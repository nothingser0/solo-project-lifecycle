# Module 13: Product Operations & Continuous Iteration

> **Templates to copy**: `templates/09-product-growth/AB_TEST_REPORT_TEMPLATE.md` · `METRICS_BASELINE_REPORT_TEMPLATE.md` · `GROWTH_EXPERIMENTS_BACKLOG_TEMPLATE.md`
> 📖 **Optional** (do NOT preload): `references/pm/PM_PRIORITIZATION_FRAMEWORKS.md` · `references/pm/PM_CONTINUOUS_IMPROVEMENT_GUIDE.md` · `deep-dives/13_PRODUCT_OPERATIONS_ITERATION.md` (retention/churn SQL, NPS snippets, RICE worked examples, OKR templates, benchmarks)

> **RICE scoring (inline — no need to open the PM guide)**:
> `Score = (Reach × Impact × Confidence) / Effort` · Reach = users/quarter affected · Impact = 0.25 minimal / 0.5 low / 1 medium / 2 high / 3 massive · Confidence = 100% high / 80% medium / 50% low · Effort = person-weeks. Higher score = do first.

Post-launch stage after M12: shift from "building" to "optimizing & growing" on real user data via a **metrics-driven operational framework**.

---

## 1. Execution Cycle (Condensed)

```text
[ INPUT: Stable production system + first 30 days of user data ]
  → STEP 1: Metrics baseline — 30-day collection; Mean/Median/P50–P95; benchmark compare; anomaly alerts
  → STEP 2: Feedback loop — NPS (Day 7/30/Quarterly); in-app widget; tickets → FAQ
  → STEP 3: Cohorts — Day 1/7/30/90 retention; Power/Casual/At-Risk/Churned segments; churn signals
  → STEP 4: RICE prioritization — Reach × Impact × Confidence / Effort; ROI; opportunity cost
  → STEP 5: Experiments backlog — hypothesis format (M04); lift × ease queue; 2–4/month; learning repo
  → STEP 6: Health monitoring — weekly standup; monthly OKR vs North Star (M00); quarterly roadmap; annual refresh
  → STEP 7: Scaling signals — P95 > 500ms; query > 100ms/N+1; cost per active user; solo overload > 60 h/wk
  → OUTPUT: 4 ops documents + 1 reference guide
```

## 2. Product Operations ≠ DevOps

Not uptime/deploy speed — the **quality of product decisions from data**. Dev metrics (coverage, build time, deploy frequency) → product metrics (retention, adoption, NPS, revenue/user); sprints → continuous dynamic iteration; success = feature moves business metrics. **Golden principle**: every feature decision answers *"Which metric will move if this feature succeeds?"*

## 3. Step-by-Step (SQL, snippets & examples in deep dive)

1. **Baseline** (≥30 days live): Acquisition (signups/sources), Activation (% onboarded / first core action ≤24 h), Retention (Day 1/7/30/90), Revenue (MRR/ARPU/LTV), Engagement (DAU/MAU), Performance (P95, error rate). P95 = SLA threshold. Benchmarks: B2B SaaS Day-30 retention 25–40%, NPS 30–50. Below benchmark → prioritize onboarding/activation. Alert on DAU drop > 30% vs 30-day baseline.
2. **Feedback loop**: NPS = % Promoters − % Detractors, automated at Day 7/30/Quarterly; Canny/Fider widget; > 5 identical tickets → FAQ or UX fix.
3. **Cohorts**: weekly signup cohorts; Power Users (top 10% → advisory board, beta, testimonials), At-Risk (inactive > 14 days consumer / > 7 days daily-tools → win-back), Churned (> 60 days or canceled). Signals: activity drop > 50%, activation milestone never reached.
4. **RICE**: `(Reach × Impact × Confidence) / Effort` (Impact 0.25–3; Confidence 50/80/100%). ROI = (incremental revenue − cost)/cost → payback < 6 months. Mandatory opportunity-cost questions. Quadrants: Do First / Schedule / Delegate / Drop.
5. **Experiments**: hypothesis — *"We believe [CHANGE] → [IMPACT] for [SEGMENT] because [RATIONALE]; measured by [METRIC & THRESHOLD]"*. Queue by lift × ease + North Star alignment. Velocity 2–4/month; log win/lose/neutral in `docs/experiments/`.
6. **Health cadence**: weekly 15-min (signups, activation, D7 retention, MRR vs churn, errors/latency); monthly OKR vs North Star; quarterly Double Down / Pivot / Kill (< 5% adoption after 3 months → deprecate); annual strategy refresh vs M00.
7. **Scaling**: P95 > 500ms / query > 100ms / N+1 / CPU > 80% → indexing audit, Redis, CDN, scale out. DB > 1M rows unpartitioned, backup > 30 min → indexes/partitioning. `CAU = infra cost / MAU` (< $1 consumer, < $10 B2B). Overload (> 60 h/wk, tickets > 48 h unanswered) → VA/support, freelance dev, or co-founder.

## 4. Scale & Termination Rules

Small → **M13 WAIVED** (ends M12). Client/Freelance/Internal → **WAIVED** (ends M11/M12). Solo SaaS → **mandatory continuous loop**. Large → mandatory + RICE backlog (daily dashboards, 2–4 experiments). Enterprise → A00/A04. The gate validator enforces this automatically.

## 5. Deliverables

`docs/analytics/` for metrics, `docs/pm/` for ops docs:
1. **`docs/analytics/METRICS_BASELINE_REPORT.md`** — 30-day baseline; must document **Acquisition + Activation + Retention** pillars with actual measurements.
2. **`docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md`** — RICE-scored backlog + results (mandatory Large).
3. **`docs/pm/PRODUCT_HEALTH_DASHBOARD.md`** — weekly/monthly/quarterly reviews.
4. **`docs/pm/SCALING_SIGNALS.md`** — infra/team thresholds & triggers.
5. **`references/pm/PM_CONTINUOUS_IMPROVEMENT_GUIDE.md`**, **`references/pm/PM_PRIORITIZATION_FRAMEWORKS.md`**.

## 6. [GATE] Exit Criteria

- [ ] 30-day baseline documented (`METRICS_BASELINE_REPORT.md`).
- [ ] Feedback loop active (NPS scheduled, widget live, tickets aggregated).
- [ ] Cohort analysis executed ≥ 1x/month; backlog RICE-prioritized (`GROWTH_EXPERIMENTS_BACKLOG.md`).
- [ ] ≥ 1 experiment launched with documented results; weekly review run ≥ 4 consecutive weeks.
- [ ] Scaling signals monitored (performance, cost, workload).

## 7. Module Integration

M00 North Star anchors OKRs & prioritization · M01 OKRs reviewed monthly · M04 hypothesis format reused · M06 §6A analytics feed cohorts · M10 performance metrics feed scaling · M12 incidents feed improvements.

---

## 🔄 CONTINUOUS ITERATION PROTOCOL

### STEP 0 — File Existence (BLOCKING)
`test -f docs/analytics/METRICS_BASELINE_REPORT.md` AND `test -f docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md` (waived paths per §4 accept absence). Missing on a required path → **STOP**, report `CRITICAL ERROR: File METRICS_BASELINE_REPORT.md or GROWTH_EXPERIMENTS_BACKLOG.md was not created. Module 13 INCOMPLETE - continuous iteration setup FAILED.` END TURN.

### STEP 1 — Content Validation
Baseline has Acquisition + Activation + Retention pillars (no placeholders); backlog is RICE-scored (no placeholders); feedback loop active; weekly ritual established. **This module is never finished** — refresh artifacts quarterly while the product is active.

### STEP 2 — Gate Verification (MANDATORY)

```
[PASTE RAW OUTPUT OF: ./scripts/gates/validate-gate.sh M13]
```

Execute `./scripts/gates/validate-gate.sh M13` (or `.ps1`). Exit 1 = incomplete; fix and re-run before declaring the loop active.

### STEP 3 — Continuous Loop
Pivot/sunset decisions go to `docs/pm/PRODUCT_LIFECYCLE_DECISION.md` with supporting M13 metrics.

**COMPLETE PRODUCT LIFECYCLE**: M00 → … → M12 → **M13 (Continuous Loop)** → (Pivot/Scale/Sunset Decision).
