# Project State & Lifecycle Handoff

> **Purpose**: Single source of truth for project lifecycle state, module completion, gate outcomes, cross-document consistency, and open assumptions.
> **Location**: `docs/pm/PROJECT_STATE.md`
> **Instruction for AI Agents**: Read this file first when starting or resuming a session to immediately re-establish context and current gate status.

---

## 1. Project Metadata

- **Project Name**: [Project Name]
- **Current Active Module**: [e.g., M00 / M01 / M02 / M04 / M05 / M06]
- **Scale**: [small | medium | large | enterprise]
- **Delivery**: [solo | portfolio | client | internal]
- **Lifecycle Path**: [Small Fast-Track / Solo SaaS / Client Commercial / Enterprise]
- **Primary Tech Stack**: [e.g., Next.js 15 + Supabase + Tailwind CSS]
- **Project Language**: [Indonesian / English]
- **Last Active Session Date**: [YYYY-MM-DD]
- **Session Operator**: [Solo Dev / AI Agent / Tech Lead]

---

## 2. Lifecycle Module Progress & Gate Status

*Legend: `NOT_STARTED` | `IN_PROGRESS` | `PENDING_PRIMARY_RESEARCH` | `PROVISIONAL` | `PENDING_APPROVAL` | `PASS` | `CONDITIONAL_GO` | `PIVOT` | `KILL` | `WAIVED`*

> ℹ️ **GATE EVALUATION RULE WITH PENDING PRIMARY RESEARCH**:
> If human user discovery (interviews, surveys, smoke test waitlists) has not yet been executed, Gate 0 MUST be set to **`PENDING_PRIMARY_RESEARCH`**.
> AI agents are strictly prohibited from evaluating this gate as `PASS` using simulated or synthetic numbers.

### Active Gate Status: `[PENDING_PRIMARY_RESEARCH / PROVISIONAL / PASS / CONDITIONAL_GO / PIVOT / KILL / WAIVED]`

**Primary Research Staging & Readiness**:
- **Interview Guide**: Staged at `docs/pm/USER_RESEARCH_REPORT.md` (Target: [5 / 10 / 15] interviews)
- **Survey Instrument**: Staged at `[Link Tally/Google Forms / PENDING]` (Target: [30 / 50] responses)
- **Behavioral Smoke Test**: Staged at `[Waitlist URL / PENDING]` (Target: $\ge 5\%$ conversion)
- **Requirement Matrix**: Linked to `docs/pm/REQUIREMENT_MATRIX.md`
- **Verification Plan**: Linked to `docs/pm/VERIFICATION_PLAN.md`

---

| Module ID | Module Name | Required Artifact | Gate Criteria | Gate Status | Completion Date |
|:----------|:------------|:------------------|:--------------|:-----------:|:----------------|
| **M00 / M00-lite** | Product Discovery & Strategy | `docs/pm/MARKET_RESEARCH.md` or `docs/pm/M00_LITE.md` | Intent-to-buy $\ge 30\%$ / Waitlist validation | [Status] | [YYYY-MM-DD] |
| **M01** | Idea & Feasibility | `docs/pm/IDEA_BRIEF.md` | Feasibility score $\ge 70/100$, 0 fatal blockers | [Status] | [YYYY-MM-DD] |
| **M02** | Discovery & Scope | `docs/pm/SCOPE_STATEMENT.md` | MoSCoW locked, RBAC defined, 0 ambiguous P0s | [Status] | [YYYY-MM-DD] |
| **M03** | Legal SOW & Charter | `docs/pm/SOW_CONTRACT.md` (or `contracts/`) | Commercial Gate: DP received, Single PIC locked (WAIVED for Solo SaaS) | [Status] | [YYYY-MM-DD] |
| **M04** | UI/UX & Information Architecture | `docs/specs/SITEMAP.md`, `DESIGN.md` | SITEMAP multi-role coverage, contrast $\ge 4.5:1$ | [Status] | [YYYY-MM-DD] |
| **M05** | Architecture Specs & PRD/FSD | `docs/specs/PRD.md`, `docs/specs/FSD.md` | Schema, APIs, lockfile versions pinned | [Status] | [YYYY-MM-DD] |
| **M06** | Development Execution | Root harness files deployed, `TODO.md` | 100% TODO completed, unit tests pass | [Status] | [YYYY-MM-DD] |
| **M07** | Quality Assurance (SIT/Security) | `docs/qa/SIT_REPORT.md` | P0/P1 bugs = 0, security audit clean | [Status] | [YYYY-MM-DD] |
| **M08** | Data Migration & Seeding | `docs/data/RECONCILIATION_REPORT.md` | Row counts match, data hash verified | [Status] | [YYYY-MM-DD] |
| **M09** | Client UAT & Validation | `docs/qa/UAT_SIGNOFF.md` | Validation Gate: Client UAT signed | [Status] | [YYYY-MM-DD] |
| **M10** | Production Deployment | `docs/ops/DEPLOYMENT_REPORT.md` | Live DNS/SSL active, healthcheck 200 | [Status] | [YYYY-MM-DD] |
| **M11** | Handover & BAST | `docs/pm/BAST.md` (or `contracts/`) | Handover Gate: 100% payment, BAST signed (WAIVED for Solo SaaS) | [Status] | [YYYY-MM-DD] |
| **M12** | Warranty & Maintenance Ops | `docs/ops/WARRANTY_POLICY.md` | SLA terms active, runbook verified | [Status] | [YYYY-MM-DD] |
| **M13** | Product Growth & Iteration | `docs/pm/METRICS_REPORT.md` | North Star Metric telemetry instrumented | [Status] | [YYYY-MM-DD] |

---

## 3. Cross-Document Consistency Matrix

*Verify bidirectional alignment between all generated artifacts before proceeding to subsequent modules:*

| Upstream Source Document | Downstream Target Document | Consistency Audit Check | Audit Status | Last Verified Date |
|:-------------------------|:---------------------------|:------------------------|:------------:|:-------------------|
| `SCOPE_STATEMENT.md` (P0/P1 features) | `SITEMAP.md` (Screens) | Every in-scope feature maps to at least 1 screen; 0 orphan screens | [OK / Drift Detected] | [YYYY-MM-DD] |
| `SCOPE_STATEMENT.md` (RBAC Matrix) | `SITEMAP.md` & `COMPONENT_REQUIREMENTS.md` | All declared roles have corresponding route guards & component visibility states | [OK / Drift Detected] | [YYYY-MM-DD] |
| `SCOPE_STATEMENT.md` (Features) | `PRD.md` & `FSD.md` | Exact parity in feature numbering (F-01..F-NN) and acceptance criteria | [OK / Drift Detected] | [YYYY-MM-DD] |
| `FSD.md` (Data Models) | Database Schema / Migrations | Table names, relations, enum variants, and indexes match FSD exactly | [OK / Drift Detected] | [YYYY-MM-DD] |
| `PRD.md` & `FSD.md` | `docs/harness-root/TODO.md` | 100% of P0/P1 features are mapped into sprint tasks in TODO.md | [OK / Drift Detected] | [YYYY-MM-DD] |
| `FSD.md` (Pinned Versions) | `package.json` / Lockfile | Pinned packages match auto-check script output (`./scripts/check-package-versions.sh`) | [OK / Drift Detected] | [YYYY-MM-DD] |

---

## 4. Active Assumption Register

*Highest risk assumptions being tested:*

| Assumption ID | Hypothesis | Confidence | Test Method | Kill Threshold | Current Outcome |
|:--------------|:-----------|:----------:|:------------|:------------------------------|:----------------|
| ASM-01 | [Hypothesis description] | [✅/🔶/❓] | [Test method] | [Kill criteria] | [Open / Validated / Disproven] |
| ASM-02 | [Hypothesis description] | [✅/🔶/❓] | [Test method] | [Kill criteria] | [Open / Validated / Disproven] |

---

## 5. Active Blockers & Critical Decisions

- [ ] **Blocker 1**: [Description of blocker, e.g., Awaiting user survey responses for M00 validation]
  - *Owner*: [User / Agent]
  - *Unblocking Action*: [What must be completed to proceed]
- [ ] **Blocker 2**: [None]

---

## 6. Immediate Next Action for Resuming Session

1. **Current Step**: [e.g., Run `./scripts/validate-gate.sh M02`]
2. **Target Deliverable**: [e.g., Draft `docs/specs/SITEMAP.md` using `templates/02-design/SITEMAP_TEMPLATE.md`]
3. **Turn-Stopping Confirmation Prompt**:
   > *"Module [XX] completed. Review artifacts in `docs/pm/` and approve proceeding to Module [YY]."*
