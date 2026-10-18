# Tsilverberg WebApp UAT & Full Browser Testing Pattern

> **Module**: M07 (Quality Assurance & SIT) & M09 (UAT & Signoff)  
> **Source**: Adapted from tsilverberg WebApp UAT skill (`tsilverberg/webapp-uat`).  
> **Scope**: Full browser User Acceptance Testing (UAT) using Playwright with automated error capture, accessibility checks (WCAG 2.2 AA), i18n validation, responsiveness overflow checks, and severity-based bug triage.

---

## 1. Automated UAT Capabilities
1. **Error Capture**: Real-time console error logging, network failure tracking, and page crash detection (`setupErrorCapture`).
2. **Accessibility (a11y) & i18n Checks**: Automated verification of WCAG 2.2 AA basics (headings, landmarks, ARIA, forms) and broken/unresolved i18n translation keys.
3. **Layout & Data Validation**: Detection of empty/placeholder data fields and responsive mobile layout overflows.

---

## 2. Bug Triage & Severity Classification
- **P0 Blocker**: Complete app load failure, data loss, or screen failure.
- **P1 High**: Broken features, incorrect data displayed, or accessibility barriers.
- **P2/P3**: Visual glitches, fallback data, cosmetic warnings, or console logs.
