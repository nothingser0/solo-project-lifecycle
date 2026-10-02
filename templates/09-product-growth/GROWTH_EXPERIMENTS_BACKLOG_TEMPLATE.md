# Growth Experiments Backlog: [Product Name]

**Product**: [Product Name]  
**Owner**: [Solo Developer Name]  
**Last Updated**: [YYYY-MM-DD]  
**Experiment Velocity Target**: 2-4 experiments per month

---

## 1. Experiment Queue Overview

**Current Status** (as of [Date]):
- **Running**: [X] experiments
- **Queued**: [X] experiments
- **Completed**: [X] experiments (lifetime)
- **Win Rate**: [X]% (experiments that beat control)

**Prioritization Framework**: RICE Score + Strategic Alignment to North Star Metric

---

## 2. Active Experiments (Running Now)

### Experiment #001: [Experiment Name]

**Status**: 🟢 Running  
**Start Date**: [YYYY-MM-DD]  
**Expected End Date**: [YYYY-MM-DD] (minimum 2 weeks or 100 conversions per variant)  
**Owner**: [Name]

#### Hypothesis
```
We believe that [CHANGE/INTERVENTION]
will result in [EXPECTED IMPACT with quantitative estimate]
for [TARGET SEGMENT]
because [RATIONALE/THEORY].

We will measure success by [PRIMARY METRIC + threshold].
```

**Example**:
```
We believe that adding social proof badges ("1,234 users love this feature")
will result in 15% increase in feature adoption rate
for new users in their first 7 days
because users trust features validated by peers (Nielsen Norman Group social proof study).

We will measure success by tracking "feature_used" event for Day 1-7 cohort, 
target: control 30% → treatment 35%+ (relative lift ≥15%).
```

#### Experiment Design

| Parameter | Detail |
| :--- | :--- |
| **Type** | A/B Test / Multivariate / Holdout |
| **Traffic Allocation** | 50% control / 50% treatment (or specify split) |
| **Sample Size Needed** | [X] users per variant (use sample size calculator) |
| **Statistical Significance Target** | 95% confidence, 80% power |
| **Guardrail Metrics** | [Metrics that should NOT degrade, e.g., "signup conversion rate > 2%"] |

#### Metrics Tracked

| Metric Type | Metric Name | Control Baseline | Treatment Target | Actual (Treatment) |
| :--- | :--- | ---: | ---: | ---: |
| **Primary** | [Metric name] | [baseline value] | [target value] | [current value] |
| **Secondary** | [Metric name] | [baseline value] | [target value] | [current value] |
| **Guardrail** | [Metric name] | [baseline value] | Must stay ≥ [threshold] | [current value] |

#### Implementation Details

**Changes Made**:
- [Technical change 1, e.g., "Added <Badge> component to feature cards"]
- [Technical change 2, e.g., "Updated copy in email Day 3 reminder"]

**Feature Flag**: `experiment_social_proof_badges` (LaunchDarkly / Posthog / Custom)

**Rollback Plan**: If guardrail metric drops > 10%, immediately set flag to 100% control.

#### Current Results (Interim Check)

**Days Running**: [X] days  
**Users per Variant**: Control: [X], Treatment: [X]  
**Statistical Significance**: [X]% confidence (need 95%+)

**Early Signal**: 🟢 Treatment leading / 🟡 Inconclusive / 🔴 Control leading

**Decision**: ⏳ Continue / ✅ Ship treatment / ❌ Kill treatment / 🔄 Iterate

---

### Experiment #002: [Second Experiment Name]

[Repeat the same structure for other active experiments]

---

## 3. Queued Experiments (Prioritized Backlog)

Experiments are ordered by **Priority Score** (RICE or Expected Lift × Ease).

### Experiment #003: [Experiment Name]

**Status**: 📋 Queued (Target Launch: [Date])  
**Priority Score**: [Score] (Rank: #1 in backlog)

#### Hypothesis (Draft)
```
We believe that [CHANGE]
will result in [IMPACT]
for [SEGMENT]
because [RATIONALE].

Success metric: [METRIC + threshold].
```

#### RICE Breakdown

| Component | Score | Reasoning |
| :--- | ---: | :--- |
| **Reach** | [X] users/quarter | [How many users affected] |
| **Impact** | [0.25/0.5/1/2/3] | [Minimal/Low/Medium/High/Massive impact per user] |
| **Confidence** | [X]% | [How confident in estimates] |
| **Effort** | [X] person-days | [Development + QA + analysis time] |
| **RICE Score** | **(Reach × Impact × Confidence) / Effort** | **= [Final Score]** |

#### Why This Matters (Strategic Alignment)
- **North Star Metric Impact**: [Explain how this experiment contributes to the North Star Metric from M00]
- **Strategic Pillar**: [Link to strategic pillar from M00, e.g., "Increase Activation"]

#### Pre-requisites (Blockers)
- [ ] [Blocker 1, e.g., "Need event tracking for feature_X_clicked"]
- [ ] [Blocker 2, e.g., "Waiting for design mockup from Figma"]

---

### Experiment #004: [Experiment Name]

**Status**: 📋 Queued  
**Priority Score**: [Score] (Rank: #2)

[Repeat the same structure]

---

### Experiment #005: [Experiment Name]

**Status**: 📋 Queued  
**Priority Score**: [Score] (Rank: #3)

[Repeat the same structure]

---

## 4. Completed Experiments (Learning Repository)

### Experiment #XXX: [Experiment Name] ✅ Win

**Run Date**: [Start] – [End] ([X] days)  
**Result**: 🎉 **Treatment Won** (shipped to 100%)

#### Final Results

| Metric | Control | Treatment | Lift | Statistical Significance |
| :--- | ---: | ---: | ---: | ---: |
| **[Primary Metric]** | [value] | [value] | **+[X]%** | 98% ✅ |
| **[Secondary Metric]** | [value] | [value] | +[X]% | 95% ✅ |
| **[Guardrail Metric]** | [value] | [value] | [X]% | Safe ✅ |

#### Key Learnings
1. **What Worked**: [Insight 1, e.g., "Social proof most effective for enterprise tier users (+22% vs +8% for starter tier)"]
2. **What Worked**: [Insight 2, e.g., "Badge placement above-the-fold critical (fold placement had no effect)"]
3. **Unexpected Finding**: [e.g., "Mobile users responded better than desktop (+18% vs +12%)"]

#### Follow-up Actions
- [x] Shipped to 100% production (2026-09-15)
- [ ] Document in product changelog
- [ ] Share learning in weekly metrics review
- [ ] Consider variant for mobile-specific optimization

---

### Experiment #XXX: [Experiment Name] ❌ Loss

**Run Date**: [Start] – [End] ([X] days)  
**Result**: 💡 **Control Won** (treatment killed)

#### Final Results

| Metric | Control | Treatment | Lift | Statistical Significance |
| :--- | ---: | ---: | ---: | ---: |
| **[Primary Metric]** | [value] | [value] | **-[X]%** | 96% ✅ (significant loss) |

#### Key Learnings (Why It Failed)
1. **Hypothesis Was Wrong**: [e.g., "Users didn't care about gamification points, found it gimmicky"]
2. **Poor Execution**: [e.g., "UI placement was confusing, covered CTA button"]
3. **Segment Mismatch**: [e.g., "B2B users don't respond to consumer-style incentives"]

#### What We'd Do Differently
- [Learning 1 for future experiments]
- [Learning 2 for future experiments]

**Still Valuable**: Failed experiments teach us what NOT to do. Document thoroughly.

---

### Experiment #XXX: [Experiment Name] 🤷 Neutral

**Run Date**: [Start] – [End]  
**Result**: 🤷 **No Significant Difference** (killed due to no impact)

#### Final Results
No statistically significant difference detected after [X] days. Possible reasons:
- Sample size too small (underpowered)
- Change too subtle to detect
- Metric not sensitive enough

**Decision**: Killed. Not worth engineering effort to maintain.

---

## 5. Icebox (Ideas Not Yet Prioritized)

Low-priority ideas or experiments that need more refinement before queuing.

### Idea: [Idea Name]
- **Description**: [1-2 sentences]
- **Expected Impact**: [Vague estimate]
- **Why Icebox**: [e.g., "Need more user research", "Too complex for current bandwidth", "Not aligned with Q4 OKR"]

---

### Idea: [Idea Name]
[Repeat structure]

---

## 6. Experiment Velocity Tracking

**Goal**: Launch 2-4 experiments per month (sustainable for solo dev).

| Month | Launched | Completed | Win Rate | Avg Setup Time | Notes |
| :--- | ---: | ---: | ---: | ---: | :--- |
| Jan 2026 | 2 | 1 | 100% | 3 days | Good month |
| Feb 2026 | 3 | 2 | 50% | 4 days | One experiment underpowered |
| Mar 2026 | 1 | 3 | 67% | 2 days | Focused on shipping wins |
| **Q1 Total** | **6** | **6** | **67%** | **3 days avg** | - |

**Learnings**:
- Setup time improving (4 days → 2 days) as we templatize experiment process.
- Win rate 67% is healthy (means we're taking calculated risks, not playing it too safe).

---

## 7. Experiment Playbook (Quick Reference)

### Sample Size Calculator
Use online calculator: [https://www.evanmiller.org/ab-testing/sample-size.html](https://www.evanmiller.org/ab-testing/sample-size.html)

**Input**:
- Baseline conversion rate: [X]%
- Minimum detectable effect: [X]% (relative lift)
- Statistical power: 80%
- Significance level: 95%

**Output**: Need [X] users per variant.

### When to Stop Experiment Early

**Stop for Win**:
- ✅ Statistical significance reached (95%+) AND
- ✅ Minimum sample size met AND
- ✅ Running for at least 1 full week (to capture day-of-week effects) AND
- ✅ Guardrail metrics safe

**Stop for Loss**:
- ❌ Treatment significantly worse (95% confidence) AND guardrail metrics at risk

**Never Stop Early**:
- 🚫 "Peeking" at results daily and stopping when it looks good (causes false positives)
- 🚫 Before minimum sample size reached (underpowered)

### Common Pitfalls to Avoid

1. **Novelty Effect**: New UI gets clicks just because it's new. Run for 2+ weeks.
2. **Seasonality**: Don't compare weekday vs weekend data, or holiday vs normal periods.
3. **Multiple Testing**: If running 20 experiments, 1 will show false positive by chance (at 95% confidence). Adjust significance threshold (Bonferroni correction) or prioritize clear wins.
4. **Proxy Metrics**: Make sure you're measuring the right thing (clicks ≠ value delivered).

---

## 8. Experiment Templates (Copy-Paste)

### A/B Test Template
```markdown
### Experiment #XXX: [Name]
**Hypothesis**: We believe [change] will result in [impact] for [segment] because [rationale].
**Primary Metric**: [metric + threshold]
**Design**: 50/50 split, 2 weeks, 95% confidence
**Sample Size**: [X] per variant
**Feature Flag**: `experiment_[name]`
```

### Feature Flag Code Snippet
```typescript
// Example: Posthog feature flag check
const showSocialProof = posthog.isFeatureEnabled('experiment_social_proof_badges');

if (showSocialProof) {
  return <FeatureCardWithBadge />;
} else {
  return <FeatureCardOriginal />;
}
```

---

**Next Review**: [Next backlog review date, typically every 2 weeks]

**Approved by**: [Solo Developer Name]  
**Date**: [YYYY-MM-DD]
