# Threat Model — STRIDE

**Project:** [Project Name]
**Prepared by:** [Your Name]
**Client:** [Client Company]
**Date:** [YYYY-MM-DD]
**Version:** 1.0
**Output path:** `docs/security/THREAT_MODEL_STRIDE.md`

> **This is a design document, not a test report.** It is produced during architecture, before code exists, and it is consumed by the security audit later. Method and rationale: `patterns/security/THREAT_MODELING_STRIDE_PATTERN.md`.
>
> **The rule that makes it useful:** every threat is either **consumed** (it becomes a finding, with the six elements in `templates/06-qa-uat/SECURITY_AUDIT_TEMPLATE.md` §4.5) or **explicitly rejected** (the design states why it does not apply). A threat that is neither is an open question, and open questions block architecture sign-off.

---

## 1. Scope and Assumptions

| Item | Value |
| :--- | :--- |
| System boundary | What is inside this threat model |
| Explicitly out of scope | What is not analyzed, and why |
| Deployment assumption | Cloud region, tenancy model, network topology |
| Attacker population considered | Unauthenticated internet · authenticated user · cross-tenant · insider · supply chain |

**Assumptions are the load-bearing part.** A threat model built on an unstated assumption ("the DB is not internet-reachable") is wrong the moment the assumption changes. State them, and state who owns each one.

---

## 2. Elements and Trust Boundaries

Every element gets a stable ID so findings, mitigations, and tests can reference it.

| ID | Type | Name | Trust level |
| :--- | :--- | :--- | :--- |
| `EI01` | External interactor | Browser / mobile client | Untrusted |
| `EI02` | External interactor | Payment gateway (webhook source) | Semi-trusted |
| `P01` | Process | API server | Trusted |
| `P02` | Process | Background worker | Trusted |
| `DS01` | Data store | Primary database | Trusted |
| `DS02` | Data store | Object storage | Trusted |
| `DF01` | Data flow | `EI01` → `P01` over HTTPS | Crosses `TB01` |
| `DF02` | Data flow | `P01` → `DS01` | Crosses `TB02` |
| `DF03` | Data flow | `EI02` → `P01` webhook | Crosses `TB03` |
| `TB01` | Trust boundary | Internet → application | — |
| `TB02` | Trust boundary | Application → database | — |
| `TB03` | Trust boundary | Third party → application | — |

### 2.1 Boundary crossings

For every flow that crosses a boundary, name **the input the attacker controls** and **the check at the gate**. A flow with no entry point is either missing from the diagram or unprotected — decide which.

| Flow | Boundary | Attacker-controlled input | Check at the gate |
| :--- | :--- | :--- | :--- |
| `DF01` | `TB01` | Body, headers, path, query | Auth middleware; schema validation; rate limit |
| `DF02` | `TB02` | Query parameters | Parameterized statements; least-privilege DB role |
| `DF03` | `TB03` | Webhook body, signature header | HMAC-SHA256 verification; replay window |

---

## 3. STRIDE

Apply each letter to each element. A blank cell means the threat does not apply **and you can say why** — that reasoning is the record. A bare dash is an unexamined cell.

| Element | S — Spoofing | T — Tampering | R — Repudiation | I — Information disclosure | D — Denial of service | E — Elevation of privilege |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `EI01` | | | | | | |
| `P01` | | | | | | |
| `P02` | | | | | | |
| `DS01` | | | | | | |
| `DS02` | | | | | | |

### 3.1 Threat register

One row per identified threat. ID format: `T-{STRIDE}-{ElementID}-{NNN}`.

| ID | Element | STRIDE | Threat | Control | State |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `T-S-P01-001` | `P01` | S | Session token replayed after logout | Short-lived JWT + server-side revocation list | Consumed |
| `T-T-P01-001` | `P01` | T | Client-supplied `tenant_id` trusted on write | Tenant derived from token, never from body | Consumed |
| `T-I-DS01-001` | `DS01` | I | Cross-tenant read via missing RLS predicate | Row-level security on every tenant-scoped table | Consumed |
| `T-D-P01-001` | `P01` | D | Unbounded export endpoint exhausts worker pool | Per-tenant quota + async job queue | Consumed |
| `T-E-P01-001` | `P01` | E | User edits own role field | Role writes restricted to admin service role | Consumed |
| `T-R-P02-001` | `P02` | R | Worker action in table | Rationale: `P02` writes only system-generated records with no user-visible action | Rejected |

**State values:** `Consumed` (became a finding or a confirmed control) · `Rejected` (does not apply, reason recorded) · `Open` (neither — blocks sign-off).

**No threat in this table carries a severity.** Severity is assigned only to a **reproduced** threat, in the security audit. A CVSS score on a design-time candidate is a number dressed up as evidence.

---

## Mitigation

Each mitigation names the control, where it is enforced, and how it is verified. A mitigation with no verification path is an intention.

| Threat ID | FSD control / requirement | Mitigation | Enforced at | Planned M07 verification |
| :--- | :--- | :--- | :--- | :--- |
| `T-S-P01-001` | [FSD §7 / SEC-...] | 15-minute access token; refresh rotation; server-side revocation | Auth middleware | Integration test: reused token after logout returns 401 |
| `T-T-P01-001` | [FSD §4 / SEC-...] | Tenant context resolved from verified token claim only | Request pipeline | Unit test: body `tenant_id` differing from token is ignored |
| `T-I-DS01-001` | [FSD §3 / SEC-...] | RLS policy on every tenant-scoped table | Database | Cross-tenant read attempt returns zero rows |
| `T-D-P01-001` | [FSD §7 / SEC-...] | Per-tenant rate limit; exports run on a bounded queue | API gateway + queue | Load test: quota exceeded returns 429, queue depth stays bounded |
| `T-E-P01-001` | [FSD §4 / SEC-...] | Role mutation restricted to service role | Authorization layer | Test: user token cannot PATCH own `role` |

### Residual risk accepted

| Threat ID | Why not mitigated further | Accepted by | Date |
| :--- | :--- | :--- | :--- |
| | | | |

**An accepted risk with no named owner is not accepted — it is unowned.**

---

## 4. Handoff to the Security Audit

- Threat IDs appearing in `templates/06-qa-uat/SECURITY_AUDIT_TEMPLATE.md` must match this register exactly.
- A threat marked `Consumed` in this document must satisfy the six elements in the audit's §4.5, or it was not a finding.
- A threat marked `Rejected` here needs no further work, but the reason must still hold at audit time — if the design changed, re-open it.
- Any threat left `Open` blocks architecture sign-off.

---

## 5. Re-run Triggers

Re-run this threat model when any of these change:

- A new trust boundary (new external service, new role, new data store, new network segment)
- A new data class (PII, payment data, credentials) enters the system
- An authentication or authorization mechanism changes
- A deployment topology change (multi-region, new tenancy model)
