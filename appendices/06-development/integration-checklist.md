# Integration Checklist (Third-Party Services)

**Module**: M06 Development Execution  
**Purpose**: Sequential checklist untuk integrating payment gateways, email services, storage, analytics

**Use with**: Stripe, Midtrans, SendGrid, Resend, AWS S3, Sentry, Mixpanel

---

## 1. Payment Gateway (Stripe / Midtrans)

### Sandbox Setup
- [ ] **Setup Lingkungan Sandbox**:
  - [ ] Daftarkan akun developer sandbox Stripe / Midtrans.
  - [ ] Pasang API keys test mode di `.env` (`STRIPE_SECRET_KEY=sk_test_...`, `STRIPE_WEBHOOK_SECRET=whsec_...`).
  - [ ] Verifikasi tidak ada kunci production (`sk_live_...`) yang bocor di branch `staging`.

### Transaction Initiation
- [ ] **Inisiasi Transaksi Pembayaran**:
  - [ ] Buat endpoint API pembuat Checkout Session (Stripe) atau Snap Token (Midtrans).
  - [ ] Simpan nomor referensi order di tabel transaksi lokal dengan status awal `pending`.

### Webhook Endpoint
- [ ] **Webhook Endpoint Kriptografis**:
  - [ ] Endpoint `POST /api/v1/webhooks/payment` dengan raw body parser.
  - [ ] Validasi tanda tangan kriptografis webhook (`stripe.webhooks.constructEvent` atau Midtrans SHA512 signature check).
  - [ ] Tolak langsung request dengan HTTP 400 jika tanda tangan tidak cocok.

### Idempotency
- [ ] **Penanganan Idempotensi Webhook**:
  - [ ] Catat setiap event ID yang masuk di tabel `webhook_events`.
  - [ ] Jika event ID sudah pernah diproses sebelumnya, return HTTP 200 instan tanpa mengeksekusi ulang mutasi bisnis.

### Status Transition
- [ ] **Transisi Status Transaksi Atomik**:
  - [ ] Bungkus pembaruan status order (`paid`, `failed`, `expired`) dan aktivasi fitur pengguna dalam transaksi basis data (`db.$transaction`).
  - [ ] Kirim email konfirmasi tanda terima pembayaran ke user secara asinkron.

---

## 2. Transactional Email Service (SendGrid / Resend)

### DNS Verification
- [ ] **Verifikasi DNS Domain**:
  - [ ] Konfigurasi record DNS pengirim: SPF (`v=spf1`), DKIM, dan DMARC (`p=reject` atau `p=quarantine`).
  - [ ] Verifikasi domain terkonfirmasi aktif pada dashboard Resend / SendGrid.

### Email Client
- [ ] **Klien Email Terisolasi**:
  - [ ] Buat modul layanan `email.service.ts` yang mengenkapsulasi pengiriman email.
  - [ ] Pada environment `development`, cetak isi email ke terminal log atau gunakan layanan uji (Mailpit / Inbucket) daripada mengirim email sungguhan.

### Automated Alerts
- [ ] **Automated Alerts & Receipts**:
  - [ ] Kirim email transaksi penting dengan menyertakan attachment PDF bukti bayar / dokumen legal.
  - [ ] Pasang header `List-Unsubscribe` dan tautan berhenti berlangganan pada email pemberitahuan reguler.

---

## 3. File Storage (AWS S3 / Cloudflare R2)

### Bucket Configuration
- [ ] **Konfigurasi Bucket & CORS**:
  - [ ] Buat bucket storage dengan nama unik per environment (`myproject-staging-vault`, `myproject-prod-vault`).
  - [ ] Matikan opsi akses publik langsung (*Block Public Access: ON*). Seluruh akses wajib melalui presigned URL atau backend proxy.
  - [ ] Konfigurasi CORS bucket hanya mengizinkan origin aplikasi web resmi dengan method `GET`, `PUT`, `HEAD`.

### IAM Credentials
- [ ] **Kredensial Hak Akses Minimum (Least-Privilege)**:
  - [ ] Buat IAM user / API token R2 khusus aplikasi dengan permission hanya `s3:PutObject` dan `s3:GetObject` pada prefix bucket terkait.
  - [ ] Jangan gunakan kredensial Root AWS / Cloudflare Admin.

### Lifecycle Policies
- [ ] **Lifecycle Policies**:
  - [ ] Pasang aturan lifecycle bucket untuk otomatis menghapus upload parsial yang terputus (*abort incomplete multipart uploads* setelah 7 hari).

---

## 4. Product Analytics (Mixpanel / GA4 / PostHog)

### Privacy Compliance
- [ ] **Inisialisasi Patuh Privasi (UU PDP & GDPR)**:
  - [ ] Inisialisasi SDK analitik hanya setelah pengguna memberikan izin (*consent banner*).
  - [ ] Pasang flag DNT (*Do Not Track*) support.

### Core Telemetry
- [ ] **Pelacakan Event Inti (Core Telemetry Mapping)**:
  - [ ] Track alur akuisisi: `auth_signup_completed`, `auth_login_succeeded`.
  - [ ] Track nilai inti aplikasi (*North Star action*): `document_created`, `document_exported`, `payment_completed`.
  - [ ] Resolusi identitas: tautkan anonymous ID ke ID pengguna resmi setelah login (`posthog.identify(userId)`).

### Data Scrubbing
- [ ] **Scrubbing Data Sensitif**:
  - [ ] Pastikan payload analitik TIDAK memuat PII sensitif (nama lengkap, NIK, alamat lengkap, kata sandi, detail kartu kredit).

---

## 5. Application Monitoring & Error Tracking (Sentry)

### SDK Installation
- [ ] **Pemasangan Sentry SDK**:
  - [ ] Pasang Sentry SDK di sisi client (Next.js client / Vite) dan server runtime (Node.js / Python / Laravel).
  - [ ] Atur environment tag (`staging`, `production`) dan release tag sesuai commit SHA git (`git rev-parse HEAD`).

### Data Scrubbing
- [ ] **Scrubbing Data Sensitif (beforeSend Filter)**:
  - [ ] Pasang hook `beforeSend` untuk membersihkan header `Authorization`, cookie sesi, nilai password, dan query parameter sensitif dari stack trace.

### Performance Tracing
- [ ] **Performance Tracing & Slow Query Alerts**:
  - [ ] Atur trace sample rate (100% pada staging untuk evaluasi, 10% pada production).
  - [ ] Konfigurasikan threshold peringatan jika kueri database memakan waktu > 500ms atau respon API > 2.000ms.

### Health Checks
- [ ] **Health Check Endpoints**:
  - [ ] Buat endpoint `GET /api/healthz` (liveness check) yang merespons status `OK`.
  - [ ] Buat endpoint `GET /api/readyz` (readiness check) yang memverifikasi koneksi aktif ke PostgreSQL dan Redis.

---

## Verification Checklist

Before merging to staging:

### Payment Gateway
- [ ] Sandbox payment flow tested (create order → redirect → webhook received)
- [ ] Webhook signature validation working (reject invalid signatures)
- [ ] Order status transitions correctly (pending → paid → fulfilled)
- [ ] Idempotency prevents duplicate processing
- [ ] Receipt emails sent automatically

### Email Service
- [ ] DNS records verified (SPF, DKIM, DMARC)
- [ ] Test emails delivered successfully
- [ ] Email templates render correctly (HTML + plain text)
- [ ] Unsubscribe links functional
- [ ] Dev environment uses mock/logger (not real sends)

### File Storage
- [ ] Bucket CORS configured correctly
- [ ] Presigned URLs work for upload/download
- [ ] File size/type validation enforced
- [ ] Public access blocked (all files private)
- [ ] Lifecycle policies active (cleanup incomplete uploads)

### Analytics
- [ ] Consent banner functional (analytics only after approval)
- [ ] Core events tracking (signup, login, North Star actions)
- [ ] No PII in analytics payloads
- [ ] Identity resolution working (anonymous → user ID)

### Monitoring
- [ ] Sentry capturing errors (client + server)
- [ ] Sensitive data scrubbed from error reports
- [ ] Performance traces collected
- [ ] Health check endpoints responding
- [ ] Alerts configured (slow queries, high error rate)

---

**See Also**:
- `appendices/06-development/backend-checklist.md` - Backend development
- `appendices/06-development/frontend-checklist.md` - Frontend development
- `patterns/security/authentication.md` - Auth patterns
- `patterns/performance/caching-strategies.md` - Performance optimization
- M06 Development Execution - Core module documentation
