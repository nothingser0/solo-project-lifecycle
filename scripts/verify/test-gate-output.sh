#!/usr/bin/env bash
# test-gate-output.sh — byte-for-byte output parity for every gate.
#
# Why this exists: validate-gate.sh holds 19 gate branches in one 92KB file. It was
# split into modules, and this test is what proves the split changed nothing
# observable. It runs every gate against a FIXED fixture and compares stdout+stderr
# and the exit code against `scripts/verify/golden-gate-output.txt`.
#
# Captured cases: the 19 module gates against one fixed incomplete fixture, the two
# usage paths, and two dedicated M00-lite cases (PASS and the exit-3 RETEST verdict)
# because the main fixture is client work, where M00 is waived.
#
# Usage:
#   bash scripts/verify/test-gate-output.sh            # compare against golden
#   bash scripts/verify/test-gate-output.sh --update   # regenerate golden (only
#                                                      # after confirming the new
#                                                      # output is correct)
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
GATE="$ROOT_DIR/scripts/gates/validate-gate.sh"
# Single golden file: one captured run of every gate, split on the marker below.
# Kept as one file so the framework does not ship 40+ tiny fixtures; git diffs stay
# readable because each gate's block is contiguous and labelled.
GOLDEN_FILE="$SCRIPT_DIR/golden-gate-output.txt"
MARKER="##### GATE:"
END_MARKER="##### END GATE:"
UPDATE=0
[ "${1:-}" = "--update" ] && UPDATE=1

GREEN='\033[0;32m'; RED='\033[0;31m'; BLUE='\033[0;34m'; YELLOW='\033[0;33m'; NC='\033[0m'

GATES="M00 M01 M02 M03 M04 M05 M06 M07 M08 M09 M10 M11 M12 M13 A00 A01 A02 A03 A04"
PASS=0; FAIL=0

# Fixed, deliberately INCOMPLETE fixture: every gate has something to report, which
# makes the captured output far more discriminating than an all-green project.
mk_fixture() {
    local d="$1"
    rm -rf "$d"; mkdir -p "$d"
    mkdir -p "$d/docs/pm" "$d/docs/specs" "$d/docs/qa" "$d/docs/governance" \
             "$d/docs/design/inspiration" "$d/assets/logo" "$d/src" "$d/tests"

    cat > "$d/docs/pm/PROJECT_STATE.md" <<'EOF'
# PROJECT_STATE
- **Scale**: Medium
- Delivery: client
- Intake-Success-Metric: 200 orders/day processed end to end
- Intake-P0-Features: 12 (catalog, orders, payments, admin, reports)
- Intake-Time-Capacity: 40 hrs/week x 12 weeks = 480 hrs
- Intake-Sensitive-Data: yes
- Intake-Integrations: none
- Intake-Branch-Hierarchy: no
- Intake-Compliance: none
- Intake-Legacy-Core: no
- Intake-Status: ANSWERED
EOF
    printf '# PROJECT_LITE\n\nCREATE TABLE users (id uuid);\nGET /api/users\nPOST /api/users\n- **Feature**: login\n\nStack Decision LOCKED: Next.js\n' > "$d/PROJECT_LITE.md"
    printf '# AGENTS\n\n## Engineering Standards\nAnti-slop rules: no @ts-ignore, no as any, no empty catch, no secrets.\n%s\n' "$(head -c 600 /dev/zero | tr '\0' 'x')" > "$d/AGENTS.md"
    printf '# CONTEXT\n%s\n' "$(head -c 600 /dev/zero | tr '\0' 'y')" > "$d/CONTEXT.md"
    printf '# TODO\n\n- [x] **M06-DB-01: Schema**\n  - **Evidence**: migrations exit 0\n- [ ] **M06-BE-01: API**\n- [ ] **M06-FE-01: Screens**\n' > "$d/TODO.md"
    printf 'ICEBERG MODEL\n%s\n' "$(head -c 1200 /dev/zero | tr '\0' 'a')" > "$d/docs/pm/SCOPE_STATEMENT.md"
    printf 'DESIGN\nContrast 7.0:1\nz-index scale\nTypography\nSpacing\n%s\n' "$(head -c 1200 /dev/zero | tr '\0' 'b')" > "$d/DESIGN.md"
    printf 'Selected Benchmark: Linear\npalette #111111 #ffffff\n' > "$d/docs/design/inspiration/notes.md"
    printf 'SCR-003 SCR-004\n%s\n' "$(head -c 1100 /dev/zero | tr '\0' 'c')" > "$d/docs/specs/SITEMAP.md"
    printf '# DESIGN_SPEC\n\nPrototyping-Workflow: A\nDefault Loading Empty Error Success\nSCR-003 SCR-004\n\n## Design Freeze\n\n| **Name**: _________________________ |\n| **Date**: [YYYY-MM-DD] |\n%s\n' "$(head -c 1100 /dev/zero | tr '\0' 'd')" > "$d/docs/specs/DESIGN_SPEC.md"
    printf '# LOGO_DESIGN_BRIEF\nSelected benchmark: Linear\n%s\n' "$(head -c 300 /dev/zero | tr '\0' 'e')" > "$d/docs/specs/LOGO_DESIGN_BRIEF.md"
    printf '# COMPONENT_REQUIREMENTS\n%s\n' "$(head -c 1100 /dev/zero | tr '\0' 'f')" > "$d/docs/specs/COMPONENT_REQUIREMENTS.md"
    head -c 120 /dev/zero | tr '\0' 'z' > "$d/assets/logo/logo.svg"
    printf '# PLAN\n\nno handover recorded here\n' > "$d/docs/pm/DATA_MIGRATION_PLAN.md"
    ( cd "$d" && git init -q . && git config user.email t@t.co && git config user.name T )
}

W="$(mktemp -d)"
trap 'rm -rf "$W"' EXIT
mk_fixture "$W/proj"

if [ "$UPDATE" -eq 1 ]; then
    echo -e "${YELLOW}Regenerating $GOLDEN_FILE...${NC}"
elif [ ! -f "$GOLDEN_FILE" ]; then
    echo -e "${RED}No golden file at $GOLDEN_FILE${NC}"
    echo "Run: bash scripts/verify/test-gate-output.sh --update"
    exit 1
fi

echo -e "${BLUE}=== Gate Output Parity (19 gates + usage paths + M00-lite verdicts) ===${NC}"
echo "Fixture: fixed, deliberately incomplete (every gate reports something)."
echo ""

compare() {
    local name="$1" actual_file="$2" actual_code="$3"

    # Normalise machine-specific absolutes before comparing or storing.
    # The usage path prints "$0", an absolute path that differs on every device
    # (drive letters, or Unix-style home directories). Storing it verbatim would
    # make the golden files device-specific and fail on any other machine.
    sed -e "s|$ROOT_DIR|<REPO>|g" "$actual_file" > "$actual_file.norm" 2>/dev/null || cp "$actual_file" "$actual_file.norm"
    mv "$actual_file.norm" "$actual_file"

    # Record the exit code so update-mode can embed it. Keyed by gate name, not by
    # the capture filename (which carries an .out suffix).
    echo "$actual_code" > "$W/$name.code"

    if [ "$UPDATE" -eq 1 ]; then
        echo -e "  ${YELLOW}↻${NC} $name captured"
        return
    fi
    local want_code
    want_code="$(sed -n "s|^$MARKER $name exit=\(.*\)$|\1|p" "$GOLDEN_FILE" | head -1)"
    if [ -z "$want_code" ]; then
        echo -e "  ${RED}✗${NC} $name — not present in $GOLDEN_FILE"
        FAIL=$((FAIL + 1)); return
    fi
    # Extract this gate's body: between its start marker and its END marker.
    # An explicit terminator (rather than "up to the next marker") keeps the blank
    # line that separates blocks for readability out of the compared region, so the
    # stored bytes stay exactly what the gate printed.
    # Field comparison (not regex) so gate names with '_' need no escaping.
    local want_file="$W/want-$name.txt"
    awk -v want="$name" 'BEGIN { skip = 1 }
        /^##### GATE:/ { skip = ($3 != want); next }
        /^##### END GATE:/ { if (!skip) exit; next }
        !skip { print }
    ' "$GOLDEN_FILE" > "$want_file"
    if diff -q "$want_file" "$actual_file" >/dev/null 2>&1 && [ "$want_code" = "$actual_code" ]; then
        echo -e "  ${GREEN}✓${NC} $name (exit $actual_code)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name — output changed (exit want=$want_code got=$actual_code)"
        diff "$want_file" "$actual_file" 2>/dev/null | head -6 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}

for g in $GATES; do
    ( cd "$W/proj" && bash "$GATE" "$g" >"$W/$g.out" 2>&1 ); code=$?
    compare "$g" "$W/$g.out" "$code"
done

# Usage paths: no argument, and an unknown module.
( cd "$W/proj" && bash "$GATE" >"$W/_noarg.out" 2>&1 ); code=$?
compare "_noarg" "$W/_noarg.out" "$code"

( cd "$W/proj" && bash "$GATE" ZZZ >"$W/_invalid.out" 2>&1 ); code=$?
compare "_invalid" "$W/_invalid.out" "$code"

# M00-lite path. The main fixture is a Medium/client project, where M00 is WAIVED —
# so the lite branch (the one with the strictest parsing) went entirely uncaptured.
# That blind spot let a template/validator mismatch ship: the shipped template writes
# its machine fields bold ("- **Waitlist-Conversion-Pct**: 6.4") while the gate
# originally expected the bare form, so a template-faithful document FAILED its own
# gate. This fixture pins the whole lite checklist, both verdicts and exit codes.
mk_m00_fixture() {
    local d="$1" wl="$2"
    rm -rf "$d"; mkdir -p "$d/docs/pm"
    printf '%b' '- **Scale**: Medium\n- Delivery: solo\n' > "$d/docs/pm/PROJECT_STATE.md"
    {
        printf '# M00-Lite: Rapid Market Validation\n\n'
        printf '## 1. Project Metadata & Problem Pitch\n\n'
        printf -- '- **Project Codename**: KasirKilat\n'
        printf -- '- **Target User**: Micro-retail owners\n'
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
        printf '%b' "$wl"
        printf '\n## 6. Unit Economics & Solo Capacity Sanity Check\n\n'
        printf -- '- **Target ARPU**: Rp 99000 / month\n\n'
        printf '## 7. Kill Criteria & Gate Validation Outcome\n\n'
        printf '### Kill Criteria Triggers:\n'
        printf '1. Market Kill: conversion < 2.0%% after >=100 visitors\n\n'
    } > "$d/docs/pm/M00_LITE.md"
}

# Case A: PASS — the template's own bold formatting, full evidence, human attribution.
mk_m00_fixture "$W/m00pass" '- **Total Unique Visitors**: 140
- **Total Waitlist / Email Signups**: 9
- **Waitlist-Conversion-Pct**: 6.4

Validated-by: Zen on 2026-10-12

Gate-Decision: PASS
'
( cd "$W/m00pass" && bash "$GATE" M00 >"$W/_m00-lite-pass.out" 2>&1 ); code=$?
compare "_m00-lite-pass" "$W/_m00-lite-pass.out" "$code"

# Case B: RETEST — exit 3 is a distinct, non-terminal verdict; the golden file pins it.
mk_m00_fixture "$W/m00retest" '- **Total Unique Visitors**: 140
- **Total Waitlist / Email Signups**: 5
- **Waitlist-Conversion-Pct**: 3.6

Validated-by: Zen on 2026-10-12

Gate-Decision: RETEST
'
( cd "$W/m00retest" && bash "$GATE" M00 >"$W/_m00-lite-retest.out" 2>&1 ); code=$?
compare "_m00-lite-retest" "$W/_m00-lite-retest.out" "$code"

# In update mode, assemble the consolidated golden file from the captures above.
# Normalisation already ran inside compare(), so no device paths reach the file.
if [ "$UPDATE" -eq 1 ]; then
    : > "$W/golden.new"
    {
        echo "# Golden gate output — captured by scripts/verify/test-gate-output.sh --update"
        echo "# Do not edit by hand. Each block: '${MARKER} <GATE> exit=<code>' then the exact"
        echo "# stdout+stderr that gate produced against the fixed fixture in the test script."
    } >> "$W/golden.new"
    for name in $GATES _noarg _invalid _m00-lite-pass _m00-lite-retest; do
        [ -f "$W/$name.out" ] || continue
        rc="$(cat "$W/$name.code" 2>/dev/null || echo "?")"
        {
            echo ""
            echo "${MARKER} ${name} exit=${rc}"
        } >> "$W/golden.new"
        cat "$W/$name.out" >> "$W/golden.new"
        echo "${END_MARKER} ${name}" >> "$W/golden.new"
    done
    mv "$W/golden.new" "$GOLDEN_FILE"
fi

echo ""
if [ "$UPDATE" -eq 1 ]; then
    echo -e "${YELLOW}Golden updated. Re-run without --update to verify.${NC}"
    exit 0
fi
if [ "$FAIL" -eq 0 ]; then
    echo -e "${GREEN}All $PASS gate output checks match golden (byte-for-byte).${NC}"
    exit 0
fi
echo -e "${RED}$FAIL of $((PASS + FAIL)) gate output checks FAILED.${NC}"
exit 1
