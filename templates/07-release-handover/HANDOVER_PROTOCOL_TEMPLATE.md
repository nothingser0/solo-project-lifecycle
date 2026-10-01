# Protokol Serah Terima Teknis & Kredensial (Technical Handover Protocol)

> Berita acara serah terima aset digital, pemindahan kepemilikan repositori kode sumber (*Git Repository*), dan pengalihan akun infrastruktur produksi kepada Pihak Klien.

---

## 1. Metadata Serah Terima
- **Nama Sistem**: [Nama Aplikasi]
- **Pihak Klien**: [Nama Perusahaan Klien]
- **Penerima Kredensial (PIC Klien)**: [Nama PIC Klien & Email Resmi]
- **Penyerah Aset (Lead Developer)**: [Nama Anda]
- **Tanggal Eksekusi**: [YYYY-MM-DD]

---

## 2. Inventaris Aset Digital yang Dialihkan

| Kategori Aset | Nama Layanan / Akun | Identifier / URL | Metode Pengalihan | Status Pengalihan |
| :--- | :--- | :--- | :--- | :---: |
| **Repositori Kode** | GitHub / GitLab | `github.com/[client-org]/[repo-name]` | Transfer Ownership Organisasi | [x] SELESAI |
| **Server Hosting** | Cloudflare / Vercel / VPS | `app.klien.com` | Undangan Pemilik Akun Utama (Owner) | [x] SELESAI |
| **Basis Data** | Managed PostgreSQL | Host: `prod-db.klien.com` | Penyerahan Master Kredensial Terenkripsi | [x] SELESAI |
| **Storage Vault** | Cloudflare R2 / AWS S3 | Bucket: `legal-vault-prod` | Pemindahan Hak Akses IAM Bucket | [x] SELESAI |
| **Payment Gateway** | Midtrans / Xendit | Merchant ID: `[MID_12345]` | Mode LIVE Dialihkan ke Rekening Klien | [x] SELESAI |
| **Email SMTP** | Resend / SendGrid | Domain: `domainklien.com` | Pengalihan Pemilik Dashboard Email | [x] SELESAI |

---

## 3. Protokol Keamanan Pengiriman Kredensial (Zero Plaintext)

1. Seluruh kata sandi master, API secret keys, dan connection string database **TIDAK DIKIRIMKAN MELALUI CHAT ATAU EMAIL TEKS BIASA**.
2. Kredensial dikirimkan menggunakan tautan enkripsi sekali pakai (*End-to-End Encrypted One-Time Link*) melalui layanan **[Bitwarden Send / 1Password / Yopass]**.
3. Pihak Klien telah membuka tautan tersebut dan mengonfirmasi bahwa seluruh kata sandi berhasil disalin dan diganti (*password rotated*) oleh tim internal Klien.

---

## 4. Pelepasan Tanggung Jawab Akses Developer (Access Revocation)

Dengan selesainya proses serah terima akun root di atas:
- Developer telah mencabut seluruh token akses pribadi (*Personal Access Tokens*) dan kunci SSH milik developer dari repositori dan server produksi.
- Klien bertanggung jawab penuh atas kerahasiaan kata sandi dan manajemen hak akses karyawan internal Klien sejak tanggal penandatanganan ini.

| Diterima oleh Single PIC Klien | Diserahkan oleh Solo Developer |
| :--- | :--- |
| **Nama**: _________________________ | **Nama**: _________________________ |
| **Jabatan**: ______________________ | **Jabatan**: Independent Lead Software Engineer |
| **Tanggal**: ______________________ | **Tanggal**: ______________________ |
| **Tanda Tangan**: | **Tanda Tangan**: |
