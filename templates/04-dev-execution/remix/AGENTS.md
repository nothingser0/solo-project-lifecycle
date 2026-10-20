# AI Agent Guidelines - Remix Project

## 0. Execution Protocol — One Task Per Turn (NON-NEGOTIABLE)

- **`TODO.md` is the queue.** Work its task list **one task at a time**.
- **Per task**: implement ONLY that task → run that task's `Verify` command → paste the raw output → report task ID + files touched + result → 🛑 **END TURN**.
- **Do NOT** start the next task, open a new sprint, or batch task IDs — unless the human names the specific task IDs to run in one instruction.
- **`[x]` is the human's mark, never yours.** Only after the human confirms may you record `Approved: <date> by <name>` in that task's `Evidence`.
- **If a spec, schema, or requirement is missing, STOP and ask** — never invent it to keep the queue moving.
- **Never run `git commit`, `git push`, or `git tag`** — hand the change to the human for review and commit.

---

## CRITICAL: Read Official Documentation First

**BEFORE implementing any feature, check official docs for current syntax:**

- **Remix Docs**: https://remix.run/docs (check version-specific pages)
- **React Docs**: https://react.dev
- **React Router**: https://reactrouter.com/en/main (Remix uses React Router v6+)

**Why**: Remix conventions evolve between versions. This project uses:
- Remix 2.x (check package.json for exact version)
- Breaking changes exist between v1 and v2

### Version-Specific Syntax Enforcement

**MANDATORY: Check docs before using these APIs** (syntax changes frequently):

| API Category | Docs URL | Common Version Conflicts |
|:-------------|:---------|:-------------------------|
| **Loaders** | https://remix.run/docs/en/main/route/loader | Data loading patterns |
| **Actions** | https://remix.run/docs/en/main/route/action | Form handling changes |
| **Meta** | https://remix.run/docs/en/main/route/meta | Meta function signature evolves |
| **Links** | https://remix.run/docs/en/main/route/links | Link preloading syntax |
| **Routing** | https://remix.run/docs/en/main/file-conventions/routes | File-based routing rules change |
| **Error Boundaries** | https://remix.run/docs/en/main/route/error-boundary | Error handling patterns |

**Red Flags (Outdated Patterns):**

❌ **Remix 1.x Patterns (DO NOT USE in v2)**:
```typescript
// ❌ OLD: CatchBoundary (Remix v1)
export function CatchBoundary() { }

// ✅ NEW: ErrorBoundary handles all errors (Remix v2)
export function ErrorBoundary() { }
```

❌ **Remix 1.x Meta (DO NOT USE)**:
```typescript
// ❌ OLD: meta returns object (v1)
export const meta = () => ({ title: 'Page' });

// ✅ NEW: meta returns array (v2)
export const meta = () => [{ title: 'Page' }];
```

**Enforcement Rules**:
1. **Before using any API**: Search Remix docs for exact function name
2. **Check version**: Run `npm list @remix-run/react` to confirm version
3. **Migration guide**: Read v1→v2 guide if upgrading
4. **If syntax error**: Update code to match docs, not vice versa

## CRITICAL: Read Project Design Specifications

**BEFORE implementing any UI component, read project design docs in docs/ folder:**

- **docs/specs/DESIGN_SPEC.md**: Per-screen 5-state specifications (SCR-XX)
- **docs/specs/SITEMAP.md**: Route structure with Screen IDs (SCR-XX)
- **DESIGN.md** (root, staged at `docs/harness-root/DESIGN.md`): design tokens (colors, typography, z-index)

**Why**: Generic Tailwind ≠ project design. Must match brand identity.

**For each screen/component:**
1. Find screen ID in docs/specs/SITEMAP.md (e.g., SCR-09 Dashboard)
2. Read corresponding screen section in docs/specs/DESIGN_SPEC.md
3. Check docs/design/screens/scr-09/ (or docs/design/prompts/scr-09/) if available
4. Extract design tokens from DESIGN.md (root):
   - Primary brand color (not generic neutral)
   - Shadow style (flat border vs heavy shadow)
   - Typography scale (specific font weights/sizes)
5. Implement exactly as specified

---

## Anti-AI-Slop Directives (ENFORCED)
1. **BANNED: Redundant Explanatory Comments** — do not narrate obvious code.
   - ❌ `// Increment counter`  |  `// Import React`
   - ❌ Stub comments: `// TODO: implement this later`  |  `// Add your logic here`
   - ✅ Comment ONLY non-obvious business logic, domain formulas, or deliberate workarounds.
   - ✅ Never leave commented-out dead code — delete it (git remembers).
2. **BANNED: Silent Failures** — no empty catch/except blocks; log, rethrow, or return a typed error.
3. **BANNED: Dead Code & Unused Imports** — remove unused variables, imports, and unreachable branches.
4. **RACE CONDITIONS (MANDATORY for any shared-state mutation)** — protect every read-modify-write on inventory, balances, counters, booking slots, or status transitions:
   - Use a DB transaction + row lock (SELECT ... FOR UPDATE), or a unique constraint / idempotency key.
   - Never "check then act" across two separate queries without a lock or constraint.
   - Webhooks and payment callbacks MUST be idempotent (dedupe on provider event ID).
   - Frontend: disable the submit button while pending + use an idempotency key to prevent double-submit.
5. **BANNED: Hallucinated APIs/Packages** — verify every import exists before using it.

---

## Code Style Rules
1. **TypeScript Strict Mode**: No `any` types. Use proper interfaces.
2. **Server Code**: Loaders and actions run only on server, never ship to client.
3. **File Naming**: kebab-case for routes (`user-profile.tsx`), PascalCase for components.
4. **Route Conventions**: File-based routing (app/routes/), nested routes via dot notation.
5. **Progressive Enhancement**: Forms work without JavaScript (use `<Form>` from Remix).
6. **Hydration-Free Rendering**: the loader output and the first client render must produce identical markup. Never compute `Date.now()`/`new Date()`/`Math.random()` or read `localStorage`/`window` during render — do it in the loader, or in `useEffect` with an explicit default render. Every formatter passes an explicit `locale` **and** `timeZone` (`Intl.DateTimeFormat('id-ID', { timeZone: 'Asia/Jakarta' })`); bare `toLocaleString()` diverges between server and browser. Never use `suppressHydrationWarning` to hide a mismatch you did not diagnose. Full ladder: `references/technical/HYDRATION_FREE_RENDERING.md`.

## Remix Patterns

### Data Loading (Loaders)
```typescript
// app/routes/documents.$id.tsx
import { json, type LoaderFunctionArgs } from "@remix-run/node";
import { useLoaderData } from "@remix-run/react";

export async function loader({ params }: LoaderFunctionArgs) {
  const document = await db.document.findUnique({ where: { id: params.id } });
  if (!document) throw new Response("Not Found", { status: 404 });
  return json({ document });
}

export default function DocumentPage() {
  const { document } = useLoaderData<typeof loader>();
  return <div>{document.title}</div>;
}
```

### Form Handling (Actions)
```typescript
import { json, redirect, type ActionFunctionArgs } from "@remix-run/node";
import { Form, useActionData } from "@remix-run/react";

export async function action({ request }: ActionFunctionArgs) {
  const formData = await request.formData();
  const title = formData.get("title");
  
  // Validation
  if (!title) {
    return json({ error: "Title required" }, { status: 400 });
  }
  
  // Create document
  await db.document.create({ data: { title } });
  return redirect("/documents");
}

export default function NewDocument() {
  const actionData = useActionData<typeof action>();
  
  return (
    <Form method="post">
      <input name="title" />
      {actionData?.error && <p>{actionData.error}</p>}
      <button type="submit">Create</button>
    </Form>
  );
}
```

## Database
- **ORM**: Prisma (recommended) or Drizzle
- **Migrations**: `npx prisma migrate dev`
- **Seeding**: `npx prisma db seed`

## Testing
- **Framework**: Vitest + Testing Library
- **Run**: `npm run test`
- **Must pass before commit**

## Security
- **CSRF**: Built-in protection via Remix Form component
- **SQL Injection**: Use Prisma/Drizzle (parameterized queries)
- **XSS**: React escapes by default
- ❌ No secrets in client code (use loaders/actions for server-side logic)

## Build Commands
- **Dev**: `npm run dev`
- **Build**: `npm run build`
- **Start Production**: `npm run start`
- **Type Check**: `npm run typecheck`

## Dependencies
- **Install**: `npm install`
- **Add Package**: `npm install package-name`
- **Audit**: `npm audit`
