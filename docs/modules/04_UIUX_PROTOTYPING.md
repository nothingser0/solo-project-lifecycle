# Module 04: UI/UX Design & Prototyping

> **Templates to copy**: `templates/02-design/` (SITEMAP, COMPONENT_REQUIREMENTS, DESIGN_SPEC, SCREEN_PROMPT) · `templates/02-design/references/inspiration-template/NOTES_TEMPLATE.md` (benchmark notes → `docs/design/inspiration/notes.md`)
> **Optional refs** (do NOT preload): `references/design/LOGO_DESIGN_CRAFT_GUIDE.md` (mark types, SVG craft) · `references/design/DESIGN_TO_CODE_FIDELITY_GUIDE.md` (viewport vs capture pixels, `scripts/design/compare_png.py`) · `references/design/UI_MOTION_GUIDELINES.md` (durations, easing, reduced-motion). Copy/voice, scoring and motion-personality guides are in `references/design/` when a step needs them.

This module translates `SCOPE_STATEMENT.md` (+ valid SOW, or M03 waived for Solo SaaS) into 6 authoritative design artifacts that serve as the UI source of truth: `docs/specs/SITEMAP.md`, `docs/specs/COMPONENT_REQUIREMENTS.md`, `docs/specs/LOGO_DESIGN_BRIEF.md`, `docs/design/inspiration/notes.md`, `docs/harness-root/DESIGN.md` (staged; deployed to root in M06), and `docs/specs/DESIGN_SPEC.md`.

In addition, it produces vector SVG assets in `assets/logo/`, an interactive reusable component showcase in `docs/design/components/index.html` (reviewed & ACC'd by the human first), and a 100% complete interactive prototype organized cleanly into role subfolders (`docs/design/screens/<role>/`) sharing global CSS and JS.

**Step 0.5 is the module's front door (all scales).** No logo, no component inventory, no `DESIGN.md` — nothing visual — may be produced until the **human** has placed at least one reference (multiple references encouraged) in `docs/design/inspiration/`. An agent-authored `notes.md` is analysis output, never the reference itself; a benchmark with no corresponding reference file is fabrication. If the folder holds no human-supplied file: **STOP AND ASK, END TURN** (`⛔ STOP 0.5` below).

**Scale calibration** (from `docs/pm/PROJECT_STATE.md` / `PROJECT_LITE.md`): **Small (M04-LITE)** — run the standalone LITE runbook [`variants/04_UIUX_LITE.md`](variants/04_UIUX_LITE.md) instead of this one. **Medium/Large** — full artifacts ≥2000B, logo ≥200B, 5-state matrix on all screens. **Enterprise** (non-solo capacity) — redirect to Seri A Advisory (Fase A02).


## 1. Execution cycle (Steps 0.5–5)

```text
INPUT: SCOPE_STATEMENT.md + valid SOW (or M03 waived for Solo SaaS)

0.5  INSPIRATION INTAKE -- first, blocking, every scale
     Human places >=1 reference in docs/design/inspiration/ (screenshots, brand board, clip, links.md).
     Static screenshots only -> the human must state the intended dynamic effects in this turn.
     STOP 0.5: no human-supplied file in that folder -> END TURN and ask. Do not create
       LOGO_DESIGN_BRIEF, assets/logo, SITEMAP, COMPONENT_REQUIREMENTS or DESIGN.md before it exists.
     Then extract from 2-5 references: colour temperature + hex, grid zones and density, component
       anatomy, type pairing and hierarchy. Live URLs -> inspect computed CSS; never guess a hex.
     Provenance goes in DESIGN.md 0: OK observed or INFERRED; a CAPTCHA/paywall page is recorded as a
       limitation, never bypassed. Output: inspiration/notes.md + exactly one primary benchmark.
     UI is code, not pictures: only photography, 3D art and brand marks may live in asset files.
0A   LOGO_DESIGN_BRIEF.md (<=2KB) + SVG set in docs/design/brand/: logo.svg, favicon.svg (or
     logo-icon.svg), logo-horizontal.svg, logo-dark.svg. Type as outlines, no raster <image>, no
     <foreignObject>, explicit viewBox. Verify with scripts/design/svg_audit.py on the primary logo.
0B   SITEMAP.md -- one dedicated section per role, never a single ambiguous table:
     Public SCR-PUB-NN / User SCR-USR-NN / Staff SCR-STF-NN / Admin SCR-ADM-NN.
     Per route: URL, screen name, purpose, layout shell, priority, breadcrumbs, RBAC guard/redirect.
0C   COMPONENT_REQUIREMENTS.md -- 3-tier inventory (primitives / composites / domain) at WCAG 2.2 AA:
     custom popover menu instead of a raw native select; FormField inline error >=13px and >=4.5:1 with
     focus on first invalid field (submit is never disabled while pristine); SubmitButton with debounce
     + spinner so a double click cannot post twice; CurrencyInput uses inputmode="numeric"; tables
     reflow into stacked cards under 640px; modal z-50, popover z-55 so it clears the modal, toast z-60
     with error/offline toasts that stay until dismissed; search + filter pills toolbar; EmptyState
     with an actionable CTA.
1    DESIGN.md at docs/harness-root/ -- provenance log, full type scale (display to caption, 16px
     mobile inputs, tabular-nums for money and counters), semantic triad tokens (success/warning/
     destructive/info), 4px spacing scale, radius scale, z-index map (base 0 ... toast 60), one icon set.
1.5  COMPONENT SHOWCASE FIRST -- docs/design/components/index.html on the shared CSS/JS, rendering
     every primitive and composite. STOP & ACC: the human approves it before any screen assembly.
2    Prototype screens in docs/design/screens/<role>/ (public, user, staff, admin) linking
     docs/design/shared/css/styles.css and shared/js/app.js. No #role-switcher. 100% of SITEMAP screens.
     Visual DNA (mandatory): real CSS Grid timelines, never flat full-width rows; segmented indicators
     stay segmented; hex taken from the benchmark, never neon or default orange; at most one primary
     action per card; real media with correct aspect ratio and ring border, never text-only card slop;
     one SVG icon set with consistent stroke and size, never emoji; circular avatars with counter
     badges and realistic placeholders; hover/active/focus/pending feedback plus reduced-motion;
     dialogs and in-page notices instead of alert/confirm/prompt; no SCR-/REQ-/M06-/FSD- codes in copy.
     Every screen links the shared stylesheet and script; no per-page inline <style> drift.
2.5  Wireflow runbooks docs/specs/wireflows/SCENARIOS_WFxx.md per wireflow screen: baseline fixture
     with seed credentials and RBAC scopes, happy path, sad path and edge cases, UI feedback behaviour.
3    DESIGN_SPEC.md per screen: 5-state matrix (default, loading, empty with CTA, error with retry,
     success) in real copy; destructive actions require typed confirmation and an audit reason;
     scroll-padding-bottom >=96px keeps focused inputs above the mobile keyboard.
4    python3 scripts/design/uiux_audit.py docs/design/screens/ --fix (Windows uiux-audit.ps1 -Fix):
     component uniformity, motion discipline, zero emoji, cross-screen parity, auto-fix of shared
     stylesheet and viewport links. Optional: one browser pass per P0 flow at mobile and desktop width
     with a clean console; never add a browser dependency just for this.
5    Walkthrough + Design Freeze: side-by-side against the reference, five Visual Review dimensions
     scored 0-2 in DESIGN_SPEC.md, human opens the prototype and signs. No M05/M06 before sign-off.
     Conversion flows (landing, signup, paywall) also review offer clarity, friction, trust and
     hesitation -- evidence-based, never manipulative; skip when conversion is not the outcome.

OUTPUT: 6 artifacts + component showcase + prototype screens + wireflow runbooks -> Module 05
```

**Full-detail cycle** (the same steps with every original clause) lives in
[`deep-dives/04_UIUX_PROTOTYPING.md`](deep-dives/04_UIUX_PROTOTYPING.md) — open it only when a step
above is ambiguous.

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

## 3. Gate Exit Criteria [GATE] — BLOCKING

**Pre-conditions (Step 0.5, every scale)**
- [ ] `docs/design/inspiration/` holds ≥1 **human-supplied** file (not `notes.md`/`README.md`/`NOTES_TEMPLATE.md`/dotfile), and `notes.md` cites a filename that exists there (≥200B, with the selected benchmark, logo hex extraction and palette decisions).
- [ ] `assets/logo/` holds production vector SVGs (`logo.svg`, `favicon.svg` or `logo-icon.svg`, `logo-horizontal.svg`, `logo-dark.svg`) ≥50B Small-LITE / ≥200B Medium+, referenced by `DESIGN.md`.
- [ ] `scripts/design/svg_audit.py <primary logo>` reports **zero FAIL** (`<text>`, raster `<image>`, `<foreignObject>`, missing `viewBox`). WARN/INFO are advisory: fix or state why deliberate. A `.svg` that does not parse is a rejected placeholder.

**Mandatory files**
- [ ] `docs/specs/COMPONENT_REQUIREMENTS.md` ≥1000B (3-tier inventory + WCAG).
- [ ] `docs/specs/LOGO_DESIGN_BRIEF.md` ≥500B and ≤2KB.
- [ ] `docs/specs/SITEMAP.md` ≥1000B Small / ≥2000B Medium+ (dedicated per-role RBAC sections).
- [ ] `docs/harness-root/DESIGN.md` staged ≥1000B (type scale, semantic triad, z-index, spacing).
- [ ] `docs/specs/DESIGN_SPEC.md` ≥1000B Small / ≥2000B Medium+ (per-screen 5-state + motion + destructive confirm).
- [ ] Component showcase `docs/design/components/index.html` created **and** ACC'd before screen assembly.
- [ ] `docs/specs/wireflows/` covers happy path, validation and domain-exception runbooks per wireflow screen.
- [ ] `docs/design/screens/<role>/` covers 100% of SITEMAP routes, per role, no runtime switcher; screen count == DESIGN_SPEC wireflow screens.

**Computed, not self-approved**
- [ ] WCAG contrast on DESIGN.md tokens, light and dark: primary text ≥7.0:1; secondary, placeholder and status ≥4.5:1; input borders ≥3:1.
- [ ] Non-colour state indicators; 16px mobile inputs; ≥44px touch targets; defined z-index layers; reduced-motion support; visible keyboard focus; no `will-change` outside active animation.
- [ ] `focus-visible:ring-2` on every interactive element (zero unstyled `outline: none`); data tables reflow to stacked cards under 640px.
- [ ] Every mutating form button declares a pending state (`disabled={isSubmitting}` + spinner + text transition) with UI debounce.
- [ ] Screens link `docs/design/shared/css/styles.css` and `shared/js/app.js`; zero inline `<style>` duplicates or drifting buttons, badges, navbars, typography.

**Design Freeze (blocking, recorded in `DESIGN_SPEC.md`)**
- [ ] Approver name (Client PIC, or the human user on solo work) + date `YYYY-MM-DD` + "Approved via [channel]". The AI agent is never a valid approver.

Optional (client projects): ≥2 usability iterations × 5+ users, SUS ≥70; prototype URL or Figma link.

## 4. Gate Invocation & Continue Rules

**MANDATORY**: execute the validator, paste its EXACT terminal output (no hardcoded checklists). If it exits `❌ Gate validation FAILED`, fix artifacts and re-run — do NOT declare completion.
```
./scripts/gates/validate-gate.sh M04
```
(Windows: `./scripts/gates/validate-gate.ps1 M04`)

Only after `✅ Gate validation PASSED` (exit 0), present the handoff summary. M04 is not a SKILL.md stop point: for Small/Solo SaaS continue to M05 in the same flow; pause for explicit approval on Client projects ("Design approved" / "Proceed to Module 05"). If the user requests changes: regenerate affected files and re-run the gate. On approval, carry DESIGN.md + DESIGN_SPEC.md forward as references for Module 05 (Architecture & FSD).

> **AUTHORITATIVE WORKFLOW OVERRIDE**
