# Design System Specification (Anti-Slop Guardrail for Interactive Prototype)

> Foundational design system reference document to upload to Interactive Prototype (`upload_design_md`). Maintains visual consistency and prevents generic interface generation ("AI Slop").

---

## 0. Design Style Choice

> **Source**: Decision made in `COMPONENT_REQUIREMENTS.md` based on PRD analysis

**Chosen Aesthetic**: [Flat Design / Minimalist / Glassmorphism / Brutalist / Material Design]

**Rationale**: [Copy from COMPONENT_REQUIREMENTS.md]

**Reference Examples**:
- [Website 1] - [What to emulate]
- [Website 2] - [Component style]

---

## 1. Design Philosophy & Style-Specific Directives

> Philosophy adapts based on chosen aesthetic (Section 0)

### Default: Flat Design (Recommended for MVP)

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

### Alternative: Glassmorphism

1. **Layered Depth with Transparency**:
   - Use `backdrop-filter: blur(10px)` on cards, modals, overlays
   - Background: `rgba(255, 255, 255, 0.1)` with blur for glass effect
   - Borders: `1px solid rgba(255, 255, 255, 0.1)` (subtle, semi-transparent)
2. **Dark or Colorful Backdrops**:
   - Glassmorphism requires gradient or photo backgrounds (not pure white)
   - Background example: `linear-gradient(135deg, #667eea 0%, #764ba2 100%)`
3. **Soft Shadows for Depth**:
   - Cards: `box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1)`
   - Modals: `box-shadow: 0 16px 64px rgba(0, 0, 0, 0.2)`
4. **Accessibility with Fallbacks**:
   - Always provide solid background fallback for text containers
   - Never place text directly on transparent/blurred surfaces

### Alternative: Brutalist

1. **Bold Contrast & Hard Edges**:
   - Borders: `3px solid #000000` (pure black, no grays)
   - Border radius: `0px` (sharp corners only, no rounding)
   - Shadows: `4px 4px 0 #000000` (hard offset, no blur)
2. **High Impact Typography**:
   - Text transform: `uppercase` for headings
   - Font weight: 700-900 (bold/black weights)
   - Letter spacing: `1-2px` for impact
3. **Asymmetric Layouts**:
   - Break grid intentionally for visual interest
   - Overlapping elements acceptable
   - Raw, unpolished aesthetic
4. **Accessibility Priority**:
   - High contrast mandatory: pure black text on white, or white on black
   - Hard shadows ensure depth perception for interactive elements

### Alternative: Minimalist

1. **Whitespace as Design**:
   - Generous padding: `24-48px` around content blocks
   - Breathing room between elements: `16-32px` gaps
   - Max content width: `65ch` for optimal readability
2. **Typography Hierarchy**:
   - Use font size + weight for hierarchy (not color)
   - Single font family maximum (or 2: sans + mono)
   - Restrained color: 1 accent color, rest grayscale
3. **Invisible Interface**:
   - UI fades to background, content is hero
   - Minimal borders: use whitespace for separation
   - Shadows only when functionally necessary (dropdowns, modals)
4. **Purposeful Elements**:
   - Every element must have clear purpose
   - No decorative additions (icons, illustrations must be functional)

### Alternative: Material Design

1. **Elevation & Shadows**:
   - Cards: `box-shadow: 0 2px 4px rgba(0,0,0,0.1), 0 4px 8px rgba(0,0,0,0.08)`
   - Elevated buttons: `box-shadow: 0 1px 3px rgba(0,0,0,0.12)`
   - Modals: `box-shadow: 0 8px 16px rgba(0,0,0,0.16)`
2. **Motion & Transitions**:
   - Standard easing: `cubic-bezier(0.4, 0.0, 0.2, 1)`
   - Duration: 200-300ms for simple transitions
   - Ripple effects on interactive elements
3. **Grid & Layout**:
   - 8dp baseline grid (8px spacing multiples)
   - Responsive breakpoints: 600px, 960px, 1280px, 1920px
   - 12-column grid system
4. **Color System**:
   - Primary, Secondary, Surface, Background, Error
   - Each color has light/dark variants
   - On-color variants for text contrast

---

## 2. Color Palette & Semantic Tokens (Color Tokens)

> Adapt based on chosen style (Section 0)

### If Flat Design or Minimalist:

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

### If Glassmorphism:

### 2.1 Background (Dark or Colorful Required)
- **Gradient Background**: `linear-gradient(135deg, #667eea 0%, #764ba2 100%)`
- **Alternative**: Dark solid `#1a1a2e` or photo backdrop
- **Surface (Glass)**: `rgba(255, 255, 255, 0.1)` + `backdrop-filter: blur(10px)`
- **Border**: `rgba(255, 255, 255, 0.1)` (subtle outline)
- **Text on Glass**: Always use solid background container for text (`background: #FFFFFF` or `rgba(255,255,255,0.95)`)

### 2.2 Semantic Colors
- **Primary Accent**: Vibrant color (e.g., `#3B82F6` blue)
- **Success**: `#10B981` (brighter green for visibility)
- **Warning**: `#F59E0B` (brighter amber)
- **Error**: `#EF4444` (brighter red)

### If Brutalist:

### 2.1 High Contrast Palette
- **Background**: `#FFFFFF` (pure white)
- **Surface**: `#FFFFFF` (no gray backgrounds)
- **Border**: `#000000` (pure black, 3px)
- **Text**: `#000000` (pure black, no grays)
- **Accent**: High saturation primary color (e.g., `#FF0000` red, `#0000FF` blue, `#FFFF00` yellow)

### 2.2 Semantic Colors (Bold Only)
- **Success**: `#00FF00` (pure green)
- **Error**: `#FF0000` (pure red)
- **Warning**: `#FFFF00` (pure yellow)
- **Info**: `#0000FF` (pure blue)

---

## 3. Typography System

> Font selection based on chosen style

### If Flat Design / Minimalist:

- **Primary UI Font (Sans-Serif)**: `Inter`, `Geist Sans`, or `system-ui, -apple-system, sans-serif`
- **Code / Number / Hash Font (Monospace)**: `JetBrains Mono`, `Geist Mono`, or `monospace`
- **Type Scale Hierarchy**:
  - `h1`: 30px / font-bold / tracking-tight
  - `h2`: 24px / font-semibold / tracking-tight
  - `h3`: 18px / font-medium
  - `body`: 14px / font-normal / leading-relaxed
  - `small / caption`: 12px / font-normal / text-muted

### If Glassmorphism:

- **Primary UI Font**: `Inter Variable`, `SF Pro`, or system-ui
- **Type Scale** (slightly larger for readability on blur):
  - `h1`: 36px / font-semibold / tracking-tight
  - `h2`: 28px / font-semibold
  - `h3`: 20px / font-medium
  - `body`: 16px / font-normal / leading-relaxed
  - `small`: 14px / font-normal

### If Brutalist:

- **Primary UI Font**: `Space Grotesk`, `Archivo Black`, or `Arial Black`
- **Type Scale** (bold weights, uppercase headings):
  - `h1`: 48px / font-black / uppercase / letter-spacing: 2px
  - `h2`: 32px / font-bold / uppercase / letter-spacing: 1px
  - `h3`: 24px / font-bold / uppercase
  - `body`: 16px / font-medium / normal-case
  - `small`: 14px / font-normal

### If Material Design:

- **Primary UI Font**: `Roboto`, `Open Sans`
- **Type Scale** (Material spec):
  - `h1`: 96px / light
  - `h2`: 60px / light
  - `h3`: 48px / regular
  - `h4`: 34px / regular
  - `body1`: 16px / regular
  - `body2`: 14px / regular
  - `caption`: 12px / regular

---

## 4. Component Shapes & Spacing (Geometry & Shapes)

> Border radius and spacing based on chosen style

### If Flat Design:

- **Corner Radius**:
  - Buttons & Input Fields: `6px` (`rounded-md`)
  - Cards & Modal Dialogs: `8px` (`rounded-lg`)
  - Status Badges: `9999px` (`rounded-full`)
- **Grid & Spacing**:
  - Based on **4px / 8-point grid** multiples (`p-2`, `p-4`, `p-6`, `gap-4`, `gap-6`).
  - Mobile touch target: Minimum `44px x 44px`.
- **Shadows**: Minimal or none
  - Cards: `box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05)` (subtle only)
  - Dropdowns: `box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1)`
  - Buttons: No shadow

### If Glassmorphism:

- **Corner Radius**:
  - Buttons: `12px` (rounded-xl)
  - Cards: `16px` (rounded-2xl)
  - Modals: `20px` (rounded-3xl)
  - Badges: `9999px` (rounded-full)
- **Grid & Spacing**:
  - 8px grid multiples
  - Generous padding: `p-6`, `p-8` (more than flat)
- **Shadows**: Soft + Blur
  - Cards: `box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1)` + `backdrop-filter: blur(10px)`
  - Modals: `box-shadow: 0 16px 64px rgba(0, 0, 0, 0.2)` + blur
  - Buttons: `box-shadow: 0 4px 16px rgba(59, 130, 246, 0.3)` (colored glow)

### If Brutalist:

- **Corner Radius**:
  - Everything: `0px` (sharp corners, no rounding)
- **Grid & Spacing**:
  - 8px grid (but asymmetric layouts OK)
  - Touch targets: `44px x 44px` minimum
- **Shadows**: Hard offset
  - Cards: `box-shadow: 6px 6px 0 #000000`
  - Buttons: `box-shadow: 4px 4px 0 #000000`
  - Modals: `box-shadow: 8px 8px 0 #000000`
  - Hover effect: Translate element, reduce shadow

### If Minimalist:

- **Corner Radius**:
  - Buttons: `4px` (subtle)
  - Cards: `8px` (subtle)
  - Inputs: `4px`
- **Grid & Spacing**:
  - Generous whitespace: `p-8`, `p-12` (24-48px)
  - Max content width: `65ch` (optimal reading)
- **Shadows**: Minimal or none
  - Cards: `box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08)` (very subtle)
  - Functional only: dropdowns, modals

### If Material Design:

- **Corner Radius**:
  - Buttons: `4px`
  - Cards: `4px`
  - FABs: `28px` (rounded-full for circular)
- **Grid & Spacing**:
  - 8dp baseline grid
  - Touch targets: `48dp` (48px)
- **Shadows**: Elevation system
  - Level 1: `0 1px 3px rgba(0,0,0,0.12)`
  - Level 2: `0 2px 6px rgba(0,0,0,0.16)`
  - Level 4: `0 4px 8px rgba(0,0,0,0.16)`
  - Level 8: `0 8px 16px rgba(0,0,0,0.16)`

---

## 5. Form & Table Standards

- **Form Inputs**: Must include an explicit text label above the field, neutral gray placeholder, and red validation message area below the field.
- **Data Tables**: Subtle 1px horizontal dividers per row (`divide-y divide-zinc-200`), tight cell padding (`py-3 px-4`), and very light gray header rows (`bg-zinc-50`).
- **Empty State**: Dashed border container (`border-dashed border-2 border-zinc-300`), descriptive text explaining the empty state, and a primary CTA button to create new data.

---

## 6. Accessibility Requirements (All Styles)

> Non-negotiable regardless of aesthetic choice

### Color Contrast
- **Body text**: 4.5:1 minimum (WCAG AA)
- **Large text** (18px+): 3:1 minimum
- **Interactive elements**: 3:1 for borders, icons
- **Testing**: Use WebAIM Contrast Checker

### Focus States
- **Visible focus ring**: 2px solid, high contrast
- **Offset**: 2px from element edge
- **Color**: Primary brand color or high contrast
- **Example**: `outline: 2px solid #3B82F6; outline-offset: 2px;`

### Keyboard Navigation
- **Tab order**: Logical, follows visual flow
- **All interactive elements**: Keyboard accessible
- **Modal focus trap**: Tab cycles within modal
- **Esc key**: Closes modals, dropdowns

### Motion
- **Respect prefers-reduced-motion**: Disable animations for users who request it
- **Fast transitions**: <300ms for UI feedback
- **No auto-play**: Videos, carousels require user action

```css
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

### Transparency & Readability
- **Text on solid backgrounds**: Never text directly on blur/transparency
- **Glassmorphism fallback**: Solid background for text containers
- **Contrast check**: Especially critical for glassmorphism, brutalist bold colors
