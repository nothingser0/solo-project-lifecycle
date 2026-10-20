# Requirements Register (Functional / Non-Functional / Business Rule / Constraint)

> **Module**: M02 (Scope Lock) & M05 (Architecture Specs)
> **Purpose**: A single register that keeps the four requirement types separate. Collapsing them is why business rules get "tested" by UI tests and NFRs get verified by clicking a page.
> **Output Location**: `docs/pm/REQUIREMENTS_REGISTER.md`
> **Relationship to `REQUIREMENT_MATRIX_TEMPLATE.md`**: the matrix traces a requirement *to* screens/endpoints/tests. This register classifies a requirement *as* a type and gives it a verifiable statement. Use the matrix when you need traceability; use this register when you need to know what kind of thing you are building.

---

## 1. The Four Types (do not merge them)

| Type | Prefix | Definition | Verified by |
| :--- | :--- | :--- | :--- |
| **Functional** | `FR-` | The system does X when Y happens | A scenario (Given-When-Then) |
| **Non-functional** | `NFR-` | A measurable quality of *how* it does it | A measurement, not a click-path |
| **Business rule** | `BR-` | A constraint imposed by the organisation on any implementation | A rule test; must survive a UI redesign |
| **Constraint** | `CON-` | A boundary that cannot be moved | Inspection against the source |

**Test**: if the requirement changes when the UI is redesigned, it is `FR`. If it must hold regardless of the UI, it is `BR`. If it is a number about performance, availability, or capacity, it is `NFR`. If it is something you cannot change, it is `CON`.

---

## 2. Register

| ID | Type | Statement (testable) | Source | Priority | Acceptance criterion | Status | Notes |
| :--- | :--- | :--- | :--- | :---: | :--- | :--- | :--- |
| **FR-001** | Functional | A cashier can create a sale for a product with available stock | SCOPE §4.1 F-01 | P0 | AC-001: Given stock ≥ 1, when the cashier confirms, then an order is created and stock decrements by 1 | SPECIFIED | |
| **FR-002** | Functional | A manager can void a same-day sale from their own location | SCOPE §4.1 F-04 | P0 | AC-004 | SPECIFIED | |
| **NFR-001** | Non-functional | Order creation API responds at p95 ≤ 500 ms under 50 concurrent users | SCOPE §4.3 | P0 | Load test report, 50 VU, 30 s | SPECIFIED | Measured in M07 |
| **NFR-002** | Non-functional | Session expires after 24 h of inactivity on shared POS hardware | SCOPE §3 | P0 | Timed test with seeded clock | SPECIFIED | |
| **BR-001** | Business rule | A discount above 15% requires approval by a role other than the requester | `BUSINESS_RULES_REGISTER.md` BR-002 | P0 | AC-011: Given a 20% discount by a Kasir, when submitted, then the order enters `PENDING_APPROVAL` | SPECIFIED | Zero self-approval |
| **BR-002** | Business rule | Stock can never go negative | `BUSINESS_RULES_REGISTER.md` BR-003 | P0 | Concurrent-sale test: second sale fails cleanly | SPECIFIED | DB CHECK + row lock |
| **CON-001** | Constraint | Hosting region must be Indonesian | `ASSUMPTIONS_CONSTRAINTS.md` CON-001 | — | Provider region inspection | FIXED | UU PDP |

**Status legend**: `DRAFT` · `SPECIFIED` · `IN_DEVELOPMENT` · `TESTED` · `VERIFIED` · `DEFERRED` · `BLOCKED (reason)`.

---

## 3. Register Rules

1. **One statement per row.** If it contains "and", split it.
2. **Every row has a source.** A requirement with no upstream source is scope creep until a human authorises it.
3. **Every P0/P1 row has an acceptance criterion.** No criterion means it cannot be verified, which means it cannot be declared done.
4. **NFRs carry a number and a measurement method.** "Fast" is not an NFR; "p95 ≤ 500 ms measured by a 50-VU load test" is.
5. **Business rules cite an instrument or a named decision-maker**, never a UI screenshot.
6. **Deferred is a decision, not a gap.** `DEFERRED` rows must name the phase that picks them up.
7. **Ambiguous rows are `BLOCKED`, not `SPECIFIED`.** A row marked SPECIFIED while the wording is still arguable is how a pack passes review and fails delivery.

---

## 4. Completeness Audit (before scope lock)

Mark each category **absent / weak / deferred**. "Absent" is an oversight; "deferred" is a decision.

| Category | Status | Note |
| :--- | :---: | :--- |
| Actors and roles | | |
| Triggers and preconditions | | |
| Postconditions and state transitions | | |
| Data fields and validation | | |
| Permissions and access boundaries | | |
| Error handling and recovery | | |
| Non-functional targets | | |
| Support / operations | | |
| Reporting and auditability | | |
| Rollout and migration | | |
| Maintenance and deprecation | | |

---

## 5. Traceability Pointer

Every `FR` / `NFR` / `BR` row must appear in `REQUIREMENT_MATRIX_TEMPLATE.md` (or the RTM in `references/ba/REQUIREMENTS_TRACEABILITY_AND_RTM_GUIDE.md`) with a screen, endpoint, or test target. A register row with no matrix row is an orphan; a matrix row with no register row is unclassified.

---

## 6. Sign-Off

- **Scope lock decision**: `Scope-Lock-Decision: LOCKED | PENDING` (also recorded in `SCOPE_STATEMENT.md`)
- **Reviewed by**: [Client Single PIC / human owner]
- **Date**: [YYYY-MM-DD]
- **Blocked rows at lock**: [count] — each one named, each one owned
