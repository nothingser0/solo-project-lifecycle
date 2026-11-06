#!/usr/bin/env python3
"""Complete the M05 fixture the way a real project would, so the gate can judge the real defects.

The template already numbers its inputs `- Q1 Team Expertise: <answer>`, so the fill keeps the
`Q1 ` prefix and replaces only the value after the colon.
"""
import io
import re
import sys

prd, fsd = sys.argv[1], sys.argv[2]

answers = {
    "Q1": "one developer, strong in TypeScript and SQL, no Kubernetes experience",
    "Q2": "Postgres 16 in production for four years, comfortable writing migrations",
    "Q3": "single VPS with an app container and managed Postgres, no orchestrator",
    "Q4": "200 orders/day peak, 20 concurrent cashiers",
    "Q5": "Rp 250.000/month for hosting and database, no paid orchestrator",
    "Q6": "12 weeks to the first paying client, 2 weeks of buffer",
    "Q7": "UU PDP: customer names and phone numbers, no payment card storage",
    "Q8": "4 hours/week, so a boring, well documented stack",
}

s = io.open(fsd, encoding="utf-8").read()
for q, val in answers.items():
    s = re.sub(rf"(?m)^(- {q} [^:\n]*:).*$", lambda m, val=val: f"{m.group(1)} {val}", s)
s = re.sub(r"(?m)^\*\*Object storage decision\*\*:.*$",
           "**Object storage decision**: Cloudflare R2 for product photos, 5 MB cap per file, "
           "webp only, 30-day cache; the pilot never exceeds the 5 GB free tier.", s)
s = re.sub(r"<Level 1 \| Level 2 \| Level 3 \| Level 4>", "Level 2", s)

# The stack decision, with the alternative that lost and the measured reason it lost. The template's
# own "<the runner-up> because <why it lost>" is an instruction, not a decision.
s = re.sub(r"(?m)^Stack Decision LOCKED:.*$",
           "Stack Decision LOCKED: Next.js 15 + Postgres 16 + Drizzle.\n\n"
           "Rejected: Kubernetes because one VM runs 200 orders/day, and an orchestrator would "
           "add three moving parts for load we will not see for two years.", s)

# The template says "Replace every bracketed placeholder with a real value before running the
# gate", and the sign-off block is where that matters most: the reviewer, the date, the
# developer's self-validation and (for client delivery) the client PIC.
s = re.sub(r"(?m)^\*\*Approved by\*\*:.*$",
           "**Approved by**: Wahyu Nur Sagita — reviewed the RBAC matrix and the idempotency key "
           "design against the FSD §4 endpoints", s)
s = re.sub(r"(?m)^\*\*Approved on\*\*:.*$", "**Approved on**: 2026-11-06", s)
s = re.sub(r"(?m)^\*\*Validated by Solo Developer\*\*:.*$",
           "**Validated by Solo Developer**: Wahyu Nur Sagita (Date: 2026-11-06)", s)
s += """
## Module 04 Handoff Strategy

Level 2: the M04 prototype supplies the token set and the two screens; M06 rebuilds them as
components against the endpoints below, keeping the same spacing scale and type scale.

## Sign-off

Approved on: 2026-11-06
Approved by: Wahyu Nur Sagita (Solo Dev)
"""
io.open(fsd, "w", encoding="utf-8").write(s)

p = io.open(prd, encoding="utf-8").read()
p = p.replace("Scenario: Operator creates new resource with valid inputs",
              "Scenario: REQ-01 Operator creates new resource with valid inputs")
p = p.replace("Scenario: Client submits mutation with network retry",
              "Scenario: REQ-02 Client submits mutation with network retry")
io.open(prd, "w", encoding="utf-8").write(p)

print("fixture completed")
