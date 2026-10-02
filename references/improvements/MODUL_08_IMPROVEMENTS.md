# Modul 08 Improvements: Data Migration & Seeding

## 1. Timeline Estimation (by Project Scale)

| Phase | Kecil (<1k rows) | Menengah (1k-100k rows) | Besar (>100k rows) | Enterprise (multi-DB) |
|-------|------------------|-------------------------|--------------------|-----------------------|
| Data Source Audit | 1-2 jam | 3-4 jam | 6-8 jam | 12-16 jam (legacy API recon) |
| Mapping Matrix | 2-3 jam | 4-6 jam | 8-12 jam | 16-24 jam (multi-source normalization) |
| ETL Script Writing | 3-4 jam | 8-12 jam | 16-24 jam | 32-48 jam (parallel pipelines) |
| PII Masking Script | 1-2 jam | 2-3 jam | 4-6 jam | 8-12 jam (anonymization engine) |
| ETL Execution & Debugging | 2-3 jam | 6-10 jam | 12-20 jam | 24-40 jam (retry logic, chunking) |
| Reconciliation Report | 1-2 jam | 2-3 jam | 4-6 jam | 8-12 jam (audit trail) |
| Client Data Sign-Off | 1 jam (email) | 2-3 jam (meeting) | 4-6 jam (presentation) | 8-12 jam (formal approval) |
| **TOTAL** | **11-17 jam (1.5-2 hari)** | **27-41 jam (3.5-5 hari)** | **54-82 jam (7-10 hari)** | **108-164 jam (14-21 hari)** |

### Assumptions
- Data quality: 80-90% clean (10-20% rejected rows require client cleanup)
- Client response time for rejected rows: 1-2 hari (not included in dev timeline)
- Buffer 25% untuk unexpected data format issues (merged cells, encoding issues, missing FK references)

### Bottlenecks
- Client data cleanup iterations: +1-3 hari per round (client-side, blocks dev progress)
- Large file parsing (>100k rows): +4-8 jam (memory optimization, streaming parser)
- Foreign key constraint violations: +2-4 jam debugging (orphaned records)
- Legacy system API downtime: +1-2 hari (waiting for access restoration)

---

## 2. Data Quality Pre-Flight Checklist

Run checklist ini SEBELUM menulis ETL script. Kirim hasil audit ke klien untuk perbaikan dulu.

---

### 1. File Format & Encoding

**Checklist**:
- [ ] File format supported (CSV UTF-8, Excel .xlsx, JSON, SQL dump)
- [ ] No merged cells (Excel) — unmerge all cells first
- [ ] No hidden rows/columns (Excel)
- [ ] Encoding UTF-8 (not Windows-1252 or ISO-8859-1) — check dengan `file -I data.csv`
- [ ] Line endings consistent (CRLF or LF, not mixed)
- [ ] File size manageable (<100MB for single-threaded, <1GB for streaming)

**Validation Command**:
```bash
# Check encoding
file -I legacy-data.csv
# Expected: text/csv; charset=utf-8

# Check line count
wc -l legacy-data.csv
# If >100k rows, plan streaming parser (not load all to memory)

# Check for null bytes (corrupted file)
grep -c $'\x00' legacy-data.csv
# Expected: 0
```

**If fails**: Ask client to re-export with correct format.

---

### 2. Column Consistency

**Checklist**:
- [ ] Header row present (column names)
- [ ] Column names ASCII-safe (no emoji, no special chars: `Nama Lengkap✅` → `Nama_Lengkap`)
- [ ] No duplicate column names (`Email`, `Email_2` → normalize)
- [ ] Column count consistent across all rows (no ragged rows)
- [ ] Required columns present (match mapping matrix)

**Validation Command**:
```bash
# Check header
head -1 legacy-data.csv

# Check column count consistency
awk -F',' 'NR==1{cols=NF} NF!=cols{print "Row " NR " has " NF " columns, expected " cols}' legacy-data.csv
# Expected: no output (all rows same column count)
```

**If fails**: Ask client to fix column structure.

---

### 3. Data Type Consistency

**Checklist per Column Type**:

**Dates**:
- [ ] Format consistent (`YYYY-MM-DD`, not mixed `12/04/2024` and `4 Desember 2024`)
- [ ] No future dates (birth_date in 2030 = invalid)
- [ ] No empty strings for required dates

**Numbers**:
- [ ] No currency symbols (`Rp`, `$`, `.`, `,`) — should be raw numbers `15000000`
- [ ] No units in number columns (`15 kg` → separate to `amount` and `unit` columns)
- [ ] Decimal separator consistent (`.` for US, `,` for ID — pick one)

**Enums**:
- [ ] Values match expected enum set (status: `pending`/`approved`/`rejected`, not `Pending`/`Approved`/`REJECTED`)
- [ ] No typos (`approvd`, `rejcted`)

**IDs (Primary/Foreign Keys)**:
- [ ] No empty IDs for required columns
- [ ] ID format consistent (UUID, integer, string)
- [ ] Foreign keys reference existing records (no orphaned records)

**Validation Script** (`scripts/validate-data-types.ts`):
```typescript
import { parse } from 'csv-parse/sync';
import { z } from 'zod';
import fs from 'fs';

const RowSchema = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
  birth_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/), // YYYY-MM-DD
  amount: z.string().regex(/^\d+$/), // Numbers only
  status: z.enum(['pending', 'approved', 'rejected']),
});

const csv = fs.readFileSync('legacy-data.csv', 'utf-8');
const rows = parse(csv, { columns: true });

let errors = 0;
rows.forEach((row, idx) => {
  const result = RowSchema.safeParse(row);
  if (!result.success) {
    console.error(`Row ${idx + 2}: ${result.error.message}`);
    errors++;
  }
});

console.log(`Validation: ${rows.length - errors}/${rows.length} rows valid`);
process.exit(errors > 0 ? 1 : 0);
```

**If fails**: Generate `data-quality-report.csv` with errors, send to client for cleanup.

---

### 4. Duplicate Detection

**Checklist**:
- [ ] No duplicate primary keys (ID column unique)
- [ ] No duplicate natural keys (email, NIK, phone unique if required)
- [ ] No duplicate composite keys (user_id + document_id combination unique)

**Validation Command**:
```bash
# Check duplicate emails
awk -F',' 'NR>1 {print $3}' legacy-data.csv | sort | uniq -d
# Expected: no output (no duplicate emails)

# Count duplicates
awk -F',' 'NR>1 {count[$3]++} END {for (email in count) if (count[email] > 1) print email, count[email]}' legacy-data.csv
```

**If duplicates found**:
- Ask client: "Which record is correct? Delete duplicates or merge?"
- Document decision in `DATA_MIGRATION_PLAN.md`

---

### 5. Referential Integrity

**Checklist**:
- [ ] Foreign keys reference existing records (user_id exists in users table)
- [ ] No orphaned records (documents without user, orders without customer)
- [ ] Circular dependencies resolved (A references B, B references A)

**Validation Script** (`scripts/check-fk-integrity.ts`):
```typescript
import { parse } from 'csv-parse/sync';
import fs from 'fs';

const users = parse(fs.readFileSync('users.csv', 'utf-8'), { columns: true });
const documents = parse(fs.readFileSync('documents.csv', 'utf-8'), { columns: true });

const userIds = new Set(users.map(u => u.id));
const orphanedDocs = documents.filter(d => !userIds.has(d.user_id));

if (orphanedDocs.length > 0) {
  console.error(`Found ${orphanedDocs.length} orphaned documents (user_id not found)`);
  fs.writeFileSync('orphaned-documents.csv', JSON.stringify(orphanedDocs, null, 2));
  process.exit(1);
}

console.log('✅ All foreign keys valid');
```

**If fails**: Ask client to provide missing parent records or remove orphaned records.

---

### 6. Volume & Performance Estimate

**Checklist**:
- [ ] Row count estimated: `wc -l legacy-data.csv`
- [ ] File size checked: `ls -lh legacy-data.csv`
- [ ] ETL execution time estimated: <1k rows (< 1 min), 1k-100k (1-10 min), >100k (10-60 min)
- [ ] Database capacity checked: staging DB has enough disk space (estimate 2x file size)

**Capacity Check**:
```bash
# Check staging DB disk usage
psql $DATABASE_URL -c "SELECT pg_size_pretty(pg_database_size(current_database()));"

# Estimate migration size (rough: 1 row ≈ 1KB)
rows=$(wc -l < legacy-data.csv)
estimated_mb=$((rows / 1000))
echo "Estimated DB size after migration: ${estimated_mb}MB"
```

---

### Pre-Flight Checklist Summary

**Before writing ETL script**:
1. ✅ File format valid (CSV UTF-8, no merged cells)
2. ✅ Column structure consistent (header present, no duplicate names)
3. ✅ Data types validated (dates YYYY-MM-DD, numbers clean, enums match)
4. ✅ No duplicates (primary keys unique)
5. ✅ Referential integrity checked (FKs reference existing records)
6. ✅ Volume estimated (ETL execution time + DB capacity)

**Output**: `DATA_QUALITY_AUDIT_REPORT.md` dengan pass/fail per checklist item. Kirim ke klien untuk approval sebelum lanjut ETL script writing.

**If any item fails**: STOP, ask client to fix data first. Do NOT proceed to ETL script writing.

---

## 3. Error Handling Strategy Matrix

### Error Classification (3 Tiers)

#### Tier 1: FATAL (Stop Entire Migration)

**Errors**:
- Database connection lost
- Disk space full (cannot write)
- Primary key constraint violation (duplicate ID in source)
- Schema mismatch (required column missing in target DB)

**Action**: **ROLLBACK** entire transaction, fix error, restart from beginning.

**Example**:
```typescript
try {
  await db.$transaction(async (tx) => {
    await tx.user.createMany({ data: validBatch });
  });
} catch (error) {
  if (error.code === 'P2002') { // Unique constraint violation
    console.error('FATAL: Duplicate primary key detected');
    throw error; // Stop migration
  }
}
```

**Recovery**:
1. Fix source data (remove duplicate IDs)
2. Clear staging DB: `DELETE FROM users WHERE created_at > NOW() - INTERVAL '1 hour'`
3. Re-run ETL from row 1

---

#### Tier 2: RECOVERABLE (Quarantine Row, Continue)

**Errors**:
- Zod validation failure (invalid email, wrong date format)
- Foreign key not found (orphaned record)
- Out-of-range value (amount negative, age > 150)

**Action**: **QUARANTINE** row to `rejected-rows.csv`, continue with next row.

**Example**:
```typescript
const rejectedRows: any[] = [];

for (const [index, raw] of rawRecords.entries()) {
  const parsed = RowSchema.safeParse(raw);
  if (!parsed.success) {
    rejectedRows.push({
      rowNumber: index + 2,
      data: JSON.stringify(raw),
      error: parsed.error.issues.map((i) => `${i.path}: ${i.message}`).join('; '),
    });
    continue; // Skip this row, proceed to next
  }
  
  validBatch.push(parsed.data);
}

// Export rejected rows
if (rejectedRows.length > 0) {
  fs.writeFileSync('rejected-rows.csv', JSON.stringify(rejectedRows, null, 2));
  console.log(`⚠️ Quarantined ${rejectedRows.length} rows`);
}
```

**Recovery**:
1. Send `rejected-rows.csv` to client
2. Client fixes data
3. Re-run ETL on fixed rows only (incremental import)

---

#### Tier 3: TRANSIENT (Retry with Backoff)

**Errors**:
- Network timeout (database query timeout)
- Rate limit exceeded (third-party API)
- Temporary lock (another process writing to same table)

**Action**: **RETRY** with exponential backoff (max 3 attempts), then fail.

**Example**:
```typescript
async function insertWithRetry(data: any[], maxAttempts = 3) {
  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      await db.$transaction(async (tx) => {
        await tx.user.createMany({ data, skipDuplicates: true });
      });
      return; // Success
    } catch (error) {
      if (error.code === 'P2024' && attempt < maxAttempts) { // Query timeout
        const delayMs = Math.pow(2, attempt) * 1000; // 2s, 4s, 8s
        console.log(`Retry attempt ${attempt}/${maxAttempts} after ${delayMs}ms`);
        await sleep(delayMs);
      } else {
        throw error; // Max attempts or non-retryable error
      }
    }
  }
}
```

---

### Error Decision Tree

```text
Error Occurs
│
├─ Database connection lost?
│  └─ YES → FATAL: Rollback, fix connection, restart
│
├─ Duplicate primary key?
│  └─ YES → FATAL: Rollback, fix source data, restart
│
├─ Validation failure (Zod)?
│  └─ YES → RECOVERABLE: Quarantine row, continue
│
├─ Foreign key not found?
│  └─ YES → RECOVERABLE: Quarantine row, continue
│
├─ Network timeout?
│  └─ YES → TRANSIENT: Retry with backoff (max 3x)
│
└─ Unknown error?
   └─ FATAL: Rollback, investigate, restart
```

---

### Logging & Observability

**Structured Logging** (JSON format):
```typescript
import winston from 'winston';

const logger = winston.createLogger({
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'migration.log' }),
    new winston.transports.Console(),
  ],
});

logger.info('Migration started', {
  source_file: 'legacy-data.csv',
  total_rows: rawRecords.length,
  timestamp: new Date().toISOString(),
});

logger.warn('Row quarantined', {
  row_number: index + 2,
  error: parsed.error.message,
});

logger.info('Migration completed', {
  total_rows: rawRecords.length,
  imported: validBatch.length,
  rejected: rejectedRows.length,
  duration_ms: Date.now() - startTime,
});
```

**Output** (`migration.log`):
```json
{"level":"info","message":"Migration started","source_file":"legacy-data.csv","total_rows":1523,"timestamp":"2026-09-30T10:00:00.000Z"}
{"level":"warn","message":"Row quarantined","row_number":145,"error":"email: Invalid email"}
{"level":"info","message":"Migration completed","total_rows":1523,"imported":1498,"rejected":25,"duration_ms":12456}
```

---

### Error Handling Checklist

- [ ] Fatal errors rollback entire transaction
- [ ] Recoverable errors quarantined to `rejected-rows.csv`
- [ ] Transient errors retried with exponential backoff (max 3x)
- [ ] Structured logging (JSON format) with row number, error message, timestamp
- [ ] Error count tracked: `imported`, `rejected`, `failed`
- [ ] Migration report includes error breakdown

---

## 4. Incremental Migration Strategy

### Scenario: Client Fixed Rejected Rows

**Initial Migration**:
- Total source: 1,525 rows
- Imported: 1,500 rows
- Rejected: 25 rows → `rejected-rows.csv`

**Client fixes rejected rows** → `rejected-rows-fixed.csv`

**Incremental Import** (only 25 fixed rows):

```typescript
// scripts/migrate-incremental.ts
import { parse } from 'csv-parse/sync';
import { z } from 'zod';
import { db } from '@/lib/db';
import fs from 'fs';

const RowSchema = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
  name: z.string().min(1),
});

async function runIncrementalMigration() {
  const csv = fs.readFileSync('rejected-rows-fixed.csv', 'utf-8');
  const rows = parse(csv, { columns: true });

  console.log(`Incremental migration: ${rows.length} rows`);

  const validBatch: any[] = [];
  const stillRejected: any[] = [];

  for (const [index, raw] of rows.entries()) {
    const parsed = RowSchema.safeParse(raw);
    if (!parsed.success) {
      stillRejected.push({
        rowNumber: index + 2,
        data: JSON.stringify(raw),
        error: parsed.error.message,
      });
      continue;
    }

    validBatch.push(parsed.data);
  }

  // Insert only new rows (skipDuplicates avoids re-importing)
  await db.$transaction(async (tx) => {
    await tx.user.createMany({
      data: validBatch,
      skipDuplicates: true, // Skip if ID already exists
    });
  });

  console.log(`✅ Imported ${validBatch.length} rows`);
  if (stillRejected.length > 0) {
    fs.writeFileSync('rejected-rows-round2.csv', JSON.stringify(stillRejected, null, 2));
    console.log(`⚠️ Still rejected: ${stillRejected.length} rows`);
  }
}

runIncrementalMigration();
```

**Run**:
```bash
pnpm tsx scripts/migrate-incremental.ts
```

---

### Idempotency Pattern (Safe Re-Run)

**Problem**: ETL script crashes mid-execution (1,000/1,500 rows imported). How to restart without duplicates?

**Solution**: Use `skipDuplicates` or `upsert`:

```typescript
// Option 1: Skip duplicates (INSERT ... ON CONFLICT DO NOTHING)
await db.user.createMany({
  data: validBatch,
  skipDuplicates: true, // Prisma automatically skips if PK/unique constraint exists
});

// Option 2: Upsert (INSERT ... ON CONFLICT DO UPDATE)
for (const row of validBatch) {
  await db.user.upsert({
    where: { id: row.id },
    update: row, // Update if exists
    create: row, // Insert if not exists
  });
}
```

**Trade-off**:
- `createMany` + `skipDuplicates`: Faster (batch insert), but cannot update existing records
- `upsert`: Slower (one-by-one), but can update existing records

**Recommendation**:
- First migration: Use `createMany` + `skipDuplicates` (fast)
- Incremental/fix: Use `upsert` (update capability)

---

### Progress Tracking (Large Migrations)

**For >10k rows**, log progress every 1,000 rows:

```typescript
const CHUNK_SIZE = 1000;
let totalImported = 0;

for (let i = 0; i < validBatch.length; i += CHUNK_SIZE) {
  const chunk = validBatch.slice(i, i + CHUNK_SIZE);
  
  await db.$transaction(async (tx) => {
    await tx.user.createMany({ data: chunk, skipDuplicates: true });
  });

  totalImported += chunk.length;
  console.log(`Progress: ${totalImported}/${validBatch.length} rows (${Math.round(totalImported / validBatch.length * 100)}%)`);
}
```

**Output**:
```
Progress: 1000/15230 rows (7%)
Progress: 2000/15230 rows (13%)
...
Progress: 15000/15230 rows (98%)
✅ Migration completed: 15230 rows
```

---

### Incremental Migration Checklist

- [ ] `skipDuplicates: true` untuk idempotency (safe re-run)
- [ ] Incremental script accepts `rejected-rows-fixed.csv` as input
- [ ] Progress logging every 1,000 rows (large migrations)
- [ ] Reconciliation report updated after incremental import

---

## 5. Production Migration Strategy (Modul 10 Preview)

**Context**: Modul 08 imports data to **staging** (PII masked). Modul 10 imports to **production** (real PII).

---

### 3 Migration Strategies

#### Strategy A: Re-Run ETL (Recommended for <10k rows)

**Pros**:
- Fresh import with production-safe data (no staging artifacts)
- No PII masking (real emails, NIK, phone)
- Clean transaction logs

**Cons**:
- Requires client to provide data again (production-ready CSV)
- Takes same time as staging migration (11-17 jam for small, 54-82 jam for large)

**Workflow**:
1. Client exports **production-ready** data (no dummy values)
2. Run same ETL script with production DATABASE_URL
3. Verify reconciliation (row count match)

**Command**:
```bash
DATABASE_URL=$PRODUCTION_DATABASE_URL pnpm tsx scripts/migrate-data.ts
```

---

#### Strategy B: Staging Dump (Recommended for >10k rows)

**Pros**:
- Fast (dump + restore < 1 jam)
- No re-processing (data already validated in staging)

**Cons**:
- PII masked in staging → must unmask in production
- Staging artifacts (test users, debug data) may leak
- IDs/UUIDs different from source (if regenerated)

**Workflow**:
1. Dump staging DB: `pg_dump $STAGING_DB > staging-dump.sql`
2. Unmask PII script: `scripts/unmask-pii-production.ts`
3. Restore to production: `psql $PRODUCTION_DB < staging-dump.sql`

**Unmasking Script**:
```typescript
// scripts/unmask-pii-production.ts
import { db } from '@/lib/db';
import { parse } from 'csv-parse/sync';
import fs from 'fs';

// Client provides production-ready PII mapping
const piiMapping = parse(fs.readFileSync('production-pii-mapping.csv', 'utf-8'), { columns: true });

for (const row of piiMapping) {
  await db.user.update({
    where: { id: row.staging_user_id },
    data: {
      email: row.real_email, // Unmask
      phone: row.real_phone,
      nik: row.real_nik,
    },
  });
}

console.log(`✅ Unmasked ${piiMapping.length} users`);
```

---

#### Strategy C: Manual CSV (Last Resort, for corrupted migrations)

**Pros**:
- Full control (manual verification per row)
- No script dependency

**Cons**:
- Slowest (hours for >1k rows)
- Error-prone (typo, missing FK)

**Workflow**:
1. Export staging DB to CSV: `psql $STAGING_DB -c "COPY users TO '/tmp/users.csv' CSV HEADER"`
2. Manually edit CSV (fix PII, remove test data)
3. Import to production: `psql $PRODUCTION_DB -c "\COPY users FROM '/tmp/users-production.csv' CSV HEADER"`

**Only use when**:
- ETL script lost/corrupted
- Staging DB has major data quality issues
- Client insists on manual review

---

### Decision Matrix

| Scenario | Recommended Strategy | Why |
|----------|---------------------|-----|
| **First production deployment** | Strategy A: Re-Run ETL | Clean import, no staging artifacts |
| **Large dataset (>10k rows)** | Strategy B: Staging Dump | Fast, already validated |
| **PII-sensitive (healthcare, finance)** | Strategy A: Re-Run ETL | No staging PII masking traces |
| **Staging data corrupted** | Strategy C: Manual CSV | Last resort fallback |

**Default**: Strategy A (Re-Run ETL) for most solo dev projects.

---

### Production Migration Checklist (Modul 10)

- [ ] Client provides production-ready CSV (no dummy data, real PII)
- [ ] Production DATABASE_URL configured (different from staging)
- [ ] Backup production DB before migration: `pg_dump > backup-pre-migration.sql`
- [ ] Run ETL script with production DATABASE_URL
- [ ] Verify reconciliation (row count match)
- [ ] Test critical workflows (login, payment, document access)
- [ ] Document migration in `DEPLOYMENT_RUNBOOK.md`


---

## Solo Developer Focus

# Panduan Migrasi Data & Seeding Solo Developer

Dokumen ini adalah pedoman taktis bagi solo developer dalam mengeksekusi pemindahan data warisan (*legacy data*) milik klien dari format spreadsheet/CSV/SQL usang ke dalam basis data modern tanpa terjebak lembur merapikan data kotor secara manual.

---

## 1. Menghindari Perangkap "Spreadsheet Hell"

Klien sering menganggap data mereka "sudah rapi", padahal di dalamnya terdapat:
- Sel Excel yang di-*merge* (*merged cells*).
- Format tanggal acak (sebagian `12/04/2024`, sebagian `4 Desember 2024`, sebagian kosong).
- Nilai angka tercampur huruf (`"Rp 15.000.000 (belum diskon)"`).
- Data ganda dengan ejaan nama berbeda (*"PT Sinar Maju"* vs *"PT. Sinar Maju, Tbk"*).

### Aturan Komunikasi Pertahanan:
> *"Pak/Bu, skrip migrasi kami bekerja secara otomatis membaca data terstruktur. Kolom tanggal wajib berformat YYYY-MM-DD dan nominal wajib angka murni. Baris yang formatnya rusak akan otomatis dipisahkan ke berkas `rejected-rows.csv` agar dapat dilengkapi oleh staf operasional Bapak/Ibu."*

---

## 2. Pola Arsitektur Skrip ETL (Extract, Transform, Load)

Gunakan pola skrip mandiri TypeScript/Node.js dengan modul `csv-parse` dan `zod`:

```typescript
import fs from "node:fs";
import { parse } from "csv-parse/sync";
import { z } from "zod";
import { db } from "@/lib/db";

// 1. Skema Validasi Baris Data
const LegacyRowSchema = z.object({
  Nama: z.string().min(1),
  Email: z.string().email(),
  Nominal: z.string().transform((val) => Number(val.replace(/[^0-9]/g, ""))),
});

async function runMigration() {
  const fileContent = fs.readFileSync("legacy-data.csv", "utf-8");
  const rawRecords = parse(fileContent, { columns: true, skip_empty_lines: true });

  const validBatch: any[] = [];
  const rejectedRows: any[] = [];

  // 2. Tahap Transform & Karantina (Quarantine Pattern)
  for (const [index, raw] of rawRecords.entries()) {
    const parsed = LegacyRowSchema.safeParse(raw);
    if (!parsed.success) {
      rejectedRows.push({
        rowNumber: index + 2, // Baris ke-1 adalah header
        data: JSON.stringify(raw),
        error: parsed.error.issues.map((i) => i.message).join("; "),
      });
      continue;
    }

    validBatch.push({
      fullName: parsed.data.Nama.trim(),
      email: parsed.data.Email.toLowerCase().trim(),
      amount: parsed.data.Nominal,
    });
  }

  // 3. Simpan Baris Gagal ke CSV Karantina
  if (rejectedRows.length > 0) {
    fs.writeFileSync("rejected-rows.csv", JSON.stringify(rejectedRows, null, 2));
    console.log(`Karantina: ${rejectedRows.length} baris gagal divalidasi.`);
  }

  // 4. Tahap Load: Batch Insert dalam Transaksi Atomik
  const CHUNK_SIZE = 500;
  for (let i = 0; i < validBatch.length; i += CHUNK_SIZE) {
    const chunk = validBatch.slice(i, i + CHUNK_SIZE);
    await db.$transaction(async (tx) => {
      await tx.user.createMany({ data: chunk, skipDuplicates: true });
    });
  }

  console.log(`Migrasi Sukses: ${validBatch.length} baris berhasil terimpor.`);
}
```

---

## 3. Protokol Masking Data Pribadi Staging (UU PDP No. 27/2022)

Dilarang keras menyalin database produksi yang memuat data NIK KTP atau nomor rekening asli ke server Staging. Lingkungan Staging sering diakses oleh penguji eksternal atau developer lepas.

### Aturan Masking Otomatis:
- **NIK KTP**: Pertahankan 6 digit pertama (kode wilayah) dan 2 digit terakhir, samarkan sisanya: `357801********01`.
- **Email**: Ganti domain menjadi `@staging.local` atau gunakan alias generik: `user_001@staging.local`.
- **Kata Sandi**: Timpa seluruh kata sandi lama dengan hash satu arah default (misal: `StagingPassword123!`) agar tester dapat login saat pengujian UAT tanpa mengetahui kata sandi asli pengguna lama.

---

## 4. Boundary Tanggung Jawab Data Hygiene (Data Liability Red-Line)

**Pembagian Tanggung Jawab:**

| Pihak | Tanggung Jawab | Batas Keras (Red-Line) |
|-------|----------------|------------------------|
| **Solo Developer** | - Membuat skrip ETL Zod-validated<br>- Menyediakan laporan `rejected-rows.csv` dengan alasan validasi error<br>- Menjalankan batch import data yang sudah valid | Jika rejection rate > 30%, WAJIB pause migrasi dan minta klien cleanup data sumber terlebih dahulu. Solo dev TIDAK cleanup manual ribuan baris data kotor. |
| **Klien** | - Membersihkan data sumber sebelum diserahkan (dedupe, format konsisten)<br>- Sign-off data final di Staging via rekonsiliasi report<br>- Memperbaiki baris yang di-reject sesuai error log | Jika klien menolak cleanup dan memaksa "terima apa adanya", tolak dengan sopan dan tawarkan Change Request berbayar untuk data cleaning manual (rate 3x lipat normal). |

**Protokol Red-Line 30%:**
```
Jika rejected_rows.length / total_rows > 0.30:
    PAUSE migrasi
    Kirim email: "Pak/Bu, data sumber memiliki tingkat error 30%+. 
                  Kami perlu Bapak/Ibu cleanup data terlebih dahulu 
                  sesuai panduan di rejected-rows.csv sebelum migrasi dilanjutkan."
    JANGAN cleanup manual sendiri (burnout trap)
```

---

## 5. Taktik Pengesahan Data Bersama Klien (Data Sign-Off)

1. **Jangan Beri Data Mentah ke Klien**:
   Tunjukkan hasil migrasi langsung di antarmuka web Staging. Saat klien melihat dashboard dengan nama pelanggan dan dokumen asli mereka, tingkat kepercayaan klien akan melonjak drastis.
2. **Kunci Persetujuan Tertulis**:
   Kirimkan lembar **`MIGRATION_RECONCILIATION_REPORT.md`** yang memuat:
   - Jumlah baris sumber vs baris terimpor.
   - Lampiran berkas `rejected-rows.csv`.
   - Pernyataan bahwa klien menyetujui data hasil impor sudah akurat untuk digunakan pada sesi **UAT (Modul 09)**.
