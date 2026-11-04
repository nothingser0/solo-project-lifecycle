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
- **Enterprise WBS Phasing (A01)**: When project originates from enterprise WBS decomposition, `TODO.md` MUST scope only the currently active Phase (e.g. Phase 1 MVP). Multi-phase backlog dumping into a single TODO is strictly forbidden.

## Database & Transaction Execution Guardrails
- **Idempotent Seeding**: All database seed scripts (`seed.ts` / seeder classes) must use deterministic static UUIDs and UPSERT / `ON CONFLICT DO NOTHING` statements. Seeding must be re-runnable 10x without violating unique constraints or creating duplicate rows.
- **Deadlock Prevention Order**: Any transaction acquiring row-level locks on multiple rows or tables must sort entities by primary key (`ORDER BY id ASC`) before locking to mathematically eliminate database deadlocks (`40P01`).

## Defect Triage Standard (Bug vs Change Request)
- **Bug (Zero-Cost Correction)**: Behavior deviates from locked `PRD.md` / `FSD.md` / Acceptance Criteria $\rightarrow$ log as immediate bugfix in current sprint.
- **Change Request (CR - Scope Extension)**: Request introduces new inputs, alters agreed flows, or extends domain scope $\rightarrow$ do NOT implement in TODO; divert to `change-requests/CR-*.md`.

## Task architecture (9 mandatory elements)

Every generated task must include all nine fields below; do not omit source traceability when writing the task blocks.

1. **Task ID** — `M06-DB-01`, `M06-BE-01`, `M06-FE-01` (used in commits/test logs)
2. **Title & single objective** — 1 table, 1 endpoint, or 1 screen only
3. **Files** — exact target paths (stops ad-hoc path invention)
4. **Depends** — preceding task IDs required first
5. **Action** — precise implementation instructions & constraints
6. **Out of Scope** — what NOT to touch in this task
7. **Verify & Expected** — executable command + deterministic success criteria
8. **Source trace** — requirement / acceptance-criteria / screen / schema IDs this task implements; use `N/A` with a reason for setup-only tasks
9. **Status** — `- [ ]` pending | `- [~]` in progress | `- [!]` blocked (with reason) | `- [x]` completed (exit 0 + evidence)

## Task ID prefixes
The framework defines the following standard task categories across all project scales (Small, Medium, Large, Enterprise). Sub-categories are strictly expressed via sprint section headers and task titles.
| Prefix | Source | Output |
| :--- | :--- | :--- |
| `M06-SETUP-xx` | Environment, DB config, design assets | `.env.local`, DB connection, brand assets |
| `M06-AUTH-xx` | `FSD.md` (§Auth/RBAC) & `SITEMAP.md` | Auth flows, session guards, login/logout, middleware |
| `M06-DB-xx` | `FSD.md` (§schema/RLS/RPC) or `PROJECT_LITE.md` §5 | `migrations/*.sql` (tables, RLS, RPCs, seed) |
| `M06-BE-xx` | `FSD.md` §API & `PRD.md` | `src/actions/*`, `src/app/api/*`, business engines |
| `M06-UI-xx` | `COMPONENT_REQUIREMENTS.md` & `DESIGN_SPEC.md` | Reusable primitives (`Button`, `Input`) & composites (`Card`, `Modal`) |
| `M06-FE-xx` | `SITEMAP.md` & `DESIGN_SPEC.md` | `src/app/*` (1-to-1 screen mapping for each `SCR-xx`) |
| `M06-INT-xx` | `FSD.md` §integration | Live wire-up, webhooks, hardware, payment gateways |
| `M06-TEST-xx` | `PRD.md` acceptance criteria | `tests/db`, `tests/sit`, `tests/e2e` |
| `M06-GATE-xx` | Release protocols | Verified build, git handoff log |

> **Anti-Bundling & Full-Fidelity Mandate**:
> 1. **1-to-1 Screen Parity**: Every screen `SCR-xx` in `SITEMAP.md` MUST have its own individual `M06-FE-xx` task. Compressing multiple screens into generic placeholders (e.g. "Core Screens") is strictly forbidden.
> 2. **Dedicated Auth & RBAC**: Whenever authentication, login portals, or user roles exist, explicit `M06-AUTH-xx` tasks are mandatory.
> 3. **Component Primitives**: Reusable primitives and composite patterns from `COMPONENT_REQUIREMENTS.md` must be itemized before assembling screen views.
> 4. **Approval Protocol**: When the human replies with "approve", "approved", "acc", or "ok lanjut", the agent marks `[x]`, records raw output under `Evidence:`, and adds `Approved: <date> by <name>`.

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

## Sprint 1: Authentication & Authorization / RBAC (skip if no auth — mark N/A)

- [ ] **M06-AUTH-01: Authentication Flow & Session Management**
  - **Files**: `src/lib/auth/*`, `src/middleware.ts` (or stack equivalent)
  - **Depends**: `M06-SETUP-01`
  - **Action**: Implement login/logout authentication handlers, session cookie validation, and token refresh per FSD.
  - **Verify**: Authenticated session returns valid user identity; invalid/expired credentials reject with 401.
  - **Expected**: Secure session handling with HttpOnly cookies.

- [ ] **M06-AUTH-02: Role-Based Access Control (RBAC) & Route Protection**
  - **Files**: `src/middleware.ts`, route guards
  - **Depends**: `M06-AUTH-01`
  - **Action**: Implement route protection matrix per SITEMAP §4 (e.g. Owner vs Staff vs Public/Tenant).
  - **Verify**: Unauthenticated access to protected routes redirects to `/login`; unauthorized roles receive 403 Forbidden.
  - **Expected**: 100% adherence to role protection matrix.

---

## Sprint 2: Database Foundation (skip if no DB — mark N/A)

- [ ] **M06-DB-01: Relational Schema & FK Indexing**
  - **Files**: `supabase/migrations/001_initial_schema.sql` (or Prisma/Drizzle/Laravel/Django/Go migrations)
  - **Depends**: `M06-SETUP-01`
  - **Action**: Define all FSD tables. Money as `BIGINT`/`NUMERIC(15,2)` (never float), fractional qty `NUMERIC(12,3)`. Explicit `CREATE INDEX` on every FK column + arithmetic CHECK constraints.
  - **Out of Scope**: No server actions, API routes, or UI.
  - **Verify**: Run migration locally (stack equivalent: `pnpm db:migrate` / `supabase db push` / `php artisan migrate` / `python manage.py migrate` / `goose up`).
  - **Expected**: Exit 0; all tables, indexes, constraints created.
  - **Evidence**: `<command output>`
    `Approved: [YYYY-MM-DD] by [Your Name]`

- [ ] **M06-DB-02: Idempotent Database Seeding**
  - **Files**: `prisma/seed.ts` (or stack seeder class)
  - **Depends**: `M06-DB-01`
  - **Action**: Implement idempotent seed data using static UUIDs and UPSERT / `ON CONFLICT DO NOTHING`.
  - **Verify**: Run seed script twice; confirm zero unique constraint errors and identical row counts.
  - **Expected**: 100% re-runnable without duplicates.

---

## Sprint 3: Backend Logic & Business Calculation Engines

- [ ] **M06-BE-01: API Boundary Validation & Server Actions**
  - **Files**: `src/actions/*`, `src/app/api/v1/*`
  - **Action**: Map all data mutations to server actions/route handlers. Validate every payload with strict Zod schemas (`uuid`, `min`, `positive`, integer amounts).
  - **Verify**: Send dirty/empty payload to a server action.
  - **Expected**: Rejected with `VALIDATION_ERROR` + structured field errors.

- [ ] **M06-BE-02: Core Business Calculation Engine**
  - **Files**: `src/lib/engine/*`
  - **Action**: Implement mathematical business formulas per FSD (e.g. billing calculation, interest, discounts).
  - **Verify**: Run unit test assertions covering edge cases (zero delta, overflow, negative values).
  - **Expected**: Deterministic integer IDR / decimal calculations matching spec.

---

## Sprint 4: UI Design System & Component Primitives

- [ ] **M06-UI-01: Design Tokens, Typography & Base Primitives**
  - **Files**: `globals.css`, `tailwind.config.ts`, `src/components/ui/*`
  - **Action**: Register CSS variables per `DESIGN.md` (colors, surface, typography, z-index). Implement atomic primitives (`Button`, `Input`, `Badge`, `Select`, `LoadingSpinner`) complying with WCAG 2.2 AA.
  - **Verify**: `pnpm run build` or Storybook/unit test; verify button focus rings and minimum 16px inputs.
  - **Expected**: 100% tokens and atomic primitives ready for composite assembly.

- [ ] **M06-UI-02: Composite Interaction Components**
  - **Files**: `src/components/*`
  - **Action**: Implement high-interaction composites from `COMPONENT_REQUIREMENTS.md` (`DataTable`, `Modal`, `ConfirmDialog`, entity cards, search toolbars).
  - **Verify**: Keyboard accessibility (Escape dismisses dialog, focus trap active).
  - **Expected**: Accessible reusable composites ready for screen views.

---

## Sprint 5: Frontend Views & Screen Coverage (1-to-1 SITEMAP Parity)

*(Generate exactly ONE task for EACH screen defined in `SITEMAP.md` [SCR-01 through SCR-N]. Do NOT bundle.)*

- [ ] **M06-FE-01: Screen View [SCR-01] Landing / Shell**
  - **Files**: `src/app/page.tsx`
  - **Action**: Implement screen with 5-state matrix (idle/loading/empty/error/success) and brand assets.
  - **Verify**: Dev server serves page at `/`; responsive across mobile and desktop.
  - **Expected**: Layout matches frozen prototype and design tokens.

- [ ] **M06-FE-02: Screen View [SCR-02] Authentication Portal**
  - **Files**: `src/app/(auth)/login/page.tsx`
  - **Action**: Implement login form with client validation, pending submit indicator, and error display.
  - **Verify**: Submit form; verify redirect to dashboard on success and inline error on failure.
  - **Expected**: Accessible form with `disabled={isSubmitting}` double-submit protection.

*(Repeat M06-FE-03..N for all remaining SCR screens from SITEMAP.md)*

---

## Sprint 6: System Integration & Webhooks (M06-INT)

- [ ] **M06-INT-01: Payment Gateway & Webhook Handlers**
  - **Files**: `src/app/api/webhooks/*`
  - **Action**: Implement signature verification, replay defense, and idempotency key guards.
  - **Verify**: Send simulated webhook payload; verify cashflow ledger auto-credited and duplicate event rejected.
  - **Expected**: 100% idempotent webhook processing.
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
