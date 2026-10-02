# Module 01: Idea & Feasibility (Idea Screening & Feasibility Testing)

> - `references/checklists/MODUL_01_ACTION_ITEMS_CHECKLIST.md` (Post-feasibility action items: Market validation, Formula verification, Security baseline)
> - `references/checklists/FEASIBILITY_CRITERIA.md` (Detailed 4-dimension feasibility rubric)
> - `references/pm/PM_PRIORITIZATION_FRAMEWORKS.md` (RICE scoring formula, reach/impact/confidence rubrics, backlog prioritization worksheet)


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
[ STEP 1: The 3-Filter Triage ]
  • Real Problem & Unique Value
  • Core User Loop
  • MVP Razor (Extreme Feature Cutting)
          │
          ▼
[ STEP 2: 4-Dimension Feasibility Check ]
  • Technical (Tech Stack & API Readiness)
  • Solo Dev Bandwidth (Time Constraints & Maintenance)
  • Regulatory & Legal (Business Permits, PDP Law, Liability)
  • Economic & Business Value (Willingness to Pay / ROI)
          │
          ▼
[ STEP 3: Scale Classification ]
  • Small (MVP / Freelance)
  • Medium (B2B SaaS / Agency)
  • Large (Scale-Up / Multi-System)
  • Enterprise (Corporate / Strict Regulation)
          │
          ▼
[ OUTPUT: IDEA_BRIEF.md Document ] ──► Ready to Proceed to Module 02: Discovery & Scope
```

---

## 2. Step-by-Step Execution

### Step 1: The 3-Filter Triage

Perform targeted interrogation on the raw idea:

1. **Problem Filter (Problem Statement)**:
   - *Question*: Who has this problem, how frequently does it occur, and how do they solve it today (manually, spreadsheets, hiring others)?
   - *Principle*: Do not build software for problems adequately solved by a Google Sheet or simple form, unless there is a specific need for automation or data security.
2. **Core Loop Filter (Core User Loop)**:
   - *Question*: What is the 3-step loop of user interaction?
   - *Standard Format*: `[User Input Data] ──► [System Processes/Transforms] ──► [User Receives Result/Value]`.
3. **Extreme Cutting Filter (MVP Razor)**:
   - *Question*: If this application could have only ONE primary feature at initial launch, which feature would still compel users to use it?
   - *Action*: Cut secondary features (social login, dark mode, complex analytics charts, multi-gateway integrations) to the *Future Backlog*.

---

### Step 2: Feasibility Rubric (4-Dimension Feasibility Check)

Evaluate idea feasibility using a 1–5 score across 4 dimensions:

| Feasibility Dimension | Critical Solo Dev Test Question | Minimum Passing Threshold |
| :--- | :--- | :--- |
| **1. Technical Feasibility** | Are the required libraries, SDKs, and APIs mature and documented? Does it require heavy compute R&D? | Score ≥3 (If heavy R&D alone is required, simplify the idea) |
| **2. Bandwidth Feasibility** | Can the application be completed within solo dev timeframes (max. 1–3 months for v1)? Are daily operational costs low? | Score ≥4 (Avoid multi-service architectures requiring 24/7 on-call) |
| **3. Regulatory & Legal Feasibility** | Does system operation violate laws, require special licenses (OJK, Kominfo, Health Ministry), or handle sensitive personal data (PDP Law)? | Score ≥4 (If criminal/fine risk exists without legal capital, pivot/scope down) |
| **4. Commercial Feasibility** | Is anyone willing to pay for this system (B2B/B2C)? If a client order, is the budget realistic relative to effort? | Score ≥3 (Must have clear revenue sources or reasonable margins) |

**Aggregate Threshold**: Total score ≥14/20 (average 3.5 per dimension). Projects with a total score < 14 must be simplified or rejected.

*See full guide at: `references/checklists/FEASIBILITY_CRITERIA.md`.*

---

### Step 3: Scale Triage (Project Scale Classification)

Determine project category upfront to establish the required weight of subsequent document formalities:

1. **Small Scale (MVP / Freelance Tool)**:
   - *Indicators*: Single user/small team, 1–2 data entities, work duration < 1 month, no banking/regulatory integrations.
   - *Next Steps*: Draft a simple 1-page Brief & Scope Statement directly; skip formal charter.
   - **Fast-Track**: If feasibility ≥ 17/20 and risk is low, Module 03 charter may be skipped (proceed directly to Module 04 design).
2. **Medium Scale (B2B SaaS / Agency)**:
   - *Indicators*: Multi-tenant, subscription payments, role-based access control (RBAC), 1–3 third-party API integrations, work duration 1–3 months (exclusive range: ≥1 month and <3 months).
   - *Next Steps*: Mandatory light PRD, formal SOW contract, and modular database architecture.
3. **Large Scale (Scale-Up / Distributed Platform)**:
   - *Indicators*: High transaction volume, high concurrency, enterprise multi-system integrations, work duration ≥3 months and <6 months (exclusive range).
   - *Next Steps*: Mandatory Project Charter, formal PRD, in-depth FSD, and detailed WBS.
4. **Enterprise / Industrial Scale (Corporate, Banking, State-Owned Enterprises)**:
   - *Indicators*: Strict regulatory compliance (PDP Law, ISO 27001, SOC2), multiple client internal stakeholders, permanent audit trails, 99.9% uptime SLA, work duration ≥6 months.
   - *Next Steps*: Mandatory formal legal sign-off, signed Project Charter, bound Single PIC, comprehensive FSD, and RTM.

---

## 3. Output Artifacts (Deliverables)

The final deliverable of Module 01 is the file **`docs/pm/IDEA_BRIEF.md`** created using the template at `templates/01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md`.

> 📁 **ABSOLUTE FILE LOCATION RULE**:
> This file MUST be stored inside the **`docs/pm/`** directory (never in the root directory).
> The root directory `./` is reserved exclusively for the 7 AI control files (Agent Harness) once Module 06 begins.

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
   - [ ] `read_file('docs/pm/IDEA_BRIEF.md')` → Confirm file exists, 80+ lines
   - [ ] Feasibility score calculated (X/5) present in file
   - [ ] Project scale (Small/Medium/Large/Enterprise) documented
   - [ ] 3-step core loop documented
3. Present a brief summary of Module 01 results to the user:
   - Elevator pitch of product idea
   - 3-step core loop
   - Feasibility Scorecard result & designated scale
4. **END YOUR RESPONSE (END TURN)** and ask for confirmation from the user:
   > *"Document `docs/pm/IDEA_BRIEF.md` has been completed with a feasibility score of [X/5] and scale [Tier]. Does this summary align with expectations, or are there points to adjust before proceeding to Module 02 (Discovery & Scope Definition)?"*
5. The agent may ONLY proceed to Module 02 AFTER the user provides an affirmative response (e.g., *"ok"*, *"proceed"*, *"approved"*). Permissions such as *"fill it in first and I will review later"* apply ONLY to this Module 01, not as permission to batch subsequent modules!
