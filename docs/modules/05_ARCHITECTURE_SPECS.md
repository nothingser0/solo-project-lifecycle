# Module 05: Architecture & Technical Specifications (PRD & FSD)

> **Templates**: `templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md`, `FSD_TECHNICAL_TEMPLATE.md` · `templates/03-architecture-specs/ARCHITECTURE_DEBT_AND_DRIFT_REGISTER_TEMPLATE.md` · Medium+: `templates/03-governance/ADR_TEMPLATE.md` (→ `docs/governance/ADR.md`)
> 📖 **Optional** (do NOT preload): `references/solo/SOLO_ARCHITECTURE_GUIDE.md` · `references/stacks/STACK_SUPPORT_MATRIX.md` · `patterns/product/BUSINESS_ANALYSIS_DISCOVERY_PATTERN.md` §6 (the five review passes) · deep dive `deep-dives/05_ARCHITECTURE_SPECS.md`
> Conditional (open only if the project needs it): `patterns/compliance/UU_PDP_COMPLIANCE.md` (personal data), `patterns/payments/INDONESIA_PAYMENT_GATEWAYS.md` (payment rails), `patterns/offline/OFFLINE_FIRST_SYNC.md` (offline operation), `patterns/architecture/POSTGRES_JOB_QUEUE_SKIP_LOCKED_PATTERN.md` (background queues), `patterns/architecture/LEGAL_DATA_MODELING_LTREE_PATTERN.md` (hierarchical data / LTREE), `patterns/compliance/INDONESIAN_LEGAL_HIERARCHY_PATTERN.md` (legal / regulatory citation), `patterns/architecture/REPOSITORY_BACKED_ARCHITECTURE_DIAGRAM_PATTERN.md` (verifiable architecture diagrams), `patterns/architecture/LEGACY_MODERNIZATION_STRANGLER_PATTERN.md` (inherited systems: strangler fig, characterization tests, per-phase rollback), `references/architecture/BACK_OF_THE_ENVELOPE_CAPACITY_PLAYBOOK.md` (BOTEC sizing), `patterns/resilience/FAULT_TOLERANCE_AND_DEGRADATION_PATTERN.md` (resilience & retry jitter), `references/architecture/QUALITY_ATTRIBUTES_AND_RISK_FRAMEWORK.md` (quality attributes & risk register), `references/architecture/SENIOR_ARCHITECT_ASSESSMENT_PLAYBOOK.md` (debt assessment & blast radius), `patterns/architecture/DATABASE_SCHEMA_AND_QUERY_OPTIMIZATION_PATTERN.md` (DDL, FK indexation & SARGable queries), `patterns/architecture/REALTIME_COMMUNICATION_AND_API_PROTOCOLS_PATTERN.md` (SSE vs WebSocket vs Polling), `patterns/architecture/SUPER_ARCHITECTURE_AND_ADAPTIVE_CONTROL_PATTERN.md` (S.U.P.E.R architecture & adaptive control), `patterns/architecture/SVG_TECHNICAL_DIAGRAM_STANDARD_PATTERN.md` (clean SVG diagram house style), `patterns/architecture/CACHING_STRATEGIES_AND_DATA_CONSISTENCY_PATTERN.md` (caching strategies & CAP consistency), `patterns/architecture/SYSTEM_DESIGN_METHODOLOGY_PATTERN.md` (system design methodology & trade-offs), `patterns/architecture/RESTFUL_API_DESIGN_PATTERN.md` (RESTful API design & resource modeling), `patterns/architecture/API_DESIGN_CHEAT_SHEET_PATTERN.md` (API design guidelines & best practices cheat sheet), `patterns/architecture/RESTFUL_API_DESIGN_PATTERN.md` (Dwyl API-as-a-product principles), `patterns/architecture/AI_AGENT_SYSTEM_PROMPT_ENGINEERING_PATTERN.md` (agent system prompts & execution guardrails), `patterns/execution/FULLSTACK_EXECUTION_ROADMAP_PATTERN.md` (full-stack milestone execution breakdown), `patterns/execution/AI_FULLSTACK_DELIVERY_WORKFLOW_PATTERN.md` (AI full-stack master control & 17-role routing), `patterns/execution/CLAUDE_CODE_SPEC_WORKFLOW_PATTERN.md` (Claude Code spec-driven dev & context optimization), `patterns/execution/CLAUDE_SKILLS_SPECIALIZED_PAIR_PROGRAMMER_PATTERN.md` (Jeffallan Claude skills & pair programmer workflows), `patterns/execution/DATA_ENGINEERING_DBT_SNOWFLAKE_PATTERN.md` (Altimate AI dbt & Snowflake analytics engineering), `patterns/execution/DATA_ENGINEERING_AGENT_SKILLS_RELIABILITY_PATTERN.md` (Vaquar Khan data engineering agent skills & reliability), `patterns/execution/TECHNICAL_WRITER_ENGINEERING_PROSE_PATTERN.md` (Riekelt technical writer engineering prose & anti-slop), `patterns/execution/SQL_DATA_WAREHOUSE_MEDALLION_PATTERN.md` (Baraa SQL data warehouse & medallion architecture), `patterns/execution/PATTERNS_DEVKIT_COMPONENT_DATA_GRAPHS_PATTERN.md` (Patterns devkit component-based data graphs), `patterns/execution/QA_SKILLS_AI_AUGMENTED_QUALITY_ASSURANCE_PATTERN.md` (Petr Kindlmann QA skills & AI-augmented QA), `patterns/execution/GRAFANA_K6_PERFORMANCE_AND_CHAOS_TESTING_PATTERN.md` (KimDoubleB Grafana k6 performance & chaos testing), `patterns/qa/UAT_UNTRUSTED_OUTPUT_BOUNDARY_PATTERN.md` (Tsilverberg WebApp UAT & browser testing), `patterns/execution/CLOUDFLARE_SECURITY_AUDIT_VULNERABILITY_PATTERN.md` (Cloudflare security audit & vulnerability hunting), `patterns/execution/NETRESEARCH_SECURITY_AUDIT_CHECKPOINTS_PATTERN.md` (Netresearch security audit & OWASP checkpoints), `patterns/execution/STROBES_SECURITY_WEB_PENTEST_METHODOLOGY_PATTERN.md` (Strobes security web pentest & AI skill architecture), `patterns/execution/SPECTEROPS_OWASP_CODE_REVIEW_PATTERN.md` (SpecterOps OWASP code review & evidence-driven auditing), `patterns/execution/BREGMAN_DEVOPS_SRE_SKILLS_PATTERN.md` (Arie Bregman DevOps & SRE agent-ready SKILL.md pattern), `patterns/execution/ADDY_OSMANI_CICD_AUTOMATION_PATTERN.md` (Addy Osmani CI/CD & quality gate automation), `patterns/execution/AKSHAY_KOKANE_AGENT_SKILLS_INJECTION_PATTERN.md` (Enterprise agent framework & trigger-based skill injection), `patterns/execution/AGENT_SKILLS_CUSTOMER_SERVICE_MCP_PATTERN.md` (Enterprise agentic customer service & MCP multi-turn testing), `patterns/execution/AWESOME_AGENT_SKILLS_ECOSYSTEM_PATTERN.md` (Awesome agent skills & progressive disclosure ecosystem), `patterns/execution/CLAUDE_SEO_GENERATIVE_ENGINE_OPTIMIZATION_PATTERN.md` (Enterprise AI search & technical SEO optimization), `patterns/execution/MARKETING_SKILLS_GROWTH_ENGINEERING_PATTERN.md` (Enterprise growth engineering & marketing intelligence), `patterns/execution/METADATA_SERP_OPTIMIZATION_PATTERN.md` (Enterprise metadata & SERP optimization), `patterns/execution/APP_STORE_OPTIMIZATION_ASO_PATTERN.md` (Enterprise app store optimization ASO)

**Inputs**: `SCOPE_STATEMENT.md` (M02) + `DESIGN_SPEC.md` (M04); Small uses `PROJECT_LITE.md`.
**Outputs**: `docs/specs/PRD.md` + `docs/specs/FSD.md` → ready for M06. Small: pinned into `PROJECT_LITE.md` §5 + human sign-off (§6).

**Scale Routing**:
- **Small (Fast-Track)**: NO `PRD.md`/`FSD.md` — stack lock, DDL, API list, security blueprint, Module 04 handoff pinned into **Section 5 of `PROJECT_LITE.md`**.
- **Enterprise**: routed to **A-Series Phase A02** + mandatory `docs/governance/ADR.md` and `docs/governance/AUDIT_TRAIL_REQUIREMENTS.md`; solo coding prohibited.

---

## Execution Steps

### STEP 0: Version Check (MANDATORY FIRST)

Run real-time version check against official registries (never trust training-data versions):

```bash
./scripts/verify/check-package-versions.sh <nextjs|laravel|django|go|fastapi|rails|mern|aspnet|spring|serverless|flutter|remix|astro|sveltekit|nuxt>
```

or Windows:

```powershell
.\scripts\verify\check-package-versions.ps1 -Framework <nextjs|laravel|django|go|fastapi|rails|mern|aspnet|spring|serverless|flutter|remix|astro|sveltekit|nuxt>
```

> Stack list source of truth: `references/stacks/STACK_SUPPORT_MATRIX.md`. A **PRODUCTION** stack
> there must be queryable by both scripts — if yours is missing, report the gap (rule 7).

- Pin the proven stable version; if a bleeding-edge major breaks the ecosystem (Tailwind v4, Zod v4), pin the stable one explicitly.
- **Breaking Changes & Documentation Sync**: The agent must inspect official release notes / migration guides for the chosen framework major version (via web search/docs check) and record the authoritative documentation URL and breaking change notes in `docs/specs/FSD.md` to prevent training-data deprecation errors in M06.
- Transcribe agreed versions **verbatim** into the `Framework Versions (Pinned):` bullet block of
  `docs/specs/FSD.md` (M06 gate `verify-framework-version.sh` reads it).
- **Machine-read — do not reformat**: keep the heading colon and the `- <Package>: <version>` bullets; delete stacks you did not lock (a stale `- Django:` line in a Next.js project fails M06, as does a table).

### STEP 1: Tech Stack Discovery Questionnaire (MANDATORY — BLOCKS FSD)

Ask the 8 questions, END TURN, wait (option lists in deep dive):
**Team Expertise · Database Experience · Deployment Topology · Expected Scale (Year 1) · Data Model Characteristics · DevOps Complexity Tolerance · Critical Feature Priority · Compliance Requirements**

Then present **2–3 options** with cost/pros/cons and let **the user LOCK the stack**. No default; changing after lock costs +2 weeks.

### STEP 2: Tech Stack Justification & Ecosystem Libraries Locking

Reasoning for the chosen stack; **alternatives rejected with reasons**; topology aligned with budget & scale. Content must adapt to the stack (PostgreSQL → SQL DDL, MongoDB → Mongoose, Laravel → Eloquent migrations, Django → ORM — never AI-SLOP generic schemas; anti-patterns in deep dive).

- **Ecosystem Libraries & Auth Solution Locking**: In addition to the base framework, M05 MUST explicitly evaluate, select, and lock the companion ecosystem libraries to prevent dependency bloat, security holes, and runtime mismatches in M06:
  - **Authentication & Session**: Next.js (Better Auth / Supabase Auth / Auth.js) vs Laravel (Breeze / Sanctum / Fortify) vs Django (allauth) vs Go/FastAPI (JWT / OAuth2).
  - **Validation & Serialization**: Zod / Valibot (TS) vs Form Requests (Laravel) vs Pydantic (Python).
  - **State Management & Data Fetching**: Zustand / TanStack Query (React) vs Pinia (Vue) vs Inertia / Livewire.
  - **UI Primitives & Motion**: shadcn/ui + Radix UI + Lucide + Framer Motion (per `patterns/ui/UI_COMPONENT_TAXONOMY.md` and `patterns/ui/MOTION_DESIGN_TAXONOMY.md`).
  - **Access Control & Permissions**: Explicit RBAC / ReBAC model implementation (per `patterns/security/ACCESS_CONTROL_PATTERNS.md`).

### STEP 3: Database Schema & Object Storage Design (ERD, DDL & Media Architecture)

- **Visual ERD (Mermaid)**: Wajib memuat diagram relasi visual `erDiagram` (Mermaid) yang menggambarkan kardinalitas (one-to-many, many-to-many) antar entitas inti.
- **DDL & Performance Indexes**: Tables, PK/FK, CHECK constraints, composite indexes pada kolom query/foreign keys (`idx_*`) — syntax per chosen DB.
- **Object Storage & Media Architecture (Zero Base64 in DB)**:
  - If project handles media uploads (images, avatars, documents, 3D models): define dedicated object storage buckets (e.g. S3, Supabase Storage, Cloudflare R2).
  - Explicit size boundaries: max file upload limit (e.g. `MAX_UPLOAD_SIZE = 5MB` for images, `15MB` for 3D/canvas models).
  - Explicit mime-type validation and CDN caching policy (`Cache-Control: public, max-age=31536000, immutable`).
  - Storing raw base64 strings in relational database columns is strictly prohibited.
- **Cascade Soft-Delete & Data Retention Architecture**:
  - For financial records, invoices, orders, and core entities: enforce soft-delete (`deleted_at TIMESTAMP WITH TIME ZONE`).
  - **Partial Unique Index Guardrail**: Any unique constraint on columns that can be soft-deleted (e.g. `email`, `slug`, `username`) MUST use a partial unique index (`CREATE UNIQUE INDEX uq_table_column_active ON table (column) WHERE deleted_at IS NULL;`) instead of an unqualified `UNIQUE` constraint, allowing re-registration/reuse after deletion.
  - Queries, views, or RLS policies MUST include automatic filtering for parent-child relationships (e.g. child records of a soft-deleted parent workspace/user are automatically excluded from active queries).
- **Serverless Database Connection Pooling**:
  - Serverless and edge runtimes (Next.js App Router, Cloudflare Workers, Vercel Functions) MUST route database queries through a connection pooler in transaction mode (e.g. PgBouncer / Supavisor on port `6543`, Prisma Accelerate, or Neon pooler).
  - Direct connection strings (port `5432` session mode) are strictly reserved for local DDL migrations and CI scripts to prevent serverless connection exhaustion (`FATAL: remaining connection slots are reserved`).
- Audit trail: `created_at`, `updated_at`, `actor_id`, soft-delete.
- Multi-tenant isolation (RLS / schema / DB-per-tenant) if applicable.
- `idempotency_keys` table for all POST mutations of financial/stock state.
- **In-Memory Caching Strategy**: Specify Redis / Keyv layer for high-throughput reads (e.g. session stores, catalog data, rate limit counters) with explicit TTLs and cache invalidation policies (never serve stale ledger balances).
- **Asynchronous Processing & Worker Queue Strategy**: Decouple resource-intensive tasks (PDF invoice compilation, transactional bulk emails, webhook processing, AI batch inference) from synchronous HTTP request cycles using a persistent queue architecture (e.g. BullMQ, Celery, Laravel Queue, pg-boss, or QStash/Inngest) to eliminate HTTP 504 gateway timeouts.
- **Disaster Recovery & Backup SLA (RPO & RTO)**: Define Recovery Point Objective (RPO ≤ 24h via daily WAL / snapshot) and Recovery Time Objective (RTO ≤ 2h cold recovery target on secondary host).

### STEP 4: API Endpoint Matrix & Realtime Transport (≥10 endpoints — gate-enforced)

- HTTP verb, path, auth, idempotency headers; JSON request/response schemas; success-vs-error matrix; style per stack (REST/GraphQL/tRPC).
- **Mandatory Pagination & Hard Cap Limit**:
  - Every collection/list endpoint MUST enforce bounded pagination (default: `limit=20`, hard maximum `MAX_LIMIT=100`). Unbounded queries (`SELECT * FROM table` without `LIMIT`) are strictly prohibited to prevent memory exhaustion (OOM).
  - High-volume data feeds (activity feeds, transactions, chat history) MUST specify cursor-based pagination over deep offset pagination.
- **Rate Limit & Cost Ceilings Guardrails**:
  - Sensitive endpoints (Auth, OTP email, AI inference, file upload) MUST specify rate limit boundaries (e.g., max 5 requests/min per IP/user) to prevent billing shocks on third-party SaaS APIs.
- **Realtime & Offline Transport Architecture** (if applicable: collaborative canvas, live chat, notifications):
  - Explicit transport protocol: WebSocket / Supabase Realtime / Server-Sent Events (SSE). Polling loops (`setInterval`) are forbidden for realtime flows.
  - Reconnection & state recovery strategy on network drop.
- **One heading per endpoint** (`#### POST /api/v1/...`) — the gate counts these headings and fails below 10.

### STEP 5: Security Blueprint, Secrets Validation & Module 04 Handoff (gate-enforced)

- **Security**: record AES-256-GCM envelope encryption, Argon2id hashing, OWASP Top 10, rate limiting, and Edge DDoS/WAF protection via Cloudflare ([`patterns/security/EDGE_SECURITY_CLOUDFLARE.md`](../../patterns/security/EDGE_SECURITY_CLOUDFLARE.md)) (+ UU PDP on Medium+). Gate-enforced; `N/A — <reason>` accepted, blank not.
- **Typed Environment Variables Schema (`.env.example`)**: Declare complete environment variable contract with runtime type-validation (Zod / `@t3-oss/env-nextjs` / Pydantic / config validators) to enforce fail-fast application startup if secrets are missing.
- **Handoff**: prototype → chosen framework conversion (component map, token extraction). The gate requires a section **named `Module 04 Handoff Strategy`** carrying **`Compatibility Level: Level 1-4`** — M06 STEP 0 parses those exact strings; level table in `FSD_TECHNICAL_TEMPLATE.md` §2.1.

### STEP 6: Write Deliverables

- `docs/specs/PRD.md` via `PRD_FINAL_TEMPLATE.md` (F-xx → REQ-xx traceability, BDD Given-When-Then criteria).
- `docs/specs/FSD.md` via `FSD_TECHNICAL_TEMPLATE.md` (DDL, API contracts, access controls, atomic high-risk mutations, Prototype Conversion Strategy) + pinned versions verbatim.
- **Small**: pin Steps 1–5 into `PROJECT_LITE.md` §5 instead (no TBD/maybe/tentative in Must-Have features).

### STEP 7: Technical Sign-Off

The **human** signs (Client Single PIC, or on solo work the developer); an AI agent is never a valid approver. The gate **fails** on residual `____` / `[YYYY-MM-DD]` / `[Your Name]` fields — a real name + date is required (same false-green the M04 Design Freeze guard closes). M05 is **not** a stop point: after sign-off, chain to M06 for Small/Solo SaaS; on Client work pause for explicit "Proceed to Module 06". Changes requested → revise and re-run.

---

## [GATE] Exit Criteria (condensed)

- [ ] 8-question questionnaire completed, 2–3 options presented, stack **LOCKED** (`Stack Decision LOCKED:` + `Stack-Locked-by:` naming the human). Real values only — the gate rejects `[answer]` placeholders and a blank `Stack-Locked-by:`
- [ ] Versions verified via registry script, pinned verbatim in `Framework Versions (Pinned):` (M06 `verify-framework-version.sh` reads it)
- [ ] Stack justification with rejected alternatives
- [ ] DDL present (tables, keys, CHECK, indexes, audit trail)
- [ ] ≥10 API endpoint **headings** (`#### <VERB> /path`) with request/response schemas; idempotency for financial POSTs — **gate-enforced at ≥10**
- [ ] Security blueprint complete (AES-256-GCM, Argon2id, OWASP, rate limiting; +UU PDP on Medium+) — each control resolved or `N/A — <reason>` *(gate-enforced)*
- [ ] `Module 04 Handoff Strategy` + `Compatibility Level: Level 1-4` present *(gate-enforced; M06 STEP 0 depends on it)*
- [ ] Substantive `PROJECT_LITE.md` (Small) or `PRD.md` + `FSD.md` (Medium+) — ≥1000B / ≥2000B targets; the script stub-checks size, so judge substance
- [ ] Idempotency strategy if applicable. RLS required **only** when `Intake-Branch-Hierarchy` is yes/multi (or the DDL declares `org_id`/`tenant_id`); single-tenant passes with `N/A — single tenant`
- [ ] Medium+ only: `docs/governance/ADR.md` (gate-enforced); Enterprise adds `docs/governance/AUDIT_TRAIL_REQUIREMENTS.md`
- [ ] Technical sign-off obtained — **human name + real date, no residual blank/placeholder fields** *(gate-enforced; AI is never a valid approver)*

> **Scale note**: size figures are targets, not hard checks — `lib/checks.sh` stub-checks only (`<40B` fails); content checks are what reject.

### Gate Execution (MANDATORY — verbatim script output)

Run the real validator — never paste a pre-filled checklist:

```bash
./scripts/gates/validate-gate.sh M05
```

or Windows:

```powershell
.\scripts\gates\validate-gate.ps1 M05
```

If it exits FAILED: fix artifacts and re-run — never declare completion on failure. Only after `✅ Gate validation PASSED` present the handoff prompt (deep dive) and END TURN for approval.

The live gate is the source of truth (`scripts/gates/modules/M05.sh` + the M05 helpers in `lib/checks.sh`). The deep dive's pseudo-code is illustrative — where they disagree, the script wins. Check-by-check breakdown: deep dive, "What `validate-gate.sh M05` actually checks".
