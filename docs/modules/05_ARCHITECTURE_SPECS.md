# Module 05: Architecture & Technical Specifications (PRD & FSD)

> **Templates to copy**: `templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md`, `FSD_TECHNICAL_TEMPLATE.md` · Enterprise/Medium+: `templates/03-governance/ADR_TEMPLATE.md` (→ `docs/governance/ADR.md`), `templates/03-governance/RISK_ASSESSMENT_MATRIX.md` (→ `docs/governance/RISK_ASSESSMENT_MATRIX.md`)
> 📖 **Optional** (do NOT preload): `references/solo/SOLO_ARCHITECTURE_GUIDE.md` · `references/stacks/STACK_SUPPORT_MATRIX.md` · deep dive `deep-dives/05_ARCHITECTURE_SPECS.md` (full question bodies, rationale, verbose prompts)
> Conditional (open only if the project needs it): `patterns/compliance/UU_PDP_COMPLIANCE.md` (personal data), `patterns/payments/INDONESIA_PAYMENT_GATEWAYS.md` (payment rails), `patterns/offline/OFFLINE_FIRST_SYNC.md` (offline operation)

**Inputs**: `SCOPE_STATEMENT.md` (Module 02) + `DESIGN_SPEC.md` (Module 04). Small scale: unified `PROJECT_LITE.md`.
**Outputs**: `docs/specs/PRD.md` + `docs/specs/FSD.md` → ready for Module 06.

**Scale Routing**:
- **Small (Fast-Track)**: NO `PRD.md`/`FSD.md` — stack lock, DDL, API list pinned into **Section 5 of `PROJECT_LITE.md`** (≥1000B).
- **Enterprise**: routed to **A-Series Phase A02** + mandatory `docs/governance/ADR.md` and `docs/governance/AUDIT_TRAIL_REQUIREMENTS.md`; solo coding prohibited.

---

## Execution Steps

### STEP 0: Version Check (MANDATORY FIRST)

Run real-time version check against official registries (never trust training-data versions):

```bash
./scripts/verify/check-package-versions.sh <nextjs|laravel|django|go|rails|mern|aspnet|spring|serverless|flutter|remix|astro|sveltekit|nuxt>
```

or Windows:

```powershell
.\scripts\verify\check-package-versions.ps1 -Framework <nextjs|laravel|django|go|rails|mern|aspnet|spring|serverless|flutter|remix|astro|sveltekit|nuxt>
```

- Pin verified versions; if a bleeding-edge major has ecosystem breakage (e.g., Tailwind v4 config changes, Zod v4 resolver incompatibility), pin the proven stable version explicitly.
- All agreed versions MUST be transcribed **verbatim** into the `Framework Versions (Pinned):` section of `docs/specs/FSD.md` so the Module 06 gate (`verify-framework-version.sh`) passes.

### STEP 1: Tech Stack Discovery Questionnaire (MANDATORY — BLOCKS FSD)

Ask the 8 questions, END TURN, wait for answers (full option lists in deep dive):
**Team Expertise · Database Experience · Deployment Topology · Expected Scale (Year 1) · Data Model Characteristics · DevOps Complexity Tolerance · Critical Feature Priority · Compliance Requirements**

Then generate **2–3 stack options** with cost/pros/cons comparison and **the user LOCKS the stack**. There is no default stack; changing after lock costs +2 weeks timeline.

### STEP 2: Tech Stack Justification

Context-specific reasoning for the chosen stack; **alternatives rejected with reasons**; deployment topology aligned with budget & scale. Content must adapt to the chosen stack (PostgreSQL → SQL DDL, MongoDB → Mongoose, Laravel → Eloquent migrations, Django → ORM models — never AI-SLOP generic schemas; anti-patterns in deep dive).

### STEP 3: Database Schema Design (DDL)

- Tables, primary/foreign keys, CHECK constraints, indexes — syntax per chosen DB.
- Audit trail strategy: `created_at`, `updated_at`, `actor_id`, soft-delete.
- Multi-tenant isolation (RLS / schema-per-tenant / DB-per-tenant) if applicable.
- `idempotency_keys` table in DDL for all POST mutations of financial/stock state.

### STEP 4: API Endpoint Matrix (≥10 endpoints)

- HTTP verb, path, auth, idempotency headers; JSON request/response schemas; success-vs-error matrix; API style per stack (REST/GraphQL/tRPC).

### STEP 5: Security Blueprint + Module 04 Handoff

- **Security**: AES-256-GCM data-vault encryption (envelope encryption), Argon2id password hashing, OWASP Top 10 protections, rate limiting, UU PDP compliance (consent, deletion right, audit logs), framework-specific patterns.
- **Handoff**: conversion strategy Module 04 prototype → chosen framework; component mapping (React → Vue/Svelte/Blade); design-token extraction for reuse.

### STEP 6: Write Deliverables

- `docs/specs/PRD.md` via `templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md` (traceability matrix F-xx → REQ-xx, domain logic defense, BDD Given-When-Then criteria).
- `docs/specs/FSD.md` via `templates/03-architecture-specs/FSD_TECHNICAL_TEMPLATE.md` (DDL, API contracts, security & access controls, atomic transactions for high-risk mutations, Prototype Conversion Strategy section).
- Transcribe pinned versions verbatim into FSD `Framework Versions (Pinned):`.
- **Small scale**: pin all of Steps 1–5 into Section 5 of `PROJECT_LITE.md` instead (no TBD/maybe/tentative in Must-Have features).

### STEP 7: Technical Sign-Off

Review with Client Single PIC (or solo self-approval); sign off. M05 is not a SKILL.md stop point: after sign-off (and gate pass) continue to M06 in the same flow for Small/Solo SaaS; on Client projects pause for explicit "FSD approved" / "Proceed to Module 06" before coding. If changes requested: revise, re-run gate.

---

## [GATE] Exit Criteria (condensed)

- [ ] 8-question questionnaire completed; 2–3 options presented; stack **LOCKED** (`Stack Decision LOCKED:` documented)
- [ ] Versions verified via registry script and pinned verbatim in FSD
- [ ] Stack justification with rejected alternatives
- [ ] DDL present (tables, keys, CHECK, indexes, audit trail)
- [ ] ≥10 API endpoints with request/response schemas; idempotency for financial POSTs
- [ ] Security blueprint complete (AES-256-GCM, Argon2id, OWASP, rate limiting, UU PDP)
- [ ] Module 04 handoff strategy documented
- [ ] File sizes: Small (3–7 P0) → `PROJECT_LITE.md` ≥1000B; otherwise `docs/specs/PRD.md` + `docs/specs/FSD.md` ≥2000B each
- [ ] Multi-tenant isolation + idempotency strategy documented if applicable
- [ ] Technical sign-off obtained

### Gate Execution (MANDATORY — verbatim script output)

Run the real validator; do NOT paste pre-filled hardcoded checklists:

```bash
./scripts/gates/validate-gate.sh M05
```

or Windows:

```powershell
.\scripts\gates\validate-gate.ps1 M05
```

If it exits FAILED: fix artifacts and re-run — never declare completion on failure. Only after `✅ Gate validation PASSED` present the handoff prompt (deep dive) and END TURN for approval. Script bodies (Phase 0 questionnaire check, file-size verification, content validation): deep dive, "Gate Script Bodies".
