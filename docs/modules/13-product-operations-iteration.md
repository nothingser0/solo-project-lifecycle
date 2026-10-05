# Module 13: Product Operations & Continuous Iteration

> - `references/pm/PM_PRIORITIZATION_FRAMEWORKS.md` (RICE scoring formula, reach/impact/confidence rubrics, backlog prioritization worksheet)
> - `templates/09-product-growth/AB_TEST_REPORT_TEMPLATE.md` (A/B testing execution report, conversion analysis, rollout decision sheet)

This module is the **post-launch stage** in the software product lifecycle for solo developers. It is executed after Module 12 (Warranty & SLA) once the system has stabilized in production and focus shifts from "building" to "optimizing & growing" based on real user data. The objective is to establish a **metrics-driven operational framework** to continuously improve the product using data, not assumptions.

---

## 1. Module 13 Execution Cycle

```text
[ INPUT: Stable Production System + First 30 Days User Data ]
                                    │
                                    ▼
[ STEP 1: Metrics Baseline Collection ]
  • Collect first 30 days post-launch metrics data
  • Calculate Mean, Median, P50/P90/P95 for all key metrics
  • Compare against industry benchmarks (if available)
  • Setup anomaly detection system (Sentry, Datadog, custom alerts)
                                    │
                                    ▼
[ STEP 2: Feedback Loop Automation ]
  • Automated NPS Survey: Day 7, Day 30, Quarterly
  • In-App Feedback Widget (Canny, UserVoice, Typeform embed)
  • Aggregate support tickets into knowledge base (GitHub Issues → FAQ)
  • Feature Request Vote & Prioritization Board
                                    │
                                    ▼
[ STEP 3: Cohort Analysis ]
  • Retention Cohorts: Day 1 / 7 / 30 / 90 retention rate
  • Behavioral Segmentation: Power Users vs Churners vs Casuals
  • Churn Prediction Signals (last_active > 14 days, low engagement)
  • Power User Identification (top 10% activity)
                                    │
                                    ▼
[ STEP 4: Feature Prioritization with RICE ]
  • Apply RICE Framework: Reach × Impact × Confidence / Effort
  • Feature ROI Calculation: Expected Revenue - Development Cost
  • Opportunity Cost Analysis: What is skipped if feature X is chosen?
  • Quarterly Feature Review Workshop
                                    │
                                    ▼
[ STEP 5: Growth Experiments Backlog ]
  • Setup Hypothesis Format (from Module 04 A/B Testing)
  • Prioritized Experiment Queue (sort by expected lift × ease)
  • Velocity Tracking: Target 2–4 experiments per month
  • Learning Repository: Document experiment results (win/lose/neutral)
                                    │
                                    ▼
[ STEP 6: Product Health Monitoring ]
  • Weekly Metrics Review (15-minute metrics standup)
  • Monthly OKR Check-In (progress against North Star Metric from M00)
  • Quarterly Roadmap Review (reprioritization based on learnings)
  • Annual Strategy Refresh (pivot or double-down decision)
                                    │
                                    ▼
[ STEP 7: Scaling Considerations ]
  • Performance Degradation Signals (response time > 500ms P95)
  • Database Optimization Triggers (query time > 100ms, N+1 queries)
  • Infrastructure Cost Monitoring (cost per active user)
  • Team Expansion Indicators (solo dev overload > 60 hours/week)
                                    │
                                    ▼
[ OUTPUT: 4 Product Operations Documents + 1 Reference Guide ]
```

---

## 2. Product Operations Principles for Solo Developers

Product Operations differs from Development Operations (DevOps). Its focus is not on server uptime or deployment speed, but rather on the **quality of product decisions made based on real data**.

| Parameter | Development Phase (M06) | Operations Phase (M13) |
| :--- | :--- | :--- |
| **Primary Metrics** | Code coverage, build time, deployment frequency | Retention rate, feature adoption, NPS, revenue per user |
| **Work Cycle** | 1–2 week sprints with fixed deadlines | Continuous iteration without rigid deadlines, dynamic priorities |
| **Decision Maker** | Solo dev (technical) | Data + Solo dev (product thinking) |
| **Success Criteria** | Feature completed according to specifications | Feature moves targeted business metrics |
| **Tooling** | GitHub, IDE, CI/CD pipeline | Analytics dashboard, cohort analysis, A/B testing platform |

**Golden Principle**: Every feature addition decision must answer: *"Which metric will move if this feature succeeds?"*

---

## 3. Step-by-Step Execution

### Step 1: Metrics Baseline Collection (First 30 Days Baseline Metrics)

After the system has been live in production for at least 30 calendar days, collect baseline data for all key metrics.

#### 1.1 Mandatory Metric Categories to Measure

| Metric Category | Specific Metrics | Query/Tool |
| :--- | :--- | :--- |
| **Acquisition** | Sign-up rate, traffic source breakdown | Google Analytics, Plausible, PostHog |
| **Activation** | % users completing onboarding / first core action within 24 hours | Custom event tracking (PostHog, Mixpanel) |
| **Retention** | Day 1 / 7 / 30 / 90 retention rate | Cohort analysis SQL query |
| **Referral** | Viral coefficient (new users per existing user) | Referral tracking (if referral program exists) |
| **Revenue** | MRR (Monthly Recurring Revenue), ARPU (Average Revenue Per User), LTV (Lifetime Value) | Stripe Dashboard / payment provider analytics |
| **Engagement** | DAU/MAU ratio, session duration, feature usage frequency | PostHog feature flags + event tracking |
| **Performance** | Response time P50/P95, error rate, uptime % | Sentry, Datadog, Vercel Analytics |

#### 1.2 Calculate Descriptive Statistics

For each metric, calculate:
- **Mean**: Average value, sensitive to outliers.
- **Median**: More robust against outliers, suitable for skewed distributions.
- **Percentiles (P50/P90/P95)**: For performance metrics (response time), use P95 as the SLA threshold.

**Example SQL Query for Retention Cohort**:
```sql
-- Day 7 Retention Rate
WITH cohorts AS (
  SELECT 
    user_id,
    DATE_TRUNC('day', created_at) AS cohort_date,
    DATE_TRUNC('day', last_active_at) AS active_date
  FROM users
  WHERE created_at >= NOW() - INTERVAL '60 days'
)
SELECT 
  cohort_date,
  COUNT(DISTINCT user_id) AS cohort_size,
  COUNT(DISTINCT CASE WHEN active_date >= cohort_date + INTERVAL '7 days' THEN user_id END) AS retained_users,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN active_date >= cohort_date + INTERVAL '7 days' THEN user_id END) / COUNT(DISTINCT user_id), 2) AS retention_rate_pct
FROM cohorts
GROUP BY cohort_date
ORDER BY cohort_date DESC;
```

#### 1.3 Benchmark Comparison

Compare your baseline against industry standards:

| Product Type | Day 1 Retention | Day 7 Retention | Day 30 Retention | NPS Score |
| :--- | :--- | :--- | :--- | :--- |
| **B2B SaaS** | 60–80% | 40–60% | 25–40% | 30–50 |
| **Consumer Mobile App** | 25–40% | 10–20% | 5–10% | 10–30 |
| **E-Commerce** | 20–35% | 10–15% | 5–10% | 20–40 |
| **Marketplace** | 30–50% | 15–25% | 10–15% | 25–45 |

**Benchmark Sources**: Mixpanel Benchmark Report, Lenny's Newsletter SaaS Metrics, OpenView SaaS Benchmarks.

**If your metrics fall below benchmarks**: Prioritize onboarding and activation improvements (STEP 2 feedback loop).

#### 1.4 Anomaly Detection Setup

Configure automated alerts to detect abnormal patterns:
```javascript
// Example: Cloudflare Workers script for anomaly alerts
async function checkDailyActiveUsers() {
  const today = await fetchDAU('2026-09-27');
  const baseline = await fetchAvgDAU(last30Days);
  
  if (today < baseline * 0.7) { // Drop > 30%
    await sendSlackAlert(`🚨 DAU drop anomaly: ${today} vs baseline ${baseline}`);
  }
}
```

**Step 1 Output**: Document **`docs/analytics/METRICS_BASELINE_REPORT.md`** (use template `templates/09-product-growth/METRICS_BASELINE_REPORT_TEMPLATE.md`).

---

### Step 2: Feedback Loop Automation

User feedback is the best source of feature ideas. Automate collection so it does not rely on manual memory.

#### 2.1 NPS Survey Automation (Net Promoter Score)

NPS measures user loyalty with a single question: *"How likely are you to recommend this product to a colleague? (0–10)"*

**Classification**:
- **Promoters (9–10)**: Loyal users, will promote the product.
- **Passives (7–8)**: Satisfied but unenthusiastic.
- **Detractors (0–6)**: Dissatisfied, potential churn risks.

**NPS Formula**: `NPS = % Promoters - % Detractors` (range: -100 to +100).

**Automation Triggers**:
```javascript
// Trigger NPS survey via email/in-app
const triggers = [
  { event: 'user_signup', delay: '7 days', campaign: 'NPS_Day7' },
  { event: 'user_signup', delay: '30 days', campaign: 'NPS_Day30' },
  { event: 'subscription_renewed', delay: '90 days', campaign: 'NPS_Quarterly' }
];
```

**Tool Recommendations**:
- **Free**: Typeform (50 responses/month), Google Forms + Zapier.
- **Paid**: Delighted ($99/month), SatisMeter, Refiner.

#### 2.2 In-App Feedback Widget

Embed a feedback widget in the corner of the application to capture spontaneous feedback.

**Minimalist Implementation with Canny (Free for < 100 MAU)**:
```html
<!-- Embed Canny widget in app dashboard -->
<script>
  !function(w,d,i,s){function l(){if(!d.getElementById(i)){var f=d.getElementsByTagName(s)[0],e=d.createElement(s);e.type="text/javascript",e.async=!0,e.src="https://canny.io/sdk.js",f.parentNode.insertBefore(e,f)}}if("function"!=typeof w.Canny){var c=function(){c.q.push(arguments)};c.q=[],w.Canny=c,"complete"===d.readyState?l():w.attachEvent?w.attachEvent("onload",l):w.addEventListener("load",l,!1)}}(window,document,"canny-jssdk","script");
  
  Canny('render', {
    boardToken: 'YOUR_BOARD_TOKEN',
    basePath: '/feedback',
    ssoToken: user.cannyToken // Optional: SSO to link to user account
  });
</script>
```

**Other Alternatives**: UserVoice, Fider (open-source), custom form to Notion database.

#### 2.3 Support Ticket Analysis

Aggregate support tickets into a knowledge base:
1. **Categorization Tags**: Bug, Feature Request, How-To, Payment Issue.
2. **Pattern Extraction**: If > 5 tickets ask the same question → create FAQ entry or fix UX.
3. **Automated Response Template**: Set up canned responses for repetitive questions.

**Example Workflow with GitHub Issues**:
```bash
# Automated labeling based on keyword
gh api repos/{username}/{repo}/issues/123 -X PATCH \
  -f state='open' \
  -f labels='["bug", "high-priority"]'
```

**Step 2 Output**: Active feedback system setup (NPS scheduled, widget live, tickets aggregated).

---

### Step 3: Cohort Analysis

Cohort analysis breaks down users by registration time or behavior to uncover retention and churn patterns.

#### 3.1 Retention Cohorts

**Definition**: A group of users who registered in the same week/month, tracked for activity over time.

**Cohort Table Example**:

| Signup Week | Cohort Size | Week 0 | Week 1 | Week 2 | Week 4 |
| :--- | ---: | ---: | ---: | ---: | ---: |
| 2026-09-01 | 120 | 100% | 45% | 32% | 18% |
| 2026-09-08 | 150 | 100% | 52% | 38% | 22% |
| 2026-09-15 | 180 | 100% | 48% | 35% | - |

**Insight**: Week 2 retention rose from 32% → 38% after onboarding improvements. Continue improvement.

**Tools**: Mixpanel (paid), PostHog (open-source self-hosted), custom SQL query.

#### 3.2 Behavioral Segmentation

Segment users based on actual behavior, not demographics:
- **Power Users**: Top 10% activity (daily login, uses advanced features).
- **Casual Users**: Weekly login, uses basic features only.
- **At-Risk Users**: Inactive > 14 days, but has not unsubscribed.
- **Churned Users**: Inactive > 60 days or canceled subscription.

**Differentiated Actions per Segment**:
```javascript
// Example: Email retention campaign
if (segment === 'power_users') {
  sendEmail('invite_beta_feature'); // Engage with early access
} else if (segment === 'at_risk') {
  sendEmail('win_back_offer'); // Discount or value prop reminder
}
```

#### 3.3 Churn Prediction Signals

Set up an early warning system for users at risk of churning:

**Churn Indicators**:
- `last_active_at > 14 days` for consumer apps, `> 7 days` for daily-use tools.
- Login frequency drops > 50% from baseline.
- Never used key features (activation milestone not reached).

**Proactive Intervention**:
```sql
-- Identify at-risk users
SELECT user_id, email, last_active_at, 
       DATE_PART('day', NOW() - last_active_at) AS days_inactive
FROM users
WHERE last_active_at < NOW() - INTERVAL '14 days'
  AND subscription_status = 'active'
ORDER BY days_inactive DESC;
```

Send targeted email: *"We noticed you haven't logged in for [X] days. Is there anything we can help with?"*

#### 3.4 Power User Identification

Power users are the best source of feedback and candidate testimonials:
```sql
-- Identify power users (top 10% activity)
WITH activity_scores AS (
  SELECT user_id, 
         COUNT(*) AS total_sessions,
         SUM(session_duration_sec) AS total_time_sec
  FROM sessions
  WHERE created_at >= NOW() - INTERVAL '30 days'
  GROUP BY user_id
)
SELECT user_id, total_sessions, total_time_sec
FROM activity_scores
WHERE total_sessions >= (SELECT PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY total_sessions) FROM activity_scores);
```

**Actions for Power Users**:
- Invite to user advisory board (monthly call).
- Offer early beta feature access.
- Request testimonials or case studies.

**Step 3 Output**: Cohort analysis dashboard + weekly updated user segment lists.

---

### Step 4: Feature Prioritization with RICE

RICE is a scoring framework for prioritizing feature backlogs objectively.

*Full guide: `references/pm/PM_PRIORITIZATION_FRAMEWORKS.md`*

#### 4.1 RICE Framework

**Formula**:
```
RICE Score = (Reach × Impact × Confidence) / Effort
```

**Variable Definitions**:
- **Reach**: How many users are affected per quarter? (absolute numbers: 100, 500, 1000 users).
- **Impact**: How significant is the impact per user? (scale: 0.25 = Minimal, 0.5 = Low, 1 = Medium, 2 = High, 3 = Massive).
- **Confidence**: How confident is this estimate? (percentage: 50% = Low, 80% = Medium, 100% = High).
- **Effort**: How many person-months (PM) to develop? (0.5 PM, 1 PM, 2 PM, etc.).

**Calculation Example**:

| Feature | Reach | Impact | Confidence | Effort (PM) | RICE Score |
| :--- | ---: | ---: | ---: | ---: | ---: |
| Dark Mode | 800 | 0.5 | 80% | 0.5 | 640 |
| Export to PDF | 500 | 1 | 100% | 1 | 500 |
| Multi-language | 1200 | 2 | 50% | 3 | 400 |
| Social Login (Google) | 600 | 0.5 | 80% | 0.5 | 480 |
| Advanced Analytics | 150 | 3 | 80% | 2 | 180 |

**Priority**: Build Dark Mode (score 640) first.

#### 4.2 Feature ROI Calculation

Calculate return on investment for paid features:
```
Feature ROI = (Expected Incremental Revenue - Development Cost) / Development Cost × 100%
```

**Example**:
- **Premium Export Feature**: Development cost Rp 10 million (40 hours × Rp 250k/hour).
- **Expected Revenue**: 50 users upgrade to paid tier (+Rp 50k/month) = Rp 2.5 million/month.
- **Payback Period**: 10 million / 2.5 million = 4 months.
- **Annual ROI**: (2.5 million × 12 - 10 million) / 10 million = 200%.

Prioritize features with a payback period < 6 months.

#### 4.3 Opportunity Cost Analysis

Every chosen feature = another feature left unbuilt.

**Mandatory Questions to Answer**:
- If I work on Feature A for 2 months, which features are delayed?
- Is Feature A more urgent than fixing a declining retention rate?

**Decision Matrix Framework**:

| Quadrant | Impact (Y-Axis) | Urgency (X-Axis) | Decision |
| :--- | :--- | :--- | :--- |
| **Q1: Do First** | High | High | Execute immediately (critical bugs, churn blockers) |
| **Q2: Schedule** | High | Low | Add to next quarter's roadmap (strategic features) |
| **Q3: Delegate/Automate** | Low | High | Seek low-code solutions or outsource |
| **Q4: Drop** | Low | Low | Drop from backlog |

**Step 4 Output**: Feature backlog sorted by RICE score, updated monthly (use `templates/09-product-growth/GROWTH_EXPERIMENTS_BACKLOG_TEMPLATE.md`).

---

### Step 5: Growth Experiments Backlog

Every feature or UX change is an experiment. Document hypotheses and results to build institutional knowledge.

#### 5.1 Hypothesis Format (from Module 04 A/B Testing)

**Experiment Hypothesis Template**:
```
We believe that [CHANGE]
will result in [IMPACT]
for [TARGET SEGMENT]
because [RATIONALE].

We will measure success by [METRIC DEFINITION & THRESHOLD].
```

**Example**:
```
We believe that adding social proof badges ("1,234 users love this feature")
will result in 15% increase in feature adoption rate
for new users in their first 7 days
because users trust features validated by peers (source: Nielsen Norman Group social proof study).

We will measure success by tracking "feature_used" event Day 1-7 cohort comparison.
```

#### 5.2 Experiment Queue Prioritization

Sort experiments based on:
1. **Expected Lift × Ease**: (Impact 1–10) × (Implementation ease 1–10).
2. **Strategic Alignment**: Does this experiment align with the North Star Metric (M00)?

**Queue Example**:

| Experiment | Expected Lift | Ease | Priority Score | Status |
| :--- | ---: | ---: | ---: | :--- |
| Email reminder for incomplete signups | 8 | 9 | 72 | Running |
| Personalized onboarding flow | 9 | 5 | 45 | Backlog |
| Loyalty points gamification | 6 | 3 | 18 | Backlog |

#### 5.3 Velocity Tracking

Target experiment velocity for solo developers: **2–4 experiments per month** (1 experiment every 1–2 weeks).

**Tracking Metrics**:
- Number of experiments launched.
- Win rate (% of experiments beating control).
- Average setup time (from idea → launch).

**Learning Repository**: Document all experiments (win, lose, neutral) in the `docs/experiments/` folder:
```
docs/experiments/
├── 2026-09-experiment-001-social-proof-badges.md
├── 2026-09-experiment-002-email-drip-sequence.md
└── 2026-10-experiment-003-pricing-page-redesign.md
```

**Step 5 Output**: Growth Experiments Backlog updated every sprint (use `templates/09-product-growth/GROWTH_EXPERIMENTS_BACKLOG_TEMPLATE.md`).

---

### Step 6: Product Health Monitoring

Continuous monitoring with a consistent rhythm prevents drifting aimlessly.

#### 6.1 Weekly Metrics Review (15-Minute Standup)

Every Monday morning, review the metrics snapshot:
- **Acquisition**: How many new signups last week vs target?
- **Activation**: % signups completing onboarding?
- **Retention**: Day 7 retention rate for last week's cohort?
- **Revenue**: MRR growth vs churn?
- **Bug/Performance**: Any error rate spikes or response time degradation?

**Minimalist Dashboard Format**:
```yaml
# Product Health Dashboard (Week 39, 2026)
Signups: 45 (target: 50) ❌
Activation Rate: 68% (baseline: 65%) ✅
Day 7 Retention: 42% (baseline: 40%) ✅
MRR: Rp 12.5M (growth: +8% MoM) ✅
P95 Response Time: 520ms (SLA: 500ms) ⚠️
Critical Bugs: 0 ✅
```

Tools: Notion database, Google Sheets auto-updating via API, or Grafana dashboard.

#### 6.2 Monthly OKR Check-In (Alignment to M00 North Star)

At the end of each month, evaluate progress against the **North Star Metric** (from Module 00):
- Is the North Star Metric moving upward?
- Which Key Results are on-track vs at-risk?
- Are there blockers that need escalation?

**North Star Metric Examples**:
- **B2B SaaS**: Weekly Active Companies (WAC).
- **E-Commerce**: Gross Merchandise Value (GMV) per month.
- **Marketplace**: Successful Transactions per week.

**Monthly Review Template**:
```markdown
# Monthly OKR Review (September 2026)

North Star Metric: Weekly Active Companies (WAC)
- Target Q3: 120 WAC
- Actual: 105 WAC (88% of target) ⚠️

Key Results:
- KR1: Increase activation rate to 70% → Achieved 68% ✅
- KR2: Reduce churn to < 5%/month → Actual 6.2% ❌
- KR3: Launch 2 enterprise features → Launched 1/2 ⚠️

Blockers:
- High churn from "small teams" segment → need better onboarding.

Actions Next Month:
- Prioritize churn reduction experiments.
- Interview churned users for qualitative insight.
```

#### 6.3 Quarterly Roadmap Review

Review the roadmap every quarter:
- Which features delivered impact vs which did not?
- Are there new learnings from experiments that warrant a strategy pivot?
- Are next quarter's priorities still relevant?

**Decision Framework**:
- **Double Down**: If a feature/channel succeeds, allocate more resources.
- **Pivot**: If hypotheses prove false, alter the approach.
- **Kill**: If a feature is unused (< 5% adoption after 3 months), deprecate it.

#### 6.4 Annual Strategy Refresh

Every year, revisit Module 00 (Product Discovery & Strategy):
- Is the Vision Statement still relevant?
- Has the competitive landscape shifted?
- Are there new market opportunities or emerging threats (regulations, technology)?

**Step 6 Output**: Weekly dashboard + Monthly OKR doc + Quarterly roadmap update (use `templates/09-product-growth/PRODUCT_HEALTH_DASHBOARD_TEMPLATE.md`).

---

### Step 7: Scaling Considerations

Monitoring signals to know when the system or team needs scaling.

#### 7.1 Performance Degradation Signals

**Infrastructure Scale-Up Triggers**:
- P95 response time consistently > 500ms.
- Database query time > 100ms for critical queries.
- N+1 query problems appearing in Sentry (multiple queries for a single page load).
- CPU/Memory usage > 80% during peak hours.

**Actions**:
- Database indexing audit (run `EXPLAIN ANALYZE` for slow queries).
- Caching layer (Redis for session/query results).
- CDN for static assets (Cloudflare, Vercel Edge).
- Vertical server scaling (upgrade tier) or horizontal scaling (load balancer + multiple instances).

#### 7.2 Database Optimization Triggers

**Signs DB Optimization Is Needed**:
- Primary tables > 1 million rows without partitioning.
- Full table scans in query logs.
- Backup time > 30 minutes.

**Optimization Strategies**:
```sql
-- Indexes for frequently filtered/joined columns
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_created_at ON orders(created_at DESC);

-- Partitioning for large tables (time-series data)
CREATE TABLE events_2026_09 PARTITION OF events
FOR VALUES FROM ('2026-09-01') TO ('2026-10-01');
```

#### 7.3 Infrastructure Cost Monitoring

**Cost Efficiency Metric**:
```
Cost per Active User (CAU) = Total Infrastructure Cost / Monthly Active Users
```

**Benchmarks**:
- **Good**: CAU < $1 for consumer apps, < $10 for B2B SaaS.
- **At Risk**: CAU increasing without significant feature or user growth.

**Tracking Example**:
```markdown
# Infrastructure Cost (September 2026)
- Vercel: $120/month
- Supabase: $25/month
- Sentry: $29/month
- Total: $174/month

MAU: 350 users
CAU: $0.50/user ✅ (target: < $1)
```

**Actions if CAU increases sharply**:
- Audit unused resources (staging environments left running).
- Optimize asset delivery (compress images, lazy load).
- Negotiate pricing tiers with vendors.

#### 7.4 Team Expansion Indicators

**Solo dev overload signals**:
- Work hours consistently > 60 hours/week.
- Support tickets unanswered > 48 hours.
- Roadmap velocity drops > 50% (due to excessive fire-fighting).
- Critical bug fixes delayed due to lack of bandwidth.

**Team Scaling Options**:
1. **Part-time VA/Support**: Outsource support tickets to a VA (Rp 2-3M/month).
2. **Freelance Developer**: Hire for specific features (project-based).
3. **Co-founder/Partner**: If revenue > Rp 50M/month and sustainable.

**Step 7 Output**: Scaling metrics monitoring dashboard (performance, cost, workload).

---

## 4. Adaptation by Project Scale

| Operations Parameter | Small Scale (MVP) | Mid-Scale (B2B SaaS) | Large Scale (Enterprise) |
| :--- | :--- | :--- | :--- |
| **Metrics Review Frequency** | Weekly (manual check) | Daily (automated dashboard) | Real-time (alerting system) |
| **Cohort Analysis** | Monthly manual SQL query | Weekly Mixpanel/PostHog | Data warehouse + BI tool (Looker, Metabase) |
| **NPS Survey** | 1x per quarter (manual email) | Automated trigger via Delighted | Enterprise NPS tool + CSAT tracking |
| **Experiment Velocity** | 1–2 per month | 2–4 per month | 1–2 per week (dedicated growth team) |
| **Scaling Threshold** | > 1,000 MAU or $5k MRR | > 10k MAU or $50k MRR | > 100k MAU or $500k MRR |

---

## 5. Output Deliverables

> 📁 **ABSOLUTE FILE LOCATION RULES**:
> All metrics, experiments, and product health documents MUST be stored inside the **`docs/pm/`** folder (for PM docs) and **`docs/analytics/`** (for metrics reports).

This module produces 4 operations documents + 1 reference guide:

1. **`docs/analytics/METRICS_BASELINE_REPORT.md`**: Baseline metrics report for the first 30 days post-launch (using `templates/09-product-growth/METRICS_BASELINE_REPORT_TEMPLATE.md`).
2. **`docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md`**: Growth experiments backlog with RICE scoring and results tracking (using `templates/09-product-growth/GROWTH_EXPERIMENTS_BACKLOG_TEMPLATE.md`).
3. **`docs/pm/PRODUCT_HEALTH_DASHBOARD.md`**: Product health dashboard for weekly/monthly/quarterly reviews (using `templates/09-product-growth/PRODUCT_HEALTH_DASHBOARD_TEMPLATE.md`).
4. **`docs/pm/SCALING_SIGNALS.md`**: Threshold and trigger documentation for scaling infrastructure/team.
5. **`references/pm/PM_CONTINUOUS_IMPROVEMENT_GUIDE.md`**: Comprehensive reference guide for continuous iteration best practices.
6. **`references/pm/PM_PRIORITIZATION_FRAMEWORKS.md`**: RICE scoring and backlog prioritization guide.

---

## 6. [GATE] Exit Criteria

[GATE] Module 13 is declared **SUCCESSFUL & CONTINUOUS ITERATION ACTIVE** if:

- [x] Baseline metrics for the first 30 days have been collected and documented (`METRICS_BASELINE_REPORT.md`).
- [x] Automated feedback loop system is active (NPS survey scheduled, in-app widget live, tickets aggregated).
- [x] Cohort analysis dashboard or SQL query is available and executed at least 1x per month.
- [x] Feature backlog has been prioritized using the RICE framework (`GROWTH_EXPERIMENTS_BACKLOG.md`).
- [x] At least 1 growth experiment has been launched and its results documented.
- [x] Weekly metrics review ritual has run for at least 4 consecutive weeks.
- [x] Scaling signals monitoring system is set up (performance, cost, workload alerts).

---

## 7. Integration with Other Modules

Module 13 is the **convergence point** of the entire product lifecycle:

| Related Module | Integration into M13 |
| :--- | :--- |
| **M00: Product Discovery & Strategy** | North Star Metric from M00 serves as the anchor for OKR tracking and feature prioritization. |
| **M01: Idea & Feasibility** | OKRs in M01 are checked for progress monthly in M13 monthly reviews. |
| **M04: UI/UX Prototyping** | Hypothesis format from M04 A/B testing is used for growth experiments in M13. |
| **M06 Section 6A: Analytics** | Event tracking and dashboards in M06 Section 6A serve as data sources for M13 cohort analysis. |
| **M10: Deployment & Production** | Performance metrics from M10 monitoring are reviewed in M13 scaling considerations. |
| **M12: Warranty & SLA** | Incidents and support tickets from M12 are analyzed in M13 for product improvements. |

---

## 🔄 CONTINUOUS ITERATION PROTOCOL (LIFECYCLE CONTINUES)

After all stages of Module 13 are set up:

### **STEP 0: FILE EXISTENCE VERIFICATION (BLOCKING CHECK)**

**MANDATORY BEFORE DECLARING SETUP COMPLETE**:

1. **Check output file existence** using one of the following methods:
   - PowerShell: `Test-Path -LiteralPath "docs/analytics/METRICS_BASELINE_REPORT.md"` → must return `True`
   - Read tool: `read_file('docs/analytics/METRICS_BASELINE_REPORT.md')` → must succeed without error
   - PowerShell: `Test-Path -LiteralPath "docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md"` → must return `True`
   - Read tool: `read_file('docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md')` → must succeed without error

2. **IF FILE DOES NOT EXIST**:
   - ❌ **STOP IMMEDIATELY** - do not declare setup complete
   - ❌ **DO NOT display continuous iteration success** to user
   - ✅ **REPORT ERROR** to user:
     ```
     CRITICAL ERROR: File METRICS_BASELINE_REPORT.md or GROWTH_EXPERIMENTS_BACKLOG.md was not created.
     Module 13 INCOMPLETE - continuous iteration setup FAILED.
     
     Probable causes:
     - Write permission denied on docs/analytics/ or docs/pm/ folder
     - Path typo in tool call
     - Disk full
     
     Please investigate this issue before declaring setup complete.
     ```
   - ✅ **END TURN** and wait for user to fix issue

3. **ONLY IF FILES EXIST**: Proceed to continuous iteration protocol below

---

### **STEP 1: CONTINUOUS ITERATION PROTOCOL**

1. **Verify setup complete**:
   - [ ] `read_file('docs/analytics/METRICS_BASELINE_REPORT.md')` → Confirm baseline metrics documented
   - [ ] `read_file('docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md')` → Confirm RICE-scored backlog exists
   - [ ] Confirm feedback loop active (NPS, widget, tickets)
   - [ ] Confirm weekly metrics review ritual established
2. **This is a module that is never "finished"**. Continuous iteration runs as long as the product remains active.
3. Review and update M13 artifacts every quarter to reflect new learnings.
4. **If you decide to pivot or sunset the product**, document the decision in `docs/pm/PRODUCT_LIFECYCLE_DECISION.md` with supporting data from M13 metrics.

**COMPLETE PRODUCT LIFECYCLE**: M00 → M01 → ... → M12 → **M13 (Continuous Loop)** → (Pivot/Scale/Sunset Decision).
