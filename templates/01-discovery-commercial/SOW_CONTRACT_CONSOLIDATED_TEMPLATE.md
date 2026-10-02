# Perjanjian Kerja Sama & Statement of Work (SOW)

> Dokumen perjanjian kerja komersial yang mengikat hak, kewajiban, nilai kompensasi, termin pembayaran, tata kelola proyek, dan proteksi hukum antara Klien dan Solo Developer.

---

## BAGIAN I: PROJECT CHARTER & TATA KELOLA

### 1. Metadata Inisiasi
- **Nama Sistem / Proyek**: [Nama Aplikasi / Sistem]
- **Pihak Klien**: [Nama Perusahaan / Organisasi Klien]
- **Lead Developer / Konsultan**: [Nama Anda]
- **Klasifikasi Skala**: [Kecil (MVP) / Menengah / Besar / Enterprise]
- **Target Tanggal Mulai**: [YYYY-MM-DD]
- **Target Tanggal Rilis Go-Live**: [YYYY-MM-DD]

---

### 2. Objektif Bisnis & Metrik Sukses
- **Latar Belakang Proyek**: [Jelaskan latar belakang dan urgensi proyek bagi klien]
- **Sasaran Terukur**:
  - [Sasaran 1: Contoh: Otomasi alur administrasi 100% tanpa kertas]
  - [Sasaran 2: Contoh: Waktu siklus proses pesanan terpangkas $\ge 50\%$]

---

### 3. Penunjukan Mutlak Single PIC Klien

Untuk mencegah kontradiksi arahan dan memastikan efisiensi eksekusi solo developer, Klien menunjuk:

- **Nama Lengkap PIC**: [Nama PIC Klien]
- **Jabatan Resmi**: [Product Owner / Manajer IT / Direktur Operasional]
- **Email & Kontak WhatsApp**: [email@perusahaan.com / +628...]
- **Kewenangan Eksklusif PIC**:
  1. Satu-satunya pihak yang berhak memberikan approval resmi terhadap PRD, FSD, dan perubahan desain UI/UX.
  2. Satu-satunya pihak yang berhak menandatangani lembar pengujian UAT dan Berita Acara Serah Terima (BAST).
  3. Instruksi atau permintaan perubahan dari staf klien lainnya **TIDAK DIAKUI** sebelum dikonfirmasi tertulis oleh PIC di atas.
- **SLA Respon Klien**: PIC Klien wajib memberikan tanggapan atau approval tertulis maksimal **3 (tiga) hari kerja**. Keterlambatan respon otomatis menggeser target rilis sistem tanpa penalti keterlambatan bagi developer.

---

### 4. Ringkasan Milestone & Jadwal Rilis

| Milestone | Deliverable Utama | Target Waktu | Status Pembayaran Terkait |
| :---: | :--- | :--- | :---: |
| **M-01** | Scope, Charter, & SOW Disepakati | Minggu ke-1 | Termin 1 (DP Diterima) |
| **M-02** | UI/UX Prototyping & Arsitektur (FSD) | Minggu ke-3 | Prasyarat Mulai Koding |
| **M-03** | Core Backend & Alpha Release | Minggu ke-6 | Termin 2 |
| **M-04** | Integrasi Lengkap & Staging (SIT Pass) | Minggu ke-9 | Termin 3 |
| **M-05** | UAT Pass & Production Go-Live | Minggu ke-11 | Termin 4 (Pelunasan 100%) |
| **M-06** | Serah Terima Repositori & BAST Signed | Minggu ke-12 | Proyek Selesai / Garansi Aktif |

---

## BAGIAN II: PERJANJIAN KOMERSIAL (SOW CONTRACT)

### 1. Identitas Para Pihak

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

### 2. Ruang Lingkup Pekerjaan (Scope of Work)

1. Developer berkewajiban membangun perangkat lunak sesuai dengan rincian fitur yang tercantum dalam dokumen lampiran **SCOPE_STATEMENT.md** (Lampiran I).
2. Segala hal yang tidak tercantum secara tertulis dalam Lampiran I secara hukum berstatus **Out-of-Scope (Di Luar Lingkup)** dan tidak dapat dituntut sebagai kewajiban Developer.

#### Batasan Lingkup Ringkas (Scope Baseline)

**In-Scope Utama**:
1. [Modul/Fitur 1]
2. [Modul/Fitur 2]
3. [Integrasi Layanan Pihak Ketiga X]
4. [Deployment Staging dan Production]

**Out-of-Scope Mutlak**:
1. [Entri data manual dokumen fisik masa lalu]
2. [Penyediaan aset kreatif kustom (ilustrasi berbayar/fotografi)]
3. [Pemeliharaan perangkat keras jaringan kantor lokal klien]
4. [Dukungan on-call di luar jam operasional kerja yang disepakati]

---

### 3. Nilai Kompensasi & Skema Termin Pembayaran

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

### 4. Ketergantungan Klien & Jadwal Pelaksanaan

1. Klien wajib menyerahkan seluruh data, akun akses, dan materi yang tercantum dalam tabel Ketergantungan Klien (*Client Dependency Register*) tepat waktu.
2. Apabila Klien terlambat menyerahkan materi atau memberikan tanggapan peninjauan (*review*) melebihi **3 (tiga) hari kerja**, maka target waktu penyelesaian proyek secara otomatis bergeser sejumlah hari keterlambatan tersebut tanpa penalti bagi Developer.

---

### 5. Prosedur Perubahan Lingkup (Change Request / CR)

1. Apabila Klien menghendaki penambahan fitur, perubahan alur, atau penyesuaian desain di luar kesepakatan awal, Klien wajib mengajukan secara tertulis kepada Developer.
2. Developer berhak mengajukan penyesuaian biaya tambahan dan perpanjangan jadwal pengerjaan (*Change Request Sheet*).
3. Pekerjaan perubahan lingkup baru akan dieksekusi setelah lembar CR disetujui dan dibayarkan oleh Klien.

---

### 6. Hak Kekayaan Intelektual (Intellectual Property Rights)

1. Seluruh kode sumber (*source code*), rancangan arsitektur, dan aset digital perangkat lunak tetap menjadi hak milik intelektual Developer sampai dengan seluruh nilai kompensasi proyek (100%) dilunasi oleh Klien.
2. Pengalihan hak penggunaan (*license*) atau hak kepemilikan penuh kepada Klien baru berlaku efektif sejak tanggal penandatanganan **Berita Acara Serah Terima (BAST)** setelah pembayaran lunas.

---

### 7. Batasan Tanggung Jawab (Limitation of Liability)

1. Developer menjamin perangkat lunak dibangun menggunakan praktik rekayasa perangkat lunak standar industri dan bebas dari instruksi berbahaya (*malicious code*).
2. Developer tidak bertanggung jawab atas kerugian bisnis tidak langsung, kehilangan profit, gangguan operasional, atau denda regulasi yang dialami Klien akibat penggunaan perangkat lunak ini.
3. Total tanggung jawab hukum dan ganti rugi finansial maksimum Developer kepada Klien dalam kondisi apapun dibatasi maksimal sebesar **total nilai uang yang telah diterima Developer** berdasarkan perjanjian ini.

---

### 8. Kerahasiaan Data & Kepatuhan UU PDP

Para Pihak sepakat untuk menjaga kerahasiaan informasi bisnis, data teknis, dan data pribadi sesuai dengan Undang-Undang Nomor 27 Tahun 2022 tentang Perlindungan Data Pribadi (UU PDP). Informasi rahasia tidak boleh disebarluaskan kepada pihak ketiga tanpa persetujuan tertulis dari pihak pemilik data.

---

### 9. Garansi Pemeliharaan (Warranty Period)

1. Developer memberikan masa garansi perbaikan kerusakan (*bug fix*) selama **[30 / 60 / 90] hari kalender** terhitung sejak penandatanganan BAST.
2. Garansi hanya berlaku untuk perbaikan galat (*error/bug*) murni di mana sistem tidak berjalan sesuai dengan dokumen FSD/PRD yang telah disepakati.
3. Garansi gugur apabila kode sumber diubah oleh pihak ketiga tanpa persetujuan Developer, atau kerusakan terjadi akibat perubahan API pihak ketiga secara mendadak.

---

### 10. Pengesahan Perjanjian

Perjanjian ini dibuat dalam rangkap 2 (dua), bermeterai cukup (Rp 10.000,- per UU No. 10/2020 Pasal 3 ayat 1), dan memiliki kekuatan hukum yang sama bagi kedua belah pihak.

| PIHAK PERTAMA (Klien) | PIHAK KEDUA (Developer) |
| :---: | :---: |
| [Nama Perusahaan Klien] | Independent Software Consultant |
| *(Meterai Rp 10.000)* | *(Meterai Rp 10.000)* |

**Catatan Legal**: Tanda tangan elektronik diakui sah per UU ITE No. 19/2016 Pasal 5 jo. PP 71/2019. Meterai elektronik dapat menggunakan layanan e-Meterai resmi Peruri.
| **Nama**: [Nama PIC Klien] | **Nama**: [Nama Anda] |
| **Jabatan**: [Jabatan Klien] | **Jabatan**: Independent Lead Engineer |
| Tanggal: _____________________ | Tanggal: _____________________ |
