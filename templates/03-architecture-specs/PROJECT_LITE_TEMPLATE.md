# PROJECT_LITE.md (Fast-Track Unified Specification)

> Lean unified specification document for **Small-Scale (Solo Portfolio, Personal Tool, or 1–4 Week Client Freelance)** projects.
> Combines Module 01 (Idea), Module 02 (Scope), Module 03 (Commercial), and Module 05 (Technical) into a single reference document.
> **ABSOLUTE RULE**: For all Web and Mobile projects, **Module 04 (Interactive Prototype UI/UX) REMAINS STRICTLY MANDATORY** to prevent UI from becoming "AI Slop" and to provide clients with a real interactive prototype. Module 04 may only be skipped if the project is purely backend/CLI/automation with no user interface.

---

## Fast-Track Execution Checklist (1-4 Week MVP)

**Mandatory Execution Order:**

- [ ] **Step 1**: Fill `PROJECT_LITE.md` (Idea + Scope + Commercial + DB Schema) — 1 unified file
- [ ] **Step 2**: **MANDATORY — Execute Module 04 Interactive Prototype (MUST NOT BE SKIPPED for Web/Mobile/Desktop GUI!)**
  - [ ] `DESIGN.md` generated and uploaded to Prototype
  - [ ] All screens generated (even 3-screen MVPs must have all screens generated)
  - [ ] Design Freeze self-approved (or client approval if working with a client)
- [ ] **Step 3**: Jump directly to Module 06 Development (skip formal PRD/FSD since they are already covered in PROJECT_LITE.md)

**Anti-Forget Protocol:**
> If an AI agent attempts to skip Module 04 citing "fast-track" or "small MVP", **MUST REJECT**. Fast-track only merges documentation, it does not skip the UI/UX phase.

---

## 1. Project Metadata & Elevator Pitch
- **Project Name**: [Application / System Name]
- **Project Type**: [Solo Portfolio / Personal Utility / Client Freelance]
- **Client / Sponsor**: [Client Company Name OR "Self-Initiated / Independent Developer"]
- **Client Single PIC**: [Client PIC Contact OR "Self (Sole Decision Maker)"]
- **Solo Developer**: [Your Name]
- **Target Release**: [YYYY-MM-DD] (Maximum 2–4 Weeks)
- **Elevator Pitch**: *For [Target Users] who experience [Problem], this system provides [Core Solution] that processes data through [3-Step Core Loop].*

---

## 2. Lean Scope Boundaries (In-Scope vs Out-of-Scope)

### Features to Build (In-Scope MVP - Maximum 3–5 Core Features)
1. **[Feature 1]**: [Core functionality description]
2. **[Feature 2]**: [Core functionality description]
3. **[Feature 3]**: [Encrypted document storage / basic payment integration]

### Officially EXCLUDED / Deferred Features (Out-of-Scope)
1. No complex graphic analytics dashboards (CSV export is sufficient if data is needed).
2. No multi-language or multi-organization/tenant integration (single-tenant).
3. Any new feature requests outside the list above must go through a Phase 2 proposal or paid Change Request.

---

## 3. Commercial Commitments (Client Project) OR Self-Runway (Solo Project)

### For Solo Portfolio / Personal Utility:
- **Commercial Status**: `[WAIVED / SELF-FUNDED]`
- **Self-Budget / Hosting Cost**: Rp [X] / month (e.g. Free Tier Vercel + Supabase)
- **Single PIC**: Sole Developer (No external approval bottlenecks)

### For Client Commercial Project (If Applicable):
- **Total Project Value**: [Currency/Amount]
- **Payment Milestones**: 50% Down Payment upfront, 50% Final upon UAT pass & BAST.
- **Client Response SLA**: Client must provide testing feedback within **3 business days** maximum.

### Single PIC Authority (Decision Power)

- **Designated Single PIC**: [Client PIC Name from Section 1] has **exclusive decision authority** for:
  - Scope changes and feature prioritization
  - UAT approval and bug severity classification
  - Final acceptance and payment authorization

- **Authority Enforcement**:
  - Only the designated Single PIC can approve scope changes or sign-off deliverables
  - Requests from non-PIC stakeholders (colleagues, management) are **invalid** unless routed through the Single PIC
  - If PIC changes, client must provide written notification with new PIC contact details

- **Conflict Resolution**: If multiple stakeholders provide conflicting requirements, developer will defer to Single PIC's decision only

**Rationale**: This clause prevents scope creep from multiple voices and ensures clear accountability.

---

## 4. Brand Identity, UI Design Tokens & Screen Prompts

### 4.1 Minimal Brand & Logo Brief
- **Brand Name / Wordmark**: [Product Name / Wordmark]
- **Brand Vibe Keywords**: [e.g., Clean, Technical, Fast, Trustworthy]
- **Primary Accent Color**: `#HEX` (e.g., `#10B981` Emerald / `#0891B2` Cyan)
- **Neutral Foundation**: Zinc Scale (Background: `#09090B` Dark / `#FAFAFA` Light)
- **Logo Asset Path**: `public/logo.svg` (or placeholder text icon)
- **Logo Prompt (AI Generator)**:
  > *"Minimalist vector app icon for [Product Name], [Core Functionality]. Simple clean geometric silhouette, flat colors, no 3D gradients, centered 1:1."*

### 4.2 Visual Inspiration & Moodboard Reference
- **Reference 1**: [URL of visual benchmark, e.g. Linear.app, Vercel, Supabase]
- **Reference 2**: [URL of second visual benchmark]
- **Notes & Typography**: Inter (Body 400/600), JetBrains Mono (Code/Numbers). Documented in `docs/design/inspiration/notes.md`.

### 4.3 Screen Prompts & Layout Architecture
- **Navigation Map**: Documented in `docs/specs/SITEMAP.md` (3–5 screens max: SCR-01 to SCR-03).
- **Prompt Location**: `docs/design/prompts/` (contains standalone prompt per screen for v0.dev / Google Stitch / Cursor).
- **Component Storage**: Save exported AI UI components into `docs/design/screens/`.

### 4.4 Design Freeze & Anti-Slop Sign-Off
- **Mobile Input Ergonomics**: All form inputs are $\ge 16$px (`text-base`) to prevent iOS Safari auto-zoom.
- **Touch Targets**: All buttons and interactive triggers meet $\ge 44\text{px} \times 44\text{px}$.
- **Contrast Ratio**: Text contrast $\ge 4.5:1$ against canvas background (WCAG 2.2 AA).
- **Design Freeze Status**: `[FROZEN / APPROVED]` (UI layout locked; zero structural rework during coding).

---

## 5. Lean Technical Blueprint

- **Selected Tech Stack**: [Example: Next.js + PostgreSQL / Flutter + Supabase / FastAPI + SQLite]
- **Database Schema (Core Tables)**:
```sql
-- Users & Sessions Table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(30) NOT NULL DEFAULT 'staff',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Core Transactions / Documents Table
CREATE TABLE core_entities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    title VARCHAR(255) NOT NULL,
    payload JSONB NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'draft',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

- **Core API Routes**:
  - `POST /api/v1/auth/login` (Login & Set HttpOnly Cookie)
  - `GET /api/v1/entities` (Fetch authenticated data list)
  - `POST /api/v1/entities` (Create new Zod-validated data)

---

## 6. Summary Agreement of the Parties

By approving this document (via signature or written email confirmation), work officially commences once the 50% Down Payment (DP) is received by the Developer.

- Approved by Client Single PIC: **[Client PIC Name]** (Date: [YYYY-MM-DD])
- Validated by Solo Developer: **[Your Name]** (Date: [YYYY-MM-DD])
