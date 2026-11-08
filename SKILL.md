---
name: solo-project-lifecycle
description: Structured, gate-controlled SDLC framework for solo devs and lean teams, from idea to release. Use for new projects (MVP, SaaS, client work) that need phase structure, document templates, quality gates, and post-launch A/B test analysis. Do NOT use for one-off throwaway scripts, single-file bug fixes, or routine coding syntax questions.
version: 0.1.1
updated: 2026-11-08
---

# Solo Project Lifecycle

The framework repo is **read-only**. Project documents are written into the user's project directory. Load files on-demand only — never pre-load.

## When to use / not use

- **Yes**: starting a new project, client scoping, need PRD/FSD/SOW/UAT/BAST, need quality gates
- **No**: one-off scripts, single-file bugfixes, syntax questions, non-software

## Scale router (pick ONE, load only that path)

| Scale | Profile | Path | Stops |
|---|---|---|---|
| **Spike / PoC** | 1–3 days, technical feasibility or throwaway prototype | Optional `spike/` → direct build; formal specs, intake gate & gate scripts waived | No stops |
| **Small / MVP** | 1–5 P0 features, no financial mutations, 1 decision maker, <4 weeks | Optional Pre-Intake Spike (`spike/`) → Intake (9 fields — 6 core + 3 escalation; record in `docs/pm/PROJECT_STATE.md`, halt until answered) → M04-LITE → M05 → [STOP] → M06+security → M09-LITE → [STOP] → M10 → M12-LITE (`RUNBOOK_OPS.md`) — M01/M02 are WAIVED here, but the scale classifier still runs | 2 stops — step-by-step day plan: `docs/QUICKSTART.md` § "The Small-Path MVP Flow" |
| **Solo SaaS** | 6–15 P0, billing, 1 founder | M00-lite → M01 → M02 → M04 → M05 → M06 → M07 → M10 → M12 → M13 | M05 stack lock + M07 |
| **Client (Medium)** | 6–15 P0, API/payment webhooks, contract, 99% SLA | M01 → M02 → **M03 SOW+DP [GATE]** → M04 → M05 → M06 → M07 → **M09 UAT [GATE]** → M10 → **M11 BAST+final payment [GATE]** → M12 | gates M03/M09/M11 + M05 stack lock, M07, M08 |
| **Large** | 16–25 P0, multi-service, **no** non-delegable obligation | **Solo coding + advisor** — the capacity risk must be accepted in writing (`docs/pm/SOLO-CAPACITY-RISK-ACCEPTANCE.md`, human-signed) → classifier exit **5**. An explicit formal-assurance answer or legacy-core replacement re-routes to A00–A04. | per phase |
| **Enterprise** | >25 P0, or any explicit non-delegable formal assurance obligation / legacy-core replacement | ⛔ no solo coding — advisory only: A00–A04 in `docs/modules/A00_ENTERPRISE_ADVISORY_SERIES.md`. Baseline privacy duties (including UU PDP) require safeguards but do not alone trigger Enterprise. | per phase |

High-water mark: if any single dimension is higher (e.g., 3 features but payment webhooks), classify at the highest tier. Legacy data = NOT "Small + M08"; reclassify upward. The Solo Capacity Gate has **two predicates**: a *non-delegable* obligation (explicit formal assurance, legacy-core) is a permanent hard block (exit 2), while a *capacity-only* Large scope may be accepted in writing (exit 5).

## Phase names (required in user-facing status and project documents)

The phase codes are internal identifiers and are not self-explanatory. Whenever a phase appears in a status, gate, recommendation, decision log, or user-facing explanation, write its code **with its plain-language name** at least on first mention in that section. Never leave labels such as `M00`, `M01`, `M03`, or `A01` unexplained. Use the canonical names below; local documents may add a short translation but must not replace the code.

| Code | Canonical phase name |
|---|---|
| M00 | Product Research & Discovery |
| M01 | Idea Feasibility |
| M02 | Scope Definition & Freeze |
| M03 | Legal, SOW & Client Data Protection |
| M04 | UI/UX & Prototyping |
| M05 | Architecture & Technical Specifications |
| M06 | Development Execution |
| M07 | Quality Assurance & System Integration Testing (SIT) |
| M08 | Data Migration & Seeding |
| M09 | User Acceptance Testing (UAT) & Client Sign-off |
| M10 | Production Deployment |
| M11 | Handover & Final Acceptance (BAST) |
| M12 | Warranty, SLA & Retainer |
| M13 | Product Operations & Iteration |
| A00 | Enterprise Advisory: Bid/No-Bid & Legal Clearance |
| A01 | Enterprise Advisory: Work Breakdown & Phasing |
| A02 | Enterprise Advisory: Architecture, Threat Modeling & Quality Scenarios |
| A03 | Enterprise Advisory: Vendor Procurement & Build-vs-Buy |
| A04 | Enterprise Advisory: Governance Handover |

Example: write `M00 · Product Research & Discovery` and `M01 · Idea Feasibility`, not bare codes. For ranges, name the stages in the range or link to this glossary (for example, `M05–M13 · Architecture through Product Operations`).

**Light default**: when scale is unclear, start Small and escalate only on risk triggers (payment webhooks, legacy data, regulated data, 6+ P0 features, SLA commitments).

## File map (load only what's relevant)

- Modules M00–M13, A-series: `docs/modules/NN_*.md` — compact runbooks (≤~2k tokens): inputs → steps → outputs → gate criteria. Extended material in `docs/modules/deep-dives/` (open only when a step requires depth).
- Templates: `templates/` — fast-track: `templates/essentials/`
- References: `references/` (stacks, solo patterns, checklists, `references/pm/AB_TEST_ANALYSIS_GUIDE.md`) — load when entering the related phase
- Code patterns: `patterns/` (Indonesia-specific: payment gateways, UU PDP, i18n/IDR, offline-first) — load only when relevant
- Case studies: `case-studies/` — for timeline/budget estimates

## Context budget (hard limits, not advice)

The repo is ~1.2M tokens. Anything beyond these limits means you are loading the framework instead of doing the work.

| What | Limit per phase |
|---|---|
| Module files open at once | **1** (read its sections, not its neighbours) |
| Framework files per phase (module + template + reference) | **3**, ~10k tokens total |
| `docs/modules/deep-dives/` | only when the module step says "see deep-dives" |
| `references/` + `patterns/` | 2 files, and only those the phase module names |

Rules:
- Enter a phase by reading its module (`docs/modules/NN_*.md`), then the one template you are filling. Load a second reference only when a step names it.
- Never pre-load the next phase's module, the whole `templates/` tree, or a deep-dive "for background".
- A small path (SKILL.md + intake + 6 modules) is ~25k tokens. If your context is over ~50% used mid-phase, stop loading docs: re-read `docs/pm/PROJECT_STATE.md` and continue from there (see Core rule 6).
- A runbook budget is **~4.5k tokens** (`scripts/verify/verify-all.sh` warns above it). Read the condensed step, then open only the specific deep-dive section pointed to.

**Never load**: `docs/INDEX.json`, `references/taxonomy/PROJECT_CATALOG_1000.md` — human-facing catalogs, too large for agent context.

## Core rules

0. **Authority**: `docs/AUTHORITY.md` defines which activities are AGENT / HUMAN-DECIDES / HUMAN-ONLY / FORBIDDEN per module. Never sign, self-approve, commit, deploy, hold production credentials, or assert payment was received.
1. **Gate script**: before declaring any module complete, run `./scripts/gates/validate-gate.sh <MODULE>` (or `.ps1`) and show output verbatim. Exit codes: `0` = passed · `1` = incomplete · `3` = RETEST (M00 waitlist 2.0–4.9%) · `4` = PROVISIONAL_PENDING_M00 · `5` = CAPACITY OVERRIDE ACCEPTED (`docs/pm/SOLO-CAPACITY-RISK-ACCEPTANCE.md`). Never falsify data or verdicts. Classifier runs at every scale.
2. **Template-first**: copy from `templates/` systematically — never author freeform documents from memory. Confirm folder placement in `docs/WHERE_THINGS_GO.md`. Kanban conventions follow `references/pm/KANBAN_CARD_CRAFT_GUIDE.md`.
3. **Stop per gate & Ask-first stops**: halt for explicit approval at [GATE]s (Client: M03, M09, M11) and Small's two stops (after M05, before M10). Never chain past ask-first stops:
   - (a) **Intake**: 9 fields (6 core + 3 escalation in `templates/essentials/INTAKE_GATE.md` → `docs/pm/PROJECT_STATE.md`) + spreadsheet triage; END TURN until answered. Missing specs → **STOP AND ASK**.
   - (b) **M04 Step 0.5 & 1.5**: Human places ≥1 reference in `docs/design/inspiration/` before any design artifact; Reusable Component Showcase (`docs/design/components/index.html`) approved before full screens. Complete Visual DNA rules live in `docs/modules/04_UIUX_PROTOTYPING.md`.
   - (c) **M05 stack lock**: 8 questions + user selects options; END TURN.
   - (d) **M06 Step 5 TODO review**: `TODO.md` synthesized without lazy bundling (1-to-1 SITEMAP parity, Auth/RBAC, UI primitives, DB/business logic). Human validates TODO before coding.
   - (e) **M06 1-Task-Per-Turn Execution**: implement one task per turn → run direct `Verify` probe (e.g. route HTTP 200/307; never fake mocks) → report evidence → 🛑 **END TURN**. Human approves before `[x]`. Complete execution rules live in `docs/modules/06_DEVELOPMENT_EXECUTION.md`.
   - (f) **M07** SIT approval; (g) **M08** Data sign-off.
4. **Cross-document consistency & Empirical Research**: verify downstream docs against upstream ones. For domain software archetypes (CRM, ATS, E-commerce, etc.), run live `web_search` against modern production standards before locking scope or wireflows.
5. **YAGNI, Craftsmanship & Anti-Yes-Man**:
   - **Anti-Yes-Man pushback**: push back on over-engineered, insecure, or out-of-scope requests (`references/process/ANTI_YES_MAN.md`).
   - **Scope discipline**: zero features beyond locked scope; no unpaid work without signed CR.
   - **No leaks or fakes**: never expose tech-stack names or internal codes (`SCR-xx`, `REQ-xx`) to customer UI. Real routes, real credential login, wired buttons. No `href="#"`, `example.com`, `Lorem ipsum`, or placeholder personas in UI/seed data.
   - **No slop in shipped code**: zero unrequested comments; zero `console.log`; zero `: any` / `as any`; zero native `window.alert/confirm/prompt` (use Toast/Dialog); no unstyled native `<select>`.
   - **Icons & motion**: semantic SVG icons only (Lucide/Heroicons) — no unicode emoji in shipped code/UI. Tactile micro-interactions (hover, active scale, focus ring, smooth transitions) are mandatory.
6. **Context Amnesia & Real Verification Guard**: when context compresses or resuming sessions, re-read `docs/pm/PROJECT_STATE.md` (handoff state is gate-enforced). Verification MUST directly test running deliverables (HTTP probe / linter).
6b. **Change Fence**: modify only what the request or current TODO task names. No drive-by refactors, formatting sweeps, or unintended file changes. List files before editing and report reason for each change.
7. **Dependency & Zero Broken Build Guard**: check manifests before installing libraries; run local typecheck/build and confirm zero compiler errors before completing steps.
8. **Security**: never paste secrets in chat; use `.env.local` and verify existence without reading values.
9. **Research evidence**: primary research must come from real users; mark `PENDING_PRIMARY_RESEARCH` if not yet collected.
10. **Language matching**: match the user's conversational language in replies and explanatory prose in `.md` project files (Indonesian for Indonesian users). Keep code, identifiers, schema names, and standard technical tokens in English. Indonesian commercial/regulatory standards (SOW/SPK, DP milestones, BAST, UU PDP, e-Meterai, PPN, QRIS/Midtrans/Xendit) are natively supported.
11. **Next action brevity**: state only the immediate next action and owner in `docs/pm/PROJECT_STATE.md` (one concise sentence).

## Harness root (9 files) — client / non-Small projects only

`AGENTS.md`, `CONTEXT.md`, `ARCHITECTURE.md`, `DESIGN.md`, `CONVENTIONS.md`, `TODO.md`, `.env.example`, `RUNBOOK_LOCAL.md`, `VERIFY_LOCAL.md` → stage in `docs/harness-root/`, copy to root **after** scaffold completes, verify, then delete staging. Small path needs root `AGENTS.md`, `TODO.md`, and `DESIGN.md` only.

## Scripts

`./scripts/gates/validate-gate.sh <MODULE>` · `./scripts/scaffold/init-project.sh <dir> <scale>` · `./scripts/scaffold/template-picker.sh` · `python scripts/runtime/analyze_ab_test.py` · see `scripts/` for more.
