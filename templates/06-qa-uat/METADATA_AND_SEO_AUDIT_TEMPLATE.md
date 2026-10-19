# Metadata & SEO Audit

> **Module**: M07 (QA & SIT) — run before M09 UAT; re-check on the production domain in M10 PVT
> **Purpose**: Metadata is the part of the product users see *before* they arrive. A wrong canonical, a duplicate title, or a missing `og:image` is invisible in local dev and expensive in production.
> **Output Location**: `docs/qa/METADATA_AUDIT.md`
> **Rule**: every row is PASS/FAIL with **evidence** (the exact tag, the debugger output, or a screenshot). "Looks fine" is not evidence.
> **Source**: Adapted from `ibelick/ui-skills` (MIT) — the 8-category priority model.

**Project**: [name] · **Environment**: staging / production · **Auditor**: [name] · **Date**: [YYYY-MM-DD]

---

## Priority order

Fix in this order. A critical failure invalidates the work below it.

| Priority | Category | Impact |
| :--: | :--- | :--- |
| 1 | Correctness & duplication | **critical** |
| 2 | Title & description | high |
| 3 | Canonical & indexing | high |
| 4 | Social cards | high |
| 5 | Icons & manifest | medium |
| 6 | Structured data | medium |
| 7 | Locale & alternates | low-medium |
| 8 | Tool boundaries | **critical** |

---

## 1. Correctness & duplication (critical)

| # | Check | Evidence | Status |
| :-: | :--- | :--- | :--: |
| 1.1 | Metadata is defined in **one place per page** — no competing systems (e.g. `next/head` + the framework's metadata API) | | [ ] |
| 1.2 | No duplicate `<title>`, `<meta name="description">`, `<link rel="canonical">`, or robots tags in the rendered head | | [ ] |
| 1.3 | Metadata is deterministic — no random values, timestamps, or request-dependent strings in a static page | | [ ] |
| 1.4 | Any dynamic/user-generated string is escaped and sanitized | | [ ] |
| 1.5 | Every route has safe defaults for title and description (a 404 page included) | | [ ] |

## 2. Title & description (high)

| # | Check | Evidence | Status |
| :-: | :--- | :--- | :--: |
| 2.1 | Every page has a non-empty title | | [ ] |
| 2.2 | Title format is consistent across the site (e.g. `Page — Brand`) | | [ ] |
| 2.3 | Titles are short and readable; no keyword stuffing | | [ ] |
| 2.4 | Shareable/searchable pages have a meta description | | [ ] |
| 2.5 | Descriptions are plain text — no markdown, no quote spam | | [ ] |

## 3. Canonical & indexing (high)

| # | Check | Evidence | Status |
| :-: | :--- | :--- | :--: |
| 3.1 | Canonical points to the **preferred** URL for the page (trailing slash, host, and protocol consistent) | | [ ] |
| 3.2 | `noindex` is used only for private, duplicate, or non-public pages | | [ ] |
| 3.3 | Robots meta matches actual access intent | | [ ] |
| 3.4 | Preview/staging deployments are `noindex` by default | | [ ] |
| 3.5 | Paginated pages have correct canonical behaviour (self-canonical, not all pointing at page 1) | | [ ] |

## 4. Social cards (high)

| # | Check | Evidence | Status |
| :-: | :--- | :--- | :--: |
| 4.1 | Shareable pages set `og:title`, `og:description`, `og:image` | | [ ] |
| 4.2 | OG and Twitter image URLs are **absolute**, not relative | | [ ] |
| 4.3 | Image dimensions are correct and the aspect ratio is stable (1200×630 for the large card) | | [ ] |
| 4.4 | `og:url` matches the canonical URL exactly | | [ ] |
| 4.5 | `og:type` is sensible (`website` or `article`) | | [ ] |
| 4.6 | `twitter:card` is set — `summary_large_image` by default | | [ ] |
| 4.7 | **Rendered on a real URL**, not localhost — paste into the platform debugger / a chat client | | [ ] |

## 5. Icons & manifest (medium)

| # | Check | Evidence | Status |
| :-: | :--- | :--- | :--: |
| 5.1 | At least one favicon that works across browsers | | [ ] |
| 5.2 | `apple-touch-icon` present when relevant | | [ ] |
| 5.3 | Web manifest is valid JSON and referenced | | [ ] |
| 5.4 | `theme-color` is intentional (matches the actual UI chrome) | | [ ] |
| 5.5 | Icon paths are stable and cacheable (no hashed filenames for the favicon) | | [ ] |

## 6. Structured data (medium)

| # | Check | Evidence | Status |
| :-: | :--- | :--- | :--: |
| 6.1 | JSON-LD is added **only** where it maps to real page content | | [ ] |
| 6.2 | JSON-LD is valid and reflects what is actually rendered | | [ ] |
| 6.3 | No invented ratings, reviews, prices, or organization details | | [ ] |
| 6.4 | One structured-data block per page unless a second type is genuinely required | | [ ] |

> **Evidence rule**: inventing structured data to win a rich result is the same violation as inventing a testimonial. If the page does not render it, it does not go in the markup.

## 7. Locale & alternates (low-medium)

| # | Check | Evidence | Status |
| :-: | :--- | :--- | :--: |
| 7.1 | `<html lang>` is correct | | [ ] |
| 7.2 | `og:locale` is set when localization exists | | [ ] |
| 7.3 | `hreflang` alternates exist **only** for pages that truly exist | | [ ] |
| 7.4 | Localized pages canonicalize correctly per locale | | [ ] |

## 8. Tool boundaries (critical)

| # | Check | Evidence | Status |
| :-: | :--- | :--- | :--: |
| 8.1 | Minimal diff — metadata only, no unrelated refactoring | | [ ] |
| 8.2 | No framework or SEO library migration unless explicitly requested | | [ ] |
| 8.3 | The project's existing metadata pattern is followed (`next/metadata`, `react-helmet`, manual head, …) | | [ ] |

---

## Automated evidence (paste raw output)

```bash
# Rendered head, per route
curl -s https://staging.example.com/ | grep -E "<title>|name=\"description\"|rel=\"canonical\"|og:|twitter:|robots"

# Duplicate-tag check (should print each tag at most once)
curl -s https://staging.example.com/ \
  | grep -oE "<title>|<meta name=\"description\"|<link rel=\"canonical\"" | sort | uniq -c

# Social card debuggers (open manually — they render what a crawler sees)
#   Facebook: https://developers.facebook.com/tools/debug/
#   LinkedIn: https://www.linkedin.com/post-inspector/
#   X:        https://cards-dev.twitter.com/validator
```

---

## Verdict

- **Blocking failures**: [list — any critical category, or any high category that breaks sharing/indexing]
- **Ready for UAT**: [ ] yes · [ ] no
- **Notes / deliberate exceptions**: [e.g. "staging is noindex by design; production verified separately in M10"]
