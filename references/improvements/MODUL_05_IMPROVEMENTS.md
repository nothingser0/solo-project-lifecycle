# Modul 05 Improvements: Architecture & Technical Specification

## 1. Timeline Estimation (by Project Scale)

| Phase | Kecil (3-6 tabel) | Menengah (10-20 tabel) | Besar (30+ tabel) | Enterprise (complex) |
|-------|------------------|------------------------|-------------------|---------------------|
| Tech Stack Selection | 1-2 jam | 2-3 jam | 4-6 jam | 8-12 jam (RFP evaluation) |
| Database Schema Design | 3-4 jam | 8-12 jam | 16-24 jam | 32-48 jam (DBA review) |
| API Contract Mapping | 2-3 jam | 6-8 jam | 12-16 jam | 24-32 jam (OpenAPI spec) |
| Security Blueprint | 2-3 jam | 4-6 jam | 8-12 jam | 16-24 jam (ISO 27001 compliance) |
| PRD/FSD Writing | 2-4 jam | 6-8 jam | 12-16 jam | 24-40 jam (formal approval) |
| Technical Sign-Off | 1 jam (email) | 2-3 jam (meeting) | 4-6 jam (presentation) | 8-16 jam (CAB approval) |
| **TOTAL** | **11-17 jam (1.5-2 hari)** | **28-40 jam (4-5 hari)** | **56-80 jam (7-10 hari)** | **112-172 jam (14-22 hari)** |

**Buffer Rule**: Add 30% buffer jika client slow response (typical: 2-5 hari delay untuk approval).

**Dependencies**: Modul 05 tidak bisa dimulai sebelum `DESIGN_SPEC.md` (Modul 04) frozen. Parallel work dengan Modul 04 = high rework risk.

---

## 2. PRD vs FSD Content Matrix

### Scope Boundary

| Content Type | PRD (Product) | FSD (Technical) | Notes |
|--------------|---------------|-----------------|-------|
| **User Stories** | ✅ Full detail | ❌ Reference only | PRD: "As admin, I can..." (acceptance criteria) |
| **RBAC Matrix** | ✅ Role x Permission | ✅ DB schema (role table) | PRD: business roles, FSD: implementation |
| **API Endpoints** | ✅ List + purpose | ✅ Full contract (JSON schema) | PRD: "POST /documents (create doc)", FSD: payload + error codes |
| **Database Schema** | ❌ Not included | ✅ Full ERD + DDL | PRD: entity names only (optional), FSD: complete SQL |
| **NFR Thresholds** | ✅ Business targets | ✅ Technical constraints | PRD: "response <200ms", FSD: "database query <50ms, API <150ms" |
| **KPI Metrics** | ✅ Business metrics | ❌ Not included | PRD: "70% user retention", FSD: none |
| **Security** | ✅ Compliance requirements | ✅ Implementation spec | PRD: "UU PDP compliant", FSD: "AES-256-GCM + KMS" |
| **Error Handling** | ✅ User-facing messages | ✅ Error code matrix | PRD: "show 'file too large'", FSD: "ERR_FILE_SIZE_EXCEEDED (413)" |
| **State Machines** | ❌ Not included | ✅ Transition diagrams | FSD only: "DRAFT → PENDING → APPROVED → REJECTED" |

### Example Scenario: Upload Document Feature

**PRD content**:
```markdown
## Feature: Document Upload

**User Story**: As a freelancer, I can upload tax documents (PDF/JPG) up to 10MB so I can submit proof of income.

**RBAC**: Freelancer role can upload, Admin role can view all uploads.

**API**: `POST /api/v1/documents` (create), `GET /api/v1/documents/:id` (view)

**NFR**: Upload success rate ≥99.5%, response time <2 seconds, file size limit 10MB.

**Error Handling**: Show "File too large" if >10MB, "Invalid format" if not PDF/JPG.

**KPI**: 80% documents uploaded within first 7 days of user registration.
```

**FSD content**:
```markdown
## API Contract: POST /api/v1/documents

**Request**:
```json
{
  "title": "Invoice Q3 2026",
  "file": "<base64_encoded_pdf>",
  "type": "income_proof"
}
```

**Response (Success)**:
```json
{
  "status": "success",
  "data": {
    "id": "doc_abc123",
    "url": "https://cdn.example.com/...",
    "created_at": "2026-09-30T10:15:30Z"
  }
}
```

**Response (Error)**:
```json
{
  "status": "error",
  "error": {
    "code": "FILE_SIZE_EXCEEDED",
    "message": "File size exceeds 10MB limit",
    "http_status": 413
  }
}
```

**Database Schema**:
```sql
CREATE TABLE documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  title TEXT NOT NULL,
  file_path TEXT NOT NULL, -- Encrypted S3 key
  file_size_bytes BIGINT NOT NULL CHECK (file_size_bytes > 0 AND file_size_bytes <= 10485760),
  status TEXT NOT NULL CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_documents_user_status ON documents(user_id, status);
```

**Security**:
- File encrypted with AES-256-GCM before S3 upload
- Encryption key stored in AWS Secrets Manager (Kecil tier) or HashiCorp Vault (Menengah tier)
- Presigned URL expires in 15 minutes
- File scan with ClamAV (virus check) before acceptance

**State Machine**:
```
PENDING → (admin review) → APPROVED / REJECTED
```

**NFR Breakdown**:
- File upload latency: <1.5s (average 500KB file)
- Database query: <50ms
- S3 upload: <1s
- Total API response: <2s
```

**Key Insight**: PRD = "what and why" (business logic), FSD = "how" (technical implementation). No overlap, full traceability.

---

## 3. API Error Standardization (3-Layer Protocol)

### Layer 1: HTTP Status Codes (Transport Layer)

Use standard RFC status codes:
- `200 OK`: Success
- `201 Created`: Resource created
- `400 Bad Request`: Client input validation failed
- `401 Unauthorized`: Missing/invalid auth token
- `403 Forbidden`: Authenticated but no permission
- `404 Not Found`: Resource doesn't exist
- `409 Conflict`: State conflict (e.g., duplicate email)
- `413 Payload Too Large`: File >10MB
- `422 Unprocessable Entity`: Business rule violation (e.g., insufficient balance)
- `429 Too Many Requests`: Rate limit exceeded
- `500 Internal Server Error`: Unhandled server error
- `503 Service Unavailable`: Dependency down (DB, payment gateway)

### Layer 2: Business Error Codes (Application Layer)

Custom error codes for client handling.

**Format**: `DOMAIN_ENTITY_REASON` (uppercase, snake_case)

**Examples**:
- `AUTH_TOKEN_EXPIRED`
- `FILE_SIZE_EXCEEDED`
- `PAYMENT_INSUFFICIENT_BALANCE`
- `DOCUMENT_ALREADY_APPROVED`
- `TAX_CALCULATION_INVALID_RATE`

**Registry** (maintain in `docs/specs/FSD.md`):

| Code | HTTP Status | User Message (ID) | Retry? | Action |
|------|-------------|-------------------|--------|--------|
| AUTH_TOKEN_EXPIRED | 401 | Token Anda kedaluwarsa, silakan login ulang | No | Redirect /login |
| FILE_SIZE_EXCEEDED | 413 | Ukuran file melebihi 10MB | No | Show file size limit |
| PAYMENT_INSUFFICIENT_BALANCE | 422 | Saldo tidak mencukupi | Yes | Show topup flow |
| DOCUMENT_ALREADY_APPROVED | 409 | Dokumen sudah disetujui, tidak bisa diedit | No | Disable edit button |
| DB_CONNECTION_FAILED | 503 | Sistem sedang maintenance, coba lagi | Yes | Retry after 30s |

### Layer 3: User-Facing Messages (Presentation Layer)

Localized, non-technical, actionable messages for end users.

**Bad** ❌:
```json
{
  "error": "Sequelize validation error: notNull Violation: user.email cannot be null"
}
```

**Good** ✅:
```json
{
  "status": "error",
  "error": {
    "code": "VALIDATION_EMAIL_REQUIRED",
    "message": "Email wajib diisi",
    "field": "email",
    "http_status": 400
  }
}
```

### Standard Error Response Schema

```typescript
type ErrorResponse = {
  status: "error";
  error: {
    code: string;              // Business error code (AUTH_TOKEN_EXPIRED)
    message: string;           // User-facing message (Indonesian default)
    field?: string;            // Field name for validation errors
    http_status: number;       // HTTP status code (for client retry logic)
    trace_id?: string;         // Correlation ID for debugging
    timestamp: string;         // ISO 8601 timestamp
  };
};
```

### Implementation Checklist

- [ ] All API endpoints return uniform error schema
- [ ] Error codes registered in FSD.md
- [ ] Frontend has error code → user message mapping
- [ ] Sentry/logging captures `trace_id` for debugging
- [ ] Rate limiting errors include `Retry-After` header

---

## 4. Database Migration Strategy (Versioned, Reversible)

### Tool Selection by Stack

| Stack | Migration Tool | Why |
|-------|---------------|-----|
| Next.js + Prisma | **Prisma Migrate** | Built-in, type-safe, shadow DB for safety |
| Laravel | **Laravel Migrations** | Artisan commands, rollback support |
| Node.js/Go raw SQL | **Flyway** or **golang-migrate** | Language-agnostic, production-grade |
| Enterprise | **Liquibase** | XML/YAML changesets, audit trail |

### Migration Workflow (Prisma Example)

#### 1. Local Development

```bash
# Edit schema.prisma
model User {
  id    String @id @default(uuid())
  email String @unique
  @@index([email])
}

# Generate migration
npx prisma migrate dev --name add_user_email_index

# Output: migrations/20260930_add_user_email_index.sql
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");
```

#### 2. Staging Deployment

```bash
# Dry-run (check SQL without executing)
npx prisma migrate deploy --preview

# Apply migrations
npx prisma migrate deploy
```

#### 3. Production Deployment (Zero-Downtime)

```sql
-- Bad ❌ (locks table, blocks writes)
ALTER TABLE users ADD COLUMN phone TEXT NOT NULL;

-- Good ✅ (add nullable first, backfill, then constrain)
-- Step 1: Add column nullable (no lock)
ALTER TABLE users ADD COLUMN phone TEXT;

-- Step 2: Backfill data in batches (app code)
UPDATE users SET phone = '' WHERE phone IS NULL LIMIT 1000;

-- Step 3: Make NOT NULL after 100% backfilled
ALTER TABLE users ALTER COLUMN phone SET NOT NULL;
```

### Breaking Changes Protocol

**Scenario**: Client request CR — "change `status` column from TEXT to ENUM"

**Original**:
```sql
CREATE TABLE documents (
  status TEXT CHECK (status IN ('draft', 'pending', 'approved'))
);
```

**CR**: Add new status `'archived'`, disallow `'draft'`

**Migration Plan** (3-Step Expand-Migrate-Contract):

```sql
-- Migration 1: Expand (add new column, keep old)
ALTER TABLE documents ADD COLUMN status_new TEXT 
  CHECK (status_new IN ('pending', 'approved', 'archived'));

-- Migration 2: Backfill (app code reads old, writes both)
UPDATE documents SET status_new = 
  CASE 
    WHEN status = 'draft' THEN 'pending'
    ELSE status
  END;

-- Migration 3: Contract (drop old column after 100% migrated)
ALTER TABLE documents DROP COLUMN status;
ALTER TABLE documents RENAME COLUMN status_new TO status;
```

**Timeline**: 3 deployments over 7-14 days (allow traffic to drain old code).

### Rollback Strategy

**Prisma**:
```bash
# Rollback last migration
npx prisma migrate resolve --rolled-back 20260930_add_user_email_index

# Manual revert (if data corrupted)
# 1. Restore DB backup from before migration
# 2. Re-apply migrations up to known good state
```

**Safety Checklist**:
- [ ] Backup database before production migration
- [ ] Test migration on staging with production-like data volume
- [ ] Breaking changes use Expand-Migrate-Contract pattern
- [ ] Rollback plan documented in migration file comments
- [ ] Large migrations (>1M rows) run in batches with progress logging

---

## 5. Non-Functional Requirements (NFR) Comprehensive Template

### 1. Performance

| Metric | Kecil (MVP) | Menengah (SaaS) | Besar (Scale-up) | Enterprise |
|--------|-------------|-----------------|------------------|-----------|
| **API Latency (P95)** | <500ms | <200ms | <100ms | <50ms |
| **Page Load (P95)** | <3s | <2s | <1.5s | <1s |
| **Database Query (P95)** | <200ms | <100ms | <50ms | <20ms |
| **Concurrent Users** | 50 | 500 | 5,000 | 50,000 |
| **Throughput (req/s)** | 10 | 100 | 1,000 | 10,000 |

### 2. Scalability

- **Vertical Scaling**: CPU/RAM upgrade without code change (target: 4x capacity with 2x hardware)
- **Horizontal Scaling**: Add more instances (stateless app, session in Redis/DB)
- **Database**: Read replicas for >10k daily users, sharding for >1M users

### 3. Security

- [ ] HTTPS/TLS 1.3 enforced (no HTTP)
- [ ] Password hashing: Argon2id or bcrypt (cost ≥12)
- [ ] Encryption at rest: AES-256 for sensitive data
- [ ] Presigned URLs for file access (max 15 min expiry)
- [ ] Rate limiting: 5 attempts/15 min for auth endpoints
- [ ] OWASP Top 10 compliance verified
- [ ] UU PDP No. 27/2022 compliance (data minimization, consent, retention)

### 4. Availability & Reliability

| Metric | Kecil | Menengah | Besar | Enterprise |
|--------|-------|----------|-------|-----------|
| **Uptime SLA** | 99% (3.6 hari/tahun down) | 99.5% (1.8 hari/tahun) | 99.9% (8.7 jam/tahun) | 99.99% (52 menit/tahun) |
| **RTO (Recovery Time)** | 4 jam | 1 jam | 15 menit | 5 menit |
| **RPO (Data Loss)** | 24 jam | 1 jam | 5 menit | 0 (real-time replication) |
| **Backup Frequency** | Daily | Every 6 hours | Hourly | Continuous (CDC) |

### 5. Maintainability

- [ ] Structured logging (JSON format, trace_id per request)
- [ ] Error monitoring: Sentry or Rollbar integrated
- [ ] Health check endpoints: `/health` (200 OK if app + DB reachable)
- [ ] Database migrations versioned and reversible
- [ ] Dependency updates: security patches within 7 days, major versions quarterly

### 6. Usability

- [ ] Lighthouse Accessibility score ≥90 (WCAG AA compliance)
- [ ] Mobile responsive (375px, 768px, 1440px tested)
- [ ] Error messages user-friendly (Indonesian, no stack traces)
- [ ] Loading states and skeleton loaders (no blank screens)

### 7. Compliance & Legal

- [ ] UU PDP No. 27/2022: consent management, data retention policy, breach notification
- [ ] GDPR (if EU users): right to erasure, data portability
- [ ] PCI DSS (if handling cards): never store CVV, tokenize card numbers
- [ ] Tax compliance: e-Faktur integration (if B2B invoicing)

### 8. Disaster Recovery

- [ ] Database backups: automated daily, stored off-site (S3 Glacier)
- [ ] Backup restoration tested quarterly (RTO/RPO validation)
- [ ] Incident response plan documented (`templates/08-maintenance-ops/INCIDENT_RESPONSE_TEMPLATE.md`)
- [ ] Runbook for common failures (DB down, API timeout, payment gateway offline)

### NFR Validation Checklist (Pre-Launch)

- [ ] Load test with k6: simulate 2x expected peak traffic
- [ ] Chaos engineering: kill DB connection, simulate API timeout
- [ ] Security scan: OWASP ZAP or Burp Suite automated scan
- [ ] Backup restoration drill: restore from backup to staging
- [ ] Monitoring alerts configured: CPU >80%, error rate >1%, response time >500ms

---

## Summary

These improvements fill 5 critical gaps in Modul 05:

1. **Timeline Estimation** — Konkret per scale tier (1.5-22 hari), buffer 30%, dependency pada Modul 04.
2. **PRD vs FSD Content Matrix** — Clear boundary: PRD = what/why, FSD = how, dengan contoh lengkap Upload Document feature.
3. **API Error Standardization** — 3-layer protocol (HTTP status, business code, user message), registry template, TypeScript schema.
4. **Database Migration Strategy** — Tool selection, zero-downtime workflow, Expand-Migrate-Contract pattern, rollback protocol.
5. **NFR Template** — 8 categories (performance, scalability, security, availability, maintainability, usability, compliance, disaster recovery) dengan metric konkret per scale tier.

Load reference ini via: `skill_view(name='solo-project-lifecycle', file_path='references/improvements/MODUL_05_IMPROVEMENTS.md')` sebelum eksekusi Modul 05.
