#!/usr/bin/env bash
# ==============================================================================
# verify-all.sh - Repository Integrity & Sanity Checker
# Validates shell script syntax, module files, and critical template presence.
# ==============================================================================

set -e

# Resolve the repo root from THIS script, then work from there.
# Without this, every relative path below (scripts/*, docs/modules/*, SKILL.md)
# resolved against the caller's cwd — so invoking the script by absolute path
# from any other directory reported the entire repo as "missing".
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$ROOT_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Solo Project Lifecycle Integrity Check ===${NC}"
echo ""

ERRORS=0
SKIPPED=0

# 1. Verify Shell Scripts Syntax
echo "1. Checking bash scripts syntax..."
for script in scripts/*/*.sh scripts/*/*/*.sh templates/04-dev-execution/*.sh templates/04-dev-execution/scripts/*.sh templates/06-qa-uat/fixtures/*.sh; do
    if [ -f "$script" ]; then
        if bash -n "$script" 2>/dev/null; then
            echo -e "  ${GREEN}✓${NC} $script"
        else
            echo -e "  ${RED}✗${NC} Syntax error in $script"
            ERRORS=$((ERRORS + 1))
        fi
    fi
done

# 1b. Merge-conflict markers anywhere in the tree.
# A conflict marker is never valid committed content, and one nested inside a bash
# gate is worse than a lint error: it is a syntax error that silently disables the
# WHOLE gate (every M05 check became unreachable, so a failing project would read
# as "no missing artifacts"). The marker guard is the cheapest possible catch.
echo ""
echo "1b. Checking for merge-conflict markers..."
CONFLICT_HITS="$(grep -rlE '^(<<<<<<< |=======$|>>>>>>> )' \
    --include='*.sh' --include='*.ps1' --include='*.md' --include='*.js' --include='*.ts' \
    --include='*.json' --include='*.yml' --include='*.yaml' --include='*.html' --include='*.css' \
    . 2>/dev/null | grep -v '^\./\.git/' || true)"
if [ -z "$CONFLICT_HITS" ]; then
    echo -e "  ${GREEN}✓${NC} no merge-conflict markers in tracked content"
else
    echo -e "  ${RED}✗${NC} merge-conflict markers found (resolve before committing):"
    echo "$CONFLICT_HITS" | sed 's/^/       /'
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "1c. Checking for leaked absolute paths..."
if node --version >/dev/null 2>&1; then
    if node scripts/verify/verify-no-absolute-paths.js; then
        :
    else
        ERRORS=$((ERRORS + 1))
    fi
else
    echo -e "  ${YELLOW}\u26a0${NC}  skipped \u2014 node is not executable from this shell"
    SKIPPED=$((SKIPPED + 1))
fi
echo ""
echo "1d. Checking scaffold parity (.sh vs .ps1)..."
if node --version >/dev/null 2>&1; then
    if node scripts/verify/verify-scaffold-parity.js; then
        :
    else
        ERRORS=$((ERRORS + 1))
    fi
else
    echo -e "  ${YELLOW}\u26a0${NC}  skipped \u2014 node is not executable from this shell"
    SKIPPED=$((SKIPPED + 1))
fi

# 2. Verify 14 Modules Presence (M00 - M13)
echo ""
echo "2. Checking 14 Lifecycle Modules (docs/modules/)..."
MODULES=(
    "00_PRODUCT_DISCOVERY_STRATEGY.md"
    "01_IDEA_FEASIBILITY.md"
    "02_DISCOVERY_SCOPE.md"
    "03_LEGAL_SOW_CHARTER.md"
    "04_UIUX_PROTOTYPING.md"
    "05_ARCHITECTURE_SPECS.md"
    "06_DEVELOPMENT_EXECUTION.md"
    "07_QUALITY_ASSURANCE_SIT.md"
    "08_DATA_MIGRATION_SEEDING.md"
    "09_UAT_CLIENT_SIGNOFF.md"
    "10_DEPLOYMENT_PRODUCTION.md"
    "11_HANDOVER_BAST.md"
    "12_WARRANTY_SLA_RETAINER.md"
    "13_PRODUCT_OPERATIONS_ITERATION.md"
)

for mod in "${MODULES[@]}"; do
    if [ -f "docs/modules/$mod" ]; then
        echo -e "  ${GREEN}✓${NC} docs/modules/$mod"
    else
        echo -e "  ${RED}✗${NC} Missing docs/modules/$mod"
        ERRORS=$((ERRORS + 1))
    fi
done

# 3. Verify Key Index Files
echo ""
echo "3. Checking Root & Directory Catalogs..."
KEY_FILES=(
    "README.md"
    "SKILL.md"
    "docs/README.md"
    "docs/modules/README.md"
    "templates/README.md"
    "patterns/README.md"
    "references/README.md"
    "scripts/README.md"
    "case-studies/README.md"
    "evals/README.md"
)

for kf in "${KEY_FILES[@]}"; do
    if [ -f "$kf" ]; then
        echo -e "  ${GREEN}✓${NC} $kf"
    else
        echo -e "  ${RED}✗${NC} Missing $kf"
        ERRORS=$((ERRORS + 1))
    fi
done

# 4. Verify Case Studies Presence (01 - 05)
echo ""
echo "4. Checking Case Studies..."
CASE_STUDIES=(
    "01_MVP_SAAS_INVENTORY.md"
    "02_ECOMMERCE_FASHION_MVP.md"
    "03_CRM_REAL_ESTATE_INTERNAL.md"
    "04_MEDIUM_B2B_SAAS_WORKED_EXAMPLE.md"
    "05_LARGE_SYSTEM_INTEGRATION_WORKED_EXAMPLE.md"
)
for cs in "${CASE_STUDIES[@]}"; do
    if [ -f "case-studies/$cs" ]; then
        echo -e "  ${GREEN}✓${NC} case-studies/$cs"
    else
        echo -e "  ${RED}✗${NC} Missing case-studies/$cs"
        ERRORS=$((ERRORS + 1))
    fi
done

# 5. Verify Patterns Presence (4 active Indonesia/domain-specific + archived generics)
echo ""
echo "5. Checking Patterns..."
PATTERNS=(
    "patterns/payments/INDONESIA_PAYMENT_GATEWAYS.md"
    "patterns/compliance/UU_PDP_COMPLIANCE.md"
    "patterns/offline/OFFLINE_FIRST_SYNC.md"
    "patterns/localization/I18N_INDONESIA.md"
    "patterns/architecture/SOLO_ARCHITECTURE_GUARDRAILS.md"
)
for pat in "${PATTERNS[@]}"; do
    if [ -f "$pat" ]; then
        echo -e "  ${GREEN}✓${NC} $pat"
    else
        echo -e "  ${RED}✗${NC} Missing $pat"
        ERRORS=$((ERRORS + 1))
    fi
done
# Archived generic patterns (present under archive/patterns/ for recovery; not loaded by agents)
ARCHIVED_PATTERNS=(
    "archive/patterns/validation/zod-patterns.md"
    "archive/patterns/security/authentication.md"
    "archive/patterns/testing/test-pyramid.md"
    "archive/patterns/deployment/ci-cd-pipeline.md"
)
for pat in "${ARCHIVED_PATTERNS[@]}"; do
    if [ ! -f "$pat" ]; then
        echo -e "  ${RED}✗${NC} Archived pattern missing: $pat"
        ERRORS=$((ERRORS + 1))
    fi
done
echo -e "  ${GREEN}✓${NC} archived generic patterns present under archive/patterns/"

# 6. Runbook token budget (SKILL.md promises "≤~2k tokens" per runbook)
# Warning-only: catches silent bloat that would defeat on-demand loading.
echo ""
echo "6. Checking Runbook Token Budget (≤~2k each)..."
BUDGET_WARN=0
for rb in docs/modules/*.md; do
    [ "$(basename "$rb")" = "README.md" ] && continue
    rb_bytes=$(wc -c < "$rb")
    rb_tok=$((rb_bytes / 4))
    if [ "$rb_tok" -gt 2000 ]; then
        echo -e "  ${YELLOW}⚠${NC} $rb ~${rb_tok} tokens (>2000) — move detail to docs/modules/deep-dives/"
        BUDGET_WARN=$((BUDGET_WARN + 1))
    fi
done
if [ $BUDGET_WARN -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} all runbooks within the ~2k token budget"
else
    echo -e "  ${YELLOW}⚠${NC} $BUDGET_WARN runbook(s) over budget (non-blocking)"
fi

# 7. Gate behavioral regression tests + output parity
echo ""
echo "7. Checking Gate Behavioral Regressions..."
# Skipped when invoked FROM the regression suite (it re-runs this script to prove
# cwd-independence); without this guard the two would recurse forever.
if [ "${GATE_REGRESSIONS_RUNNING:-0}" = "1" ]; then
    echo -e "  ${YELLOW}⚠${NC} skipped (nested run from the regression suite)"
else
    if bash scripts/verify/test-gate-regressions.sh >/dev/null 2>&1; then
        echo -e "  ${GREEN}✓${NC} gate regression tests pass (intake gate enforced on every reachable module)"
    else
        echo -e "  ${RED}✗${NC} gate regression tests FAILED (run: bash scripts/verify/test-gate-regressions.sh)"
        ERRORS=$((ERRORS + 1))
    fi
    # Output parity: every gate's behaviour must match the captured golden files.
    # This is what proves the dispatcher/module split changed nothing observable.
    if bash scripts/verify/test-gate-output.sh >/dev/null 2>&1; then
        GOLDEN_COUNT=$(grep -c "^##### GATE:" scripts/verify/golden-gate-output.txt 2>/dev/null || echo "?")
        echo -e "  ${GREEN}✓${NC} gate output parity holds (${GOLDEN_COUNT} checks vs golden, byte-for-byte)"
    else
        echo -e "  ${RED}✗${NC} gate output parity FAILED (run: bash scripts/verify/test-gate-output.sh)"
        ERRORS=$((ERRORS + 1))
    fi
fi

# 8. Eval scenario catalog integrity (structural; does not run an agent)
echo ""
echo "8. Checking Eval Scenario Catalog..."
if node --version >/dev/null 2>&1; then
    # Count from the runner rather than hardcoding it — the number went stale the
    # moment EVAL-09/EVAL-10 were added.
    if node scripts/evals/run-evals.js --validate >/dev/null 2>&1; then
        EVAL_COUNT=$(ls evals/scenarios/*.md 2>/dev/null | wc -l | tr -d ' ')
        echo -e "  ${GREEN}✓${NC} eval scenarios valid (${EVAL_COUNT} scenarios, all with automated assertions)"
    else
        echo -e "  ${RED}✗${NC} eval catalog invalid (run: node scripts/evals/run-evals.js --validate)"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo -e "  ${YELLOW}\u26a0${NC}  skipped \u2014 node is not executable from this shell"
    SKIPPED=$((SKIPPED + 1))
fi

# 9. Verify Markdown Links and Frontmatter
echo "9. Checking Markdown Links and SKILL.md Frontmatter..."
if node --version >/dev/null 2>&1; then
    if node scripts/verify/verify-skill-frontmatter.js >/dev/null 2>&1; then
        echo -e "  ${GREEN}✓${NC} SKILL.md frontmatter valid"
    else
        echo -e "  ${RED}✗${NC} SKILL.md frontmatter invalid"
        ERRORS=$((ERRORS + 1))
    fi
    if node scripts/verify/verify-links.js >/dev/null 2>&1; then
        echo -e "  ${GREEN}✓${NC} Internal Markdown links valid (0 broken)"
    else
        echo -e "  ${RED}✗${NC} Broken markdown links found"
        ERRORS=$((ERRORS + 1))
    fi
    if node scripts/verify/index-manifest.js --check >/dev/null 2>&1; then
        echo -e "  ${GREEN}✓${NC} INDEX.json manifest in two-way parity with filesystem"
    else
        echo -e "  ${RED}✗${NC} INDEX.json manifest out of sync (run: node scripts/verify/index-manifest.js)"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo -e "  ${YELLOW}\u26a0${NC}  skipped \u2014 node is not executable from this shell"
    SKIPPED=$((SKIPPED + 1))
fi
echo ""
if [ $ERRORS -eq 0 ] && [ $SKIPPED -eq 0 ]; then
    echo -e "${GREEN}All integrity checks passed successfully!${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}All bash checks passed \u2014 ${SKIPPED} node-based check(s) SKIPPED (node not executable from bash; run them explicitly)${NC}"
    exit 0
else
    echo -e "${RED}Total errors found: $ERRORS${NC}"
    exit 1
fi
