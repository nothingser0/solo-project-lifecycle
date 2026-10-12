# Module 05: Architecture & Technical Specifications (PRD & FSD)

> **Templates to copy**: `templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md`, `FSD_TECHNICAL_TEMPLATE.md` · Enterprise/Medium+: `templates/03-governance/ADR_TEMPLATE.md` (→ `docs/governance/ADR.md`), `templates/03-governance/RISK_ASSESSMENT_MATRIX.md` (→ `docs/governance/RISK_ASSESSMENT_MATRIX.md`)
> 📖 **Optional** (do NOT preload): `references/solo/SOLO_ARCHITECTURE_GUIDE.md` · `references/stacks/STACK_SUPPORT_MATRIX.md` · deep dive `deep-dives/05_ARCHITECTURE_SPECS.md` (full question bodies, rationale, verbose prompts)
> Conditional (open only if the project needs it): `patterns/compliance/UU_PDP_COMPLIANCE.md` (personal data), `patterns/payments/INDONESIA_PAYMENT_GATEWAYS.md` (payment rails), `patterns/offline/OFFLINE_FIRST_SYNC.md` (offline operation)

**Inputs**: `SCOPE_STATEMENT.md` (Module 02) + `DESIGN_SPEC.md` (Module 04). Small scale: unified `PROJECT_LITE.md`.
**Outputs**: `docs/specs/PRD.md` + `docs/specs/FSD.md` → ready for Module 06. Small: everything pinned into **Section 5** of `PROJECT_LITE.md` + the human sign-off (Section 6).

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

> Stack list source of truth: `references/stacks/STACK_SUPPORT_MATRIX.md`. A stack marked
> **PRODUCTION** there must be queryable by both scripts — if the one you locked is missing,
> report the gap rather than inventing versions from memory (rule 7).

- Pin verified versions; if a bleeding-edge major breaks the ecosystem (Tailwind v4 config, Zod v4
  resolver), pin the proven stable explicitly.
- Transcribe agreed versions **verbatim** into the `Framework Versions (Pinned):` bullet block of
  `docs/specs/FSD.md` (M06 gate `verify-framework-version.sh` reads it).
- **Machine-read — do not reformat**: keep the heading colon and the `- <Package>: <version>`
  bullets, and delete lines for stacks you did not lock (a stale `- Django:` line in a Next.js
  project fails the M06 comparison; so does a table or renamed heading).

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

### STEP 4: API Endpoint Matrix (≥10 endpoints for Medium+; ≥5 is the hard gate floor)

- HTTP verb, path, auth, idempotency headers; JSON request/response schemas; success-vs-error matrix; API style per stack (REST/GraphQL/tRPC).
- **One heading per endpoint** (`#### POST /api/v1/...`) — the gate counts these and fails below 5.
  ≥10 is the M05 exit criterion; 5 is the validator floor.

### STEP 5: Security Blueprint + Module 04 Handoff (both gate-enforced)

- **Security**: AES-256-GCM data-vault encryption (envelope encryption), Argon2id password hashing, OWASP Top 10, rate limiting, UU PDP (consent, deletion right, audit logs), framework-specific patterns. The gate requires these *recorded* (4 controls Small, +UU PDP Medium+).
- **Handoff**: Module 04 prototype → chosen framework conversion; component mapping (React → Vue/Svelte/Blade); design-token extraction. The gate requires a section **named `Module 04 Handoff Strategy`** carrying a **`Compatibility Level: Level 1-4`** line — M06 STEP 0 parses those exact strings; level definitions in `templates/03-architecture-specs/FSD_TECHNICAL_TEMPLATE.md` §2.1.

### STEP 6: Write Deliverables

- `docs/specs/PRD.md` via `templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md` (traceability matrix F-xx → REQ-xx, domain logic defense, BDD Given-When-Then criteria).
- `docs/specs/FSD.md` via `templates/03-architecture-specs/FSD_TECHNICAL_TEMPLATE.md` (DDL, API contracts, security & access controls, atomic transactions for high-risk mutations, Prototype Conversion Strategy section).
- Transcribe pinned versions verbatim into FSD `Framework Versions (Pinned):`.
- **Small scale**: pin all of Steps 1–5 into Section 5 of `PROJECT_LITE.md` instead (no TBD/maybe/tentative in Must-Have features).

### STEP 7: Technical Sign-Off

Review with Client Single PIC — or, on solo projects, the **human user** self-approves (an AI agent is never a valid approver); sign off by writing the reviewer's real name and date into the sign-off block. The gate **fails** on residual `____` / `[YYYY-MM-DD]` / `[Your Name]` fields: the sign-off must be a real human entry, not the untouched template row (the same false-green the M04 Design Freeze guard closes). M05 is not a SKILL.md stop point: after sign-off (and gate pass) continue to M06 in the same flow for Small/Solo SaaS; on Client projects pause for explicit "FSD approved" / "Proceed to Module 06" before coding. If changes requested: revise, re-run gate.

---

## [GATE] Exit Criteria (condensed)

<<<<<<< HEAD
- [ ] 8-question questionnaire completed; 2–3 options presented; stack **LOCKED** (`Stack Decision LOCKED:` + `Stack-Locked-by:` naming the human). The 8 answers must be **real values** — the gate rejects residual `[answer]` placeholders
- [ ] Versions verified via registry script and pinned verbatim in FSD `Framework Versions (Pinned):` (re-checked by M06's `verify-framework-version.sh`)
- [ ] Stack justification with rejected alternatives
- [ ] DDL present (tables, keys, CHECK, indexes, audit trail)
- [ ] ≥10 API endpoints with request/response schemas; idempotency for financial POSTs *(gate-enforced on Medium+)*
- [ ] Security blueprint complete *(gate-enforced)*; `Module 04 Handoff Strategy` + `Compatibility Level: Level 1-4` present *(gate-enforced; M06 STEP 0 depends on it)*
- [ ] Substantive `PROJECT_LITE.md` (Small) or `PRD.md` + `FSD.md` (Medium+) — target ≥1000B / ≥2000B each; the script stub-checks size, so judge real substance, not padding
- [ ] Multi-tenant isolation + idempotency strategy documented if applicable
- [ ] Technical sign-off obtained — **human name + real date, no residual blank/placeholder fields** *(gate-enforced; AI is never a valid approver)*
=======
- [ ] 8-question questionnaire completed; 2–3 options presented; stack **LOCKED** (`Stack Decision LOCKED:` documented)
- [ ] Versions verified via registry script and pinned verbatim in the FSD `Framework Versions (Pinned):` bullet block (parseable by `verify-framework-version.sh` at M06)
- [ ] Stack justification with rejected alternatives
- [ ] DDL present (tables, keys, CHECK, indexes, audit trail)
- [ ] ≥10 API endpoint **headings** (`#### <VERB> /path`) with request/response schemas; idempotency for financial POSTs (gate floor: 5)
- [ ] Security blueprint complete (AES-256-GCM, Argon2id, OWASP, rate limiting, UU PDP) — each control resolved or `N/A — <reason>`
- [ ] Module 04 handoff strategy documented (screen → route → component map + compatibility level)
- [ ] File sizes: Small → `PROJECT_LITE.md` ≥1000B; otherwise `PRD.md` + `FSD.md` ≥2000B each (targets only — see note below)
- [ ] Idempotency strategy if applicable. RLS required **only** when `Intake-Branch-Hierarchy` is yes/multi (or the DDL declares `org_id`/`tenant_id`); single-tenant passes with `N/A — single tenant`
- [ ] Medium+ only: `docs/governance/ADR.md` present (M05 gate requires it); Enterprise additionally requires `docs/governance/AUDIT_TRAIL_REQUIREMENTS.md`
- [ ] Technical sign-off obtained
>>>>>>> 026a538 (fix(m05): stop false RLS failures and count endpoint headings)

> **Scale note**: size figures above are documented targets. `lib/checks.sh` treats `min_size` as
> advisory (v2: stub-check only, `<40B` fails) — content checks are what reject.

### Gate Execution (MANDATORY — verbatim script output)

Run the real validator; do NOT paste pre-filled hardcoded checklists:

```bash
./scripts/gates/validate-gate.sh M05
```

or Windows:

```powershell
.\scripts\gates\validate-gate.ps1 M05
```

<<<<<<< HEAD
If it exits FAILED: fix artifacts and re-run — never declare completion on failure. Only after `✅ Gate validation PASSED` present the handoff prompt (deep dive) and END TURN for approval.

The live gate is the source of truth: `scripts/gates/modules/M05.sh` + the M05 helpers in `scripts/gates/lib/checks.sh`. The pseudo-code in the deep dive is an illustrative sketch of the same contract — when the two disagree, the script wins.
=======
If it exits FAILED: fix artifacts and re-run — never declare completion on failure. Only after `✅ Gate validation PASSED` present the handoff prompt (deep dive) and END TURN for approval. Full check-by-check breakdown: deep dive, "What `validate-gate.sh M05` actually checks".
>>>>>>> 026a538 (fix(m05): stop false RLS failures and count endpoint headings)
