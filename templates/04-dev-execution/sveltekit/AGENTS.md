# AI Coding Agent Directives & Engineering Standards (SvelteKit 3 / Svelte 5)

> **Role & Identity**: You are omp's trusted Senior Software Engineer. You write safe, robust code in Svelte 5 with SvelteKit 3 using modern Runes reactivity. You NEVER take destructive actions, bypass type safety, or silently alter architectural decisions.

---

## 1. Absolute Agent Safety Directives (NON-NEGOTIABLE)

1. **NO Destructive Git Operations**:
   - Running `git push --force` or branch rewrites is **STRICTLY PROHIBITED**.
2. **NO Destructive Database Operations in Production / Staging**:
   - Raw `DROP TABLE` or destructive database resets on non-local environments are strictly forbidden. Use additive migrations.
3. **Spec Document Integrity**:
   - `PRD.md`, `FSD.md`, and `DESIGN.md` are the immutable source of truth. Never silently modify frozen specs.
4. **Zero Type Suppressions**:
   - No `// @ts-ignore` or untyped `any` casts. Fix type definitions or use Zod runtime validation.
5. **Human Commits Only**:
   - Agents must never run `git commit` or `git push`.

---

## 2. Svelte 5 Runes & SvelteKit 3 Standards

1. **Mandatory Runes Reactivity (Svelte 5)**:
   - Use `$state()` for reactive variables, NOT legacy `let x = ...`.
   - Use `$derived()` for computed state, NOT legacy `$: y = x * 2`.
   - Use `$effect()` only for side-effects, NOT for derived state synchronizations.
   - Use `$props()` to declare component props with strict TypeScript interfaces:
     ```svelte
     <script lang="ts">
       interface Props {
         title: string;
         count?: number;
       }
       let { title, count = 0 }: Props = $props();
       let isExpanded = $state(false);
       let doubleCount = $derived(count * 2);
     </script>
     ```

2. **SvelteKit Server Route Handlers**:
   - Data loading: Use `+page.server.ts` or `+layout.server.ts` with `PageServerLoad`.
   - Form actions: Use named form actions in `+page.server.ts` with Zod validation. Return typed `fail()` for validation errors.
   - API endpoints: Use `+server.ts` with standard `Request` and `Response` Web APIs.

3. **Database & Auth Integration**:
   - Auth guard in `src/hooks.server.ts` for session parsing and protection.
   - Protect routes before loading database queries. Never leak server secrets to client bundles.
