# Lifecycle Modules Catalog (M00 - M13)

Sequential 14-module delivery framework for solo developers, covering initiation, specification, execution, handover, and ongoing operations.

---

## Module Index & Quality Gates

| ID | Module Name | Primary Artifacts | Gate Checkpoint | File |
|---|---|---|---|---|
| **M00** | Product Discovery & Strategy | `MARKET_RESEARCH.md`, `COMPETITIVE_LANDSCAPE.md` | Pre-flight validation | [`00-product-discovery-strategy.md`](./00-product-discovery-strategy.md) |
| **M01** | Idea & Feasibility | `IDEA_BRIEF.md` (4D Scoring) | 3-Filter Triage | [`01-idea-feasibility.md`](./01-idea-feasibility.md) |
| **M02** | Discovery & Scope Definition | `SCOPE_STATEMENT.md` (MoSCoW, RBAC) | Scope Lock | [`02-discovery-scope.md`](./02-discovery-scope.md) |
| **M03** | Legal SOW & Charter | `SOW_CONTRACT.md` | **Gate 1: Commercial (DP & SOW)** | [`03-legal-sow-charter.md`](./03-legal-sow-charter.md) |
| **M04** | UI/UX Design & Prototyping | `DESIGN.md`, `DESIGN_SPEC.md` | Design Freeze | [`04-uiux-prototyping.md`](./04-uiux-prototyping.md) |
| **M05** | Architecture & Specifications | `PRD.md`, `FSD.md`, `SYSTEM_DESIGN_DOC.md` | Tech Spec Sign-off | [`05-architecture-specs.md`](./05-architecture-specs.md) |
| **M06** | Development Execution | 9 AI Harness Files (`AGENTS.md`, `TODO.md`, etc.) | Harness & Smoke Gate | [`06-development-execution.md`](./06-development-execution.md) |
| **M07** | Quality Assurance & SIT | `SIT_WORKBOOK.md`, `SECURITY_AUDIT.md` | Sandbox Integration Pass | [`07-quality-assurance-sit.md`](./07-quality-assurance-sit.md) |
| **M08** | Data Migration & Seeding | `DATA_MIGRATION_PLAN.md`, `RECONCILIATION_REPORT.md` | Data Hygiene Sign-off | [`08-data-migration-seeding.md`](./08-data-migration-seeding.md) |
| **M09** | Client UAT & Sign-off | `UAT_WORKBOOK.md`, `UAT_SIGNOFF_REPORT.md` | **Gate 2: Validation (PIC Sign-off)** | [`09-uat-client-signoff.md`](./09-uat-client-signoff.md) |
| **M10** | Deployment & Go-Live | `DEPLOYMENT_PROTOCOL.md`, `ROLLBACK_PLAN.md` | Production Gate (No Friday) | [`10-deployment-production.md`](./10-deployment-production.md) |
| **M11** | Handover & BAST | `BAST.md`, `HANDOVER_PROTOCOL.md` | **Gate 3: Settlement & Handover** | [`11-handover-bast.md`](./11-handover-bast.md) |
| **M12** | Warranty & SLA Retainer | `WARRANTY_POLICY.md`, `SLA_RETAINER_CONTRACT.md` | Warranty Transition | [`12-warranty-sla-retainer.md`](./12-warranty-sla-retainer.md) |
| **M13** | Product Operations & Iteration | `METRICS_BASELINE_REPORT.md`, `GROWTH_EXPERIMENTS_BACKLOG.md` | Continuous Iteration | [`13-product-operations-iteration.md`](./13-product-operations-iteration.md) |

---

## Usage by Scale

- **Small (MVP)**: Fast-track path `M04 → M05 → M06 → M10` (or single `PROJECT_LITE.md`).
- **Medium**: `M01 → M02 → M04 → M05 → M06 → M07 → M09 → M10 → M11 → M12`.
- **Large / Enterprise**: Full sequential pipeline `M00 → M13` including compliance, data migration, and recurring operations.
