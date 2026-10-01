# Perjanjian Pemeliharaan Sistem & Tingkat Layanan (Monthly SLA Retainer)

**Nomor**: SLA/[KODE_PROYEK]/[BULAN_ROMAWI]/[TAHUN]

---

Perjanjian Pemeliharaan Sistem dan Tingkat Layanan (*Service Level Agreement*) ini dibuat dan ditandatangani pada hari ini, [Hari], tanggal [Tanggal] bulan [Bulan] tahun [Tahun], oleh dan antara:

1. **PIHAK PERTAMA (Klien)**:
   - Nama Perusahaan: [Nama PT / CV Klien]
   - Diwakili oleh: [Nama PIC / Direktur Klien]
   - Jabatan: [Jabatan Klien]
   - Selanjutnya disebut sebagai **"Klien"**.

2. **PIHAK KEDUA (Penyedia Layanan / Developer)**:
   - Nama Lengkap: [Nama Anda]
   - Profesi: Konsultan Rekayasa Perangkat Lunak Independen
   - NIK / NPWP: [Nomor Identitas / NPWP]
   - Selanjutnya disebut sebagai **"Developer"**.

---

### PASAL 1: RUANG LINGKUP LAYANAN PEMELIHARAAN (SCOPE OF SERVICES)

Developer berkewajiban memberikan layanan pemeliharaan perangkat lunak berkelanjutan untuk sistem `https://app.klien.com` yang mencakup:

1. **Pemeliharaan Preventif Rutin (Preventive Maintenance)**:
   - Pemantauan stabilitas server, status CPU/RAM, dan database connection pooling.
   - Pemasangan patch keamanan dependensi dan audit kerentanan bulanan (`pnpm audit`).
   - Verifikasi berkala terhadap keberhasilan pencadangan basis data harian (*Daily Backup Restore Test*).
2. **Alokasi Jam Kerja Bulanan (Dedicated Development Hours)**:
   - Klien mendapatkan jatah kuota pengembangan dan perbaikan sebesar **[10 / 15 / 30] Jam Kerja per Bulan**.
   - Kuota jam dapat digunakan secara fleksibel untuk: penambahan fitur minor, perbaikan bug sekunder, pembuatan variasi template baru, atau konsultasi arsitektur.
3. **Kebijakan Sisa Jam (Unused Hours Policy)**:
   - Jam kerja yang tidak terpakai dalam satu periode bulan akan kedaluwarsa dan tidak dapat diakumulasikan ke bulan berikutnya (*use it or lose it*), kecuali disepakati rollover maksimal 20% untuk satu bulan berikutnya.
4. **Tarif Kelebihan Jam (Overage Hours)**:
   - Pekerjaan yang membutuhkan waktu melebihi kuota bulanan akan ditagihkan dengan tarif tambahan sebesar **Rp [Tarif_Per_Jam] per jam kerja** setelah mendapat persetujuan tertulis dari Klien.

---

### PASAL 2: TINGKAT LAYANAN & WAKTU TANGGAP (SLA MATRIX)

Developer memberikan komitmen waktu tanggap (*response time*) dan penyelesaian pada jam kerja resmi (Senin–Jumat, 09.00–17.00 WIB):

| Severity Level | Kriteria Gangguan | Waktu Tanggap Respon Awal | Target Resolusi Masalah |
| :---: | :--- | :---: | :---: |
| **Severity 1 (Kritis)** | Seluruh aplikasi mati (*down*) atau database tidak dapat diakses | **$< 1$ Jam** (Siaga 24/7 untuk Paket Gold) | **$< 12$ Jam** |
| **Severity 2 (Mayor)** | Fitur penting terganggu namun sistem masih dapat beroperasi | **$< 4$ Jam Kerja** | **$< 24$ Jam Kerja** |
| **Severity 3 (Minor)** | Permintaan penyesuaian teks, tampilan, atau pertanyaan konsultasi | **$< 8$ Jam Kerja** | Dijadwalkan sesuai antrean |

---

### PASAL 3: BIAYA LAYANAN & KETENTUAN PEMBAYARAN

1. **Biaya Retainer Bulanan**: Sebesar **Rp [Nominal Angka]** (*[Terbilang dalam Rupiah]*) per bulan, di luar biaya langganan server cloud pihak ketiga (S3/VPS/Domain).
2. **Ketentuan Penagihan**:
   - Biaya retainer dibayarkan **di muka (Pre-paid)** selambat-lambatnya pada tanggal **1 (satu)** setiap bulannya.
   - Developer berhak menghentikan sementara layanan dukungan (*support suspension*) apabila pembayaran bulanan belum diterima hingga tanggal 7 pada bulan berjalan.
3. **Rekening Pembayaran Resmi**:
   - Bank: [Nama Bank]
   - Nomor Rekening: [Nomor Rekening]
   - Atas Nama: [Nama Anda]

---

### PASAL 4: JANGKA WAKTU & PENGAKHIRAN PERJANJIAN

1. Perjanjian ini berlaku selama **[6 / 12] bulan** terhitung sejak tanggal [Tanggal Mulai] sampai dengan [Tanggal Berakhir], dan dapat diperpanjang secara otomatis atas kesepakatan kedua belah pihak.
2. Masing-masing pihak berhak mengakhiri perjanjian ini dengan memberikan pemberitahuan tertulis selambat-lambatnya **30 (tiga puluh) hari kalender** sebelum tanggal pemutusan efektif.

---

Perjanjian ini dibuat dalam rangkap 2 (dua), bermeterai cukup (Rp 10.000,-), dan mengikat kedua belah pihak sejak tanggal ditandatangani.

| PIHAK PERTAMA (Klien) | PIHAK KEDUA (Developer) |
| :---: | :---: |
| [Nama Perusahaan Klien] | Independent Software Consultant |
| *(Meterai Rp 10.000,-)* | *(Meterai Rp 10.000,-)* |
| _____________________________ | _____________________________ |
| **[Nama PIC Klien]** | **[Nama Anda]** |
| [Jabatan Resmi Klien] | Independent Lead Software Engineer |
