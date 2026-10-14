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
- **Delivery Model**: [Bespoke Freelance / Academic Joki / On-Premise / Internal Tool / Open-Source / Solo SaaS]
- **Monetization**: [Fixed Price / Free & Open-Source / Milestone Termin / Recurring / Self-Funded]
- **Client Single PIC**: [Client PIC Contact OR "Self (Sole Decision Maker)"]
- **Solo Developer**: [Your Name]
- **Target Release**: [YYYY-MM-DD] (Maximum 2–4 Weeks)
- **Industry Archetype**: [Acronym] - [Full Archetype Name] (from references/taxonomy/SYSTEM_ARCHETYPES_250.md)
- **Catalog Benchmark**: #[1-1000] - [Catalog Entry Name] (from references/taxonomy/PROJECT_CATALOG_1000.md)
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


---

## 2.1 Riskiest Assumption Test (RAT) & Validation Razor

*Identify the top 1–2 premises that would kill this small project if false. Test before building complex logic:*

| ID | Core Hypothesis | Test Method (<1 Day) | Pass Threshold | Outcome / Evidence |
|:---|:----------------|:---------------------|:---------------|:-------------------|
| **ASM-01** | [e.g., Users will input data manually daily] | [5 user interviews / paper test] | ≥ 3 of 5 confirm | [✅ PASS / ⏳ PENDING / ❌ FAIL] |
| **ASM-02** | [e.g., Free tier Supabase / Vercel is sufficient] | [Architecture spike POC] | Zero paid addons needed | [✅ PASS / ⏳ PENDING / ❌ FAIL] |

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
- **Mobile Input Ergonomics**: All form inputs are ≥ 16px (`text-base`) to prevent iOS Safari auto-zoom.
- **Touch Targets**: All buttons and interactive triggers meet ≥ 44px × 44px.
- **Contrast Ratio**: Text contrast ≥ 4.5:1 against canvas background (WCAG 2.2 AA).
- **Design Freeze Status**: `[FROZEN / APPROVED]` (UI layout locked; zero structural rework during coding).

---

## 5. Lean Technical Blueprint

> **Section 5 is the Small-path substitute for PRD/FSD.** `validate-gate.sh M05` verifies three
> things here that M06 depends on: the locked stack backed by 8 real answers, the security
> blueprint (STEP 5), and the Module 04 handoff strategy (STEP 5) — which M06 STEP 0 parses.

- **Selected Tech Stack**: [Example: Next.js + PostgreSQL / Flutter + Supabase / FastAPI + SQLite]

Stack Decision LOCKED: [Next.js / Laravel / Django / Go / SvelteKit / FastAPI]
Stack-Locked-by: [name of the human who chose it — the AI agent may not choose]

### Tech Stack Discovery Answers (8 — human input, gate-enforced)

> `validate-gate.sh M05` fails if `Stack Decision LOCKED:` appears without these 8 answers
> recorded. The agent asks; the human answers. Record each answer verbatim.

- Q1 Team Expertise: [answer]
- Q2 Database Experience: [answer]
- Q3 Deployment Topology: [answer]
- Q4 Expected Scale (Year 1): [answer]
- Q5 Data Model Characteristics: [answer]
- Q6 DevOps Complexity Tolerance: [answer]
- Q7 Critical Feature Priority: [answer]
- Q8 Compliance Requirements: [answer]

## Framework Versions (Pinned):
- [Package/Framework Name]: [x.y.z]
- [Runtime/DB Client]: [x.y.z]

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

### Security Blueprint (STEP 5 — all four required; gate-checked)

- **Data at rest**: AES-256-GCM envelope encryption for [sensitive columns: e.g. `payload`, PII fields]; keys held outside the repo.
- **Password hashing**: Argon2id (memory-hard; never MD5/SHA-1/bcrypt-cost<10).
- **Web hardening**: OWASP Top 10 mitigations — input validation on every write path, output encoding, CSRF token, `HttpOnly`+`Secure`+`SameSite` cookies, no verbose error leakage.
- **Rate limiting**: [login 5/min per IP, mutating endpoints 60/min per user].
- **Personal data**: [UU PDP — consent capture, deletion right, audit log] or `N/A (no personal data)`.

### Module 04 Handoff Strategy (STEP 5 — gate-checked; parsed by M06 STEP 0)

**Compatibility Level**: Level [1 / 2 / 3 / 4] — pick ONE. This is the same 1–4 scale as
`FSD_TECHNICAL_TEMPLATE.md` §2.1 (do not invent a second mapping):

| Level | Situation | Conversion Approach |
| :--- | :--- | :--- |
| **1** | Static HTML / click-dummy (Workflow A) | Translate markup into components; map tokens |
| **2** | AI-generated prototype code, same framework (Workflow B) | Clean and wire the generated components; refactor to conventions |
| **3** | Figma/designer handoff (Workflow C) | Extract components from the design; rebuild on the frozen layout |

**Conversion Plan**: 1. Extract [n] components from `COMPONENT_REQUIREMENTS.md` → 2. Map `DESIGN.md` tokens to [Tailwind/theme config] → 3. Rebuild screens in [framework], static first, then data-backed.
**Estimated Conversion Time**: [X days]

### Core API Routes (STEP 4)

  - `POST /api/v1/auth/login` (Login & Set HttpOnly Cookie)
  - `GET /api/v1/entities` (Fetch authenticated data list)
  - `POST /api/v1/entities` (Create new Zod-validated data)

> Medium/Large use `docs/specs/FSD.md` instead: a full endpoint matrix (**≥10 endpoint
> headings**, gate-enforced) with request/response schemas and idempotency headers for
> financial POSTs.

---

## 6. Technical Sign-Off & Summary Agreement of the Parties

> `validate-gate.sh M05` **requires** the sign-off below to be filled with a real human name and a
> real date before the gate passes. **The AI agent may never sign or self-approve** (docs/AUTHORITY.md);
> a human reviewer does. Solo/portfolio/internal delivery completes the *Validated by Solo Developer*
> line; client delivery must also complete the *Client Single PIC* line.

**Approved by**: [Human reviewer name — the person who reviewed the architecture]
**Approved on**: [YYYY-MM-DD]
**Validated by Solo Developer**: [Developer name] (Date: [YYYY-MM-DD])
**Approved by Client Single PIC** (client delivery only): [Client PIC name] (Date: [YYYY-MM-DD])

By approving this document (via signature or written email confirmation), work officially commences once the 50% Down Payment (DP) is received by the Developer.
