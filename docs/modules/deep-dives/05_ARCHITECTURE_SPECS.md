# Module 05 Deep Dive: Tech Stack Discovery Questionnaire & Extended Prose

## Contents

- [Module Purpose (Full Context)](#module-purpose-full-context)
- [Question 1: Team Expertise](#question-1-team-expertise)
- [Question 2: Database Experience](#question-2-database-experience)
- [Question 3: Deployment Topology (Hosting Model)](#question-3-deployment-topology-hosting-model)
- [Question 4: Expected Scale (Year 1 Target)](#question-4-expected-scale-year-1-target)
- [Question 5: Data Model Characteristics](#question-5-data-model-characteristics)
- [Question 6: DevOps Complexity Tolerance](#question-6-devops-complexity-tolerance)
- [Question 7: Critical Feature Priority](#question-7-critical-feature-priority)
- [Question 8: Compliance Requirements](#question-8-compliance-requirements)
- [Registry Version Check: Rationale & Output (Extended)](#registry-version-check-rationale-output-extended)
- [FSD Content Adaptation by Stack (Extended Prose)](#fsd-content-adaptation-by-stack-extended-prose)
- [Verbose Agent Prompt Example: Tech Stack Discovery Complete](#verbose-agent-prompt-example-tech-stack-discovery-complete)
- [Verbose Gate Handoff Prompt (after Module 05 Gate PASSED)](#verbose-gate-handoff-prompt-after-module-05-gate-passed)
- [Universal Registry Sources Table (moved from runbook)](#universal-registry-sources-table-moved-from-runbook)
- [Gate Script Bodies (moved from runbook)](#gate-script-bodies-moved-from-runbook)


> Companion to the runbook [`docs/modules/05_ARCHITECTURE_SPECS.md`](../05_ARCHITECTURE_SPECS.md).
> This file holds the VERBATIM detailed bodies of Questions 1–8 of the Tech Stack Discovery Questionnaire (full option lists + 'Why this matters' paragraphs), plus other long-form prose removed from the runbook for brevity.

---

## Module Purpose (Full Context)

This module is the fifth phase in the software project lifecycle for solo developers. Its purpose is to architect the entire "engine, data cabling, database, and security systems" behind the interface frozen in Module 04, producing two primary blueprints: **`PRD.md`** (*Product Requirement Document*) and **`FSD.md`** (*Functional Specification Document*).

---

## Question 1: Team Expertise
**"What tech stack is the team/you already familiar with and productive in?"**

Options:
- [ ] JavaScript/TypeScript (React, Node.js, Next.js)
- [ ] PHP (Laravel, Symfony, CodeIgniter)
- [ ] Python (Django, Flask, FastAPI)
- [ ] Ruby (Rails, Sinatra)
- [ ] Go (Gin, Fiber, Echo)
- [ ] Java (Spring Boot)
- [ ] .NET (ASP.NET Core)
- [ ] Other: ___________

**Why this matters**: 2-month learning curve vs 2 weeks. Leveraging existing expertise = faster delivery.

---

## Question 2: Database Experience
**"Which database has the team used and feels comfortable maintaining?"**

Options:
- [ ] PostgreSQL
- [ ] MySQL / MariaDB
- [ ] MongoDB
- [ ] SQLite
- [ ] Firebase / Supabase
- [ ] None (first project - prefer managed service)

**Why this matters**: Wrong DB choice = schema migration nightmare in production.

---

## Question 3: Deployment Topology (Hosting Model)
**"Which hosting topology fits the operational constraints?"**

Options:
- [ ] Serverless / Edge free-tier (cold starts, bandwidth limits)
- [ ] Single VPS / container (full control, no cold starts)
- [ ] Managed PaaS (auto-scale, zero-config, vendor lock-in)
- [ ] Multi-node cluster with managed DB (high availability, IaC)
- [ ] Regulated cloud region (compliance certifications, data residency)

**Why this matters**:
- Serverless free-tier: cold starts and bandwidth caps under burst traffic
- Single VPS/container: predictable latency, manual patching burden
- Managed PaaS: zero-ops but vendor lock-in and per-request pricing
- Multi-node cluster: highest resilience, requires IaC and observability investment

---

## Question 4: Expected Scale (Year 1 Target)
**"What is the target concurrent user count within the first 12 months?"**

Options:
- [ ] <100 (MVP, internal tool, niche B2B)
- [ ] 100-1,000 (small B2B SaaS, local business)
- [ ] 1,000-10,000 (growing SaaS, regional app)
- [ ] 10,000-100,000 (high-growth startup)
- [ ] >100,000 (viral app, nationwide scale)

**Why this matters**:
- <100 users: Monolith is sufficient (PostgreSQL single instance)
- 10K users: Needs caching (Redis), read replicas
- 100K users: Microservices, load balancer, CDN mandatory

---

## Question 5: Data Model Characteristics
**"What are the data model characteristics of this application?"**

Options:
- [ ] Fixed schema (relational, predictable fields - e.g., invoice, user profile)
- [ ] Flexible schema (JSON-heavy, dynamic fields - e.g., CMS, form builder)
- [ ] Mixed (some fixed tables + some flexible JSON fields)
- [ ] Time-series (logs, metrics, events - append-only)
- [ ] Graph (social network, recommendation engine)

**Why this matters**:
- Fixed schema → PostgreSQL (strong typing, foreign keys)
- Flexible schema → MongoDB (schemaless, easy iteration)
- Time-series → TimescaleDB / InfluxDB
- Graph → Neo4j

---

## Question 6: DevOps Complexity Tolerance
**"How comfortable are you handling deployment complexity?"**

Options:
- [ ] Zero-config (git push auto-deploy, no terminal commands)
- [ ] Low-config (Docker Compose, basic CI/CD)
- [ ] Medium (Kubernetes, Terraform basics)
- [ ] High (full control, custom infra, multi-region)

**Why this matters**:
- Zero-config: Vercel, Railway (easy but vendor lock-in)
- Low-config: DigitalOcean App Platform (Docker deploy via UI)
- Medium: AWS ECS, GCP Cloud Run (container orchestration)
- High: Kubernetes self-managed (full control, high maintenance)

---

## Question 7: Critical Feature Priority
**"What is the most critical feature for this application?"**

Options:
- [ ] SEO (public content, need server-side rendering)
- [ ] Real-time (chat, live updates, WebSockets)
- [ ] Complex queries (analytics, reports, data aggregation)
- [ ] File processing (uploads, image resizing, video encoding)
- [ ] API-first (mobile app, third-party integrations)
- [ ] Admin dashboard (internal tool, CRUD operations)

**Why this matters**:
- SEO priority → Next.js (SSR), Nuxt.js, SvelteKit
- Real-time → Go/Node.js (WebSocket support), Elixir Phoenix
- Complex queries → PostgreSQL (window functions, CTEs), avoid NoSQL
- File processing → Background jobs (Celery, Bull), object storage (S3)

---

## Question 8: Compliance Requirements
**"What regulatory compliance must be satisfied?"**

Options:
- [ ] None (personal project, MVP)
- [ ] UU PDP (Indonesia - user consent, data deletion right)
- [ ] GDPR (EU - strict data protection)
- [ ] Sektor kesehatan (Kemenkes SatuSehat, UU PDP - enkripsi rekam medis, audit log kekal)
- [ ] SOC2 / ISO27001 (Enterprise B2B - security audit)
- [ ] PCI-DSS (Payment processing - credit card data)

**Why this matters**:
- PCI-DSS / Sektor Finansial & Medis: Managed cloud with compliance certifications (AWS, Azure)
- ISO27001: Need audit logs (database triggers, Sentry logging)
- None: Simpler stack choices, faster iteration

**Threat model**: any answer other than *None* means the system has a trust boundary somebody will attack. At **Client** scale and above, produce `docs/security/THREAT_MODEL_STRIDE.md` from `templates/03-architecture-specs/THREAT_MODEL_STRIDE_TEMPLATE.md` before the architecture is signed off; the method is `patterns/security/THREAT_MODELING_STRIDE_PATTERN.md`. At **Small** scale, skip the document and keep the one-table version described in that pattern.

---

## Registry Version Check: Rationale & Output (Extended)

**Why**: AI models suffer from knowledge cutoff lag (e.g., assuming Next.js 14 when Next.js 15/16 is current, or assuming Laravel 10 when Laravel 11/13 is current). Real-time registry queries ensure architectural recommendations use actual current stable releases without requiring developers to pre-install local compilers (Composer, PHP, Python, Go) before scaffolding.

**Output provides**:
- Current stable versions directly from upstream registries.
- Deprecation warnings (e.g., `@supabase/auth-helpers-nextjs` → `@supabase/ssr`).
- Compatibility analysis & breaking change warnings (e.g., Zod v4 vs react-hook-form, Tailwind v4 PostCSS breaking changes).
- Recommended scaffold commands and exact pinned version definitions.

---

## FSD Content Adaptation by Stack (Extended Prose)

After stack is locked, agent proceeds to generate FSD sections based on the chosen stack.

**Content must adapt to stack**:
- PostgreSQL chosen → SQL DDL syntax with FOREIGN KEY, CHECK constraints
- MongoDB chosen → Mongoose schema syntax, no foreign keys
- Laravel chosen → Eloquent migration syntax
- Django chosen → Django ORM models syntax

**Anti-Pattern** (AI SLOP):
- ❌ Always generate PostgreSQL schema without checking chosen DB
- ❌ Always recommend Next.js API routes without checking chosen backend
- ❌ Generic "best practices" not aligned with the framework

---

## Verbose Agent Prompt Example: Tech Stack Discovery Complete

**Agent prompt after questionnaire** (verbose example):
```
📋 Tech Stack Discovery Complete

User Answers Summary:
1. Team Expertise: JavaScript/TypeScript
2. Database: PostgreSQL
3. Hosting Topology: Serverless / Edge free-tier
4. Scale: <100 users
5. Data Model: Fixed schema
6. DevOps: Zero-config
7. Critical Feature: SEO
8. Compliance: UU PDP

Generating stack options...

[Agent generates 2-3 options here]

Please select stack (A/B/C) to proceed. Decision LOCKS tech stack for this project.

⚠️ WAITING FOR STACK SELECTION - Cannot generate FSD without locked stack decision.
```

**Agent MUST END TURN and wait for user input.**

---

## Verbose Gate Handoff Prompt (after Module 05 Gate PASSED)

```
Module 05 Gate PASSED. All architectural specifications verified.

Next Steps:
1. Review FSD.md (verify tech decisions align with expectations)
2. If revisions needed: Request changes now (before Module 06 coding)
3. If approved: Confirm "FSD approved, start Module 06 development"

⚠️ CRITICAL: Stack cannot change after approval without +2 weeks timeline impact (database migration, API rewrite, component conversion).
```

---

## Universal Registry Sources Table (moved from runbook)

| Ecosystem / Stack | Official Registry Source | Query Method | Verified Upstream Targets |
| :--- | :--- | :--- | :--- |
| **Next.js / Node** | npm Registry | `npm view <pkg> version` | `next`, `react`, `tailwindcss`, `zod`, `@supabase/ssr` |
| **Laravel / PHP** | Packagist API | `repo.packagist.org/p2/laravel/framework.json` | `laravel/framework`, `breeze`, `sanctum`, PHP req |
| **Django / Python** | PyPI JSON API | `pypi.org/pypi/django/json` | `django`, `djangorestframework`, `psycopg`, Python req |
| **Go / Golang** | Go Official API & Proxy | `go.dev/dl/?mode=json` & `proxy.golang.org` | Stable Go runtime, `gin`, `gorm`, `pgx` |
| **Ruby on Rails** | RubyGems API | `rubygems.org/api/v1/gems/rails.json` | `rails`, `puma`, `pg`, Ruby req |
| **SvelteKit** | npm Registry | `npm view @sveltejs/kit version` | `@sveltejs/kit`, `svelte` |
| **Nuxt** | npm Registry | `npm view nuxt version` | `nuxt`, `vue` |
| **Flutter / Dart** | Pub.dev API | `pub.dev/api/packages/flutter_lints` | `flutter_lints`, `http`, `provider` |

---

## Gate Script Bodies (moved from runbook)


⚠️ **The executable gate is `scripts/gates/modules/M05.sh` + the M05 helpers in
scripts/gates/lib/checks.sh`** (`check_stack_questionnaire`, `check_security_blueprint`,
`check_handoff_strategy`, `check_tech_signoff`). The PowerShell/Python below illustrates the
*same contract* in readable form for humans; where they disagree, the shell script wins.
Behaviour is locked by `scripts/verify/test-gate-regressions.sh` (behavioural cases) and
`scripts/verify/golden-gate-output.txt` (byte-for-byte output parity).

### Gate Check — Module 05 Phase 0 (PowerShell)

*Illustrative — the real Phase 0 enforcement is the questionnaire guard in `checks.sh`, which
counts Q1–Q8 individually and rejects placeholder answers.*

```powershell
# GATE CHECK - Module 05 Phase 0
# Verify questionnaire answered before FSD generation

Ordered by where it appears in `scripts/gates/modules/M05.sh`:

# Agent must track user answers in memory or temp file
# Check if all 8 questions answered (placeholders like "[answer]" do NOT count)
if ($answeredQuestions -lt 8) {
    Write-Error "❌ PHASE 0 GATE FAILED: Only $answeredQuestions/8 questions answered."
    Write-Error "Complete questionnaire before generating stack options."
    exit 1
}

**Gate-enforced** (the machine-checkable markers): 8 real answers + a human `Stack-Locked-by:`,
AES-256-GCM/Argon2id/OWASP/rate-limit coverage (+UU PDP on Medium+), the `Module 04 Handoff Strategy`
section with `Compatibility Level: Level 1-4`, `≥10` endpoint headings, and a human sign-off with a real
name + date. **Judged by the human at sign-off** (the gate cannot assess quality): stack-justification
substance, whether the endpoint schemas are realistic, and version-registry freshness. The gate confirms
the artifacts exist and hold their markers — not that the engineering is good.

### Downstream contract: M06 reads the FSD pinned block

### Gate Check — Module 05 File & Content Verification (PowerShell)

*Illustrative. The live gate additionally requires: `Stack-Locked-by:` naming a human, the security
blueprint controls, the `Module 04 Handoff Strategy` section with `Compatibility Level: Level 1-4`,
and a human technical sign-off with no residual blank/placeholder fields. The size threshold in the
live script is a stub-check (≥40B); `MinSize` here shows the runbook's *target* sizes.*

1. The heading must keep its trailing colon and stay a bullet block (the parser splits on the
   literal `Framework Versions (Pinned):` and then on a blank line).
2. Delete lines for stacks you did not lock. The template ships `Next.js/Laravel/Django/Go` example
   lines on purpose, because a leftover one is read as a declared pin and fails against the
   lockfile of a different stack.
The parser exists in both `.sh` and `.ps1`; keep them in sync when adding a stack.
