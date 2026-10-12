# COMPONENT_REQUIREMENTS.md — Small Path (LITE)

> Target: ≥1000B. Lean inventory: primitives + composites only. No component library spec.

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

## Rules (enforced)

- States per interactive component: default, hover, focus, disabled, loading.
- Monetary inputs: `inputmode="numeric"` + live thousand separators (never `<input type="number">`).
- Icons: one family only; no emoji as UI icons.
- No gradients, no glassmorphism, shadows ≤4px.
