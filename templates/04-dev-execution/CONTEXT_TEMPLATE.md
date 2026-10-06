# Business Context & Scope Governance (CONTEXT.md)

> **Purpose**: Definitive business context, domain logic rules, segregation of duties, closed-scope boundaries, and domain glossary to guide AI coding agent implementation.
> **Enforced Principle**: **The Closed Scope Rule** — Anything not explicitly enumerated in the In-Scope list is strictly **OUT OF SCOPE**. Agents MUST NOT hallucinate unrequested features.
> **Standard**: Domain-neutral architecture adaptable to CRM, CMS, HRIS, E-Commerce, Retail/POS, Fintech, and Developer Platforms across all 4 project scales.

---

## 1. Product Summary & Business Problem

- **Product / System Name**: [System / Application Name]
- **Target Domain**: [CRM / CMS / HRIS / E-Commerce / Retail POS / Fintech / B2B SaaS / Internal Tool]
- **Target Project Scale**: [Small (MVP) / Medium (SaaS) / Large / Enterprise]
- **Core Problem Solved**: [Quantified business pain: e.g. Retail: stock shrinkage 10–15%/mo; CRM: lost lead response rate 25%; CMS: review bottlenecks 4 days; HRIS: manual payroll discrepancy 12%]
- **Core Technological Solution**: [How this software deterministically resolves the primary problem]

---

## 2. Statutory, Legal & Domain Compliance (Conditional)

*(If statutory calculations, taxation, or regulated compliance are in scope, document exact rules. If project is non-statutory, e.g. CMS, mark N/A with rationale)*

### 2.1 Applicable Statutory Citations (Domain-Conditional)
*(Verify exact citations against current official government sources before implementation)*
- **Retail / SME Commerce Tax Example (Indonesia)**:
  - Regulatory basis: **PP 55/2022** (and subsequent official amendments, verify current legal text).
  - Entity distinction: Wajib Pajak Orang Pribadi (Rp 500M/year non-taxable threshold) vs Badan Usaha (0.5% from first Rupiah).
- **HRIS / Payroll Tax Example (Indonesia)**:
  - Regulatory basis: **PP 58/2023 & PMK 168/2023** (PPh 21 TER Categories A, B, C) + BPJS statutory formulas.
- **Non-Statutory Domains (CMS, CRM, DevTools, Internal Tools)**:
  - Status: **N/A** (No statutory calculations or financial tax filing in scope).

### 2.2 Mandatory Legal Disclaimers (In-App)
1. *"Kalkulasi sistem ini bersifat alat bantu estimasi operasional dan tidak menggantikan pelaporan resmi regulator atau nasihat profesional bersertifikasi."*
2. *"Sistem disediakan 'sebagaimana adanya' (as-is); pengguna bertanggung jawab penuh atas pencocokan fisik dan data yang diinput."*

---

## 3. Core User Loops & Segregation of Duties

### 3.1 Primary Interaction Flow (Core Loop)
*(Document the 3-step loop delivering core value)*
1. **Step 1 (Input / Trigger)**: [User action, e.g., Cashier scans barcode / Sales rep logs deal / Author submits draft]
2. **Step 2 (Processing / Mutation)**: [System executes atomic mutation, verifies state rules, records immutable journal]
3. **Step 3 (Output / Value)**: [Immediate tactile outcome, e.g., Receipt prints, stage updates, article published]

### 3.2 Operational Integrity & Exception Handling (Domain-Conditional)
*(Select the relevant domain pattern; mark others N/A with reasoned justification)*

#### A. Retail / Commerce / POS Scope (Conditional):
- **Cashier Transaction & Hardware Failures**:
  - If thermal printer runs out of paper or disconnects, the transaction record is ALREADY locked in database; receipt dialog provides a "Reprint Receipt" button without re-executing balance mutations.
- **Transaction Cancellation (Void Protocol)**:
  - Cashier (ROL-03) CANNOT void completed sales independently.
  - Void requires Manager (ROL-02) or Owner (ROL-01) authorization, with a mandatory reason note ($\ge 10$ chars).
  - The system creates a formal **reversal movement entry** in `inventory_movements` to restore stock, preserving full audit history.
- **Two-Phase Blind Count Opname & In-Flight Reconciliation**:
  - Staff physical count screens omit expected system quantities 100% to eliminate confirmation bias.
  - Reconciliation formula accounting for in-flight sales during active count:
    $$\text{Net Variance} = \text{Physical Count} - (\text{Snapshot Stock} - \text{In-Flight Sales} + \text{In-Flight Purchases})$$

#### B. CRM / Sales Pipeline Scope:
- **Deal Stage Transition Gates**: Deals cannot be marked "Won" without attached signed agreement and verified deal amount.
- **Orphan Record Guard**: Deleting companies/accounts requires re-assigning associated contacts and open tasks.

#### C. CMS / Editorial Scope:
- **Publishing State Machine**: `Draft` $\rightarrow$ `In Review` $\rightarrow$ `Scheduled` $\rightarrow$ `Published`.
- **Slug Immortality**: Title edits automatically generate permanent HTTP 301 redirects from old URLs.

#### D. Other Domains / Scrapers / Internal Tools:
- Document domain-specific failure recovery (e.g. proxy rotation, dead letter queues, rate limit backoff) or mark N/A.

---

## 4. User Role Matrix & RBAC Enforcement

*(Adapt roles to your project domain. Examples: Retail = Owner/Manager/Kasir/Akuntan; CRM = Admin/Manager/Rep; CMS = Admin/Editor/Author)*

| Role Code | Role Name | System Access Scope | Sensitive Data Masking | Mutation Authority |
| :--- | :--- | :--- | :--- | :--- |
| **ROL-01** | Super Admin / Owner | All tenant modules and settings | Full visibility (margins, revenue, costs, audit logs) | Full mutation authority, user management, billing |
| **ROL-02** | Manager / Reviewer | Assigned scopes / departments | Operational views; high-level summaries | Workflow approvals; **ZERO self-approval** on own requests |
| **ROL-03** | Staff / Operator / Rep | Execution interface only | **Completely hidden** (cost prices, salaries, margins) | Creates operational records; cannot void or delete |
| **ROL-04** | Auditor / Guest / Client| Read-only portal / statements | Audit log inspection / own records only | Read-only; zero mutation permissions |

---

## 5. Absolute Scope Boundaries & The Closed Scope Rule

> ⚠️ **CRITICAL DIRECTIVE: THE CLOSED SCOPE RULE**
> The AI Coding Agent is **STRICTLY FORBIDDEN** from inventing or implementing features outside the explicit In-Scope list. Any feature not listed under In-Scope is officially **OUT OF SCOPE**.

### 5.1 In-Scope (P0 & P1 Deliverables)
*(Populate with the approved features from `SCOPE_STATEMENT.md`)*
- `F-01`: [Core Authentication & Session Management]
- `F-02`: [Primary Resource CRUD & Validation]
- `F-03`: [Primary Operational Workflow & State Machine]
- `F-04`: [Reporting / Analytics / Export Sanitization]
- `F-05`: [SaaS Monetization / Billing Engine (or N/A for Internal Tools)]
- `F-06`: [Offboarding & Regulatory Data Deletion (or N/A for Small MVP)]

### 5.2 Out-of-Scope (PROHIBITED — Anti-Scope Creep Guardrails)
The AI agent MUST NOT implement any of the following capabilities unless explicitly authorized via a formal Change Request (CR):
1. **NO WhatsApp Chatbot / AI Agent Automation** (unless explicitly in P0 scope).
2. **NO Dynamic Payment Gateways / Custom Wallets** (stick strictly to specified payment provider or manual invoices).
3. **NO Loyalty Points / Gamification / Coupon Engines** (defer to Phase 2).
4. **NO Multi-Currency / International Tax Treaties** (stick strictly to primary currency and tax scope).
5. **NO Unrequested Multi-Language Localization** (stick strictly to primary project locale).
6. **NO Unbounded Third-Party Integrations** (no social media auto-posting, SMS blasts, or unmapped APIs).

---

## 6. Domain Glossary

*(Define domain-specific business terminology to prevent semantic drift)*

- **Append-Only Ledger**: A persistence model where historical records are immutable; balance mutations are recorded as new event rows, never via in-place overwrites.
- **Blind Count Opname**: An inventory audit procedure where physical counters are not shown expected system quantities, eliminating confirmation bias.
- **In-Flight Reconciliation**: An algorithmic calculation adjusting physical inventory counts for transactions executed while the counting session was underway.
- **Idempotency Key**: A unique client-generated UUID (v4) transmitted in mutation headers to ensure repeated network requests return the same response without duplicate side effects.
- **Security Definer**: A PostgreSQL function executing with the permissions of the function creator, hardened with `SET search_path = public, pg_temp STABLE`.
- **Soft Delete**: Setting a boolean flag (`is_active = false` or timestamp `deleted_at`) to hide records from active workflows while permanently preserving audit history.
- **Void Transaction**: An authorized administrative cancellation of a completed record that appends an offsetting reversal entry to the ledger.

---

## 7. Automated Quality Validation Checklist

*Before completing `CONTEXT.md`, verify:*

- [ ] **1. Closed Scope Rule Active**: The explicit mandate that unlisted features are out-of-scope is clearly articulated.
- [ ] **2. Domain-Appropriate Compliance**: Statutory rules cite official date-verified regulations or are marked N/A with rationale.
- [ ] **3. Segregation of Duties**: Operational roles are separated from review/approval roles with zero self-approval, or marked N/A for single-user tools.
- [ ] **4. Exception & Fallback Workflows**: Hardware and transaction failure fallbacks are defined where applicable, or marked N/A.
- [ ] **5. Definitive Domain Glossary**: Core technical and business terms are documented to prevent implementation misunderstandings.
