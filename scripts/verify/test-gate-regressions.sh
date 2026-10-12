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
    if echo "$out" | grep -qE "Intake field incomplete|Intake-Status not set|Intake Gate:.*missing"; then
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

INTAKE_UNKNOWN='- **Scale**: Small\n- Delivery: UNKNOWN\n- Intake-Success-Metric: UNKNOWN\n- Intake-P0-Features: UNKNOWN\n- Intake-Time-Capacity: UNKNOWN\n- Intake-Sensitive-Data: UNKNOWN\n- Intake-Status: UNKNOWN\n'
INTAKE_ANSWERED='- **Scale**: Small\n- Delivery: solo\n- Intake-Success-Metric: 10 users can create a task\n- Intake-P0-Features: 3 (create, list, complete)\n- Intake-Time-Capacity: 10 hrs/week x 3 weeks = 30 hrs\n- Intake-Sensitive-Data: no\n- Intake-Status: ANSWERED\n'
INTAKE_MEDIUM='- **Scale**: Medium\n- Delivery: client\n- Intake-Success-Metric: 200 orders/day processed\n- Intake-P0-Features: 12 (catalog, orders, payments, admin)\n- Intake-Time-Capacity: 40 hrs/week x 12 weeks = 480 hrs\n- Intake-Sensitive-Data: no\n- Intake-Status: ANSWERED\n'

echo -e "${BLUE}=== Gate Regression Tests ===${NC}"
echo ""
echo "Intake gate must block EVERY reachable module for Small projects."
echo "Regression: the check was once nested inside the scale-waiver branch,"
echo "so Small silently bypassed all 5 mandatory intake questions."
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
TASKS_APPROVED='- [x] **M06-DB-01: Schema**\n  - **Evidence**: exit 0 | Approved: 2026-10-12 by zen\n- [x] **M06-BE-01: API**\n  - **Evidence**: pass | Approved: 2026-10-12 by zen\n- [x] **M06-FE-01: Screens**\n  - **Evidence**: pass | Approved: 2026-10-12 by zen\n'
TASKS_PARTIAL='- [x] **M06-DB-01: Schema**\n  - **Evidence**: exit 0 | Approved: 2026-10-12 by zen\n- [x] **M06-BE-01: API**\n  - **Evidence**: tests pass\n- [x] **M06-FE-01: Screens**\n  - **Evidence**: pass | Approved: 2026-10-12 by zen\n'

expect_approval "3 tasks [x], zero approvals (agent ran the sprint)" BLOCKED "$TASKS_SELF"
expect_approval "3 tasks [x], all approved by human" ALLOWED "$TASKS_APPROVED"
expect_approval "partial: one task self-approved" BLOCKED "$TASKS_PARTIAL"

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
FREEZE_SIGNED='# DESIGN_SPEC\n\n## Design Freeze\n\n- Approved by: Zen (founder)\n- Approved on: 2026-10-12\n'
expect_human_input "M04 freeze left as a blank template" BLOCKED M04 "docs/specs/DESIGN_SPEC.md" "$FREEZE_BLANK"
expect_human_input "M04 freeze signed by a human" ALLOWED M04 "docs/specs/DESIGN_SPEC.md" "$FREEZE_SIGNED"

# B. Stack questionnaire (M05) — the marker alone must not pass.
printf '%b' '# PROJECT_LITE\n\nCREATE TABLE users (id uuid);\nGET /api/users\nPOST /api/users\n- **Feature**: login\n\nStack Decision LOCKED: Next.js\n' > "$WORK/pl_noq.md"
printf '%b' '# PROJECT_LITE\n\nCREATE TABLE users (id uuid);\nGET /api/users\nPOST /api/users\n- **Feature**: login\n\nStack Decision LOCKED: Next.js\nStack-Locked-by: Zen\n\n- Q1 Team Expertise: x\n- Q2 Database Experience: x\n- Q3 Deployment Topology: x\n- Q4 Expected Scale (Year 1): x\n- Q5 Data Model Characteristics: x\n- Q6 DevOps Complexity Tolerance: x\n- Q7 Critical Feature Priority: x\n- Q8 Compliance Requirements: x\n' > "$WORK/pl_8q.md"

run_lock() {
    local name="$1" want="$2" src="$3"
    local dir="$WORK/plk"
    make_project "$dir" "$INTAKE_ANSWERED"
    cp "$src" "$dir/PROJECT_LITE.md"
    local out
    out="$(cd "$dir" && bash "$GATE" M05 2>&1 || true)"
    local got="ALLOWED"
    if echo "$out" | grep -qE "records only [0-9]+/8 questionnaire"; then
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

# C. Client input receipt (M08). Medium scale: M08 is WAIVED for Small, so a Small
# fixture would pass vacuously and the guard would go untested.
expect_client_input() {
    local name="$1" want="$2" content="$3"
    local dir="$WORK/pci"
    make_project "$dir" "$INTAKE_MEDIUM"
    printf '%b' "$content" > "$dir/docs/pm/DATA_MIGRATION_PLAN.md"
    local out
    out="$(cd "$dir" && bash "$GATE" M08 2>&1 || true)"
    local got="ALLOWED"
    if echo "$out" | grep -qE "no record that the client-supplied"; then
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
        printf -- '- **Validation Lead**: Zen\n- **Date**: 2026-10-12\n\n'
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
        echo "$out" | grep -E '❌|⚠️' | head -3 | sed 's/^/       /'
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

Validated-by: Zen on 2026-10-12

Gate-Decision: PASS
'
expect_m00 "template-style bold fields at 6.4% + 140 visits" PASS "$WL_TEMPLATE"

# Regression: the exact bug — a template-faithful document used to FAIL while a
# de-formatted one PASSED. Both must now be equal.
WL_BARE='Total Unique Visitors: 140
Total Waitlist / Email Signups: 9
Waitlist-Conversion-Pct: 6.4

Validated-by: Zen on 2026-10-12

Gate-Decision: PASS
'
expect_m00 "same evidence, formatting stripped (parity with bold)" PASS "$WL_BARE"

# Sample floor: a rate is not evidence below 100 targeted visits.
WL_SMALL='- **Total Unique Visitors**: 1
- **Total Waitlist / Email Signups**: 1
- **Waitlist-Conversion-Pct**: 100

Validated-by: Zen on 2026-10-12

Gate-Decision: PASS
'
expect_m00 "1 visitor / 1 signup = 100% (below visit floor)" FAIL "$WL_SMALL"

# RETEST band must be representable and must NOT pass.
WL_RETEST='- **Total Unique Visitors**: 140
- **Total Waitlist / Email Signups**: 5
- **Waitlist-Conversion-Pct**: 3.6

Validated-by: Zen on 2026-10-12

Gate-Decision: RETEST
'
expect_m00 "3.6% waitlist declared RETEST" RETEST "$WL_RETEST"

# Inflating the decision on a RETEST-band number is the core anti-gaming check.
WL_INFLATED='- **Total Unique Visitors**: 140
- **Total Waitlist / Email Signups**: 5
- **Waitlist-Conversion-Pct**: 3.6

Validated-by: Zen on 2026-10-12

Gate-Decision: PASS
'
expect_m00 "3.6% but declared PASS (talked up)" FAIL "$WL_INFLATED"

# KILL band.
WL_KILL='- **Total Unique Visitors**: 200
- **Total Waitlist / Email Signups**: 2
- **Waitlist-Conversion-Pct**: 1.0

Validated-by: Zen on 2026-10-12

Gate-Decision: FAIL
'
expect_m00 "1.0% waitlist declared FAIL" FAIL "$WL_KILL"

# Arithmetic the gate can check: signups cannot exceed visitors.
WL_IMPOSSIBLE='- **Total Unique Visitors**: 120
- **Total Waitlist / Email Signups**: 200
- **Waitlist-Conversion-Pct**: 6.0

Validated-by: Zen on 2026-10-12

Gate-Decision: PASS
'
expect_m00 "signups exceed visitors (impossible)" FAIL "$WL_IMPOSSIBLE"

# Percent that contradicts signups/visitors.
WL_MISMATCH='- **Total Unique Visitors**: 1000
- **Total Waitlist / Email Signups**: 10
- **Waitlist-Conversion-Pct**: 6.0

Validated-by: Zen on 2026-10-12

Gate-Decision: PASS
'
expect_m00 "6.0% contradicts 10/1000 (=1.0%)" FAIL "$WL_MISMATCH"

# Secondary signal rescues the RETEST band.
WL_INTENT='- **Total Unique Visitors**: 140
- **Total Waitlist / Email Signups**: 5
- **Waitlist-Conversion-Pct**: 3.6
- **Intent-to-Buy-Pct**: 34

Validated-by: Zen on 2026-10-12

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

Validated-by: Zen on 2026-10-12

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
        printf '\nValidated-by: Zen on 2026-10-12\n\nGate-Decision: PASS\n'
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

# The eval scenario expects a NOT-YET-RUN research state to be PENDING, not PASS.
WL_PENDING='- **Total Unique Visitors**: 0
- **Total Waitlist / Email Signups**: 0
- **Waitlist-Conversion-Pct**: 0

Gate-Decision: PENDING
'
expect_m00 "research not yet run (PENDING)" FAIL "$WL_PENDING"

echo ""
echo "M03: the SHIPPED SOW template must be gate-ready once its blanks are filled."
echo "Regressions: the template's non-bank placeholder form ('[Account Number]')"
echo "tripped the unresolved-placeholder block even when the user filled the real"
echo "fields, the consolidated SOW titled its sections ('Project Charter',"
echo "'Compensation Value & Payment Milestone Schedule') so the heading matcher"
echo "reported false MISSING headings, and the DP confirmation the runbook records"
echo "was only accepted on the milestone line - so a contract filled exactly as the"
echo "templates instruct FAILED M03 with no way to close the gate."
echo ""

# expect_m03_template <name> <EXPECTED> <template-rel> <fill-cmd-run-in-project-dir>
expect_m03_template() {
    local name="$1" want="$2" tpl="$3" fill="$4"
    local dir="$WORK/m03"
    rm -rf "$dir"; mkdir -p "$dir/contracts" "$dir/docs/pm"
    printf '%b' '# PROJECT_STATE\n- **Scale**: Medium\n- Delivery: client\n' > "$dir/docs/pm/PROJECT_STATE.md"
    cp "$REPO/$tpl" "$dir/contracts/SOW_CONTRACT.md"
    cp "$REPO/templates/02-legal-commercial/NDA_TEMPLATE.md" "$dir/contracts/NDA.md"
    ( cd "$dir" && eval "$fill" )
    local out got
    out="$(cd "$dir" && bash "$GATE" M03 2>&1 || true)"
    if echo "$out" | grep -qE "Gate validation PASSED"; then got="PASS"; else got="FAIL"; fi
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M03 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M03 -> $got, expected $want)"
        echo "$out" | grep -E "❌" | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}

# Legitimate fill: the user replaces the bank account blanks and ticks the DP line
# (adding the receipt wording the template already carries on that same line).
M03_FILL_DP_DONE='sed -i "s/Account Number: \[Account Number\]/Account Number: 1234567890 (BCA)/" contracts/SOW_CONTRACT.md
sed -i "s/^- \[ \] DP (Milestone 1)/- [x] DP (Milestone 1)/" contracts/SOW_CONTRACT.md
sed -i "s/^- \[ \] SOW signed by both parties/- [x] SOW signed by both parties/" contracts/SOW_CONTRACT.md
sed -i "s/^- \[ \] NDA signed/- [x] NDA signed/" contracts/SOW_CONTRACT.md'

expect_m03_template "shipped consolidated SOW, blanks filled + DP ticked" PASS \
    "templates/01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md" "$M03_FILL_DP_DONE"

# Same template, real bank fields filled but the DP left PENDING: still blocked.
M03_FILL_DP_PENDING='sed -i "s/Account Number: \[Account Number\]/Account Number: 1234567890 (BCA)/" contracts/SOW_CONTRACT.md'
expect_m03_template "shipped consolidated SOW with DP still pending is blocked" FAIL \
    "templates/01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md" "$M03_FILL_DP_PENDING"

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
DEVICE_HITS="$(grep -rlE "$DEVICE_PAT" --include='*.sh' --include='*.ps1' --include='*.js' --include='*.ts' --include='*.yml' "$REPO/scripts" "$REPO/.github" 2>/dev/null | head -5 || true)"
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
