# Standar Rekayasa Solo Developer: Git, Keamanan, Performa, & Efisiensi Sumber Daya

Dokumen ini adalah pedoman teknis mendalam bagi solo developer untuk menegakkan disiplin version control (Git), keamanan data, kecepatan aplikasi, dan penghematan biaya server.

---

## 1. Protokol Percabangan Git & Kebersihan Produksi (Clean Production)

### 1.1 Struktur Cabang (Branch Hierarchy)
```text
[ main ]        ──► Kode produksi stabil, bersih dari berkas internal dev, ber-tag SemVer (v1.0.0)
   ▲
   │ (Pull Request / Merge setelah lulus UAT Klien)
[ staging ]     ──► Lingkungan integrasi untuk pengujian bersama Single PIC Klien
   ▲
   │ (Merge setelah lulus smoke test lokal)
[ feat/* ]      ──► Cabang kerja per fitur/tugas atomik di TODO.md
[ fix/* ]       ──► Cabang perbaikan bug
```

### 1.2 Kebersihan Produksi (Omission of Internal Docs)
Berkas kerja internal seperti `TODO.md`, draf catatan rapat, atau skrip uji lokal tidak boleh disertakan dalam bundle produksi publik atau image Docker.

Tambahkan pada berkas `.dockerignore`:
```text
TODO.md
docs/specs/
scripts/smoke-test.ts
.env*
!.env.example
README.md
```

### 1.3 Standar Pesan Commit (Conventional Commits)
Format wajib: `<type>(<scope>): <subject>`
- `feat(vault)`: Penambahan fitur baru
- `fix(auth)`: Perbaikan bug
- `perf(db)`: Peningkatan performa (indeks, query optimization)
- `sec(crypto)`: Penguatan keamanan atau rotasi kunci
- `chore(deps)`: Pembaruan dependensi paket

---

## 2. Pilar Keamanan Kritis (Security Engineering)

### 2.1 Pencegahan SQL Injection & Celah Input
- DILARANG menyambung string kueri SQL mentah:
  ```typescript
  // SALAH & BERBAHAYA:
  await db.$queryRawUnsafe(`SELECT * FROM users WHERE email = '${email}'`);

  // BENAR: Menggunakan kueri berparameter aman
  await db.$queryRaw`SELECT * FROM users WHERE email = ${email}`;
  ```
- Seluruh input dari client wajib melalui skema **Zod** sebelum diproses lebih lanjut.

### 2.2 Keamanan Sesi & Password
- Kata sandi wajib di-hash menggunakan **Argon2id**:
  ```typescript
  import * as argon2 from "argon2";
  const hash = await argon2.hash(password, { type: argon2.argon2id });
  ```
- Token sesi disimpan di cookie dengan atribut wajib:
  ```http
  Set-Cookie: session_token=...; HttpOnly; Secure; SameSite=Strict; Path=/; Max-Age=604800
  ```

### 2.3 Audit Keamanan Dependensi Otomatis
Jalankan audit berkala:
```bash
pnpm audit --audit-level=high
```
Jika ditemukan celah dengan tingkat keparahan tinggi (*high/critical*), segera perbarui paket terkait sebelum melanjutkan koding.

---

## 3. Pilar Performa (Performance Engineering)

### 3.1 Pencegahan Masalah N+1 Query
Masalah N+1 query adalah pembunuh performa utama pada ORM:
```typescript
// SALAH: 1 query untuk ambil user + N query di dalam loop (N+1 queries)
const users = await db.user.findMany();
for (const user of users) {
  const docs = await db.document.findMany({ where: { creatorId: user.id } });
}

// BENAR: Cukup 1 query dengan relasi join / eager loading
const usersWithDocs = await db.user.findMany({
  include: { documents: true },
});
```

### 3.2 Indeks Basis Data yang Presisi
Pasang indeks pada:
1. Seluruh kolom **Foreign Key** (`creator_id`, `document_id`).
2. Kolom status yang sering digunakan pada klausa `WHERE`:
   ```sql
   CREATE INDEX idx_documents_status ON documents(status);
   -- Composite index jika sering dicari bersamaan:
   CREATE INDEX idx_documents_creator_status ON documents(creator_id, status);
   ```

### 3.3 Optimasi Aset Visual
- Dilarang memuat gambar format PNG/JPEG mentah ukuran besar.
- Gunakan format **WebP / AVIF** otomatis melalui komponen Next.js `<Image />`.
- Gunakan teknik **Font Subsetting** (hanya memuat karakter Latin yang dibutuhkan) untuk memangkas ukuran file font $< 30\text{ KB}$.

---

## 4. Pilar Efisiensi Sumber Daya & Biaya (Resource Efficiency)

### 4.1 Database Connection Pooling
Serverless functions (seperti Next.js API routes atau AWS Lambda) membuka koneksi database baru setiap kali ada request. Tanpa pooling, database PostgreSQL akan kehabisan batas koneksi (*Connection Exhaustion*).
- Gunakan **Connection Pooler** (Supabase Connection Pooler / PgBouncer / Prisma Accelerate).
- Batasi ukuran pool di connection string:
  ```text
  DATABASE_URL="postgresql://user:pass@host:6543/db?pgbouncer=true&connection_limit=10"
  ```

### 4.2 Pemrosesan File Berbasis Aliran (Streaming)
Jangan membaca berkas besar langsung ke memori RAM:
```typescript
// SALAH: Memuat seluruh file 50 MB ke RAM
const fileBuffer = fs.readFileSync("large-document.pdf");

// BENAR: Alirkan data secara streaming (konsumsi RAM < 10 MB konstan)
const readStream = fs.createReadStream("large-document.pdf");
readStream.pipe(cipherStream).pipe(s3UploadStream);
```

### 4.3 Multi-Stage Docker Build untuk Efisiensi Server
Jika men-deploy menggunakan Docker container, gunakan teknik multi-stage:
```dockerfile
# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install --frozen-lockfile
COPY . .
RUN pnpm build

# Stage 2: Production Runner (Ukuran akhir < 150 MB)
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/static ./.next/static
EXPOSE 3000
CMD ["node", "server.js"]
```
Teknik ini memangkas ukuran image dari 1.2 GB menjadi **hanya 130 MB**, menghemat biaya penyimpanan registry dan mempercepat waktu deployment hingga 5x lipat.

---

## 5. Pilar Observabilitas & Ketahanan (Observability & Reliability)

Solo developer tidak dapat memantau terminal server 24 jam sehari. Sistem harus mampu melapor mandiri saat terjadi anomali:

### 5.1 Structured JSON Logging
Dilarang menggunakan `console.log()` teks polos di produksi. Gunakan logger terstruktur JSON (Pino/Winston) yang menyertakan trace ID, actor ID, dan error stack:
```typescript
import pino from "pino";
export const logger = pino({
  level: process.env.LOG_LEVEL || "info",
  formatters: {
    level: (label) => ({ level: label }),
  },
});
```

### 5.2 Rute Healthcheck & Graceful Shutdown
- Wajib sediakan endpoint `GET /api/health` yang menguji koneksi basis data aktif.
- Tangani sinyal sistem operasi (`SIGTERM` / `SIGINT`) untuk menutup koneksi database secara tertib sebelum proses dihentikan:
  ```typescript
  process.on("SIGTERM", async () => {
    logger.info("Menerima SIGTERM, menutup koneksi database...");
    await db.$disconnect();
    process.exit(0);
  });
  ```

---

## 6. Pilar Kemudahan Perawatan & Kebersihan Tipe (Maintainability & Type Hygiene)

### 6.1 Sumber Tunggal Tipe Data (Single Source of Truth)
- Tipe data TypeScript wajib diturunkan secara otomatis dari skema validasi Zod (`z.infer<typeof Schema>`).
- Dilarang menduplikasi definisi tipe secara manual di tempat terpisah.

### 6.2 Pola Early Returns (Guard Clauses)
Validasi seluruh kondisi salah, akses tidak sah, dan input kosong di baris paling awal fungsi:
```typescript
// BENAR: Flat dan mudah dipahami
export async function processDocument(user: User, docId: string) {
  if (!user.isActive) throw new ForbiddenError("Akun tidak aktif");
  if (!docId) throw new BadRequestError("Document ID kosong");
  
  const doc = await getDoc(docId);
  if (!doc) throw new NotFoundError("Dokumen tidak ditemukan");

  return executeLogic(doc);
}
```

---

## 7. Pilar Ketahanan Data & Pemulihan (Data Durability & Disaster Recovery)

### 7.1 Kebijakan Soft-Delete vs Hard-Delete
- Data transaksi finansial, draf kontrak legal, dan jejak audit **DILARANG DIHAPUS PERMANEN** dari basis data (`DELETE FROM`).
- Gunakan kolom `deleted_at TIMESTAMP WITH TIME ZONE NULL` (Soft-Delete) agar data tetap memiliki nilai pembuktian audit dan dapat dipulihkan jika pengguna salah menghapus.

### 7.2 Integritas Transaksi Multi-Tabel
Operasi mutasi data yang melibatkan lebih dari satu tabel wajib dibungkus dalam transaksi atomik (`db.$transaction`). Jika langkah kedua gagal, langkah pertama otomatis dibatalkan (*rollback*) sehingga data tidak pernah korup sebagian.
