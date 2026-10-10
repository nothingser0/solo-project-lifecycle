# Scope Statement & Requirements Breakdown

> Initial project scope agreement document resulting from requirements elicitation to lock functional boundaries prior to commercial contract signing and pricing estimation.

---

## 1. Project Metadata & Document Control
- **Project Name**: [Application / System Name]
- **Client / Stakeholder**: [Client Company / Organization]
- **Solo Developer / Consultant**: [Your Name]
- **Document Reference**: `docs/pm/IDEA_BRIEF.md` (v1.0)
- **Document Status**: `[DRAFT | IN_REVIEW | APPROVED | FROZEN]`
- **Defined Project Scale**: [Small (MVP, 3–7 Must) / Solo SaaS (8–15 Must) / Medium (8–15 Must) / Large (16–25 Must) / Enterprise]
- **Elicitation Completion Date**: [YYYY-MM-DD]
- **Last Modified**: [YYYY-MM-DD]

### Data Confidence Legend
| Icon | Level | Meaning | Rule |
|:--:|:--|:--|:--|
| ✅ | **VERIFIED** | Validated via client sign-off, live empirical user data, or formal statutory text |
| 🔶 | **ASSUMPTION** | Working operational hypothesis; must be confirmed before scope freeze |
| ❓ | **UNKNOWN** | Open requirement or technical uncertainty; blocks sprint scheduling |

### Change Control & Scope Freeze Protocol
- **Scope Freeze Rule**: Once this document is marked `APPROVED` (for SOW signing) or `FROZEN` (for M06 development), zero features may be added without a formal Change Request (CR).
- **Change Request (CR) Process**: Any scope modification requires: (1) Description, (2) Impact on dev days, (3) Budget adjustment, and (4) Written approval.

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

> ℹ️ **IN-SCOPE CLARIFICATION**:
> - **P0 (Must-Have)**: Strictly IN-SCOPE for **Phase 1.0 (MVP Go-Live)**.
> - **P1 (Should-Have)**: Strictly IN-SCOPE for **Phase 1.5 (Fast-Follow Post-Launch Release)**.
> - **P2 (Could-Have)**: OUT-OF-SCOPE for initial release; cataloged in Phase 2 Backlog.
> - **P3 (Won't-Have)**: Formally EXCLUDED from project deliverables.

### 4.1 MoSCoW Feature Inventory
*Respect scale limits: Small (3–7 Must), Medium/Solo SaaS (8–15 Must), Large (16–25 Must):*

| Feature ID | Module / Domain | Functional Description | Priority | Est. Effort (Days) | Root Cause Addressed | Target Release | Confidence |
| :--- | :--- | :--- | :---: | :---: | :--- | :---: | :---: |
| **F-01** | [Core / Auth] | [User authentication, session handling, RBAC] | **P0 (Must)** | 3 days | Baseline access & security | Phase 1.0 (MVP) | ✅ |
| **F-02** | [Primary Domain] | [Core entity CRUD, search, input validation] | **P0 (Must)** | 4 days | Primary problem (80%) | Phase 1.0 (MVP) | ✅ |
| **F-03** | [Core Workflow] | [Primary operational flow, transaction locking] | **P0 (Must)** | 5 days | Primary bottleneck (80%)| Phase 1.0 (MVP) | 🔶 |
| **F-04** | [Monetization / Ops]| [Billing engine, subscription / admin panel] | **P0 (Must)** | 4 days | Revenue sustainability | Phase 1.0 (MVP) | 🔶 |
| **F-05** | [Compliance / Export]| [Offboarding flow, data export, CSV sanitization] | **P0 (Must)** | 2 days | Statutory compliance | Phase 1.0 (MVP) | ✅ |
| **F-06** | [Secondary Workflow]| [Advanced filtering, batch processing, summary reports] | **P1 (Should)**| 3 days | Operational efficiency | Phase 1.5 | 🔶 |
| **F-07** | [Integrations / Alert]| [Third-party webhooks, external notifications] | **P2 (Could)** | 3 days | Workflow enhancement | Phase 2 Backlog | 🔶 |
| **F-08** | [Deferred Scope] | [Multi-currency, mobile native app, AI copilot] | **P3 (Won't)** | — | Non-essential scope | Excluded | ✅ |

### 4.2 User Stories & Acceptance Criteria (INVEST Standard)
*Document user stories for all P0 (Must) and P1 (Should) features:*

#### Feature F-01: [Feature Name, e.g., Role-Based Authentication & Session Management]
- **User Story**: As a [role], I want to [action], so that [benefit].
- **Acceptance Criteria**:
  - [ ] Given [valid credentials], when user logs in, then JWT cookie is set with `HttpOnly`, `SameSite=Lax`, and user is redirected to role dashboard.
  - [ ] Given [invalid role permissions], when user attempts accessing unauthorized route, then system redirects to `/403` and emits audit log.
  - [ ] Edge Case: Password reset tokens expire strictly after 15 minutes.

#### Feature F-02: [Feature Name, e.g., POS Checkout & Transaction Recording]
- **User Story**: As a [role], I want to [action], so that [benefit].
- **Acceptance Criteria**:
  - [ ] Given [scanned SKU], when product is added to cart, then system validates local stock balance and renders price formatted in IDR.
  - [ ] Given [completed transaction], when cashier submits payment, then stock balance decrements atomically and receipt data is emitted.
  - [ ] Edge Case: Offline transaction queued in IndexedDB if internet connectivity drops.

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

### 5.3 Tax Calculation Disclaimers (PP 55/2022 jo. PP 20/2026)
- Regulatory basis: **PP 55/2022 jo. PP 20/2026** (enacted 22 April 2026). The time limit for the 0.5% PPh Final facility is permanently eliminated, but the facility is **strictly restricted** to **Wajib Pajak Orang Pribadi (WP OP)**, **PT Perorangan**, and **Koperasi** with gross turnover $\le$ Rp 4.8 billion/year.
- Non-Eligibility: The 0.5% facility is **no longer eligible** for CV, Firma, PT Non-Perorangan, or BUMDes.
- Threshold: The **Rp 500.000.000/year non-taxable gross turnover threshold** applies strictly to individual taxpayers (WP OP).
- Mandatory In-App Disclaimer: *"Perhitungan pajak bersifat estimasi operasional dan tidak menggantikan pelaporan resmi pada DJP. PPN tidak diperhitungkan (non-PKP)."*

### 5.4 Mandatory Data Privacy Compliance (UU PDP No. 27/2022)
- [ ] **Privacy Policy & Terms of Service**: Prepared in M04, accepted upon signup.
- [ ] **Data Retention**: Accounting transaction records retained for 3 years (UU KUP compliance).
- [ ] **PII Scrubbing**: Error tracking (Sentry) configured to strip customer names, emails, and financial amounts.
- [ ] **CSV Injection Prevention**: All spreadsheet exports prepend `'` to formula triggers (`=`, `+`, `-`, `@`, `\t`, `\r`, `\n`, `|`).

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
---

## Machine Validation Summary (M02 Scope Lock)

```text
Scope-P0-Count: [number]
Scope-Lock-Decision: PENDING
```

*(Options: LOCKED | PENDING. Machine validator rejects M02 if P0 count falls outside scale limits (Small 3-7, Medium 8-15, Large 16-25), if ambiguous terms exist in Must-Have rows, if Out-of-Scope has fewer than 3 explicit exclusions, or if the Data Confidence Legend is absent).*

---

- Validated by Client PIC: **[Client PIC Name]** (Date: [YYYY-MM-DD])
