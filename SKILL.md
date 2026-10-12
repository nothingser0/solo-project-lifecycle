---
name: solo-project-lifecycle
description: Lightweight SDLC framework for solo devs and small teams, from idea to release. Use for new projects (MVP, SaaS, client work) that need phase structure, document templates, and quality gates. Do NOT use for one-off throwaway scripts, single-file bug fixes, or routine coding syntax questions.
version: 1.0.0
updated: 2026-10-11
---

# Solo Project Lifecycle

The framework repo is **read-only**. Project documents are written into the user's project directory. Load files on-demand only — never pre-load.

## When to use / not use

- **Yes**: starting a new project, client scoping, need PRD/FSD/SOW/UAT/BAST, need quality gates
- **No**: one-off scripts, single-file bugfixes, syntax questions, non-software

## Scale router (pick ONE, load only that path)

| Scale | Profile | Path | Stops |
|---|---|---|---|
| **Small / MVP** | 3–7 P0 features, no financial mutations, 1 decision maker, <4 weeks | Intake (5 questions, record in `docs/pm/PROJECT_STATE.md`, halt until answered) → M04-LITE → M05 → [STOP] → M06+security → M09-LITE → [STOP] → M10 → M12-LITE (`RUNBOOK_OPS.md`) | 2 stops |
| **Solo SaaS** | 8–15 P0, billing, 1 founder | M00-lite → M01 → M02 → M04 → M05 → M06 → M07 → M10 → M12 → M13 | free chaining |
| **Client (Medium)** | 8–15 P0, API/payment webhooks, contract, 99% SLA | M01 → M02 → **M03 SOW+DP [GATE]** → M04 → M05 → M06 → M07 → **M09 UAT [GATE]** → M10 → **M11 BAST+final payment [GATE]** → M12 | stop at gates only |
| **Enterprise** | >15 P0, regulated (OJK/UU PDP/ISO), legacy | ⛔ no solo coding — act as advisor: A00–A04 in `docs/modules/A00_ENTERPRISE_ADVISORY_SERIES.md` | per phase |

High-water mark: if any single dimension is higher (e.g., 3 features but payment webhooks), classify at the highest tier. Legacy data = NOT "Small + M08"; reclassify upward.

**Light default**: when scale is unclear, start Small and escalate only on risk triggers (payment webhooks, legacy data, regulated data, >7 P0 features, SLA commitments).

## File map (load only what's relevant)

- Modules M00–M13, A-series: `docs/modules/NN_*.md` — each is a compact runbook (≤~2k tokens): inputs → steps → outputs → gate criteria. Extended material lives in `docs/modules/deep-dives/`; open it only when a step requires depth.
- Templates: `templates/` — fast-track: `templates/essentials/`
- References: `references/` (stacks, solo patterns, checklists) — load when entering the related phase
- Code patterns: `patterns/` (Indonesia-specific: payment gateways, UU PDP, i18n/IDR, offline-first) — load only when the project needs that concern
- Case studies: `case-studies/` — for timeline/budget estimates

**Never load**: `INDEX.json`, `references/taxonomy/PROJECT_CATALOG_1000.md` — human-facing catalogs, too large for agent context.

## Core rules

1. **Gate script**: before declaring any module complete, run `./scripts/gates/validate-gate.sh <MODULE>` (or `.ps1`) and show its output verbatim. Exit 1 = incomplete, fix first. Gates check existence + non-stub, not document length.
2. **Template-first**: copy from `templates/` and fill systematically — never author freeform documents from memory.
3. **Stop per gate, not per module**: halt for explicit approval at every [GATE] in the path (Client: M03, M09, M11) and at Small's two stops (after M05, before M10). Chain non-gate modules in one go, presenting a brief artifact summary per module as you proceed. Autopilot requests never skip client gates (contractual).
4. **Cross-document consistency**: verify downstream docs against upstream ones (Scope → Sitemap → PRD/FSD → Schema → Code).
5. **YAGNI**: no features/components beyond what the scope asks. No unpaid work without a CR.
6. **Security**: never ask the user to paste secrets in chat — have them write to `.env.local`; verify the file exists without reading it.
7. **Research evidence**: primary research data must come from real users. If none yet, mark `PENDING_PRIMARY_RESEARCH` — never fabricate.
8. **Language**: reply and produce deliverables in **English** by default; switch languages only if the user explicitly asks. Indonesian commercial/regulatory context (SOW/SPK, DP milestones, BAST, UU PDP, e-Meterai, PPN, QRIS/Midtrans/Xendit) is natively supported.

## Harness root (9 files) — client / non-Small projects only

AGENTS.md, CONTEXT.md, ARCHITECTURE.md, DESIGN.md, CONVENTIONS.md, TODO.md, .env.example, RUNBOOK_LOCAL.md, VERIFY_LOCAL.md → stage in `docs/harness-root/`, copy to root **after** scaffold completes, verify, then delete staging. The **Small** path skips the 9-file harness — root `AGENTS.md` + `TODO.md` suffice.

## Scripts

`./scripts/gates/validate-gate.sh <MODULE>` · `./scripts/scaffold/init-project.sh <dir> <scale>` · `./scripts/scaffold/template-picker.sh` · see `scripts/` for more.
