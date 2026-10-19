# Software Security Audit Report

> Technical security audit documentation, dependency sanitation, OWASP Top 10 vulnerability protection, and data regulatory compliance verification (UU PDP No. 27/2022).
>
> **This is a worked example of `templates/06-qa-uat/SECURITY_AUDIT_TEMPLATE.md`.** It is filled in for the Legal Document Vault so you can see what a completed audit looks like at every section, including the parts most often skipped: §4.5 (what counts as a finding), §6 (git history), and §7 (outstanding validation).

---

## 1. Audit Metadata
- **System Name**: Legal Document Vault
- **Target Environment URL**: `https://staging.legalvault.example`
- **Technical Auditor / Solo Security Engineer**: Auditor (single-engineer engagement)
- **Audit Date**: 2026-10-19
- **Compliance Level**: Regulated Data (UU PDP No. 27/2022 — legal document confidentiality)
- **Commit audited**: `4f8c21a` (SHA of source, not of the deployed bundle — see §6)

---

## 2. Third-Party Dependency Audit Results (Supply-Chain Security)

Command Executed: `pnpm audit --audit-level=high`

| Vulnerability Level | Findings Count | Remediation Status |
| :--- | :---: | :--- |
| **Critical** | 0 | Free of Critical Vulnerabilities |
| **High** | 0 | Free of High Vulnerabilities |
| **Moderate** | 2 | Patched (`cookie` <0.7.0 → 0.7.2; `esbuild` dev-only, upgrade scheduled) |
| **Low** | 3 | Ignored — development build dependencies only, absent from the production bundle |

---

## 3. OWASP Top 10 Verification Checklist

| ID | Control | Result | Evidence |
| :--- | :--- | :---: | :--- |
| A01 | Broken access control | ✅ | RLS on `documents`; cross-tenant read attempt returned 0 rows |
| A02 | Cryptographic failures | ✅ | AES-256-GCM at rest; TLS 1.3 enforced; no MD5/SHA-1 in source |
| A03 | Injection | ✅ | All queries parameterized; 0 string-concatenated SQL |
| A04 | Insecure design | ✅ | Threat model present — see §4.6 |
| A05 | Security misconfiguration | ✅ | Headers verified in §4 |
| A06 | Vulnerable components | ✅ | See §2 |
| A07 | Auth failures | 🔶 | Session fixation tested; MFA enforcement for admin accounts is provider-side — see §7 |
| A08 | Integrity failures | ✅ | Uploads checksummed; signature verification uses HMAC-SHA256 |
| A09 | Logging failures | ✅ | Auth events and document access logged with actor + timestamp |
| A10 | SSRF | ✅ | No user-supplied URL is fetched server-side |

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

## 4.5 What Counts as a Finding

A finding needs **all six** elements. Anything short of that is a checklist deviation and stays out of this report.

| Finding | Lower-trust principal | Accepted input | Intended control | Crossed boundary | Affected resource | Observed result |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **F-01** Signed-document download skips tenant predicate | Authenticated user of tenant A | `GET /api/documents/{id}` with a tenant-B document ID | Row-level security on `documents` | `TB01` internet → app | Another firm's signed PDF | File returned in full; reproduced in staging |

**Severity of F-01: High.** The actor fully defeats an explicit control (RLS) for an action with real consequences (reading another firm's confidential document). Not Critical because the actor must be authenticated and must know or guess a document ID.

**Rejected as findings in this audit** (each lacks one of the six):

- Missing `Permissions-Policy` header — no reachable violation demonstrated.
- `pnpm audit` moderate advisories in dev dependencies — not in the production bundle.
- Login error message differs between "unknown email" and "wrong password" — self-impact only; the principal reaches no resource they did not already control.

---

## 4.6 Threat Model Input

Consumed from `docs/security/THREAT_MODEL_STRIDE.md` (method: `patterns/security/THREAT_MODELING_STRIDE_PATTERN.md`).

| Threat ID | State | Consumed as |
| :--- | :--- | :--- |
| `T-I-DS01-001` | Consumed | **F-01** — missing tenant predicate on the download path |
| `T-S-P01-001` | Consumed | Verified: 15-minute access token; reused token after logout returns 401 |
| `T-E-P01-001` | Consumed | Verified: user token cannot PATCH its own `role` |
| `T-D-P01-001` | Consumed | Verified: export quota returns 429; queue depth stayed bounded under load |
| `T-R-P02-001` | Rejected | Worker writes only system-generated records; no user-visible action to repudiate |

No threat is left `Open`.

---

## 5. Security Conclusion & Pass Status

- [ ] **MEETS SECURITY STANDARDS (SECURITY PASS)**: All critical test parameters above are satisfied.
- [x] **REJECTED (FAIL)**: One High finding (F-01) must be resolved prior to go-live.
- [ ] **PASS WITH OUTSTANDING VALIDATION**: see §7.

**F-01 blocks launch.** It is not a hardening item.

---

## 6. Git History & Pre-Publication Check

Prepared for handover of the repository to the client.

```bash
[ "$(git rev-parse --is-shallow-repository)" = true ] && git fetch --unshallow
gitleaks detect --source . --redact
```

| Check | Result |
| :--- | :--- |
| Secrets in any commit | None found |
| Agent-context files past or present (`AGENTS.md`, `CLAUDE.md`, `.cursorrules`) | `CLAUDE.md` present in history; remediated — it listed an internal staging hostname, which was moved to `docs/runbook/` and the file rewritten |
| `.env`, `*.pem`, `*.key` ever committed | None |

**Removal is not rotation.** No live credential was found, so no rotation was required. Had one been found, revocation at the source would have preceded the scrub.

---

## 7. Outstanding Validation

Records whose decisive fact lives outside this repository. **These carry no severity.**

| ID | Missing fact | Who can resolve | Blocks launch? |
| :--- | :--- | :--- | :---: |
| OV-01 | Whether MFA is enforced for admin accounts on the identity provider | Client IT (IdP admin console) | No — soft-launch with MFA optional, enforced before client onboarding |

---

## Notes

- **Audited commit `4f8c21a`.** The deployed staging bundle was not verified to be built from it; see the build-identity section of `templates/04-dev-execution/VERIFY_LOCAL_TEMPLATE.md` §1.1.
- Retest scope after F-01 is fixed: the download path only, plus a regression check that other tenant-scoped endpoints share the predicate.
