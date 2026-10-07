# Requirements Traceability Matrix (RTM)

> **Purpose**: Trace requirements bi-directionally from business pain points and market hypotheses through architectural design, implementation, and gate verification.
> **Standard**: Every P0/P1 feature must trace back to a validated user need or an explicit cataloged assumption.
> **Output Location**: `docs/pm/REQUIREMENT_MATRIX.md` (or `docs/specs/REQUIREMENT_MATRIX.md`)

---

## 1. Traceability Overview

- **Project**: [Project Name]
- **Date**: [YYYY-MM-DD]
- **Lead Analyst**: [Your Name / Solo Dev]
- **Scope Reference**: `docs/pm/SCOPE_STATEMENT.md`
- **Sitemap Reference**: `docs/specs/SITEMAP.md`

### Requirement Status Legend
- `PENDING_PRIMARY_RESEARCH`: Requirement derived from an unvalidated assumption; awaiting human user confirmation.
- `SPECIFIED`: Technical contract and UI wireflow approved.
- `IN_DEVELOPMENT`: Code and database schema actively being written.
- `TESTED`: Unit and integration test assertions passed.
- `VERIFIED`: User acceptance or real market behavioral test confirmed.

---

## 2. Requirements Traceability Matrix

| Req ID | Business Pain / Hypothesis | Requirement Description | MoSCoW Priority | Screen Mapping | API / DB Target | Verification Method | Current Status | Confidence |
|:-------|:---------------------------|:------------------------|:---------------:|:---------------|:----------------|:--------------------|:--------------:|:----------:|
| **REQ-01** | [ASM-01] Stock mismatch losses | Offline-first cashier barcode checkout with real-time stock decrement | P0 (Must) | `SCR-01` (POS Workspace) | `POST /api/v1/orders`<br>`products.stock` | Automated Test + Offline Simulation | `SPECIFIED` | 🔶 |
| **REQ-02** | [INT-01] Unreliable store connectivity | Local mutation queue syncing to cloud when connection is restored | P0 (Must) | `SCR-01` (POS Workspace) | `IndexedDB.sync_queue`<br>`POST /api/v1/sync` | Network disconnect/reconnect test | `SPECIFIED` | 🔶 |
| **REQ-03** | [ASM-02] Owner requires remote oversight | Executive analytics dashboard showing multi-branch sales & discrepancies | P0 (Must) | `SCR-25` (Admin Overview) | `GET /api/v1/reports/summary`<br>`orders` view | End-to-end integration test | `SPECIFIED` | 🔶 |
| **REQ-04** | Loss prevention | Two-person manager PIN override for discounts exceeding 15% | P1 (Should) | `SCR-22` (Approvals Drawer) | `POST /api/v1/orders/:id/override` | Role boundary test + Audit log check | `SPECIFIED` | 🔶 |
| **REQ-05** | Statutory tax compliance | Automated DPP and 11% PPN calculation on tax invoices | P1 (Should) | `SCR-19` (Transactions) | `orders.tax_amount`<br>`invoices` table | Math assertion test against PP 55/2022 | `SPECIFIED` | ✅ |

---

## 3. Assumption Dependency Analysis

*Requirements that CANNOT be considered fully locked until human primary research completes:*

| Req ID | Tied Assumption ID | Required Human Evidence | Risk to Architecture if False | Fallback / Pivot Action |
|:-------|:-------------------|:------------------------|:------------------------------|:------------------------|
| **REQ-01** | `ASM-01` | $\ge 3$ merchants confirm >Rp 1M/mo loss | High: Over-engineering cashier sync if stock loss is negligible | Downgrade to simple manual spreadsheet import |
| **REQ-02** | `ASM-03` | On-site testing of cellular dead zones | Medium: Complexity of offline conflict resolution | Standard online web app with service worker caching |
| **REQ-03** | `ASM-02` | Willingness-to-pay confirmation from owners | High: Owners refuse to pay recurring subscription | Pivot to one-time software license or freemium |

---

## 4. Verification Sign-Off Protocol

- [ ] Every P0 requirement maps to at least one user flow in `SITEMAP.md`.
- [ ] Every requirement tied to an unvalidated hypothesis is marked `PENDING_PRIMARY_RESEARCH`.
- [ ] No feature is scheduled into `TODO.md` sprint planning without a documented verification method.
