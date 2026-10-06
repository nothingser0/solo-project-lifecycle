# Idea Brief & Feasibility Scorecard

> Initial idea screening document to validate technical, operational, and commercial feasibility prior to formal specification design.

---

## 1. Project Metadata
- **Idea Name / Project Codename**: [Example: AutoLegalDoc / VaultSign]
- **Initiator / Solo Dev**: [Your Name]
- **Evaluation Date**: [YYYY-MM-DD]
- **Initial Target Scale**: [Small (MVP) / Medium (SaaS) / Large / Enterprise]

---

## 2. Idea Summary (Elevator Pitch)
> **Formula Format**: For **[Target User]** who experience **[Specific Problem]**, **[Product Name]** is a **[Software Category]** solution that delivers **[Core Benefit / Unique Value]**, unlike manual/existing alternatives because **[Differentiating Advantage]**.

- **Elevator Pitch**:
  *[Write a 1–2 sentence summary following the formula above]*

---

## 3. The 3-Filter Triage & Market Validation

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

| Feasibility Dimension | Score (1–5) | Solo Developer Analysis, Reality Checks & Mitigations |
| :--- | :---: | :--- |
| **1. Technical Feasibility** | [ ] / 5 | [CRUD vs Real-Time/Offline. Offline+Real-time capped at max 3/5. Deferral mitigation documented?] |
| **2. Bandwidth Feasibility (Solo Effort)** | [ ] / 5 | [Epic sum + 20% buffer + 6-7w non-dev phases match timeline claim within 20%?] |
| **3. Regulatory & Legal Feasibility** | [ ] / 5 | [UU PDP compliance plan documented (Privacy Policy, ToS, DPA, Disclaimers). Encryption ≠ compliance.] |
| **4. Commercial Feasibility (Unit Economics)** | [ ] / 5 | [Intent discounted to 15-25%? COGS 10-20% ARPU? SMB churn 10-15%/mo modeled? LTV:CAC ≥3:1?] |
| **AVERAGE TOTAL SCORE** | **[ ] / 5** | *(Total score divided by 4)* |

### Gate Decision
- [ ] **GO (Pass)**: Average score $\ge 3.5$, no dimension $<3$, zero unresolved complexity red flags. Proceed to Module 02.
- [ ] **GO BERSYARAT (Conditional Pass)**: Average score $3.0–3.5$ with mandatory deferrals (e.g., offline sync deferred to Phase 2, legal templates committed before M06).
- [ ] **PIVOT (Adjust)**: Any dimension $<3.0$ or root cause mismatch. Prune features/segments and re-evaluate.
- [ ] **KILL (Drop)**: Unresolvable technical complexity, prohibitive legal compliance capital, or negative unit economics.

---

## 5. Technical & Bandwidth Cross-Check Details

### 5.1 Bandwidth Epic Breakdown Audit
- Total Must-Have Features: `[X]` features
- Raw Development Epic Sum: `[X]` weeks (CRUD: 3-5 days/feature, Complex: 1.5-2 weeks/feature)
- Buffered Development Weeks ($+20\%$): `[X]` weeks
- Non-Development Lifecycle (M01-M05: 2-3w, M07 QA: 2w, M08 Data: 1w, M10 Deploy: 1w): `[6-7]` weeks
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
- Realistic Conversion Rate: Survey Intent `[X]%` $\times 0.20 =$ `[Y]%`
- Modeled Customer Lifetime: `[12–18]` months (accounting for SMB annual churn)
- Estimated LTV : CAC Ratio: `[X] : 1` (Target: $\ge 3:1$)

---

## 6. Post-Development Kill & Pivot Criteria

*Explicit thresholds reviewed at M06 Week 4 and Week 8:*

- **Kill Criteria (Halt Project)**:
  - Week 4 progress check: Working features $<30\%$ of planned milestone scope.
  - Beta testing: $\ge 50\%$ of closed-beta users reject product value.
  - Infrastructure cost: Unit hosting costs $>3\times$ original ARPU estimate.
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
