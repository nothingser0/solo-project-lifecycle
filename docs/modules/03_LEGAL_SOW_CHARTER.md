# Module 03: [COMMERCIAL GATE] Legal SOW, DP, & Single PIC Agreement

> **Templates to copy**: `templates/01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md` (Medium/Large) · `templates/02-legal-commercial/SOW_SMB.md` · `CHANGE_REQUEST_TEMPLATE.md`

> ⚠️ **LEGAL DISCLAIMER**: General SDLC guidance, NOT legal advice. AI-drafted contracts are operational drafts **requiring professional legal review before signature**.

**Purpose**: BLOCKING commercial gate for client projects. **Not a single line of code or detailed design before this gate passes.** Binds `SCOPE_STATEMENT.md` into an enforceable agreement, secures the Down Payment (DP), locks a Single PIC, and establishes the CR protocol. For Solo SaaS / internal tools without an external paying client, this gate is **FORMALLY WAIVED** (no fictitious clients or fake DP transfers; record `WAIVED (Self-Initiated)` in `PROJECT_STATE.md`); development proceeds directly to Module 04.

---

## 1. Execution Rules

### Step 1 — Contract Model
- **Fixed-Price**: scope clear, budget inflexible. Add 20–30% contingency for reasonable revisions.
- **T&M / Retainer**: dynamic roadmap or phased Large deliverables. Bill monthly or per 40-hour block, upfront per period.

### Step 2 — Payment Milestones (never 100% on delivery)
| Milestone | Condition | % | Prerequisite |
|---|---|---|---|
| M1 (DP) | Signing & initiation | **30%** | Agreed SOW & Charter |
| M2 (Staging) | Core P0 flows live on staging | **40%** | Demo before UAT |
| M3 (Final) | UAT pass, pre-handover | **30%** | Sign-off; paid before DNS & BAST |

Percentages must sum to exactly 100%. Standard = **30/40/30**; **50/50** only for Small fast-track client projects.

### Step 3 — Single PIC Rule
Document name, title, email, phone of **1 absolute decision maker** client-side. All instructions, approvals, UAT results, and signatures are valid only from that PIC. Clause: *"Verbal instructions or written requests from client staff outside the designated Single PIC hold no binding authority over the developer."* Review SLA: max 3 business days.

### Step 4 — Legal Protection Clauses
1. **IP**: source code, credentials, licenses remain the Developer's property until 100% of milestones are paid.
2. **Limitation of Liability**: no indirect damages / lost profit / breach-from-client-negligence liability; capped at total contract value actually paid.
3. **CR Mechanism**: any feature outside `SCOPE_STATEMENT.md` → CR sheet: `Fee = Estimated Hours × Hourly Rate` + release extended by X days.
4. **Deemed Acceptance**: no client feedback for 7 calendar days post-demo = milestone accepted (anti-ghosting).
5. **Revision Limits**: cap design revisions and UAT cycles (max 2 UAT rounds per contract).
6. **Third-Party Accounts**: hosting, WhatsApp APIs, gateway accounts registered under the **Client**, never on developer credit cards.

---

## 2. Scale & Document Hierarchy

| Aspect | Small (Fast-Track) | Medium (B2B/Agency) | Large (Phased) | Enterprise (Non-Solo) |
|---|---|---|---|---|
| Format | `SOW_SMB.md` | Consolidated SOW | MSA + phased SOW | Consulting Agreement (A00) |
| Legality | e-signature | e-Meterai Rp 10k / wet ink | Legal review + e-Meterai | Procurement + Net 30 |
| Payment | 50/50 | 30/40/30 | 30/40/30 per pkg | Retainer / Net 30 |
| NDA | Clause suffices | **MANDATORY** | Mutual NDA + UU PDP | Mutual NDA + DPA |

Hierarchy on conflict: **MSA** (enduring principles) > **SOW** (deliverables, milestones, payments) > **DPA** (UU PDP roles, breach notice) > **NDA**.

**Enterprise routing**: >25 P0 features (Enterprise tier; Large 16–25 P0 stays solo-viable), legacy core replacement, or statutory compliance exceeds solo capacity — do NOT sign a development SOW. Use the Consulting Agreement under Phase A00 with Risk Assessment Matrix and RACI Matrix approved.

---

## 3. Output Artifacts

All in **`docs/pm/`**:
1. **`docs/pm/SOW_CONTRACT.md`**: consolidated agreement (Part I: Project Charter with baseline dates + SOW: scope, fees, milestones, Single PIC, legal clauses). Template: `SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md` (Medium/Large) or `SOW_SMB.md` (SMB <50 employees).

---

## 4. Gate Exit Criteria

PASSED if and only if:
- [ ] `docs/pm/SOW_CONTRACT.md` (including Part I: Project Charter) approved
- [ ] Contract signed by Client and Developer (or approved internally for solo products)
- [ ] Client Single PIC officially designated
- [ ] **Down Payment (Milestone 1) received and confirmed in the Developer's bank account** (or self-budget allocated for internal projects)

---

## 🛑 [GATE] EXIT & MANDATORY STOP PROTOCOL

### STEP 0 — File Existence Check (BLOCKING)
`test -f docs/pm/SOW_CONTRACT.md` must succeed. If missing: **STOP IMMEDIATELY** — no validation, no summary, no DP prompt. Report `CRITICAL ERROR: SOW_CONTRACT.md file was not created. Module 03 FAILED - cannot proceed to Module 04.` and END TURN.

### STEP 1 — Content Validation & DP Confirmation
1. No Module 04 (design) work until this [GATE] passes — DP confirmed or BYPASS recorded (contractual stop, SKILL.md rule 3).
2. Checklist:
   - [ ] Milestone structure documented (or BYPASS flag for internal)
   - [ ] Part I (Project Charter) present with baseline dates (or WAIVED for Solo SaaS)
   - [ ] Single PIC identified with official contact info (client projects)
   - [ ] Limitation of Liability clause present (cap = total fees received)
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
