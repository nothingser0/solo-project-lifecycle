# Database Operations: Seeding & Transactions Pattern

Comprehensive implementation patterns for safe database seeding, atomic transactions, locking strategies, and idempotent execution for solo developers and small teams.

---

## 1. Atomic Database Transactions

Financial, inventory, and multi-step data mutations must execute inside atomic transactions (`ACID`) to prevent partial writes.

### 1.1 Prisma Interactive Transactions

```typescript
import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

interface TransferRequest {
  fromAccountId: string;
  toAccountId: string;
  amount: number;
}

export async function transferFunds(req: TransferRequest) {
  if (!Number.isFinite(req.amount) || req.amount <= 0) {
    throw new Error('Transfer amount must be a positive finite number');
  }

  return await prisma.$transaction(async (tx) => {
    // 1. Decrement sender balance
    const sender = await tx.account.update({
      where: { id: req.fromAccountId },
      data: { balance: { decrement: req.amount } },
    });

    if (sender.balance < 0) {
      throw new Error(`Insufficient funds: account ${req.fromAccountId}`);
    }

    // 2. Increment receiver balance
    const receiver = await tx.account.update({
      where: { id: req.toAccountId },
      data: { balance: { increment: req.amount } },
    });

    // 3. Create immutable audit ledger row
    const ledger = await tx.auditLog.create({
      data: {
        eventType: 'FUND_TRANSFER',
        metadata: {
          from: req.fromAccountId,
          to: req.toAccountId,
          amount: req.amount,
        },
      },
    });

    return { sender, receiver, ledgerId: ledger.id };
  }, {
    maxWait: 5000, // 5s max wait to acquire connection
    timeout: 10000, // 10s execution timeout
  });
}
```

### 1.2 Pessimistic Locking with Raw SQL (PostgreSQL `FOR UPDATE`)

When 2 concurrent requests modify the same row (e.g., ticket booking, voucher redemption), standard read-modify-write introduces race conditions. Use `SELECT ... FOR UPDATE`.

```typescript
export async function claimVoucher(voucherId: string, userId: string) {
  return await prisma.$transaction(async (tx) => {
    // Lock row exclusively until transaction completes
    const rows = await tx.$queryRaw<Array<{ id: string; quota: number }>>`
      SELECT id, quota FROM vouchers
      WHERE id = ${voucherId}::uuid
      FOR UPDATE
    `;

    const voucher = rows[0];
    if (!voucher || voucher.quota <= 0) {
      throw new Error('Voucher out of quota or does not exist');
    }

    // Deduct quota safely
    await tx.$executeRaw`
      UPDATE vouchers
      SET quota = quota - 1, updated_at = NOW()
      WHERE id = ${voucherId}::uuid
    `;

    // Record redemption
    await tx.voucherClaim.create({
      data: { voucherId, userId },
    });

    return { success: true };
  });
}
```

---

## 2. Idempotent Data Seeding Pattern

Seeding must be safely re-runnable in local dev, CI/CD, and staging without duplicate key violations (`UPSERT` pattern).

### 2.1 Standard TypeScript Seeder (`prisma/seed.ts`)

```typescript
import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';
import { z } from 'zod';

// Validate seeder environment configuration
const DevAdminEnvSchema = z.object({
  SEED_ADMIN_EMAIL: z.string().email(),
  SEED_ADMIN_PASSWORD: z.string().min(12, 'Dev admin password must be at least 12 characters'),
});

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting idempotent database seed...');

  const isProduction = process.env.NODE_ENV === 'production';

  // 1. Seed Roles & Permissions
  const adminRole = await prisma.role.upsert({
    where: { name: 'SUPER_ADMIN' },
    update: {},
    create: {
      name: 'SUPER_ADMIN',
      description: 'System administrator with unrestricted access',
    },
  });

  const userRole = await prisma.role.upsert({
    where: { name: 'MEMBER' },
    update: {},
    create: {
      name: 'MEMBER',
      description: 'Standard registered user',
    },
  });

  // 2. Development-Only Admin Account (Never seeded in production)
  if (!isProduction) {
    const envResult = DevAdminEnvSchema.safeParse(process.env);
    if (!envResult.success) {
      console.warn('⚠️ Skipping dev admin seed: SEED_ADMIN_EMAIL and SEED_ADMIN_PASSWORD (min 12 chars) must be provided in local .env');
    } else {
      const { SEED_ADMIN_EMAIL, SEED_ADMIN_PASSWORD } = envResult.data;
      const passwordHash = await bcrypt.hash(SEED_ADMIN_PASSWORD, 12);

      await prisma.user.upsert({
        where: { email: SEED_ADMIN_EMAIL },
        update: { roleId: adminRole.id },
        create: {
          email: SEED_ADMIN_EMAIL,
          name: 'Local Dev Admin',
          passwordHash,
          roleId: adminRole.id,
          emailVerified: true,
        },
      });

      console.log(`🔑 Development admin created/verified for account: ${SEED_ADMIN_EMAIL}`);
    }
  } else {
    console.log('🔒 Production environment detected: Skipping default admin user seeding.');
  }

  // 3. Seed Reference Data (Lookup tables)
  const categories = [
    { code: 'CAT_TECH', name: 'Technology & Hardware' },
    { code: 'CAT_SRV', name: 'Cloud Services & SaaS' },
    { code: 'CAT_CONS', name: 'Consulting & Advisory' },
  ];

  for (const cat of categories) {
    await prisma.category.upsert({
      where: { code: cat.code },
      update: { name: cat.name },
      create: { code: cat.code, name: cat.name },
    });
  }

  console.log('✅ Seeding completed successfully.');
}

main()
  .catch((e) => {
    console.error('❌ Seeding failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
```

### 2.2 Package.json Configuration

```json
{
  "prisma": {
    "seed": "tsx prisma/seed.ts"
  },
  "scripts": {
    "db:migrate": "prisma migrate dev",
    "db:seed": "prisma db seed",
    "db:reset": "prisma migrate reset --force"
  }
}
```

---

## 3. High-Volume Batch Seeding

For performance testing or data migration (10,000+ rows), never use individual `create()` loops. Use `createMany()` or PostgreSQL `COPY`.

```typescript
export async function seedDummyTransactions(count = 5000) {
  const batchSize = 1000;
  console.log(`Generating ${count} mock transactions in batches of ${batchSize}...`);

  for (let i = 0; i < count; i += batchSize) {
    const records = Array.from({ length: Math.min(batchSize, count - i) }).map((_, idx) => ({
      referenceNumber: `TX-${Date.now()}-${i + idx}`,
      amount: Math.floor(Math.random() * 500000) + 10000,
      status: 'COMPLETED',
      createdAt: new Date(),
    }));

    await prisma.transaction.createMany({
      data: records,
      skipDuplicates: true, // Idempotent batch insertion
    });
  }
}
```

---

## 4. Best Practices Checklist

- [ ] All multi-table updates are wrapped in an atomic transaction (`$transaction`).
- [ ] Financial balance checks occur *inside* the transaction boundary.
- [ ] Concurrency-critical counters use pessimistic row locks (`SELECT ... FOR UPDATE`).
- [ ] Seeders use `upsert` with unique keys to allow repeated execution.
- [ ] Default admin accounts are blocked when `NODE_ENV === 'production'`.
- [ ] No plaintext passwords or static secrets in seeder code; credentials use Zod-validated environment variables (`SEED_ADMIN_PASSWORD` >= 12 chars).
- [ ] Large dataset seeding is broken down into chunked batches (500–1000 rows).

---

## See Also

- `patterns/database/supabase-migrations.md` - Schema migrations & RLS policies
- `references/solo/SOLO_DEVELOPMENT_PATTERNS.md` - Backend transaction safety & locking
- `docs/modules/08-data-migration-seeding.md` - Legacy data migration & ETL workflows
