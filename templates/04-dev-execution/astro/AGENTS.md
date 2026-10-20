# AI Agent Guidelines - Astro Project

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

- **Astro**: https://docs.astro.build/
- **Content Collections**: https://docs.astro.build/en/guides/content-collections/
- **Islands / View Transitions**: https://docs.astro.build/en/guides/view-transitions/
- **Integrations** (React/Vue/Svelte): https://docs.astro.build/en/guides/integrations-guide/

**Why**: Astro ships breaking changes between minors (content collections, view transitions, adapter APIs). Verify against the installed version, not memory.

---

## 1. Absolute Agent Safety Directives (NON-NEGOTIABLE)

1. **NO Destructive Git Operations**: `git push --force` and branch rewrites are **STRICTLY PROHIBITED**.
2. **NO Destructive Database Operations**: never run `DROP TABLE`, `TRUNCATE`, or destructive migration rollbacks against staging/production.
3. **Spec Document Integrity**: documents marked `[FROZEN]` / `[APPROVED]` (`PRD.md`, `FSD.md`, `DESIGN_SPEC.md`, `DESIGN.md`, `SCOPE_STATEMENT.md`) are the immutable source of truth. Never edit them to make code fit — raise a Change Request.
4. **Human Commits Only**: AI agents must never run `git commit` or `git push`.
5. **Mandatory Specs Pre-Read**: read `AGENTS.md`, `CONTEXT.md`, `DESIGN.md`, `TODO.md`, and the FSD/`PROJECT_LITE.md` before writing code.

---

## 2. Astro & TypeScript Standards

1. **Type Safety**: TypeScript strict mode. Explicit prop interfaces for every component (`interface Props { … }`). No `any`, no `@ts-ignore`, no `as unknown as`.
2. **Islands Over Hydration**: keep components static by default. Add a client directive *only* when interactivity is genuinely required, and pick the cheapest one (`client:visible` > `client:idle` > `client:load`).
   - A hydrated island must be **deterministic**: no `Date.now()`, `new Date()`, `Math.random()`, `localStorage`, or bare `toLocaleString()` during its initial render — format with an explicit locale **and** `timeZone` (`Intl.DateTimeFormat('id-ID', { timeZone: 'Asia/Jakarta' })`), read storage in an effect, or pass the server value in as a prop. Never hydrate a component that only displays text. Full ladder: `references/technical/HYDRATION_FREE_RENDERING.md`.
3. **Content Collections**: define schemas in `src/content/config.ts` with Zod. Query through `getCollection()` — never read content files with `fs` at runtime.
4. **Server vs Client**: `src/pages` and endpoints run at build/SSR time. Never reference `window`/`document` outside a client directive or `is:inline` script.
5. **Data Fetching**: fetch at build time (top-level await / `Astro.props`) for static routes. Use SSR adapters only when a route genuinely needs per-request data.
6. **No Layout Duplication**: reuse a single `Layout.astro`. Never copy-paste head/meta blocks between pages.

---

## 3. Styling & Design Tokens

1. **Tokens from `DESIGN.md`**: colors, spacing, radii, and typography come from the frozen design tokens. Never introduce an off-palette hex or arbitrary spacing value.
2. **Scoped Styles by Default**: use `<style>` blocks in `.astro` files (auto-scoped). Reach for `:global()` only when styling genuinely external markup.
3. **No Utility-Framework Drift**: if the project uses Tailwind, follow `tailwind.config.*` — do not add inline styles to bypass it.
4. **Accessibility (WCAG 2.2 AA)**: semantic landmarks, visible focus rings, labels on every input, `alt` on every image, contrast ≥4.5:1 for body text. Keyboard-operable — no click-only handlers.
5. **Asset Weight**: images through `astro:assets` with explicit dimensions; SVG logo from `assets/logo/`. No 2MB stock heroes.

---

## 4. Security & Data Handling

1. **No Secrets in the Repo**: values live in `.env` (git-ignored); commit only `.env.example` with placeholders. `PUBLIC_*` variables are client-visible — never put secrets there.
2. **Server-Only Code**: mark privileged modules `server-only`; never import them into client components.
3. **Input Validation**: validate every form/endpoint payload with Zod at the boundary. Reject before touching storage.
4. **No `set:html` on user content**: it bypasses escaping. Prefer `{value}` interpolation; sanitize before any raw HTML.
5. **CSRF on Mutations**: non-GET endpoints validate origin/CSRF tokens.
6. **UU PDP 27/2022**: personal data (NIK, phone, address) goes only to approved storage, with retention rules from the FSD.

---

## 5. Specification Alignment

1. **Screen IDs**: every page traces to a `SCR-xx` in `DESIGN_SPEC.md`. No unmapped screens, no orphan components.
2. **5 UI States**: every data-driven view handles Default, Loading, Empty, Error, Success.
3. **Scope Discipline**: build only what the approved scope lists. New ideas go to the backlog — not into this sprint.
4. **Traceability**: each change maps to a `TODO.md` task ID; reference it in the task's evidence.

---

## 6. Anti-Slop Directives (BANNED PATTERNS)

1. **No decorative comments**: never restate the code, never leave `// TODO` stubs, never commit commented-out code.
2. **No silent failures**: empty `catch {}` blocks are banned. Surface a specific error to the user or rethrow with context.
3. **No placeholder content**: no lorem ipsum, no "Coming soon" pages, no dead buttons, no fake success toasts on failed requests.
4. **No hallucinated APIs**: verify every Astro integration, adapter, and helper exists in the installed version before using it.
5. **No duplicated logic**: extract shared behaviour; a copy-pasted component with a different name is a defect.

---

## 7. Verification Before Handover

- `astro check` — zero type errors.
- `astro build` — exit 0.
- The task's own `Verify` command — paste raw output as evidence.
- Report: task ID · files touched · raw output · blockers. Then 🛑 **END TURN**.

**Escalate, never guess silently**: if the spec is ambiguous, a business rule would break, or you cannot justify a file/route, stop and ask.
