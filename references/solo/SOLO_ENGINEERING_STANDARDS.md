# Solo Developer Engineering Standards: Git, Security, Performance, & Resource Efficiency

This document is an in-depth technical guide for solo developers to enforce discipline in version control (Git), data security, application performance, and server cost optimization.

---

## 1. Git Branching Protocol & Clean Production

### 1.1 Branch Hierarchy
```text
[ main ]        ──► Stable production code, free of internal dev files, tagged with SemVer (v1.0.0)
   ▲
   │ (Pull Request / Merge after passing Client UAT)
[ staging ]     ──► Integration environment for testing with the Client's Single PIC
   ▲
   │ (Merge after passing local smoke test)
[ feat/* ]      ──► Working branch per atomic feature/task in TODO.md
[ fix/* ]       ──► Bug fix branch
```

### 1.2 Clean Production (Omission of Internal Docs)
Internal development files such as `TODO.md`, draft meeting notes, or local test scripts must never be included in public production bundles or Docker images.

Add to `.dockerignore`:
```text
TODO.md
docs/specs/
scripts/smoke-test.ts
.env*
!.env.example
README.md
```

### 1.3 Conventional Commits Standard
Mandatory format: `<type>(<scope>): <subject>`
- `feat(vault)`: New feature addition
- `fix(auth)`: Bug fix
- `perf(db)`: Performance improvement (indexes, query optimization)
- `sec(crypto)`: Security hardening or key rotation
- `chore(deps)`: Package dependency update

---

## 2. Security Engineering Pillar

### 2.1 SQL Injection Prevention & Input Sanitization
- DO NOT concatenate raw SQL query strings:
  ```typescript
  // INCORRECT & DANGEROUS:
  await db.$queryRawUnsafe(`SELECT * FROM users WHERE email = '${email}'`);

  // CORRECT: Using secure parameterized queries
  await db.$queryRaw`SELECT * FROM users WHERE email = ${email}`;
  ```
- All client inputs must pass through **Zod** validation schemas before further processing.

### 2.2 Session Security & Password Hashing
- Passwords must be hashed using **Argon2id**:
  ```typescript
  import * as argon2 from "argon2";
  const hash = await argon2.hash(password, { type: argon2.argon2id });
  ```
- Session tokens stored in cookies must set mandatory attributes:
  ```http
  Set-Cookie: session_token=...; HttpOnly; Secure; SameSite=Strict; Path=/; Max-Age=604800
  ```

### 2.3 Automated Dependency Security Audits
Run regular security audits:
```bash
pnpm audit --audit-level=high
```
If vulnerabilities with high or critical severity are detected, update the affected packages immediately before resuming development.

---

## 3. Performance Engineering Pillar

### 3.1 N+1 Query Prevention
The N+1 query problem is the primary performance killer in ORMs:
```typescript
// INCORRECT: 1 query to fetch users + N queries inside the loop (N+1 queries)
const users = await db.user.findMany();
for (const user of users) {
  const docs = await db.document.findMany({ where: { creatorId: user.id } });
}

// CORRECT: Single query with relation join / eager loading
const usersWithDocs = await db.user.findMany({
  include: { documents: true },
});
```

### 3.2 Precise Database Indexing
Add indexes to:
1. All **Foreign Key** columns (`creator_id`, `document_id`).
2. Status columns frequently queried in `WHERE` clauses:
   ```sql
   CREATE INDEX idx_documents_status ON documents(status);
   -- Composite index if frequently filtered together:
   CREATE INDEX idx_documents_creator_status ON documents(creator_id, status);
   ```

### 3.3 Visual Asset Optimization
- Do not load large uncompressed PNG/JPEG images.
- Use **WebP / AVIF** automatically via Next.js `<Image />` component.
- Apply **Font Subsetting** (loading only required Latin characters) to reduce font file size to $< 30\text{ KB}$.

---

## 4. Resource & Cost Efficiency Pillar

### 4.1 Database Connection Pooling
Serverless functions (such as Next.js API routes or AWS Lambda) open a new database connection on every request. Without pooling, PostgreSQL will quickly hit connection limits (Connection Exhaustion).
- Use a **Connection Pooler** (Supabase Connection Pooler / PgBouncer / Prisma Accelerate).
- Limit pool size in the connection string:
  ```text
  DATABASE_URL="postgresql://user:pass@host:6543/db?pgbouncer=true&connection_limit=10"
  ```

### 4.2 Stream-Based File Processing
Never read large files directly into memory:
```typescript
// INCORRECT: Loading entire 50 MB file into RAM
const fileBuffer = fs.readFileSync("large-document.pdf");

// CORRECT: Stream data sequentially (constant RAM usage < 10 MB)
const readStream = fs.createReadStream("large-document.pdf");
readStream.pipe(cipherStream).pipe(s3UploadStream);
```

### 4.3 Multi-Stage Docker Builds for Server Efficiency
When deploying via Docker containers, use multi-stage builds:
```dockerfile
# Stage 1: Build
FROM node:22-alpine AS builder
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install --frozen-lockfile
COPY . .
RUN pnpm build

# Stage 2: Production Runner (Final size < 150 MB)
FROM node:22-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/static ./.next/static
EXPOSE 3000
CMD ["node", "server.js"]
```
This technique reduces image size from 1.2 GB to **just 130 MB**, saving registry storage costs and speeding up deployment times by up to 5x.

---

## 5. Observability & Reliability Pillar

Solo developers cannot monitor a server terminal 24 hours a day. The system must autonomously report anomalies:

### 5.1 Structured JSON Logging
Never use plain text `console.log()` in production. Use structured JSON loggers (Pino/Winston) including trace IDs, actor IDs, and error stack traces:
```typescript
import pino from "pino";
export const logger = pino({
  level: process.env.LOG_LEVEL || "info",
  formatters: {
    level: (label) => ({ level: label }),
  },
});
```

### 5.2 Healthcheck Routes & Graceful Shutdown
- Provide a `GET /api/health` endpoint that actively tests database connectivity.
- Handle operating system signals (`SIGTERM` / `SIGINT`) to close database connections cleanly before processes terminate:
  ```typescript
  process.on("SIGTERM", async () => {
    logger.info("SIGTERM received, closing database connections...");
    await db.$disconnect();
    process.exit(0);
  });
  ```

---

## 6. Maintainability & Type Hygiene Pillar

### 6.1 Single Source of Truth for Data Types
- TypeScript data types must be inferred automatically from Zod validation schemas (`z.infer<typeof Schema>`).
- Never duplicate type definitions manually in separate files.

### 6.2 Early Returns Pattern (Guard Clauses)
Validate all error conditions, unauthorized access, and empty inputs at the top of the function:
```typescript
// CORRECT: Flat and easy to reason about
export async function processDocument(user: User, docId: string) {
  if (!user.isActive) throw new ForbiddenError("Account is inactive");
  if (!docId) throw new BadRequestError("Document ID is required");
  
  const doc = await getDoc(docId);
  if (!doc) throw new NotFoundError("Document not found");

  return executeLogic(doc);
}
```

---

## 7. Data Durability & Disaster Recovery Pillar

### 7.1 Soft-Delete vs Hard-Delete Policy
- Financial transactional data, legal contract drafts, and audit trails **MUST NEVER BE PERMANENTLY DELETED** from the database (`DELETE FROM`).
- Use a `deleted_at TIMESTAMP WITH TIME ZONE NULL` column (Soft-Delete) so data retains evidentiary audit value and can be restored if accidentally deleted by users.

### 7.2 Multi-Table Transaction Integrity
Data mutation operations involving more than one table must be wrapped in atomic transactions (`db.$transaction`). If any subsequent step fails, all preceding steps are automatically rolled back, ensuring data is never left in a partially corrupted state.
