# Legacy Modernization & Strangler Fig Pattern

> **Module**: M05 (Architecture & Specs) & M06 (Development Execution) — for projects that inherit a running system
> **Source**: The five-step workflow and the traffic-increment checkpoints (5 → 25 → 50 → 100%) are adapted from `jeffallan/claude-skills` `legacy-modernizer` (MIT). The underlying concepts are older than that repo: **strangler fig is Martin Fowler's**, and **characterization tests are Michael Feathers'** (*Working Effectively with Legacy Code*). The failure table, checkpoints and exit criteria are this framework's own.
> **When**: the client already has a system in production and wants it replaced, upgraded, or decomposed. Not for greenfield work.
> **Why this exists separately from greenfield**: on a legacy project the risk is not "will the new code work" — it is "will the business keep running while we replace it". Every rule here is about that second question.

---

## 1. The rule that separates a migration from a rewrite

**Never replace a running system in one cutover unless the client has accepted a full outage window.** For everything else, migrate incrementally with a route back.

| Approach | When it is correct |
| :--- | :--- |
| **Big-bang rewrite** | Genuinely short outage the client signed off; small system; no revenue path through it |
| **Incremental / strangler fig** | Everything else — one route, one module, or one workflow at a time, old path still serving |
| **Branch by abstraction** | The unit of change is inside a module, not a whole route |

Almost every "we'll rewrite it in three months" estimate is wrong, and the client discovers that while their old system is already half-dismantled.

---

## 2. The five-step workflow

Each step has a **checkpoint you must pass before the next**. Skipping the checkpoint is how a migration becomes an incident.

### Step 1 — Assess

Map what exists: entry points, data ownership, external integrations, scheduled jobs, and who depends on which behaviour.

**Checkpoint**: every external integration and data contract is documented. An integration nobody remembered will be discovered by a customer, at the worst moment.

### Step 2 — Plan

An incremental roadmap with an **explicit rollback strategy per phase** and a named owner for the rollback decision.

| Field | Why it is required |
| :--- | :--- |
| Phase scope | What moves in this phase, and what deliberately does not |
| Rollback trigger | The measured condition that means "undo this" — not a feeling |
| Rollback owner | A person, not a team. Someone must decide at 02:00 |
| Verification | How you will know the phase worked |

**Checkpoint**: each phase has a rollback trigger and an owner.

### Step 3 — Build the safety net **before touching production code**

Two things, in this order:

1. **Characterization tests** — tests that capture what the legacy system does **today, including its bugs**. They document behaviour, not correctness.
2. **Monitoring** on the legacy path, so you have a baseline to compare against.

**Checkpoint**: the characterization suite runs green against the **unmodified** legacy system. A suite that cannot pass on the current system tells you nothing about a later change.

### Step 4 — Migrate incrementally

Strangler fig: route traffic through a facade, then shift it in steps.

```
        ┌──────────────┐
Client ─►│   Facade     │──► legacy implementation   (100% → 75% → 50% → 0%)
        │ (routing)    │──► new implementation      (0% → 25% → 50% → 100%)
        └──────────────┘
```

Feature flags control the split. Every increment is a deploy, not a big release.

**Checkpoint**: error rate and latency stay within the baseline captured in Step 3 after each increment.

### Step 5 — Validate, then retire

**Checkpoint**: the new path is stable at 100% traffic for **at least one release cycle** before the legacy path is deleted. Delete the flag, then the code — in that order, in separate deploys.

---

## 3. Characterization tests in one paragraph

A characterization test asserts what the code *currently does*, even when that is wrong. Write it against the real system, and let it pass immediately — if it fails, your understanding is wrong, not the code.

```python
def test_shipping_cost_domestic_heavy():
    # Documenting current behaviour, NOT correct behaviour.
    # 7.5 may be a bug; that is a separate ticket, not this migration's job.
    assert calculate_shipping_cost({"weight": 15, "destination": "domestic"}) == 7.5
```

**Why this is the whole safety net**: you cannot refactor code whose behaviour you cannot assert. Characterization tests convert "I think this does X" into a failing test the moment it stops doing X.

**Do not fix bugs during characterization.** Record them. Fixing one changes behaviour and the test that documented it — which destroys the baseline you are migrating against.

---

## 4. What goes wrong

| Failure | What it looks like | Prevention |
| :--- | :--- | :--- |
| **No baseline** | "It seems slower" after cutover, with nothing to compare | Step 3 monitoring before Step 4 |
| **Big-bang disguised as incremental** | All traffic flips on a Friday | The flag exists and has been exercised at 5% first |
| **Fixing bugs mid-migration** | Behaviour changes, characterization suite goes red, nobody knows why | Record bugs; fix after retirement |
| **Rollback that was never tested** | The trigger fires and the old path no longer runs | Test the rollback once, in staging, before you need it |
| **Deleting the legacy path too early** | A small consumer nobody tracked breaks | One full release cycle at 100%, plus a dependency check |
| **Scope creep by modernization** | "While we're here, let's also…" | Phases have explicit *not* lists |

---

## 5. Exit criteria

- [ ] Every external integration and data contract documented
- [ ] Each phase has a rollback trigger *and* a named owner
- [ ] Characterization tests pass green against the unmodified legacy system
- [ ] Baseline metrics captured before the first traffic shift
- [ ] Each increment verified against baseline before the next
- [ ] New path stable at 100% for one release cycle before retirement
- [ ] Rollback exercised at least once
- [ ] Bugs found during migration recorded, not fixed
