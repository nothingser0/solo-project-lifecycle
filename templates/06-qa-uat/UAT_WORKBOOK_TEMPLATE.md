# User Acceptance Testing (UAT) Workbook

> Combined UAT test scenario workbook and defect tracking log for the client acceptance testing period by Client Single PIC.

---

## PART I: UAT TEST SCENARIOS

### 1. Environment Information & Test Credentials
- **Staging Server URL**: `https://staging.[client-domain].com`
- **Testing Window**: [Start Date] to [End Date] (Maximum 7 Business Days)
- **Tester Credentials**:
  - Super Admin: `tester-admin@staging.local` / `UatTest2026!`
  - Operations Staff: `tester-staff@staging.local` / `UatTest2026!`

---

### 2. UAT Test Scenario Worksheets

#### Scenario 1: User Login & Authentication Flow
- **Scenario ID**: `UAT-SCN-01`
- **Test Objective**: Verify users can log in securely and are redirected to the appropriate dashboard.
- **Test Steps**:
  1. Open URL `https://staging.[client-domain].com/login`.
  2. Enter staff tester email and password.
  3. Click **"Log In to Account"** button.
- **Expected Result**:
  - Page redirects to Staff Dashboard (`/dashboard`).
  - Tester username is displayed in top-right corner.
  - Login session persists when browser tab is closed and reopened.
- **Client Test Result**: [ ] **PASS** / [ ] **FAIL**
- **Tester Notes**: __________________________________________________

---

#### Scenario 2: New Document Draft Creation
- **Scenario ID**: `UAT-SCN-02`
- **Test Objective**: Verify staff can fill in document template forms and the system generates an official PDF preview.
- **Test Steps**:
  1. From dashboard, click **"Create New Document"** button.
  2. Select template type **"Freelance Service Agreement"**.
  3. Fill in party names, compensation amount, and effective date fields.
  4. Click **"Generate Document Preview"** button.
- **Expected Result**:
  - Document PDF preview is displayed on browser screen within $< 5\text{ seconds}$.
  - Form data entered is accurately rendered within document clauses.
  - Document status is recorded as `DRAFT`.
- **Client Test Result**: [ ] **PASS** / [ ] **FAIL**
- **Tester Notes**: __________________________________________________

---

#### Scenario 3: Digital Signature & Document Locking
- **Scenario ID**: `UAT-SCN-03`
- **Test Objective**: Verify signers can sign documents via public links and documents are locked against modifications.
- **Test Steps**:
  1. Click **"Send Signature Link"** button to signer's email.
  2. Open confidential link received via email.
  3. Draw signature on digital canvas box, then click **"Save & Sign"**.
- **Expected Result**:
  - Successful signature confirmation screen appears.
  - Document status on dashboard automatically transitions to `SIGNED (LOCKED)`.
  - Final PDF document displays signature image and SHA-256 hash stamp in footer.
- **Client Test Result**: [ ] **PASS** / [ ] **FAIL**
- **Tester Notes**: __________________________________________________

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
| **BUG-01** | [YYYY-MM-DD] | Document Form | Date of birth cannot be selected prior to year 1980 | **Severity 2** | `CLOSED` | [YYYY-MM-DD] | [x] Verified Pass |
| **BUG-02** | [YYYY-MM-DD] | E-Sign Canvas | Clear canvas button does not reset signature strokes | **Severity 3** | `CLOSED` | [YYYY-MM-DD] | [x] Verified Pass |
| **CR-01**  | [YYYY-MM-DD] | Notifications | Client requests SMS notification integration in addition to email | **Out-of-Scope** | `TRANSFERRED TO CR` | - | Moved to CR Sheet #02 |

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

### 5. UAT Approval Sheet

After all test scenarios pass and Severity 1 & 2 bugs are resolved, Client Single PIC signs the UAT approval sheet:

| Client Single PIC | Lead Developer |
| :--- | :--- |
| **Name**: _________________________ | **Name**: _________________________ |
| **Title / Role**: _________________ | **Title / Role**: Independent Lead Engineer |
| **Date**: _________________________ | **Date**: _________________________ |
| **Signature**: | **Signature**: |
