# Modul 06 Improvements: Development Execution & AI Agent Workflow

## 1. Timeline Estimation (by Project Scale)

| Phase | Kecil (3-6 tabel) | Menengah (10-20 tabel) | Besar (30+ tabel) | Enterprise |
|-------|------------------|------------------------|-------------------|-----------|
| Scaffold + 7 Harness Setup | 1-2 jam | 2-3 jam | 3-4 jam | 4-6 jam (custom framework) |
| UI Implementation | 8-12 jam | 20-30 jam | 40-60 jam | 80-120 jam (multi-platform) |
| Database Migration + Seed | 2-3 jam | 4-6 jam | 8-12 jam | 16-24 jam (data import) |
| Backend API Development | 12-20 jam | 40-60 jam | 80-120 jam | 160-240 jam |
| Frontend-Backend Wiring | 4-6 jam | 12-16 jam | 24-32 jam | 48-64 jam |
| Smoke Test + Audit | 2-3 jam | 4-6 jam | 8-12 jam | 16-24 jam |
| **TOTAL** | **29-46 jam (4-6 hari)** | **82-121 jam (10-15 hari)** | **163-240 jam (20-30 hari)** | **324-478 jam (40-60 hari)** |

**Assumptions**:
- AI agent (Cursor/Claude Code/OpenCode) handles 60-70% boilerplate (CRUD, validation, auth)
- Manual intervention: business logic, complex formulas, third-party integration (30-40%)
- Buffer 25% untuk debugging, rework, client feedback iteration

**Bottlenecks**:
- Third-party API integration (payment, OCR, tax API): +20-40 jam per integration
- Complex business rules (tax calculation formulas, approval workflows): +10-20 jam
- File processing (PDF generation, image optimization, video encoding): +8-16 jam

**Dependencies**:
- Modul 06 cannot start until `PRD.md` + `FSD.md` (Modul 05) approved
- UI scaffold depends on `DESIGN.md` + `DESIGN_SPEC.md` (Modul 04) frozen

---

## 2. AI Agent Delegation Strategy (Task Routing Matrix)

### Capability Tier by Tool

| Tool | Strength | Weakness | Best For | Avoid For |
|------|----------|----------|----------|-----------|
| **Cursor** | Fast autocomplete, inline edit | Hallucination on complex logic | CRUD, UI components, Zod schemas | Security code, complex algorithms |
| **Claude Code** | Reasoning, multi-file refactor | Slower (network latency) | Architecture planning, debugging, test generation | Real-time coding (slow feedback) |
| **OpenCode** | MCP integration (Stitch, DB) | Limited reasoning depth | API scaffolding, DB migration, Stitch import | Business logic validation |
| **GitHub Copilot** | Fast, context-aware | Limited multi-file awareness | Function completion, utility helpers | Large-scale refactoring |

### Task Delegation Decision Tree

```text
Task: [Feature/Bug/Refactor]
│
├─ Security-Sensitive? (Auth, Encryption, Payment)
│  ├─ YES → Manual coding + AI documentation only
│  └─ NO → Continue
│
├─ Complex Business Logic? (Tax calculation, Approval workflow)
│  ├─ YES → AI draft + Manual review & test
│  └─ NO → Continue
│
├─ Third-Party Integration? (Stripe, Midtrans, AWS)
│  ├─ YES → Manual test + AI documentation
│  └─ NO → Continue
│
├─ Boilerplate CRUD? (Create/Read/Update/Delete standard)
│  ├─ YES → Fully autonomous AI (Cursor/OpenCode)
│  └─ NO → Continue
│
└─ UI Components? (Forms, Tables, Cards)
   └─ YES → AI scaffold + Manual polish (accessibility, responsive)
```

### Autonomy Level by Task Type

| Task Type | Autonomy | Review Depth | Example |
|-----------|----------|--------------|---------|
| **CRUD API** | 90% autonomous | Smoke test only | `POST /api/documents` (create doc) |
| **Zod Schema** | 95% autonomous | Type-check only | Validate user input |
| **UI Components** | 80% autonomous | Accessibility audit | Button, Card, Form |
| **Database Migration** | 70% autonomous | Manual verify constraints | Add FK, index, CHECK |
| **Business Logic** | 40% autonomous | Manual review + unit test | Tax calculation formula |
| **Auth/Encryption** | 20% autonomous | Manual implement + audit | Argon2id hash, AES-256 encrypt |
| **Third-Party API** | 30% autonomous | Manual integration test | Midtrans payment, AWS S3 upload |

### Quality Gate per Autonomy Level

**90-95% Autonomous** (CRUD, Schema):
- [ ] AI generates code
- [ ] Run smoke test (`pnpm run test:smoke`)
- [ ] Type-check passes (`tsc --noEmit`)
- [ ] Commit without manual review

**70-80% Autonomous** (UI, DB Migration):
- [ ] AI generates code
- [ ] Manual spot-check (1-2 files)
- [ ] Run targeted test (component test, migration dry-run)
- [ ] Commit after spot-check

**40% Autonomous** (Business Logic):
- [ ] AI drafts code
- [ ] Manual review entire implementation
- [ ] Write unit test (cover edge cases)
- [ ] Manual test with real data
- [ ] Commit after full review

**20-30% Autonomous** (Security, Third-Party):
- [ ] AI provides documentation/reference
- [ ] Manual implement from scratch or heavily modify AI draft
- [ ] Security audit (OWASP checklist)
- [ ] Integration test with sandbox/test mode
- [ ] Commit after audit + test pass

### Example Workflow: Implement Document Upload Feature

**Task Breakdown**:
1. ✅ Zod schema (`DocumentUploadSchema`) → **95% AI** (Cursor autocomplete)
2. ✅ API route handler boilerplate (`POST /api/documents`) → **90% AI** (OpenCode scaffold)
3. ⚠️ File encryption (AES-256-GCM stream) → **20% AI** (manual implement, AI reference docs)
4. ⚠️ S3 presigned URL generation → **30% AI** (AI draft, manual test with AWS sandbox)
5. ✅ Database `documents` table insert → **90% AI** (Prisma Client)
6. ✅ Frontend upload form UI → **80% AI** (Claude Code scaffold, manual a11y check)
7. ⚠️ Virus scan integration (ClamAV) → **30% AI** (manual integration, AI config docs)

**Estimated Time**:
- AI execution: 2-3 jam (tasks 1,2,5,6)
- Manual coding: 4-6 jam (tasks 3,4,7)
- **Total**: 6-9 jam

---

## 3. Smoke Test Specification (Fast Confidence Check)

### Goal

Smoke test bukan full test suite. Target: **<2 menit execution**, catch **80% critical failures** (build errors, DB connection, auth broken).

### 3-Tier Smoke Test

#### Tier 1: Compilation & Linting (30 detik)

```bash
# package.json scripts
{
  "test:smoke": "npm-run-all test:smoke:*",
  "test:smoke:types": "tsc --noEmit",
  "test:smoke:lint": "eslint --max-warnings 0 src/",
  "test:smoke:audit": "pnpm audit --audit-level high --prod"
}
```

**Pass Criteria**:
- [ ] TypeScript type-check 0 errors
- [ ] ESLint 0 warnings (enforce AGENTS.md rules: no `any`, no unused vars)
- [ ] No high/critical npm vulnerabilities in production dependencies

#### Tier 2: Critical Unit Assertions (30 detik)

Test **business-critical functions only** (not exhaustive unit tests).

**`tests/smoke/critical.test.ts`**:
```typescript
import { describe, it, expect } from 'vitest';
import { calculatePPh21 } from '@/lib/tax/pph21';
import { encryptBuffer, decryptBuffer } from '@/lib/crypto/aes256';

describe('Smoke Test: Critical Functions', () => {
  // Tax calculation (core business logic)
  it('calculates PPh 21 correctly for income 100M', () => {
    const result = calculatePPh21({ income: 100_000_000, ptkp: 'TK0' });
    expect(result.tax).toBe(11_500_000); // Pre-calculated correct value
  });

  // Encryption (security-critical)
  it('encrypts and decrypts buffer correctly', () => {
    const original = Buffer.from('sensitive data');
    const key = '0'.repeat(64); // 32-byte hex key
    const encrypted = encryptBuffer(original, key);
    const decrypted = decryptBuffer(encrypted, key);
    expect(decrypted.toString()).toBe('sensitive data');
  });

  // Zod schema (validation gate)
  it('validates document upload schema', async () => {
    const { CreateDocumentSchema } = await import('@/lib/schemas/document');
    const valid = { title: 'Test Doc', type: 'invoice', file_size: 5000 };
    const invalid = { title: 'A', type: 'invalid', file_size: 11_000_000 };
    
    expect(CreateDocumentSchema.safeParse(valid).success).toBe(true);
    expect(CreateDocumentSchema.safeParse(invalid).success).toBe(false);
  });
});
```

**Run**: `vitest run tests/smoke/ --reporter=dot`

**Pass Criteria**:
- [ ] All assertions pass (3/3 tests OK)
- [ ] Execution time <30 seconds

#### Tier 3: Integration Health Probes (60 detik)

Test **infrastructure connectivity** (DB, Redis, S3).

**`tests/smoke/integration.test.ts`**:
```typescript
import { describe, it, expect } from 'vitest';
import { db } from '@/lib/db';
import { redis } from '@/lib/redis';
import { s3Client } from '@/lib/s3';

describe('Smoke Test: Infrastructure', () => {
  it('connects to database', async () => {
    const result = await db.$queryRaw`SELECT 1 as health`;
    expect(result[0].health).toBe(1);
  });

  it('connects to Redis cache', async () => {
    await redis.set('smoke_test', 'ok', 'EX', 10);
    const value = await redis.get('smoke_test');
    expect(value).toBe('ok');
  });

  it('connects to S3 storage', async () => {
    const command = new ListBucketsCommand({});
    const response = await s3Client.send(command);
    expect(response.$metadata.httpStatusCode).toBe(200);
  });

  it('API /health endpoint responds', async () => {
    const res = await fetch('http://localhost:3000/api/health');
    expect(res.status).toBe(200);
    const json = await res.json();
    expect(json.status).toBe('healthy');
  });
});
```

**Setup**: Start dev server in background before test (`pnpm dev &`)

**Pass Criteria**:
- [ ] All probes succeed (4/4 tests OK)
- [ ] Execution time <60 seconds

### Smoke Test CI/CD Integration

**GitHub Actions** (`.github/workflows/smoke-test.yml`):
```yaml
name: Smoke Test
on: [push, pull_request]

jobs:
  smoke:
    runs-on: ubuntu-latest
    timeout-minutes: 3  # Fail if >3 min (smoke test should be fast)
    
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      
      - run: pnpm install --frozen-lockfile
      - run: pnpm run test:smoke
      
      - name: Notify on failure
        if: failure()
        run: |
          curl -X POST ${{ secrets.DISCORD_WEBHOOK_URL }} \
            -H 'Content-Type: application/json' \
            -d '{"content": "🚨 Smoke test failed on commit ${{ github.sha }}"}'
```

### What Smoke Test Does NOT Cover

❌ **NOT tested** (defer to Modul 07 SIT):
- Third-party API integration (Midtrans payment, SendGrid email)
- File upload end-to-end (UI → API → S3 → DB)
- User authentication flows (login, logout, session expiry)
- Performance/load testing (concurrent requests, large file uploads)
- Security penetration testing (OWASP Top 10 vulnerabilities)

✅ **Smoke test = Build confidence**, not exhaustive validation.

---

## 4. Environment Variable Management (Secrets & Config)

### Classification (Secret vs Config)

| Category | Examples | Storage | Commit? |
|----------|----------|---------|---------|
| **Secrets** (sensitive) | `DATABASE_URL`, `STRIPE_SECRET_KEY`, `JWT_SECRET`, `ENCRYPTION_KEY` | `.env` (git-ignored), Vercel/Railway dashboard | ❌ NEVER |
| **Config** (non-sensitive) | `NEXT_PUBLIC_APP_URL`, `PAGINATION_DEFAULT_SIZE`, `MAX_FILE_SIZE_MB` | `.env.example` (git-tracked) | ✅ YES |
| **Public** (browser-accessible) | `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY`, `NEXT_PUBLIC_SENTRY_DSN` | `.env` + `.env.example` | ✅ YES (public) |

### Workflow per Environment

#### 1. Local Development

**`.env` (git-ignored, create manually from `.env.example`)**:
```bash
# Copy template
cp .env.example .env

# Fill with local values
DATABASE_URL="postgresql://localhost:5432/myapp_dev"
REDIS_URL="redis://localhost:6379"
STRIPE_SECRET_KEY="sk_test_..." # Test mode key
ENCRYPTION_KEY="..." # Generate: openssl rand -hex 32
JWT_SECRET="..." # Generate: openssl rand -base64 32
```

**`.env.example` (git-tracked, safe template)**:
```bash
# Database
DATABASE_URL="postgresql://user:password@host:5432/dbname"

# Redis Cache
REDIS_URL="redis://localhost:6379"

# Stripe (use test mode keys for local/staging)
STRIPE_SECRET_KEY="sk_test_..."
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY="pk_test_..."

# Encryption (NEVER use same key for dev/prod)
ENCRYPTION_KEY="<generate-with-openssl-rand-hex-32>"

# JWT
JWT_SECRET="<generate-with-openssl-rand-base64-32>"

# Feature Flags
ENABLE_FILE_VIRUS_SCAN="false" # Set true in production

# Config (non-secret)
MAX_FILE_SIZE_MB="10"
PAGINATION_DEFAULT_SIZE="20"
```

#### 2. Staging Deployment (Vercel/Railway)

**Vercel Dashboard → Project Settings → Environment Variables**:
```
DATABASE_URL = postgresql://staging.supabase.co/...
STRIPE_SECRET_KEY = sk_test_...  # Still test mode
ENCRYPTION_KEY = <different-from-local>
JWT_SECRET = <different-from-local>
ENABLE_FILE_VIRUS_SCAN = true
```

**Railway Dashboard → Variables**:
Same as Vercel, but Railway auto-provides `DATABASE_URL` if using Railway Postgres.

**Sync Script** (optional, if using `.env.staging` file):
```bash
# .env.staging (git-ignored, manual sync to dashboard)
vercel env add DATABASE_URL production < .env.staging
```

#### 3. Production Deployment

**Critical Rules**:
- [ ] **NEVER** use test mode keys (`sk_test_`, `pk_test_`)
- [ ] **ALWAYS** generate new `ENCRYPTION_KEY` and `JWT_SECRET` (different from dev/staging)
- [ ] **ENABLE** security features (`ENABLE_FILE_VIRUS_SCAN=true`, `FORCE_HTTPS=true`)
- [ ] **ROTATE** secrets quarterly (Q1, Q2, Q3, Q4)

**Vercel Production Env Vars**:
```
DATABASE_URL = postgresql://prod.supabase.co/... # Production DB
STRIPE_SECRET_KEY = sk_live_... # LIVE mode key
ENCRYPTION_KEY = <unique-prod-only-key>
JWT_SECRET = <unique-prod-only-key>
ENABLE_FILE_VIRUS_SCAN = true
FORCE_HTTPS = true
SENTRY_DSN = https://...@sentry.io/... # Error tracking
```

### Security Checklist

- [ ] `.env` added to `.gitignore` (never commit)
- [ ] `.env.example` has placeholder values (no real secrets)
- [ ] Staging uses test mode keys (Stripe `sk_test_`, Midtrans sandbox)
- [ ] Production keys rotated quarterly
- [ ] No hardcoded secrets in code (`process.env` only)
- [ ] Vercel/Railway environment variables configured per environment (dev/staging/prod)

### Secret Rotation Protocol

**Quarterly rotation** (every 3 months):
1. Generate new `ENCRYPTION_KEY` and `JWT_SECRET`
2. Update Vercel/Railway dashboard (production + staging)
3. Re-encrypt existing data with new key (migration script)
4. Invalidate old JWT tokens (force re-login)
5. Document rotation in `CHANGELOG.md`

**Emergency rotation** (if leaked):
1. Revoke leaked key immediately (Stripe dashboard, database password reset)
2. Generate new key
3. Deploy with new key (emergency release)
4. Force user re-login (flush sessions)
5. Post-mortem analysis (how leaked? prevent recurrence)

---

## 5. Verification Checklist Template (VERIFY_LOCAL.md)

Create `docs/VERIFY_LOCAL.md` dengan checklist comprehensive:

### Template Structure

```markdown
# Local Development Verification Report

**Date**: 2026-09-30  
**Branch**: `staging`  
**Commit**: `a3f52b1`  
**Verified by**: [Your Name]

---

## 1. Build & Compilation

- [ ] TypeScript type-check: `pnpm run type-check` → Exit code 0
- [ ] Build success: `pnpm run build` → No errors
- [ ] ESLint warnings: 0 (enforce `--max-warnings 0`)

**Evidence**:
```bash
$ pnpm run type-check
✓ Type-check completed in 3.2s (0 errors)

$ pnpm run build
✓ Build completed in 12.4s
  Route (app)                                Size     First Load JS
  ┌ ○ /                                      1.2 kB          85 kB
  ├ ○ /dashboard                             2.3 kB          87 kB
  └ ○ /api/health                            0.5 kB          82 kB
○  (Static)  prerendered as static HTML
```

---

## 2. Database & Migrations

- [ ] Migration applied: `pnpm prisma migrate deploy` → Success
- [ ] Seed data inserted: `pnpm db:seed` → 10 users, 25 documents
- [ ] Foreign key constraints verified: Manual check `\d documents` in psql

**Evidence**:
```sql
-- psql output
myapp_dev=# \d documents
Column       | Type                     | Constraints
-------------|--------------------------|-------------------------
id           | uuid                     | PK, default gen_random_uuid()
user_id      | uuid                     | FK → users(id) ON DELETE RESTRICT
title        | text                     | NOT NULL
file_size    | bigint                   | CHECK (file_size > 0 AND file_size <= 10485760)
status       | text                     | CHECK (status IN ('pending', 'approved', 'rejected'))
created_at   | timestamptz              | NOT NULL, default NOW()

Indexes:
  "documents_pkey" PRIMARY KEY (id)
  "idx_documents_user_status" btree (user_id, status)
```

---

## 3. API Endpoints (Manual Smoke Test)

Test **5 critical endpoints** via `curl` or Postman:

### 3.1 Health Check
```bash
$ curl http://localhost:3000/api/health
{"status":"healthy","timestamp":"2026-09-30T10:15:30Z","db":"connected"}
```
- [ ] Status 200 OK
- [ ] `db` field = "connected"

### 3.2 User Login
```bash
$ curl -X POST http://localhost:3000/api/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"test@example.com","password":"test123"}'
{"status":"success","data":{"token":"eyJhbGc...","user":{"id":"...","email":"test@example.com"}}}
```
- [ ] Status 200 OK
- [ ] JWT token returned
- [ ] Cookie `session_token` set (HttpOnly, Secure, SameSite=Strict)

### 3.3 Create Document (Authenticated)
```bash
$ curl -X POST http://localhost:3000/api/documents \
  -H 'Authorization: Bearer ...' \
  -H 'Content-Type: application/json' \
  -d '{"title":"Test Invoice","type":"invoice","file":"<base64_pdf>"}'
{"status":"success","data":{"id":"doc_abc123","url":"https://cdn.example.com/..."}}
```
- [ ] Status 201 Created
- [ ] Document ID returned
- [ ] File encrypted and uploaded to S3 (verify S3 console)

### 3.4 Error Handling (Invalid Input)
```bash
$ curl -X POST http://localhost:3000/api/documents \
  -H 'Authorization: Bearer ...' \
  -H 'Content-Type: application/json' \
  -d '{"title":"A","type":"invalid"}'
{"status":"error","error":{"code":"VALIDATION_ERROR","message":"Title min 3 characters","field":"title","http_status":400}}
```
- [ ] Status 400 Bad Request
- [ ] Error code `VALIDATION_ERROR`
- [ ] Field-specific error message

### 3.5 Rate Limiting (Auth Endpoint)
```bash
# Send 6 requests in <15 seconds
for i in {1..6}; do curl -X POST http://localhost:3000/api/auth/login \
  -d '{"email":"test@example.com","password":"wrong"}'; done
# 6th request:
{"status":"error","error":{"code":"RATE_LIMIT_EXCEEDED","message":"Too many login attempts","http_status":429}}
```
- [ ] Status 429 Too Many Requests after 5 attempts
- [ ] `Retry-After` header present

---

## 4. UI Functionality (Manual Browser Test)

Open http://localhost:3000 in browser:

### 4.1 Login Page (`/login`)
- [ ] Form fields render (email, password)
- [ ] Submit button enabled when fields valid
- [ ] Error message shown when credentials invalid
- [ ] Redirect to `/dashboard` on success

### 4.2 Dashboard (`/dashboard`)
- [ ] Displays user name from session
- [ ] Shows document list (empty state if 0 docs)
- [ ] "Create Document" button navigates to `/documents/new`
- [ ] Logout button clears session and redirects to `/login`

### 4.3 Create Document Form (`/documents/new`)
- [ ] File upload input accepts PDF/JPG only
- [ ] Shows "File too large" error if >10MB
- [ ] Loading skeleton shown during upload
- [ ] Success toast notification on upload complete
- [ ] Redirects to `/documents/:id` after success

### 4.4 Document Detail (`/documents/:id`)
- [ ] PDF preview embedded (via presigned URL)
- [ ] Status badge shows current state (Pending/Approved/Rejected)
- [ ] "Download" button triggers file download (presigned URL, 15 min expiry)
- [ ] 404 page shown if document ID invalid

### 4.5 Responsive & Accessibility
- [ ] Mobile viewport (375px): layout not broken, buttons tappable (44×44px)
- [ ] Keyboard navigation: Tab reaches all interactive elements
- [ ] Focus indicator visible (2px outline)
- [ ] Alt text present on all images

---

## 5. Security Verification

- [ ] Password hashing: Argon2id (verify code, not bcrypt)
- [ ] File encryption: AES-256-GCM (verify `encryptBuffer` function)
- [ ] JWT cookie: `HttpOnly; Secure; SameSite=Strict` (inspect browser DevTools)
- [ ] SQL injection protection: All queries use Prisma ORM (no raw SQL concatenation)
- [ ] CORS policy: Only allow `https://app.example.com` (verify `Access-Control-Allow-Origin` header)
- [ ] Dependency audit: `pnpm audit` → 0 high/critical vulnerabilities

**Evidence**:
```bash
$ pnpm audit
found 0 vulnerabilities
```

---

## 6. Performance Verification

- [ ] N+1 query check: Open Prisma Studio, execute `/api/documents` → Query count = 2 (1 for documents, 1 for users, not 1+N)
- [ ] Page load time: Lighthouse Performance score ≥85
- [ ] API latency (P95): <200ms (verify via monitoring dashboard or `curl -w "@curl-format.txt"`)
- [ ] Database index usage: `EXPLAIN ANALYZE SELECT * FROM documents WHERE user_id = '...' AND status = 'pending'` → Uses `idx_documents_user_status`

**Evidence** (Lighthouse):
```
Performance: 92
Accessibility: 95
Best Practices: 90
SEO: 94
```

---

## 7. Resource Efficiency

- [ ] Memory usage: Dev server stable at <512MB (verify `node --inspect` or `top`)
- [ ] Docker image size: <200MB (if using Docker, verify `docker images`)
- [ ] Database connections: Max 10 connections pooled (verify `SELECT count(*) FROM pg_stat_activity`)

---

## 8. Error Handling & Observability

- [ ] Structured logging: All logs JSON format with `trace_id` (verify `pnpm dev` output)
- [ ] Error monitoring: Sentry captures exceptions (trigger test error `/api/test-error` → check Sentry dashboard)
- [ ] Healthcheck endpoint: `GET /api/health` returns DB + Redis status

**Evidence** (Structured log):
```json
{
  "timestamp": "2026-09-30T10:15:30.120Z",
  "level": "info",
  "trace_id": "7b84f23b-0142-493e-8c5e-bf321bca9b11",
  "actor_id": "user_abc123",
  "endpoint": "POST /api/documents",
  "message": "Document created successfully",
  "duration_ms": 124
}
```

---

## 9. Known Issues & Limitations

List any **intentional** limitations or bugs deferred to Modul 07:

- [ ] Email sending not implemented (deferred to M06 Section 6A)
- [ ] File virus scan disabled in local dev (ClamAV not running, enabled in production only)
- [ ] Payment integration uses Stripe test mode (sandbox transactions)

---

## 10. Sign-Off

**Verified by**: [Your Name]  
**Date**: 2026-09-30  
**Status**: ✅ PASS — Ready for Modul 07 (QA & SIT)

**Next Steps**:
1. Merge `staging` branch
2. Deploy to staging environment (Vercel staging URL)
3. Proceed to Modul 07 (Quality Assurance & SIT)
```

---

## 6. Modul 04 Dependency Clarification (UI Implementation Workflow)

Modul 04 refocus menghasilkan `DESIGN.md` + `DESIGN_SPEC.md` + `DESIGN_REFERENCES.md` **tanpa** Google Stitch Screen ID. Workflow Modul 06 adjusted:

### Option A: Manual UI Scaffold (Default, No Stitch)

**Input**: `DESIGN.md` (tokens) + `DESIGN_SPEC.md` (page breakdown)

**Steps**:
1. **Read Design Tokens**:
   ```bash
   # AI agent reads DESIGN.md
   - Primary color: #0891B2 (Cyan-600)
   - Typography: Inter (400/600 weight)
   - Spacing: 4/8/16/24/32px grid
   - Border: 1px solid #E4E4E7, radius 6-8px
   - Shadow: max 0 4px 6px rgba(0,0,0,0.1)
   ```

2. **Scaffold Components** (AI agent):
   ```bash
   # Create component library from DESIGN.md specs
   npx shadcn-ui@latest init
   npx shadcn-ui@latest add button card input table
   
   # Customize per DESIGN.md tokens
   # File: src/components/ui/button.tsx
   # Apply: primary bg-cyan-600, hover bg-cyan-700, focus ring-2 ring-cyan-600
   ```

3. **Scaffold Pages** (AI agent reads DESIGN_SPEC.md):
   ```bash
   # For each page in DESIGN_SPEC.md (e.g., "Landing Page"):
   # Create: src/app/(marketing)/page.tsx
   # Section breakdown:
   #   - Header (logo + nav + CTA)
   #   - Hero (H1 + subheading + CTA button)
   #   - Features (3 cards: icon + title + description)
   #   - Footer (links + copyright)
   ```

4. **Apply Anti-Slop Rules** (manual review):
   - [ ] No gradients (`bg-gradient-`, `linear-gradient`)
   - [ ] No glassmorphism (`backdrop-blur`, `bg-white/10`)
   - [ ] Shadow ≤ `shadow-md`
   - [ ] Border radius ≤ 8px
   - [ ] Contrast ≥4.5:1 (all text)

**Timeline**: 8-12 jam (Kecil), 20-30 jam (Menengah), 40-60 jam (Besar)

### Option B: Google Stitch (Optional, If User Chose Stitch in Modul 04)

**Only if** Modul 04 explicitly generated Stitch Screen IDs (user requested Stitch workflow).

**Input**: `DESIGN_SPEC.md` with Screen ID table (e.g., `SCR-001`, `SCR-002`)

**Steps**:
1. **Read Screen ID** from `DESIGN_SPEC.md`:
   ```markdown
   ## Screen: Landing Page (SCR-001)
   **Stitch URL**: https://stitch.withgoogle.com/p/abc123/s/001
   ```

2. **Import via MCP** (OpenCode):
   ```bash
   # AI agent calls MCP tool
   stitch_get_screen(screen_id="SCR-001", export_format="nextjs-tailwind")
   # Output: src/app/(marketing)/page.tsx
   ```

3. **Verify Compliance**:
   - [ ] Run anti-slop verification script (check for gradients, glassmorphism)
   - [ ] Manual spot-check 2-3 screens

**Timeline**: 4-6 jam (Kecil), 12-16 jam (Menengah), 24-32 jam (Besar) — faster than manual

### Decision Matrix

| Scenario | Workflow | Why |
|----------|----------|-----|
| **Modul 04 output = DESIGN.md + DESIGN_SPEC.md only** | **Option A: Manual Scaffold** | No Stitch Screen ID available |
| **Modul 04 output = DESIGN_SPEC.md WITH Screen ID table** | **Option B: Stitch Import** | User explicitly chose Stitch in Modul 04 |
| **Modul 04 Stitch output failed anti-slop review** | **Option A: Manual Scaffold** | Discard Stitch, rebuild from DESIGN.md |

**Default assumption**: Option A (Manual Scaffold), unless `DESIGN_SPEC.md` explicitly lists Stitch Screen IDs.

---

## Summary

These improvements fill 6 critical gaps in Modul 06:

1. **Timeline Estimation** — 4-60 hari per scale, buffer 25%, bottlenecks identified (third-party API +20-40 jam, complex business logic +10-20 jam)
2. **AI Agent Delegation Strategy** — 4 tools capability matrix (Cursor/Claude Code/OpenCode/Copilot), decision tree (security → manual, CRUD → 90% autonomous), autonomy level per task type
3. **Smoke Test Specification** — 3-tier (compilation 30s, unit assertions 30s, integration probes 60s), <2 min total, CI/CD integration, NOT full test suite
4. **Environment Variable Management** — Secret vs config classification, workflow per environment (local/staging/production), quarterly rotation protocol, emergency rotation SOP
5. **Verification Checklist Template** — `VERIFY_LOCAL.md` comprehensive (10 sections: build, DB, API, UI, security, performance, resource, observability, known issues, sign-off)
6. **Modul 04 Dependency Clarification** — Option A (manual scaffold from DESIGN.md, default) vs Option B (Stitch import, if Screen ID exists), decision matrix

Load reference ini via: `skill_view(name='solo-project-lifecycle', file_path='references/improvements/MODUL_06_IMPROVEMENTS.md')` sebelum eksekusi Modul 06.
