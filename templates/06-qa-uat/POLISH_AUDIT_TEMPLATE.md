# Anti-Vibe-Code Polish Audit (`docs/qa/POLISH_AUDIT.md`)

> **Purpose**: Catch the 22 tells that make a shipped project read as AI-generated. Run this **on the deployed staging URL** (not in the IDE) before M07 sign-off and again on production in M10 PVT.
> **Why it exists**: Functional gates pass, but the product still *looks* vibe-coded. These are the highest-signal cheap checks.
> **Rule**: every row is PASS/FAIL with **evidence** (screenshot path, command output, or URL). "Looks fine" is not evidence.

**Project**: [name] · **Environment**: staging / production · **Auditor**: [name] · **Date**: [YYYY-MM-DD]

---

## A. First Impression (run on a real phone, not devtools)

| # | Tell | Check | Evidence | Status |
|:--:|:--|:--|:--|:--:|
| 1 | **Horizontal scroll on mobile** | `document.documentElement.scrollWidth > window.innerWidth` on every route at 375px. No sideways scroll on any page. | | [ ] |
| 2 | **No favicon** | `/favicon.ico` returns 200; tab shows brand mark, not the framework default or blank. | | [ ] |
| 3 | **No meta description** | `<meta name="description">` present, unique per route, 120–160 chars. | | [ ] |
| 4 | **No custom 404** | Visit `/this-page-does-not-exist`. Renders branded 404 with a route back — not the framework default. | | [ ] |
| 5 | **Huge uncompressed images** | No image > 300 KB; hero ≤ 500 KB. Served as WebP/AVIF, `width`/`height` set (no layout shift). | | [ ] |
| 6 | **Generic stock hero** | Hero is product-specific (real UI screenshot, domain illustration, or brand composition) — not a smiling-people stock photo. | | [ ] |
| 7 | **No loading states** | Every data-driven view shows a skeleton/spinner; no blank flash or frozen UI on slow 3G (throttle to Slow 4G). | | [ ] |
| 8 | **Random spacing** | All margins/paddings come from the spacing scale (4/8/12/16/24/32/48). No `mt-[13px]` one-offs. | | [ ] |
| 9 | **Default Tailwind blue** | No unstyled `blue-500`/`indigo-600` defaults. Primary = `[BRAND_HEX]` from `DESIGN.md`. | | [ ] |
| 10 | **Expired / wrong copyright** | Footer year = current year (or `© 2024–2026` range). No 2024-only, no placeholder `[Year]`. | | [ ] |

---

## B. Sharing, Navigation & Content

| # | Tell | Check | Evidence | Status |
|:--:|:--|:--|:--|:--:|
| 11 | **No preview image when shared** | Paste the URL into WhatsApp/Slack/X. Card shows `og:image` (1200×630), `og:title`, `og:description`. Validate via the platform debugger. | | [ ] |
| 12 | **Broken links** | Crawl the deployed site (`lychee`/`linkinator`/manual). Zero 404s in nav, footer, CTAs, legal pages. | | [ ] |
| 13 | **Default page title** | Every route has a specific `<title>` (`Dashboard — Acme`), not `Create Next App` / `Vite + React` / `localhost`. | | [ ] |
| 14 | **Placeholder text left in** | Zero occurrences of lorem ipsum, `Product A`, `[Your Company]`, `test@example.com`, `TODO`, `Coming soon`. | | [ ] |
| 15 | **Console errors** | DevTools console clean on every route: no red errors, no 404 asset requests, no React hydration/key warnings. | | [ ] |
| 16 | **No hover states** | Every button/link/card has a visible hover **and** `:focus-visible` state. Nothing feels inert. | | [ ] |
| 17 | **No empty states** | Every list/table has a designed empty state (icon + explanation + primary CTA) — not a bare "No data" or blank box. | | [ ] |
| 18 | **Three different fonts** | ≤ 2 font families (one UI + optionally one mono). No 3+ families, no unstyled system fallback mixed with brand font. | | [ ] |
| 19 | **Forms with no error messages** | Submit each form empty and with invalid input → inline, specific, ≥13px, `aria-describedby`-linked error text. No silent failure. | | [ ] |
| 20 | **Buttons that go nowhere** | Click every button. Zero `href="#"`, zero dead handlers, zero "coming soon" toasts on primary actions. | | [ ] |

---

## B2. Code-Quality Tells (grep the diff, not the browser)

| # | Tell | Check | Evidence | Status |
|:--:|:--|:--|:--|:--:|
| 21 | **AI-slop comments** | Every added comment earns its place: no `// Increment counter` narration, no `// TODO: implement later` stubs, no commented-out dead code. | | [ ] |
| 22 | **Race condition on shared state** | For each mutation of stock/balance/counter/booking/status: is it inside a transaction with a row lock, unique constraint, or compare-and-swap? Is the webhook idempotent (dedupes on provider event ID)? Double-click submit — does it create two records? | | [ ] |

---

## C. Automated Evidence (paste raw output)

```bash
# 1. Dead links + asset 404s
npx linkinator https://staging.example.com --recurse --skip "mailto:*"

# 2. Page weight / image budget
npx lighthouse https://staging.example.com --preset=desktop --only-categories=performance --quiet --chrome-flags="--headless"

# 3. Metadata + OG tags present
curl -s https://staging.example.com | grep -E "og:image|<title>|meta name=\"description\"|favicon"

# 4. AI-slop comments in the diff (narrating + stub comments; TOD[O] avoids this file's own lint)
git diff origin/main...HEAD -- '*.ts' '*.tsx' '*.js' '*.py' '*.go' '*.php' '*.rb' \
  | grep -E "^\+.*(//|#)\s*(Import |Get the |Set the |Increment |Initialize |Create a |This (function|method|is)|TOD[O]:? (implement|add)|Add your logic)" \
  && echo "⚠️ SLOP COMMENTS FOUND" || echo "✅ no narrating/stub comments"

# 5. Unprotected read-modify-write (transaction-aware: tracks BEGIN/COMMIT + FOR UPDATE state)
awk '/UPDATE .*(stock|balance|qty|quantity|count|version)/ { if (!lock) print FILENAME":"FNR": "$0 } \
     { if (/FOR UPDATE|version =|BEGIN/) lock=1; if (/COMMIT|ROLLBACK/) lock=0 }' \
     $(find . -name "*.sql" -o -name "*.ts" -o -name "*.py" -o -name "*.php" | grep -v node_modules)
# No output = every mutation sits inside a locked transaction. Any printed line = investigate.
```

**Lighthouse budget (record actual)**: Performance ≥ 85 · Best Practices ≥ 95 · SEO ≥ 95 · no console errors.
Actual: Perf [ ] · BP [ ] · SEO [ ]

---

## D. Verdict

- **Tells found**: [X] / 22
- **Blocking tells (must fix before sign-off)**: 1, 2, 4, 5, 7, 11, 13, 14, 15, 19, 20 (broken experience / leaked placeholder) **+ 22 (unprotected race condition — data corruption risk)**.
- **Non-blocking but logged**: 21 (slop comments) and the remaining polish rows.
- **Non-blocking polish (fix before M10 or log as post-launch)**: the remainder.

**Conclusion**: [ ] READY (0 blocking tells) · [ ] NOT READY ([X] blocking tells open)

**Signed off by**: [name] · **Date**: [YYYY-MM-DD]

---

> **Re-run requirement**: rows 1–22 MUST be re-verified on the **production domain** during M10 PVT. Staging-only verification is insufficient — CDN, minification, and env differences surface new tells (especially 5, 11, 15).
