# Module 04-LITE: UI/UX for Small (Fast-Track)

> Template source: `templates/02-design/DESIGN_MD_TEMPLATE.md` · Full runbook (Medium+): [`04_UIUX_PROTOTYPING.md`](../04_UIUX_PROTOTYPING.md)

**Purpose**: proportional design pass for the Small path. Produces the same 6 artifact names as full M04, sized down — never skipped.

## Step 0.5 — Inspiration Intake & Motion Directives (BLOCKING, not sizeable down)

The LITE path shrinks the artifacts; it never waives the input. **Before any artifact below exists** (logo, SITEMAP, components, DESIGN.md), the **human** must place at least one reference in `docs/design/inspiration/` — a screenshot, a brand board, short video clip, or a `links.md` listing reference URLs (Linear, Vercel, TailwindUI, Stripe or any product the human actually likes).

- **Dynamic effects rule**: When providing static screenshots without live URLs, the human states the desired dynamic effects directly (e.g. parallax scroll, 3D canvas, video background, stagger text reveal, hover interactions) so the AI captures the intended feel.
- ⛔ **STOP 0.5**: folder empty → END TURN and ask. Do not emit a placeholder logo, SITEMAP, component list, or `DESIGN.md` "while waiting".
- `notes.md` is the agent's analysis, **never** the reference. A benchmark that cites no existing file is fabrication.
- Gate-enforced: `validate-gate.sh M04` (and `M06`, for projects that started before this rule) fails until a human-supplied file exists and `notes.md` cites it by filename.

## Step 1.5 — Interactive Prototype & Polish Motion Specs (Code Prototype Standard)

Visual preview and interaction polish are mandatory to eliminate AI slop. Author interactive HTML/code prototype screens directly into `docs/design/screens/` (supporting state toggles: Default, Loading, Empty, Error, Success). Include rich interactive polish: micro-interactions, hover states, smooth transitions, and optional 3D/canvas/parallax embed slots (e.g. Spline, Three.js, Framer Motion) so the human can test actual user flows and delight directly in a browser before Design Freeze. External design tool handoffs are eliminated; interactive code prototyping is the single permanent standard.

## Artifacts (all required, 1 page or less each)

1. `docs/specs/LOGO_DESIGN_BRIEF.md` — name, vibe, seed colors, chosen mark archetype + word map. **Logo placeholder rule**: initials SVG at `assets/logo/logo.svg` is acceptable (monogram 1–2 letters, brand accent, ≥50B) — but it must still pass the mechanical audit: `python3 scripts/design/svg_audit.py assets/logo/logo.svg` with **zero FAIL** (no live `<text>`, no raster, no `<foreignObject>`, has a `viewBox`). Small scale does not waive vector hygiene; see `references/design/LOGO_DESIGN_CRAFT_GUIDE.md` §6.
2. `docs/specs/SITEMAP.md` — screen inventory + navigation (≥1000B), diturunkan langsung dari P0/P1 Features & Roles di `SCOPE_STATEMENT.md`.
3. `docs/specs/COMPONENT_REQUIREMENTS.md` — lean inventory, primitives + composites only (≥1000B).
4. `assets/media/` (optional) — dedicated directory for custom illustrations, Lottie animations, Spline/3D models (.splinecode, .glb), or reference media.
5. `docs/design/inspiration/notes.md` — **exactly 1 benchmark** (e.g., Linear, Vercel, TailwindUI, Stripe) with reason + palette hexes (≥200B), citing the human's reference file from Step 0.5 by name.
6. `docs/harness-root/DESIGN.md` — tokens: palette (computed WCAG ratios), typography, spacing, z-index scale (≥1000B).
7. `docs/specs/DESIGN_SPEC.md` — **5-state matrix (Default, Loading, Empty, Error, Success) on primary screens only** (1–3 main data screens); secondary screens need Default state only. The **human user** signs the Design Freeze line (self-approval + date) — an AI agent may never sign or self-approve it.

## Anti-slop minimums (unchanged, computed not self-approved)

- Contrast: primary text ≥7:1; secondary/status/placeholder ≥4.5:1; input borders ≥3:1.
- Zero emoticons/emojis (jangan pernah gunakan emoticon, gunakan icons), zero glassmorphism, shadows ≤4px, non-color state indicators, ≥44px touch targets, zero default Tailwind blue (`#3B82F6`).
- **Keyboard & Mobile Reflow**: High-contrast `focus-visible:ring-2` on all interactive controls (never `outline: none`); data tables on viewports `<640px` reflow into stacked key-value cards (never unconstrained horizontal scroll hiding action buttons).
- Component signature match: Primary buttons, cards, and input fields must mirror exact radius, height, and border styling extracted from benchmark in `notes.md` (no generic AI defaults).
- **Reusable Prototype Architecture**: All screens in `docs/design/screens/` must link to shared `css/styles.css` (tokens, buttons, cards, badges, navbar) and `js/app.js` (nav, modals, toast) — no inline styles or divergent component styling across pages.
- **Mechanical UI/UX Consistency Audit**: Run `powershell -ExecutionPolicy Bypass -File scripts/design/uiux-audit.ps1 -Fix` (or `python3 scripts/design/uiux_audit.py docs/design/screens/ --fix`) to audit and auto-fix any button, card, badge, animation, or navigation drifts across screens.

## Gate

```
[PASTE RAW OUTPUT OF: ./scripts/gates/validate-gate.sh M04]
```

Run `./scripts/gates/validate-gate.sh M04` (or `.ps1`). Exit 1 = fix artifacts and re-run. Small-scale expectations apply: `SITEMAP.md`/`DESIGN_SPEC.md` ≥1000B (not 2000B), logo ≥50B, notes.md ≥200B with 1 benchmark. Step 0.5 (human reference) has **no** Small exemption. On pass, continue to M05 in the same flow (M04 is not a stop point; Small's first [STOP] is after M05).
