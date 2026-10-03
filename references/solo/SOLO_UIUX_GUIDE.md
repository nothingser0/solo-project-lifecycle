# Solo Developer UI/UX Guide: Efficiency, Accessibility, & Design Freeze

This document provides practical guidelines for solo developers to design professional, ergonomic, and accessible user interfaces without falling into the traps of pixel-pushing or endless visual revisions from clients.

---

## 1. `DESIGN.md` Workflow: Maximum Efficiency for Solo Developers

> **Workflow Note:** This guide defaults to pure Markdown `DESIGN.md` workflow. Google Stitch (AI prototyping tool, launched 2025) remains available but is optional.

Solo developers should never waste time designing twice (first on a vector canvas, then recoding from scratch). Use `DESIGN.md` as the single source of truth for visual decisions across all project scales, from Small to Enterprise.

### 1.1 Three-Step Procedure for a Slop-Free `DESIGN.md` Workflow
1. **Step 1: Lock the Design System (`DESIGN.md`)**:
    - Populate the `DESIGN.md` template upfront with color tokens, typography, radius, spacing, interactive states, and accessibility constraints.
    - Treat this document as the reference for design, implementation, and review to prevent purple gradients, floating cards, or fonts that clash with the product identity.
2. **Step 2: Precision Screen Prompting Formula**:
    - *Prompt Pattern*:
      > *"Build the [Screen Name] interface for the [Role] user. Follow `DESIGN.md`. Display a clean, flat Tailwind-based layout. Displayed data: [List of Real Columns/Fields]. Components: use dense data tables, semantic status badges, and 1px bordered action buttons. Do not use heavy drop-shadows or color gradients."*
3. **Step 3: Connecting Screens into a Real Prototype**:
    - Implement components strictly according to `DESIGN.md`.
    - Connect routing links: `<a href="/target-page">`.
    - Deploy instantly to Vercel or Cloudflare Pages as an interactive live demo for the client.

### 1.2 `DESIGN.md` Implementation Matrix by Scale:
| Scale | Screen Coverage with `DESIGN.md` | Demo Output |
| :--- | :--- | :--- |
| **Small (MVP / Freelance)** | **100% of all pages** in Scope (no reductions) | Instant Live Vercel Staging link |
| **Medium (B2B SaaS)** | **100% of all pages** complete with 5-state variants | Fully interactive Live Web Staging |
| **Large & Enterprise** | **100% of all pages** covering all user roles & permissions | Live Web Staging + WCAG AA Accessibility Compliance Audit |

---

## 2. Solo Engineer Visual "Anti-Slop" Principles

Mature software design is characterized by **readability and interaction clarity**, not gratuitous graphic ornamentation:

1. **The 60-30-10 Rule for Color**:
   - **60%**: Neutral base color (White `#FFFFFF` / Light Gray `#F4F4F5` for backgrounds and containers).
   - **30%**: High-contrast dark typography (Black `#09090B` / Slate `#334155`).
   - **10%**: Client's primary brand accent color (reserved exclusively for primary action buttons, active links, and focus rings).
2. **Text Contrast Compliance (WCAG 2.1 AA)**:
   - Do not use washed-out gray text on white backgrounds that causes eye fatigue.
   - Regular body text contrast ratio to background must be at least **4.5 : 1**.
   - Large text contrast ratio (headings $> 18\text{px}$ bold) must be at least **3.0 : 1**.
3. **Experience Lifesavers: Empty States & Skeleton Loaders**:
   - Never leave a screen completely blank when a new user first signs up.
   - Always provide concise illustrations, guiding copy, and a Call-to-Action button (*"No documents created yet. Click the button below to create your first document."*).
   - Replace generic spinning loading spinners with *Skeleton Loaders* mimicking the card/table layout to eliminate visual jarring (*zero layout shift*).

---

## 3. Client Prototype Walkthrough Protocol

During prototype demo sessions with the **Client's Single PIC**, direct conversations toward functional workflows rather than subjective artistic debates:

### Feedback Steering Tactics:
- **Don't Ask**: *"How does it look? Do you like the colors?"* (This invites wild subjective opinions).
- **The Right Questions**:
  - *"Does this form sequence match your staff's standard operating procedure at the office?"*
  - *"Is the document status on this page clear enough for staff to take their next action?"*

### Handling Subjective Client Comments:
- **Scenario**: *"Could we make the colors pop more, maybe bright red, and make the logo bigger?"*
- **Solo Dev Response**:
  > *"The current palette follows your company's official brand guidelines and passes standard WCAG 2.1 AA accessibility contrast ratios. This is critical to prevent staff eye fatigue during hours of screen work. If you'd like certain actions to stand out more, we can emphasize the primary action buttons without changing the page's neutral foundation."*

---

## 4. Enforcing Design Freeze Protocols

Once the Client's Single PIC approves the prototype workflow in `DESIGN_SPEC.md`:

1. **Lock All Layouts**:
   - Official design status transitions to **FROZEN**.
   - Figma pages or mockup code are designated as the *Approved Baseline*.
2. **Post-Freeze Change Tolerance**:
   - *Free minor revisions*: Text label changes (copywriting), subtle button color tweaks, or minor icon swaps.
   - *Mandatory Change Request (CR)*: Moving database column positions that alter form layouts, adding new pages, overhauling multi-step wizards, or changing navigation architecture.
