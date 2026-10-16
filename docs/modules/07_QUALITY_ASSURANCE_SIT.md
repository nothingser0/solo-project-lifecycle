# Module 07: Quality Assurance (Unit Test, SIT, & Security Audit)

> **Templates to copy**: `templates/06-qa-uat/BUG_REPORT.md` · `SIT_WORKBOOK_TEMPLATE.md` · `POLISH_AUDIT_TEMPLATE.md`
> 📖 **Optional refs** (do NOT preload): `references/playbooks/AI_ASSISTED_DEVELOPMENT.md` (pre-merge review: inline checklist below) · `patterns/qa/EXACT_BUILD_VERIFICATION_PATTERN.md` (exact-build pinning & 4-state lifecycle) · `templates/06-qa-uat/PENTEST_SCOPE_TEMPLATE.md` (Large/Enterprise only)

This module validates reliability, third-party integration integrity (*System Integration Testing* / SIT), performance resilience, and security in the **Staging** environment before client UAT (Module 09). Verbose SIT walkthrough & Enterprise A04 advisory: `deep-dives/07_QUALITY_ASSURANCE_SIT.md`.

**Scale routing (one line)**: Small: M07 waived → `SECURITY_CHECKLIST_SMALL.md` in M06, go M09-LITE · Medium/Large: full M07 below (a capacity-only Large runs solo under a signed risk acceptance) · Enterprise / non-delegable: Phase A04 advisory (`deep-dives/07_QUALITY_ASSURANCE_SIT.md`).

**Input**: staging branch from M06 + `FSD.md`.

## Steps

### Step 1 — Unit & Integration Tests
```bash
pnpm run test        # Vitest / Jest / Pytest / Go test — exit code 0
```
- Unit: pure business logic, calculations, AES-256 crypto utilities, Zod schemas.
- Integration: API endpoints (status codes, DB isolation), third-party sandbox clients.
- **Pre-merge AI review (inline — no need to open the playbook)**:
  1. Diff scope: every changed file traces to a task in `TODO.md`; zero drive-by edits.
  2. Hallucination scan: no invented APIs/imports (verify each new import exists); no `@ts-ignore`/`as any`/empty catch.
  3. Security: no secrets in diff, inputs validated at boundaries (Zod), auth checks on every new route.
  4. Tests: new logic has a test; existing tests still pass locally.
  5. Revert-ability: one logical change per commit; commit message states the why.
- Pyramid: ~70% unit/contract, ~25% API integration/SIT, ~5% critical-path E2E smoke (login → create → PDF → sign → `SIGNED`). No brittle UI/CSS tests.
- Pass criteria: 100% tests pass, exit 0.

### Step 2 — System Integration Testing (SIT, Staging)
**Dummy/seed data only. Real client data is imported in M08 after SIT passes.**
1. **Payment & Webhook Integrity**:
   - Verify success + failed/expired webhook payloads → `PAID` / `CANCELLED` transitions, inventory lock.
   - **Webhook HMAC & Replay Defense**: Test missing signature (must return 401/403), invalid signature (must return 401/403), and repeated delivery of identical payload (must be idempotent: no duplicate credits, return 200 OK).
2. **Encrypted vault upload**: AES-256 encrypted upload to storage bucket + presigned URL download/decrypt within 15-minute expiry.
3. **Transactional email**: OTP email arrives with correctly formatted template (SMTP / Resend delivery log).
4. **BOLA / IDOR Authorization Tests**: Explicitly test cross-tenant and cross-user data access (User A attempting to read/update User B's resource ID must strictly return `403 Forbidden` or `404 Not Found`).
5. **SIT Sandbox Teardown & Reset Protocol**: After running synthetic sandbox mutations (test orders, simulated payments, generated OTPs), execute a clean-state reset or re-seed script before entering Module 09 (Client UAT) so client stakeholders encounter clean demo accounts rather than distorted test transactions.

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

### Step 7 — Anti-Vibe-Code Polish Audit (run on the DEPLOYED staging URL)
Tests pass ≠ looks finished. Build `docs/qa/POLISH_AUDIT.md` from `templates/06-qa-uat/POLISH_AUDIT_TEMPLATE.md` and check all 32 tells **on the live staging URL, on a real phone**: horizontal scroll, favicon, meta description, custom 404, image weight, stock hero, loading states, spacing scale, default Tailwind blue, copyright year, OG preview image, broken links, page title, leftover placeholder text, console errors, hover/focus states, empty states, font count, form error messages, dead buttons, slop comments, race conditions, cliché eyebrow badges, fake stats, purple text gradients, spec leaks, emoji icons, layout deviation, media/3D CLS, database base64 bloat, FOUC theme flash, unbounded rate limits.
- Run on **Slow 4G + 375px viewport** — desktop devtools hides most of these.
- Every row needs evidence (screenshot path, command output, or URL). "Looks fine" is not evidence.
- 🧑 **HUMAN-ONLY — cannot be verified by any script**: the **real-phone** pass. The agent can run the emulated viewport checks and gather every other row, but "on a real phone" means the human holds the device. Record it as `Real-device pass: pending <name>` and **end the turn** — the agent must not mark the row passing on emulation alone.
- **Blocking tells** (must be fixed before sign-off per `POLISH_AUDIT_TEMPLATE.md`).
- Re-verify all tells on the production domain during M10 PVT (CDN/env differences surface new tells).

## Outputs
1. **`docs/qa/SIT_WORKBOOK.md`** — SIT plan + pass evidence, conclusion: READY FOR CLIENT UAT (prerequisite for M09 UAT).
2. **`docs/qa/SECURITY_AUDIT.md`** — dependency audit results, OWASP/header status, secret-scan and encryption verification (also accepted as `docs/qa/SECURITY_AUDIT_REPORT.md`).
3. **`docs/qa/POLISH_AUDIT.md`** — 32-tell anti-vibe-code + code-quality audit with per-row evidence; conclusion READY / NOT READY.

## Gate Exit Criteria [GATE]
- [ ] All unit + integration tests pass (exit 0).
- [ ] SIT sandboxes proven (payment webhook HMAC verification + replay defense, encrypted vault + presigned URL, transactional email, and IDOR/BOLA authorization checks) on staging with seed data only.
- [ ] Security audit clean: `pnpm audit` zero High/Critical, secret scan clean, OWASP + security headers verified.
- [ ] Load test: ≤200 ms avg latency, zero 500s.
- [ ] Staging deployed and stable; smoke test passes.
- [ ] `docs/qa/POLISH_AUDIT.md` published: 0 blocking tells open (favicon, 404, OG image, console errors, placeholder text, dead buttons, etc.).
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
