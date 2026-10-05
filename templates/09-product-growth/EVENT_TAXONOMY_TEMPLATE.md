# Event Taxonomy

**Project**: [Project Name]  
**Last Updated**: [YYYY-MM-DD]  
**Owner**: [Developer Name]

---

## Naming Convention

**Format**: `verb_noun` (lowercase, underscore separator)

**Examples**:
- ✅ `view_page`, `click_button`, `complete_signup`
- ❌ `Page Viewed`, `buttonClick`, `SignUp`

---

## Event Categories

### 1. Page Views

| Event Name | Properties | Trigger Location | Business Goal |
|------------|------------|------------------|---------------|
| `view_page` | `page_name` (string), `user_role` (string) | All page navigations | Track user navigation patterns |
| `view_dashboard` | `dashboard_type` (string), `date_range` (string) | Dashboard screen | Monitor feature adoption |
| `view_settings` | `settings_section` (string) | Settings page | Identify configuration friction |

### 2. User Actions

| Event Name | Properties | Trigger Location | Business Goal |
|------------|------------|------------------|---------------|
| `click_button` | `button_id` (string), `screen` (string), `action_type` (string) | Interactive buttons | Measure feature engagement |
| `submit_form` | `form_id` (string), `form_type` (string), `field_count` (number) | Form submissions | Identify drop-off points |
| `upload_file` | `file_type` (string), `file_size_kb` (number), `upload_method` (string) | File upload flows | Track storage usage patterns |

### 3. Conversion Events (Funnel Critical)

| Event Name | Properties | Trigger Location | Business Goal |
|------------|------------|------------------|---------------|
| `start_signup` | `signup_method` (string), `referrer_source` (string) | Signup form load | Top of funnel measurement |
| `complete_signup` | `signup_method` (string), `time_to_complete_sec` (number) | Account created | Activation rate |
| `complete_onboarding` | `steps_completed` (number), `skipped_steps` (array) | Onboarding finished | Onboarding effectiveness |
| `activate_account` | `first_action` (string), `time_since_signup_hours` (number) | First value action | True activation (aha moment) |

### 4. Engagement & Retention

| Event Name | Properties | Trigger Location | Business Goal |
|------------|------------|------------------|---------------|
| `share_document` | `document_id` (string), `share_method` (string), `recipient_count` (number) | Share modal | Viral coefficient |
| `invite_user` | `invite_method` (string), `workspace_id` (string) | Invite flow | Growth loops |
| `enable_notification` | `notification_type` (string), `channel` (string) | Settings toggle | Retention anchor |

### 5. Revenue Events

| Event Name | Properties | Trigger Location | Business Goal |
|------------|------------|------------------|---------------|
| `view_pricing` | `plan_type` (string), `billing_period` (string) | Pricing page | Intent to purchase |
| `start_checkout` | `plan_selected` (string), `amount_usd` (number) | Checkout initiated | Checkout funnel |
| `complete_payment` | `plan_type` (string), `amount_usd` (number), `payment_method` (string) | Payment success | Revenue tracking |
| `upgrade_plan` | `from_plan` (string), `to_plan` (string), `mrr_delta_usd` (number) | Plan change | Expansion revenue |

### 6. Error & Friction Events

| Event Name | Properties | Trigger Location | Business Goal |
|------------|------------|------------------|---------------|
| `error_payment_failed` | `error_code` (string), `payment_provider` (string), `amount_usd` (number) | Payment error handler | Reduce checkout friction |
| `error_upload_timeout` | `file_size_kb` (number), `browser` (string) | Upload timeout | Identify infra issues |
| `error_api_failure` | `endpoint` (string), `status_code` (number), `error_message` (string) | API error boundary | Monitor system reliability |

---

## User Properties (Set on Identify)

Properties attached to user profile, not individual events:

| Property Name | Type | Source | Update Frequency |
|---------------|------|--------|------------------|
| `user_id` | string | Auth system | Signup |
| `email` | string | User input | Signup |
| `signup_date` | ISO timestamp | Server | Signup |
| `plan_type` | enum: free/pro/enterprise | Subscription system | Plan change |
| `company_size` | enum: 1-10/11-50/51-200/200+ | Signup form | Signup |
| `industry` | string | Signup form | Signup |
| `signup_method` | enum: email/google/github | Auth provider | Signup |
| `total_documents_uploaded` | number | Database | Daily aggregation |
| `lifetime_value_usd` | number | Billing system | Payment event |

---

## Super Properties (Session-Level)

Properties auto-attached to ALL events during session:

| Property Name | Type | Source | Example Value |
|---------------|------|--------|---------------|
| `session_id` | uuid | Analytics SDK | `550e8400-e29b-41d4-a716-446655440000` |
| `device_type` | enum: desktop/mobile/tablet | User agent | `desktop` |
| `browser` | string | User agent | `Chrome 118` |
| `os` | string | User agent | `macOS 14.0` |
| `screen_resolution` | string | Window API | `1920x1080` |
| `referrer_url` | string | Document referrer | `https://google.com/search?q=...` |
| `utm_source` | string | URL params | `producthunt` |
| `utm_campaign` | string | URL params | `launch_week` |

---

## Implementation Checklist

- [ ] Analytics SDK initialized in root layout
- [ ] Consent management (GDPR/UU PDP compliant)
- [ ] All conversion events tracked (signup → activation → retention)
- [ ] Error events wired to error boundaries
- [ ] User properties set on signup/login
- [ ] Super properties configured in SDK init
- [ ] QA: Verify events fire in staging (Mixpanel Live View)
- [ ] Documentation: Update FSD.md with analytics integration section

---

## Event Volume Estimate

| Event Category | Estimated Frequency | Monthly Volume (100 MAU) |
|----------------|---------------------|--------------------------|
| Page Views | 50 events/user/month | 5,000 |
| User Actions | 100 events/user/month | 10,000 |
| Conversion | 5 events/user (one-time) | 500 |
| Engagement | 20 events/user/month | 2,000 |
| Errors | 2 events/user/month | 200 |
| **TOTAL** | | **~18,000 events/month** |

**Free Tier Check**: Mixpanel free tier = 100K events/month → Sufficient for ~550 MAU

---

## Maintenance

**Monthly Audit**:
1. Check Mixpanel/Amplitude dashboard for events with 0 triggers in 30 days → Remove dead code
2. Review events with >50% missing properties → Fix tracking code
3. Compare actual volume vs. estimate → Adjust free tier if needed

**Naming Convention Enforcement**:
```typescript
// lib/analytics.ts - Add runtime validation
export const track = (event: string, properties?: Record<string, any>) => {
  const validFormat = /^[a-z]+_[a-z_]+$/
  if (!validFormat.test(event)) {
    console.error(`Invalid event name: ${event}. Use verb_noun format.`)
    return
  }
  mixpanel.track(event, properties)
}
```
