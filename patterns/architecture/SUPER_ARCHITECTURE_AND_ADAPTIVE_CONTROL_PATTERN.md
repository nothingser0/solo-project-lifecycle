# S.U.P.E.R Architecture & Closed-Loop Adaptive Control Pattern

> **Module**: M05 (Architecture & Specs), M06 (Development Execution), & M07 (Quality Assurance / SIT)  
> **Source**: Adapted from a published spec-driven-development framework (v1.15.0) & Qian Xuesen's Engineering Cybernetics.  
> **Scope**: Authoritative engineering rules enforcing clean component boundaries (S.U.P.E.R), closed-loop feedback telemetry to prevent agent drift, and structured delivery batching.

---

## 1. The S.U.P.E.R Architecture Philosophy

Build software like interlocking LEGO bricks: each block has a single job, a standard schema, a clear flow, runs in any environment, and can be swapped with zero cascading ripples.

### S — Single Purpose (Unix Philosophy)
* Every file, module, and function solves exactly **one conceptual problem**.
* *Litmus Test*: If you cannot summarize a module's single responsibility in one plain sentence, it MUST be decomposed.
* *Anti-Pattern*: A single service or script that fetches raw records, computes financial aggregates, renders HTML previews, and triggers webhook notifications.

### U — Unidirectional Flow (Clean Architecture)
* Data flows in one direction: `Input -> Validation -> Domain Logic -> Persistence / Output`.
* Dependencies point inward: Outer layers (HTTP, DB drivers, UI) depend on core domain logic. Core domain logic has **zero external service imports**.
* *Litmus Test*: Can core business logic run unit tests with zero external mocks, containers, or network connections? If not, dependency direction is violated.

### P — Ports over Implementation (Hexagonal Architecture)
* Define explicit interface contracts (TypeScript types, Zod schemas, JSON Schemas) before writing implementation code.
* Cross-module boundaries communicate through typed, serializable structures.
* Swapping an external provider (e.g. Midtrans $\to$ Xendit, Resend $\to$ Postmark) requires updating only an adapter port, with zero edits to core business entities.

### E — Environment-Agnostic (12-Factor App)
* Configuration is injected via environment variables or validated config schemas (`.env` $\to$ validated by Zod at startup).
* Never hardcode domain URLs, filesystem paths, webhook secrets, or credentials.
* Code must execute identically across local macOS/Linux development, Docker containers, and edge serverless runtimes.

### R — Replaceable Parts
* The ultimate objective of S + U + P + E.
* **Replacement cost is the primary metric of architecture quality**. If replacing one database table or UI component triggers edits across 10 unrelated files, the architecture is broken.

---

## 2. The 10-Check S.U.P.E.R Code Review Card

Run this automated checklist after every development task before declaring completion:

| # | Check Item | Principle | Pass Criteria |
| :-: | :--- | :---: | :--- |
| 1 | Module Responsibility | **S** | File/module has exactly one defined role. |
| 2 | Function Cohesion | **S** | Functions perform one discrete operation without hidden side effects. |
| 3 | Unidirectional Flow | **U** | Data flows strictly downstream (`Input -> Process -> Output`). |
| 4 | Zero Circular Imports | **U** | No mutual or circular module references (`A -> B -> A`). |
| 5 | Schema-Defined Contracts | **P** | Inputs/outputs are typed and validated with schemas (Zod/JSON Schema). |
| 6 | Serializable I/O | **P** | Cross-boundary parameters can be serialized to JSON/Protobuf. |
| 7 | Zero Hardcoded Config | **E** | Secrets, URLs, and paths are read strictly from environment configs. |
| 8 | Explicit Dependencies | **E** | All newly imported packages are declared in `package.json` / lockfile. |
| 9 | Localized Blast Radius | **R** | Component can be replaced or deleted without breaking sibling features. |
| 10 | Regression Tests Green | **—** | Unit/integration tests pass with 0 assertion failures. |

*Scoring Rule*: 10/10 = Proceed. 8–9/10 = Fix violations before merging. $<8/10$ = **HALT and refactor**.

---

## 3. Closed-Loop Adaptive Control Protocol

To prevent AI coding agents from blindly pursuing stale plans when encountering unexpected blockers, implement a closed-loop cybernetic feedback system:

```text
[ Task Specification (Set Point) ]
               │
               ▼
┌───────────────────────────────┐
│ CONTROLLER (SDLC Harness)     │◄───────────────────────────────────┐
└──────────────┬────────────────┘                                    │
               │ Guided Task Instructions                            │
               ▼                                                     │ Telemetry Feedback
┌───────────────────────────────┐                                    │ (Effort Δ, SUPER Δ,
│ ACTUATOR (Coding Agent)       │                                    │  Unplanned Deps)
└──────────────┬────────────────┘                                    │
               │ Codebase Mutations                                  │
               ▼                                                     │
┌───────────────────────────────┐       ┌────────────────────────────┴───────┐
│ PLANT (Repository Codebase)   │──────►│ SENSOR (Post-Task Telemetry Parser)│
└───────────────────────────────┘       └────────────────────────────────────┘
```

### Telemetry Signals
After completing each development task, collect 3 empirical metrics:
1. **$\Delta \text{Effort}$**: Difference between estimated effort and actual effort ($S \to L = +2$, $M \to M = 0$).
2. **$\Delta \text{SUPER}$**: Points change on the 10-check review card. A score drop counts as deviation ($+1$).
3. **$\text{Unplanned Deps}$**: Number of previously unlisted files, schemas, or external APIs touched (capped at 2).

### Cumulative Drift Score Formula
$$\text{task\_drift} = \max(0, \Delta \text{Effort}) + (\text{SUPER Regression ? } 1 : 0) + \min(\text{Unplanned Deps}, 2)$$
$$\text{drift\_score} = \sum \text{task\_drift}$$

### Percentage Thresholds & Automatic Triggers
Calculated at phase/sprint start based on total planned tasks:
* **Mild ($\ge 20\%$ total tasks)** $\to$ **Annotate**: Add warning badge `⚠️ drift-warning` to subsequent tasks.
* **Significant ($\ge 40\%$ total tasks)** $\to$ **Replan**: **HALT IMMEDIATELY**. Close remaining tasks with reason `superseded-by-replan`, re-decompose remaining work based on learned realities.
* **Severe ($\ge 60\%$ total tasks)** $\to$ **Rescope**: **HALT IMMEDIATELY**. Escalate to human architect to reduce scope or pivot architecture.

---

## 4. Delivery Batch PR Protocol

Avoid creating fragmented single-file pull requests:
1. **Batch Boundary**: Group tasks that share the same validation harness, database migration, or rollback boundary into a single cohesive **Delivery Batch**.
2. **Atomic Verification**: Run full lint, type check, unit tests, and S.U.P.E.R audit across the batch branch before opening PR.
3. **Traceability**: The single batch PR references all constituent issues (`Closes #12, Closes #13`).
