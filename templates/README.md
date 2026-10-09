# Template Library Catalog

Comprehensive index of all 170 project management, specification, design, governance, development harness, QA, and operations templates in the `templates/` directory.

---

## Directory Overview

```
templates/
├── 00-pre-sales-enterprise/     (2 files)  - RFP responses, enterprise POC evaluation plans
├── 01-discovery-commercial/     (14 files) - Market research, scope statement, SOW contracts, MoSCoW
├── 02-design/                   (15 files) - UI/UX specifications, design tokens, component APIs, sitemaps
├── 02-legal-commercial/         (2 files)  - Financial tracking ledger, SMB simplified SOW
├── 03-architecture-specs/       (8 files)  - Full PRD, technical FSD, system design docs, project lite
├── 03-governance/               (16 files) - Enterprise governance: ADRs, CAB, RACI, GDPR, SOC2, risk matrices
├── 04-dev-execution/            (54 files) - 9 AI harness files, stack templates (Next.js, Laravel, Go, etc.)
├── 05-data-migration/           (3 files)  - Data migration plans, reconciliation sheets, lite ETL
├── 06-qa-uat/                   (14 files) - SIT workbooks, security audits, pentest scope, UAT sign-offs
├── 07-release-handover/         (9 files)  - Deployment protocols, rollback plans, training plans, BAST
├── 08-maintenance-ops/          (9 files)  - SLA retainer contracts, warranty policies, incident response
├── 09-product-growth/           (7 files)  - Event taxonomies, analytics plans, A/B testing, dashboards
├── by-use-case/                 (16 files) - Fast-track task guides (MVP, client commercial, legal-vault example)
└── essentials/                  (1 file)   - Quick-access index to 8 core production templates
```

---

## 1. Pre-Sales & Enterprise (`00-pre-sales-enterprise/`)

| File | Purpose | Stage / Gate |
|---|---|---|
| [`POC_PLAN_TEMPLATE.md`](./00-pre-sales-enterprise/POC_PLAN_TEMPLATE.md) | Enterprise Proof-of-Concept scope, milestone success criteria, sandbox limits | Pre-engagement / M00 |
| [`RFP_RESPONSE_TEMPLATE.md`](./00-pre-sales-enterprise/RFP_RESPONSE_TEMPLATE.md) | Formal technical proposal response to enterprise Request for Proposals | Pre-engagement / M00 |

---

## 2. Discovery & Commercial Initiation (`01-discovery-commercial/`)

| File | Purpose | Stage / Gate |
|---|---|---|
| [`IDEA_BRIEF_TEMPLATE.md`](./01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md) | 3-filter idea triage, 4D feasibility scoring, scale classification | Module 01 |
| [`M00_LITE_TEMPLATE.md`](./01-discovery-commercial/M00_LITE_TEMPLATE.md) | 1-page rapid market validation (5 interviews, waitlist test, RAT) for solo SaaS | Module 00 (Lite) |
| [`MARKET_RESEARCH_TEMPLATE.md`](./01-discovery-commercial/MARKET_RESEARCH_TEMPLATE.md) | TAM/SAM/SOM market sizing, industry headwinds, regulatory landscape | Module 00 |
| [`COMPETITIVE_LANDSCAPE_TEMPLATE.md`](./01-discovery-commercial/COMPETITIVE_LANDSCAPE_TEMPLATE.md) | 5–10 competitor benchmarking matrix, feature gaps, positioning | Module 00 |
| [`USER_RESEARCH_REPORT_TEMPLATE.md`](./01-discovery-commercial/USER_RESEARCH_REPORT_TEMPLATE.md) | Customer interviews, Jobs-to-be-Done (JTBD), user personas | Module 00 |
| [`PRODUCT_STRATEGY_TEMPLATE.md`](./01-discovery-commercial/PRODUCT_STRATEGY_TEMPLATE.md) | Vision, North Star Metric, strategic pillars, Value Proposition Canvas | Module 00 |
| [`INTERVIEW_GUIDE_TEMPLATE.md`](./01-discovery-commercial/INTERVIEW_GUIDE_TEMPLATE.md) | The Mom Test interview questions & JTBD discovery script across 3 stakeholder groups | Module 00 / 01 |
| [`SCOPE_STATEMENT_TEMPLATE.md`](./01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md) | In-Scope vs Out-of-Scope boundaries, user roles, client dependency SLAs | Module 02 |
| [`MOSCOW_MATRIX.md`](./01-discovery-commercial/MOSCOW_MATRIX.md) | MoSCoW feature prioritization breakdown (Must/Should/Could/Won't) | Module 02 |
| [`BACKLOG_TEMPLATE.md`](./01-discovery-commercial/BACKLOG_TEMPLATE.md) | Feature backlog breakdown with user story points & RICE prioritization | Module 02 |
| [`SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md`](./01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md) | Legally binding SOW contract, milestone payments, Single PIC, liability cap | Module 03 [Gate 1] |
| [`SOLO_SAAS_CHARTER_TEMPLATE.md`](./01-discovery-commercial/SOLO_SAAS_CHARTER_TEMPLATE.md) | Internal governance charter for self-initiated solo SaaS: runway budget, anti-creep razor, ambang gugur | Module 03 (Solo SaaS) |
| [`COMMUNICATION_PLAN_TEMPLATE.md`](./01-discovery-commercial/COMMUNICATION_PLAN_TEMPLATE.md) | Stakeholder communication cadences, escalation paths, status reports | Module 02 |
| [`OKR_TEMPLATE.md`](./01-discovery-commercial/OKR_TEMPLATE.md) | Objectives & Key Results tracking sheet for project deliverables | Module 01 |
| [`RACI_MATRIX_TEMPLATE.md`](./01-discovery-commercial/RACI_MATRIX_TEMPLATE.md) | Role responsibility matrix (Responsible, Accountable, Consulted, Informed) | Module 02 |
| [`RISK_REGISTER_TEMPLATE.md`](./01-discovery-commercial/RISK_REGISTER_TEMPLATE.md) | Technical and commercial risk register with mitigation strategies | Module 02 |
| [`STAKEHOLDER_MAP_TEMPLATE.md`](./01-discovery-commercial/STAKEHOLDER_MAP_TEMPLATE.md) | Stakeholder power-interest grid and communication priorities | Module 02 |
| [`REQUIREMENT_MATRIX_TEMPLATE.md`](./01-discovery-commercial/REQUIREMENT_MATRIX_TEMPLATE.md) | Requirements Traceability Matrix linking pain points to architecture & verification | Module 02/05 |
| [`VERIFICATION_PLAN_TEMPLATE.md`](./01-discovery-commercial/VERIFICATION_PLAN_TEMPLATE.md) | Objective verification plan & gate protocols (handles pending primary research) | Module 00/06/07 |

---

## 3. UI/UX Design & Specification (`02-design/`)

| File | Purpose | Stage / Gate |
|---|---|---|
| [`DESIGN_MD_TEMPLATE.md`](./02-design/DESIGN_MD_TEMPLATE.md) | Design tokens source of truth for root (`./DESIGN.md`) — anti-slop guardrail | Module 04 |
| [`DESIGN_SPEC_TEMPLATE.md`](./02-design/DESIGN_SPEC_TEMPLATE.md) | Comprehensive screen specifications, 5-state matrix, Design Freeze sign-off | Module 04 |
| [`COMPONENT_REQUIREMENTS_TEMPLATE.md`](./02-design/COMPONENT_REQUIREMENTS_TEMPLATE.md) | Scope-justified UI component inventory and state matrix | Module 04 |
| [`COMPONENT_API_SPEC_TEMPLATE.md`](./02-design/COMPONENT_API_SPEC_TEMPLATE.md) | Component documentation (props, variants, accessibility, code usage) | Module 04B |
| [`COMPONENT_RFC_TEMPLATE.md`](./02-design/COMPONENT_RFC_TEMPLATE.md) | Request for Comments template for complex UI component proposals | Module 04 |
| [`DESIGN_SYSTEM_AUDIT_TEMPLATE.md`](./02-design/DESIGN_SYSTEM_AUDIT_TEMPLATE.md) | Visual inconsistency audit (colors, typography, spacing, duplicate atoms) | Module 04B |
| [`DESIGN_TOKENS_SPEC_TEMPLATE.md`](./02-design/DESIGN_TOKENS_SPEC_TEMPLATE.md) | Design token definitions (primitive, semantic, multi-platform CSS/iOS/Android) | Module 04B |
| [`SITEMAP_TEMPLATE.md`](./02-design/SITEMAP_TEMPLATE.md) | Information Architecture, page hierarchy, route paths map | Module 04 |
| [`LOGO_DESIGN_BRIEF_TEMPLATE.md`](./02-design/LOGO_DESIGN_BRIEF_TEMPLATE.md) | Brand identity guidelines and AI image prompts for logo generation | Module 04 |
| [`SCREEN_PROMPT_TEMPLATE.md`](./02-design/SCREEN_PROMPT_TEMPLATE.md) | Standardized per-screen AI prompt template for v0/Stitch/Bolt | Module 04 |
| [`USABILITY_TEST_PLAN_TEMPLATE.md`](./02-design/USABILITY_TEST_PLAN_TEMPLATE.md) | User testing scripts, task scenarios, SUS calculation workbook | Module 04 |
| [`AB_TEST_HYPOTHESIS_TEMPLATE.md`](./02-design/AB_TEST_HYPOTHESIS_TEMPLATE.md) | A/B testing hypothesis format for validating UI variants | Module 04 |
| [`references/README.md`](./02-design/references/README.md) | Design reference system guide (inspiration collection, prompt inputs) | Module 04 |
| [`references/inspiration-template/notes-template.md`](./02-design/references/inspiration-template/notes-template.md) | Template for analyzing visual reference screenshots | Module 04 |
| [`references/prompt-input/README.md`](./02-design/references/prompt-input/README.md) | Structured prompt templates for AI component generators | Module 04 |
| [`references/prototype-output/README.md`](./02-design/references/prototype-output/README.md) | Standardized directory structure for generated interactive prototypes | Module 04 |

---

## 4. Legal & Commercial (`02-legal-commercial/`)

| File | Purpose | Stage / Gate |
|---|---|---|
| [`FINANCIAL_TRACKING.md`](./02-legal-commercial/FINANCIAL_TRACKING.md) | Project cash flow ledger: invoicing milestones, receipts, expense tracking | Module 03 |
| [`SOW_SMB.md`](./02-legal-commercial/SOW_SMB.md) | Streamlined SOW agreement for small businesses and fast-turnaround projects | Module 03 |
| [`NDA_TEMPLATE.md`](./02-legal-commercial/NDA_TEMPLATE.md) | Mutual Non-Disclosure Agreement for confidential source code & client data | Module 03 |
| [`CHANGE_REQUEST_TEMPLATE.md`](./02-legal-commercial/CHANGE_REQUEST_TEMPLATE.md) | Formal scope modification agreement with impact & commercial estimation | Module 03 / Post-Lock |

---

## 5. Architecture & Technical Specifications (`03-architecture-specs/`)

| File | Purpose | Stage / Gate |
|---|---|---|
| [`PRD_FINAL_TEMPLATE.md`](./03-architecture-specs/PRD_FINAL_TEMPLATE.md) | Official Product Requirement Document (RBAC, user stories, NFRs) | Module 05 |
| [`FSD_TECHNICAL_TEMPLATE.md`](./03-architecture-specs/FSD_TECHNICAL_TEMPLATE.md) | Functional Specification Document (SQL DDL, JSON API contracts, security) | Module 05 |
| [`PROJECT_LITE_TEMPLATE.md`](./03-architecture-specs/PROJECT_LITE_TEMPLATE.md) | Unified single-file specification (Idea + Scope + DB Schema) for 1–4 week MVPs | Module 01/05 |
| [`SYSTEM_DESIGN_DOC_TEMPLATE.md`](./03-architecture-specs/SYSTEM_DESIGN_DOC_TEMPLATE.md) | Large-scale architecture blueprint: load balancing, caching, DB sharding | Module 05B |
| [`CAPACITY_PLANNING_TEMPLATE.md`](./03-architecture-specs/CAPACITY_PLANNING_TEMPLATE.md) | Traffic projections (MAU/RPS), server memory/storage sizing calculations | Module 05B |
| [`DISASTER_RECOVERY_PLAN_TEMPLATE.md`](./03-architecture-specs/DISASTER_RECOVERY_PLAN_TEMPLATE.md) | RPO/RTO targets, Multi-AZ failover, backup restoration runbooks | Module 05B |
| [`DESIGN_PATTERN_DECISION_TREE_TEMPLATE.md`](./03-architecture-specs/DESIGN_PATTERN_DECISION_TREE_TEMPLATE.md) | Architecture and software design pattern selection decision tree | Module 05 |
| [`CODE_REVIEW_PATTERN_CHECKLIST_TEMPLATE.md`](./03-architecture-specs/CODE_REVIEW_PATTERN_CHECKLIST_TEMPLATE.md) | Anti-pattern detection and clean architecture code review checklist | Module 05 |

---

## 6. Enterprise Governance (`03-governance/`)

| File | Purpose | Stage / Gate |
|---|---|---|
| [`ADR_TEMPLATE.md`](./03-governance/ADR_TEMPLATE.md) | Architectural Decision Record format for recording major technical choices | Module 05 |
| [`CAB_PROCESS.md`](./03-governance/CAB_PROCESS.md) | Change Advisory Board (CAB) review protocol and release authorization SOP | Module 10 |
| [`COMMUNICATION_PLAN.md`](./03-governance/COMMUNICATION_PLAN.md) | Enterprise stakeholder communication matrices and meeting schedules | Module 02 |
| [`ESCALATION_MATRIX.md`](./03-governance/ESCALATION_MATRIX.md) | Incident and commercial dispute escalation levels (Level 1–4) | Module 03 |
| [`EXECUTIVE_DECK_TEMPLATE.md`](./03-governance/EXECUTIVE_DECK_TEMPLATE.md) | Executive sponsor milestone presentation template | Module 03 |
| [`GDPR_COMPLIANCE_CHECKLIST.md`](./03-governance/GDPR_COMPLIANCE_CHECKLIST.md) | Privacy impact assessment, DPO contacts, user consent verification | Module 05 |
| [`INCIDENT_RESPONSE_PLAN.md`](./03-governance/INCIDENT_RESPONSE_PLAN.md) | Production incident triage protocol (SEV 1–4) and post-mortem template | Module 12 |
| [`MEETING_CADENCE_GUIDE.md`](./03-governance/MEETING_CADENCE_GUIDE.md) | Recommended meeting rhythm for solo devs managing enterprise clients | Module 03 |
| [`RACI_MATRIX.md`](./03-governance/RACI_MATRIX.md) | Enterprise responsibility allocation sheet | Module 02 |
| [`RISK_ASSESSMENT_MATRIX.md`](./03-governance/RISK_ASSESSMENT_MATRIX.md) | Probability vs impact 5x5 enterprise risk matrix | Module 02 |
| [`SOC2_ISO27001_COMPLIANCE.md`](./03-governance/SOC2_ISO27001_COMPLIANCE.md) | Security controls checklist for SOC2 Type II and ISO 27001 audits | Module 07 |
| [`STAKEHOLDER_REGISTER.md`](./03-governance/STAKEHOLDER_REGISTER.md) | Detailed stakeholder registry with contact details and engagement styles | Module 02 |
| [`VENDOR_COMPARISON_MATRIX.md`](./03-governance/VENDOR_COMPARISON_MATRIX.md) | Subcontractor and SaaS vendor evaluation scoring matrix | Module 03 |
| [`DATA_CLASSIFICATION_POLICY.md`](./03-governance/DATA_CLASSIFICATION_POLICY.md) | Data sensitivity tiers (Public, Internal, Confidential, Restricted) | Module 05 |
| [`DATA_RETENTION_POLICY.md`](./03-governance/DATA_RETENTION_POLICY.md) | Data lifecycle and automated deletion protocols | Module 05 |
| [`AUDIT_TRAIL_REQUIREMENTS.md`](./03-governance/AUDIT_TRAIL_REQUIREMENTS.md) | Compliance log retention, immutable auditing, tamper-proofing standards | Module 05 |

---

## 7. Development Execution & AI Harness (`04-dev-execution/`)

### Core 7 Root AI Harness Files
| Template | Destination Path | Purpose |
|---|---|---|
| [`AGENTS_TEMPLATE.md`](./04-dev-execution/AGENTS_TEMPLATE.md) | `./AGENTS.md` | Universal AI agent system prompt and non-negotiable coding rules |
| [`CONTEXT_TEMPLATE.md`](./04-dev-execution/CONTEXT_TEMPLATE.md) | `./CONTEXT.md` | Business summary, user persona context, In-Scope/Out-of-Scope limits |
| [`ARCHITECTURE_TEMPLATE.md`](./04-dev-execution/ARCHITECTURE_TEMPLATE.md) | `./ARCHITECTURE.md` | Component blueprints, DB models, and API contracts for AI consumption |
| [`CONVENTIONS_TEMPLATE.md`](./04-dev-execution/CONVENTIONS_TEMPLATE.md) | `./CONVENTIONS.md` | Project naming conventions, directory structure, TypeScript strictness |
| [`ENV_EXAMPLE_TEMPLATE.md`](./04-dev-execution/ENV_EXAMPLE_TEMPLATE.md) | `./.env.example` | Sanitized environment variable catalog with format hints |
| [`TODO_TEMPLATE.md`](./04-dev-execution/TODO_TEMPLATE.md) | `./TODO.md` | Sequential atomic task queue for AI code generation |
| [`RUNBOOK_LOCAL_TEMPLATE.md`](./04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md) | `docs/specs/RUNBOOK_LOCAL.md` | Local development environment setup, DB migrations, dev server guide |
| [`VERIFY_LOCAL_TEMPLATE.md`](./04-dev-execution/VERIFY_LOCAL_TEMPLATE.md) | `docs/specs/VERIFY_LOCAL.md` | Self-verification test checklist proving implementation before merge |

### Dev Tools, Guides, & Scripts
| File | Purpose |
|---|---|
| [`DEVELOPMENT_PROGRESS_TRACKER.md`](./04-dev-execution/DEVELOPMENT_PROGRESS_TRACKER.md) | Coding execution progress sheet, checklists, and review checkpoints |
| [`AI_CODE_REVIEW_CHECKLIST_TEMPLATE.md`](./04-dev-execution/AI_CODE_REVIEW_CHECKLIST_TEMPLATE.md) | Pre-merge AI code review protocol gate |
| [`AI_PROMPT_LIBRARY_TEMPLATE.md`](./04-dev-execution/AI_PROMPT_LIBRARY_TEMPLATE.md) | Reusable prompts for boilerplate, schemas, migrations, test cases |
| [`API_DOCUMENTATION_GUIDE.md`](./04-dev-execution/API_DOCUMENTATION_GUIDE.md) | OpenAPI / Swagger specification authoring guidelines |
| [`IAC_GUIDE.md`](./04-dev-execution/IAC_GUIDE.md) | Infrastructure as Code (Terraform / Pulumi) setup for solo devs |
| [`PERFORMANCE_PROFILING_GUIDE.md`](./04-dev-execution/PERFORMANCE_PROFILING_GUIDE.md) | CPU, memory, and database slow-query profiling procedures |
| [`PR_APPROVAL_WORKFLOW_GUIDE.md`](./04-dev-execution/PR_APPROVAL_WORKFLOW_GUIDE.md) | GitHub PR review workflows, branch protection rules, squash merging |
| [`DAILY_STANDUP.md`](./04-dev-execution/DAILY_STANDUP.md) | Solo dev asynchronous daily check-in log format |
| [`SPRINT_PLANNING.md`](./04-dev-execution/SPRINT_PLANNING.md) | 2-week sprint planning sheet with velocity calculations |
| [`SPRINT_RETRO.md`](./04-dev-execution/SPRINT_RETRO.md) | Sprint retrospective template (Went well, To improve, Action items) |
| [`scripts/check-dependencies.sh`](./04-dev-execution/scripts/check-dependencies.sh) | Pre-install dependency compatibility validator script |
| [`TODO_VERIFICATION_SCRIPT.sh`](./04-dev-execution/TODO_VERIFICATION_SCRIPT.sh) | Script to verify completed TODO.md tasks against git commits |
| [`checklists/backend-checklist.md`](./04-dev-execution/checklists/backend-checklist.md) | Backend development execution verification checklist |
| [`checklists/frontend-checklist.md`](./04-dev-execution/checklists/frontend-checklist.md) | Frontend UI, responsiveness, and state management verification checklist |
| [`checklists/integration-checklist.md`](./04-dev-execution/checklists/integration-checklist.md) | Third-party API, payment gateway, and storage integration checklist |

### Stack-Specific Harness Templates
Complete harness sets (AGENTS, ARCHITECTURE, CONVENTIONS, ENV_EXAMPLE) per framework:
- **`nextjs/`**: Next.js 15+ App Router, Server Actions, React 19, Supabase (`AGENTS.md`, `ARCHITECTURE.md`, `CONVENTIONS.md`, `ENV_EXAMPLE.md`)
- **`laravel/`**: Laravel 11–13+, Livewire / Inertia, Sanctum auth (`AGENTS.md`, `ARCHITECTURE.md`, `CONVENTIONS.md`, `ENV_EXAMPLE.md`)
- **`django/`**: Django 5–6+, DRF, PostgreSQL, Celery (`AGENTS.md`, `ARCHITECTURE.md`, `CONVENTIONS.md`, `ENV_EXAMPLE.md`)
- **`go/`**: Go 1.23+, Fiber / Echo, pgx, SQL migrations (`AGENTS.md`, `ARCHITECTURE.md`, `CONVENTIONS.md`, `ENV_EXAMPLE.md`)
- **`rails/`**: Ruby on Rails 7+, ActiveRecord, RSpec (`AGENTS.md`, `ARCHITECTURE.md`, `CONVENTIONS.md`, `.env.example`)
- **`remix/`**: Remix / React Router v7 full-stack web standards
- **`mern/`**: Express.js + React + MongoDB Mongoose
- **`aspnet/`**: ASP.NET Core Web API + Entity Framework
- **`spring/`**: Spring Boot + Spring Data JPA
- **`jamstack/` & `astro/`**: Static site generation and content collections
- **`nuxt/`**: Nuxt 3 Vue.js full-stack framework
- **`sveltekit/`**: SvelteKit full-stack framework
- **`serverless/`**: AWS Lambda / Serverless Framework event-driven apps
- **`flutter/`**: Flutter cross-platform mobile apps

---

## 8. Data Migration & Seeding (`05-data-migration/`)

| File | Purpose | Stage / Gate |
|---|---|---|
| [`DATA_MIGRATION_PLAN_TEMPLATE.md`](./05-data-migration/DATA_MIGRATION_PLAN_TEMPLATE.md) | Source-to-target column mapping matrix, data hygiene boundaries | Module 08 |
| [`RECONCILIATION_REPORT_TEMPLATE.md`](./05-data-migration/RECONCILIATION_REPORT_TEMPLATE.md) | Imported vs rejected data row counts & Client Data Sign-Off sheet | Module 08 |
| [`DATA_MIGRATION_LITE.md`](./05-data-migration/DATA_MIGRATION_LITE.md) | Lightweight CSV/Excel data import checklist for small MVP projects | Module 08 |

---

## 9. Quality Assurance & UAT (`06-qa-uat/`)

| File | Purpose | Stage / Gate |
|---|---|---|
| [`SIT_WORKBOOK_TEMPLATE.md`](./06-qa-uat/SIT_WORKBOOK_TEMPLATE.md) | System Integration Testing workbook for 3rd-party sandboxes in Staging | Module 07 |
| [`SECURITY_AUDIT_TEMPLATE.md`](./06-qa-uat/SECURITY_AUDIT_TEMPLATE.md) | OWASP Top 10 security audit report & personal data compliance check | Module 07 |
| [`SECURITY_CHECKLIST_SMALL.md`](./06-qa-uat/SECURITY_CHECKLIST_SMALL.md) | Lightweight 10-point security checklist for MVPs | Module 07 |
| [`PENTEST_SCOPE_TEMPLATE.md`](./06-qa-uat/PENTEST_SCOPE_TEMPLATE.md) | Rules of engagement and scope definition for third-party penetration tests | Module 07 |
| [`BUG_REPORT.md`](./06-qa-uat/BUG_REPORT.md) | Standardized bug reporting format with environment & repro steps | Module 07 |
| [`BUG_TRIAGE_MATRIX.md`](./06-qa-uat/BUG_TRIAGE_MATRIX.md) | Severity 1–4 defect classification and resolution SLA matrix | Module 09 |
| [`DEMO_SCRIPT.md`](./06-qa-uat/DEMO_SCRIPT.md) | Step-by-step walkthrough script for client demo presentations | Module 09 |
| [`DEMO_FEEDBACK_FORM.md`](./06-qa-uat/DEMO_FEEDBACK_FORM.md) | Structured client feedback collection form after demo sessions | Module 09 |
| [`FEEDBACK_MATRIX.md`](./06-qa-uat/FEEDBACK_MATRIX.md) | Client feedback triage matrix: Bug vs Change Request separation | Module 09 |
| [`UAT_WORKBOOK_TEMPLATE.md`](./06-qa-uat/UAT_WORKBOOK_TEMPLATE.md) | Comprehensive client testing guide and defect log on Staging server | Module 09 |
| [`UAT_WORKBOOK_SMALL.md`](./06-qa-uat/UAT_WORKBOOK_SMALL.md) | Simplified UAT testing matrix for fast-track projects | Module 09 |
| [`UAT_SIGNOFF_TEMPLATE.md`](./06-qa-uat/UAT_SIGNOFF_TEMPLATE.md) | Official User Acceptance Testing Sign-Off Report signed by Client Single PIC | Module 09 [Gate 2] |
| [`UAT_SIGNOFF_SMALL.md`](./06-qa-uat/UAT_SIGNOFF_SMALL.md) | Single-page client UAT sign-off confirmation | Module 09 [Gate 2] |
| [`UAT_TRAINING_SCRIPT.md`](./06-qa-uat/UAT_TRAINING_SCRIPT.md) | Client end-user training session script before starting UAT | Module 09 |

---

## 10. Release & Handover (`07-release-handover/`)

| File | Purpose | Stage / Gate |
|---|---|---|
| [`DEPLOYMENT_PROTOCOL_TEMPLATE.md`](./07-release-handover/DEPLOYMENT_PROTOCOL_TEMPLATE.md) | Production release execution checklist, DNS/SSL setup, live secrets | Module 10 |
| [`ROLLBACK_PLAN_TEMPLATE.md`](./07-release-handover/ROLLBACK_PLAN_TEMPLATE.md) | 15-minute emergency rollback procedures for go-live failure recovery | Module 10 |
| [`RELEASE_APPROVAL_CHECKLIST.md`](./07-release-handover/RELEASE_APPROVAL_CHECKLIST.md) | Pre-deployment sanity gate (No Friday Deploys, smoke test passes) | Module 10 |
| [`BAST_TEMPLATE.md`](./07-release-handover/BAST_TEMPLATE.md) | Official Project Handover Certificate (BAST) with legal Rp 10.000 stamp | Module 11 [Gate 3] |
| [`BAST_EMAIL_SMALL.md`](./07-release-handover/BAST_EMAIL_SMALL.md) | Formal email-based handover confirmation for remote client projects | Module 11 [Gate 3] |
| [`HANDOVER_PROTOCOL_TEMPLATE.md`](./07-release-handover/HANDOVER_PROTOCOL_TEMPLATE.md) | Git repo transfer, Bitwarden encrypted credentials handover SOP | Module 11 |
| [`USER_MANUAL_TEMPLATE.md`](./07-release-handover/USER_MANUAL_TEMPLATE.md) | System operations manual for client staff and administrators | Module 11 |
| [`TRAINING_PLAN.md`](./07-release-handover/TRAINING_PLAN.md) | Post-launch client operational training curriculum and quota tracking | Module 11 |
| [`CREDENTIALS_VAULT.md`](./07-release-handover/CREDENTIALS_VAULT.md) | Secure credential inventory format for client transfer | Module 11 |

---

## 11. Maintenance & SLA (`08-maintenance-ops/`)

| File | Purpose | Stage / Gate |
|---|---|---|
| [`WARRANTY_POLICY_TEMPLATE.md`](./08-maintenance-ops/WARRANTY_POLICY_TEMPLATE.md) | Official warranty policy: 30–90 day bug-fix coverage, defect definitions | Module 12 |
| [`WARRANTY_POLICY_SMALL.md`](./08-maintenance-ops/WARRANTY_POLICY_SMALL.md) | 30-day simplified warranty policy for small-tier projects | Module 12 |
| [`SLA_RETAINER_CONTRACT_TEMPLATE.md`](./08-maintenance-ops/SLA_RETAINER_CONTRACT_TEMPLATE.md) | Recurring monthly maintenance agreement (Monthly Retainer SLA) | Module 12 |
| [`SLA_SLO_DEFINITIONS.md`](./08-maintenance-ops/SLA_SLO_DEFINITIONS.md) | Formal SLA uptime (99.9%) and response/resolution time matrices | Module 12 |
| [`INCIDENT_RESPONSE_TEMPLATE.md`](./08-maintenance-ops/INCIDENT_RESPONSE_TEMPLATE.md) | Standard Operating Procedure (SOP) for emergency outages and Root Cause Analysis | Module 12 |
| [`PROJECT_RETROSPECTIVE_TEMPLATE.md`](./08-maintenance-ops/PROJECT_RETROSPECTIVE_TEMPLATE.md) | End-of-project retrospective template (budget accuracy, learnings) | Module 12 |
| [`BACKUP_RESTORE_PROCEDURES.md`](./08-maintenance-ops/BACKUP_RESTORE_PROCEDURES.md) | Database backup, encrypted offsite storage, and disaster recovery drill SOP | Module 12 |
| [`CAPACITY_PLANNING_GUIDE.md`](./08-maintenance-ops/CAPACITY_PLANNING_GUIDE.md) | Post-launch server resource scaling guide | Module 12 |
| [`DISASTER_RECOVERY_PLAN.md`](./08-maintenance-ops/DISASTER_RECOVERY_PLAN.md) | Operational disaster mitigation and emergency failover protocols | Module 12 |

---

## 12. Product Operations & Growth (`09-product-growth/`)

| File | Purpose | Stage / Gate |
|---|---|---|
| [`METRICS_BASELINE_REPORT_TEMPLATE.md`](./09-product-growth/METRICS_BASELINE_REPORT_TEMPLATE.md) | First 30-day post-launch baseline metrics report (AARRR funnel, NPS) | Module 13 |
| [`EVENT_TAXONOMY_TEMPLATE.md`](./09-product-growth/EVENT_TAXONOMY_TEMPLATE.md) | Analytics event tracking taxonomy (`verb_noun` naming convention) | Module 06B / 13 |
| [`ANALYTICS_IMPLEMENTATION_PLAN_TEMPLATE.md`](./09-product-growth/ANALYTICS_IMPLEMENTATION_PLAN_TEMPLATE.md) | Mixpanel / Amplitude SDK tracking implementation plan & consent management | Module 06B / 13 |
| [`DASHBOARD_SPEC_TEMPLATE.md`](./09-product-growth/DASHBOARD_SPEC_TEMPLATE.md) | KPI dashboard specifications, alert thresholds, cohort analysis specs | Module 06B / 13 |
| [`GROWTH_EXPERIMENTS_BACKLOG_TEMPLATE.md`](./09-product-growth/GROWTH_EXPERIMENTS_BACKLOG_TEMPLATE.md) | Growth experiments backlog with RICE scoring and experiment results | Module 13 |
| [`PRODUCT_HEALTH_DASHBOARD_TEMPLATE.md`](./09-product-growth/PRODUCT_HEALTH_DASHBOARD_TEMPLATE.md) | Periodic product health review dashboard (retention, uptime, support load) | Module 13 |
| [`AB_TEST_REPORT_TEMPLATE.md`](./09-product-growth/AB_TEST_REPORT_TEMPLATE.md) | Post-experiment conversion analysis, statistical significance, rollout plan | Module 13 |

---

## 13. By Use Case (`by-use-case/`) & Essentials (`essentials/`)

- [`essentials/README.md`](./essentials/README.md): Fast-track index to the **8 most essential templates** for 80% of solo projects.
- [`essentials/PROJECT_STATE_TEMPLATE.md`](./essentials/PROJECT_STATE_TEMPLATE.md): Single source of truth for project lifecycle state, gate progress, and cross-session handoff.
- [`by-use-case/mvp-fast-track/README.md`](./by-use-case/mvp-fast-track/README.md): Minimal templates for 1–4 week solo MVPs.
- [`by-use-case/client-commercial/README.md`](./by-use-case/client-commercial/README.md): Complete governance path for paid client engagements.
- [`by-use-case/technical-specs/README.md`](./by-use-case/technical-specs/README.md): Architecture-first path for complex systems.
- [`by-use-case/operations/README.md`](./by-use-case/operations/README.md): Post-launch warranty, incident response, and SLA workflows.
- [`by-use-case/examples/legal-vault/`](./by-use-case/examples/legal-vault/README.md): Fully worked end-to-end project example across all phases.
