#!/usr/bin/env bash
# test-gate-regressions.sh - Regression tests for validate-gate.sh
#
# Guards behavioral contracts that were previously broken. Each case builds a
# throwaway project, runs a gate, and asserts the outcome.
#
# Usage: bash scripts/verify/test-gate-regressions.sh
# Exit:  0 = all pass, 1 = at least one regression.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GATE="$SCRIPT_DIR/../gates/validate-gate.sh"

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

PASS=0
FAIL=0
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# make_project <dir> <statefile-content-or-empty>
make_project() {
    local dir="$1" state="$2"
    rm -rf "$dir"
    mkdir -p "$dir/docs/pm" "$dir/src"
    printf '# lite\n' > "$dir/PROJECT_LITE.md"
    printf '# AGENTS\n' > "$dir/AGENTS.md"
    printf '# TODO\n- [x] done\n' > "$dir/TODO.md"
    if [ -n "$state" ]; then
        printf "%b" "$state" > "$dir/docs/pm/PROJECT_STATE.md"
    fi
    ( cd "$dir" && git init -q . && git config user.email t@t.co && git config user.name T )
}

# expect_intake <name> <BLOCKED|ALLOWED> <state-content> <module>
expect_intake() {
    local name="$1" want="$2" state="$3" mod="$4"
    local dir="$WORK/p"
    make_project "$dir" "$state"
    local out
    out="$(cd "$dir" && bash "$GATE" "$mod" 2>&1)"
    local got="ALLOWED"
    if echo "$out" | grep -qE "Intake field incomplete|Intake field missing|Intake-Status not set|Intake Gate:.*missing"; then
        got="BLOCKED"
    fi
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  ($mod -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  ($mod -> $got, expected $want)"
        FAIL=$((FAIL + 1))
    fi
}

# The 3 escalation fields (Integrations / Branch-Hierarchy / Compliance) are read
# by classify-scale.sh and are mandatory: while they are absent a payment webhook
# or multi-tenant hierarchy is invisible and a project keeps its declared tier.
INTAKE_UNKNOWN='- **Scale**: Small\n- Delivery: UNKNOWN\n- Intake-Success-Metric: UNKNOWN\n- Intake-P0-Features: UNKNOWN\n- Intake-Time-Capacity: UNKNOWN\n- Intake-Sensitive-Data: UNKNOWN\n- Intake-Integrations: UNKNOWN\n- Intake-Branch-Hierarchy: UNKNOWN\n- Intake-Compliance: UNKNOWN\n- Intake-Legacy-Core: no\n- Intake-Status: UNKNOWN\n'
INTAKE_ANSWERED='- **Scale**: Small\n- Delivery: solo\n- Intake-Success-Metric: 10 users can create a task\n- Intake-P0-Features: 3 (create, list, complete)\n- Intake-Time-Capacity: 10 hrs/week x 3 weeks = 30 hrs\n- Intake-Sensitive-Data: no\n- Intake-Integrations: none\n- Intake-Branch-Hierarchy: no\n- Intake-Compliance: none\n- Intake-Legacy-Core: no\n- Intake-Status: ANSWERED\n'
INTAKE_MEDIUM='- **Scale**: Medium\n- Delivery: client\n- Intake-Success-Metric: 200 orders/day processed\n- Intake-P0-Features: 12 (catalog, orders, payments, admin)\n- Intake-Time-Capacity: 40 hrs/week x 12 weeks = 480 hrs\n- Intake-Sensitive-Data: no\n- Intake-Integrations: none\n- Intake-Branch-Hierarchy: no\n- Intake-Compliance: none\n- Intake-Legacy-Core: no\n- Intake-Status: ANSWERED\n'

echo -e "${BLUE}=== Gate Regression Tests ===${NC}"
echo ""
echo "Intake gate must block EVERY reachable module for Small projects."
echo "Regression: the check was once nested inside the scale-waiver branch,"
echo "so Small silently bypassed every mandatory intake question."
echo ""

for mod in M01 M02 M04 M05 M06; do
    expect_intake "Small + UNKNOWN intake, jump to $mod" BLOCKED "$INTAKE_UNKNOWN" "$mod"
done

expect_intake "Small + no PROJECT_STATE.md" BLOCKED "" M01
expect_intake "Small + ANSWERED intake" ALLOWED "$INTAKE_ANSWERED" M01
expect_intake "Small + ANSWERED intake (later module)" ALLOWED "$INTAKE_ANSWERED" M05

echo ""
echo "Per-task human approval gate: M06 must reject self-approved tasks."
echo "Regression: the gate required every task to be '[x]' but never checked"
echo "WHO ticked it, so an agent could self-approve a whole sprint."
echo ""

# expect_approval <name> <BLOCKED|ALLOWED> <todo-content>
expect_approval() {
    local name="$1" want="$2" todo="$3"
    local dir="$WORK/pa"
    make_project "$dir" "$INTAKE_ANSWERED"
    printf '%b' "$todo" > "$dir/TODO.md"
    local out
    out="$(cd "$dir" && bash "$GATE" M06 2>&1 || true)"
    local got="ALLOWED"
    if echo "$out" | grep -qE "missing a human approval line"; then
        got="BLOCKED"
    fi
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M06 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M06 -> $got, expected $want)"
        FAIL=$((FAIL + 1))
    fi
}

TASKS_SELF='- [x] **M06-DB-01: Schema**\n  - **Evidence**: migrations exit 0\n- [x] **M06-BE-01: API**\n  - **Evidence**: tests pass\n- [x] **M06-FE-01: Screens**\n  - **Evidence**: build exit 0\n'
TASKS_APPROVED='- [x] **M06-DB-01: Schema**\n  - **Evidence**: exit 0 | Approved: 2026-10-12 by S. Rahma\n- [x] **M06-BE-01: API**\n  - **Evidence**: pass | Approved: 2026-10-12 by S. Rahma\n- [x] **M06-FE-01: Screens**\n  - **Evidence**: pass | Approved: 2026-10-12 by S. Rahma\n'
TASKS_PARTIAL='- [x] **M06-DB-01: Schema**\n  - **Evidence**: exit 0 | Approved: 2026-10-12 by S. Rahma\n- [x] **M06-BE-01: API**\n  - **Evidence**: tests pass\n- [x] **M06-FE-01: Screens**\n  - **Evidence**: pass | Approved: 2026-10-12 by S. Rahma\n'
# Same defect with the bold markers omitted. The tick/pending counts are
# bold-agnostic, so the approval guard's own task-id pattern must be too.
TASKS_UNBOLD_SELF='- [x] M06-DB-01: Schema\n  - **Evidence**: migrations exit 0\n- [x] M06-BE-01: API\n  - **Evidence**: tests pass\n- [x] M06-FE-01: Screens\n  - **Evidence**: build exit 0\n'
TASKS_UNBOLD_APPROVED='- [x] M06-DB-01: Schema\n  - **Evidence**: exit 0 | Approved: 2026-10-12 by S. Rahma\n- [x] M06-BE-01: API\n  - **Evidence**: pass | Approved: 2026-10-12 by S. Rahma\n- [x] M06-FE-01: Screens\n  - **Evidence**: pass | Approved: 2026-10-12 by S. Rahma\n'

expect_approval "3 tasks [x], zero approvals (agent ran the sprint)" BLOCKED "$TASKS_SELF"
expect_approval "3 tasks [x], all approved by human" ALLOWED "$TASKS_APPROVED"
expect_approval "partial: one task self-approved" BLOCKED "$TASKS_PARTIAL"
expect_approval "unbolded ids, zero approvals (guard bypass)" BLOCKED "$TASKS_UNBOLD_SELF"
expect_approval "unbolded ids, all approved by human" ALLOWED "$TASKS_UNBOLD_APPROVED"

echo ""
echo "Actor attribution: the agent must never be a valid approver or self-deployer."
echo "Regression: 'solo self-approval' read as the agent approving its own work,"
echo "and M12's hotfix flow pushed to main with no human gate (contradicting M10)."
echo ""

REPO="$(cd "$SCRIPT_DIR/../.." && pwd)"

# check_doc <name> <file> <regex-that-must-be-absent>
check_forbidden() {
    local name="$1" file="$2" pat="$3"
    if [ ! -f "$file" ]; then
        echo -e "  ${RED}✗${NC} $name  (missing file: $file)"
        FAIL=$((FAIL + 1))
        return
    fi
    if grep -qE "$pat" "$file"; then
        echo -e "  ${RED}✗${NC} $name  (forbidden pattern present)"
        FAIL=$((FAIL + 1))
    else
        echo -e "  ${GREEN}✓${NC} $name"
        PASS=$((PASS + 1))
    fi
}

# check_required <name> <file> <regex-that-must-be-present>
check_required() {
    local name="$1" file="$2" pat="$3"
    if [ ! -f "$file" ]; then
        echo -e "  ${RED}✗${NC} $name  (missing file: $file)"
        FAIL=$((FAIL + 1))
        return
    fi
    if grep -qE "$pat" "$file"; then
        echo -e "  ${GREEN}✓${NC} $name"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (required pattern absent)"
        FAIL=$((FAIL + 1))
    fi
}

# Every stack harness must carry the one-task-per-turn protocol.
STACK_FAIL=0
for stage in "$REPO"/templates/04-dev-execution/*/; do
    agents="$stage/AGENTS.md"
    [ -f "$agents" ] || continue
    if ! grep -qE "Execution Protocol|one task at a time|one task per turn" "$agents"; then
        echo -e "  ${RED}✗${NC} $(basename "$stage")/AGENTS.md lacks the one-task-per-turn protocol"
        STACK_FAIL=1
    fi
done
if [ "$STACK_FAIL" -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} all stack AGENTS.md templates carry the per-task protocol"
    PASS=$((PASS + 1))
else
    FAIL=$((FAIL + 1))
fi

# 'solo self-approval' must never appear undefined — it invites the agent to self-approve.
for md in "$REPO"/docs/modules/variants/04_UIUX_LITE.md "$REPO"/docs/modules/04_UIUX_PROTOTYPING.md "$REPO"/docs/modules/05_ARCHITECTURE_SPECS.md "$REPO"/templates/essentials/LITE_DESIGN_SPEC_TEMPLATE.md; do
    check_forbidden "$(basename "$md") has no bare 'solo self-approval'" "$md" "solo self-approval"
done

# M12's hotfix flow must contain a human stop before merging to main.
check_required "M12 hotfix stops for the human before main" "$REPO/docs/modules/12_WARRANTY_SLA_RETAINER.md" "STOP: the human merges .?main|human merges .?main"

echo ""
echo "Human-input gates: artefact existence must not be confused with human sign-off."
echo "Regression: M04 passed on file size alone (agent could fill the approval row),"
echo "M05 checked only a literal lock marker, and M08/M10 never verified that the"
echo "client actually handed over data/credentials."
echo ""

# expect_human_input <name> <BLOCKED|ALLOWED> <module> <file-relative-path> <content>
expect_human_input() {
    local name="$1" want="$2" mod="$3" rel="$4" content="$5"
    local dir="$WORK/phi"
    make_project "$dir" "$INTAKE_ANSWERED"
    mkdir -p "$dir/$(dirname "$rel")"
    printf '%b' "$content" > "$dir/$rel"
    local out
    out="$(cd "$dir" && bash "$GATE" "$mod" 2>&1 || true)"
    local got="ALLOWED"
    if echo "$out" | grep -qE "missing a named Design Freeze approver|missing a real Design Freeze date|still holds blank/placeholder|records only [0-9]+/8|no record that the client-supplied"; then
        got="BLOCKED"
    fi
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  ($mod -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  ($mod -> $got, expected $want)"
        FAIL=$((FAIL + 1))
    fi
}

# A. Design Freeze (M04)
FREEZE_BLANK='# DESIGN_SPEC\n\n## Design Freeze\n\n| **Name**: _________________________ |\n| **Date**: [YYYY-MM-DD] |\n'
FREEZE_SIGNED='# DESIGN_SPEC\n\n## Design Freeze\n\n- Approved by: S. Rahma (founder)\n- Approved on: 2026-10-12\n'
expect_human_input "M04 freeze left as a blank template" BLOCKED M04 "docs/specs/DESIGN_SPEC.md" "$FREEZE_BLANK"
expect_human_input "M04 freeze signed by a human" ALLOWED M04 "docs/specs/DESIGN_SPEC.md" "$FREEZE_SIGNED"

# A2. Design inspiration (M04) — HUMAN-ONLY input.
# Regression: the gate accepted notes.md alone, so the "reference" requirement was
# satisfiable with a document the agent wrote itself. The guard now requires >=1
# file in inspiration/ that the agent could not have authored, and notes.md must
# cite a filename that actually exists (a benchmark with no file is fabricated).
# expect_inspiration <name> <BLOCKED|ALLOWED> <"filename:content" ...>
# The content is what makes each case meaningful: case "human screenshot + notes.md
# citing it" passes ONLY because notes.md names the file that exists, and the
# negative cases pass only because notes.md does (or does not) name a real file.
expect_inspiration() {
    local name="$1" want="$2"; shift 2
    local dir="$WORK/insp"
    make_project "$dir" "$INTAKE_ANSWERED"
    mkdir -p "$dir/docs/design/inspiration"
    local spec
    for spec in "$@"; do
        printf '%s\n' "${spec#*:}" > "$dir/docs/design/inspiration/${spec%%:*}"
    done
    local out
    out="$(cd "$dir" && bash "$GATE" M04 2>&1 || true)"
    local got="ALLOWED"
    if echo "$out" | grep -qE "no HUMAN-supplied reference|Design references: no|cites no filename present"; then
        got="BLOCKED"
    fi
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M04 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M04 -> $got, expected $want)"
        echo "$out" | grep -E '❌ Design' | head -2 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}

expect_inspiration "M04 inspiration folder empty (agent must stop and ask)" BLOCKED
expect_inspiration "M04 only notes.md — and it cites its own fabricated benchmark" BLOCKED "notes.md:Selected Benchmark: Linear"
expect_inspiration "M04 notes.md cites a file that does not exist" BLOCKED "notes.md:Linear reference-9-missing.png"
expect_inspiration "M04 human screenshot + notes.md citing it" ALLOWED "notes.md:reference-1-dashboard.png" "reference-1-dashboard.png:binary-data"

# B. Stack questionnaire (M05) — the marker alone must not pass.
printf '%b' '# PROJECT_LITE\n\nCREATE TABLE users (id uuid);\nGET /api/users\nPOST /api/users\n- **Feature**: login\n\nStack Decision LOCKED: Next.js\n' > "$WORK/pl_noq.md"
printf '%b' '# PROJECT_LITE\n\nCREATE TABLE users (id uuid);\nGET /api/users\nPOST /api/users\n- **Feature**: login\n\nStack Decision LOCKED: Next.js\nStack-Locked-by: S. Rahma\n\n- Q1 Team Expertise: x\n- Q2 Database Experience: x\n- Q3 Deployment Topology: x\n- Q4 Expected Scale (Year 1): x\n- Q5 Data Model Characteristics: x\n- Q6 DevOps Complexity Tolerance: x\n- Q7 Critical Feature Priority: x\n- Q8 Compliance Requirements: x\n' > "$WORK/pl_8q.md"

run_lock() {
    local name="$1" want="$2" src="$3"
    local dir="$WORK/plk"
    make_project "$dir" "$INTAKE_ANSWERED"
    cp "$src" "$dir/PROJECT_LITE.md"
    local out
    out="$(cd "$dir" && bash "$GATE" M05 2>&1 || true)"
    local got="ALLOWED"
    if echo "$out" | grep -qE "records only [0-9]+/8 .*questionnaire"; then
        got="BLOCKED"
    fi
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M05 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M05 -> $got, expected $want)"
        FAIL=$((FAIL + 1))
    fi
}

run_lock "M05 lock marker with zero questionnaire answers" BLOCKED "$WORK/pl_noq.md"
run_lock "M05 lock backed by all 8 answers" ALLOWED "$WORK/pl_8q.md"

# B1b. M05 RLS trigger. Regression: the check grepped free text over PROJECT_STATE.md
# for "branch|tenant|organization", and the shipped template's own line
# "- Intake-Branch-Hierarchy: [no | yes]" contains "branch" — so EVERY project,
# including a genuinely single-tenant one, was told its FSD was missing RLS policies.
# The trigger must come from the structured Intake field the classifier reads.
run_rls() {
    local name="$1" want="$2" branch="$3" fsextra="$4"
    local dir="$WORK/rls"
    make_project "$dir" "- **Scale**: Medium\n- Delivery: client\n- Intake-Success-Metric: 50 invoices/day\n- Intake-P0-Features: 10 (invoices, reports)\n- Intake-Time-Capacity: 40 hrs/week x 10 weeks\n- Intake-Sensitive-Data: no\n- Intake-Integrations: none\n- Intake-Branch-Hierarchy: $branch\n- Intake-Compliance: none\n- Intake-Legacy-Core: no\n- Intake-Status: ANSWERED\n"
    mkdir -p "$dir/docs/specs"
    {
        printf -- '## 1. Document Metadata\n'
        printf -- '## 2. Component Architecture & Tech Stack Decisions\n'
        printf -- 'Stack Decision LOCKED: FastAPI\nStack-Locked-by: S. Rahma\n'
        printf -- '### Framework Versions (Pinned):\n- FastAPI: 0.143.0\n'
        printf -- '- Q1 Team Expertise: x\n- Q2 Database Experience: x\n- Q3 Deployment Topology: x\n'
        printf -- '- Q4 Expected Scale (Year 1): x\n- Q5 Data Model Characteristics: x\n'
        printf -- '- Q6 DevOps Complexity Tolerance: x\n- Q7 Critical Feature Priority: x\n'
        printf -- '- Q8 Compliance Requirements: x\n'
        printf -- '## 3. Relational Database Schema\nCREATE TABLE invoices (id uuid primary key, total bigint);\n'
        printf -- '## 6. API Contract Specifications\n'
        printf -- '#### GET /api/v1/invoices\n#### POST /api/v1/invoices\n#### PATCH /api/v1/invoices/:id\n'
        printf -- '#### DELETE /api/v1/invoices/:id\n#### POST /api/v1/auth/login\n'
        printf -- '#### GET /api/v1/invoices/:id\n#### POST /api/v1/invoices/:id/void\n'
        printf -- '#### POST /api/v1/invoices/:id/pay\n#### POST /api/v1/invoices/:id/refund\n'
        printf -- '#### POST /api/v1/reports/daily\n'
        printf -- '## 7. Security Blueprint\nAES-256-GCM; Argon2id; OWASP Top 10; rate limiting.\n'
        printf -- '## 8. Module 04 Handoff Strategy\n**Compatibility Level**: Level 2\n'
        printf -- '**Approved by**: S. Rahma\n**Approved on**: 2026-10-12\n**Approved by Client Single PIC**: S. Rahma (Date: 2026-10-12)\n'
        printf '%b' "$fsextra"
    } > "$dir/docs/specs/FSD.md"
    local out
    out="$(cd "$dir" && bash "$GATE" M05 2>&1 || true)"
    local got="ALLOWED"
    if echo "$out" | grep -q "missing Row-Level Security"; then
        got="BLOCKED"
    fi
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M05 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M05 -> $got, expected $want)"
        FAIL=$((FAIL + 1))
    fi
}

run_rls "M05 single-tenant project is NOT asked for RLS" ALLOWED "no" ""
run_rls "M05 multi-branch project IS asked for RLS" BLOCKED "yes" ""
run_rls "M05 single-tenant but FSD declares org_id -> RLS required" BLOCKED "no" "\nCREATE TABLE users (org_id uuid not null);\n"

# B1c. M05 endpoint counting. Regression: the old pattern required a bare "####" at
# column 0, so a heading nested under a section (template-faithful) scored 0 and no
# project could pass its own gate. The floor is 10 (M05 STEP 4 / exit criteria).
run_endpoints() {
    local name="$1" want="$2" body="$3"
    local dir="$WORK/ep"
    make_project "$dir" "$INTAKE_MEDIUM"
    mkdir -p "$dir/docs/specs"
    {
        printf -- '## 1. Document Metadata\n'
        printf -- '## 2. Component Architecture & Tech Stack Decisions\n'
        printf -- 'Stack Decision LOCKED: Next.js\nStack-Locked-by: S. Rahma\n'
        printf -- '### Framework Versions (Pinned):\n- Next.js: 15.0.3\n'
        printf -- '- Q1 Team Expertise: x\n- Q2 Database Experience: x\n- Q3 Deployment Topology: x\n'
        printf -- '- Q4 Expected Scale (Year 1): x\n- Q5 Data Model Characteristics: x\n'
        printf -- '- Q6 DevOps Complexity Tolerance: x\n- Q7 Critical Feature Priority: x\n'
        printf -- '- Q8 Compliance Requirements: x\n'
        printf -- '## 3. Relational Database Schema\nCREATE TABLE a (id uuid);\n'
        printf '%b' "$body"
    } > "$dir/docs/specs/FSD.md"
    local out
    out="$(cd "$dir" && bash "$GATE" M05 2>&1 || true)"
    local got="TOO_FEW"
    if echo "$out" | grep -q "API endpoint contracts verified"; then
        got="ENOUGH"
    fi
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M05 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M05 -> $got, expected $want)"
        FAIL=$((FAIL + 1))
    fi
}

# Indented headings (2 spaces) prove the leading-space tolerance in the pattern.
TEN_HEADINGS='## 6. API\n  #### GET /api/v1/a\n#### POST /api/v1/a\n#### PATCH /api/v1/a/:id\n#### DELETE /api/v1/a/:id\n#### POST /api/v1/login\n#### GET /api/v1/b\n#### POST /api/v1/b\n#### PATCH /api/v1/b/:id\n#### DELETE /api/v1/b/:id\n#### POST /api/v1/b/approve\n'
NINE_HEADINGS='## 6. API\n#### GET /api/v1/a\n#### POST /api/v1/a\n#### PATCH /api/v1/a/:id\n#### DELETE /api/v1/a/:id\n#### POST /api/v1/login\n#### GET /api/v1/b\n#### POST /api/v1/b\n#### PATCH /api/v1/b/:id\n#### DELETE /api/v1/b/:id\n'
run_endpoints "M05 FSD with 10 endpoint headings (one indented) passes the floor" ENOUGH "$TEN_HEADINGS"
run_endpoints "M05 FSD with 9 endpoint headings fails the floor" TOO_FEW "$NINE_HEADINGS"
# B2. M05 deliverables that were never verified. The first case is the false-green
# that motivated the guard: copy the RAW PROJECT_LITE_TEMPLATE.md, change ONLY the
# lock line, and the old gate passed with "8 recorded questionnaire answers" because
# the template ships 8 literal "- Q1 ... [answer]" lines. Placeholders are not answers.
#
# expect_m05 <name> <BLOCKED|ALLOWED> <regex-that-marks-the-failure> <build-fn>
expect_m05() {
    local name="$1" want="$2" pattern="$3" build="$4"
    local dir="$WORK/m05_$build"
    make_project "$dir" "$INTAKE_ANSWERED"
    mkdir -p "$dir/docs/specs" "$dir/docs/governance"
    "$build" "$dir"
    local out
    out="$(cd "$dir" && bash "$GATE" M05 2>&1 || true)"
    local got="ALLOWED"
    if echo "$out" | grep -qE "$pattern"; then
        got="BLOCKED"
    fi
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M05 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M05 -> $got, expected $want)"
        FAIL=$((FAIL + 1))
    fi
}
# A filled answer block + the Small-path artefacts the gate now requires.
ANSWERED_Q8='- Q1 Team Expertise: TypeScript\n- Q2 Database Experience: PostgreSQL\n- Q3 Deployment Topology: PaaS\n- Q4 Expected Scale (Year 1): under 100 users\n- Q5 Data Model Characteristics: fixed schema\n- Q6 DevOps Complexity Tolerance: zero-config\n- Q7 Critical Feature Priority: speed\n- Q8 Compliance Requirements: UU PDP light\n'
SECURITY_OK='AES-256-GCM envelope encryption; Argon2id hashing; OWASP Top 10; rate limiting 60/min.\n'
HANDOFF_OK='### Module 04 Handoff Strategy\n**Compatibility Level**: Level 3\n**Conversion Plan**: rebuild 6 components.\n'
SIGNOFF_OK='**Approved by**: S. Rahma\n**Approved on**: 2026-10-12\n**Validated by Solo Developer**: S. Rahma (Date: 2026-10-12)\n'

build_raw_template() { # the false-green: raw template with only the lock line edited
    sed 's|^Stack Decision LOCKED: \[Next.js / Laravel / Django / Go / SvelteKit / FastAPI\]|Stack Decision LOCKED: Next.js|' \
        "$REPO/templates/03-architecture-specs/PROJECT_LITE_TEMPLATE.md" > "$1/PROJECT_LITE.md"
}
build_no_security() {
    { printf '# PROJECT_LITE\n\nCREATE TABLE users (id uuid);\nGET /api/users\nPOST /api/users\nStack Decision LOCKED: Next.js\nStack-Locked-by: S. Rahma\n'; printf '%b' "$ANSWERED_Q8$HANDOFF_OK$SIGNOFF_OK"; } > "$1/PROJECT_LITE.md"
}
build_no_handoff() {
    { printf '# PROJECT_LITE\n\nCREATE TABLE users (id uuid);\nGET /api/users\nPOST /api/users\nStack Decision LOCKED: Next.js\nStack-Locked-by: S. Rahma\n'; printf '%b' "$ANSWERED_Q8$SECURITY_OK$SIGNOFF_OK"; } > "$1/PROJECT_LITE.md"
}
build_blank_signoff() {
    { printf '# PROJECT_LITE\n\nCREATE TABLE users (id uuid);\nGET /api/users\nPOST /api/users\nStack Decision LOCKED: Next.js\nStack-Locked-by: S. Rahma\n'; printf '%b' "$ANSWERED_Q8$SECURITY_OK$HANDOFF_OK"; printf '**Approved by**: _________________________\n**Approved on**: [YYYY-MM-DD]\n'; } > "$1/PROJECT_LITE.md"
}
build_all_ok() {
    { printf '# PROJECT_LITE\n\nCREATE TABLE users (id uuid);\nGET /api/users\nPOST /api/users\nStack Decision LOCKED: Next.js\nStack-Locked-by: S. Rahma\n'; printf '%b' "$ANSWERED_Q8$SECURITY_OK$HANDOFF_OK$SIGNOFF_OK"; } > "$1/PROJECT_LITE.md"
}
# A role word satisfies "a leading letter" but is not a named human. Both approver
# checks (stack lock and technical sign-off) must reject it, or the rule is vacuous.
build_role_approver() { # $1 = target dir, $2 = role string
    local dir="$1" role="$2"
    { printf '# PROJECT_LITE\n\nCREATE TABLE users (id uuid);\nGET /api/users\nPOST /api/users\nStack Decision LOCKED: Next.js\nStack-Locked-by: %s\n' "$role"; printf '%b' "$ANSWERED_Q8$SECURITY_OK$HANDOFF_OK"; printf '**Approved by**: %s\n**Approved on**: 2026-10-12\n**Validated by Solo Developer**: %s (Date: 2026-10-12)\n' "$role" "$role"; } > "$dir/PROJECT_LITE.md"
}
build_role_approver_validation() { build_role_approver "$1" "Validation Lead"; }
build_role_approver_founder() { build_role_approver "$1" "Founder"; }
build_role_approver_admin() { build_role_approver "$1" "Admin"; }

expect_m05 "M05 raw PROJECT_LITE template, only the lock line edited (placeholder answers)" BLOCKED "records only [0-9]+/8 real questionnaire" build_raw_template
expect_m05 "M05 lock line but no security blueprint" BLOCKED "security blueprint incomplete" build_no_security
expect_m05 "M05 lock line but no Module 04 handoff" BLOCKED "missing the 'Module 04 Handoff Strategy'" build_no_handoff
expect_m05 "M05 blank/placeholder sign-off fields" BLOCKED "blank/placeholder sign-off fields" build_blank_signoff
expect_m05 "M05 complete Small-path artifact set" ALLOWED "Gate validation FAILED" build_all_ok
# Role words are not named humans — the check must not be satisfied by a title.
expect_m05 "M05 approver is the role string 'Validation Lead'" BLOCKED "no human in 'Stack-Locked-by:'" build_role_approver_validation
expect_m05 "M05 approver is 'Founder'" BLOCKED "no human in 'Stack-Locked-by:'" build_role_approver_founder
expect_m05 "M05 approver is 'Admin'" BLOCKED "no human in 'Stack-Locked-by:'" build_role_approver_admin
# C. Client input receipt (M08). Medium scale: M08 is WAIVED for Small, so a Small
# fixture would pass vacuously and the guard would go untested.
expect_client_input() {
    local name="$1" want="$2" content="$3"
    local dir="$WORK/pci"
    # This helper exercises the CLIENT-INPUT check, which only runs when M08 is not
    # waived. `Intake-Legacy-Core: no` is a greenfield project, and M08 is now
    # correctly waived for it — so this fixture declares legacy data explicitly.
    local intake="${INTAKE_MEDIUM/Intake-Legacy-Core: no/Intake-Legacy-Core: yes}"
    make_project "$dir" "$intake"
    printf '%b' "$content" > "$dir/docs/pm/DATA_MIGRATION_PLAN.md"
    local out
    out="$(cd "$dir" && bash "$GATE" M08 2>&1 || true)"
    local got="ALLOWED"
    # Two distinct rejection messages: no marker at all, and a marker that is still a
    # placeholder. Both mean BLOCKED; matching only the first hid the placeholder case.
    if echo "$out" | grep -qE "no record that the client-supplied|client-input line is present but still a placeholder"; then
        got="BLOCKED"
    fi
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M08 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M08 -> $got, expected $want)"
        FAIL=$((FAIL + 1))
    fi
}

expect_client_input "M08 plan with no client-input record (Medium)" BLOCKED "# PLAN\n\nno handover recorded here at all\n"
expect_client_input "M08 plan recording the client handover (Medium)" ALLOWED "# PLAN\n\nInputs-Received: POS export from Budi (PIC) on 2026-10-12\n\n"
# A present-but-unfilled marker is the false green this check exists to prevent:
# the shipped template line matched the key and nothing else was required.
expect_client_input "M08 plan with the unfilled Inputs-Received template line (Medium)" BLOCKED "# PLAN\n\nInputs-Received: [what was received] from [client PIC] on [YYYY-MM-DD]\n"
expect_client_input "M08 plan with an empty Inputs-Received value (Medium)" BLOCKED "# PLAN\n\nInputs-Received:\n"

# The other direction of the waiver: INTAKE_GATE defines Intake-Legacy-Core as yes|no,
# and `no` is a greenfield project, so M08 must be WAIVED for it. Before the fix the
# waiver only matched `greenfield|none`, which no template ever produced.
expect_m08_waived() {
    local name="$1" legacy="$2" want="$3"
    local dir="$WORK/m08w"
    local intake="${INTAKE_MEDIUM/Intake-Legacy-Core: no/Intake-Legacy-Core: $legacy}"
    make_project "$dir" "$intake"
    printf '# PLAN\n\nno migration plan recorded\n' > "$dir/docs/pm/DATA_MIGRATION_PLAN.md"
    local out got
    out="$(cd "$dir" && bash "$GATE" M08 2>&1 || true)"
    got="NOT_WAIVED"
    printf '%s' "$out" | grep -qiE "M08 Data Migration is WAIVED" && got="WAIVED"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M08 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M08 -> $got, expected $want)"
        FAIL=$((FAIL + 1))
    fi
}
expect_m08_waived "M08 waived for greenfield (Intake-Legacy-Core: no)" no WAIVED
expect_m08_waived "M08 NOT waived when legacy data exists (yes)" yes NOT_WAIVED

# E. The authority matrix must exist and be referenced from SKILL.md.
check_required "docs/AUTHORITY.md exists (single source of role attribution)" "$REPO/docs/AUTHORITY.md" "HUMAN-ONLY|FORBIDDEN"
check_required "SKILL.md references docs/AUTHORITY.md" "$REPO/SKILL.md" "docs/AUTHORITY\.md"

echo ""
echo "Gate completeness: a failing precondition must not hide later checks."
echo "Regression: 'set -e' aborted the script at the first failing bare call, so the"
echo "checklist truncated and the final verdict never printed."
echo ""

# A failing intake must still let the WHOLE checklist run and reach the summary.
TRUNC_DIR="$WORK/trunc"
make_project "$TRUNC_DIR" "$INTAKE_UNKNOWN"
printf -- '- [x] **M06-DB-01**\n' > "$TRUNC_DIR/TODO.md"
trunc_out="$(cd "$TRUNC_DIR" && bash "$GATE" M06 2>&1 || true)"
if printf '%s\n' "$trunc_out" | grep -qE "Gate validation (FAILED|PASSED)"; then
    echo -e "  ${GREEN}✓${NC} failing intake still prints the final verdict (no set -e truncation)"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}✗${NC} failing intake truncates the checklist — final verdict never printed"
    FAIL=$((FAIL + 1))
fi

# Every stack directory that ships an AGENTS.md must carry the protocol, and the
# two formerly-placeholder stacks must now ship one at all.
for stack in astro nuxt; do
    if [ -f "$REPO/templates/04-dev-execution/$stack/AGENTS.md" ]; then
        echo -e "  ${GREEN}✓${NC} $stack/AGENTS.md exists (was a placeholder until 2027)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $stack/AGENTS.md missing"
        FAIL=$((FAIL + 1))
    fi
done

# M02 must not let the agent publish legal text unreviewed.
check_required "M02 requires legal review before publishing legal text" "$REPO/docs/modules/02_DISCOVERY_SCOPE.md" "LEGAL-REVIEW"

echo ""
echo "M00-lite: the shipped template must PASS its own gate, and no under-evidenced"
echo "report may pass. Regressions: the machine field was written bold by the template"
echo "while the gate expected the bare form (template-faithful docs FAILED, de-formatted"
echo "ones PASSED); a 1-visitor/1-signup page passed the 5% bar; the declared decision"
echo "was never reconciled against the numbers; PASS needed no human attribution."
echo ""

# expect_m00 <name> <EXPECTED> <waitlist-line+extras>; EXPECTED in PASS|RETEST|FAIL
expect_m00() {
    local name="$1" want="$2" extras="$3"
    local dir="$WORK/m00"
    rm -rf "$dir"; mkdir -p "$dir/docs/pm"
    printf '%b' '- **Scale**: Medium\n- Delivery: solo\n' > "$dir/docs/pm/PROJECT_STATE.md"
    {
        printf '# M00-Lite: Rapid Market Validation\n\n'
        printf '## 1. Project Metadata & Problem Pitch\n'
        printf -- '- **Project Codename**: KasirKilat\n- **Target User**: Micro-retail owners\n'
        printf -- '- **Core Pain**: Physical stock discrepancies vs Excel records\n'
        printf -- '- **Proposed Solution**: Offline-first cashier app\n'
        printf -- '- **Proposed Price Point**: Rp 99000 / month\n'
        printf -- '- **Validation Lead**: S. Rahma\n- **Date**: 2026-10-12\n\n'
        printf '## 2. Riskiest Assumption Register (RAT)\n\n'
        printf '| ID | Core Hypothesis | Risk Level | Evidence Needed | Cheap Test Method | Kill Threshold | Outcome |\n'
        printf '|:---|:---|:---:|:---|:---|:---|:---:|\n'
        printf '| **ASM-01** | Users lose money monthly | HIGH | 3/5 confirm loss | Deep interviews | <2 respondents | ✅ |\n'
        printf '| **ASM-02** | Users will pay | HIGH | Waitlist with price anchor | Landing page | <2.0%% | ✅ |\n\n'
        printf '## 3. Quick Competitor & Alternative Check\n\n'
        printf '| Solution Name | Type | Price / Tier | Strengths | Critical Weaknesses | Unique Differentiator We Offer |\n'
        printf '|:---|:---|:---|:---|:---|:---|\n'
        printf '| Pesanan Toko | Direct SaaS | Rp 200k/mo | Brand | Offline broken | Offline-first |\n'
        printf '| **SIAPIK / Excel** | Free / Govt | Rp 0 | Free | Manual | Auto sync |\n\n'
        printf '## 4. Qualitative User Discovery (5 User Interviews)\n\n'
        printf '| Respondent ID | Role / Business Type | Current Solution | Biggest Friction / Loss | Willingness to Pay | Evidence Status |\n'
        printf '|:---|:---|:---|:---|:---|:---:|\n'
        printf '| **INT-01** | Grocery, 2 staff | paper | Rp 800k loss | Rp 50k-100k/mo | ✅ Real |\n'
        printf '| **INT-02** | Pet shop | Excel | Corrupt sheets | Rp 100k/mo | ✅ Real |\n'
        printf '| **INT-03** | Boutique | POS app X | Slow offline | Rp 150k/mo | ✅ Real |\n'
        printf '| **INT-04** | Warung | paper | Rp 500k loss | Rp 50k/mo | ⏳ Pending |\n'
        printf '| **INT-05** | Minimarket | Excel | Rp 1.2M loss | Rp 100k/mo | ⏳ Pending |\n\n'
        printf '## 5. Behavioral Intent Validation (Waitlist / Smoke Test)\n\n'
        printf '%b' "$extras"
        printf '\n## 6. Unit Economics & Solo Capacity Sanity Check\n\n'
        printf -- '- **Target ARPU**: Rp 99000 / month\n\n'
        printf '## 7. Kill Criteria & Gate Validation Outcome\n\n### Kill Criteria Triggers:\n'
        printf '1. Market Kill: conversion < 2.0%% after >=100 visitors\n\n'
    } > "$dir/docs/pm/M00_LITE.md"
    local out code got
    out="$(cd "$dir" && bash "$GATE" M00 2>&1)"; code=$?
    case "$code" in
        0) got="PASS" ;;
        3) got="RETEST" ;;
        *) got="FAIL" ;;
    esac
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M00 -> $got, exit $code)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M00 -> $got, expected $want)"
        echo "$out" | grep -E '❌|⚠️' | 
        
        -3 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}

# The template's own formatting: bullets, bold field names, trailing "%".
WL_TEMPLATE='- **Landing Page URL / Platform**: https://kasirkilat.carrd.co
- **Traffic Source**: merchant communities
- **Total Unique Visitors**: 140
- **Total Waitlist / Email Signups**: 9
- **Conversion Rate**: (9 / 140) x 100% = 6.43%
- **Waitlist-Conversion-Pct**: 6.4
- **Gate Pass Benchmark**: >= 5.0% waitlist conversion

Validated-by: S. Rahma on 2026-10-12

Gate-Decision: PASS
'
expect_m00 "template-style bold fields at 6.4% + 140 visits" PASS "$WL_TEMPLATE"

# Regression: the exact bug — a template-faithful document used to FAIL while a
# de-formatted one PASSED. Both must now be equal.
WL_BARE='Total Unique Visitors: 140
Total Waitlist / Email Signups: 9
Waitlist-Conversion-Pct: 6.4

Validated-by: S. Rahma on 2026-10-12

Gate-Decision: PASS
'
expect_m00 "same evidence, formatting stripped (parity with bold)" PASS "$WL_BARE"

# Sample floor: a rate is not evidence below 100 targeted visits.
WL_SMALL='- **Total Unique Visitors**: 1
- **Total Waitlist / Email Signups**: 1
- **Waitlist-Conversion-Pct**: 100

Validated-by: S. Rahma on 2026-10-12

Gate-Decision: PASS
'
expect_m00 "1 visitor / 1 signup = 100% (below visit floor)" FAIL "$WL_SMALL"

# RETEST band must be representable and must NOT pass.
WL_RETEST='- **Total Unique Visitors**: 140
- **Total Waitlist / Email Signups**: 5
- **Waitlist-Conversion-Pct**: 3.6

Validated-by: S. Rahma on 2026-10-12

Gate-Decision: RETEST
'
expect_m00 "3.6% waitlist declared RETEST" RETEST "$WL_RETEST"

# Inflating the decision on a RETEST-band number is the core anti-gaming check.
WL_INFLATED='- **Total Unique Visitors**: 140
- **Total Waitlist / Email Signups**: 5
- **Waitlist-Conversion-Pct**: 3.6

Validated-by: S. Rahma on 2026-10-12

Gate-Decision: PASS
'
expect_m00 "3.6% but declared PASS (talked up)" FAIL "$WL_INFLATED"

# KILL band.
WL_KILL='- **Total Unique Visitors**: 200
- **Total Waitlist / Email Signups**: 2
- **Waitlist-Conversion-Pct**: 1.0

Validated-by: S. Rahma on 2026-10-12

Gate-Decision: FAIL
'
expect_m00 "1.0% waitlist declared FAIL" FAIL "$WL_KILL"

# Arithmetic the gate can check: signups cannot exceed visitors.
WL_IMPOSSIBLE='- **Total Unique Visitors**: 120
- **Total Waitlist / Email Signups**: 200
- **Waitlist-Conversion-Pct**: 6.0

Validated-by: S. Rahma on 2026-10-12

Gate-Decision: PASS
'
expect_m00 "signups exceed visitors (impossible)" FAIL "$WL_IMPOSSIBLE"

# Percent that contradicts signups/visitors.
WL_MISMATCH='- **Total Unique Visitors**: 1000
- **Total Waitlist / Email Signups**: 10
- **Waitlist-Conversion-Pct**: 6.0

Validated-by: S. Rahma on 2026-10-12

Gate-Decision: PASS
'
expect_m00 "6.0% contradicts 10/1000 (=1.0%)" FAIL "$WL_MISMATCH"

# Secondary signal rescues the RETEST band.
WL_INTENT='- **Total Unique Visitors**: 140
- **Total Waitlist / Email Signups**: 5
- **Waitlist-Conversion-Pct**: 3.6
- **Intent-to-Buy-Pct**: 34

Validated-by: S. Rahma on 2026-10-12

Gate-Decision: PASS
'
expect_m00 "3.6% waitlist but 34% intent-to-buy" PASS "$WL_INTENT"

# PASS requires a named human validator with a real date.
WL_NOATTR='- **Total Unique Visitors**: 140
- **Total Waitlist / Email Signups**: 9
- **Waitlist-Conversion-Pct**: 6.4

Gate-Decision: PASS
'
expect_m00 "6.4% but no Validated-by attribution" FAIL "$WL_NOATTR"

# Unresolved placeholders must not pass, even with good numbers.
WL_PLACEHOLDER='- **Total Unique Visitors**: 140
- **Total Waitlist / Email Signups**: 9
- **Waitlist-Conversion-Pct**: 7.5
- **Proposed Price Point**: Rp [X]/mo

Validated-by: S. Rahma on 2026-10-12

Gate-Decision: PASS
'
expect_m00 "leftover [X]/mo placeholder" FAIL "$WL_PLACEHOLDER"

# 3 verified interviews is the floor; 2 verified must not pass.
expect_m00_interviews() {
    local name="$1" want="$2" verified="$3"
    local dir="$WORK/m00i"
    rm -rf "$dir"; mkdir -p "$dir/docs/pm"
    printf '%b' '- **Scale**: Medium\n- Delivery: solo\n' > "$dir/docs/pm/PROJECT_STATE.md"
    {
        printf '# M00-Lite: Rapid Market Validation\n\n'
        printf '## 2. Riskiest Assumption Register (RAT)\n\n'
        printf '| **ASM-01** | Users lose money | HIGH | 3/5 | Interviews | <2 | ✅ |\n\n'
        printf '## 3. Quick Competitor & Alternative Check\n\n| Competitor | Direct | Rp 200k | Brand | Offline | Ours |\n\n'
        printf '## 4. Qualitative User Discovery (5 User Interviews)\n\n'
        printf '| Respondent ID | Role | Current Solution | Friction | Willingness to Pay | Evidence Status |\n'
        printf '|:---|:---|:---|:---|:---|:---:|\n'
        printf '| **INT-01** | Grocery | paper | loss | Rp 50k | ✅ Real |\n'
        printf '| **INT-02** | Pet shop | Excel | corrupt | Rp 100k | ✅ Real |\n'
        printf '| **INT-03** | Boutique | POS X | slow | Rp 150k | %s |\n'
        if [ "$verified" = "3" ]; then printf '| **INT-04** | Warung | paper | loss | Rp 50k | ✅ Real |\n'; else printf '| **INT-04** | Warung | paper | loss | Rp 50k | ⏳ Pending |\n'; fi
        printf '\n## 5. Behavioral Intent Validation (Waitlist / Smoke Test)\n\n'
        printf -- '- **Total Unique Visitors**: 140\n- **Total Waitlist / Email Signups**: 9\n- **Waitlist-Conversion-Pct**: 6.4\n'
        printf '\nValidated-by: S. Rahma on 2026-10-12\n\nGate-Decision: PASS\n'
    } > "$dir/docs/pm/M00_LITE.md"
    local out got
    out="$(cd "$dir" && bash "$GATE" M00 2>&1 || true)"
    if echo "$out" | grep -q "Insufficient real interviews"; then got="BLOCKED"; else got="ALLOWED"; fi
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M00 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M00 -> $got, expected $want)"
        FAIL=$((FAIL + 1))
    fi
}

expect_m00_interviews "2 of 5 interviews verified (below floor)" BLOCKED 2
expect_m00_interviews "3 of 5 interviews verified (at floor)" ALLOWED 3

echo ""
echo "M01: the declared Scale must never override the classifier, and the brief's"
echo "decision must reconcile against its own numbers in BOTH directions."
echo "Regressions: the solo-capacity classifier sat inside the non-Small branch, so"
echo "declaring 'Scale: small' skipped the High-Water-Mark check entirely (20 P0"
echo "features + sensitive data passed); a crashing classifier (exit != 2) printed"
echo "'Solo capacity verified'; a leftover IDEA_BRIEF.md stub shadowed a filled"
echo "FEASIBILITY_REPORT.md; 'CONDITIONAL_GO' spelled with an underscore was not"
echo "recognised (only 'CONDITIONAL GO'); PROVISIONAL_PENDING_M00 was reported as"
echo "'decision not declared'; and average >= 3.5 with a GO/ CONDITIONAL_GO verdict"
echo "was never cross-checked."
echo ""

# expect_m01 <name> <EXPECTED> <state-content|EMPTY> <brief-content|EMPTY>
# EXPECTED in PASS|FAIL|PROVISIONAL. Exit 0 = PASS, 1 = FAIL, 3 = RETEST, 4 = PROVISIONAL.
expect_m01() {
    local name="$1" want="$2" state="$3" brief="$4"
    local dir="$WORK/m01"
    rm -rf "$dir"; mkdir -p "$dir/docs/pm"
    [ "$state" = "EMPTY" ] || printf '%b' "$state" > "$dir/docs/pm/PROJECT_STATE.md"
    [ "$brief" = "EMPTY" ] || printf '%b' "$brief" > "$dir/docs/pm/IDEA_BRIEF.md"
    local out code got
    out="$(cd "$dir" && bash "$GATE" M01 2>&1)"; code=$?
    case "$code" in
        0) got="PASS" ;;
        3) got="RETEST" ;;
        4) got="PROVISIONAL" ;;
        *) got="FAIL" ;;
    esac
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M01 -> $got, exit $code)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M01 -> $got, expected $want)"
        echo "$out" | grep -E '❌|⚠️' | head -3 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}

M01_OK='# Brief\n\nFeasibility-Score-Technical: 4.0\nFeasibility-Score-Operational: 4.0\nFeasibility-Score-Regulatory: 4.0\nFeasibility-Score-Financial: 4.0\nFeasibility-Decision: GO\n'
# Declared Small, but the structured fields say 20 P0 features + sensitive data.
STATE_LIES_SMALL='- **Scale**: small\n- Delivery: solo\n- Intake-Success-Metric: m\n- Intake-P0-Features: 20 (a..t)\n- Intake-Time-Capacity: 5 hrs/week x 2 weeks\n- Intake-Sensitive-Data: yes\n- Intake-Integrations: none\n- Intake-Branch-Hierarchy: no\n- Intake-Compliance: none\n- Intake-Legacy-Core: no\n- Intake-Status: ANSWERED\n'
expect_m01 "Self-declared Small, 20 P0 + sensitive data (classifier wins)" FAIL "$STATE_LIES_SMALL" "$M01_OK"

# No PROJECT_STATE.md at all: the intake gate must fail for EVERY scale.
expect_m01 "Medium intent, no PROJECT_STATE.md" FAIL "EMPTY" "$M01_OK"

# PROVISIONAL is a legitimate halt state, not an undeclared decision.
M01_PROV='# Brief\n\nFeasibility-Score-Technical: 4.0\nFeasibility-Score-Operational: 4.0\nFeasibility-Score-Regulatory: 4.0\nFeasibility-Score-Financial: 4.0\nFeasibility-Decision: PROVISIONAL_PENDING_M00\n'
expect_m01 "PROVISIONAL_PENDING_M00 (no final GO)" PROVISIONAL "$INTAKE_MEDIUM" "$M01_PROV"

# Fail-closed: average < 3.5 may not be declared GO.
M01_LOW='# Brief\n\nFeasibility-Score-Technical: 3.5\nFeasibility-Score-Operational: 3.5\nFeasibility-Score-Regulatory: 3.0\nFeasibility-Score-Financial: 3.0\nFeasibility-Decision: GO\n'
expect_m01 "average 3.25 declared GO (talked up)" FAIL "$INTAKE_MEDIUM" "$M01_LOW"

# CONDITIONAL_GO must carry its mitigation plan, in either spelling.
M01_COND_NOMIT='# Brief\n\nFeasibility-Score-Technical: 4.0\nFeasibility-Score-Operational: 4.0\nFeasibility-Score-Regulatory: 4.0\nFeasibility-Score-Financial: 4.0\nFeasibility-Decision: CONDITIONAL_GO\n'
expect_m01 "CONDITIONAL_GO without a Mitigation line" FAIL "$INTAKE_MEDIUM" "$M01_COND_NOMIT"
M01_COND_MIT='# Brief\n\nFeasibility-Score-Technical: 4.0\nFeasibility-Score-Operational: 4.0\nFeasibility-Score-Regulatory: 4.0\nFeasibility-Score-Financial: 4.0\nFeasibility-Decision: CONDITIONAL_GO\n\nMitigation: defer offline sync to Phase 2\n'
expect_m01 "CONDITIONAL_GO with a Mitigation line" PASS "$INTAKE_MEDIUM" "$M01_COND_MIT"

# Checkbox form: the scorecard declares the decision by ticking a row.
M01_CHECKBOX='# Brief\n\n- [ ] **GO**\n- [x] **CONDITIONAL_GO**\n- [ ] **PIVOT**\n- [ ] **KILL**\n\nFeasibility-Score-Technical: 4.0\nFeasibility-Score-Operational: 4.0\nFeasibility-Score-Regulatory: 4.0\nFeasibility-Score-Financial: 4.0\n\nMitigation: ship online-first MVP\n'
expect_m01 "checkbox form: [x] **CONDITIONAL_GO**" PASS "$INTAKE_MEDIUM" "$M01_CHECKBOX"
M01_UNTICKED='# Brief\n\n- [ ] **GO**\n- [ ] **CONDITIONAL_GO**\n- [x] **KILL**\n\nFeasibility-Score-Technical: 4.0\nFeasibility-Score-Operational: 4.0\nFeasibility-Score-Regulatory: 4.0\nFeasibility-Score-Financial: 4.0\n'
expect_m01 "checkbox form: [x] **KILL**" FAIL "$INTAKE_MEDIUM" "$M01_UNTICKED"

# A leftover stub must not shadow the filled alias report.
expect_m01_alias() {
    local name="$1" want="$2"
    local dir="$WORK/m01a"
    rm -rf "$dir"; mkdir -p "$dir/docs/pm"
    printf '%b' "$INTAKE_MEDIUM" > "$dir/docs/pm/PROJECT_STATE.md"
    printf 'Feasibility-Score-Technical: 1.0\nstub stub stub\n' > "$dir/docs/pm/IDEA_BRIEF.md"
    printf '%b' "$M01_OK" > "$dir/docs/pm/FEASIBILITY_REPORT.md"
    local out code got
    out="$(cd "$dir" && bash "$GATE" M01 2>&1)"; code=$?
    [ "$code" -eq 0 ] && got="PASS" || got="FAIL"
    if [ "$got" = "$want" ] && echo "$out" | grep -q "Both briefs present"; then
        echo -e "  ${GREEN}✓${NC} $name  (M01 -> $got, alias preferred)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M01 -> $got, expected $want + alias notice)"
        echo "$out" | grep -E '❌|\[INFO\]' | head -3 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
expect_m01_alias "stub IDEA_BRIEF.md + filled FEASIBILITY_REPORT.md" PASS

# Intake escalation fields: absent is not "none".
INTAKE_NO_ESCALATION='- **Scale**: Small\n- Delivery: solo\n- Intake-Success-Metric: 10 users can create a task\n- Intake-P0-Features: 3 (create, list, complete)\n- Intake-Time-Capacity: 10 hrs/week x 3 weeks = 30 hrs\n- Intake-Sensitive-Data: no\n- Intake-Status: ANSWERED\n'
expect_intake "Small + ANSWERED but escalation fields absent" BLOCKED "$INTAKE_NO_ESCALATION" M01

# A payment webhook declared in the escalation field must escalate the tier:
# it puts the project at Medium, which the 'small' declared P0 count cannot satisfy.
STATE_WEBHOOK='- **Scale**: small\n- Delivery: client\n- Intake-Success-Metric: m\n- Intake-P0-Features: 4 (a,b,c,d)\n- Intake-Time-Capacity: 10 hrs/week x 4 weeks\n- Intake-Sensitive-Data: no\n- Intake-Integrations: Midtrans payment webhook\n- Intake-Branch-Hierarchy: no\n- Intake-Compliance: none\n- Intake-Legacy-Core: no\n- Intake-Status: ANSWERED\n'
expect_m01 "Small + Midtrans webhook integration (escalates to Medium)" FAIL "$STATE_WEBHOOK" "$M01_OK"

# The eval scenario expects a NOT-YET-RUN research state to be PENDING, not PASS.
WL_PENDING='- **Total Unique Visitors**: 0
- **Total Waitlist / Email Signups**: 0
- **Waitlist-Conversion-Pct**: 0

Gate-Decision: PENDING
'
expect_m00 "research not yet run (PENDING)" FAIL "$WL_PENDING"

echo ""
echo "Solo Capacity Gate: the classifier has TWO predicates. A capacity risk (16-25 P0,"
echo "no non-delegable obligation) may be accepted in writing by a named human; a"
echo "non-delegable obligation (statutory compliance / legacy-core) never may."
echo "Regression: the gate blocked both cases with one opaque exit 2 that no"
echo "regression test covered, so the rule silently drifted from every other module."
echo ""

# expect_capacity <name> <want-exit> <state-fields> <acceptance-content|EMPTY>
expect_capacity() {
    local name="$1" want="$2" fields="$3" acc="$4"
    local dir="$WORK/cap"
    make_project "$dir" "$fields"
    if [ "$acc" != "EMPTY" ]; then
        printf '%b' "$acc" > "$dir/docs/pm/SOLO-CAPACITY-RISK-ACCEPTANCE.md"
    fi
    local code got
    ( cd "$dir" && bash "$SCRIPT_DIR/../gates/classify-scale.sh" >/dev/null 2>&1 ); code=$?
    case "$code" in
        0) got="SOLO_VIABLE" ;;
        2) got="BLOCKED" ;;
        5) got="OVERRIDDEN" ;;
        *) got="UNEXPECTED_$code" ;;
    esac
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (classifier -> $got, exit $code)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (classifier -> $got/exit $code, expected $want)"
        FAIL=$((FAIL + 1))
    fi
}

# The Medium band is 6-15 in SKILL.md, M01, M02 and SCOPE_STATEMENT. The classifier
# once used `-ge 8`, making the documented 6-7 band unreachable: a 6-P0 project was
# classified small while every document called it Medium. These three pin both edges.
# expect_scale_band <name> <p0-count> <want-scale-token>
expect_scale_band() {
    local name="$1" n="$2" want="$3"
    local dir="$WORK/band"
    make_project "$dir" "- **Scale**: small\n- Delivery: solo\n"
    {
        printf '# Scope\n\n| ID | Feature | Priority |\n| :--- | :--- | :--- |\n'
        local i=1
        while [ "$i" -le "$n" ]; do
            printf '| **F-%03d** | feature %d | Must |\n' "$i" "$i"
            i=$((i + 1))
        done
    } > "$dir/docs/pm/SCOPE_STATEMENT.md"
    local out got
    out="$(cd "$dir" && bash "$SCRIPT_DIR/../gates/classify-scale.sh" docs/pm/SCOPE_STATEMENT.md 2>&1 || true)"
    got=$(printf '%s' "$out" | sed -n 's/^Evaluated Scale[[:space:]]*:[[:space:]]*\([a-z]*\).*/\1/p' | head -1)
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (${n} P0 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (${n} P0 -> ${got:-<none>}, expected $want)"
        FAIL=$((FAIL + 1))
    fi
}
expect_scale_band "Scale band: 5 P0 stays small" 5 "small"
expect_scale_band "Scale band: 6 P0 is medium (lower edge)" 6 "medium"
expect_scale_band "Scale band: 15 P0 is medium (upper edge)" 15 "medium"
expect_scale_band "Scale band: 16 P0 is large" 16 "large"

# M12 at Large requires docs/pm/INCIDENT_RESPONSE.md, and no scaffold branch produced
# it — a correctly scaffolded Large project failed the gate. Both scaffolds now copy
# 08-maintenance-ops/INCIDENT_RESPONSE_TEMPLATE.md there; this pins the requirement.
# expect_m12_incident <name> <scale> <create-incident:yes|no> <want>
expect_m12_incident() {
    local name="$1" scale="$2" create="$3" want="$4"
    local dir="$WORK/m12inc"
    make_project "$dir" "- **Scale**: $scale\n- Delivery: client\n"
    printf '# Warranty\n\n## Coverage\n\n## Exclusions\n\n## Service Level Agreement\n' > "$dir/docs/pm/WARRANTY_POLICY.md"
    [ "$create" = "yes" ] && printf '# Incident Response\n\n## Severity\n\n## Comms\n' > "$dir/docs/pm/INCIDENT_RESPONSE.md"
    local out rc got
    out="$(cd "$dir" && bash "$GATE" M12 2>&1)"; rc=$?
    got="ALLOWED"; [ "$rc" -ne 0 ] && got="BLOCKED"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M12 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M12 -> $got, expected $want)"
        echo "$out" | grep -E "INCIDENT_RESPONSE" | head -2 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
expect_m12_incident "M12 Large without INCIDENT_RESPONSE.md" large no BLOCKED
expect_m12_incident "M12 Large with INCIDENT_RESPONSE.md" large yes ALLOWED

# 20 P0 with nothing non-delegable -> capacity risk, overridable (Large tier).
CAP_LARGE='- **Scale**: large\n- Delivery: solo\n- Intake-Success-Metric: 500 orders/day\n- Intake-P0-Features: 20 (a..t)\n- Intake-Time-Capacity: 40 hrs/week x 20 weeks\n- Intake-Sensitive-Data: no\n- Intake-Integrations: none\n- Intake-Branch-Hierarchy: no\n- Intake-Compliance: none\n- Intake-Legacy-Core: no\n- Intake-Status: ANSWERED\n'
CAP_ACCEPTED='- Accepted-By: S. Rahma\n- Accepted-On: 2026-10-12\n- Scope-Version: v1\n'
CAP_PLACEHOLDER='- Accepted-By: [real human name]\n- Accepted-On: [YYYY-MM-DD]\n'
# Same size, but a non-delegable statutory obligation.
CAP_COMPLIANCE='- **Scale**: large\n- Delivery: client\n- Intake-Success-Metric: 500 loans/day\n- Intake-P0-Features: 20 (a..t)\n- Intake-Time-Capacity: 40 hrs/week x 20 weeks\n- Intake-Sensitive-Data: yes\n- Intake-Integrations: none\n- Intake-Branch-Hierarchy: no\n- Intake-Compliance: OJK\n- Intake-Legacy-Core: no\n- Intake-Status: ANSWERED\n'
# Same size, but a legacy-core replacement.
CAP_LEGACY='- **Scale**: large\n- Delivery: client\n- Intake-Success-Metric: ledger migration\n- Intake-P0-Features: 20 (a..t)\n- Intake-Time-Capacity: 40 hrs/week x 20 weeks\n- Intake-Sensitive-Data: no\n- Intake-Integrations: none\n- Intake-Branch-Hierarchy: no\n- Intake-Compliance: none\n- Intake-Legacy-Core: yes\n- Intake-Status: ANSWERED\n'

expect_capacity "Large capacity-only, no acceptance file" BLOCKED "$CAP_LARGE" "EMPTY"
expect_capacity "Large capacity-only, placeholder acceptance" BLOCKED "$CAP_LARGE" "$CAP_PLACEHOLDER"
expect_capacity "Large capacity-only, named+dated acceptance" OVERRIDDEN "$CAP_LARGE" "$CAP_ACCEPTED"
# The non-delegable block must hold EVEN WITH a complete acceptance file.
expect_capacity "OJK compliance + valid acceptance (non-delegable)" BLOCKED "$CAP_COMPLIANCE" "$CAP_ACCEPTED"
expect_capacity "Legacy-core + valid acceptance (non-delegable)" BLOCKED "$CAP_LEGACY" "$CAP_ACCEPTED"
expect_capacity "Medium scope stays solo-viable (no override needed)" SOLO_VIABLE "$INTAKE_MEDIUM" "EMPTY"

echo ""
echo "M06 STEP 0 / STEP 2: the runbook's hard claims must be enforced, not prose."
echo "Regressions: the FSD lock + handoff section were checked only by deep-dive"
echo ""

# expect_m06_step <name> <BLOCKED|ALLOWED> <fsd-content|EMPTY> <harness-complete: yes|no>
expect_m06_step() {
    local name="$1" want="$2" fsd="$3" full="$4"
    local dir="$WORK/m06s"
    make_project "$dir" "$INTAKE_MEDIUM"
    # A complete TODO so ONLY the STEP 0 / STEP 2 lines can decide the outcome.
    printf -- '- [x] **M06-SETUP-03: Specs Pre-Read**\n  - **Evidence**: read\n- [x] **M06-DB-01: Schema**\n  - **Evidence**: ok\n- [x] **M06-BE-01: API**\n  - **Evidence**: ok\n- [x] **M06-FE-01: Screens**\n  - **Evidence**: ok\n' > "$dir/TODO.md"
    printf 'anti-slop typescript strict verification standards\n' > "$dir/AGENTS.md"
    mkdir -p "$dir/docs/specs"
    [ "$fsd" = "EMPTY" ] || printf '%b' "$fsd" > "$dir/docs/specs/FSD.md"
    if [ "$full" = "yes" ]; then
        for f in CONTEXT ARCHITECTURE DESIGN CONVENTIONS; do printf 'x\n' > "$dir/$f.md"; done
        printf 'x\n' > "$dir/.env.example"
        printf 'x\n' > "$dir/RUNBOOK_LOCAL.md"
        printf 'x\n' > "$dir/VERIFY_LOCAL.md"
    fi
    local out
    out="$(cd "$dir" && bash "$GATE" M06 2>&1 || true)"
    local got="ALLOWED"
    if echo "$out" | grep -qE "STEP 0: .*no 'Stack Decision LOCKED|STEP 0: FSD.md missing the 'Module 04 Handoff|STEP 2: harness file\(s\) missing"; then
        got="BLOCKED"
    fi
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M06 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M06 -> $got, expected $want)"
        echo "$out" | grep -E '❌ STEP' | head -3 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}

FSD_OK_LOCK='Stack Decision LOCKED: Next.js 15\n\n## Module 04 Handoff Strategy\nCompatibility Level: 2\n'
FSD_NO_LOCK='## 2. Component Architecture\n\nORM / Driver: Drizzle\n'
FSD_NO_HANDOFF='Stack Decision LOCKED: Next.js 15\n\n## 3. Database Schema\n'

expect_m06_step "FSD with no locked stack" BLOCKED "$FSD_NO_LOCK" yes
expect_m06_step "FSD with no Module 04 Handoff Strategy" BLOCKED "$FSD_NO_HANDOFF" yes
expect_m06_step "FSD locked + handoff, only 3 of 9 harness files" BLOCKED "$FSD_OK_LOCK" no
expect_m06_step "FSD locked + handoff, all 9 harness files" ALLOWED "$FSD_OK_LOCK" yes

# Producer side: M05 must require the handoff section so M06 STEP 0 can read it.
expect_m05_handoff() {
    local name="$1" want="$2" with_handoff="$3"
    local dir="$WORK/m05h"
    make_project "$dir" "$INTAKE_MEDIUM"
    mkdir -p "$dir/docs/specs"
    printf '### Stack Decision\nStack Decision LOCKED: Next.js\n\n- Q1 x\n- Q2 x\n- Q3 x\n- Q4 x\n- Q5 x\n- Q6 x\n- Q7 x\n- Q8 x\n' > "$dir/docs/specs/FSD.md"
    [ "$with_handoff" = "yes" ] && printf '\n## Module 04 Handoff Strategy\nCompatibility Level: 3\n' >> "$dir/docs/specs/FSD.md"
    local out
    out="$(cd "$dir" && bash "$GATE" M05 2>&1 || true)"
    local got="ALLOWED"
    if echo "$out" | grep -qE "missing the 'Module 04 Handoff Strategy'"; then
        got="BLOCKED"
    fi
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M05 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M05 -> $got, expected $want)"
        FAIL=$((FAIL + 1))
    fi
}
expect_m05_handoff "M05 FSD without handoff section" BLOCKED no
expect_m05_handoff "M05 FSD with handoff section" ALLOWED yes

echo ""
echo "M06 STEP 3: a template-faithful FSD must PASS its own version gate."
echo "Regression: the version parser anchored on '^- <pkg>:' while the shipped"
echo "FSD template writes '- **Framework**: Next.js ^15.0.3', so every project that"
echo "followed the template failed STEP 3 with 'FSD missing Next.js: X.Y.Z'."
echo ""

VERSION_SH="$REPO/scripts/verify/verify-framework-version.sh"

# expect_version <name> <EXPECTED: PASS|FAIL> <fsd-version-line> <resolved> <conflicting-manifest>
expect_version() {
    local name="$1" want="$2" fsdline="$3" resolved="$4" extra="$5"
    local dir="$WORK/vt"
    rm -rf "$dir"; mkdir -p "$dir/docs/specs" "$dir/bin"
    printf '### Stack Decision (LOCKED)\nStack Decision LOCKED: Next.js 15\n\n### Framework Versions (Pinned)\n%b\n\n## 3. Database Schema\n' "$fsdline" > "$dir/docs/specs/FSD.md"
    printf '{"dependencies":{"next":"^15.0.3"}}\n' > "$dir/package.json"
    printf '{"packages":{"node_modules/next":{"version":"%s"}}}\n' "$resolved" > "$dir/package-lock.json"
    [ -n "$extra" ] && printf '{}\n' > "$dir/$extra"
    # Deterministic node shim: the gate only reads the lockfile through it.
    cat > "$dir/bin/node" <<EOF
#!/usr/bin/env bash
case "\$*" in
  *node_modules/next*) echo "$resolved" ;;
  *node_modules/react*) echo "" ;;
  *) exit 1 ;;
esac
EOF
    chmod +x "$dir/bin/node"
    local out code
    out="$(cd "$dir" && PATH="$dir/bin:$PATH" bash "$VERSION_SH" 2>&1)"; code=$?
    local got="FAIL"; [ "$code" -eq 0 ] && got="PASS"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (version gate -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (version gate -> $got, expected $want)"
        echo "$out" | tail -4 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}

expect_version "template form ('- **Framework**: Next.js ^15.0.3') matches 15.0.3" PASS \
    '- **Framework**: Next.js ^15.0.3 (App Router)' "15.0.3" ""
expect_version "bare form ('- Next.js: 15.0.3') matches 15.0.3" PASS \
    '- Next.js: 15.0.3' "15.0.3" ""
expect_version "template form vs resolved 16.1.0 (drift)" FAIL \
    '- **Framework**: Next.js ^15.0.3 (App Router)' "16.1.0" ""
expect_version "FSD Next.js but composer.json present (wrong scaffold)" FAIL \
    '- **Framework**: Next.js ^15.0.3 (App Router)' "15.0.3" "composer.json"

echo ""
echo "Path portability: every script must work from ANY cwd and on ANY device."
echo "Regression: verify-all.sh and index-manifest.js resolved paths against the"
echo "caller's cwd, so invoking them by absolute path from another directory"
echo "reported the whole repo as missing. No absolute device paths are allowed."
echo ""

OUTSIDE="$(mktemp -d)"

# Guard against infinite recursion: verify-all.sh calls this suite (section 7),
# so re-running verify-all from here would re-enter this file forever.
# The env var breaks the cycle; verify-all still runs every other check.
if (cd "$OUTSIDE" && GATE_REGRESSIONS_RUNNING=1 bash "$REPO/scripts/verify/verify-all.sh" >/dev/null 2>&1); then
    echo -e "  ${GREEN}✓${NC} verify-all.sh works when invoked from an unrelated cwd"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}✗${NC} verify-all.sh fails when invoked from an unrelated cwd"
    FAIL=$((FAIL + 1))
fi

if command -v node >/dev/null 2>&1; then
    if (cd "$OUTSIDE" && node "$REPO/scripts/verify/index-manifest.js" --check >/dev/null 2>&1); then
        echo -e "  ${GREEN}✓${NC} index-manifest.js works when invoked from an unrelated cwd"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} index-manifest.js fails when invoked from an unrelated cwd"
        FAIL=$((FAIL + 1))
    fi
fi

rm -rf "$OUTSIDE"

DEVICE_PAT='(\b[A-Za-z]:[\\/](?![\\/])[A-Za-z0-9_.-]+|/Users/[a-z0-9_.-]+|/home/[a-z0-9_.-]+|/mnt/[a-z]/|AppData[\\/])'
# verify-no-absolute-paths.js legitimately contains the patterns it searches for;
# exempt it by name rather than forcing that file to obfuscate its own regexes.
DEVICE_HITS="$(grep -rlE "$DEVICE_PAT" --include='*.sh' --include='*.ps1' --include='*.js' --include='*.ts' --include='*.yml' "$REPO/scripts" "$REPO/.github" 2>/dev/null | grep -v 'verify-no-absolute-paths' | head -5 || true)"
if [ -z "$DEVICE_HITS" ]; then
    echo -e "  ${GREEN}✓${NC} no hardcoded device paths in scripts / CI"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}✗${NC} hardcoded device path(s) found:"
    echo "$DEVICE_HITS" | sed 's/^/       /'
    FAIL=$((FAIL + 1))
fi

# Captured gate output must stay device-independent: the golden file is committed and
# compared on other machines, so an absolute path from the author's disk would fail
# everywhere else. Regression: it once captured
# "/c/Users/<author>/.../validate-gate.sh" in the usage line.
GOLDEN_FILE="$REPO/scripts/verify/golden-gate-output.txt"
if [ ! -f "$GOLDEN_FILE" ]; then
    echo -e "  ${RED}✗${NC} golden gate output file is missing ($GOLDEN_FILE)"
    FAIL=$((FAIL + 1))
else
    # Look for author-machine paths, not for the literal <REPO> placeholder.
    if grep -qE '(/[A-Za-z]/Users/|/Users/[a-z0-9_.-]+/|/home/[a-z0-9_.-]+/|[A-Za-z]:[\\/]Users)' "$GOLDEN_FILE" 2>/dev/null; then
        echo -e "  ${RED}✗${NC} golden output contains an absolute device path:"
        grep -nE '(/[A-Za-z]/Users/|/Users/[a-z0-9_.-]+/|/home/[a-z0-9_.-]+/|[A-Za-z]:[\\/]Users)' "$GOLDEN_FILE" | head -3 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    else
        echo -e "  ${GREEN}✓${NC} golden gate outputs are device-independent (no absolute author paths)"
        PASS=$((PASS + 1))
    fi
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
    echo -e "${GREEN}All $PASS gate regression tests passed.${NC}"
    exit 0
fi
echo -e "${RED}$FAIL of $((PASS + FAIL)) gate regression tests FAILED.${NC}"
exit 1
