# CONVENTIONS.md

> Code style standards, component architecture, and technical conventions for AI coding agents to prevent low-quality code (*AI slop code*).

---

## 1. File Naming & Structural Rules (File Naming)

1. **File Naming Format**:
   - All filenames must use **`kebab-case`** format:
     - Correct: `document-form.tsx`, `auth-middleware.ts`, `use-vault-storage.ts`
     - Incorrect: `DocumentForm.tsx`, `authMiddleware.ts`, `use_vault.ts`
2. **Prohibited Barrel Files (`index.ts`)**:
   - Creating `index.ts` files that re-export all files in a folder (*re-export barrels*) is PROHIBITED.
   - Always import modules directly from their specific files to maintain optimal *tree-shaking* performance and prevent circular dependencies (*circular dependencies*).

---

## 2. React & Next.js App Router Standards

1. **Server Components as the Primary Default**:
   - All pages and components in `src/app/` are **React Server Components (RSC)** by default.
   - Placing the `'use client'` directive at the top level of a page is PROHIBITED.
2. **Isolating `'use client'` to Leaf Components**:
   - Use `'use client'` only on the smallest components that genuinely require browser interaction (`useState`, `useEffect` hooks, or `onClick` events), such as interactive buttons or signature canvases.
3. **Disciplined State Management**:
   - Use *Discriminated Unions* to manage mutation/data states:
     ```typescript
     type RequestState<T> =
       | { status: "idle" }
       | { status: "loading" }
       | { status: "error"; message: string }
       | { status: "success"; data: T };
     ```

---

## 3. TypeScript Discipline & Type Handling

1. **Zero `any` Policy**:
   - Using the `any` type is PROHIBITED. Enforce `strict: true` and `noUncheckedIndexedAccess: true` in `tsconfig.json`.
   - Double assertions (`as unknown as TargetType`) and non-null assertions (`!`) without guards are STRICTLY PROHIBITED.
2. **Single Source of Truth Types from Zod**:
   - Writing TypeScript interfaces and Zod schemas separately when they represent the same data is prohibited. Always infer types from Zod schemas:
     ```typescript
     export const UserSchema = z.object({ id: z.string().uuid(), email: z.string().email() });
     export type User = z.infer<typeof UserSchema>;
     ```

---

## 4. Code Structure & Error Handling (Clean Code & Error Handling)

1. **Early Returns Pattern (Guard Clauses)**:
   - Handle error conditions and validation failures at the beginning of functions. Avoid deeply nested `if-else` branching (*arrow anti-pattern*).
2. **No Swallowing Errors (No Empty Catch)**:
   - Writing empty catch blocks: `catch (e) {}` is PROHIBITED. All errors must be logged using structured loggers or rethrown with meaningful messages.
3. **Centralized Constants**:
   - Magic numbers or transaction status strings must be defined as typed constants (*const assertions* or TypeScript enums).
4. **Uniform Action Result Contract**:
   - Server mutations must return a consistent `ActionResult<T>` structure:
     ```typescript
     export type ActionError = { code: string; message: string; fieldErrors?: Record<string, string[]> };
     export type ActionResult<T> = { success: true; data: T } | { success: false; error: ActionError };
     ```

---

## 5. Form Ergonomics & Data Sanitization

1. **Universal 16px Input Font Size (iOS Anti-Zoom Rule)**:
   - Form inputs (`<input>`, `<select>`, `<textarea>`) MUST be at least `16px` (`text-base`) across all viewports.
   - Never override with `md:text-sm`, which triggers auto-zoom on touch tablets and iPads ($\ge 768$px).
2. **Anti-Disabled Pristine Button Rule**:
   - Form submit buttons remain enabled in pristine/untouched state (validation triggers on click with auto-focus to first invalid field).
3. **Calibrated Notification Toast Behavior**:
   - Success notifications: Auto-dismiss permitted after $\ge 4000$ms with pause on hover/focus.
   - Error and offline alert notifications: STRICTLY FORBIDDEN to auto-dismiss (manual dismissal required).
4. **Safe Spreadsheet Export Sanitization**:
   - When exporting tabular data to CSV or Excel, escape formula triggers without breaking pure negative numbers:
     ```typescript
     export function sanitizeExportCell(value: unknown): string | number {
       if (typeof value === 'number') return value;
       if (value === null || value === undefined) return '';
       const str = String(value);
       if (/^-?\d+(\.\d+)?$/.test(str)) return str; // Preserve pure numeric strings
       const triggers = ['=', '+', '-', '@', '\t', '\r'];
       return triggers.some(t => str.startsWith(t)) ? `'${str}` : str;
     }
     ```
