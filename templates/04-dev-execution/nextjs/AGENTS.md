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

## CRITICAL: Read Project Design Specifications

**BEFORE implementing any UI component, check project design docs:**

- **DESIGN.md**: Color tokens, typography, spacing, component styles
- **DESIGN_SPEC.md** (or DESIGN_SYSTEM.md): Screen specifications, component specs
- **SITEMAP.md**: Route structure, navigation hierarchy

**Why**: Generic Tailwind ≠ project design. Must match brand identity.

**For each screen/component:**
1. Find screen ID in SITEMAP.md (e.g., SCR-09 Dashboard)
2. Read corresponding section in DESIGN_SPEC.md
3. Extract design tokens from DESIGN.md:
   - Primary brand color (not generic neutral)
   - Shadow style (flat border vs heavy shadow)
   - Typography scale (specific font weights/sizes)
4. Implement exactly as specified

**Anti-Pattern:**
❌ `className="bg-neutral-100"` (generic)
✅ `className="bg-primary-600"` (brand primary from DESIGN.md)

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
