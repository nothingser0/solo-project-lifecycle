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
INTAKE_ANSWERED='- **Scale**: Small\n- Delivery: solo\n- Intake-Success-Metric: 10 users can create a task\n- Intake-P0-Features: 3 (create, list, complete)\n- Intake-Time-Capacity: 10 hrs/week x 3 weeks = 30 hrs\n- Intake-Sensitive-Data: no\n- Intake-Integrations: none\n- Intake-Branch-Hierarchy: no\n- Intake-Compliance: none\n- Intake-Legacy-Core: no\n- Intake-Status: ANSWERED\n\n- Next-Action: run validate-gate.sh M01\n- Open-Decisions: none\n'
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
echo "DB defense: a ticked M06-DB task without real-DB probes must be rejected."
# Regression: STEP 6 required a real database probe but nothing enforced it, so a DB task
# could cite a green vitest run against a stubbed repo and pass. Scoped to M06-DB only.
expect_db() {
    local name="$1" want="$2" todo="$3" evidence="$4"
    local dir="$WORK/dbdef"
    rm -rf "$dir"; mkdir -p "$dir/docs/pm" "$dir/artifacts"
    printf '%b' "$todo" > "$dir/TODO.md"
    printf '%b' "$evidence" > "$dir/artifacts/final-evidence.md"
    local out got
    out="$(cd "$dir" && bash "$GATE" M06 2>&1 || true)"
    got="ALLOWED"
    echo "$out" | grep -qE "no real-DB proof" && got="BLOCKED"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M06 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M06 -> $got, expected $want)"
        FAIL=$((FAIL + 1))
    fi
}
DB_TODO='- [x] **M06-DB-01: Schema**\n  - **Evidence**: migrations exit 0 | Approved: 2026-10-12 by S. Rahma\n'
DB_PROBES='migrate up\nmigrate down\nmigrate up\nseeder COUNT(*) before 0 after 12\nEXPLAIN uses idx_inv_tenant\n'
expect_db "stubbed DB task blocked"        "BLOCKED" "$DB_TODO" 'Evidence: vitest 12 passed\n'
expect_db "probed DB task allowed"         "ALLOWED" "$DB_TODO" "$DB_PROBES"
expect_db "partial probes blocked"         "BLOCKED" "$DB_TODO" 'migrate down ok\nEXPLAIN ok\n'
expect_db "UI task unaffected by DB rule"  "ALLOWED" '- [x] **M06-FE-01: Page**\n  - **Evidence**: route 200 | Approved: 2026-10-12 by S. Rahma\n' 'route /invoices 200\n'

echo "Per-task human approval gate: M06 must reject self-approved tasks."
echo "Regression: the gate required every task to be '[x]' but never checked"
echo "WHO ticked it, so an agent could self-approve a whole sprint."
echo ""

# expect_m04_screen <name> <PASS|FAIL> <screen-html>
# Builds the minimum M04 project and varies only the prototype screen content.
expect_m04_screen() {
    local name="$1" want="$2" html="$3" variant="${4:-}"
    local dir="$WORK/m04scr"
    rm -rf "$dir"; mkdir -p "$dir/docs/pm" "$dir/docs/specs" "$dir/docs/design/screens" "$dir/docs/design/brand" "$dir/docs/design/inspiration"
    printf '%b' "$INTAKE_MEDIUM" > "$dir/docs/pm/PROJECT_STATE.md"
    printf '%b' "$html" > "$dir/docs/design/screens/SCR-003.html"
    # everything M04 needs that is not under test
    printf 'SCR-003 admin invoices\n%s\n' "$(printf 'sitemap detail row. %.0s' $(seq 1 120))" > "$dir/docs/specs/SITEMAP.md"
    printf '# DESIGN_SPEC\n\nPrototyping: Interactive Code Prototype\nDefault Loading Empty Error Success\n%s\n' \
        "$(printf 'screen rows and state matrix detail. %.0s' $(seq 1 100))" > "$dir/docs/specs/DESIGN_SPEC.md"
    printf '# Components\n\n## Primitives & Atomic\nbutton input\n## Composites\ncard form\n## Accessibility WCAG AA\ncontrast 4.5:1\n%s\n' \
        "$(printf 'component inventory detail. %.0s' $(seq 1 60))" > "$dir/docs/specs/COMPONENT_REQUIREMENTS.md"
    printf '# Logo brief\n\nmonogram mark with brand accent and clear space rules defined\n' > "$dir/docs/specs/LOGO_DESIGN_BRIEF.md"
    printf '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64"><circle cx="32" cy="32" r="28" fill="#3b82f6"/><text x="32" y="42" font-size="28" fill="#fff" text-anchor="middle">A</text></svg>\n' > "$dir/docs/design/brand/logo.svg"
    printf '# inspiration notes\n\nWinning benchmark: Linear, because of its density and neutral palette.\n%s\n' \
        "$(printf 'observation detail. %.0s' $(seq 1 60))" > "$dir/docs/design/inspiration/notes.md"
    printf 'reference screenshot placeholder supplied by the human\n' > "$dir/docs/design/inspiration/ref.png"
    printf 'sources:\n  - docs/design/inspiration/notes.md\n\nEvidence & Inference Log: tokens marked observed or inferred\n\nTypography scale and Spacing scale defined here.\nContrast 4.5:1 and 7.0:1 recorded. z-index base 0 toast 60.\n%s\n' \
        "$(printf 'design token detail. %.0s' $(seq 1 60))" > "$dir/DESIGN.md"
    mkdir -p "$dir/docs/design/components" "$dir/docs/specs/wireflows"
    case "$variant" in
        no-showcase)     : ;;
        hollow-showcase) printf '<!doctype html><html><body>\n' > "$dir/docs/design/components/index.html" ;;
        broken-asset)
            printf '<!doctype html><html><head><meta name="viewport" content="width=device-width"><link rel="stylesheet" href="../shared/css/missing.css"></head><body><main><p>%s</p></main></body></html>\n' \
                "$(printf 'Screen words that clear the hollow floor comfortably. %.0s' $(seq 1 40))" > "$dir/docs/design/screens/SCR-003.html" ;;
        word-only)
            printf '<!doctype html><html><head><meta name="viewport" content="width=device-width"><title>s</title></head><body>%s</body></html>\n' \
                "$(printf 'Just prose with no elements at all in the body tag. %.0s' $(seq 1 50))" > "$dir/docs/design/screens/SCR-003.html" ;;
        *)               printf '<!doctype html><html><body><main>\n%s\n</main></body></html>\n' \
                             "$(printf 'Primitive and composite components rendered on the shared sheet. %.0s' $(seq 1 30))" > "$dir/docs/design/components/index.html" ;;
    esac
    case "$variant" in
        no-wireflow) : ;;
        *)           printf '# SCENARIOS_WF01\n\n## Baseline fixture\nseed admin account\n\n## Happy path\n%s\n' \
                          "$(printf 'Open invoices and confirm totals update. %.0s' $(seq 1 20))" > "$dir/docs/specs/wireflows/SCENARIOS_WF01.md" ;;
    esac
    local out got="PASS"
    out="$(cd "$dir" && bash "$GATE" M04 2>&1 || true)"
    echo "$out" | grep -qE "too hollow to be a screen" && got="FAIL"
    echo "$out" | grep -qE "Component showcase missing|Component showcase .* too hollow|Wireflow Interaction Scenarios missing" && got="FAIL"
    echo "$out" | grep -qE "asset reference\(s\) resolve to nothing|no elements in <body>" && got="FAIL"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M04 hollow -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M04 hollow -> $got, expected $want)"
        FAIL=$((FAIL + 1))
    fi
}
expect_m04_screen "stylesheet that resolves to nothing blocks" FAIL '<!doctype html><html><body><main>PLACEHOLDER</main></body></html>' broken-asset
expect_m04_screen "body with no elements is not a screen" FAIL '<!doctype html><html><body><main>PLACEHOLDER</main></body></html>' word-only
expect_m04_screen "component showcase missing blocks" FAIL '<!doctype html><html><body><main>PLACEHOLDER</main></body></html>' no-showcase
expect_m04_screen "hollow component showcase blocks" FAIL '<!doctype html><html><body><main>PLACEHOLDER</main></body></html>' hollow-showcase
expect_m04_screen "zero wireflow runbooks block" FAIL '<!doctype html><html><body><main>PLACEHOLDER</main></body></html>' no-wireflow
# the same fixture, but with a showcase + wireflow, must pass the new checks
expect_m04_screen "empty 0-byte .html is not a prototype" FAIL ''
expect_m04_screen "real markup screen passes the hollow check" PASS "<!doctype html><html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><title>Invoices</title></head><body data-roles=\"admin\"><main><h1>Invoices</h1><p>$(printf 'Invoice rows for the current month with totals and status per row. %.0s' $(seq 1 40))</p></main></body></html>
"
# A screenshot is a reference, not a screen the developer built.
m04_png_only() {
    local dir="$WORK/m04png"; rm -rf "$dir"; mkdir -p "$dir/docs/design/screens" "$dir/docs/pm"
    printf '%b' "$INTAKE_MEDIUM" > "$dir/docs/pm/PROJECT_STATE.md"
    printf 'x' > "$dir/docs/design/screens/shot.png"
    local out; out="$(cd "$dir" && bash "$GATE" M04 2>&1 || true)"
    if echo "$out" | grep -qE "Interactive screen preview outputs present"; then
        echo -e "  ${RED}✗${NC} a PNG alone must not count as a prototype screen"
        FAIL=$((FAIL + 1))
    else
        echo -e "  ${GREEN}✓${NC} a PNG alone does not count as a prototype screen"
        PASS=$((PASS + 1))
    fi
}
m04_png_only

# expect_m03_sow <name> <PASS|FAIL> <signature-block-content>
# Builds a complete client SOW and swaps only its signature block / clause substance.
expect_m03_sow() {
    local name="$1" want="$2" sig="$3"
    local dir="$WORK/m03sow"
    rm -rf "$dir"; mkdir -p "$dir/docs/pm" "$dir/contracts" "$dir/docs/governance"
    printf '%b' "$INTAKE_MEDIUM" > "$dir/docs/pm/PROJECT_STATE.md"
    printf '# NDA\n\n%s\n' "$(printf 'Mutual confidentiality obligations apply to both parties. %.0s' $(seq 1 20))" > "$dir/contracts/NDA.md"
    local i=1; while [ $i -le 40 ]; do echo "risk item $i with owner and mitigation described in enough words" >> "$dir/docs/governance/RISK_ASSESSMENT_MATRIX.md"; i=$((i+1)); done
    i=1; while [ $i -le 40 ]; do echo "raci row $i with responsible accountable consulted informed named" >> "$dir/docs/governance/RACI_MATRIX.md"; i=$((i+1)); done
    {
      echo '# SOW'
      echo '## Project Overview'; echo 'Build a POS for Acme with 7 features over 12 weeks.'
      echo '## Scope of Work'; echo 'Seven features per SCOPE_STATEMENT, nothing more.'
      echo '## Deliverables & Milestones'; echo 'M-01 to M-06 with dated sign-off per milestone.'
      echo '## Change Request'; echo 'Any change beyond scope needs a written CR with fee and timeline.'
      echo '## Compensation & Payment Terms'
      echo 'Total Rp 60.000.000. DP 30% Rp 18.000.000 within 7 days of signing. Balance per milestone.'
      echo '- [x] DP 2026-11-01 Rp 18.000.000 Cleared'
      echo '## Single PIC'; echo 'Ibu Sri is the sole approval authority for this engagement.'
      echo '## Deemed Acceptance'
      printf 'If the Client does not provide written feedback within seven calendar days of a deliverable submission, that deliverable is deemed accepted. Deemed acceptance triggers the corresponding invoice and starts the applicable warranty period, and later objections are handled as a new Change Request rather than as a defect.\n'
      echo '## Limitation of Liability'
      printf 'The Developer aggregate liability under this agreement is limited to the total fees actually paid by the Client at the time the claim arises. Neither party is liable for indirect, incidental or consequential loss, including lost profits or lost data, except where the law does not permit such exclusion.\n'
      echo '## Revision Limits'
      printf 'The fee includes two rounds of design revision and two rounds of user acceptance testing. Further rounds are treated as a Change Request priced separately. Feedback must be supplied in writing within seven calendar days of each submission and silence is treated as acceptance rather than approval of later changes.\n'
      echo '## Third-Party Accounts'
      printf 'All third-party accounts required to operate the system, including hosting, domain registration, email delivery and payment gateway accounts, are registered in the Client name and billed directly to the Client. The Developer receives delegated access only for the duration of the engagement and never becomes the owner of those accounts.\n'
      echo '## Intellectual Property'
      printf 'All intellectual property in the delivered work remains the property of the Developer until the full contract value has been received and cleared. On final payment ownership transfers to the Client. Pre-existing tools, libraries and internal frameworks used by the Developer remain the Developer property and are licensed, not assigned, to the Client.\n'
      echo '## Signatures'
      printf '%b\n' "$sig"
    } > "$dir/contracts/SOW_CONTRACT.md"
    local out got="PASS"
    out="$(cd "$dir" && bash "$GATE" M03 2>&1 || true)"
    echo "$out" | grep -qE "Gate validation FAILED" && got="FAIL"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M03 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M03 -> $got, expected $want)"
        FAIL=$((FAIL + 1))
    fi
}
SIG_BLANK='Client\nName: _________________________________\nTitle: _________________________________\nDate: _________________________________\nSignature: _________________________________\n'
SIG_FILLED='Client\nName: Sri Wahyuni  Signature: /s/ Sri Wahyuni\nTitle: Operations Director  Date: 2026-11-01\nSignature: /s/ Sri Wahyuni  Date: 2026-11-01\nDeveloper\nName: Zeenn  Signature: /s/ Zeenn  Date: 2026-11-02\n'
expect_m03_sow "unsigned SOW (blank signature lines) blocked" FAIL "$SIG_BLANK"
expect_m03_sow "signed SOW with substantive clauses passes"  PASS "$SIG_FILLED"

# expect_m02_scope <name> <PASS|FAIL> <scope-content>
expect_m02_scope() {
    local name="$1" want="$2" scope="$3"
    local dir="$WORK/m02ac"
    rm -rf "$dir"; mkdir -p "$dir/docs/pm"
    printf '%b' "$INTAKE_MEDIUM" > "$dir/docs/pm/PROJECT_STATE.md"
    printf '%b' "$scope" > "$dir/docs/pm/SCOPE_STATEMENT.md"
    # Unrelated M02 prerequisites, so the assertion isolates the criteria/OOS rule.
    # Non-stub (the gate rejects near-empty files): real prose, kept short.
    printf '# Stakeholders\n\nThe buyer sponsors the work and signs off each milestone. The\noperations lead supplies the domain rules and reviews the workflow. No third\nparty has approval authority, so decisions resolve within one working day.\n' > "$dir/docs/pm/STAKEHOLDER_MAP.md"
    printf '# Communication Plan\n\nA written status update goes out every Friday covering what\nshipped, what slipped and the next milestone. Blocking questions are raised the\nsame day rather than saved for the weekly call.\n' > "$dir/docs/pm/COMMUNICATION_PLAN.md"
    local out got="PASS"
    out="$(cd "$dir" && bash "$GATE" M02 2>&1 || true)"
    echo "$out" | grep -qE "Gate validation FAILED" && got="FAIL"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M02 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M02 -> $got, expected $want)"
        FAIL=$((FAIL + 1))
    fi
}

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

# B1c. M05 endpoint contracts. The spec (M05 §STEP 4) says "document every in-scope API
# operation; do not invent endpoints to meet a count" — so there is no numeric floor.
# What the gate must prove is (1) headings nested under a section are still counted
# (leading-space tolerance) and (2) a heading without the four contract fields is not a
# contract. Regression: the old pattern required a bare "####" at column 0, so a
# template-faithful FSD scored 0 endpoints and no project could pass its own gate.
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
    if echo "$out" | grep -q "API endpoint contracts found" && ! echo "$out" | grep -q "carry all four contract fields"; then
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

# Contract-valid block builder: every field the gate counts.
ep_block() {
    local indent="$1" method="$2" path="$3" omit="${4:-}"
    printf '%b#### %s %s\n' "$indent" "$method" "$path"
    [ "$omit" = "auth" ] || printf -- '- **Auth**: bearer token, role ADMIN\n'
    [ "$omit" = "req" ]  || printf -- '- **Request**: `{ "name": string }`\n'
    [ "$omit" = "ok" ]   || printf -- '- **Success**: 200 `{ "id": uuid }`\n'
    [ "$omit" = "err" ]  || printf -- '- **Error**: 400 validation, 403 forbidden\n'
}

TEN_HEADINGS="## 6. API\n"
TEN_HEADINGS+="$(ep_block '  ' GET /api/v1/a)"
for i in 2 3 4 5 6 7 8 9 10; do TEN_HEADINGS+="$(ep_block '' POST /api/v1/r$i)"; done
TEN_HEADINGS+=$'\n'

INCOMPLETE_HEADINGS="## 6. API\n$(ep_block '' GET /api/v1/a)\n$(ep_block '' POST /api/v1/b err)\n"

run_endpoints "M05 counts nested headings and accepts complete contracts" ENOUGH "$TEN_HEADINGS"
run_endpoints "M05 rejects a heading without the four contract fields" TOO_FEW "$INCOMPLETE_HEADINGS"
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
        echo "$out" | grep -E '❌|⚠️' | head -4 | sed "s/^/       /"
        FAIL=$((FAIL + 1))
    fi
}

M01_OK='# Brief\n\nFeasibility-Score-Technical: 4.0\nFeasibility-Score-Operational: 4.0\nFeasibility-Score-Regulatory: 4.0\nFeasibility-Score-Financial: 4.0\nFeasibility-Decision: GO\nFeasibility-Evidence-Technical: N=10 interviews, 7/10 hit this weekly\nFeasibility-Evidence-Operational: 3 epics = 96h vs 160h capacity\nFeasibility-Evidence-Regulatory: UU PDP baseline, 0 external audits\nFeasibility-Evidence-Financial: 3/10 committed Rp 150k/mo'
# Declared Small, but the structured fields say 20 P0 features + sensitive data.
STATE_LIES_SMALL='- **Scale**: small\n- Delivery: solo\n- Intake-Success-Metric: m\n- Intake-P0-Features: 20 (a..t)\n- Intake-Time-Capacity: 5 hrs/week x 2 weeks\n- Intake-Sensitive-Data: yes\n- Intake-Integrations: none\n- Intake-Branch-Hierarchy: no\n- Intake-Compliance: none\n- Intake-Legacy-Core: no\n- Intake-Status: ANSWERED\n'
expect_m01 "Self-declared Small, 20 P0 + sensitive data (classifier wins)" FAIL "$STATE_LIES_SMALL" "$M01_OK"

# No PROJECT_STATE.md at all: the intake gate must fail for EVERY scale.
expect_m01 "Medium intent, no PROJECT_STATE.md" FAIL "EMPTY" "$M01_OK"

# PROVISIONAL is a legitimate halt state, not an undeclared decision.
M01_PROV='# Brief\n\nFeasibility-Score-Technical: 4.0\nFeasibility-Score-Operational: 4.0\nFeasibility-Score-Regulatory: 4.0\nFeasibility-Score-Financial: 4.0\nFeasibility-Decision: PROVISIONAL_PENDING_M00\nFeasibility-Evidence-Technical: N=10 interviews, 7/10 hit this weekly\nFeasibility-Evidence-Operational: 3 epics = 96h vs 160h capacity\nFeasibility-Evidence-Regulatory: UU PDP baseline, 0 external audits\nFeasibility-Evidence-Financial: 3/10 committed Rp 150k/mo'
expect_m01 "PROVISIONAL_PENDING_M00 (no final GO)" PROVISIONAL "$INTAKE_MEDIUM" "$M01_PROV"

# Acceptance-criteria binding: `## Acceptance Criteria` was checked as a heading only, so a
# scope whose entire criteria section read "(the acceptance criteria are obvious)" locked and
# passed. A locked scope promises every Must-Have is testable.
M02_VAGUE_AC='# Scope\n\n## User Stories\n\n- x\n\n## Acceptance Criteria\n\n(the acceptance criteria are obvious)\n\n## Out-of-Scope\n\n- Offline mode is not supported in the MVP\n- Multi-currency pricing is excluded\n- Native mobile apps are out of scope\n\n## Must-Have\n\n| ID | Requirement | Priority |\n|---|---|---|\n| **F-01** | a | Must |\n| **F-02** | b | Must |\n| **F-03** | c | Must |\n| **F-04** | d | Must |\n| **F-05** | e | Must |\n| **F-06** | f | Must |\n\nNo self-approval for mutations/approvals.\n\nScope-Lock-Decision: LOCKED\nScope-P0-Count: 6\n\n✅ legend\n'
M02_TESTED_AC='# Scope\n\n## User Stories\n\n- x\n\n## Acceptance Criteria\n\n- [ ] Given a user, when they submit F-01, then response is 200\n- [ ] Given a user, when they submit F-02, then response is 200\n- [ ] Given a user, when they submit F-03, then response is 200\n- [ ] Given a user, when they submit F-04, then response is 200\n- [ ] Given a user, when they submit F-05, then response is 200\n- [ ] Given a user, when they submit F-06, then response is 200\n\n## Out-of-Scope\n\n- Offline mode is not supported in the MVP\n- Multi-currency pricing is excluded\n- Native mobile apps are out of scope\n\n## Must-Have\n\n| ID | Requirement | Priority |\n|---|---|---|\n| **F-01** | a | Must |\n| **F-02** | b | Must |\n| **F-03** | c | Must |\n| **F-04** | d | Must |\n| **F-05** | e | Must |\n| **F-06** | f | Must |\n\nNo self-approval for mutations/approvals.\n\nScope-Lock-Decision: LOCKED\nScope-P0-Count: 6\n\n✅ legend\n'
M02_JUNK_OOS='# Scope\n\n## User Stories\n\n- x\n\n## Acceptance Criteria\n\n- [ ] Given a user, when they submit F-01, then response is 200\n- [ ] Given a user, when they submit F-02, then response is 200\n- [ ] Given a user, when they submit F-03, then response is 200\n- [ ] Given a user, when they submit F-04, then response is 200\n- [ ] Given a user, when they submit F-05, then response is 200\n- [ ] Given a user, when they submit F-06, then response is 200\n\n## Out-of-Scope\n\n- 1\n- 2\n- 3\n\n## Must-Have\n\n| ID | Requirement | Priority |\n|---|---|---|\n| **F-01** | a | Must |\n| **F-02** | b | Must |\n| **F-03** | c | Must |\n| **F-04** | d | Must |\n| **F-05** | e | Must |\n| **F-06** | f | Must |\n\nNo self-approval for mutations/approvals.\n\nScope-Lock-Decision: LOCKED\nScope-P0-Count: 6\n\n✅ legend\n'
expect_m02_scope "vague acceptance criteria blocked" FAIL "$M02_VAGUE_AC"
expect_m02_scope "testable criteria for every Must-Have pass" PASS "$M02_TESTED_AC"
expect_m02_scope "junk out-of-scope placeholders blocked" FAIL "$M02_JUNK_OOS"

# Evidence binding: a 4.0 dimension is a claim of near-certainty. An all-4.0 brief was the
# cheapest possible fabrication (190 bytes, no research) and it passed the gate; a cited data
# point is what a Confidence marker cannot fake. Unbacked high scores are forced to 3.0, which
# makes GO (average >= 3.5) unreachable.
M01_NO_EVIDENCE='# Brief\n\nFeasibility-Score-Technical: 4.0\nFeasibility-Score-Operational: 4.0\nFeasibility-Score-Regulatory: 4.0\nFeasibility-Score-Financial: 4.0\nFeasibility-Decision: GO\n'
expect_m01 "all-4.0 brief with zero cited evidence is rejected" FAIL "$INTAKE_MEDIUM" "$M01_NO_EVIDENCE"
M01_ONE_BACKED='# Brief\n\nFeasibility-Score-Technical: 4.0\nFeasibility-Evidence-Technical: N=10 interviews, 7/10 hit this weekly\nFeasibility-Score-Operational: 4.0\nFeasibility-Evidence-Operational: 3 epics = 96h vs 160h capacity\nFeasibility-Score-Regulatory: 4.0\nFeasibility-Evidence-Regulatory: UU PDP baseline, 0 external audits\nFeasibility-Score-Financial: 4.0\nFeasibility-Evidence-Financial: 3/10 committed Rp 150k/mo\nFeasibility-Decision: GO\n'
expect_m01 "same 4.0 scores with cited evidence pass" PASS "$INTAKE_MEDIUM" "$M01_ONE_BACKED"
# A modest score needs no citation: evidence is only demanded where certainty is claimed.
M01_MODEST='# Brief\n\nFeasibility-Score-Technical: 3.5\nFeasibility-Score-Operational: 3.5\nFeasibility-Score-Regulatory: 3.5\nFeasibility-Score-Financial: 3.5\nFeasibility-Decision: GO\n'
expect_m01 "3.5 scores need no citation" PASS "$INTAKE_MEDIUM" "$M01_MODEST"

# Fail-closed: average < 3.5 may not be declared GO.
M01_LOW='# Brief\n\nFeasibility-Score-Technical: 3.5\nFeasibility-Score-Operational: 3.5\nFeasibility-Score-Regulatory: 3.0\nFeasibility-Score-Financial: 3.0\nFeasibility-Decision: GO\n'
expect_m01 "average 3.25 declared GO (talked up)" FAIL "$INTAKE_MEDIUM" "$M01_LOW"

# CONDITIONAL_GO must carry its mitigation plan, in either spelling.
M01_COND_NOMIT='# Brief\n\nFeasibility-Score-Technical: 4.0\nFeasibility-Score-Operational: 4.0\nFeasibility-Score-Regulatory: 4.0\nFeasibility-Score-Financial: 4.0\nFeasibility-Decision: CONDITIONAL_GO\nFeasibility-Evidence-Technical: N=10 interviews, 7/10 hit this weekly\nFeasibility-Evidence-Operational: 3 epics = 96h vs 160h capacity\nFeasibility-Evidence-Regulatory: UU PDP baseline, 0 external audits\nFeasibility-Evidence-Financial: 3/10 committed Rp 150k/mo'
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
        echo "$out" | grep -E '❌|\[INFO\]' | head -4 | sed "s/^/       /"
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

# M05 / M06 must run the SAME classifier: SKILL.md promises "the scale classifier still
# runs" on the Small path, but only M01/M02 called it, and Small skips both — so a
# Small-declared project reached architecture/coding with an unvalidated Intake.
# This fixture declares small, but its answers evaluate to medium (1 webhook), so the
# High-Water-Mark mismatch must now fail at M05/M06, not only at M01/M02.
expect_gate_scale_mismatch() {
    local gate="$1" name="$2"
    local dir="$WORK/gsm-$gate"
    make_project "$dir" "$STATE_WEBHOOK"
    local out code got
    out="$(cd "$dir" && bash "$GATE" "$gate" 2>&1)"; code=$?
    got="PASSED"
    if [ "$code" -ne 0 ]; then
        got="BLOCKED"
    fi
    if [ "$got" = "BLOCKED" ] && echo "$out" | grep -q "Scale mismatch"; then
        echo -e "  ${GREEN}✓${NC} $name  ($gate -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  ($gate -> $got/exit $code, expected BLOCKED with Scale mismatch)"
        echo "$out" | grep -E '❌' | head -3 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
    rm -rf "$dir"
}
expect_gate_scale_mismatch M05 "M05 runs the classifier: declared small vs webhook=medium"
expect_gate_scale_mismatch M06 "M06 runs the classifier: declared small vs webhook=medium"

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
# The handoff check in M05 and M06 was a bare presence grep: a document containing
# the words "Handoff Strategy" in prose passed, without the Level 1-4 or the
# conversion plan its own error message promises. Both gates now require a level.
# expect_handoff <label> <fsd-body> <want: BLOCKED|ALLOWED>
expect_handoff() {
    local label="$1" body="$2" want="$3"
    local dir="$WORK/handoff"
    make_project "$dir" "$INTAKE_MEDIUM"
    mkdir -p "$dir/docs/specs"
    printf '%b' "$body" > "$dir/docs/specs/FSD.md"
    # Assert the handoff rule itself, not the whole M06 gate: M06 has many other
    # requirements, so running it whole would report BLOCKED for a different reason
    # and the case would prove nothing about the handoff check.
    local got="BLOCKED"
    if grep -qiE "Module 04 Handoff|Handoff Strategy|Handoff-Compatibility" "$dir/docs/specs/FSD.md" && \
       grep -qiE "Compatibility Level[^:]*:[[:space:]]*(Level[[:space:]]*)?[1-4]|Level[[:space:]]*[1-4]" "$dir/docs/specs/FSD.md"; then
        got="ALLOWED"
    fi
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $label  (handoff -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $label  (handoff -> $got, expected $want)"
        FAIL=$((FAIL + 1))
    fi
    rm -rf "$dir"
}
expect_handoff "Handoff: prose mentioning the words is rejected" '# FSD\n\nWe should discuss the Handoff Strategy later.\n' BLOCKED
expect_handoff "Handoff: a real Compatibility Level 3 is accepted" '# FSD\n\n### Module 04 Handoff Strategy\n**Compatibility Level**: Level 3\n**Conversion Plan**: rebuild 6 components.\n' ALLOWED


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
# Non-delegable is an obligation, not a size. INTAKE_GATE.md Q6, SKILL.md and the
# acceptance template all say legacy-core blocks "at any size" — but the predicate
# used to live inside the TIER>=3 branch, so a 12-P0 Medium ledger migration passed
# as "Within solo capacity" (exit 0) with a valid acceptance file sitting unused.
MED_LEGACY="${INTAKE_MEDIUM/Intake-Legacy-Core: no/Intake-Legacy-Core: yes}"
expect_capacity "Medium legacy-core is non-delegable at ANY tier" BLOCKED "$MED_LEGACY" "$CAP_ACCEPTED"
expect_capacity "Medium legacy-core, no acceptance file either" BLOCKED "$MED_LEGACY" "EMPTY"
expect_capacity "Medium scope stays solo-viable (no override needed)" SOLO_VIABLE "$INTAKE_MEDIUM" "EMPTY"

# The classifier's exit 5 used to die inside check_scale_feasibility: it printed a
# warning and returned 0, so validate-gate.sh exited 0 — a clean green, which every
# document forbids. The dispatcher now owns the verdict (GATE_VERDICT=CAPACITY_OVERRIDE
# -> exit 5). A real artefact failure still wins, so the override cannot hide a
# missing brief.
# expect_gate_override <name> <want-exit> <brief|EMPTY>
expect_gate_override() {
    local name="$1" want="$2" brief="$3"
    local dir="$WORK/ov"
    make_project "$dir" "$CAP_LARGE"
    printf '%b' "$CAP_ACCEPTED" > "$dir/docs/pm/SOLO-CAPACITY-RISK-ACCEPTANCE.md"
    [ "$brief" = "EMPTY" ] || printf '%b' "$brief" > "$dir/docs/pm/IDEA_BRIEF.md"
    local code
    ( cd "$dir" && bash "$GATE" M01 >/dev/null 2>&1 ); code=$?
    if [ "$code" -eq "$want" ]; then
        echo -e "  ${GREEN}\u2713${NC} $name  (validate-gate M01 -> exit $code)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}\u2717${NC} $name  (validate-gate M01 -> exit $code, expected $want)"
        FAIL=$((FAIL + 1))
    fi
}
expect_gate_override "Large override + complete brief is exit 5, not a clean green" 5 "$M01_OK"
expect_gate_override "Large override + missing brief stays a hard fail (exit 1)" 1 "EMPTY"

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
        echo "$out" | grep -E '❌ STEP' | head -4 | sed "s/^/       /"
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

# `mktemp -d` alone returns a drive-letter path here which bash cannot `cd` into, so
# the subshell below silently stayed in the repo and the test measured nothing.
# `-p /tmp` asks for the POSIX temp root directly, so no drive form is constructed.
# (Do not write an example path in this comment: the repo's own device-path guard
# scans scripts/ and would flag it.)
OUTSIDE="$(mktemp -d -p /tmp 2>/dev/null || mktemp -d)"

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
        grep -nE '(/[A-Za-z]/Users/|/Users/[a-z0-9_.-]+/|/home/[a-z0-9_.-]+/|[A-Za-z]:[\\/]Users)' "$GOLDEN_FILE" | head -4 | sed "s/^/       /"
        FAIL=$((FAIL + 1))
    else
        echo -e "  ${GREEN}✓${NC} golden gate outputs are device-independent (no absolute author paths)"
        PASS=$((PASS + 1))
    fi
fi

# ---------------------------------------------------------------------------
# Gate smoke coverage for the modules that had NO rule-level case.
#
# The golden suite runs every gate and byte-compares its output, so a gate is
# never "untested" — but a golden pins whatever the gate printed that day, and
# would happily pin a broken rule. These assert the rule itself, in both
# directions: an empty project must FAIL, a minimally filled one must PASS.
#
# Each case names one artifact the gate is responsible for. If a gate starts
# passing an empty project, or stops accepting a filled one, this fails.
# ---------------------------------------------------------------------------
# expect_gate <gate> <label> <required-file> <want: BLOCKED|ALLOWED> [extra-content]
#   No extra-content  => document the gate requires is absent   -> expect BLOCKED
#   extra-content set => that document exists with content      -> expect ALLOWED
expect_gate() {
    local gate="$1" label="$2" file="$3" want="$4" content="${5:-}"
    local dir="$WORK/smoke-$gate"
    make_project "$dir" "$INTAKE_MEDIUM"
    # Enterprise advisory gates need the enterprise delivery declaration.
    case "$gate" in
        A*) printf -- '- **Scale**: Enterprise\n- Delivery: client\n' > "$dir/docs/pm/PROJECT_STATE.md" ;;
    esac
    if [ -n "$content" ]; then
        mkdir -p "$dir/$(dirname "$file")"
        printf '%b' "$content" > "$dir/$file"
    fi
    local out rc got
    out="$(cd "$dir" && bash "$GATE" "$gate" 2>&1)"; rc=$?
    got="ALLOWED"; [ "$rc" -ne 0 ] && got="BLOCKED"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $label  ($gate -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $label  ($gate -> $got/exit $rc, expected $want)"
        printf '%s' "$out" | grep -E "MISSING|missing|❌" | head -2 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
    rm -rf "$dir"
}

# Content long enough to clear the byte floor, with the headings each gate greps.
# M00 aggregates four signals (runbook §1): PASS if any PASS, KILL only if ALL KILL,
# otherwise RETEST. The gate once used waitlist conversion alone, so an intent-only
# 20% report scored KILL, and any single "strong" signal rescued a genuine KILL.
# expect_m00_signal <name> <waitlist-pct> <intent> <deposits> <loi> <declared> <want-computed>
expect_m00_signal() {
    local name="$1" pct="$2" intent="$3" dep="$4" loi="$5" declared="$6" want="$7"
    local dir="$WORK/m00sig"
    make_project "$dir" "- **Scale**: Medium\n- Delivery: solo\n"
    cat > "$dir/docs/pm/M00_LITE.md" <<M00EOF
# M00-Lite: Rapid Market Validation

## 1. Project Metadata & Problem Pitch
- **Project Codename**: SigTest
- **Target User**: Micro-retail owners
- **Core Pain**: stock discrepancies
- **Proposed Solution**: offline cashier
- **Proposed Price Point**: Rp 99000 / month
- **Validation Lead**: S. Rahma
- **Date**: 2026-10-12

## 2. Riskiest Assumption Register (RAT)
| ID | Core Hypothesis | Risk Level | Evidence Needed | Cheap Test Method | Kill Threshold | Outcome |
|:---|:---|:---:|:---|:---|:---|:---:|
| **ASM-01** | users lose money | HIGH | 3/5 confirm | Deep interviews | <2 respondents | ✅ |

## 3. Quick Competitor & Alternative Check
| Solution Name | Type | Price | Strengths | Weaknesses | Differentiator |
|:---|:---|:---|:---|:---|:---|
| Toko | Direct | Rp 200k | Brand | Offline broken | Offline-first |

## 4. Real User Interviews (INT-0x)
| ID | Name | Role | Date | Status |
|:---|:---|:---|:---|:---|
| INT-01 | A | owner | 2026-10-01 | ✅ Real |
| INT-02 | B | owner | 2026-10-02 | ✅ Real |
| INT-03 | C | owner | 2026-10-03 | ✅ Real |

## 5. Quantitative Validation Thresholds
- **Total Unique Visitors**: 140
- **Total Waitlist / Email Signups**: ${pct%.*}0
- **Waitlist-Conversion-Pct**: $pct
- **Intent-to-Buy-Pct**: $intent
Alternative-Proof: deposits:$dep loi:$loi

Validated-by: S. Rahma on 2026-10-12

Gate-Decision: $declared
M00EOF
    local out got
    out="$(cd "$dir" && bash "$GATE" M00 2>&1 || true)"
    got=$(printf '%s' "$out" | sed -n 's/.*Aggregated verdict from signals:.*-> \([A-Z]*\).*/\1/p' | head -1)
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (aggregated -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (aggregated -> ${got:-<none>}, expected $want)"
        FAIL=$((FAIL + 1))
    fi
    rm -rf "$dir"
}
# The combination a founder actually hits: weak waitlist, real deposit interest.
expect_m00_signal "M00 waitlist KILL + deposits RETEST aggregates to RETEST" 1.5 10 2 0 RETEST RETEST
expect_m00_signal "M00 any PASS signal closes the gate" 1.5 35 0 0 PASS PASS
expect_m00_signal "M00 all signals KILL aggregates to KILL" 1.0 5 0 0 KILL KILL

# Positive direction where the gate needs more than one artifact. M02 reconciles
# Scope-P0-Count against the counted Must-Have rows, so the count is derived from
# the shipped template rather than guessed — the check this pins is that a
# template-faithful document passes, not that a hand-written one does.
# expect_gate_scaffold <gate> <label> <want>   (uses INTAKE_MEDIUM + templates)
expect_gate_scaffold() {
    local gate="$1" label="$2" want="$3"
    local dir="$WORK/scaf-$gate"
    make_project "$dir" "$INTAKE_MEDIUM"
    case "$gate" in
        M02)
            # The shipped template is a form: fill the lock, the count (which must equal
            # the counted Must rows), and add Must rows to reach the Medium band (6-15).
            cp "$REPO/templates/01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md" "$dir/docs/pm/SCOPE_STATEMENT.md"
            local scope="$dir/docs/pm/SCOPE_STATEMENT.md"
            sed -i 's/^Scope-P0-Count: \[number\]/Scope-P0-Count: 7/; s/^Scope-Lock-Decision: PENDING/Scope-Lock-Decision: LOCKED/' "$scope"
            sed -i 's/\[Project Name\]/Acme/g; s/\[Client Company\]/Acme Corp/g; s/\[Your Name\]/S. Rahma/g; s/\[YYYY-MM-DD\]/2026-10-12/g' "$scope"
            # Nested brackets need two passes; M02 rejects any remaining [...].
            sed -i -E 's/\[[^][]*\]/X/g' "$scope"
            sed -i -E 's/\[[^][]*\]/X/g' "$scope"
            # Pad to 7 counted Must rows (the template ships fewer than the Medium floor).
            awk 'BEGIN{done=0} /^\| \*\*F-/ {n++} {print} /^$/ && !done && n>0 {print "| **F-901** | Fallback feature A | Must |"; print "| **F-902** | Fallback feature B | Must |"; done=1}' \
                "$scope" > "$scope.tmp" && mv "$scope.tmp" "$scope"
            # Same reasoning for criteria: the fixture pads F-901/F-902 to reach the Medium
            # band, so it must ship a criterion for them or it asserts a scope lock on features
            # with no acceptance test - exactly what the AC binding rule forbids.
            sed -i 's|^# Scope|# Scope\n\nAC-F-901: Given a user, when they use fallback A, then the response is 200 with 0 errors\nAC-F-902: Given an admin, when they use fallback B, then the record is created and listed|' "$scope" 2>/dev/null || true
            mkdir -p "$dir/docs/governance"
            cp "$REPO/templates/03-governance/RACI_MATRIX.md" "$dir/docs/governance/RACI_MATRIX.md"
            cp "$REPO/templates/01-discovery-commercial/COMMUNICATION_PLAN_TEMPLATE.md" "$dir/docs/pm/COMMUNICATION_PLAN.md"
            cp "$REPO/templates/01-discovery-commercial/STAKEHOLDER_MAP_TEMPLATE.md" "$dir/docs/pm/STAKEHOLDER_MAP.md"
            ;;
        M07)
            mkdir -p "$dir/docs/qa"
            cp "$REPO/templates/06-qa-uat/SIT_WORKBOOK_TEMPLATE.md" "$dir/docs/qa/SIT_WORKBOOK.md"
            local wb="$dir/docs/qa/SIT_WORKBOOK.md"
            sed -i 's/\[Project Name\]/Acme/g; s/\[Client Company\]/Acme Corp/g; s/\[Your Name\]/S. Rahma/g; s/\[YYYY-MM-DD\]/2026-10-12/g; s/\[staging URL\]/https:\/\/staging.example.com/g; s/\[client-domain\]/example.com/g' "$wb"
            # Fill the form like a human would: the shipped line is a choose-one menu
            # ("[SIT PASS - READY FOR UAT / NOT READY]"), which is not an attestation.
            sed -i -E 's/^(\s*-\s*\*\*Final Testing Status\*\*:).*/\1 SIT PASS - READY FOR UAT/' "$wb"
            # M07 also requires a security audit artifact with a real attestation.
            cp "$REPO/templates/06-qa-uat/SECURITY_AUDIT_TEMPLATE.md" "$dir/docs/qa/SECURITY_AUDIT.md"
            local sa="$dir/docs/qa/SECURITY_AUDIT.md"
            # A filled audit form: every bracketed prompt replaced with the recorded value,
            # then the attestation checkbox ticked by the human auditor.
            sed -i -E 's/\[[^][]*\]/X/g' "$sa"
            sed -i 's/\[Patched \/ Monitored\]/Patched/g' "$sa" || true
            printf '\n- [x] **SECURITY PASS**: Applicable tests have evidence and findings meet the release policy.\n' >> "$sa"
            # M07 also requires the polish audit and a passing SIT result.
            printf '# Polish Audit\n\nAll 33 tells reviewed. READY (0 blocking tells).\n' > "$dir/docs/qa/POLISH_AUDIT.md"
            # The workbook ships a form; strip every remaining [...] so the placeholder
            # check passes. Do NOT strip the security audit after marking its checkbox —
            # the gate reads "[x] **SECURITY PASS**" as the attestation.
            sed -i -E 's/\[[^][]*\]/X/g' "$wb"
            ;;
        M13)
            printf -- '- **Scale**: solo-saas\n- Delivery: solo\n' > "$dir/docs/pm/PROJECT_STATE.md"
            ;;
    esac
    local out rc got
    out="$(cd "$dir" && bash "$GATE" "$gate" 2>&1)"; rc=$?
    got="ALLOWED"; [ "$rc" -ne 0 ] && got="BLOCKED"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $label  ($gate -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $label  ($gate -> $got/exit $rc, expected $want)"
        printf '%s' "$out" | grep -E "❌" | head -4 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
    rm -rf "$dir"
}

expect_gate M02 "M02 empty project blocks"            "docs/pm/SCOPE_STATEMENT.md" BLOCKED
expect_gate M03 "M03 empty project blocks"            "contracts/SOW_SMB.md" BLOCKED

expect_gate M07 "M07 empty project blocks"            "docs/qa/SIT_WORKBOOK.md" BLOCKED
expect_gate M09 "M09 empty project blocks"            "docs/pm/UAT_SIGNOFF_REPORT.md" BLOCKED
expect_gate M10 "M10 empty project blocks"            "docs/DEPLOYMENT_PROTOCOL.md" BLOCKED
expect_gate M11 "M11 empty project blocks"            "docs/pm/BAST.md" BLOCKED
# M13 is waived for client/portfolio/internal delivery (lifecycle ends at M11/M12),
# so an empty METRICS_BASELINE_REPORT is correctly accepted for this fixture.
expect_gate M13 "M13 waived for client delivery (empty metrics accepted)" "docs/analytics/METRICS_BASELINE_REPORT.md" ALLOWED

# Positive direction for the three gates whose fixture needs more than one stub.
expect_gate_scaffold M02 "M02 accepts the shipped scope + RACI + comms + stakeholders" ALLOWED
expect_gate_scaffold M07 "M07 accepts the shipped SIT workbook with PASS + staging URL" ALLOWED
expect_gate_scaffold M13 "M13 NOT waived for solo-saas: empty metrics blocks" BLOCKED

# M00 FULL path (not the lite path). Its Validated-by extraction at M00.sh:294-300
# is a separate inline regex from check_signoff, so the role denylist had to be
# routed through it separately — and nothing exercised that path until now.
# Four docs at >=1500 bytes, no bracketed tokens (the placeholder grep at :266
# rejects [X]/[Y]/[WTP]/[Your Name]/[YYYY-MM-DD] and friends).
# expect_m00_full <name> <validated-by-name> <want>
expect_m00_full() {
    local name="$1" validator="$2" want="$3"
    local dir="$WORK/m00full"
    # Delivery must NOT be client/portfolio/internal: M00 is WAIVED for those
    # (scope is pre-defined), and a waived gate never reaches the validator check.
    # Nothing else reaches the full path either — it must not be Small (lite) and
    # must not look like M00-LITE.
    make_project "$dir" "- **Scale**: Medium\n- Delivery: solo\n"
    local filler
    filler=$(awk 'BEGIN{for(i=0;i<80;i++) printf "Detailed research prose with substance and no bracket tokens. "}')
    mkdir -p "$dir/docs/pm"
    printf '# MARKET_RESEARCH\n\n%s\n\nSource: https://example.com/report\nVerified: 2026-10-12\n' "$filler" > "$dir/docs/pm/MARKET_RESEARCH.md"
    printf '# COMPETITIVE_LANDSCAPE\n\n%s\n\nTest Date: 2026-10-10\nOnboarding Time: 14 minutes\n' "$filler" > "$dir/docs/pm/COMPETITIVE_LANDSCAPE.md"
    printf '# PRODUCT_STRATEGY\n\n%s\n' "$filler" > "$dir/docs/pm/PRODUCT_STRATEGY.md"
    printf '# USER_RESEARCH_REPORT\n\n%s\n\nGate-Decision: PASS\n\nValidated-by: %s on 2026-10-12\n' "$filler" "$validator" > "$dir/docs/pm/USER_RESEARCH_REPORT.md"
    local out rc got
    out="$(cd "$dir" && bash "$GATE" M00 2>&1)"; rc=$?
    got="ALLOWED"; [ "$rc" -ne 0 ] && got="BLOCKED"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M00 full -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M00 full -> $got/exit $rc, expected $want)"
        printf '%s' "$out" | grep -E "❌" | head -4 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
    rm -rf "$dir"
}
expect_m00_full "M00 full path rejects a role as validator" "Test Lead" BLOCKED
expect_m00_full "M00 full path accepts a named validator" "S. Rahma" ALLOWED

expect_gate A00 "A00 empty project blocks"            "contracts/CONSULTING_AGREEMENT.md" BLOCKED
expect_gate A01 "A01 empty project blocks"            "docs/pm/WBS_PHASING_PLAN.md" BLOCKED
expect_gate A02 "A02 empty project blocks"            "docs/architecture/ENTERPRISE_ARCHITECTURE_BLUEPRINT.md" BLOCKED
expect_gate A03 "A03 empty project blocks"            "docs/procurement/VENDOR_PROCUREMENT_SCHEDULE.md" BLOCKED
expect_gate A04 "A04 empty project blocks"            "docs/governance/GOVERNANCE_HANDOVER_PACK.md" BLOCKED

# Positive direction for the A-series: prove the gate ACCEPTS a filled instance.
# The 13 BLOCKED cases above only prove it rejects an empty one. A02 and A03 each
# require TWO artifacts, so the helper takes a tpl:dest pair list.
# expect_gate_tpl <gate> <label> <want> <tpl:dest> [<tpl:dest>...]
expect_gate_tpl() {
    local gate="$1" label="$2" want="$3"; shift 3
    local dir="$WORK/tpl-$gate"
    make_project "$dir" "$INTAKE_MEDIUM"
    case "$gate" in
        A*) printf -- '- **Scale**: Enterprise\n- Delivery: client\n' > "$dir/docs/pm/PROJECT_STATE.md" ;;
    esac
    local pair tpl dest
    for pair in "$@"; do
        tpl="${pair%%:*}"; dest="${pair#*:}"
        mkdir -p "$dir/$(dirname "$dest")"
        sed -e 's/\[Project Name\]/Acme/g' -e 's/\[Client Company\]/Acme Corp/g' \
            -e 's/\[Your Name\]/S. Rahma/g' -e 's/\[YYYY-MM-DD\]/2026-10-12/g' \
            "$REPO/$tpl" > "$dir/$dest"
    done
    local out rc got
    out="$(cd "$dir" && bash "$GATE" "$gate" 2>&1)"; rc=$?
    got="ALLOWED"; [ "$rc" -ne 0 ] && got="BLOCKED"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $label  ($gate -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $label  ($gate -> $got/exit $rc, expected $want)"
        printf '%s' "$out" | grep -E "❌" | head -4 | sed "s/^/       /"
        FAIL=$((FAIL + 1))
    fi
    rm -rf "$dir"
}

expect_gate_tpl A02 "A02 accepts the shipped blueprint + threat model" ALLOWED \
    templates/03-architecture-specs/ENTERPRISE_ARCHITECTURE_BLUEPRINT_TEMPLATE.md:docs/architecture/ENTERPRISE_ARCHITECTURE_BLUEPRINT.md \
    templates/03-architecture-specs/THREAT_MODEL_STRIDE_TEMPLATE.md:docs/security/THREAT_MODEL_STRIDE.md
expect_gate_tpl A03 "A03 accepts the shipped schedule + comparison matrix" ALLOWED \
    templates/03-governance/VENDOR_PROCUREMENT_SCHEDULE_TEMPLATE.md:docs/procurement/VENDOR_PROCUREMENT_SCHEDULE.md \
    templates/03-governance/VENDOR_COMPARISON_MATRIX.md:docs/governance/VENDOR_COMPARISON_MATRIX.md
expect_gate_tpl A04 "A04 accepts the shipped governance pack" ALLOWED \
    templates/03-governance/GOVERNANCE_HANDOVER_PACK_TEMPLATE.md:docs/governance/GOVERNANCE_HANDOVER_PACK.md
expect_gate_tpl A00 "A00 accepts the shipped consulting agreement" ALLOWED \
    templates/00-pre-sales-enterprise/CONSULTING_AGREEMENT_TEMPLATE.md:contracts/CONSULTING_AGREEMENT.md
expect_gate_tpl A01 "A01 accepts the shipped WBS template" ALLOWED \
    templates/00-pre-sales-enterprise/WBS_PHASING_TEMPLATE.md:docs/pm/WBS_PHASING_PLAN.md

echo ""
if [ "$FAIL" -eq 0 ]; then
    echo -e "${GREEN}All $PASS gate regression tests passed.${NC}"
    exit 0
fi
echo -e "${RED}$FAIL of $((PASS + FAIL)) gate regression tests FAILED.${NC}"
exit 1
