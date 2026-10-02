# QA & Testing Phase TODO Template (Modul 07 - Modul 09)

> Template daftar tugas atomik untuk fase Quality Assurance, System Integration Testing (SIT), Audit Keamanan Siber, Verifikasi Migrasi Data, dan User Acceptance Testing (UAT) bersama Klien.
> Aturan: Kerjakan pengujian secara defensif. Setiap skenario uji harus didukung asersi otomatis atau bukti log/tangkapan layar sebelum centang `[x]`. Fase ini wajib mencapai kriteria 0 cacat kritis/tinggi (Zero P1/P2 Defects) sebelum diizinkan melangkah ke Deployment Produksi.

---

## Metadata Pengujian
- **Nama Sistem**: [Nama Sistem / Aplikasi]
- **Target URL Lingkungan Staging**: `https://staging.domain.com`
- **Lead QA Engineer / Solo Dev**: [Nama Anda]
- **Klien UAT Representative**: [Nama PIC Klien]
- **Tanggal Mulai QA**: [YYYY-MM-DD]
- **Target Selesai UAT**: [YYYY-MM-DD]
- **Status Gerbang QA/UAT**: [ ] TESTING IN PROGRESS | [ ] UAT UNDER REVIEW | [ ] PASSED & SIGNED-OFF

---

## 1. Modul 07: Penulisan Uji Otomatis & Strategi QA (Test Writing)

### 1.1 Perencanaan Strategi Pengujian (Test Plan)
- [ ] `qa/test-plan.md`: Dokumentasikan Rencana Pengujian Komprehensif (Scope of Testing, In-Scope vs Out-of-Scope, Lingkungan Uji Staging, Matriks Browser/Perangkat: Chrome, Safari, Firefox, iOS, Android) - expect cakupan pengujian terdokumentasi jelas
- [ ] `qa/test-plan.md`: Definisikan Kriteria Masuk (*Entry Criteria*: build staging hijau, migrasi DB tuntas) dan Kriteria Keluar (*Exit Criteria*: 100% test case dieksekusi, 0 P1/P2 defect, test coverage target tercapai) - expect ambang batas kualitas terdefinisi
- [ ] `qa/test-matrix.md`: Susun Matriks Keterlacakan Kebutuhan (*Traceability Matrix*) yang memetakan setiap User Story dari Modul 02 ke nomor Test Case spesifik - expect setiap fitur terikat minimal 1 skenario uji positif dan 1 skenario uji negatif

### 1.2 Penulisan Uji Unit (Unit Testing)
- [ ] `tests/unit/utils/*.test.ts`: Tulis pengujian unit untuk fungsi murni, kalkulasi matematis, utilitas tanggal/waktu, dan format mata uang - expect 100% branch coverage pada utilitas kritis
- [ ] `tests/unit/validation/*.test.ts`: Tulis pengujian unit untuk skema parser Zod / Yup / Joi (uji string kosong, karakter ilegal, panjang batas minimum/maksimum, format email/telepon abnormal) - expect seluruh validasi input menolak data invalid dengan pesan error terstruktur
- [ ] `tests/unit/domain/*.test.ts`: Tulis pengujian unit untuk logika aturan bisnis murni terisolasi (diskon, perhitungan pajak, permission role checker, transisi state machine) - expect logika bisnis lolos pengujian tanpa dependensi basis data eksternal
- [ ] Jalankan runner uji unit: `pnpm test:unit --coverage` - expect target coverage kode domain mencapai minimal >= 80%

### 1.3 Penulisan Uji Integrasi (Integration Testing)
- [ ] `tests/integration/auth/*.test.ts`: Tulis uji integrasi alur login, logout, refresh token, session expiry, dan proteksi middleware cookie HttpOnly - expect kode status HTTP 200, 401, 403 terverifikasi akurat
- [ ] `tests/integration/api/*.test.ts`: Tulis uji integrasi CRUD endpoint REST API dengan basis data test terisolasi (Testcontainers / Postgres SQLite in-memory) - expect transaksi database ACID terverifikasi (commit & rollback)
- [ ] `tests/integration/webhooks/*.test.ts`: Tulis pengujian penerimaan webhook pihak ketiga dengan mocking payload bertanda tangan HMAC-SHA256 valid dan invalid - expect respon 200 OK untuk payload valid dan 401 Unauthorized untuk signature palsu
- [ ] `tests/integration/storage/*.test.ts`: Tulis pengujian upload file, verifikasi MIME type, batasan ukuran maksimum file, dan presigned URL generator - expect file berhasil tersimpan di object storage staging

### 1.4 Penulisan Uji End-to-End (E2E Automated Testing)
- [ ] `tests/e2e/auth.spec.ts`: Buat skrip uji E2E (Playwright / Cypress) untuk alur registrasi, verifikasi email, login, dan reset password - expect alur selesai hingga mendarat di dashboard pengguna
- [ ] `tests/e2e/core-workflow.spec.ts`: Buat skrip uji E2E untuk alur inti bisnis (*Core Transaction Loop*) dari awal hingga akhir tanpa intervensi manual - expect simulasi alur end-to-end 100% hijau di lingkungan headless CI
- [ ] `tests/e2e/edge-cases.spec.ts`: Buat pengujian untuk skenario ekstrim: submit ganda (*double-click submission*), back-button browser saat form kotor, sesi habis di tengah transaksi, dan form berukuran sangat besar - expect aplikasi menangani kondisi tanpa crash atau duplikasi rekaman data
- [ ] Jalankan runner uji E2E: `pnpm test:e2e` - expect seluruh skenario E2E kritis berhasil tanpa flakiness

---

## 2. Modul 07: Eksekusi SIT, Beban, & Manajemen Cacat (SIT Execution)

### 2.1 Eksekusi System Integration Testing (SIT)
- [ ] `qa/sit-execution-log.md`: Jalankan seluruh skenario SIT di lingkungan Staging yang identik dengan arsitektur Produksi - expect 100% skenario tereksekusi dan tercatat
- [ ] `qa/sit-execution-log.md`: Uji integrasi multi-layanan (Sinkronisasi Database <-> Redis Cache <-> Background Worker Queue <-> Eksternal Gateway) - expect antrean job BullMQ terproses tanpa orphan jobs
- [ ] `qa/sit-cross-browser.md`: Lakukan pengujian lintas browser (Chrome, Edge, Safari, Firefox) dan responsivitas layar (Desktop 1920x1080, Laptop 1366x768, Tablet iPad, Mobile 375px) - expect konsistensi visual dan fungsional di seluruh viewport

### 2.2 Uji Kinerja & Beban Sistem (Performance & Load Testing)
- [ ] `tests/load/k6-script.js`: Buat skrip uji beban k6 / Artillery untuk menguji endpoint terpadat dengan target 50-100 Concurrent Virtual Users (VUs) - expect skrip mencakup tahapan ramp-up, steady state, dan ramp-down
- [ ] `qa/performance-report.md`: Eksekusi uji beban dan ukur metrik performa sistem:
  - Nilai latency p95: target < 500 ms untuk query standar, < 1500 ms untuk transaksi berat
  - Nilai latency p99: target < 2000 ms
  - Error rate: target < 0.1% pada beban puncak
  - Utilisasi CPU & RAM server basis data: tidak melampaui 80%
  - expect sistem tidak mengalami deadlock, connection pool starvation, atau restart mendadak
- [ ] `qa/lighthouse-report.html`: Jalankan Google Lighthouse audit pada halaman publik dan dashboard utama - expect skor Performance >= 85, Accessibility >= 90, Best Practices >= 90, SEO >= 90

### 2.3 Pelaporan & Triase Cacat (Defect Triage & Severity)
- [ ] `qa/defect-tracker.md`: Catat setiap bug yang ditemukan dengan struktur baku: ID Cacat, Judul, Langkah Reproduksi, Hasil Aktual, Hasil yang Diharapkan, Tangkapan Layar / Log, Severity, Priority, Status - expect deskripsi reproduktifitas jelas
- [ ] Terapkan klasifikasi tingkat keparahan cacat:
  - **P1 - Blocker**: Sistem crash, data rusak/hilang, kebocoran data, alur transaksi utama terputus total tanpa workaround
  - **P2 - Critical**: Fitur bisnis utama gagal, namun ada workaround sementara yang rumit
  - **P3 - Major**: Fitur sekunder tidak berfungsi sesuai spesifikasi, fungsionalitas utama tetap aman
  - **P4 - Minor / Trivial**: Ketidaksesuaian visual minor, typo teks, misalignment padding < 4px
  - expect seluruh cacat terklasifikasi secara objektif
- [ ] `qa/defect-tracker.md`: Lakukan perbaikan bug dan re-test verifikasi - expect seluruh cacat P1 dan P2 terselesaikan (Zero P1/P2 Defects) sebelum gerbang UAT dibuka

---

## 3. Modul 07 & 05B: Audit Keamanan Siber & Kepatuhan Data (Security Audit)

### 3.1 Audit Dependensi & Pemindaian Kode Statis (Supply-Chain & SAST)
- [ ] `qa/security/dependency-scan.txt`: Jalankan pemindai dependensi package: `pnpm audit --audit-level=high` atau Snyk - expect 0 kerentanan tingkat Critical atau High pada dependensi pihak ketiga
- [ ] `qa/security/secret-scan.txt`: Jalankan pemindaian kredensial dan secret bocor di riwayat git menggunakan TruffleHog atau Gitleaks: `gitleaks detect --verbose` - expect nol private key, token API, atau password yang ter-commit ke dalam repositori
- [ ] `qa/security/sast-report.txt`: Jalankan analisis statis keamanan kode menggunakan Semgrep atau SonarQube - expect nol temuan injeksi atau pola koding berbahaya

### 3.2 Checklist Pengujian OWASP Top 10
- [ ] `qa/security/owasp-checklist.md`: **A01: Broken Access Control (BOLA/IDOR)** - Uji akses manipulasi ID pada parameter URL/body menggunakan token akun lain - expect akses ditolak dengan respon 403 Forbidden
- [ ] `qa/security/owasp-checklist.md`: **A02: Cryptographic Failures** - Verifikasi enkripsi kata sandi menggunakan Argon2id atau bcrypt (cost factor >= 12), enkripsi file rahasia dengan AES-256-GCM, dan seluruh lalu lintas data wajib TLS 1.3 - expect hash aman dan SSL grade A di SSL Labs
- [ ] `qa/security/owasp-checklist.md`: **A03: Injection (SQLi, NoSQLi, XSS)** - Uji coba injeksi SQL payload (`' OR '1'='1`) dan payload XSS (`<script>alert(1)</script>`) pada seluruh form input - expect input otomatis disanitasi dan kueri ORM sepenuhnya parameterized
- [ ] `qa/security/owasp-checklist.md`: **A04: Insecure Design & Rate Limiting** - Uji pembatasan laju (*rate limiting*) pada endpoint login, forgot password, dan checkout (uji tembak 20 request/detik) - expect respon HTTP 429 Too Many Requests aktif
- [ ] `qa/security/owasp-checklist.md`: **A05: Security Misconfiguration** - Pastikan mode `NODE_ENV=production`, stack trace dinonaktifkan dari respon publik, dan default credentials server diubah - expect pesan error generik terstruktur
- [ ] `qa/security/owasp-checklist.md`: **A07: Identification & Auth Failures** - Uji proteksi brute-force (akun terkunci sementara setelah 5x gagal), session fixation direset saat login, dan cookie flag `HttpOnly, Secure, SameSite=Strict` terpasang - expect token tidak dapat diakses via JavaScript console
- [ ] `qa/security/owasp-checklist.md`: **A08: Software & Data Integrity** - Verifikasi integritas dokumen/file sensitif menggunakan hash kriptografis SHA-256 - expect checksum tervalidasi sebelum parsing file
- [ ] `qa/security/owasp-checklist.md`: **A09: Security Logging & Monitoring** - Pastikan setiap event kritis (login gagal, perubahan role admin, penghapusan data masal) tercatat di audit log server dengan timestamp UTC dan IP - expect jejak audit lengkap
- [ ] `qa/security/owasp-checklist.md`: **A10: Server-Side Request Forgery (SSRF)** - Uji endpoint yang menerima URL eksternal dengan memasukkan alamat internal (`http://127.0.0.1`, `http://169.254.169.254`) - expect permintaan ke subnet internal diblokir

### 3.3 Verifikasi HTTP Security Headers
- [ ] `qa/security/http-headers.md`: Uji respon header keamanan di staging via `curl -I https://staging.domain.com`:
  - `Strict-Transport-Security: max-age=31536000; includeSubDomains; preload`
  - `X-Content-Type-Options: nosniff`
  - `X-Frame-Options: DENY` (anti-clickjacking)
  - `Referrer-Policy: strict-origin-when-cross-origin`
  - `Content-Security-Policy: default-src 'self' ...`
  - expect seluruh header keamanan standar terdeteksi aktif

---

## 4. Modul 08: Verifikasi Migrasi & Seeding Data (Data Migration Verification)

### 4.1 Dry-Run Migrasi Data di Staging
- [ ] `data-migration/migration-dry-run-plan.md`: Susun runbook urutan eksekusi skrip ETL (Extract, Transform, Load) dari sistem lama ke skema baru - expect tahapan eksekusi urut per tabel referensi
- [ ] `data-migration/scripts/`: Jalankan skrip sanitasi dan transformasi data sampel riil dari sistem lama - expect karakter aneh, format tanggal inkonsisten, dan duplikasi data ternormalisasi
- [ ] Eksekusi migrasi di staging: `pnpm run migrate:staging` - expect proses migrasi tuntas tanpa error constraint foreign key

### 4.2 Laporan Rekonsiliasi Data (Reconciliation Report)
- [ ] `data-migration/reconciliation-report.md`: Cocokkan jumlah total rekaman data per tabel sumber vs tabel target (`COUNT(*) source == COUNT(*) target`) - expect varians perbedaan 0%
- [ ] `data-migration/reconciliation-report.md`: Lakukan verifikasi integritas data finansial/angka akumulasi (`SUM(amount) source == SUM(amount) target`) - expect tidak ada selisih satu sen pun
- [ ] `data-migration/reconciliation-report.md`: Uji coba skenario rollback migrasi data ke titik sebelum migrasi - expect prosedur rollback berhasil mengembalikan database ke kondisi awal secara bersih

---

## 5. Modul 09: Fasilitasi UAT Bersama Klien (UAT Facilitation)

### 5.1 Persiapan Lingkungan & Lembar Kerja UAT
- [ ] `uat/uat-workbook.xlsx` (atau `uat/UAT_SCENARIOS.md`): Buat lembar kerja skenario UAT berbasis bahasa bisnis pengguna (bukan bahasa koding):
  - ID Skenario UAT
  - Peran Pengguna (Role: Admin, Kasir, Pengguna Biasa)
  - Prasyarat Skenario
  - Panduan Langkah Aksi Langkah demi Langkah
  - Kriteria Hasil yang Diharapkan
  - Kolom Hasil Klien: [LULUS / GAGAL / CATATAN]
  - expect seluruh use-case bisnis di SOW Modul 03 terwakili
- [ ] `uat/environment-setup.md`: Siapkan akun uji terisolasi untuk masing-masing perwakilan tim klien (kredensial kredensial role lengkap) dan muat data dummy yang realistis - expect sistem siap digunakan tanpa konfigurasi manual oleh klien

### 5.2 Kickoff & Pendampingan UAT
- [ ] Gelar sesi pertemuan Kickoff UAT daring/tatap muka: demonstrasikan alur navigasi aplikasi dan jelaskan cara mengisi formulir UAT Workbook - expect tim penguji klien memahami prosedur pengujian
- [ ] Tetapkan jendela waktu UAT resmi (standar: 3-5 hari kerja kalender) sesuai kontrak SOW - expect batas waktu pengumpulan feedback disepakati kedua belah pihak
- [ ] Buka kanal komunikasi siaga (Grup WhatsApp/Slack terdedikasi) untuk merespons pertanyaan pengguna secara cepat selama periode pengujian - expect response time < 30 menit pada jam kerja

### 5.3 Triase Temuan UAT & Negosiasi Scope (Defect vs Change Request)
- [ ] `uat/uat-defect-log.md`: Kumpulkan seluruh catatan temuan dari tim klien setiap sore hari - expect seluruh masukan terdokumentasi rapi
- [ ] Jalankan sesi triase harian bersama PIC Klien:
  - Klasifikasikan temuan: Apakah ini **Bug / Penyimpangan dari SOW** (wajib diperbaiki segera tanpa biaya tambahan) atau **Permintaan Baru / Change Request** (dicatat untuk roadmap fase berikutnya atau dikenakan biaya CR)
  - expect kesepakatan tegas agar terhindar dari pemekaran fitur (*scope creep*) di penghujung proyek
- [ ] Perbaiki seluruh bug UAT yang telah disepakati dan deploy hotfix ke staging - expect verifikasi ulang disaksikan oleh penguji klien

### 5.4 Penandatanganan Berita Acara UAT (UAT Sign-off)
- [ ] Pastikan 100% skenario UAT berstatus LULUS (PASS) dan tidak ada cacat berkategori P1/P2 yang masih berstatus OPEN - expect lembar kerja UAT bersih
- [ ] `uat/BAST_UAT_SIGNOFF.pdf`: Terbitkan dokumen formal Berita Acara UAT Sign-off - expect dokumen ditandatangani basah / digital certificate oleh Project Sponsor atau Product Owner Klien

---

## 6. Gerbang Verifikasi Kelolosan Fase QA/UAT (Gate Pass QA to Deployment)

| Parameter Evaluasi | Standar Minimum Kelolosan | Status Verifikasi | Catatan Bukti |
| :--- | :--- | :---: | :--- |
| **Cakupan Uji Otomatis** | Unit & Integration test lolos 100%, coverage >= 80%, E2E alur inti hijau | [ ] PASS | Dilampirkan laporan `pnpm test` |
| **Bebas Cacat Kritis** | Zero P1 (Blocker) & Zero P2 (Critical) defects di staging | [ ] PASS | Dilampirkan `qa/defect-tracker.md` |
| **Kinerja & Beban** | Latency p95 < 500ms, Error rate < 0.1% pada uji beban VUs | [ ] PASS | Dilampirkan `qa/performance-report.md` |
| **Audit Keamanan** | OWASP Top 10 lolos, pnpm audit 0 Critical/High, 0 secret leak | [ ] PASS | Dilampirkan `qa/security/` |
| **Rekonsiliasi Data** | Migrasi dry-run sukses, selisih rekaman data 0% | [ ] PASS | Dilampirkan `data-migration/reconciliation-report.md` |
| **UAT Sign-off Formal** | Dokumen persetujuan UAT ditandatangani oleh pemangku kepentingan klien | [ ] PASS | Dilampirkan `uat/BAST_UAT_SIGNOFF.pdf` |

### Keputusan Gerbang QA:
- [ ] **LULUS (GO TO PRODUCTION DEPLOYMENT - M10)**: Seluruh pengujian lolos, audit keamanan bersih, dan klien telah menandatangani UAT Sign-off. Sistem siap rilis ke Lingkungan Produksi.
- [ ] **TAHAN (HOLD / BLOCKING DEFECT)**: Masih ditemukan cacat P1/P2 atau celah keamanan tingkat tinggi. Dilarang keras melakukan rilis ke produksi!
- [ ] **REVISI UAT (HOLD / CLIENT RE-TEST)**: Klien belum menyelesaikan seluruh skenario uji atau meminta perbaikan fungsionalitas inti. Jadwalkan pengujian ulang.
