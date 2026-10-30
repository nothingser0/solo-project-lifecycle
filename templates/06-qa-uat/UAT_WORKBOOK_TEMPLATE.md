# User Acceptance Testing (UAT) Workbook

> Combined UAT test scenario workbook and defect tracking log for the client acceptance testing period by Client Single PIC.

---

## PART I: UAT TEST SCENARIOS

### 1. Environment, Window & Decision Roles
- **Staging URL**: [approved staging URL]
- **Build / commit under test**: [version and commit]
- **Testing window**: [agreed start and end dates; source agreement]
- **Test account access**: [secure vault/process reference only; never paste credentials or secrets here]

| Role | Name | Responsibility / authority | Contact / evidence reference |
| :--- | :--- | :--- | :--- |
| Tester(s) | [name(s)] | Execute assigned scenarios and record observed results | [reference] |
| Client Single PIC (approver) | [name] | Accepts results and signs UAT decision | [reference] |
| Release veto authority (if any) | [name/role or N/A with reason] | Can block release under agreed policy | [reference] |
| Developer / triage owner | [name] | Triage, fixes, staging redeploy, and retest coordination | [reference] |

---

### 2. UAT Scenario Matrix

Create at least one scenario for every in-scope PRD acceptance criterion. Use plain business language. Include preconditions, exact actions, observable expected results, actual result, tester, status, and evidence. Use Given/When/Then where useful. Remove out-of-scope or non-applicable scenarios with a reason; never copy example outcomes as evidence.

| Scenario ID | Requirement / AC ID | Priority | Preconditions / test data | User steps (Given / When / Then where useful) | Expected result | Actual result | Tester | Status (PASS / FAIL / BLOCKED / N/A + reason) | Evidence / retest build |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| UAT-SCN-01 | [PRD/FSD AC ID] | [P0/P1/P2] | [preconditions; synthetic account/data reference] | [business-language steps] | [observable acceptance result] | [fill after execution] | [name] | [unexecuted] | [evidence path/link] |

**Coverage summary**: [in-scope AC count] · [mapped to scenario count] · [PASS] · [FAIL] · [BLOCKED] · [N/A with reason] · [untested]. Any unmapped or untested in-scope P0 criterion is a release gap requiring explicit disposition by the approver.

---

## PART II: UAT DEFECT TRACKING LOG

### 1. Test Metadata
- **System Name**: [Application Name]
- **Reporting Period**: [Start Date] to [End Date]
- **Tester Single PIC**: [Client PIC Name]
- **Lead Developer**: [Your Name]

---

### 2. Defect Tracking Table

| Bug ID | Date Reported | Module / Page | Issue Description & Steps to Reproduce | Severity (1/2/3/CR) | Remediation Status | Resolution Date | Client Retest Verification |
| :---: | :---: | :--- | :--- | :---: | :---: | :---: | :---: |
| [ID] | [date] | [module/route] | [repro steps, expected vs actual, evidence reference] | [severity/CR] | [status + owner] | [date] | [tester, retest build, result] |

---

### 3. Remediation Status Definitions
- **`OPEN`**: New issue reported by client tester and currently queued for triage.
- **`IN_PROGRESS`**: Valid issue currently being fixed by developer in `fix/*` branch.
- **`RESOLVED`**: Fix deployed to Staging server and ready for client retest.
- **`CLOSED`**: Client PIC retested on Staging and confirmed bug is fully resolved.
- **`TRANSFERRED TO CR`**: Request outside PRD/FSD scope transferred to paid *Change Request* proposal.

---

### 4. Final Triage Status Summary

- **Total Findings Reported**: [ ] Findings
- **Severity 1 (Blocker)**: [0] Open  *(Must be 0 for UAT Sign-Off)*
- **Severity 2 (Major)**: [0] Open  *(Must be 0 for UAT Sign-Off)*
- **Severity 3 (Minor)**: [ ] Resolved / Scheduled during warranty
- **New Feature Requests (CR)**: [ ] Transferred to Next Phase / CR Document

---

### 5. UAT Decision & Sign-Off

Record the final decision, release risks accepted, any approved punch-list items, and why the decision meets the project's release policy. `GO` requires all applicable P0 criteria to pass and no unresolved blocker; any exception needs explicit authorized approval. `NO-GO` or `PENDING` keeps production release blocked.

- **Decision**: [GO / NO-GO / PENDING]
- **Residual risks / accepted deviations**: [list with owner and mitigation, or none]
- **Deferred punch-list items**: [IDs, owner, target date, or none]
- **Decision rationale / release policy reference**: [text/reference]

| Client Single PIC | Lead Developer |
| :--- | :--- |
| **Name**: _________________________ | **Name**: _________________________ |
| **Title / Role**: _________________ | **Title / Role**: Independent Lead Engineer |
| **Date**: _________________________ | **Date**: _________________________ |
| **Signature**: | **Signature**: |
