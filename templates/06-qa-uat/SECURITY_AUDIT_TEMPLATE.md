# Software Security Audit Report

> Technical security audit documentation, dependency sanitation, OWASP Top 10 vulnerability protection, and data regulatory compliance verification (UU PDP No. 27/2022).

---

## 1. Audit Metadata
- **System Name**: [Application Name]
- **Target Environment URL**: `https://staging.[client-domain].com`
- **Technical Auditor / Solo Security Engineer**: [Your Name]
- **Audit Date**: [YYYY-MM-DD]
- **Compliance Level**: Standard Web Application / Regulated Data

---

## 2. Third-Party Dependency Audit Results (Supply-Chain Security)

Command Executed: `pnpm audit --audit-level=high`

| Vulnerability Level | Findings Count | Remediation Status |
| :--- | :---: | :--- |
| **Critical** | 0 | Free of Critical Vulnerabilities |
| **High** | 0 | Free of High Vulnerabilities |
| **Moderate** | [ ] | [Patched / Monitored] |
| **Low** | [ ] | Ignored if development build dependency only |

---

## 3. OWASP Top 10 Verification Checklist

> **Naming note**: `A01`–`A10` here are **OWASP Top 10 categories** (e.g. `A01:2021 Broken Access Control`), NOT the Enterprise Advisory phases `A00`–`A04` in `docs/modules/A00_ENTERPRISE_ADVISORY_SERIES.md`. Same letters, unrelated namespaces.

| Vulnerability Category | Defense Mechanism Tested | Test Status | Technical Evidence |
| :--- | :--- | :---: | :--- |
| **A01: Broken Access Control** | IDOR verification: User A restricted from accessing User B's documents | [x] PASS | Isolated query with filter `WHERE creator_id = user.id` |
| **A02: Cryptographic Failures** | File vault AES-256 encrypted; password Argon2id hashed; TLS 1.3 active | [x] PASS | Verified via binary inspection of S3 files and database hash columns |
| **A03: Injection (SQLi/Command)** | Database queries must be parameterized (Prisma/Drizzle); Zod input validation | [x] PASS | Injection payload `' OR '1'='1` rejected as plain string input |
| **A04: Insecure Design** | Rate Limiting on login and document endpoints | [x] PASS | Load burst of 10 requests/second returned `429 Too Many Requests` |
| **A05: Security Misconfiguration** | Debug mode disabled in staging/production; error messages do not leak stack traces | [x] PASS | Server error responses return structured generic messages |
| **A06: Vulnerable Components** | Dependency audit clean of public CVEs | [x] PASS | Passed `pnpm audit` |
| **A07: Identification & Auth** | Brute force protection; session stored in `HttpOnly, Secure` cookies with `SameSite=Lax` (or `Strict` when app and API share one origin) | [x] PASS | Session cannot be stolen via JavaScript `document.cookie`; cookie is actually sent on the app→API call |
| **A08: Software & Data Integrity** | Document integrity validated using SHA-256 cryptographic hashes | [x] PASS | SHA-256 value stored in database and PDF footer |
| **A09: Logging & Monitoring** | Audit trail logging for every document creation & signing action | [x] PASS | Logs stored with UTC timestamp, IP address, and User-Agent |
| **A10: Server-Side Request Forgery** | Webhook endpoints only invoke URLs registered on the official whitelist | [x] PASS | Calls to internal local IP addresses (127.0.0.1) are blocked |

---

## 4. HTTP Security Headers Verification

| Security Header | Mandatory Configuration Value | Status |
| :--- | :--- | :---: |
| `Strict-Transport-Security` | `max-age=31536000; includeSubDomains; preload` | Enabled |
| `X-Content-Type-Options` | `nosniff` | Enabled |
| `X-Frame-Options` | `DENY` (Prevents Clickjacking attacks) | Enabled |
| `Referrer-Policy` | `strict-origin-when-cross-origin` | Enabled |
| `Content-Security-Policy` | `default-src 'self'; script-src 'self' ...` | Enabled |

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

- [x] **MEETS SECURITY STANDARDS (SECURITY PASS)**: All critical test parameters above are satisfied. The system is secure against common exploitation vectors and meets basic UU PDP No. 27/2022 compliance.
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
