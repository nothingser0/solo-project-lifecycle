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

**Decision authority**: Record the operational PIC's approval scope separately from the Client's authorized contract signatory. One person may hold both roles. A backup acts only under written delegation that states its scope and limits. This avoids treating project approval authority as proof of legal signing authority.

**Scope-to-contract reconciliation**: Include the approved scope document's version/date in the SOW and check each deliverable, exclusion, acceptance test, dependency, milestone, and payment trigger against it. Resolve differences before signature or record them as an approved CR.

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

## Runbook Originals (moved 2026-11-04)

Original text verbatim, so no clause is lost when a condensed step is ambiguous.

```markdown
# Module 03: [COMMERCIAL GATE] Legal SOW, DP, & Single PIC Agreement

> **Templates to copy**: `templates/01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md` (Medium/Large) · `templates/02-legal-commercial/SOW_SMB.md` · `CHANGE_REQUEST_TEMPLATE.md`

> ⚠️ **LEGAL DISCLAIMER**: General SDLC guidance, NOT legal advice. AI-drafted contracts are operational drafts **requiring professional legal review before signature**.

**Purpose**: BLOCKING commercial gate for client projects. **Not a single line of code or detailed design before this gate passes.** Binds `SCOPE_STATEMENT.md` into an enforceable agreement, secures the Down Payment (DP), locks a Single PIC, and establishes the CR protocol. For Solo SaaS / internal tools without an external paying client, this gate is **FORMALLY WAIVED** (no fictitious clients or fake DP transfers; record `WAIVED (Self-Initiated)` in `PROJECT_STATE.md`); development proceeds directly to Module 04.

---

## 1. Execution Rules

### Step 1 — Contract Model
- **Authority Enforcement on DP**: AI agents are **STRICTLY FORBIDDEN** from asserting or ticking `[x] DP Cleared` autonomously (per `docs/AUTHORITY.md`). Only the human developer may tick the DP box after directly verifying their bank statement or payment settlement.
- **Small Client Streamlining**: For Small Fast-Track client projects (< Rp 15M / ~$1,000), use `SOW_SMB.md` as a lightweight 1-2 page agreement focusing strictly on scope, 50/50 payment, single WhatsApp/email PIC, and revision boundaries.

### Step 2 — Payment Milestones (never 100% on delivery)
| Milestone | Condition | % | Prerequisite |
|---|---|---|---|
| M1 (DP) | Signing & initiation | **30%** | Agreed SOW & Charter |
| M2 (Staging) | Core P0 flows live on staging | **40%** | Demo before UAT |
| M3 (Final) | UAT pass, pre-handover | **30%** | Sign-off; paid before DNS & BAST |

Percentages must sum to exactly 100%. Standard = **30/40/30**; **50/50** only for Small fast-track client projects.

### Step 3 — Single PIC Rule
Record the operational PIC's name, title, email, phone, approval scope, and **1 official communication channel**. Record the Client's authorized contract signatory separately; one person may fill both roles. A backup may approve only within authority and limits delegated by the Client in writing. Record UAT and change-request authority explicitly. Review SLA: max 3 business days.

### Step 3a — Contract Baseline and Data Handling
Before signature, reconcile every SOW deliverable, exclusion, milestone, acceptance test, dependency, and payment trigger against the approved `SCOPE_STATEMENT.md` version. Record its version/date in the SOW; any difference is either corrected or approved through a documented CR. If personal data will be processed, complete the DPA fields for data categories, purpose, duration, subprocessors, processing locations, and cross-border access/transfers; obtain professional legal review and signatures before that processing begins. Record `DPA signed` or `DPA N/A — no personal data processed` in the M03 log. Keep legal deadlines and obligations subject to counsel review for the applicable jurisdiction and contract.

### Step 3b — Counterparty Paper Review (conditional)
Use this workflow only when a client or vendor supplies its own contract, NDA, or material terms that differ from the project templates. If no counterparty paper is involved, record `N/A` and continue. Use `templates/02-legal-commercial/CONTRACT_REVIEW_TEMPLATE.md`; identify the document version/date, parties, your represented party, governing law if stated, and the relevant project playbook. Review material clauses against that playbook, cite the exact clause/page, and record the issue in plain language, severity, likelihood, preferred position, and a fallback. If an approved position is missing, mark it `UNKNOWN — ask owner/counsel`; do not invent a legal or commercial position. Route findings as `GREEN` (routine for human confirmation), `YELLOW` (owner and/or counsel review needed), or `RED` (hold signature and escalate). These labels only route review; they do not establish that a document is safe, legally sufficient, or approved. A qualified lawyer must review legal interpretation, enforceability, unfamiliar jurisdictions, and material high-severity findings. Only the authorized human may decide or sign.

### Step 4 — Legal Protection Clauses
1. **IP**: source code, credentials, licenses remain the Developer's property until 100% of milestones are paid.
2. **Limitation of Liability**: no indirect damages / lost profit / breach-from-client-negligence liability; capped at total contract value actually paid.
3. **CR Mechanism**: any feature outside `SCOPE_STATEMENT.md` → CR sheet: `Fee = Estimated Hours × Hourly Rate` + release extended by X days.
4. **Deemed Acceptance**: no client feedback for 7 calendar days post-demo = milestone accepted (anti-ghosting).
5. **Revision Limits**: cap design revisions and UAT cycles (max 2 UAT rounds per contract).
6. **Third-Party Accounts**: hosting, WhatsApp APIs, gateway accounts registered under the **Client**, never on developer credit cards.
7. **Project Suspension & Kill Fee**: Overdue dependency or payment >10 calendar days suspends development and staging access; resuming requires a 5% administrative restart fee. Client termination without Developer default renders DP strictly non-refundable and completed TODO tasks billable prorata.
8. **Governing Law & Dispute Resolution (Jurisdiction)**: Disputes resolved via good-faith mutual deliberation (musyawarah) within 30 days. If unresolved, legal venue is bound strictly to the **District Court (Pengadilan Negeri) of the Developer's domicile**, shielding the solo engineer from out-of-town litigation costs.

---

## 2. Scale & Document Hierarchy

| Aspect | Small (Fast-Track) | Medium (B2B/Agency) | Large (Phased) | Enterprise (Non-Solo) |
|---|---|---|---|---|
| Format | `SOW_SMB.md` | Consolidated SOW | MSA + phased SOW | Consulting Agreement (A00) |
| Legality | e-signature | e-Meterai Rp 10k / wet ink | Legal review + e-Meterai | Procurement + Net 30 |
| Payment | 50/50 | 30/40/30 | 30/40/30 per pkg | Retainer / Net 30 |
| NDA | Clause suffices | **MANDATORY** | Mutual NDA + UU PDP | Mutual NDA + DPA |

**Delivery routing (the gate reads only this field)**: `solo` / `portfolio` / `internal` in `docs/pm/PROJECT_STATE.md` → gate **WAIVED** (record `WAIVED (Self-Initiated)`; complete the Solo SaaS Charter — no SOW, no DP, never a fabricated client). `client` → **always enforced**. Undeclared → fail-closed.

Hierarchy on conflict: **MSA** (enduring principles) > **SOW** (deliverables, milestones, payments) > **DPA** (UU PDP roles, breach notice) > **NDA**.

**Enterprise routing**: >25 P0 features, a legacy-core replacement, or an explicit formal external audit/certification/sector approval obligation that cannot be discharged by the developer is **non-delegable**. Baseline privacy duties, including UU PDP, still require appropriate delivery safeguards but are not by themselves a reason to route to A00. A **Large (16–25 P0) scope with no non-delegable obligation** may stay solo and still take a development SOW, provided `docs/pm/SOLO-CAPACITY-RISK-ACCEPTANCE.md` is signed and the classifier returns exit 5.

---

## 3. Output Artifacts

Written to **`contracts/`** or **`docs/pm/`** (gate accepts either path per file). Exact template paths: deep-dive §5.

1. **`SOW_CONTRACT.md`** — Charter (Part I, baseline dates) + SOW (scope, fees, milestones, Single PIC, clauses). Its **M03 Gate Confirmation Log** footer carries the DP receipt (STEP 3).
2. **`NDA.md`** — mandatory Medium+ before client data access; optional Small.
3. **`DATA_PROTECTION_ADDENDUM.md`** — when personal data is processed (UU PDP 27/2022).
4. **`change-requests/CR-*.md`** + **`FINANCIAL_TRACKING.md`** — one CR sheet per approved change; burn tracked from day one.
5. **`SOLO_SAAS_CHARTER.md`** — Solo SaaS / internal only, in place of the SOW.
6. **`PROJECT_STATE.md`** — updated `M03` row + the `Delivery` field that routes the gate.
7. **`CONTRACT_REVIEW_<document>.md`** — conditional review worksheet when counterparty paper is reviewed; record findings and their disposition, including counsel escalation where needed.

---

## 4. Gate Exit Criteria

PASSED if and only if:
- [ ] `docs/pm/SOW_CONTRACT.md` (including Part I: Project Charter) approved
- [ ] Contract signed by Client and Developer (or approved internally for solo products)
- [ ] Client Single PIC officially designated
- [ ] Operational approval authority and authorized contract signatory recorded; any backup delegation documented
- [ ] SOW scope and acceptance terms reconciled against the approved scope version
- [ ] DPA signed before personal-data processing, or explicit `N/A` recorded when none is processed
- [ ] If counterparty paper was reviewed, findings and disposition are recorded; review status does not replace the signed agreement or required legal review
- [ ] **Down Payment (Milestone 1) received and confirmed in the Developer's bank account** (or self-budget allocated for internal projects)

---

## 🛑 [GATE] EXIT & MANDATORY STOP PROTOCOL

### STEP 0 — File Existence Check (BLOCKING)
For client delivery, one of `contracts/SOW_CONTRACT.md`, `docs/pm/SOW_CONTRACT.md`, `contracts/SOW_SMB.md`, or `docs/pm/SOW_SMB.md` must exist. If none: **STOP IMMEDIATELY** — no validation, no summary, no DP prompt. Report `CRITICAL ERROR: SOW_CONTRACT.md file was not created. Module 03 FAILED - cannot proceed to Module 04.` and END TURN. (Solo SaaS / internal: skip STEP 0–1; the charter replaces the SOW and the gate is `WAIVED`.)

### STEP 1 — Content Validation & DP Confirmation
1. No Module 04 (design) work until this [GATE] passes — DP confirmed or BYPASS recorded (contractual stop, SKILL.md rule 3).
2. Checklist:
   - [ ] Milestone structure documented (or BYPASS flag for internal)
   - [ ] Part I (Project Charter) present with baseline dates (or WAIVED for Solo SaaS)
   - [ ] Single PIC identified with official contact info and Back-up PIC (client projects)
   - [ ] Limitation of Liability clause present (cap = total fees received)
   - [ ] Project Suspension & Kill Fee clause documented (overdue >10d pause, non-refundable DP)
   - [ ] Governing law & developer domicile jurisdiction clause locked
3. Present summary: go-live date, milestone schedule & DP amount (or internal flag), risk boundaries.

### STEP 2 — Gate Verification (MANDATORY)

```
[PASTE RAW OUTPUT OF: ./scripts/gates/validate-gate.sh M03]
```

**MANDATORY**: Execute `./scripts/gates/validate-gate.sh M03` (or `.ps1`). Exit 1 = incomplete; fix and re-run before declaring completion. **DO NOT proceed to Module 04 until DP is confirmed** (or bypassed for Solo SaaS).

### STEP 3 — STOP: Down Payment Confirmation Prompt

```
📋 Commercial Gate: Down Payment Confirmation

The SOW and PROJECT_CHARTER documents are complete.

❓ Has the Down Payment of [Rp X] been received in your bank account?

Reply: "DP RECEIVED" / "SUDAH TRANSFER" / "PAID" to proceed to Module 04 (UI/UX Design)
      (Explicit payment receipt confirmation required; casual "ok" is not accepted as payment proof)
Reply: BELUM / NO / NOT YET if still awaiting transfer

(Self-initiated product / Solo SaaS: reply BYPASS to record commercial gate as WAIVED)
```

**Payment matching logic**: CONFIRMED = "dp received", "sudah transfer", "paid", "lunas dp". WAITING = "belum", "no", "waiting". BYPASS = "bypass", "skip", "solo saas". Casual filler ("ok", "lanjut") does **NOT** count as DP confirmation.

After confirmation, log in the `SOW_CONTRACT.md` footer:
```markdown
## Gate Confirmation Log
- **DP Confirmed**: [YYYY-MM-DD HH:MM WIB]
- **Confirmed By**: [User Name]
- **Next Module**: 04 (UI/UX Design & Prototyping)
```
Then wait for explicit user approval before proceeding to Module 04.
```
