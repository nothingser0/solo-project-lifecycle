# Vendor Procurement Schedule

**Project:** [Project Name]
**Client:** [Client Company]
**Prepared by:** [Your Name]
**Date:** [YYYY-MM-DD]
**Output path:** `docs/procurement/VENDOR_PROCUREMENT_SCHEDULE.md`

> Companion to `docs/governance/VENDOR_COMPARISON_MATRIX.md` (which vendor) — this document is **when and how** the selection happens.

---

## Procurement Scope

What is being procured, and what is explicitly not. A schedule that does not name its boundary becomes an open-ended obligation.

| Item | In scope | Notes |
| :--- | :---: | :--- |
| Implementation vendor | ☐ | Builds and operates the system |
| Managed infrastructure | ☐ | Cloud, database, queue |
| Identity provider | ☐ | SSO, MFA, directory sync |
| Payment gateway | ☐ | Merchant account, settlement |
| Security assessment | ☐ | Third-party pentest |
| Support / retainer | ☐ | Post-handover operations |

**Explicitly out of scope:** [e.g. hardware procurement, end-user devices, network cabling]

**Why now:** the procurement must complete before [milestone] because [dependency — e.g. "M05 architecture cannot lock the stack until the identity provider's protocol support is known"].

---

## Timeline

Dates are **commitment dates**, not aspirations. A schedule without a decision gate is a wish list.

| # | Stage | Start | Decision gate | Owner | Blocks |
| :-: | :--- | :--- | :--- | :--- | :--- |
| 1 | Requirements finalised | | written requirements signed off | | 2 |
| 2 | RFP issued to shortlist | | RFP sent, receipt confirmed | | 3 |
| 3 | Vendor Q&A window | | all questions answered in writing | | 4 |
| 4 | Proposals received | | submission deadline passed | | 5 |
| 5 | Evaluation and scoring | | comparison matrix complete | | 6 |
| 6 | **Vendor selected** | | selection recorded in ADR + matrix | | 7 |
| 7 | Contract executed | | countersigned contract on file | | 8 |
| 8 | Onboarding / handover | | access granted, SLA start date agreed | | — |

**The decision gate is the deliverable of each stage.** A stage that "has been worked on" but produced no recorded decision has not completed, and the next stage must not start.

**Parallel-safe stages**: 3 and 4 overlap legitimately. 5 must not start before 4 closes — evaluating partial proposals biases the comparison toward whoever replied first.

---

## Requirements

Three tiers, because a single flat list makes every criterion equally important and the comparison subjective.

### Mandatory (a vendor failing any of these is disqualified)

| # | Requirement | Verification method |
| :-: | :--- | :--- |
| M1 | [e.g. Data residency in Indonesian territory] | Contractual commitment + hosting documentation |
| M2 | [e.g. SOC 2 Type II or ISO 27001 certification] | Certificate on file, not a marketing page |
| M3 | [e.g. Ability to export all data in an open format on exit] | Documented API or export format |
| M4 | [e.g. Incident notification within 24 hours] | Contract clause |

**Disqualification is not a negotiation position.** A vendor that fails M1–M4 is out, regardless of price.

### Scored (weighted in the comparison matrix)

| # | Requirement | Weight | What a good answer looks like |
| :-: | :--- | ---: | :--- |
| S1 | [e.g. Implementation timeline] | 25% | Named team, dated plan |
| S2 | [e.g. Relevant domain experience] | 20% | Two referenceable projects in the same regulated sector |
| S3 | [e.g. Total cost of ownership over 3 years] | 30% | All-in, including exit |
| S4 | [e.g. Support responsiveness] | 15% | Stated SLA with credits |
| S5 | [e.g. Team continuity] | 10% | Named individuals with commitments |

**TCO must include the exit.** A three-year cost that stops at delivery hides the migration the client will eventually pay for.

### Nice to have (no weight; recorded for negotiation)

- [e.g. Existing integration with the client's accounting system]
- [e.g. Local support in the client's timezone]

---

## Anti-Conflict Rule

The advisor preparing this schedule **must not** bid for the work, and must not receive any vendor commission or referral fee.

**Declare it in writing** next to the schedule, and name any commercial relationship with a shortlisted vendor — including prior employment, equity, or a referral arrangement. An advisor who both specifies and supplies has an unmanageable conflict, and the client cannot detect it from the documents.

---

## Vendor Exit Strategy

Requirements that keep the client able to leave, stated before the contract is signed because they cannot be negotiated afterwards:

| Requirement | Why it must be contractual |
| :--- | :--- |
| Open schema contracts, documented | Swap vendors without rewriting the database |
| Full data export on demand, in a documented format | Preventing hostage-taking |
| No proprietary lock-in in the data model | The lock-in that costs the most to unwind |
| Source-code escrow or repository handover terms | Continuity if the vendor fails |
| Named exit/transition assistance period | Nobody leaves on day one |

**If a vendor refuses any of these, that refusal is the finding** — record it and escalate before selection, not after.
