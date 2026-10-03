# TODO.md

> Atomic task list for autonomous coding execution by AI coding agents (OpenCode / OpenChamber).
> Rule: Complete tasks sequentially one by one. Check `[x]` immediately after each task is completed and verified.

---

## Phase 1: Repository Initialization & Baseline Tooling
- [ ] `package.json`: Initialize core dependencies (Next.js, React, TypeScript, Tailwind, Zod, Prisma) - expect local build succeeds
- [ ] `tsconfig.json`: Enable TypeScript strict mode with zero tolerance for `any` types - expect tsc --noEmit passes
- [ ] `.env.example`: Create environment variable template (DATABASE_URL, JWT_SECRET, S3/R2 keys) - expect complete env dictionary
- [ ] `src/lib/env.ts`: Create environment variable parser using Zod - expect fail-fast crash when required env vars are missing

## Phase 2: Database Schema & Migrations
- [ ] `prisma/schema.prisma`: Define users, documents, and signatures models per FSD DDL - expect valid schema
- [ ] `migrations/`: Run initial database migration to local PostgreSQL - expect tables created in database
- [ ] `prisma/seed.ts`: Create initial seed data script (super admin account and document templates) - expect seed loaded successfully

## Phase 3: UI Component Setup from Google Stitch
- [ ] `src/components/ui/`: Copy primitive components (Button, Input, Table, Badge) from Stitch output - expect clean components
- [ ] `src/app/(auth)/login/page.tsx`: Mount login page layout from Stitch - expect clean login form rendering
- [ ] `src/app/(dashboard)/page.tsx`: Mount dashboard layout from Stitch - expect statistics widgets & table rendered
- [ ] `src/app/(dashboard)/documents/new/page.tsx`: Mount dynamic document form from Stitch - expect input form rendered

## Phase 4: API Endpoints & Backend Services
- [ ] `src/lib/crypto.ts`: Create AES-256-GCM streaming encryption and SHA-256 hashing functions - expect encryption & decryption pass
- [ ] `src/lib/storage.ts`: Create Cloudflare R2 / S3 storage client and presigned URL generator - expect file upload succeeds
- [ ] `src/app/api/v1/auth/login/route.ts`: Create Zod-validated login handler and set HttpOnly cookie - expect login 200 OK
- [ ] `src/app/api/v1/documents/route.ts`: Create POST handler for new document draft creation - expect 201 Created
- [ ] `src/app/api/v1/documents/[id]/route.ts`: Create GET handler for document detail and presigned URL - expect 200 OK
- [ ] `src/app/api/v1/sign/[token]/route.ts`: Create signature transaction handler with pessimistic locking - expect 200 OK

## Phase 5: UI to Backend API Integration (Wiring)
- [ ] `src/components/docs/modules/LoginForm.tsx`: Connect login form submission to /api/v1/auth/login - expect redirect to dashboard
- [ ] `src/components/docs/modules/DocumentForm.tsx`: Connect document form submission to POST /api/v1/documents - expect draft saved
- [ ] `src/components/docs/modules/SignCanvas.tsx`: Connect [Interactive feature] to POST /api/v1/sign/[token] - expect SIGNED status
- [ ] `5-State Review`: Verify loading skeleton, empty state, and inline error views across all pages - expect defensive UI

## Phase 6: Self-Assertion Testing (Local Smoke Test)
- [ ] `scripts/smoke-test.ts`: Write complete flow assertion script from login through document hash verification - expect 100% PASS
- [ ] `VERIFY_LOCAL.md`: Fill in self-verification evidence sheet before releasing to Staging - expect PASS decision
