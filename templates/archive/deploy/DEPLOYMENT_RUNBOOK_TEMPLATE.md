# Buku Panduan Deployment Produksi (Deployment Runbook)

> Panduan langkah demi langkah teknis bagi solo engineer untuk mengeksekusi peluncuran sistem ke lingkungan server Produksi.

---

## 1. Metadata Rilis
- **Nama Sistem**: [Nama Aplikasi]
- **Target Versi Rilis**: `v1.0.0`
- **Domain Resmi**: `https://app.klien.com`
- **Tanggal & Jam Rilis**: [YYYY-MM-DD] Pukul [09.00 - 11.00 WIB]
- **Release Engineer**: [Nama Anda]

---

## 2. Checklist Pra-Peluncuran (Pre-Flight Sanity)

- [ ] **Berita Acara UAT**: Dokumen `UAT_SIGNOFF_REPORT.md` telah ditandatangani Single PIC Klien.
- [ ] **Jadwal Aman**: Rilis dilakukan pada hari kerja (Selasa–Kamis pagi), bukan Jumat sore atau akhir pekan.
- [ ] **Snapshot Backup**: Basis data produksi telah di-backup secara manual sebelum migrasi dijalankan.
- [ ] **Kunci Lingkungan**: Variabel `.env` produksi menggunakan kredensial LIVE (Bukan sandbox).

---

## 3. Urutan Eksekusi Deployment (Step-by-Step Commands)

### Langkah 1: Penggabungan Branch & Tagging Git
```bash
# Pindah ke branch main dan gabungkan dari staging
git checkout main
git pull origin main
git merge --no-ff staging -m "chore: merge staging for production release v1.0.0"

# Beri label versi resmi
git tag -a v1.0.0 -m "Release Production v1.0.0"
git push origin main --tags
```

### Langkah 2: Migrasi Basis Data Produksi
```bash
# Jalankan migrasi skema SQL DDL
DATABASE_URL="postgresql://user:pass@prod-host:5432/db_prod?sslmode=require" pnpm db:migrate
```

### Langkah 3: Eksekusi Build & Deploy Kontainer
```bash
# Jika menggunakan Docker / Serverless:
# Pipeline CI/CD otomatis berjalan saat git push tag v1.0.0
# Verifikasi status pipeline di GitHub Actions / Dashboard Cloud Hosting
```

### Langkah 4: Verifikasi DNS & Sertifikat SSL (Web Deployment)
```bash
# Periksa propagasi DNS
dig +short app.klien.com
# Uji status sertifikat SSL
curl -Iv https://app.klien.com
```

### Langkah 5: Peluncuran Aplikasi Mobile (Khusus Mobile Apps)
- [ ] **Android Keystore**: Berkas release keystore `.jks` tersimpan aman di vault terenkripsi.
- [ ] **Build Android App Bundle**: `flutter build appbundle --release` atau `cd android && ./gradlew bundleRelease` (menghasilkan berkas `.aab`).
- [ ] **Google Play Console**: Upload `.aab` ke track *Production* (atau jalankan *Staged Rollout 20%*).
- [ ] **iOS Archive**: `flutter build ipa --release` atau arsip via Xcode dengan *Distribution Certificate* & *Provisioning Profile*.
- [ ] **Apple App Store Connect**: Upload `.ipa` via Transporter/Xcode $\to$ Kirim untuk peninjauan (*Submit for Review*).
- [ ] **Force-Update Check**: Endpoint `/api/v1/app/version-check` mengembalikan versi minimum `1.0.0`.

---

## 4. Pengaktifan Pemantauan & Bot Alert (Observability)

- [ ] **Error Tracking**: DSN Sentry lingkungan produksi terkonfirmasi menerima event error pengujian.
- [ ] **Uptime Ping**: Layanan Uptime Kuma / BetterStack aktif memantau endpoint `https://app.klien.com/api/health` setiap 60 detik.
- [ ] **Telegram/WA Alert**: Bot notifikasi down terhubung ke perangkat solo developer.
- [ ] **Auto-Backup**: Cron job backup harian pukul 02.00 WIB terverifikasi aktif.
