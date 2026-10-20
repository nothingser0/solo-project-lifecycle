# Design-to-Code Fidelity Guide

> **Module**: M04 (design handoff), M06 (implementation), M07 (visual QA)
> **Purpose**: Close the gap between the design image and the shipped page, with measurements instead of opinions.
> **Source**: Principles adapted from `oil-oil/draw-ui` (no license — principles only, no text or code copied). The comparator in `scripts/design/compare_png.py` is original, written for this framework.
> **Companion**: `templates/06-qa-uat/POLISH_AUDIT_TEMPLATE.md` (surface tells) · `templates/02-design/DESIGN_TOKENS_SPEC_TEMPLATE.md` (token source of truth)

---

## 1. Three numbers that are not the same number

Most "the page doesn't match the design" arguments come from conflating these.

| Number | What it is | What it is not |
| :--- | :--- | :--- |
| **Logical viewport** | The CSS width the layout was designed against (e.g. 390px) | The pixel width of the exported image |
| **Document height** | How tall the full page is when scrolled | The viewport height |
| **Capture pixels** | The actual PNG dimensions | The CSS layout width |

A design exported at 1170×2532 for a 390×844 logical viewport is a **3× capture**, not a 1170px-wide layout. Treating 1170 as the CSS width makes every font size and spacing value three times too large, and the whole implementation is wrong in a way that looks deliberate.

**Rule**: record all three explicitly before writing any CSS. `DESIGN_SPEC.md` §3 carries the viewport; the capture scale belongs next to it.

---

## 2. Region measurement, not whole-image guessing

A whole-image difference tells you *that* something moved. It never tells you *what*. Measure named regions instead.

```json
{
  "reference": "design.png",
  "css_viewport_width": 1024,
  "regions": [
    {"name": "page-bg",   "kind": "color", "box": [20, 20, 100, 40], "inset": 2},
    {"name": "card-a",    "box": [40, 200, 280, 320]},
    {"name": "card-b",    "box": [344, 200, 280, 320]},
    {"name": "title-ink", "box": [40, 90, 420, 70], "box_type": "ink"}
  ]
}
```

| Field | Meaning |
| :--- | :--- |
| `box` | `[x, y, width, height]` in **reference pixels** — not corner coordinates |
| `kind` | `box` (geometry) or `color` (sample the area) |
| `box_type` | `element` (the box around a component) · `ink` (the visible glyphs only) · `sample` (a flat area) |
| `inset` | Pixels to pull in before sampling colour, so anti-aliased edges and text do not contaminate the sample |

**Why `ink` vs `element` matters**: a heading's element box and its visible glyphs have different geometry. If you match the glyph box but compare it to the DOM element box, you will "fix" a real font problem by shrinking the container — which breaks the layout and leaves the font wrong.

**Colour sampling discipline**: sample the interior, avoiding text, photography and highlights. Read the median *and* the 10th/90th percentiles. A wide spread means a gradient or contamination, not a token. Do not promote every sampled value into a CSS variable.

**Repeated components**: compare width and gap distributions across siblings. Small variation is one shared spec; a genuinely different ratio is a second component. Do not assume equal widths before measuring.

---

## 3. The comparison loop

```bash
# 1. Compare the render against the design, with named regions
python3 scripts/design/compare_png.py \
  --reference design.png --candidate shot.png \
  --region hero:0,0,1024,600 --region cards:40,200,584,320

# 2. Long pages: compare the shared area and report the height delta
python3 scripts/design/compare_png.py \
  --reference design.png --candidate shot.png --allow-height-difference

# 3. Machine-readable, for a round-over-round diff
python3 scripts/design/compare_png.py --reference a.png --candidate b.png --json
```

**The tool refuses to help you cheat**: it will not rescale either image. A width mismatch is a capture defect (wrong viewport, wrong DPR, wrong capture scale) and is reported as an error with exit code 2.

| Output | Meaning |
| :--- | :--- |
| `mad` | Mean absolute per-channel difference, 0–255. Robust, easy to reason about. |
| `rms` | Root mean square of the differences. Punishes large local differences more than `mad`. |
| `height_delta` | Candidate height minus reference height. Positive means the page grew. |

**What a number does not mean**: there is no universal pass threshold. A photographic hero will produce a large difference even when the layout is perfect; a flat-colour wireframe will produce a tiny one even when the type is wrong. The number *locates* the problem. You still have to look.

---

## 4. Fix in this order

When several regions are off, do not patch each one. The errors are usually one cause with many symptoms.

| Order | Fix | Why here |
| :-: | :--- | :--- |
| 1 | **Page width and container** | Every measurement below is relative to it. Fixing spacing first means redoing it. |
| 2 | **Font and line breaks** | Wrong font metrics shift every block below it. |
| 3 | **Spacing** | Once width and type are right, gaps become the only variable. |
| 4 | **Asset crop and decoration** | The last thing to move, because it absorbs the others' slack. |

**The cascade rule**: if consecutive sections are all offset in the same direction, find the **earliest** section that moved and fix that one. Adjusting every later section with a negative margin hides the cause and makes the next content change break again.

---

## 5. What code must not become

The single most common failure when reconstructing a design is shipping the design image as a background.

| Must be code | May be an image asset |
| :--- | :--- |
| Layout, cards, text, buttons, tables, filters, ordinary line icons | Logo, brand mark, complex illustration, photography, 3D or glass effects, effects CSS cannot reproduce accurately |

**The test**: select the text in the browser. If you cannot select it, it is not text. If a screenshot is the page background, the page has no accessible content, does not respond to viewport changes, cannot be translated, and fails every SEO and accessibility audit at once.

**Assets**: reuse original assets and clean crops first. Regenerate only when the original is missing or below the required resolution. Required pixels = CSS width × target DPR: a 150px-wide logo at DPR 2 needs 300 effective pixels. Whitespace does not count toward resolution, and upscaling does not restore detail.

**Never present a generated PNG or a raster wrapped in an SVG as an original vector.** A brand mark that has been "redrawn" is a different brand mark.

---

## 6. Verification is not one check

| Check | Proves | Does not prove |
| :--- | :--- | :--- |
| Pixel/region diff | Layout and colour are close at one size | Nothing about interaction, other viewports, or fonts |
| DOM measurement | Element boxes and computed styles match | That the visible glyphs match (font substitution) |
| Visual inspection at target size | The thing actually looks right | Anything about behaviour |
| Real interaction | Buttons, states, errors work | Visual fidelity |
| Cross-viewport pass | Layout survives resizing | Fidelity at any one size |

**The font trap**: a CSS `font-family` list containing the right font, plus a loaded webfont, does not prove the intended font rendered. Check the *computed* font actually used for the glyphs, or compare glyph shapes in a zoomed region. Fallback fonts are the most common silent fidelity failure, and they pass every automated check.

**The DPR trap**: a 240×80 CSS logo area needs a 480×160 device-pixel screenshot to prove anything at DPR 2. Judging it from a full-page thumbnail at 1× proves nothing about the edges.

---

## 7. Report honestly

State separately:

- **Verified**: regions measured, viewports tested, interactions exercised.
- **Inferred**: values read off a design image where no source file exists.
- **Not verified**: anything you did not actually run.

Never convert a difference score into a "fidelity percentage". It sounds precise and means nothing, and it invites an argument about the number instead of the design. Report the region, the delta, and the cause.

Differences caused by photography, substitute fonts, or a missing brand master are **not defects to be closed** — they are conditions to be stated.
