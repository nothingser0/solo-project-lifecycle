# UI Generation Prompt: [SCREEN_ID] — [SCREEN_TITLE]

> **Purpose**: Standalone generation prompt to copy-paste into AI prototyping tools (v0.dev, Google Stitch, Bolt.new, Claude Artifacts) or feed to an autonomous frontend agent.
> **Source Documents**: `docs/specs/DESIGN_SPEC.md` and `docs/harness-root/DESIGN.md`
> **Artifact Storage**: Save exported code/components into `docs/design/screens/[screen-id-lowercase]/`

---

## 1. Screen Identity & Business Context
- **Screen ID**: [SCREEN_ID] (e.g., SCR-01, SCR-04)
- **Screen Title**: [SCREEN_TITLE] (e.g., Public Landing Page, Operational Workspace, Deal Detail)
- **URL Route**: `[URL_ROUTE]` (e.g., `/`, `/dashboard`, `/pos`, `/deals/:id`)
- **Feature Code**: `[FEATURE_ID]` (mapped to `SCOPE_STATEMENT.md` F-xx)
- **Access Roles**: [Allowed Roles, e.g., Public, All Authenticated, Manager Only]
- **User Story & Purpose**: [As a role, I want to action, so that outcome]

---

## 2. Design System Tokens & Anti-Slop Guardrails
*(Strictly adhere to semantic tokens from `DESIGN.md`; zero arbitrary unmapped colors)*

- **Typography**:
  - Primary UI Font: `Inter` (with `font-feature-settings: 'tnum'` / tabular numbers for financial and metric data).
  - Monospace Font: `JetBrains Mono` for codes, hashes, currency units, and identifiers.
- **Color Palette & Semantic Triad**:
  - Background Canvas: `bg-background` (`#FFFFFF` in Light / `#09090B` in Dark)
  - Card & Container Surface: `bg-card border border-border` (`#E4E4E7` subtle passive divider)
  - Interactive Form Borders: `border-input` (strict $\ge 3.0:1$ non-text contrast against card background)
  - Text Hierarchy: `text-foreground` (primary high contrast $\ge 7:1$) / `text-muted-foreground` (secondary $\ge 4.5:1$)
  - Status Indicators: Use semantic triads: `--success`, `--warning`, `--destructive`, `--info`.
  - Transaction Convention: Normal business expenses/deductions use neutral badges with arithmetic signs (`-Rp` or `-$`), NEVER destructive red styling.
- **Form Ergonomics & Anti-Zoom**:
  - All form inputs (`<input>`, `<select>`, `<textarea>`) MUST specify `text-base` (`16px`) universally across all viewports to prevent iOS Safari auto-zoom.
  - Submit Buttons: Anti-disabled pristine state (button remains enabled in pristine state; clicking triggers validation with auto-focus to first invalid field).
- **Touch Targets**:
  - All interactive tap targets (buttons, steppers, icon triggers) MUST meet minimum $\ge 44\text{px} \times 44\text{px}$ (`h-11 min-w-11`).
- **Visual Anti-Slop Directives**:
  - NO purple/neon gradients, NO glassmorphism backdrop blur, NO drop shadows $> \text{shadow-md}$.

---

## 3. Layout Structure & Responsive Breakpoints

### 3.1 Adaptive Layout Structure
- **Desktop & Tablet ($\ge 768\text{px}$)**:
  - [Describe desktop layout: e.g. Fixed sidebar 240–260px, sticky topbar 64px, dual-panel split canvas, or centered grid max-w-7xl]
- **Mobile Viewports ($< 768\text{px}$)**:
  - Sticky top header (56px) + bottom navigation bar (64px).
  - Data tables MUST reflow into stacked cards with key-value pairs (prevent unstyled horizontal scrollbars).

---

## 4. Mandatory 5-State Matrix Implementation
*(Every data-driven screen must implement and handle all 5 states)*

1. **Idle / Default**: Full rendered interface populated with realistic domain data (locale-appropriate entities, zero "Product A" placeholders).
2. **Loading Skeleton**: Structural skeleton blocks (`animate-pulse bg-zinc-200 dark:bg-zinc-800`) matching exact card/table row geometry.
3. **Empty State**: Centered illustration / icon, descriptive empty explanation, and primary action button (CTA).
4. **Inline Field Errors**: Descriptive $\ge 13$px red error messages (`text-destructive`) programmatically linked via `aria-describedby`.
5. **Success Feedback**: Immediate visual confirmation toast or status badge transition.
