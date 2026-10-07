# Project Verification Plan & Gate Evaluation Protocol

> **Purpose**: Establish an objective verification framework for evaluating product requirements, technical specifications, and lifecycle gate transitions.
> **Special Protocol**: Defines explicit procedures for handling gates when **human primary research is pending** (`PENDING_PRIMARY_RESEARCH`).
> **Output Location**: `docs/pm/VERIFICATION_PLAN.md` (or `docs/qa/VERIFICATION_PLAN.md`)

---

## 1. Verification Strategy & Authority

Verification in this lifecycle framework operates across three distinct tiers:

```
[ Tier 1: Automated Verification ] ──► Unit tests, type checking, linting, link checking, script execution
[ Tier 2: Qualitative Human Research ] ──► User interviews, operator pain validation, stakeholder discovery
[ Tier 3: Behavioral Market Proof ] ──► Live waitlists, pre-orders, signed Letters of Intent (LOI)
```

> ⚠️ **RULE ON GATE EVALUATION WITHOUT PRIMARY RESEARCH**:
> - An AI agent or automated script **CANNOT EVALUATE A GATE AS PASS OR FAIL** if primary research data has not yet been collected from real humans.
> - In the absence of real user data, the gate outcome **MUST BE DECLARED AS `PENDING_PRIMARY_RESEARCH`**.
> - The agent prepares the test instruments (interview guides, screeners, surveys, tracking scripts) and awaits human execution.

---

## 2. Gate Verification Checkpoints

| Gate ID | Lifecycle Module | Verification Criteria | Evidence Required | Verification Method | Evaluation Status |
|:--------|:-----------------|:----------------------|:------------------|:--------------------|:-----------------:|
| **Gate 0** | M00 / M00-lite (Discovery) | Market need validated, intent-to-buy $\ge 30\%$ or waitlist $\ge 5\%$ | User interview transcripts, survey dataset, waitlist metrics | Human empirical review | `PENDING_PRIMARY_RESEARCH` |
| **Gate 1** | M01 (Feasibility) | 4D Feasibility $\ge 3.5/5.0$, zero fatal regulatory blockers | `IDEA_BRIEF.md`, technical spike | Architecture & compliance audit | `PENDING` |
| **Gate 2** | M02 (Scope Lock) | P0/P1 boundaries locked, RBAC matrix complete | `SCOPE_STATEMENT.md` | Stakeholder review | `PENDING` |
| **Gate 3** | M03 (Commercial) | Signed SOW/contract, down payment received | Bank transfer confirmation, signed SOW | Financial audit | `WAIVED` (if solo SaaS) |
| **Gate 4** | M04 (Design & IA) | Multi-role Sitemap complete, WCAG 2.2 AA contrast verified | `SITEMAP.md`, `DESIGN.md` | Contrast checker, screen inventory | `PENDING` |
| **Gate 5** | M05 (Specs) | Pinned package versions, database schema, API contracts | `PRD.md`, `FSD.md` | `./scripts/check-package-versions.sh` | `PENDING` |
| **Gate 6** | M06 (Harness & Code) | 100% TODO items complete, type-check 0 errors | `VERIFY_LOCAL.md`, test logs | `pnpm run test:smoke` | `PENDING` |
| **Gate 7** | M07 (SIT & Security) | 0 critical vulnerabilities, end-to-end integration PASS | `SIT_WORKBOOK.md`, audit log | Automated security scan | `PENDING` |
| **Gate 8** | M09 (Client UAT) | Formal acceptance by client or target beta users | Signed UAT signoff, zero P0 bugs | Demonstration & testing | `PENDING` |
| **Gate 9** | M10 (Production) | Production domain live, SSL valid, healthcheck 200 | `GO_LIVE_REPORT.md` | Live endpoint probe | `PENDING` |
| **Gate 10**| M11 (Handover/BAST) | 100% payment settled, BAST signed, repo transferred | Signed BAST, payment receipt | Administrative verification | `WAIVED` (if solo SaaS) |

---

## 3. Protocol for `PENDING_PRIMARY_RESEARCH` State

When a project enters or pauses at Gate 0 with pending human discovery:

### 3.1 Prerequisite Research Instruments
Before marking Gate 0 as ready for user execution, the following instruments must be staged in `docs/pm/`:
1. **Interview Script**: Tailored questions for Group A (Operators), Group B (Decision Makers), and Group C (Regulators).
2. **Survey Screener & Form**: Configured on Tally, Typeform, or Google Forms.
3. **Behavioral Smoke Test**: Waitlist landing page with pricing stated.

### 3.2 Gate Release Criteria (Moving from `PENDING` to `PASS`)
The gate moves from `PENDING_PRIMARY_RESEARCH` to `PASS` **ONLY IF**:
1. Minimum sample size is satisfied:
   - Solo SaaS (M00-lite): $\ge 5$ documented user interviews OR $\ge 5\%$ waitlist conversion ($\ge 100$ visitors).
   - Medium B2B: $\ge 8$ interviews + $\ge 30$ survey respondents.
   - Enterprise: $\ge 15$ interviews + $\ge 50$ survey respondents.
2. Verified intent-to-buy reaches $\ge 30\%$ (or waitlist conversion $\ge 5\%$).
3. Zero fatal regulatory blockers identified in the target jurisdiction.

### 3.3 Kill Criteria Action (Moving from `PENDING` to `KILL`)
If research yields:
- Intent-to-buy $< 30\%$ AND waitlist conversion $< 2\%$ after 200 visits.
- Immediate action: **HALT DEVELOPMENT**. Present pivot options to user.

---

## 4. Technical Verification Protocol (Local Dev & CI)

```bash
# Automated technical verification commands
pnpm run lint                # Linter check (0 errors)
pnpm run type-check           # TypeScript compiler check (0 errors)
pnpm run test:unit            # Unit test suite
pnpm run test:smoke           # Critical user flow smoke tests
node scripts/verify-links.js  # Documentation integrity
```

---

## 5. Verification Sign-Off

- **Verification Lead**: [Name / Solo Dev]
- **Current Gate State**: `PENDING_PRIMARY_RESEARCH`
- **Next Action**: Execute primary interviews using staged interview guide.
- **Date**: [YYYY-MM-DD]
