#!/usr/bin/env bash
# ==============================================================================
# verify-all.sh - Repository Integrity & Sanity Checker
# Validates shell script syntax, module files, and critical template presence.
# ==============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Solo Project Lifecycle Integrity Check ===${NC}"
echo ""

ERRORS=0

# 1. Verify Shell Scripts Syntax
echo "1. Checking bash scripts syntax..."
for script in scripts/*.sh templates/04-dev-execution/*.sh templates/04-dev-execution/scripts/*.sh; do
    if [ -f "$script" ]; then
        if bash -n "$script" 2>/dev/null; then
            echo -e "  ${GREEN}✓${NC} $script"
        else
            echo -e "  ${RED}✗${NC} Syntax error in $script"
            ERRORS=$((ERRORS + 1))
        fi
    fi
done

# 2. Verify 14 Modules Presence (M00 - M13)
echo ""
echo "2. Checking 14 Lifecycle Modules (docs/modules/)..."
MODULES=(
    "00-product-discovery-strategy.md"
    "01-idea-feasibility.md"
    "02-discovery-scope.md"
    "03-legal-sow-charter.md"
    "04-uiux-prototyping.md"
    "05-architecture-specs.md"
    "06-development-execution.md"
    "07-quality-assurance-sit.md"
    "08-data-migration-seeding.md"
    "09-uat-client-signoff.md"
    "10-deployment-production.md"
    "11-handover-bast.md"
    "12-warranty-sla-retainer.md"
    "13-product-operations-iteration.md"
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
    "01-mvp-saas-inventory.md"
    "02-ecommerce-fashion-mvp.md"
    "03-crm-real-estate-internal.md"
    "04-medium-b2b-saas-worked-example.md"
    "05-large-system-integration-worked-example.md"
)
for cs in "${CASE_STUDIES[@]}"; do
    if [ -f "case-studies/$cs" ]; then
        echo -e "  ${GREEN}✓${NC} case-studies/$cs"
    else
        echo -e "  ${RED}✗${NC} Missing case-studies/$cs"
        ERRORS=$((ERRORS + 1))
    fi
done

# 5. Verify Patterns Presence (17 Patterns)
echo ""
echo "5. Checking Patterns..."
PATTERNS=(
    "patterns/api/graphql-and-versioning.md"
    "patterns/api/rest-conventions.md"
    "patterns/database/seeding-and-transactions.md"
    "patterns/database/supabase-migrations.md"
    "patterns/deployment/ci-cd-pipeline.md"
    "patterns/error-handling/error-boundaries.md"
    "patterns/git-workflow/branching-strategy.md"
    "patterns/performance/caching-strategies.md"
    "patterns/performance/n-plus-one-prevention.md"
    "patterns/security/authentication.md"
    "patterns/testing/test-pyramid.md"
    "patterns/validation/zod-patterns.md"
    "patterns/payments/indonesia-payment-gateways.md"
    "patterns/compliance/uu-pdp-compliance.md"
    "patterns/offline/offline-first-sync.md"
    "patterns/observability/logging-monitoring.md"
    "patterns/localization/i18n-indonesia.md"
)
for pat in "${PATTERNS[@]}"; do
    if [ -f "$pat" ]; then
        echo -e "  ${GREEN}✓${NC} $pat"
    else
        echo -e "  ${RED}✗${NC} Missing $pat"
        ERRORS=$((ERRORS + 1))
    fi
done

# 6. Verify Markdown Links and Frontmatter
echo "6. Checking Markdown Links and SKILL.md Frontmatter..."
if command -v node >/dev/null 2>&1; then
    if node scripts/verify-skill-frontmatter.js >/dev/null 2>&1; then
        echo -e "  ${GREEN}✓${NC} SKILL.md frontmatter valid"
    else
        echo -e "  ${RED}✗${NC} SKILL.md frontmatter invalid"
        ERRORS=$((ERRORS + 1))
    fi
    if node scripts/verify-links.js >/dev/null 2>&1; then
        echo -e "  ${GREEN}✓${NC} Internal Markdown links valid (0 broken)"
    else
        echo -e "  ${RED}✗${NC} Broken markdown links found"
        ERRORS=$((ERRORS + 1))
    fi
fi
echo ""
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}All integrity checks passed successfully!${NC}"
    exit 0
else
    echo -e "${RED}Total errors found: $ERRORS${NC}"
    exit 1
fi
