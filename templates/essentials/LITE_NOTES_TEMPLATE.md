# Design Reference Notes — Small Path (LITE)

> M04-LITE rule: **exactly 1 benchmark** (not 3-5). ≥200B. Full template for Medium+: `templates/02-design/references/inspiration-template/NOTES_TEMPLATE.md`

## Selected Benchmark ("paling OK")

- **Benchmark**: [e.g., Linear, Vercel, Stripe, TailwindUI]
- **Why this one**: [1-2 sentences: clarity, data density, fit for target user]
- **Source**: [URL or app name]

## Extracted palette

- **Primary**: `#______`
- **Accent**: `#______`
- **Neutrals**: bg `#______` / surface `#______` / border `#______` / muted text `#______` / text `#______`
- **Semantic**: success `#______` / error `#______` / warning `#______`

## Extracted rules (keep it short)

- **Typography**: [font family], body [size]px, headings [sizes]
- **Spacing base**: [4px / 8px] grid
- **Radius**: buttons [x]px, cards [x]px
- **Shadows**: [none / subtle 0 1px 2px ...]
- **Layout**: max width [x]px, [sidebar/topbar] nav

## Logo alignment

- **Logo core hex**: `#______` (from `docs/specs/LOGO_DESIGN_BRIEF.md` or `assets/logo/`)
- **Harmonization**: inherit benchmark layout; adjust accent to match logo hue.

## Anti-patterns (from benchmark comparison)

- No gradients, no glassmorphism, shadows ≤4px, contrast ≥4.5:1 for all text.
