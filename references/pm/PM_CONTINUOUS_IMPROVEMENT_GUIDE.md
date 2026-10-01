# Product Management: Continuous Improvement Guide

**Purpose:** Post-launch product iteration tactics, growth experiments, and feedback loops for solo product managers.

**When to Use:** After M10 (Deployment) or M13 (Product Operations) — when the product is live and generating real user data.

**Context:** Solo PM mode. You're the Single PIC for product health, growth experiments, and iterative improvement. This guide covers Build-Measure-Learn cycles, feedback collection, cohort analysis, churn prevention, and quarterly roadmap refresh tactics.

---

## Table of Contents

1. [Build-Measure-Learn Cycle](#1-build-measure-learn-cycle)
2. [Growth Experiment Backlog Prioritization](#2-growth-experiment-backlog-prioritization)
3. [Feedback Collection Systems](#3-feedback-collection-systems)
4. [Cohort Analysis & Retention Tracking](#4-cohort-analysis--retention-tracking)
5. [Churn Prediction & Prevention](#5-churn-prediction--prevention)
6. [Feature Adoption Tracking](#6-feature-adoption-tracking)
7. [Quarterly Roadmap Refresh](#7-quarterly-roadmap-refresh)
8. [Product Health Metrics Dashboard](#8-product-health-metrics-dashboard)
9. [Tools & Stack Recommendations](#9-tools--stack-recommendations)

---

## 1. Build-Measure-Learn Cycle

### Overview

The Build-Measure-Learn (BML) loop is the core rhythm of continuous product improvement. Ship small changes, measure impact, learn from data, repeat.

### The Three Phases

#### Phase 1: Build (Ship the Change)

**What to ship:**
- Minimum testable change (not full feature)
- A/B test variants
- Feature flags for gradual rollout

**Deployment tactics:**
```bash
# Feature flag example (LaunchDarkly, Unleash, or custom)
if (featureFlags.isEnabled('new-onboarding-flow', user.id)) {
  return <NewOnboardingFlow />;
} else {
  return <LegacyOnboardingFlow />;
}
```

**Best practices:**
- Ship to 5-10% of users first (canary release)
- Always include a rollback plan
- Instrument before shipping (add tracking events first)

#### Phase 2: Measure (Collect Data)

**What to track:**
- **Primary metric:** The one thing that must improve
- **Guardrail metrics:** Things that must NOT degrade (revenue, churn, NPS)
- **Diagnostic metrics:** Why did the primary metric move?

**Example instrumentation:**
```javascript
// Track key events
analytics.track('Onboarding Step Completed', {
  step: 'company_info',
  variant: 'new_flow',
  time_taken_seconds: 45,
  user_id: user.id
});

analytics.track('Signup Completed', {
  variant: 'new_flow',
  total_time_seconds: 120,
  user_id: user.id
});
```

**Minimum data collection period:**
- **Low-traffic products:** 2-4 weeks (wait for statistical significance)
- **High-traffic products:** 3-7 days (enough for 1000+ users per variant)

#### Phase 3: Learn (Analyze & Decide)

**Analysis checklist:**
- [ ] Did the primary metric improve? (statistical significance: p < 0.05)
- [ ] Did guardrail metrics stay healthy?
- [ ] What segments benefited most? (mobile vs. desktop, new vs. returning)
- [ ] What's the estimated business impact? (revenue, retention, LTV)

**Decision tree:**

```
Primary metric improved significantly?
├─ YES → Did guardrails stay healthy?
│   ├─ YES → Ship to 100%, document learnings
│   └─ NO → Investigate side effects, iterate or kill
└─ NO → Primary metric degraded or flat?
    ├─ DEGRADED → Rollback immediately
    └─ FLAT → Extend test (maybe underpowered) or kill
```

### BML Cycle Cadence

**For solo PMs:**
- **Weekly:** Review experiment results, ship 1-2 new tests
- **Bi-weekly:** Deep-dive on one major metric (retention, activation, churn)
- **Monthly:** Full product health review (all metrics, all cohorts)

---

## 2. Growth Experiment Backlog Prioritization

### ICE Score Framework

**ICE** = **I**mpact × **C**onfidence × **E**ase

Score each experiment 1-10 on:
- **Impact:** How much will this move the North Star Metric?
- **Confidence:** How certain are we this will work?
- **Ease:** How fast/cheap is it to test?

**Formula:**
```
ICE Score = (Impact + Confidence + Ease) / 3
```

**Example:**

| Experiment | Impact | Confidence | Ease | ICE | Priority |
|------------|--------|------------|------|-----|----------|
| Simplify signup (remove 2 steps) | 9 | 8 | 7 | 8.0 | 🔥 High |
| Add social login (Google OAuth) | 7 | 9 | 8 | 8.0 | 🔥 High |
| Redesign pricing page | 6 | 5 | 4 | 5.0 | Medium |
| Build native mobile app | 9 | 6 | 2 | 5.7 | Medium |
| Add dark mode | 3 | 8 | 6 | 5.7 | Medium |
| Localize to Spanish | 5 | 4 | 3 | 4.0 | Low |

**Prioritization rule:** Ship ICE > 7.0 first.

### RICE Score Framework (Alternative)

**RICE** = **R**each × **I**mpact × **C**onfidence / **E**ffort

Use RICE when you need to account for **how many users** are affected.

**Formula:**
```
RICE Score = (Reach × Impact × Confidence) / Effort

Where:
- Reach = # of users affected per quarter
- Impact = 0.25 (minimal), 0.5 (low), 1 (medium), 2 (high), 3 (massive)
- Confidence = 50% (low), 80% (medium), 100% (high)
- Effort = Person-weeks to ship
```

**Example:**

| Experiment | Reach (users/quarter) | Impact | Confidence | Effort (weeks) | RICE |
|------------|----------------------|--------|------------|----------------|------|
| Simplify signup | 2,000 | 2 (high) | 80% | 1 | 3,200 |
| Social login | 2,000 | 1 (medium) | 100% | 2 | 1,000 |
| Mobile app | 500 | 3 (massive) | 50% | 12 | 62.5 |

**Prioritization rule:** Ship highest RICE first.

### Growth Experiment Template

Use this format for your backlog (Notion, Airtable, Linear):

```markdown
## Experiment: [Name]

**Hypothesis:** We believe that [change] will result in [outcome] because [reasoning].

**Metrics:**
- Primary: [Metric to improve]
- Guardrail: [Metrics that must not degrade]

**ICE Score:** [X.X]
**Status:** [Backlog / In Progress / Analyzing / Shipped / Killed]
**Owner:** [You]
**Timeline:** [Start Date] → [End Date]
```

---

## 3. Feedback Collection Systems

### Automated NPS Surveys

**What is NPS?**  
Net Promoter Score = % Promoters (9-10) - % Detractors (0-6)

**When to trigger:**
- After Day 7 (user has formed an opinion)
- After key milestone (e.g., published first project, hit 100 views)
- Quarterly for long-term users

**Survey flow:**

1. **Question 1:** "How likely are you to recommend [Product] to a friend or colleague?" (0-10 scale)
2. **Question 2 (if 0-6):** "What's the main reason for your score?"
3. **Question 2 (if 9-10):** "What do you love most about [Product]?"

**Tools:**
- **Delighted** (delighted.com) — $49/mo, auto-triggered NPS
- **Refiner** (refiner.io) — $79/mo, in-app surveys
- **DIY:** Trigger email via Postmark/SendGrid at Day 7

**Example code (trigger NPS after 7 days):**
```javascript
// Backend: Daily cron job
const usersForNPS = await db.users.findMany({
  where: {
    created_at: { gte: sevenDaysAgo, lte: eightDaysAgo },
    nps_surveyed: false,
    status: 'active'
  }
});

for (const user of usersForNPS) {
  await sendNPSSurvey(user.email, user.id);
  await db.users.update({ where: { id: user.id }, data: { nps_surveyed: true } });
}
```

### In-App Feedback Widgets

**When to use:**
- Context-specific feedback (per-feature or per-page)
- Bug reporting
- Feature requests

**Widget placement:**
- Bottom-right corner: "Feedback" button (always visible)
- After failed actions: "Something wrong? Let us know"
- After successful milestones: "How was this experience?"

**Tools:**
- **Canny** (canny.io) — $79/mo, feedback + roadmap voting
- **UserVoice** (uservoice.com) — $699/mo (overkill for solo; use Canny)
- **Hotjar** (hotjar.com) — $39/mo, feedback + heatmaps
- **DIY:** Simple modal with Textarea → POST to DB

**Example React component:**
```tsx
function FeedbackWidget() {
  const [open, setOpen] = useState(false);
  const [feedback, setFeedback] = useState('');

  const submit = async () => {
    await fetch('/api/feedback', {
      method: 'POST',
      body: JSON.stringify({ feedback, page: window.location.pathname, user_id: user.id })
    });
    setOpen(false);
    toast.success('Thanks for your feedback!');
  };

  return (
    <div className="fixed bottom-4 right-4">
      <button onClick={() => setOpen(true)}>💬 Feedback</button>
      {open && (
        <FeedbackModal feedback={feedback} onChange={setFeedback} onSubmit={submit} onClose={() => setOpen(false)} />
      )}
    </div>
  );
}
```

### User Interviews (Qualitative)

**When to conduct:**
- Before building major features (validate demand)
- After churned users (exit interviews)
- Monthly check-ins with power users

**Interview script (15-30 minutes):**

1. **Context (5 min):** "Tell me about your workflow before using [Product]."
2. **Usage (10 min):** "Walk me through the last time you used [Product]. What were you trying to accomplish?"
3. **Pain Points (5 min):** "What's the most frustrating part of [Product]?"
4. **Feature Requests (5 min):** "If you could wave a magic wand and add one thing, what would it be?"
5. **Willingness to Pay (5 min):** "How much value does [Product] provide? Would you pay $X/month for it?"

**Recruiting tactics:**
- Email top 10 active users: "I'd love to learn from you. 30-min call, $50 Amazon gift card?"
- In-app banner: "Help shape the product. Book a call with the founder."
- Churn survey: "Can I ask why you're canceling? 15-min call, no sales pitch."

**Tools:**
- **Calendly** (calendly.com) — Free, auto-schedule interviews
- **Zoom** or **Google Meet** — Free video calls
- **Grain** (grain.com) — $19/mo, auto-transcribe + highlight reels

---

## 4. Cohort Analysis & Retention Tracking

### Cohort Retention Table

**Definition:** Track what % of users return after Day 1, Day 7, Day 30, Day 90.

**Example cohort table:**

| Signup Week | Users | Day 1 | Day 7 | Day 30 | Day 90 |
|-------------|-------|-------|-------|--------|--------|
| 2026-W38 | 120 | 68% | 42% | 28% | 18% |
| 2026-W37 | 105 | 71% | 45% | 31% | — |
| 2026-W36 | 98 | 65% | 38% | — | — |

**How to interpret:**
- **Day 1 retention <50%:** Onboarding is broken. Users don't see value fast enough.
- **Day 7 retention <30%:** Product isn't sticky. Users try it once and leave.
- **Day 30 retention <15%:** Churn is too high. Product doesn't solve a recurring need.

**Target benchmarks (B2B SaaS):**
- Day 1: 60-80%
- Day 7: 40-60%
- Day 30: 25-40%
- Day 90: 15-30%

### SQL Query for Cohort Analysis

```sql
-- Cohort retention (PostgreSQL)
WITH cohorts AS (
  SELECT 
    user_id,
    DATE_TRUNC('week', created_at) AS cohort_week,
    created_at
  FROM users
),
activity AS (
  SELECT
    user_id,
    DATE_TRUNC('day', event_timestamp) AS activity_date
  FROM events
  WHERE event_name = 'session_start'
)
SELECT
  c.cohort_week,
  COUNT(DISTINCT c.user_id) AS cohort_size,
  COUNT(DISTINCT CASE WHEN a.activity_date = c.created_at + INTERVAL '1 day' THEN c.user_id END) AS day_1_retained,
  COUNT(DISTINCT CASE WHEN a.activity_date = c.created_at + INTERVAL '7 days' THEN c.user_id END) AS day_7_retained,
  COUNT(DISTINCT CASE WHEN a.activity_date = c.created_at + INTERVAL '30 days' THEN c.user_id END) AS day_30_retained
FROM cohorts c
LEFT JOIN activity a ON c.user_id = a.user_id
GROUP BY c.cohort_week
ORDER BY c.cohort_week DESC;
```

### Improving Retention

**Tactics:**

1. **Day 1 retention:** Improve onboarding (faster time-to-value)
   - Show example data (don't start with blank slate)
   - Guide users to first "aha moment" (first project, first result)
   - Send Day 1 email: "Here's what you can do next"

2. **Day 7 retention:** Build habits (trigger loops)
   - Email: "You have 3 new notifications"
   - Push notification: "Your report is ready"
   - In-app nudges: "Complete your profile (2 min)"

3. **Day 30 retention:** Deliver ongoing value
   - Weekly digest emails: "Your stats this week"
   - Feature discovery: "Did you know you can...?"
   - Expansion: "Invite your team (free)"

---

## 5. Churn Prediction & Prevention

### Churn Prediction Model

**Leading indicators of churn:**
- No login in 7 days
- Declined payment (credit card expired)
- Downgrade from paid to free
- Support ticket unresolved for >3 days
- NPS score ≤ 6

**Churn risk score (simple model):**

```python
# Assign points for each risk factor
churn_score = 0

if days_since_last_login > 7:
    churn_score += 3
if days_since_last_login > 14:
    churn_score += 2

if payment_failed:
    churn_score += 5

if nps_score <= 6:
    churn_score += 4

if support_tickets_unresolved > 0:
    churn_score += 2

# Classify
if churn_score >= 7:
    status = "High Risk"
elif churn_score >= 4:
    status = "At Risk"
else:
    status = "Healthy"
```

### Churn Prevention Campaigns

**For "At Risk" users (automated):**

1. **Re-engagement email (Day 7 inactive):**
   ```
   Subject: We miss you! Here's what's new.
   
   Hi [Name],
   
   It's been a week since you last logged in. We've shipped some new features you might love:
   - [Feature 1]
   - [Feature 2]
   
   [CTA: Log back in]
   ```

2. **Winback offer (Day 14 inactive):**
   ```
   Subject: Come back — 50% off next month
   
   We noticed you haven't been around. If pricing is an issue, here's 50% off your next month (expires in 48 hours).
   
   [CTA: Reactivate with discount]
   ```

3. **Exit survey (cancellation flow):**
   ```
   Before you go:
   - What's the main reason you're canceling? [Dropdown]
   - What could we have done better? [Textarea]
   - Would you consider coming back if we fixed [issue]? [Yes/No]
   ```

**For "High Risk" users (manual outreach):**

- Personal email from founder: "Hey [Name], I noticed you haven't logged in. Can I help with anything?"
- Offer live onboarding call (15 min)
- Custom discount or feature access

---

## 6. Feature Adoption Tracking

### What to Track

**Per-feature metrics:**
- **Discovery Rate:** % of users who see the feature (viewed feature page, saw tooltip)
- **Activation Rate:** % of users who try the feature (clicked button, started flow)
- **Adoption Rate:** % of users who use it regularly (3+ times in 30 days)

**Example (new "Export to PDF" feature):**

| Metric | Value | Interpretation |
|--------|-------|----------------|
| Discovery Rate | 68% | Good. Most users find it. |
| Activation Rate | 22% | Low. Only 1 in 3 who see it actually use it. |
| Adoption Rate | 8% | Very low. Not sticky. |

**Action:** Feature is discoverable but not compelling. Improve value prop or kill it.

### Tracking Implementation

```javascript
// Track feature discovery
analytics.track('Feature Discovered', {
  feature: 'export_pdf',
  discovery_method: 'tooltip',  // or 'menu', 'banner', 'email'
  user_id: user.id
});

// Track feature activation
analytics.track('Feature Activated', {
  feature: 'export_pdf',
  user_id: user.id
});

// Query adoption (3+ uses in 30 days)
SELECT 
  user_id,
  COUNT(*) AS usage_count
FROM events
WHERE event_name = 'Feature Activated'
  AND feature = 'export_pdf'
  AND timestamp > NOW() - INTERVAL '30 days'
GROUP BY user_id
HAVING COUNT(*) >= 3;
```

### Feature Kill Criteria

**When to sunset a feature:**
- Adoption rate < 5% after 90 days
- High maintenance cost (bugs, support tickets)
- Doesn't move North Star Metric
- Conflicts with product vision

**How to kill a feature:**
1. **Month 1:** Deprecation notice (in-app banner)
2. **Month 2:** Remove from UI (keep API for 90 days)
3. **Month 3:** Full removal (archive code, update docs)

---

## 7. Quarterly Roadmap Refresh

### OKR-Driven Roadmap

**Framework:** Objectives & Key Results (OKRs)

**Example Q1 2026 OKR:**

**Objective:** Improve new user activation

**Key Results:**
- KR1: Increase Day 7 retention from 40% to 55%
- KR2: Reduce time-to-first-value from 10 min to 3 min
- KR3: Ship 5 onboarding experiments (3 winners)

**Roadmap items:**
- Redesign onboarding flow (remove 2 steps)
- Add interactive product tour
- Pre-populate example data for new users
- A/B test social login
- Send Day 1 activation email

### Quarterly Planning Process

**Week 1: Reflect**
- Review last quarter's OKRs (what hit, what missed)
- Analyze product health metrics (retention, churn, NPS)
- Collect feature requests from users (Canny votes, support tickets)

**Week 2: Prioritize**
- Score all ideas with ICE or RICE
- Map top 10 ideas to strategic pillars (from Product Strategy doc)
- Draft OKRs for next quarter

**Week 3: Build Roadmap**
- Break OKRs into initiatives
- Estimate effort (T-shirt sizes: S/M/L)
- Sequence by dependency + impact

**Week 4: Communicate**
- Publish roadmap (Notion, Canny, or public changelog)
- Announce in product (in-app banner: "What's coming in Q2")
- Email power users: "Here's what we're building next"

---

## 8. Product Health Metrics Dashboard

### Core Metrics to Track

**Acquisition:**
- Signups per week
- Traffic sources (organic, paid, referral)
- Signup conversion rate (visitor → signup)

**Activation:**
- % of signups who complete onboarding
- Time to first value (median)
- Day 1 retention

**Retention:**
- Day 7, Day 30, Day 90 retention
- Weekly Active Users (WAU)
- Monthly Active Users (MAU)

**Revenue:**
- Monthly Recurring Revenue (MRR)
- Customer Lifetime Value (LTV)
- Customer Acquisition Cost (CAC)
- LTV:CAC ratio (target: 3:1 or higher)

**Satisfaction:**
- NPS score (track quarterly)
- Support ticket volume
- Churn rate (% of users who cancel per month)

### Dashboard Stack (Solo PM)

**Option 1: All-in-One Analytics**
- **Mixpanel** ($25/mo) — events, cohorts, funnels, retention
- **Amplitude** (free tier) — similar to Mixpanel, generous free tier

**Option 2: DIY (SQL + Metabase)**
- **Metabase** (free, self-hosted) — SQL → dashboards
- **PostgreSQL** (your app DB) — run queries directly
- **cron job** → pre-compute metrics daily (cache in `metrics` table)

**Option 3: Spreadsheet (scrappy)**
- Weekly manual export from DB
- Google Sheets with pivot tables + charts
- Not scalable, but works for first 100 users

### Example Metabase Dashboard

**Query: Weekly Retention Cohorts**
```sql
-- See section 4 for full SQL
```

**Query: MRR Growth**
```sql
SELECT 
  DATE_TRUNC('month', subscription_start) AS month,
  SUM(monthly_price) AS mrr
FROM subscriptions
WHERE status = 'active'
GROUP BY month
ORDER BY month;
```

---

## 9. Tools & Stack Recommendations

### Feedback & User Research

| Tool | Use Case | Pricing | Recommendation |
|------|----------|---------|----------------|
| **Canny** | Feature requests + voting | $79/mo | Best for solo PMs |
| **UserVoice** | Enterprise feedback | $699/mo | Overkill, skip |
| **Hotjar** | Heatmaps + feedback widget | $39/mo | Good for behavior analysis |
| **Grain** | Interview transcription | $19/mo | Must-have for user interviews |
| **Calendly** | Schedule interviews | Free | Essential |

### Analytics

| Tool | Use Case | Pricing | Recommendation |
|------|----------|---------|----------------|
| **Mixpanel** | Event tracking, cohorts | $25/mo | Best for SaaS |
| **Amplitude** | Product analytics | Free tier | Great free option |
| **PostHog** | Open-source analytics | Free (self-host) | DIY, privacy-friendly |
| **Metabase** | SQL dashboards | Free | Pair with your DB |

### Experimentation (A/B Testing)

| Tool | Use Case | Pricing | Recommendation |
|------|----------|---------|----------------|
| **GrowthBook** | Open-source A/B testing | Free (self-host) | Best for solo devs |
| **LaunchDarkly** | Feature flags + A/B tests | $75/mo | Overkill, use GrowthBook |
| **Optimizely** | Enterprise A/B testing | $$$$ | Skip |
| **DIY** | Custom feature flags | Free | Simple: `if (user.id % 2 == 0)` |

### NPS & Surveys

| Tool | Use Case | Pricing | Recommendation |
|------|----------|---------|----------------|
| **Delighted** | Automated NPS | $49/mo | Set it and forget it |
| **Refiner** | In-app surveys | $79/mo | Good for micro-surveys |
| **Typeform** | Custom surveys | $35/mo | Use for exit interviews |

---

## Summary Checklist

**Weekly:**
- [ ] Review 1-2 experiment results
- [ ] Ship 1 new growth experiment
- [ ] Check product health dashboard (retention, MRR, churn)

**Monthly:**
- [ ] Deep-dive on one metric (retention, activation, or churn)
- [ ] Conduct 2-3 user interviews
- [ ] Review NPS feedback
- [ ] Update growth experiment backlog (ICE scores)

**Quarterly:**
- [ ] Reflect on last quarter's OKRs
- [ ] Set next quarter's OKRs
- [ ] Refresh product roadmap
- [ ] Communicate roadmap to users

---

**Next Steps:**
1. Set up basic product health dashboard (Mixpanel or Amplitude)
2. Implement cohort retention tracking (SQL query)
3. Add NPS survey (trigger at Day 7)
4. Create growth experiment backlog (start with ICE scoring)
5. Schedule first 3 user interviews

**Questions?** Reference the [Product Operations module (M13)](../../modules/13-product-operations-iteration.md) for more context.
