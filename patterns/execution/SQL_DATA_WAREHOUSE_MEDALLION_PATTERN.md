# Baraa SQL Data Warehouse & Medallion Architecture Pattern

> **Module**: M05 (Architecture & Specs), M06 (Development Execution), & M08 (Data Migration & Seeding)  
> **Source**: Adapted from Baraa Khatib Salkini's SQL Data Warehouse project (`DataWithBaraa/sql-data-warehouse-project`).  
> **Scope**: Modern enterprise data warehousing using SQL Server structured around the Medallion Architecture (Bronze, Silver, Gold) with clear ETL procedures, data cleansing, and star-schema analytical reporting.

---

## 1. Medallion Architecture Layers
1. **Bronze Layer (`/bronze`)**: Raw data ingestion exactly as-is from source systems (ERP and CRM CSV files) into staging tables.
2. **Silver Layer (`/silver`)**: Data cleansing, standardization, null handling, deduplication, and data type normalization.
3. **Gold Layer (`/gold`)**: Business-ready analytical models structured into optimized star schemas (fact and dimension tables) for reporting.

---

## 2. Quality Assurance & Testing (`/tests`)
- Pre-load and post-load validation scripts checking duplicate keys, orphan foreign keys, invalid date ranges, and negative pricing anomalies before exposing gold tables to BI dashboards.

---

## 3. Naming Convention & Gold-Layer Star Schema

The layers above tell you *where* data lives. This section tells you what the objects are **called** and what shape the gold tables must take.

### 3.0 Naming convention (state it once, then check it)

| Object | Pattern | Example |
| :--- | :--- | :--- |
| Bronze / Silver table | `<sourcesystem>_<entity>` — the source table name, **not renamed** | `crm_customer_info` |
| Dimension | `<category>_<entity>`, business-aligned | `gold.dim_customers` |
| Fact | `<category>_<entity>` | `gold.fact_sales` |
| Report / aggregate | `report_<entity>` | `report_sales_monthly` |
| Dimension surrogate key | `<entity>_key` | `customer_key` |
| Source identifier, preserved | `<entity>_id` / `_number` | `customer_id`, `customer_number` |
| System-generated metadata | `dwh_<column>` | `dwh_create_date` |
| Load procedure per layer | `load_<layer>` | `load_bronze` |

All names are **snake_case**, in English, and never a SQL reserved word.

**Why bronze/silver keep the source name**: at those layers the table *is* the source table. Renaming it there destroys the ability to trace a column back to the system that produced it. Renaming happens once, at gold, where the name becomes business-aligned.

**Why the `_key` / `_id` pair is the rule and not decoration**: seeing both on a dimension tells the reader that one is the warehouse's stable identity and the other is the source's — which is the whole point of §3.1.2.

The catalog that ships with these tables carries **type and description per column**. A column list without descriptions is a schema dump, not a catalog.

### 3.1 The four star-schema rules

Each prevents a specific way two reports end up disagreeing.

### 3.1.1 Write the fact table's grain in one sentence

Before creating a fact table, write down what **one row represents**:

> *"One row per order line, per order, per day."*

If that sentence needs an "and" you cannot defend, you have two fact tables. Ambiguous grain produces double-counted revenue that looks correct in every individual query — this is the single most expensive modelling mistake, because it survives to the dashboard.

### 3.1.2 Every dimension gets a surrogate key

The dimension has both `customer_key` (surrogate, warehouse-generated) and `customer_id` (natural, from the source system). Joins and facts use the **surrogate**.

**Why the natural key is not enough**: source systems reuse identifiers. A deleted customer's `customer_id` can be reassigned to a new customer, and every historical fact that joined on the natural key now points at the wrong person. The surrogate key is stable for the life of the row.

### 3.1.3 A pre-built date dimension, not `date_trunc` per query

Build one `dim_date` with the columns reporting actually needs: date, day, week, month, quarter, year, fiscal period, is-weekend, is-holiday.

**Why**: if every report computes its own month boundary, two reports will eventually disagree about which day belongs to which month — usually because one used `date_trunc` in local time and the other in UTC. One shared date dimension means one answer.

### 3.1.4 Record SCD Type per dimension

| Type | Behaviour | Consequence downstream |
| :--- | :--- | :--- |
| **Type 1** | Overwrite the attribute in place | History is lost — the report shows today's attribute for yesterday's fact |
| **Type 2** | Add a new row per change, with `start_date` / `end_date` / `is_current` | History preserved, **but row counts now count versions, not entities** |

**The rule that matters**: every downstream count must state whether it counts entities or versions. `SELECT COUNT(*) FROM dim_products` under Type 2 returns the number of product *versions*, which is not the number of products — and it is the count someone will put in a client report.

Declare the type per dimension in the data catalog, not in someone's memory. `dim_products` carrying `start_date` is a Type 2 dimension; a reader has to be told that before they write a count.