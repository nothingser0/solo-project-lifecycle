# AI Agent Guidelines - Next.js Project

## CRITICAL: Read Official Documentation First

**BEFORE implementing any feature, check official docs for current syntax:**

- **Next.js Docs**: https://nextjs.org/docs (check version-specific pages)
- **React Docs**: https://react.dev
- **Prisma Docs**: https://www.prisma.io/docs
- **NextAuth Docs**: https://authjs.dev

**Why**: Framework syntax changes between versions. This project uses:
- Next.js 15.x (check ARCHITECTURE.md for exact version)
- Breaking changes exist in 16.x (middleware→proxy)

**When uncertain about syntax:**
1. Read official docs for installed version
2. Check migration guides for breaking changes
3. Verify with type-checking before committing

### Version-Specific Syntax Enforcement

**MANDATORY: Check docs before using these APIs** (syntax changes frequently):

| API Category | Docs URL | Common Version Conflicts |
|:-------------|:---------|:-------------------------|
| **Metadata API** | https://nextjs.org/docs/app/api-reference/functions/generate-metadata | Next.js 13 vs 15 signature changes |
| **Server Actions** | https://nextjs.org/docs/app/building-your-application/data-fetching/server-actions-and-mutations | Stability changes per version |
| **Image Component** | https://nextjs.org/docs/app/api-reference/components/image | Props differ Next.js 13 vs 15 |
| **Middleware** | https://nextjs.org/docs/app/building-your-application/routing/middleware | Breaking changes in 16.x |
| **Route Handlers** | https://nextjs.org/docs/app/building-your-application/routing/route-handlers | Request/Response types evolve |
| **Prisma Client** | https://www.prisma.io/docs/orm/prisma-client | Query syntax changes per version |
| **React 19 Features** | https://react.dev/blog | use(), useOptimistic(), transitions |

**Red Flags (Outdated Patterns from Old Versions):**

❌ **Next.js 12/13 Patterns (DO NOT USE)**:
```typescript
// ❌ OLD: getServerSideProps (Pages Router)
export async function getServerSideProps(context) { }

// ✅ NEW: Server Component (App Router)
async function Page() {
  const data = await fetch(...)
  return <div>{data}</div>
}
```

❌ **React 17/18 Patterns (DO NOT USE)**:
```typescript
// ❌ OLD: Class components
class MyComponent extends React.Component { }

// ✅ NEW: Function components + hooks
function MyComponent() { }
```

❌ **Prisma Old Syntax (Verify Current Docs)**:
```typescript
// If you see error: check current Prisma version docs
// Syntax evolves between major versions
// Read: https://www.prisma.io/docs/orm/prisma-client/queries/relation-queries
```

**Enforcement Rules**:

1. **Before using any API**: Search official docs for the EXACT function name
2. **Copy-paste from docs**: Don't rely on memory or old tutorials
3. **Check "Version" dropdown**: Verify docs match installed version (run `npm list next react`)
4. **Migration guides**: Read if upgrading mid-project

**If syntax error occurs**:
```bash
# 1. Check installed version
npm list next react prisma

# 2. Search official docs for that exact version
# Example: "Next.js 15.0.3 generateMetadata"

# 3. Compare your code vs docs example

# 4. If mismatch: update code to match docs, NOT docs to match code
```

## CRITICAL: Read Project Design Specifications

**BEFORE implementing any UI component, read project design docs in docs/ folder:**

- **docs/specs/DESIGN_SYSTEM.md**: Design tokens, screen specifications, component styles
- **docs/specs/SITEMAP.md**: Route structure with Screen IDs (SCR-XX)
- **docs/design/prototype-output/**: Generated screen components (if using Interactive Prototype)
- **DESIGN.md** (root): Simplified tokens reference (copied from docs/)

**Why**: Generic Tailwind ≠ project design. Must match brand identity.

**For each screen/component:**
1. Find screen ID in docs/specs/SITEMAP.md (e.g., SCR-09 Dashboard)
2. Read corresponding section in docs/specs/DESIGN_SYSTEM.md
3. Check docs/design/prototype-output/SCR-09/ if available
4. Extract design tokens from DESIGN.md (root):
   - Primary brand color (not generic neutral)
   - Shadow style (flat border vs heavy shadow)
   - Typography scale (specific font weights/sizes)
5. Implement exactly as specified

**Anti-Pattern:**
❌ `className="bg-neutral-100"` (generic)
✅ `className="bg-primary-600"` (brand primary from docs/specs/DESIGN_SYSTEM.md)

---

## Code Style Rules
1. **TypeScript Strict Mode**: No `any` types. Use proper interfaces.
2. **Server Components**: Default to Server Components, use 'use client' only when needed.
3. **File Naming**: kebab-case for files (`user-profile.tsx`), PascalCase for components.
4. **API Routes**: app/api/[route]/route.ts with Zod validation.
5. **No Barrel Files**: Direct imports only (`import { Button } from '@/components/button'`).

## Database
- ORM: Prisma (preferred) or Drizzle
- Migrations: `prisma migrate dev`
- Seeding: `prisma db seed`

## Testing
- Run: `npm run test:smoke` (Vitest/Jest)
- Must pass before commit

## Build Commands
- Dev: `npm run dev`
- Build: `npm run build`
- Type Check: `tsc --noEmit`

## Commit Format
```
feat: add user profile page
fix: resolve auth token expiry
refactor: extract validation logic
```

## Anti-Patterns (NEVER)
- ❌ No `any` types
- ❌ No raw SQL queries
- ❌ No inline styles (use Tailwind classes)
- ❌ No console.log in production code
- ❌ No client-side secrets (.env.local for server only)
