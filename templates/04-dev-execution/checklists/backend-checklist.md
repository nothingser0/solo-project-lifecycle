# Backend Development Checklist

**Module**: M06 Development Execution  
**Purpose**: Detailed sequential checklist for backend API, database, queues, storage

**Use with**: AI coding agents, solo developers executing M06

---

## 1. Database Setup & Migrations

### Connection & Pooling
- [ ] **Connection & Connection Pooling**:
  - [ ] Set database connection URL in `.env` (format: `postgresql://user:pass@host:5432/dbname?sslmode=prefer`).
  - [ ] Configure pooling (PgBouncer / Prisma connection limit / max pool size) to prevent connection exhaustion during traffic spikes.
  - [ ] Verify database connection timeouts (connect timeout: 5s, statement timeout: 30s).

### Schema Definition
- [ ] **DDL Schema Definition & Entity Models**:
  - [ ] Create user and account models (`User`, `Account`, `Session`, `Profile`).
  - [ ] Create core business entity models per `ARCHITECTURE.md` (e.g., `Document`, `Transaction`, `AuditLog`).
  - [ ] Enforce data integrity constraints: `NOT NULL`, `CHECK`, and `UNIQUE` at the database level.
  - [ ] Configure foreign key relational integrity clauses: `ON DELETE RESTRICT` (for financial/legal data) or `CASCADE` (for parent-owned child entities).

### Indexing Strategy
- [ ] **Indexing Strategy**:
  - [ ] Add indexes on all Foreign Key columns (`tenant_id`, `user_id`, `organization_id`).
  - [ ] Create compound indexes for common filter queries (e.g., `@@index([tenant_id, status, created_at])`).
  - [ ] Create unique indexes on unique identifier fields (e.g., `email`, `slug`, `transaction_code`).
  - [ ] Apply text search indexes (B-Tree/Trigram/Full-Text Search) on frequently searched columns.

### Soft Delete
- [ ] **Soft-Delete & Data Durability**:
  - [ ] Add `deleted_at TIMESTAMP NULL` column to all critical entity tables.
  - [ ] Set up query middleware / Prisma extension to automatically filter `deleted_at IS NULL` rows.

### Migration Execution
- [ ] **Migration Execution & Seeders**:
  - [ ] Generate the initial migration file (`prisma migrate dev --name init` / `php artisan migrate` / `makemigrations`).
  - [ ] Test migration rollback to ensure migrations are reversible.
  - [ ] Create initial data seeder script (`seed.ts`): superadmin account, basic reference data, and mock fixtures for local testing.

---

## 2. API Endpoints Development

### Authentication Endpoints
- [ ] **Authentication & Identity Endpoints**:
  - [ ] `POST /api/v1/auth/register`: Register new user, hash password (Argon2id min 12 rounds), return HTTP 201.
  - [ ] `POST /api/v1/auth/login`: Verify credentials, brute-force delay protection, issue session/JWT in HttpOnly cookie (`SameSite=Lax`, `Secure`).
  - [ ] `POST /api/v1/auth/logout`: Revoke token/session, clear authentication cookie.
  - [ ] `POST /api/v1/auth/refresh`: Rotate refresh token with token reuse detection.
  - [ ] `POST /api/v1/auth/forgot-password` & `POST /api/v1/auth/reset-password`: Cryptographic token with 15-minute TTL.
  - [ ] `GET /api/v1/auth/me`: Retrieve currently logged-in user profile.

### CRUD Endpoints
- [ ] **Core Business CRUD Endpoints**:
  - [ ] `GET /api/v1/{resources}`: List resources with status filters, date range, pagination, and tenant isolation.
  - [ ] `GET /api/v1/{resources}/:id`: Single resource detail with tenant ownership verification (prevent IDOR vulnerability).
  - [ ] `POST /api/v1/{resources}`: New resource creation wrapped in Zod validation and atomic database transaction.
  - [ ] `PATCH /api/v1/{resources}/:id`: Partial resource update with state-machine validation and optimistic locking.
  - [ ] `DELETE /api/v1/{resources}/:id`: Soft-delete resource, update `deleted_at`, record audit log.

### Search & Filter
- [ ] **Search & Filtering Endpoints**:
  - [ ] Sanitize search query strings (prevent wildcard abuse & regex DoS).
  - [ ] Multi-field filter support via query parameters (e.g., `?status=pending&role=manager&from=2026-01-01`).
  - [ ] Fuzzy matching or trigram search for minor typo tolerance on names/titles.

### Pagination
- [ ] **Pagination & Sorting Standardization**:
  - [ ] Implement cursor-based pagination for large volume datasets / infinite scroll.
  - [ ] Apply fallback limit & offset with strict bounds (`max_limit = 100`, default: 20).
  - [ ] Standardize JSON response format:

    {
      "data": [...],
      "meta": { "total": 142, "page": 1, "limit": 20, "has_more": true },
      "error": null
    }
    ```

---

## 3. Middleware Implementation

### Authentication Middleware
- [ ] **Authentication Middleware**:
  - [ ] Extract token from HttpOnly cookie or `Authorization: Bearer <token>` header.
  - [ ] Validate cryptographic signature and token expiration.
  - [ ] Inject user identity payload (`userId`, `tenantId`, `role`) into request context.
  - [ ] Return standard 401 Unauthorized if token is missing, malformed, or expired.

### Authorization Middleware
- [ ] **Role-Based Access Control (RBAC) & Tenant Isolation**:
  - [ ] Create guard middleware to validate user roles (`admin`, `member`, `guest`).
  - [ ] Validate tenant scope: every query must include a `tenant_id` filter to prevent cross-tenant data leaks.

### Validation Middleware
- [ ] **Validation Middleware**:
  - [ ] Automated Zod schema validation on `request.body`, `request.query`, and `request.params`.
  - [ ] Consistent 422 Unprocessable Entity error format with failed field details:
    ```json
    {
      "error": { "code": "VALIDATION_ERROR", "fields": { "email": "Invalid email format" } }
    }


### Rate Limiting
- [ ] **Rate Limiting Middleware**:
  - [ ] Apply IP & User ID-based rate limiting (in-memory sliding window / Redis).
  - [ ] Public routes: max 100 req/min; Auth routes (login/register): max 5 req/min.
  - [ ] Send standard headers: `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `Retry-After`.

### Security Headers
- [ ] **Security Headers & CORS Middleware**:
  - [ ] Configure CSP (Content Security Policy), HSTS (`max-age=31536000`), X-Frame-Options (`DENY`), X-Content-Type-Options (`nosniff`).
  - [ ] Strict CORS: Explicit staging/production origin whitelist; `Access-Control-Allow-Origin: *` prohibited when credentials/cookies are used.

---

## 4. Background Jobs, Queues & Workers

### Queue Setup
- [ ] **Queue Runtime Setup**:
  - [ ] Initialize task queue (BullMQ / Redis / Celery / Laravel Queue / River).
  - [ ] Separate worker configuration from HTTP server to avoid overloading the main event loop.

### Async Workers
- [ ] **Asynchronous Task Workers**:
  - [ ] PDF generation, watermarking, and legal document stamping worker.
  - [ ] File compression and hashing worker (SHA-256 integrity verification).
  - [ ] Transactional email delivery and webhook outbox delivery worker.

### Retry Policy
- [ ] **Resilience & Retry Policy**:
  - [ ] Apply exponential backoff with jitter on failed tasks (e.g., retry after 5s, 15s, 45s).
  - [ ] Configure Dead Letter Queue (DLQ) to capture tasks failing after 3 attempts.
  - [ ] Automated alerting if DLQ depth exceeds threshold.

---

## 5. File Upload & Storage Service

### Storage Abstraction
- [ ] **Storage Client Abstraction**:
  - [ ] Create uniform storage adapter (S3 / Cloudflare R2 / MinIO / Local filesystem).
  - [ ] Read credentials from `.env` (`S3_BUCKET`, `S3_REGION`, `S3_ACCESS_KEY`, `S3_SECRET_KEY`).

### Presigned URLs
- [ ] **Presigned URL Architecture**:
  - [ ] `POST /api/v1/storage/upload-url` endpoint: Generate presigned PUT URL with 15-minute TTL.
  - [ ] `GET /api/v1/storage/download-url/:id` endpoint: Generate presigned GET URL with 15-minute TTL and strict authorization.

### File Validation
- [ ] **Server-Side File Validation**:
  - [ ] Validate MIME type via file header magic bytes (not just reading file extension).
  - [ ] Enforce maximum file size limits (e.g., 15MB for PDF, 5MB for images).
  - [ ] Sanitize original filename (strip dangerous characters, use UUIDv4 as storage key).

### Encryption
- [ ] **Encryption At-Rest**:
  - [ ] Apply streaming AES-256-GCM encryption before sensitive files are written to storage bucket.

---

## 6. Email & Notifications

### Email Transport
- [ ] **Transactional Email Transport**:
  - [ ] Integrate Resend / SendGrid / SES SDK with logging fallback in local mode.
  - [ ] Configure fallback mode (mock logger) if email API key is not configured locally.

### Email Templates
- [ ] **Responsive HTML Email Templates**:
  - [ ] Account activation & email verification template.
  - [ ] Password reset template with TTL-bound link.
  - [ ] Document status notification template (e.g., "Document has been signed").
  - [ ] Provide plain-text version for every email for optimal deliverability.

### In-App Notifications
- [ ] **In-App Notification Dispatcher**:
  - [ ] Database model `Notification` (`id`, `user_id`, `title`, `body`, `read_at`, `created_at`).
  - [ ] `GET /api/v1/notifications` and `PATCH /api/v1/notifications/:id/read` endpoints.

### Webhook Handlers
- [ ] **Webhook Deliverability Handler**:
  - [ ] Webhook receiver endpoint for bounce and complaint events from email provider to automatically deactivate delivery to invalid emails.

---

## Verification Checklist

Before merging to staging:

- [ ] All API endpoints return consistent JSON structure
- [ ] Authentication flow tested (register → login → refresh → logout)
- [ ] RBAC verified (users cannot access other tenants' data)
- [ ] Rate limiting active on login/register endpoints
- [ ] Background jobs processing successfully
- [ ] File upload/download working with presigned URLs
- [ ] Email sending (or mock in dev) functional
- [ ] Database migrations reversible (tested rollback)
- [ ] Zero TypeScript errors (`tsc --noEmit`)
- [ ] No `any` types in new code

---

**See Also**:
- `templates/04-dev-execution/checklists/frontend-checklist.md` - Frontend development tasks
- `templates/04-dev-execution/checklists/integration-checklist.md` - Third-party integrations
- `patterns/security/authentication.md` - Auth implementation patterns
- `patterns/validation/zod-patterns.md` - Validation schemas
- M06 Development Execution - Core module documentation
