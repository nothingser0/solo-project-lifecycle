# UI Motion & Micro-Interaction Guidelines

> **Module**: M04 (UI/UX Design & Prototyping) & M06 (Development Execution)  
> **Source**: Adapted from Disney animation principles for digital UI (`LottieFiles`), `ibelick/ui-skills`, and `Jakubantalik/transitions.dev` (motion-token scale and usage-matching doctrine; values free to use, library not redistributable).  
> **Objective**: Eliminate sluggish, distracting, or jittery animations; enforce physics-based, performant, and accessible motion across interfaces.

---

## 1. The 3 UI Motion Tiers (Duration Scales)

Animations must feel instantaneous and purposeful, never delaying user workflows:

| Tier | Duration Window | Use Cases | Easing Curve |
| :--- | :---: | :--- | :--- |
| **Tier 1: Micro-Interactions** | **100ms – 150ms** | Button active/tap scale, checkbox checks, icon toggle swaps, radio selections. | `ease-out` or `cubic-bezier(0.16, 1, 0.3, 1)` |
| **Tier 2: Interface Transitions** | **200ms – 250ms** | Dropdown menus, modal dialog pop-in/scale, tooltip reveals, accordion expand. | `cubic-bezier(0.16, 1, 0.3, 1)` (Fluid Out) |
| **Tier 3: Complex Choreography** | **300ms – 400ms** | Full-page slide transitions, sheet draw-ins, staggered list/grid card entrances. | `cubic-bezier(0.2, 0.8, 0.2, 1)` (Smooth Decel) |

*Rule of Thumb: for **functional** motion (the user is waiting to act) 400ms is the ceiling. Expressive one-off moments may reach 500ms — see §9 for the distinction.*

---

## 2. Hardware Performance Rules (GPU Acceleration Only)

### The Permitted Properties (Zero Layout Re-flow)
Animate **ONLY** properties handled directly by the GPU compositor thread:
* ✅ `transform: translate3d(...)` / `translateX` / `translateY`
* ✅ `transform: scale(...)`
* ✅ `transform: rotate(...)`
* ✅ `opacity`

### The Banned Animated Properties
❌ **STRICTLY PROHIBITED**: Animating properties that trigger browser Layout or Paint recalculations on every frame:
* Never animate: `width`, `height`, `top`, `left`, `bottom`, `right`, `margin`, `padding`, or `border-width`.
* If a container needs to expand (e.g. accordion/modal), use CSS Grid transition (`grid-template-rows: 0fr -> 1fr`) or transform scaling with an inner inverse-transform.

---

## 3. Staggered Choreography Guidelines

When revealing lists, table rows, or dashboard statistic cards:
* **Stagger Increment**: Apply a delay of **`25ms – 35ms`** per child element.
* **Maximum Stagger Cap**: Stop staggering after **6 items** (maximum total delay: ~200ms). Items 7 and beyond must enter simultaneously with item 6. Never make a user watch 50 rows cascade down one by one. The **total** is the real constraint — see §8.3.

---

## 4. The 100th-Viewing & Distraction Defenses

Adapted from LottieFiles production motion diagnostic rules:

1. **The 100th-Viewing Test**:
   - Ask before freezing any interactive animation: *"Will the user still appreciate this on their 100th interaction, or will it feel like an annoying delay?"*
   - If an animation feels like waiting on repeated daily usage (e.g. bouncy dialog pop-ups, lengthy button spinners), reduce duration to $\le 150\text{ms}$ or replace with instantaneous state change.
2. **The 1/3 Screen Rule**:
   - At any single moment, never animate more than **one-third (33%)** of the viewport surface area simultaneously.
   - If a page has 12 cards, do not bounce all 12 at once. Animate the primary container or stagger entrance to prevent cognitive overload.
3. **Zero Linear Spatial Motion**:
   - Never use `linear` timing on physical coordinate movement (`translate`, `scale`, `rotate`). Linear spatial motion looks robotic and unnatural. Always use `ease-out` for entrances and `ease-in` for exits.

---

## 5. Platform Motion Scaling & Viewport Caps

Adapted from production context-adaptation motion scaling standards:

| Platform Viewport | Duration Modifier | Permitted Complexity | Mobile Constraints |
| :--- | :---: | :--- | :--- |
| **Desktop (≥ 1024px)** | `1.0x` (Baseline) | Full spatial translation & multi-element choreographies. | Hover states, cursor tracking, multi-column stagger. |
| **Tablet (768px – 1023px)** | `0.9x` | Standard transitions, reduce stagger count to 4. | Touch feedback < 100ms. |
| **Mobile (< 768px)** | `0.8x` (Snappy) | Minimal: Opacity + single transform axis only. | **Zero Mobile Parallax**: Parallax scrolling is strictly banned on mobile viewports. |

* **Mobile Max Displacement Rule**: Physical translation distance on screens under 600px must never exceed **20% of viewport width** (approx. 60px–80px) to prevent disorienting large-distance sweeps.

---

## 6. Mandatory Accessibility Gate (`prefers-reduced-motion`)

To prevent motion sickness and vestibular disorders, every CSS transition and animation block MUST honor system accessibility preferences:

```css
/* Global Reset for Reduced Motion */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```
In React / Framer Motion / Tailwind:
```tsx
// Respect reduced motion in motion components
<motion.div
  initial={{ opacity: 0, y: shouldReduceMotion ? 0 : 8 }}
  animate={{ opacity: 1, y: 0 }}
  transition={{ duration: shouldReduceMotion ? 0 : 0.2 }}
/>
```

---

## 7. The Motion Token Scale (and why "match usage, not numbers")

A single motion scale beats per-component magic numbers: one place to tune, one vocabulary to reason about. The rule that makes it work is **match on usage, never on the nearest number**.

> A value is not wrong because it is 20 ms off. It is wrong when it does not fit **what the motion does**.

A `300ms` modal close maps to the *quick* token (150 ms) because both mean "modal close", even though the numbers differ. If a value's usage matches no token's usage, **leave it alone** — never force a swap because a number is close.

### 7.1 Durations

| Token | Value | Usage |
| :--- | ---: | :--- |
| `--duration-stagger` | 40 ms | per-item stagger offset |
| `--duration-micro` | 80 ms | tooltip/path delay, shake segment, large stagger |
| `--duration-quick` | 150 ms | modal/dropdown **close**, text swap, tooltip appear |
| `--duration-fast` | 250 ms | icon swap, dropdown/modal **open**, tabs sliding, page slide |
| `--duration-medium` | 350 ms | panel close, toast close |
| `--duration-slow` | 400 ms | panel open, skeleton content reveal, input clear |
| `--duration-very-slow` | 500 ms | emphasis moments: badge appear, text reveal, success check |

### 7.2 Easings

| Token | Value | Usage |
| :--- | :--- | :--- |
| `--ease-smooth-out` | `cubic-bezier(0.22, 1, 0.36, 1)` | open/close of modal, dropdown, panel; page slide; resize; position change — **the default** |
| `--ease-in-out` | `ease-in-out` | icon swap, text swap, text reveal, skeleton reveal |
| `--ease-out` | `ease-out` | tooltip open / close |
| `--ease-linear` | `linear` | shimmer, skeleton pulse, spinner — **only** these |
| `--ease-bounce` | `cubic-bezier(0.34, 1.36, 0.64, 1)` | badge pop open |
| `--ease-bounce-strong` | `cubic-bezier(0.34, 3.85, 0.64, 1)` | bouncy hover-**out** (avatar return) |

Overshoot curves belong to **entrances only**. Never bounce a close.

### 7.3 Distances, scales, blur

| Token | Value | Usage |
| :--- | ---: | :--- |
| `--distance-micro` | 4 px | text swap |
| `--distance-small` | 6 px | error shake (small segment) |
| `--distance-base` | 8 px | badge reveal, page slide, shake (large segment) |
| `--distance-medium` | 12 px | text reveal |
| `--distance-large` | 30 px | check badge appear |
| `--scale-large` | 0.96 | modal open / close |
| `--scale-medium` | 0.97 | dropdown open |
| `--scale-small` | 0.98 | tooltip open |
| `--scale-tiny` | 0.99 | dropdown close |
| `--blur-small` | 2 px | panel reveal, icon swap, text swap, skeleton reveal, number pop-in |
| `--blur-medium` | 3 px | page slide, text reveal |
| `--blur-large` | 8 px | success check open |

**Scale and blur are the *pre* values** — they always settle to `1` / `0`. A pre-scale below ~0.9 reads as a "zoom" and rarely fits UI chrome. Distance scales **down** with frequency and **up** with ceremony: an in-place text swap barely moves (4 px), a page slide travels a readable 8 px, a one-off celebratory badge can sweep 30 px. Anything over ~40 px that is not a full drawer usually reads as sluggish.

Blur softens a *swap or slide*; it is wrong on a plain fade or a colour/theme change. It can also be **missing**: a page slide with no blur lane should probably gain `--blur-medium`.

**Asset**: `templates/ui/motion-tokens.css` — the scale as a ready `:root` block.

---

## 8. Timing Rules That Numbers Alone Cannot Express

A value can be on-scale and still wrong, because **when** it happens matters as much as how long it takes.

### 8.1 Open/close asymmetry

Opening is an invitation; closing should get out of the way. **Closes are faster and quieter than opens.**

| Surface | Open | Close |
| :--- | ---: | ---: |
| Dropdown / modal | 250 ms (`--duration-fast`) | 150 ms (`--duration-quick`) |
| Panel | 400 ms (`--duration-slow`) | 350 ms (`--duration-medium`) |
| Toast | — | 350 ms (`--duration-medium`) |

**Symmetric exceptions — same duration and easing both ways; do NOT split:** page side-by-side (250 ms), tabs sliding (250 ms), accordion (250 ms), icon swap (250 ms), text swap (150 ms). These read as one reversible motion, not an open/close pair.

The **enter** phase carries the distance and blur; the exit may drop or shrink them, so a close does not fling content across the screen.

### 8.2 Hover in vs hover out

- **In:** quick and direct — `--duration-fast` or less, `--ease-smooth-out`.
- **Out:** softer and springier — the return may take longer and use `--ease-bounce-strong`, so a row settles instead of snapping.

This is the one place where the *out* is deliberately more elaborate than the *in*.

### 8.3 Stagger totals, not just offsets

- Offset: `--duration-stagger` (40 ms) per item; step up to `--duration-micro` (80 ms) for a few large items.
- **Cap the total**: offset × item count should stay under **~300 ms**, or the last item feels late. For long lists, cap the number of staggered items or shrink the offset.
- Our earlier rule (25–35 ms, max 6 items, ≈200 ms total) is the conservative end of the same principle. Both are valid; **the total is the constraint, not the per-item number.**

### 8.4 Delay discipline

- A delay is for **filtering accidental triggers** (a tooltip waits 80 ms so a passing cursor does not fire it) or **sequencing** two things (a path draw after a fade).
- **Never delay a close or a hover-out.** Dismissal must feel instant.
- If motion feels late, **trim the duration, not add a delay.** Delay does not make an animation feel faster.

---

## 9. Reconciling the duration ceiling

An earlier rule in this guide says *"if an animation takes longer than 400 ms, it is wasting the user's time."* That is **correct for interface motion and wrong as a universal law**. Resolve it by intent:

| Intent | Ceiling | Examples |
| :--- | :--- | :--- |
| **Functional** — the user is waiting to act | **≤ 400 ms** | dropdown, modal, panel, page slide, tabs, tooltip, icon/text swap |
| **Expressive** — a moment the user is meant to notice, once | **≤ 500 ms**, and only for a *single* element | success check, badge pop, celebratory number, first-paint text reveal |

A 500 ms **modal open** is a defect. A 500 ms **success check** is the point of the success check. The distinguishing test: *is the user waiting to do something, or is the interface telling them something happened?* If they are waiting, 400 ms is the ceiling and 250 ms is usually better.

Repeated-daily interactions should sit at the low end regardless of intent — see the 100th-viewing test in §4.

---
