# Perjanjian Kerja Sama & Statement of Work (SOW)

> Dokumen perjanjian kerja komersial yang mengikat hak, kewajiban, nilai kompensasi, termin pembayaran, dan proteksi hukum antara Klien dan Solo Developer.

---

## 1. Identitas Para Pihak

Perjanjian ini dibuat dan disepakati pada hari ini, [Hari], tanggal [Tanggal] bulan [Bulan] tahun [Tahun], oleh dan antara:

1. **PIHAK PERTAMA (Klien)**:
   - Nama Perusahaan: [Nama PT / CV / Organisasi Klien]
   - Alamat: [Alamat Lengkap Kantor Klien]
   - Diwakili oleh: [Nama PIC / Direktur Klien]
   - Jabatan: [Jabatan Resmi]
   - Selanjutnya disebut sebagai **"Klien"**.

2. **PIHAK KEDUA (Developer)**:
   - Nama Lengkap: [Nama Anda]
   - Alamat / Domisili: [Alamat Domisili Anda]
   - NIK / NPWP: [Nomor Identitas / Pajak]
   - Bertindak sebagai: Profesional Konsultan Rekayasa Perangkat Lunak Independen
   - Selanjutnya disebut sebagai **"Developer"**.

---

## 2. Ruang Lingkup Pekerjaan (Scope of Work)

1. Developer berkewajiban membangun perangkat lunak sesuai dengan rincian fitur yang tercantum dalam dokumen lampiran **SCOPE_STATEMENT.md** (Lampiran I) dan **PROJECT_CHARTER.md** (Lampiran II).
2. Segala hal yang tidak tercantum secara tertulis dalam Lampiran I secara hukum berstatus **Out-of-Scope (Di Luar Lingkup)** dan tidak dapat dituntut sebagai kewajiban Developer.

---

## 3. Nilai Kompensasi & Skema Termin Pembayaran

1. **Total Nilai Pekerjaan**: Rp [Nominal Angka] (*[Terbilang dalam Rupiah]*), di luar Pajak Pertambahan Nilai (PPN) dan biaya langganan infrastruktur pihak ketiga (server, cloud storage, API berbayar).
2. **Tahapan Pembayaran (Termin)**:
   - **Termin 1 (Uang Muka / DP 30% - 50%)**: Sebesar Rp [Nominal], dibayarkan saat penandatanganan perjanjian ini sebagai prasyarat dimulainya pekerjaan.
   - **Termin 2 (Alpha Delivery 25%)**: Sebesar Rp [Nominal], dibayarkan setelah fungsionalitas core engine backend dan antarmuka dasar diverifikasi di lingkungan lokal/staging.
   - **Termin 3 (Beta Delivery & SIT 25%)**: Sebesar Rp [Nominal], dibayarkan setelah seluruh modul terintegrasi dan siap diuji coba untuk proses User Acceptance Test (UAT).
   - **Termin 4 (Pelunasan 10% - 20%)**: Sebesar Rp [Nominal], dibayarkan selambat-lambatnya 7 (tujuh) hari kerja setelah Berita Acara UAT disetujui, sebelum penyerahan repositori kode sumber dan BAST.
3. **Rekening Pembayaran Resmi**:
   - Bank: [Nama Bank, misal: Bank Central Asia]
   - Nomor Rekening: [Nomor Rekening]
   - Atas Nama: [Nama Pemilik Rekening Sesuai Identitas Developer]

---

## 4. Ketergantungan Klien & Jadwal Pelaksanaan

1. Klien wajib menyerahkan seluruh data, akun akses, dan materi yang tercantum dalam tabel Ketergantungan Klien (*Client Dependency Register*) tepat waktu.
2. Apabila Klien terlambat menyerahkan materi atau memberikan tanggapan peninjauan (*review*) melebihi **3 (tiga) hari kerja**, maka target waktu penyelesaian proyek secara otomatis bergeser sejumlah hari keterlambatan tersebut tanpa penalti bagi Developer.

---

## 5. Prosedur Perubahan Lingkup (Change Request / CR)

1. Apabila Klien menghendaki penambahan fitur, perubahan alur, atau penyesuaian desain di luar kesepakatan awal, Klien wajib mengajukan secara tertulis kepada Developer.
2. Developer berhak mengajukan penyesuaian biaya tambahan dan perpanjangan jadwal pengerjaan (*Change Request Sheet*).
3. Pekerjaan perubahan lingkup baru akan dieksekusi setelah lembar CR disetujui dan dibayarkan oleh Klien.

---

## 6. Hak Kekayaan Intelektual (Intellectual Property Rights)

1. Seluruh kode sumber (*source code*), rancangan arsitektur, dan aset digital perangkat lunak tetap menjadi hak milik intelektual Developer sampai dengan seluruh nilai kompensasi proyek (100%) dilunasi oleh Klien.
2. Pengalihan hak penggunaan (*license*) atau hak kepemilikan penuh kepada Klien baru berlaku efektif sejak tanggal penandatanganan **Berita Acara Serah Terima (BAST)** setelah pembayaran lunas.

---

## 7. Batasan Tanggung Jawab (Limitation of Liability)

1. Developer menjamin perangkat lunak dibangun menggunakan praktik rekayasa perangkat lunak standar industri dan bebas dari instruksi berbahaya (*malicious code*).
2. Developer tidak bertanggung jawab atas kerugian bisnis tidak langsung, kehilangan profit, gangguan operasional, atau denda regulasi yang dialami Klien akibat penggunaan perangkat lunak ini.
3. Total tanggung jawab hukum dan ganti rugi finansial maksimum Developer kepada Klien dalam kondisi apapun dibatasi maksimal sebesar **total nilai uang yang telah diterima Developer** berdasarkan perjanjian ini.

---

## 8. Kerahasiaan Data & Kepatuhan UU PDP

Para Pihak sepakat untuk menjaga kerahasiaan informasi bisnis, data teknis, dan data pribadi sesuai dengan Undang-Undang Nomor 27 Tahun 2022 tentang Perlindungan Data Pribadi (UU PDP). Informasi rahasia tidak boleh disebarluaskan kepada pihak ketiga tanpa persetujuan tertulis dari pihak pemilik data.

---

## 9. Garansi Pemeliharaan (Warranty Period)

1. Developer memberikan masa garansi perbaikan kerusakan (*bug fix*) selama **[30 / 60 / 90] hari kalender** terhitung sejak penandatanganan BAST.
2. Garansi hanya berlaku untuk perbaikan galat (*error/bug*) murni di mana sistem tidak berjalan sesuai dengan dokumen FSD/PRD yang telah disepakati.
3. Garansi gugur apabila kode sumber diubah oleh pihak ketiga tanpa persetujuan Developer, atau kerusakan terjadi akibat perubahan API pihak ketiga secara mendadak.

---

## 10. Pengesahan Perjanjian

Perjanjian ini dibuat dalam rangkap 2 (dua), bermeterai cukup (Rp 10.000,-), dan memiliki kekuatan hukum yang sama bagi kedua belah pihak.

| PIHAK PERTAMA (Klien) | PIHAK KEDUA (Developer) |
| :---: | :---: |
| [Nama Perusahaan Klien] | Independent Software Consultant |
| *(Meterai Rp 10.000)* | *(Meterai Rp 10.000)* |
| _____________________________ | _____________________________ |
| **Nama**: [Nama PIC Klien] | **Nama**: [Nama Anda] |
| **Jabatan**: [Jabatan Klien] | **Jabatan**: Independent Lead Engineer |
| Tanggal: _____________________ | Tanggal: _____________________ |
