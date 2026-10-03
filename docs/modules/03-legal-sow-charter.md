# Module 03: [COMMERCIAL GATE] Legal SOW, DP, & Single PIC Agreement

> ⚠️ **LEGAL DISCLAIMER**: This content provides general SDLC guidelines, NOT legal advice. References to PDP Law, Civil Code (KUHPerdata), and ITE Law are educational and HAVE NOT been verified by licensed Indonesian attorneys. Always consult a qualified lawyer for contract drafting, regulatory compliance, and legal matters. Framework authors assume no liability for legal decisions made based on this content.


This module is a **BLOCKING COMMERCIAL GATE** in the solo developer project lifecycle. Fundamental rule: **NOT A SINGLE LINE OF CODE OR DETAILED DESIGN IS UNDERTAKEN BEFORE PASSING THIS GATE.**

The purpose is to bind the `SCOPE_STATEMENT.md` document into a legally enforceable agreement, secure the Down Payment (DP), lock in a Single PIC from the client side, and establish the Change Request protocol.

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
[ OUTPUT: SOW_CONTRACT.md & PROJECT_CHARTER.md Documents ]
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
| **Milestone 1 (DP)** | Contract Signing & Project Initiation | **30% – 50%** | Handover of agreed SOW & Project Charter |
| **Milestone 2 (Alpha)** | Core Engine & Database Integration Complete | **25% – 30%** | Demo of backend functionality & basic UI on local/staging |
| **Milestone 3 (Beta)** | Complete Integration & Internal UAT Passed | **20% – 25%** | App ready for client testing on Staging (SIT Pass) |
| **Milestone 4 (Final)** | Production Go-Live & Formal Handover | **10% – 20%** | Client UAT Sign-off approved, ready for BAST handover |

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

## 4. Output Artifacts (Deliverables)

> 📁 **ABSOLUTE FILE LOCATION RULE**:
> All Module 03 documents MUST be stored inside the **`docs/pm/`** directory (never in the root directory).

1. **`docs/pm/SOW_CONTRACT.md`**: Consolidated commercial agreement document (Project Charter + SOW) binding objectives, Single PIC, scope, fees, payment milestones, and legal clauses (using template `templates/01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md`).

> 💡 **ADAPTATION FOR SOLO DEV PRODUCT (SELF-INITIATED/INTERNAL)**:
> If the project is a self-initiated product without an external client, commercial contracts and DP invoicing may be adapted for internal use, **HOWEVER `docs/pm/PROJECT_CHARTER.md` REMAINS MANDATORY** to lock timeline baselines, infrastructure budgets, and risk boundaries. Skipping Module 03 entirely is STRICTLY PROHIBITED!

---

## 5. Gate Exit Criteria

This [GATE] is declared **PASSED** if and only if:
- [x] The `docs/pm/PROJECT_CHARTER.md` document has been approved.
- [x] The SOW contract has been signed by both Client and Developer (or approved internally for solo products).
- [x] The Client Single PIC has been officially designated.
- [x] **Down Payment funds (Milestone 1) have been received and confirmed in Developer's bank account** (or self-budget has been allocated).

---

## 🛑 [GATE] EXIT & MANDATORY STOP PROTOCOL

After `docs/pm/PROJECT_CHARTER.md` (and `docs/pm/SOW_CONTRACT.md`) has been written:

### **STEP 0: FILE EXISTENCE VERIFICATION (BLOCKING CHECK)**

**MANDATORY BEFORE CONTENT VALIDATION**:

1. **Verify output file existence** using one of the following methods:
   - PowerShell: `Test-Path -LiteralPath "docs/pm/PROJECT_CHARTER.md"` → must return `True`
   - Bash/Zsh: `test -f "docs/pm/PROJECT_CHARTER.md" && echo "True" || echo "False"`
   - Read tool: `read_file('docs/pm/PROJECT_CHARTER.md')` → must succeed without error
   - PowerShell: `Test-Path -LiteralPath "docs/pm/SOW_CONTRACT.md"` → must return `True`
   - Bash/Zsh: `test -f "docs/pm/SOW_CONTRACT.md" && echo "True" || echo "False"`
   - Read tool: `read_file('docs/pm/SOW_CONTRACT.md')` → must succeed without error

2. **IF FILE DOES NOT EXIST**:
   - ❌ **STOP IMMEDIATELY** - do not proceed to content validation
   - ❌ **DO NOT present summary** to user
   - ❌ **DO NOT prompt for DP confirmation**
   - ✅ **REPORT ERROR** to user:
     ```
     CRITICAL ERROR: PROJECT_CHARTER.md or SOW_CONTRACT.md file was not created.
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
   - [ ] `read_file('docs/pm/PROJECT_CHARTER.md')` → Confirm baseline dates set
   - [ ] `read_file('docs/pm/SOW_CONTRACT.md')` → Confirm milestone structure documented (or BYPASS flag for internal)
   - [ ] Single PIC identified with contact info
   - [ ] Liability cap clause present
3. Present a commitment summary to the user:
   - Target go-live release date
   - Payment milestone schedule & DP amount (or internal project flag)
   - Core risk boundaries
4. **END YOUR RESPONSE (END TURN)** and present the Down Payment confirmation prompt:

   ```
   📋 Commercial Gate: Down Payment Confirmation
   
   The SOW and PROJECT_CHARTER documents are complete.
   
   ❓ Has the Down Payment of [Rp X] been received in your bank account?
  
   Reply: SUDAH / YES / YA / OK to proceed to Module 04 (UI/UX Design)
         (SUDAH = already received, YA = yes in Indonesian)
   Reply: BELUM / NO / NOT YET if still awaiting transfer
         (BELUM = not yet in Indonesian)
  
   (Solo dev internal product: reply BYPASS to skip DP gate)
   ```

5. **Fuzzy Match Logic**: Accept variations (sudah/SUDAH/yes/YES/ya/ok as CONFIRMED; belum/no/not yet as WAITING; bypass/BYPASS/skip for internal projects). Indonesian keywords kept for local client convenience.
6. **DO NOT proceed to Module 04** until user confirms DP received or bypass for internal
7. After user confirms, log confirmation in `PROJECT_CHARTER.md` footer:
   ```markdown
   ---
   ## Gate Confirmation Log
   - **DP Confirmed**: [YYYY-MM-DD HH:MM WIB]
   - **Confirmed By**: [User Name]
   - **Next Module**: 04 (UI/UX Design & Prototyping)
   ```
8. Wait for explicit approval from user before proceeding to Module 04.
