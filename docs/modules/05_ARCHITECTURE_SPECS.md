# Module 05: Architecture & Technical Specifications (PRD & FSD)

> **Templates**: `templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md`, `FSD_TECHNICAL_TEMPLATE.md` · Medium+: `templates/03-governance/ADR_TEMPLATE.md` (→ `docs/governance/ADR.md`)
> 📖 **Optional** (do NOT preload): `references/solo/SOLO_ARCHITECTURE_GUIDE.md` · `references/stacks/STACK_SUPPORT_MATRIX.md` · deep dive `deep-dives/05_ARCHITECTURE_SPECS.md`
> Conditional (open only if the project needs it): `patterns/compliance/UU_PDP_COMPLIANCE.md` (personal data), `patterns/payments/INDONESIA_PAYMENT_GATEWAYS.md` (payment rails), `patterns/offline/OFFLINE_FIRST_SYNC.md` (offline operation)

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

### STEP 2: Tech Stack Justification

Reasoning for the chosen stack; **alternatives rejected with reasons**; topology aligned with budget & scale. Content must adapt to the stack (PostgreSQL → SQL DDL, MongoDB → Mongoose, Laravel → Eloquent migrations, Django → ORM — never AI-SLOP generic schemas; anti-patterns in deep dive).

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
  - Queries, views, or RLS policies MUST include automatic filtering for parent-child relationships (e.g. child records of a soft-deleted parent workspace/user are automatically excluded from active queries).
- Audit trail: `created_at`, `updated_at`, `actor_id`, soft-delete.
- Multi-tenant isolation (RLS / schema / DB-per-tenant) if applicable.
- `idempotency_keys` table for all POST mutations of financial/stock state.

### STEP 4: API Endpoint Matrix & Realtime Transport (≥10 endpoints — gate-enforced)

- HTTP verb, path, auth, idempotency headers; JSON request/response schemas; success-vs-error matrix; style per stack (REST/GraphQL/tRPC).
- **Rate Limit & Cost Ceilings Guardrails**:
  - Sensitive endpoints (Auth, OTP email, AI inference, file upload) MUST specify rate limit boundaries (e.g., max 5 requests/min per IP/user) to prevent billing shocks on third-party SaaS APIs.
- **Realtime & Offline Transport Architecture** (if applicable: collaborative canvas, live chat, notifications):
  - Explicit transport protocol: WebSocket / Supabase Realtime / Server-Sent Events (SSE). Polling loops (`setInterval`) are forbidden for realtime flows.
  - Reconnection & state recovery strategy on network drop.
- **One heading per endpoint** (`#### POST /api/v1/...`) — the gate counts these headings and fails below 10.

### STEP 5: Security Blueprint + Module 04 Handoff (both gate-enforced)

- **Security**: record AES-256-GCM envelope encryption, Argon2id hashing, OWASP Top 10, rate limiting (+ UU PDP on Medium+). Gate-enforced; `N/A — <reason>` accepted, blank not.
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
