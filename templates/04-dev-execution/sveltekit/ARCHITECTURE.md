# SvelteKit 3 / Svelte 5 Architecture Guide

## Directory Structure

```text
src/
├── app.html              # HTML shell
├── hooks.server.ts       # Server middleware, auth guards, locals
├── lib/
│   ├── server/           # Server-only modules (DB client, secrets)
│   │   ├── db.ts
│   │   └── schema.ts
│   ├── components/       # Reusable Svelte 5 UI components
│   └── utils/            # Shared formatting, helpers, Zod schemas
└── routes/
    ├── +layout.svelte    # Global layout & design tokens
    ├── +layout.server.ts # Global session data loader
    ├── +page.svelte      # Public landing / dashboard
    └── api/              # Standalone REST / webhook handlers
        └── webhooks/
            └── +server.ts
```

## Architectural Rules

1. **Server vs Client Isolation**: Everything inside `$lib/server/` cannot be imported by client-side code. SvelteKit build fails automatically if violated.
2. **Form Actions First**: Prefer SvelteKit native form actions (`use:enhance`) over manual client `fetch()` for mutations to preserve progressive enhancement and automatic cache invalidation.
3. **Database Client Pooling**: Instantiate database clients (Prisma, Drizzle, or PocketBase/Supabase) once in `$lib/server/db.ts` to prevent connection exhaustion.
