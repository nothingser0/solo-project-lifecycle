# Module 04: UI/UX Design & Prototyping

> **Templates to copy**: `templates/02-design/` (SITEMAP, COMPONENT_REQUIREMENTS, DESIGN_SPEC, SCREEN_PROMPT) · `templates/02-design/references/inspiration-template/NOTES_TEMPLATE.md` (benchmark notes → `docs/design/inspiration/notes.md`)
> 📖 **Optional** (do NOT preload): `references/solo/SOLO_UIUX_GUIDE.md` · `references/design/LOGO_DESIGN_CRAFT_GUIDE.md` (optical corrections, 8 mark types, SVG craft rules) · `references/design/BRAND_VOICE_GUIDE.md` (tone sliders, word bank, error-state microcopy) · `references/design/CONTENT_QUALITY_SCORECARD.md` (four-standard scoring for every user-facing string) · `templates/02-design/STATE_COPY_TEMPLATE.md` (empty/error/success/loading/onboarding copy) · `references/design/AI_WRITING_TELLS.md` (structural AI tells, false positives, human signals) · `references/design/DESIGN_TO_CODE_FIDELITY_GUIDE.md` (viewport vs capture pixels, region measurement, `scripts/design/compare_png.py`) · `references/design/UI_MOTION_GUIDELINES.md` (durations, easing, reduced-motion) · `references/design/MOTION_PERSONALITY_GUIDE.md` (which motion, and how it should feel) · `templates/01-discovery-commercial/BRAND_MESSAGING_HIERARCHY.md` (essence, value pillars, audience pitch matrix) · `patterns/product/BRAND_STRATEGY_AND_IDENTITY_PATTERN.md` §2–§3 (the position and name this identity must express) · `patterns/ui/SCROLL_SCRUBBED_WORLD_PATTERN.md` (scroll-driven cinematic hero: seam law, camera A/B, blob-seek) · `patterns/architecture/SVG_TECHNICAL_DIAGRAM_STANDARD_PATTERN.md` (clean SVG diagram house style) · deep dive [`deep-dives/04_UIUX_PROTOTYPING.md`](deep-dives/04_UIUX_PROTOTYPING.md) — full A–E workflows, Figma MCP, root causes, Decision Matrix.

This module translates `SCOPE_STATEMENT.md` (+ valid SOW, or M03 waived for Solo SaaS) into 6 authoritative design artifacts that serve as the UI source of truth: `docs/specs/SITEMAP.md`, `docs/specs/COMPONENT_REQUIREMENTS.md`, `docs/specs/LOGO_DESIGN_BRIEF.md`, `docs/design/inspiration/notes.md`, `docs/harness-root/DESIGN.md` (staged; deployed to root in M06), and `docs/specs/DESIGN_SPEC.md`.

**Step 0.5 is the module's front door (all scales).** No logo, no component inventory, no `DESIGN.md` — nothing visual — may be produced until the **human** has placed at least one reference in `docs/design/inspiration/`. An agent-authored `notes.md` is analysis output, never the reference itself; a benchmark with no corresponding reference file is fabrication. If the folder holds no human-supplied file: **STOP AND ASK, END TURN** (`⛔ STOP 0.5` below).

**Scale calibration** (from `docs/pm/PROJECT_STATE.md` / `PROJECT_LITE.md`): **Small (M04-LITE)** — run the standalone LITE runbook [`variants/04_UIUX_LITE.md`](variants/04_UIUX_LITE.md) instead of this one. **Medium/Large** — full artifacts ≥2000B, logo ≥200B, 5-state matrix on all screens. **Enterprise** (non-solo capacity) — redirect to Seri A Advisory (Fase A02).

## 1. Execution Cycle (Steps 0A–5)

```text
INPUT: SCOPE_STATEMENT.md & Valid SOW (or M03 Waived for Solo SaaS)
 ▼ 0.5 Inspiration Intake & Effect Cues — FIRST, BLOCKING, EVERY SCALE
       The human places >=1 reference in docs/design/inspiration/ (screenshot, brand board, short video clip, or links.md of URLs).
       Crucial: if providing static screenshots without live URLs, the human MUST specify desired dynamic effects directly (e.g. parallax scroll, 3D Spline canvas, video background, stagger text animation, hover micro-interactions).
       ⛔ STOP 0.5: if that folder holds no human-supplied file → END TURN and ask. Do NOT create
          LOGO_DESIGN_BRIEF.md, assets/logo/, SITEMAP.md, COMPONENT_REQUIREMENTS.md, or DESIGN.md first.
       Then: scaffold docs/design/inspiration/, analyze 2–5 references, capture human effect specifications.
       If the project archetype requires specific layout zones (e.g. Bookmark Manager, Notion-like Workspace, File Explorer), execute **`web_search`** against leading industry benchmarks (e.g. `Raindrop.io`, `Linear`, `Vercel`) to discover standard multi-zone layouts and prevent arbitrary omission.
       If references include live URLs (`links.md`), execute **Source-Aware CSS Inspection**: inspect the live DOM/computed CSS of the benchmark to extract exact CSS tokens (`background-color`, primary brand hex, `font-family`, button `border-radius`, and card shadow depth) instead of guessing values from memory.
       **Record every token's provenance** in `DESIGN.md` §0 (Evidence & Inference Log): mark each value ✅ observed (computed CSS / SVG fill / font declaration) or 🔶 inferred (a decision no source states). Prefer official pages, press kits, and CSS over third-party galleries. If a page is blocked by CAPTCHA/login/paywall, record the limitation — never bypass the access control to extract a colour. An invented palette is a guess with hex codes, not a design system.
       Enforce **Code vs. Asset Splitting**: UI components (buttons, input fields, badges, cards, navigation shells) MUST be authored in semantic HTML/CSS code; only photographic imagery, standalone 3D illustrations, and brand vector marks may reside in asset files. Never export styled UI containers as flat background images.
       select exactly 1 primary benchmark, cross-check palette vs the logo brief (later) → docs/design/inspiration/notes.md
       ⛔ FORBIDDEN: inventing a reference; notes.md is agent output, never the reference
 ▼ 0A. LOGO_DESIGN_BRIEF.md — name/philosophy/vibe/seed colors (≤2KB) → docs/specs/LOGO_DESIGN_BRIEF.md; save logo to assets/logo/ (logo.svg | logo.png)
 ▼ 0B. SITEMAP.md — hierarchy, 3–5 critical flows, breadcrumbs, States/RBAC (SITEMAP_TEMPLATE.md) → docs/specs/SITEMAP.md
 ▼ 0C. COMPONENT_REQUIREMENTS.md (TEMPLATE) — features→UI patterns, 3-tier inventory (Primitives/Standard Composites/Domain Composites), 5-state matrix, WCAG 2.2 AA (prevents AI slop)
 ▼ 1. DESIGN.md — from benchmark + logo: tokens, computed WCAG ratios, z-index scale → docs/harness-root/DESIGN.md (staged)
 ▼ 2. Choose prototyping workflow (visual mandatory): A AI prototype code (v0/Bolt/Lovable export into `docs/design/screens/`) | B Design tool export/handoff (Figma/Penpot exported assets/previews into `docs/design/screens/`). (Pure text/markdown abolished).
        **Visual Benchmark DNA & Anti-Slop Prototype Fidelity Rules (MANDATORY)**:
        - **Spatial & Timeline Grid Fidelity**: If the benchmark features a Gantt-style schedule or calendar timeline with date columns, the prototype MUST implement an authentic CSS Grid with column-aligned horizontal event spans. Creating flat, full-width `w-full` table rows that disregard the date columns above them is STRICTLY FORBIDDEN as Fake Timeline Slop.
        - **Micro-Indicator Fidelity**: If the benchmark utilizes segmented progress dashes (e.g. 5 segmented pill dashes), the prototype MUST implement segmented dashes instead of substituting a generic continuous progress line.
        - **Curated Color Temperature**: Card backgrounds and accents must extract the exact curated hex colors from the benchmark (e.g. warm coral `#FF5B37`, carbon black `#141518`). Uncalibrated neon or raw saturated hues (such as `#FF5722` or default unstyled Tailwind orange) are PROHIBITED.
        - **Action Density & Calm Hierarchy**: Side drawers and list cards must maintain visual calm. A maximum of 1 primary action or clean circular checkmark per card; stuffing 3-4 competing action buttons inside a single list card is PROHIBITED.
        - **Card Photos & Rich Media Asset Preservation**: If the benchmark displays photographic media, cover images, room/product preview cards, banners, or photo avatars, the prototype MUST include authentic image assets (curated high-resolution Unsplash URLs with semantic keywords or local image assets in `public/images/`) with matching aspect ratios (`aspect-video`, `aspect-[4/3]`, `aspect-square`), object-cover fitting (`object-cover rounded-xl`), and subtle inner border (`ring-1 ring-black/5`). Stripping away card imagery into flat text-only boxes or raw monochrome initial circles is STRICTLY FORBIDDEN as Card Slop.
        - **Unified SVG Iconography**: Prototypes and prompts must use a single cohesive SVG icon system (e.g. Lucide icons or Heroicons) with matching stroke width (e.g. `stroke-[1.75]`), consistent size scales (`h-4 w-4` / `h-5 w-5`), and subtle muted colors (`text-slate-400 group-hover:text-slate-600`). Inconsistent emoji icons, mismatched icon styles, or low-res raster icon snippets are PROHIBITED.
        - **Avatar & Search Bar Craft**: Avatars must use high-fidelity circular representations with soft borders and clean counter badges (`+8`); avoid harsh monochrome text circles (`PK`, `BS`). Search bars must feature concise, realistic placeholders (`Find your Task, Projects ...`) rather than explanatory tutorials.
        - **Custom Floating Menus vs Native Select**: Form controls, filter pills, and dropdown triggers must render custom floating popovers with matching rounded corners (`rounded-2xl`), floating elevation (`shadow-xl shadow-slate-200/50` or dark equivalent), and item hover states (`hover:bg-slate-50`). Rendering raw browser native `<select>` dropdowns (which open sharp rectangular 90-degree OS menus) is STRICTLY FORBIDDEN as Dropdown Slop.
        - **Tactile Micro-Interactions & Fluid Animations (Zero Raw Browser Alerts)**: Prototypes and components must implement comprehensive tactile feedback: (1) Hover state transitions (`transition-all duration-150 ease-out`); (2) Active press tactile compression (`active:scale-[0.98]`); (3) Accessible keyboard focus (`focus-visible:ring-2 focus-visible:ring-offset-2`); (4) Modals & Popovers enter/exit choreography (`backdrop-blur-sm`, `fade-in`, and scale pop `zoom-in-95`); (5) Progress bars and dynamic metrics fluid transition (`transition-all duration-500 ease-out`). Calling raw browser OS popups (`alert()`, `confirm()`, `prompt()`) is strictly prohibited; all notifications and confirmations MUST use design-matched custom Toasts and Dialog Modals. Static, non-interactive dead prototypes are forbidden.
        - **Full-Screen Prototype Coverage (Zero Single-Screen Cop-Out)**: `docs/design/screens/` MUST contain interactive visual previews covering ALL core screens defined in `SITEMAP.md` (e.g. Dashboard, Unit List, Tenant Records, Billing & Invoicing), either as individual HTML pages (`index.html`, `billing.html`, `rooms.html`) or an interactive prototype with navigation view/tab switcher. Creating only `index.html` (Dashboard) while leaving the rest of the application to be invented from scratch in M06 is PROHIBITED. M06 FE development is an exact 1-to-1 conversion of approved prototype HTML into React/Next.js components.
        - **Zero Spec Identifier Leaks**: Internal spec codes (`SCR-xx`, `REQ-xx`, `M06-FE-xx`, `FSD-xx`) are project management metadata. They MUST NEVER appear in user-facing UI badges, headings, cards, or microcopy.
 ▼ 3. DESIGN_SPEC.md (DESIGN_SPEC_TEMPLATE.md) — every in-scope screen (SCR-01..SCR-NN) with 5-state matrix: Default, Loading Skeleton, Empty, Error, Success
 ▼ 4. (Workflow B only; SKIPPED for A) — prompts via SCREEN_PROMPT_TEMPLATE.md → docs/design/prompts/scr-xx/PROMPT.md; rendered outputs → docs/design/screens/scr-xx/
 ▼ 5. Walkthrough + Design Freeze — The agent MUST present a structured Side-by-Side Verification comparison comparing `docs/design/screens/index.html` with `docs/design/inspiration/<reference>.png` across 5 pillars (spatial layout, component anatomy, color curation, timeline grid, action density). The human user opens the prototype in browser alongside the benchmark, completes the Visual Benchmark Review checklist in `DESIGN_SPEC.md`, and signs the Design Freeze Sign-Off. Moving to M05/M06 before Design Freeze is strictly forbidden.
OUTPUT: 6 COMPLETE ARTIFACTS → proceed to Module 05
```

### M04-LITE Pragmatic Rules (Scale: Small)
1. Placeholder initials SVG allowed at `assets/logo/logo.svg` (monogram 1–2 letters, brand accent, ≥50 bytes).
2. 1 real web/dashboard benchmark is enough (Linear, Vercel, TailwindUI, Stripe) with reason + colors in `notes.md`.
3. Full 5-state matrix only for 1–3 main data screens; secondary screens need default state only.
4. All 6 deliverables still required, proportional and concise (1–2 pages per document).

**Step 0C validation rules**: nomenclature parity (100% names in mapping exist in inventory) · Anti-Disabled Pristine (submit never disabled pristine; click triggers validation + autofocus) · Non-dismissing error/offline toasts · `inputmode="numeric"` for currency, never `type="number"` · Modal dropdown (55) above dialog (50) · Error text ≥13px, ≥4.5:1 · **Mobile Table Card Reflow**: Data tables on viewports `<640px` MUST reflow into stacked key-value cards (never unconstrained horizontal scroll that hides action buttons) · **Focus-Visible Ring Discipline**: Never use `outline: none` without a high-contrast replacement; all interactive controls require explicit `focus-visible:ring-2` for keyboard accessibility.

**Step 0.5 acceptance (gate-enforced, every scale)**: `docs/design/inspiration/` contains ≥1 file that is not `notes.md`/`README.md`/`NOTES_TEMPLATE.md`/dotfile, and `notes.md` cites a filename that actually exists in that folder. `validate-gate.sh M04` fails without both; M06 re-checks it for projects that started before this rule existed.

## 2. Outputs
`docs/specs/LOGO_DESIGN_BRIEF.md` · `docs/specs/SITEMAP.md` · `docs/specs/COMPONENT_REQUIREMENTS.md` · `docs/design/inspiration/notes.md` · `docs/harness-root/DESIGN.md` · `docs/specs/DESIGN_SPEC.md` — plus `assets/logo/` (logo.svg/logo.png), `assets/media/` (dedicated directory for 3D models, video loops, Lottie JSON, and rich media assets), and, for Workflow B, `docs/design/prompts/scr-xx/PROMPT.md` + `docs/design/screens/scr-xx/`.
Location rules: `DESIGN_SPEC.md` MUST be in `docs/specs/` (root placement forbidden). DESIGN.md + DESIGN_SPEC.md mandatory regardless of prototype choice.
Viewport Precedence: apply [`patterns/ui/RESPONSIVE_DESIGN_PRIORITY_PATTERN.md`](../../patterns/ui/RESPONSIVE_DESIGN_PRIORITY_PATTERN.md) — Mobile-First is default for consumer/SaaS/portals; Desktop-First permitted only for dense ERP/canvas tools with mobile card reflow.

## 3. Gate Exit Criteria [GATE] — BLOCKING Checklist

### Design Pre-Conditions
- [ ] **DESIGN PRE-CONDITION (Step 0.5, every scale): `docs/design/inspiration/` holds ≥1 HUMAN-supplied reference file (not `notes.md`/`README.md`/`NOTES_TEMPLATE.md`/dotfile). No logo, components, SITEMAP, or DESIGN.md may be produced before it exists — the agent STOPs and asks.**
- [ ] **DESIGN PRE-CONDITION: `assets/logo/` contains `logo.svg` or `logo.png` (≥50B Small-LITE / ≥200B Medium+), referenced by DESIGN.md.**
- [ ] **LOGO CRAFT (gate-enforced mechanically):** `python3 scripts/design/svg_audit.py assets/logo/logo.svg` reports **zero FAIL** findings. A `FAIL` on live `<text>`, an embedded raster `<image>`, `<foreignObject>`, or a missing `viewBox` blocks the gate — a logo that renders differently per machine, or cannot be cut/embroidered, is not deliverable. `WARN`/`INFO` findings are advisory: fix them or state why the choice is deliberate. A file named `.svg` that does not parse as SVG is rejected as a placeholder.
- [ ] **DESIGN PRE-CONDITION: `docs/design/inspiration/notes.md` exists with selected benchmark (≥200B), logo hex extraction, palette decisions, and cites a reference filename that exists in that folder.**

### Mandatory Files
- [ ] `docs/specs/COMPONENT_REQUIREMENTS.md` exists (≥1000B; 3-tier inventory Primitives/Composites + WCAG accessibility).
- [ ] `docs/specs/LOGO_DESIGN_BRIEF.md` exists (≥500B and ≤2KB).
- [ ] `docs/specs/SITEMAP.md` exists (≥1000B Small / ≥2000B Medium+; screen inventory, flows, navigation).
- [ ] `docs/harness-root/DESIGN.md` exists, staged (≥1000B; palette + typography + z-index scale).
- [ ] `docs/specs/DESIGN_SPEC.md` exists (≥1000B Small / ≥2000B Medium+; per-screen 5-state specs + motion/interaction directives).
- [ ] Screen prompts/screens exist iff Workflow B selected; **screen count match**: SITEMAP total routes == DESIGN_SPEC wireflow screens.

### Accessibility & Anti-Slop (computed, not self-approved)
- [ ] **WCAG contrast (DESIGN.md tokens, light & dark): primary text ≥7.0:1; secondary + placeholder + status ≥4.5:1; input borders ≥3:1.**
- [ ] **Anti-slop: zero gradients, zero glassmorphism/backdrop-blur, shadows ≤4px, non-color state indicators, 16px mobile inputs, ≥44px touch targets, z-index scale defined, `prefers-reduced-motion` fallbacks on dynamic transitions, and `will-change` restricted to active animating states.**
- [ ] **Keyboard & Mobile Polish: explicit `focus-visible:ring-2` on all interactive elements (zero unstyled `outline: none`); data tables reflow into stacked cards on mobile viewports `<640px`.**
- [ ] **Form Submission Guardrail: all mutating form action buttons MUST declare a pending/submitting state (`disabled={isSubmitting}` with spinner + text transition) and UI debounce to prevent rapid double-clicks and race-condition duplicate orders on high-latency networks.**

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
