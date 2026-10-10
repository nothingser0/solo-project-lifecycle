# Idea Brief & Feasibility Scorecard

> Initial idea screening document to validate technical, operational, and commercial feasibility prior to formal specification design.

---

## 1. Project Metadata
- **Idea Name / Project Codename**: [Example: AutoLegalDoc / VaultSign]
- **Initiator / Solo Dev**: [Your Name]
- **Evaluation Date**: [YYYY-MM-DD]
- **Initial Target Scale**: [Small (MVP) / Medium (SaaS) / Large / Enterprise]
- **Delivery Model**: [Bespoke Freelance / On-Premise / Academic / Proprietary Internal / Open-Source / Commercial SaaS]
- **Monetization Model**: [Fixed Contract Price / One-Time License / Free & Non-Commercial / Recurring Subscription / Waived]
- **Industry Archetype**: [Acronym] - [Full Archetype Name] (from references/taxonomy/SYSTEM_ARCHETYPES_250.md)
- **Catalog Benchmark**: #[1-1000] - [Catalog Entry Name] (from references/taxonomy/PROJECT_CATALOG_1000.md)

---

## 2. Idea Summary (Elevator Pitch)
> **Formula Format**: For **[Target User]** who experience **[Specific Problem]**, **[Product Name]** is a **[Software Category]** solution that delivers **[Core Benefit / Unique Value]**, unlike manual/existing alternatives because **[Differentiating Advantage]**.

- **Elevator Pitch**:
  *[Write a 1–2 sentence summary following the formula above]*

---

## 3. The 3-Filter Triage & Market Validation

### 3.0 Premise Testing & Assumption Register (Riskiest Assumption First)
*Do not accept problem statements in the brief at face value. Catalog and test foundational premises first.*

| ID | Core Premise / Assumption | Risk Level (H/M/L) | Evidence Needed to Validate | Cheap Test Method (RAT) | Kill Threshold (Ambang Gugur) | Status |
|:---|:--------------------------|:------------------:|:----------------------------|:------------------------|:------------------------------|:-------|
| PREM-01 | [e.g., Problem is severe enough that users actively seek solutions] | High | Users already tried or paid for workarounds | 5 Discovery interviews | If 0/5 spend money or >2 hrs/wk on this | [Unproven / Tested / Disproven] |
| PREM-02 | [e.g., Target segment has authority to adopt & pay] | High | Budget authority confirmation from persona | Economic buyer interview (Group B) | No budget authority (<Rp 50k/mo) | [Unproven / Tested / Disproven] |
| PREM-03 | [e.g., Regulatory barriers allow 1 developer to build MVP legally] | High | Legal checklist & licensing research | Compliance audit in M00/M01 | Direct OJK/BI license required | [Unproven / Tested / Disproven] |

> ⚡ **RULE**: If any High-Risk premise hits its **Kill Threshold**, STOP or PIVOT immediately before proceeding to technical specifications or architecture design.

---

### 3.1 Problem Statement & Research Methodology
- **Primary Problem**: [Explain the user's biggest pain point today with concrete numbers]
- **Current Workarounds / Alternatives**: [How do they solve this problem now? Example: Manual Excel, expensive notary services, Google Drive templates]
- **Measurable Loss / Non-Resolution Impact**: [Quantified time or financial loss per month]
- **Research Methodology Disclosure**:
  - Sample Size ($N$): [e.g., N=52 total (10 interviews, 42 survey forms)]
  - Recruitment Channel: [e.g., Direct shop visits, WhatsApp merchant groups, organic search]
  - Potential Selection Bias: [e.g., Online forms over-index on tech-savvy business owners]
  - Pricing Question Formulation: [Must be pricing commitment question, e.g., "Would you pay Rp X/month?"]

### 3.2 Competitor Landscape Benchmark (5–7 Competitors)
*Benchmark across direct, adjacent, and manual workarounds to verify uniqueness.*

| No | Competitor Name | URL / Type | Pricing Tiers | Core Features | Offline Mode? | Target Segment | Weakness / Gaps |
|:--:| :--- | :--- | :--- | :--- | :---: | :--- | :--- |
| 1 | [Direct Comp 1] | Direct | [e.g., Free / Rp 50k/mo] | [...] | [Yes/No] | [Micro SMB] | [...] |
| 2 | [Direct Comp 2] | Direct | [...] | [...] | [Yes/No] | [...] | [...] |
| 3 | [Adjacent Comp 1] | Adjacent POS/ERP | [e.g., Rp 300k hardware] | [...] | [Yes/No] | [Mid Retail] | [...] |
| 4 | [Adjacent Comp 2] | Adjacent | [...] | [...] | [Yes/No] | [...] | [...] |
| 5 | [Manual Workaround 1]| Excel / Sheets | Free | Custom formulas | Yes | All | Error-prone, no audit |
| 6 | [Manual Workaround 2]| Paper Ledgers | Low | Notes, receipts | Yes | Micro | Discrepancy, lost data |
| 7 | [Manual / Substitute 3]| WhatsApp / Chat | Free | Ad-hoc text/voice notes | Yes | Micro | Lost messages, no structured records |

**Uniqueness Claim Verification**:
- Stated Differentiator: [e.g., Retail: "Inventory-centric bookkeeping without hardware at Rp 99k/mo"; CRM: "WhatsApp-native lead pipeline with automated SLA alerts"; CMS: "Headless Markdown publishing with live SEO diffing"]
- Claim Verification Status: [Verified Unique / Reframed (competitor X already provides Y)]

### 3.3 Core User Loop (3-Step Primary Flow)
1. **Step 1 (Input)**: [User Action / Trigger, e.g., Cashier scans barcode / types SKU]
2. **Step 2 (Process)**: [System Mutation, e.g., Retail: validates stock & decrements balance; CRM: recalculates pipeline & notifies team; CMS: renders preview & updates cache]
3. **Step 3 (Output / Value)**: [User Receives Value, e.g., Retail: receipt printed; CRM: deal stage locked & task assigned; CMS: article published live]

### 3.4 Extreme Scope Pruning (The MVP Razor)

| Features in First Release (In-Scope MVP) | Dropped / Deferred Features (Out-of-Scope) |
| :--- | :--- |
| • [Core Feature 1: Primary CRUD & Core Workflow] | • [Deferred: Advanced real-time multi-node sync (Phase 1.5)] |
| • [Core Feature 2: Audited status mutation / state history] | • [Deferred: AI recommendation / automated copilot (Phase 2)] |
| • [Core Feature 3: Essential reporting / basic document export]| • [Deferred: Multi-gateway billing / custom white-label (Phase 2)] |

### 3.5 MVP Razor & Root Cause Validation Gate (MANDATORY)
- **Root Cause Breakdown (80/20 Analysis)**:
  - Primary Root Causes ($\approx 80\%$): [Dominant bottleneck: e.g., Retail: unrecorded shrinkage; CRM: unassigned leads; CMS: manual review delay]
  - Secondary Root Causes ($\approx 20\%$): [Secondary friction: e.g., sync latency, notification formatting, cosmetic UI]
- **Solution-Problem Alignment**: Does MVP Razor solve $\ge 70\%$ of the primary root cause? `[YES / NO]`
  - *Mitigation if NO*: [Reframe MVP Razor to address dominant cause]
- **Target Segment Feasibility**:
  - [Segment 1: e.g., Primary Persona matching MVP scope] $\rightarrow$ Fits MVP model: `[YES]`
  - [Segment 2: e.g., Adjacent Persona requiring unbuilt complex feature] $\rightarrow$ `[NO - DROPPED FROM MVP OR UPGRADE FEATURE]`

---

## 4. Solo Developer Feasibility Scorecard (Stricter Reality Scoring)

*Rate each dimension from 1 (Very Poor / Unfeasible) to 5 (Excellent / Highly Feasible)*

| Feasibility Dimension | Score (1–5) | Confidence | Solo Developer Analysis, Reality Checks & Mitigations |
| :--- | :---: | :---: | :--- |
| **1. Technical Feasibility** (`Technical`) | [ ] / 5 | [✅/🔶/❓] | [CRUD vs Offline-write / async sync. Delta ledger vs LWW. Offline+Real-time capped at 3/5.] |
| **2. Bandwidth Feasibility — Solo Effort** (`Operational`) | [ ] / 5 | [✅/🔶/❓] | [Epic sum + 20% buffer + scale-adjusted non-dev overhead matches timeline claim within 20%?] |
| **3. Regulatory & Legal Feasibility** (`Regulatory`) | [ ] / 5 | [✅/🔶/❓] | [UU PDP compliance planned (Privacy Policy, ToS, DPA, Disclaimers). Zero unsubstantiated marketing claims.] |
| **4. Commercial Feasibility — Unit Economics** (`Financial`) | [ ] / 5 | [✅/🔶/❓] | [Pricing commitment discounted 15-25%? COGS 10-20% ARPU? Break-even modeled? LTV:CAC ≥3:1?] |
| **OVERALL AVERAGE SCORE** | **[ ] / 5** | — | *(Total score divided by 4; `GO` requires average ≥ 3.5, else use `CONDITIONAL_GO`)* |

### Machine Validation Summary (M01 Feasibility Scores & Decision)

```text
Feasibility-Score-Technical: [fill 1.0-5.0]
Feasibility-Score-Operational: [fill 1.0-5.0]
Feasibility-Score-Regulatory: [fill 1.0-5.0]
Feasibility-Score-Financial: [fill 1.0-5.0]
Feasibility-Decision: PENDING
```

*(Key mapping: `Operational` = Bandwidth Feasibility, `Financial` = Commercial Feasibility. Options: GO | CONDITIONAL_GO | PIVOT | KILL. Machine validator strictly rejects M01 if any dimension is missing, out of the 1.0-5.0 range, < 3.0, if `GO` is declared with average < 3.5, or if Feasibility-Decision is KILL/PIVOT).*

---

## 5. Technical & Bandwidth Cross-Check Details

### 5.1 Bandwidth Epic Breakdown Audit
- Total Must-Have Features: `[X]` features
- Raw Development Epic Sum: `[X]` weeks (CRUD: 3-5 days/feature, Complex: 1.5-2 weeks/feature)
- Buffered Development Weeks ($+20\%$): `[X]` weeks
- Non-Development Overhead (Small: 1w, Medium: 3-4w, Large: 6-7w): `[X]` weeks
- **Total Calculated Weeks**: `[X]` weeks (vs Initial Timeline Claim: `[Y]` weeks)
- Variance: `[Z]%` (Must be $\le 20\%$ or timeline claim must be adjusted)

### 5.2 Legal Compliance Checklist (UU PDP No. 27/2022)
- [ ] **Privacy Policy (Kebijakan Privasi)** planned (data collection, retention, deletion rights)
- [ ] **Terms of Service (Syarat & Ketentuan)** planned (liability limits, dispute resolution)
- [ ] **Data Processing Agreement (DPA)** planned for third-party cloud processors (Supabase/AWS)
- [ ] **Disclaimers**: Financial estimation / tax disclaimers formulated

### 5.3 Unit Economics Modeling
- Price / Subscription Tier: `Rp [X] / month`
- Modeled COGS ($10\%–20\%$ ARPU): `Rp [X] / month` (server, gateway 2%, SMS/WhatsApp, monitoring)
- Realistic Conversion Rate: Survey Pricing Commitment `[X]%` $\times [0.15, 0.25] =$ `[Y]%` (Midpoint: $\times 0.20$)
- Modeled Customer Lifetime: `[12–18]` months (accounting for SMB annual churn)
- Pre-Launch Estimated CAC: `Rp [X]` (Proxy: channel ad clicks / conversion or outreach cost)
- Fixed Monthly Overhead (DB $25, VPS $20, domain/email $10, APM $15): `Rp [X] / month`
- Break-Even Subscribers: $\frac{\text{Fixed Overhead}}{\text{ARPU} \times \text{Gross Margin \%}} =$ `[Z]` active paying subscribers
- Estimated LTV : CAC Ratio: `[X] : 1` (Target: $\ge 3:1$)

---

## 6. Post-Development Kill & Pivot Criteria

*Explicit thresholds reviewed at M06 Week 4 and Week 8:*

- **Kill Criteria (Halt Project)**:
  - Week 4 progress check: Working features $<30\%$ of planned milestone scope.
  - Beta testing: $\ge 50\%$ of closed-beta users reject product value.
  - Infrastructure cost: Unit hosting and third-party API COGS exceeds **50% of ARPU** (healthy baseline is 10-20%).
- **Pivot Criteria (Restructure Scope)**:
  - Beta churn $>50\%$ in 30 days $\rightarrow$ Prune scope to single core interaction loop.
  - Timeline slip $>30\%$ $\rightarrow$ Freeze secondary features, ship online-only MVP.
  - Data sync conflict issues $\rightarrow$ Pivot to online-first PWA with optimistic UI.

---

## 7. Assigned Scale Classification Parameters

- **Selected Scale**: `[Small / Medium / Large / Enterprise]`
- **Selection Rationale**: [Complexity, data privacy exposure, concurrency, multi-tenancy requirements]
- **Target Development Timeline**: [Realistic calendar weeks based on epic audit]

---

## 8. Next Steps for Module 02: Discovery & Scope
1. [Discovery Question 1: E.g., Specific table schema for audit trail logs]
2. [Discovery Question 2: E.g., Fallback behavior when user network connection drops]
3. [Discovery Question 3: E.g., Exact legal wording for financial estimation disclaimer]
