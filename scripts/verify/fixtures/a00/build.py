#!/usr/bin/env python3
"""Build an A00 (advisory agreement) project the gate ACCEPTS, then apply exactly one mutation.

Shape follows templates/00-pre-sales-enterprise/CONSULTING_AGREEMENT_TEMPLATE.md, filled the way a
real engagement is filled.

Suspected holes - measured, never assumed:
  fee-zero-no-probono   "Total Advisory Fee: Rp 0" with no pro-bono wording
  liability-none        "Maximum Liability Cap: None"
  model-signs           "For and on behalf of CONSULTANT -> Claude Agent"
  sections-empty        Parties / Advisory Deliverables / Professional Fees / Liability, no content
  placeholder-left      "[Amount]" still unfilled
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


AGREEMENT = """# Enterprise Architecture & Technical Advisory Agreement

> Commercial contract for an independent technical consultant advising Bank Nusantara Mandiri.

## 1. Parties & Engagement Premise

This Agreement is entered into between Bank Nusantara Mandiri, represented by Ayu Lestari, Director of
Technology (the "Client"), and Damar Wicaksono, an independent technical consultant (the
"Consultant").

### 1.1 Nature of Engagement (Pure Advisory)

The Consultant is engaged solely in an architectural advisory and technical governance capacity.

## 2. Advisory Deliverables & Scope (The A-Series Package)

The Consultant shall deliver the Enterprise Readiness & Architecture Package:
1. A00 commercial clearance and bid/no-bid analysis.
2. A01 enterprise readiness assessment.
3. A02 threat model and data-classification review.
4. A03 procurement and governance handover pack.

## 3. Professional Fees, Invoicing & Corporate Net Payment Terms

1. **Total Advisory Fee**: Rp 85.000.000 (exclusive of statutory VAT/PPN).
2. **Milestone Schedule**:
   - Retainer / Kickoff (30%): due upon signing, before A01 commencement.
   - Architecture & Threat Model Sign-off (40%): due on delivery of A02.
   - Procurement & Governance Final Handover (30%): due on delivery of A03 and A04.
3. **Corporate Invoicing Terms (Net 30)**: invoices payable within 30 calendar days. Late payments
   beyond 14 days incur 1% interest per month. Work pauses if a milestone payment is overdue.

## 4. Integrity Pact, Anti-Bribery & Conflict of Interest

The Consultant warrants no commercial relationship with any vendor that could respond to the
procurement this engagement prepares.

## 5. Professional Liability Limitation & Disclaimer

1. **Disclaimer of Implementation Liabilities**: the Consultant provides architectural
   recommendations; implementation decisions remain with the Client.
2. **Maximum Liability Cap**: the maximum total liability of the Consultant under any cause of
   action is capped at the total fees actually paid under this Agreement.
3. **Legal & Compliance Status**: architecture blueprints are advisory, not legal opinions.

## 6. Execution & Duty Stamps

| For and on behalf of CLIENT | For and on behalf of CONSULTANT |
| :---: | :---: |
| Ayu Lestari | Damar Wicaksono |
| *(e-Meterai / Duty Stamp Rp 10.000)* | *(e-Meterai / Duty Stamp Rp 10.000)* |
| Title: Director of Technology | Title: Lead Enterprise Architect |
| Date: 2026-11-08 | Date: 2026-11-08 |
"""


def build(dest, kind):
    def w(rel, text):
        p = os.path.join(dest, rel)
        os.makedirs(os.path.dirname(p) or dest, exist_ok=True)
        with open(p, "w", encoding="utf-8") as fh:
            fh.write(text)

    ag = AGREEMENT

    if kind == "fee-zero-no-probono":
        ag = ag.replace("1. **Total Advisory Fee**: Rp 85.000.000 (exclusive of statutory VAT/PPN).",
                        "1. **Total Advisory Fee**: Rp 0 (exclusive of statutory VAT/PPN).")
    elif kind == "liability-none":
        ag = ag.replace(
            "2. **Maximum Liability Cap**: the maximum total liability of the Consultant under any cause of\n   action is capped at the total fees actually paid under this Agreement.",
            "2. **Maximum Liability Cap**: None")
        ag = ag.replace("1. **Disclaimer of Implementation Liabilities**: the Consultant provides architectural\n   recommendations; implementation decisions remain with the Client.",
                        "")
    elif kind == "model-signs":
        ag = ag.replace("| Ayu Lestari | Damar Wicaksono |", "| Ayu Lestari | Claude Agent |")
    elif kind == "sections-empty":
        start = ag.index("## 2. Advisory Deliverables")
        end = ag.index("## 3. Professional Fees")
        ag = ag[:start] + "## 2. Advisory Deliverables & Scope (The A-Series Package)\n\n" + ag[end:]
    elif kind == "placeholder-left":
        ag = ag.replace("Rp 85.000.000", "Rp [Amount]")
    elif kind != "base":
        raise SystemExit("unknown kind: %s" % kind)

    w("contracts/CONSULTING_AGREEMENT.md", ag)
    w("docs/pm/PROJECT_STATE.md", "# Project State\n\n- **Project**: Bank Nusantara Mandiri Advisory\n- **Scale**: Enterprise\n- **Delivery**: client\n")


if __name__ == "__main__":
    build(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else "base")
    print("built", sys.argv[2] if len(sys.argv) > 2 else "base")
