# Google Stitch Project Structure

Struktur folder untuk persiapan Google Stitch generation dan output management.

**Last Updated:** 2026-09-29  
**Purpose:** Template folder structure untuk workflow Google Stitch (mockup generation → code export → Next.js integration)

---

## Overview

Google Stitch = AI-powered mockup generator yang export code (HTML/CSS/Tailwind/React). Workflow: Planning docs (DESIGN.md + DESIGN_SPEC.md) → Stitch prompts → Generate mockups → Export code → Integrate ke Next.js project.

**Folder structure ini dipakai di fase:**
- **Planning (Hermes):** Buat DESIGN.md, DESIGN_SPEC.md
- **Stitch Prep (PC):** Setup `stitch-input/` folder (prompts + brand assets + references)
- **Stitch Generation (PC/Browser):** Generate 10 screens via Google Stitch web UI atau MCP
- **Integration (PC/VS Code):** Copy `stitch-output/` code → Next.js `src/app/` folder, tambah logic/state/API

---

## Folder Structure

```
[project-root]/                          # Root project (e.g., freepajak/)
├── docs/                                # Planning docs (from Hermes)
│   ├── pm/
│   │   ├── IDEA_BRIEF.md
│   │   └── SCOPE_STATEMENT.md
│   ├── specs/
│   │   ├── LOGO_DESIGN_BRIEF.md
│   │   ├── DESIGN.md
│   │   └── DESIGN_SPEC.md
│   └── research/
│       └── ...
├── stitch-input/                        # Input files untuk Stitch (buat manual di PC)
│   ├── prompts/                         # Prompt per screen (.txt files)
│   │   ├── 01-landing-page.txt
│   │   ├── 02-login.txt
│   │   ├── 03-signup.txt
│   │   ├── 04-onboarding.txt
│   │   ├── 05-dashboard.txt
│   │   ├── 06-calculator.txt
│   │   ├── 07-calculation-result.txt
│   │   ├── 08-clients.txt
│   │   ├── 09-transactions.txt
│   │   └── 10-settings.txt
│   ├── brand/                           # Brand assets (logo, colors)
│   │   ├── logo.svg                     # Logo master file
│   │   ├── logo-icon.svg                # Icon only (no text)
│   │   └── colors.txt                   # Brand color palette
│   └── references/                      # Reference images (for style anchor)
│       ├── stripe-dashboard.png         # Example: clean table layout
│       ├── linear-app.png               # Example: modern nav sidebar
│       └── notion-database.png          # Example: data-dense table
└── stitch-output/                       # Exported code dari Stitch (generated)
    ├── 01-landing-page/
    │   ├── page.tsx                     # Exported React component
    │   ├── components/                  # Extracted components (if any)
    │   └── styles.css                   # Extracted styles (if separate)
    ├── 02-login/
    │   └── page.tsx
    ├── 03-signup/
    │   └── page.tsx
    ├── 04-onboarding/
    │   └── page.tsx
    ├── 05-dashboard/
    │   └── page.tsx
    ├── 06-calculator/
    │   └── page.tsx
    ├── 07-calculation-result/
    │   └── page.tsx
    ├── 08-clients/
    │   └── page.tsx
    ├── 09-transactions/
    │   └── page.tsx
    └── 10-settings/
        └── page.tsx
```

---

## File Details

### 1. `stitch-input/prompts/*.txt`

**Purpose:** Prompt per screen untuk Google Stitch generation

**Format:** Plain text file, 1 prompt per screen

**Content structure:**
```
Screen: [Screen Name] ([Route], [Role])
Layout: [Header/Sidebar/Main/Footer breakdown]
Section 1: [Name]
  - Heading: "[Text]"
  - Components: [Button/Card/Table/etc with Tailwind classes]
Section 2: ...
Style strict: [Colors, fonts, spacing, radius, shadows]
NO: [Anti-slop directives: gradients, glassmorphism, heavy shadows, Lorem Ipsum]
Reference: [Product name for style anchor]
```

**Example:** `01-landing-page.txt`
```
Screen: Landing Page (/, Public)

Layout:
- Header: Logo left, nav center (Home, Fitur, Harga), button "Daftar" (teal) right
- Main: 8 sections (Hero, Problem, Solution, How It Works, Social Proof, Pricing, FAQ, CTA)
- Footer: Logo, links, social icons

Section 1: Hero
- Heading (text-4xl, font-bold, gray-900): "Hitung 3 Skema Pajak Freelancer"
- Subheading (text-xl, gray-600): "Simpan Jutaan Rupiah per Tahun"
- Button primary (bg-cyan-600, text-white, px-6 py-3, rounded-lg): "Hitung Pajak Gratis"

Style strict:
- Primary: #0891B2 (teal) — CTA buttons only
- Background: #FFFFFF
- Text: #111827 (gray-900), #6B7280 (gray-500)
- Border: #E5E7EB (gray-200), 1px solid
- Font: Inter, JetBrains Mono (numbers)
- Radius: 8px (cards), 6px (buttons)
- Shadow: NONE (use borders)

NO:
- ❌ Gradients
- ❌ Glassmorphism
- ❌ Shadows > 4px
- ❌ Lorem Ipsum

Reference: Stripe homepage (clean, white bg, subtle borders)
```

**How to create:**
1. Open `docs/specs/DESIGN_SPEC.md` → Section 6
2. For each screen (SCR-01 to SCR-10):
   - Extract layout structure
   - Extract section breakdown (headings, components, Tailwind classes)
   - Extract style constraints from DESIGN.md
   - Add anti-slop directives (NO gradients, NO glassmorphism, etc)
   - Add reference product (Stripe, Linear, Notion)
3. Save to `stitch-input/prompts/[NN]-[screen-name].txt`

**Total files:** 10 prompts (1 per screen)

---

### 2. `stitch-input/brand/logo.svg`

**Purpose:** Logo master file (SVG vector) untuk upload ke Google Stitch

**Source:** Generated from `docs/specs/LOGO_DESIGN_BRIEF.md` (4 AI prompts)

**Requirements:**
- ✅ SVG format (vector, scalable)
- ✅ Works on white background
- ✅ Works on dark background (if dark mode)
- ✅ Clean shapes (no raster images embedded)
- ✅ File size < 50KB

**Export variants:**
- `logo.svg` (full logo: icon + text, horizontal layout)
- `logo-icon.svg` (icon only, no text, square aspect ratio)
- `logo-512.png`, `logo-256.png`, `logo-128.png` (raster fallbacks for non-SVG contexts)

**How to create:**
1. Open `docs/specs/LOGO_DESIGN_BRIEF.md`
2. Copy 4 prompts (line ~225-289)
3. Generate via ChatGPT/Claude/Midjourney
4. Download SVG
5. Save to `stitch-input/brand/logo.svg`

---

### 3. `stitch-input/brand/colors.txt`

**Purpose:** Brand color palette untuk reference saat Stitch generation

**Format:** Plain text, 1 color per line with hex + name + usage

**Content:**
```
Primary: Teal #0891B2 (Cyan-600) — CTA buttons, active nav links, focus states
Accent: Coral #F97316 (Orange-500) — Secondary CTA, warning alerts, highlights
Background: White #FFFFFF — Page background, card background
Surface: Gray-50 #F9FAFB — Alternating table rows, disabled inputs
Text Primary: Gray-900 #111827 — Headings, body text, form labels
Text Secondary: Gray-500 #6B7280 — Helper text, placeholders, muted info
Text Tertiary: Gray-400 #9CA3AF — Disabled text
Border Default: Gray-200 #E5E7EB — Card borders, input borders, table dividers
Border Strong: Gray-300 #D1D5DB — Focused inputs, active sections
Success: Emerald-500 #10B981 — "Hemat Rp X", calculation saved
Warning: Amber-500 #F59E0B — "Deadline 7 hari lagi"
Error: Red-500 #EF4444 — Form validation errors
Info: Blue-500 #3B82F6 — Tips, help tooltips
```

**Source:** Extracted from `docs/specs/DESIGN.md` Section 2

**How to create:**
1. Open `docs/specs/DESIGN.md` → Section 2 (Color Palette & Tokens)
2. Copy semantic color tokens
3. Format as plain text (no Markdown)
4. Save to `stitch-input/brand/colors.txt`

---

### 4. `stitch-input/references/*.png`

**Purpose:** Reference images untuk style anchor (Stitch belajar dari visual example)

**Format:** PNG or JPG, screenshots dari real products

**Recommended references:**
- **Stripe Dashboard** (`stripe-dashboard.png`): Clean table, white bg, 1px borders, no shadows
- **Linear App** (`linear-app.png`): Modern nav sidebar, active state indicator, flat design
- **Notion Database** (`notion-database.png`): Data-dense table, good typography hierarchy
- **Vercel Dashboard** (`vercel-dashboard.png`): Minimalist cards, good spacing

**How to create:**
1. Visit reference products (Stripe, Linear, Notion, Vercel)
2. Take screenshots (browser DevTools → responsive mode 1280px width)
3. Crop to relevant sections (table, sidebar, card grid)
4. Save to `stitch-input/references/[product-name].png`

**Why references matter:**
- Stitch learns visual patterns from references (better than text description alone)
- "Reference: Stripe Dashboard" + actual screenshot = higher quality output
- Reduces AI slop (gradients, glassmorphism) because real products don't use them

---

### 5. `stitch-output/[NN]-[screen-name]/page.tsx`

**Purpose:** Exported code dari Google Stitch (skeleton React component)

**Format:** `.tsx` file (TypeScript + JSX)

**Content:** Static mockup dengan:
- ✅ Layout structure (JSX elements)
- ✅ Tailwind CSS classes (styling)
- ✅ Hardcoded placeholder data
- ❌ NO state management (useState, useEffect)
- ❌ NO data fetching (Supabase, API)
- ❌ NO routing (Link component)
- ❌ NO business logic

**Example:** `stitch-output/05-dashboard/page.tsx`
```tsx
export default function Dashboard() {
  return (
    <div className="flex">
      <aside className="w-64 border-r border-gray-200">
        <nav>
          <a className="block px-4 py-2 text-cyan-600 bg-cyan-50">Dashboard</a>
          <a className="block px-4 py-2 text-gray-700">Kalkulator</a>
        </nav>
      </aside>
      <main className="flex-1 p-8">
        <div className="grid grid-cols-4 gap-6">
          <div className="bg-white border border-gray-200 rounded-lg p-6">
            <p className="text-sm text-gray-500">Total Omzet</p>
            <p className="text-2xl font-bold font-mono">Rp 240.000.000</p>
          </div>
          {/* 3 cards more */}
        </div>
      </main>
    </div>
  );
}
```

**How generated:**
1. Via Google Stitch web UI:
   - Open https://stitch.withgoogle.com
   - Create project, upload brand/colors/logo
   - Paste prompt dari `stitch-input/prompts/05-dashboard.txt`
   - Click "Generate"
   - Review mockup
   - Click "Export" → Choose "React Component"
   - Download → save to `stitch-output/05-dashboard/page.tsx`

2. Via MCP (automated):
   - Claude Desktop + MCP Stitch server
   - Chat: "Generate dashboard using prompt from stitch-input/prompts/05-dashboard.txt"
   - Claude call MCP → generate → return code
   - Save to `stitch-output/05-dashboard/page.tsx`

**Total files:** 10 components (1 per screen)

---

## Workflow Timeline

| Phase | Tool | Duration | Input | Output |
|-------|------|----------|-------|--------|
| **1. Planning** | Hermes | 2-3 weeks | User requirements | `docs/` (241KB: IDEA_BRIEF, SCOPE_STATEMENT, DESIGN.md, DESIGN_SPEC.md) |
| **2. Export** | Hermes terminal | 5 minutes | `docs/` folder | `freepajak-planning.tar.gz` (76KB) |
| **3. Extract** | PC terminal | 2 minutes | `.tar.gz` file | `docs/` folder on PC |
| **4. Logo Generation** | ChatGPT/Midjourney | 30 minutes | LOGO_DESIGN_BRIEF.md | `stitch-input/brand/logo.svg` |
| **5. Stitch Prep** | Manual (VS Code) | 30 minutes | DESIGN_SPEC.md Section 6 | `stitch-input/prompts/*.txt` (10 files), `stitch-input/brand/colors.txt`, `stitch-input/references/*.png` (3-5 files) |
| **6. Stitch Generation** | Google Stitch Web or MCP | 2-3 hours | `stitch-input/` folder | `stitch-output/*.tsx` (10 files, skeleton components) |
| **7. Next.js Setup** | Terminal + VS Code | 1 hour | - | Next.js project scaffold + shadcn/ui |
| **8. Integration** | VS Code | 2-3 hours | `stitch-output/*.tsx` | `src/app/*/page.tsx` (copy + fix imports + add routing) |
| **9. Development** | VS Code + Supabase | 6-8 weeks | Skeleton components | Working app (state + API + logic + tests) |

**Total:** 3 weeks planning (done in Hermes) + 1 day Stitch prep/generation + 6-8 weeks development = **10-12 weeks end-to-end**

---

## Checklist: Stitch Prep (Before Generation)

**Before opening Google Stitch, verify:**

- [ ] `docs/specs/DESIGN.md` exists (design system: colors, typography, components)
- [ ] `docs/specs/DESIGN_SPEC.md` exists (10 screens breakdown: layout, sections, wireframes)
- [ ] `stitch-input/brand/logo.svg` exists (generated from LOGO_DESIGN_BRIEF.md)
- [ ] `stitch-input/brand/colors.txt` exists (brand color palette with hex values)
- [ ] `stitch-input/prompts/01-landing-page.txt` exists (prompt for landing page)
- [ ] `stitch-input/prompts/02-login.txt` exists
- [ ] ... (total 10 prompts, 1 per screen)
- [ ] `stitch-input/references/stripe-dashboard.png` exists (at least 1 reference image)
- [ ] All prompts include anti-slop directives: "NO gradients, NO glassmorphism, NO shadows > 4px, NO Lorem Ipsum"

**If any missing:** Go back to planning phase, create missing files

---

## Common Pitfalls & How to Avoid

| Pitfall | Symptom | Fix |
|---------|---------|-----|
| **Prompt too short** | Stitch generates generic UI (purple gradients, Lorem Ipsum) | Add detailed layout + section breakdown + anti-slop directives + reference product |
| **No reference images** | Output doesn't match desired style | Upload 3-5 reference screenshots (Stripe, Linear, Notion) |
| **No brand colors uploaded** | Stitch uses default colors (blue, purple) | Upload `colors.txt` with exact hex values |
| **Logo not uploaded** | Stitch uses placeholder logo | Generate logo first, upload SVG |
| **Export wrong format** | HTML/CSS instead of React | Choose "React Component" or "Tailwind CSS" when exporting |
| **Stitch output has Lorem Ipsum** | Placeholder text not replaced | Add to prompt: "Use real tax terms: 'Penghasilan Bruto', 'PPh Final', 'NPWP'" |
| **Heavy shadows on cards** | AI slop (glassmorphism) | Add to prompt: "NO shadows on cards, use 1px borders (border border-gray-200)" |
| **Gradient backgrounds** | AI slop (purple/pink/blue) | Add to prompt: "NO gradients, solid colors only: white #FFFFFF, gray-50 #F9FAFB" |

---

## FAQ

**Q: Harus pakai Google Stitch? Bisa skip?**  
A: Bisa skip, tapi lebih lambat. Alternatif:
- Manual coding dari wireframe (8-10 weeks total)
- Figma → Figma-to-Code plugin (butuh Figma skill)
- v0.dev (similar to Stitch, tapi kurang customizable)

**Q: MCP Stitch wajib?**  
A: Opsional. Manual browser workflow works fine, MCP cuma accelerator (2-3 jam → 1-2 jam).

**Q: Berapa banyak reference images ideal?**  
A: 3-5 images cukup. Lebih dari 10 images malah bikin Stitch confused.

**Q: Stitch output langsung production-ready?**  
A: TIDAK. Stitch output = skeleton (layout + styling), masih butuh 6-8 minggu development (state, API, logic).

**Q: Bisa pakai Stitch untuk backend/API?**  
A: Tidak. Stitch cuma frontend mockup. Backend (Supabase, API routes) manual coding.

**Q: Kalau Stitch generation gagal (error, timeout)?**  
A: Retry dengan prompt lebih simple (kurangi sections, fokus ke layout utama). Atau generate per section (hero section dulu, table section terpisah), lalu combine manual.

---

## Tools & Resources

**Google Stitch:**
- Web UI: https://stitch.withgoogle.com
- Docs: https://ai.google.dev/stitch (official documentation)
- Pricing: Free (as of Sept 2026, usage limits may apply)

**MCP Stitch:**
- MCP Protocol: https://modelcontextprotocol.io
- Stitch MCP Server: https://github.com/modelcontextprotocol/servers (check for `stitch` server)
- Claude Desktop: https://claude.ai/desktop

**Logo Generation:**
- ChatGPT: https://chat.openai.com (DALL-E 3 for logo generation)
- Midjourney: https://midjourney.com (Discord bot, best quality)
- Claude: https://claude.ai (Anthropic's image generation)

**Reference Products:**
- Stripe: https://stripe.com/dashboard
- Linear: https://linear.app
- Notion: https://notion.so
- Vercel: https://vercel.com/dashboard
- Supabase: https://supabase.com/dashboard

---

## Next Steps After Stitch Generation

**After you have `stitch-output/*.tsx` files:**

1. **Create Next.js project:**
   ```bash
   npx create-next-app@latest [project-name] --typescript --tailwind --app
   ```

2. **Install shadcn/ui:**
   ```bash
   npx shadcn@latest init
   npx shadcn@latest add button input card table dialog dropdown-menu toast badge tabs calendar
   ```

3. **Copy Stitch output to Next.js:**
   ```bash
   cp stitch-output/01-landing-page/page.tsx src/app/(marketing)/page.tsx
   cp stitch-output/05-dashboard/page.tsx src/app/(authenticated)/dashboard/page.tsx
   # ... copy all 10 screens
   ```

4. **Fix imports:**
   ```tsx
   // From Stitch (wrong):
   import { Button } from './components/button';
   
   // Fix to:
   import { Button } from '@/components/ui/button';
   ```

5. **Add routing:**
   ```tsx
   // From Stitch (wrong):
   <a href="/signup">Daftar</a>
   
   // Fix to:
   import Link from 'next/link';
   <Link href="/signup">Daftar</Link>
   ```

6. **Test responsive:**
   - Resize browser: 375px (mobile) → 768px (tablet) → 1280px (desktop)
   - Fix breakpoints if needed

7. **Start development (6-8 weeks):**
   - Add Supabase (auth, database queries)
   - Add state management (useState, useContext, Zustand)
   - Add business logic (tax calculation functions)
   - Add form handling (React Hook Form, Zod validation)
   - Add error handling (toast notifications)
   - Add loading states (skeleton, spinners)

---

**End of STITCH_PROJECT_STRUCTURE.md**
