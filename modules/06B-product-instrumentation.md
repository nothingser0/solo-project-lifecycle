# Modul 06B: Product Instrumentation & Analytics Setup

> ⚠️ **MANDATORY: Load references BEFORE executing this module**:
> - `references/pm/PM_ANALYTICS_SETUP_GUIDE.md` (Platform selection, Event taxonomy quickstart, AARRR dashboard, A/B testing, Privacy compliance)
>
> **MANDATORY: Load references BEFORE executing this module**:
> - Read: `references/pm/PM_ANALYTICS_SETUP_GUIDE.md`

Modul ini adalah tahap pasca-development untuk solo developer dan PM yang butuh mengukur product-market fit, engagement funnel, dan business metrics secara kuantitatif. Tujuannya adalah memasang **event tracking taxonomy** terstruktur, **analytics platform SDK** (Mixpanel/Amplitude/GA4), dan **dashboard real-time** untuk monitoring North Star Metric tanpa menenggelamkan solo dev dengan overhead berlebih.

---

## 1. Kapan Modul 06B Dieksekusi?

```text
[ TIMING MATRIX ]
                                      
Skala Kecil (MVP):        ──► SKIP atau Minimal GA4 page views only
Skala Menengah:           ──► Pasang setelah M06 selesai, sebelum M07 (QA)
Skala Besar/Enterprise:   ──► Wajib sejak M05 (FSD), tracking plan masuk spesifikasi teknis
Product Hunt Launch:      ──► 2 minggu sebelum launch, butuh baseline data
Fundraising/VC Pitch:     ──► Wajib ada dashboard live untuk bukti traction
```

**Trigger Activation**:
- User bertanya "bagaimana cara track conversion funnel?"
- User menyebut "analytics", "Mixpanel", "dashboard", "metrics", "cohort analysis"
- Project masuk fase validasi pasar pasca-MVP
- Butuh A/B testing infrastructure untuk feature flags

---

## 2. Analytics Platform Selection Matrix

| Platform | Best For | Pricing | Solo Dev Friendly? | Key Features |
|----------|----------|---------|-------------------|--------------|
| **Mixpanel** | Funnel analysis, retention cohorts | Free: 100K events/mo | ✅ Yes | Event-based, user profiles, funnel viz |
| **Amplitude** | Product analytics, user journeys | Free: 10M events/mo | ✅ Yes | Retention, behavioral cohorting |
| **PostHog** | Self-hosted, privacy-first | Free: 1M events/mo | ✅ Yes | Feature flags + analytics + session replay |
| **Google Analytics 4 (GA4)** | Web traffic, SEO attribution | Free: unlimited | ✅ Yes | Acquisition tracking, basic funnels |
| **Segment.io** | CDP layer (multi-tool routing) | $120/mo minimum | ❌ Overkill for solo | Event routing to multiple destinations |

**Default Stack for Solo Dev Menengah**:
```text
Mixpanel (funnel + retention) + GA4 (acquisition) + Sentry (errors)
Total cost: $0/mo until scale
```

---

## 3. Event Tracking Taxonomy (The Naming Convention)

### Format Baku: `verb_noun` (lowercase, underscore separator)

```typescript
// ✅ CORRECT
track('view_page', { page_name: 'dashboard', user_role: 'admin' })
track('click_button', { button_id: 'export_pdf', screen: 'document_detail' })
track('complete_signup', { signup_method: 'google_oauth' })

// ❌ WRONG (inconsistent naming)
track('Page Viewed', { pageName: 'Dashboard' })  // space, PascalCase
track('buttonClick', { id: 'export' })             // camelCase verb
```

### Kategori Event Utama:

| Category | Event Examples | Tracking Goal |
|----------|----------------|---------------|
| **Page Views** | `view_page`, `view_dashboard`, `view_settings` | Navigasi user, screen time |
| **User Actions** | `click_button`, `submit_form`, `upload_file` | Interaksi fitur kunci |
| **Conversion** | `complete_signup`, `complete_payment`, `activate_account` | Funnel drop-off analysis |
| **Engagement** | `share_document`, `invite_user`, `enable_notification` | Viral coefficient, retention |
| **Errors** | `error_payment_failed`, `error_upload_timeout` | Friction points |

---

## 4. Implementation Quickstart (Next.js + Mixpanel)

### Step 1: Install SDK
```bash
pnpm add mixpanel-browser
```

### Step 2: Create Analytics Wrapper (`lib/analytics.ts`)
```typescript
import mixpanel from 'mixpanel-browser'

const MIXPANEL_TOKEN = process.env.NEXT_PUBLIC_MIXPANEL_TOKEN

export const analytics = {
  init: () => {
    if (MIXPANEL_TOKEN) {
      mixpanel.init(MIXPANEL_TOKEN, { 
        debug: process.env.NODE_ENV === 'development',
        track_pageview: false, // manual tracking
        persistence: 'localStorage'
      })
    }
  },
  
  identify: (userId: string, traits?: Record<string, any>) => {
    mixpanel.identify(userId)
    if (traits) mixpanel.people.set(traits)
  },
  
  track: (event: string, properties?: Record<string, any>) => {
    mixpanel.track(event, properties)
  },
  
  page: (pageName: string, properties?: Record<string, any>) => {
    mixpanel.track('view_page', { page_name: pageName, ...properties })
  }
}
```

### Step 3: Initialize in Root Layout
```typescript
// app/layout.tsx
'use client'
import { useEffect } from 'react'
import { analytics } from '@/lib/analytics'

export default function RootLayout({ children }) {
  useEffect(() => {
    analytics.init()
  }, [])
  
  return <html>{children}</html>
}
```

### Step 4: Track User Actions
```typescript
// app/dashboard/page.tsx
'use client'
import { analytics } from '@/lib/analytics'

export default function DashboardPage() {
  useEffect(() => {
    analytics.page('dashboard')
  }, [])
  
  const handleExport = () => {
    analytics.track('click_button', { 
      button_id: 'export_pdf',
      screen: 'dashboard' 
    })
    // ... export logic
  }
  
  return <button onClick={handleExport}>Export PDF</button>
}
```

---

## 5. Core Metrics & Dashboard Design (AARRR Framework)

### North Star Metric (from M00 Product Discovery)
Define ONE metric that reflects user value delivery:

| Product Type | North Star Metric Example |
|--------------|---------------------------|
| SaaS Document Vault | Weekly Active Documents Uploaded |
| E-commerce | Orders per Week |
| Social App | Daily Active Users (DAU) |
| API Service | API Calls per Day |

### AARRR Metrics Breakdown:

```text
Acquisition:    New signups per week (source: GA4 UTM params)
Activation:     % users who complete first key action within 24h
Retention:      Weekly retention cohort (W1, W2, W4 retention %)
Referral:       Viral coefficient (invites sent / new users)
Revenue:        MRR, ARPU, LTV/CAC ratio
```

**Dashboard Layout (Mixpanel Boards)**:
1. **Overview**: North Star Metric + AARRR summary cards
2. **Funnel**: Signup → Activation → First Value → Retention
3. **Cohorts**: Weekly retention heatmap
4. **User Profiles**: Power users vs. churned users behavioral diff

---

## 6. A/B Testing & Feature Flags Setup

### Option 1: PostHog (Analytics + Feature Flags Combined)
```bash
pnpm add posthog-js
```

```typescript
// lib/posthog.ts
import posthog from 'posthog-js'

posthog.init(process.env.NEXT_PUBLIC_POSTHOG_KEY!, {
  api_host: 'https://app.posthog.com'
})

export const useFeatureFlag = (flagKey: string) => {
  return posthog.isFeatureEnabled(flagKey)
}

// Usage in component
const newUIEnabled = useFeatureFlag('new_dashboard_ui')
```

### Option 2: LaunchDarkly (Enterprise-grade, $9/seat)
```bash
pnpm add launchdarkly-react-client-sdk
```

### Statistical Significance Calculator (Inline Formula)
```
Minimum sample size = (Z² × p × (1-p)) / E²
Z = 1.96 (95% confidence)
p = 0.5 (conservative estimate)
E = 0.05 (5% margin of error)

Result: ~385 users per variant minimum
```

**Test Result Report Template**: `templates/09-product-growth/AB_TEST_REPORT_TEMPLATE.md`

---

## 7. Error Monitoring Integration (Sentry)

```bash
pnpm add @sentry/nextjs
```

```typescript
// sentry.client.config.ts
import * as Sentry from '@sentry/nextjs'

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  tracesSampleRate: 0.1, // 10% of transactions for performance monitoring
  environment: process.env.NODE_ENV,
  integrations: [
    new Sentry.BrowserTracing(),
    new Sentry.Replay({
      maskAllText: true,
      blockAllMedia: true
    })
  ],
  replaysSessionSampleRate: 0.1,
  replaysOnErrorSampleRate: 1.0
})
```

**Alert Thresholds**:
- Severity 1 (P0): Error rate > 5% in 10 minutes → SMS alert
- Severity 2 (P1): New error type affecting > 10 users → Email alert
- Severity 3 (P2): Performance regression > 50% baseline → Dashboard only

---

## 8. Privacy Compliance (GDPR & UU PDP No. 27/2022)

### Consent Management Checklist:
- [ ] Cookie banner dengan opt-in eksplisit (bukan pre-checked)
- [ ] Disable tracking sebelum user klik "Accept Analytics"
- [ ] Sediakan opt-out URL: `/privacy/opt-out`
- [ ] Anonymize IP addresses: `mixpanel.set_config({ ip: false })`
- [ ] Data retention policy: Auto-delete events > 2 tahun

### Code Example: Consent Wrapper
```typescript
// lib/analytics.ts (enhanced)
export const analytics = {
  init: () => {
    const consent = localStorage.getItem('analytics_consent')
    if (consent === 'granted' && MIXPANEL_TOKEN) {
      mixpanel.init(MIXPANEL_TOKEN)
    }
  },
  
  grantConsent: () => {
    localStorage.setItem('analytics_consent', 'granted')
    analytics.init()
  },
  
  revokeConsent: () => {
    localStorage.removeItem('analytics_consent')
    mixpanel.opt_out_tracking()
  }
}
```

---

## 9. Output Artifacts (Deliverables)

| Artifact | Location | Purpose |
|----------|----------|---------|
| **Event Taxonomy Doc** | `docs/analytics/EVENT_TAXONOMY.md` | Single source of truth untuk nama event |
| **Implementation Plan** | `docs/analytics/ANALYTICS_IMPLEMENTATION_PLAN.md` | Langkah instalasi SDK, tracking code locations |
| **Dashboard Spec** | `docs/analytics/DASHBOARD_SPEC.md` | Definisi metrics, chart types, alert thresholds |
| **A/B Test Report** | `docs/analytics/AB_TEST_REPORT_[test_name].md` | Hypothesis, results, statistical significance |

**Template Sources**:
- `templates/09-product-growth/EVENT_TAXONOMY_TEMPLATE.md`
- `templates/09-product-growth/ANALYTICS_IMPLEMENTATION_PLAN_TEMPLATE.md`
- `templates/09-product-growth/DASHBOARD_SPEC_TEMPLATE.md`

---

## 10. Anti-Patterns & Red Flags

| ❌ Anti-Pattern | ✅ Correct Approach |
|----------------|---------------------|
| Track everything "just in case" | Define 5-10 core events aligned with North Star Metric |
| Inconsistent event naming (camelCase + snake_case) | Enforce `verb_noun` convention via ESLint rule |
| No user properties (demographic/behavioral) | Set user traits on signup: `plan_type`, `signup_date`, `company_size` |
| Ignore statistical significance in A/B tests | Wait for minimum 385 users/variant + 7 days runtime |
| Analytics code scattered in 50+ files | Centralize in `lib/analytics.ts`, import one wrapper |

---

## 11. Maintenance & Iteration

**Monthly Review Checklist**:
1. Audit dead events (0 triggers in 30 days) → Remove from codebase
2. Check for events with >50% missing properties → Fix instrumentation
3. Review dashboard: Still aligned with current business goals?
4. Sentry: Triage errors by frequency (Pareto 80/20 rule)

**Scale Trigger (Upgrade Analytics Stack)**:
- Mixpanel free tier exhausted (>100K events/mo) → Upgrade to $25/mo or migrate to PostHog self-hosted
- Need advanced features (SQL queries, data warehouse sync) → Consider Amplitude Growth plan

---

## 12. Integration with Other Modules

| Module | Integration Point |
|--------|-------------------|
| **M05 (FSD)** | Event taxonomy masuk API contract documentation |
| **M06 (Development)** | Analytics tracking code di `TODO.md` sebagai subtask |
| **M07 (QA/SIT)** | Verify analytics SDK fires correctly in staging |
| **M09 (UAT)** | Demo live dashboard to client as "business intelligence" |
| **M10 (Deployment)** | Inject production Mixpanel/Sentry tokens via CI/CD secrets |

---

## Prinsip Solo Developer Analytics

1. **Prioritize Signal over Noise**: Track maksimal 10 core events, bukan 100 random clicks.
2. **No Vendor Lock-In**: Gunakan wrapper abstraction (`lib/analytics.ts`) agar mudah swap Mixpanel → PostHog.
3. **Privacy-First by Default**: Opt-in analytics, bukan opt-out, untuk compliance UU PDP.
4. **Dashboard as Product Compass**: North Star Metric harus terlihat dalam 3 detik buka dashboard.
5. **Free Tier Sufficiency**: Proyek solo dev jarang melewati 100K events/bulan sebelum PMF.

---

## 🛑 PROTOKOL [GATE] KELUAR & WAJIB BERHENTI

Setelah analytics instrumentation setup selesai:

### **LANGKAH 0: VERIFIKASI EKSISTENSI BERKAS (BLOCKING CHECK)**

**WAJIB DILAKUKAN SEBELUM DECLARE SETUP COMPLETE**:

1. **Cek keberadaan file output** menggunakan salah satu metode:
   - PowerShell: `Test-Path -LiteralPath "docs/analytics/EVENT_TAXONOMY.md"` → harus return `True`
   - Read tool: `read_file('docs/analytics/EVENT_TAXONOMY.md')` → harus sukses tanpa error

2. **JIKA FILE TIDAK ADA**:
   - ❌ **STOP IMMEDIATELY** - jangan declare setup complete
   - ❌ **JANGAN tampilkan summary** ke user
   - ❌ **JANGAN lanjut ke Module 07**
   - ✅ **REPORT ERROR** ke user:
     ```
     CRITICAL ERROR: File EVENT_TAXONOMY.md tidak tercipta.
     Module 06B INCOMPLETE - analytics setup FAILED.
     
     Kemungkinan penyebab:
     - Write permission denied pada folder docs/analytics/
     - Path typo di tool call
     - Disk full
     
     Tolong investigasi issue ini sebelum lanjut.
     ```
   - ✅ **END TURN** dan tunggu user fix issue

3. **HANYA JIKA FILE EXISTS**: Lanjut ke validasi di bawah

---

### **LANGKAH 1: VALIDASI SETUP & CONFIRMATION**

1. **Verifikasi analytics setup**:
   - [ ] `read_file('docs/analytics/EVENT_TAXONOMY.md')` → Confirm 5-10 core events documented
   - [ ] Confirm SDK installed (Mixpanel/Amplitude/GA4)
   - [ ] Confirm tracking wrapper created (`lib/analytics.ts`)
   - [ ] Confirm event naming convention enforced (`verb_noun`)
2. **AKHIRI RESPON ANDA (END TURN)** dan ajukan konfirmasi:
   > *"Analytics instrumentation telah selesai dengan [X] core events terdefinisi. SDK terpasang dan event taxonomy terdokumentasi di `docs/analytics/EVENT_TAXONOMY.md`. Siap lanjut ke Modul 07 (QA & SIT) untuk verify tracking di staging?"*
3. Tunggu respon persetujuan eksplisit dari pengguna sebelum melangkah ke Modul 07.

---

**Next Step After M06B**: Lanjut ke **Modul 07 (Quality Assurance & SIT)** untuk memastikan tracking code bekerja di staging sebelum UAT.
