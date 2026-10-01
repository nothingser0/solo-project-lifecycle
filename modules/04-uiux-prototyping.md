# Modul 04: UI/UX Design & Prototyping (Google Stitch Universal Engine)

> ⚠️ **MANDATORY: Load references BEFORE executing this module**:
> - `references/solo/SOLO_UIUX_GUIDE.md` (Solo dev UI/UX efficiency guide, Component library selection, WCAG contrast, Prototype walkthrough)
> - `references/pm/PM_USER_TESTING_GUIDE.md` (User testing facilitation, Usability test plan)
> - `references/technical/UI_COMPONENT_ANIMATION_LIBRARY.md` (Animation patterns library)
> - `references/technical/ASSET_MANAGEMENT_GUIDE.md` (Images/SVG/WebP/fonts optimization, Favicon package, Accessibility alt text, Performance budgets)
> - `references/improvements/MODUL_04_IMPROVEMENTS.md` (Output contract: DESIGN.md, DESIGN_SPEC.md, DESIGN_REFERENCES.md; manual workflow; scope-based page inventory)
> - `references/technical/AI_DEVELOPMENT_TOOLS_COMPARISON.md` (AI UI prototyping & coding tools benchmark)
>
> Load via: `skill_view(name='solo-project-lifecycle', file_path='references/improvements/MODUL_04_IMPROVEMENTS.md')`

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

## 2. Empat Artefak Keluaran (Deliverables) Modul 04

Modul ini menghasilkan 4 deliverable konkret:

| No | Nama Artefak | Format / Lokasi | Deskripsi & Fungsi |
| :---: | :--- | :--- | :--- |
| **1** | **`docs/specs/DESIGN_SYSTEM.md`** | Folder `docs/specs/` | Dokumen gabungan token desain sistem dan spesifikasi antarmuka lengkap (arsitektur informasi, sitemap, Screen ID Stitch, matriks 5 state layar). |
| **2** | **Interactive Prototype** | Tautan Live Staging Web / Stitch Viewer | Aplikasi antarmuka nyata yang bisa diklik tombolnya, diketik form-nya, dan diuji alur kerjanya oleh klien. |
| **3** | **Design Freeze Sign-Off** | Lembar bertandatangan di `docs/specs/DESIGN_SYSTEM.md` | Berita acara persetujuan tertulis dari Single PIC Klien yang mengunci struktur visual sebelum koding backend dimulai. |

> 📁 **ATURAN LOKASI BERKAS MUTLAK**:
> - `DESIGN.md` ditaruh di root (`./DESIGN.md`) karena berfungsi sebagai berkas kendali AI saat koding (Modul 06).
> - `DESIGN_SPEC.md` WAJIB ditaruh di **`docs/specs/DESIGN_SPEC.md`**. DILARANG menaruhnya di root direktori.
>
> ⚠️ **PENANGANAN KENDALA TOOL GOOGLE STITCH**:
> Jika pemanggilan tool Stitch (`stitch_create_project` atau `stitch_generate_screen_from_text`) mengalami kegagalan autentikasi atau jaringan:
> - **DILARANG KERAS membuat keputusan sepihak "skip Stitch / implement directly in code"**!
> - Periksa apakah API Key Stitch telah terpasang dengan benar di konfigurasi MCP (`opencode.json` / `STITCH_API_KEY`). Laporkan kendala teknis kepada pengguna untuk memastikan koneksi Stitch pulih, bukan mengambil jalan pintas memotong fase desain.

---

## 3. Langkah demi Langkah Eksekusi

### Langkah 0: Generate Logo Design Brief (MANDATORY - Pre-Design Phase)
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
   > "Logo design brief telah dibuat di `docs/specs/LOGO_DESIGN_BRIEF.md` (Xkb). Silakan generate logo menggunakan salah satu dari 4 prompt yang tersedia (copy-paste ke ChatGPT/Claude/Midjourney/LogoAI). Setelah logo selesai, simpan SVG files ke `/assets/logo/` dan lanjut ke Langkah 1 (DESIGN.md). **Atau, jika ingin skip logo placeholder dulu, kita bisa lanjut dengan placeholder dan Anda generate logo nanti sebelum launch.**"

3. **Wait for User Decision** (Do NOT proceed automatically):
   - User generates logo now → Wait for logo files, then proceed to Step 1
   - User wants placeholder → Proceed to Step 1 with placeholder logo note

**Why This is Mandatory**:
- Logo colors inform the primary/accent color palette in `DESIGN.md`
- Logo style (geometric/rounded/modern) informs design system tokens
- Generating brief upfront prevents color/style mismatches later
- User can generate logo asynchronously without blocking Modul 04 progress

**Template**: Use `templates/02-design/LOGO_DESIGN_BRIEF_TEMPLATE.md` (if not exists, create inline using the structure above).

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
   - Tombol "Login" $\to$ mengarahkan ke `/dashboard`
   - Tombol "Buat Dokumen Baru" $\to$ mengarahkan ke `/documents/new`
   - Tombol "Simpan Draf" $\to$ menampilkan modal/toast sukses dan mengarahkan ke `/documents/:id`
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
| **Kepatuhan Desain** | Kontras visual standar $\ge 4.5:1$ | WCAG AA terverifikasi pada form | Full WCAG AA audit (Keyboard nav, Screen reader) |
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
- [x] Dokumen `DESIGN.md` telah diunggah dan aktif sebagai Design System di Stitch.
- [x] Seluruh layar utama telah di-generate dengan data riil dan 5 state lengkap.
- [x] Tautan demo interaktif (Clickable Prototype) dapat diklik tanpa dead-end.
- [x] **Minimum 2 iterasi user testing telah dilakukan dengan 5+ pengguna per iterasi.**
- [x] **SUS Score ≥70 (Acceptable) tercapai pada iterasi terakhir.** ← MANDATORY GATE
- [x] **Accessibility audit (WCAG AA) menunjukkan zero critical issues.**
- [x] **Single PIC Klien (atau solo developer) telah menandatangani persetujuan Design Freeze.**

---

## 🛑 PROTOKOL [GATE] KELUAR & WAJIB BERHENTI

Setelah berkas `DESIGN.md`, `docs/specs/DESIGN_SPEC.md`, dan seluruh layar Stitch selesai di-generate:
1. **DILARANG KERAS langsung melanjutkan atau memanggil tool untuk Modul 05 dalam giliran (turn) yang sama!**
2. **VERIFIKASI DIRI (Self-Verification Checklist)**:
   - [ ] `read_file('DESIGN.md')` → Confirm color tokens, typography exists
   - [ ] `read_file('docs/specs/DESIGN_SPEC.md')` → Confirm Screen ID table populated
   - [ ] Count generated screens = total screens in scope (100% coverage)
   - [ ] Demo URL accessible (if applicable)
3. Tampilkan ringkasan hasil desain kepada pengguna:
   - Token desain utama di `DESIGN.md` (Warna aksen, font, border)
   - Tabel inventaris Screen ID Stitch yang berhasil di-generate
   - Tautan demo interaktif Stitch / live staging preview
4. **AKHIRI RESPON ANDA (END TURN)** dan ajukan konfirmasi kepada pengguna:
   > *"Seluruh layar telah di-generate di Google Stitch dan didokumentasikan di `docs/specs/DESIGN_SPEC.md`. Silakan tinjau prototipenya. Apakah tata letak visual ini disetujui (Design Freeze) sebelum kita melangkah ke Modul 05 (Arsitektur & FSD)?"*
5. Tunggu respon persetujuan eksplisit dari pengguna sebelum melangkah ke Modul 05.

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
