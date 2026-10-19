# Patterns Devkit Component-Based Data Graphs & SDK Pattern

> **Module**: M05 (Architecture & Specs) & M06 (Development Execution)  
> **Source**: Adapted from Patterns Devkit (`patterns-app/patterns-devkit`).  
> **Scope**: Building modular, versioned data pipelines and graphs from reusable Python and SQL components connected via `graph.yml` and platform SDK primitives (`Table`, `Parameter`, `State`).

---

## 1. Graph Structure & Component Architecture
1. **`graph.yml`**: Central orchestrator defining pipeline nodes, inputs, outputs, and table linkages.
2. **Reusable Python & SQL Nodes**: Stateless or stateful processing units reading and writing through typed table handles (`patterns.Table`).
3. **SDK Primitives**:
   - `Table(name, mode="r"|"w")`: Typed data handle supporting `.init()`, `.read()`, `.append()`, `.upsert()`, and `.replace()`.
   - `Parameter(name, type, default)`: Strongly typed pipeline configuration parameters.
   - `State`: Persistent execution state across graph runs.

---

## 2. CLI Operations & Deployment
- Rapid component creation (`patterns create node`), secret management (`patterns create secret`), and cloud synchronization (`patterns upload`).

---

## 3. Write-Table Discipline (the four rules that prevent a re-run from corrupting data)

The API list above says what the methods are. These say what to do with them, and each one prevents a specific failure that only appears on the second run.

### 3.1 Declare the schema explicitly on every write table

`Table.init(schema=..., unique_on=...)` rather than letting the first record infer it.

**Why**: an inferred schema is whatever the first batch happened to contain. The day a nullable column arrives null-and-first, the type becomes nullable forever, or a numeric field becomes a string because one record had `"N/A"`. Declaring types at init makes the pipeline reject bad data instead of absorbing it into the schema.

### 3.2 `unique_on` plus `upsert`, never `append`, for anything that can be re-run

Declare the business key and write with `upsert`.

**Why**: `append` on a re-run duplicates every row. This is the single most common data-pipeline defect and it is invisible until someone sums a column twice. `unique_on` makes the deduplication a property of the table, not of the code that writes to it — so a future node cannot forget.

### 3.3 Add `add_created` or `add_monotonic_id`

**Why**: without a load timestamp or a monotonic id, downstream nodes cannot tell *when* a row arrived, so incremental processing has to re-read everything or guess. This is what makes "only process new rows" possible at all.

### 3.4 Keep nodes small, composable, and parameterized

A node that does ingestion *and* transformation *and* scoring cannot be reused, tested in isolation, or partially re-run after a failure.

**The test**: can this node be described in one sentence with one input and one output? If it needs "and", it is two nodes.

---

## 4. Re-run Safety Check

Before shipping any node, answer:

- [ ] Does a second run of this graph produce the same tables as the first? (If not: §3.2)
- [ ] Is the write table's schema declared, or inferred from the first batch? (§3.1)
- [ ] Can a downstream node tell which rows are new? (§3.3)
- [ ] Does every write path have a declared unique key, or a documented reason it needs none?