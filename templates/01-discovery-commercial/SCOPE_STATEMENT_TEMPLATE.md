# Scope Statement & Requirements Breakdown

> Dokumen kesepakatan lingkup proyek awal hasil elisitasi kebutuhan untuk mengunci batas fungsional sebelum penandatanganan kontrak komersial dan estimasi harga.

---

## 1. Metadata Proyek
- **Nama Proyek**: [Nama Sistem / Aplikasi]
- **Klien**: [Perusahaan / Organisasi Klien]
- **Solo Developer / Konsultan**: [Nama Anda]
- **Referensi Dokumen**: IDEA_BRIEF-[ID] v1.0
- **Skala Proyek Ditetapkan**: [Kecil (MVP) / Menengah / Besar / Enterprise]
- **Tanggal Selesai Elisitasi**: [YYYY-MM-DD]

---

## 2. Objektif Bisnis & Sasaran Terukur
- **Masalah Utama yang Diselesaikan**: [Uraian singkat masalah bisnis klien]
- **Sasaran Utama Proyek**: [Contoh: Otomasi alur penerbitan invoice dan pelacakan pembayaran piutang]
- **Metrik Keberhasilan Bisnis**:
  - [Metrik 1: Penurunan waktu pembuatan kontrak dari 3 hari menjadi 10 menit]
  - [Metrik 2: 100% dokumen tersimpan terenkripsi sesuai UU PDP]

---

## 3. Matriks Peran Pengguna (User Roles & RBAC)

| Kode Peran | Nama Peran | Deskripsi Tanggung Jawab | Hak Akses Utama |
| :--- | :--- | :--- | :--- |
| **ROL-01** | Super Admin | Pengelola sistem internal tertinggi | Akses seluruh modul, audit trail, user management |
| **ROL-02** | Manager / Reviewer | Verifikator operasional | Menyetujui dokumen, melihat laporan analitik |
| **ROL-03** | Staf Operasional | Eksekutor input data harian | Membuat draf, mengirim notifikasi, input data |
| **ROL-04** | Client / Tamu Eksternal | Pengguna pihak ketiga | Mengisi formulir publik, membubuhkan tanda tangan |

---

## 4. Rincian Lingkup Fungsional (MoSCoW Breakdown)

| ID Fitur | Modul Terkait | Deskripsi Fungsionalitas | Prioritas | Kriteria Keberterimaan Awal (Acceptance Criteria) |
| :--- | :--- | :--- | :---: | :--- |
| **F-01** | Otentikasi | Login menggunakan Email & Password / OTP | **Must** | Password minimal 8 karakter, ada rate limit gagal 5x |
| **F-02** | Template Doc | Form input dinamis untuk 2 template legal | **Must** | Data form divalidasi dan terpetakan rapi ke variabel PDF |
| **F-03** | PDF Engine | Render dokumen PDF berformat baku A4 | **Must** | Dokumen ter-generate < 3 detik, font standar terbaca |
| **F-04** | E-Signature | Tanda tangan digital canvas + hash SHA-256 | **Must** | Menyimpan koordinat, IP address, user-agent, dan timestamp |
| **F-05** | Document Vault | Penyimpanan dokumen terenkripsi AES-256 | **Must** | Link unduh menggunakan presigned URL kedaluwarsa 15 menit |
| **F-06** | Export Excel | Ekspor daftar riwayat dokumen ke file .xlsx | **Should** | File terunduh berisi kolom tanggal, nama pihak, dan status |
| **F-07** | WA Notif | Pengiriman pesan status via WhatsApp gateway | **Could** | Jika integrasi API Fonnte/Twilio selesai lebih cepat |
| **F-08** | Multi-bahasa | Antarmuka dalam Bahasa Inggris & Mandarin | **Won't** | Resmi ditunda ke Fase 2 pengembangan berikutnya |

---

## 5. Batasan Lingkup Tegas (Scope Boundaries)

### 5.1 In-Scope (Pekerjaan yang DIKERJAKAN oleh Developer)
1. Perancangan arsitektur, basis data, dan antarmuka web responsif untuk fitur F-01 s/d F-06.
2. Integrasi penyimpanan cloud terenkripsi (AWS S3 / Cloudflare R2).
3. Penyediaan server Staging untuk pengujian dan server Production untuk rilis akhir.
4. Penyusunan dokumentasi manual penggunaan sistem untuk admin dan staf.

### 5.2 Out-of-Scope (Pekerjaan yang TIDAK TERMASUK & Tidak Boleh Dituntut)
1. **Entri Data Manual**: Developer tidak bertanggung jawab menginput ribuan data dokumen fisik lama klien.
2. **Kustomisasi API Tanpa Dokumentasi**: Segala integrasi ke sistem internal klien yang tidak memiliki REST API resmi dengan dokumentasi lengkap.
3. **Penyediaan Perangkat Keras / Hardware**: Komputer, printer, scanner, atau jaringan kabel kantor klien.
4. **Nasihat Hukum (Legal Counsel)**: Developer hanya menyediakan platform teknologi; validitas hukum isi pasal kontrak sepenuhnya tanggung jawab penasihat hukum internal klien.
5. **Revisi Tak Terbatas**: Revisi alur di luar dokumen ini akan masuk ke skema *Change Request (CR)* berbayar.

---

## 6. Daftar Ketergantungan Klien (Client Dependency Register)

*Pengerjaan proyek terikat pada ketepatan waktu Klien dalam menyerahkan dependensi berikut:*

| Kode Dep | Kebutuhan dari Pihak Klien | Tenggat Penyerahan | Konsekuensi Jika Terlambat |
| :--- | :--- | :--- | :--- |
| **DEP-01** | Dokumen teks final klausul template legal (format Word) | Hari ke-3 Proyek | Penundaan pengerjaan modul formulir template (F-02) |
| **DEP-02** | Kredensial akun cloud storage (AWS / GCS) & SMTP email | Hari ke-7 Proyek | Penundaan setup backend vault & notifikasi |
| **DEP-03** | Akses Domain DNS untuk konfigurasi alamat web sistem | Hari ke-14 Proyek | Penundaan provisioning SSL dan server staging |
| **DEP-04** | Feedback tertulis pada sesi review draf fungsional | Maksimal 3 hari kerja | Penundaan jadwal go-live sejumlah hari keterlambatan |

---

## 7. Asumsi & Batasan Teknis Awal
- **Platform**: Web application berbasis browser modern (Chrome, Safari, Edge, Firefox).
- **Infrastruktur**: Menggunakan managed database dan serverless/container environment untuk efisiensi biaya operasional.
- **Kapasitas Beban Awal**: Dirancang untuk menangani hingga [Contoh: 1.000 dokumen/bulan dan 50 concurrent users].

---

## 8. Validasi Awal Lingkup

Dokumen ini menjadi dasar penyusunan **Statement of Work (SOW), Nilai Kontrak, dan Jadwal Pembayaran Termin (Modul 03)**.

- Divalidasi oleh Solo Developer: **[Nama Anda]** (Tanggal: [YYYY-MM-DD])
- Divalidasi oleh PIC Klien: **[Nama PIC Klien]** (Tanggal: [YYYY-MM-DD])
