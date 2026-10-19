# Accessibility Audit

> **Module**: M07 (QA & SIT) — run before M09 UAT; the same checklist applies to a Small project inside M06
> **Purpose**: Accessibility failures are cheap to fix in code and expensive to fix after launch (and legally expensive in a UU PDP / public-sector context). This is the audit, not the design guidance — the design rules live in `templates/02-design/COMPONENT_REQUIREMENTS_TEMPLATE.md`.
> **Output Location**: `docs/qa/ACCESSIBILITY_AUDIT.md`
> **Rule**: every row is PASS/FAIL with **evidence** (the exact snippet, the axe output, or a keyboard-test note). "It looks accessible" is not evidence.
> **Source**: Adapted from `ibelick/ui-skills` (MIT) — the 9-category priority model.

**Project**: [name] · **Environment**: staging / production · **Auditor**: [name] · **Date**: [YYYY-MM-DD]

---

## Priority order

| Priority | Category | Impact |
| :--: | :--- | :--- |
| 1 | Accessible names | **critical** |
| 2 | Keyboard access | **critical** |
| 3 | Focus & dialogs | **critical** |
| 4 | Semantics | high |
| 5 | Forms & errors | high |
| 6 | Announcements | medium-high |
| 7 | Contrast & states | medium |
| 8 | Media & motion | low-medium |
| 9 | Tool boundaries | **critical** |

---

## 1. Accessible names (critical)

| # | Check | Evidence | Status |
| :-: | :--- | :--- | :--: |
| 1.1 | Every interactive control has an accessible name | | [ ] |
| 1.2 | Icon-only buttons have `aria-label` or `aria-labelledby` | | [ ] |
| 1.3 | Every `input`, `select`, and `textarea` is labelled | | [ ] |
| 1.4 | Links have meaningful text (no "click here", no bare URL) | | [ ] |
| 1.5 | Decorative icons are `aria-hidden="true"` | | [ ] |

## 2. Keyboard access (critical)

| # | Check | Evidence | Status |
| :-: | :--- | :--- | :--: |
| 2.1 | No `div`/`span` used as a button without full keyboard support | | [ ] |
| 2.2 | Every interactive element is reachable by `Tab` | | [ ] |
| 2.3 | Focus is visible for keyboard users | | [ ] |
| 2.4 | No `tabindex` greater than `0` | | [ ] |
| 2.5 | `Escape` closes dialogs and overlays where applicable | | [ ] |

## 3. Focus & dialogs (critical)

| # | Check | Evidence | Status |
| :-: | :--- | :--- | :--: |
| 3.1 | Modals trap focus while open | | [ ] |
| 3.2 | Focus is restored to the trigger on close | | [ ] |
| 3.3 | Initial focus is set inside the dialog | | [ ] |
| 3.4 | Opening a dialog does not scroll the page unexpectedly | | [ ] |

## 4. Semantics (high)

| # | Check | Evidence | Status |
| :-: | :--- | :--- | :--: |
| 4.1 | Native elements (`button`, `a`, `input`) preferred over role hacks | | [ ] |
| 4.2 | If a `role` is used, its required ARIA attributes are present | | [ ] |
| 4.3 | Lists use `ul`/`ol` with `li` | | [ ] |
| 4.4 | Heading levels are not skipped | | [ ] |
| 4.5 | Tables use `th` for headers where applicable | | [ ] |
| 4.6 | **Exactly one `h1` per page**, and it is the page's real subject | | [ ] |
| 4.7 | **Headings are not used for visual size.** A section title that is small text is still a heading; a big decorative number is not. Markup follows outline, CSS follows appearance. | | [ ] |

**4.6/4.7 are measurable, so measure them.** One command per route:

```bash
curl -s "$URL" | grep -o '<h[1-6]' | sort | uniq -c
```

Any page reporting `25 h1` has used the top heading level as a font-size utility. That is a defect even when the page looks correct, because a screen reader's outline becomes a list of 25 equal topics. The fix is one `h1` for the page subject and `h2`/`h3` for sections, restyled with classes. Static templates are the usual offender, because a component copied six times carries its `h1` with it.

## 5. Forms & errors (high)

| # | Check | Evidence | Status |
| :-: | :--- | :--- | :--: |
| 5.1 | Errors are linked to fields with `aria-describedby` | | [ ] |
| 5.2 | Required fields are announced | | [ ] |
| 5.3 | Invalid fields set `aria-invalid="true"` | | [ ] |
| 5.4 | Helper text is associated with its input | | [ ] |
| 5.5 | A disabled submit action explains **why** it is disabled | | [ ] |

## 6. Announcements (medium-high)

| # | Check | Evidence | Status |
| :-: | :--- | :--- | :--: |
| 6.1 | Critical form errors use `aria-live` | | [ ] |
| 6.2 | Loading states use `aria-busy` or status text | | [ ] |
| 6.3 | Toasts are **not** the only way critical information is conveyed | | [ ] |
| 6.4 | Expandable controls use `aria-expanded` and `aria-controls` | | [ ] |

## 7. Contrast & states (medium)

| # | Check | Evidence | Status |
| :-: | :--- | :--- | :--: |
| 7.1 | Text and icons meet the contrast targets (4.5:1 text / 3:1 UI) | | [ ] |
| 7.2 | Hover-only interactions have keyboard equivalents | | [ ] |
| 7.3 | Disabled states do not rely on colour alone | | [ ] |
| 7.4 | No focus outline is removed without a visible replacement | | [ ] |

## 8. Media & motion (low-medium)

| # | Check | Evidence | Status |
| :-: | :--- | :--- | :--: |
| 8.1 | Images have correct alt text (meaningful, or empty when decorative) | | [ ] |
| 8.2 | Videos with speech provide captions where relevant | | [ ] |
| 8.3 | `prefers-reduced-motion` is respected for non-essential motion | | [ ] |
| 8.4 | No media autoplays with sound | | [ ] |

## 9. Tool boundaries (critical)

| # | Check | Evidence | Status |
| :-: | :--- | :--- | :--: |
| 9.1 | Minimal, targeted changes — no unrelated refactoring | | [ ] |
| 9.2 | No ARIA added where native semantics already solve the problem | | [ ] |
| 9.3 | No UI-library migration unless requested | | [ ] |

---

## Automated evidence (paste raw output)

```bash
# 1. axe-core via Playwright (install once: npm i -D @axe-core/playwright)
#    Run against each route at 375px and 1440px.
npx playwright test a11y.spec.ts --reporter=list

# 2. Lighthouse accessibility category
npx lighthouse https://staging.example.com --only-categories=accessibility --quiet \
  --chrome-flags="--headless" --output=json --output-path=/tmp/a11y.json
node -e "const r=require('/tmp/a11y.json');console.log('score',r.categories.accessibility.score)"

# 3. Keyboard walk (manual, 5 minutes — do this by hand, not by script)
#    Tab through the primary flow: can you reach and operate every control?
#    Shift+Tab back: does focus return sensibly? Escape: does it close?
```

**Manual keyboard pass is not optional.** Automated tools catch roughly a third of real issues; the rest need a human with a keyboard.

---

## Verdict

- **Blocking failures**: [list — any critical category]
- **WCAG 2.2 AA claim**: [ ] supportable · [ ] not supportable — do not claim conformance without the manual pass
- **Ready for UAT**: [ ] yes · [ ] no
- **Notes / deliberate exceptions**: [e.g. "third-party embedded widget; vendor owns its a11y"]
