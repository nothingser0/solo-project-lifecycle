# COMPONENT_REQUIREMENTS.md — Small Path (LITE)

> Target: ≥1000B. Lean inventory: primitives + composites only. No component library spec.
> ⛔ Produce only AFTER Step 0.5: a human-supplied reference exists in `docs/design/inspiration/`.

## Primitives

| Component | Variants | Notes |
| :--- | :--- | :--- |
| Button | primary, secondary, destructive | ≥44px touch target |
| Input | text, numeric, password | 16px font (iOS zoom guard) |
| Select | — | native preferred |
| Badge / status | success, warning, destructive | non-color indicator required |

## Composites

| Component | Composed of | Used on |
| :--- | :--- | :--- |
| DataTable | table + pagination + empty state | SCR-00X |
| FormCard | inputs + submit + inline errors | SCR-00X |
| Toast | status badge + message + dismiss | global |

## Accessibility (WCAG 2.2 AA)

| Rule | Requirement |
| :--- | :--- |
| Text contrast | ≥ 4.5:1 body, ≥ 3:1 large text and UI borders |
| Touch targets | ≥ 44px on mobile, ≥ 36px on desktop |
| Focus | Every interactive element has a visible `:focus-visible` ring — never `outline: none` without a replacement |
| Inputs | ≥ 16px font size on mobile (below that, iOS zooms on focus) |
| Labels | Every input has a `<label>`; placeholder text is never the only label |
| Semantics | Real `<button>`/`<a>` elements — a clickable `<div>` is not a control |
| Motion | Respect `prefers-reduced-motion` |
| Images | Meaningful images have `alt`; decorative ones use `alt=""` |

## Rules (enforced)

- States per interactive component: default, hover, focus, disabled, loading.
- Monetary inputs: `inputmode="numeric"` + live thousand separators (never `<input type="number">`).
- Icons: one family only; no emoji as UI icons.
- No gradients, no glassmorphism, shadows ≤4px.
