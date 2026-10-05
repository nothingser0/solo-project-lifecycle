---
name: solo-project-lifecycle
description: End-to-end software development lifecycle (SDLC) orchestrator for solo developers and technical consultants executing projects from Small (MVP) to Enterprise scale. Covers the full 14-module pipeline from raw idea triage, feasibility evaluation, discovery, contract gating, UI/UX, architecture/FSD, development, QA/SIT, data migration, UAT sign-off, production deployment, to BAST handover and maintenance. Trigger whenever proposing a new app idea, scoping a project, qualifying clients, drafting PRD/FSD, planning architectures, or closing projects.
---

# Solo Software Lifecycle Orchestrator

Software operational framework for solo developers and technical consultants executing projects from Small (MVP) to Enterprise scale with scope protection, AI automation, and tiered quality gates.

> 🚀 **QUICK INITIATION GUIDE (ANTI-CONFLICT PROTOCOL)**:
> Before starting to code or creating a project folder, read the Quickstart guide in **`docs/quickstart.md`**.
> Never copy harness files (`AGENTS.md`, `TODO.md`, etc.) to an empty folder **before** running your language framework scaffolding (`create-next-app`, `poetry init`, `composer`, `dotnet new`, `flutter create`, etc.) to avoid CLI rejection (*directory conflict*).

---

## 1. The 14-Module Pipeline

```text
INITIATION & DISCOVERY PHASE:
  00. Product Discovery & Strategy (Market, Competitor, & User Research) ──► docs/modules/00-product-discovery-strategy.md
  01. Idea & Feasibility (3-Filter Triage & Feasibility Score) ──► docs/modules/01-idea-feasibility.md
  02. Discovery & Scope Definition (Business Requirements Elicitation)
  03. [COMMERCIAL GATE] Legal SOW, Down Payment, & Single PIC Agreement

DESIGN & SPECIFICATION PHASE:
  04. UI/UX Design & Prototyping (Design System & User Flow)
    - Section 8: Design System Foundation & Implementation [M04B - Enterprise Extension]
  05. Architecture & Technical Specifications (PRD, FSD, & DB Schema)
    - Section 6: System Design & Infrastructure Scalability [M05B - Enterprise Extension]

EXECUTION & VALIDATION PHASE:
  06. Development (Backend, Frontend, API Integration)
    - Section 6A: Product Instrumentation & Analytics Setup [M06B - Enterprise Extension]
  07. Quality Assurance (Unit Test, SIT, & Security Audit)
  08. Data Migration & Seeding (Data Cleaning & Transformation)
  09. [VALIDATION GATE] Client UAT & Sign-Off in Staging

RELEASE & CLOSURE PHASE:
  10. Deployment & Production Go-Live (CI/CD, DNS, SSL)
  11. [HANDOVER GATE] 100% Final Settlement, Training, BAST, & Repository Handover
  12. Warranty Period (Bug Fixes) ──► Transition to Monthly Retainer / SLA
  13. Product Operations & Continuous Iteration (Metrics Baseline, RICE, Feedback Loop) ──► docs/modules/13-product-operations-iteration.md
```

**CRITICAL: Progressive Loading Protocol**
- **DO NOT load all 17 modules at once** (total ~100K tokens)
- Load specific module ONLY when entering that phase
- Example: "Load docs/modules/03-legal-sow-charter.md" when at Module 03
- Reduces context pollution and improves response quality

---

## 2. Core Solo Rules

1. **Defensive Scope Management (Scope Protection)**: Solo developers do not have a replacement team. Any feature addition without formal documentation is unpaid work.
2. **Single PIC Rule**: On Medium to Enterprise projects, the Client must designate one absolute Person in Charge (PIC) to prevent client internal conflicts from burdening the developer.
3. **Locked Client Dependencies (Client Dependency SLA)**: Release schedules are tied to the client's speed in providing data, access, and approvals. Client delays automatically shift the timeline.
4. **Uncompromising Gates (Gated Delivery)**:
   - No coding without a Down Payment (DP) & written agreement.
   - No pointing production domains without UAT Pass.
   - No handover of source code or root credentials without 100% final settlement and signed BAST.
5. **Mandatory Turn-Stopping at Gates**:
   - **EVERY TIME A MODULE IS COMPLETED, THE AGENT MUST STOP (END TURN)**.
   - STRICTLY FORBIDDEN to batch-execute multiple modules automatically in a single interaction turn.
   - User permissions such as *"fill it in first, I'll review later"* ONLY apply to the currently active module, NOT a blank check to execute subsequent modules without stopping.
   - The agent MUST display a summary of the completed module artifacts and request explicit user approval before proceeding to the next module.

---

## 3. Project Scale Matrix & Fast-Track Mode

| Scale | Characteristic Boundaries | Module 01: Ideation & Feasibility | Modules 02–05: Specs & Design | Modules 06–09: QA & UAT | Modules 10–12: Release & BAST |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Small (MVP / Fast-Track)** | 1–4 weeks, 1–3 features, solo user | Use 1 file `PROJECT_LITE.md` (Combined M01-M03-M05) | **M04 MANDATORY for**: Web/Mobile/Desktop GUI. **M04 SKIP for**: CLI/API/cron | Core logic unit tests + smoke test | Direct PaaS deploy, email BAST |
| **Medium** | 1–3 months, Auth, DB, Payment/API | 4-Dimensional Feasibility, Market Validation | Modular PRD, Design System, FSD, API Contract | Automated API tests, SIT, signed PIC UAT | CI/CD pipeline, stamped BAST, 60-day warranty |
| **Large** | 3–6 months, multi-system integration | Initial Architecture Audit, Risk Analysis | Formal PRD, In-depth FSD, Context Map, WBS level 3 | Full test pyramid, Basic Pentest, staged formal UAT | Zero-downtime deploy, physical/digital BAST, 90-day warranty |
| **Enterprise** | ≥ 6 months, legal compliance, banking/SOE | PDP Law Audit, Compliance, Security Gate | Business Case, Formal Charter, PRD, FSD, RTM, DPA | Third-party Pentest, Disaster recovery drill, Formal UAT | CAB Approval, scheduled maintenance window, legal BAST, SLA |

**Warranty Period by Scale**:
- Small: 30 days
- Medium: 60 days
- Large: 90 days
- Enterprise: 90 days + optional SLA contract

---

## 4. Execution Module Status

- **Module 00: Product Discovery & Strategy**: `docs/modules/00-product-discovery-strategy.md` — Market research (TAM/SAM/SOM), competitor analysis, user interview research (JTBD), North Star Metric determination, and Value Proposition Canvas. **SKIP if**: Fast-Track MVP with tight deadlines.
- **Module 01: Idea & Feasibility**: `docs/modules/01-idea-feasibility.md` — 3-filter idea triage, 4-dimensional feasibility testing, extreme feature pruning, initial scale classification.
- **Module 02: Discovery & Scope Definition**: `docs/modules/02-discovery-scope.md` — Stakeholder requirements elicitation, user role mapping, MoSCoW breakdown, In-Scope vs Out-of-Scope locking, and client dependency register.
- **Module 03: [COMMERCIAL GATE] Legal SOW, DP, & Single PIC Agreement**: `docs/modules/03-legal-sow-charter.md` — Contract model selection, milestone payment terms, binding Single PIC agreement, Change Request protocol, and Down Payment security.
- **Module 04: UI/UX Design & Specification**: `docs/modules/04-uiux-prototyping.md` — Produces `DESIGN.md`, `docs/specs/DESIGN_SPEC.md`, and `docs/design/DESIGN_REFERENCES.md`; covers information architecture, scope-based sitemap & page inventory, shared component standards, states, responsive behavior, accessibility, asset needs, and Design Freeze. Interactive prototype optional.
  - Section 8: **Design System Foundation [M04B]** — Enterprise design systems with tokens, component libraries, Storybook, governance. **SKIP if**: Solo MVP <4 weeks.
- **Module 05: Architecture & Technical Specifications (PRD & FSD)**: `docs/modules/05-architecture-specs.md` — Tech stack selection (Boring Tech ladder), SQL DDL database schema, API contracts & error matrix, security architecture (PDP Law/AES-256), and FSD sign-off.
  - Section 6: **System Design & Infrastructure [M05B]** — Load balancing, Redis caching, DB sharding, high availability, capacity planning. **SKIP if**: Small projects.
- **Module 06: Development (Backend, Frontend, API Integration)**: `docs/modules/06-development-execution.md` — Repo & tooling setup, DB migration & local seeding, Zod-gated API implementation, component implementation, AES-256 streaming encryption, and self-smoke test.
  - Section 6A: **Analytics Setup [M06B]** — Mixpanel/Amplitude integration, event taxonomy, AARRR funnels, dashboards, error monitoring.
- **Module 07: Quality Assurance (Unit Test, SIT, & Security Audit)**: `docs/modules/07-quality-assurance-sit.md` — Solo dev testing pyramid, third-party SIT sandbox (Payment/Storage/Email), OWASP/PDP Law security audit, k6 load testing, and staging release.
- **Module 08: Data Migration & Seeding**: `docs/modules/08-data-migration-seeding.md` — Data hygiene protocol (Clean-In/Clean-Out), source-to-target column mapping, Staging PII masking sanitation, atomic ETL batch scripts, and data sign-off reconciliation.
- **Module 09: [VALIDATION GATE] Client UAT & Sign-Off in Staging**: `docs/modules/09-uat-client-signoff.md` — User testing in Staging, defect triage matrix (Severity 1/2/3/CR), scope creep repulsion, deemed acceptance clause, and signed UAT Report.
- **Module 10: Deployment & Production Go-Live**: `docs/modules/10-deployment-production.md` — Pre-release checklist (No Friday Deploy), git merge SemVer tagging, DNS/SSL TLS 1.3 configuration, mobile release Android Keystore & iOS TestFlight, zero-downtime DB migration, and PVT.
- **Module 11: [HANDOVER GATE] Settlement, Training, BAST, & Repository Handover**: `docs/modules/11-handover-bast.md` — Final invoice billing, training quota allotment (1–2 sessions), Git repo & encrypted credentials transfer (Bitwarden Send), and legally binding stamped BAST signing.
- **Module 12: Warranty Period & Transition to Monthly Retainer / SLA**: `docs/modules/12-warranty-sla-retainer.md` — Pure bug-fix warranty boundary enforcement, response/resolution SLA matrix, post-mortem emergency incident handling, and conversion to recurring monthly retainer contract.
- **Module 13: Product Operations & Continuous Iteration**: `docs/modules/13-product-operations-iteration.md` — 30-day post-launch baseline metrics collection, feedback loop & NPS automation, cohort retention analysis, growth experiment prioritization (RICE), and scaling signal monitoring.

---

## 5. Template Directory & File Placement Structure

> 📁 **ABSOLUTE FILE DISTRIBUTION RULES (FOLDER HYGIENE)**:
> - **Folder `docs/pm/`**: Exclusively for initiation, scoping, legal, and governance documents (`IDEA_BRIEF.md`, `SCOPE_STATEMENT.md`, `PROJECT_CHARTER.md`, `SOW_CONTRACT.md`, `BAST.md`, etc.).
> - **Folder `docs/specs/`**: Exclusively for technical specification and interface documents (`PRD.md`, `FSD.md`, `DESIGN_SPEC.md`).
> - **Root Directory (`./`)**: EXCLUSIVELY RESERVED ONLY FOR 7 AI HARNESS FILES (`AGENTS.md`, `CONTEXT.md`, `ARCHITECTURE.md`, `DESIGN.md`, `CONVENTIONS.md`, `.env.example`, `TODO.md`), `README.md`, and framework configuration. **Never place planning documents in root!**

### Fast-Track Mode
- `templates/03-architecture-specs/PROJECT_LITE_TEMPLATE.md`: Unified streamlined specification template (Idea + Scope + Commercial + DB Schema) for 1–4 week MVP projects. Saved to root (`./PROJECT_LITE.md`). *(Note: Module 04 Design workflow applies to Web/Mobile; Design specs optional).*

### Module 00 (Active)
- `templates/01-discovery-commercial/MARKET_RESEARCH_TEMPLATE.md`: Saved to **`docs/pm/MARKET_RESEARCH.md`** (TAM/SAM/SOM results, industry trends, regulatory landscape).
- `templates/01-discovery-commercial/COMPETITIVE_LANDSCAPE_TEMPLATE.md`: Saved to **`docs/pm/COMPETITIVE_LANDSCAPE.md`** (5-10 competitor analysis, feature matrix, SWOT, positioning map).
- `templates/01-discovery-commercial/USER_RESEARCH_REPORT_TEMPLATE.md`: Saved to **`docs/pm/USER_RESEARCH_REPORT.md`** (Interview/survey summaries, JTBD personas, user journey, pain matrix).
- `templates/01-discovery-commercial/PRODUCT_STRATEGY_TEMPLATE.md`: Saved to **`docs/pm/PRODUCT_STRATEGY.md`** (Vision/Mission, North Star Metric, Value Prop Canvas, Strategic Pillars).

### Module 01 (Active)
- `templates/01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md`: Saved to **`docs/pm/IDEA_BRIEF.md`** (Idea summary, elevator pitch, 3-filter triage, feasibility score).

### Module 02 (Active)
- `templates/01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md`: Saved to **`docs/pm/SCOPE_STATEMENT.md`** (MoSCoW scope agreement, RBAC, Out-of-Scope boundaries, SLA dependencies).

### Module 03 (Active)
- `templates/01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md`: Saved to **`docs/pm/SOW_CONTRACT.md`** (Legal commercial agreement, payment terms, liability cap, project charter).

### Module 04 - Advanced Templates
- `templates/02-design/DESIGN_SYSTEM_AUDIT_TEMPLATE.md`: Visual inconsistency audit template (color inventory, typography, spacing, component duplication). Saved to **`docs/design/DESIGN_SYSTEM_AUDIT.md`**.
- `templates/02-design/DESIGN_TOKENS_SPEC_TEMPLATE.md`: Design tokens specification template (primitive + semantic, color/typography/spacing/shadow/motion, platform outputs CSS/iOS/Android/Flutter). Saved to **`tokens/design-tokens.json`** + generated **`dist/css/variables.css`**.
- `templates/02-design/COMPONENT_API_SPEC_TEMPLATE.md`: Component documentation template (props, variants, states, accessibility checklist, usage examples, migration guide). Saved to **`docs/design/COMPONENT_API_SPEC.md`** per component.
> For M04 Section 8 (Design System Foundation) - Enterprise projects only.

### Module 04 (Active)
- `templates/02-design/DESIGN_MD_TEMPLATE.md`: Saved to root (**`./DESIGN.md`**) as source of truth for design tokens and component standards.
- `templates/02-design/DESIGN_SPEC_TEMPLATE.md`: Saved to **`docs/specs/DESIGN_SPEC.md`** (Information architecture, URL routes, scope-based page/sub-page inventory, states, responsive behavior, and Design Freeze sheet).
- `docs/design/DESIGN_REFERENCES.md`: Generated from visual search keywords for Pinterest, Behance, and Dribbble. Do not copy reference works directly.

### Module 05 (Active)
- `templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md`: Saved to **`docs/specs/PRD.md`** (Official product specifications, RBAC matrix, KPI metrics, NFR constraints).
- `templates/03-architecture-specs/FSD_TECHNICAL_TEMPLATE.md`: Saved to **`docs/specs/FSD.md`** (Technical architectural specifications, ERD, standard SQL DDL, JSON API contracts, security blueprint).

### Module 05 - Advanced Templates
- `templates/03-architecture-specs/SYSTEM_DESIGN_DOC_TEMPLATE.md`: Saved to **`docs/specs/SYSTEM_DESIGN_DOC.md`** (Large-scale system architecture specification, load balancing, caching, DB partitioning/sharding).
- `templates/03-architecture-specs/CAPACITY_PLANNING_TEMPLATE.md`: Saved to **`docs/specs/CAPACITY_PLANNING.md`** (MAU/RPS traffic projection, CPU/Memory utilization, and server/DB/Redis resource requirements).
- `templates/03-architecture-specs/DISASTER_RECOVERY_PLAN_TEMPLATE.md`: Saved to **`docs/specs/DISASTER_RECOVERY_PLAN.md`** (RPO/RTO disaster mitigation SOP, Multi-AZ failover scenarios, and recovery procedures).
- `templates/03-architecture-specs/DESIGN_PATTERN_DECISION_TREE_TEMPLATE.md`: Saved to **`docs/specs/DESIGN_PATTERN_DECISION_TREE.md`** (Software design pattern selection decision tree).
- `templates/03-architecture-specs/CODE_REVIEW_PATTERN_CHECKLIST_TEMPLATE.md`: Saved to **`docs/specs/CODE_REVIEW_PATTERN_CHECKLIST.md`** (Pattern evaluation and anti-pattern code review checklist).
> For M05 Section 6 (System Design & Infrastructure) - Large/Enterprise projects.

### Module 06 (Active - 7 Root Harness Files)
- `templates/04-dev-execution/AGENTS_TEMPLATE.md`: Saved to root (**`./AGENTS.md`**) — *MANDATORY OVERWRITE of framework default AGENTS.md (such as Next.js 15), never skip!*
- `templates/04-dev-execution/CONTEXT_TEMPLATE.md`: Saved to root (**`./CONTEXT.md`**) — Business summary & Out-of-Scope boundaries.
- `templates/04-dev-execution/ARCHITECTURE_TEMPLATE.md`: Saved to root (**`./ARCHITECTURE.md`**) — Technical FSD summary for AI consumption.
- `templates/04-dev-execution/CONVENTIONS_TEMPLATE.md`: Saved to root (**`./CONVENTIONS.md`**) — Code style conventions (kebab-case, Server Components, no barrel files).
- `templates/04-dev-execution/ENV_EXAMPLE_TEMPLATE.md`: Saved to root (**`./.env.example`**) — Standard environment variable dictionary.
- `templates/04-dev-execution/TODO_TEMPLATE.md`: Saved to root (**`./TODO.md`**) — Sequential atomic AI coding task queue.
- `templates/04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md`: Saved to **`docs/specs/RUNBOOK_LOCAL.md`** or root.
- `templates/04-dev-execution/VERIFY_LOCAL_TEMPLATE.md`: Saved to **`docs/specs/VERIFY_LOCAL.md`** or root.

### Module 06 - Advanced Templates
- `templates/09-product-growth/EVENT_TAXONOMY_TEMPLATE.md`: Event tracking taxonomy template with `verb_noun` convention, user properties, and super properties. Saved to **`docs/analytics/EVENT_TAXONOMY.md`**.
- `templates/09-product-growth/ANALYTICS_IMPLEMENTATION_PLAN_TEMPLATE.md`: Mixpanel/Amplitude SDK implementation plan template, tracking code locations, GDPR consent management, and QA checklist. Saved to **`docs/analytics/ANALYTICS_IMPLEMENTATION_PLAN.md`**.
- `templates/09-product-growth/DASHBOARD_SPEC_TEMPLATE.md`: Dashboard specification template for North Star Metric, AARRR funnel, cohort analysis, error monitoring, and alert thresholds. Saved to **`docs/analytics/DASHBOARD_SPEC.md`**.
> For M06 Section 6A (Analytics Setup) - Post-MVP or enterprise analytics.

### Module 07 (Active)
- `templates/06-qa-uat/SIT_WORKBOOK_TEMPLATE.md`: SIT (System Integration Testing) workbook template for third-party services in Staging.
- `templates/06-qa-uat/SECURITY_AUDIT_TEMPLATE.md`: OWASP Top 10 security vulnerability audit report template and PDP Law personal data compliance.

### Module 08 (Active)
- `templates/05-data-migration/DATA_MIGRATION_PLAN_TEMPLATE.md`: Source column mapping template to SQL database, data hygiene responsibility boundaries, and transformation rules.
- `templates/05-data-migration/RECONCILIATION_REPORT_TEMPLATE.md`: Quantitative reconciliation report template for imported vs rejected data rows and Client Data Sign-Off sheet.

### Module 09 (Active)
- `templates/06-qa-uat/UAT_WORKBOOK_TEMPLATE.md`: Combined UAT workbook template (testing guide + defect log) for non-technical users on the Staging server.
- `templates/06-qa-uat/UAT_SIGNOFF_TEMPLATE.md`: Official User Acceptance Testing Sign-Off Report (UAT Sign-Off) signed by the Client Single PIC.

### Module 10 (Active)
- `templates/07-release-handover/DEPLOYMENT_PROTOCOL_TEMPLATE.md`: Technical guide template for production release steps, DNS/SSL check, and live secrets.
- `templates/07-release-handover/ROLLBACK_PLAN_TEMPLATE.md`: Emergency 15-minute rollback procedure template for fatal go-live failure recovery.

### Module 11 (Active)
- `templates/07-release-handover/USER_MANUAL_TEMPLATE.md`: User operational manual template for system staff and administrators.
- `templates/07-release-handover/HANDOVER_PROTOCOL_TEMPLATE.md`: Handover protocol template for Git repository ownership transfer and encrypted credential handover.
- `templates/07-release-handover/BAST_TEMPLATE.md`: Official Project Handover Certificate (BAST) with legal Rp 10.000 stamp, officially triggering the warranty period.

### Module 12 (Active)
- `templates/08-maintenance-ops/WARRANTY_POLICY_TEMPLATE.md`: Official policy template for warranty boundaries, service support hours, and covered defect definitions.
- `templates/08-maintenance-ops/SLA_RETAINER_CONTRACT_TEMPLATE.md`: Recurring monthly maintenance agreement (Monthly Retainer SLA) for recurring revenue.
- `templates/08-maintenance-ops/INCIDENT_RESPONSE_TEMPLATE.md`: Standard operating procedure (SOP) for production emergency incident response and root cause analysis (RCA).

### Module 13 (Active)
- `templates/09-product-growth/METRICS_BASELINE_REPORT_TEMPLATE.md`: Saved to **`docs/analytics/METRICS_BASELINE_REPORT.md`** (First 30 days post-launch metrics baseline report).
- `templates/09-product-growth/GROWTH_EXPERIMENTS_BACKLOG_TEMPLATE.md`: Saved to **`docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md`** (Growth experiments backlog with RICE scoring and results tracking).
- `templates/09-product-growth/PRODUCT_HEALTH_DASHBOARD_TEMPLATE.md`: Saved to **`docs/pm/PRODUCT_HEALTH_DASHBOARD.md`** (Product health dashboard for periodic review).

---

## 6. Framework Automation & Tooling

- **Package Version Checker**: See [`docs/package-version-auto-check.md`](./package-version-auto-check.md) for real-time package version verification (`check-package-versions.sh` / `.ps1`) to avoid AI knowledge cutoff regressions.
- **Gate Validation CLI**: Run `./scripts/validate-gate.sh` to programmatically verify quality gates between modules.
