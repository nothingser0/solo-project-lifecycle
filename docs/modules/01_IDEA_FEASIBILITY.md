# Module 01: Idea & Feasibility (Idea Screening & Feasibility Testing)

> **Template to copy**: `templates/01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md`
> 📖 **Optional ref**: `references/checklists/FEASIBILITY_CRITERIA.md` (do NOT preload)

> **Feasibility scoring (inline — no need to open FEASIBILITY_CRITERIA)**: score 0–25 per dimension, ≥70/100 total to pass. Dimensions: **Market** (real pain, reachable users) · **Technical** (solo-buildable in capacity, boring stack) · **Economic** (WTP ≥ cost to serve) · **Operational** (maintainable by one person). Any dimension below its floor = CONDITIONAL GO at best; 0 fatal blockers required.

**Purpose**: first gate — turn a raw idea into a **Validated Idea Brief** with scale boundaries before heavy documents or code. Entry point for client fixed-scope/Small fast-track; follows M00 otherwise.

---

## 1. Execution Rules

### Step 0 — Premise Testing & M00 Inheritance
- If M00 ran: inherit TAM/SAM/SOM, competitor matrix, personas — do NOT redo; focus on technical triage.
- Log unproven premises with confidence tags (✅/🔶/❓) and kill thresholds.
- **Provisional Gate Rule**: if M00 is `PENDING_PRIMARY_RESEARCH`, score provisionally but hold gate as `PROVISIONAL_PENDING_M00` — no final GO.

### Step 1 — 3-Filter Triage
- **Classification**: archetype acronym + scale tier, recorded in the `IDEA_BRIEF.md` header. Use the shorthand below; do NOT load the full catalogs (`references/taxonomy/` is human reference only — SKILL.md forbids default loading).

**Common archetype shorthand** (extend freely; acronym + short description is enough):
```
ERP  Enterprise Resource Planning      POS  Point of Sale           LMS  Learning Management
CRM  Customer Relationship Mgmt        IMS  Inventory Management     ATS  Applicant Tracking
CMS  Content Management                WMS  Warehouse Management     HRIS Human Resource Info System
SaaS Multi-tenant Subscription App     OMS  Order Management         TMS  Transportation Mgmt
EIS  Executive Info Dashboard          FSM  Field Service Mgmt       DSS  Decision Support
GRC  Governance/Risk/Compliance        PIM  Product Info Mgmt        DMS  Document Management
```
- **Problem filter**: who, how often, measurable loss today? Don't build if a sheet solves 80%.
- **Data quality standards**: disclose sample size & split (N, interviews vs survey), recruitment bias, question formulation (only pricing-commitment questions count as WTP), loss-verification sample.
- **Competitor benchmark** (skip if inheriting M00): 5–7 competitors across direct/adjacent/manual; pricing, feature matrix (5–8), moat, weaknesses, offline audit, market boundary. If ≥2 competitors already provide a claimed-unique feature, the claim is FALSE — reframe it.
- **Core user loop**: `[Trigger] → [System mutation] → [Value/record locked]`.
- **MVP Razor**: with ONE capability, which justifies switching? Cut the rest.
- **Anti-contradiction checks**: zero ghost features; inventory parity with M02/M04; no dual-status features; profit-label alignment (Gross vs Net Profit per expense scope).

### Step 2 — MVP Razor & Root Cause Validation Gate (MANDATORY)
- 80/20 breakdown of the problem metric; MVP Razor must target the ~80% primary root cause (≥70% resolution) or it is REJECTED.
- Segment-feature fit: drop personas who need out-of-scope features for core value (or upgrade the feature to P0).

### Step 3 — 4-Dimension Feasibility & Dimension Floor
Score 1.0–5.0 with confidence tags; apply floors conservatively.
- **Technical**: 5/5 plain CRUD; 4/5 one modern pattern (real-time OR offline-async sync OR cached PWA); 3/5 combined real-time + offline multi-master sync, complex RLS, Safari ITP eviction, free-tier BaaS in production; ≤2/5 custom ML/crypto/hardware. **Offline mutation + real-time sync caps at 3/5** — requires deferral mitigation. Ledgers use append-only deltas (never LWW) and UUIDv7 ordering (never client wall-clock).
- **Bandwidth**: timeline = epic sum × 1.2 buffer + non-dev overhead (Small +1 wk, Medium +3–4 wk, Large +6–7 wk); >20% mismatch → revise timeline up.
- **Regulatory (UU PDP)**: Privacy Policy, ToS, DPA, 72-hour breach notification mandatory; explicit financial/tax disclaimers; no "audit-ready/compliant" claims without substantiation. 5/5 = zero personal data → 1/5 = licensing violation.
- **Commercial** (pick delivery model): Client/fixed-price → margin & effective hourly yield (≥Rp 100–250k/jam; DP ≥50% via M03). SaaS → intent discount ×0.15–0.25, COGS 10–20% of ARPU, churn 30–50%/yr (lifetime 12–18 mo), LTV:CAC ≥3:1, break-even vs fixed overhead (~Rp 1.0–1.2M/mo).

**Dimension Floor Decision**: GO = avg ≥3.5, no dim <3.0 → M02 after approval · CONDITIONAL GO = avg 3.0–3.49, no dim <3.0 → mitigation plan for 3.0 dims · PIVOT = avg <3.0 OR any dim = 2.0 → restructure, halt · KILL = avg <2.5 OR any dim = 1.0 → terminate, archive. Any ❓ Unvalidated dimension → **PROVISIONAL**.

### Step 4 — Post-Development Kill/Pivot Criteria
- **Kill**: velocity <30% of milestone scope after 4 wks; ≥50% beta testers wouldn't use it free; COGS/user >50% ARPU; regulatory dead-end.
- **Pivot**: beta churn >50%/30d; timeline slip >30%; sync corruption → online-first; price war → niche repositioning.
- Review at M06 Week 4 & 8, and M07 beta week 2 (Small: M06 Day 10).

### Step 5 — Scale Classification (High-Water Mark) & Routing
P0-only counting; highest single dimension tier wins. Small (3–7 P0, <4wk) → `PROJECT_LITE.md`. Solo SaaS (8–15 P0, billing) → M00-lite first, skips M03/M11. Client Medium (8–15 P0, contract, 1 PIC) → M03 SOW+DP mandatory. Large (16–25 P0, migration) → full PRD/FSD/M08. Enterprise (>25 P0 or statutory) → **no solo coding; A-Series**. Routing/timelines: `references/playbooks/SCALE_WORKFLOWS.md`.

Post-gate (GO only): roadmap, milestones, backlog (RICE), OKR/KPI, risk register (mitigate ≥6), resource allocation (70-20-10).

---

## 2. Output Artifacts

All in **`docs/pm/`**:
1. **`docs/pm/IDEA_BRIEF.md`** — archetype/catalog header, pitch, core loop, features, 4D scorecard + confidence tags, scale classification, kill/pivot criteria.
2. **`docs/pm/PROJECT_STATE.md`** — scores, gate decision, assumptions, next path.

---

## Gate Exit Protocol

M01 is **not** a stop point: after the brief passes the gate, chain into Module 02 (stops are governed by SKILL.md rule 3). Pause only on `PIVOT`, `KILL`, `PROVISIONAL_PENDING_M00`.

**Self-verification checklist**:
- [ ] Pitch, 3-step core loop, archetype/catalog classification present
- [ ] 4D scorecard numeric, all dims ≥3.0 for GO/CONDITIONAL_GO; confidence tags on every score
- [ ] Explicit `Feasibility-Decision: GO | CONDITIONAL_GO | PIVOT | KILL` declared (avg <3.5 must be CONDITIONAL_GO)
- [ ] Root-cause match ≥70%; segments addressable by MVP features
- [ ] Epic-sum + 20% buffer + overhead consistent with timeline (±20%)
- [ ] Legal compliance planned; commercial model uses discounted intent + COGS benchmarks
- [ ] Assumption register with kill thresholds; 5–7 competitors, uniqueness checked
- [ ] `docs/pm/PROJECT_STATE.md` updated; Intake Gate fields answered (`Intake-Status: ANSWERED`)

**Gate verification (MANDATORY)**:

```
[PASTE RAW OUTPUT OF: ./scripts/gates/validate-gate.sh M01]
```

**MANDATORY**: Execute `./scripts/gates/validate-gate.sh M01` (or `.ps1`). Exit 1 = incomplete; fix and re-run before declaring completion.

**Report & continue**: present pitch, core loop, scorecard and scale. GO/CONDITIONAL_GO → proceed to M02 (CONDITIONAL_GO carries its mitigation plan). PIVOT/KILL/PROVISIONAL → halt and ask the matching question (restructure vs M00 / archive post-mortem / proceed with interviews).
