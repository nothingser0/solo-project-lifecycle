# M00-Lite: Rapid Market Validation (Solo SaaS & Self-Initiated)

> **Fixture, not a deliverable.** CI copies this file to `<project>/docs/pm/M00_LITE.md`
> to prove the M00 gate accepts a correctly-evidenced report.
>
> Why it lives here instead of inline in `ci.yml`: the mock used to be embedded as a
> shell heredoc whose lines sat at column 0. A YAML block scalar (`run: |`) ends at the
> first line less indented than its content, so the workflow file stopped parsing at
> that point — the CI workflow was invalid and had never run. It was also duplicated
> once for the bash job and once for the PowerShell here-string (where the closing
> `'@` must sit at column 0, a requirement YAML cannot satisfy either).
>
> Keep the field names and section headings exactly as below: the gate parses them.

## 1. Project Metadata & Problem Pitch

- **Project Codename**: MockApp
- **Target User**: Independent creators and micro-retail store owners
- **Core Pain**: Time lost tracking receipts and calculating manual reconciliations
- **Proposed Solution**: Automated receipt scanning app with offline sync capability
- **Proposed Price Point**: Rp 150000 / month
- **Validation Lead**: Test Lead
- **Date**: 2026-10-11

## 2. Riskiest Assumption Register (RAT)

| ID | Core Hypothesis | Risk Level | Evidence Needed | Cheap Test Method | Kill Threshold | Outcome |
|:---|:---|:---:|:---|:---|:---|:---:|
| **ASM-01** | Users lose measurable revenue each month | HIGH | 3/5 confirm loss | Deep interviews | <2 respondents | [x] |
| **ASM-02** | Users will pay for automated capture | HIGH | Waitlist with price anchor | Landing page | <2.0% | [x] |

## 3. Quick Competitor & Alternative Check

| Solution Name | Type | Price / Tier | Strengths | Critical Weaknesses | Unique Differentiator We Offer |
|:---|:---|:---|:---|:---|:---|
| Competitor X | Direct SaaS | Rp 200k/mo | Established brand | Offline sync broken | 100% offline first sync |

## 4. Qualitative User Discovery (5 User Interviews)

| Respondent ID | Role / Business Type | Current Solution | Biggest Friction / Loss | Willingness to Pay | Evidence Status |
|:---|:---|:---|:---|:---|:---:|
| **INT-01** | Boutique Owner | Paper Receipts | Missing tax deductions | Rp 100k/mo | ✅ Real |
| **INT-02** | Freelancer | Spreadsheet | Formula breakage | Rp 100k/mo | ✅ Real |
| **INT-03** | Agency Founder | SaaS Tool X | Overpriced seat model | Rp 150k/mo | ✅ Real |

## 5. Behavioral Intent Validation (Waitlist / Smoke Test)

- **Total Unique Visitors**: 120
- **Total Waitlist / Email Signups**: 9
- **Waitlist-Conversion-Pct**: 7.5
- **Intent-to-Buy-Pct**: 0
- **Alternative-Proof**: deposits: 0 | loi: 0

## 6. Unit Economics & Pricing Feasibility

- **Acquisition Cost (CAC)**: Rp 15,000 / user
- **Lifetime Value (LTV)**: Rp 900,000 / user
- **LTV / CAC Ratio**: 60x (Target: >= 3x)
- **Gross Margin**: 85%

Validated-by: Test Lead on 2026-10-11

## 7. Kill Criteria & Gate Validation Outcome

1. Market Kill: waitlist conversion < 2.0% after >=100 targeted visitors
2. Feasibility Kill: MVP exceeds 6 weeks for one developer
3. Regulatory Kill: business model requires a banking licence

Gate-Decision: PASS
