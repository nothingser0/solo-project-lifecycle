# Protokol Deployment Produksi & Laporan Go-Live

> Dokumen gabungan panduan eksekusi peluncuran sistem ke Produksi dan laporan verifikasi pasca-rilis.

---

## BAGIAN I: DEPLOYMENT RUNBOOK

### 1. Metadata Rilis
- **Nama Sistem**: [Nama Aplikasi]
- **Target Versi Rilis**: `v1.0.0`
- **Domain Resmi**: `https://app.klien.com`
- **Tanggal & Jam Rilis**: [YYYY-MM-DD] Pukul [09.00 - 11.00 WIB]
- **Release Engineer**: [Nama Anda]

---

### 2. Checklist Pra-Peluncuran (Pre-Flight Sanity)

- [ ] **Berita Acara UAT**: Dokumen `UAT_SIGNOFF_REPORT.md` telah ditandatangani Single PIC Klien.
- [ ] **Jadwal Aman**: Rilis dilakukan pada hari kerja (Selasa–Kamis pagi), bukan Jumat sore atau akhir pekan.
- [ ] **Snapshot Backup**: Basis data produksi telah di-backup secara manual sebelum migrasi dijalankan.
- [ ] **Kunci Lingkungan**: Variabel `.env` produksi menggunakan kredensial LIVE (Bukan sandbox).

---

### 3. Urutan Eksekusi Deployment (Step-by-Step Commands)

#### Langkah 1: Penggabungan Branch & Tagging Git
```bash
# Pindah ke branch main dan gabungkan dari staging
git checkout main
git pull origin main
git merge --no-ff staging -m "chore: merge staging for production release v1.0.0"

# Beri label versi resmi
git tag -a v1.0.0 -m "Release Production v1.0.0"
git push origin main --tags
```

#### Langkah 2: Migrasi Basis Data Produksi
```bash
# Jalankan migrasi skema SQL DDL
DATABASE_URL="postgresql://user:***@prod-host:5432/db_prod?sslmode=require" pnpm db:migrate
```

#### Langkah 3: Eksekusi Build & Deploy Kontainer
```bash
# Jika menggunakan Docker / Serverless:
# Pipeline CI/CD otomatis berjalan saat git push tag v1.0.0
# Verifikasi status pipeline di GitHub Actions / Dashboard Cloud Hosting
```

#### Langkah 4: Verifikasi DNS & Sertifikat SSL (Web Deployment)
```bash
# Periksa propagasi DNS
dig +short app.klien.com
# Uji status sertifikat SSL
curl -Iv https://app.klien.com
```

#### Langkah 5: Peluncuran Aplikasi Mobile (Khusus Mobile Apps)
- [ ] **Android Keystore**: Berkas release keystore `.jks` tersimpan aman di vault terenkripsi.
- [ ] **Build Android App Bundle**: `flutter build appbundle --release` atau `cd android && ./gradlew bundleRelease` (menghasilkan berkas `.aab`).
- [ ] **Google Play Console**: Upload `.aab` ke track *Production* (atau jalankan *Staged Rollout 20%*).
- [ ] **iOS Archive**: `flutter build ipa --release` atau arsip via Xcode dengan *Distribution Certificate* & *Provisioning Profile*.
- [ ] **Apple App Store Connect**: Upload `.ipa` via Transporter/Xcode $\to$ Kirim untuk peninjauan (*Submit for Review*).
- [ ] **Force-Update Check**: Endpoint `/api/v1/app/version-check` mengembalikan versi minimum `1.0.0`.

---

### 4. Pengaktifan Pemantauan & Bot Alert (Observability)

- [ ] **Error Tracking**: DSN Sentry lingkungan produksi terkonfirmasi menerima event error pengujian.
- [ ] **Uptime Ping**: Layanan Uptime Kuma / BetterStack aktif memantau endpoint `https://app.klien.com/api/health` setiap 60 detik.
- [ ] **Telegram/WA Alert**: Bot notifikasi down terhubung ke perangkat solo developer.
- [ ] **Auto-Backup**: Cron job backup harian pukul 02.00 WIB terverifikasi aktif.

---

## BAGIAN II: GO-LIVE VERIFICATION REPORT

### 1. Metadata Peluncuran
- **Nama Sistem**: [Nama Aplikasi]
- **Versi Rilis Resmi**: `v1.0.0`
- **Domain Resmi Publik**: `https://app.klien.com`
- **Waktu Resmi Go-Live**: [YYYY-MM-DD] Pukul [HH:MM WIB]
- **Lead Release Engineer**: [Nama Anda]
- **Status Operasional**: **LIVE ON PRODUCTION (STABIL)**

---

### 2. Status Infrastruktur Produksi

| Komponen Infrastruktur | Penyedia Layanan | Status Konfigurasi | Hasil Verifikasi |
| :--- | :--- | :--- | :---: |
| **Domain & DNS** | Cloudflare / Niagahoster | Record A & CNAME Aktif | Lolos Resolusi DNS |
| **Sertifikat Keamanan** | Let's Encrypt / Cloudflare | TLS 1.3 Aktif (Masa berlaku 90 hari) | SSL Labs Grade A |
| **Basis Data Produksi**| Managed PostgreSQL v16 | Multi-AZ / Daily Backup Aktif | Koneksi Pool Stabil |
| **Storage Vault** | Cloudflare R2 / AWS S3 | Bucket Private (Enkripsi AES-256-GCM) | Upload/Download Lolos |
| **Gateway Pembayaran** | Midtrans / Xendit | **Mode Produksi (LIVE)** | Webhook Lolos Verifikasi |
| **Email Transaksional**| Resend / SendGrid | Domain Pengirim Terverifikasi (DKIM/SPF) | Delivery Rate 100% |

---

### 3. Hasil Pengujian Verifikasi Pasca-Rilis (Production Verification Testing)

Pengujian transaksi nyata dilakukan langsung di domain publik:

- [x] **PVT-01 (Autentikasi)**: Akun Super Admin dan Staf resmi berhasil login ke sistem produksi.
- [x] **PVT-02 (Pembuatan Dokumen)**: Draf dokumen baru berhasil diinput, dirender menjadi PDF resmi, dan tersimpan terenkripsi di vault.
- [x] **PVT-03 (Tanda Tangan Digital)**: Tautan tanda tangan digital berhasil dibuka di perangkat ponsel dan dibubuhi tanda tangan.
- [x] **PVT-04 (Transaksi Riil)**: Uji coba transaksi pembayaran nyata berhasil memotong saldo dan mengubah status order secara instan.
- [x] **PVT-05 (Observabilitas)**: Uptime monitoring aktif dengan latensi rata-rata **125 ms** (target $< 200\text{ ms}$).

---

### 4. Deklarasi Sistem Siap Operasional

Dengan ini dinyatakan bahwa sistem perangkat lunak telah resmi beroperasi secara mandiri di lingkungan Produksi. 

Proyek secara resmi melangkah ke tahap penutupan komersial dan serah terima: **Modul 11: [GATE PENYERAHAN] Pelunasan 100%, Training, BAST, & Handover Repositori**.

---

### 5. Lembar Pengesahan Go-Live

| Single PIC Klien | Release Engineer |
| :--- | :--- |
| **Nama**: _________________________ | **Nama**: _________________________ |
| **Jabatan**: ______________________ | **Jabatan**: Independent Lead Engineer |
| **Tanggal**: ______________________ | **Tanggal**: ______________________ |
| **Tanda Tangan**: | **Tanda Tangan**: |
