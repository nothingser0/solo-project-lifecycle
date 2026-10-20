# Hydration-Free Rendering (Server-First UI)

> **Applies to**: every SSR framework in the supported matrix — Next.js (App Router), Nuxt, SvelteKit, Remix/React Router, Astro, MERN+SSR.
> **Rule**: if the UI can be correct **without hydration**, it must be built that way. Hydration is an exception you justify per leaf component, not the default.
> **Load when**: Module 06 (build), Module 07 Step 7 (polish audit), or whenever a hydration warning appears.

---

## 1. Why this exists

A hydration error is not a warning to silence — it is evidence that the server produced one tree and the client produced another. React throws away the server HTML for that subtree and re-renders it client-side; the user sees a flash, a form can lose what they typed, and the "SSR" you are paying for disappears.

The classic sources are all *non-deterministic render output*:

| Source | Why it breaks | Example |
| :--- | :--- | :--- |
| Wall-clock / random | Server and client run at different times with different seeds | `Date.now()`, `new Date()`, `Math.random()`, `crypto.randomUUID()` |
| Locale / timezone formatting | The server's ICU locale, TZ, and even Node/browser ICU builds differ | `toLocaleString()`, `toLocaleDateString()`, `Intl.DateTimeFormat` without explicit locale + timeZone |
| Browser-only state | `localStorage`/`sessionStorage`/`matchMedia`/`window` do not exist on the server | reading a theme or a cart count during render |
| Environment branching | `process.env` vs `import.meta.env`, or `typeof window` checks in JSX | rendering "in dev" banners, or a different class list |
| Third-party script DOM injection | Analytics/chat widgets mutate the DOM before React hydrates | `<script>` injecting badges into a hydrated container |

Formatting is the one people miss most: `(1234.5).toLocaleString()` returns `1,234.5` in one ICU build and `1.234,5` in another. Money and dates in an Indonesian app are the highest-risk case.

---

## 2. Decision ladder (apply in order)

Work down this ladder and stop at the first rung that works.

**1. Render it on the server and pass it down as a prop.**
The default. Fetch in a Server Component / loader / `+page.server.ts`, format where the timezone is known, ship plain values into the view. No client JS needed at all.

**2. Keep the component server-rendered and make the *value* deterministic.**
Give every formatter an explicit locale and timezone instead of relying on the host:

```ts
// ✅ deterministic on both sides
const nf = new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', minimumFractionDigits: 0 });
const df = new Intl.DateTimeFormat('id-ID', { dateStyle: 'long', timeZone: 'Asia/Jakarta' });
```

**3. If only a small island needs interactivity, isolate it to a leaf.**
A counter, a modal, a combobox. The page shell stays static; `'use client'` (or `client:visible`) covers the smallest possible subtree.

**4. If the value genuinely cannot exist on the server, read it *after* mount.**
Theme, device capability, or a value from `localStorage`. Render an explicit default first, then swap:

```tsx
const [theme, setTheme] = useState<'light' | 'dark'>('light'); // matches server output
useEffect(() => setTheme(localStorage.getItem('theme') === 'dark' ? 'dark' : 'light'), []);
```

**5. If the block must never be server-rendered, opt that block out.**
`next/dynamic` with `{ ssr: false }`, or a client-only island. The block is then honest about what it is: a client component, not a broken server render.

**6. `suppressHydrationWarning` — last resort, single node only.**
Legitimate for exactly one unknowable text node (a clock, a "last updated" stamp) where the mismatch is expected and cosmetic. It is **never** a fix for a subtree, and using it to silence an error you did not diagnose is prohibited.

---

## 3. Alternatives to hydration, by need

| Need | Hydration-free approach |
| :--- | :--- |
| Sorting/filtering/search | URL search params + a server round-trip (`?sort=date&page=2`). Works with JS disabled, shareable, and no client state to desync. |
| Pagination | Query param + server render. |
| Forms | Native `<form method="post">` → server action / endpoint. Progressive enhancement first; add client niceties on top. |
| Date & currency display | Format on the server with explicit locale + timeZone (rung 2). |
| Theme choice | Read after mount (rung 4) **or** read the cookie on the server — the cookie is available to the server, so prefer that. |
| Relative time ("3 minutes ago") | Render the absolute timestamp on the server; localise after mount, or pass the server's `now` down. |
| User-specific greeting | Server session read — never `localStorage`. |
| Analytics/consent banner | Inject via `next/script` with an explicit strategy, or render a placeholder slot the script fills. |
| Charts / editors / canvases | Client-only island (rung 5) behind a sized placeholder — no layout shift, no mismatch. |

**Anti-pattern to delete on sight**: rendering `localStorage.getItem(...)` or `Date.now()` directly in JSX "because it works locally". It works locally *because the client renders first in dev*.

---

## 4. Per-stack notes

- **Next.js (App Router)**: Server Components by default. `'use client'` marks a boundary *and everything below it* — put the directive on the leaf, not the page. `next/dynamic` with `{ ssr: false }` requires a client boundary. Cookies/headers are server-readable: use `await cookies()` instead of `localStorage` for theme/session-derived UI.
- **Nuxt**: `useAsyncData`/`useFetch` run on both sides and can desync; pass a stable `key` and format server-side. `ClientOnly` is the per-block opt-out. `import.meta.server`/`import.meta.client` guards beat `typeof window`.
- **SvelteKit**: everything is server-rendered then hydrated. Read browser storage in `onMount`, never in the component body or `$derived`. `browser` from `$app/environment` is the feature check.
- **Remix / React Router**: loaders are server-only — put the formatting there. `useEffect` for anything DOM-only; `<Form>` progressive enhancement keeps the page working before hydration completes.
- **Astro**: no hydration unless you ask for it. Use `client:visible` over `client:load`, and `is:inline` scripts for third-party tags. A hydrated island that only displays text should not be an island at all.
- **MERN + SSR**: the server bundle must not import browser globals; guard with an environment check and keep the first render identical to the server's — the same five rules apply.

---

## 5. Verification

Run before declaring a UI task done (the checks are in `VERIFY_LOCAL.md` §4C):

1. Open DevTools Console, walk every route — zero hydration warnings, zero "text content did not match", zero "extra attributes from server".
2. Throttle to Slow 4G and reload: no layout flash, no content swap, no lost form input.
3. Disable JavaScript on the primary flows (login, list, detail). Server-rendered content must still be visible and forms must still be submittable when progressive enhancement is in place.
4. Grep the diff for `Date.now(`, `Math.random(`, `localStorage`, `toLocale` in files that render server-side.
5. Confirm every formatter call site passes an explicit locale and timeZone.

**Fix the source, not the symptom.** `suppressHydrationWarning` changes nothing about what the user experienced; it only hides the report.
