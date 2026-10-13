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

## 3. Brand Vibe

- **[Keyword 1]** - [Brief rationale]
- **[Keyword 2]** - [Brief rationale]
- **[Keyword 3]** - [Brief rationale]
- **[Keyword 4]** - [Brief rationale]

---

## 4. User Responsibility

⛔ **Blocked until Step 0.5 is satisfied**: this brief is written *from* the human's references in
`docs/design/inspiration/`. If that folder holds no human-supplied file, the agent stops and asks —
it does not draft this document, and it does not invent a reference to unblock itself.

User handles logo generation and asset extraction:
1. Place your visual references in `docs/design/inspiration/` (screenshots, brand board, or `links.md`).
2. Generate logo using the prompt template with your own visual references.
3. Extract primary and optional accent brand colors (hex codes) for `DESIGN.md`.
4. Save SVG and PNG exports to `/assets/logo/`:
   - `logo.svg`
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
