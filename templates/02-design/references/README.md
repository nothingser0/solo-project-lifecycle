# Design References System

> **Purpose**: Store and analyze design reference materials to guide component generation with specific aesthetic, not generic AI templates.

---

## 📁 Folder Structure

```
references/design/
├── inspiration/                    ← USER FILLS THIS
│   ├── screenshot-1-dashboard.png
│   ├── screenshot-2-forms.png
│   ├── screenshot-3-buttons.png
│   └── notes.md                    ← ANALYSIS (use notes-template.md)
│
├── stitch-input/                   ← Prompts for Google Stitch
│   └── README.md
│
└── stitch-output/                  ← Results from Stitch
    └── README.md
```

---

## 🎯 Workflow

### Step 1: Collect Reference Screenshots

Save 3-5 screenshots of designs you want to emulate:

```bash
references/design/inspiration/
├── linear-dashboard.png        # Example: Linear.app dashboard
├── stripe-landing.png          # Example: Stripe.com landing page
├── vercel-buttons.png          # Example: Vercel.com button styles
└── notes.md                    # Analysis (copy from notes-template.md)
```

**What to capture:**
- Dashboard layouts (spacing, card design)
- Form screens (input styling, validation states)
- Button variations (primary, secondary, states)
- Typography examples (headings, body text)
- Color palette samples (extract from screenshots)

---

### Step 2: Analyze References

Copy `inspiration-template/notes-template.md` to `inspiration/notes.md`:

```bash
cp references/design/inspiration-template/notes-template.md \
   references/design/inspiration/notes.md
```

Then fill in the template:

```markdown
## Screenshot 1: linear-dashboard.png
**Source**: Linear.app
**Focus**: Dashboard layout, card design, color palette

**Observations**:
- Colors: Primary #5E6AD2 (purple), Neutrals Zinc scale
- Typography: Inter 400/600, 14px body, 24px headings
- Spacing: 16px card padding, 8px gaps
- Borders: 1px solid #E5E7EB
- Shadows: None (flat design)
- Layout: 1280px max width, 12-column grid

## Extracted Common Patterns
(Consolidate across all 3-5 screenshots)

Colors: #5E6AD2 primary, Zinc neutrals
Typography: Inter 400/600
Style: Flat Design (minimal shadows, 1px borders)
```

---

### Step 3A: Manual Workflow (Google Stitch)

**Upload to Stitch:**

1. Generate `DESIGN_SYSTEM.md` from `notes.md` analysis
2. Upload `DESIGN_SYSTEM.md` to Stitch: `stitch_upload_design_md()`
3. Upload reference screenshots: `stitch_upload_reference_images()`
4. Generate screens: `stitch_generate_screen_from_text("Dashboard with stats")`
5. Stitch outputs match reference style
6. Save results to `references/design/stitch-output/`

---

### Step 3B: Automated Workflow (MCP or AI Code)

**AI reads references folder:**

```javascript
// M04 Step 0 - Component Discovery
const refs = await readDirectory('references/design/inspiration/');
// Files: *.png, notes.md

// Parse extracted patterns
const patterns = await parseDesignNotes('references/design/inspiration/notes.md');
// Extracted: colors, typography, spacing, shadows, style

// Generate DESIGN_SYSTEM.md
const designSystem = generateDesignSystemFromPatterns(patterns);
await writeFile('docs/specs/DESIGN_SYSTEM.md', designSystem);

// Generate components matching reference style
const components = await generateComponents({
  designSystem: 'docs/specs/DESIGN_SYSTEM.md',
  referenceImages: 'references/design/inspiration/*.png',
  screens: SITEMAP.screens
});
```

AI automatically:
1. Reads `notes.md` (extracted patterns)
2. Views screenshots (visual confirmation)
3. Generates `DESIGN_SYSTEM.md` matching references
4. Generates components following extracted style

---

## 🔄 Integration with M04

### In `COMPONENT_REQUIREMENTS.md`:

```markdown
## Design Style Decision

Reference Sources (saved in references/design/inspiration/):
- screenshot-1-dashboard.png - Linear.app dashboard
- screenshot-2-forms.png - Stripe.com form styling
- screenshot-3-buttons.png - Vercel.com button states

Extracted Style: Flat Design (see notes.md analysis)
- 1px borders #E5E7EB
- Minimal shadows (0 1px 2px)
- Inter 400/600 typography
- Zinc neutral palette + #5E6AD2 accent

For detailed implementation → DESIGN_SYSTEM.md (generated from references)
```

### In `DESIGN_SYSTEM.md`:

```markdown
## 0. Design Style Choice

Source: references/design/inspiration/notes.md

Reference Screenshots:
1. Linear.app dashboard - Flat design, minimal shadows
2. Stripe.com landing - High contrast, professional
3. Vercel.com UI - Sharp, fast, monochrome + accent

Extracted Common Patterns:
- Style: Flat Design
- Colors: Zinc scale + single accent
- Typography: Inter 400/600
- Borders: 1px solid, 8px radius
- Shadows: Minimal (0 1px 2px) or none

(Sections 1-6 generated from these patterns)
```

---

## 📸 Screenshot Tips

**Good Screenshots:**
- ✅ Full screen capture (1920×1080 or actual browser window)
- ✅ Multiple UI states visible (buttons, forms, cards)
- ✅ Clear typography (readable font sizes, hierarchy)
- ✅ Color palette visible (backgrounds, text, accents)
- ✅ Real content (not Lorem Ipsum)

**Bad Screenshots:**
- ❌ Partial crops (missing context)
- ❌ Low resolution (can't extract details)
- ❌ Heavily stylized mockups (not production UI)
- ❌ Screenshots with watermarks/overlays
- ❌ Dark mode only (need light mode reference too)

---

## 🎨 What to Extract

From each screenshot, analyze:

1. **Colors**: Use color picker tool (browser DevTools, ColorZilla)
   - Primary brand color
   - Neutral grays (background, surface, border, text)
   - Semantic colors (success, error, warning)

2. **Typography**: Inspect element or estimate
   - Font family (Inter, Roboto, SF Pro)
   - Font weights used (400, 600, 700)
   - Size scale (14px body, 20px h3, 24px h2)
   - Line heights (1.5 relaxed, 1.25 tight)

3. **Spacing**: Measure with browser DevTools
   - Padding (button: 12×24px, card: 24px)
   - Gaps (8px tight, 16px comfortable)
   - Margins (32px between sections)

4. **Borders & Shadows**: Inspect element
   - Border: `1px solid #E5E7EB`
   - Radius: `border-radius: 8px`
   - Shadow: `box-shadow: 0 1px 2px rgba(0,0,0,0.05)`

5. **Style Classification**: Overall aesthetic
   - Flat Design: No shadows, solid colors
   - Glassmorphism: Blur, transparency
   - Brutalist: Hard shadows, sharp edges
   - Minimalist: Whitespace, subtle

---

## 🚫 Anti-Patterns

**Don't do this:**

❌ **Generic references**: "Just make it modern"
- AI generates generic template style
- No specific aesthetic guidance

❌ **Too many styles**: 10 different reference apps
- Conflicting patterns (some flat, some glass)
- AI can't extract consistent style

❌ **No analysis**: Screenshots without notes.md
- AI guesses patterns instead of following analysis
- Inconsistent implementation

**Do this instead:**

✅ **3-5 consistent references**: Linear, Stripe, Vercel (all flat)
✅ **Detailed notes.md**: Extracted colors, typography, spacing
✅ **Clear style classification**: "Flat Design" with characteristics

---

## 📋 Checklist

Before proceeding to DESIGN_SYSTEM.md generation:

- [ ] 3-5 reference screenshots saved to `inspiration/`
- [ ] Screenshots show consistent aesthetic (not conflicting styles)
- [ ] `notes.md` created from `notes-template.md`
- [ ] Each screenshot analyzed (colors, typography, spacing, shadows)
- [ ] Common patterns extracted across all references
- [ ] Style classification determined (Flat/Glass/Brutal/Minimal/Material)
- [ ] Component examples documented (Button, Card, Input)
- [ ] Accessibility validated (contrast ratios checked)

---

## 🔗 Related Templates

- `inspiration-template/notes-template.md` - Copy this to `inspiration/notes.md` to start analysis
- `COMPONENT_REQUIREMENTS_TEMPLATE.md` - Links to design references
- `DESIGN_MD_TEMPLATE.md` - Generated from reference analysis
- `stitch-input/README.md` - Google Stitch prompt guidelines
- `stitch-output/README.md` - Store Stitch generation results

---

## 💡 Tips

**For Solo MVP (Budget <$5K):**
- Use 3 references maximum (faster analysis)
- Choose Flat Design or Minimalist (faster to implement)
- Focus on component style (buttons, forms, cards)
- Skip complex animations (use simple transitions)

**For Client Projects (Budget >$20K):**
- Use 5+ references (thorough analysis)
- Document brand-specific variations
- Include responsive breakpoints from references
- Analyze micro-interactions (hover states, transitions)

**For Design-Forward Projects:**
- Choose Glassmorphism or custom aesthetic
- Document all animation timings
- Include motion principles
- More screenshots needed (6-8)

---

**Next**: Fill `inspiration/` folder → Analyze in `notes.md` → Generate `DESIGN_SYSTEM.md`
