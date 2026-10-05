# Scope Statement & Requirements Breakdown

> Initial project scope agreement document resulting from requirements elicitation to lock functional boundaries prior to commercial contract signing and pricing estimation.

---

## 1. Project Metadata
- **Project Name**: [Application / System Name]
- **Client / Stakeholder**: [Client Company / Organization]
- **Solo Developer / Consultant**: [Your Name]
- **Document Reference**: IDEA_BRIEF-[ID] v1.0
- **Defined Project Scale**: [Small (MVP) / Medium (SaaS) / Large / Enterprise]
- **Elicitation Completion Date**: [YYYY-MM-DD]

---

## 2. Business Objectives, Root Cause Breakdown & Metrics

### 2.1 Core Problem & 80/20 Root Cause Breakdown
- **Stated Problem Metric**: [Quantified business pain: e.g., Retail: stock discrepancy 10-15%; CRM: lost lead response rate 25%; CMS: article review bottleneck 4 days; HRIS: manual payroll discrepancy 12%]
- **Primary Root Causes ($\approx 80\%$)**: [Primary operational bottlenecks: e.g., manual untracked paper entry, unassigned follow-ups, untracked editorial revisions]
- **Secondary Root Causes ($\approx 20\%$)**: [Secondary friction points: e.g., notification delays, multi-branch coordination]
- **Problem-Solution Fit Rule**: Every Must-Have (P0) feature must directly address the primary $80\%$ root causes.

### 2.2 Realistic Business Growth Ramp
- **Year 1 Customer Target**: [e.g., 50–100 paying organizations (not fantasy 500 in Month 1)]
- **Projected MRR**: [e.g., Rp 5M – Rp 10M at Rp 99k/month]
- **Target D30 Retention**: [e.g., 30%–40% active after initial 30 days]
- **Modeled Customer Lifetime**: [e.g., 12–18 months based on SMB churn rates]

### 2.3 Non-Circular North Star Metric
- **North Star Metric**: [e.g., Active Tenant Rate = 70% of monthly active signed-up organizations record ≥5 operational transactions per week]

---

## 3. User Role Matrix & Approval Decision Tree (RBAC)

*(Adapt roles and permissions to your project domain. Examples:
- **Retail / POS**: Owner, Store Manager, Cashier, Accountant
- **CRM / Sales**: Sales Director, Sales Manager, Sales Rep, Account Exec
- **HRIS / Payroll**: Super Admin, HR Manager, Department Head, Employee
- **CMS / Editorial**: Admin, Managing Editor, Author, Contributor
- **Small MVP / Internal**: Administrator, Standard User)*

### 3.1 Role Permission Matrix

| Role Code | Role Name | Create | Read | Update | Delete / Void / Archive | Special Permissions & Domain Guardrails |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **ROL-01** | [Super Admin / Owner] | All resources | All scopes / tenants | All resources | Soft-delete / Void only (Immutable audit trail) | Full system administration, billing, team management, audit reports |
| **ROL-02** | [Manager / Reviewer] | Operational items | Assigned scope/branch| Assigned items | State transitions / voids | Approval authority over threshold; **ZERO SELF-APPROVAL** on own submissions |
| **ROL-03** | [Staff / Operator / Rep]| Primary tasks only | Assigned work items | Own active records | None (escalate to ROL-02) | Execution-only access; sensitive cost/margin/salary fields strictly hidden |
| **ROL-04** | [Auditor / Viewer / Client]| None | Target reports / data | None | None | Read-only inspection; export privileges (PDF/Excel) |

### 3.2 Workflow Approval Decision Tree (Domain-Conditional)
*(Define multi-tier approval rules for sensitive actions. Mark N/A for single-user Small MVP tools)*
```text
[Action Triggered by Operator] ──► Approval Routing
├── Standard Request (Within Threshold) ──► ROL-02 (Manager) Approval
├── High-Value / High-Risk Request     ──► ROL-01 (Admin/Owner) Approval
├── Self-Created Request by ROL-02      ──► Escalates to ROL-01 (NO SELF-APPROVAL)
└── Emergency / Standard Action         ──► Auto-Approved with audit log
```

---

## 4. Functional Scope Breakdown (MoSCoW)

*Feature inventory allocated across MoSCoW tiers. Respect scale-based limits (Small: 3–7 Must; Medium: 8–15 Must; Large: 16–25 Must; Enterprise: 26–40 Must):*

| Feature ID | Module | Functional Description | Priority | Root Cause Addressed | Acceptance Criteria |
| :--- | :--- | :--- | :---: | :--- | :--- |
| **F-01** | [Core / Auth] | [User authentication, session handling, RBAC] | **Must** | Baseline security | Session management, role access enforcement |
| **F-02** | [Primary Domain] | [Core entity CRUD, search, validation] | **Must** | Primary problem (80%) | Data integrity rules, duplicate prevention |
| **F-03** | [Core Workflow] | [Primary operational flow, state transitions] | **Must** | Primary bottleneck (80%)| Role authorization gates, audit log emission |
| **F-04** | [Monetization / Ops]| [Billing engine, subscription / internal admin (or N/A)] | **Must** | Operational sustainability| Trial guards, grace period, manual override |
| **F-05** | [Compliance / Export]| [Offboarding flow, data export, CSV sanitization] | **Must** | Regulatory compliance | One-click export, sanitizes spreadsheet triggers |
| **F-06** | [Secondary Workflow]| [Advanced filtering, batch processing, summary reports] | **Should** | Operational efficiency | Fallback manual workaround available |
| **F-07** | [Integrations / Alert]| [Third-party webhooks, external notifications] | **Could** | Value enhancement | Scheduled if development runs ahead of time |
| **F-08** | [Deferred Scope] | [Multi-currency, mobile native app, AI copilot] | **Won't** | Post-launch deferral | Formally deferred to Phase 2 |

---

## 5. Strict Scope Boundaries, Tax & Legal Compliance

### 5.1 In-Scope (Work DELIVERED by Developer)
1. Architectural design, database schema, RLS policies, and responsive web UI for Must-Have and Should-Have features.
2. Integration with cloud database and encrypted asset storage.
3. Automated staging deployment per pull request and production deployment setup.
4. User manual documentation for administrators and operational staff.

### 5.2 Out-of-Scope (Work NOT INCLUDED & Cannot Be Demanded)
1. **Manual Data Entry**: Digitizing physical paper documents or parsing corrupted legacy spreadsheets.
2. **Third-Party API Fees**: Payment gateway processing fees, SMS/WhatsApp gateway charges, and cloud compute tiers.
3. **Hardware & Local Network**: Computers, routers, thermal printer driver troubleshooting, or local connectivity.
4. **Legal & Tax Advisory**: Developer provides technological execution; formal tax filing and legal compliance remain client responsibility.
5. **Out-of-Scope User Segments**: Segments requiring unbuilt features (e.g., Cafes requiring Bill of Materials) are formally excluded from MVP scope.

### 5.3 Tax Calculation Disclaimers (PP 55/2022)
- Regulatory basis: **PP 55/2022** (replaces PP 23/2018) with Rp 500.000.000/year non-taxable threshold for individual taxpayers.
- Mandatory In-App Disclaimer: *"Perhitungan pajak bersifat estimasi operasional dan tidak menggantikan pelaporan resmi pada DJP. PPN tidak diperhitungkan (non-PKP)."*

### 5.4 Mandatory Data Privacy Compliance (UU PDP No. 27/2022)
- [ ] **Privacy Policy & Terms of Service**: Prepared in M04, accepted upon signup.
- [ ] **Data Retention**: Accounting transaction records retained for 3 years (UU KUP compliance).
- [ ] **PII Scrubbing**: Error tracking (Sentry) configured to strip customer names, emails, and financial amounts.
- [ ] **CSV Injection Prevention**: All spreadsheet exports prepend `'` to formula triggers (`=`, `+`, `-`, `@`).

---

## 6. Technical Architecture & Database Schema Constraints

### 6.1 Database Schema Guardrails
- **Universal Tenant Isolation**: Every table includes `org_id UUID NOT NULL REFERENCES organizations(id)`.
- **Public Schema RLS**: RLS policies query `public.user_roles`, never the read-only auth schema.
- **Financial Precision**: Money stored as `DECIMAL(15, 2)`; `transaction_items` snapshots historical `unit_cost`.
- **Audit Trails**: Movements and transactions are append-only / void-only (no hard `DELETE`). `audit_logs` records all critical operations.
- **Column-Level Security**: Application layer filters out `buy_price` for Kasir queries.

### 6.2 Architecture Realism
- **Offline / Connectivity**: Online-only MVP with reconnection retry guards (offline sync deferred if locations $<3$).
- **Performance Budgets**: TTI $<5$ seconds on 3G; initial JS bundle $<200$ KB gzipped; API p95 $<500$ ms.
- **PDF Engine**: Client-side rendering via `@react-pdf/renderer` (avoids serverless Puppeteer timeout limits).
- **Tech Stack Locking**: Minor versions pinned (e.g., Next.js 15.0.x, React 19.0.x, Dexie 4.0.x).

---

## 7. Client Dependency Register (Dependency SLA)

| Dep Code | Client Requirement | Delivery Deadline | Consequence If Delayed |
| :--- | :--- | :--- | :--- |
| **DEP-01** | Payment gateway sandbox credentials & SMTP keys | Project Day 7 | Delay in billing & notification engine development |
| **DEP-02** | Master product data in structured CSV/Excel template | Project Day 10 | Postponement of seed data setup and testing |
| **DEP-03** | DNS domain access for custom domain routing | Project Day 21 | Postponement of production SSL setup |
| **DEP-04** | Formal written feedback on milestone reviews | Max 3 business days | Launch date pushes back by delayed days |

---

## 8. Realistic Timeline, Process Phasing & Beta Plan

- **M04 UI/UX Design**: 2–3 weeks (30–50 screens, extended state matrix, Privacy Policy & ToS).
- **M05 Architecture**: 1 week (ERD, data model, RLS SQL scripts).
- **M06 Development**: 8–12 weeks (includes 20% development buffer).
- **M07 QA & Testing**: 2 weeks (automated RLS tests + manual audit).
- **Change Request (CR) Freeze**: Strictly locked **2 weeks before QA starts**.
- **Phase 1.5 Window**: Scheduled strictly post-launch (Week 21+), never during QA.
- **Closed Beta Usability Testing**: 5 representative business owners recruited for 60-minute remote sessions during M07 Week 2.

---

## 9. Initial Scope Validation & Sign-Off

This document locks the baseline requirements for preparing the **Statement of Work (SOW), Contract Value, and Payment Milestone Schedule (Module 03)**.

- Validated by Solo Developer: **[Your Name]** (Date: [YYYY-MM-DD])
- Validated by Client PIC: **[Client PIC Name]** (Date: [YYYY-MM-DD])
