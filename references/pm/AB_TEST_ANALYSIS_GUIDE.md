# A/B Test Analysis & Experimentation Guide for Solo Devs & PMs

> Reference guide for statistical rigor, sample size validation, Sample Ratio Mismatch (SRM) detection, guardrail verification, and structured launch decisions (**Ship, Investigate, Extend, Stop, Don't Ship**).
> Companion to **Module 13: Product Operations & Iteration** (`docs/modules/13_PRODUCT_OPERATIONS_ITERATION.md`) and CLI tool `scripts/runtime/analyze_ab_test.py`.

---

## 1. Experimentation Philosophy for Solo Developers

As a solo developer or lean product team, engineering bandwidth is your scarcest asset. Building the wrong features or shipping variants based on noisy data incurs massive opportunity costs and code bloat.

### Core Principles
1. **Statistical Rigor Over Intuition**: Never call a winner because "Variant looks higher after 3 days." Flukes, weekday/weekend seasonality, and novelty effects produce false positives.
2. **First Do No Harm (Guardrails First)**: A 15% increase in signup completion is worthless if it crashes Day-30 retention or doubles P95 server latency.
3. **Protect Experiment Integrity**: Check for Sample Ratio Mismatch (SRM) before looking at conversion rates. An experiment with corrupted traffic allocation is invalid.
4. **Instant Kill Switches**: Never launch an experiment without dynamic feature flag gating. Degraded variants must be reverted in `< 5 minutes` without a redeployment.
5. **Decisive Outcomes**: Every test terminates in one of five distinct decisions: **Ship**, **Investigate**, **Extend**, **Stop**, or **Don't Ship**.

---

## 2. The 5-Stage A/B Test Evaluation Pipeline

```text
[ STAGE 1: Experiment Context ]
   - Measurable hypothesis, primary metric, guardrails, target MDE
         │
         ▼
[ STAGE 2: Test Setup & Validity Checks ]
   - Duration ≥ 7–14 days (full business cycles)
   - SRM Chi-Square Test (p_SRM ≥ 0.001)
   - Sample size & statistical power validation (Power ≥ 80%, conv ≥ 100/var)
         │
         ▼
[ STAGE 3: Statistical & Practical Significance ]
   - Conversion rates, relative lift %, standard error, Z-score
   - Two-tailed p-value (threshold: p < 0.05)
   - 95% Confidence Interval [CI_lower, CI_upper]
   - Practical significance (Lift ≥ Minimum Detectable Effect)
         │
         ▼
[ STAGE 4: Guardrail Metrics Audit ]
   - Secondary metrics: Revenue, engagement, P95 response time, churn, support load
   - Flag any degraded metrics
         │
         ▼
[ STAGE 5: Structured Product Decision ]
   - Ship it / Investigate / Extend / Stop / Don't ship
```

---

## 3. Detailed Stage Breakdown

### Stage 1: Experiment Context & Hypothesis Framing

Every experiment must begin with a falsifiable, measurable hypothesis:

```
We believe that [CHANGE]
will result in [IMPACT]
for [TARGET SEGMENT]
because [RATIONALE / USER INSIGHT].

We will measure success by [PRIMARY METRIC & THRESHOLD]
without harming [GUARDRAIL METRICS].
```

**Parameters to Declare Upfront**:
- **Primary Metric**: The single north-star metric the test aims to move (e.g., Signup Completion Rate).
- **Minimum Detectable Effect (MDE)**: The smallest relative lift that economically justifies maintaining the feature (e.g., $+10\%$ relative lift).
- **Traffic Allocation**: Target split between Control and Variant (typically 50/50).
- **Significance Level ($\alpha$)**: Standard $0.05$ (95% confidence).
- **Statistical Power ($1 - \beta$)**: Standard $0.80$ (80% probability of detecting a real effect).

---

### Stage 2: Test Setup & Validity Checks

Before interpreting results, validate that the test conditions did not corrupt the data.

#### 1. Test Duration & Business Cycles
- **Minimum Duration**: **1 to 2 full weeks (7 to 14 days)**.
- **Why**: User behaviour varies between weekdays and weekends. A 3-day test starting Friday will skew results.
- **Novelty Effect Washout**: Returning users often click new elements purely because they are new (or avoid them due to disrupted habits). Running 14 days allows novelty bias to settle.

#### 2. Sample Ratio Mismatch (SRM) Detection
Sample Ratio Mismatch occurs when the actual proportion of users assigned to variants differs significantly from the expected allocation.
- **Common Causes**: Cache poisoning, redirection delays, ad blocker interference, bot traffic skew, or broken randomization hashing.
- **Detection Method**: Chi-Square Goodness-of-Fit test with 1 degree of freedom:
  $$\chi^2 = \frac{(O_c - E_c)^2}{E_c} + \frac{(O_v - E_v)^2}{E_v}$$
  Where $O$ is observed count, $E$ is expected count ($Total \times Split$).
- **Rule**: If $p_{SRM} < 0.001$, **the experiment is compromised**. Do not trust conversion numbers. Halt and fix the allocation bug.

#### 3. Sample Size & Power Calculation
An underpowered test cannot reliably distinguish between a true uplift and random noise:
$$n_{\text{per variant}} = \frac{2 \cdot (Z_{\alpha/2} + Z_{\beta})^2 \cdot p \cdot (1 - p)}{\Delta_{\text{abs}}^2}$$
- For $\alpha = 0.05$ ($Z_{\alpha/2} = 1.96$) and Power $= 80\%$ ($Z_\beta = 0.8416$):
  $$(Z_{\alpha/2} + Z_\beta)^2 \approx 7.849$$
- **Hard Floor for Solo Devs**: A test with $< 100$ conversions per variant is underpowered. Never execute sweeping architectural or product redesigns based on underpowered samples.

---

### Stage 3: Statistical & Practical Significance

#### Mathematical Formulations

1. **Conversion Rates**:
   $$p_c = \frac{\text{Conversions}_c}{N_c}, \quad p_v = \frac{\text{Conversions}_v}{N_v}$$

2. **Absolute Lift & Relative Lift**:
   $$\Delta_{\text{abs}} = p_v - p_c, \quad \text{Lift}_{\text{rel}} = \frac{p_v - p_c}{p_c} \times 100\%$$

3. **Standard Error (Unpooled Difference)**:
   $$SE = \sqrt{\frac{p_c (1 - p_c)}{N_c} + \frac{p_v (1 - p_v)}{N_v}}$$

4. **Z-Score & Two-Tailed p-value**:
   $$Z = \frac{\Delta_{\text{abs}}}{SE}$$
   $$p\text{-value} = 2 \cdot (1 - \Phi(|Z|))$$
   Where $\Phi$ is the cumulative standard normal distribution.

5. **95% Confidence Interval**:
   $$CI_{\text{abs}} = \Delta_{\text{abs}} \pm 1.96 \cdot SE$$
   $$CI_{\text{rel}} = \frac{CI_{\text{abs}}}{p_c} \times 100\%$$

#### Statistical vs. Practical Significance
- **Statistical Significance ($p < 0.05$)**: The observed difference is very unlikely to be random noise.
- **Practical Significance**: The magnitude of lift meets or exceeds the business-justified threshold ($\text{Lift} \ge \text{MDE}$). A $+0.2\%$ lift that is statistically significant ($p = 0.01$) on 500,000 visitors is useless if it adds $2/month but introduces technical complexity.

---

### Stage 4: Guardrail Metrics Health Check

Guardrail metrics ensure the primary win did not create hidden regressions.

| Guardrail Category | Target Threshold | Degradation Action |
|:---|:---|:---|
| **Revenue / ARPU** | $\ge$ Control baseline | Flag if revenue per user drops > 2% |
| **P95 Latency / Performance** | $\le 500\text{ms}$ or $\le$ Control $+10\%$ | Flag if variant introduces UI lag or slow queries |
| **7-Day / 30-Day Churn** | No statistically significant increase | Flag if activation rises but 14-day churn spikes |
| **Error Rate (Sentry / Logs)** | $< 0.1\%$ | Flag if variant throws unhandled client exceptions |
| **Support Ticket Volume** | No significant spike | Flag if users report confusion or broken workflows |

---

### Stage 5: Structured Product Decision Matrix

Translate findings directly into product execution:

| Test Outcome | Recommendation | Action Plan |
|:---|:---:|:---|
| **SRM Detected** ($p_{SRM} < 0.001$) | **Stop & Invalidate** | Halt test immediately; debug tracking scripts/router; discard results. |
| **Duration < 7 Days** | **Extend the test** | Keep running until minimum 1–2 weekly cycles complete. |
| **Significant Positive Lift** ($p < 0.05$), Guardrails Clean | **Ship it (100% Rollout)** | Roll out to 100% via feature flag; delete control branch; update baseline. |
| **Significant Positive Lift** ($p < 0.05$), Guardrail Degraded | **Investigate** | Do not ship; conduct trade-off review with stakeholders; resolve secondary friction. |
| **Significant Negative Lift** ($p < 0.05$, Lift $< 0$) | **Don't ship** | Immediately toggle kill switch to revert; document post-mortem. |
| **Not Significant**, Positive Trend, Underpowered | **Extend the test** | Continue test until sample size reaches power target (max 30 days). |
| **Not Significant**, Flat / Inconclusive, Adequately Powered | **Stop the test** | Kill variant; remove flag; preserve engineering bandwidth for higher RICE items. |

---

## 4. Automation: The Analyzer CLI Tool

`solo-project-lifecycle` includes an executable standard library Python tool:
`scripts/runtime/analyze_ab_test.py`

### 1. Summary Statistics Mode
When you have total visitors and conversion counts:

```bash
python scripts/runtime/analyze_ab_test.py \
  --test-name "Streamlined Checkout v2" \
  --hypothesis "1-step checkout increases conversion without hurting revenue" \
  --duration-days 14 \
  -cu 2500 -cc 250 \
  -vu 2520 -vc 320 \
  --mde 10.0 \
  --guardrail "P95 Latency:210ms:218ms:PASS" \
  --guardrail "ARPU:$14.20:$14.15:PASS" \
  --guardrail "Refund Rate:1.1%:1.2%:PASS"
```

### 2. Guardrail Degradation Check

```bash
python scripts/runtime/analyze_ab_test.py \
  --test-name "Aggressive Paywall Modal" \
  -cu 3000 -cc 150 \
  -vu 2980 -vc 220 \
  --guardrail "Day-7 Retention:42%:28%:FAIL" \
  --guardrail "Support Tickets:12:48:FAIL"
```

### 3. Raw Event CSV Ingestion Mode
Accepts CSV files with headers `user_id`, `variant` (`control` or `variant`), and `converted` (`0` or `1`):

```bash
python scripts/runtime/analyze_ab_test.py \
  --csv data/experiments/exp_002_raw.csv \
  --test-name "Pricing Page Monthly vs Annual" \
  --mde 8.0
```

### 4. JSON Output for CI/CD or Automated Dashboards

```bash
python scripts/runtime/analyze_ab_test.py -cu 1000 -cc 100 -vu 1000 -vc 140 --json
```

---

## 5. Experiment Artifacts & Logging

Log all experiment results in the project repository to build an organizational learning repository:

1. **Hypothesis Document**: Created during M04 / M13 using `templates/02-design/AB_TEST_HYPOTHESIS_TEMPLATE.md`.
2. **Analysis Report**: Filed in `docs/experiments/YYYY-MM-TEST-NAME.md` using `templates/09-product-growth/AB_TEST_REPORT_TEMPLATE.md`.
3. **Continuous Backlog**: Updated in `docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md`.

---

## 6. Checklist: Pre-Flight to Rollout

- [ ] **Pre-Flight**:
  - [ ] Hypothesis declared with measurable primary metric and target MDE.
  - [ ] Guardrail metrics identified with regression thresholds.
  - [ ] Feature flag created with instant kill switch (`< 5 min` rollback).
  - [ ] Flag expiration date scheduled in `TODO.md` (no permanent dead code).
- [ ] **Execution**:
  - [ ] Traffic split verified at 50/50 without Sample Ratio Mismatch.
  - [ ] Test allowed to run for at least 7 to 14 days (minimum 1–2 full business cycles).
- [ ] **Analysis**:
  - [ ] Analysis executed via `scripts/runtime/analyze_ab_test.py`.
  - [ ] SRM checked ($p_{SRM} \ge 0.001$).
  - [ ] Statistical significance evaluated at $p < 0.05$.
  - [ ] Guardrails verified with zero regressions.
  - [ ] Final recommendation chosen (**Ship / Investigate / Extend / Stop / Don't ship**).
- [ ] **Post-Launch**:
  - [ ] Report documented in `docs/experiments/`.
  - [ ] Losing variant code deleted; winning code refactored into the primary codebase.
  - [ ] Feature flag archived and removed.
