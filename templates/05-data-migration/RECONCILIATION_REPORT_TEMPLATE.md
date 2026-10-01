# Laporan Rekonsiliasi Migrasi Data (Migration Reconciliation Report)

> Dokumen resmi bukti hasil pemindahan data warisan (*legacy data*), pencocokan jumlah baris, daftar data ditolak, dan lembar pengesahan keabsahan data oleh Pihak Klien.

---

## 1. Metadata Eksekusi Migrasi
- **Nama Sistem**: [Nama Aplikasi]
- **Target Basis Data**: PostgreSQL Staging (`staging.domainklien.com`)
- **Eksekutor Migrasi**: [Nama Anda]
- **Tanggal Selesai Eksekusi**: [YYYY-MM-DD]
- **Berkas Sumber yang Diproses**: `[Nama_File_Sumber_1.xlsx]`, `[Nama_File_Sumber_2.csv]`

---

## 2. Tabel Rekonsiliasi Kuantitatif (Data Reconciliation Table)

| Entitas Data / Tabel | Total Baris Sumber ($N_{\text{src}}$) | Berhasil Terimpor ($N_{\text{imp}}$) | Gagal / Ditolak ($N_{\text{rej}}$) | Duplikat Diabaikan | Persentase Keberhasilan |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Pengguna (`users`)** | 450 | 442 | 8 | 0 | **98.2%** |
| **Dokumen (`documents`)**| 1.200 | 1.185 | 15 | 0 | **98.8%** |
| **Master Wilayah** | 100 | 100 | 0 | 0 | **100.0%** |
| **TOTAL** | **1.750** | **1.727** | **23** | **0** | **98.7%** |

---

## 3. Rincian & Penanganan Baris yang Ditolak (Rejected Rows)

Seluruh baris yang gagal diimpor telah dipisahkan secara otomatis ke dalam berkas lampiran **`rejected-rows.csv`**.

### Kategori Alasan Kegagalan:
1. **Format Email Rusak (8 Baris)**: Alamat email tidak memiliki simbol `@` atau domain tidak valid (contoh: `"budi.santoso.gmail"`).
2. **Ketergantungan Foreign Key Hilang (15 Baris)**: Dokumen lama mereferensikan nama pemilik yang tidak terdaftar di daftar pengguna manapun.

> **Tindakan Lanjutan**: Berkas `rejected-rows.csv` telah diserahkan kepada tim operasional Klien. Data perbaikan dapat diinput mandiri melalui form aplikasi setelah sistem go-live.

---

## 4. Uji Sampel Integritas Data (Data Integrity Spot-Check)

Developer dan PIC Klien telah melakukan uji petik (*spot-check*) acak terhadap 10 entri data di antarmuka Staging:
- [x] Nama lengkap, nomor identitas, dan status dokumen cocok dengan data asli.
- [x] Tanggal transaksi dan nilai nominal terkonversi dengan presisi tanpa distorsi angka.
- [x] Hak akses login akun sampel berfungsi sesuai peran yang ditentukan di PRD.

---

## 5. Lembar Pengesahan Keabsahan Data (Data Sign-Off)

Dengan menandatangani dokumen ini, Pihak Klien menyatakan telah memeriksa hasil rekonsiliasi data di atas dan menyetujui bahwa:
1. Data yang berhasil terimpor telah akurat dan sah untuk digunakan dalam sesi **User Acceptance Testing (UAT)**.
2. Baris data yang ditolak (*rejected rows*) menjadi tanggung jawab Klien untuk diperbaiki atau dilengkapi secara mandiri.

| Disahkan oleh Single PIC Klien | Dilaporkan oleh Solo Developer |
| :--- | :--- |
| **Nama**: _________________________ | **Nama**: _________________________ |
| **Jabatan**: ______________________ | **Jabatan**: Independent Lead Engineer |
| **Tanggal**: ______________________ | **Tanggal**: ______________________ |
| **Tanda Tangan**: | **Tanda Tangan**: |
