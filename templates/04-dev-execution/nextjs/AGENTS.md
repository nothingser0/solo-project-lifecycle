# AI Agent Guidelines - Next.js Project

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
