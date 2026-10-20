# Legal Data Modeling & PostgreSQL LTREE Architecture

> **Module**: M05 (Architecture & Technical Specs) & M08 (Data Seeding & Migration)  
> **Source**: Adapted from published Indonesian open-law engineering schemas.  
> **Objective**: Efficiently query deep hierarchical statutory structures and maintain tamper-proof, append-only revision trails in PostgreSQL.

---

## 1. Modeling Deep Legal Hierarchies with PostgreSQL `LTREE`

Indonesian legislation is organized in deep nested trees:
`Book ──► Chapter (Bab) ──► Section (Bagian) ──► Paragraph (Paragraf) ──► Article (Pasal) ──► Clause (Ayat) ──► Explanation (Penjelasan)`

Traditional relational `parent_id` models require slow, recursive Common Table Expressions (CTEs) to fetch a chapter. The optimal production pattern leverages the PostgreSQL **`LTREE`** extension.

### Schema Definition:
```sql
CREATE EXTENSION IF NOT EXISTS ltree;

CREATE TABLE document_nodes (
    id SERIAL PRIMARY KEY,
    work_id INTEGER NOT NULL REFERENCES works(id) ON DELETE CASCADE,
    node_type VARCHAR(20) NOT NULL CHECK (
        node_type IN ('buku', 'bab', 'bagian', 'paragraf', 'pasal', 'ayat', 'penjelasan_umum', 'penjelasan_pasal')
    ),
    number VARCHAR(50),                     -- e.g., '156' for Pasal 156
    heading TEXT,                           -- e.g., 'BAB IV: Pemutusan Hubungan Kerja'
    content_text TEXT,                      -- Verbatim statutory provision
    parent_id INTEGER REFERENCES document_nodes(id),
    path LTREE NOT NULL,                    -- Materialized path: e.g. 'root.bab_4.pasal_156.ayat_2'
    depth INTEGER NOT NULL DEFAULT 0,
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Fast hierarchical retrieval using GIST indexes
CREATE INDEX idx_document_nodes_path ON document_nodes USING GIST(path);
CREATE INDEX idx_document_nodes_work ON document_nodes(work_id);
```

### High-Performance Hierarchical Query:
To fetch all articles and clauses under Chapter IV in a single fast query:
```sql
SELECT node_type, number, content_text 
FROM document_nodes 
WHERE path <@ 'root.bab_4' 
ORDER BY sort_order ASC;
```

---

## 2. The Append-Only Legal Revision Trail (`apply_revision`)

Legal and compliance platforms must guarantee data integrity. Direct `UPDATE` statements on statutory provisions are strictly forbidden. All modifications must execute via an **atomic, append-only revision procedure**.

### PostgreSQL Stored Function:
```sql
CREATE OR REPLACE FUNCTION apply_revision(
    p_node_id INTEGER,
    p_work_id INTEGER,
    p_new_content TEXT,
    p_revision_type VARCHAR(30),
    p_reason TEXT,
    p_actor_type VARCHAR(20) DEFAULT 'system',
    p_created_by UUID DEFAULT NULL
) RETURNS BIGINT
LANGUAGE plpgsql
AS $$
DECLARE
    v_old_content TEXT;
    v_node_type VARCHAR(20);
    v_node_number VARCHAR(50);
    v_node_path LTREE;
    v_revision_id BIGINT;
BEGIN
    -- 1. Snapshot existing verified content
    SELECT content_text, node_type, number, path
    INTO v_old_content, v_node_type, v_node_number, v_node_path
    FROM document_nodes
    WHERE id = p_node_id AND work_id = p_work_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Node % not found in regulation %', p_node_id, p_work_id;
    END IF;

    -- 2. Insert immutable audit record
    INSERT INTO revisions (
        work_id, node_id, node_type, node_number, node_path,
        old_content, new_content, revision_type, reason,
        actor_type, created_by
    ) VALUES (
        p_work_id, p_node_id, v_node_type, v_node_number, v_node_path,
        v_old_content, p_new_content, p_revision_type, p_reason,
        p_actor_type, p_created_by
    ) RETURNING id INTO v_revision_id;

    -- 3. Update current active node text and link revision pointer
    UPDATE document_nodes
    SET content_text = p_new_content,
        revision_id = v_revision_id
    WHERE id = p_node_id;

    RETURN v_revision_id;
END;
$$;
```

---

## 3. The 3-Layer Legal Search Fast-Path

Full-text search on legal documents must handle exact legislative citations instantly before falling back to full semantic search:

1. **Layer 1: Identity Fast-Path (Regex Engine)**:
   - Intercept inputs matching patterns like `"Pasal [0-9]+"`, `"UU [0-9]+/[0-9]+"`. Bypass AI embeddings or fuzzy FTS and directly return exact node records with score 1000.
2. **Layer 2: Works Full-Text Search (Title & Subject)**:
   - Match regulation titles using PostgreSQL `to_tsvector('indonesian', title)`.
3. **Layer 3: Content Fallback with Indonesian Stemmer**:
   - Query article text using 3-tier cascade:
     `websearch_to_tsquery('indonesian', query) ──► plainto_tsquery ──► ILIKE %query%`
