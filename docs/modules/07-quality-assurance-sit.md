# Modul 07: Quality Assurance (Unit Test, SIT, & Security Audit)

> - `references/playbooks/ai-assisted-development.md` (Pre-merge AI review protocol, prompt engineering patterns, multi-file orchestration)
>

Modul ini adalah tahap ketujuh dalam siklus hidup proyek perangkat lunak untuk solo developer. Tujuannya adalah memvalidasi keandalan, integritas integrasi sistem pihak ketiga (*System Integration Testing* / SIT), ketahanan performa, dan keamanan sistem secara otomatis di lingkungan **Staging** sebelum diserahkan kepada klien untuk proses UAT (Modul 09).

---

## 1. Siklus Eksekusi Modul 07

```text
[ INPUT: Repositori Kode di Branch staging dari Modul 06 & FSD.md ]
                                    │
                                    ▼
[ LANGKAH 1: Pengujian Otomatis Unit & Kontrak API (Test Pyramid) ]
  • Unit Test: Logika bisnis murni, kalkulasi, dan utilitas kriptografi
  • Integration Test: Endpoint API ber-Zod, status response, & isolasi DB
  • Pre-Merge AI Review: Protokol `references/playbooks/ai-assisted-development.md`
                                    │
                                    ▼
[ LANGKAH 2: Pengujian Integrasi Sistem Pihak Ketiga (SIT) ]
  • SIT dilakukan dengan data dummy/seed data (BUKAN data riil klien)
  • Validasi Sandbox Payment Gateway (Simulasi Webhook Sukses/Gagal)
  • Validasi Cloud Storage (Upload terenkripsi AES-256 & Presigned URL)
  • Validasi Transaksional Email (SMTP / Resend delivery log)
  • Data riil klien diimpor M08 setelah SIT lolos
                                    │
                                    ▼
[ LANGKAH 3: Audit Keamanan & Hardening (Security Gate) ]
  • Dependency Vulnerability Audit (`pnpm audit --audit-level=high`)
  • Secret Leak Scanning (Deteksi API key / token yang tidak sengaja ter-commit)
  • Checklist Verifikasi OWASP Top 10 (SQL Injection, XSS, CSRF, Broken Auth)
                                    │
                                    ▼
[ LANGKAH 4: Uji Beban & Performa Concurrency (Load Testing) ]
  • Uji Beban Menggunakan k6 / Autocannon (Misal: 50–100 Concurrent Virtual Users)
  • Verifikasi Latency API ≤200 ms & Error Rate 0%
                                    │
                                    ▼
[ LANGKAH 5: Deployment ke Lingkungan Staging & Pengesahan SIT ]
  • Deploy Branch staging ke Server Staging Klien (Vercel / VPS / Cloud Run)
  • Penyusunan Dokumen Laporan Hasil Uji (SIT_REPORT.md)
                                    │
                                    ▼
[ OUTPUT: SIT_REPORT.md & Server Staging Siap UAT ] ──► Siap Masuk ke Modul 08: Data Migration
```

---

## 2. Prinsip QA Solo Developer: "The Pragmatic Test Pyramid"

Solo developer tidak memiliki tim QA beranggotakan 5 orang. Dilarang menulis ratusan pengujian antarmuka (UI tests) yang rapuh (*brittle*) dan sering gagal hanya karena perubahan class CSS.

### Piramida Pengujian Efisien Solo Dev:
1. **Lapisan Bawah (70% - Unit & Contract Tests)**:
   - Menguji fungsi murni (*pure functions*): rumus kalkulasi, pemrosesan teks template, enkripsi/dekripsi AES-256, dan validasi skema Zod. Cepat dijalankan (< 5 detik) dan stabil.
2. **Lapisan Tengah (25% - API Integration & SIT Tests)**:
   - Menguji interaksi controller dengan database lokal dan sandbox pihak ketiga (Payment, Email, S3).
3. **Lapisan Atas (5% - Critical Path E2E Smoke Test)**:
   - Hanya menguji 1 alur terpenting (*Core Happy Path*): Login → Buat dokumen → Generate PDF → Tanda tangan → Status `SIGNED`.

---

## 3. Langkah demi Langkah Eksekusi

### Langkah 1: Pengujian Otomatis Unit & Integrasi
Jalankan pengujian menggunakan test runner cepat (Vitest / Jest / Pytest / Go test):
```bash
# Menjalankan seluruh unit & integration test
pnpm run test # atau vitest run
```
Kriteria Lolos: 100% tes lulus tanpa kegagalan (`exit code 0`).

### Langkah 2: System Integration Testing (SIT)
**PENTING**: SIT dilakukan dengan **data dummy/seed data** di lingkungan Staging. Data riil klien **TIDAK** diimpor hingga SIT lolos (Modul 08).

Uji seluruh titik sambungan ke layanan pihak ketiga di lingkungan sandbox:
1. **Payment Gateway Sandbox**:
   - Tembakkan payload webhook pembayaran sukses → Pastikan status pesanan berubah menjadi `PAID` dan stok terkunci.
   - Tembakkan webhook pembayaran kedaluwarsa/gagal → Pastikan status berubah menjadi `CANCELLED`.
2. **Document Vault Storage**:
   - Upload file dokumen → Pastikan file tersimpan di bucket storage dalam kondisi biner terenkripsi.
   - Ambil presigned URL → Pastikan file dapat diunduh dan didekripsi dengan sempurna dalam batas waktu 15 menit.
3. **Email Transaksional**:
   - Uji pengiriman email OTP → Pastikan masuk ke inbox email penguji dengan format template rapi.

### Langkah 3: Audit Keamanan & Hardening
1. **Audit Dependensi**:
   ```bash
   pnpm audit --audit-level=high
   ```
   Wajib menghasilkan: `found 0 vulnerabilities`.
2. **Pemeriksaan Celah OWASP**:
   - Pastikan seluruh rute terproteksi otentikasi menolak request tanpa token (`401 Unauthorized`).
   - Pastikan header keamanan HTTP terpasang:
     ```http
     X-Content-Type-Options: nosniff
     X-Frame-Options: DENY
     Referrer-Policy: strict-origin-when-cross-origin
     Content-Security-Policy: default-src 'self' ...
     ```

### Langkah 4: Uji Beban & Konkurensi (Load Testing)
Gunakan skrip uji beban sederhana (k6 atau autocannon):
```bash
# Contoh simulasi 50 concurrent users selama 30 detik
npx autocannon -c 50 -d 30 http://localhost:3000/api/health
```
- **Ambang Batas Minimum**:
  - Rata-rata latency ≤200 ms.
  - Tidak ada kegagalan koneksi database (*zero 500 server errors*).

### Langkah 5: Deployment ke Staging Server & SIT Report
1. Push branch `staging` ke remote: `git push origin staging`.
2. CI/CD otomatis melakukan build dan deploy ke domain staging: `https://staging.domainklien.com`.
3. Jalankan pengujian cepat langsung di domain staging tersebut.
4. Rangkum seluruh bukti pengujian ke dalam berkas **`SIT_REPORT.md`**.

---

## 4. Adaptasi Berdasarkan Skala Proyek

| Aspek QA & SIT | Skala Kecil (MVP / Freelance) | Skala Menengah (B2B SaaS / Agensi) | Skala Besar & Enterprise |
| :--- | :--- | :--- | :--- |
| **Cakupan Pengujian** | Unit test logika inti + Smoke test lokal | Unit test + SIT API Sandbox + k6 load test | Test Pyramid penuh, Pact contract test, Chaos test |
| **Audit Keamanan** | `pnpm audit` + OWASP checklist dasar | SAST scan (Semgrep) + SSL Labs grade A | Third-party Penetration Test (Pentest) berijazah |
| **Uji Beban** | Cukup verifikasi 20 concurrent users | Uji beban 100 concurrent users via k6 | Stress test peak load 1.000+ users & failover DB |
| **Lingkungan Staging**| Preview URL otomatis (Vercel/Railway) | Server Staging terisolasi dengan data dummy | Mirror Production Staging dengan sanitasi data |
| **Laporan SIT** | Checklist ringkas di VERIFY.md | Dokumen formal `SIT_REPORT.md` | Formal SIT Sign-off + Audit Security Attestation |

---

## 5. Artefak Keluaran (Deliverables)

Modul ini menghasilkan 2 artefak utama:
1. **`docs/qa/SIT_WORKBOOK.md`**: Buku kerja gabungan rencana pengujian dan laporan bukti kelulusan SIT di Staging yang menjadi prasyarat pembukaan sesi UAT Klien (menggunakan `templates/06-qa-uat/SIT_WORKBOOK_TEMPLATE.md`).
2. **`docs/qa/SECURITY_AUDIT_REPORT.md`**: Hasil audit kerentanan pustaka, status header keamanan OWASP, dan verifikasi enkripsi (menggunakan `templates/06-qa-uat/SECURITY_AUDIT_TEMPLATE.md`).

---

## 6. Kriteria Kelulusan [GATE] (Gate Exit Criteria)

[GATE] Modul 07 dinyatakan **LOLOS (PASS)** jika:
- [x] Seluruh unit test dan integration test lulus 100% (`pnpm test` exit code 0).
- [x] SIT dengan seluruh sandbox pihak ketiga (Payment, Vault S3/R2, Email) terbukti berhasil.
- [x] Audit dependensi `pnpm audit` bebas dari kerentanan kategori High/Critical.
- [x] Aplikasi telah berhasil di-deploy dan berjalan stabil di server **Staging**.
- [x] Dokumen **`docs/qa/SIT_REPORT.md`** telah terbit dengan kesimpulan: **READY FOR CLIENT UAT**.

---

## 🛑 PROTOKOL [GATE] KELUAR & WAJIB BERHENTI

Setelah server Staging aktif dan dokumen `SIT_REPORT.md` terbit:

### **LANGKAH 0: VERIFIKASI EKSISTENSI BERKAS (BLOCKING CHECK)**

**WAJIB DILAKUKAN SEBELUM VALIDASI KONTEN**:

1. **Cek keberadaan file output** menggunakan salah satu metode:
   - PowerShell: `Test-Path -LiteralPath "docs/qa/SIT_WORKBOOK.md"` → harus return `True`
   - Read tool: `read_file('docs/qa/SIT_WORKBOOK.md')` → harus sukses tanpa error

2. **JIKA FILE TIDAK ADA**:
   - ❌ **STOP IMMEDIATELY** - jangan lanjut validasi konten
   - ❌ **JANGAN tampilkan summary** ke user
   - ❌ **JANGAN ajukan konfirmasi** untuk lanjut Module 08
   - ✅ **REPORT ERROR** ke user:
     ```
     CRITICAL ERROR: File SIT_WORKBOOK.md tidak tercipta.
     Module 07 FAILED - tidak bisa lanjut ke Module 08 (Data Migration).
     
     Kemungkinan penyebab:
     - Write permission denied pada folder docs/qa/
     - Path typo di tool call
     - Disk full
     
     Tolong investigasi issue ini sebelum lanjut.
     ```
   - ✅ **END TURN** dan tunggu user fix issue

3. **HANYA JIKA FILE EXISTS**: Lanjut ke validasi konten di bawah

---

### **LANGKAH 1: VALIDASI KONTEN & TESTS**

1. **DILARANG KERAS langsung melanjutkan atau memanggil tool untuk Modul 08/09 dalam giliran (turn) yang sama!**
2. **Verifikasi test results**:
   - [ ] `read_file('docs/qa/SIT_WORKBOOK.md')` → Confirm all tests PASS
   - [ ] Confirm staging URL accessible
   - [ ] Confirm `pnpm audit` clean (zero critical vulnerabilities)
   - [ ] Confirm sandbox integrations verified (Payment/Storage/Email)
3. Tampilkan ringkasan hasil pengujian integrasi Staging kepada pengguna:
   - URL Staging yang aktif
   - Status kelulusan pengujian sandbox pihak ketiga
   - Hasil audit keamanan dependensi & uji beban k6
3. **AKHIRI RESPON ANDA (END TURN)** dan ajukan konfirmasi kepada pengguna:
   > *"Sistem telah berhasil lolos pengujian integrasi (SIT Pass) dan aktif di server Staging. Apakah hasil pengujian ini disetujui sebelum kita melanjutkan ke Modul 08 (Data Migration)?"*
4. Tunggu respon persetujuan eksplisit dari pengguna sebelum melangkah ke modul berikutnya.
