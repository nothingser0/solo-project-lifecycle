# Module 06: Development Execution (Coding & 3 Pillars)

Coding via **AI Coding Agents** with an **Agent Harness**, Git branching, 3 pillars: **Security, Performance, Resource Efficiency**.
**Inputs**: `docs/specs/FSD.md` (LOCKED stack) + `PRD.md` + frozen prototype. Small: `PROJECT_LITE.md`.
**Refs**: `references/solo/SOLO_DEVELOPMENT_PATTERNS.md` (+`SOLO_ENGINEERING_STANDARDS.md`), `DEV_EXECUTION_DEEP_DIVE.md`, `references/playbooks/ai-assisted-development.md`, stack quickstarts, `STACK_SUPPORT_MATRIX.md`.
Deep dives: [#code-style](deep-dives/06-development-execution.md#code-style-rules-per-stack-agentsmd) · [#dependencies](deep-dives/06-development-execution.md#dependency-compatibility--pre-install-checks) · [#harness](deep-dives/06-development-execution.md#9-file-harness-staging--template-examples) · [#gate-checks](deep-dives/06-development-execution.md#phase-0-gate-check-and-extended-checklists)

## 1. Execution Steps
**STEP 0 — Locked stack decision (MANDATORY FIRST; gate-check exists).** Parse FSD `Stack Decision LOCKED:` + `Module 04 Handoff Strategy` → compatibility level (1-4). Small: verify `PROJECT_LITE.md`. Must match M05 approval. **Never assume Next.js.**

**STEP 1 — Scaffold (command strictly from FSD.md; pin FSD versions).**

| Stack | Scaffold Command | Version Pin | ORM/Migration |
|---|---|---|---|
| Next.js | `pnpm create next-app@latest --typescript --tailwind --app` | `pnpm add next@{FSD.Next} react@{FSD.React} react-dom@{FSD.React}` | Prisma/Drizzle |
| Laravel | `composer create-project laravel/laravel --prefer-dist` | `composer require laravel/framework:{FSD.Laravel}` | Eloquent |
| Django | `django-admin startproject <proj> && python manage.py startapp core` | `pip install django=={FSD.Django}` | Django ORM |
| Go | `mkdir <proj> && go mod init github.com/user/<proj>` | go.mod: `go {FSD.Go}` | GORM/sqlx/migrate |

Git: `main` → `staging` → `feat/*`.
**STEP 2 — Deploy 9 harness files to root AFTER scaffold.** Source `docs/harness-root/` (staged M01-M05); overwrites framework boilerplate. Stack-specific `AGENTS.md`, `ARCHITECTURE.md`, `CONVENTIONS.md`, `.env.example` (`templates/04-dev-execution/{stack}/`); universal `CONTEXT.md`, `DESIGN.md`; generated `TODO.md`, `VERIFY_LOCAL.md`, `RUNBOOK_LOCAL.md`. (Details: deep dive.)

⛔ **STRICT ORDER — 4-line checklist, NEVER reorder:**
1. Scaffold finished (create-next-app / laravel new / django-admin / go mod init).
2. Copy staging to root: `cp docs/harness-root/* ./ && cp docs/harness-root/.env.example ./`
3. Verify all 9 files exist in root: AGENTS, ARCHITECTURE, CONTEXT, CONVENTIONS, DESIGN, TODO, .env.example, VERIFY_LOCAL, RUNBOOK_LOCAL.
4. ONLY then: `rm -rf docs/harness-root/` — NEVER delete staging before verification.

Optional: `./scripts/scaffold/template-picker.sh --phase 4 --dest .`
**Small skips the 9-file harness**: root `AGENTS.md` + `TODO.md` suffice.

**STEP 3 — Version gate (MANDATORY).** Run `./scripts/verify/verify-framework-version.sh` (or `.ps1`). Lockfile (package-lock/composer.lock/requirements.txt/go.mod) vs FSD: **major.minor exact**; Tailwind v3/v4 detected (v4 → CSS-first config). Mismatch → FAIL. Anti-overkill (`STACK_SUPPORT_MATRIX.md`): Small = no Docker/microservices; Medium = monolith (no Kafka/K8s); Large = modular monolith + DB + Redis. Drift → prune.

**STEP 4 — Pre-install dependency checks (BEFORE installing).**
`npm info <pkg> peerDependencies` → `npm view <pkg> deprecated` → `npm view <pkg> version` → pin `pnpm add <pkg>@<compatible-version>`. Known pairs, deprecated replacements, font rule, matrices: deep dive. Deprecated: do NOT install. Spec-locked CVEs: document/escalate.

**STEP 5 — Generate TODO.md** via `templates/04-dev-execution/TODO_TEMPLATE.md`. Read PRD/FSD/SITEMAP (or PROJECT_LITE.md). 100% coverage: 1 task per FSD/PROJECT_LITE **table/screen/endpoint/feature**. IDs `M06-{SETUP|DB|BE|FE|QA}-xx`; mandatory `M06-SETUP-03` specs pre-read (gate-checked). Each task: **Verify** {stack cmd}, **Expected** {criteria}, **Evidence** {output/screenshot/query}. Human validates coverage; commit before coding; `[x]` only after Verify.

**STEP 6 — Implement per TODO (DB → API → prototype).**
- **DB**: stack ORM migrations; pooling; FK-column indexes; reversible; seed data; Sprint 1 gate.
- **API**: endpoints per FSD, Zod/schema validation + 3 pillars — Security: encryption, HttpOnly cookies, parameterized queries; Performance: N+1 prevention, caching, indexing; Resources: pooling, streaming, memory.
- **Prototype**: per FSD `Module 04 Handoff Strategy` (Levels 1-4); check framework docs; **UI 100% identical to frozen prototype**; static screens first (Sprint 3), data-backed after DB+API.
- **5 UI states** per screen (idle/loading/success/error/empty).
- **Consumer mapping**: user-facing → UI exists; webhook → provider config; cron → caller in RUNBOOK_LOCAL.md; jobs → worker verified.

**STEP 7 — Tests & Git.** Stack tests (`npm run test:smoke` / `php artisan test` / `python manage.py test` / `go test ./...`); `tsc --noEmit`; `pnpm audit`. AI pre-merge review → `AI_REVIEW_LOG.md`. Merge to `staging`; tag Alpha.

**STEP 8 — RUNBOOK_LOCAL.md + VERIFY_LOCAL.md** from `templates/04-dev-execution/{RUNBOOK_LOCAL,VERIFY_LOCAL}_TEMPLATE.md` (placeholders → FSD endpoints + stack commands). Smoke test 100%.

## 2. Output Artifacts
Source code (clean, active `staging` branch) · **`RUNBOOK_LOCAL.md`** · **`VERIFY_LOCAL.md`** · **`AI_REVIEW_LOG.md`** · **`DEVELOPMENT_PROGRESS_TRACKER.md`** (`templates/04-dev-execution/`).

## 3. Gate Exit Criteria [GATE]
- [ ] Version match: lockfile major.minor exact vs FSD; Tailwind v3/v4 detected.
- [ ] 9 harness files verified in root (or Small: root `AGENTS.md` + `TODO.md`).
- [ ] Dependencies resolved; no unmet peers; no deprecated packages.
- [ ] Per-stack verification (chosen by the FSD `Stack Decision LOCKED:` field): Next.js → `pnpm build` + `pnpm tsc --noEmit` + `pnpm audit`; Laravel → `php artisan test`; Django → `pytest`; Go → `go test ./...`. All exit 0 (or documented spec-locked risk).
- [ ] Smoke test 100%.
- [ ] Migrations reversible; indexes in place; VERIFY_LOCAL.md has pass proof.
- [ ] Small: `docs/qa/SECURITY_CHECKLIST_SMALL.md` filled (≥300 bytes; absorbs M07 security).
- [ ] **Verbatim**: `./scripts/gates/validate-gate.sh M06` (or `.ps1 M06`) — exit 1 = fix and re-run.

## 4. Gate Exit & Routing
After coding completes and smoke test passes 100%:
1. **Self-verify**: gate checklist above all pass + latest commit on staging (`git log -1`).
2. Summarize local results to the user (compile/smoke results, VERIFY_LOCAL.md proof).
3. Continue per routing once the gate passes: Small → **Module 09-LITE (UAT Sign-off)**, skipping M07 & M08 · Medium/Large → **Module 07 (QA & SIT)**. (M06 is not a SKILL.md stop point; pause only if the user requested changes or the gate failed.)
