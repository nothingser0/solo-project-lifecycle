# Module 04-LITE: UI/UX for Small (Fast-Track)

> Template source: `templates/02-design/DESIGN_MD_TEMPLATE.md` · Full runbook (Medium+): [`04_UIUX_PROTOTYPING.md`](../04_UIUX_PROTOTYPING.md)

**Purpose**: proportional design pass for the Small path. Produces the same 6 artifact names as full M04, sized down — never skipped.

## Step 0.5 — Inspiration Intake (BLOCKING, not sizeable down)

The LITE path shrinks the artifacts; it never waives the input. **Before any artifact below exists** (logo, SITEMAP, components, DESIGN.md), the **human** must place at least one reference in `docs/design/inspiration/` — a screenshot, a brand board, or a `links.md` listing reference URLs (Linear, Vercel, TailwindUI, Stripe or any product the human actually likes).

- ⛔ **STOP 0.5**: folder empty → END TURN and ask. Do not emit a placeholder logo, SITEMAP, component list, or `DESIGN.md` "while waiting".
- `notes.md` is the agent's analysis, **never** the reference. A benchmark that cites no existing file is fabrication.
- Gate-enforced: `validate-gate.sh M04` (and `M06`, for projects that started before this rule) fails until a human-supplied file exists and `notes.md` cites it by filename.

## Artifacts (all required, 1 page or less each)

1. `docs/specs/LOGO_DESIGN_BRIEF.md` — name, vibe, seed colors. **Logo placeholder rule**: initials SVG at `assets/logo/logo.svg` is acceptable (monogram 1–2 letters, brand accent, ≥50B).
2. `docs/specs/SITEMAP.md` — screen inventory + navigation (≥1000B).
3. `docs/specs/COMPONENT_REQUIREMENTS.md` — lean inventory, primitives + composites only (≥1000B).
4. `docs/design/inspiration/notes.md` — **exactly 1 benchmark** (e.g., Linear, Vercel, TailwindUI, Stripe) with reason + palette hexes (≥200B), citing the human's reference file from Step 0.5 by name.
5. `docs/harness-root/DESIGN.md` — tokens: palette (computed WCAG ratios), typography, spacing, z-index scale (≥1000B).
6. `docs/specs/DESIGN_SPEC.md` — **5-state matrix (Default, Loading, Empty, Error, Success) on primary screens only** (1–3 main data screens); secondary screens need Default state only. The **human user** signs the Design Freeze line (self-approval + date) — an AI agent may never sign or self-approve it.

## Anti-slop minimums (unchanged, computed not self-approved)

- Contrast: primary text ≥7:1; secondary/status/placeholder ≥4.5:1; input borders ≥3:1.
- Zero gradients, zero glassmorphism, shadows ≤4px, non-color state indicators, ≥44px touch targets, zero default Tailwind blue (`#3B82F6`).
- Component signature match: Primary buttons, cards, and input fields must mirror exact radius, height, and border styling extracted from benchmark in `notes.md` (no generic AI defaults).

## Gate

```
[PASTE RAW OUTPUT OF: ./scripts/gates/validate-gate.sh M04]
```

Run `./scripts/gates/validate-gate.sh M04` (or `.ps1`). Exit 1 = fix artifacts and re-run. Small-scale expectations apply: `SITEMAP.md`/`DESIGN_SPEC.md` ≥1000B (not 2000B), logo ≥50B, notes.md ≥200B with 1 benchmark. Step 0.5 (human reference) has **no** Small exemption. On pass, continue to M05 in the same flow (M04 is not a stop point; Small's first [STOP] is after M05).
