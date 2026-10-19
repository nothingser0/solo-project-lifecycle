# Test Suite Curation & Pruning Pattern

> **Module**: M06 (Development Execution) & M07 (Quality Assurance) — when the regression suite has become the bottleneck
> **Source**: Principles adapted from `petrkindlmann/qa-skills` `test-suite-curation` (MIT) — the coverage-equality trap, per-test coverage fingerprinting, quarantine-before-delete, and the per-test audit row. Written for this framework.
> **When to use**: the suite takes long enough that people skip it, or the same test file has grown past what anyone reads. Not for judging whether one test is well written (`AI_CODE_REVIEW_CHECKLIST_TEMPLATE.md`) or healing a flaky test.
> **The scope warning first**: this pattern *proposes* deletions. A human approves them. Whole-corpus analysis is the agent's advantage; whole-corpus auto-deletion is not.

---

## 1. The rule that prevents the expensive mistake

> **Coverage equality is not redundancy.**

Two tests can execute the exact same lines and assert completely different things — the status code versus the body, one edge-case input versus another, one piece of state versus another. **Coverage measures what code ran, never what was checked.**

The failure this prevents, in its usual shape: Test A and Test B cover identical lines, a tired engineer deletes B, and three weeks later a production defect ships because B was the only test asserting the rounding was right.

| Evidence | Proof of redundancy? |
| :--- | :--- |
| Identical line coverage | ❌ No — a candidate only |
| Identical branch coverage | ❌ No |
| Same file, similar name | ❌ No |
| **The survivor kills every mutant the other kills** | ✅ Yes |

**The only accepted proof** is mutation testing: if A kills every mutant B kills, A genuinely subsumes B's fault detection. If B kills a mutant A misses, B catches a defect class A does not — **keep both**, even with identical coverage.

---

## 2. Four dispositions, not one

`Redundant`, `obsolete`, and `low-value` are three different states. Collapsing them into a single "delete" bucket is how real coverage is lost.

| Disposition | Meaning | Action |
| :--- | :--- | :--- |
| **Redundant** | Confirmed subsumed by another test (mutation-proven) | Quarantine, then delete |
| **Obsolete** | Tests a behaviour the product no longer has | Delete with the feature; note which feature |
| **Low-value** | Checks something real but trivially cheap to re-break | Keep or rewrite — **not** delete |
| **Keep** | Uniquely covers a branch, or guards a critical path | Protect; do not touch |

**A test that never failed is not the same as a test that cannot fail.** Never-failed is a signal to investigate (see §4); it is not a disposition.

---

## 3. Per-test coverage, not per-file

A single `--cov` report gives per-*file* percentages, which cannot tell you which *test* covered which line — so it cannot tell you which tests overlap.

**Record per-test contexts** (pytest + coverage.py):

```bash
pytest --cov=src --cov-branch --cov-context=test
```

`--cov-context=test` tags every measured line with the test that ran it; `--cov-branch` stops a test that takes the `if` from being counted the same as one that takes the `else`. Read the contexts table out of the `.coverage` SQLite database to build, per test, the set of `(file, line)` and `(file, branch-arc)` pairs.

> **Version caveat — check this before trusting any result.** `--cov-context` requires **pytest-cov ≥ 4**; it delegates to `coverage`'s dynamic contexts. On an older pin the flag is **silently ignored**, and you get per-file data while believing you have per-test — the worst possible failure for this step, because the analysis below then runs on data that cannot answer the question.
>
> Verify two things: that the flag exists in the installed version, and that the `.coverage` SQLite database has a **non-empty `context` table**. If the flag is unavailable, set `dynamic_context = test_function` under `[coverage]` in `setup.cfg` or `pyproject.toml` instead, and confirm the table is populated before continuing.

From those sets you get two useful relations:

- **Uniquely covered lines** — only one test covers them. That test is pulling its weight; losing it loses that coverage outright.
- **Subsumption** — one test's set is a superset of another's. That is a *candidate*, not proof (§1).

**Do not rank tests by line count, and do not delete a test for having a low coverage percentage.** A one-line test can be the only thing guarding a critical branch.

---

## 4. Mining CI history

Two signals only a history gives you:

| Signal | What it means | Action |
| :--- | :--- | :--- |
| **Never failed** across the recorded window | Either genuinely redundant, or never exercised a real path | Investigate; do not delete on the signal alone |
| **Always flaky** (fails and passes with no code change) | Not protecting anything reliably; it trains people to re-run | Fix or quarantine — a flaky test is worse than a missing one, because it teaches the team to ignore red |

**Requires real history.** No JUnit/Datadog/Trunk records means you have coverage and clustering only — say so rather than inferring stability from a few runs.

---

## 5. Quarantine before delete

Asked to remove 600 tests, the naive move is one PR that deletes 600 files. Do not.

1. **Quarantine, never delete directly.** Mark skipped with a reason (`@pytest.mark.skip(reason="curation, see audit row")`, `xfail`, `.skip`) or move to a `quarantine/` suite that stays in the repo. They stop running but remain visible and instantly restorable.
2. **A named human approves.** Redundancy was a hypothesis until §1 confirmed it. "Redundant tests need no review" is how coverage gets lost quietly.
3. **Define an observation window** — default **two releases**. Run with the cohort quarantined and watch for **escaped defects**: any production incident or bug ticket that a quarantined test would have caught means it was not redundant. Restore it.
4. **Delete in small batches**, each linked to its audit row.
5. **Keep it restorable.** Record the quarantine location and commit. *"It's in git history" is not a recovery plan* — nobody reconstructs a test from a deleted diff under incident pressure.

---

## 6. The audit record

Every removal carries its own row. **If you cannot fill the row, you cannot delete the test.**

| Field | Why |
| :--- | :--- |
| Test identifier | Enough to restore it |
| Disposition | Redundant / obsolete / low-value |
| Superseding test | For redundant only — the mutation-proven survivor |
| Coverage delta | What uniquely-covered lines, if any, are lost |
| Mutation evidence | Kill-set comparison, or "not run" with the reason |
| Approved by | A named person |
| Quarantine location | Where it lives until deletion |
| Restore command | One step, not "check the git log" |

---

## 7. Tiering: smoke / core / extended

Once the suite is pruned, split it by **risk and defect-detection history**, not by file layout:

| Tier | Contents | Budget |
| :--- | :--- | :--- |
| **Smoke** | Every critical path; must pass before any deploy | Minutes, not tens of minutes |
| **Core** | The regression suite; must pass before merge | The normal CI run |
| **Extended** | Slow, exhaustive, or environment-dependent | Nightly or pre-release |

The smoke budget is the point of the exercise: if smoke cannot run in a few minutes, people will skip it, and a suite that is skipped protects nothing.

---

## 8. Exit checklist

- [ ] Per-test coverage recorded (contexts), not per-file
- [ ] Every redundancy claim backed by mutation evidence, or marked "candidate, unconfirmed"
- [ ] Quarantine used; nothing deleted directly
- [ ] An observation window is defined and has elapsed
- [ ] Escaped defects checked against the quarantined cohort
- [ ] A named human approved each batch
- [ ] Every deletion has a filled audit row with a restore command
- [ ] Smoke tier fits its time budget
