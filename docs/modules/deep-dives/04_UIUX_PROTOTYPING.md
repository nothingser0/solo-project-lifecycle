# Module 04 Deep Dive: UI/UX Design & Prototyping

## Contents

- [Root Causes of Design Failure (Why Step 0 Exists)](#root-causes-of-design-failure-why-step-0-exists)
- [Step 0 Process](#step-0-process)
- [Prototyping Approach Selection (STEP 2) — Full Option Details](#prototyping-approach-selection-step-2-full-option-details)
- [Content Moved From the Runbook (Condensed M04 Rewrite)](#content-moved-from-the-runbook-condensed-m04-rewrite)


> Companion to [`docs/modules/04_UIUX_PROTOTYPING.md`](../04_UIUX_PROTOTYPING.md). This file contains the detailed Step 0 process, the interactive code prototyping standards, and the root-cause analysis of design failure. The runbook holds the condensed execution path, gate criteria, and stop protocol.

---

## Root Causes of Design Failure (Why Step 0 Exists)

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

## Step 0 Process

### 1. Read SCOPE_STATEMENT.md (15 min)

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

### 2. Map Features → UI Patterns (45 min)

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

### 3. Consolidate Component Inventory (Strict Three-Tier Structure)

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

### 4. Define Interaction States (15 min)

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

### 5. Responsive & Accessibility (15 min)

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
   - Success/info toasts may auto-dismiss after ≥ 5000ms with pause on hover/focus.
3. **Focus Not Obscured (WCAG 2.4.11)**:
   - Containers with sticky navigation (`z-10`) or fixed checkout docks (`z-20`) must specify CSS `scroll-padding`:
     ```css
     html, body, .scroll-container {
       scroll-padding-top: 80px;
       scroll-padding-bottom: 96px;
     }
```
4. **Accessible Error Typography**:
   - All form error messages (`aria-describedby`) must be at least `13px` (`text-xs md:text-sm`) with ≥ 4.5:1 contrast against the background.

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

### 6. Write COMPONENT_REQUIREMENTS.md (15 min)

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

## Prototyping Approach Selection (STEP 2) — Full Option Details

**Choose the lightest approach that meets review and handoff needs. M04 artifact and human approval requirements still apply; tools are optional ways to produce or inspect those artifacts.**

| Need | Suitable approach | Choose when |
|---|---|---|
| Low-dependency interactive prototype | Native HTML/CSS | Solo project, simple flows, or no design handoff requirement |
| Rapid generated React/Tailwind screens | v0 or similar builder | The chosen stack fits the project and exported code will be reviewed |
| Explore visual directions | Stitch or another visual builder | Early layout exploration matters more than reusable production code |
| Shared design file and designer handoff | Figma or Penpot | Stakeholders need editable design artifacts or ongoing design collaboration |
| Sync code and a Figma library | Figma MCP / Code Connect | Figma is the agreed source of truth and integration is available |
| Verify rendered flows | Browser automation already available (for example Playwright) | A focused check helps validate P0 journeys; do not add tooling solely for M04 |

Choose React, Tailwind, shadcn/ui, WordPress/WPDS, or another component system only when it matches the implementation stack and product. Do not make a tool or library a gate requirement.

For conversion-focused landing, signup, onboarding, or paywall work, review offer clarity, user effort, trust, and recovery using M00/M01 audience and outcome evidence. Skip this branch when conversion is not an explicit outcome; avoid deceptive or coercive patterns.

### Option A: Native HTML/CSS Prototype (Default for Solo Projects)
Use for simple flows or when a low-dependency, reviewable prototype fits best. Markdown specs help define the prototype but do not replace the interactive prototype required by the M04 gate. Keep it small for M04-LITE.

**Deliverables**: `DESIGN.md`, `DESIGN_SPEC.md`, and the required interactive prototype.

**Pros**: No external design-tool dependency; source can be reviewed and reused during implementation. **Trade-off**: visual iteration is manual unless a browser tool is already available.

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

## Content Moved From the Runbook (Condensed M04 Rewrite)

### Prototyping Workflow Decision Matrix (STEP 2)

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

### PowerShell Gate Script Body (File Verification)

```powershell
# GATE CHECK - Module 04 File Verification
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

# Design pre-condition: logo asset must exist (logo.svg or logo.png)
if (-not ((Test-Path "assets/logo/logo.svg") -or (Test-Path "assets/logo/logo.png"))) {
    Write-Error "❌ GATE FAILED: assets/logo/ must contain logo.svg or logo.png."
    $allPassed = $false
} else {
    Write-Host "✅ assets/logo/ verified (logo.svg or logo.png present)"
}

if (-not $allPassed) {
    Write-Error "`n🛑 MODULE 04 GATE FAILED: Missing or incomplete files. CANNOT proceed to Module 05."
    exit 1
}

Write-Host "`n✅ MODULE 04 FILE VERIFICATION PASSED - All mandatory files exist."
```

### Python Verification Pseudo-Code (Content Check)

```python
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

    # 6. Review visual effects in context. Blur and shadow are not automatic
    # violations; assess contrast, hierarchy, performance, and reference fidelity.

    return True
```

## Full Execution Cycle (moved from the runbook, 2026-11-04)

The runbook now carries the condensed form. This is the original step text, verbatim, kept so no
clause is lost when the condensed form is ambiguous.

```text
INPUT: SCOPE_STATEMENT.md & Valid SOW (or M03 Waived for Solo SaaS)
 ▼ 0.5 Inspiration Intake & Deep Extraction (Multiple References Allowed) — FIRST, BLOCKING, EVERY SCALE
       The human places >=1 reference in docs/design/inspiration/ (multiple screenshots, dashboard/table/mobile cards, brand board, short video clip, or links.md of URLs).
       Crucial: if providing static screenshots without live URLs, the human MUST specify desired dynamic effects directly (e.g. parallax scroll, 3D Spline canvas, video background, stagger text animation, hover micro-interactions).
       ⛔ STOP 0.5: if that folder holds no human-supplied file → END TURN and ask. Do NOT create
          LOGO_DESIGN_BRIEF.md, assets/logo/, SITEMAP.md, COMPONENT_REQUIREMENTS.md, or DESIGN.md first.
       Then: scaffold docs/design/inspiration/, analyze 2–5 references, extract and record:
       (1) Color temperature & brand accents (dominant hex, card backgrounds, muted borders).
       (2) Spatial grid zones & density (sidebars, split panels, card paddings, data density).
       (3) Component anatomy & cues (segmented indicators, badge pill shapes, timeline grids).
       (4) Visual typography & hierarchy (font pairings, title sizing, tabular numeral usage).
       If the project archetype requires specific layout zones (e.g. Bookmark Manager, Notion-like Workspace, File Explorer), execute **`web_search`** against leading industry benchmarks (e.g. `Raindrop.io`, `Linear`, `Vercel`) to discover standard multi-zone layouts and prevent arbitrary omission.
       If references include live URLs (`links.md`), execute **Source-Aware CSS Inspection**: inspect the live DOM/computed CSS of the benchmark to extract exact CSS tokens (`background-color`, primary brand hex, `font-family`, button `border-radius`, and card shadow depth) instead of guessing values from memory.
       **Record every token's provenance** in `DESIGN.md` §0 (Evidence & Inference Log): mark each value ✅ observed (computed CSS / SVG fill / font declaration) or 🔶 inferred (a decision no source states). Prefer official pages, press kits, and CSS over third-party galleries. If a page is blocked by CAPTCHA/login/paywall, record the limitation — never bypass the access control to extract a colour. An invented palette is a guess with hex codes, not a design system.
       Enforce **Code vs. Asset Splitting**: UI components (buttons, input fields, badges, cards, navigation shells) MUST be authored in semantic HTML/CSS code; only photographic imagery, standalone 3D illustrations, and brand vector marks may reside in asset files. Never export styled UI containers as flat background images.
       select exactly 1 primary benchmark, cross-check palette vs the logo brief (later) → docs/design/inspiration/notes.md
       ⛔ FORBIDDEN: inventing a reference; notes.md is agent output, never the reference
 ▼ 0A. LOGO_DESIGN_BRIEF.md & Vector SVG Brand Assets
       Define name, philosophy, vibe, and seed colors (≤2KB) → `docs/design/brand/LOGO_DESIGN_BRIEF.md` (or `docs/specs/`).
       Generate clean, production-grade vector SVG assets in `docs/design/brand/` (and/or `assets/logo/`):
       - `docs/design/brand/logo.svg` (Primary brand logo lockup: mark + logotype)
       - `docs/design/brand/favicon.svg` or `logo-icon.svg` (1:1 square icon mark for favicon and app icons)
       - `docs/design/brand/logo-horizontal.svg` (Slim horizontal lockup for desktop navbar/topbar)
       - `docs/design/brand/logo-dark.svg` (High-contrast dark mode variant)
       Craft standards: Valid SVG, explicit `viewBox`, all typography converted to path outlines (no raw <text> requiring local OS fonts), zero raster <image> embedding, zero <foreignObject>. Audit mechanically via `python3 scripts/design/svg_audit.py docs/design/brand/logo.svg`.
 ▼ 0B. SITEMAP.md (Dedicated Per-Role RBAC Sections)
       Derived directly from SCOPE_STATEMENT.md (1-to-1 mapping of P0/P1 Feature Inventory, RBAC Matrix, & User Stories).
       MUST NOT lump all routes into a single ambiguous table. Organize into explicit dedicated sections per role:
       1. Public / Guest Sitemap (`SCR-PUB-01..NN`): `/`, `/login`, `/register`, `/forgot-password`.
       2. User / Member / Tenant Sitemap (`SCR-USR-01..NN`): `/user/dashboard`, `/user/profile`, resource CRUD.
       3. Staff / Operational Sitemap (`SCR-STF-01..NN`): `/ops/workspace`, `/ops/queue`, `/ops/stock-opname`.
       4. Admin / Owner Sitemap (`SCR-ADM-01..NN`): `/admin/dashboard`, `/admin/users`, `/admin/audit-logs`, `/admin/settings`.
       Specify route URL, screen name, purpose, layout shell, priority, breadcrumbs, and explicit RBAC route guard/redirects.
 ▼ 0C. COMPONENT_REQUIREMENTS.md (Exhaustive & Anti-Omission Audit)
       Map every in-scope feature to concrete UI patterns. Tabulate 3-tier inventory with WCAG 2.2 AA enforcement:
       1. Primitives: `Button`, `Input`, `Textarea`, `PopoverMenu` (custom floating; zero raw native select), `Badge`, `Checkbox`, `LoadingSpinner`, `Icon` (Lucide SVG, zero emoticons).
       2. Standard Composites:
          - `FormField` with accessible label, inline error message (≥13px, ≥4.5:1 contrast), and first-invalid auto-focus (*Anti-Disabled Pristine*).
          - `SubmitButton` with debounced loading state (`disabled={isSubmitting}` + spinner + text shift) to prevent double-click transactions.
          - `CurrencyInput` / `NumericInput` with live dot/comma separator formatting (`inputmode="numeric"`, never `type="number"`).
          - `Card` (Header, Title, Content, Footer).
          - `Table` with **Mobile Table Card Reflow** (<640px stacks into key-value cards instead of broken horizontal scroll).
          - `Modal` (z-50) & `ConfirmDialog` with typing confirmation for destructive actions.
          - `PopoverMenu` (z-55) ensuring dropdowns inside modals render above modal content.
          - `Toast` (z-60) with **Non-Dismissing Error/Offline Rule** (success toasts auto-dismiss; error/network toasts remain until dismissed).
          - `SearchInput` + `FilterPills` + `ClearButton` toolbar.
          - `EmptyState` with illustration + heading + actionable CTA.
       3. Domain Composites: Tailored to project (e.g. `POSCartDock`, `ThermalPrintView`, `BlindOpnameInput`, `OfflineSyncBadge`).
 ▼ 1. DESIGN.md (Extracted Tokens & Full Typographic / Color Scale)
       Stored at `docs/harness-root/DESIGN.md` (staged for root in M06):
       - **Section 0 (Provenance Log)**: Mark each token ✅ observed from benchmark or 🔶 inferred.
       - **Complete Typographic Hierarchy**:
         - Display / Hero (36–48px, leading-tight, bold)
         - H1 Page Title (28–32px, leading-snug, bold)
         - H2 Section Header (22–24px, leading-normal, semibold)
         - H3 Card Title (18–20px, semibold)
         - H4 Subtitle (16px, medium)
         - Body Primary (14–16px; 16px strictly enforced on mobile form inputs to stop iOS auto-zoom)
         - Small / Caption / Helper (12–13px, contrast ≥4.5:1)
         - Monospace & Tabular Numerals (`font-variant-numeric: tabular-nums;` for all currency, tables, counters).
       - **Complete Semantic Triad Color Tokens**:
         - Success: Text `#065F46`, Border `#A7F3D0`, Bg `#ECFDF5` (tested ≥4.5:1 AA)
         - Warning: Text `#92400E`, Border `#FDE68A`, Bg `#FFFBEB`
         - Destructive: Text `#991B1B`, Border `#FECACA`, Bg `#FEF2F2`
         - Info: Text `#1E40AF`, Border `#BFDBFE`, Bg `#EFF6FF`
       - **Spacing, Radius & Z-Index Scale**:
         - Spacing tokens in multiples of 4px (`--space-1`=4px .. `--space-16`=64px).
         - Radius scale (`--radius-sm`, `--radius-md`, `--radius-lg`, `--radius-full`).
         - Z-Index hierarchy: Base (0), Sticky Nav (10), Bottom Bar (20), Modal Backdrop (40), Modal Content (50), Popover (55), Toast (60).
       - **Visual Craft**: Use a coherent icon set, visible keyboard focus, and intentional effects grounded in the reference and usability needs; avoid generic decoration that weakens hierarchy or readability.

 ▼ 1.5. Reusable Component Showcase First (MANDATORY STOP & ACC)
       Before assembling screen prototypes, the agent MUST author the reusable component library:
       - Scaffold `docs/design/components/index.html` (or modular component files) linked to `docs/design/shared/css/styles.css` and `docs/design/shared/js/app.js`.
       - Render working, tactile instances of all primitives and composites: Buttons, FormFields, Inputs, Popovers, Cards, Table Card Reflow, Badges, Modals, and Toasts.
       - ⛔ **STOP & ACC**: Present the Component Showcase to the human. Once approved (ACC), proceed to screen assembly. This eliminates copy-paste drift and guarantees 100% component consistency across screens.
 ▼ 2. Author Interactive Prototype (Unified HTML/CSS/JS in Dedicated Role Subfolders)
        Build interactive HTML screens in `docs/design/screens/<role>/` linked to global shared CSS (`docs/design/shared/css/styles.css`) and global JS (`docs/design/shared/js/app.js`).
        **ZERO RUNTIME ROLE SWITCHER**:
        - Abolish complex `#role-switcher` DOM-hiding hacks.
        - Structure screens directly into clean role subfolders:
          - `docs/design/screens/public/` (e.g. `index.html`, `login.html`, `register.html`)
          - `docs/design/screens/user/` (e.g. `dashboard.html`, `profile.html`, `resources.html`)
          - `docs/design/screens/staff/` (e.g. `workspace.html`, `queue.html`)
          - `docs/design/screens/admin/` (e.g. `dashboard.html`, `users.html`, `audit-logs.html`, `settings.html`)
        - Reusable Component Assembly: Assemble screens using the pre-approved components from Step 1.5.
        - Full Coverage: 100% of screens declared in `SITEMAP.md` (`SCR-01..SCR-NN`) must be visually prototyped.
        **Visual Benchmark DNA & Anti-Slop Prototype Fidelity Rules (MANDATORY)**:
        - **Spatial & Timeline Grid Fidelity**: If the benchmark features a Gantt-style schedule or calendar timeline with date columns, the prototype MUST implement an authentic CSS Grid with column-aligned horizontal event spans. Creating flat, full-width `w-full` table rows that disregard the date columns above them is STRICTLY FORBIDDEN as Fake Timeline Slop.
        - **Micro-Indicator Fidelity**: If the benchmark utilizes segmented progress dashes (e.g. 5 segmented pill dashes), the prototype MUST implement segmented dashes instead of substituting a generic continuous progress line.
        - **Curated Color Temperature**: Card backgrounds and accents must extract the exact curated hex colors from the benchmark (e.g. warm coral `#FF5B37`, carbon black `#141518`). Uncalibrated neon or raw saturated hues (such as `#FF5722` or default unstyled Tailwind orange) are PROHIBITED.
        - **Action Density & Calm Hierarchy**: Side drawers and list cards must maintain visual calm. A maximum of 1 primary action or clean circular checkmark per card; stuffing 3-4 competing action buttons inside a single list card is PROHIBITED.
        - **Card Photos & Rich Media Asset Preservation**: If the benchmark displays photographic media, cover images, room/product preview cards, banners, or photo avatars, the prototype MUST include authentic image assets (curated high-resolution Unsplash URLs with semantic keywords or local image assets in `public/images/`) with matching aspect ratios (`aspect-video`, `aspect-[4/3]`, `aspect-square`), object-cover fitting (`object-cover rounded-xl`), and subtle inner border (`ring-1 ring-black/5`). Stripping away card imagery into flat text-only boxes or raw monochrome initial circles is STRICTLY FORBIDDEN as Card Slop.
        - **Unified SVG Iconography (Zero Emoticons)**: Jangan pernah menggunakan emoticon atau emoji; selalu gunakan icons (SVG). Prototypes and prompts must use a single cohesive SVG icon system (e.g. Lucide icons or Heroicons) with matching stroke width (e.g. `stroke-[1.75]`), consistent size scales (`h-4 w-4` / `h-5 w-5`), and subtle muted colors (`text-slate-400 group-hover:text-slate-600`). Raw emoticons/emojis, mismatched icon styles, or low-res raster icon snippets are STRICTLY PROHIBITED.
        - **Avatar & Search Bar Craft**: Avatars must use high-fidelity circular representations with soft borders and clean counter badges (`+8`); avoid harsh monochrome text circles (`PK`, `BS`). Search bars must feature concise, realistic placeholders (`Find your Task, Projects ...`) rather than explanatory tutorials.
        - **Select Controls**: Use native `<select>` when its platform behavior improves accessibility or mobile usability. Use a custom popover only when the interaction needs richer behavior; preserve keyboard operation, focus management, and screen-reader semantics.
        - **Purposeful Feedback and Motion**: Interactive controls need clear hover, active, focus, pending, and result feedback. Add animation only when it clarifies a state change or supports the chosen design direction; honor `prefers-reduced-motion` and keep controls usable without motion. Use dialogs and in-page notifications for meaningful prototype flows instead of raw `alert()`, `confirm()`, or `prompt()`.
        - **Full-Screen Prototype Coverage (Zero Single-Screen Cop-Out)**: Dedicated screens in `docs/design/screens/<role>/` covering 100% of all screens defined in `SITEMAP.md` (`SCR-01..SCR-NN`) without relying on runtime role switcher hacks. Creating only `index.html` (Dashboard) while leaving the rest of the application to be invented from scratch in M06 is STRICTLY PROHIBITED. M06 FE development is an exact 1-to-1 conversion of approved prototype HTML into React/Next.js components.
        - **Zero Spec Identifier Leaks**: Internal spec codes (`SCR-xx`, `REQ-xx`, `M06-FE-xx`, `FSD-xx`) are project management metadata. They MUST NEVER appear in user-facing UI badges, headings, cards, or microcopy.
        - **Modular & Reusable Component Architecture (Shared CSS & JS Standard)**: Prototype screens in `docs/design/screens/<role>/` MUST NOT be authored as isolated, monolithic HTML files containing duplicate inline `<style>` tags or arbitrary hardcoded styles that drift across pages. Each screen HTML (`index.html`, `dashboard.html`, etc.) MUST link to the single centralized stylesheet (`../../shared/css/styles.css`) and centralized script (`../../shared/js/app.js`). All design tokens from `DESIGN.md` (colors, typography, spacing, radius) and reusable component classes (`.btn`, `.card`, `.badge`, `.navbar`, `.sidebar`, `.form-input`) must reside in `shared/css/styles.css` so button sizes, card paddings, font scales, badges, navbars, and colors remain 100% consistent across every screen in `SITEMAP.md`.
  ▼ 2.5 Wireflow Scenarios & Interaction Runbooks (docs/specs/wireflows/SCENARIOS_WFxx.md)
        Authored in tandem with screen prototype assembly (using `templates/02-design/SCENARIOS_WF_TEMPLATE.md`):
        - Every distinct wireflow screen (WF-01..WF-NN / SCR-01..SCR-NN) gets a companion testing runbook in `docs/specs/wireflows/`.
        - Documents: (1) Testing Baseline Fixture (USR-01..USR-NN with seed credentials & RBAC scopes);
                     (2) Exhaustive Happy Path with exact action sequences & dynamic redirection;
                     (3) Exhaustive Sad Path & Edge Cases discovered during prototyping (validation errors, disabled/expired roles, multi-unit states, force password change);
                     (4) UI Feedback Behavior (toasts, dialogs, inline error highlights, spinner states).
        - These runbooks bridge design and engineering: they ensure the prototype HTML/JS implements real-world edge cases before freezing design, provide exact business logic requirements for M05 (FSD), and serve as the verified test execution runbooks in M07 (QA/SIT) and M09 (UAT).
 ▼ 3. DESIGN_SPEC.md (DESIGN_SPEC_TEMPLATE.md) — every in-scope screen (SCR-01..SCR-NN) with:
        - Exhaustive 5-state matrix: Default, Loading Skeleton, Empty State (with actionable CTA), Error State (with retry CTA), and Success/Feedback.
        - Concrete State Copy: Real human-grade microcopy (no "Lorem ipsum" or generic "Terjadi kesalahan").
        - Destructive Action Safety: Require confirmation dialog with explicit keyword typing and audit reason.
        - Mobile Virtual Keyboard Defense: `scroll-padding-bottom` (≥96px) to keep focused inputs visible above mobile keyboard and bottom nav.
 ▼ 4. Professional UI/UX Consistency Audit & Auto-Fix Pass — Execute `python3 scripts/design/uiux_audit.py docs/design/screens/ --fix` (Windows: `powershell -ExecutionPolicy Bypass -File scripts/design/uiux-audit.ps1 -Fix`). The agent audits every generated screen against the design system:
        - **Component Uniformity**: 100% button heights, card paddings, font scales, and badge styles conform to `.btn`, `.card`, `.badge`, `.form-input` across all screens.
        - **Animation & Motion Discipline**: Uniform transitions (`duration-150 ease-out`), active press compression (`active:scale-[0.98]`), modal/drawer choreographies, and `prefers-reduced-motion` compliance.
        - **Zero Emoticons**: Eliminates all raw unicode emojis in UI; ensures cohesive vector SVG icons are used everywhere.
        - **Cross-Screen Parity**: Guarantees identical navbar/sidebar items, brand lockup, and layout shell across all screens in `SITEMAP.md`.
        - **Auto-Fixing**: Automatically resolves missing shared stylesheet links, missing mobile viewports, and styling discrepancies before presenting to the human.
       If an interactive browser tool is already available, use it for one focused check of each P0 flow at mobile and desktop widths: exercise the primary path and one important error/recovery state, inspect console errors, and compare the rendered screen with its reference. Fix observed issues and repeat the affected check; record any unverified viewport or flow. Do not add a browser dependency solely for this optional check.
 ▼ 5. Walkthrough + Design Freeze — Present a side-by-side comparison of the prototype and its reference. Review visual fidelity (layout, components, color, data density), task completion (clear primary action, next step, and recovery from errors), craft (tokens, responsive behavior, keyboard and assistive-technology access), and trust (clear feedback and understandable errors). Rate the five dimensions in the Visual Review table in `DESIGN_SPEC.md` from 0 (missing/blocking) to 2 (clear and supported by evidence); use the score to expose weak areas, not as a substitute for fixing blockers or human approval. Record issues and decisions there; the human opens the prototype and signs the Design Freeze. Moving to M05/M06 before Design Freeze is strictly forbidden.
       For landing, signup, onboarding, or paywall flows with an explicit conversion goal, also review clarity of the offer, effort/friction, trust cues, and recovery from hesitation. Use goals and audience evidence from discovery; avoid manipulative patterns. Skip this review when conversion is not a project outcome.
OUTPUT: 6 COMPLETE ARTIFACTS + COMPONENT SHOWCASE + SCREEN PROTOTYPES + INTERACTION SCENARIOS → proceed to Module 05
```
