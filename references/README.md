# References Library Catalog

Comprehensive index of all 36 engineering guides, checklists, playbooks, stack quickstarts, and pre-sales references in the `references/` directory.

---

## Directory Structure

```
references/
├── checklists/          (4 files)  - Feasibility criteria, evaluation checklists, elicitation guides
├── taxonomy/            (2 files)  - 250 industry software archetypes, 1,000 project catalog
├── playbooks/           (3 files)  - AI-assisted development, design patterns, scale workflows
├── pm/                  (6 files)  - Prioritization, analytics, communication, testing, tooling
├── pre-sales/           (3 files)  - Discovery call checklists, proposals, quotation templates
├── solo/                (4 files)  - Solo developer architecture, patterns, standards, UI/UX
├── stacks/              (6 files)  - Decision metrics, 2026 support matrix & anti-overkill, quickstarts
└── technical/          (13 files)  - Deep research, design systems, APM, compliance, animation, deep-dives
```

---

## 1. Checklists (`references/checklists/`)

| File | Purpose | Referenced In |
|---|---|---|
| [`FEASIBILITY_CRITERIA.md`](./checklists/FEASIBILITY_CRITERIA.md) | 4-dimensional feasibility scoring rubric (Technical, Economic, Operational, Legal) | Module 01 |
| [`MODULE_01_ACTION_ITEMS_CHECKLIST.md`](./checklists/MODULE_01_ACTION_ITEMS_CHECKLIST.md) | Post-feasibility execution checklist: Market validation, formula audit, security baseline | Module 01 |
| [`MODULE_02_EVALUATION_CHECKLIST.md`](./checklists/MODULE_02_EVALUATION_CHECKLIST.md) | MoSCoW quality check, INVEST user stories, database validation, NFR realism check | Module 02 |
| [`REQUIREMENT_ELICITATION_GUIDE.md`](./checklists/REQUIREMENT_ELICITATION_GUIDE.md) | 5-pillar elicitation question bank and red-flags detection for client discovery | Module 02 |

---

## 2. Taxonomy & System Catalogs (`references/taxonomy/`)

| File | Purpose | Referenced In |
|---|---|---|
| [`SYSTEM_ARCHETYPES_250.md`](./taxonomy/SYSTEM_ARCHETYPES_250.md) | Standard 250 industry software archetypes, acronyms, and classification definitions | Module 00, 01 |
| [`PROJECT_CATALOG_1000.md`](./taxonomy/PROJECT_CATALOG_1000.md) | 1,000 deduplicated system ideas across 4 implementation tiers (Small, Medium, Large, Enterprise) | Module 00, 01, 05 |

---

## 3. Playbooks (`references/playbooks/`)

| File | Purpose | Referenced In |
|---|---|---|
| [`SCALE_WORKFLOWS.md`](./playbooks/SCALE_WORKFLOWS.md) | Tiered execution workflows across Small (MVP), Medium, Large, and Enterprise scales | Module 00–13 |
| [`ai-assisted-development.md`](./playbooks/ai-assisted-development.md) | Prompt engineering patterns, multi-file AI orchestration, pre-merge review protocol | Module 06, 07 |
| [`software-design-patterns.md`](./playbooks/software-design-patterns.md) | Clean code principles, SOLID, Repository/Service layer patterns, anti-pattern detection | Module 05, 06 |

---

## 4. Product Management (`references/pm/`)

| File | Purpose | Referenced In |
|---|---|---|
| [`PM_ANALYTICS_SETUP_GUIDE.md`](./pm/PM_ANALYTICS_SETUP_GUIDE.md) | Event taxonomy, funnel design, metric baselines (Mixpanel, GA4, PostHog) | Module 06 |
| [`PM_COMMUNICATION_GUIDE.md`](./pm/PM_COMMUNICATION_GUIDE.md) | Stakeholder management, status updates, client expectation setting, meeting cadences | Module 02 |
| [`PM_CONTINUOUS_IMPROVEMENT_GUIDE.md`](./pm/PM_CONTINUOUS_IMPROVEMENT_GUIDE.md) | Post-launch iteration loops, NPS feedback, bug triage, retrospective facilitation | Module 13 |
| [`PM_PRIORITIZATION_FRAMEWORKS.md`](./pm/PM_PRIORITIZATION_FRAMEWORKS.md) | RICE scoring formula, reach/impact/confidence rubrics, backlog prioritization worksheets | Module 01, 13 |
| [`PM_TOOLS_SETUP_GUIDE.md`](./pm/PM_TOOLS_SETUP_GUIDE.md) | Configuration guide for Linear, Jira, GitHub Projects, Notion for solo dev workflows | Module 01 |
| [`PM_USER_TESTING_GUIDE.md`](./pm/PM_USER_TESTING_GUIDE.md) | User testing facilitation scripts, usability test plans, SUS scoring calculation | Module 04 |
| [`INDUSTRY_TOOLS_ADAPTER.md`](./pm/INDUSTRY_TOOLS_ADAPTER.md) | Integration bridge for Notion databases, Linear/Jira CSV import, and remote Figma MCP | Module 01, 04 |

---

## 5. Pre-Sales (`references/pre-sales/`)

| File | Purpose | Referenced In |
|---|---|---|
| [`DISCOVERY_CALL_CHECKLIST.md`](./pre-sales/DISCOVERY_CALL_CHECKLIST.md) | Pre-sales client intake questionnaire, budget qualification, timeline reality checks | Module 00 |
| [`PROPOSAL_DECK.md`](./pre-sales/PROPOSAL_DECK.md) | Commercial proposal slide outline, pitch structure, scope packaging, value pricing | Module 00 |
| [`QUOTATION_EMAIL.md`](./pre-sales/QUOTATION_EMAIL.md) | Professional quotation email templates, payment milestone terms, engagement options | Module 03 |

---

## 6. Solo Engineering (`references/solo/`)

| File | Purpose | Referenced In |
|---|---|---|
| [`SOLO_ARCHITECTURE_GUIDE.md`](./solo/SOLO_ARCHITECTURE_GUIDE.md) | Boring Tech Ladder, PostgreSQL JSONB, Modular Monoliths, PaaS hosting prioritization | Module 05 |
| [`SOLO_DEVELOPMENT_PATTERNS.md`](./solo/SOLO_DEVELOPMENT_PATTERNS.md) | Zod runtime guards, AES-256-GCM encryption, pessimistic locking, presigned URLs | Module 06 |
| [`SOLO_ENGINEERING_STANDARDS.md`](./solo/SOLO_ENGINEERING_STANDARDS.md) | Git branching, OWASP compliance, N+1 query prevention, connection pooling, asset budgets | Module 06 |
| [`SOLO_UIUX_GUIDE.md`](./solo/SOLO_UIUX_GUIDE.md) | Solo dev UI/UX efficiency, design tokens in Markdown, WCAG contrast, Design Freeze | Module 04 |

---

## 7. Tech Stacks (`references/stacks/`)

| File | Purpose | Referenced In |
|---|---|---|
| [`STACK_DECISION_METRICS.md`](./stacks/STACK_DECISION_METRICS.md) | Build time, incremental compile, cold start benchmarks across major web frameworks | Module 05 |
| [`STACK_SUPPORT_MATRIX.md`](./stacks/STACK_SUPPORT_MATRIX.md) | Supported language & framework evaluation matrix, tooling maturity, verification gates | Module 05 |
| [`django-quickstart.md`](./stacks/django-quickstart.md) | Django (v5–v6+) + Python 3.12+ + PostgreSQL 16+ + Celery setup & live version verification guide | Module 06 |
| [`go-quickstart.md`](./stacks/go-quickstart.md) | Go (v1.23–v1.27+) + Fiber/Echo/Chi + PostgreSQL 16+ setup & live version verification guide | Module 06 |
| [`laravel-quickstart.md`](./stacks/laravel-quickstart.md) | Laravel (v11–v13+) + PHP 8.3+ + MySQL/PostgreSQL + Livewire/Inertia setup & live version verification guide | Module 06 |
| [`nextjs-quickstart.md`](./stacks/nextjs-quickstart.md) | Next.js (v15–v16+) + React 19+ + TypeScript + Prisma/Supabase setup & live version verification guide | Module 06 |

---

## 8. Technical Engineering & Research (`references/technical/`)

| File | Purpose | Referenced In |
|---|---|---|
| [`AI_DEVELOPMENT_TOOLS_COMPARISON.md`](./technical/AI_DEVELOPMENT_TOOLS_COMPARISON.md) | Benchmark & selection guide for AI coding assistants (Cursor, Claude Code, Windsurf) | Module 04, 06 |
| [`APM_PROFILING_RUNBOOK.md`](./technical/APM_PROFILING_RUNBOOK.md) | Application Performance Monitoring (APM), tracing slow queries, CPU/memory bottleneck analysis | Module 06 |
| [`ASSET_MANAGEMENT_GUIDE.md`](./technical/ASSET_MANAGEMENT_GUIDE.md) | Optimization protocols for images (WebP/AVIF), SVGs, custom fonts, favicon bundles | Module 04 |
| [`COMPLIANCE_MONITORING_AUTOMATION.md`](./technical/COMPLIANCE_MONITORING_AUTOMATION.md) | Automated compliance auditing, vulnerability scanning pipelines, UU PDP compliance | Module 07 |
| [`DATA_ASSETS_MANAGEMENT.md`](./technical/DATA_ASSETS_MANAGEMENT.md) | Regulatory data versioning, seed data structure, lookup tables, multi-tenant asset management | Module 05, 08 |
| [`DEEP_RESEARCH_METHODOLOGY.md`](./technical/DEEP_RESEARCH_METHODOLOGY.md) | Domain knowledge acquisition, competitive intelligence gathering, regulatory research | Module 00 |
| [`DESIGN_SYSTEM_GUIDE.md`](./technical/DESIGN_SYSTEM_GUIDE.md) | Design system token hierarchies, component architecture, Storybook integration | Module 04 |
| [`FIGMA_MCP_SETUP.md`](./technical/FIGMA_MCP_SETUP.md) | Figma MCP server installation, live design synchronization, token extraction workflows | Module 04 |
| [`MOBILE_ARCHITECTURE_GUIDE.md`](./technical/MOBILE_ARCHITECTURE_GUIDE.md) | Mobile viewport responsiveness, touch ergonomics, PWA configuration, cross-platform layouts | Module 04 |
| [`UI_COMPONENT_ANIMATION_LIBRARY.md`](./technical/UI_COMPONENT_ANIMATION_LIBRARY.md) | Production micro-interaction animation patterns, Framer Motion/CSS transitions | Module 04 |
| [`UIUX_PROTOTYPING_DEEP_DIVE.md`](./technical/UIUX_PROTOTYPING_DEEP_DIVE.md) | Full 44-screen TataBuku sitemap, prototyping options tutorial, local MCP workflows, M04B design system | Module 04 |
| [`ARCHITECTURE_SPECS_DEEP_DIVE.md`](./technical/ARCHITECTURE_SPECS_DEEP_DIVE.md) | Universal stack evaluation rubrics, Astro/Remix/Laravel comparisons, prototype conversion, M05B enterprise system design | Module 05 |
| [`DEV_EXECUTION_DEEP_DIVE.md`](./technical/DEV_EXECUTION_DEEP_DIVE.md) | Framework-specific ORM/DDL code styles (Prisma/Eloquent/Django), Sprints 0–6 execution, M06B product instrumentation | Module 06 |

---

## 9. Team Collaboration & Agency Handoff (`references/team/`)

| File | Purpose | Referenced In |
|---|---|---|
| [`TEAM_COLLABORATION_GUIDE.md`](./team/TEAM_COLLABORATION_GUIDE.md) | Role responsibility matrix (PM/Design/Eng/QA), multi-stage handoffs, and multi-agent coordination | Module 02, 06 |
