# Product Requirement Document (PRD)

> Dokumen spesifikasi kebutuhan produk resmi yang mendefinisikan seluruh fungsionalitas sistem, alur pengguna, batasan non-fungsional, dan kriteria keberterimaan rilis.

---

## 1. Metadata Dokumen
- **Nama Produk / Sistem**: [Nama Aplikasi]
- **Klien**: [Perusahaan / Organisasi Klien]
- **Lead Architect / Solo Engineer**: [Nama Anda]
- **Referensi Desain**: DESIGN_SPEC-[ID] v1.0 (Frozen)
- **Referensi Lingkup**: SCOPE_STATEMENT-[ID] v1.0
- **Versi Dokumen**: 1.0.0
- **Status Dokumen**: [Draft / In Review / Approved for Build]
- **Tanggal Persetujuan**: [YYYY-MM-DD]

---

## 2. Ringkasan Eksekutif & Objektif Bisnis
- **Deskripsi Produk**: [Jelaskan dalam 2–3 kalimat fungsi utama sistem]
- **Masalah Utama yang Diselesaikan**: [Uraian pain points pengguna]
- **Target Pengguna**: [Daftar persona pengguna utama]
- **Key Performance Indicators (KPI)**:
  - [KPI 1: Waktu pembuatan dan penandatanganan dokumen $< 5\text{ menit}$]
  - [KPI 2: Tingkat keberhasilan transaksi pembubuhan e-sign $\ge 99.5\%$]

---

## 3. Matriks Peran Pengguna & Hak Akses (Role-Based Access Control)

| Kode Peran | Nama Peran | Hak Akses Modul Dokumen | Hak Akses Modul Pengguna | Hak Akses Audit Log |
| :---: | :--- | :--- | :--- | :--- |
| **ROL-01** | Super Admin | Lihat Semua, Hapus, Arsip | Buat User, Edit Role, Hapus | Akses Penuh Export Log |
| **ROL-02** | Manager | Buat, Setujui, Kirim Tanda Tangan | Lihat Daftar Anggota Tim | Lihat Log Tim Sendiri |
| **ROL-03** | Staf Operasional | Buat Draf, Isi Variabel Form | Hanya Profil Sendiri | Tidak Ada Akses |
| **ROL-04** | Signer (Tamu) | Membaca & Menandatangani via Token | Tidak Ada Akses | Tidak Ada Akses |

---

## 4. Spesifikasi Kebutuhan Fungsional (Functional Requirements)

### Modul 1: Otentikasi & Manajemen Sesi
- **ID Kebutuhan**: `REQ-AUTH-01`
- **User Story**: Sebagai pengguna sistem, saya ingin login menggunakan email dan kata sandi atau OTP agar dapat mengakses data kerja saya secara aman.
- **Kriteria Keberterimaan (Acceptance Criteria)**:
  - [ ] Kata sandi minimal 8 karakter, wajib kombinasi huruf dan angka.
  - [ ] Password disimpan menggunakan hashing `Argon2id`.
  - [ ] Pembatasan laju salah password maksimal 5 kali dalam 15 menit.
  - [ ] Sesi disimpan pada cookie `HttpOnly`, `Secure`, dan `SameSite=Strict`.

### Modul 2: Pembuatan Dokumen & Generator PDF
- **ID Kebutuhan**: `REQ-DOC-01`
- **User Story**: Sebagai Staf/Manager, saya ingin memilih template legal dan mengisi form dinamis agar sistem menghasilkan draf PDF resmi secara otomatis.
- **Kriteria Keberterimaan (Acceptance Criteria)**:
  - [ ] Seluruh field wajib diisi sebelum dokumen dapat di-generate.
  - [ ] Render PDF ukuran baku A4 dengan margin standar hukum Indonesia (2.5 cm).
  - [ ] Proses render PDF memakan waktu $< 3\text{ detik}$.
  - [ ] File PDF otomatis terenkripsi dan tersimpan di Document Vault aman.

### Modul 3: Tanda Tangan Digital & Jejak Audit
- **ID Kebutuhan**: `REQ-SIGN-01`
- **User Story**: Sebagai penandatangan, saya ingin menandatangani dokumen melalui tautan aman agar dokumen sah secara perdata.
- **Kriteria Keberterimaan (Acceptance Criteria)**:
  - [ ] Tautan penandatanganan menggunakan secure token sekali pakai (*one-time token*) kedaluwarsa 7 hari.
  - [ ] Sistem merekam metadata audit trail: Waktu tanda tangan (UTC), Alamat IP, User-Agent browser, dan Hash dokumen (SHA-256).
  - [ ] Dokumen yang sudah ditandatangani berstatus `LOCKED` (tidak dapat diedit lagi).

---

## 5. Kebutuhan Non-Fungsional (Non-Functional Requirements / NFR)

### 5.1 Performa & Skalabilitas (Performance)
- Waktu respon rata-rata endpoint API $\le 200\text{ ms}$ pada beban $100\text{ concurrent requests}$.
- Kapasitas throughput sistem mampu menangani minimal $50\text{ transaksi baru per menit}$.

### 5.2 Ketersediaan & Keandalan (Availability)
- Target Service Level Agreement (SLA): $99.9\%$ uptime bulanan (maksimal downtime $< 43\text{ menit/bulan}$).
- Database dilengkapi mekanisme automated daily backup terenkripsi dengan retensi penyimpanan 30 hari.

### 5.3 Keamanan & Kepatuhan UU PDP (Security & Compliance)
- Seluruh komunikasi data wajib menggunakan protokol **TLS 1.3** (HTTPS).
- File dokumen di dalam storage wajib dienkripsi saat istirahat (*encryption-at-rest*) menggunakan **AES-256-GCM**.
- Data pribadi pengguna (NIK, nomor telepon, alamat) wajib dilindungi hak privasinya sesuai UU PDP No. 27/2022.

---

## 6. Ketergantungan Layanan Pihak Ketiga

| Nama Layanan | Kategori Integrasi | Kredensial / Konfigurasi yang Dibutuhkan |
| :--- | :--- | :--- |
| **Resend / SendGrid** | Transaksional Email (OTP & Link Sign) | SMTP Key & Verified Sender Domain DNS |
| **Cloudflare R2 / AWS S3** | Penyimpanan Dokumen Terenkripsi | S3 Access Key, Secret Key, Bucket Name |
| **Midtrans / Xendit** | Payment Gateway (Jika Berbayar) | Server Key, Client Key, Webhook Secret |

---

## 7. Lembar Persetujuan Dokumen Kebutuhan Produk

Dokumen ini menjadi landasan resmi bagi penyusunan Functional Specification Document (FSD) dan pengujian akhir sistem (UAT).

- Disetujui oleh Single PIC Klien: **[Nama PIC Klien]**
- Tanggal Persetujuan: **[YYYY-MM-DD]**
- Tanda Tangan: _________________________
