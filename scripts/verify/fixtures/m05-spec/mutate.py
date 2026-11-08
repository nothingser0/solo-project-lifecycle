#!/usr/bin/env python3
"""Introduce one verified defect into the built M05 fixture, for the regression suite.

Each kind targets the exact line the gate reads. A mutation that changes nothing is an error, not a
silent pass: that mistake already made two probes lie about the gate in this session.
"""
import io
import re
import sys

root, kind = sys.argv[1], sys.argv[2]
fsd = f"{root}/docs/specs/FSD.md"
prd = f"{root}/docs/specs/PRD.md"


def read(p):
    try:
        return io.open(p, encoding="utf-8").read()
    except FileNotFoundError:
        raise SystemExit(f"missing {p}")


def write(p, s):
    io.open(p, "w", encoding="utf-8").write(s)


s = read(fsd)
before = s

if kind == "no-erd":
    write(fsd, re.sub(r"```mermaid\nerDiagram.*?\n```\n", "", s, flags=re.S))

elif kind == "erd-short":
    for t in ("CMS_ARTICLES", "CRM_DEALS", "IDEMPOTENCY_KEYS"):
        s = re.sub(rf"\n    {t} \{{\n(?:        [^\n]*\n)*?    \}}", "", s)
    write(fsd, s)

elif kind == "erd-orphan":
    write(fsd, s.replace("    AUDIT_LOGS {",
                         "    GHOST_TABLE {\n        uuid id PK\n    }\n    AUDIT_LOGS {", 1))

elif kind == "bdd-no-req":
    p = read(prd)
    write(prd, re.sub(r"Scenario: REQ-\d+ ", "Scenario: ", p))

elif kind == "lock-no-q":
    write(fsd, re.sub(r"(?m)^- Q[1-8] .*\n?", "", s))

elif kind == "q-placeholder":
    write(fsd, re.sub(r"(?m)^(- Q[1-8] [^:\n]*:).*$", r"\1 <answer>", s))

elif kind == "rejected-no-reason":
    write(fsd, re.sub(r"(?m)^Rejected: .*$", "Rejected: Kubernetes", s))

elif kind == "approver-placeholder":
    write(fsd, re.sub(r"(?m)^\*\*Approved by\*\*:.*$",
                      "**Approved by**: [Human reviewer name]", s))

elif kind == "approver-agent":
    write(fsd, re.sub(r"(?m)^\*\*Approved by\*\*:.*$", "**Approved by**: Claude Agent", s))

elif kind == "signoff-date":
    write(fsd, re.sub(r"(?m)^\*\*Approved on\*\*:.*$", "**Approved on**: YYYY-MM-DD", s))

elif kind == "storage-placeholder":
    write(fsd, re.sub(r"(?m)^\*\*Object storage decision\*\*:.*$",
                      "**Object storage decision**: [selected service, access]", s))

elif kind == "level-5":
    write(fsd, re.sub(r"(?m)^\*\*Compatibility Level\*\*:.*$",
                      "**Compatibility Level**: Level 5", s))

elif kind == "no-handoff":
    write(fsd, re.sub(r"## Module 04 Handoff Strategy\n(?:.*\n)*?(?=## )", "", s))

else:
    raise SystemExit(f"unknown kind {kind}")

if kind != "bdd-no-req" and io.open(fsd, encoding="utf-8").read() == before:
    raise SystemExit(f"mutation {kind} changed nothing")
print(kind)
