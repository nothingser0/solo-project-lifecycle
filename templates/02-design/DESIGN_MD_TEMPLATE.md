---
version: alpha
name: [Brand / Product Name]
description: [One sentence: the visual language this file encodes.]
sources:
  - [https://official-site.example — homepage / product page]
  - [https://official-site.example/press — press kit, media kit, or brand page]
  - [URL of any design case study that explains the identity system]
notes:
  - [Observed on YYYY-MM-DD. What was inspected: live DOM/computed CSS, SVG fills, font declarations.]
  - [Any evidence limitation — blocked page, missing press kit, asset unavailable.]
---

# Design System Specification & CSS Tokens (DESIGN.md)

> **Purpose**: Definitive design system tokens and visual engineering rules for AI coding agents. Deployed to `docs/harness-root/DESIGN.md` in Module 04 and root `./DESIGN.md` in Module 06.
> **Standard**: Strict WCAG 2.2 Level AA compliance, calibrated triad semantic tokens, iOS-safe 16px inputs, and unified multi-theme CSS variables.
> **Domain & Scale**: Adaptable across all software categories (CRM, CMS, HRIS, E-Commerce, Retail POS, Fintech, SaaS, Developer Tools) and scales (Small MVP to Enterprise).

> **Source discipline (gate-enforced)**: `sources:` must list the real pages or files this system was derived from, and §0 must separate **observed evidence** from **inference**. A palette invented from memory is not a design system — it is a guess with hex codes. The agent may not fill `sources:` with a URL it did not actually inspect.

---

## 0. Evidence & Inference Log

*Every token below came from somewhere. Record where, and mark what was inferred. This section is what separates a design system from a plausible-looking guess.*

| # | Token / decision | Source type | Evidence (what was actually observed) | Confidence |
| :-: | :--- | :--- | :--- | :---: |
| 1 | `--primary` = `#0F7C80` | Direct | Computed `background-color` of the header CTA on the live homepage, 2026-10-19 | ✅ |
| 2 | Display typeface = Inter | Direct | `font-family` declaration in the site's CSS bundle | ✅ |
| 3 | `--radius-lg` = 12px | Direct | `border-radius` on product cards | ✅ |
| 4 | Section rhythm = 96px | Inference | Not declared in CSS as a token; derived from observed spacing between blocks | 🔶 |
| 5 | Status colours (success/warning) | Inference | Brand defines no status palette; assigned from the accent hue family | 🔶 |

**Source-type legend**
- **Direct** — observed CSS, SVG fill, image colour, font name, or layout behaviour.
- **Official prose** — brand usage rules, typography notes, or press-kit copy published by the brand.
- **Design rationale** — published explanation of motif, concept, colour naming, or type system.
- **Inference** — a practical decision the agent made that no source states.

**Confidence legend**: ✅ VERIFIED (observed) · 🔶 INFERENCE (decided, not observed) · ❓ UNKNOWN (unresolved, blocks a decision).

**Rules**
1. An inferred token must be marked 🔶 and say *why* it was needed. Do not promote an inference to ✅ later without new evidence.
2. If a page was blocked (CAPTCHA, login, paywall), say so here. **Never bypass an access control** to get a colour.
3. Where official brand rules restrict use (logo clearspace, forbidden pairings, licensed typefaces), quote the rule and link it.
4. Third-party brand databases and inspiration galleries are **secondary** support only — never the sole source for a token.

---

## 1. Calibrated Color Palette & Contrast Verification

*All contrast ratios are mathematically computed against the respective background surface. Labels strictly reflect actual compliance (WCAG AA vs AAA) without overclaiming:*

### 1.1 Light Mode Color Tokens (Base Surface: `#FFFFFF` / Canvas: `#F7F6F2`)

| Token Name | HEX Value | UI Role | Tested Background | Contrast Ratio | Compliance Standard |
| :--- | :---: | :--- | :---: | :---: | :---: |
| `--background` | `#FFFFFF` | Primary viewport background | - | - | Base Canvas |
| `--card` | `#FFFFFF` | Elevated container / modal card | `#F7F6F2` | 1.05 : 1 | Base Container |
| `--foreground` | `#18181B` | Headings & primary body copy | `#FFFFFF` | **17.72 : 1** | PASS (WCAG AAA) |
| `--muted-foreground` | `#71717A` | Secondary text, captions, hints | `#FFFFFF` | **4.83 : 1** | PASS (WCAG AA) |
| `--text-placeholder`| `#71717A` | Input field placeholder text | `#FFFFFF` | **4.83 : 1** | PASS (WCAG AA) |
| `--border` (Subtle)| `#8A8A93` | 1px passive container divider | `#FFFFFF` | **3.42 : 1** | PASS (WCAG 1.4.11 >= 3:1) |
| `--input` (Border) | `#71717A` | Interactive form & button border| `#FFFFFF` | **4.83 : 1** | PASS (WCAG 1.4.11 ≥ 3:1) |
| `--primary` | `#[BRAND_HEX]`| Primary brand accent / CTA | `#FFFFFF` | ≥ 4.5 : 1 | PASS (WCAG AA) |

### 1.2 Dark Mode Color Tokens (Base Surface: `#09090B` / Canvas: `#121214`)

| Token Name | HEX Value | UI Role | Tested Background | Contrast Ratio | Compliance Standard |
| :--- | :---: | :--- | :---: | :---: | :---: |
| `--background` | `#09090B` | Dark viewport background | - | - | Base Canvas |
| `--card` | `#18181B` | Elevated card container | `#09090B` | 1.15 : 1 | Elevated Surface |
| `--foreground` | `#F4F4F5` | Dark mode primary headings & body | `#09090B` | **18.10 : 1** | PASS (WCAG AAA) |
| `--muted-foreground` | `#A1A1AA` | Dark mode secondary text | `#09090B` | **7.76 : 1** | PASS (WCAG AAA) |
| `--text-placeholder`| `#A1A1AA` | Dark mode input placeholder | `#18181B` | **6.91 : 1** | PASS (WCAG AA) |
| `--border` (Subtle)| `#6E6E78` | Passive container divider | `#09090B` | **3.95 : 1** | PASS (WCAG 1.4.11 >= 3:1) |
| `--input` (Border) | `#71717A` | Interactive form border | `#18181B` | **3.67 : 1** | PASS (WCAG 1.4.11 ≥ 3:1) |
| `--primary` | `#[BRAND_DARK]`| Primary brand accent / CTA | `#09090B` | ≥ 4.5 : 1 | PASS (WCAG AA) |

---

## 2. Complete Triad Status Tokens (Text, Border, Background)

*Every semantic status MUST provide three distinct CSS variables to ensure visual harmony without hardcoded hexes in components:*

| Status Semantic | Text Token (`--[name]`) | Border Token (`--[name]-border`) | Background Token (`--[name]-bg`) | Light Contrast | Dark Text Token | Dark Border Token | Dark Background Token | Dark Contrast |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Success** | `#065F46` | `#A7F3D0` | `#ECFDF5` | **6.78 : 1** (AA) | `#86EFAC` | `#065F46` | `#052E16` | **10.62 : 1** (AAA) |
| **Warning** | `#92400E` | `#FDE68A` | `#FFFBEB` | **6.37 : 1** (AA) | `#FDE047` | `#854D0E` | `#422006` | **11.06 : 1** (AAA) |
| **Destructive**| `#991B1B` | `#FECACA` | `#FEF2F2` | **6.80 : 1** (AA) | `#FCA5A5` | `#991B1B` | `#450A0A` | **8.51 : 1** (AAA) |
| **Info** | `#1E40AF` | `#BFDBFE` | `#EFF6FF` | **7.10 : 1** (AAA)| `#93C5FD` | `#1E40AF` | `#172554` | **9.25 : 1** (AAA) |

> ⚠️ **SEMANTIC USAGE RULE**:
> Normal business transactions (operating expenses, outbound shipping, routine adjustments) use **neutral badge styling with arithmetic signs** (`-Rp` or `-$`), **NEVER `--destructive`**.
> Destructive tokens are strictly reserved for irreversible operations: voided invoices, deleted records, overdue accounts, and system errors.

---

## 3. Typography & Form Ergonomics (Anti-Zoom Standards)

### 3.1 The 5 Font Pairing Modes
Select exactly one pairing strategy matching project scale and context:
1. **`single-family`** *(Recommended for Solo Dev)*: One versatile variable family (e.g., Inter, Geist). Hierarchy driven solely by `wght` (font-weight), `opsz` (optical size), and letter-spacing. Lowest bandwidth, zero font-clash risk.
2. **`superfamily`**: Sans + Serif sharing identical underlying skeleton, x-height, and proportions (e.g., IBM Plex Sans + IBM Plex Serif, Source Sans + Source Serif).
3. **`contrast`**: Distinct, characterful display typeface for marketing headlines + ultra-neutral grotesque sans for app UI.
4. **`same-designer`**: Two distinct faces engineered by the same type foundry or designer for harmonious baseline cadence.
5. **`data-face`**: Specialized monospace or tabular sans dedicated to financial, numerical, or data-dense dashboard views.

### 3.2 Font Family Declarations & The `tnum` Rule
- **Primary UI / Body Font**: `Inter` (weights: 400, 500, 600, 700)
- **Monospace / Numeric Font**: `JetBrains Mono` (weights: 400, 700) for codes, currency, hashes, and SKU identifiers.
- **Tabular Numbers (`tnum`) Gate**: For financial, bookkeeping, accounting, or metrics dashboards (e.g., FreePajak, TataBuku), the body and data font MUST explicitly support OpenType tabular figures:
  ```css
  /* Enforce fixed-width numerals in all data tables, counters, and currencies */
  .tabular-nums, table td, .metric-counter {
    font-feature-settings: "tnum" 1;
    font-variant-numeric: tabular-nums;
  }
  ```
  *Failure mode: Proportional numbers ("1" narrower than "8") causing jittery alignment in financial tables or running timers.*

### 3.3 Form Input Anti-Zoom Rule (iOS & iPad Safari)
- All form inputs (`<input>`, `<select>`, `<textarea>`) **MUST BE AT LEAST `16px` (`text-base`) across ALL viewports**.
- **PROHIBITED**: Applying `text-base md:text-sm` to inputs. This triggers automatic viewport zoom on iPads and touch screens ≥ 768px, distorting layout shells.
- **Inputmode Differentiation**:
  - Currency / Integer inputs: Use `inputmode="numeric"` with live dot/comma thousands formatting. NEVER use `<input type="number">`.
  - Fractional quantities (Kg/Liter): Use `inputmode="decimal"`.

### 3.4 Layout Shell Architecture Tokens (Inherited from notes.md §3)
- `--layout-shell`: `[top-nav | sidebar | split]` (Strictly locked to the primary benchmark archetype)
- `--shell-header-height`: `64px` (or benchmark height)
- `--shell-canvas-bg`: `#[HEX]` (Benchmark neutral canvas tone, e.g. `#F4F5F7` / `#F8FAFC`)
- `--shell-content-max-width`: `1280px` (or `1440px` / `fluid`)
- **Shell Parity Contract**: Prototype screens and final production layouts MUST adhere strictly to `--layout-shell`. If `--layout-shell: top-nav`, inventing a left sidebar is STRICTLY FORBIDDEN as a visual hallucination.

---

## 3.5 Spacing Scale

M04 requires this section by name. A single spacing scale is what keeps a layout from drifting into arbitrary values (`13px`, `27px`) that look almost-consistent and are not.

| Token | Value | Used for |
| :--- | ---: | :--- |
| `--space-0` | 0 | Flush edges |
| `--space-1` | 4px | Icon-to-label, inline gaps |
| `--space-2` | 8px | Form field internal padding |
| `--space-3` | 12px | Related controls in a group |
| `--space-4` | 16px | Default element spacing |
| `--space-6` | 24px | Card padding, block separation |
| `--space-8` | 32px | Section rhythm |
| `--space-12` | 48px | Page-level separation |
| `--space-16` | 64px | Hero / empty-state breathing room |

**Rules**: every margin and padding is a token, never a raw number. The base unit is 4px; all values are multiples of it. Vertical rhythm inside a section uses one step, section-to-section uses the next.

---

## 4. Touch Ergonomics & Specialized Hardware Geometry

### 4.1 Touch Targets (Comfort & AAA Standard)
- Primary tap targets on touch and mobile devices **MUST be ≥ 44px × 44px** (`h-11 min-w-11`).
- *Note*: While WCAG 2.2 Level AA establishes 24px minimum (SC 2.5.8), 44px is our internal ergonomics baseline to prevent mis-taps on tablet/touch terminals.
- Numeric Keypads (if applicable): Keypad buttons must meet minimum **56px × 56px**.

### 4.2 Hardware & POS Formatting (Conditional Extensions)
*(Applicable to retail, field POS, or hardware integrations; mark N/A for standard web apps)*
- **Thermal Receipt Typography**:
  - Maximum printable width: **48mm** (on 58mm paper) or **72mm** (on 80mm paper).
  - Divider lines: `border-t border-dashed border-black` with zero horizontal margins.
  - Font size: `11px`, line-height `1.25`, pure monochrome black text on white background.
- **Offline / Sync Visual Badges**:
  - Online: Subtle green dot (`--success`) with pulse.
  - Offline: Warm amber badge (`--warning`) displaying pending mutation queue count.
  - Syncing: Animated spinning loader badge (`--info`).
  - Sync Error: Destructive badge (`--destructive`) with interactive retry prompt.

---

## 5. Anti-Slop Rules & Design Defenses
- **Zero Emoticons / Emojis (Icons Only)**: Jangan pernah menggunakan emoticon atau karakter emoji OS (seperti 🚀, 💡, ⚙️, ❌) pada antarmuka; selalu gunakan icon SVG standar yang kohesif (e.g. Lucide, Heroicons).
- **Effects by evidence**: Choose blur, transparency, and shadow from the inspected reference and test them for text contrast, visual hierarchy, and performance on target devices. Remove an effect when it obscures content or adds no useful hierarchy; do not reject it by name alone.
- **Mobile Touch Defense**: All interactive form inputs must maintain `16px` base font size on mobile viewports to prevent iOS Safari auto-zoom; all buttons must satisfy `min-h-[44px]` touch targets.

---

## 6. Complete Root CSS Variables (`src/app/globals.css`)

```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    /* Base Canvas & Cards */
    --background: #FFFFFF;
    --card: #FFFFFF;
    --card-foreground: #18181B;
    --popover: #FFFFFF;
    --popover-foreground: #18181B;

    /* Content & Typography */
    --foreground: #18181B;
    --muted: #F4F4F5;
    --muted-foreground: #71717A;
    --text-placeholder: #71717A;

    /* Borders & Inputs */
    --border: #E4E4E7;         /* Subtle container borders (1.3:1) */
    --input: #71717A;          /* Form input borders (4.8:1 WCAG AA) */
    --ring: #0891B2;           /* Focus ring outline */

    /* Triad Status: Success */
    --success: #065F46;
    --success-border: #A7F3D0;
    --success-bg: #ECFDF5;

    /* Triad Status: Warning */
    --warning: #92400E;
    --warning-border: #FDE68A;
    --warning-bg: #FFFBEB;

    /* Triad Status: Destructive */
    --destructive: #991B1B;
    --destructive-border: #FECACA;
    --destructive-bg: #FEF2F2;

    /* Triad Status: Info */
    --info: #1E40AF;
    --info-border: #BFDBFE;
    --info-bg: #EFF6FF;

    /* Data Visualization Charts */
    --chart-1: #0891B2;
    --chart-2: #10B981;
    --chart-3: #F59E0B;
    --chart-4: #6366F1;
    --chart-5: #EC4899;

    /* Unified Z-Index Stacking Context */
    --z-canvas: 0;
    --z-sticky-nav: 10;
    --z-floating-action: 20;
    --z-page-dropdown: 30;
    --z-modal-backdrop: 40;
    --z-modal-dialog: 50;
    --z-modal-dropdown: 55;
    --z-toast: 60;
    --z-payment-gateway: 999999;
  }

  .dark {
    /* Base Canvas & Cards */
    --background: #09090B;
    --card: #18181B;
    --card-foreground: #F4F4F5;
    --popover: #18181B;
    --popover-foreground: #F4F4F5;

    /* Content & Typography */
    --foreground: #F4F4F5;
    --muted: #27272A;
    --muted-foreground: #A1A1AA;
    --text-placeholder: #A1A1AA;

    /* Borders & Inputs */
    --border: #27272A;
    --input: #71717A;          /* Form input borders (3.7:1 WCAG AA) */
    --ring: #22D3EE;

    /* Triad Status: Success */
    --success: #86EFAC;
    --success-border: #065F46;
    --success-bg: #052E16;

    /* Triad Status: Warning */
    --warning: #FDE047;
    --warning-border: #854D0E;
    --warning-bg: #422006;

    /* Triad Status: Destructive */
    --destructive: #FCA5A5;
    --destructive-border: #991B1B;
    --destructive-bg: #450A0A;

    /* Triad Status: Info */
    --info: #93C5FD;
    --info-border: #1E40AF;
    --info-bg: #172554;

    /* Data Visualization Charts */
    --chart-1: #22D3EE;
    --chart-2: #34D399;
    --chart-3: #FBBF24;
    --chart-4: #818CF8;
    --chart-5: #F472B6;
  }
}
```

---

## 7. Master Component Visual Specifications & Anatomy (Anti-Guessing Contract)

*Every component implemented in `docs/design/components/index.html` and prototype screens MUST adhere to these exact styling structures and class standards. AI agents MUST NOT invent arbitrary styles or fall back to generic unstyled boxes.*

### 7.1 Layout Shell & Navigation Bar (`.navbar`)
- **Top-Navigation Bar (`.navbar-top`)**:
  - Structure: Sticky header `h-16` (64px), `bg-white` (or `--card`), border-b `1px solid var(--border)`, `px-6 md:px-8`, `flex items-center justify-between`.
  - Content Constraint: Centered `max-w-7xl mx-auto w-full`.
  - Brand Logo: Placed on left (`h-9 w-auto`).
  - Nav Pills (`.nav-pill`): Horizontal scrollable list on mobile, inline-flex on desktop.
    - Base: `rounded-full px-4 py-1.5 text-sm font-medium transition-all`.
    - Active: `bg-[var(--primary)] text-white shadow-sm`.
    - Inactive: `text-[var(--muted-foreground)] hover:text-[var(--foreground)] hover:bg-[var(--muted)]`.
  - User Action Bar: Right-aligned notification bell with unread dot + circular photo avatar (`w-9 h-9 rounded-full ring-2 ring-white`).

### 7.2 Button & Action System (`.btn`)
- **Primary Button (`.btn-primary`)**:
  - `h-11 px-5 rounded-xl bg-[var(--primary)] text-white font-medium text-sm inline-flex items-center justify-center gap-2 shadow-sm hover:brightness-105 active:scale-[0.98] focus-visible:ring-2 focus-visible:ring-[var(--primary)] focus-visible:ring-offset-2 transition-all`.
- **Secondary Button (`.btn-secondary`)**:
  - `h-11 px-5 rounded-xl bg-[var(--muted)] text-[var(--foreground)] font-medium text-sm inline-flex items-center justify-center gap-2 hover:bg-slate-200 active:scale-[0.98] transition-all`.
- **Outline Button (`.btn-outline`)**:
  - `h-11 px-5 rounded-xl border border-[var(--input)] bg-white text-[var(--foreground)] font-medium text-sm inline-flex items-center justify-center gap-2 hover:bg-slate-50 active:scale-[0.98] transition-all`.
- **Ghost Button (`.btn-ghost`)**:
  - `h-11 px-4 rounded-xl text-[var(--muted-foreground)] font-medium text-sm inline-flex items-center justify-center gap-2 hover:bg-[var(--muted)] hover:text-[var(--foreground)] transition-all`.
- **Destructive Button (`.btn-destructive`)**:
  - `h-11 px-5 rounded-xl bg-[var(--destructive)] text-white font-medium text-sm inline-flex items-center justify-center gap-2 shadow-sm hover:brightness-105 active:scale-[0.98] transition-all`.
- **Button Loading State**:
  - `disabled opacity-80 cursor-not-allowed inline-flex items-center justify-center gap-2` pairing a spinning SVG loader with text.

### 7.3 Form Input & Data Entry System (`.form-field`)
- **Text & Search Input (`.input`)**:
  - `h-11 px-4 rounded-xl border border-[var(--input)] bg-white text-base text-[var(--foreground)] placeholder:text-[var(--text-placeholder)] focus:outline-none focus:border-[var(--primary)] focus:ring-2 focus:ring-[var(--primary)]/20 transition-all`.
- **Textarea (`.textarea`)**:
  - `min-h-[100px] p-4 rounded-xl border border-[var(--input)] bg-white text-base text-[var(--foreground)] placeholder:text-[var(--text-placeholder)] focus:outline-none focus:border-[var(--primary)] focus:ring-2 focus:ring-[var(--primary)]/20 transition-all`.
- **Currency & Numeric Input (`.currency-input`)**:
  - `inputmode="numeric"` with live thousand-separator dot formatting, without browser spin arrows. Font: tabular numbers.
- **Label (`.form-label`)**:
  - `text-sm font-medium text-[var(--foreground)] mb-1.5 block`.
- **Field Error (`.form-error`)**:
  - `text-xs text-[var(--destructive)] mt-1.5 flex items-center gap-1 font-medium`.
- **Checkbox & Radio**:
  - `w-5 h-5 rounded-md border border-[var(--input)] text-[var(--primary)] focus:ring-[var(--primary)] focus:ring-2 transition-all`.
- **Toggle Switch (`.switch`)**:
  - Track: `w-11 h-6 bg-slate-200 rounded-full transition-colors relative cursor-pointer data-[checked=true]:bg-[var(--primary)]`.
  - Thumb: `w-5 h-5 bg-white rounded-full shadow-md transition-transform transform translate-x-0.5 data-[checked=true]:translate-x-5.5`.

### 7.4 Floating Controls, Select & Popovers
- **Custom Popover Select (`.select-popover`)**:
  - Trigger: `h-11 px-4 rounded-xl border border-[var(--input)] bg-white flex items-center justify-between text-base cursor-pointer`.
  - Floating Menu: `z-55 mt-2 bg-white rounded-2xl border border-[var(--border)] shadow-xl p-2 min-w-[200px] animate-in fade-in zoom-in-95`.
  - Options: `px-3 py-2 rounded-lg text-sm hover:bg-[var(--muted)] cursor-pointer flex items-center justify-between`.
  - Strict Rule: Zero unstyled native `<select>`.
- **Dropdown Menu (`.dropdown-menu`)**:
  - Container: `z-30 bg-white rounded-2xl border border-[var(--border)] shadow-xl p-1.5 min-w-[180px]`.
- **Tooltip (`.tooltip`)**:
  - `z-30 px-2.5 py-1 text-xs bg-slate-900 text-white rounded-lg shadow-md`.

### 7.5 Status Badges, Chips & Avatars
- **Status Badges (`.badge`)**:
  - Structure: `inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold`.
  - Success: `bg-[var(--success-bg)] text-[var(--success)] border border-[var(--success-border)]`.
  - Warning: `bg-[var(--warning-bg)] text-[var(--warning)] border border-[var(--warning-border)]`.
  - Destructive: `bg-[var(--destructive-bg)] text-[var(--destructive)] border border-[var(--destructive-border)]`.
  - Info: `bg-[var(--info-bg)] text-[var(--info)] border border-[var(--info-border)]`.
  - Neutral: `bg-slate-100 text-slate-700 border border-slate-200`.
- **Avatar System (`.avatar`)**:
  - Photo Avatar: `w-10 h-10 rounded-full object-cover ring-2 ring-white shadow-sm`.
  - Online Dot: `w-2.5 h-2.5 bg-emerald-500 rounded-full absolute bottom-0 right-0 ring-2 ring-white`.
  - Strict Rule: Zero raw monochrome initials circles.

### 7.6 Card Archetypes (`.card`)
- **Standard Content Card (`.card-standard`)**:
  - `bg-white border border-[var(--border)] rounded-2xl p-6 shadow-sm (0 1px 3px rgba(0,0,0,0.04))`.
  - Header: `flex items-center justify-between mb-4`.
  - Title: `text-base font-semibold text-[var(--foreground)]`.
- **Hero Featured Card (`.card-hero`)**:
  - Structure: `bg-[var(--primary)] rounded-3xl p-8 text-white relative overflow-hidden grid grid-cols-1 md:grid-cols-2 gap-6 items-center`.
  - Left Col: Badge pill (`bg-white/20 text-white backdrop-blur-sm`), Headline `text-2xl md:text-3xl font-bold`, Subtitle `text-white/80`, White CTA button (`bg-white text-[var(--primary)] font-semibold rounded-xl px-5 py-2.5 shadow-md hover:bg-white/90`).
  - Right Col: Real photo cutout / property thumbnail seamlessly aligned without harsh container borders.
- **Media / Property Listing Card (`.card-property`)**:
  - Structure: `bg-white border border-[var(--border)] rounded-2xl overflow-hidden shadow-sm hover:shadow-md transition-shadow group`.
  - Media Container: `aspect-[16/10] w-full relative overflow-hidden bg-slate-100`. Image: `w-full h-full object-cover group-hover:scale-105 transition-transform duration-300`.
  - Floating Badge: `absolute top-3 left-3 bg-white/90 backdrop-blur-sm px-2.5 py-1 rounded-full text-xs font-semibold text-[var(--foreground)] shadow-sm`.
  - Body (`p-4`): Property title `font-semibold text-base mb-1`, facility chips row `flex gap-2 text-xs text-[var(--muted-foreground)] mb-3`, footer row with bold price `text-base font-bold text-[var(--primary)]` and detail link.
- **Metric KPI Tile (`.card-metric`)**:
  - Structure: `bg-white border border-[var(--border)] rounded-2xl p-5 shadow-sm`.
  - Label: `text-xs text-[var(--muted-foreground)] uppercase tracking-wider mb-1 font-semibold`.
  - Value: `text-2xl font-bold text-[var(--foreground)] tabular-nums`.

### 7.7 Data Table & Mobile Card Reflow System (`.table`)
- **Desktop Data Table (`.table-container`)**:
  - Container: `w-full overflow-x-auto rounded-2xl border border-[var(--border)] bg-white shadow-sm`.
  - Header: `bg-slate-50 border-b border-[var(--border)] text-xs font-semibold text-[var(--muted-foreground)] uppercase tracking-wider px-4 py-3 text-left`.
  - Rows: `border-b border-[var(--border)] hover:bg-slate-50/70 transition-colors px-4 py-3.5 text-sm`.
  - Numbers: Enforce `tabular-nums` on all currencies, dates, and counters.
- **Mobile Table Reflow (<640px) (`.table-mobile-card`)**:
  - Strict Rule: On screens `<640px`, tables MUST unwrap into stacked key-value cards with distinct labels, never hidden horizontal scrollbars.
- **Pagination Controls (`.pagination`)**:
  - Centered row with Previous, active Page Pill (`rounded-lg px-3 py-1.5 text-sm bg-[var(--primary)] text-white`), and Next.

### 7.8 Overlays, Modals & Dialogs (`.modal`)
- **Modal Dialog (`.modal-dialog`)**:
  - Backdrop: `fixed inset-0 bg-black/40 backdrop-blur-sm z-40 flex items-center justify-center p-4`.
  - Container: `bg-white rounded-2xl border border-[var(--border)] shadow-2xl max-w-lg w-full p-6 z-50 animate-in fade-in zoom-in-95`.
  - Header: `flex items-center justify-between pb-4 border-b border-[var(--border)] mb-4`.
  - Footer: `flex items-center justify-end gap-3 pt-4 border-t border-[var(--border)] mt-6`.
- **Confirmation Dialog (`.confirm-dialog`)**:
  - Alert icon badge + Clear destructive confirmation button requiring explicit intent.

### 7.9 Feedback & State Displays
- **Toast Notifications (`.toast`)**:
  - Container: `fixed bottom-5 right-5 z-60 flex flex-col gap-2 max-w-sm w-full`.
  - Toast Card: `bg-white rounded-xl border border-[var(--border)] shadow-lg p-4 flex items-start gap-3 animate-in slide-in-from-bottom-5`.
  - Rule: Error toasts do NOT auto-dismiss.
- **Empty State (`.empty-state`)**:
  - Container: `text-center py-12 px-4 max-w-md mx-auto`.
  - Elements: Centered SVG illustration/icon, Title `font-semibold text-lg text-[var(--foreground)] mb-1`, Description `text-sm text-[var(--muted-foreground)] mb-4`, Action Button CTA.
- **Skeleton Loader (`.skeleton`)**:
  - `bg-slate-200 animate-pulse rounded-xl`.

### 7.10 Signature Domain Organisms
- **Radial Dashed Progress Gauge (`.radial-gauge`)**:
  - SVG circle container `w-28 h-28 relative flex items-center justify-center mx-auto`.
  - Background track: `stroke-[#E2E8F0] stroke-width="8" fill="transparent"`.
  - Active track: `stroke-[var(--primary)] stroke-width="8" stroke-dasharray="6,4" stroke-linecap="round" fill="transparent"`.
  - Center Metric: `absolute inset-0 flex flex-col items-center justify-center text-center`. Value: `text-xl font-bold text-[var(--foreground)]`, Label: `text-[10px] text-[var(--muted-foreground)] uppercase tracking-wider`.
- **Condition / Quality Slider (`.condition-slider`)**:
  - Segmented horizontal track with colored milestone pills indicating room or property inspection quality.
- **Split POS / Catalog Dock (`.pos-dock`)**:
  - Split dual-panel on desktop, sticky floating bottom bar on mobile viewports.

---

## 8. Automated Quality Validation Checklist (DESIGN.md Gate)

*Before finalizing `DESIGN.md`, verify:*

- [ ] **1. Accurate Contrast Labeling**: Secondary text and placeholder ratios are honestly labeled as WCAG AA (≥ 4.5:1) without false AAA claims.
- [ ] **2. Complete Triad Status Tokens**: Every semantic state (`success`, `warning`, `destructive`, `info`) defines text, border, and background variables in both light and dark CSS blocks.
- [ ] **3. Border Separation**: Subtle container boundaries (`--border`) and high-contrast interactive borders (`--input`, ≥ 3:1) maintain separate token definitions.
- [ ] **4. Universal 16px Inputs**: All form inputs specify `text-base` (16px) universally without `md:text-sm` responsive overrides to prevent iOS/iPad auto-zoom.
- [ ] **5. Unified Stacking Scale**: All z-index contexts are declared via CSS variables from canvas (`0`) to modal dropdowns (`55`) and toasts (`60`).
- [ ] **6. Zero Horizontal Overflow Gate**: Validated via browser inspection that `document.body.scrollWidth <= window.innerWidth` across 375px mobile and 1440px desktop viewports.
- [ ] **7. Tabular Figure Compliance**: Financial, numeric, and currency data tables enforce `tabular-nums` (`font-feature-settings: "tnum" 1`).
