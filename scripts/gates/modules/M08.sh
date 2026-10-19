#!/usr/bin/env bash
# Gate: M08 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_M08 ------------------------------------------------------
gate_M08() {
    echo "=== M08: Data Migration & Seeding Gate Checklist ==="
    # Automatic waiver for Small Scale (legacy data triggers re-classification to Large per SKILL.md)
    # or Greenfield projects explicitly declared in Intake (Legacy Data: None/No).
    is_m08_waived=0
    if is_small_scale; then
        echo "  [INFO] Small Scale detected: M08 Data Migration is WAIVED (Legacy data triggers re-classification to Large)."
        is_m08_waived=1
    elif [ -f "docs/pm/PROJECT_STATE.md" ]; then
        legacy_val="$(get_field "Intake-Legacy-Core" docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
        [ -z "$legacy_val" ] && legacy_val="$(get_field "Legacy Data" docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
        if [ "$legacy_val" = "greenfield" ] || [ "$legacy_val" = "none" ]; then
            echo "  [INFO] Greenfield project detected (no legacy data): M08 Data Migration is WAIVED."
            is_m08_waived=1
        fi
    fi

    if [ $is_m08_waived -eq 1 ]; then
        check_optional "docs/pm/DATA_MIGRATION_PLAN.md" "docs/pm/DATA_MIGRATION_LITE.md"
    else
        check_required "docs/pm/DATA_MIGRATION_PLAN.md" "docs/pm/DATA_MIGRATION_LITE.md" 1000
        local plan_file="docs/pm/DATA_MIGRATION_PLAN.md"
        [ -f "$plan_file" ] || plan_file="docs/pm/DATA_MIGRATION_LITE.md"

        # Content verification: reject raw template placeholders in data migration plan
        if [ -f "$plan_file" ]; then
            # The Inputs-Received line carries its own dedicated check (check_client_inputs,
            # which names the exact fix). Grepping it here too would report one omission twice.
            if grep -vE "Inputs[- ]Received|Client[- ]Provided|Received from client|Handover received" "$plan_file" \
                | grep -qE "\[Your Name\]|\[Application Name\]|\[Client Company|\[YYYY-MM-DD\]"; then
                echo "  ❌ $plan_file still contains unresolved template placeholders ([...])!"
                GATE_FAILED=1
            fi
            # Section check for full migration plan
            if [ "$plan_file" = "docs/pm/DATA_MIGRATION_PLAN.md" ]; then
                check_sections "$plan_file" "Data Hygiene" "Mapping Matrix" "Masking Protocol" || true
            fi
        fi

        # Client handover: the source data + credentials are the client's inputs.
        # '|| true' keeps the checklist running under 'set -e' so ALL failures print.
        check_client_inputs "$plan_file" "M08 Data Migration" || true
    # For Large/Enterprise scale, reconciliation report is MANDATORY (zero-discrepancy audit)
    m08_scale="$(get_field Scale docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
    if [ "$m08_scale" = "large" ] || [ "$m08_scale" = "enterprise" ]; then
        echo "  [INFO] Large/Enterprise scale detected: MIGRATION_RECONCILIATION_REPORT.md is MANDATORY."
        check_required "docs/pm/MIGRATION_RECONCILIATION_REPORT.md" "" 500
    else
        check_optional "docs/pm/MIGRATION_RECONCILIATION_REPORT.md"
    fi
    if [ -f "docs/pm/MIGRATION_RECONCILIATION_REPORT.md" ]; then
        # Content verification: reject raw template placeholders in reconciliation report
        if grep -qE "\[Your Name\]|\[Application Name\]|\[YYYY-MM-DD\]|\[Source_File_Name" "docs/pm/MIGRATION_RECONCILIATION_REPORT.md"; then
            echo "  ❌ docs/pm/MIGRATION_RECONCILIATION_REPORT.md still contains unresolved template placeholders ([...])!"
            GATE_FAILED=1
        fi
        # Content verification (BLOCKER): must not report FAILED or DISCREPANCY
        if grep -qiE "FAILED|RECONCILIATION DISCREPANCY|UNRESOLVED DISCREPANCY|Status[[:space:]]*:[[:space:]]*FAIL" "docs/pm/MIGRATION_RECONCILIATION_REPORT.md"; then
            echo "  ❌ docs/pm/MIGRATION_RECONCILIATION_REPORT.md reports migration failure or discrepancy! Cannot close M08."
            GATE_FAILED=1
        elif grep -qiE "PASSED|RECONCILED|100%|SUCCESS|Zero Discrepancy|RECONCILIATION PASS" "docs/pm/MIGRATION_RECONCILIATION_REPORT.md"; then
            echo "  ✅ Data migration reconciliation verified (Audit PASSED)"
        else
            echo "  ❌ Migration reconciliation report missing explicit PASSED/RECONCILED attestation!"
            GATE_FAILED=1
        fi
        # Verification of Client Single PIC Sign-off (M08 §6 exit criteria): signature must not be blank placeholder
        if grep -qiE "Client Single PIC|Authorized by Client" "docs/pm/MIGRATION_RECONCILIATION_REPORT.md"; then
            if grep -qiE "Name[[:space:]]*:[[:space:]]*_{3,}|Signature[[:space:]]*:[[:space:]]*_{3,}|Signature[[:space:]]*:[[:space:]]*\|[[:space:]]*$" "docs/pm/MIGRATION_RECONCILIATION_REPORT.md"; then
                echo "  ❌ docs/pm/MIGRATION_RECONCILIATION_REPORT.md sign-off sheet has unfulfilled blank signature lines (______ / unassigned PIC)!"
                GATE_FAILED=1
            else
                echo "  ✅ Client Single PIC Data Sign-Off signature recorded"
            fi
        fi
    else
        echo "  [INFO] Data migration plan verified. Run reconciliation after seeding."
    fi
    fi
    echo ""
}
