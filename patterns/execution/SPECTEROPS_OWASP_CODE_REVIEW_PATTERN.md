# SpecterOps OWASP Security Code Review & Evidence-Driven Auditing Pattern

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
