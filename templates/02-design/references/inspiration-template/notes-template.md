# Design Reference Analysis

> Extract visual patterns from reference screenshots saved in this folder.
> **Purpose**: Guide AI/Stitch to generate components matching reference style, not generic templates.

---

## How to Use This Template

1. **Save reference screenshots** to this folder:
   - `reference-1-dashboard.png` - Main screen layout example
   - `reference-2-forms.png` - Form styling example
   - `reference-3-buttons.png` - Button states and interactions
   - (3-5 screenshots recommended)

2. **Analyze each screenshot** and fill sections below

3. **Extract common patterns** across all references

4. **AI reads this file** to generate DESIGN_SYSTEM.md matching your references

---

## Screenshot Inventory

### Screenshot 1: [filename.png]
**Source**: [Website/App name, URL if public]
**Focus**: [What to extract: dashboard layout, color palette, typography]

**Observations**:
- **Colors**: Primary #[HEX], Secondary #[HEX], Neutrals [gray scale]
- **Typography**: [Font name], Weights [400/600/700], Sizes [14px body, 24px heading]
- **Spacing**: Padding [Xpx], Gaps [Ypx], Margins [Zpx]
- **Borders**: [Width] [Color], Radius [Xpx]
- **Shadows**: [box-shadow values] or "None"
- **Layout**: [Max width, grid columns, alignment]

---

### Screenshot 2: [filename.png]
**Source**: [Website/App name]
**Focus**: [What to extract]

**Observations**:
- **Colors**: 
- **Typography**: 
- **Spacing**: 
- **Borders**: 
- **Shadows**: 
- **Layout**: 

---

### Screenshot 3: [filename.png]
**Source**: [Website/App name]
**Focus**: [What to extract]

**Observations**:
- **Colors**: 
- **Typography**: 
- **Spacing**: 
- **Borders**: 
- **Shadows**: 
- **Layout**: 

---

## Extracted Common Patterns

> Consolidate patterns seen across ALL screenshots (not outliers)

### Colors

**Primary Brand Color**: #[HEX] - [Description, e.g., "Blue from Linear"]
**Secondary/Accent**: #[HEX] (if present)

**Neutral Scale** (gray tones):
```
Background: #FFFFFF or #[HEX]
Surface: #[HEX] (cards, modals)
Border: #[HEX]
Muted text: #[HEX]
Primary text: #[HEX]
```

**Semantic Colors**:
```
Success: #[HEX] (green)
Error: #[HEX] (red)
Warning: #[HEX] (amber/orange)
Info: #[HEX] (blue)
```

**Rationale**: [Why this palette? Brand alignment, mood, accessibility]

---

### Typography

**Font Family**: [Font name, e.g., "Inter", "SF Pro", "Roboto"]
**Source**: [Google Fonts / System / Custom]

**Weights Used**: [e.g., 400 (regular), 600 (semibold)]
**Weights NOT Used**: [e.g., 300, 500, 700 - keep minimal]

**Type Scale** (observed from screenshots):
```
H1: [size]px / line-height [size]px / weight [400-900]
H2: [size]px / [line-height]px / weight [value]
H3: [size]px / [line-height]px / weight [value]
Body: [size]px / [line-height]px / weight [value]
Small/Caption: [size]px / [line-height]px / weight [value]
```

**Hierarchy Strategy**: [How hierarchy is created]
- Primary: Font weight (400 → 600)
- Secondary: Size (14px → 20px → 24px)
- Tertiary: Color (#111827 → #6B7280 muted)

---

### Spacing & Layout

**Grid System**: [4px / 8px base, or custom]

**Spacing Scale** (padding, margins, gaps):
```
Tight: [value]px
Comfortable: [value]px
Loose: [value]px
Extra loose: [value]px
```

**Common Padding**:
- Buttons: [horizontal]px × [vertical]px
- Cards: [value]px
- Containers: [value]px
- Input fields: [horizontal]px × [vertical]px

**Layout Constraints**:
- Max content width: [value]px
- Grid columns: [number] columns
- Container padding: [mobile]px mobile, [desktop]px desktop

**Touch Targets**: [minimum size, e.g., 44×44px for mobile buttons]

---

### Borders & Corners

**Border Width**: [1px / 2px / 3px]
**Border Color**: #[HEX] - [e.g., "Light gray #E5E7EB"]
**Border Style**: [solid / dashed / none]

**Corner Radius** (observed from screenshots):
```
Buttons: [value]px (e.g., 6px, 8px, or 0px sharp)
Input fields: [value]px
Cards: [value]px
Modals: [value]px
Badges/Pills: [value]px or 9999px (fully rounded)
```

**Consistency**: [Are all components using same radius? Or varied?]

---

### Shadows & Depth

**Shadow Strategy**: [None / Minimal / Soft / Bold / Layered]

**Shadow Values** (extracted from screenshots):
```
Buttons: [box-shadow value or "None"]
Cards: [box-shadow value]
Dropdowns: [box-shadow value]
Modals: [box-shadow value]
```

**Example:**
```css
/* Minimal/Flat */
box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);

/* Soft SaaS */
box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);

/* None */
box-shadow: none; /* Flat design, borders only */
```

**Elevation Hierarchy**: [How depth is communicated]
- Base: No shadow (flat surface)
- Level 1: Subtle shadow (cards)
- Level 2: Medium shadow (dropdowns)
- Level 3: Strong shadow (modals, overlays)

---

### Interaction States

**Button States** (observed):
```
Default: [background color, border, shadow]
Hover: [changes on hover]
Active/Pressed: [changes on click]
Disabled: [opacity, cursor, color changes]
Loading: [spinner position, button disabled state]
```

**Input States**:
```
Default: [border color, background]
Focus: [border color change, focus ring, shadow]
Error: [border color, background, icon]
Disabled: [opacity, cursor]
```

**Link States**:
```
Default: [color, underline]
Hover: [color change, underline appear/disappear]
Visited: [color]
Active: [color]
```

---

### Animation & Motion

**Transition Speed**: [fast <150ms / medium 200-300ms / slow >300ms]
**Easing**: [ease / ease-in-out / cubic-bezier / linear]

**Common Transitions**:
```
Button hover: [property] [duration] [easing]
Modal open: [property] [duration] [easing]
Dropdown: [property] [duration] [easing]
```

**Motion Principle**: [Minimal/functional or expressive/animated?]

---

## Style Classification

Based on extracted patterns above, the design style is:

**Detected Style**: [Flat Design / Minimalist / Glassmorphism / Brutalist / Material Design / Custom Hybrid]

**Characteristics**:
- [ ] Flat colors (no gradients)
- [ ] Minimal/no shadows
- [ ] 1px borders
- [ ] Subtle corner rounding (4-8px)
- [ ] High information density
- [ ] Clean, professional aesthetic
- [ ] [Add other observed characteristics]

**Why This Classification**:
[Explain what patterns led to this classification]

Example:
```
Flat Design: All 3 references use 1px borders, minimal shadows
(0 1px 2px max), solid colors (no gradients), and 6-8px radius.
Layout is clean, structured, information-dense. Matches Linear,
Stripe, Vercel approach.
```

---

## Design Principles (3-5 Rules)

Based on references, establish core design rules:

1. **[Principle 1]**: [Description]
   - Example: "Clarity over decoration - shadows only for functional elevation"

2. **[Principle 2]**: [Description]
   - Example: "High contrast text - all text meets WCAG AA (4.5:1 minimum)"

3. **[Principle 3]**: [Description]
   - Example: "Consistent spacing - 8px grid system, no arbitrary values"

4. **[Principle 4]**: [Description]

5. **[Principle 5]**: [Description]

---

## Component Style Examples

Based on references, document how key components should look:

### Button (Primary)

```css
.button-primary {
  /* Extracted from references */
  background: #[HEX from references];
  color: #[text color];
  border: [width] [style] #[color] or none;
  border-radius: [value]px;
  padding: [vertical]px [horizontal]px;
  font-weight: [400-900];
  font-size: [size]px;
  box-shadow: [value or none];
  transition: [property] [duration] [easing];
}

.button-primary:hover {
  background: #[hover color];
  /* Other hover changes */
}
```

---

### Card

```css
.card {
  background: #[HEX];
  border: [width] [style] #[color];
  border-radius: [value]px;
  padding: [value]px;
  box-shadow: [value or none];
}
```

---

### Input Field

```css
.input {
  background: #[HEX];
  border: [width] [style] #[color];
  border-radius: [value]px;
  padding: [vertical]px [horizontal]px;
  font-size: [size]px;
  transition: border [duration] [easing];
}

.input:focus {
  border-color: #[focus color];
  outline: [ring width] solid #[color];
  outline-offset: [value]px;
  box-shadow: [focus ring shadow or none];
}

.input.error {
  border-color: #[error color];
}
```

---

## Anti-Patterns (What NOT To Do)

Based on reference analysis:

- ❌ **Don't use**: [Pattern not seen in any references]
  - Example: "Don't use gradients - all references use solid colors"

- ❌ **Don't use**: [Pattern contradicts references]
  - Example: "Don't use heavy shadows - references use minimal or none"

- ❌ **Don't use**: [Pattern would break consistency]
  - Example: "Don't mix shadow styles - be consistent with minimal approach"

- ❌ **Don't use**: [Pattern would hurt accessibility]
  - Example: "Don't reduce contrast for aesthetic - references prioritize readability"

---

## Accessibility Validation

> Ensure reference-based design doesn't compromise accessibility

### Color Contrast Check

Using extracted colors above:

- [ ] **Primary text on background**: [ratio, e.g., 16:1] ✅ PASSES WCAG AA
- [ ] **Muted text on background**: [ratio, e.g., 4.6:1] ✅ PASSES WCAG AA
- [ ] **Primary button text**: [ratio] ✅/❌
- [ ] **Error text**: [ratio] ✅/❌

**Testing Tool**: Use [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)

If any fail, adjust color while maintaining reference aesthetic.

---

### Focus Indicators

Based on references:

- **Focus ring color**: #[HEX from primary or contrast color]
- **Ring width**: [2px recommended]
- **Ring offset**: [2px recommended]
- **Ring style**: [solid / dashed]

```css
:focus-visible {
  outline: 2px solid #[color];
  outline-offset: 2px;
}
```

---

### Motion Accessibility

- [ ] **Respect prefers-reduced-motion**: Yes/No
- [ ] **Fast transitions** (<300ms): Yes/No
- [ ] **No auto-play**: Videos, carousels require user action

```css
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## Implementation Checklist

Before generating DESIGN_SYSTEM.md:

- [ ] All screenshots analyzed (3-5 minimum)
- [ ] Common patterns extracted (colors, typography, spacing, shadows)
- [ ] Style classification determined
- [ ] Design principles written (3-5 rules)
- [ ] Component examples provided (Button, Card, Input minimum)
- [ ] Anti-patterns documented
- [ ] Accessibility validated (contrast ratios checked)
- [ ] Ready for DESIGN_SYSTEM.md generation

---

## Next Steps

1. **Save this file** as `notes.md` in `references/design/inspiration/`
2. **AI reads this file** to generate `DESIGN_SYSTEM.md`
3. **Review generated DESIGN_SYSTEM.md** against original references
4. **Adjust if needed** (iterate on notes.md, regenerate)

---

**This file is the source of truth for design style. Keep it updated as references change.**
