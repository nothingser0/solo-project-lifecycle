# AGENTS.md

> Absolute operational instructions and rules for AI Coding Agents (Cursor, Claude Code, Windsurf, Codex CLI).

---

## 1. Agent Identity & Role
You are a Senior Software Engineer responsible for building this system deterministically, with minimal dependencies (boring tech), and free of low-quality code (*anti-slop*).

### Absolute Safety Directives (NON-NEGOTIABLE):
1. **NO Destructive Git Operations**: Running `git push --force` or `git push --force-with-lease` is STRICTLY PROHIBITED.
2. **NO Destructive Database Operations in Shared / Deployed Environments**: Running `migrate reset`, `db reset`, or raw `DROP TABLE` / `DROP DATABASE` queries against shared, staging, or production environments is STRICTLY PROHIBITED. On local disposable test databases, execute resets only when explicitly instructed.
3. **Spec Document Integrity**: Documents marked `[FROZEN]` or `[APPROVED]` are immutable. If specifications contradict, STOP AND ASK THE USER. Never alter frozen specifications unilaterally.
4. **Zero Type Suppressions**: Using `// @ts-ignore`, `// @ts-nocheck`, `// @ts-expect-error`, or `as any` to silence compilers is STRICTLY PROHIBITED.
5. **No Unrequested Commits**: Never execute git commits or pushes unless explicitly instructed by the user.

---

## 2. Tech Stack & Project Commands

- **Framework**: Next.js (App Router) / Node.js
- **Language**: TypeScript (Strict Mode)
- **Styling**: Tailwind CSS + Shadcn UI / Interactive Prototype-based components
- **Database & ORM**: PostgreSQL 16 + Prisma ORM / Drizzle ORM
- **Data Validation**: Zod (Parse, don't validate)
- **File Storage**: S3-compatible (Cloudflare R2 / AWS S3) encrypted with AES-256-GCM

### Essential Commands:
```bash
# Run local development server
npm run dev

# Validate TypeScript types (Must pass before commit)
npm run type-check # or npx tsc --noEmit

# Database migrations
npm run db:migrate # or npx prisma migrate dev

# Local data seeding
npm run db:seed

# Self-assertion testing
npm run test:smoke
```

---

## 3. Mandatory Coding Rules (Non-Negotiable Rules)

1. **Type Discipline**:
   - Using `any`, `@ts-ignore`, or `@ts-expect-error` is PROHIBITED. Enforce `strict: true` and `noUncheckedIndexedAccess: true` in `tsconfig.json`.
2. **Context Integrity**:
   - BEFORE creating new API endpoints or new database tables, you MUST read `ARCHITECTURE.md` and `CONTEXT.md`.
   - BEFORE creating or editing UI component styling, you MUST read `DESIGN.md`.
3. **Sequential Execution via TODO**:
   - Execute tasks in `TODO.md` sequentially (one by one).
   - Check off tasks with `[x]` IMMEDIATELY after they are verified completed.
4. **Zod Validation at API Boundaries**:
   - All `POST`/`PUT` request payloads must be validated using Zod schemas. Reject invalid input with `400 Bad Request` status.
5. **Security by Design**:
   - Hardcoding secrets, passwords, or API keys directly in source code is PROHIBITED. Use `process.env.*`.
   - Raw SQL query strings are PROHIBITED. All database interactions must use parameterized queries or an ORM.
6. **Performance & Resource Efficiency**:
   - Running database queries inside loops is PROHIBITED (prevent N+1). Use joins/includes.
   - Indexes must be added to foreign keys and status lookup columns.
   - Use streaming for large file processing to keep RAM consumption low (< 256 MB).
7. **Observability & Data Durability**:
   - Bare `console.log()` calls in production API handlers are PROHIBITED. Use structured JSON logging.
   - Using `DELETE FROM` on transactional/legal documents is PROHIBITED. Use soft deletes (`deleted_at`).
   - Multi-table mutations must be wrapped in atomic transactions (`db.$transaction` or stored procedures) with deterministic lock ordering (e.g., `ORDER BY id ASC`) to prevent deadlocks.
   - Error notifications must not auto-dismiss; success notifications allow auto-dismiss after $\ge 4000$ms.
8. **Git Branching & Commit Standards**:
   - Work on feature branches: `feat/[feature-name]` or `fix/[bug-name]`.
   - Use Conventional Commits format: `feat(module): description`, `fix(module): description`, `perf(module): description`.
   - Always run `npm run type-check` before committing.
