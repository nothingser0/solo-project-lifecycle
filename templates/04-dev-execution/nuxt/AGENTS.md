# AI Agent Guidelines - Nuxt Project

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

- **Nuxt**: https://nuxt.com/docs
- **Vue 3**: https://vuejs.org/guide/introduction.html
- **Nitro (server engine)**: https://nitro.build/guide
- **Pinia**: https://pinia.vuejs.org/

**Why**: Nuxt 3/4 changed auto-imports, `useFetch`/`useAsyncData` semantics, Nitro presets, and module APIs. Verify against the installed version, not memory.

---

## 1. Absolute Agent Safety Directives (NON-NEGOTIABLE)

1. **NO Destructive Git Operations**: `git push --force` and branch rewrites are **STRICTLY PROHIBITED**.
2. **NO Destructive Database Operations**: never run `DROP TABLE`, `TRUNCATE`, or destructive Prisma/ORM migration resets against staging/production.
3. **Spec Document Integrity**: documents marked `[FROZEN]` / `[APPROVED]` (`PRD.md`, `FSD.md`, `DESIGN_SPEC.md`, `DESIGN.md`, `SCOPE_STATEMENT.md`) are the immutable source of truth. Never edit them to make code fit — raise a Change Request.
4. **Human Commits Only**: AI agents must never run `git commit` or `git push`.
5. **Mandatory Specs Pre-Read**: read `AGENTS.md`, `CONTEXT.md`, `DESIGN.md`, `TODO.md`, and the FSD/`PROJECT_LITE.md` before writing code.

---

## 2. Nuxt & TypeScript Standards

1. **Type Safety**: TypeScript strict mode. Typed props with `defineProps<Props>()`, typed emits with `defineEmits<…>()`. No `any`, no `@ts-ignore`, no `as unknown as`.
2. **Composition API Only**: `<script setup lang="ts">`. Options API is not used in new code.
3. **Auto-imports Are Not a Guess**: rely on Nuxt auto-imports only for documented composables/components. Import everything else explicitly — never invent a composable name.
4. **Data Fetching**: `useFetch` for URL-based fetches, `useAsyncData` when the key or handler is custom. Always handle `pending`, `error`, and empty results — a bare `data.value.map()` hides all three.
5. **Server Routes**: privileged logic lives in `server/api/**` or `server/utils/**`. Never import server-only modules into client components; guard with `import.meta.server` checks for shared code.
6. **State**: Pinia stores for cross-page state; `useState` for lightweight SSR-safe shared state. Never keep auth/session in a plain module-level variable.
7. **No Layout Drift**: one `layouts/default.vue`; never duplicate head/meta blocks per page — use `useHead`/`useSeoMeta`.
8. **Hydration-Free Rendering**: the same component runs on server and client — its markup must not depend on where it runs. Never read `localStorage`/`window`/`matchMedia` in the component body or a `computed` (use `onMounted`, or a server-readable cookie). Never render `Date.now()`, `new Date()`, `Math.random()`, or bare `toLocaleString()`/`toLocaleDateString()`; format with an explicit locale **and** `timeZone` (`Intl.DateTimeFormat('id-ID', { timeZone: 'Asia/Jakarta' })`) or pass the server value down as a prop. `useAsyncData`/`useFetch` need a stable `key` so both sides cache the same payload. Use `<ClientOnly>` for a genuinely client-only block — not to hide a mismatch. Full ladder: `references/technical/HYDRATION_FREE_RENDERING.md`.

---

## 3. Styling & Design Tokens

1. **Tokens from `DESIGN.md`**: colors, spacing, radii, and typography come from the frozen design tokens (via `tailwind.config.*` or CSS variables). Never introduce an off-palette hex or arbitrary spacing value.
2. **No Inline-Style Bypass**: follow the configured styling layer; do not patch around it with `:style="{ … }"`.
3. **Accessibility (WCAG 2.2 AA)**: semantic landmarks, visible focus rings, labels on every input, `alt` on every image, contrast ≥4.5:1 for body text. Keyboard-operable — no click-only handlers.
4. **Asset Weight**: `@nuxt/image` with explicit dimensions; SVG logo from `assets/logo/`. No 2MB stock heroes.

---

## 4. Security & Data Handling

1. **No Secrets in the Repo**: server secrets in `.env` (git-ignored); commit only `.env.example`. `runtimeConfig` — only `public.*` keys reach the client. Never put a secret under `runtimeConfig.public`.
2. **Server-Only Code**: use `server/utils` + `import.meta.server` guards. Never expose an ORM client or service-role key to the browser.
3. **Input Validation**: validate every server route payload with Zod (or the project's schema layer) at the boundary. Reject before touching storage.
4. **No `v-html` on user content**: it bypasses escaping. Prefer `{{ }}` interpolation; sanitize before any raw HTML.
5. **CSRF on Mutations**: non-GET endpoints validate origin/CSRF tokens.
6. **UU PDP 27/2022**: personal data (NIK, phone, address) goes only to approved storage, with retention rules from the FSD.

---

## 5. Specification Alignment

1. **Screen IDs**: every page traces to a `SCR-xx` in `DESIGN_SPEC.md`. No unmapped pages, no orphan components.
2. **5 UI States**: every data-driven view handles Default, Loading, Empty, Error, Success.
3. **Scope Discipline**: build only what the approved scope lists. New ideas go to the backlog — not into this sprint.
4. **Traceability**: each change maps to a `TODO.md` task ID; reference it in the task's evidence.

---

## 6. Anti-Slop Directives (BANNED PATTERNS)

1. **No decorative comments**: never restate the code, never leave `// TODO` stubs, never commit commented-out code.
2. **No silent failures**: empty `catch {}` blocks are banned. Surface a specific error to the user or rethrow with context.
3. **No placeholder content**: no lorem ipsum, no "Coming soon" pages, no dead buttons, no fake success toasts on failed requests.
4. **No hallucinated APIs/composables**: verify every Nuxt composable, module, and Nitro preset exists in the installed version before using it.
5. **No duplicated logic**: extract shared behaviour; a copy-pasted component with a different name is a defect.

---

## 7. Verification Before Handover

- `nuxi typecheck` — zero type errors.
- `nuxi build` — exit 0.
- The task's own `Verify` command — paste raw output as evidence.
- Report: task ID · files touched · raw output · blockers. Then 🛑 **END TURN**.

**Escalate, never guess silently**: if the spec is ambiguous, a business rule would break, or you cannot justify a file/route, stop and ask.
