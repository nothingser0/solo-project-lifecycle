# Product Sunset & End-of-Life (EOL) Architecture Guide

> **Module**: M13 (Product Operations & Continuous Iteration)  
> **Source**: Adapted from enterprise product lifecycle and graceful deprecation frameworks (`deanpeters/Product-Manager-Skills`).  
> **Governing Mandate**: **"Lose the product without losing the customer."**

---

## 1. Right-Sizing the EOL Process

Not all product retirements require months of enterprise committee meetings. Select the appropriate intensity level during the initial assessment:

| Intensity Level | Typical Scope | Elapsed Timeline | Required Alignment Steps |
| :--- | :--- | :---: | :--- |
| **Level 1 (Light)** | Minor feature, internal tool, legacy CLI flag, or deprecated endpoint. | **Days to weeks** | Short internal punch list, release notes notice, and support FAQ. |
| **Level 2 (Standard)** | Paid commercial add-on, secondary tier, active paying users. | **3 to 6 months** | Formal stakeholder sequence, phased gates, automated migration path, 60-day notice. |
| **Level 3 (Heavy)** | Revenue-critical flagship product, regulated data, enterprise SLAs. | **6 to 12 months** | Legal/compliance review, escrow settlement, dedicated transition hotline, data offboarding. |

---

## 2. The 6-Phase Deprecation Route

```text
[ Phase 1: Decide ] ──► [ Phase 2: Align ] ──► [ Phase 3: Plan ]
         │                       │                      │
         ▼                       ▼                      ▼
[ Phase 4: Prepare ] ──► [ Phase 5: Announce ] ──► [ Phase 6: Close ]
```

### Phase 1: Decide (Readiness & Viability)
* Assess technical debt vs. maintenance overhead vs. actual active customer usage.
* **Decision Point 1 Gate**: Is there a real, tested landing place or alternative for existing users? If no viable alternative exists, proceed with planning but **HALT the announcement**.

### Phase 2: Align (Stakeholder Sequence)
* Walk the sequential verification chain before touching public communication:
  `Legal/Contracts ──► Finance/Billing ──► Customer Success ──► High-Risk Customers ──► Engineering`
* **Decision Point 2 Gate**: Did a legal contract, regulatory guarantee, or field promise invalidate the retirement? If yes, roll back to Phase 1 immediately.

### Phase 3: Plan (Phase-Gated Checklist)
* Map all data retention, contract settlements, and automated redirect gates.
* **The "Zero TBD" Rule**: Every checklist item must have a named owner and an immutable target date. Unowned items are guaranteed failure points.

### Phase 4: Prepare (Internal Enablement Gating)
* **Cardinal Rule**: Never inform customers before the front-line support staff is fully equipped.
* Prepare: Support FAQ, objection handling scripts, pre-approved commercial discount offers for switching, and technical escalation ladders.
* **Decision Point 4 Gate**: If support or documentation is unready, the public announcement date **MUST slip**.

### Phase 5: Announce (Customer Communication)
* Provide clear, transparent reasoning; state the exact shutdown timeline; deliver an effortless 1-click data export/migration bridge.

### Phase 6: Close (The Post-Mortem & Decommissioning)
* Ensure cold storage data deletion complies with UU PDP / privacy laws, cancel infrastructure instances, settle lingering prorated refunds, and document architectural lessons learned.
