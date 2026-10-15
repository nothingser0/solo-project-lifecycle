# Module 08: Data Migration & Seeding

> **Templates to copy**: `templates/05-data-migration/DATA_MIGRATION_LITE.md` · `DATA_MIGRATION_PLAN_TEMPLATE.md`
> 📖 **Optional** (do NOT preload): `references/technical/DATA_ASSETS_MANAGEMENT.md` · deep dive `deep-dives/08_DATA_MIGRATION_SEEDING.md` (audit examples, mapping matrix, ETL details, reconciliation).

Transfers client legacy data (CSV/Excel/SQL) into the new FSD schema — **Staging only, PII masked** — before UAT in Module 09. Production import happens in M10 (ETL re-run, staging dump, or manual CSV).

**Inputs**: client raw data (CSV/Excel/SQL) + `FSD.md` database schema.

## Steps

1. **Source data audit** — Inspect structure, date/number formats, FK integrity.
   **Clean-In / Clean-Out**: the **client owns data hygiene**. The developer only writes automated ETL. Manual cleaning of client rows (dedup, cell repair, orphan fixes) = **separate Change Request (CR)**, never free work.
2. **Column mapping matrix** — Map every legacy column → target column (types, defaults, date/Rupiah/enum transforms) into `docs/pm/DATA_MIGRATION_PLAN.md` via `templates/05-data-migration/DATA_MIGRATION_PLAN_TEMPLATE.md`. Get client agreement on this document before writing the ETL.
3. **Mask PII on staging** — NIK, personal phone numbers, and legacy passwords must be masked/faked before any non-production load, per **UU PDP No. 27/2022**. **Production dumps are NEVER restored to staging unmasked.**
4. **ETL script & Dry-Run Mode** — Extract (stream parser: `csv-parse`/`exceljs`) → Transform (Zod validation, UUIDv7 PKs, Argon2id for temp passwords) → Load (batch insert 500–1,000 rows inside one atomic transaction).
   - **Mandatory Dry-Run Pre-Flight**: ETL scripts MUST support a `--dry-run` flag that validates schemas, FK constraints, and type parsers without committing transactions to the database.
   - **Rollback Safety & Point-in-Time Snapshot**: A clean database snapshot MUST be taken immediately prior to migration execution to allow instant single-command rollback (`DROP/RESTORE`) if migration integrity fails.
   - A bad row goes to `rejected-rows.csv` with its row number and error reason — **never abort the whole run**.
5. **Reconcile** — Count `N_source` / `N_imported` / `N_rejected`; they must add up. Deliver `rejected-rows.csv` to the client's operations team to fix and resubmit.
6. **Report & sign-off** — Produce `docs/pm/MIGRATION_RECONCILIATION_REPORT.md` via `templates/05-data-migration/RECONCILIATION_REPORT_TEMPLATE.md`; demonstrate sanitized staging data (real shape, masked PII — not Lorem Ipsum) and obtain the client Single PIC **Data Sign-Off**.

**Scale routing (one line)**: Small = M08 waived, seed data only · Greenfield (any scale, no legacy data) = M08 waived · Medium/Large with legacy data = full M08 below (legacy data from a Small client escalates to Large); Enterprise → Series A Phase A02 (Data Governance).

## Outputs

1. `docs/pm/DATA_MIGRATION_PLAN.md` (or `docs/pm/DATA_MIGRATION_LITE.md` for lightweight SMB migrations)
2. `docs/pm/MIGRATION_RECONCILIATION_REPORT.md`
3. Staging database populated with masked data, ready for UAT.

⚠️ Production import is **not** done here — it happens in Module 10.

## Gate exit criteria [GATE]

M08 is **PASS** when all of the following hold:

- [ ] Column mapping (`docs/pm/DATA_MIGRATION_PLAN.md` or `DATA_MIGRATION_LITE.md`) agreed with the client.
- [ ] Pre-flight `--dry-run` passed with zero schema/constraint violations; pre-migration snapshot created.
- [ ] ETL ran with **no foreign key integrity errors**.
- [ ] PII masked on staging (UU PDP compliant).
- [ ] `rejected-rows.csv` produced and handed over to the client.
- [ ] Client Single PIC signed the reconciliation sign-off.

**Verify, verbatim:**

```bash
./scripts/gates/validate-gate.sh M08
```

(PowerShell equivalent: `./scripts/gates/validate-gate.ps1 M08`.)

**Sign-off wait**: After the gate passes, wait for the client's Data Sign-Off before starting Module 09 (UAT); the sign-off is the acceptance evidence M09's gate checks.
