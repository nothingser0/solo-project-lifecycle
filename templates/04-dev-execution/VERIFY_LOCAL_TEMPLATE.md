# Local Verification & Smoke Test Checklist

> Self-verification sheet before a solo developer publishes code to the staging repository or submits a release milestone.

---

## 1. Verification Metadata
- **Project Name**: [Application Name]
- **Latest Commit SHA**: `[git rev-parse --short HEAD]`
- **Working Tree Dirty**: [yes/no — if yes, the SHA alone does not identify what you tested]
- **Tester / Solo Engineer**: [Your Name]
- **Verification Date**: [YYYY-MM-DD]
- **Target Status**: [Ready for Staging QA / Incomplete]

### 1.1 Build identity — can you re-create exactly what you tested?

A commit SHA identifies the *source*, not the *artifact*. Record what actually ran.

| Field | Value | Why it matters |
| :--- | :--- | :--- |
| Source revision | `[SHA]` | The code |
| Uncommitted changes at test time | `[none / list]` | A dirty tree means the SHA is a lie |
| Build timestamp | `[YYYY-MM-DD HH:MM TZ]` | Distinguishes rebuilds of the same SHA |
| Artifact hash | `[sha256sum dist/app.js]` | The bytes you actually exercised |
| Runtime / platform | `[Node 22.13 / Windows 11]` | Behaviour differs across runtimes |
| Launch command | `[npm run start:staging]` | Reproducible start state |
| Seed / test data | `[seed.sql, 12 records]` | Results depend on starting state |

**If identity cannot be pinned** (a moving deployment, a CDN that updates, no build hash), say so explicitly and **do not claim exact-version acceptance**. Report which build is currently available separately from the last build you independently verified — these differ more often than teams assume.

---

## 2. Compilation & Linter Verification (Build Sanity)

| Test Command | Success Criteria | Self-Test Result | Notes |
| :--- | :--- | :---: | :--- |
| `npm run type-check` | TypeScript compiles without errors (`exit 0`) | [ ] PASS | Free of type errors |
| `npm run lint` | Linter clean without critical warnings | [ ] PASS | Code adheres to style rules |
| `npm run build` | Frontend & backend bundle built successfully | [ ] PASS | Output ready for release |
| `npm run test:smoke` | Core user loop assertions pass | [ ] PASS | Smoke tests clean |

---

## 3. API Endpoint Matrix Verification (Per FSD)

| Endpoint | Method | Test Scenario | Expected Status Code | Test Result |
| :--- | :---: | :--- | :---: | :---: |
| `/api/v1/auth/login` | `POST` | Valid credentials → HttpOnly cookie / token set | `200 OK` | [ ] PASS |
| `/api/v1/auth/login` | `POST` | Invalid credentials → Specific error message | `401 Unauthorized` | [ ] PASS |
| `/api/v1/[resource]` | `POST` | Valid payload + new Idempotency key | `201 Created` | [ ] PASS |
| `/api/v1/[resource]` | `POST` | Duplicate idempotency key re-sent → Cached response | `200 OK / 409` | [ ] PASS |
| `/api/v1/[resource]/:id` | `GET` | Fetch resource data → Scoped by tenant | `200 OK` | [ ] PASS |
| `/api/v1/[action]` | `POST` | Atomic mutation → Status updated | `200 OK` | [ ] PASS |

---

## 4. UI Screen Verification (Per Interactive Prototype & 5 States)

### 4A. Design Compliance (Per DESIGN.md Tokens)

**Check each screen against DESIGN.md specifications:**

| Screen | Brand Color Used | Typography Scale | Shadow Style | Border Style | Result |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Dashboard / Home** | Primary (not neutral) | Per DESIGN.md section 3 | Flat (shadow-sm) | 1px border | [ ] PASS |
| **Login / Auth** | Primary brand | Correct weights | Flat | 1px border | [ ] PASS |
| **[Primary Screen]** | Primary brand | Correct | Flat | 1px border | [ ] PASS |

**Design Token Verification:**
- [ ] Primary brand color applied to CTA buttons (not `bg-neutral-100`)
- [ ] Typography matches DESIGN.md scale (specific font weights/sizes)
- [ ] Shadow style consistent (flat `shadow-sm border` vs heavy `shadow-lg`)
- [ ] Border width matches spec (typically 1px `border-neutral-200`)
- [ ] Spacing follows Tailwind scale from DESIGN.md

### 4B. 5-State Matrix (Per SITEMAP Screens)

| Page Name | Default State | Skeleton Loader | Empty State | Inline Error | Success Toast |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Dashboard / Overview**| [ ] PASS | [ ] PASS | [ ] PASS | [ ] PASS | [ ] PASS |
| **Primary Resource Form**| [ ] PASS | [ ] PASS | N/A | [ ] PASS | [ ] PASS |
| **[Feature Screen]** | [ ] PASS | [ ] PASS | N/A | [ ] PASS | [ ] PASS |

### 4C. Hydration-Free Rendering Check (SSR frameworks)

> Policy: **if the UI can be correct without hydration, it must be built that way.** Detailed ladder:
> `references/technical/HYDRATION_FREE_RENDERING.md`. This section records the *evidence*, not an intention.

**Run dev server and check browser console:**

```bash
npm run dev
# Open http://localhost:3000 in browser
# Open DevTools Console (F12)
# Navigate through all screens
```

**Hydration Errors to Check:**
- [ ] No "Hydration failed" warnings in console
- [ ] No "Text content did not match" errors
- [ ] No "Extra attributes from server" warnings
- [ ] Zero `suppressHydrationWarning` attributes added to silence a mismatch (grep the diff)

**Non-deterministic render sources (must not run during the initial render):**
- ❌ `Date.now()`, `new Date()`, `performance.now()` in render
- ❌ `Math.random()`, `crypto.randomUUID()` in render
- ❌ `toLocaleString()` / `toLocaleDateString()` / `Intl.*Format` without an explicit `locale` **and** `timeZone`
- ❌ `localStorage` / `sessionStorage` / `window` / `matchMedia` read in render or in a `$derived`/`useMemo`
- ❌ `typeof window` branches that change markup
- ❌ Third-party scripts (analytics, chat widgets) injecting DOM before hydration

**Client-component exemption register** (required — an unlisted `'use client'` island is an unexplained one):

| File (leaf component) | Browser-only need | Why no server-side alternative | Evidence |
| :--- | :--- | :--- | :--- |
| `[components/…-toggle.tsx]` | `[localStorage theme read]` | `[theme cookie not readable in this route]` | `[console clean, 375px + desktop]` |

**Verification evidence (paste raw):**
- [ ] Console capture across all routes: `[path or pasted output]`
- [ ] JS-disabled pass on the primary flows (login, list, detail): `[what still renders/submits]`
- [ ] Grep for render-time non-determinism: `grep -rnE "Date\.now\(|Math\.random\(|toLocale(String|DateString)" [src/app]` → `[result]`

**Resolution order** (do not skip to the last one):
1. Server-render the value and pass it down as a prop.
2. Make the formatter deterministic (explicit `locale` + `timeZone`).
3. Isolate interactivity to the smallest leaf component.
4. Read the value after mount (`useEffect`) with an explicit default render.
5. Opt the block out of SSR (`next/dynamic` `{ ssr: false }`, a client-only island).
6. `suppressHydrationWarning` — one known-unknowable node only, never a subtree.

---

## 5. Automated Security & Concurrency Verification

### 5.1 Automated RLS Security Test (`tests/db/rls.test.ts`)
| Test Scenario | Command | Expected Result | Audit Status |
| :--- | :--- | :--- | :---: |
| Anonymous query isolation | `pnpm test:security` | 0 rows returned on protected tables | [ ] PASS |
| Role column masking | `pnpm test:security` | Sensitive cost fields omitted for staff | [ ] PASS |
| Multi-tenant IDOR attack | `pnpm test:security` | Org A cannot query Org B records (0 rows) | [ ] PASS |

### 5.2 Automated Concurrency & Deadlock Test (`tests/db/concurrency.test.ts`)
| Test Scenario | Command | Expected Result | Audit Status |
| :--- | :--- | :--- | :---: |
| 20 parallel transactions | `pnpm test:concurrency` | Zero `40P01` deadlock errors | [ ] PASS |
| Aggregate reconciliation | `pnpm test:concurrency` | Inventory/balance aggregate equals movement ledger sum | [ ] PASS |

### 5.3 Critical Security Checks (Security Sanity)
- [ ] **Encrypted Storage**: Sensitive files in S3/R2 are confirmed binary encrypted at rest.
- [ ] **Presigned URLs**: Download links expire automatically and return `403 Forbidden` after 15 minutes.
- [ ] **Password Protection**: Password hashes in database confirmed using Argon2id / bcrypt (≥ 12 rounds).
- [ ] **Rate Limiting**: Auth & checkout endpoints rate-limited against brute-force attacks.

---

## 6. Evidence Manifest (required when the change has a visible surface)

*A claim of "verified" needs artifacts that exist, are not stubs, and belong to **this** run. Guide: `references/technical/EVIDENCE_MANIFEST_GUIDE.md`.*

Declare what this pass must capture — one entry per viewport/state that the change actually affects. A full desktop+mobile feature needs both; a narrow HUD fix needs only the affected desktop state. **Do not drop an entry because its capture failed** — the failure is the finding.

`artifacts/evidence.json`:

```json
{
  "version": 1,
  "runId": "pass-1",
  "captures": [
    { "mode": "desktop", "state": "default", "report": "artifacts/pass-1/desktop.json" },
    { "mode": "mobile",  "state": "default", "report": "artifacts/pass-1/mobile.json" }
  ],
  "artifacts": ["artifacts/pass-1/screen.webm"]
}
```

```bash
python3 scripts/verify/check_evidence.py . --manifest artifacts/evidence.json
```

| Check | Status | Evidence |
| :--- | :--: | :--- |
| Manifest declares every affected viewport/state | [ ] | |
| `runId` is fresh (new run for this change, never relabelled) | [ ] | |
| `check_evidence.py` passes (strict mode) | [ ] | |
| **I looked at** each screenshot / recording myself | [ ] | [what I saw — not "looks good"] |
| **Not verified** (state it plainly) | [ ] | [e.g. "low-end device FPS — no device available"] |

> The last two rows are the honest ones. The checker proves artifacts exist; it cannot prove they show the right thing, that motion feels right, or that the build succeeded. Claiming otherwise is a false-green.

---

## 6A. Four states, not two

Pass/fail hides the two states that cause the most damage: a check nobody ran, and a check run on the wrong build.

| State | Means | Counts as pass? |
| :--- | :--- | :---: |
| **PASSED** | Ran on the pinned build, observed the expected result | Yes |
| **FAILED** | Ran, result differed — with reproduction | No |
| **BLOCKED** | Could not run (no device, no runtime, no access) | **No** — it is an explicit gap |
| **NOT RUN** | Nobody attempted it | **No** — and it must be visible, not omitted |

**Rule**: a section with any FAILED, BLOCKED or NOT RUN row cannot be marked LOCAL PASS. Report the counts, not just a verdict: `24 passed / 2 failed / 1 blocked / 3 not run`.

### 6A.1 What evidence actually proves

These distinctions are where "it works" quietly becomes a false claim:

| Claim | Proves | Does **not** prove |
| :--- | :--- | :--- |
| `npm run build` succeeded | Compilation | That the app launches |
| App launched | Process started | That any interaction works |
| Screenshot of a state | That state rendered once | That the flow reaching it works |
| Unit tests pass | Tested units behave | End-to-end behaviour |
| Implementer says it's fixed | Someone wrote code | That the defect is gone |
| Tested on emulator | Emulated behaviour | Physical-device behaviour |

A compile, one title-screen screenshot, or a green unit suite **cannot** establish an interactive end-to-end flow.

### 6A.2 Who ran the check

| Situation | What you may claim |
| :--- | :--- |
| A separate person/task tested the build | **Independently verified** |
| The implementer tested their own build | **Implementer-reported** — say so |
| The agent tested its own implementation | **Self-verified** — disclose it |

On a solo project there is usually no separate tester. That is fine. What is not fine is presenting self-testing as independent QA. Write `Self-verified (no separate tester available)` and move on.

---

## 7. Final Local Verification Decision

- [ ] **LOCAL PASS**: All checklist items above are fulfilled. Code is ready to be pushed to the `staging` branch for integration testing in **Module 07: QA & SIT**.
- [ ] **FAIL**: Critical bugs or compilation failures found. Resolve before pushing.

**Waivers**: if a criterion is knowingly not met and the project proceeds, record who approved it, when, and what the consequence is. A waiver is a decision with a name attached — not a missing checkbox. Blocked and never-run required checks are **not** waivers; they are gaps.
