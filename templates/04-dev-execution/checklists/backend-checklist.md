# Backend Development Checklist

**Module**: M06 Development Execution  
**Purpose**: Detailed sequential checklist untuk backend API, database, queues, storage

**Use with**: AI coding agents, solo developers executing M06

---

## 1. Database Setup & Migrations

### Connection & Pooling
- [ ] **Koneksi & Connection Pooling**:
  - [ ] Pasang URL koneksi database di `.env` (format: `postgresql://user:pass@host:5432/dbname?sslmode=prefer`).
  - [ ] Konfigurasikan pooling (PgBouncer / Prisma connection limit / max pool size) untuk mencegah *connection exhaustion* saat traffic melonjak.
  - [ ] Verifikasi timeout koneksi database (connect timeout: 5s, statement timeout: 30s).

### Schema Definition
- [ ] **Definisi Skema DDL & Model Entitas**:
  - [ ] Buat model pengguna dan akun (`User`, `Account`, `Session`, `Profile`).
  - [ ] Buat model entitas bisnis inti sesuai `ARCHITECTURE.md` (contoh: `Document`, `Transaction`, `AuditLog`).
  - [ ] Terapkan konstrain integritas data: `NOT NULL`, `CHECK`, dan `UNIQUE` pada level basis data.
  - [ ] Pasang klausul integritas relasi foreign key: `ON DELETE RESTRICT` (untuk data finansial/legal) atau `CASCADE` (untuk entitas child milik parent).

### Indexing Strategy
- [ ] **Strategi Indexing**:
  - [ ] Tambahkan indeks pada seluruh kolom Foreign Key (`tenant_id`, `user_id`, `organization_id`).
  - [ ] Buat compound index untuk kueri filter umum (contoh: `@@index([tenant_id, status, created_at])`).
  - [ ] Buat unique index pada field penanda unik (contoh: `email`, `slug`, `transaction_code`).
  - [ ] Terapkan indeks pencarian teks (B-Tree/Trigram/Full-Text Search) pada kolom yang sering dicari.

### Soft Delete
- [ ] **Soft-Delete & Durabilitas Data**:
  - [ ] Tambahkan kolom `deleted_at TIMESTAMP NULL` pada seluruh tabel entitas penting.
  - [ ] Pasang query middleware / Prisma extension untuk memfilter baris `deleted_at IS NULL` secara otomatis.

### Migration Execution
- [ ] **Eksekusi Migrasi & Seeders**:
  - [ ] Generate berkas migrasi pertama (`prisma migrate dev --name init` / `php artisan migrate` / `makemigrations`).
  - [ ] Uji balik (*rollback*) migrasi untuk memastikan migrasi *reversible*.
  - [ ] Buat skrip seeder data awal (`seed.ts`): akun superadmin, data referensi dasar, dan mock fixture untuk uji lokal.

---

## 2. API Endpoints Development

### Authentication Endpoints
- [ ] **Authentication & Identity Endpoints**:
  - [ ] `POST /api/v1/auth/register`: Registrasi user baru, hash password (Argon2id min 12 rounds), return HTTP 201.
  - [ ] `POST /api/v1/auth/login`: Verifikasi kredensial, proteksi brute-force delay, terbitkan session/JWT di cookie HttpOnly (`SameSite=Lax`, `Secure`).
  - [ ] `POST /api/v1/auth/logout`: Revokasi token/sesi, hapus cookie autentikasi.
  - [ ] `POST /api/v1/auth/refresh`: Rotasi refresh token dengan deteksi token reuse.
  - [ ] `POST /api/v1/auth/forgot-password` & `POST /api/v1/auth/reset-password`: Token kriptografis ber-TTL 15 menit.
  - [ ] `GET /api/v1/auth/me`: Ambil profil pengguna yang sedang login.

### CRUD Endpoints
- [ ] **Core Business CRUD Endpoints**:
  - [ ] `GET /api/v1/{resources}`: Daftar data dengan filter status, date range, pagination, dan tenant isolation.
  - [ ] `GET /api/v1/{resources}/:id`: Detail satu data dengan verifikasi kepemilikan tenant (cegah IDOR vulnerability).
  - [ ] `POST /api/v1/{resources}`: Pembuatan data baru dibungkus validasi Zod dan transaksi basis data atomik.
  - [ ] `PATCH /api/v1/{resources}/:id`: Pembaruan data parsial dengan validasi state-machine dan optimistic locking.
  - [ ] `DELETE /api/v1/{resources}/:id`: Soft-delete data, update `deleted_at`, catat audit log.

### Search & Filter
- [ ] **Search & Filtering Endpoints**:
  - [ ] Sanitasi query string pencarian (cegah wildcard abuse & regex DoS).
  - [ ] Dukungan filter multi-field via query parameter (contoh: `?status=pending&role=manager&from=2026-01-01`).
  - [ ] Fuzzy matching atau trigram search untuk toleransi salah ketik ringan pada nama/judul.

### Pagination
- [ ] **Standardisasi Pagination & Sorting**:
  - [ ] Implementasikan Cursor-based pagination untuk dataset volume besar / infinite scroll.
  - [ ] Terapkan fallback limit & offset dengan batasan tegas (`max_limit = 100`, default: 20).
  - [ ] Standardisasi format respons JSON:
    ```json
    {
      "data": [...],
      "meta": { "total": 142, "page": 1, "limit": 20, "has_more": true },
      "error": null
    }
    ```

---

## 3. Middleware Implementation

### Authentication Middleware
- [ ] **Authentication Middleware**:
  - [ ] Ekstrak token dari HttpOnly cookie atau header `Authorization: Bearer <token>`.
  - [ ] Validasi tanda tangan kriptografis dan masa berlaku token.
  - [ ] Injeksi payload identitas pengguna (`userId`, `tenantId`, `role`) ke dalam *request context*.
  - [ ] Return standard 401 Unauthorized jika token tidak ada, rusak, atau kadaluwarsa.

### Authorization Middleware
- [ ] **Role-Based Access Control (RBAC) & Tenant Isolation**:
  - [ ] Buat guard middleware untuk memvalidasi peran (`admin`, `member`, `guest`).
  - [ ] Validasi *tenant scope*: setiap kueri wajib menyertakan filter `tenant_id` untuk mencegah kebocoran antar klien.

### Validation Middleware
- [ ] **Validation Middleware**:
  - [ ] Validasi skema Zod otomatis pada `request.body`, `request.query`, dan `request.params`.
  - [ ] Format error 422 Unprocessable Entity yang konsisten dengan rincian field yang gagal:
    ```json
    {
      "error": { "code": "VALIDATION_ERROR", "fields": { "email": "Format email tidak valid" } }
    }
    ```

### Rate Limiting
- [ ] **Rate Limiting Middleware**:
  - [ ] Terapkan pembatasan rate limit berbasis IP & User ID (in-memory sliding window / Redis).
  - [ ] Public routes: max 100 req/min; Auth routes (login/register): max 5 req/min.
  - [ ] Kirim header standar: `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `Retry-After`.

### Security Headers
- [ ] **Security Headers & CORS Middleware**:
  - [ ] Konfigurasikan CSP (Content Security Policy), HSTS (`max-age=31536000`), X-Frame-Options (`DENY`), X-Content-Type-Options (`nosniff`).
  - [ ] CORS ketat: Whitelist domain staging/production eksplisit, dilarang `Access-Control-Allow-Origin: *` bila cookie digunakan.

---

## 4. Background Jobs, Queues & Workers

### Queue Setup
- [ ] **Queue Runtime Setup**:
  - [ ] Inisialisasi antrean tugas (BullMQ / Redis / Celery / Laravel Queue / River).
  - [ ] Pisahkan konfigurasi worker dari server HTTP agar tidak membebani event loop utama.

### Async Workers
- [ ] **Asynchronous Task Workers**:
  - [ ] Worker pembuatan PDF, watermarking, dan stempel dokumen legal.
  - [ ] Worker kompresi dan hashing berkas (SHA-256 integrity verification).
  - [ ] Worker pengiriman email transaksional dan webhook outbox delivery.

### Retry Policy
- [ ] **Ketahanan & Retry Policy**:
  - [ ] Terapkan exponential backoff dengan jitter pada tugas yang gagal (contoh: retry setelah 5s, 15s, 45s).
  - [ ] Konfigurasikan Dead Letter Queue (DLQ) untuk menampung tugas yang gagal setelah 3x percobaan.
  - [ ] Alerting otomatis jika antrean DLQ melebihi ambang batas.

---

## 5. File Upload & Storage Service

### Storage Abstraction
- [ ] **Storage Client Abstraction**:
  - [ ] Buat adapter storage seragam (S3 / Cloudflare R2 / MinIO / Local filesystem).
  - [ ] Kredensial dibaca dari `.env` (`S3_BUCKET`, `S3_REGION`, `S3_ACCESS_KEY`, `S3_SECRET_KEY`).

### Presigned URLs
- [ ] **Presigned URL Architecture**:
  - [ ] Endpoint `POST /api/v1/storage/upload-url`: Hasilkan presigned PUT URL ber-TTL 15 menit.
  - [ ] Endpoint `GET /api/v1/storage/download-url/:id`: Hasilkan presigned GET URL ber-TTL 15 menit dengan otorisasi ketat.

### File Validation
- [ ] **Validasi Berkas Server-Side**:
  - [ ] Validasi MIME-type via *magic bytes* header berkas (bukan sekadar membaca ekstensi nama file).
  - [ ] Batasi ukuran maksimum file (contoh: 15MB untuk PDF, 5MB untuk gambar).
  - [ ] Sanitasi nama berkas asli (hapus karakter berbahaya, gunakan UUIDv4 sebagai storage key).

### Encryption
- [ ] **Enkripsi At-Rest**:
  - [ ] Terapkan enkripsi streaming AES-256-GCM sebelum berkas sensitif ditulis ke storage bucket.

---

## 6. Email & Notifications

### Email Transport
- [ ] **Transport Email Transaksional**:
  - [ ] Integrasikan SDK Resend / SendGrid / SES dengan logging fallback pada mode lokal.
  - [ ] Konfigurasikan fallback mode (mock logger) jika API key email belum terpasang di lokal.

### Email Templates
- [ ] **Template Email HTML Responsif**:
  - [ ] Template aktivasi akun & verifikasi email.
  - [ ] Template reset kata sandi dengan link ber-TTL.
  - [ ] Template notifikasi status dokumen (contoh: "Dokumen telah ditandatangani").
  - [ ] Sediakan versi plain-text untuk setiap email demi deliverability optimal.

### In-App Notifications
- [ ] **In-App Notification Dispatcher**:
  - [ ] Model basis data `Notification` (`id`, `user_id`, `title`, `body`, `read_at`, `created_at`).
  - [ ] Endpoint `GET /api/v1/notifications` dan `PATCH /api/v1/notifications/:id/read`.

### Webhook Handlers
- [ ] **Webhook Deliverability Handler**:
  - [ ] Endpoint penangkap webhook bounce dan complaint dari penyedia email untuk otomatis menonaktifkan pengiriman ke email invalid.

---

## Verification Checklist

Before merging to staging:

- [ ] All API endpoints return consistent JSON structure
- [ ] Authentication flow tested (register → login → refresh → logout)
- [ ] RBAC verified (users cannot access other tenants' data)
- [ ] Rate limiting active on login/register endpoints
- [ ] Background jobs processing successfully
- [ ] File upload/download working with presigned URLs
- [ ] Email sending (or mock in dev) functional
- [ ] Database migrations reversible (tested rollback)
- [ ] Zero TypeScript errors (`tsc --noEmit`)
- [ ] No `any` types in new code

---

**See Also**:
- `templates/04-dev-execution/checklists/frontend-checklist.md` - Frontend development tasks
- `templates/04-dev-execution/checklists/integration-checklist.md` - Third-party integrations
- `patterns/security/authentication.md` - Auth implementation patterns
- `patterns/validation/zod-patterns.md` - Validation schemas
- M06 Development Execution - Core module documentation
