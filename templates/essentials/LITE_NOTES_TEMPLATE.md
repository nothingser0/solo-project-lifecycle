# Design Reference Notes — Small Path (LITE)

> M04-LITE rule: **exactly 1 benchmark** (not 3-5). ≥200B. Full template for Medium+: `templates/02-design/references/inspiration-template/NOTES_TEMPLATE.md`
>
> ⛔ **Precondition (not sizeable down)**: the human places ≥1 reference in `docs/design/inspiration/`
> (screenshot, brand board, or `links.md` of URLs). This file is the agent's analysis — never the
> reference itself. Until a human file exists: STOP AND ASK, and produce no logo, SITEMAP,
> components, or `DESIGN.md`.

## Selected Benchmark ("paling OK")

- **Reference file**: [EXACT filename the human placed, e.g. `reference-1-dashboard.png` or `links.md` — must exist in `docs/design/inspiration/`]
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

## Component Signature (Mirror from Reference — No AI Generic Defaults)

*Capture the physical styling signature of the benchmark so implementation does not drift to generic AI slop:*

- **Primary Button**: height [x]px, padding [x]px [y]px, font-weight [500/600], radius [x]px, border [none / 1px solid #hex], shadow [none / subtle]
- **Secondary Button / Ghost**: background [#hex / transparent], border [1px solid #hex], text color [#hex]
- **Cards / Containers**: padding [x]px, radius [x]px, border [1px solid #hex], background [#hex], shadow [none / 0 1px 2px]
- **Input Fields**: height [x]px, padding-x [x]px, font-size 16px (iOS zoom safety), border [1px solid #hex], focus ring color [#hex]
- **Table / List Row**: height [x]px, divider border [1px solid #hex], hover background [#hex]

## Logo alignment

- **Logo core hex**: `#______` (from `docs/specs/LOGO_DESIGN_BRIEF.md` or `assets/logo/`)
- **Harmonization**: inherit benchmark layout; adjust accent to match logo hue.

## Anti-patterns (from benchmark comparison)

- **Zero Generic AI Slop**: No default Tailwind blue (`#3B82F6` / `blue-500`), no purple-to-blue gradient text, no fuzzy glassmorphism/backdrop-blur.
- **No Floating Unstyled Modals**: Modals/drawers must have crisp border and dark backdrop overlay (`rgba(0,0,0,0.5)`).
- **No Generic AI Copywriting**: Replace placeholder clichés ("Unlock powerful possibilities", "Next-gen experience") with real, concise action verbs and domain labels.
- **Strict Ergonomics**: Shadows ≤4px, contrast ≥4.5:1 (normal text) and ≥7.0:1 (primary text), touch target minimum 44px × 44px.
