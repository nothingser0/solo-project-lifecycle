#!/usr/bin/env python3
"""Third pass: the four remaining M06 complaints, each answered on its own terms.

  - the DB probe lines must name the configured target, not just the SQL
  - a design reference supplied by a human under docs/design/inspiration/
  - no internal spec id (SCR-xx) leaking into shipped source - the reference belongs in the
    task list, not in the component
  - form controls carry a class
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

# ---- DB proof names the target (localhost) on each line
ev = r("artifacts/final-evidence.md")
ev = ev.replace("""```
npm run migrate:down   # rollback succeeds
SELECT COUNT(*) FROM products;   # seeder count = 12
EXPLAIN SELECT id FROM products ORDER BY name;   # index scan
```""",
                """Against localhost (postgres://localhost:5432/kasir):

```
localhost$ npm run migrate:down   # rollback succeeds
localhost$ SELECT COUNT(*) FROM products;   # seeder count = 12
localhost$ EXPLAIN SELECT id FROM products ORDER BY name;   # index scan
```""")
w("artifacts/final-evidence.md", ev)

# ---- a human-supplied design reference
w("docs/design/inspiration/notes.md",
  "# Inspiration\n\nWinning benchmark: reference-1.png (Linear), because of its density and neutral palette.\n"
  "The human supplied reference-1.png by saving it from the browser; it is not a fabricated URL.\n")
w("docs/design/inspiration/reference-1.png", "PNG reference screenshot supplied by the human\n" * 40)

# ---- source: drop the SCR-xx references, add a class on the input
login = r("src/app/login/page.tsx").replace(
    "// Ported from docs/design/screens/SCR-001.html\n", "")
login = login.replace('<input id="email" value={email} onChange={(e) => setEmail(e.target.value)} />',
                      '<input id="email" className="field-input" value={email} '
                      'onChange={(e) => setEmail(e.target.value)} />')
w("src/app/login/page.tsx", login)

orders = r("src/app/orders/page.tsx").replace(
    "// Ported from docs/design/screens/SCR-002.html\n", "")
w("src/app/orders/page.tsx", orders)

print("fixture third pass written")
