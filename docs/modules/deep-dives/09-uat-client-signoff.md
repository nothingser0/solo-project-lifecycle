# Module 09 Deep Dive: UAT Preparation Resources & Client Protection Scripts

> Companion to `docs/modules/09-uat-client-signoff.md` (runbook). This file holds the detailed execution guidance; the runbook keeps a condensed summary.

## UAT Preparation Resources

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

## Solo Developer Protection Scripts During UAT (Full Text)

### 1. Deflecting "New Features Disguised as Bugs"
Clients often say: *"Hey, why doesn't this button send notifications to Telegram yet? This is a bug, please fix it."*

**Solo Dev Standard Response**:
> *"Let's review our agreed PRD and FSD v1.0 documents together. In Module 4 notification feature details, we agreed that the system uses Transactional Email delivery, while Telegram integration is documented as Out-of-Scope (Phase 2). Because the email system on staging is working properly, this functionality has Passed UAT status. If you would like to add the Telegram module now, we are happy to prepare a separate Change Request (CR) form."*

### 2. The Deemed Acceptance Clause
To prevent clients from delaying testing sessions for weeks and causing project stalls:
- The testing window is capped at a maximum of **5–7 business days**.
- A standard clause in the SOW contract applies: *"If the Client does not perform testing or provide written defect notes within 10 (ten) business days from the delivery of the Staging link, the software shall be legally considered fully accepted (Deemed Accepted), and the developer is entitled to proceed to production deployment and final invoice settlement."*

---

## UAT Iteration Limit & Deemed Acceptance (Full Clause)

**UAT Iteration Limit**: Maximum **2 (two) UAT cycles** per commercial contract (`SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md` — revision limits clause).
- Cosmetic defects (Severity 3/4) **MAY NOT block UAT sign-off** and are deferred to warranty.
- If client remains silent without written defect reports for **7 calendar days**, the milestone is **DEEMED ACCEPTED** pursuant to contract Deemed Acceptance clause.

---

## Defect Severity Matrix (Full Definitions)

Every issue reported by the client must be classified into 4 levels:

| Severity Level | Definition & Impact | Dev Response SLA | Impact on UAT Sign-Off |
| :--- | :--- | :---: | :--- |
| **Severity 1 (Blocker)** | System crash, data corruption, payment failure, core workflow completely broken. | < 24 Hours | **BLOCKS** sign-off (Must be resolved). |
| **Severity 2 (Major)** | Important feature not functioning per FSD, but a temporary workaround exists. | < 48 Hours | Must be fixed before production deployment. |
| **Severity 3 (Minor)** | Typo, 2px text margin shift, badge color low contrast. | < 72 Hours | **DOES NOT BLOCK** sign-off (Can be addressed during release window / warranty). |
| **Out-of-Scope (CR)** | Request for new workflow or additional database column outside PRD. | Answered same day | **REJECTED FROM UAT** → Moved to Change Request form. |

> Summary for the runbook: structure UAT with the training/demo/feedback templates (Medium/Large), deflect out-of-scope requests with the PRD/FSD reference + Change Request form, enforce the 5–7 business-day window with the Deemed Acceptance clause, and cap the engagement at 2 UAT cycles — cosmetic defects never block sign-off.
