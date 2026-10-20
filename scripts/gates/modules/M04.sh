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
        # 1b. Mechanical SVG audit (BLOCKER on FAIL findings). A logo can be 3 KB
        # and still be undeliverable: live <text>, an embedded raster, or a
        # <foreignObject> breaks on a machine without the font and cannot be cut
        # or embroidered. Byte size proves nothing about craft, so the SVG is
        # audited against references/design/LOGO_DESIGN_CRAFT_GUIDE.md §6.
        # Advisory findings (WARN/INFO) are reported, never blocking: a
        # deliberate near-miss angle is legitimate and the human decides.
        case "$found_logo" in
            *.svg)
                audit_script="${SCRIPT_DIR:-scripts/gates}/../design/svg_audit.py"
                py=""
                if python3 -c "import sys; sys.exit(0)" >/dev/null 2>&1; then
                    py=python3
                elif python -c "import sys; sys.exit(0)" >/dev/null 2>&1; then
                    py=python
                fi
                if [ ! -f "$audit_script" ]; then
                    echo "  ⚠️  Logo audit skipped: $audit_script not found (framework incomplete)."
                elif [ -z "$py" ]; then
                    echo "  ⚠️  Logo audit skipped: no python3/python on PATH."
                else
                    audit_out="$("$py" "$audit_script" "$found_logo" 2>&1 || true)"
                    audit_blocking=0
                    for finding in live-text raster-image foreign-object; do
                        if echo "$audit_out" | grep -q "FAIL \[$finding\]"; then
                            audit_blocking=1
                        fi
                    done
                    if echo "$audit_out" | grep -q "WARN \[no-viewbox\]"; then
                        audit_blocking=1
                    fi
                    # A file named .svg that cannot be parsed as SVG is not a logo.
                    # Without this, a placeholder file (or a renamed PNG) sailed
                    # through as "no findings".
                    if echo "$audit_out" | grep -q "could not parse"; then
                        echo "  ❌ $found_logo is not parseable SVG — a placeholder or mislabelled file is not a logo asset."
                        GATE_FAILED=1
                        audit_parse_failed=1
                    else
                        audit_parse_failed=0
                    fi
                    if [ "$audit_parse_failed" -eq 1 ]; then
                        :
                    elif [ "$audit_blocking" -eq 1 ]; then
                        echo "  ❌ $found_logo failed the mechanical SVG audit (M04 §6):"
                        echo "$audit_out" | grep -E "FAIL \[|WARN \[no-viewbox\]" | sed 's/^/       /'
                        GATE_FAILED=1
                    elif echo "$audit_out" | grep -qE "FAIL \[|WARN \["; then
                        score=$(echo "$audit_out" | sed -n 's/.*score: \([0-9]*\)\/100.*/\1/p' | head -1)
                        echo "  ✅ $found_logo passed the blocking SVG audit (score ${score:-?}/100); advisory findings:"
                        echo "$audit_out" | grep -E "WARN \[" | sed 's/^/       /'
                    else
                        score=$(echo "$audit_out" | sed -n 's/.*score: \([0-9]*\)\/100.*/\1/p' | head -1)
                        echo "  ✅ $found_logo passed the mechanical SVG audit (score ${score:-?}/100, no findings)"
                    fi
                fi
                ;;
        esac
    else
        echo "  ❌ assets/logo/ (MISSING: logo.svg or logo.png required before DESIGN.md can be generated)"
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
    check_sections "docs/specs/COMPONENT_REQUIREMENTS.md" "Primitives|Atomic" "Composites" "WCAG|Accessibility"
    check_required "docs/specs/LOGO_DESIGN_BRIEF.md" "" 200
    check_required "docs/design/inspiration/notes.md" "" 200
    check_required "DESIGN.md" "docs/harness-root/DESIGN.md" 1000
    check_required "docs/specs/DESIGN_SPEC.md" "" $min_design_spec
    check_sections "docs/specs/DESIGN_SPEC.md" "Motion|Transition|Interaction"

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
        # 3b. Provenance (BLOCKER). A DESIGN.md with no recorded source is an
        # invented palette: the agent cannot distinguish an observed token from a
        # plausible guess, and nobody downstream can re-verify it. Requires a
        # non-placeholder `sources:` entry plus the evidence/inference log.
        design_sources=$(sed -n '/^sources:/,/^[a-z-]*:/p' "$design_file" 2>/dev/null \
            | grep -E "^\s*-\s*(https?://|[A-Za-z0-9_./-]+\.(md|css|svg|json))" \
            | grep -vE "\[|<|your-|example\.(com|org)|\.\.\." || true)
        if [ -n "$design_sources" ]; then
            src_count=$(printf '%s\n' "$design_sources" | wc -l | tr -d ' ')
            echo "  ✅ DESIGN.md records ${src_count} real source(s) for its tokens"
        else
            echo "  ❌ DESIGN.md has no real 'sources:' entry — record the pages/files the tokens were derived from (M04 §0)."
            echo "     A palette with no provenance is a guess with hex codes, not a design system."
            GATE_FAILED=1
        fi
        if grep -qiE "Evidence (and|&) Inference|Evidence & Inference Log|✅.*(observed|VERIFIED).*🔶|🔶" "$design_file"; then
            echo "  ✅ DESIGN.md separates observed evidence from inference"
        else
            echo "  ❌ DESIGN.md missing the evidence/inference log — mark each token ✅ observed or 🔶 inferred (M04 §0)."
            GATE_FAILED=1
        fi
    fi

    # 4. 5-State Matrix Verification in DESIGN_SPEC.md (BLOCKER)
    if [ -f "docs/specs/DESIGN_SPEC.md" ]; then
        state_count=0
        for st in "Idle|Default" "Loading" "Empty" "Error" "Success"; do
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
                echo "  ❌ DESIGN.md missing Typography or Spacing sections!"
                GATE_FAILED=1
            fi

            # 5b. Anti-Slop Design Defenses (BLOCKER)
            if grep -qiE "Anti-Slop|Zero Gradients|Zero Glassmorphism|Restrained Shadows" "$design_file"; then
                echo "  ✅ DESIGN.md Anti-Slop design defenses verified"
            else
                echo "  ❌ DESIGN.md missing Anti-Slop design rules (Zero Gradients, Zero Glassmorphism, Restrained Shadows)!"
                GATE_FAILED=1
            fi
        fi

        # 6. Prototyping Workflow enforcement (Visual prototypes MANDATORY: A/B)
        wf=$(grep -iE "^Prototyping-Workflow:\s*[AB]" "docs/specs/DESIGN_SPEC.md" | grep -oiE "[AB]" | head -1 | tr '[:lower:]' '[:upper:]')
        if [ "$wf" = "A" ] || [ "$wf" = "B" ]; then
            echo "  [INFO] Prototyping-Workflow: $wf (visual preview mandatory)."
            # Allow flat files in docs/design/screens/*.html or nested subfolders docs/design/screens/scr-xx/
            screen_files=$(find docs/design/screens -type f \( -name "*.html" -o -name "*.tsx" -o -name "*.jsx" -o -name "*.vue" -o -name "*.png" -o -name "*.jpg" -o -name "*.svg" \) 2>/dev/null | wc -l | tr -d ' ')
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
