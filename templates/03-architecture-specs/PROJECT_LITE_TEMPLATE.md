# PROJECT_LITE.md (Fast-Track Unified Specification)

> Dokumen spesifikasi ramping terpadu untuk proyek **Skala Kecil (MVP / Freelance 1–4 Minggu)**.
> Menggabungkan Modul 01 (Ide), Modul 02 (Scope), Modul 03 (Komersial), dan Modul 05 (Teknis) menjadi satu berkas acuan tunggal.
> **ATURAN MUTLAK**: Untuk seluruh proyek Web dan Mobile, **Modul 04 (Google Stitch UI/UX) TETAP WAJIB DIJALANKAN** agar tampilan tidak menjadi "AI Slop" dan klien memiliki prototipe interaktif nyata. Modul 04 hanya boleh dilewati jika proyek bersifat murni backend/CLI/otomasi tanpa antarmuka.

---

## Fast-Track Execution Checklist (MVP 1-4 Minggu)

**Urutan Eksekusi Wajib:**

- [ ] **Step 1**: Fill `PROJECT_LITE.md` (Idea + Scope + Komersial + Schema DB) — 1 file unified
- [ ] **Step 2**: **MANDATORY — Execute Modul 04 Google Stitch (TIDAK BOLEH DI-SKIP untuk Web/Mobile/Desktop GUI!)**
  - [ ] `DESIGN.md` generated dan uploaded ke Stitch
  - [ ] All screens generated (bahkan MVP 3-screen tetap wajib di-generate semua)
  - [ ] Design Freeze self-approved (atau klien approval jika ada klien)
- [ ] **Step 3**: Jump langsung ke Modul 06 Development (skip PRD/FSD formal karena sudah ada di PROJECT_LITE.md)

**Anti-Lupa Protocol:**
> Jika agen AI mencoba skip Modul 04 dengan alasan "fast-track" atau "MVP kecil", **WAJIB DITOLAK**. Fast-track hanya merge dokumentasi, bukan skip UI/UX phase.

---

## 1. Metadata Proyek & Elevator Pitch
- **Nama Proyek**: [Nama Aplikasi / Sistem]
- **Klien**: [Nama Klien / Inisiator]
- **Single PIC Klien**: [Nama PIC Klien & Kontak]
- **Solo Developer**: [Nama Anda]
- **Target Rilis**: [YYYY-MM-DD] (Maksimal 2–4 Minggu)
- **Elevator Pitch**: *Untuk [Target Pengguna] yang mengalami [Masalah], sistem ini menyediakan [Solusi Inti] yang memproses data melalui [Core Loop 3 Langkah].*

---

## 2. Batasan Lingkup Ramping (In-Scope vs Out-of-Scope)

### Fitur yang Dibuat (In-Scope MVP - Maksimal 3–5 Fitur Inti)
1. **[Fitur 1]**: [Deskripsi fungsionalitas inti]
2. **[Fitur 2]**: [Deskripsi fungsionalitas inti]
3. **[Fitur 3]**: [Penyimpanan dokumen terenkripsi / integrasi payment dasar]

### Fitur yang Resmi DIBUANG / Ditunda (Out-of-Scope)
1. Tidak ada dashboard analitik grafik kompleks (cukup ekspor CSV jika butuh data).
2. Tidak ada integrasi multi-bahasa atau multi-perusahaan (single-tenant).
3. Segala permintaan fitur baru di luar daftar di atas wajib melalui penawaran Fase 2 atau Change Request berbayar.

---

## 3. Komitmen Komersial & Pembayaran Berjenjang (Payment Gate)

- **Total Nilai Pekerjaan**: Rp [Nominal Angka]
- **Skema Pembayaran (2 Tahap)**:
  - **Termin 1 (DP 50%)**: Dibayarkan di muka sebagai prasyarat mulai koding.
  - **Termin 2 (Pelunasan 50%)**: Dibayarkan setelah UAT lolos dan sistem live, sebelum penyerahan kredensial root/repo.
- **SLA Respon Klien**: Klien wajib memberikan feedback pengujian maksimal **3 hari kerja**.

---

## 4. Rujukan Prototipe Antarmuka (Google Stitch UI/UX Mandat)
*Bagian ini wajib diisi untuk aplikasi Web dan Mobile:*

- **Stitch Project ID**: `projects/[PROJECT_ID]`
- **Design System Asset ID**: `assets/[ASSET_ID]` (menggunakan guardrail `DESIGN.md` anti-slop)
- **Tautan Live Interactive Prototype**: `[https://staging-preview-url]`
- **Status Desain**: **FROZEN (DIBEKUKAN)** — Tata letak visual dan alur navigasi telah disetujui klien dan tidak boleh dirombak saat koding.

---

## 5. Cetak Biru Teknis Ramping (Lean Technical Blueprint)

- **Tech Stack Terpilih**: [Contoh: Next.js + PostgreSQL / Flutter + Supabase / FastAPI + SQLite]
- **Skema Basis Data (Tabel Inti)**:
```sql
-- Tabel Pengguna & Sesi
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(30) NOT NULL DEFAULT 'staff',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabel Transaksi / Dokumen Inti
CREATE TABLE core_entities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    title VARCHAR(255) NOT NULL,
    payload JSONB NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'draft',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

- **Rute API Inti**:
  - `POST /api/v1/auth/login` (Login & Set HttpOnly Cookie)
  - `GET /api/v1/entities` (Ambil daftar data terotentikasi)
  - `POST /api/v1/entities` (Buat data baru tervalidasi Zod)

---

## 6. Persetujuan Ringkas Para Pihak

Dengan menyetujui dokumen ini (melalui tanda tangan atau konfirmasi email tertulis), pekerjaan resmi dimulai setelah pembayaran Down Payment (DP 50%) diterima oleh Developer.

- Disetujui oleh Single PIC Klien: **[Nama PIC Klien]** (Tanggal: [YYYY-MM-DD])
- Divalidasi oleh Solo Developer: **[Nama Anda]** (Tanggal: [YYYY-MM-DD])
