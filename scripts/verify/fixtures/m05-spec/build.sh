#!/usr/bin/env bash
# Build the M05 fixture repo from the shipped templates, so regressions can copy a repo whose every
# bracketed placeholder has been replaced the way the template instructs.
set -eu
HERE=$(cd "$(dirname "$0")" && pwd)
CLONE=$(cd "$HERE/../../../.." && pwd)
T="$CLONE/templates/03-architecture-specs"
DST="$HERE/repo"

# Never leave the caller inside a directory we delete: the shell loses its cwd.
cd "$CLONE"
rm -rf "$DST"
mkdir -p "$DST/docs/specs" "$DST/docs/governance" "$DST/docs/pm"

printf '# Project State\n\n- Delivery: solo\n- Scale: Medium\n- Intake-Success-Metric: 200 orders/day processed\n- Intake-P0-Features: 12 (catalog, orders, payments, admin)\n- Intake-Time-Capacity: 40 hrs/week x 12 weeks = 480 hrs\n- Intake-Sensitive-Data: no\n- Intake-Integrations: none\n- Intake-Branch-Hierarchy: no\n- Intake-Compliance: none\n- Intake-Legacy-Core: no\n- Intake-Status: ANSWERED\n- Next-Action: run the M05 gate\n- Open-Decisions: none\n\n## Stack\n\nRejected: Kubernetes because one VM runs 200 orders/day without an orchestrator.\n\nStack Decision LOCKED: Next.js 15 + Postgres 16 + Drizzle.\n' > "$DST/docs/pm/PROJECT_STATE.md"

python3 - "$T/PRD_FINAL_TEMPLATE.md" "$DST/docs/specs/PRD.md" <<'PY'
import io, re, sys
src, dst = sys.argv[1], sys.argv[2]
s = io.open(src, encoding="utf-8").read()
io.open(dst, "w", encoding="utf-8").write(re.sub(r"\[([^\[\]]{1,80})\]", r"<\1>", s))
PY

python3 - "$T/FSD_TECHNICAL_TEMPLATE.md" "$DST/docs/specs/FSD.md" <<'PY'
import io, re, sys
src, dst = sys.argv[1], sys.argv[2]
s = io.open(src, encoding="utf-8").read()
io.open(dst, "w", encoding="utf-8").write(re.sub(r"\[([^\[\]]{1,80})\]", r"<\1>", s))
PY

printf '# ADR\n\n## ADR-001 — stack\n\nRejected: Kubernetes because one VM runs 200 orders/day without an orchestrator.\n\nStack Decision LOCKED: Next.js 15 + Postgres 16 + Drizzle.\n' > "$DST/docs/governance/ADR.md"

python3 "$HERE/fill.py" "$DST/docs/specs/PRD.md" "$DST/docs/specs/FSD.md"
python3 "$HERE/erd.py"  "$DST/docs/specs/FSD.md"
echo "fixture built at $DST"
