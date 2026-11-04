# Module 09 Deep Dive: UAT Preparation Resources & Client Protection Scripts

## Contents

- [UAT Preparation Resources](#uat-preparation-resources)
- [Solo Developer Protection Scripts During UAT (Full Text)](#solo-developer-protection-scripts-during-uat-full-text)
- [UAT Iteration Limit & Acceptance Terms](#uat-iteration-limit-acceptance-terms)
- [Defect Severity Matrix (Full Definitions)](#defect-severity-matrix-full-definitions)


> Companion to `docs/modules/09_UAT_CLIENT_SIGNOFF.md` (runbook). This file holds the detailed execution guidance; the runbook keeps a condensed summary.

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

### 2. Acceptance Window and Contract Terms
Record the agreed UAT start/end date, response expectations, and escalation path in the signed SOW/project plan. This workflow does not infer acceptance from silence. Any deemed-acceptance term must be explicit in the applicable contract and reviewed for that agreement and jurisdiction; an agent must never mark UAT approved or authorize deployment from silence alone.

---

## UAT Iteration Limit & Acceptance Terms

**UAT Iteration Limit**: Follow the cycle limit in the signed commercial contract, if one exists; do not invent a default.
- Severity 3/4 defects may be deferred only with documented Client Single PIC approval, an owner, a target date, and a recorded release-risk disposition.
- If the client is unresponsive, follow the contract's documented notice and escalation process. Keep UAT pending until the designated approver provides written acceptance or the authorized project owner records a contract-reviewed decision.

---

## Defect Severity Matrix (Full Definitions)

Every issue reported by the client must be classified into 4 levels:

| Severity Level | Definition & Impact | Dev Response SLA | Impact on UAT Sign-Off |
| :--- | :--- | :---: | :--- |
| **Severity 1 (Blocker)** | System crash, data corruption, payment failure, core workflow completely broken. | < 24 Hours | **BLOCKS** sign-off (Must be resolved). |
| **Severity 2 (Major)** | Important feature not functioning per FSD, but a temporary workaround exists. | < 48 Hours | Must be fixed before production deployment. |
| **Severity 3 (Minor)** | Typo, 2px text margin shift, badge color low contrast. | < 72 Hours | May be deferred only with documented PIC approval, owner, target date, and risk disposition. |
| **Out-of-Scope (CR)** | Request for new workflow or additional database column outside PRD. | Answered same day | **REJECTED FROM UAT** → Moved to Change Request form. |

> Summary for the runbook: structure UAT with the training/demo/feedback templates (Medium/Large), deflect out-of-scope requests with the PRD/FSD reference + Change Request form, record the agreed acceptance window and escalation path, and follow any contractual cycle limit. Deferred defects require documented PIC approval and a punch list.
