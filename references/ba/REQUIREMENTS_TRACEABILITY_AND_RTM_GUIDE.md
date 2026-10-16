# Requirements Traceability (RTM) & Stakeholder Governance Guide

> **Module**: M02 (Discovery Scope), M07 (Quality Assurance), & M13 (Product Operations)  
> **Source**: Adapted from enterprise business analysis and executive communication standards (`devfolorunso/business-analyst-agent-skill`, `luckybajaj22031996/pm-ba-claude-skills`).  
> **Objective**: Maintain bidirectional traceability between business goals and test suites; enforce testable requirement formulation and structured RAG stakeholder updates.

---

## 1. The 4-Way Requirements Traceability Matrix (RTM)

A requirements document is not an isolated artifact. It exists to guarantee that every line of production code directly serves an authorized business objective, and every functional specification is verified by automated or manual tests.

```text
[ Business Objective (BO-xxx) ]
             │
             ▼
[ Business Requirement (BR-xxx) ]
             │
             ▼
[ Functional Specification (FR-xxx) ] ◄── Linked in PRD / Scope
             │
             ▼
[ Test Case / Acceptance Criteria (TC-xxx) ]
             │
             ▼
[ Git Commit / Production Code (Commit SHA) ]
```

### Traceability Health Rules:
1. **Zero Gold-Plating**: If a feature or functional spec cannot trace its lineage back to a ratified Business Objective (`BO-xxx`), it is unauthorized scope creep.
2. **Zero Verification Gaps**: If a Functional Specification (`FR-xxx`) does not map to at least one Test Case (`TC-xxx`), it represents an untested QA vulnerability.

---

## 2. The Strict Testability Standard for Requirements

Every business and functional requirement must satisfy the **Testability Test**:
* If you cannot write a concrete, observable acceptance criterion for a statement using `Given / When / Then`, the requirement is **defective** and must be rewritten.
* **Banned Vague Words**: Never use words like *"user-friendly"*, *"fast"*, *"robust"*, *"scalable"*, or *"intuitive"* in requirements unless paired with a measurable metric (e.g., *"Page load LCP < 1.8 seconds over 4G networks"*).

| Defective Requirement (Untestable) | Disciplined Requirement (Testable & Traced) |
| :--- | :--- |
| ❌ *The system should process tax calculations quickly and handle errors gracefully.* | ✅ **FR-TAX-002**: *When an invoice is submitted, the system shall compute PPh 21 and PPN within $\le 500\text{ms}$. If NPWP is invalid, display error ERR-NPWP-01 within 200ms.* |
| ❌ *The dashboard must be intuitive for freelancers.* | ✅ **FR-DASH-001**: *A first-time user shall successfully generate and download their first invoice within $\le 3$ clicks from the home screen.* |

---

## 3. Executive RAG Status & Decision Governance

Stakeholder and client updates must maintain high signal-to-noise ratios. Adopt the standard **RAG (Red / Amber / Green)** classification framework:

### RAG Definitions:
* 🟢 **GREEN**: On track against baseline scope, timeline, and budget. Minor issues handled within normal sprint capacity.
* 🟡 **AMBER**: Risks identified that threaten delivery dates or dependencies, but an active mitigation plan is in place.
* 🔴 **RED**: Critical blocker encountered that WILL cause milestone slippage, budget overrun, or legal breach unless leadership intervenes.

### Mandatory Decision Request Format:
Whenever a status is labeled **AMBER** or **RED**, you must **NEVER** merely report the problem. You must pair the alert with a concrete, actionable **Decision Request**:

```text
Status: RED 🔴
Blocker: Bank mutation API webhook provider has delayed sandbox credential issuance by 10 business days.
Business Impact: Automated invoice reconciliation (Milestone 3) cannot enter UAT on Friday.
Required Decision: 
  - Option A (Recommended): Launch Milestone 3 with manual CSV statement upload bridge; deploy automated webhook sync in Milestone 4.
  - Option B: Delay Milestone 3 public launch by 14 days pending provider credentials.
```
