#!/usr/bin/env python3
"""Build an A01 (WBS phasing) project the gate ACCEPTS, then apply exactly one mutation.

Shape follows templates/00-pre-sales-enterprise/WBS_PHASING_TEMPLATE.md, filled the way a real plan
is filled (scope razor as a table, as the template does).

Suspected holes - measured, never assumed:
  one-phase-large        Large scale with a single package row
  razor-nothing          "nothing was cut" in prose while two bullets exist
  razor-one-cut          only one real cut named
  sections-empty         Phasing Strategy / Phased Package Breakdown with no content
  signoff-filler-name    "Lead Enterprise Architect: filled"
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))

WBS = """# Work Breakdown Structure (WBS) & Phasing Plan

## 1. Executive Summary & Phasing Strategy

Bank Nusantara Mandiri's core ledger ships first, integrations follow once the ledger is stable, and the
legacy ERP bridge lands last because it has the largest blast radius of the three.

## 2. Phased Package Breakdown

### Phase 1: Core Backbone & Baseline Ledger

| Package | Deliverable | Exit criteria |
| :--- | :--- | :--- |
| Core IAM & RBAC | roles, permissions, audit trail | 12 role tests green |
| Primary Ledger | double-entry ledger, reconciliation | 3 reconciliations match to the cent |

### Phase 2: Ecosystem Integrations & Partner Gateway

| Package | Deliverable | Exit criteria |
| :--- | :--- | :--- |
| Partner API gateway | signed webhooks, retries | 200 sandbox calls, 0 duplicates |

### Phase 3: Legacy Bridge & Core ERP/Banking Synchronization

| Package | Deliverable | Exit criteria |
| :--- | :--- | :--- |
| Legacy core migration | nightly sync, cutover runbook | one dry run reconciles |

## 3. Scope Razor & Boundary Defense

Items cut from Phase 1, each with the reason it waits:

- Multi-branch synchronisation — waits on a stable core ledger (Phase 2).
- Legacy core migration — high blast radius, needs its own incident plan (Phase 3).

| Scope Item | Target Phase | Implementation Team | Justification |
| :--- | :---: | :--- | :--- |
| Core IAM & RBAC | Phase 1 | Implementation Vendor Team A | Prerequisite for all business workflows |
| Primary Ledger | Phase 1 | Implementation Vendor Team A | Core business transaction boundary |
| Multi-Branch Sync | Phase 2 | Implementation Vendor Team B | Depends on stable Phase 1 core ledger |
| Legacy Core Migration | Phase 3 | Specialized Integration Contractor | High blast-radius, requires isolation |

## 4. Phase Gate Sign-Off

Lead Enterprise Architect: Damar Wicaksono
Date: 2026-11-08
Status: **WBS PHASING APPROVED (Ready for C4 Modeling & STRIDE in Phase A02)**
"""


def build(dest, kind):
    def w(rel, text):
        p = os.path.join(dest, rel)
        os.makedirs(os.path.dirname(p) or dest, exist_ok=True)
        with open(p, "w", encoding="utf-8") as fh:
            fh.write(text)

    wbs = WBS
    scale = "Enterprise"

    if kind == "one-phase-large":
        start = wbs.index("### Phase 2")
        end = wbs.index("## 3. Scope Razor")
        wbs = wbs[:start] + wbs[end:]
    elif kind == "razor-nothing":
        start = wbs.index("Items cut from Phase 1")
        end = wbs.index("| Scope Item | Target Phase")
        wbs = wbs[:start] + "Nothing was cut from phase 1; everything is in.\n\n" + wbs[end:]
    elif kind == "razor-one-cut":
        wbs = wbs.replace(
            "- Legacy core migration — high blast radius, needs its own incident plan (Phase 3).\n", "")
    elif kind == "sections-empty":
        start = wbs.index("## 1. Executive Summary")
        end = wbs.index("## 2. Phased Package Breakdown")
        wbs = wbs[:start] + "## 1. Executive Summary & Phasing Strategy\n\n" + wbs[end:]
    elif kind == "signoff-filler-name":
        wbs = wbs.replace("Lead Enterprise Architect: Damar Wicaksono",
                          "Lead Enterprise Architect: filled")
    elif kind != "base":
        raise SystemExit("unknown kind: %s" % kind)

    w("docs/pm/WBS_PHASING_PLAN.md", wbs)
    w("docs/pm/PROJECT_STATE.md", "# Project State\n\n- **Project**: Bank Nusantara Mandiri Core Ledger\n- **Scale**: %s\n- **Delivery**: client\n" % scale)


if __name__ == "__main__":
    build(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else "base")
    print("built", sys.argv[2] if len(sys.argv) > 2 else "base")
