# Module 06: Development Execution (Coding & 3 Pillars)

Coding via **AI Coding Agents** with an **Agent Harness** + Git branching; 3 pillars: **Security, Performance, Resource Efficiency**.
**Inputs**: `docs/specs/FSD.md` (LOCKED stack) + `PRD.md` + frozen prototype; Small: `PROJECT_LITE.md`.
> **Templates to copy**: `templates/04-dev-execution/{TODO,RUNBOOK_LOCAL,VERIFY_LOCAL}_TEMPLATE.md` · pre-merge: `checklists/{FRONTEND,BACKEND,INTEGRATION}_CHECKLIST.md`
📖 **Optional** (do NOT preload): `references/technical/EVIDENCE_MANIFEST_GUIDE.md` (making a completion claim checkable) · `references/solo/{SOLO_DEVELOPMENT_PATTERNS,SOLO_ENGINEERING_STANDARDS}.md` · `references/playbooks/AI_ASSISTED_DEVELOPMENT.md` · stack quickstarts · `references/stacks/STACK_SUPPORT_MATRIX.md` · conditional: `patterns/localization/I18N_INDONESIA.md`, `patterns/payments/INDONESIA_PAYMENT_GATEWAYS.md`, `patterns/ui/SCROLL_SCRUBBED_WORLD_PATTERN.md` (only if the frozen design contains a scroll-scrubbed hero — its engine is `templates/ui/scroll-scrub-engine.js`).

> **Pre-merge AI review (log in `AI_REVIEW_LOG.md`)**: review the actual diff against its TODO task and locked acceptance criteria; trace changed files and behaviour to requirement IDs; verify new dependencies and APIs against the chosen stack's current official docs; inspect security-sensitive changes (auth, input, data access, secrets, external calls); run only the repository's lint/typecheck/test/build and record exact output. Classify each finding (blocker / fix now / accepted risk / out of scope), fix blockers and in-scope defects, route scope changes through a CR, and record accepted risks with owner and date. This is a distinct pass from the task's `Verify`.
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

**STEP 3 — Version gate (MANDATORY).** Run `./scripts/verify/verify-framework-version.sh` (or `.ps1`). It checks the scaffold manifest matches the FSD, then compares lockfile against `Framework Versions (Pinned)`: **major.minor exact**. Comparators exist for Next.js, Laravel, Django, FastAPI, Go, SvelteKit, Nuxt, Rails and Expo (Expo needs npm `package-lock.json`, then `npx expo install --check` and `npx expo-doctor@latest`); Tailwind v3/v4 is reported where applicable. Mismatch or a missing comparator fails — never claim STEP 3 passed while the verifier says the pin is UNVERIFIED. Stacks listed only as tracked in `references/stacks/STACK_SUPPORT_MATRIX.md` are not gate-ready. **Anti-overkill baseline** (same matrix): Small = no Docker, no microservices · Medium = monolith, no Kafka or K8s · Large = modular monolith + DB + Redis. Drift from that baseline gets pruned.

**STEP 4 — Pre-install dependency checks (BEFORE installing).**
`npm info <pkg> peerDependencies` → `npm view <pkg> deprecated` → `npm view <pkg> version` → pin `pnpm add <pkg>@<compatible-version>`. Known pairs, deprecated replacements, font rule, matrices: deep dive. Deprecated: do NOT install. Spec-locked CVEs: document/escalate.

**STEP 5 — Generate TODO.md** via `templates/04-dev-execution/TODO_TEMPLATE.md`, reading PRD/FSD/SITEMAP/COMPONENT_REQUIREMENTS/DESIGN_SPEC (or `PROJECT_LITE.md`). **100% multi-document decomposition — bundling is forbidden**:
- **1-to-1 SITEMAP parity**: every screen in `SITEMAP.md` gets its own `M06-FE-xx` task. "Core Screens"-style placeholder bundles are forbidden.
- **Auth & RBAC tasks**: when FSD/SITEMAP specify authentication, sessions or role guards, TODO carries explicit `M06-AUTH-xx` (or `SETUP`/`BE`) tasks for auth config, login/logout screens and route middleware.
- **UI system first**: with `COMPONENT_REQUIREMENTS.md` present, primitives and composites (Button, Input, Badge, Card, DataTable, Modal, ConfirmDialog) land in a dedicated sprint before screen assembly.
- **DB & logic mapping**: 1 task per table/model migration + seeder idempotency (`M06-DB-xx`), 1 per major server action or business engine (`M06-BE-xx`).
- **Enterprise WBS boundary**: for projects from `A01_WORK_BREAKDOWN_PHASING.md`, scope TODO to the **active contracted phase** only (e.g. Phase 1, 8–15 P0); a multi-phase monolithic backlog is forbidden.
- Exactly 7 closed categories at every scale: `M06-{SETUP|DB|BE|FE|INT|TEST|GATE}-xx` (sub-categories live in sprint headings, never as new prefixes); `M06-SETUP-03` specs pre-read is gate-checked. Each task carries **Verify** {stack cmd}, **Expected** {criteria}, **Evidence** {output}.
- **Approval protocol**: when the human says "approve", "approved", "acc" or "ok lanjut", the agent marks `- [x]`, appends `Evidence: <raw output>` and writes `Approved: YYYY-MM-DD by <name>`.
- 🛑 **END TURN after writing TODO.md** — present the task count and coverage mapping, then wait before implementing the first task.

**STEP 6 — Implement per TODO (DB → API → prototype).** **One task per turn**: implement → run `Verify` → S.U.P.E.R 10-check review card (`patterns/architecture/SUPER_ARCHITECTURE_AND_ADAPTIVE_CONTROL_PATTERN.md`) + edit-over-create hygiene (`patterns/architecture/AI_AGENT_SYSTEM_PROMPT_ENGINEERING_PATTERN.md`) → report Evidence → 🛑 **END TURN**. The human approves before `[x]` and the next task; `Approved: <date> by <name>` is gate-enforced (self-ticked tasks fail). Batch only when the user names task IDs.
- **Change fence**: edit only the files this TODO task names; anything else needs a question first, and existing content is preserved unless removal is the request (see Core rule 6b). Report changed paths with a one-line reason each.
- **Evidence must resolve**: when a task produces a visible surface or file artifact, run `python3 scripts/verify/check_evidence.py . --report artifacts/final-evidence.md` before claiming completion. A missing path, a 0-byte stub, or a relabelled earlier report is a fabricated claim. State what you did **not** verify.
- **Prototype is the spec**: every `M06-FE-xx` ports layout, hierarchy, styling and micro-interactions from `docs/design/screens/<role>/<screen>.html`. Divergent cards, filters or layouts invented from memory are forbidden, and no `SCR-`/`REQ-`/`M06-`/`FSD-` code goes into user-facing copy.
- **Route defense**: an `M06-FE-xx` `Verify` probes that specific route (`curl -fsSL -o /dev/null -w "%{http_code}"` expecting 200/307, or the production build manifest). Citing unrelated unit tests as UI evidence is a fabricated claim; a 404 or crash on a declared route blocks approval.
- **DB & seed idempotency**: ORM migrations pooling + FK indexes + reversible; every seeder is 100% idempotent (deterministic UUIDs / UPSERT / `ON CONFLICT DO NOTHING`) so ten runs never duplicate rows.
- **API**: per FSD, schema validation, and the 3 pillars — security (encryption, HttpOnly cookies, parameterized queries), performance (no N+1, caching, indexes, `limit <= 100`), resources (pooling, streaming, memory).
- **Mutations & concurrency**: mutating forms bind a submitting state (`disabled={isSubmitting}`); read-modify-write on stock/balance/counter/status is atomic (tx + row lock, unique constraint, or CAS); webhooks are idempotent; multi-row transactions acquire locks in a deterministic `ORDER BY id` so PostgreSQL `40P01` deadlocks are impossible; server and workers trap `SIGTERM`/`SIGINT`, stop accepting, drain in-flight work and close pools within 10s.
- **UI completeness**: all 5 states per screen (idle/loading/success/error/empty); design-calibrated Toasts and Dialog Modals instead of `alert`/`confirm`/`prompt`; nested + root Error Boundaries with a reset action instead of a white screen, and structured logging for unhandled backend rejections.
- **Hydration discipline (SSR stacks)**: build it hydration-free when the view is correct without it. No `Date.now()`/`new Date()`/`Math.random()`/`localStorage`/bare `toLocaleString()` in the initial render; every formatter takes an explicit `locale` + `timeZone`; `'use client'` only on the smallest interactive leaf, each listed in `VERIFY_LOCAL.md` §4C (console proof there too; ladder: `references/technical/HYDRATION_FREE_RENDERING.md`).
- **Consumer mapping**: user-facing → UI exists; webhook → provider config; cron → caller in `RUNBOOK_LOCAL.md`; jobs → worker verified.
- **DB defense** (the backend twin of route defense): a `M06-DB-*` `Verify` must prove the schema against a **real database instance**, never a mock. Three probes, pasted raw into `Evidence`: (1) `migrate up` → `migrate down` → `migrate up` succeeds (reversible); (2) running the seeder **twice** leaves no duplicate rows — report the before/after `COUNT(*)`; (3) one key query's `EXPLAIN` shows the intended index used. A passing unit/integration test that stubs the DB is **not** setup evidence — it is the same fabricated claim as citing unit tests for a route. If no reachable database exists, state that the DB was not verified instead of claiming it. Test-runner output (vitest, jest, pytest) is only evidence for the level it actually exercises: a mocked repo layer proves wiring, not schema.
- **Bug vs CR**: behaviour violating locked PRD/FSD/acceptance is a bug, fixed now at zero cost. Anything else is a CR in `change-requests/CR-*.md` with fee and timeline, never implemented mid-sprint.

**STEP 7 — Tests, CI Pipeline & Git.** Run the stack's configured smoke/unit tests, static checks, build and dependency/security checks where supported — use the commands locked in the project harness, never assume TypeScript, pnpm or a particular scanner.
- Terraform: `terraform fmt -check -recursive`, `terraform init -backend=false`, `terraform validate`. Review `.tftest.hcl` before running it — apply-mode tests can provision billable infrastructure.
- CI: adapt `templates/04-dev-execution/PROJECT_CI_TEMPLATE.yml` to the chosen stack before wiring it.
- Expo: project scripts + `npx expo install --check` + `npx expo-doctor@latest`; device/native smoke needs the approved development build. EAS cloud builds only when the project selects that workflow AND a profile plus credentials are configured.
- Record AI pre-merge findings and dispositions in `AI_REVIEW_LOG.md`. This pass inspects the diff; broader system QA/SIT belongs to M07.
- **The human merges to `staging` and tags Alpha. The agent never commits, merges or tags.**

**STEP 8 — RUNBOOK_LOCAL.md + VERIFY_LOCAL.md** from `templates/04-dev-execution/{RUNBOOK_LOCAL,VERIFY_LOCAL}_TEMPLATE.md` (placeholders → FSD endpoints + stack commands). Smoke test 100%.

> **Placement**: every artefact below has exactly one home — see `docs/WHERE_THINGS_GO.md`. Do not create a second copy in another folder.

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
