# Module 13 Deep Dive: Metrics SQL, NPS Automation, Cohort Analysis, RICE & Scaling Signals

> Companion to `docs/modules/13-product-operations-iteration.md` (runbook). This file holds the detailed execution steps; the runbook keeps a condensed summary.

## Step 1 (Detail): Metrics Baseline Collection

### 1.1 Mandatory Metric Categories

| Metric Category | Specific Metrics | Query/Tool |
| :--- | :--- | :--- |
| **Acquisition** | Sign-up rate, traffic source breakdown | Google Analytics, Plausible, PostHog |
| **Activation** | % users completing onboarding / first core action within 24 hours | Custom event tracking (PostHog, Mixpanel) |
| **Retention** | Day 1 / 7 / 30 / 90 retention rate | Cohort analysis SQL query |
| **Referral** | Viral coefficient (new users per existing user) | Referral tracking (if referral program exists) |
| **Revenue** | MRR (Monthly Recurring Revenue), ARPU (Average Revenue Per User), LTV (Lifetime Value) | Stripe Dashboard / payment provider analytics |
| **Engagement** | DAU/MAU ratio, session duration, feature usage frequency | PostHog feature flags + event tracking |
| **Performance** | Response time P50/P95, error rate, uptime % | Sentry, Datadog, Vercel Analytics |

### 1.2 Descriptive Statistics
- **Mean**: Average value, sensitive to outliers.
- **Median**: More robust against outliers, suitable for skewed distributions.
- **Percentiles (P50/P90/P95)**: For performance metrics, use P95 as the SLA threshold.

**Day 7 Retention Cohort SQL**:
```sql
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

### 1.3 Benchmark Comparison

| Product Type | Day 1 Retention | Day 7 Retention | Day 30 Retention | NPS Score |
| :--- | :--- | :--- | :--- | :--- |
| **B2B SaaS** | 60–80% | 40–60% | 25–40% | 30–50 |
| **Consumer Mobile App** | 25–40% | 10–20% | 5–10% | 10–30 |
| **E-Commerce** | 20–35% | 10–15% | 5–10% | 20–40 |
| **Marketplace** | 30–50% | 15–25% | 10–15% | 25–45 |

**Benchmark Sources**: Mixpanel Benchmark Report, Lenny's Newsletter SaaS Metrics, OpenView SaaS Benchmarks. If metrics fall below benchmarks: prioritize onboarding and activation improvements.

### 1.4 Anomaly Detection Setup
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

---

## Step 2 (Detail): Feedback Loop Automation

### 2.1 NPS Survey Automation
NPS measures user loyalty with a single question: *"How likely are you to recommend this product to a colleague? (0–10)"*

**Classification**: Promoters (9–10), Passives (7–8), Detractors (0–6).
**Formula**: `NPS = % Promoters - % Detractors` (range: -100 to +100).

**Automation Triggers**:
```javascript
const triggers = [
  { event: 'user_signup', delay: '7 days', campaign: 'NPS_Day7' },
  { event: 'user_signup', delay: '30 days', campaign: 'NPS_Day30' },
  { event: 'subscription_renewed', delay: '90 days', campaign: 'NPS_Quarterly' }
];
```

**Tool Recommendations**: Free — Typeform (50 responses/month), Google Forms + Zapier. Paid — Delighted ($99/month), SatisMeter, Refiner.

### 2.2 In-App Feedback Widget
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

**Alternatives**: UserVoice, Fider (open-source), custom form to Notion database.

### 2.3 Support Ticket Analysis
1. **Categorization Tags**: Bug, Feature Request, How-To, Payment Issue.
2. **Pattern Extraction**: If > 5 tickets ask the same question → create FAQ entry or fix UX.
3. **Automated Response Template**: Set up canned responses for repetitive questions.

```bash
# Example: GitHub Issues labeling via API
gh api repos/{username}/{repo}/issues/123 -X PATCH \
  -f state='open' \
  -f labels='["bug", "high-priority"]'
```

---

## Step 3 (Detail): Cohort Analysis

### 3.1 Retention Cohort Table Example

| Signup Week | Cohort Size | Week 0 | Week 1 | Week 2 | Week 4 |
| :--- | ---: | ---: | ---: | ---: | ---: |
| 2026-09-01 | 120 | 100% | 45% | 32% | 18% |
| 2026-09-08 | 150 | 100% | 52% | 38% | 22% |
| 2026-09-15 | 180 | 100% | 48% | 35% | - |

**Tools**: Mixpanel (paid), PostHog (open-source self-hosted), custom SQL query.

### 3.2 Behavioral Segmentation
- **Power Users**: Top 10% activity (daily login, uses advanced features).
- **Casual Users**: Weekly login, uses basic features only.
- **At-Risk Users**: Inactive > 14 days, but has not unsubscribed.
- **Churned Users**: Inactive > 60 days or canceled subscription.

```javascript
// Example: Email retention campaign
if (segment === 'power_users') {
  sendEmail('invite_beta_feature'); // Engage with early access
} else if (segment === 'at_risk') {
  sendEmail('win_back_offer'); // Discount or value prop reminder
}
```

### 3.3 Churn Prediction Signals
**Churn Indicators**:
- `last_active_at > 14 days` for consumer apps, `> 7 days` for daily-use tools.
- Login frequency drops > 50% from baseline.
- Never used key features (activation milestone not reached).

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

### 3.4 Power User Identification
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

**Actions for Power Users**: invite to user advisory board (monthly call), offer early beta feature access, request testimonials or case studies.

---

## Step 4 (Detail): RICE Prioritization

*Full guide: `references/pm/PM_PRIORITIZATION_FRAMEWORKS.md`*

**Formula**: `RICE Score = (Reach × Impact × Confidence) / Effort`
- **Reach**: users affected per quarter (absolute numbers).
- **Impact**: 0.25 Minimal / 0.5 Low / 1 Medium / 2 High / 3 Massive.
- **Confidence**: 50% Low / 80% Medium / 100% High.
- **Effort**: person-months (0.5 PM, 1 PM, 2 PM, …).

| Feature | Reach | Impact | Confidence | Effort (PM) | RICE Score |
| :--- | ---: | ---: | ---: | ---: | ---: |
| Dark Mode | 800 | 0.5 | 80% | 0.5 | 640 |
| Export to PDF | 500 | 1 | 100% | 1 | 500 |
| Multi-language | 1200 | 2 | 50% | 3 | 400 |
| Social Login (Google) | 600 | 0.5 | 80% | 0.5 | 480 |
| Advanced Analytics | 150 | 3 | 80% | 2 | 180 |

**Feature ROI**: `(Expected Incremental Revenue - Development Cost) / Development Cost × 100%`. Prioritize features with a payback period < 6 months.

**Opportunity Cost mandatory questions**: If I work on Feature A for 2 months, which features are delayed? Is Feature A more urgent than fixing a declining retention rate?

**Decision Matrix**:

| Quadrant | Impact (Y) | Urgency (X) | Decision |
| :--- | :--- | :--- | :--- |
| **Q1: Do First** | High | High | Execute immediately (critical bugs, churn blockers) |
| **Q2: Schedule** | High | Low | Add to next quarter's roadmap (strategic features) |
| **Q3: Delegate/Automate** | Low | High | Seek low-code solutions or outsource |
| **Q4: Drop** | Low | Low | Drop from backlog |

---

## Step 5 (Detail): Growth Experiments Backlog

### 5.1 Hypothesis Format
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

### 5.2 Experiment Queue Prioritization
Sort by **Expected Lift × Ease**: (Impact 1–10) × (Implementation ease 1–10), plus strategic alignment with the North Star Metric (M00).

| Experiment | Expected Lift | Ease | Priority Score | Status |
| :--- | ---: | ---: | ---: | :--- |
| Email reminder for incomplete signups | 8 | 9 | 72 | Running |
| Personalized onboarding flow | 9 | 5 | 45 | Backlog |
| Loyalty points gamification | 6 | 3 | 18 | Backlog |

### 5.3 Velocity & Learning Repository
Target velocity for solo developers: **2–4 experiments per month**. Track: experiments launched, win rate (% beating control), average setup time (idea → launch).

```
docs/experiments/
├── 2026-09-experiment-001-social-proof-badges.md
├── 2026-09-experiment-002-email-drip-sequence.md
└── 2026-10-experiment-003-pricing-page-redesign.md
```

---

## Step 6 (Detail): Product Health Monitoring

### 6.1 Weekly Metrics Review (15-Minute Standup, Every Monday)
- **Acquisition**: new signups last week vs target?
- **Activation**: % signups completing onboarding?
- **Retention**: Day 7 retention rate for last week's cohort?
- **Revenue**: MRR growth vs churn?
- **Bug/Performance**: error rate spikes or response time degradation?

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

### 6.2 Monthly OKR Check-In (Alignment to M00 North Star)
- Is the North Star Metric moving upward? (B2B SaaS: Weekly Active Companies; E-Commerce: monthly GMV; Marketplace: successful transactions per week)
- Which Key Results are on-track vs at-risk? Blockers needing escalation?

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

### 6.3 Quarterly Roadmap Review
- **Double Down**: If a feature/channel succeeds, allocate more resources.
- **Pivot**: If hypotheses prove false, alter the approach.
- **Kill**: If a feature is unused (< 5% adoption after 3 months), deprecate it.

### 6.4 Annual Strategy Refresh
Revisit Module 00: Is the Vision Statement still relevant? Has the competitive landscape shifted? New market opportunities or emerging threats (regulations, technology)?

---

## Step 7 (Detail): Scaling Considerations

### 7.1 Performance Degradation Signals
**Triggers**: P95 response time consistently > 500ms; database query time > 100ms for critical queries; N+1 query problems in Sentry; CPU/Memory usage > 80% during peak hours.

**Actions**: database indexing audit (`EXPLAIN ANALYZE` for slow queries), caching layer (Redis for session/query results), CDN for static assets (Cloudflare, Vercel Edge), vertical scaling (upgrade tier) or horizontal scaling (load balancer + multiple instances).

### 7.2 Database Optimization Triggers
**Signs**: primary tables > 1 million rows without partitioning; full table scans in query logs; backup time > 30 minutes.

```sql
-- Indexes for frequently filtered/joined columns
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_created_at ON orders(created_at DESC);

-- Partitioning for large tables (time-series data)
CREATE TABLE events_2026_09 PARTITION OF events
FOR VALUES FROM ('2026-09-01') TO ('2026-10-01');
```

### 7.3 Infrastructure Cost Monitoring
```
Cost per Active User (CAU) = Total Infrastructure Cost / Monthly Active Users
```
**Benchmarks**: Good — CAU < $1 for consumer apps, < $10 for B2B SaaS. At Risk — CAU increasing without significant feature or user growth.

```markdown
# Infrastructure Cost (September 2026)
- Vercel: $120/month
- Supabase: $25/month
- Sentry: $29/month
- Total: $174/month

MAU: 350 users
CAU: $0.50/user ✅ (target: < $1)
```

**Actions if CAU increases sharply**: audit unused resources (staging environments left running), optimize asset delivery (compress images, lazy load), negotiate pricing tiers with vendors.

### 7.4 Team Expansion Indicators
**Solo dev overload signals**: work hours consistently > 60 hours/week; support tickets unanswered > 48 hours; roadmap velocity drops > 50% (excessive fire-fighting); critical bug fixes delayed due to lack of bandwidth.

**Team Scaling Options**:
1. **Part-time VA/Support**: Outsource support tickets to a VA (Rp 2-3M/month).
2. **Freelance Developer**: Hire for specific features (project-based).
3. **Co-founder/Partner**: If revenue > Rp 50M/month and sustainable.

> Summary for the runbook: 30-day baseline (Acquisition/Activation/Retention mandatory pillars), automated NPS + in-app widget + ticket aggregation, cohort SQL for retention/churn/power users, RICE-scored backlog with ROI and opportunity cost, 2–4 experiments/month with a learning repository, weekly/monthly/quarterly review cadence, and CAU + P95 latency + workload scaling triggers.
