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

## Architecture Input Reconciliation Example

1. Read confirmed architecture inputs from prior project artifacts and record their sources.
2. Ask only about material gaps or conflicts that affect the decision.
3. Present 2–3 stack options with project-specific trade-offs if the stack is undecided.
4. Wait for the human to choose and lock a stack before finalizing the FSD.

Wait for user input only when a material gap or the stack lock requires a human decision; do not repeat answered intake questions.
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

# Record confirmed answers from existing project artifacts; ask only for missing
# or conflicting decisions. A placeholder is not a recorded architecture input.
if ($answeredQuestions -lt 8) {
    Write-Error "❌ PHASE 0 GATE FAILED: Only $answeredQuestions/8 questions answered."
    Write-Error "Resolve missing architecture inputs before locking the stack."
    exit 1
}

**Gate-enforced** (the machine-checkable markers): recorded architecture inputs + a human `Stack-Locked-by:`,
encryption/password-hashing/OWASP/rate-limit coverage (+UU PDP on Medium+), the `Module 04 Handoff Strategy`
section with `Compatibility Level: Level 1-4`, complete contracts for each in-scope API operation (or explicit N/A), and a human sign-off with a real
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

## Full Execution Steps 0-5 (moved from the runbook, 2026-11-04)

The runbook now carries the condensed steps. This is the original text verbatim, kept so no
clause is lost when the condensed form is ambiguous.

### STEP 0: Version Check (MANDATORY FIRST)

Run real-time version check against official registries (never trust training-data versions):

```bash
./scripts/verify/check-package-versions.sh <nextjs|expo|laravel|django|go|fastapi|rails|mern|aspnet|spring|serverless|flutter|remix|astro|sveltekit|nuxt>
```

or Windows:

```powershell
.\scripts\verify\check-package-versions.ps1 -Framework <nextjs|expo|laravel|django|go|fastapi|rails|mern|aspnet|spring|serverless|flutter|remix|astro|sveltekit|nuxt>
```

> Stack list source of truth: `references/stacks/STACK_SUPPORT_MATRIX.md`. A **PRODUCTION** stack
> there must be queryable by both scripts — if yours is missing, report the gap (rule 7).

- Pin the proven stable version; if a bleeding-edge major breaks the ecosystem (Tailwind v4, Zod v4), pin the stable one explicitly.
- **Breaking Changes & Documentation Sync**: The agent must inspect official release notes / migration guides for the chosen framework major version (via web search/docs check) and record the authoritative documentation URL and breaking change notes in `docs/specs/FSD.md` to prevent training-data deprecation errors in M06.
- Transcribe agreed versions **verbatim** into the `Framework Versions (Pinned):` bullet block of
  `docs/specs/FSD.md` (M06 gate `verify-framework-version.sh` reads it).
- **Machine-read — do not reformat**: keep the heading colon and the `- <Package>: <version>` bullets; delete stacks you did not lock (a stale `- Django:` line in a Next.js project fails M06, as does a table).

### STEP 1: Resolve Architecture Inputs (BLOCKS STACK LOCK)

**Existing codebase (conditional)**: If this project extends or replaces an existing repository, inspect its entry points, runtime/configuration, data stores and models, external integrations, authentication boundaries, tests, and deployment path before proposing the target design. Cite files or commands as evidence; mark anything unverified `UNKNOWN`. Record the current state, constraints, and required changes in the FSD architecture section. Use `patterns/architecture/LEGACY_MODERNIZATION_STRANGLER_PATTERN.md` when incremental replacement is needed. For a greenfield project, record `N/A — no existing codebase`.

Review M01/M02 decisions, `PROJECT_STATE.md`, the approved scope, and M04 design before asking anything. Reuse confirmed answers and record their source. Ask only targeted questions for missing or conflicting decisions that materially affect stack, data, deployment, scale, or compliance; use the questionnaire below as a prompt bank, not a second intake interview:
**Team Expertise · Database Experience · Deployment Topology · Expected Scale (Year 1) · Data Model Characteristics · DevOps Complexity Tolerance · Critical Feature Priority · Compliance Requirements**

Present 2–3 viable options with trade-offs when the stack remains undecided. The human selects and records the stack lock; carry forward any earlier decisions that remain valid.

### STEP 2: Tech Stack Justification & Ecosystem Libraries Locking

Justify the chosen stack, name the **alternatives rejected with reasons**, and align topology with budget and scale. Content must adapt to the stack (PostgreSQL → SQL DDL, MongoDB → Mongoose, Laravel → Eloquent migrations, Django → ORM — never generic AI schemas; anti-patterns in the deep dive).

- **Ecosystem libraries & auth**: lock only the companion libraries M06 will actually install, per product need: authentication & session, validation/serialization, state management & data fetching, access control (RBAC/ReBAC per `patterns/security/ACCESS_CONTROL_PATTERNS.md`), and UI primitives — the last one derives from the already-approved M04 inventory; never introduce a second UI system here. Per-framework candidate lists: `templates/03-architecture-specs/FSD_TECHNICAL_TEMPLATE.md`.
- **Prefer the framework's own capability** when it meets the requirement; record `N/A — <reason>` for each category the product does not need.

**Risk-triggered security and vendor references**: Load `patterns/security/THREAT_MODELING_STRIDE_PATTERN.md` and the relevant security pattern when the product handles personal/sensitive data, payments, public APIs, multi-tenant access, or privileged roles; use the project data classification and threat model to select controls. For a third-party service, first assess data handled, failure impact, exit path, and cost in the vendor/build-vs-buy decision. After the stack and provider are chosen, consult that provider's official skill or documentation for integration details; vendor-specific guidance does not replace the project's threat model or security review.

**C4 views (conditional)**: Add a C4 System Context and/or Container view when multiple deployable services, data stores, external systems, or trust boundaries make the system shape hard to understand from the DFD. Use a Component view only when a container's internal structure needs clarification. Keep diagrams consistent with the selected stack, DFD, and threat model; otherwise record `N/A — DFD is sufficient`.

### STEP 3: Database Schema & Object Storage Design (ERD, DDL & Media Architecture)

- **Visual ERD (Mermaid)**: Wajib memuat diagram relasi visual `erDiagram` (Mermaid) yang menggambarkan kardinalitas (one-to-many, many-to-many) antar entitas inti.
- **DDL & Performance Indexes**: Tables, PK/FK, CHECK constraints, composite indexes pada kolom query/foreign keys (`idx_*`) — syntax per chosen DB.
- **Object Storage & Media Architecture**:
  - If the product accepts user-uploaded media, choose a storage location and define access, size, type validation, retention, and delivery behavior. Otherwise record `N/A — no user-uploaded media`.
  - In the FSD, record this in `Object storage decision`; in `PROJECT_LITE.md`, include the same decision in the architecture summary.
  - Set file size limits from the product, provider, and abuse risk. Validate content type and size server-side. Choose cache headers by access level; private user data must not inherit public immutable caching.
  - Keep large binary payloads out of relational columns by default; document a justified exception if inline storage is appropriate.
- **Deletion & Retention Semantics**: Define retention and deletion per data class and legal/product need. Use soft-delete only when restoration or tombstone behavior is required; immutable financial/audit records should use explicit reversal/correction records where appropriate. Add a partial unique index only when the product permits reusing a value after soft-delete.
- **Connection Management**: For serverless or highly concurrent runtimes, follow the selected database provider's current pooling and connection-limit guidance. Document migration and runtime connection paths separately when they differ.
- Audit fields and retention: choose fields from the entity lifecycle and traceability needs; do not add `updated_at` or soft-delete semantics to immutable records without a reason.
- Multi-tenant isolation (RLS / schema / DB-per-tenant) if applicable.
- `idempotency_keys` or an equivalent idempotency mechanism for financial/stock mutations when retries could duplicate state changes.
- **Caching**: Add a cache only for measured or expected read pressure; record consistency and invalidation rules, or `N/A — no cache needed at this scale`.
- **Asynchronous Processing**: Define a durable queue for work that can outlive a request or needs retry/isolation; otherwise record `N/A — request-bound work is sufficient`.
- **Recovery & Backup Targets (RPO/RTO)**: Set recovery targets from the business impact of data loss and downtime, then choose backups and restore procedures that fit the budget and operating model. Treat RPO ≤24h / RTO ≤2h as examples, not defaults.

### STEP 4: API Contracts & Realtime Transport

- Document every in-scope API operation from the requirements and wireflows; do not invent endpoints to meet a count. For each operation record method/path (or protocol operation), auth, idempotency where needed, request/response schema, and success/error behavior. If there is no application API, record `N/A — no application API`.
- **Mandatory Pagination & Hard Cap Limit**:
  - Every collection/list endpoint MUST enforce bounded pagination (default: `limit=20`, hard maximum `MAX_LIMIT=100`). Unbounded queries (`SELECT * FROM table` without `LIMIT`) are strictly prohibited to prevent memory exhaustion (OOM).
  - High-volume data feeds (activity feeds, transactions, chat history) MUST specify cursor-based pagination over deep offset pagination.
- **Rate Limit & Cost Ceilings Guardrails**:
  - Sensitive endpoints (Auth, OTP email, AI inference, file upload) MUST specify rate limit boundaries (e.g., max 5 requests/min per IP/user) to prevent billing shocks on third-party SaaS APIs.
- **Realtime & Offline Transport Architecture** (if applicable: collaborative canvas, live chat, notifications):
  - Explicit transport protocol: WebSocket / Supabase Realtime / Server-Sent Events (SSE). Polling loops (`setInterval`) are forbidden for realtime flows.
  - Reconnection & state recovery strategy on network drop.
- Use one heading per HTTP endpoint (`#### POST /api/v1/...`) so each contract can be reviewed independently.

### STEP 5: Security Blueprint, Secrets Validation & Module 04 Handoff (gate-enforced)

- **Security**: use the risk-triggered STRIDE model and data classification to choose controls. Record the decision, enforcement point, and verification path for encryption at rest (including whether application-level AES-256-GCM is warranted), password hashing (Argon2id or the selected identity provider's managed approach), OWASP-relevant risks, rate limits, edge protection, and applicable privacy requirements. Keep `N/A — <reason>` explicit; do not prescribe a vendor or control without a project need.
- **Threat-to-verification traceability**: map each consumed threat/security requirement to its FSD control, enforcing component, and planned M07 verification. Keep threat IDs stable across the threat model, FSD, and security audit.
- **Granular RBAC Role Capability & Limitation Matrix (Boleh Apa vs DILARANG Apa)**:
  - If the application involves multiple roles (e.g. Owner, Manager, Staff, Member/Tenant), `docs/specs/FSD.md` Section 4.0 MUST define a granular capability matrix detailing:
    1. **Boleh Dilakukan (Allowed Capabilities)**: Explicit list of allowed business actions per role.
    2. **DILARANG & UI MASKED (Forbidden Actions & Hidden UI)**: Strict negative boundaries for each role. Sensitive views (e.g. profit/loss, bank accounts, staff management, audit logs) MUST NOT be accessible to lower roles (e.g. Staff/Operator).
    3. **Dedicated Operational Views**: Lower roles (e.g. Staff) must have a tailored operational interface (e.g. `/staff` or `/ops/workspace`) showing only operational tasks (daily tasks, meter recording, ticket logs), eliminating confusing read-only disabled views or exposure to executive analytics.
    4. **Backend Action Authorization (Defense-in-Depth)**: Frontend route masking alone is insufficient; server actions, mutations, and API endpoints must independently enforce role verification and throw HTTP 403 Forbidden on unauthorized execution.
- **Typed Environment Variables Schema (`.env.example`)**: Declare complete environment variable contract with runtime type-validation (Zod / `@t3-oss/env-nextjs` / Pydantic / config validators) to enforce fail-fast application startup if secrets are missing.
- **Handoff**: prototype → chosen framework conversion (component map, token extraction). The gate requires a section **named `Module 04 Handoff Strategy`** carrying **`Compatibility Level: Level 1-4`** — M06 STEP 0 parses those exact strings; level table in `FSD_TECHNICAL_TEMPLATE.md` §2.1.
