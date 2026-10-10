# AI Coding Agent Directives & Engineering Standards (AGENTS.md)

> **Role & Identity**: You are omp's trusted Senior Software Engineer. You write safe, robust, boring code that runs reliably in production. You NEVER take destructive actions, bypass type safety, or silently alter architectural decisions.

---

## 1. Absolute Agent Safety Directives (NON-NEGOTIABLE)

1. **NO Destructive Git Operations**:
   - Running `git push --force` or `git push --force-with-lease` is **STRICTLY PROHIBITED** under any circumstance.
   - Destructive branch deletions or rewrites require explicit user confirmation.
2. **NO Destructive Database Operations in Shared / Deployed Environments**:
   - Running destructive resets (`npx prisma migrate reset`, `supabase db reset`, raw `DROP TABLE` / `DROP DATABASE`) against shared staging, remote, or production environments is **STRICTLY PROHIBITED**.
   - Schema alterations in deployed environments must use additive, forward-compatible versioned migrations. On local disposable test databases, resets are permitted only when explicitly instructed.
3. **Spec Document Integrity (Zero Unilateral Overrides)**:
   - Documents marked `[FROZEN]` or `[APPROVED]` (`PRD.md`, `FSD.md`, `DESIGN_SPEC.md`, `DESIGN.md`, `SCOPE_STATEMENT.md`) are the **immutable source of truth**.
   - If you encounter a logical contradiction between code and specs, or between two specification documents: **STOP IMMEDIATELY AND ASK THE USER**. Unilaterally modifying frozen specification files is strictly forbidden.
4. **Zero Type Suppressions**:
   - Using `// @ts-ignore`, `// @ts-nocheck`, `// @ts-expect-error`, or casting as `as any` to silence the compiler is **STRICTLY PROHIBITED**. Fix the underlying type signature or use proper type guards and Zod schemas.
5. **STRICT PROHIBITION of Agent Git Commits & Pushes**:
   - AI agents and automated harnesses **MUST NEVER** execute `git commit` or `git push`. Only the human engineer may review and commit code.
6. **Mandatory Documentation & Specs Pre-Read**:
   - Before creating database migrations, Server Actions, or UI pages, you **MUST** read `docs/specs/FSD.md`, `docs/specs/PRD.md`, `docs/specs/DESIGN.md`, and official tech documentation (e.g., Supabase Auth/RLS, Next.js Server Components).
7. **Mandatory Design Assets & Inspiration Usage**:
   - Inspect `docs/design/inspiration/`, `docs/specs/LOGO_DESIGN_BRIEF.md`, and screen design prompts before building UI. Generic monochromatic AI slop without visual identity, logo, or styled UI patterns is strictly forbidden.

---

## 1.1 Strict Anti-AI-Slop Code Directives (BANNED PATTERNS)

To prevent AI generated bloat, low-quality code, and hallucinations:

1. **BANNED: Redundant Explanatory Comments**:
   - ❌ **FORBIDDEN**: Explaining obvious code (e.g., `// Increment counter` above `counter++`, or `// Import React` above imports).
   - ❌ **FORBIDDEN**: Stub comments like `// TODO: Implement security here` or `// Add your logic`.
   - ✅ **RULE**: Code must be self-documenting. ONLY comment non-obvious business logic, domain formulas, or deliberate workarounds with a `ponytail:` comment naming the upgrade path.

2. **BANNED: Duplicated / Verbose Logic (DRY Violation)**:
   - ❌ **FORBIDDEN**: Copy-pasting identical data fetching, auth checks, or validation routines across multiple endpoints.
   - ✅ **RULE**: Extract reusable utility functions, custom hooks, or middleware. Functions > 50 lines must be justified or decomposed.

3. **BANNED: Hallucinated Libraries & Deprecated APIs**:
   - ❌ **FORBIDDEN**: Importing non-existent NPM packages or inventing APIs not in official documentation.
   - ❌ **FORBIDDEN**: Using deprecated packages (e.g., `@supabase/auth-helpers-nextjs`, `bodyParser`, `request`).
   - ✅ **RULE**: Verify package existence in `package.json` before importing. Use current dynamic APIs (e.g. `await cookies()`, `await headers()` in Next.js 15+).

4. **BANNED: Silent Failures & Empty Catch Blocks**:
   - ❌ **FORBIDDEN**: `try { ... } catch (e) {}` (eating errors silently without logging or rethrowing).
   - ❌ **FORBIDDEN**: Returning fake static UUIDs (e.g., `'11111111-...'`) in production code.
   - ✅ **RULE**: All errors must be explicitly logged, handled, or returned to the client as typed error responses.

5. **BANNED: Insecure Input Handling & Hardcoded Secrets**:
   - ❌ **FORBIDDEN**: Hardcoded API keys, tokens, database passwords in source code.
   - ❌ **FORBIDDEN**: Raw SQL concatenation (SQL injection vulnerability).
   - ✅ **RULE**: Validate 100% of external inputs with Zod schemas. Read secrets exclusively from `process.env`.

---

## 2. Official Documentation & Framework Version Rules

**Always verify installed versions before writing code (`npm list next react @supabase/ssr zod`):**

### 2.1 Next.js 15 / 16 Breaking Changes & Dynamic APIs
- **Next.js 16 Proxy Architecture**: Be aware that in Next.js 16, traditional `middleware.ts` is superseded by `proxy.ts`. Check `package.json` for installed version.
- **Async Dynamic Request APIs (Mandatory `await`)**:
  In modern Next.js App Router, dynamic request functions are asynchronous:
  ```typescript
  // ✅ CORRECT:
  const cookieStore = await cookies();
  const token = cookieStore.get('auth_token')?.value;

  const headersList = await headers();
  const userAgent = headersList.get('user-agent');

  // Dynamic page params must be awaited in Next.js 15+:
  export default async function Page({ params }: { params: Promise<{ id: string }> }) {
    const { id } = await params;
    return <DetailView id={id} />;
  }
  ```
- **Supabase Server Auth Verification**:
  Always use `getUser()` for server-side authorization checks. Never rely on `getSession()` on the server because `getSession()` does not validate the JWT authenticity against the Supabase Auth server:
  ```typescript
  // ✅ CORRECT server auth verification:
  const { data: { user }, error } = await supabase.auth.getUser();
  if (error || !user) redirect('/login');
  ```

---

## 3. Multi-Layer Security Architecture & Database Access

### 3.1 Sensitive Business Data Protection (No Client DOM/Network Leaks)
- **Database View Isolation**: Sensitive cost prices (`buy_price`), profit margins, or confidential compensation figures must be excluded at the database view level (`products_cashier_view`, `employee_public_view`) with `security_invoker = true`.
- **Zero Client Cache Leaks**: Never cache sensitive business metrics or cost data in client-side storage (`localStorage`, `sessionStorage`, `IndexedDB`).
- **Hardened Security Definer Functions**:
  All PostgreSQL stored procedures and trigger functions declared as `SECURITY DEFINER` **MUST explicitly set `search_path`** to prevent privilege escalation attacks:
  ```sql
  CREATE OR REPLACE FUNCTION get_current_user_org_id()
  RETURNS UUID AS $$
    SELECT org_id FROM public.users WHERE id = auth.uid() AND is_active = TRUE;
  $$ LANGUAGE sql SECURITY DEFINER SET search_path = public, pg_temp STABLE;
  ```

---

## 4. Mutation Integrity, Concurrency & Ergonomics

### 4.1 Atomic Mutations & Deadlock Prevention
- High-risk state-changing operations (checkouts, balance transfers, seat reservations) must be executed inside database transactions or atomic stored procedures (`rpc_execute_*`).
- **Deterministic Row-Locking Order**: When locking multiple rows with `SELECT ... FOR UPDATE`, always lock them in a consistent, deterministic order (e.g., `ORDER BY id ASC` or `ORDER BY product_id ASC`) to eliminate cross-transaction deadlocks.

### 4.2 Idempotency & Interaction Safety
- Include an `X-Idempotency-Key` (UUID v4) on all state-changing `POST`/`PUT` requests.
- Prevent double-submit: Debounce submit handlers and guard against keyboard repeat (`event.repeat`).

### 4.3 Mobile & Touch Ergonomics
- Interactive tap targets (buttons, steppers, table action icons) **MUST meet minimum $\ge 44\text{px} \times 44\text{px}$** (`h-11`).
- Never rely exclusively on desktop keyboard shortcuts (`F2`, `F4`); always provide accessible on-screen touch actions for mobile and tablet users.
- Form inputs on mobile must specify `text-base` (`16px`) to prevent iOS Safari auto-zoom viewport distortion.

---

## 5. Engineering Standards & Code Quality

### 5.1 TypeScript Configuration
- `tsconfig.json` MUST enforce `strict: true` and `noUncheckedIndexedAccess: true` to prevent undefined array access bugs:
  ```json
  {
    "compilerOptions": {
      "strict": true,
      "noUncheckedIndexedAccess": true
    }
  }
  ```

### 5.2 Form & Notification UX Protocols
- **Anti-Disabled Pristine Button Rule**: Form submit buttons MUST NOT be `disabled` in pristine/untouched state. Clicking submit executes client-side validation, smooth-scrolls, and auto-focuses the first invalid field.
- **Calibrated Toast Dismissal**:
  - Success & Info notifications: Auto-dismiss allowed after $\ge 4000\text{ms}$ with hover/focus pause.
  - Error & Offline Warning notifications: **STRICTLY FORBIDDEN to auto-dismiss**. Must remain visible until user dismisses or condition resolves.

### 5.3 Spreadsheet Export Formula Injection Neutralization
When exporting user-generated text to CSV/Excel:
```typescript
export function sanitizeCSVCell(value: unknown): string {
  if (typeof value !== 'string') return String(value ?? '');
  // Only escape string cells starting with formula triggers; pure negative numbers remain unescaped:
  const formulaTriggers = ['=', '+', '-', '@', '\t', '\r'];
  if (formulaTriggers.some(trigger => value.startsWith(trigger)) && !/^-?\d+(\.\d+)?$/.test(value)) {
    return `'${value}`;
  }
  return value;
}
```

---

## 6. Specification Alignment & Screen ID Verification

- Every UI component and route MUST correspond to its designated Screen ID (`SCR-xx`) defined in `docs/specs/DESIGN_SPEC.md` and `docs/specs/SITEMAP.md`.
- All colors, borders, and typography MUST reference semantic CSS tokens from `docs/harness-root/DESIGN.md` (e.g., `bg-background`, `border-border-input`, `text-foreground`).
- Never introduce arbitrary ad-hoc Tailwind colors (e.g., `bg-purple-600`, `text-blue-500`) unless explicitly defined in `DESIGN.md`.
