# Altimate AI Data Engineering & dbt/Snowflake Analytics Engineering Pattern

> **Module**: M05 (Architecture & Specs), M06 (Development Execution), & M08 (Data Migration & Seeding)  
> **Source**: Adapted from Altimate AI Data Engineering Skills (`AltimateAI/data-engineering-skills`).  
> **Scope**: Standardized analytics engineering workflows for dbt modeling, incremental strategies, column-role testing, model documentation, downstream-impact refactoring, SQL-to-dbt migration, and Snowflake query optimization.

---

## 1. dbt Engineering Core Workflows

### A. Model Development (`creating-dbt-models`)
- **Convention Discovery**: Inspect existing staging, intermediate, and mart layers before writing new models.
- **Iterative Build**: Write model SQL $\to$ Run `dbt build` / `dbt show` $\to$ Verify column types and output structure against constraints.

### B. Incremental Modeling (`developing-incremental-models`)
- **Strategy Selection**: Choose between `append`, `delete+insert`, or `merge` based on source updates.
- **Unique Key Design**: Always define explicit `unique_key` and handle late-arriving data / idempotency.
- **Default to `table`, not `incremental`.** Below roughly 10M source rows, a full rebuild is simpler and a full refresh is fast; incremental adds a class of bugs (duplicate keys, missed late data, schema drift) that a small dataset does not need.
- **Always test with `--full-refresh` first**, and confirm `unique_key` is genuinely unique in both source and target. A merge that fails three times is almost always a duplicate key, not a transient error.

### C. Testing Models (`testing-dbt-models`)
Test by column role, not by preference. Match the project's existing `schema.yml` style before adding anything.

| Column role | Minimum tests |
| :--- | :--- |
| Primary key | `unique`, `not_null` |
| Foreign key | `not_null`, `relationships` |
| Categorical / status | `accepted_values` — ask for the valid set, never assume it |
| Required field, date/timestamp | `not_null` |

**A model with no tests is not finished**, regardless of whether it builds. The test is what tells you the next upstream change did not break it.

### D. Documenting Models (`documenting-dbt-models`)
Every model and every tested column carries a `description` in `schema.yml`. A column whose meaning lives only in someone's memory is the first thing the next engineer misreads — and on an analytics project, a misread column becomes a wrong number in a client report.

---

### E. Refactoring & Downstream Impact (`refactoring-dbt-models`)

A passing `dbt build` says nothing about the BI dashboard that reads the old column name. Before any rename or drop:

1. **Enumerate the dependents.** Grep every consumer for `<model>.<column>` — downstream models, exposures, dashboards, and any service querying the warehouse directly.
2. **Enumerate the columns each consumer uses.** A dependent that only reads three columns is not blocked by a change to the fourth.
3. **A now-unreferenced column is removable only after one release cycle** at zero references. "Nobody uses it" is a belief until you have looked.
4. **Prove output equality after the change** — row counts and sums against the pre-change query, not just a green test suite.

> **Why this is a separate step**: dbt's lineage covers models, not the SQL inside a dashboard. The consumer most likely to break is the one dbt cannot see.

### F. Migrating SQL to dbt (`migrating-sql-to-dbt`)

Convert in layers, and build each layer before starting the next:

| Layer | What goes in it | Rule |
| :--- | :--- | :--- |
| **Staging** | One model per source table, 1:1 with it | Rename and cast only. No joins, no business logic |
| **Intermediate** | Business logic, joins, aggregation | Still not the final shape |
| **Mart** | The shape a consumer queries | One mart per use case |

**Validate each layer with numbers, not with "it compiles":** row count and sum of every measure against the legacy query, layer by layer. A staging model that already returns different row counts means the extraction is wrong, and every layer above it inherits the error.

---

## 2. Snowflake Performance Tuning

### A. Expensive Query Triage (`finding-expensive-queries`)
- Rank queries by cost, execution time, and bytes scanned using warehouse query history.

### B. Query Optimization (`optimizing-query-text`)
- **Profile Analysis**: Identify table scans, redundant joins, and unindexed filtering bottlenecks.
- **Semantic Preservation**: Ensure query restructuring preserves exact business logic output while reducing resource consumption.
