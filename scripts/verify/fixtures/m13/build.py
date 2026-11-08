#!/usr/bin/env python3
"""Build an M13 (product operations) project the gate ACCEPTS, then apply exactly one mutation.

M13 is the continuous loop for a self-initiated product, so the base is Delivery: solo, Scale:
Medium - the combination where the gate is enforced rather than waived.

Suspected holes - measured, never assumed:
  metrics-empty        Acquisition / Activation / Retention headings with nothing under them
  metrics-prose-only   sections filled with sentences but not a single figure
  rice-keyword-only    Large scale, backlog mentions "RICE" in prose with no scored row
  delivery-blank       Scale Medium, Delivery missing entirely
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))


def find_repo(start):
    cur = start
    for _ in range(12):
        if os.path.isdir(os.path.join(cur, "templates")):
            return cur
        nxt = os.path.dirname(cur)
        if nxt == cur:
            break
        cur = nxt
    raise SystemExit("templates/ not found above %s" % start)


STATE = """# Project State

- **Project**: Warung Ledger
- **Scale**: %s
- **Delivery**: %s
- **Current module**: M13
"""

METRICS = """# Metrics Baseline Report: Warung Ledger

## 1. Executive Summary

Baseline captured on 2026-11-01, four weeks after launch, from PostHog and Stripe exports.

## 2. Acquisition Metrics

### 2.1 Signups & Traffic Sources

| Week | Signups | Source |
| :--- | :--- | :--- |
| W43 | 128 | organic search 74, referral 31, ads 23 |
| W44 | 151 | organic search 88, referral 39, ads 24 |

## 3. Activation Metrics

### 3.1 Onboarding Completion

141 of 279 signups finished onboarding: 50.5 percent completion within 24 hours.

## 4. Retention Metrics

### 4.1 Cohort Retention Rates

| Cohort | D1 | D7 | D30 |
| :--- | :--- | :--- | :--- |
| W43 | 61% | 34% | 21% |
| W44 | 64% | 36% | 22% |

### 4.2 Churn Analysis

Monthly churn is 5.8 percent; 9 of 155 paying accounts cancelled in October.

## 5. Engagement Metrics

Weekly active accounts 118, median 4 sessions per week.
"""

GROWTH = """# Growth Experiments Backlog: Warung Ledger

**Prioritization Framework**: RICE Score + Strategic Alignment to North Star

## 1. Experiment Queue Overview

| ID | Experiment | Reach | Impact | Confidence | Effort | RICE |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| EXP-001 | Guided first-sale wizard | 279 | 2 | 80% | 3 | 148 |
| EXP-002 | WhatsApp receipt sharing | 118 | 3 | 60% | 2 | 106 |

## 2. Active Experiments (Running Now)

### Experiment #001: Guided first-sale wizard

RICE 148. Started 2026-10-28, measuring onboarding completion over two weeks.
"""


def build(dest, kind):
    def w(rel, text):
        p = os.path.join(dest, rel)
        os.makedirs(os.path.dirname(p) or dest, exist_ok=True)
        with open(p, "w", encoding="utf-8") as fh:
            fh.write(text)

    metrics, growth = METRICS, GROWTH
    scale, delivery = "Medium", "solo"

    if kind == "metrics-empty":
        start = metrics.index("## 2. Acquisition Metrics")
        end = metrics.index("## 5. Engagement Metrics")
        metrics = metrics[:start] + (
            "## 2. Acquisition Metrics\n\n## 3. Activation Metrics\n\n## 4. Retention Metrics\n\n"
        ) + metrics[end:]
    elif kind == "metrics-prose-only":
        start = metrics.index("## 2. Acquisition Metrics")
        end = metrics.index("## 5. Engagement Metrics")
        metrics = metrics[:start] + (
            "## 2. Acquisition Metrics\n\nTraffic came mostly from organic search and referrals during the launch weeks.\n\n"
            "## 3. Activation Metrics\n\nOnboarding completion looked reasonable compared with similar products.\n\n"
            "## 4. Retention Metrics\n\nRetention held steady across both cohorts we observed.\n\n"
        ) + metrics[end:]
    elif kind == "rice-keyword-only":
        scale = "Large"
        growth = """# Growth Experiments Backlog: Warung Ledger

**Prioritization Framework**: RICE Score + Strategic Alignment to North Star

## 1. Experiment Queue Overview

We will prioritise experiments using the RICE framework once we have more traffic.
"""
    elif kind == "delivery-blank":
        delivery = ""
    elif kind != "base":
        raise SystemExit("unknown kind: %s" % kind)

    w("docs/pm/PROJECT_STATE.md", STATE % (scale, delivery if delivery else " "))
    w("docs/analytics/METRICS_BASELINE_REPORT.md", metrics)
    if scale == "Large":
        w("docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md", growth)


if __name__ == "__main__":
    build(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else "base")
    print("built", sys.argv[2] if len(sys.argv) > 2 else "base")
