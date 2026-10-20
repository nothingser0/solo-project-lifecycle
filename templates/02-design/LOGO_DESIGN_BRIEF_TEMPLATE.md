# Logo Design Brief: [Project Name]

**Project**: [Project Name]  
**Created**: YYYY-MM-DD  
**Owner**: [User / Team]  

---

## 1. Product Name & Philosophy

**[Product Name]**: [2-3 sentences explaining what the product does and why it exists.]

---

## 2. Target User

[1 sentence defining the primary audience and usage context.]

---

## 3. Brand Vibe & Mark Archetype Selection

- **Target Mark Archetype**: [Select from `references/design/LOGO_DESIGN_CRAFT_GUIDE.md` §2: Wordmark / Lettermark-Monogram / Letterform / Combination / Pictorial / Abstract / Emblem / Negative-Space]
- **Archetype rationale**: [Why this type fits the name length, the product's image-ability, and the media budget — see the decision guide in §2]
- **Second type explored**: [The alternative you tested before committing; a concept only ever drawn in one type was never tested]
- **Category clichés named before drawing**: [The 3–4 obvious moves in this sector, written down first]
- **One concept free of every default**: [Which concept uses nothing from the flagged list — required, or the shortlist is one idea three times]
- **[Keyword 1]** - [Brief rationale]
- **[Keyword 2]** - [Brief rationale]
- **[Keyword 3]** - [Brief rationale]
- **[Keyword 4]** - [Brief rationale]

---

## 3.0 Defaults Register (`defaults_used`)

Every flagged default that survived into a concept — a font, a palette region, or a mark tag — is recorded here with a **concrete** reason. Base rates and the full tag vocabulary: `references/design/AI_DEFAULTS_REFERENCE.md`; the rule: `references/design/LOGO_DESIGN_CRAFT_GUIDE.md` §7.

| Concept | Default id / tag | Why this brand, specifically |
| :--- | :--- | :--- |
| A | [e.g. `inter-text`] | [e.g. "UI-dense product, 4 languages, existing Inter brand asset"] |
| B | [e.g. `negative-space`] | [e.g. "the mark reads as a ledger rule; competitors use literal icons"] |
| C | — | *(none — this is the concept that must use no defaults)* |

**Rules**
- An empty or vague reason ("feels warm", "modern", "premium") is a **blocking** defect, not a pass. Claiming a default is not justifying it.
- If the honest reason is "it was the first idea", write that. That is the finding, and the concept should change.
- An agent may never invent a justification on the human's behalf.

---

## 3.1 Word Map (language → symbol)

Good marks come from translating language into form. Fill this before drawing anything; if you cannot fill it, the brief is not ready.

| Core word | Nouns (drawable) | Associations / metaphors | Opposites | Materials / processes |
| :--- | :--- | :--- | :--- | :--- |
| **Name**: [word] | | | | |
| **Offering**: [what they sell] | | | | |
| **Adjective 1** | | | | |
| **Adjective 2** | | | | |
| **Promise**: [the outcome] | | | | |

**Intersections** (where two branches meet — this is where distinctive ideas live):
1. [e.g. "an H whose crossbar is a calm horizon line"]
2. [ ]
3. [ ]
4. [ ]

> Each intersection becomes a **one-sentence concept** before it becomes a drawing. A sentence that could describe a competitor's logo is not a concept.

---

## 4. User Responsibility & Disciplinary Verification

⛔ **Blocked until Step 0.5 is satisfied**: this brief is written *from* the human's references in
`docs/design/inspiration/`. If that folder holds no human-supplied file, the agent stops and asks —
it does not draft this document, and it does not invent a reference to unblock itself.

User handles logo generation and asset extraction:
1. Place your visual references in `docs/design/inspiration/` (screenshots, brand board, or `links.md`).
2. Generate logo using the prompt template with your own visual references.
3. Extract primary and optional accent brand colors (hex codes) for `DESIGN.md`.
4. Verify the generated mark against `references/design/LOGO_DESIGN_CRAFT_GUIDE.md`:
   - [ ] **16px Squint Test**: Is the mark instantly identifiable as a 16x16 favicon?
   - [ ] **One-Colour Test**: Does it hold its shape as pure monochrome black/white?
   - [ ] **3:1 Contrast Shelf Test**: Verified against both light and dark surfaces.
   - [ ] **Anti-Slop Ban**: Free of generic category clichés (no shields/charts/piggybanks).
   - [ ] **Optical corrections applied** (§3): overshoot on curves, bone effect fixed on capsules, reversed variant thinned for irradiation, optical centring nudged up
   - [ ] **Mechanical audit clean**: `python3 scripts/design/svg_audit.py assets/logo/*.svg` — zero FAIL, and every WARN either fixed or explained
   - [ ] **Real holes, not white paint**: negative-space counters use `fill-rule="evenodd"`, not white shapes on top
5. Save SVG and PNG exports to `/assets/logo/`:
   - `logo.svg` (Primary lockup)
   - `logo-icon.svg` (Standalone mark)
   - `logo-icon-small.svg` (Simplified small-size cut, if the main icon fails at 16px)
   - `icon-512.png`
   - `icon-192.png`
   - `favicon.ico`

---

## 5. AI Prompt Template

Base prompt for AI logo tools (ChatGPT / Midjourney / LogoAI). Attach visual reference images and customize:

```text
[UPLOAD YOUR LOGO REFERENCES HERE]

Design a minimalist vector logo for "[Product Name]", a [brief product description].

Brand personality:
- [Vibe keyword 1]
- [Vibe keyword 2]
- [Vibe keyword 3]
- [Vibe keyword 4]

Style references: [Describe reference images or rely on uploaded attachments]

Constraints:
- Flat vector, transparent background, high contrast
- Simple geometry, no gradients, no 3D effects
- Scalable from 16px favicon to 512px app icon
- Centered composition, 1:1 aspect ratio
```

---

## Status & Next Steps

- [ ] Generate logo or proceed with placeholder (e.g., text monogram).
- [ ] Save assets to `/assets/logo/`.
- [ ] Update `DESIGN.md` with extracted primary brand color.
- [ ] Proceed to Step 0B (`SITEMAP.md`).
