# Business Process Flow Template (As-Is vs To-Be)

> **Module**: M02 (Scope Definition) & M05 (Functional Specification)  
> **Source**: Adapted from Business Process Modeling & Elicitation techniques.  
> **Objective**: Map existing manual client operations (As-Is) and design the streamlined automated workflow (To-Be) before building UI screens.

---

## 1. Process Metadata

| Field | Value |
| :--- | :--- |
| **Process Name** | `[e.g., Procurement Approval / Invoice Settlement / Inventory Stocktake]` |
| **Business Domain** | `[Retail / B2B SaaS / Services / Logistics]` |
| **Primary Actors** | `[Staff Operator, Store Manager, Finance Admin, End Customer]` |
| **Target Outcome** | `[e.g., Reduce invoice processing time from 3 days to 5 minutes]` |

---

## 2. As-Is Process (Current State & Pain Points)

Document how the client or user performs this workflow today without your software:

```
[Step 1: WhatsApp message received from customer]
       ↓ (Manual copy-paste)
[Step 2: Operator records in Excel spreadsheet]
       ↓ (Risk of missing data / formula corruption)
[Step 3: Staff emails PDF invoice to Manager for approval]
       ↓ (Takes 24–48 hours delay)
[Step 4: Customer transfers via BCA and sends paper transfer slip]
       ↓ (Finance manually checks m-Banking mutation)
[Step 5: Warehouse manually updates physical notebook]
```

### Quantified Pain Points in As-Is:
1. **Time Waste**: Average duration of `[X hours/days]` per transaction.
2. **Financial Loss**: `[e.g., 5% stock discrepancy / unpaid invoices forgotten]`.
3. **Bottleneck Person**: Workflow blocks completely when `[Manager/Finance]` is out of office.

---

## 3. To-Be Process (Optimized System Workflow)

Design the software workflow that eliminates manual friction:

```
[Step 1: Customer submits order via web checkout]
       ↓ (Automated record creation)
[Step 2: System generates Midtrans QRIS / Virtual Account with HMAC webhook]
       ↓ (Instant payment settlement within 5 seconds)
[Step 3: Webhook automatically transitions status: pending → paid]
       ↓ (Zero human intervention required)
[Step 4: Real-time inventory deduction via ACID DB transaction]
       ↓ (System notification)
[Step 5: Warehouse dashboard alerts staff to pack item with generated airway bill]
```

### Quantified Improvements in To-Be:
1. **Automation Rate**: Replaces `[4 manual steps]` with `[1 automated pipeline]`.
2. **Speed**: Turnaround time reduced from `[3 days]` to `[Instant / < 1 minute]`.
3. **Auditability**: 100% of state changes logged with timestamps and actor IDs.

---

## 4. Exception & Fallback Handling (The Broken Paths)

What happens when the happy path fails?

| Exception Event | System Behavior | Fallback / Human Escalation |
| :--- | :--- | :--- |
| **Payment Timeout / Cancelled** | Release locked inventory after 15 minutes. | Send reminder email/WhatsApp with retry link. |
| **Out-of-Stock Race Condition** | DB transaction aborts; returns error toast. | Auto-refund via payment gateway or notify backorder. |
| **Webhook Delivery Failure** | Fallback cron job polls payment gateway status. | Alert admin dashboard if unverified after 1 hour. |
| **Manual Data Dispute** | Provide Admin override action with audit log. | Super Admin enters mandatory justification note. |
