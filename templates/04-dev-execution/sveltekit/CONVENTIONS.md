# Svelte 5 & SvelteKit 3 Coding Conventions

1. **Naming Conventions**:
   - Components: `PascalCase.svelte` (e.g., `StatCard.svelte`).
   - Routes: lowercase kebab-case directories (e.g., `routes/inventory-items/+page.svelte`).
   - Server utilities: `camelCase.ts` inside `$lib/server/`.

2. **Validation & Typing**:
   - Validate all action payloads using Zod before touching the database.
   - Return `{ errors: ... }` via `fail(400, { ... })` on validation failures.

3. **Styling & Assets**:
   - Tailwind CSS utility classes aligned with `DESIGN.md` design tokens.
   - Accessible HTML semantics and WCAG 2.1 AA compliant color contrasts.
