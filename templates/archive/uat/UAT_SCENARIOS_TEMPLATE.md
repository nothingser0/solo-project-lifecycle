# Skenario Pengujian Penerimaan Pengguna (UAT Scenarios)

> Panduan langkah pengujian sistem bagi pengguna akhir (*end-users*) dan Single PIC Klien di lingkungan server Staging.

---

## 1. Informasi Lingkungan & Kredensial Pengujian
- **URL Server Staging**: `https://staging.domainklien.com`
- **Periode Pengujian (Testing Window)**: [Tanggal Mulai] s/d [Tanggal Selesai] (Maksimal 7 Hari Kerja)
- **Akun Penguji (Tester Credentials)**:
  - Super Admin: `tester-admin@staging.local` / `UatTest2026!`
  - Staf Operasional: `tester-staff@staging.local` / `UatTest2026!`

---

## 2. Lembar Kerja Skenario Pengujian UAT

### Skenario 1: Alur Masuk & Autentikasi Pengguna
- **ID Skenario**: `UAT-SCN-01`
- **Tujuan Uji**: Memastikan pengguna dapat login dengan aman dan diarahkan ke dashboard kerja yang tepat.
- **Langkah Pengujian**:
  1. Buka URL `https://staging.domainklien.com/login`.
  2. Masukkan email dan kata sandi penguji staf.
  3. Klik tombol **"Masuk ke Akun"**.
- **Hasil yang Diharapkan**:
  - Halaman berpindah ke Dashboard Staf (`/dashboard`).
  - Nama pengguna penguji tampil di pojok kanan atas.
  - Sesi login tetap aktif saat tab browser ditutup dan dibuka kembali.
- **Hasil Pengujian Klien**: [ ] **LOLOS (PASS)**  /  [ ] **GAGAL (FAIL)**
- **Catatan Penguji**: __________________________________________________

---

### Skenario 2: Pembuatan Draf Dokumen Baru
- **ID Skenario**: `UAT-SCN-02`
- **Tujuan Uji**: Memastikan staf dapat mengisi formulir template dokumen dan sistem menghasilkan pratinjau PDF resmi.
- **Langkah Pengujian**:
  1. Dari dashboard, klik tombol **"Buat Dokumen Baru"**.
  2. Pilih jenis template **"Perjanjian Kerja Lepas (Freelance)"**.
  3. Isi kolom nama pihak, nominal kompensasi, dan tanggal berlaku.
  4. Klik tombol **"Generate Pratinjau Dokumen"**.
- **Hasil yang Diharapkan**:
  - Tampil pratinjau dokumen PDF di layar browser dalam waktu $< 5\text{ detik}$.
  - Data yang diketik di form tampil akurat pada isi pasal-pasal dokumen.
  - Status dokumen tercatat sebagai `DRAFT`.
- **Hasil Pengujian Klien**: [ ] **LOLOS (PASS)**  /  [ ] **GAGAL (FAIL)**
- **Catatan Penguji**: __________________________________________________

---

### Skenario 3: Penandatanganan Digital & Penguncian Dokumen
- **ID Skenario**: `UAT-SCN-03`
- **Tujuan Uji**: Memastikan penandatangan dapat menandatangani dokumen via tautan publik dan dokumen terkunci dari perubahan.
- **Langkah Pengujian**:
  1. Klik tombol **"Kirim Tautan Tanda Tangan"** ke email penandatangan.
  2. Buka tautan rahasia yang diterima di email.
  3. Bubuhkan tanda tangan pada kotak kanvas digital, lalu klik **"Simpan & Sahkan"**.
- **Hasil yang Diharapkan**:
  - Muncul layar konfirmasi tanda tangan berhasil.
  - Status dokumen di dashboard otomatis berubah menjadi `SIGNED (TERKUNCI)`.
  - Dokumen PDF final menampilkan gambar tanda tangan dan cap hash SHA-256 di bagian footer.
- **Hasil Pengujian Klien**: [ ] **LOLOS (PASS)**  /  [ ] **GAGAL (FAIL)**
- **Catatan Penguji**: __________________________________________________
