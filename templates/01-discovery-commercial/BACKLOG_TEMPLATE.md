# Product Backlog: [Product Name]

**Project**: [Project Name]  
**Owner**: [PIC Name]  
**Sprint/Cycle**: [Sprint Number] ([Start Date] – [End Date])  
**Last Updated**: YYYY-MM-DD

---

## 1. Backlog Summary

| Status | Count | Total SP | % of Backlog |
| :--- | ---: | ---: | ---: |
| Done | 12 | 34 | 25% |
| In Progress | 3 | 13 | 10% |
| Ready (Prioritized) | 8 | 28 | 21% |
| Backlog (Unprioritized) | 45 | 152 | 44% |
| **TOTAL** | **68** | **227** | **100%** |

**Velocity**: Avg 15 SP/week (based on last 3 sprints)  
**Projected Completion**: [Date] (if velocity is constant)

---

## 2. Epic Hierarchy & Status

```text
Epic 1: User Authentication System (34 SP) ────┐
  ├─ Story 1.1: Email/Password Login (5 SP) ✅ │
  ├─ Story 1.2: Password Reset Flow (3 SP) 🟡  │── Priority: P0 (Must Have)
  ├─ Story 1.3: Session Management (5 SP) ⬜    │
  └─ Story 1.4: Rate Limiting (3 SP) ⬜         │
                                                 │
Epic 2: Document Processing Engine (55 SP) ────┤
  ├─ Story 2.1: File Upload (S3) (5 SP) ✅      │
  ├─ Story 2.2: OCR Processing (13 SP) 🟡       │── Priority: P0 (Must Have)
  ├─ Story 2.3: Result Storage (5 SP) ⬜        │
  └─ Story 2.4: Batch Processing (8 SP) ⬜      │
                                                 │
Epic 3: User Dashboard (28 SP) ────────────────┤
  ├─ Story 3.1: List View (5 SP) ✅             │── Priority: P1 (Should Have)
  ├─ Story 3.2: Detail View (3 SP) 🟡           │
  └─ Story 3.3: Search & Filter (5 SP) ⬜       │
                                                 │
Epic 4: Payment & Billing (21 SP) ─────────────┘── Priority: P1 (Should Have)
  ├─ Story 4.1: Stripe Integration (8 SP) ⬜
  ├─ Story 4.2: Invoice Generation (5 SP) ⬜
  └─ Story 4.3: Subscription Management (8 SP) ⬜
```

**Legend**:
- ✅ Done
- 🟡 In Progress
- ⬜ Not Started

---

## 3. Prioritized Backlog (Ready for Development)

### Epic 1: User Authentication System

#### Story 1.2: Password Reset Flow
**As a** registered user,  
**I want to** reset my password via email link,  
**So that** I can regain access if I forget my password.

**Priority**: P0 (Must Have)  
**Story Points**: 3 SP  
**Owner**: Dev  
**Status**: In Progress (60% done)  
**Sprint**: Sprint 2

**Acceptance Criteria**:
- [ ] Given I click "Forgot Password", when I enter my registered email, then I receive a reset link within 2 minutes
- [ ] Given I click the reset link, when I enter a new password (min 8 chars), then my password is updated and I'm logged out from all sessions
- [ ] Given the reset link is older than 1 hour, when I try to use it, then I see "Link expired, request a new one"
- [ ] Edge case: If email not registered, show generic message "If email exists, you'll receive a link" (prevent email enumeration)

**Technical Tasks**:
- [x] Task 1.2.1: Create POST `/api/auth/reset-request` endpoint (1 SP)
- [ ] Task 1.2.2: Generate secure token (crypto.randomBytes), store in DB with expiry (1 SP)
- [ ] Task 1.2.3: Send email with reset link via SendGrid (0.5 SP)
- [ ] Task 1.2.4: Create POST `/api/auth/reset-confirm` endpoint (validate token, update password) (1 SP)
- [ ] Task 1.2.5: Write integration test for full flow (0.5 SP)

**Dependencies**: SMTP config (SendGrid API key)  
**Blocker**: None  
**Notes**: Use same token format as email verification (SHA256 hash in DB)

---

#### Story 1.3: Session Management (JWT Refresh Token)
**As a** logged-in user,  
**I want** my session to auto-refresh without re-login,  
**So that** I don't get logged out every 15 minutes.

**Priority**: P0 (Must Have)  
**Story Points**: 5 SP  
**Owner**: Dev  
**Status**: Not Started  
**Sprint**: Sprint 3

**Acceptance Criteria**:
- [ ] Given my access token expires (15 min), when I make an API call, then system auto-refreshes token using refresh token (stored in httpOnly cookie)
- [ ] Given refresh token expires (7 days), when I try to use it, then I'm logged out and must re-authenticate
- [ ] Given I logout, when I try to use old tokens, then I get 401 Unauthorized
- [ ] Edge case: If refresh token is revoked (manual logout or security event), reject all subsequent requests

**Technical Tasks**:
- [ ] Task 1.3.1: Implement token refresh endpoint POST `/api/auth/refresh` (2 SP)
- [ ] Task 1.3.2: Store refresh token in DB (table: `refresh_tokens`) with expiry & user_id (1 SP)
- [ ] Task 1.3.3: Update client-side auth middleware to auto-retry with refresh on 401 (2 SP)
- [ ] Task 1.3.4: Add token revocation on logout (delete from DB) (1 SP)
- [ ] Task 1.3.5: Write security test (attempt to use revoked token) (1 SP)

**Dependencies**: None  
**Blocker**: None  
**Notes**: Use httpOnly cookie for refresh token (prevent XSS), secure flag in production

---

### Epic 2: Document Processing Engine

#### Story 2.2: OCR Processing (Extract Text from Images)
**As a** user,  
**I want** the system to extract text from uploaded images,  
**So that** I can search and analyze document content.

**Priority**: P0 (Must Have)  
**Story Points**: 13 SP (Large – complex integration)  
**Owner**: Dev  
**Status**: In Progress (30% done)  
**Sprint**: Sprint 2–3 (spans 2 sprints)

**Acceptance Criteria**:
- [ ] Given I upload a clear image (PNG/JPG), when processing completes, then extracted text accuracy ≥ 95% (tested with 10 sample docs)
- [ ] Given I upload a PDF with scanned pages, when processing completes, then each page is OCR'd separately
- [ ] Given OCR fails (unreadable image), when I check status, then I see error message "Unable to extract text, please upload higher quality image"
- [ ] Edge case: If image > 10MB, reject with "File too large, max 10MB"

**Technical Tasks**:
- [x] Task 2.2.1: Research OCR libraries (Tesseract.js vs AWS Textract vs Google Vision API) (2 SP)
- [x] Task 2.2.2: Set up Google Vision API credentials & test with sample image (2 SP)
- [ ] Task 2.2.3: Create background job queue (BullMQ + Redis) for async processing (3 SP)
- [ ] Task 2.2.4: Implement OCR processing job (call Vision API, handle retries) (3 SP)
- [ ] Task 2.2.5: Store extracted text in DB (table: `document_extracts`) (1 SP)
- [ ] Task 2.2.6: Add webhook/polling for job status (notify user when done) (2 SP)
- [ ] Task 2.2.7: Write end-to-end test with real sample documents (1 SP)

**Dependencies**: Google Cloud Vision API quota (free tier: 1000 requests/month)  
**Blocker**: ⚠️ Vision API approval pending (applied 2026-01-05, expected 3–5 days)  
**Notes**: Fallback to Tesseract.js if API quota exceeded (lower accuracy but free)

**RICE Score**: (200 users × 3 impact × 0.8 confidence) / 2.5 effort = **192** (high priority)

---

### Epic 3: User Dashboard

#### Story 3.2: Document Detail View
**As a** user,  
**I want** to view full details of a processed document,  
**So that** I can see extracted text, metadata, and download results.

**Priority**: P1 (Should Have)  
**Story Points**: 3 SP  
**Owner**: Dev  
**Status**: In Progress (20% done)  
**Sprint**: Sprint 2

**Acceptance Criteria**:
- [ ] Given I click on a document in the list, when detail page loads, then I see: filename, upload date, status, extracted text (if done), download button
- [ ] Given document is still processing, when I view detail, then I see progress indicator and estimated time remaining
- [ ] Given extraction failed, when I view detail, then I see error message and option to re-upload
- [ ] Edge case: If I try to view another user's document (URL tampering), I get 403 Forbidden

**Technical Tasks**:
- [ ] Task 3.2.1: Create GET `/api/documents/:id` endpoint with auth check (1 SP)
- [ ] Task 3.2.2: Build detail page UI (Next.js page, Tailwind CSS) (1 SP)
- [ ] Task 3.2.3: Add real-time status polling (if processing, poll every 5 seconds) (1 SP)
- [ ] Task 3.2.4: Write authorization test (ensure user can only access own docs) (0.5 SP)

**Dependencies**: Story 2.2 (OCR Processing) must be complete  
**Blocker**: None  
**Notes**: Use SWR for client-side data fetching + auto-refresh

---

## 4. Unprioritized Backlog (Future Consideration)

| Story ID | Title | Epic | Priority | SP | RICE Score | Notes |
| :--- | :--- | :--- | :--- | ---: | ---: | :--- |
| 4.1 | Stripe integration | Payment | P1 | 8 | 150 | Required for monetization |
| 5.1 | Email notifications | Notifications | P2 | 3 | 80 | Nice to have |
| 5.2 | Onboarding tutorial | Activation | P1 | 5 | 120 | Reduce churn |
| 6.1 | Export to PDF | Export | P2 | 3 | 60 | User-requested |
| 6.2 | Batch upload (multiple files) | Upload | P2 | 5 | 90 | Power user feature |
| 7.1 | Dark mode | UI/UX | P3 | 2 | 40 | Low effort, nice-to-have |
| 8.1 | API for third-party integration | Platform | P2 | 13 | 50 | Complex, Later phase |

**Promotion Criteria** (when to move to "Ready"):
- RICE score > 100 AND fits in current sprint capacity
- OR urgent user request (3+ customers asking)
- OR dependency for higher-priority story

---

## 5. Icebox (Deferred / Rejected)

| Story | Reason | Date Moved | Review Date |
| :--- | :--- | :--- | :--- |
| Social login (Google, Facebook) | Scope cut for MVP, email login sufficient | 2026-01-20 | Q2 2026 |
| Real-time collaboration (multi-user editing) | Too complex for solo dev, not core value | 2026-01-15 | Q3 2026 |
| Mobile app (iOS/Android native) | Web-first strategy, no demand yet | 2026-01-10 | When DAU > 500 |

---

## 6. Backlog Grooming Notes

**Last Grooming Session**: 2026-01-25  
**Attendees**: Solo Dev (self-review)

**Actions Taken**:
- Broke down Story 2.2 (OCR) into 7 technical tasks (was too vague)
- Re-estimated Story 1.3 from 3 SP → 5 SP (forgot token revocation logic)
- Promoted Story 3.2 to Sprint 2 (user feedback: "Need to see extraction results ASAP")
- Moved Story 7.1 (Dark mode) from P3 → P2 (low effort, high delight)

**Next Grooming**: 2026-02-01 (weekly cadence)

---

## 7. Definition of Ready (Checklist Before Story Enters Sprint)

- [ ] Story follows "As a... I want... So that..." format
- [ ] Acceptance criteria are testable (Given/When/Then)
- [ ] Story is estimated (story points assigned)
- [ ] Technical tasks are broken down (each task < 1 day)
- [ ] Dependencies identified and unblocked
- [ ] RICE score calculated (for prioritization)
- [ ] Reviewed by PIC/PM (or self-review for solo dev)

---

## 8. Definition of Done (Checklist Before Story Marked "Done")

- [ ] Code written and passes linting (ESLint, Prettier)
- [ ] All acceptance criteria met (manual testing)
- [ ] Unit/integration tests written (coverage ≥ 70% for new code)
- [ ] Peer review (or self-review with checklist for solo dev)
- [ ] Deployed to staging environment
- [ ] Smoke test passed on staging
- [ ] Documentation updated (API docs, README if needed)
- [ ] No known P0/P1 bugs remaining

---

## 9. Backlog Health Metrics

| Metric | Target | Actual | Status |
| :--- | :--- | :--- | :--- |
| % stories with acceptance criteria | 100% | 95% | 🟡 (5 stories missing) |
| % stories estimated | 100% | 98% | ✅ |
| Avg story size | ≤ 5 SP | 6.2 SP | 🔴 (too large, break down) |
| Backlog depth (weeks of work) | 4–6 weeks | 8 weeks | 🟡 (too much, prune) |
| Icebox items | < 10% total | 12% | 🟡 (review quarterly) |

**Action Items**:
- Break down 3 large stories (> 8 SP) this week
- Prune 5 low-priority items from backlog (move to Icebox)

---

## 📌 Quick Reference Links

- **Roadmap**: `docs/pm/PRODUCT_ROADMAP.md`
- **OKRs**: `docs/pm/OKR_Q1_2026.md`
- **Prioritization Guide**: `references/pm/PM_PRIORITIZATION_FRAMEWORKS.md`
- **Jira/Linear Setup**: `references/pm/PM_TOOLS_SETUP_GUIDE.md`

---

**💡 Solo Dev Backlog Tips**:
- Keep "In Progress" limit to 1–3 stories max (avoid context switching)
- Groom backlog weekly (15–30 min), review RICE scores
- Use T-shirt sizing (XS/S/M/L/XL) for rough estimates, convert to SP later
- Break down any story > 8 SP before starting (unknowns hide in large stories)
- Don't over-plan: Only detail next 2–3 sprints, keep rest as rough epics
