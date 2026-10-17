# Database Schema & Query Optimization Pattern

> **Module**: M05 (Architecture & Specs), M06 (Development Execution), & M07 (Quality Assurance / Performance Audit)  
> **Source**: Adapted from `planetscale/database-skills` (Vitess & PostgreSQL/MySQL production standards).  
> **Scope**: Authoritative engineering rules for resilient relational database schema design, B-Tree index optimization, foreign key indexing, SARGable queries, and N+1 prevention.

---

## 1. Schema Design Standards (PostgreSQL & MySQL)

Relational database schemas must be engineered for write scalability, query predictability, and index locality.

### 1.1 Primary Key Discipline (Anti-UUIDv4 Fragmentation)
* **Default Standard**: Use narrow, monotonic IDs:
  ```sql
  -- PostgreSQL
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY
  -- MySQL / InnoDB
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY
  ```
* ❌ **Prohibited Antipattern**: Using random UUIDv4 (`gen_random_uuid()`) as the primary clustered key. Random UUIDs cause random page insertion, catastrophic B-Tree index fragmentation, and massive write amplification.
* **When UUIDs Are Required**: If external-facing, non-enumerable IDs are necessary, use **`UUIDv7`** (time-ordered, monotonic) or store a random UUID in a secondary unique column while retaining a `BIGINT` clustered primary key.

### 1.2 Foreign Key (FK) Indexing Mandate
> **PostgreSQL and MySQL DO NOT automatically create indexes on foreign key columns.** Every foreign key column (`*_id`) that participates in `JOIN`, `WHERE`, or `ON DELETE CASCADE` operations **MUST** have an explicit index.

```sql
CREATE TABLE order_item (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES order_header(id) ON DELETE CASCADE,
    product_id BIGINT NOT NULL REFERENCES product(id),
    quantity INTEGER NOT NULL CHECK (quantity > 0)
);

-- MANDATORY: Explicit FK Indexes
CREATE INDEX order_item_order_id_idx ON order_item (order_id);
CREATE INDEX order_item_product_id_idx ON order_item (product_id);
```

### 1.3 Data Types & Naming Conventions
* **Timestamps**: Always use `TIMESTAMPTZ` (PostgreSQL) or `DATETIME` (MySQL). Never use unqualified `TIMESTAMP` without timezone.
* **Status Fields**: Prefer `TEXT` with a `CHECK` constraint over native database `ENUM` types. `CHECK` constraints can be modified and extended without complex migration locks.
* **Naming Standard**: Use singular `snake_case` for table and column names (`user_account`, `order_item`, `created_at`).

---

## 2. Indexing Rules & Query Optimization

### 2.1 The Composite Index Rule (Equality First, Range Second)
Order composite index columns strictly according to the **Leftmost Prefix Rule**:
1. **Equality columns first** (`WHERE status = 'paid'`).
2. **Range / Sort columns last** (`AND created_at >= '2026-01-01' ORDER BY created_at DESC`).
```sql
-- Supports queries with status = 'active' AND created_at > ...
CREATE INDEX invoice_status_created_idx ON invoice (status, created_at);
```

### 2.2 SARGable Queries (Search Argument Able)
Never wrap indexed columns inside database functions in the `WHERE` clause. Functions prevent B-Tree index scans and trigger costly full table scans.
```sql
-- ❌ BAD: Non-SARGable (triggers Seq Scan)
SELECT id, total FROM invoice WHERE date_trunc('month', created_at) = '2026-10-01';

-- ✅ GOOD: SARGable (triggers Index Scan)
SELECT id, total FROM invoice 
WHERE created_at >= '2026-10-01 00:00:00Z' AND created_at < '2026-11-01 00:00:00Z';
```

### 2.3 Keyset / Cursor Pagination (Anti-Deep OFFSET)
Never use high `OFFSET` values on large collections. `OFFSET 10000` scans and discards 10,000 rows. Use Keyset pagination anchored on `(created_at, id)`:
```sql
-- ✅ GOOD: Constant-time Keyset Cursor Pagination
SELECT id, title, created_at 
FROM article 
WHERE (created_at, id) < ('2026-10-15T12:00:00Z', 987654)
ORDER BY created_at DESC, id DESC 
LIMIT 20;
```

---

## 3. Query Execution & N+1 Prevention

### 3.1 N+1 Query Elimination in Application Code
Never fire queries inside application loops (`for / forEach`):
```typescript
// ❌ BAD: N+1 queries fired to DB
for (const user of users) {
  const posts = await db.query('SELECT * FROM post WHERE user_id = $1', [user.id]);
}

// ✅ GOOD: Single batch query with ANY / IN
const userIds = users.map((u) => u.id);
const allPosts = await db.query('SELECT * FROM post WHERE user_id = ANY($1)', [userIds]);
```

### 3.2 Selective Projection & Deduplication
* **Never use `SELECT *` in production APIs**: Specify exact required columns (`SELECT id, name, email`) to reduce network payload and enable index-only covering scans.
* **Prefer `UNION ALL` over `UNION`**: `UNION` incurs an expensive sorting/hashing pass to deduplicate rows. Use `UNION ALL` when sets are known to be disjoint.

---

## 4. Pre-Merge Database Audit Checklist (M07 QA Gate)

- [ ] Every foreign key column has a corresponding `CREATE INDEX` statement.
- [ ] Primary keys use `BIGINT` or `UUIDv7` (zero random UUIDv4 clustered PKs).
- [ ] No `SELECT *` in high-throughput production query paths.
- [ ] High-volume paginated endpoints ($>1,000$ records) use cursor-based pagination.
- [ ] `EXPLAIN ANALYZE` confirms zero accidental `Seq Scan` on large tables ($>10,000$ rows).
