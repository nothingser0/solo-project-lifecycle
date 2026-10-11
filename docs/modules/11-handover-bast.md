# Module 11: [HANDOVER GATE] Final Settlement, Training, BAST, & Repository Handover

> - `templates/07-release-handover/BAST_EMAIL_SMALL.md` (Email-based lightweight BAST confirmation for remote/small projects)
> - `templates/07-release-handover/TRAINING_PLAN.md` (Client staff operational training curriculum & schedule)

This module is the **CLOSURE & HANDOVER GATE** in the solo developer project lifecycle. Absolute rule: **TRANSFERRING GIT REPOSITORY OWNERSHIP, SERVER ROOT CREDENTIALS, AND SIGNING THE BAST ARE STRICTLY PROHIBITED BEFORE THE FINAL SETTLEMENT PAYMENT (100%) HAS CLEARED AND IS CONFIRMED IN THE DEVELOPER'S BANK ACCOUNT.**

The objective is to conduct operational training for client staff within a metered quota, hand over user manual documentation (`USER_MANUAL.md`), securely transfer repository ownership, secure final settlement payment, and execute a legally binding **Berita Acara Serah Terima (BAST - Official Handover Certificate)** that marks the commencement of the Warranty Period (Module 12).

---

## 1. Module 11 Execution Cycle

```text
[ INPUT: System Live in Production & GO_LIVE_REPORT.md from Module 10 ]
                                    │
                                    ▼
[ STEP 1: Final Settlement Invoice Issuance (Milestone 3: 30% / atau 50% pada Small Fast-Track) ]
  • Issue Final Settlement Invoice Based on Go-Live Verification Proof
  • Provide Payment Due Date According to SOW (Maximum 7 Business Days)
  • **CRITICAL SEQUENCE**: 100% payment RECEIVED → THEN point official client DNS & proceed to training
                                    │
                                    ▼
[ STEP 2: User Training (Client Training & Onboarding) ]
  • **PREREQUISITE**: Confirmation of 100% payment received before starting training
  • Limited Session Quota: 1x Operational Staff Session & 1x Super Admin Session
  • Record Concise Video Tutorials & Hand Over USER_MANUAL.md Document
  • Additional Sessions Beyond Quota Must Incur Extra Training Fees
                                    │
                                    ▼
[ STEP 3: [GATE] Cash Flow Gate (Payment-Gated Verification) ]
  • Check Developer Bank Account Statement
  • FINAL SETTLEMENT RECEIVED IN FULL ──► Proceed to Step 4
  • FUNDS NOT YET RECEIVED ──► HOLD REPO TRANSFER & ROOT SERVER ACCOUNTS
                                    │
                                    ▼
[ STEP 4: Repository Ownership Transfer & Encrypted Credentials ]
  • Transfer GitHub/GitLab Repository Ownership to Client Organization
  • Hand Over Production Credentials via Encrypted Channels (Bitwarden/1Password)
                                    │
                                    ▼
[ STEP 5: Signing Official Handover Certificate (Valid BAST) ]
  • Print BAST Document with Sufficient Duty Stamp (Meterai Rp 10,000) or Peruri e-Meterai
  • Co-signed by Client Single PIC & Developer
  • Official Trigger: Bug Fix Warranty Period (Module 12) Begins
                                    │
                                    ▼
[ OUTPUT: Signed BAST, Transferred Repository, & 100% Paid in Full ]
```

---

## 2. Solo Developer Handover Golden Rule: "No Pay, No Root"

### Why Is This Discipline Absolute?
In many client companies (especially Mid-scale and Corporate), the finance department often delays final milestone payments for weeks if their technical team already holds full control over the code repository and servers.

The solo developer's only bargaining leverage to ensure invoices are paid in full is **control over infrastructure root accounts and repository ownership**.

### Safe Staged Handover Protocol:
1. **At Go-Live (Module 10)**: Grant client access only as **Standard User / Operational Admin** within the web application (`app.client.com`), not the cloud provider root account or GitHub admin.
2. **While Awaiting Payment**: The system can already be used by client staff for daily operations, but the Developer retains infrastructure access rights.
3. **After 100% Payment Has Cleared**: Only then perform Git repository ownership transfer and hand over database/cloud root passwords.

---

## 3. Step-by-Step Execution

### Step 1: User Training Session (Training Quota Management)
To prevent the solo developer from being turned into an indefinite free operational helpdesk:
- **Standard Quota**: Maximum **2 online meeting sessions** (@ 60 minutes via Zoom/Google Meet):
  - *Session 1*: Staff daily operational workflow (Data entry, document creation, approval flow).
  - *Session 2*: Super Admin system management (User management, access permissions, audit trail, data export).
- **Training Assets**: Record the training sessions and deliver the recordings alongside the **`USER_MANUAL.md`** file so future new client staff can onboard independently without contacting the developer again.

### Step 2: Credential Handover Protocol (Zero Plaintext Sharing)
Sending server passwords, database master keys, or API secrets via WhatsApp chat or unencrypted plaintext email is strictly prohibited.

**Template**: `templates/07-release-handover/CREDENTIALS_VAULT.md` (1Password/Bitwarden setup guide)

- Use secure one-time channels such as **Bitwarden Send**, **1Password**, or **Yopass** (encrypted links that automatically self-destruct after being opened once).
- **Recommended**: Set up shared vault (1Password/Bitwarden) for permanent credential access during warranty period
- Summarize the inventory of handed-over accounts in the **`HANDOVER_PROTOCOL.md`** file.

**Credentials to hand over**:
- Production admin login
- Staging admin login  
- Database credentials
- API keys (payment, email, storage)
- Hosting/cloud provider access
- Domain/DNS management
- Git repository access

**Best Practice**: Client changes all passwords within 7 days post-handover for security ownership transfer.

### Step 3: Git Repository Ownership Transfer
1. Go to GitHub / GitLab project settings:
   - Select **"Transfer Ownership"** $\to$ Enter the Client organization account name.
2. Ensure the Client promotes their designated technical Single PIC as the new Owner.
3. Remove your Personal Access Tokens (PAT) from the client's CI/CD settings and replace them with tokens owned by the client organization.

### Step 4: Formal BAST Signing
1. Prepare the **`BAST_TEMPLATE.md`** document containing:
   - Breakdown of handed-over deliverables (Git source code, live URL, User manual).
   - Sign-off confirming the system has been properly accepted.
   - Formal statement of the start and end dates of the **Warranty Period (Module 12)**.
2. Affix a physical Rp 10,000 duty stamp (meterai) (or official e-Meterai) and co-sign with the Client Single PIC.

---

## 4. Adaptation by Project Scale

| Handover Parameter | 🔵 Small Scale (Fast-Track Client) | 🟢 Medium Scale (B2B SaaS / Agency) | 🟡 Large Scale (Multi-Department) | 🔴 Enterprise (Non-Solo Capacity) |
| :--- | :--- | :--- | :--- | :--- |
| **Training Session** | 1 brief session via Google Meet (optional) | 2 structured sessions (Staff & Admin) | Multi-session per department + LMS Recording | Pengawasan kurikulum onboarding vendor klien |
| **User Guide** | 1-page Quickstart Guide Markdown | Formal `USER_MANUAL.md` document | Complete User Manual PDF + OpenAPI API Docs | Standar dokumentasi teknis enterprise |
| **Account Transfer** | Invite admin via Vercel/DB dashboard | Git repo transfer + Vault Credentials | Cloud Tenant Transfer + Handover Protocol | Serah terima tata kelola & audit arsitektur |
| **BAST Document** | `BAST_EMAIL_SMALL.md` / email BAST | Official BAST with Rp 10,000 duty stamp | BAST + Wajib `HANDOVER_PROTOCOL.md` | Advisory Handover Dossier (Fase A00) |

---

## 5. Post-Project Retrospective (Optional - Internal Only)

After handover completion and final payment clearance, conduct internal retrospective using **`templates/08-maintenance-ops/PROJECT_RETROSPECTIVE_TEMPLATE.md`** (10.74 KB):

**Purpose**: Capture lessons learned for continuous skill improvement and process refinement.

**Structure**:
- **What went well**: Successful practices, tools, workflows to repeat
- **What went wrong**: Mistakes, blockers, technical debt sources
- **Lessons learned**: Concrete takeaways and action items
- **Process improvements**: Changes to templates, workflows, or client communication for next project

**Audience**: Internal team only (not client-facing)  
**Duration**: 1-2 hours self-reflection or team discussion  
**Output**: Retrospective notes stored in project archive for future reference

**When to use**: All scales. Recommended after every project to build systematic improvement habits.

---

## 6. Output Deliverables

> 📁 **ABSOLUTE FILE LOCATION RULES**:
> - User manual must be stored in **`docs/USER_MANUAL.md`** (or at the project root for easy staff access).
> - Handover transfer reports and BAST documents MUST be stored in the **`docs/pm/`** folder.

This module produces official closing documents:
1. **`docs/USER_MANUAL.md`**: Operational guide for administrators and system users (using `templates/07-release-handover/USER_MANUAL_TEMPLATE.md`).
2. **`docs/pm/HANDOVER_PROTOCOL.md`**: Technical handover report for Git repository ownership transfer, inventory of handed-over accounts, and authority delegation checklist (using `templates/07-release-handover/HANDOVER_PROTOCOL_TEMPLATE.md`).
3. **`docs/pm/BAST.md`**: Official Handover Certificate (BAST) with Rp 10,000 duty stamp transferring software license/ownership rights and activating the warranty period (using `templates/07-release-handover/BAST_TEMPLATE.md`; for remote/small projects: `templates/07-release-handover/BAST_EMAIL_SMALL.md`).
4. **Proof of 100% Payment Clearance**: Bank statement confirmation verifying receipt of the final milestone payment.

---

## 7. [GATE] Exit Criteria

[GATE] Module 11 is declared **PASSED** if:
- [ ] **Final settlement funds (100%) have cleared and are confirmed in the Developer's bank account.**
- [ ] Staff and admin training sessions have been conducted according to the agreed quota.
- [ ] Git repository and production credentials have been transferred to the Client organization.
- [ ] Document `docs/USER_MANUAL.md` has been delivered to the client.
- [ ] **Official stamped BAST document (`docs/pm/BAST.md`) has been signed by both parties.**

---

## 🛑 [GATE] EXIT & MANDATORY STOP PROTOCOL

After BAST signing and asset handover:

### **STEP 0: FILE EXISTENCE VERIFICATION (BLOCKING CHECK)**

**MANDATORY BEFORE CONTENT VALIDATION**:

1. **Check output file existence** using one of the following methods:
   - PowerShell: `Test-Path -LiteralPath "docs/pm/BAST.md"` → must return `True`
   - Read and verify file `docs/pm/BAST.md` → must succeed without error

2. **IF FILE DOES NOT EXIST**:
   - ❌ **STOP IMMEDIATELY** - do not proceed to content validation
   - ❌ **DO NOT display summary** to user
   - ❌ **DO NOT prompt confirmation** to proceed to Module 12
   - ✅ **REPORT ERROR** to user:
     ```
     CRITICAL ERROR: File BAST.md was not created.
     Module 11 FAILED - cannot proceed to Module 12 (Warranty & SLA).
     
     Probable causes:
     - Write permission denied on docs/pm/ folder
     - Path typo in tool call
     - Disk full
     
     Please investigate this issue before proceeding.
     ```
   - ✅ **END TURN** and wait for user to fix issue

3. **ONLY IF FILE EXISTS**: Proceed to content validation below

---

### **STEP 1: CONTENT & PAYMENT VALIDATION**

1. **STRICTLY FORBIDDEN to close the session or call tools for Module 12 within the same turn!**
2. **Verify BAST content & payment**:
   - [ ] Read and verify file `docs/pm/BAST.md` → Confirm signature + duty stamp + warranty period
   - [ ] Confirm payment 100% received (bank statement or screenshot)
   - [ ] Confirm repo transferred to client organization
   - [ ] Confirm credentials handed over securely
3. Display project closure summary:
   - Confirmation of signed stamped BAST
   - Official warranty start and end dates
   - Maintenance package offering (Monthly Retainer SLA)
4. **END YOUR RESPONSE (END TURN)** and prompt the user for confirmation:
   > *"The project has been officially handed over and closed (BAST signed). The official warranty period runs from today until [End Date] (Duration: 30 days for small scale / 60 days for mid-scale / 90 days for large scale). Would you like to draft the warranty policy and Monthly Retainer SLA proposal (Module 12)?"*
5. Wait for explicit user confirmation before proceeding to Module 12.
