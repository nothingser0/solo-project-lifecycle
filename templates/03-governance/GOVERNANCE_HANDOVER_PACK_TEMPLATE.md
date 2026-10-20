# Governance Handover Pack

**Project:** [Project Name]
**Client:** [Client Company]
**Prepared by:** [Your Name]
**Date:** [YYYY-MM-DD]
**Version:** 1.0
**Output path:** `docs/governance/GOVERNANCE_HANDOVER_PACK.md`

> **This pack is a client deliverable, not an advisor obligation.** It transfers operational control of the system to the client's own IT organisation. After handover, the advisor's ongoing role is the conformance retainer — not day-to-day operation.
>
> This pack **assembles three existing documents rather than restating them**. Copy the operative content in; do not re-author it here and let the sources drift.

---

## 1. RACI — who decides what after handover

Source: `docs/governance/RACI_MATRIX.md`. Reproduce the matrix for the **operational** activities only — the project-delivery roles are retired at handover.

| Activity | Client IT | Client Business Owner | Advisor (retainer) | Vendor |
| :--- | :-: | :-: | :-: | :-: |
| Production deploy | **A/R** | I | C | C |
| Schema change | **A/R** | I | C | C |
| Incident: P1 | **A/R** | I | C | R |
| Incident: P3 | **A/R** | — | I | R |
| Access grant / revoke | **A/R** | C | I | — |
| Backup restore drill | **A/R** | I | C | — |
| Architecture conformance review | C | I | **A/R** | I |
| Vendor change request | C | **A** | C | R |

**A/R = accountable and responsible · C = consulted · I = informed.** Exactly one **A** per row. A row with two accountable parties has no owner.

**The load-bearing rows are deploy, schema change, and access grant.** If the client cannot name a human who is **A** for each of those three on the day this pack is signed, handover is not complete.

---

## 2. CAB — change advisory process

Source: `docs/governance/CAB_PROCESS.md`. Summarise the operative rules; keep the full document as the reference.

| Change class | Example | Approval required | Lead time |
| :--- | :--- | :--- | :--- |
| **Standard** | Config value within approved range, dependency patch | Pre-approved; log it | None |
| **Normal** | Feature deploy, schema migration (additive) | CAB approval | 2 business days |
| **Emergency** | Security patch, P1 fix | Duty approver, retrospective CAB | Same day, reviewed within 5 days |
| **Major** | Destructive migration, auth change, data deletion | CAB + business owner | 5 business days |

**Every change is logged with: what, who approved, when, rollback plan, and outcome.** The log is the audit trail; a change with no log entry did not have approval.

**Emergency is a lane, not a bypass.** The retrospective review within five days is what keeps the lane from becoming the default.

---

## 3. Disaster Recovery — operational readiness

Source: `docs/ops/DISASTER_RECOVERY_PLAN.md` (or `docs/architecture/` for the architecture-tier plan). The client IT team must be able to execute it without the advisor on the call.

| Item | Value | Verified |
| :--- | :--- | :-: |
| RPO (acceptable data loss) | | ☐ |
| RTO (acceptable downtime) | | ☐ |
| Backup cadence | | ☐ |
| Restore drill frequency | | ☐ |
| **Date of last successful restore drill** | | ☐ |
| Contact escalation path | | ☐ |
| Documented runbook location | | ☐ |

**A DR plan that has never been restored from is a plan, not a capability.** The row that matters is *date of last successful restore drill* — if it is empty, the client is inheriting an untested assumption. Run one drill before handover.

**On-call ownership** transfers with this pack: name the rotation, the escalation contact, and the paging mechanism.

---

## 4. Architecture Conformance Retainer

Post-handover, the advisor's standing role is to inspect vendor work at each sprint milestone for compliance with the architecture blueprints — **not** to operate the system.

| Item | Value |
| :--- | :--- |
| Review cadence | [e.g. monthly, or per sprint milestone] |
| Scope | Pull requests against `docs/architecture/ENTERPRISE_ARCHITECTURE_BLUEPRINT.md` and the ADR set |
| Authority | **Advisory** — the advisor reports findings; the client decides |
| Non-goals | No deploys, no production credentials, no sign-off that substitutes for the client's own |
| Exit trigger | Recorded in the retainer contract, not open-ended |

**State the non-goals explicitly.** A retainer that quietly acquires operational responsibility becomes the liability the handover existed to avoid.

---

## 5. Handover Sign-Off

| Item | Confirmed by | Date |
| :--- | :--- | :--- |
| RACI accepted; a named **A** exists for deploy, schema change, access grant | | |
| CAB process live; change log exists and is being written | | |
| DR plan executed at least once; restore drill passed | | |
| Retainer scope and non-goals agreed in writing | | |
| Access transferred: production, monitoring, backups, secrets manager | | |
| Advisor access **revoked** | | |

**The last row is part of handover, not a courtesy.** An advisor who retains production access after sign-off is a standing risk the client cannot see.
