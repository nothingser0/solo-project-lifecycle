# Modul 04: UI/UX Design & Prototyping (Google Stitch Universal Engine)

> ⚠️ **MANDATORY: Load references BEFORE executing this module**:
> - `references/solo/SOLO_UIUX_GUIDE.md` (Solo dev UI/UX efficiency guide, Component library selection, WCAG contrast, Prototype walkthrough)
> - `references/pm/PM_USER_TESTING_GUIDE.md` (User testing facilitation, Usability test plan)
> - `references/technical/UI_COMPONENT_ANIMATION_LIBRARY.md` (Animation patterns library)
> - `references/technical/ASSET_MANAGEMENT_GUIDE.md` (Images/SVG/WebP/fonts optimization, Favicon package, Accessibility alt text, Performance budgets)
> - `references/improvements/MODUL_04_IMPROVEMENTS.md` (Output contract: DESIGN.md, DESIGN_SPEC.md, DESIGN_REFERENCES.md; manual workflow; scope-based page inventory)
> - `references/technical/AI_DEVELOPMENT_TOOLS_COMPARISON.md` (AI UI prototyping & coding tools benchmark)
>
> **MANDATORY: Load references BEFORE executing this module**:
> - Read: `references/improvements/MODUL_04_IMPROVEMENTS.md`

Modul ini menerjemahkan `SCOPE_STATEMENT.md` menjadi tiga dokumen yang menjadi source of truth UI: `DESIGN.md`, `docs/specs/DESIGN_SPEC.md`, dan `docs/design/DESIGN_REFERENCES.md`. Fokusnya standardisasi visual, shared components, semua page/sub-page yang memang in-scope, responsive behavior, accessibility, dan acceptance criteria.

> **Workflow default:** jangan pakai Google Stitch. Stitch hanya opsi tambahan jika user memilihnya dan hasilnya lolos review. Deskripsi markdown bukan shortcut; untuk solo developer, spesifikasi yang konsisten lebih berguna daripada prototype AI yang tidak konsisten.

> **Output gate:** Modul 04 tidak menghasilkan kode UI, prompt Stitch, Screen ID, atau prototype live secara default. Kode dibuat di Modul 06 berdasarkan tiga dokumen ini.

---

## 1. Siklus Eksekusi Modul 04

```text
[ INPUT: SCOPE_STATEMENT.md & Kontrak Sah + DP dari Modul 03 ]
                                │
                                ▼
[ LANGKAH 1: Penyusunan Guardrail DESIGN.md (Anti-Slop Token) ]
  • Palet Warna Netral (Zinc/Slate) + 1 Warna Brand Aksen
  • Tipografi Inter & JetBrains Mono, Border Flat 1px, Zero Gradient
                                │
                                ▼
[ LANGKAH 2: Inisiasi Project & Design System di Google Stitch ]
  • Buat Container Project (stitch_create_project)
  • Upload DESIGN.md (stitch_upload_design_md & stitch_create_design_system_from_design_md)
                                │
                                ▼
[ LANGKAH 3: Generasi Layar Berbasis Data Riil (stitch_generate_screen_from_text) ]
  • Generasi Setiap Halaman Utama (Login, Dashboard, Form, Detail)
  • Wajib Menyertakan 5 State: Default, Loading Skeleton, Empty, Error, Success
                                │
                                ▼
[ LANGKAH 4: Integrasi Navigasi & Live Staging Clickable Prototype ]
  • Hubungkan Tautan Antar-Layar (<a href="...">)
  • Deploy Instan ke Live Preview URL (Vercel / Cloudflare Pages / Stitch Viewer)
                                │
                                ▼
[ LANGKAH 5: Sesi Walk-Through & Pembekuan Desain (Design Freeze) ]
  • Demo Interaktif Bersama Single PIC Klien
  • Tanda Tangan Lembar Design Freeze Sign-Off
                                │
                                ▼
[ OUTPUT: 4 ARTEFAK LENGKAP ] ──► Siap Lanjut ke Modul 05: Arsitektur & FSD
```

---

## 2. Deliverables Modul 04

Modul ini menghasilkan deliverable konkret:

| No | Nama Artefak | Format / Lokasi | Deskripsi & Fungsi |
| :---: | :--- | :--- | :--- |
| **1** | **`docs/specs/SITEMAP.md`** | Folder `docs/specs/` | Information Architecture: struktur navigasi, hierarki halaman, route paths (18-50 screens tergantung skala). Prerequisite untuk DESIGN_SYSTEM.md. |
| **2** | **`docs/specs/DESIGN_SYSTEM.md`** | Folder `docs/specs/` | Dokumen gabungan token desain sistem dan spesifikasi antarmuka lengkap (color palette, typography, component specs, matriks 5 state layar per screen). |
| **3** | **`DESIGN.md`** (root) | Root project | Design tokens untuk AI agent consumption saat coding (Modul 06): warna, font, spacing, anti-slop guardrails. |
| **4** | **Interactive Prototype** (Optional) | Live Staging / Stitch Viewer / Figma | Aplikasi antarmuka yang bisa diklik (hanya jika workflow AI/Manual Figma dipilih). Untuk workflow markdown: skip prototype, langsung coding di Modul 06. |
| **5** | **Design Freeze Sign-Off** | Lembar bertandatangan | Berita acara persetujuan tertulis dari Single PIC Klien yang mengunci struktur visual sebelum koding dimulai. |

> 📁 **ATURAN LOKASI BERKAS MUTLAK**:
> - `DESIGN.md` ditaruh di root (`./DESIGN.md`) karena berfungsi sebagai berkas kendali AI saat koding (Modul 06).
> - `DESIGN_SPEC.md` WAJIB ditaruh di **`docs/specs/DESIGN_SPEC.md`**. DILARANG menaruhnya di root direktori.
>
> ⚠️ **PENANGANAN KENDALA TOOL GOOGLE STITCH**:
> Jika pemanggilan tool Stitch (`stitch_create_project` atau `stitch_generate_screen_from_text`) mengalami kegagalan autentikasi atau jaringan:
> - **DILARANG KERAS membuat keputusan sepihak "skip Stitch / implement directly in code"**!
> - Periksa apakah API Key Stitch telah terpasang dengan benar di konfigurasi MCP (`opencode.json` / `STITCH_API_KEY`). Laporkan kendala teknis kepada pengguna untuk memastikan koneksi Stitch pulih, bukan mengambil jalan pintas memotong fase desain.

---

## 2A. SITEMAP.md - Information Architecture

**File**: `docs/specs/SITEMAP.md`

Sitemap mendefinisikan **hierarki halaman, route paths, dan navigation structure** sebelum membuat mockup. Prerequisite wajib untuk DESIGN_SYSTEM.md.

### Template Structure

```markdown
# SITEMAP - Information Architecture
[Nama Proyek]

## Total Screens: [X] screens

---

## PUBLIC PAGES (Unauthenticated)

**Root**: `/`
├── `/login` - User login form
├── `/signup` - Registration form (email + password)
├── `/forgot-password` - Request password reset email
└── `/reset-password?token=xxx` - Reset password with token verification

---

## AUTHENTICATED PAGES

**Dashboard**: `/dashboard` (Landing page after login)

### Documents Module
├── `/documents` - List view (table with filters, search, pagination)
├── `/documents/upload` - Upload new document form
├── `/documents/:id` - Single document detail view
└── `/documents/:id/edit` - Edit document metadata

### Signatures Module (E-signature workflow)
├── `/signatures/pending` - Documents awaiting signature
├── `/signatures/completed` - Signed documents archive
└── `/signatures/:id` - Signature detail & status tracking

### Users Module (Admin only)
├── `/users` - User management list (roles: admin, editor, viewer)
├── `/users/invite` - Invite new user form (email + role selection)
└── `/users/:id` - User profile & permission management

### Settings
├── `/settings/profile` - User profile (name, email, avatar)
├── `/settings/security` - Change password, 2FA setup
└── `/settings/preferences` - UI theme (light/dark), language, notifications

---

## Screen Count by Module

| Module | Screens | Notes |
|--------|---------|-------|
| Public | 4 | Login, signup, forgot/reset password |
| Dashboard | 1 | Main landing after auth |
| Documents | 4 | List, upload, detail, edit |
| Signatures | 3 | Pending, completed, detail |
| Users (Admin) | 3 | List, invite, profile |
| Settings | 3 | Profile, security, preferences |
| **TOTAL** | **18** | MVP scope |

---

## Navigation Structure

**Top Navigation** (Authenticated):
- Logo (left) → `/dashboard`
- Main Nav (center): Documents | Signatures | Users (if admin)
- User Menu (right): Profile | Settings | Logout

**Sidebar Navigation** (Optional - for dashboard-heavy apps):
- Dashboard
- Documents
- Signatures
- Users (admin only)
- Settings
- Help & Support

**Breadcrumbs** (Context awareness):
- Example: Home > Documents > Document #123 > Edit
```

### Contoh Aplikasi Berbeda Skala

**Small (10-15 screens)**: Landing page SaaS
```
Public: /, /login, /signup, /pricing
Authenticated: /dashboard, /settings, /billing
Admin: /admin/users, /admin/reports
```

**Medium (20-30 screens)**: E-commerce
```
Public: /, /products, /product/:id, /cart, /checkout, /login
User: /account, /orders, /orders/:id, /wishlist, /settings
Admin: /admin/products, /admin/orders, /admin/customers, /admin/analytics
```

**Large (50-100+ screens)**: Enterprise SaaS
```
- 10+ modules (CRM, Inventory, Finance, HR, Reports)
- Role-based screens (admin, manager, staff)
- Multi-step workflows (onboarding, approval chains)
```

---

## 2B. Workflow Options: Manual vs AI-Assisted Design

Setelah sitemap selesai, pilih workflow untuk membuat mockup screens:

### Option A: Manual Design (Figma/Adobe XD/Sketch)

**Tools**: Figma, Adobe XD, Sketch

**Workflow**:
1. Buat design system di Figma (components library: buttons, inputs, cards, modals)
2. Design 18 screens satu per satu manually (wireframe → high-fidelity)
3. Export specs (measurements, colors, typography) untuk developer
4. Generate assets (icons, images, logos)
5. Handoff via Figma Dev Mode / Zeplin

**Pros**:
- ✅ Full pixel-perfect control
- ✅ Industry-standard workflow (mudah hire designer nanti)
- ✅ Reusable component library untuk future updates
- ✅ Client familiar dengan Figma (easier feedback loop)

**Cons**:
- ❌ Slow (1-2 minggu untuk 18 screens dengan polishing)
- ❌ Perlu design skills (color theory, typography, spacing)
- ❌ Effort: High (8-10 jam per screen untuk detailed mockup)

**Best For**:
- Client projects dengan high design expectations
- Produk consumer-facing (B2C) yang butuh strong branding
- Budget cukup untuk hire freelance UI designer (Rp 5-10 juta)

**Time Estimate**: 2-3 minggu (solo developer with basic design skills)

---

### Option B: AI-Assisted Design (Google Stitch / v0.dev / Uizard)

**Tools**: Google Stitch (built-in MCP), v0.dev by Vercel, Uizard, Galileo AI

**Workflow**:
1. Write design system tokens di DESIGN.md (colors, typography, spacing)
2. Prompt AI per screen: "Generate dashboard with sidebar nav, document list table, upload button"
3. AI generates mockup + React/HTML code in seconds
4. Iterate: "Make sidebar wider, change primary color to cyan-600, add dark mode"
5. Export React components / Tailwind HTML

**Pros**:
- ✅ Fast (beberapa jam untuk 18 screens dengan iterations)
- ✅ Generate code langsung (skip manual HTML/CSS translation)
- ✅ Easy iteration (re-prompt untuk variants berbeda)
- ✅ Low cost (Google Stitch free tier, v0.dev $20/month)

**Cons**:
- ❌ Generic look jika tidak di-customize (common AI patterns)
- ❌ Less pixel-perfect (spacing/alignment kadang off)
- ❌ Perlu prompt engineering skills (GIGO: garbage in, garbage out)
- ❌ Code quality varies (kadang inline styles, not following conventions)

**Best For**:
- MVP / Internal tools (speed > polish)
- Solo developer tanpa design skills
- Budget tight (tidak hire designer)
- Fast iteration cycle (prototype → test → iterate dalam hours)

**Time Estimate**: 1-3 hari (termasuk prompt iteration & code cleanup)

**Contoh Prompt (Google Stitch)**:
```
Generate Dashboard screen (Screen ID: SCR-02) untuk Legal Document Management:

CONTENT:
- Sidebar navigation (left): Logo, Dashboard, Documents, Signatures, Settings
- Main content area: 
  * Header: "Documents" title, Search bar (placeholder: "Search by title or ID"), "Upload" button (primary)
  * Table: 5 columns (Title, Uploaded By, Date, Status, Actions), 10 rows with pagination
  * Status badges: Draft (gray), Pending (yellow), Signed (green)
  * Actions: View icon, Edit icon, Delete icon

DATA CONTEXT: Indonesian law firm, document titles in Bahasa Indonesia

DESIGN CONSTRAINTS (ANTI-SLOP):
- NO gradients, glassmorphism, colored shadows
- Flat colors: Primary #0891B2 (Cyan-600), Neutrals Zinc-50 to Zinc-950
- Borders: 1px solid #E4E4E7, radius 8px (cards), 6px (buttons)
- Typography: Inter font, weights 400 (body) / 600 (headings), line-height 1.6
- Shadows: 0 1px 3px rgba(0,0,0,0.1) only (no heavy shadows)
- Layout: Sidebar 240px fixed, main content max-w-7xl, padding 24px
- Spacing: Tailwind scale (4/8/16/24/32px)
- Table: Zebra striping (even rows bg-zinc-50), sticky header
```

---

### Option C: Hybrid (Recommended untuk Solo Developer)

**Best of Both Worlds**

**Workflow**:
1. **AI wireframes** (Google Stitch / v0.dev): Generate 18 screens cepat (1 hari)
   - Focus: Layout structure, component placement, navigation flow
   - Accept: 80% quality (not pixel-perfect yet)

2. **Manual polish** di Figma (if needed) (1-2 hari):
   - Export Stitch designs to Figma (via HTML → Figma plugin)
   - Polish: Typography hierarchy, spacing consistency, color refinement
   - Add brand-specific elements (custom icons, illustrations, photography)
   - Create reusable component library dari AI output

3. **Code implementation** (Modul 06):
   - Use Stitch-generated code as starting point (HTML structure, Tailwind classes)
   - Refactor to match codebase patterns (component composition, naming conventions)
   - Replace placeholder data dengan real data from database

**Pros**:
- ✅ 70% faster than full manual (AI handles boilerplate structure)
- ✅ Better quality than pure AI (manual polish untuk brand consistency)
- ✅ Reusable design system (Figma library untuk future updates)
- ✅ Balanced cost (AI free tier + 1-2 hari design time vs 2-3 minggu full manual)

**Cons**:
- ⚠️ Still perlu basic Figma skills untuk polishing
- ⚠️ Two tools overhead (learn both Stitch + Figma)

**Best For**:
- Solo developer dengan limited design skills tapi willing to learn
- Client projects dengan medium design expectations (B2B SaaS)
- Budget tight tapi ada waktu 1-2 hari untuk polish
- Want reusable design system untuk long-term maintenance

**Time Estimate**: 3-5 hari (1 hari AI generation + 1-2 hari manual polish + 1 hari code integration testing)

---

## 2C. Decision Matrix: Pilih Workflow yang Tepat

| Kriteria | Manual Figma | AI-Assisted | Hybrid |
|----------|--------------|-------------|--------|
| **Budget** | Rp 5-10 juta (hire designer) atau 2-3 minggu solo time | Free - Rp 500k/month tools | Rp 0-2 juta (AI tools + freelance polish) |
| **Timeline** | 2-3 minggu | 1-3 hari | 3-5 hari |
| **Design Skill Required** | High (color theory, typography, composition) | Low (prompt engineering) | Medium (basic Figma + AI prompts) |
| **Output Quality** | Highest (pixel-perfect, brand-aligned) | Medium (generic, needs refinement) | High (80-90% of manual quality) |
| **Client Type** | B2C, consumer apps, high design expectations | Internal tools, MVP, technical users | B2B SaaS, medium expectations |
| **Long-term Maintenance** | Best (component library di Figma) | Hardest (re-prompt setiap perubahan) | Good (Figma library + AI iteration) |
| **Code Quality** | N/A (manual translation by dev) | Medium (AI-generated, needs cleanup) | Good (AI base + manual refactoring) |

**Rekomendasi Default untuk Solo Developer**:
- **MVP / Internal tools / Tight deadline**: → **Option B (AI-Assisted)**
- **Client project / Medium budget / 1-2 minggu available**: → **Option C (Hybrid)**
- **High-end product / Strong brand / Budget untuk designer**: → **Option A (Manual Figma)** atau hire freelance designer

---

## 3. Langkah demi Langkah Eksekusi

### Langkah 0A: Generate Logo Design Brief (MANDATORY - Pre-Design Phase)
**WAJIB DIJALANKAN SEBELUM LANGKAH 1** untuk semua proyek (klien atau solo product):

1. **Buat dokumen `LOGO_DESIGN_BRIEF.md`** di `docs/specs/` dengan struktur:
   - Brand Identity (positioning statement, tagline, target user)
   - Brand Personality (tone of voice, mood keywords)
   - Logo Requirements (format SVG, scalability 16px-512px, versatility light/dark)
   - 4 Logo Concept Ideas (Lettermark, Abstract Symbol, Iconographic, Wordmark)
   - Color Palette Recommendation (primary + accent colors dengan hex codes)
   - **4 Ready-to-Use Prompts** untuk AI logo generators:
     - Prompt 1: Lettermark Style (untuk ChatGPT/Claude/Midjourney)
     - Prompt 2: Abstract Symbol Style
     - Prompt 3: Iconographic Style
     - Prompt 4: Wordmark Style
   - Deliverables Checklist (3 variants, color versions, file naming)
   - Style References (SaaS logos: Stripe, Notion, Linear, Vercel)

2. **Inform User Explicitly**:
   > "Logo design brief telah dibuat di `docs/specs/LOGO_DESIGN_BRIEF.md` (Xkb). Silakan generate logo menggunakan salah satu dari 4 prompt yang tersedia (copy-paste ke ChatGPT/Claude/Midjourney/LogoAI). Setelah logo selesai, simpan SVG files ke `/assets/logo/` dan lanjut ke Langkah 0B (SITEMAP.md). **Atau, jika ingin skip logo placeholder dulu, kita bisa lanjut dengan placeholder dan Anda generate logo nanti sebelum launch.**"

3. **Wait for User Decision** (Do NOT proceed automatically):
   - User generates logo now → Wait for logo files, then proceed to Step 0B
   - User wants placeholder → Proceed to Step 0B with placeholder logo note

**Why This is Mandatory**:
- Logo colors inform the primary/accent color palette in `DESIGN.md`
- Logo style (geometric/rounded/modern) informs design system tokens
- Generating brief upfront prevents color/style mismatches later
- User can generate logo asynchronously without blocking Modul 04 progress

**Template**: Use `templates/02-design/LOGO_DESIGN_BRIEF_TEMPLATE.md` (if not exists, create inline using the structure above).

---

### Langkah 0B: Generate SITEMAP.md (MANDATORY - Information Architecture)
**PREREQUISITE untuk semua workflow (Manual, AI, atau Hybrid)**

1. **Read SCOPE_STATEMENT.md** dari Modul 02:
   - Extract semua user stories (As a [role], I want to [action], so that [benefit])
   - Group by module/feature area (Documents, Users, Settings, etc.)
   - Identify public vs authenticated pages
   - Map role-based access (admin-only screens, user screens)

2. **Create `docs/specs/SITEMAP.md`** dengan struktur:
   - **Public Pages**: Root `/`, login, signup, password reset
   - **Authenticated Pages**: Dashboard, main modules, settings
   - **Screen Count by Module**: Table dengan breakdown jumlah screens per module
   - **Navigation Structure**: Top nav, sidebar (if applicable), breadcrumbs

3. **Verify Completeness**:
   ```bash
   # Check file exists
   Test-Path "docs/specs/SITEMAP.md"
   
   # If FALSE: STOP and report error
   # If TRUE: Read file and verify screen count matches scope
   ```

4. **Screen Count Validation**:
   - Count total screens di SITEMAP.md
   - Compare dengan scope dari SCOPE_STATEMENT.md
   - **GATE**: Jika mismatch >10% (missing screens atau out-of-scope screens):
     - Report discrepancy kepada user
     - Ask: "Scope di SITEMAP ada X screens, tapi SCOPE_STATEMENT hanya mention Y user stories. Apakah ada screen yang missing atau out-of-scope?"
     - WAIT for user confirmation sebelum lanjut

5. **Inform User**:
   > "SITEMAP.md telah dibuat di `docs/specs/SITEMAP.md` (Xkb) dengan total [X] screens. Breakdown per module: Public (4), Dashboard (1), Documents (4), Settings (3), Admin (3). Silakan review structure navigasi sebelum lanjut ke workflow selection (Manual Figma / AI-Assisted / Hybrid)."

6. **WAIT for User Approval**:
   > "Apakah struktur sitemap ini sudah benar? Jika ya, pilih workflow:
   > - **A) Manual Figma** (2-3 minggu, pixel-perfect)
   > - **B) AI-Assisted** (1-3 hari, code langsung)
   > - **C) Hybrid** (3-5 hari, AI + manual polish)
   > 
   > Ketik A/B/C untuk melanjutkan, atau request perubahan sitemap."

**Why This is Mandatory**:
- Sitemap = blueprint untuk semua screens (cegah missing pages di design)
- Screen count validation = early detection scope creep
- Navigation structure locked early = consistent UX flow
- Prerequisite untuk estimasi effort (18 screens vs 50 screens = different timeline)

**Template**: Use structure dari Section 2A (SITEMAP.md - Information Architecture)

**Example Terminal Command** (if SITEMAP.md missing):
```powershell
# GATE CHECK - Langkah 0B
if (-not (Test-Path "docs/specs/SITEMAP.md")) {
    Write-Error "LANGKAH 0B FAILED: File docs/specs/SITEMAP.md tidak ditemukan."
    Write-Error "Modul 04 TIDAK BOLEH lanjut ke Langkah 1 tanpa SITEMAP.md."
    Write-Error "Generate SITEMAP.md terlebih dahulu berdasarkan SCOPE_STATEMENT.md."
    exit 1
}

# Verify file not empty
$sitemapContent = Get-Content "docs/specs/SITEMAP.md" -Raw
if ($sitemapContent.Length -lt 500) {
    Write-Error "SITEMAP.md terlalu pendek (<500 chars). Ensure complete screen inventory."
    exit 1
}

Write-Host "✅ LANGKAH 0B PASS: SITEMAP.md verified ($(($sitemapContent.Length)) bytes)"
```

---

### Langkah 1: Merumuskan Guardrail `DESIGN.md` (ANTI-SLOP MANDATORY)
Gunakan template di `templates/02-design/DESIGN_MD_TEMPLATE.md` dengan **STRICT ANTI-SLOP RULES**:

#### 1.1 Color Palette (FLAT COLORS ONLY)
**Primary/Accent (Pick ONE):**
- From logo color palette if available, OR
- Placeholder: `#0891B2` (Cyan-600) for fintech/SaaS, `#3B82F6` (Blue-500) for enterprise B2B
- **FORBIDDEN:** Purple gradients (`#A855F7` → `#EC4899`), neon colors, rainbow palettes

**Neutrals (Zinc Scale):**
- Background Light: `#FFFFFF`
- Background Dark: `#09090B` (Zinc-950) — NOT pure black `#000000`
- Text Primary: `#3F3F46` (Zinc-700) — readable, high contrast (9.73:1 on white)
- Text Secondary: `#71717A` (Zinc-500)
- Border: `#E4E4E7` (Zinc-200)
- **FORBIDDEN:** Gray scale with blue tint (`#CBD5E1` Slate), custom grays outside Tailwind default

**Semantic Colors:**
- Success: `#10B981` (Emerald-500)
- Warning: `#F59E0B` (Amber-500)
- Error: `#EF4444` (Red-500)
- Info: `#3B82F6` (Blue-500)

#### 1.2 Typography (NO EXOTIC FONTS)
**Font Families:**
- UI/Body: **Inter** (weights: 400, 500, 600, 700 ONLY)
- Monospace/Code: **JetBrains Mono** (weights: 400, 700 ONLY)
- **FORBIDDEN:** Fancy display fonts (Recoleta, Clash Display, Syne), handwriting fonts, font weights outside 400-700

**Type Scale:**
- H1: 48px/700, line-height 1.1, letter-spacing -0.02em
- H2: 36px/600, line-height 1.2
- H3: 24px/600, line-height 1.3
- Body: 16px/400, line-height 1.6
- **FORBIDDEN:** Line-height < 1.4 for body text (readability), all-caps body text

#### 1.3 Borders & Radius (SUBTLE ONLY)
**Borders:**
- Width: **1px solid** (default for all cards, inputs, buttons outline)
- **FORBIDDEN:** 2px+ thick borders, dashed/dotted borders, gradient borders

**Border Radius:**
- Cards: 8px (`rounded-lg`)
- Buttons: 6px (`rounded-md`)
- Inputs: 6px (`rounded-md`)
- **FORBIDDEN:** `rounded-3xl` (24px+), `rounded-full` on non-circular elements, asymmetric radius

#### 1.4 Shadows (FLAT > DEPTH)
**Default Shadow (cards, dropdowns):**
```css
box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1); /* Tailwind shadow-sm */
```

**Hover Shadow (interactive elements):**
```css
box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Tailwind shadow-md */
```

**FORBIDDEN:**
- `shadow-2xl` (0 25px 50px) — too dramatic
- Colored shadows (`shadow-cyan-500/50`)
- Multiple layered shadows
- Inner shadows for "neumorphism" effect

#### 1.5 Effects & Animations (MINIMAL)
**Allowed:**
- Hover state: opacity change (0.9), subtle shadow lift
- Focus state: 2px outline in primary color, 3px offset
- Transitions: 200ms ease-out (NO 500ms+ bouncy animations)

**FORBIDDEN:**
- Gradients (linear-gradient, radial-gradient) — use flat colors
- Glassmorphism (`backdrop-blur-lg`, `bg-white/10`)
- Parallax scrolling
- Floating/levitating cards (`transform: translateY(-10px)`)
- Animated gradients (gradient position shift)
- Skeleton loaders with shimmer animation (use static gray blocks)
- Text fade-in per character (Framer Motion stagger)
- 3D transforms (`rotateX`, `rotateY`, `perspective`)

#### 1.6 Layout (GRID > ARBITRARY FLOATING)
**Structure:**
- Container: `max-w-7xl mx-auto px-4` (1280px max, centered)
- Grid: 12-column system (Tailwind `grid-cols-12`)
- Spacing: 4px/8px/16px/24px/32px increments (Tailwind default scale)

**FORBIDDEN:**
- Absolute positioned elements without layout reason (floating badges everywhere)
- Overlapping cards (z-index stacking for visual "depth")
- Asymmetric layouts (random element placement)

#### 1.7 Component Reusability (DRY PRINCIPLE)
**Mandatory Shared Components:**
- Button (Primary, Secondary, Destructive variants)
- Input (Text, Email, Password, Number with consistent styling)
- Card (Container dengan border, radius, shadow standard)
- Table (Zebra stripe rows, sticky header)
- Modal/Dialog (Overlay + centered content)
- Toast/Alert (Success, Warning, Error semantic colors)

**Tech Stack Enforcement:**
- **shadcn/ui** as base (Radix UI primitives for accessibility)
- **NO custom CSS files** (Tailwind utility classes only, config in `tailwind.config.ts`)
- **NO Framer Motion** unless interactive prototype needs demo animations (remove before production)

---

#### 1.8 AI Slop Detection Checklist (MANDATORY REVIEW)

Before finalizing `DESIGN.md`, verify ZERO of these slop indicators exist:

**Visual Slop:**
- [ ] ❌ Purple/pink gradients (`bg-gradient-to-r from-purple-600 to-pink-600`)
- [ ] ❌ Glassmorphism blur (`backdrop-blur-lg bg-white/10`)
- [ ] ❌ Drop shadows > `shadow-md`
- [ ] ❌ Border radius > 12px (except circles/pills)
- [ ] ❌ Colored shadows (`shadow-cyan-500/50`)
- [ ] ❌ Floating cards with `hover:scale-105`
- [ ] ❌ Animated gradient backgrounds

**Code Slop:**
- [ ] ❌ Inline Tailwind classes > 15 per element
- [ ] ❌ Custom `@keyframes` animations for static content
- [ ] ❌ Framer Motion `staggerChildren` for text fade-in
- [ ] ❌ Component abstraction layers > 3 deep (Button → BaseButton → Clickable → Pressable)
- [ ] ❌ CSS variables with `-magic-` or `-epic-` prefixes
- [ ] ❌ Hardcoded pixel values outside Tailwind scale (e.g., `w-[347px]`)

**Content Slop:**
- [ ] ❌ Generic hero headlines ("Unlock Your Potential", "Elevate Your Experience")
- [ ] ❌ Overuse of emoji in UI copy (💥🚀✨ everywhere)
- [ ] ❌ Buzzword density > 10% (synergy, leverage, paradigm, holistic)

---

#### 1.9 Google Stitch Prompt Directive (CRITICAL)

When generating screens via `stitch_generate_screen_from_text`, **ALWAYS include this directive** in the prompt:

```
DESIGN CONSTRAINTS (ANTI-SLOP):
- NO gradients, glassmorphism, or colored shadows
- Flat colors only: Primary [#HEX], Neutrals Zinc-50 to Zinc-950
- Borders: 1px solid #E4E4E7, radius max 8px
- Typography: Inter font, weights 400/600 only, line-height 1.6
- Shadows: subtle 0 1px 3px rgba(0,0,0,0.1) only
- Layout: Grid-based, NO floating/overlapping elements
- Spacing: Tailwind default scale (4/8/16/24/32px)
- Animations: NONE (static screens for prototype)
```

**Example Full Prompt:**
```
Generate Landing Page (Screen ID: SCR-01) for FreePajak tax SaaS:

CONTENT:
- Hero section: Headline "Hitung 3 Skema Pajak. Pilih yang Paling Hemat.", 
  subheadline, CTA "Coba Gratis"
- Problem section: 3 pain points with icons
- How It Works: 3 steps with numbers
- Pricing: 2 tiers (Free, Pro)
- Footer: links, copyright

DATA CONTEXT: Indonesian freelancer tax app, Rupiah currency format

DESIGN CONSTRAINTS (ANTI-SLOP):
- NO gradients, glassmorphism, or colored shadows
- Flat colors: Primary #0891B2 (Cyan-600), Neutrals Zinc-50 to Zinc-950
- Borders: 1px solid #E4E4E7, radius 8px
- Typography: Inter font, weights 400/600, line-height 1.6
- Shadows: 0 1px 3px rgba(0,0,0,0.1) only
- Layout: Grid-based, max-w-7xl container
- Spacing: Tailwind scale (px-4, py-8, gap-6)
```

---

#### 1.10 Post-Generation Review (MANDATORY BEFORE DESIGN FREEZE)

After Stitch generates screens, **MANUALLY REVIEW** each screen for slop:

**Review Checklist (Per Screen):**
1. [ ] Open screen preview in browser DevTools
2. [ ] Inspect CSS: Search for `gradient`, `blur`, `shadow-` (check if > `shadow-md`)
3. [ ] Check colors: Only Primary + Zinc scale (NO purple, pink, rainbow)
4. [ ] Measure border-radius: Max 8px (use DevTools Inspect)
5. [ ] Count Tailwind classes per element: Max 15 (refactor to component if >15)
6. [ ] Test contrast: All text ≥4.5:1 ratio (use WebAIM Contrast Checker)
7. [ ] Verify typography: Only Inter/JetBrains Mono, weights 400-700

**If Slop Detected:**
- Regenerate screen with stricter prompt directive, OR
- Manually edit exported HTML/CSS to remove slop, OR
- Reject screen and document issue for client review

**Approval Gate:**
- Solo product: Self-review checklist above
- Client project: Walk client through checklist, get written approval per screen batch

### Langkah 2: Registrasi ke Google Stitch via Tooling
1. Buat project container baru:
   `stitch_create_project(reason="Inisiasi UI prototype untuk [Nama Proyek]")`
2. Konversikan berkas `DESIGN.md` menjadi base64, lalu upload:
   `stitch_upload_design_md(projectId="...", designMdBase64="...")`
3. Terapkan Design System tersebut ke project:
   `stitch_create_design_system_from_design_md(projectId="...", ...)`

### Langkah 3: Generasi Seluruh Layar (Phased Coverage untuk Enterprise)
Panggil `stitch_generate_screen_from_text` untuk **SETIAP halaman** yang tertera di `SCOPE_STATEMENT.md`:
- **Scale Kecil/Menengah (<50 screens)**: 100% exhaustive coverage dalam satu fase. DILARANG memangkas.
- **Scale Besar/Enterprise (≥50 screens)**: Phased approach untuk mencegah context exhaustion:
  - **Phase 1 (MVP Screens)**: Core user flows (login, dashboard, primary CRUD, checkout) — max 30-40 screens
  - **Phase 2 (Admin/Secondary)**: Admin panels, reports, settings — remaining screens
  - Document phasing plan in `DESIGN_SPEC.md` before starting.
- Sertakan konteks data bisnis nyata Indonesia (format rupiah, istilah hukum/bisnis, nama kota).
- Wajib meminta state defensif: minta layar *Empty State* dan *Loading Skeleton*.
- Catat `screen_id` dari **setiap layar** yang berhasil di-generate ke dalam tabel inventaris di `DESIGN_SPEC.md`.

### Langkah 4: Merakit Clickable Demo Lengkap
1. Ambil kode HTML/CSS komponen dari Stitch untuk seluruh layar.
2. Pasang tag hyperlink routing standar untuk menghubungkan alur tombol:
   - Tombol "Login" → mengarahkan ke `/dashboard`
   - Tombol "Buat Dokumen Baru" → mengarahkan ke `/documents/new`
   - Tombol "Simpan Draf" → menampilkan modal/toast sukses dan mengarahkan ke `/documents/:id`
3. Deploy kode ke staging URL gratis (Vercel / Cloudflare Pages) agar dapat dibuka langsung oleh klien di HP maupun laptop untuk menguji alur utuh 100%.

### Langkah 5: Walk-Through & Pembekuan Desain (Design Freeze)
1. Jadwalkan demo bersama **Single PIC Klien** (atau self-review untuk solo product).
2. Biarkan klien mencoba mengklik dan mengetik form di live demo untuk seluruh layar.
3. Kunci persetujuan tertulis: *Tata letak visual dan alur navigasi resmi DIBEKUKAN (FROZEN). Perubahan layout di kemudian hari masuk skema Change Request (CR).*

---

## 4. Adaptasi Berdasarkan Skala Proyek

| Parameter | Skala Kecil (MVP / Freelance) | Skala Menengah (B2B SaaS / Agensi) | Skala Besar & Enterprise |
| :--- | :--- | :--- | :--- |
| **Cakupan Layar** | **100% seluruh halaman** dalam Scope (tanpa pengurangan) | **100% seluruh halaman** dalam Scope (tanpa pengurangan) | **Phased if ≥50 screens**: Phase 1 (MVP core), Phase 2 (admin/secondary) |
| **Media Demo** | Tautan Viewer Stitch / Live Preview | Live Staging Web (Vercel/Cloudflare) | Live Staging Web + Dokumen Audit Aksesibilitas |
| **Kepatuhan Desain** | Kontras visual standar ≥4.5:1 | WCAG AA terverifikasi pada form | Full WCAG AA audit (Keyboard nav, Screen reader) |
| **Approval** | Konfirmasi tertulis email/chat | Tanda tangan lembar Design Freeze | Formal Design Sign-Off & Berita Acara Review UI |

---

## 5. User Testing & Iterative Validation

Setelah prototipe interaktif Stitch selesai, **WAJIB** melakukan user testing sebelum design freeze final. Skip fase ini hanya menggeser masalah usability ke post-launch (5x lebih mahal diperbaiki).

### 5.1 User Testing Plan (Template: `templates/02-design/USABILITY_TEST_PLAN_TEMPLATE.md`)

**Untuk setiap iterasi:**
- **Test Objectives**: Validasi 3-5 user journey kritis (contoh: "User baru dapat menyelesaikan onboarding dalam <5 menit tanpa bantuan")
- **Participant Recruitment**: Minimum **5 pengguna per iterasi** (Nielsen Norman standard untuk mengungkap 85% masalah usability)
- **Screening Criteria**: Target demografi sesuai persona (contoh: "Admin HR perusahaan 50-500 karyawan, akrab Excel")
- **Incentive Structure**: Voucher e-commerce Rp 100-200k/sesi (30-45 menit), atau product credit untuk B2B SaaS

### 5.2 Usability Testing Protocol

**Task Scenarios** (Representative User Journeys):
- Tulis 5-7 skenario realistis tanpa petunjuk navigasi (contoh: "Bayangkan hari pertama Anda bekerja. Buatlah akun dan tambahkan 3 karyawan baru ke sistem.")
- Hindari kata kunci UI ("klik tombol Login") → gunakan intent ("masuk ke akun Anda")

**Think-Aloud Protocol**:
- Minta peserta mendeskripsikan pikiran mereka saat mengerjakan task
- Moderator TIDAK boleh memberi petunjuk, hanya prompt: "Apa yang Anda pikirkan saat ini?"

**Observation Checklist**:
- Task completion rate (berhasil/gagal)
- Time on task (bandingkan dengan baseline target)
- Error rate dan recovery path
- Verbatim quotes untuk pain points

**Post-Test Questionnaire** (SUS - System Usability Scale):
- 10 pertanyaan standar, skala Likert 1-5
- Skor 0-100 (dihitung dengan formula SUS)
- Template: `templates/02-design/USABILITY_TEST_PLAN_TEMPLATE.md`

### 5.3 Iteration Cycle (Mandatory Loop)

```text
[ Prototype v1 ] → [ Test (5 users) ] → [ Analyze SUS + Pain Points ] → [ Iterate Design ]
       ↑                                                                        │
       └────────────────────────────────────────────────────────────────────────┘
       (Min 2 Iterations)
```

**Success Criteria** (Industry Standard - Sauro & Lewis):
- **SUS Score ≥70**: Acceptable (C grade) — Minimum untuk lanjut ke development
- **SUS Score ≥80**: Good (B grade) — Target untuk produk kompetitif
- **SUS Score ≥90**: Excellent (A grade) — World-class UX

**Minimum 2 Iterasi** sebelum design freeze:
- Iterasi 1: Uncovering major blockers (navigation confusion, missing features)
- Iterasi 2: Refinement (labeling, visual hierarchy, micro-interactions)

> ⚠️ **GATE RULE**: SUS Score <70 pada iterasi ke-2 → WAJIB iterasi ke-3 sebelum lanjut Modul 05.

### 5.4 A/B Testing Hypothesis (Template: `templates/02-design/AB_TEST_HYPOTHESIS_TEMPLATE.md`)

Gunakan untuk menguji alternatif desain yang kontroversial (contoh: layout dashboard, CTA wording).

**Hypothesis Format** (Measurable & Falsifiable):
```
We believe [CHANGE X]
will result in [OUTCOME Y]
We will measure [METRIC Z]
We will know we're right when [SUCCESS CRITERIA]
```

**Contoh**:
```
We believe moving "Export Report" button from dropdown menu to primary toolbar
will result in 30% increase in report export usage
We will measure click-through rate on Export button
We will know we're right when CTR ≥15% (baseline: 11.5%) after 2 weeks with 500+ sessions
```

**Sample Size Calculation**:
- Gunakan kalkulator online (Optimizely, VWO) dengan input: baseline conversion rate, minimum detectable effect (MDE), statistical power (80%), significance (α=0.05)
- Typical B2B SaaS: 200-500 users per variant untuk MDE 20%

**Test Duration**: Minimum 1 full business cycle (B2B: 1-2 minggu, e-commerce: 3-7 hari)

### 5.5 Accessibility Audit (WCAG 2.1 Level AA Compliance)

**Pre-Development Checklist** (Lakukan di Prototipe Stitch):
- [ ] **Contrast Ratio**: Text ≥4.5:1, Large text ≥3:1 (gunakan WebAIM Contrast Checker)
- [ ] **Keyboard Navigation**: Semua interaksi dapat dilakukan tanpa mouse (Tab, Enter, Esc, Arrow keys)
- [ ] **Focus Indicators**: Visible focus state pada semua elemen interaktif (outline 2px solid)
- [ ] **Screen Reader Testing**: Test dengan NVDA (Windows) atau VoiceOver (Mac) untuk 3 critical paths
- [ ] **Form Labels**: Semua input field memiliki `<label>` atau `aria-label`
- [ ] **Error Messages**: Deskriptif dan programmatically associated dengan field (`aria-describedby`)

**Tools**:
- Chrome Lighthouse Accessibility Audit (target score ≥90)
- axe DevTools browser extension (zero critical/serious issues)

> 📖 **Reference Guide**: `references/pm/PM_USER_TESTING_GUIDE.md` — Best practices, common pitfalls, dan case study iterative testing.

### 5.6 Testing Tools Integration

| Tool | Use Case | Pricing Tier untuk Solo/Small Team |
| :--- | :--- | :--- |
| **UserTesting.com** | Remote moderated/unmoderated testing | $49/video (pay-as-you-go) |
| **Maze** | Unmoderated prototype testing + heatmaps | Free tier: 1 project, 50 responses/month |
| **Hotjar** | Session recordings, heatmaps, surveys (post-launch) | Free tier: 35 sessions/day |
| **Typeform** | Post-test SUS questionnaires | Free tier: 10 questions, 100 responses/month |
| **Optimal Workshop** | Card sorting, tree testing (IA validation) | Free tier: 1 study, 10 participants |

**Rekomendasi Stack untuk Budget Terbatas**:
- **Pre-Launch**: Maze (prototype testing) + Google Forms (SUS questionnaire) + Manual screen reader testing
- **Post-Launch**: Hotjar (behavior analytics) + Typeform (NPS/feedback)

---

## 6. Kriteria Kelulusan [GATE] (Gate Exit Criteria)

[GATE] Modul 04 dinyatakan **LOLOS (PASS)** jika:

### Mandatory Files Verification (BLOCKING):
- [x] **`docs/specs/LOGO_DESIGN_BRIEF.md` exists** (≥500 bytes, contains 4 prompts)
- [x] **`docs/specs/SITEMAP.md` exists** (≥500 bytes, contains screen count table)
- [x] **`DESIGN.md` exists** (root, ≥1000 bytes, contains color palette + typography)
- [x] **`docs/specs/DESIGN_SYSTEM.md` exists** (≥2000 bytes, contains screen specs)
- [x] **Screen count match**: SITEMAP.md total = DESIGN_SYSTEM.md screen inventory (±10% tolerance)

### Design Quality (BLOCKING):
- [x] **Anti-slop compliance**: Zero gradients, zero glassmorphism, shadows ≤4px blur
- [x] **Contrast ratio ≥4.5:1** for all text (WCAG AA)
- [x] **Accessibility audit**: Zero critical issues (Lighthouse ≥90 or manual WCAG checklist)

### User Testing (OPTIONAL for MVP, MANDATORY for Client Projects):
- [x] **Minimum 2 iterasi user testing** dengan 5+ pengguna per iterasi (if client project)
- [x] **SUS Score ≥70** (Acceptable) pada iterasi terakhir (if user testing conducted)

### Design Freeze Sign-Off (BLOCKING):
- [x] **Design Freeze approval** embedded in DESIGN_SYSTEM.md dengan:
  - Approver name (Client PIC atau solo developer self-approval)
  - Approval date (YYYY-MM-DD)
  - Signature placeholder (digital signature atau statement: "Approved via [email/chat]")

### Optional (Workflow-Dependent):
- [ ] Interactive prototype URL accessible (if AI-Assisted/Hybrid workflow with live demo)
- [ ] Figma project link (if Manual Figma workflow)
- [ ] Exported assets di `/assets/design/` (if manual mockups)

---

## 🛑 PROTOKOL [GATE] KELUAR & WAJIB BERHENTI

**LANGKAH 0: Tentukan Workflow** (Manual/AI/Hybrid) → User pilih A/B/C sebelum file generation

**LANGKAH 1: File Existence Verification (MANDATORY - Run BEFORE declaring complete)**

```powershell
# GATE CHECK - Module 04 File Verification
# Run this PowerShell script to verify all mandatory files exist

$requiredFiles = @(
    @{Path="docs/specs/LOGO_DESIGN_BRIEF.md"; MinSize=500},
    @{Path="docs/specs/SITEMAP.md"; MinSize=500},
    @{Path="DESIGN.md"; MinSize=1000},
    @{Path="docs/specs/DESIGN_SYSTEM.md"; MinSize=2000}
)

$allPassed = $true

foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file.Path)) {
        Write-Error "❌ GATE FAILED: File $($file.Path) tidak ditemukan."
        $allPassed = $false
    } else {
        $size = (Get-Item $file.Path).Length
        if ($size -lt $file.MinSize) {
            Write-Error "❌ GATE FAILED: File $($file.Path) terlalu kecil ($size bytes < $($file.MinSize) bytes minimum)."
            $allPassed = $false
        } else {
            Write-Host "✅ $($file.Path) verified ($size bytes)"
        }
    }
}

if (-not $allPassed) {
    Write-Error "`n🛑 MODULE 04 GATE FAILED: Missing atau incomplete files. TIDAK BOLEH lanjut ke Module 05."
    exit 1
}

Write-Host "`n✅ MODULE 04 FILE VERIFICATION PASSED - All mandatory files exist."
```

**LANGKAH 2: Content Verification (MANDATORY)**

Agent wajib execute checks berikut SEBELUM declare Module 04 complete:

```python
# Pseudo-code untuk agent verification
def verify_module_04():
    # 1. Read SITEMAP.md and count screens
    sitemap = read_file("docs/specs/SITEMAP.md")
    sitemap_screen_count = extract_screen_count(sitemap)  # Parse "Total Screens: X"
    
    # 2. Read DESIGN_SYSTEM.md and count screen specs
    design_spec = read_file("docs/specs/DESIGN_SYSTEM.md")
    spec_screen_count = count_screen_sections(design_spec)  # Count "## Screen: ..." sections
    
    # 3. Verify match (±10% tolerance)
    if abs(sitemap_screen_count - spec_screen_count) > (sitemap_screen_count * 0.1):
        raise GateError(f"Screen count mismatch: SITEMAP ({sitemap_screen_count}) vs DESIGN_SYSTEM ({spec_screen_count})")
    
    # 4. Verify DESIGN.md contains required sections
    design_md = read_file("DESIGN.md")
    required_sections = ["Color Palette", "Typography", "Spacing", "Components"]
    for section in required_sections:
        if section not in design_md:
            raise GateError(f"DESIGN.md missing section: {section}")
    
    # 5. Verify Design Freeze Sign-Off exists
    if "Approved by:" not in design_spec or "Date:" not in design_spec:
        raise GateError("Design Freeze Sign-Off missing in DESIGN_SYSTEM.md")
    
    # 6. Anti-slop check (search for violations)
    violations = []
    if "gradient" in design_md.lower() or "linear-gradient" in design_md.lower():
        violations.append("Gradient detected in DESIGN.md")
    if "backdrop-blur" in design_md.lower() or "glassmorphism" in design_md.lower():
        violations.append("Glassmorphism detected")
    if "shadow-2xl" in design_md or "shadow-xl" in design_md:
        violations.append("Excessive shadow detected (>shadow-md)")
    
    if violations:
        raise GateError(f"Anti-slop violations: {', '.join(violations)}")
    
    return True
```

**LANGKAH 3: Report Summary kepada User**

Setelah semua checks passed, tampilkan ringkasan:

```
✅ MODULE 04 COMPLETE - Design Deliverables Ready

Files Generated:
- ✅ LOGO_DESIGN_BRIEF.md (11.2KB) - 4 AI prompts ready
- ✅ SITEMAP.md (6.8KB) - 18 screens mapped
- ✅ DESIGN.md (12.4KB) - Design tokens defined
- ✅ DESIGN_SYSTEM.md (34.7KB) - Screen specs complete

Quality Checks:
- ✅ Screen count match: SITEMAP (18) = DESIGN_SYSTEM (18)
- ✅ Anti-slop compliance: 0 violations
- ✅ Accessibility: Contrast ratio ≥4.5:1 verified
- ✅ Design Freeze: Approved by [Name] on [Date]

[Optional - If prototype exists]
- ✅ Interactive Prototype: [URL or Figma link]

---

Next Steps:
1. User review all 4 files (spot-check content accuracy)
2. If corrections needed: Request changes now (before Module 05)
3. If approved: Confirm "Design Freeze approved, lanjut Module 05"

⚠️ WAITING FOR USER CONFIRMATION - Do NOT proceed to Module 05 automatically.
```

**LANGKAH 4: STOP & Wait for User Approval**

**DILARANG KERAS** melanjutkan ke Module 05 dalam turn yang sama. Agent harus:
1. **END TURN** setelah display summary
2. **WAIT** for explicit user approval: "Design approved" atau "Lanjut Module 05"
3. Only proceed after user confirmation received

**Jika user request changes**:
- Re-generate affected file(s)
- Re-run GATE verification
- Display updated summary
- Wait for approval again

**Jika user approve**:
- Proceed to Module 05 (Architecture & FSD)
- Carry forward DESIGN.md + DESIGN_SYSTEM.md sebagai reference untuk tech specs

---

> **AUTHORITATIVE WORKFLOW OVERRIDE**
>
> Sections below that describe mandatory Google Stitch, Stitch Screen IDs, Stitch prompts, Stitch export, or Stitch MCP are legacy optional guidance. They do not apply to the default Modul 04 workflow. Follow `references/improvements/MODUL_04_IMPROVEMENTS.md`: produce only `DESIGN.md`, `docs/specs/DESIGN_SPEC.md`, and `docs/design/DESIGN_REFERENCES.md`. Do not create Stitch prompts, Screen IDs, exports, or live prototypes unless the user explicitly requests Stitch.

## 7. Workflow Split: Planning (Hermes) vs Development (PC with MCP Stitch)

**Use Case**: User melakukan planning/PM/design specification di Hermes (chat AI), lalu eksekusi UI generation & development di PC lokal dengan MCP Stitch.

### 7.1 Phase A: Planning & Design Specification (Hermes)

**Deliverables yang dibuat di Hermes**:

1. ✅ **`docs/specs/LOGO_DESIGN_BRIEF.md`** (~11KB)
   - 4 AI prompts untuk generate logo (ChatGPT/Claude/Midjourney)
   - Color palette recommendation (primary + accent hex codes)
   - Style references (SaaS logos: Stripe, Notion, Linear)

2. ✅ **`DESIGN.md`** (root project, ~8-15KB)
   - Color palette (primary, background, text, border dengan hex codes)
   - Typography (font families, weights, line heights, letter-spacing)
   - Component inventory (buttons, cards, forms, tables, modals)
   - **Anti-slop guardrails** (NO gradients, NO glassmorphism, shadow max 4px, contrast ≥4.5:1)
   - Design tokens (spacing 4px grid, border radius 6-8px, border width 1px)

3. ✅ **`docs/specs/DESIGN_SPEC.md`** (~20-40KB)
   - Sitemap (10-15 pages with routes)
   - Screen ID per page (SCR-001, SCR-002, SCR-003, ...)
   - Section breakdown per screen (header + hero + cards + table + footer)
   - 5-state matrix per screen (Default, Loading, Empty, Error, Success)
   - Wireframe ASCII (optional text-based layout sketch)
   - Component specs (size, spacing, interaction states)

4. ✅ **`data/regulations/*.json`** (jika ada data assets, contoh FreePajak)
   - `pph21-rates.json` (tax brackets dengan version, source, effective date)
   - `ptkp-values.json` (tax-free allowance categories)
   - `pph23-rates.json`, `pp20-2026.json`, dll
   - Metadata: version, source URL, last_updated, changelog

5. ✅ **Google Stitch Prompt Files** (optional — pre-write prompts untuk setiap screen)
   - `stitch-prompts/01-landing-page.txt` (10-20 baris: layout + style strict + components)
   - `stitch-prompts/02-dashboard.txt`
   - `stitch-prompts/03-calculation-form.txt`
   - Format: Layout sections, Style (STRICT anti-slop), Components list, References

**How to Export from Hermes to PC**:

```bash
# User action (di chat Hermes):
# 1. Request: "Export semua deliverables Modul 04 ke satu archive"
# 2. Hermes akan create tar.gz di /opt/data/workspace/ atau /opt/data/home/project/[name]/
# 3. User download via file browser atau scp/rsync

# Example terminal command (Hermes executes):
cd /opt/data/home/project/freepajak
tar -czf ../freepajak-design-export-$(date +%Y%m%d).tar.gz \
  DESIGN.md \
  docs/specs/LOGO_DESIGN_BRIEF.md \
  docs/specs/DESIGN_SPEC.md \
  data/regulations/*.json \
  stitch-prompts/*.txt

# Output: /opt/data/home/project/freepajak-design-export-20260929.tar.gz
# User downloads this file to PC
```

**Folder structure dalam archive**:
```
freepajak-design-export/
├── DESIGN.md                              # Root design system tokens
├── docs/
│   └── specs/
│       ├── LOGO_DESIGN_BRIEF.md           # Logo generation prompts
│       └── DESIGN_SPEC.md                 # Screen breakdown + sitemap
├── data/
│   └── regulations/
│       ├── pph21-rates.json               # Tax data assets
│       └── ptkp-values.json
└── stitch-prompts/                        # Optional pre-written prompts
    ├── 01-landing-page.txt
    ├── 02-dashboard.txt
    ├── 03-calculation-form.txt
    └── ...
```

---

### 7.2 Phase B: UI Generation & Development (PC with MCP Stitch)

**User bekerja di PC lokal dengan tools**:
- **MCP Server**: `mcp-server-google-stitch` (built-in di Claude Desktop/Codex/OpenCode/Windsurf)
- **Code editor**: VS Code / Cursor / Windsurf
- **AI coding agent**: Claude Desktop, Codex CLI, OpenCode CLI (dengan MCP Stitch enabled)
- **Framework**: Next.js 15, Tailwind CSS, shadcn/ui

**Workflow di PC**:

#### Step 1: Extract Deliverables
```bash
# Di PC
cd ~/projects/freepajak
tar -xzf ~/Downloads/freepajak-design-export-20260929.tar.gz
ls -lh  # Verify DESIGN.md, docs/, data/, stitch-prompts/ extracted
```

#### Step 2: Setup MCP Stitch (jika belum configured)

**Option A: Claude Desktop** (`~/Library/Application Support/Claude/claude_desktop_config.json` on Mac):
```json
{
  "mcpServers": {
    "google-stitch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-google-stitch"],
      "env": {
        "STITCH_API_KEY": "your-google-stitch-api-key-here"
      }
    }
  }
}
```

**Option B: Environment Variable** (jika MCP built-in):
```bash
# Add to ~/.bashrc or ~/.zshrc
export STITCH_API_KEY="your-google-stitch-api-key-here"
```

**Get Stitch API Key**:
- Visit https://stitch.withgoogle.com
- Sign in with Google account
- Go to Settings → API Keys → Generate New Key
- Copy key (starts with `sk-stitch-...`)

#### Step 3: Generate UI Screens via MCP Stitch (Autonomous AI Agent)

**User prompt to Claude Desktop / Codex / OpenCode**:
```
Read DESIGN.md and docs/specs/DESIGN_SPEC.md from this project, then generate all 10 screens using Google Stitch MCP.

Project context:
- App: FreePajak (tax calculator for Indonesian freelancers)
- Framework: Next.js 15 + Tailwind CSS + TypeScript
- Design style: Minimalist, flat colors, NO gradients, NO glassmorphism

For each screen in DESIGN_SPEC.md (SCR-001 to SCR-010):
1. Read the corresponding prompt file from stitch-prompts/[screen].txt
2. Call stitch_generate_screen_from_text with:
   - prompt: content from .txt file
   - screen_id: from DESIGN_SPEC.md (e.g., "SCR-001")
   - design_system: color palette + typography from DESIGN.md
3. Verify output compliance with DESIGN.md anti-slop rules:
   - NO gradients (background must be solid colors only)
   - Shadow blur max 4px (check box-shadow values)
   - Contrast ratio ≥4.5:1 (text on background)
   - Border radius ≤8px (cards), ≤6px (buttons)
4. Export code to Next.js structure:
   - /app/(routes)/[route-name]/page.tsx
   - Tailwind classes only (no inline styles)
   - shadcn/ui components where applicable
5. Update DESIGN_SPEC.md with Stitch URL per screen

After all screens generated:
- Create interactive prototype links (stitch_link_screens)
- Generate accessibility report (WCAG AA compliance)
- Save summary to design-freeze-report.md

Proceed autonomously and report progress every 3 screens.
```

#### Step 4: AI Agent Execution Flow (Autonomous via MCP)

**What the AI agent does** (no user intervention needed):

1. **Read specifications**:
   - `read_file('DESIGN.md')` → Extract color palette (`#0891B2`, `#FFFFFF`, `#18181B`), typography (`Inter`, `600 semibold`)
   - `read_file('docs/specs/DESIGN_SPEC.md')` → Extract screen list (10 screens: SCR-001 to SCR-010, routes `/`, `/dashboard`, `/calculations`, etc.)
   - `read_file('stitch-prompts/01-landing-page.txt')` → Get prompt text for first screen

2. **Generate screen 1** (Landing Page):
   ```javascript
   // MCP tool call
   stitch_generate_screen_from_text({
     prompt: `Landing page for FreePajak tax calculator.
     
     Layout:
     - Header: Logo (left), Nav (center), CTA button (right)
     - Hero: H1 "Hitung Pajak Freelancer 3 Skema", subheading, CTA
     - Features: 3 cards (icons + title + description)
     - Footer: Links + copyright
     
     Style (STRICT):
     - Primary color: #0891B2
     - Background: #FFFFFF
     - Text: #18181B (headings), #52525B (body)
     - NO gradients, flat colors only
     - Shadow: max 0 4px 6px rgba(0,0,0,0.1)
     - Border: 1px solid #E4E4E7
     - Font: Inter (600 semibold headings, 400 body)`,
     
     screen_id: "SCR-001",
     design_system: {
       colors: { primary: "#0891B2", background: "#FFFFFF", text: "#18181B" },
       fonts: { body: "Inter", headings: "Inter" }
     }
   })
   ```

3. **Verify anti-slop compliance**:
   ```javascript
   // Agent checks generated code
   const code = stitch_export_code({ screen_id: "SCR-001", format: "nextjs-tailwind" });
   
   // Check for violations
   const hasGradient = code.includes('bg-gradient') || code.includes('linear-gradient');
   const hasShadowLarge = /shadow-\[(.*?)\]/.test(code) && /* blur > 4px */;
   
   if (hasGradient || hasShadowLarge) {
     // Regenerate with stricter prompt
     stitch_regenerate_screen({
       screen_id: "SCR-001",
       prompt: "... (add more explicit NO GRADIENT rule)"
     });
   }
   ```

4. **Export code to Next.js**:
   ```bash
   # Agent writes file
   # File: /app/(marketing)/page.tsx
   export default function LandingPage() {
     return (
       <div className="min-h-screen bg-white">
         <header className="border-b border-zinc-200">
           <div className="container mx-auto px-4 py-4 flex items-center justify-between">
             <img src="/logo.svg" alt="FreePajak" className="h-8" />
             <nav className="flex gap-6">
               <a href="#features" className="text-zinc-600 hover:text-zinc-900">Features</a>
               <a href="#pricing" className="text-zinc-600 hover:text-zinc-900">Pricing</a>
             </nav>
             <button className="bg-cyan-600 hover:bg-cyan-700 text-white px-4 py-2 rounded-md font-semibold">
               Mulai Gratis
             </button>
           </div>
         </header>
         
         <main>
           <section className="container mx-auto px-4 py-20 text-center">
             <h1 className="text-5xl font-bold text-zinc-900">
               Hitung Pajak Freelancer 3 Skema
             </h1>
             <p className="text-xl text-zinc-600 mt-4">
               PPh 21 Pegawai, Bukan Pegawai, dan PP 23 — bandingkan, hemat jutaan
             </p>
             <button className="mt-8 bg-cyan-600 hover:bg-cyan-700 text-white px-8 py-4 rounded-lg font-semibold text-lg">
               Coba Kalkulator Gratis
             </button>
           </section>
           
           {/* Features section */}
           {/* ... */}
         </main>
       </div>
     );
   }
   ```

5. **Update DESIGN_SPEC.md**:
   ```markdown
   ## Screen: Landing Page (SCR-001)
   
   **Route**: `/`
   **Status**: ✅ Generated
   **Stitch URL**: https://stitch.withgoogle.com/p/abc123/s/001
   **Generated**: 2026-09-29
   **Anti-Slop Compliance**: ✅ Pass (0 gradients, 0 violations)
   ```

6. **Repeat for screens 2-10** (Dashboard, Calculation Form, Result Comparison, History, Settings, etc.)

7. **Generate interactive prototype**:
   ```javascript
   // Link screens together
   stitch_link_screens({
     links: [
       { from: "SCR-001", to: "SCR-002", trigger: "button[Mulai Gratis]" },
       { from: "SCR-002", to: "SCR-003", trigger: "card[PPh 21 Pegawai]" },
       // ...
     ]
   });
   
   // Get preview URL
   const prototypeURL = stitch_get_prototype_url({ project_id: "abc123" });
   // Returns: https://stitch.withgoogle.com/p/abc123/preview
   ```

8. **Generate Design Freeze Report**:
   ```markdown
   # Design Freeze Report — FreePajak
   
   **Date**: 2026-09-29
   **Project**: FreePajak Tax Calculator
   **Screens Generated**: 10/10 (100%)
   
   ## Screen Inventory
   
   | Screen ID | Route | Status | Stitch URL | Compliance |
   |-----------|-------|--------|------------|------------|
   | SCR-001 | / | ✅ Approved | [Link](https://stitch.../001) | ✅ Pass |
   | SCR-002 | /dashboard | ✅ Approved | [Link](https://stitch.../002) | ✅ Pass |
   | SCR-003 | /calculations | ✅ Approved | [Link](https://stitch.../003) | ✅ Pass |
   | ... | ... | ... | ... | ... |
   
   ## Anti-Slop Compliance Summary
   
   - ✅ 0 gradients detected (target: 0)
   - ✅ 0 glassmorphism effects (target: 0)
   - ✅ All shadows ≤4px blur (target: ≤4px)
   - ✅ Contrast ratio ≥4.5:1 on all text (WCAG AA pass)
   - ✅ Border radius ≤8px (cards), ≤6px (buttons)
   
   ## Interactive Prototype
   
   **Preview URL**: https://stitch.withgoogle.com/p/abc123/preview
   **Status**: Ready for user testing
   
   ## Next Steps
   
   1. User review prototype (test all 10 screens, check navigation flow)
   2. Accessibility audit (Lighthouse, WAVE, screen reader test)
   3. Design Freeze Sign-Off
   4. Proceed to Modul 05 (System Design & Infrastructure)
   
   ---
   
   **Approved by**: [User Name]
   **Date**: ___________
   **Signature**: ___________
   ```

#### Step 5: User Reviews Output di PC

```bash
# Start Next.js dev server
cd ~/projects/freepajak
npm install
npm run dev

# Open browser
open http://localhost:3000
```

**Review checklist**:
- ✅ Visual matches DESIGN.md (colors, typography, spacing)
- ✅ All 10 screens accessible via navigation
- ✅ Interactive prototype works (buttons clickable, forms submittable)
- ✅ No AI slop (gradients, glassmorphism, excessive shadows)
- ✅ Responsive (mobile 375px, tablet 768px, desktop 1440px)
- ✅ Accessibility (keyboard nav, alt text, ARIA labels)

**Run Lighthouse audit**:
```bash
# Chrome DevTools → Lighthouse → Run audit
# Target scores:
# - Performance: ≥90
# - Accessibility: ≥90
# - Best Practices: ≥90
# - SEO: ≥90
```

#### Step 6: Iterate if Needed

**If violations detected**:
```
User to AI agent:
"Screen SCR-002 (Dashboard) has gradient background in hero section, regenerate with strict flat colors only. Reference DESIGN.md anti-slop rules."

AI agent:
[reads DESIGN.md anti-slop section]
[calls stitch_regenerate_screen with updated prompt]
[verifies new output, exports code]
[reports: "SCR-002 regenerated, gradient removed, compliance verified"]
```

---

### 7.3 Deliverables Handoff Back to Hermes (Optional Documentation)

**If user wants to document final state in Hermes for archival**:

```bash
# Di PC, create summary untuk upload ke Hermes
cd ~/projects/freepajak
cat > design-freeze-summary.txt <<EOF
FreePajak Design Freeze Summary

Date: 2026-09-29
Screens: 10/10 generated
Anti-Slop Compliance: 100% (0 violations)
Prototype URL: https://stitch.withgoogle.com/p/abc123/preview
Lighthouse Scores: Performance 92, Accessibility 95, Best Practices 90, SEO 94

Design Freeze Approved: Yes
Approver: [User Name]
Date: 2026-09-29

Ready to proceed to Modul 05 (System Design & Infrastructure).
EOF

# User pastes this summary ke Hermes chat
```

**Hermes agent actions**:
- Update project tracking (mark Modul 04 complete)
- Archive design freeze report ke `/opt/data/home/project/freepajak/docs/specs/design-freeze-report.md`
- Suggest next steps: "Modul 04 complete. Lanjut ke Modul 05 (System Design & Infrastructure) untuk define database schema, API endpoints, dan tech stack detail?"

---

### 7.4 Summary: Workflow Split Best Practices

| Phase | Location | Tools | Primary Output | Duration |
|-------|----------|-------|----------------|----------|
| **Planning & Spec** | Hermes (chat AI) | web_search, write_file, patch, skill_view | DESIGN.md, DESIGN_SPEC.md, JSON data, Stitch prompts | 4-6 hours |
| **UI Generation** | PC + MCP Stitch | Claude Desktop/Codex/OpenCode + MCP | 10 screens (Next.js code), interactive prototype | 3-5 hours |
| **Review & Iterate** | PC | Browser, Lighthouse, WAVE | Anti-slop verification, accessibility audit | 2-3 hours |
| **Development** | PC | VS Code, Next.js, Supabase, Vercel | Full-stack app implementation | 40-80 hours |
| **Documentation** | Hermes (optional) | read_file, patch, memory | Design freeze archive, project status update | 30 minutes |

**Key Benefits**:
- ✅ **Hermes**: Thinking & Planning (specifications, research, data modeling, prompt engineering)
- ✅ **PC**: Execution (UI generation via MCP, coding, testing, deployment)
- ✅ **No duplication**: Specs created once in Hermes, consumed autonomously by MCP agent on PC
- ✅ **Async workflow**: User can continue planning in Hermes while PC agent generates screens in background
- ✅ **Verifiable output**: Design freeze report with concrete metrics (0 gradients, 95 Lighthouse score, etc.)

**Common Pitfalls to Avoid**:
- ❌ Skipping DESIGN.md → MCP agent generates inconsistent styling across screens
- ❌ Vague Stitch prompts → AI outputs generic templates with gradients/glassmorphism
- ❌ No anti-slop verification → Accepting first MCP output without compliance check
- ❌ Skipping accessibility audit → Launch dengan WCAG violations (legal risk)
- ❌ No design freeze sign-off → Scope creep during development ("can we change the layout?")

---
