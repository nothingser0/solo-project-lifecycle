# Module 08 Deep Dive: Data Migration & Seeding — Step-by-Step Execution

> Companion to `docs/modules/08-data-migration-seeding.md` (runbook). This file holds the detailed execution steps; the runbook keeps a condensed summary.

## Step 1: Source Data Audit
1. Request the client to provide data in a structured digital format (CSV, Excel `.xlsx`, or SQL Dump).
2. Check data type consistency:
   - Date formats (whether `YYYY-MM-DD`, `DD/MM/YYYY`, or arbitrary text).
   - Financial number formats (whether containing `Rp` currency symbols, dots, or commas).
   - Relational ID integrity (whether foreign keys point to records that actually exist).

## Step 2: Migration Plan Document Preparation (Mapping Matrix)
Draft a mapping table from the legacy format to the new FSD schema:
- Example: Excel column `"Nama Lengkap"` → SQL column `users.full_name` (`VARCHAR(150)`).
- Example: Excel column `"Tgl Lahir"` → Transformation `new Date(row.tgl)` → `users.birth_date` (`DATE`).

## Step 3: Writing the Automated ETL Script (Batch Loading)
Write a standalone execution script (e.g., `scripts/runtime/migrate-data.ts` or a Python script):
1. **Extract**: Read source files using a stream parser (`csv-parse` or `exceljs`).
2. **Transform**: Validate each row with Zod. Generate UUIDv7 for new primary keys. Hash temporary passwords using Argon2id.
3. **Load**: Insert data into the database using *Batch Insert* operations (`createMany` or SQL `COPY`) in blocks of 500–1,000 rows within an atomic transaction (`db.$transaction`).

## Step 4: Reconciliation & Rejected Row Handling
1. The script calculates:
   - Total rows in source file: N_source
   - Total rows successfully imported: N_imported
   - Total failed/corrupt rows: N_rejected
2. All failed rows are automatically exported to `rejected-rows.csv` complete with row numbers and validation error messages.
3. Deliver the `rejected-rows.csv` file to the Client for their operations team to correct.

## Step 5: Data Sign-Off with Client
1. Demonstrate the Staging dashboard which now displays the client's sanitized production-shaped data (PII masked per Step 3, not "Lorem Ipsum" dummy data).
2. Send the **`MIGRATION_RECONCILIATION_REPORT.md`** document to the Client's Single PIC.
3. Client signs the data approval sheet (*Data Sign-Off*).

---
## Appendix: Project Scale Adaptation (moved from runbook)

| Data Migration Aspect | 🔵 Small (Fast-Track MVP) | 🟢 Medium (B2B SaaS / Agency) | 🟡 Large (Legacy Data Migration) | 🔴 Enterprise (Non-Solo) |
| :--- | :--- | :--- | :--- | :--- |
| **M08 Status** | **WAIVED** (initial seeding only) | Conditional (mandatory if client has legacy data) | Fully mandatory (`DATA_MIGRATION_PLAN.md` & reconciliation) | Routed to Series A (Phase A02 Data Governance) |
| **Data Volume** | Zero legacy data (dummy seed only) | 1,000–100,000 client rows | >100,000 rows / inherited database | Corporate ERP (client data engineers manage) |
| **Source Format** | N/A (app code seeder) | Structured Excel / CSV | Old relational DB, SQL dump, multi-table | Core legacy systems / distributed warehouses |
| **Execution Method** | `prisma db seed` / `npm run seed` | Structured ETL script with batching & logging | Modular ETL pipeline with dry-run & rollback schema | Data migration governance & reconciliation framework |
| **PII Sanitization** | N/A (pure synthetic data) | Auto masking script for NIK, phone no., email | UU PDP No. 27/2022 anonymization engine | Corporate privacy audit & data processing contract |
| **Sign-Off Document** | Waived | `MIGRATION_RECONCILIATION_REPORT.md` sheet signed | Official Data Reconciliation Act (BAST Data) | Migration audit recommendation & data committee sign-off |

**Guardrails**: 1) Small projects never handle client legacy data — such projects auto-escalate to Large per the high-water mark (`SKILL.md:156`). 2) Client production dumps containing PII are strictly forbidden from being restored directly to Staging/local without masking first (UU PDP No. 27/2022 Art. 35). 3) Solo developers must not migrate enterprise systems alone — route to Series A Advisory (A02 Data Architecture & Governance).

---
## Appendix: Gate Step 0 — File Existence Verification (moved from runbook)

Blocking check BEFORE content validation:
1. Check `docs/pm/MIGRATION_RECONCILIATION_REPORT.md` exists (PowerShell: `Test-Path -LiteralPath "docs/pm/MIGRATION_RECONCILIATION_REPORT.md"` → `True`, or read the file successfully).
2. **If it does not exist**: STOP immediately — no content validation, no summary, no Module 09 confirmation request. Report to user:
   ```
   CRITICAL ERROR: File MIGRATION_RECONCILIATION_REPORT.md was not created.
   Module 08 FAILED - cannot proceed to Module 09 (UAT).
   Possible causes: write permission denied on docs/pm/, path typo, disk full.
   ```
   END TURN and wait for the user to fix it.
3. Only if it exists, proceed to content validation: verify row counts match, PII is sanitized on staging, and the client Data Sign-Off is received; present the reconciliation summary (imported vs rejected counts), then STOP-and-wait for sign-off.
