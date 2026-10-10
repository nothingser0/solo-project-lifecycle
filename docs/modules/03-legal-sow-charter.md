# Module 03: [COMMERCIAL GATE] Legal SOW, DP, & Single PIC Agreement

> ⚠️ **LEGAL DISCLAIMER**: This content provides general SDLC guidelines, NOT legal advice. References to PDP Law, Civil Code (KUHPerdata), and ITE Law are educational and HAVE NOT been verified by licensed Indonesian attorneys. Always consult a qualified lawyer for contract drafting, regulatory compliance, and legal matters. Framework authors assume no liability for legal decisions made based on this content.

- `references/pre-sales/QUOTATION_EMAIL.md` (Commercial email template, milestone quotation, fee breakdown)
- `templates/03-governance/EXECUTIVE_DECK_TEMPLATE.md` (Commercial presentation for enterprise sponsors & executives)
- `templates/03-governance/MEETING_CADENCE_GUIDE.md` (Stakeholder alignment schedule, commercial check-in meetings)
- `templates/03-governance/VENDOR_COMPARISON_MATRIX.md` (Vendor/subcontractor evaluation for specialized deliverables)


This module is a **BLOCKING COMMERCIAL GATE FOR CLIENT COMMERCIAL PROJECTS** in the solo developer project lifecycle. Fundamental rule for paid client work: **NOT A SINGLE LINE OF CODE OR DETAILED DESIGN IS UNDERTAKEN BEFORE PASSING THIS GATE.** (For self-initiated products, Solo SaaS, and internal tools without an external client, this commercial gate is **FORMALLY WAIVED / BYPASSED**, and development proceeds directly to Module 04).

The purpose for client engagements is to bind the `SCOPE_STATEMENT.md` document into a legally enforceable agreement, secure the Down Payment (DP), lock in a Single PIC from the client side, and establish the Change Request protocol.

---

## 1. Execution Cycle of Module 03

```text
[ INPUT: SCOPE_STATEMENT.md Document from Module 02 ]
                         │
                         ▼
[ STEP 1: Contract Model Determination & Commercial Estimation ]
  • Fixed-Price Milestone (Small & Medium Scale)
  • Time & Materials / Monthly Retainer (Large & Flexible Scale)
                         │
                         ▼
[ STEP 2: Payment Milestone Structure Locking ]
  • Milestone 1 (DP 30–50%): Prerequisite to start technical research & UI/UX
  • Intermediate Milestones (Alpha/Beta): Tied to deliverable verification
  • Final Milestone (100% Settlement): Prerequisite for repo handover & BAST
                         │
                         ▼
[ STEP 3: Binding Single PIC Clause & Response SLA ]
  • 1 Absolute Decision Maker on Client Side
  • Client Review SLA of Maximum 3 Business Days (Delays = Schedule Extension)
                         │
                         ▼
[ STEP 4: Establishing Solo Developer Legal Protection Clauses ]
  • Limitation of Liability (Liability Cap = Maximum Contract Value)
  • Source Code Ownership (IP retained until 100% paid)
  • Feature Modification Protocol (Formal Change Request / CR)
                         │
                         ▼
[ OUTPUT: SOW_CONTRACT.md (includes charter in Part I) ]
                         │
          ┌──────────────┴──────────────┐
          ▼                             ▼
    [ DP NOT YET RECEIVED ]       [ DP RECEIVED & VALID CONTRACT ]
    • DO NOT START CODING         • Commercial Gate Passed
    • Status: On-Hold             • Proceed to Module 04: UI/UX Design
```

---

## 2. Step-by-Step Execution

### Step 1: Choosing the Right Contract Model
1. **Fixed-Price (Milestone-Based Fixed Price)**:
   - *When to Use*: Scope in `SCOPE_STATEMENT.md` is crystal clear and client budget is inflexible.
   - *Solo Dev Key*: Must add 20–30% contingency buffer to mitigate reasonable revisions.
2. **Time & Materials / Monthly Retainer**:
   - *When to Use*: Client has a dynamic roadmap (*"features figured out as we go"*) or Large/Enterprise scale projects requiring ongoing research.
   - *Solo Dev Key*: Bill monthly or per 40-hour block with upfront payment at start of each period.

---

### Step 2: Establishing a Phased Payment Milestone Structure
As a solo developer, never accept payment solely at project completion (100% on delivery). Standard milestone schedule:

| Milestone | Milestone / Payment Condition | Percentage | Deliverable Prerequisite |
| :---: | :--- | :---: | :--- |
| **Milestone 1 (DP)** | Contract Signing & Project Initiation | **40%** | Handover of agreed SOW & Project Charter |
| **Milestone 2 (Alpha)** | Core Engine & Database Integration Complete | **25%** | Demo of backend functionality & basic UI on local/staging |
| **Milestone 3 (Beta)** | Complete Integration & Internal UAT Passed | **20%** | App ready for client testing on Staging (SIT Pass) |
| **Milestone 4 (Final)** | Production Go-Live & Formal Handover | **15%** | Client UAT Sign-off approved, ready for BAST handover |
*Rule: Milestone percentages MUST sum to exactly 100%. Alternative 3-phase option for smaller projects: 50% DP, 30% Beta/UAT, 20% Final.*

---

### Step 3: Enforcing the Single PIC Rule
Corporate clients often have multiple heads with conflicting directions.
- Mandatory to document name, title, email, and phone number of **1 Client Single PIC**.
- All instructions, design approvals, UAT results, and document signings are valid only if signed off by that Single PIC.
- Include the clause: *"Verbal instructions or written requests from client staff outside the designated Single PIC hold no binding authority over the developer."*

---

### Step 4: Locking Vital Legal Protection Clauses for Solo Devs
1. **Intellectual Property (IP) Rights**:
   - Source code, server credentials, and software licenses remain the exclusive intellectual property of the Developer until all milestone payments (100%) are fully settled.
2. **Limitation of Liability (Liability Cap)**:
   - The developer is not liable for indirect damages, loss of business profit, or data breaches caused by client employee negligence in storing passwords.
   - The developer's maximum financial liability under any circumstance is capped at the total contract value actually paid by the client.
3. **Change Request (CR) Mechanism**:
   - Any additional feature outside `SCOPE_STATEMENT.md` must be recorded on a CR sheet with the formula: `Additional Fee = Estimated Hours x Hourly Rate` and `Release Schedule Extended by X Days`.

---

## 3. Adaptation Based on Project Scale

| Aspect | Small Scale (MVP / Freelance) | Medium Scale (B2B SaaS / Agency) | Large Scale & Enterprise |
| :--- | :--- | :--- | :--- |
| **Contract Format** | 50% DP Invoice + Scope Statement via Email | SOW Document & Cooperation Agreement (PKS) | Master Service Agreement (MSA) + Formal SOW |
| **Legality** | Electronic signature (PDF signature) | Wet-ink signature with stamp duty / e-Meterai | Corporate legal review by client legal team |
| **DP Terms** | Mandatory 50% upfront | Minimum 30–40% upfront | Minimum 20–30% upfront (aligned with corporate SOP) |
| **NDA Clause** | Confidentiality clause within SOW suffices | Standard Non-Disclosure Agreement (NDA) | Formal Mutual NDA + strict PDP Law clauses |

---

### 🔴 Enterprise Scale: Governance & Compliance Templates

**When**: Regulated/statutory context (banking, healthcare, government), mandatory SOC 2/ISO 27001, or enterprise-scale audit requirements

**Additional M03 Requirements** (beyond SOW/Charter):

**Compliance & Data Protection**:
- `templates/03-governance/GDPR_COMPLIANCE_CHECKLIST.md` - Right to erasure, data portability, consent management (GDPR/PDP Law)
- `templates/03-governance/DATA_CLASSIFICATION_POLICY.md` - Public/Internal/Confidential/Restricted data handling rules
- `templates/08-maintenance-ops/SLA_SLO_DEFINITIONS.md` - Service levels (99.9% uptime, <200ms p95 latency, incident response SLA)

**Risk & Stakeholder Management**:
- `templates/03-governance/RISK_ASSESSMENT_MATRIX.md` - Score risks (Probability × Impact), track mitigation progress
- `templates/03-governance/STAKEHOLDER_REGISTER.md` - Power/Interest matrix, identify decision makers beyond Single PIC
- `templates/03-governance/COMMUNICATION_PLAN.md` - Who gets what info, when, via which channel (executives, steering committee)
- `templates/03-governance/ESCALATION_MATRIX.md` - P0-P4 severity levels, response times, escalation contacts

**Financial & Decision Tracking**:
- `templates/02-legal-commercial/FINANCIAL_TRACKING.md` - Budget tracking, burn rate monitoring, milestone forecasting
- `templates/03-governance/RACI_MATRIX.md` - Responsible/Accountable/Consulted/Informed for major contract decisions

**Pre-Sales (if RFP/Tender)**:
- `templates/00-pre-sales-enterprise/RFP_RESPONSE_TEMPLATE.md` - Government/corporate tender response structure

**Why These Matter**:
- **GDPR/PDP Law**: Enterprise clients demand data protection compliance before contract signing
- **SLA/SLO**: Banking/healthcare require contractual uptime guarantees (99.9%+)
- **Risk Matrix**: Corporate governance requires risk register before project approval
- **Stakeholder Register**: Enterprise projects have 10+ stakeholders beyond Single PIC (steering committee, legal, security, compliance)
- **Escalation Matrix**: Clear escalation paths prevent project delays (know who to call for P0 incidents)

**M03 Gate for Enterprise** = SOW signed + DP received + **Risk Register approved** + **RACI Matrix confirmed**

---

## 4. Output Artifacts (Deliverables)

> 📁 **ABSOLUTE FILE LOCATION RULE**:
> All Module 03 documents MUST be stored inside the **`docs/pm/`** directory (never in the root directory).

1. **`docs/pm/SOW_CONTRACT.md`**: Consolidated commercial agreement document (Project Charter + SOW) binding objectives, Single PIC, scope, fees, payment milestones, and legal clauses.

**Templates Available**:
- **Small/Medium (SMB clients)**: `templates/02-legal-commercial/SOW_SMB.md` (simplified, no legal review needed, <Rp 100M)
- **Large/Enterprise**: `templates/01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md` (full contract with comprehensive clauses)

**When to use SOW_SMB**:
- Client is small-medium business (<50 employees)
- Budget <Rp 100M
- No legal department (client won't redline)
- Straightforward project (no compliance requirements)

> 💡 **ADAPTATION FOR SELF-INITIATED PRODUCTS & SOLO SAAS (BYPASS RULE)**:
> - **Module 03 is SKIPPED / BYPASSED for Solo SaaS, Portfolio, and Internal Solo Projects** without an external paying client, as declared in `SKILL.md` (line 104 & 110) and `SCALE_WORKFLOWS.md`.
> - Do NOT fabricate fictitious client agreements, self-invoices, or fake down payment transfers with yourself.
> - Project baselines (timeline, architecture, cash runway, and fixed infrastructure budgets) are tracked directly in `docs/pm/PROJECT_STATE.md` and `docs/pm/IDEA_BRIEF.md`.
> - The commercial gate is recorded as **`WAIVED (Self-Initiated)`** in `PROJECT_STATE.md`.
> - For internal enterprise / company projects requiring internal departmental authorization, use `templates/02-legal-commercial/SOW_SMB.md` with the `[BYPASS]` flag.

---

## 5. Gate Exit Criteria

This [GATE] is declared **PASSED** if and only if:
- [ ] The `docs/pm/SOW_CONTRACT.md` document (including Part I: Project Charter) has been approved.
- [ ] The SOW contract has been signed by both Client and Developer (or approved internally for solo products).
- [ ] The Client Single PIC has been officially designated.
- [ ] **Down Payment funds (Milestone 1) have been received and confirmed in Developer's bank account** (or self-budget has been allocated).

---

### 4.1 Upfront Change Request (CR) Protocol & Leverage Defense
- **Change Requests Belong in M03**: Scope defense starts before coding. Never negotiate change requests ad-hoc in WhatsApp. The SOW must include an explicit CR template link (`templates/02-legal-commercial/CHANGE_REQUEST_TEMPLATE.md`).
- **Deemed Acceptance Enforcement**: Protect solo developers against ghosting clients. If client feedback is absent for 7 calendar days post-demo, the milestone is deemed accepted by law.
- **Third-Party Account Rule**: Cloud hosting, WhatsApp APIs, and payment gateway credentials must be owned by the client, never paid with developer credit cards.
- **Legal Draft Disclaimer**: All legal contracts and clauses generated by AI agents represent operational engineering drafts and **MUST BE MARKED AS DRAFTS REQUIRING PROFESSIONAL LEGAL REVIEW** before final signature.

---

## 🛑 [GATE] EXIT & MANDATORY STOP PROTOCOL

After `docs/pm/SOW_CONTRACT.md` (consolidated charter + contract) has been written:

### **STEP 0: FILE EXISTENCE VERIFICATION (BLOCKING CHECK)**

**MANDATORY BEFORE CONTENT VALIDATION**:

1. **Verify output file existence** using one of the following methods:
   - PowerShell: `Test-Path -LiteralPath "docs/pm/SOW_CONTRACT.md"` → must return `True`
   - Bash/Zsh: `test -f "docs/pm/SOW_CONTRACT.md" && echo "True" || echo "False"`
   - Read and verify file `docs/pm/SOW_CONTRACT.md` → must succeed without error

2. **IF FILE DOES NOT EXIST**:
   - ❌ **STOP IMMEDIATELY** - do not proceed to content validation
   - ❌ **DO NOT present summary** to user
   - ❌ **DO NOT prompt for DP confirmation**
   - ✅ **REPORT ERROR** to user:
     ```
     CRITICAL ERROR: SOW_CONTRACT.md file was not created.
     Module 03 FAILED - cannot proceed to Module 04 (UI/UX Design).
     
     Possible causes:
     - Write permission denied on docs/pm/ directory
     - Path typo in tool call
     - Disk full
     
     Please investigate this issue before proceeding.
     ```
   - ✅ **END TURN** and wait for user to fix issue

3. **ONLY IF FILES EXIST**: Proceed to content validation below

---

### **STEP 1: CONTENT VALIDATION & DP CONFIRMATION**

1. **STRICTLY FORBIDDEN to proceed directly or invoke tools for Module 04 within the same turn!**
2. **CONTENT VERIFICATION (Self-Verification Checklist)**:
   - [ ] Read and verify file `docs/pm/SOW_CONTRACT.md` → Confirm milestone structure documented (or BYPASS flag for internal)
   - [ ] Confirm Part I (Project Charter) section exists with baseline dates (or WAIVED for Solo SaaS)
   - [ ] Single PIC identified with official contact info (for client projects)
   - [ ] Limitation of Liability clause present (liability capped at total fees received)
3. Present a commitment summary to the user:
   - Target go-live release date
   - Payment milestone schedule & DP amount (or internal project flag)
   - Core risk boundaries
4. **END YOUR RESPONSE (END TURN)** and present the Down Payment confirmation prompt:

   ```
   📋 Commercial Gate: Down Payment Confirmation
   
   The SOW and PROJECT_CHARTER documents are complete.
   
   ❓ Has the Down Payment of [Rp X] been received in your bank account?
  
   Reply: "DP RECEIVED" / "SUDAH TRANSFER" / "PAID" to proceed to Module 04 (UI/UX Design)
         (Explicit payment receipt confirmation required; casual "ok" is not accepted as payment proof)
   Reply: BELUM / NO / NOT YET if still awaiting transfer
  
   (Self-initiated product / Solo SaaS: reply BYPASS to record commercial gate as WAIVED)
   ```

5. **Payment Confirmation Matching Logic**: Accept explicit payment confirmations (e.g., "dp received", "sudah transfer", "paid", "lunas dp" as CONFIRMED; "belum", "no", "waiting" as WAITING; "bypass", "skip", "solo saas" for self-initiated projects). Casual conversational filler (such as "ok" or "lanjut") DOES NOT count as DP receipt confirmation!
6. **DO NOT proceed to Module 04** until user confirms DP received or bypass for self-initiated projects.
7. After user confirms, log confirmation in `SOW_CONTRACT.md` footer:
   ```markdown
   ---
   ## Gate Confirmation Log
   - **DP Confirmed**: [YYYY-MM-DD HH:MM WIB]
   - **Confirmed By**: [User Name]
   - **Next Module**: 04 (UI/UX Design & Prototyping)
   ```
8. Wait for explicit approval from user before proceeding to Module 04.
