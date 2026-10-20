# Architecture Debt & Convention Drift Register

> **Project**: `[Project Name]`  
> **Inspection Source**: `[Repository Commit SHA / Branch / Path]`  
> **Evaluator**: `[Human Architect / Solo Developer / AI Agent]`  
> **Date**: `[YYYY-MM-DD]`  

---

## 0. Establish the Dominant Pattern Before Calling Anything Drift

Half of all "drift" findings are wrong because the reviewer measured against what they expected rather than what this codebase actually does. Before writing a single row, count.

| Observation | Verdict | What to do |
| :--- | :--- | :--- |
| One file does X, nine do Y | **Drift** | A finding. Record the nine as baseline, the one as deviation. |
| Five do X, five do Y | **Open question** | Not a finding. The owner must choose the convention; you cannot. |
| Every file does X, your instinct says Y | **Not a finding** | Your instinct is not a baseline. X is the convention. |
| X is used but the framework documents Y | **Framework drift** | A finding — this one has a written authority behind it. |

**The two permitted baselines** are the framework's documented conventions and this project's own dominant pattern. Personal preference, "what most codebases do", and "what I would have written" are not baselines.

**Flow conflicts are the exception that needs tracing, not counting.** A claim that two flows disagree requires following the actual path from entry point to data — not inferring it from file names or folder layout.

---

## 1. Baselines Used for Assessment

* **Framework Official Conventions**: `[e.g. Next.js 15 App Router + Server Actions / Supabase Auth]`
* **Codebase Dominant Patterns**: `[e.g. Zod-validated server actions, snake_case DB columns, shadcn/ui primitives]`

---

## 2. Active Debt & Drift Findings

| # | Finding & Description | Dimension | Evidence (`path:lines`) | Measurable System Impact | Severity | Confidence |
| :---: | :--- | :--- | :--- | :--- | :---: | :---: |
| **01** | `[Title of finding]` | `[Debt / Separation / Framework Drift / Project Drift / Flow Conflict]` | `[src/lib/api.ts:45-80]` | `[Specific runtime, security, or testing failure]` | `[Critical / High / Medium / Low]` | `[Direct / Inferred]` |

*(If no architectural debt survived the evidence check, write `None identified`)*

---

## 3. Proposed Smallest Safe Corrections (Requires Approval)

*Note: All recommendations are strictly proposed and must be verified by the human developer before implementation.*

| Finding # | Smallest Safe Correction | Permanent Prevention Mechanism | Approval Status |
| :---: | :--- | :--- | :---: |
| **01** | `[Minimal code/config delta]` | `[e.g. ESLint boundary rule, shared helper, partial index]` | `[PROPOSED / APPROVED / DEFERRED]` |

---

## 4. Blast Radius Assessment for Scheduled Refactoring

| Target Module / Component | Blast Radius Tier | Affected Downstream Dependents | Rollback Strategy |
| :--- | :---: | :--- | :--- |
| `[e.g. Auth Middleware]` | **Tier 3 (Systemic)** | All protected API routes, user sessions | Revert commit; verify session cookie fallback |
| `[e.g. Invoice PDF Generator]` | **Tier 1 (Localized)** | Billing download page only | Feature flag disable |

---

## 5. Non-Findings (Rejected Nitpicks)

List items evaluated but discarded because they were based on personal taste or lacked evidence of present system impact:
* *[Example: "Suggested converting all controllers to functional closures — rejected as style preference with zero functional impact."]*
