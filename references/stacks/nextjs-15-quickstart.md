# Next.js Quickstart Guide

**Stack**: Next.js (Current Stable / v15–v16+) + React 19+ + TypeScript + Prisma/Supabase + PostgreSQL

> 💡 **Version Independence**: Real-time versions are verified via M05 gate (`npm view next version`). Running `pnpm create next-app@latest` automatically pins the current major release.

**Timeline**: 2-4 weeks MVP for SaaS/web app

**Best for**: Full-stack TypeScript, server components, API routes

---

## Quick Setup (15 minutes)

### 1. Initialize Project

```bash
# Create Next.js 15 app
npx create-next-app@latest my-app --typescript --tailwind --app --turbopack

cd my-app

# Install core dependencies
pnpm add prisma @prisma/client zod @hookform/resolvers react-hook-form
pnpm add bcrypt jsonwebtoken
pnpm add -D @types/bcrypt @types/jsonwebtoken
```

---

### 2. Database Setup (Prisma + PostgreSQL)

```bash
# Initialize Prisma
npx prisma init

# Edit prisma/schema.prisma
```

**prisma/schema.prisma**:
```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id        String   @id @default(cuid())
  email     String   @unique
  password  String
  name      String?
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model Document {
  id        String   @id @default(cuid())
  title     String
  content   String?
  userId    String
  user      User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  
  @@index([userId])
}
```

**Run migrations**:
```bash
npx prisma migrate dev --name init
npx prisma generate
```

---

### 3. Environment Variables

**.env.local**:
```bash
DATABASE_URL="postgresql://user:password@localhost:5432/mydb"
JWT_SECRET="your-super-secret-jwt-key-min-64-chars-random"
JWT_REFRESH_SECRET="another-secret-for-refresh-tokens"
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET="nextauth-secret-32-chars-minimum"
```

---

## Project Structure

```
my-app/
├── app/
│   ├── api/              # API routes
│   │   ├── auth/
│   │   │   ├── login/route.ts
│   │   │   ├── register/route.ts
│   │   │   └── logout/route.ts
│   │   └── documents/
│   │       ├── route.ts          # GET, POST
│   │       └── [id]/route.ts     # GET, PATCH, DELETE
│   ├── (auth)/           # Auth layout group
│   │   ├── login/page.tsx
│   │   └── register/page.tsx
│   ├── (dashboard)/      # Protected layout group
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   └── documents/
│   │       ├── page.tsx
│   │       └── [id]/page.tsx
│   ├── layout.tsx        # Root layout
│   └── page.tsx          # Landing page
├── lib/
│   ├── db.ts             # Prisma client singleton
│   ├── auth/
│   │   ├── jwt.ts
│   │   └── password.ts
│   └── schemas/
│       ├── auth.ts
│       └── documents.ts
├── components/
│   ├── ui/               # shadcn/ui components
│   └── forms/
├── prisma/
│   └── schema.prisma
└── proxy.ts         # Route protection
```

---

## Core Patterns

### Prisma Client Singleton

**lib/db.ts**:
```typescript
import { PrismaClient } from '@prisma/client';

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined;
};

export const db = globalForPrisma.prisma ?? new PrismaClient();

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = db;
```

---

### API Route Example

**app/api/documents/route.ts**:
```typescript
import { NextRequest, NextResponse } from 'next/server';
import { db } from '@/lib/db';
import { CreateDocumentSchema } from '@/lib/schemas/documents';
import { requireAuth } from '@/lib/middleware/auth';

export async function GET(req: NextRequest) {
  const authError = await requireAuth(req);
  if (authError) return authError;

  const user = (req as any).user;
  
  const documents = await db.document.findMany({
    where: { userId: user.userId },
    orderBy: { createdAt: 'desc' },
  });

  return NextResponse.json({ documents });
}

export async function POST(req: NextRequest) {
  const authError = await requireAuth(req);
  if (authError) return authError;

  const body = await req.json();
  const validatedData = CreateDocumentSchema.parse(body);

  const user = (req as any).user;
  const document = await db.document.create({
    data: {
      ...validatedData,
      userId: user.userId,
    },
  });

  return NextResponse.json({ document }, { status: 201 });
}
```

---

### Server Components (Default in App Router)

**app/(dashboard)/documents/page.tsx**:
```typescript
import { db } from '@/lib/db';
import { cookies } from 'next/headers';
import { verifyAccessToken } from '@/lib/auth/jwt';

export default async function DocumentsPage() {
  // Server-side auth check
  const cookieStore = cookies();
  const accessToken = cookieStore.get('accessToken')?.value;
  
  if (!accessToken) {
    redirect('/login');
  }

  const user = verifyAccessToken(accessToken);
  
  // Fetch data server-side
  const documents = await db.document.findMany({
    where: { userId: user.userId },
    orderBy: { createdAt: 'desc' },
  });

  return (
    <div>
      <h1>Documents ({documents.length})</h1>
      {documents.map(doc => (
        <div key={doc.id}>
          <h2>{doc.title}</h2>
          <p>{doc.content}</p>
        </div>
      ))}
    </div>
  );
}
```

---

### Middleware for Route Protection

**proxy.ts**:
```typescript
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';
import { verifyAccessToken } from '@/lib/auth/jwt';

export function middleware(request: NextRequest) {
  const accessToken = request.cookies.get('accessToken')?.value;

  // Protected routes
  if (request.nextUrl.pathname.startsWith('/dashboard')) {
    if (!accessToken) {
      return NextResponse.redirect(new URL('/login', request.url));
    }

    try {
      verifyAccessToken(accessToken);
    } catch {
      return NextResponse.redirect(new URL('/login', request.url));
    }
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/dashboard/:path*', '/api/documents/:path*'],
};
```

---

## UI with shadcn/ui

### Install shadcn/ui

```bash
npx shadcn@latest init

# Add components
npx shadcn@latest add button
npx shadcn@latest add input
npx shadcn@latest add form
npx shadcn@latest add dialog
npx shadcn@latest add table
```

### Form Example

**components/forms/document-form.tsx**:
```typescript
'use client';

import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { CreateDocumentSchema, CreateDocumentInput } from '@/lib/schemas/documents';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from '@/components/ui/form';

export function DocumentForm() {
  const form = useForm<CreateDocumentInput>({
    resolver: zodResolver(CreateDocumentSchema),
  });

  const onSubmit = async (data: CreateDocumentInput) => {
    const res = await fetch('/api/documents', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });

    if (res.ok) {
      alert('Document created!');
      form.reset();
    }
  };

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        <FormField
          control={form.control}
          name="title"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Title</FormLabel>
              <FormControl>
                <Input {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        
        <Button type="submit" disabled={form.formState.isSubmitting}>
          {form.formState.isSubmitting ? 'Creating...' : 'Create Document'}
        </Button>
      </form>
    </Form>
  );
}
```

---

## Deployment (Vercel)

### 1. Push to GitHub

```bash
git init
git add .
git commit -m "chore: initial commit"
git branch -M main
git remote add origin https://github.com/username/my-app.git
git push -u origin main
```

### 2. Deploy on Vercel

1. Go to [vercel.com](https://vercel.com)
2. Import GitHub repository
3. Add environment variables:
   - `DATABASE_URL`
   - `JWT_SECRET`
   - `JWT_REFRESH_SECRET`
   - `NEXTAUTH_SECRET`
4. Deploy

**Auto-deployments**: Every push to `main` triggers deployment

---

## Testing

### Install Vitest

```bash
pnpm add -D vitest @vitejs/plugin-react
```

**vitest.config.ts**:
```typescript
import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
  },
});
```

### Test Example

**__tests__/lib/auth/password.test.ts**:
```typescript
import { describe, it, expect } from 'vitest';
import { hashPassword, verifyPassword } from '@/lib/auth/password';

describe('Password hashing', () => {
  it('hashes and verifies password', async () => {
    const password = 'SecurePass123';
    const hash = await hashPassword(password);
    
    expect(await verifyPassword(password, hash)).toBe(true);
    expect(await verifyPassword('WrongPass', hash)).toBe(false);
  });
});
```

---

## Performance Optimization

### Image Optimization

```tsx
import Image from 'next/image';

<Image
  src="/logo.png"
  alt="Logo"
  width={200}
  height={100}
  priority
/>
```

### Font Optimization

```tsx
import { Inter } from 'next/font/google';

const inter = Inter({ subsets: ['latin'] });

export default function RootLayout({ children }) {
  return (
    <html lang="en" className={inter.className}>
      <body>{children}</body>
    </html>
  );
}
```

### Metadata for SEO

```tsx
import { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'My App',
  description: 'Full-stack Next.js app',
  openGraph: {
    title: 'My App',
    description: 'Full-stack Next.js app',
    url: 'https://myapp.com',
    siteName: 'My App',
    images: ['/og-image.png'],
  },
};
```

---

## Common Issues

### Prisma Client Not Found

```bash
npx prisma generate
```

### Hydration Errors

Use `'use client'` for components with interactivity (forms, buttons)

### Middleware Not Working

Check `proxy.ts` `matcher` config

---

## Next Steps

1. **Auth**: Implement full auth flow (see `patterns/security/authentication.md`)
2. **File uploads**: Add S3/R2 integration
3. **Email**: Add Resend for transactional emails
4. **Payment**: Integrate Stripe/Midtrans
5. **Analytics**: Add PostHog/Mixpanel
6. **Monitoring**: Add Sentry for error tracking

---

## See Also

- [Next.js Documentation](https://nextjs.org/docs)
- [Prisma Docs](https://www.prisma.io/docs)
- [shadcn/ui](https://ui.shadcn.com)
- `patterns/validation/zod-patterns.md` - Validation schemas
- `patterns/security/authentication.md` - JWT auth
