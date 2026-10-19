# Advanced OWASP Security Code Review & Evidence-Driven Auditing Pattern

> **Module**: M05 (Architecture & Specs), M07 (Quality Assurance & SIT), & M12 (Warranty & Security)  
> **Source**: Adapted from SpecterOps Skills (`SpecterOps/skills/owasp-security-code-review`).  
> **Scope**: Evidence-driven security code reviews, trust boundary mapping, authentication/authorization verification, untrusted-data sink tracing, business logic & cryptography assessment, and executable PoC generation (`poc_<finding_slug>.py`).

---

## 1. Core Review Methodology
1. **Architecture Security Review**: Identify architectural anti-patterns, trust boundary violations, and component isolation failures.
2. **Entry Points & Input Validation**: Map all external entry points (HTTP endpoints, RPC, message queues, CLI args) and verify input sanitization.
3. **AuthN & AuthZ Verification**: Inspect session management, token handling, role-based/attribute-based access controls, and privilege escalation vectors.
4. **Data Flow & Taint Tracing**: Trace untrusted data sources to sensitive sinks (SQL queries, OS command execution, reflection, template rendering).
5. **Business Logic & Crypto Review**: Analyze state machine flaws, race conditions, cryptographic primitives, key management, and randomness.

---

## 2. Finding Standard & PoC Requirements
- **Evidence-Driven Conformance**: Report a finding *only* when a complete execution path from source to sink is verified in the source code. Unverified concerns must be filed as **Open Questions / Assumptions** or **Coverage Gaps**.
- **Executable PoC Requirement**: For every confirmed finding, include an autonomous, safe verification script (`poc_<finding_slug>.py`) specifying minimum attacker position, required credentials, environmental pre-conditions, and invocation instructions.

---

## 3. Review Steps the Methodology Above Skips

Steps 1–5 cover architecture, entry points, auth, data flow, and business logic. Three areas are where real audit findings actually live and are easiest to omit:

**6. Cryptographic implementation.** Password hashing, encryption, signatures, MACs, randomness, key derivation, key storage, certificate validation, token construction. Check nonce/IV uniqueness, constant-time comparison where it matters, key separation, rotation, and **failure behavior**.

> Treat as priority review areas: custom crypto · hardcoded keys · weak randomness · disabled TLS verification · unsigned or partially verified tokens.

**7. Error handling — does it fail closed or fail open?** Check authentication, authorization, validation, and transaction boundaries specifically. Review exception swallowing, fallback behavior, retries, partial commits, default values, verbose responses, stack traces, and secret-bearing logs.

> A `catch { return user }` is a finding. A stack trace in an API response is a finding. An empty catch block around an authorization check is a Critical.

**8. Configuration and deployment.** Debug modes, CORS, trusted proxies, host validation, cookie flags, security headers, logging, feature flags, secret loading. Then container/runtime privileges, filesystem permissions, network exposure, cloud/IAM bindings, CI/CD secrets, build-time substitutions, and production-vs-development drift.

> **The pattern to name explicitly**: an insecure default that makes a secure deployment depend on undocumented operator behavior. If `DEBUG=true` is the default and safety requires remembering to set it false, that is a design defect, not a deployment mistake.

---

## 4. Safe-by-Default PoC Rules

A PoC for a destructive finding can destroy the thing being audited. These rules are not optional:

| Rule | Why |
| :--- | :--- |
| Default to **dry-run or harmless markers** | A proof that printing a marker is sufficient proves the path without mutating anything |
| A **state-changing** step requires an explicit flag | `--confirm-write` or equivalent; never implicit |
| Print numbered steps: prerequisites → auth/material acquisition → trigger → impact verification → cleanup | A PoC nobody can follow is not a PoC; cleanup makes it repeatable |
| State the **attacker position** before sending anything | Unauthenticated internet vs. authenticated tenant is the difference between Critical and Low |
| State every **unproven prerequisite** | "Assumes the proxy strips this header" is a prerequisite, not a detail |
| Validate with a syntax check + dry run first | An unrunnable script is a hypothesis, not evidence |
| **Record which steps were executed and which were not** | The distinction between "proof" and "scaffold" is the whole point |

**If a finding has no safe runnable path**, still create the per-finding scaffold and explain the missing prerequisite. An empty file marked with the reason is a record; silence is not.

---

## 5. Keep Coverage Visible

A security review that reports only findings implies everything unmentioned was examined and found sound. That implication is usually false.

State explicitly, after the findings:

| Section | Content |
| :--- | :--- |
| **Reviewed surfaces** | Which routes, handlers, services, jobs, configs, and files were actually read |
| **Skipped areas** | What was not examined, and why (no access, out of scope, time) |
| **Assumptions** | What the review depends on: internal-network trust, proxy behavior, provider config |
| **Test gaps** | What could not be verified statically |
| **Open Questions / Assumptions** | Concerns lacking a complete path — filed separately, never promoted to findings |

**If there are no confirmed findings, say so explicitly** and still state the reviewed surfaces, unresolved risks, and test gaps. "No findings" without coverage is indistinguishable from "not looked at".
