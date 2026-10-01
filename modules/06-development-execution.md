# Modul 06: Development (Backend, Frontend, Integrasi API, & 3 Pilar Rekayasa)

> ⚠️ **MANDATORY: Load references BEFORE executing this module**:
> - `references/solo/SOLO_DEVELOPMENT_PATTERNS.md` (Zod validation, AES-256-GCM encryption, Pessimistic locking, Presigned URLs, Self-test scripts)
> - `references/solo/SOLO_ENGINEERING_STANDARDS.md` (Git branching, OWASP/UU PDP audit, N+1 query prevention, Asset optimization, Connection pooling)
> - `references/improvements/MODUL_06_IMPROVEMENTS.md` (Timeline estimation 29-478 jam, AI agent delegation strategy, smoke test 3-tier, env var management, VERIFY_LOCAL template, Modul 04 dependency workflow)
> - `references/technical/AI_DEVELOPMENT_TOOLS_COMPARISON.md` (AI coding tool selection, Cursor vs Claude Code vs Windsurf benchmark)
> - `references/playbooks/ai-assisted-development.md` (Prompt engineering patterns, multi-file orchestration, pre-merge AI review protocol)
> - `references/playbooks/software-design-patterns.md` (Clean code principles, SOLID, design patterns, and anti-pattern detection for AI-generated code)
>
> Load via: `skill_view(name='solo-project-lifecycle', file_path='references/solo/SOLO_DEVELOPMENT_PATTERNS.md')`

Modul ini adalah tahap keenam dalam siklus hidup proyek perangkat lunak untuk solo developer. Tujuannya adalah mengeksekusi penulisan kode nyata (*coding*) secara terarah menggunakan bantuan **AI Coding Agents (OpenChamber + OpenCode + OhMyOpenCode / Cursor / Claude Code)** melalui penyediaan **Agent Harness (berkas pemandu AI)**, mengintegrasikan antarmuka dari **Google Stitch**, mengelola percabangan **Git**, serta menegakkan 3 pilar rekayasa non-negosiasi: **Keamanan (Security)**, **Performa (Performance)**, dan **Efisiensi Sumber Daya (Resource Efficiency)**.

---

## 1. Siklus Eksekusi Modul 06 (The Agentic Vibe Coding Loop)

```text
[ INPUT: FSD.md, PRD.md, & Komponen UI Google Stitch dari Modul 04-05 ]
                                    │
                                    ▼
[ LANGKAH 1: Inisiasi Repositori & Pemasangan 7 Berkas Harness AI ]
  • Scaffold Clean Project (pnpm create next-app)
  • Pasang: AGENTS.md, CONTEXT.md, ARCHITECTURE.md, DESIGN.md, CONVENTIONS.md, .env.example, TODO.md
  • Git Init & Strategi Percabangan (main ──► staging ──► feat/*)
                                    │
                                    ▼
[ LANGKAH 2: Penerapan Komponen UI Google Stitch via MCP ]
  • OpenCode Panggil stitch_get_screen ──► Ekstrak ke src/components/
  • Pasang Rute Halaman (Dashboard, Forms, Detail, Sign Page)
  • Pastikan UI Visual 100% Identik dengan Prototipe Terkunci
                                    │
                                    ▼
[ LANGKAH 3: Pembangunan Basis Data & Migrasi (Dituntun AI) ]
  • AI Membaca ARCHITECTURE.md ──► Skema Prisma/Drizzle & Migrasi DDL
  • Pasang Database Pooling & Indexing pada Kolom Foreign Key
  • Eksekusi Migrasi Lokal & Penyuntikan Seed Data Riil
                                    │
                                    ▼
[ LANGKAH 4: Backend API, Layanan Vault, & 3 Pilar Rekayasa ]
  • AI Membaca TODO.md Sekuensial ──► Buat Handler API Ber-Zod
  • Pilar Security: Enkripsi Stream AES-256-GCM, HttpOnly Cookies, Parameterized Queries
  • Pilar Performance: N+1 Prevention, In-Memory Caching (Redis), Query Indexing
  • Pilar Resource: Zero Memory Leak, Stream Processing, Connection Pool Capping
  • Sambungkan Tombol UI Stitch ke Endpoint API (5 State Wajib Aktif)
                                    │
                                    ▼
[ LANGKAH 5: Uji Asersi Mandiri, Git Commit, & Pencapaian Termin ]
  • Jalankan Skrip Asersi `npm run test:smoke` (100% PASS)
  • Audit Kemanan Dependensi (`pnpm audit`) & TypeScript Check (`tsc --noEmit`)
  • Merge Fitur ke Branch `staging` & Tagih Milestone Termin 2 (Alpha)
                                    │
                                    ▼
[ OUTPUT: Repositori Kode Siap Pakai & RUNBOOK_LOCAL.md ] ──► Siap Masuk ke Modul 07: QA & SIT
```

---

## 2. Tujuh Berkas Kendali AI di Root Repo (The 7 Root Harness Files)

⚠️ **CRITICAL PRE-FLIGHT WARNING: Next.js AGENTS.md Conflict**

Next.js `create-next-app` auto-generates conflicting `AGENTS.md` (9 lines boilerplate).

**WAJIB overwrite IMMEDIATELY** after scaffold:
```bash
cp templates/04-dev-execution/AGENTS_TEMPLATE.md AGENTS.md
```

**NEVER skip this step!** Next.js boilerplate lacks 6 Engineering Pillars enforcement.

**(Repeated at scaffold protocol section for visibility)**

---

*Panduan evaluasi & pemilihan AI coding tool: `references/technical/AI_DEVELOPMENT_TOOLS_COMPARISON.md`*

Sebelum memicu agen AI untuk menulis kode, letakkan 7 berkas kendali ini di root folder proyek:

| No | Nama Berkas | Sumber Rujukan | Fungsi untuk AI Coding Agent |
| :---: | :--- | :--- | :--- |
| **1** | **`AGENTS.md`** | `templates/04-dev-execution/AGENTS_TEMPLATE.md` | Aturan main mutlak: larangan tipe `any`, perintah build/test, dan format commit. |
| **2** | **`CONTEXT.md`** | `templates/04-dev-execution/CONTEXT_TEMPLATE.md` | Konteks bisnis, peran user (RBAC), dan daftar batas tegas *Out-of-Scope* agar AI tidak halusinasi. |
| **3** | **`ARCHITECTURE.md`** | `templates/04-dev-execution/ARCHITECTURE_TEMPLATE.md` | Rangkuman FSD: struktur folder, skema tabel, dan kontrak rute API JSON. |
| **4** | **`DESIGN.md`** | `templates/02-design/DESIGN_MD_TEMPLATE.md` | Token visual dari Modul 04: palet Zinc, 1 aksen brand, font Inter, border 1px flat. |
| **5** | **`CONVENTIONS.md`** | `templates/04-dev-execution/CONVENTIONS_TEMPLATE.md` | Aturan gaya koding: penamaan `kebab-case`, Server Components default, larangan barrel files. |
| **6** | **`.env.example`** | `templates/04-dev-execution/ENV_EXAMPLE_TEMPLATE.md` | Kamus variabel lingkungan baku agar AI tidak mengarang nama key database/rahasia. |
| **7** | **`TODO.md`** | `templates/04-dev-execution/TODO_TEMPLATE.md` | Daftar tugas atomik sekuensial yang dicentang `[x]` satu per satu oleh AI. |

---

## 3. Strategi Percabangan Git Solo Developer (Git Branching & Clean Production)

Percabangan disesuaikan dengan skala proyek:

| Scale | Branch Structure | Rationale |
|-------|------------------|-----------|
| **Kecil** | `main` only (direct commits or single dev branch) | Overhead rendah, solo dev MVP/freelance |
| **Menengah** | `main` + `staging` (optional feat/* for large features) | Integration testing sebelum production |
| **Besar/Enterprise** | `main` + `staging` + `feat/*` (strict feature branches) | Formal review gates, client demos |

**Besar/Enterprise Branching Flow**:

```text
[ main ] ──────────────(Release Tag v1.0.0 - Production Clean)─────────────────►
   ▲
   │ (Merge setelah UAT Pass)
[ staging ] ───────────(Integration & Client Demo)─────────────────────────────►
   ▲
   │ (Merge setelah lolos tes lokal)
   ├── [ feat/auth-login ] ───────► (Selesai ──► Merge ke staging)
   ├── [ feat/document-vault ] ───► (Selesai ──► Merge ke staging)
   └── [ fix/pdf-render-bug ] ────► (Selesai ──► Merge ke staging)
```

### Aturan Baku Branching (Besar/Enterprise):
1. **Branch `main` (Production)**:
   - Kode produksi 100% stabil yang sudah lolos UAT klien.
   - Bersih dari berkas internal dev: berkas seperti `TODO.md` dan catatan draf internal tidak boleh mengotori branch produksi (diatur via `.gitignore` produksi atau build docker ignore).
   - Selalu diberi label SemVer: `git tag -a v1.0.0 -m "Release v1.0.0"`.
2. **Branch `staging` (Integration)**:
   - Wadah integrasi seluruh fitur yang siap diuji di server Staging. Klien menguji fitur di environment ini.
3. **Branch `feat/[nama-fitur]`**:
   - Cabang kerja solo dev untuk setiap item besar di `TODO.md`.
   - Setelah tugas selesai dan lulus `smoke-test` lokal, branch di-merge ke `staging`.
4. **Format Pesan Commit (Conventional Commits)**:
   - `feat(vault): implement streaming AES-256 encryption for PDF upload`
   - `fix(auth): correct Argon2id memory cost parameter`
   - `perf(db): add index on documents(creator_id, status)`

---

## 4. Enam Pilar Kualitas Rekayasa (The 6 Engineering Pillars)

Pengkodean bukan hanya tentang "fitur berjalan", melainkan wajib memenuhi 6 standar rekayasa:

### Pilar 1: Keamanan Defensif (Security by Design)
- **Zero Raw Queries**: 100% query SQL wajib melalui ORM/parameterized query untuk mencegah SQL Injection.
- **Validasi Ketat di Pintu Masuk**: Semua data request wajib melalui skema Zod.
- **Enkripsi Data Sensitif (UU PDP No. 27/2022)**: File dokumen dienkripsi AES-256-GCM sebelum masuk storage; password di-hash menggunakan Argon2id; token sesi disimpan di cookie `HttpOnly, Secure, SameSite=Strict`.
- **Audit Dependensi**: Jalankan `pnpm audit` secara berkala untuk memastikan tidak ada pustaka open-source yang memiliki celah keamanan (*vulnerability*).

### Pilar 2: Performa & Kecepatan (Performance Engineering)
- **Pencegahan N+1 Query**: Dilarang menjalankan query database di dalam perulangan loop. Gunakan `include`/`select` relasi atau batched query.
- **Database Indexing**: Pasang indeks pada setiap kolom Foreign Key dan kolom filter pencarian (`WHERE status = ...`).
- **Zero Layout Shift & Optimasi Aset**: Gunakan Next.js `<Image>` untuk kompresi WebP otomatis dan skeleton loader untuk mencegah pergeseran tampilan saat memuat data.
- **Caching**: Terapkan in-memory caching (Redis) untuk data master yang jarang berubah.

### Pilar 3: Efisiensi Sumber Daya & Biaya (Resource & Cost Efficiency)
- **Database Connection Pooling**: PostgreSQL memiliki batas koneksi terbatas. Selalu gunakan connection pooling (Prisma Accelerate, Supabase Pooler, atau PgBouncer) agar serverless functions tidak menenggelamkan database (*connection exhaustion*).
- **Streaming Files**: File PDF atau dokumen besar diproses menggunakan **Node.js Stream** (bukan `fs.readFileSync` ke dalam RAM) agar konsumsi memori server tetap rendah di bawah 256 MB.
- **Minimal Docker Footprint**: Jika menggunakan Docker, gunakan teknik *multi-stage build* berbasis Alpine Linux agar ukuran image kontainer kecil (< 150 MB) dan hemat biaya hosting.

### Pilar 4: Observabilitas & Ketahanan (Observability & Reliability)
- **Structured JSON Logging**: Log menggunakan format JSON (Pino) dengan trace ID, actor ID, dan error stack untuk kemudahan filter log di cloud.
- **Healthcheck & Graceful Shutdown**: Sediakan rute `GET /api/health` dan tangani sinyal `SIGTERM` untuk menutup koneksi database secara tertib.

### Pilar 5: Kemudahan Perawatan & Kebersihan Tipe (Maintainability & Type Hygiene)
- **Single Source of Truth Tipe Data**: Seluruh tipe TypeScript diturunkan dari Zod (`z.infer<typeof Schema>`), dilarang duplikasi manual.
- **Haram Barrel Files (`index.ts`)**: Impor langsung dari file spesifik untuk mencegah circular dependencies dan mempercepat tree-shaking.
- **Early Returns (Guard Clauses)**: Tangani error di baris awal fungsi, hindari struktur if-else bersarang.
- **Clean Code & Design Patterns**: Terapkan prinsip SOLID dan pola arsitektur sesuai `references/playbooks/software-design-patterns.md`.

### Pilar 6: Ketahanan Data & Pemulihan (Data Durability & Disaster Recovery)
- **Soft-Delete Mutlak**: Dokumen transaksi legal DILARANG dihapus permanen (`DELETE FROM`). Gunakan kolom `deleted_at`.
- **Integritas Transaksi Atomik**: Mutasi multi-tabel wajib dibungkus dalam blok `db.$transaction` untuk mencegah korupsi data sebagian.

---

## 5. Langkah demi Langkah Eksekusi

### Langkah 1: Persiapan Repositori & Tooling

**Input**: Kebutuhan dari `FSD.md` dan `PRD.md`.

**Aktivitas**:

1. **Buat repositori Git lokal** (jika belum ada):

   ```bash
   git init
   git branch -M main
   ```

2. **Scaffold framework bahasa pilihan**:

   **PENTING: Protokol Anti-Konflik Framework-Agnostic**

   Banyak CLI framework modern **menolak eksekusi jika direktori target tidak kosong**. Karena Modul 01-05 sudah menghasilkan folder `docs/pm/` dan `docs/specs/`, strategi scaffold berbeda per framework:

   | Framework | Empty Dir? | AGENTS.md Conflict? | Scaffold Protocol |
   |-----------|------------|---------------------|-------------------|
   | **Next.js 15+** | Yes (strict) | **YES** (auto-gen 9 lines) | Temp folder → copy → **WAJIB overwrite AGENTS.md** (see warning above) |
   | **Laravel** | No (tolerates files) | No | Direct scaffold: `composer create-project laravel/laravel .` |
   | **Django/FastAPI** | No | No | Direct init: `poetry init` / `django-admin startproject . .` |
   | **Flutter** | Yes (strict) | No | Temp folder → copy (no AGENTS.md conflict) |

   **Next.js Protocol** (ONLY if using Next.js):
   ```bash
   # Scaffold di folder KOSONG baru
   mkdir ../temp_scaffold
   cd ../temp_scaffold
   pnpm create next-app@latest . --typescript --tailwind --app --no-src-dir=false --import-alias "@/*"
   
   # Copy framework files ke project folder
   cd ../project_folder
   cp -r ../temp_scaffold/* .
   cp -r ../temp_scaffold/.* . 2>/dev/null || true
   
   # Cleanup temp
   rm -rf ../temp_scaffold
   
   # CRITICAL: Overwrite Next.js AGENTS.md boilerplate (3rd reminder)
   # Get template from ROOT_HARNESS_BUNDLE (portable path)
    cp templates/04-dev-execution/root-harness/AGENTS_TEMPLATE.md AGENTS.md
   ```

   **Laravel Protocol**:
   ```bash
   # Direct scaffold (no conflict)
   composer create-project laravel/laravel .
   
   # Copy 7 harness files from ROOT_HARNESS_BUNDLE (portable)
    cp templates/04-dev-execution/root-harness/AGENTS_TEMPLATE.md AGENTS.md
    cp templates/04-dev-execution/root-harness/CONTEXT_TEMPLATE.md CONTEXT.md
    cp templates/04-dev-execution/root-harness/ARCHITECTURE_TEMPLATE.md ARCHITECTURE.md
    cp templates/04-dev-execution/root-harness/CONVENTIONS_TEMPLATE.md CONVENTIONS.md
    cp templates/04-dev-execution/root-harness/TODO_TEMPLATE.md TODO.md
    cp templates/04-dev-execution/root-harness/DESIGN_MD_TEMPLATE.md DESIGN.md
    cp templates/04-dev-execution/root-harness/ENV_EXAMPLE_TEMPLATE.md .env.example
   ```

   **Django/FastAPI Protocol**:
   ```bash
   # Direct init
   poetry init  # or: django-admin startproject myproject .
   
   # Copy 7 harness files from ROOT_HARNESS_BUNDLE (portable)
    cp templates/04-dev-execution/root-harness/AGENTS_TEMPLATE.md AGENTS.md
    cp templates/04-dev-execution/root-harness/CONTEXT_TEMPLATE.md CONTEXT.md
    cp templates/04-dev-execution/root-harness/ARCHITECTURE_TEMPLATE.md ARCHITECTURE.md
    cp templates/04-dev-execution/root-harness/CONVENTIONS_TEMPLATE.md CONVENTIONS.md
    cp templates/04-dev-execution/root-harness/TODO_TEMPLATE.md TODO.md
    cp templates/04-dev-execution/root-harness/DESIGN_MD_TEMPLATE.md DESIGN.md
    cp templates/04-dev-execution/root-harness/ENV_EXAMPLE_TEMPLATE.md .env.example
   ```

   **Flutter Protocol**:
   ```bash
   # Scaffold di folder KOSONG
   mkdir ../temp_scaffold
   cd ../temp_scaffold
   flutter create --org com.klien --project-name legal_vault .
   
   # Copy ke project folder
   cd ../project_folder
   cp -r ../temp_scaffold/* .
   
   # Cleanup + copy harness from ROOT_HARNESS_BUNDLE (portable, no AGENTS.md conflict)
   rm -rf ../temp_scaffold
    cp templates/04-dev-execution/root-harness/AGENTS_TEMPLATE.md AGENTS.md
    cp templates/04-dev-execution/root-harness/CONTEXT_TEMPLATE.md CONTEXT.md
    cp templates/04-dev-execution/root-harness/ARCHITECTURE_TEMPLATE.md ARCHITECTURE.md
    cp templates/04-dev-execution/root-harness/CONVENTIONS_TEMPLATE.md CONVENTIONS.md
    cp templates/04-dev-execution/root-harness/TODO_TEMPLATE.md TODO.md
    cp templates/04-dev-execution/root-harness/DESIGN_MD_TEMPLATE.md DESIGN.md
    cp templates/04-dev-execution/root-harness/ENV_EXAMPLE_TEMPLATE.md .env.example
   # ... (copy 6 other files)
   ```

3. **Verifikasi 7 Root Harness Files terpasang**:

   ```bash
   # Fixed verification: .env.example has no .md extension
   ls -1 | grep -E '^(AGENTS|CONTEXT|ARCHITECTURE|DESIGN|CONVENTIONS|TODO)\.md$' && ls -1 .env.example
   ```

   Expected output: 6 .md files + .env.example (7 total).

4. **Buat branch staging**: `git checkout -b staging`

5. **Commit awal** untuk mengunci harness dan scaffolding:
   ```bash
   git add .
   git commit -m "chore: initial project scaffolding with 7 AI harness files"
   ```

### Langkah 2: Implementasi Komponen UI (Stitch atau Manual Scaffold)

**Opsi A: Import dari Google Stitch (Jika Screen ID Tersedia)**
1. Baca Screen ID dari `DESIGN_SYSTEM.md` (Bagian II: Inventaris Layar).
2. Instruksikan OpenCode (jika Stitch MCP tersedia):
   > *"Gunakan tool `stitch_get_screen` untuk Screen ID yang terdaftar. Ekstrak kode HTML/Tailwind menjadi komponen React di `src/components/ui/` dan pasang halamannya di `src/app/`."*
3. Jalankan `pnpm dev` untuk verifikasi UI identik dengan desain.

**Opsi B: Scaffold Manual (Tanpa Stitch)**
1. Baca deskripsi layar dari `DESIGN_SYSTEM.md` (sitemap + token warna/tipografi).
2. Buat komponen UI shell kosong dengan struktur folder yang benar:
   ```bash
   mkdir -p src/components/ui src/app/{dashboard,documents,login}
   ```
3. Instruksikan AI untuk generate komponen berdasarkan DESIGN_SYSTEM.md tanpa Stitch:
   > *"Baca `DESIGN_SYSTEM.md`. Buat komponen React/Vue/Flutter sesuai palet Zinc, font Inter, border flat 1px. Scaffold halaman login, dashboard, document list."*

### Langkah 3: Eksekusi Migrasi Basis Data & Seeding
1. **Verifikasi Staging ENV**: Before migrations, verify `.env` (staging):
   ```bash
   # Check no production keys leaked to staging
   grep -E '(DATABASE_URL|STRIPE_SECRET_KEY|AWS_SECRET)' .env
   # Confirm staging endpoints (e.g., Stripe test mode key prefix sk_test_)
   ```
2. Instruksikan agen AI (OpenCode):
   > *"Baca ARCHITECTURE.md bagian Database Models. Buat skema Prisma/Drizzle lengkap dengan konstrain CHECK, relasi foreign key, dan indeks performa. Jalankan migrasinya."*
3. Jalankan migrasi: `pnpm db:migrate`
4. Jalankan seeding data awal: `pnpm db:seed`

### Langkah 4: Koding Backend API, Layanan Vault, & Wiring UI
1. Instruksikan agen AI mengeksekusi item pada `TODO.md` satu per satu:
   - Terapkan validasi Zod pada handler API.
   - Buat layanan enkripsi stream AES-256-GCM ke S3/R2 dan presigned URL 15 menit.
   - Sambungkan form UI Stitch ke endpoint API via `fetch` atau Server Actions.
   - Pastikan kelima kondisi layar berfungsi: *Skeleton Loader*, *Empty State*, *Inline Error Message*, dan *Toast Notifikasi*.
   - Terapkan pola prompt engineering & multi-file orchestration dari `references/playbooks/ai-assisted-development.md`.

### Langkah 5: Uji Asersi Mandiri (Smoke Test Lokal)
Jalankan skrip uji cepat:
```bash
pnpm run test:smoke
```
Pastikan kompilasi bersih (`pnpm run type-check`) dan audit dependensi aman (`pnpm audit`).

---

## 6. Pencapaian Milestone Pembayaran (Termin Gates)

1. **Milestone Alpha (Termin 2 - 25% s/d 30%)**:
   - *Kriteria Lolos*: Basis data termigrasi, otentikasi login aktif, alur pembuatan draf dokumen berjalan lokal, dan pilar keamanan/performa dasar terverifikasi di branch `staging`.
   - *Tindakan*: Terbitkan Invoice Termin 2 ke Klien.
2. **Milestone Beta (Termin 3 - 20% s/d 25%)**:
   - *Kriteria Lolos*: Seluruh modul backend, frontend, vault terenkripsi terhubung lengkap serta siap diuji coba di server Staging.
   - *Tindakan*: Lanjut ke Modul 07 (QA & SIT) sebelum UAT klien.

---

## 7. Artefak Keluaran (Deliverables)

1. **Source Code Repositori Git**: Basis kode bersih dengan branch `staging` aktif dan riwayat commit terstruktur.
2. **`RUNBOOK_LOCAL.md`**: Panduan lengkap setup environment, migrasi DB, dan menjalankan aplikasi di lokal (menggunakan `templates/04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md`).
3. **`VERIFY_LOCAL.md`**: Lembar hasil verifikasi mandiri bahwa seluruh endpoint FSD, 3 pilar rekayasa, dan alur Stitch berfungsi 100% (menggunakan `templates/04-dev-execution/VERIFY_LOCAL_TEMPLATE.md`).
4. **`AI_REVIEW_LOG.md`**: Log protokol review kode AI pre-merge sesuai panduan `references/playbooks/ai-assisted-development.md`.

---

## 8. Kriteria Kelulusan [GATE] (Gate Exit Criteria)

[GATE] Modul 06 dinyatakan **LOLOS (PASS)** jika:
- [x] Percabangan Git terstruktur (`main`, `staging`, `feat/*`) dengan commit rapi.
- [x] 7 berkas kendali AI (Agent Harness) terpasang di root proyek.
- [x] Komponen Google Stitch telah diekstrak via MCP dan terhubung ke backend API.
- [x] Kode sumber berhasil di-build tanpa error kompilasi TypeScript (`tsc --noEmit` exit 0).
- [x] Migrasi basis data berjalan mulus dengan indeks pencarian terpasang.
- [x] Enkripsi file vault AES-256-GCM berbasis stream berhasil menyimpan dan membaca dokumen via presigned URL.
- [x] Skrip uji mandiri (`smoke-test`) lulus 100% dan audit dependensi (`pnpm audit`) bebas celah kritis.

---

## 🛑 PROTOKOL [GATE] KELUAR & WAJIB BERHENTI

Setelah koding selesai dan skrip `smoke-test` lulus 100%:
1. **DILARANG KERAS langsung melanjutkan atau memanggil tool untuk Modul 07 dalam giliran (turn) yang sama!**
2. **VERIFIKASI DIRI (Self-Verification Checklist)**:
   - [ ] `terminal('pnpm run type-check')` → Exit code 0 (no TypeScript errors)
   - [ ] `terminal('pnpm run test:smoke')` → All assertions passed
   - [ ] `terminal('pnpm audit')` → No critical vulnerabilities
   - [ ] `read_file('VERIFY_LOCAL.md')` → Documented test results exist
   - [ ] `terminal('git log -1')` → Latest commit exists on staging branch
3. Tampilkan ringkasan hasil development lokal kepada pengguna:
   - Hasil uji kompilasi dan smoke test lokal
   - Bukti fungsionalitas di `VERIFY_LOCAL.md`
   - Kesiapan pengujian integrasi Staging (Termin 2 Alpha Release)
4. **AKHIRI RESPON ANDA (END TURN)** dan ajukan konfirmasi kepada pengguna:
   > *"Seluruh fitur inti telah selesai dikoding dan diverifikasi lokal (Smoke Test PASS). Apakah hasil development ini disetujui sebelum kita membuka Modul 07 (Quality Assurance & SIT di Staging)?"*
5. Tunggu respon persetujuan eksplisit dari pengguna sebelum melangkah ke Modul 07.
