# AI Defaults — Measured Base Rates & Cliché Tags

> **Module**: M04 (UI/UX) — referenced by `LOGO_DESIGN_CRAFT_GUIDE.md` §7 and the logo brief
> **Source**: Adapted from `fatihaydost/brand-identity-skill` (MIT) — the measured-defaults dataset and the flag-plus-justification model. Base rates are that project's published experiment; re-measure when models change.
> **Purpose**: Turn "avoid AI slop" from an adjective into a **checkable base rate**. A default is allowed — it just has to be named and defended.

---

## 1. Why rates, not bans

A ban moves the model to the next default. What actually reduces sameness is a **flag plus a justification requirement**: the default is visible, the reason is written down, and an unjustified one is a finding.

Run the **reflex test** after every draft:

> *"Would I propose this same font, palette or mark idea for another brand in this sector?"*

If yes → justify from the brief, or change it. **At least one concept in every shortlist must use nothing from these lists.**

---

## 2. Section A — Model defaults

Measured on 180 answers across 30 briefs (Claude Opus/Sonnet/Haiku, 2026-10). The core finding: the model reproduces a **sector stereotype** — the same brief produced the same display face 67–80% of the time on repeat, and 60% across models.

| ID | Component | Default | Base rate | Legitimate when |
| :--- | :--- | :--- | :--- | :--- |
| `fraunces-display` | type | Fraunces / soft-serif display (Recoleta, Playfair) | 24% of display faces; Opus 40% | The brief's voice is genuinely soft and crafted, and the competitor shelf is empty there |
| `inter-text` | type | Inter as the text face | 40% of text faces; Haiku 57% | UI-dense product, wide language coverage, or an existing Inter asset |
| `cream-ground` | palette | Cream / bone light neutral (L 0.88–1.0, C 0.008–0.05, h 40–110) | 57–67% of Opus/Sonnet palettes | The material is real (paper, kraft, plaster) or the region is empty |
| `terracotta-clay` | palette | Terracotta / clay (L 0.45–0.72, C 0.08–0.18, h 25–60) | 63–70% | Real fired clay or kraft material; or an empty competitor region |
| `gold-brass-accent` | palette | Gold / brass / mustard accent (L 0.55–0.85, C 0.07–0.17, h 60–100) | 70–77% | A genuine premium material, not "premium" as a mood |
| `navy-primary` | palette | Navy primary (L 0–0.40, h 225–285) | Dominant in law, property, finance, insurance, public sector | The sector register is real and you add something ownable |
| `sector-font-cormorant` | type | Cormorant Garamond | Wine, hotel, property | Sector register genuinely requires it |
| `sector-font-canela` | type | Canela | Law | Same |
| `sector-font-barlow-condensed` | type | Barlow Condensed | Construction, logistics | Same |
| `sector-font-tech-grotesk` | type | Space Grotesk / Sora | AI, crypto, fintech | Same |
| `sector-font-poppins` | type | Poppins | Edtech | Same |
| `tech-indigo-violet` | palette | Indigo/violet primary | Technology briefs only (~6% elsewhere) | Genuinely a tech product, and violet is not the whole idea |
| `gradient` | logo | Blue→purple gradient fill | ~5% | Almost never — and if used, keep a flat one-colour master |

**Also measured**: symbol + wordmark lockups appear in 97–100% of answers. The lockup is standard, not wrong — but a shortlist of three lockups is one idea three times. **Offer a wordmark-only or purely typographic concept.**

---

## 3. Section B — Category clichés (human-made, not only AI)

| Tag | What it looks like | Why it fails |
| :--- | :--- | :--- |
| `spark` | Four-point star / sparkle, 8 vertices alternating radii | The universal "AI product" glyph |
| `radial-swirl` | *n* rotated copies of one module around a central hole | Reads as a generated pattern, not a decision |
| `gradient-orb` | Glowing sphere or blob, usually blue-violet | Belongs to a 2023–24 app-icon trend |
| `initial-in-rounded-square` | One glyph inside a radiused tile filling the canvas | That tile is the **app-icon container**, not a logo |
| `hexagon-nodes` | Regular hexagon, cube, or node-and-line graph | "Blockchain/network" shorthand |
| `category-icon` | The sector's stock icon: leaf, shield, roof, up-arrow, bulb, globe, bolt, mountain, key, flame | Says the category, not the brand |
| `swoosh` | Generic motion swoosh or orbit arc | The most-copied mark shape in existence |
| `outline-icon` | Stroke-only, uniform stroke ≈1/12 of size, round caps | It is an icon-set style, not an identity |
| `literal-object` | The symbol draws the object the name names (moon for Moonvault) | Identifies nothing beyond the word |
| `hidden-letter` | An initial hidden inside the symbol | Fine as a second reading, weak as the whole idea |
| `negative-space` | The idea depends on a figure read in the empty space | Strongest of the set — and the hardest to execute |
| `circle-container` | Symbol enclosed in or built on a circle/ring/badge | Container substitutes for concept |
| `local-nod` | A landmark, flag, or tourist symbol of the city/country | Dates fast; often means nothing to the actual customer |

**Judge flat, one colour, at 16 px, before any mockup.** Mockup polish over a weak form is the most common way a cliché survives review.

---

## 4. How to apply

1. **Before drawing** — write down the sector's three or four obvious moves. Naming them is what makes the reflex test possible.
2. **While drafting** — run the reflex test on every font, colour, and mark idea.
3. **Before showing** — record every surviving default in the brief's `defaults_used` table with a concrete reason.
4. **Judge** — an unjustified cliché is a **warning**; a cliché *claimed* with an empty reason is **blocking**. An agent may never invent the justification.

### Valid vs invalid reasons

| Valid | Invalid |
| :--- | :--- |
| The user asked for it explicitly | "Feels warm" |
| The competitor map shows that region empty | "Feels premium" |
| An existing brand asset being retained | "It's modern" |
| A production constraint (licensed face, weight budget, legacy print) | "It tested well" (no test was run) |

---

## 5. Honest limits

- These are **base rates from one experiment on specific models**, not universal laws. They will drift.
- The colour regions are OKLCH ranges; a colour matching the range is *flagged*, not *wrong*.
- Detecting a tag in a finished mark is heuristic. The audit flags; the human decides.
- The dataset covers English-language briefs and Western/global sectors. Base rates for an Indonesian market brief are not measured here — treat the list as directional, and record your own observations.
