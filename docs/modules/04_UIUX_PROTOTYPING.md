# Module 04: UI/UX Design & Prototyping

> **Templates to copy**: `templates/02-design/` (SITEMAP, COMPONENT_REQUIREMENTS, DESIGN_SPEC, SCREEN_PROMPT) · `templates/02-design/references/inspiration-template/NOTES_TEMPLATE.md` (benchmark notes → `docs/design/inspiration/notes.md`)
> 📖 **Optional** (do NOT preload): `references/solo/SOLO_UIUX_GUIDE.md` · `references/design/LOGO_DESIGN_CRAFT_GUIDE.md` (optical corrections, 8 mark types, SVG craft rules) · `references/design/BRAND_VOICE_GUIDE.md` (tone sliders, word bank, error-state microcopy) · `references/design/CONTENT_QUALITY_SCORECARD.md` (four-standard scoring for every user-facing string) · `templates/02-design/STATE_COPY_TEMPLATE.md` (empty/error/success/loading/onboarding copy) · `references/design/AI_WRITING_TELLS.md` (structural AI tells, false positives, human signals) · `references/design/DESIGN_TO_CODE_FIDELITY_GUIDE.md` (viewport vs capture pixels, region measurement, `scripts/design/compare_png.py`) · `references/design/UI_MOTION_GUIDELINES.md` (durations, easing, reduced-motion) · `references/design/MOTION_PERSONALITY_GUIDE.md` (which motion, and how it should feel) · `templates/01-discovery-commercial/BRAND_MESSAGING_HIERARCHY.md` (essence, value pillars, audience pitch matrix) · `patterns/product/BRAND_STRATEGY_AND_IDENTITY_PATTERN.md` §2–§3 (the position and name this identity must express) · `patterns/ui/SCROLL_SCRUBBED_WORLD_PATTERN.md` (scroll-driven cinematic hero: seam law, camera A/B, blob-seek) · `patterns/architecture/SVG_TECHNICAL_DIAGRAM_STANDARD_PATTERN.md` (clean SVG diagram house style) · deep dive [`deep-dives/04_UIUX_PROTOTYPING.md`](deep-dives/04_UIUX_PROTOTYPING.md) — full A–E workflows, Figma MCP, root causes, Decision Matrix.

This module translates `SCOPE_STATEMENT.md` (+ valid SOW, or M03 waived for Solo SaaS) into 6 authoritative design artifacts that serve as the UI source of truth: `docs/specs/SITEMAP.md`, `docs/specs/COMPONENT_REQUIREMENTS.md`, `docs/specs/LOGO_DESIGN_BRIEF.md`, `docs/design/inspiration/notes.md`, `docs/harness-root/DESIGN.md` (staged; deployed to root in M06), and `docs/specs/DESIGN_SPEC.md`.

In addition, it produces vector SVG assets in `assets/logo/`, an interactive reusable component showcase in `docs/design/components/index.html` (reviewed & ACC'd by the human first), and a 100% complete interactive prototype organized cleanly into role subfolders (`docs/design/screens/<role>/`) sharing global CSS and JS.

**Step 0.5 is the module's front door (all scales).** No logo, no component inventory, no `DESIGN.md` — nothing visual — may be produced until the **human** has placed at least one reference (multiple references encouraged) in `docs/design/inspiration/`. An agent-authored `notes.md` is analysis output, never the reference itself; a benchmark with no corresponding reference file is fabrication. If the folder holds no human-supplied file: **STOP AND ASK, END TURN** (`⛔ STOP 0.5` below).

**Scale calibration** (from `docs/pm/PROJECT_STATE.md` / `PROJECT_LITE.md`): **Small (M04-LITE)** — run the standalone LITE runbook [`variants/04_UIUX_LITE.md`](variants/04_UIUX_LITE.md) instead of this one. **Medium/Large** — full artifacts ≥2000B, logo ≥200B, 5-state matrix on all screens. **Enterprise** (non-solo capacity) — redirect to Seri A Advisory (Fase A02).

## 1. Execution Cycle (Steps 0A–5)

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
 ▼ 5. Walkthrough + Design Freeze — Present a side-by-side comparison of the prototype and its reference. Review visual fidelity (layout, components, color, data density), task completion (clear primary action, next step, and recovery from errors), craft (tokens, responsive behavior, keyboard and assistive-technology access), and trust (clear feedback and understandable errors). Record issues and decisions in the existing Visual Benchmark Review checklist in `DESIGN_SPEC.md`; the human opens the prototype and signs the Design Freeze. Moving to M05/M06 before Design Freeze is strictly forbidden.
OUTPUT: 6 COMPLETE ARTIFACTS + COMPONENT SHOWCASE + SCREEN PROTOTYPES + INTERACTION SCENARIOS → proceed to Module 05
```

### M04-LITE Pragmatic Rules (Scale: Small)
1. Placeholder initials SVG allowed at `assets/logo/logo.svg` (monogram 1–2 letters, brand accent, ≥50 bytes).
2. 1 real web/dashboard benchmark is enough (Linear, Vercel, TailwindUI, Stripe) with reason + colors in `notes.md`.
3. Full 5-state matrix only for 1–3 main data screens; secondary screens need default state only.
4. All 6 deliverables still required, proportional and concise (1–2 pages per document).

**Step 0C validation rules**: nomenclature parity (100% names in mapping exist in inventory) · Anti-Disabled Pristine (submit never disabled pristine; click triggers validation + autofocus) · Non-dismissing error/offline toasts · `inputmode="numeric"` for currency, never `type="number"` · Modal/popover layers preserve access to nested controls · Error text ≥13px, ≥4.5:1 · **Mobile Table Card Reflow**: Data tables on viewports `<640px` MUST reflow into stacked key-value cards (never unconstrained horizontal scroll that hides action buttons) · **Keyboard Access**: Never remove focus indication without a visible replacement; verify all actions by keyboard.

**Step 0.5 acceptance (gate-enforced, every scale)**: `docs/design/inspiration/` contains ≥1 file that is not `notes.md`/`README.md`/`NOTES_TEMPLATE.md`/dotfile, and `notes.md` cites a filename that actually exists in that folder. `validate-gate.sh M04` fails without both; M06 re-checks it for projects that started before this rule existed.

## 2. Outputs
`docs/specs/LOGO_DESIGN_BRIEF.md` · `docs/specs/SITEMAP.md` · `docs/specs/COMPONENT_REQUIREMENTS.md` · `docs/design/inspiration/notes.md` · `docs/harness-root/DESIGN.md` · `docs/specs/DESIGN_SPEC.md` — plus `docs/design/brand/` (`logo.svg`, `favicon.svg`, `logo-horizontal.svg`, `logo-dark.svg`), `assets/media/`, reusable component showcase in `docs/design/components/index.html` (verified and ACC'd by human first), wireflow interaction runbooks in `docs/specs/wireflows/` (`SCENARIOS_WF01.md`..`SCENARIOS_WFNN.md`), and interactive prototype screens in dedicated role subfolders `docs/design/screens/<role>/` (sharing `docs/design/shared/css/styles.css` and `docs/design/shared/js/app.js`).
Location rules: `DESIGN_SPEC.md` MUST be in `docs/specs/` (root placement forbidden). DESIGN.md + DESIGN_SPEC.md mandatory regardless of prototype choice.
Viewport Precedence: apply [`patterns/ui/RESPONSIVE_DESIGN_PRIORITY_PATTERN.md`](../../patterns/ui/RESPONSIVE_DESIGN_PRIORITY_PATTERN.md) — Mobile-First is default for consumer/SaaS/portals; Desktop-First permitted only for dense ERP/canvas tools with mobile card reflow.

## 3. Gate Exit Criteria [GATE] — BLOCKING Checklist

### Design Pre-Conditions
- [ ] **DESIGN PRE-CONDITION (Step 0.5, every scale): `docs/design/inspiration/` holds ≥1 HUMAN-supplied reference file (multiple references supported; not `notes.md`/`README.md`/`NOTES_TEMPLATE.md`/dotfile). No logo, components, SITEMAP, or DESIGN.md may be produced before it exists — the agent STOPs and asks.**
- [ ] **DESIGN PRE-CONDITION: `assets/logo/` contains production-ready vector SVGs (`logo.svg`, `favicon.svg` / `logo-icon.svg`, `logo-horizontal.svg`, `logo-dark.svg`, ≥50B Small-LITE / ≥200B Medium+), referenced by DESIGN.md.**
- [ ] **LOGO CRAFT (gate-enforced mechanically):** `python3 scripts/design/svg_audit.py assets/logo/logo.svg` reports **zero FAIL** findings. A `FAIL` on live `<text>`, an embedded raster `<image>`, `<foreignObject>`, or a missing `viewBox` blocks the gate — a logo that renders differently per machine, or cannot be cut/embroidered, is not deliverable. `WARN`/`INFO` findings are advisory: fix them or state why the choice is deliberate. A file named `.svg` that does not parse as SVG is rejected as a placeholder.
- [ ] **DESIGN PRE-CONDITION: `docs/design/inspiration/notes.md` exists with selected benchmark (≥200B), logo hex extraction, palette decisions, and cites a reference filename that exists in that folder.**

### Mandatory Files
- [ ] `docs/specs/COMPONENT_REQUIREMENTS.md` exists (≥1000B; 3-tier inventory Primitives/Composites + WCAG accessibility).
- [ ] `docs/specs/LOGO_DESIGN_BRIEF.md` exists (≥500B and ≤2KB).
- [ ] `docs/specs/SITEMAP.md` exists (≥1000B Small / ≥2000B Medium+; dedicated per-role RBAC sitemap sections, screen inventory, flows, navigation).
- [ ] `docs/harness-root/DESIGN.md` exists, staged (≥1000B; full typographic scale H1-H4/body/tabular, semantic triad colors, z-index scale, spacing).
- [ ] `docs/specs/DESIGN_SPEC.md` exists (≥1000B Small / ≥2000B Medium+; per-screen 5-state specs + motion/interaction directives + destructive confirmation safety).
- [ ] **Reusable Component Showcase ACC**: `docs/design/components/index.html` created and approved by user before full-screen assembly.
- [ ] **Wireflow Interaction Scenarios**: `docs/specs/wireflows/` covers nominal (happy path), validation, and domain exception (sad path) test runbooks (`SCENARIOS_WFxx.md`) for prototyped wireflow screens.
- [ ] **Interactive prototype screens exist**: `docs/design/screens/<role>/` covers 100% of routes in `SITEMAP.md` structured cleanly per role (no runtime role switcher hacks); **screen count match**: SITEMAP total routes == DESIGN_SPEC wireflow screens.

### Accessibility & Anti-Slop (computed, not self-approved)
- [ ] **WCAG contrast (DESIGN.md tokens, light & dark): primary text ≥7.0:1; secondary + placeholder + status ≥4.5:1; input borders ≥3:1.**
- [ ] **Usability and accessibility**: non-color state indicators; 16px mobile inputs; ≥44px touch targets; defined z-index layers; reduced-motion support; visible keyboard focus; and no `will-change` outside active animation. Choose blur, shadows, typography, and motion to fit the reference and preserve contrast, legibility, performance, and task completion; no visual treatment is prohibited by name alone.
- [ ] **Keyboard & Mobile Polish: explicit `focus-visible:ring-2` on all interactive elements (zero unstyled `outline: none`); data tables reflow into stacked cards on mobile viewports `<640px`.**
- [ ] **Form Submission Guardrail: all mutating form action buttons MUST declare a pending/submitting state (`disabled={isSubmitting}` with spinner + text transition) and UI debounce to prevent rapid double-clicks and race-condition duplicate orders on high-latency networks.**
- [ ] **Reusable Prototype Architecture: Screens in `docs/design/screens/<role>/` link to shared CSS (`docs/design/shared/css/styles.css`) and shared JS (`docs/design/shared/js/app.js`); zero disjointed inline `<style>` duplicates or mismatched buttons, badges, navbars, cards, and typography across sitemap screens.**

### Design Freeze Sign-Off (BLOCKING, in DESIGN_SPEC.md)
- [ ] Approver name (Client PIC, or the **human user** on solo projects) + date (YYYY-MM-DD) + signature placeholder ("Approved via [email/chat]"). The AI agent is never a valid approver.

Optional: user testing (client projects): ≥2 iterations × 5+ users, SUS ≥70; prototype URL / Figma link.

## 4. Gate Invocation & Continue Rules

**MANDATORY**: execute the validator, paste its EXACT terminal output (no hardcoded checklists). If it exits `❌ Gate validation FAILED`, fix artifacts and re-run — do NOT declare completion.
```
./scripts/gates/validate-gate.sh M04
```
(Windows: `./scripts/gates/validate-gate.ps1 M04`)

Only after `✅ Gate validation PASSED` (exit 0), present the handoff summary. M04 is not a SKILL.md stop point: for Small/Solo SaaS continue to M05 in the same flow; pause for explicit approval on Client projects ("Design approved" / "Proceed to Module 05"). If the user requests changes: regenerate affected files and re-run the gate. On approval, carry DESIGN.md + DESIGN_SPEC.md forward as references for Module 05 (Architecture & FSD).

> **AUTHORITATIVE WORKFLOW OVERRIDE**
