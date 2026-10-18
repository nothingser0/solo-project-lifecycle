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
