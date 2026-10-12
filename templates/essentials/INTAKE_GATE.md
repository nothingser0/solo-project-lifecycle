# Intake Gate (Small Scale Entry)

> **Purpose**: 8 mandatory questions BEFORE any project begins. For the Small path this replaces M00/M01/M02; at every scale it feeds the automated scale classifier.
> **Location**: answers recorded as fields in `docs/pm/PROJECT_STATE.md`.
> **Rule**: Agent MUST STOP and wait until all 8 are answered. Every module's gate rejects a missing / empty / `UNKNOWN` field.
>
> ⚠️ **`docs/pm/PROJECT_STATE.md` is mandatory at EVERY scale** — it holds the Intake answers, so it is also the file the scale classifier reads.
> `PROJECT_LITE.md` does NOT replace it; a Small project needs both.

---

## The 5 Mandatory Core Questions

1. **Project Type** — `solo | portfolio | client | internal`
2. **Success Metric** — the single measurable number that defines "done" (e.g., "10 users can create a task")
3. **Must-Have Features & Explicit Non-Features** — the 3–7 P0 features AND at least 1 thing NOT built
4. **Time Capacity** — hours per week × weeks available (drives scope pruning)
5. **Login or Sensitive Data** — `yes | no` (yes → UU PDP applies from day one; also raises blast-radius tier)

---

## The 3 Escalation Questions (High-Water Mark inputs)

These three decide the tier when the answer is not "none". They are **not optional placeholders**: an absent field is not the same as "none", and while it is absent the classifier cannot see the risk, so a payment webhook or a multi-tenant hierarchy silently stays "Small".

6. **External Integrations** — which third-party services/webhooks the MVP calls (`none`, or a comma-separated list: Midtrans, Xendit, WhatsApp, SendGrid, …). **Any one integration raises the tier to Medium; 4+ raise it to Large.**
7. **Branch / Tenant Hierarchy** — `no | yes` (multi-branch, multi-tenant, or franchise hierarchy). `yes` → Large.
8. **Statutory Compliance** — `none`, or the regulation that applies (OJK, BI, UU PDP, ISO 27001, medical devices). Anything other than `none` → Enterprise, which is **advisory only (A00–A04), never solo coding**.

Answer `none` / `no` explicitly when there is nothing to declare. Leaving the line out fails the Intake Gate.

---

## Recorded Fields (paste into PROJECT_STATE.md §1)

```
- Delivery: [solo | portfolio | client | internal]
- Intake-Success-Metric: [measured outcome]
- Intake-P0-Features: [N] (list)
- Intake-Non-Features: [explicit exclusions]
- Intake-Time-Capacity: [X hrs/week x Y weeks = Z hrs]
- Intake-Sensitive-Data: [yes | no]
- Intake-Integrations: [none | comma-separated list]
- Intake-Branch-Hierarchy: [no | yes]
- Intake-Compliance: [none | OJK | BI | UU PDP | ISO 27001 | ...]
- Intake-Status: [ANSWERED | UNKNOWN]
```

---

## Scope Pruning Rule

If `P0_Features × estimated_hours_per_feature > Time_Capacity`, the agent MUST:
1. Propose concrete feature cuts (rank by P0 impact).
2. WAIT for user approval.
3. NEVER proceed with an "escalation trigger" instead of cutting.
