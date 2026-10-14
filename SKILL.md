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
| **Small / MVP** | 1–5 P0 features, no financial mutations, 1 decision maker, <4 weeks | Optional Pre-Intake Spike (`spike/`) → Intake (9 fields — 6 core + 3 escalation; record in `docs/pm/PROJECT_STATE.md`, halt until answered) → M04-LITE → M05 → [STOP] → M06+security → M09-LITE → [STOP] → M10 → M12-LITE (`RUNBOOK_OPS.md`) — M01/M02 are WAIVED here, but the scale classifier still runs | 2 stops |
| **Solo SaaS** | 6–15 P0, billing, 1 founder | M00-lite → M01 → M02 → M04 → M05 → M06 → M07 → M10 → M12 → M13 | M05 stack lock + M07 |
| **Client (Medium)** | 6–15 P0, API/payment webhooks, contract, 99% SLA | M01 → M02 → **M03 SOW+DP [GATE]** → M04 → M05 → M06 → M07 → **M09 UAT [GATE]** → M10 → **M11 BAST+final payment [GATE]** → M12 | gates M03/M09/M11 + M05 stack lock, M07, M08 |
| **Large** | 16–25 P0, multi-service, **no** non-delegable obligation | **Solo coding + advisor** — the capacity risk must be accepted in writing (`docs/pm/SOLO-CAPACITY-RISK-ACCEPTANCE.md`, human-signed) → classifier exit **5**. A non-delegable answer (statutory compliance / legacy-core) re-routes to A00–A04. | per phase |
| **Enterprise** | >25 P0, or any non-delegable obligation: statutory compliance (OJK/UU PDP/ISO), legacy-core replacement | ⛔ no solo coding — non-delegable, advisory only: A00–A04 in `docs/modules/A00_ENTERPRISE_ADVISORY_SERIES.md`. No signature can substitute a licensed auditor/vendor. | per phase |

High-water mark: if any single dimension is higher (e.g., 3 features but payment webhooks), classify at the highest tier. Legacy data = NOT "Small + M08"; reclassify upward. The Solo Capacity Gate has **two predicates**: a *non-delegable* obligation (statutory compliance, legacy-core) is a permanent hard block (exit 2), while a *capacity-only* Large scope may be accepted in writing (exit 5).

**Light default**: when scale is unclear, start Small and escalate only on risk triggers (payment webhooks, legacy data, regulated data, >7 P0 features, SLA commitments).

## File map (load only what's relevant)

- Modules M00–M13, A-series: `docs/modules/NN_*.md` — each is a compact runbook (≤~2k tokens): inputs → steps → outputs → gate criteria. Extended material lives in `docs/modules/deep-dives/`; open it only when a step requires depth.
- Templates: `templates/` — fast-track: `templates/essentials/`
- References: `references/` (stacks, solo patterns, checklists) — load when entering the related phase
- Code patterns: `patterns/` (Indonesia-specific: payment gateways, UU PDP, i18n/IDR, offline-first) — load only when the project needs that concern
- Case studies: `case-studies/` — for timeline/budget estimates

**Never load**: `docs/INDEX.json`, `references/taxonomy/PROJECT_CATALOG_1000.md` — human-facing catalogs, too large for agent context.

## Core rules

0. **Authority**: `docs/AUTHORITY.md` defines which activities are AGENT / HUMAN-DECIDES / HUMAN-ONLY / FORBIDDEN, per module. Read it before treating any step as yours. Never sign, self-approve, commit, deploy, hold production credentials, or assert a payment was received.
1. **Gate script**: before declaring any module complete, run `./scripts/gates/validate-gate.sh <MODULE>` (or `.ps1`) and show its output verbatim. Exit codes: `0` = passed · `1` = incomplete, fix first · `3` = **RETEST** (M00 only: the evidence is real but sits in the 2.0–4.9% waitlist band — the gate is *not* passed, so do not chain onward; run one optimisation sprint and re-test) · `4` = **PROVISIONAL_PENDING_M00** (M01 only: scoring is real but M00 primary research is not done — no final GO; run the interviews/waitlist and re-run) · `5` = **CAPACITY OVERRIDE ACCEPTED** (classifier only: a capacity-only Large scope runs solo under a human-signed `docs/pm/SOLO-CAPACITY-RISK-ACCEPTANCE.md`; the gate continues but always surfaces the override, never a clean green — non-delegable obligations still block with exit 2). Gates check existence + non-stub, not document length. **Never edit a number or verdict to turn a failing run green** — the gate reconciles declared decisions against the recorded evidence. The scale classifier runs at every scale: a declared `Scale:` never overrides the High-Water Mark.
2. **Template-first**: copy from `templates/` and fill systematically — never author freeform documents from memory.
3. **Stop per gate, not per module**: halt for explicit approval at every [GATE] (Client: M03, M09, M11) and at Small's two stops (after M05, before M10). Between stops, chain *spec/planning* modules in one go with a brief artifact summary each. Autopilot never skips client gates (contractual).
   - **Ask-first stops (never chain past, any scale)**: (a) **Intake** — the 9 fields (6 core + 3 escalation) in `templates/essentials/INTAKE_GATE.md`, recorded in `docs/pm/PROJECT_STATE.md` (mandatory at every scale — `PROJECT_LITE.md` is not a substitute), END TURN until answered; (b) **M04 Step 0.5 design references** — the human places ≥1 reference in `docs/design/inspiration/` BEFORE any logo/components/SITEMAP/DESIGN.md exists; folder empty → END TURN and ask, never invent one (`notes.md` is agent output, not the reference); (c) **M05 stack lock** — the 8 questions + user picks from 2–3 options, END TURN; (d) **M07** SIT approval; (e) **M08** client Data Sign-Off; (f) **M06 STEP 5** — human validates TODO coverage before coding starts.
   - **M04 Prototyping Workflow Choice (all scales)**: Prototyping requires physical visual previews to prevent AI slop. At M04 Step 2, the agent must STOP AND ASK the human to choose: Workflow A (HTML click-dummy screen previews in `docs/design/screens/`), Workflow B (AI builder v0/Lovable), or Workflow C (Figma/Penpot manual design). END TURN until answered.
   - If an artifact would be invented (missing spec, missing stack lock, missing intake answer), **STOP AND ASK** — never proceed on a guess.
   - **M06 development is NOT chained**: implement **one TODO task per turn** → run its `Verify` → report Evidence → 🛑 **END TURN**. The human approves before `[x]` and before the next task. Never a whole sprint in one turn; batch only when the user names the task IDs. `[x]` is the human's mark, not the agent's.
4. **Cross-document consistency**: verify downstream docs against upstream ones (Scope → Sitemap → PRD/FSD → Schema → Code).
5. **YAGNI**: no features/components beyond what the scope asks. No unpaid work without a CR.
6. **Security**: never ask the user to paste secrets in chat — have them write to `.env.local`; verify the file exists without reading it.
7. **Research evidence**: primary research data must come from real users. If none yet, mark `PENDING_PRIMARY_RESEARCH` — never fabricate.
8. **Language**: reply and produce deliverables in **English** by default; switch languages only if the user explicitly asks. Indonesian commercial/regulatory context (SOW/SPK, DP milestones, BAST, UU PDP, e-Meterai, PPN, QRIS/Midtrans/Xendit) is natively supported.

## Harness root (9 files) — client / non-Small projects only

AGENTS.md, CONTEXT.md, ARCHITECTURE.md, DESIGN.md, CONVENTIONS.md, TODO.md, .env.example, RUNBOOK_LOCAL.md, VERIFY_LOCAL.md → stage in `docs/harness-root/`, copy to root **after** scaffold completes, verify, then delete staging. The **Small** path skips the 9-file harness — root `AGENTS.md` + `TODO.md` suffice.

## Scripts

`./scripts/gates/validate-gate.sh <MODULE>` · `./scripts/scaffold/init-project.sh <dir> <scale>` · `./scripts/scaffold/template-picker.sh` · see `scripts/` for more.
