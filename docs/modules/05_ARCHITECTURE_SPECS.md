# Module 05: Architecture & Technical Specifications (PRD & FSD)

> **Templates**: `templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md`, `FSD_TECHNICAL_TEMPLATE.md` · `templates/03-architecture-specs/ARCHITECTURE_DEBT_AND_DRIFT_REGISTER_TEMPLATE.md` · Medium+: `templates/03-governance/ADR_TEMPLATE.md` (→ `docs/governance/ADR.md`)
> 📖 **Optional** (do NOT preload): `references/solo/SOLO_ARCHITECTURE_GUIDE.md` · `references/stacks/STACK_SUPPORT_MATRIX.md` · `patterns/product/BUSINESS_ANALYSIS_DISCOVERY_PATTERN.md` §6 (the five review passes) · deep dive `deep-dives/05_ARCHITECTURE_SPECS.md`
> Conditional (open only if the project needs it): `patterns/compliance/UU_PDP_COMPLIANCE.md` (personal data), `patterns/payments/INDONESIA_PAYMENT_GATEWAYS.md` (payment rails), `patterns/offline/OFFLINE_FIRST_SYNC.md` (offline operation), `patterns/architecture/POSTGRES_JOB_QUEUE_SKIP_LOCKED_PATTERN.md` (background queues), `patterns/architecture/LEGAL_DATA_MODELING_LTREE_PATTERN.md` (hierarchical data / LTREE), `patterns/compliance/INDONESIAN_LEGAL_HIERARCHY_PATTERN.md` (legal / regulatory citation), `patterns/architecture/REPOSITORY_BACKED_ARCHITECTURE_DIAGRAM_PATTERN.md` (verifiable architecture diagrams), `patterns/architecture/LEGACY_MODERNIZATION_STRANGLER_PATTERN.md` (inherited systems: strangler fig, characterization tests, per-phase rollback), `references/architecture/BACK_OF_THE_ENVELOPE_CAPACITY_PLAYBOOK.md` (BOTEC sizing), `patterns/resilience/FAULT_TOLERANCE_AND_DEGRADATION_PATTERN.md` (resilience & retry jitter), `references/architecture/QUALITY_ATTRIBUTES_AND_RISK_FRAMEWORK.md` (quality attributes & risk register), `references/architecture/SENIOR_ARCHITECT_ASSESSMENT_PLAYBOOK.md` (debt assessment & blast radius), `patterns/architecture/DATABASE_SCHEMA_AND_QUERY_OPTIMIZATION_PATTERN.md` (DDL, FK indexation & SARGable queries), `patterns/architecture/REALTIME_COMMUNICATION_AND_API_PROTOCOLS_PATTERN.md` (SSE vs WebSocket vs Polling), `patterns/architecture/SUPER_ARCHITECTURE_AND_ADAPTIVE_CONTROL_PATTERN.md` (S.U.P.E.R architecture & adaptive control), `patterns/architecture/SVG_TECHNICAL_DIAGRAM_STANDARD_PATTERN.md` (clean SVG diagram house style), `patterns/architecture/CACHING_STRATEGIES_AND_DATA_CONSISTENCY_PATTERN.md` (caching strategies & CAP consistency), `patterns/architecture/SYSTEM_DESIGN_METHODOLOGY_PATTERN.md` (system design methodology & trade-offs), `patterns/architecture/RESTFUL_API_DESIGN_PATTERN.md` (RESTful API design & resource modeling), `patterns/architecture/API_DESIGN_CHEAT_SHEET_PATTERN.md` (API design guidelines & best practices cheat sheet), `patterns/architecture/RESTFUL_API_DESIGN_PATTERN.md` (API-as-a-product principles), `patterns/architecture/AI_AGENT_SYSTEM_PROMPT_ENGINEERING_PATTERN.md` (agent system prompts & execution guardrails), `patterns/execution/FULLSTACK_EXECUTION_ROADMAP_PATTERN.md` (full-stack milestone execution breakdown), `patterns/execution/AI_FULLSTACK_DELIVERY_WORKFLOW_PATTERN.md` (AI full-stack master control & 17-role routing), `patterns/execution/CLAUDE_CODE_SPEC_WORKFLOW_PATTERN.md` (Claude Code spec-driven dev & context optimization), `patterns/execution/CLAUDE_SKILLS_SPECIALIZED_PAIR_PROGRAMMER_PATTERN.md` (specialized pair-programmer skill sets), `patterns/execution/DATA_ENGINEERING_DBT_SNOWFLAKE_PATTERN.md` (dbt & Snowflake analytics engineering), `patterns/execution/DATA_ENGINEERING_AGENT_SKILLS_RELIABILITY_PATTERN.md` (data engineering agent skills & reliability), `patterns/execution/TECHNICAL_WRITER_ENGINEERING_PROSE_PATTERN.md` (technical writer engineering prose & anti-slop), `patterns/execution/SQL_DATA_WAREHOUSE_MEDALLION_PATTERN.md` (SQL data warehouse & medallion architecture), `patterns/execution/PATTERNS_DEVKIT_COMPONENT_DATA_GRAPHS_PATTERN.md` (Patterns devkit component-based data graphs), `patterns/execution/QA_SKILLS_AI_AUGMENTED_QUALITY_ASSURANCE_PATTERN.md` (AI-augmented QA workflows), `patterns/execution/GRAFANA_K6_PERFORMANCE_AND_CHAOS_TESTING_PATTERN.md` (Grafana k6 performance & chaos testing), `patterns/qa/UAT_UNTRUSTED_OUTPUT_BOUNDARY_PATTERN.md` (browser UAT automation & untrusted-output boundaries), `patterns/execution/CLOUDFLARE_SECURITY_AUDIT_VULNERABILITY_PATTERN.md` (Cloudflare security audit & vulnerability hunting), `patterns/execution/SECURITY_AUDIT_CHECKPOINTS_PATTERN.md` (automated security audit & OWASP checkpoints), `patterns/execution/WEB_PENTEST_METHODOLOGY_PATTERN.md` (web pentest methodology & AI skill architecture), `patterns/execution/OWASP_SECURITY_CODE_REVIEW_PATTERN.md` (OWASP code review & evidence-driven auditing), `patterns/execution/DEVOPS_SRE_AGENT_SKILLS_PATTERN.md` (DevOps & SRE agent-ready SKILL.md pattern), `patterns/execution/ENTERPRISE_CICD_AUTOMATION_PATTERN.md` (enterprise CI/CD & quality gate automation), `patterns/execution/AGENT_SKILL_INJECTION_FRAMEWORK_PATTERN.md` (Enterprise agent framework & trigger-based skill injection), `patterns/execution/AGENT_SKILLS_CUSTOMER_SERVICE_MCP_PATTERN.md` (Enterprise agentic customer service & MCP multi-turn testing), `patterns/execution/AWESOME_AGENT_SKILLS_ECOSYSTEM_PATTERN.md` (Awesome agent skills & progressive disclosure ecosystem), `patterns/execution/CLAUDE_SEO_GENERATIVE_ENGINE_OPTIMIZATION_PATTERN.md` (Enterprise AI search & technical SEO optimization), `patterns/execution/MARKETING_SKILLS_GROWTH_ENGINEERING_PATTERN.md` (Enterprise growth engineering & marketing intelligence), `patterns/execution/METADATA_SERP_OPTIMIZATION_PATTERN.md` (Enterprise metadata & SERP optimization), `patterns/execution/APP_STORE_OPTIMIZATION_ASO_PATTERN.md` (Enterprise app store optimization ASO)

**Inputs**: `SCOPE_STATEMENT.md` (M02) + `DESIGN_SPEC.md` (M04) + Wireflow Scenarios in `docs/specs/wireflows/` (`SCENARIOS_WFxx.md`); Small uses `PROJECT_LITE.md`.
**Outputs**: `docs/specs/PRD.md` + `docs/specs/FSD.md` → ready for M06. Small: pinned into `PROJECT_LITE.md` §5 + human sign-off (§6).

**Scale Routing**:
- **Small (Fast-Track)**: NO `PRD.md`/`FSD.md` — stack lock, DDL, API list, security blueprint, Module 04 handoff pinned into **Section 5 of `PROJECT_LITE.md`**.
- **Enterprise**: routed to **A-Series Phase A02** + mandatory `docs/governance/ADR.md` and `docs/governance/AUDIT_TRAIL_REQUIREMENTS.md`; solo coding prohibited.
- **Large (optional) / Enterprise path**: `M05B` in `references/playbooks/SCALE_WORKFLOWS.md` produces `SYSTEM_DESIGN_DOC.md`, `CAPACITY_PLANNING.md`, `DISASTER_RECOVERY_PLAN.md` from the templates in `templates/03-architecture-specs/`. M05B is a playbook work package, **not** a separate `validate-gate.sh` gate — the M05 gate itself verifies the stack lock, blueprint, handoff, and the High-Water-Mark/solo-capacity classifier.

---

## Execution Steps

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

Review M01/M02 decisions, `PROJECT_STATE.md`, the approved scope, and M04 design before asking anything. Reuse confirmed answers and record their source. Ask only targeted questions for missing or conflicting decisions that materially affect stack, data, deployment, scale, or compliance; use the questionnaire below as a prompt bank, not a second intake interview:
**Team Expertise · Database Experience · Deployment Topology · Expected Scale (Year 1) · Data Model Characteristics · DevOps Complexity Tolerance · Critical Feature Priority · Compliance Requirements**

Present 2–3 viable options with trade-offs when the stack remains undecided. The human selects and records the stack lock; carry forward any earlier decisions that remain valid.

### STEP 2: Tech Stack Justification & Ecosystem Libraries Locking

Reasoning for the chosen stack; **alternatives rejected with reasons**; topology aligned with budget & scale. Content must adapt to the stack (PostgreSQL → SQL DDL, MongoDB → Mongoose, Laravel → Eloquent migrations, Django → ORM — never AI-SLOP generic schemas; anti-patterns in deep dive).

- **Ecosystem Libraries & Auth Solution Locking**: Evaluate only companion libraries required by this product and lock choices that affect M06. Prefer built-in framework capabilities when they meet the requirements:
  - **Authentication & Session**: Next.js (Better Auth / Supabase Auth / Auth.js) vs Laravel (Breeze / Sanctum / Fortify) vs Django (allauth) vs Go/FastAPI (JWT / OAuth2).
  - **Validation & Serialization**: Zod / Valibot (TS) vs Form Requests (Laravel) vs Pydantic (Python).
  - **State Management & Data Fetching**: Zustand / TanStack Query (React) vs Pinia (Vue) vs Inertia / Livewire.
  - **UI Primitives & Motion**: derive framework mappings from the already-approved M04 component inventory and design tokens; do not choose a second UI system here.
  - **Access Control & Permissions**: Explicit RBAC / ReBAC model implementation (per `patterns/security/ACCESS_CONTROL_PATTERNS.md`).
  - Evaluate each category only when the product needs it; prefer existing framework capabilities where sufficient and record `N/A` with a short reason otherwise.

**Risk-triggered security and vendor references**: Load `patterns/security/THREAT_MODELING_STRIDE_PATTERN.md` and the relevant security pattern when the product handles personal/sensitive data, payments, public APIs, multi-tenant access, or privileged roles; use the project data classification and threat model to select controls. For a third-party service, first assess data handled, failure impact, exit path, and cost in the vendor/build-vs-buy decision. After the stack and provider are chosen, consult that provider's official skill or documentation for integration details; vendor-specific guidance does not replace the project's threat model or security review.

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

### STEP 6: Write Deliverables

- `docs/specs/PRD.md` via `PRD_FINAL_TEMPLATE.md` (F-xx → REQ-xx traceability, BDD Given-When-Then criteria).
- `docs/specs/FSD.md` via `FSD_TECHNICAL_TEMPLATE.md` (DDL, API contracts, access controls, atomic high-risk mutations, Prototype Conversion Strategy, synthesizing state transitions & logic from `docs/specs/wireflows/`) + pinned versions verbatim.
- **Small**: pin Steps 1–5 into `PROJECT_LITE.md` §5 instead (no TBD/maybe/tentative in Must-Have features).

### STEP 7: Technical Sign-Off

The **human** signs (Client Single PIC, or on solo work the developer); an AI agent is never a valid approver. The gate **fails** on residual `____` / `[YYYY-MM-DD]` / `[Your Name]` fields — a real name + date is required (same false-green the M04 Design Freeze guard closes). M05 is **not** a stop point: after sign-off, chain to M06 for Small/Solo SaaS; on Client work pause for explicit "Proceed to Module 06". Changes requested → revise and re-run.

---

## [GATE] Exit Criteria (condensed)

- [ ] Existing architecture inputs reconciled; material gaps resolved; stack **LOCKED** by a named human (`Stack Decision LOCKED:` + `Stack-Locked-by:`)
- [ ] Versions verified via registry script, pinned verbatim in `Framework Versions (Pinned):` (M06 `verify-framework-version.sh` reads it)
- [ ] Stack justification with rejected alternatives
- [ ] DDL present (tables, keys, CHECK, indexes, audit trail)
- [ ] All in-scope API operations have complete contracts, or `N/A — no application API`; idempotency for high-risk mutations
- [ ] Security blueprint complete with risk-appropriate decisions (encryption, password hashing, OWASP-relevant controls, rate limits, and applicable privacy obligations) and enforcement/verification references; each item resolved or `N/A — <reason>` *(gate-enforced)*
- [ ] Granular RBAC Role Capability & Limitation Matrix present in `FSD.md` when multiple roles are defined (Owner vs Manager vs Staff vs Member: Boleh vs DILARANG & UI Masked, dedicated views, server-side 403 authorization) *(gate-enforced)*
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
