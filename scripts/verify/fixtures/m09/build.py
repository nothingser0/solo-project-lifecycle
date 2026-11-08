#!/usr/bin/env python3
"""Build a base M09 project the gate ACCEPTS, then apply exactly one mutation.

M09 closes the project: a client delivery needs a UAT sign-off plus a traceable workbook.

The base is written out by hand rather than produced by filling the shipped template with one
placeholder word. Filling every `[...]` with "recorded" produced a document whose signatory line
read `**Reviewer**: recorded`, and the gate accepted that filler as a named person - the same class
of hole as an unsigned sheet. A real pack has a real name, a real date and a real channel.
"""
import io
import os
import sys

root, kind = sys.argv[1], sys.argv[2]


def w(rel, s):
    p = os.path.join(root, rel)
    os.makedirs(os.path.dirname(p) or root, exist_ok=True)
    io.open(p, "w", encoding="utf-8").write(s)


w("docs/pm/PROJECT_STATE.md",
  "# Project State\n\n- **Scale**: Client (Medium)\n- **Delivery**: client\n")

# ------------------------------------------------------------------ the UAT sign-off report
uat = """# User Acceptance Testing (UAT) Sign-Off Report

- **System Name**: Kasir
- **Client Company**: Toko Nusantara Mandiri
- **UAT Window**: 2026-11-04 to 2026-11-06
- **Environment**: https://kasir-staging.vercel.app

## 1. Sign-Off Metadata

| Field | Value |
| :--- | :--- |
| Prepared by | Damar Wicaksono |
| Client Single PIC | Ayu Lestari |
| Signing Date | 2026-11-06 |

## 2. UAT Testing Summary Results

| Requirement / AC ID | Scenario | Result |
| :--- | :--- | :---: |
| REQ-01 | login works with the client account | PASS |
| REQ-02 | create an order and print the receipt | PASS |
| REQ-03 | invalid stock is rejected with a clear message | PASS |

Defect summary:

| Severity | Count | State |
| :--- | ---: | :--- |
| Sev 1 | 0 | none raised |
| Sev 2 | 0 | none raised |
| Sev 3 | 2 | fixed during UAT |

## 3. Acceptance & Release Decision

**Status**: APPROVED — the client accepted the release for production go-live.

## 4. Punch List & Conditional Sign-Off (Warranty Transition)

No open punch-list items. The two Sev 3 defects were fixed and retested inside the UAT window.

## 5. Signatures of the Parties

| Party | Name | Signature | Date |
| :--- | :--- | :--- | :--- |
| Client Single PIC | Ayu Lestari | Ayu Lestari | 2026-11-06 |
| Solo Lead Engineer | Damar Wicaksono | Damar Wicaksono | 2026-11-06 |

Signed via: meeting
"""

# ---------------------------------------------------------------------------- the UAT workbook
wb = """# UAT Workbook

## Requirement / AC ID

| Requirement / AC ID | Scenario | Evidence | Result |
| :--- | :--- | :--- | :---: |
| REQ-01 | login works with the client account | artifacts/uat-01.png | PASS |
| REQ-02 | create an order and print the receipt | artifacts/uat-02.png | PASS |
| REQ-03 | invalid stock is rejected | artifacts/uat-03.png | PASS |

## Evidence

Every row carries a screenshot captured during the UAT session in artifacts/.

## UAT Decision

The client accepted all three P0 requirements on 2026-11-06.
"""

# ------------------------------------------------------------------------ one mutation each
if kind == "uat-pending-mentioned":
    uat += "\nNo PENDING items remained at the close of UAT.\n"
elif kind == "uat-go-in-word":
    # no decision word at all; the only "go" is inside another word
    uat = uat.replace("**Status**: APPROVED — the client accepted the release for production go-live.",
                      "**Status**: The cargo crate was shipped and the release left the depot.")
elif kind == "uat-renamed-signoff":
    # the sign-off block survives and is dated, but it names nobody
    uat = uat.replace("| Client Single PIC | Ayu Lestari | Ayu Lestari | 2026-11-06 |",
                      "| Reviewer | | | 2026-11-06 |")
    uat = uat.replace("Client Single PIC", "Reviewer")
elif kind == "uat-placeholder-name":
    # a filler word where a person's name belongs
    uat = uat.replace("| Client Single PIC | Ayu Lestari | Ayu Lestari | 2026-11-06 |",
                      "| Client Single PIC | recorded | recorded | 2026-11-06 |")
elif kind == "uat-blank-cell":
    uat = uat.replace("| Client Single PIC | Ayu Lestari | Ayu Lestari | 2026-11-06 |",
                      "| Client Single PIC | Ayu Lestari | ____________________ | 2026-11-06 |")
elif kind == "uat-sev-row":
    uat = uat.replace("| Sev 1 | 0 | none raised |", "| Sev 1 | 3 | still reproducing |")
elif kind == "uat-no-workbook":
    pass  # written below as absent

w("docs/pm/UAT_SIGNOFF_REPORT.md", uat)
if kind != "uat-no-workbook":
    w("docs/pm/UAT_WORKBOOK.md", wb)

print(kind)
