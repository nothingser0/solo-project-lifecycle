# CONVENTIONS.md - Next.js Project

> Code style standards and technical conventions for AI agents

---

## File Naming

1. **Format**: `kebab-case` for all files
   - ✅ `user-profile.tsx`, `auth-proxy.ts`
   - ❌ `UserProfile.tsx`, `authMiddleware.ts`

2. **Component Names**: PascalCase for React components
   ```typescript
   // file: user-card.tsx
   export function UserCard() { ... }
   ```

3. **No Barrel Files**: Direct imports only
   - ❌ `index.ts` re-exports
   - ✅ `import { Button } from '@/components/ui/button'`

---

## React & Next.js Standards

1. **Server Components Default**
   - All components in `app/` are Server Components
   - Use `'use client'` only for interactivity (useState, onClick)

2. **Async Server Components**
   ```typescript
   export default async function Page() {
     const data = await fetchData()
     return <div>{data}</div>
   }
   ```

3. **Client Component Pattern**
   ```typescript
   'use client'
   import { useState } from 'react'
   
   export function InteractiveButton() {
     const [count, setCount] = useState(0)
     return <button onClick={() => setCount(c => c + 1)}>{count}</button>
   }
   ```

---

## TypeScript Discipline

1. **No `any` Types**
   - Use `unknown` if type uncertain, then narrow with type guards
   
2. **Zod-First Types**
   ```typescript
   const UserSchema = z.object({ id: z.string(), name: z.string() })
   type User = z.infer<typeof UserSchema>
   ```

3. **Discriminated Unions for States**
   ```typescript
   type State<T> =
     | { status: 'idle' }
     | { status: 'loading' }
     | { status: 'error'; error: string }
     | { status: 'success'; data: T }
   ```

---

## Error Handling

1. **Early Returns** (guard clauses)
   ```typescript
   if (!user) return { error: 'Not found' }
   if (!user.isActive) return { error: 'Inactive' }
   // happy path continues
   ```

2. **Never Empty Catch**
   ```typescript
   try {
     await action()
   } catch (error) {
     console.error('Action failed:', error)
     throw error // or handle meaningfully
   }
   ```

---

## API Route Conventions

```typescript
// app/api/users/route.ts
export async function GET(request: Request) {
  // 1. Auth check
  const session = await getSession()
  if (!session) return Response.json({ error: 'Unauthorized' }, { status: 401 })
  
  // 2. Validation (if query params)
  const url = new URL(request.url)
  const page = parseInt(url.searchParams.get('page') || '1')
  
  // 3. Business logic
  const users = await db.user.findMany({ skip: (page - 1) * 20, take: 20 })
  
  // 4. Response
  return Response.json({ users })
}
```
