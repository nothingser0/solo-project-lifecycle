# AI Agent Guidelines - Remix Project

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

- **docs/specs/DESIGN_SYSTEM.md**: Design tokens, screen specifications, component styles
- **docs/specs/SITEMAP.md**: Route structure with Screen IDs (SCR-XX)
- **docs/design/stitch-output/**: Generated screen components (if using Google Stitch)
- **DESIGN.md** (root): Simplified tokens reference (copied from docs/)

**Why**: Generic Tailwind ≠ project design. Must match brand identity.

**For each screen/component:**
1. Find screen ID in docs/specs/SITEMAP.md (e.g., SCR-09 Dashboard)
2. Read corresponding section in docs/specs/DESIGN_SYSTEM.md
3. Check docs/design/stitch-output/SCR-09/ if available
4. Extract design tokens from DESIGN.md (root):
   - Primary brand color (not generic neutral)
   - Shadow style (flat border vs heavy shadow)
   - Typography scale (specific font weights/sizes)
5. Implement exactly as specified

---

## Code Style Rules
1. **TypeScript Strict Mode**: No `any` types. Use proper interfaces.
2. **Server Code**: Loaders and actions run only on server, never ship to client.
3. **File Naming**: kebab-case for routes (`user-profile.tsx`), PascalCase for components.
4. **Route Conventions**: File-based routing (app/routes/), nested routes via dot notation.
5. **Progressive Enhancement**: Forms work without JavaScript (use `<Form>` from Remix).

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
