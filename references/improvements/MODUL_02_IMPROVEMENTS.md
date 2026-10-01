# Modul 02: Discovery & Scope Definition Improvements

> **Purpose**: Supplement Modul 02 dengan 8 critical missing sections: Timeline, MoSCoW Over-Limit Protocol, Dependency Deadlock Protocol, Solo Dev Simplified Workflow, Out-of-Scope Trap Items, Discovery Red-Flags, SMART Success Criteria, Client Data Quality Standard.
>
> **Last Updated**: 2026-09-30  
> **Target**: Solo developers executing Modul 02 (Discovery & Scope)

---

## 1. Timeline Estimation (CRITICAL — Missing in Core Module)

### Problem
Module tidak mention berapa hari/minggu untuk complete Modul 02. Discovery + MoSCoW + Stakeholder docs = minimal 3-5 hari, bukan 1 hari.

### Solution: Timeline by Scale

**Fast-Track (Solo Dev Product / Simple Client):**
- **Duration**: 1-2 hari
- **Deliverable**: `SCOPE_STATEMENT.md` basic (In/Out-Scope, MoSCoW, Dependency SLA)
- **Skip**: STAKEHOLDER_MAP, COMMUNICATION_PLAN, RACI_MATRIX (overkill untuk 1-2 orang)
- **Use case**: Freelance project, startup MVP, personal product

**Standard (B2B Client / Agency Project):**
- **Duration**: 3-5 hari
- **Deliverable**: Full SCOPE_STATEMENT + STAKEHOLDER_MAP + COMMUNICATION_PLAN + RACI_MATRIX
- **Use case**: Client punya tim 3-5 orang, approval chain unclear, multi-departemen

**Enterprise (Formal RFP / Regulated Industry):**
- **Duration**: 2-4 minggu
- **Deliverable**: Multi-divisi workshop, formal RTM draft, compliance scope checklist
- **Use case**: Bank, BUMN, government, healthcare (multi-stakeholder, compliance-heavy)

---

## 2. MoSCoW Over-Limit Protocol (CRITICAL)

### Problem
Module mention limits (Kecil 3-7 Must-Have, Menengah 8-15, dll) tapi tidak ada **process flow** jika client insist semua fitur Must-Have.

### Solution: Over-Limit Decision Tree

**If Must-Have count > scale limit:**

**STEP 1: STOP & Alert Client**
```
"Risk: X Must-Have fitur melebihi limit Y untuk skala [Kecil/Menengah].
Risk: Overload solo dev bandwidth → quality drop, timeline slip, burnout.
Need re-prioritization sebelum lanjut."
```

**STEP 2: Present 4 Options**

| Option | Action | Impact | Cost/Time |
|--------|--------|--------|-----------|
| **A. Re-prioritize** | Force-rank top N fitur, degrade sisanya ke Should-Have (Phase 2) | Timeline sama, scope berkurang | No extra cost |
| **B. Phase Split** | Must-Have fase 1 (launch 8 minggu) + fase 2 (launch +12 minggu) | 2 releases, iterative feedback | Phase 2 charge separate |
| **C. Scale Up** | Hire co-developer untuk handle overflow fitur | Timeline sama, scope sama | Cost +Rp 15-30 juta |
| **D. Extend Timeline** | +50% timeline untuk accommodate semua fitur solo | Scope sama, timeline +4-6 minggu | No extra cost (if hourly), or renegotiate fixed price |

**STEP 3: Client Decision**
- Client pick 1 option, document di `SCOPE_STATEMENT.md` section "Must-Have Overflow Resolution"
- Update MoSCoW table: Move degraded fitur ke Should-Have/Phase 2

**STEP 4: Re-verify Scope**
- Confirm final Must-Have count ≤ limit
- Update timeline estimate di PROJECT_CHARTER.md

---

## 3. Dependency Deadlock Protocol (CRITICAL)

### Problem
Module ada klausul "Keterlambatan ≥3 hari → geser deadline" tapi tidak ada protocol jika client **never deliver** (stuck 2+ minggu).

### Solution: Escalation Ladder

**Day 1-3: Gentle Reminder**
```
"Hi [Client], reminder data [X] due today untuk keep timeline on track.
ETA kapan bisa kirim?"
```

**Day 4-7: Formal Notice (Email)**
```
Subject: [PROJECT] Data Dependency Overdue — Timeline Impact

Hi [Client],

Data [X] overdue 4 hari. Impact:
- Original launch: [Date A]
- Revised launch (if delivered today): [Date A + 4 hari]

Please confirm delivery ETA by EOD tomorrow, atau kita schedule call untuk discuss workaround.
```

**Day 8-14: Pause Notice**
```
Subject: [PROJECT] Work Paused — Awaiting Data Dependency

Hi [Client],

Data [X] overdue 10 hari. Effective today, development work PAUSED until dependency delivered.

Options:
1. Deliver data [X] ASAP → Resume work
2. Use mock/dummy data workaround (charge +Rp [Y] for mock data generation + cleanup later)
3. Extend pause → Timeline shifts proportionally

Please advise by [Date].
```

**Day 15-30: Termination Warning**
```
Subject: [PROJECT] Contract Termination Risk — 30-Day Dependency Delay

Hi [Client],

Data [X] overdue 21 hari. Project cannot proceed without this dependency.

Per SOW Clause [X.Y], if dependency delay >30 hari:
- Contract may be terminated
- Down Payment (DP) non-refundable
- Hours worked billed at hourly rate Rp [Z]/hour

Deadline to deliver: [Date] (9 hari remaining)

Let's schedule call to discuss resolution.
```

**Day 31+: Termination Execution**
```
Subject: [PROJECT] Contract Terminated — Dependency Not Delivered

Hi [Client],

Per SOW Clause [X.Y] and prior notices, contract terminated effective today due to 30+ hari dependency delay.

Final invoice:
- Down Payment (non-refundable): Rp [A]
- Hours worked (Week 1-4): [X] hours × Rp [Z]/hour = Rp [B]
- Total due: Rp [B - A] (DP already paid)

Code delivered to date: [GitHub commit hash / archive link]
Partial deliverables: [List]

Thank you for the opportunity. Available to resume if dependency resolved in future.
```

---

## 4. Solo Dev Simplified Workflow (CRITICAL)

### Problem
Default Modul 02 workflow sangat detail (4 dokumen: SCOPE_STATEMENT, STAKEHOLDER_MAP, COMMUNICATION_PLAN, RACI_MATRIX). Risk: Solo dev spend 2 hari bikin dokumen PM yang gak dibaca client.

### Solution: Fast-Track 1-Day Workflow

**Solo Dev Fast-Track (1 hari):**

**WAJIB:**
- ✅ `SCOPE_STATEMENT.md` (In/Out-Scope, MoSCoW, Dependency SLA)

**SKIP (replace dengan 1 paragraph di SCOPE_STATEMENT):**
- ❌ `STAKEHOLDER_MAP.md` → Add 1 paragraph: "Stakeholder: [Client Name] (Decision Maker), [User Name] (Feedback Provider)"
- ❌ `COMMUNICATION_PLAN.md` → Add 1 paragraph: "Update: Weekly Friday 5pm via WhatsApp. Approval turnaround: Max 2 hari (deemed approved after)."
- ❌ `RACI_MATRIX.md` → Obvious: Solo Dev = R (Responsible), Client = A (Accountable) for semua deliverables

**When to Use Full Workflow (3-5 hari):**
- ✅ Client punya tim ≥3 orang
- ✅ Multi-departemen (IT, Finance, Operations, Marketing)
- ✅ Approval chain unclear (banyak yang comment, gak jelas siapa decide)
- ✅ Budget >Rp 50 juta (formal project, perlu documentation audit trail)

**Template Simplified SCOPE_STATEMENT (Append Sections):**

```markdown
## 6. Stakeholder & Communication

**Stakeholder:**
- [Client Name], [Title] — Decision Maker (Accountable for all approvals)
- [User Name], [Title] — User Representative (Feedback provider)

**Communication:**
- **Update cadence**: Weekly status Friday 5pm via WhatsApp/Email
- **Approval SLA**: Max 48 jam. After 48 jam no response = deemed approved (to keep timeline on track)
- **Emergency contact**: [Phone number] (for production-down issues only)

**RACI Summary**: Solo Dev = Responsible (R) for all development. Client = Accountable (A) for all approvals.
```

---

## 5. Out-of-Scope Trap Items Checklist (CRITICAL)

### Problem
Module ada 3 contoh Out-of-Scope tapi kurang **trap items** yang sering jadi sengketa post-launch.

### Solution: Mandatory Out-of-Scope Items

**WAJIB tulis eksplisit di Out-of-Scope section:**

```markdown
## Out-of-Scope (Explicitly Excluded)

The following are OUT OF SCOPE and will NOT be provided unless separately contracted:

**Training & Support:**
- ❌ Unlimited training sessions → ✅ Max 2 training sessions @ 2 hours each. Additional training: Rp [X]/hour
- ❌ Lifetime maintenance → ✅ Warranty: 30-60 days post-launch bug fixes only. After: Monthly retainer Rp [Y]/month

**Design & Content:**
- ❌ Unlimited UI revision rounds → ✅ UI design: 2 revision rounds included. Extra round: Rp [Z] each
- ❌ Data entry by developer → ✅ Client responsible for inputting master data (products, users, etc). Developer provides import tools only
- ❌ Content writing (blogs, FAQs, product descriptions) → ✅ Client provides all text content. Developer integrates content only
- ❌ Graphic design (custom illustrations, infographics) → ✅ Developer uses stock images/icons. Custom graphics: hire separate designer

**Marketing & SEO:**
- ❌ SEO optimization & Google ranking → ✅ Developer ensures technical SEO basics (meta tags, sitemap). Google Ads/content SEO: hire SEO specialist
- ❌ Social media management → ✅ Developer provides social share buttons. Posting/scheduling: client responsibility

**Infrastructure & Operations:**
- ❌ 24/7 server monitoring & on-call support → ✅ Developer sets up server initial config. 24/7 monitoring: use managed hosting (e.g., Vercel) or hire DevOps
- ❌ Custom report generation per user request → ✅ Report formats fixed per PRD. Custom reports = Change Request (charged separately)

**Third-Party Services:**
- ❌ Payment of third-party licenses (fonts, APIs, hosting) → ✅ Client pays directly for Midtrans, SendGrid, AWS, etc. Developer configures only
- ❌ Legal compliance audit (e.g., ISO 27001, SOC2) → ✅ Developer follows OWASP Top 10 & UU PDP basics. Formal audit: hire external auditor

**Legacy System Integration:**
- ❌ Fixing bugs in client's legacy system → ✅ Developer integrates with legacy API as-is. Bugs in legacy system: client's vendor fixes
- ❌ Data migration from corrupted/unstructured sources → ✅ Client provides clean CSV/JSON. Data cleaning: charge Rp [X]/hour

**Hardware & Office IT:**
- ❌ Fixing client's office network/firewall/printers → ✅ Developer delivers software only. Hardware/network issues: client's IT team
```

---

## 6. Discovery Red-Flags (CRITICAL)

### Problem
Module reference `REQUIREMENT_ELICITATION_GUIDE.md` tapi module file sendiri tidak mention **red-flags** yang harus alert solo dev untuk STOP & renegotiate.

### Solution: Red-Flag Detection Checklist

**STOP & Re-negotiate if detect during discovery:**

| Red-Flag | Risk | Action |
|----------|------|--------|
| 🚩 **No Single PIC** — Client gak bisa jawab "Siapa yang decide final approval?" | Multi-stakeholder hell, endless revision loop, approval deadlock | STOP: Demand Single PIC appointment in writing. No work until designated |
| 🚩 **No Sample Data/Wireframe** — Client bilang "terserah kamu aja" untuk UI | Scope kabur, risk endless "bukan gini maksudku" post-development | STOP: Require client provide reference apps (3 screenshots) or approval bahwa developer full control design |
| 🚩 **Budget-Feature Mismatch** — Client expect "mirip Tokopedia" tapi budget Rp 5 juta | Unrealistic expectation, guaranteed disappointment | STOP: Show comparable project cost (Rp 50-100 juta). Offer scaled-down MVP or refer to agency |
| 🚩 **Vague Scope** — Client minta "fleksibel, nanti kita lihat aja", menolak commit MoSCoW | Scope creep guaranteed, never-ending project | STOP: Explain fixed-scope model. If client insist fleksibel, charge T&M (Time & Material) hourly rate only |
| 🚩 **Feature Overload** — Client bilang "simple kok" tapi list 20+ Must-Have fitur | Under-estimate complexity, timeline akan overrun | STOP: Apply MoSCoW limits. Force client rank top 7 fitur, defer rest to Phase 2 |
| 🚩 **Unrealistic Timeline** — Client minta "selesai 2 minggu, kan cuma form input" padahal ada payment, email, report | Impossible deadline, setup for failure | STOP: Show realistic timeline (4-8 minggu). Explain technical dependencies. Offer fast-track option (drop fitur) |
| 🚩 **Multiple Decision Makers** — "Saya dan partner saya decide bareng" tapi mereka sering disagree | Approval deadlock, stuck di revision hell | STOP: Require voting mechanism (siapa casting vote?) or separate PIC per module (Design vs Backend) |

**Polite Challenge Script:**
```
"Terima kasih untuk requirement-nya. Saya notice beberapa hal yang perlu kita align dulu sebelum lanjut:

1. [Red-flag detected, e.g., No Single PIC]
2. [Impact explanation, e.g., Risk approval deadlock]
3. [Solution proposal, e.g., Designate 1 person sebagai final decision maker]

Bisa kita schedule 30-min call untuk clarify? Ini penting untuk protect timeline dan budget kita berdua."
```

---

## 7. SMART Success Criteria Template (IMPORTANT)

### Problem
Module ada example Bad vs Good success criteria tapi tidak ada **SMART framework** untuk validate.

### Solution: SMART Checklist

**Every success criteria MUST be:**

**S — Specific**: Jelas WHAT & WHO
- ❌ Bad: "Dashboard yang bagus"
- ✅ Good: "Dashboard untuk Finance Manager dengan 5 widget: Revenue, Orders, Top Products, User Growth, System Alerts"

**M — Measurable**: Ada angka/metric konkrit
- ❌ Bad: "Cepat dan responsif"
- ✅ Good: "Page load <2s (Desktop), <3s (Mobile 3G), Uptime >99.5%"

**A — Achievable**: Realistic dengan tech stack & bandwidth solo dev
- ❌ Bad: "Support unlimited concurrent users"
- ✅ Good: "Support 100-500 concurrent users (scale: Vercel Pro plan, PostgreSQL 100 connections)"

**R — Relevant**: Solve real problem, ada impact measurement
- ❌ Bad: "Ada dark mode toggle"
- ✅ Good: "Reduce manual reporting time dari 10 jam/minggu → 5 menit/hari (automate Excel export)"

**T — Time-bound**: Ada deadline & milestone jelas
- ❌ Bad: "Launch secepat mungkin"
- ✅ Good: "MVP launch Week 8 (10 Must-Have fitur), Phase 2 launch Week 20 (5 Should-Have fitur)"

**SMART Template Example:**

```markdown
## Success Criteria (SMART)

**Goal**: Automate sales reporting untuk reduce manual work

**Specific**: 
- Dashboard for Sales Manager
- 5 core reports: Daily Sales, Top Products, Sales by Region, Target Progress, Inventory Alerts
- Export to Excel (1-click)

**Measurable**:
- Report generation: <5 seconds
- Excel export: <10 seconds for 10,000 rows
- Mobile responsive: 320px - 1920px
- Uptime: >99.5% (measure via UptimeRobot)

**Achievable**:
- Tech stack: Next.js + PostgreSQL + Vercel
- Solo dev bandwidth: 20 jam/minggu × 8 minggu = 160 jam
- Comparable project: [Reference app X] delivered in 6 minggu

**Relevant**:
- Current pain: Manual Excel consolidation 10 jam/minggu
- Target: Automate to 5 menit/hari (save 9.5 jam/minggu = Rp [X] labor cost/bulan)
- ROI: Break-even in 3 bulan

**Time-bound**:
- Week 1-2: Discovery & Design
- Week 3-6: Development (Backend + Frontend)
- Week 7: QA & Bug Fix
- Week 8: UAT & Launch
- Week 9-10: Warranty period (bug fixes only)
```

---

## 8. Client Data Acceptance Criteria (IMPORTANT)

### Problem
Module mention "Master data dalam format digital terstruktur" tapi tidak ada **data quality checklist** untuk accept/reject client data.

### Solution: Data Quality Standard

**Data dianggap VALID & READY jika:**

| Criteria | Valid ✅ | Invalid ❌ | Action if Invalid |
|----------|---------|-----------|-------------------|
| **Format** | CSV, Excel (.xlsx), JSON | Screenshot Excel di Word/PPT, PDF scan, foto WhatsApp | REJECT: Request proper export dari source system |
| **Structure** | Setiap row punya kolom yang sama, no merged cells | Merged cells, inconsistent columns per row | REJECT: Client unmerge & restructure |
| **Continuity** | Data kontinyu, no blank rows (except header) | Random blank rows, footer/summary mixed di data | REJECT: Client remove blank rows |
| **Header** | Baris 1 adalah nama kolom jelas (ProductName, Price, Stock) | Logo, alamat perusahaan, tanggal laporan di baris 1-5 | REJECT: Client remove header noise |
| **Encoding** | UTF-8 (nama Indonesia tampil benar: "Bakso", "Jökull") | Corrupt text ("��kawan", "BÃ¡nh MÃ¬") | REJECT: Client re-export dengan UTF-8 encoding |
| **Completeness** | Kolom mandatory terisi semua (no NULL di primary key) | Missing ID, nama kosong, harga NULL | REJECT: Client fill mandatory fields or mark deletable rows |

**Rejected Data Examples:**

❌ **Screenshot Excel di Word/PPT**
```
Problem: Not machine-readable, cannot import programmatically
Solution: Client export original Excel file (.xlsx)
```

❌ **PDF Scan Buku Manual**
```
Problem: OCR tidak guaranteed 100% akurat, manual correction required
Solution: Client re-type to Excel (or developer charge data entry Rp [X]/hour)
```

❌ **Mixed Format Data**
```
Problem: Row 1-10 pakai format A (3 kolom), row 11-20 format B (5 kolom)
Solution: Client standardize to 1 format
```

**Data Cleaning Fee Structure:**

If client deliver invalid data & insist developer clean:
- **Minor cleaning** (remove blank rows, fix encoding): Rp 500k - 1 juta (1-2 jam)
- **Moderate cleaning** (restructure columns, fill missing data): Rp 2-5 juta (1-2 hari)
- **Heavy cleaning** (OCR PDF, manual re-type): Rp 10-20 juta (1-2 minggu) — REJECT, suruh client hire data entry vendor

**Data Delivery SLA:**

```markdown
## Client Data Delivery SLA

**Data Required**: [List: Master Products, User List, Historical Transactions]

**Delivery Deadline**: [Date] (Week 2 of project)

**Acceptance Criteria**: Per Data Quality Standard (see above)

**Process**:
1. Client submit data → Developer review within 2 hari
2. If VALID: Proceed to migration
3. If INVALID: Return with rejection note → Client fix & resubmit → Review again
4. Max 2 resubmit rounds. After 2 rejections, charge data cleaning fee or pause project

**Late Delivery Impact**: Every 3 hari delay → Launch date shifts +3 hari (no penalty to developer)
```

---

## Summary: 8 Critical Improvements

| # | Improvement | Impact | Priority |
|---|-------------|--------|----------|
| 1 | Timeline Estimation (1-2 hari / 3-5 hari / 2-4 minggu) | Set realistic expectation, prevent "deadline besok" request | 🔴 CRITICAL |
| 2 | MoSCoW Over-Limit Protocol (4 options: re-prioritize/phase/scale/extend) | Prevent feature overload, protect solo dev bandwidth | 🔴 CRITICAL |
| 3 | Dependency Deadlock Protocol (pause Day 14, terminate Day 31) | Prevent stuck project, protect developer from unpaid wait time | 🔴 CRITICAL |
| 4 | Solo Dev Simplified Workflow (1 hari, SCOPE_STATEMENT only) | Save 1-2 hari paperwork, pragmatic for small projects | 🔴 CRITICAL |
| 5 | Out-of-Scope Trap Items (training, maintenance, revisi, data entry, SEO, 24/7, custom report) | Prevent post-launch sengketa "kok gak termasuk?" | 🔴 CRITICAL |
| 6 | Discovery Red-Flags (No PIC, no sample, budget mismatch, vague scope, overload, unrealistic) | Early warning system, STOP bad projects before invest time | 🔴 CRITICAL |
| 7 | SMART Success Criteria (Specific, Measurable, Achievable, Relevant, Time-bound) | Alignment expectation, prevent "selesai tapi gak sesuai harapan" | 🟡 IMPORTANT |
| 8 | Data Quality Standard (format, struktur, encoding, acceptance/rejection criteria) | Prevent "data cleaning hell", protect from unpaid data janitor work | 🟡 IMPORTANT |

---

**Use Case Example: Solo Dev Fast-Track (1 Day)**

**Input**: Client request web app "inventory + sales report", budget Rp 15 juta, timeline 6 minggu

**Modul 02 Execution:**

**Hour 1-2: Discovery Call**
- Use REQUIREMENT_ELICITATION_GUIDE.md (5 Pillars)
- Detect red-flags: Check PIC, budget realism, sample data availability
- Result: Client punya Single PIC ✅, budget realistic ✅, no red-flags ✅

**Hour 3-4: MoSCoW Breakdown**
- List fitur: 12 fitur total
- Classify: 6 Must-Have, 4 Should-Have, 2 Won't-Have
- Check limit: Menengah scale = max 15 Must-Have ✅ (6 < 15, within limit)

**Hour 5-6: Write SCOPE_STATEMENT.md (Simplified)**
- In-Scope: 6 Must-Have fitur
- Out-of-Scope: Trap items checklist (training unlimited, maintenance forever, data entry, SEO, 24/7, custom report)
- Client Dependency SLA: Master data CSV format by Week 2, API keys by Week 1
- Success Criteria: SMART format (5 widget dashboard, <2s load, 100 concurrent users, save 10 jam/minggu, launch Week 6)
- Stakeholder & Communication: 1 paragraph (Weekly update Friday, approval max 2 hari)

**Hour 7: Review & Approval**
- Send SCOPE_STATEMENT.md to client
- Client approve via WhatsApp ✅

**Hour 8: Commit & Gate**
- `git add docs/pm/SCOPE_STATEMENT.md && git commit`
- Self-verify: File exists ✅, 60+ lines ✅, Must-Have 6 (within limit) ✅, Out-of-Scope ≥3 ✅
- END TURN, await user approval to proceed Modul 03

**Total Time**: 8 jam (1 hari kerja) ✅

---

**Next Steps After Loading This Reference:**

1. Load `modules/02-discovery-scope.md` (core framework)
2. Load `references/improvements/MODUL_02_IMPROVEMENTS.md` (this file — 8 critical supplements)
3. Load `references/checklists/MODUL_02_EVALUATION_CHECKLIST.md` (quality gate checklist)
4. Load `references/checklists/REQUIREMENT_ELICITATION_GUIDE.md` (5 Pillars question bank)
5. Execute Modul 02 dengan full context (core + improvements + checklist + elicitation guide)

**Agent must apply ALL 8 improvements during Modul 02 execution, not just core module alone.**
