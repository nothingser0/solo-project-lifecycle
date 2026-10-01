# Panduan Arsitektur & Rekayasa Teknis Solo Developer

Dokumen ini adalah pedoman arsitektur perangkat lunak untuk solo developer dan konsultan teknis dalam merancang sistem yang andal, aman dari celah hukum/keamanan, dan minim beban pemeliharaan (*low-maintenance*).

---

## 1. Filosofi "The Boring Tech Ladder"

Sebagai solo developer, Anda adalah satu-satunya orang yang bertanggung jawab saat server mati pukul 03.00 pagi. Hindari teknologi eksotis yang belum teruji (*Resume-Driven Development*).

### Tangga Prioritas Pemilihan Teknologi:
1. **Rung 1: Monolith Modern Lebih Unggul dari Microservices**:
   - DILARANG memecah aplikasi menjadi microservices terdistribusi jika hanya dikerjakan oleh 1 orang, kecuali ada kewajiban arsitektur dari divisi Enterprise klien.
   - Gunakan **Modular Monolith**: Satu basis kode terstruktur rapi dengan pemisahan domain yang bersih di folder (`modules/auth`, `modules/documents`, `modules/billing`).
2. **Rung 2: PostgreSQL Sebagai "Swiss Army Knife"**:
   - Jangan menambah database NoSQL terpisah (misal MongoDB atau CouchDB) hanya untuk data semi-terstruktur.
   - Kolom `JSONB` di PostgreSQL sudah mendukung query indeks (`GIN Index`), validasi skema, dan performa tinggi tanpa perlu memelihara dua kluster database berbeda.
3. **Rung 3: PaaS & Managed Services Terkelola**:
   - Prioritaskan Managed Database (Supabase, Neon, AWS RDS) dan PaaS (Vercel, Cloudflare, Railway) agar Anda tidak perlu membuang waktu mengurus patch OS Linux, backup disk otomatis, atau konfigurasi firewall manual.

---

## 2. Praktik Terbaik Basis Data (Database Hygiene)

### 2.1 Integritas di Lapisan Basis Data (Database-Level Enforcement)
Jangan hanya mengandalkan validasi di kode aplikasi (JavaScript/Python). Aplikasi bisa memiliki bug, tetapi database harus tetap menjadi benteng terakhir:
- **Foreign Key Constraints**: Selalu gunakan `ON DELETE RESTRICT` untuk data transaksi. Jangan gunakan `CASCADE` pada data penting karena bisa menghapus data audit secara tidak sengaja.
- **Check Constraints**: Pasang batasan nilai di SQL (misal: `CHECK (compensation_amount >= 0)`).
- **Format Waktu Baku**: Selalu gunakan `TIMESTAMP WITH TIME ZONE` (UTC) untuk menghindari kerancuan perbedaan zona waktu (WIB/WITA/WIT).

### 2.2 Penanganan Transaksi & Concurrency
Untuk mencegah kondisi balapan (*race condition*) saat dua proses memodifikasi data yang sama:
- Gunakan transaksi atomik (`BEGIN ... COMMIT`).
- Gunakan penguncian baris eksplisit:
  ```sql
  -- Kunci baris agar tidak bisa dimodifikasi transaksi lain sampai commit
  SELECT * FROM documents WHERE id = '...' FOR UPDATE;
  ```

---

## 3. Checklist Keamanan Standar Industri (OWASP & UU PDP)

### 3.1 Kepatuhan UU Perlindungan Data Pribadi (UU PDP No. 27/2022)
1. **Prinsip Minimisasi Data**: Jangan meminta atau menyimpan data KTP/finansial jika tidak benar-benar dibutuhkan oleh alur bisnis.
2. **Enkripsi Saat Istirahat (Encryption-at-Rest)**:
   - Data sensitif di database dienkripsi menggunakan ekstensi `pgcrypto` atau di level aplikasi sebelum query `INSERT`.
   - File dokumen PDF disimpan di bucket cloud storage yang mengaktifkan enkripsi bawaan **AES-256**.
3. **Tautan Akses Sementara (Zero Public Buckets)**:
   - Dilarang membuat bucket storage berstatus `public-read`.
   - Seluruh akses unduh/preview dokumen wajib menggunakan **Presigned URL** bertanda tangan kriptografis dengan masa berlaku maksimal 15 menit.

### 3.2 Pertahanan OWASP Top 10
- **SQL Injection**: Wajib menggunakan *Parameterized Queries* atau ORM teruji (Prisma, Drizzle, SQLx, Gorm). Haram menyambung string query SQL secara mentah (`"SELECT * FROM users WHERE email = '" + input + "'"`).
- **Broken Authentication**:
  - Hashing password wajib menggunakan **Argon2id** atau **bcrypt** (cost factor minimal 12). Dilarang keras menggunakan MD5 atau SHA-256 biasa untuk password.
  - Simpan token otentikasi di cookie dengan flag: `HttpOnly; Secure; SameSite=Strict`.
- **Idempotency Protection**:
  - Untuk setiap endpoint mutasi finansial/penerbitan dokumen (`POST`), wajib mewajibkan header `X-Idempotency-Key` (UUIDv4) untuk mencegah transaksi ganda saat jaringan internet klien tidak stabil.

---

## 4. Pola Logging & Observabilitas Solo Dev

Jangan menggunakan `console.log()` polos di lingkungan produksi.
- Gunakan structured logger berformat JSON (misal: Pino atau Winston).
- Cantumkan konteks mutlak pada setiap log:
  ```json
  {
    "timestamp": "2026-09-24T10:15:30.120Z",
    "level": "error",
    "trace_id": "7b84f23b-0142-493e-8c5e-bf321bca9b11",
    "actor_id": "user_uuid_here",
    "endpoint": "POST /api/v1/documents",
    "error_code": "PDF_RENDER_TIMEOUT",
    "message": "Puppeteer timeout after 5000ms"
  }
  ```
- Hubungkan log ke layanan monitoring gratis/murah (misal: Sentry untuk error tracking, Axiom/BetterStack untuk agregasi log) agar Anda mendapatkan notifikasi instan via Telegram/Email saat terjadi error sistem.
