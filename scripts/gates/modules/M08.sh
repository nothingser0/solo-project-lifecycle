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
        # INTAKE_GATE.md and PROJECT_STATE_TEMPLATE.md define this field as yes|no, so
        # "no" (a greenfield project) must waive M08 — it previously matched nothing.
        case "$legacy_val" in
            no|n|false|greenfield|none)
            echo "  [INFO] Greenfield project detected (no legacy data): M08 Data Migration is WAIVED."
            is_m08_waived=1
            ;;
        esac
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
                check_sections "$plan_file" "Data Hygiene" "Mapping Matrix" "Masking Protocol"
                check_section_content "$plan_file" "Data Hygiene" "Mapping Matrix" "Masking Protocol"
            fi
        fi

        # E. A reconciliation that says only "PASSED" is an assertion, not evidence. Real
        # reconciliation counts rows per table: source, loaded, matched.
        # Only claim anything when the report is actually present; a missing file is reported by
        # check_required/check_optional, and the else-branch was printing a pass for an absent file.
        if [ -f docs/pm/MIGRATION_RECONCILIATION_REPORT.md ]; then
            if grep -qiE "^\|.*(row|baris).*(row|baris)|rows?[[:space:]]*:[[:space:]]*[0-9]+" docs/pm/MIGRATION_RECONCILIATION_REPORT.md; then
                echo "  ✅ Reconciliation report carries per-table row counts"
                # Numbers that disagree are the whole point of a reconciliation. A row whose source,
                # loaded or matched counts differ is an unresolved discrepancy, even if the document
                # says PASSED beside it - one lost row is invisible to every other check here.
                m08_mismatch=""
                while IFS='|' read -r _ tbl src loaded matched _rest; do
                    tbl=$(printf '%s' "$tbl" | tr -d ' *_`' | sed 's/[[:space:]]*$//')
                    src=$(printf '%s' "$src" | tr -d ' *_`,'); loaded=$(printf '%s' "$loaded" | tr -d ' *_`,'); matched=$(printf '%s' "$matched" | tr -d ' *_`,' 2>/dev/null)
                    case "$src$loaded$matched" in *[!0-9]*|"") continue ;; esac
                    [ -z "$src" ] && continue
                    if [ "$src" != "$loaded" ] || [ "$src" != "$matched" ]; then
                        m08_mismatch="$m08_mismatch ${tbl:-?}(src=$src loaded=$loaded matched=$matched)"
                    fi
                done < <(grep -E '^[[:space:]]*\|' docs/pm/MIGRATION_RECONCILIATION_REPORT.md || true)
                if [ -n "$m08_mismatch" ]; then
                    echo "  ❌ MIGRATION_RECONCILIATION_REPORT.md has row counts that do not agree:$m08_mismatch"
                    echo "     Source, loaded and matched must be equal per table; a difference is an unresolved discrepancy."
                    GATE_FAILED=1
                elif [ -z "$(grep -E '^[[:space:]]*\|[[:space:]]*[A-Za-z]' docs/pm/MIGRATION_RECONCILIATION_REPORT.md | grep -E '\|[[:space:]]*[0-9]+[[:space:]]*\|' || true)" ]; then
                    echo "  ❌ MIGRATION_RECONCILIATION_REPORT.md has no table row with numeric counts."
                    echo "     Add: | Table | Source rows | Loaded rows | Matched | with the measured numbers."
                    GATE_FAILED=1
                else
                    echo "  ✅ Reconciliation row counts agree for every table"
                fi
            else
                echo "  ❌ MIGRATION_RECONCILIATION_REPORT.md states no row counts - 'PASSED' without numbers is an opinion."
                echo "     Add a table: | Table | Source rows | Loaded rows | Matched | (counts, not adjectives)."
                GATE_FAILED=1
            fi
        fi

        # C+E. A mapping matrix that names no table from the schema is a table of words, and a
        # reconciliation that reports only the word PASSED proves nothing. Both are checked
        # against the DDL that M05 produced, when there is a schema to check against.
        if [ -f docs/specs/FSD.md ] || [ -f "docs/specs/PROJECT_LITE.md" ]; then
            ddl_src="docs/specs/FSD.md"
            [ -f "$ddl_src" ] || ddl_src="docs/specs/PROJECT_LITE.md"
            m08_tables=$(grep -oiE "CREATE TABLE (IF NOT EXISTS )?[\"\`]?[a-z_][a-z0-9_]*" "$ddl_src" 2>/dev/null \
                         | sed -E 's/.*(TABLE (IF NOT EXISTS )?)//' | tr -d '"\`' | tr '[:upper:]' '[:lower:]' | sort -u || true)
            if [ -n "$m08_tables" ]; then
                if grep -qiE "N/A[[:space:]]*[-—:].*(migration|migrasi|no data)|no data migration" "$plan_file"; then
                    echo "  ✅ Data migration marked N/A with a stated rationale"
                else
                    unmapped=""
                    for tb in $m08_tables; do
                        grep -qiE "(^|[^a-z0-9_])${tb}([^a-z0-9_]|$)" "$plan_file" || unmapped="$unmapped $tb"
                    done
                    if [ -n "$unmapped" ]; then
                        echo "  ❌ DATA_MIGRATION_PLAN.md never mentions these schema table(s):$unmapped"
                        echo "     The mapping matrix must map real columns from the DDL, or record 'N/A — no data migration' with a reason."
                        GATE_FAILED=1
                    else
                        echo "  ✅ Mapping matrix references the $(printf '%s\n' "$m08_tables" | grep -c .) schema table(s)"
                    fi
                fi
            fi
        fi

        # Client handover: the source data + credentials are the client's inputs.
        # '|| true' keeps the checklist running under 'set -e' so ALL failures print.
        check_client_inputs "$plan_file" "M08 Data Migration" || true
    # A migration that runs at all needs a reconciliation report: without one nobody has compared
    # the source with the target, whatever the scale. Large/Enterprise additionally carry a floor
    # on the report's size (500 bytes) because they owe a zero-discrepancy audit.
    m08_scale="$(get_field Scale docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
    if [ "$m08_scale" = "large" ] || [ "$m08_scale" = "enterprise" ]; then
        echo "  [INFO] Large/Enterprise scale detected: MIGRATION_RECONCILIATION_REPORT.md is MANDATORY."
        check_required "docs/pm/MIGRATION_RECONCILIATION_REPORT.md" "" 500
    else
        check_required "docs/pm/MIGRATION_RECONCILIATION_REPORT.md" "" 500
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
        # Client sign-off. This must not be conditional on wording: renaming the heading to
        # "Sign-Off" used to skip the check completely, so an unsigned migration closed cleanly.
        # Look for the sheet by structure (a sign-off / PIC heading) and then demand a real name
        # and a real signature in it - the template ships blanks in both colon and table-cell form.
        m08_sign=$(grep -iE "^#+[[:space:]]*.*(sign-?off|PIC|authori[sz]ed by client)" docs/pm/MIGRATION_RECONCILIATION_REPORT.md || true)
        if [ -z "$m08_sign" ]; then
            echo "  ❌ MIGRATION_RECONCILIATION_REPORT.md has no client sign-off section."
            echo "     A migration the client has not accepted is not reconciled; add the PIC sign-off sheet."
            GATE_FAILED=1
        else
            m08_blank=$(grep -nE '(_{3,}|\[ *\]|\.\.\.)' docs/pm/MIGRATION_RECONCILIATION_REPORT.md \
                        | grep -iE 'name|signature|PIC|date' || true)
            if [ -n "$m08_blank" ]; then
                echo "  ❌ MIGRATION_RECONCILIATION_REPORT.md sign-off is UNSIGNED: a name, signature or date is blank."
                echo "     $(printf '%s' "$m08_blank" | head -1 | cut -c1-90)"
                GATE_FAILED=1
            else
                # A person must be named in a DATA row. Matching any row with two wordy cells
                # accepted the header itself (`| Role | Name | Signature | Date |`), so a table
                # whose only filled data row was `| Reviewer | | | |` still passed. Compare the
                # cells against the column words and require a name that is not a column title.
                m08_named=0
                while IFS='|' read -r _ c1 c2 c3 c4 _rest; do
                    for cell in "$c1" "$c2" "$c3" "$c4"; do
                        cell=$(printf '%s' "$cell" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' | tr -d '*_`')
                        [ -z "$cell" ] && continue
                        case "$(printf '%s' "$cell" | tr '[:upper:]' '[:lower:]')" in
                            role|name|signature|date|title|reviewer|signed"") continue ;;
                        esac
                        if printf '%s' "$cell" | grep -qE '^[A-Za-z][A-Za-z.,'"'"' -]{2,}$'; then
                            m08_named=1
                        fi
                    done
                done < <(awk '/^#+[[:space:]]/ { insig = ($0 ~ /[Ss]ign-?[Oo]ff|[Pp][Ii][Cc]|[Aa]uthori[sz]ed by [Cc]lient/) ? 1 : 0 }
                               insig && /^[[:space:]]*\|/ {print}' \
                          docs/pm/MIGRATION_RECONCILIATION_REPORT.md || true)
                if [ "$m08_named" -ne 1 ]; then
                    echo "  ❌ MIGRATION_RECONCILIATION_REPORT.md sign-off names nobody: no person is recorded."
                    echo "     Name the client PIC who accepted the data; a header row is not a signatory."
                    GATE_FAILED=1
                else
                    echo "  ✅ Client Data Sign-Off records a named signatory with a signature"
                fi
        fi
        fi
    else
        echo "  [INFO] Data migration plan verified. Run reconciliation after seeding."
    fi
    fi
    echo ""
}
