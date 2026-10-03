# Local Verification & Smoke Test Checklist

> Self-verification sheet before a solo developer publishes code to the staging repository or submits a release milestone.

---

## 1. Verification Metadata
- **Project Name**: [Application Name]
- **Latest Commit SHA**: `______` (run `git rev-parse --short HEAD`)
- **Tester / Solo Engineer**: [Your Name]
- **Verification Date**: [YYYY-MM-DD]
- **Target Status**: ❌ INCOMPLETE (mark ✅ READY after all checks pass)

---

## 2. Compilation & Linter Verification (Build Sanity)

| Test Command | Success Criteria | Self-Test Result | Notes |
| :--- | :--- | :---: | :--- |
| `npm run type-check` | TypeScript compiles without errors (`exit 0`) | [ ] PASS | Run and document output |
| `npm run lint` | Linter clean without critical warnings | [ ] PASS | Run and document output |
| `npm run build` | Frontend & backend bundle built successfully | [ ] PASS | Run and document output |

---

## 3. API Endpoint Matrix Verification (Per FSD)

| Endpoint | Method | Test Scenario | Expected Status Code | Test Result |
| :--- | :---: | :--- | :---: | :---: |
| `/api/v1/auth/login` | `POST` | Valid credentials → HttpOnly cookie set | `200 OK` | [ ] PASS |
| `/api/v1/auth/login` | `POST` | Invalid password → Error message | `401 Unauthorized` | [ ] PASS |
| (Add all FSD endpoints here) | | | | [ ] PASS |

**Evidence Required**: Paste curl command output or Postman screenshots showing actual responses

---

## 4. UI Screen Verification (Per Google Stitch & 5 States)

### 4A. Design Compliance (Per DESIGN.md Tokens)

**Check each screen against DESIGN.md specifications:**

| Screen | Brand Color Used | Typography Scale | Shadow Style | Border Style | Result |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Dashboard** | Primary (not neutral) | Per DESIGN.md section 3 | Flat (shadow-sm) | 1px border | [ ] PASS |
| **Login** | Primary brand | Correct weights | Flat | 1px border | [ ] PASS |
| (Add all SITEMAP screens) | | | | [ ] PASS |

**Design Token Verification**:
- [ ] Primary brand color applied to CTA buttons (not `bg-neutral-100`)
- [ ] Typography matches DESIGN.md scale (specific font weights/sizes)
- [ ] Shadow style consistent (flat `shadow-sm border` vs heavy `shadow-lg`)
- [ ] Border width matches spec (typically 1px `border-neutral-200`)
- [ ] Spacing follows Tailwind scale from DESIGN.md

**Evidence Required**: Attach screenshots showing brand colors applied correctly

### 4B. 5-State Matrix (Per SITEMAP Screens)

| Page Name | Default State | Skeleton Loader | Empty State | Inline Error | Success Toast |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Dashboard** | [ ] PASS | [ ] PASS | [ ] PASS | [ ] PASS | [ ] PASS |
| **Document Form** | [ ] PASS | [ ] PASS | N/A | [ ] PASS | [ ] PASS |
| (Add all screens) | [ ] PASS | [ ] PASS | [ ] PASS | [ ] PASS | [ ] PASS |

**Evidence Required**: Test each state manually, document with screenshots

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

**Evidence Required**: Console screenshot showing zero hydration errors

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

## 5. Critical Security Verification (Security Sanity)

- [ ] **Encryption**: Sensitive data encrypted at rest (check FSD security spec)
- [ ] **Presigned URL**: Download links expire per FSD timeout (test expiry)
- [ ] **Password Hashing**: Database shows hashed passwords (not plaintext)
- [ ] **Rate Limiting**: Login endpoint blocks after X attempts (test manually)

**Evidence Required**: 
- Database query showing `$argon2id$` or `$2b$` prefixed passwords
- Rate limit test: curl login 6 times, 6th fails with 429
- Presigned URL expires: wait timeout, verify 403 Forbidden

---

## 6. Final Local Verification Decision

**Smoke Test Execution**:
```bash
npm run test:smoke
# OR
npx tsx scripts/smoke-test.ts
```

**Smoke Test Result**: ______ passed, ______ failed (paste output below)

```
[Paste smoke test output here]
```

**Final Decision**:
- [ ] **LOCAL PASS**: All checklist items above fulfilled, all evidence attached, smoke test passed 100%
- [ ] **FAIL**: Critical bugs or compilation failures found. Resolve before pushing.

**If FAIL, document blockers**:
1. 
2. 
3.
