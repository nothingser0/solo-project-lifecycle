# Zod Validation Patterns

**Purpose**: Reusable Zod schemas untuk type-safe validation di backend & frontend

**Reference locations**: M06 (lines 229, 342, 1013, 1033, 1193, 1246, 1275, 1394, 1525), M07 (line 22, 61), M08 (line 36, 66, 91)

---

## Core Principles

1. **Single Source of Truth**: Semua TypeScript types derived dari Zod (`z.infer<typeof Schema>`)
2. **Share schemas**: Backend dan frontend gunakan schema yang sama (DRY)
3. **Fail fast**: Validasi di pintu masuk (API handler, form submit)
4. **Structured errors**: Return field-level error messages (422 Unprocessable Entity)

---

## Installation

```bash
# Next.js / React
pnpm add zod @hookform/resolvers

# Backend only
pnpm add zod
```

---

## Basic Schemas

### User Authentication

```typescript
// lib/schemas/auth.ts
import { z } from 'zod';

export const RegisterSchema = z.object({
  email: z.string().email('Email tidak valid'),
  password: z.string()
    .min(8, 'Password minimal 8 karakter')
    .regex(/[A-Z]/, 'Harus ada huruf besar')
    .regex(/[0-9]/, 'Harus ada angka'),
  name: z.string().min(2, 'Nama minimal 2 karakter'),
});

export const LoginSchema = z.object({
  email: z.string().email('Email tidak valid'),
  password: z.string().min(1, 'Password wajib diisi'),
});

export const ResetPasswordSchema = z.object({
  token: z.string().length(32, 'Token tidak valid'),
  password: z.string().min(8, 'Password minimal 8 karakter'),
});

// Infer types
export type RegisterInput = z.infer<typeof RegisterSchema>;
export type LoginInput = z.infer<typeof LoginSchema>;
```

---

### CRUD Operations

```typescript
// lib/schemas/documents.ts
import { z } from 'zod';

export const CreateDocumentSchema = z.object({
  title: z.string().min(1, 'Judul wajib diisi').max(200),
  content: z.string().optional(),
  categoryId: z.string().uuid('Category ID tidak valid'),
  tags: z.array(z.string()).max(10, 'Maksimal 10 tags'),
  status: z.enum(['draft', 'published', 'archived']),
});

export const UpdateDocumentSchema = CreateDocumentSchema.partial();

export const DocumentQuerySchema = z.object({
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(20),
  status: z.enum(['draft', 'published', 'archived']).optional(),
  search: z.string().max(100).optional(),
  sortBy: z.enum(['createdAt', 'updatedAt', 'title']).default('createdAt'),
  sortOrder: z.enum(['asc', 'desc']).default('desc'),
});

export type CreateDocumentInput = z.infer<typeof CreateDocumentSchema>;
export type UpdateDocumentInput = z.infer<typeof UpdateDocumentSchema>;
export type DocumentQuery = z.infer<typeof DocumentQuerySchema>;
```

---

### File Upload

```typescript
// lib/schemas/upload.ts
import { z } from 'zod';

const MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
const ALLOWED_FILE_TYPES = ['application/pdf', 'image/jpeg', 'image/png'];

export const FileUploadSchema = z.object({
  file: z.custom<File>()
    .refine(file => file.size <= MAX_FILE_SIZE, 'File maksimal 5MB')
    .refine(file => ALLOWED_FILE_TYPES.includes(file.type), 
      'Format file harus PDF, JPEG, atau PNG'),
  description: z.string().max(500).optional(),
});

export const BulkUploadSchema = z.object({
  files: z.array(z.custom<File>()).min(1).max(10, 'Maksimal 10 files'),
});
```

---

## Backend Validation

### Next.js API Route

```typescript
// app/api/auth/register/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { RegisterSchema } from '@/lib/schemas/auth';
import { hash } from 'bcrypt';
import { db } from '@/lib/db';

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    
    // Validate with Zod
    const validatedData = RegisterSchema.parse(body);
    
    // Business logic
    const hashedPassword = await hash(validatedData.password, 12);
    const user = await db.user.create({
      data: {
        email: validatedData.email,
        password: hashedPassword,
        name: validatedData.name,
      },
    });
    
    return NextResponse.json({ userId: user.id }, { status: 201 });
    
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { 
          error: 'Validation failed',
          details: error.errors.map(e => ({
            field: e.path.join('.'),
            message: e.message,
          }))
        },
        { status: 422 }
      );
    }
    
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
```

---

### Validation Middleware (Reusable)

```typescript
// lib/middleware/validate.ts
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';

export function validateBody<T extends z.ZodTypeAny>(schema: T) {
  return async (req: NextRequest) => {
    try {
      const body = await req.json();
      const validatedData = schema.parse(body);
      
      // Attach validated data to request
      (req as any).validatedData = validatedData;
      return null; // No error
      
    } catch (error) {
      if (error instanceof z.ZodError) {
        return NextResponse.json(
          {
            error: 'Validation failed',
            details: error.errors.map(e => ({
              field: e.path.join('.'),
              message: e.message,
            }))
          },
          { status: 422 }
        );
      }
      throw error;
    }
  };
}

// Usage
export async function POST(req: NextRequest) {
  const validationError = await validateBody(CreateDocumentSchema)(req);
  if (validationError) return validationError;
  
  const data = (req as any).validatedData as CreateDocumentInput;
  // ... business logic
}
```

---

### Query String Validation

```typescript
// app/api/documents/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { DocumentQuerySchema } from '@/lib/schemas/documents';

export async function GET(req: NextRequest) {
  const searchParams = req.nextUrl.searchParams;
  
  // Convert URLSearchParams to object
  const queryObject = Object.fromEntries(searchParams.entries());
  
  // Validate & parse with defaults
  const query = DocumentQuerySchema.parse(queryObject);
  
  const documents = await db.document.findMany({
    where: {
      status: query.status,
      title: query.search ? { contains: query.search } : undefined,
    },
    orderBy: { [query.sortBy]: query.sortOrder },
    skip: (query.page - 1) * query.limit,
    take: query.limit,
  });
  
  return NextResponse.json({ documents, query });
}
```

---

## Frontend Validation

### React Hook Form Integration

```tsx
// components/forms/register-form.tsx
'use client';

import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { RegisterSchema, RegisterInput } from '@/lib/schemas/auth';

export function RegisterForm() {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<RegisterInput>({
    resolver: zodResolver(RegisterSchema),
  });

  const onSubmit = async (data: RegisterInput) => {
    const res = await fetch('/api/auth/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });
    
    if (!res.ok) {
      const error = await res.json();
      alert(error.details.map(d => d.message).join('\n'));
    }
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
      <div>
        <label htmlFor="email">Email</label>
        <input
          {...register('email')}
          type="email"
          className={errors.email ? 'border-red-500' : ''}
        />
        {errors.email && (
          <p className="text-red-500 text-sm">{errors.email.message}</p>
        )}
      </div>

      <div>
        <label htmlFor="password">Password</label>
        <input
          {...register('password')}
          type="password"
          className={errors.password ? 'border-red-500' : ''}
        />
        {errors.password && (
          <p className="text-red-500 text-sm">{errors.password.message}</p>
        )}
      </div>

      <button type="submit" disabled={isSubmitting}>
        {isSubmitting ? 'Registering...' : 'Register'}
      </button>
    </form>
  );
}
```

---

### Server Actions (Next.js 15)

```tsx
// app/actions/documents.ts
'use server';

import { CreateDocumentSchema } from '@/lib/schemas/documents';
import { db } from '@/lib/db';
import { revalidatePath } from 'next/cache';

export async function createDocument(formData: FormData) {
  const rawData = {
    title: formData.get('title'),
    content: formData.get('content'),
    categoryId: formData.get('categoryId'),
    tags: formData.getAll('tags'),
    status: formData.get('status'),
  };

  // Validate
  const validatedData = CreateDocumentSchema.parse(rawData);

  // Create
  const document = await db.document.create({
    data: validatedData,
  });

  revalidatePath('/documents');
  return { success: true, documentId: document.id };
}
```

---

## Advanced Patterns

### Dependent Fields

```typescript
// lib/schemas/payment.ts
import { z } from 'zod';

export const PaymentSchema = z.discriminatedUnion('method', [
  z.object({
    method: z.literal('bank_transfer'),
    bankCode: z.enum(['bca', 'mandiri', 'bni']),
  }),
  z.object({
    method: z.literal('e_wallet'),
    provider: z.enum(['gopay', 'ovo', 'dana']),
    phoneNumber: z.string().regex(/^08\d{8,11}$/),
  }),
  z.object({
    method: z.literal('credit_card'),
    cardNumber: z.string().length(16),
    cvv: z.string().length(3),
  }),
]);
```

---

### Transform & Coerce

```typescript
// lib/schemas/product.ts
import { z } from 'zod';

export const ProductSchema = z.object({
  name: z.string().trim().min(1), // Remove whitespace
  price: z.coerce.number().positive(), // String → Number
  stock: z.coerce.number().int().min(0),
  tags: z.string().transform(s => s.split(',')), // "tag1,tag2" → ["tag1", "tag2"]
  isActive: z.coerce.boolean(), // "true" → true
});
```

---

### Refinements (Custom Validation)

```typescript
// lib/schemas/booking.ts
import { z } from 'zod';

export const BookingSchema = z.object({
  startDate: z.coerce.date(),
  endDate: z.coerce.date(),
  guests: z.number().int().min(1).max(10),
}).refine(
  data => data.endDate > data.startDate,
  { message: 'End date must be after start date', path: ['endDate'] }
).refine(
  data => {
    const duration = data.endDate.getTime() - data.startDate.getTime();
    const days = duration / (1000 * 60 * 60 * 24);
    return days <= 30;
  },
  { message: 'Booking duration max 30 days', path: ['endDate'] }
);
```

---

## Testing

```typescript
// __tests__/schemas/auth.test.ts
import { describe, it, expect } from 'vitest';
import { RegisterSchema } from '@/lib/schemas/auth';

describe('RegisterSchema', () => {
  it('accepts valid data', () => {
    const data = {
      email: 'user@example.com',
      password: 'Password123',
      name: 'John Doe',
    };
    
    expect(() => RegisterSchema.parse(data)).not.toThrow();
  });

  it('rejects invalid email', () => {
    const data = {
      email: 'not-an-email',
      password: 'Password123',
      name: 'John',
    };
    
    expect(() => RegisterSchema.parse(data)).toThrow('Email tidak valid');
  });

  it('rejects weak password', () => {
    const data = {
      email: 'user@example.com',
      password: 'weak',
      name: 'John',
    };
    
    const result = RegisterSchema.safeParse(data);
    expect(result.success).toBe(false);
    if (!result.success) {
      expect(result.error.errors).toHaveLength(2); // Min length + regex
    }
  });
});
```

---

## Error Handling Best Practices

### Structured Error Response

```typescript
// lib/utils/error-response.ts
import { z } from 'zod';
import { NextResponse } from 'next/server';

export function zodErrorResponse(error: z.ZodError) {
  return NextResponse.json(
    {
      error: 'Validation failed',
      details: error.errors.map(e => ({
        field: e.path.join('.'),
        message: e.message,
        code: e.code,
      }))
    },
    { status: 422 }
  );
}

// Frontend consumption
const res = await fetch('/api/endpoint', { method: 'POST', body });
if (res.status === 422) {
  const { details } = await res.json();
  details.forEach(({ field, message }) => {
    setError(field, { message }); // React Hook Form
  });
}
```

---

## Performance Tips

1. **Lazy parsing**: Use `.safeParse()` instead of `.parse()` to avoid try-catch overhead
2. **Memoize schemas**: Define schemas outside component/function scope
3. **Partial validation**: Use `.pick()` or `.omit()` for subset validation
4. **Async validation**: Use `.parseAsync()` for DB uniqueness checks

```typescript
// Async validation (DB check)
const EmailUniqueSchema = z.string().email().refine(
  async email => {
    const user = await db.user.findUnique({ where: { email } });
    return !user;
  },
  { message: 'Email already registered' }
);

// Usage
const result = await EmailUniqueSchema.parseAsync('user@example.com');
```

---

## Migration: Plain Validation → Zod

**Before** (manual validation):
```typescript
if (!email || !email.includes('@')) {
  return res.status(400).json({ error: 'Invalid email' });
}
if (!password || password.length < 8) {
  return res.status(400).json({ error: 'Password too short' });
}
```

**After** (Zod):
```typescript
const validatedData = LoginSchema.parse({ email, password });
// TypeScript knows validatedData is { email: string, password: string }
```

**Benefits**:
- ✅ Type inference (no manual TypeScript types)
- ✅ Consistent error format
- ✅ Shared frontend/backend validation
- ✅ Self-documenting (schema = single source of truth)

---

## See Also

- `patterns/security/authentication.md` - JWT & password hashing
- `patterns/validation/form-validation.md` - Frontend form patterns
- M06 Development Execution - Zod integration checklist
