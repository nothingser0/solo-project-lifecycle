#!/usr/bin/env bash
# End-to-end template pairing.
#
# Every "template cannot satisfy its own gate" defect this framework shipped had the
# same shape: a template was edited (or a gate tightened) and nobody proved the pair
# together. Each block below takes the SHIPPED template, copies it to where the gate
# looks, fills only the placeholders a human would fill, and asserts the gate accepts
# it. The raw template must not be accepted in the cases where a gate rejects
# placeholders — that is the second half of the proof.
#
# Why bash and not Node: the gate scripts are bash, and Node/MSYS disagree about
# what "/tmp" and "C:\..." mean (that cost seven iterations once already).
set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
GATE="$REPO/scripts/gates/validate-gate.sh"
PASS=0
FAIL=0
BASE="$(mktemp -d)"
trap 'rm -rf "$BASE"' EXIT INT TERM

ok()   { printf '  \033[32m✓\033[0m %s\n' "$1"; PASS=$((PASS + 1)); }
bad()  { printf '  \033[31m✗\033[0m %s\n' "$1"; FAIL=$((FAIL + 1)); }

# base_project <dir> <scale> <delivery>
base_project() {
    local d="$1" scale="$2" delivery="$3"
    mkdir -p "$d/docs/pm" "$d/docs/specs" "$d/docs/qa" "$d/docs/governance" "$d/src"
    printf -- '- **Scale**: %s\n- Delivery: %s\n- Intake-Success-Metric: 200 orders/day\n- Intake-P0-Features: 12\n- Intake-Time-Capacity: 40 hrs/week\n- Intake-Sensitive-Data: yes\n- Intake-Integrations: none\n- Intake-Branch-Hierarchy: no\n- Intake-Compliance: none\n- Intake-Legacy-Core: yes\n- Intake-Status: ANSWERED\n' "$scale" "$delivery" > "$d/docs/pm/PROJECT_STATE.md"
    printf '# AGENTS\n\nAnti-slop rules and verification standards.\n' > "$d/AGENTS.md"
    printf '# TODO\n\n- [x] **M06-DB-01**: schema\n  - **Evidence**: exit 0 | Approved: 2026-10-12 by S. Rahma\n' > "$d/TODO.md"
    printf '# PROJECT_LITE\n\nStack Decision LOCKED: Next.js\n' > "$d/PROJECT_LITE.md"
}

# fill <file>  — replace bracketed placeholders the way a human filling the form would.
# Two passes because some templates nest brackets.
# BSD sed (macOS) has no `sed -i` without a backup suffix, so this uses a temp file.
# Same portability class as the `declare -A` bug in the per-scale test.
fill() {
    local f="$1" tmp="$1.tmp"
    sed 's/\[Project Name\]/Acme/g; s/\[Client Company\]/Acme Corp/g; s/\[Your Name\]/S. Rahma/g; s/\[Application Name\]/Acme/g; s/\[Client PIC Name\]/Sari/g; s/\[YYYY-MM-DD\]/2026-10-12/g' "$f" > "$tmp"
    sed -E 's/\[[^][]*\]/X/g' "$tmp" > "$f"
    sed -E 's/\[[^][]*\]/X/g' "$f" > "$tmp"
    mv "$tmp" "$f"
}

run_gate() { # run_gate <dir> <gate> -> echoes exit code
    ( cd "$1" && bash "$GATE" "$2" >/dev/null 2>&1 ); echo $?
}

# pair_case <label> <gate> <want-exit> <template:dest> [<template:dest>...]
#   want-exit 0 => the filled shipped template must PASS
#   want-exit 1 => the raw (unfilled) template must FAIL
pair_case() {
    local label="$1" gate="$2" want="$3"; shift 3
    local dir="$BASE/pair-$(echo "$label" | tr -cd 'a-zA-Z0-9')"
    base_project "$dir" "Medium" "client"
    local pair tpl dest
    for pair in "$@"; do
        tpl="${pair%%:*}"; dest="${pair#*:}"
        mkdir -p "$dir/$(dirname "$dest")"
        if [ ! -f "$REPO/$tpl" ]; then
            bad "$label — template missing: $tpl"
            rm -rf "$dir"
            return
        fi
        cp "$REPO/$tpl" "$dir/$dest"
        if [ "$want" -eq 0 ]; then fill "$dir/$dest"; fi
    done
    local rc
    rc=$(run_gate "$dir" "$gate")
    if [ "$rc" -eq "$want" ]; then
        ok "$label (exit $rc)"
    else
        bad "$label (exit $rc, wanted $want)"
        ( cd "$dir" && bash "$GATE" "$gate" 2>&1 | grep -E "❌" | head -3 | sed 's/^/       /' )
    fi
    rm -rf "$dir"
}

echo "Template pairing — the shipped template must satisfy the gate that reads it"
echo ""

# M04 and M05 are holistic gates: they demand sibling artifacts (PRD, ADR, logo,
# design references) that are unrelated to the template under test. Running them
# whole would fail for the siblings, not the contract. So for those two the
# assertion is the one the gate actually performs on this file: check_sections.
# heading_contract <label> <template> <heading> [<heading>...]
heading_contract() {
    local label="$1" tpl="$2"; shift 2
    local missing=""
    local h
    for h in "$@"; do
        grep -qiE "^#{1,6}[[:space:]]*.*${h}" "$REPO/$tpl" || missing="$missing '$h'"
    done
    if [ -z "$missing" ]; then
        ok "$label"
    else
        bad "$label — shipped template lacks:$missing"
    fi
}

# The heading contracts the gates grep for. If a heading is renamed in the template
# these break, which is exactly the defect class that shipped three times.
heading_contract "M04 contract: component template has Primitives/Composites/WCAG" \
    templates/essentials/LITE_COMPONENT_REQUIREMENTS_TEMPLATE.md "Primitives|Atomic" "Composites" "WCAG|Accessibility"
heading_contract "M12 contract: small warranty has Coverage/Exclusion/SLA" \
    templates/08-maintenance-ops/WARRANTY_POLICY_SMALL.md "Coverage" "Exclusion" "Service Level Agreement"
# Typography/Spacing is DESIGN.md's contract (M04.sh:171-176), not the FSD's.
# Asserting it against FSD would have invented a rule the gate does not have.
heading_contract "M04 contract: DESIGN.md template has Typography and Spacing" \
    templates/02-design/DESIGN_MD_TEMPLATE.md "Typography" "Spacing"

# M05's endpoint contract lives in the FSD body; assert it directly rather than
# running the whole gate (which needs PRD + ADR siblings).
fsd="$REPO/templates/03-architecture-specs/FSD_TECHNICAL_TEMPLATE.md"
ep_count=$(grep -icE "^\s*#{2,6}\s*(GET|POST|PUT|PATCH|DELETE)\s+/" "$fsd" || echo 0)
contracted=$(awk '
    /^[[:space:]]*#{2,6}[[:space:]]*(GET|POST|PUT|PATCH|DELETE)[[:space:]]+\// {
        if (inb && a && r && s && e) ok++; inb=1; a=r=s=e=0; next
    }
    /^[[:space:]]*#{1,6}[[:space:]]/ { if (inb) { if (a&&r&&s&&e) ok++; inb=0 } }
    inb && /- \*\*Auth\*\*:/ { a=1 }
    inb && /- \*\*(Request|Query|Headers)\*\*:/ { r=1 }
    inb && /- \*\*Success\*\*:/ { s=1 }
    inb && /- \*\*Error\*\*:/ { e=1 }
    END { if (inb && a && r && s && e) ok++; print ok+0 }
' "$fsd")
if [ "${ep_count:-0}" -ge 10 ] && [ "${contracted:-0}" -ge 10 ]; then
    ok "M05 contract: FSD ships $ep_count endpoint headings, $contracted with full contracts"
else
    bad "M05 contract: FSD has $ep_count headings / $contracted contracted (both need >=10)"
fi

# M12: the Small warranty doc must carry Coverage / Exclusion / SLA headings.
pair_case "Warranty policy shipped template is accepted by M12" M12 0 \
    templates/08-maintenance-ops/WARRANTY_POLICY_SMALL.md:docs/pm/WARRANTY_POLICY.md

# M08: the LITE migration plan must record a real client-input receipt.
pair_case "Migration LITE shipped template is rejected while unfilled" M08 1 \
    templates/05-data-migration/DATA_MIGRATION_LITE.md:docs/pm/DATA_MIGRATION_LITE.md

# SOLO CAPACITY: the acceptance template is the ONLY file that opens a Large tier.
# Raw (placeholders intact) must be rejected by the classifier; a human-filled copy
# must produce the override (exit 5). This pins the template's field names to what
# classify-scale.sh greps (Accepted-By + Accepted-On YYYY-MM-DD) — the exact defect
# class that shipped with Accepted-On vs Accepted-date drift.
capacity_pair_case() {
    local label="$1" want="$2" mode="$3"
    local dir="$BASE/cap-$(echo "$label" | tr -cd 'a-zA-Z0-9')"
    mkdir -p "$dir/docs/pm"
    # 20 P0, no compliance/legacy -> CAPACITY-ONLY Large: the tier this file governs.
    printf '# PROJECT_STATE\n- Current Phase: Phase 01\n- Scale: large\n- Delivery: solo\n- Intake-P0-Features: 20 (a..t)\n- Intake-Integrations: none\n- Intake-Compliance: none\n- Intake-Legacy-Core: no\n- Intake-Status: ANSWERED\n' > "$dir/docs/pm/PROJECT_STATE.md"
    cp "$REPO/templates/essentials/SOLO_CAPACITY_RISK_ACCEPTANCE.md" "$dir/docs/pm/SOLO-CAPACITY-RISK-ACCEPTANCE.md"
    if [ "$mode" = "fill" ]; then fill "$dir/docs/pm/SOLO-CAPACITY-RISK-ACCEPTANCE.md"; fi
    local rc
    ( cd "$dir" && bash "$REPO/scripts/gates/classify-scale.sh" >/dev/null 2>&1 ); rc=$?
    if [ "$rc" -eq "$want" ]; then ok "$label (exit $rc)"; else bad "$label (exit $rc, wanted $want)"; fi
    rm -rf "$dir"
}
capacity_pair_case "Capacity acceptance raw template is rejected by the classifier" 2 raw
capacity_pair_case "Capacity acceptance human-filled template yields the override" 5 fill

# M04 small path: LITE_SITEMAP + LITE_DESIGN_SPEC ship together into docs/specs/ and
# the gate diffs their distinct SCR-IDs with zero tolerance at 3 screens
# (tolerance = floor(3/10) = 0). Drifting ID sets between the two templates fail M04
# on every fresh Small project — pin them equal here.
lite_ids() { grep -oE 'SCR-[0-9]+' "$1" | sort -u; }
if diff <(lite_ids "$REPO/templates/essentials/LITE_SITEMAP_TEMPLATE.md") \
         <(lite_ids "$REPO/templates/essentials/LITE_DESIGN_SPEC_TEMPLATE.md") >/dev/null; then
    ok "M04 contract: LITE SITEMAP and DESIGN_SPEC ship the same screen IDs"
else
    bad "M04 contract: LITE SITEMAP/DESIGN_SPEC screen IDs drift (every fresh Small project would fail the ±10% check)"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
    echo "All $PASS template pairing checks passed."
    exit 0
fi
echo "$FAIL of $((PASS + FAIL)) template pairing checks FAILED."
exit 1
