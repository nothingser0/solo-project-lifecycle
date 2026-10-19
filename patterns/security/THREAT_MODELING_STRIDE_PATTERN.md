# Threat Modeling — STRIDE Behind Every Trust Boundary

**When to use:** during architecture (M05), once the data flow is known and before code exists. Re-run when the trust boundaries change — a new external service, a new role, a new data store.

**When not to use:** on a three-route app with one external boundary. A threat model whose output restates the OWASP checklist is ceremony, not analysis. Below ~3 trust boundaries, the checklist in `templates/06-qa-uat/SECURITY_AUDIT_TEMPLATE.md` §3 is enough.

**The trap this pattern exists to prevent:** a threat model that assigns severity to threats it never validated. Threats found by reading a design are **candidates**. A candidate becomes a confirmed record only after reproduction. Severity on an unvalidated candidate is fiction with a number attached.

---

## 1. Number the elements first

A threat model that cannot point at a specific element produces advice, not findings. Draw the data flow, then give every element a stable ID.

| Element | Prefix | Example |
| :--- | :--- | :--- |
| External interactor | `EI` | `EI01` |
| Process | `P` | `P01` |
| Data store | `DS` | `DS01` |
| Data flow | `DF` | `DF01` |
| Trust boundary | `TB` | `TB01` |

Threat ID: `T-{STRIDE}-{ElementID}-{NNN}` — e.g. `T-S-P01-001` is the first spoofing threat against process 01.

**Why the ID matters:** later artifacts cite it. A finding in the security audit, a mitigation in the backlog, and a test case all reference `T-S-P01-001`, so a threat can be traced from design to verification to closure. Without IDs, threats get discussed once and forgotten.

---

## 2. Draw the boundaries

A trust boundary is where the level of trust changes — the browser to the server, the server to a third-party API, an app process to its database, an admin console to the user application.

**Every data flow that crosses a boundary needs a named entry point**: what input does the attacker control, and what check sits at that gate?

| Data flow | Crosses | Attacker-controlled input | Check at the gate |
| :--- | :--- | :--- | :--- |
| `DF03` | `TB01` (internet → app) | Request body, headers, path | Auth middleware, schema validation |
| `DF07` | `TB02` (app → DB) | Query parameters | Parameterized statements, RLS |

A flow with no entry point is either missing from the diagram or unprotected. Decide which — both are findings.

---

## 3. Apply STRIDE to each element

STRIDE asks six questions per element. It is a checklist for *generating* threats, not for grading them.

| Letter | Threat | The control that answers it | Check it in |
| :--- | :--- | :--- | :--- |
| **S** | Spoofing | Authentication — identity is proven | `SECURITY_AUDIT_TEMPLATE.md` §3 A07 |
| **T** | Tampering | Integrity — signing, checksums, parameterized writes | §3 A03, A08 |
| **R** | Repudiation | Audit logging — the action is attributable | §3 A09 |
| **I** | Information disclosure | Confidentiality — authorization, encryption, minimization | §3 A01, A02 |
| **D** | Denial of service | Availability — rate limits, quotas, timeouts | §3 A04, A05 |
| **E** | Elevation of privilege | Authorization — least privilege, role checks | §3 A01 |

| Element | S | T | R | I | D | E |
| :--- | :-: | :-: | :-: | :-: | :-: | :-: |
| `EI01` browser | — | — | — | — | ✓ | — |
| `P01` API | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| `DS01` users table | — | ✓ | — | ✓ | — | — |
| `DF03` request | ✓ | ✓ | — | ✓ | ✓ | — |

A cell is `—` when the threat does not apply **and you can say why**. That reasoning is the record; a bare `—` is an unexamined cell.

---

## 4. Consume or reject — the rule that makes it useful

Every threat identified ends in exactly one of two states:

- **Consumed** — it became a finding. It must then satisfy the six elements in `SECURITY_AUDIT_TEMPLATE.md` §4.5, or it is not a finding.
- **Explicitly rejected** — the design states why it does not apply, with a reason specific to this system.

> A threat that is neither consumed nor rejected is an **open question**, and open questions block a conclusion. "We noted it and moved on" is how a threat model becomes a document nobody reads.

---

## 5. Validate before you grade

| State | Meaning | Severity? |
| :--- | :--- | :--- |
| Reproduced in a lab | Attack executed, expected result observed | Yes — assign from the observed impact |
| Needs manual validation | Plausible, but the decisive fact is outside the code (proxy config, provider setting, identity policy) | **No** — record the missing fact and who can resolve it |
| Theoretical | Code path exists, never tested | **No** — a candidate, not a record |
| Ruled out | Mitigation present, or precondition cannot be met | **No** — recorded as rejected with the reason |

Only the first row gets a severity. A CVSS score on a theoretical threat is a number dressed up as evidence.

---

## 6. Scale it

| Scale | Output |
| :--- | :--- |
| **Small / MVP** | One table: elements, threats per element, one line per threat (consumed / rejected). Half a page. |
| **Medium / Client** | The element and boundary tables above, plus validation state per threat, referenced from the security audit. |
| **Large / Enterprise** | The above plus attack paths for the confirmed Critical/High threats, and a re-run triggered by any new trust boundary. |

The failure mode at every scale is the same: a long document with no IDs, no validation states, and no record of what was rejected.
