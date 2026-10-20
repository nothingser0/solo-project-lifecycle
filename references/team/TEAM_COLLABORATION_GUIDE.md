# Team Collaboration & Agency Handoff Guide

> **Target**: Software development agencies, multi-developer teams, and multi-agent AI environments scaling beyond solo development.
> **Standard**: Preserves lifecycle discipline, gate stopping authority, and cross-discipline handoffs across Product Management, Design, Engineering, and Quality Assurance.

---

## 1. Role-to-Artifact Responsibility Matrix (RACI)

In multi-person teams or multi-agent swarms, assign explicit ownership over lifecycle deliverables:

| Lifecycle Phase | Primary Artifact | Responsible (R) | Accountable (A) | Consulted (C) | Informed (I) |
|:----------------|:-----------------|:----------------|:----------------|:--------------|:-------------|
| **M00 Discovery** | `MARKET_RESEARCH.md`, `M00_LITE.md` | Product Manager | Founder / Client | Tech Lead | Engineering Team |
| **M01 Feasibility** | `IDEA_BRIEF.md` | PM & Tech Lead | Tech Lead | System Architect | Client / Founder |
| **M02 Scope Lock** | `SCOPE_STATEMENT.md` | Product Manager | Client Single PIC | Tech Lead, UI Designer | Entire Team |
| **M03 Commercial** | `SOW_CONTRACT.md` | Commercial / Account Lead | Founder / Director | Legal, Tech Lead | PM |
| **M04 Design** | `DESIGN_SPEC.md`, `DESIGN.md` | Product Designer | PM & Single PIC | Frontend Lead | Engineering Team |
| **M05 Specs** | `PRD.md`, `FSD.md` | System Architect | Tech Lead | Security Lead, PM | Engineering Team |
| **M06 Dev** | Source Code, `TODO.md` | Software Engineers | Tech Lead | UI Designer | PM, QA Lead |
| **M07 QA/SIT** | `SIT_REPORT.md` | QA Engineer | QA Lead | Tech Lead | Client Single PIC |
| **M09 UAT** | `UAT_SIGNOFF.md` | QA Lead & PM | Client Single PIC | Engineers | Executive Sponsors |
| **M10 Deploy** | Production Release | DevOps / Tech Lead | Tech Lead | Security Lead | All Stakeholders |
| **M11 Handover** | `BAST.md` | Account Lead | Director & Client | PM, Tech Lead | Finance |

---

## 2. Four Stage Handoff Protocols

### Handoff 1: PM → Product Designer (M02 → M04)
- **Prerequisite Gate**: `SCOPE_STATEMENT.md` marked `APPROVED`.
- **Handoff Package**:
  1. Feature inventory with strict MoSCoW prioritization (Must vs Should).
  2. RBAC matrix detailing permissions per user role.
  3. Real data context and domain statutory rules (e.g., PP 55/2022 jo. PP 20/2026).
- **Designer Acceptance Criteria**: Designer confirms zero ambiguous features before drafting wireflows.

### Handoff 2: Designer → Engineering Team (M04 → M05/M06)
- **Prerequisite Gate**: `DESIGN_SPEC.md` signed as **Design Freeze**.
- **Handoff Package**:
  1. `docs/harness-root/DESIGN.md` containing semantic tokens, palette, typography scale, and 240px sidebar layout.
  2. `docs/specs/COMPONENT_REQUIREMENTS.md` with 3-tier component inventory and anti-disabled pristine rules.
  3. Interactive prototype or Figma inspect link.
- **Engineering Acceptance Criteria**: Tech Lead verifies WCAG 2.2 AA contrast compliance and zero missing states (default, loading, error, empty, success).

### Handoff 3: Engineering → QA Team (M06 → M07)
- **Prerequisite Gate**: Local test suite passing, type-check exit code 0, staging build green.
- **Handoff Package**:
  1. Deployed staging URL.
  2. Seeded test accounts across all roles (Admin, Manager, Operator) with sanitized PII.
  3. Changelog and updated API contracts in `FSD.md`.
- **QA Acceptance Criteria**: Staging smoke test passes 5 primary user loops without 500 server errors.

### Handoff 4: QA & PM → Client Stakeholder (M07 → M09/M11)
- **Prerequisite Gate**: SIT pass, zero P0/P1 bugs outstanding, security audit clean.
- **Handoff Package**:
  1. UAT Test Workbook with step-by-step user test scenarios.
  2. 5-day formal review window with single PIC feedback SLA.
  3. Official Acceptance Report (`BAST.md`).

---

## 3. Multi-Agent & Multi-Developer Shared State Synchronization

When multiple engineers or autonomous AI agents work concurrently:

1. **Shared State Lock**: Always query `docs/pm/PROJECT_STATE.md` to identify active module, locked versions, and registered assumptions before starting work.
2. **Git Branching Discipline**:
   - `main`: Production release branch (locked, tagged with SemVer).
   - `staging`: Integration branch for QA and client demo.
   - `feat/feature-name`: Isolated feature branch mapped 1:1 to a Must-Have feature ID (`F-01..F-NN`).
3. **Atomic Task Queue in `TODO.md`**:
   - Avoid two developers modifying the same database migration or route handler concurrently.
   - Lock task in `TODO.md` by marking assignee before opening code files.
4. **Dispatch admission** — see §3.1 before spawning any sub-agent.

---

### 3.1 Dispatch admission — parallelism is an economic decision

Delegating work has two costs that are easy to forget:

- **Cold-start tax**: the sub-agent re-reads files, rules and context you already hold.
- **Orchestration overhead**: worktrees, handoffs, integration of divergent branches.

Dispatch only when the parallelism gain plus the context-isolation value exceeds those costs. Otherwise you pay twice for the same reading.

| Tier | When | What you do |
| :--- | :--- | :--- |
| **0 — direct (default)** | Task is S/M effort, touches ≤3 files, you already hold the context, or acceptance is machine-verifiable | Do it yourself on the working branch. No sub-agent, no worktree. |
| **1 — single delegate** | L/XL bundle, heavy exploratory reading, or output long enough to pollute your context | Hand the whole batch to one agent. Isolation is the reason, not speed. |
| **2 — parallel lanes** | **All** must hold: file sets are disjoint · each lane is ≥L effort · each lane is independently verifiable · ≤4 lanes | One agent per dependency-ready lane, each in its own worktree |

**The Tier 2 conditions are conjunctive.** Three of four is not a reason to parallelise — it is a reason to stay at Tier 1. Disjoint files are the one that matters most: two lanes touching the same file produce a merge conflict that costs more than the parallelism saved.

**Default to Tier 0.** On a solo project most work is Tier 0, and the honest answer to "should I delegate this?" is usually no. If the platform has no sub-agents, every tier collapses to Tier 0 — execute sequentially.

**Matching the review to the risk**

| Level | When |
| :--- | :--- |
| **L1 — machine validation** (always) | Acceptance checks plus the batch's combined validation |
| **L2 — orchestrator diff review** (default) | You read the integrated diff against every acceptance criterion |
| **L3 — independent reviewer** | Mandatory for every Tier 2 lane, and for high-risk work: contract or port format changes, logic code, cross-surface invariants |

A Tier 2 lane that is not independently reviewed is a lane whose bugs you will find in M07 instead.
