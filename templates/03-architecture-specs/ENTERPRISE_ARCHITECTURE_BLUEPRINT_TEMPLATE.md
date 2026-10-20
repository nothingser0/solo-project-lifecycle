# Enterprise Architecture Blueprint

**Project:** [Project Name]
**Client:** [Client Company]
**Prepared by:** [Your Name]
**Date:** [YYYY-MM-DD]
**Version:** 1.0
**Output path:** `docs/architecture/ENTERPRISE_ARCHITECTURE_BLUEPRINT.md`

> Companion documents: `docs/security/THREAT_MODEL_STRIDE.md` (what can go wrong) · `docs/governance/ADR.md` (why each choice was made). This blueprint records **structure and constraints**; the threat model records **threats against it**; the ADRs record **decisions**.

---

## 1. Business Context

| Item | Value |
| :--- | :--- |
| Business capability served | What this system does for the organisation |
| Users and roles | Who uses it, at which privilege level |
| Regulatory regime | Which of these apply: UU PDP · sectoral (Kemenkes/OJK) · PCI-DSS · ISO 27001 |
| Availability target | Contractual SLA and the SLO that supports it |
| Data classification | What classes of data exist, and which are regulated |

---

## 2. C4 Context

**Level 1 — who and what the system talks to.** Only external actors and external systems appear here; internal structure does not.

| Element | Type | Responsibility | Trust level |
| :--- | :--- | :--- | :--- |
| Firm staff | Person | Create, sign, and retrieve documents | Authenticated |
| Client contact | Person | Receive and sign documents | Authenticated, lowest privilege |
| Identity provider | External system | Authentication, MFA | Trusted third party |
| Payment gateway | External system | Billing | Trusted third party, webhook source |
| Document Vault | Software system | This system | — |

### 2.1 C4 Container

**Level 2 — deployable units.** Each container is separately deployable or separately scaled.

| Container | Technology | Responsibility | Scales by |
| :--- | :--- | :--- | :--- |
| Web application | SPA served from CDN | UI, form rendering, signature capture | CDN edges |
| API service | Stateless HTTP service | Domain logic, authorization | Horizontal |
| Worker | Queue consumer | PDF rendering, signature verification, email | Queue depth |
| Primary database | Managed Postgres | Documents metadata, audit trail | Vertical first |
| Object storage | Bucket | Encrypted document blobs | Unbounded |
| Queue | Managed broker | Async work, retries | Partition count |

### 2.2 C4 Component

**Level 3 — inside the containers that carry risk.** Only the components worth isolating; a full component inventory is not the deliverable.

| Component | Container | Responsibility | Boundary |
| :--- | :--- | :--- | :--- |
| Auth middleware | API service | Token validation, tenant resolution | Every request |
| Authorization layer | API service | Object-level and role checks | Every read/write |
| Document service | API service | Upload, retrieve, version | — |
| Signing engine | Worker | Digital signature, PDF assembly | Isolated; holds signing key |
| Audit writer | Worker | Append-only audit records | Write-only path |

**Level 4 (code) is not documented here** — it drifts within days. Record it in the ADR for the module that needs it.

---

## 3. Data Residency

**Constraint:** regulated data must remain in the jurisdiction its regulation requires. For Indonesian engagements, UU PDP No. 27/2022 and PP 71/2019 govern; sectoral rules (Kemenkes, OJK) may be stricter.

| Data class | Storage location | Replication | Cross-border transfer? | Basis |
| :--- | :--- | :--- | :--- | :--- |
| Document blobs (signed PDFs) | Cloud region in-country | Same-region only | No | UU PDP |
| Document metadata | In-country managed DB | Same-region standby | No | UU PDP |
| Audit trail | In-country, append-only | Same-region | No | UU PDP + sectoral |
| Telemetry / logs | In-country | — | No — scrub PII before egress | UU PDP |
| Backups | In-country | Encrypted, cross-AZ | No | UU PDP |

**Record the decision as an ADR**, not only as a table cell: the constraint, the options considered, and what would have to change to relax it. A residency table with no ADR behind it gets silently violated by the next vendor integration.

---

## 4. Quality Attribute Scenario

**No generic "SLA 99.9%".** A quality scenario states a concrete stimulus and an observable response, so it can be tested.

| ID | Attribute | Stimulus | Response | Measure |
| :--- | :--- | :--- | :--- | :--- |
| `QA-01` | Performance | 1,000 TPS ingestion spike | Queue buffers; workers autoscale | API p95 ≤ 400 ms, zero dropped events |
| `QA-02` | Availability | Primary AZ failure | Standby promoted | RTO ≤ 15 min, RPO ≤ 5 min, no data loss |
| `QA-03` | Security | Request with a document ID from another tenant | Authorization layer denies | 403, zero bytes of foreign document body, audit entry written |
| `QA-04` | Scalability | Document volume grows 10× | Storage and query paths scale independently | p95 retrieval unchanged; no full-table scan |
| `QA-05` | Operability | Worker backlog exceeds threshold | Alert fires before user-visible impact | Alert at 5 min backlog; SLO breach at 15 min |

**Every scenario needs a measure, a test method, and an owner.** A scenario with no measure is an aspiration.

| ID | Test method | Owner |
| :--- | :--- | :--- |
| `QA-01` | Load test at 2× target | SRE |
| `QA-02` | Game day: forced AZ failover | SRE |
| `QA-03` | Cross-tenant access test in SIT | QA |
| `QA-04` | Capacity model + query plan review | Architect |
| `QA-05` | Alert rule rehearsal | SRE |

---

## 5. Constraints and Trade-offs Accepted

| Constraint | Consequence | Trade-off accepted | ADR |
| :--- | :--- | :--- | :--- |
| Data residency in-country | Fewer managed-service options; higher unit cost | Pay more for regional managed services | ADR-001 |
| Multi-tenant isolation via RLS | Every query carries the tenant predicate; a missing predicate is a data breach | Simplicity of application-level filtering rejected | ADR-002 |
| Append-only audit trail | No updates or deletes; corrections are compensating records | Storage grows monotonically | ADR-003 |

---

## 6. What This Blueprint Deliberately Does Not Cover

- **Threats** — see `docs/security/THREAT_MODEL_STRIDE.md`.
- **Vendor selection** — see `docs/procurement/VENDOR_COMPARISON_MATRIX.md`.
- **Operational procedures** — see `docs/ops/`.
- **Component-level code design** — see the ADR for each module.

Stating the boundary is part of the deliverable: a blueprint that claims to cover everything is trusted for nothing.
