# PM Analytics Setup Guide for Solo Developers

Tactical guide for solo developers and PMs who need data-driven decision making without drowning in excessive analytics. Focus: **Minimal Viable Analytics** for validating product-market fit.

---

## 1. Analytics Philosophy for Solo Devs

**Core Principles**:
1. **Track Less, Learn More**: 10 well-understood core events > 100 random events
2. **Free Tier First**: Use free tiers until PMF is reached (Mixpanel's 100K events/month is sufficient for 500 MAU)
3. **Privacy by Default**: GDPR/UU PDP compliance is not optional; it is mandatory from day one
4. **Dashboard as Compass**: North Star Metric must be visible within 3 seconds
5. **No Vendor Lock-In**: Wrapper abstraction (`lib/analytics.ts`) for easy platform migration

---

## 2. Platform Selection Decision Tree

```text
START: What's your primary goal?
│
├─ [Web Traffic & SEO Attribution]
│   └─► Google Analytics 4 (GA4)
│       ✅ Free unlimited
│       ✅ Best for content marketing
│       ❌ Weak product analytics
│
├─ [Funnel Analysis & Retention Cohorts]
│   └─► Mixpanel or Amplitude
│       Mixpanel: ✅ Better funnel visualization, 100K events free
│       Amplitude: ✅ 10M events free, better for mobile apps
│
├─ [Privacy-First / Self-Hosted]
│   └─► PostHog
│       ✅ Session replay + feature flags + analytics in one
│       ✅ 1M events free (cloud) or unlimited (self-hosted)
│       ❌ Self-hosted overhead (Docker, Postgres, ClickHouse)
│
└─ [Multi-Tool Data Warehouse (Advanced)]
    └─► Segment.io as CDP
        ✅ Send events to multiple destinations (Mixpanel + Amplitude + Slack)
        ❌ $120/mo minimum, overkill for solo devs
```

**Default Recommendation for Medium-Scale Solo Devs**:
```
Mixpanel (product analytics) + GA4 (acquisition) + Sentry (errors)
Total cost: $0/month up to >500 MAU
```

---

## 3. The 5 Core Metrics (Minimal Viable Analytics)

Don't track everything. Start with these 5 metrics:

| Metric | Definition | Why It Matters | How to Track |
|--------|------------|----------------|--------------|
| **1. Signups per Week** | New accounts created | Top of funnel health | Event: `complete_signup` |
| **2. Activation Rate** | % signups who reach "aha moment" | True product validation | Funnel: `complete_signup` → `activate_account` |
| **3. Weekly Retention (W1)** | % users active 7 days after signup | Product stickiness | Cohort analysis in Mixpanel |
| **4. North Star Metric** | Core value delivery metric | Business compass | Custom event (e.g., `upload_document`) |
| **5. Error Rate** | % events that are errors | System reliability | Event count: `error_*` / total events |

**Action Triggers**:
- Signups dropping >30% week-over-week → Investigate acquisition channel
- Activation rate <20% → Onboarding is broken, fix before scaling
- W1 retention <40% → Product-market fit not yet achieved
- Error rate >5% → Critical engineering issue

---

## 4. Event Taxonomy Quickstart

### The Verb-Noun Convention

**Format**: `verb_noun` (lowercase, underscore)

**Why?**
- Consistency: Easy to filter in Mixpanel (`view_*`, `error_*`)
- Readability: Self-documenting
- Scalability: 100 events stay organized

**Examples**:
```typescript
// ✅ CORRECT
analytics.track('view_page', { page_name: 'dashboard' })
analytics.track('click_button', { button_id: 'export_pdf' })
analytics.track('complete_signup', { method: 'google' })
analytics.track('error_payment_failed', { error_code: 'card_declined' })

// ❌ WRONG
analytics.track('Dashboard Viewed')          // Space, title case
analytics.track('buttonClick')               // camelCase
analytics.track('signup_complete')           // Noun-verb order
```

### Prioritized Event List (Track in This Order)

**Week 1: Conversion Funnel (Priority 1)**
```typescript
track('start_signup', { signup_method: 'email' })
track('complete_signup', { user_id, signup_method })
track('complete_onboarding', { steps_completed: 3 })
track('activate_account', { first_action: 'upload_document' })
```

**Week 2: Engagement (Priority 2)**
```typescript
track('view_page', { page_name: 'dashboard' })
track('click_button', { button_id: 'share', screen: 'document_detail' })
track('upload_file', { file_type: 'pdf', file_size_kb: 250 })
```

**Week 3: Errors (Priority 3)**
```typescript
track('error_payment_failed', { error_code, amount_usd })
track('error_upload_timeout', { file_size_kb })
track('error_api_failure', { endpoint: '/api/documents', status_code: 500 })
```

---

## 5. Implementation Checklist (Copy-Paste for PM/Dev)

### Pre-Implementation (1 hour)
- [ ] Define North Star Metric (1 metric reflecting true user value)
- [ ] List 5 core events (signup, activation, retention anchor, engagement, error)
- [ ] Create Mixpanel account (free tier)
- [ ] Get project token from Mixpanel settings

### Development (4 hours)
- [ ] Install SDK: `pnpm add mixpanel-browser`
- [ ] Create `lib/analytics.ts` wrapper (copy from template)
- [ ] Add environment variable: `NEXT_PUBLIC_MIXPANEL_TOKEN`
- [ ] Initialize in root layout: `analytics.init()`
- [ ] Track 5 core events (signup, activation, page view, button click, error)

### GDPR Compliance (2 hours)
- [ ] Create cookie consent banner component
- [ ] Disable tracking until consent granted
- [ ] Add opt-out page: `/privacy/opt-out`
- [ ] Anonymize IPs: `mixpanel.init({ ip: false })`

### QA & Verification (1 hour)
- [ ] Test in Mixpanel Live View (real-time event stream)
- [ ] Verify user identification works (check user profile)
- [ ] Trigger test errors, check error events fire
- [ ] Confirm consent banner works (accept/decline)

### Dashboard Setup (2 hours)
- [ ] Create Mixpanel board: "Executive Overview"
- [ ] Add North Star Metric (line chart)
- [ ] Add funnel: Signup → Activation
- [ ] Add retention cohort heatmap
- [ ] Set alert: Activation rate <20% for 48h

**Total Time**: ~10 hours for full analytics setup

---

## 6. Common Pitfalls & How to Avoid Them

| ❌ Anti-Pattern | 🚨 Why It's Bad | ✅ Correct Approach |
|----------------|----------------|---------------------|
| Track everything "just in case" | Drowns signal in noise, expensive | Start with 5 core events, add only when needed |
| Inconsistent naming (camelCase + snake_case) | Breaks filtering, hard to maintain | Enforce `verb_noun` via runtime validation |
| No user properties | Can't segment cohorts, limited insights | Set user traits on signup: `plan_type`, `signup_date` |
| Skip GDPR consent | Legal risk (UU PDP fines up to Rp 6M) | Consent banner before any tracking |
| Analytics in 50+ files | Hard to debug, circular dependencies | Centralize in `lib/analytics.ts` |
| Ignore statistical significance | False conclusions from A/B tests | Minimum 385 users/variant, 7 days runtime |
| Use production token in dev | Pollutes production data | Separate tokens: dev/staging/prod |

---

## 7. Solo Dev Dashboard Design (Single Screen)

**Goal**: Founder/PM can answer "How's the business?" within 10 seconds.

**Layout (Mixpanel Board)**:
```
┌─────────────────────────────────────────────────────────┐
│  NORTH STAR METRIC                                      │
│  Weekly Active Documents: 127 (↑ 18% vs last week)     │
│  [Line chart: 12-week trend]                            │
└─────────────────────────────────────────────────────────┘

┌──────────────┬──────────────┬──────────────┬───────────┐
│ New Signups  │ Activation   │ W1 Retention │    MRR    │
│     42       │     38%      │     45%      │  $1,240   │
│  (↑ 12%)     │  (↓ 5%)      │  (↑ 3%)      │ (↑ 22%)   │
└──────────────┴──────────────┴──────────────┴───────────┘

┌─────────────────────────────────────────────────────────┐
│  CONVERSION FUNNEL                                      │
│  Signup (100%) → Onboarding (72%) → First Upload (38%) │
│  [Funnel visualization]                                 │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│  ERRORS (Last 7 Days)                                   │
│  • error_payment_failed: 3 occurrences (2 users)        │
│  • error_upload_timeout: 1 occurrence (1 user)          │
└─────────────────────────────────────────────────────────┘
```

**Update Frequency**: Real-time (Mixpanel auto-refreshes)

---

## 8. A/B Testing Framework (Feature Flags)

### When to Run A/B Tests?
- ✅ Onboarding flow changes (high impact on activation)
- ✅ Pricing page variations (direct revenue impact)
- ✅ New feature rollout (measure adoption before full release)
- ❌ Color tweaks (not worth statistical overhead for solo dev)

### Statistical Significance Calculator

**Formula**:
```
Minimum sample size per variant = (1.96² × 0.5 × 0.5) / 0.05²
                                 ≈ 385 users per variant
```

**Runtime**: Minimum 7 days (to capture weekly behavior patterns)

**Interpretation**:
- p < 0.05: Significant result (95% confidence)
- p < 0.01: Highly significant (99% confidence)
- p > 0.05: Inconclusive (need more data or no real difference)

### Tool: PostHog Feature Flags + Analytics

**Why PostHog for A/B Testing?**
- Feature flags + analytics in a single platform
- Free tier: 1M events/month
- Built-in statistical significance calculator

**Implementation**:
```typescript
// lib/posthog.ts
import posthog from 'posthog-js'

posthog.init(process.env.NEXT_PUBLIC_POSTHOG_KEY!)

export const useFeatureFlag = (flagKey: string) => {
  return posthog.isFeatureEnabled(flagKey)
}

// Usage in component
const newOnboardingEnabled = useFeatureFlag('new_onboarding_flow')

if (newOnboardingEnabled) {
  return <NewOnboardingFlow />
} else {
  return <OldOnboardingFlow />
}
```

---

## 9. Error Monitoring Integration (Sentry)

**Why Separate Error Tracking from Product Analytics?**
- Sentry: Engineering-focused (stack traces, release tracking, performance)
- Mixpanel: Product-focused (user behavior, funnels, cohorts)

**Setup (5 minutes)**:
```bash
pnpm add @sentry/nextjs
npx @sentry/wizard@latest -i nextjs
```

**Key Features for Solo Dev**:
1. **Error Grouping**: Auto-groups similar errors (avoid alert spam)
2. **Release Tracking**: Tag errors by git commit (know which deploy broke)
3. **Performance Monitoring**: Slow API endpoints flagged automatically
4. **Session Replay**: Watch user session before error occurred

**Alert Rules**:
```
Severity 1 (P0): Error rate > 5% in 10 minutes → SMS + Slack
Severity 2 (P1): New error type affecting > 10 users → Email
Severity 3 (P2): Performance regression > 50% → Dashboard only
```

---

## 10. Privacy Compliance Deep Dive (GDPR & UU PDP)

### UU PDP No. 27/2022 (Indonesia)

**Key Requirements**:
1. **Explicit Consent**: User must actively consent (not a pre-checked checkbox)
2. **Data Minimization**: Only track data essential for operations
3. **Right to Erasure**: Users can request data deletion
4. **Data Breach Notification**: Mandatory reporting to authorities within 3x24 hours

**Penalties**: Fines up to Rp 6 billion or 2% of annual turnover

### Implementation Checklist

- [ ] **Consent Banner**: Explicit opt-in before analytics activates
- [ ] **Privacy Policy**: Document explaining what data is collected
- [ ] **Opt-Out URL**: `/privacy/opt-out` to revoke consent
- [ ] **IP Anonymization**: `mixpanel.init({ ip: false })`
- [ ] **Data Retention**: Auto-delete events older than 2 years
- [ ] **No Sensitive Data**: Never track passwords, credit cards, national ID (NIK/KTP)

### Consent Banner Code (Copy-Paste)

```typescript
// components/cookie-consent.tsx
'use client'

import { useState, useEffect } from 'react'
import { analytics } from '@/lib/analytics'

export function CookieConsent() {
  const [show, setShow] = useState(false)

  useEffect(() => {
    const consent = localStorage.getItem('analytics_consent')
    if (!consent) setShow(true)
    else if (consent === 'granted') analytics.init()
  }, [])

  const grant = () => {
    localStorage.setItem('analytics_consent', 'granted')
    setShow(false)
    analytics.init()
  }

  const deny = () => {
    localStorage.setItem('analytics_consent', 'denied')
    setShow(false)
  }

  if (!show) return null

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-zinc-900 text-white p-4 z-50">
      <div className="max-w-6xl mx-auto flex items-center justify-between">
        <p>We use cookies to improve your experience. See our Privacy Policy.</p>
        <div className="space-x-2">
          <button onClick={grant} className="bg-white text-black px-4 py-2 rounded">
            Accept
          </button>
          <button onClick={deny} className="border border-white px-4 py-2 rounded">
            Decline
          </button>
        </div>
      </div>
    </div>
  )
}
```

---

## 11. Cost Optimization (Free Tier Longevity)

### Event Volume Estimation

**Formula**:
```
Monthly events = MAU × (avg events per user per session) × (avg sessions per month)

Example:
100 MAU × 20 events/session × 8 sessions/month = 16,000 events/month
```

**Mixpanel Free Tier**: 100K events/month → Supports ~625 MAU at 160 events/user/month

### Cost Scaling Trigger Points

| MAU Range | Expected Monthly Events | Platform Cost |
|-----------|------------------------|---------------|
| 0-500 | <80K | $0 (free tier) |
| 500-1K | 80K-160K | $25/mo (Mixpanel Growth plan) |
| 1K-5K | 160K-800K | $89/mo |
| 5K-10K | 800K-1.6M | $199/mo |

**Optimization Tips**:
1. **Don't track page views for every route**: Only critical pages (dashboard, pricing, signup)
2. **Sample non-critical events**: Track only 10% of `view_page` events after PMF
3. **Batch events**: Send events in batches (Mixpanel SDK does this automatically)
4. **Archive old data**: Export to CSV annually, reduce retention period

---

## 12. Monthly Maintenance Routine (30 minutes)

**Week 1: Audit Dead Events**
```bash
# Check Mixpanel → Insights → Event frequency report
# Find events with 0 triggers in last 30 days
# Remove tracking code for dead events
```

**Week 2: Review Missing Properties**
```bash
# Check Mixpanel → Events → Property completion rate
# Fix events with >50% missing properties
```

**Week 3: Dashboard Health Check**
```bash
# Confirm all charts loading correctly
# Update alert thresholds if baseline changed
# Add metrics for new features shipped
```

**Week 4: Cohort Analysis**
```bash
# Review retention heatmap
# Identify drop-off week (W1? W2? W4?)
# Plan interventions (email campaigns, feature improvements)
```

---

## 13. When to Upgrade Analytics Stack?

**Stick with Free Tier If**:
- <500 MAU
- <100K events/month
- Basic funnels and retention analysis sufficient

**Upgrade to Paid Plan When**:
- Need advanced features (SQL queries, custom dashboards, data warehouse export)
- Hit free tier limits consistently
- Need dedicated support (SLA guarantees)

**Consider Self-Hosted PostHog When**:
- >$500/mo analytics spend
- Privacy-critical industry (healthcare, finance)
- Need unlimited event volume

---

## 14. Quick Reference: Platform Comparison Table

| Feature | Mixpanel | Amplitude | PostHog | GA4 |
|---------|----------|-----------|---------|-----|
| **Free Tier** | 100K events/mo | 10M events/mo | 1M events/mo | Unlimited |
| **Funnel Analysis** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| **Retention Cohorts** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ |
| **A/B Testing** | ❌ (need 3rd party) | ❌ | ✅ Built-in | ✅ Limited |
| **Session Replay** | ❌ | ❌ | ✅ Built-in | ❌ |
| **Self-Hosted** | ❌ | ❌ | ✅ | ❌ |
| **Learning Curve** | Easy | Medium | Medium | Hard |
| **Best For** | Product analytics | Mobile apps | Privacy-first | Web traffic/SEO |

---

**Next Step**: Use the templates in `templates/09-product-growth/` to create EVENT_TAXONOMY.md, ANALYTICS_IMPLEMENTATION_PLAN.md, and DASHBOARD_SPEC.md documents for your project.
