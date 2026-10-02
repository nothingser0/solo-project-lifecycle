# Modul 07 Improvements: Quality Assurance & System Integration Testing

## 1. Timeline Estimation (by Project Scale)

| Phase | Kecil (3-6 tabel) | Menengah (10-20 tabel) | Besar (30+ tabel) | Enterprise |
|-------|------------------|------------------------|-------------------|-----------|
| Unit Test Writing | 3-4 jam | 8-12 jam | 16-24 jam | 32-48 jam |
| API Integration Test | 2-3 jam | 6-8 jam | 12-16 jam | 24-32 jam |
| SIT Sandbox Testing | 2-3 jam | 6-10 jam | 12-20 jam | 24-40 jam |
| Security Audit | 1-2 jam | 3-4 jam | 6-8 jam | 12-16 jam |
| Load Testing Setup & Execution | 1-2 jam | 3-4 jam | 6-8 jam | 12-16 jam |
| Staging Deployment | 1 jam | 2-3 jam | 4-6 jam | 8-12 jam |
| SIT Report Writing | 1-2 jam | 2-3 jam | 4-6 jam | 8-12 jam |
| **TOTAL** | **11-17 jam (1.5-2 hari)** | **30-44 jam (4-6 hari)** | **60-88 jam (8-11 hari)** | **120-176 jam (15-22 hari)** |

### Assumptions
- Test coverage target: 70% (critical paths only, not 100% coverage)
- AI agent (Cursor/Claude Code) generates 60% test boilerplate (CRUD API tests, Zod schema tests)
- Manual intervention: complex business logic tests, webhook signature tests, presigned URL expiry tests (40%)
- Buffer 20% untuk debugging flaky tests, sandbox API downtime, staging deployment issues

### Bottlenecks
- Third-party sandbox API slow/unreliable: +4-8 jam (retry/wait time)
- Flaky integration tests (DB connection timeout, race conditions): +2-4 jam debugging
- Load testing infrastructure setup (k6 installation, script writing): +2-3 jam first time

---

## 2. Test Coverage Priority Matrix

### Tier 1: MUST TEST (Critical Path — 0% Skip Tolerance)

**Business-Critical Functions**:
- [ ] Authentication (login, logout, token refresh, session expiry)
- [ ] Payment transaction (order creation, webhook handling, status transition)
- [ ] Data encryption/decryption (AES-256-GCM, file vault)
- [ ] Tax calculation formulas (PPh 21, VAT, withholding tax)
- [ ] Document signing workflow (draft → pending → signed → rejected)
- [ ] Audit trail logging (who changed what when)

**Security Gates**:
- [ ] Input validation (Zod schema all API endpoints)
- [ ] SQL injection prevention (Prisma ORM query builder)
- [ ] XSS prevention (sanitize user input, CSP headers)
- [ ] CSRF token validation (form submissions)
- [ ] Rate limiting (auth endpoints 5 attempts/15 min)

**Data Integrity**:
- [ ] Foreign key constraints (ON DELETE RESTRICT verified)
- [ ] Unique constraints (email, username, document ID)
- [ ] CHECK constraints (file_size > 0 AND file_size <= 10MB)
- [ ] Transaction rollback (payment failure → inventory released)

**Test Methods**:
- Unit tests: Business logic functions
- Integration tests: API endpoints + DB
- Contract tests: Webhook signature verification

**Coverage Target**: 90-100%

---

### Tier 2: SHOULD TEST (High-Value Features — Skip Only If Time-Constrained)

**User Workflows**:
- [ ] User registration (email verification, welcome email)
- [ ] Password reset (OTP generation, token expiry)
- [ ] Document upload (file type validation, virus scan)
- [ ] Search & filtering (pagination, sort, full-text search)
- [ ] Notification delivery (email, in-app, push)

**Third-Party Integrations**:
- [ ] Email sending (SMTP/SendGrid delivery log)
- [ ] File storage (S3/R2 upload, presigned URL expiry)
- [ ] SMS OTP (Twilio/Vonage sandbox)
- [ ] Analytics tracking (Mixpanel event ingestion)

**Test Methods**:
- Integration tests: Sandbox API interactions
- Smoke tests: End-to-end critical paths

**Coverage Target**: 70-80%

---

### Tier 3: NICE TO TEST (Low-Risk Features — OK to Skip)

**Non-Critical UI Components**:
- [ ] Loading skeletons
- [ ] Toast notifications
- [ ] Modal animations
- [ ] Tooltip text

**Static Content**:
- [ ] About Us page
- [ ] Privacy Policy page
- [ ] FAQ page

**Admin Utilities**:
- [ ] Export CSV reports
- [ ] Bulk delete operations (admin only)
- [ ] System settings UI

**Test Methods**:
- Manual spot-check only
- No automated tests

**Coverage Target**: 0-20%

---

### Test Skip Decision Tree

```text
Feature: [X]
│
├─ Security-sensitive? (Auth, Payment, Encryption)
│  └─ YES → MUST TEST (Tier 1)
│
├─ Data integrity risk? (DB constraints, transactions)
│  └─ YES → MUST TEST (Tier 1)
│
├─ Business-critical? (Tax calculation, signing workflow)
│  └─ YES → MUST TEST (Tier 1)
│
├─ User-facing workflow? (Registration, upload, search)
│  └─ YES → SHOULD TEST (Tier 2)
│
├─ Third-party integration? (Email, storage, SMS)
│  └─ YES → SHOULD TEST (Tier 2)
│
└─ Static content or UI polish?
   └─ YES → NICE TO TEST (Tier 3, OK to skip)
```

---

### Overall Coverage Target by Scale

| Scale | Target Coverage | Focus |
|-------|----------------|-------|
| **Kecil (MVP)** | 60-70% | Tier 1 only (critical path + security) |
| **Menengah (SaaS)** | 70-80% | Tier 1 + Tier 2 (workflows + integrations) |
| **Besar** | 80-90% | Tier 1 + Tier 2 + partial Tier 3 |
| **Enterprise** | 90-95% | All tiers + compliance tests (SOC 2, ISO 27001) |

**Key Insight**: 100% coverage is NOT the goal. 70% coverage on critical paths beats 95% coverage including trivial UI tests.

---

## 3. Flaky Test Debugging Protocol

### Definition
**Flaky test** = test yang kadang pass, kadang fail, padahal code tidak berubah. Common causes:
- Network timeout (sandbox API slow)
- Race condition (async operation belum selesai)
- Timing dependency (presigned URL expired mid-test)
- Shared state (database tidak di-reset antar test)

---

### 3-Step Flaky Test Triage

#### Step 1: Identify Flakiness (Run 10x)
```bash
# Run test 10 kali
for i in {1..10}; do pnpm test -- payment.test.ts; done

# Flaky = fail 1-9 kali dari 10 runs
# Reliably failing = fail 10/10 (bukan flaky, memang bug)
# Reliably passing = pass 10/10 (not flaky)
```

**Action**:
- **0-1 failures**: Not flaky, investigate the 1 failure as a real bug
- **2-8 failures**: **FLAKY** → proceed to Step 2
- **9-10 failures**: Reliably failing, fix the code or test assertion

---

#### Step 2: Root Cause Analysis (4 Common Causes)

**Cause A: Network Timeout**
```typescript
// Bad ❌ (default 5s timeout, sandbox API slow)
test('webhook delivers payment success', async () => {
  const res = await fetch('https://sandbox.midtrans.com/webhook', { ... });
  expect(res.status).toBe(200);
});

// Good ✅ (increase timeout, add retry)
test('webhook delivers payment success', async () => {
  const res = await fetch('https://sandbox.midtrans.com/webhook', {
    signal: AbortSignal.timeout(15000), // 15s timeout
  });
  expect(res.status).toBe(200);
}, { timeout: 20000 }); // Vitest test-level timeout
```

**Cause B: Race Condition (Async Not Awaited)**
```typescript
// Bad ❌ (upload not awaited, presigned URL generated before upload completes)
test('presigned URL works after upload', async () => {
  s3.upload(file); // Missing await!
  const url = await getPresignedUrl(file.id);
  const res = await fetch(url);
  expect(res.status).toBe(200);
});

// Good ✅ (await upload completion)
test('presigned URL works after upload', async () => {
  await s3.upload(file); // Wait for upload
  const url = await getPresignedUrl(file.id);
  const res = await fetch(url);
  expect(res.status).toBe(200);
});
```

**Cause C: Timing Dependency (Presigned URL Expiry)**
```typescript
// Bad ❌ (5s expiry too short, test execution takes 6s)
test('presigned URL expires after 5s', async () => {
  const url = await getPresignedUrl(file.id, { expiresIn: 5 });
  await sleep(6000); // Test takes 6s, URL expired mid-test
  const res = await fetch(url);
  expect(res.status).toBe(403);
});

// Good ✅ (use mock time or increase expiry)
test('presigned URL expires after 5s', async () => {
  vi.useFakeTimers(); // Mock time
  const url = await getPresignedUrl(file.id, { expiresIn: 5 });
  vi.advanceTimersByTime(6000); // Fast-forward 6s
  const res = await fetch(url);
  expect(res.status).toBe(403);
  vi.useRealTimers();
});
```

**Cause D: Shared State (DB Not Reset)**
```typescript
// Bad ❌ (test depends on previous test data)
test('create user', async () => {
  await db.user.create({ email: 'test@example.com' });
});

test('user email unique', async () => {
  // Fails if previous test ran (email already exists)
  await db.user.create({ email: 'test@example.com' });
});

// Good ✅ (isolate test data with beforeEach)
beforeEach(async () => {
  await db.user.deleteMany(); // Clean slate
});

test('create user', async () => {
  await db.user.create({ email: 'test@example.com' });
});

test('user email unique', async () => {
  await db.user.create({ email: 'test@example.com' }); // Guaranteed unique
});
```

---

#### Step 3: Fix or Quarantine

**Option A: Fix (Preferred)**
- Apply root cause fix from Step 2
- Run 10x again → should pass 10/10

**Option B: Quarantine (Temporary)**
If fix requires major refactor (e.g., rewrite webhook handler):
```typescript
// Mark test as flaky, skip in CI
test.skip('webhook delivers payment success', async () => {
  // TODO: Fix race condition in webhook handler (Issue #123)
});
```

**Document in SIT_REPORT.md**:
```markdown
## Known Flaky Tests (Quarantined)

| Test | Reason | Issue | ETA Fix |
|------|--------|-------|---------|
| payment.test.ts: webhook delivers payment success | Race condition in webhook handler | #123 | Modul 08 (2 hari) |
```

**Option C: Delete (Last Resort)**
If test provides no value (e.g., testing third-party API behavior, not our code):
```typescript
// Delete test that checks Midtrans API uptime (not our responsibility)
test.skip('Midtrans sandbox is up', async () => {
  const res = await fetch('https://sandbox.midtrans.com/ping');
  expect(res.status).toBe(200); // This tests Midtrans, not our code
});
```

---

### Flaky Test Prevention Checklist

- [ ] All async operations awaited
- [ ] Network timeouts ≥15s (sandbox APIs slow)
- [ ] Database reset in `beforeEach` (isolated test data)
- [ ] Mock time for timing-dependent tests (presigned URL expiry, OTP expiry)
- [ ] Retry logic for sandbox API calls (max 3 attempts)
- [ ] No `sleep()` or arbitrary waits (use `waitFor()` with condition)

---

## 4. SIT Report Template Structure

Create `docs/qa/SIT_REPORT.md` dengan format ini:

```markdown
# System Integration Testing (SIT) Report

**Project**: [Nama Proyek]  
**Date**: 2026-09-30  
**Environment**: Staging (https://staging.example.com)  
**Branch**: `staging`  
**Commit**: `a3f52b1`  
**Tested by**: [Your Name]

---

## 1. Executive Summary

**Status**: ✅ PASS — Ready for Client UAT

**Test Results**:
- Unit Tests: 45/45 passed (100%)
- Integration Tests: 23/23 passed (100%)
- SIT Sandbox Tests: 8/8 passed (100%)
- Security Audit: 0 critical vulnerabilities
- Load Test: P95 latency 142ms (<200ms target), 0% error rate

**Critical Issues**: None

**Known Limitations**:
- Email sending uses test SMTP (not production SendGrid)
- Payment uses Midtrans sandbox (not live mode)
- File virus scan disabled (ClamAV not running in staging)

---

## 2. Test Coverage Summary

| Category | Tests Written | Tests Passed | Coverage |
|----------|--------------|--------------|----------|
| Unit Tests (Business Logic) | 45 | 45 | 82% |
| Integration Tests (API + DB) | 23 | 23 | 75% |
| SIT Tests (Third-Party Sandbox) | 8 | 8 | 100% |
| E2E Smoke Test (Critical Path) | 1 | 1 | 100% |
| **TOTAL** | **77** | **77** | **78%** |

**Tier 1 (Critical Path) Coverage**: 95% ✅  
**Tier 2 (Workflows) Coverage**: 72% ✅  
**Tier 3 (UI Polish) Coverage**: 10% (intentionally low)

---

## 3. Third-Party Integration Test Results

### 3.1 Payment Gateway (Midtrans Sandbox)

**Test Cases**:
1. ✅ Webhook signature verification (SHA-512 hash validated)
2. ✅ Payment success → Order status `PAID` + inventory locked
3. ✅ Payment expired → Order status `CANCELLED` + inventory released
4. ✅ Payment pending → Order status `PENDING_PAYMENT`

**Evidence**:
```bash
$ curl -X POST http://localhost:3000/api/webhooks/midtrans \
  -H 'X-Callback-Signature: 7b84f23b...' \
  -d '{"order_id":"ORD-123","transaction_status":"settlement"}'
{"status":"success","message":"Payment processed"}

# Database verification
SELECT status FROM orders WHERE id = 'ORD-123';
-- Result: PAID
```

**Status**: ✅ PASS

---

### 3.2 File Storage (AWS S3)

**Test Cases**:
1. ✅ File upload encrypted (AES-256-GCM) — raw file unreadable in S3 console
2. ✅ Presigned URL generated (15 min expiry)
3. ✅ Presigned URL expired after 15 min → 403 Forbidden
4. ✅ File download + decrypt successful

**Evidence**:
```bash
# Upload file
$ curl -X POST http://localhost:3000/api/documents \
  -H 'Authorization: Bearer ***' \
  -F 'file=@invoice.pdf'
{"id":"doc_abc123","url":"https://cdn.example.com/..."}

# Verify encryption (raw file in S3 should be garbled)
$ aws s3 cp s3://bucket/doc_abc123.enc /tmp/test.pdf
$ open /tmp/test.pdf
# Result: "Failed to load PDF document" (encrypted, unreadable)

# Presigned URL expiry
$ curl https://cdn.example.com/doc_abc123?X-Amz-Expires=900&... 
# After 16 min: <Error><Code>AccessDenied</Code></Error>
```

**Status**: ✅ PASS

---

### 3.3 Email Delivery (SMTP Test Server)

**Test Cases**:
1. ✅ OTP email sent (6-digit code)
2. ✅ Welcome email sent (user registration)
3. ✅ Password reset email sent (reset link valid 1 hour)

**Evidence**:
```bash
# Mailpit inbox (http://localhost:8025)
From: noreply@example.com
To: test@example.com
Subject: Your OTP Code
Body: Your verification code is: 123456
```

**Status**: ✅ PASS

---

## 4. Security Audit Results

### 4.1 Dependency Vulnerabilities
```bash
$ pnpm audit --audit-level=high
found 0 vulnerabilities
```
**Status**: ✅ PASS

### 4.2 OWASP Top 10 Checklist

| Vulnerability | Test | Result |
|--------------|------|--------|
| **SQL Injection** | Tested with `' OR '1'='1` payload | ✅ PASS (Prisma ORM prevents injection) |
| **XSS** | Tested with `<script>alert(1)</script>` | ✅ PASS (React escapes by default) |
| **Broken Auth** | Tested access without token | ✅ PASS (401 Unauthorized) |
| **CSRF** | Tested POST without CSRF token | ✅ PASS (SameSite=Strict cookie) |
| **Sensitive Data Exposure** | Checked password hashing | ✅ PASS (Argon2id, no plaintext) |
| **Missing Access Control** | Tested user A access user B data | ✅ PASS (403 Forbidden) |
| **Security Misconfiguration** | Checked HTTP headers | ✅ PASS (CSP, X-Frame-Options set) |

**Status**: ✅ PASS

### 4.3 Encryption Verification
- [ ] Password hashing: Argon2id (cost 12) ✅
- [ ] File encryption: AES-256-GCM ✅
- [ ] JWT token: HttpOnly, Secure, SameSite=Strict ✅
- [ ] Database credentials: AWS Secrets Manager ✅

**Status**: ✅ PASS

---

## 5. Load Testing Results

**Tool**: k6  
**Configuration**: 50 concurrent users, 30 seconds duration

**Results**:
```
http_req_duration..........: avg=142ms  min=45ms  med=128ms  max=312ms  p(95)=198ms
http_req_failed............: 0.00%  (0 failed out of 1,500 requests)
http_reqs..................: 1,500  (50 req/s)
```

**Analysis**:
- ✅ P95 latency 198ms (<200ms target)
- ✅ 0% error rate (no 500 errors)
- ✅ 50 req/s throughput sustained

**Status**: ✅ PASS

---

## 6. Known Issues & Limitations

| Issue | Severity | Workaround | ETA Fix |
|-------|----------|-----------|---------|
| Email uses test SMTP (not SendGrid) | Low | Manual SendGrid setup in production | Modul 10 (deploy) |
| Payment uses Midtrans sandbox | Low | Switch to live mode in production | Modul 10 (deploy) |
| File virus scan disabled | Medium | Enable ClamAV in production Docker | Modul 10 (deploy) |
| Search pagination slow (>1k results) | Low | Add database index on `created_at` | Modul 13 (optimization) |

---

## 7. Test Artifacts

**Test Reports**:
- Unit test coverage: `coverage/index.html` (82% statement coverage)
- Integration test logs: `logs/integration-test.log`
- Load test report: `scripts/load-test-report.html`

**Staging Environment**:
- URL: https://staging.example.com
- Admin credentials: `admin@example.com` / `***` (stored in vault)
- Test user: `test@example.com` / `***`

---

## 8. Sign-Off

**QA Engineer**: [Your Name]  
**Date**: 2026-09-30  
**Status**: ✅ READY FOR CLIENT UAT

**Recommendation**: Proceed to Modul 09 (UAT with client). System is stable, secure, and performant in staging environment.

**Next Steps**:
1. Schedule UAT session with client (Modul 09)
2. Prepare UAT scenarios document (`UAT_SCENARIOS.md`)
3. Set up client access to staging environment
```

---

## 5. Staging Environment Setup Checklist

### Pre-Deployment Verification

**Before deploying to staging**, verify these configurations match production (except secrets):

---

### 1. Environment Variables (Staging-Specific)

```bash
# Staging .env (Vercel/Railway dashboard)
NODE_ENV=staging  # Not "production"
DATABASE_URL=postgresql://staging.supabase.co/...  # Staging DB
REDIS_URL=redis://staging.upstash.io/...  # Staging cache

# Third-Party APIs (Sandbox Mode)
STRIPE_SECRET_KEY=***  # Test mode, not sk_live_
MIDTRANS_SERVER_KEY=***  # Sandbox key
SENDGRID_API_KEY=***  # Test sending quota

# Feature Flags (Staging-Specific)
ENABLE_FILE_VIRUS_SCAN=false  # ClamAV not running in staging
ENABLE_EMAIL_SENDING=true  # Use Mailpit test SMTP
ENABLE_PAYMENT_LIVE_MODE=false  # Sandbox only

# Encryption Keys (Different from Production)
ENCRYPTION_KEY=<staging-specific-key>  # NEVER reuse production key
JWT_SECRET=<staging-specific-secret>

# Public URLs
NEXT_PUBLIC_APP_URL=https://staging.example.com
NEXT_PUBLIC_API_URL=https://staging.example.com/api

# Monitoring (Staging-Specific)
SENTRY_DSN=https://...@sentry.io/staging  # Separate Sentry project
SENTRY_ENVIRONMENT=staging
```

**Critical Rules**:
- [ ] All secrets different from production (encryption key, JWT secret)
- [ ] Third-party APIs in sandbox/test mode
- [ ] Feature flags match staging limitations (virus scan disabled)
- [ ] Public URLs point to staging domain

---

### 2. Database Seeding (Staging Data)

**NEVER use production data dump in staging**. Use seed data:

```bash
# Seed staging database with dummy data
pnpm db:seed:staging

# Or manual SQL seed
psql $DATABASE_URL < scripts/staging-seed.sql
```

**Seed Data Requirements**:
- [ ] 10-20 test users (varied roles: admin, user, guest)
- [ ] 50-100 documents (cover all statuses: draft, pending, approved, rejected)
- [ ] 10-20 payment transactions (cover all states: pending, paid, expired, refunded)
- [ ] Edge cases: user with 0 documents, user with 1000 documents, expired sessions

**Data Sanitization** (if using production backup):
```sql
-- Hash all emails (GDPR compliance)
UPDATE users SET email = CONCAT('test+', id, '@example.com');

-- Scramble phone numbers
UPDATE users SET phone = '+628****3456' || RIGHT(id::text, 4);

-- Clear sensitive data
UPDATE documents SET file_path = NULL, encryption_key = NULL;
```

---

### 3. Feature Flags & Toggles

**Staging-Specific Flags**:
```typescript
// lib/config.ts
export const featureFlags = {
  enableVirusScan: process.env.ENABLE_FILE_VIRUS_SCAN === 'true',  // false in staging
  enableLivePayment: process.env.ENABLE_PAYMENT_LIVE_MODE === 'true',  // false in staging
  enableEmailSending: process.env.ENABLE_EMAIL_SENDING === 'true',  // true (Mailpit)
  enableRateLimiting: process.env.NODE_ENV === 'production',  // disabled in staging (easier testing)
};
```

**Why Disable in Staging**:
- Virus scan: ClamAV resource-heavy, not needed for test files
- Live payment: Avoid accidental charges
- Rate limiting: Allow unlimited test requests

---

### 4. Third-Party Service Configuration

**Payment Gateway (Midtrans/Stripe)**:
- [ ] Sandbox mode enabled
- [ ] Webhook URL points to staging: `https://staging.example.com/api/webhooks/midtrans`
- [ ] Test credit cards work: `4111 1111 1111 1111` (Stripe), `4811 1111 1111 1114` (Midtrans)

**File Storage (S3/R2)**:
- [ ] Separate staging bucket: `my-app-staging` (not production bucket)
- [ ] Public access blocked (presigned URLs only)
- [ ] Lifecycle policy: delete files >30 days (save cost)

**Email (SendGrid/SMTP)**:
- [ ] Staging uses Mailpit or Ethereal Email (no real emails sent)
- [ ] Or SendGrid test domain: `staging.example.com` (separate from production domain)

**Monitoring (Sentry)**:
- [ ] Separate Sentry project: `my-app-staging`
- [ ] Error sample rate 100% (capture all errors, not sampled like production)

---

### 5. DNS & SSL

**Domain**:
- [ ] Staging subdomain: `staging.example.com`
- [ ] SSL certificate valid (Let's Encrypt auto-renewal)
- [ ] No HSTS header (easier to switch between staging/local)

**Vercel/Railway Auto-Config**:
- Vercel: Auto-generates `*.vercel.app` preview URL
- Railway: Auto-generates `*.up.railway.app` staging URL

---

### 6. Access Control

**Who Can Access Staging**:
- [ ] Solo developer (you)
- [ ] Client UAT testers (credentials in vault)
- [ ] NOT public (add basic auth or IP whitelist if needed)

**Basic Auth Example** (Next.js middleware):
```typescript
// middleware.ts
export function middleware(req: NextRequest) {
  if (process.env.NODE_ENV === 'staging') {
    const auth = req.headers.get('authorization');
    if (auth !== 'Basic ' + btoa('admin:staging123')) {
      return new Response('Unauthorized', {
        status: 401,
        headers: { 'WWW-Authenticate': 'Basic' },
      });
    }
  }
}
```

---

### 7. Monitoring & Logging

**Staging-Specific Monitoring**:
- [ ] Healthcheck endpoint: `GET /api/health` returns 200
- [ ] Error tracking: Sentry captures all exceptions
- [ ] Log aggregation: Structured JSON logs (easier debugging)
- [ ] Performance monitoring: Lighthouse CI runs on every deploy

**Alerts** (Slack/Discord webhook):
```bash
# .github/workflows/staging-deploy.yml
- name: Notify deployment success
  run: |
    curl -X POST ${{ secrets.DISCORD_WEBHOOK_URL }} \
      -d '{"content":"✅ Staging deployed: https://staging.example.com"}'
```

---

### 8. Pre-SIT Smoke Test

**Before running full SIT**, verify basic functionality:

```bash
# 1. Healthcheck
curl https://staging.example.com/api/health
# Expected: {"status":"healthy","db":"connected"}

# 2. Auth works
curl -X POST https://staging.example.com/api/auth/login \
  -d '{"email":"test@example.com","password":"***"}'
# Expected: {"status":"success","token":"eyJ..."}

# 3. Database accessible
psql $DATABASE_URL -c "SELECT COUNT(*) FROM users;"
# Expected: 10-20 (seed data)

# 4. Redis cache works
redis-cli -u $REDIS_URL PING
# Expected: PONG
```

**If any smoke test fails**, fix before proceeding to SIT.

---

### Staging Environment Checklist Summary

- [ ] Environment variables configured (staging-specific)
- [ ] Database seeded with dummy data (10-20 users, 50-100 documents)
- [ ] Feature flags set (virus scan disabled, payment sandbox)
- [ ] Third-party services in sandbox mode (Midtrans, Stripe, SendGrid test)
- [ ] DNS & SSL configured (staging.example.com with valid cert)
- [ ] Access control enabled (basic auth or IP whitelist)
- [ ] Monitoring & logging active (Sentry, healthcheck)
- [ ] Pre-SIT smoke test passed (health, auth, DB, Redis)

**Status**: ✅ Ready for SIT


---

## Solo Developer Focus

# Panduan Quality Assurance & SIT Solo Developer

Dokumen ini adalah buku pedoman praktis bagi solo developer dalam menjalankan pengujian mutu perangkat lunak, verifikasi integrasi sistem (SIT), audit celah keamanan, dan uji beban konkurensi tanpa membuang waktu untuk pengujian manual yang berulang-ulang.

---

## 1. Filosofi Pengujian Solo Developer: "The Pragmatic Test Pyramid"

Kesalahan terbesar solo developer adalah mencoba meniru tim QA korporat dengan menulis ratusan skrip otomasi browser (Selenium / Cypress) yang lambat dan rapuh (*flaky*). Setiap kali ada perubahan class Tailwind atau tata letak HTML, pengujian browser tersebut gagal.

### Alokasi Energi Pengujian yang Efisien:
1. **70% Energi: Unit & Contract Tests**:
   - Uji logika murni (*pure functions*): validasi Zod, kalkulasi matematika, transformasi data, dan enkripsi/dekripsi AES-256.
   - Gunakan test runner cepat seperti **Vitest** (kecepatan eksekusi dalam hitungan milidetik).
2. **25% Energi: API Integration & System Integration Testing (SIT)**:
   - Uji endpoint API terhadap database uji lokal dan sandbox pihak ketiga (Payment Gateway, Cloud Storage, Email SMTP).
3. **5% Energi: 1 Critical Path E2E Smoke Test**:
   - Cukup satu pengujian alur kritis (*Core User Journey*) dari login hingga dokumen berstatus `SIGNED`.

---

## 2. Playbook Pengujian Integrasi Pihak Ketiga (SIT Playbook)

### 2.1 Pengujian Payment Gateway Sandbox (Midtrans / Xendit)
Saat menguji transaksi pembayaran, fokus utama adalah **keamanan webhook**:
- **Verifikasi Tanda Tangan Webhook (Signature Key)**:
  Pastikan backend Anda memverifikasi SHA-512 signature yang dikirim payment gateway untuk mencegah serangan webhook palsu (*spoofing*).
  ```typescript
  // Contoh verifikasi signature Midtrans
  const signature = crypto.createHash("sha512")
    .update(`${order_id}${status_code}${gross_amount}${server_key}`)
    .digest("hex");
  if (signature !== req.headers["x-callback-signature"]) {
    return Response.json({ error: "Invalid signature" }, { status: 403 });
  }
  ```
- **Simulasi Transaksi Sukses vs Gagal**:
  Kirim payload simulasi pembayaran sukses (`settlement`) dan pembayaran kedaluwarsa (`expire`) dari dashboard sandbox untuk memastikan mesin keadaan (*state machine*) status order berpindah dengan benar.

### 2.2 Pengujian Penyimpanan Dokumen (Cloudflare R2 / AWS S3)
- **Uji Enkripsi Biner**: Unduh file langsung via S3 CLI atau dashboard cloud. Buka file tersebut menggunakan PDF reader. File harus **rusak / gagal dibuka** (membuktikan enkripsi at-rest bekerja).
- **Uji Masa Kedaluwarsa Presigned URL**:
  Terbitkan presigned URL dengan durasi 5 detik untuk pengujian. Tunggu 6 detik, lalu buka link tersebut di browser. Browser wajib menerima respon `403 Forbidden` atau `Request has expired`.

### 2.3 Pengujian Email Transaksional (Zero Spamming)
- Gunakan layanan penangkap email lokal seperti **Mailpit** (via Docker) atau **Ethereal Email** saat pengujian lokal agar Anda tidak membuang kuota email API berbayar atau memicu deteksi spam filter.

---

## 3. Playbook Uji Beban & Konkurensi (Load Testing)

Solo developer wajib membuktikan sistem tidak akan tumbang saat puluhan orang mengakses aplikasi secara bersamaan.

### Skrip Uji Beban Cepat Menggunakan `k6`:

**JavaScript/TypeScript (Next.js, Node.js)**:
Buat berkas `scripts/load-test.js`:
```javascript
import http from "k6/http";
import { check, sleep } from "k6";

export const options = {
  vus: 50, // 50 Virtual Users bersamaan
  duration: "30s", // Selama 30 detik
  thresholds: {
    http_req_duration: ["p(95)<200"], // 95% request harus di bawah 200ms
    http_req_failed: ["rate<0.01"],   // Error rate harus di bawah 1%
  },
};

export default function () {
  const res = http.get("https://staging.domainklien.com/api/health");
  check(res, {
    "status is 200": (r) => r.status === 200,
  });
  sleep(1);
}
```

Jalankan: `k6 run scripts/load-test.js`

**PHP/Laravel (Alternatif dengan PHP Unit Test)**:
```bash
# Laravel Dusk atau PHPUnit dengan concurrent requests
vendor/bin/phpunit --testsuite=LoadTests
```

**Python (pytest + locust)**:
```bash
# Install: pip install locust
# Buat locustfile.py lalu jalankan:
locust -f locustfile.py --headless -u 50 -r 10 -t 30s --host=https://staging.domainklien.com
```

---

## 4. Checklist Audit Keamanan Mandiri (Security Gate)

Sebelum menyatakan lingkungan Staging siap untuk diuji klien, verifikasi 5 poin ini:
1. [x] **`pnpm audit`**: 0 kerentanan kritis atau tinggi.
2. [x] **Zero Secret Leak**: Tidak ada token AWS/S3 atau connection string database yang tertinggal di riwayat git commit.
3. [x] **IDOR Protection**: Pengguna A tidak dapat mengunduh dokumen Pengguna B dengan hanya mengganti ID di URL (`/api/v1/documents/UUID_B`).
4. [x] **Rate Limiting Aktif**: Percobaan login gagal lebih dari 5 kali berturut-turut otomatis memicu blokir sementara (*HTTP 429 Too Many Requests*).
5. [x] **Header Keamanan HTTP**: Header `Content-Security-Policy`, `X-Frame-Options`, dan `X-Content-Type-Options` terpasang rapi.
