#!/usr/bin/env python3
"""Build a base M08 project the gate ACCEPTS, then apply exactly one mutation.

M08 is the data-migration gate. The base is a client delivery that migrated three tables and left
behind the four artifacts a real migration produces: a plan, a reconciliation report with counts,
a schema, and a signed client hand-over.
"""
import io
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
TPL = os.path.normpath(os.path.join(HERE, "..", "..", "..", "..", "templates"))
if not os.path.isdir(TPL):
    raise SystemExit(f"templates not found at {TPL}")

root, kind = sys.argv[1], sys.argv[2]


def w(rel, s):
    p = os.path.join(root, rel)
    os.makedirs(os.path.dirname(p) or root, exist_ok=True)
    io.open(p, "w", encoding="utf-8").write(s)


def r(rel):
    return io.open(os.path.join(root, rel), encoding="utf-8").read()


# ---- project state: client/medium with legacy data, so M08 is NOT waived --------------------
w("docs/pm/PROJECT_STATE.md",
  "# Project State\n\n- **Scale**: Client (Medium)\n- **Intake-Legacy-Core**: yes\n"
  "- **Legacy Data**: yes — the client's existing spreadsheet export must be migrated\n")

# ---- schema: the DDL the plan has to map ----------------------------------------------------
w("docs/specs/FSD.md",
  "# FSD\n\n```sql\nCREATE TABLE customers (\n  id uuid primary key\n);\n"
  "CREATE TABLE orders (\n  id uuid primary key\n);\n"
  "CREATE TABLE order_items (\n  id uuid primary key\n);\n```\n")

# ---- plan: the shipped template, filled like a human would -----------------------------------
plan = io.open(os.path.join(TPL, "05-data-migration/DATA_MIGRATION_PLAN_TEMPLATE.md"),
               encoding="utf-8").read()
plan = re.sub(r"\[([^\]]*)\]", "recorded", plan)
plan = plan.replace("Inputs-Received: recorded",
                    "Inputs-Received: legacy XLSX export from Budi Santoso on 2026-10-20")
if "Inputs-Received" not in plan:
    plan += "\n\nInputs-Received: legacy XLSX export from Budi Santoso on 2026-10-20\n"
plan += "\n\n## Tables\n\n- customers\n- orders\n- order_items\n"

# ---- reconciliation: per-table counts, not the word PASSED -----------------------------------
recon = """# Migration Reconciliation Report

| Table | Source rows | Loaded rows | Matched |
| :--- | ---: | ---: | ---: |
| customers | 1200 | 1200 | 1200 |
| orders | 8400 | 8400 | 8400 |
| order_items | 21000 | 21000 | 21000 |

Status: PASSED

## Client Single PIC Sign-Off

| Role | Name | Signature | Date |
| :--- | :--- | :--- | :--- |
| Client Single PIC | Budi Santoso | Budi Santoso | 2026-10-25 |
"""

# ---- one mutation each ----------------------------------------------------------------------
if kind == "recon-passed-no-counts":
    recon = recon.replace(
        "| Table | Source rows | Loaded rows | Matched |\n| :--- | ---: | ---: | ---: |\n"
        "| customers | 1200 | 1200 | 1200 |\n| orders | 8400 | 8400 | 8400 |\n"
        "| order_items | 21000 | 21000 | 21000 |\n", "")
elif kind == "recon-counts-not-matching":
    # counts present, but the loaded total does not match the source: a real discrepancy
    recon = recon.replace("| orders | 8400 | 8400 | 8400 |", "| orders | 8400 | 8399 | 8399 |")
elif kind == "recon-no-pic-wording":
    # remove the phrase the sign-off check keys on, leaving the signature blank
    recon = recon.replace("## Client Single PIC Sign-Off", "## Sign-Off")
    recon = recon.replace("| Client Single PIC | Budi Santoso | Budi Santoso | 2026-10-25 |",
                          "| Reviewer | | | |")
elif kind == "recon-blank-signature":
    recon = recon.replace("| Client Single PIC | Budi Santoso | Budi Santoso | 2026-10-25 |",
                          "| Client Single PIC | Budi Santoso | ____________________ | 2026-10-25 |")
elif kind == "no-reconciliation-medium":
    pass  # written below as absent
elif kind == "plan-ignores-table":
    plan = plan.replace("\n- order_items", "")
elif kind == "no-schema":
    plan = plan.replace("\n\n## Tables\n\n- customers\n- orders\n- order_items\n", "")

w("docs/pm/DATA_MIGRATION_PLAN.md", plan)
if kind != "no-reconciliation-medium":
    w("docs/pm/MIGRATION_RECONCILIATION_REPORT.md", recon)

print(kind)
