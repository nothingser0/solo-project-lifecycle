# Solo Software Lifecycle Orchestrator

> **This file is a human-facing overview.** The agent-facing entry point is [`SKILL.md`](../SKILL.md). Quick start: [`QUICKSTART.md`](./QUICKSTART.md).

Software operational framework for solo developers executing projects from Small (MVP) to Enterprise scale with scope protection, AI automation, and tiered quality gates.

---

## 1. Core Solo Rules

1. **Defensive Scope Management**: any feature addition without formal documentation is unpaid work.
2. **Single PIC Rule**: on Medium+ projects the Client designates one absolute Person in Charge.
3. **Locked Client Dependencies**: release schedules shift automatically with client delays in data/access/approvals.
4. **Uncompromising Gates**:
   - No coding without signed SOW + Down Payment (client work).
   - No production domain pointing without UAT pass.
   - No code/credential handover without 100% final settlement + signed BAST.
5. **Stops are per-gate, not per-module** (see SKILL.md rule 3): halt at M03 / M09 / M11 for client work, and at Small's two stops (after M05, before M10). Non-gate modules chain with artifact summaries.

---

## 2. Project Scale Matrix

| Scale | Boundaries | Specs & Design | QA & UAT | Release |
| :--- | :--- | :--- | :--- | :--- |
| **Small (MVP)** | <4 weeks, 3–7 P0, no financial mutation | `PROJECT_LITE.md` + M04-LITE | Smoke + security checklist small | PaaS deploy, email BAST (client) |
| **Medium (Solo SaaS / Client)** | 1–3 months, auth, DB, payments | Modular PRD, Design System, FSD, API contract | SIT, signed PIC UAT | CI/CD, stamped BAST, 60-day warranty |
| **Large** | 3–6 months, multi-system | Formal PRD/FSD, WBS, risk | Full test pyramid, basic pentest | Zero-downtime, 90-day warranty |
| **Enterprise** | >25 P0, regulated, legacy | Full governance pack | Third-party pentest, DR drill | CAB, legal BAST, SLA — **solo coding prohibited**, advisory only (A00–A04) |

**Warranty**: Small 30d · Medium 60d · Large/Enterprise 90d.

---

## 3. Folder Hygiene (absolute)

- **`docs/pm/`**: initiation, scoping, legal, governance docs (`IDEA_BRIEF.md`, `SCOPE_STATEMENT.md`, `SOW_CONTRACT.md`, `BAST.md`…).
- **`docs/specs/`**: technical specs (`PRD.md`, `FSD.md`, `DESIGN_SPEC.md`, `SITEMAP.md`).
- **Root (`./`)**: ONLY the 9 AI harness files (`AGENTS.md`, `CONTEXT.md`, `ARCHITECTURE.md`, `DESIGN.md`, `CONVENTIONS.md`, `.env.example`, `TODO.md`, `RUNBOOK_LOCAL.md`, `VERIFY_LOCAL.md`), `README.md`, and framework configs. Never planning docs in root.
- **Small path exception**: root harness = `AGENTS.md` + `TODO.md` only.

---

## 4. Module Index

Modules live in `docs/modules/` — each is a compact runbook (≤~2k tokens) with a companion deep-dive in `docs/modules/deep-dives/`.

| # | Module | Gate |
| :--- | :--- | :--- |
| M00 | Product Discovery & Strategy (`00_PRODUCT_DISCOVERY_STRATEGY.md`) | — |
| M01 | Idea & Feasibility (`01_IDEA_FEASIBILITY.md`) | — |
| M02 | Discovery & Scope (`02_DISCOVERY_SCOPE.md`) | — |
| M03 | Legal SOW & Charter (`03_LEGAL_SOW_CHARTER.md`) | **[GATE 1]** Commercial (client) |
| M04 | UI/UX & Prototyping (`04_UIUX_PROTOTYPING.md`, LITE: `variants/04_UIUX_LITE.md`) | — |
| M05 | Architecture & Specs (`05_ARCHITECTURE_SPECS.md`) | — |
| M06 | Development Execution (`06_DEVELOPMENT_EXECUTION.md`) | — |
| M07 | QA & SIT (`07_QUALITY_ASSURANCE_SIT.md`) | — |
| M08 | Data Migration & Seeding (`08_DATA_MIGRATION_SEEDING.md`) | — |
| M09 | Client UAT & Sign-off (`09_UAT_CLIENT_SIGNOFF.md`) | **[GATE 2]** Validation (client) |
| M10 | Deployment & Go-Live (`10_DEPLOYMENT_PRODUCTION.md`) | — |
| M11 | Handover & BAST (`11_HANDOVER_BAST.md`) | **[GATE 3]** Settlement (client) |
| M12 | Warranty & SLA (`12_WARRANTY_SLA_RETAINER.md`) | — |
| M13 | Product Operations (`13_PRODUCT_OPERATIONS_ITERATION.md`) | — |
| A00–A04 | Enterprise Advisory (`A00_ENTERPRISE_ADVISORY_SERIES.md`) | advisory only |

**Progressive loading**: load ONE module file when entering its phase. Never preload all modules. Human-reference catalogs (`docs/INDEX.json`, `references/taxonomy/`) must not be loaded by agents.

---

## 5. Automation & Tooling

- **Gate validation**: `./scripts/gates/validate-gate.sh <MODULE>` (bash; the `.ps1` twin is a thin wrapper).
- **Scale classifier**: `./scripts/gates/classify-scale.sh docs/pm/PROJECT_STATE.md` (structured-field parsing).
- **Scaffold**: `./scripts/scaffold/init-project.sh <dir> <scale>` (proportional per scale).
- **Package version check**: `./scripts/verify/check-package-versions.sh <framework>` — see [`PACKAGE_VERSION_AUTO_CHECK.md`](./PACKAGE_VERSION_AUTO_CHECK.md).
- **Integrity suite**: `./scripts/verify/verify-all.sh` (also runs in CI).
- **Evals**: `evals/` — 8 behavioral scenarios (gate stopping, anti-hallucination, classifier, token budget).
