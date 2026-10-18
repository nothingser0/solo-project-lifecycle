# Petr Kindlmann QA Skills & AI-Augmented Quality Assurance Pattern

> **Module**: M07 (Quality Assurance & SIT) & M13 (Product Operations & Iteration)  
> **Source**: Adapted from Petr Kindlmann QA Skills (`petrkindlmann/qa-skills`).  
> **Scope**: 50 professional QA and test-automation workflows encompassing Playwright/Cypress E2E testing, risk-based test planning, test reliability healing, selector drift recovery, and AI-augmented bug triage.

---

## 1. Core QA & Automation Architecture
1. **Project Context (`qa-project-context`)**: Standardized configuration file (`.agents/qa-project-context.md`) capturing the tech stack, test frameworks, CI/CD, and quality goals read by all QA skills.
2. **Automation Execution**: Robust test suites using Playwright E2E, Cypress, API contract testing, visual regression checking, and k6 load testing.
3. **Risk-Based Testing**: Prioritization based on component impact, likelihood of failure, and regression risk scores.

---

## 2. AI-Augmented Quality Assurance
- **AI Test Generation**: Automated creation of comprehensive test matrices and assertions from PRDs and user stories.
- **Selector Drift Recovery**: Bulk offline DOM snapshot comparison and locator healing after UI refactors.
- **Flaky Test Management**: Runtime locator healing, test quarantine, and root-cause classification.
