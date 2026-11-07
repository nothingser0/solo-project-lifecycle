#!/usr/bin/env python3
"""Build an M11 (BAST handover) project the gate ACCEPTS, then apply exactly one mutation.

Shape follows templates/07-release-handover/BAST_TEMPLATE.md (formal BAST, delivery=client) and
templates/essentials/PROJECT_STATE_TEMPLATE.md (get_field reads "- **Field**: value", not tables).

Suspected holes - each is measured, never assumed:
  paid-no-amount      "Settlement of Financial Obligations" with no 100% / no amount
  arrears-negated     "The FIRST PARTY has outstanding arrears of Rp 0" - zero owed, should be fine?
  same-both-sides     FIRST PARTY == SECOND PARTY
  blank-signature     "Signature: ________________________" with names present
  model-second-party  SECOND PARTY: Claude Agent
  article-missing     only "Article 1" - Articles 2 and 3 gone
  delivery-undeclared no Delivery field at all - is a client handover assumed?
  manual-medium       Scale: Medium with no USER_MANUAL.md
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

- **Project**: Kasir POS
- **Scale**: %s
- **Delivery**: %s
- **Current module**: M11
"""

BAST = """# PROJECT HANDOVER & ACCEPTANCE CERTIFICATE (BAST)

**Number**: BAST/KASIR/XI/2026
**Date**: 6 November 2026

---

On this day, Friday, 6 November 2026, located in Yogyakarta, the undersigned below:

1. **CLIENT PIC NAME**: Ayu Lestari
   **Title**: Director
   **Company**: Toko Nusantara Mandiri
   **Office Address**: Jl. Malioboro 12, Yogyakarta
   Acting for and on behalf of **Toko Nusantara Mandiri**, hereinafter referred to as the **"FIRST PARTY"**.

2. **DEVELOPER NAME**: Damar Wicaksono
   **Profession**: Independent Software Engineering Consultant
   **ID / Tax Number (NIK / NPWP)**: 3401xxxxxxxxxxxx
   **Domicile Address**: Sleman, Yogyakarta
   Acting for and on behalf of himself/herself, hereinafter referred to as the **"SECOND PARTY"**.

---

### WHEREAS:
1. Master Services Agreement & Statement of Work (SOW) Number: `SOW/KASIR/2026/07` dated `2026-07-14`.
2. User Acceptance Testing Sign-Off Report (*UAT Sign-Off Report*) dated `2026-11-06`.
3. Official System Launch Report (*Go-Live Report*) dated `2026-11-06`.

---

### HEREBY AGREE AND DECLARE AS FOLLOWS:

#### Article 1: Handover of Deliverables
The SECOND PARTY has completed and handed over all software system development deliverables to the FIRST PARTY with the following details:

1. **Application**: Kasir POS v1.4.0 deployed at https://kasir.tokosinarjaya.id
2. **Source Code**: Ownership of the official Git repository has been fully transferred to the FIRST PARTY organization.
3. **Documentation**: FSD, PRD, user manual, and migration report delivered under docs/.
4. **User Training**: Two operational training sessions for the FIRST PARTY's staff have been completed on 2026-11-05.

#### Article 2: Settlement of Financial Obligations
The FIRST PARTY declares that it has settled all payment obligations (100%) of the total contract value of Rp 42.000.000 to the SECOND PARTY. Both parties confirm there is no outstanding arrears.

#### Article 3: Maintenance Warranty Period
1. Starting from the signing date of this Certificate, the SECOND PARTY provides a **Maintenance Warranty Period of 60 days**.

---

Thus this Project Handover & Acceptance Certificate (BAST) is executed in 2 (two) counterparts and signed by both parties with full awareness and responsibility without coercion from any party.

| FIRST PARTY (Client) | SECOND PARTY (Developer) |
| :---: | :---: |
| Toko Nusantara Mandiri | Independent Software Consultant |
| *(Duty Stamp / Meterai)* | *(Duty Stamp / Meterai)* |
| **Ayu Lestari** | **Damar Wicaksono** |
| Director | Independent Lead Software Engineer |

Signature / Tanda Tangan

Date / Tanggal: 6 November 2026
"""


def build(dest, kind):
    def w(rel, text):
        p = os.path.join(dest, rel)
        os.makedirs(os.path.dirname(p) or dest, exist_ok=True)
        with open(p, "w", encoding="utf-8") as fh:
            fh.write(text)

    bast = BAST
    scale, delivery = "Small", "client"

    if kind == "paid-no-amount":
        bast = bast.replace(
            "The FIRST PARTY declares that it has settled all payment obligations (100%) of the total contract value of Rp 42.000.000 to the SECOND PARTY. Both parties confirm there is no outstanding arrears.",
            "The FIRST PARTY and the SECOND PARTY will discuss the commercial settlement separately after handover.",
        )
    elif kind == "arrears-negated":
        bast = bast.replace(
            "Both parties confirm there is no outstanding arrears.",
            "The FIRST PARTY currently has outstanding arrears of Rp 0.",
        )
    elif kind == "same-both-sides":
        bast = bast.replace("**CLIENT PIC NAME**: Ayu Lestari", "**CLIENT PIC NAME**: Damar Wicaksono")
    elif kind == "blank-signature":
        bast = bast.replace("| **Ayu Lestari** | **Damar Wicaksono** |", "| ______________________ | ______________________ |")
    elif kind == "model-second-party":
        bast = bast.replace("2. **DEVELOPER NAME**: Damar Wicaksono", "2. **DEVELOPER NAME**: Claude Agent")
    elif kind == "article-missing":
        start = bast.index("#### Article 2")
        end = bast.index("Thus this Project Handover")
        bast = bast[:start] + bast[end:]
    elif kind == "delivery-undeclared":
        delivery = ""
    elif kind == "manual-medium":
        scale = "Medium"
    elif kind == "arrears-negated":
        bast = bast.replace("Both parties confirm there is no outstanding arrears.",
                            "Both parties confirm the settlement position; see the ledger.").replace(
            "has settled all payment obligations (100%) of the total contract value of Rp 42.000.000",
            "has settled all payment obligations (100%) of the total contract value of Rp 42.000.000")
    elif kind != "base":
        raise SystemExit("unknown kind: %s" % kind)

    w("docs/pm/BAST.md", bast)
    w("docs/pm/PROJECT_STATE.md", STATE % (scale, delivery if delivery else " "))
    if kind == "manual-medium":
        pass  # deliberately no USER_MANUAL.md


if __name__ == "__main__":
    build(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else "base")
    print("built", sys.argv[2] if len(sys.argv) > 2 else "base")
