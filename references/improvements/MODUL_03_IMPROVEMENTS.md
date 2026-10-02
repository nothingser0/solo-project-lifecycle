# Modul 03: Legal SOW, DP, & Single PIC Agreement Improvements

> **Purpose**: Supplement Modul 03 dengan 10 critical missing sections: Timeline, Contract Model Decision Tree, Payment Deadlock Protocol, PIC Succession Protocol, CR Workflow, Liability Exclusion Examples, IP Ownership Matrix, Data Protection Standard, Developer Termination Rights, Document Purpose Clarification.
>
> **Last Updated**: 2026-09-30  
> **Target**: Solo developers executing Modul 03 (Commercial Gate)

---

## 1. Timeline Estimation (CRITICAL — Missing in Core Module)

### Problem
Module tidak mention berapa hari/minggu untuk complete Modul 03. Bikin kontrak + negosiasi + sign + tunggu DP = minimal 3-7 hari, bukan 1 hari.

### Solution: Timeline by Context

**Internal Product (Solo Dev Mandiri):**
- **Duration**: 1-2 jam
- **Deliverable**: `PROJECT_CHARTER.md` basic (baseline schedule, budget infra, risk)
- **Skip**: SOW_CONTRACT.md (no client, no payment)
- **Gate**: BYPASS DP check (no external payment)

**Standard Freelance Client:**
- **Duration**: 3-5 hari
- **Breakdown**:
  - Day 1: Draft SOW_CONTRACT.md + PROJECT_CHARTER.md (2-3 jam)
  - Day 2-3: Send to client, negotiation (revisi termin struktur, CR rate, liability cap)
  - Day 4: Sign contract (e-signature or tanda tangan basah + scan)
  - Day 5-7: Wait DP transfer (bank processing 1-3 hari kerja)
- **Gate**: Confirm DP received (check rekening)

**Enterprise Corporate Client:**
- **Duration**: 1-3 minggu
- **Breakdown**:
  - Week 1: Draft SOW + PROJECT_CHARTER, submit to client legal team
  - Week 2: Legal review (client lawyer mark up contract, back-and-forth revision)
  - Week 3: Stakeholder approval (finance, procurement, executive sign-off), PO generation, payment processing
- **Gate**: Confirm DP + PO number received

---

## 2. Contract Model Decision Tree (CRITICAL)

### Problem
Module mention 2 model (Fixed-Price vs T&M/Retainer) tapi tidak ada **decision tree** yang jelas kapan pakai mana.

### Solution: Decision Flowchart

```
START: Apakah scope di SCOPE_STATEMENT.md SUDAH JELAS 100%?
  │
  ├─ NO → T&M/Retainer ONLY
  │        (Scope kabur = impossible estimate fixed-price)
  │
  └─ YES → Apakah client fleksibel terhadap perubahan fitur?
            │
            ├─ NO → Fixed-Price
            │        (Client mau kepastian biaya, no surprise cost)
            │
            └─ YES → Apakah engagement >6 bulan?
                      │
                      ├─ YES → Monthly Retainer
                      │         (Long-term, ongoing feature dev)
                      │
                      └─ NO → T&M Hourly
                               (Short-term, scope evolving)
```

### Fixed-Price ONLY IF (All 3 criteria met):

| Criteria | Check |
|----------|-------|
| ✅ **Scope 100% jelas** | MoSCoW locked, no ambiguity, all screens defined |
| ✅ **Client commit no CR** | Or CR charged separately at hourly rate |
| ✅ **Reference exists** | Comparable project done before (reliable estimate) |

**If ANY criteria NOT met → Use T&M/Retainer instead**

### T&M/Retainer IF (Any 1 criteria met):

| Criteria | Example |
|----------|---------|
| ✅ **Scope evolving** | Roadmap dinamis, "fitur dipikirkan sambil jalan" |
| ✅ **Long-term** | 6+ bulan engagement, ongoing feature development |
| ✅ **Discovery phase** | Client belum tahu pasti apa yang mau dibangun |
| ✅ **Regulated industry** | Fintech/healthtech (requirement berubah per regulasi) |

### Rate Structure Comparison:

| Model | Rate | Payment | Risk |
|-------|------|---------|------|
| **Fixed-Price** | Total Rp X (e.g., Rp 50 juta) | Per milestone (30-50-20% termin) | Developer bear scope risk (if under-estimate, rugi) |
| **T&M Hourly** | Rp Y/jam (e.g., Rp 300k/jam) | Weekly/bi-weekly invoice (40 jam × Rp 300k = Rp 12 juta) | Client bear scope risk (if over-run, client pay more) |
| **Monthly Retainer** | Rp Z/bulan (e.g., Rp 20 juta/bulan) | Monthly prepaid (1st of month) | Shared risk (fixed hours/month, unused hours carry-over or lost) |

---

## 3. Payment Deadlock Protocol (CRITICAL)

### Problem
Module ada struktur termin tapi tidak ada **protocol** jika client refuse bayar termin antara (Alpha/Beta).

### Solution: Escalation Ladder

**Day 1-3: Polite Reminder**
```
Subject: [PROJECT] Termin [Alpha/Beta] Invoice Reminder

Hi [Client],

Termin [Alpha/Beta] invoice sent [Date]. Payment due date: [Date].
Please confirm ETA untuk transfer.

Deliverables completed:
- [Deliverable X] ✅
- [Deliverable Y] ✅

Next milestone (after payment): [Deliverable Z]

Thank you!
```

**Day 4-7: Formal Notice + PAUSE Work**
```
Subject: [PROJECT] Payment Overdue — Work Paused

Hi [Client],

Payment overdue 4 hari. Effective today, development work PAUSED until payment cleared.

Impact:
- Original launch: [Date A]
- Revised launch (if paid today): [Date A + 7 hari]

Please confirm payment status by EOD tomorrow.
```

**Day 8-14: IP Protection Reminder**
```
Subject: [PROJECT] Payment Overdue — IP Ownership Reminder

Hi [Client],

Payment overdue 10 hari. Reminder per SOW Clause [X.Y]:
- Source code IP milik Developer sampai lunas 100%
- No demo access, no staging URL, no code delivery until payment cleared
- Late payment fee: 2% per minggu overdue (Rp [X] as of today)

Please settle payment to resume work.
```

**Day 15-30: Termination Warning**
```
Subject: [PROJECT] Contract Termination Risk — 30-Day Payment Delay

Hi [Client],

Payment overdue 21 hari. Per SOW Clause [X.Y], if payment delay >30 hari:
- Contract may be terminated
- All payments received (DP + prior termin) non-refundable
- Developer retains IP ownership, may commercialize deliverables to recover losses

Deadline to pay: [Date] (9 hari remaining)

Let's schedule call to discuss resolution.
```

**Day 31+: Termination Execution**
```
Subject: [PROJECT] Contract Terminated — Payment Default

Hi [Client],

Per SOW Clause [X.Y] and prior notices (4 reminders sent), contract terminated effective today due to 30+ hari payment default.

Final accounting:
- Total paid: Rp [A] (DP + Termin X)
- Hours worked to date: [Y] jam
- Hourly rate: Rp [Z]/jam
- Value delivered: Rp [Y × Z]
- Outstanding balance: Rp [Y×Z - A] (client owes developer) OR Rp [A - Y×Z] (refund to client)

IP ownership: Per IP Ownership Matrix, developer retains 100% IP (payment <100%).

Code/deliverables: Archived, not delivered to client.

Option to resume: If client settle outstanding balance + late fees within 30 hari, project may resume with new contract.
```

---

## 4. PIC Succession Protocol (CRITICAL)

### Problem
Module ada klausul Single PIC tapi tidak ada **protocol** jika PIC resign/sakit/pindah divisi mid-project.

### Solution: 4-Step Succession Process

**STEP 1: PAUSE Decision-Pending Work**
```
Email to client:

Subject: [PROJECT] Single PIC Unavailable — Need Designation

Hi [Client],

Single PIC [Name] unavailable (reason: [resign/sick leave/transferred]).

Per SOW Clause [X.Y], all decisions require Single PIC approval.

Decision-pending items PAUSED:
- [Design approval for Feature X]
- [UAT sign-off for Module Y]
- [CR-003 approval]

Action needed: Designate NEW Single PIC in writing to proceed.
```

**STEP 2: Client Designate NEW PIC**

**Requirement:**
- Full name, title, email, phone
- Authority confirmation (signed by client executive/manager)
- Availability commitment (response SLA max 3 hari)

**Email template for client:**
```
Subject: [PROJECT] New Single PIC Designation

[Client Company] designates [New Name], [Title], as new Single PIC for [Project Name], effective [Date].

Contact:
- Email: [email]
- Phone: [phone]
- Authority: Approved by [Executive Name], [Title]

[New Name] has authority to:
- Approve design/scope changes
- Sign UAT/milestone acceptance
- Approve Change Requests
- Make final decisions on project direction

Signed: [Executive Signature]
Date: [Date]
```

**STEP 3: Knowledge Transfer (3-5 hari)**

**Developer responsibility:**
- Share project status summary (What's done, what's pending, blockers)
- Share all prior approvals (design, scope decisions, CR history)
- Schedule 1-hour handover call with new PIC (walkthrough staging demo)

**New PIC responsibility:**
- Review all prior approvals (confirm understanding)
- Acknowledge decision-pending items (approve/reject/clarify)

**STEP 4: SOW Amendment**

**Update SOW Clause "Single PIC" section:**
```markdown
## Single Point of Contact (PIC)

~~Original PIC: [Old Name], [Title] (Effective [Start Date] - [End Date])~~

**Current PIC**: [New Name], [Title] (Effective [Date])
- Email: [email]
- Phone: [phone]
- Authority: Approved by [Executive Name], [Title]
- Succession date: [Date]
```

**Both parties sign amendment (or email confirmation sufficient for small projects)**

**Timeline Impact**: Add buffer +3-7 hari for new PIC ramp-up

---

## 5. Change Request Workflow (CRITICAL)

### Problem
Module ada formula CR (`Biaya = Jam × Tarif`, `Jadwal +X hari`) tapi tidak ada **step-by-step process**.

### Solution: 5-Step CR Process

**STEP 1: CR Submission (Client Request)**

**Client fill CR form** (gunakan formulir Change Request yang disepakati dalam SOW):

```markdown
## Change Request: CR-001

**Date**: 2026-10-15
**Requested by**: [Client Name], [Title]
**Type**: [ ] New Feature  [ ] Modify Existing  [ ] Remove Feature

**Description**:
Add export PDF feature untuk sales report (currently Excel only).

**Business Justification**:
Sales team prefer PDF for client presentation (no Excel edit risk).

**Priority**: [ ] Critical  [X] Important  [ ] Nice-to-Have

**Preferred Timeline**: Launch bersamaan dengan v1.0 (Week 8)
```

**STEP 2: Impact Assessment (Developer Estimate — 2 hari)**

**Developer analyze & respond:**

```markdown
## CR-001 Impact Assessment

**Effort Estimate**: 12 jam dev time
- Backend: PDF generation library integration (4 jam)
- Frontend: Add "Export PDF" button + loading state (2 jam)
- Styling: PDF template matching brand guidelines (3 jam)
- Testing: Cross-browser PDF rendering test (3 jam)

**Cost**: Rp 3.6 juta (12 jam × Rp 300k/jam)

**Timeline Impact**: +2 hari (if start now), or defer to v1.1 (+0 hari for v1.0)

**Alternative Options**:
1. **Accept**: Add to v1.0 scope (+Rp 3.6 juta, launch delay +2 hari)
2. **Swap**: Replace Feature Z (also 12 jam effort) with PDF export (zero cost, same timeline)
3. **Defer**: Move to Phase 2 v1.1 (launch Week 10, +0 impact on v1.0)
4. **Simplify**: Basic PDF (no brand styling) = 8 jam = Rp 2.4 juta, +1 hari

**Recommendation**: Option 3 (Defer to v1.1) — v1.0 already packed, PDF is nice-to-have not blocker.
```

**STEP 3: Negotiation (if Needed)**

**Client response options:**
- **Accept Option X**: Proceed to Step 4
- **Negotiate**: "Can we do basic PDF for Rp 2 juta instead of Rp 3.6 juta?" → Developer counter-offer
- **Defer**: "OK, move to v1.1"
- **Reject**: "Never mind, cancel CR"

**STEP 4: Approval & DP Transfer**

**Client sign CR approval:**
```markdown
## CR-001 Approval

Approved option: [Option 1: Accept]

Cost: Rp 3.6 juta
Timeline: +2 hari (launch Week 8 → Week 8+2hari)

Payment terms: 30% DP (Rp 1.08 juta) paid upfront, 70% (Rp 2.52 juta) paid at CR completion.

Client signature: [Signature]
Date: [Date]
```

**Developer action:**
- Wait DP transfer confirmed (Rp 1.08 juta)
- Update `SCOPE_STATEMENT.md`: Append CR log

```markdown
## Change Request Log

| CR ID | Date | Description | Cost | Timeline Impact | Status | Approved By |
|-------|------|-------------|------|-----------------|--------|-------------|
| CR-001 | 2026-10-15 | Export PDF feature | Rp 3.6 juta | +2 hari | ✅ Approved, In Progress | [Client Name] |
```

**STEP 5: Execute CR**

- Developer implement CR per estimate (12 jam)
- Test & deliver (same quality standard as original scope)
- Demo to client (staging)
- Invoice remaining balance (Rp 2.52 juta) at CR completion
- Client approve & pay final 70%

**CR Complete**: Close CR-001, update SCOPE_STATEMENT.md status `✅ Completed`

---

## 6. Liability Exclusion Examples (IMPORTANT)

### Problem
Module mention "Liability cap = max nilai kontrak" tapi tidak ada **concrete examples** exclusion.

### Solution: Exclusion Checklist

**Developer NOT LIABLE for:**

| Exclusion | Example | Why Excluded |
|-----------|---------|--------------|
| ❌ **Lost Profit/Revenue** | "Sistem down 1 jam, kehilangan omzet Rp 10 juta" | Indirect loss, unpredictable, not developer's control |
| ❌ **Data Breach (Client Fault)** | Karyawan share password ke pihak ketiga, data leaked | Client security policy breach |
| ❌ **Force Majeure** | Datacenter kebakaran, ISP nationwide outage, pandemic lockdown | Beyond developer control |
| ❌ **Third-Party Failure** | Payment gateway down, email service limit exceeded, SMS provider issue | Not developer's service |
| ❌ **Client Misuse** | Manual SQL injection by client admin, delete production DB | Intentional misuse |
| ❌ **Regulatory Penalties** | OJK fine karena client tidak comply regulasi (e.g., no risk disclosure) | Client compliance responsibility |
| ❌ **Hardware Failure** | Client server hard drive corrupt, no backup | Client infrastructure responsibility |
| ❌ **User Error** | User accidentally delete critical data, no confirmation dialog clicked | User training issue |

**Developer LIABLE for:**

| Liability | Example | Developer Action |
|-----------|---------|------------------|
| ✅ **Code Bugs** | Feature X crash on mobile Safari | Fix within warranty (30-60 hari) |
| ✅ **Security Vulnerabilities** | SQL injection vulnerability in developer's code | Patch ASAP (max 7 hari) |
| ✅ **Data Loss (Developer Error)** | Developer run wrong migration script, delete prod data (if backup not per FSD) | Restore from backup, compensate if no backup |
| ✅ **Performance Issue** | Page load >10s (FSD spec: <2s) | Optimize to meet spec |
| ✅ **Breach of Confidentiality** | Developer leak client data to competitor | Legal action, compensate damages |

**Maximum Liability**: Rp [Total nilai kontrak yang sudah dibayar]

**Example Clause (for SOW_CONTRACT.md):**
```markdown
## Limitation of Liability

Developer's total liability for any claim arising from this agreement shall not exceed the total amount paid by Client to Developer under this contract.

Developer shall NOT be liable for:
- Indirect, incidental, consequential, or punitive damages (including lost profits, lost revenue, loss of business opportunity)
- Data breach or security incidents resulting from Client's failure to safeguard passwords or follow security best practices
- Force majeure events (fire, flood, earthquake, war, pandemic, government action, Internet service outage)
- Failure or malfunction of third-party services (payment gateways, email providers, cloud hosting providers, APIs)
- Client misuse of the system (intentional or negligent acts by Client's employees or users)
- Regulatory fines or penalties imposed on Client due to Client's non-compliance with applicable laws
```

---

## 7. IP Ownership Matrix (IMPORTANT)

### Problem
Module mention "IP milik developer sampai lunas 100%" tapi tidak ada clarify **partial payment scenario**.

### Solution: Payment % → IP Ownership Matrix

| Payment Status | IP Ownership | Client Rights | Developer Rights |
|----------------|--------------|---------------|------------------|
| **0-29% paid** | 100% Developer | ❌ No access to source code, no usage rights | ✅ May resell to another client, commercialize |
| **30-69% paid** | Negotiable (termination fee) | ⚠️ Client may negotiate: Pay termination fee (30% sisa) → Get IP license | ⚠️ Or developer refund (Paid - Hours worked), retain IP |
| **70-99% paid** | Conditional license | ⚠️ Client may use, cannot resell/redistribute until 100% paid | ⚠️ Developer retain ownership, may revoke if final payment not received within 30 hari |
| **100% paid** | 100% Client | ✅ Full rights (use, modify, resell, redistribute, sublicense) | ❌ No rights (except portfolio use with permission) |

**Termination Fee Calculation:**
```
If project terminated mid-way (e.g., Client paid 50%, want to terminate):

Option A: Client forfeit IP, get partial refund
- Paid: Rp 25 juta (50% of Rp 50 juta contract)
- Hours worked: 80 jam × Rp 300k/jam = Rp 24 juta
- Refund: Rp 25 juta - Rp 24 juta = Rp 1 juta
- IP ownership: 100% Developer

Option B: Client pay termination fee, get IP
- Paid: Rp 25 juta (50%)
- Remaining: Rp 25 juta (50%)
- Termination fee: 30% of remaining = Rp 7.5 juta
- Total client pay: Rp 25 juta + Rp 7.5 juta = Rp 32.5 juta (65% of contract)
- IP ownership: 100% Client (license granted)
```

**Exception: Open-Source Components**
```
Components under MIT/Apache/BSD license (e.g., Next.js, Tailwind, shadcn/ui) remain under original license.
Client cannot claim exclusive ownership of open-source components.
```

**SOW Clause Example:**
```markdown
## Intellectual Property Ownership

**Source Code Ownership**: All source code, designs, documentation, and deliverables created by Developer shall remain the exclusive intellectual property of Developer until Client has paid 100% of the contract value.

**IP Transfer**: Upon receipt of final payment (100%), Developer transfers full ownership of the intellectual property to Client, including rights to use, modify, distribute, sublicense, and commercialize the deliverables.

**Partial Payment**: If project is terminated before 100% payment, IP ownership is determined as follows:
- 0-29% paid: Developer retains 100% IP ownership, Client receives no rights
- 30-69% paid: Negotiable (Client may pay termination fee of 30% remaining balance to acquire IP license)
- 70-99% paid: Client receives conditional license (may use, cannot resell) until 100% paid

**Open-Source Components**: Any open-source libraries or frameworks used (e.g., Next.js, React, Tailwind CSS) remain under their original licenses (MIT, Apache, etc.) and are not transferred to Client as exclusive IP.
```

---

## 8. Data Protection Standard (SHOULD-FIX)

### Problem
Module mention NDA tapi tidak ada **data handling requirements** konkrit.

### Solution: Data Protection Checklist

**Developer Commits:**

| Commitment | Specification |
|------------|---------------|
| ✅ **Encrypt at rest** | AES-256 for database, file storage (S3/R2 server-side encryption) |
| ✅ **Encrypt in transit** | TLS 1.3 for all API/web traffic, no HTTP (HTTPS only) |
| ✅ **No prod data local** | Use anonymized/fake data di local dev environment |
| ✅ **Access control** | Only developer access production DB (no share credentials to junior/intern) |
| ✅ **Backup retention** | 30 hari rolling backup, after: securely deleted (shred/overwrite, not just delete) |
| ✅ **NDA period** | During project + 2 tahun after termination |

**Client Data NOT Shared With:**

| Prohibited | Example |
|------------|---------|
| ❌ **Third-party subcontractors** | Unless approved in writing (e.g., hire designer for UI, need client consent) |
| ❌ **AI training** | No production data to ChatGPT/Claude/GitHub Copilot for debugging (use synthetic data) |
| ❌ **Portfolio showcase** | Unless approved in writing (use anonymized screenshots, blur sensitive data) |
| ❌ **Competitors** | No disclosure of client business logic, pricing, strategy to competing clients |

**UU PDP Compliance (Indonesia Law No. 27/2022):**

| Requirement | Implementation |
|-------------|----------------|
| ✅ **Consent** | User must consent to data processing (checkbox "I agree to Terms", no pre-checked) |
| ✅ **Purpose limitation** | Data collected only for stated purpose (e.g., order processing, not marketing unless consented) |
| ✅ **Data minimization** | Collect only necessary data (e.g., no need KTP scan for newsletter subscription) |
| ✅ **Retention limit** | Max 5 tahun (or per regulation), after: delete or anonymize |
| ✅ **Breach notification** | Max 3 hari to client + BSSN (Badan Siber dan Sandi Negara) if breach detected |
| ✅ **User rights** | User can request: access data, correct data, delete data (GDPR-style rights) |

**SOW Clause Example:**
```markdown
## Data Protection & Confidentiality

**Encryption**: Developer shall encrypt all Client data at rest (AES-256) and in transit (TLS 1.3).

**Access Control**: Only Developer shall have access to production systems. Credentials shall not be shared with third parties without Client's written consent.

**No Production Data in Development**: Developer shall use anonymized or synthetic data for local development and testing. Production data shall not be downloaded to Developer's local machine.

**Backup & Retention**: Developer shall maintain rolling backups for 30 days. Backups older than 30 days shall be securely deleted (shredded/overwritten).

**Non-Disclosure**: Developer shall not disclose Client's confidential information to any third party during the project and for 2 years after project completion.

**UU PDP Compliance**: Developer shall implement data protection measures in compliance with Indonesia's Personal Data Protection Law (UU No. 27/2022), including user consent, data minimization, retention limits, and breach notification within 3 days.
```

---

## 9. Developer Termination Rights (SHOULD-FIX)

### Problem
Module mention client termination tapi tidak ada **developer-initiated termination** clause.

### Solution: Developer Termination Triggers

**Developer May Terminate Contract If:**

| Trigger | Condition | Example |
|---------|-----------|---------|
| 🚩 **Payment Delay** | >30 hari overdue (per Payment Deadlock Protocol) | Client tidak bayar termin Alpha setelah 4 reminder |
| 🚩 **PIC Breach** | Multiple decision makers conflict, no resolution >14 hari | Bos bilang approve, manager bilang reject, stuck 2 minggu |
| 🚩 **Scope Creep Excessive** | Client insist 10+ CR without payment, refuse renegotiate | "Ini cuma minor change" × 10 kali, total +50 jam unpaid |
| 🚩 **Harassment/Abuse** | WhatsApp spam 100+ messages/hari, verbal abuse, unrealistic demands | Client telpon jam 2 pagi marah-marah, toxic behavior |
| 🚩 **Force Majeure (Developer)** | Medical emergency, family crisis >30 hari | Developer sakit berat, cannot work 2 bulan |

**Termination Process:**

**STEP 1: Send 14-Day Notice**
```
Subject: [PROJECT] Contract Termination Notice (14-Day Cure Period)

Hi [Client],

Per SOW Clause [X.Y], Developer issues termination notice due to:
[Reason: Payment delay 45 hari / PIC breach / Scope creep excessive / Harassment]

**Cure Period**: Client has 14 hari to cure breach:
- [If payment: Pay outstanding balance Rp X]
- [If PIC: Designate Single PIC in writing]
- [If scope creep: Approve CR-XXX or rollback features]
- [If harassment: Cease toxic behavior, appoint new liaison]

If not cured by [Date], contract will be terminated effective Day 15.

This notice sent via email + registered mail (bukti kirim: [Tracking number]).
```

**STEP 2: 14-Day Cure Period**

Client may:
- **Cure breach**: Pay balance, designate PIC, approve CR, stop harassment → Contract continues
- **Negotiate**: Counter-offer (e.g., "Bayar 50% dulu, sisa 50% bulan depan") → Developer may accept/reject
- **Ignore**: No response → Proceed to Step 3

**STEP 3: Terminate (Day 15)**
```
Subject: [PROJECT] Contract Terminated Effective Today

Hi [Client],

Breach not cured within 14 hari. Contract terminated effective today per SOW Clause [X.Y].

**Refund Calculation**:
- Total paid by Client: Rp [A]
- Hours worked by Developer: [X] jam × Rp [Y]/jam = Rp [Z]
- Refund to Client: Rp [A - Z] (if A > Z)
- OR Balance owed by Client: Rp [Z - A] (if Z > A)

**IP Ownership**: Per IP Ownership Matrix:
- If paid <70%: Developer retains 100% IP
- If paid 70-99%: Conditional license (may use, cannot resell)

**Deliverables**: Code archive sent to Client (if paid ≥30%), or retained by Developer (if paid <30%).

**Final Invoice**: [Attach invoice for balance owed, if applicable]

Thank you for the opportunity. Wish you success.
```

**SOW Clause Example:**
```markdown
## Termination by Developer

Developer may terminate this agreement with 14 days written notice if:
1. Client fails to pay any invoice within 30 days of due date
2. Client breaches Single PIC clause (multiple conflicting decision makers, no resolution >14 days)
3. Client requests excessive scope changes without payment (>10 CR requests rejected or unpaid)
4. Client engages in harassment, abuse, or unreasonable demands that prevent Developer from performing work
5. Force majeure event affecting Developer (medical emergency, family crisis) lasting >30 days

Upon termination, Developer shall:
- Provide 14-day cure period for Client to remedy breach
- Calculate refund: (Amount Paid) - (Hours Worked × Hourly Rate)
- Transfer IP per IP Ownership Matrix (based on % paid)
- Deliver work product completed to date (if paid ≥30%)
```

---

## 10. Document Purpose Clarification (SHOULD-FIX)

### Problem
Module ada 2 deliverables (SOW_CONTRACT.md + PROJECT_CHARTER.md) tapi tidak explain **what's the difference** & **why need both**.

### Solution: Document Comparison

### Why 2 Documents?

| Aspect | SOW_CONTRACT.md | PROJECT_CHARTER.md |
|--------|-----------------|---------------------|
| **Purpose** | Legal/Commercial agreement | Technical/PM baseline |
| **Audience** | Client, Legal team, Accounting | Developer, Client PIC, Tech team |
| **Content** | Who pays what, when, IP, liability, termination | How to execute (timeline, tech stack, assumptions, constraints, RACI) |
| **Tone** | Formal legal language ("Party A", "shall", "hereto") | Informal PM language ("we will", "target", "goal") |
| **Signature** | **Required** (legally binding) | **Optional** (alignment doc) |
| **Enforceability** | Court-enforceable | Not enforceable (internal reference) |
| **Updates** | Rare (require amendment + sign) | Frequent (update baseline, no signature) |

### When to Use 1 Doc vs 2 Docs:

**1 Document (Merged — SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md):**
- ✅ Solo dev product (no client, PROJECT_CHARTER only, no SOW)
- ✅ Freelance small project (<Rp 20 juta, <2 bulan)
- ✅ Client prefer simplicity (1 doc to sign, not 2)
- ✅ Low-risk project (known client, repeat customer)

**2 Documents (Separate):**
- ✅ B2B/Agency project (>Rp 50 juta, >3 bulan)
- ✅ Enterprise client (legal team review, procurement process)
- ✅ High-risk project (new client, complex scope, international)
- ✅ Client has legal template (must use their MSA + separate SOW)

### Document Checklist:

**Solo Dev Internal Product:**
- ✅ `PROJECT_CHARTER.md` (baseline schedule, budget, risk)
- ❌ `SOW_CONTRACT.md` (skip, no client)
- **Gate**: BYPASS DP check

**Freelance Small Project:**
- ✅ `SOW_CONTRACT_CONSOLIDATED.md` (merged, both in 1 doc)
- **Gate**: Confirm DP received

**B2B/Enterprise Project:**
- ✅ `SOW_CONTRACT.md` (legal/commercial)
- ✅ `PROJECT_CHARTER.md` (technical/PM)
- **Gate**: Confirm DP + PO received

---

## Summary: 10 Critical Improvements

| # | Improvement | Impact | Priority |
|---|-------------|--------|----------|
| 1 | Timeline Estimation (1-2 jam internal, 3-5 hari standard, 1-3 minggu enterprise) | Set realistic wait time expectation | 🔴 CRITICAL |
| 2 | Contract Model Decision Tree (scope jelas + fleksibel? → Fixed-Price vs T&M) | Help choose right model, prevent under-pricing | 🔴 CRITICAL |
| 3 | Payment Deadlock Protocol (Day 1-3 reminder, Day 31+ terminate + IP claim) | Protect from payment default, enforce IP ownership | 🔴 CRITICAL |
| 4 | PIC Succession Protocol (pause, designate new, knowledge transfer, resume) | Handle PIC change gracefully, prevent approval deadlock | 🔴 CRITICAL |
| 5 | CR Workflow (5 steps: submit, assess, negotiate, approve, execute) | Standardize CR handling, prevent scope creep | 🔴 CRITICAL |
| 6 | Liability Exclusion Examples (lost profit, force majeure, third-party failure) | Limit legal exposure, clarify responsibility boundaries | 🟡 IMPORTANT |
| 7 | IP Ownership Matrix (0-29%/30-69%/70-99%/100% payment → ownership) | Clarify partial payment scenario, prevent IP disputes | 🟡 IMPORTANT |
| 8 | Data Protection Standard (encrypt, no prod data local, UU PDP compliance) | Compliance with Indonesia privacy law, protect client data | 🟡 IMPORTANT |
| 9 | Developer Termination Rights (payment delay, harassment, force majeure) | Protect developer from toxic clients, enable exit strategy | 🟡 IMPORTANT |
| 10 | Document Purpose Clarification (SOW legal vs PROJECT_CHARTER PM) | Reduce confusion, know when use 1 vs 2 docs | 🟡 IMPORTANT |

---

**Next Steps After Loading This Reference:**

1. Load `modules/03-legal-sow-charter.md` (core framework)
2. Load `references/improvements/MODUL_03_IMPROVEMENTS.md` (this file — 10 critical supplements)
3. Apply `references/improvements/MODUL_03_IMPROVEMENTS.md` (scope creep tactics, CR formula, PIC enforcement)
4. Execute Modul 03 dengan full context (core + improvements + boundary defense)

**Agent must apply ALL 10 improvements during Modul 03 execution, not just core module alone.**


---

## Solo Developer Focus

# Panduan Pertahanan Batas Kerja Solo Developer (Solo Boundary Defense)

Dokumen ini adalah buku saku taktis bagi solo developer dan konsultan perangkat lunak untuk menjaga batasan lingkup, melindungi arus kas termin pembayaran, dan menangkis tekanan birokrasi klien tanpa merusak hubungan profesional.

---

## 1. Taktik Menolak Scope Creep (Penambahan Fitur Liar)

Klien sering melontarkan permintaan fitur tambahan secara kasual saat rapat atau obrolan chat. Solo dev dilarang keras langsung mengiyakan tanpa proses administrasi.

### Pola Komunikasi "Ya, Tapi Lewat Change Request"
Gunakan teknik **Validate, Position, Option**:

1. **Validasi**: Akui ide mereka bermanfaat (*"Ide filter pencarian otomatis berdasarkan geolokasi ini sangat bagus untuk kenyamanan pengguna..."*).
2. **Posisikan Batasan**: Tunjukkan dokumen acuan (*"...Namun sesuai dokumen Scope Statement v1.0 yang kita sepakati bersama, fitur pencarian di rilis ini dibatasi pada input teks nama kota..."*).
3. **Beri Opsi Keputusan**:
   > *"Agar jadwal go-live kita tanggal [Target Tanggal] tidak terganggu, ada 2 opsi terbaik:*
   > - *Opsi A: Kita masukkan ke dalam daftar prioritas pertama untuk **Fase 2 Pengembangan** setelah sistem resmi rilis.*
   > - *Opsi B: Kita kerjakan sekarang melalui **Change Request (CR)** resmi, dengan penyesuaian biaya sebesar Rp [Nominal] dan penambahan waktu kerja [X] hari.*
   >
   > *Opsi mana yang Bapak/Ibu prioritaskan untuk operasional saat ini?"*

---

## 2. Formula Standar Biaya & Jadwal Change Request (CR)

Jika klien memilih Opsi B, hitung penyesuaian secara terukur menggunakan rumus baku:

$$\text{Biaya CR} = (\text{Estimasi Jam Kerja Teknis} \times \text{Tarif Jam Anda}) + \text{Biaya Integrasi API/Infra Baru}$$

$$\text{Penambahan Jadwal} = \text{Estimasi Hari Kerja} + \text{Buffer QA (2 Hari Kerja)}$$

### Lembar Ringkas Change Request (CR Sheet)
Setiap perubahan wajib mencantumkan:
- **Nomor CR**: CR-[ID-Proyek]-001
- **Deskripsi Fitur Baru**: Penjelasan spesifik fungsionalitas yang diminta.
- **Dampak Teknis**: Modul yang terdampak dan pengujian ulang yang diperlukan.
- **Biaya Tambahan**: Nominal bersih.
- **Perubahan Tanggal Go-Live**: Dari tanggal lama $\to$ tanggal baru.
- **Persetujuan Tertulis**: Tanda tangan / konfirmasi email resmi dari Single PIC Klien.

---

## 3. Protokol Penegakan Aturan Single PIC

### Kasus: Staf Klien Lain Memberikan Instruksi Mendadak
Sering kali staf lapangan atau manajer lain di kantor klien meminta: *"Tolong tambahin kolom ini di laporan ya, penting banget."*

### Respon Standar Solo Developer:
> *"Terima kasih atas informasinya, Mas/Mbak [Nama Staf]. Sesuai Project Charter yang ditandatangani manajemen [Nama Perusahaan Klien], seluruh arahan perubahan fungsionalitas wajib divalidasi satu pintu melalui **[Nama Single PIC]**. Mohon disampaikan ke beliau agar dapat diinstruksikan secara tertulis ke saya. Hal ini untuk memastikan seluruh sistem tetap sinkron dan jadwal peluncuran tetap aman."*

---

## 4. Disiplin Termin Pembayaran (Payment Gating & Work Pause)

### Aturan Emas Arus Kas Solo Dev:
1. **No DP, No Work**: Jangan membuat sketsa UI mendalam atau menulis baris kode pertama sebelum DP Termin 1 masuk ke rekening.
2. **Staging is Yours, Production is Gated**:
   - Selama proses pengembangan hingga UAT, deploy hanya dilakukan di server staging milik akun developer sendiri.
   - Jangan pernah melakukan pointing domain klien atau instalasi di server produksi klien sebelum pembayaran termin UAT diterima.
3. **Protokol Hentikan Kerja Sementara (Work Pause Protocol)**:
   - Jika pembayaran termin terlambat lebih dari **7 hari kerja** sejak invoice dikirim:
     1. Kirim surat pemberitahuan penghentian sementara pekerjaan (*Notice of Work Suspension*).
     2. Hentikan seluruh aktivitas koding dan pengujian.
     3. Jadwal rilis resmi ditunda sampai pembayaran diselesaikan.

---

## 5. Batasan Pertahanan Hukum (Legal Shield)

Untuk menghindari tuntutan hukum tidak masuk akal dari klien skala korporat:

1. **Liability Cap (Batas Maksimal Ganti Rugi)**:
   - Pastikan di dalam SOW selalu ada klausul: *"Total liabilitas finansial maksimum Developer dibatasi maksimal sebesar total nilai uang yang telah diterima Developer dari Klien."*
2. **Klausul Disclaimer Teknologi**:
   - Untuk aplikasi di ranah sensitif (legal-tech, fintech, edutech): Nyatakan bahwa developer menyediakan perangkat lunak, bukan pemberi fatwa hukum, penasihat keuangan berlisensi, atau institusi penjamin simpanan.
3. **Penahanan Hak Cipta (IP Retention)**:
   - Hak kekayaan intelektual atas kode sumber baru beralih kepada klien pada saat **Pelunasan 100% dan penandatanganan Berita Acara Serah Terima (BAST)**.
