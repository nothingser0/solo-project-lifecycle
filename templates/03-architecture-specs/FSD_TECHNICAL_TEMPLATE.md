# Functional Specification Document (FSD)

> Dokumen spesifikasi teknis arsitektur yang mendefinisikan "BAGAIMANA" sistem dibangun: skema basis data, kontrak API, model keamanan, dan logika mesin keadaan (*state machine*).

---

## 1. Metadata Dokumen
- **Nama Sistem**: [Nama Aplikasi]
- **Klien**: [Perusahaan / Organisasi Klien]
- **Lead Software Architect**: [Nama Anda]
- **Referensi PRD**: PRD-[ID] v1.0 (Approved)
- **Referensi Desain**: DESIGN_SPEC-[ID] v1.0 (Frozen)
- **Versi Dokumen**: 1.0.0
- **Status Dokumen**: [Approved for Build]
- **Tanggal Persetujuan**: [YYYY-MM-DD]

---

## 2. Arsitektur Komponen & Keputusan Tech Stack

```text
[ Browser / Mobile Client ]
            │
            ▼ (HTTPS / TLS 1.3 - JSON API)
    [ API Gateway / Reverse Proxy (Caddy / Nginx / Cloudflare) ]
            │
            ▼
    [ Application Backend (Node.js / Next.js / Go) ]
            │
            ├──► [ Database: PostgreSQL (Managed / Supabase) ]
            ├──► [ Cache & Rate Limit: Redis (Upstash) ]
            ├──► [ Document Vault: Cloudflare R2 / AWS S3 (AES-256) ]
            └──► [ Third-Party APIs: SMTP (Resend) / Payment (Midtrans) ]
```

### Keputusan Teknologi (Tech Stack Matrix)
- **Frontend / Client UI**: Next.js (App Router, React 19, TypeScript, Tailwind CSS, Shadcn UI).
- **Backend Runtime**: Node.js v20+ LTS / Next.js Server Actions / Route Handlers.
- **Database Utama**: PostgreSQL 16 (dengan ekstensi `pgcrypto` dan `uuid-ossp`).
- **ORM / Query Builder**: Prisma ORM / Drizzle ORM (dengan migrasi skema terversi).
- **In-Memory Cache & Lock**: Redis v7 (Rate limiting dan antrean background job).
- **Penyimpanan Berkas (Blob Storage)**: Cloudflare R2 (S3-compatible, zero egress fee).

---

## 3. Skema Basis Data Relasional (SQL DDL Baku)

```sql
-- Ekstensi Kriptografi dan UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Tabel Pengguna (Users)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    role VARCHAR(30) NOT NULL DEFAULT 'staff' CHECK (role IN ('super_admin', 'manager', 'staff')),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);

-- 2. Tabel Dokumen (Documents)
CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    creator_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    title VARCHAR(255) NOT NULL,
    template_type VARCHAR(50) NOT NULL CHECK (template_type IN ('pkwt', 'nda', 'freelance_contract', 'invoice')),
    form_data JSONB NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'pending_sign', 'signed', 'archived')),
    file_vault_key VARCHAR(500), -- Path S3 file PDF terenkripsi
    document_hash_sha256 VARCHAR(64), -- Integritas hash isi dokumen
    idempotency_key VARCHAR(100) UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_documents_creator_status ON documents(creator_id, status);
CREATE INDEX idx_documents_created_at ON documents(created_at);

-- 3. Tabel Jejak Audit Tanda Tangan (Signatures & Audit Trail)
CREATE TABLE document_signatures (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    document_id UUID NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
    signer_name VARCHAR(150) NOT NULL,
    signer_email VARCHAR(255) NOT NULL,
    token_hash VARCHAR(64) UNIQUE NOT NULL,
    signature_svg_path VARCHAR(500),
    signer_ip_address VARCHAR(45) NOT NULL,
    signer_user_agent TEXT NOT NULL,
    signed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_signatures_document ON document_signatures(document_id);
```

---

## 4. Kontrak API & Matriks Endpoint

### 4.1 Endpoint: `POST /api/v1/documents`
- **Fungsi**: Menerbitkan draf dokumen baru dari input form.
- **Otentikasi**: Wajib (`Bearer <JWT_TOKEN>`).
- **Headers**:
  ```http
  Authorization: Bearer eyJhbGciOi...
  Content-Type: application/json
  X-Idempotency-Key: 9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d
  ```

#### Payload Request JSON
```json
{
  "title": "Perjanjian Kerja Lepas - Budi Santoso",
  "template_type": "freelance_contract",
  "form_data": {
    "employer_name": "PT Sinar Maju",
    "contractor_name": "Budi Santoso",
    "compensation_amount": 15000000,
    "scope_of_work": "Pengembangan antarmuka website",
    "start_date": "2026-10-01",
    "end_date": "2026-12-31"
  }
}
```

#### Respon Sukses (`201 Created`)
```json
{
  "status": "success",
  "data": {
    "document_id": "8c4e6123-5e92-4f31-893c-623ab1e4811a",
    "title": "Perjanjian Kerja Lepas - Budi Santoso",
    "status": "draft",
    "preview_url": "https://vault.domain.com/preview/8c4e6123?token=exp15m...",
    "created_at": "2026-09-24T10:00:00Z"
  }
}
```

#### Matriks Respon Galat (Error Matrix)
| HTTP Code | Error Code | Kondisi Penyebab | Respon JSON |
| :---: | :--- | :--- | :--- |
| `400` | `VALIDATION_ERROR` | Format JSON form_data salah atau ada field kosong | `{"status": "error", "code": "VALIDATION_ERROR", "details": [...]}` |
| `401` | `UNAUTHORIZED` | Token JWT tidak ada atau telah kedaluwarsa | `{"status": "error", "code": "UNAUTHORIZED", "message": "Sesi Anda telah berakhir"}` |
| `409` | `IDEMPOTENCY_CONFLICT`| Request dengan idempotency key sama sedang diproses | `{"status": "error", "code": "IDEMPOTENCY_CONFLICT", "message": "Proses duplikat"}` |
| `500` | `PDF_RENDER_FAILED` | Pustaka generator PDF gagal merender dokumen | `{"status": "error", "code": "SERVER_ERROR", "message": "Gagal merender file PDF"}` |

---

## 5. Arsitektur Keamanan & Kriptografi (Security Blueprint)

1. **Enkripsi File Dokumen (Vault Encryption-at-Rest)**:
   - File PDF dokumen dienkripsi menggunakan algoritma **AES-256-GCM** sebelum dialirkan (*streamed*) ke storage S3/R2.
   - Kunci enkripsi enkapsulasi (*Data Encryption Key / DEK*) disimpan terenkripsi menggunakan kunci utama (*Master Key*) yang disimpan pada variabel lingkungan server yang terisolasi.
2. **Keamanan Tautan Unduhan (Presigned URLs)**:
   - File di storage tidak pernah dibuka untuk akses publik (`public-read`).
   - Akses unduhan hanya diterbitkan melalui *Presigned URL* yang ditandatangani secara kriptografis dengan masa berlaku maksimal **15 menit**.
3. **Penyimpanan Kredensial Kata Sandi**:
   - Kata sandi wajib di-hash menggunakan **Argon2id** dengan parameter: `memoryCost: 65536` (64 MB), `timeCost: 3`, `parallelism: 4`.
4. **Pemberian Tanda Tangan Kriptografis (Integrity Hash)**:
   - Setiap dokumen yang selesai ditandatangani dihitung nilai hash-nya menggunakan **SHA-256**.
   - Nilai hash disimpan di tabel `documents.document_hash_sha256` dan dicantumkan pada footer PDF sebagai bukti keaslian dokumen (*tamper-evident seal*).

---

## 6. Mesin Keadaan Dokumen (Document State Machine)

```text
               ┌────────────────────────────────────────────────────────┐
               ▼                                                        │
         [ 1. DRAFT ] ──(Kirim Tautan Tanda Tangan)──► [ 2. PENDING_SIGN ]
               │                                                │
               │ (Dihapus Pembuat)                              │ (Kedaluwarsa 7 Hari)
               ▼                                                ▼
         [ ARCHIVED ]                                     [ EXPIRED ]
                                                                │
                                   (Seluruh Pihak Tanda Tangan) │
                                                                ▼
                                                        [ 3. SIGNED (LOCKED) ]
```

### Aturan Transisi Keadaan (State Invariants):
1. Dokumen yang telah berstatus `SIGNED` **DILARANG KERAS** mengalami perubahan form data atau file PDF.
2. Penandatanganan dilakukan dalam satu transaksi atomik database (`BEGIN ... COMMIT`) menggunakan penguncian baris (`SELECT ... FOR UPDATE`) untuk mencegah race condition saat dua penandatangan membubuhkan tanda tangan di detik yang sama.

---

## 7. Lembar Pengesahan Spesifikasi Teknis (Technical Sign-Off)

Dokumen ini merupakan spesifikasi arsitektur final. Seluruh implementasi kode pada **Modul 06: Development** wajib mengikuti ketentuan skema, rute API, dan arsitektur keamanan di atas.

| Disetujui oleh Single PIC Klien | Divalidasi oleh Lead Software Architect |
| :--- | :--- |
| **Nama**: _________________________ | **Nama**: _________________________ |
| **Jabatan**: ______________________ | **Jabatan**: Independent Lead Engineer |
| **Tanggal**: ______________________ | **Tanggal**: ______________________ |
| **Tanda Tangan**: | **Tanda Tangan**: |
