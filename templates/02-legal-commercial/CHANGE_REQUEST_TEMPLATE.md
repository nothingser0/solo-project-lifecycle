# Change Request (CR) Form & Impact Assessment

> **Purpose**: Formal scope modification agreement for managing feature additions, workflow changes, or architectural adjustments requested after the `SCOPE_STATEMENT.md` baseline is locked.
> **Standard Rule**: No development begins on out-of-scope features until this Change Request is formally approved and financial terms are settled.
> **Target File Location**: `contracts/change-requests/CR-[YY]-[NNN].md` (or `docs/pm/CR-[YY]-[NNN].md`)

---

## 1. Change Request Metadata

- **CR Tracking ID**: CR-[YYYY]-[001]
- **Project Name**: [Project Name]
- **Associated SOW Reference**: `SOW_CONTRACT.md` (Dated [YYYY-MM-DD])
- **Associated Scope Statement**: `docs/pm/SCOPE_STATEMENT.md` (v1.0)
- **Request Date**: [YYYY-MM-DD]
- **Requested By (Client Single PIC)**: [Client PIC Name] ([Title])
- **Evaluated By (Developer)**: [Your Name]
- **Current CR Status**: `[SUBMITTED | EVALUATED | APPROVED | REJECTED | WITHDRAWN]`

---

## 2. Description of Requested Change

### 2.1 Problem / Business Justification
[Describe why the client is requesting this change and what business objective it solves]

### 2.2 Proposed Functional Delta
- **New Feature / Modification**: [Detailed specification of what needs to be added, modified, or removed]
- **Affected User Roles**: [e.g., Manager, Operator, End Customer]
- **Impacted Screens / Routes**: [e.g., SCR-04 Checkout, SCR-09 Dashboard]
- **Impacted Database Entities**: [e.g., `orders`, `transaction_logs`]

---

## 3. Impact Assessment (Technical, Timeline & Cost)

*Evaluation conducted by the Developer before approval:*

### 3.1 Engineering Effort Breakdown
| Task ID | Implementation Description | Est. Dev Hours | Est. Dev Days | Complexity |
|:-------:|:---------------------------|:--------------:|:-------------:|:----------:|
| T-CR-01 | Database migration & schema updates | 6 hrs | 0.75 days | Medium |
| T-CR-02 | Backend API endpoints & validation logic | 12 hrs | 1.5 days | Medium |
| T-CR-03 | Frontend UI state & error handling | 12 hrs | 1.5 days | Medium |
| T-CR-04 | Integration tests & regression verification | 6 hrs | 0.75 days | Low |
| **Total** | **Combined Engineering Effort** | **36 hrs** | **4.5 days** | — |

### 3.2 Timeline & Delivery Schedule Impact
- **Original Go-Live Date**: [YYYY-MM-DD]
- **Schedule Extension**: `+ [X] business days`
- **Revised Target Go-Live Date**: `[YYYY-MM-DD]`
- **Impact on Current Sprint / Milestone**: [e.g., Milestone 3 Beta pushed back by 1 calendar week]

### 3.3 Commercial & Financial Adjustment
- **Hourly / Daily Consulting Rate**: Rp [Amount] / day (or Rp [Amount] / hour)
- **Calculated Change Fee**: $\text{Dev Hours} \times \text{Rate} = \mathbf{Rp \text{ [Amount]}}$
- **Tax (PPN 11%)**: Rp [Amount]
- **Total Additional Invoice Value**: **Rp [Amount]** (including tax)
- **Payment Term**: [100% upfront before development starts / Added to next milestone invoice]

---

## 4. Alternative Options & Deferral Recommendations

If the client prefers to avoid schedule slip or additional cost:
- [ ] **Option A (Approved as CR)**: Implement immediately with agreed timeline extension and fee.
- [ ] **Option B (Trade-off Swap)**: Swap this feature with an existing Should-Have feature (e.g., deferring Feature F-07 to Phase 2 to keep timeline neutral).
- [ ] **Option C (Phase 1.5 Deferral)**: Postpone this feature to Phase 1.5 (post-launch warranty/retainer), preserving the original MVP go-live date.

---

## 5. Formal Approval & Sign-Off

By signing below, the Client approves the functional delta, the associated cost adjustment, and the revised project go-live date.

| Client Single PIC Approval | Developer Confirmation |
| :---: | :---: |
| [Client Company Name] | Independent Software Consultant |
| **Name**: [Client PIC Name] | **Name**: [Your Name] |
| **Title**: [Designated Single PIC] | **Title**: Lead Software Engineer |
| **Decision**: `[ APPROVED / REJECTED ]` | **Status**: `[ ACCEPTED ]` |
| Date: _____________________ | Date: _____________________ |
