# Design System Specification & CSS Tokens (DESIGN.md)

> **Purpose**: Definitive design system tokens and visual engineering rules for AI coding agents. Deployed to `docs/harness-root/DESIGN.md` in Module 04 and root `./DESIGN.md` in Module 06.
> **Standard**: Strict WCAG 2.2 Level AA compliance, calibrated triad semantic tokens, iOS-safe 16px inputs, and unified multi-theme CSS variables.
> **Domain & Scale**: Adaptable across all software categories (CRM, CMS, HRIS, E-Commerce, Retail POS, Fintech, SaaS, Developer Tools) and scales (Small MVP to Enterprise).

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
| `--border` (Subtle)| `#E4E4E7` | 1px passive container divider | `#FFFFFF` | 1.30 : 1 | Passive Boundary |
| `--input` (Border) | `#71717A` | Interactive form & button border| `#FFFFFF` | **4.83 : 1** | PASS (WCAG 1.4.11 $\ge 3:1$) |
| `--primary` | `#[BRAND_HEX]`| Primary brand accent / CTA | `#FFFFFF` | $\ge 4.5 : 1$ | PASS (WCAG AA) |

### 1.2 Dark Mode Color Tokens (Base Surface: `#09090B` / Canvas: `#121214`)

| Token Name | HEX Value | UI Role | Tested Background | Contrast Ratio | Compliance Standard |
| :--- | :---: | :--- | :---: | :---: | :---: |
| `--background` | `#09090B` | Dark viewport background | - | - | Base Canvas |
| `--card` | `#18181B` | Elevated card container | `#09090B` | 1.15 : 1 | Elevated Surface |
| `--foreground` | `#F4F4F5` | Dark mode primary headings & body | `#09090B` | **18.10 : 1** | PASS (WCAG AAA) |
| `--muted-foreground` | `#A1A1AA` | Dark mode secondary text | `#09090B` | **7.76 : 1** | PASS (WCAG AAA) |
| `--text-placeholder`| `#A1A1AA` | Dark mode input placeholder | `#18181B` | **6.91 : 1** | PASS (WCAG AA) |
| `--border` (Subtle)| `#27272A` | Passive container divider | `#09090B` | 1.25 : 1 | Passive Boundary |
| `--input` (Border) | `#71717A` | Interactive form border | `#18181B` | **3.67 : 1** | PASS (WCAG 1.4.11 $\ge 3:1$) |
| `--primary` | `#[BRAND_DARK]`| Primary brand accent / CTA | `#09090B` | $\ge 4.5 : 1$ | PASS (WCAG AA) |

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

### 3.1 Font Family Declarations
- **Primary UI / Body Font**: `Inter` (weights: 400, 500, 600, 700)
- **Monospace / Numeric Font**: `JetBrains Mono` (weights: 400, 700) for codes, currency, hashes, and SKU identifiers.

### 3.2 Form Input Anti-Zoom Rule (iOS & iPad Safari)
- All form inputs (`<input>`, `<select>`, `<textarea>`) **MUST BE AT LEAST `16px` (`text-base`) across ALL viewports**.
- **PROHIBITED**: Applying `text-base md:text-sm` to inputs. This triggers automatic viewport zoom on iPads and touch screens $\ge 768\text{px}$, distorting layout shells.
- **Inputmode Differentiation**:
  - Currency / Integer inputs: Use `inputmode="numeric"` with live dot/comma thousands formatting. NEVER use `<input type="number">`.
  - Fractional quantities (Kg/Liter): Use `inputmode="decimal"`.

---

## 4. Touch Ergonomics & Specialized Hardware Geometry

### 4.1 Touch Targets (Comfort & AAA Standard)
- Primary tap targets on touch and mobile devices **MUST be $\ge 44\text{px} \times 44\text{px}$** (`h-11 min-w-11`).
- *Note*: While WCAG 2.2 Level AA establishes 24px minimum (SC 2.5.8), $44\text{px}$ is our internal ergonomics baseline to prevent mis-taps on tablet/touch terminals.
- Numeric Keypads (if applicable): Keypad buttons must meet minimum **$56\text{px} \times 56\text{px}$**.

### 4.2 Hardware & POS Formatting (Conditional Extensions)
*(Applicable to retail, field POS, or hardware integrations; mark N/A for standard web apps)*
- **Thermal Receipt Typography**:
  - Maximum printable width: **$48\text{mm}$** (on 58mm paper) or **$72\text{mm}$** (on 80mm paper).
  - Divider lines: `border-t border-dashed border-black` with zero horizontal margins.
  - Font size: `11px`, line-height `1.25`, pure monochrome black text on white background.
- **Offline / Sync Visual Badges**:
  - Online: Subtle green dot (`--success`) with pulse.
  - Offline: Warm amber badge (`--warning`) displaying pending mutation queue count.
  - Syncing: Animated spinning loader badge (`--info`).
  - Sync Error: Destructive badge (`--destructive`) with interactive retry prompt.

---

## 5. Complete Root CSS Variables (`src/app/globals.css`)

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

## 6. Automated Quality Validation Checklist (DESIGN.md Gate)

*Before finalizing `DESIGN.md`, verify:*

- [ ] **1. Accurate Contrast Labeling**: Secondary text and placeholder ratios are honestly labeled as WCAG AA ($\ge 4.5:1$) without false AAA claims.
- [ ] **2. Complete Triad Status Tokens**: Every semantic state (`success`, `warning`, `destructive`, `info`) defines text, border, and background variables in both light and dark CSS blocks.
- [ ] **3. Border Separation**: Subtle container boundaries (`--border`) and high-contrast interactive borders (`--input`, $\ge 3:1$) maintain separate token definitions.
- [ ] **4. Universal 16px Inputs**: All form inputs specify `text-base` (16px) universally without `md:text-sm` responsive overrides to prevent iOS/iPad auto-zoom.
- [ ] **5. Unified Stacking Scale**: All z-index contexts are declared via CSS variables from canvas (`0`) to modal dropdowns (`55`) and toasts (`60`).
