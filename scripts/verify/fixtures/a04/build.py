#!/usr/bin/env python3
"""Build an A04 (governance handover) project the gate ACCEPTS, then mutate one thing.

Shape copied from templates/03-governance/GOVERNANCE_HANDOVER_PACK_TEMPLATE.md: a RACI table with
A/R markers per activity, a CAB table, a Disaster Recovery table with RPO/RTO rows, and a retainer
section. Read from the template, not from memory - two earlier modules shipped a base that did not
resemble the template and the "hole" turned out to be my own fixture.

Suspected holes - each measured, never assumed:
  rto-empty          "| RTO (acceptable downtime) | | ☐ |" - the label is there, the value is not
  raci-no-accountable  a RACI with rows but no A anywhere
  raci-placeholder   a role assigned to TBD
  dr-no-rto          the RTO row deleted entirely
  rto-tbd            "| RTO (acceptable downtime) | TBD | ☐ |" - a label, a placeholder, no number
  dr-no-drill        no restore drill recorded at all
  cab-empty          "## CAB" with nothing under it
  retainer-empty     "## Architecture Conformance Retainer" with nothing under it
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))

PACK = """# Governance Handover Pack

> Transfers operational governance from the delivery team to the client's own roles.

## 1. RACI — who decides what after handover

| Activity | Client IT | Client Business Owner | Advisor (retainer) | Vendor |
| :--- | :---: | :---: | :---: | :---: |
| Production deploy | **A/R** | I | C | C |
| Schema change | **A/R** | I | C | C |
| Incident: P1 | **A/R** | I | C | R |
| Incident: P3 | **A/R** | — | I | R |
| Access grant / revoke | **A/R** | C | I | — |
| Backup restore drill | **A/R** | I | C | — |
| Architecture conformance review | C | I | **A/R** | I |
| Vendor change request | C | **A** | C | R |

**A/R = accountable and responsible · C = consulted · I = informed.** Exactly one **A** per activity.

## 2. CAB — change advisory process

| Change class | Example | Approval required | Lead time |
| :--- | :--- | :--- | :--- |
| Standard | dependency patch within the approved range | team lead | none |
| Normal | schema change | CAB chair plus business owner | 2 working days |
| Emergency | P1 hotfix | incident commander, reviewed next CAB | same day |

CAB meets weekly on Tuesdays; emergency changes are reviewed at the next session.

## 3. Disaster Recovery — operational readiness

| Item | Value | Verified |
| :--- | :--- | :-: |
| RPO (acceptable data loss) | 5 minutes (Neon PITR) | yes |
| RTO (acceptable downtime) | 2 hours | yes |
| Backup cadence | continuous WAL, nightly snapshot | yes |
| Restore drill frequency | quarterly | yes |
| **Date of last successful restore drill** | 2026-10-14 | yes |
| Contact escalation path | on-call -> Wahyu Nur Sagita -> Budi Santoso | yes |
| Documented runbook location | docs/pm/ROLLBACK_PLAN.md | yes |

## 4. Architecture Conformance Retainer

Monthly review of 4 hours: architecture conformance, dependency currency, and a written finding
report to the client business owner. Misuse of the retainer for new features is out of scope.

Signed by: Wahyu Nur Sagita
"""


def _section(text, heading):
    """Body of a level-2 section, headings included for simple rendering."""
    lines = text.splitlines()
    out, keep = [], False
    for line in lines:
        if line.startswith("## "):
            keep = heading.lower() in line.lower()
            if keep:
                out.append(line)
            continue
        if keep:
            out.append(line)
    return "\n".join(out)


def build(dest, kind):
    def w(rel, text):
        p = os.path.join(dest, rel)
        os.makedirs(os.path.dirname(p) or dest, exist_ok=True)
        with open(p, "w", encoding="utf-8") as fh:
            fh.write(text)

    pack = PACK

    if kind == "rto-empty":
        pack = pack.replace("| RTO (acceptable downtime) | 2 hours | yes |",
                            "| RTO (acceptable downtime) | | ☐ |")
    elif kind == "raci-no-accountable":
        pack = pack.replace("**A/R**", "R").replace("**A**", "C")
    elif kind == "raci-placeholder":
        pack = pack.replace("| Production deploy | **A/R** | I | C | C |",
                            "| Production deploy | TBD | I | C | C |")
    elif kind == "rto-tbd":
        pack = pack.replace("| RTO (acceptable downtime) | 2 hours | yes |",
                            "| RTO (acceptable downtime) | TBD | ☐ |")
    elif kind == "dr-no-drill":
        pack = pack.replace("| Restore drill frequency | quarterly | yes |\n", "")
        pack = pack.replace("| **Date of last successful restore drill** | 2026-10-14 | yes |\n", "")
    elif kind == "dr-no-rto":
        pack = pack.replace("| RTO (acceptable downtime) | 2 hours | yes |\n", "")
    elif kind == "cab-empty":
        start = pack.index("## 2. CAB")
        end = pack.index("## 3. Disaster Recovery")
        pack = pack[:start] + "## 2. CAB — change advisory process\n\n" + pack[end:]
    elif kind == "retainer-empty":
        start = pack.index("## 4. Architecture Conformance Retainer")
        pack = pack[:start] + "## 4. Architecture Conformance Retainer\n"
    elif kind != "base":
        raise SystemExit("unknown kind: %s" % kind)

    w("docs/governance/GOVERNANCE_HANDOVER_PACK.md", pack)
    w("docs/pm/PROJECT_STATE.md", "# Project State\n\n- **Project**: Bank Sinar Jaya Ledger\n- **Scale**: Enterprise\n- **Delivery**: client\n")


if __name__ == "__main__":
    build(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else "base")
    print("built", sys.argv[2] if len(sys.argv) > 2 else "base")
