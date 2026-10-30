# Module 06: Development Execution (Coding & 3 Pillars)

Coding via **AI Coding Agents** with an **Agent Harness** + Git branching; 3 pillars: **Security, Performance, Resource Efficiency**.
**Inputs**: `docs/specs/FSD.md` (LOCKED stack) + `PRD.md` + frozen prototype; Small: `PROJECT_LITE.md`.
> **Templates to copy**: `templates/04-dev-execution/{TODO,RUNBOOK_LOCAL,VERIFY_LOCAL}_TEMPLATE.md` · pre-merge: `checklists/{FRONTEND,BACKEND,INTEGRATION}_CHECKLIST.md`
📖 **Optional** (do NOT preload): `references/technical/EVIDENCE_MANIFEST_GUIDE.md` (making a completion claim checkable) · `references/solo/{SOLO_DEVELOPMENT_PATTERNS,SOLO_ENGINEERING_STANDARDS}.md` · `references/playbooks/AI_ASSISTED_DEVELOPMENT.md` · stack quickstarts · `references/stacks/STACK_SUPPORT_MATRIX.md` · conditional: `patterns/localization/I18N_INDONESIA.md`, `patterns/payments/INDONESIA_PAYMENT_GATEWAYS.md`, `patterns/ui/SCROLL_SCRUBBED_WORLD_PATTERN.md` (only if the frozen design contains a scroll-scrubbed hero — its engine is `templates/ui/scroll-scrub-engine.js`).

> **Pre-merge AI review (log in `AI_REVIEW_LOG.md`)**: review the actual diff against its TODO task and locked acceptance criteria; trace changed files and behavior to source requirement IDs; verify new dependencies/APIs against the selected stack's current official docs; inspect security-sensitive paths changed (auth, input, data access, secrets, external calls); run only the repository's applicable lint/typecheck/test/build commands and record exact output. Classify each finding (blocker / fix now / accepted risk / out of scope); fix blockers and in-scope defects, route scope changes through CR, and record accepted risks with owner/date. Review is a distinct pass from executing the task's `Verify` command.
Deep dive [`deep-dives/06_DEVELOPMENT_EXECUTION.md`](deep-dives/06_DEVELOPMENT_EXECUTION.md) — open by section when a step needs depth (code style, dependencies, harness staging, gate scripts).

## 1. Execution Steps
**STEP 0 — Locked stack decision (MANDATORY FIRST; gate-enforced).** Parse FSD `Stack Decision LOCKED:` + `Module 04 Handoff Strategy` → compatibility level (1-4). Small: verify `PROJECT_LITE.md`. Must match M05 approval. **Never assume Next.js.** (Medium+ gate fails without both markers.)

**STEP 1 — Scaffold (command strictly from FSD.md; pin FSD versions).**

| Stack | Scaffold Command | Version Pin | ORM/Migration |
|---|---|---|---|
| Next.js | `pnpm create next-app@latest --typescript --tailwind --app` | `pnpm add next@{FSD.Next} react@{FSD.React} react-dom@{FSD.React}` | Prisma/Drizzle |
| Laravel | `composer create-project laravel/laravel --prefer-dist` | `composer require laravel/framework:{FSD.Laravel}` | Eloquent |
| Django | `django-admin startproject <proj> && python manage.py startapp core` | `pip install django=={FSD.Django}` | Django ORM |
| Go | `mkdir <proj> && go mod init github.com/user/<proj>` | go.mod: `go {FSD.Go}` | GORM/sqlx/migrate |
| Expo / React Native | `npx create-expo-app@latest <proj> --template <template compatible with FSD-locked SDK>`; pin Expo with npm | `npm install expo@{FSD.Expo}`; commit `package-lock.json` | Expo Router / SQLite or selected FSD data layer |

For Expo, use npm and commit `package-lock.json` for the M06 version gate. Align the generated app with the SDK compatible with the locked `expo` package; do not copy a moving SDK number into the FSD.

Git: `main` → `staging` → `feat/*`.
**STEP 2 — Deploy harness files to root AFTER scaffold (gate-enforced).** Source `docs/harness-root/` (staged M01-M05 for all scales, including Small); overwrites boilerplate. Unstaged fallback: `templates/04-dev-execution/{AGENTS,ARCHITECTURE,CONVENTIONS,ENV_EXAMPLE}_TEMPLATE.md` + `{stack}/` + `templates/02-design/DESIGN_MD_TEMPLATE.md`, renaming `ENV_EXAMPLE`→`.env.example`.
⛔ **STRICT ORDER (never reorder):** (1) scaffold finished; (2) `cp docs/harness-root/* ./ && cp docs/harness-root/.env.example ./ 2>/dev/null || true`; (3) verify root harness files (Medium+: 9 files; Small: `AGENTS.md`, `TODO.md`, `DESIGN.md`); (4) ONLY then `rm -rf docs/harness-root/`. Optional: `./scripts/scaffold/template-picker.sh --phase 4 --dest .`.

**STEP 3 — Version gate (MANDATORY).** Run `./scripts/verify/verify-framework-version.sh` (or `.ps1`). It checks the scaffold manifest type matches FSD, then lockfile vs FSD `Framework Versions (Pinned)`: **major.minor exact**. Current lockfile comparators: Next.js, Laravel, Django, FastAPI, Go, SvelteKit, Nuxt, Rails, and Expo (Expo requires npm `package-lock.json` and runs `npx expo install --check` plus `npx expo-doctor@latest`). Tailwind v3/v4 is reported where applicable. Mismatch or missing comparator → FAIL. Other stacks in `STACK_SUPPORT_MATRIX.md` are tracked/recommended but are not M06 gate-ready until both scaffold/harness guidance and bash + PowerShell lockfile comparators exist. Never claim STEP 3 passed when the verifier says the pin is UNVERIFIED. Anti-overkill (`references/stacks/STACK_SUPPORT_MATRIX.md`): Small = no Docker/microservices; Medium = monolith (no Kafka/K8s); Large = modular monolith + DB + Redis. Drift → prune.

**STEP 4 — Pre-install dependency checks (BEFORE installing).**
`npm info <pkg> peerDependencies` → `npm view <pkg> deprecated` → `npm view <pkg> version` → pin `pnpm add <pkg>@<compatible-version>`. Known pairs, deprecated replacements, font rule, matrices: deep dive. Deprecated: do NOT install. Spec-locked CVEs: document/escalate.

**STEP 5 — Generate TODO.md** via `templates/04-dev-execution/TODO_TEMPLATE.md`. Read PRD/FSD/SITEMAP/COMPONENT_REQUIREMENTS/DESIGN_SPEC (or PROJECT_LITE.md). **100% Multi-Document Specification Decomposition (Anti-Bundling Standard)**:
- **1-to-1 Screen Parity with SITEMAP (SCR-01..SCR-N)**: Every screen listed in `SITEMAP.md` MUST have an individual `M06-FE-xx` task. Compressing or bundling multiple screens into generic placeholders (e.g. "Core Screens") is strictly forbidden.
- **Dedicated Auth & RBAC Tasks**: If authentication, sessions, or role guards are specified in FSD/SITEMAP, TODO MUST include explicit `M06-AUTH-xx` tasks (or `M06-SETUP-xx` / `M06-BE-xx`) for auth configuration, login/logout screens, and route middleware guards.
- **UI Design System & Primitives (COMPONENT_REQUIREMENTS)**: When `COMPONENT_REQUIREMENTS.md` is present, reusable UI primitives (Button, Input, Badge, etc.) and composite patterns (Card, DataTable, Modal, ConfirmDialog) MUST be established in a dedicated sprint or prerequisite tasks before screen assembly.
- **Database & Business Logic 1-to-1 Mapping**: 1 task per DB table/model migration + seeder idempotency (`M06-DB-xx`), and 1 task per major server action/business engine (`M06-BE-xx`).
- **Enterprise WBS Phasing Scope Boundary**: For projects originating from Enterprise WBS Decomposition (`A01_WORK_BREAKDOWN_PHASING.md`), `TODO.md` MUST strictly scope tasks only for the **active contracted Phase** (e.g. Phase 1 MVP, 8–15 P0 features). Generating multi-phase monolithic TODO backlogs is strictly prohibited.
- Exactly 7 closed categories across all scales: `M06-{SETUP|DB|BE|FE|INT|TEST|GATE}-xx` (sub-categories are expressed strictly via sprint headings/titles, no ad-hoc prefixes); mandatory `M06-SETUP-03` specs pre-read (gate-checked). Each task: **Verify** {stack cmd}, **Expected** {criteria}, **Evidence** {output}.
- **Approval Protocol**: When the human replies with "approve", "approved", "acc", or "ok lanjut", the agent immediately marks `- [x]`, appends `Evidence: <raw output>`, and writes `Approved: YYYY-MM-DD by <name>`.
- 🛑 **END TURN after writing TODO.md** — present task count and coverage mapping; wait for user confirmation BEFORE implementing the first task.

**STEP 6 — Implement per TODO (DB → API → prototype).** **One task per turn**: implement → run `Verify` → audit 10-Check S.U.P.E.R review card & telemetry drift check (`patterns/architecture/SUPER_ARCHITECTURE_AND_ADAPTIVE_CONTROL_PATTERN.md`) → enforce agent execution guardrails (zero scratchpad comments, edit-over-create file hygiene per `patterns/architecture/AI_AGENT_SYSTEM_PROMPT_ENGINEERING_PATTERN.md`) → report Evidence → 🛑 **END TURN**. Human approves before `[x]` and the next task; `Approved: <date> by <name>` is **gate-enforced** (self-ticked tasks fail). Batch only when the user names task IDs.
- **Evidence must resolve, not just be cited**: when a task produces a visible surface or a file artifact, run `python3 scripts/verify/check_evidence.py . --report artifacts/final-evidence.md` before claiming completion. A missing path, a 0-byte stub, or a relabelled report from an earlier run is a fabricated claim — the gate checks the `Approved:` line, not whether the file exists. State what you looked at and what you did **not** verify.
- **Zero UI Invention from Scratch (1-to-1 Prototype Conversion)**: For every frontend screen task (`M06-FE-xx`), the agent MUST port the layout, component hierarchy, Tailwind styling, and micro-interactions directly from `docs/design/screens/<screen>.html`. Inventing divergent card styles (e.g. replacing dark/colored hero cards with plain white boxes), inconsistent filters, or unapproved layouts from memory is STRICTLY FORBIDDEN.
- **Zero Spec Identifier Leaks in Customer UI**: Internal spec codes (`SCR-xx`, `REQ-xx`, `M06-FE-xx`, `FSD-xx`) MUST NEVER be rendered into user-facing headings, badges, labels, or subtitles. Strip all specification metadata during frontend component assembly.
- **Anti-False-Verification Mandate (The 404 Route Defense)**:
  - For every frontend route/screen task (`M06-FE-xx`), the `Verify` command MUST directly test that specific route via automated HTTP probe (e.g. `curl -fsSL -o /dev/null -w "%{http_code}" http://localhost:3000/<route>` or PowerShell `Invoke-WebRequest` asserting HTTP 200/307) or production build manifest check (`npm run build`).
  - An agent is **STRICTLY PROHIBITED** from running unrelated unit tests (e.g. `npm test` on backend calculations) and presenting exit code 0 as evidence for a frontend UI task.
  - A route returning **HTTP 404** or an unhandled client/server crash when visited is an immediate critical defect that blocks approval.
- **DB & Seed Idempotency**: stack ORM migrations; pooling; FK-column indexes; reversible; **all seeder scripts MUST be 100% idempotent** (using deterministic static UUIDs / UPSERT / `ON CONFLICT DO NOTHING`) so executing the seeder 10x never produces duplicate records or violates unique constraints.
- **API**: endpoints per FSD, Zod/schema validation + 3 pillars — Security: encryption, HttpOnly cookies, parameterized queries; Performance: N+1 prevention, caching, indexing, bounded pagination (`limit <= 100`); Resources: connection pooling (PgBouncer/Supavisor), streaming, memory.
- **Frontend Mutation Guardrails**: all mutating forms MUST bind to loading/submitting states (`disabled={isSubmitting}`) with visual indicators to prevent client-side double submits and duplicate records.
- **Concurrency, Deadlock Prevention & Hygiene**:
  - Read-modify-write on stock/balance/counter/status MUST be atomic (tx + row lock, unique constraint, or CAS); webhooks idempotent.
  - **Deadlock Prevention Protocol**: Any transaction acquiring row-level locks on multiple records across tables or rows MUST acquire locks in a globally deterministic order (strictly `ORDER BY id ASC` or deterministic primary key sort) to mathematically prevent database deadlocks (PostgreSQL error `40P01`).
  - **Graceful Shutdown Protocol**: Server entrypoints and background workers MUST intercept `SIGTERM` and `SIGINT` signals to reject new incoming traffic, drain in-flight jobs/requests, and cleanly close database pools within a 10s grace timeout (prevents corrupted transactions during deploys).
  - No comments that restate code, no stubs, no commented-out code. Details: deep dive.
- **Prototype**: per FSD `Module 04 Handoff Strategy` (Levels 1-4); **UI 100% identical to frozen prototype**; static screens first (Sprint 3), data-backed after DB+API.
- **5 UI states** per screen (idle/loading/success/error/empty).
- **Zero Raw Browser Alerts Mandate**: Using `window.alert()`, `confirm()`, or `prompt()` is strictly forbidden as amateur AI slop. All notifications and user confirmations MUST use custom design-calibrated Toasts (e.g. Sonner/hot-toast) and styled Dialog Modals (with `backdrop-blur-sm`, `rounded-2xl`, and micro-interaction animations).
- **Error Boundaries & Unhandled Exception Defense**: Frontend MUST implement nested and root Error Boundaries (`error.tsx` in Next.js / boundary component) with reset action to eliminate White Screen of Death; Backend MUST catch unhandled rejections with structured logging.
- **Hydration-free UI (SSR stacks)**: if a view is correct without hydration, it must be built that way. No `Date.now()`/`new Date()`/`Math.random()`/`localStorage`/bare `toLocaleString()` during the initial render; every date/number formatter passes an explicit `locale` + `timeZone`; `'use client'` only on the smallest leaf that needs interaction, each one recorded in `VERIFY_LOCAL.md` §4C. Ladder: `references/technical/HYDRATION_FREE_RENDERING.md`; console proof required per `VERIFY_LOCAL.md` §4C.
- **Consumer mapping**: user-facing → UI exists; webhook → provider config; cron → caller in RUNBOOK_LOCAL.md; jobs → worker verified.
- **Defect Triage Protocol (Bug vs CR Boundary)**:
  - **Bug**: Functionality violates locked `PRD.md` / `FSD.md` / Acceptance Criteria $\rightarrow$ fixed immediately at zero cost.
  - **Change Request (CR)**: Any modification of behavior or additional capability outside locked specs $\rightarrow$ diverted to `change-requests/CR-*.md` with fee & timeline impact; never implemented during sprint.

**STEP 7 — Tests, CI Pipeline & Git.** Run the stack's configured smoke/unit tests, static checks, build, and dependency/security checks where supported; use the commands locked in the project harness (do not assume TypeScript, pnpm, or a particular scanner). For Terraform projects, run `terraform fmt -check -recursive`, `terraform init -backend=false`, and `terraform validate`; review `.tftest.hcl` commands before running tests, since apply-mode tests may provision billable infrastructure. Configure CI via `templates/04-dev-execution/PROJECT_CI_TEMPLATE.yml` only after adapting it to the selected stack. For Expo, run the project scripts plus `npx expo install --check` and `npx expo-doctor@latest`; device/native smoke testing requires the approved development build or device. EAS cloud builds are optional and require a configured profile and credentials; enable them only when the project explicitly selects that workflow. Record AI pre-merge review findings and dispositions in `AI_REVIEW_LOG.md`; this review inspects the diff, while M07 owns broader system QA/SIT. **Human merges to `staging` and tags Alpha** — agent must not commit/merge/tag.

**STEP 8 — RUNBOOK_LOCAL.md + VERIFY_LOCAL.md** from `templates/04-dev-execution/{RUNBOOK_LOCAL,VERIFY_LOCAL}_TEMPLATE.md` (placeholders → FSD endpoints + stack commands). Smoke test 100%.

## 2. Output Artifacts
Source code (on `staging`) · **`RUNBOOK_LOCAL.md`** · **`VERIFY_LOCAL.md`** · **`AI_REVIEW_LOG.md`** · **`DEVELOPMENT_PROGRESS_TRACKER.md`** (`templates/04-dev-execution/`).

## 3. Gate Exit Criteria [GATE]
- [ ] STEP 0+2: FSD has `Stack Decision LOCKED:` + `Module 04 Handoff Strategy`; all 9 harness files in root (Small: `AGENTS.md`+`TODO.md`).
- [ ] Version match: lockfile major.minor exact vs FSD; Tailwind v3/v4 detected.
- [ ] Dependencies resolved; no unmet peers; no deprecated packages.
- [ ] Per-stack verification (Next.js `pnpm build`+`tsc --noEmit`+`pnpm audit` · Laravel `php artisan test` · Django `pytest` · Go `go test ./...`) — exit 0, or documented spec-locked CVE risk.
- [ ] Smoke test 100%.
- [ ] **Hydration discipline**: no render-time `Date.now()`/`new Date()`/`Math.random()`/`localStorage`/bare `toLocale*` in source; every `'use client'` island is listed with its justification in `VERIFY_LOCAL.md` §4C.
- [ ] Migrations reversible; indexes in place; `VERIFY_LOCAL.md` has pass proof.
- [ ] Small: `docs/qa/SECURITY_CHECKLIST_SMALL.md` filled (≥300 bytes; absorbs M07 security).
- [ ] **Small only** (no M07): `docs/qa/POLISH_AUDIT.md` from `templates/06-qa-uat/POLISH_AUDIT_TEMPLATE.md` — 0 blocking tells (favicon, 404, meta, OG, console errors, placeholder text, dead buttons). Medium+ covers in M07 Step 7.
- [ ] **Verbatim**: `./scripts/gates/validate-gate.sh M06` (or `.ps1 M06`) — exit 1 = fix and re-run.

## 4. Gate Exit & Routing
After coding completes and smoke test passes 100%:
1. **Self-verify**: gate checklist above all pass + latest commit on staging (`git log -1`).
2. Summarize local results to the user (compile/smoke results, VERIFY_LOCAL.md proof).
3. Continue per routing once the gate passes: Small → **Module 09-LITE (UAT Sign-off)**, skipping M07 & M08 · Medium/Large → **Module 07 (QA & SIT)**. (M06 is not a SKILL.md stop point; pause only if the user requested changes or the gate failed.)
