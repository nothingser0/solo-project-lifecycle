# TODO.md

> Atomic task list for autonomous coding execution by AI coding agents (Cursor / Claude Code / Windsurf / Codex CLI).
> Rule: Complete tasks sequentially one by one. Check `[x]` immediately after each task is completed and verified.

---

## Phase 1: Repository Initialization & Baseline Tooling
- [ ] **M06-SETUP-00**: **Specs Pre-Read** — read AGENTS/CONTEXT/PROJECT_LITE/FSD/PRD before writing code - expect sign-off recorded
- [ ] **M06-SETUP-01**: `package.json`: Initialize core dependencies (Next.js, React, TypeScript, Tailwind, Zod, Prisma) - expect local build succeeds
- [ ] **M06-SETUP-02**: `tsconfig.json`: Enable TypeScript strict mode with zero tolerance for `any` types - expect tsc --noEmit passes
- [ ] **M06-SETUP-03**: `.env.example`: Create environment variable template (DATABASE_URL, JWT_SECRET, S3/R2 keys) - expect complete env dictionary
- [ ] **M06-SETUP-04**: `src/lib/env.ts`: Create environment variable parser using Zod - expect fail-fast crash when required env vars are missing

## Phase 2: Database Schema & Migrations
- [ ] **M06-DB-01**: `prisma/schema.prisma`: Define users, documents, and signatures models per FSD DDL - expect valid schema
- [ ] **M06-DB-02**: `migrations/`: Run initial database migration to local PostgreSQL - expect tables created in database
- [ ] **M06-DB-03**: `prisma/seed.ts`: Create initial seed data script (super admin account and document templates) - expect seed loaded successfully

## Phase 3: UI Component Setup from Interactive Prototype
- [ ] **M06-FE-01**: `src/components/ui/`: Copy primitive components (Button, Input, Table, Badge) from prototype output - expect clean components
- [ ] **M06-FE-02**: `src/app/(auth)/login/page.tsx`: Mount login page layout from prototype - expect clean login form rendering
- [ ] **M06-FE-03**: `src/app/(dashboard)/page.tsx`: Mount dashboard layout from prototype - expect statistics widgets & table rendered
- [ ] **M06-FE-04**: `src/app/(dashboard)/documents/new/page.tsx`: Mount dynamic document form from prototype - expect input form rendered

## Phase 4: API Endpoints & Backend Services
- [ ] **M06-BE-01**: `src/lib/crypto.ts`: Create AES-256-GCM streaming encryption and SHA-256 hashing functions - expect encryption & decryption pass
- [ ] **M06-BE-02**: `src/lib/storage.ts`: Create Cloudflare R2 / S3 storage client and presigned URL generator - expect file upload succeeds
- [ ] **M06-BE-03**: `src/app/api/v1/auth/login/route.ts`: Create Zod-validated login handler and set HttpOnly cookie - expect login 200 OK
- [ ] **M06-BE-04**: `src/app/api/v1/documents/route.ts`: Create POST handler for new document draft creation - expect 201 Created
- [ ] **M06-BE-05**: `src/app/api/v1/documents/[id]/route.ts`: Create GET handler for document detail and presigned URL - expect 200 OK
- [ ] **M06-BE-06**: `src/app/api/v1/sign/[token]/route.ts`: Create signature transaction handler with pessimistic locking - expect 200 OK

## Phase 5: UI to Backend API Integration (Wiring)
- [ ] **M06-FE-05**: `src/components/modules/LoginForm.tsx`: Connect login form submission to /api/v1/auth/login - expect redirect to dashboard
- [ ] **M06-FE-06**: `src/components/modules/DocumentForm.tsx`: Connect document form submission to POST /api/v1/documents - expect draft saved
- [ ] **M06-FE-07**: `src/components/modules/SignCanvas.tsx`: Connect e-sign canvas to POST /api/v1/sign/[token] - expect SIGNED status
- [ ] **M06-FE-08**: `5-State Review`: Verify loading skeleton, empty state, and inline error views across all pages - expect defensive UI

## Phase 6: Self-Assertion Testing (Local Smoke Test)
- [ ] **M06-BE-07**: `scripts/smoke-test.ts`: Write complete flow assertion script from login through document hash verification - expect 100% PASS
- [ ] **M06-BE-08**: `VERIFY_LOCAL.md`: Fill in self-verification evidence sheet before releasing to Staging - expect PASS decision
