#!/usr/bin/env python3
"""Build a base M07 project that the gate ACCEPTS, then apply exactly one mutation.

Rule for every probe: the base must be proven PASS first, otherwise a FAIL tells us nothing about
the mutation. Each variant therefore changes a single line and nothing else.
"""
import io
import os
import re
import sys

TPL = "/opt/data/cache/scratch/lifecycle-clone/templates"
root, kind = sys.argv[1], sys.argv[2]


def w(rel, s):
    p = os.path.join(root, rel)
    os.makedirs(os.path.dirname(p) or root, exist_ok=True)
    io.open(p, "w", encoding="utf-8").write(s)


sit = io.open(os.path.join(TPL, "06-qa-uat/SIT_WORKBOOK_TEMPLATE.md"), encoding="utf-8").read()
polish = io.open(os.path.join(TPL, "06-qa-uat/POLISH_AUDIT_TEMPLATE.md"), encoding="utf-8").read()
sec = io.open(os.path.join(TPL, "06-qa-uat/SECURITY_AUDIT_TEMPLATE.md"), encoding="utf-8").read()

# ---- specs: three requirements, three screens -----------------------------------------------
w("docs/pm/PROJECT_STATE.md", "# Project State\n\n- **Scale**: Client (Medium)\n")
w("docs/specs/FSD.md",
  "# FSD\n\n- REQ-01 login\n- REQ-02 create order\n- REQ-03 receipt\n"
  "\n| SCR-001 | login |\n| SCR-002 | orders |\n| SCR-003 | receipt |\n")

# ---- POLISH: check the ready box, drop the not-ready option ---------------------------------
polish = polish.replace(
    "**Conclusion**: [ ] READY (0 blocking tells) · [ ] NOT READY ([X] blocking tells open)",
    "**Conclusion**: [x] READY (0 blocking tells)")
polish = re.sub(r"\[([^\]]*)\]", lambda m: "N/A" if "blocking" in m.group(1) else "done", polish)

# ---- SECURITY: tick SECURITY PASS, drop the rejected option ---------------------------------
sec = "\n".join(l for l in sec.split("\n") if "REJECTED (FAIL)" not in l)
sec = sec.replace("| **Critical** | [observed count] | [disposition / evidence] |",
                  "| **Critical** | 0 | none found |")
sec = re.sub(r"\[([^\]]*)\]", "done", sec)
sec = sec.replace("- done **SECURITY PASS**:", "- [x] **SECURITY PASS**:")

# ---- SIT: a real pass, every REQ/SCR covered, one negative row, staging URL ------------------
sit = sit.replace("**Conclusion**: [SIT PASS / NOT READY / PASS WITH RELEASE RISKS]",
                  "**Conclusion**: SIT PASS")
sit = re.sub(r"Final Testing Status\*\*:?[^\n]*", "Final Testing Status**: SIT PASS", sit)
sit = re.sub(r"\[([^\]]*)\]", "done", sit)
sit += ("\n\n| Item | Scenario | Result |\n| :--- | :--- | :---: |\n"
        "| REQ-01 | login with valid credentials | PASS |\n"
        "| REQ-02 | create order | PASS |\n"
        "| REQ-03 | receipt renders | PASS |\n"
        "| SCR-001 | login screen | PASS |\n"
        "| SCR-002 | orders screen | PASS |\n"
        "| SCR-003 | receipt screen | PASS |\n"
        "| REQ-01 | login with an invalid password is rejected | PASS |\n"
        "\nStaging-URL: https://kasir-staging.vercel.app\n")
sit = sit.replace("| **Name**: _________________________ | **Name**: _________________________ |",
                  "| **Name**: Wahyu Nur Sagita | **Name**: Budi Santoso |")
sit = sit.replace("| **Title / Role**: Independent Lead Engineer | **Title / Role**: _________________ |",
                  "| **Title / Role**: Independent Lead Engineer | **Title / Role**: Operations Manager |")
sit = sit.replace("| **Date**: _________________________ | **Date**: _________________________ |",
                  "| **Date**: 2026-11-06 | **Date**: 2026-11-07 |")
sit = sit.replace("| **Signature**: | **Signature**: |",
                  "| **Signature**: Wahyu Nur Sagita | **Signature**: Budi Santoso |")

# ---- one mutation each ----------------------------------------------------------------------
if kind == "empty-signoff":
    sit = sit.replace("| **Name**: Wahyu Nur Sagita | **Name**: Budi Santoso |",
                      "| **Name**: _________________________ | **Name**: _________________________ |")
    sit = sit.replace("| **Signature**: Wahyu Nur Sagita | **Signature**: Budi Santoso |",
                      "| **Signature**: | **Signature**: |")
elif kind == "signoff-missing":
    sit = re.sub(r"### 6\. SIT Sign-Off Sheet.*\Z", "", sit, flags=re.S)
elif kind == "polish-vague-zero":
    polish = "# Polish Audit\n\nOverall: 0 blocking problems were observed during review.\n"
elif kind == "no-specs":
    # specs live elsewhere, but the workbook still names what it tested: traceable, so it passes
    os.remove(os.path.join(root, "docs/specs/FSD.md"))
elif kind == "no-traceability":
    # neither the specs nor the workbook name a requirement: a PASS here would be unattributable
    os.remove(os.path.join(root, "docs/specs/FSD.md"))
    sit = re.sub(r"REQ-[0-9]+", "item", sit)
    sit = re.sub(r"SCR-[0-9]+", "screen", sit)
    w("docs/qa/SIT_WORKBOOK.md", sit)
elif kind == "security-critical-row":
    sec = sec.replace("| **Critical** | 0 | none found |", "| **Critical** | 2 | open |")
elif kind == "native-narrow":
    sit = sit.replace("### 4d. Native Mobile QA (native apps only)",
                      "### 4d. Native Mobile")
elif kind == "sit-pass-no-evidence":
    # drop every evidence path but keep the PASS words
    sit = re.sub(r"\| done \| done \|", "| | |", sit)

w("docs/qa/SIT_WORKBOOK.md", sit)
w("docs/qa/POLISH_AUDIT.md", polish)
w("docs/qa/SECURITY_AUDIT.md", sec)
print(kind)
