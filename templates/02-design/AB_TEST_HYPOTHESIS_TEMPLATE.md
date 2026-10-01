# A/B Test Hypothesis: [Feature/Change Name]

**Test ID**: [ABT-001]  
**Date Created**: [YYYY-MM-DD]  
**Owner**: [Name]  
**Status**: [ ] Draft [ ] Running [ ] Complete

---

## 1. Hypothesis Statement

**Format** (Measurable & Falsifiable):

```
We believe [CHANGE X]
will result in [OUTCOME Y]
We will measure [METRIC Z]
We will know we're right when [SUCCESS CRITERIA]
```

**Filled Example**:
```
We believe moving "Export Report" button from dropdown menu to primary toolbar
will result in 30% increase in report export usage
We will measure click-through rate (CTR) on Export button
We will know we're right when CTR ≥15% (baseline: 11.5%) after 2 weeks with 500+ sessions
```

---

## 2. Context & Rationale

**Current Problem**:  
[Contoh: "Only 11.5% of users who view reports actually export them, despite export being a core workflow. User interviews revealed 4/5 users didn't notice the dropdown menu."]

**Why This Change**:  
[Contoh: "Primary toolbar placement increases discoverability. Industry benchmark for similar tools: 18-25% CTR on export features."]

**Alternative Considered** (Why Not Chosen):  
[Contoh: "Alternative: Add a tooltip on hover → Rejected because mobile users won't see hover states."]

---

## 3. Test Design

### Variants

**Control (A)**: [Describe current state]  
- Screenshot/Prototype URL: [...]
- Key characteristic: [Contoh: "Export button inside '⋮' overflow menu"]

**Treatment (B)**: [Describe proposed change]  
- Screenshot/Prototype URL: [...]
- Key characteristic: [Contoh: "Export button as primary action in toolbar, icon + label"]

### Success Metric (Primary)

**Metric**: [Contoh: "Click-through rate (CTR) on Export button"]  
**Formula**: `(Export Button Clicks / Report Views) × 100%`  
**Baseline (Control)**: 11.5%  
**Target (Treatment)**: ≥15% (+30% relative lift)  
**Minimum Detectable Effect (MDE)**: 20% relative improvement (13.8% absolute)

### Secondary Metrics (Guardrails)

Track untuk memastikan tidak ada regresi:
- **Bounce Rate**: Tidak boleh meningkat >5%
- **Time to Export**: Tidak boleh meningkat >10%
- **Error Rate**: Tidak boleh meningkat

---

## 4. Sample Size & Duration

**Sample Size Calculation**:
- Tool: [Optimizely Calculator / VWO / Evan's Awesome A/B Tools]
- Input:
  - Baseline conversion rate: 11.5%
  - Minimum detectable effect: 20% relative (13.8% absolute)
  - Statistical power: 80%
  - Significance level (α): 0.05 (two-tailed)
- **Required Sample Size**: ~450 users per variant (900 total)

**Traffic Allocation**: 50/50 split (Control vs Treatment)

**Test Duration**:
- Expected daily traffic: 80 users/day
- Days needed: 900 / 80 = **~12 days**
- Add 1 business cycle buffer: **2 weeks total**
- Start Date: [YYYY-MM-DD]
- End Date: [YYYY-MM-DD]

**Early Stopping Rule**:  
Do NOT stop early unless:
- Treatment shows >95% confidence AND sample size ≥minimum
- Critical bug/regression detected in Treatment

---

## 5. Implementation Checklist

### Pre-Launch
- [ ] Design mockups approved (Control & Treatment)
- [ ] Code implemented with feature flag (`EXPORT_BUTTON_VARIANT`)
- [ ] Analytics event tracking verified:
  - `report_viewed` (trigger: page load)
  - `export_button_clicked` (variant label: A/B)
  - `export_completed` (success confirmation)
- [ ] QA tested both variants (cross-browser, mobile)
- [ ] Randomization logic verified (consistent user assignment)

### During Test
- [ ] Monitor daily: No critical bugs, traffic split 50/50
- [ ] Check guardrail metrics weekly (bounce rate, error rate)
- [ ] Do NOT peek at results before reaching sample size (p-hacking risk)

### Post-Test
- [ ] Calculate statistical significance (chi-square test / z-test)
- [ ] Document results in Section 6
- [ ] Decision: Ship Treatment / Revert to Control / Iterate

---

## 6. Results & Decision (Fill After Test Completes)

**Test Completed**: [YYYY-MM-DD]

### Data Summary

| Variant | Users | Report Views | Export Clicks | CTR | Relative Lift |
| :--- | ---: | ---: | ---: | ---: | ---: |
| Control (A) | — | — | — | —% | Baseline |
| Treatment (B) | — | — | — | —% | —% |

**Statistical Significance**: p = [value], [ ] Significant (p <0.05) [ ] Not Significant

**Confidence Interval (95%)**: Treatment CTR = [X.X% to Y.Y%]

### Secondary Metrics

| Metric | Control | Treatment | Change | Within Guardrail? |
| :--- | ---: | ---: | ---: | :---: |
| Bounce Rate | —% | —% | —% | [ ] Yes [ ] No |
| Time to Export | —s | —s | —% | [ ] Yes [ ] No |
| Error Rate | —% | —% | —% | [ ] Yes [ ] No |

### Qualitative Feedback

[Capture any user comments/support tickets during test period]

---

## 7. Final Decision

**Decision**: [ ] Ship Treatment [ ] Revert to Control [ ] Run Follow-Up Test

**Rationale**:  
[Contoh: "Treatment achieved 16.2% CTR (p=0.003), exceeding target 15%. No guardrail violations. Shipping to 100% users."]

**Follow-Up Actions**:
- [ ] [Action 1, contoh: "Update onboarding tooltip to mention new Export button location"]
- [ ] [Action 2]
- [ ] [Action 3]

**Lessons Learned**:  
[Contoh: "Icon + label outperformed icon-only in toolbar. Apply same pattern to other secondary actions."]

---

## 8. Related Hypotheses (Iteration Chain)

- **Previous Test**: [ABT-XXX: Description]
- **Next Test**: [ABT-XXX: Description, if this test generates new questions]
