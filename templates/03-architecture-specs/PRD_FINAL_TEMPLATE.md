# Product Requirement Document (PRD) — Architecture & Functional Specification

> **Purpose**: Definitive technical requirements specification bridging `SCOPE_STATEMENT.md` and `DESIGN_SPEC.md` into concrete engineering rules, immutable state journals, mutation idempotency, database-level security, statutory compliance, and BDD release acceptance criteria.
> **Standard**: Zero naive sync assumptions, zero DOM-only security leaks, and mathematically verified domain logic across all project types (CRM, CMS, HRIS, E-commerce, Fintech, SaaS, Developer Tools).
> **Output**: `docs/specs/PRD.md`

---

## 1. Document Metadata
- **Product / System Name**: [System / Application Name]
- **Client / Organization**: [Client Company / Organization]
- **Lead Software Architect**: [Your Name]
- **Project Domain**: [CRM / CMS / HRIS / E-Commerce / Fintech / B2B SaaS / Developer Tool]
- **Defined Project Scale**: [Small (MVP) / Medium (SaaS) / Large / Enterprise]
- **Scope Reference**: `docs/pm/SCOPE_STATEMENT.md` (v1.0)
- **Design Reference**: `docs/specs/DESIGN_SPEC.md` (v2.1 Frozen)
- **Specification Version**: 2.0.0
- **Document Status**: [DRAFT / IN_REVIEW / APPROVED_FOR_BUILD]
- **Approval Date**: [YYYY-MM-DD]

### 1.1 Scale-Adaptive PRD Sizing Framework
*Adapt PRD depth and complexity based on project scale:*

| Scale Tier | Feature Count (P0/P1) | Target Document Depth | State Architecture | Security & Data Model |
| :--- | :---: | :---: | :--- | :--- |
| **Small (MVP / Internal)** | 3–7 features | Concise (3–5 pages) | Standard transactional tables with `created_at`/`updated_at`; simple audit log | Single-tenant or basic RLS; standard password hashing |
| **Medium (B2B SaaS / Agency)**| 8–15 features | Structured (10–20 pages) | State machine / event journal for core workflows; mutation idempotency | Multi-tenant `org_id` RLS; database view isolation; subscription billing |
| **Large (Scale-Up / Multi-System)**| 16–25 features | Comprehensive (20–35 pages)| Full append-only movement ledger / event sourcing; decoupled background workers | Location & role-scoped RLS; rate limiting; KMS encryption |
| **Enterprise (Corporate / Regulated)**| 26–40 features | Formal Enterprise (40+ pages)| Immutable audit vault; high-concurrency partitions; DR runbooks | SOC2 / ISO 27001 / UU PDP compliance; HSM keys; multi-tier CAB sign-off |

---

## 2. Functional Traceability Matrix (F-xx → REQ-xx → Screen / Endpoint ID)

> **TRACEABILITY RULE**: Every in-scope feature (`F-xx`) agreed in `SCOPE_STATEMENT.md` MUST map to an explicit Technical Requirement ID (`REQ-xx`) and a registered Screen ID (`SCR-xx`) or Backend Job/API ID (`API-xx` / `JOB-xx` for headless/background features). Zero untracked features allowed.

*(Populate with your project's actual features; sample rows below illustrate structure)*

| Feature ID | Technical Requirement ID | Functional Domain | Requirement Summary | Interface Screen / Endpoint ID |
| :---: | :--- | :--- | :--- | :---: |
| **F-01** | `REQ-01` | [Domain 1, e.g. Auth / Core] | [Primary capability description] | `SCR-001` or `API-001` |
| **F-02** | `REQ-02` | [Domain 2, e.g. Resource Mgmt]| [CRUD, validation rules, search & filtering] | `SCR-002`, `SCR-003` |
| **F-03** | `REQ-03` | [Domain 3, e.g. Workflow] | [State machine transitions, validation logic] | `SCR-004` |
| **F-04** | `REQ-04` | [Domain 4, e.g. Integration] | [Async processing, webhook / third-party sync] | `JOB-001` (N/A No UI) |
| **F-..** | `REQ-..` | ... | [All remaining in-scope features from SCOPE_STATEMENT] | `SCR-..` / `API-..` |

---

## 3. Append-Only Ledger & Immutable State Architecture

*(Architectural Pattern: Tailor complexity to project scale and domain risk)*

### 3.1 Failure Mode: Naive In-Place Overwrites
Overwriting entity states or balances directly via un-audited `UPDATE ... SET status = ...` or `UPDATE ... SET balance = balance - 1` destroys audit history, causes race conditions under concurrent writes, and prevents historical reconciliation.

### 3.2 Scale-Appropriate State Architecture
- **Small Scale (MVP / Simple Tools)**: Standard relational tables with `created_at`, `updated_at`, and a centralized `audit_logs` table. No complex event sourcing or CQRS projection pipelines required.
- **Medium / Large / Enterprise Scale**: Event-driven state journals or append-only movement ledgers where data integrity or financial accuracy is mission-critical:

### 3.3 Architectural Patterns for Medium / Large Scale
- **Core Principle**: All mutations are recorded as immutable, append-only journal entries. Current status or balance acts strictly as a **cached read-model projection**.

**Pattern A: Balance / Movement Ledger (Commerce / Inventory / Fintech)**:
```sql
CREATE TABLE inventory_movements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES organizations(id),
  location_id UUID NOT NULL REFERENCES locations(id),
  product_id UUID NOT NULL REFERENCES products(id),
  movement_type TEXT NOT NULL, -- 'INBOUND', 'OUTBOUND', 'ADJUSTMENT', 'TRANSFER'
  quantity DECIMAL(12, 3) NOT NULL,
  unit_cost DECIMAL(15, 2) NOT NULL, -- Snapshot of cost at time of mutation
  reference_id UUID NOT NULL,       -- FK to originating transaction/order
  created_by UUID NOT NULL REFERENCES auth.users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

**Pattern B: Entity Activity & State Transition Journal (CRM / CMS / SaaS)**:
```sql
CREATE TABLE entity_activity_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES organizations(id),
  entity_type TEXT NOT NULL, -- 'DEAL', 'ARTICLE', 'EMPLOYEE', 'PROJECT'
  entity_id UUID NOT NULL,
  previous_state TEXT,
  new_state TEXT NOT NULL,
  changes JSONB,             -- {"field": {"old": "val", "new": "val"}}
  performed_by UUID NOT NULL REFERENCES auth.users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

- **Cache Invalidation & Balance Rule**: Primary entities maintain a read-optimized cached status/balance column. Reconciliations and audits recalculate directly from raw journal records.

---

## 4. Mutation Idempotency & Interaction Safety

### 4.1 Idempotent Transaction Ingestion (Universal)
- Every balance mutation, checkout, payment, or critical status transition initiated from a client device MUST generate and transmit an `idempotency_key` (UUID v4) in request headers.
- **Server-Side Enforcement**:
  ```sql
  ALTER TABLE transactions ADD CONSTRAINT uq_transaction_idempotency UNIQUE (org_id, idempotency_key);
  ```
- If a network retry transmits an existing `idempotency_key`, the server returns the cached prior response with HTTP 200 without executing duplicated mutations.

### 4.2 Isolated Offline Sequencing (Conditional: Local-First / Field Ops)
*(Applicable if offline operation is in scope; mark N/A if online-only)*
- Prevent identifier collisions across disconnected devices:
  $$\text{Identifier} = \text{[NODE-ID]}-\text{[DEVICE-ID]}-\text{[YYYYMMDD]}-\text{[6-DIGIT-SEQ]}$$
- Terminals increment sequential numbers in local IndexedDB without cross-device locking.

### 4.3 Hardware Scanner & Keyboard Shortcut Mitigation (Conditional: POS / Barcode Hardware)
*(Applicable if physical scanners or cashier hardware are in scope; mark N/A for standard web apps)*
- **Hardware Trap**: Physical barcode scanners emit keyboard scan codes terminating in an automatic newline character (`\r` or `\n`), identical to `Enter`.
- **Protocol**:
  - `Enter` is bound strictly to **"Add Scanned Item to Cart"** or search lookup.
  - Submitting payment or executing checkout via `Enter` is **STRICTLY PROHIBITED**.
  - Final checkout is bound exclusively to dedicated function keys (e.g., `F4`) or explicit modal confirmation buttons.

---

## 5. Domain Logic Defense & Operational Integrity (Domain-Conditional)

*(Select the subsection matching your project domain; mark others N/A with reasoned justification)*

### 5.1 Retail / Inventory: Two-Phase Blind Count Opname
*(For projects tracking physical goods/warehouse balances; mark N/A if not applicable)*
- **Phase 1 (Blind Physical Count)**: Staff physical count interface physically omits system expected stock and variance columns from DOM and API responses to eliminate confirmation bias. Staff input physical quantities only.
- **Phase 2 (Variance Review)**: Supervisors review variance accounting for in-flight transactions during the active count. Any discrepancy requires an explanatory note of $\ge 10$ characters, with escalation to Owner for variances exceeding defined thresholds ($>Rp 1\text{M}$ or $>10\%$).

### 5.2 CRM / Sales Pipeline: Deal Stage Gates & Lead Integrity
*(For CRM / pipeline management projects; mark N/A if not applicable)*
- **Stage Transition Validation**: Deals cannot transition to "Won" without mandatory fields (deal value $>0$, signed contract attachment, close date).
- **Orphan Prevention**: Deleting a company or account does NOT hard-delete associated contacts or activities (enforce re-assignment or soft-delete).
- **Lead Duplicate Guard**: Matching rules on domain name and normalized phone prevent duplicate lead ingestion.

### 5.3 CMS / Publishing: Content Lifecycle & Slug Collisions
*(For CMS / editorial publishing platforms; mark N/A if not applicable)*
- **Editorial State Machine**: Strict lifecycle enforcement: `Draft` $\rightarrow$ `In Review` $\rightarrow$ `Scheduled` $\rightarrow$ `Published` $\rightarrow$ `Archived`.
- **Slug Immortality**: Changing article titles generates permanent HTTP 301 redirects from old URL slugs to prevent SEO broken links.
- **Concurrent Edit Lock**: Collaborative editing implements optimistic locking (`version` column) or heartbeat locks to prevent author overwrite collisions.

---

## 6. Multi-Layer Security Architecture & Database-Level Isolation

### 6.1 Database View Separation (Sensitive Field Protection)
Relying solely on frontend UI logic (`v-if` or conditional JSX) to hide sensitive business fields (cost prices, executive salaries, profit margins, deal values) is a critical security vulnerability. Network inspectors expose raw API payloads.

**Architectural Enforcement**:
```sql
-- Create role-restricted database view (e.g., operator / staff view):
CREATE VIEW products_public_view AS
SELECT
  id, org_id, sku, name, category_id, unit, sell_price, is_active, created_at
FROM products
WHERE is_active = true;
-- Sensitive cost/buy_price is completely excluded from database projection!
```
- API endpoints serving restricted roles query the restricted view directly.

### 6.2 Multi-Tenant / Organizational Row-Level Security (RLS)
```sql
CREATE POLICY tenant_isolation_policy ON transactions
FOR ALL USING (
  org_id = (SELECT org_id FROM public.user_roles WHERE user_id = auth.uid() LIMIT 1)
);
```

### 6.3 CSV & Spreadsheet Formula Injection Sanitization (Universal)
To prevent malicious code execution in Microsoft Excel / Google Sheets when exporting user-generated text:
```typescript
export function sanitizeSpreadsheetCell(value: string | null | undefined): string {
  if (!value) return '';
  const dangerousPrefixes = ['=', '+', '-', '@', '\t', '\r'];
  if (dangerousPrefixes.some(prefix => value.startsWith(prefix))) {
    return `'${value}`; // Prepend single quote to force plain text evaluation
  }
  return value;
}
```

---

## 7. Statutory & Sector Regulatory Compliance (Domain-Conditional)

*(If statutory, financial, or tax calculations are in scope, cite verified, date-checked regulations and disclaimers. If non-statutory, e.g. CMS/DevTools, mark N/A with rationale)*

### 7.1 Applicable Statutory Citations (If In Scope)
- **E-Commerce / SME Tax (Indonesia)**: PP 55/2022 (PPh Final 0.5% with Rp 500M annual non-taxable threshold for individual taxpayers).
- **HRIS / Payroll (Indonesia)**: PP 58/2023 & PMK 168/2023 (PPh 21 TER Categories A, B, C) + BPJS Ketenagakerjaan/Kesehatan.
- **Data Privacy (Universal)**: UU PDP No. 27/2022 / GDPR compliance (lawful data processing, user deletion rights, DPA agreements).

### 7.2 Mandatory Legal Disclaimers (In-App)
Display persistent in-app disclaimers:
1. *"Perhitungan ini bersifat alat bantu estimasi operasional dan tidak menggantikan pelaporan resmi regulator atau nasihat profesional bersertifikasi."*
2. *"Sistem disediakan 'sebagaimana adanya' (as-is); pengguna bertanggung jawab atas kebenaran data fisik yang diinput."*

---

## 8. Release Acceptance Criteria (Given-When-Then BDD — Universal)

*Every core functional module must specify testable BDD acceptance scenarios and boundary conditions:*

### 8.1 Scenario: Primary Entity Creation & Validation
```gherkin
Scenario: Operator creates new resource with valid inputs
  Given the authenticated user has "Editor" permissions
  And is on the creation screen "/[resource]/new"
  When the user inputs valid data and submits
  Then the submit button enters loading state
  And an immutable creation event is recorded in the activity log
  And the user is redirected to the detail view with a success toast notification
```

### 8.2 Scenario: State Mutation with Idempotency
```gherkin
Scenario: Client submits mutation with network retry
  Given an initial mutation request was dispatched with idempotency key "550e8400-e29b-41d4-a716-446655440000"
  And the server successfully processed the balance deduction
  When the client network times out and resends the exact same request with identical idempotency key
  Then the server returns the cached HTTP 200 response
  And zero duplicate balance deductions or records are created
```

---

## 9. Automated Quality Validation Checklist (PRD Exit Gate)

*Before finalizing `docs/specs/PRD.md`, verify:*

- [ ] **1. Full Traceability**: 100% of Scope Statement features are mapped in Section 2 to Technical Requirement IDs (`REQ-xx`) and Screen IDs (`SCR-xx`).
- [ ] **2. Immutable State Architecture**: State transitions and balance mutations use append-only event journals; direct un-audited overwrites are eliminated.
- [ ] **3. Mutation Idempotency**: State-changing requests enforce `idempotency_key` unique constraints, with keyboard safeguards against premature submission.
- [ ] **4. Domain Workflow Defense**: Operational failure modes (e.g. blind count for inventory, stage transition validation for CRM, editorial lock for CMS) are defended or marked N/A with rationale.
- [ ] **5. Database-Layer Security**: Sensitive fields are protected via database views/queries, with tenant-scoped RLS and CSV formula injection sanitization.
- [ ] **6. BDD Acceptance Scenarios**: Core business workflows and critical edge cases are specified in Given-When-Then format.
- [ ] **7. Verified Statutory Compliance (If Applicable)**: Applicable statutory formulas cite date-verified regulations with required disclaimers, or are marked N/A.

---

## 10. Technical PRD Sign-Off Sheet

By signing below, the Lead Software Architect and Client PIC confirm that all functional requirements, security boundaries, and release acceptance criteria documented herein are approved for technical implementation in Module 06.

| Approved by Client Single PIC | Validated by Lead Software Architect |
| :--- | :--- |
| **Name**: _________________________ | **Name**: _________________________ |
| **Role**: _________________________ | **Role**: Lead Software Architect |
| **Date**: [YYYY-MM-DD] | **Date**: [YYYY-MM-DD] |
| **Signature**: _____________________ | **Signature**: _____________________ |
