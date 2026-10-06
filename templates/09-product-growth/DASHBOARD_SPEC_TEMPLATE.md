# Dashboard Specification

**Project**: [Project Name]  
**Dashboard Platform**: [Mixpanel / Amplitude / PostHog / Looker]  
**Last Updated**: [YYYY-MM-DD]  
**Owner**: [Developer Name / PM]

---

## North Star Metric

**Metric Name**: [e.g., Weekly Active Documents Uploaded]  
**Definition**: [Precise calculation logic]  
**Target Value**: [e.g., 50 documents/week by Month 3]  
**Update Frequency**: Real-time  
**Chart Type**: Line chart with 12-week trend

**Why This Metric?**
[1-2 sentences explaining why this metric reflects true user value delivery and business health]

---

## Dashboard Layout

### Board 1: Executive Overview (Primary Dashboard)

**Purpose**: Single-screen health check for founders/stakeholders

| Widget | Metric | Visualization | Data Source | Update Frequency |
|--------|--------|---------------|-------------|------------------|
| 1 | North Star Metric | Large number + 12-week trend line | `complete_upload` event count | Real-time |
| 2 | New Signups (7d) | Single-value card with % change | `complete_signup` event count | Real-time |
| 3 | Activation Rate | Single-value card (%) | Funnel: `complete_signup` → `activate_account` | Hourly |
| 4 | Weekly Retention (W1) | Single-value card (%) | Cohort analysis | Daily |
| 5 | MRR | Single-value card ($) | `complete_payment` aggregated | Hourly |

**Alert Thresholds**:
- North Star Metric drops >30% week-over-week → Slack alert
- Activation rate <20% for 48h → Email alert

---

### Board 2: AARRR Funnel (Product Analytics)

**Purpose**: Identify conversion bottlenecks

#### Acquisition
| Metric | Definition | Chart Type | Target | Alert Threshold |
|--------|------------|------------|--------|-----------------|
| Traffic Sources | UTM source breakdown | Pie chart | N/A | N/A |
| Signup Conversion Rate | Visitors → Signups | Funnel | >3% | <2% for 7d |
| Cost per Acquisition | Ad spend / signups | Line chart | <$20 | >$50 |

#### Activation
| Metric | Definition | Chart Type | Target | Alert Threshold |
|--------|------------|------------|--------|-----------------|
| Onboarding Completion | % users completing onboarding flow | Bar chart | >70% | <50% for 3d |
| Time to First Value | Median time: signup → first upload | Histogram | <10 min | >30 min median |
| Activation Rate | % signups who trigger `activate_account` | Single value | >40% | <30% for 7d |

#### Retention
| Metric | Definition | Chart Type | Target | Alert Threshold |
|--------|------------|------------|--------|-----------------|
| Weekly Retention Cohorts | W1, W2, W4, W8 retention % | Heatmap | W1 >40%, W4 >20% | W1 <25% |
| Daily Active Users (DAU) | Unique users with ≥1 event/day | Line chart | Growth trajectory | 20% drop in 3d |
| Churn Risk Users | Users with 0 activity in 14d | Table | N/A | >30% of active base |

#### Referral
| Metric | Definition | Chart Type | Target | Alert Threshold |
|--------|------------|------------|--------|-----------------|
| Viral Coefficient | Invites sent / new signups | Line chart | >0.5 | <0.2 for 30d |
| Invite Accept Rate | Accepted invites / sent | Bar chart | >30% | <15% |

#### Revenue
| Metric | Definition | Chart Type | Target | Alert Threshold |
|--------|------------|------------|--------|-----------------|
| MRR | Monthly Recurring Revenue | Line chart | +10% MoM | Flat for 2 months |
| ARPU | Average Revenue Per User | Line chart | >$20/mo | <$10/mo |
| LTV/CAC Ratio | Lifetime Value / Customer Acquisition Cost | Single value | >3.0 | <1.5 |

---

### Board 3: Feature Adoption (Product Development)

**Purpose**: Measure feature usage and identify underutilized features

| Feature | Event Tracked | Adoption Rate (% of users) | Usage Frequency (avg/user/week) | Trend (7d) |
|---------|---------------|----------------------------|----------------------------------|------------|
| Document Upload | `upload_file` | [Calculate from Mixpanel] | [Calculate] | [↑/↓/%] |
| Share Feature | `share_document` | [Calculate] | [Calculate] | [↑/↓/%] |
| Export PDF | `click_button` (button_id=export_pdf) | [Calculate] | [Calculate] | [↑/↓/%] |
| Team Invite | `invite_user` | [Calculate] | [Calculate] | [↑/↓/%] |

**Action Items**:
- Features with <10% adoption → Consider deprecation or redesign
- Features with 30%+ adoption but low frequency → Investigate friction points

---

### Board 4: Errors & Performance (Engineering Health)

**Purpose**: Monitor system reliability and user-facing errors

#### Error Tracking
| Error Type | Event | Frequency (7d) | Affected Users | Severity | Status |
|------------|-------|----------------|----------------|----------|--------|
| Payment Failures | `error_payment_failed` | [Count] | [Unique users] | P0 | [Open/Fixed] |
| Upload Timeouts | `error_upload_timeout` | [Count] | [Unique users] | P1 | [Open/Fixed] |
| API Failures | `error_api_failure` | [Count] | [Unique users] | P1 | [Open/Fixed] |

**Alert Rules**:
- Any error affecting >10 users in 1 hour → PagerDuty alert
- Error rate >5% of total events → Slack alert

#### Performance Metrics (from Sentry)
| Metric | P50 | P95 | P99 | Target | Alert Threshold |
|--------|-----|-----|-----|--------|-----------------|
| Page Load Time (ms) | [Value] | [Value] | [Value] | <1000ms | >2000ms P95 |
| API Response Time (ms) | [Value] | [Value] | [Value] | <200ms | >500ms P95 |
| Time to Interactive (ms) | [Value] | [Value] | [Value] | <3000ms | >5000ms P95 |

---

## User Segmentation

### Power Users Definition
**Criteria**: Users with ≥10 events/week for 4 consecutive weeks

**Dashboard Widget**: 
- Count of power users
- Power user retention rate
- Feature usage comparison (power users vs. average)

### At-Risk Users Definition
**Criteria**: Active users (had events in last 30d) but 0 events in last 14d

**Dashboard Widget**:
- Count of at-risk users
- Cohort: When did they sign up?
- Last action taken before going dormant

---

## A/B Test Results Dashboard

**Purpose**: Track live experiments and their impact

| Test Name | Hypothesis | Variant A (Control) | Variant B (Treatment) | Metric | Winner | Status |
|-----------|------------|---------------------|----------------------|--------|--------|--------|
| [Test ID] | [What we're testing] | [Description] | [Description] | [Primary metric] | [A/B/Inconclusive] | [Active/Concluded] |

**Example**:
| Test Name | Hypothesis | Variant A | Variant B | Metric | Winner | Status |
|-----------|------------|-----------|-----------|--------|--------|--------|
| new_onboarding_flow | Simplified 2-step onboarding will increase activation | 3-step flow | 2-step flow | Activation rate | B (+12% lift) | Concluded |

**Test Criteria**:
- Minimum sample size: 385 users per variant
- Minimum runtime: 7 days
- Statistical significance threshold: p < 0.05

---

## Dashboard Access & Permissions

| Role | Dashboard Access | Edit Permissions | Export Data |
|------|------------------|------------------|-------------|
| Founder/CEO | All boards | ✅ Yes | ✅ Yes |
| Product Manager | Board 1, 2, 3 | ✅ Yes | ✅ Yes |
| Engineer | Board 4 only | ❌ No | ✅ Yes |
| Investor | Board 1 only (view-only) | ❌ No | ❌ No |

---

## Dashboard Maintenance Schedule

**Daily** (automated):
- Refresh all metrics at 00:00 UTC
- Check alert rules for threshold breaches

**Weekly** (manual, 30 min):
- Review cohort retention trends
- Triage new error types
- Update A/B test status

**Monthly** (manual, 2 hours):
- Audit metrics: Still aligned with business goals?
- Remove deprecated metrics (features removed, etc.)
- Update alert thresholds based on new baseline

**Quarterly** (manual, 4 hours):
- Full dashboard redesign review
- Add new metrics from recent features
- Stakeholder feedback session

---

## Technical Implementation Notes

### Mixpanel Board IDs
- Executive Overview: [Board ID or URL]
- AARRR Funnel: [Board ID or URL]
- Feature Adoption: [Board ID or URL]
- Errors & Performance: [Board ID or URL]

### Custom Formulas

**Activation Rate**:
```
(Count of users with 'activate_account' event) / (Count of users with 'complete_signup' event) * 100
```

**Weekly Retention W1**:
```
(Users active in Week 1 after signup) / (Total signups in cohort week) * 100
```

**Viral Coefficient**:
```
(Count of 'invite_user' events) / (Count of new signups from invites)
```

---

## Success Criteria for Dashboard

- ✅ **Decision-making speed**: Founder can answer "How's the business?" in <10 seconds
- ✅ **Actionability**: Every metric ties to a specific action (e.g., low activation → fix onboarding)
- ✅ **Reliability**: Zero data gaps in last 30 days
- ✅ **Adoption**: Checked daily by founder/PM
- ✅ **Alert accuracy**: <5% false positive alert rate

---

## Appendix: Chart Type Selection Guide

| Data Type | Best Chart | Example Metric |
|-----------|-----------|----------------|
| Single point-in-time value | Single-value card | MRR, DAU, Activation Rate |
| Trend over time | Line chart | Weekly signups, retention trend |
| Proportion breakdown | Pie chart or bar chart | Traffic sources, error types |
| Funnel conversion | Funnel chart | Signup → Activation → Retention |
| Cohort behavior | Heatmap | Weekly retention by cohort |
| Distribution | Histogram | Time to activation, session length |
| Comparison | Bar chart | Feature A vs. Feature B usage |
| Relationship | Scatter plot | LTV vs. CAC by cohort |
