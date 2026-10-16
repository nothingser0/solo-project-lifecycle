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

## 2. The 7 Mark Types Decision Framework

Before drawing or prompting any mark, select the exact mark archetype matching product strategy:

| Mark Type | Description | Best Suited For | Industry Examples |
| :--- | :--- | :--- | :--- |
| **1. Wordmark** | Distinct custom typographic treatment of the brand name alone. | Short, punchy, memorable names (<7 chars). | Stripe, Google, Braun, Vercel |
| **2. Letterform** | A singular, stylized first letter mark (monogram). | Digital products, mobile apps, crowded favicons. | Netflix (N), Airbnb (A), Notion (N) |
| **3. Combination** | Dedicated symbol paired horizontally or vertically with a wordmark. | Standard B2B SaaS, developer tools, new startups. | Slack, Supabase, Linear, Linear |
| **4. Pictorial** | Simplified, recognizable real-world object silhouette. | Direct metaphorical storytelling, lifestyle brands. | Apple, Twitter bird, Target |
| **5. Abstract** | Geometric or conceptual mark with metaphorical meaning. | Deep-tech, infrastructure, financial protocols. | Nike swoosh, Chase octagon, Pepsi |
| **6. Emblem** | Typographic wordmark enclosed within a boundary/badge. | Heritage, community, education, physical goods. | Starbucks, Harley-Davidson, GitHub Copilot badge |
| **7. Mascot** | Illustrated character embodying the brand personality. | Consumer, gamified, or onboarding-heavy apps. | GitHub (Octocat), Duolingo (Owl), Docker (Moby) |

---

## 3. Mathematical Lockup & Clearspace Grid

Professional branding enforces rigid spatial relationships between the icon and typographic wordmark:

### A. Horizontal Lockup (Default / Navbar)
* **Icon-to-Text Gap ($G$)**: The horizontal margin between the icon and the first letter of the wordmark MUST equal exactly **$25\%$ to $33\%$ of the icon's width ($W$)**.
* **Vertical Baseline Alignment**: The vertical midpoint of the icon MUST align optically with the lowercase x-height or uppercase cap-height of the wordmark typography (never arbitrary baseline float).

### B. Stacked Lockup (Center / Splash Screen)
* **Icon-to-Text Gap**: Vertical distance equal to **$50\%$ of icon height ($H$)**.
* **Optical Horizontal Centering**: Wordmark horizontally centered directly below the optical weight center of the icon.

### C. The Clearspace Perimeter (The Exclusion Zone)
* **Clearspace Margin ($X$)**: The minimum breathing room surrounding the logo lockup on all 4 sides MUST equal **$100\%$ of the icon's height ($H$)** (or the height of the capital letter "X" of the wordmark).
* No competing text, borders, buttons, or page margins may invade this exclusion zone.

---

## 4. Standard Asset Delivery Package (`assets/logo/`)

A production-ready logo delivery must provide the following files:

```
assets/logo/
├── logo.svg                 # Primary horizontal lockup (Icon + Wordmark)
├── logo-stacked.svg         # Centered vertical lockup (for splash screens/invoices)
├── logo-icon.svg            # Standalone 1:1 square mark (for App Icon, Avatar, Favicon)
├── logo-monochrome-black.svg# Pure black vector silhouette (#000000)
├── logo-monochrome-white.svg# Pure white vector silhouette (#FFFFFF)
├── favicon.ico              # Multi-resolution ICO (16x16, 32x32, 48x48)
├── icon-192.png             # Android PWA home screen icon
└── icon-512.png             # Android PWA splash screen & Apple touch fallback
```

---

## 6. Anti-AI-Default Convergence Ban (The Sameness Blocker)

When unprompted, LLMs default to an identical predictable aesthetic across 90% of requests. The following AI-default styling convergence is **EXPLICITLY BANNED** unless the human's reference explicitly demands it:

| Component | Forbidden AI-Default Convergence (Banned) | Disciplined Diverse Direction |
| :--- | :--- | :--- |
| **Color Palette** | Cream background (`#FDFBF7`) + Terracotta / Burnt Orange (`#C85A32`) + Muted Gold accent (`#D4AF37`). Also default Tailwind Blue (`#3B82F6`). | High-contrast monochromatic slate, deep petrol ink (`#0F172A`), acid lime, electric violet, or strict brutalist monotone. |
| **Heading Font** | Fraunces, Playfair Display, or generic serif italic quotes on dark backgrounds. | Modern geometric display sans, crisp grotesks, technical monospace, or bespoke optical letterforms. |
| **Mark Concept**| A single lowercase letter passively trapped inside a colored circle or rounded squircle. | Negative-space cutouts, dynamic asymmetric strokes, kinetic geometric angles, or pure structural wordmarks. |
| **Background** | Subtle purple-indigo radial glow / mesh gradient centered in the viewport. | Solid optical matte surfaces, strict 1px border dividers, or subtle architectural dot grids. |

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
