# Brand Guidelines: [Product Name]

**Version:** 1.0  
**Date:** [Date]  
**Owner:** [Your Name]

---

## 1. Brand Overview

**Mission Statement:**
[1-2 sentences: Why you exist, what change you want to create]

**Vision:**
[1-2 sentences: Where you want to be in 5 years]

**Brand Personality:**
[3-5 adjectives describing your brand, e.g., "Professional, Approachable, Trustworthy"]

**Target Audience:**
[Who you serve, their pain points, aspirations]

---

## 2. Logo Usage

### 2.1 Primary Logo

**Full Logo (Horizontal)**
```
[Insert PNG/SVG of horizontal logo]
Filename: logo-horizontal.svg
Dimensions: [Width x Height]
```

**When to use:** Website header, marketing materials, presentations

**Minimum Size:**
- Digital: 120px width
- Print: 40mm width

---

### 2.2 Logo Variants

**Icon Only (Square)**
```
[Insert icon-only logo]
Filename: logo-icon.svg
```
**When to use:** Social media profile pictures, favicons, app icons

**Wordmark Only (Text)**
```
[Insert wordmark logo]
Filename: logo-wordmark.svg
```
**When to use:** Tight horizontal spaces (email signatures, footer)

**Monochrome Versions**
```
[Black logo] [White logo]
```
**When to use:**
- Black: Print materials, black & white contexts
- White: Dark backgrounds, photos, hero sections

---

### 2.3 Clear Space & Minimum Size

**Clear Space Rule:**
Maintain clear space around logo equal to height of logo icon (X = icon height)

```
      [X]
   ┌───────┐
[X]│ LOGO  │[X]
   └───────┘
      [X]
```

**Minimum Sizes:**
- **Digital:** 24px height (icon), 120px width (full logo)
- **Print:** 10mm height (icon), 40mm width (full logo)

---

### 2.4 Logo Don'ts (What NOT to Do)

❌ **Don't stretch or skew**
```
[Example: distorted logo]
```

❌ **Don't change colors**
```
[Example: logo in wrong color like red]
```

❌ **Don't add effects** (shadows, gradients, outlines)
```
[Example: logo with drop shadow]
```

❌ **Don't place on busy backgrounds**
```
[Example: logo on complex photo]
```

❌ **Don't rotate**
```
[Example: tilted logo]
```

✅ **Correct Usage**
```
[Example: logo on clean background with proper spacing]
```

---

## 3. Color Palette

### 3.1 Primary Colors

**Brand Primary (Accent Color)**
```
Color: [Name, e.g., "Teal"]
Hex: #0891B2
RGB: rgb(8, 145, 178)
HSL: hsl(191, 91%, 36%)
Tailwind: cyan-600

Usage: CTA buttons, links, primary actions, brand highlights
```

**Neutral Base**
```
Color: White
Hex: #FFFFFF
RGB: rgb(255, 255, 255)
Usage: Backgrounds (light mode)
```

```
Color: Dark (near-black)
Hex: #09090B
RGB: rgb(9, 9, 11)
Tailwind: zinc-950
Usage: Text (light mode), background (dark mode)
```

---

### 3.2 Semantic Colors (Functional)

**Success (Green)**
```
Hex: #10B981
Tailwind: emerald-500
Usage: Success messages, positive states
```

**Warning (Yellow)**
```
Hex: #F59E0B
Tailwind: amber-500
Usage: Warning alerts, caution states
```

**Error (Red)**
```
Hex: #EF4444
Tailwind: red-500
Usage: Error messages, destructive actions
```

**Info (Blue)**
```
Hex: #3B82F6
Tailwind: blue-500
Usage: Informational messages, tips
```

---

### 3.3 Neutral Scale (Grays)

```
Zinc-50:  #FAFAFA (Subtle backgrounds)
Zinc-100: #F4F4F5 (Hover states)
Zinc-200: #E4E4E7 (Borders)
Zinc-300: #D4D4D8 (Disabled states)
Zinc-400: #A1A1AA (Placeholders)
Zinc-500: #71717A (Secondary text)
Zinc-600: #52525B (Body text)
Zinc-700: #3F3F46 (Headings)
Zinc-800: #27272A (Strong emphasis)
Zinc-900: #18181B (Darkest text)
Zinc-950: #09090B (Near-black)
```

**Usage Guide:**
- **Backgrounds:** 50-100
- **Borders:** 200-300
- **Text (light mode):** 600-950
- **Text (dark mode):** 50-400

---

### 3.4 Color Accessibility

**Contrast Ratios (WCAG AA Compliance):**
- **Normal text (16px):** Minimum 4.5:1
- **Large text (24px+):** Minimum 3:1
- **UI elements:** Minimum 3:1

**Tested Combinations:**
| Foreground | Background | Ratio | Pass |
|------------|------------|-------|------|
| #09090B (Zinc-950) | #FFFFFF | 21:1 | ✅ AAA |
| #0891B2 (Cyan-600) | #FFFFFF | 4.52:1 | ✅ AA |
| #71717A (Zinc-500) | #FFFFFF | 4.61:1 | ✅ AA |

**Tool:** Use WebAIM Contrast Checker (https://webaim.org/resources/contrastchecker/)

---

### 3.5 Color Don'ts

❌ **Don't use colors not in palette** (no "creative" colors like purple/pink unless redefined)
❌ **Don't use gradients** (flat colors only per brand style)
❌ **Don't use brand primary for body text** (use Zinc-700 or darker)
❌ **Don't use pure black #000000** (use Zinc-950 #09090B instead)

---

## 4. Typography

### 4.1 Font Families

**Primary Font (UI & Body Text)**
```
Font: Inter
Weights: 400 (Regular), 500 (Medium), 600 (Semibold), 700 (Bold)
License: Open Font License (free)
CDN: Google Fonts
Fallback: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif
```

**Monospace Font (Code, Data, Technical)**
```
Font: JetBrains Mono
Weights: 400 (Regular), 700 (Bold)
License: Apache 2.0 (free)
CDN: Google Fonts
Fallback: "Courier New", monospace
```

---

### 4.2 Type Scale (Desktop)

| Element | Size | Weight | Line Height | Letter Spacing | Example |
|---------|------|--------|-------------|----------------|---------|
| **H1 (Hero)** | 48px (3rem) | 700 | 1.1 | -0.02em | # Main Headline |
| **H2 (Section)** | 36px (2.25rem) | 600 | 1.2 | -0.01em | ## Section Title |
| **H3 (Subsection)** | 24px (1.5rem) | 600 | 1.3 | 0 | ### Subsection |
| **H4 (Card Title)** | 20px (1.25rem) | 600 | 1.4 | 0 | #### Card Heading |
| **Body Large** | 18px (1.125rem) | 400 | 1.6 | 0 | Intro paragraph |
| **Body** | 16px (1rem) | 400 | 1.6 | 0 | Default text |
| **Body Small** | 14px (0.875rem) | 400 | 1.5 | 0 | Captions, metadata |
| **Button** | 16px (1rem) | 600 | 1 | 0 | CTA Text |
| **Label** | 14px (0.875rem) | 500 | 1.4 | 0.01em | Form labels |
| **Code** | 14px (0.875rem) | 400 | 1.5 | 0 | `inline code` |

---

### 4.3 Type Scale (Mobile)

| Element | Size (Mobile) | Adjust |
|---------|---------------|--------|
| **H1** | 36px (2.25rem) | -12px |
| **H2** | 28px (1.75rem) | -8px |
| **H3** | 20px (1.25rem) | -4px |
| **H4** | 18px (1.125rem) | -2px |
| **Body** | 16px (1rem) | No change |

**Responsive CSS:**
```css
h1 {
  font-size: 2.25rem; /* 36px mobile */
}

@media (min-width: 768px) {
  h1 {
    font-size: 3rem; /* 48px desktop */
  }
}
```

---

### 4.4 Typography Best Practices

**Line Length:**
- Optimal: 60-80 characters per line
- Max: 100 characters

**Paragraph Spacing:**
- Between paragraphs: 1.5em (24px for 16px text)

**Hierarchy:**
- Use size, weight, and color to create clear hierarchy
- Don't rely on color alone (accessibility)

**All Caps:**
- Use sparingly (labels, small headings)
- Increase letter-spacing: 0.05-0.1em

---

### 4.5 Typography Don'ts

❌ **Don't use more than 2 font families** (Inter + JetBrains Mono only)
❌ **Don't use font weights not listed** (no Light 300, no Black 900)
❌ **Don't use justified text** (use left-aligned)
❌ **Don't use line-height < 1.4 for body text** (readability)
❌ **Don't use pure black text on white** (use Zinc-700 #3F3F46)

---

## 5. Iconography

### 5.1 Icon Style

**Icon Set:** [Lucide Icons / Heroicons / Phosphor / Custom]
**Style:** Outline (2px stroke), 24×24px base size
**Color:** Inherit from parent text color
**License:** [License type]

**Example Icons:**
```
[Home icon] [User icon] [Settings icon] [Search icon]
```

---

### 5.2 Icon Usage Rules

**Sizes:**
- Small: 16px (inline with text)
- Medium: 24px (default)
- Large: 32px (feature icons)

**Colors:**
- **Default:** Zinc-600 (body text color)
- **Active state:** Cyan-600 (brand primary)
- **Disabled:** Zinc-400

**Spacing:**
- Icon + Text: 8px gap
- Icon only (buttons): 12px padding

---

### 5.3 Custom Icon Guidelines (If Creating New Icons)

**Grid:** 24×24px artboard
**Stroke:** 2px weight
**Corners:** Rounded (2px radius)
**Style:** Consistent line endings (round caps)
**Export:** SVG, optimize with SVGO

❌ **Don't mix outline and filled icons**
❌ **Don't use gradients in icons**
❌ **Don't use icons smaller than 16px** (accessibility)

---

## 6. Imagery & Photography

### 6.1 Photo Style

**Mood:** [e.g., "Professional yet approachable, natural lighting"]
**Subject:** [e.g., "Real people working (not stock photos), Indonesian context"]
**Color Grading:** [e.g., "Slightly desaturated, warm tones"]

**Example:**
```
[Insert 2-3 example photos that match brand style]
```

---

### 6.2 Image Treatment

**Overlay (for text readability):**
```css
background: linear-gradient(
  180deg,
  rgba(9, 9, 11, 0.6) 0%,
  rgba(9, 9, 11, 0.3) 100%
);
```

**Border Radius:** 8px (cards), 12px (hero images)

**Aspect Ratios:**
- Hero: 16:9 or 21:9
- Cards: 4:3 or 1:1
- Thumbnails: 1:1

---

### 6.3 Imagery Don'ts

❌ **Don't use cliché stock photos** (fake handshakes, generic office)
❌ **Don't use heavy filters** (keep natural)
❌ **Don't use images with embedded text** (SEO & i18n issues)
❌ **Don't use images <1200px width** (quality threshold)

---

## 7. UI Components

### 7.1 Buttons

**Primary Button**
```css
Background: #0891B2 (Cyan-600)
Text: #FFFFFF (White)
Font: 16px / 600 weight
Padding: 12px 24px
Border Radius: 6px
Hover: Background → #0E7490 (Cyan-700)
```

**Secondary Button**
```css
Background: Transparent
Text: #0891B2 (Cyan-600)
Border: 1px solid #0891B2
Hover: Background → #F0FDFA (Cyan-50)
```

**Destructive Button**
```css
Background: #EF4444 (Red-500)
Text: #FFFFFF
Hover: Background → #DC2626 (Red-600)
```

---

### 7.2 Form Inputs

```css
Border: 1px solid #E4E4E7 (Zinc-200)
Border Radius: 6px
Padding: 10px 14px
Font: 16px / 400 weight
Focus: Border → #0891B2 (Cyan-600), Shadow: 0 0 0 3px rgba(8, 145, 178, 0.1)
Error: Border → #EF4444 (Red-500)
```

---

### 7.3 Cards

```css
Background: #FFFFFF
Border: 1px solid #E4E4E7 (Zinc-200)
Border Radius: 8px
Padding: 24px
Shadow: 0 1px 3px rgba(0, 0, 0, 0.1)
Hover: Shadow → 0 4px 6px rgba(0, 0, 0, 0.1)
```

---

## 8. Tone of Voice & Messaging

### 8.1 Brand Voice

**We are:**
- [Adjective 1]: [Explanation]
- [Adjective 2]: [Explanation]
- [Adjective 3]: [Explanation]

**Example for Tax SaaS:**
```
We are:
- Trustworthy: We cite regulations, never guess, admit when unsure
- Approachable: Tax is complex, we explain simply without condescension
- Empowering: We help users make informed decisions, not dictate
```

**We are NOT:**
- Overly formal/bureaucratic
- Salesy/pushy
- Condescending/talking down

---

### 8.2 Writing Style

**Language:** [Bahasa Indonesia formal / casual, or English]

**Person:** [First-person "kami", second-person "Anda/kamu"]

**Sentence Structure:**
- Average 15-20 words
- Active voice preferred
- Avoid jargon unless defined

**Punctuation:**
- Use Oxford comma (A, B, and C)
- Avoid exclamation marks except for genuine celebration
- Em dash for emphasis — like this

---

### 8.3 Messaging Examples

| Situation | ❌ Don't Say | ✅ Do Say |
|-----------|-------------|----------|
| Welcome new user | "Welcome aboard!" | "Selamat datang di [Product]! Mari kita mulai." |
| Error message | "Error 500" | "Ada yang salah. Kami sudah tahu dan sedang memperbaiki." |
| Feature unavailable | "This feature is not available" | "Fitur ini belum tersedia di paket Anda. Upgrade untuk akses." |
| Call to action | "Buy now!" | "Mulai gratis 14 hari" |

---

## 9. Social Media Guidelines

### 9.1 Profile Setup

**Profile Picture:** Logo icon (square variant)
**Cover Photo:** Brand color + tagline (1500×500px)
**Bio Template:**
```
[One-line value proposition]
[What you do]
[CTA with link]

Example:
Hitung pajak freelancer dalam 3 menit.
Tax planning assistant pertama untuk freelancer & solopreneur Indonesia.
👉 Coba gratis: [link]
```

---

### 9.2 Post Templates

**Educational Post:**
```
[Hook question or surprising stat]

[3-5 bullet points with emoji]

[CTA or question to audience]

#hashtag1 #hashtag2
```

**Product Update:**
```
🚀 [Feature name] is live!

[What it does in 1 sentence]
[Why it matters]

Try it: [link]
```

---

### 9.3 Visual Guidelines (Social Media)

**Dimensions:**
- Twitter/X: 1200×675px (16:9)
- Instagram: 1080×1080px (1:1)
- LinkedIn: 1200×627px

**Template Style:**
- Background: Brand color or photo with overlay
- Text: White, bold, max 7 words
- Logo: Bottom corner, small

---

## 10. Legal & Compliance

**Trademark:** [Product Name]™ (pending/registered)
**Copyright Notice:** © 2026 [Company Name]. All rights reserved.

**Approved Descriptors:**
- "[Product] is a tax planning assistant..."
- "Powered by [Product]"

**Prohibited Claims:**
- ❌ "Guaranteed tax savings"
- ❌ "100% accurate" (use "legally compliant" instead)
- ❌ "IRS/DJP approved" (unless officially endorsed)

---

## 11. Brand Assets Download

**Download Link:** [Dropbox/Google Drive link to brand kit]

**Contents:**
- Logo (SVG, PNG variants)
- Color palette (Sketch/Figma file)
- Font files (woff2)
- Icon set
- Social media templates (Canva/Figma)

---

**Questions? Contact:** [Brand owner email]
**Last Updated:** [Date]
**Version History:** [Link to changelog]
