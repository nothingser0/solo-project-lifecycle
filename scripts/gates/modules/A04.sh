#!/usr/bin/env bash
# Gate: A04 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_A04 ------------------------------------------------------
gate_A04() {
    echo "=== A04: Governance Handover & Architecture Conformance Retainer Checklist ==="
    check_required "docs/governance/GOVERNANCE_HANDOVER_PACK.md" "docs/pm/GOVERNANCE_HANDOVER_PACK.md" 1000

    local target="docs/governance/GOVERNANCE_HANDOVER_PACK.md"
    [ -f "$target" ] || target="docs/pm/GOVERNANCE_HANDOVER_PACK.md"
    if [ -f "$target" ]; then
        if grep -qE "\[Client Company|\[Your Name\]|\[Project Name\]|\[YYYY-MM-DD\]" "$target"; then
            echo "  ❌ $target still contains unresolved template placeholders ([...])!"
            GATE_FAILED=1
        fi
        check_sections "$target" "RACI" "CAB" "Disaster Recovery"

        a04_body() { # $1 keyword, $2 file
            awk -v pat="$1" 'BEGIN{IGNORECASE=1}
                /^#+[[:space:]]/ {
                    lvl = match($0, /[^#]/)
                    if (keep == 0 && $0 ~ pat) { keep = 1; base = lvl; next }
                    if (keep == 1 && lvl <= base) { keep = 0 }
                }
                keep { print }' "$2" 2>/dev/null
        }
        a04_rows() { # rows of a table body, structure stripped
            printf '%s\n' "$1" | sed 's/^[[:space:]]*//' \
                | grep -E '^\|' | grep -vE '^\|[[:space:]]*:'                 | grep -vE '^\|[[:space:]]*(activity|item|change class|change type|role)[[:space:]]*\|'
        }
        a04_content() { # non-empty, non-structural lines of a section body
            printf '%s\n' "$1" | sed 's/^[[:space:]]*//' | grep -vE '^$|^-{3,}$|^#|^>'
        }

        # A RACI whose only row is "Everything | TBD" assigns nothing. Require at least three
        # rows, at least one accountable owner, and no placeholder owner.
        raci_block=$(sed -n '/[#]*.*RACI/,/^#[#]\{0,2\}[[:space:]]/p' "$target" 2>/dev/null || true)
        [ -n "$raci_block" ] || raci_block=$(sed -n '/[#]*.*RACI/,$p' "$target" 2>/dev/null || true)
        raci_rows=$(echo "$raci_block" | grep -cE "^\|[^-|][^|]*\|" || true)
        raci_rows=${raci_rows:-0}
        if [ "$raci_rows" -lt 3 ]; then
            echo "  ❌ $target RACI has $raci_rows row(s) - fewer than three assigns nothing."
            GATE_FAILED=1
        fi
        if echo "$raci_block" | grep -qiE "\|[[:space:]]*(TBD|TODO|XXX|\?+|n/a|_____)[[:space:]]*\|"; then
            echo "  ❌ $target RACI assigns a role to TBD/placeholder - the accountability is unassigned."
            GATE_FAILED=1
        fi
        # "accountable" in prose is not an owner: the template's own footnote
        # ("**A/R = accountable and responsible**") satisfied the old check while every RACI cell
        # read R/C/I. Only a cell counts, and A/R means the same person is both.
        if ! a04_rows "$raci_block" | grep -qE '\|[[:space:]>*_]*(A|A/R|A\\R|AR)[[:space:]*_<]*\|'; then
            echo "  ❌ $target RACI assigns no cell an A (accountable) - nobody owns the decision."
            GATE_FAILED=1
        fi

        # Disaster recovery without a stated recovery time and recovery point is an intention.
        dr_block=$(sed -n '/[#]*.*Disaster Recovery/,/^#[#]\{0,2\}[[:space:]]/p' "$target" 2>/dev/null || true)
        [ -n "$dr_block" ] || dr_block=$(sed -n '/[#]*.*Disaster Recovery/,$p' "$target" 2>/dev/null || true)
        if [ -n "$dr_block" ]; then
            # The label alone is not a number: the shipped template's rows are blank
            # ("| RTO (acceptable downtime) | | ☐ |"). Require both the label and a stated value.
            for pair in "RTO|recovery time" "RPO|recovery point"; do
                key=${pair%%|*}; alt=${pair##*|}
                val=$(printf '%s\n' "$dr_block" | sed 's/^[[:space:]]*//' \
                    | grep -iE "$key|$alt" | grep -E '^\|' | head -1 \
                    | awk -F'|' '{ print $3 }' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//; s/[☐☑✓✗xX]//g')
                if ! printf '%s\n' "$dr_block" | grep -qiE "$key|$alt"; then
                    echo "  ❌ $target Disaster Recovery states no $key - '$key unspecified' is not a recovery plan."
                    GATE_FAILED=1
                elif [ -z "$val" ] || printf '%s\n' "$val" | grep -qiE '^(tbd|todo|n/?a|unknown|-+|_+)$'; then
                    echo "  ❌ $target Disaster Recovery gives $key no value ('${val:-empty}') - an unmeasured target is an intention."
                    GATE_FAILED=1
                fi
            done

            # Targets without a test are a wish: a drill date is what makes them credible.
            if ! printf '%s\n' "$dr_block" | grep -qiE 'drill|tested|rehears'; then
                echo "  ❌ $target Disaster Recovery records no restore drill - an untested recovery target is a hope."
                GATE_FAILED=1
            fi
        fi

        # A CAB section with a heading and nothing else describes no change process.
        cab_body=$(a04_body "CAB" "$target")
        if [ -z "$(a04_content "$cab_body")" ]; then
            echo "  ❌ $target CAB section is empty - a heading is not a change process."
            GATE_FAILED=1
        fi

        # The retainer is the thing the client is buying after handover; it must say what it covers.
        ret_body=$(a04_body "Retainer" "$target")
        if [ -z "$(a04_content "$ret_body")" ]; then
            echo "  ❌ $target has no Architecture Conformance Retainer content - the handover sells a service it never describes."
            GATE_FAILED=1
        fi

        # Same signing rule as M09/M10/M11/A00.
        if grep -iE "(signed by|signed|approved by)[[:space:]]*:" "$target" | grep -qiE "(claude|chatgpt|gpt[0-9._-]*|openai|anthropic|copilot|gemini|llama|assistant|agent|bot|llm|ai assistant)"; then
            echo "  ❌ $target names a model as the signing party - the agent may draft the handover pack, never sign it."
            GATE_FAILED=1
        fi
    fi
}
