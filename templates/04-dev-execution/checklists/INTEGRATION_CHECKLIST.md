# Integration Checklist (Third-Party Services)

**Module**: M06 Development Execution  
**Purpose**: Sequential checklist for integrating payment gateways, email services, storage, analytics

**Use with**: Stripe, Midtrans, SendGrid, Resend, AWS S3, Sentry, Mixpanel

---

## 1. Payment Gateway (Stripe / Midtrans)

### Sandbox Setup
- [ ] **Sandbox Environment Setup**:
  - [ ] Register Stripe / Midtrans sandbox developer account.
  - [ ] Set test mode API keys in `.env` (`STRIPE_SECRET_KEY=sk_test_...`, `STRIPE_WEBHOOK_SECRET=whsec_...`).
  - [ ] Verify no production keys (`sk_live_...`) are leaked in the `staging` branch.

### Transaction Initiation
- [ ] **Payment Transaction Initiation**:
  - [ ] Create API endpoint for Checkout Session (Stripe) or Snap Token (Midtrans) generation.
  - [ ] Save order reference number in local transaction table with initial `pending` status.

### Webhook Endpoint
- [ ] **Cryptographic Webhook Endpoint**:
  - [ ] `POST /api/v1/webhooks/payment` endpoint with raw body parser.
  - [ ] Validate cryptographic webhook signature (`stripe.webhooks.constructEvent` or Midtrans SHA512 signature check).
  - [ ] Immediately reject request with HTTP 400 if signature does not match.

### Idempotency
- [ ] **Webhook Idempotency Handling**:
  - [ ] Record every incoming event ID in `webhook_events` table.
  - [ ] If event ID has been processed previously, return HTTP 200 immediately without re-executing business mutations.

### Status Transition
- [ ] **Atomic Transaction Status Transition**:
  - [ ] Wrap order status updates (`paid`, `failed`, `expired`) and user feature activation in a database transaction (`db.$transaction`).
  - [ ] Send payment receipt confirmation email to user asynchronously.

---

## 2. Transactional Email Service (SendGrid / Resend)

### DNS Verification
- [ ] **Domain DNS Verification**:
  - [ ] Configure sender DNS records: SPF (`v=spf1`), DKIM, and DMARC (`p=reject` or `p=quarantine`).
  - [ ] Verify domain is confirmed active on the Resend / SendGrid dashboard.

### Email Client
- [ ] **Isolated Email Client**:
  - [ ] Create service module `email.service.ts` encapsulating email dispatch.
  - [ ] In `development` environment, log email content to the terminal or use a test service (Mailpit / Inbucket) instead of sending real emails.

### Automated Alerts
- [ ] **Automated Alerts & Receipts**:
  - [ ] Send critical transaction emails with attached PDF proof of payment / legal documents.
  - [ ] Configure `List-Unsubscribe` headers and unsubscribe links in regular notification emails.

---

## 3. File Storage (AWS S3 / Cloudflare R2)

### Bucket Configuration
- [ ] **Bucket & CORS Configuration**:
  - [ ] Create storage buckets with unique names per environment (`myproject-staging-vault`, `myproject-prod-vault`).
  - [ ] Disable direct public access (*Block Public Access: ON*). All access must go through presigned URLs or backend proxy.
  - [ ] Configure bucket CORS to only allow official web app origins with `GET`, `PUT`, `HEAD` methods.

### IAM Credentials
- [ ] **Least-Privilege IAM Credentials**:
  - [ ] Create application-specific IAM user / R2 API token with only `s3:PutObject` and `s3:GetObject` permissions on the relevant bucket prefix.
  - [ ] Do not use AWS Root / Cloudflare Admin credentials.

### Lifecycle Policies
- [ ] **Lifecycle Policies**:
  - [ ] Configure bucket lifecycle rules to automatically remove aborted partial uploads (*abort incomplete multipart uploads* after 7 days).

---

## 4. Product Analytics (Mixpanel / GA4 / PostHog)

### Privacy Compliance
- [ ] **Privacy-Compliant Initialization (UU PDP & GDPR)**:
  - [ ] Initialize analytics SDK only after user grants consent (*consent banner*).
  - [ ] Add DNT (*Do Not Track*) support flag.

### Core Telemetry
- [ ] **Core Telemetry Mapping**:
  - [ ] Track acquisition flow: `auth_signup_completed`, `auth_login_succeeded`.
  - [ ] Track core application value (*North Star action*): `document_created`, `document_exported`, `payment_completed`.
  - [ ] Identity resolution: link anonymous ID to authenticated user ID after login (`posthog.identify(userId)`).

### Data Scrubbing
- [ ] **Sensitive Data Scrubbing**:
  - [ ] Ensure analytics payloads do NOT contain sensitive PII (full name, national ID, full address, password, credit card details).

---

## 5. Application Monitoring & Error Tracking (Sentry)

### SDK Installation
- [ ] **Sentry SDK Installation**:
  - [ ] Install Sentry SDK on client side (Next.js client / Vite) and server runtime (Node.js / Python / Laravel).
  - [ ] Set environment tag (`staging`, `production`) and release tag based on git commit SHA (`git rev-parse HEAD`).

### Data Scrubbing
- [ ] **Sensitive Data Scrubbing (beforeSend Filter)**:
  - [ ] Configure `beforeSend` hook to scrub `Authorization` headers, session cookies, password values, and sensitive query parameters from stack traces.

### Performance Tracing
- [ ] **Performance Tracing & Slow Query Alerts**:
  - [ ] Configure trace sample rate (100% on staging for evaluation, 10% on production).
  - [ ] Configure alert threshold if database queries exceed > 500ms or API responses exceed > 2,000ms.

### Health Checks
- [ ] **Health Check Endpoints**:
  - [ ] Create `GET /api/healthz` endpoint (liveness check) responding with `OK` status.
  - [ ] Create `GET /api/readyz` endpoint (readiness check) verifying active connections to PostgreSQL and Redis.

---

## Verification Checklist

Before merging to staging:

### Payment Gateway
- [ ] Sandbox payment flow tested (create order → redirect → webhook received)
- [ ] Webhook signature validation working (reject invalid signatures)
- [ ] Order status transitions correctly (pending → paid → fulfilled)
- [ ] Idempotency prevents duplicate processing
- [ ] Receipt emails sent automatically

### Email Service
- [ ] DNS records verified (SPF, DKIM, DMARC)
- [ ] Test emails delivered successfully
- [ ] Email templates render correctly (HTML + plain text)
- [ ] Unsubscribe links functional
- [ ] Dev environment uses mock/logger (not real sends)

### File Storage
- [ ] Bucket CORS configured correctly
- [ ] Presigned URLs work for upload/download
- [ ] File size/type validation enforced
- [ ] Public access blocked (all files private)
- [ ] Lifecycle policies active (cleanup incomplete uploads)

### Analytics
- [ ] Consent banner functional (analytics only after approval)
- [ ] Core events tracking (signup, login, North Star actions)
- [ ] No PII in analytics payloads
- [ ] Identity resolution working (anonymous → user ID)

### Monitoring
- [ ] Sentry capturing errors (client + server)
- [ ] Sensitive data scrubbed from error reports
- [ ] Performance traces collected
- [ ] Health check endpoints responding
- [ ] Alerts configured (slow queries, high error rate)

---

**See Also**:
- `templates/04-dev-execution/checklists/backend-checklist.md` - Backend development
- `templates/04-dev-execution/checklists/frontend-checklist.md` - Frontend development
- `patterns/security/authentication.md` - Auth patterns
- `patterns/performance/caching-strategies.md` - Performance optimization
- M06 Development Execution - Core module documentation
