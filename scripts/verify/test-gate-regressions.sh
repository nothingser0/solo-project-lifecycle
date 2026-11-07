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
REPO="$(cd "$SCRIPT_DIR/../.." && pwd)"

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

# expect_m03m12 <name> <PASS|FAIL> <mode:ndamodel|ndahuman|irmissing|irreal>
expect_m03m12() {
    local name="$1" want="$2" mode="$3"
    local dir="$WORK/m03m12"; rm -rf "$dir"; mkdir -p "$dir/docs/pm" "$dir/contracts"
    printf -- '- **Scale**: Large\n- Delivery: client\n- Intake-Status: ANSWERED\n' > "$dir/docs/pm/PROJECT_STATE.md"
    case "$mode" in
        nda*)
            local sign="Sri Wahyuni on 2026-11-05"
            [ "$mode" = "ndamodel" ] && sign="Claude Agent"
            cp "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/templates/00-pre-sales-enterprise/SOW_CONTRACT_TEMPLATE.md" "$dir/contracts/SOW_CONTRACT.md" 2>/dev/null || true
            [ -f "$dir/contracts/SOW_CONTRACT.md" ] || printf '# SOW\n' > "$dir/contracts/SOW_CONTRACT.md"
            printf '# NDA\n\nDisclosing Party: PT Klien Sejahtera\nReceiving Party: Zeenn Studio\n\nSigned by: %s\n' "$sign" > "$dir/contracts/NDA.md"
            ;;
        ir*)
            printf '# Warranty\n\n## Coverage\nx\n## Exclusion\nx\n## Service Level Agreement\nx\n' > "$dir/docs/pm/WARRANTY_POLICY.md"
            if [ "$mode" = "irmissing" ]; then
                printf '# Incident Response\n\nWe will handle incidents when they happen.\n' > "$dir/docs/pm/INCIDENT_RESPONSE.md"
            else
                printf '# Incident Response Plan\n\n## Severity\n| Level | Definition |\n|---|---|\n| SEV1 | All users down |\n\n## Escalation\nOn-call -> tech lead within 15 minutes.\n\n## Response time\nSEV1 acknowledged within 5 minutes.\n\n## Communication\nStatus page every 30 minutes.\n\nOwner: Sri Wahyuni\n' > "$dir/docs/pm/INCIDENT_RESPONSE.md"
            fi
            ;;
    esac
    local out got="PASS"
    out="$(cd "$dir" && bash "$GATE" "$([ "${mode#nda}" != "$mode" ] && echo M03 || echo M12)" 2>&1 || true)"
    case "$mode" in
        ndamodel) echo "$out" | grep -q "names a model as a signing party" && got="FAIL" ;;
        irmissing) echo "$out" | grep -q "missing severity-level detail" && got="FAIL" ;;
        irreal)   echo "$out" | grep -q "missing .*-level detail" && got="FAIL" ;;
        ndahuman) echo "$out" | grep -q "names a model\|no signing party line" && got="FAIL" ;;
    esac
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (m03m12:$mode -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (m03m12:$mode -> $got, expected $want)"
        echo "$out" | grep -iE "model|missing .*-level|signing party" | head -2 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
expect_m03m12 "an NDA signed by a model blocks" FAIL ndamodel
expect_m03m12 "an NDA signed by a human does not raise the signature issue" PASS ndahuman
expect_m03m12 "an incident plan with no severity scale blocks" FAIL irmissing
expect_m03m12 "a real incident plan passes" PASS irreal

# expect_a01a04 <name> <PASS|FAIL> <mode:a01model|a01razor|a01ok|a04tdb|a04dr|a04ok>
expect_a01a04() {
    local name="$1" want="$2" mode="$3"
    local dir="$WORK/a0104"; rm -rf "$dir"; mkdir -p "$dir/docs/pm" "$dir/docs/governance"
    printf -- '- **Scale**: Large\n- Intake-Status: ANSWERED\n' > "$dir/docs/pm/PROJECT_STATE.md"
    case "$mode" in
        a01*)
            local sign="Sri Wahyuni on 2026-11-05" razor='- Loyalty points deferred because no loyalty programme.
- Multi-warehouse moved out because one warehouse until 2027.' rows='| Phase | Package | Price |
|---|---|---|
| 1 | Ordering core | 300000000 |
| 2 | Reporting | 200000000 |'
            [ "$mode" = "a01model" ] && sign="Claude Agent"
            [ "$mode" = "a01razor" ] && razor="Nothing cut."
            cat > "$dir/docs/pm/WBS_PHASING_PLAN.md" <<EOF
# WBS Phasing Plan

## Phasing Strategy
Two phases.

## Phased Package Breakdown
$rows

## Scope Razor
$razor

## Sign-Off
Signed by: $sign
EOF
            ;;
        a04*)
            local owner="Sri Wahyuni" dr="RTO: 4 hours. RPO: 15 minutes."
            [ "$mode" = "a04tdb" ] && owner="TBD"
            [ "$mode" = "a04dr" ] && dr="We have backups."
            cat > "$dir/docs/governance/GOVERNANCE_HANDOVER_PACK.md" <<EOF
# Governance Handover Pack

## RACI
| Activity | Owner | Role |
|---|---|---|
| Release approval | $owner | A |
| Incident triage | Budi | R |
| Change requests | Zeenn | C |

## CAB
Monthly, first Tuesday, quorum 2.

## Disaster Recovery
$dr

Signed by: Sri Wahyuni on 2026-11-05
EOF
            ;;
    esac
    local out got="PASS"
    out="$(cd "$dir" && bash "$GATE" "$(echo "$mode" | cut -c1-3 | tr 'a-z' 'A-Z')" 2>&1 || true)"
    case "$mode" in
        a01model) echo "$out" | grep -q "names a model in the Sign-Off" && got="FAIL" ;;
        a01razor) echo "$out" | grep -q "Scope Razor says nothing is cut" && got="FAIL" ;;
        a04tdb)   echo "$out" | grep -q "assigns a role to TBD/placeholder" && got="FAIL" ;;
        a04dr)    echo "$out" | grep -q "states no RTO" && got="FAIL" ;;
    esac
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (a0104:$mode -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (a0104:$mode -> $got, expected $want)"
        echo "$out" | grep -iE "Sign-Off|Razor|RACI|RTO" | head -2 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
expect_a01a04 "a model signing the phasing plan blocks" FAIL a01model
expect_a01a04 "a scope razor that cuts nothing blocks" FAIL a01razor
expect_a01a04 "a complete phasing plan passes" PASS a01ok
expect_a01a04 "a RACI owner of TBD blocks" FAIL a04tdb
expect_a01a04 "a DR with no RTO blocks" FAIL a04dr
expect_a01a04 "a complete governance pack passes" PASS a04ok

# expect_advisory <name> <PASS|FAIL> <mode:a00model|a00fee|a02stride|a03rows>
expect_advisory() {
    local name="$1" want="$2" mode="$3"
    local dir="$WORK/adv"; rm -rf "$dir"
    mkdir -p "$dir/docs/pm" "$dir/docs/architecture" "$dir/docs/security" "$dir/docs/procurement" "$dir/docs/governance"
    printf -- '- **Scale**: Large\n- Intake-Status: ANSWERED\n' > "$dir/docs/pm/PROJECT_STATE.md"
    case "$mode" in
        a00*)
            local who="Zeenn" fee="IDR 15.000.000 per month"
            [ "$mode" = "a00model" ] && who="Claude Agent"
            [ "$mode" = "a00fee" ] && fee="0"
            cat > "$dir/docs/pm/CONSULTING_AGREEMENT.md" <<EOF
# Consulting Agreement

## Parties
Client: PT Klien
Consultant: $who

## Advisory Deliverables
Architecture review, monthly.

## Professional Fees
Fee: $fee

## Liability
Capped at 2x monthly fee.

Signed by: $who on 2026-11-05
EOF
            ;;
        a02stride)
            printf '# Blueprint\n\n## C4\nx\n## Data Residency\nx\n## Scenario\nx\n' > "$dir/docs/architecture/ENTERPRISE_ARCHITECTURE_BLUEPRINT.md"
            printf '# Threat model\n\n## STRIDE\nnone found\n## Mitigation\nnothing needed\n' > "$dir/docs/security/THREAT_MODEL_STRIDE.md"
            ;;
        a03rows)
            printf '# Schedule\n\n## Procurement Scope\nx\n## Timeline\nx\n## Requirements\nx\n' > "$dir/docs/procurement/VENDOR_PROCUREMENT_SCHEDULE.md"
            printf '# Matrix\n\n## Comparison Framework\nx\n## Decision Matrix\n| Vendor | Score |\n|---|---|\n## Recommendation\nGo with someone.\n' > "$dir/docs/governance/VENDOR_COMPARISON_MATRIX.md"
            ;;
    esac
    local out got="PASS"
    out="$(cd "$dir" && bash "$GATE" "$(echo "$mode" | cut -c1-3 | tr 'a-z' 'A-Z')" 2>&1 || true)"
    case "$mode" in
        a00model) echo "$out" | grep -q "names a model as a signing party" && got="FAIL" ;;
        a00fee)   echo "$out" | grep -q "zero/absent professional fee" && got="FAIL" ;;
        a02stride) echo "$out" | grep -q "fewer than 3 has not been done" && got="FAIL" ;;
        a03rows)  echo "$out" | grep -q "scored row(s)" && got="FAIL" ;;
    esac
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (adv:$mode -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (adv:$mode -> $got, expected $want)"
        echo "$out" | grep -iE "model|fee|STRIDE|scored" | head -2 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
expect_advisory "a model signing the consulting agreement blocks" FAIL a00model
expect_advisory "a zero fee without pro bono blocks" FAIL a00fee
expect_advisory "a STRIDE model with no categories blocks" FAIL a02stride
expect_advisory "a decision matrix with no scored rows blocks" FAIL a03rows

# expect_signatory <name> <PASS|FAIL> <mode:m10model|m10human|m11model|m11same|m11ok>
expect_signatory() {
    local name="$1" want="$2" mode="$3"
    local dir="$WORK/sign"; rm -rf "$dir"; mkdir -p "$dir/docs/pm"
    printf -- '- **Scale**: Medium\n- Intake-Status: ANSWERED\n' > "$dir/docs/pm/PROJECT_STATE.md"
    case "$mode" in
        m10*)
            printf '# Protocol\n\n## Release and Environment\nx\n## Post-Deployment Verification\nx\n## Monitoring and Recovery\nx\n' > "$dir/docs/pm/DEPLOYMENT_PROTOCOL.md"
            local lead="Claude Agent"
            [ "$mode" = "m10human" ] && lead="Sri Wahyuni"
            cat > "$dir/docs/pm/GO_LIVE_REPORT.md" <<EOF
# Go Live Report

## Release and Environment
Environment: production

## Post-Deployment Verification
| ID | Scenario | Result |
|---|---|---|
| PVT-01 | Login works | PASS |

## Monitoring and Recovery
Rollback: previous image tag

Human decision: GO
Release status: LIVE
Lead Engineer: $lead
EOF
            ;;
        m11*)
            local p1="Sri Wahyuni, PT Klien" p2="Zeenn, Studio" s1="Sri Wahyuni" s2="Zeenn"
            case "$mode" in
                m11model) s1="Claude Agent" ;;
                m11same)  p1="Zeenn, Studio"; p2="Zeenn, Studio"; s1="Zeenn"; s2="Zeenn" ;;
            esac
            cat > "$dir/docs/pm/BAST.md" <<EOF
# BAST

## Article 1 Parties
FIRST PARTY: $p1
SECOND PARTY: $p2

## Article 2 Payment
The client confirmed settled all payment in full.

## Article 3 Handover
All deliverables transferred.

## Signatures
Signed by FIRST PARTY: $s1
Date: 2026-11-05
Signed by SECOND PARTY: $s2
Date: 2026-11-05
EOF
            printf '# Manual\n\n## Getting Started\nx\n## Features\nx\n' > "$dir/docs/USER_MANUAL.md"
            ;;
    esac
    local out got="PASS"
    out="$(cd "$dir" && bash "$GATE" "$([ "${mode#m10}" != "$mode" ] && echo M10 || echo M11)" 2>&1 || true)"
    case "$mode" in
        m10model) echo "$out" | grep -q "names a model as Lead Engineer" && got="FAIL" ;;
        m10human) echo "$out" | grep -q "names a model as Lead Engineer" && got="FAIL" ;;
        m11model) echo "$out" | grep -q "names a model as" && got="FAIL" ;;
        m11same)  echo "$out" | grep -q "same party on both sides" && got="FAIL" ;;
        m11ok)    echo "$out" | grep -qE "names a model|same party" && got="FAIL" ;;
    esac
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (sign:$mode -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (sign:$mode -> $got, expected $want)"
        echo "$out" | grep -iE "model|same party" | head -2 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
expect_signatory "a model as Lead Engineer blocks" FAIL m10model
expect_signatory "a human Lead Engineer passes" PASS m10human
expect_signatory "a model signing FIRST PARTY blocks" FAIL m11model
expect_signatory "the same party on both sides blocks" FAIL m11same
expect_signatory "two different humans pass" PASS m11ok

# expect_m06_visual <name> <PASS|FAIL> <src-body> <mode:contrast|font|scale|bare|upload> [fsd]
expect_m06_visual() {
    local name="$1" want="$2" body="$3" mode="$4" fsd="${5:-}"
    local dir="$WORK/m06vis"
    rm -rf "$dir"; mkdir -p "$dir/docs/pm" "$dir/docs/specs" "$dir/docs/design/screens" "$dir/artifacts" "$dir/src"
    printf -- '- **Scale**: Medium\n- Intake-Status: ANSWERED\n' > "$dir/docs/pm/PROJECT_STATE.md"
    printf 'SCR-001 Login\n' > "$dir/docs/specs/SITEMAP.md"
    for f in a b c d; do printf '\x89PNG-%0.s' $(seq 1 200) > "$dir/artifacts/$f.png"; done
    printf '# E\nmigrate down\nCOUNT(\nEXPLAIN\n' > "$dir/artifacts/final-evidence.md"
    printf '# TODO\n- [x] **M06-SETUP-01: s**\n  - **Human Check**: run npm run dev\n  - **Evidence**: `artifacts/a.png` | Approved: 2026-01-01 by Sri\n- [x] **M06-DB-01: s**\n  - **Human Check**: open psql\n  - **Evidence**: `artifacts/b.png` | Approved: 2026-01-01 by Sri\n- [x] **M06-BE-01: s**\n  - **Evidence**: `artifacts/c.png` | Approved: 2026-01-01 by Sri\n- [x] **M06-FE-01: s**\n  - **Human Check**: compare SCR-001\n  - **Evidence**: `artifacts/d.png` | Approved: 2026-01-01 by Sri\n' > "$dir/TODO.md"
    printf '# AGENTS\nThe prototype is the UI source of truth: docs/design/screens/\n' > "$dir/AGENTS.md"
    printf '# CONTEXT\nDecision Log\nKnown issues\n' > "$dir/CONTEXT.md"
    printf '# ARCH\ntopology\nRejected: NestJS because two deploys\n' > "$dir/ARCHITECTURE.md"
    if [ "$mode" = "scale" ]; then
        printf '# DESIGN\n| token | value |\n|---|---|\n| caption | 13px |\n| body | 17px |\n' > "$dir/DESIGN.md"
    else
        printf '# DESIGN\ntokens\n' > "$dir/DESIGN.md"
    fi
    printf '# CONV\nnaming\n' > "$dir/CONVENTIONS.md"
    printf '# RUN\nnpm run dev\nTroubleshooting\nReset to a clean state\n' > "$dir/RUNBOOK_LOCAL.md"
    printf '# VERIFY\ntests\n' > "$dir/VERIFY_LOCAL.md"
    [ -n "$fsd" ] && printf '# FSD\n\n%s\n' "$fsd" > "$dir/docs/specs/FSD.md"
    printf '%b\n' "$body" > "$dir/src/page.tsx"
    local out got="PASS"
    out="$(cd "$dir" && bash "$GATE" M06 2>&1 || true)"
    case "$mode" in
        contrast) echo "$out" | grep -q "contrast below WCAG AA" && got="FAIL" ;;
        font)     echo "$out" | grep -q "font-family used but never loaded" && got="FAIL" ;;
        scale)    echo "$out" | grep -q "not in the DESIGN.md type scale\|defines no px type scale" && got="FAIL" ;;
        bare)     echo "$out" | grep -q "rendered with no className/style" && got="FAIL" ;;
        upload)   echo "$out" | grep -q "specifies a file upload but no file input" && got="FAIL" ;;
    esac
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (visual:$mode -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (visual:$mode -> $got, expected $want)"
        echo "$out" | grep -iE "contrast|font-family|type scale|no className|file upload" | head -2 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
expect_m06_visual "fefefe text on white fails AA" FAIL 'export const A = () => <p style={{ color: "#fefefe", background: "#ffffff" }}>x</p>;' contrast
expect_m06_visual "dark text on white passes AA" PASS 'export const A = () => <p style={{ color: "#111827", background: "#ffffff" }}>x</p>;' contrast
expect_m06_visual "an Inter font-family that is never loaded blocks" FAIL 'export const A = () => <p style={{ fontFamily: "Inter" }}>x</p>;' font
expect_m06_visual "a font size outside the DESIGN.md scale blocks" FAIL 'export const A = () => <p style={{ fontSize: "15px" }}>x</p>;' scale
expect_m06_visual "a size inside the scale passes" PASS 'export const A = () => <p style={{ fontSize: "13px" }}>x</p>;' scale
expect_m06_visual "a bare select blocks" FAIL 'export const A = () => <select><option>a</option></select>;' bare
expect_m06_visual "an FSD upload with no file input blocks" FAIL 'export const A = () => <input type="text" className="x" />;' upload '| FR-01 | Customer uploads a KTP scan (.jpg, .pdf, max 2MB) | file rejected |'
expect_m06_visual "an FSD upload with a file input passes" PASS 'export const A = () => <input type="file" accept="image/*" className="x" />;' upload '| FR-01 | Customer uploads a KTP scan (.jpg, .pdf, max 2MB) | file rejected |'
expect_m06_visual "text-slate-400 on bg-white fails AA (2.56:1)" FAIL 'export const A = () => <p className="text-slate-400 bg-white">x</p>;' contrast
expect_m06_visual "text-gray-300 on bg-gray-100 fails AA (1.34:1)" FAIL 'export const A = () => <p className="text-gray-300 bg-gray-100">x</p>;' contrast
expect_m06_visual "text-slate-900 on bg-white passes AA (17:1)" PASS 'export const A = () => <p className="text-slate-900 bg-white">x</p>;' contrast
expect_m06_visual "text-slate-400/70 on bg-white fails AA (1.86:1)" FAIL 'export const A = () => <p className="text-slate-400/70 bg-white">x</p>;' contrast
expect_m06_visual "text-slate-900/60 on bg-white passes AA (4.69:1)" PASS 'export const A = () => <p className="text-slate-900/60 bg-white">x</p>;' contrast
expect_m06_human() {
    local name="$1" want="$2" body="$3" mode="$4"
    local dir="$WORK/m06h"; rm -rf "$dir"; mkdir -p "$dir/docs/pm" "$dir/docs/specs" "$dir/docs/design/screens" "$dir/artifacts" "$dir/src"
    printf -- '- **Scale**: Medium
- Intake-Status: ANSWERED\n' > "$dir/docs/pm/PROJECT_STATE.md"
    printf 'SCR-001 Login\n' > "$dir/docs/specs/SITEMAP.md"
    for f in a b c d; do printf '\x89PNG-%0.s' $(seq 1 200) > "$dir/artifacts/$f.png"; done
    printf '# E\nmigrate down\nCOUNT(\nEXPLAIN\n' > "$dir/artifacts/final-evidence.md"
    printf '# TODO\n- [x] **M06-SETUP-01: s**\n  - **Human Check**: run npm run dev\n  - **Evidence**: `artifacts/a.png` | Approved: 2026-01-01 by Sri\n- [x] **M06-DB-01: s**\n  - **Human Check**: open psql\n  - **Evidence**: `artifacts/b.png` | Approved: 2026-01-01 by Sri\n- [x] **M06-BE-01: s**\n  - **Evidence**: `artifacts/c.png` | Approved: 2026-01-01 by Sri\n- [x] **M06-FE-01: s**\n  - **Human Check**: compare SCR-001\n  - **Evidence**: `artifacts/d.png` | Approved: 2026-01-01 by Sri\n' > "$dir/TODO.md"
    printf '# AGENTS\nThe prototype is the UI source of truth: docs/design/screens/\n' > "$dir/AGENTS.md"
    printf '# CONTEXT\nDecision Log\nKnown issues\n' > "$dir/CONTEXT.md"
    printf '# ARCH\ntopology\nRejected: NestJS because two deploys\n' > "$dir/ARCHITECTURE.md"
    printf '# DESIGN\ntokens\n' > "$dir/DESIGN.md"
    printf '# CONV\nnaming\n' > "$dir/CONVENTIONS.md"
    printf '# RUN\nnpm run dev\nTroubleshooting\nReset to a clean state\n' > "$dir/RUNBOOK_LOCAL.md"
    printf '%b\n' "$body" > "$dir/VERIFY_LOCAL.md"
    printf 'export const A = () => <p className="text-slate-900 bg-white">x</p>;\n' > "$dir/src/a.tsx"
    local out got="PASS"
    out="$(cd "$dir" && bash "$GATE" M06 2>&1 || true)"
    echo "$out" | grep -q "lists no human-only checks\|does not cover both runtime contrast" && got="FAIL"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (human:$mode -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (human:$mode -> $got, expected $want)"
        echo "$out" | grep -iE "human-only|runtime contrast" | head -2 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
expect_m06_human "a VERIFY_LOCAL with no human-only checks blocks" FAIL '# Verify
tests pass' a
expect_m06_human "human-only checks without an interactive step block" FAIL '# Verify

## Human-only checks
DevTools computed style for runtime contrast.' b
expect_m06_human "human-only checks covering both pass" PASS '# Verify

## Human-only checks
DevTools computed style for runtime contrast.
Open every dropdown and popover.' c

# expect_m06_slop <name> <PASS|FAIL> <src-file-body> <mode:emoji|comment|todo>
# The anti-slop checks that were measuring the wrong thing: an emoji range that skipped
# U+2600-U+26FF, and a comment pattern that only matched thirteen capitalised phrases.
expect_m06_slop() {
    local name="$1" want="$2" body="$3" mode="$4"
    local dir="$WORK/m06sl"
    rm -rf "$dir"; mkdir -p "$dir/docs/pm" "$dir/docs/specs" "$dir/docs/design/screens" "$dir/artifacts" "$dir/src"
    printf -- '- **Scale**: Medium\n- Intake-Status: ANSWERED\n' > "$dir/docs/pm/PROJECT_STATE.md"
    printf 'SCR-001 Login\n' > "$dir/docs/specs/SITEMAP.md"
    for f in a b c d; do printf '\x89PNG-%0.s' $(seq 1 200) > "$dir/artifacts/$f.png"; done
    printf '# E\nmigrate down\nCOUNT(\nEXPLAIN\n' > "$dir/artifacts/final-evidence.md"
    printf '# TODO\n- [x] **M06-SETUP-01: s**\n  - **Human Check**: run npm run dev\n  - **Evidence**: `artifacts/a.png` | Approved: 2026-01-01 by Sri\n- [x] **M06-DB-01: s**\n  - **Human Check**: open psql\n  - **Evidence**: `artifacts/b.png` | Approved: 2026-01-01 by Sri\n- [x] **M06-BE-01: s**\n  - **Evidence**: `artifacts/c.png` | Approved: 2026-01-01 by Sri\n- [x] **M06-FE-01: s**\n  - **Human Check**: compare SCR-001\n  - **Evidence**: `artifacts/d.png` | Approved: 2026-01-01 by Sri\n' > "$dir/TODO.md"
    printf '# AGENTS\nThe prototype is the UI source of truth: docs/design/screens/\n' > "$dir/AGENTS.md"
    printf '# CONTEXT\nDecision Log\nKnown issues\n' > "$dir/CONTEXT.md"
    printf '# ARCH\ntopology\nRejected: NestJS because two deploys\n' > "$dir/ARCHITECTURE.md"
    printf '# DESIGN\ntokens #3b82f6\n' > "$dir/DESIGN.md"
    printf '# CONV\nnaming\n' > "$dir/CONVENTIONS.md"
    printf '# RUN\nnpm run dev\nTroubleshooting\nReset to a clean state\n' > "$dir/RUNBOOK_LOCAL.md"
    printf '# VERIFY\ntests\n' > "$dir/VERIFY_LOCAL.md"
    printf '%b\n' "$body" > "$dir/src/page.tsx"
    local out got="PASS"
    out="$(cd "$dir" && bash "$GATE" M06 2>&1 || true)"
    case "$mode" in
        emoji)   echo "$out" | grep -q "raw emoji / emoticon" && got="FAIL" ;;
        comment) echo "$out" | grep -q "narrating / redundant comment" && got="FAIL" ;;
        todo)    echo "$out" | grep -q "placeholder TODO stub" && got="FAIL" ;;
    esac
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (slop:$mode -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (slop:$mode -> $got, expected $want)"
        echo "$out" | grep -iE "emoji|comment|TODO stub" | head -2 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
expect_m06_slop "lightning and gear emoji are caught" FAIL 'export const A = () => <b>\xe2\x9a\xa1 \xe2\x9a\x99</b>;' emoji
expect_m06_slop "warning sign emoji is caught" FAIL 'export const B = () => <b>\xe2\x9a\xa0</b>;' emoji
expect_m06_slop "banner-and-lowercase comments block" FAIL '// ============================\n// increment the counter\nexport const c = 1;' comment
expect_m06_slop "shouted comment blocks" FAIL '// THIS IS THE LOGIN PAGE OK\nexport const d = 1;' comment
expect_m06_slop "TODO left in source blocks" FAIL '// TODO: add validation later\nexport const e = 1;' todo
expect_m06_slop "a why-comment is allowed" PASS '// Retry once because the payment provider times out on cold start.\nexport const f = 1;' comment

# expect_m08_m09 <name> <PASS|FAIL> <mode:m08map|m08rows|m09model|m09incomplete> <body>
expect_m08_m09() {
    local name="$1" want="$2" mode="$3" body="$4"
    local dir="$WORK/m0809"
    rm -rf "$dir"; mkdir -p "$dir/docs/pm" "$dir/docs/specs" "$dir/docs/qa"
    printf -- '- **Scale**: Medium\n- Intake-Status: ANSWERED\n' > "$dir/docs/pm/PROJECT_STATE.md"
    printf '# FSD\n\nCREATE TABLE customers (id uuid);\nCREATE TABLE invoices (id uuid);\n' > "$dir/docs/specs/FSD.md"
    case "$mode" in
        m08map|m08rows)
            printf '# Plan\n\n## Data Hygiene\nx\n## Mapping Matrix\n%b\n## Masking Protocol\nx\nInputs-Received: yes\n' \
                "$([ "$mode" = m08map ] && printf 'generic column mapping\n' || printf '| customers.name | customers.name |\n| invoices.total | invoices.total |\n')" \
                > "$dir/docs/pm/DATA_MIGRATION_PLAN.md"
            printf '# Recon\nStatus: RECONCILED\n%b\n' "$body" > "$dir/docs/pm/MIGRATION_RECONCILIATION_REPORT.md"
            ;;
        m09model|m09incomplete)
            printf '# UAT\n\n### Requirement / AC ID\n### Evidence\n\n%b\n' "$body" > "$dir/docs/qa/UAT_WORKBOOK.md"
            printf '# Report\n\n### Sign-Off Metadata\n### Testing Summary\n### Acceptance & Release Decision\n\n%b\nStatus: SIGNED\n' "$body" > "$dir/docs/pm/UAT_SIGNOFF_REPORT.md"
            ;;
    esac
    local out got="PASS"
    out="$(cd "$dir" && bash "$GATE" "$([ "${mode#m08}" != "$mode" ] && echo M08 || echo M09)" 2>&1 || true)"
    case "$mode" in
        m08map)  echo "$out" | grep -q "never mentions these schema table" && got="FAIL" ;;
        m08rows) echo "$out" | grep -q "states no row counts" && got="FAIL" ;;
        m09model) echo "$out" | grep -q "names a model as the client signatory" && got="FAIL" ;;
        m09incomplete) echo "$out" | grep -q "sign-off is incomplete" && got="FAIL" ;;
    esac
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (${mode} -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (${mode} -> $got, expected $want)"
        echo "$out" | grep -E "never mentions|row counts|model|incomplete" | head -2 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
expect_m08_m09 "migration plan that maps no schema table blocks" FAIL m08map 'All tables passed.'
expect_m08_m09 "reconciliation without row counts blocks" FAIL m08rows 'All tables passed.'
expect_m08_m09 "migration plan + counted reconciliation passes" PASS m08rows '| Table | Source rows | Loaded rows | Matched |
|---|---|---|---|
| customers | 100 | 100 | 100 |
| invoices | 40 | 40 | 40 |'
expect_m08_m09 "model signing the client UAT blocks" FAIL m09model 'Client Single PIC: Claude Agent
Signature: Claude Agent
Date: 2026-11-05
Signed via: meeting'
expect_m08_m09 "UAT signature without a channel blocks" FAIL m09incomplete 'Client Single PIC: Sri Wahyuni
Signature: Sri Wahyuni'
expect_m08_m09 "human client sign-off with channel passes" PASS m09incomplete 'Client Single PIC: Sri Wahyuni
Signature: Sri Wahyuni
Date: 2026-11-05
Signed via: meeting'

# expect_m06_harness <name> <PASS|FAIL> <mode:runbook|context|arch>
# A harness file that exists only to clear a size floor is decoration; each must carry the
# section the person opening it came for.
expect_m06_harness() {
    local name="$1" want="$2" mode="$3"
    local dir="$WORK/m06hs"
    rm -rf "$dir"; mkdir -p "$dir/docs/pm" "$dir/docs/specs" "$dir/docs/design/screens" "$dir/artifacts" "$dir/src"
    printf -- '- **Scale**: Medium\n- Intake-Status: ANSWERED\n' > "$dir/docs/pm/PROJECT_STATE.md"
    printf '\x89PNG-%0.s' $(seq 1 200) > "$dir/artifacts/a.png"
    printf 'SCR-001 Login\n' > "$dir/docs/specs/SITEMAP.md"
    printf '# E\nmigrate down\nCOUNT(\nEXPLAIN\n' > "$dir/artifacts/final-evidence.md"
    printf '# TODO\n- [x] **M06-SETUP-01: s**\n  - **Human Check**: run npm run dev\n  - **Evidence**: `artifacts/a.png` | Approved: 2026-01-01 by Sri\n- [x] **M06-DB-01: s**\n  - **Human Check**: open psql\n  - **Evidence**: `artifacts/a.png` | Approved: 2026-01-01 by Sri\n- [x] **M06-BE-01: s**\n  - **Evidence**: `artifacts/a.png` | Approved: 2026-01-01 by Sri\n- [x] **M06-FE-01: s**\n  - **Human Check**: compare SCR-001\n  - **Evidence**: `artifacts/a.png` | Approved: 2026-01-01 by Sri\n' > "$dir/TODO.md"
    printf '# AGENTS\nThe prototype is the UI source of truth: docs/design/screens/\n' > "$dir/AGENTS.md"
    printf '# CONTEXT\nproduct summary\nDecision Log\nKnown issues\n' > "$dir/CONTEXT.md"
    printf '# ARCHITECTURE\ntopology\nRejected: NestJS because two deploys\n' > "$dir/ARCHITECTURE.md"
    printf '# DESIGN\ntokens\n' > "$dir/DESIGN.md"
    printf '# CONVENTIONS\nnaming\n' > "$dir/CONVENTIONS.md"
    printf '# RUNBOOK\nTroubleshooting\nReset to a clean state\n' > "$dir/RUNBOOK_LOCAL.md"
    printf '# VERIFY\ntests\n' > "$dir/VERIFY_LOCAL.md"
    case "$mode" in
        runbook) printf '# RUNBOOK\nnpm run dev\n' > "$dir/RUNBOOK_LOCAL.md" ;;
        context) printf '# CONTEXT\nproduct summary\n' > "$dir/CONTEXT.md" ;;
        arch)    printf '# ARCHITECTURE\ntopology\n' > "$dir/ARCHITECTURE.md" ;;
    esac
    local out got="PASS"
    out="$(cd "$dir" && bash "$GATE" M06 2>&1 || true)"
    echo "$out" | grep -q "missing the section they exist for" && got="FAIL"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M06 harness -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M06 harness -> $got, expected $want)"
        echo "$out" | grep -E "missing the section" | head -2 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
expect_m06_harness "runbook without troubleshooting blocks" FAIL runbook
expect_m06_harness "context without a decision log blocks" FAIL context
expect_m06_harness "architecture with no rejected alternative blocks" FAIL arch

# expect_m07_sit <name> <PASS|FAIL> <workbook-rows>
# M07 signs the system off, so a workbook that skips requirements must not pass.
expect_m07_sit() {
    local name="$1" want="$2" rows="$3"
    local dir="$WORK/m07sit"
    rm -rf "$dir"; mkdir -p "$dir/docs/qa" "$dir/docs/pm" "$dir/docs/specs"
    printf -- '- **Scale**: Medium\n- Intake-Status: ANSWERED\n' > "$dir/docs/pm/PROJECT_STATE.md"
    printf 'SCR-001 Login\nSCR-002 Dashboard\n' > "$dir/docs/specs/SITEMAP.md"
    printf '| REQ-01 | F-01 |\n| REQ-02 | F-02 |\n' > "$dir/docs/specs/PRD.md"
    {
      printf '# SIT Workbook\n\nPART I: SIT TEST PLAN\nPART II: SIT REPORT\nThird-Party Integration\n'
      printf 'Load & Concurrency Test\nCore Web Vitals\nNative Mobile QA\nSign-Off\nDocument Metadata\n'
      printf 'Scope\nEnvironment\n\nStaging-URL: https://staging.example.test\nFinal Testing Status: SIT PASS\n\n'
      printf '| ID | Scenario | Expected | Actual | Status |\n|---|---|---|---|---|\n'
      printf '%b\n' "$rows"
    } > "$dir/docs/qa/SIT_WORKBOOK.md"
    local out got="PASS"
    out="$(cd "$dir" && bash "$GATE" M07 2>&1 || true)"
    echo "$out" | grep -qE "never tests|no negative/edge scenario" && got="FAIL"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M07 sit -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M07 sit -> $got, expected $want)"
        echo "$out" | grep -E "never tests|negative/edge|SIT covers" | head -2 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
expect_m07_sit "SIT attesting PASS while skipping requirements blocks" FAIL '| TC-01 | login works | dashboard | ok | PASS |'
expect_m07_sit "SIT covering everything but only happy paths blocks" FAIL '| TC-01 | REQ-01 SCR-001 login | ok | ok | PASS |\n| TC-02 | REQ-02 SCR-002 totals | ok | ok | PASS |'
expect_m07_sit "SIT with full coverage and a rejected-input row passes" PASS '| TC-01 | REQ-01 SCR-001 login | ok | ok | PASS |\n| TC-02 | REQ-02 SCR-002 totals | ok | ok | PASS |\n| TC-03 | REQ-01 wrong password rejected | error | ok | PASS |'

# expect_m06_int <name> <PASS|FAIL> <todo-extra> <fsd-body>
expect_m06_int() {
    local name="$1" want="$2" extra="$3" fsd="${4:-Payment gateway: Midtrans, webhook settlement callbacks.}"
    local dir="$WORK/m06int"
    rm -rf "$dir"; mkdir -p "$dir/docs/harness-root" "$dir/docs/specs" "$dir/artifacts"
    for f in a b c d; do printf '\x89PNG-%0.s' $(seq 1 200) > "$dir/artifacts/$f.png"; done
    printf '# FSD\n\n## Integrations\n\n%b\n' "$fsd" > "$dir/docs/specs/FSD.md"
    printf '# E\nmigrate down\nCOUNT(\nEXPLAIN\n' > "$dir/artifacts/final-evidence.md"
    {
      printf '# TODO\n\n'
      printf -- '- [x] **M06-SETUP-01: scaffold**\n  - **Evidence**: `artifacts/a.png`\n  - Approved: 2026-01-01 by Sri Wahyuni\n'
      printf -- '- [x] **M06-DB-01: schema**\n  - **Evidence**: `artifacts/b.png`\n  - Approved: 2026-01-01 by Sri Wahyuni\n'
      printf -- '- [x] **M06-BE-01: api**\n  - **Evidence**: `artifacts/c.png`\n  - Approved: 2026-01-01 by Sri Wahyuni\n'
      printf -- '- [x] **M06-FE-01: screens**\n  - **Evidence**: `artifacts/d.png`\n  - Approved: 2026-01-01 by Sri Wahyuni\n'
      printf '%b\n' "$extra"
    } > "$dir/docs/harness-root/TODO.md"
    local out got="PASS"
    out="$(cd "$dir" && bash "$GATE" M06 2>&1 || true)"
    echo "$out" | grep -q "no M06-INT-xx task" && got="FAIL"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M06 int -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M06 int -> $got, expected $want)"
        echo "$out" | grep -E "M06-INT|Integration wire" | head -2 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
expect_m06_int "declared integration with no M06-INT task blocks" FAIL ''
expect_m06_int "M06-INT task satisfies a declared integration" PASS '- [x] **M06-INT-01: Midtrans webhook**\n  - **Evidence**: `artifacts/a.png`\n  - Approved: 2026-01-01 by Sri Wahyuni'
expect_m06_int "integration marked N/A with a reason passes" PASS '- M06-INT: N/A - payment collected offline by bank transfer'
expect_m06_int "no declared integration needs no INT task" PASS '' 'No external services; everything is in-house.'

# expect_m06_cross <name> <PASS|FAIL> <mode:port|dbtarget> <fixture-shape>
# The two cross-module rules M06 was missing: a frozen prototype nobody ported, and a DB probe
# that ran against a different server than the app.
expect_m06_cross() {
    local name="$1" want="$2" mode="$3" src="$4" dsnenv="$5" evidence="$6"
    local dir="$WORK/m06cx"
    rm -rf "$dir"; mkdir -p "$dir/docs/harness-root" "$dir/docs/specs" "$dir/docs/design/screens" "$dir/artifacts" "$dir/src"
    printf '\x89PNG-%0.s' $(seq 1 200) > "$dir/artifacts/a.png"
    cp "$dir/artifacts/a.png" "$dir/artifacts/b.png"
    cp "$dir/artifacts/a.png" "$dir/artifacts/c.png"
    cp "$dir/artifacts/a.png" "$dir/artifacts/d.png"
    printf 'SCR-001 Login\nSCR-002 Dashboard\n' > "$dir/docs/specs/SITEMAP.md"
    printf '%b' "$dsnenv" > "$dir/.env"
    printf '%b' "$evidence" > "$dir/artifacts/final-evidence.md"
    printf '%b' "$src" > "$dir/src/pages.tsx"
    printf '# TODO\n\n- [x] **M06-SETUP-01: scaffold**\n  - **Evidence**: `artifacts/a.png`\n  - Approved: 2026-01-01 by Sri Wahyuni\n- [x] **M06-DB-01: schema**\n  - **Evidence**: `artifacts/b.png`\n  - Approved: 2026-01-01 by Sri Wahyuni\n- [x] **M06-BE-01: api**\n  - **Evidence**: `artifacts/c.png`\n  - Approved: 2026-01-01 by Sri Wahyuni\n- [x] **M06-FE-01: screens**\n  - **Evidence**: `artifacts/d.png`\n  - Approved: 2026-01-01 by Sri Wahyuni\n- [x] **M06-FE-02: dashboard**\n  - **Evidence**: `artifacts/a.png`\n  - Approved: 2026-01-01 by Sri Wahyuni\n' > "$dir/docs/harness-root/TODO.md"
    local out got="PASS"
    out="$(cd "$dir" && bash "$GATE" M06 2>&1 || true)"
    case "$mode" in
        port)     echo "$out" | grep -q "never references these frozen prototype" && got="FAIL" ;;
        dbtarget) echo "$out" | grep -q "never name the configured database target" && got="FAIL" ;;
    esac
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M06 $mode -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M06 $mode -> $got, expected $want)"
        echo "$out" | grep -E "prototype|database target" | head -3 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
M06_EV_OK='migrate down\nCOUNT(\nEXPLAIN\nagainst neon.tech\n'
M06_EV_LOCAL='migrate down\nCOUNT(\nEXPLAIN\nran on localhost\n'
M06_ENV_NEON='DATABASE_URL=postgresql://u:p@ep-cool.neon.tech/app\n'
M06_SRC_PORTED='/* SCR-001 SCR-002 */\n'
expect_m06_cross "source that never ports the frozen screens blocks" FAIL port "$(printf '/* nothing */')" "$M06_ENV_NEON" "$M06_EV_OK"
expect_m06_cross "ported source passes" PASS port "$M06_SRC_PORTED" "$M06_ENV_NEON" "$M06_EV_OK"
expect_m06_cross "DB probe on localhost while the app uses Neon blocks" FAIL dbtarget "$M06_SRC_PORTED" "$M06_ENV_NEON" "$M06_EV_LOCAL"
expect_m06_cross "DB probe naming the configured target passes" PASS dbtarget "$M06_SRC_PORTED" "$M06_ENV_NEON" "$M06_EV_OK"

# expect_m06_todo <name> <PASS|FAIL> <todo-tail-after-header>
# M06 trusts TODO.md, so the two ways a tick lies are worth pinning: a model approving it,
# and one artefact standing in for several unrelated tasks.
expect_m06_todo() {
    local name="$1" want="$2" body="$3"
    local dir="$WORK/m06td"
    rm -rf "$dir"; mkdir -p "$dir/docs/harness-root" "$dir/artifacts"
    printf '\x89PNG-%0.s' $(seq 1 200) > "$dir/artifacts/db.png"
    cp "$dir/artifacts/db.png" "$dir/artifacts/api.png"
    cp "$dir/artifacts/db.png" "$dir/artifacts/ui.png"
    cp "$dir/artifacts/db.png" "$dir/artifacts/setup.png"
    printf '# TODO\n\n%b\n' "$body" > "$dir/docs/harness-root/TODO.md"
    local out got="PASS"
    out="$(cd "$dir" && bash "$GATE" M06 2>&1 || true)"
    echo "$out" | grep -qE "approved by a model|one evidence path is cited" && got="FAIL"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M06 todo -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M06 todo -> $got, expected $want)"
        echo "$out" | grep -E "approval|evidence path|model" | head -3 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
M06_T=('- [x] **M06-SETUP-01: scaffold**\n  - **Evidence**: `artifacts/setup.png`\n  - Approved: 2026-01-01 by Sri Wahyuni\n')
M06_T+=('- [x] **M06-DB-01: schema**\n  - **Evidence**: `artifacts/db.png`\n  - Approved: 2026-01-01 by Sri Wahyuni\n')
M06_T+=('- [x] **M06-BE-01: api**\n  - **Evidence**: `artifacts/api.png`\n  - Approved: 2026-01-01 by Sri Wahyuni\n')
M06_T+=('- [x] **M06-FE-01: screens**\n  - **Evidence**: `artifacts/ui.png`\n  - Approved: 2026-01-01 by Sri Wahyuni\n')
expect_m06_todo "model approval of a task blocks" FAIL "- [x] **M06-SETUP-01: scaffold**\n  - **Evidence**: \`artifacts/setup.png\`\n  - Approved: 2026-01-01 by Claude Agent\n- [x] **M06-DB-01: schema**\n  - **Evidence**: \`artifacts/db.png\`\n  - Approved: 2026-01-01 by Sri Wahyuni\n- [x] **M06-BE-01: api**\n  - **Evidence**: \`artifacts/api.png\`\n  - Approved: 2026-01-01 by Sri Wahyuni\n- [x] **M06-FE-01: screens**\n  - **Evidence**: \`artifacts/ui.png\`\n  - Approved: 2026-01-01 by Sri Wahyuni\n"
expect_m06_todo "one artefact reused across categories blocks" FAIL "- [x] **M06-SETUP-01: scaffold**\n  - **Evidence**: \`artifacts/setup.png\`\n  - Approved: 2026-01-01 by Sri Wahyuni\n- [x] **M06-DB-01: schema**\n  - **Evidence**: \`artifacts/ui.png\`\n  - Approved: 2026-01-01 by Sri Wahyuni\n- [x] **M06-BE-01: api**\n  - **Evidence**: \`artifacts/api.png\`\n  - Approved: 2026-01-01 by Sri Wahyuni\n- [x] **M06-FE-01: screens**\n  - **Evidence**: \`artifacts/ui.png\`\n  - Approved: 2026-01-01 by Sri Wahyuni\n"
expect_m06_todo "human-approved distinct evidence passes" PASS "- [x] **M06-SETUP-01: scaffold**\n  - **Evidence**: \`artifacts/setup.png\`\n  - Approved: 2026-01-01 by Sri Wahyuni\n- [x] **M06-DB-01: schema**\n  - **Evidence**: \`artifacts/db.png\`\n  - Approved: 2026-01-01 by Sri Wahyuni\n- [x] **M06-BE-01: api**\n  - **Evidence**: \`artifacts/api.png\`\n  - Approved: 2026-01-01 by Sri Wahyuni\n- [x] **M06-FE-01: screens**\n  - **Evidence**: \`artifacts/ui.png\`\n  - Approved: 2026-01-01 by Sri Wahyuni\n"

# expect_m05_schema <name> <PASS|FAIL> <fsd-tail>
# Assert the ERD/DDL cross-check and the rejected-alternative rule on their own.
expect_m05_schema() {
    local name="$1" want="$2" tail="$3"
    local dir="$WORK/m05sc"
    rm -rf "$dir"; mkdir -p "$dir/docs/specs"
    printf '# FSD\n\n%b\n\nApproved by: Sri Wahyuni\nApproved on: 2026-11-05\n' "$tail" > "$dir/docs/specs/FSD.md"
    local out got="PASS"
    out="$(cd "$dir" && bash "$GATE" M05 2>&1 || true)"
    echo "$out" | grep -qE "missing from the ERD|never created by the DDL|no rejected alternative|without a reason" && got="FAIL"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M05 schema -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M05 schema -> $got, expected $want)"
        echo "$out" | grep -E "ERD|Table|Rejected|rejected" | head -3 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
M05_ERD_AGREE='```mermaid\nerDiagram\n    orders {\n        uuid id\n    }\n```\nCREATE TABLE orders (id uuid);\nCREATE INDEX idx_orders ON orders(id);\nStack Decision LOCKED: Next.js  Rejected: Laravel because the team already ships React'
expect_m05_schema "ERD that omits a DDL table blocks" FAIL '```mermaid\nerDiagram\n    orders {\n        uuid id\n    }\n```\nCREATE TABLE orders (id uuid);\nCREATE TABLE invoices (id uuid);\nCREATE INDEX idx_orders ON orders(id);\nStack Decision LOCKED: Next.js  Rejected: Laravel because the team already ships React'
expect_m05_schema "ERD describing a table no DDL creates blocks" FAIL '```mermaid\nerDiagram\n    purchase {\n        uuid id\n    }\n```\nCREATE TABLE orders (id uuid);\nCREATE INDEX idx_orders ON orders(id);\nStack Decision LOCKED: Next.js  Rejected: Laravel because the team already ships React'
expect_m05_schema "locked stack with no rejected alternative blocks" FAIL '```mermaid\nerDiagram\n    orders {\n        uuid id\n    }\n```\nCREATE TABLE orders (id uuid);\nCREATE INDEX idx_orders ON orders(id);\nStack Decision LOCKED: Next.js'
expect_m05_schema "rejected alternative with no reason blocks" FAIL '```mermaid\nerDiagram\n    orders {\n        uuid id\n    }\n```\nCREATE TABLE orders (id uuid);\nCREATE INDEX idx_orders ON orders(id);\nStack Decision LOCKED: Next.js  Rejected: Laravel'
expect_m05_schema "ERD matching DDL with a justified stack passes" PASS "$M05_ERD_AGREE"

# expect_m05_chain <name> <PASS|FAIL> <prd-body> [scope-body] [sitemap-body]
# M05's job is the traceability chain, so these cases assert the chain and nothing else.
expect_m05_chain() {
    local name="$1" want="$2" prd="$3" scope="${4:-}" sitemap="${5:-}"
    local dir="$WORK/m05ch"
    rm -rf "$dir"; mkdir -p "$dir/docs/specs" "$dir/docs/pm"
    printf '%b' "$prd" > "$dir/docs/specs/PRD.md"
    printf '# FSD\n\n## Technical Sign-Off\n\nApproved by: Sri Wahyuni\nApproved on: 2026-11-05\n' > "$dir/docs/specs/FSD.md"
    [ -n "$scope" ] && printf '%b' "$scope" > "$dir/docs/pm/SCOPE_STATEMENT.md"
    [ -n "$sitemap" ] && printf '%b' "$sitemap" > "$dir/docs/specs/SITEMAP.md"
    local out got="PASS"
    out="$(cd "$dir" && bash "$GATE" M05 2>&1 || true)"
    echo "$out" | grep -qE "no requirement mapping|no feature behind them|no traceability matrix|never approved|no BDD scenarios|scenario\(s\) name no REQ|no requirement mentions" && got="FAIL"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M05 chain -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M05 chain -> $got, expected $want)"
        echo "$out" | grep -E "traceability|scope|BDD|SITEMAP" | head -4 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
M05_HDR='# PRD\n\n## Document Metadata\nv1\n\n## Functional Traceability Matrix\n\n'
M05_SCEN='\n\nScenario: sign in\nGiven a registered user\nWhen they submit valid credentials\nThen they reach the dashboard\nREQ-01\n'
expect_m05_chain "feature with no requirement blocks" FAIL "$M05_HDR"'| F-01 | login |\n'"$M05_SCEN"
expect_m05_chain "requirement with no feature blocks" FAIL "$M05_HDR"'| REQ-01 | login |\n'"$M05_SCEN"
expect_m05_chain "feature outside the M02 scope blocks" FAIL "$M05_HDR"'| REQ-01 | F-99 |\n'"$M05_SCEN" '| F-01 | auth |\n'
expect_m05_chain "prose with Given/When/Then is not a scenario" FAIL "$M05_HDR"'| REQ-01 | F-01 |\n\nGiven the pressure When the market Then whoever\n' '| F-01 | auth |\n'
expect_m05_chain "SITEMAP screen no requirement mentions blocks" FAIL "$M05_HDR"'| REQ-01 | F-01 |\n'"$M05_SCEN" '| F-01 | auth |\n' 'SCR-001 Login\nSCR-002 Dashboard\n'
expect_m05_chain "fully traceable spec passes" PASS "$M05_HDR"'| REQ-01 | F-01 | SCR-001 |\n'"$M05_SCEN"

# expect_m05_signoff <name> <PASS|FAIL> <sed-ish python to break the fixture>
# The sign-off block is where a template placeholder most easily passes as a signature, so these
# cases break one field at a time in an otherwise complete FSD.
expect_m05_signoff() {  # <name> <PASS|FAIL> <python body> [expected-message-regex]
    local name="$1" want="$2" body="$3" expect_msg="${4:-}"
    local dir="$WORK/m05sig" fix="$REPO/scripts/verify/fixtures/m05-spec/repo"
    rm -rf "$dir"; cp -r "$fix" "$dir"        # a repo the gate already accepts
    python3 - "$dir/docs/specs/FSD.md" "$dir/docs/specs/PRD.md" <<PY
import io, re, sys
p, prd = sys.argv[1], sys.argv[2]
s = io.open(p, encoding="utf-8").read()
p = prd
$body
io.open(sys.argv[1], "w", encoding="utf-8").write(s)
PY
    local out rc
    out="$(cd "$dir" && bash "$GATE" M05 2>&1)"; rc=$?
    local got="PASS"; [ "$rc" -ne 0 ] && got="FAIL"
    local ok=0 cause=0
    [ "$got" = "$want" ] && ok=1
    # a FAIL only counts when it fails for the reason under test
    if [ "$want" = "FAIL" ] && [ -n "$expect_msg" ]; then
        echo "$out" | grep -qE "$expect_msg" && cause=1
    else
        cause=1
    fi
    if [ "$ok" = 1 ] && [ "$cause" = 1 ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M05 sign-off -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M05 sign-off -> $got, expected $want${expect_msg:+, message /$expect_msg/})"
        echo "$out" | grep -E "❌" | head -3 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}

expect_m05_signoff "the object-storage row is a paragraph, as the template writes it" PASS 's = s'
expect_m05_signoff "the template's own rejected-alternative instruction is not a reason" FAIL \
    's = re.sub(r"(?m)^Rejected: .*$", "Rejected: <the runner-up> because <why it lost>", s)' \
    "rejected alternative is the template"
expect_m05_signoff "an agent is never the technical approver" FAIL \
    's = re.sub(r"(?m)^\*\*Approved by\*\*:.*$", "**Approved by**: Claude Agent", s)' \
    "approver is not a human"
expect_m05_signoff "the reviewer placeholder is not a signature" FAIL \
    's = re.sub(r"(?m)^\*\*Approved by\*\*:.*$", "**Approved by**: [Human reviewer name]", s)' \
    "technical approver is still the template placeholder"
expect_m05_signoff "a placeholder sign-off date blocks" FAIL \
    's = re.sub(r"(?m)^\*\*Approved on\*\*:.*$", "**Approved on**: YYYY-MM-DD", s)' \
    "sign-off date"

# expect_m04_route <name> <PASS|FAIL> <sitemap-ids> <files-to-create> <stray-colour?>
# Isolates the SCR-xx -> screen mapping and the token-colour rule.
setup_m04() {
    local dir="$1" html="${2:-}"
    rm -rf "$dir"; mkdir -p "$dir/docs/pm" "$dir/docs/specs" "$dir/docs/design/screens" "$dir/docs/design/brand" "$dir/docs/design/inspiration"
    printf '%b' "$INTAKE_MEDIUM" > "$dir/docs/pm/PROJECT_STATE.md"
    printf '%b' "$html" > "$dir/docs/design/screens/SCR-003.html"
    # everything M04 needs that is not under test
    printf 'SCR-003 admin invoices\n%s\n' "$(printf 'sitemap detail row. %.0s' $(seq 1 120))" > "$dir/docs/specs/SITEMAP.md"
    printf '# DESIGN_SPEC\n\nPrototyping: Interactive Code Prototype\nDefault Loading Empty Error Success\n\n## Motion & Interaction\ntransition 150ms, active scale 0.98\n%s\n' \
        "$(printf 'screen rows and state matrix detail. %.0s' $(seq 1 100))" > "$dir/docs/specs/DESIGN_SPEC.md"
    mkdir -p "$dir/docs/design/shared/css"
    printf 'body{margin:0;font-family:system-ui}\n' > "$dir/docs/design/shared/css/styles.css"
    printf '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64"><circle cx="32" cy="32" r="30" fill="#3b82f6"/></svg>\n' > "$dir/docs/design/brand/favicon.svg"
    printf '# Components\n\n## Primitives & Atomic\nbutton input\n## Composites\ncard form\n## Accessibility WCAG AA\ncontrast 4.5:1\n%s\n' \
        "$(printf 'component inventory detail. %.0s' $(seq 1 60))" > "$dir/docs/specs/COMPONENT_REQUIREMENTS.md"
    printf '# Logo brief\n\nmonogram mark with brand accent and clear space rules defined\n' > "$dir/docs/specs/LOGO_DESIGN_BRIEF.md"
    printf '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" role="img" aria-label="Acme mark"><title>Acme</title><circle cx="32" cy="32" r="28" fill="#3b82f6"/><path d="M20 40 L32 20 L44 40 Z" fill="#ffffff"/><rect x="18" y="44" width="28" height="4" fill="#ffffff"/></svg>\n' > "$dir/docs/design/brand/logo.svg"
    printf '# inspiration notes\n\nWinning benchmark: ref.png (Linear), because of its density and neutral palette.\n%s\n' \
        "$(printf 'observation detail. %.0s' $(seq 1 60))" > "$dir/docs/design/inspiration/notes.md"
    printf 'reference screenshot placeholder supplied by the human\n' > "$dir/docs/design/inspiration/ref.png"
    printf 'sources:\n  - docs/design/inspiration/notes.md\n\nEvidence & Inference Log: tokens marked observed or inferred\n\n## Anti-Slop\nZero emoticons, zero glassmorphism, restrained shadows, one icon set.\n\nTypography scale and Spacing scale defined here.\nContrast 4.5:1 and 7.0:1 recorded. z-index base 0 toast 60.\n%s\n' \
        "$(printf 'design token detail. %.0s' $(seq 1 60))" > "$dir/DESIGN.md"
    mkdir -p "$dir/docs/design/components" "$dir/docs/specs/wireflows"
    
}

expect_m04_route() {
    local name="$1" want="$2" ids="$3" files="$4" stray="${5:-}"
    local dir="$WORK/m04rt"
    # START FROM THE PASSING M04 FIXTURE: this test targets two rules and nothing else, so
    # rebuilding the whole prerequisite stack here would assert unrelated checks.
    rm -rf "$dir"; mkdir -p "$dir"
    setup_m04 "$dir"
    # setup_m04 ships one SCR-003 screen; these cases re-cut the map, so start from an empty screen dir
    rm -f "$dir"/docs/design/screens/*.html
    printf 'SCR-001 Login screen with an email field and a submit button for the operator\nSCR-002 Dashboard screen with totals and a table of recent invoices for review\n' > "$dir/docs/specs/SITEMAP.md"
    printf 'body{color:#3b82f6}\n' > "$dir/docs/design/shared/css/styles.css"
    printf '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64"><circle cx="32" cy="32" r="30" fill="#3b82f6"/></svg>\n' > "$dir/docs/design/brand/favicon.svg"
    for f in $files; do
        printf '<!doctype html><html lang="id"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width"><link rel="stylesheet" href="../shared/css/styles.css"><link rel="icon" href="../brand/favicon.svg"><title>%s</title></head><body><main><p style="color:%s">%s</p></main></body></html>\n' \
            "$f" "${stray:-#3b82f6}" "$(printf 'Screen words that clear the hollow floor comfortably. %.0s' $(seq 1 40))" > "$dir/docs/design/screens/$f.html"
    done
    local out got="PASS"
    out="$(cd "$dir" && bash "$GATE" M04 2>&1 || true)"
    echo "$out" | grep -qE "no file and no data-screen section|Colours used in the prototype but absent" && got="FAIL"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (route/token -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (route/token -> $got, expected $want)"
        FAIL=$((FAIL + 1))
    fi
}
expect_m04_route "SITEMAP screen with no file blocks" FAIL "x" "SCR-001"
expect_m04_route "every SITEMAP screen mapped passes" PASS "x" "SCR-001 SCR-002"
expect_m04_route "prototype colour outside the tokens blocks" FAIL "x" "SCR-001 SCR-002" "#ff00aa"

# expect_m04_freeze <name> <PASS|FAIL> <freeze-block>
# A Design Freeze approved by the model is not an approval: the runbook says so and the gate
# used to accept any name, plus a sign-off with no channel at all.
expect_m04_freeze() {
    local name="$1" want="$2" block="$3"
    local dir="$WORK/m04fz"
    rm -rf "$dir"; mkdir -p "$dir/docs/specs"
    printf '# DESIGN_SPEC\n\nPrototyping: Interactive Code Prototype\nDefault Loading Empty Error Success\n\n## Motion & Interaction\nspring\n\n%b\n' "$block" > "$dir/docs/specs/DESIGN_SPEC.md"
    local out got="PASS"
    out="$(cd "$dir" && bash "$GATE" M04 2>&1 || true)"
    echo "$out" | grep -qE "approver is not a human|missing the approval channel" && got="FAIL"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (freeze -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (freeze -> $got, expected $want)"
        FAIL=$((FAIL + 1))
    fi
}
expect_m04_freeze "agent cannot approve the design freeze" FAIL '- Approved by: Claude Agent\n- Approved on: 2026-11-05\n- Approved via: chat\n'
expect_m04_freeze "sign-off without a channel is rejected" FAIL '- Approved by: Sri Wahyuni\n- Approved on: 2026-11-05\n'
expect_m04_freeze "human with name, date and channel passes" PASS '- Approved by: Sri Wahyuni\n- Approved on: 2026-11-05\n- Approved via: WhatsApp\n'

# expect_m04_screen <name> <PASS|FAIL> <screen-html>
# Builds the minimum M04 project and varies only the prototype screen content.

expect_m04_screen() {
    local name="$1" want="$2" html="$3" variant="${4:-}"
    local dir="$WORK/m04scr"
    setup_m04 "$dir" "$html"
    case "$variant" in
        no-showcase)     : ;;
        hollow-showcase) printf '<!doctype html><html><body>\n' > "$dir/docs/design/components/index.html" ;;
        broken-asset)
            printf '<!doctype html><html><head><meta name="viewport" content="width=device-width"><link rel="stylesheet" href="../shared/css/missing.css"></head><body><main><p>%s</p></main></body></html>\n' \
                "$(printf 'Screen words that clear the hollow floor comfortably. %.0s' $(seq 1 40))" > "$dir/docs/design/screens/SCR-003.html" ;;
        two-sheets)
            printf '<!doctype html><html lang="id"><head><meta name="viewport" content="width=device-width"><link rel="stylesheet" href="../shared/css/a.css"></head><body><main><p>%s</p></main></body></html>\n' \
                "$(printf 'Screen words that clear the hollow floor. %.0s' $(seq 1 40))" > "$dir/docs/design/screens/SCR-003.html"
            printf '<!doctype html><html lang="id"><head><meta name="viewport" content="width=device-width"><link rel="stylesheet" href="../shared/css/b.css"></head><body><main><p>%s</p></main></body></html>\n' \
                "$(printf 'Screen words that clear the hollow floor. %.0s' $(seq 1 40))" > "$dir/docs/design/screens/SCR-004.html" ;;
        inline-style)
            printf '<!doctype html><html lang="id"><head><meta name="viewport" content="width=device-width"><link rel="stylesheet" href="../shared/css/styles.css"><style>.x{color:red}</style></head><body><main><p>%s</p></main></body></html>\n' \
                "$(printf 'Screen words that clear the hollow floor. %.0s' $(seq 1 40))" > "$dir/docs/design/screens/SCR-003.html" ;;
        no-alt)
            printf '<!doctype html><html lang="id"><head><meta name="viewport" content="width=device-width"><link rel="stylesheet" href="../shared/css/styles.css"></head><body><main><img src="x.png"><p>%s</p></main></body></html>\n' \
                "$(printf 'Screen words that clear the hollow floor. %.0s' $(seq 1 40))" > "$dir/docs/design/screens/SCR-003.html" ;;
        no-favicon)
            rm -f "$dir/docs/design/brand/favicon.svg" ;;
        no-title)
            printf '<!doctype html><html lang="id"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width"><link rel="stylesheet" href="../shared/css/styles.css"><link rel="icon" href="../../brand/favicon.svg"></head><body><main><p>%s</p></main></body></html>\n' \
                "$(printf 'Screen words that clear the hollow floor. %.0s' $(seq 1 40))" > "$dir/docs/design/screens/SCR-003.html" ;;
        dup-title)
            printf '<!doctype html><html lang="id"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width"><link rel="stylesheet" href="../shared/css/styles.css"><link rel="icon" href="../../brand/favicon.svg"><title>Same</title></head><body><main><p>%s</p></main></body></html>\n' \
                "$(printf 'Screen words that clear the hollow floor. %.0s' $(seq 1 40))" > "$dir/docs/design/screens/SCR-003.html"
            printf '<!doctype html><html lang="id"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width"><link rel="stylesheet" href="../shared/css/styles.css"><link rel="icon" href="../../brand/favicon.svg"><title>Same</title></head><body><main><p>%s</p></main></body></html>\n' \
                "$(printf 'Screen words that clear the hollow floor. %.0s' $(seq 1 40))" > "$dir/docs/design/screens/SCR-004.html" ;;
        icon-404)
            printf '<!doctype html><html lang="id"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width"><link rel="stylesheet" href="../shared/css/styles.css"><link rel="icon" href="../../brand/nope.svg"><title>Invoices</title></head><body><main><p>%s</p></main></body></html>\n' \
                "$(printf 'Screen words that clear the hollow floor. %.0s' $(seq 1 40))" > "$dir/docs/design/screens/SCR-003.html" ;;
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
    echo "$out" | grep -qE "different stylesheets|per-page <style> block|Accessibility defect|No screen links a stylesheet|screen\(s\) link the shared stylesheet" && got="FAIL"
    echo "$out" | grep -qE "<head> incomplete|Favicon missing|Favicon (TOO SMALL|is not parseable)|is not parseable SVG" && got="FAIL"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M04 hollow -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M04 hollow -> $got, expected $want)"
        FAIL=$((FAIL + 1))
    fi
}
expect_m04_screen "missing favicon blocks" FAIL '<!doctype html><html lang="id"><head><meta charset="utf-8"><title>T</title></head><body><main>PLACEHOLDER</main></body></html>' no-favicon
expect_m04_screen "screen without <title> blocks" FAIL '<!doctype html><html lang="id"><body><main>PLACEHOLDER</main></body></html>' no-title
expect_m04_screen "duplicate <title> across screens blocks" FAIL '<!doctype html><html lang="id"><body><main>PLACEHOLDER</main></body></html>' dup-title
expect_m04_screen "favicon link that 404s blocks" FAIL '<!doctype html><html lang="id"><body><main>PLACEHOLDER</main></body></html>' icon-404
expect_m04_screen "two different stylesheets across screens block" FAIL '<!doctype html><html lang="id"><body><main>PLACEHOLDER</main></body></html>' two-sheets
expect_m04_screen "per-page <style> block blocks" FAIL '<!doctype html><html lang="id"><body><main>PLACEHOLDER</main></body></html>' inline-style
expect_m04_screen "img without alt blocks" FAIL '<!doctype html><html lang="id"><body><main>PLACEHOLDER</main></body></html>' no-alt
expect_m04_screen "stylesheet that resolves to nothing blocks" FAIL '<!doctype html><html><body><main>PLACEHOLDER</main></body></html>' broken-asset
expect_m04_screen "body with no elements is not a screen" FAIL '<!doctype html><html><body><main>PLACEHOLDER</main></body></html>' word-only
expect_m04_screen "component showcase missing blocks" FAIL '<!doctype html><html><body><main>PLACEHOLDER</main></body></html>' no-showcase
expect_m04_screen "hollow component showcase blocks" FAIL '<!doctype html><html><body><main>PLACEHOLDER</main></body></html>' hollow-showcase
expect_m04_screen "zero wireflow runbooks block" FAIL '<!doctype html><html><body><main>PLACEHOLDER</main></body></html>' no-wireflow
# the same fixture, but with a showcase + wireflow, must pass the new checks
expect_m04_screen "empty 0-byte .html is not a prototype" FAIL ''
expect_m04_screen "real markup screen passes the hollow check" PASS "<!doctype html><html lang=\"id\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><link rel=\"stylesheet\" href=\"../shared/css/styles.css\"><link rel=\"icon\" href=\"../brand/favicon.svg\"><title>Invoices</title></head><body data-roles=\"admin\"><main><h1>Invoices</h1><p>$(printf 'Invoice rows for the current month with totals and status per row. %.0s' $(seq 1 40))</p></main></body></html>
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
    printf '# NDA\n\nDisclosing Party: PT Klien\nReceiving Party: Zeenn\n\nSigned by: Sri Wahyuni on 2026-11-05\n\n%s\n' "$(printf 'Mutual confidentiality obligations apply to both parties. %.0s' $(seq 1 20))" > "$dir/contracts/NDA.md"
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

# The complete fixture is the shipped SOW. A model must not be able to sign it, and a signature
# with no date must not count - the gate only asked whether the name was blank.
expect_m03_fixture() {
    local name="$1" want="$2" kind="$3"
    local dir="$WORK/m03fix"
    rm -rf "$dir"; cp -r "$REPO/scripts/verify/fixtures/m03-sow" "$dir"
    local sow="$dir/contracts/SOW_CONTRACT.md"
    case "$kind" in
        thin)   python3 "$REPO/scripts/verify/fixtures/m03-sow/thin.py" "$sow" >/dev/null ;;
        model)
            python3 - "$sow" <<'PYM'
import io, re, sys
p = sys.argv[1]; s = io.open(p, encoding="utf-8").read()
s = re.sub(r"(?m)^Name:[ \t]*Wahyu[^\n]*$", "Name: Claude Agent", s, count=1)
s = re.sub(r"(?m)^Signature:[ \t]*Wahyu[^\n]*$", "Signature: /s/ Claude Agent", s, count=1)
io.open(p, "w", encoding="utf-8").write(s)
PYM
            ;;
        nodate)
            python3 - "$sow" <<'PYD'
import io, re, sys
p = sys.argv[1]; s = io.open(p, encoding="utf-8").read()
s = re.sub(r"(?m)^Date:[ \t]*2026-11-06[^\n]*$", "Date:", s, count=1)
io.open(p, "w", encoding="utf-8").write(s)
PYD
            ;;
    esac
    local out got="FAIL"
    out="$(cd "$dir" && bash "$GATE" M03 2>&1 || true)"
    echo "$out" | grep -q "Gate validation PASSED" && got="PASS"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (SOW -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (SOW -> $got, expected $want)"
        echo "$out" | grep -E "❌" | head -2 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
if [ -d "$REPO/scripts/verify/fixtures/m03-sow" ]; then
    expect_m03_fixture "the complete shipped SOW passes" PASS clean
    expect_m03_fixture "a one-line liability clause blocks" FAIL thin
    expect_m03_fixture "a model signing the SOW blocks" FAIL model
    expect_m03_fixture "a signature with no date blocks" FAIL nodate

# M03: an unbounded promise passed. "guaranteed completely bug-free forever", "unlimited lifetime
# support" and "unlimited liability for any and all damages" all reached M04 as signed terms.
expect_m03_promise() {
    local name="$1" want="$2" mode="$3"
    local dir="$WORK/m03prom"
    rm -rf "$dir"; cp -r "$REPO/scripts/verify/fixtures/m03-sow" "$dir"
    [ "$mode" = "none" ] || python3 "$REPO/scripts/verify/fixtures/m03-sow/promise.py" "$dir/contracts/SOW_CONTRACT.md" "$mode" >/dev/null
    local out got="FAIL"
    out="$(cd "$dir" && bash "$GATE" M03 2>&1 || true)"
    echo "$out" | grep -q "Gate validation PASSED" && got="PASS"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (promise -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (promise -> $got, expected $want)"
        echo "$out" | grep -E "without a bound|no duration" | head -1 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
expect_m03_promise "a bounded warranty and a capped liability pass" PASS none
expect_m03_promise "'guaranteed completely bug-free forever' blocks" FAIL bugfree
expect_m03_promise "'unlimited lifetime support' blocks" FAIL support
expect_m03_promise "'unlimited liability for any and all damages' blocks" FAIL liability
else
    echo -e "  ${YELLOW}-${NC} M03 fixture regressions skipped: m03-sow missing"
fi

# M04: contrast was a shape test ("anything:1"), a bare input had no label, and min-width: 0
# with overflow hidden collapsed a badge. All three passed a design handover.
expect_m04_defect() {
    local name="$1" want="$2" kind="$3"
    local dir="$WORK/m04def"
    rm -rf "$dir"; cp -r "$REPO/scripts/verify/fixtures/m04-design" "$dir"
    case "$kind" in
        contrast)  printf '\n- Body text contrast: 2.1:1\n' >> "$dir/DESIGN.md" ;;
        label)     python3 "$REPO/scripts/verify/fixtures/m04-design/add-input.py" "$dir/docs/design/screens/scr-01.html" ;;
        collapse)  printf '\n.badge { min-width: 0; overflow: hidden; }\n' >> "$dir/docs/design/screens/style.css" ;;
    esac
    local out got="FAIL"
    out="$(cd "$dir" && bash "$GATE" M04 2>&1 || true)"
    echo "$out" | grep -q "Gate validation PASSED" && got="PASS"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M04 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M04 -> $got, expected $want)"
        echo "$out" | grep -E "contrast|unlabelled|collapses" | head -1 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
if [ -d "$REPO/scripts/verify/fixtures/m04-design" ]; then
    expect_m04_defect "a clean design handover passes" PASS clean
    expect_m04_defect "a 2.1:1 text contrast claim blocks" FAIL contrast
    expect_m04_defect "an input with only a placeholder blocks" FAIL label
    expect_m04_defect "min-width: 0 with overflow hidden blocks" FAIL collapse
else
    echo -e "  ${YELLOW}-${NC} M04 defect regressions skipped: fixture missing"
fi

# Nine defects M04 already detects, each one a browser-visible fault. They are regressions so a
# later edit to the gate cannot lose a check without failing the suite.
expect_m04_visual() {
    local name="$1" want="$2" kind="$3"
    local dir="$WORK/m04vis"
    rm -rf "$dir"; cp -r "$REPO/scripts/verify/fixtures/m04-design" "$dir"
    case "$kind" in
        svg-text)     python3 "$REPO/scripts/verify/fixtures/m04-design/mutate.py" "$dir" svg-text ;;
        svg-tiny)     python3 "$REPO/scripts/verify/fixtures/m04-design/mutate.py" "$dir" svg-tiny ;;
        spec-leak)    python3 "$REPO/scripts/verify/fixtures/m04-design/mutate.py" "$dir" spec-leak ;;
        sitemap)      python3 "$REPO/scripts/verify/fixtures/m04-design/mutate.py" "$dir" sitemap ;;
        stray-color)  python3 "$REPO/scripts/verify/fixtures/m04-design/mutate.py" "$dir" stray-color ;;
        no-charset)   python3 "$REPO/scripts/verify/fixtures/m04-design/mutate.py" "$dir" no-charset ;;
        no-alt)       python3 "$REPO/scripts/verify/fixtures/m04-design/mutate.py" "$dir" no-alt ;;
        hollow)       python3 "$REPO/scripts/verify/fixtures/m04-design/mutate.py" "$dir" hollow ;;
        page-style)   python3 "$REPO/scripts/verify/fixtures/m04-design/mutate.py" "$dir" page-style ;;
    esac
    local out got="FAIL"
    out="$(cd "$dir" && bash "$GATE" M04 2>&1 || true)"
    echo "$out" | grep -q "Gate validation PASSED" && got="PASS"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M04 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M04 -> $got, expected $want)"
        echo "$out" | grep -E "❌" | head -1 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
if [ -d "$REPO/scripts/verify/fixtures/m04-design" ]; then
    expect_m04_visual "a logo drawn with <text> blocks (fonts differ per machine)" FAIL svg-text
    expect_m04_visual "a 169-byte logo placeholder blocks" FAIL svg-tiny
    expect_m04_visual "a SCR-xx code leaking into the UI blocks" FAIL spec-leak
    expect_m04_visual "a SITEMAP promising screens with no file blocks" FAIL sitemap
    expect_m04_visual "a colour outside the design tokens blocks" FAIL stray-color
    expect_m04_visual "a screen with no charset blocks" FAIL no-charset
    expect_m04_visual "an image with no alt blocks" FAIL no-alt
    expect_m04_visual "a hollow screen blocks" FAIL hollow
    expect_m04_visual "a per-page <style> block blocks" FAIL page-style
else
    echo -e "  ${YELLOW}-${NC} M04 visual regressions skipped: fixture missing"
fi

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
printf '%b' '# PROJECT_LITE\n\nCREATE TABLE users (id uuid);\nGET /api/users\nPOST /api/users\n- **Feature**: login\n\nStack Decision LOCKED: Next.js  Rejected: Laravel because the team already ships React\n' > "$WORK/pl_noq.md"
printf '%b' '# PROJECT_LITE\n\nCREATE TABLE users (id uuid);\nGET /api/users\nPOST /api/users\n- **Feature**: login\n\nStack Decision LOCKED: Next.js  Rejected: Laravel because the team already ships React\nStack-Locked-by: S. Rahma\n\n- Q1 Team Expertise: x\n- Q2 Database Experience: x\n- Q3 Deployment Topology: x\n- Q4 Expected Scale (Year 1): x\n- Q5 Data Model Characteristics: x\n- Q6 DevOps Complexity Tolerance: x\n- Q7 Critical Feature Priority: x\n- Q8 Compliance Requirements: x\n' > "$WORK/pl_8q.md"

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
        printf -- 'Stack Decision LOCKED: FastAPI  Rejected: Next.js because the workload is batch-heavy\nStack-Locked-by: S. Rahma\n'
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
        printf -- 'Stack Decision LOCKED: Next.js  Rejected: Laravel because the team already ships React\nStack-Locked-by: S. Rahma\n'
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
    sed 's|^Stack Decision LOCKED: \[Next.js / Laravel / Django / Go / SvelteKit / FastAPI\]|Stack Decision LOCKED: Next.js  Rejected: Laravel because the team already ships React|' \
        "$REPO/templates/03-architecture-specs/PROJECT_LITE_TEMPLATE.md" > "$1/PROJECT_LITE.md"
}
build_no_security() {
    { printf '# PROJECT_LITE\n\nCREATE TABLE users (id uuid);\nGET /api/users\nPOST /api/users\nStack Decision LOCKED: Next.js  Rejected: Laravel because the team already ships React\nStack-Locked-by: S. Rahma\n'; printf '%b' "$ANSWERED_Q8$HANDOFF_OK$SIGNOFF_OK"; } > "$1/PROJECT_LITE.md"
}
build_no_handoff() {
    { printf '# PROJECT_LITE\n\nCREATE TABLE users (id uuid);\nGET /api/users\nPOST /api/users\nStack Decision LOCKED: Next.js  Rejected: Laravel because the team already ships React\nStack-Locked-by: S. Rahma\n'; printf '%b' "$ANSWERED_Q8$SECURITY_OK$SIGNOFF_OK"; } > "$1/PROJECT_LITE.md"
}
build_blank_signoff() {
    { printf '# PROJECT_LITE\n\nCREATE TABLE users (id uuid);\nGET /api/users\nPOST /api/users\nStack Decision LOCKED: Next.js  Rejected: Laravel because the team already ships React\nStack-Locked-by: S. Rahma\n'; printf '%b' "$ANSWERED_Q8$SECURITY_OK$HANDOFF_OK"; printf '**Approved by**: _________________________\n**Approved on**: [YYYY-MM-DD]\n'; } > "$1/PROJECT_LITE.md"
}
build_all_ok() {
    { printf '# PROJECT_LITE\n\nCREATE TABLE users (id uuid);\nGET /api/users\nPOST /api/users\nStack Decision LOCKED: Next.js  Rejected: Laravel because the team already ships React\nStack-Locked-by: S. Rahma\n'; printf '%b' "$ANSWERED_Q8$SECURITY_OK$HANDOFF_OK$SIGNOFF_OK"; } > "$1/PROJECT_LITE.md"
}
# A role word satisfies "a leading letter" but is not a named human. Both approver
# checks (stack lock and technical sign-off) must reject it, or the rule is vacuous.
build_role_approver() { # $1 = target dir, $2 = role string
    local dir="$1" role="$2"
    { printf '# PROJECT_LITE\n\nCREATE TABLE users (id uuid);\nGET /api/users\nPOST /api/users\nStack Decision LOCKED: Next.js  Rejected: Laravel because the team already ships React\nStack-Locked-by: %s\n' "$role"; printf '%b' "$ANSWERED_Q8$SECURITY_OK$HANDOFF_OK"; printf '**Approved by**: %s\n**Approved on**: 2026-10-12\n**Validated by Solo Developer**: %s (Date: 2026-10-12)\n' "$role" "$role"; } > "$dir/PROJECT_LITE.md"
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
M01_CHECKBOX='# Brief\n\n- [ ] **GO**\n- [x] **CONDITIONAL_GO**\n- [ ] **PIVOT**\n- [ ] **KILL**\n\nFeasibility-Score-Technical: 4.0\nFeasibility-Score-Operational: 4.0\nFeasibility-Score-Regulatory: 4.0\nFeasibility-Score-Financial: 4.0\n\nMitigation: ship an online-first MVP to five pilot shops before the full build\n'
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
    # A plan must define severity, escalation, response time and comms; a document with the
    # headings and no content is exactly what the incident gate now rejects.
    [ "$create" = "yes" ] && printf '# Incident Response\n\n## Severity\n| Level | Definition |\n|---|---|\n| SEV1 | All users down |\n\n## Escalation\nOn-call -> tech lead within 15 minutes.\n\n## Response time\nSEV1 acknowledged within 5 minutes.\n\n## Comms\nStatus page every 30 minutes.\n\nOwner: Sri Wahyuni\n' > "$dir/docs/pm/INCIDENT_RESPONSE.md"
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

FSD_OK_LOCK='Stack Decision LOCKED: Next.js 15  Rejected: Laravel because the team already ships React\n\n## Module 04 Handoff Strategy\nCompatibility Level: 2\n'
FSD_NO_LOCK='## 2. Component Architecture\n\nORM / Driver: Drizzle\n'
FSD_NO_HANDOFF='Stack Decision LOCKED: Next.js 15  Rejected: Laravel because the team already ships React\n\n## 3. Database Schema\n'

expect_m06_step "FSD with no locked stack" BLOCKED "$FSD_NO_LOCK" yes
expect_m06_step "FSD with no Module 04 Handoff Strategy" BLOCKED "$FSD_NO_HANDOFF" yes
expect_m06_step "FSD locked + handoff, only 3 of 9 harness files" BLOCKED "$FSD_OK_LOCK" no
expect_m06_step "FSD locked + handoff, all 9 harness files" ALLOWED "$FSD_OK_LOCK" yes

# expect_m06_source <name> <PASS|FAIL> <expected-❌-message|""> <python body>
# Builds on the complete M06 fixture, so a PASS means the gate really is green.
expect_m06_source() {
    local name="$1" want="$2" msg="$3" body="$4"
    local fix="$REPO/scripts/verify/fixtures/m06/repo" dir="$WORK/m06src"
    if [ ! -d "$fix" ]; then
        echo -e "  ${RED}✗${NC} $name  (fixture missing: $fix)"
        FAIL=$((FAIL + 1)); return
    fi
    rm -rf "$dir"; cp -r "$fix" "$dir"
    python3 - "$dir" <<PY
import io, os, sys
root = sys.argv[1]
$body
PY
    local out rc got=PASS
    out="$(cd "$dir" && bash "$GATE" M06 2>&1)"; rc=$?
    [ "$rc" -ne 0 ] && got="FAIL"
    local cause=1
    if [ "$want" = "FAIL" ] && [ -n "$msg" ]; then
        printf '%s\n' "$out" | grep -E '^[[:space:]]*❌' | grep -F -q -- "$msg" || cause=0
    fi
    if [ "$got" = "$want" ] && [ "$cause" = 1 ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M06 source -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M06 source -> $got, expected $want${msg:+, message /$msg/})"
        printf '%s\n' "$out" | grep -E '^[[:space:]]*❌' | head -3 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}

expect_m06_source "a credential inside a connection URI blocks" FAIL "hardcoded secret" '
os.makedirs(os.path.join(root, "src/lib"), exist_ok=True)
io.open(os.path.join(root, "src/lib/db-uri.ts"), "w", encoding="utf-8").write(
    "import postgres from \"postgres\";\n"
    "export const sql = postgres(\"postgres://admin:Sup3rS3cret@db.internal:5432/kasir\");\n")
'
expect_m06_source "an env-driven connection URI passes" PASS "" '
os.makedirs(os.path.join(root, "src/lib"), exist_ok=True)
io.open(os.path.join(root, "src/lib/db-uri.ts"), "w", encoding="utf-8").write(
    "import postgres from \"postgres\";\n"
    "export const sql = postgres(process.env.DATABASE_URL);\n")
'
expect_m06_source "a popover requirement with only SQL select blocks" FAIL "popover/combobox but no such component" '
p = os.path.join(root, "docs/specs/FSD.md")
s = io.open(p, encoding="utf-8").read()
io.open(p, "w", encoding="utf-8").write(
    s + "\n\n## Filters\n\nThe orders screen uses a popover filter for the customer column.\n")
'
expect_m06_source "a popover requirement served by <Select> passes" PASS "" '
p = os.path.join(root, "docs/specs/FSD.md")
s = io.open(p, encoding="utf-8").read()
io.open(p, "w", encoding="utf-8").write(
    s + "\n\n## Filters\n\nThe orders screen uses a popover filter for the customer column.\n")
io.open(os.path.join(root, "src/app/orders/picker.tsx"), "w", encoding="utf-8").write(
    "export function Picker() { return <Select options={[]} />; }\n")
'
expect_m06_source "a file-upload requirement with no file input blocks" FAIL "specifies a file upload but no file input" '
p = os.path.join(root, "docs/specs/FSD.md")
s = io.open(p, encoding="utf-8").read()
io.open(p, "w", encoding="utf-8").write(
    s + "\n\n## Attachments\n\nProducts accept a photo upload: .jpg or .png, maximum 5 MB.\n")
'


# Producer side: M05 must require the handoff section so M06 STEP 0 can read it.
expect_m05_handoff() {
    local name="$1" want="$2" with_handoff="$3"
    local dir="$WORK/m05h"
    make_project "$dir" "$INTAKE_MEDIUM"
    mkdir -p "$dir/docs/specs"
    printf '### Stack Decision\nStack Decision LOCKED: Next.js  Rejected: Laravel because the team already ships React\n\n- Q1 x\n- Q2 x\n- Q3 x\n- Q4 x\n- Q5 x\n- Q6 x\n- Q7 x\n- Q8 x\n' > "$dir/docs/specs/FSD.md"
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
    printf '### Stack Decision (LOCKED)\nStack Decision LOCKED: Next.js 15  Rejected: Laravel because the team already ships React\n\n### Framework Versions (Pinned)\n%b\n\n## 3. Database Schema\n' "$fsdline" > "$dir/docs/specs/FSD.md"
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

## 3b. Real User Interviews (INT-0x)
| ID | Name | Role | Date | Status |
|:---|:---|:---|:---|:---|
| INT-01 | A | owner | 2026-10-01 | ✅ Real |
| INT-02 | B | owner | 2026-10-02 | ✅ Real |
| INT-03 | C | owner | 2026-10-03 | ✅ Real |

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

## 4b. User Discovery
Five attempts, three confirmed above; the remaining two were unreachable calls.

## 5. Behavioral Intent Validation (Waitlist / Smoke Test)
- **Total Unique Visitors**: 140
- **Total Waitlist / Email Signups**: $(awk -v p="$pct" 'BEGIN { printf "%d", (p * 140 / 100) + 0.5 }')
- **Waitlist-Conversion-Pct**: $pct
- **Intent-to-Buy-Pct**: $intent
Alternative-Proof: deposits:$dep loi:$loi

## 6. Unit Economics & Solo Capacity Sanity Check
- **Target ARPU**: Rp 99000 / month
- **Estimated CAC**: Rp 25000 / customer

## 7. Kill Criteria & Gate Validation Outcome
Kill criteria as listed in the module contract.

Validated-by: S. Rahma on 2026-10-12

Gate-Decision: $declared
M00EOF
    local out got
    out="$(cd "$dir" && bash "$GATE" M00 2>&1 || true)"
    got=$(printf '%s' "$out" | sed -n 's/.*Aggregated verdict from signals:.*-> \([A-Z]*\).*/\1/p' | head -1)
    if [ -z "$got" ]; then got="<none: the fixture never reached aggregation>"; fi
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (aggregated -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (aggregated -> ${got:-<none>}, expected $want)"
        FAIL=$((FAIL + 1))
    fi
    rm -rf "$dir"
}
# The module contract (00_PRODUCT_DISCOVERY_STRATEGY.md §1b): any PASS behavioural signal closes
# the gate, RETEST is the best signal in RETEST, KILL is all in KILL. One documented exception: a
# survey lifts RETEST, it never overturns a measured behavioural KILL - otherwise 1.5% of 140
# visitors is talked up by a questionnaire, which is the whole point of running the waitlist.
expect_m00_signal "M00 waitlist KILL + deposits RETEST aggregates to RETEST" 1.5 10 2 0 RETEST RETEST
expect_m00_signal "M00 a survey cannot overturn a waitlist KILL" 1.5 35 0 0 KILL KILL
expect_m00_signal "M00 a survey lifts a RETEST to PASS" 3.5 35 0 0 PASS PASS
expect_m00_signal "M00 a real deposit closes the gate over a waitlist KILL" 1.5 10 6 0 PASS PASS
expect_m00_signal "M00 all signals KILL aggregates to KILL" 1.0 5 0 0 KILL KILL

# The kill-criteria checks must not fire on the document that DEFINES the criterion. The CI
# fixture m00-lite-pass.md contains "Regulatory Kill: business model requires a banking licence"
# and my first version blocked it - a gate failing the correct document.
expect_m00_kill() {
    local name="$1" want="$2" appended="$3"
    local dir="$WORK/m00kill"; rm -rf "$dir"; mkdir -p "$dir/docs/pm"
    printf -- '- **Scale**: solo\n- Delivery: solo\n' > "$dir/docs/pm/PROJECT_STATE.md"
    cp "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/scripts/verify/fixtures/m00-lite-pass.md" "$dir/docs/pm/M00_LITE.md"
    [ -n "$appended" ] && printf '%b\n' "$appended" >> "$dir/docs/pm/M00_LITE.md"
    local out got="PASS"
    out="$(cd "$dir" && bash "$GATE" M00 2>&1 || true)"
    echo "$out" | grep -qE "Regulatory kill|Feasibility kill" && got="FAIL"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (kill -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (kill -> $got, expected $want)"
        echo "$out" | grep -E "Regulatory kill|Feasibility kill" | head -2 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
expect_m00_kill "a document that only DEFINES the kill criteria passes" PASS ""
expect_m00_kill "an admission of needing a lending licence blocks" FAIL '## 8. Business Model
Our model requires a lending licence from OJK before launch.'
expect_m00_kill "a 12-week MVP timeline blocks" FAIL '## 9. Delivery
MVP development timeline: 12 weeks for one developer.'

# M01: the mitigation label was accepted as a plan. The template ships the label with the
# instruction inside it and the old check only grepped for "Mitigation:", so a CONDITIONAL_GO with
# no plan passed into M02. Four spellings must block, one real plan must pass.
expect_m01_mitigation() {
    local name="$1" want="$2" line="$3"
    local dir="$WORK/m01mit"
    rm -rf "$dir"; cp -r "$REPO/scripts/verify/fixtures/m01-go" "$dir"
    python3 - "$dir/docs/pm/IDEA_BRIEF.md" "$line" <<'PYFIX'
import io, re, sys
p, line = sys.argv[1], sys.argv[2]
s = io.open(p, encoding="utf-8").read()
s = re.sub(r"^Feasibility-Decision:.*$", "Feasibility-Decision: CONDITIONAL_GO", s, flags=re.M)
s = s.replace("Mitigation: two weeks of discovery with five shop owners before build.", line)
io.open(p, "w", encoding="utf-8").write(s)
PYFIX
    local out got="FAIL"
    out="$(cd "$dir" && bash "$GATE" M01 2>&1 || true)"
    echo "$out" | grep -q "Gate validation PASSED" && got="PASS"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (mitigation -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (mitigation -> $got, expected $want)"
        echo "$out" | grep -E "mitigation plan" | head -1 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
if [ -d "$REPO/scripts/verify/fixtures/m01-go" ]; then
    expect_m01_mitigation "the template's own mitigation label is not a plan" FAIL \
        'Mitigation: [required when the decision is CONDITIONAL_GO]'
    expect_m01_mitigation "an empty mitigation blocks" FAIL 'Mitigation:'
    expect_m01_mitigation "TBD mitigation blocks" FAIL 'Mitigation: TBD'
    expect_m01_mitigation "a four-word mitigation blocks" FAIL 'Mitigation: ship it fast'
    expect_m01_mitigation "a real mitigation plan passes" PASS \
        'Mitigation: two weeks of discovery with five shop owners before build.'

# M02: the "measurable Then" test was a 14-word list containing grammar words. "then it is good"
# and "then no errors occur anywhere" passed; "then the order status becomes paid" was rejected.
expect_m02_ac() {
    local name="$1" want="$2" acs="$3"
    local dir="$WORK/m02ac"
    rm -rf "$dir"; cp -r "$REPO/scripts/verify/fixtures/m02-scope" "$dir" 2>/dev/null || mkdir -p "$dir/docs/pm"
    [ -f "$dir/docs/pm/SCOPE_STATEMENT.md" ] || { echo -e "  ${YELLOW}-${NC} sorry: fixture m02-scope missing"; return; }
    python3 - "$dir/docs/pm/SCOPE_STATEMENT.md" "$acs" <<'PYAC'
import io, re, sys
p, acs = sys.argv[1], sys.argv[2]
s = io.open(p, encoding="utf-8").read()
s = re.sub(r"(?im)^\s*-?\s*(?:\[[ xX]\]\s*)?(?:AC-F-\d+|Given\b).*$", "", s)
s += "\n## Acceptance Criteria\n\n" + acs.replace("\\n", "\n") + "\n"
io.open(p, "w", encoding="utf-8").write(s)
PYAC
    local out got="FAIL"
    out="$(cd "$dir" && bash "$GATE" M02 2>&1 || true)"
    echo "$out" | grep -q "Gate validation PASSED" && got="PASS"
    if [ "$got" = "$want" ]; then
        echo -e "  ${GREEN}✓${NC} $name  (AC -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (AC -> $got, expected $want)"
        echo "$out" | grep -E "Acceptance criteria" | head -1 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}
if [ -d "$REPO/scripts/verify/fixtures/m02-scope" ]; then
    expect_m02_ac "'then it is good' is not a measurement" FAIL \
'- AC-F-01: Given a user, when they click, then it is good
- AC-F-02: Given a user, when they click, then it is good
- AC-F-03: Given a user, when they click, then it is good
- AC-F-04: Given a user, when they click, then it is good
- AC-F-05: Given a user, when they click, then it is good
- AC-F-06: Given a user, when they click, then it is good
- AC-F-07: Given a user, when they click, then it is good
- AC-F-08: Given a user, when they click, then it is good'
    expect_m02_ac "'then no errors occur anywhere' is not a measurement" FAIL \
'- AC-F-01: Given a user, when they click, then no errors occur anywhere
- AC-F-02: Given a user, when they click, then no errors occur anywhere
- AC-F-03: Given a user, when they click, then no errors occur anywhere
- AC-F-04: Given a user, when they click, then no errors occur anywhere
- AC-F-05: Given a user, when they click, then no errors occur anywhere
- AC-F-06: Given a user, when they click, then no errors occur anywhere
- AC-F-07: Given a user, when they click, then no errors occur anywhere
- AC-F-08: Given a user, when they click, then no errors occur anywhere'
    expect_m02_ac "a state transition is a measurement" PASS \
'- AC-F-01: Given a customer, when they pay, then the order status becomes paid
- AC-F-02: Given a cashier, when they open the list, then 20 rows are rendered
- AC-F-03: Given an admin, when they delete, then the account is marked deleted
- AC-F-04: Given a user, when they submit, then HTTP 201 and the row is created
- AC-F-05: Given a visitor, when they log in wrong, then the error is shown and no session is set
- AC-F-06: Given a manager, when they export, then a CSV of all rows is downloaded
- AC-F-07: Given a device, when it syncs, then exactly 0 conflicts are reported
- AC-F-08: Given a user, when they pay twice, then the second charge is rejected'
else
    echo -e "  ${YELLOW}-${NC} M02 AC regressions skipped: fixture m02-scope missing"
fi
else
    echo -e "  ${YELLOW}-${NC} M01 mitigation regressions skipped: fixture m01-go missing"
fi

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
            # The workbook ships a form; strip every remaining [...] so the placeholder
            # check passes. Do NOT strip the security audit after marking its checkbox —
            # the gate reads "[x] **SECURITY PASS**" as the attestation.
            sed -i -E 's/\[[^][]*\]/X/g' "$wb"
            # A blank form is not a completed audit. This fixture is the positive case, so it has
            # to look like the three artifacts a real delivery leaves behind: a polish audit that
            # names the URL it inspected and states each tell, a sign-off sheet two people signed,
            # and a workbook whose PASS traces back to requirements.
            {
                printf '# Polish Audit — https://staging.example.com\n\n'
                printf '| # | Tell | Verdict | Evidence |\n| :--- | :--- | :---: | :--- |\n'
                for i in 1 2 3 4 5 6; do
                    printf '| %s | tell-%s | PASS | inspected on the deployed URL |\n' "$i" "$i"
                done
                printf '\n**Conclusion**: READY (0 blocking tells)\n'
            } > "$dir/docs/qa/POLISH_AUDIT.md"
            # Two identifiable signatories, as the template's own sheet requires.
            sed -i 's/| \*\*Name\*\*: ____*[^|]*| \*\*Name\*\*: ____*[^|]*|/| **Name**: S. Rahma | **Name**: A. Kusuma |/' "$wb"
            sed -i 's/| \*\*Title \/ Role\*\*: Independent Lead Engineer | \*\*Title \/ Role\*\*: ____*[^|]*|/| **Title \/ Role**: Independent Lead Engineer | **Title \/ Role**: Product Owner |/' "$wb"
            sed -i 's/| \*\*Date\*\*: ____*[^|]*| \*\*Date\*\*: ____*[^|]*|/| **Date**: 2026-10-12 | **Date**: 2026-10-13 |/' "$wb"
            sed -i 's/| \*\*Signature\*\*: | \*\*Signature\*\*: |/| **Signature**: S. Rahma | **Signature**: A. Kusuma |/' "$wb"
            # Every REQ-xx / SCR-xx the specs declare must have a tested row. make_project writes
            # the intake; use whatever requirement IDs it produced.
            {
                printf '\n| Item | Scenario | Result |\n| :--- | :--- | :---: |\n'
                # Rows are listed from the specs when they exist and from the workbook's own scope
                # when they do not: the gate asks for traceability, not for a particular spec path.
                rows=""
                if [ -f "$dir/docs/specs/FSD.md" ]; then
                    rows=$(grep -oE 'REQ-[0-9]+' "$dir/docs/specs/FSD.md" | sort -u)
                fi
                if [ -z "$rows" ]; then
                    rows=$(printf 'REQ-01\nREQ-02\nREQ-03')
                fi
                printf '%s\n' "$rows" | while read -r rq; do
                    [ -n "$rq" ] || continue
                    printf '| %s | primary path verified | PASS |\n' "$rq"
                    printf '| %s | invalid input is rejected (negative) | PASS |\n' "$rq"
                done
                sc_rows=""
                if [ -f "$dir/docs/specs/SITEMAP.md" ]; then
                    sc_rows=$(grep -oE 'SCR-[A-Z]*-?[0-9]+' "$dir/docs/specs/SITEMAP.md" | sort -u)
                fi
                if [ -z "$sc_rows" ]; then
                    sc_rows=$(printf 'SCR-001\nSCR-002')
                fi
                printf '%s\n' "$sc_rows" | while read -r sc; do
                    [ -n "$sc" ] || continue
                    printf '| %s | screen renders and is reachable | PASS |\n' "$sc"
                done
                printf '\nStaging-URL: https://staging.example.com\n'
            } >> "$wb"
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

# ----------------------------------------------------------------- M07: QA / SIT / security
# Measured 2026-11-06: the shipped template passed with an unsigned sign-off sheet, a prose claim of
# "0 blocking" and a bolded Critical count. Each case below pins one of those shut, and each rule
# also has a case proving a correct document still passes.
expect_m07() {
    local name="$1" want="$2" msg="$3" kind="$4"
    local build="$REPO/scripts/verify/fixtures/m07/build.py" dir="$WORK/m07qa"
    if [ ! -f "$build" ]; then
        echo -e "  ${RED}✗${NC} $name  (fixture builder missing: $build)"
        FAIL=$((FAIL + 1)); return
    fi
    rm -rf "$dir"; mkdir -p "$dir"
    python3 "$build" "$dir" "$kind" >/dev/null 2>&1 || {
        echo -e "  ${RED}✗${NC} $name  (builder failed for '$kind')"; FAIL=$((FAIL + 1)); return; }
    local out rc got=PASS
    out="$(cd "$dir" && bash "$GATE" M07 2>&1)"; rc=$?
    [ "$rc" -ne 0 ] && got="FAIL"
    local cause=1
    if [ "$want" = "FAIL" ] && [ -n "$msg" ]; then
        printf '%s\n' "$out" | grep -E '^[[:space:]]*❌' | grep -F -q -- "$msg" || cause=0
    fi
    if [ "$got" = "$want" ] && [ "$cause" = 1 ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M07 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M07 -> $got, expected $want)"
        printf '%s\n' "$out" | grep -E '^[[:space:]]*❌' | head -2 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}

echo ""
echo "M07 QA / SIT / security:"
expect_m07 "a fully executed SIT workbook passes"                 PASS ""                                             base
expect_m07 "an unsigned sign-off sheet blocks"                    FAIL "sign-off sheet is UNSIGNED"                  empty-signoff
expect_m07 "a missing sign-off section blocks"                    FAIL "has no 'SIT Sign-Off' section"               signoff-missing
expect_m07 "a prose claim of 0 blocking without a URL blocks"     FAIL "names no deployed URL"                       polish-vague-zero
expect_m07 "SIT rows traceable to workbook IDs still pass"       PASS ""                                            no-specs
expect_m07 "SIT PASS with nothing to trace to blocks"             FAIL "SIT coverage cannot be verified"             no-traceability
expect_m07 "a bolded Critical count still blocks"                 FAIL "reports unresolved Critical vulnerabilities" security-critical-row
expect_m07 "a renamed native QA heading blocks"                   FAIL "matching 'Native Mobile QA'"                 native-narrow

echo ""
echo "M08 data migration:"
# Measured 2026-11-06: counts that disagreed passed, a renamed sign-off heading disabled the
# signatory check entirely, a blank table-cell signature passed, and Medium closed without any
# reconciliation report. One case per hole, plus the positive base.
expect_m08() {
    local name="$1" want="$2" msg="$3" kind="$4"
    local build="$REPO/scripts/verify/fixtures/m08/build.py" dir="$WORK/m08mig"
    if [ ! -f "$build" ]; then
        echo -e "  ${RED}✗${NC} $name  (fixture builder missing: $build)"
        FAIL=$((FAIL + 1)); return
    fi
    rm -rf "$dir"; mkdir -p "$dir"
    python3 "$build" "$dir" "$kind" >/dev/null 2>&1 || {
        echo -e "  ${RED}✗${NC} $name  (builder failed for '$kind')"; FAIL=$((FAIL + 1)); return; }
    local out rc got=PASS
    out="$(cd "$dir" && bash "$GATE" M08 2>&1)"; rc=$?
    [ "$rc" -ne 0 ] && got="FAIL"
    local cause=1
    if [ "$want" = "FAIL" ] && [ -n "$msg" ]; then
        printf '%s\n' "$out" | grep -E '^[[:space:]]*❌' | grep -F -q -- "$msg" || cause=0
    fi
    if [ "$got" = "$want" ] && [ "$cause" = 1 ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M08 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M08 -> $got, expected $want)"
        printf '%s\n' "$out" | grep -E '^[[:space:]]*❌' | head -2 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}

expect_m08 "a reconciled migration with agreeing counts passes"     PASS ""                                    base
expect_m08 "PASSED without row counts blocks"                       FAIL "states no row counts"                  recon-passed-no-counts
expect_m08 "row counts that disagree block"                         FAIL "row counts that do not agree"          recon-counts-not-matching
expect_m08 "a renamed sign-off heading still blocks an unsigned PIC" FAIL "sign-off names nobody"               recon-no-pic-wording
expect_m08 "a blank signature cell blocks"                          FAIL "sign-off is UNSIGNED"                  recon-blank-signature
expect_m08 "a Medium migration without reconciliation blocks"       FAIL "MIGRATION_RECONCILIATION_REPORT.md (MISSING)" no-reconciliation-medium
expect_m08 "a table missing from the mapping blocks"                FAIL "never mentions these schema table(s)"  plan-ignores-table

echo ""
echo "M09 UAT sign-off:"
# Measured 2026-11-06 on a hand-written pack: "No PENDING items remained" was rejected as a status,
# "The cargo crate was shipped" was accepted as an approval, a blank signature cell passed, an open
# Sev 1 row passed, a filler word passed as a signatory, and an internal signature closed the UAT.
expect_m09() {
    local name="$1" want="$2" msg="$3" kind="$4"
    local build="$REPO/scripts/verify/fixtures/m09/build.py" dir="$WORK/m09uat"
    if [ ! -f "$build" ]; then
        echo -e "  ${RED}✗${NC} $name  (fixture builder missing: $build)"
        FAIL=$((FAIL + 1)); return
    fi
    rm -rf "$dir"; mkdir -p "$dir"
    python3 "$build" "$dir" "$kind" >/dev/null 2>&1 || {
        echo -e "  ${RED}✗${NC} $name  (builder failed for '$kind')"; FAIL=$((FAIL + 1)); return; }
    local out rc got=PASS
    out="$(cd "$dir" && bash "$GATE" M09 2>&1)"; rc=$?
    [ "$rc" -ne 0 ] && got="FAIL"
    local cause=1
    if [ "$want" = "FAIL" ] && [ -n "$msg" ]; then
        printf '%s\n' "$out" | grep -E '^[[:space:]]*❌' | grep -F -q -- "$msg" || cause=0
    fi
    if [ "$got" = "$want" ] && [ "$cause" = 1 ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M09 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M09 -> $got, expected $want)"
        printf '%s\n' "$out" | grep -E '^[[:space:]]*❌' | head -2 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}

expect_m09 "a signed, evidenced UAT pack passes"                  PASS ""                                   base
expect_m09 "mentioning no PENDING items is not a rejection"       PASS ""                                   uat-pending-mentioned
expect_m09 "an approval word inside prose is not an approval"     FAIL "missing explicit approval attestation" uat-go-in-word
expect_m09 "a renamed client row with no name blocks"             FAIL "client sign-off row names nobody"    uat-renamed-signoff
expect_m09 "a filler word is not a signatory"                     FAIL "placeholder word"                    uat-placeholder-name
expect_m09 "a blank signature cell blocks"                        FAIL "blank signature lines"               uat-blank-cell
expect_m09 "an open Severity 1 row blocks"                         FAIL "unresolved Severity 1 or 2 defects"  uat-sev-row
expect_m09 "a UAT without a workbook blocks"                       FAIL "UAT_WORKBOOK.md (MISSING)"           uat-no-workbook

echo ""
echo "M10 production cutover:"
# Measured 2026-11-07: a PVT row saying "FAIL (retested, now PASS)", a PVT row with a blank status
# cell, a core section demoted to a top-level title, a client-input receipt with no PIC, a Large
# delivery with no rollback plan, and a model riding along as the verifying signer - all PASSED.
expect_m10() {
    local name="$1" want="$2" msg="$3" kind="$4"
    local build="$REPO/scripts/verify/fixtures/m10/build.py" dir="$WORK/m10gate"
    if [ ! -f "$build" ]; then
        echo -e "  ${RED}✗${NC} $name  (fixture builder missing: $build)"
        FAIL=$((FAIL + 1)); return
    fi
    rm -rf "$dir"; mkdir -p "$dir"
    python3 "$build" "$dir" "$kind" >/dev/null 2>&1 || {
        echo -e "  ${RED}✗${NC} $name  (builder failed for '$kind')"; FAIL=$((FAIL + 1)); return; }
    local out rc got=PASS
    out="$(cd "$dir" && bash "$GATE" M10 2>&1)"; rc=$?
    [ "$rc" -ne 0 ] && got="FAIL"
    local cause=1
    if [ "$want" = "FAIL" ] && [ -n "$msg" ]; then
        printf '%s\n' "$out" | grep -E '^[[:space:]]*❌' | grep -F -q -- "$msg" || cause=0
    fi
    if [ "$got" = "$want" ] && [ "$cause" = 1 ]; then
        echo -e "  ${GREEN}✓${NC} $name  (M10 -> $got)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $name  (M10 -> $got, expected $want)"
        printf '%s\n' "$out" | grep -E '^[[:space:]]*❌' | head -2 | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
}

expect_m10 "a verified, live cutover passes"                    PASS ""                                   base
expect_m10 "a failure rescued in prose is still a failure"      FAIL "PVT rows reporting failure"        pvt-fail-prose
expect_m10 "a PVT row with no status blocks"                    FAIL "blank status cell"                 pvt-no-status-row
expect_m10 "a core section demoted to a title blocks"           FAIL "only as a top-level title"         section-level1
expect_m10 "a client receipt with no PIC blocks"                FAIL "still a placeholder"               inputs-blank-pic
expect_m10 "a Large release without a rollback plan blocks"      FAIL "ROLLBACK_PLAN.md (MISSING)"        rollback-large
expect_m10 "a model named as verifier blocks"                    FAIL "names a model as Lead Engineer"    signer-role
expect_m10 "a decision line that is only a bullet blocks"        FAIL "must record 'Human decision: GO'"  go-commented

echo ""
if [ "$FAIL" -eq 0 ]; then
    echo -e "${GREEN}All $PASS gate regression tests passed.${NC}"
    exit 0
fi
echo -e "${RED}$FAIL of $((PASS + FAIL)) gate regression tests FAILED.${NC}"
exit 1
