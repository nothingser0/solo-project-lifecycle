# Module 01: Idea & Feasibility (Idea Screening & Feasibility Testing)

> - `references/checklists/MODULE_01_ACTION_ITEMS_CHECKLIST.md` (Post-feasibility action items: Market validation, Formula verification, Security baseline)
> - `references/checklists/FEASIBILITY_CRITERIA.md` (Detailed 4-dimension feasibility rubric)
> - `references/pm/PM_PRIORITIZATION_FRAMEWORKS.md` (RICE scoring formula, reach/impact/confidence rubrics, backlog prioritization worksheet)
> - `templates/03-architecture-specs/PROJECT_LITE_TEMPLATE.md` (Fast-track single-file specification for Small/MVP tier projects)


This module is the first gate in the software development lifecycle for solo developers. Its purpose is to transform abstract raw ideas into a **Validated Idea Brief** with clear scale boundaries before wasting time on lengthy documents or coding.

**Solo Dev Tooling Prerequisites**:
- [ ] Password manager installed (Bitwarden/1Password) for secure credential sharing with clients
- [ ] Git client configured with proper email/name
- [ ] AI coding assistant ready (Cursor/Claude Code/Windsurf) if planning to use AI-assisted development

---

## 1. Execution Cycle of Module 01

```text
[ RAW / ROUGH IDEA ]
          │
          ▼
[ STEP 1: The 3-Filter Triage, Data Quality & Competitor Research ]
  • Real Problem, Survey Methodology & Root Cause Breakdown
  • 5-7 Competitor Landscape & Uniqueness Verification
  • Core User Loop (3-Step Primary Flow)
  • MVP Razor (Extreme Scope Pruning)
          │
          ▼
[ STEP 1.5: MVP Razor Validation Gate (MANDATORY) ]
  • Root Cause Match (≥70% of stated problem solved)
  • Target Segment Feasibility & BOM/Feature Fit
  • Prune Mismatched Segments or Upgrade MVP Features
          │
          ▼
[ STEP 2: 4-Dimension Feasibility Check (Stricter Reality Scoring) ]
  • Technical (Complexity Red Flags, Offline/Real-Time Penalties)
  • Solo Dev Bandwidth (Epic Breakdown Sum + Non-Dev Buffer Cross-Check)
  • Regulatory & Legal (UU PDP Compliance, Mandatory Docs, Disclaimers)
  • Commercial & Business Value (Discounted Intent 15-25%, Unit Economics)
  • Gate Outcome: GO (≥3.5) / GO BERSYARAT (3.0-3.5) / PIVOT (<3.0) / KILL
          │
          ▼
[ STEP 2.5: Post-Development Kill/Pivot Criteria ]
  • Week 4 & Week 8 Progress & Churn Thresholds
          │
          ▼
[ STEP 3: Scale Classification & Module Routing ]
  • Small (MVP) / Medium (SaaS) / Large (Scale-Up) / Enterprise
          │
          ▼
[ OUTPUT: docs/pm/IDEA_BRIEF.md ] ──► Ready to Proceed to Module 02: Discovery & Scope
```

---

## 2. Step-by-Step Execution

### Step 1: The 3-Filter Triage, Data Quality & Competitor Research

Perform rigorous interrogation on the raw idea before writing formal specifications:

#### 1.1 Problem Filter & Survey/Interview Methodology Standards
- *Core Question*: Who has this problem, how frequently does it occur, and what is the measurable financial/time loss today?
- *Workaround Rule*: Do not build custom software if a Google Sheet, Notion template, or simple form already solves 80% of the pain.
- *Data Quality Standards*: If citing user research, survey numbers, or market loss figures, the agent **MUST** document:
  1. **Sample Size & Split**: Disclose total respondents ($N$) and interview vs online survey breakdown (e.g., $N=52$: 10 in-depth interviews, 42 online forms). Never state "83% of users" without clarifying whether that is $8/10$ interviewees or $43/52$ survey responses.
  2. **Recruitment Channel & Selection Bias**: State how participants were acquired (e.g., direct shop visits, WhatsApp merchant groups, paid ads). Acknowledge biases (e.g., online forms over-index on tech-savvy business owners).
  3. **Question Formulation**: Distinguish intent from interest. A question asking *"Apakah Anda tertarik?"* measures passive curiosity. Only questions with pricing commitment (e.g., *"Apakah Anda bersedia membayar Rp 99.000/bulan untuk software ini?"*) count toward willingness-to-pay.
  4. **Financial Loss Verification**: State the sample size behind claimed loss amounts (e.g., *"Rp 3-8 juta/bulan loss from stock discrepancy cited across 10 merchant interviews; variance is high and subject to outlier bias"*).

#### 1.2 Competitor Research Minimum Standard
Agents **MUST** benchmark at least **5–7 competitors** across three distinct categories:
1. **Direct Competitors** (same core value proposition, same audience; e.g., BukuWarung, BukuKas).
2. **Adjacent Competitors** (same problem for different scale OR full POS/ERP; e.g., Majoo, Moka, Accurate).
3. **Manual / Workaround Competitors** (physical ledgers, customized Excel/Google Sheets, cash drawer paper notes).

**Required Documentation Per Competitor**:
- Product name, website URL, and detailed pricing tiers.
- Core feature matrix (list 5–8 dominant capabilities).
- Primary strength / market moat.
- Operational weakness / customer complaint themes.
- Offline capability audit: Does it support offline data entry? How does conflict resolution work?
- Target market boundary (micro-merchants vs mid-sized retailers vs enterprise).

**Uniqueness Claim Verification**:
- If the idea claims *"First offline-first inventory"* or *"Unique zero-hardware setup"*, the agent must verify that claim against all 7 competitors.
- If $\ge 2$ competitors already provide the feature (e.g., Majoo provides offline POS mode), the uniqueness claim is **FALSE** and must be reframed (e.g., *"Inventory-centric bookkeeping with offline mode without proprietary POS hardware at Rp 99k/month"*).

#### 1.3 Core User Loop (3-Step Primary Flow)
Define the uninterrupted daily loop delivering core value:
```text
[User Input / Trigger] ──► [System Process / Ledger Mutation] ──► [User Receives Value / Record Locked]
```
*Example*: Cashier scans barcode / types SKU `Indomie Goreng` ──► System validates stock, applies discount, records transaction hash ──► Receipt prints, inventory decrements, and daily revenue updates.

#### 1.4 Extreme Scope Pruning (The MVP Razor)
If the application could ship with only ONE capability, which feature justifies users switching from their current workaround?
- Cut secondary features (social login, dark mode, CSV exports, multi-currency, AI analytics) to the deferred backlog.

#### 1.5 Internal Consistency & Anti-Contradiction Checks
Before finalizing the triage, verify document consistency:
1. **Zero Ghost Features**: Every capability mentioned in the elevator pitch, problem narrative, or core loop MUST be listed in the feature table. (e.g., If the core loop mentions barcode scanning, it cannot be tagged as Phase 1.5 Should-Have).
2. **Feature Count Parity**: Count must-have features in the brief table and ensure exact parity across `IDEA_BRIEF.md`, `SCOPE_STATEMENT.md`, and `SITEMAP.md`. Never claim "13 features" when only 8 are tabulated.
3. **No Dual-Status Conflicts**: A feature cannot be simultaneously labeled "Should-Have (Phase 1.5)" and "Out-of-Scope (Phase 2)".
4. **Profit Label Alignment**: If operational expense tracking is deferred, financial reports MUST be labeled "Laba Kotor (Gross Profit)", not "Laba Bersih (Net Profit)".

---

### Step 1.5: MVP Razor & Root Cause Validation Gate (MANDATORY)

Before calculating feasibility scores, the agent **MUST** pass this validation gate to prevent building features that solve the wrong problem.

#### 1. Root Cause Breakdown (80/20 Analysis)
- Extract the quantified problem metrics from Step 1 according to your project domain:
  - *Retail / Commerce*: Problem = 10-15% stock discrepancy $\rightarrow$ 80% root cause: unrecorded shrinkage & manual entry errors; 20%: branch sync lag $\rightarrow$ P0 = stock adjustment audit, NOT multi-branch sync.
  - *CRM / Sales Pipeline*: Problem = 35% lead drop-off $\rightarrow$ 80% root cause: unassigned leads & delayed manual outreach ($>24$h); 20%: report generation speed $\rightarrow$ P0 = automated lead assignment & instant notifications, NOT AI predictive scoring.
  - *CMS / Publishing*: Problem = 4-day editorial bottleneck $\rightarrow$ 80% root cause: uncoordinated email review loops; 20%: CDN cache propagation $\rightarrow$ P0 = in-app review & state approval workflow, NOT multi-region edge deployment.
- **Validation Rule**: The proposed MVP Razor **MUST** target the primary $\approx 80\%$ root cause. If the proposed MVP Razor focuses on secondary friction ($<20\%$) while ignoring the dominant bottleneck, the MVP Razor is **REJECTED** and must be reframed.

#### 2. Target Segment Feature Fit
- Audit every targeted user segment against the MVP feature inventory:
  - *Persona A (Direct Fit)*: Needs are fully satisfied by core MVP feature set $\rightarrow$ **RETAIN IN MVP**.
  - *Persona B (Complex Adjacent Persona)*: Requires complex out-of-scope capabilities to experience core value (e.g., Cafe requiring Bill of Materials when building retail inventory, or Enterprise Holding requiring Okta SSO when building SMB CRM) $\rightarrow$ **DOES NOT FIT MVP**.
- **Decision Rule**: If a persona requires an out-of-scope complex feature to experience core value, **DROP THE SEGMENT** from MVP scope or upgrade the feature to MVP. Never retain a target persona in the brief whose pain points cannot be solved by the MVP.

#### 3. Verification Gate Checklist
- [ ] MVP Razor directly resolves $\ge 70\%$ of the primary root cause.
- [ ] All retained target segments can achieve core value using exclusively MVP features.
- [ ] Real-time sync or distributed networking is deferred if multi-branch coordination accounts for $<30\%$ of target users.

---

### Step 2: Feasibility Rubric (Stricter Reality Scoring)

Evaluate idea feasibility using conservative solo developer metrics. Overinflating scores to achieve an easy "PASS" is an anti-pattern that leads to abandoned projects.

#### 2.1 Technical Feasibility Scoring Rubric

- **5/5 (Excellent)**: Standard CRUD application, battle-tested REST API, relational DB, standard authentication, online-only. Zero custom R&D.
- **4/5 (Good)**: Single modern pattern: EITHER real-time WebSockets (online-only) OR local-first caching (read-only PWA), but NOT both. Well-documented SDKs.
- **3/5 (Moderate — Complexity Red Flag)**:
  - Combined Real-Time + Offline-First + Bi-directional Conflict Resolution (LWW/CRDT).
  - Complex multi-tenant Row-Level Security (RLS) with dynamic hierarchical permissions.
  - Mobile browser storage caveats (e.g., Safari iOS auto-clearing IndexedDB under storage pressure).
  - Relying on free-tier BaaS for production (e.g., Supabase free tier projects pausing after inactivity, lack of daily automated point-in-time recovery).
- **2/5 (Challenging)**: Custom machine learning training, background audio/video transcoding, custom cryptographic protocols, hardware peripheral drivers.
- **1/5 (R&D Experiment)**: Novel distributed algorithms, unproven academic architectures, hardware-software co-design.

#### 2.1.1 Offline & Real-Time Technical Traps (Mandatory Reality Checks)
If offline capability or real-time networking is proposed, evaluate these failure modes:
- [ ] **Storage Mechanism**: Use **IndexedDB (Dexie.js)**. Never use `localStorage` (5MB limit, synchronous blocking, lacks indexed queries).
- [ ] **Conflict Resolution Strategy**: Must use **append-only delta movements**. Never use Last-Write-Wins (LWW), which silently overwrites offline sales when multiple terminals reconnect.
- [ ] **Client Clock Drift**: Never trust client device timestamps for ledger ordering. The server's `created_at` timestamp must remain the authoritative source of truth.
- [ ] **Safari iOS Eviction Risk**: Acknowledge that Safari iOS deletes IndexedDB storage after 7 days of inactivity under storage pressure; implement server backup sync prompts.
- [ ] **BaaS Free-Tier Production Traps**: Free-tier Supabase projects automatically pause after inactivity and lack automated daily point-in-time recovery. Budget for paid tier ($25/mo) in production.
- [ ] **WebSocket Concurrency Limits**: Model concurrent WebSocket connection limits for real-time channels across multiple tenant users.

> ⚠️ **MANDATORY COMPLEXITY RED FLAG RULES**:
> - Combining **Offline Data Mutation + Real-Time Sync** automatically caps Technical Feasibility at **maximum 3/5**.
> - If scored 3/5, the brief **MUST** include an explicit deferral mitigation (e.g., *"Defer offline sync to Phase 2; MVP ships as mobile-first online-only with network reconnection retry"*), which restores the adjusted score to 4/5.

#### 2.2 Bandwidth Feasibility & Epic Breakdown Cross-Check

Never accept arbitrary timeline claims (e.g., *"12-16 weeks"*) without cross-checking the actual epic sums.

**Cross-Check Procedure**:
1. **Sum Development Epics**: Count must-have features. Simple CRUD features average $3–5$ working days; complex features (payments, offline sync, approval engines) average $1.5–2$ weeks.
2. **Apply 20% Development Buffer**: $\text{Buffered Dev Weeks} = \text{Sum of Epics} \times 1.2$.
3. **Add Non-Development Lifecycle Phases**:
   - Discovery & Specifications (M01–M05): 2–3 weeks.
   - QA & End-to-End Testing (M07): 2 weeks.
   - Data Seeding & Migration (M08): 1 week.
   - Production Deployment & Domain Setup (M10): 1 week.
   - *Total Non-Dev Lifecycle*: 6–7 weeks.
4. **Calculate Realistic Calendar Weeks**:
   $$\text{Total Project Weeks} = \text{Buffered Dev Weeks} + \text{Non-Dev Weeks (6–7w)}$$
   For part-time solo developers ($<40$ hrs/week) or teams taking holiday buffers, multiply total weeks by $1.2$.
5. **Validation Rule**: If the epic breakdown plus non-dev buffer exceeds the high-level timeline claim by $>20\%$ (e.g., claiming 12 weeks when epic math indicates 17 weeks), the timeline claim **MUST** be revised upwards before proceeding.

#### 2.3 Regulatory & Legal Feasibility (UU PDP No. 27/2022 Compliance)

Claiming *"Risk: Zero"* on legal feasibility is strictly prohibited for any software handling customer data. Infrastructure encryption (AES-256) is security, **not legal compliance**.

**Mandatory Compliance Deliverables**:
- [ ] **Privacy Policy (Kebijakan Privasi)**: Detailing user data collection, retention periods, third-party sharing, and user deletion rights under UU PDP No. 27/2022.
- [ ] **Terms of Service (Syarat & Ketentuan)**: Platform liabilities, account termination terms, and dispute jurisdiction.
- [ ] **Data Processing Agreement (DPA)**: Required when routing user data through third-party cloud vendors (Supabase, AWS, payment gateways).
- [ ] **Data Breach Notification Procedure**: Documenting 72-hour notice protocol in case of unauthorized data exfiltration.

**Mandatory Disclaimer Requirements**:
- Financial / Tax calculators: Must display explicit disclaimers (*"Perhitungan bersifat estimasi dan tidak menggantikan pelaporan pajak resmi atau nasihat akuntan publik"*).
- Non-PKP / PPN Status: Explicitly clarify if the system is designed for non-PKP entities with zero PPN handling.
- Bank Compliance Claims: Never claim "bank-compliant financial reports" unless the system generates full double-entry Balance Sheet, P&L, and Cash Flow statements.
- Liability Limitation: Software provided "as-is"; include disclaimers absolving developer from operational discrepancies between physical cash and software records.
- Financial records: Explicit disclaimer on user responsibility for input data accuracy.

**Legal Scoring Rubric**:
- **5/5**: Pure internal offline utility, zero personal/financial data, zero regulatory exposure.
- **4/5**: Standard SaaS with complete legal pack (Privacy Policy, ToS, DPA templates) prepared using verified templates (e.g., GetTerms) or legal review.
- **3/5**: Regulated financial, tax, or medical calculation requiring custom legal disclaimers and compliance review.
- **2/5**: Handling sensitive personal data without clear privacy policy or DPA protocols.
- **1/5**: Direct violation of licensing rules (operating uncertified payment gateway, unlicensed financial advisory).

#### 2.4 Commercial Feasibility & Unit Economics Reality Check

Never treat survey "intent-to-buy" percentages as real conversion rates.

1. **Intent-to-Buy Discounting**:
   - Real-world conversion from stated survey intent to actual paid subscription is typically **$15\%–25\%$**.
   - *Formula*: $\text{Realistic Conversion Rate} = \text{Survey Intent Rate} \times 0.20$.
   - *Example*: A $59.6\%$ survey intent translates to a realistic initial conversion rate of **$9\%–12\%$**.
2. **Realistic SaaS COGS Breakdown**:
   - Server hosting, database compute, and storage.
   - Payment gateway fees ($1.5\%–3.0\%$ per transaction plus fixed fee).
   - Transactional SMS / WhatsApp OTP / Email delivery costs.
   - Application monitoring & error tracking (Sentry, Logtail).
   - *Benchmark*: SaaS COGS must be modeled at **$10\%–20\%$ of ARPU**, never $<5\%$.
3. **SME / UMKM Churn Dynamics**:
   - Micro & small business SaaS experiences high annual churn ($30\%–50\%$ annually, or $3\%–5\%$ monthly).
   - Assume maximum customer lifetime of **$12–18$ months** for SMB cohorts when calculating Lifetime Value (LTV).
4. **Unit Economics Ratios**:
   $$\text{LTV} = \text{ARPU} \times \text{Customer Lifetime (Months)} \times \text{Gross Margin \%}$$
   $$\text{LTV : CAC Ratio} = \frac{\text{LTV}}{\text{CAC}}$$
   - $\ge 5:1$: Highly viable commercial model.
   - $3:1$ to $5:1$: Acceptable for solo MVP.
   - $< 3:1$: Unviable; CAC must be reduced or pricing restructured.
5. **Initial Traction & Operational Feasibility**:
   - **First 20 Customers Plan**: Define an actionable acquisition channel (direct outreach, community partnerships, local retail onboarding).
   - **Data Migration Path**: Document migration from physical paper / Excel to eliminate customer switching barriers.
   - **Solo Dev Support Capacity**: Acknowledge support limits (1 solo developer can manage at most 50–100 active organizations without automated self-serve tooling).

---

### Step 2.5: Post-Development Kill & Pivot Criteria (MANDATORY)

Feasibility is not a one-time gate. The Idea Brief **MUST** define concrete metrics that trigger project termination (Kill) or scope restructuring (Pivot) during execution (reviewed at M06 Week 4 and Week 8).

#### 1. Kill Criteria (Halt Project & Write Off Sunk Costs)
- **Velocity Collapse**: After 4 weeks of development in M06, working feature completion is $<30\%$ of planned milestone scope.
- **User Rejection at Beta**: $\ge 50\%$ of closed-beta testers report they would NOT use the product even if free.
- **Infrastructure Cost Explosion**: Operational infrastructure cost per active user exceeds $3\times$ original ARPU estimates.
- **Regulatory Dead-End**: New legal mandates impose licensing requirements impossible for a solo developer to acquire.

#### 2. Pivot Criteria (Restructure Scope & Continue)
- **Beta Churn $>50\%$ in 30 Days**: Drastically prune feature complexity; pivot core flow to the single highest-frequency action.
- **Timeline Slip $>30\%$**: Defer remaining complex features to Phase 1.5; freeze all new feature development and ship online-only MVP.
- **Technical Synchronization Bottleneck**: Offline data resolution produces irrecoverable state corruption $\rightarrow$ immediately pivot to online-first PWA with optimistic UI and network reconnect guards.
- **Direct Competitor Price War**: Incumbent drops prices or launches identical free tier $\rightarrow$ pivot positioning toward high-trust specialized niche (e.g., specific tax vertical, single-trade retail).

#### 3. Review Schedule
- **Checkpoint 1 (M06 Week 4)**: Audit development velocity against epic baseline.
- **Checkpoint 2 (M06 Week 8)**: Audit feature completeness and database performance under load.
- **Checkpoint 3 (M07 Beta Week 2)**: Audit user retention, bug density, and willingness-to-pay conversion.

---

### Step 3: Scale Triage (Project Scale Classification)

Determine project category upfront to establish the required weight of subsequent document formalities:

1. **Small Scale (MVP / Freelance Tool)**:
   - *Indicators*: Single user/small team, 1–2 data entities, timeline 1-3 months, no banking/regulatory integrations.
   - *Next Steps*: Draft simple 1-page Brief & Scope Statement, then create SOW_CONTRACT.md (simplified template with charter in Part I).
   - **Note**: M03 SOW_CONTRACT.md (with charter in Part I) is mandatory for all scales to lock scope baseline and payment terms. For internal projects, use simplified SOW template with BYPASS flag.
2. **Medium Scale (B2B SaaS / Agency)**:
   - *Indicators*: Multi-tenant, subscription payments, role-based access control (RBAC), 1–3 third-party API integrations, timeline 3-6 months.
   - *Next Steps*: Mandatory light PRD, formal SOW contract, and modular database architecture.
3. **Large Scale (Scale-Up / Distributed Platform)**:
   - *Indicators*: High transaction volume, high concurrency, enterprise multi-system integrations, timeline 6-12 months.
   - *Next Steps*: Mandatory Project Charter, formal PRD, in-depth FSD, and detailed WBS.
4. **Enterprise / Industrial Scale (Corporate, Banking, State-Owned Enterprises)**:
   - *Indicators*: Strict regulatory compliance (PDP Law, ISO 27001, SOC2), multiple client internal stakeholders, permanent audit trails, 99.9% uptime SLA, timeline 12-24 months.
   - *Next Steps*: Mandatory formal legal sign-off, signed Project Charter, bound Single PIC, comprehensive FSD, and RTM.
   - *M00 Integration*: **IF M00 (Product Discovery) was executed**: Use M00 outputs as inputs for M01 feasibility analysis:
     - `MARKET_RESEARCH.md` → Market size/TAM validation (Step 1)
     - `COMPETITIVE_LANDSCAPE.md` → Competitor analysis (Step 1)
     - `USER_RESEARCH_REPORT.md` → User persona validation (Step 2)
     - `PRODUCT_STRATEGY.md` → Strategic positioning context (Step 3)

**Module Routing**: After scale classification, refer to `references/playbooks/SCALE_WORKFLOWS.md` for:
- Module sequence per scale (which modules to execute, which to skip)
- Week-by-week timeline breakdown
- Payment gate locations (DP, Alpha, Beta, Final)
- Real-world workflow examples (Solo MVP, Agency, Vendor, Enterprise)

**Quick Reference**:
- **Small Scale**: M01 → M02 → M03 → M04 → M05 → M06 → M07-LITE → M09 → M10 → M11 (10 modules, skip M00/M08/M12/M13)
- **Medium Scale**: M01 → M02 → M03 → M04 → M05 → M06 → M07 → M09 → M10 → M11 (10 modules, skip M00/M08/M12/M13)
- **Large Scale**: M01 → M02 → M03 → M04 → M05 → M06 → M07 → M08 → M09 → M10 → M11 → M12 (12 modules, skip M00/M13)
- **Enterprise**: Full M00 → M13 (14 modules, no skips)

**Note**: M01 always executes first to determine scale, then routes to scale-specific modules starting from M02.

*See `references/playbooks/SCALE_WORKFLOWS.md` for complete timelines, payment structures, and gate enforcement.*

---

## 3. Output Artifacts (Deliverables)

The final deliverable of Module 01 is the file **`docs/pm/IDEA_BRIEF.md`** created using the template at `templates/01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md`.

> 📁 **ABSOLUTE FILE LOCATION RULE**:
> This file MUST be stored inside the **`docs/pm/`** directory (never in the root directory).
> The root directory `./` is reserved exclusively for the 9 AI control files (Agent Harness), README.md, and configuration once Module 06 begins.

---

## 4. Product Roadmap

After the idea passes feasibility checks, build a roadmap providing timeline visibility and execution priority:

### 4.1 Now/Next/Later Framework

- **Now (0–1 month)**: Core MVP features that MUST exist for initial launch (Core User Loop)
- **Next (1–3 months)**: Supporting features improving retention/revenue (e.g., notifications, payment integrations)
- **Later (3–6 months+)**: Nice-to-have features & experiments (e.g., dark mode, advanced analytics, AI features)

### 4.2 Timeline Estimation & Dependency Mapping

- Use T-shirt sizing (XS/S/M/L/XL) or story points for relative estimation
- Identify critical dependencies: Feature B cannot start before Feature A is finished
- Flag external dependencies (API vendors, third-party approvals) with high risk tags

### 4.3 Release Milestones

| Milestone | Target | Core Deliverables | Exit Criteria |
| :--- | :--- | :--- | :--- |
| **M0: Technical Spike** | Week 1 | Proof of concept core algorithm/integration | Can demo the hardest technical risk |
| **M1: Alpha (Internal)** | Week 4 | Core user loop works end-to-end | Solo dev can complete full workflow |
| **M2: Beta (Closed)** | Week 8 | 3–5 real users testing | At least 2 users complete workflow without help |
| **M3: Public Launch** | Week 12 | Production-ready with docs | Ready for public traffic & payments |

### 4.4 Roadmap Tools Setup

- **Notion**: Database template with status (Now/Next/Later/Done), owner, dependencies, effort
- **Linear**: Roadmap view with cycles (sprints), project milestones, and automated triage
- **Productboard**: Feature scoring (RICE), user feedback aggregation, roadmap visualization

*Full setup guide: `references/pm/PM_TOOLS_SETUP_GUIDE.md`*

---

## 5. Backlog Management

Break down the roadmap into actionable execution units:

### 5.1 Hierarchy: Epic → Story → Task

- **Epic**: Large feature requiring 2–4 weeks (e.g., "User Authentication System")
- **Story**: Work unit taking 1–3 days that delivers value (e.g., "As a user, I want to login with email so I can access my account")
- **Task**: Technical sub-task implementation of a story (e.g., "Create POST /api/auth/login endpoint", "Hash password with bcrypt")

### 5.2 User Story Format (Industry Standard)

```
As a [persona/role],
I want to [action/capability],
So that [business value/outcome].

Acceptance Criteria:
- [ ] Given [context], when [action], then [expected result]
- [ ] Given [context], when [action], then [expected result]
- [ ] Edge case: [negative case handling]
```

### 5.3 Story Point Estimation (Fibonacci Scale)

- **1 point**: Trivial change (rename variable, update copy text) — 15 min
- **2 points**: Simple CRUD API or UI component — 1–2 hours
- **3 points**: Standard feature with simple business logic — half day
- **5 points**: Complex feature with integration — 1 day
- **8 points**: Very complex, needs design discussion — 2–3 days
- **13 points**: Epic-level, must be broken down smaller

*If story > 8 points, breakdown into sub-stories is MANDATORY.*

### 5.4 Backlog Prioritization (RICE Score)

Formula: **RICE Score = (Reach × Impact × Confidence) / Effort**

- **Reach**: Number of users affected per period (e.g., 100 users/month)
- **Impact**: Scale of impact (Massive=3, High=2, Medium=1, Low=0.5, Minimal=0.25)
- **Confidence**: Data confidence level (High=100%, Medium=80%, Low=50%)
- **Effort**: Person-months to complete (e.g., 0.5 = 2 weeks solo dev)

Example:
- Story A: (500 × 3 × 1.0) / 0.5 = **3000** (highest priority)
- Story B: (50 × 2 × 0.8) / 2.0 = **40** (low priority)

*Full worksheet: `references/pm/PM_PRIORITIZATION_FRAMEWORKS.md`*

### 5.5 Jira/Linear Project Setup

- **Jira**: Epic → Story → Subtask hierarchy, Custom fields (RICE score), Automation rules (auto-assign, status sync)
- **Linear**: Project → Issue → Sub-issue, Labels (#now #next #later), Cycles (sprint), Triage view

*Step-by-step setup guide: `references/pm/PM_TOOLS_SETUP_GUIDE.md`*

*Backlog template: `templates/01-discovery-commercial/BACKLOG_TEMPLATE.md`*

---

## 6. OKR/KPI Framework

Establish measurable targets to align execution with business goals:

### 6.1 Quarterly OKR Template

**Objective** (Qualitative goal, inspiring): *"Launch MVP and validate product-market fit"*

**Key Results** (Quantitative, measurable, time-bound):
1. KR1: Acquire 50 beta users by end of Q1
2. KR2: Achieve 40% weekly active user (WAU) retention by week 8
3. KR3: Collect 20 user feedback sessions with actionable insights

### 6.2 Key Results Measurable Criteria

Every KR MUST have:
- **Baseline**: Initial value (e.g., 0 users currently)
- **Target**: Desired value to achieve (e.g., 50 users)
- **Metric Definition**: How it is measured (e.g., "Unique users completing signup flow")
- **Data Source**: Where data is fetched (e.g., "PostgreSQL users table, status='active'")

### 6.3 KPI Dashboard Design

**Metric Categories**:
- **Acquisition**: Signups/week, conversion rate landing → signup
- **Activation**: % users completing onboarding within 24 hours
- **Retention**: D1/D7/D30 retention rate, weekly active users (WAU)
- **Revenue** (if applicable): MRR (Monthly Recurring Revenue), ARPU (Average Revenue Per User)
- **Technical Health**: API p95 latency, error rate, uptime %

**Tools**: Metabase/Superset (self-hosted), Mixpanel/Amplitude (SaaS), or custom dashboard with Grafana + PostgreSQL

### 6.4 Metric Ownership (RACI Matrix)

| Metric | Responsible | Accountable | Consulted | Informed |
| :--- | :--- | :--- | :--- | :--- |
| Weekly signups | Developer (track code) | PM/Founder (target) | Marketing | Investors |
| API uptime | Developer (monitor) | Developer (fix) | — | Users (status page) |
| User retention | PM/Founder (analyze) | PM/Founder (decide) | Developer (impl) | Team |

*Full OKR template: `templates/01-discovery-commercial/OKR_TEMPLATE.md`*

---

## 7. Risk Register

Anticipate risks early to minimize firefighting:

### 7.1 Risk Identification Workshop

**5 Risk Categories**:
1. **Technical**: API vendor deprecated, scaling bottleneck, tech debt
2. **Resource**: Solo dev illness/burnout, skill gap (e.g., infrastructure unfamiliarity)
3. **Market**: Competitor launches similar product, low user adoption
4. **Legal/Compliance**: PDP Law violations, vendor ToS changes
5. **Financial**: Budget overrun, revenue below projections

### 7.2 Risk Assessment Matrix (Likelihood × Impact)

| Likelihood | Impact Low (1) | Impact Medium (2) | Impact High (3) |
| :--- | :---: | :---: | :---: |
| **High (3)** | 3 (Monitor) | 6 (Mitigate) | **9 (Urgent)** |
| **Medium (2)** | 2 (Accept) | 4 (Monitor) | 6 (Mitigate) |
| **Low (1)** | 1 (Accept) | 2 (Accept) | 3 (Monitor) |

**Action Threshold**:
- Score 7–9: Mandatory mitigation plan BEFORE starting development
- Score 4–6: Active monitoring, prepare contingency plan
- Score 1–3: Accept risk, review quarterly

### 7.3 Mitigation Strategies Per Risk

Example:
- **Risk**: "Main payment gateway (Midtrans) API down during launch" (Likelihood=2, Impact=3, Score=6)
  - **Mitigation**: Integrate backup gateway (Xendit) in week 6, test failover logic
  - **Contingency**: Manual payment confirmation via bank transfer if both gateways are down
  - **Owner**: Developer
  - **Review Date**: 2 weeks before launch

### 7.4 Monitoring Cadence & Escalation Protocol

- **Weekly**: Review top 3 risks (score ≥6) in standup/weekly review
- **Monthly**: Re-assess likelihood & impact of all risks, update mitigation status
- **Escalation**: If risk score increases from 4 → 7+, trigger emergency planning session

*Risk register template: `templates/01-discovery-commercial/RISK_REGISTER_TEMPLATE.md`*

---

## 8. Resource Allocation

Map realistic effort for solo devs or small teams:

### 8.1 Time Budget Per Epic

Use the **70-20-10** rule:
- **70%**: Development (coding, testing, deployment)
- **20%**: Planning & design (architecture, mockups, PRD)
- **10%**: Buffer for unexpected issues (bug fixes, vendor downtime)

Example: Epic "User Auth System" = 2 weeks total
- Development: 7 days (coding auth flow, testing, deploy)
- Planning: 2 days (design DB schema, security review, API contract)
- Buffer: 1 day (handle edge cases, fix integration bugs)

### 8.2 Skill Gap Analysis

Identify skills NOT YET acquired but REQUIRED by the project:

| Skill Required | Current Level | Target Level | Learning Path | Time Investment |
| :--- | :--- | :--- | :--- | :--- |
| React Server Components | Beginner | Intermediate | Official docs + 2 tutorials | 2 days |
| Stripe webhook security | None | Proficient | Stripe docs + test with CLI | 1 day |
| AWS CDK infra-as-code | None | Basic | CDK workshop + deploy 1 stack | 3 days |

**Decision Point**: If total learning time > 20% of project timeline, consider:
- Simplify tech stack (use existing proficiencies)
- Hire freelancer for specific task
- Extend timeline to accommodate learning

### 8.3 External Dependency Tracking

| Dependency | Type | Status | Risk | Contact/Docs | Mitigation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| WhatsApp Business API approval | Vendor | Pending | High | Meta Business Support | Fallback: Email notifications |
| SSL cert for custom domain | Infrastructure | Not started | Low | Let's Encrypt docs | Auto-renew with Certbot |
| Client design assets (logo, color) | Stakeholder | Waiting | Medium | client@email.com | Use placeholder, finalize week 2 |

**Tracking Cadence**: Update status every 2–3 days for High/Medium risk dependencies.

---

## 🛑 [GATE] EXIT & MANDATORY STOP PROTOCOL

After the file `docs/pm/IDEA_BRIEF.md` has been written:
1. **STRICTLY FORBIDDEN to proceed directly or invoke tools for Module 02 within the same turn!**
2. **SELF-VERIFICATION CHECKLIST**:
   - [ ] Read and verify file `docs/pm/IDEA_BRIEF.md` → Confirm file exists, 120+ lines
   - [ ] Feasibility score calculated (X/5) present in file
   - [ ] Gate decision explicitly declared: GO (≥3.5), GO BERSYARAT (3.0-3.5 with mitigations), PIVOT (<3.0), or KILL
   - [ ] Project scale (Small/Medium/Large/Enterprise) documented
   - [ ] 3-step core loop documented
   - [ ] Root cause vs MVP Razor alignment verified (≥70% match to primary root cause)
   - [ ] Target segment verification passed (all retained segments addressable by MVP features)
   - [ ] Technical feasibility scored conservatively (max 3/5 if real-time + offline; deferral mitigation documented)
   - [ ] Epic breakdown cross-check passes (epic sum + 20% buffer + 6-7w non-dev matches timeline within 20%)
   - [ ] Legal compliance checklist complete (Privacy Policy, ToS, DPA, disclaimers)
   - [ ] Commercial feasibility uses discounted intent (15-25% of survey intent; COGS 10-20% of ARPU)
   - [ ] 5-7 competitors documented across direct, adjacent, and manual with uniqueness claim verified
   - [ ] Post-development Kill/Pivot criteria documented for M06 Checkpoints
3. Present a brief summary of Module 01 results to the user:
   - Elevator pitch of product idea
   - 3-step core loop
   - Feasibility Scorecard result & designated scale
4. **END YOUR RESPONSE (END TURN)** and ask for confirmation from the user:
   > *"Document `docs/pm/IDEA_BRIEF.md` has been completed with a feasibility score of [X/5] and scale [Tier]. Does this summary align with expectations, or are there points to adjust before proceeding to Module 02 (Discovery & Scope Definition)?"*
5. The agent may ONLY proceed to Module 02 AFTER the user provides an affirmative response (e.g., *"ok"*, *"proceed"*, *"approved"*). Permissions such as *"fill it in first and I will review later"* apply ONLY to this Module 01, not as permission to batch subsequent modules!
