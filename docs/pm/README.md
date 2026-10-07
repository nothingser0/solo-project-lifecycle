# Project Management & Governance Directory (`docs/pm/`)

This directory is the standardized output destination for all project initiation, scoping, commercial, and legal governance artifacts generated during the lifecycle.

---

## Purpose & Usage

In the **solo-project-lifecycle** framework, the root directory (`./`) is reserved exclusively for the 9 AI harness files (`AGENTS.md`, `CONTEXT.md`, `ARCHITECTURE.md`, `DESIGN.md`, `CONVENTIONS.md`, `.env.example`, `TODO.md`, `RUNBOOK_LOCAL.md`, `VERIFY_LOCAL.md`), `README.md`, and configuration.

All planning and governance documents produced by AI agents or developers must be stored here inside `docs/pm/`.

---

## Artifacts Stored Here (Generated per Module)

| Artifact | Generated In | Source Template | Purpose |
|---|---|---|---|
| `PROJECT_STATE.md` | Universal / All | `templates/essentials/PROJECT_STATE_TEMPLATE.md` | Single source of truth for gate tracking & cross-session handoff |
| `M00_LITE.md` | Module 00 (Lite) | `templates/01-discovery-commercial/M00_LITE_TEMPLATE.md` | Rapid 1-page market validation for Solo SaaS products |
| `INTERVIEW_GUIDE.md` | Module 00 / 01 | `templates/01-discovery-commercial/INTERVIEW_GUIDE_TEMPLATE.md` | The Mom Test interview questions & JTBD discovery script |
| `REQUIREMENT_MATRIX.md`| Module 02 / 05 | `templates/01-discovery-commercial/REQUIREMENT_MATRIX_TEMPLATE.md` | Requirements Traceability Matrix linking pain points to code & tests |
| `VERIFICATION_PLAN.md` | Module 00 / 06 | `templates/01-discovery-commercial/VERIFICATION_PLAN_TEMPLATE.md` | Objective verification plan & gate protocols (handles pending research) |
| `MARKET_RESEARCH.md` | Module 00 | `templates/01-discovery-commercial/MARKET_RESEARCH_TEMPLATE.md` | TAM/SAM/SOM market analysis & trends |
| `COMPETITIVE_LANDSCAPE.md` | Module 00 | `templates/01-discovery-commercial/COMPETITIVE_LANDSCAPE_TEMPLATE.md` | Feature matrix & competitor breakdown |
| `USER_RESEARCH_REPORT.md` | Module 00 | `templates/01-discovery-commercial/USER_RESEARCH_REPORT_TEMPLATE.md` | JTBD interview notes & pain-point matrix |
| `PRODUCT_STRATEGY.md` | Module 00 | `templates/01-discovery-commercial/PRODUCT_STRATEGY_TEMPLATE.md` | North Star Metric & strategic pillars |
| `IDEA_BRIEF.md` | Module 01 | `templates/01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md` | 3-filter triage & 4D feasibility score |
| `SCOPE_STATEMENT.md` | Module 02 | `templates/01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md` | MoSCoW feature breakdown & Out-of-Scope boundaries |
| `SOW_CONTRACT.md` | Module 03 | `templates/01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md` | Commercial agreement, milestone terms, project charter |
| `BAST.md` | Module 11 | `templates/07-release-handover/BAST_TEMPLATE.md` | Official handover certificate & warranty trigger |
| `GROWTH_EXPERIMENTS_BACKLOG.md` | Module 13 | `templates/09-product-growth/GROWTH_EXPERIMENTS_BACKLOG_TEMPLATE.md` | Post-launch growth backlog with RICE scoring |
| `PRODUCT_HEALTH_DASHBOARD.md` | Module 13 | `templates/09-product-growth/PRODUCT_HEALTH_DASHBOARD_TEMPLATE.md` | Recurring product KPI monitoring sheet |

---

## Note for Framework Repository

This directory inside the framework toolkit repository serves as the structural reference. In active user projects, the AI agent generates the filled markdown files directly into the user project's `docs/pm/` folder.
