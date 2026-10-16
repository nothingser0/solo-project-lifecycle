# Logo Design Craft & Verification Guide

> **Module**: M04 (UI/UX Design & Prototyping)  
> **Source**: Adapted from professional SVG logo principles and testing methodologies.  
> **Objective**: Ensure that brand marks and logos are disciplined, scalable, non-generic, and technically flawless before freezing design.

---

## 1. The 4 Logo Verification Tests (The Disciplinary Filter)

Before finalizing any logo in `assets/logo/` or locking `DESIGN.md`, the logo MUST pass these 4 stress tests:

### Test 1: The 16px Favicon / Squint Test
* **Requirement**: The core mark must remain instantly recognizable when scaled down to a **16×16 px** browser favicon or 32×32 px mobile status bar icon.
* **Failure Mode**: Tiny delicate lines, excessive interior details, or micro-text that turn into blurry, unreadable mud at small resolutions.
* **Correction**: Simplify geometry, thicken line weights, or design a dedicated high-contrast `logo-icon.svg` specifically for small viewports.

### Test 2: The One-Colour / Monochrome Test
* **Requirement**: Convert the logo to 100% solid black (`#000000`) on white, and 1 solid white (`#FFFFFF`) on black.
* **Failure Mode**: The logo relies on gradients, multiple overlapping pastel colors, or shadows to define its shape. When printed on a monochrome invoice or thermal receipt, it becomes an unrecognizable blob.
* **Correction**: Rely on pure positive/negative space and silhouette geometry. If the mark doesn't work in pure black-and-white, the foundation is broken.

### Test 3: The 3:1 Contrast Shelf Test
* **Requirement**: The logo mark must maintain at least a **3:1 contrast ratio** against both light mode backgrounds (`#FFFFFF` / `#F8FAFC`) and dark mode surfaces (`#090D16` / `#000000`).
* **Correction**: Provide two distinct SVG variants: `logo-light.svg` (for light backgrounds) and `logo-dark.svg` (for dark backgrounds).

### Test 4: The Anti-Slop Category Ban (No Generic Clichés)
AI and inexperienced designers default to the same tired visual tropes. The following category clichés are **STRICTLY FORBIDDEN**:

| Industry Sector | Forbidden AI Clichés (Banned) | Disciplined Professional Direction |
| :--- | :--- | :--- |
| **Fintech / Finance** | Piggy banks, gold coins, generic shield, bank blue `#0047AB`. | Strict geometric typography, architectural grids, modern editorial contrast. |
| **SaaS / DevTools** | Chat bubbles, padlocks, ascending chart arrows, gear icons. | Monograms, abstract letterforms, dynamic angles, high-contrast monospace balance. |
| **Healthcare / Med** | EKG heartbeat lines, medical crosses, pill capsules, leafy hands. | Organic curved silhouettes, calming asymmetrical forms, warm human geometry. |
| **Logistics / Delivery**| Wings, flying paper airplanes, generic cardboard boxes. | Motion lines, kinetic bold letterforms, spatial road/route abstractions. |

---

## 2. Standard Asset Delivery Package (`assets/logo/`)

A production-ready logo delivery must provide the following files:

```
assets/logo/
├── logo.svg                 # Primary full lockup (Icon + Wordmark)
├── logo-icon.svg            # Standalone 1:1 square mark (for App Icon, Avatar, Favicon)
├── logo-monochrome.svg      # Pure black/white vector silhouette
├── favicon.ico              # Multi-resolution ICO (16x16, 32x32, 48x48)
├── icon-192.png             # Android PWA home screen icon
└── icon-512.png             # Android PWA splash screen & Apple touch fallback
```

---

## 3. SVG Technical Craft & Optical Rules

1. **Optical Centering over Geometric Centering**:
   - Asymmetrical marks, triangles, play buttons, and curved letterforms (e.g. "P", "D", "3") have an uneven visual weight. Centering purely by mathematical bounding box makes them look off-center to the human eye.
   - Adjust coordinates optically so the center of visual mass aligns with the icon container.
2. **Overshoot Compensation**:
   - Curves and sharp apexes appear smaller than flat baselines of identical mathematical height. Circles and curved elements must extend 1–2% beyond the baseline/cap height (overshoot) to look identical in scale.
3. **Anchor Point Budget (Complexity Cap)**:
   - A production vector mark should have **fewer than 150 anchor points**.
   - Marks exceeding 300 anchor points indicate bloated autotracing or messy bezier handles that slow down DOM rendering and blur at 16px. Every anchor point must earn its place.
4. **Zero Near-Miss Angles**:
   - Avoid unintentional accidental slopes (e.g. 89.4° or 179.2°). Structural lines intended to be vertical or horizontal must snap strictly to 90.0° and 180.0°.
5. **Clean ViewBox**: Always use a clean square or proportional `viewBox` (e.g. `viewBox="0 0 100 100"` or `viewBox="0 0 240 60"`), never hardcoded px bounds without viewBox.
6. **Path Outlines**: Convert all live text fonts to vector `<path>` outlines so the SVG renders identically on devices without the local font installed.
7. **Zero Embedded Base64**: Never embed raster images (`<image href="data:image/png...">`) inside an SVG logo file.
8. **Vector Size Cap**: A production logo icon should be lightweight, clean, and under 50KB in total payload size.
