# Deployment & Handover Phase TODO Template (Modul 10 - Modul 11)

> Template daftar tugas atomik untuk fase Rilis Produksi (Go-Live), Verifikasi Pasca-Deployment, Serah Terima Sistem (Handover), dan Penandatanganan BAST Final bersama Klien.
> Aturan: Eksekusi deployment dengan disiplin tinggi sesuai runbook. Dilarang melakukan perubahan manual mendadak (*cowboy deployments*) di server produksi. Setiap langkah harus memiliki bukti asersi dan prosedur rollback yang siap dieksekusi sewaktu-waktu.

---

## Metadata Deployment & Serah Terima
- **Nama Sistem**: [Nama Sistem / Aplikasi]
- **Target URL Produksi**: `https://app.domainklien.com`
- **Lead Release Engineer / Solo Dev**: [Nama Anda]
- **PIC Teknis & Bisnis Klien**: [Nama PIC Klien]
- **Jendela Waktu Deployment (Maintenance Window)**: [YYYY-MM-DD HH:mm - HH:mm WIB]
- **Metode Deployment**: Blue/Green | Canary | Rolling Update | Container Service
- **Status Gerbang Rilis**: [ ] PRE-FLIGHT | [ ] DEPLOYING | [ ] VERIFIED LIVE | [ ] HANDOVER COMPLETED

---

## 1. Modul 10: Pemeriksaan Pra-Penerbangan (Pre-Flight Checks)

### 1.1 Persiapan Tim & Jendela Pemeliharaan
- [ ] `deploy/pre-flight-checklist.md`: Tetapkan jendela waktu rilis (*maintenance window*) di jam lalu lintas terendah (misal: Sabtu/Minggu pukul 23:00 - 03:00 WIB) - expect kesepakatan jadwal tertulis dengan klien
- [ ] `deploy/pre-flight-checklist.md`: Kirimkan pemberitahuan resmi pemeliharaan terjadwal (*maintenance notification banner/email*) kepada pengguna 48 jam dan 2 jam sebelum rilis - expect pengguna teredukasi
- [ ] `deploy/pre-flight-checklist.md`: Berlakukan *Code Freeze*: kunci branch `main` atau `release` di Git, dilarang melakukan commit fitur baru di luar patch rilis yang telah lolos UAT - expect status branch stabil

### 1.2 Kesiapan Infrastruktur & Jaringan Produksi
- [ ] `deploy/infrastructure-readiness.md`: Verifikasi kapasitas komputasi (CPU, RAM, Disk I/O) server produksi siap menampung beban - expect alokasi resource sesuai dokumen Capacity Planning
- [ ] `deploy/infrastructure-readiness.md`: Konfigurasikan catatan DNS publik (A Record, CNAME, TXT record untuk SPF/DKIM) dengan TTL rendah (300 detik) untuk memfasilitasi propagasi cepat - expect propagasi DNS terpantau aktif
- [ ] `deploy/infrastructure-readiness.md`: Pasang dan verifikasi sertifikat SSL/TLS (Let's Encrypt / Cloudflare Edge Certificate) pada domain utama dan seluruh subdomain - expect validitas sertifikat aktif dan HTTPS dipaksa (*forced HTTPS redirect*)
- [ ] `deploy/infrastructure-readiness.md`: Konfigurasikan Web Application Firewall (WAF) dan proteksi DDoS di Cloudflare / AWS Shield (rate limit rule, bot fight mode) - expect proteksi layer 7 aktif

### 1.3 Audit Variabel Lingkungan & Secret Produksi
- [ ] `deploy/env-audit.md`: Siapkan file konfigurasi lingkungan produksi (`.env.production` atau di dalam Cloud Secret Manager / Doppler / Infisical / AWS Parameter Store) - expect tidak ada nilai placeholder dummy staging yang tersisa
- [ ] `deploy/env-audit.md`: Jalankan validator Zod / schema parser variabel lingkungan: `pnpm run check:env` - expect seluruh variabel wajib terdefinisi lengkap tanpa error
- [ ] `deploy/env-audit.md`: Verifikasi kredensial produksi pihak ketiga aktif:
  - Database URL produksi dengan connection pooling (PgBouncer / Supabase pooler)
  - Production Payment Gateway API Keys & Webhook Secret
  - Production Email Service (Resend / AWS SES / SendGrid) domain terverifikasi
  - Production Object Storage (Cloudflare R2 / AWS S3) bucket permission terkunci privat
  - expect seluruh koneksi pihak ketiga merespons status otentikasi valid

### 1.4 Pencadangan Basis Data & Rencana Rollback (Contingency Baseline)
- [ ] `deploy/backup-verification.md`: Jalankan pencadangan basis data penuh (*Full Database Snapshot / pg_dump*) sesaat sebelum eksekusi rilis: `pg_dump -Fc -v -h <host> -U <user> <dbname> > backup_pre_deploy.dump` - expect file dump terverifikasi integritasnya dan tersimpan di penyimpanan aman off-site
- [ ] `deploy/rollback-plan.md`: Dokumentasikan Rencana Rollback eksplisit langkah-demi-langkah jika proses deployment gagal - expect perintah shell pemulihan teruji
- [ ] `deploy/rollback-plan.md`: Tetapkan kriteria pemicu rollback (*Rollback Triggers*):
  - Terjadi error migrasi database yang merusak integritas skema
  - Healthcheck `/healthz` gagal merespons dalam 5 menit pasca rilis
  - Error rate pada APM melampaui > 1% dalam 15 menit pertama
  - Terjadi kegagalan transaksi inti pengguna yang tidak dapat ditambal dalam 30 menit
  - expect komitmen eksekusi rollback tanpa keraguan jika salah satu kriteria terpicu

---

## 2. Modul 10: Langkah Eksekusi Deployment (Deployment Steps)

### 2.1 Eksekusi Migrasi Basis Data Produksi
- [ ] Pasang halaman pemeliharaan sementara (*Maintenance Page / Banner 503 Service Unavailable*) jika deployment memerlukan downtime skema basis data - expect lalu lintas pengguna tertahan aman
- [ ] Jalankan skrip migrasi skema database produksi: `pnpm prisma migrate deploy` (atau alat migrasi terkait) - expect proses migrasi selesai dengan status exit code 0 tanpa kegagalan constraint
- [ ] Verifikasi keberadaan tabel, indeks baru, dan data seeding wajib (data master wilayah, akun superadmin awal, role permissions) - expect skema database produksi sinkron 100% dengan rancangan FSD

### 2.2 Kompilasi Build & Distribusi Aplikasi
- [ ] Eksekusi build artefak produksi teroptimasi: `pnpm build` (atau trigger pipeline CI/CD GitHub Actions) - expect proses bundling aset JS/CSS lolos tanpa error TypeScript atau circular dependency
- [ ] Distribusikan container image baru / deploy serverless bundle ke cluster komputasi produksi - expect proses container pull dan spawn instance baru berjalan lancar
- [ ] Bersihkan cache lama di CDN (*Cloudflare Cache Purge / AWS CloudFront Invalidation*) untuk memastikan pengguna mendapatkan aset JavaScript dan CSS paling mutakhir - expect pengguna tidak mengalami kegagalan chunk loader

### 2.3 Evaluasi Pemeriksaan Kesehatan (Health Checks)
- [ ] Uji endpoint internal kesiapan server: `curl -I https://app.domainklien.com/healthz` - expect HTTP 200 OK
- [ ] Uji keterhubungan layanan dependensi via endpoint diagnostik internal: koneksi database, koneksi Redis cache, koneksi worker queue, dan akses disk - expect seluruh status berstatus `HEALTHY`
- [ ] Nonaktifkan halaman pemeliharaan dan buka kembali rute lalu lintas pengguna penuh (*Switch traffic to live*) - expect lalu lintas publik mengalir masuk secara normal

---

## 3. Modul 10: Verifikasi Pasca-Deployment (Post-Deployment Verification)

### 3.1 Uji Asap Produksi (Production Smoke Testing)
- [ ] Lakukan pengujian alur kritis langsung di lingkungan produksi (*Live Smoke Test*) menggunakan akun uji khusus operator:
  - Uji alur masuk pengguna (*Login Admin & Normal User*)
  - Uji pembuatan dan penyimpanan entitas data utama
  - Uji upload file ke penyimpanan cloud dan pemuatan thumbnail gambar
  - Uji transaksi simulasi pembayaran / pemrosesan data riil
  - Uji pengiriman email notifikasi transaksional ke inbox riil
  - expect seluruh alur inti berjalan mulus tanpa hambatan
- [ ] Hapus data pengujian (*cleanup test artifacts*) atau tandai dengan flag testing agar tidak mengotori laporan analitik keuangan riil klien - expect integritas data produksi bersih

### 3.2 Pemantauan Log & Telemetri Real-Time
- [ ] Pantau streaming log server secara langsung (*tail live logs*) selama minimal 30 menit pasca rilis - expect tidak ada unhandled exception, fatal crash, atau connection leak yang berulang
- [ ] Buka dashboard APM & pelacak error (Sentry / Datadog / Logflare) - expect nol laporan error berkategori unhandled issue baru
- [ ] Periksa metrik performa server produksi (CPU load, Memory usage, Network traffic, DB Active Connections) - expect utilisasi resource berada di rentang normal (< 40%)
- [ ] Ukur Core Web Vitals dan respon Time to First Byte (TTFB) halaman produksi riil - expect TTFB < 300 ms dan First Contentful Paint (FCP) < 1.5 detik

---

## 4. Modul 11: Serah Terima Sistem & Dokumentasi (Handover Tasks)

### 4.1 Penyusunan Panduan Operasional & Pengguna
- [ ] `docs/03-handover/USER_MANUAL.pdf`: Susun buku panduan penggunaan aplikasi untuk pengguna akhir (*User Manual*) dilengkapi tangkapan layar antarmuka dan petunjuk alur kerja - expect panduan mudah dipahami staf operasional klien
- [ ] `docs/03-handover/ADMIN_GUIDE.pdf`: Susun panduan administrator sistem (*Admin Manual*): manajemen pengguna, hak akses role, prosedur reset akun, dan navigasi menu pengaturan - expect panduan admin lengkap
- [ ] `docs/03-handover/OPERATIONAL_RUNBOOK.md`: Susun runbook operasional teknis untuk tim IT klien:
  - Panduan start/stop/restart layanan server
  - Prosedur backup dan restore basis data harian
  - Prosedur rotasi kredensial dan API keys
  - Panduan penanganan kegagalan darurat (*Emergency troubleshooting*)
  - expect dokumentasi teknis mandiri yang memungkinkan tim IT klien mengoperasikan sistem

### 4.2 Pelatihan & Alih Pengetahuan (Knowledge Transfer)
- [ ] Jadwalkan dan selenggarakan sesi pelatihan tatap muka / daring (*Knowledge Transfer Session*) untuk staf operasional dan tim IT klien - expect kehadiran seluruh PIC terkait
- [ ] Dokumentasikan rekaman video sesi pelatihan dan tautkan ke repositori dokumentasi proyek - expect materi pelatihan tersimpan rapi untuk onboarding staf klien di masa depan
- [ ] Fasilitasi sesi tanya-jawab interaktif dan latihan mandiri oleh staf klien - expect tim klien mampu melakukan seluruh alur kerja operasional tanpa bantuan

### 4.3 Alih Kepemilikan Kode Sumber & Infrastruktur
- [ ] Transfer kepemilikan repositori Git (GitHub / GitLab) ke organisasi akun resmi klien atau undang akun teknis klien sebagai Owner - expect klien memiliki kendali penuh atas kode sumber
- [ ] Delegasikan hak akses akun cloud infrastructure (Vercel, AWS, Cloudflare, Supabase, Neon) ke email master klien - expect kepemilikan billing dan akun berpindah ke akun perusahaan klien
- [ ] `docs/03-handover/CREDENTIAL_VAULT.md`: Serahkan seluruh master credentials, database root password, API secrets, dan encryption keys melalui kanal aman (1Password / Bitwarden secure share link terenkripsi) - expect dilarang mengirim kredensial lewat chat WhatsApp atau email terbuka
- [ ] Cabut atau turunkan akses akun pribadi/konsultan Anda dari hak Administrator menjadi hak Maintenance terbatas (jika berlanjut ke SLA) atau hapus total jika proyek putus kontrak - expect kepatuhan tata kelola akses

### 4.4 Berita Acara Serah Terima (BAST Final) & Invoice Pelunasan
- [ ] `docs/03-handover/BAST_FINAL.pdf`: Terbitkan dokumen resmi Berita Acara Serah Terima (BAST) Final yang memuat:
  - Pernyataan bahwa seluruh deliverable sesuai SOW telah selesai diserahkan dan berfungsi dengan baik
  - Tanggal resmi dimulainya Masa Garansi (*Warranty Period*)
  - Tanda tangan basah / digital certificate (e-Meterai) dari Lead Consultant dan Direktur / Project Sponsor Klien
  - expect dokumen BAST ditandatangani secara sah oleh kedua belah pihak
- [ ] `invoices/INVOICE_FINAL_PAYMENT.pdf`: Terbitkan invoice pembayaran tahap akhir / pelunasan (Milestone 3: 10%-20%) - expect invoice terkirim ke divisi finance klien dengan jatuh tempo pembayaran jelas
- [ ] Verifikasi penerimaan pelunasan pembayaran akhir ke rekening bank - expect seluruh kewajiban komersial proyek lunas 100%

---

## 5. Gerbang Verifikasi Kelolosan Fase Deployment & Handover

| Parameter Evaluasi | Standar Minimum Kelolosan | Status Verifikasi | Catatan Bukti |
| :--- | :--- | :---: | :--- |
| **Kesiapan Pre-Flight** | DNS propagasi tuntas, SSL aktif, env secret valid, DB backup pre-deploy sukses | [ ] PASS | Dilampirkan di `deploy/` |
| **Eksekusi Rilis** | Migrasi DB produksi sukses, build bersih, container up, `/healthz` HTTP 200 | [ ] PASS | Dilampirkan log rilis produksi |
| **Uji Asap Produksi** | Alur transaksi inti live lolos 100%, data uji dibersihkan, Sentry 0 fatal error | [ ] PASS | Dilampirkan bukti smoke test |
| **Dokumentasi & Training** | User Manual, Admin Guide, dan Runbook diserahkan; sesi training terlaksana | [ ] PASS | Dilampirkan di `docs/03-handover/` |
| **Alih Akses & Kredensial** | Repo & cloud ownership ditransfer, kredensial diserahkan via secure vault | [ ] PASS | Dilampirkan konfirmasi transfer akses |
| **Legal BAST & Pelunasan** | BAST Final bermeterai ditandatangani, invoice pelunasan terbayar 100% | [ ] PASS | Dilampirkan `BAST_FINAL.pdf` & bukti transfer |

### Keputusan Gerbang Deployment:
- [ ] **SELESAI PENUH (GO TO MAINTENANCE & WARRANTY - M12)**: Sistem telah live, BAST final ditandatangani, dan kepemilikan beralih penuh ke klien. Transisi proyek ke masa garansi pemeliharaan di Modul 12.
- [ ] **ROLLBACK DARURAT (EMERGENCY ROLLBACK)**: Terjadi anomali fatal pada lingkungan produksi pasca rilis. Segera eksekusi runbook rollback ke versi stabil sebelumnya!
- [ ] **PENDING BAST / HANDOVER (HOLD MILESTONE)**: Sistem aktif di produksi namun dokumen BAST atau pelunasan administrasi belum tuntas. Selesaikan serah terima administratif.
