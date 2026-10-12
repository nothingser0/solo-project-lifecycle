# M00 Deep Dive: Product Discovery & Strategy — Extended Material

## Contents

- [1. TAM/SAM/SOM Worked Example (Accounting SaaS, Indonesian MSMEs)](#1-tamsamsom-worked-example-accounting-saas-indonesian-msmes)
- [2. Regulatory Landscape Checklist (Indonesia)](#2-regulatory-landscape-checklist-indonesia)
- [3. Competitor Testing Protocol](#3-competitor-testing-protocol)
- [4. User Research Instruments](#4-user-research-instruments)
- [5. Product Strategy Details](#5-product-strategy-details)
- [6. Unit Economics & Kill Criteria](#6-unit-economics-kill-criteria)


Companion to [`../00_PRODUCT_DISCOVERY_STRATEGY.md`](../00_PRODUCT_DISCOVERY_STRATEGY.md). Reference links: `references/technical/DEEP_RESEARCH_METHODOLOGY.md`, `references/pre-sales/DISCOVERY_CALL_CHECKLIST.md`, `PROPOSAL_DECK.md`, `templates/00-pre-sales-enterprise/POC_PLAN_TEMPLATE.md`.

## 1. TAM/SAM/SOM Worked Example (Accounting SaaS, Indonesian MSMEs)

⚠️ Naive top-down TAM (64M MSMEs × Rp 1.2M = Rp 76.8T) is a **VANITY TAM**. Model a segmented funnel with Assumption IDs:

```python
total_msmes = 64_000_000                      # [ASM-MKT-01] Total MSMEs (BPS, Kemenkop)
retail_services_segment = total_msmes * 0.15  # [ASM-MKT-02] Inventory/cashier need (~9.6M)
digitalized_with_devices = retail_services_segment * 0.12  # [ASM-MKT-03] PC/smartphone + connectivity (~1.15M)
willing_to_pay_saas = digitalized_with_devices * 0.08      # [ASM-MKT-04] Active software budget (~92,000)

arpu_tahunan = 1_200_000                      # Rp 100,000/month × 12
SAM = willing_to_pay_saas * arpu_tahunan      # Rp 110.4 B (realistic serviceable market)

target_capture_rate = 0.005                   # 0.5% of SAM in Year 1 (≈460 paying stores)
SOM_tahun_1 = SAM * target_capture_rate       # Rp 552 M/year (≈ Rp 46M MRR)
```

**Validation methods**: Top-Down (industry reports → segment filter); Bottom-Up (smallest unit economics, e.g., Jakarta restaurants × avg POS spend).

**Market sizing frameworks**:
| Framework | When | Example |
|---|---|---|
| Substitution Analysis | Replaces existing solution | "How many pay for manual notary legalization?" |
| Proxy Metrics | No direct data | 120M e-commerce users × 15% custom goods = 18M prospects |
| Value-Based Sizing | B2B SaaS with ROI | Saves 10 h/wk admin (Rp 5M/mo salary) → WTP Rp 1–2M/mo |

**Trend analysis sources**: Google Trends, McKinsey/BCG Indonesia, DailySocial.id, Katadata. Check: growth >10% YoY? adoption-curve position (early adopter vs late majority)? macro tailwinds (UU PDP, post-pandemic shifts, subsidies)?

## 2. Regulatory Landscape Checklist (Indonesia)

| Domain | Regulation | Action |
|---|---|---|
| Private PSE | Permen Kominfo 5/2020 jo. 10/2021 (Komdigi) | PSE registration via oss.go.id before commercial go-live |
| Taxation | UU HPP 7/2021, PMK 60/2022 | 11% VAT in pricing; PPh Final 0.5% (PP 55/2022 jo. PP 20/2026) for qualifying MSMEs |
| Legality/KBLI | NIB via OSS-RBA (62019, 62029, 63122) | NIB for corporate bank accounts & payment gateways |
| Trademark | Law 20/2016 (DJKI) | Query pdki-indonesia.dgip.go.id before naming |
| Data Protection | UU PDP 27/2022 | Consent clause, encryption transit/at-rest, right to erasure |
| Fintech/Payments | OJK & BI (PBI 22/23/PBI/2020, QRIS, POJK 10/2022) | **Never hold user funds**; use licensed gateways (Midtrans/Xendit) |
| Healthtech | MoH: SIP, electronic medical records, Izin Edar Alkes | SATUSEHAT integration if touching rekam medis |
| E-signature | Komdigi PSrE (Privy/Vida) | Certified PSrE API for statutory evidentiary weight |

## 3. Competitor Testing Protocol

**Mandatory hands-on rule**: install & test the actual product (free tier/trial/app) — not marketing pages or reviews. Record onboarding time, checkout friction, mobile performance. Always check free/government alternatives (BI SIAPIK, DJP e-Faktur, Google Sheets templates). Every price needs verified date + direct URL.

```bash
# Discovery operators
"<problem keyword> software site:id"
"<problem keyword> Indonesia pricing"
intitle:"<competitor name> review"
# App stores
https://play.google.com/store/search?q=<keyword>&c=apps&gl=ID
https://apps.apple.com/id/search?term=<keyword>
# Plus ProductHunt / Indie Hackers for global startups
```

**Feature matrix template**:
| Feature | Comp A | Comp B | Comp C | Us |
|---|---|---|---|---|
| Real-Time Analytics Dashboard | ✅ | ❌ | ✅ | ✅ |
| Export Reports to Excel | ✅ | ✅ | ❌ | ✅ |
| WhatsApp Notifications | ❌ | ❌ | ✅ | ✅ |
| Mobile App | ✅ | ❌ | ✅ | ⏳ Phase 2 |
| Multi-User RBAC | ❌ | ✅ | ✅ | ✅ |

Gap analysis: features no competitor offers that interviews show users need.

**Pricing models**: Freemium; Tiered (Rp 99k/299k/999k); Per-seat (Rp 50k/user); Usage-based (Rp 5/tx). Anchors: low-end disruption (30–50% cheaper — risk of cheap perception) or premium (+20–30% with clear differentiator).

**SWOT example — Competitor A (large incumbent)**: Strengths: brand, integrations, 24/7 support. Weaknesses: legacy UI, expensive, no mobile. Opportunities: they ignore MSME segment. Threats: can pivot fast with capital.

**Positioning map**:
```
High Price
      │
   [A]│     [C]
      │
──────┼──────────► Complexity (Simple → Advanced)
      │
   [B]│  [Your Product]
Low Price
```

## 4. User Research Instruments

**Respondent groups**: A = End-users/daily operators (friction, workarounds); B = Economic buyers (budget, WTP, ROI); C = Ecosystem stakeholders (compliance, integrations).

**5-Act interview structure** (30–45 min): 1) Warm-up + recording permission (5'); 2) Current state: tools, time (10'); 3) Pain points + failure impact (10'); 4) Desired future / must-haves (10'); 5) WTP budget (5').

**Mandatory JTBD questions**:
- "When using [solution], what job are you trying to get done?"
- "What prompted switching from manual to software (or vice versa)?"
- "If your software disappeared tomorrow, what would you do?"

**Red flags**: no real problem (just chatting); wants free only; "all features important" without priorities.

**Sample size thresholds**: Standard/Enterprise ≥50 (30% intent = ≥15 people); Medium/B2B ≥30 (≥9); Solo SaaS/M00-lite ≥5 in-depth interviews + behavioral test (waitlist/pre-orders) OR ≥30 survey respondents.

**Behavioral intent validation** (stated intent is weak): landing-page waitlist ≥5% of ≥100 targeted visits; ≥5 refundable pre-order deposits before backend code; ≥2 signed B2B LOIs.

**Survey structure**: Part 1 Screener (frequency disqualifiers) → Part 2 Pain severity Likert 1–5 → Part 3 Van Westendorp (too cheap / cheap / expensive / too expensive) → Part 4 Intent-to-buy tiers. Gate: ≥30% "Definitely/Probably buy" or waitlist ≥5%.

**Confidence legend**: ✅ VERIFIED (empirical, cited with date & URL) · 🔶 ASSUMPTION (register & test) · ❓ UNKNOWN (discovery gap).

**Persona template fields**: demographics, tech savviness, Jobs-to-be-Done, ranked pain points with quantified impact (e.g., "stock discrepancy = Rp 5–10M/mo losses"), current workaround, WTP range, objections. Example: Budi, 32, retail chain manager (5 branches), critical pain = physical-vs-record discrepancies; WTP Rp 200k–500k/mo.

**Journey map (5 stages)**: Awareness → Consideration → Purchase/Signup → Onboarding (aha moment) → Retention/Advocacy. Annotate pain level + opportunity per stage (e.g., "setup takes 2 h → build 1-click Excel import wizard").

**Pain prioritization (Impact × Effort)**: stock discrepancy = high impact → MVP; manual reporting 4 h/wk → MVP; dark mode → later; accounting integration → Phase 2.

## 5. Product Strategy Details

**Vision formula**: `[Target User] + [Transformed Future State] + [Societal Impact]`. Quality test: inspiring, aspirational (3–5 yrs), not generic. Example: "trusted inventory platform for 100,000 Indonesian retail MSMEs…".

**Mission formula**: `[What We Do] + [For Whom] + [How Differently]`. Test: actionable, specific, differentiated.

**North Star Metric**: define formula, rationale (leading revenue indicator, reflects user value, actionable), initial target (baseline → Month-6 target), breakdown tree (Acquisition / Activation / Engagement / Retention). Anti-patterns: "total registered users" (vanity), "time in app" (confusion ≠ value). Example NSM: "Tracked Stock Transactions per Week", target 500 → 2,000/wk/user.

**Value Proposition Canvas**: Customer profile (Jobs / Pains / Gains) ↔ Value map (Products & Services / Pain Relievers / Gain Creators). Example: pain "branch staff forget updates" → reliever "auto-sync every transaction"; gain "avoid stockouts" → creator "low-stock alerts".

**Strategic pillars template** (3–5): definition, key initiatives (6–12 mo), success criteria. Example: Pillar 1 Reliability & Offline-First (≥95% syncs without loss); Pillar 2 Ease of Use (≥80% first transaction within 10 min); Pillar 3 Actionable Insights (≥50% weekly insight usage).

## 6. Unit Economics & Kill Criteria

- Target price, CAC, LTV = ARPU × lifespan; gateway fees (QRIS 0.7%, VA Rp 2–4k/tx, card 2.9% + Rp 2k); PPN 11% + PPh Final 0.5%; gross margin ≥70%.
- **Kill criteria**: 1) Market: intent <30% AND waitlist <2% of 200 visitors. 2) Economic: CAC > LTV/3 after initial marketing tests. 3) Solo feasibility: architecture requires real-time multi-master offline sync or custom banking protocols beyond one developer.
- Waitlist banding: ≥5.0% PASS; 2.0–4.9% one 7-day copy/value-prop sprint then re-test; <2.0% KILL.
