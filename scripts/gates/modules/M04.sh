#!/usr/bin/env bash
# Gate: M04 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_M04 ------------------------------------------------------
gate_M04() {
    echo "=== M04: UI/UX Prototyping Gate Checklist ==="
    check_intake_gate || true
    # Universal: All scales MUST have components, design inspiration, logo, design tokens, and screen specs
    # 1. Strict Prerequisite: Logo asset must exist in assets/logo/ (logo.svg or logo.png)
    min_logo=200
    if is_small_scale; then
        min_logo=50 # M04-LITE: initial placeholder SVG allowed (min 50B)
    fi
    found_logo=""
    for l in "assets/logo/logo.svg" "assets/logo/logo.png" "assets/logo/logo.webp"; do
        if [ -f "$l" ]; then found_logo="$l"; break; fi
    done
    if [ -n "$found_logo" ]; then
        lsize=$(wc -c < "$found_logo" 2>/dev/null || echo 0)
        if [ "$lsize" -ge "$min_logo" ]; then
            echo "  ✅ $found_logo (${lsize}B >= ${min_logo}B minimum)"
        else
            echo "  ❌ $found_logo (TOO SMALL: ${lsize}B < ${min_logo}B minimum required)"
            GATE_FAILED=1
        fi
    else
        echo "  ❌ assets/logo/ (MISSING: logo.svg / logo.png required before DESIGN.md can be generated)"
        GATE_FAILED=1
    fi

    # 2. Strict Prerequisite: a HUMAN-supplied design reference must exist, and
    # notes.md must select a benchmark from it. '|| true' so a missing reference
    # does not hide the remaining checks (the checklist must print in one pass).
    # The reference requirement is scale-independent: it cannot be waived by
    # choosing the LITE path, and the agent may never author the reference itself.
    check_design_inspiration || true
    if [ -f "docs/design/inspiration/notes.md" ] \
        && grep -qiE "Selected.*Benchmark|Winning Reference|Primary Benchmark|Paling OK" "docs/design/inspiration/notes.md"; then
        echo "  ✅ docs/design/inspiration/notes.md (Benchmark selection verified)"
    else
        echo "  ❌ docs/design/inspiration/notes.md (Prerequisite missing: winning benchmark selection not documented!)"
        GATE_FAILED=1
    fi
    min_sitemap=2000
    min_design_spec=2000
    if is_small_scale; then
        min_sitemap=1000       # M04-LITE: 3-5 routes only
        min_design_spec=1000   # M04-LITE: 5-state matrix on primary screens only
    fi
    check_required "docs/specs/SITEMAP.md" "" $min_sitemap
    check_required "docs/specs/COMPONENT_REQUIREMENTS.md" "" 1000
    check_required "docs/specs/LOGO_DESIGN_BRIEF.md" "" 200
    check_required "docs/design/inspiration/notes.md" "" 200
    check_required "DESIGN.md" "docs/harness-root/DESIGN.md" 1000
    check_required "docs/specs/DESIGN_SPEC.md" "" $min_design_spec

    # 3. Accessibility & Contrast Verification in DESIGN.md (BLOCKER)
    design_file="DESIGN.md"
    [ -f "$design_file" ] || design_file="docs/harness-root/DESIGN.md"
    if [ -f "$design_file" ]; then
        if grep -qiE "[0-9]+(\.[0-9]+)?\s*:\s*1|WCAG|Contrast Ratio" "$design_file"; then
            echo "  ✅ DESIGN.md accessibility & contrast ratios verified"
        else
            echo "  ❌ DESIGN.md missing mathematically computed contrast ratios (e.g. >= 4.5:1, >= 7.0:1)!"
            GATE_FAILED=1
        fi
        if grep -qiE "z-index|Z-Index Layering|--z-" "$design_file"; then
            echo "  ✅ DESIGN.md z-index layering scale verified"
        else
            echo "  ❌ DESIGN.md missing z-index layering scale definition!"
            GATE_FAILED=1
        fi
    fi

    # 4. 5-State Matrix Verification in DESIGN_SPEC.md (BLOCKER)
    if [ -f "docs/specs/DESIGN_SPEC.md" ]; then
        state_count=0
        for st in "Idle" "Loading" "Empty" "Error" "Success"; do
            if grep -qiE "$st" "docs/specs/DESIGN_SPEC.md"; then
                state_count=$((state_count + 1))
            fi
        done
        if [ "$state_count" -ge 3 ]; then
            echo "  ✅ DESIGN_SPEC.md 5-state matrix markers verified ($state_count/5 states detected)"
        else
            echo "  ❌ DESIGN_SPEC.md missing 5-state matrix coverage (found only $state_count/5 states)!"
            GATE_FAILED=1
        fi

        # 5. Typography & Spacing sections in DESIGN.md (BLOCKER)
        if [ -f "$design_file" ]; then
            if grep -qiE "Typography" "$design_file" && grep -qiE "Spacing" "$design_file"; then
                echo "  ✅ DESIGN.md Typography & Spacing sections verified"
            else
                echo "  ❌ DESIGN.md missing required 'Typography' and/or 'Spacing' sections!"
                GATE_FAILED=1
            fi
        fi

        # 6. Prototyping Workflow enforcement (B/C/D require physical screen/prompt output)
        wf=$(grep -iE "^Prototyping-Workflow:\s*[ABCD]" "docs/specs/DESIGN_SPEC.md" | grep -oiE "[ABCD]" | head -1 | tr '[:lower:]' '[:upper:]')
        if [ "$wf" = "B" ] || [ "$wf" = "C" ] || [ "$wf" = "D" ]; then
            echo "  [INFO] Prototyping-Workflow: $wf (visual/AI/design-tool) — per-screen output is MANDATORY."
            # Allow flat files in docs/design/screens/*.html or nested subfolders docs/design/screens/scr-xx/
            screen_files=$(find docs/design/screens -type f \( -name "*.html" -o -name "*.tsx" -o -name "*.jsx" -o -name "*.vue" \) 2>/dev/null | wc -l | tr -d ' ')
            if [ "${screen_files:-0}" -ge 1 ]; then
                echo "  ✅ Interactive screen preview outputs present (found $screen_files preview files)"
            else
                echo "  ❌ Workflow $wf selected but interactive screen previews missing! Place HTML/component prototypes in docs/design/screens/."
                GATE_FAILED=1
            fi
        fi

        # 7. Screen count match: SITEMAP routes vs DESIGN_SPEC screen rows (±10%)
        if [ -f "docs/specs/SITEMAP.md" ]; then
            sitemap_screens=$(grep -oE "SCR-[0-9]+" "docs/specs/SITEMAP.md" | sort -u | wc -l | tr -d ' ')
            spec_screens=$(grep -oE "SCR-[0-9]+" "docs/specs/DESIGN_SPEC.md" | sort -u | wc -l | tr -d ' ')
            if [ "${sitemap_screens:-0}" -ge 1 ]; then
                diff=$(( sitemap_screens - spec_screens ))
                [ "$diff" -lt 0 ] && diff=$(( -diff ))
                tolerance=$(( sitemap_screens / 10 ))
                if [ "$diff" -le "$tolerance" ]; then
                    echo "  ✅ Screen count match verified (SITEMAP $sitemap_screens vs DESIGN_SPEC $spec_screens, tolerance ±$tolerance)"
                else
                    echo "  ❌ Screen count mismatch: SITEMAP $sitemap_screens vs DESIGN_SPEC $spec_screens (exceeds ±10% tolerance)!"
                    GATE_FAILED=1
                fi
            fi
        fi

        # 8. Design Freeze must be signed by the human (not filled in by the agent).
        # '|| true' keeps the checklist running under 'set -e' so ALL failures print.
        check_design_freeze || true
    fi
}
