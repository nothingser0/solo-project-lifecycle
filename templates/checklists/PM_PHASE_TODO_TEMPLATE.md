# PM Phase TODO Template (Module 00 - Module 03)

> Atomic task checklist template for Product Management, Discovery, Feasibility, Scope Definition, and Legal/Commercial Negotiation phases.
> Rules: Execute systematically module by module. Every task must provide artifact proof before checking `[x]`. These modules must be finalized and approved by the client/stakeholder before proceeding to the Design & Architecture phase.

---

## Project Metadata
- **Project Name**: [Project / System Name]
- **Client / Business Initiator**: [Company / Organization Name]
- **Product Manager / Solo Consultant**: [Your Name]
- **Start Date**: [YYYY-MM-DD]
- **Target PM Phase Completion**: [YYYY-MM-DD]
- **Document Version**: 1.0.0
- **PM Gate Status**: [ ] DRAFT | [ ] UNDER REVIEW | [ ] APPROVED / LOCKED

---

## 1. Module 00: Market Research, Competitors, & Product Strategy (M00)

### 1.1 Market Research & Business Opportunity
- [ ] `docs/01-discovery/market-research.md`: Calculate TAM, SAM, and SOM estimates using quantitative formulas - expect realistic market size estimates verified against public data (BPS/Census, Statista, industry reports)
- [ ] `docs/01-discovery/market-research.md`: Analyze macro trends and market adoption cycles 3-5 years forward - expect market trend directions clearly described
- [ ] `docs/01-discovery/market-research.md`: Map regulatory landscape and legal compliance for relevant sectors (PDP Law / GDPR, licensing permits for fintech/healthtech) - expect regulatory requirements and licensing checklists recorded without compliance gaps

### 1.2 In-Depth Competitor Analysis
- [ ] `docs/01-discovery/competitive-analysis.md`: Identify at least 3 direct competitors and 2 indirect competitors - expect complete competitor profiles
- [ ] `docs/01-discovery/competitive-analysis.md`: Build Feature Comparison Matrix based on core system capabilities - expect feature differentiation clearly highlighted
- [ ] `docs/01-discovery/competitive-analysis.md`: Benchmark competitor pricing models - expect upper and lower bounds of market willingness to pay
- [ ] `docs/01-discovery/competitive-analysis.md`: Create 2x2 Positioning Map (e.g., Price vs. Customization, or Ease of Use vs. Feature Depth) - expect market white space or comparative advantage identified

### 1.3 User Research & Real Customer Needs (User Research)
- [ ] `docs/01-discovery/user-research.md`: Draft User Interview Script with 8-10 in-depth behavioral questions - expect unbiased interview guide
- [ ] `docs/01-discovery/user-research.md`: Conduct interviews with 5-10 target user representatives or survey validation with at least 30 respondents - expect transcript synthesis notes and empirical data collected
- [ ] `docs/01-discovery/personas.md`: Create 2 primary user personas using Jobs-to-be-Done (JTBD), pains, gains, and emotional triggers - expect concrete problem-oriented personas rather than mere demographic fiction
- [ ] `docs/01-discovery/user-journey-map.md`: Map as-is User Journey Map along with key friction points and frustrations - expect optimization opportunities transparently identified

### 1.4 Product Strategy & Success Metrics
- [ ] `docs/01-discovery/product-strategy.md`: Formulate Value Proposition Canvas and product positioning statement - expect concise 1-paragraph unique value proposition
- [ ] `docs/01-discovery/product-strategy.md`: Define 1 North Star Metric (NSM) and 3-5 supporting Input Metrics - expect measurable metrics without vanity metrics
- [ ] `docs/01-discovery/okrs.md`: Formulate Objectives and Key Results (OKRs) for the first quarter post-launch - expect realistic numerical targets defined

---

## 2. Module 01: Idea Triage & Feasibility Assessment (M01)

### 2.1 The 3-Filter Triage
- [ ] `docs/01-discovery/idea-brief.md`: Write Real Problem in 1 sentence & Unique Solution in 1 sentence - expect problem cannot be solved simply with a free Google Spreadsheet
- [ ] `docs/01-discovery/idea-brief.md`: Define Core User Loop (Trigger -> Action -> Variable Reward -> Investment) - expect clear core interaction loop in < 3 steps
- [ ] `docs/01-discovery/idea-brief.md`: Apply the MVP Razor: eliminate all features outside the Core User Loop - expect only 1-3 essential features delivering immediate value remaining

### 2.2 4-Dimension Feasibility Assessment
- [ ] `docs/01-discovery/feasibility-report.md`: Technical Feasibility - Evaluate stack readiness, third-party API availability, and architecture complexity for solo developer - expect technical score >= 4/5
- [ ] `docs/01-discovery/feasibility-report.md`: Solo Dev Bandwidth Feasibility (Schedule/Capacity) - Calculate complexity-to-delivery deadline ratio - expect reasonable working hour commitment without burnout
- [ ] `docs/01-discovery/feasibility-report.md`: Legal & Regulatory Feasibility (Legal/Compliance) - Audit potential personal data liabilities, intellectual property, and operating licenses - expect zero fatal legal blockers
- [ ] `docs/01-discovery/feasibility-report.md`: Economic & Business Feasibility (Economic/ROI) - Test Willingness to Pay, basic unit economics, and developer margin - expect positive ROI and budget readiness from sponsor/client

### 2.3 Scale Classification & Decision Gate
- [ ] `docs/01-discovery/scale-classification.md`: Determine project scale classification (Small MVP / Mid B2B SaaS / Large Multi-System / Enterprise) - expect execution route and timeline mapped accurately
- [ ] `Module 01 Gate Review`: Determine GO / PIVOT / KILL status based on feasibility score threshold - expect formal decision approved by stakeholders

---

## 3. Module 02: Scope Definition & Backlog Decomposition (M02)

### 3.1 Stakeholder Identification & RACI Matrix
- [ ] `docs/01-discovery/stakeholders.md`: Map all primary stakeholders (Project Sponsor, Product Owner, End User, Compliance Lead) - expect contacts and authority levels registered
- [ ] `docs/01-discovery/raci-matrix.md`: Build RACI Matrix (Responsible, Accountable, Consulted, Informed) for each project deliverable phase - expect single accountable party per deliverable without ambiguity

### 3.2 Scope Statement
- [ ] `docs/01-discovery/scope-statement.md`: Detail explicit **In-Scope** list (features, platforms, integrations required to be built) - expect clear functional boundaries
- [ ] `docs/01-discovery/scope-statement.md`: Detail explicit **Out-of-Scope** list (features strictly excluded in this phase) - expect protection against scope creep
- [ ] `docs/01-discovery/scope-statement.md`: Document **Project Assumptions** (data availability, client review turnaround time, third-party API stability) - expect assumptions documented in writing
- [ ] `docs/01-discovery/scope-statement.md`: Document **Project Constraints** (hard deadlines, budget ceiling, hardware/hosting limitations) - expect constraints acknowledged by both parties

### 3.3 Backlog Decomposition & Feature Prioritization
- [ ] `docs/01-discovery/backlog.md`: Break down requirements into Epics and User Stories following INVEST standards (*Independent, Negotiable, Valuable, Estimable, Small, Testable*) - expect user stories accompanied by Acceptance Criteria in Given-When-Then format
- [ ] `docs/01-discovery/prioritization.md`: Apply MoSCoW method (Must-have, Should-have, Could-have, Won't-have for this release) - expect Must-Have allocation <= 60% of total capacity
- [ ] `docs/01-discovery/prioritization.md`: Score alternative priorities using the RICE framework (*Reach, Impact, Confidence, Effort*) for tier-2 backlog - expect priority ranking ordered objectively

### 3.4 Risk Management & Change Control
- [ ] `docs/01-discovery/risk-register.md`: Build Risk Register (Risk description, Category: Technical/Business/Operational, Probability 1-5, Impact 1-5, Mitigation Plan, Contingency Plan) - expect mitigation plans for all High/Critical risks
- [ ] `docs/01-discovery/change-management-protocol.md`: Establish formal Change Request (CR) protocol (CR submission form, cost/timeline impact assessment, written approval requirements) - expect written agreement that scope changes outside SOW incur additional invoices and delivery time

---

## 4. Module 03: Legal Contracts, SOW, & Project Charter (M03)

### 4.1 Scope of Work (SOW) Formulation
- [ ] `contracts/SOW_CONTRACT.md`: Write project objective description, key deliverables, and deliverable specifications per milestone - expect concrete deliverables verifiable objectively
- [ ] `contracts/SOW_CONTRACT.md`: Insert Milestone Schedule & Phased Payment Distribution table:
  - Milestone 1: Initiation, SOW & Design Approved (Down Payment 30% - 50%)
  - Milestone 2: Core Development & SIT Completed (30% - 40%)
  - Milestone 3: UAT Passed & Final BAST Go-Live (10% - 20%)
  - expect no 100% pay-at-the-end clauses (*pay-at-the-end anti-pattern prevented*)
- [ ] `contracts/SOW_CONTRACT.md`: Define testing procedures and client review turnaround window (maximum 5-7 business days to provide feedback/approval per milestone) - expect deemed-accepted clause if client fails to respond within timeline

### 4.2 Intellectual Property, Confidentiality, & Liability Clauses
- [ ] `contracts/SOW_CONTRACT.md`: Enforce Intellectual Property (IP) clause: Ownership of newly developed source code transfers to client ONLY after 100% full payment is completed - expect solo dev copyright protection maintained
- [ ] `contracts/SOW_CONTRACT.md`: Include Open Source Software (OSS) and developer reusable boilerplate clauses excluded from client exclusive assignment - expect generic libraries protected
- [ ] `contracts/SOW_CONTRACT.md`: Establish mutual Non-Disclosure Agreement (NDA) covering proprietary business data and system credentials - expect data protection compliance and trade secret protection
- [ ] `contracts/SOW_CONTRACT.md`: Define warranty period (*Warranty Period*) for 30-60 calendar days ONLY for bugs deviating from agreed SOW/FSD specifications (not new feature additions) - expect clear warranty boundaries

### 4.3 Termination, Late Payment, & Kill Fee Clauses
- [ ] `contracts/SOW_CONTRACT.md`: Include late payment penalties for client invoices (e.g., 0.1%/day) and developer right to suspend work if invoices are overdue - expect solo dev cash flow protection
- [ ] `contracts/SOW_CONTRACT.md`: Establish Kill Fee / Termination for Convenience clause: if project is unilaterally terminated by client, down payment is forfeited and all completed work must be paid pro-rata - expect mitigation against unilateral time loss
- [ ] `contracts/SOW_CONTRACT.md`: Define dispute resolution and escalation mechanism (Amicable negotiation -> Arbitration / District Court of provider jurisdiction) - expect legal jurisdiction clearly stated

### 4.4 Project Charter Finalization & Down Payment (DP) Invoice
- [ ] `contracts/PROJECT_CHARTER.md`: Compile 1-2 page Project Charter summary signed by Project Sponsor and Lead Consultant - expect official project authorization mandate issued
- [ ] `invoices/INVOICE_DOWN_PAYMENT.pdf`: Issue Down Payment (DP 30%-50%) invoice with official bank details - expect invoice received and validated by client finance department
- [ ] `Proof of Payment`: Verify down payment wire transfer received in bank account before technical/design execution begins - expect effective balance confirmed in account (Zero work without DP)

---

## 5. PM Phase Verification Gate (Gate Pass PM to Design)

| Evaluation Parameter | Minimum Pass Standard | Verification Status | Evidence Notes |
| :--- | :--- | :---: | :--- |
| **Problem & Market Validation** | TAM/SAM calculated, 5+ user interviews completed, competitor differentiation clear | [ ] PASS | Attached in `docs/01-discovery/` |
| **Feasibility & Scale** | 4-dimension feasibility score >= 4/5, project scale classified | [ ] PASS | Attached in `docs/01-discovery/feasibility-report.md` |
| **Scope Lock** | Scope statement In/Out locked, MoSCoW backlog finalized | [ ] PASS | Attached in `docs/01-discovery/scope-statement.md` |
| **Legality & Financials** | SOW & Contract executed by both parties (digital stamp/signature), DP 30-50% cleared | [ ] PASS | Attached in `contracts/` & bank transfer proof |

### PM Gate Decision:
- [ ] **PASSED (GO TO DESIGN)**: All M00-M03 artifacts complete, contract valid, DP cleared. Proceed to Module 04 (Design System & Prototyping).
- [ ] **HOLD (HOLD / PENDING DP)**: Documents finalized but DP payment not yet cleared. Strictly prohibited from writing code or creating final designs!
- [ ] **REJECT / PIVOT (REJECT / REDESIGN SCOPE)**: Scope is unrealistic or commercial agreement cannot be reached. Revise scope or cancel project.
