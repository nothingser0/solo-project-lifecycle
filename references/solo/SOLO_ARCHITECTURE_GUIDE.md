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
4. **Rung 4: The $5/mo Self-Hosted Escape Hatch (Coolify / Dokku on VPS)**:
   - When managed PaaS bills threaten bootstrapped runway ($50–$100+/month for multi-tenant databases, vector indices, or background queues), migrate to a single Hetzner or DigitalOcean VPS ($4–$6/month) running Coolify or Dokku.
   - Maintain PaaS-like git push deployments while paying flat, predictable hardware costs.
   - Pair with zero-egress storage (Cloudflare R2) and automated offsite database snapshots.

---

## 2. Architectural Topologies: Solo vs Overkill Taxonomy

### 2.1 Deployment & Execution Topology
- **Modular Monolith (Default Standard | 95% Use Case)**:
   - *Definition*: Single deployable artifact/runtime with strict internal domain separation (e.g. `src/modules/billing`, `src/modules/auth`).
   - *Solo Advantage*: In-process function calls, ACID transactions across modules, zero network overhead, single CI/CD pipeline.
- **Self-Hosted VPS Monolith (The Solo FinOps Sweet Spot | $4–$6/mo)**:
   - *Definition*: Single Linux VPS running Coolify/Dokku + Dockerized App + Postgres + Redis.
   - *Solo Advantage*: Deterministic hosting bill, zero cold starts, unlimited staging databases, unmetered background workers.
   - *Mandatory Safeguard*: Automate offsite encrypted daily backups to Cloudflare R2 / AWS S3 using a hardened cron job; rely on Caddy/Traefik for automated Let's Encrypt SSL.
- **Microservices (Overkill Flag | Avoid as Solo)**:
  - *Definition*: Distributed independent services communicating over HTTP/gRPC/Kafka.
  - *Solo Trap*: Operational suicide for one developer. Introduces distributed transactions (2PC/Saga), eventual consistency bugs, dual-run deployments, and complex infrastructure (K8s, service mesh, distributed tracing).
- **Serverless & Edge (Targeted Utility | 5% Use Case)**:
  - *Definition*: Ephemeral functions (AWS Lambda, Cloudflare Workers).
  - *Solo Fit*: Excellent for bursty, sporadic background tasks (PDF generation, webhook ingestion, thumbnail resizing).
  - *Solo Trap*: Connection pooling limits on relational databases. Always pair with HTTP poolers (PgBouncer, Prisma Accelerate, Cloudflare Hyperdrive).
- **N-Tier Architecture (Layered Discipline)**:
  - *Definition*: Separation into Presentation -> Application/Business Logic -> Data Access layers.
  - *Solo Standard*: Implement logically via folder structures inside a monolith rather than deploying onto separate physical VMs.

### 2.2 Repository Strategies: Monorepo vs Polyrepo
- **Monorepo (Recommended for Fullstack Solo)**:
  - *Tooling*: Turborepo, pnpm workspaces, or Nx.
  - *Structure*: `apps/web`, `apps/api` (or unified app), `packages/db`, `packages/shared-types`.
  - *Solo Advantage*: Atomic refactoring. A single git commit can update database schema, API contracts, and frontend consumption without version mismatch or out-of-sync PRs.
- **Polyrepo (Multiple Repositories | High Friction)**:
  - *Solo Trap*: Divergent branch versions, managing npm package releases for internal DTOs, and coordinating multi-repo release sequences alone.

### 2.3 Code Design Patterns: Practicality vs Over-Engineering
- **Hexagonal / Clean Architecture (Ports & Adapters)**:
  - *Solo Rule*: Heavy interface/adapter abstraction layers are justified for enterprise projects with 5+ year lifespans or strict compliance audits. For rapid solo client MVPs (1–4 weeks), prefer pragmatic domain services over excessive DTO/interface boilerplate.
- **CQRS (Command Query Responsibility Segregation)**:
  - *Solo Rule*: Separate Read/Write logic at the code/service level if beneficial for readability. NEVER spin up separate physical Read and Write databases with asynchronous sync for solo projects unless analytics read traffic strictly demands an OLAP replica (e.g., ClickHouse).
- **Microfrontends (Strict Red Flag)**:
  - *Solo Rule*: Completely prohibited for solo engineering. Designed strictly for massive corporations with 10+ independent frontend squads to deploy independently. Adds bundle bloat, CSS bleeding, iframe/Module Federation friction, and zero benefit for a single developer.

---

## 3. Database Hygiene & Best Practices

### 3.1 Database-Level Enforcement
Never rely solely on application-level validation (JavaScript/Python). Applications have bugs, but the database must serve as the final fortress of integrity:
- **Foreign Key Constraints**: Always use `ON DELETE RESTRICT` for transactional data. Avoid `CASCADE` on critical entities to prevent accidental cascading deletion of audit trails.
- **Check Constraints**: Enforce data boundaries in SQL (e.g., `CHECK (compensation_amount >= 0)`).
- **Standardized Timestamps**: Always use `TIMESTAMP WITH TIME ZONE` (UTC) to eliminate timezone ambiguity across regions.

### 3.2 Transaction & Concurrency Management
To prevent race conditions when two concurrent processes modify the same record:
- Use atomic transactions (`BEGIN ... COMMIT`).
- Use explicit row locking:
  ```sql
  -- Lock row so other transactions cannot modify it until commit
  SELECT * FROM documents WHERE id = '...' FOR UPDATE;
  ```

---

## 4. Industry-Standard Security Checklist (OWASP & Data Protection)

### 4.1 Personal Data Protection Compliance (UU PDP No. 27/2022)
1. **Data Minimization Principle**: Do not collect or store national ID (NIK/KTP) or financial data unless strictly necessary for business workflows.
2. **Encryption-at-Rest**:
   - Encrypt sensitive database columns using `pgcrypto` or at the application layer before running `INSERT` queries.
   - Store PDF documents in cloud storage buckets with default **AES-256** encryption enabled.
3. **Ephemeral Access URLs (Zero Public Buckets)**:
   - Never create storage buckets with `public-read` access.
   - All document downloads and previews must use cryptographically signed **Presigned URLs** with an expiration window of 15 minutes or less.

### 4.2 OWASP Top 10 Defenses
- **SQL Injection**: Always use Parameterized Queries or proven ORMs (Prisma, Drizzle, SQLx, Gorm). Never concatenate raw SQL query strings (`"SELECT * FROM users WHERE email = '" + input + "'"`).
- **Broken Authentication**:
  - Hash passwords using **Argon2id** or **bcrypt** (minimum cost factor 12). MD5 or plain SHA-256 for password hashing is strictly prohibited.
  - Store authentication tokens in cookies with `HttpOnly; Secure`, and `SameSite=Lax` by default — `Strict` only when app and API share an origin (see `SOLO_ENGINEERING_STANDARDS.md` §SameSite).
- **Idempotency Protection**:
  - For financial mutation or document generation endpoints (`POST`), require an `Idempotency-Key` (UUIDv4) header to prevent duplicate executions from unstable client networks.

---

## 5. Solo Dev Logging & Observability Patterns

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
