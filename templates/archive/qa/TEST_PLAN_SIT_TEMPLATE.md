# Rencana Pengujian Integrasi Sistem (System Integration Test Plan)

> Dokumen acuan skenario pengujian integrasi sistem perangkat lunak terhadap komponen internal dan layanan pihak ketiga di lingkungan Staging.

---

## 1. Metadata Pengujian
- **Nama Sistem**: [Nama Aplikasi]
- **Lingkungan Pengujian**: Server Staging (`https://staging.domainklien.com`)
- **Penanggung Jawab / Solo QA & Dev**: [Nama Anda]
- **Target Tanggal Eksekusi**: [YYYY-MM-DD]
- **Referensi Dokumen**: FSD-[ID] v1.0 & PRD-[ID] v1.0

---

## 2. Cakupan Pengujian Integrasi (Testing Scope)

### In-Scope
1. Integrasi API internal antara frontend dan backend database.
2. Integrasi payment gateway sandbox (penerbitan tagihan & penanganan webhook).
3. Integrasi penyimpanan berkas Cloudflare R2 / S3 (enkripsi & presigned URL).
4. Integrasi pengiriman email transaksional (SMTP / Resend).

### Out-of-Scope
- Pengujian beban ekstrim $> 10.000$ concurrent users (di luar kapasitas yang disepakati).
- Pengujian fisik perangkat keras jaringan kantor klien.

---

## 3. Matriks Skenario Pengujian (SIT Test Matrix)

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

## 4. Kriteria Kelulusan Pengujian (Entry & Exit Criteria)
- **Kriteria Mulai (Entry)**: Seluruh kode di branch `staging` lulus kompilasi TypeScript dan unit test lokal 100%.
- **Kriteria Selesai (Exit)**:
  - 100% skenario pengujian di atas berstatus **PASS**.
  - Bebas dari bug tingkat keparahan Kritis (*Critical/Blocker*).
  - Laporan `SIT_REPORT.md` diterbitkan dan siap ditinjau untuk membuka sesi UAT Klien.
