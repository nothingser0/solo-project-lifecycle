# QA & Testing Phase TODO Template (Module 07 - Module 09)

> Atomic task checklist template for Quality Assurance, System Integration Testing (SIT), Cybersecurity Audit, Data Migration Verification, and User Acceptance Testing (UAT) with the Client.
> Rules: Execute testing defensively. Every test scenario must be backed by automated assertions or log/screenshot evidence before checking `[x]`. This phase must achieve Zero P1/P2 Defects (critical/high severity) before being authorized to proceed to Production Deployment.

---

## Testing Metadata
- **System Name**: [System / Application Name]
- **Staging Environment Target URL**: `https://staging.domain.com`
- **Lead QA Engineer / Solo Dev**: [Your Name]
- **Client UAT Representative**: [Client PIC Name]
- **QA Start Date**: [YYYY-MM-DD]
- **Target UAT Completion**: [YYYY-MM-DD]
- **QA/UAT Gate Status**: [ ] TESTING IN PROGRESS | [ ] UAT UNDER REVIEW | [ ] PASSED & SIGNED-OFF

---

## 1. Module 07: Automated Test Writing & QA Strategy (Test Writing)

### 1.1 Test Planning (Test Plan)
- [ ] `qa/test-plan.md`: Document Comprehensive Test Plan (Scope of Testing, In-Scope vs Out-of-Scope, Staging Test Environment, Browser/Device Matrix: Chrome, Safari, Firefox, iOS, Android) - expect test scope clearly documented
- [ ] `qa/test-plan.md`: Define Entry Criteria (*Entry Criteria*: staging build green, DB migration complete) and Exit Criteria (*Exit Criteria*: 100% test cases executed, 0 P1/P2 defects, test coverage target met) - expect quality thresholds defined
- [ ] `qa/test-matrix.md`: Build Requirements Traceability Matrix mapping every User Story from Module 02 to specific Test Case numbers - expect each feature bound to at least 1 positive test scenario and 1 negative test scenario

### 1.2 Unit Testing
- [ ] `tests/unit/utils/*.test.ts`: Write unit tests for pure functions, mathematical calculations, date/time utilities, and currency formatting - expect 100% branch coverage on critical utilities
- [ ] `tests/unit/validation/*.test.ts`: Write unit tests for Zod / Yup / Joi schema parsers (test empty strings, illegal characters, min/max boundary lengths, malformed email/phone formats) - expect all input validations reject invalid data with structured error messages
- [ ] `tests/unit/domain/*.test.ts`: Write unit tests for isolated pure business logic (discounts, tax calculations, role permission checkers, state machine transitions) - expect business logic passes tests without external database dependencies
- [ ] Run unit test runner: `pnpm test:unit --coverage` - expect domain code target coverage achieves at least >= 80%

### 1.3 Integration Testing
- [ ] `tests/integration/auth/*.test.ts`: Write integration tests for login, logout, refresh token, session expiry flows, and HttpOnly cookie middleware protection - expect HTTP status codes 200, 401, 403 verified accurately
- [ ] `tests/integration/api/*.test.ts`: Write integration tests for REST API CRUD endpoints with isolated test database (Testcontainers / Postgres SQLite in-memory) - expect ACID database transactions verified (commit & rollback)
- [ ] `tests/integration/webhooks/*.test.ts`: Write third-party webhook ingestion tests mocking HMAC-SHA256 signed payloads (valid and invalid) - expect 200 OK response for valid payloads and 401 Unauthorized for invalid signatures
- [ ] `tests/integration/storage/*.test.ts`: Write file upload tests, MIME type verification, maximum file size limits, and presigned URL generator - expect files successfully stored in staging object storage

### 1.4 End-to-End Automated Testing (E2E Automated Testing)
- [ ] `tests/e2e/auth.spec.ts`: Create E2E test scripts (Playwright / Cypress) for registration, email verification, login, and password reset flows - expect flow completes landing on user dashboard
- [ ] `tests/e2e/core-workflow.spec.ts`: Create E2E test scripts for core business flow (*Core Transaction Loop*) from start to finish without manual intervention - expect end-to-end flow simulation 100% green in headless CI environment
- [ ] `tests/e2e/edge-cases.spec.ts`: Create tests for extreme scenarios: double-click submission, browser back-button on dirty forms, session expiry mid-transaction, and very large form payloads - expect application handles conditions without crashing or duplicate data records
- [ ] Run E2E test runner: `pnpm test:e2e` - expect all critical E2E scenarios succeed without flakiness

---

## 2. Module 07: SIT Execution, Load Testing, & Defect Management (SIT Execution)

### 2.1 System Integration Testing (SIT) Execution
- [ ] `qa/sit-execution-log.md`: Execute all SIT scenarios in Staging environment identical to Production architecture - expect 100% scenarios executed and logged
- [ ] `qa/sit-execution-log.md`: Test multi-service integration (Database <-> Redis Cache <-> Background Worker Queue <-> External Gateway synchronization) - expect BullMQ job queue processes without orphan jobs
- [ ] `qa/sit-cross-browser.md`: Perform cross-browser testing (Chrome, Edge, Safari, Firefox) and screen responsiveness (Desktop 1920x1080, Laptop 1366x768, iPad Tablet, Mobile 375px) - expect visual and functional consistency across all viewports

### 2.2 System Performance & Load Testing
- [ ] `tests/load/k6-script.js`: Build k6 / Artillery load testing script to test highest-traffic endpoints targeting 50-100 Concurrent Virtual Users (VUs) - expect script includes ramp-up, steady-state, and ramp-down phases
- [ ] `qa/performance-report.md`: Execute load tests and measure system performance metrics:
  - p95 latency value: target < 500 ms for standard queries, < 1500 ms for heavy transactions
  - p99 latency value: target < 2000 ms
  - Error rate: target < 0.1% at peak load
  - Database server CPU & RAM utilization: does not exceed 80%
  - expect system experiences no deadlocks, connection pool starvation, or unexpected restarts
- [ ] `qa/lighthouse-report.html`: Run Google Lighthouse audit on public pages and main dashboard - expect scores Performance >= 85, Accessibility >= 90, Best Practices >= 90, SEO >= 90

### 2.3 Defect Reporting & Triage (Defect Triage & Severity)
- [ ] `qa/defect-tracker.md`: Log every bug found with standardized structure: Defect ID, Title, Steps to Reproduce, Actual Result, Expected Result, Screenshot / Log, Severity, Priority, Status - expect reproducible descriptions clear
- [ ] Apply defect severity classifications:
  - **P1 - Blocker**: System crash, data corrupted/lost, data breach, primary transaction flow blocked with no workaround
  - **P2 - Critical**: Core business feature fails, but complex temporary workaround exists
  - **P3 - Major**: Secondary feature does not function per specification, primary functionality remains operational
  - **P4 - Minor / Trivial**: Minor visual cosmetic defect, text typo, padding misalignment < 4px
  - expect all defects classified objectively
- [ ] `qa/defect-tracker.md`: Perform bug fixes and re-test verification - expect all P1 and P2 defects resolved (Zero P1/P2 Defects) before opening UAT gate

---

## 3. Module 07 & 05B: Cybersecurity & Data Compliance Audit (Security Audit)

### 3.1 Dependency Audit & Static Code Analysis (Supply-Chain & SAST)
- [ ] `qa/security/dependency-scan.txt`: Run package dependency scanner: `pnpm audit --audit-level=high` or Snyk - expect 0 Critical or High severity vulnerabilities in third-party dependencies
- [ ] `qa/security/secret-scan.txt`: Run secret and credential leak scan across git history using TruffleHog or Gitleaks: `gitleaks detect --verbose` - expect zero private keys, API tokens, or passwords committed to repository
- [ ] `qa/security/sast-report.txt`: Run static application security testing using Semgrep or SonarQube - expect zero injection findings or dangerous coding patterns

### 3.2 OWASP Top 10 Testing Checklist
- [ ] `qa/security/owasp-checklist.md`: **A01: Broken Access Control (BOLA/IDOR)** - Test ID manipulation in URL/body parameters using another user's token - expect access denied with 403 Forbidden response
- [ ] `qa/security/owasp-checklist.md`: **A02: Cryptographic Failures** - Verify password hashing using Argon2id or bcrypt (cost factor >= 12), secret file encryption with AES-256-GCM, and all traffic enforced via TLS 1.3 - expect secure hashes and SSL grade A on SSL Labs
- [ ] `qa/security/owasp-checklist.md`: **A03: Injection (SQLi, NoSQLi, XSS)** - Test SQL injection payloads (`' OR '1'='1`) and XSS payloads (`<script>alert(1)</script>`) across all form inputs - expect inputs automatically sanitized and ORM queries fully parameterized
- [ ] `qa/security/owasp-checklist.md`: **A04: Insecure Design & Rate Limiting** - Test rate limiting on login, forgot password, and checkout endpoints (burst test 20 requests/sec) - expect HTTP 429 Too Many Requests response triggered
- [ ] `qa/security/owasp-checklist.md`: **A05: Security Misconfiguration** - Ensure `NODE_ENV=production` mode, stack traces disabled from public responses, and default server credentials changed - expect generic structured error messages
- [ ] `qa/security/owasp-checklist.md`: **A07: Identification & Auth Failures** - Test brute-force protection (account temporarily locked after 5 failed attempts), session fixation reset on login, and cookie flags `HttpOnly, Secure, SameSite=Strict` applied - expect tokens inaccessible via JavaScript console
- [ ] `qa/security/owasp-checklist.md`: **A08: Software & Data Integrity** - Verify integrity of sensitive documents/files using SHA-256 cryptographic hashes - expect checksum validated before parsing files
- [ ] `qa/security/owasp-checklist.md`: **A09: Security Logging & Monitoring** - Ensure all critical events (failed logins, admin role changes, bulk data deletions) logged in server audit log with UTC timestamp and IP - expect complete audit trail
- [ ] `qa/security/owasp-checklist.md`: **A10: Server-Side Request Forgery (SSRF)** - Test endpoints accepting external URLs with internal addresses (`http://127.0.0.1`, `http://169.254.169.254`) - expect requests to internal subnets blocked

### 3.3 HTTP Security Headers Verification
- [ ] `qa/security/http-headers.md`: Test staging response security headers via `curl -I https://staging.domain.com`:
  - `Strict-Transport-Security: max-age=31536000; includeSubDomains; preload`
  - `X-Content-Type-Options: nosniff`
  - `X-Frame-Options: DENY` (anti-clickjacking)
  - `Referrer-Policy: strict-origin-when-cross-origin`
  - `Content-Security-Policy: default-src 'self' ...`
  - expect all standard security headers detected active

---

## 4. Module 08: Data Migration & Seeding Verification (Data Migration Verification)

### 4.1 Data Migration Dry-Run in Staging
- [ ] `data-migration/migration-dry-run-plan.md`: Prepare runbook for execution order of ETL (Extract, Transform, Load) scripts from legacy system to new schema - expect execution sequence ordered by reference table
- [ ] `data-migration/scripts/`: Run sanitization and transformation scripts on real sample data from legacy system - expect malformed characters, inconsistent date formats, and duplicate records normalized
- [ ] Execute staging migration: `pnpm run migrate:staging` - expect migration completes without foreign key constraint errors

### 4.2 Data Reconciliation Report
- [ ] `data-migration/reconciliation-report.md`: Reconcile total record counts per source table vs target table (`COUNT(*) source == COUNT(*) target`) - expect 0% variance
- [ ] `data-migration/reconciliation-report.md`: Verify integrity of financial data and accumulated balances (`SUM(amount) source == SUM(amount) target`) - expect zero discrepancy to the cent
- [ ] `data-migration/reconciliation-report.md`: Test rollback scenario to restore data to pre-migration state - expect rollback procedure cleanly restores database to initial state

---

## 5. Module 09: Client-Facing UAT Facilitation (UAT Facilitation)

### 5.1 Environment Setup & UAT Workbook Preparation
- [ ] `uat/uat-workbook.xlsx` (or `uat/UAT_SCENARIOS.md`): Create UAT scenario workbook in user business language (not code terms):
  - UAT Scenario ID
  - User Role (Role: Admin, Cashier, Regular User)
  - Scenario Preconditions
  - Step-by-Step Action Guide
  - Expected Result Criteria
  - Client Result Column: [PASS / FAIL / NOTES]
  - expect all business use cases from Module 03 SOW represented
- [ ] `uat/environment-setup.md`: Prepare isolated test accounts for each client team representative (complete role credentials) and seed realistic dummy data - expect system ready for use without manual client configuration

### 5.2 UAT Kickoff & Support
- [ ] Host online/in-person UAT Kickoff meeting: demonstrate application navigation flow and explain how to fill out the UAT Workbook - expect client test team understands testing procedures
- [ ] Establish official UAT testing window (standard: 3-5 calendar business days) per SOW contract - expect feedback submission deadline agreed upon by both parties
- [ ] Open dedicated standby communication channel (dedicated WhatsApp Group / Slack) to respond promptly to user questions throughout testing window - expect response time < 30 minutes during business hours

### 5.3 UAT Defect Triage & Scope Negotiation (Defect vs Change Request)
- [ ] `uat/uat-defect-log.md`: Consolidate all feedback notes from client team every afternoon - expect all feedback neatly documented
- [ ] Conduct daily triage sessions with Client PIC:
  - Classify findings: Is this a **Bug / SOW Deviation** (must be fixed immediately at no additional cost) or a **New Request / Change Request** (logged for next phase roadmap or billed as CR)
  - expect firm agreement to prevent scope creep at project conclusion
- [ ] Fix all agreed UAT bugs and deploy hotfix to staging - expect re-verification witnessed by client tester

### 5.4 UAT Sign-Off Execution (UAT Sign-off)
- [ ] Ensure 100% of UAT scenarios status is PASS and zero P1/P2 defects remain OPEN - expect clean UAT workbook
- [ ] `uat/BAST_UAT_SIGNOFF.pdf`: Issue formal UAT Sign-off document - expect document signed via wet signature / digital certificate by Client Project Sponsor or Product Owner

---

## 6. QA/UAT Phase Verification Gate (Gate Pass QA to Deployment)

| Evaluation Parameter | Minimum Pass Standard | Verification Status | Evidence Notes |
| :--- | :--- | :---: | :--- |
| **Automated Test Coverage** | Unit & Integration tests pass 100%, coverage >= 80%, core E2E flow green | [ ] PASS | Attach `pnpm test` report |
| **Zero Critical Defects** | Zero P1 (Blocker) & Zero P2 (Critical) defects in staging | [ ] PASS | Attach `qa/defect-tracker.md` |
| **Performance & Load** | p95 latency < 500ms, Error rate < 0.1% under VU load test | [ ] PASS | Attach `qa/performance-report.md` |
| **Security Audit** | OWASP Top 10 pass, pnpm audit 0 Critical/High, 0 secret leaks | [ ] PASS | Attach `qa/security/` |
| **Data Reconciliation** | Dry-run migration successful, 0% record variance | [ ] PASS | Attach `data-migration/reconciliation-report.md` |
| **Formal UAT Sign-off** | UAT approval document signed by client stakeholders | [ ] PASS | Attach `uat/BAST_UAT_SIGNOFF.pdf` |

### QA Gate Decision:
- [ ] **PASSED (GO TO PRODUCTION DEPLOYMENT - M10)**: All tests pass, security audit clean, and client signed UAT Sign-off. System ready for Production Environment release.
- [ ] **HOLD (HOLD / BLOCKING DEFECT)**: P1/P2 defects or high-severity security vulnerabilities remain. Strictly prohibited from releasing to production!
- [ ] **UAT REVISION (HOLD / CLIENT RE-TEST)**: Client has not completed all test scenarios or requested core functionality fixes. Reschedule testing round.
