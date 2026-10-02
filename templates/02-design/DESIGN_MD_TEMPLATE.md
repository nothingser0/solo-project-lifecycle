# Design System Specification (Anti-Slop Guardrail for Google Stitch)

> Foundational design system reference document to upload to Google Stitch (`upload_design_md`). Maintains visual consistency and prevents generic interface generation ("AI Slop").

---

## 1. Design Philosophy & Anti-Slop Directives (Core Directives)

1. **Flat & Structured First**:
   - DO NOT use heavy drop shadows (*thick/colored drop-shadows*) or floating cards (*floating cards*).
   - Use flat 1px neutral borders (`border border-zinc-200 dark:border-zinc-800`) to separate data containers.
2. **Neutral Monochrome + Single Accent Color**:
   - DO NOT use neon color gradients or generic AI-typical random purple.
   - 90% of components use a neutral gray palette (Zinc). Use only **1 primary brand accent color** for Call-to-Action (CTA) buttons and active links.
3. **Real Data & Information Density (Data-Dense)**:
   - DO NOT use dummy Latin text (*Lorem Ipsum*).
   - All text must use real business/domain terminology matching the application context (currency format e.g. `$`/`Rp`, localized dates, real organization names).
4. **Strict Accessibility Compliance (WCAG 2.1 AA)**:
   - Text contrast ratio against background color must be at least **4.5 : 1**.

---

## 2. Color Palette & Semantic Tokens (Color Tokens)

### 2.1 Light Mode (Standard)
- **Primary Background**: `#FFFFFF`
- **Surface / Card Background**: `#F4F4F5` (Zinc-100)
- **Border**: `#E4E4E7` (Zinc-200)
- **Primary Text (Headings & Body)**: `#09090B` (Zinc-950) — *Contrast ratio: 19.8 : 1 (Passes AAA)*
- **Muted Text (Placeholder & Helper)**: `#71717A` (Zinc-500) — *Contrast ratio: 4.6 : 1 (Passes AA)*

### 2.2 Dark Mode (Optional)
- **Primary Background**: `#09090B` (Zinc-950)
- **Surface / Card Background**: `#18181B` (Zinc-900)
- **Border**: `#27272A` (Zinc-800)
- **Primary Text**: `#FAFAFA` (Zinc-50)
- **Muted Text**: `#A1A1AA` (Zinc-400)

### 2.3 Accent & Functional Semantic Colors
- **Brand Primary Accent**: `#[HEX_BRAND]` (Example Slate Navy: `#0F172A` or Emerald: `#059669`)
- **Success Status**: `#16A34A` (Green-600)
- **Warning Status**: `#D97706` (Amber-600)
- **Destructive / Error Status**: `#DC2626` (Red-600)

---

## 3. Typography System

- **Primary UI Font (Sans-Serif)**: `Inter`, `Geist Sans`, or `system-ui, -apple-system, sans-serif`
- **Code / Number / Hash Font (Monospace)**: `JetBrains Mono`, `Geist Mono`, or `monospace`
- **Type Scale Hierarchy**:
  - `h1`: 30px / font-bold / tracking-tight
  - `h2`: 24px / font-semibold / tracking-tight
  - `h3`: 18px / font-medium
  - `body`: 14px / font-normal / leading-relaxed
  - `small / caption`: 12px / font-normal / text-muted

---

## 4. Component Shapes & Spacing (Geometry & Shapes)

- **Corner Radius**:
  - Buttons & Input Fields: `6px` (`rounded-md`)
  - Cards & Modal Dialogs: `8px` (`rounded-lg`)
  - Status Badges: `9999px` (`rounded-full`)
- **Grid & Spacing**:
  - Based on **4px / 8-point grid** multiples (`p-2`, `p-4`, `p-6`, `gap-4`, `gap-6`).
  - Mobile touch target: Minimum `44px x 44px`.

---

## 5. Form & Table Standards

- **Form Inputs**: Must include an explicit text label above the field, neutral gray placeholder, and red validation message area below the field.
- **Data Tables**: Subtle 1px horizontal dividers per row (`divide-y divide-zinc-200`), tight cell padding (`py-3 px-4`), and very light gray header rows (`bg-zinc-50`).
- **Empty State**: Dashed border container (`border-dashed border-2 border-zinc-300`), descriptive text explaining the empty state, and a primary CTA button to create new data.
