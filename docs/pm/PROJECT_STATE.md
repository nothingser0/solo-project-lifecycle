# Project State & Lifecycle Handoff

> **Purpose**: Single source of truth for project lifecycle state, module completion, gate outcomes, cross-document consistency, and open assumptions.
> **Location**: `docs/pm/PROJECT_STATE.md`
> **Instruction for AI Agents**: Read this file first when starting or resuming a session to immediately re-establish context and current gate status.
>
> ℹ️ **FRAMEWORK REPOSITORY NOTICE**: Inside this skill framework repo, this file serves as a reference starter template. When scaffolding a user project, instantiate this file in the user's project directory and track active state there.

---

## 1. Project Metadata

- **Project Name**: [Project Name]
- **Current Active Module**: M00 (Product Discovery & Strategy)
- **Lifecycle Path**: Solo SaaS (Self-Initiated Product)
- **Complexity Scale**: Medium (4–10 core features / 8–15 Must-Haves)
- **Primary Tech Stack**: Next.js 15 + Supabase + Tailwind CSS
- **Project Language**: English / Indonesian
- **Last Active Session Date**: [YYYY-MM-DD]
- **Session Operator**: Solo Dev & AI Agent

---

## 2. Lifecycle Module Progress & Gate Status

*Legend: `NOT_STARTED` | `IN_PROGRESS` | `PENDING_PRIMARY_RESEARCH` | `PROVISIONAL` | `PENDING_APPROVAL` | `PASS` | `CONDITIONAL_GO` | `PIVOT` | `KILL` | `WAIVED`*

> ℹ️ **GATE EVALUATION RULE WITH PENDING PRIMARY RESEARCH**:
> If human user discovery (interviews, surveys, smoke test waitlists) has not yet been executed, Gate 0 MUST be set to **`PENDING_PRIMARY_RESEARCH`**.
> AI agents are strictly prohibited from evaluating this gate as `PASS` using simulated or synthetic numbers.

### Active Gate Status: `PENDING_PRIMARY_RESEARCH`

**Primary Research Staging & Readiness**:
- **Interview Guide**: Staged at `docs/pm/INTERVIEW_GUIDE.md` (Target: 5 interviews for M00-lite, 10 for Standard)
- **Survey Instrument**: Staged at `docs/pm/USER_RESEARCH_REPORT.md` (Target: ≥30 / 50 responses)
- **Behavioral Smoke Test**: Staged waitlist landing page (Target: ≥5% conversion from ≥100 visits)
- **Requirement Matrix**: Linked to `docs/pm/REQUIREMENT_MATRIX.md`
- **Verification Plan**: Linked to `docs/pm/VERIFICATION_PLAN.md`

---

| Module ID | Module Name | Required Artifact | Gate Criteria | Gate Status | Completion Date |
|:----------|:------------|:------------------|:--------------|:-----------:|:----------------|
| **M00 / M00-lite** | Product Discovery & Strategy | `docs/pm/MARKET_RESEARCH.md` or `docs/pm/M00_LITE.md` | Intent-to-buy $\ge 30\%$ / Waitlist validation | `PENDING_PRIMARY_RESEARCH` | — |
| **M01** | Idea & Feasibility | `docs/pm/IDEA_BRIEF.md` | Feasibility score $\ge 3.5/5.0$, no dimension $<3.0$ | `NOT_STARTED` | — |
| **M02** | Discovery & Scope | `docs/pm/SCOPE_STATEMENT.md` | MoSCoW locked, RBAC defined, 0 ambiguous P0s | `NOT_STARTED` | — |
| **M03** | Legal SOW & Charter | `docs/pm/SOW_CONTRACT.md` (or `contracts/`) | Commercial Gate: DP received, Single PIC locked | `WAIVED` (Solo SaaS) | — |
| **M04** | UI/UX & Information Architecture | `docs/specs/SITEMAP.md`, `DESIGN.md` | SITEMAP multi-role coverage, contrast $\ge 4.5:1$ | `NOT_STARTED` | — |
| **M05** | Architecture Specs & PRD/FSD | `docs/specs/PRD.md`, `docs/specs/FSD.md` | Schema, APIs, lockfile versions pinned | `NOT_STARTED` | — |
| **M06** | Development Execution | Root harness files deployed, `TODO.md` | 100% TODO completed, unit tests pass | `NOT_STARTED` | — |
| **M07** | Quality Assurance (SIT/Security) | `docs/qa/SIT_REPORT.md` | P0/P1 bugs = 0, security audit clean | `NOT_STARTED` | — |
| **M08** | Data Migration & Seeding | `docs/data/RECONCILIATION_REPORT.md` | Row counts match, data hash verified | `NOT_STARTED` | — |
| **M09** | Client UAT & Validation | `docs/qa/UAT_SIGNOFF.md` | Validation Gate: Client UAT signed | `NOT_STARTED` | — |
| **M10** | Production Deployment | `docs/ops/DEPLOYMENT_REPORT.md` | Live DNS/SSL active, healthcheck 200 | `NOT_STARTED` | — |
| **M11** | Handover & BAST | `docs/pm/BAST.md` (or `contracts/`) | Handover Gate: 100% payment, BAST signed | `WAIVED` (Solo SaaS) | — |
| **M12** | Warranty & Maintenance Ops | `docs/ops/WARRANTY_POLICY.md` | SLA terms active, runbook verified | `NOT_STARTED` | — |
| **M13** | Product Growth & Iteration | `docs/pm/METRICS_REPORT.md` | North Star Metric telemetry instrumented | `NOT_STARTED` | — |

---

## 3. Cross-Document Consistency Matrix

*Verify bidirectional alignment between all generated artifacts before proceeding to subsequent modules:*

| Upstream Source Document | Downstream Target Document | Consistency Audit Check | Audit Status | Last Verified Date |
|:-------------------------|:---------------------------|:------------------------|:------------:|:-------------------|
| `SCOPE_STATEMENT.md` (P0/P1 features) | `SITEMAP.md` (Screens) | Every in-scope feature maps to at least 1 screen; 0 orphan screens | [PENDING_M02] | — |
| `SCOPE_STATEMENT.md` (RBAC Matrix) | `SITEMAP.md` & `COMPONENT_REQUIREMENTS.md` | All declared roles have corresponding route guards & component visibility states | [PENDING_M02] | — |
| `SCOPE_STATEMENT.md` (Features) | `PRD.md` & `FSD.md` | Exact parity in feature numbering (F-01..F-NN) and acceptance criteria | [PENDING_M02] | — |
| `FSD.md` (Data Models) | Database Schema / Migrations | Table names, relations, enum variants, and indexes match FSD exactly | [PENDING_M05] | — |
| `PRD.md` & `FSD.md` | `docs/harness-root/TODO.md` | 100% of P0/P1 features are mapped into sprint tasks in TODO.md | [PENDING_M05] | — |
| `FSD.md` (Pinned Versions) | `package.json` / Lockfile | Pinned packages match auto-check script output (`./scripts/check-package-versions.sh`) | [PENDING_M05] | — |

---

## 4. Active Assumption Register

*Highest risk assumptions being tested:*

| Assumption ID | Hypothesis | Confidence | Test Method | Kill Threshold | Current Outcome |
|:--------------|:-----------|:----------:|:------------|:------------------------------|:----------------|
| **ASM-01** | Target users experience quantifiable monthly recurring loss | 🔶 | 5 Deep user interviews (Group A & B) | <2 of 5 respondents confirm loss | `PENDING_PRIMARY_RESEARCH` |
| **ASM-02** | Target users will pay ≥Rp 100k/mo for automated cloud sync | 🔶 | Landing page waitlist with pricing anchor | Waitlist conversion < 3% from 100 visits | `PENDING_PRIMARY_RESEARCH` |
| **ASM-03** | Core MVP workflow operable by non-technical staff without training | 🔶 | Clickable wireflow usability session | >50% users fail unassisted task | `PENDING_M04` |

---

## 5. Active Blockers & Critical Decisions

- [ ] **Blocker 1**: Awaiting human user interviews & live waitlist traffic to evaluate Gate 0.
  - *Owner*: User / Founder
  - *Unblocking Action*: Conduct 5 customer discovery interviews using `docs/pm/INTERVIEW_GUIDE.md`.
- [ ] **Blocker 2**: None.

---

## 6. Immediate Next Action for Resuming Session

1. **Current Step**: Execute customer discovery interviews using `docs/pm/INTERVIEW_GUIDE.md`.
2. **Target Deliverable**: Log interview findings into `docs/pm/M00_LITE.md` (or `docs/pm/USER_RESEARCH_REPORT.md`).
3. **Turn-Stopping Confirmation Prompt**:
   > *"Module 00 is staged in state `PENDING_PRIMARY_RESEARCH`. Conduct 5 user interviews with `docs/pm/INTERVIEW_GUIDE.md` and confirm findings to advance Gate 0."*
