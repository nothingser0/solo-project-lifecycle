# Altimate AI Data Engineering & dbt/Snowflake Analytics Engineering Pattern

> **Module**: M05 (Architecture & Specs), M06 (Development Execution), & M08 (Data Migration & Seeding)  
> **Source**: Adapted from Altimate AI Data Engineering Skills (`AltimateAI/data-engineering-skills`).  
> **Scope**: Standardized analytics engineering workflows for dbt modeling, schema testing, debugging, incremental model strategies, and Snowflake query optimization.

---

## 1. dbt Engineering Core Workflows

### A. Model Development (`creating-dbt-models`)
- **Convention Discovery**: Inspect existing staging, intermediate, and mart layers before writing new models.
- **Iterative Build**: Write model SQL $\to$ Run `dbt build` / `dbt show` $\to$ Verify column types and output structure against constraints.

### B. Incremental Modeling (`developing-incremental-models`)
- **Strategy Selection**: Choose between `append`, `delete+insert`, or `merge` based on source updates.
- **Unique Key Design**: Always define explicit `unique_key` and handle late-arriving data / idempotency.

---

## 2. Snowflake Performance Tuning

### A. Expensive Query Triage (`finding-expensive-queries`)
- Rank queries by cost, execution time, and bytes scanned using warehouse query history.

### B. Query Optimization (`optimizing-query-text`)
- **Profile Analysis**: Identify table scans, redundant joins, and unindexed filtering bottlenecks.
- **Semantic Preservation**: Ensure query restructuring preserves exact business logic output while reducing resource consumption.
