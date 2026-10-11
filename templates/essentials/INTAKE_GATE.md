# Intake Gate (Small Scale Entry)

> **Purpose**: 5 mandatory questions BEFORE any small-scale project begins. Replaces M00/M01/M02 for the Small path.
> **Location**: answers recorded as fields in `docs/pm/PROJECT_STATE.md`.
> **Rule**: Agent MUST STOP and wait until all 5 are answered. Gate M01 rejects if any field is empty or `UNKNOWN`.

---

## The 5 Mandatory Questions

1. **Project Type** — `solo | portfolio | client | internal`
2. **Success Metric** — the single measurable number that defines "done" (e.g., "10 users can create a task")
3. **Must-Have Features & Explicit Non-Features** — the 3–7 P0 features AND at least 1 thing NOT built
4. **Time Capacity** — hours per week × weeks available (drives scope pruning)
5. **Login or Sensitive Data** — `yes | no` (yes → UU PDP applies from day one; also raises blast-radius tier)

---

## Recorded Fields (paste into PROJECT_STATE.md §1)

```
- Delivery: [solo | portfolio | client | internal]
- Intake-Success-Metric: [measured outcome]
- Intake-P0-Features: [N] (list)
- Intake-Non-Features: [explicit exclusions]
- Intake-Time-Capacity: [X hrs/week x Y weeks = Z hrs]
- Intake-Sensitive-Data: [yes | no]
- Intake-Status: [ANSWERED | UNKNOWN]
```

---

## Scope Pruning Rule

If `P0_Features × estimated_hours_per_feature > Time_Capacity`, the agent MUST:
1. Propose concrete feature cuts (rank by P0 impact).
2. WAIT for user approval.
3. NEVER proceed with an "escalation trigger" instead of cutting.
