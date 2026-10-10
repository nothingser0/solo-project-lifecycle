# System Integration Testing (SIT) Workbook

> Combined system integration test plan and completion evidence report for the Staging environment prior to Client UAT.

---

## PART I: SIT TEST PLAN

### 1. Test Metadata
- **System Name**: [Application Name]
- **Test Environment**: Staging Server (`https://staging.[client-domain].com`)
- **Person in Charge / Solo QA & Dev**: [Your Name]
- **Target Execution Date**: [YYYY-MM-DD]
- **Document References**: FSD-[ID] v1.0 & PRD-[ID] v1.0

---

### 2. Testing Scope

#### In-Scope
1. Internal API integration between frontend and backend database.
2. Sandbox payment gateway integration (invoice generation & webhook handling).
3. Cloudflare R2 / S3 file storage integration (encryption & presigned URLs).
4. Transactional email delivery integration (SMTP / Resend).

#### Out-of-Scope
- Extreme load testing $> 10,000$ concurrent users (exceeding agreed capacity).
- Physical hardware testing of client office network.

---

### 3. SIT Test Matrix

| Test ID | Module / Service | Test Scenario | Expected Result | Pass Criteria |
| :---: | :--- | :--- | :--- | :---: |
| **SIT-01** | Auth API | Login with valid staff account | Receives HttpOnly session token, redirects to dashboard | PASS / FAIL |
| **SIT-02** | Document API | Create document with valid data | Document saved in DB, `DRAFT` status, ID generated | PASS / FAIL |
| **SIT-03** | Vault Storage | Render PDF and save to Cloud Storage | PDF file saved with binary AES-256 encryption | PASS / FAIL |
| **SIT-04** | Presigned URL | Retrieve document download link | URL accessible and expires after 15 minutes | PASS / FAIL |
| **SIT-05** | E-Sign API | Execute digital signature via token | Signature recorded, document status `SIGNED` | PASS / FAIL |
| **SIT-06** | Email Sandbox | Send signer link notification | Email delivered to recipient inbox with proper formatting | PASS / FAIL |
| **SIT-07** | Payment Webhook | Send successful transaction webhook payload | Order status automatically transitions from `PENDING` $\to$ `PAID` | PASS / FAIL |
| **SIT-08** | Idempotency | Send duplicate checkout request (double-click) | Second request rejected with `409 Conflict`, no duplicate records created | PASS / FAIL |

---

### 4. Entry & Exit Criteria
- **Entry Criteria**: All code on `staging` branch passes TypeScript compilation and 100% of local unit tests.
- **Exit Criteria**:
  - 100% of test scenarios above marked **PASS**.
  - Free of Critical/Blocker severity bugs.
  - Part II (SIT Report) published and ready for review to unlock Client UAT.

---

## PART II: SIT REPORT

### 1. Report Metadata
- **System Name**: [Application Name]
- **Staging Build Version**: `v0.9.0-rc1` (Commit: `[git-hash]`)
- **Staging Server URL**: `https://staging.[client-domain].com`
- **Testing Completion Date**: [YYYY-MM-DD]
- **Tester / Lead Engineer**: [Your Name]
- **Final Testing Status**: **PASSED (SIT PASS - READY FOR UAT)**

---

### 2. Execution Summary

| Test Category | Total Scenarios | Passed | Failed | Pass Rate |
| :--- | :---: | :---: | :---: | :---: |
| **Unit & Logic Tests** | [e.g.: 24] | 24 | 0 | **100%** |
| **API Contract Tests** | [e.g.: 12] | 12 | 0 | **100%** |
| **Third-Party Integrations** | [e.g.: 8] | 8 | 0 | **100%** |
| **Security & OWASP Sanity** | 10 | 10 | 0 | **100%** |
| **TOTAL** | **[Total]** | **[Total]** | **0** | **100%** |

---

### 3. Third-Party Integration Testing Details

1. **Document Storage (Cloudflare R2 / AWS S3)**:
   - *Status*: **PASS**
   - *Evidence*: Document PDF files successfully uploaded under AES-256-GCM encryption. Presigned download URLs successfully generated and automatically expire after 15 minutes.
2. **Sandbox Payment Gateway (Midtrans / Xendit)**:
   - *Status*: **PASS**
   - *Evidence*: Bank transfer and QRIS payment simulations successfully triggered webhooks to the staging server; order status transitioned automatically to `PAID` without manual intervention.
3. **Transactional Email (Resend / SMTP)**:
   - *Status*: **PASS**
   - *Evidence*: Document signing link emails arrived in recipient inboxes in $< 5\text{ seconds}$ with active signature action button.

---

### 4. Load & Concurrency Test Results (Load Test Metrics)

Testing Tool: `k6` / `autocannon`
- **Concurrent Users**: 50 Virtual Users
- **Test Duration**: 30 Seconds
- **Total Requests Processed**: [e.g.: 4,850 requests]
- **Average Response Time (Latency p95)**: **142 ms** (Target threshold: $\le 200\text{ ms}$)
- **Error Rate**: **0.00%** (Zero failed requests)
- **Database Status**: Connection pool load stable, zero connection timeouts occurred.

---

### 4b. Automated Test Coverage (Large / Enterprise scale mandatory)

Report the output of `pnpm test:coverage` (or `npm run coverage`):
- **Line Coverage**: [e.g.: 74%] (Large: $\ge 70\%$ | Enterprise: $\ge 80\%$)
- **Branch Coverage**: [e.g.: 63%] (Large: $\ge 60\%$ | Enterprise: $\ge 70\%$)

> Small / Medium scale: no strict threshold — report actual numbers for transparency.

---

### 5. Gate Recommendation

Based on all technical test results, third-party system integrations, security audits, and load testing above:

The system is declared **STABLE, SECURE, AND PASSED SYSTEM INTEGRATION TESTING (SIT PASS)**.

The system is officially recommended to initiate **User Acceptance Testing (UAT)** with the **Client Single PIC** in the Staging environment.

---

### 6. SIT Sign-Off Sheet

| Solo Lead Engineer | Client Single PIC (Review) |
| :--- | :--- |
| **Name**: _________________________ | **Name**: _________________________ |
| **Title / Role**: Independent Lead Engineer | **Title / Role**: _________________ |
| **Date**: _________________________ | **Date**: _________________________ |
| **Signature**: | **Signature**: |
