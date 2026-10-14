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
4. **Hydration-Free First (Server-First Rendering)**:
   - If a view is correct without hydration, it MUST NOT be hydrated. `'use client'` is an exception recorded per leaf component in `VERIFY_LOCAL.md` §4C, never the default.
   - No non-deterministic value may be produced during the initial render: `Date.now()`, `new Date()`, `Math.random()`, `crypto.randomUUID()`.
   - `localStorage` / `sessionStorage` / `window` / `matchMedia` are read **after** mount (`useEffect`) or, preferably, never — server-readable cookies/session replace them.
   - Every date/number formatter passes an explicit `locale` **and** `timeZone` (`new Intl.DateTimeFormat('id-ID', { timeZone: 'Asia/Jakarta' })`); bare `toLocaleString()` is PROHIBITED because server and client ICU builds disagree.
   - Prefer server round-trips over client state for sorting, filtering, and pagination (URL search params).
   - `suppressHydrationWarning` is permitted only for a single known-unknowable node — never to silence an undiagnosed mismatch or an entire subtree.
   - Full decision ladder: `references/technical/HYDRATION_FREE_RENDERING.md`.

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
   - Never override with `md:text-sm`, which triggers auto-zoom on touch tablets and iPads (≥ 768px).
2. **Anti-Disabled Pristine Button Rule**:
   - Form submit buttons remain enabled in pristine/untouched state (validation triggers on click with auto-focus to first invalid field).
3. **Calibrated Notification Toast Behavior**:
   - Success notifications: Auto-dismiss permitted after ≥ 4000ms with pause on hover/focus.
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

---

## 6. Anti-Slop UI & The Craftsmanship Standard

*Adopts core filter rules from the Anti-Slop standard to ensure designs feel human-crafted, intentional, and grounded in domain reality:*

1. **The Purpose Test (No Technique Without Reason)**:
   - Every visual decision (radius, border, badge, animation, shadow) must have an articulated purpose. If the only rationale is "it's the AI default" or "it looks modern", eliminate it.
2. **Zero Default Tailwind Blue & AI Gradients**:
   - Using unstyled Tailwind blue (`#3B82F6` / `blue-500`) or purple-to-blue text gradients (`bg-gradient-to-r from-blue-600 to-purple-600`) as primary brand styles is PROHIBITED. All accent colors must be defined in `DESIGN.md`.
3. **No Cliché Decorative Pills (Eyebrow Badges)**:
   - Do not place decorative badge capsules (`[ ✨ AI Powered ]`, `[ Beta 2.0 ]`, `[ New ]`) directly above page headlines unless conveying a critical system state.
4. **Functional Completeness (No Dead Decoration)**:
   - Every interactive element (button, link, tab, filter) MUST be wired to a real handler or route. Zero `href="#"`, zero dummy buttons, zero "Coming Soon" alerts on primary flows.
5. **Evidence Over Fabricated Claims**:
   - Never generate fake testimonials, fictional user stats ("10k+ active teams", "99.9% uptime"), or placeholder "Trusted By" logos unless provided by the user.
6. **Mirror Component Signatures**:
   - Buttons, cards, and input fields must inherit exact height, padding, and corner radius extracted from the human's visual benchmark in `notes.md` (no unprompted pill buttons or excessive rounded corners).
7. **Zero Internal Spec Leaks in Customer Views**:
   - Screen IDs (`SCR-01`, `SCR-02`), internal document headers, and technical slots (`[WASM Canvas slot]`, `[slot]`) must NEVER appear in rendered customer-facing UI. Use authentic domain-specific nomenclature.
8. **Prohibited Raw OS Emoticons in UI Actions**:
   - Do not use raw OS emoji (e.g. ⚙️, 📁, 🚀, ❌) as icons for actions, navigations, or statuses in production components. Always import standardized SVG icon components (e.g. Lucide React).
9. **Layout Fidelity to Inspiration**:
   - Layout implementations must strictly align with the spatial structure, density, and layout archetypes deposited in `docs/design/inspiration/` and synthesized in `DESIGN.md`.
