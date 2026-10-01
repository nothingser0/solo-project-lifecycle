# Kebijakan Masa Garansi Pemeliharaan (Warranty Policy)

> Ketentuan resmi mengenai cakupan, batasan, jam layanan, dan prosedur pelaporan perbaikan galat (*bug fix*) selama masa garansi pascapenandatanganan BAST.

---

## 1. Parameter Garansi
- **Nama Sistem**: [Nama Aplikasi]
- **Pihak Klien**: [Nama Perusahaan Klien]
- **Lead Developer**: [Nama Anda]
- **Nomor Referensi BAST**: BAST/[ID_PROYEK]/[TAHUN]
- **Tanggal Mulai Garansi**: [YYYY-MM-DD] (Sesuai tanggal BAST)
- **Tanggal Berakhir Garansi**: [YYYY-MM-DD] (30 / 60 / 90 Hari Kalender)

---

## 2. Cakupan Garansi (Apa yang Termasuk & Dilindungi)

Garansi berlaku **HANYA untuk perbaikan galat murni (Bug Fixes)**:
1. Kesalahan logika pemrograman di mana fungsi sistem tidak berjalan sesuai dengan dokumen spesifikasi teknis **FSD.md** atau **PRD.md**.
2. Gangguan keamanan kritis (*security vulnerability*) pada kode aplikasi yang ditulis oleh Developer.
3. Terjadinya galat internal server (*HTTP 500 Server Error*) yang dipicu oleh alur kerja normal yang telah disetujui pada sesi UAT.

---

## 3. Pengecualian Garansi (Apa yang TIDAK Termasuk)

Garansi secara hukum **TIDAK BERLAKU** untuk kondisi berikut:
1. **Permintaan Fitur Baru (New Features)**: Penambahan modul baru, pembuatan template dokumen baru, atau perubahan format laporan yang belum tercantum di PRD.
2. **Perubahan Desain Visual (UI Layout)**: Pemindahan posisi tombol, perubahan warna brand, atau perombakan sitemap navigasi setelah dokumen *Design Freeze* disahkan.
3. **Kesalahan Pengoperasian Pengguna (User Error)**: Penghapusan data master oleh staf klien yang tidak sengaja, lupa kata sandi masal, atau perangkat keras kantor klien yang terkena virus.
4. **Perubahan Pihak Ketiga Eksternal**: Perubahan endpoint API, pembaruan kebijakan mendadak, atau gangguan server pada penyedia pihak ketiga (Payment Gateway, Cloudflare, AWS/GCP, SMTP).
5. **Modifikasi Kode Tanpa Izin**: Kode sumber telah diubah atau dimodifikasi oleh tim internal klien atau pihak ketiga lainnya tanpa persetujuan tertulis dari Developer.

---

## 4. Jam Layanan & Matriks Perjanjian Tingkat Layanan (SLA)

- **Jam Layanan Resmi**: **Senin s/d Jumat, pukul 09.00 – 17.00 WIB** (Hari libur nasional tidak dihitung).
- **Saluran Pelaporan Resmi**: Email ke `[email-support@domain.com]` atau grup koordinasi teknis resmi.

| Klasifikasi Kendala | Definisi Kendala | Batas Waktu Respon Awal | Target Resolusi Perbaikan |
| :--- | :--- | :---: | :---: |
| **Severity 1 (Kritis)** | Seluruh sistem mati total (*down*), transaksi pembayaran gagal total, data korup | **$< 2$ Jam Kerja** | **$< 24$ Jam Kerja** |
| **Severity 2 (Mayor)** | Fitur penting tidak berjalan namun masih ada cara alternatif (*workaround*) | **$< 8$ Jam Kerja** | **$< 48$ Jam Kerja** |
| **Severity 3 (Minor)** | Kesalahan penulisan teks (*typo*), format tampilan agak bergeser sedikit | **$< 24$ Jam Kerja** | Dijadwalkan pada rilis pembaruan mingguan |

---

## 5. Prosedur Setelah Masa Garansi Berakhir

Setelah tanggal berakhirnya masa garansi terlewati:
- Segala bentuk perbaikan galat, pembaruan keamanan, dan bantuan teknis akan dikenakan tarif per jam (*Time & Materials*) standar industri atau diatur melalui **Kontrak Pemeliharaan Bulanan (Monthly Retainer SLA)**.
