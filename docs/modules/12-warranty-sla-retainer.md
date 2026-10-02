# Module 12: Warranty Period & Transition to Monthly Retainer / SLA Support

>

This module is the twelfth stage (culminating phase) in the software project lifecycle for solo developers. The objective is to manage the bug fix warranty period in a metered manner, establish Service Level Agreements (SLA), handle production emergency incidents, and convert one-off project relationships into predictable recurring revenue: **Monthly Maintenance Contracts (Monthly Retainer / SLA Contract)**.

---

## 1. Module 12 Execution Cycle

```text
[ INPUT: Valid Stamped BAST Document from Module 11 & System Live in Production ]
                                    │
                                    ▼
[ STEP 1: Enforcement of Official Warranty Boundaries (Warranty Period) ]
  • Start Date: Exactly when BAST is signed (Not when coding started)
  • Duration: 30 Days (Small/MVP) / 60 Days (Mid-scale) / 90 Days (Large & Enterprise)
  • Mandatory Scope: Pure bug fixes that violate FSD/PRD specifications
                                    │
                                    ▼
[ STEP 2: Enforcement of SLA Response Matrix & Working Hours ]
  • Standard Working Hours: Monday – Friday 09:00 – 17:00 WIB (Except Enterprise Retainer)
  • Severity 1 Response (System Down): Response < 2 Hours, Resolution < 24 Hours
  • Severity 2 Response (Major): Response < 8 Hours, Resolution < 48 Hours
  • Severity 3 Response (Minor/Question): Next business day
                                    │
                                    ▼
[ STEP 3: Production Emergency Incident Handling (Break-Glass SOP) ]
  • Rapid Incident Triage via Sentry & Uptime Monitor
  • Execute Fix on fix/* Branch ──► Hotfix Staging ──► Push Tag to main
  • Concise Post-Mortem Documentation in Case of Downtime
                                    │
                                    ▼
[ STEP 4: Transition to Monthly Retainer Contract (Recurring Revenue) ]
  • Send Maintenance Package Proposal (Bronze / Silver / Gold) 14 Days Before Warranty Expires
  • Negotiate & Sign Monthly SLA Retainer Contract
  • Establish Preventive Maintenance Schedule (OS Updates, Patching, Backup Audits)
                                    │
                                    ▼
[ OUTPUT: WARRANTY_POLICY.md Document & SLA_RETAINER_CONTRACT.md Contract ]
```

---

## 2. Solo Developer Protection Principles: "Warranty vs Retainer"

Clients often assume that after purchasing software, the developer is obligated to maintain the system for free for life. The solo developer must strictly distinguish between these two concepts:

| Parameter | Warranty Period | Maintenance Contract (Monthly Retainer) |
| :--- | :--- | :--- |
| **Cost Status** | **FREE** (Included in initial contract). | **PAID MONTHLY** (Routine upfront recurring fee). |
| **Duration** | Limited (30 / 60 / 90 calendar days). | Ongoing (6 or 12-month agreement). |
| **Scope of Work** | **STRICTLY PURE BUG FIXES ONLY**: Repairing functionality proven inconsistent with FSD/PRD. | Server monitoring, library/security version updates, regular DB backup verification, and minor feature development hourly quota. |
| **New Features** | **STRICTLY PROHIBITED**: Must go through Change Request (CR). | Included in the monthly hours quota. |
| **External Causes** | **VOID**: If server is modified by third parties or third-party APIs change format. | Handled using the monthly retainer hours allocation. |

---

## 3. Step-by-Step Execution

### Step 1: Warranty Policy Socialization (`WARRANTY_POLICY.md`)
1. Concurrently with the handover of the BAST (Module 11), deliver the **`WARRANTY_POLICY.md`** document to the Client Single PIC.
2. Affirm official communication channels:
   - Bug reports must go through official email or a single technical coordination group.
   - Sending bug messages to the solo developer's personal number outside working hours is strictly prohibited (unless the server is in *Critical Down* status).

### Step 2: Incident Triage & Hotfix Execution
If the client reports an issue in production during the warranty period:
1. Inspect the Sentry dashboard to view stack traces and error history.
2. Create a fix branch from `main`:
   ```bash
   git checkout main
   git checkout -b fix/issue-critical-payment
   ```
3. Code the fix, run local `pnpm run test:smoke`.
4. Merge to `staging` for rapid verification, then merge to `main` and tag the hotfix:
   ```bash
   git checkout main
   git merge --no-ff fix/issue-critical-payment
   git tag -a v1.0.1 -m "hotfix: resolve payment webhook timeout"
   git push origin main --tags
   ```

### Step 3: Negotiating Transition to Monthly Retainer (14 Days Before Warranty Expires)
Two weeks before the warranty period ends, send a routine maintenance proposal (*Retainer Proposal*).

**Reminder Automation**: Configure a calendar reminder or cron job to automatically send the proposal 14 days before the warranty expiration date:
```bash
# Example cron job: Send retainer proposal reminder
# Add to crontab or use a service scheduler (Hermes cron / GitHub Actions)
0 9 * * * check_warranty_expiry_and_notify.sh
```

Offer 3 package tiers:

1. **Bronze Package (Basic Maintenance & Security)**:
   - 24/7 server monitoring (Uptime & Sentry).
   - Monthly dependency security patching and database maintenance.
   - Backup data integrity verification (*daily backup restore test*).
   - Allocation: 5 Technical consultation hours / month.
2. **Silver Package (Standard Maintenance & Optimization)**:
   - All facilities of the Bronze Package.
   - Allocation of **15 Working hours / month** for minor feature additions, UI adjustments, or report format changes.
   - Responsive SLA response time < 4 hours on business days.
3. **Gold Package (Enterprise SLA & Full Priority)**:
   - All facilities of the Silver Package.
   - Allocation of **30 Working hours / month** for continuous development.
   - On-call emergency weekend support (*On-Call Support*) if the system encounters a critical failure (*Severity 1*).

---

## 4. Adaptation by Project Scale

| Post-Project Parameter | Small Scale (MVP / Freelance) | Mid-Scale (B2B SaaS / Agency) | Large & Enterprise Scale |
| :--- | :--- | :--- | :--- |
| **Warranty Duration** | 30 Calendar Days | 60 Calendar Days | 90 Calendar Days |
| **Bug Response SLA** | Response within 1x24 hours on business days | Response within 4–8 hours on business days | Response within 1–2 hours with emergency escalation |
| **Retainer Model** | Incidental repair option (*Hourly T&M*) | Silver Retainer Package (10–15 hours/month) | Formal Enterprise SLA Contract (Bilingual) |
| **Retainer Invoicing** | Invoiced after hours are consumed | Invoiced upfront on the 1st of every month | Annual contract paid quarterly/annually |

---

## 5. Output Deliverables

> 📁 **ABSOLUTE FILE LOCATION RULES**:
> All warranty policy documents, retainer contracts, and incident reports MUST be stored inside the **`docs/pm/`** folder.

This module produces 3 maintenance governance documents:
1. **`docs/pm/WARRANTY_POLICY.md`**: Official policy document defining warranty boundaries, service working hours, and covered bug definitions (using `templates/08-maintenance-ops/WARRANTY_POLICY_TEMPLATE.md`).
2. **`docs/pm/SLA_RETAINER_CONTRACT.md`**: Recurring monthly maintenance partnership contract (*Monthly Retainer Agreement*) (using `templates/08-maintenance-ops/SLA_RETAINER_CONTRACT_TEMPLATE.md`).
3. **`docs/pm/INCIDENT_RESPONSE.md`**: Standard operating procedure (SOP) for handling production emergency incidents for solo developers (using `templates/08-maintenance-ops/INCIDENT_RESPONSE_TEMPLATE.md`).

---

## 6. [GATE] Exit Criteria

[GATE] Module 12 is declared **SUCCESSFUL & PROJECT LIFECYCLE 100% COMPLETE** if:
- [x] The 30/60/90 calendar day warranty period has passed with no pending Severity 1 & 2 tickets unresolved.
- [x] Document `docs/pm/WARRANTY_POLICY.md` has been issued.
- [x] The client has signed the warranty sign-off sheet or officially signed the Monthly Retainer Contract (`docs/pm/SLA_RETAINER_CONTRACT.md`).
- [x] The system operates stably and autonomously on production servers with active automated monitoring.

---

## 🛑 LIFECYCLE COMPLETION PROTOCOL

After all stages of Module 12 are completed:

### **STEP 0: FILE EXISTENCE VERIFICATION (BLOCKING CHECK)**

**MANDATORY BEFORE CLOSURE**:

1. **Check output file existence** using one of the following methods:
   - PowerShell: `Test-Path -LiteralPath "docs/pm/WARRANTY_POLICY.md"` → must return `True`
   - Read tool: `read_file('docs/pm/WARRANTY_POLICY.md')` → must succeed without error

2. **IF FILE DOES NOT EXIST**:
   - ❌ **STOP IMMEDIATELY** - do not proceed to closure
   - ❌ **DO NOT display congratulations** to user
   - ✅ **REPORT ERROR** to user:
     ```
     CRITICAL ERROR: File WARRANTY_POLICY.md was not created.
     Module 12 INCOMPLETE - lifecycle cannot be closed.
     
     Probable causes:
     - Write permission denied on docs/pm/ folder
     - Path typo in tool call
     - Disk full
     
     Please investigate this issue before closure.
     ```
   - ✅ **END TURN** and wait for user to fix issue

3. **ONLY IF FILE EXISTS**: Proceed to closure below

---

### **STEP 1: LIFECYCLE CLOSURE**

1. **Verify warranty policy**:
   - [ ] `read_file('docs/pm/WARRANTY_POLICY.md')` → Confirm warranty period, coverage, exclusions documented
   - [ ] Confirm no pending Severity 1/2 tickets
   - [ ] Confirm monitoring active and stable
2. Display congratulations and project completion summary to user.
3. **DECISION POINT**: Determine project closure type:

---

### **STEP 2: PROJECT CLOSURE TYPE ASSESSMENT**

**A. Client Project (Delivery & Exit)**
- [ ] Client will maintain internally or hire in-house team
- [ ] Source code and credentials already handed over (M11)
- [ ] Warranty period expired

**Action**: 
> *"The [30/60/90 day] warranty period has expired. All deliverables have been handed over. This project is officially declared 100% COMPLETE. Thank you for your trust!*
> 
> *Optional: We offer a Monthly Retainer (Rp X/month) for ongoing support. Are you interested?"*

**END TURN** - Lifecycle complete.

---

**B. In-House Product / Ongoing Service**
- [ ] Product is self-owned (not a client project)
- [ ] Or: Client signed Monthly Retainer / SLA contract
- [ ] Product will continue to be developed & operated

**Action**: **TRANSITION TO MODULE 13** (Product Operations & Continuous Iteration)

> *"The initial launch warranty period has concluded. The system is stable and monitoring is active.*
> 
> *For ongoing product operations, proceed to **Module 13: Product Operations & Continuous Iteration** for:*
> - *30-day post-launch baseline metrics*
> - *Continuous feedback loop & prioritization*
> - *Growth experiments & A/B testing*
> - *Scaling signal monitoring*
>
> *Are you ready to start Module 13?"*

**END TURN** - Wait for user approval before loading Module 13.

---

**C. Retainer / SLA Maintenance Only (No Active Development)**
- [ ] Client signed SLA contract for bug fixes & monitoring only
- [ ] No new features or growth experiments planned
- [ ] Maintenance mode (incident response only)

**Action**:
> *"SLA contract active. System in maintenance mode. Incident monitoring running.*
> 
> *If new features or growth optimization are needed in the future, we can activate Module 13 (Product Operations). For now, the development lifecycle is COMPLETE."*

**END TURN** - Lifecycle complete (maintenance-only mode).

---

### **Decision Matrix: When to Proceed to Module 13?**

| Condition | Proceed to M13? | Reason |
|-----------|----------------|---------|
| Client project + handover complete | ❌ NO | Client owns product, exit relationship |
| Client project + monthly retainer signed | ✅ YES | Ongoing ops & iteration needed |
| In-house product (solo dev owner) | ✅ YES | Continuous improvement & growth |
| SLA maintenance-only (no features) | ❌ NO | Reactive mode, no proactive ops |
| Warranty expired + no ongoing contract | ❌ NO | Project closed |

---

**Module 12 Gate Exit Criteria**:
- [x] Warranty policy documented
- [x] No Severity 1/2 pending tickets
- [x] Closure type determined (A/B/C)
- [x] If Type B: User approval to proceed to M13
- [x] If Type A/C: Final closure acknowledgment
