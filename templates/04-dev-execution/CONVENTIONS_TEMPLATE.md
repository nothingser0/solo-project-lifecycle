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
   - Using the `any` type is PROHIBITED. Use `unknown` if the data type cannot be determined in advance, then narrow it using *Type Guards* or Zod validation.
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
