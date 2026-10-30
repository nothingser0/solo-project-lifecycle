# System Integration Testing (SIT) Workbook

> Combined system integration test plan and completion evidence report for the Staging environment prior to Client UAT.

---

## PART I: SIT TEST PLAN

### 1. Test Metadata
- **System Name**: [Application Name]
- **Test Environment**: Staging Server (`https://staging.[client-domain].com`)
- **Person in Charge / Solo QA & Dev**: [Your Name]
- **Target Execution Date**: [YYYY-MM-DD]
- **Document References**: FSD-[ID] v1.0, PRD-[ID] v1.0, & Wireflow Scenarios (`docs/specs/wireflows/`)

---

### 2. Testing Scope

#### In-Scope
List only integrations and critical user journeys in the locked FSD, threat model, and acceptance criteria. For each, record its requirement/scenario ID and environment. The examples in the matrix below are optional, not assumed project features.

#### Out-of-Scope
- Load beyond the agreed workload/capacity target (unless explicitly in scope).
- Physical hardware testing of client office network.

---

### 3. SIT Test Matrix

| Test ID | Requirement / risk ID | Module / Service | Test Scenario | Expected Result | Applicability (Y/N + reason) | Result (PASS / FAIL / BLOCKED / N/A) | Evidence |
| :---: | :--- | :--- | :--- | :--- | :--- | :---: | :--- |
| SIT-01 | [ID] | [API / core flow] | [Valid and invalid contract cases] | [FSD / acceptance criteria] | [Y/N + reason] | [record after execution] | [command / artifact] |
| SIT-02 | [ID] | [Authorization boundary] | [Access as a distinct unauthorized principal, if applicable] | [No unauthorized data or side effect] | [Y/N + reason] | [record after execution] | [command / artifact] |
| SIT-03 | [ID] | [Third-party integration] | [Success, failure, timeout/retry behavior, if applicable] | [FSD contract] | [Y/N + reason] | [record after execution] | [sandbox evidence] |
| SIT-04 | [ID] | [Webhook / async delivery] | [Invalid signature and duplicate delivery, if applicable] | [Reject unauthenticated delivery; idempotent effect] | [Y/N + reason] | [record after execution] | [request IDs / logs] |
| SIT-05 | [ID] | [Data lifecycle] | [Create/read/update/delete and boundary cases] | [Expected state and data isolation] | [Y/N + reason] | [record after execution] | [query / assertion] |

Add rows for every in-scope P0 acceptance criterion and material threat scenario. Every N/A needs a reason; a blocked or untested applicable row prevents SIT PASS. Never pre-mark a template row as passed.

---

### 4. Entry & Exit Criteria
- **Entry Criteria**: The identified staging build matches the M06 handoff; the selected stack's static checks and required local tests pass.
- **Exit Criteria**:
  - Every applicable scenario is **PASS**; N/A rows have a reason; no applicable row remains blocked or untested.
  - Free of Critical/Blocker severity bugs.
  - Part II (SIT Report) published and ready for review to unlock Client UAT.

---

## PART II: SIT REPORT

### 1. Report Metadata
- **System Name**: [Application Name]
- **Staging Build Version**: `v0.9.0-rc1` (Commit: `[git-hash]`)
- **Staging Server URL**: `https://staging.[client-domain].com`
- **Testing Completion Date**: [YYYY-MM-DD]
- **Tester / Lead Engineer**: [Your Name]
- **Final Testing Status**: [SIT PASS - READY FOR UAT / NOT READY]

---

### 2. Execution Summary

| Test Category | Total Scenarios | Passed | Failed | Pass Rate |
| :--- | :---: | :---: | :---: | :---: |
| **Unit & Logic Tests** | [count] | [count] | [count] | [calculate] |
| **API Contract Tests** | [count] | [count] | [count] | [calculate] |
| **Applicable Third-Party Integrations** | [count] | [count] | [count] | [calculate] |
| **Security Scenarios** | [count] | [count] | [count] | [calculate] |
| **TOTAL** | [count] | [count] | [count] | [calculate] |

---

### 3. Third-Party Integration Testing Details

For each applicable integration, record provider/environment, build identity, scenario IDs, request/correlation IDs, observed result, and evidence path. Record N/A and why when no integration exists. Do not copy example provider names or results into the report.

---

### 4. Load & Concurrency Test Results (Load Test Metrics)

Testing Tool: [tool/version or N/A with reason]
- **Workload / concurrency / duration**: [M02 target and observed run]
- **Requests processed**: [observed]
- **Latency percentiles and threshold**: [observed vs M02 budget]
- **Error rate and threshold**: [observed vs M02 budget]
- **Resource / dependency saturation and recovery**: [observed]

---

### 4b. Automated Test Coverage (Large / Enterprise scale mandatory)

Report the selected stack's coverage command and actual output, if coverage is required by project scale or risk:
- **Line Coverage**: [observed % / N/A with reason]
- **Branch Coverage**: [observed % / N/A with reason]

> Small / Medium scale: no strict threshold — report actual numbers for transparency.

### 4c. Core Web Vitals (web surfaces only)

Record routes in M02's performance scope and identify any representative route grouping. Include the measurement source, device segment, build/URL, and evidence. Prefer field data at the 75th percentile, segmented by mobile and desktop. When field data is unavailable, label the result as lab data and preliminary; a lab score does not establish field compliance. Compare against M02 budgets or, when none exist, the current default good thresholds: LCP ≤2.5 s, INP ≤200 ms, CLS ≤0.1. Source: [web.dev Core Web Vitals thresholds](https://web.dev/articles/defining-core-web-vitals-thresholds).

| Route / surface | Device segment | Data type + source | LCP (≤2.5 s) | INP (≤200 ms) | CLS (≤0.1) | Result / evidence |
| :--- | :--- | :--- | :---: | :---: | :---: | :--- |
| [route or N/A — no web UI] | [mobile / desktop] | [field p75 / lab + tool] | [value] | [value] | [value] | [status + evidence path] |

### 4d. Native Mobile QA (native apps only)

For an iOS/Android app, list supported platforms and representative OS/device coverage. Include critical user flows and applicable permission, deep-link, background/resume, offline/recovery, and notification behavior. Record the selected runner and exact command; do not require multiple overlapping frameworks. Web-only projects record `N/A — no native mobile app` and why.

| Platform / OS / device | Critical flow or native behavior | Runner / command | Result | Evidence |
| :--- | :--- | :--- | :---: | :--- |
| [iOS / Android or N/A with reason] | [scenario] | [tool + command/version] | [PASS / FAIL / BLOCKED / N/A] | [artifact / run link] |

---

### 5. Gate Recommendation

Based on all technical test results, third-party system integrations, security audits, and load testing above:

**Conclusion**: [SIT PASS / NOT READY / PASS WITH RELEASE RISKS]. Base this on executed scenarios and evidence; do not claim overall security or release readiness from this workbook alone.

If and only if the conclusion is SIT PASS and all applicable exit criteria are evidenced, recommend **User Acceptance Testing (UAT)** with the designated client reviewer in the staging environment. Otherwise record the blocking gaps and do not recommend progression.

---

### 6. SIT Sign-Off Sheet

| Solo Lead Engineer | Client Single PIC (Review) |
| :--- | :--- |
| **Name**: _________________________ | **Name**: _________________________ |
| **Title / Role**: Independent Lead Engineer | **Title / Role**: _________________ |
| **Date**: _________________________ | **Date**: _________________________ |
| **Signature**: | **Signature**: |
