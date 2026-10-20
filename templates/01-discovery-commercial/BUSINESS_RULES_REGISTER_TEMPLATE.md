# Business Rules Register

> **Module**: M02 (Scope Lock) & M05 (Architecture Specs)
> **Purpose**: Capture the constraints the organisation imposes on *any* implementation, separately from features. A business rule must survive a UI redesign; a feature does not.
> **Output Location**: `docs/pm/BUSINESS_RULES_REGISTER.md`
> **Why separate from the requirement matrix**: `REQUIREMENT_MATRIX_TEMPLATE.md` traces features to screens and endpoints. Rules have no screen — they have a source (regulation, policy, named decision-maker) and an enforcement point (validation, constraint, approval gate).

---

## 1. Rule Classification

Classify every rule before writing it. The class decides where it is enforced and how it is tested.

| Class | Example | Enforced at | Verified by |
| :--- | :--- | :--- | :--- |
| **Regulatory** | Tax invoice must carry a 16-digit NPWP | Validation + stored field | Assertion against the cited instrument |
| **Policy** | Discount > 15% requires manager approval | Workflow gate + RBAC | Approval-path test with two roles |
| **Domain invariant** | Stock can never go negative | DB constraint + transaction | Concurrency test |
| **Commercial** | Refund only within 7 days of settlement | Service logic + status check | Time-travel / seeded-date test |
| **Derived** | Gross margin = revenue − COGS snapshot | Computation | Arithmetic assertion on a fixture |

---

## 2. Rule Register

| Rule ID | Rule Statement (testable) | Class | Source (instrument / document / decision-maker) | Confidence | Applies To | Exceptions | Enforcement Point | Status |
| :--- | :--- | :--- | :--- | :---: | :--- | :--- | :--- | :--- |
| **BR-001** | A tax invoice is only issued when the order status is `PAID` | Regulatory | PP 55/2022 jo. PP 20/2026 | ✅ | Orders, Invoices | None | Service guard + DB CHECK | SPECIFIED |
| **BR-002** | A discount above 15% requires approval by a role other than the requester | Policy | Client PIC decision, 2026-10-19 | ✅ | Discounts | Owner-role auto-approval | Approval gate + zero-self-approval check | SPECIFIED |
| **BR-003** | `products.stock` can never be negative | Domain invariant | Business owner | ✅ | Inventory | Supervisor override with audit entry | DB CHECK + row lock | SPECIFIED |
| **BR-004** | A refund is only allowed within 7 calendar days of settlement | Commercial | SOW §4.2 | 🔶 | Refunds | Discretionary goodwill credit | Status + timestamp check | SPECIFIED |

**Confidence legend**: ✅ VERIFIED (source cited, readable) · 🔶 ASSUMPTION (registered, unverified) · ❓ UNKNOWN (blocks scope lock).

---

## 3. Rule Authoring Rules

1. **One rule per row.** A row containing "and" is usually two rules.
2. **Testable wording.** "Discounts require approval" is not a rule; "a discount above 15% requires approval by a role other than the requester" is.
3. **Cite the source.** A rule with no source is an opinion. If the source is a person, name the role and the date.
4. **Name the exceptions.** A rule without stated exceptions will be treated as absolute, then broken silently in production.
5. **Mark unverifiable sources** 🔶 and carry them into the assumption register — never upgrade a guess to a rule.
6. **No rule from a UI screenshot.** Reverse-engineering rules from a mock-up produces rules that change when the UI changes.

---

## 4. Conflict Check

Run this before scope lock. Rules conflict more often than features do.

| Check | Question | Finding |
| :--- | :--- | :--- |
| **Rule vs rule** | Do two rules produce contradictory outcomes for the same input? | |
| **Rule vs NFR** | Does an audit rule make the latency target unachievable? | |
| **Rule vs scope** | Is a rule in scope with no feature to enforce it? | |
| **Rule vs regulation** | Does a commercial rule contradict a cited instrument? | |
| **Orphan rule** | Is a rule enforced by nothing (no validation, constraint, or gate)? | |

An **orphan rule** is the most dangerous finding: the organisation believes it is enforced, and nothing enforces it.

---

## 5. Sign-Off

- **Rules reviewed by**: [Client Single PIC / human owner] — a business rule is a business decision, never an agent's call
- **Date**: [YYYY-MM-DD]
- **Scope version covered**: [commit / SCOPE_STATEMENT version]

> Any rule added after this line requires a Change Request or a documented scope note.
