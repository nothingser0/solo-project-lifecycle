# ARCHITECTURE.md

> Cetak biru teknis arsitektur, struktur direktori, skema basis data, dan kontrak API untuk memandu implementasi kode oleh AI coding agents.

---

## 1. Topologi Sistem & Alur Data

```text
[ Browser Client (HTML/Tailwind dari Google Stitch) ]
                      │
                      ▼ (HTTPS / JSON API)
        [ Next.js App Router / API Handlers ]
                      │
         ┌────────────┼────────────┐
         ▼            ▼            ▼
   [ PostgreSQL ]  [ Redis ]   [ Cloudflare R2 / S3 ]
    Data Transaksi  Rate Limit  File PDF Terenkripsi
```

---

## 2. Struktur Direktori Standar (Directory Layout)

```text
src/
├── app/                      # Rute halaman Next.js App Router & API Route Handlers
│   ├── (auth)/login/         # Halaman login
│   ├── (dashboard)/          # Halaman dashboard terotentikasi
│   │   ├── documents/        # Manajemen dokumen
│   │   └── settings/         # Pengaturan akun
│   ├── api/v1/               # Endpoint REST API
│   │   ├── auth/             # Handler login/logout
│   │   ├── documents/        # Handler CRUD & render dokumen
│   │   └── sign/             # Handler verifikasi tanda tangan
│   └── sign/[token]/         # Halaman publik tanda tangan tamu
├── components/               # Komponen UI hasil adaptasi Google Stitch
│   ├── ui/                   # Komponen primitif (Button, Dialog, Input, Table)
│   └── modules/              # Komponen bisnis (DocumentForm, PDFPreview, SignCanvas)
├── lib/                      # Utilitas bersama
│   ├── db.ts                 # Instansiasi koneksi Prisma/PostgreSQL
│   ├── crypto.ts             # Enkripsi streaming AES-256-GCM & hashing
│   ├── storage.ts            # Klien Cloudflare R2 / S3 & presigned URL
│   └── env.ts                # Validasi variabel lingkungan dengan Zod
└── schemas/                  # Skema Zod validasi request & response API
```

---

## 3. Skema Basis Data Inti (Database Models)

Mengacu pada skema SQL DDL di `FSD.md`:
- **Tabel `users`**: Menyimpan akun pengguna, email unik, hash kata sandi Argon2id, dan peran (`super_admin`, `manager`, `staff`).
- **Tabel `documents`**: Menyimpan draf dokumen, data form JSONB, status (`draft`, `pending_sign`, `signed`, `archived`), path S3 file terenkripsi, dan hash SHA-256 dokumen.
- **Tabel `document_signatures`**: Menyimpan rekaman audit tanda tangan, nama penandatangan, IP address, user-agent, dan timestamp UTC.

---

## 4. Matriks Kontrak API Wajib

| Rute Endpoint | Metode | Header Khusus | Payload Wajib | Respon Sukses |
| :--- | :---: | :--- | :--- | :---: |
| `/api/v1/auth/login` | `POST` | - | `email`, `password` | `200 OK` + HttpOnly Cookie |
| `/api/v1/documents` | `POST` | `Authorization`, `X-Idempotency-Key` | `title`, `template_type`, `form_data` | `201 Created` (`document_id`) |
| `/api/v1/documents/:id` | `GET` | `Authorization` | - | `200 OK` + `preview_url` (15m) |
| `/api/v1/sign/:token` | `POST` | - | `signature_svg`, `token` | `200 OK` (Status `SIGNED`) |

---

## 5. Aturan Keamanan & Kriptografi Wajib
1. **Enkripsi File**: Dokumen PDF wajib dienkripsi sebelum upload ke S3/R2 menggunakan `crypto.createCipheriv('aes-256-gcm', key, iv)`.
2. **Presigned URL**: Tautan unduhan berkas wajib kedaluwarsa maksimal dalam 15 menit (900 detik).
3. **Pessimistic Lock**: Alur penandatanganan dokumen wajib menggunakan transaksi atomik dengan `SELECT ... FOR UPDATE` agar terhindar dari race condition.
