# Supabase Migration Pattern

Best practices for Supabase/Postgres migrations to avoid common errors.

---

## 1. UUID Generation (Modern Postgres 13+)

**Always use `gen_random_uuid()` - built-in, no extension needed**:

```sql
-- ✅ CORRECT
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ❌ WRONG: Requires uuid-ossp extension
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4()
);
```

**Why**: Supabase uses Postgres 15+ where `gen_random_uuid()` is built-in. No `CREATE EXTENSION "uuid-ossp"` needed.

---

## 2. Foreign Key Topological Sort

**Parent tables MUST be created before children**:

```sql
-- ✅ CORRECT ORDER: Dependencies resolved
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid()
);

CREATE TABLE profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE clients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE
);

CREATE TABLE invoices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE
);

CREATE TABLE time_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_id UUID REFERENCES invoices(id) ON DELETE SET NULL
);

CREATE TABLE expenses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_id UUID REFERENCES invoices(id) ON DELETE SET NULL
);
```

**Dependency graph**:
```
users (no deps)
  ↓
profiles → users
clients → users
  ↓
projects → clients
  ↓
invoices → projects
  ↓
time_entries → invoices
expenses → invoices
```

**Common error**:
```sql
-- ❌ WRONG: Forward reference
CREATE TABLE time_entries (
  invoice_id UUID REFERENCES invoices(id)  -- Error: relation "invoices" does not exist
);

CREATE TABLE invoices (
  id UUID PRIMARY KEY
);
```

**Fix**: Create `invoices` before `time_entries`.

---

## 3. Timestamps with Timezone

**Always use `TIMESTAMPTZ` (not `TIMESTAMP`)**:

```sql
-- ✅ CORRECT
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ❌ WRONG: No timezone
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMP DEFAULT NOW()
);
```

**Why**: `TIMESTAMPTZ` stores UTC, auto-converts to user timezone. `TIMESTAMP` stores as-is (ambiguous timezone).

---

## 4. Soft Deletes with Indexes

**Add index on `deleted_at` for performance**:

```sql
CREATE TABLE documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  deleted_at TIMESTAMPTZ
);

-- Performance: Filter out soft-deleted rows efficiently
CREATE INDEX idx_documents_active ON documents(id) WHERE deleted_at IS NULL;
```

**Query pattern**:
```sql
-- Fetch active only (uses index)
SELECT * FROM documents WHERE deleted_at IS NULL;

-- Include deleted
SELECT * FROM documents;
```

---

## 5. Row Level Security (RLS)

**Enable RLS + create policies**:

```sql
-- Enable RLS
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;

-- Policy: Users see only their own documents
CREATE POLICY documents_select_own
  ON documents
  FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

-- Policy: Users insert only with their own user_id
CREATE POLICY documents_insert_own
  ON documents
  FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

-- Policy: Users update only their own documents
CREATE POLICY documents_update_own
  ON documents
  FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- Policy: Users delete only their own documents
CREATE POLICY documents_delete_own
  ON documents
  FOR DELETE
  TO authenticated
  USING (user_id = auth.uid());
```

**Common error**: Forgetting to enable RLS → all rows accessible to all users.

---

## 6. Enum Types

**Create enum types before using them**:

```sql
-- Create enum
CREATE TYPE invoice_status AS ENUM ('draft', 'sent', 'paid', 'cancelled');

-- Use in table
CREATE TABLE invoices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  status invoice_status NOT NULL DEFAULT 'draft'
);
```

**Altering enums** (add value):
```sql
ALTER TYPE invoice_status ADD VALUE 'overdue';
```

**Note**: Cannot remove enum values. Drop and recreate if needed (requires data migration).

---

## 7. Full-Text Search

**Use tsvector for search**:

```sql
CREATE TABLE articles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  search_vector TSVECTOR GENERATED ALWAYS AS (
    to_tsvector('english', title || ' ' || content)
  ) STORED
);

-- Index for fast search
CREATE INDEX idx_articles_search ON articles USING GIN(search_vector);

-- Query
SELECT * FROM articles
WHERE search_vector @@ to_tsquery('english', 'postgres & migration');
```

---

## 8. Migration File Structure

**Supabase migration naming**:
```
supabase/migrations/
  20231001120000_create_users.sql
  20231001120100_create_profiles.sql
  20231001120200_create_clients.sql
  20231001120300_create_projects.sql
  20231001120400_create_invoices.sql
  20231001120500_create_time_entries.sql
```

**File format**: `YYYYMMDDHHMMSS_description.sql`

**Each file should**:
- Be idempotent (can run multiple times safely)
- Have rollback script if needed
- Follow dependency order

---

## Quick Reference Checklist

```
Migration pre-flight:
  - [ ] Use gen_random_uuid() not uuid_generate_v4()
  - [ ] Parent tables created before children (topological sort)
  - [ ] TIMESTAMPTZ not TIMESTAMP
  - [ ] RLS enabled on tables with user data
  - [ ] Indexes on foreign keys
  - [ ] Indexes on deleted_at for soft deletes
  - [ ] tsvector indexes for search columns
```
