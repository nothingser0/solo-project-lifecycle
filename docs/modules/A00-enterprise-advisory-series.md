# Enterprise Advisory Series (A00 - A04): Non-Solo Capacity Lifecycle

> **Target**: Projects classified as **BEYOND_SOLO_CAPACITY** (>15 P0 features, statutory audit, multi-branch, core legacy integration).
> **Premise**: Solo developer acts as **Lead Enterprise Architect / Technical Advisor**. Hands-on solo coding is strictly prohibited. The output is a verified **Enterprise Architecture & Procurement Readiness Package**.

---

## 1. The 5-Phase Advisory Lifecycle Overview

```text
[ CLIENT RFP / ENTERPRISE OPPORTUNITY ]
                     │
                     ▼
[ PHASE A00: Bid/No-Bid & Commercial Clearance ] ──► 🛑 STOP 1 (Advisory Agreement Signed)
  • Administrative eligibility check (PT/CV, NPWP, legal tender requirements)
  • Bid/No-Bid decision matrix (Capacity, margin, risk boundaries)
  • Output: CONSULTING_AGREEMENT.md (Net 30, liability cap, anti-conflict pact)
                     │
                     ▼
[ PHASE A01: Work Breakdown Structure & Phased Decomposition ]
  • Scope Razor: Decompose >15 P0 features into autonomous Medium-scale sub-projects (Phases 1-3)
  • Legacy Integration Isolation: Isolate core banking/ERP legacy into a standalone spike
  • Verification: Every sub-package must pass classify-scale.sh as Scale: medium
  • Output: WBS_PHASING_PLAN.md
                     │
                     ▼
[ PHASE A02: C4 Architecture, Threat Modeling & Quality Scenarios ] ──► 🛑 STOP 2 (Arch Sign-off)
  • C4 Model (Context, Containers, Components) + ADR Suite
  • Threat Modeling (STRIDE): Spoofing, Tampering, Repudiation, Info Disclosure, DoS, Elevation
  • ATAM Quality Scenarios: Measurable latency, throughput (TPS), RPO (<15m), RTO (<1h)
  • Data Residency: Explicit local region lock (e.g. AWS Jakarta ap-southeast-3) via ADR
  • Security Controls Mapping: UU PDP No. 27/2022, POJK/BI regulations, ISO 27001 readiness
  • Output: ENTERPRISE_ARCHITECTURE_BLUEPRINT.md, ADR_SUITE.md, THREAT_MODEL_STRIDE.md
                     │
                     ▼
[ PHASE A03: Vendor Procurement & Build-vs-Buy Evaluation ]
  • Technical specifications schedule for corporate RFP
  • Build-vs-Buy analysis for commodity components (IAM, CMS, payment engine)
  • Weighted Vendor Comparison Matrix (RFP Technical Evaluation Criteria)
  • Vendor Lock-In Exit Strategy: Data portability, open DDL schemas, neutral export scripts
  • Output: VENDOR_PROCUREMENT_SCHEDULE.md, VENDOR_COMPARISON_MATRIX.md
                     │
                     ▼
[ PHASE A04: Governance Handover & Architecture Conformance Retainer ] ──► 🛑 STOP 3 (Final Sign-off)
  • Corporate RACI Matrix: Multi-department decision ownership
  • CAB Protocol Template: Change Advisory Board process for vendor releases
  • Disaster Recovery Blueprint: Automated backup, failover topology, restore drill protocol
  • Conformance Retainer: Architecture review SLA per vendor sprint milestone
  • Output: GOVERNANCE_HANDOVER_PACK.md (Setara BAST Advisory)
```

---

## 2. Phase-by-Phase Execution Guidelines

### Phase A00: Bid/No-Bid & Legal Clearance
1. **Administrative Feasibility**: Verify corporate entity readiness. If tender mandates specialized corporate capital guarantees beyond consultant status, execute **NO-BID** immediately before wasting hours.
2. **Paid Discovery Principle**: Never write custom 40-page RFP responses or POC code for free. Bill as an upfront Technical Discovery / Advisory Engagement.
3. **Draft Disclaimer**: Mark all regulatory compliance mappings as:
   > *"DRAFT TEKNIS — WAJIB DITINJAU OLEH LEGAL COUNSEL / PAKAR KEPATUHAN TERSERTIFIKASI SEBELUM EKSEKUSI HUKUM."*

### Phase A01: Work Breakdown Structure (WBS) & Phasing
1. **Decomposition Before Architecture**: Never model a monolith for 25 features. Split into:
   - *Phase 1 (Core Backbone)*: 8–10 P0 features, basic RBAC, foundational ledger.
   - *Phase 2 (Ecosystem Integrations)*: Secondary modules, reporting, branch synchronization.
   - *Phase 3 (Legacy Bridge & Advanced Automation)*: High-risk legacy connectors, ETL, automated reconciliation.
2. **Gate Validation**: Run `./scripts/gates/classify-scale.sh` against each phase specification. Each phase **MUST resolve to `Scale: medium`**.

### Phase A02: C4 Modeling, STRIDE & Quality Scenarios
1. **C4 Hierarchy**: Context (System boundaries) $
ightarrow$ Containers (Web, API, DB, Queue) $
ightarrow$ Components (Domain engines).
2. **STRIDE Threat Modeling**: Explicit mitigations per container (e.g., mTLS between services, KMS envelope encryption for PII, HMAC-SHA256 webhooks).
3. **ATAM Scenarios**: No generic "SLA 99.9%". Define concrete stimulus-response pairs:
   - *Scenario*: Ingestion spike of 1,000 TPS during morning batch peak.
   - *Expected Response*: Queue buffer absorbs load, worker autoscales, API p95 $\le 400\text{ ms}$, zero messages dropped.
4. **Data Residency**: Lock cloud deployment to Indonesian territory (PP 71/2019 & UU PDP) via explicit ADR entry.

### Phase A03: Vendor Procurement & Build-vs-Buy
1. **Procurement Schedule**: Formulate technical scope attachments for corporate vendor RFP.
2. **Anti-Conflict Rule**: The advisor acts as an objective evaluator and **MUST NOT** bid as an implementation vendor or receive vendor commissions.
3. **Vendor Exit Strategy**: Define open schema contracts so the client can swap implementation vendors without rewriting the database.

### Phase A04: Governance Handover
1. **Templates as Client Deliverables**: `CAB_PROCESS.md` and `DISASTER_RECOVERY_PLAN.md` are deliverables for the client IT operations team, not runtime obligations of the advisor.
2. **Architecture Conformance Review**: Transition into a monthly retainer to inspect vendor pull requests and architecture compliance at each sprint milestone.

---

## 3. Output Artifacts & Deliverables

| Phase | Phase Name | Primary Deliverables | Standard Template |
| :---: | :--- | :--- | :--- |
| **A00** | Commercial Clearance | `contracts/CONSULTING_AGREEMENT.md` | `templates/00-pre-sales-enterprise/CONSULTING_AGREEMENT_TEMPLATE.md` |
| **A01** | WBS Decomposition | `docs/pm/WBS_PHASING_PLAN.md` | `templates/00-pre-sales-enterprise/WBS_PHASING_TEMPLATE.md` |
| **A02** | C4 & Threat Model | `docs/architecture/ENTERPRISE_ARCHITECTURE_BLUEPRINT.md`<br>`docs/security/THREAT_MODEL_STRIDE.md` | Architecture Blueprint & STRIDE Reference |
| **A03** | Vendor Procurement | `docs/procurement/VENDOR_PROCUREMENT_SCHEDULE.md`<br>`docs/governance/VENDOR_COMPARISON_MATRIX.md` | `templates/03-governance/VENDOR_COMPARISON_MATRIX.md` |
| **A04** | Governance Handover | `docs/governance/GOVERNANCE_HANDOVER_PACK.md` | Governance Pack & Retainer Charter |

---

## 4. Gate Verification Protocol (A00 - A04)

Execute automated verification before declaring phase completion:

```bash
# Validate Advisory Phase Gate Checkpoints:
./scripts/gates/validate-gate.sh A00   # Commercial Consulting Clearance
./scripts/gates/validate-gate.sh A01   # WBS Phasing & Domain Decomposition
./scripts/gates/validate-gate.sh A02   # C4 Architecture Blueprint & STRIDE
./scripts/gates/validate-gate.sh A03   # Vendor Procurement Schedule & Matrix
./scripts/gates/validate-gate.sh A04   # Governance Handover & Retainer
```
