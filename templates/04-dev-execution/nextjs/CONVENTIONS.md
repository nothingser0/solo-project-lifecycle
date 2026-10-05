# Code Style & Engineering Conventions (CONVENTIONS.md)

> **Purpose**: Technical code style standards, TypeScript strictness, Server Action contracts, touch accessibility, and data sanitization conventions for AI coding agents.
> **Standard**: Zero TypeScript bypasses, robust `ActionResult<T>` contracts, iOS-safe 16px inputs, and formula-injection-safe spreadsheet exports.

---

## 1. File Naming, Directory Structure & Components

1. **Format**: `kebab-case` for all files and folders
   - ✅ `user-profile.tsx`, `auth-proxy.ts`, `data-table.tsx`
   - ❌ `UserProfile.tsx`, `authMiddleware.ts`, `data_table.tsx`
2. **Component Exports**: PascalCase for React component definitions:
   ```typescript
   // file: src/components/domain/order-card.tsx
   export function OrderCard({ id }: OrderCardProps) { ... }
   ```
3. **No Barrel Files (`index.ts`)**: Direct imports only to optimize Turbopack bundling and prevent circular dependencies:
   - ❌ `import { Button, Card } from '@/components'`
   - ✅ `import { Button } from '@/components/ui/button'`
   - ✅ `import { Card } from '@/components/ui/card'`

---

## 2. TypeScript Strict Discipline & Zero-Bypass Policy

1. **Strict Compiler Flags**:
   `tsconfig.json` MUST enforce `strict: true` and `noUncheckedIndexedAccess: true`.
2. **Zero `any` Policy**:
   Using `any` is strictly prohibited. Use `unknown` if the incoming payload is unverified, then narrow it using Zod schemas or type guards.
3. **Prohibition of TypeScript Bypasses**:
   - Double assertions (`as unknown as TargetType`) are **STRICTLY PROHIBITED**.
   - Non-null assertions (`!`) are **STRICTLY PROHIBITED** without adjacent runtime guard checks.
   - Using `// @ts-ignore` or `// @ts-nocheck` is **STRICTLY PROHIBITED**.
4. **Zod Single Source of Truth**:
   Infer application types directly from Zod schemas:
   ```typescript
   export const ResourceSchema = z.object({
     id: z.string().uuid(),
     name: z.string().min(1, 'Name is required'),
     amount: z.number().int().nonnegative('Amount must be non-negative')
   });
   export type Resource = z.infer<typeof ResourceSchema>;
   ```
5. **Monetary Precision**:
   Store all financial amounts as integer minor units or full currency units using `BIGINT` or integer types, never floating-point `number`.

---

## 3. Server Actions & Standardized `ActionResult<T>` Contract

Every Next.js Server Action MUST return a structured, type-safe result contract to facilitate automated testing and client form handling:

```typescript
// src/types/action-result.ts
export type ActionError = {
  code: string; // Machine-readable error code, e.g., 'INSUFFICIENT_STOCK', 'UNAUTHORIZED'
  message: string; // Human-readable error message
  fieldErrors?: Record<string, string[]>; // Field-specific validation errors for forms
};

export type ActionResult<T> =
  | { success: true; data: T }
  | { success: false; error: ActionError };
```

### Standard Action Implementation Pattern
```typescript
'use server';

import { createServerClient } from '@/lib/supabase/server';
import { ActionResult } from '@/types/action-result';

export async function updateResourceAction(
  id: string,
  formData: FormData
): Promise<ActionResult<{ id: string }>> {
  const supabase = await createServerClient();
  const { data: { user }, error: authError } = await supabase.auth.getUser();

  if (authError || !user) {
    return {
      success: false,
      error: { code: 'UNAUTHORIZED', message: 'Authentication required' }
    };
  }

  // Validate inputs, execute mutations...
  return { success: true, data: { id } };
}
```

---

## 4. Form Accessibility & Touch Ergonomics

1. **Universal 16px Input Font Size (iOS Anti-Zoom Rule)**:
   - Form inputs (`<input>`, `<select>`, `<textarea>`) **MUST BE AT LEAST `16px` (`text-base`) across ALL viewports**.
   - ❌ **Prohibited**: Using `text-base md:text-sm` (causes iOS Safari on iPad viewports $\ge 768\text{px}$ to zoom and break the viewport).
   - ✅ **Correct**: `className="text-base h-11 w-full rounded-md border border-border-input ..."`
2. **Anti-Disabled Pristine Button Rule**:
   - Form submission buttons MUST NOT be `disabled` while the form is untouched/pristine.
   - Clicking submit on an incomplete form triggers inline validation, smooth-scrolls, and auto-focuses the first invalid field.
3. **Touch Target Sizing**:
   - Primary interactive touch targets on mobile and tablet interfaces **MUST meet minimum $\ge 44\text{px} \times 44\text{px}$** (`h-11 min-w-11`).
   - *Accessibility Reference*: While WCAG 2.2 Level AA establishes 24px minimum (SC 2.5.8), $44\text{px}$ is our internal ergonomics standard (aligned with WCAG AAA / Apple HIG) to ensure error-free operation on touch terminals.
4. **Calibrated Notification Toast Behavior**:
   - Success & Informational toasts: Auto-dismiss permitted after $\ge 4000\text{ms}$, with timer pause on hover or keyboard focus.
   - Error & System Warning toasts: **STRICTLY FORBIDDEN to auto-dismiss**. They must remain visible until the user explicitly clicks dismiss.

---

## 5. Safe Spreadsheet Export Sanitization (`sanitizeExportCell`)

When exporting user-generated records to CSV or Excel, formula injection triggers must be safely escaped without breaking pure negative numbers:

```typescript
// src/lib/csv.ts
export function sanitizeExportCell(value: unknown): string | number {
  // Preserve pure numbers
  if (typeof value === 'number') {
    return value;
  }

  if (value === null || value === undefined) {
    return '';
  }

  const str = String(value);

  // Preserve pure numeric strings including negative numbers (e.g. "-150000" or "-15.5")
  if (/^-?\d+(\.\d+)?$/.test(str)) {
    return str;
  }

  // Escape dangerous spreadsheet formula triggers (=, +, -, @, \t, \r)
  // Notice: check without trimming so leading control characters are caught
  const formulaTriggers = ['=', '+', '-', '@', '\t', '\r'];
  if (formulaTriggers.some(trigger => str.startsWith(trigger))) {
    return `'${str}`;
  }

  return str;
}
```

---

## 6. Multi-Layer Security & System Time Conventions

1. **Database-Level Data Masking**:
   - Cost prices (`buy_price`), gross margins, and executive salaries MUST NOT be exposed to operational staff roles.
   - Enforce data masking via database views (`products_cashier_view`, `products_public_view`) with `security_invoker = true`.
2. **Authoritative Timestamping**:
   - Store all database timestamps in UTC with timezone: `TIMESTAMPTZ NOT NULL DEFAULT now()`.
   - Never trust client device clock time for ledger ordering. Client timestamps may be logged as `device_timestamp` for metadata, but server `created_at` remains the authoritative source of truth.
   - Format dates on client side according to the tenant's configured timezone (e.g., `Asia/Jakarta`, `en-US`).

---

## 7. Automated Quality Validation Checklist

*Before committing code changes, verify:*

- [ ] **1. Safe Spreadsheet Sanitization**: `sanitizeExportCell` properly preserves pure negative numbers while prepending single quote `'` to formula triggers without premature trimming.
- [ ] **2. Universal 16px Inputs**: All form input styles specify `text-base` (16px) universally without `md:text-sm` viewport overrides.
- [ ] **3. Zero TypeScript Bypasses**: The codebase contains zero occurrences of `any`, `// @ts-ignore`, non-null assertions `!`, or double-casts `as unknown as`.
- [ ] **4. Standardized `ActionResult<T>`**: Server Actions return uniform `{ success: true, data }` or `{ success: false, error: { code, message } }` objects.
- [ ] **5. Touch Ergonomics**: Tap targets on mobile/tablet interfaces meet the 44px comfort standard, with error toasts configured for manual close only.
