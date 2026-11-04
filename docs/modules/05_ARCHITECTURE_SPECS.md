# Module 05: Architecture & Technical Specifications (PRD & FSD)

> **Templates**: `templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md`, `FSD_TECHNICAL_TEMPLATE.md` · `templates/03-architecture-specs/ARCHITECTURE_DEBT_AND_DRIFT_REGISTER_TEMPLATE.md` · Medium+: `templates/03-governance/ADR_TEMPLATE.md` (→ `docs/governance/ADR.md`)
> 📖 **Optional** (do NOT preload): `references/solo/SOLO_ARCHITECTURE_GUIDE.md` · `references/stacks/STACK_SUPPORT_MATRIX.md` · `references/architecture/PRODUCTION_DISTRIBUTED_SYSTEMS_CHECKLIST.md` (111 production realities — read only the rows your scale requires; state per-subsystem CAP choice and acceptance of the skipped items) · `patterns/product/BUSINESS_ANALYSIS_DISCOVERY_PATTERN.md` §6 (the five review passes) · deep dive `deep-dives/05_ARCHITECTURE_SPECS.md`
> **Conditional patterns** (open only when the project needs it): `patterns/` holds the Indonesia-specific rails — `compliance/UU_PDP_COMPLIANCE.md`, `payments/INDONESIA_PAYMENT_GATEWAYS.md`, `offline/OFFLINE_FIRST_SYNC.md`, `security/ACCESS_CONTROL_PATTERNS.md`, `security/THREAT_MODELING_STRIDE_PATTERN.md`, `architecture/*` queue/LTREE/strangler patterns, `resilience/FAULT_TOLERANCE_AND_DEGRADATION_PATTERN.md`; `references/architecture/` holds the BOTEC capacity playbook and the quality-attribute frame. Load a pattern only for the concern in front of you.

**Inputs**: `SCOPE_STATEMENT.md` (M02) + `DESIGN_SPEC.md` (M04) + Wireflow Scenarios in `docs/specs/wireflows/` (`SCENARIOS_WFxx.md`); Small uses `PROJECT_LITE.md`.
**Outputs**: `docs/specs/PRD.md` + `docs/specs/FSD.md` → ready for M06. Small: pinned into `PROJECT_LITE.md` §5 + human sign-off (§6).

**Scale Routing**:
- **Small (Fast-Track)**: NO `PRD.md`/`FSD.md` — stack lock, DDL, API list, security blueprint, Module 04 handoff pinned into **Section 5 of `PROJECT_LITE.md`**.
- **Enterprise**: routed to **A-Series Phase A02** + mandatory `docs/governance/ADR.md` and `docs/governance/AUDIT_TRAIL_REQUIREMENTS.md`; solo coding prohibited.
- **Large (optional) / Enterprise path**: `M05B` in `references/playbooks/SCALE_WORKFLOWS.md` produces `SYSTEM_DESIGN_DOC.md`, `CAPACITY_PLANNING.md`, `DISASTER_RECOVERY_PLAN.md` from the templates in `templates/03-architecture-specs/`. M05B is a playbook work package, **not** a separate `validate-gate.sh` gate — the M05 gate itself verifies the stack lock, blueprint, handoff, and the High-Water-Mark/solo-capacity classifier.

---

## Execution Steps

### STEP 0: Version Check (MANDATORY FIRST)

Never trust training-data versions. Run the registry check for the locked framework:

```bash
./scripts/verify/check-package-versions.sh <nextjs|expo|laravel|django|go|fastapi|rails|mern|aspnet|spring|serverless|flutter|remix|astro|sveltekit|nuxt>
```
```powershell
.\scripts\verify\check-package-versions.ps1 -Framework <nextjs|...|nuxt>
```

- Stack list source of truth: `references/stacks/STACK_SUPPORT_MATRIX.md`. If your PRODUCTION stack is missing from either script, report the gap (Core rule 7).
- Pin the proven stable version; when a bleeding-edge major breaks the ecosystem, pin the stable one explicitly.
- Read the official release notes / migration guide for the chosen major and record that URL plus the breaking changes in `docs/specs/FSD.md` — this is what stops deprecated M06 code.
- Transcribe the agreed versions **verbatim** into the `Framework Versions (Pinned):` bullet block of `docs/specs/FSD.md`; `scripts/verify/verify-framework-version.sh` reads it in M06. **Machine-read — do not reformat**: keep the colon heading and the `- <Package>: <version>` bullets, and delete stacks you did not lock (a stale `- Django:` line, or a table, fails M06).

### STEP 1: Resolve Architecture Inputs (BLOCKS STACK LOCK)

**Existing codebase (conditional)**: extending or replacing a repo? Inspect entry points, runtime/config, data stores and models, integrations, auth boundaries, tests and deployment path first. Cite files or commands as evidence and mark anything unverified `UNKNOWN`. Use `patterns/architecture/LEGACY_MODERNIZATION_STRANGLER_PATTERN.md` when replacement is incremental. Greenfield → record `N/A — no existing codebase`.

Review M01/M02 decisions, `PROJECT_STATE.md`, the approved scope and the M04 design before asking anything; reuse confirmed answers and cite their source. Ask only targeted questions about missing or conflicting decisions that change stack, data, deployment or compliance. Prompt bank (not a second intake interview): **team expertise · database experience · deployment topology · expected scale (year 1) · data model · DevOps tolerance · critical feature priority · compliance**. Present 2–3 viable options with trade-offs when the stack is undecided; the human records the stack lock, and earlier decisions that still hold are carried forward.

### STEP 2: Tech Stack Justification & Ecosystem Libraries Locking

Justify the chosen stack, name the **alternatives rejected with reasons**, and align topology with budget and scale. Content must adapt to the stack (PostgreSQL → SQL DDL, MongoDB → Mongoose, Laravel → Eloquent migrations, Django → ORM — never generic AI schemas).

- **Ecosystem libraries & auth**: lock only the companions M06 will install, per product need — auth/session, validation, state & data fetching, access control (`patterns/security/ACCESS_CONTROL_PATTERNS.md`), UI primitives. UI primitives derive from the approved M04 inventory; never introduce a second UI system. Candidate lists per framework: `templates/03-architecture-specs/FSD_TECHNICAL_TEMPLATE.md`.
- **Prefer the framework's own capability** where it suffices; record `N/A — <reason>` for categories the product does not need.

**Risk-triggered security & vendor refs**: load `patterns/security/THREAT_MODELING_STRIDE_PATTERN.md` and the matching pattern when the product touches personal data, payments, public APIs, multi-tenancy or privileged roles, and pick controls from the data classification and threat model. For a third-party service, assess data handled, failure impact, exit path and cost before deciding. Consult the provider's own docs for integration details; they never replace your threat model.

**C4 views (conditional)**: add System Context and/or Container when several deployable services, stores, external systems or trust boundaries make the shape hard to read from the DFD; Component only when one container needs it. Keep them consistent with stack, DFD and threat model, otherwise `N/A — DFD is sufficient`.

### STEP 3: Database Schema & Object Storage Design (ERD, DDL & Media)

- **Visual ERD (Mermaid)**: `erDiagram` with cardinality (one-to-many, many-to-many) across the core entities.
- **DDL & indexes**: tables, PK/FK, CHECK constraints, composite indexes (`idx_*`) on query columns and foreign keys — syntax per the chosen DB.
- **Object storage & media**: if users upload media, choose the store and define access, size/type validation, retention and delivery; otherwise `N/A — no user-uploaded media` (recorded in the FSD `Object storage decision`, and in `PROJECT_LITE.md` for Small). Set size limits from product + provider + abuse risk, validate type and size server-side, pick cache headers by access level (private data must not inherit public immutable caching), and keep large binaries out of relational columns unless you document why inline is right.
- **Deletion & retention**: define retention/deletion per data class. Soft-delete only when restoration or a tombstone is required; immutable financial/audit records get explicit reversal records. Add a partial unique index only when a value may be reused after soft-delete.
- **Connection management**: for serverless or high-concurrency runtimes follow the provider's current pooling guidance; document migration and runtime connection paths separately when they differ.
- **Audit fields**: choose from entity lifecycle and traceability needs; do not add `updated_at` or soft-delete to immutable records without a reason.
- **Multi-tenant isolation** (RLS / schema-per-tenant / DB-per-tenant) when applicable.
- **Idempotency**: an `idempotency_keys` table or equivalent for financial/stock mutations where a retry could duplicate a state change.
- **Caching**: only for measured or expected read pressure, with consistency and invalidation rules — else `N/A — no cache needed at this scale`.
- **Async processing**: a durable queue for work that outlives a request or needs retry/isolation — else `N/A — request-bound work is sufficient`.
- **RPO/RTO**: derive recovery targets from the business impact of loss and downtime, then choose backups and restore procedure to fit budget and operating model. RPO ≤24h / RTO ≤2h are examples, not defaults.

### STEP 4: API Contracts & Realtime Transport

- Document every in-scope operation from the requirements and wireflows; **never invent endpoints to meet a count**. Per operation: method/path (or protocol operation), auth, idempotency where needed, request/response schema, success and error behaviour. No application API → `N/A — no application API`.
- **Bounded pagination, always**: every collection endpoint enforces a cap (default `limit=20`, hard max `MAX_LIMIT=100`); unbounded `SELECT *` without `LIMIT` is prohibited (OOM). High-volume feeds (activity, transactions, chat history) use cursor pagination, not deep offsets.
- **Rate limit & cost ceilings**: auth, OTP email, AI inference and file upload declare limits (e.g. 5/min per IP/user) so a third-party bill cannot spike.
- **Realtime & offline transport** (when applicable): an explicit protocol — WebSocket / Supabase Realtime / SSE — never `setInterval` polling loops for realtime flows — plus reconnection and state-recovery behaviour.
- One heading per HTTP endpoint (`#### POST /api/v1/...`) so each contract reviews independently.

### STEP 5: Security Blueprint, Secrets Validation & Module 04 Handoff (gate-enforced)

- **Security**: choose controls from the STRIDE model and data classification; record the decision, enforcement point and verification path for encryption at rest (including whether application-level AES-256-GCM is warranted), password hashing (Argon2id or the identity provider's managed approach), OWASP-relevant risks, rate limits, edge protection and privacy obligations. Keep `N/A — <reason>` explicit; never prescribe a vendor or control without a project need.
- **Threat-to-verification traceability**: map each consumed threat to its FSD control, enforcing component and planned M07 verification; keep threat IDs stable across threat model, FSD and security audit.
- **RBAC capability matrix** (multiple roles → `docs/specs/FSD.md` §4.0): (1) allowed business actions per role; (2) **DILARANG & UI MASKED** negative boundaries — profit/loss, bank accounts, staff management and audit logs are invisible to lower roles; (3) a dedicated operational view per lower role (e.g. `/staff`), never read-only disabled executive views; (4) **backend authorization** — server actions, mutations and endpoints independently enforce the role and return 403, because route masking alone is not enforcement.
- **Typed env schema** (`.env.example` + Zod / `@t3-oss/env-nextjs` / Pydantic) so the app fails fast at startup when a secret is missing.
- **Handoff**: prototype → framework conversion (component map, token extraction). The gate needs a section **named `Module 04 Handoff Strategy`** carrying **`Compatibility Level: Level 1-4`** — M06 STEP 0 parses those exact strings; level table in `FSD_TECHNICAL_TEMPLATE.md` §2.1.

### STEP 6: Write Deliverables

- `docs/specs/PRD.md` via `PRD_FINAL_TEMPLATE.md` (F-xx → REQ-xx traceability, BDD Given-When-Then criteria).
- `docs/specs/FSD.md` via `FSD_TECHNICAL_TEMPLATE.md` (DDL, API contracts, access controls, atomic high-risk mutations, Prototype Conversion Strategy, synthesizing state transitions & logic from `docs/specs/wireflows/`) + pinned versions verbatim.
- **Small**: pin Steps 1–5 into `PROJECT_LITE.md` §5 instead (no TBD/maybe/tentative in Must-Have features).

### STEP 7: Technical Sign-Off

Before sign-off, review the FSD (or Section 5 of `PROJECT_LITE.md` for Small) against approved requirements/scope, any PRD, and the M04 handoff: confirm traceability, consistent decisions and diagrams, explicit assumptions/open items, and enough data/API/security/failure behavior for implementation without guessing. Resolve blockers or record an owner and decision point for non-blocking items. For existing repositories, verify the proposed changes account for the observed codebase constraints.

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
- [ ] Architecture review completed before technical sign-off; FSD or Small-path blueprint is implementable without guessing; existing-codebase constraints and conditional C4 views are addressed or marked `N/A`.
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

The live gate is the source of truth (`scripts/gates/modules/M05.sh` + M05 helpers in `lib/checks.sh`); where prose and script disagree, the script wins.

**Full detail**: the original Steps 0–5 text (per-framework library menus, every elaboration) is preserved in [`deep-dives/05_ARCHITECTURE_SPECS.md`](deep-dives/05_ARCHITECTURE_SPECS.md) — open it only when a step above is ambiguous.
