# Analytics Implementation Plan

**Project**: [Project Name]  
**Platform**: [Mixpanel / Amplitude / PostHog / GA4]  
**Planned Start**: [YYYY-MM-DD]  
**Target Completion**: [YYYY-MM-DD]  
**Owner**: [Developer Name]

---

## 1. Platform Selection Rationale

**Chosen Platform**: Mixpanel

**Why Mixpanel?**
- Funnel analysis superior to GA4
- 100K events/month free tier sufficient for MVP
- User profile tracking (behavioral cohorting)
- Next.js SDK well-documented

**Alternatives Considered**:
- ❌ Amplitude: 10M free events but weaker funnel visualization
- ❌ PostHog: Self-hosted overhead not justified for solo dev
- ❌ GA4: Weak for product analytics, better for SEO/acquisition only

---

## 2. SDK Installation

### Step 1: Install Dependencies
```bash
pnpm add mixpanel-browser
pnpm add -D @types/mixpanel-browser
```

### Step 2: Environment Variables
Add to `.env.local` and `.env.example`:
```bash
NEXT_PUBLIC_MIXPANEL_TOKEN=your_project_token_here
NEXT_PUBLIC_ENABLE_ANALYTICS=true  # false in dev, true in prod
```

### Step 3: Create Analytics Wrapper
**File**: `lib/analytics.ts`

```typescript
import mixpanel from 'mixpanel-browser'

const MIXPANEL_TOKEN = process.env.NEXT_PUBLIC_MIXPANEL_TOKEN
const ANALYTICS_ENABLED = process.env.NEXT_PUBLIC_ENABLE_ANALYTICS === 'true'

export const analytics = {
  init: () => {
    if (ANALYTICS_ENABLED && MIXPANEL_TOKEN) {
      mixpanel.init(MIXPANEL_TOKEN, {
        debug: process.env.NODE_ENV === 'development',
        track_pageview: false, // manual tracking for better control
        persistence: 'localStorage',
        ip: false, // GDPR: anonymize IPs
        ignore_dnt: false, // respect Do Not Track
      })
      
      // Set super properties (attached to all events)
      mixpanel.register({
        app_version: process.env.NEXT_PUBLIC_APP_VERSION || '1.0.0',
        environment: process.env.NODE_ENV,
      })
    }
  },

  identify: (userId: string, traits?: Record<string, any>) => {
    if (!ANALYTICS_ENABLED) return
    mixpanel.identify(userId)
    if (traits) {
      mixpanel.people.set({
        $email: traits.email,
        $name: traits.name,
        signup_date: traits.signupDate,
        plan_type: traits.planType,
        ...traits,
      })
    }
  },

  track: (event: string, properties?: Record<string, any>) => {
    if (!ANALYTICS_ENABLED) return
    
    // Runtime validation: enforce verb_noun naming
    const validFormat = /^[a-z]+_[a-z_]+$/
    if (!validFormat.test(event)) {
      console.error(`❌ Invalid event name: "${event}". Use verb_noun format (e.g., click_button)`)
      return
    }
    
    mixpanel.track(event, {
      timestamp: new Date().toISOString(),
      ...properties,
    })
  },

  page: (pageName: string, properties?: Record<string, any>) => {
    if (!ANALYTICS_ENABLED) return
    mixpanel.track('view_page', {
      page_name: pageName,
      url: window.location.href,
      ...properties,
    })
  },

  reset: () => {
    if (!ANALYTICS_ENABLED) return
    mixpanel.reset() // Clear user identity on logout
  },
}
```

### Step 4: Initialize in Root Layout
**File**: `app/layout.tsx`

```typescript
'use client'

import { useEffect } from 'react'
import { analytics } from '@/lib/analytics'

export default function RootLayout({ children }: { children: React.ReactNode }) {
  useEffect(() => {
    analytics.init()
  }, [])

  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
```

---

## 3. Tracking Code Locations

### Priority 1: Conversion Funnel (Critical Path)

| Event | File Path | Trigger Point | Code Snippet |
|-------|-----------|---------------|--------------|
| `start_signup` | `app/(auth)/signup/page.tsx` | Component mount | `useEffect(() => analytics.track('start_signup', { signup_method: 'email' }), [])` |
| `complete_signup` | `app/(auth)/signup/actions.ts` | Server action success | `analytics.track('complete_signup', { user_id, signup_method })` |
| `activate_account` | `app/dashboard/page.tsx` | First document upload | `analytics.track('activate_account', { first_action: 'upload_document' })` |

### Priority 2: Engagement Events

| Event | File Path | Trigger Point | Code Snippet |
|-------|-----------|---------------|--------------|
| `view_dashboard` | `app/dashboard/page.tsx` | Component mount | `useEffect(() => analytics.page('dashboard'), [])` |
| `click_button` | `components/ui/button.tsx` | onClick handler | `onClick={() => { analytics.track('click_button', { button_id: props.id }); props.onClick() }}` |
| `upload_file` | `app/api/upload/route.ts` | File uploaded | `analytics.track('upload_file', { file_type, file_size_kb })` |

### Priority 3: Error Tracking

| Event | File Path | Trigger Point | Code Snippet |
|-------|-----------|---------------|--------------|
| `error_payment_failed` | `app/api/payment/route.ts` | Payment catch block | `analytics.track('error_payment_failed', { error_code, amount_usd })` |
| `error_upload_timeout` | `components/upload-form.tsx` | Upload timeout | `analytics.track('error_upload_timeout', { file_size_kb })` |

---

## 4. User Identification Strategy

**Trigger Point**: Immediately after signup/login

**File**: `app/(auth)/login/actions.ts`
```typescript
'use server'

import { analytics } from '@/lib/analytics'

export async function loginUser(email: string, password: string) {
  const user = await authenticateUser(email, password)
  
  // Identify user in Mixpanel
  analytics.identify(user.id, {
    email: user.email,
    name: user.name,
    signup_date: user.createdAt,
    plan_type: user.planType,
    company_size: user.companySize,
  })
  
  return user
}
```

**Logout**: Reset identity
```typescript
// app/api/logout/route.ts
export async function POST() {
  analytics.reset()
  // ... logout logic
}
```

---

## 5. GDPR/UU PDP Consent Management

### Consent Banner (Priority: Before Analytics Init)

**File**: `components/cookie-consent.tsx`
```typescript
'use client'

import { useState, useEffect } from 'react'
import { analytics } from '@/lib/analytics'

export function CookieConsent() {
  const [consent, setConsent] = useState<string | null>(null)

  useEffect(() => {
    const stored = localStorage.getItem('analytics_consent')
    setConsent(stored)
    
    if (stored === 'granted') {
      analytics.init()
    }
  }, [])

  const grantConsent = () => {
    localStorage.setItem('analytics_consent', 'granted')
    setConsent('granted')
    analytics.init()
  }

  const revokeConsent = () => {
    localStorage.setItem('analytics_consent', 'denied')
    setConsent('denied')
  }

  if (consent) return null

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-zinc-900 text-white p-4">
      <p>We use cookies to improve your experience.</p>
      <button onClick={grantConsent}>Accept</button>
      <button onClick={revokeConsent}>Decline</button>
    </div>
  )
}
```

### Opt-Out Page
**File**: `app/privacy/opt-out/page.tsx`
```typescript
export default function OptOutPage() {
  const handleOptOut = () => {
    localStorage.setItem('analytics_consent', 'denied')
    mixpanel.opt_out_tracking()
    alert('Analytics tracking disabled.')
  }

  return <button onClick={handleOptOut}>Opt Out of Tracking</button>
}
```

---

## 6. Testing & QA Checklist

### Development Testing
- [ ] Analytics disabled in dev mode (`NEXT_PUBLIC_ENABLE_ANALYTICS=false`)
- [ ] Console logs show event names (debug mode enabled)
- [ ] Event validation catches malformed event names

### Staging Testing
- [ ] Mixpanel Live View shows events in real-time
- [ ] User identification works (check Mixpanel user profile)
- [ ] Super properties attached to all events
- [ ] Error events fire correctly (trigger test errors)
- [ ] Consent banner shows on first visit
- [ ] Opt-out disables tracking

### Production Verification
- [ ] Analytics token injected via CI/CD secrets
- [ ] No PII leaks (no raw emails/passwords in event properties)
- [ ] IP anonymization enabled
- [ ] Event volume within free tier limits (monitor first 7 days)

---

## 7. Dashboard Setup (Mixpanel Boards)

### Board 1: Executive Overview
- **North Star Metric**: Weekly Active Documents Uploaded (line chart)
- **AARRR Summary**: 5 single-value cards (Acquisition, Activation, Retention, Referral, Revenue)
- **Funnel**: Signup → Onboarding → First Upload → 7-Day Retention

### Board 2: Conversion Funnel
- **Funnel Chart**: `start_signup` → `complete_signup` → `activate_account`
- **Conversion Time**: Time to activation histogram
- **Drop-off Analysis**: Table showing drop-off % at each step

### Board 3: User Cohorts
- **Retention Heatmap**: Weekly retention (W1, W2, W4, W8)
- **Cohort Segmentation**: Power users vs. churned users (event frequency)

### Board 4: Errors & Friction
- **Error Frequency**: Bar chart of `error_*` events
- **Error by User Segment**: Table showing which plan types hit errors most

---

## 8. Timeline & Milestones

| Week | Tasks | Deliverables |
|------|-------|--------------|
| Week 1 | SDK installation, wrapper creation, consent management | `lib/analytics.ts`, cookie banner |
| Week 2 | Core event tracking (signup, dashboard, upload) | 10 core events live in staging |
| Week 3 | User identification, super properties, error tracking | Full user profiles in Mixpanel |
| Week 4 | Dashboard setup, QA testing, production deployment | 4 Mixpanel boards, production analytics live |

---

## 9. Success Metrics (Implementation Quality)

- ✅ **100% conversion funnel coverage**: All critical path events tracked
- ✅ **<5% event validation errors**: Naming convention enforced
- ✅ **Zero PII leaks**: No sensitive data in event properties
- ✅ **GDPR compliant**: Consent banner + opt-out functional
- ✅ **Real-time visibility**: Dashboard loads in <3 seconds

---

## 10. Maintenance Plan

**Weekly**:
- Check Mixpanel dashboard for anomalies (sudden event drop = tracking bug)

**Monthly**:
- Audit dead events (0 triggers) → Remove tracking code
- Review missing properties (>50% null values) → Fix implementation
- Monitor free tier usage (spike alert at 80K/100K events)

**Quarterly**:
- Revisit event taxonomy: Still aligned with business goals?
- Update super properties (new app version, new user traits)

---

## Notes

- **Do NOT track sensitive data**: No passwords, credit card numbers, PII in event properties
- **Use environment-specific tokens**: Separate Mixpanel projects for dev/staging/production
- **Analytics ≠ Logging**: Use Sentry for error monitoring, Mixpanel for user behavior
