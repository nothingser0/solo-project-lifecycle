# Module 07: Quality Assurance (Unit Test, SIT, & Security Audit)

> - `references/playbooks/ai-assisted-development.md` (Pre-merge AI review protocol)
> - `templates/06-qa-uat/BUG_REPORT.md` (Standardized defect reporting format)
> - `templates/06-qa-uat/PENTEST_SCOPE_TEMPLATE.md` (Large/Enterprise third-party pentest scoping)

This module validates reliability, third-party integration integrity (*System Integration Testing* / SIT), performance resilience, and security in the **Staging** environment before client UAT (Module 09). Verbose SIT walkthrough & Enterprise A04 advisory: `deep-dives/07-quality-assurance-sit.md`.

**Scale routing (one line)**: Small: M07 waived → `SECURITY_CHECKLIST_SMALL.md` in M06, go M09-LITE · Medium/Large: full M07 below · Enterprise: not solo capacity → Phase A04 advisory (`deep-dives/07-quality-assurance-sit.md`).

**Input**: staging branch from M06 + `FSD.md`.

## Steps

### Step 1 — Unit & Integration Tests
```bash
pnpm run test        # Vitest / Jest / Pytest / Go test — exit code 0
```
- Unit: pure business logic, calculations, AES-256 crypto utilities, Zod schemas.
- Integration: API endpoints (status codes, DB isolation), third-party sandbox clients.
- Pre-merge AI review per `references/playbooks/ai-assisted-development.md`.
- Pyramid: ~70% unit/contract, ~25% API integration/SIT, ~5% critical-path E2E smoke (login → create → PDF → sign → `SIGNED`). No brittle UI/CSS tests.
- Pass criteria: 100% tests pass, exit 0.

### Step 2 — System Integration Testing (SIT, Staging)
**Dummy/seed data only. Real client data is imported in M08 after SIT passes.**
1. **Payment sandbox**: success + failed/expired webhook payloads → `PAID` / `CANCELLED` transitions, inventory lock.
2. **Encrypted vault upload**: AES-256 encrypted upload to storage bucket + presigned URL download/decrypt within 15-minute expiry.
3. **Transactional email**: OTP email arrives with correctly formatted template (SMTP / Resend delivery log).

### Step 3 — Security Audit & Bug Triage
```bash
pnpm audit --audit-level=high   # must report zero High/Critical vulnerabilities
```
- Secret leak scan: no committed API keys/tokens/.env artifacts (git history included).
- OWASP Top 10 checks: protected routes reject unauthenticated requests (401), SQLi/XSS/CSRF/broken auth.
- Security headers present on all responses:
  `X-Content-Type-Options: nosniff` · `X-Frame-Options: DENY` · `Referrer-Policy: strict-origin-when-cross-origin` · `Content-Security-Policy: default-src 'self' ...`
- Bug triage via `templates/06-qa-uat/BUG_TRIAGE_MATRIX.md`: P0 blocker (data loss/security/crash) · P1 major, no workaround · P2 minor, workaround exists · P3 cosmetic. Fix P0/P1 before gate; log all in SIT workbook.
- Large/Enterprise third-party pentest: scope via `templates/06-qa-uat/PENTEST_SCOPE_TEMPLATE.md`; results recorded in `docs/qa/SECURITY_AUDIT.md`.

### Step 4 — Load Test
```bash
npx autocannon -c 50 -d 30 https://staging.clientdomain.com/api/health   # or k6
```
Thresholds: ~50 VUs, average latency ≤200 ms, zero 500 errors (no DB connection failures).

### Step 5 — Deploy Staging & Smoke Test
1. `git push origin staging` → CI/CD deploys to `https://staging.clientdomain.com`.
2. Smoke test the staging URL: core happy path + health endpoint return expected results.

### Step 6 — Compile SIT Workbook
Build `docs/qa/SIT_WORKBOOK.md` from `templates/06-qa-uat/SIT_WORKBOOK_TEMPLATE.md`: test plan, per-integration sandbox evidence (payment/vault/email), audit & load results, defect log, sign-off conclusion **READY FOR CLIENT UAT**.

## Outputs
1. **`docs/qa/SIT_WORKBOOK.md`** — SIT plan + pass evidence, conclusion: READY FOR CLIENT UAT (prerequisite for M09 UAT).
2. **`docs/qa/SECURITY_AUDIT.md`** — dependency audit results, OWASP/header status, secret-scan and encryption verification (also accepted as `docs/qa/SECURITY_AUDIT_REPORT.md`).

## Gate Exit Criteria [GATE]
- [ ] All unit + integration tests pass (exit 0).
- [ ] SIT sandboxes proven (payment webhooks, encrypted vault + presigned URL, transactional email) on staging with seed data only.
- [ ] Security audit clean: `pnpm audit` zero High/Critical, secret scan clean, OWASP + security headers verified.
- [ ] Load test: ≤200 ms avg latency, zero 500s.
- [ ] Staging deployed and stable; smoke test passes.
- [ ] `docs/qa/SIT_WORKBOOK.md` published with **READY FOR CLIENT UAT**.

**Coverage (one line)**: Large ≥70% line / ≥60% branch, Enterprise ≥80% / ≥70% (`pnpm test:coverage`), Small/Medium pragmatic coverage of critical paths only.

**Verbatim gate check**:
```bash
./scripts/gates/validate-gate.sh M07
```
```powershell
./scripts/gates/validate-gate.ps1 M07
```

🛑 **STOP-and-wait**: After the gate passes and `SIT_WORKBOOK.md` is published, END the turn and wait for explicit client/user approval before proceeding to Module 08 (Data Migration).
