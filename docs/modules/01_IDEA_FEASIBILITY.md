# Module 01: Idea & Feasibility (Idea Screening & Feasibility Testing)

> **Template**: `templates/01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md` → `docs/pm/IDEA_BRIEF.md` (alias `FEASIBILITY_REPORT.md`; if both exist the gate scores the one with more `Feasibility-Score-*` lines, so a stub cannot shadow a filled report).
> 📖 **Optional refs** (do NOT preload): `references/checklists/FEASIBILITY_CRITERIA.md`, `references/checklists/MODULE_01_ACTION_ITEMS_CHECKLIST.md`.

**Purpose**: first gate — turn a raw idea into a **Validated Idea Brief** with scale boundaries before heavy documents or code. Follows M00; entry point for **Solo SaaS and client fixed-scope** work. The **Small** path WAIVES M01 (Intake + `PROJECT_LITE.md` replace it — see SKILL.md's router), though the classifier below still runs.

---

## 1. Execution Rules

### Step 0 — Premise Testing & M00 Inheritance
- If M00 ran: inherit TAM/SAM/SOM, competitor matrix, personas — do NOT redo; focus on technical triage.
- Log unproven premises with confidence tags (✅/🔶/❓) and kill thresholds.
- **Provisional Gate Rule**: if M00 is `PENDING_PRIMARY_RESEARCH`, write `Feasibility-Decision: PROVISIONAL_PENDING_M00` — no final GO. The gate returns a distinct non-terminal verdict (**exit 4**); do not chain onward until the M00 research is done and the gate re-runs green.
- **Solo-capacity classifier runs at EVERY scale**, Small included: it derives the tier from the Intake fields, *not* the declared `Scale:` line, so if the two disagree (e.g. `Scale: small` + a payment webhook) the gate fails on the High-Water-Mark rule. Set `Scale:` to its verdict.

### Step 1 — 3-Filter Triage
- **Classification & Live Benchmark Search**: archetype acronym + scale tier in the `IDEA_BRIEF.md` header, written `ACRONYM — long name` (e.g. `POS — Point of Sale`); summary table: `deep-dives/01_IDEA_FEASIBILITY.md` §0. Never load `references/taxonomy/`. **MANDATORY**: Before drafting the core user loop or MVP features, execute **`web_search`** against leading live products in that archetype to discover table-stakes features, standard layout patterns, and modern expectations. Apply **BOTEC back-of-the-envelope capacity sizing** ([`references/architecture/BACK_OF_THE_ENVELOPE_CAPACITY_PLAYBOOK.md`](../../references/architecture/BACK_OF_THE_ENVELOPE_CAPACITY_PLAYBOOK.md)) to translate vague traffic expectations into realistic QPS and storage constraints before scoping infra. Do NOT invent archetype feature-sets from stale training data.
- **Problem filter**: who, how often, measurable loss today? Don't build if a sheet solves 80%.
- **Data quality standards**: disclose sample size & split (N, interviews vs survey), recruitment bias, question formulation (only pricing-commitment questions count as WTP), loss-verification sample. Full procedure: deep-dive §1.
- **Competitor benchmark** (skip if inheriting M00): 5–7 competitors across direct/adjacent/manual. If ≥2 competitors already provide a claimed-unique feature, the claim is FALSE — reframe it.
- **Core user loop**: `[Trigger] → [System mutation] → [Value/record locked]`.
- **MVP Razor**: with ONE capability, which justifies switching? Cut the rest.
- **Anti-contradiction checks**: zero ghost features; inventory parity with M02/M04; no dual-status features; profit-label alignment (Gross vs Net Profit).

### Step 2 — MVP Razor & Root Cause Validation Gate (MANDATORY)
- 80/20 breakdown of the problem metric; MVP Razor must target the ~80% primary root cause (≥70% resolution) or it is REJECTED.
- Segment-feature fit: drop personas who need out-of-scope features for core value (or upgrade the feature to P0).

### Step 3 — 4-Dimension Feasibility & Dimension Floor
Score each dimension **1.0–5.0** with a confidence tag, written on its own line with the exact machine field name the gate reads: `Feasibility-Score-Technical` (solo-buildable, boring stack) · `Feasibility-Score-Operational` (bandwidth) · `Feasibility-Score-Regulatory` (UU PDP, licensing, disclaimers) · `Feasibility-Score-Financial` (WTP ≥ cost to serve, unit economics).
Full per-dimension rubric — CRUD/offline caps, the epic-sum bandwidth formula, UU PDP duties, client-vs-SaaS unit economics: `deep-dives/01_IDEA_FEASIBILITY.md` §1–3. Load it when a score is not obvious; the two hard rules are:
- **Offline mutation + real-time sync caps `Technical` at 3/5** — ship a deferral mitigation or lower the claim. Ledgers use append-only deltas (never LWW) with UUIDv7 ordering (never client wall-clock).
- **Technical Spike / POC Protocol**: When validating novel APIs, third-party services, or unfamiliar libraries before scoring `Technical`, execute a time-boxed technical spike (1–2 days max) inside `spike/` to produce a throwaway proof of concept. Never assign a score ≥4/5 based on unverified assumptions or marketing claims.
- **Build vs Buy Triage & 40-Hour Commodity Rule**: Differentiate Core Differentiators (must BUILD) from Commodity Utilities (must BUY/ADOPT). If a non-core commodity component (auth, transactional email, file uploads, billing portal, cron scheduler) requires >40 hours of solo development time but can be served by a battle-tested third-party service/library with generous free tiers, custom building is strictly prohibited for MVP scope.
- **External Approval Lead-Time & Unblocking Fallback**: Any third-party integration requiring external identity/business verification or manual review with lead-time ≥7 business days (e.g. Meta WhatsApp Cloud API, Payment Gateway Live KYC, Apple Developer enrollment) MUST either initiate verification during M01/M02 or define an operational fallback (e.g. transactional email or manual bank transfer confirmation) so MVP launch is never held hostage by external platform bureaucracy.
- **Timeline = epic sum × 1.2 + non-dev overhead** (Small +1 wk, Medium +3–4 wk, Large +6–7 wk); >20% mismatch → revise the timeline up, not the score.

**Dimension Floor Decision** (declare the winner on a single line as `Feasibility-Decision: GO | CONDITIONAL_GO | PIVOT | KILL | PROVISIONAL_PENDING_M00`):
`GO` = avg ≥3.5, no dim <3.0 → M02 · `CONDITIONAL_GO` = avg 3.0–3.49 (or ≥3.5 with an accepted risk), no dim <3.0 → requires a `Mitigation:` line, then M02 · `PIVOT` = avg <3.0 OR any dim = 2.0 → restructure, halt · `KILL` = avg <2.5 OR any dim = 1.0 → terminate, archive. Any ❓ Unvalidated dimension → **PROVISIONAL_PENDING_M00**.
The gate reconciles both directions: `GO` at avg <3.5 fails; `CONDITIONAL_GO` without a `Mitigation:` line fails.

### Step 4 — Post-Development Kill/Pivot Criteria
**Kill**: velocity <30% of milestone scope after 4 wks · ≥50% beta testers wouldn't use it free · COGS/user >50% ARPU · regulatory dead-end. **Pivot**: beta churn >50%/30d · timeline slip >30% · sync corruption → online-first · price war → niche repositioning. Review at M06 Week 4 & 8 and M07 beta week 2 (Small: M06 Day 10).

### Step 5 — Scale Classification (High-Water Mark) & Routing
P0-only counting; highest single dimension tier wins. Small (1–5 P0, <4wk) → `PROJECT_LITE.md`. Solo SaaS (6–15 P0, billing) → M00-lite first, skips M03/M11. Client Medium (6–15 P0, contract, 1 PIC) → M03 SOW+DP mandatory. Large (16–25 P0, migration) → full PRD/FSD/M08, solo under a signed `docs/pm/SOLO-CAPACITY-RISK-ACCEPTANCE.md` (classifier exit 5). Enterprise (>25 P0, explicit non-delegable formal assurance, or legacy-core) → **no solo coding, A-Series**. Baseline privacy duties (including UU PDP) alone do not trigger Enterprise. Routing/timelines: `references/playbooks/SCALE_WORKFLOWS.md`.

Post-gate (`GO`/`CONDITIONAL_GO`, carrying its `Mitigation:`), using the shipped templates: `docs/pm/RISK_REGISTER.md` (`RISK_REGISTER_TEMPLATE.md`; mitigate ≥6, also accepted as M03's risk artefact) · `docs/pm/BACKLOG.md` (`BACKLOG_TEMPLATE.md`; RICE) · `docs/pm/OKR.md` (`OKR_TEMPLATE.md`). Roadmap, milestones, resource allocation (70-20-10) → `PROJECT_STATE.md` §1–§2.

---

## 2. Output Artifacts

All in **`docs/pm/`**: **`IDEA_BRIEF.md`** (archetype header, pitch, core loop, features, 4D scorecard + confidence tags, scale classification, kill/pivot criteria) and **`PROJECT_STATE.md`** (scores, gate decision, assumptions, next path + the Intake answers).

---

## Gate Exit Protocol

M01 is **not** a stop point: after the brief passes the gate, chain into Module 02 (stops are governed by SKILL.md rule 3). Pause only on `PIVOT`, `KILL`, `PROVISIONAL_PENDING_M00`.

**Self-verification checklist**:
- [ ] Pitch, 3-step core loop, archetype classification present
- [ ] 4D scorecard numeric, all dims ≥3.0, confidence tags on every score
- [ ] `Feasibility-Decision: GO | CONDITIONAL_GO | PIVOT | KILL | PROVISIONAL_PENDING_M00` declared (avg <3.5 → CONDITIONAL_GO **with a `Mitigation:` line**)
- [ ] `Scale:` matches the classifier's `Evaluated Scale` (the declared line never overrides the High-Water Mark)
- [ ] Root-cause match ≥70%; segments addressable by MVP features
- [ ] Epic-sum + 20% buffer + overhead consistent with the timeline (±20%)
- [ ] Legal compliance planned; commercial model uses discounted intent + COGS benchmarks
- [ ] Assumption register with kill thresholds; 5–7 competitors, uniqueness checked
- [ ] `PROJECT_STATE.md` updated; all 8 Intake fields answered (`Intake-Status: ANSWERED`)

**Gate verification (MANDATORY)**: paste the raw output of `./scripts/gates/validate-gate.sh M01`. Exit 0 = passed · 1 = incomplete, fix and re-run · 4 = `PROVISIONAL_PENDING_M00` (M00 research outstanding — not passed, do not chain onward).

**Report & continue**: present pitch, core loop, scorecard and scale. GO/CONDITIONAL_GO → proceed to M02 (CONDITIONAL_GO carries its mitigation plan). PIVOT/KILL/PROVISIONAL → halt and ask the matching question (restructure vs M00 / archive post-mortem / proceed with interviews).
