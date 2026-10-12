# Project Closure Report

> **Purpose**: Formal end-of-project report delivered **to the client** at closure — the counterpart to the internal `PROJECT_RETROSPECTIVE_TEMPLATE.md`. The retrospective is for you; this is for the stakeholders who paid for and will live with the system.
>
> **When**: after M11 (BAST + final payment cleared) and before warranty expires. Deliver alongside the signed BAST — not instead of it.
> **Audience**: Client Single PIC, sponsor, and the operations team who inherit the system. Keep it non-technical where possible; link to technical artifacts instead of inlining them.
> **Owner**: the **human developer** sends this. The AI agent may draft it; it must not send, sign, or present it as final without human approval.

**Project**: [Project Name]
**Client**: [Client/Company Name]
**Client Single PIC**: [Name, Role]
**Contract Reference**: [SOW/SPK number, dated YYYY-MM-DD]
**Report Date**: [YYYY-MM-DD]
**Report Version**: [1.0]

---

## 1. Executive Summary

Two or three paragraphs a non-technical sponsor can read alone:

- **What was delivered**: [system name + one-line purpose]
- **Was the objective met**: [yes / partially / no — with the honest qualifier]
- **Date live**: [YYYY-MM-DD]
- **Final contract status**: [amount, milestones settled, any outstanding balance]
- **Outstanding items**: [none / list with owner and date]

> ⚠️ Write this **after** confirming settlement. A closure report delivered before final payment weakens M11's "No Pay, No Root" leverage.

---

## 2. Objectives vs. Results

State the objective **as it was written in the SOW** — not as it ended up. Variance is normal; unexplained variance is not.

| # | Objective (per SOW) | Success Measure | Result | Status |
| :--- | :--- | :--- | :--- | :--- |
| 1 | [objective] | [metric/target] | [actual] | Met / Partial / Deferred |
| 2 | [objective] | [metric/target] | [actual] | Met / Partial / Deferred |
| 3 | [objective] | [metric/target] | [actual] | Met / Partial / Deferred |

- **Fully met**: [N of M]
- **Partially met** (with reason): [list]
- **Deferred to warranty/next phase**: [list — must match the Change Request log, never invented here]

---

## 3. Deliverables Handover

| Deliverable | Type | Location | Status |
| :--- | :--- | :--- | :--- |
| Source code | Git repository | [repo URL — ownership transferred? Y/N] | ✅ |
| Live application | URL | [https://app.client.com] | ✅ |
| `USER_MANUAL.md` | Document | [path] | ✅ |
| Operations runbook | Document | [path] | ✅ |
| Credentials inventory | Encrypted handover | [vault reference — **never inline secrets**] | ✅ |
| Test evidence | QA/SIT/UAT artifacts | [path] | ✅ |
| Signed BAST | Contract | [path/reference] | ✅ |

- **Third-party accounts**: registered under [client's name — confirm, per M03 "never on developer credit cards"]
- **Repository ownership**: [transferred to client org on YYYY-MM-DD / retained pending X]

---

## 4. Schedule & Effort

| Item | Planned | Actual | Variance | Reason |
| :--- | :--- | :--- | :--- | :--- |
| Duration | [X weeks] | [Y weeks] | [+/− Z] | [reason if >20%] |
| Milestones met on time | [N of M] | — | — | [reason] |
| Change Requests raised | — | [N] | +Rp [total] | [summary] |

Be factual. If the project slipped, say why in one sentence — clients accept a clear cause far better than a vague one.

---

## 5. What Was Delivered Well

Three to five concrete strengths, tied to something the client can see:

- [e.g. "Order processing flow runs end-to-end with real payment gateway, verified in production PVT on YYYY-MM-DD"]
- [e.g. "All 22 polish-audit tells cleared on the live domain before launch"]
- [avoid generic praise — point at evidence, not adjectives]

---

## 6. Known Limitations & Deviations

This section protects both sides. Anything a reasonable operations person could trip over belongs here.

| Limitation | Impact | Workaround | Status |
| :--- | :--- | :--- | :--- |
| [e.g. offline mode not implemented] | [must be online to sync] | [retry on reconnect] | Deferred — CR-X |
| [e.g. browser support = last 2 versions] | [older browsers unsupported] | [use current Chrome/Edge] | By design |
| [e.g. report export capped at 10k rows] | [large exports split] | [filter by date range] | By design |

- **Explicitly out of scope** (per `SCOPE_STATEMENT.md` exclusions): [legacy digitization, third-party licensing, local hardware/network faults, formal legal/tax counsel]
- **Data accuracy**: figures produced by the system are estimates unless independently verified — [state the disclaimer exactly as approved, and confirm legal review status: `LEGAL-REVIEW: REVIEWED by <name> on <date>` if tax/legal text was published]

---

## 7. Warranty & Support Period

| Item | Term |
| :--- | :--- |
| Warranty start | [YYYY-MM-DD — the BAST date] |
| Warranty end | [YYYY-MM-DD — 30/60/90 days per contract] |
| Coverage | [bug fixes for delivered scope only — no new features] |
| Response commitment | [per WARRANTY_POLICY / SLA tier — or "none; best-effort"] |
| Out-of-warranty | New features → Change Request; retainer options: [Bronze/Silver/Gold reference] |
| Official support channel | [email / one coordination group — **not personal numbers outside working hours**] |

- **Client's obligations**: rotate all handed-over passwords within 7 days (`HANDOVER_PROTOCOL.md`); report bugs via the official channel.
- **Warranty is void for**: third-party server/API changes, client-side configuration changes, and modifications made by parties other than the developer.

---

## 8. Lessons Learned (Client-Facing)

Keep this short and useful — the deeper internal version stays in the retrospective.

| What worked | What to change next time |
| :--- | :--- |
| [e.g. early data handover from client ops sped up M08] | [e.g. confirm master-data format earlier, before ETL build] |

---

## 9. Handover Checklist (confirm before sending)

- [ ] All deliverables in §3 physically handed over and accessible to the client.
- [ ] Credentials delivered via encrypted channel; **no secrets appear in this document**.
- [ ] Final payment received and confirmed in the bank account before repo/root transfer.
- [ ] Signed BAST attached or referenced.
- [ ] Warranty dates recorded and match `WARRANTY_POLICY.md`.
- [ ] Change Request log reconciled — nothing in §2 says "deferred" that isn't in a CR.
- [ ] Legal-review marker resolved if any legal or tax text was published.

---

## 10. Sign-Off

| Acknowledged by Client Single PIC | Submitted by Developer |
| :--- | :--- |
| **Name**: [name] | **Name**: [name] |
| **Role**: [role] | **Role**: Solo Software Engineer |
| **Date**: [YYYY-MM-DD] | **Date**: [YYYY-MM-DD] |

> Acknowledgement records receipt of this report and of the deliverables in §3. It does not replace the BAST, which remains the contractual acceptance document.
