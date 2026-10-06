# Local Verification & Smoke Test Checklist

> Self-verification sheet before a solo developer publishes code to the staging repository or submits a release milestone.

---

## 1. Verification Metadata
- **Project Name**: [Application Name]
- **Latest Commit SHA**: `[git rev-parse --short HEAD]`
- **Tester / Solo Engineer**: [Your Name]
- **Verification Date**: [YYYY-MM-DD]
- **Target Status**: [Ready for Staging QA / Incomplete]

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
| `/api/v1/auth/login` | `POST` | Valid credentials $\to$ HttpOnly cookie / token set | `200 OK` | [ ] PASS |
| `/api/v1/auth/login` | `POST` | Invalid credentials $\to$ Specific error message | `401 Unauthorized` | [ ] PASS |
| `/api/v1/[resource]` | `POST` | Valid payload + new Idempotency key | `201 Created` | [ ] PASS |
| `/api/v1/[resource]` | `POST` | Duplicate idempotency key re-sent $\to$ Cached response | `200 OK / 409` | [ ] PASS |
| `/api/v1/[resource]/:id` | `GET` | Fetch resource data $\to$ Scoped by tenant | `200 OK` | [ ] PASS |
| `/api/v1/[action]` | `POST` | Atomic mutation $\to$ Status updated | `200 OK` | [ ] PASS |

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

### 4C. Hydration Error Check (Next.js SSR)

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

**Common Hydration Sources (If Found):**
- ❌ `Date.now()` or timestamps in SSR components
- ❌ `Math.random()` values
- ❌ Browser APIs (`window`, `document`) without `useEffect`
- ❌ Conditional rendering based on `useEffect` state
- ❌ Third-party scripts (analytics, chat widgets) injecting DOM

**Resolution:**
- Move dynamic values to client components (`'use client'`)
- Use `useEffect` for browser-only code
- Suppress hydration warnings only if unavoidable (e.g., timestamp display)

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
- [ ] **Password Protection**: Password hashes in database confirmed using Argon2id / bcrypt ($\ge 12$ rounds).
- [ ] **Rate Limiting**: Auth & checkout endpoints rate-limited against brute-force attacks.

---

## 6. Final Local Verification Decision

- [ ] **LOCAL PASS**: All checklist items above are fulfilled. Code is ready to be pushed to the `staging` branch for integration testing in **Module 07: QA & SIT**.
- [ ] **FAIL**: Critical bugs or compilation failures found. Resolve before pushing.
