# Project Charter & Tata Kelola Proyek

> Dokumen penyelarasan strategis untuk mengesahkan inisiasi proyek, mengunci wewenang Single PIC, dan menetapkan batasan wewenang sebelum development dimulai.

---

## 1. Metadata Inisiasi
- **Nama Sistem / Proyek**: [Nama Aplikasi / Sistem]
- **Pihak Klien**: [Nama Perusahaan / Organisasi Klien]
- **Lead Developer / Konsultan**: [Nama Anda]
- **Klasifikasi Skala**: [Kecil (MVP) / Menengah / Besar / Enterprise]
- **Target Tanggal Mulai**: [YYYY-MM-DD]
- **Target Tanggal Rilis Go-Live**: [YYYY-MM-DD]

---

## 2. Objektif Bisnis & Metrik Sukses
- **Latar Belakang Proyek**: [Jelaskan latar belakang dan urgensi proyek bagi klien]
- **Sasaran Terukur**:
  - [Sasaran 1: Contoh: Otomasi alur administrasi 100% tanpa kertas]
  - [Sasaran 2: Contoh: Waktu siklus proses pesanan terpangkas $\ge 50\%$]

---

## 3. Batasan Lingkup Ringkas (Scope Baseline)
*Mengacu pada dokumen SCOPE_STATEMENT.md:*

### In-Scope Utama
1. [Modul/Fitur 1]
2. [Modul/Fitur 2]
3. [Integrasi Layanan Pihak Ketiga X]
4. [Deployment Staging dan Production]

### Out-of-Scope Mutlak
1. [Entri data manual dokumen fisik masa lalu]
2. [Penyediaan aset kreatif kustom (ilustrasi berbayar/fotografi)]
3. [Pemeliharaan perangkat keras jaringan kantor lokal klien]
4. [Dukungan on-call di luar jam operasional kerja yang disepakati]

---

## 4. Penunjukan Mutlak Single PIC Klien

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

## 5. Ringkasan Milestone & Jadwal Rilis

| Milestone | Deliverable Utama | Target Waktu | Status Pembayaran Terkait |
| :---: | :--- | :--- | :---: |
| **M-01** | Scope, Charter, & SOW Disepakati | Minggu ke-1 | Termin 1 (DP Diterima) |
| **M-02** | UI/UX Prototyping & Arsitektur (FSD) | Minggu ke-3 | Prasyarat Mulai Koding |
| **M-03** | Core Backend & Alpha Release | Minggu ke-6 | Termin 2 |
| **M-04** | Integrasi Lengkap & Staging (SIT Pass) | Minggu ke-9 | Termin 3 |
| **M-05** | UAT Pass & Production Go-Live | Minggu ke-11 | Termin 4 (Pelunasan 100%) |
| **M-06** | Serah Terima Repositori & BAST Signed | Minggu ke-12 | Proyek Selesai / Garansi Aktif |

---

## 6. Lembar Persetujuan Piagam Proyek

Dokumen ini menjadi acuan mutlak dalam tata kelola komunikasi dan eksekusi teknis harian.

| Pihak Klien (Single PIC) | Pihak Developer / Konsultan |
| :--- | :--- |
| **Nama**: _________________________ | **Nama**: _________________________ |
| **Jabatan**: ______________________ | **Jabatan**: Independent Lead Engineer |
| **Tanggal**: ______________________ | **Tanggal**: ______________________ |
| **Tanda Tangan**: | **Tanda Tangan**: |
