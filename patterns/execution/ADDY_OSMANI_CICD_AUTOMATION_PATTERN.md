# Addy Osmani CI/CD and Automation Pattern

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
