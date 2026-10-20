# Logo Design Craft & Verification Guide

> **Module**: M04 (UI/UX Design & Prototyping)
> **Source**: Adapted from `kaankiziltug/logo-design-skill` (MIT) — optical correction set, mark-type taxonomy and audit heuristics — and `fatihaydost/brand-identity-skill` (MIT) — the measured AI-defaults dataset and the flag-plus-justification model; plus professional SVG logo principles and testing methodologies.
> **Objective**: Ensure that brand marks are disciplined, scalable, non-generic, and technically flawless before Design Freeze.
> **Tooling**: `scripts/design/svg_audit.py` mechanically checks the rules in §6. Run it before showing a mark to anyone.
> **Base rates**: `references/design/AI_DEFAULTS_REFERENCE.md` holds the measured model defaults and the full cliché tag vocabulary used in §7.

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
* **Correction**: Provide two distinct SVG variants: `logo-light.svg` (for light backgrounds) and `logo-dark.svg` (for dark backgrounds). For text inside a lockup, 4.5:1 applies, not 3:1.

### Test 4: The Reflex Test (Name the Cliché, Then Justify or Change It)

AI and inexperienced designers default to the same visual tropes. Treat them as **flagged**, not forbidden — a ban just moves the model to the next default. Each one may be used **if it is named and defended from the brief** (§7).

| Industry Sector | Flagged clichés | Disciplined direction |
| :--- | :--- | :--- |
| **Fintech / Finance** | Piggy banks, gold coins, generic shield, bank blue `#0047AB`. | Strict geometric typography, architectural grids, modern editorial contrast. |
| **SaaS / DevTools** | Chat bubbles, padlocks, ascending chart arrows, gear icons. | Monograms, abstract letterforms, dynamic angles, high-contrast monospace balance. |
| **Healthcare / Med** | EKG heartbeat lines, medical crosses, pill capsules, leafy hands. | Organic curved silhouettes, calming asymmetrical forms, warm human geometry. |
| **Logistics / Delivery**| Wings, flying paper airplanes, generic cardboard boxes. | Motion lines, kinetic bold letterforms, spatial road/route abstractions. |

**Before drawing:** write the category's three or four obvious moves down explicitly. Then either avoid them, or record the one you kept in `defaults_used` with a concrete reason. At least one concept in the shortlist must use none of them.

---

## 2. The 8 Mark Types Decision Framework

Before drawing or prompting any mark, select the exact mark archetype matching product strategy.

| Mark Type | Description | Best Suited For | Watch out for |
| :--- | :--- | :--- | :--- |
| **1. Wordmark** | Distinct custom typographic treatment of the brand name alone. | Short, punchy, memorable names (<7 chars). | Generic if the type is stock; long names shrink into thin strips. |
| **2. Lettermark / Monogram** | Two or more initials combined into one mark. | Long or hard-to-say names; fashion, heritage, institutions. | Woven initials carry little meaning; needs heavy exposure. |
| **3. Letterform** | A single initial treated as a symbol (carries the concept in its *treatment*). | App icons, favicons, avatars, tech and finance. | Many brands share the same letter — the twist must be ownable. |
| **4. Combination** | Symbol locked up with a wordmark (horizontal or stacked). | Most new brands; the symbol can later stand alone. | Two weak halves do not make one strong mark. |
| **5. Pictorial** | Simplified, recognizable real-world object or animal silhouette. | Direct metaphor, lifestyle brands, wordless recognition. | Literalness; clichés; too much detail at small sizes. |
| **6. Abstract** | Non-representational form carrying an idea (speed, connection, growth). | Deep tech, infrastructure, diversified companies. | Meaningless without exposure and a story to teach it. |
| **7. Emblem / Badge** | Type locked inside a boundary, seal, or shield. | Heritage, community, education, sports, physical goods. | Illegible when small; inflexible across media. |
| **8. Negative Space** | Figure and ground both carry meaning; two silhouettes share an edge. | When a clever, conceptually linked pair genuinely exists. | The hardest type to execute; forced results read as ambiguity. |

### Decision guide

1. **Name is short and distinctive** → wordmark, optionally with a companion symbol.
2. **Name is long or hard to say** → monogram or letterform plus the wordmark.
3. **The product has one vivid, unambiguous image** → pictorial, reduced to geometry.
4. **The concept is a phenomenon, not an object** → abstract, and budget for teaching it.
5. **There is a real two-silhouette idea** → negative space; if you have to explain the overlap, it is not there yet.
6. **The brand needs warmth and a face** → mascot, and accept the complexity cost.
7. **The identity must survive embroidery and engraving** → emblem or solid pictorial.

**Explore at least two different types** before committing. A concept that only exists in one type was never tested against alternatives.

---

## 3. Optical Corrections (the craft layer)

Geometry that measures correct still looks wrong. These are the corrections that separate a resolved mark from a drafted one. Apply them in the final stage, not while concepting.

| Effect | What happens | Correction |
| :--- | :--- | :--- |
| **Overshoot** | Round and pointed shapes look smaller than flat-edged shapes of equal height. | Let curves extend **1–3%** past the cap/baseline; sharp apexes may need **3–6%**. |
| **Bone effect** | Where a curve meets a straight tangentially (capsules, rounded rects), the straight segment appears to pinch inward. | Ramp curvature gradually (cubic Bézier handles ≈ 0.55–0.65 of the corner size) instead of jumping from line to full arc. |
| **Irradiation** | Light-on-dark reads larger and bolder than dark-on-light. | Provide a **reversed variant with strokes thinned 2–5%**, or scaled down slightly. Test side by side until they look equal. |
| **Same-size illusion** | A circle, square and triangle of equal bounding box do not look equally sized. | Enlarge by eye: circle slightly larger than square; triangle larger still. |
| **Horizontal weight** | Horizontal strokes look heavier than vertical strokes of the same width. | Thin horizontals **5–10%**; thin strokes near acute junctions to avoid ink traps. |
| **Optical centre** | The optical centre sits slightly *above* the geometric centre. | Nudge the mark up a little; shift asymmetric shapes toward their visual mass, not their bounding box. |
| **Letter test** | A modified letter may stop reading as that letter. | Check every modified letter at first glance. If a K reads as an h, revise the treatment. |
| **Junction inspection** | Where strokes meet, accidental notches, slivers, lumps and ink traps appear. | Inspect every junction at 4× zoom; no sliver narrower than the thinnest intentional stroke. |

> **Gridding is for finishing, not for starting.** Apply construction grids after the concept is chosen to find misalignments and stray angles. Do not over-grid: an organic curve that refuses to decompose into circles is fine. A construction drawing covered in meaningless circles is a presentation gimmick.

---

## 4. Mark Type Detail — What Each One Actually Costs

**Wordmark.** Sidesteps the recognition problem — the name is always visible. Becomes generic unless you customise something: a cut, a join, a distinctive terminal, a ligature, a letter substituted with a meaningful sign, a shape hidden in a counter. Lowercase reads approachable, uppercase institutional, title case conventional.

**Lettermark / Monogram.** Solves long names and tight spaces. Letters with rich structure (`a`, `s`, `w`, `g`, `k`, `R`, `M`, `W`) interlock interestingly; `i`, `l`, `I` offer little. Look for shared strokes, mirrored shapes and nestable counters.

**Letterform.** More neutral and often more timeless than pictorial marks. The concept must live in the treatment: a letter that is also an arrow, a path, a fold, a container, a person.

**Pictorial.** Work in silhouette first — the object's most characteristic view is the one that cannot be mistaken for something else. Reduce to geometry: a leaf is two quarter-circles, a bird is a few arcs. Pair with neutral typography to avoid overload.

**Abstract.** Only meaningful after exposure. Some phenomena map naturally (connection → linking shapes; speed → tapering sweep); others ("reliability", "quality") have no natural sign, so meaning is assigned through story and repetition. Check for unintended political, religious or ethnic connotations.

**Negative space.** The strongest versions merge **two strongly recognisable silhouettes that are conceptually related**, one positive and one negative. Rare and the hardest to do; forced results read as ambiguity rather than cleverness.

**Mascot.** Buys warmth and personality; costs complexity, dates faster, and usually needs a simplified small-size cut.

**Emblem.** Excellent for heritage and physical goods; fails at small sizes unless a standalone symbol is also provided.

---

## 5. Mathematical Lockup & Clearspace Grid

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

## 6. SVG Technical Craft & Optical Rules

Run `python3 scripts/design/svg_audit.py assets/logo/*.svg` before showing any mark. It checks rules 1–6 and 9–10 mechanically.

1. **Optical Centering over Geometric Centering**: Asymmetrical marks, triangles, play buttons, and curved letterforms have uneven visual weight. Centering by bounding box makes them look off-center.
2. **Overshoot Compensation**: Curves and apexes extend 1–3% (3–6% for sharp points) beyond the baseline/cap height.
3. **Anchor Point Budget (Complexity Cap)**: A production vector mark should have **fewer than 150 anchor points**. Marks above ~300 indicate bloated autotracing or messy Bézier handles. Every anchor must earn its place.
4. **Zero Near-Miss Angles**: Structural lines intended vertical or horizontal snap to 90.0°/180.0°; deliberate diagonals snap to 0/15/30/45/60/75°. An element at 43° should be 45°; 1–3° off reads as a mistake.
5. **Master File Cleanliness (Strict Forbidden Tags)**: No raster `<image>`, blur `<filter>`, or `<foreignObject>` in a master. Pure vector geometry only (`<path>`, `<rect>`, `<circle>`, `<polygon>`).
6. **Raster Erosion Gate (16px Favicon Limit)**: At 16×16 px, no line, stroke, or negative-space gap may render narrower than **1 px** physical thickness. Details thinner than 1 px disappear to sub-pixel raster erosion. (The audit measures sub-shapes against 1/48 of the canvas for symbols, 1/32 of the lockup height for wordmarks.)
7. **False-Hole Prevention (`fill-rule` Integrity)**: Negative-space counters must be real holes (`fill-rule="evenodd"` or subtracted paths), never white shapes painted on top. Painted white "holes" break on coloured or photographic backgrounds and in one-colour versions.
8. **Display Font License Gate**: Any typography in wordmarks or lockups must have a commercial-safe license (SIL OFL 1.1 or Apache 2.0). Never embed unlicensed proprietary type into client deliverables.
9. **Clean ViewBox**: Always a clean square or proportional `viewBox` (`0 0 256 256` for symbols; lockups keep height 256), never hardcoded px bounds without a viewBox.
10. **Path Outlines**: Convert all live text to vector `<path>` outlines so the SVG renders identically without the local font installed. (`<text>` is allowed for exploration only, and must be flagged.)
11. **Zero Embedded Base64**: Never embed raster images (`<image href="data:image/png...">`) inside a logo SVG.
12. **Vector Size Cap**: A production logo icon should be lightweight and under 50 KB.

### Benchmark reference points

The audit compares complexity against a 1,432-logo reference corpus (`scripts/design/library-stats.json`):

| Measure | Median | p75 | p95 |
| :--- | ---: | ---: | ---: |
| Anchor points (all logos) | 75 | 155 | 379 |
| Anchor points (square icons) | 53 | 95 | 274 |
| Distinct colours | 2 | 4 | 10 |

About **75%** of reference logos use ≤3 colours; gradients appear in ~19%. Roughly **9 in 10** full logos are wide horizontal lockups (aspect >2.5:1), while **3 in 4** icons are near-square (0.8–1.25:1). Design the symbol and the lockup **as a pair** from day one.

---

## 7. AI Defaults: Flagged, Not Banned (The Sameness Blocker)

When unprompted, models converge on the same aesthetic. A **ban** does not fix this — it just moves the model to the next default. What works is a **flag plus a justification requirement**: the default is allowed, but it must be named and defended from the brief.

### 7.1 The reflex test (run after every draft)

> **"Would I propose this same font, palette or mark idea for another brand in this sector?"**

If yes, you are using a default. Either justify it from the brief, or change it. **At least one concept in every shortlist must use nothing from the list below** — otherwise you have produced three versions of the same stereotype.

A justification is concrete or it is not a justification:

| Valid | Not a reason |
| :--- | :--- |
| The user asked for it explicitly | "Feels warm" |
| The competitor map shows that region empty | "Feels premium" |
| It is an existing brand asset being retained | "It's modern" |
| A production constraint demands it (licensed face already bought, weight budget) | "It tested well" (no test was run) |

### 7.2 Measured model defaults

These were measured on a 180-answer, 30-brief experiment (Claude Opus/Sonnet/Haiku, 2026-10). Treat them as **base rates**, not laws — and re-measure when models change.

| Default | Base rate | When it is legitimate |
| :--- | :--- | :--- |
| **Fraunces / soft serif display** | 24% of display faces (Opus 40%) | The brief's voice really is soft and crafted, and competitors do not use it |
| **Inter text face** | 40% of text faces (Haiku 57%) | UI-dense product, wide language coverage, or an existing Inter brand |
| **Cream ground + terracotta + gold accent** | 47–50% of Opus/Sonnet palettes | The material is real (fired clay, kraft) or the region is empty on the competitor shelf |
| **Navy primary + gold accent** | Dominant in law, property, finance, insurance | The sector genuinely requires that register and you add something ownable |
| **Sector fonts** (Cormorant for wine/hotel, Barlow Condensed for construction, Space Grotesk for AI/fintech, Poppins for edtech) | High | You have a brief-grounded reason and a second reading |
| **Indigo/violet in tech** | Common only in technology briefs | Genuinely a tech product and the accent is not the whole idea |
| **Symbol + wordmark lockup** | 97–100% of answers | Standard, but **also offer a wordmark-only or typographic concept** |
| **Blue-to-purple gradient** | Rare (5%) but reads as a cliché when it appears | Almost never |

### 7.3 Category clichés (human-made, not just AI)

Four-point spark · radial swirl · gradient orb · initial in a rounded square (that tile is the *app-icon container*, not a logo) · hexagon/nodes/cube · leaf, shield, roof, up-arrow, bulb, globe, bolt, mountain, key, flame · the swoosh · outline icons on a uniform stroke grid · mockup polish over a weak form.

**Judge flat, one colour, at 16 px, before any mockup.**

### 7.4 Record it, don't hide it

Every flagged default that survives into a concept goes into the brief's `defaults_used` list with its id and a concrete reason. The same applies to **tagged mark types**: `literal-object`, `hidden-letter`, `negative-space`, `circle-container`, `local-nod`, `gradient`, `spark`, `radial-swirl`, `gradient-orb`, `initial-in-rounded-square`, `hexagon-nodes`, `category-icon`, `swoosh`, `outline-icon`.

**The gate rule** (measure, then judge):
- A cliché used **without** a recorded justification → **warning**, surfaced for the human to decide.
- A cliché **listed** in `defaults_used` but with an empty or vague reason → **blocking**. Claiming a default is not the same as justifying it.

An agent may never invent a justification. If the honest answer is "I chose it because it was the first idea", that is the finding.

---

## 8. Standard Asset Delivery Package (`assets/logo/`)

A production-ready logo delivery must provide the following files:

```
assets/logo/
├── logo.svg                 # Primary horizontal lockup (Icon + Wordmark)
├── logo-stacked.svg         # Centered vertical lockup (for splash screens/invoices)
├── logo-icon.svg            # Standalone 1:1 square mark (for App Icon, Avatar, Favicon)
├── logo-icon-small.svg      # Simplified small-size cut (if the main icon fails at 16px)
├── logo-monochrome-black.svg# Pure black vector silhouette (#000000)
├── logo-monochrome-white.svg# Pure white vector silhouette (#FFFFFF), strokes thinned for irradiation
├── favicon.ico              # Multi-resolution ICO (16x16, 32x32, 48x48)
├── icon-192.png             # Android PWA home screen icon
└── icon-512.png             # Android PWA splash screen & Apple touch fallback
```

---

## 9. Honesty Rules

1. **Never claim a test you did not run.** If you could not render and inspect the mark, say so.
2. **You cannot guarantee trademark clearance.** Recommend a professional search (trademark databases, reverse image search).
3. **Font licences must allow logo use.** State which fonts you assumed, and that outlines were constructed or must be made.
4. **Never trace a reference.** Studying a competitor's construction is legitimate; reproducing its geometry is not.
