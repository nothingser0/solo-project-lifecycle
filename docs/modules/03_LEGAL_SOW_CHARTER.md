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

---

## 4. Gate Exit Criteria

PASSED if and only if:
- [ ] `docs/pm/SOW_CONTRACT.md` (including Part I: Project Charter) approved
- [ ] Contract signed by Client and Developer (or approved internally for solo products)
- [ ] Client Single PIC officially designated
- [ ] Operational approval authority and authorized contract signatory recorded; any backup delegation documented
- [ ] SOW scope and acceptance terms reconciled against the approved scope version
- [ ] DPA signed before personal-data processing, or explicit `N/A` recorded when none is processed
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
