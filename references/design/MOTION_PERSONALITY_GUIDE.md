# Motion Personality & Selection Guide

> **Module**: M04 (UI/UX) — decides *which* motion and *how it should feel*, before any effect is chosen
> **Source**: Adapted from `LottieFiles/motion-design-skill` (MIT) — the four personality archetypes, the emotion-to-motion map, the material physics table and the three-layer model. Values cross-checked against `references/design/UI_MOTION_GUIDELINES.md` (timing tokens) — where they disagree, the token scale wins.
> **Companion**: `patterns/ui/MOTION_DESIGN_TAXONOMY.md` is the *catalogue* (73 effects). This file is the *selection layer* — it tells you which one to reach for, and what it should feel like.

---

## 1. The decision order

Do not start from an effect. Start from the intent.

```
1. Does it serve a FUNCTION (feedback, guidance, state)?
      → timing rules for responsiveness (§4); keep it short and quiet
2. Does it express BRAND PERSONALITY?
      → pick one archetype (§2) and apply it consistently
3. Does it tell a STORY or direct attention?
      → Disney principles + choreography (§5)
4. Is it a COMPLEX multi-element scene?
      → the 1/3 rules + stagger budgets (§6)
```

Most UI motion is case 1. Most *bad* UI motion is case 1 treated as case 3.

---

## 2. Four archetypes — pick ONE per project

| Archetype | Duration | Easing | Overshoot | Use for |
| :--- | :--- | :--- | :--- | :--- |
| **Playful** | 150–300 ms | `ease-out-back`, bouncy springs | 10–20% | children's apps, casual games, social, celebrations, onboarding |
| **Premium** | 350–600 ms | `cubic-bezier(0.4, 0, 0.2, 1)` | 0% | fashion, finance, luxury, portfolios, editorial |
| **Corporate** | 200–400 ms | `cubic-bezier(0.2, 0, 0, 1)` | 0–3% | enterprise, dashboards, admin, healthcare, banking |
| **Energetic** | 100–250 ms | `ease-out-expo`, elastic | 15–30% | sports, gaming, fitness, bold consumer products |

**Defaults**: Corporate for UI, Playful for illustration.

**Signature traits**

- **Playful** — bounce settle, squash-stretch on press, rotation wobble, varied stagger. Paths are arcs, never straight.
- **Premium** — slow fades, subtle scale (98→100%), generous pauses, minimal properties (opacity + one). Never squash-stretch.
- **Corporate** — consistent timing, clear state transitions, predictable patterns, uniform stagger. Mostly straight paths, small arcs for emphasis.
- **Energetic** — fast, high overshoot, punchy accents. Use sparingly; it fatigues quickly on repeated interaction.

### 2.1 Brand motion identity — three constants

Define these once, in `DESIGN.md`, and reuse everywhere:

1. **Signature easing** — one curve for ~80% of animations.
2. **Duration palette** — three values only (quick / standard / slow).
3. **Entrance pattern** — one consistent entry style (from below, from the right, scale-up).

A project with four easings and nine durations has no motion identity, only accidents.

> **Cross-check**: the three-value duration palette maps onto the token scale in `UI_MOTION_GUIDELINES.md` §7 (`--duration-fast` / `--duration-medium` / `--duration-slow`). Use the tokens, not raw milliseconds.

---

## 3. Emotion → motion

When the brief gives you adjectives rather than behaviours, translate them.

| Emotion | Character | Path | Easing | Duration |
| :--- | :--- | :--- | :--- | :--- |
| **Joy** | bouncy, arcs | curved, upward | `ease-out-back` | 200–400 ms |
| **Calm** | smooth, flowing | gentle curves | sine ease-in-out | 500–1000 ms |
| **Urgency** | sharp, fast | straight lines | `ease-out` | 100–200 ms |
| **Sadness** | slow, downward | drooping curves | cubic ease-in-out | 600–1200 ms |
| **Surprise** | sudden, expanding | radial outward | `ease-out-expo` | 150–300 ms |
| **Elegance** | slow, controlled | long arcs | `(0.4, 0, 0.2, 1)` | 400–700 ms |
| **Playfulness** | bouncy, irregular | arcs, squiggly | `ease-out-back` | 200–350 ms |

**Path as language**: angular = tense · curved = friendly · spiral = whimsical · diagonal = purposeful · vertical = growth or weight · horizontal = progress.

> **Conflict rule**: Calm (500–1000 ms) and Sadness (600–1200 ms) exceed the functional ceiling in `UI_MOTION_GUIDELINES.md` §9. That is correct for **decorative or narrative** motion (an illustration, a hero animation) and wrong for **functional** UI motion. A modal never takes 800 ms because the brand is "calm".

---

## 4. Functional timing (the short end)

| Element | Duration |
| :--- | :--- |
| Tooltip / micro-feedback | 80–120 ms |
| Button press / toggle | 120–180 ms |
| Icon transition | 150–250 ms |
| Card enter / exit | 200–350 ms |
| Modal / dialog | 300–400 ms |
| Page transition | 400–600 ms |
| Dramatic reveal (decorative only) | 600–1200 ms |

**Distance scales duration**: 100 px is the base; 200 px → ×1.3; 400 px → ×1.6.

**Enter > exit**: entrances run 30–50% longer than exits. Users care about what appears, not what leaves.

**Interactive feedback**: hover < 100 ms · press < 150 ms · settle 200–300 ms · error shake 300–400 ms (2–3 oscillations).

---

## 5. Three layers (flat animation is missing layers)

Every non-trivial animation has three:

| Layer | What it is | Example |
| :--- | :--- | :--- |
| **Primary** | the action the viewer follows | the card sliding in |
| **Secondary** | supporting richness | its shadow arriving 50 ms later; the icon shifting 2 px |
| **Ambient** | background life | a slow gradient drift, a subtle pulse |

A card that only translates looks flat. A card whose shadow lags and whose content fades in 100 ms later looks designed.

**But**: ambient motion is the first thing to cut on mobile, under `prefers-reduced-motion`, and for repeated-daily interactions.

---

## 6. Choreography

- **Lead with the hero** — the primary element enters first or most prominently.
- **Spatial consistency** — all elements enter from the same direction.
- **Counter-motion** — if the hero moves right, ambient layers drift left at 20–30% speed.
- **1/3 rule (distance)** — no motion travels more than ⅓ of the screen without an intermediate keyframe.
- **1/3 rule (elements)** — with 3+ elements, no more than ⅓ are in active motion at once.

### Stagger budgets

| Pattern | Per-item delay | Total budget | Use for |
| :--- | ---: | ---: | :--- |
| Micro cascade | 20–40 ms | < 200 ms | list items, grid cells |
| Standard | 50–100 ms | < 400 ms | cards, panels, nav |
| Dramatic | 100–200 ms | < 600 ms | hero sections |
| Wave | 30–60 ms | < 500 ms | data visualisations |

**The total is the constraint.** 20 items × 40 ms = 800 ms, and the last item feels late. Cap the count or shrink the offset — see `UI_MOTION_GUIDELINES.md` §8.3.

---

## 7. Material physics

When the motion depicts a *material* (a sheet, a liquid, a heavy panel), borrow its physics rather than inventing a curve.

| Material | Duration scale | Overshoot | Reads as |
| :--- | ---: | ---: | :--- |
| Rigid (metal, stone) | ×1.2 | 0% | heavy, precise |
| Elastic (rubber, gel) | ×0.8 | 15–25% | springy, alive |
| Fluid (water, paint) | ×1.5 | 5% | smooth, continuous |
| Paper (cards, sheets) | ×1.0 | 3–5% | light, physical |
| Gas (smoke, fog) | ×2.0 | 0% | slow, diffuse |
| Glass (brittle) | ×0.9 | 0% | crisp, no give |

---

## 8. Weight classification

| Weight | Examples | Duration | Overshoot |
| :--- | :--- | :--- | :--- |
| **Heavy** | modals, overlays, drawers | 300–500 ms | 0% |
| **Medium** | cards, panels | 200–350 ms | 3–5% |
| **Light** | tooltips, badges, icons | 80–200 ms | 5–15% |

A tooltip that takes 400 ms feels broken. A modal that takes 120 ms feels cheap. Weight should match consequence.

---

## 9. The four rules that are never broken

1. **Never `linear` for spatial movement.** Linear is for spinners, progress bars, and shimmer — never for something travelling across the screen.
2. **Never opacity-only for an important state change.** Pair it with position or scale, or the change is invisible to a user who looked away.
3. **Never exceed ⅓ of the screen** without an intermediate keyframe.
4. **Keep the layers, but cut them honestly** — if you ship only a primary layer because the surface is a repeated-daily interaction, say so in the design spec. "Flat because we chose flat" is a decision; "flat because nobody thought about it" is the default.

---

## 10. Troubleshooting

| Symptom | Likely cause | Fix |
| :--- | :--- | :--- |
| Looks robotic | linear easing, or no arc | add an easing curve, curve the path |
| Feels too slow | duration too long for the element's weight | check §4 / §8, use `ease-out` |
| Feels cheap / flat | missing secondary + ambient | add shadow motion, background life |
| Too distracting | too many elements moving | apply the ⅓ rules, reduce amplitude |
| No personality | generic easing everywhere | commit to one archetype (§2) |
| Feels like a different product | personality applied inconsistently | re-read §2.1, pick one signature easing |
