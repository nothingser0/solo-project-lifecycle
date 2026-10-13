# Module 06: Development Execution (Coding & 3 Pillars)

Coding via **AI Coding Agents** with an **Agent Harness** + Git branching; 3 pillars: **Security, Performance, Resource Efficiency**.
**Inputs**: `docs/specs/FSD.md` (LOCKED stack) + `PRD.md` + frozen prototype; Small: `PROJECT_LITE.md`.
> **Templates to copy**: `templates/04-dev-execution/{TODO,RUNBOOK_LOCAL,VERIFY_LOCAL}_TEMPLATE.md` · pre-merge: `checklists/{FRONTEND,BACKEND,INTEGRATION}_CHECKLIST.md`
📖 **Optional** (do NOT preload): `references/solo/{SOLO_DEVELOPMENT_PATTERNS,SOLO_ENGINEERING_STANDARDS}.md` · `references/playbooks/AI_ASSISTED_DEVELOPMENT.md` · stack quickstarts · `references/stacks/STACK_SUPPORT_MATRIX.md` · conditional: `patterns/localization/I18N_INDONESIA.md`, `patterns/payments/INDONESIA_PAYMENT_GATEWAYS.md`.

> **Pre-merge AI review (inline, 5 checks — log in `AI_REVIEW_LOG.md`)**: (1) every changed file traces to a TODO task; (2) no invented imports/APIs — verify each exists; (3) no secrets, no `@ts-ignore`/`as any`/empty catch; (4) new logic tested; (5) one logical change per commit.
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

Git: `main` → `staging` → `feat/*`.
**STEP 2 — Deploy harness files to root AFTER scaffold (gate-enforced).** Source `docs/harness-root/` (staged M01-M05 for all scales, including Small); overwrites boilerplate. Unstaged fallback: `templates/04-dev-execution/{AGENTS,ARCHITECTURE,CONVENTIONS,ENV_EXAMPLE}_TEMPLATE.md` + `{stack}/` + `templates/02-design/DESIGN_MD_TEMPLATE.md`, renaming `ENV_EXAMPLE`→`.env.example`.
⛔ **STRICT ORDER (never reorder):** (1) scaffold finished; (2) `cp docs/harness-root/* ./ && cp docs/harness-root/.env.example ./ 2>/dev/null || true`; (3) verify root harness files (Medium+: 9 files; Small: `AGENTS.md`, `TODO.md`, `DESIGN.md`); (4) ONLY then `rm -rf docs/harness-root/`. Optional: `./scripts/scaffold/template-picker.sh --phase 4 --dest .`.

**STEP 3 — Version gate (MANDATORY).** Run `./scripts/verify/verify-framework-version.sh` (or `.ps1`). It checks the scaffold manifest type matches FSD, then lockfile (package-lock/composer.lock/requirements.txt/go.mod) vs FSD `Framework Versions (Pinned)` (both pinned forms accepted): **major.minor exact**, Tailwind v3/v4 reported (v4 → CSS-first config). Mismatch → FAIL. Anti-overkill (`references/stacks/STACK_SUPPORT_MATRIX.md`): Small = no Docker/microservices; Medium = monolith (no Kafka/K8s); Large = modular monolith + DB + Redis. Drift → prune.

**STEP 4 — Pre-install dependency checks (BEFORE installing).**
`npm info <pkg> peerDependencies` → `npm view <pkg> deprecated` → `npm view <pkg> version` → pin `pnpm add <pkg>@<compatible-version>`. Known pairs, deprecated replacements, font rule, matrices: deep dive. Deprecated: do NOT install. Spec-locked CVEs: document/escalate.

**STEP 5 — Generate TODO.md** via `templates/04-dev-execution/TODO_TEMPLATE.md`. Read PRD/FSD/SITEMAP (or PROJECT_LITE.md). 100% coverage: 1 task per FSD/PROJECT_LITE **table/screen/endpoint/feature**. Exactly 7 closed categories across all scales: `M06-{SETUP|DB|BE|FE|INT|TEST|GATE}-xx` (sub-categories are expressed strictly via sprint headings/titles, no ad-hoc prefixes); mandatory `M06-SETUP-03` specs pre-read (gate-checked). Each task: **Verify** {stack cmd}, **Expected** {criteria}, **Evidence** {output}. 🛑 **END TURN after writing TODO.md** — present task count; wait for user confirmation BEFORE implementing the first task.

**STEP 6 — Implement per TODO (DB → API → prototype).** **One task per turn**: implement → run `Verify` → report Evidence → 🛑 **END TURN**. Human approves before `[x]` and the next task; `Approved: <date> by <name>` is **gate-enforced** (self-ticked tasks fail). Batch only when the user names task IDs.
- **DB**: stack ORM migrations; pooling; FK-column indexes; reversible; seed data.
- **API**: endpoints per FSD, Zod/schema validation + 3 pillars — Security: encryption, HttpOnly cookies, parameterized queries; Performance: N+1 prevention, caching, indexing; Resources: pooling, streaming, memory.
- **Concurrency & comment hygiene**: read-modify-write on stock/balance/counter/status MUST be atomic (tx + row lock, unique constraint, or CAS); webhooks idempotent. No comments that restate code, no stubs, no commented-out code. Details: deep dive.
- **Prototype**: per FSD `Module 04 Handoff Strategy` (Levels 1-4); **UI 100% identical to frozen prototype**; static screens first (Sprint 3), data-backed after DB+API.
- **5 UI states** per screen (idle/loading/success/error/empty).
- **Hydration-free UI (SSR stacks)**: if a view is correct without hydration, it must be built that way. No `Date.now()`/`new Date()`/`Math.random()`/`localStorage`/bare `toLocaleString()` during the initial render; every date/number formatter passes an explicit `locale` + `timeZone`; `'use client'` only on the smallest leaf that needs interaction, each one recorded in `VERIFY_LOCAL.md` §4C. Ladder: `references/technical/HYDRATION_FREE_RENDERING.md`; console proof required per `VERIFY_LOCAL.md` §4C.
- **Consumer mapping**: user-facing → UI exists; webhook → provider config; cron → caller in RUNBOOK_LOCAL.md; jobs → worker verified.

**STEP 7 — Tests & Git.** Stack smoke/unit tests + `tsc --noEmit` + `pnpm audit`. AI pre-merge review → `AI_REVIEW_LOG.md`. **Human merges to `staging` and tags Alpha** — agent must not commit/merge/tag.

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
