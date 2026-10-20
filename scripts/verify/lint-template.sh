#!/usr/bin/env bash
# lint-template.sh - Validate template completeness
# Usage: ./scripts/verify/lint-template.sh docs/specs/PRD.md

set -e

TEMPLATE_FILE="${1:-}"

if [ -z "$TEMPLATE_FILE" ]; then
    echo "Usage: $0 <TEMPLATE_FILE>"
    echo "Example: $0 docs/specs/PRD.md"
    echo ""
    echo "Validates filled templates for required sections and placeholder text"
    exit 1
fi

if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "❌ File not found: $TEMPLATE_FILE"
    exit 1
fi

echo "🔍 Linting template: $TEMPLATE_FILE"
echo ""

ERRORS=0
WARNINGS=0

# Check for unfilled placeholders:
# If checking a raw template in templates/, intentional user placeholders like [Your Name] are valid.
# If checking a filled project document (e.g. docs/specs/PRD.md), all placeholders must be replaced.
IS_RAW_TEMPLATE=0
if [[ "$TEMPLATE_FILE" == *"templates/"* ]] || [[ "$TEMPLATE_FILE" == *"_TEMPLATE"* ]]; then
    IS_RAW_TEMPLATE=1
fi

# inline-code spans stripped: examples like `// TODO: x` are documentation, not placeholders
CLEAN_SCAN=$(mktemp)
sed 's/`[^`]*`//g' "$TEMPLATE_FILE" > "$CLEAN_SCAN"
trap 'rm -f "$CLEAN_SCAN"' EXIT

if [ $IS_RAW_TEMPLATE -eq 1 ]; then
    PLACEHOLDERS=$(grep -n "\[FILL\|PLACEHOLDER\|TODO:\|FIXME:\|XXX:\|<INSERT\|<DESCRIBE\|<LIST" "$CLEAN_SCAN" 2>/dev/null || true)
else
    PLACEHOLDERS=$(grep -nE "\[(FILL|Nama|isi|Your|Client|Company|Project|YYYY|Amount|[0-9]+%|[XYZ])[^]]*\]|PLACEHOLDER|TODO:|FIXME:|XXX:|<INSERT|<DESCRIBE|<LIST" "$CLEAN_SCAN" 2>/dev/null || true)
fi

if [ -n "$PLACEHOLDERS" ]; then
    echo "❌ Unfilled placeholders detected:"
    echo "$PLACEHOLDERS" | head -10
    ERRORS=$((ERRORS + 1))
    if [ $(echo "$PLACEHOLDERS" | wc -l) -gt 10 ]; then
        echo "   ... and $(($(echo "$PLACEHOLDERS" | wc -l) - 10)) more"
    fi
    echo ""
else
    echo "✅ No unfilled placeholders"
fi

# Check for Lorem Ipsum text
LOREM=$(grep -n "Lorem ipsum\|dolor sit amet" "$TEMPLATE_FILE" 2>/dev/null || true)
if [ -n "$LOREM" ]; then
    echo "⚠️  Lorem ipsum text found:"
    echo "$LOREM"
    WARNINGS=$((WARNINGS + 1))
    echo ""
fi

# Check for empty sections (headers followed immediately by header of same/higher level, ignoring subheadings)
EMPTY_SECTIONS=$(awk '
/^#+/ {
    match($0, /^#+/)
    curr_level = RLENGTH
    if (prev_header != "") {
        if (curr_level <= prev_level) {
            print prev_line ": " prev_header
        }
    }
    prev_header = $0
    prev_line = NR
    prev_level = curr_level
    next
}
{ if (prev_header != "" && NF > 0 && !/^---/) prev_header="" }
END { if (prev_header != "") print prev_line ": " prev_header }
' "$TEMPLATE_FILE")
if [ -n "$EMPTY_SECTIONS" ]; then
    echo "⚠️  Potentially empty sections:"
    echo "$EMPTY_SECTIONS"
    WARNINGS=$((WARNINGS + 1))
    echo ""
fi

# Template-specific checks based on filename
BASENAME=$(basename "$TEMPLATE_FILE")
case "$BASENAME" in
    PRD*.md)
        echo "=== PRD-specific checks ==="
        
        # Required PRD sections
        for section in "Functional" "Security"; do
            if grep -q "$section" "$TEMPLATE_FILE"; then
                echo "✅ Has section: $section"
            else
                echo "❌ Missing section: $section"
                ERRORS=$((ERRORS + 1))
            fi
        done
        echo ""
        ;;
        
    FSD*.md)
        echo "=== FSD-specific checks ==="
        
        # Required FSD sections
        for section in "Tech Stack" "Database Schema" "API Contract" "Security"; do
            if grep -q "$section" "$TEMPLATE_FILE"; then
                echo "✅ Has section: $section"
            else
                echo "❌ Missing section: $section"
                ERRORS=$((ERRORS + 1))
            fi
        done
        
        # Check for SQL schema
        if grep -q "CREATE TABLE\|ALTER TABLE" "$TEMPLATE_FILE"; then
            echo "✅ Contains SQL DDL"
        else
            echo "⚠️  No SQL DDL found"
            WARNINGS=$((WARNINGS + 1))
        fi
        echo ""
        ;;
        
    SOW*.md)
        echo "=== SOW-specific checks ==="
        
        # Check for payment terms
        if grep -E -iq "Termin|Payment (terms|milestone|schedule)|Down Payment|\bDP\b|Total Contract Value|Biaya Proyek" "$TEMPLATE_FILE"; then
            echo "✅ Payment terms defined"
        else
            echo "❌ Payment terms missing"
            ERRORS=$((ERRORS + 1))
        fi
        
        # Check for Single PIC
        if grep -q "Single PIC\|Penanggung Jawab" "$TEMPLATE_FILE"; then
            echo "✅ Single PIC clause present"
        else
            echo "⚠️  Single PIC not mentioned"
            WARNINGS=$((WARNINGS + 1))
        fi
        
        # Check for scope boundary
        if grep -iqE "In-Scope|In Scope|Out-of-Scope|Out of Scope|Ruang Lingkup" "$TEMPLATE_FILE"; then
            echo "✅ Scope boundary defined"
        else
            echo "❌ Scope boundary missing"
            ERRORS=$((ERRORS + 1))
        fi

        # M03 hard-blocker parity: validate-gate.sh M03 fails a SOW missing ANY of
        # these clauses, so a shipped template lacking one can never pass its own
        # gate. Catch it at lint time, before it reaches a project. Regression: the
        # consolidated SOW titled its sections so the gate's heading matcher missed
        # them; this lint pins the clause set independently of section titles.
        # '<<' separates the regex (which itself uses '|') from its label.
        while IFS= read -r pair; do
            [ -n "$pair" ] || continue
            pat="${pair%%<<*}"; label="${pair##*<<}"
            if grep -iqE "$pat" "$TEMPLATE_FILE"; then
                echo "✅ $label present"
            else
                echo "❌ $label missing (M03 gate hard blocker)"
                ERRORS=$((ERRORS + 1))
            fi
        done <<'CLAUSES'
Deemed Acceptance|Klien Diam<<Deemed Acceptance clause
Limitation of Liability|Liability Cap<<Limitation of Liability clause
Revision Limit|Maximum [0-9]+ (round|test cycle)<<Revision limits clause
Third-Party (Subscriptions|Accounts)|Client corporate name|registered under the Client|billed directly to the Client<<Third-party account ownership clause
Down Payment|30/40/30|50/50|Milestone.*Payment<<Payment terms & milestones
Gate Confirmation Log<<M03 Gate Confirmation Log
CLAUSES
        echo ""
        ;;
        
    BAST*.md)
        echo "=== BAST-specific checks ==="
        
        # Check for signature block
        if grep -q "Signature\|Tanda Tangan" "$TEMPLATE_FILE"; then
            echo "✅ Signature block present"
        else
            echo "❌ Signature block missing"
            ERRORS=$((ERRORS + 1))
        fi
        
        # Check for date
        if grep -q "Date:\|Tanggal:" "$TEMPLATE_FILE"; then
            echo "✅ Date field present"
        else
            echo "⚠️  Date field missing"
            WARNINGS=$((WARNINGS + 1))
        fi
        echo ""
        ;;
esac

# Check file size (warn if suspiciously small)
FILE_SIZE=$(wc -c < "$TEMPLATE_FILE")
if [ "$FILE_SIZE" -lt 500 ]; then
    echo "⚠️  File unusually small (< 500 bytes). Content complete?"
    WARNINGS=$((WARNINGS + 1))
fi

# Summary
echo "================================"
if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
    echo "✅ Template validation PASSED"
    echo "   File appears complete and ready for use"
    exit 0
elif [ "$ERRORS" -eq 0 ]; then
    echo "⚠️  Template validation PASSED with warnings"
    echo "   Errors: $ERRORS | Warnings: $WARNINGS"
    echo "   Review warnings before proceeding"
    exit 0
else
    echo "❌ Template validation FAILED"
    echo "   Errors: $ERRORS | Warnings: $WARNINGS"
    echo "   Fix errors before proceeding to next module"
    exit 1
fi
