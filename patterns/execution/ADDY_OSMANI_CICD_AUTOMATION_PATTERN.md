# Enterprise CI/CD and Automation Pattern

> **Module**: M10 (Deployment & Production) & M13 (Product Operations & Iteration)  
> **Source**: Adapted from Addy Osmani Agent Skills (`addyosmani/agent-skills`).  
> **Scope**: Quality gate enforcement pipelines (Lint, Type Check, Unit Tests, Build, Integration, E2E, Security Audit), shift-left testing, feedback loops for AI agents, feature flags, staged rollouts, rollback workflows, and CI optimization (caching & parallelism).

---

## 1. Quality Gate Enforcement Pipeline
Every change must pass automated quality gates before merge or deployment:

```
Pull Request Opened 
  │ ▼ 
  ├─► LINT CHECK (eslint, prettier)
  ├─► TYPE CHECK (tsc --noEmit)
  ├─► UNIT TESTS (jest / vitest)
  ├─► BUILD (npm run build)
  ├─► INTEGRATION TESTS (API / Database services)
  ├─► E2E TESTS (Playwright / Cypress)
  ├─► SECURITY AUDIT (npm audit)
  └─► BUNDLE SIZE CHECK
```

---

## 2. Core Automation Principles
- **Shift Left**: Catch problems early in the pipeline. Linting issues cost minutes; production defects cost hours.
- **No Gate Skipping**: If lint fails, fix lint; if tests fail, fix code. Never disable rules or skip tests.
- **Agent Feedback Loop**: Feed CI failure output directly back to the agent for automated remediation (`npm run lint --fix`, type error fixes).
- **Staged Deployments & Rollbacks**: Automated staging verification, feature flags for decoupling deployment from release, and rapid one-click rollbacks.
- **CI Optimization**: Cache dependencies (`actions/cache`), run independent jobs in parallel, and keep test suites under 10 minutes.

---

## 3. The Rationalizations That Kill CI

A pipeline exists for months before its first real test: the week everyone is under pressure and the pipeline is the thing standing between them and "done". These are the exact sentences used, and the answer to each.

| Rationalization | Reality |
| :--- | :--- |
| "CI is too slow" | Optimize the pipeline — never skip it. A five-minute pipeline prevents hours of debugging. |
| "This change is trivial, skip CI" | Trivial changes break builds. CI is fastest exactly for trivial changes. |
| "The test is flaky, just re-run it" | Flaky tests mask real bugs and train everyone to ignore red. Fix the flakiness or delete the test. |
| "We'll add CI later" | Projects without CI accumulate broken states and never catch up. |
| "Manual testing is enough" | Manual testing does not scale, is not repeatable, and is the first thing dropped under deadline. |

**A pipeline is not proven until someone has been told no by it.** If no change has ever been blocked, either the gates are not enforced or nothing has gone wrong yet — and the first option is far more likely.

**The paired failure: silencing instead of fixing.** Deleting a test, adding `|| true`, marking a job `continue-on-error`, or loosening a lint rule all turn the gate into decoration. A gate you can bypass without a recorded decision is not a gate.

---

## 4. Who Fixes a Red Build

Designate a **Build Cop**: when the build breaks, the Build Cop fixes or reverts it — not the author of the breaking change.

| Why not the author | Why the role works |
| :--- | :--- |
| The author is mid-task, may be unavailable, and has every incentive to argue the failure is unrelated | A named owner removes the assumption that someone else will handle it |
| Red builds accumulate while authorship is negotiated | Revert is always an option, and the person on point can take it |

**The default move is revert, not fix-forward.** A broken `main` blocks everyone; an unmerged fix costs the author one round trip. Reverting is not a judgement on the change.

---

## 5. Optimize in This Order

When the pipeline exceeds 10 minutes, apply these in order of impact — not in order of novelty:

| # | Step | What it buys |
| :-: | :--- | :--- |
| 1 | Cache dependencies (`actions/cache`, `setup-node` cache) | Largest single win, near-zero risk |
| 2 | Run independent jobs in parallel (lint, typecheck, test, build) | Wall-clock drops to the slowest job |
| 3 | **Run only what changed** — path filters per job | Skips whole job classes for docs-only or unrelated PRs |
| 4 | Matrix builds / shard the test suite | Linear speedup with runner count |
| 5 | Move slow tests off the critical path to a schedule | Keeps the merge gate fast without losing coverage |
| 6 | Larger or self-hosted runners | Costs money; last resort |

**Step 3 is the one people skip and the one that changes behaviour.** Path filters are also the only step that can silently reduce coverage: a filter that misclassifies a path means a job never runs for a change that needed it. When you add a filter, state which paths it excludes and what protects them.

```yaml
on:
  pull_request:
    paths-ignore:
      - 'docs/**'
      - '**/*.md'
```

**Never filter the gate itself.** Filtering lint or typecheck means a change can reach `main` having skipped them; filter only the expensive, redundant jobs (e2e, integration) and let the cheap ones run always.

---

## 6. Flags and Rollouts Need Expiry

A feature flag is a temporary divergence, not a configuration system. Give every flag a lifecycle and a removal date at creation:

**Create → enable for testing → canary (1% → 10% → 100%) → remove the flag and the dead code.**

| Failure | Consequence |
| :--- | :--- |
| Flag with no cleanup date | Dead branches accumulate; nobody knows which path is live |
| Flag used for permanent configuration | Two code paths forever, both partially tested |
| Canary with no abort criterion | "Canary" becomes "we deployed to 1% and went to lunch" |
| Rollback never rehearsed | The rollback path is the least-tested code in the system |

**Rehearse the rollback before you need it.** A rollback workflow that has never run is a plan, and production is the worst place to discover the previous artifact is no longer retained.
