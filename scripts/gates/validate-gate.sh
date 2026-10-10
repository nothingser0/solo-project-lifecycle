#!/usr/bin/env bash
# validate-gate.sh - Gate checkpoint validation for solo-project-lifecycle
# Usage: ./scripts/gates/validate-gate.sh <MODULE_ID>

set -e

GATE_MODULE="${1:-}"
GATE_FAILED=0

if [ -z "$GATE_MODULE" ]; then
    echo "Usage: $0 <MODULE_ID>"
    echo "Example: $0 M03"
    echo ""
    echo "Available gates: M00, M01, M02, M03, M04, M05, M06, M07, M08, M09, M10, M11, M12, M13"
    exit 1
fi

echo "🔍 Validating Gate: $GATE_MODULE"
echo "============================================================"

check_required() {
    local file="$1"
    local alt="$2"
    local min_size="${3:-200}" # Default min_size: 200 bytes (anti-stub)
    local target=""
    if [ -f "$file" ]; then
        target="$file"
    elif [ -n "$alt" ] && [ -f "$alt" ]; then
        target="$alt"
    fi

    if [ -n "$target" ]; then
        local size=0
        # Portable file size extraction
        size=$(wc -c < "$target" 2>/dev/null || stat -c%s "$target" 2>/dev/null || echo 0)
        size=$(echo "$size" | tr -d ' ')
        if [ "$size" -lt "$min_size" ]; then
            echo "  ❌ $target (TOO SMALL: ${size}B < ${min_size}B minimum required)"
            GATE_FAILED=1
        else
            echo "  ✅ $target (${size}B >= ${min_size}B)"
        fi
    else
        echo "  ❌ $file (MISSING)"
        GATE_FAILED=1
    fi
}

check_optional() {
    local file="$1"
    local alt="$2"
    if [ -f "$file" ]; then
        echo "  [OK] $file (optional)"
    elif [ -n "$alt" ] && [ -f "$alt" ]; then
        echo "  [OK] $alt (optional)"
    else
        echo "  ⚠️  $file (optional, not found)"
    fi
}

case "$GATE_MODULE" in
    M00)
        echo "=== M00: Product Discovery & Strategy Gate Checklist ==="
        # 1. Check if M00 is WAIVED by Scale (small) or Delivery (client/internal/portfolio)
        is_m00_waived=0
        if grep -qiE "Scale:\s*small" docs/pm/PROJECT_STATE.md 2>/dev/null || ([ ! -f "docs/pm/PROJECT_STATE.md" ] && [ -f "PROJECT_LITE.md" ]); then
            echo "  [INFO] Small Scale detected: M00 Product Discovery is WAIVED (Handled by Intake Gate)."
            is_m00_waived=1
        elif grep -qiE "Delivery:\s*(client|internal|portfolio)" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            echo "  [INFO] Client / Internal / Portfolio delivery: M00 Product Discovery is WAIVED (Scope pre-defined)."
            is_m00_waived=1
        fi

        if [ $is_m00_waived -eq 1 ]; then
            check_optional "docs/pm/M00_LITE.md" "docs/pm/MARKET_RESEARCH.md"
        elif [ -f "docs/pm/M00_LITE.md" ]; then
            echo "  [INFO] Detected M00-lite rapid validation path (Solo SaaS)"
            check_required "docs/pm/M00_LITE.md" "" 1000
            # 1. Blocking decision check: must explicitly be Gate-Decision: PASS
            if grep -qiE "^Gate-Decision:\s*PENDING|\[x\]\s*⏳\s*PENDING" "docs/pm/M00_LITE.md"; then
                echo "  ❌ Gate status: PENDING_PRIMARY_RESEARCH (Real human research pending; M00 cannot be closed)"
                GATE_FAILED=1
            elif grep -qiE "^Gate-Decision:\s*FAIL|^Gate-Decision:\s*PIVOT|\[x\]\s*❌\s*(PIVOT|STOP)" "docs/pm/M00_LITE.md"; then
                echo "  ❌ Gate status: FAIL / PIVOT (Market validation kill criteria triggered)"
                GATE_FAILED=1
            elif grep -qiE "^Gate-Decision:\s*PASS|\[x\]\s*✅\s*PASS" "docs/pm/M00_LITE.md"; then
                echo "  ✅ Gate decision verified: PASS"
            else
                echo "  ❌ Explicit Gate-Decision (PASS|PENDING|FAIL) not declared!"
                GATE_FAILED=1
            fi
            # 2. Check for unresolved template placeholders [...]
            if grep -q "\[\.\.\.\]\|\[X\]/mo\|\[Your Name\]" "docs/pm/M00_LITE.md"; then
                echo "  ❌ Unresolved template placeholders [...] detected in M00_LITE.md!"
                GATE_FAILED=1
            fi
            # 3. Check real interview count (minimum 3 real interviews confirmed)
            real_interviews=$(grep -c "✅ Real" "docs/pm/M00_LITE.md" 2>/dev/null || echo 0)
            if [ "$real_interviews" -ge 3 ]; then
                echo "  ✅ Real interviews verified: $real_interviews (>= 3 minimum confirmed)"
            else
                echo "  ❌ Insufficient real interviews: $real_interviews (< 3 confirmed with '✅ Real')"
                GATE_FAILED=1
            fi
        else
            check_required "docs/pm/MARKET_RESEARCH.md" "" 1500
            check_required "docs/pm/COMPETITIVE_LANDSCAPE.md" "docs/pm/COMPETITOR_ANALYSIS.md" 1500
            check_required "docs/pm/USER_RESEARCH_REPORT.md" "" 1500
            check_required "docs/pm/PRODUCT_STRATEGY.md" "" 1500

            # 1. Reject template placeholders in all Full M00 docs
            for doc in "docs/pm/MARKET_RESEARCH.md" "docs/pm/COMPETITIVE_LANDSCAPE.md" "docs/pm/USER_RESEARCH_REPORT.md" "docs/pm/PRODUCT_STRATEGY.md"; do
                if [ -f "$doc" ] && grep -q "\[\.\.\.\]" "$doc"; then
                    echo "  ❌ Unresolved template placeholders [...] detected in $doc!"
                    GATE_FAILED=1
                fi
            done

            # 2. Verify MARKET_RESEARCH.md cites live sources and verification dates
            if [ -f "docs/pm/MARKET_RESEARCH.md" ]; then
                if grep -qiE "https?://" "docs/pm/MARKET_RESEARCH.md" && grep -qiE "Verified:|Tahun 20|202[0-9]-[0-9]{2}-[0-9]{2}" "docs/pm/MARKET_RESEARCH.md"; then
                    echo "  ✅ Market research sources and verification dates verified"
                else
                    echo "  ❌ MARKET_RESEARCH.md must cite live source URLs (https://) and verification dates!"
                    GATE_FAILED=1
                fi
            fi

            # 3. Verify USER_RESEARCH_REPORT.md structured decision & numeric intent
            if [ -f "docs/pm/USER_RESEARCH_REPORT.md" ]; then
                if grep -qiE "^Gate-Decision:\s*PENDING|PENDING_PRIMARY_RESEARCH" "docs/pm/USER_RESEARCH_REPORT.md"; then
                    echo "  ❌ Gate status: PENDING_PRIMARY_RESEARCH (Real user data pending; synthetic data prohibited)"
                    GATE_FAILED=1
                elif grep -qiE "^Gate-Decision:\s*FAIL" "docs/pm/USER_RESEARCH_REPORT.md"; then
                    echo "  ❌ Gate status: FAIL (Market research thresholds not met)"
                    GATE_FAILED=1
                elif grep -qiE "^Gate-Decision:\s*PASS" "docs/pm/USER_RESEARCH_REPORT.md"; then
                    echo "  ✅ Gate decision verified: PASS"
                else
                    echo "  ❌ Explicit Gate-Decision (PASS|PENDING|FAIL) not declared in USER_RESEARCH_REPORT.md!"
                    GATE_FAILED=1
                fi
            fi

            # 4. Hands-on competitor testing is a MANDATORY BLOCKER
            if [ -f "docs/pm/COMPETITIVE_LANDSCAPE.md" ]; then
                if grep -qiE "Test Date|Tanggal Uji|Onboarding Time|Waktu Onboarding" "docs/pm/COMPETITIVE_LANDSCAPE.md"; then
                    echo "  ✅ Hands-on competitor testing evidence verified"
                else
                    echo "  ❌ Hands-on competitor testing evidence (Test Date / Onboarding Time) missing in COMPETITIVE_LANDSCAPE.md!"
                    GATE_FAILED=1
                fi
            fi
        fi
        ;;
    M01)
        echo "=== M01: Idea Feasibility Gate Checklist ==="
        # 1. Automatic waiver for Small Scale (handled via Intake Gate + PROJECT_LITE.md)
        is_m01_waived=0
        if grep -qiE "Scale:\s*small" docs/pm/PROJECT_STATE.md 2>/dev/null || ([ ! -f "docs/pm/PROJECT_STATE.md" ] && [ -f "PROJECT_LITE.md" ]); then
            echo "  [INFO] Small Scale detected: M01 Idea Feasibility is WAIVED (Handled by Intake Gate & PROJECT_LITE)."
            is_m01_waived=1
        fi

        if [ $is_m01_waived -eq 1 ]; then
            check_optional "docs/pm/IDEA_BRIEF.md" "PROJECT_LITE.md"
        else
            check_required "docs/pm/IDEA_BRIEF.md" "docs/pm/FEASIBILITY_REPORT.md" 1000
            check_required "docs/pm/PROJECT_STATE.md" "" 200

            # 2. Execute Solo Capacity Classifier (High-Water Mark enforcement)
            if [ -f "scripts/gates/classify-scale.sh" ]; then
                echo "  [INFO] Running mechanical scale & solo capacity classifier..."
                classify_output=$(bash scripts/gates/classify-scale.sh 2>&1) || classify_exit=$?
                classify_exit=${classify_exit:-0}
                if [ "$classify_exit" -eq 2 ]; then
                    echo "  ❌ SOLO CAPACITY GATE TRIGGERED: Project exceeds solo developer capacity!"
                    echo "$classify_output" | sed "s/^/    /"
                    GATE_FAILED=1
                else
                    echo "  ✅ Solo capacity verified: Scope is executable within solo capacity"
                fi
            fi

        # Target file resolution
        brief_file="docs/pm/IDEA_BRIEF.md"
        [ -f "$brief_file" ] || brief_file="docs/pm/FEASIBILITY_REPORT.md"

        if [ -f "$brief_file" ]; then
            # 1. Reject template placeholders [...]
            if grep -q "\[\.\.\.\]\|\[Example:\|\[Your Name\]" "$brief_file"; then
                echo "  ❌ Unresolved template placeholders [...] detected in $brief_file!"
                GATE_FAILED=1
            fi

            # 2. Blocking Feasibility Decision check
            if grep -qiE "^Feasibility-Decision:\s*KILL|\[x\]\s*\*\*KILL\*\*" "$brief_file"; then
                echo "  ❌ Gate status: KILL (Fatal single-point blocker; project terminated)"
                GATE_FAILED=1
            elif grep -qiE "^Feasibility-Decision:\s*PIVOT|\[x\]\s*\*\*PIVOT\*\*" "$brief_file"; then
                echo "  ❌ Gate status: PIVOT (Idea feasibility rejected; return to M00 or restructure scope)"
                GATE_FAILED=1
            elif grep -qiE "^Feasibility-Decision:\s*(GO|CONDITIONAL_GO)|\[x\]\s*\*\*(GO|CONDITIONAL GO)\*\*" "$brief_file"; then
                echo "  ✅ Feasibility decision verified: GO / CONDITIONAL_GO"
            else
                echo "  ❌ Explicit Feasibility-Decision (GO | CONDITIONAL_GO | PIVOT | KILL) not declared!"
                GATE_FAILED=1
            fi

            # 3. Dimension Floor Verification (Every individual dimension must be >= 3.0)
            if grep -qiE "^Feasibility-Score-(Technical|Operational|Regulatory|Financial):\s*[0-2](\.[0-9]+)?" "$brief_file"; then
                echo "  ❌ Dimension Floor Failure: Individual dimension score < 3.0 detected!"
                GATE_FAILED=1
            else
                if grep -qiE "^Feasibility-Score-(Technical|Operational|Regulatory|Financial):" "$brief_file"; then
                    echo "  ✅ Dimension Floor verified: All individual dimensions >= 3.0"
                fi
            fi
        fi

        # 4. Intake Gate: reject if mandatory intake fields are empty or UNKNOWN
        if [ -f "docs/pm/PROJECT_STATE.md" ]; then
            for field in "Delivery:" "Intake-Success-Metric:" "Intake-P0-Features:" "Intake-Time-Capacity:" "Intake-Sensitive-Data:"; do
                if grep -qiE "^\s*-?\s*$field\s*(UNKNOWN|\[|$)" "docs/pm/PROJECT_STATE.md"; then
                    echo "  ❌ Intake field incomplete or UNKNOWN: $field"
                    GATE_FAILED=1
                fi
            done
            if grep -qiE "^\s*-?\s*Intake-Status:\s*ANSWERED" "docs/pm/PROJECT_STATE.md"; then
                echo "  ✅ Intake Gate: all 5 mandatory fields answered"
            else
                echo "  ❌ Intake Gate: Intake-Status not set to ANSWERED"
                GATE_FAILED=1
            fi
        fi
        fi # end of is_m01_waived else branch
        ;;
    M02)
        echo "=== M02: Discovery & Scope Gate Checklist ==="
        # 1. Automatic waiver for Small Scale (handled via Intake Gate + PROJECT_LITE.md)
        is_m02_waived=0
        if grep -qiE "Scale:\s*small" docs/pm/PROJECT_STATE.md 2>/dev/null || ([ ! -f "docs/pm/PROJECT_STATE.md" ] && [ -f "PROJECT_LITE.md" ]); then
            echo "  [INFO] Small Scale detected: M02 Discovery & Scope is WAIVED (Handled by Intake Gate & PROJECT_LITE)."
            is_m02_waived=1
        fi

        if [ $is_m02_waived -eq 1 ]; then
            check_optional "docs/pm/SCOPE_STATEMENT.md" "PROJECT_LITE.md"
        else
            check_required "docs/pm/SCOPE_STATEMENT.md" "" 2000
        if grep -qiE "Scale:\s*enterprise" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            echo "  [INFO] Enterprise scale detected: RACI Matrix is MANDATORY."
            check_required "docs/governance/RACI_MATRIX.md" "docs/pm/RACI_MATRIX.md"
        fi
        if [ -f "docs/pm/SCOPE_STATEMENT.md" ]; then
            scope="docs/pm/SCOPE_STATEMENT.md"

            # 1. Reject unresolved template placeholders [...]
            if grep -q "\[\.\.\.\]\|\[Feature [0-9]\|\[Application / System Name\]" "$scope"; then
                echo "  ❌ Unresolved template placeholders [...] detected in SCOPE_STATEMENT.md!"
                GATE_FAILED=1
            fi

            # 2. Ambiguity detection on Must-Have rows
            if grep -iE "\|.*(must|p0).*\|" "$scope" | grep -qiE "TBD|maybe|if time permits|tentative|TBA"; then
                echo "  ❌ Ambiguous terms (TBD/maybe/if time permits) detected in Must-Have scope rows!"
                GATE_FAILED=1
            else
                echo "  ✅ Zero ambiguous terms in Must-Have scope rows"
            fi

            # 3. P0 feature count within scale limits (mechanical)
            p0_count=$(grep -icE "\|.*(must|p0).*\|" "$scope" || true)
            declared_scale=$(grep -iE "^\s*-?\s*Scale:" docs/pm/PROJECT_STATE.md 2>/dev/null | head -1 | grep -oiE "small|medium|large|enterprise|solo-saas" | head -1)
            case "$declared_scale" in
                small)      lo=3; hi=7 ;;
                medium|solo-saas) lo=8; hi=15 ;;
                large)      lo=16; hi=25 ;;
                *)          lo=3; hi=25 ;;
            esac
            echo "  [INFO] Declared scale: ${declared_scale:-unknown}; P0 rows counted: $p0_count (expected $lo-$hi)"
            if [ "$p0_count" -lt "$lo" ] || [ "$p0_count" -gt "$hi" ]; then
                echo "  ❌ P0 Must-Have count ($p0_count) outside scale '$declared_scale' limits ($lo-$hi). Prune scope or re-classify scale."
                GATE_FAILED=1
            else
                echo "  ✅ P0 Must-Have count within scale limits"
            fi

            # 4. Confidence Legend check (BLOCKER)
            if grep -q "✅" "$scope" || grep -qi "VERIFIED" "$scope"; then
                echo "  ✅ Data Confidence Legend / status markers present"
            else
                echo "  ❌ Data Confidence Legend [✅ / 🔶 / ❓] not declared!"
                GATE_FAILED=1
            fi

            # 5. Out-of-Scope exclusions check (BLOCKER, require >= 3 concrete items)
            if grep -qi "out-of-scope" "$scope"; then
                oos_count=$(grep -cE "^\s*[0-9]+\.\s" "$scope" || true)
                if [ "${oos_count:-0}" -ge 3 ]; then
                    echo "  ✅ Explicit Out-of-Scope boundaries defined ($oos_count numbered exclusions)"
                else
                    echo "  ❌ Out-of-Scope section requires >= 3 explicit numbered exclusions (found: ${oos_count:-0})"
                    GATE_FAILED=1
                fi
            else
                echo "  ❌ Out-of-Scope boundary section missing!"
                GATE_FAILED=1
            fi

            # 6. RBAC Zero Self-Approval guardrail
            if grep -qiE "zero self-approval|no self-approval" "$scope"; then
                echo "  ✅ RBAC Zero Self-Approval guardrail present"
            else
                echo "  ⚠️  RBAC Zero Self-Approval guardrail not explicitly stated"
            fi
        fi
        # 7. Company/team projects require STAKEHOLDER_MAP, COMMUNICATION_PLAN, RACI
        if grep -qiE "Delivery:\s*(client|internal)" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            echo "  [INFO] Company/client delivery: Stakeholder & Communication docs MANDATORY."
            check_required "docs/pm/STAKEHOLDER_MAP.md" "" 500
            check_required "docs/pm/COMMUNICATION_PLAN.md" "" 500
        fi
        fi # end of is_m02_waived else
        ;;
    M03)
        echo "=== M03: Legal SOW & Charter Checklist ==="
        target_sow="contracts/SOW_CONTRACT.md"
        [ -f "$target_sow" ] || target_sow="docs/pm/SOW_CONTRACT.md"
        
        IS_SOLO=0
        # STRICT DELIVERY ROUTING: Only bypass if Delivery is explicitly solo, portfolio, or internal
        if grep -qiE "Delivery:\s*(solo|portfolio|internal)" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            IS_SOLO=1
        elif grep -qiE "Delivery:\s*client" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            IS_SOLO=0 # Client delivery NEVER bypasses SOW regardless of scale
        elif [ ! -f "$target_sow" ] && [ -f "docs/pm/M00_LITE.md" ]; then
            IS_SOLO=1
        fi

        if [ $IS_SOLO -eq 1 ]; then
            echo "  [INFO] Solo SaaS / Internal project detected: Commercial SOW gate is WAIVED."
            check_optional "contracts/SOW_CONTRACT.md" "docs/pm/SOW_CONTRACT.md"
        else
            check_required "contracts/SOW_CONTRACT.md" "docs/pm/SOW_CONTRACT.md" 1000
            check_optional "contracts/NDA.md" "docs/pm/NDA.md"
            if [ -f "$target_sow" ]; then
                # 1. Check unresolved placeholders [...]
                if grep -q "\[\.\.\.\]\|\[Numeric Amount\]\|\[Account Number\]" "$target_sow"; then
                    echo "  ❌ Unresolved template placeholders [...] detected in SOW contract!"
                    GATE_FAILED=1
                fi

                # 2. Payment terms & milestones
                if grep -qiE "Termin|Milestone.*Payment|Down Payment|DP|30/40/30|50/50" "$target_sow"; then
                    echo "  ✅ Payment terms & milestone schedule defined"
                else
                    echo "  ❌ Payment terms not clearly defined!"
                    GATE_FAILED=1
                fi

                # 3. Down payment confirmation is a HARD BLOCKER for client projects
                if grep -qiE "\[x\]\s*(DP|Down Payment|30%|40%|50%|Cleared|Received)" "$target_sow"; then
                    echo "  ✅ Down payment (DP) confirmation verified ([x] cleared)"
                else
                    echo "  ❌ Down payment (DP) not confirmed! Marked [x] received required before M04."
                    GATE_FAILED=1
                fi

                # 4. Single PIC is a HARD BLOCKER
                if grep -qi "Single PIC" "$target_sow"; then
                    echo "  ✅ Single PIC clause present"
                else
                    echo "  ❌ Single PIC clause missing!"
                    GATE_FAILED=1
                fi

                # 5. Deemed Acceptance is a HARD BLOCKER
                if grep -qiE "Deemed Acceptance|Klien Diam" "$target_sow"; then
                    echo "  ✅ Deemed acceptance clause verified (Anti-ghosting protection)"
                else
                    echo "  ❌ Deemed acceptance clause (7-day feedback limit) missing in SOW contract!"
                    GATE_FAILED=1
                fi

                # 6. Limitation of Liability is a HARD BLOCKER
                if grep -qiE "Limitation of Liability|Liability Cap" "$target_sow"; then
                    echo "  ✅ Limitation of liability clause present"
                else
                    echo "  ❌ Limitation of liability clause missing in SOW contract!"
                    GATE_FAILED=1
                fi

                # 7. Enterprise scale requires approved Risk Assessment Matrix
                if grep -qiE "Scale:\s*enterprise" docs/pm/PROJECT_STATE.md 2>/dev/null; then
                    echo "  [INFO] Enterprise scale detected: Risk Assessment Matrix is MANDATORY in M03."
                    check_required "docs/governance/RISK_ASSESSMENT_MATRIX.md" "docs/pm/RISK_REGISTER.md" 500
                fi
            fi
            echo ""
            echo "⚠️  DO NOT proceed to M04 until DP confirmed in bank account (or bypassed for Solo SaaS)"
        fi
        ;;
    M04)
        echo "=== M04: UI/UX Prototyping Gate Checklist ==="
        # Universal: All scales MUST have components, design inspiration, logo, design tokens, and screen specs
        # 1. Strict Prerequisite: Logo asset must exist in assets/logo/ (logo.svg or logo.png)
        min_logo=200
        if grep -qiE "Scale:\s*small" docs/pm/PROJECT_STATE.md 2>/dev/null || ([ ! -f "docs/pm/PROJECT_STATE.md" ] && [ -f "PROJECT_LITE.md" ]); then
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

        # 2. Strict Prerequisite: Design inspiration notes MUST cite selected benchmark and logo alignment
        if [ -f "docs/design/inspiration/notes.md" ]; then
            if grep -qiE "Selected.*Benchmark|Winning Reference|Primary Benchmark|Paling OK" "docs/design/inspiration/notes.md"; then
                echo "  ✅ docs/design/inspiration/notes.md (Benchmark selection verified)"
            else
                echo "  ⚠️  docs/design/inspiration/notes.md (Warning: explicit winning benchmark selection not detected)"
            fi
        fi
        check_required "docs/specs/SITEMAP.md" "" 2000
        check_required "docs/specs/COMPONENT_REQUIREMENTS.md" "" 1000
        check_required "docs/specs/LOGO_DESIGN_BRIEF.md" "" 200
        check_required "docs/design/inspiration/notes.md" "" 200
        check_required "DESIGN.md" "docs/harness-root/DESIGN.md" 1000
        check_required "docs/specs/DESIGN_SPEC.md" "" 2000
        ;;
    M05)
        echo "=== M05: Architecture & Specs Gate Checklist ==="
        if grep -qiE "Scale:\s*small" docs/pm/PROJECT_STATE.md 2>/dev/null || ([ ! -f "docs/pm/PROJECT_STATE.md" ] && [ -f "PROJECT_LITE.md" ]); then
            echo "  [INFO] Detected Small-Scale Fast-Track MVP path (PROJECT_LITE.md)"
            check_required "PROJECT_LITE.md" "" 1000
            if [ -f "PROJECT_LITE.md" ]; then
                if grep -iE "^\s*-\s*Feature|^\s*[0-9]+\.\s*\*\*\[Feature" "PROJECT_LITE.md" | grep -qiE "TBD|maybe|tentative|TBA|if time permits"; then
                    echo "  ❌ Ambiguous terms (TBD/maybe/tentative) detected in PROJECT_LITE.md Must-Have features!"
                    GATE_FAILED=1
                else
                    echo "  ✅ Zero ambiguous terms in PROJECT_LITE.md Must-Have features"
                fi
            fi
            check_optional "docs/specs/PRD.md"
            check_optional "docs/specs/FSD.md"
        else
        check_required "docs/specs/PRD.md" "" 2000
        check_required "docs/specs/FSD.md" "" 2000
        if grep -qiE "Scale:\s*enterprise" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            echo "  [INFO] Enterprise scale detected: ADR and Audit Trail Specs are MANDATORY."
            check_required "docs/governance/ADR.md" "docs/specs/ADR.md"
            check_required "docs/governance/AUDIT_TRAIL_REQUIREMENTS.md" "docs/specs/AUDIT_TRAIL_REQUIREMENTS.md"
        fi
        check_optional "PROJECT_LITE.md"
        fi
        ;;
    M06)
        echo "=== M06: Development Execution Gate Checklist ==="
        check_required "AGENTS.md" "" 500
        check_required "CONTEXT.md" "" 500
        check_required "TODO.md" "" 500
        # Small scale absorbs M07 security (Opsi A): security checklist is part of M06 exit.
        if grep -qiE "Scale:\s*small" docs/pm/PROJECT_STATE.md 2>/dev/null || ([ ! -f "docs/pm/PROJECT_STATE.md" ] && [ -f "PROJECT_LITE.md" ]); then
            echo "  [INFO] Small scale: SECURITY_CHECKLIST_SMALL.md absorbed into M06 (M07 folded)."
            check_required "docs/qa/SECURITY_CHECKLIST_SMALL.md" "SECURITY_CHECKLIST_SMALL.md" 300
        fi
        # RUNBOOK_LOCAL.md / VERIFY_LOCAL.md are root harness files; resolve any accepted location.
        runbook_path="RUNBOOK_LOCAL.md"
        for candidate in "RUNBOOK_LOCAL.md" "docs/RUNBOOK_LOCAL.md" "docs/specs/RUNBOOK_LOCAL.md"; do
            if [ -f "$candidate" ]; then runbook_path="$candidate"; break; fi
        done
        check_required "$runbook_path" "" 500
        verify_path="VERIFY_LOCAL.md"
        for candidate in "VERIFY_LOCAL.md" "docs/VERIFY_LOCAL.md" "docs/specs/VERIFY_LOCAL.md"; do
            if [ -f "$candidate" ]; then verify_path="$candidate"; break; fi
        done
        check_required "$verify_path" "" 500
        check_optional "ARCHITECTURE.md"
        check_optional "CONVENTIONS.md"
        ;;
    M07)
        echo "=== M07: Quality Assurance & SIT Gate Checklist (medium+ only) ==="
        # NOTE: Small scale does NOT run M07; security is folded into M06.
        check_required "docs/qa/SIT_WORKBOOK.md"
        if grep -qiE "Scale:\s*(large|enterprise)" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            echo "  [INFO] Large / Enterprise scale detected: Security Audit is MANDATORY."
            check_required "docs/qa/SECURITY_AUDIT.md" "docs/qa/SECURITY_AUDIT_REPORT.md"
        else
            check_optional "docs/qa/SECURITY_AUDIT.md" "docs/qa/SECURITY_AUDIT_REPORT.md"
        fi
        ;;
    M08)
        echo "=== M08: Data Migration & Seeding Gate Checklist ==="
        check_required "docs/pm/DATA_MIGRATION_PLAN.md" "" 1000
        # For Large/Enterprise scale, reconciliation report is MANDATORY (zero-discrepancy audit)
        if grep -qiE "Scale:\s*(large|enterprise)" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            echo "  [INFO] Large/Enterprise scale detected: MIGRATION_RECONCILIATION_REPORT.md is MANDATORY."
            check_required "docs/pm/MIGRATION_RECONCILIATION_REPORT.md" "" 500
        else
            check_optional "docs/pm/MIGRATION_RECONCILIATION_REPORT.md"
        fi
        if [ -f "docs/pm/MIGRATION_RECONCILIATION_REPORT.md" ]; then
            if grep -qiE "PASSED|RECONCILED|100%|SUCCESS|Zero Discrepancy" docs/pm/MIGRATION_RECONCILIATION_REPORT.md; then
                echo "  ✅ Data migration reconciliation verified (Audit PASSED)"
            else
                echo "  ⚠️  Migration reconciliation not marked as PASSED/RECONCILED!"
            fi
        else
            echo "  [INFO] Data migration plan verified. Run reconciliation after seeding."
        fi
        echo ""
        ;;
    M09)
        echo "=== M09: Validation Gate (UAT Sign-Off) Checklist ==="
        if [ -f "docs/pm/M00_LITE.md" ] || grep -qiE "Delivery:\s*(solo|portfolio|internal)" docs/pm/PROJECT_STATE.md 2>/dev/null || grep -qiE "Scale:\s*(solo-saas|small|internal)" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            echo "  [INFO] Solo SaaS / Internal project detected: M09 Client UAT is WAIVED (Self-testing)."
            check_optional "docs/pm/UAT_SIGNOFF_REPORT.md" "docs/qa/UAT_SIGNOFF.md"
        else
        check_required "docs/pm/UAT_SIGNOFF_REPORT.md" "docs/qa/UAT_SIGNOFF.md"
        fi
        check_optional "docs/qa/UAT_WORKBOOK.md"
        if [ -f "docs/pm/UAT_SIGNOFF_REPORT.md" ] || [ -f "docs/qa/UAT_SIGNOFF.md" ]; then
            target_uat="docs/pm/UAT_SIGNOFF_REPORT.md"
            [ -f "$target_uat" ] || target_uat="docs/qa/UAT_SIGNOFF.md"
            if grep -q "APPROVED\|PASSED\|Accepted" "$target_uat"; then
                echo "  ✅ UAT approved status detected"
            else
                echo "  ⚠️  UAT approved status not clearly found"
            fi
        fi
        echo ""
        echo "⚠️  DO NOT deploy to production until UAT signed"
        ;;
    M10)
        echo "=== M10: Deployment Production Gate Checklist ==="
        check_required "docs/DEPLOYMENT_PROTOCOL.md" "docs/pm/DEPLOYMENT_PROTOCOL.md" 1000
        check_required "docs/pm/GO_LIVE_REPORT.md" "docs/GO_LIVE_REPORT.md" 500
        # Check HTTP status 200 if URL present in GO_LIVE_REPORT.md
        live_report="docs/pm/GO_LIVE_REPORT.md"
        [ -f "$live_report" ] || live_report="docs/GO_LIVE_REPORT.md"
        if [ -f "$live_report" ]; then
            prod_url=$(grep -iE "Production URL|Live URL|URL Live" "$live_report" | grep -oE "https?://[^ ]+" | head -1 || echo "")
            if [ -n "$prod_url" ] && command -v curl >/dev/null 2>&1; then
                echo "  [INFO] Probing Production URL: $prod_url"
                http_code=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "$prod_url" 2>/dev/null || echo "000")
                if [ "$http_code" = "200" ] || [ "$http_code" = "301" ] || [ "$http_code" = "302" ]; then
                    echo "  ✅ Production URL responded with HTTP $http_code (Verified LIVE)"
                else
                    echo "  ⚠️  Production URL probe returned HTTP $http_code (Check deployment connectivity)"
                fi
            fi
        fi
        if grep -qiE "Scale:\s*enterprise" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            echo "  [INFO] Enterprise scale detected: CAB Approval is MANDATORY."
            check_required "docs/governance/CAB_APPROVAL.md" "docs/pm/CAB_APPROVAL.md"
        fi
        check_optional "docs/ROLLBACK_PLAN.md" "docs/pm/ROLLBACK_PLAN.md"
        ;;
    M11)
        echo "=== M11: Handover & BAST Gate Checklist ==="
        if [ -f "docs/pm/M00_LITE.md" ] || grep -qiE "Delivery:\s*(solo|portfolio|internal)" docs/pm/PROJECT_STATE.md 2>/dev/null || grep -qiE "Scale:\s*(solo-saas|small|internal)" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            echo "  [INFO] Solo SaaS / Internal project detected: M11 Client BAST Handover is WAIVED."
            check_optional "docs/pm/BAST.md" "contracts/BAST.md"
        else
        check_required "docs/pm/BAST.md" "contracts/BAST.md"
        fi
        check_optional "docs/pm/GO_LIVE_REPORT.md"
        check_optional "docs/pm/HANDOVER_PROTOCOL.md" "docs/HANDOVER_PROTOCOL.md"
        check_optional "docs/USER_MANUAL.md"
        echo ""
        echo "⚠️  DO NOT transfer repo/credentials until 100% payment confirmed"
        ;;
    M12)
        echo "=== M12: Warranty SLA Retainer Gate Checklist ==="
        if grep -qiE "Delivery:\s*(solo|portfolio|internal)" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            echo "  [INFO] Solo/Internal project detected: RUNBOOK_OPS.md accepted in place of WARRANTY_POLICY.md"
            check_required "docs/pm/RUNBOOK_OPS.md" "docs/pm/WARRANTY_POLICY.md" 500
        else
            check_required "docs/pm/WARRANTY_POLICY.md" "" 500
        fi
        check_optional "docs/pm/SLA_RETAINER_CONTRACT.md" "contracts/SLA_RETAINER.md"
        check_optional "docs/pm/INCIDENT_RESPONSE.md" "docs/INCIDENT_RESPONSE.md"
        ;;
    M13)
        echo "=== M13: Product Operations & Iteration Gate Checklist ==="
        check_required "docs/pm/METRICS_BASELINE_REPORT.md" "docs/analytics/METRICS_BASELINE_REPORT.md"
        check_optional "docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md"
        ;;
    *)
        echo "❌ Unknown gate: $GATE_MODULE"
        echo "Available gates: M00, M01, M02, M03, M04, M05, M06, M07, M08, M09, M10, M11, M12, M13"
        exit 1
        ;;
esac

echo ""
echo "============================================================"
if [ $GATE_FAILED -eq 1 ]; then
    echo "❌ Gate validation FAILED - missing mandatory artifacts"
    exit 1
else
    echo "✅ Gate validation PASSED"
    exit 0
fi
