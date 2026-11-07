#!/usr/bin/env python3
"""Build an A02 (C4 blueprint + STRIDE threat model) project the gate ACCEPTS, then mutate one thing.

Shape follows templates/03-architecture-specs/ENTERPRISE_ARCHITECTURE_BLUEPRINT_TEMPLATE.md and
THREAT_MODEL_STRIDE_TEMPLATE.md. The base carries the template's real structure: a C4 context with
containers, a data-residency table, a quality scenario, and a STRIDE threat table.

Suspected holes - each measured, never assumed:
  stride-prose-only      the 6 category words appear in prose, no threat table
  stride-table-no-cat    a threat table exists, but only 2 STRIDE categories are named
  mitigation-empty       "## Mitigation" heading with nothing under it
  c4-empty               "## 2. C4 Context" with no content
  residency-no-region    Data Residency section without any region named
  scenario-no-numbers    Quality Attribute Scenario with no measurable target
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))

BLUEPRINT = """# Enterprise Architecture Blueprint

## 1. Business Context

Bank Sinar Jaya runs a multi-branch ledger for 42 branches. Peak load is 900 concurrent cashiers.

## 2. C4 Context

Customers and branch staff use a React client; the payment gateway calls back over signed webhooks.

### 2.1 C4 Container

| Container | Technology | Responsibility |
| :--- | :--- | :--- |
| web | Next.js 15 | cashier and admin UI |
| api | Node 22 | ledger, auth, webhooks |
| db | Postgres 16 (Neon) | double-entry ledger, audit trail |

### 2.2 C4 Component

| Component | Responsibility |
| :--- | :--- |
| LedgerService | posts balanced entries, rejects unbalanced ones |
| WebhookVerifier | validates Midtrans signatures before accepting a payment event |

## 3. Data Residency

| Data class | Region | Retention |
| :--- | :--- | :--- |
| Customer PII | Jakarta (Asia/Jakarta) | 5 years per OJK |
| Transaction ledger | Jakarta (Asia/Jakarta) | 10 years per OJK |

All backups stay in the Jakarta region; no cross-border replication.

## 4. Quality Attribute Scenario

| Attribute | Stimulus | Target |
| :--- | :--- | :--- |
| Latency | cashier records a sale | p95 under 800 ms |
| Durability | node failure during posting | zero committed entries lost |

## 5. Constraints and Trade-offs Accepted

Single region, no active-active, to stay inside the operations budget for a solo team.

## 6. What This Blueprint Deliberately Does Not Cover

Mobile offline sync, and the legacy ERP bridge (Phase 3 of the WBS).
"""

THREAT = """# Threat Model — STRIDE

## 1. Scope and Assumptions

| Item | Value |
| :--- | :--- |
| System boundary | ledger API, webhook receiver, admin UI |
| Explicitly out of scope | the client's ERP, with no network path to it |
| Deployment assumption | single region, Neon Postgres, Vercel functions |
| Attacker population considered | unauthenticated internet, authenticated cashier |

## 2. Elements and Trust Boundaries

| ID | Type | Name | Trust level |
| :--- | :--- | :--- | :--- |
| EI01 | External interactor | Browser / mobile client | Untrusted |
| EI02 | External interactor | Payment gateway webhook source | Semi-trusted |
| P01 | Process | API server | Trusted |
| DS01 | Data store | Primary database | Trusted |

## 3. STRIDE Threats

| ID | Category | Threat | Mitigation |
| :--- | :--- | :--- | :--- |
| T01 | Spoofing | A forged cashier session claims another branch | short-lived signed session tokens, per-branch claims |
| T02 | Tampering | A client edits the sale amount in flight | server recomputes totals; client values are advisory |
| T03 | Repudiation | A cashier denies issuing a refund | append-only audit log with actor and timestamp |
| T04 | Information Disclosure | A webhook receipt leaks customer PII | receipts store only the transaction id |
| T05 | Denial of Service | A flood of webhook calls saturates the API | signature check before parsing, per-IP rate limit |

## 4. Mitigation Summary

| Mitigation | Threat IDs |
| :--- | :--- |
| signed sessions and tokens | T01 |
| server-side recomputation | T02 |
| append-only audit log | T03 |
| rate limiting at the edge | T05 |
"""


def build(dest, kind):
    def w(rel, text):
        p = os.path.join(dest, rel)
        os.makedirs(os.path.dirname(p) or dest, exist_ok=True)
        with open(p, "w", encoding="utf-8") as fh:
            fh.write(text)

    bp, th = BLUEPRINT, THREAT

    if kind == "stride-prose-only":
        start = th.index("## 3. STRIDE Threats")
        end = th.index("## 4. Mitigation Summary")
        th = th[:start] + (
            "## 3. STRIDE Threats\n\n"
            "We considered Spoofing and Tampering briefly. Repudiation is not applicable to us. "
            "Information Disclosure, Denial of Service and Elevation of Privilege were discussed "
            "and judged low risk for a single-region bank deployment.\n\n"
        ) + th[end:]
    elif kind == "stride-table-no-cat":
        start = th.index("## 3. STRIDE Threats")
        end = th.index("## 4. Mitigation Summary")
        th = th[:start] + (
            "## 3. STRIDE Threats\n\n"
            "| ID | Category | Threat | Mitigation |\n| :--- | :--- | :--- | :--- |\n"
            "| T01 | Spoofing | forged session | signed tokens |\n"
            "| T02 | Tampering | edited sale amount | server recompute |\n\n"
        ) + th[end:]
    elif kind == "mitigation-empty":
        start = th.index("## 4. Mitigation Summary")
        th = th[:start] + "## 4. Mitigation Summary\n"
    elif kind == "c4-empty":
        start = bp.index("## 2. C4 Context")
        end = bp.index("## 3. Data Residency")
        bp = bp[:start] + "## 2. C4 Context\n\n" + bp[end:]
    elif kind == "residency-no-region":
        start = bp.index("## 3. Data Residency")
        end = bp.index("## 4. Quality Attribute Scenario")
        bp = bp[:start] + "## 3. Data Residency\n\nThe data stays wherever the provider puts it.\n\n" + bp[end:]
    elif kind == "scenario-no-numbers":
        start = bp.index("## 4. Quality Attribute Scenario")
        end = bp.index("## 5. Constraints and Trade-offs")
        bp = bp[:start] + (
            "## 4. Quality Attribute Scenario\n\n"
            "The system should feel fast and should not lose data under normal operation.\n\n"
        ) + bp[end:]
    elif kind != "base":
        raise SystemExit("unknown kind: %s" % kind)

    w("docs/architecture/ENTERPRISE_ARCHITECTURE_BLUEPRINT.md", bp)
    w("docs/security/THREAT_MODEL_STRIDE.md", th)
    w("docs/pm/PROJECT_STATE.md", "# Project State\n\n- **Project**: Bank Sinar Jaya Ledger\n- **Scale**: Enterprise\n- **Delivery**: client\n")


if __name__ == "__main__":
    build(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else "base")
    print("built", sys.argv[2] if len(sys.argv) > 2 else "base")
