# Template Library Catalog

Index of the templates in `templates/`. **Fast-track index with the most-used templates: [`essentials/README.md`](./essentials/README.md)** — start there.

> Loading guidance: copy only the template(s) for the module you are entering. Do not read this catalog wholesale during a project; it is a directory map, not a work list.

---

## Directory Overview

```
templates/
├── 00-pre-sales-enterprise/     RFP responses, enterprise POC evaluation plans
├── 01-discovery-commercial/     Market research, scope statement, SOW contracts, MoSCoW
├── 02-design/                   UI/UX specifications, design tokens, component APIs, sitemaps
├── 02-legal-commercial/         Financial tracking ledger, SMB simplified SOW
├── 03-architecture-specs/       Full PRD, technical FSD, system design docs, project lite
├── 03-governance/               Enterprise governance: ADRs, CAB, RACI, GDPR, SOC2, risk matrices
├── 04-dev-execution/            9 AI harness files, stack templates (Next.js, Laravel, Go, etc.),
│                                examples/TODO_EXAMPLE_POS_RETAIL.md (full worked sprint plan)
├── 05-data-migration/           Data migration plans, reconciliation sheets, lite ETL
├── 06-qa-uat/                   SIT workbooks, security audits, pentest scope, UAT sign-offs
├── 07-release-handover/         Deployment protocols, rollback plans, training plans, BAST
├── 08-maintenance-ops/          SLA retainer contracts, warranty policies, incident response
├── 09-product-growth/           Event taxonomies, analytics plans, A/B testing, dashboards
├── by-use-case/                 Fast-track task guides (MVP, client commercial, legal-vault example)
└── essentials/                  Fast-track index + LITE bodies for the Small path
```

## Per-directory quick map

| Directory | Use when entering | Highlights |
| :--- | :--- | :--- |
| `00-pre-sales-enterprise/` | Enterprise pre-engagement | `RFP_RESPONSE_TEMPLATE.md`, `POC_PLAN_TEMPLATE.md`, `CONSULTING_AGREEMENT_TEMPLATE.md`, `WBS_PHASING_TEMPLATE.md` |
| `01-discovery-commercial/` | M00–M02 | `M00_LITE_TEMPLATE.md`, `IDEA_BRIEF_TEMPLATE.md`, `SCOPE_STATEMENT_TEMPLATE.md`, `SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md`, `MARKET_RESEARCH_TEMPLATE.md` |
| `02-design/` | M04 | `DESIGN_MD_TEMPLATE.md`, `DESIGN_SPEC_TEMPLATE.md`, `SITEMAP_TEMPLATE.md`, `COMPONENT_REQUIREMENTS_TEMPLATE.md`, `LOGO_DESIGN_BRIEF_TEMPLATE.md`; LITE bodies in `essentials/` |
| `02-legal-commercial/` | M03 (small client) | `SOW_SMB.md`, `NDA_TEMPLATE.md`, `CHANGE_REQUEST_TEMPLATE.md` |
| `03-architecture-specs/` | M05 | `PROJECT_LITE_TEMPLATE.md`, `PRD_FINAL_TEMPLATE.md`, `FSD_TECHNICAL_TEMPLATE.md`, `SYSTEM_DESIGN_DOC_TEMPLATE.md` |
| `03-governance/` | Enterprise / Large | ADR, RACI, CAB, SOC2/ISO, data policies |
| `04-dev-execution/` | M06 | 9 harness files (AGENTS/CONTEXT/ARCHITECTURE/DESIGN/CONVENTIONS/TODO/RUNBOOK_LOCAL/VERIFY_LOCAL/.env.example), per-stack AGENTS/CONVENTIONS, `examples/` worked sprint plan |
| `05-data-migration/` | M08 | `DATA_MIGRATION_PLAN_TEMPLATE.md`, `DATA_MIGRATION_LITE.md`, `RECONCILIATION_REPORT_TEMPLATE.md` |
| `06-qa-uat/` | M07/M09 | `SIT_WORKBOOK_TEMPLATE.md`, `SECURITY_CHECKLIST_SMALL.md`, `UAT_SIGNOFF_SMALL.md`, `UAT_WORKBOOK_TEMPLATE.md` |
| `07-release-handover/` | M10/M11 | `DEPLOYMENT_PROTOCOL_TEMPLATE.md`, `ROLLBACK_PLAN_TEMPLATE.md`, `GO_LIVE_REPORT_TEMPLATE.md`, `BAST_TEMPLATE.md`, `HANDOVER_PROTOCOL_TEMPLATE.md` |
| `08-maintenance-ops/` | M11/M12 | `WARRANTY_POLICY_TEMPLATE.md`, `SLA_RETAINER_CONTRACT_TEMPLATE.md`, `RUNBOOK_OPS.md`, `INCIDENT_RESPONSE_TEMPLATE.md`, `PROJECT_CLOSURE_REPORT_TEMPLATE.md` (client-facing, M11), `PROJECT_RETROSPECTIVE_TEMPLATE.md` (internal, M11) |
| `09-product-growth/` | M13 | `METRICS_BASELINE_REPORT_TEMPLATE.md`, `GROWTH_EXPERIMENTS_BACKLOG_TEMPLATE.md`, `AB_TEST_REPORT_TEMPLATE.md` |
| `by-use-case/` | — | Index READMEs per workflow + `examples/legal-vault/` worked example |
| `essentials/` | Small path | `INTAKE_GATE.md`, `PROJECT_STATE_TEMPLATE.md`, `LITE_*.md` bodies, fast-track index |

## Full Inventory (secondary & specialist templates)

The quick map above lists only the most-used templates. Everything else lives here so you never have to `ls` or guess. Copy on demand — do not read this table wholesale.

| Directory | Secondary / specialist templates |
| :--- | :--- |
| `01-discovery-commercial/` | `BACKLOG_TEMPLATE.md`, `COMMUNICATION_PLAN_TEMPLATE.md`, `INTERVIEW_GUIDE_TEMPLATE.md`, `MOSCOW_MATRIX.md`, `OKR_TEMPLATE.md`, `RACI_MATRIX_TEMPLATE.md`, `REQUIREMENT_MATRIX_TEMPLATE.md`, `RISK_REGISTER_TEMPLATE.md`, `SOLO_SAAS_CHARTER_TEMPLATE.md`, `VERIFICATION_PLAN_TEMPLATE.md` |
| `02-design/` | `AB_TEST_HYPOTHESIS_TEMPLATE.md`, `COMPONENT_API_SPEC_TEMPLATE.md`, `COMPONENT_RFC_TEMPLATE.md`, `DESIGN_SYSTEM_AUDIT_TEMPLATE.md`, `DESIGN_TOKENS_SPEC_TEMPLATE.md`, `USABILITY_TEST_PLAN_TEMPLATE.md`, `references/inspiration-template/NOTES_TEMPLATE.md`, `references/prototype-output/` |
| `02-legal-commercial/` | `FINANCIAL_TRACKING.md` |
| `03-architecture-specs/` | `CAPACITY_PLANNING_TEMPLATE.md`, `CODE_REVIEW_PATTERN_CHECKLIST_TEMPLATE.md`, `DESIGN_PATTERN_DECISION_TREE_TEMPLATE.md`, `DISASTER_RECOVERY_PLAN_TEMPLATE.md` |
| `03-governance/` | `DATA_CLASSIFICATION_POLICY.md`, `DATA_RETENTION_POLICY.md`, `ESCALATION_MATRIX.md`, `EXECUTIVE_DECK_TEMPLATE.md`, `GDPR_COMPLIANCE_CHECKLIST.md`, `INCIDENT_RESPONSE_PLAN.md`, `MEETING_CADENCE_GUIDE.md`, `SOC2_ISO27001_COMPLIANCE.md`, `STAKEHOLDER_REGISTER.md`, `ADR_TEMPLATE.md`, `RISK_ASSESSMENT_MATRIX.md` |
| `04-dev-execution/` | `AI_CODE_REVIEW_CHECKLIST_TEMPLATE.md`, `AI_PROMPT_LIBRARY_TEMPLATE.md`, `API_DOCUMENTATION_GUIDE.md`, `DAILY_STANDUP.md`, `IAC_GUIDE.md`, `LEARNINGS_TEMPLATE.md`, `PERFORMANCE_PROFILING_GUIDE.md`, `PR_APPROVAL_WORKFLOW_GUIDE.md`, `RELEASE_WORKFLOW.md`, `SEED_DATA_TEMPLATE.md`, `SPRINT_PLANNING.md`, `SPRINT_RETRO.md`, `checklists/` (BACKEND, FRONTEND, INTEGRATION), per-stack `ENV_EXAMPLE.md` |
| `06-qa-uat/` | `DEMO_FEEDBACK_FORM.md`, `DEMO_SCRIPT.md`, `FEEDBACK_MATRIX.md`, `UAT_TRAINING_SCRIPT.md`, `POLISH_AUDIT_TEMPLATE.md` |
| `07-release-handover/` | `CHANGELOG_TEMPLATE.md`, `CREDENTIALS_VAULT.md`, `RELEASE_APPROVAL_CHECKLIST.md`, `USER_MANUAL_TEMPLATE.md` |
| `08-maintenance-ops/` | `BACKUP_RESTORE_PROCEDURES.md`, `CAPACITY_PLANNING_GUIDE.md`, `SLA_SLO_DEFINITIONS.md` |
| `09-product-growth/` | `ANALYTICS_IMPLEMENTATION_PLAN_TEMPLATE.md`, `DASHBOARD_SPEC_TEMPLATE.md`, `EVENT_TAXONOMY_TEMPLATE.md`, `PRODUCT_HEALTH_DASHBOARD_TEMPLATE.md` |
| `00-pre-sales-enterprise/` | `RFP_RESPONSE_TEMPLATE.md`, `POC_PLAN_TEMPLATE.md`, `CONSULTING_AGREEMENT_TEMPLATE.md`, `WBS_PHASING_TEMPLATE.md` |

For a machine-readable inventory, see `docs/INDEX.json` (human reference only — **never load it into agent context**; it is large and adds no execution value).
