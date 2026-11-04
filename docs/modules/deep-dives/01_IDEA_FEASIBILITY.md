# M01 Deep Dive: Idea & Feasibility — Extended Material

## Contents

- [0. Archetype Shorthand](#0-archetype-shorthand)
- [1. Technical Feasibility Rubric (full)](#1-technical-feasibility-rubric-full)
- [2. Bandwidth Cross-Check (full procedure)](#2-bandwidth-cross-check-full-procedure)
- [3. Commercial Feasibility — Delivery Model Details](#3-commercial-feasibility-delivery-model-details)
- [4. Root-Cause Examples per Domain](#4-root-cause-examples-per-domain)
- [5. Timeline Estimation & Backlog Details](#5-timeline-estimation-backlog-details)
- [6. OKR, Risk & Resource Details](#6-okr-risk-resource-details)


Companion to [`../01_IDEA_FEASIBILITY.md`](../01_IDEA_FEASIBILITY.md). Reference links: `references/checklists/MODULE_01_ACTION_ITEMS_CHECKLIST.md`, `references/checklists/FEASIBILITY_CRITERIA.md`, `references/pm/PM_PRIORITIZATION_FRAMEWORKS.md`, `references/playbooks/SCALE_WORKFLOWS.md`.

## 0. Archetype Shorthand

Classification is written as `ACRONYM — long name`; extend freely (acronym + short description is enough):

```
ERP  Enterprise Resource Planning      POS  Point of Sale           LMS  Learning Management
CRM  Customer Relationship Mgmt        IMS  Inventory Management     ATS  Applicant Tracking
CMS  Content Management                WMS  Warehouse Management     HRIS Human Resource Info System
SaaS Multi-tenant Subscription App     OMS  Order Management         TMS  Transportation Mgmt
EIS  Executive Info Dashboard          FSM  Field Service Mgmt       DSS  Decision Support
GRC  Governance/Risk/Compliance        PIM  Product Info Mgmt        DMS  Document Management
```

The 250-entry archetype catalog and the 1,000-project catalog live in `references/taxonomy/` — human reference only, never agent context (SKILL.md forbids default loading).

## 1. Technical Feasibility Rubric (full)

- **5/5 (Excellent)**: standard CRUD, battle-tested REST, relational DB, standard auth, online-only. Zero custom R&D.
- **4/5 (Good)**: one modern pattern — real-time WebSockets (online-only) OR offline-first with async background sync (no distributed conflict resolution) OR read-only cached PWA. Well-documented SDKs.
- **3/5 (Moderate — red flag)**: combined high-concurrency real-time + bi-directional offline multi-master sync (LWW/CRDT); complex multi-tenant RLS with dynamic hierarchical permissions; mobile storage caveats (Safari iOS IndexedDB eviction); production on free-tier BaaS (Supabase free tier pauses after inactivity, no PITR).
- **2/5 (Challenging)**: custom ML training, audio/video transcoding, custom cryptographic protocols, hardware drivers.
- **1/5 (R&D)**: novel distributed algorithms, unproven academic architectures, hardware-software co-design.

**Offline & real-time traps (mandatory checks)**:
- Storage: **IndexedDB (Dexie.js / idb-keyval)** — never localStorage (5MB, synchronous, no indexed queries).
- Conflict resolution: financial ledgers & inventory use **append-only delta movements** (`stock_delta = -1`); never LWW (silently overwrites concurrent transactions). User profiles/preferences: LWW acceptable with monotonic sequence IDs or UUIDv7.
- Clock drift: never trust client wall-clock for global ledger ordering; UUIDv7 client sequence + authoritative server timestamps on sync ingestion.
- **Safari iOS ITP eviction (verified 2026)**: script-writable storage purged after 7 days of inactivity under storage pressure → server backup sync reminders + PWA install prompts.
- **BaaS free-tier traps (verified 2026)**: Supabase free tier pauses after 7 days inactivity, no point-in-time recovery → budget $25/mo paid tier in production.
- WebSocket concurrency: model connection limits across multi-tenant users.

**Complexity red-flag rules**: Offline mutation + real-time sync ⇒ cap 3/5; at 3/5 the brief MUST include explicit deferral mitigation (e.g., "defer offline sync to Phase 2; ship mobile-first online-only with reconnect retry"), restoring adjusted score to 4/5.

## 2. Bandwidth Cross-Check (full procedure)

1. Sum development epics: simple CRUD 3–5 working days; complex (payments, offline sync, approval engines) 1.5–2 weeks.
2. Apply 20% schedule buffer: `Buffered Dev Weeks = Sum of Epics × 1.2` (sprint-level 70-20-10 allocation does not double-count this).
3. Scale-adjusted non-dev overhead:
   - **Small**: Specs (M04/M05) 2–3 d + QA/security (M07-LITE) 1 d + deploy (M10) 1 d = **1 week**.
   - **Medium**: Discovery & specs (M01–M05) 2 wks + QA (M07) 1 wk + deploy (M10) 1 wk (M08 skipped) = **3–4 weeks**.
   - **Large/Enterprise**: Discovery (M00–M05) 3 wks + full QA/SIT (M07) 2 wks + migration (M08) 1 wk + deploy/BAST (M10/M11) 1 wk = **6–7 weeks**.
4. `Total Project Weeks = Buffered Dev Weeks + Scale-Adjusted Non-Dev Weeks`; part-time (<40 h/wk) × 1.2.
5. Validation: if epic math exceeds the timeline claim by >20% (e.g., claim 12 wks, math says 17), revise the claim up before proceeding.

## 3. Commercial Feasibility — Delivery Model Details

**Model A: Bespoke freelance / client / academic (fixed-price & milestone)**
- No recurring billing modeled (no ARPU/churn/gateway).
- `Net Profit Margin = (Contract Value − (Direct Tooling/Third-Party Costs + Hosting)) / Contract Value × 100%`
- `Real Hourly Yield = Net Project Profit / Total Estimated Dev Hours` — must exceed baseline opportunity cost (≥ Rp 100,000–250,000/jam).
- Payment safety gate: minimum 50% DP locked in M03 before development.

**Model B: Open-source / free utility / personal tool**
- Commercial defaults 5/5 if hosting/API costs ≤ Rp 150,000/mo within personal budget ceiling.
- Validate free-tier coverage: Cloudflare Pages, Turso, Supabase free tier, GitHub Pages vs expected traffic.

**Model C: On-premise / enterprise one-time license**
- License price vs hardware provisioning + custom deployment hours.
- Maintenance retainer target: 15–25% of initial license fee per year (bug fixes, OS compatibility).

**Model D: Subscription SaaS**
1. Intent-to-Buy discounting: `Realistic Conversion = Survey Pricing Commitment × [0.15, 0.25]` (midpoint ×0.20). Applies ONLY to pricing-commitment questions; passive interest converts <5%. Example: 59.6% commitment → 9.0–14.9% real conversion (≈11.9%).
2. COGS: hosting, DB compute, gateway fees (1.5–3.0% + fixed), SMS/WhatsApp OTP/email, monitoring. Benchmark 10–20% of ARPU, never <5%.
3. SMB churn: 30–50% annually (3–5% monthly); lifetime cap 12–18 months for LTV.
4. `LTV = ARPU × Lifetime (months) × Gross Margin %`; LTV:CAC — ≥5:1 highly viable, 3:1–5:1 acceptable solo MVP, <3:1 unviable.
5. CAC proxies: Paid = CPC / (Landing Conv% × Trial Conv%) — e.g., Rp 3,000/(0.05×0.20) = Rp 300,000. Organic = (outreach hours × opportunity cost)/converted accounts. B2B pilot = pilot onboarding cost/converted annual contracts.
6. Fixed overhead ≈ Rp 1.0–1.2M/mo (DB $25 + hosting $20 + domain/email $10 + monitoring $15). `Break-Even Subscribers = Fixed Monthly Overhead / (ARPU × Gross Margin%)` — e.g., Rp 1.2M / Rp 80k = 15 subscribers at Rp 100k ARPU, 80% margin.
7. Solo support capacity: max 50–100 active organizations without automated self-serve tooling.

## 4. Root-Cause Examples per Domain

- **Retail/Commerce**: 10–15% stock discrepancy → 80% unrecorded shrinkage & manual entry errors; 20% branch sync lag ⇒ P0 = stock adjustment audit trail, NOT multi-branch sync.
- **CRM/Sales**: 35% lead drop-off → 80% unassigned leads & >24h manual outreach ⇒ P0 = automated lead assignment + instant notifications, NOT AI scoring.
- **CMS/Publishing**: 4-day editorial bottleneck → 80% uncoordinated email review loops ⇒ P0 = in-app review & state approval workflow, NOT multi-region edge deployment.

## 5. Timeline Estimation & Backlog Details

- T-shirt sizing or story points; map critical dependencies (B needs A); flag external dependencies (API vendors, third-party approvals) as high risk.
- Milestones: M0 spike (wk 1, hardest-risk demo) → M1 Alpha (wk 4; Small: day 10, full core loop) → M2 Beta closed (wk 8; 3–5 real users, ≥2 complete workflows unaided) → M3 Public launch (wk 12–14; Small: wk 3–4). Scale mapping: Small wk 2–4, Medium wk 12–14, Large wk 18–25.
- Story points (Fibonacci): 1 = trivial (15 min) · 2 = simple CRUD/UI (1–2 h) · 3 = standard logic (half day) · 5 = complex integration (1 d) · 8 = very complex (2–3 d) · 13 = must split. RICE = (Reach × Impact × Confidence) / Effort (Effort in person-days for stories, person-weeks for epics). Impact: massive 3 / high 2 / medium 1 / low 0.5 / minimal 0.25; Confidence: high 100%, medium 80%, low 50%.
- Tools: Notion (status DB), Linear (cycles/roadmap), Productboard (RICE scoring).

## 6. OKR, Risk & Resource Details

- **OKR example**: O = "Launch MVP and validate PMF"; KR1 50 beta users by Q1; KR2 40% WAU retention by week 8; KR3 20 actionable feedback sessions. Every KR needs baseline, target, metric definition, data source. KPI dashboard categories: Acquisition, Activation, D1/D7/D30 + WAU, MRR/ARPU, API p95/error rate/uptime. RACI per metric.
- **Risk workshop categories**: Technical, Resource, Market, Legal/Compliance, Financial, Regulatory Policy Shift, Product Abuse & Fraud. L×I matrix — scores {1,2,3,4,6,9}: 6/9 mandatory mitigation before dev; 3/4 monitor + contingency; 1/2 accept, quarterly review. Example: "Midtrans down at launch" (2×3=6) → backup gateway Xendit week 6, failover tests, manual bank-transfer confirmation fallback; review 2 wks pre-launch. Cadence: weekly top-3 review, monthly re-assessment; any escalation to 6/9 triggers emergency session.
- **Resource allocation**: 70-20-10 (dev / planning / buffer) per epic — e.g., 2-wk auth epic = 7 d dev + 2 d planning + 1 d buffer. Skill-gap table (skill / current / target / path / investment); if learning >20% of timeline → simplify stack, hire freelancer, or extend timeline. External dependency tracker with 2–3 day status cadence for high/medium risk (e.g., WhatsApp Business API approval pending → fallback email notifications).

## Runbook Originals (moved 2026-11-04)

Original text verbatim, so no clause is lost when a condensed step is ambiguous.

```markdown
# Module 01: Idea & Feasibility (Idea Screening & Feasibility Testing)

> **Template**: `templates/01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md` → `docs/pm/IDEA_BRIEF.md` (alias `FEASIBILITY_REPORT.md`; if both exist the gate scores the one with more `Feasibility-Score-*` lines, so a stub cannot shadow a filled report).
> 📖 **Optional refs** (do NOT preload): `references/checklists/FEASIBILITY_CRITERIA.md`, `references/checklists/MODULE_01_ACTION_ITEMS_CHECKLIST.md`, `templates/01-discovery-commercial/WORKING_BACKWARDS_PR_FAQ_TEMPLATE.md` (pressure-test the value proposition), `templates/01-discovery-commercial/COMPETITIVE_ALTERNATIVE_PAGE_TEMPLATE.md`, `templates/01-discovery-commercial/B2B_COLD_OUTREACH_PLAYBOOK.md` (only when validating demand with real prospects).

**Purpose**: first gate — turn a raw idea into a **Validated Idea Brief** with scale boundaries before heavy documents or code. Follows M00; entry point for **Solo SaaS and client fixed-scope** work. The **Small** path WAIVES M01 (Intake + `PROJECT_LITE.md` replace it — see SKILL.md's router), though the classifier below still runs.

---

## 1. Execution Rules

### Step 0 — Premise Testing & M00 Inheritance
- If M00 ran: inherit TAM/SAM/SOM, competitor matrix, personas — do NOT redo; focus on technical triage.
- Continue the same assumption IDs and ledger started in M00; do not create a competing copy. Scan the idea across Value/desirability, Usability, Viability, Feasibility, Go-to-Market, and Team/operations; add Regulatory when the domain requires it. Tag each decision-critical premise with its risk lens, impact if false, uncertainty, and source. Rank impact and uncertainty High/Medium/Low in a 3×3 matrix; test High-High first, then break ties by decision impact and how quickly credible evidence can be obtained. Do not mistake the feasibility scorecard for an assumption register. Use `templates/01-discovery-commercial/ASSUMPTIONS_CONSTRAINTS_TEMPLATE.md` when the M00-lite artifact cannot carry that trail.
- **Probe selection and experiment design**: Choose the cheapest method that can produce evidence for the specific premise, not the method easiest to build. Use a time-boxed spike for technical/API unknowns, an observed task test for usability, real-user behavior or a pricing commitment for demand/viability, and synthetic simulation only for edge cases or data logic. A narrative prototype can test comprehension or stakeholder alignment, but does not establish customer demand. For each experiment, record the assumption ID, falsifiable hypothesis, target/sample and context, probe, timebox, success and failure thresholds, observed evidence, and resulting decision. Do not create a separate experiment register or treat a test artifact as evidence by itself. An inconclusive result stays open.
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
- **Pre-mortem**: Before finalizing the brief, imagine the project failed within 12 months. Record the three most plausible causes, an early observable warning for each, and the linked assumption or mitigation. Keep this separate from post-development kill thresholds; it is a discovery prompt, not evidence that failure is certain.

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

All in **`docs/pm/`**: **`IDEA_BRIEF.md`** (archetype header, pitch, core loop, assumption lenses and prioritized probes, pre-mortem, features, 4D scorecard + confidence tags, scale classification, kill/pivot criteria) and **`PROJECT_STATE.md`** (scores, gate decision, assumption links, next path + the Intake answers).

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
- [ ] Decision-critical assumptions tagged by risk lens and ranked; each planned experiment has a falsifiable threshold; pre-mortem's top causes link to assumptions or mitigations
- [ ] `PROJECT_STATE.md` updated; all 8 Intake fields answered (`Intake-Status: ANSWERED`)

**Gate verification (MANDATORY)**: paste the raw output of `./scripts/gates/validate-gate.sh M01`. Exit 0 = passed · 1 = incomplete, fix and re-run · 4 = `PROVISIONAL_PENDING_M00` (M00 research outstanding — not passed, do not chain onward).

**Report & continue**: present pitch, core loop, scorecard and scale. GO/CONDITIONAL_GO → proceed to M02 (CONDITIONAL_GO carries its mitigation plan). PIVOT/KILL/PROVISIONAL → halt and ask the matching question (restructure vs M00 / archive post-mortem / proceed with interviews).
```
