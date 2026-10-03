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

## Phase 3: UI Component Setup
> **Source**: Reference `DESIGN.md` (tokens) + `DESIGN_SPEC.md` (screen specs)  
> - **With Stitch**: Copy from `stitch-output/SCR-XX/` folders  
> - **Without Stitch**: Implement manually using shadcn/ui + Tailwind matching DESIGN.md tokens

- [ ] `src/components/ui/`: Implement primitive components (Button, Input, Table, Badge) per DESIGN.md color/typography tokens - expect clean components matching design system
- [ ] `src/app/(auth)/login/page.tsx`: Implement Screen SCR-06 (Login) from DESIGN_SPEC.md section 3.6 or `stitch-output/SCR-06/` - expect clean login form with 5 states (ideal/loading/error/success/validation)
- [ ] `src/app/(dashboard)/page.tsx`: Implement Screen SCR-09 (Dashboard) from DESIGN_SPEC.md section 3.9 or `stitch-output/SCR-09/` - expect statistics widgets & data table rendered
- [ ] `src/app/(dashboard)/documents/new/page.tsx`: Implement Screen SCR-12 (Create Resource) from DESIGN_SPEC.md section 3.12 or `stitch-output/SCR-12/` - expect dynamic form with validation

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
