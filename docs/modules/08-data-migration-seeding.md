# Module 08: Data Migration & Seeding (Legacy Data Migration & Data Seeding)

> - `references/technical/DATA_ASSETS_MANAGEMENT.md` (Seed data structure, Reference data (city/bank list), Versioning regulations data, Content data management)
> - `templates/05-data-migration/DATA_MIGRATION_LITE.md` (Lightweight migration protocol for simple CSV/Excel imports)

This module is the eighth phase in the software project lifecycle for solo developers. Its purpose is to transfer client legacy data (from Excel, CSV, legacy systems, or outdated databases) into the new database schema automatically, encrypted, and validated before the user acceptance testing (UAT) session in Module 09 begins.

---

## 1. Execution Cycle of Module 08

```text
[ INPUT: Client Raw Data (CSV/Excel/SQL) & FSD.md Database Schema ]
                                    │
                                    ▼
[ STEP 1: Source Data Audit & Demarcation of Responsibility ]
  • Clean-In / Clean-Out Rule: Client is responsible for data hygiene
  • Developer ONLY writes automated transformation scripts (ETL)
                                    │
                                    ▼
[ STEP 2: Column Mapping Matrix Formulation (Data Mapping) ]
  • Source Column Mapping ──► New Database Column (Data Types, Default Values)
  • Entity Relation Normalization & Format Transformation (Date, Rupiah, Enum)
                                    │
                                    ▼
[ STEP 3: Masking & Sanitization of Staging Sensitive Data (PDP Law) ]
  • PII Data Masking (NIK/National ID, Bank Account Number, Legacy Passwords) on Staging Server
  • Prevention of Real Personal Data Leakage to Non-Production Environments
                                    │
                                    ▼
[ STEP 4: Execution of Atomic Transaction-Based ETL Script (Batch Load) ]
  • Extract (Parse file) ──► Transform (Zod Validation) ──► Load (Batch Insert)
  • Wrapped in Database Transaction Blocks (Automatic Rollback on Error)
                                    │
                                    ▼
[ STEP 5: Data Reconciliation & Client Sign-Off ]
  • Source Rows vs Imported Rows Calculation (100% Match)
  • Preparation of MIGRATION_RECONCILIATION_REPORT.md Document
  • Client Single PIC Signs Data Sign-Off Approval
                                    │
                                    ▼
[ OUTPUT: Staging Database Populated with Real Data (PII Masked) & RECONCILIATION_REPORT.md ]

⚠️ IMPORTANT: This module only imports data into Staging. 
Data migration to Production is performed separately in Module 10 (3 options: ETL re-run, staging dump, or manual CSV).
                                    │
                                    ▼
──► Ready to Proceed to Module 09: UAT & Client Sign-Off
```

---

## 2. Solo Developer Migration Principles: "Clean-In, Clean-Out"

One of the biggest time-sink traps for solo developers without getting paid is **"Manually Cleaning Broken Client Data"**.

### Standard Rules for Solo Dev Protection:
1. **Client Owns Data Hygiene**:
   - The client is required to submit data that is already clean from invalid duplicates, corrupted cell formats, or unidentified orphan records.
   - If the client requests the developer to clean thousands of spreadsheet rows manually, that work **MUST be scoped under a separate data consulting Change Request (CR)**.
2. **Schema Validation Without Exception**:
   - The migration script must validate every row using Zod/Pydantic schemas.
   - If a row is corrupted, the script automatically rejects it into a `rejected-rows.csv` dump file with an error reason description, without aborting the entire process.
3. **Data Privacy Compliance (UU PDP No. 27/2022 / Personal Data Protection Law)**:
   - In the **Staging** environment, sensitive personal data (NIK / national ID, personal phone numbers, legacy passwords) must be masked / faked.
   - **Production**: Real unmasked data is only imported during the final migration in Module 10 (3 options: ETL re-run, staging dump, or manual CSV).

---

## 3. Step-by-Step Execution

### Step 1: Source Data Audit
1. Request the client to provide data in a structured digital format (CSV, Excel `.xlsx`, or SQL Dump).
2. Check data type consistency:
   - Date formats (whether `YYYY-MM-DD`, `DD/MM/YYYY`, or arbitrary text).
   - Financial number formats (whether containing `Rp` currency symbols, dots, or commas).
   - Relational ID integrity (whether foreign keys point to records that actually exist).

### Step 2: Migration Plan Document Preparation (Mapping Matrix)
Draft a mapping table from the legacy format to the new FSD schema:
- Example: Excel column `"Nama Lengkap"` → SQL column `users.full_name` (`VARCHAR(150)`).
- Example: Excel column `"Tgl Lahir"` → Transformation `new Date(row.tgl)` → `users.birth_date` (`DATE`).

### Step 3: Writing the Automated ETL Script (Batch Loading)
Write a standalone execution script (e.g., `scripts/runtime/migrate-data.ts` or a Python script):
1. **Extract**: Read source files using a stream parser (`csv-parse` or `exceljs`).
2. **Transform**: Validate each row with Zod. Generate UUIDv7 for new primary keys. Hash temporary passwords using Argon2id.
3. **Load**: Insert data into the database using *Batch Insert* operations (`createMany` or SQL `COPY`) in blocks of 500–1,000 rows within an atomic transaction (`db.$transaction`).

### Step 4: Reconciliation & Rejected Row Handling
1. The script calculates:
   - Total rows in source file: N_source
   - Total rows successfully imported: N_imported
   - Total failed/corrupt rows: N_rejected
2. All failed rows are automatically exported to `rejected-rows.csv` complete with row numbers and validation error messages.
3. Deliver the `rejected-rows.csv` file to the Client for their operations team to correct.

### Step 5: Data Sign-Off with Client
1. Demonstrate the Staging dashboard which now displays the client's sanitized production-shaped data (PII masked per Step 3, not "Lorem Ipsum" dummy data).
2. Send the **`MIGRATION_RECONCILIATION_REPORT.md`** document to the Client's Single PIC.
3. Client signs the data approval sheet (*Data Sign-Off*).

---

## 4. Adaptation by Project Scale

| Data Migration Aspect | 🔵 Small Scale (Fast-Track MVP) | 🟢 Medium Scale (B2B SaaS / Agency) | 🟡 Large Scale (Legacy Data Migration) | 🔴 Enterprise (Non-Solo Capacity) |
| :--- | :--- | :--- | :--- | :--- |
| **M08 Status** | **M08 DI-SKIP / WAIVED** (Hanya data seeding awal) | **Kondisional** (Wajib jika ada data legacy klien) | **Wajib Penuh** (`DATA_MIGRATION_PLAN.md` & Rekonsiliasi) | **Dialihkan ke Seri A (Fase A02 Data Governance)** |
| **Data Volume** | Zero legacy data (hanya dummy seed) | 1,000 – 100,000 baris data dari klien | > 100,000 baris data / database warisan | Database ERP korporat (dikelola data engineer klien) |
| **Source Format** | N/A (kode seeder aplikasi) | Spreadsheet Excel / CSV terstruktur | Database relasional lama, dump SQL, multi-tabel | Sistem core legacy / data warehouse terdistribusi |
| **Execution Method** | `prisma db seed` / `npm run seed` | Script ETL terstruktur dengan batching & logging | Pipeline ETL modular dengan dry-run & skema rollback | Data Migration Governance & Framework Rekonsiliasi |
| **PII Sanitization** | N/A (data sintetis murni) | Script masking otomatis untuk NIK, no HP, & email | Engine anonimisasi data kepatuhan UU PDP No. 27/2022 | Audit privasi data korporat & kontrak pemrosesan data |
| **Sign-Off Dokumen** | Di-waive | Lembar `MIGRATION_RECONCILIATION_REPORT.md` ditandatangani | Berita Acara Rekonsiliasi Data Resmi (BAST Data) | Rekomendasi audit migrasi & tanda tangan komite data |

> ⚠️ **LEGACY DATA & PDP LAW GUARDRAILS**:
> 1. **Legacy Data Escalation Rule**: Proyek skala kecil tidak menangani migrasi data warisan klien. Jika klien membawa basis data legacy, proyek **otomatis naik kelas (High-Water Mark) ke Skala Besar** (`SKILL.md:156`).
> 2. **UU PDP Staging Prohibition**: Database dump produksi klien ber-PII **DILARANG KERAS di-restore langsung ke lingkungan Staging atau Lokal** tanpa proses masking/anonymization terlebih dahulu (UU PDP No. 27/2022 Pasal 35).
> 3. **Enterprise Non-Solo Capacity**: Solo developer dilarang melakukan migrasi sistem enterprise mandiri. Proyek enterprise dialihkan ke **Seri A Advisory (Fase A02 Data Architecture & Governance)**.

---

## 5. Deliverables

> 📁 **MANDATORY FILE LOCATION RULE**:
> Migration plan documents and data reconciliation reports MUST be stored in the **`docs/pm/`** folder.

This module produces 3 primary artifacts:
1. **`docs/pm/DATA_MIGRATION_PLAN.md`**: Document mapping source columns to target columns, transformation rules, and data ownership boundaries (using `templates/05-data-migration/DATA_MIGRATION_PLAN_TEMPLATE.md`).
2. **`docs/pm/MIGRATION_RECONCILIATION_REPORT.md`**: Report providing proof of source vs target data count comparison, rejected rows list, and Client PIC approval sheet (using `templates/05-data-migration/RECONCILIATION_REPORT_TEMPLATE.md`).
3. **Staging Database Populated with Sanitized Data**: Database on the Staging server ready for UAT testing sessions (all PII masked).

---

## 6. Gate Exit Criteria [GATE]

[GATE] Module 08 is declared **PASSED (PASS)** if:
- [ ] Column mapping document (`docs/pm/DATA_MIGRATION_PLAN.md`) is agreed upon.
- [ ] ETL script successfully imports all valid data without triggering foreign key integrity errors.
- [ ] Sensitive data on the Staging server has been sanitized/masked in compliance with PDP Law.
- [ ] All failed rows have been exported to `rejected-rows.csv` and handed over to the client.
- [ ] **Client Single PIC has signed the data reconciliation sign-off sheet.**

---

## 🛑 EXIT [GATE] PROTOCOL & MANDATORY STOP

After data is successfully migrated and the reconciliation report is published:

### **STEP 0: FILE EXISTENCE VERIFICATION (BLOCKING CHECK)**

**MANDATORY BEFORE CONTENT VALIDATION**:

1. **Check output file existence** using one of the following methods:
   - PowerShell: `Test-Path -LiteralPath "docs/pm/MIGRATION_RECONCILIATION_REPORT.md"` → must return `True`
   - Read and verify file `docs/pm/MIGRATION_RECONCILIATION_REPORT.md` → must succeed without error

2. **IF FILE DOES NOT EXIST**:
   - ❌ **STOP IMMEDIATELY** - do not proceed to content validation
   - ❌ **DO NOT display summary** to user
   - ❌ **DO NOT request confirmation** to proceed to Module 09
   - ✅ **REPORT ERROR** to user:
     ```
     CRITICAL ERROR: File MIGRATION_RECONCILIATION_REPORT.md was not created.
     Module 08 FAILED - cannot proceed to Module 09 (UAT).
     
     Possible causes:
     - Write permission denied on docs/pm/ folder
     - Path typo in tool call
     - Disk full
     
     Please investigate this issue before proceeding.
     ```
   - ✅ **END TURN** and wait for user to fix issue

3. **ONLY IF FILE EXISTS**: Proceed to content validation below

---

### **STEP 1: CONTENT VALIDATION & DATA SIGN-OFF**

1. **STRICTLY PROHIBITED from proceeding directly or calling tools for Module 09 within the same turn!**
2. **Verify migration results**:
   - [ ] Read and verify file `docs/pm/MIGRATION_RECONCILIATION_REPORT.md` → Confirm row counts match
   - [ ] Confirm PII sanitized on staging
   - [ ] Confirm client Data Sign-Off received
3. Present data reconciliation summary (successful vs rejected row counts) to user.
4. **END YOUR RESPONSE (END TURN)** and ask user for confirmation:
   > *"Data has been successfully migrated to the Staging database with verified reconciliation accuracy. Is this data approved (Data Sign-Off) before we open the user testing session in Module 09 (UAT & Sign-Off)?"*
5. Wait for explicit approval response from user before advancing to Module 09.
