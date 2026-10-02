# Module 07: Quality Assurance (Unit Test, SIT, & Security Audit)

> - `references/playbooks/ai-assisted-development.md` (Pre-merge AI review protocol, prompt engineering patterns, multi-file orchestration)

This module is the seventh phase in the software project lifecycle for solo developers. Its purpose is to validate reliability, third-party system integration integrity (*System Integration Testing* / SIT), performance resilience, and system security automatically in the **Staging** environment before handing over to the client for the UAT process (Module 09).

---

## 1. Execution Cycle of Module 07

```text
[ INPUT: Code Repository on staging Branch from Module 06 & FSD.md ]
                                    │
                                    ▼
[ STEP 1: Automated Unit & API Contract Testing (Test Pyramid) ]
  • Unit Test: Pure business logic, calculations, and cryptographic utilities
  • Integration Test: Zod-validated API endpoints, response statuses, & DB isolation
  • Pre-Merge AI Review: `references/playbooks/ai-assisted-development.md` protocol
                                    │
                                    ▼
[ STEP 2: Third-Party System Integration Testing (SIT) ]
  • SIT is conducted with dummy/seed data (NOT client real data)
  • Payment Gateway Sandbox Validation (Success/Failure Webhook Simulation)
  • Cloud Storage Validation (AES-256 Encrypted Upload & Presigned URL)
  • Transactional Email Validation (SMTP / Resend delivery log)
  • Client real data is imported in M08 after SIT passes
                                    │
                                    ▼
[ STEP 3: Security Audit & Hardening (Security Gate) ]
  • Dependency Vulnerability Audit (`pnpm audit --audit-level=high`)
  • Secret Leak Scanning (Detection of accidentally committed API keys / tokens)
  • OWASP Top 10 Verification Checklist (SQL Injection, XSS, CSRF, Broken Auth)
                                    │
                                    ▼
[ STEP 4: Load & Concurrency Performance Testing (Load Testing) ]
  • Load Testing Using k6 / Autocannon (e.g., 50–100 Concurrent Virtual Users)
  • Verify API Latency ≤200 ms & Error Rate 0%
                                    │
                                    ▼
[ STEP 5: Deployment to Staging Environment & SIT Sign-Off ]
  • Deploy staging Branch to Client Staging Server (Vercel / VPS / Cloud Run)
  • Prepare Test Results Report Document (SIT_REPORT.md)
                                    │
                                    ▼
[ OUTPUT: SIT_REPORT.md & Staging Server Ready for UAT ] ──► Ready to Proceed to Module 08: Data Migration
```

---

## 2. Solo Developer QA Principles: "The Pragmatic Test Pyramid"

Solo developers do not have a 5-person QA team. Writing hundreds of brittle UI tests that frequently fail simply due to CSS class changes is prohibited.

### Efficient Test Pyramid for Solo Devs:
1. **Bottom Layer (70% - Unit & Contract Tests)**:
   - Test pure functions: calculation formulas, template text processing, AES-256 encryption/decryption, and Zod schema validations. Fast to run (< 5 seconds) and stable.
2. **Middle Layer (25% - API Integration & SIT Tests)**:
   - Test controller interactions with local database and third-party sandboxes (Payment, Email, S3).
3. **Top Layer (5% - Critical Path E2E Smoke Test)**:
   - Only test the single most critical flow (*Core Happy Path*): Login → Create document → Generate PDF → Sign → Status `SIGNED`.

---

## 3. Step-by-Step Execution

### Step 1: Automated Unit & Integration Testing
Run tests using a fast test runner (Vitest / Jest / Pytest / Go test):
```bash
# Run all unit & integration tests
pnpm run test # or vitest run
```
Pass Criteria: 100% tests pass without failure (`exit code 0`).

### Step 2: System Integration Testing (SIT)
**IMPORTANT**: SIT is conducted with **dummy/seed data** in the Staging environment. Real client data is **NOT** imported until SIT passes (Module 08).

Test all integration points to third-party services in sandbox environments:
1. **Payment Gateway Sandbox**:
   - Fire a successful payment webhook payload → Ensure order status updates to `PAID` and inventory is locked.
   - Fire an expired/failed payment webhook → Ensure status updates to `CANCELLED`.
2. **Document Vault Storage**:
   - Upload a document file → Ensure file is stored in the storage bucket in encrypted binary format.
   - Retrieve presigned URL → Ensure file can be downloaded and decrypted completely within the 15-minute expiry limit.
3. **Transactional Email**:
   - Test OTP email delivery → Ensure it arrives in the tester's inbox with properly formatted template.

### Step 3: Security Audit & Hardening
1. **Dependency Audit**:
   ```bash
   pnpm audit --audit-level=high
   ```
   Must yield: `found 0 vulnerabilities`.
2. **OWASP Vulnerability Checks**:
   - Ensure all authenticated protected routes reject unauthenticated requests (`401 Unauthorized`).
   - Ensure HTTP security headers are configured:
     ```http
     X-Content-Type-Options: nosniff
     X-Frame-Options: DENY
     Referrer-Policy: strict-origin-when-cross-origin
     Content-Security-Policy: default-src 'self' ...
     ```

### Step 4: Load & Concurrency Testing
Use a simple load testing script (k6 or autocannon):
```bash
# Example simulation of 50 concurrent users for 30 seconds
npx autocannon -c 50 -d 30 http://localhost:3000/api/health
```
- **Minimum Thresholds**:
  - Average latency ≤200 ms.
  - No database connection failures (*zero 500 server errors*).

### Step 5: Deployment to Staging Server & SIT Report
1. Push branch `staging` to remote: `git push origin staging`.
2. CI/CD automatically builds and deploys to the staging domain: `https://staging.clientdomain.com`.
3. Run a quick smoke test directly on the staging domain.
4. Compile all test evidence into the **`SIT_REPORT.md`** file.

---

## 4. Adaptation by Project Scale

| QA & SIT Aspect | Small Scale (MVP / Freelance) | Medium Scale (B2B SaaS / Agency) | Large & Enterprise Scale |
| :--- | :--- | :--- | :--- |
| **Testing Scope** | Core logic unit tests + local smoke test | Unit tests + Sandbox API SIT + k6 load test | Full Test Pyramid, Pact contract test, Chaos test |
| **Security Audit** | `pnpm audit` + basic OWASP checklist | SAST scan (Semgrep) + SSL Labs grade A | Certified third-party Penetration Test (Pentest) |
| **Load Testing** | Verify 20 concurrent users is sufficient | 100 concurrent users load test via k6 | Stress test peak load 1,000+ users & DB failover |
| **Staging Environment** | Automated preview URL (Vercel/Railway) | Isolated Staging server with dummy data | Mirror Production Staging with data sanitization |
| **SIT Report** | Concise checklist in VERIFY.md | Formal `SIT_REPORT.md` document | Formal SIT Sign-off + Security Audit Attestation |

---

## 5. Deliverables

This module produces 2 primary artifacts:
1. **`docs/qa/SIT_WORKBOOK.md`**: Combined test plan and Staging SIT pass verification workbook serving as a prerequisite for opening the Client UAT session (using `templates/06-qa-uat/SIT_WORKBOOK_TEMPLATE.md`).
2. **`docs/qa/SECURITY_AUDIT_REPORT.md`**: Library vulnerability audit results, OWASP security header status, and encryption verification (using `templates/06-qa-uat/SECURITY_AUDIT_TEMPLATE.md`).

---

## 6. Gate Exit Criteria [GATE]

[GATE] Module 07 is declared **PASSED (PASS)** if:
- [x] All unit tests and integration tests pass 100% (`pnpm test` exit code 0).
- [x] SIT with all third-party sandboxes (Payment, Vault S3/R2, Email) is proven successful.
- [x] Dependency audit `pnpm audit` is free of High/Critical category vulnerabilities.
- [x] Application has been successfully deployed and runs stably on the **Staging** server.
- [x] Document **`docs/qa/SIT_REPORT.md`** has been published with the conclusion: **READY FOR CLIENT UAT**.

---

## 🛑 EXIT [GATE] PROTOCOL & MANDATORY STOP

After the Staging server is active and the `SIT_REPORT.md` document is published:

### **STEP 0: FILE EXISTENCE VERIFICATION (BLOCKING CHECK)**

**MANDATORY BEFORE CONTENT VALIDATION**:

1. **Check output file existence** using one of the following methods:
   - PowerShell: `Test-Path -LiteralPath "docs/qa/SIT_WORKBOOK.md"` → must return `True`
   - Read tool: `read_file('docs/qa/SIT_WORKBOOK.md')` → must succeed without error

2. **IF FILE DOES NOT EXIST**:
   - ❌ **STOP IMMEDIATELY** - do not proceed to content validation
   - ❌ **DO NOT display summary** to user
   - ❌ **DO NOT request confirmation** to proceed to Module 08
   - ✅ **REPORT ERROR** to user:
     ```
     CRITICAL ERROR: File SIT_WORKBOOK.md was not created.
     Module 07 FAILED - cannot proceed to Module 08 (Data Migration).
     
     Possible causes:
     - Write permission denied on docs/qa/ folder
     - Path typo in tool call
     - Disk full
     
     Please investigate this issue before proceeding.
     ```
   - ✅ **END TURN** and wait for user to fix issue

3. **ONLY IF FILE EXISTS**: Proceed to content validation below

---

### **STEP 1: CONTENT VALIDATION & TESTS**

1. **STRICTLY PROHIBITED from proceeding directly or calling tools for Module 08/09 within the same turn!**
2. **Verify test results**:
   - [ ] `read_file('docs/qa/SIT_WORKBOOK.md')` → Confirm all tests PASS
   - [ ] Confirm staging URL accessible
   - [ ] Confirm `pnpm audit` clean (zero critical vulnerabilities)
   - [ ] Confirm sandbox integrations verified (Payment/Storage/Email)
3. Present summary of Staging integration test results to user:
   - Active Staging URL
   - Pass status of third-party sandbox testing
   - Dependency security audit & k6 load test results
4. **END YOUR RESPONSE (END TURN)** and ask user for confirmation:
   > *"The system has successfully passed integration testing (SIT Pass) and is active on the Staging server. Are these test results approved before we proceed to Module 08 (Data Migration)?"*
5. Wait for explicit approval response from user before advancing to the next module.
