# Software Security Audit Report

> Technical security assessment covering applicable OWASP categories, dependencies, and project-specific data protections.

> Working report template: begin with no findings/results marked as passed. Scope the checks to the M05 threat model, reachable trust boundaries, deployed configuration, and dependency tools for the selected stack. Mark non-applicable controls with a reason. This report is not a legal compliance certification.

---

## 1. Audit Metadata
- **System Name**: [Application Name]
- **Target Environment URL**: `https://staging.[client-domain].com`
- **Technical Auditor / Solo Security Engineer**: [Your Name]
- **Audit Date**: [YYYY-MM-DD]
- **Data classification / regulatory scope**: [project classification or N/A with reason]

---

## 2. Third-Party Dependency Audit Results (Supply-Chain Security)

Command and tool version: [selected stack's dependency scanner, exact command, version, and date]

| Vulnerability Level | Findings Count | Remediation Status |
| :--- | :---: | :--- |
| **Critical** | [observed count] | [disposition / evidence] |
| **High** | [observed count] | [disposition / evidence] |
| **Moderate** | [observed count] | [disposition / evidence] |
| **Low** | [observed count] | [disposition / evidence] |

---

## 3. OWASP Top 10 Verification Checklist

**Version / scope used**: [current OWASP Top 10 version and applicable application type]

> **Naming note**: `A01`–`A10` here are **OWASP Top 10 categories**, NOT the Enterprise Advisory phases `A00`–`A04` in `docs/modules/A00_ENTERPRISE_ADVISORY_SERIES.md`. Same letters, unrelated namespaces.

| OWASP Top 10:2025 category / threat ID | Applicable control and test | Status (PASS / FAIL / N/A + reason) | Technical Evidence |
| :--- | :--- | :---: | :--- |
| **A01: Broken Access Control** | [test applicable authorization boundaries] | [ ] | [observed evidence or N/A reason] |
| **A02: Security Misconfiguration** | [inspect applicable deployed configuration and error handling] | [ ] | [observed evidence or N/A reason] |
| **A03: Software Supply Chain Failures** | [review dependency/build provenance and scanner results] | [ ] | [command, version, output or N/A reason] |
| **A04: Cryptographic Failures** | [test cryptography and sensitive-data flows present] | [ ] | [observed evidence or N/A reason] |
| **A05: Injection** | [test input/query/command boundaries present] | [ ] | [observed evidence or N/A reason] |
| **A06: Insecure Design** | [test relevant abuse/rate controls from threat model] | [ ] | [observed evidence or N/A reason] |
| **A07: Authentication Failures** | [test authentication/session controls if present] | [ ] | [observed evidence or N/A reason] |
| **A08: Software & Data Integrity** | [test update, build, webhook or data integrity controls that apply] | [ ] | [observed evidence or N/A reason] |
| **A09: Security Logging and Alerting Failures** | [test security-relevant logging/alerting requirements] | [ ] | [observed evidence or N/A reason] |
| **A10: Mishandling of Exceptional Conditions** | [test error, failure, timeout, and recovery paths] | [ ] | [observed evidence or N/A reason] |
| **Additional threat-model scenarios (including SSRF where applicable)** | [test relevant trust boundaries not covered above] | [ ] | [observed evidence or N/A reason] |

---

## 4. HTTP Security Headers Verification

| Security Header / deployed control | Expected value from threat model and deployment needs | Status + response evidence |
| :--- | :--- | :---: |
| [header/control] | [expected value or N/A rationale] | [PASS / FAIL / N/A + evidence] |

---

## 4.5 What Counts as a Finding (and what does not)

A finding needs **all six** of these. If any is missing, it is not a finding — it is a checklist deviation, and checklist deviations do not belong in a security report.

| Element | Question |
| :--- | :--- |
| **Lower-trust principal** | Who is acting with less trust than the system? |
| **Accepted input or action** | What can they send, or what can they do? |
| **Intended control** | Which control is supposed to stop them? |
| **Crossed boundary** | What boundary does that control guard? |
| **Affected principal or resource** | Whose data, or what resource, is reached? |
| **Observed result** | What concretely happens — observed, or observable by the owner? |

**Rejected as findings** (each lacks one of the six): a missing best practice with no reachable violation · defence-in-depth advice · a generic parser crash with no impact · self-impact where the principal only reaches their own data · guessed deployment or provider behaviour not present in the source.

**The severity rule that matters**: only a **confirmed** record gets a severity. A record whose decisive fact lives outside the repository — in a proxy config, a provider setting, an identity policy — is **`needs_validation`**, and it carries **no severity at all**. It records the exact missing fact and what would resolve it.

| Severity | Anchor |
| :--- | :--- |
| **Critical** | Unauthenticated actor gains code execution, full data-store access, or takeover of arbitrary accounts |
| **High** | An actor **fully defeats** an explicit control with real consequences: auth bypass, cross-tenant read/write, stored script affecting other users |
| **Medium** | A real boundary violation with limited blast radius, uncommon preconditions, or a narrow resource set |
| **Low** | Non-secret internal disclosure, or minimal gain for sustained effort |

**The high/medium discriminator**: does the demonstrated result *fully defeat* an explicit control for an action with real consequences, or only weaken it? If you cannot state the concrete damage, the severity is lower than it feels.

**If a client asks for a number**, map to the CVSS v3.1 base score band — do not invent a figure:

| Score | Severity | Matches the anchor above |
| :--- | :--- | :--- |
| 9.0–10.0 | Critical | Unauthenticated RCE, full data access, account takeover |
| 7.0–8.9 | High | Explicit control fully defeated |
| 4.0–6.9 | Medium | Real violation, limited blast radius |
| 0.1–3.9 | Low | Internal disclosure, minimal gain |
| 0.0 | None | Not a finding |

Compute the vector from what you **demonstrated**, not from what seems possible: `AV` (network/adjacent/local/physical), `AC` (low/high), `PR` (none/low/high), `UI` (none/required), `S` (unchanged/changed), `C`/`I`/`A` (high/low/none). The vector is the record; the score is derived from it.

**A score is not a substitute for the boundary analysis above.** A CVSS of 7.5 on a finding you cannot demonstrate is a number dressed up as evidence.

---

## 4.6 Threat Model Input

Threat identification is a design activity and happens before code exists — see `patterns/security/THREAT_MODELING_STRIDE_PATTERN.md`. If a threat model exists, this audit consumes it: every threat is either **consumed** (became a finding, with the six elements in §4.5) or **explicitly rejected** (the design states why it does not apply). A threat that is neither is an open question and blocks the conclusion in §5.

If no threat model exists, note that as a gap and proceed with §3. Do not build one here — testing is the wrong moment to discover that the design was never reasoned about.

---

## 5. Security Conclusion & Pass Status

- [ ] **SECURITY PASS**: Applicable tests have evidence and findings meet the project's documented release policy. This is not a legal compliance certification.
- [ ] **REJECTED (FAIL)**: Critical/High category security vulnerabilities identified that must be resolved prior to go-live.
- [ ] **PASS WITH OUTSTANDING VALIDATION**: No confirmed Critical/High finding, but one or more items are recorded as `needs_validation`. List them in §7 and name who can resolve each one. **This is not a pass** — it is a decision to proceed while the gap is written down and owned.


---

## 6. Git History & Pre-Publication Check

A clean `HEAD` does not mean a clean repository. Secrets committed and later "deleted" remain in every clone of the history, and flipping a repo to public (or mirroring it to a new remote) exposes all of them at once.

**Run this before a repo goes public, is handed to a client, or is mirrored to a new remote.**

```bash
# A shallow clone has no history to scan — deepen it first
[ "$(git rev-parse --is-shallow-repository)" = true ] && git fetch --unshallow

gitleaks detect --source . --redact
# or: trufflehog git "file://$(pwd)" --only-verified --json
```

| Check | Why a working-tree scan misses it |
| :--- | :--- |
| Secrets in **any** commit | The file was deleted later; the blob is still in history |
| **Agent-context files** past or present (`AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `.github/copilot-instructions.md`) | These routinely accumulate internal hostnames, URLs, codenames and credentials — and the current copy may be sanitized while an earlier revision still leaks |
| `.env`, `*.pem`, `*.key` ever committed | Renaming does not remove the original blob |

**Removal is not rotation.** Any secret found in history must be **rotated at its source** — revoke the token, reissue the key — *in addition to* being scrubbed. Assume it was cloned the moment it was pushed; the only safe assumption is that the credential is public.

**Why this matters more on this framework than on a typical repo**: every project here ships an `AGENTS.md` and often a `CLAUDE.md`, and both are *designed* to be verbose about internal structure. Writing `docs/AUTHORITY.md`-style detail into `AGENTS.md` and later "cleaning it up" leaves the full version in history — which is exactly the file a public mirror exposes.

---

## 7. Outstanding Validation

| # | Hypothesis | Missing fact | Who can resolve it | Target date |
| :-: | :--- | :--- | :--- | :--- |
| 1 | | | | |

> An item here has **no severity** and **does not block go-live on its own** — but it must have an owner and a date. A `needs_validation` item with no owner is an unverified claim someone will later mistake for a verified one.
