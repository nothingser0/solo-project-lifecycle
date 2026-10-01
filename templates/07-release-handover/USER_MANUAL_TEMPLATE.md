# Buku Panduan Pengguna Sistem (User Manual)

> Panduan operasional praktis bagi staf dan administrator dalam menggunakan fitur-fitur aplikasi perangkat lunak sehari-hari.

---

## 1. Informasi Sistem & Akses Masuk
- **Nama Aplikasi**: [Nama Aplikasi]
- **Alamat URL Resmi**: `https://app.klien.com`
- **Peramban yang Didukung**: Google Chrome, Safari, Microsoft Edge, Mozilla Firefox (Versi 2 tahun terakhir).

---

## 2. Panduan Masuk & Keamanan Akun
1. Buka tautan `https://app.klien.com/login`.
2. Masukkan alamat email kantor dan kata sandi yang telah didaftarkan oleh Administrator.
3. Klik tombol **"Masuk ke Akun"**.
4. *Tips Keamanan*: Jangan pernah membagikan kata sandi Anda kepada orang lain. Selalu klik menu **"Keluar (Logout)"** setelah selesai menggunakan komputer bersama.

---

## 3. Panduan Operasional Staf (Fitur Utama)

### 3.1 Membuat Dokumen Legal Baru
1. Masuk ke menu **"Manajemen Dokumen"** di bilah navigasi sebelah kiri.
2. Klik tombol **"Buat Dokumen Baru"** di pojok kanan atas.
3. Pilih jenis template yang diinginkan (contoh: *Perjanjian Kerja Lepas*).
4. Lengkapi formulir isian data:
   - Nama lengkap para pihak.
   - Nilai kompensasi (hanya ketik angka tanpa titik/koma, sistem otomatis memformat menjadi Rupiah).
   - Tanggal mulai dan tanggal berakhir kontrak.
5. Klik tombol **"Pratinjau Dokumen"** untuk memastikan isi pasal telah sesuai.
6. Klik **"Simpan Draf"** atau **"Kirim Permintaan Tanda Tangan"**.

### 3.2 Mengirim Tautan Tanda Tangan Digital
1. Buka detail dokumen yang berstatus `DRAFT`.
2. Masukkan nama dan alamat email penerima tanda tangan.
3. Klik **"Kirim Email Penandatanganan"**.
4. Status dokumen akan otomatis berubah menjadi `MENUNGGU TANDA TANGAN (PENDING)`.

---

## 4. Panduan Administrator (Fitur Manajemen)

### 4.1 Menambahkan Akun Pengguna Baru
1. Masuk ke menu **"Pengaturan"** $\to$ **"Manajemen Pengguna"**.
2. Klik tombol **"Tambah Pengguna"**.
3. Masukkan nama, email, dan pilih peran (*Role*):
   - **Staf**: Hanya bisa membuat dan melihat draf dokumen miliknya sendiri.
   - **Manager**: Bisa menyetujui draf dan mengirimkan tautan tanda tangan resmi.
   - **Super Admin**: Akses penuh ke seluruh data dan laporan audit sistem.
4. Klik **"Kirim Undangan Akun"**. Kata sandi sementara akan otomatis terkirim ke email pengguna baru.

### 4.2 Melihat Jejak Audit (Audit Trail Log)
1. Masuk ke menu **"Audit Trail"**.
2. Seluruh aktivitas pembuatan dokumen, waktu tanda tangan, alamat IP, dan nilai hash SHA-256 tersimpan secara permanen dan dapat diunduh dalam format Excel melalui tombol **"Ekspor Laporan"**.

---

## 5. Pertanyaan Umum & Bantuan (FAQ)
- **Bagaimana jika lupa kata sandi?**
  Klik tautan *"Lupa Kata Sandi"* pada halaman login, masukkan email Anda, dan ikuti instruksi reset yang dikirim ke inbox email.
- **Mengapa tautan tanda tangan tidak bisa dibuka?**
  Tautan tanda tangan digital memiliki batas kedaluwarsa keamanan selama 7 hari. Jika telah kedaluwarsa, staf dapat menerbitkan tautan baru melalui tombol *"Kirim Ulang Tautan"* pada detail dokumen.
