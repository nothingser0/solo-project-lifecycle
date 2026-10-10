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
    echo "Available gates: M00..M13 (SDLC Modules) | A00..A04 (Enterprise Advisory Series)"
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
            if grep -q "\[\.\.\.\]\|\[X\]/mo\|\[Your Name\]\|\[Business Type\]\|\[Current tool\]\|\[Competitor A\]" "docs/pm/M00_LITE.md"; then
                echo "  ❌ Unresolved template placeholders [...] detected in M00_LITE.md!"
                GATE_FAILED=1
            fi
            # 3. Check real interview count (must be in table rows INT-0x, minimum 3 confirmed)
            real_interviews=$(grep -iE "\|\s*\*\*INT-0[1-5]\*\*\s*\|.*✅\s*Real" "docs/pm/M00_LITE.md" 2>/dev/null | wc -l || echo 0)
            real_interviews=$(echo "$real_interviews" | tr -d ' ')
            if [ "$real_interviews" -ge 3 ]; then
                echo "  ✅ Real user interviews verified in INT-0x rows: $real_interviews (>= 3 minimum confirmed)"
            else
                echo "  ❌ Insufficient real interviews: $real_interviews confirmed in INT-0x rows (< 3 confirmed with '✅ Real')"
                GATE_FAILED=1
            fi
            # 4. Check Waitlist Conversion rate is numeric and >= 5.0%
            wl_pct=$(grep -iE "Waitlist-Conversion-Pct:\s*[0-9.]+" "docs/pm/M00_LITE.md" 2>/dev/null | grep -oE "[0-9.]+" | head -1 || echo "")
            if [ -n "$wl_pct" ]; then
                is_low=$(awk -v val="$wl_pct" 'BEGIN { if (val < 5.0) print 1; else print 0 }' 2>/dev/null || echo 0)
                if [ "$is_low" -eq 1 ]; then
                    echo "  ❌ Waitlist-Conversion-Pct ($wl_pct%) is below minimum gate pass threshold (5.0%)!"
                    GATE_FAILED=1
                else
                    echo "  ✅ Waitlist conversion rate verified: $wl_pct% (>= 5.0% threshold)"
                fi
            else
                echo "  ❌ Waitlist-Conversion-Pct numeric percentage missing in M00_LITE.md!"
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
            if grep -q "\[\.\.\.\]\|\[Example:\|\[Your Name\]\|\[Direct Comp\|\[Adjacent Comp\|\[Segment 1:\|Rp \[X\]" "$brief_file"; then
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

            # 3. Dimension Floor & Score Integrity (all 4 dimensions REQUIRED, numeric, range 1.0-5.0, each >= 3.0)
            dim_ok=1
            dim_sum=0
            for dim in Technical Operational Regulatory Financial; do
                # Reject unedited placeholder form [3.0 - 5.0]
                if grep -qiE "^Feasibility-Score-${dim}:\s*\[" "$brief_file"; then
                    echo "  ❌ Feasibility-Score-${dim} still holds an unedited placeholder!"
                    dim_ok=0
                    GATE_FAILED=1
                    continue
                fi
                dim_val=$(grep -iE "^Feasibility-Score-${dim}:\s*[0-9]" "$brief_file" | grep -oE "[0-9]+(\.[0-9]+)?" | head -1 || echo "")
                if [ -z "$dim_val" ]; then
                    echo "  ❌ Missing numeric Feasibility-Score-${dim} (all 4 dimensions required, 1.0-5.0)"
                    dim_ok=0
                    GATE_FAILED=1
                    continue
                fi
                if [ "$(awk -v v="$dim_val" 'BEGIN { print (v >= 1.0 && v <= 5.0) ? 1 : 0 }')" -ne 1 ]; then
                    echo "  ❌ Feasibility-Score-${dim} out of range: $dim_val (must be 1.0-5.0)"
                    dim_ok=0
                    GATE_FAILED=1
                    continue
                fi
                if [ "$(awk -v v="$dim_val" 'BEGIN { print (v < 3.0) ? 1 : 0 }')" -eq 1 ]; then
                    echo "  ❌ Dimension Floor Failure: ${dim} = $dim_val (< 3.0)"
                    dim_ok=0
                    GATE_FAILED=1
                    continue
                fi
                dim_sum=$(awk -v a="$dim_sum" -v b="$dim_val" 'BEGIN { print a + b }')
            done
            if [ $dim_ok -eq 1 ]; then
                dim_avg=$(awk -v s="$dim_sum" 'BEGIN { printf "%.2f", s / 4 }')
                echo "  ✅ Dimension Floor verified: all 4 dimensions >= 3.0 (average $dim_avg)"
                # 4. Decision/average consistency: average < 3.5 MUST be CONDITIONAL_GO, not GO
                decision=$(grep -iE "^Feasibility-Decision:\s*(GO|CONDITIONAL_GO)" "$brief_file" | grep -oiE "CONDITIONAL_GO|GO" | head -1 | tr '[:lower:]' '[:upper:]')
                if [ -n "$decision" ] && [ "$decision" = "GO" ]; then
                    if [ "$(awk -v a="$dim_avg" 'BEGIN { print (a < 3.5) ? 1 : 0 }')" -eq 1 ]; then
                        echo "  ❌ Decision mismatch: average $dim_avg < 3.5 requires 'CONDITIONAL_GO', not 'GO'"
                        GATE_FAILED=1
                    fi
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

            # 3. Scope-Lock-Decision verification (BLOCKER)
            if grep -qiE "^Scope-Lock-Decision:\s*PENDING" "$scope"; then
                echo "  ❌ Scope lock status: PENDING (Scope not frozen; M02 cannot be closed)"
                GATE_FAILED=1
            elif grep -qiE "^Scope-Lock-Decision:\s*LOCKED" "$scope"; then
                echo "  ✅ Scope lock decision verified: LOCKED"
            else
                echo "  ❌ Explicit Scope-Lock-Decision (LOCKED | PENDING) not declared in SCOPE_STATEMENT.md!"
                GATE_FAILED=1
            fi

            # 4. P0 feature count within scale limits (strictly count | **F-xx** | rows)
            p0_count=$(grep -iE "\|\s*\*\*F-[0-9]+\*\*\s*\|.*(must|p0)" "$scope" 2>/dev/null | wc -l || true)
            p0_count=$(echo "$p0_count" | tr -d ' ')
            declared_scale=$(grep -iE "^\s*-?\s*Scale:" docs/pm/PROJECT_STATE.md 2>/dev/null | head -1 | grep -oiE "small|medium|large|enterprise|solo-saas" | head -1)
            case "$declared_scale" in
                small)      lo=3; hi=7 ;;
                medium|solo-saas) lo=8; hi=15 ;;
                large)      lo=16; hi=25 ;;
                *)          lo=3; hi=25 ;;
            esac
            echo "  [INFO] Declared scale: ${declared_scale:-unknown}; P0 feature rows (F-xx) counted: $p0_count (expected $lo-$hi)"
            if [ "$p0_count" -lt "$lo" ] || [ "$p0_count" -gt "$hi" ]; then
                echo "  ❌ P0 Must-Have count ($p0_count) outside scale '$declared_scale' limits ($lo-$hi). Prune scope or re-classify scale."
                GATE_FAILED=1
            else
                echo "  ✅ P0 Must-Have count within scale limits"
            fi

            # 5. Confidence Legend check (BLOCKER)
            if grep -q "✅" "$scope" || grep -qi "VERIFIED" "$scope"; then
                echo "  ✅ Data Confidence Legend / status markers present"
            else
                echo "  ❌ Data Confidence Legend [✅ / 🔶 / ❓] not declared!"
                GATE_FAILED=1
            fi

            # 6. Out-of-Scope exclusions check (strictly scoped within Section 5.2)
            if grep -qi "out-of-scope" "$scope"; then
                oos_section=$(sed -n '/### 5\.2 Out-of-Scope/,/### 5\.3/p' "$scope" 2>/dev/null || true)
                oos_count=$(echo "$oos_section" | grep -cE "^\s*[0-9]+\.\s" || true)
                if [ "${oos_count:-0}" -ge 3 ]; then
                    echo "  ✅ Explicit Out-of-Scope boundaries defined in Section 5.2 ($oos_count numbered exclusions)"
                else
                    echo "  ❌ Section 5.2 Out-of-Scope requires >= 3 explicit numbered exclusions (found: ${oos_count:-0})"
                    GATE_FAILED=1
                fi
            else
                echo "  ❌ Out-of-Scope boundary section missing!"
                GATE_FAILED=1
            fi

            # 7. RBAC Zero Self-Approval guardrail (Hard blocker on non-small projects)
            if grep -qiE "zero self-approval|no self-approval" "$scope"; then
                echo "  ✅ RBAC Zero Self-Approval guardrail present"
            else
                echo "  ❌ RBAC Zero Self-Approval guardrail (no self-approval for mutations/approvals) missing in SCOPE_STATEMENT.md!"
                GATE_FAILED=1
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
        [ -f "$target_sow" ] || target_sow="contracts/SOW_SMB.md"
        [ -f "$target_sow" ] || target_sow="docs/pm/SOW_SMB.md"
        
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
            # Accept standard SOW_CONTRACT or simplified SOW_SMB
            if [ -f "contracts/SOW_SMB.md" ] || [ -f "docs/pm/SOW_SMB.md" ]; then
                check_required "contracts/SOW_SMB.md" "docs/pm/SOW_SMB.md" 1000
            else
                check_required "contracts/SOW_CONTRACT.md" "docs/pm/SOW_CONTRACT.md" 1000
            fi

            # NDA is mandatory for Medium+ client delivery; optional for Small client
            is_small_client=0
            if grep -qiE "Scale:\s*small" docs/pm/PROJECT_STATE.md 2>/dev/null || ([ ! -f "docs/pm/PROJECT_STATE.md" ] && [ -f "PROJECT_LITE.md" ]); then
                is_small_client=1
            fi
            if [ $is_small_client -eq 1 ]; then
                check_optional "contracts/NDA.md" "docs/pm/NDA.md"
            else
                echo "  [INFO] Medium+ client delivery: NDA is MANDATORY before client data access."
                check_required "contracts/NDA.md" "docs/pm/NDA.md" 500
            fi
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
                # Must be an explicit [x] DP line AND state a clearing/received/transfer status
                if grep -qiE "\[x\][^\n]*(DP|Down Payment|30%|40%|50%)" "$target_sow" && \
                   grep -qiE "\[x\][^\n]*(Cleared|Received|Masuk|Lunas|Transferred|Settled|Bank Confirmed|Transfer Confirmed)" "$target_sow"; then
                    echo "  ✅ Down payment (DP) confirmation verified ([x] cleared & received in bank account)"
                else
                    echo "  ❌ Down payment (DP) not confirmed! Requires '[x] DP ... Cleared/Received/Transferred' (discussion-only or unchecked lines do NOT count)."
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

                # 7. Revision Limits clause is a HARD BLOCKER (solo dev anti infinite-revision trap)
                if grep -qiE "Revision Limit|Maximum\s+[0-9]+\s+round|Maximum\s+[0-9]+\s+test cycle|[0-9]+\s+rounds\b|[0-9]+\s+cycles\b" "$target_sow"; then
                    echo "  ✅ Revision limits clause present (design/UAT rounds capped)"
                else
                    echo "  ❌ Revision limits clause missing! Cap design revisions & UAT cycles to prevent infinite revision traps."
                    GATE_FAILED=1
                fi

                # 8. Third-Party Account Ownership is a HARD BLOCKER (client-owned infrastructure)
                if grep -qiE "Third-Party (Subscriptions|Accounts)|Client corporate name|registered under the Client|Client credit card|billed directly to the Client" "$target_sow"; then
                    echo "  ✅ Third-party account ownership clause present (client-owned infrastructure)"
                else
                    echo "  ❌ Third-party account ownership clause missing! Cloud/hosting/gateway accounts MUST be registered under the Client."
                    GATE_FAILED=1
                fi

                # 9. Enterprise scale requires approved Risk Assessment Matrix & RACI Matrix
                if grep -qiE "Scale:\s*enterprise" docs/pm/PROJECT_STATE.md 2>/dev/null; then
                    echo "  [INFO] Enterprise scale detected: Risk Assessment Matrix & RACI Matrix MANDATORY in M03."
                    check_required "docs/governance/RISK_ASSESSMENT_MATRIX.md" "docs/pm/RISK_REGISTER.md" 500
                    check_required "docs/governance/RACI_MATRIX.md" "docs/pm/RACI_MATRIX.md" 500
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
                echo "  ❌ docs/design/inspiration/notes.md (Prerequisite missing: winning benchmark selection not documented!)"
                GATE_FAILED=1
            fi
        else
            echo "  ❌ docs/design/inspiration/notes.md (MISSING)"
            GATE_FAILED=1
        fi
        min_sitemap=2000
        min_design_spec=2000
        if grep -qiE "Scale:\s*small" docs/pm/PROJECT_STATE.md 2>/dev/null || ([ ! -f "docs/pm/PROJECT_STATE.md" ] && [ -f "PROJECT_LITE.md" ]); then
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
                prompt_files=$(find docs/design/prompts -name "PROMPT.md" 2>/dev/null | wc -l | tr -d ' ')
                screen_files=$(find docs/design/screens -mindepth 2 -type f 2>/dev/null | wc -l | tr -d ' ')
                if [ "${prompt_files:-0}" -ge 1 ] && [ "${screen_files:-0}" -ge 1 ]; then
                    echo "  ✅ Per-screen outputs present (prompts: $prompt_files, screens: $screen_files)"
                else
                    echo "  ❌ Workflow $wf selected but per-screen outputs missing! Create docs/design/prompts/scr-xx/PROMPT.md and docs/design/screens/scr-xx/ for every screen."
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
        fi
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

        # Content verification for FSD.md (Medium & Large scales)
        if [ -f "docs/specs/FSD.md" ]; then
            fsd="docs/specs/FSD.md"

            # 1. Stack Decision LOCKED verification (BLOCKER)
            if grep -qiE "Stack Decision LOCKED:" "$fsd"; then
                echo "  ✅ Locked tech stack decision documented in FSD.md"
            else
                echo "  ❌ FSD.md missing locked tech stack decision ('Stack Decision LOCKED:')!"
                GATE_FAILED=1
            fi

            # 2. Database Schema DDL existence (BLOCKER)
            if grep -qiE "CREATE TABLE|mongoose\.Schema|models\.Model|Schema::create|model [A-Za-z]+ \{" "$fsd"; then
                echo "  ✅ Database schema definition verified in FSD.md (DDL / ORM models present)"
            else
                echo "  ❌ FSD.md missing explicit database schema definition (CREATE TABLE / ORM models)!"
                GATE_FAILED=1
            fi

            # 3. API Endpoints contract verification (Minimum 5 endpoints documented)
            ep_count=$(grep -iE "####\s*(GET|POST|PUT|PATCH|DELETE)|Route::(get|post|put|delete)|@(Get|Post|Put|Delete)Mapping|path:\s*/api" "$fsd" 2>/dev/null | wc -l || echo 0)
            ep_count=$(echo "$ep_count" | tr -d ' ')
            if [ "${ep_count:-0}" -ge 5 ]; then
                echo "  ✅ API endpoint contracts verified ($ep_count endpoints documented)"
            else
                echo "  ❌ FSD.md insufficient API endpoint contracts: found only ${ep_count:-0} endpoints (minimum 5 required)!"
                GATE_FAILED=1
            fi

            # 4. Idempotency Key table verification for financial/mutation systems
            if grep -qiE "financial|pembayaran|payment|saldo|transaksi|checkout|order" docs/pm/PROJECT_STATE.md 2>/dev/null; then
                if grep -qiE "idempotency_keys|idempotency" "$fsd"; then
                    echo "  ✅ Idempotency protection schema verified in FSD.md (idempotency_keys table present)"
                else
                    echo "  ❌ FSD.md missing idempotency_keys table for financial/mutation project!"
                    GATE_FAILED=1
                fi
            fi
        fi

        # Architecture Decision Record is MANDATORY for Medium+ (justify architectural style choices)
        if grep -qiE "Scale:\s*(medium|large|enterprise)" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            echo "  [INFO] Medium+ scale detected: Architecture Decision Record (ADR) is MANDATORY."
            check_required "docs/governance/ADR.md" "docs/specs/ADR.md" 500
        fi

        if grep -qiE "Scale:\s*enterprise" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            echo "  [INFO] Enterprise scale detected: ADR and Audit Trail Specs are MANDATORY."
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
        is_m07_waived=0
        if grep -qiE "Scale:\s*small" docs/pm/PROJECT_STATE.md 2>/dev/null || ([ ! -f "docs/pm/PROJECT_STATE.md" ] && [ -f "PROJECT_LITE.md" ]); then
            echo "  [INFO] Small Scale detected: M07 QA & SIT is WAIVED (Security absorbed in M06, UAT in M09-LITE)."
            is_m07_waived=1
        fi

        if [ $is_m07_waived -eq 1 ]; then
            check_optional "docs/qa/SIT_WORKBOOK.md"
        else
        check_required "docs/qa/SIT_WORKBOOK.md"
        if grep -qiE "Scale:\s*(large|enterprise)" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            echo "  [INFO] Large / Enterprise scale detected: Security Audit is MANDATORY."
            check_required "docs/qa/SECURITY_AUDIT.md" "docs/qa/SECURITY_AUDIT_REPORT.md"
        else
            check_optional "docs/qa/SECURITY_AUDIT.md" "docs/qa/SECURITY_AUDIT_REPORT.md"
        fi
        fi
        ;;
    M08)
        echo "=== M08: Data Migration & Seeding Gate Checklist ==="
        # Automatic waiver for Small Scale (legacy data triggers re-classification to Large per SKILL.md)
        is_m08_waived=0
        if grep -qiE "Scale:\s*small" docs/pm/PROJECT_STATE.md 2>/dev/null || ([ ! -f "docs/pm/PROJECT_STATE.md" ] && [ -f "PROJECT_LITE.md" ]); then
            echo "  [INFO] Small Scale detected: M08 Data Migration is WAIVED (Legacy data triggers re-classification to Large)."
            is_m08_waived=1
        fi

        if [ $is_m08_waived -eq 1 ]; then
            check_optional "docs/pm/DATA_MIGRATION_PLAN.md"
        else
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
        fi
        echo ""
        ;;
    M09)
        echo "=== M09: Validation Gate (UAT Sign-Off) Checklist ==="
        is_m09_solo=0
        if grep -qiE "Delivery:\s*(solo|portfolio|internal)" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            is_m09_solo=1
        elif grep -qiE "Delivery:\s*client" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            is_m09_solo=0 # Client delivery NEVER waives UAT regardless of scale
        elif [ -f "docs/pm/M00_LITE.md" ] || grep -qiE "Scale:\s*(solo-saas|internal)" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            is_m09_solo=1
        fi

        if [ $is_m09_solo -eq 1 ]; then
            echo "  [INFO] Solo SaaS / Internal project detected: M09 Client UAT is WAIVED (Self-testing)."
            check_optional "docs/pm/UAT_SIGNOFF_REPORT.md" "docs/qa/UAT_SIGNOFF.md"
        else
            # Accept standard UAT_SIGNOFF_REPORT or lightweight UAT_SIGNOFF_SMALL
            target_uat="docs/pm/UAT_SIGNOFF_REPORT.md"
            [ -f "$target_uat" ] || target_uat="docs/qa/UAT_SIGNOFF.md"
            [ -f "$target_uat" ] || target_uat="docs/qa/UAT_SIGNOFF_SMALL.md"
            [ -f "$target_uat" ] || target_uat="docs/pm/UAT_SIGNOFF_SMALL.md"

            if [ -f "$target_uat" ]; then
                check_required "$target_uat" "" 300
            else
                check_required "docs/pm/UAT_SIGNOFF_REPORT.md" "docs/qa/UAT_SIGNOFF.md" 500
            fi
        fi
        check_optional "docs/qa/UAT_WORKBOOK.md"
        if [ -f "docs/pm/UAT_SIGNOFF_REPORT.md" ] || [ -f "docs/qa/UAT_SIGNOFF.md" ] || [ -f "docs/qa/UAT_SIGNOFF_SMALL.md" ] || [ -f "docs/pm/UAT_SIGNOFF_SMALL.md" ]; then
            target_uat="docs/pm/UAT_SIGNOFF_REPORT.md"
            [ -f "$target_uat" ] || target_uat="docs/qa/UAT_SIGNOFF.md"
            [ -f "$target_uat" ] || target_uat="docs/qa/UAT_SIGNOFF_SMALL.md"
            [ -f "$target_uat" ] || target_uat="docs/pm/UAT_SIGNOFF_SMALL.md"
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
        # For Large scale, emergency rollback plan is MANDATORY
        if grep -qiE "Scale:\s*(large|enterprise)" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            echo "  [INFO] Large / Enterprise scale detected: Emergency Rollback Plan is MANDATORY."
            check_required "docs/pm/ROLLBACK_PLAN.md" "docs/ROLLBACK_PLAN.md" 500
        else
        check_optional "docs/ROLLBACK_PLAN.md" "docs/pm/ROLLBACK_PLAN.md"
        fi
        ;;
    M11)
        echo "=== M11: Handover & BAST Gate Checklist ==="
        is_m11_solo=0
        if grep -qiE "Delivery:\s*(solo|portfolio|internal)" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            is_m11_solo=1
        elif grep -qiE "Delivery:\s*client" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            is_m11_solo=0 # Client delivery NEVER waives BAST handover regardless of scale
        elif [ -f "docs/pm/M00_LITE.md" ] || grep -qiE "Scale:\s*(solo-saas|internal)" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            is_m11_solo=1
        fi

        if [ $is_m11_solo -eq 1 ]; then
            echo "  [INFO] Solo SaaS / Internal project detected: M11 Client BAST Handover is WAIVED."
            check_optional "docs/pm/BAST.md" "contracts/BAST.md"
        else
            # Accept standard BAST.md or lightweight BAST_EMAIL_SMALL.md
            target_bast="docs/pm/BAST.md"
            [ -f "$target_bast" ] || target_bast="contracts/BAST.md"
            [ -f "$target_bast" ] || target_bast="docs/pm/BAST_EMAIL_SMALL.md"
            [ -f "$target_bast" ] || target_bast="contracts/BAST_EMAIL_SMALL.md"

            if [ -f "$target_bast" ]; then
                check_required "$target_bast" "" 200
            else
                check_required "docs/pm/BAST.md" "contracts/BAST.md" 500
            fi

            # For Large scale, technical handover protocol is MANDATORY
            if grep -qiE "Scale:\s*(large|enterprise)" docs/pm/PROJECT_STATE.md 2>/dev/null; then
                echo "  [INFO] Large / Enterprise scale detected: Technical Handover Protocol is MANDATORY."
                check_required "docs/pm/HANDOVER_PROTOCOL.md" "docs/HANDOVER_PROTOCOL.md" 500
            fi
        fi
        check_optional "docs/pm/GO_LIVE_REPORT.md"
        check_optional "docs/pm/HANDOVER_PROTOCOL.md" "docs/HANDOVER_PROTOCOL.md"
        check_optional "docs/USER_MANUAL.md"
        echo ""
        echo "⚠️  DO NOT transfer repo/credentials until 100% payment confirmed"
        ;;
    M12)
        echo "=== M12: Warranty SLA Retainer Gate Checklist ==="
        is_m12_solo=0
        if grep -qiE "Delivery:\s*(solo|portfolio|internal)" docs/pm/PROJECT_STATE.md 2>/dev/null || ([ ! -f "docs/pm/PROJECT_STATE.md" ] && [ -f "PROJECT_LITE.md" ]); then
            is_m12_solo=1
        elif [ -f "docs/pm/M00_LITE.md" ] || grep -qiE "Scale:\s*(solo-saas|internal)" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            is_m12_solo=1
        fi

        if [ $is_m12_solo -eq 1 ]; then
            echo "  [INFO] Solo/Internal project detected: RUNBOOK_OPS.md accepted in place of WARRANTY_POLICY.md"
            check_required "docs/pm/RUNBOOK_OPS.md" "docs/pm/WARRANTY_POLICY.md" 500
        else
            check_required "docs/pm/WARRANTY_POLICY.md" "" 500
        fi
        check_optional "docs/pm/SLA_RETAINER_CONTRACT.md" "contracts/SLA_RETAINER.md"
        # For Large scale, emergency incident response plan is MANDATORY
        if grep -qiE "Scale:\s*(large|enterprise)" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            echo "  [INFO] Large / Enterprise scale detected: Incident Response Plan is MANDATORY."
            check_required "docs/pm/INCIDENT_RESPONSE.md" "docs/INCIDENT_RESPONSE.md" 500
        else
        check_optional "docs/pm/INCIDENT_RESPONSE.md" "docs/INCIDENT_RESPONSE.md"
        fi
        ;;
    M13)
        echo "=== M13: Product Operations & Iteration Gate Checklist ==="
        # M13 is a Continuous Product Loop for SELF-INITIATED products only.
        # Small Scale terminates at M12; Client delivery terminates at M11/M12.
        is_m13_waived=0
        if grep -qiE "Delivery:\s*(client|portfolio|internal)" docs/pm/PROJECT_STATE.md 2>/dev/null; then
            echo "  [INFO] Client/Internal/Portfolio delivery detected: M13 Product Iteration is WAIVED (lifecycle ends at M11/M12)."
            is_m13_waived=1
        elif grep -qiE "Scale:\s*small" docs/pm/PROJECT_STATE.md 2>/dev/null || ([ ! -f "docs/pm/PROJECT_STATE.md" ] && [ -f "PROJECT_LITE.md" ]); then
            echo "  [INFO] Small Scale detected: M13 Product Iteration is WAIVED (Fast-Track ends at M12)."
            is_m13_waived=1
        fi

        if [ $is_m13_waived -eq 1 ]; then
            check_optional "docs/analytics/METRICS_BASELINE_REPORT.md" "docs/pm/METRICS_BASELINE_REPORT.md"
        else
            check_required "docs/analytics/METRICS_BASELINE_REPORT.md" "docs/pm/METRICS_BASELINE_REPORT.md"
            # For Large scale, RICE-scored growth experiment backlog is MANDATORY
            if grep -qiE "Scale:\s*(large|enterprise)" docs/pm/PROJECT_STATE.md 2>/dev/null; then
                echo "  [INFO] Large / Enterprise scale detected: Growth Experiments Backlog is MANDATORY."
                check_required "docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md" "" 500
            else
                check_optional "docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md"
            fi
        fi
        ;;
    # =========================================================================
    # Enterprise Advisory Series (A00 - A04): Non-Solo Capacity Lifecycle
    # =========================================================================
    A00)
        echo "=== A00: Bid/No-Bid & Commercial Clearance Checklist ==="
        check_required "contracts/CONSULTING_AGREEMENT.md" "docs/pm/CONSULTING_AGREEMENT.md" 1000
        check_optional "docs/pm/RFP_RESPONSE.md"
        ;;
    A01)
        echo "=== A01: WBS Phasing & Domain Decomposition Checklist ==="
        check_required "docs/pm/WBS_PHASING_PLAN.md" "" 1000
        ;;
    A02)
        echo "=== A02: C4 Enterprise Architecture & STRIDE Threat Modeling Checklist ==="
        check_required "docs/architecture/ENTERPRISE_ARCHITECTURE_BLUEPRINT.md" "docs/specs/ARCHITECTURE_BLUEPRINT.md" 1000
        check_required "docs/security/THREAT_MODEL_STRIDE.md" "docs/specs/THREAT_MODEL.md" 1000
        ;;
    A03)
        echo "=== A03: Vendor Procurement & Build-vs-Buy Evaluation Checklist ==="
        check_required "docs/procurement/VENDOR_PROCUREMENT_SCHEDULE.md" "docs/specs/VENDOR_PROCUREMENT_SCHEDULE.md" 800
        check_required "docs/governance/VENDOR_COMPARISON_MATRIX.md" "docs/pm/VENDOR_COMPARISON_MATRIX.md" 500
        ;;
    A04)
        echo "=== A04: Governance Handover & Architecture Conformance Retainer Checklist ==="
        check_required "docs/governance/GOVERNANCE_HANDOVER_PACK.md" "docs/pm/GOVERNANCE_HANDOVER_PACK.md" 1000
        ;;
    *)
        echo "❌ Unknown gate: $GATE_MODULE"
        echo "Available gates: M00..M13 (SDLC Modules) | A00..A04 (Enterprise Advisory Series)"
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
