# Laporan Audit Keamanan Perangkat Lunak (Security Audit Report)

> Dokumen hasil audit keamanan teknis, sanitasi dependensi, perlindungan celah OWASP Top 10, dan verifikasi kepatuhan regulasi data (UU PDP No. 27/2022).

---

## 1. Metadata Audit
- **Nama Sistem**: [Nama Aplikasi]
- **Target URL Lingkungan**: `https://staging.domainklien.com`
- **Auditor Teknis / Solo Security Engineer**: [Nama Anda]
- **Tanggal Audit**: [YYYY-MM-DD]
- **Tingkat Kepatuhan**: Standard Web Application / Regulated Data

---

## 2. Hasil Audit Dependensi Pihak Ketiga (Supply-Chain Security)

Perintah yang Dijalankan: `pnpm audit --audit-level=high`

| Tingkat Kerentanan | Jumlah Ditemukan | Status Penanganan |
| :--- | :---: | :--- |
| **Critical** | 0 | Bebas Celah Kritis |
| **High** | 0 | Bebas Celah Tinggi |
| **Moderate** | [ ] | [Telah ditambal / Diawasi] |
| **Low** | [ ] | Diabaikan jika hanya dependensi build dev |

---

## 3. Checklist Verifikasi OWASP Top 10

| Kategori Kerentanan | Mekanisme Pertahanan yang Diuji | Status Uji | Bukti Teknis |
| :--- | :--- | :---: | :--- |
| **A01: Broken Access Control** | Verifikasi IDOR: Pengguna A dilarang mengakses dokumen milik Pengguna B | [x] PASS | Query terisolasi dengan filter `WHERE creator_id = user.id` |
| **A02: Cryptographic Failures** | File vault terenkripsi AES-256; password ter-hash Argon2id; TLS 1.3 aktif | [x] PASS | Verifikasi inspeksi biner file S3 dan kolom hash database |
| **A03: Injection (SQLi/Command)** | Kueri database wajib parameterized (Prisma/Drizzle); validasi input Zod | [x] PASS | Uji injeksi `' OR '1'='1` ditolak sebagai input string biasa |
| **A04: Insecure Design** | Pembatasan laju (*Rate Limiting*) pada login dan endpoint dokumen | [x] PASS | Uji tembak 10 request/detik menghasilkan `429 Too Many Requests` |
| **A05: Security Misconfiguration** | Mode debug dinonaktifkan di staging/produksi; pesan error tidak bocor stack trace | [x] PASS | Respon error server mengembalikan pesan generik terstruktur |
| **A06: Vulnerable Components** | Audit dependensi bersih dari CVE publik | [x] PASS | Lulus `pnpm audit` |
| **A07: Identification & Auth** | Proteksi brute force; sesi disimpan pada cookie `HttpOnly, Secure, SameSite=Strict` | [x] PASS | Sesi tidak dapat dicuri via JavaScript `document.cookie` |
| **A08: Software & Data Integrity** | Integritas dokumen tervalidasi menggunakan hash kriptografis SHA-256 | [x] PASS | Nilai SHA-256 tersimpan di database dan footer PDF |
| **A09: Logging & Monitoring** | Pencatatan audit trail untuk setiap aksi pembuatan & penandatanganan dokumen | [x] PASS | Log tersimpan dengan timestamp UTC, IP address, dan User-Agent |
| **A10: Server-Side Request Forgery** | Endpoint webhook hanya memanggil URL yang terdaftar di whitelist resmi | [x] PASS | Panggilan ke alamat IP lokal internal (127.0.0.1) diblokir |

---

## 4. Verifikasi Header Keamanan HTTP (HTTP Security Headers)

| Header Keamanan | Nilai Konfigurasi Wajib | Status |
| :--- | :--- | :---: |
| `Strict-Transport-Security` | `max-age=31536000; includeSubDomains; preload` | Terpasang |
| `X-Content-Type-Options` | `nosniff` | Terpasang |
| `X-Frame-Options` | `DENY` (Mencegah serangan Clickjacking) | Terpasang |
| `Referrer-Policy` | `strict-origin-when-cross-origin` | Terpasang |
| `Content-Security-Policy` | `default-src 'self'; script-src 'self' ...` | Terpasang |

---

## 5. Kesimpulan & Status Kelulusan Keamanan

- [x] **MEMENUHI STANDAR KEAMANAN (SECURITY PASS)**: Seluruh parameter pengujian kritis di atas terpenuhi. Sistem aman dari celah eksploitasi umum dan memenuhi kepatuhan dasar UU PDP No. 27/2022.
- [ ] **DITOLAK (FAIL)**: Ditemukan celah keamanan kategori Critical/High yang wajib diperbaiki sebelum go-live.
