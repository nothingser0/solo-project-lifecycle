# Senior Architect Assessment, Debt & Blast Radius Playbook

> **Module**: M05 (Architecture & Specs), M06 (Development), & M13 (Operations & Maintenance)  
> **Source**: Adapted from `aetox-skills/senior-architect-agent` (v2.0.0 cognitive architecture framework).  
> **Scope**: Authoritative engineering rules for evidence-first codebase inspection, objective architecture debt assessment, blast radius containment, and preventing taste-driven redesigns.

---

## 1. The Core Engineering Stance: "Describe, Then Judge"

AI coding agents and junior engineers frequently make two fatal architectural mistakes:
1. **Taste-Driven Nitpicking**: Labeling working code as "bad architecture" simply because it does not match personal style preferences or the latest Twitter/X framework fad.
2. **Reckless Redesign License**: Using a minor bug or debt finding as justification to rewrite an entire subsystem without understanding its historical invariants or blast radius.

### The Two Mandatory Baselines Rule
> **An architectural finding is VALID only if it violates one of two explicit baselines:**
> 1. **The Framework's Documented Conventions**: Fighting official lifecycle, routing, data-fetching, or server/client boundaries (e.g. executing synchronous file I/O inside Next.js edge runtimes).
> 2. **The Project's Own Dominant Patterns**: Violating patterns established across the codebase (e.g. if 9 modules use Zod schema validation and 1 module uses raw untyped casts, that is **Convention Drift**; if 5 use A and 5 use B, it is an **Open Architectural Question**, not a defect).

---

## 2. The 5 Dimensions of Architecture Debt

Every finding in `ARCHITECTURE_DEBT_AND_DRIFT_REGISTER.md` must be classified into one of five rigorous dimensions:

| Dimension | Definition | Concrete System Impact (Required) |
| :--- | :--- | :--- |
| **1. Architecture Debt** | Duplicated domain logic, hidden coupling, permanent temporary workarounds, missing database migration rollback scripts. | Slows feature additions; increases defect rate during schema updates. |
| **2. Separation of Concerns** | Leaking boundaries (e.g., UI components making direct raw SQL queries; business logic embedded inside API routing handlers). | Makes automated unit/integration testing impossible without full database mocks. |
| **3. Framework Convention Drift** | Reimplementing what the framework already provides natively (e.g., writing custom auth session cookies instead of using Supabase/Better Auth primitives). | Introduces security vulnerabilities and maintenance burdens across framework upgrades. |
| **4. Project Convention Drift** | Breaking codebase-wide naming, error-handling response shapes, or state management standards. | Confuses future AI coding agents and human contributors; leads to inconsistent API error toasts. |
| **5. Flow Conflicts** | Dual sources of truth for a single state, circular module imports, or background jobs bypassing database transactional locks. | Causes data corruption, phantom state reads, and race condition heisenbugs. |

---

## 3. The "Smallest Safe Correction" Mandate

* **Never Redesign Inside a Finding**: An architectural critique must never be bundled with an unrequested multi-file refactoring.
* **Propose the Minimal Delta**: Recommend the smallest change that stops the debt from recurring (e.g. adding an ESLint import rule or exporting a single shared validation helper), marked `[Status: Proposed - Requires Human Approval]`.

---

## 4. Blast Radius & Impact Analysis (Prior to Code Mutations)

Before initiating code changes in M06 or refactoring in M13, evaluate the **Blast Radius Tier**:

```text
[ Architectural Change Request ]
               │
   ┌───────────┼───────────┐
   ▼           ▼           ▼
 Tier 1      Tier 2      Tier 3
(Low)       (Medium)    (Critical)
```

### Blast Radius Tiers & Verification Gates:
* **Tier 1 (Localized / Low)**:
  - *Scope*: Changes isolated to a single UI presentation component or helper utility with zero downstream dependents.
  - *Gate*: Component unit test passes; zero regression in sibling views.
* **Tier 2 (Module / Medium)**:
  - *Scope*: Changes touching an internal API route contract, service layer, or single-table migration.
  - *Gate*: SIT integration test suite passes; backward compatibility preserved for existing clients.
* **Tier 3 (Systemic / High Blast Radius)**:
  - *Scope*: Changes modifying Authentication middleware, Database Connection Poolers, Global State Stores, or Financial/Payment Webhooks.
  - *Gate*: **Mandatory Human Sign-Off** + synthetic transaction replay verification + rollback plan documented in `docs/specs/FSD.md`.
