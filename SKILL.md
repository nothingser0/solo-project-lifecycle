---
name: solo-project-lifecycle
description: Comprehensive skill framework for managing software project lifecycle from discovery to production, featuring a 1,000-system catalog across 4 scales, 250 industry software archetypes, and October 2026 modern tech stack benchmarks. Gunakan saat memulai proyek baru, riset pasar, analisis kompetitor, klasifikasi arketipe sistem, validasi kelayakan ide, pembuatan PRD, FSD, SOW, BAST, SPK, scoping client work, planning architecture anti-overkill, kepatuhan UU PDP, integrasi payment gateway Indonesia, atau mengelola full SDLC solo/tim. Use when starting projects, scoping client work, writing specs, or managing full SDLC. Do NOT use for one-off throwaway scripts, single-file bug fixes, or routine coding syntax questions.
version: 1.0.0
updated: 2026-10-08
---

# Solo Project Lifecycle

**Skill framework** (~3.9MB content, 270+ files) providing structured SDLC for solo developers and small teams. 14 modules from discovery through post-launch maintenance, backed by a 1,000-system taxonomy, 250 industry software archetypes, and October 2026 tech stack benchmarks across 17 engineering domains.

## Framework architecture

This is a **comprehensive skill toolkit**, not a single loadable skill file:

- **Entry point**: This SKILL.md file (8KB) - lightweight navigation guide
- **Module library**: 14 modules in `docs/modules/` loaded on-demand per project phase
- **Taxonomy & catalog**: 250 industry archetypes and 1,000 system variations in `references/taxonomy/`
- **Template library**: 150+ templates in `templates/` by use case and phase
- **Reference materials**: 600KB guides, playbooks, case studies in `references/`
- **Code patterns**: Reusable validation/auth/performance patterns in `patterns/`

**Size justification**: Framework completeness = utility. Agents read specific modules/templates on-demand, not entire 3.9MB at once. Similar to testing-library or design systems - comprehensive by design. Disk size verified via `./scripts/calculate-size.sh`.

**Usage model**: Clone repo → agent navigates via SKILL.md → loads relevant module → applies template → references patterns as needed.

---

## Critical: Project Directory Separation

**Framework repo is read-only**. User projects are created in separate directories.

**Agent workflow for new projects**:

1. **Pre-scaffold phase** (M01-M05): Generate PM/spec docs + stage harness files
   - Write: `docs/pm/`, `docs/specs/`, `docs/harness-root/`
   - `docs/harness-root/` contains 9 files: AGENTS.md, ARCHITECTURE.md, CONTEXT.md, CONVENTIONS.md, DESIGN.md, TODO.md, .env.example, RUNBOOK_LOCAL.md, VERIFY_LOCAL.md
   - User can inspect staged files before scaffold

2. **Scaffold phase** (M06): User runs framework CLI (create-next-app, laravel new, etc.)
   - Framework generates its boilerplate in root

3. **Harness deployment** (M06 continuation): Agent copies staged files to root
   - Source: `docs/harness-root/*` and `docs/harness-root/.env.example`
   - Target: `./` (project root: `cp docs/harness-root/* ./ && cp docs/harness-root/.env.example ./`)
   - Overwrites framework boilerplate (e.g., Next.js AGENTS.md)

> ⛔ **STRICT ORDERING (MANDATORY — NEVER REORDER)**: The 4 steps below MUST run in this exact sequence. Deleting `docs/harness-root/` BEFORE the copy succeeds destroys the only source of the 9 harness files and is **STRICTLY PROHIBITED**.
> 1. **Scaffold finishes first**: framework CLI (`create-next-app`, `laravel new`, `django-admin startproject`, `go mod init`, etc.) MUST have completed in root.
> 2. **Copy staging → root**: `cp docs/harness-root/* ./ && cp docs/harness-root/.env.example ./`
> 3. **Verify 9 files exist in root**: `ls -1 | grep -E '^(AGENTS|CONTEXT|ARCHITECTURE|DESIGN|CONVENTIONS|TODO|RUNBOOK_LOCAL|VERIFY_LOCAL)\.md$'; ls -1 .env.example` → must list all 9. Gate aborts if any missing.
> 4. **Only then delete staging**: `rm -rf docs/harness-root/` (enforces Single Source of Truth; git history is the immutable backup).
>
> If scaffold has NOT run yet, keep `docs/harness-root/` intact. NEVER run step 4 unless step 3 passed.

**File placement rules**:
- **Framework repo**: READ templates only (skill:// paths)
- **User project staging**: `docs/harness-root/` (before scaffold)
- **User project root**: `./` (after scaffold, copy from staging)

## When to invoke

- User mentions starting new project, MVP, or client work
- Market research, competitor analysis, problem validation, or idea feasibility
- Needs PRD, FSD, SOW, or technical specs
- Planning development phases or timeline
- Managing project with gates (SOW, UAT, handover)
- Building with proper architecture (not ad-hoc coding)

## When NOT to invoke

- One-off throwaway helper scripts without project lifecycle scope (e.g., "write a regex to parse a string")
- Single-file bug fixes or routine syntax questions where project architecture is already settled
- Non-software requests or general chat

## Language & Regional Context

**Language mirroring**: Reply and draft project documents in the user's primary language. If the user communicates in Indonesian, write conversational answers and project deliverables in clear, professional Indonesian. If in English, write in English.

**Indonesia-first practical context**: The skill framework natively supports Indonesian commercial, legal, and regulatory standards (SOW/SPK, Down Payment/milestones, BAST handover, UU PDP No. 27/2022, e-Meterai, Komdigi Private PSE registration, PPN 11%/PKP taxation, OSS-RBA KBLI business classification, and QRIS/Midtrans/Xendit payment gateways).

## Core rules

**Mandatory gate execution before declaration**: Agents MUST run the official gate validation script (`./scripts/gates/validate-gate.sh <MODULE>` or `.ps1`) and output the exact command output BEFORE declaring ANY module complete, presenting summaries, or stopping turn.
  - Self-declared completion without running the validator script is STRICTLY PROHIBITED.
  - If the script exits with code 1 (`Gate validation FAILED`), the module is INCOMPLETE. Do NOT declare completion, do NOT print pre-filled success checklists (`✅`), and do NOT ask for user approval to proceed. Fix the missing or undersized artifacts first, re-run the gate, and repeat until exit code 0.
  - **Design Pre-Condition (M04)**: `DESIGN.md` CANNOT be drafted until (1) brand logo asset exists in `assets/logo/` (`logo.svg` / `logo.png`) and (2) primary benchmark selection ("paling OK") is recorded in `docs/design/inspiration/notes.md`. If either is missing, generation halts.
  - *Why*: Prose checklists allow hallucinated completion. Exact machine validation (tokens, minimum file sizes, and non-empty artifacts) is the ONLY authoritative definition of done across all 14 modules.

**Mandatory turn-stopping**: Stop after EVERY module completion. Present artifacts summary, request explicit approval before next module. User saying "fill it in first" applies ONLY to current module, NOT permission to chain-execute.
  - *Why*: Downstream engineering decisions (schema, APIs, code) directly depend on upstream scope and commercial locks. Chained execution without review accumulates cascading mistakes that cost $5\times$ more to refactor later.
  - *Autopilot Exception (Small MVP Only)*: If the user explicitly authorizes fast-track execution (e.g., *"autopilot", "jalankan langsung tanpa berhenti", "chain-execute"*), the agent MAY proceed through M04 → M05 → M06 without stopping at intermediate phase boundaries, provided all generated specifications pass verification and no fatal blockers are encountered.

**Template-first enforcement**: NEVER generate empty or freeform documents from module guideline prose alone. ALWAYS copy from the official template in `templates/` and populate it systematically.
  - *Why*: Module guidelines provide educational theory, but templates contain the exact standardized section headings, compliance disclaimers, and validation tables required by downstream linters and CI scripts.

**Cross-document consistency**: Verify downstream documents against upstream approved artifacts (Scope Statement $\rightarrow$ Sitemap $\rightarrow$ Component Specs $\rightarrow$ PRD/FSD $\rightarrow$ DB Schema $\rightarrow$ Code).
  - *Why*: Discrepancies between scope definitions and database schemas cause authorization holes, missing columns, and wasted sprint cycles.

**Anti-over-specification & reusability**: Strictly enforce YAGNI. Prefer standard native platform capabilities and existing component primitives. Do not invent one-off components without explicit requirement in `SCOPE_STATEMENT.md`.
  - *Why*: Unrequested abstractions and superfluous components introduce technical debt and maintenance burden for solo developers.

**Evidence rule for primary research**: Primary research data (interviews, surveys, willingness to pay) MUST originate from real human users. Agents MUST NOT fabricate interview transcripts or survey numbers. Draft the research instruments, mark outputs as `PENDING`, and set gate status to `PENDING_PRIMARY_RESEARCH`.
  - *Why*: Synthetic interview quotes provide false confidence, leading founders to invest months building software that nobody wants to buy.

**Data confidence legend**: Every factual claim and persona MUST include confidence markers:
- ✅ **VERIFIED**: Empirical data from real users, live analytics, or cited primary sources (with URL and date).
- 🔶 **ASSUMPTION**: Working hypothesis that must be tested before scaling.
- ❓ **UNKNOWN**: Information gap requiring research or user input.

**Riskiest assumption first (RAT)**: Maintain an Assumption Register. Prioritize testing the riskiest assumption with the cheapest test before building features.

**Scope protection**: No feature addition without formal docs. No unpaid work.
  - *Why*: Scope creep without contractual Change Requests destroys profitability and project delivery timelines.

**Security**: NEVER ask user to paste secrets (API keys, tokens, passwords) in chat. Guide user to write directly to `.env.local` or config files. Verify file exists without reading content.
  - *Why*: Secrets pasted into LLM chats risk leakage into logs, shell history, and context windows.

**Gate enforcement** (client projects only):
- Commercial gate (M03): No coding without signed SOW + down payment
- Validation gate (M09): No production deploy without UAT sign-off
- Handover gate (M11): No code/credentials transfer without 100% payment + signed BAST

**Progressive loading**: Load specific module file ONLY when entering that phase. Don't preload all modules.

## Project scale

**Classification by Engineering Risk & Scope (High-Water Mark Rule)**:
Scale classification is driven by **engineering risk profile and operational load**, NOT arbitrary currency/budget metrics.

### The 5 Engineering Dimensions:
1. **P0 Must-Have Feature Count**: Scope boundary locked to Must-Have (P0) only (P1 Should-Have is excluded from scale calculation).
2. **Blast Radius & Data Sensitivity**: Operational blast radius of bugs (cosmetic vs financial mutation vs health/regulated data).
3. **Stakeholder & Approval Drag**: 1 solo founder vs 1 client PIC vs multi-tier corporate boards.
4. **Target Availability & SLA**: Informal best-effort vs 99.0% vs 99.9% 24/7 uptime guarantee.
5. **External Integrations & Webhooks**: Isolated DB vs asynchronous webhook settlement (Payment, logistics, banking).

> ⚖️ **HIGH-WATER MARK RESOLUTION RULE (MANDATORY)**:
> When dimensions diverge, **THE HIGHEST APPLICABLE TIER DETERMINES THE SCALE**.
> Example: A project with only 3 P0 features (Small) that processes financial transactions with payment gateway webhooks (Medium/High blast radius) **MUST BE CLASSIFIED AS MEDIUM** and cannot bypass architecture or testing gates.

---

### 4 Scale Tiers:

**Small / Fast-Track MVP**:
- **Criteria**: 1–3 core flows, 3–7 P0 Must-Haves, isolated DB, low blast radius (no financial mutations/health data), 1 decision maker, best-effort availability, <4 weeks.
- **Path**: **Intake → M04-LITE → M05 → [STOP 1] → M06 (incl. security) → M09-LITE → [STOP 2] → M10 → M12 (RUNBOOK_OPS.md)**
  - *Client delivery only*: add **M03** (before M04-LITE) and **M11** (after M10).
  - **Intake** (replaces M00/M01/M02 for small): 5 mandatory questions — project type, success metric, must-have features + explicit non-features, time capacity, login/sensitive data. Answers recorded as fields in `docs/pm/PROJECT_STATE.md`; agent STOPS until answered.
  - **M04-LITE**: logo placeholder from initials allowed; 1 benchmark suffices; full 5-state matrix only for primary screens.
  - **M06** absorbs M07: Sprint 0 deploys hello-world to staging; per-feature build + lint + `tsc --noEmit` + main-flow test + two-account check + `SECURITY_CHECKLIST_SMALL.md`.
  - **M09-LITE**: minimum 1 external tester (name recorded) in `docs/qa/UAT_SIGNOFF_SMALL.md`.
  - **M12-LITE**: `RUNBOOK_OPS.md` (rollback, backup, monitoring) replaces warranty doc for non-client delivery.
  - **Stop points (2 only)**: after design+spec (STOP 1), and before deploy (STOP 2). Intake also halts until questions answered.
  - **Legacy data rule**: existing/legacy data is NOT "small + M08"; it triggers **re-classification to Large** (High-Water Mark) and leaves the small path.
- Template: `templates/03-architecture-specs/PROJECT_LITE_TEMPLATE.md`
- Example: Landing page, portfolio site, simple CRUD app

**Independent / Self-Initiated Product (Solo SaaS, Developer Tool)**:
- **Criteria**: 8–15 P0 Must-Haves, subscription billing / payments, user data residency, 1 solo founder, 99.0% availability target, 1–3 months.
- Path: **M00-lite** → M01 → M02 → M04 → M05 → M06 → M07 → M10 → M12 → M13
- Template: `templates/01-discovery-commercial/M00_LITE_TEMPLATE.md` + Full PRD/FSD
- Validates market/user demand via M00-lite, skips external client contract gates (M03, M11). Commercial model adapts to product (SaaS subscription, one-off download, or free open-source).
- Example: Independent micro-SaaS, desktop tool (Tauri), open-source developer utility

**Bespoke Freelance & Client Commercial (Agency / Mid-Tier)**:
- **Criteria**: 8–15 P0 Must-Haves, external API/payment webhooks, fixed commercial contract with 1 Client Single PIC, 99.0% SLA, 1–3 months.
- Path: M01 → M02 → **M03** → M04 → M05 → M06 → **M07** → **M09** → M10 → **M11** → M12
- Templates: Full PRD/FSD in `templates/03-architecture-specs/`
- Example: Custom bespoke business portal, e-commerce, internal company tool, academic software deliverable

**Beyond Solo Capacity: Large & Enterprise Scale (A-Series Advisory Lifecycle)**:
- **Criteria**: >15 P0 Must-Haves, multi-branch, high financial/medical blast radius, or statutory compliance (OJK/BI/UU PDP/ISO 27001).
- ⛔ **STRICT SOLO CODING PROHIBITION**: Single-developer implementation is strictly prohibited. The solo practitioner acts as **Lead Enterprise Architect / Technical Advisor**.
- **Path (A00-A04 Architecture & Procurement Readiness Package)**:
  - **A00**: Pre-Sales, Administrative Eligibility, Bid/No-Bid Decision & `CONSULTING_AGREEMENT.md` (Net 30, liability cap, anti-conflict pact).
  - **A01**: Work Breakdown Structure (WBS) & Phasing (decomposes scope into autonomous Medium sub-projects; isolates legacy core banking/ERP spikes).
  - **A02**: C4 Architecture Blueprint, Threat Modeling (STRIDE), Local Data Residency ADR (AWS Jakarta / on-premise), ATAM Quality Scenarios.
  - **A03**: Vendor Procurement Specifications, Build-vs-Buy Analysis, Weighted Evaluation Matrix & Anti-Lock-In Exit Strategy.
  - **A04**: Governance Handover (RACI, CAB Process, DR Plan for client team) & Architecture Conformance Review Retainer.
- Example: Regional banking portal, multi-tenant hospital network, nationwide retail supply chain.

---

**Client project gates** (adds M03, M09, M11 to path above):

**If paid client work**: Add these gates regardless of complexity
- **M03** (before M04): SOW contract + down payment → Commercial gate
- **M09** (before M10): UAT sign-off → Validation gate
- **M11** (after M10): BAST + full payment → Handover gate

**If solo/portfolio**: Skip gates, use complexity path only

**Examples**:
- Solo portfolio (3 features): Small path → Intake → M04-LITE → M05 → [STOP 1] → M06 (+security) → M09-LITE → [STOP 2] → M10 → M12
- Solo SaaS (8 features): Solo SaaS path → M00-lite → M01 → M02 → M04 → M05 → M06 → M07 → M10 → M12 → M13
- Client SaaS (8 features): Medium + gates → M01 → M02 → **M03** → M04 → M05 → M06 → **M07** → **M09** → M10 → **M11** → M12

## Enterprise Advisory Series (Non-Solo Capacity)
- **A00-A04**: `A00-enterprise-advisory-series.md` - Pure architecture, STRIDE threat modeling, WBS phasing, vendor procurement, and governance advisory.

## Module structure

Load module files from `docs/modules/` on demand:

**Discovery** (skip for MVPs):
- M00: `00-product-discovery-strategy.md` - Market research, competitor analysis
- M01: `01-idea-feasibility.md` - 4-dimension feasibility scoring

**Planning**:
- M02: `02-discovery-scope.md` - MoSCoW prioritization, RBAC, scope lock
- M03: `03-legal-sow-charter.md` - SOW contract, down payment, Single PIC [GATE 1]

**Design**:
- M04: `04-uiux-prototyping.md` - UI/UX design, wireframes, DESIGN.md
- M05: `05-architecture-specs.md` - PRD, FSD, database schema, API contracts

**Development**:
- M06: `06-development-execution.md` - Backend, frontend, 9 root harness files
- M07: `07-quality-assurance-sit.md` - Tests, security audit, staging
- M08: `08-data-migration-seeding.md` - ETL, data reconciliation
- M09: `09-uat-client-signoff.md` - Client UAT, sign-off [GATE 2]

**Launch**:
- M10: `10-deployment-production.md` - Production deploy, DNS/SSL
- M11: `11-handover-bast.md` - BAST signing, credentials transfer [GATE 3]
- M12: `12-warranty-sla-retainer.md` - Warranty period, SLA retainer
- M13: `13-product-operations-iteration.md` - Metrics, iteration

## Templates location

All templates in `templates/` directory:

**Fast-track**: `templates/essentials/` (8 most-used)

**By use case**:
- `by-use-case/mvp-fast-track/` - Solo MVP projects
- `by-use-case/client-commercial/` - Paid client work
- `by-use-case/technical-specs/` - Architecture-heavy
- `by-use-case/operations/` - Post-launch maintenance

**By phase** (match module number):
- `00-pre-sales-enterprise/` - RFP response, POC plans
- `01-discovery-commercial/` - Market research, SOW, scope
- `02-design/` - Design specs, prototypes
- `02-legal-commercial/` - Financial tracking, SMB SOW
- `03-architecture-specs/` - PRD, FSD, system design
- `03-governance/` - Enterprise governance (ADR, RACI, compliance, incident response)
- `04-dev-execution/` - AGENTS.md, CONTEXT.md, TODO.md, RUNBOOK_LOCAL.md, VERIFY_LOCAL.md (9 root harness files)
- `05-data-migration/` - Migration plans
- `06-qa-uat/` - Test plans, security audits
- `07-release-handover/` - Deployment, BAST
- `08-maintenance-ops/` - SLA, incident response
- `09-product-growth/` - Analytics, A/B tests

## File placement rules

**docs/pm/**: Planning & governance (IDEA_BRIEF.md, SCOPE_STATEMENT.md, SOW_CONTRACT.md, BAST.md)

**docs/specs/**: Technical specs (PRD.md, FSD.md, DESIGN_SPEC.md)

**Root (./)**: Reserved for 9 AI harness files ONLY (AGENTS.md, CONTEXT.md, ARCHITECTURE.md, DESIGN.md, CONVENTIONS.md, .env.example, TODO.md, RUNBOOK_LOCAL.md, VERIFY_LOCAL.md). Never put PM docs in root.

## Scripts

Validation tools in `scripts/` (bash + PowerShell):

```bash
# Validate gate checkpoints (covers M00 through M13)
./scripts/gates/validate-gate.sh M03              # Commercial gate
./scripts/gates/validate-gate.sh M06              # Harness gate
./scripts/gates/validate-gate.sh M09              # UAT signoff gate
./scripts/verify/check-package-versions.sh nextjs  # Real-time package registry checks
./scripts/verify/verify-framework-version.sh       # Verify lockfile matches FSD (Next.js, Laravel, Django, Go)

# Initialize new project per scale (small | solo-saas | medium | large)
./scripts/scaffold/init-project.sh ~/projects/my-app solo-saas

# Check template completeness
./scripts/verify/lint-template.sh path/to/template.md

# Template picker (interactive or headless)
./scripts/scaffold/template-picker.sh                # Interactive menu
./scripts/scaffold/template-picker.sh --phase 8 --dry-run  # Fast-track MVP dry-run

# Verify TODO checklist completion
./templates/04-dev-execution/TODO_VERIFICATION_SCRIPT.sh TODO.md

# Pre-install dependency compatibility check
./templates/04-dev-execution/scripts/check-dependencies.sh
```

PowerShell: Same commands, use `.ps1` extension.

## References

Deep-dive guides in `references/`:
- `taxonomy/` - 250 standard industry archetypes (`SYSTEM_ARCHETYPES_250.md`) & 1,000 system variations across 4 complexity tiers (`PROJECT_CATALOG_1000.md`)
- `checklists/` - Feasibility criteria, evaluation
- `playbooks/` - AI development, design patterns
- `pm/` - Analytics setup, prioritization, communication
- `pre-sales/` - Discovery calls, proposals, quotations
- `solo/` - Solo dev architecture, patterns, engineering standards
- `stacks/` - 2026 official stable benchmarks (Laravel 13, Go 1.27, Spring Boot 4.1, .NET 10, Tauri 2.12, Svelte 5, FastAPI 0.142), anti-overkill selection matrix, and stack quickstarts
- `technical/` - Deep research, compliance, design systems, APM, mobile architecture

Load references when entering relevant module. Don't preload all.

## Code patterns

Reusable patterns in `patterns/`:
- `validation/` - Zod schemas, form validation
- `security/` - Authentication, encryption
- `performance/` - N+1 prevention, caching
- `api/` - REST conventions, GraphQL & versioning
- `database/` - Migrations, transactions, seeding
- `payments/` - Indonesian payment gateways (Midtrans, Xendit, QRIS, idempotent webhooks)
- `compliance/` - Indonesian UU PDP No. 27/2022 data protection patterns
- `offline/` - Local-first caching, mutation queue, and conflict resolution
- `observability/` - Structured Pino JSON logging, trace correlation IDs, Sentry
- `localization/` - Indonesian Rupiah formatting, WIB/WITA/WIT, statutory tax rounding
- `deployment/` - CI/CD pipeline automation
- `error-handling/` - Error boundaries and resilience
- `git-workflow/` - Branching, commit conventions
- `testing/` - Test pyramid, unit/integration strategies

## Case studies

Real projects in `case-studies/` (reference for timelines/budgets):
- `01-mvp-saas-inventory.md` - 4 weeks, 200 users
- `02-ecommerce-fashion-mvp.md` - 21 days, Rp 52M GMV
- `03-crm-real-estate-internal.md` - 28 days, +58% revenue
- `04-medium-b2b-saas-worked-example.md` - 12 weeks, B2B multi-tenant SaaS
- `05-large-system-integration-worked-example.md` - 25 weeks, legacy integration & migration

## Tech stack support
Stack-agnostic. Quickstart guides in `references/stacks/`:

- Frontend: React, Next.js (v15–v16+), Vue, Svelte
- Backend: Node.js, Laravel (v11–v13+), Django (v5–v6+), Go (v1.23–v1.27+)
- Database: PostgreSQL, MySQL, Supabase
- Deploy: Vercel, Railway, AWS, DigitalOcean

## Anti-patterns

**Don't**:
- Load all modules at once (use progressive loading)
- Chain-execute modules without user approval
- Skip gates on client projects
- Put PM docs in root directory
- Add features without formal docs (scope creep)
- Code before SOW signed (client projects)
- Deploy before UAT pass
- Transfer code before final payment

## Framework overview

Complete guide: `docs/README.md`
Quick start: `docs/quickstart.md` (MVP 2-4 week path)
Module details: `docs/modules/` (load on demand)
