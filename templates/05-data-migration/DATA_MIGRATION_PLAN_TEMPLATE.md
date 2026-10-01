# Rencana Migrasi Data (Data Migration Plan)

> Dokumen spesifikasi teknis pemetaan kolom, aturan transformasi data warisan (*legacy data*), dan batasan tanggung jawab pembersihan data antara Klien dan Developer.

---

## 1. Metadata Rencana Migrasi
- **Nama Sistem**: [Nama Aplikasi]
- **Klien**: [Perusahaan / Organisasi Klien]
- **Lead Data Engineer / Developer**: [Nama Anda]
- **Tanggal Rencana**: [YYYY-MM-DD]
- **Target Eksekusi**: Lingkungan Staging & Produksi

---

## 2. Batasan Tanggung Jawab (Data Hygiene Boundary)

1. **Tanggung Jawab Klien**:
   - Menyerahkan berkas data sumber dalam format digital terstruktur (CSV, Excel `.xlsx`, atau SQL Dump).
   - Bertanggung jawab penuh atas kebersihan isi data (*Data Hygiene*): menghapus duplikasi yang tidak sah, memperbaiki nama/nomor yang salah ketik, dan melengkapi kolom wajib yang kosong.
2. **Tanggung Jawab Developer**:
   - Menulis skrip ekstraksi, transformasi, dan pemuatan otomatis (*ETL Script*).
   - Memastikan data yang valid terimpor dengan integritas relasi tabel terjaga.
   - Menyediakan laporan baris yang ditolak (`rejected-rows.csv`) beserta alasan kegagalan validasi.
3. **Klausul Jasa Pembersihan Manual**:
   - Permintaan pembersihan manual atau perbaikan format data yang korup oleh developer di luar skrip otomatis akan dikenakan biaya tambahan melalui prosedur *Change Request (CR)*.

---

## 3. Matriks Pemetaan Kolom (Data Mapping Matrix)

### Entitas: Pengguna / Karyawan (Tabel `users`)
- **Berkas Sumber**: `Data_Karyawan_2026.xlsx` (Sheet 1)

| No | Kolom Sumber (Excel) | Tipe Data Asal | Kolom Target (Database SQL) | Tipe Target SQL | Aturan Transformasi / Default |
| :-: | :--- | :--- | :--- | :--- | :--- |
| 1 | `No_Induk` | Teks | `legacy_id` | `VARCHAR(50)` | Simpan sebagai referensi audit |
| 2 | `Nama Lengkap` | Teks | `full_name` | `VARCHAR(150)` | Trim spasi kiri/kanan, Title Case |
| 3 | `Alamat Email` | Teks | `email` | `VARCHAR(255)` | Lowercase, validasi regex RFC 5322 |
| 4 | `Jabatan / Peran` | Teks | `role` | `VARCHAR(30)` | Map: "Staff" $\to$ `staff`, "Head" $\to$ `manager` |
| 5 | - | - | `id` | `UUID` | Auto-generate UUIDv7 |
| 6 | - | - | `password_hash` | `VARCHAR(255)` | Hash password default sementara (Argon2id) |

---

## 4. Protokol Masking Data Sensitif di Staging (UU PDP Compliance)

Untuk menjaga kerahasiaan data pribadi sesuai UU PDP No. 27/2022 di lingkungan non-produksi:

| Kolom Sensitif | Nilai Asli (Produksi) | Nilai Masking di Server Staging |
| :--- | :--- | :--- |
| **NIK KTP** | `3578012304900001` | `357801********01` |
| **Nomor Telepon**| `081234567890` | `0812****7890` |
| **Alamat Email** | `budi.santoso@perusahaan.com` | `user_001@staging.local` |
| **Nomor Rekening**| `140001829104` | `******9104` |

---

## 5. Lembar Persetujuan Rencana Pemetaan Data

Dokumen ini menjadi acuan mutlak bagi penulisan skrip otomasi migrasi data.

| Disetujui oleh Single PIC Klien | Divalidasi oleh Solo Developer |
| :--- | :--- |
| **Nama**: _________________________ | **Nama**: _________________________ |
| **Jabatan**: ______________________ | **Jabatan**: Independent Lead Engineer |
| **Tanggal**: ______________________ | **Tanggal**: ______________________ |
| **Tanda Tangan**: | **Tanda Tangan**: |
