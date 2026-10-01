# Panduan Kriteria Kelayakan (Feasibility Criteria) Solo Developer

Dokumen ini adalah rubrik acuan objektif untuk mengevaluasi kelayakan ide perangkat lunak bagi solo developer sebelum menyepakati komitmen atau memulai koding.

---

## 1. Empat Dimensi Kelayakan Solo Developer

### 1.1 Kelayakan Teknis (Technical Feasibility)
Sebagai solo developer, batas kegagalan teknis sangat tipis. Hindari "Research & Development (R&D) Trap".

* **Skor 5 (Sangat Layak)**: Menggunakan stack teruji (Boring Tech), pustaka open-source populer (>5k bintang GitHub), API pihak ketiga memiliki dokumentasi resmi (OpenAPI/Swagger) dan SDK stabil.
* **Skor 3 (Layak dengan Catatan)**: Membutuhkan integrasi sistem pihak ketiga yang dokumentasinya minim, atau ada proses background worker yang membutuhkan penanganan failover cermat.
* **Skor 1 (Red Flag / Tidak Layak)**: Membutuhkan riset model AI dari nol, reverse-engineering API tertutup tanpa izin, integrasi hardware kustom tanpa simulator, atau dependensi yang belum stabil.

### 1.2 Kelayakan Bandwidth & Operasional (Solo Bandwidth Feasibility)
Solo dev memiliki batas kapasitas rata-rata **120–160 jam kerja produktif per bulan**.

* **Skor 5 (Sangat Layak)**:
  - Arsitektur berbasis PaaS/Serverless (Vercel, Supabase, Cloudflare, Railway) dengan zero server maintenance.
  - Alur bisnis otomatis tanpa intervensi manual developer harian (self-service).
* **Skor 3 (Layak dengan Catatan)**:
  - Membutuhkan setup VPS mandiri (Docker, Nginx, cron backup) yang membutuhkan monitoring mingguan.
* **Skor 1 (Red Flag / Tidak Layak)**:
  - Membutuhkan penanganan tiket operasional manual 24/7.
  - Arsitektur microservices terfragmentasi yang membebani debugging lokal.

### 1.3 Kelayakan Regulasi & Hukum (Compliance & Legal Feasibility)
Pelanggaran regulasi di Indonesia dapat berujung sanksi administratif hingga pidana.

* **Regulasi Data Pribadi (UU PDP No. 27/2022)**:
  - *Aturan*: Jika aplikasi mengumpulkan data KTP, data kesehatan, data finansial, atau data anak, wajib ada enkripsi saat transit dan at-rest, persetujuan eksplisit (consent), dan mekanisme penghapusan data.
* **Regulasi Tanda Tangan Elektronik (UU ITE & PP 71/2019)**:
  - *Tanda Tangan Tidak Tersertifikasi* (Canvas/Email OTP): Sah secara hukum perdata (KUHPerdata 1865/1866) namun memiliki kekuatan pembuktian lebih lemah di pengadilan jika disangkal.
  - *Tanda Tangan Tersertifikasi (PSrE)*: Wajib menggunakan vendor berizin Kominfo (Privy, VIDA, Peruri) jika menangani dokumen bernilai hukum tinggi / perbankan.
* **Regulasi Finansial (Bank Indonesia / OJK)**:
  - Solo developer **DILARANG KERAS** menyimpan data kartu kredit mentah di database. Wajib menggunakan Payment Gateway berlisensi (Midtrans, Xendit, Doku) yang memiliki sertifikasi PCI-DSS Level 1.
* **Klausul Disclaimer Wajib**:
  - Untuk produk legal-tech/health-tech: Aplikasi wajib menampilkan klausul bahwa sistem adalah penyedia teknologi pendukung, bukan pengganti advokat/dokter berlisensi.

### 1.4 Kelayakan Komersial & Nilai Proyek (Economic Feasibility)
* **Untuk Produk Mandiri (SaaS/Micro-app)**:
  - *Uji Willingness to Pay*: Apakah calon pengguna sudah mengeluarkan uang untuk mengatasi masalah ini sekarang? Jika mereka saat ini menggunakan solusi gratisan dan enggan membayar, ide tersebut berisiko tinggi.
* **Untuk Proyek Klien**:
  - *Rasio Nilai terhadap Waktu*: Nilai kontrak dibagi estimasi jam kerja harus memenuhi batas minimum tarif profesional per jam Anda.
  - Jika klien meminta sistem skala besar dengan budget skala kecil, proyek wajib ditolak atau dipangkas ke MVP dasar.

---

## 2. Sakelar Pembatal Otomatis (The "Kill Switch" Red Flags)

Jika menemukan salah satu kondisi di bawah ini, **BATALKAN PROYEK ATAU PIVOT SECARA TEGAS**:

1. **Bypassing / Scraping Ilegal**: Klien meminta membuat bot/scraper untuk mengambil data dari platform pihak ketiga yang secara eksplisit melarang bot di Ketentuan Layanannya (Terms of Service).
2. **Ketergantungan API Tanpa Izin**: Bisnis bergantung pada *undocumented/private API* milik platform lain yang bisa ditutup sewaktu-waktu.
3. **Ekspektasi Tim Besar dengan Harga Solo**: Klien menuntut ketersediaan support 24/7 dan SLA 99.99% tanpa bersedia membayar biaya infrastruktur berlebih dan retainer bulanan.
4. **Ketiadaan PIC Berwenang**: Klien tidak bisa menunjuk satu orang pengambil keputusan, sehingga arahan selalu berubah setiap kali rapat.
