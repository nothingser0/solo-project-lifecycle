# Buku Kerja Pengujian Penerimaan Pengguna (UAT Workbook)

> Dokumen gabungan skenario pengujian UAT dan log pelacakan kendala untuk periode pengujian penerimaan sistem oleh Single PIC Klien.

---

## BAGIAN I: SKENARIO PENGUJIAN UAT

### 1. Informasi Lingkungan & Kredensial Pengujian
- **URL Server Staging**: `https://staging.domainklien.com`
- **Periode Pengujian (Testing Window)**: [Tanggal Mulai] s/d [Tanggal Selesai] (Maksimal 7 Hari Kerja)
- **Akun Penguji (Tester Credentials)**:
  - Super Admin: `tester-admin@staging.local` / `UatTest2026!`
  - Staf Operasional: `tester-staff@staging.local` / `UatTest2026!`

---

### 2. Lembar Kerja Skenario Pengujian UAT

#### Skenario 1: Alur Masuk & Autentikasi Pengguna
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

#### Skenario 2: Pembuatan Draf Dokumen Baru
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

#### Skenario 3: Penandatanganan Digital & Penguncian Dokumen
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

---

## BAGIAN II: LOG PELACAKAN KENDALA UAT

### 1. Metadata Pengujian
- **Nama Sistem**: [Nama Aplikasi]
- **Periode Pelaporan**: [Tanggal Mulai] s/d [Tanggal Selesai]
- **Single PIC Penguji**: [Nama PIC Klien]
- **Lead Developer**: [Nama Anda]

---

### 2. Tabel Pelacakan Cacat / Bug (Defect Tracking Table)

| ID Bug | Tanggal Lapor | Modul / Halaman | Deskripsi Masalah & Langkah Reproduksi | Severity (1/2/3/CR) | Status Penanganan | Tanggal Resolusi | Verifikasi Ulang Klien |
| :---: | :---: | :--- | :--- | :---: | :---: | :---: | :---: |
| **BUG-01** | [YYYY-MM-DD] | Form Dokumen | Tanggal lahir tidak bisa dipilih jika sebelum tahun 1980 | **Severity 2** | `CLOSED` | [YYYY-MM-DD] | [x] Terverifikasi Lolos |
| **BUG-02** | [YYYY-MM-DD] | E-Sign Canvas | Tombol clear canvas tidak mereset goresan tanda tangan | **Severity 3** | `CLOSED` | [YYYY-MM-DD] | [x] Terverifikasi Lolos |
| **CR-01**  | [YYYY-MM-DD] | Notifikasi | Klien meminta integrasi notifikasi SMS selain email | **Out-of-Scope** | `DIALIHKAN KE CR` | - | Masuk Lembar CR #02 |

---

### 3. Definisi Status Penanganan
- **`OPEN`**: Masalah baru dilaporkan oleh tester klien dan sedang dalam antrean triase.
- **`IN_PROGRESS`**: Masalah valid sedang diperbaiki oleh developer di branch `fix/*`.
- **`RESOLVED`**: Perbaikan telah di-deploy ke server Staging dan siap diuji ulang oleh klien.
- **`CLOSED`**: PIC Klien telah menguji ulang di Staging dan mengonfirmasi bug telah tuntas.
- **`DIALIHKAN KE CR`**: Permintaan di luar lingkup PRD/FSD yang dialihkan ke penawaran *Change Request* berbayar.

---

### 4. Rekapitulasi Status Akhir Triase

- **Total Temuan Dilaporkan**: [ ] Temuan
- **Severity 1 (Blocker)**: [0] Open  *(Wajib 0 untuk UAT Sign-Off)*
- **Severity 2 (Major)**: [0] Open  *(Wajib 0 untuk UAT Sign-Off)*
- **Severity 3 (Minor)**: [ ] Resolved / Dijadwalkan saat garansi
- **Permintaan Fitur Baru (CR)**: [ ] Dialihkan ke Fase Lanjutan / Dokumen CR

---

### 5. Lembar Persetujuan UAT

Setelah seluruh skenario pengujian lolos dan bug Severity 1 & 2 tuntas, Single PIC Klien menandatangani lembar persetujuan UAT:

| Single PIC Klien | Lead Developer |
| :--- | :--- |
| **Nama**: _________________________ | **Nama**: _________________________ |
| **Jabatan**: ______________________ | **Jabatan**: Independent Lead Engineer |
| **Tanggal**: ______________________ | **Tanggal**: ______________________ |
| **Tanda Tangan**: | **Tanda Tangan**: |
