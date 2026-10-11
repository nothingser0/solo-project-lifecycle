# TODO.md — Engineering Execution Plan & Automated Quality Gates

> **Role & Purpose**: Sequential atomic task list for AI Coding Agents (Cursor / Claude Code / Windsurf / Codex CLI).
> **Execution Rule**: Execute one task $\rightarrow$ run automated verification $\rightarrow$ record evidence $\rightarrow$ check `[x]` $\rightarrow$ advance to next task.
> **Integrity Mandate**: Zero unverified tasks. Zero hallucinated features outside In-Scope. Zero bypassed TypeScript compiler errors.
> **Scale & Domain Adaptability**: Adaptable across all software categories (CRM, CMS, HRIS, E-Commerce, Retail/POS, Fintech, Developer Tools) and all 4 scales:
> - **Small (MVP / Internal)**: Core database, UI shell, essential CRUD, and smoke tests (mark billing, webhooks, offline queues N/A).
> - **Medium (B2B SaaS / Agency)**: 7 Sprints covering multi-tenant RLS, state journals, mutation idempotency, and automated QA.
> - **Large / Enterprise**: Comprehensive execution covering high-concurrency row-locking, audit vaults, load testing, and disaster recovery.

### Standard Task Architecture (8 Mandatory Elements per Task)
Every atomic task in `TODO.md` MUST specify these 8 core fields to prevent AI hallucination and scope drift:
1. **Unique Task ID**: e.g., `M06-DB-01`, `M06-BE-01`, `M06-FE-01` (referenced in git commits and test logs).
2. **Title & Single Objective**: Specific, non-compound goal (1 table, 1 endpoint, or 1 screen only).
3. **Files (Target Paths)**: Exact file paths created or modified (stops AI from inventing new ad-hoc paths).
4. **Depends**: Preceding task IDs that MUST be completed first (e.g. `M06-DB-01` before `M06-BE-01`).
5. **Action**: Precise implementation instructions, domain formulas, and architectural constraints.
6. **Out of Scope**: Explicit boundaries of what NOT to touch in this task (stops unprompted side-edits).
7. **Verify & Expected**: Executable terminal command (`Verify`) and deterministic success criteria (`Expected`).
8. **Extended Task Status**:
   - `- [ ]` : Not started (Pending)
   - `- [~]` : In progress (Actively executing)
   - `- [!]` : Blocked (Halted with explicit blocker reason)
   - `- [x]` : Completed (Verified exit 0 with proof)

### Header-Level Pre-Conditions (Before Sprint 0)
- **Primary Objective**: Build 100% of agreed in-scope features from `FSD.md` and `PRD.md` with zero unhandled edge cases.
- **Mandatory Pre-Read Documents**: `AGENTS.md` (anti-slop directives), `CONTEXT.md` (boundaries), `FSD.md` (DDL & RLS), `PRD.md` (BDD criteria), `DESIGN.md` (tokens), and `SITEMAP.md`.
- **Module Exit Gate Criteria**: 100% of tasks marked `[x]` (zero `[ ]` or `[!]` remaining), `pnpm tsc --noEmit` exit 0, smoke tests passing, zero `@ts-ignore`, and `validate-gate.sh M06` passed.

### Execution Paradigm: Standard Full-Stack Architecture
$$\text{Sprint 0 (Setup)} \longrightarrow \text{Sprint 1 (Database)} \longrightarrow \text{Sprint 2 (Backend)} \longrightarrow \text{Sprint 3 (Frontend)} \longrightarrow \text{Sprint 4 (Integrasi)} \longrightarrow \text{Sprint 5 (Testing)} \longrightarrow \text{Sprint 6 (Gate)}$$

1. **Database First**: Skema DDL, foreign key index, RLS policies, dan Stored Procedure atomik. Database adalah sumber kebenaran tunggal (*single source of truth*).
2. **Backend APIs / Actions**: Endpoint tervalidasi Zod, auth verification (`getUser()`), dan route protection middleware. Diuji langsung ke database.
3. **Frontend Implementation**: Konversi desain layar ke kode stack; jika belum ada screen per layar, buat langsung dari `DESIGN.md` + logo dan inspirasi visual di `docs/design/inspiration/`. Ergonomi tombol $\ge 44\text{px}$, input $16\text{px}$.
4. **Integrasi Frontend ➔ Backend (Wire-Up)**: Form dan tombol kasir langsung memanggil backend nyata. **Larangan keras dummy UUID (`11111111-...`) dan larangan `catch {}` kosong**.
5. **Testing & QA**: SIT rumus bisnis (WAC, PPh 0,5%) dan E2E browser automation (Playwright).
6. **Hard Release Gate**: `npm run build` exit code 0. AI agent dilarang keras `git commit` / `git push` mandiri.

### Traceability Mapping Framework
| Task Prefix | Source Document | Primary Concrete Output |
| :--- | :--- | :--- |
| **`M06-SETUP-xx`**| Environment, DB Config & Design Assets | `.env.local`, DB Connection, Brand Assets |
| **`M06-DB-xx`** | `docs/specs/FSD.md` (§2, §3, §5) | `supabase/migrations/*.sql` (Tables, RLS, RPCs) |
| **`M06-BE-xx`** | `docs/specs/FSD.md` (§4, §5) & `PRD.md` | `src/actions/*.ts` & `src/app/api/v1/*` (Route Handlers) |
| **`M06-FE-xx`** | `docs/specs/SITEMAP.md` & `DESIGN_SPEC.md` | `src/app/*` (UI Components & 100% SCR-xx Screens) |
| **`M06-INT-xx`**| `docs/specs/FSD.md` (§5) & Hardware/SaaS | Live Form Wire-up, Webhooks, Thermal ESC/POS |
| **`M06-TEST-xx`**| `docs/specs/PRD.md` (Acceptance Criteria) | `tests/db/*`, `tests/sit/*`, `tests/e2e/*` (Vitest / Playwright) |
| **`M06-GATE-xx`**| Release Protocols & Human Handover | Verified Production Build & Git Handoff Log |

---

## Sprint 0: Environment Setup, Database Init & Asset Audit (MANDATORY FIRST)

- [ ] **M06-SETUP-01: Local Environment Configuration & Secrets Staging**
  - Salin `.env.example` ke `.env.local`. Isi semua kredensial database, JWT secret, dan API keys.
  - Untuk Supabase / Auth: Matikan opsi *Confirm Email* di dashboard local/dev config guna mencegah error rate limit (`email rate limit exceeded`).
  - **Verify**: `npm run dev` berjalan bersih dan terhubung ke instance database.
  - **Expected**: Koneksi database terjalin tanpa error variabel hilang.
  - **Evidence**: Log terminal menunjukkan boot server bersih.

- [ ] **M06-SETUP-02: Design Assets & Visual Identity Audit**
  - Periksa `docs/design/inspiration/`, `docs/specs/LOGO_DESIGN_BRIEF.md`, dan prompt visual.
  - Salin logo brand asli, favicon, font, dan warna tema primer ke `public/` atau `src/assets/`.
  - **Verify**: File aset siap diimpor di komponen UI; larangan layout monokrom generic tanpa identitas brand.
  - **Expected**: Aset brand valid; tidak ada icon placeholder kaku.
  - **Evidence**: Listing file visual di direktori aset.

- [ ] **M06-SETUP-03: Mandatory Documentation & Specs Pre-Read Sign-Off (ALL SCALES)**
  - **Wajib dibaca utuh SEBELUM menulis baris kode pertama.** Dokumen wajib dibaca bersifat adaptif terhadap skala:
    - **Semua skala**: `AGENTS.md` (aturan koding & anti-slop), `CONTEXT.md` (konteks bisnis & batas out-of-scope), `docs/specs/DESIGN.md` (token visual), `docs/specs/SITEMAP.md` (peta rute & Screen ID `SCR-xx`), `docs/specs/DESIGN_SPEC.md` (wireflow & matriks 5-state).
    - **Skala Kecil (Fast-Track)**: `PROJECT_LITE.md` (Seksi 5 arsitektur: skema database & daftar API) sebagai pengganti FSD/PRD.
    - **Skala Medium / Large / Enterprise**: `docs/specs/FSD.md` (DDL, RLS, API, idempotency) dan `docs/specs/PRD.md` (traceability `F-xx→REQ-xx` & skenario BDD).
  - Pahami kontrak data, hak akses role (RBAC), aturan mutasi atomik, dan batas *Out-of-Scope*.
  - **Verify**: Catat model status, aturan idempotensi, kebijakan RLS, dan daftar Screen ID yang harus diimplementasikan.
  - **Expected**: Pemahaman penuh seluruh spesifikasi sebelum menyentuh file skema atau komponen UI.
  - **Evidence**: Checklist dokumen spesifikasi yang telah dibaca dan diverifikasi.

---

## Sprint 1: Database Foundation, DDL Migrations & Atomic RPCs

- [ ] **M06-DB-01: Relational Schema & 100% Foreign Key Indexing (Universal)**
  - **Files**: `supabase/migrations/001_initial_schema.sql` (or Prisma/Drizzle equivalent migration file)
  - **Depends**: `M06-SETUP-01` (local environment & database instance active)
  - **Action**: Definisikan seluruh tabel skema FSD (master data, transaksi, audit log). Tipe moneter wajib `BIGINT` atau `NUMERIC(15, 2)` (larangan float rounding) dan `NUMERIC(12, 3)` untuk kuantitas pecahan. Tambahkan eksplisit `CREATE INDEX` pada setiap kolom foreign key (`REFERENCES table(id)`) dan arithmetic CHECK constraints (`net_amount = subtotal - discount`, `quantity > 0`).
  - **Out of Scope**: Dilarang menulis Server Actions, API routes, atau komponen UI di task ini (fokus DDL database murni).
  - **Verify**: Jalankan migrasi di container database lokal (`supabase db push` / `pnpm db:migrate`).
  - **Expected**: Migrasi sukses dengan exit code 0; seluruh tabel, index, dan constraint terbuat.
  - **Evidence**: Query `information_schema.tables` dan `pg_indexes` mengonfirmasi pembuatan tabel dan index 100%.

- [ ] **M06-DB-02: Access Control, RLS & Array Operator Hardening (Universal)**
  - Aktifkan RLS di setiap tabel multi-tenant: `ALTER TABLE [table] ENABLE ROW LEVEL SECURITY;`.
  - Buat policy granular per operasi (`SELECT`, `INSERT`, `UPDATE`, `DELETE`) sesuai role pengguna.
  - Helper function hardening: `CREATE OR REPLACE FUNCTION get_current_user_org_id() ... SET search_path = public, pg_temp STABLE;` dengan validasi `is_active = TRUE`.
  - **Array Comparison Rule**: Gunakan array containment PostgreSQL `@> ARRAY[id]` atau explicit cast `id = ANY((...)::uuid[])` guna menghindari error `SQLSTATE 42883 (operator does not exist: uuid = uuid[])`.
  - **Verify**: Automated RLS access tests (simulasi akses cross-tenant dan unauthorized staff).
  - **Expected**: Query cross-tenant return 0 rows; mutasi tanpa hak ditolak dengan policy violation.
  - **Evidence**: Log pengujian database menunjukkan penolakan akses.

- [ ] **M06-DB-03: Idempotent Organization Registration RPC (Universal)**
  - Buat Stored Procedure atomik `register_initial_organization` (membuat organisasi, cabang default, dan user owner dalam 1 transaksi `BEGIN ... COMMIT`).
  - Wajib menyertakan klausul `ON CONFLICT (id) DO UPDATE` saat insert tabel `users` guna mencegah error `duplicate key value violates unique constraint "users_pkey"`.
  - **Verify**: Jalankan pemanggilan registrasi ganda dengan ID user yang sama.
  - **Expected**: Transaksi berhasil secara idempoten tanpa kegagalan constraint.
  - **Evidence**: Query basis data membuktikan record terdaftar rapi tanpa duplikasi error.

- [ ] **M06-DB-04: Atomic Mutation Stored Procedure / Concurrency Guard (Conditional)**
  - Buat Stored Procedure transaksi atomik (`process_pos_checkout` / `rpc_execute_[mutation]`) dengan deterministic row-locking: `SELECT ... FOR UPDATE ORDER BY id ASC`.
  - Ambil harga/biaya resmi dari tabel server (anti-tampering harga dari sisi klien).
  - Catat mutasi ke append-only ledger (`inventory_movements`, `balance_movements`) dan simpan snapshot biaya historis.
  - **Verify**: Simulasikan eksekusi konkuren dari 2 sesi yang mengakses item yang sama.
  - **Expected**: Transaksi kedua antre bersih menunggu pelepasan lock; zero deadlock, zero saldo negatif.
  - **Evidence**: Log uji konkurensi membuktikan serialisasi lock berhasil.

- [ ] **M06-DB-05: Sensitive Data Masking & Database Views (Conditional)**
  - Buat database view aman untuk role staf kasir/operasional (contoh: `products_cashier_view`) yang menyembunyikan harga beli (`buy_price`), margin, atau gaji.
  - Berikan izin akses staf hanya lewat view ini (`security_invoker = true`).
  - **Verify**: Query view kasir via token akun staf.
  - **Expected**: Kolom harga beli tersembunyi total di tingkat basis data.
  - **Evidence**: Hasil query JSON tidak memuat field sensitif.

- [ ] **M06-DB-06: Idempotency Cache & Immutable Audit Log Tables (Universal)**
  - Buat tabel `idempotency_keys` dengan unique constraint pada `(org_id, idempotency_key)`.
  - Buat tabel `audit_logs` dengan policy RLS ketat (hanya `SELECT` dan `INSERT`; tolak `UPDATE` dan `DELETE`).
  - **Verify**: Eksekusi `UPDATE audit_logs SET action = 'tampered'`.
  - **Expected**: Basis data menolak kueri dengan error permission denied.
  - **Evidence**: Pesan error SQL mengonfirmasi penolakan mutasi.

---

## Sprint 2: Core State Engine, Server Actions & Route Handlers (Backend)

- [ ] **M06-BE-01: API Boundary Validation dengan Zod (Universal)**
  - Bangun Server Actions dan Route Handlers yang memetakan seluruh mutasi data.
  - Validasi seluruh payload input menggunakan skema Zod ketat (`uuid`, `min`, `positive`, integer amount).
  - **Verify**: Kirim payload kotor/kosong ke Server Action.
  - **Expected**: Request ditolak dengan kode `VALIDATION_ERROR` dan field errors terstruktur.
  - **Evidence**: Log pengujian unit validasi backend.

- [ ] **M06-BE-02: RBAC Enforcement & Route Protection Middleware (Universal)**
  - Validasi sesi pengguna di server menggunakan `supabase.auth.getUser()`, jangan pernah mempercayai cookie klien tanpa verifikasi.
  - Konfigurasi `middleware.ts` untuk memproteksi seluruh rute privat (`/dashboard/*`, `/pos`, `/products`, `/reports/*`).
  - **Verify**: Buka URL privat dalam sesi tanpa autentikasi (incognito).
  - **Expected**: Pengguna langsung di-redirect ke `/login`.
  - **Evidence**: Respon HTTP network menunjukkan status 307/302 redirect.

- [ ] **M06-BE-03: Real Backend Mutation Handlers (Universal)**
  - Implementasikan logika kulakan pembelian barang (`recordPurchase`), penyesuaian stok opname, dan pelunasan piutang/kasbon.
  - **Anti-Mock Mandate**: Dilarang menggunakan dummy UUID statis (seperti `'11111111-...'`). Seluruh operasi wajib mengacu pada record relasional nyata di database.
  - **Verify**: Jalankan pemanggilan action kulakan barang masuk di lingkungan lokal.
  - **Expected**: Data transaksi pembelian tercatat di database dan saldo stok bertambah.
  - **Evidence**: Kueri database membuktikan penambahan record transaksi dan mutasi stok.

---

## Sprint 3: Design Tokens, UI Shell & 100% Screen Implementation (Frontend)

- [ ] **M06-FE-01: Semantic CSS Tokens & TypeScript Strict Configuration (Universal)**
  - Daftarkan CSS variables di `globals.css` sesuai `DESIGN.md`: surface base, triad status (`--success`, `--warning`, `--destructive`), dan z-index.
  - Pasang font brand dan konfigurasi warna tema di `tailwind.config.js`.
  - **Verify**: Jalankan `type-check` dan periksa token warna di browser DevTools.
  - **Expected**: Exit code 0, CSS variables ter-resolve sempurna.
  - **Evidence**: Log compiler TypeScript.

- [ ] **M06-FE-02: Public Shell & Authentication Pages (SCR-001, SCR-002)**
  - Implementasikan landing page (`SCR-001`) dan login portal (`SCR-002`) menggunakan aset logo dan inspirasi visual di `docs/design/inspiration/`.
  - Input form wajib `text-base` (16px) universal untuk mencegah auto-zoom di iOS Safari.
  - Submit button tetap aktif dalam kondisi pristine; klik memicu validasi dan auto-focus field invalid pertama.
  - **Verify**: Buka form login di simulasi layar mobile, klik submit saat input kosong.
  - **Expected**: Viewport tidak auto-zoom; pesan error inline muncul; field pertama fokus.
  - **Evidence**: Screenshot browser menampilkan validasi form mobile.

- [ ] **M06-FE-03: Operational Dashboard & Analytical Widgets (SCR-003, SCR-004)**
  - Bangun layout dashboard responsif: desktop sidebar (240–260px) dan mobile navigation bar.
  - Terapkan 5-State Matrix: Idle/Default, Loading Skeletons (`animate-pulse`), Empty State dengan CTA, Error Banner dengan tombol coba lagi, dan Success Toast.
  - **Verify**: Throttle koneksi ke Slow 3G di DevTools; amati perpindahan state.
  - **Expected**: Skeleton loader tampil halus sebelum data ter-render.
  - **Evidence**: Screenshot tampilan loading skeleton dan empty state.

- [ ] **M06-FE-04: Operational Execution Workspace / Terminal Kasir (SCR-005)**
  - Split layout: katalog barang di kiri, keranjang transaksi aktif di kanan/bawah.
  - Target sentuh tombol kasir wajib $\ge 44\text{px} \times 44\text{px}$ (`h-11 min-w-11`).
  - Tombol `Enter` terikat ke pencarian item/barcode; tombol checkout/bayar terikat ke tombol terpisah atau shortcut fungsi (`F4`).
  - **Verify**: Ukur ukuran tombol kasir di inspector elemen browser.
  - **Expected**: Seluruh tombol interaktif memenuhi batas minimal $\ge 44\text{px}$.
  - **Evidence**: Screenshot box model inspector.

- [ ] **M06-FE-05: Resource Catalog & Input Masking (SCR-006, SCR-007)**
  - Tabel master produk dengan pencarian, filter kategori, dan pagination.
  - Input nominal moneter wajib menggunakan `inputmode="numeric"` dengan live separator ribuan (contoh: `Rp 1.250.000`), jangan pernah memakai `<input type="number">`.
  - **Verify**: Ketik nominal angka di input harga barang.
  - **Expected**: Angka otomatis terformat dengan titik pemisah ribuan.
  - **Evidence**: Screenshot input aktif form harga.

---

## Sprint 4: Integrasi Frontend ➔ Backend (Wire-Up Bebas Mock)

- [ ] **M06-INT-01: Live Form Connection & Anti-Fake-Success Enforcement**
  - Sambungkan seluruh form UI (Registrasi, Onboarding, Produk, Kulakan, Kasbon) langsung ke Server Actions Sprint 2.
  - **Anti-Fake-Success Rule**:
    - Dilarang membungkus request API dengan `try { await fetch(...) } catch {}` kosong.
    - Dilarang menampilkan popup sukses palsu jika request database gagal.
    - Tangkap error respon backend dan tampilkan pesan error spesifik via toast/alert UI.
  - **Verify**: Submit transaksi kasir saat backend memicu validasi error (simulasikan stok habis).
  - **Expected**: UI menampilkan toast error merah dengan pesan kesalahan server; modal sukses TIDAK muncul.
  - **Evidence**: Screenshot antarmuka menampilkan pesan error server asli.

- [ ] **M06-INT-02: Payment Gateway & Webhook Cryptographic Verification (Conditional)**
  - Integrasikan checkout langganan / pembayaran QRIS (Midtrans / Xendit).
  - Webhook endpoint memverifikasi tanda tangan kriptografi (HMAC SHA-512) dan mencatat idempotency key.
  - **Verify**: Kirim webhook simulasi dengan signature palsu, lalu dengan signature valid.
  - **Expected**: Signature palsu ditolak dengan `403 Forbidden`; signature valid memproses aktivasi.
  - **Evidence**: Log server webhook mengonfirmasi verifikasi signature.

- [ ] **M06-INT-03: Thermal Receipt & Printing Hardware Integration (Conditional)**
  - Implementasikan stylesheet cetak struk kasir `@media print` (58mm/80mm, font monospace, tanpa margin browser).
  - Fallback aman: jika printer terputus, transaksi tetap tercatat di database dan sediakan opsi "Cetak Ulang Struk".
  - **Verify**: Buka dialog cetak struk untuk transaksi yang telah selesai.
  - **Expected**: Preview cetak pas pada lebar 58mm/80mm tanpa bleed header/footer browser.
  - **Evidence**: Screenshot preview print thermal.

---

## Sprint 5: Automated Testing & Verifikasi Kualitas (M07 Entry)

- [ ] **M06-TEST-01: SIT Core Business Calculations (Vitest)**
  - Tulis unit test untuk rumus bisnis krusial:
    1. Perhitungan Weighted Average Cost (WAC) saat kulakan barang masuk.
    2. Pengurangan saldo piutang kasbon saat cicilan diterima.
    3. Perhitungan cadangan PPh Final 0,5% UMKM (PP 55/2022 / regulasi berlaku).
  - **Verify**: Jalankan test suite lokal: `npx vitest run`.
  - **Expected**: 100% test assertions pass dengan exit code 0.
  - **Evidence**: Output ringkasan test runner di terminal.

- [ ] **M06-TEST-02: End-to-End User Journey Automation (Playwright)**
  - Jalankan pengujian Playwright untuk alur kritis: Registrasi Akun $\rightarrow$ Onboarding $\rightarrow$ Tambah Barang $\rightarrow$ Transaksi POS Kasir $\rightarrow$ Cetak Struk.
  - **Verify**: Jalankan Playwright headless test.
  - **Expected**: Seluruh user journey sukses dari awal hingga akhir; zero hydration mismatch, zero unhandled exception di console browser.
  - **Evidence**: Rekaman video test atau laporan Playwright pass.

---

## Sprint 6: Hard Release Gate (Human Handover & Deploy Guard)

- [ ] **M06-GATE-01: Production Build & Type Integrity Gate**
  - Jalankan build produksi lokal: `npm run build` dan `npx tsc --noEmit`.
  - Pastikan tidak ada supresi compiler (`// @ts-ignore`, `as any`).
  - **Verify**: Terminal compile build produksi.
  - **Expected**: Exit code 0 tanpa error TypeScript atau lint.
  - **Evidence**: Log terminal output `npm run build` sukses.

- [ ] **M06-GATE-02: Strict Human-Only Commit & Deployment Handoff**
  - **Protokol Keselamatan**: AI Agent dan harness dilarang keras menjalankan `git commit` maupun `git push`.
  - Sediakan instruksi ringkas panduan runbook deploy lokal (`RUNBOOK_LOCAL.md`) dan serahkan perubahan ke developer manusia untuk di-commit secara manual.
  - **Verify**: Status git bersih dan siap di-review developer.
  - **Expected**: Laporan verifikasi disajikan ke developer; tidak ada commit/push liar oleh agen.
  - **Evidence**: Laporan akhir diserahkan kepada pengguna.
