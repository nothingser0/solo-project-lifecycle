# ARCHITECTURE.md - Next.js Project

> Technical architecture, directory layout, database schema, and API contracts

---

## System Topology

```text
[ Browser Client ]
        │
        ▼ (HTTPS / JSON API)
[ Next.js App Router ]
        │
   ┌────┴────┐
   ▼         ▼
[ Database ] [ External APIs ]
```

---

## Directory Structure

```text
src/
├── app/                    # Next.js App Router
│   ├── (auth)/            # Auth pages (login, register)
│   ├── (dashboard)/       # Protected dashboard routes
│   ├── api/               # API Route Handlers
│   └── layout.tsx         # Root layout
├── components/
│   ├── ui/                # shadcn/ui primitives
│   └── features/          # Feature-specific components
├── lib/
│   ├── db.ts              # Database client (Prisma/Drizzle)
│   ├── auth.ts            # Auth helpers
│   └── utils.ts           # Shared utilities
└── schemas/               # Zod validation schemas
```

---

## Database Schema

Refer to `docs/specs/FSD.md` for complete schema.

Key tables:
- **users**: Authentication, roles
- **[domain_entity]**: Core business entities

---

## API Routes

| Endpoint | Method | Auth | Payload | Response |
|----------|--------|------|---------|----------|
| `/api/auth/login` | POST | - | email, password | 200 + cookie |
| `/api/[resource]` | GET | ✓ | - | 200 + array |
| `/api/[resource]` | POST | ✓ | form data | 201 + id |
| `/api/[resource]/:id` | PATCH | ✓ | partial data | 200 |
| `/api/[resource]/:id` | DELETE | ✓ | - | 204 |

---

## Security Rules

1. **Server Components**: Default for all pages
2. **API Auth**: Verify JWT/session on protected routes
3. **Input Validation**: Zod schemas for all API inputs
4. **Error Handling**: Never expose stack traces to clients
