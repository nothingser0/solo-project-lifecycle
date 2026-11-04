# Module 13 Deep Dive: Metrics SQL, NPS Automation, Cohort Analysis, RICE & Scaling Signals

## Contents

- [Step 1 (Detail): Metrics Baseline Collection](#step-1-detail-metrics-baseline-collection)
- [Step 2 (Detail): Feedback Loop Automation](#step-2-detail-feedback-loop-automation)
- [Step 3 (Detail): Cohort Analysis](#step-3-detail-cohort-analysis)
- [Step 4 (Detail): RICE Prioritization](#step-4-detail-rice-prioritization)
- [Step 5 (Detail): Growth Experiments Backlog](#step-5-detail-growth-experiments-backlog)
- [Step 6 (Detail): Product Health Monitoring](#step-6-detail-product-health-monitoring)
- [Step 7 (Detail): Scaling Considerations](#step-7-detail-scaling-considerations)


> Companion to `docs/modules/13_PRODUCT_OPERATIONS_ITERATION.md` (runbook). This file holds the detailed execution steps; the runbook keeps a condensed summary.

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

### 5.4 A/B Test Statistical Analysis Pipeline

Full manual guide: `references/pm/AB_TEST_ANALYSIS_GUIDE.md`.

Automated CLI analysis via `scripts/runtime/analyze_ab_test.py`:

```bash
# Example invocation with guardrails
python scripts/runtime/analyze_ab_test.py \
  --test-name "Pricing Page Redesign" \
  --hypothesis "Clearer tiered comparison increases trial conversions" \
  --duration-days 14 \
  -cu 1800 -cc 180 \
  -vu 1820 -vc 235 \
  --mde 10.0 \
  --guardrail "P95 Latency:210ms:215ms:PASS" \
  --guardrail "Refund Rate:1.2%:1.1%:PASS"
```

**Statistical Formulas Enforced**:
1. **Sample Size & Power**: $n_{\text{req}} = \frac{2 \cdot (Z_{\alpha/2} + Z_\beta)^2 \cdot p(1-p)}{MDE^2}$. Flag if underpowered ($<80\%$ power or $<100$ conversions/variant).
2. **Sample Ratio Mismatch (SRM)**: $\chi^2 = \sum \frac{(O - E)^2}{E}$. If $p_{SRM} < 0.001$, traffic allocation is biased — test is invalid.
3. **Relative Lift**: $\text{Lift} = \frac{p_v - p_c}{p_c} \times 100\%$.
4. **Z-Score & Two-Tailed p-value**: $Z = \frac{p_v - p_c}{\sqrt{SE_c^2 + SE_v^2}}$, evaluate against $\alpha = 0.05$.
5. **95% Confidence Interval**: $\Delta \pm 1.96 \cdot SE$.

**Outcome Actions**:
- **Ship it**: Significant positive lift ($p < 0.05$) + clean guardrails $\rightarrow$ Roll out to 100%.
- **Investigate**: Significant positive lift, but secondary metric degraded $\rightarrow$ Trade-off review.
- **Extend the test**: Directional positive lift, but underpowered or duration $< 7$ days $\rightarrow$ Run longer.
- **Stop the test**: Inconclusive / flat lift with adequate power $\rightarrow$ Kill variant, free bandwidth.
- **Don't ship**: Significant negative lift $\rightarrow$ Instant kill switch, revert to control.

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

## Runbook Originals (moved 2026-11-04)

Original text verbatim, so no clause is lost when a condensed step is ambiguous.

```markdown
# Module 13: Product Operations & Continuous Iteration

> **Templates to copy**: `templates/09-product-growth/AB_TEST_REPORT_TEMPLATE.md` · `METRICS_BASELINE_REPORT_TEMPLATE.md` · `GROWTH_EXPERIMENTS_BACKLOG_TEMPLATE.md` · `CHURN_PREVENTION_PLAYBOOK.md` · `SAAS_PRICING_MONETIZATION_GUIDE.md` · `ONBOARDING_ACTIVATION_PLAYBOOK.md`
> 📖 **Optional** (do NOT preload): `references/pm/AB_TEST_ANALYSIS_GUIDE.md` · `references/pm/PM_PRIORITIZATION_FRAMEWORKS.md` · `references/pm/PM_CONTINUOUS_IMPROVEMENT_GUIDE.md` · `references/pm/PRODUCT_SUNSET_AND_EOL_GUIDE.md` · `templates/09-product-growth/FEATURE_SUNSET_CHECKLIST.md` · `references/pm/FEATURE_FINANCIAL_INVESTMENT_FRAMEWORK.md` · `references/growth/ENGINEERING_AS_MARKETING_PLAYBOOK.md` · `references/growth/BEHAVIORAL_PSYCHOLOGY_FRAMEWORK.md` · `deep-dives/13_PRODUCT_OPERATIONS_ITERATION.md` (retention/churn SQL, NPS snippets, RICE worked examples, OKR templates, benchmarks)

> **RICE scoring (inline — no need to open the PM guide)**:
> `Score = (Reach × Impact × Confidence) / Effort` · Reach = users/quarter affected · Impact = 0.25 minimal / 0.5 low / 1 medium / 2 high / 3 massive · Confidence = 100% high / 80% medium / 50% low · Effort = person-weeks. Higher score = do first.

Post-launch stage after M12: shift from "building" to "optimizing & growing" on real user data via a **metrics-driven operational framework**.

---

## 1. Execution Cycle (Condensed)

```text
[ INPUT: Stable production system + first 30 days of user data ]
  → STEP 1: Metrics baseline — 30-day collection; Mean/Median/P50–P95; benchmark compare; anomaly alerts
  → STEP 2: Feedback loop — NPS (Day 7/30/Quarterly); in-app widget; tickets → FAQ
  → STEP 3: Cohorts — Day 1/7/30/90 retention; Power/Casual/At-Risk/Churned segments; churn signals
  → STEP 4: RICE prioritization — Reach × Impact × Confidence / Effort; ROI; opportunity cost
  → STEP 5: Experiments backlog — hypothesis format (M04); lift × ease queue; 2–4/month; learning repo
  → STEP 6: Health monitoring — weekly standup; monthly OKR vs North Star (M00); quarterly roadmap; annual refresh
  → STEP 7: Scaling signals — P95 > 500ms; query > 100ms/N+1; cost per active user; solo overload > 60 h/wk
  → OUTPUT: 4 ops documents + 1 reference guide
```

## 2. Product Operations ≠ DevOps

Not uptime/deploy speed — the **quality of product decisions from data**. Dev metrics (coverage, build time, deploy frequency) → product metrics (retention, adoption, NPS, revenue/user); sprints → continuous dynamic iteration; success = feature moves business metrics. **Golden principle**: every feature decision answers *"Which metric will move if this feature succeeds?"*

## 3. Step-by-Step (SQL, snippets & examples in deep dive)

### Evidence method by traffic and risk
Choose the smallest method that can answer the product question. With low traffic or few customers, use instrumented task observation, support/interview themes, cohort direction, or a time-boxed concierge/usability test; report counts and context, and label the result directional. Use an A/B test only when traffic, conversion volume, and exposure control can support the planned decision. Do not turn an underpowered result into a winner or a failed feature. Set a feature flag and rollback path when a production change needs controlled exposure or fast reversal; a flag is not a prerequisite for every interview or manual experiment. Keep claims proportional to the evidence and carry unresolved assumptions in the shared assumption ledger.

1. **Baseline** (≥30 days live): Acquisition (signups/sources), Activation (% onboarded / first core action ≤24 h), Retention (Day 1/7/30/90), Revenue (MRR/ARPU/LTV), Engagement (DAU/MAU), Performance (P95, error rate). P95 = SLA threshold. Benchmarks: B2B SaaS Day-30 retention 25–40%, NPS 30–50. Below benchmark → prioritize onboarding/activation. Alert on DAU drop > 30% vs 30-day baseline.
2. **Feedback loop**: NPS = % Promoters − % Detractors, automated at Day 7/30/Quarterly when the sample and consent support it; Canny/Fider widget; > 5 identical tickets → FAQ or UX fix. Group requests by user segment, job, and observed pain; deduplicate repeats and retain representative evidence. Treat request counts as a prioritization signal, not proof of demand—validate decision-critical needs with user behavior or research before expanding scope.
3. **Cohorts**: weekly signup cohorts; Power Users (top 10% → advisory board, beta, testimonials), At-Risk (inactive > 14 days consumer / > 7 days daily-tools → win-back), Churned (> 60 days or canceled). Signals: activity drop > 50%, activation milestone never reached.
4. **RICE**: `(Reach × Impact × Confidence) / Effort` (Impact 0.25–3; Confidence 50/80/100%). ROI = (incremental revenue − cost)/cost → payback < 6 months. Mandatory opportunity-cost questions. Quadrants: Do First / Schedule / Delegate / Drop.
5. **Experiments & Rollback Safety (method chosen for the evidence available)**:
   - Hypothesis format: *"We believe [CHANGE] → [IMPACT] for [SEGMENT] because [RATIONALE]; measured by [METRIC & THRESHOLD]"*.
   - **Controlled exposure**: When a production experiment needs segmented rollout or rapid reversal, use a feature flag with a named owner, rollback trigger, and removal date. Otherwise document the test's exposure and rollback method; do not add a flag by default.
   - **Statistical guardrails**: For A/B tests, check allocation, sample adequacy, duration, confidence interval, and practical effect before deciding. Underpowered or low-volume results are inconclusive and must not be reported as statistically proven. Do not require an A/B test when a qualitative or behavioral method is more suitable.
   - **Guardrail metrics**: Check relevant secondary measures (such as revenue, latency, churn, errors, or support burden) for material harm; choose these before the test based on the change.
   - **Structured Decision Matrix**: Evaluate results via CLI (`python scripts/runtime/analyze_ab_test.py`) into actionable verdicts:
     - *Ship it (100% rollout)*: Significant positive lift, no guardrail degradations.
     - *Investigate*: Significant positive lift, but secondary/guardrail metric regressed.
     - *Extend the test*: Directional positive trend, but underpowered or duration < 7 days.
     - *Stop the test*: Inconclusive / flat lift with adequate power — preserve dev bandwidth.
     - *Don't ship*: Significant negative lift — toggle kill switch, revert to control.
     - *Stop & Invalidate*: SRM detected ($p_{SRM} < 0.001$) — allocation router broken.
   - Queue by lift × ease + North Star alignment; set a cadence the product's traffic and solo capacity can sustain; log result, evidence strength, and next decision in `docs/experiments/` (see `references/pm/AB_TEST_ANALYSIS_GUIDE.md`).
6. **Health cadence**: weekly 15-min (signups, activation, D7 retention, MRR vs churn, errors/latency); monthly OKR vs North Star; quarterly Double Down / Pivot / Kill (< 5% adoption after 3 months → deprecate); annual strategy refresh vs M00.
7. **Scaling**: P95 > 500ms / query > 100ms / N+1 / CPU > 80% → indexing audit, Redis, CDN, scale out. DB > 1M rows unpartitioned, backup > 30 min → indexes/partitioning. `CAU = infra cost / MAU` (< $1 consumer, < $10 B2B). Overload (> 60 h/wk, tickets > 48 h unanswered) → VA/support, freelance dev, or co-founder.

## 4. Scale & Termination Rules

Small → **M13 WAIVED** (ends M12). Client/Freelance/Internal → **WAIVED** (ends M11/M12). Solo SaaS → **mandatory continuous loop**. Large → mandatory + RICE backlog (daily dashboards, 2–4 experiments). Enterprise → A00/A04. The gate validator enforces this automatically.

## 5. Deliverables

`docs/analytics/` for metrics, `docs/pm/` for ops docs:
1. **`docs/analytics/METRICS_BASELINE_REPORT.md`** — 30-day baseline; must document **Acquisition + Activation + Retention** pillars with actual measurements.
2. **`docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md`** — RICE-scored backlog + results (mandatory Large).
3. **`docs/pm/PRODUCT_HEALTH_DASHBOARD.md`** — weekly/monthly/quarterly reviews.
4. **`docs/pm/SCALING_SIGNALS.md`** — infra/team thresholds & triggers.
5. **`references/pm/PM_CONTINUOUS_IMPROVEMENT_GUIDE.md`**, **`references/pm/PM_PRIORITIZATION_FRAMEWORKS.md`**.

## 6. [GATE] Exit Criteria

- [ ] 30-day baseline documented (`METRICS_BASELINE_REPORT.md`).
- [ ] Feedback loop active (NPS scheduled, widget live, tickets aggregated).
- [ ] Cohort analysis executed ≥ 1x/month; backlog RICE-prioritized (`GROWTH_EXPERIMENTS_BACKLOG.md`).
- [ ] At least one decision-making learning cycle is documented with a method suitable for the available traffic, evidence strength, result, and resulting action; A/B claims include valid statistical analysis when an A/B test was used.
- [ ] Product review cadence is established and supported by actual data; flag and rollback controls are documented when controlled production exposure is used.
- [ ] Scaling signals monitored (performance, cost, workload).

## 7. Module Integration

M00 North Star anchors OKRs & prioritization · M01 OKRs reviewed monthly · M04 hypothesis format reused · M06 §6A analytics feed cohorts · M10 performance metrics feed scaling · M12 incidents feed improvements.

---

## 🔄 CONTINUOUS ITERATION PROTOCOL

### STEP 0 — File Existence (BLOCKING)
`test -f docs/analytics/METRICS_BASELINE_REPORT.md` AND `test -f docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md` (waived paths per §4 accept absence). Missing on a required path → **STOP**, report `CRITICAL ERROR: File METRICS_BASELINE_REPORT.md or GROWTH_EXPERIMENTS_BACKLOG.md was not created. Module 13 INCOMPLETE - continuous iteration setup FAILED.` END TURN.

### STEP 1 — Content Validation
Baseline has Acquisition + Activation + Retention pillars (no placeholders); backlog is RICE-scored (no placeholders); feedback loop active; weekly ritual established. **This module is never finished** — refresh artifacts quarterly while the product is active.

### STEP 2 — Gate Verification (MANDATORY)

```
[PASTE RAW OUTPUT OF: ./scripts/gates/validate-gate.sh M13]
```

Execute `./scripts/gates/validate-gate.sh M13` (or `.ps1`). Exit 1 = incomplete; fix and re-run before declaring the loop active.

### STEP 3 — Continuous Loop
Pivot/sunset decisions go to `docs/pm/PRODUCT_LIFECYCLE_DECISION.md` with supporting M13 metrics.

**COMPLETE PRODUCT LIFECYCLE**: M00 → … → M12 → **M13 (Continuous Loop)** → (Pivot/Scale/Sunset Decision).
```
