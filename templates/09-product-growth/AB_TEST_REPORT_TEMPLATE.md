# A/B Test Report: [Test Name]

**Test ID:** [TEST-YYYY-NNN]  
**Date Range:** [Start Date] — [End Date]  
**Author:** [Your Name]  
**Date Analyzed:** [YYYY-MM-DD]  
**Status:** [Running / Completed / Shipped / Killed]

---

## Executive Summary

<!-- 2-3 sentences: What was tested? What won? What's the recommendation? -->

[Brief overview. Example: "We tested a simplified onboarding flow (2 steps vs. 4 steps) to improve signup completion. Variant B (2-step) increased completion by 23% (p<0.01). Recommendation: Ship Variant B to 100% of users."]

**Winner:** [Control / Variant A / Variant B / No Winner]  
**Recommendation:** [Ship / Kill / Iterate / Extend Test]  
**Impact:** [Revenue, conversions, retention impact estimate]

---

## 1. Hypothesis

### Problem Statement

**What user problem are we solving?**

[Describe the pain point or opportunity. Example: "Only 45% of users who start signup complete it. Drop-off analysis shows 30% abandon at the 'Company Info' step (step 3 of 4). Users report this feels 'too much work for just trying the product.'"]

### Hypothesis Statement

**We believe that** [change to product/feature]  
**For** [target users]  
**Will result in** [expected outcome]  
**Because** [reasoning/user insight]

**Example:**  
We believe that reducing signup steps from 4 to 2 (email + password only)  
For new trial users  
Will result in 15%+ higher signup completion rate  
Because users want to "try before they commit" and don't want to provide company details upfront.

### Success Criteria

**Primary Metric:** [What must improve?]  
**Minimum Detectable Effect (MDE):** [Smallest change worth shipping]  
**Statistical Significance:** p < 0.05 (95% confidence)  
**Sample Size Required:** [N users per variant]

**Example:**
- **Primary Metric**: Signup completion rate (% of users who finish all steps)
- **MDE**: +10% relative increase (from 45% to 49.5%)
- **Sample Size**: 1,800 users per variant (3,600 total)

---

## 2. Test Design

### Variants

#### Control (Baseline)

**Description:** [What's the current experience?]

**Implementation:**
- [Key element 1]
- [Key element 2]
- [Screenshot or Figma link]

**Example:**
- 4-step signup: Email → Password → Company Info → Team Size
- Required fields: 8 total
- Estimated time: 3-5 minutes

#### Variant A

**Description:** [What changes in this variant?]

**Implementation:**
- [Key element 1]
- [Key element 2]
- [Screenshot or Figma link]

**Example:**
- 2-step signup: Email → Password (company info moved to post-signup onboarding)
- Required fields: 2 total
- Estimated time: 30 seconds

#### Variant B (if applicable)

**Description:** [What changes in this variant?]

**Implementation:**
- [Key element 1]
- [Key element 2]
- [Screenshot or Figma link]

### Traffic Split

| Variant | % Traffic | Expected Users (per week) |
|---------|-----------|---------------------------|
| Control | 50% | [Number] |
| Variant A | 50% | [Number] |

**Assignment Method:** [Random / User ID Hash / Session-based]  
**Randomization Unit:** [User / Session / Device]

### Duration

**Start Date:** [YYYY-MM-DD]  
**End Date:** [YYYY-MM-DD]  
**Total Duration:** [N weeks]

**Why this duration?**
- Covers 2 full weeks (accounts for weekday/weekend behavior)
- Achieves statistical power (1,800 users per variant at 900/week traffic)

---

## 3. Results

### Sample Size

| Variant | Users | Sessions | % of Total |
|---------|-------|----------|------------|
| Control | [N] | [N] | 50.2% |
| Variant A | [N] | [N] | 49.8% |
| **Total** | [N] | [N] | 100% |

**Data Quality Checks:**
- ✅ Traffic split within 51/49 range (no allocation bias)
- ✅ No bot traffic detected (reCAPTCHA filter applied)
- ✅ No outliers removed (no users excluded)

### Primary Metric: [Metric Name]

| Variant | Metric Value | Absolute Change | Relative Change | p-value | CI (95%) |
|---------|--------------|-----------------|-----------------|---------|----------|
| Control | [X%] | — | — | — | [Lower — Upper] |
| Variant A | [Y%] | [+/- Z pp] | [+/- W%] | [p-value] | [Lower — Upper] |

**Example:**

| Variant | Signup Completion | Absolute Change | Relative Change | p-value | CI (95%) |
|---------|-------------------|-----------------|-----------------|---------|----------|
| Control | 45.2% | — | — | — | 42.8% — 47.6% |
| Variant A | 55.6% | **+10.4 pp** | **+23.0%** | **0.0032** | 52.9% — 58.3% |

**Statistical Significance:** ✅ Yes (p < 0.05)  
**Practical Significance:** ✅ Yes (exceeds +10% MDE)

### Conversion Funnel Breakdown

| Step | Control | Variant A | Lift |
|------|---------|-----------|------|
| Land on signup page | 100% | 100% | — |
| Start signup (enter email) | 82.3% | 83.1% | +1.0% |
| Complete step 1 | 72.1% | 81.5% | **+13.0%** |
| Complete step 2 | 58.4% | 55.6% | (final) |
| Complete step 3 (Control only) | 51.2% | — | — |
| Complete step 4 (Control only) | 45.2% | — | — |

**Insight:** Variant A eliminates drop-off at steps 3 & 4 (company info + team size).

---

## 4. Secondary Metrics

### Impact on [Secondary Metric 1]

| Variant | Value | Change | p-value |
|---------|-------|--------|---------|
| Control | [X] | — | — |
| Variant A | [Y] | [+/- Z%] | [p-value] |

**Example: Time to Complete Signup**

| Variant | Avg Time | Change | p-value |
|---------|----------|--------|---------|
| Control | 4m 32s | — | — |
| Variant A | 48s | **-79%** | <0.001 |

### Impact on [Secondary Metric 2]

**Example: 7-Day Activation Rate (users who complete first core action)**

| Variant | Activation | Change | p-value |
|---------|------------|--------|---------|
| Control | 62.3% | — | — |
| Variant A | 58.7% | -3.6 pp | 0.21 (n.s.) |

**Note:** Not statistically significant. Possible that lower-intent users complete Variant A faster, slightly diluting activation.

### Guardrail Metrics (No Negative Impact)

- ✅ **Revenue per user (30-day):** No significant change (-2.1%, p=0.45)
- ✅ **Churn rate (14-day):** No significant change (+0.8 pp, p=0.67)
- ✅ **Support ticket volume:** No increase (Variant A: 0.3 tickets/user vs. Control: 0.4, p=0.52)

---

## 5. Segmentation Analysis

### By User Segment

**Metric:** Signup Completion Rate

| Segment | Control | Variant A | Lift | p-value |
|---------|---------|-----------|------|---------|
| **Overall** | 45.2% | 55.6% | +23.0% | 0.0032 |
| Mobile users | 38.1% | 51.2% | **+34.4%** | 0.008 |
| Desktop users | 49.7% | 58.3% | +17.3% | 0.041 |
| New visitors (no prior session) | 42.3% | 54.1% | **+27.9%** | 0.012 |
| Returning visitors | 51.8% | 59.2% | +14.3% | 0.18 (n.s.) |

**Insights:**
- **Mobile users benefit most** (+34% lift). Control's 4-step form is especially painful on mobile.
- Returning visitors already showed higher intent, so lift is smaller (but still positive).

### By Traffic Source

| Source | Control | Variant A | Lift | p-value |
|--------|---------|-----------|------|---------|
| Organic search | 48.2% | 57.1% | +18.5% | 0.032 |
| Paid ads | 41.3% | 54.8% | **+32.7%** | 0.005 |
| Direct | 50.1% | 59.3% | +18.4% | 0.08 (borderline) |

**Insight:** Paid ad traffic (lower intent) sees the biggest lift. Simplified signup reduces friction for "just browsing" users.

---

## 6. Statistical Details

### Formulas Used

**Conversion Rate:**
```
Conversion Rate = (Conversions / Total Users) × 100
```

**Relative Lift:**
```
Relative Lift (%) = ((Variant Rate - Control Rate) / Control Rate) × 100
```

**Standard Error:**
```
SE = sqrt( p × (1 - p) / n )
where p = conversion rate, n = sample size
```

**Z-Score (Two-Proportion Test):**
```
Z = (p_variant - p_control) / sqrt( SE_control² + SE_variant² )
```

**p-value:** Derived from Z-score via standard normal distribution.

**Confidence Interval (95%):**
```
CI = p ± 1.96 × SE
```

### Power Analysis

**Achieved Power:** 0.89 (89% chance of detecting a true +10% effect)  
**Required Power:** 0.80 (standard)  
**Status:** ✅ Well-powered test

### Bayesian Analysis (Optional)

**Probability Variant A beats Control:** 98.7%  
**Expected Lift (Posterior Mean):** +22.3% (95% CI: +8.1% to +36.5%)

---

## 7. Winner Variant

### Winning Variant: **Variant A**

**Why it won:**
- **+23% increase in signup completion** (10.4 percentage points)
- **Statistically significant** (p = 0.0032, well below 0.05)
- **Exceeded MDE** (+10% threshold)
- **No negative impact** on revenue, activation, or churn

### Revenue Impact Estimate

**Calculation:**

```
Current signup traffic: 3,600 signups/month
Control conversion: 45.2% → 1,627 completed signups/month
Variant A conversion: 55.6% → 2,002 completed signups/month

Additional signups: +375/month

If 30% convert to paid (avg $50/month LTV):
+375 × 0.30 × $50 = +$5,625 MRR
Annual impact: ~$67,500 ARR
```

**Conservative Estimate (accounting for dilution):** +$4,000 MRR / +$48K ARR

---

## 8. Recommendation

### Ship Variant A to 100%

**Rationale:**
1. Clear statistical win (+23% lift, p<0.01)
2. No negative side effects on key guardrails
3. Mobile users benefit most (34% lift) — aligns with mobile-first strategy
4. Simple implementation (remove 2 steps, move fields to post-signup)

### Implementation Plan

**Phase 1: Gradual Rollout (Week 1)**
- Ship to 100% of new users
- Monitor for 7 days (watch for edge cases)

**Phase 2: Full Deployment (Week 2)**
- Make Variant A the new baseline
- Archive old 4-step flow (keep code in git history for 90 days)

**Phase 3: Follow-Up Optimization (Month 2)**
- Test moving company info collection to onboarding survey (inside product)
- A/B test incentivizing profile completion (discount for filling company info)

### Rollback Plan

**If Variant A causes issues:**
- Trigger: 7-day activation rate drops >5% (from 60% to <57%)
- Action: Revert to Control within 1 hour via feature flag
- Notify: Engineering + Product leads

---

## 9. Learnings & Next Steps

### Key Learnings

1. **Less is more for trial signups:** Users want to try before committing. Collecting detailed info upfront kills conversion.
2. **Mobile-first matters:** Mobile users are 34% more sensitive to form friction.
3. **Post-signup data collection works:** We can collect company info later (during onboarding) without losing it.

### Follow-Up Experiments

**Experiment 1: Social Login**
- **Hypothesis:** Adding "Sign up with Google" will further reduce friction (+15% lift)
- **Priority:** High
- **Timeline:** Q2 2026

**Experiment 2: Progressive Profiling**
- **Hypothesis:** Collecting company info via in-app prompts (not forms) will maintain data quality
- **Priority:** Medium
- **Timeline:** Q3 2026

**Experiment 3: Mobile-Optimized Onboarding**
- **Hypothesis:** Tailored mobile onboarding (swipe cards vs. forms) will boost activation
- **Priority:** Medium
- **Timeline:** Q3 2026

### Risks & Mitigations

**Risk 1: Lower data quality**
- **Concern:** Missing company info for 20% of users (who skip post-signup survey)
- **Mitigation:** Gate certain features behind profile completion (e.g., team invite requires company name)

**Risk 2: Lower-intent users diluting metrics**
- **Concern:** Easier signup = more tire-kickers, lower activation
- **Status:** Monitored, no significant drop detected (58.7% vs. 62.3%, p=0.21)
- **Mitigation:** Track cohort retention at Day 30 to confirm long-term impact

---

## 10. Appendix

### Data Sources

- **Analytics Platform:** [Mixpanel / Amplitude / PostHog]
- **SQL Queries:** [Link to GitHub gist or internal docs]
- **Raw Data Export:** [Link to CSV or data warehouse query]

### Supporting Assets

- **Figma Designs:**
  - [Control Flow](https://figma.com/...)
  - [Variant A Flow](https://figma.com/...)
- **Loom Walkthrough:** [Video demo of variants]
- **Statistical Calculator:** [Link to A/B test calculator used]

### Charts & Visualizations

<!-- Placeholder for charts -->

**[CHART 1: Conversion Funnel Comparison]**
```
┌─────────────────────────────────────────┐
│ Control:  100% → 72% → 58% → 51% → 45% │
│ Variant A: 100% → 82% → 56% (done)      │
└─────────────────────────────────────────┘
```

**[CHART 2: Daily Conversion Rate (Control vs. Variant A)]**
```
(Insert line chart: X-axis = Date, Y-axis = Conversion %, 2 lines)
```

**[CHART 3: Lift by Segment]**
```
Mobile:    +34% ████████████████████
Paid Ads:  +33% ███████████████████
New Users: +28% █████████████████
Desktop:   +17% ███████████
Overall:   +23% ██████████████
```

### Peer Review

**Reviewed By:**
- [Data Scientist]: [Name] — [Date] — ✅ Approved
- [Product Manager]: [Name] — [Date] — ✅ Approved
- [Engineering Lead]: [Name] — [Date] — ✅ Approved

---

## Sign-Off

**Product Decision:** [Ship / Kill / Extend Test / Iterate]  
**Decision Maker:** [Name, Title]  
**Date:** [YYYY-MM-DD]  
**Next Review:** [Date for post-ship analysis]

---

**Changelog:**

| Date | Version | Changes | Author |
|------|---------|---------|--------|
| [YYYY-MM-DD] | 1.0 | Initial test report | [Name] |
| [YYYY-MM-DD] | 1.1 | Added segmentation analysis | [Name] |
| [YYYY-MM-DD] | 2.0 | Final report, recommendation added | [Name] |
