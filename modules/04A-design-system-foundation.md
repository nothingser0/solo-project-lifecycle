# Modul 04A: Design System Foundation & Implementation

Modul ini adalah panduan komprehensif untuk solo developer dan tim kecil yang ingin membangun, mengadopsi, atau mengaudit Design System. Berbeda dengan **Modul 04 (UI/UX Prototyping)** yang fokus pada prototyping layar individual dengan Google Stitch, **Modul 04A** adalah fondasi strategis untuk membangun sistem desain yang scalable, maintainable, dan dapat diadopsi di seluruh produk atau organisasi.

> 🎯 **KAPAN MENGGUNAKAN MODUL 04A?**
> - Proyek **Besar/Enterprise** dengan multiple products atau platform (Web, iOS, Android, Flutter)
> - Produk dengan **3+ engineer** yang butuh konsistensi visual tanpa review manual
> - Startup yang berencana **scale tim design/engineering** dalam 6-12 bulan
> - Refactoring codebase lama dengan **inconsistent UI components** (design debt)
> - Client request **white-label solution** atau **multi-tenant branding**
>
> **SKIP MODUL 04A jika:**
> - MVP solo dev <4 minggu dengan 1-3 layar (cukup Modul 04 Google Stitch)
> - Prototyping proof-of-concept yang akan dibuang
> - Backend API-only atau CLI tool tanpa GUI

---

## 1. Terminologi Kritis (Disambiguation)

Istilah-istilah ini sering dipakai campur aduk. Definisi di bawah adalah standar industri 2024-2026:

| Istilah | Definisi | Contoh Konkret | Deliverable Utama |
|---------|----------|----------------|-------------------|
| **Design System** | Ekosistem lengkap: design tokens + component library + documentation + governance | Material Design (Google), Polaris (Shopify), Carbon (IBM) | Figma library + React components + docs site |
| **Design Language** | Prinsip filosofis visual & tone of voice tanpa implementasi kode | Fluent Design (Microsoft), Human Interface Guidelines (Apple) | PDF guideline, brand book |
| **Pattern Library** | Katalog solusi UI untuk kasus umum (navigation, forms, data display) | Navigation patterns (drawer, tabs, breadcrumb) | Storybook / Zeroheight |
| **Component Library** | Kumpulan komponen UI yang sudah di-code (buttons, inputs, cards) | Chakra UI, Shadcn, MUI, Ant Design | NPM package / Git submodule |
| **Design Tokens** | Variabel atomic untuk visual properties (color, spacing, typography) | `--color-primary-500: #3B82F6;` | JSON / CSS variables / Swift enums |

**Atomic Design Methodology (Brad Frost)**:
```text
Atoms (button, input, icon)
  ↓
Molecules (search bar = input + button)
  ↓
Organisms (header = logo + nav + search bar + user menu)
  ↓
Templates (page layout with placeholders)
  ↓
Pages (templates filled with real content)
```

**Decision Tree: Build vs Adopt**:
```text
Start → Do you need custom branding? 
        ├─ No → Adopt Shadcn (headless) or Chakra (opinionated)
        └─ Yes → Do you have 3+ designers?
                 ├─ No → Adopt + override tokens (Tailwind custom theme)
                 └─ Yes → Build custom DS (this module)
```

---

## 2. Making a Design System (Strategic Process)

### 2.1 Phase 1: Design Audit (The Inventory)

**Objective**: Expose inconsistency debt across existing product.

**Audit Checklist** (Template: `templates/02-design/DESIGN_SYSTEM_AUDIT_TEMPLATE.md`):
1. **Color Inventory**:
   - Screenshot all unique colors → Extract hex codes (Figma plugin: Stark)
   - Typical finding: 47 shades of gray when only need 10
   - Grouping strategy: Cluster similar colors within Delta E < 3 (perceptual difference)

2. **Typography Audit**:
   - Count font families (web safe limit: 2-3 max)
   - List all font sizes in use (typical chaos: 14px, 14.5px, 15px, 16px all for body text)
   - Map to type scale: Heading 1-6, Body, Caption, Overline

3. **Spacing Inconsistency**:
   - Measure gaps between elements (DevTools overlay)
   - Common finding: 12px, 14px, 15px, 16px, 18px, 20px (should be 8pt grid: 8, 16, 24, 32)

4. **Component Duplication**:
   - Count button variants (primary, secondary, ghost, danger, success, etc.)
   - Find duplicate implementations (3 different "Card" components doing same thing)

**Output**: Spreadsheet dengan kolom [Component Type, Location, Screenshot, Consolidation Plan]

### 2.2 Phase 2: Stakeholder Alignment

**Critical Stakeholders**:
| Role | Interest | Approval Power | Communication Cadence |
|------|----------|----------------|----------------------|
| **Engineering Lead** | Bundle size, migration effort | High (veto breaking changes) | Weekly sync |
| **Product Manager** | Feature velocity impact | Medium | Bi-weekly checkpoint |
| **Design Lead** | Visual consistency, adoption | High (design decisions) | Daily collaboration |
| **Marketing** | Brand compliance | Medium (brand assets) | Monthly review |

**Alignment Workshop Agenda** (2 jam):
1. Show audit findings (inconsistency screenshots)
2. Present business case: "Design debt is costing us X hours/week"
3. Demo reference DS (Material Design, Polaris)
4. Agree on **MVP component set** (20 core components, bukan 50)
5. Define success metrics (adoption rate, design review cycle time)

### 2.3 Phase 3: Governance Model

**Option A: Centralized (Small Team <10 people)**:
- 1 "Design System Owner" (50% bandwidth allocation)
- All changes go through central review
- Fast decision, consistent quality, bottleneck risk

**Option B: Federated (Scale Team >20 people)**:
- Each squad has "DS Champion" (10% bandwidth)
- RFC (Request for Comments) process untuk new components
- Slower decision, decentralized ownership, higher adoption

**Versioning Strategy**:
```text
Semantic Versioning for Design:
v1.2.3
│ │ └─ Patch: Bug fixes, accessibility improvements (non-breaking)
│ └─── Minor: New components, new variants (backward compatible)
└───── Major: Breaking API changes, token renames
```

**Release Cadence**:
- Patch: Weekly (hotfixes)
- Minor: Bi-weekly (new features)
- Major: Quarterly (with 3-month migration window)

### 2.4 Phase 4: Adoption Roadmap

**Pilot Team Strategy** (avoid "big bang" rollout):
```text
Week 1-2:  Pick 1 squad, migrate 1 feature (e.g., Settings page)
Week 3-4:  Collect feedback, iterate on DX (Developer Experience)
Week 5-8:  Gradual rollout to 3 more squads
Week 9-12: Mandate for new features, brownfield migration starts
```

**Adoption Metrics Dashboard**:
- **Coverage**: % of screens using DS components (target: 80% in 6 months)
- **Consistency Score**: Automated visual regression test pass rate
- **Velocity**: Design-to-code handoff time (baseline vs DS-enabled)
- **Support Burden**: # of "how to use DS" Slack questions per week

---

## 3. Design Language (Principles → Specifications)

### 3.1 Visual Principles (Foundation Manifesto)

**Example: Solo Dev E-commerce Design Principles**:
1. **Clarity over Cleverness**: No mystery meat navigation, label everything
2. **Speed Perception**: Skeleton loaders, optimistic UI updates
3. **Trust Signals**: Security badges on checkout, real customer reviews
4. **Accessibility Baseline**: WCAG 2.1 AA non-negotiable

**Translating to Specs**:
| Principle | Concrete Specification |
|-----------|----------------------|
| Clarity | Minimum tap target: 44x44px, label every icon |
| Speed | Max 200ms button feedback, skeleton during fetch |
| Trust | SSL badge visible on checkout, Trustpilot widget |
| Accessibility | Color contrast ≥4.5:1, keyboard nav for all actions |

### 3.2 8pt Spacing Scale

```css
/* Base unit: 8px */
--space-0: 0;
--space-1: 0.125rem;  /* 2px - borders */
--space-2: 0.25rem;   /* 4px - tight spacing */
--space-3: 0.5rem;    /* 8px - base unit */
--space-4: 0.75rem;   /* 12px - compact */
--space-5: 1rem;      /* 16px - comfortable */
--space-6: 1.5rem;    /* 24px - airy */
--space-8: 2rem;      /* 32px - section gaps */
--space-10: 2.5rem;   /* 40px - large blocks */
--space-12: 3rem;     /* 48px - hero spacing */
```

**Usage Rule**: 90% of spacing should use tokens, 10% custom for edge cases.

### 3.3 Elevation System (Shadows)

```css
--elevation-0: none;  /* Flat surfaces */
--elevation-1: 0 1px 2px rgba(0,0,0,0.05);  /* Cards */
--elevation-2: 0 4px 6px rgba(0,0,0,0.1);   /* Dropdowns */
--elevation-3: 0 10px 15px rgba(0,0,0,0.15); /* Modals */
--elevation-4: 0 20px 25px rgba(0,0,0,0.2);  /* Notifications */
```

**Anti-Pattern**: Arbitrary shadow values like `box-shadow: 2px 3px 5px #888;` (tidak ada di token system).

### 3.4 Motion Design (Duration & Easing)

```css
--duration-fast: 100ms;     /* Hover, focus states */
--duration-base: 200ms;     /* Transitions, slides */
--duration-slow: 300ms;     /* Modals, page transitions */
--duration-slower: 500ms;   /* Complex animations */

--easing-standard: cubic-bezier(0.4, 0.0, 0.2, 1);  /* Material Design standard */
--easing-decelerate: cubic-bezier(0.0, 0.0, 0.2, 1); /* Enter screen */
--easing-accelerate: cubic-bezier(0.4, 0.0, 1, 1);   /* Exit screen */
```

### 3.5 Responsive Breakpoints (Mobile-First)

```css
/* 4 breakpoints, tidak lebih */
--breakpoint-sm: 640px;   /* Phones landscape */
--breakpoint-md: 768px;   /* Tablets portrait */
--breakpoint-lg: 1024px;  /* Tablets landscape, small laptops */
--breakpoint-xl: 1280px;  /* Desktops */
```

**Breakpoint Strategy**:
- Design mobile (375px) first
- Test tablet (768px) second
- Desktop (1280px) last
- No separate "phablet" or "4K" breakpoints (YAGNI)

### 3.6 Dark Mode Strategy

**Option A: Semantic Tokens (Recommended)**:
```css
/* Light mode */
:root {
  --color-bg-primary: #FFFFFF;
  --color-text-primary: #09090B;
  --color-border: #E4E4E7;
}

/* Dark mode */
@media (prefers-color-scheme: dark) {
  :root {
    --color-bg-primary: #09090B;
    --color-text-primary: #FAFAFA;
    --color-border: #27272A;
  }
}
```

**Option B: CSS Variables + Data Attribute**:
```css
[data-theme="light"] { --bg: white; }
[data-theme="dark"] { --bg: black; }
```

**User Preference Detection**:
```typescript
const getTheme = () => {
  const stored = localStorage.getItem('theme')
  if (stored) return stored
  return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
}
```

### 3.7 Voice & Tone Guidelines

| Context | Voice | Example |
|---------|-------|---------|
| **Error Messages** | Clear, blame-free | ✅ "This email is already registered" ❌ "Invalid input" |
| **Empty States** | Encouraging | ✅ "No documents yet. Create your first one?" ❌ "No data" |
| **Success Confirmations** | Concise, affirming | ✅ "Saved" ❌ "Your changes have been successfully saved!" |
| **Loading States** | Transparent | ✅ "Loading your documents..." ❌ "Please wait" |

---

## 4. Design Tokens (The Single Source of Truth)

### 4.1 Token Taxonomy (Naming Convention)

**Format**: `[category]-[property]-[variant]-[state]`

```css
/* Primitive tokens (raw values) */
--color-blue-500: #3B82F6;
--color-gray-900: #09090B;
--font-size-lg: 1.125rem;

/* Semantic tokens (purpose-driven) */
--color-action-primary: var(--color-blue-500);
--color-text-body: var(--color-gray-900);
--font-size-heading-3: var(--font-size-lg);
```

**Why Two Layers?**
- **Primitive**: Design tool origin (Figma color styles)
- **Semantic**: Implementation mapping (button primary = blue-500 today, could be green-600 tomorrow)

### 4.2 Color Token Structure

```json
{
  "color": {
    "primitive": {
      "blue": {
        "50": "#EFF6FF",
        "500": "#3B82F6",
        "900": "#1E3A8A"
      }
    },
    "semantic": {
      "action": {
        "primary": "{color.primitive.blue.500}",
        "primary-hover": "{color.primitive.blue.600}"
      },
      "text": {
        "body": "{color.primitive.gray.900}",
        "muted": "{color.primitive.gray.500}"
      },
      "background": {
        "surface": "{color.primitive.white}",
        "overlay": "rgba(0, 0, 0, 0.5)"
      }
    }
  }
}
```

### 4.3 Platform-Specific Output (Style Dictionary)

**Install Style Dictionary**:
```bash
pnpm add -D style-dictionary
```

**Config**: `style-dictionary.config.js`
```javascript
module.exports = {
  source: ['tokens/**/*.json'],
  platforms: {
    css: {
      transformGroup: 'css',
      buildPath: 'dist/css/',
      files: [{ destination: 'variables.css', format: 'css/variables' }]
    },
    ios: {
      transformGroup: 'ios',
      buildPath: 'dist/ios/',
      files: [{ destination: 'Tokens.swift', format: 'ios-swift/class.swift' }]
    },
    android: {
      transformGroup: 'android',
      buildPath: 'dist/android/',
      files: [{ destination: 'tokens.xml', format: 'android/resources' }]
    }
  }
}
```

**Generated Output**:
```css
/* dist/css/variables.css */
:root {
  --color-action-primary: #3B82F6;
}
```

```swift
// dist/ios/Tokens.swift
public class Tokens {
  public static let colorActionPrimary = UIColor(hex: 0x3B82F6)
}
```

### 4.4 Token Versioning & Migration

**Breaking Change Example**: Rename `--color-primary` → `--color-action-primary`

**Migration Strategy**:
1. **v1.9.0**: Add new token `--color-action-primary` (duplicate)
2. **v1.10.0**: Deprecate `--color-primary` (console warning)
3. **v2.0.0**: Remove `--color-primary` (breaking change)

**Deprecation Warning (CSS)**:
```css
:root {
  --color-primary: var(--color-action-primary); /* DEPRECATED: Use --color-action-primary */
}
```

---

## 5. Core Components (The 20 Essential Components)

### 5.1 Component Priority Matrix

| Priority | Component | Use Cases | Complexity |
|----------|-----------|-----------|------------|
| **P0** (Week 1) | Button, Input, Label, Spinner | Forms, CTAs | Low |
| **P1** (Week 2) | Select, Checkbox, Radio, Toggle | Form controls | Medium |
| **P1** (Week 3) | Card, Modal, Alert, Toast | Content containers, feedback | Medium |
| **P2** (Week 4) | Tooltip, Dropdown, Badge, Avatar | Microinteractions | Medium |
| **P2** (Week 5) | Table, Tabs, Accordion, Breadcrumb | Data display, navigation | High |
| **P3** (Week 6) | Pagination, Progress, Skeleton | States, navigation | Low |

**Stop at P2 untuk MVP** (16 components). P3 optional depending on product type.

### 5.2 Component API Design Principles

**1. Composition over Configuration**:
```tsx
// ❌ BAD: Too many props
<Button variant="primary" size="lg" loading={true} disabled={false} icon="check" />

// ✅ GOOD: Composable
<Button variant="primary" size="lg">
  {isLoading ? <Spinner /> : <CheckIcon />}
  Save Changes
</Button>
```

**2. Controlled vs Uncontrolled**:
```tsx
// Controlled (React state drives value)
<Input value={email} onChange={setEmail} />

// Uncontrolled (DOM drives value, use ref)
<Input defaultValue="hello@example.com" ref={inputRef} />
```

**Rule**: Provide both, default to controlled for forms.

**3. Compound Components Pattern**:
```tsx
// ✅ Flexible API
<Card>
  <Card.Header>
    <Card.Title>Document Title</Card.Title>
  </Card.Header>
  <Card.Body>Content here</Card.Body>
  <Card.Footer>
    <Button>Action</Button>
  </Card.Footer>
</Card>
```

### 5.3 Accessibility Checklist Per Component

**Button Accessibility**:
- [ ] Keyboard: Activates on `Enter` and `Space`
- [ ] Focus: Visible outline (2px solid, high contrast)
- [ ] ARIA: `aria-label` if icon-only, `aria-disabled` if disabled
- [ ] Screen reader: Announces state ("Loading" when spinner visible)

**Modal Accessibility**:
- [ ] Focus trap: Tab cycles within modal only
- [ ] Escape key: Closes modal
- [ ] ARIA: `role="dialog"`, `aria-modal="true"`, `aria-labelledby` pointing to title
- [ ] Backdrop: Click outside closes (unless critical action)

**Table Accessibility**:
- [ ] Semantic HTML: `<table>`, `<thead>`, `<tbody>`, `<th>`, `<td>`
- [ ] Sort indicators: `aria-sort="ascending"` on sortable columns
- [ ] Keyboard: Arrow keys navigate cells (complex tables only)

**Template**: `templates/02-design/COMPONENT_API_SPEC_TEMPLATE.md` — Includes props table, states, accessibility checklist, usage examples.

---

## 6. Tooling & Workflow

### 6.1 Figma Setup (Design Tool of Record)

**Library Structure**:
```
📂 Design System (Master Library)
  ├─ 🎨 Foundations
  │   ├─ Colors (Styles)
  │   ├─ Typography (Text Styles)
  │   └─ Spacing (Grid Layouts)
  ├─ 🧩 Components
  │   ├─ Button (Variants: Primary, Secondary, Ghost)
  │   ├─ Input (Variants: Default, Error, Disabled)
  │   └─ ...
  └─ 📐 Templates
      ├─ Auth Flow
      └─ Dashboard Layout
```

**Figma Variants Best Practice**:
- Max 3-4 properties per component (variant, size, state, icon)
- Boolean properties for states (`isLoading`, `isDisabled`)
- Avoid combinatorial explosion (4 sizes × 3 variants × 2 states = 24 variants max)

### 6.2 Figma Plugins (Essential 5)

| Plugin | Function | Use Case |
|--------|----------|----------|
| **Tokens Studio** | Sync design tokens JSON ↔ Figma | Import Style Dictionary output to Figma styles |
| **A11y - Color Contrast Checker** | WCAG compliance check | Flag text with <4.5:1 contrast ratio |
| **Content Reel** | Populate with realistic data | Replace "Lorem ipsum" with real product names |
| **Figma to Code (Anima)** | Export Figma → React/Vue | Generate component scaffolding (50% time saving) |
| **Similayer** | Select all similar layers | Batch update 50 buttons at once |

### 6.3 Code Generation (Figma → Code)

**Tool Options**:
| Tool | Output Quality | Pricing | Best For |
|------|---------------|---------|----------|
| **Anima** | 70% production-ready | $31/mo | React, Vue |
| **Figma Dev Mode** | 50% reference code | Free | Copy CSS, inspect spacing |
| **Locofy** | 80% for simple layouts | $25/mo | Landing pages |

**Realistic Workflow**:
```text
Designer creates component in Figma
  ↓
Run Anima export → Get React scaffolding
  ↓
Developer refines: Add logic, accessibility, error handling (30-50% manual work)
  ↓
Publish to Storybook
```

**Anti-Pattern**: Expect 100% auto-generation. Code gen is *scaffolding*, not *final product*.

### 6.4 Version Control for Design (Figma Branching)

**Branching Strategy**:
```
main (Production DS)
  ├─ feature/new-button-variant (Designer A)
  └─ feature/dark-mode-tokens (Designer B)
```

**Merge Review Checklist**:
- [ ] No breaking changes to existing components (unless major version)
- [ ] Accessibility audit passed (contrast, keyboard nav)
- [ ] Documented in Storybook (if component change)

**Alternative to Figma Branching**: **Abstract** (deprecated 2024), **Zeplin** (legacy), **Storybook as design tool** (emerging 2025-2026).

### 6.5 CI/CD for Design Systems

**Automated Pipeline**:
```yaml
# .github/workflows/design-system.yml
name: DS CI/CD
on: [push]
jobs:
  build:
    - run: pnpm install
    - run: pnpm run build:tokens  # Style Dictionary build
    - run: pnpm run build:components
    - run: pnpm test:visual  # Chromatic visual regression
    - run: pnpm run deploy:storybook  # Deploy to Chromatic / Vercel
```

**Visual Regression Testing (Chromatic)**:
```bash
pnpm add -D chromatic
npx chromatic --project-token=<token>
```

**NPM Publishing Workflow**:
```bash
# Bump version
pnpm version minor
# Build
pnpm run build
# Publish to npm
pnpm publish
```

---

## 7. Product Management for Design Systems

### 7.1 Adoption Metrics (Measurable Success)

**Component Usage Analytics** (Automated):
```javascript
// Track DS component usage in CI
import { analyzeImports } from '@ds-analytics/scanner'

const report = analyzeImports('./src')
// Output: { Button: 45, Input: 32, CustomButton: 12 }
// Goal: CustomButton → 0 (full DS adoption)
```

**Design Consistency Score**:
```text
Consistency Score = (Screens using DS components / Total screens) × 100
Target: 80% in 6 months
```

### 7.2 Contribution Model (RFC Process)

**When to Create RFC**: New component, breaking API change, major token refactor.

**RFC Template** (`templates/02-design/COMPONENT_RFC_TEMPLATE.md`):
```markdown
# RFC: [Component Name]

## Problem Statement
What user need is unmet by current DS?

## Proposed Solution
Component API, variants, example usage

## Alternatives Considered
Why not extend existing component?

## Accessibility Checklist
Keyboard nav, ARIA roles, screen reader testing

## Breaking Changes
None / Migration guide attached

## Implementation Plan
Timeline, owner, dependencies
```

**Approval Process**:
1. Draft RFC → Post in #design-system Slack
2. 48h comment period
3. Design System Council vote (3-5 members)
4. Approved → Assign to sprint

### 7.3 Breaking Changes Protocol

**Deprecation Timeline** (3 releases):
```text
v1.9.0: Add new API, mark old as deprecated (console.warn)
v1.10.0: Update docs with migration guide
v2.0.0: Remove deprecated API (breaking change)
```

**Migration Guide Template**:
```markdown
# Migration Guide: v1.x → v2.0

## Breaking Changes
1. `Button color` prop renamed to `variant`
   - Before: `<Button color="blue" />`
   - After: `<Button variant="primary" />`

2. Removed: `Input size="xs"`
   - Migration: Use `size="sm"` instead

## Codemod Script
```bash
npx @myds/codemod v1-to-v2 ./src
```

## Timeline
- v2.0 released: Jan 15, 2026
- v1.x support ends: Apr 15, 2026 (3 months)
```

### 7.4 Community Engagement

**Office Hours**:
- Weekly 30min Zoom: "DS Q&A"
- Topics: How to use X component, contribution workflow

**Slack Channel Strategy**:
- `#design-system-updates`: Announcements only (low noise)
- `#design-system-help`: Questions & troubleshooting
- `#design-system-rfcs`: Proposals discussion

**Quarterly Workshops**:
- "Building Accessible Components 101"
- "Contributing Your First Component"
- "Dark Mode Best Practices"

### 7.5 Measuring ROI (Business Case)

**Metrics to Track**:
| Metric | Before DS | After DS (6mo) | Delta |
|--------|-----------|----------------|-------|
| **Design-to-code handoff** | 3-5 days | 1-2 days | -60% |
| **Design review cycle** | 4 iterations | 1-2 iterations | -50% |
| **New feature UI time** | 40h | 16h | -60% |
| **Bug: visual inconsistency** | 12/sprint | 3/sprint | -75% |

**Formula**:
```
ROI = (Time Saved × Hourly Rate × Team Size) - (DS Maintenance Cost)

Example:
Time saved: 24h/sprint/engineer
Hourly rate: $50
Team size: 5 engineers
Sprints/year: 26

Annual saving: 24 × 50 × 5 × 26 = $156,000
DS maintenance: 1 FTE × $80,000 = $80,000
Net ROI: $76,000/year (95% gain)
```

---

## 8. Output Artifacts (Deliverables)

| Artifact | Location | Purpose |
|----------|----------|---------|
| **Design System Audit Report** | `docs/design/DESIGN_SYSTEM_AUDIT.md` | Baseline inconsistency assessment |
| **Design Tokens Spec** | `tokens/design-tokens.json` + `dist/css/variables.css` | Single source of truth for styling |
| **Component API Spec** | `docs/design/COMPONENT_API_SPEC.md` | Props, states, accessibility per component |
| **Storybook Docs Site** | `https://storybook.myapp.com` | Living documentation & component playground |
| **Adoption Dashboard** | Notion / Airtable | Usage metrics, migration tracker |

**Template Sources**:
- `templates/02-design/DESIGN_SYSTEM_AUDIT_TEMPLATE.md`
- `templates/02-design/DESIGN_TOKENS_SPEC_TEMPLATE.md`
- `templates/02-design/COMPONENT_API_SPEC_TEMPLATE.md`

**Reference Guide**:
- `references/technical/DESIGN_SYSTEM_GUIDE.md` — Deep-dive best practices, case studies, tool comparisons

---

## 9. Integration with Other Modules

| Module | Integration Point |
|--------|-------------------|
| **M04 (UI/UX Prototyping)** | Google Stitch uses tokens from M04A; M04A defines system, M04 applies it |
| **M05 (Architecture/FSD)** | Token structure influences CSS architecture (CSS-in-JS vs CSS Modules) |
| **M06 (Development)** | Components published as NPM package, imported in app code |
| **M07 (QA/SIT)** | Visual regression tests via Chromatic, accessibility audit with axe |
| **M10 (Deployment)** | Storybook deployed to static hosting (Vercel/Chromatic) |

---

## 10. Anti-Patterns & Red Flags

| ❌ Anti-Pattern | ✅ Correct Approach |
|----------------|---------------------|
| Build 50 components on Day 1 | Start with 16 core P0/P1 components, iterate |
| No semantic tokens (only primitive colors) | Two-layer tokens: primitive → semantic mapping |
| Figma library without code implementation | Tight sync: Figma component = React component |
| Zero governance (anyone can add components) | RFC process for new components, DS council approval |
| "Design system is a design team project" | Cross-functional: designers + engineers co-own |

---

## 11. Kriteria Kelulusan [GATE] (Gate Exit Criteria)

Modul 04A dinyatakan **LOLOS (PASS)** jika:
- [x] Design audit selesai dengan laporan inconsistency quantified
- [x] Design tokens JSON structure created (primitive + semantic layers)
- [x] Minimum 16 core components (P0 + P1) implemented & documented in Storybook
- [x] Accessibility audit passed: WCAG 2.1 AA compliance for all components
- [x] CI/CD pipeline setup: Visual regression tests + NPM publish workflow
- [x] Adoption plan documented dengan target metrics (80% coverage in 6 months)

---

## 🛑 PROTOKOL [GATE] KELUAR & WAJIB BERHENTI

Setelah Design System foundation artifacts selesai:
1. **DILARANG KERAS langsung melanjutkan tanpa review!**
2. **Verifikasi Diri**:
   - [ ] `read_file('docs/design/DESIGN_SYSTEM_AUDIT.md')` → Confirm audit completed
   - [ ] `read_file('tokens/design-tokens.json')` → Confirm token structure valid
   - [ ] Count implemented components = 16+ (P0 + P1 checklist)
3. Tampilkan ringkasan kepada pengguna:
   - Token count (colors, spacing, typography scales)
   - Component list (P0/P1/P2 breakdown)
   - Storybook URL (if deployed)
4. **AKHIRI RESPON (END TURN)** dan konfirmasi:
   > *"Design System foundation telah selesai: [X] tokens defined, [Y] components implemented. Silakan review Storybook di [URL]. Apakah siap melanjutkan ke implementasi layar dengan Design System ini?"*
