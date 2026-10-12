# Lifecycle Modules Catalog (M00 - M13)

Sequential 14-module delivery framework for solo developers, covering initiation, specification, execution, handover, and ongoing operations. Each module file is a compact runbook (inputs → steps → outputs → gate criteria, target ≤~2k tokens); extended material lives in `deep-dives/` and is loaded only when a step requires depth.

**Load discipline**: runbook headers list `📖 Optional refs (do NOT preload)`. Load a runbook first and follow its steps; open an optional ref or deep-dive **only** when a step names it. Copy-ready templates (`**Templates to copy**`) are read at execution time, not upfront. Small pieces needed on every run (RICE formula, pre-merge review, research method, feasibility scoring) are inlined in the runbook itself.

---

## Module Index & Quality Gates

| ID | Module Name | Primary Artifacts | Gate Checkpoint | File |
|---|---|---|---|---|
| **M00** | Product Discovery & Strategy | `MARKET_RESEARCH.md`, `COMPETITIVE_LANDSCAPE.md` | Pre-flight validation | [`00_PRODUCT_DISCOVERY_STRATEGY.md`](./00_PRODUCT_DISCOVERY_STRATEGY.md) |
| **M01** | Idea & Feasibility | `IDEA_BRIEF.md` (4D Scoring, 1.0–5.0) | Dimension Floor + scale classifier | [`01_IDEA_FEASIBILITY.md`](./01_IDEA_FEASIBILITY.md) |
| **M02** | Discovery & Scope Definition | `SCOPE_STATEMENT.md` (MoSCoW, RBAC) | Scope Lock | [`02_DISCOVERY_SCOPE.md`](./02_DISCOVERY_SCOPE.md) |
| **M03** | Legal SOW & Charter | `SOW_CONTRACT.md` | **Gate 1: Commercial (DP & SOW)** | [`03_LEGAL_SOW_CHARTER.md`](./03_LEGAL_SOW_CHARTER.md) |
| **M04** | UI/UX Design & Prototyping | `DESIGN.md`, `DESIGN_SPEC.md` | Design Freeze | [`04_UIUX_PROTOTYPING.md`](./04_UIUX_PROTOTYPING.md) |
| **M05** | Architecture & Specifications | `PRD.md` + `FSD.md` (Small: `PROJECT_LITE.md` §5; Medium+ also `docs/governance/ADR.md`; Large/Enterprise add `SYSTEM_DESIGN_DOC.md`, `CAPACITY_PLANNING.md`, `DISASTER_RECOVERY_PLAN.md` via M05B) | Tech Spec Sign-off (human; gate-enforced: ≥10 endpoint headings, `Stack Decision LOCKED:` + 8 real answers + `Stack-Locked-by:`, security blueprint, `Module 04 Handoff Strategy`; idempotency/RLS conditional on Intake) | [`05_ARCHITECTURE_SPECS.md`](./05_ARCHITECTURE_SPECS.md) |
| **M06** | Development Execution | 9 AI Harness Files (`AGENTS.md`, `TODO.md`, etc.) | Harness & Smoke Gate | [`06_DEVELOPMENT_EXECUTION.md`](./06_DEVELOPMENT_EXECUTION.md) |
| **M07** | Quality Assurance & SIT | `SIT_WORKBOOK.md`, `SECURITY_AUDIT.md` | Sandbox Integration Pass | [`07_QUALITY_ASSURANCE_SIT.md`](./07_QUALITY_ASSURANCE_SIT.md) |
| **M08** | Data Migration & Seeding | `DATA_MIGRATION_PLAN.md`, `RECONCILIATION_REPORT.md` | Data Hygiene Sign-off | [`08_DATA_MIGRATION_SEEDING.md`](./08_DATA_MIGRATION_SEEDING.md) |
| **M09** | Client UAT & Sign-off | `UAT_WORKBOOK.md`, `UAT_SIGNOFF_REPORT.md` | **Gate 2: Validation (PIC Sign-off)** | [`09_UAT_CLIENT_SIGNOFF.md`](./09_UAT_CLIENT_SIGNOFF.md) |
| **M10** | Deployment & Go-Live | `DEPLOYMENT_PROTOCOL.md`, `ROLLBACK_PLAN.md` | Production Gate (No Friday) | [`10_DEPLOYMENT_PRODUCTION.md`](./10_DEPLOYMENT_PRODUCTION.md) |
| **M11** | Handover & BAST | `BAST.md`, `HANDOVER_PROTOCOL.md` | **Gate 3: Settlement & Handover** | [`11_HANDOVER_BAST.md`](./11_HANDOVER_BAST.md) |
| **M12** | Warranty & SLA Retainer | `WARRANTY_POLICY.md`, `SLA_RETAINER_CONTRACT.md` | Warranty Transition | [`12_WARRANTY_SLA_RETAINER.md`](./12_WARRANTY_SLA_RETAINER.md) |
| **M13** | Product Operations & Iteration | `METRICS_BASELINE_REPORT.md`, `GROWTH_EXPERIMENTS_BACKLOG.md` | Continuous Iteration | [`13_PRODUCT_OPERATIONS_ITERATION.md`](./13_PRODUCT_OPERATIONS_ITERATION.md) |
| **A00-A04** | Enterprise Advisory Series (Non-Solo) | C4 Model, STRIDE, WBS Phasing, RFP Procurement Pack | Non-Solo Capacity Gate | [`A00_ENTERPRISE_ADVISORY_SERIES.md`](./A00_ENTERPRISE_ADVISORY_SERIES.md) |

---

## Usage by Scale

- **Small (MVP)**: Intake → `M04-LITE → M05 → [STOP] → M06 (+security) → M09-LITE → [STOP] → M10 → M12-LITE` (or single `PROJECT_LITE.md`).
- **Medium (client)**: `M01 → M02 → M03 [GATE] → M04 → M05 → M06 → M07 → M09 [GATE] → M10 → M11 [GATE] → M12`.
- **Large / Enterprise**: Full sequential pipeline `M00 → M13` including compliance, data migration, and recurring operations.
