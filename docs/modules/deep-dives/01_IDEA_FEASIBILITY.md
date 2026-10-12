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
