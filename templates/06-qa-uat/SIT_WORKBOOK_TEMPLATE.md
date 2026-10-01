# Buku Kerja Pengujian Integrasi Sistem (SIT Workbook)

> Dokumen gabungan rencana pengujian integrasi sistem dan laporan bukti kelulusan untuk lingkungan Staging sebelum UAT Klien.

---

## BAGIAN I: RENCANA PENGUJIAN SIT (TEST PLAN)

### 1. Metadata Pengujian
- **Nama Sistem**: [Nama Aplikasi]
- **Lingkungan Pengujian**: Server Staging (`https://staging.domainklien.com`)
- **Penanggung Jawab / Solo QA & Dev**: [Nama Anda]
- **Target Tanggal Eksekusi**: [YYYY-MM-DD]
- **Referensi Dokumen**: FSD-[ID] v1.0 & PRD-[ID] v1.0

---

### 2. Cakupan Pengujian Integrasi (Testing Scope)

#### In-Scope
1. Integrasi API internal antara frontend dan backend database.
2. Integrasi payment gateway sandbox (penerbitan tagihan & penanganan webhook).
3. Integrasi penyimpanan berkas Cloudflare R2 / S3 (enkripsi & presigned URL).
4. Integrasi pengiriman email transaksional (SMTP / Resend).

#### Out-of-Scope
- Pengujian beban ekstrim $> 10.000$ concurrent users (di luar kapasitas yang disepakati).
- Pengujian fisik perangkat keras jaringan kantor klien.

---

### 3. Matriks Skenario Pengujian (SIT Test Matrix)

| ID Tes | Modul / Layanan | Skenario Pengujian | Hasil yang Diharapkan | Kriteria Lolos |
| :---: | :--- | :--- | :--- | :---: |
| **SIT-01** | Auth API | Login dengan akun staff yang valid | Mendapat token sesi HttpOnly, redirect ke dashboard | PASS / FAIL |
| **SIT-02** | Document API | Buat dokumen dengan data valid | Dokumen tersimpan di DB, status `DRAFT`, ID terbit | PASS / FAIL |
| **SIT-03** | Vault Storage | Render PDF dan simpan ke Cloud Storage | File PDF tersimpan terenkripsi biner AES-256 | PASS / FAIL |
| **SIT-04** | Presigned URL | Ambil tautan unduh dokumen | URL dapat diakses dan kedaluwarsa setelah 15 menit | PASS / FAIL |
| **SIT-05** | E-Sign API | Eksekusi tanda tangan digital via token | Tanda tangan tersimpan, status dokumen `SIGNED` | PASS / FAIL |
| **SIT-06** | Email Sandbox | Kirim notifikasi link penandatangan | Email terkirim ke alamat tujuan dengan format rapi | PASS / FAIL |
| **SIT-07** | Payment Webhook | Kirim payload webhook transaksi sukses | Status pesanan otomatis berubah dari `PENDING` $\to$ `PAID` | PASS / FAIL |
| **SIT-08** | Idempotency | Kirim request checkout ganda (double-click) | Request kedua ditolak `409 Conflict`, tidak ada data dobel | PASS / FAIL |

---

### 4. Kriteria Kelulusan Pengujian (Entry & Exit Criteria)
- **Kriteria Mulai (Entry)**: Seluruh kode di branch `staging` lulus kompilasi TypeScript dan unit test lokal 100%.
- **Kriteria Selesai (Exit)**:
  - 100% skenario pengujian di atas berstatus **PASS**.
  - Bebas dari bug tingkat keparahan Kritis (*Critical/Blocker*).
  - Laporan Bagian II (SIT Report) diterbitkan dan siap ditinjau untuk membuka sesi UAT Klien.

---

## BAGIAN II: LAPORAN HASIL SIT (SIT REPORT)

### 1. Metadata Laporan
- **Nama Sistem**: [Nama Aplikasi]
- **Versi Build di Staging**: `v0.9.0-rc1` (Commit: `[git-hash]`)
- **URL Server Staging**: `https://staging.domainklien.com`
- **Tanggal Selesai Pengujian**: [YYYY-MM-DD]
- **Penguji / Lead Engineer**: [Nama Anda]
- **Status Akhir Pengujian**: **LULUS (SIT PASS - READY FOR UAT)**

---

### 2. Ringkasan Eksekusi Pengujian (Execution Summary)

| Kategori Pengujian | Total Skenario | Lolos (Pass) | Gagal (Fail) | Persentase Kelulusan |
| :--- | :---: | :---: | :---: | :---: |
| **Unit & Logic Tests** | [contoh: 24] | 24 | 0 | **100%** |
| **API Contract Tests** | [contoh: 12] | 12 | 0 | **100%** |
| **Third-Party Integrations** | [contoh: 8] | 8 | 0 | **100%** |
| **Security & OWASP Sanity** | 10 | 10 | 0 | **100%** |
| **TOTAL** | **[Total]** | **[Total]** | **0** | **100%** |

---

### 3. Rincian Hasil Pengujian Integrasi Pihak Ketiga

1. **Penyimpanan Dokumen (Cloudflare R2 / AWS S3)**:
   - *Status*: **PASS**
   - *Bukti*: File PDF dokumen berhasil diunggah dalam kondisi terenkripsi AES-256-GCM. Tautan unduh presigned URL berhasil diterbitkan dan otomatis kedaluwarsa setelah 15 menit.
2. **Payment Gateway Sandbox (Midtrans / Xendit)**:
   - *Status*: **PASS**
   - *Bukti*: Simulasi pembayaran transfer bank dan QRIS berhasil memicu webhook ke server staging, status pesanan otomatis berganti menjadi `PAID` tanpa intervensi manual.
3. **Email Transaksional (Resend / SMTP)**:
   - *Status*: **PASS**
   - *Bukti*: Pengiriman email tautan penandatanganan dokumen tiba di inbox dalam waktu $< 5\text{ detik}$ dengan tombol tanda tangan aktif.

---

### 4. Hasil Uji Beban & Konkurensi (Load Test Metrics)

Alat Uji: `k6` / `autocannon`
- **Jumlah Pengguna Bersamaan (Concurrent Users)**: 50 Virtual Users
- **Durasi Pengujian**: 30 Detik
- **Total Request Diproses**: [contoh: 4.850 requests]
- **Rata-rata Waktu Respon (Latency p95)**: **142 ms** (Batas target: $\le 200\text{ ms}$)
- **Tingkat Kegagalan (Error Rate)**: **0.00%** (Nol request gagal)
- **Status Basis Data**: Beban koneksi pool stabil, tidak terjadi *connection timeout*.

---

### 5. Rekomendasi Gerbang (Gate Recommendation)

Berdasarkan seluruh hasil pengujian teknis, integrasi sistem pihak ketiga, audit keamanan, dan uji beban di atas:

Sistem dinyatakan **STABIL, AMAN, DAN LOLOS PENGUJIAN INTEGRASI (SIT PASS)**.

Sistem secara resmi direkomendasikan untuk membuka sesi **User Acceptance Testing (UAT)** bersama **Single PIC Klien** di lingkungan Staging.

---

### 6. Lembar Pengesahan SIT

| Solo Lead Engineer | Single PIC Klien (Review) |
| :--- | :--- |
| **Nama**: _________________________ | **Nama**: _________________________ |
| **Jabatan**: Independent Lead Engineer | **Jabatan**: ______________________ |
| **Tanggal**: ______________________ | **Tanggal**: ______________________ |
| **Tanda Tangan**: | **Tanda Tangan**: |
