# Modul 10: Deployment & Production Go-Live (Peluncuran Resmi ke Lingkungan Produksi)

> ⚠️ **MANDATORY: Load references BEFORE executing this module**:
> - `references/improvements/MODUL_10_IMPROVEMENTS.md` (No Friday Deploy, Expand and Contract migration, TTL DNS lowering, Encrypted S3/R2 backup, timeline estimation 8-112 jam, blue-green deployment strategy, DNS cutover protocol, rollback execution playbook <15min, production monitoring setup checklist)
>
> Load via: `skill_view(name='solo-project-lifecycle', file_path='references/improvements/MODUL_10_IMPROVEMENTS.md')`

Modul ini adalah tahap kesepuluh dalam siklus hidup proyek perangkat lunak untuk solo developer. Tujuannya adalah memindahkan kode yang telah lolos UAT dari branch `staging` ke branch `main`, mengonfigurasi infrastruktur produksi resmi (Domain DNS, SSL TLS 1.3, Cloudflare, Basis Data Produksi), mengeksekusi migrasi basis data tanpa henti (*zero-downtime*), mengaktifkan pemantauan observabilitas, dan melakukan pengujian pasca-rilis (*Post-Deployment Smoke Test*) hingga sistem resmi **LIVE ON PRODUCTION**.

---

## 1. Siklus Eksekusi Modul 10

```text
[ INPUT: Berita Acara UAT Sah (Modul 09) & Kode Stabil di Branch staging ]
                                    │
                                    ▼
[ LANGKAH 1: [GATE] Pemeriksaan Pra-Rilis (Go / No-Go Gate) ]
  • Verifikasi Berita Acara UAT Bertandatangan (Prasyarat Mutlak)
  • Waktu Rilis Aman: Dilarang rilis Jumat sore atau menjelang hari libur
  • Snapshot Backup Basis Data Sebelum Eksekusi Migrasi
                                    │
                                    ▼
[ LANGKAH 2: Penggabungan Branch Git & Pelabelan Versi Resmi (SemVer Tag) ]
  • Merge staging ──► main (Clean Production Codebase)
  • Beri Label Rilis: git tag -a v1.0.0 -m "Release Production v1.0.0"
  • Push ke Remote Repository untuk Memicu Pipeline CI/CD Produksi
                                    │
                                    ▼
[ LANGKAH 3: Penyediaan Infrastruktur & Kunci Rahasia Produksi ]
  • Konfigurasi DNS Domain Resmi (A / CNAME Record) & Sertifikat SSL TLS 1.3
  • Konfigurasi Variabel Lingkungan Produksi (.env.production - Kunci Asli)
  • Pengalihan Kredensial Payment Gateway dari Sandbox ──► Production Mode
                                    │
                                    ▼
[ LANGKAH 4: Eksekusi Migrasi Basis Data Produksi (Zero-Downtime) ]
  • Eksekusi Migrasi Skema SQL DDL pada Database Produksi
  • Impor Data Riil Klien Terverifikasi (Hasil Modul 08)
                                    │
                                    ▼
[ LANGKAH 5: Pengaktifan Pemantauan & Bot Alert (Observability Live) ]
  • Hubungkan Sentry / Error Tracker Otomatis
  • Setup Uptime Healthcheck Monitor (Ping setiap 60 detik ke /api/health)
  • Verifikasi Jadwal Otomatisasi Daily Backup Database
                                    │
                                    ▼
[ LANGKAH 6: Uji Verifikasi Pasca-Deployment (Production Smoke Test) ]
  • Uji Coba Transaksi Nyata di Domain Publik (https://app.klien.com)
  • Penyusunan Dokumen GO_LIVE_VERIFICATION_REPORT.md
                                    │
                                    ▼
[ OUTPUT: Sistem LIVE di Produksi & GO_LIVE_REPORT.md ] ──► Siap Masuk ke Modul 11: Handover & BAST
```

---

## 2. Tiga Aturan Emas Deployment Solo Developer

1. **Aturan "No Friday Deployment"**:
   - DILARANG melakukan peluncuran sistem baru ke lingkungan produksi pada hari **Jumat sore, akhir pekan, atau malam sebelum hari libur nasional**.
   - Jika terjadi kendala tak terduga, solo developer akan terjebak lembur darurat di akhir pekan tanpa dukungan tim teknis klien atau customer support vendor cloud.
   - Waktu rilis ideal: **Selasa atau Rabu pukul 09.00–11.00 pagi** (seluruh pihak siaga penuh).
2. **Kunci Kredensial Asli (Zero Sandbox Keys in Prod)**:
   - Pastikan variabel lingkungan di server produksi telah diganti dengan akun asli (Live API Key Payment Gateway, Live SMTP, Live Cloudflare R2), bukan akun pengujian sandbox staging.
3. **Wajib Memiliki Rencana Mundur Darurat (Rollback Plan)**:
   - Sebelum menyentuh tombol deploy, solo dev harus tahu persis cara mengembalikan sistem ke kondisi semula dalam waktu < 15 menit jika terjadi kegagalan fatal.

---

## 3. Langkah demi Langkah Eksekusi

### Langkah 1: Pemeriksaan Pra-Rilis (Pre-Flight Checklist)

1. Periksa berkas `UAT_SIGNOFF_REPORT.md`: Pastikan tanda tangan Single PIC Klien sah.

2. **CRITICAL: Verifikasi Production Environment Variables**

   Sebelum menyentuh DNS atau deployment, verifikasi ENV production:

   ```bash
   # Verify payment gateway mode
   echo $PAYMENT_GATEWAY_MODE
   # Expected: "production" atau "live"
   # NEVER: "sandbox" atau "test"

   # Verify database URL
   echo $DATABASE_URL | grep -o 'prod\|production\|live'
   # Must contain production identifiers

   # Verify API keys (partial check)
   echo $STRIPE_SECRET_KEY | cut -c1-10
   # Production: sk_live_...
   # Sandbox: sk_test_... (WRONG!)

   # Verify JWT secret different from staging
   echo $JWT_SECRET | cut -c1-8
   # Should differ from staging JWT_SECRET

   # Verify encryption key rotated
   echo $ENCRYPTION_KEY | cut -c1-8
   # Should differ from staging ENCRYPTION_KEY
   ```

   **Checklist Production ENV**:
   - [ ] `PAYMENT_GATEWAY_MODE=production` (NOT sandbox)
   - [ ] `DATABASE_URL` points to production DB
   - [ ] `STRIPE_SECRET_KEY` starts with `sk_live_`
   - [ ] `MIDTRANS_IS_PRODUCTION=true`
   - [ ] `SMTP_HOST` is production mail server (NOT mailtrap/mailpit)
   - [ ] `STORAGE_BUCKET` is production bucket (NOT staging)
   - [ ] `JWT_SECRET` different from staging
   - [ ] `ENCRYPTION_KEY` rotated for production
   - [ ] `CORS_ORIGIN` matches production domain
   - [ ] `SENTRY_DSN` with `environment: "production"`
   - [ ] `SESSION_SECRET` unique to production

   **STOP deployment jika masih ada sandbox keys!**

3. **Rollback Plan Dry-Run Verification**:

   - [ ] Rollback plan dry-run executed in staging (verify git revert + DB restore time)
   - [ ] Database migration rollback script tested (if DDL changes exist)
   - [ ] Documented: can we restore last known good state in <15 minutes?

   **WARNING**: DDL migrations (ADD COLUMN, DROP TABLE) may not be reversible without data loss. Test rollback procedure in staging first.

4. Ambil snapshot backup manual database produksi (jika memperbarui sistem yang sudah ada):
   ```bash
   pg_dump -U postgres -d legal_vault_prod -F c -b -v -f "backup-pre-deploy-$(date +%Y%m%d).dump"
   ```

### Langkah 2: Merge Git & Pelabelan Versi Resmi
1. Pindah ke branch `main` dan gabungkan kode dari `staging`:
   ```bash
   git checkout main
   git merge --no-ff staging
   ```
2. Berikan label tag versi resmi:
   ```bash
   git tag -a v1.0.0 -m "Release Production v1.0.0 - Go-Live"
   git push origin main --tags
   ```

### Langkah 3: Konfigurasi DNS & SSL

1. Masuk ke dashboard DNS penyedia domain klien (Cloudflare, Niagahoster, Route53).
2. Arahkan DNS Record:
   - `Type A`: `@` → IP Server Produksi / Load Balancer.
   - `CNAME`: `app` atau `www` → domain hosting (Vercel / Cloud Run).
3. Verifikasi propagasi DNS menggunakan `dig` atau `nslookup`.
4. Pastikan sertifikat SSL terbit dan mendapatkan peringkat minimal **Grade A** di SSL Labs (TLS 1.3 aktif).

### Langkah 4: Impor Data Riil Klien Terverifikasi (Hasil Modul 08)

**PENTING**: Data ini berasal dari hasil Modul 08 yang telah lolos UAT. Pilih salah satu dari 3 metode berikut untuk memindahkan data ke production:

**PILIHAN A: Re-run ETL Script ke Production** (Recommended - Fresh Import)

Jika data source (Excel/CSV) masih tersedia dan tidak berubah sejak UAT:

```bash
# Jalankan ETL script langsung ke production DB
DATABASE_URL="postgresql://user:***@prod-db:5432/db" node scripts/etl-import.js --source data/klien-final.xlsx

# Verify row count
psql $DATABASE_URL -c "SELECT COUNT(*) FROM documents;"
psql $DATABASE_URL -c "SELECT COUNT(*) FROM users;"
```

**Benefit**: Data fresh, tidak ada staging artifacts, reconciliation sama seperti UAT.

---

**PILIHAN B: Copy Staging Database ke Production** (Faster - Staging Dump)

Jika data di staging DB sudah lolos UAT dan tidak ada perubahan:

**Pre-Migration Test Data Verification** (MANDATORY before dump):

```bash
# Verify no test data in staging
psql $STAGING_DB_URL -c "SELECT COUNT(*) FROM users WHERE email LIKE '%test%';"
# Expected: 0 test accounts

psql $STAGING_DB_URL -c "SELECT COUNT(*) FROM documents WHERE title = 'Test Document';"
# Expected: 0 test documents

psql $STAGING_DB_URL -c "SELECT COUNT(*) FROM users WHERE email LIKE '%@example.com';"
# Expected: 0 example.com emails (common test pattern)
```

**STOP if test data found!** Clean staging DB before proceeding.

```bash
# Dump staging DB
pg_dump -U postgres -h staging-db -d legal_vault_staging -F c -b -v -f staging-uat-approved.dump

# Restore ke production DB
pg_restore -U postgres -h prod-db -d legal_vault_prod -v staging-uat-approved.dump

# Verify row count match
psql postgresql://prod-db/legal_vault_prod -c "SELECT COUNT(*) FROM documents;"
```

**Risk**: Pastikan staging DB bersih, tidak ada test data yang tercampur.

---

**PILIHAN C: Manual Migration (Last Resort)**

Jika volume data kecil (<100 rows) dan ETL script tidak tersedia:

```bash
# Export staging data to CSV
psql postgresql://staging-db/legal_vault_staging -c "COPY documents TO STDOUT WITH CSV HEADER" > documents.csv

# Import ke production
psql postgresql://prod-db/legal_vault_prod -c "COPY documents FROM STDIN WITH CSV HEADER" < documents.csv
```

---

**Post-Migration Verification (MANDATORY)**:

```bash
# Check row count consistency with M08 reconciliation
echo "Users: $(psql $PROD_DB_URL -tAc 'SELECT COUNT(*) FROM users')"
echo "Documents: $(psql $PROD_DB_URL -tAc 'SELECT COUNT(*) FROM documents')"

# Check data integrity
psql $PROD_DB_URL -c "SELECT * FROM documents WHERE created_at IS NULL LIMIT 5;"
# Expected: 0 rows (no NULL timestamps)

# Check foreign key integrity
psql $PROD_DB_URL -c "SELECT COUNT(*) FROM documents d LEFT JOIN users u ON d.creator_id = u.id WHERE u.id IS NULL;"
# Expected: 0 (no orphaned documents)

# Verify application-level data access
curl -X POST https://app.klien.com/api/auth/login \
  -d '{"email":"admin@klien.com","password":"***"}' \
  | jq '.token' # Should return valid JWT

# Verify document retrieval
curl https://app.klien.com/api/documents?limit=5 \
  -H "Authorization: Bearer ***" # Should return real documents
```

**WAJIB cocokkan row count dengan UAT_SIGNOFF_REPORT.md Section "Data Migration Reconciliation"**.

---

### Langkah 5: Eksekusi Migrasi Skema Database Produksi

Jalankan migrasi schema SQL DDL pada database produksi:

```bash
DATABASE_URL="postgresql://user:***@prod-db:5432/db" pnpm db:migrate
```

*Catatan Solo Dev: Pastikan skrip migrasi bersifat aditif (hanya menambah kolom/tabel baru), dilarang menggunakan perintah destruktif (`DROP COLUMN` / `TRUNCATE`).*

### Langkah 5: Pengaktifan Observabilitas & Alerting
1. Pastikan DSN Sentry lingkungan produksi aktif (`environment: "production"`).
2. Daftarkan URL `https://app.klien.com/api/health` ke layanan uptime monitoring (Uptime Kuma, BetterStack, atau Cronitor).
3. Sambungkan bot alert ke grup Telegram atau nomor WhatsApp solo dev untuk notifikasi instan jika server down.

### Langkah 6: Production Verification Test (PVT)
Buka browser pada domain publik resmi:
1. Uji alur otentikasi login akun produksi.
2. Uji coba pembuatan 1 dokumen sampel dan pastikan PDF ter-generate serta tersimpan di bucket storage produksi.
3. Lakukan 1 transaksi pembayaran nominal kecil asli (misal Rp 10.000 via QRIS) untuk memvalidasi webhook payment gateway produksi.
4. Rangkum bukti hasil pengujian ke dalam dokumen **`GO_LIVE_VERIFICATION_REPORT.md`**.

---

## 4. Alur Khusus Deployment Aplikasi Mobile (Android & iOS)

Jika proyek mencakup aplikasi mobile (Flutter / React Native / Native), proses deployment memiliki karakteristik toko aplikasi (*App Store Ecosystem*) yang berbeda dari web:

```text
[ SOURCE CODE STAGING ]
           │
           ├──────────────────────────────────────┐
           ▼                                      ▼
   [ ANDROID RELEASE ]                     [ IOS RELEASE ]
   • Signing: Release Keystore (.jks)     • Signing: Distribution Cert & Provisioning Profile
   • Build: Android App Bundle (.aab)     • Build: iOS Archive (.ipa) via Xcode / Fastlane
   • Beta: Internal App Sharing           • Beta: Apple TestFlight Internal/External
           │                                      │
           ▼                                      ▼
[ GOOGLE PLAY CONSOLE ]                    [ APPLE APP STORE CONNECT ]
• Review: 24–72 Jam (Automated & Manual)  • Review: 24–48 Jam (Strict Apple Guidelines)
• Phased Rollout: 10% ──► 50% ──► 100%    • Phased Release: 7 Hari Bertahap
```

### 4.1 Manajemen Kunci & Signing (Keystore & Certificates)
- **Android**: Buat keystore produksi dan simpan berkas `.jks` serta password alias di brankas terenkripsi (Bitwarden). *Jika keystore hilang, aplikasi tidak akan pernah bisa di-update lagi di Google Play Store selamanya.*
- **iOS**: Daftarkan akun Apple Developer Program Klien ($99/tahun). Buat sertifikat distribusi dan App Store Provisioning Profile.

### 4.2 Strategi Beta Testing Sebelum Publik (TestFlight & Internal Sharing)
- Dilarang langsung melempar build pertama ke produksi publik.
- **Android**: Upload ke track **Internal Testing** di Google Play Console $\to$ bagikan link ke Single PIC Klien untuk verifikasi di ponsel Android asli.
- **iOS**: Upload ke **TestFlight** $\to$ invite akun email Apple ID milik Single PIC Klien untuk uji coba di perangkat iPhone nyata.

### 4.3 Mengantisipasi Waktu Review Toko Aplikasi (The Review Buffer)
- Tidak seperti web yang bisa rilis instan dalam 2 menit, rilis mobile terikat jadwal review manusia:
  - Apple App Store: Membutuhkan waktu **24–48 jam kerja**.
  - Google Play Console: Membutuhkan waktu **24–72 jam kerja** (terutama untuk akun pengembang baru).
- **Strategi Tangkal Komplain Klien**: Cantumkan di jadwal bahwa tanggal go-live mobile terhitung sejak status aplikasi berubah menjadi *Ready for Sale / Published* oleh toko aplikasi.

### 4.4 Penanganan Rollback & Pembaruan Darurat Mobile (OTA & Force Update)
- Aplikasi mobile tidak bisa di-rollback secara instan jika ada bug kritis di tangan pengguna.
- **Mekanisme Wajib Force-Update**: Aplikasi mobile wajib memiliki pengecekan versi minimum di splash screen (`GET /api/v1/app/version-check`). Jika ada bug kritis, backend dapat memaksa pengguna meng-update aplikasi ke versi terbaru sebelum bisa membuka dashboard.
- **Over-The-Air (OTA) Updates**: Untuk React Native (Expo Updates) atau Flutter (Shorebird), pasang mekanisme OTA patch agar perbaikan kode JavaScript/Dart minor bisa terdistribusi seketika tanpa harus melewati proses review toko aplikasi ulang.

---

## 5. Adaptasi Berdasarkan Skala Proyek

| Aspek Deployment | Skala Kecil (MVP / Freelance) | Skala Menengah (B2B SaaS / Agensi) | Skala Besar & Enterprise |
| :--- | :--- | :--- | :--- |
| **Infrastruktur** | PaaS (Vercel / Railway / Render) | Managed Cloud Run / Docker VPS + Managed DB | Multi-region AWS/GCP, Kubernetes, Private VPC |
| **Strategi Rilis** | Rolling restart instan (< 1 menit) | Blue-Green Deployment / Container Swap | Canary Deployment bertahap (10% $\to$ 50% $\to$ 100%) |
| **Jadwal Rilis** | Jam kerja santai (Selasa pagi) | Scheduled maintenance (Selasa 10.00 WIB) | Scheduled Window malam hari dengan persetujuan CAB |
| **Monitoring** | Sentry gratis + Uptime Kuma bot | Sentry + BetterStack log aggregation | APM penuh (Datadog/New Relic) + PagerDuty SLA |

---

## 5. Artefak Keluaran (Deliverables)

> 📁 **ATURAN LOKASI BERKAS MUTLAK**:
> Dokumen runbook dan laporan go-live WAJIB disimpan di folder **`docs/deploy/`** atau **`docs/pm/`**.

Modul ini menghasilkan 2 dokumen eksekusi:
1. **`docs/deploy/DEPLOYMENT_PROTOCOL.md`**: Protokol gabungan panduan deployment dan laporan go-live yang membuktikan sistem aktif di Produksi (menggunakan `templates/07-release-handover/DEPLOYMENT_PROTOCOL_TEMPLATE.md`).
2. **`docs/deploy/ROLLBACK_PLAN.md`**: Prosedur darurat pemulihan jika terjadi kegagalan fatal saat go-live (menggunakan `templates/07-release-handover/ROLLBACK_PLAN_TEMPLATE.md`).

---

## 6. Kriteria Kelulusan [GATE] (Gate Exit Criteria)

[GATE] Modul 10 dinyatakan **LOLOS (PASS)** jika:
- [x] Branch `main` telah diberi tag versi SemVer resmi (`v1.0.0`).
- [x] Domain resmi (`https://app.klien.com`) aktif dengan enkripsi SSL/TLS 1.3 valid.
- [x] Migrasi database produksi sukses dijalankan tanpa kehilangan data.
- [x] Seluruh variabel lingkungan menggunakan akun live produksi (bukan sandbox).
- [x] Uji transaksi nyata pasca-rilis (*PVT*) berhasil 100%.
- [x] Sistem monitoring uptime dan pelacak error Sentry aktif.

---

## 🛑 PROTOKOL [GATE] KELUAR & WAJIB BERHENTI

Setelah sistem resmi Live di Produksi dan laporan PVT terbit:

### **LANGKAH 0: VERIFIKASI EKSISTENSI BERKAS (BLOCKING CHECK)**

**WAJIB DILAKUKAN SEBELUM VALIDASI KONTEN**:

1. **Cek keberadaan file output** menggunakan salah satu metode:
   - PowerShell: `Test-Path -LiteralPath "docs/deploy/GO_LIVE_VERIFICATION_REPORT.md"` → harus return `True`
   - Read tool: `read_file('docs/deploy/GO_LIVE_VERIFICATION_REPORT.md')` → harus sukses tanpa error

2. **JIKA FILE TIDAK ADA**:
   - ❌ **STOP IMMEDIATELY** - jangan lanjut validasi konten
   - ❌ **JANGAN tampilkan summary** ke user
   - ❌ **JANGAN ajukan konfirmasi** untuk lanjut Module 11
   - ✅ **REPORT ERROR** ke user:
     ```
     CRITICAL ERROR: File GO_LIVE_VERIFICATION_REPORT.md tidak tercipta.
     Module 10 FAILED - tidak bisa lanjut ke Module 11 (Handover & BAST).
     
     Kemungkinan penyebab:
     - Write permission denied pada folder docs/deploy/
     - Path typo di tool call
     - Disk full
     
     Tolong investigasi issue ini sebelum lanjut.
     ```
   - ✅ **END TURN** dan tunggu user fix issue

3. **HANYA JIKA FILE EXISTS**: Lanjut ke validasi konten di bawah

---

### **LANGKAH 1: VALIDASI KONTEN & PRODUCTION VERIFICATION**

1. **DILARANG KERAS langsung menyerahkan repositori, password root, atau memanggil tool untuk Modul 11 dalam giliran (turn) yang sama!**
2. **Verifikasi production deployment**:
   - [ ] `read_file('docs/deploy/GO_LIVE_VERIFICATION_REPORT.md')` → Confirm PVT tests PASS
   - [ ] Confirm domain live with valid SSL (https://app.klien.com accessible)
   - [ ] Confirm monitoring active (Sentry DSN, uptime checker)
   - [ ] Confirm production transaction tested successfully
3. Tampilkan status keberhasilan go-live produksi kepada pengguna:
   - Domain produksi resmi yang aktif
   - Hasil uji verifikasi transaksi nyata (PVT)
   - Status pemantauan uptime & error tracker Sentry
3. **AKHIRI RESPON ANDA (END TURN)** dan ajukan konfirmasi kepada pengguna:
   > *"Sistem telah resmi beroperasi di server Produksi (Live). Bukti verifikasi terdokumentasi di `docs/pm/GO_LIVE_VERIFICATION_REPORT.md`. Apakah Anda siap menerbitkan invoice pelunasan dan memulai proses serah terima (Modul 11: Handover & BAST)?"*
4. Tunggu respon persetujuan eksplisit dari pengguna sebelum melangkah ke Modul 11.
