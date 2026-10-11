# Module 09: [VALIDATION GATE] UAT & Client Sign-Off on Staging

> - `templates/06-qa-uat/UAT_WORKBOOK_SMALL.md` (Lightweight UAT test matrix for MVP/Fast-track projects)
> - `templates/06-qa-uat/UAT_SIGNOFF_SMALL.md` (Simplified single-page client sign-off sheet for small projects)

This module is a **BLOCKING VALIDATION GATE** in the solo developer project lifecycle. Absolute rule: **DEPLOYMENT TO PRODUCTION SERVERS OR POINTING PRIMARY DOMAINS IS STRICTLY PROHIBITED BEFORE THIS GATE PASSES.**

Its purpose is to facilitate direct testing by the **Client Single PIC** and end users (*key users*) on the Staging server based on scenarios in **`PRD.md`**, manage defect triage, deflect scope creep disguised as bugs, and secure the signing of the **UAT Sign-Off Report (Berita Acara UAT)**.

---

## 1. Execution Cycle of Module 09

```text
[ INPUT: Staging Server Ready & Data Populated ]
  • M07 REQUIRED: Staging must pass SIT (docs/qa/SIT_WORKBOOK.md or SECURITY_CHECKLIST_SMALL.md)
  • M08 CONDITIONAL: If legacy data exists, must be imported and reconciled
  • M08 BYPASS: Greenfield projects (no legacy data) use seed data only
                                    │
                                    ▼
[ STEP 1: UAT Scenario Preparation & Client Tester Credentials ]
  • Convert PRD.md Acceptance Criteria into Layman Test Steps
  • Provision Client Tester Accounts on Staging (Super Admin, Manager, Staff)
                                    │
                                    ▼
[ STEP 2: UAT Session Kickoff & Testing Window Locking ]
  • Brief Orientation Session (30-Minute Scenario Walkthrough Demo to Client PIC)
  • Lock UAT Deadline (Maximum 5–7 Business Days)
  • Apply Deemed Acceptance Clause (Automatic Acceptance on Default)
                                    │
                                    ▼
[ STEP 3: Finding Triage: Real Bugs vs Scope Creep ]
  • Severity 1 (Blocker): Must be fixed immediately
  • Severity 2 (Major): Fixed before production release
  • Severity 3 (Minor/Cosmetic): Reasonable fix or deferred to warranty period
  • New Features (Out of PRD scope): Rejected & redirected to Change Request (CR)
                                    │
                                    ▼
[ STEP 4: Bug Fixing on fix/* Branch & Staging Re-verification ]
  • Solo Dev Fixes Valid Bugs on Isolated Branch ──► Merge to staging
  • Client PIC Retests & Marks RESOLVED Status in UAT_DEFECT_LOG.md
                                    │
                                    ▼
[ STEP 5: Signing of UAT Sign-Off Report ]
  • Prepare UAT_SIGNOFF_REPORT.md Document
  • Client Single PIC Signs System Acceptance Approval
                                    │
                                    ▼
[ OUTPUT: Signed UAT Sign-Off Report ] ──► Open [GATE] Module 10: Production Deploy
```

---

## 2. UAT Preparation Resources

Before UAT execution, use these optional templates to structure client preparation:

### Client Training Script
**`templates/06-qa-uat/UAT_TRAINING_SCRIPT.md`** (12.77 KB) - Conduct 1-2 hour training session covering:
- System walkthrough and feature demonstrations
- Test account credentials and access setup
- UAT process explanation and timeline expectations
- Feedback submission workflow and defect reporting

**When to use**: Medium/Large scales, or Small scale with non-technical clients unfamiliar with testing.

### Demo Kickoff Script
**`templates/06-qa-uat/DEMO_SCRIPT.md`** (10.15 KB) - Structure formal UAT kickoff meeting:
- Feature demonstrations with scenario walkthroughs
- Success criteria review per PRD acceptance criteria
- Q&A preparation and edge case handling
- Recording demo session for reference

**When to use**: All scales for Step 2 kickoff session (30-minute orientation).

### Structured Feedback Collection
**`templates/06-qa-uat/FEEDBACK_MATRIX.md`** (11.17 KB) - Organize client feedback systematically:
- Feedback ID, category (bug/feature/UX), priority classification
- Screenshot/video evidence attachment
- Resolution status tracking (Open/In Progress/Resolved/Closed)
- Sign-off tracking per feature area

**When to use**: Medium/Large scales with multiple UAT participants requiring centralized feedback tracking.

---

## 3. Solo Developer Protection Principles During UAT

### 1. Deflecting "New Features Disguised as Bugs"
Clients often say: *"Hey, why doesn't this button send notifications to Telegram yet? This is a bug, please fix it."*

**Solo Dev Standard Response**:
> *"Let's review our agreed PRD and FSD v1.0 documents together. In Module 4 notification feature details, we agreed that the system uses Transactional Email delivery, while Telegram integration is documented as Out-of-Scope (Phase 2). Because the email system on staging is working properly, this functionality has Passed UAT status. If you would like to add the Telegram module now, we are happy to prepare a separate Change Request (CR) form."*

### 2. The Deemed Acceptance Clause
To prevent clients from delaying testing sessions for weeks and causing project stalls:
- The testing window is capped at a maximum of **5–7 business days**.
- A standard clause in the SOW contract applies: *"If the Client does not perform testing or provide written defect notes within 10 (ten) business days from the delivery of the Staging link, the software shall be legally considered fully accepted (Deemed Accepted), and the developer is entitled to proceed to production deployment and final invoice settlement."*

---

## 4. Defect Severity Matrix

Every issue reported by the client must be classified into 4 levels:

| Severity Level | Definition & Impact | Dev Response SLA | Impact on UAT Sign-Off |
| :--- | :--- | :---: | :--- |
| **Severity 1 (Blocker)** | System crash, data corruption, payment failure, core workflow completely broken. | < 24 Hours | **BLOCKS** sign-off (Must be resolved). |
| **Severity 2 (Major)** | Important feature not functioning per FSD, but a temporary workaround exists. | < 48 Hours | Must be fixed before production deployment. |
| **Severity 3 (Minor)** | Typo, 2px text margin shift, badge color low contrast. | < 72 Hours | **DOES NOT BLOCK** sign-off (Can be addressed during release window / warranty). |
| **Out-of-Scope (CR)** | Request for new workflow or additional database column outside PRD. | Answered same day | **REJECTED FROM UAT** → Moved to Change Request form. |

---

**UAT Iteration Limit**: Maximum **2 (two) UAT cycles** per commercial contract (`SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md:42`).
- Cosmetic defects (Severity 3/4) **MAY NOT block UAT sign-off** and are deferred to warranty.
- If client remains silent without written defect reports for **7 calendar days**, the milestone is **DEEMED ACCEPTED** pursuant to contract Deemed Acceptance clause.

---

## 5. Adaptation by Project Scale

| UAT Aspect | 🔵 Small Scale (Fast-Track Client) | 🟢 Medium Scale (B2B SaaS / Agency) | 🟡 Large Scale (Multi-Division) | 🔴 Enterprise (Non-Solo Capacity) |
| :--- | :--- | :--- | :--- | :--- |
| **UAT Path** | **M09-LITE** (`UAT_SIGNOFF_SMALL.md`) | Wajib Penuh (`UAT_SIGNOFF_REPORT.md`) | Wajib Penuh + UAT Workbook Divisi | **Dialihkan ke Seri A (Fase A04/A00)** |
| **Testing Duration** | 2–3 business days | 5–7 business days | 10–14 business days | Pengawasan jadwal pengujian vendor klien |
| **UAT Participants** | Direct business owner / 1 tester eksternal | Single PIC + staf operasional | Client QA team & Business Analysts | Komite pengadaan & tim penilai enterprise |
| **Sign-Off Document** | `docs/qa/UAT_SIGNOFF_SMALL.md` | `docs/pm/UAT_SIGNOFF_REPORT.md` | Signed UAT Report + Defect Matrix | Advisory Acceptance Recommendation (A04) |

---

## 6. Deliverables

> 📁 **MANDATORY FILE LOCATION RULE**:
> All scenario files, defect logs, and UAT Sign-Off reports MUST be stored in the **`docs/pm/`** folder.

This module produces 2 sign-off documents:
1. **`docs/pm/UAT_WORKBOOK.md`**: Combined test scenario workbook and defect tracking log for Client Single PIC (using `templates/06-qa-uat/UAT_WORKBOOK_TEMPLATE.md`; lightweight alternative: `UAT_WORKBOOK_SMALL.md`).
2. **`docs/pm/UAT_SIGNOFF_REPORT.md`**: Official UAT Sign-Off Report signed by Client Single PIC certifying that all system functionality has been accepted (using `templates/06-qa-uat/UAT_SIGNOFF_TEMPLATE.md`; on Small scale, generated as `docs/qa/UAT_SIGNOFF_SMALL.md`).

---

## 7. Gate Exit Criteria [GATE]

[GATE] Module 09 is declared **PASSED** if:
- [ ] All test scenarios have **PASS** status or all Severity 1 & 2 findings are **RESOLVED**.
- [ ] **Quantitative Stability Criteria**:
  - 0 critical bugs (Severity 1) unresolved
  - Error rate < 1% (99%+ request success rate in staging logs)
  - System uptime ≥99% over last 48 hours
  - All core user flows (login, create, submit, approve) complete without blocking issues
- [ ] New feature requests have been separated in writing into Change Request forms.
- [ ] **Client Single PIC has signed the `docs/pm/UAT_SIGNOFF_REPORT.md` document.**

---

## 🛑 EXIT [GATE] PROTOCOL & MANDATORY STOP

After the UAT Sign-Off Report is signed by the client:

### **STEP 0: FILE EXISTENCE VERIFICATION (BLOCKING CHECK)**

**MANDATORY BEFORE CONTENT VALIDATION**:

1. **Check output file existence** using one of the following methods:
   - PowerShell: `Test-Path -LiteralPath "docs/pm/UAT_SIGNOFF_REPORT.md"` → must return `True`
   - Read and verify file `docs/pm/UAT_SIGNOFF_REPORT.md` → must succeed without error

2. **IF FILE DOES NOT EXIST**:
   - ❌ **STOP IMMEDIATELY** - do not proceed to content validation
   - ❌ **DO NOT display summary** to user
   - ❌ **DO NOT request confirmation** to proceed to Module 10
   - ✅ **REPORT ERROR** to user:
     ```
     CRITICAL ERROR: File UAT_SIGNOFF_REPORT.md was not created.
     Module 09 FAILED - cannot proceed to Module 10 (Production Deployment).
     
     Possible causes:
     - Write permission denied on docs/pm/ folder
     - Path typo in tool call
     - Disk full
     
     Please investigate this issue before proceeding.
     ```
   - ✅ **END TURN** and wait for user to fix issue

3. **ONLY IF FILE EXISTS**: Proceed to content validation below

---

### **STEP 1: CONTENT VALIDATION & SIGNATURE**

1. **STRICTLY PROHIBITED from directly performing git merge to `main`, deploying, or calling tools for Module 10 within the same turn!**
2. **Verify UAT Sign-Off content**:
   - [ ] Read and verify file `docs/pm/UAT_SIGNOFF_REPORT.md` → Confirm client signature + date exists
   - [ ] Confirm all Severity 1 & 2 defects RESOLVED
   - [ ] Confirm scope creep requests rejected or moved to Change Request
3. Present UAT closure status (all Severity 1 & 2 defects completed) and confirmation of signed UAT Report.
4. **END YOUR RESPONSE (END TURN)** and ask user for confirmation:
   > *"The UAT Sign-Off Report (`docs/pm/UAT_SIGNOFF_REPORT.md`) has been officially signed. The system is authorized to merge into the `main` branch. Are you ready to execute the official launch to the Production server in Module 10 (Deployment & Production Go-Live)?"*
5. Wait for explicit approval response from user before initiating the production deployment process.
