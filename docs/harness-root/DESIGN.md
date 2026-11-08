# DESIGN.md — design tokens (copied from Module 04)

> **Source of truth**: `docs/design/DESIGN.md` written and frozen in Module 04. Copy the token
> tables here verbatim; do not invent values during implementation. Every colour, size and
> spacing used in `src/` must exist below.

## 1. Colour tokens
| Token | Value | Contrast on `--bg` | Provenance |
|---|---|---|---|
| `--bg` | [from docs/design/DESIGN.md] | — | observed from the winning benchmark |
| `--fg` | [..] | [e.g. 12.6:1] | |
| `--primary` | [..] | [>= 4.5:1 against --bg] | |

**Brand colours allowed** (third-party brand marks exempt from the token rule):
- [e.g. #003D79 payment provider mark]

## 2. Typography scale
| Token | Size / line-height | Weight | Use |
|---|---|---|---|
| `--text-xs` | 12 / 16 | 400 | meta, table captions |
| `--text-sm` | 14 / 20 | 400 | body, table cells |
| `--text-base` | 16 / 24 | 400 | default body |
| `--text-lg` | 18 / 28 | 600 | card titles |
| `--text-xl` | 20 / 28 | 600 | section headings |
| `--text-2xl` | 24 / 32 | 700 | page headings |

## 3. Spacing scale (4px base)
`--space-1` 4 · `--space-2` 8 · `--space-3` 12 · `--space-4` 16 · `--space-6` 24 · `--space-8` 32

## 4. Radius, elevation, z-index
| Token | Value | Use |
|---|---|---|
| `--radius-sm` | 6px | inputs, buttons |
| `--radius-md` | 10px | cards |
| `--z-dropdown` | 1000 | menus |
| `--z-modal` | 1400 | dialogs, nothing higher without a token |

## 5. Anti-Slop rules (gate-enforced)
No neon palette, no emoji as UI icons, no raw `<select>` or unstyled browser defaults, no
`alert()`/`confirm()`, no invented card layout. Port from `docs/design/screens/`.
