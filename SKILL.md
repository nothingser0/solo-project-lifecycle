---
name: solo-project-lifecycle
description: Lightweight SDLC framework for solo devs and small teams, from idea to release. Use for new projects (MVP, SaaS, client work) that need phase structure, document templates, quality gates, and post-launch A/B test analysis. Do NOT use for one-off throwaway scripts, single-file bug fixes, or routine coding syntax questions.
version: 1.0.0
updated: 2026-10-21
---

# Solo Project Lifecycle

The framework repo is **read-only**. Project documents are written into the user's project directory. Load files on-demand only — never pre-load.

## When to use / not use

- **Yes**: starting a new project, client scoping, need PRD/FSD/SOW/UAT/BAST, need quality gates
- **No**: one-off scripts, single-file bugfixes, syntax questions, non-software

## Scale router (pick ONE, load only that path)

| Scale | Profile | Path | Stops |
|---|---|---|---|
| **Small / MVP** | 1–5 P0 features, no financial mutations, 1 decision maker, <4 weeks | Optional Pre-Intake Spike (`spike/`) → Intake (9 fields — 6 core + 3 escalation; record in `docs/pm/PROJECT_STATE.md`, halt until answered) → M04-LITE → M05 → [STOP] → M06+security → M09-LITE → [STOP] → M10 → M12-LITE (`RUNBOOK_OPS.md`) — M01/M02 are WAIVED here, but the scale classifier still runs | 2 stops |
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

- Modules M00–M13, A-series: `docs/modules/NN_*.md` — each is a compact runbook (≤~2k tokens): inputs → steps → outputs → gate criteria. Extended material lives in `docs/modules/deep-dives/`; open it only when a step requires depth.
- Templates: `templates/` — fast-track: `templates/essentials/`
- References: `references/` (stacks, solo patterns, checklists, `references/pm/AB_TEST_ANALYSIS_GUIDE.md`) — load when entering the related phase
- Code patterns: `patterns/` (Indonesia-specific: payment gateways, UU PDP, i18n/IDR, offline-first) — load only when the project needs that concern
- Case studies: `case-studies/` — for timeline/budget estimates

**Never load**: `docs/INDEX.json`, `references/taxonomy/PROJECT_CATALOG_1000.md` — human-facing catalogs, too large for agent context.

## Core rules

0. **Authority**: `docs/AUTHORITY.md` defines which activities are AGENT / HUMAN-DECIDES / HUMAN-ONLY / FORBIDDEN, per module. Read it before treating any step as yours. Never sign, self-approve, commit, deploy, hold production credentials, or assert a payment was received.
1. **Gate script**: before declaring any module complete, run `./scripts/gates/validate-gate.sh <MODULE>` (or `.ps1`) and show its output verbatim. Exit codes: `0` = passed · `1` = incomplete, fix first · `3` = **RETEST** (M00 only: the evidence is real but sits in the 2.0–4.9% waitlist band — the gate is *not* passed, so do not chain onward; run one optimisation sprint and re-test) · `4` = **PROVISIONAL_PENDING_M00** (M01 only: scoring is real but M00 primary research is not done — no final GO; run the interviews/waitlist and re-run) · `5` = **CAPACITY OVERRIDE ACCEPTED** (`validate-gate.sh` itself, not only the classifier: a capacity-only Large scope whose artefacts otherwise pass exits 5 under a human-signed `docs/pm/SOLO-CAPACITY-RISK-ACCEPTANCE.md` — the gate continues but the verdict is never a clean green; a real artefact failure still exits 1; non-delegable obligations still block with exit 2). Gates check existence + non-stub, not document length. **Never edit a number or verdict to turn a failing run green** — the gate reconciles declared decisions against the recorded evidence. The scale classifier runs at every scale: a declared `Scale:` never overrides the High-Water Mark.
2. **Template-first**: copy from `templates/` and fill systematically — never author freeform documents from memory. **Solo Kanban & Jira Standards**: Workflow `Backlog -> To Do (5) -> In Progress (2) -> In Review (1) -> Done` dengan penjelasan transisi maks. 1 kalimat per status. Eliminasi redundansi manual untuk solo dev: Assignee otomatis via Jira Automation ("Assign to me" saat In Progress; tidak ditulis di tiap kartu), hapus label `Solo` (gunakan label hanya untuk kondisi khusus seperti `blocked`), dan Due Date dikosongkan secara global. Format kartu wajib punchy dan scannable: `[ID] [Work Type] — Judul`, `Parent` (bila kartu anak), `Priority` (Highest/High/Medium/Low), `Description` (maks. 2 kalimat konkret), `Acceptance Criteria` (checklist pendek), `Estimate` (hours), dan `Dependencies`. Verifikasi jumlah kartu post-edit dan pastikan zero duplikasi dokumen.
3. **Stop per gate, not per module**: halt for explicit approval at every [GATE] (Client: M03, M09, M11) and at Small's two stops (after M05, before M10). Between stops, chain *spec/planning* modules in one go with a brief artifact summary each. Autopilot never skips client gates (contractual).
   - **Ask-first stops (never chain past, any scale)**: (a) **Intake** — the 9 fields (6 core + 3 escalation) in `templates/essentials/INTAKE_GATE.md`, recorded in `docs/pm/PROJECT_STATE.md` (mandatory at every scale — `PROJECT_LITE.md` is not a substitute), END TURN until answered; (b) **M04 Step 0.5 & 1.5** — (1) the human places ≥1 reference (multiple references supported) in `docs/design/inspiration/` BEFORE any logo/components/SITEMAP/DESIGN.md exists; folder empty → END TURN and ask, never invent one (`notes.md` is agent output, not the reference); (2) **Step 1.5 Reusable Component Showcase** (`docs/design/components/index.html`) must be presented and ACC'd by the human BEFORE full-screen assembly; (c) **M05 stack lock** — the 8 questions + user picks from 2–3 options, END TURN; (d) **M07** SIT approval; (e) **M08** client Data Sign-Off; (f) **M06 STEP 5** — human validates TODO coverage before coding starts.
   - **M04 Interactive Prototyping & Visual DNA (all scales)**: Prototyping requires physical visual code previews (`docs/design/screens/`) to prevent AI slop. Before assembling screens, author reusable primitives & composites in `docs/design/components/index.html` linked to shared CSS/JS, and obtain user ACC. At M04 Step 2, author interactive HTML prototype screens organized directly into role subfolders (`docs/design/screens/<role>/`, e.g. `public/`, `user/`, `staff/`, `admin/`) using the modular architecture (`docs/design/shared/css/styles.css` and `docs/design/shared/js/app.js`), completely eliminating complex `#role-switcher` DOM-hiding hacks. Code prototyping is the permanent standard. **Visual Benchmark DNA Mandate**: Prototypes MUST preserve the structural and aesthetic DNA of the human's reference: (1) calendar/schedules must use real column-aligned CSS Grid timelines (never fake full-width table rows); (2) segmented progress indicators must use segmented dashes, not thick generic lines; (3) extract exact curated hex colors from the benchmark (no uncalibrated neon hues like `#FF5722`); (4) maintain visual calm without crowding 3–4 action buttons into single list cards; (5) custom floating menus/popovers with `rounded-2xl` and `shadow-xl` (raw unstyled native `<select>` dropdowns are STRICTLY FORBIDDEN); (6) tactile micro-interactions on all interactive elements (hover duration-150, active:scale-[0.98], focus-visible:ring-2, backdrop-blur modal choreography, and fluid animated progress transitions); (7) full-screen prototype coverage covering 100% of all screens in `SITEMAP.md` organized cleanly per role subfolder — in M06 FE coding, the agent directly ports these approved prototype screens with zero ad-hoc layout invention; (8) modular & reusable prototype architecture: prototype screens in `docs/design/screens/<role>/` MUST link to shared CSS (`docs/design/shared/css/styles.css`) and shared JS (`docs/design/shared/js/app.js`) instead of scattered inline `<style>` tags or hardcoded ad-hoc styles; (8b) **wireflow interaction scenarios**: author companion testing runbooks in `docs/specs/wireflows/SCENARIOS_WFxx.md` covering nominal happy paths, validation constraints, and domain edge cases discovered during prototyping (disabled/expired accounts, multi-unit holders, network recovery); (9) automated UI/UX consistency audit & auto-fix: execute `scripts/design/uiux_audit.py` (or `scripts/design/uiux-audit.ps1 -Fix`) to mechanically audit every screen for component, font, badge, animation, and navbar parity and automatically resolve discrepancies before Design Freeze.
   - If an artifact would be invented (missing spec, missing stack lock, missing intake answer), **STOP AND ASK** — never proceed on a guess.
   - **M06 STEP 5 TODO Full-Fidelity Coverage**: `TODO.md` MUST synthesize from ALL upstream specs without lazy bundling: (1) `SITEMAP.md` 1-to-1 screen mapping (every `SCR-xx` gets its own `M06-FE-xx` task); (2) `FSD.md` Auth & RBAC (explicit `M06-AUTH-xx` tasks for login/session/guards); (3) `COMPONENT_REQUIREMENTS.md` UI primitives/composites (`M06-UI-xx`); (4) `FSD.md` DB models (1 task per table + idempotent seed); (5) `FSD.md` business calculation engines. Compressing screens into generic placeholders is strictly forbidden. Human validates TODO coverage before coding starts.
   - **M06 development is NOT chained**: implement **one TODO task per turn** → run its `Verify` → report Evidence → 🛑 **END TURN**. The `Verify` command MUST directly test the specific task deliverable (e.g. for a UI screen task, execute a route probe asserting HTTP 200/307; NEVER cite unrelated unit tests as UI evidence). A 404 on any declared route is an immediate blocker. The human approves before `[x]` and before the next task. When the human confirms with "approve", "approved", "acc", or "ok lanjut", the agent marks `[x]`, appends raw output under `Evidence:`, and adds `Approved: <date> by <name>`. Batch only when the user names task IDs. `[x]` is the human's mark, not the agent's autonomous tick.
4. **Cross-document consistency & Empirical Research**: verify downstream docs against upstream ones (Scope → Sitemap → PRD/FSD → Schema → Code). For domain-specific software archetypes (e.g., Bookmark Manager, ATS, CRM, E-Commerce, POS), the agent MUST NOT invent features or UI wireframes purely from training data; it MUST run live `web_search` against modern production standards to identify baseline industry feature-sets and layout expectations before locking scope or wireflows.
5. **YAGNI & Craftsmanship Anti-Slop**: no features/components beyond what the scope asks. No unpaid work without a CR. **Zero tech stack leaks in customer UI**: never mention internal tech stack names (`Supabase Auth`, `Next.js`, `Prisma`, `PostgreSQL`, `Tailwind`) in user-facing copy, badges, footers, or tooltips; speak strictly in customer domain language. **Zero spec identifier leaks**: never display internal spec codes (`SCR-xx`, `REQ-xx`, `M06-FE-xx`, `FSD-xx`) in customer-facing UI headings, badges, or subtitles. **Zero stub pages**: every route declared in SITEMAP must be fully implemented with real components, tables, and forms (empty `<12` line / `<400` byte placeholder pages fail M06 gate). **Authentic auth**: login forms must execute real credential actions, never client `<Link>` shortcuts. **Zero dead buttons**: all action buttons/bells must have active handlers or popovers. **Zero dummy mock URLs**: no `example.com` in seed data or attachments. **Zero redundant codebase comments**: eliminate obvious syntax-repeating comments (e.g. `// Header`, `// Button`, `// Loop through items`, `// Return result`); code must be self-documenting. **Zero raw browser alerts**: calling `window.alert()`, `confirm()`, or `prompt()` is strictly prohibited; all user feedback and confirmations MUST use design-matched custom Toasts and Dialog Modals. **Zero unstyled native `<select>` slop**: dropdowns, filter pills, and action menus must use custom styled floating popovers with rounded containers and soft shadows. **Mandatory micro-interactions**: hover, active press compression, focus rings, modal zoom/fade, and progress transitions must be animated.
6. **Security**: never ask the user to paste secrets in chat — have them write to `.env.local`; verify the file exists without reading it.
7. **Research evidence**: primary research data must come from real users. If none yet, mark `PENDING_PRIMARY_RESEARCH` — never fabricate.
8. **Language matching**: use the language the human is using in the current conversation for replies and human-facing prose in project files (especially Markdown documents, reports, plans, and UI copy). If the human writes in Indonesian, speak Indonesian and write the explanatory prose in project `.md` files in Indonesian; follow the same rule for other languages. Keep code, identifiers, API and schema names, commands, conventional technical terms, and code comments in standard English unless the project or user explicitly requires otherwise. Preserve established names and quoted source text; do not translate code or identifiers just to match prose language. When editing a mixed-language document, make the prose you author or revise match the human's language while leaving technical tokens intact. Indonesian commercial/regulatory context (SOW/SPK, DP milestones, BAST, UU PDP, e-Meterai, PPN, QRIS/Midtrans/Xendit) is natively supported.
9. **Next action brevity**: `docs/pm/PROJECT_STATE.md` may include one `Next action` line or short paragraph to preserve handoff continuity. State only the immediate action and its condition/owner if needed (normally one sentence). Do not repeat the project summary, rationale, risks, prior decisions, or later-stage reminders there; those belong in their dedicated sections. Other files need a `Next action` section only when their template or purpose requires a handoff.

## Harness root (9 files) — client / non-Small projects only

AGENTS.md, CONTEXT.md, ARCHITECTURE.md, DESIGN.md, CONVENTIONS.md, TODO.md, .env.example, RUNBOOK_LOCAL.md, VERIFY_LOCAL.md → stage in `docs/harness-root/`, copy to root **after** scaffold completes, verify, then delete staging. The **Small** path skips the 9-file harness — root `AGENTS.md`, `TODO.md`, and `DESIGN.md` suffice (M06 requires that third file at root for Small too).

## Scripts

`./scripts/gates/validate-gate.sh <MODULE>` · `./scripts/scaffold/init-project.sh <dir> <scale>` · `./scripts/scaffold/template-picker.sh` · `python scripts/runtime/analyze_ab_test.py` · see `scripts/` for more.
