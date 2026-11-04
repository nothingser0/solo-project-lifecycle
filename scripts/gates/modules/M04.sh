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
    for l in "docs/design/brand/logo.svg" "docs/design/brand/logo.png" "assets/logo/logo.svg" "assets/logo/logo.png" "assets/logo/logo.webp"; do
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
        echo "  ❌ Logo missing: logo.svg or logo.png required in docs/design/brand/ (or assets/logo/) before DESIGN.md can be generated"
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
    check_required "docs/design/brand/LOGO_DESIGN_BRIEF.md" "docs/specs/LOGO_DESIGN_BRIEF.md" 200
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
            if grep -qiE "Anti-Slop|Zero Emoticons|Zero Glassmorphism|Restrained Shadows" "$design_file"; then
                echo "  ✅ DESIGN.md Anti-Slop design defenses verified"
            else
                echo "  ❌ DESIGN.md missing Anti-Slop design rules (Anti-Slop, Zero Emoticons, Zero Glassmorphism, Restrained Shadows)!"
                GATE_FAILED=1
            fi
        fi

        # 6. Interactive Prototyping enforcement (Visual prototype MANDATORY)
        echo "  [INFO] Interactive Prototyping (visual preview mandatory)."
        # Allow flat files in docs/design/screens/*.html or nested subfolders docs/design/screens/scr-xx/
        screen_files=$(find docs/design/screens -type f \( -name "*.html" -o -name "*.tsx" -o -name "*.jsx" -o -name "*.vue" -o -name "*.png" -o -name "*.jpg" -o -name "*.svg" \) 2>/dev/null | wc -l | tr -d ' ')
        if [ "${screen_files:-0}" -ge 1 ]; then
            echo "  ✅ Interactive screen preview outputs present (found $screen_files preview files)"
            # 6b. Mechanical Anti-Slop Prototype Audit
            neon_colors=$(grep -rInE "(#FF5722|#FF0000|#00FF00|bg-orange-500|bg-red-500)" docs/design/screens 2>/dev/null | wc -l | tr -d ' ')
            if [ "${neon_colors:-0}" -gt 0 ]; then
                echo "  ⚠️  Anti-slop advisory: found ${neon_colors} uncalibrated neon color(s) in prototype. Use curated tones from DESIGN.md in M06 FE."
            fi
            # 6c. Spec identifier leaks in prototype UI (BLOCKER)
            proto_spec_leaks=$(grep -rInE "(SCR-[0-9]+|M06-FE-[0-9]+)" docs/design/screens 2>/dev/null \
                | grep -vE "(\.test\.|\.spec\.|__tests__|node_modules|\.d\.ts)" | wc -l | tr -d ' ')
            if [ "${proto_spec_leaks:-0}" -gt 0 ]; then
                echo "  ❌ Anti-slop: found ${proto_spec_leaks} internal spec identifier(s) (e.g. SCR-xx) leaking in prototype UI! Spec codes are internal; end users must never see them."
                GATE_FAILED=1
            else
                echo "  ✅ Anti-slop: zero internal spec identifiers leaked in prototype UI"
            fi
            # 6d. Prototype Screen Coverage Check: prevent single-screen dashboard cop-out
            if [ -f "docs/specs/SITEMAP.md" ]; then
                sitemap_screens=$(grep -oE "SCR-[0-9]+" "docs/specs/SITEMAP.md" | sort -u | wc -l | tr -d ' ')
                if [ "${sitemap_screens:-0}" -ge 4 ] && [ "${screen_files:-0}" -eq 1 ]; then
                    # If only 1 file exists, check if it contains multi-screen views/tabs
                    single_html=$(find docs/design/screens -type f -name "*.html" | head -1)
                    if [ -f "$single_html" ] && ! grep -qiE "(data-screen|view-|tab-|screen-container|switchView|showScreen)" "$single_html"; then
                        echo "  ❌ Prototype coverage incomplete! SITEMAP defines ${sitemap_screens} screens, but docs/design/screens/ only has 1 screen file without multi-view switching."
                        echo "     Every core screen in SITEMAP.md must be prototyped in HTML (either multi-page HTML or an interactive SPA switcher) before entering M06 FE coding."
                        GATE_FAILED=1
                    else
                        echo "  ✅ Full prototype screen coverage verified (multi-view / multi-page prototype covers SITEMAP)"
                    fi
                fi
            fi
            # 6e. Modern Landing Page Section Depth Check (SCR-01)
            if [ -f "docs/specs/SITEMAP.md" ] && grep -qiE "SCR-01.*Landing|Landing.*Page" "docs/specs/SITEMAP.md"; then
                landing_has_sections=0
                if grep -qiE "FAQ|Frequently Asked|Mockup|Product (Preview|Tour|Showcase)|Calculator|Comparison" docs/specs/DESIGN_SPEC.md 2>/dev/null; then
                    landing_has_sections=1
                elif grep -qriE "FAQ|Frequently Asked|Mockup|Product (Preview|Tour|Showcase)|Calculator|Comparison" docs/design/screens 2>/dev/null; then
                    landing_has_sections=1
                fi
                if [ $landing_has_sections -eq 1 ]; then
                    echo "  ✅ Landing Page (SCR-01) multi-section depth verified (Product Preview/FAQ/Features)"
                else
                    echo "  ⚠️  Landing Page advisory: SCR-01 missing depth (Hero only). Standard SaaS landing pages require 6 sections: Hero, Product Preview Frame, Feature Deep Dives, ROI/Calculator, FAQ, and Footer."
                fi
            fi
            # 6f. Reusable Prototype Architecture Check (Shared CSS / Design System)
            shared_css=$(find docs/design -type f \( -name "*.css" -o -name "styles.css" -o -name "design-system.css" \) 2>/dev/null | wc -l | tr -d ' ')
            html_count=$(find docs/design/screens -type f -name "*.html" 2>/dev/null | wc -l | tr -d ' ')
            if [ "${html_count:-0}" -ge 2 ]; then
                if [ "${shared_css:-0}" -ge 1 ] || grep -qriE 'rel="stylesheet" href="[^"]*(\.css|styles|tailwind)' docs/design/screens 2>/dev/null; then
                    echo "  ✅ Reusable prototype architecture verified (screens utilize shared CSS/design-system)"
                else
                    echo "  ⚠️  Prototype advisory: multiple HTML screens detected without shared CSS. Ensure screens link to shared css/styles.css to maintain navbar, button, badge, and typography consistency across the sitemap."
                fi
            fi
            # 6g. Mechanical UI/UX Consistency Audit
            uiux_audit_script="${SCRIPT_DIR:-scripts/gates}/../../scripts/design/uiux_audit.py"
            if [ -n "$py" ] && [ -f "$uiux_audit_script" ]; then
                uiux_out="$("$py" "$uiux_audit_script" docs/design/screens 2>&1)"
                uiux_ec=$?
                if [ $uiux_ec -eq 0 ]; then
                    echo "  ✅ Mechanical UI/UX consistency audit PASSED"
                else
                    echo "  ⚠️  UI/UX consistency audit found items to fix. Run: python3 scripts/design/uiux_audit.py docs/design/screens/ --fix"
                fi
            fi
        else
            echo "  ❌ Interactive screen previews missing! Place HTML/component prototypes in docs/design/screens/."
            GATE_FAILED=1
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

        # 9. Visual Benchmark Side-by-Side Review Verification
        if [ -f "docs/specs/DESIGN_SPEC.md" ]; then
            if grep -qiE "Visual Benchmark Side-by-Side|Spatial & Grid Layout|Component Anatomy & Indicators" "docs/specs/DESIGN_SPEC.md"; then
                echo "  ✅ Visual Benchmark side-by-side review checklist verified in DESIGN_SPEC.md"
            fi
        fi

        # 10. Wireflow Interaction Scenarios (docs/specs/wireflows/*.md)
        scenario_count=$(find docs/specs/wireflows docs/design/scenarios -type f -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
        if [ "${scenario_count:-0}" -ge 1 ]; then
            echo "  ✅ Wireflow Interaction Scenarios verified (found ${scenario_count} scenario runbook(s) in docs/specs/wireflows/)"
        fi
    fi
}
