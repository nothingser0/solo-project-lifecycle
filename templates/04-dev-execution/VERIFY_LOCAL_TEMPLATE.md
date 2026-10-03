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
| `npm run type-check` | TypeScript compiles without errors (`exit 0`) | [x] PASS | Free of type errors |
| `npm run lint` | Linter clean without critical warnings | [x] PASS | Code adheres to style rules |
| `npm run build` | Frontend & backend bundle built successfully | [x] PASS | Output ready for release |

---

## 3. API Endpoint Matrix Verification (Per FSD)

| Endpoint | Method | Test Scenario | Expected Status Code | Test Result |
| :--- | :---: | :--- | :---: | :---: |
| `/api/v1/auth/login` | `POST` | Valid credentials $\to$ HttpOnly cookie set | `200 OK` | PASS |
| `/api/v1/auth/login` | `POST` | Invalid password $\to$ Specific error message | `401 Unauthorized` | PASS |
| `/api/v1/documents` | `POST` | Valid payload + new Idempotency key | `201 Created` | PASS |
| `/api/v1/documents` | `POST` | Duplicate idempotency key re-sent $\to$ Rejected | `409 Conflict` | PASS |
| `/api/v1/documents/:id` | `GET` | Fetch document data $\to$ Presigned URL issued | `200 OK` | PASS |
| `/api/v1/sign/:token` | `POST` | Digital signature $\to$ Status updated to `SIGNED` | `200 OK` | PASS |

---

## 4. UI Screen Verification (Per Google Stitch & 5 States)

| Page Name | Default State | Skeleton Loader | Empty State | Inline Error | Success Toast |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Dashboard** | [x] PASS | [x] PASS | [x] PASS | [x] PASS | [x] PASS |
| **Document Form** | [x] PASS | [x] PASS | N/A | [x] PASS | [x] PASS |
| **[Feature] Screen** | [x] PASS | [x] PASS | N/A | [x] PASS | [x] PASS |

---

## 5. Critical Security Verification (Security Sanity)

- [x] **[Security feature]**: PDF files in Cloudflare R2 / AWS S3 bucket are confirmed binary encrypted (cannot be opened directly without decryption key).
- [x] **Presigned URL**: Download links expire automatically and return `403 Forbidden` after 15 minutes.
- [x] **Password Protection**: `password_hash` column in PostgreSQL database is confirmed prefixed with `$argon2id$` (not plaintext).
- [x] **Rate Limiting**: Login endpoint temporarily blocked after 5 consecutive failed attempts.

---

## 6. Final Local Verification Decision

- [x] **LOCAL PASS**: All checklist items above are fulfilled. Code is ready to be pushed to the `staging` branch for integration testing in **Module 07: QA & SIT**.
- [ ] **FAIL**: Critical bugs or compilation failures found. Resolve before pushing.
