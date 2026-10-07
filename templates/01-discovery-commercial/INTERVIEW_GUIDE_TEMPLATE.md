# User & Stakeholder Interview Guide (Discovery & Problem Validation)

> **Purpose**: Standardized, non-leading interview protocol for validating customer pain points, current workarounds, willingness to pay, and operational bottlenecks before writing software specifications or code.
> **Methodology**: Grounded in **Jobs-to-be-Done (JTBD)** and **The Mom Test** principles (talking about concrete past behavior and actual money spent, never hypothetical praise).
> **Mandatory Evidence Rule**: Primary research data must originate from real human conversations. Agents are strictly prohibited from generating synthetic interview quotes.
> **Output Location**: `docs/pm/INTERVIEW_GUIDE.md` (interviews logged in `docs/pm/USER_RESEARCH_REPORT.md` or `docs/pm/M00_LITE.md`)

---

## 1. Interview Setup & Metadata

- **Project Name**: [Application / System Name]
- **Target Persona / Role**: [e.g., Retail Store Owner / Operations Manager / Cashier]
- **Target Stakeholder Group**: `[Group A: End User / Group B: Economic Buyer / Group C: Ecosystem]`
- **Lead Interviewer**: [Your Name / Solo Dev]
- **Target Number of Interviews**: [Minimum 5 for M00-lite; 10–15 for Medium/Large]
- **Average Duration**: 30–45 minutes per session
- **Incentive / Honorarium**: [Rp 50k–100k e-wallet voucher / Free early access / None]

### Data Confidence Legend
| Icon | Level | Meaning | Rule |
|:--:|:--|:--|:--|
| ✅ | **VERIFIED** | Direct quote or empirical metric confirmed during live interview | Must cite Interview ID and recording/notes timestamp |
| 🔶 | **ASSUMPTION** | Working hypothesis extrapolated from respondent comments | Cataloged in Assumption Register for quantitative survey testing |
| ❓ | **UNKNOWN** | Conflicting statement or unasked question | Flagged for follow-up inquiry |

---

## 2. Core Non-Leading Principles (The Mom Test Protocol)

1. **Ask About the Past, Never the Future**:
   - ❌ *Leading*: "Would you use an app that automatically syncs stock to the cloud?" $\rightarrow$ Everyone politely says "yes".
   - ✅ *Behavioral*: "How did you update your stock balance yesterday? When was the last time records didn't match physical stock? What did you do?"
2. **Seek Concrete Quantified Losses**:
   - ❌ *Vague*: "Is stock discrepancy a big problem for you?"
   - ✅ *Quantified*: "Over the last 30 days, how much money or how many hours did your team spend investigating stock mismatches?"
3. **Investigate Current Workarounds (Proof of Real Pain)**:
   - If the respondent has not actively searched for, built a spreadsheet for, or paid for a workaround, the problem **IS NOT PAINFUL ENOUGH** to justify building a B2B SaaS product.
4. **Distinguish Interest from Willingness to Pay**:
   - Compliments (*"That sounds like a great idea!"*) are worthless data. Only past expenditures, active software budgets, or deposit commitments count as validation.

---

## 3. The 5-Act Interview Framework

### Act 1: Warm-Up & Context (3–5 min)
*Goal: Establish rapport, set expectations, and obtain recording consent.*
- "Thank you for taking the time to speak with me today. I am researching how businesses in [industry] manage [domain workflow, e.g. inventory and daily sales]."
- "I'm not here to sell you anything or pitch any software. I just want to learn about how you currently run your day-to-day operations."
- "Do you mind if I record our audio solely for taking accurate notes? The recording will remain strictly confidential."
- *Context Questions*:
  - "Can you tell me a bit about your business? How many branches, staff members, and daily transactions do you typically manage?"

---

### Act 2: Current Workflow & Tools (7–10 min)
*Goal: Understand the baseline operational workflow and tool stack.*
- "Walk me through how you handle [core workflow] from start to finish on a typical day."
- "What tools or methods do you use right now? (e.g., pen and paper ledgers, Excel spreadsheets, POS apps, WhatsApp messages)?"
- "Who on your team touches this data? How does information get handed off between staff members?"
- "Where does the data end up at the end of the day or month?"

---

### Act 3: Deep-Dive into Pain Points & Quantifiable Losses (10–15 min)
*Goal: Uncover the emotional frustration and financial/time loss of the primary bottleneck.*
- "When you think about this entire process, what is the single most frustrating or time-consuming part?"
- "Can you tell me about the last time that went wrong? What happened?"
- "What was the actual consequence when that happened? Did you lose money, delay customers, or have to work overtime?"
- "Roughly how many hours per week do you or your team spend dealing with that specific issue?"
- "Have you ever tried to fix this problem before? What happened when you tried?"

---

### Act 4: Evaluating Alternatives & Free/Government Workarounds (5–7 min)
*Goal: Discover direct competitors, spreadsheets, and free statutory platforms.*
- "What other software or solutions have you considered or tested in the past?"
- "If you tested [Competitor X or Free Tool like BI SIAPIK / Excel], why did you choose not to use it, or why did you stop?"
- "What is missing from the existing tools on the market that forces you to keep using spreadsheets or paper?"

---

### Act 5: Willingness to Pay & Procurement Authority (5–10 min)
*Goal: Establish pricing anchors and decision-making hierarchy (Group B).*
- "How much do you currently spend per month on software or tools to run your business?"
- "If a reliable solution eliminated [specific pain point] entirely, what monthly price would feel like:
  - Too cheap (you would question its quality): Rp [Amount]
  - A good deal / bargain: Rp [Amount]
  - Expensive, but you would still buy it: Rp [Amount]
  - Too expensive (you would immediately reject it): Rp [Amount]"
- "If you decided to adopt a tool like this, who in your organization has the final authority to approve the purchase?"
- "What would hold you back from adopting a new system next week?"

---

## 4. Specialized Question Banks by Stakeholder Group

### Group A: Daily End-Users & Operators (Cashiers, Clerks, Staff)
- "What is the slowest part of your shift when serving customers or updating records?"
- "What happens when the internet connection drops or runs slow? Does the system stop working?"
- "What mistakes happen most frequently during data entry? How do you catch or fix them?"
- "If you could change one button or screen in the software you use today, what would it be?"

### Group B: Economic Buyers & Business Owners (Founders, CFOs, Directors)
- "How does this operational friction impact your bottom line or monthly profitability?"
- "If an employee makes a recording error, what is the maximum financial loss your business has experienced in a single month?"
- "What return on investment (ROI) would you expect before approving a software purchase of Rp 100k–500k/month?"
- "How long does it take for you to train new staff on your current tools?"

### Group C: Ecosystem Stakeholders, Regulators & Advisors (Tax Consultants, Accountants, Banks)
- "What reporting standards (e.g., SAK EMKM, standard P&L) do these businesses fail to meet most often?"
- "When tax authorities or auditors request documentation, what data is usually missing or corrupted?"
- "What statutory regulations (e.g., UU PDP, PPh Final PP 20/2026, electronic invoice rules) are most frequently neglected by small business platforms?"
- "What compliance integration would make client data 10x easier for you to review?"

---

## 5. Interview Capture & Summary Template

*Copy this block for each completed interview transcript:*

```markdown
### Interview Log: INT-[01]
- **Respondent Name / Pseudonym**: [e.g., Pak Hendra]
- **Role & Company Profile**: [e.g., Owner, Minimarket Retail (2 branches, 4 staff)]
- **Stakeholder Group**: [Group B: Economic Buyer]
- **Date & Duration**: [YYYY-MM-DD] | 38 minutes
- **Evidence Verification**: ✅ Audio recording archived / Timestamped notes verified

#### 1. Core Jobs-To-Be-Done (JTBD)
- **When**: Closing daily store registers across 2 separate locations,
- **I want to**: Verify stock counts against cash receipts without calling branch staff,
- **So that**: I can immediately detect discrepancies before staff shifts end.

#### 2. Key Pain Points & Quantified Impact
1. **Critical Pain**: Stock shrinkage averages Rp 1.5M/month per branch (total Rp 3M/month loss). [✅ Verified]
2. **Time Loss**: Spends 1.5 hours every evening manually reconciling Excel spreadsheets. [✅ Verified]
3. **Connectivity Friction**: Existing cloud app freezes when indihome/cellular drops during rush hour. [✅ Verified]

#### 3. Current Workarounds
- Uses physical printed ledger + WhatsApp photo updates sent by cashier at 21:00.

#### 4. Willingness to Pay & Decision Authority
- **Current Software Spend**: Rp 0 (relies on free Google Sheets).
- **Price Anchor**: Considers Rp 150k/month a reasonable price if offline-mode is seamless.
- **Decision Authority**: Sole owner, full buying authority.

#### 5. Golden Verbatim Quotes
> "Kalau aplikasi kasir mati pas mati lampu atau sinyal jelek, antrean toko saya langsung macet. Akhirnya kasir saya catat di kertas lagi, dan besoknya selisih stok Rp 200 ribu nggak ada yang ngaku."
```

---

## 6. Interview Synthesis & Exit Criteria

Before declaring the qualitative discovery phase complete in Module 00 / Module 01:
- [ ] At least **5 (for M00-lite)** or **10 (for Standard M00)** interviews completed across target stakeholder groups.
- [ ] At least **3 respondents** have confirmed a quantifiable recurring financial or time loss.
- [ ] At least **3 respondents** have demonstrated an active willingness to pay with explicit price anchors.
- [ ] All interview quotes and metrics cited in `USER_RESEARCH_REPORT.md` are linked to an active `INT-xx` log.
- [ ] Zero synthetic, fictional, or AI-hallucinated interview quotes exist in the deliverable.
