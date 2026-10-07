# User Research Report

**Research Date**: [YYYY-MM-DD] to [YYYY-MM-DD]  
**Created By**: [Team Name / Solo Dev]  
**Document Version**: 1.0  
**Research Lead**: [Researcher Name]
**Research Status**: [PENDING_PRIMARY_RESEARCH / IN_PROGRESS / VALIDATED]

---

> ⚠️ **MANDATORY EVIDENCE RULE FOR AI AGENTS & DEVELOPERS**:
> - Primary research data (interview quotes, survey sample metrics, willingness-to-pay amounts) **MUST ORIGINATE FROM REAL HUMAN USERS**.
> - Agents are **STRICTLY FORBIDDEN** from fabricating fictional interview transcripts or synthetic survey percentages to pass gates.
> - If real research has not yet been conducted by the user, the agent drafts the research instruments (interview scripts, survey questionnaire, assumption register), marks results as `PENDING`, and sets the Gate status to **`PENDING_PRIMARY_RESEARCH`**.
> - Personas generated prior to interviews MUST be labeled as **`Proto-Persona (Hypothesis)`**.

### Data Confidence Legend
| Icon | Level | Meaning | Rule |
|:--:|:--|:--|:--|
| ✅ | **VERIFIED** | Empirical data from real user interviews, live analytics, or verified primary sources | Must cite interview ID, sample size, URL, and date |
| 🔶 | **ASSUMPTION** | Plausible hypothesis based on secondary insights or domain experience | Must be cataloged in Assumption Register below |
| ❓ | **UNKNOWN** | Critical information gap | Must be tested before committing to architecture/code |

---

## 1. Executive Summary

**Research Objectives**:
[1-2 sentences: What do you want to validate from this research?]

**Key Findings (Top 3)**:
1. **[Finding 1]**: [Most critical insight from user research]
2. **[Finding 2]**: [Second key insight]
3. **[Finding 3]**: [Third key insight]

**Intent-to-Buy Validation**:
- **Stated Intent (Survey)**: [X]% respondents selected "Definitely buy" or "Probably buy" (Threshold: $\ge 30\%$)
- **Behavioral Intent (Cheap Test)**: [Waitlist conversion rate % / LOI signed / Pre-orders]
- **Gate Status**: 
  - [ ] **✅ PASS**: Validated with $\ge 30\%$ intent-to-buy from real sample + behavioral proof
  - [ ] **⏳ PENDING_PRIMARY_RESEARCH**: Instruments prepared; awaiting human research execution
  - [ ] **❌ FAIL**: Real data collected but intent-to-buy $< 30\%$ $\rightarrow$ Trigger Pivot / Stop

**Recommendation**:
- [ ] **Proceed to Product Strategy**: Validated problem, clear user needs, sufficient intent-to-buy.
- [ ] **Pivot**: Pain points validated but solution fit is unclear; adjust positioning.
- [ ] **Stop**: Intent-to-buy <30%, insufficient willingness to pay.

---

## 2. Assumption Register & Riskiest Assumption Tests (RAT)

*Rule: Identify premises in the idea brief and test the riskiest assumption first before building software.*

| ID | Premise / Core Hypothesis | Confidence | Evidence Required | Cheap Test Method | Kill Threshold | Status |
|:---|:--------------------------|:----------:|:------------------|:------------------|:------------------------------|:-------|
| ASM-01 | [e.g., SME owners lose > Rp 2M/mo from stock mismatch] | 🔶 | 5+ user interview confirmations with ledger proofs | Interview Group A & B | <3 of 5 experience material loss | [Open / Tested / Disproven] |
| ASM-02 | [e.g., Users will pay Rp 150k/mo for automated sync] | 🔶 | Landing page waitlist with price anchor | Landing page + pricing CTA | Waitlist conversion < 3% from 200 visits | [Open / Tested / Disproven] |
| ASM-03 | [e.g., Staff can operate UI without >15m training] | 🔶 | Usability test with clickable prototype | Task completion test (SCR-01) | >50% fail unassisted checkout | [Open / Tested / Disproven] |

---

## 3. Research Methodology & Multi-Stakeholder Groups

### 2.1 Sample Size & Demographics

Qualitative Research (Interviews):
- **Total Interviews Completed**: [X] people (Target: $\ge 10$ for standard, $\ge 5$ for M00-lite)
- **Duration per Interview**: [Y] minutes average
- **Interview Method**: [Zoom video call / Phone / In-person / Async written]
- **Incentive**: [Voucher Rp X / Free early access / None]

**Target Stakeholder Groups (Multi-Stakeholder Coverage)**:
1. **Group A: End-Users / Daily Operators** (e.g., Cashiers, inventory staff, branch clerks) $\rightarrow$ Focus on operational friction, daily errors, and usability barriers.
2. **Group B: Economic Buyers / Decision Makers** (e.g., Business owners, Directors, Finance managers) $\rightarrow$ Focus on ROI, willingness-to-pay, procurement authority, and pain point severity.
3. **Group C: Ecosystem Enablers & Regulators** (e.g., Banks, tax consultants, auditors, industry associations) $\rightarrow$ Focus on compliance, integration requirements, and legal liabilities.

Quantitative Research (Survey):
- **Total Respondents**: [X] people (Target: $\ge 50$ for standard, $\ge 30$ for medium)
- **Survey Platform**: [Google Forms / Typeform / Tally]
- **Response Rate**: [X]% (if email blast list used)
- **Survey Duration**: [Median X minutes to complete]

---

### 2.2 Respondent Demographics

**Geographic Distribution**:
| Region | Count | Percentage |
| :--- | :---: | :---: |
| Greater Jakarta (Jabodetabek) | [X] | [Y]% |
| West Java | [X] | [Y]% |
| East Java | [X] | [Y]% |
| Outside Java | [X] | [Y]% |

**Industry/Sector** (if B2B):
| Industry | Count | Percentage |
| :--- | :---: | :---: |
| Retail/FMCG | [X] | [Y]% |
| F&B/Restaurant | [X] | [Y]% |
| Professional Services | [X] | [Y]% |
| Manufacturing | [X] | [Y]% |
| Other | [X] | [Y]% |

**Company Size** (if B2B):
| Company Size | Count | Percentage |
| :--- | :---: | :---: |
| 1-5 employees | [X] | [Y]% |
| 6-20 employees | [X] | [Y]% |
| 21-50 employees | [X] | [Y]% |
| 51-200 employees | [X] | [Y]% |
| >200 employees | [X] | [Y]% |

**Age Range** (if B2C):
| Age | Count | Percentage |
| :--- | :---: | :---: |
| 18-24 | [X] | [Y]% |
| 25-34 | [X] | [Y]% |
| 35-44 | [X] | [Y]% |
| 45-54 | [X] | [Y]% |
| 55+ | [X] | [Y]% |

---

## 3. Qualitative Insights (Interview Findings)

### 3.1 Interview Summary Table

| ID | Role/Title | Company/Context | Current Solution | Top Pain Point | WTP Range | Intent |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| U01 | [Operations Manager] | [Retail store with 7 branches] | [Excel + WA group] | [Stock discrepancies, loss of 5-10M IDR/mo] | Rp 200-500k/mo | Strong |
| U02 | [SME Owner] | [Cafe chain with 3 outlets] | [Manual bookkeeping] | [Slow sales reporting] | Rp 100-300k/mo | Moderate |
| U03 | [...] | [...] | [...] | [...] | [...] | [...] |
| ... | | | | | | |
| U10+ | | | | | | |

**Interview Transcripts**: [Link to Google Drive/Notion folder with full transcripts, or anonymized summary in appendix]

---

### 3.2 Synthesized Themes (Affinity Mapping)

**Theme 1: [Theme Name, e.g., "Data Accuracy & Trust Issues"]**
- **Frequency**: [X]/[Total] respondents mentioned this theme
- **Representative Quotes**:
  > "I often manually count physical stock vs the system, and there is always a 10-15% mismatch. So I don't trust the data." — U01, Operations Manager
  
  > "Branch staff often forget to input entries or miswrite numbers. Eventually the data becomes garbage." — U04, Retail Owner

- **Implication for Product**:
  [What must the product solve to address this theme? Example: Validation layer, barcode scanning to reduce manual entry errors]

---

**Theme 2: [Theme Name, e.g., "Time Waste on Manual Admin"]**
- **Frequency**: [X]/[Total] respondents
- **Representative Quotes**:
  > "Every weekend I spend 4-5 hours compiling reports from 7 branches. Copy-pasting Excel sheets one by one." — U01

- **Implication for Product**:
  [Auto-consolidation reports, real-time dashboard]

---

**Theme 3: [Theme Name, e.g., "Lack of Actionable Insights"]**
- **Frequency**: [X]/[Total] respondents
- **Representative Quotes**:
  > "I have complete sales data in Excel, but have no idea which products are slow-moving. There are no alerts." — U06

- **Implication for Product**:
  [Predictive analytics, alert system for anomalies/thresholds]

---

### 3.3 Jobs-to-be-Done Analysis

**Framework**: When [situation], I want to [motivation], so that I can [outcome].

**Top 5 Jobs Users Are Hiring Product For**:

1. **Job #1**: "When a branch processes a sales transaction, I want inventory to update automatically in real time, so that I don't need to call each branch to check stock."
   - **Current Struggle**: Daily manual phone calls/WA messages, information is often outdated.
   - **Success Criteria**: Check stock from dashboard in <10 seconds, data accuracy 95%+.

2. **Job #2**: "When the month ends, I want sales reports from all branches to be generated automatically, so that I don't waste 4 hours compiling Excel files."
   - **Current Struggle**: Manual copy-pasting across various Excel files.
   - **Success Criteria**: 1-click report generation, export to PDF/Excel, completed within 30 seconds.

3. **Job #3**: "When product stock is running low, I want to receive automatic alerts, so that I don't run out of best-selling items."
   - **Current Struggle**: No monitoring system, often too late to restock.
   - **Success Criteria**: Alerts via WhatsApp/Email when stock falls below threshold, sufficient restock lead time.

4. **Job #4**: [...]

5. **Job #5**: [...]

---

### 3.4 Pain Point Severity Ranking

**Method**: Respondents rank pain points from 1 (not bothersome) to 5 (extremely severe).

| Pain Point | Avg. Severity (1-5) | Frequency (% mention) | Impact × Frequency Score |
| :--- | :---: | :---: | :---: |
| Physical stock vs recorded discrepancy (financial loss) | 4.8 | 85% | 4.08 🔴 **Critical** |
| Manual processes consume 4+ hours/week | 4.2 | 70% | 2.94 🟠 **High** |
| Lack of real-time visibility across branches | 3.9 | 60% | 2.34 🟡 **Medium** |
| Reports are not actionable (just a data dump) | 3.5 | 50% | 1.75 🟡 **Medium** |
| Slow software setup/onboarding (>30 minutes) | 2.8 | 40% | 1.12 🟢 **Low** |

**Priority Pain Points to Solve in MVP** (Score ≥2.5):
1. Physical stock vs recorded discrepancy
2. Time-consuming manual processes
3. Lack of real-time visibility

---

## 4. Quantitative Insights (Survey Results)

### 4.1 Screener & Qualification

**Q: Do you currently manage [specific task/problem]?**
- Yes: [X]% → Proceed to full survey
- No: [Y]% → Survey terminated

**Q: How often do you perform this [task]?**
- Daily: [X]%
- Several times a week: [X]%
- Once a month: [X]%
- Rarely (<1x/month): [X]% → Disqualified

**Qualified Respondents**: [X] out of [Y] total responses

---

### 4.2 Pain Point Severity Distribution

**Q: How severely do the following issues disrupt your work? (1 = Not a problem, 5 = Extremely disruptive)**

**Pain Point 1: [Issue description]**
```
Rating Distribution:
1 (Not a problem):        ▓▓░░░░░░░░ 10%
2 (Minor problem):        ▓▓▓░░░░░░░ 15%
3 (Moderate problem):     ▓▓▓▓▓░░░░░ 25%
4 (Major problem):        ▓▓▓▓▓▓▓░░░ 35% 
5 (Extremely disruptive): ▓▓▓▓░░░░░░ 15%

Average: 3.4 / 5.0
Median: 4
```

**Pain Point 2: [...]**
[Repeat for each pain point]

---

### 4.3 Current Solution Usage

**Q: What do you currently use to handle [problem]?**

| Solution | Percentage |
| :--- | :--- |
| Manual Excel | 45% ▓▓▓▓▓▓▓▓▓░ |
| Competitor Software A | 20% ▓▓▓▓░░░░░░ |
| Competitor Software B | 10% ▓▓░░░░░░░░ |
| Pen & paper | 15% ▓▓▓░░░░░░░ |
| No system used | 10% ▓▓░░░░░░░░ |

**Insight**: 70% of respondents use manual/non-software solutions → massive opportunity to convert them.

---

### 4.4 Willingness to Pay (Van Westendorp Analysis)

**Q: At what price would you consider the product to be...**

**Distribution Chart**:
```
Rp 0     50k    100k   150k   200k   250k   300k   350k   400k
│────────┼──────┼──────┼──────┼──────┼──────┼──────┼──────│
Too Cheap:            ▲ (50k median)
Cheap (good deal):             ▲ (100k median)
Expensive (hesitant):                    ▲ (250k median)
Too Expensive:                                  ▲ (350k median)

Optimal Price Point (OPP): Rp 150k - Rp 200k
└─ Intersection of "Cheap" and "Expensive" curves
```

**Price Sensitivity**:
- **Too Cheap (suspicious)**: <Rp 50k
- **Good Value Zone**: Rp 100k - Rp 200k 🎯
- **Expensive but Acceptable**: Rp 200k - Rp 300k
- **Too Expensive (won't buy)**: >Rp 350k

**Recommendation**: Launch pricing at **Rp 99k - Rp 149k/month** to maximize adoption in early stages.

---

### 4.5 Intent-to-Buy

**Q: If this software were available today at Rp [X]/month, would you:**

| Response | Percentage | Count |
| :--- | :--- | :--- |
| Definitely buy (Strong Intent) | 25% ▓▓▓▓▓░░░░░ | [X] |
| Probably buy (Moderate Intent) | 35% ▓▓▓▓▓▓▓░░░ | [Y] |
| Need to discuss with team first | 20% ▓▓▓▓░░░░░░ | [Z] |
| Not interested | 20% ▓▓▓▓░░░░░░ | [W] |

**Total Intent-to-Buy (Definitely + Probably)**: **60%** ✅ **PASS GATE** (≥30%)

**Early Adopter Pool Estimate**:
```python
# From 50 survey respondents
strong_intent = 25% * 50 = 12 people
moderate_intent = 35% * 50 = 18 people

# Realistic conversion rate assumption:
# Strong intent → paid: 50% conversion
# Moderate intent → paid: 20% conversion

expected_paying_customers_from_survey = (12 * 0.5) + (18 * 0.2) = 6 + 3.6 = 9-10 customers

# If we can reach 1,000 people with a similar profile:
potential_customers = (1000 * 0.25 * 0.5) + (1000 * 0.35 * 0.2) = 125 + 70 = 195 customers
```

---

### 4.6 Feature Prioritization (Kano Model)

**Q: If feature [X] is present, how satisfied are you? If it is absent, how dissatisfied are you?**

| Feature | Must-Have | Performance | Delighter | Indifferent |
| :--- | :---: | :---: | :---: | :---: |
| Real-time stock sync | ✅ 80% | | | |
| Auto-generate report | ✅ 70% | | | |
| Barcode scanner integration | | ✅ 60% | | |
| WhatsApp notification | | | ✅ 50% | |
| Dark mode | | | | ✅ 20% |
| Multi-currency support | | | | ✅ 15% |

**Interpretation**:
- **Must-Have**: If absent, users are extremely dissatisfied. Required for MVP.
- **Performance**: The better the implementation, the higher user satisfaction. Medium priority.
- **Delighter**: Users do not expect it, but are pleasantly surprised if present. Nice-to-have.
- **Indifferent**: Users do not care either way. Skip in MVP.

---

## 5. Persona Creation (Jobs-to-be-Done Framework)

> ℹ️ **STATUS NOTE**: Until empirical user interviews are conducted, all entries below represent **`Proto-Persona (Hypothesis)`**. Only upgrade status to `Validated Persona` after linking direct quotes and validated sample demographics.

### Proto-Persona 1: [Persona Name, e.g., "Budi — SME Retail Operations Manager"]
**Validation Status**: [ 🔶 Proto-Persona (Hypothesis) / ✅ Validated Persona ]  
**Interview Evidence**: [Pending interviews / Linked to Interview INT-01 to INT-04]

**Demographics**:
- **Age**: 32 years old
- **Location**: South Jakarta
- **Education**: Bachelor in Management
- **Role**: Operations Manager (manages 5-7 retail branch stores)
- **Work Experience**: 8 years in the retail industry
- **Tech Savviness**: Moderate (uses Instagram, WhatsApp Business, Excel, has tried accounting software)
- **Salary / Budget Authority**: Rp 12-18 million/month, can approve software budgets up to Rp 500k/month

---

**Jobs to Be Done**:
1. **Primary Job**: Monitor inventory levels in real-time without having to call each branch.
2. **Secondary Job**: Create weekly sales reports for the owner without manual data entry.
3. **Tertiary Job**: Detect slow-moving products for proactive discounting.

---

**Current Workflow (As-Is)**:
```
06:00 - Wake up, check "Operations Team" WA group for branch stock updates
08:00 - Arrive at headquarters, open Excel master inventory
09:00 - Call 7 branch managers one by one to validate physical stock
11:00 - Manually input stock counts into Excel (prone to typos)
14:00 - Owner requests this week's sales report; start compiling data
16:00 - Complete compilation, send via email (total 4 hours of admin work)
```

---

**Pain Points** (ranked by severity):
1. **🔴 Critical**: Frequent discrepancies between physical inventory and records (loss of Rp 5-10M/month due to "lost" items or recording errors).
2. **🟠 High**: Spend 4 hours/week compiling Excel sheets from 7 branches (manual, repetitive, tedious).
3. **🟡 Medium**: Owner frequently asks for impromptu reports (weekends/evenings), requiring sudden overtime.
4. **🟢 Low**: Difficult to track which products are fast-selling vs slow-moving (relies on intuition, no data-driven decisions).

---

**Goals & Desired Outcomes**:
- **Efficiency Goal**: Reduce admin time from 4 hours/week to <30 minutes/week.
- **Accuracy Goal**: Stock discrepancy <2% (down from current ~10-15%).
- **Peace of Mind**: No stress over impromptu report requests from the owner, as data is always ready.
- **Career Goal**: Leverage data to propose business strategies to the owner (e.g., "Product X has been slow-moving for 3 months; recommend discounting"), advancing to General Manager.

---

**Current Workaround & Frustrations**:
- **Workaround**: Uses Excel + WhatsApp group for daily staff reports. Manually audits physical stock every weekend.
- **Frustration #1**: "Branch staff often forget to update the WA group, or write the wrong numbers. I have to act like a police officer nagging them every day."
- **Frustration #2**: "My Excel workbook has 15 sheets for 7 branches. Every time the owner wants a different report format, I have to re-tinker with formulas."
- **Frustration #3**: "Enterprise software like [Competitor A] is too expensive (Rp 500k/month) and complicated to set up. Requires 1 week of training."

---

**Willingness to Pay**: Rp 200k - Rp 500k/month
- **Rationale**: Saving 4 hours/week = 16 hours/month. With Budi's salary at Rp 15M/month (~Rp 94k/hour), time savings value = Rp 1.5M/month. Plus reducing stock discrepancy losses of Rp 5-10M/month.
- **Budget Approval**: Budi can self-approve up to Rp 500k/month. Higher amounts require owner approval.

---

**Objections & Barriers to Adoption**:
1. **"Can branch staff (high school education, age 40+) use it?"**
   - Need: Ultra-simple UI, local language support, video tutorials, onboarding <15 minutes.
2. **"Does it work when the internet goes down?"**
   - Need: Offline-first architecture, automatic data synchronization when back online.
3. **"How do I migrate my existing Excel data?"**
   - Need: 1-click import wizard from Excel templates.
4. **"Is the data secure? I don't want sales data leaking to competitors."**
   - Need: AES-256 encryption, data protection compliance, audit trails.

---

**Preferred Communication Channels**:
- **Discovery**: Google Search ("store inventory software"), peer recommendations from fellow ops managers, retail community WhatsApp/Telegram groups.
- **Evaluation**: 14-day free trial (must be self-serve without mandatory sales calls), case studies / testimonials.
- **Support**: WhatsApp Business chat (prefers async messaging over phone calls), local knowledge base, YouTube video tutorials.

---

**Quote (Representative)**:
> "I need software that I can set up in 30 minutes, that my staff can use immediately without formal training, and priced without hurting SME cash flow. If it can solve these 3 things, I'll definitely buy."

---

### Proto-Persona 2: [Another Persona Name]
**Validation Status**: [ 🔶 Proto-Persona (Hypothesis) / ✅ Validated Persona ]  
**Interview Evidence**: [Pending interviews / Linked to Interview INT-05 to INT-08]

[Repeat identical structure for personas 2-3]

---

## 6. User Journey Mapping

### Journey Map: Persona 1 (Budi - Operations Manager)

**Stage 1: Awareness (Trigger)**
- **Scenario**: Owner complains about stock discrepancies again, threatening to deduct Budi's bonus if unresolved.
- **Touchpoint**: Budi searches Google for "how to fix store inventory discrepancies" → finds blog post → mentions inventory software → begins research.
- **Emotion**: 😰 Stressed, desperate to find a solution.
- **Pain**: Doesn't know where to start, overwhelmed by software options, afraid of making the wrong choice.
- **Opportunity**: SEO content marketing (blog/video "5 Ways to Eliminate Stock Discrepancies"), retargeting ads.

---

**Stage 2: Consideration (Research)**
- **Scenario**: Budi compares 3-4 software tools (visits websites, reads reviews, asks in WA groups).
- **Touchpoint**: Website landing page, pricing page, comparison chart, video testimonials, Facebook retail community groups.
- **Emotion**: 🤔 Skeptical, overwhelmed by choices.
- **Pain**: "All software claims to be great, but which one is truly right for an SME like mine?" "Does the pricing match the features?"
- **Opportunity**: 
  - Social proof (case studies of similar local SMEs, video testimonials from store owners).
  - Credit card-free trial (removes barrier).
  - Transparent comparison table (vs Competitors A, B, C).

---

**Stage 3: Purchase/Signup (Conversion)**
- **Scenario**: Budi decides to try the free trial, clicking "Start 14-Day Free Trial".
- **Touchpoint**: Signup form, onboarding wizard, setup assistance.
- **Emotion**: 😬 Anxious (worried about complexity, afraid of wasting trial time).
- **Pain**: 
  - Signup form too long (requests excessive information).
  - Unclear onboarding (stuck on step 2, unsure what to do next).
  - Excel data import fails (format mismatch, cryptic error messages).
- **Opportunity**:
  - Step-by-step onboarding wizard (progress bar, estimated time: "3-minute setup").
  - 1-click import wizard (auto-detect columns, fault-tolerant formatting).
  - Live chat / WA support when stuck.

---

**Stage 4: Onboarding/First Use (Aha Moment)**
- **Scenario**: Budi successfully imports data, invites 2 branch staff to test recording transactions, and sees the dashboard update in real time.
- **Touchpoint**: Dashboard, first transaction, first report generated.
- **Emotion**: 🤩 Delighted ("Wow, it really is real-time! Branch staff said it's so easy!").
- **Pain**: 
  - Unsure which features to use first (too many options, overwhelming).
  - Branch staff complain that UI is confusing (too many menus, complex English).
- **Opportunity**:
  - Onboarding checklist (guided first 5 tasks: "1. Record first transaction, 2. View dashboard, 3. Generate report").
  - Celebrate first milestone (confetti animation, "Congratulations! First transaction recorded!").
  - In-app video tutorials (embedded 2-3 minute videos).

**Aha Moment Definition**: Budi sees dashboard update in real time after branch staff records a transaction, and successfully generates a sales report in <30 seconds (vs 4 hours manually in Excel).

---

**Stage 5: Retention (Habitual Use)**
- **Scenario**: Budi and team use the software daily; it has become their default workflow.
- **Touchpoint**: Daily dashboard check, weekly report generation, monthly billing reminder.
- **Emotion**: 😌 Relieved (life is easier, owner is satisfied).
- **Pain**: 
  - Churn risk if bugs disrupt core workflow (e.g., sync failure, report error).
  - Churn risk if competitors offer lower prices or more features.
  - Churn risk if owner cuts budget (recession, store closures).
- **Opportunity**:
  - Customer success check-in (email/WA every 30 days: "How is your experience? Any challenges?").
  - Upsell advanced features (e.g., "Upgrade to Pro plan for predictive restock alerts").
  - Build switching costs (integrations with accounting software, extensive historical data, high migration effort).

---

**Stage 6: Advocacy (Word-of-Mouth)**
- **Scenario**: Budi recommends the software to fellow ops managers in WhatsApp groups.
- **Touchpoint**: Referral program, testimonial request, case study interview.
- **Emotion**: 😊 Proud (proud of using software that solves the problem, eager to share).
- **Pain**: No incentive to refer (why promote it for free?).
- **Opportunity**:
  - Referral program (refer 3 friends, get 1 month free or 20% discount).
  - Gamification (top referrer leaderboard, "Community Champion" badge).
  - Featured case study (published on blog/social media, boosting Budi's industry credibility).

---

## 7. Pain Point Prioritization (Impact-Effort Matrix)

**Methodology**: Plot pain points based on **Impact to User** (severity of problem) vs **Effort to Solve** (implementation complexity).

```
High Impact
    │
    │  [1] Stock discrepancy  [2] Manual admin 4 hrs/wk
    │      (financial loss)       (time waste)
    │
    │  
────┼────────────────────────────────────────────► Effort to Solve
    │                                               (Low → High)
    │  [3] Slow setup         [4] No native mobile app
    │      (>30 min)              (limited access)
    │
Low Impact
```

**Prioritization Decision**:

**Quadrant 1 (High Impact, Low Effort)**: 🎯 **DO FIRST IN MVP**
- [Pain #1]: Discrepancy between physical stock and records
  - **Solution**: Real-time sync, barcode scanner integration, validation layer.
  - **Effort**: Medium (2-3 weeks dev time).
- [Pain #2]: Manual admin consuming 4 hours/week
  - **Solution**: Auto-consolidation reporting, 1-click PDF/Excel export.
  - **Effort**: Low (1 week dev time).

**Quadrant 2 (High Impact, High Effort)**: 🚀 **DO IN PHASE 2**
- [Pain #5]: Lack of actionable insights (just a data dump)
  - **Solution**: Predictive analytics, ML model for demand forecasting.
  - **Effort**: High (4-6 weeks + data science expertise).

**Quadrant 3 (Low Impact, Low Effort)**: ✅ **DO IF TIME PERMITS**
- [Pain #3]: Slow setup (>30 minutes)
  - **Solution**: Onboarding wizard, import templates.
  - **Effort**: Low (1 week).

**Quadrant 4 (Low Impact, High Effort)**: ❌ **DON'T DO / DEPRIORITIZE**
- [Pain #4]: No native mobile app
  - **Solution**: Build native iOS/Android apps.
  - **Effort**: High (8-12 weeks + maintenance burden).
  - **Alternative**: Responsive PWA is sufficient for this use case.

---

## 8. Research Limitations & Biases

**Known Limitations**:
1. **Sample Size**: [X] interviews and [Y] surveys are not representative of the entire target market. Generalize with caution.
2. **Selection Bias**: Respondents who completed surveys/interviews tend to already be problem-aware (survivor bias). Unaware users may be underrepresented.
3. **Social Desirability Bias**: During interviews, respondents may state "yes, I would buy" to please the interviewer, differing from actual behavior. Must validate with actual purchase behavior in MVP.
4. **Geographic Limitation**: [X]% respondents from Greater Jakarta; insights may not fully apply to regions outside major urban centers.

**Mitigation**:
- Combine qualitative (deep understanding) with quantitative (statistical validation).
- Track actual conversion rate in MVP to validate intent-to-buy claims.
- Iterate research every 3-6 months to update assumptions.

---

## 9. Next Steps & Recommendations

**For Product Development**:
1. **MVP Feature Prioritization**: Focus on solving Pain #1 (stock discrepancies) and Pain #2 (manual admin time waste) first.
2. **UX Requirements**: Onboarding must be <15 minutes, intuitive localization, offline-first architecture.
3. **Pricing Strategy**: Launch at Rp 99k-149k/month (sweet spot from WTP analysis).

**For Go-to-Market**:
1. **Target Segment**: SME retail with 5-20 employees, Greater Jakarta, currently using Excel/manual systems.
2. **Messaging**: "Stop wasting 4 hours/week compiling Excel. Rp 99k/month, 15-minute setup, easy for any staff member."
3. **Channels**: SEO content (pain point blogs), retail owner WhatsApp/Telegram communities, referral program.

**For Further Research**:
- [ ] Prototype usability testing (5-10 users, moderated task-based testing)
- [ ] Pricing experiment A/B test (Rp 99k vs Rp 149k conversion rate)
- [ ] Expand geographic coverage (research users outside major urban hubs)

---

**Appendix**:
- [Link to full interview transcripts]
- [Link to raw survey data CSV]
- [Link to affinity mapping Miro/FigJam board]

---

**Approved By**:  
**Name**: [Solo Dev / PM Lead]  
**Date**: [YYYY-MM-DD]
