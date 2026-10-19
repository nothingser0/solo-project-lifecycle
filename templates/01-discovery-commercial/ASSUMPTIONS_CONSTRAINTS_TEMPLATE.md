# Assumptions & Constraints Register

> **Module**: M02 (Discovery & Scope) & M05 (Architecture Specs)
> **Purpose**: One visible register for the two things that silently invalidate a plan — assumptions that turn out false, and constraints that were never written down.
> **Output Location**: `docs/pm/ASSUMPTIONS_CONSTRAINTS.md`
> **Relationship to other artifacts**: `RISK_REGISTER_TEMPLATE.md` holds *risks* (things that may happen). This file holds *assumptions* (things you believe are already true) and *constraints* (things you cannot change). An assumption that fails becomes a risk; a constraint that is violated becomes a blocker.

---

## 1. Assumptions

An assumption is a belief you are treating as true without evidence. If it is false, work is wasted.

| ID | Assumption | Impact if false | Likelihood wrong | Validation approach | Owner | Status |
| :--- | :--- | :--- | :---: | :--- | :--- | :--- |
| **ASM-001** | Target users have a smartphone with ≥4 GB RAM | Core UI must be simplified; offline mode unusable | Medium | 5-user device survey during discovery | Human | ❓ OPEN |
| **ASM-002** | Client can provide master data as clean CSV within week 1 | Migration slips; M08 blocked | High | Request sample file at M03 signing | Client PIC | ❓ OPEN |
| **ASM-003** | Payment gateway sandbox supports QRIS simulation | SIT cannot verify settlement flow | Low | Verified in sandbox docs 2026-10-19 | Agent | ✅ VALIDATED |

**Status legend**: ❓ OPEN (unvalidated) · 🔶 TESTING (instrument in flight) · ✅ VALIDATED (evidence recorded) · ❌ DISPROVEN (plan must change).

### Assumption Rules
1. **Every ❓ OPEN assumption needs a validation approach and an owner.** An assumption nobody is testing is a guess with paperwork.
2. **Never let the agent validate its own assumption.** Evidence comes from a real source — a document, a sandbox response, or a named human (`docs/AUTHORITY.md`).
3. **A disproven assumption is a scope event**, not a footnote: route it to the Change Request process if it changes deliverables.
4. **Assumptions about human behaviour are the riskiest.** "Users will enter data daily" fails more often than any technical assumption.

---

## 2. Constraints

A constraint is a boundary you cannot move — technical, legal, commercial, or temporal.

| ID | Constraint | Type | Hard / Soft | Source | Design impact |
| :--- | :--- | :--- | :---: | :--- | :--- |
| **CON-001** | Hosting must be in an Indonesian region | Legal | Hard | UU PDP 27/2022 + client policy | Region-locked provider; no multi-region failover |
| **CON-002** | Must integrate with the client's existing MySQL 5.7 instance | Technical | Hard | Client infrastructure | No features requiring Postgres-specific types |
| **CON-003** | Launch before the client's fiscal year end | Temporal | Soft | Client PIC | Scope pruned to P0; P1 deferred to Phase 2 |
| **CON-004** | Budget ceiling Rp 40 M | Commercial | Hard | SOW | No paid third-party services beyond gateway fees |

**Type**: Legal · Technical · Commercial · Temporal · Operational · Organisational.
**Hard** = cannot be negotiated (a violation blocks delivery). **Soft** = negotiable with cost or timeline impact — state the trade.

### Constraint Rules
1. **A soft constraint must state what it costs to relax.** Otherwise it will be treated as hard, or ignored.
2. **Constraints are inherited, not invented.** A constraint with no source is a preference.
3. **Check constraints against architecture at M05.** A hard constraint discovered after the stack lock costs a rewrite, not a paragraph.
4. **Client-declared constraints are inputs, not decisions.** Record them; do not reinterpret them.

---

## 3. Dependency Watchlist

Constraints that depend on another party — the ones that actually slip.

| ID | Dependency | Provided by | Needed by | Status | Escalation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **DEP-001** | Payment gateway production KYC approval | Client + gateway | M10 go-live | ⏳ PENDING | Client PIC; fallback = manual bank transfer confirmation |
| **DEP-002** | Brand logo assets | Client | M04 Step 0.5 | ⏳ PENDING | Blocks all design artifacts — see M04 Step 0.5 |

> A dependency with no fallback and no escalation path is a schedule risk disguised as a task.

---

## 4. Review Cadence

- **M02 lock**: all assumptions have an owner; all hard constraints have a design impact recorded.
- **M05 sign-off**: every hard constraint is either satisfied by the architecture or explicitly flagged as a deviation.
- **M06 weekly**: any assumption that became ❌ DISPROVEN in the past week is reviewed for scope impact.
- **M09/M11**: the register is part of the handover pack — the client inherits the open assumptions.

---

## 5. Sign-Off

- **Register reviewed by**: [Client Single PIC / human owner]
- **Date**: [YYYY-MM-DD]
- **Open assumptions accepted at this date**: [count] — accepted by the same human, not by the agent
