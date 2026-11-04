# Solo Developer UI/UX Guide: Efficiency, Accessibility, & Design Freeze

This document provides practical guidelines for solo developers to design professional, ergonomic, and accessible user interfaces without falling into the traps of pixel-pushing or endless visual revisions from clients.

---

## 1. `DESIGN.md` Workflow: Maximum Efficiency for Solo Developers

> **Workflow Note:** This guide defaults to pure Markdown `DESIGN.md` workflow with modern component libraries (shadcn/ui, Tailwind). Interactive visual prototyping (v0, Figma, Bolt) is optional.

Solo developers should never waste time designing twice (first on a vector canvas, then recoding from scratch). Use `DESIGN.md` as the single source of truth for visual decisions across all project scales, from Small to Enterprise.

### 1.0 Bagaimana SITEMAP.md Dihasilkan dari SCOPE_STATEMENT.md (Hulu ke Hilir)
Sebelum merancang prototipe atau menulis `SITEMAP.md`, struktur halaman tidak boleh dikarang bebas dari imajinasi. `SITEMAP.md` diturunkan secara deterministik dari 4 fondasi utama di `docs/pm/SCOPE_STATEMENT.md`:

1. **Pemetaan Fitur MoSCoW (P0 Must-Have & P1 Should-Have)**:
   - Setiap fitur yang disepakati (`F-01..F-NN`) **wajib** memiliki representasi minimal 1 layar konkret (`SCR-01..SCR-NN`) tempat user berinteraksi.
   - *Contoh*: `F-01` (Auth) → `/login`, `F-02` (Katalog Unit) → `/rooms` & `/rooms/:id`, `F-03` (Invoicing) → `/billing`.
   - **Aturan Anti-Drift**: Zero orphan screens (tidak ada layar tanpa dasar fitur di scope, dan tidak ada fitur P0 yang tertinggal tanpa layar UI).

2. **Matriks Peran Pengguna / RBAC (`ROL-01..ROL-NN`)**:
   - Menentukan segmentasi rute dan hak akses navigasi (*route guards*).
   - Memisahkan zona Public (`/`, `/login`), zona Operator/Staff (`/app/*`), dan zona Admin/Owner (`/admin/*`).

3. **User Stories & Critical Flows (Given-When-Then)**:
   - Rangkaian alur cerita pengguna mendikte hierarki navigasi dan tautan antar-layar (*screen flows & breadcrumbs*: misal Dashboard → Daftar Entitas → Formulir Input → Halaman Sukses).

4. **Struktur Shell dari Visual Benchmark (Step 0.5)**:
   - Referensi desain di `docs/design/inspiration/` menentukan Information Architecture (IA) fisik (apakah aplikasi menggunakan Fixed Sidebar, Topbar Navigation, atau Segmented Tab Shell).

### 1.1 Three-Step Procedure for a Slop-Free `DESIGN.md` Workflow
1. **Step 1: Lock the Design System (`DESIGN.md`)**:
    - Populate the `DESIGN.md` template upfront with color tokens, typography, radius, spacing, interactive states, and accessibility constraints.
    - Treat this document as the reference for design, implementation, and review to prevent emoticons instead of icons, floating cards, or fonts that clash with the product identity.
2. **Step 2: Precision Screen Prompting Formula**:
    - *Prompt Pattern*:
      > *"Build the [Screen Name] interface for the [Role] user. Follow `DESIGN.md`. Display a clean, flat Tailwind-based layout. Displayed data: [List of Real Columns/Fields]. Components: use dense data tables, semantic status badges, and 1px bordered action buttons. Do not use heavy drop-shadows or generic AI styling. Never use emoticons or emojis; always use SVG icons."*
3. **Step 3: Connecting Screens into a Real Prototype**:
    - Implement components strictly according to `DESIGN.md`.
    - Connect routing links: `<a href="/target-page">`.
    - Deploy instantly to Vercel or Cloudflare Pages as an interactive live demo for the client.

### 1.2 `DESIGN.md` Implementation Matrix by Scale:
| Scale | Screen Coverage with `DESIGN.md` | Demo Output |
| :--- | :--- | :--- |
| **Small (MVP / Freelance)** | **100% of all pages** in Scope (no reductions) | Instant Live Vercel Staging link |
| **Medium (B2B SaaS)** | **100% of all pages** complete with 5-state variants | Fully interactive Live Web Staging |
| **Large & Enterprise** | **100% of all pages** covering all user roles & permissions | Live Web Staging + WCAG AA Accessibility Compliance Audit |

### 1.3 Modular & Reusable Architecture for Prototype Screens
When building prototype screens in `docs/design/screens/`:
- **Separate HTML, CSS, and JS**:
  - `css/styles.css`: Centralized design system (tokens from `DESIGN.md`, base typography, `.btn`, `.card`, `.badge`, `.navbar`, `.sidebar`, form controls).
  - `js/app.js`: Centralized interaction behaviors (active nav detection, modal backdrop handlers, toast notifications, 5-state matrix preview switcher).
  - Screen HTMLs (`index.html`, `rooms.html`, `billing.html`): Clean semantic markup linking to the shared CSS and JS (`<link rel="stylesheet" href="css/styles.css">` and `<script src="js/app.js"></script>`).
- **Eliminate Disjointed Inline Slop**:
  - Never write monolithic HTML files with duplicate inline `<style>` tags or arbitrary hardcoded classes per screen.
  - Ensures navbar layout, button heights, card paddings, font scales, and badge styles remain 100% identical and consistent across every route in `SITEMAP.md`.
  - Accelerates M06 implementation: cleanly structured prototype components convert directly 1-to-1 into React/Vue/Blade components with zero guesswork.

### 1.4 Audit Otomatis UI/UX & Auto-Fixer: Menjaga Konsistensi Lintas Halaman
Sebelum menunjukkan prototipe kepada klien atau sebelum menandatangani Design Freeze, solo developer wajib menjalankan audit otomatis konsistensi UI/UX:
- **Perintah Eksekusi**:
  - `powershell -ExecutionPolicy Bypass -File scripts/design/uiux-audit.ps1 -Fix -Report docs/specs/DESIGN_SYSTEM_AUDIT.md` (Windows)
  - `python3 scripts/design/uiux_audit.py docs/design/screens/ --fix --report docs/specs/DESIGN_SYSTEM_AUDIT.md` (Linux/Mac/CI)
- **Peran Auditor UI/UX Otomatis**:
  1. **Audit Komponen**: Memeriksa seluruh tombol, kartu, badge, dan formulir agar tidak ada yang memakai styling acak atau inline style di luar `css/styles.css`.
  2. **Audit Animasi & Micro-Interaction**: Memastikan durasi transisi hover seragam (`150ms ease-out`), kompresi sentuhan aktif (`active:scale-[0.98]`), dan kepatuhan `prefers-reduced-motion`.
  3. **Audit Zero Emoticon**: Memastikan zero raw emojis pada antarmuka, mewajibkan penggunaan icon SVG kohesif (misal: Lucide).
  4. **Audit Paritas Navigasi**: Memeriksa menu sidebar dan navbar di seluruh layar; mencegah perbedaan nama brand atau menu navigasi yang hilang antar-halaman.
  5. **Auto-Fixing**: Otomatis menyuntikkan tag stylesheet, script interaktif, dan meta viewport mobile yang hilang.

### 1.5 Standar Kelengkapan Prototipe: 100% Layar Sitemap & Simulasi Multi-Role
Untuk memastikan peninjau dapat mengevaluasi aplikasi secara utuh sebelum masuk ke tahap koding M06:
1. **Cakupan 100% Layar SITEMAP.md**:
   - Setiap rute `SCR-01..SCR-NN` yang ada di `docs/specs/SITEMAP.md` **wajib** dibuatkan file HTML prototipe konkretnya di `docs/design/screens/`.
   - Dilarang hanya membuat 1 halaman dashboard utama lalu membiarkan halaman sekunder lainnya kosong. Seluruh alur aplikasi harus bisa diklik dan dijelajahi.
2. **Pengujian Multi-Role Interaktif (RBAC Testing)**:
   - Pasang `#role-switcher` di navbar prototipe yang membaca dan menyimpan role aktif ke `localStorage` (Guest, User, Staff, Manager, Owner).
   - Gunakan atribut `data-roles="owner,manager"` pada menu sidebar dan tombol aksi agar menu otomatis disaring sesuai role yang sedang aktif.
   - Gunakan atribut `data-role-mask="staff,user,guest"` untuk memverifikasi penyembunyian data sensitif (seperti omzet atau nomor rekening bank) dari pandangan staff atau publik.

---

## 2. Solo Engineer Visual "Anti-Slop" Principles

Mature software design is characterized by **readability and interaction clarity**, not gratuitous graphic ornamentation:

1. **The 60-30-10 Rule for Color**:
   - **60%**: Neutral base color (White `#FFFFFF` / Light Gray `#F4F4F5` for backgrounds and containers).
   - **30%**: High-contrast dark typography (Black `#09090B` / Slate `#334155`).
   - **10%**: Client's primary brand accent color (reserved exclusively for primary action buttons, active links, and focus rings).
2. **Text Contrast Compliance (WCAG 2.1 AA)**:
   - Do not use washed-out gray text on white backgrounds that causes eye fatigue.
   - Regular body text contrast ratio to background must be at least **4.5 : 1**.
   - Large text contrast ratio (headings > 18px bold) must be at least **3.0 : 1**.
3. **Experience Lifesavers: Empty States & Skeleton Loaders**:
   - Never leave a screen completely blank when a new user first signs up.
   - Always provide concise illustrations, guiding copy, and a Call-to-Action button (*"No documents created yet. Click the button below to create your first document."*).
   - Replace generic spinning loading spinners with *Skeleton Loaders* mimicking the card/table layout to eliminate visual jarring (*zero layout shift*).

---

## 3. Client Prototype Walkthrough Protocol

During prototype demo sessions with the **Client's Single PIC**, direct conversations toward functional workflows rather than subjective artistic debates:

### Feedback Steering Tactics:
- **Don't Ask**: *"How does it look? Do you like the colors?"* (This invites wild subjective opinions).
- **The Right Questions**:
  - *"Does this form sequence match your staff's standard operating procedure at the office?"*
  - *"Is the document status on this page clear enough for staff to take their next action?"*

### Handling Subjective Client Comments:
- **Scenario**: *"Could we make the colors pop more, maybe bright red, and make the logo bigger?"*
- **Solo Dev Response**:
  > *"The current palette follows your company's official brand guidelines and passes standard WCAG 2.1 AA accessibility contrast ratios. This is critical to prevent staff eye fatigue during hours of screen work. If you'd like certain actions to stand out more, we can emphasize the primary action buttons without changing the page's neutral foundation."*

---

## 4. Enforcing Design Freeze Protocols

Once the Client's Single PIC approves the prototype workflow in `DESIGN_SPEC.md`:

1. **Lock All Layouts**:
   - Official design status transitions to **FROZEN**.
   - Figma pages or mockup code are designated as the *Approved Baseline*.
2. **Post-Freeze Change Tolerance**:
   - *Free minor revisions*: Text label changes (copywriting), subtle button color tweaks, or minor icon swaps.
   - *Mandatory Change Request (CR)*: Moving database column positions that alter form layouts, adding new pages, overhauling multi-step wizards, or changing navigation architecture.
