# Module 00: Product Discovery & Strategy (Market Research, Competitor, User, & Product Strategy)

> - `references/technical/DEEP_RESEARCH_METHODOLOGY.md` (Regulatory/compliance research, Competitor deep-dive analysis, Domain knowledge acquisition for fintech/healthtech/legaltech)
> - `references/pre-sales/DISCOVERY_CALL_CHECKLIST.md` (Pre-sales intake, discovery call questionnaire, stakeholder qualification)
> - `references/pre-sales/PROPOSAL_DECK.md` (Proposal slide outline, pitch structure, commercial presentation)
> - `templates/00-pre-sales-enterprise/POC_PLAN_TEMPLATE.md` (Proof-of-concept scope, evaluation criteria, client POC validation plan)


This module is the **earliest gate** in the software development lifecycle for solo developers and technical consultants working on projects with an unlimited time budget and company use cases. This module is mandatory to execute **BEFORE Module 01 (Idea & Feasibility)** when:
- The project requires industry-grade Product Management (PM) standards.
- There is a need for market validation, competitor analysis, and in-depth user research before defining features.

**For Fast-Track projects or MVPs with tight deadlines: SKIP this module and proceed directly to Module 01 (Idea & Feasibility).**

---

## 1. Execution Cycle of Module 00

```text
[ BUSINESS QUESTION / MARKET OPPORTUNITY ]
          │
          ▼
[ STEP 1: Market Research ]
  • TAM/SAM/SOM Calculation
  • Industry Trend Analysis
  • Regulatory Landscape Check
          │
          ▼
[ STEP 2: Competitive Analysis ]
  • Competitor Identification (Direct & Indirect)
  • Feature Matrix Comparison
  • Pricing Benchmarking
  • SWOT Analysis per Competitor
  • Positioning Map (2x2 Matrix)
          │
          ▼
[ STEP 3: User Research ]
  • Interview Guide (10+ users, 30-45 min each)
  • Survey Design (50+ respondents, quantitative validation)
  • Persona Creation (Jobs-to-be-Done Framework)
  • User Journey Mapping
  • Pain Point Prioritization
          │
          ▼
[ STEP 4: Product Strategy ]
  • Vision Statement (Aspirational, 3-5 years)
  • Mission Statement (Tactical, current state)
  • North Star Metric Definition + Rationale
  • Value Proposition Canvas (Gains/Pains/Jobs)
  • Strategic Pillars (3-5 Core Focus Areas)
          │
          ▼
[ GATE PROTOCOL: Market Validation Pass ]
  • Min 30% intent-to-buy from survey
  • Competitive moat identified
  • North Star Metric measurable
          │
          ▼
[ OUTPUT: 4 PM Documents ] ──► Ready to Proceed to Module 01: Idea & Feasibility
```

---

## 2. Step-by-Step Execution

### Step 1: Market Research

Goal: Understand market size, industry growth, and regulatory constraints before investing time into a specific idea.

#### 1.1 TAM/SAM/SOM Calculation

**TAM (Total Addressable Market)**: The entire market if there are no limitations (geographical, regulatory, competitor).
**SAM (Serviceable Addressable Market)**: The segment of TAM realistically serviceable by your product.
**SOM (Serviceable Obtainable Market)**: The portion of SAM you can capture in the first year with limited resources.

**Estimation Formula**:
```python
# Example: Accounting SaaS for Indonesian MSMEs
TAM = (jumlah_ukm_indonesia * arpu_tahunan)
    # 64 million MSMEs (Kemenkop 2022 data) * Rp 1,200,000/year
    # [UPDATE 2026: Verify latest BPS/Kemenkop UKM count]
    # TAM = Rp 76.8 trillion

SAM = TAM * (persentase_digitalisasi_aktif)
    # 64M MSMEs * 8% already using software * Rp 1,200,000
    # SAM = Rp 6.1 trillion

SOM_tahun_1 = SAM * (target_market_share_realistis)
    # Rp 6.1 trillion * 0.01% (1 out of 10,000 digital MSMEs)
    # 0.01% = 0.0001 in Python formula (not 0.01)
    # SOM = Rp 610 million/year (≈ 500 paying customers)
```

**Validation Methods**:
- **Top-Down**: Take industry report data (Gartner, Statista, Kemenkop, BPS) → filter down to target segment.
- **Bottom-Up**: Calculate from smallest unit economics (number of Jakarta restaurants * average POS software expenditure).

#### 1.2 Market Sizing Frameworks

| Framework | When to Use | Application Example |
| :--- | :--- | :--- |
| **Substitution Analysis** | Product replaces an existing solution | "How many people currently pay for manual notary services to legalize documents?" |
| **Proxy Metrics** | New market without direct data | "Number of active e-commerce users (120M) * 15% have bought custom goods → 18M prospective design-to-print platform users" |
| **Value-Based Sizing** | B2B SaaS with clear ROI | "If software saves 10 hours/week for admin staff (Rp 5M/month salary), WTP is Rp 1-2M/month" |

#### 1.3 Industry Trend Analysis

Use Google Trends, McKinsey/BCG Indonesia reports, and startup research (DailySocial.id, Katadata) to discover:
1. **Growth Trends**: Is the industry growing >10% YoY or stagnant?
2. **Tech Adoption Curve**: Where is target user adoption positioned (Early Adopter vs Late Majority)?
3. **Macro Tailwinds**: New regulations (UU PDP), post-pandemic behavioral shifts, government subsidies.

#### 1.4 Regulatory Landscape Check

| Industry Sector | Critical Regulations Solo Devs Must Know |
| :--- | :--- |
| **Fintech / Payment** | OJK (PUJK, P2P Lending License), Bank Indonesia (GPN, QRIS license mandatory) |
| **Healthtech / Telemedicine** | Ministry of Health (SIP doctor license, electronic medical records), Medical Device Distribution License (Izin Edar Alkes) |
| **Edtech / Online Course** | Ministry of Education (NPSN for formal education), Content copyright |
| **Data-Heavy Apps** | PDP Law No. 27/2022 (mandatory consent management, data breach notification) |
| **E-Signature Apps** | Kominfo PSrE (licensed provider mandatory if legally binding signature) |

**Step 1 Output**: File **`docs/pm/MARKET_RESEARCH.md`** containing:
- TAM/SAM/SOM calculation results with data sources.
- Industry trend charts (Google Trends screenshot or YoY growth table).
- List of regulations affecting go-to-market.

---

### Step 2: Competitive Analysis

Goal: Understand competitor landscape to identify positioning gaps and defensible moats.

#### 2.1 Competitor Identification

**Direct Competitors**: Products solving the same problem in the same way.
**Indirect Competitors**: Products solving the same problem in a different way.
**Substitute Competitors**: Non-software solutions users currently rely on (Excel, WhatsApp groups, manual services).

**Discovery Tactics**:
```bash
# Use Google search operators
"<problem keyword> software site:id"
"<problem keyword> Indonesia pricing"
intitle:"<competitor name> review"

# Check app stores
https://play.google.com/store/search?q=<keyword>&c=apps&gl=ID
https://apps.apple.com/id/search?term=<keyword>

# Monitor ProductHunt/Indie Hackers for global startups
```

#### 2.2 Feature Matrix Comparison

Create a competitor feature comparison table:

| Feature | Competitor A | Competitor B | Competitor C | [Your Product] |
| :--- | :---: | :---: | :---: | :---: |
| Real-Time Analytics Dashboard | ✅ | ❌ | ✅ | ✅ |
| Export Reports to Excel | ✅ | ✅ | ❌ | ✅ |
| WhatsApp Notification Integration | ❌ | ❌ | ✅ | ✅ |
| Mobile App (Android/iOS) | ✅ | ❌ | ✅ | ⏳ (Phase 2) |
| Multi-User RBAC | ❌ | ✅ | ✅ | ✅ |

**Gap Analysis**: Highlight features that **DO NOT EXIST IN ANY COMPETITORS** but users need (from user interview research).

#### 2.3 Pricing Benchmarking

Record competitor pricing models:
- **Freemium**: Core features free, pro features paid (Notion, Canva).
- **Tiered Subscription**: Bronze/Silver/Gold (Rp 99k, Rp 299k, Rp 999k/month).
- **Per-Seat Pricing**: Rp 50k/user/month (Slack, Mekari).
- **Usage-Based**: Rp 5/transaction or Rp 0.01/API call (Stripe, Midtrans).

**Positioning Price Anchor**:
- **Low-End Disruption**: 30-50% cheaper than incumbents (risk: cheap perception = fewer features).
- **Premium Positioning**: 20-30% more expensive with a clear value proposition (e.g., "only solution with end-to-end encryption").

#### 2.4 SWOT Analysis per Competitor

For 3 primary competitors, build a SWOT analysis:

**Example: Competitor A (Large Incumbent)**
- **Strengths**: High brand awareness, extensive integrations, 24/7 support.
- **Weaknesses**: Legacy UI, expensive pricing, no mobile app.
- **Opportunities**: Expansion into MSME segment (they focus on enterprise).
- **Threats**: Can pivot quickly with substantial capital if our product gains traction.

#### 2.5 Positioning Map (2x2 Matrix)

Create a positioning visualization with relevant X and Y axes:

```
High Price
      │
   [A]│     [C]
      │
──────┼──────────► Complexity (Simple → Advanced)
      │
   [B]│  [Your Product]
      │
Low Price
```

**Step 2 Output**: File **`docs/pm/COMPETITIVE_LANDSCAPE.md`** containing:
- List of 5-10 competitors categorized by type (direct/indirect/substitute).
- Feature matrix table.
- Pricing benchmarking table.
- SWOT analysis for 3 primary competitors.
- Positioning map diagram (ASCII art or link to Excalidraw/Figma).

---

### Step 3: User Research

Goal: Validate market assumptions using qualitative data (interviews) and quantitative data (surveys).

#### 3.1 Interview Guide (10+ Users, 30-45 Min Each)

**Target Respondents**:
- **For B2B**: Decision makers (Director, Finance Manager, IT Manager).
- **For B2C**: Active users of existing solutions or manual workarounds.

**Interview Structure (5-Act Framework)**:
1. **Warm-Up (5 min)**: Introduce self, explain research objective, request recording permission.
2. **Current State (10 min)**: "Describe how you currently handle [problem]. What tools do you use? How much time does it take?"
3. **Pain Points (10 min)**: "What is the most frustrating part of this process? Have you experienced failures/errors? What was the impact?"
4. **Desired Future (10 min)**: "If you had a magic wand, what would your ideal solution look like? What features are must-haves?"
5. **Willingness to Pay (5 min)**: "If software existed to solve this problem, what monthly budget would seem reasonable to you?"

**Mandatory Questions (Jobs-to-be-Done Framework)**:
```
Q: "When using [existing solution], what job are you actually trying to get done?"

Q: "What prompted you to switch from manual methods to software (or vice versa)?"

Q: "If the software you use disappeared tomorrow, what would you do?"
```

**Red Flags in Interviews**:
- Respondent does not have a real problem (just enjoys chatting).
- Respondent provides many feature ideas but refuses to pay ("wants it free only").
- Respondent claims "all features are important" without clear priorities.

#### 3.2 Survey Design (50+ Respondents, Quantitative Validation)

Use Google Forms / Typeform / Tally for structured surveys:

**Part 1: Screener (Filter Respondents)**
```
Q1: Do you currently manage [specific task]? (Yes/No)
    → If "No", stop survey.

Q2: How often do you perform this [task]?
    [ ] Daily
    [ ] Several times a week
    [ ] Once a month
    [ ] Rarely (<1x/month) → disqualify
```

**Part 2: Pain Point Severity (Likert Scale 1-5)**
```
Q: How significantly do the following issues disrupt your work?
   (1 = Not an issue, 5 = Highly disruptive)

- Manual process takes > 2 hours/day: [1][2][3][4][5]
- Frequent data entry errors: [1][2][3][4][5]
- Difficult to track change history: [1][2][3][4][5]
```

**Part 3: Willingness to Pay (Van Westendorp Price Sensitivity)**
```
Q: At what price would you consider the product to be:
   - Too cheap (suspicious quality): Rp _______
   - Cheap (good deal): Rp _______
   - Expensive (starting to hesitate): Rp _______
   - Too expensive (would not buy): Rp _______
```

**Part 4: Intent to Buy**
```
Q: If this software were available today at Rp [X]/month, would you:
   [ ] Definitely buy (Strong Intent)
   [ ] Probably buy (Moderate Intent)
   [ ] Need to discuss with team first
   [ ] Not interested
```

**Gate Pass Criteria**: Minimum 30% of respondents choose "Definitely buy" or "Probably buy" (from minimum 50 respondents = 15 people).

#### 3.3 Persona Creation (Jobs-to-be-Done Framework)

Create 2-3 primary personas based on interview results:

**Persona Template**:
```markdown
## Persona 1: Budi — Retail MSME Operations Manager

**Demographics**:
- Age: 32 years old
- Location: Jakarta
- Role: Retail chain store manager (5 branches)
- Tech Savviness: Moderate (uses Instagram, WhatsApp Business, Excel)

**Jobs to Be Done**:
- Monitor inventory in real-time without having to call each branch.
- Generate weekly sales reports for the owner without manual entry.
- Identify slow-moving products for discounting.

**Pain Points** (ranked by severity):
1. **Critical**: Frequent discrepancies between physical stock and records (losses of Rp 5-10M/month).
2. **High**: Spends 4 hours/week compiling Excel sheets from 5 branches.
3. **Medium**: Owner frequently asks for impromptu reports, requiring overtime.

**Current Workaround**:
- Uses Excel + WhatsApp group for daily staff reports.
- Manual physical stock counts every weekend.

**Willingness to Pay**: Rp 200k-500k/month (saves overtime hours + reduces stock discrepancies).

**Objections/Barriers**:
- "Can branch staff (high school education) operate this?"
- "Will it still work if internet drops?"
```

#### 3.4 User Journey Mapping

Map user stages from awareness through retention:

**5-Stage Journey**:
1. **Awareness**: How do users first discover the product? (Google search "cashier software", friend recommendation, Facebook ads).
2. **Consideration**: What do they evaluate? (Price, ease of use, free trial availability).
3. **Purchase/Signup**: What is the signup friction? (Requires credit card? Complex setup?).
4. **Onboarding/First Use**: When do they experience the "aha moment"? (First data entry completed? First report generated?).
5. **Retention/Advocacy**: Why do they stay or churn? (Consistent value vs "too complex, returning to Excel").

**Mapping Pain & Opportunity**:
```
Stage: Onboarding
Current Experience: "Setup takes 2 hours, confused about importing master data."
Pain Level: ⭐⭐⭐⭐ (High)
Opportunity: "Build a 1-click import wizard from Excel template."
```

#### 3.5 Pain Point Prioritization (Impact-Effort Matrix)

Prioritize pain points based on **Impact to User** vs **Effort to Solve**:

```
High Impact
    │
 [1]│ [2]          [1] Stock discrepancy = monetary loss
    │               → High priority (solve in MVP)
────┼────────►    [2] Manual reporting 4 hours/week
    │               → High priority (solve in MVP)
 [3]│ [4]          [3] Dark mode
    │               → Low priority (nice-to-have)
Low Impact        [4] Accurate accounting integration
                    → Medium-High effort, postpone to Phase 2
```

**Step 3 Output**: File **`docs/pm/USER_RESEARCH_REPORT.md`** containing:
- Summary transcripts of 10+ interviews (anonymized).
- Survey result summary (charts: pain severity distribution, WTP histogram, intent-to-buy %).
- 2-3 complete personas with JTBD.
- User journey map with pain/opportunity annotations.
- Pain point prioritization matrix (screenshot or ASCII table).

---

### Step 4: Product Strategy

Goal: Transform research insights into a long-term product strategy with measurable success metrics.

#### 4.1 Vision Statement (Aspirational, 3-5 Years)

**Formula**: `[Target User] + [Transformed Future State] + [Societal Impact]`

**Example**:
```
Vision: "To become the trusted inventory management platform for 100,000 Indonesian 
         retail MSMEs, eliminating losses caused by stock discrepancies, and 
         empowering small business owners to focus on growth rather than 
         administrative headaches."
```

**Vision Quality Test**:
- ✅ Inspiring (gets team excited to work toward it).
- ✅ Aspirational (not achieved today, but realistic in 3-5 years).
- ❌ Too generic ("become the best platform in Indonesia").

#### 4.2 Mission Statement (Tactical, Current State)

**Formula**: `[What We Do] + [For Whom] + [How We Do It Differently]`

**Example**:
```
Mission: "Help retail store owners with 2-10 branches track real-time inventory 
          through a mobile app operable by staff with <30 minutes of training, 
          without requiring 24/7 internet connectivity."
```

**Mission Quality Test**:
- ✅ Actionable (clear what is being worked on today).
- ✅ Specific (not "helping everyone").
- ✅ Differentiated (has a unique "how").

#### 4.3 North Star Metric Definition + Rationale

**North Star Metric (NSM)**: The single key metric that best captures the core value delivered to users.

**Definition Template**:
```markdown
## North Star Metric: [Metric Name]

**Formula**: [Calculation formula]

**Rationale (Why This Metric?)**:
- Leading indicator for revenue (strong correlation with retention/MRR).
- Directly reflects user value (not a vanity metric).
- Actionable and influenceable by the product/engineering team.

**Initial Target (First 3-6 Months)**: [Baseline number → target]

**Breakdown Metrics (Tree)**:
```

**Example: Inventory Management SaaS**
```
North Star Metric: "Number of Tracked Stock Transactions per Week"
  (Rationale: The more transactions tracked, the higher the value delivered 
   to users through accurate data. Strong correlation with retention.)

Target: 500 transactions/week/user → 2,000 transactions/week/user (Month 6)

Breakdown:
├─ Acquisition: New users sign up per week
├─ Activation: % users entering ≥10 transactions in week 1
├─ Engagement: % users active at least 3x/week
└─ Retention: % users still active in month 3
```

**Flawed NSM Anti-Patterns**:
- ❌ "Total registered users" → vanity metric (many register but never use it).
- ❌ "Time spent in app" → not necessarily good (users might be confused).

#### 4.4 Value Proposition Canvas (Strategyzer Framework)

Use the Gains/Pains/Jobs template from Strategyzer.com:

**Customer Profile (Right Side)**:
1. **Customer Jobs**: What is the user trying to get done? (functional, social, emotional).
2. **Pains**: What obstructs them from completing the job? (frustrations, obstacles, risks).
3. **Gains**: What outcomes do they desire? (saving time, saving money, status).

**Value Map (Left Side)**:
1. **Products & Services**: What does the product offer?
2. **Pain Relievers**: How does the product eliminate pains?
3. **Gain Creators**: How does the product produce gains?

**Mapping Example**:
```
Customer Job: "Track real-time stock without calling branches."

Pain: "Branch staff frequently forget to update; data is unreliable."
Pain Reliever: "Auto-sync every transaction to cloud without manual entry."

Gain: "Make rapid restocking decisions; avoid stockouts of best-sellers."
Gain Creator: "Automated alert when stock drops below threshold."
```

#### 4.5 Strategic Pillars (3-5 Core Focus Areas)

Define 3-5 strategic pillars to guide the product roadmap:

**Pillar Template**:
```markdown
## Pillar 1: [Pillar Name]

**Definition**: [1-sentence positioning of this pillar]

**Key Initiatives (6-12 Months)**:
- [ ] Initiative A
- [ ] Initiative B

**Success Criteria**: [Metric to evaluate pillar success]
```

**Example: Inventory SaaS**
```
Pillar 1: Reliability & Offline-First
  → System must remain fully functional during internet outages.
  Key Initiatives: Implement IndexedDB sync, background queue, conflict resolution.
  Success: ≥95% transactions successfully synced without data loss.

Pillar 2: Ease of Use for Non-Tech Staff
  → Onboarding in <30 minutes, requiring no formal training.
  Key Initiatives: Setup wizard, in-app video tutorials, localized UI/UX.
  Success: ≥80% new users complete their first transaction within 10 minutes.

Pillar 3: Actionable Insights (not just data dumps)
  → Users gain actionable business decisions directly from the dashboard.
  Key Initiatives: Predictive restock alerts, slow-moving product detection.
  Success: ≥50% users use insights to make decisions weekly.
```

**Step 4 Output**: File **`docs/pm/PRODUCT_STRATEGY.md`** containing:
- Vision & Mission Statement.
- North Star Metric with formula, rationale, target, and breakdown tree.
- Value Proposition Canvas (Gains/Pains/Jobs mapping).
- 3-5 Strategic Pillars with initiatives and success criteria.

---

## 3. Adaptation Based on Project Scale

| Aspect | Solo Dev Product (Self-Initiated) | B2B SaaS Client | Enterprise Client |
| :--- | :--- | :--- | :--- |
| **Market Research Depth** | Quick TAM/SAM/SOM estimate (1-2 days) using secondary data | Formal industry research, conduct primary research (50+ survey respondents) | Commissioned report (partnership with market research consultancy), in-depth compliance audit |
| **Competitive Analysis** | 3-5 primary competitors, baseline feature matrix | 5-10 competitors, full SWOT, detailed pricing benchmarking | 10+ competitors, Porter's Five Forces, IP/patent landscape analysis |
| **User Research** | 5-10 interviews, 30+ survey respondents | 10-20 stakeholder interviews, 50-100 survey respondents, persona validation workshop | Multi-phase research (discovery → validation → usability testing), 30+ interviews, 200+ surveys, ethnographic study |
| **Product Strategy** | 1-page Vision/Mission, simplified NSM | Formal Vision/Mission, NSM with metric breakdown, Value Prop Canvas | Formal business case, 3-year roadmap, strategic alignment with corporate OKRs |

---

## 4. Output Artifacts (Deliverables)

The final deliverables of Module 00 are **4 PM documents** created using the templates in the `templates/01-discovery-commercial/` directory:

1. **`docs/pm/MARKET_RESEARCH.md`**: TAM/SAM/SOM findings, industry trends, regulatory landscape.
   - Template: `templates/01-discovery-commercial/MARKET_RESEARCH_TEMPLATE.md`
2. **`docs/pm/COMPETITIVE_LANDSCAPE.md`**: 5-10 competitor analysis, feature matrix, SWOT, positioning map.
   - Template: `templates/01-discovery-commercial/COMPETITIVE_LANDSCAPE_TEMPLATE.md`
3. **`docs/pm/USER_RESEARCH_REPORT.md`**: Interview/survey summaries, JTBD personas, user journey, pain matrix.
   - Template: `templates/01-discovery-commercial/USER_RESEARCH_REPORT_TEMPLATE.md`
4. **`docs/pm/PRODUCT_STRATEGY.md`**: Vision/Mission, North Star Metric, Value Prop Canvas, Strategic Pillars.
   - Template: `templates/01-discovery-commercial/PRODUCT_STRATEGY_TEMPLATE.md`

> 📁 **ABSOLUTE FILE LOCATION RULE**:
> All documents MUST be stored inside the **`docs/pm/`** directory (never in the root directory).
> The root directory `./` is reserved exclusively for the 7 AI control files (Agent Harness) once Module 06 begins.

---

## 🛑 [GATE] EXIT & MANDATORY STOP PROTOCOL

After all four PM documents have been written:

1. **STRICTLY FORBIDDEN to proceed directly or invoke tools for Module 01 within the same turn!**

2. **SELF-VERIFICATION CHECKLIST**:
   - [ ] `read_file('docs/pm/MARKET_RESEARCH.md')` → Confirm TAM/SAM/SOM exists, data sources cited
   - [ ] `read_file('docs/pm/COMPETITIVE_LANDSCAPE.md')` → Min 5 competitors, feature matrix present, positioning map present
   - [ ] `read_file('docs/pm/USER_RESEARCH_REPORT.md')` → Min 10 interview insights, survey results (sample size ≥30), 2-3 complete personas
   - [ ] `read_file('docs/pm/PRODUCT_STRATEGY.md')` → Vision/Mission written, North Star Metric defined with formula + rationale, 3-5 Strategic Pillars present

3. **GATE PASS CRITERIA** (Market Validation):
   - [ ] **Intent-to-Buy ≥30%**: From a survey of at least 50 respondents, at least 30% (15 people) select "Definitely buy" or "Probably buy".
   - [ ] **Competitive Moat Identified**: At least 1 clear differentiator that competitors lack or cannot easily replicate (e.g., offline-first architecture, specific niche focus).
   - [ ] **North Star Metric Measurable**: NSM can be tracked with technical instrumentation (event logging, DB queries).

   **If Gate Pass FAILS**:
   - Intent-to-buy <30% → **PIVOT or STOP**: Idea is unvalidated; do not proceed to development.
   - No competitive moat → **PIVOT positioning** or identify alternative unique value propositions.
   - NSM not measurable → Revise NSM until it can be instrumented.

4. Present a summary of Module 00 results to the user:
   ```
   ## Product Discovery & Strategy Summary

   **Market Opportunity**:
   - TAM: [number], SAM: [number], SOM Year 1: [number]
   - Industry trend: [1-2 sentence insight]
   - Regulatory blocker: [yes/no]

   **Competitive Landscape**:
   - [X] direct competitors, [Y] indirect competitors
   - Positioning gap: [our unique differentiator]
   - Pricing anchor: [pricing strategy]

   **User Validation**:
   - [X] interviews, [Y] survey respondents
   - Top 3 Pain Points: [1], [2], [3]
   - Intent-to-Buy: [Z]% (Gate Pass: ✅/❌)

   **Product Strategy**:
   - North Star Metric: [metric name + target]
   - Strategic Pillars: [pillar 1], [pillar 2], [pillar 3]
   ```

5. **END YOUR RESPONSE (END TURN)** and ask for confirmation from the user:
   > *"Module 00 (Product Discovery & Strategy) is complete with [X]% intent-to-buy and North Star Metric '[NSM]' defined. Gate validation: [PASS/FAIL]. Does this product strategy align with expectations, or are there insights to adjust before proceeding to Module 01 (Idea & Feasibility)?*
   > 
   > *If the Gate FAILS, I recommend PIVOTING or STOPPING the project. If the Gate PASSES, we can proceed to Module 01 for technical breakdown and feasibility checks."*

6. The agent may ONLY proceed to Module 01 AFTER the user provides an affirmative response (e.g., *"ok"*, *"proceed"*, *"approved"*) AND Gate Pass criteria are met.
