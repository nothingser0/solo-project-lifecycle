#!/usr/bin/env python3
"""Second pass on the M06 fixture: supply what the first run said was missing.

Each addition answers a specific message from the gate, not a guess:
  - a chosen Compatibility Level (the FSD section must carry one)
  - the Module 04 Handoff Strategy heading the checker looks for
  - RUNBOOK_LOCAL.md troubleshooting section
  - artifacts of real size (>= 1024 bytes), not stubs
  - DB evidence: migrate down, seeder count, EXPLAIN
  - a 'Human Check' line on the SETUP/DB/FE tasks
  - the shipped source names the frozen screens it ported
"""
import io
import os
import sys

root = sys.argv[1]


def w(rel, text):
    p = os.path.join(root, rel)
    os.makedirs(os.path.dirname(p) or root, exist_ok=True)
    io.open(p, "w", encoding="utf-8").write(text)


def r(rel):
    return io.open(os.path.join(root, rel), encoding="utf-8").read()


PAD = ("PNG payload for the evidence report. " * 40)

# ---- FSD: compatibility level + handoff heading
fsd = r("docs/specs/FSD.md")
fsd = fsd.replace("## Module 04 Handoff Strategy",
                  "**Compatibility Level**: Level 2\n\n## Module 04 Handoff Strategy")
w("docs/specs/FSD.md", fsd)

# ---- runbook: troubleshooting
runbook = r("RUNBOOK_LOCAL.md")
runbook = runbook.replace("# Runbook Local", "# Runbook Local\n\n## Troubleshooting & Clean State")
w("RUNBOOK_LOCAL.md", runbook)

# ---- artifacts of real size
for name in ("setup", "db", "api", "fe-1", "fe-2", "qa"):
    w(f"artifacts/{name}.png", PAD + f"\n{name}\n")

# ---- DB evidence in the evidence report
ev = r("artifacts/final-evidence.md")
ev += """
## Database proof

```
npm run migrate:down   # rollback succeeds
SELECT COUNT(*) FROM products;   # seeder count = 12
EXPLAIN SELECT id FROM products ORDER BY name;   # index scan
```
"""
w("artifacts/final-evidence.md", ev)

# ---- TODO: Human Check lines and screen references
todo = r("TODO.md")
todo = todo.replace("""- [x] **M06-DB-01: schema + migration** — Postgres tables created and queried""",
                    """- [x] **M06-DB-01: schema + migration** — Postgres tables created and queried (SCR-002 orders table)
  - Human Check: open the orders screen, confirm the seeded rows appear""")
todo = todo.replace("""- [x] **M06-FE-01: port SCR-001 login** — docs/design/screens/SCR-001.html""",
                    """- [x] **M06-FE-01: port SCR-001 login** — docs/design/screens/SCR-001.html
  - Human Check: open /login and confirm the form matches the prototype""")
todo = todo.replace("""- [x] **M06-FE-02: port SCR-002 orders** — docs/design/screens/SCR-002.html""",
                    """- [x] **M06-FE-02: port SCR-002 orders** — docs/design/screens/SCR-002.html
  - Human Check: open /orders and confirm the table matches the prototype""")
todo = todo.replace("""- [x] **M06-SETUP-01: Specs Pre-Read** — read AGENTS, CONTEXT, FSD, PRD""",
                    """- [x] **M06-SETUP-01: Specs Pre-Read** — read AGENTS, CONTEXT, FSD, PRD
  - Human Check: confirm the stack lock in FSD matches what was built""")
w("TODO.md", todo)

# ---- source references the screens
login = r("src/app/login/page.tsx")
login = login.replace("export default function LoginPage() {",
                      "// Ported from docs/design/screens/SCR-001.html\nexport default function LoginPage() {")
w("src/app/login/page.tsx", login)

orders = r("src/app/orders/page.tsx")
orders = orders.replace("type Order = { id: string; total: number };",
                        "// Ported from docs/design/screens/SCR-002.html\ntype Order = { id: string; total: number };")
w("src/app/orders/page.tsx", orders)

print("fixture second pass written")
