#!/usr/bin/env python3
"""Build an A03 (vendor procurement) project the gate ACCEPTS, then mutate one thing.

Shape follows templates/03-governance/VENDOR_PROCUREMENT_SCHEDULE_TEMPLATE.md and
VENDOR_COMPARISON_MATRIX.md: vendors appear as COLUMN HEADERS in the comparison tables, and the
recommendation sits under "## Recommendation".

Suspected holes - each measured, never assumed:
  rec-empty            "## Recommendation" heading with nothing under it
  rec-unknown-vendor   recommendation names a vendor that is in no comparison column
  matrix-scores-only   two rows that carry a number but no criteria or vendor columns
  sections-empty       Procurement Scope / Requirements with no content
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))

SCHEDULE = """# Vendor Procurement Schedule

## Procurement Scope

| Item | In scope | Notes |
| :--- | :---: | :--- |
| Implementation vendor | yes | builds and operates the system |
| Managed infrastructure | yes | cloud, database, queue |
| Payment gateway | yes | merchant account, settlement |
| Security assessment | yes | third-party penetration test |

## Timeline

| # | Stage | Start | Decision gate | Owner | Blocks |
| :-: | :--- | :--- | :--- | :--- | :--- |
| 1 | Requirements finalised | 2026-11-10 | written requirements signed off | Damar Wicaksono | 2 |
| 2 | Vendor shortlist | 2026-11-17 | three vendors pass must-haves | Damar Wicaksono | 3 |
| 3 | Contract signed | 2026-12-01 | legal review complete | Ayu Lestari | 4 |

## Requirements

### Mandatory (a vendor failing any of these is disqualified)

| Requirement | Rationale |
| :--- | :--- |
| SOC 2 Type II | the client's audit requires it |
| 99.9% SLA | the ledger cannot lose a business day |

### Scored (weighted in the comparison matrix)

| Requirement | Weight |
| :--- | :-: |
| Settlement latency | 30% |
| Reconciliation tooling | 25% |
| Support responsiveness | 20% |
"""

MATRIX = """# Vendor Comparison Matrix

## Comparison Framework

### Must-Have Requirements (Pass/Fail)

| Requirement | Midtrans | Xendit | Adyen |
|:---|:---|:---|:---|
| Indonesia merchant licence | yes | yes | no |
| SOC 2 certified | no | yes | yes |
| 99.9% SLA | yes | yes | yes |

### Weighted Scoring (100 points)

| Criteria | Weight | Midtrans | Xendit | Adyen |
|:---|:---|:---|:---|:---|
| **Settlement latency** | 30% | 8/10 | 9/10 | 7/10 |
| **Reconciliation tooling** | 25% | 6/10 | 9/10 | 8/10 |
| **Support responsiveness** | 20% | 7/10 | 8/10 | 9/10 |

## Decision Matrix

| Criteria | Weight | Midtrans | Xendit | Adyen |
|:---|:---|:---|:---|:---|
| Weighted total | 100% | 71 | 87 | 79 |

## Recommendation

**Primary Recommendation**: Xendit, with Midtrans retained as the fallback if Xendit's sandbox
onboarding slips past 2026-11-24.
"""


def build(dest, kind):
    def w(rel, text):
        p = os.path.join(dest, rel)
        os.makedirs(os.path.dirname(p) or dest, exist_ok=True)
        with open(p, "w", encoding="utf-8") as fh:
            fh.write(text)

    sched, matrix = SCHEDULE, MATRIX

    if kind == "rec-empty":
        start = matrix.index("## Recommendation")
        matrix = matrix[:start] + "## Recommendation\n"
    elif kind == "rec-unknown-vendor":
        matrix = matrix.replace(
            "**Primary Recommendation**: Xendit, with Midtrans retained as the fallback if Xendit's sandbox\nonboarding slips past 2026-11-24.",
            "**Primary Recommendation**: Razorpay, chosen on a referral from a friend at another bank.")
    elif kind == "matrix-scores-only":
        start = matrix.index("## Comparison Framework")
        end = matrix.index("## Recommendation")
        matrix = matrix[:start] + (
            "## Comparison Framework\n\n## Decision Matrix\n\n"
            "| Score |\n| :--- |\n| 87 |\n| 79 |\n\n"
        ) + matrix[end:]
    elif kind == "sections-empty":
        start = sched.index("## Procurement Scope")
        end = sched.index("## Timeline")
        sched = sched[:start] + "## Procurement Scope\n\n" + sched[end:]
    elif kind != "base":
        raise SystemExit("unknown kind: %s" % kind)

    w("docs/procurement/VENDOR_PROCUREMENT_SCHEDULE.md", sched)
    w("docs/governance/VENDOR_COMPARISON_MATRIX.md", matrix)
    w("docs/pm/PROJECT_STATE.md", "# Project State\n\n- **Project**: Bank Nusantara Mandiri Ledger\n- **Scale**: Enterprise\n- **Delivery**: client\n")


if __name__ == "__main__":
    build(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else "base")
    print("built", sys.argv[2] if len(sys.argv) > 2 else "base")
