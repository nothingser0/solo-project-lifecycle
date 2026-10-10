# Module 04: UI/UX Design & Prototyping

> **PROTOTYPING OPTIONS (2026)**: Multiple approaches available - Markdown-only, AI tools (v0/Bolt/Lovable), or design tools (Figma).
> **Default workflow**: Choose based on project context (see STEP 2).

> - `references/solo/SOLO_UIUX_GUIDE.md` (Solo dev UI/UX efficiency guide, Component library selection, WCAG contrast, Prototype walkthrough)
> - `references/pm/PM_USER_TESTING_GUIDE.md` (User testing facilitation, Usability test plan)
> - `references/technical/UI_COMPONENT_ANIMATION_LIBRARY.md` (Animation patterns library)
> - `references/technical/ASSET_MANAGEMENT_GUIDE.md` (Images/SVG/WebP/fonts optimization, Favicon package, Accessibility alt text, Performance budgets)
> - `references/technical/AI_DEVELOPMENT_TOOLS_COMPARISON.md` (AI UI prototyping & coding tools benchmark)
> - `references/technical/FIGMA_MCP_SETUP.md` (Figma MCP server installation, live design sync, token setup, usage patterns)
> - `references/technical/DESIGN_SYSTEM_GUIDE.md` (Design system architecture, token hierarchy, component lifecycle)
> - `references/technical/MOBILE_ARCHITECTURE_GUIDE.md` (Mobile viewport responsiveness, touch targets, PWA/native UI guidelines)
> - `templates/02-design/SITEMAP_TEMPLATE.md` (Information architecture & route map template)
> - `templates/02-design/DESIGN_SPEC_TEMPLATE.md` (Full screen wireflow & interaction specification template)
> - `templates/02-design/COMPONENT_RFC_TEMPLATE.md` (RFC template for proposing complex new design components)
> - `templates/02-design/references/inspiration-template/notes-template.md` (Design inspiration extraction and notes template)


This module translates `SCOPE_STATEMENT.md` into 6 authoritative design specification artifacts that serve as the UI source of truth: `docs/specs/SITEMAP.md`, `docs/specs/COMPONENT_REQUIREMENTS.md`, `docs/specs/LOGO_DESIGN_BRIEF.md`, `docs/design/inspiration/notes.md`, `docs/harness-root/DESIGN.md` (staged, deployed to root in M06), and `docs/specs/DESIGN_SPEC.md`. Its focus is information architecture, component inventories, accessibility, design tokens, and comprehensive screen specifications.

> **Default workflow (2026):** Choose prototyping approach based on context. Markdown-first for solo MVP; interactive prototypes (v0/Stitch/Figma) when client needs visual sign-off.

> **Universal Design Artifact Mandate (Semua Skala Wajib Sama)**: Tidak ada pengecualian skala dari Small hingga Enterprise. Setiap proyek WAJIB menghasilkan 6 artefak spesifikasi (`LOGO_DESIGN_BRIEF.md`, `SITEMAP.md`, `COMPONENT_REQUIREMENTS.md`, `notes.md`, `DESIGN.md`, `DESIGN_SPEC.md`), menyelaraskan palet dengan logo di `/assets/logo/`, serta menghasilkan prompt layar di `docs/design/prompts/` dan artefak render/output di `docs/design/screens/`.

> **Output gate:** Module 04 produces design specifications and optional interactive prototypes. Production code is implemented in Module 06 based on these verified specifications.

---

## 1. Module 04 Execution Cycle

```text
[ INPUT: SCOPE_STATEMENT.md & Valid SOW (or M03 Waived for Solo SaaS) ]
                                │
                                ▼
[ STEP 0A: Minimal Logo Design Brief (Pre-Design Phase) ]
  • Product Name, Philosophy, Brand Vibe Keywords, Brand Colors (≤2KB limit)
  • Simpan logo hasil generate di `/assets/logo/` (`logo.svg` / `logo.png`)
  • OUTPUT: docs/specs/LOGO_DESIGN_BRIEF.md & assets/logo/
                                │
                                ▼
[ STEP 0B: SITEMAP.md & Navigation Architecture ]
  • Screen Hierarchy & Route Map mapped from in-scope features
  • 3-5 Critical User Flows & Comprehensive Breadcrumbs
  • Extended Screen Format (States, RBAC, Real Data Context)
  • OUTPUT: docs/specs/SITEMAP.md
                                │
                                ▼
[ STEP 0C: Component Discovery & UI Pattern Analysis ]
  • Read SCOPE_STATEMENT.md & SITEMAP.md → Map features & routes to UI patterns
  • 3-Tier Component Inventory (Primitives, Standard, Domain Composites)
  • Define interaction states, Anti-Disabled Pristine rule, WCAG 2.2 AA protocols
  • OUTPUT: docs/specs/COMPONENT_REQUIREMENTS.md (prevents AI slop)
                                │
                                ▼
[ STEP 0.5: Visual Reference Gathering & Brand Synthesis (MANDATORY GATE BEFORE DESIGN.MD) ]
  • Scaffold `docs/design/inspiration/` & Collect 2–5 UI reference screenshots/URLs
  • Vision Extraction: Palette, Geometry, Elevation, Typography, Density
  • Logo & Inspiration Alignment: Agent compares references against `LOGO_DESIGN_BRIEF.md`
  • **Selection Decision**: Agent evaluates options, selects exactly 1 primary visual benchmark ("1 paling OK")
    or harmonizes palette with brand logo colors, and documents explicit justification
  • OUTPUT: `docs/design/inspiration/notes.md` (STRICT PREREQUISITE for STEP 1)
  • ⛔ FORBIDDEN: Generating `DESIGN.md` before `notes.md` is complete with selected visual benchmark
                                │
                                ▼
[ STEP 1: Drafting DESIGN.md System Tokens (Derived from Selected Inspiration & Logo) ]
  • Input: `COMPONENT_REQUIREMENTS.md` & `notes.md` (MUST read selected benchmark from `notes.md`)
  • Primary brand colors derived directly from chosen visual benchmark / `LOGO_DESIGN_BRIEF.md`
  • Neutral & Accent Tokens, Container vs Interactive Borders (≥3:1)
  • Placeholder Contrast (≥4.5:1), Separate Expense vs Destructive Semantics
  • Mobile Anti-Zoom (16px), 44px Touch Targets, 240px Sidebar, Z-Index Scale
                                │
                                ▼
[ STEP 2: Choose Prototyping Workflow (Context-Driven) ]
  • Markdown-only: DESIGN.md + DESIGN_SPEC.md (fast, solo projects)
  • Visual builder: v0.dev / Google Stitch / HTML click-dummy
  • AI prototype: v0.dev / Bolt.new (AI-generated components)
  • Design tool: Figma Dev Mode (professional handoff)
                                │
                                ▼
[ STEP 3: Screen Specification & Wireflows (5-State Matrix) ]
  • Document/Generate Each In-Scope Screen from SITEMAP.md (SCR-01..SCR-NN)
  • Mandatory Inclusion of 5 States: Default, Loading Skeleton, Empty, Error, Success
                                │
                                ▼
[ STEP 4: Screen Prompts & Screen Output Generation (MANDATORY ALL SCALES) ]
  • Generate structured per-screen prompts for ALL screens in SITEMAP.md using `templates/02-design/SCREEN_PROMPT_TEMPLATE.md`
  • Store prompts in: `docs/design/prompts/[screen-id-lowercase]/PROMPT.md`
  • Generate/render screen code or prototype components based on prompt, DESIGN.md, and SITEMAP.md
  • Store generated screen outputs in: `docs/design/screens/[screen-id-lowercase]/`
  • OUTPUT: docs/design/prompts/ & docs/design/screens/ populated for all in-scope screens
                                │
                                ▼
                                │
                                ▼
[ STEP 5: Walk-Through Session & Design Freeze Sheet ]
  • Walkthrough Demo (Formal with Single PIC for Client; Self-Review for Solo)
  • Sign Design Freeze Sign-Off Sheet
                                │
                                ▼
[ OUTPUT: 6 COMPLETE ARTIFACTS ] ──► Ready to Proceed to Module 05: Architecture & FSD
  1. docs/specs/COMPONENT_REQUIREMENTS.md (component inventory)
  2. docs/specs/LOGO_DESIGN_BRIEF.md (minimal brief ≤2KB)
  3. docs/specs/SITEMAP.md (screen hierarchy, flows, RBAC)
  4. docs/design/inspiration/notes.md (visual reference extraction)
  5. docs/harness-root/DESIGN.md (design tokens, real WCAG AA)
  6. docs/specs/DESIGN_SPEC.md (screen specifications)
  + assets/logo/ (logo asset: logo.svg / logo.png)
  + docs/design/prompts/ & docs/design/screens/ (per-screen generation prompts and rendered components)
```

---

## 0. Component Discovery & UI Pattern Analysis (STEP 0)

> **CRITICAL: This step prevents AI slop, naming collisions, and accessibility violations by mapping scope features to concrete UI patterns, calibrated WCAG 2.2 Level AA states, and unified layer hierarchies BEFORE designing.**
> **Duration**: 1-2 hours
> **Input**: `SCOPE_STATEMENT.md` (features, user stories, acceptance criteria) & `SITEMAP.md`
> **Output**: `COMPONENT_REQUIREMENTS.md` (justified component inventory)

### Root Causes of Design Failure (Why Step 0 Exists)

Without systematic component discovery, AI agents generate "design slop" that appears polished on the surface but fails catastrophically during frontend implementation:
1. **Component Nomenclature Inconsistency**: Key components referenced in feature workflows (§2) do not match the component inventory table (§3), causing developer confusion and duplicated abstractions during scaffolding.
2. **False Accessibility Compliance**: Agents claim "Strict WCAG AA" while specifying form submit buttons disabled in pristine states (confusing users), error toasts auto-dismissing after 4 seconds (violating WCAG 2.2.1), or focused inputs obscured by sticky bars (violating WCAG 2.4.11 Focus Not Obscured).
3. **Layer Collisions (Z-Index Conflicts)**: Modal dialogs render at higher z-index than dropdowns/comboboxes triggered inside them, clipping selection menus behind backdrops.
4. **Naive Domain Assumptions**: Using `<input type="number">` for currency (introducing float spinners and rounding errors), assuming stock 0 rigidly blocks cashier queues when physical goods exist on shelves, or citing outdated statutory tax thresholds.

**The Step 0 Solution**:
- Every component is strictly traced to an in-scope P0/P1 feature in `SCOPE_STATEMENT.md` and route in `SITEMAP.md`.
- Nomenclature parity: 100% exact name match between interaction sequences and inventory tables.
- Right-sized inventory: 20–35 components with variants, zero unrequested additions.
- Calibrated WCAG 2.2 Level AA compliance built directly into component states and layout containers.

---

### Step 0 Process

#### 1. Read SCOPE_STATEMENT.md (15 min)

Extract:
- **Features**: What the app does (authentication, dashboard, CRUD, etc.)
- **User stories**: Who needs what and why
- **Acceptance criteria**: Observable success conditions
- **Critical flows**: Login → Dashboard → Create task → View detail

**Example (TaskFlow app):**
```markdown
Feature 1: Authentication
- User story: As a team member, I want to log in, so I can access my tasks
- Acceptance: Email validation, password min 8 chars, error messages

Feature 2: Dashboard
- User story: As a team lead, I want to see task stats, so I can monitor progress
- Acceptance: Show total/in-progress/completed counts, load in <2s

Feature 3: Task List
- User story: As a team member, I want to view all tasks, so I can pick work
- Acceptance: Sortable table, filter by status, search by title, pagination
```

---

#### 2. Map Features → UI Patterns (45 min)

For each feature, identify:
- **UI pattern needed**: Form, table, dashboard, detail view, modal, etc.
- **User interactions**: What user does → What system shows
- **Edge cases**: Empty state, error state, loading state

**Example:**
```markdown
Feature 1: Authentication

UI Patterns:
- Form layout (email + password fields)
- Input validation (inline errors)
- Submit button (primary variant)
- Loading state (spinner during API call)

User Interactions:
1. User enters email → System validates format
2. User enters password → System checks length
3. User clicks "Login" → System shows loading, then redirects or error

Edge Cases:
- Invalid email: Show "Invalid email format" below field
- Wrong password: Show "Invalid credentials" below form
- Network error: Show "Connection failed. Retry?" with button

Components Required:
- Input (with error state)
- Button (primary variant, loading state)
- FormField (label + input + error wrapper)
- LoadingSpinner
```

Repeat for ALL features in SCOPE_STATEMENT.

**Domain Edge Case Handling (Non-Naive Business Rules)**:
- **Currency & Monetary Entry**: Must specify `inputmode="numeric"` with live dot-thousand formatting (e.g., `Rp 1.250.000`), NEVER `<input type="number">`.
- **Cashier Stock Discrepancies**: If system stock reaches 0 but physical goods exist on shelves, provide a supervisor override workflow rather than rigidly blocking the cashier queue.
- **Blind Count Opname**: For inventory adjustments, hide expected quantities during counting to prevent confirmation bias.

---

#### 3. Consolidate Component Inventory (Strict Three-Tier Structure)

Group all components into three definitive tiers. Every component named in Step 2 MUST appear here:

**A. Primitives (Atomic Components)**:
- `Button` (primary, secondary, outline, ghost, destructive)
- `Input` (text, email, password, search, numeric)
- `Textarea`, `Select` (single, combobox), `Badge`, `Checkbox`, `LoadingSpinner`, `Icon` (Lucide React)

**B. Standard Composites**:
- `FormField` (accessible wrapper with label, input, hint, and ≥13px error text)
- `Card` (standard header, body, footer container)
- `Table` (accessible table with pagination; reflows to stacked cards on mobile <640px)
- `Modal` (backdrop `z-40`, dialog `z-50`, focus trap, Esc handler)
- `ConfirmDialog` (destructive action prompt)
- `Toast` (system alerts; container `z-60`)
- `EmptyState` (illustration + heading + description + CTA)
- `SearchInput` (input + icon + clear action)

**C. Domain-Specific Composites (Conditional Extensions)**:
*(Include only if required by project domain)*
- `POSCartDock` (two-panel split on tablet/desktop, sticky bottom dock on mobile)
- `ChangeCalculator` (cashier tender amount & quick cash chips)
- `ThermalPrintView` (`@media print` 58mm/80mm receipt stylesheet)
- `OfflineSyncBadge` (4 connection states: Online, Offline, Syncing, Sync Error)
- `CurrencyInput` (live formatted monetary field)

**Rules:**
- ✅ 100% exact name match with Feature → UI Pattern Mapping.
- ❌ Exclude generic "might need later" components (tabs, sliders, accordions if not in P0/P1 scope).
- ✅ Right-sized inventory: typically 20–35 components total for MVP.
- ✅ Document intentionally excluded components (e.g., No tabs/accordion/slider if not justified by scope).

---

#### 4. Define Interaction States (15 min)

**Per Component:**
- Input: default, hover, focus, error, disabled
- Button: default, hover, active, disabled, loading
- Modal: closed, opening, open, closing

**Per Screen (5-State Matrix):**
- All data screens MUST have:
  1. **Idle/Default**: Normal render with data
  2. **Loading**: Skeleton loaders (gray pulsing)
  3. **Success**: Data loaded (same as idle)
  4. **Screen Error**: Full-screen or container alert card with retry CTA (network failure / 500 error)
  5. **Empty**: Empty state illustration + CTA

> ⚠️ **ERROR SEPARATION RULE**:
> Field validation errors (inline red text, invalid inputs) belong strictly to component form states.
> They MUST NEVER be conflated into screen-level error states.

---

#### 5. Responsive & Accessibility (15 min)

**Responsive Breakpoints:**
- Standardize on Tailwind breakpoints: `sm: 640px`, `md: 768px`, `lg: 1024px`, `xl: 1280px`.
- **Definitive switch point**: Consistently use `md: 768px` for shifting between mobile drawer/bottom tabs and desktop sidebar/two-panel layouts.
- Table overflow: On viewports `<640px`, data tables MUST reflow into stacked cards with key-value pairs.

**Calibrated Accessibility Protocol (WCAG 2.2 Level AA):**
1. **Anti-Disabled Pristine Rule**:
   - Form submit buttons **MUST NOT** be `disabled` while the form is untouched/pristine.
   - *Enforcement*: Users must be able to click submit to understand expectations; clicking triggers validation, scrolls smoothly, and auto-focuses the first invalid field.
2. **Timing Adjustable (WCAG 2.2.1)**:
   - Error toasts and offline reconnection alerts **MUST NOT auto-dismiss**. They require explicit user dismissal or error condition resolution.
   - Success/info toasts may auto-dismiss after $\ge 5000\text{ms}$ with pause on hover/focus.
3. **Focus Not Obscured (WCAG 2.4.11)**:
   - Containers with sticky navigation (`z-10`) or fixed checkout docks (`z-20`) must specify CSS `scroll-padding`:
     ```css
     html, body, .scroll-container {
       scroll-padding-top: 80px;
       scroll-padding-bottom: 96px;
     }
```
4. **Accessible Error Typography**:
   - All form error messages (`aria-describedby`) must be at least `13px` (`text-xs md:text-sm`) with $\ge 4.5:1$ contrast against the background.

**Technical Specifications & Unified Z-Index Hierarchy:**
- Font package: Use `next/font/google`. Deprecated `@next/font/google` is **strictly prohibited**.
- Unified Stacking Scale:
  ```css
  :root {
    --z-canvas: 0;
    --z-sticky-nav: 10;
    --z-floating-action: 20;
    --z-page-dropdown: 30;
    --z-modal-backdrop: 40;
    --z-modal-dialog: 50;
    --z-modal-dropdown: 55; /* Dropdowns INSIDE modal dialog portals */
    --z-toast: 60;
    --z-payment-gateway: 999999;
  }
```

---

#### 6. Write COMPONENT_REQUIREMENTS.md (15 min)

Use template: `templates/02-design/COMPONENT_REQUIREMENTS_TEMPLATE.md`

**Mandatory 9 Standardized Sections:**
1. **Metadata & Scope Alignment**: Scope/sitemap references, verified WCAG 2.2 AA target.
2. **Feature → UI Pattern Mapping & Domain Edge Cases**: Interaction sequences, edge cases, domain exception mitigations.
3. **Official Component Inventory**: Strict 3-tier categorization (Primitives, Standard Composites, Domain Composites).
4. **Priority Screen 5-State Matrix**: Default, Loading, Success, Screen Error, Empty State (field errors separated).
5. **Calibrated Accessibility Protocol**: Anti-disabled pristine, WCAG 2.2.1 timing, WCAG 2.4.11 scroll-padding, error typography.
6. **Multi-User & Role-Aware Component Protocols**: Defense-in-depth UI gating vs server RBAC.
7. **Technical Specifications & Unified Z-Index Scale**: Modern font loading, standard breakpoints, multi-tier z-index scale (`z-0` to `z-999999`).
8. **Regulatory Compliance & Local Domain Policies**: Statutory tax rules (PP 55/2022 jo. PP 20/2026 or sector regulations), mandatory liability disclaimers.
9. **Agent Validation Checklist**: Exit verification before proceeding to tokens.

**Output file:**
```
docs/specs/COMPONENT_REQUIREMENTS.md
```

---

### Step 0 Checklist (Agent Validation Rules)

Before completing Step 0 and proceeding to `docs/harness-root/DESIGN.md` generation, verify:

- [ ] **1. Nomenclature Parity**: 100% of component names in Section 2 exist in Section 3 inventory table.
- [ ] **2. Anti-Disabled Pristine**: Form submit buttons are NOT disabled in pristine state (validation triggers on click with auto-focus).
- [ ] **3. Non-Dismissing Errors**: Error toasts and offline reconnection alerts are configured without auto-dismiss.
- [ ] **4. Numeric Input Optimization**: All monetary/currency inputs use `inputmode="numeric"` and NEVER `type="number"`.
- [ ] **5. Z-Index Layer Integrity**: Modal dropdowns/comboboxes (`--z-modal-dropdown: 55`) are layered higher than the dialog itself (`--z-modal-dialog: 50`).
- [ ] **6. Accessible Error Typography**: All form error text is minimum 13px with $\ge 4.5:1$ contrast against the card background.
- [ ] **7. Verified Document Output**: `docs/specs/COMPONENT_REQUIREMENTS.md` committed and adheres to the 7 standardized sections.

**Time budget**: 1-2 hours
**Next step**: Proceed to Step 0.5 (Visual Reference Gathering & Benchmark Selection).

---

### 0.4. M04-LITE: Fast-Track UI/UX for Small Scale (<4 Weeks)

> **When to use**: Automatically activated when `Scale: small` in `docs/pm/PROJECT_STATE.md` or executing via `PROJECT_LITE.md`.
> **Core Principle**: Eliminates design paralysis while preserving strict anti-slop tokens and WCAG 2.2 AA accessibility.

**M04-LITE Pragmatic Rules**:
1. **Logo Placeholder Allowed**: Tidak wajib mendesain logo kompleks. Cukup buat placeholder inisial SVG sederhana di `assets/logo/logo.svg` (misal monogram teks 1-2 huruf dengan warna aksen brand). Minimal ukuran file $\ge 50$ byte.
2. **1 Visual Benchmark Cukup**: Tidak wajib mengumpulkan 5 screenshot. Cukup pilih **1 web/dashboard acuan nyata** (misal Linear, Vercel, TailwindUI, Stripe) dan catat alasan serta ekstrak warnanya di `docs/design/inspiration/notes.md`.
3. **5-State Matrix Penuh Hanya untuk Layar Utama**: Layar sekunder (static about/terms) cukup state default. Matriks 5-state (Idle, Loading Skeleton, Empty, Error, Success) hanya diwajibkan untuk 1–3 layar data utama.
4. **Deliverables Tetap Lengkap**: Tetap menghasilkan 6 berkas inti agar tidak ada utang arsitektur, namun isinya proporsional dan ringkas (1–2 halaman per dokumen).

---

### Step 0.5: Visual Reference Gathering & Benchmark Selection (MANDATORY BEFORE DESIGN.MD)

1. **Scaffold Inspiration Space**: Ensure `docs/design/inspiration/` exists.
2. **Analyze 2–5 References**: User supplies screenshots/URLs or agent benchmarks top industry references.
3. **Evaluate & Pick 1 Primary Benchmark ("Paling OK")**:
   - Agent evaluates aesthetic fit, density, component geometry, and domain standards.
   - Cross-check against `docs/specs/LOGO_DESIGN_BRIEF.md` to ensure palette harmony with brand logo.
   - Select exactly 1 primary winner / unified reference baseline.
4. **Document Decision in `docs/design/inspiration/notes.md`**:
   - Must state chosen benchmark, why it was selected over alternatives, and extracted hex codes matched to the logo.
5. **Enforcement**: `docs/harness-root/DESIGN.md` **CANNOT** be drafted out of thin air. It MUST explicitly cite the selected benchmark and logo alignment from `docs/design/inspiration/notes.md`.

---

## 1A. Prototyping Approach Selection (STEP 2)

**Choose approach based on project context**:

### Option A: Markdown-Only (FASTEST - Solo Projects)
**Use when**:
- Solo developer project (no client visual approval needed)
- Budget <$5K USD (time = money)
- Simple UI (forms, tables, dashboards)

**Deliverables**:
- ✅ DESIGN.md (tokens)
- ✅ DESIGN_SPEC.md (5-state matrix per screen)
- ❌ No interactive prototype

**Pros**: Fastest (2-4 hours), no tool dependency, forces clear specification
**Cons**: No visual preview before coding, client may request changes post-M06

---

### Option B: AI Visual Builder (v0.dev / Google Stitch / HTML Click-Dummy)
**Use when**:
- Need rapid visual prototyping (drag-and-drop)
- Client requires interactive demo
- Design system can be uploaded programmatically

**Tools**: v0.dev by Vercel, Google Stitch, or standalone HTML/CSS click-dummy

**Workflow**:
1. Generate DESIGN.md (tokens, guidelines)
2. Upload design system tokens to visual builder
3. Generate screens and verify interactive state transitions
4. Connect navigation and deploy to Prototype Viewer
5. Document final specs in DESIGN_SPEC.md

**Deliverables**:
- ✅ DESIGN.md (tokens)
- ✅ DESIGN_SPEC.md (5-state matrix)
- ✅ UI prototype URL

**Pros**: Fast iteration, visual drag-and-drop, instant preview
**Cons**: MCP tool dependency, proprietary platform

> ⚠️ **PROTOTYPING TOOL TROUBLESHOOTING**:
> If Prototype MCP tools fail (authentication/network):
> - Check access token in configuration / `FIGMA_ACCESS_TOKEN`
> - Report technical issues to user (don't skip Prototype unilaterally)
> - Fallback to Option C (AI prototype) only if Prototype unavailable

---

### Option C: AI-Powered Prototype (Modern Alternative)
**Use when**:
- Prototype unavailable or user prefers code-based output
- Need production-ready component code
- Client needs visual sign-off before M06

**Tools** (choose one):

#### 1. v0.dev (Vercel)
```bash
Pros: Next.js/React output, Tailwind built-in, production-ready code
Cons: Vercel account required, rate limits
Use: Next.js projects (70% of solo projects)
```

#### 2. Bolt.new (StackBlitz)
```bash
Pros: Multiple frameworks (Vue/Svelte/React), instant deploy
Cons: WebContainers dependency, limited backend
Use: Frontend-heavy apps, rapid iteration
```

#### 3. Lovable.dev (formerly GPT Engineer)
```bash
Pros: Database schema + API + UI generation
Cons: Opinionated stack, subscription required
Use: CRUD apps with clear data model
```

**Workflow**:
1. Generate DESIGN.md first (tokens, guidelines)
2. Feed DESIGN.md to AI tool with screen descriptions
3. Iterate 2-3 rounds (colors, layout, components)
4. Export prototype URL for client review
5. Document final design in DESIGN_SPEC.md

**Deliverables**:
- ✅ DESIGN.md (tokens)
- ✅ DESIGN_SPEC.md (5-state matrix)
- ✅ Interactive prototype URL

---

### Option D: Design Tool Workflow (Complex UI)
**Use when**:
- Complex visual design (brand-heavy, marketing site)
- Designer on team (handoff to dev)
- Client requires design files (Figma/Penpot)
- Manual design control needed

**Tools**:

#### 1. Figma Dev Mode (Manual Export)
```bash
Pros: Industry standard, code export, design tokens
Cons: Subscription required ($15/mo), manual design work
Use: Professional client work, complex UI systems
Note: For live sync, use Option E (Figma MCP) instead
```

#### 2. Penpot (Open-Source Figma Alternative)
```bash
Pros: Free, self-hosted, SVG-native
Cons: Smaller ecosystem, fewer plugins
Use: Budget-conscious projects, design freedom
```

**Workflow**:
1. Create design system (colors, typography, components)
2. Design all screens with 5-state variants
3. Export design tokens to DESIGN.md (manual)
4. Document specs in DESIGN_SPEC.md
5. Share Figma/Penpot link for client review

**Deliverables**:
- ✅ DESIGN.md (tokens)
- ✅ DESIGN_SPEC.md (specifications)
- ✅ Figma file / Penpot project

---

### Option E: Figma MCP (Live Design Sync)
**Use when**:
- Active designer making frequent iterations
- Need real-time design system sync
- Want AI to generate code directly from Figma frames
- MCP-compatible AI tool available (Claude Code, Cursor, VS Code, Codex, Xcode)

**Requirements**:
- Figma account with API access
- MCP-compatible AI client ([Figma MCP Catalog](https://www.figma.com/mcp-catalog/))
- OAuth authentication (browser flow)

**Quick Start**:

**If MCP already configured globally** (e.g., in `~/.omp`):
Figma MCP server already available. Skip to Usage below.

**Setup per Client**:

**Claude Code**:
```bash
claude plugin install figma@claude-plugins-official
# Or: claude mcp add --scope user --transport http figma https://mcp.figma.com/mcp
```

**Cursor**: `/add-plugin figma`

**VS Code**: Install Figma MCP extension or add to `mcp.json`

**Codex**: `codex mcp add figma --url https://mcp.figma.com/mcp`

**Xcode**: One-click setup via plugin

See `references/technical/FIGMA_MCP_SETUP.md` for full installation guide.

**Available Tools**:

**Read** (Design → Code):
- `get_design_context` - Extract design + generate code (React+Tailwind default)
- `get_metadata` - XML outline of frame structure
- `get_screenshot` - Screenshot of selection
- `download_assets` - Export assets (PNG/SVG/PDF/JPG)
- `get_variable_defs` - Design tokens (colors, typography, spacing)
- `get_motion_context` - Animation keyframes
- `search_design_system` - Search libraries for components/variables

**Write** (Code → Design):
- `use_figma` - Create/edit Figma content
- `generate_figma_design` - Capture live UI to Figma
- `generate_diagram` - Create FigJam diagrams from Mermaid
- `upload_assets` - Upload images to Figma

Full reference: https://developers.figma.com/docs/figma-mcp-server/tools-and-prompts/

**Usage Examples**:

**Extract Design System (M04)**:
```bash
User: "Extract design system from https://figma.com/file/ABC123/Design-System"

AI calls:
- get_design_context(fileKey="ABC123", nodeId from URL)
- get_variable_defs() for tokens

Generates:
→ DESIGN_SPEC.md with live tokens (colors, typography, spacing)
→ Component inventory from Figma libraries
```

**Generate Code from Frame (M06)**:
```bash
User: "Generate Next.js component from https://figma.com/file/ABC123/.../node-XYZ"

AI calls:
- get_design_context(fileKey="ABC123", nodeId="node-XYZ")

Returns:
→ React + Tailwind component code
→ Matches Figma design exactly
```

**Custom Framework**:
```bash
"Generate in Vue using components from src/ui/"
"Generate iOS SwiftUI view from this Figma frame"
"Generate plain HTML + CSS"
```

**Deliverables**:
- ✅ DESIGN_SPEC.md (auto-generated from Figma variables)
- ✅ DESIGN_SPEC.md (extracted from frames)
- ✅ Live Figma file (source of truth)
- ✅ No manual export needed

**Pros**:
- ✅ No manual token export (reads Figma variables directly)
- ✅ Always synced (queries live file)
- ✅ AI generates code from frames (visual → code)
- ✅ Bidirectional (can capture live UI to Figma)
- ✅ Component reuse via Code Connect

**Cons**:
- ❌ Requires MCP setup (OAuth authentication)
- ❌ Only works with supported clients (Claude Code, Cursor, VS Code, Codex, Xcode)
- ❌ Network dependency (Figma API must be reachable)
- ❌ Figma subscription required

**Best for**:
- Teams with active designer + developer collaboration
- Design systems with frequent token updates
- Projects where Figma is single source of truth

---

### Decision Matrix

| Criteria | Markdown | Prototype | AI Prototype | Design Tool | Figma MCP |
|----------|----------|--------|--------------|-------------|-----------|
| Time | 2-4 hours | 4-8 hours | 1-2 days | 2-3 days | 4-6 hours |
| Cost | Free | Free* | $0-50 | $15-50/mo | $15/mo |
| Client demo | ❌ | ✅ | ✅ | ✅ | ✅ |
| Code output | N/A | HTML | React/Vue | Manual | React/Vue |
| Tool dependency | None | MCP | Web | Desktop app | MCP + Figma |
| Live sync | ❌ | ❌ | ❌ | ❌ | ✅ |
| Best for | Solo MVP | Quick visual | Modern stack | Professional | Design systems |

*Prototype: Free if MCP available; otherwise N/A

---

## 2. Module 04 Deliverables

This module produces 6 authoritative design specification artifacts:

| No | Artifact Name | Format / Location | Description & Function |
| :---: | :--- | :--- | :--- |
| **1** | **`docs/specs/LOGO_DESIGN_BRIEF.md`** | Folder `docs/specs/` | Minimal logo & branding brief (≤2KB): product name, philosophy, brand vibe keywords, seed palette. |
| **2** | **`docs/specs/SITEMAP.md`** | Folder `docs/specs/` | Information Architecture: navigation structure, page hierarchy, route paths (18-50 screens depending on scale), critical flows, breadcrumbs. Prerequisite for DESIGN_SPEC.md. |
| **3** | **`docs/specs/COMPONENT_REQUIREMENTS.md`** | Folder `docs/specs/` | Justified 3-tier component inventory (Primitives, Standard Composites, Domain Composites) with WCAG 2.2 AA interaction states. |
| **4** | **`docs/design/inspiration/notes.md`** | Folder `docs/design/inspiration/` | Visual reference analysis, extracted palette/geometry/elevation, logo cross-alignment. |
| **5** | **`docs/harness-root/DESIGN.md`** | Folder `docs/harness-root/` (staged) | Authoritative design tokens for coding (Module 06): colors, fonts, spacing, anti-slop guardrails. Deployed to `./DESIGN.md` after scaffold. |
| **6** | **`docs/specs/DESIGN_SPEC.md`** | Folder `docs/specs/` | Full screen specifications & wireflows with 5-state matrix per screen (Idle, Loading Skeleton, Empty, Screen Error, Success) and embedded Design Freeze Sign-Off. |
| **7** | **`assets/logo/`** | Root `/assets/logo/` | Berkas logo hasil generate (`logo.svg` / `logo.png`) yang dijadikan acuan palet warna dan mood visual. |
| **8** | **`docs/design/prompts/` & `docs/design/screens/`** | Folder `docs/design/` | Berkas prompt per-layar berdasarkan SITEMAP/DESIGN_SPEC (`prompts/scr-xx/PROMPT.md`) dan hasil generate komponen layar (`screens/scr-xx/`). |

> 📁 **MANDATORY FILE LOCATION RULES**:
> - `DESIGN.md` is staged in `docs/harness-root/DESIGN.md` during M04, then deployed to root (`./DESIGN.md`) after scaffold in M06.
> - `DESIGN_SPEC.md` MUST be placed in **`docs/specs/DESIGN_SPEC.md`**. Placed in the root directory is STRICTLY FORBIDDEN.
>
> ⚠️ **PROTOTYPING TOOL SELECTION**:
> - Default to Option A (Markdown-only) for solo projects
> - Use Option B (Prototype) if MCP available and user prefers visual builder
> - Use Option C (AI prototype) for modern stack with code output
> - Use Option D (Design tool) for professional design handoff
> - Never skip DESIGN.md + DESIGN_SPEC.md documentation (mandatory regardless of prototype choice)


> 📚 **EXTENDED WORKED EXAMPLES & DEEP DIVE**:
> For the comprehensive 44-screen TataBuku sitemap example, user testing facilitation scripts, cloud vs local MCP setup, and M04B enterprise design tokens, consult:
> - [`references/technical/UIUX_PROTOTYPING_DEEP_DIVE.md`](../../references/technical/UIUX_PROTOTYPING_DEEP_DIVE.md)

---

---

## 6. Gate Exit Criteria [GATE]

[GATE] Module 04 is declared **PASSED** if:

### Mandatory Files Verification (BLOCKING):
- [ ] **`docs/specs/COMPONENT_REQUIREMENTS.md` exists** (≥1000 bytes, contains component inventory & interaction states)
- [ ] **`docs/specs/LOGO_DESIGN_BRIEF.md` exists** (≥500 bytes, ≤2KB minimal brief)
- [ ] **`docs/specs/SITEMAP.md` exists** (≥2000 bytes, contains screen inventory, user flows, and navigation structure)
- [ ] **`docs/design/inspiration/notes.md` exists** (synthesizes 2–5 visual references, logo hex extraction, palette decisions)
- [ ] **`docs/harness-root/DESIGN.md` exists** (staged, ≥1000 bytes, contains color palette + typography)
- [ ] **`docs/specs/DESIGN_SPEC.md` exists** (≥2000 bytes, contains screen specs)
- [ ] **`assets/logo/` exists** (contains `logo.svg` or `logo.png` referenced by DESIGN.md)
- [ ] **Screen Prompts & Screens exist**: `docs/design/prompts/` dan `docs/design/screens/` terisi untuk seluruh layar di SITEMAP.md
- [ ] **Screen count match**: SITEMAP.md total = DESIGN_SPEC.md screen inventory (±10% tolerance)

### Strict Accessibility & Ergonomics Audit (BLOCKING - MATHEMATICALLY COMPUTED):

Every `DESIGN.md` generation MUST pass this mathematical contrast and ergonomics verification table. Self-approving without actual computed ratios is STRICTLY FORBIDDEN:

| Element Tested | Foreground / Border | Background Surface | Light Mode Ratio (Target) | Dark Mode Ratio (Target) | Minimum Standard |
| :--- | :--- | :--- | :---: | :---: | :---: |
| **Text Primary** | `--foreground` | `--background` | **≥7.0:1** (e.g., `#18181B` on `#FFFFFF` = 17.72:1) | **≥7.0:1** (e.g., `#F4F4F5` on `#09090B` = 18.10:1) | ≥7.0:1 (Enhanced) |
| **Text Secondary** | `--muted-foreground` | `--background` | **≥4.5:1** (e.g., `#71717A` on `#FFFFFF` = 4.83:1) | **≥4.5:1** (e.g., `#A1A1AA` on `#09090B` = 7.76:1) | ≥4.5:1 (WCAG AA) |
| **Placeholder Text** | `--text-placeholder` | `--input-bg` | **≥4.5:1** (e.g., `#71717A` on `#FFFFFF` = 4.83:1) | **≥4.5:1** (e.g., `#A1A1AA` on `#18181B` = 6.91:1) | ≥4.5:1 (WCAG AA) |
| **Interactive Input Borders**| `--border-input` | `--card` / `--background` | **≥3.0:1** (e.g., `#71717A` on `#FFFFFF` = 4.83:1) | **≥3.0:1** (e.g., `#71717A` on `#18181B` = 3.67:1) | ≥3.0:1 (WCAG 1.4.11) |
| **Destructive Text / Badge** | `--destructive-foreground` | `--destructive` bg | **≥4.5:1** (e.g., `#991B1B` on `#FEE2E2` = 6.80:1) | **≥4.5:1** (e.g., `#FCA5A5` on `#450A0A` = 8.51:1) | ≥4.5:1 (WCAG AA) |
| **Success Text / Badge** | `--success-foreground` | `--success` bg | **≥4.5:1** (e.g., `#065F46` on `#D1FAE5` = 6.78:1) | **≥4.5:1** (e.g., `#86EFAC` on `#052E16` = 10.62:1) | ≥4.5:1 (WCAG AA) |
| **Warning Text / Badge** | `--warning-foreground` | `--warning` bg | **≥4.5:1** (e.g., `#92400E` on `#FEF3C7` = 6.37:1) | **≥4.5:1** (e.g., `#FDE047` on `#422006` = 11.06:1) | ≥4.5:1 (WCAG AA) |

**Ergonomics & Device Constraints (BLOCKING):**
- [ ] **Non-Color Indicators**: Every state change (error, success, warning, expenses) pairs color with explicit text labels, arithmetic signs (e.g., `-Rp` for expenses), or icons (never color hue alone).
- [ ] **iOS Safari Anti-Zoom**: Mobile input fields specify `text-base` (`16px`) on mobile viewports (`text-base md:text-sm`).
- [ ] **Touch Target Compliance**: Interactive targets (buttons, steppers, icon buttons) meet `≥44px × 44px` (`h-11`).
- [ ] **Anti-Slop Compliance**: Zero gradients, zero glassmorphism, shadows $\le 4$px blur, and z-index scale defined.

### User Testing (OPTIONAL for MVP, MANDATORY for Client Projects):
- [ ] **Minimum 2 iterations of user testing** with 5+ users per iteration (if client project)
- [ ] **SUS Score ≥70** (Acceptable) on the final iteration (if user testing conducted)

### Design Freeze Sign-Off (BLOCKING):
- [ ] **Design Freeze approval** embedded in DESIGN_SPEC.md with:
  - Approver name (Client PIC or solo developer self-approval)
  - Approval date (YYYY-MM-DD)
  - Signature placeholder (digital signature or statement: "Approved via [email/chat]")

### Optional (Workflow-Dependent):
- [ ] Interactive prototype URL accessible (if AI-Assisted/Hybrid workflow with live demo)
- [ ] Figma project link (if Manual Figma workflow)
- [ ] Exported assets in `/assets/design/` (if manual mockups)

---

## 🛑 PROTOCOL [GATE] EXIT & MANDATORY STOP

**STEP 0: Determine Workflow** (Manual/AI/Hybrid) → User selects A/B/C before file generation

**STEP 1: File Existence Verification (MANDATORY - Run BEFORE declaring complete)**

```powershell
# GATE CHECK - Module 04 File Verification
# Run this PowerShell script to verify all mandatory files exist

$requiredFiles = @(
    @{Path="docs/specs/COMPONENT_REQUIREMENTS.md"; MinSize=1000},
    @{Path="docs/specs/LOGO_DESIGN_BRIEF.md"; MinSize=500; MaxSize=2048},
    @{Path="docs/specs/SITEMAP.md"; MinSize=2000},
    @{Path="docs/design/inspiration/notes.md"; MinSize=200},
    @{Path="docs/harness-root/DESIGN.md"; MinSize=1000},
    @{Path="docs/specs/DESIGN_SPEC.md"; MinSize=2000}
)

$allPassed = $true

foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file.Path)) {
        Write-Error "❌ GATE FAILED: File $($file.Path) not found."
        $allPassed = $false
    } else {
        $size = (Get-Item $file.Path).Length
        if ($size -lt $file.MinSize) {
            Write-Error "❌ GATE FAILED: File $($file.Path) is too small ($size bytes < $($file.MinSize) bytes minimum)."
            $allPassed = $false
        } else {
            if ($file.MaxSize -and $size -gt $file.MaxSize) {
                Write-Error "❌ GATE FAILED: File $($file.Path) exceeds maximum allowed size ($size bytes > $($file.MaxSize) bytes maximum)."
                $allPassed = $false
            } else {
            Write-Host "✅ $($file.Path) verified ($size bytes)"
            }
        }
    }
}

if (-not $allPassed) {
    Write-Error "`n🛑 MODULE 04 GATE FAILED: Missing or incomplete files. CANNOT proceed to Module 05."
    exit 1
}

Write-Host "`n✅ MODULE 04 FILE VERIFICATION PASSED - All mandatory files exist."
```

**STEP 2: Content Verification (MANDATORY)**

Agent must execute the following checks BEFORE declaring Module 04 complete:

```python
# Pseudo-code for agent verification
def verify_module_04():
    # 1. Read SITEMAP.md and count screens
    sitemap = read_file("docs/specs/SITEMAP.md")
    sitemap_screen_count = extract_screen_count(sitemap)  # Parse "Total Screens: X"
    
    # 2. Read DESIGN_SPEC.md and count screen specs
    design_spec = read_file("docs/specs/DESIGN_SPEC.md")
    spec_screen_count = count_screen_sections(design_spec)  # Count "## Screen: ..." sections
    
    # 3. Verify match (±10% tolerance)
    if abs(sitemap_screen_count - spec_screen_count) > (sitemap_screen_count * 0.1):
        raise GateError(f"Screen count mismatch: SITEMAP ({sitemap_screen_count}) vs DESIGN_SPEC ({spec_screen_count})")
    
    # 4. Verify DESIGN.md contains required sections
    design_md = read_file("docs/harness-root/DESIGN.md")  # Staged path during M04, deployed to root in M06
    required_sections = ["Color Palette", "Typography", "Spacing", "Components", "Border Contrast Architecture", "Z-Index Layering Scale"]
    for section in required_sections:
        if section not in design_md:
            raise GateError(f"DESIGN.md missing section: {section}")

    # 4b. Verify WCAG tokens exist
    wcag_tokens = ["--border-input", "--text-placeholder", "--chart-1", "--z-modal"]
    for token in wcag_tokens:
        if token not in design_md:
            raise GateError(f"DESIGN.md missing critical token: {token}")
    
    # 5. Verify Design Freeze Sign-Off exists
    if "Approved by:" not in design_spec or "Date:" not in design_spec:
        raise GateError("Design Freeze Sign-Off missing in DESIGN_SPEC.md")
    
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

**STEP 3: Report Summary to User**

**MANDATORY**: Execute `./scripts/gates/validate-gate.sh M04` (or `.ps1`). Paste the EXACT terminal output into your response.

Do NOT use pre-filled completion checklists with hardcoded `✅`. Output must be derived from the actual validator execution:

```
[PASTE RAW OUTPUT OF: ./scripts/gates/validate-gate.sh M04]
```

If the script exits with `❌ Gate validation FAILED`, you MUST NOT declare completion or stop the turn. Fix missing artifacts and re-run.

Only after `✅ Gate validation PASSED` (exit code 0), present the handoff prompt:

```
Module 04 Gate PASSED. All 6 design artifacts verified.

---

Next Steps:
1. User reviews design specification artifacts (SITEMAP.md, COMPONENT_REQUIREMENTS.md, DESIGN.md, DESIGN_SPEC.md, notes.md, LOGO_DESIGN_BRIEF.md)
2. If corrections needed: Request changes now (before Module 05)
3. If approved: Confirm "Design Freeze approved, proceed to Module 05"

```

**STEP 4: STOP & Wait for User Approval**

**STRICTLY FORBIDDEN** to proceed to Module 05 within the same turn. The agent must:
1. **END TURN** after displaying summary
2. **WAIT** for explicit user approval: "Design approved" or "Proceed to Module 05"
3. Only proceed after user confirmation received

**If user requests changes**:
- Re-generate affected file(s)
- Re-run GATE verification
- Display updated summary
- Wait for approval again

**If user approves**:
- Proceed to Module 05 (Architecture & FSD)
- Carry forward DESIGN.md + DESIGN_SPEC.md as references for technical specs

---

> **AUTHORITATIVE WORKFLOW OVERRIDE**
>
