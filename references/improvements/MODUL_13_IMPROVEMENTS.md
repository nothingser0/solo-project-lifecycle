# Modul 13 Improvements: Product Operations & Continuous Iteration

## 1. Timeline Estimation (by Project Scale)

| Phase | Kecil (MVP) | Menengah (SaaS) | Besar | Enterprise |
|-------|-------------|-----------------|-------|-----------|
| Metrics Baseline Collection (30 days data) | 4 jam | 8 jam | 16 jam | 32 jam |
| Feedback Loop Setup (NPS + Widget) | 3 jam | 6 jam | 12 jam | 24 jam |
| Cohort Analysis Setup (SQL + Dashboard) | 4 jam | 8 jam | 16 jam | 32 jam |
| RICE Framework Backlog Prioritization | 2 jam | 4 jam | 8 jam | 16 jam |
| Growth Experiments Setup (Hypothesis Template) | 2 jam | 4 jam | 8 jam | 16 jam |
| Product Health Dashboard Setup | 3 jam | 6 jam | 12 jam | 24 jam |
| Scaling Monitoring Setup (Performance + Cost) | 2 jam | 4 jam | 8 jam | 16 jam |
| **INITIAL SETUP TIME** | **20 jam** | **40 jam** | **80 jam** | **160 jam** |
| **ONGOING MAINTENANCE** (per month) | **4-6 jam** | **8-12 jam** | **16-24 jam** | **32-48 jam** |

### Assumptions
- Initial setup = one-time infrastructure (dashboards, SQL queries, templates)
- Ongoing maintenance = weekly metrics review (15 min) + monthly OKR check-in (1 jam) + experiment launches (2-4 per month)
- Experiment time = 2-4 jam per experiment (hypothesis → implement → launch)

### Bottlenecks
- Data integration: +4-8 jam (if analytics not implemented in Modul 06B)
- Dashboard tool learning curve: +4-8 jam (first-time Mixpanel/Posthog setup)
- SQL query optimization: +2-4 jam (complex cohort analysis for large datasets)

---

## 2. Metrics Dashboard Tool Recommendations

### Problem
Modul 13 mentions "dashboard" but no concrete tool recommendations by budget/scale.

### Solution: Tool Matrix by Budget & Complexity

---

### Option A: Free Tier Tools (Rp 0/bulan, Good for MVP)

#### 1. **Posthog (Open Source Self-Hosted)**

**Pros**:
- Free unlimited events (self-hosted)
- Built-in feature flags, A/B testing, session recording
- SQL query builder for custom cohorts
- No vendor lock-in

**Cons**:
- Requires Docker + 2GB RAM server (Rp 100-200k/bulan hosting)
- Setup complexity (~4 jam initial setup)

**Setup**:
```bash
# Deploy via Docker Compose
git clone https://github.com/PostHog/posthog.git
cd posthog
docker compose -f docker-compose.yml up -d

# Access: http://localhost:8000
# Default user: admin / password (change immediately)
```

**Integration** (Next.js):
```typescript
// lib/posthog.ts
import posthog from 'posthog-js';

if (typeof window !== 'undefined') {
  posthog.init('YOUR_PROJECT_API_KEY', {
    api_host: 'https://posthog.yourserver.com'
  });
}

// Track event
posthog.capture('user_signed_up', {
  plan: 'free',
  referral_source: 'google'
});
```

**Best For**: Developers comfortable with self-hosting, privacy-conscious projects.

---

#### 2. **Google Analytics 4 (GA4) + Looker Studio**

**Pros**:
- 100% free (Google account only)
- Looker Studio = free BI dashboards (drag-drop)
- Integration with Google Ads (if running ads)

**Cons**:
- Limited cohort analysis (not as flexible as Mixpanel)
- Event tracking requires manual GTM setup
- Data sampling on high-traffic sites

**Setup**:
```html
<!-- Add GA4 tag to app -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>
```

**Looker Studio Dashboard**:
1. Go to https://lookerstudio.google.com
2. Create Data Source → Google Analytics
3. Drag-drop widgets: Users over time, Conversion funnel, Retention cohorts

**Best For**: Non-technical stakeholders, visual reports, integration with Google ecosystem.

---

#### 3. **Plausible Analytics (€9/month, Privacy-Focused)**

**Pros**:
- No cookies, GDPR-compliant
- Lightweight script (<1KB)
- Simple dashboard (pageviews, referrers, goals)

**Cons**:
- No cohort analysis, A/B testing, or advanced segmentation
- Limited to web analytics (no custom events)

**Best For**: Simple landing pages, blogs, privacy-first projects.

---

### Option B: Paid Tools (Rp 500k - 1.5 jt/bulan, Good for SaaS)

#### 1. **Mixpanel (Starts $20/month for 100k MTU)**

**Pros**:
- Industry standard for product analytics
- Built-in retention, funnel, cohort analysis
- A/B testing + feature flags
- No SQL required (visual query builder)

**Cons**:
- Price scales with Monthly Tracked Users (MTU)
- Steep learning curve for advanced features

**Setup**:
```typescript
// lib/mixpanel.ts
import mixpanel from 'mixpanel-browser';

mixpanel.init('YOUR_PROJECT_TOKEN', {
  track_pageview: true,
  persistence: 'localStorage'
});

// Track event
mixpanel.track('Feature Used', {
  feature_name: 'Export PDF',
  user_tier: 'premium'
});

// Identify user
mixpanel.identify(user.id);
mixpanel.people.set({
  $email: user.email,
  plan: user.plan
});
```

**Pricing**:
- Free: 20M events/month (unlimited users)
- Growth: $20/month (100k MTU)
- Enterprise: Custom pricing

**Best For**: B2B SaaS, mobile apps, growth-focused teams.

---

#### 2. **Amplitude (Free for 10M events/month)**

**Pros**:
- Free tier generous (10M events)
- Behavioral cohorts (e.g., "users who completed onboarding but didn't activate")
- Predictive analytics (churn risk scoring)

**Cons**:
- UI complexity (steeper learning curve than Mixpanel)
- Advanced features require paid plan

**Best For**: Data-driven teams, churn prediction, large user base.

---

#### 3. **June.so ($99/month, Built for SaaS)**

**Pros**:
- Pre-built SaaS dashboards (activation, retention, MRR)
- Auto-generated reports (no SQL or config)
- Beautiful UI (designed for founders)

**Cons**:
- Fixed price (not usage-based)
- Limited customization vs Mixpanel

**Best For**: Solo founders who want plug-and-play analytics.

---

### Option C: Enterprise Tools (Rp 10-50 jt/bulan, Good for Scale)

#### 1. **Segment (Data Pipeline) + Warehouse**

**Setup**:
- Segment: $120/month (collects events from all sources)
- BigQuery/Snowflake: ~$500/month (data warehouse)
- Looker/Metabase: $500/month (BI tool)

**Pros**:
- Single API, sends data to all tools (Mixpanel, GA, Salesforce)
- Full data ownership (warehouse)
- Unlimited custom queries (SQL)

**Cons**:
- Complex setup (data engineer recommended)
- High cost

**Best For**: Enterprise with multiple tools, need data unification.

---

### Tool Recommendation Matrix

| Project Scale | Users | Budget | Recommended Tool | Why |
|--------------|-------|--------|------------------|-----|
| **MVP/Small** | <1k MAU | Rp 0 | Posthog (self-host) | Free, full-featured, self-hosted |
| **Small** | <5k MAU | Rp 0 | GA4 + Looker Studio | Free, easy setup, visual reports |
| **Medium** | 5k-50k MAU | Rp 500k-1.5jt | Mixpanel Growth | Industry standard, rich cohorts |
| **Large** | 50k-500k MAU | Rp 1.5-5jt | Amplitude | Predictive analytics, generous free tier |
| **Enterprise** | >500k MAU | Rp 10-50jt | Segment + Warehouse | Data ownership, multi-tool integration |

---

### Setup Priority (First 30 Days)

**Week 1**: Basic tracking
- [ ] Install analytics SDK (Posthog/Mixpanel/GA4)
- [ ] Track 5 core events: signup, login, feature_used, payment, churn
- [ ] Verify events in dashboard (test mode)

**Week 2**: Cohort analysis
- [ ] Setup user properties (plan, signup_date, referral_source)
- [ ] Create first retention cohort (Day 1/7/30)
- [ ] Setup automated cohort report (weekly email)

**Week 3**: Dashboards
- [ ] Create Product Health Dashboard (Looker Studio/Mixpanel)
- [ ] Add 5 key metrics: DAU, activation rate, retention, MRR, churn
- [ ] Share dashboard link with stakeholders

**Week 4**: Alerts
- [ ] Setup anomaly alerts (DAU drop >30%)
- [ ] Setup Sentry integration (error spike alerts)
- [ ] Test alert triggers (simulate anomaly)

---

## 3. Experiment Documentation Template

### Problem
Modul 13 mentions documenting experiments but no structured template.

### Solution: Standardized Experiment Doc Format

---

### Template: `docs/experiments/YYYY-MM-experiment-NNN-title.md`

```markdown
# Experiment NNN: [Title]

**Status**: [DRAFT / RUNNING / COMPLETED / KILLED]  
**Owner**: [Dev Name]  
**Start Date**: YYYY-MM-DD  
**End Date**: YYYY-MM-DD (or "Ongoing")  
**Priority**: [P0: Critical / P1: High / P2: Medium / P3: Low]

---

## 1. Hypothesis

**Template**:
```
We believe that [CHANGE]
will result in [IMPACT]
for [TARGET SEGMENT]
because [RATIONALE].

We will measure success by [METRIC DEFINITION & THRESHOLD].
```

**Example**:
```
We believe that adding a progress bar to the onboarding flow
will result in 20% increase in onboarding completion rate
for new users in their first session
because progress indicators reduce perceived effort and increase commitment (Zeigarnik effect).

We will measure success by tracking "onboarding_completed" event within 1 hour of signup, comparing treated vs control cohorts.
```

---

## 2. Background & Context

**Why This Experiment?**
- Current problem: Only 45% of signups complete onboarding (industry benchmark: 60-70%)
- User feedback: "Tidak tahu berapa langkah lagi" (user interviews, 3 mentions)
- Opportunity size: 500 signups/month × 20% lift = +100 activated users/month

**Related Experiments**:
- Experiment 012: Simplified onboarding (failed: no impact on completion)
- Experiment 018: Gamified badges (success: +12% completion)

---

## 3. Experiment Design

### Variants

| Variant | Description | Screenshot/Mockup |
|---------|-------------|-------------------|
| **Control (A)** | Current onboarding (no progress bar) | [Link to screenshot] |
| **Treatment (B)** | Onboarding with progress bar (5 steps) | [Link to Figma mockup] |

### Segmentation & Sample Size

**Target Segment**: All new signups (web + mobile)  
**Exclusions**: Returning users, admin accounts  
**Sample Size**:
- Control: 50% of new signups (~250 users/month)
- Treatment: 50% of new signups (~250 users/month)

**Statistical Power**:
- Baseline conversion: 45%
- Expected lift: +20% relative (45% → 54%)
- Minimum detectable effect: 9 percentage points
- Required sample size: 194 per variant (calculated via Evan's Awesome A/B Tools)
- Expected duration: 4 weeks to reach 250 per variant

### Implementation

**Technical Changes**:
- Add `ProgressBar` component to onboarding layout
- Track current step in `onboarding_progress` state
- Update Mixpanel event: `onboarding_step_completed(step_number)`

**Feature Flag**:
```typescript
// lib/features.ts
import { useFeatureFlag } from '@posthog/react';

export function useOnboardingProgressBar() {
  const isEnabled = useFeatureFlag('onboarding-progress-bar');
  return isEnabled;
}

// Usage in component
function OnboardingLayout() {
  const showProgressBar = useOnboardingProgressBar();
  
  return (
    <div>
      {showProgressBar && <ProgressBar currentStep={step} totalSteps={5} />}
      {/* rest of onboarding */}
    </div>
  );
}
```

**Rollout Plan**:
1. Week 1: 10% traffic (canary test)
2. Week 2: 50% traffic (full A/B test)
3. Week 3-4: Monitor results
4. Week 5: Decide (ship 100% or kill)

---

## 4. Success Metrics

### Primary Metric

**Metric**: Onboarding Completion Rate (within 1 hour of signup)

**Definition**:
```sql
-- Onboarding completion rate
SELECT 
  variant,
  COUNT(DISTINCT user_id) as total_users,
  COUNT(DISTINCT CASE WHEN onboarding_completed_at IS NOT NULL THEN user_id END) as completed_users,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN onboarding_completed_at IS NOT NULL THEN user_id END) / COUNT(DISTINCT user_id), 2) as completion_rate_pct
FROM experiment_users
WHERE experiment_name = 'onboarding-progress-bar'
  AND created_at >= '2026-09-01'
GROUP BY variant;
```

**Success Threshold**: 
- Statistical significance: p-value < 0.05 (95% confidence)
- Practical significance: Lift > +15% relative (worth shipping)

---

### Secondary Metrics

| Metric | Why Track | Definition |
|--------|-----------|------------|
| **Time to Complete Onboarding** | Check if progress bar speeds up or slows down flow | Median time from first step to completion |
| **Drop-off per Step** | Identify which step loses most users | % users who abandon at each step |
| **Day 7 Retention** | Ensure onboarding quality (not just speed) | % users active 7 days after signup |

---

### Guardrail Metrics (Should NOT Degrade)

- Page load time: Should stay <2s (progress bar adds minimal JS)
- Error rate: Should stay <0.5% (no new bugs introduced)
- Mobile completion rate: Should not drop (ensure mobile UI tested)

---

## 5. Results

### Quantitative Results

**Data Collection Period**: 2026-09-01 to 2026-09-28 (4 weeks)

| Variant | Users | Completed | Completion Rate | Lift vs Control | P-Value |
|---------|-------|-----------|-----------------|-----------------|---------|
| **Control (A)** | 512 | 231 | 45.1% | — | — |
| **Treatment (B)** | 498 | 279 | 56.0% | **+24.2%** | **0.003** ✅ |

**Statistical Significance**: p < 0.05 ✅ (experiment succeeded)

**Secondary Metrics**:
- Time to Complete: Control 8.3 min → Treatment 7.1 min (faster)
- Drop-off Step 3: Control 18% → Treatment 12% (improved)
- Day 7 Retention: Control 42% → Treatment 44% (neutral, no degradation)

**Guardrail Metrics**:
- Page load time: 1.8s (no change)
- Error rate: 0.3% (no change)
- Mobile completion: 41% → 52% (improved!)

---

### Qualitative Feedback

**User Interviews** (5 users from treatment group):
- ✅ "Progress bar bikin lebih jelas berapa langkah lagi" (clarity)
- ✅ "Gak berasa lama karena tahu progres" (perceived speed)
- ⚠️ "Step 3 masih agak membingungkan" (opportunity for next experiment)

**Support Tickets**:
- No increase in onboarding-related tickets (neutral)

---

## 6. Decision & Learnings

### Decision

**✅ SHIP TO 100%**

**Reasoning**:
- Clear statistical win (+24% lift, p=0.003)
- Secondary metrics positive (faster, less drop-off)
- No guardrail degradation (performance, errors)
- Aligns with strategic goal (increase activation from 45% to 60%)

**Rollout Date**: 2026-10-01 (ship to all users)

---

### Learnings

**What Worked**:
- Progress indicator reduced uncertainty → higher completion
- Mobile users benefited even more than desktop (+27% lift on mobile vs +22% desktop)
- Simple UI change, big impact (80/20 principle)

**What Didn't Work**:
- N/A (experiment succeeded)

**Opportunities for Next Experiment**:
- Step 3 still has highest drop-off (18% → 12%, but still highest) → investigate UX
- Experiment 025: Add contextual help tooltips on Step 3

---

### Follow-Up Actions

- [ ] Remove feature flag, deploy to 100% (2026-10-01)
- [ ] Update onboarding metrics baseline (new baseline: 56%)
- [ ] Document progress bar pattern in design system (reusable component)
- [ ] Plan Experiment 025 (Step 3 tooltips)

---

## 7. Attachments

- [Figma Mockup: Progress Bar Design](https://figma.com/file/...)
- [Analytics Dashboard: Experiment Results](https://mixpanel.com/...)
- [Code PR: Feature Implementation](https://github.com/org/repo/pull/123)
- User Interview Notes: `docs/research/onboarding-interviews-sept-2026.md`

---

## 8. Changelog

| Date | Event | Notes |
|------|-------|-------|
| 2026-08-15 | Hypothesis drafted | Initial planning |
| 2026-08-22 | Design completed | Figma mockup approved |
| 2026-09-01 | Experiment launched | 10% canary |
| 2026-09-08 | Scaled to 50% | Full A/B test |
| 2026-09-28 | Data collection complete | 4 weeks, 1010 users |
| 2026-09-29 | Analysis completed | +24% lift, p=0.003 |
| 2026-09-30 | Decision: SHIP | Rollout to 100% on Oct 1 |
| 2026-10-01 | Shipped to 100% | Feature flag removed |
```

---

### Experiment Status Definitions

| Status | Definition | Next Action |
|--------|-----------|-------------|
| **DRAFT** | Hypothesis written, design in progress | Complete design, get approval |
| **RUNNING** | Experiment live, collecting data | Monitor daily, wait for sample size |
| **COMPLETED** | Data collected, analysis done, decision made | Ship to 100% or kill |
| **KILLED** | Experiment failed or deprioritized | Document learnings, archive |

---

### Experiment Naming Convention

```
YYYY-MM-experiment-NNN-short-title.md
```

**Examples**:
- `2026-09-experiment-024-onboarding-progress-bar.md`
- `2026-10-experiment-025-step-3-help-tooltips.md`
- `2026-11-experiment-026-pricing-page-social-proof.md`

**NNN** = Sequential number (pad with zeros: 001, 002, ..., 099, 100)

---

### Experiment Backlog Tracking

**Use `docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md`**:

```markdown
# Growth Experiments Backlog

## Active Experiments (RUNNING)

| ID | Title | Owner | Start | Expected End | Status |
|----|-------|-------|-------|--------------|--------|
| 024 | Onboarding Progress Bar | Dev | 2026-09-01 | 2026-09-28 | Analyzing |

## Planned (DRAFT)

| ID | Title | RICE Score | Priority | Owner | Estimated Start |
|----|-------|------------|----------|-------|-----------------|
| 025 | Step 3 Help Tooltips | 180 | P1 | Dev | 2026-10-08 |
| 026 | Pricing Page Social Proof | 240 | P0 | Dev | 2026-10-01 |

## Completed

| ID | Title | Result | Lift | Decision | Ship Date |
|----|-------|--------|------|----------|-----------|
| 024 | Onboarding Progress Bar | ✅ Win | +24% | Shipped | 2026-10-01 |
| 023 | Email Drip Sequence | ❌ Neutral | -2% | Killed | N/A |
| 022 | Dark Mode | ✅ Win | +8% engagement | Shipped | 2026-08-15 |
```

---

### Experiment Documentation Checklist

- [ ] Hypothesis clearly stated (change → impact → segment → rationale)
- [ ] Background explains WHY (problem size, user feedback, opportunity)
- [ ] Variants defined (control vs treatment, screenshots/mockups)
- [ ] Sample size calculated (statistical power, duration estimate)
- [ ] Success metrics defined (primary + secondary + guardrails)
- [ ] Implementation planned (feature flag, rollout %)
- [ ] Results recorded (quantitative + qualitative + p-value)
- [ ] Decision made (ship/kill/iterate) with reasoning
- [ ] Learnings documented (what worked, what didn't, next steps)
- [ ] Follow-up actions tracked (remove flag, update baseline, new experiment)
