# M03 Deep Dive: Legal SOW & Charter — Extended Material

## Contents

- [1. Enterprise Advisory Gate (Phase A00) — Full Detail](#1-enterprise-advisory-gate-phase-a00-full-detail)
- [2. Legal Document Hierarchy (Full)](#2-legal-document-hierarchy-full)
- [3. Clause Drafting Notes (Operational Drafts)](#3-clause-drafting-notes-operational-drafts)
- [4. Payment & Leverage Detail](#4-payment-leverage-detail)
- [5. Commercial Estimation Inputs](#5-commercial-estimation-inputs)


Companion to [`../03_LEGAL_SOW_CHARTER.md`](../03_LEGAL_SOW_CHARTER.md). Reference links: `references/pre-sales/QUOTATION_EMAIL.md`, `templates/03-governance/EXECUTIVE_DECK_TEMPLATE.md`, `MEETING_CADENCE_GUIDE.md`, `VENDOR_COMPARISON_MATRIX.md`, `templates/02-legal-commercial/FINANCIAL_TRACKING.md`.

> ⚠️ All AI-drafted legal content is an operational engineering draft requiring professional legal review before signature.

## 1. Enterprise Advisory Gate (Phase A00) — Full Detail

**Solo capacity limitation enforcement**: projects with >25 P0 features (Enterprise tier), legacy core replacements, or explicit formal external audit/certification/sector approval obligations **exceed solo developer capacity**. Baseline privacy duties such as UU PDP are scoped as delivery safeguards. Do NOT sign a monolithic development SOW. The commercial instrument is the **Consulting Agreement** (`templates/00-pre-sales-enterprise/CONSULTING_AGREEMENT_TEMPLATE.md`) under Phase A00.

Governance & compliance templates for A00–A04:

**Compliance & data protection (UU PDP 27/2022)**:
- `templates/03-governance/DATA_PROTECTION_ADDENDUM.md` — controller/processor terms
- `templates/03-governance/DATA_CLASSIFICATION_POLICY.md` — Public/Internal/Confidential/Restricted handling
- `templates/08-maintenance-ops/SLA_SLO_DEFINITIONS.md` — 99.9% uptime, <200ms p95, incident response SLA

**Risk & stakeholders**:
- `templates/03-governance/RISK_ASSESSMENT_MATRIX.md` — Probability × Impact scoring with mitigation tracking
- `templates/03-governance/STAKEHOLDER_REGISTER.md` — Power/Interest matrix; decision makers beyond Single PIC
- `templates/03-governance/COMMUNICATION_PLAN.md` — info flow for executives / steering committee
- `templates/03-governance/ESCALATION_MATRIX.md` — P0–P4 severity, response times, escalation contacts

**Financial & decision tracking**:
- `templates/02-legal-commercial/FINANCIAL_TRACKING.md` — budget, burn rate, milestone forecasting
- `templates/03-governance/RACI_MATRIX.md` — RACI for major contract decisions

**Advisory Gate = Consulting Agreement signed + Retainer confirmed + Risk Assessment Matrix approved + RACI Matrix confirmed** (handled via Phase A00, never a development SOW).

## 2. Legal Document Hierarchy (Full)

1. **MSA**: enduring legal principles — IP ownership, limitation of liability, dispute resolution, governing law. Prevails on legal conflict unless the SOW explicitly overrides.
2. **SOW**: deliverables, milestones, payment schedules, technical specifications for a specific phase.
3. **DPA**: personal data processing, controller/processor roles, breach notification per UU PDP 27/2022.
4. **NDA**: proprietary technical/business data exchange during pre-sales and execution.

## 3. Clause Drafting Notes (Operational Drafts)

**Single PIC clause (sample wording)**:
> "All instructions, design approvals, UAT results, and document signings are valid only if issued or signed off by the designated Client Single PIC. Verbal instructions or written requests from client staff outside the designated Single PIC hold no binding authority over the Developer."

**Liability cap (sample wording)**:
> "The Developer is not liable for indirect damages, loss of business profit, or data breaches caused by client employee negligence in storing passwords. The Developer's maximum financial liability under any circumstance is capped at the total contract value actually paid by the Client."

**CR formula**: `Additional Fee = Estimated Hours × Hourly Rate`; `Release Schedule Extended by X Days`. Every CR recorded on the CR sheet (`templates/02-legal-commercial/CHANGE_REQUEST_TEMPLATE.md`) — never negotiated ad-hoc in WhatsApp. Scope defense starts in M03, before coding.

**Deemed Acceptance**: if the client provides no feedback for 7 calendar days after a milestone demo, the milestone is deemed accepted (anti-ghosting leverage). Mirrors the UAT clause in M09: *"If the Client does not perform testing or provide written defect notes within 10 (ten) business days from delivery of the Staging link, the software shall be legally considered fully accepted (Deemed Accepted)."*

**Revision limits**: cap design revisions and UAT cycles (max 2 UAT rounds per commercial contract; cosmetic Severity 3/4 defects may not block sign-off and defer to warranty).

**Third-party account rule**: cloud hosting, WhatsApp APIs, and payment gateway credentials must be registered under the Client's corporate name and billed directly to the Client — never paid with the developer's credit cards. Protects against hostage situations at handover and keeps vendor ToS liability with the account owner.

## 4. Payment & Leverage Detail

- Standard **30/40/30**: DP 30% at signing (prerequisite to any technical research/UI-UX), 40% at staging demo of core P0 flows (before UAT entry), 30% at UAT pass — payable **before** DNS pointing and BAST handover (`SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md:111`).
- **50/50** only for Small fast-track client projects (50% DP / 50% at BAST).
- Leverage-safe handover: developer deploys to developer-controlled production/preview for PVT and produces `GO_LIVE_REPORT.md`; pointing `app.client.com` and transferring master cloud/repo credentials is held as commercial leverage until 100% final payment clears (M11).
- e-Meterai (Rp 10,000) for Medium+ Indonesian contracts; wet-ink alternative; corporate legal review for Large.

## 5. Commercial Estimation Inputs

- Fixed-price: add 20–30% contingency to the quoted milestone sum to absorb reasonable revision rounds.
- T&M/retainer: bill monthly or per 40-hour block, paid upfront per period; Large-scale phased deliverables map to per-package 30/40/30 schedules.
- Cross-check contract value against M01 Model A math: Net Profit Margin ≥ healthy band and Real Hourly Yield ≥ Rp 100,000–250,000/jam before signing.
- Track milestone status/burn in `templates/02-legal-commercial/FINANCIAL_TRACKING.md` from day one.

## 6. Output Artifacts & Template Paths

Every artifact lands in `contracts/` **or** `docs/pm/` (the gate accepts either path per file).

| Artifact | When required | Template to copy |
| :--- | :--- | :--- |
| `SOW_CONTRACT.md` (Part I Charter + SOW) | Medium / Large client | `templates/01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md` |
| `SOW_SMB.md` | SMB client <50 employees | `templates/02-legal-commercial/SOW_SMB.md` |
| `NDA.md` | Medium+ before client data access (optional Small) | `templates/02-legal-commercial/NDA_TEMPLATE.md` |
| `DATA_PROTECTION_ADDENDUM.md` | whenever personal data is processed | `templates/03-governance/DATA_PROTECTION_ADDENDUM.md` |
| `SOLO_SAAS_CHARTER.md` | Solo SaaS / internal only, in place of the SOW | `templates/01-discovery-commercial/SOLO_SAAS_CHARTER_TEMPLATE.md` |
| `change-requests/CR-[YY]-[NNN].md` | one per approved change | `templates/02-legal-commercial/CHANGE_REQUEST_TEMPLATE.md` |
| `FINANCIAL_TRACKING.md` | from day one | `templates/02-legal-commercial/FINANCIAL_TRACKING.md` |
| `PROJECT_STATE.md` (M03 row + `Delivery` field) | always | `templates/essentials/PROJECT_STATE_TEMPLATE.md` |

**DP recording rule**: both SOW templates carry an **M03 Gate Confirmation Log** footer. Tick its Down Payment line and fill the date/amount/name; the receipt wording must sit on that same line. `scripts/gates/validate-gate.sh M03` reads that line — never a chat message — and `scripts/verify/lint-template.sh` fails any SOW template that drops one of the M03 hard-blocker clauses, so a shipped template can never regress into one that cannot pass its own gate.
