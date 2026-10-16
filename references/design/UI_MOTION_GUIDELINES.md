# UI Motion & Micro-Interaction Guidelines

> **Module**: M04 (UI/UX Design & Prototyping) & M06 (Development Execution)  
> **Source**: Adapted from Disney animation principles for digital UI (`LottieFiles`), `transitions.dev`, and `ibelick/ui-skills`.  
> **Objective**: Eliminate sluggish, distracting, or jittery animations; enforce physics-based, performant, and accessible motion across interfaces.

---

## 1. The 3 UI Motion Tiers (Duration Scales)

Animations must feel instantaneous and purposeful, never delaying user workflows:

| Tier | Duration Window | Use Cases | Easing Curve |
| :--- | :---: | :--- | :--- |
| **Tier 1: Micro-Interactions** | **100ms – 150ms** | Button active/tap scale, checkbox checks, icon toggle swaps, radio selections. | `ease-out` or `cubic-bezier(0.16, 1, 0.3, 1)` |
| **Tier 2: Interface Transitions** | **200ms – 250ms** | Dropdown menus, modal dialog pop-in/scale, tooltip reveals, accordion expand. | `cubic-bezier(0.16, 1, 0.3, 1)` (Fluid Out) |
| **Tier 3: Complex Choreography** | **300ms – 400ms** | Full-page slide transitions, sheet draw-ins, staggered list/grid card entrances. | `cubic-bezier(0.2, 0.8, 0.2, 1)` (Smooth Decel) |

*Rule of Thumb: If an animation takes longer than 400ms, it is actively wasting the user's time.*

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
* **Maximum Stagger Cap**: Stop staggering after **6 items** (maximum total delay: ~200ms). Items 7 and beyond must enter simultaneously with item 6. Never make a user watch 50 rows cascade down one by one.

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
