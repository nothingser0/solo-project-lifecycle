# User Acceptance Testing (UAT) Sign-Off Report

> UAT decision record. This project artifact is not a substitute for legal review of contract terms.

---

## 1. Sign-Off Metadata
- **System Name**: [Application Name]
- **Client**: [Client Company Name]
- **Client Single PIC**: [Client PIC Full Name]
- **Lead Developer**: [Your Name]
- **Test Environment**: Staging Server (`https://staging.domainklien.com`)
- **Tested Build Version**: `v0.9.5-rc` (Commit: `[git-hash]`)
- **Signing Date**: [YYYY-MM-DD]

---

## 2. UAT Testing Summary Results

Based on the identified UAT workbook and defect log, the parties record actual results for the tested build below. Replace example rows with this project's in-scope modules; do not copy unverified results.

| Module Category | Total Scenarios Tested | Passed | Notes / Resolution |
| :--- | :---: | :---: | :--- |
| [in-scope module / requirement IDs] | [count] | [count] | [result and evidence reference] |
| **P0 acceptance criteria** | [in-scope count] | [passed count] | [unmapped, failed, blocked, or exception IDs] |
| **Release-blocking defects** | [count] | [resolved count] | [open count + disposition] |

---

## 3. Acceptance & Release Decision

By signing this Sign-Off Report, the **CLIENT** certifies and agrees that:

1. **Tested build and coverage**: This decision applies only to the staging build and acceptance criteria listed in the attached UAT workbook. Record unmapped/untested criteria and their disposition.
2. **Decision**: [GO / NO-GO / PENDING]. GO authorizes progression to the M10 release approval process; it does not replace the M10 deployment approval or rollback checks.
3. **Residual risks and deviations**: Record each accepted risk, owner, mitigation, and target date. Any conditional approval or deferred defect must be listed in the signed punch list below and permitted by the release policy.
4. **Scope changes**: Requests outside the approved PRD/FSD scope are logged as Change Requests and require separate approval.

| Decision role | Name | Decision / authority | Date |
| :--- | :--- | :--- | :--- |
| Client Single PIC approver | [name] | [GO / NO-GO / PENDING] | [date] |
| Release veto authority (if any) | [name/role or N/A with reason] | [cleared / veto / N/A] | [date] |
| Developer / UAT coordinator | [name] | [acknowledgment] | [date] |

---

## 4. Punch List & Conditional Sign-Off (Warranty Transition)
*Deferred defects require explicit PIC approval under the release policy, with owner and target date. Severity alone does not automatically authorize release with an open defect.*

| Punch Item # | Module / Screen | Defect Description | Severity (Sev 2/3) | Target Resolution Date (M12) |
| :---: | :--- | :--- | :---: | :--- |
| [ID] | [module/screen] | [defect and evidence] | [severity] | [owner + target date + mitigation] |

---

## 5. Signatures of the Parties

Use the signature method and record-retention process agreed by the parties. Any legal effect is governed by the applicable contract and jurisdiction.

| Approved by Client Single PIC | Validated by Lead Software Engineer |
| :--- | :--- |
| **Name**: _________________________ | **Name**: _________________________ |
| **Title / Role**: [Product Owner / IT Manager] | **Title / Role**: Independent Lead Software Engineer |
| **Company**: [Client Company Name] | **Date**: _________________________ |
| **Date**: _________________________ | **Signature**: |
| **Signature**: | |
