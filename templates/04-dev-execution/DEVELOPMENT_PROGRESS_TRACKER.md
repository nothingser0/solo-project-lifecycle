# DEVELOPMENT_PROGRESS_TRACKER.md

> Lembar pelacak kemajuan eksekusi koding, status implementasi komponen, integrasi pihak ketiga, dan pos pemeriksaan code review untuk solo developer & AI coding agents (OpenCode / Cursor / Claude Code).

---

## 1. Project Profile & Locked Stack Metadata

| Parameter | Konfigurasi Proyek | Catatan / Link Spesifikasi |
|---|---|---|
| **Project Name** | `[Nama Proyek]` | PRD.md / FSD.md |
| **Tech Stack Decision** | `[Next.js / Laravel / Django / Go / Flutter]` | FSD.md Header (LOCKED) |
| **Handoff Compatibility** | `[Level 1 / Level 2 / Level 3 / Level 4]` | FSD.md Handoff Strategy |
| **Database Engine** | `[PostgreSQL 16 / MySQL 8 / SQLite]` | ARCHITECTURE.md |
| **ORM / Query Builder** | `[Prisma / Drizzle / Eloquent / Django ORM]` | ARCHITECTURE.md |
| **Object Storage** | `[Cloudflare R2 / AWS S3 / MinIO]` | `.env.example` |
| **Payment Gateway** | `[Stripe / Midtrans / Xendit]` | PRD.md Fungsionalitas |
| **Email Provider** | `[Resend / SendGrid / Amazon SES]` | `.env.example` |
| **Monitoring / APM** | `[Sentry / Datadog / OpenTelemetry]` | `.env.example` |
| **Target Delivery Date** | `[YYYY-MM-DD]` | Project Plan |
| **Lead Developer** | `[Solo Developer Name]` | Git Author |

---

## 2. Ringkasan Kemajuan Eksekusi (High-Level Summary)

```text
[1. Foundation]  ────────► [2. Backend API]  ────────► [3. Frontend UI]  ────────► [4. Integrations]  ────────► [5. Smoke Test & Gate]
      [  % ]                     [  % ]                      [  % ]                      [  % ]                       [  % ]
```

| Domain Pekerjaan | Total Item | Selesai (`DONE`) | Sedang Dikerjakan (`WIP`) | Belum (`TODO`) | Persentase Selesai |
|---|:---:|:---:|:---:|:---:|:---:|
| **Scaffolding & Harness** | 10 | 0 | 0 | 10 | 0% |
| **Backend Development** | 24 | 0 | 0 | 24 | 0% |
| **Frontend Development** | 24 | 0 | 0 | 24 | 0% |
| **Integrations & Services** | 18 | 0 | 0 | 18 | 0% |
| **Code Review & Milestones**| 4 | 0 | 0 | 4 | 0% |
| **TOTAL KESELURUHAN** | **80** | **0** | **0** | **80** | **0%** |

*Status Legend*: `TODO` (Belum Dikerjakan) | `WIP` (Sedang Dikerjakan) | `BLOCKED` (Tergendala) | `REVIEW` (Menunggu Code Review) | `DONE` (Selesai & Teruji).

---

## 3. Backend Development Progress Checklist

### 3.1 Database Setup & Migrations
- [ ] **DB-01**: Konfigurasi koneksi database & connection pooler (PgBouncer / max pool limits) `[Status: TODO]`
- [ ] **DB-02**: Skema DDL tabel inti sesuai ARCHITECTURE.md (Users, Profiles, Organizations) `[Status: TODO]`
- [ ] **DB-03**: Skema DDL entitas bisnis (Documents, Invoices, Transactions, AuditLogs) `[Status: TODO]`
- [ ] **DB-04**: Pasang relasi Foreign Key dengan klausul `ON DELETE RESTRICT` / `CASCADE` terencana `[Status: TODO]`
- [ ] **DB-05**: Pasang indeks performa (FK lookup, kolom pencarian, kolom sorting, unique constraints) `[Status: TODO]`
- [ ] **DB-06**: Terapkan kolom soft-delete (`deleted_at TIMESTAMP NULL`) pada seluruh tabel transaksi `[Status: TODO]`
- [ ] **DB-07**: Eksekusi berkas migrasi awal dan pastikan rollback script berfungsi tanpa error `[Status: TODO]`
- [ ] **DB-08**: Buat skrip seeder (`prisma/seed.ts` atau framework seeder) untuk user admin & mock data testing `[Status: TODO]`

### 3.2 API Endpoints (Auth, CRUD, Search, & Pagination)
- [ ] **API-01**: `POST /api/v1/auth/register` - Pendaftaran akun baru dengan enkripsi password (Argon2id/Bcrypt) `[Status: TODO]`
- [ ] **API-02**: `POST /api/v1/auth/login` - Validasi kredensial, proteksi brute-force, dan set HttpOnly JWT/Session `[Status: TODO]`
- [ ] **API-03**: `POST /api/v1/auth/logout` & `POST /api/v1/auth/refresh` - Revokasi sesi dan rotasi refresh token `[Status: TODO]`
- [ ] **API-04**: `POST /api/v1/auth/forgot-password` & `POST /api/v1/auth/reset-password` - Token reset ber-TTL 15 menit `[Status: TODO]`
- [ ] **API-05**: `GET /api/v1/users/me` & `PATCH /api/v1/users/me` - Ambil profil sesi aktif dan update profil pengguna `[Status: TODO]`
- [ ] **API-06**: `GET /api/v1/resources` - Endpoint daftar data dengan query filter, sorting, dan pagination `[Status: TODO]`
- [ ] **API-07**: `GET /api/v1/resources/:id` - Detail entitas tunggal dengan verifikasi kepemilikan data (tenant isolation) `[Status: TODO]`
- [ ] **API-08**: `POST /api/v1/resources` - Pembuatan entitas dengan validasi skema Zod dan transaksi atomik `[Status: TODO]`
- [ ] **API-09**: `PATCH /api/v1/resources/:id` - Pembaruan parsial dengan proteksi race condition / optimistic lock `[Status: TODO]`
- [ ] **API-10**: `DELETE /api/v1/resources/:id` - Soft-delete entitas dan pencatatan audit log `[Status: TODO]`
- [ ] **API-11**: `GET /api/v1/search` - Endpoint pencarian teks dengan sanitasi string dan indeks full-text/trigram `[Status: TODO]`
- [ ] **API-12**: Penerapan standardisasi pagination cursor atau `page`/`limit` (maksimum hard limit: 100 record) `[Status: TODO]`

### 3.3 Middleware (Auth, Validation, & Rate Limiting)
- [ ] **MID-01**: Middleware Autentikasi - Ekstraksi token dari HttpOnly cookie / Bearer header, validasi masa aktif `[Status: TODO]`
- [ ] **MID-02**: Middleware Otorisasi (RBAC) - Pengecekan role pengguna (`admin`, `member`, `guest`) dan izin spesifik `[Status: TODO]`
- [ ] **MID-03**: Middleware Validasi Payload - Validasi otomatis body/query/params menggunakan skema Zod `[Status: TODO]`
- [ ] **MID-04**: Middleware Rate Limiting - Pembatasan request berbasis IP & User ID (Redis / in-memory sliding window) `[Status: TODO]`
- [ ] **MID-05**: Middleware Security Headers - Konfigurasi CSP, HSTS, X-Frame-Options, X-Content-Type-Options `[Status: TODO]`
- [ ] **MID-06**: Middleware CORS Terisolasi - Whitelist origin ketat (dilarang menggunakan wildcard `*` pada credentials) `[Status: TODO]`

### 3.4 Background Jobs, Queues & Workers
- [ ] **JOB-01**: Setup queue worker runtime (BullMQ / Redis / Celery / Laravel Queue) `[Status: TODO]`
- [ ] **JOB-02**: Antrean pemrosesan dokumen asinkron (kompresi, watermarking, konversi PDF, hashing berkas) `[Status: TODO]`
- [ ] **JOB-03**: Antrean pengiriman email transaksional & webhooks outbox pattern `[Status: TODO]`
- [ ] **JOB-04**: Pengaturan retry policy otomatis dengan exponential backoff dan Dead Letter Queue (DLQ) `[Status: TODO]`

### 3.5 File Upload & Storage Service
- [ ] **STR-01**: Abstraksi klien object storage (S3 / Cloudflare R2 / MinIO) dengan kredensial dari environment variable `[Status: TODO]`
- [ ] **STR-02**: Generator Presigned URL untuk upload langsung dari klien (metode PUT, TTL 15 menit) `[Status: TODO]`
- [ ] **STR-03**: Validasi server-side: pemeriksaan MIME-type berbasis magic bytes (bukan hanya ekstensi file) `[Status: TODO]`
- [ ] **STR-04**: Enkripsi berkas sensitif pada saat *at-rest* (AES-256-GCM streaming) sebelum penyimpanan `[Status: TODO]`

### 3.6 Email & Notifications Dispatcher
- [ ] **NOTIF-01**: Integrasi transport email transaksional (Resend / SendGrid / SES SDK) `[Status: TODO]`
- [ ] **NOTIF-02**: Template HTML email transaksional (Verifikasi email, reset password, invoice payment, notifikasi tugas) `[Status: TODO]`
- [ ] **NOTIF-03**: In-app notifications table & endpoint retrieval (`GET /api/v1/notifications`, `PATCH mark-as-read`) `[Status: TODO]`
- [ ] **NOTIF-04**: Webhook handler untuk menangani event bounce, delivery failure, dan spam report dari provider email `[Status: TODO]`

---

## 4. Frontend Development Progress Checklist

### 4.1 Component Library & Design System Setup
- [ ] **FE-01**: Sinkronisasi token desain dengan `DESIGN_SYSTEM.md` (Warna zinc/neutral, font Inter, radius border) `[Status: TODO]`
- [ ] **FE-02**: Pemasangan komponen primitif atomik (Button, Input, Select, Checkbox, Textarea, Badge, Avatar) `[Status: TODO]`
- [ ] **FE-03**: Pemasangan komponen feedback (Alert, Modal/Dialog, Toast sonner/toast, Drawer, Popover) `[Status: TODO]`
- [ ] **FE-04**: Pemasangan komponen navigasi (Navbar, Sidebar collapsible, Breadcrumbs, Tab navigation) `[Status: TODO]`
- [ ] **FE-05**: Pemasangan komponen data display (DataTable dengan sorting/pagination, StatCard, EmptyState) `[Status: TODO]`
- [ ] **FE-06**: Pengujian aksesibilitas komponen (WCAG AA contrast ratio 4.5:1, keyboard tab focus ring, ARIA) `[Status: TODO]`

### 4.2 Pages & Routing Architecture
- [ ] **FE-07**: Route root & Layout publik (Landing page, Terms, Privacy, FAQ) `[Status: TODO]`
- [ ] **FE-08**: Route group autentikasi `(auth)` (Login, Register, Forgot Password, Reset Password, Verify Email) `[Status: TODO]`
- [ ] **FE-09**: Route group aplikasi `(app)` atau `(dashboard)` dengan auth guard wrapper & persistent layout `[Status: TODO]`
- [ ] **FE-10**: Halaman index dashboard (Statistik ringkas, daftar aktivitas terkini, quick actions) `[Status: TODO]`
- [ ] **FE-11**: Halaman list entitas dengan dynamic search & pagination query parameters `[Status: TODO]`
- [ ] **FE-12**: Halaman detail entitas (`/resources/[id]`) dan halaman pembuatan/pengeditan formulir `[Status: TODO]`
- [ ] **FE-13**: Halaman pengaturan pengguna & organisasi (`/settings/profile`, `/settings/billing`, `/settings/team`) `[Status: TODO]`
- [ ] **FE-14**: Halaman error defensif kustom (Halaman `404 Not Found` dan `500 Server Error` dengan tombol kembali) `[Status: TODO]`

### 4.3 State Management
- [ ] **FE-15**: Setup Server-State management (TanStack Query / SWR / Server Action caching) dengan TTL terkonfigurasi `[Status: TODO]`
- [ ] **FE-16**: Setup Client-State store (Zustand / Pinia / React Context) untuk state UI global (sidebar open, theme) `[Status: TODO]`
- [ ] **FE-17**: Sinkronisasi state URL dengan parameter pencarian (tabel filters, tabs aktif, page numbers) `[Status: TODO]`
- [ ] **FE-18**: Invalidation policy: otomatis trigger refetch setelah mutasi (create/update/delete) berhasil `[Status: TODO]`

### 4.4 Form Handling & Validation
- [ ] **FE-19**: Pemasangan form handler (React Hook Form / Formik / Native Forms) pada seluruh form input `[Status: TODO]`
- [ ] **FE-20**: Integrasi validasi skema Zod di sisi klien (single source of truth dari shared validation schema) `[Status: TODO]`
- [ ] **FE-21**: Penanganan error inline di bawah setiap input field yang gagal validasi `[Status: TODO]`
- [ ] **FE-22**: Form submission safeguards: disable tombol submit dan tampilkan loading indicator saat request berjalan `[Status: TODO]`

### 4.5 API Integration & Wiring
- [ ] **FE-23**: Setup API client wrapper (`fetch` wrapper / Axios instance) dengan interceptor auth & error handling `[Status: TODO]`
- [ ] **FE-24**: Penanganan rotasi refresh token otomatis ketika menerima respons `401 Unauthorized` `[Status: TODO]`
- [ ] **FE-25**: Implementasi upload berkas langsung ke cloud via presigned URL dengan progress bar `[Status: TODO]`
- [ ] **FE-26**: Implementasi optimistic UI update untuk interaksi instan pengguna (toggle switch, bookmark, like) `[Status: TODO]`

### 4.6 The 5 UI States Implementation (Defensive UI)
- [ ] **UI-01**: **Idle State**: Tampilan default elemen dan form dalam kondisi bersih dan siap digunakan `[Status: TODO]`
- [ ] **UI-02**: **Loading State**: Skeleton loader berdimensi presisi (bukan spinner layar penuh generik) `[Status: TODO]`
- [ ] **UI-03**: **Success State**: Notifikasi toast sukses, feedback visual, dan redirect otomatis yang mulus `[Status: TODO]`
- [ ] **UI-04**: **Error State**: Inline error alert, pesan kesalahan ramah pengguna, dan tombol "Coba Lagi" (Retry) `[Status: TODO]`
- [ ] **UI-05**: **Empty State**: Ilustrasi/ikon kontekstual, deskripsi situasi, dan tombol CTA jelas (misal: "Buat Item Pertama") `[Status: TODO]`

---

## 5. Third-Party & Infrastructure Integration Checklist

### 5.1 Payment Gateway Integration (Stripe / Midtrans)
- [ ] **PAY-01**: Kredensial sandbox/test mode dikonfigurasi aman pada `.env` (dilarang commit secret key) `[Status: TODO]`
- [ ] **PAY-02**: Implementasi Checkout Session / Snap Token API untuk inisiasi pembayaran produk/langganan `[Status: TODO]`
- [ ] **PAY-03**: Webhook endpoint dengan validasi tanda tangan kriptografi (Stripe signature / Midtrans SHA512 hash) `[Status: TODO]`
- [ ] **PAY-04**: Idempotency safeguard pada webhook handler: dilarang memproses event ID yang sama berulang kali `[Status: TODO]`
- [ ] **PAY-05**: Sinkronisasi status order/langganan dalam transaksi basis data (`pending` → `paid` → `failed` / `expired`) `[Status: TODO]`
- [ ] **PAY-06**: Customer billing portal / redirect ke riwayat transaksi bagi pengguna `[Status: TODO]`

### 5.2 Transactional Email Service (Resend / SendGrid / SES)
- [ ] **EML-01**: Konfigurasi DNS domain sender terverifikasi (SPF, DKIM, DMARC lolos uji) `[Status: TODO]`
- [ ] **EML-02**: Inisiasi SDK klien email dengan logging fallback pada mode lokal/pengembangan `[Status: TODO]`
- [ ] **EML-03**: Template email autentikasi teruji (Link verifikasi pendaftaran & reset kata sandi) `[Status: TODO]`
- [ ] **EML-04**: Template email transaksi bisnis teruji (Konfirmasi pembayaran, faktur, ringkasan draf) `[Status: TODO]`

### 5.3 Object Storage Integration (Cloudflare R2 / AWS S3)
- [ ] **OBJ-01**: Bucket terisolasi dibuat dengan konfigurasi CORS ketat untuk domain staging & production `[Status: TODO]`
- [ ] **OBJ-02**: IAM policy menggunakan prinsip hak akses minimum (*least-privilege*: hanya put & get sesuai prefix) `[Status: TODO]`
- [ ] **OBJ-03**: Upload direct-to-storage via presigned URL teruji dengan berkas sampel `[Status: TODO]`
- [ ] **OBJ-04**: Download file privat melalui presigned URL bertenggat waktu (TTL 15 menit) `[Status: TODO]`

### 5.4 Analytics Integration (Mixpanel / GA4 / PostHog)
- [ ] **ANA-01**: Inisialisasi SDK analitik dengan dukungan privasi pengguna / cookie consent banner `[Status: TODO]`
- [ ] **ANA-02**: Tracking event alur akuisisi: `user_signed_up`, `user_logged_in` `[Status: TODO]`
- [ ] **ANA-03**: Tracking event nilai inti (*core value event*): `document_created`, `document_signed`, `item_published` `[Status: TODO]`
- [ ] **ANA-04**: Tracking event monetisasi: `checkout_initiated`, `payment_completed` `[Status: TODO]`
- [ ] **ANA-05**: Sanitasi data analitik: DILARANG mengirim data sensitif / PII (kata sandi, nomor kartu, NIK) `[Status: TODO]`

### 5.5 Monitoring & Error Tracking (Sentry)
- [ ] **MON-01**: Sentry DSN terpasang di sisi frontend dan backend runtime `[Status: TODO]`
- [ ] **MON-02**: Konfigurasi `beforeSend` untuk scrubbing data sensitif (header Authorization, cookie, password, nomor kartu) `[Status: TODO]`
- [ ] **MON-03**: Tracking performa & trace tracing (sampling rate: 10% di staging/prod, 100% di error) `[Status: TODO]`
- [ ] **MON-04**: Endpoint health check sistem aktif (`GET /api/healthz` dan `GET /api/readyz`) memantau DB & Redis `[Status: TODO]`

---

## 6. Code Review Milestone Checkpoints

### Checkpoint 1: Scaffolding & Foundation Gate
- **Fokus**: Arsitektur direktori, 7 harness files, skema database, linting, & typing.
- **Waktu Eksekusi**: Setelah Inisiasi Repositori & Migrasi Basis Data Awal.
- **Kriteria Lulus**:
  - [ ] `tsc --noEmit` / linter framework lolos tanpa error dan tanpa toleransi tipe `any`.
  - [ ] Berkas `.env.example` lengkap dengan seluruh variabel yang dibutuhkan kode.
  - [ ] Migrasi database berhasil dieksekusi secara lokal dan seeder data awal masuk.
  - [ ] 7 harness AI (`AGENTS.md`, `CONTEXT.md`, `ARCHITECTURE.md`, `CONVENTIONS.md`, `TODO.md`, `DESIGN.md`, `.env.example`) terpasang di root.
- **Keputusan**: ☐ PASS | ☐ REWORK REQUIRED

### Checkpoint 2: Core Data & Domain Gate (Termin Alpha Gate)
- **Fokus**: Alur autentikasi, entitas bisnis utama, API CRUD, dan integrasi UI dasar.
- **Waktu Eksekusi**: Prasyarat penagihan Termin 2 (Alpha Release - 25% s/d 30%).
- **Kriteria Lulus**:
  - [ ] Autentikasi end-to-end berfungsi (registrasi, login, logout, sesi tersimpan dalam HttpOnly cookie).
  - [ ] Seluruh endpoint CRUD entitas utama berfungsi sesuai spesifikasi FSD.md.
  - [ ] Validasi input Zod terpasang di seluruh endpoint API dan form frontend.
  - [ ] Penegakan isolasi tenant: data user A tidak dapat dibaca atau dimodifikasi oleh user B.
  - [ ] Smoke test lokal tahap 1 lulus 100%.
- **Keputusan**: ☐ PASS | ☐ REWORK REQUIRED (Invoice Termin 2 siap diterbitkan jika PASS)

### Checkpoint 3: Third-Party Integration & Security Gate
- **Fokus**: Payment gateway, file upload terenkripsi, transactional email, dan keamanan.
- **Waktu Eksekusi**: Setelah seluruh layanan eksternal tersambung.
- **Kriteria Lulus**:
  - [ ] Webhook pembayaran berhasil memproses notifikasi sandbox dan kebal duplikasi event (idempotent).
  - [ ] File upload ke cloud storage menggunakan presigned URL dan MIME-type divalidasi dengan magic bytes.
  - [ ] Enkripsi AES-256-GCM berfungsi aktif untuk berkas/data sensitif.
  - [ ] Rate limiting aktif melindungi endpoint login dan endpoint publik.
  - [ ] Audit dependensi (`pnpm audit` / `composer audit`) bebas dari celah kritis (High/Critical).
- **Keputusan**: ☐ PASS | ☐ REWORK REQUIRED

### Checkpoint 4: Release Candidate & Staging Freeze Gate (Termin Beta Gate)
- **Fokus**: Defensive UI (5 states), observabilitas (Sentry), performa query, & kesiapan Modul 07.
- **Waktu Eksekusi**: Prasyarat penagihan Termin 3 (Beta Release - 20% s/d 25%) & handoff ke Modul 07 QA/SIT.
- **Kriteria Lulus**:
  - [ ] Seluruh halaman menerapkan 5 UI States (Idle, Loading skeleton, Success toast, Error inline, Empty state).
  - [ ] Indeks database terverifikasi aktif pada semua foreign key dan filter pencarian (bebas N+1 query).
  - [ ] Sentry / APM aktif menangkap unhandled errors tanpa kebocoran data sensitif.
  - [ ] Local smoke test lengkap (`test:smoke`) berhasil 100% dan lembar `VERIFY_LOCAL.md` telah diisi lengkap.
  - [ ] Seluruh kode ter-merge bersih ke branch `staging` dengan tag `v0.9.0-beta`.
- **Keputusan**: ☐ PASS | ☐ REWORK REQUIRED (Siap Melangkah ke Modul 07)

---

## 7. Matriks Kepatuhan 3 Pilar Rekayasa (Engineering Compliance Matrix)

| Pilar Rekayasa | Aspek yang Diuji | Standar Non-Negosiasi | Status Verifikasi |
|---|---|---|:---:|
| **Pilar 1: Keamanan (Security)** | Proteksi Kredensial | Dilarang hardcode secret, wajib load dari environment variable aman | `[ ] PASS` |
| | Proteksi Autentikasi | Password di-hash Argon2id/Bcrypt; JWT disimpan di HttpOnly SameSite=Lax cookie | `[ ] PASS` |
| | Sanitasi Input | Validasi skema Zod pada setiap input request, bebas SQL Injection & XSS | `[ ] PASS` |
| | Enkripsi Dokumen | Enkripsi AES-256-GCM berbasis stream untuk dokumen sensitif at-rest | `[ ] PASS` |
| **Pilar 2: Performa (Performance)** | Efisiensi Kueri Basis Data | Bebas dari masalah kueri N+1; indeks terpasang pada semua foreign key | `[ ] PASS` |
| | Optimasi Aset UI | Gambar dioptimasi via komponen Image; Dynamic import untuk modul berat | `[ ] PASS` |
| | Caching Strategis | Cache header untuk aset statis, server-state caching dengan revalidation | `[ ] PASS` |
| **Pilar 3: Efisiensi Sumber Daya** | Connection Pooling | Database connection pool terkonfigurasi untuk mencegah exhaustion | `[ ] PASS` |
| | Pemrosesan Stream | Upload/download berkas besar menggunakan streaming (tidak ditampung memori penuh) | `[ ] PASS` |
| | Soft-Delete Terkelola | Data transaksi legal tidak dihapus permanen; menggunakan klausul soft-delete | `[ ] PASS` |

---

## 8. Registry Catatan Kendala, Bug & Hutang Teknis (Defect & Tech Debt Registry)

| ID | Tanggal Ditemukan | Komponen / Endpoint | Deskripsi Isu / Hutang Teknis | Tingkat Keparahan (Low/Med/High/Critical) | Rencana Solusi / Tindakan | Status |
|---|:---:|---|---|:---:|---|:---:|
| `TD-01` | `YYYY-MM-DD` | `Auth Middleware` | Contoh: Belum ada rate limiting pada refresh token | `Medium` | Tambahkan Redis sliding window limit | `TODO` |
| `TD-02` | `YYYY-MM-DD` | `Document Table` | Contoh: Query lambat saat data > 5.000 baris | `High` | Tambahkan composite index pada `(tenant_id, created_at)` | `TODO` |

---

## 9. Lembar Pengesahan Pra-QA (Pre-QA Local Sign-Off)

Sebelum membuka Modul 07 (Quality Assurance & SIT di Lingkungan Staging), pastikan seluruh item di bawah ini telah ditandatangani oleh solo developer:

- [ ] Seluruh 4 pos pemeriksaan code review (Checkpoint 1 s/d 4) berstatus **PASS**.
- [ ] Build lokal bersih tanpa peringatan kompilasi fatal (`npm run build` exit code 0).
- [ ] Lembar `VERIFY_LOCAL.md` terisi bukti pengujian mandiri dan tersimpan di repositori.
- [ ] Commit terakhir di branch `staging` telah diberi tag versi release candidate (contoh: `git tag -a v0.9.0-beta -m "Beta release for QA"`).
- [ ] Klien telah menerima laporan kemajuan Termin 2 / Termin 3 sesuai target milestone.

**Status Akhir Modul 06**: ☐ **LOLOS KE MODUL 07** | ☐ **BELUM LOLOS (PERBAIKI DAFTAR DI ATAS)**  
**Tanggal Pengesahan**: `[YYYY-MM-DD]`  
**Tanda Tangan Pengembang**: `[Nama Solo Developer]`
