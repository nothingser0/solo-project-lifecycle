# Solo Developer Architecture & Technical Engineering Guide

This document provides software architecture guidelines for solo developers and technical consultants to design reliable, legally compliant, secure, and low-maintenance systems.

---

## 1. "The Boring Tech Ladder" Philosophy

As a solo developer, you are the only person on call when a server goes down at 3:00 AM. Avoid exotic, unproven technologies (Resume-Driven Development).

### Priority Technology Ladder:
1. **Rung 1: Modern Monoliths Outperform Microservices**:
   - DO NOT split an application into distributed microservices when maintained by a single person, unless mandated by an enterprise client's architectural guidelines.
   - Use a **Modular Monolith**: A single, clean codebase with modular domain boundaries organized in folders (`src/modules/auth`, `src/modules/documents`, `src/modules/billing`).
2. **Rung 2: PostgreSQL as the "Swiss Army Knife"**:
   - Do not add a separate NoSQL database (e.g., MongoDB or CouchDB) just for semi-structured data.
   - PostgreSQL's `JSONB` columns support index queries (`GIN Index`), schema validation, and high performance without needing to maintain two separate database clusters.
3. **Rung 3: Managed PaaS & Cloud Services**:
   - Prioritize Managed Databases (Supabase, Neon, AWS RDS) and PaaS solutions (Vercel, Cloudflare, Railway) so you never waste time managing Linux OS patches, automated disk backups, or manual firewall configurations.

---

## 2. Database Hygiene & Best Practices

### 2.1 Database-Level Enforcement
Never rely solely on application-level validation (JavaScript/Python). Applications have bugs, but the database must serve as the final fortress of integrity:
- **Foreign Key Constraints**: Always use `ON DELETE RESTRICT` for transactional data. Avoid `CASCADE` on critical entities to prevent accidental cascading deletion of audit trails.
- **Check Constraints**: Enforce data boundaries in SQL (e.g., `CHECK (compensation_amount >= 0)`).
- **Standardized Timestamps**: Always use `TIMESTAMP WITH TIME ZONE` (UTC) to eliminate timezone ambiguity across regions.

### 2.2 Transaction & Concurrency Management
To prevent race conditions when two concurrent processes modify the same record:
- Use atomic transactions (`BEGIN ... COMMIT`).
- Use explicit row locking:
  ```sql
  -- Lock row so other transactions cannot modify it until commit
  SELECT * FROM documents WHERE id = '...' FOR UPDATE;
  ```

---

## 3. Industry-Standard Security Checklist (OWASP & Data Protection)

### 3.1 Personal Data Protection Compliance (UU PDP No. 27/2022)
1. **Data Minimization Principle**: Do not collect or store national ID (NIK/KTP) or financial data unless strictly necessary for business workflows.
2. **Encryption-at-Rest**:
   - Encrypt sensitive database columns using `pgcrypto` or at the application layer before running `INSERT` queries.
   - Store PDF documents in cloud storage buckets with default **AES-256** encryption enabled.
3. **Ephemeral Access URLs (Zero Public Buckets)**:
   - Never create storage buckets with `public-read` access.
   - All document downloads and previews must use cryptographically signed **Presigned URLs** with an expiration window of 15 minutes or less.

### 3.2 OWASP Top 10 Defenses
- **SQL Injection**: Always use Parameterized Queries or proven ORMs (Prisma, Drizzle, SQLx, Gorm). Never concatenate raw SQL query strings (`"SELECT * FROM users WHERE email = '" + input + "'"`).
- **Broken Authentication**:
  - Hash passwords using **Argon2id** or **bcrypt** (minimum cost factor 12). MD5 or plain SHA-256 for password hashing is strictly prohibited.
  - Store authentication tokens in cookies with flags: `HttpOnly; Secure; SameSite=Strict`.
- **Idempotency Protection**:
  - For financial mutation or document generation endpoints (`POST`), require an `X-Idempotency-Key` (UUIDv4) header to prevent duplicate executions from unstable client networks.

---

## 4. Solo Dev Logging & Observability Patterns

Never use bare `console.log()` in production environments.
- Use structured JSON loggers (e.g., Pino or Winston).
- Include complete contextual metadata in every log:
  ```json
  {
    "timestamp": "2026-09-24T10:15:30.120Z",
    "level": "error",
    "trace_id": "7b84f23b-0142-493e-8c5e-bf321bca9b11",
    "actor_id": "user_uuid_here",
    "endpoint": "POST /api/v1/documents",
    "error_code": "PDF_RENDER_TIMEOUT",
    "message": "Puppeteer timeout after 5000ms"
  }
  ```
- Route logs to low-cost or free monitoring tools (e.g., Sentry for error tracking, Axiom/BetterStack for log aggregation) to receive instant notifications via Telegram or Email when system errors occur.
