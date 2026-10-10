# Seed Data Specification & Fixture Plan

> **Purpose**: Deterministic, realistic development/test fixtures so dashboards, KPIs, and E2E tests have data to render. Prevents "empty screen" bugs and flaky tests.
> **Location**: `prisma/seed.ts` (Next.js/Prisma), `database/seeders/*.php` (Laravel), `apps/*/management/commands/seed.py` (Django), `cmd/seed/main.go` (Go).
> **Rule**: Seed data MUST be idempotent (safe to re-run), cover every RBAC role, and include at least two tenants for RLS/IDOR testing.

---

## 1. Required Seed Coverage (MANDATORY)

| Category | Minimum Records | Why |
|:---|:---:|:---|
| **Tenants / Organizations** | 2 (`Org A`, `Org B`) | Prove multi-tenant isolation; RLS/IDOR tests need cross-tenant data |
| **Users per tenant** | 1 owner + 1 staff (per tenant) | Exercise RBAC visibility differences |
| **Domain master data** | 5–10 records (clients, products, etc.) | Populate list/search/filter screens |
| **Domain transactions** | 10–20 records across ALL statuses | Exercise 5-state matrix (empty/loading/error/success) and status filters |
| **Edge-case records** | 1 each | Zero-value, max-length string, unicode name, future/past dates |

---

## 2. Determinism Rules
1. **Fixed seed**: use a fixed random seed so runs are reproducible (`faker.seed(42)`).
2. **Fixed clock**: pin "now" to a fixed timestamp so `OVERDUE`/time-window logic is testable.
3. **Fixed timezone**: all dates generated in `Asia/Jakarta`.
4. **Idempotent**: use `upsert` / `ON CONFLICT DO UPDATE`, never blind `INSERT` that fails on re-run.
5. **Explicit IDs**: use readable stable UUIDs for cross-referencing in tests (never random per run).

---

## 3. Reference Implementation Skeleton

```typescript
// prisma/seed.ts (Next.js + Prisma)
import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
  // 2 tenants for RLS/IDOR coverage
  const orgA = await prisma.organization.upsert({
    where: { slug: 'org-a' },
    update: {},
    create: { id: '00000000-0000-0000-0000-0000000000aa', slug: 'org-a', name: 'Org A' },
  });
  const orgB = await prisma.organization.upsert({
    where: { slug: 'org-b' },
    update: {},
    create: { id: '00000000-0000-0000-0000-0000000000bb', slug: 'org-b', name: 'Org B' },
  });

  // TODO: seed users (owner + staff) per tenant, master data, and transactions across all statuses.
  // Cover edge cases: zero value, max-length, unicode, past/future dates.
}

main().finally(() => prisma.$disconnect());
```

---

## 4. Verification (Machine-Checkable)
- **Verify**: `pnpm db:seed` (or `php artisan db:seed` / `python manage.py seed`).
- **Expected**: Exit code 0; re-running produces the same record counts (idempotent).
- **Verify**: `pnpm test tests/db/seed-integrity.test.ts`
- **Expected**: Assert both tenants exist, every status enum has ≥1 record, RLS cross-tenant query returns 0 rows.
