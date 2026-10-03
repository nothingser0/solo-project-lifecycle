# Design References

> **Purpose**: Store design inspiration, competitor screenshots, style guides, and reference materials for this project.

## What to Put Here

### 1. Competitor Analysis Screenshots
- `competitors/[company-name]/`
  - Landing page layouts
  - Dashboard UIs
  - Navigation patterns
  - Form designs
  - Pricing tables

### 2. Design Inspiration
- `inspiration/`
  - Dribbble/Behance favorites
  - Awwwards examples
  - Industry-specific patterns
  - Color palette references

### 3. Brand Assets (If Provided)
- `brand/`
  - Logo files (SVG, PNG)
  - Brand guidelines PDF
  - Color palette hex codes
  - Typography specimen
  - Icon set

### 4. User Research Artifacts
- `user-research/`
  - User interview recordings/transcripts
  - Survey results
  - Usability test videos
  - Heatmaps/analytics screenshots

### 5. Wireframes & Sketches
- `wireframes/`
  - Hand-drawn sketches (photos)
  - Low-fidelity wireframes
  - User flow diagrams
  - Information architecture maps

### 6. Design System References
- `design-systems/`
  - Material Design guidelines
  - Tailwind CSS examples
  - Shadcn/ui patterns
  - Component library docs

## Folder Structure Example

```
references/
├── competitors/
│   ├── company-a/
│   │   ├── landing.png
│   │   ├── dashboard.png
│   │   └── pricing.png
│   └── company-b/
│       └── ...
├── inspiration/
│   ├── color-palettes/
│   ├── typography/
│   └── layouts/
├── brand/
│   ├── logo.svg
│   ├── brand-guidelines.pdf
│   └── color-palette.png
├── user-research/
│   ├── interview-01.mp4
│   ├── survey-results.xlsx
│   └── usability-test-notes.md
├── wireframes/
│   ├── sitemap.png
│   ├── user-flow.png
│   └── sketches/
└── design-systems/
    ├── tailwind-examples/
    └── shadcn-components/
```

## Usage in Design Process

Reference these materials when:
- Creating DESIGN.md (Module 04)
- Writing Stitch prompts (anti-slop constraints)
- Validating component patterns
- Resolving design decisions
- Presenting to stakeholders

## Git Considerations

**Do NOT commit:**
- ❌ Copyrighted competitor screenshots (fair use risk)
- ❌ Client confidential materials (NDAs)
- ❌ Large video files (>50MB)

**OK to commit:**
- ✅ Public design inspiration links (markdown file with URLs)
- ✅ Your own wireframes/sketches
- ✅ Client-provided brand assets (with permission)
- ✅ Anonymized user research data

**Alternative**: Use `.gitignore` to exclude this folder entirely, store references in cloud storage (Google Drive, Notion).

---

**Created**: 2026-10-03  
**Purpose**: Project-specific design reference library
