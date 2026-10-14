# TODO.md — Engineering Execution Plan & Automated Quality Gates

> **Role**: Sequential atomic task list. The **agent implements ONE task, runs `Verify`, reports `Evidence`, and STOPS**. The **human confirms before the next task starts**. `[x]` is the human's mark, not the agent's.
> **Integrity**: Zero unverified tasks. Zero features outside In-Scope. Zero suppressed compiler errors.
> **Full worked example** (POS/retail, 7 sprints): `templates/04-dev-execution/examples/TODO_EXAMPLE_POS_RETAIL.md`

## Execution protocol (task-by-task, human-verified)

```
For each task:
  1. Agent implements ONLY this task (no lookahead, no bundling).
  2. Agent runs the task's `Verify` command and pastes raw output.
  3. Agent reports: task ID · files touched · Verify output · blockers.
  4. 🛑 Agent ENDS TURN. It does NOT start the next task.
  5. Human reviews, runs the app / checks the diff, then either:
       - approves  → agent marks `- [x]` and proceeds to the next task, OR
       - rejects   → agent fixes and re-reports (task stays `- [~]`).
```

**Approval marker (gate-enforced)**: when the human approves a task, append the line below to that task's **Evidence**. `validate-gate.sh M06` **fails** on any `[x]` task whose block lacks it — an agent that ticks its own boxes cannot pass the gate.

```
**Evidence**: <raw command output> | Approved: 2026-10-12 by <name>
```
*(accepted spellings: `Approved:`, `Approved by`, `Disetujui`)*

**Batch mode (opt-in only)**: the human may authorize a contiguous run of named task IDs (e.g. "run M06-DB-01…04 without stopping"). Without that explicit instruction, **one task per turn is the default at every scale** — including autopilot, which chains *modules*, never individual tasks.

**Never**: implement a whole sprint in one turn, mark `[x]` without human approval, or continue past a failing `Verify`.

## Scale adaptation

- **Small (MVP/Internal)**: core DB, UI shell, essential CRUD, smoke tests. Mark billing/webhooks/offline as N/A.
- **Medium (B2B SaaS/Agency)**: multi-tenant RLS, state journals, mutation idempotency, automated QA.
- **Large/Enterprise**: row-locking, audit vaults, load testing, disaster recovery.

## Task architecture (8 mandatory elements)

1. **Task ID** — `M06-DB-01`, `M06-BE-01`, `M06-FE-01` (used in commits/test logs)
2. **Title & single objective** — 1 table, 1 endpoint, or 1 screen only
3. **Files** — exact target paths (stops ad-hoc path invention)
4. **Depends** — preceding task IDs required first
5. **Action** — precise implementation instructions & constraints
6. **Out of Scope** — what NOT to touch in this task
7. **Verify & Expected** — executable command + deterministic success criteria
8. **Status** — `- [ ]` pending | `- [~]` in progress | `- [!]` blocked (with reason) | `- [x]` completed (exit 0 + evidence)

## Task ID prefixes
The framework defines exactly **7 closed task categories** across all project scales (Small, Medium, Large, Enterprise). Sub-categories are strictly expressed via sprint section headers and task titles rather than inventing new prefixes.
| Prefix | Source | Output |
| :--- | :--- | :--- |
| `M06-SETUP-xx` | Environment, DB config, design assets | `.env.local`, DB connection, brand assets |
| `M06-DB-xx` | `FSD.md` (§schema/RLS/RPC) or `PROJECT_LITE.md` §5 | `migrations/*.sql` (tables, RLS, RPCs) |
| `M06-BE-xx` | `FSD.md` §API & `PRD.md` | `src/actions/*`, `src/app/api/*` |
| `M06-FE-xx` | `SITEMAP.md` & `DESIGN_SPEC.md` | `src/app/*` (UI components, SCR-xx screens) |
| `M06-INT-xx` | `FSD.md` §integration | Live wire-up, webhooks, hardware |
| `M06-TEST-xx` | `PRD.md` acceptance criteria | `tests/db`, `tests/sit`, `tests/e2e` |
| `M06-GATE-xx` | Release protocols | Verified build, git handoff log |

**Module exit gate**: 100% tasks `[x]` (zero `[ ]`/`[~]`/`[!]`), build + typecheck exit 0, smoke tests pass, zero `@ts-ignore`, `validate-gate.sh M06` passed. Every `[x]` must trace to a **human approval** recorded in the task's `Evidence` — tasks the agent self-approved do not count.

**M06 output artifacts** (Module 06 §2): source code on `staging` · `RUNBOOK_LOCAL.md` · `VERIFY_LOCAL.md` · `AI_REVIEW_LOG.md` (M06-GATE-03) · `DEVELOPMENT_PROGRESS_TRACKER.md` (M06-GATE-04).

---

## Sprint 0: Environment Setup & Specs Pre-Read (MANDATORY FIRST)

- [ ] **M06-SETUP-01: Project Scaffolding & Local Environment Staging**
  - **Files**: `package.json` (or stack equivalent), `.env.local` (from `.env.example`)
  - **Action**: Run framework scaffold command locked in M05 (e.g. `pnpm create next-app@latest`). Copy root harness files from `docs/harness-root/` (`AGENTS.md`, `TODO.md`, `DESIGN.md`). Fill local DB credentials, secrets, API keys.
  - **Out of Scope**: No custom business logic or UI application code.
  - **Verify**: `npm run dev` (or stack equivalent: `php artisan serve` / `go run .`) boots clean and `./scripts/verify/verify-framework-version.sh` passes.
  - **Expected**: Project running cleanly locally, lockfile matching M05 locked versions.
  - **Evidence**: `<command output>`
    `Approved: [YYYY-MM-DD] by [Your Name]`

- [ ] **M06-SETUP-02: Design Assets & Visual Identity Audit**
  - **Files**: `public/` or `src/assets/`, `docs/design/inspiration/`
  - **Action**: Copy real brand logo, favicon, fonts, theme colors. No generic monochrome placeholder layouts.
  - **Verify**: Assets importable from UI components.
  - **Expected**: Valid brand assets, no rigid placeholder icons.

- [ ] **M06-SETUP-03: Specs Pre-Read Sign-Off (ALL SCALES)**
  - **Action**: Read in full BEFORE the first line of code — all scales: `AGENTS.md`, `CONTEXT.md`, `DESIGN.md`, `SITEMAP.md`, `DESIGN_SPEC.md`. Small: `PROJECT_LITE.md` §5 (schema + API list) replaces FSD/PRD. Medium+: `FSD.md` (DDL, RLS, API, idempotency) + `PRD.md` (traceability, BDD).
  - **Verify**: Record status model, idempotency rules, RLS policy, and Screen ID list to implement.
  - **Expected**: Full spec understanding before touching schema or UI files.

---

## Sprint 1: Database Foundation (skip if no DB — mark N/A)

- [ ] **M06-DB-01: Relational Schema & FK Indexing**
  - **Files**: `supabase/migrations/001_initial_schema.sql` (or Prisma/Drizzle/Laravel/Django/Go migrations)
  - **Depends**: `M06-SETUP-01`
  - **Action**: Define all FSD tables. Money as `BIGINT`/`NUMERIC(15,2)` (never float), fractional qty `NUMERIC(12,3)`. Explicit `CREATE INDEX` on every FK column + arithmetic CHECK constraints.
  - **Out of Scope**: No server actions, API routes, or UI.
  - **Verify**: Run migration locally (stack equivalent: `pnpm db:migrate` / `supabase db push` / `php artisan migrate` / `python manage.py migrate` / `goose up`).
  - **Expected**: Exit 0; all tables, indexes, constraints created.
  - **Evidence**: `<command output>`
    `Approved: [YYYY-MM-DD] by [Your Name]`

*(Repeat the 8-element pattern for: RLS/access control, idempotent registration RPC, atomic mutation procedures, sensitive-data views, idempotency/audit tables. See example file for full DB tasks.)*

## Sprint 2: Backend (skip if no backend — mark N/A)

- [ ] **M06-BE-01: API Boundary Validation (Zod)**
  - **Files**: `src/actions/*`, `src/app/api/v1/*`
  - **Action**: Map all data mutations to server actions/route handlers. Validate every payload with strict Zod schemas (`uuid`, `min`, `positive`, integer amounts).
  - **Verify**: Send dirty/empty payload to a server action.
  - **Expected**: Rejected with `VALIDATION_ERROR` + structured field errors.

*(Repeat for: RBAC route protection middleware, real mutation handlers. No dummy UUIDs; no empty `catch {}`.)*

## Sprint 3: Frontend

- [ ] **M06-FE-01: Design Tokens & Strict TS Config**
  - **Files**: `globals.css`, `tailwind.config.js`
  - **Action**: Register CSS variables per `DESIGN.md` (surface base, status triad, z-index). Install brand font.
  - **Verify**: `type-check` + DevTools color check.
  - **Expected**: Exit 0; variables resolve.

*(Repeat for each SCR-xx screen: 5-state matrix — idle/loading/empty/error/success. Mobile: inputs 16px, touch targets ≥44px, monetary inputs `inputmode="numeric"` with live thousand separators.)*

## Sprint 4: Frontend→Backend Wire-Up

- [ ] **M06-INT-01: Live Form Connection (Anti-Fake-Success)**
  - **Action**: Connect all forms to Sprint 2 handlers. Forbidden: empty `try/catch`, fake success popups on failed requests. Show specific backend error messages.
  - **Verify**: Submit while backend returns a validation error.
  - **Expected**: Red error toast with real server message; no success modal.

*(Conditional: payment webhooks with HMAC verification + idempotency keys; thermal printing fallbacks.)*

## Sprint 5: Testing (M07 entry)

- [ ] **M06-TEST-01: SIT Core Business Calculations**
  - **Files**: `tests/sit/*`
  - **Action**: Unit-test critical business formulas (e.g., cost averaging, receivable deductions, tax reserves as applicable to the domain).
  - **Verify**: `npx vitest run` (or stack equivalent: `artisan test`, `pytest`, `go test ./...`).
  - **Expected**: 100% assertions pass, exit 0.

*(Repeat for E2E user-journey automation — Playwright or stack equivalent.)*

## Sprint 6: Hard Release Gate

- [ ] **M06-GATE-01: Production Build & Type Integrity**
  - **Action**: Run production build + typecheck (stack equivalent: `pnpm build && tsc --noEmit` / `artisan build` / `pytest` / `go build`). No `@ts-ignore`, no `as any`.
  - **Verify**: Terminal build output.
  - **Expected**: Exit 0, zero type/lint errors.

- [ ] **M06-GATE-02: Human-Only Commit & Handoff**
  - **Action**: AI agents/harness MUST NOT run `git commit` or `git push`. Hand changes to the human developer with `RUNBOOK_LOCAL.md` instructions.
  - **Verify**: `git status` clean, ready for human review.
  - **Expected**: Verification report delivered; no agent commits.

- [ ] **M06-GATE-03: AI Pre-Merge Review Log**
  - **Files**: `AI_REVIEW_LOG.md` (from `templates/04-dev-execution/AI_CODE_REVIEW_CHECKLIST_TEMPLATE.md`)
  - **Action**: Run the 5-point inline pre-merge review for EVERY changed file and record it: (1) file traces to a TODO task; (2) no invented imports/APIs — each verified to exist; (3) no secrets, no `@ts-ignore`/`as any`/empty catch; (4) new logic has a test; (5) one logical change per commit. Log each finding with a severity prefix (`[BLOCKER]` / `[BUG]` / `[SECURITY]` / `[PERF]` / `[SUGGESTION]`).
  - **Out of Scope**: No merge — the human merges to `staging` and tags Alpha.
  - **Verify**: `test -s AI_REVIEW_LOG.md` (non-empty) and zero unresolved `[BLOCKER]`/`[SECURITY]` entries.
  - **Expected**: `AI_REVIEW_LOG.md` exists with one reviewed entry per changed file; zero open blockers.

- [ ] **M06-GATE-04: Progress Tracker Hand-Off**
  - **Files**: `DEVELOPMENT_PROGRESS_TRACKER.md` (from `templates/04-dev-execution/DEVELOPMENT_PROGRESS_TRACKER.md`)
  - **Action**: Copy the tracker into the project, fill the locked-stack metadata (stack, DB engine, ORM, storage, gateway, monitoring) and the component/integration status rows so the human has a single progress view for M07.
  - **Out of Scope**: No new features; tracking only.
  - **Verify**: Tracker metadata matches `AGENTS.md`/FSD lock; no `[Project Name]` placeholders left.
  - **Expected**: Tracker reflects the completed sprint set; placeholders resolved.
