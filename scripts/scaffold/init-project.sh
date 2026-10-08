#!/usr/bin/env bash
# init-project.sh - Deterministic Project Directory Initializer
# Usage: ./scripts/init-project.sh <TARGET_DIR> [small|solo-saas|independent|open-source|medium|bespoke|freelance|large|enterprise] [ARCHETYPE] [DELIVERY]

set -e

TARGET_DIR="${1:-}"
SCALE="${2:-solo-saas}"
ARCHETYPE="${3:-}"
DELIVERY="${4:-}"

if [ -z "$TARGET_DIR" ]; then
    echo "Usage: $0 <TARGET_DIR> [small|solo-saas|independent|open-source|medium|bespoke|freelance|large|enterprise] [ARCHETYPE] [DELIVERY]"
    echo "Example: $0 ~/projects/my-new-saas solo-saas"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEMPLATES="$ROOT_DIR/templates"

echo "=== Initializing New Project ==="
echo "Target Directory : $TARGET_DIR"
echo "Project Scale    : $SCALE"
echo "--------------------------------"

# Create standard directory hierarchy
mkdir -p "$TARGET_DIR/docs/pm"
mkdir -p "$TARGET_DIR/docs/specs"
mkdir -p "$TARGET_DIR/docs/design/inspiration"
mkdir -p "$TARGET_DIR/docs/design/prompts"
mkdir -p "$TARGET_DIR/docs/design/screens"
mkdir -p "$TARGET_DIR/docs/harness-root"

# Universal: Project State tracker
cp "$TEMPLATES/essentials/PROJECT_STATE_TEMPLATE.md" "$TARGET_DIR/docs/pm/PROJECT_STATE.md"
cp "$TEMPLATES/02-design/references/inspiration-template/notes-template.md" "$TARGET_DIR/docs/design/inspiration/notes.md"
cp "$TEMPLATES/02-design/SCREEN_PROMPT_TEMPLATE.md" "$TARGET_DIR/docs/design/prompts/SCREEN_PROMPT_TEMPLATE.md"

case "$SCALE" in
    small|open-source)
        echo "Configuring for Small / Open-Source Fast-Track MVP..."
        cp "$TEMPLATES/03-architecture-specs/PROJECT_LITE_TEMPLATE.md" "$TARGET_DIR/PROJECT_LITE.md"
        cp "$TEMPLATES/02-design/SITEMAP_TEMPLATE.md" "$TARGET_DIR/docs/specs/SITEMAP.md"
        cp "$TEMPLATES/02-design/DESIGN_MD_TEMPLATE.md" "$TARGET_DIR/docs/harness-root/DESIGN.md"
        cp "$TEMPLATES/04-dev-execution/TODO_TEMPLATE.md" "$TARGET_DIR/docs/harness-root/TODO.md"
        ;;
    solo-saas|independent)
        echo "Configuring for Independent / Self-Initiated Product..."
        cp "$TEMPLATES/01-discovery-commercial/M00_LITE_TEMPLATE.md" "$TARGET_DIR/docs/pm/M00_LITE.md"
        cp "$TEMPLATES/01-discovery-commercial/INTERVIEW_GUIDE_TEMPLATE.md" "$TARGET_DIR/docs/pm/INTERVIEW_GUIDE.md"
        cp "$TEMPLATES/01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md" "$TARGET_DIR/docs/pm/IDEA_BRIEF.md"
        cp "$TEMPLATES/01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md" "$TARGET_DIR/docs/pm/SCOPE_STATEMENT.md"
        cp "$TEMPLATES/01-discovery-commercial/REQUIREMENT_MATRIX_TEMPLATE.md" "$TARGET_DIR/docs/pm/REQUIREMENT_MATRIX.md"
        cp "$TEMPLATES/01-discovery-commercial/VERIFICATION_PLAN_TEMPLATE.md" "$TARGET_DIR/docs/pm/VERIFICATION_PLAN.md"
        cp "$TEMPLATES/02-design/SITEMAP_TEMPLATE.md" "$TARGET_DIR/docs/specs/SITEMAP.md"
        cp "$TEMPLATES/02-design/COMPONENT_REQUIREMENTS_TEMPLATE.md" "$TARGET_DIR/docs/specs/COMPONENT_REQUIREMENTS.md"
        cp "$TEMPLATES/02-design/DESIGN_SPEC_TEMPLATE.md" "$TARGET_DIR/docs/specs/DESIGN_SPEC.md"
        cp "$TEMPLATES/02-design/DESIGN_MD_TEMPLATE.md" "$TARGET_DIR/docs/harness-root/DESIGN.md"
        cp "$TEMPLATES/04-dev-execution/TODO_TEMPLATE.md" "$TARGET_DIR/docs/harness-root/TODO.md"
        ;;
    medium|bespoke|freelance)
        echo "Configuring for Medium Bespoke / Client Commercial..."
        mkdir -p "$TARGET_DIR/contracts"
        cp "$TEMPLATES/01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md" "$TARGET_DIR/docs/pm/IDEA_BRIEF.md"
        cp "$TEMPLATES/01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md" "$TARGET_DIR/docs/pm/SCOPE_STATEMENT.md"
        cp "$TEMPLATES/01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md" "$TARGET_DIR/contracts/SOW_CONTRACT.md"
        cp "$TEMPLATES/02-legal-commercial/NDA_TEMPLATE.md" "$TARGET_DIR/contracts/NDA.md"
        cp "$TEMPLATES/02-design/SITEMAP_TEMPLATE.md" "$TARGET_DIR/docs/specs/SITEMAP.md"
        cp "$TEMPLATES/02-design/COMPONENT_REQUIREMENTS_TEMPLATE.md" "$TARGET_DIR/docs/specs/COMPONENT_REQUIREMENTS.md"
        cp "$TEMPLATES/02-design/DESIGN_SPEC_TEMPLATE.md" "$TARGET_DIR/docs/specs/DESIGN_SPEC.md"
        cp "$TEMPLATES/02-design/DESIGN_MD_TEMPLATE.md" "$TARGET_DIR/docs/harness-root/DESIGN.md"
        cp "$TEMPLATES/04-dev-execution/TODO_TEMPLATE.md" "$TARGET_DIR/docs/harness-root/TODO.md"
        ;;
    large)
        echo "Configuring for Large Scale..."
        mkdir -p "$TARGET_DIR/contracts"
        mkdir -p "$TARGET_DIR/docs/qa"
        cp "$TEMPLATES/01-discovery-commercial/MARKET_RESEARCH_TEMPLATE.md" "$TARGET_DIR/docs/pm/MARKET_RESEARCH.md"
        cp "$TEMPLATES/01-discovery-commercial/COMPETITIVE_LANDSCAPE_TEMPLATE.md" "$TARGET_DIR/docs/pm/COMPETITIVE_LANDSCAPE.md"
        cp "$TEMPLATES/01-discovery-commercial/USER_RESEARCH_REPORT_TEMPLATE.md" "$TARGET_DIR/docs/pm/USER_RESEARCH_REPORT.md"
        cp "$TEMPLATES/01-discovery-commercial/PRODUCT_STRATEGY_TEMPLATE.md" "$TARGET_DIR/docs/pm/PRODUCT_STRATEGY.md"
        cp "$TEMPLATES/01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md" "$TARGET_DIR/docs/pm/IDEA_BRIEF.md"
        cp "$TEMPLATES/01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md" "$TARGET_DIR/docs/pm/SCOPE_STATEMENT.md"
        cp "$TEMPLATES/01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md" "$TARGET_DIR/contracts/SOW_CONTRACT.md"
        cp "$TEMPLATES/02-legal-commercial/NDA_TEMPLATE.md" "$TARGET_DIR/contracts/NDA.md"
        cp "$TEMPLATES/02-design/SITEMAP_TEMPLATE.md" "$TARGET_DIR/docs/specs/SITEMAP.md"
        cp "$TEMPLATES/02-design/COMPONENT_REQUIREMENTS_TEMPLATE.md" "$TARGET_DIR/docs/specs/COMPONENT_REQUIREMENTS.md"
        cp "$TEMPLATES/02-design/DESIGN_SPEC_TEMPLATE.md" "$TARGET_DIR/docs/specs/DESIGN_SPEC.md"
        cp "$TEMPLATES/02-design/DESIGN_MD_TEMPLATE.md" "$TARGET_DIR/docs/harness-root/DESIGN.md"
        cp "$TEMPLATES/04-dev-execution/TODO_TEMPLATE.md" "$TARGET_DIR/docs/harness-root/TODO.md"
        cp "$TEMPLATES/05-data-migration/DATA_MIGRATION_PLAN_TEMPLATE.md" "$TARGET_DIR/docs/pm/DATA_MIGRATION_PLAN.md"
        cp "$TEMPLATES/05-data-migration/RECONCILIATION_REPORT_TEMPLATE.md" "$TARGET_DIR/docs/pm/MIGRATION_RECONCILIATION_REPORT.md"
        cp "$TEMPLATES/06-qa-uat/SIT_WORKBOOK_TEMPLATE.md" "$TARGET_DIR/docs/qa/SIT_WORKBOOK.md"
        cp "$TEMPLATES/06-qa-uat/SECURITY_AUDIT_TEMPLATE.md" "$TARGET_DIR/docs/qa/SECURITY_AUDIT.md"
        ;;
    enterprise)
        echo "Configuring for Enterprise Scale (Mission-Critical / Regulated)..."
        mkdir -p "$TARGET_DIR/contracts"
        mkdir -p "$TARGET_DIR/docs/qa"
        mkdir -p "$TARGET_DIR/docs/governance"
        mkdir -p "$TARGET_DIR/docs/ops"
        cp "$TEMPLATES/00-pre-sales-enterprise/RFP_RESPONSE_TEMPLATE.md" "$TARGET_DIR/docs/pm/RFP_RESPONSE.md"
        cp "$TEMPLATES/00-pre-sales-enterprise/POC_PLAN_TEMPLATE.md" "$TARGET_DIR/docs/pm/POC_PLAN.md"
        cp "$TEMPLATES/01-discovery-commercial/MARKET_RESEARCH_TEMPLATE.md" "$TARGET_DIR/docs/pm/MARKET_RESEARCH.md"
        cp "$TEMPLATES/01-discovery-commercial/COMPETITIVE_LANDSCAPE_TEMPLATE.md" "$TARGET_DIR/docs/pm/COMPETITIVE_LANDSCAPE.md"
        cp "$TEMPLATES/01-discovery-commercial/USER_RESEARCH_REPORT_TEMPLATE.md" "$TARGET_DIR/docs/pm/USER_RESEARCH_REPORT.md"
        cp "$TEMPLATES/01-discovery-commercial/PRODUCT_STRATEGY_TEMPLATE.md" "$TARGET_DIR/docs/pm/PRODUCT_STRATEGY.md"
        cp "$TEMPLATES/01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md" "$TARGET_DIR/docs/pm/IDEA_BRIEF.md"
        cp "$TEMPLATES/01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md" "$TARGET_DIR/docs/pm/SCOPE_STATEMENT.md"
        cp "$TEMPLATES/01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md" "$TARGET_DIR/contracts/SOW_CONTRACT.md"
        cp "$TEMPLATES/02-legal-commercial/NDA_TEMPLATE.md" "$TARGET_DIR/contracts/NDA.md"
        cp "$TEMPLATES/02-design/SITEMAP_TEMPLATE.md" "$TARGET_DIR/docs/specs/SITEMAP.md"
        cp "$TEMPLATES/02-design/COMPONENT_REQUIREMENTS_TEMPLATE.md" "$TARGET_DIR/docs/specs/COMPONENT_REQUIREMENTS.md"
        cp "$TEMPLATES/02-design/DESIGN_SPEC_TEMPLATE.md" "$TARGET_DIR/docs/specs/DESIGN_SPEC.md"
        cp "$TEMPLATES/02-design/DESIGN_MD_TEMPLATE.md" "$TARGET_DIR/docs/harness-root/DESIGN.md"
        cp "$TEMPLATES/04-dev-execution/TODO_TEMPLATE.md" "$TARGET_DIR/docs/harness-root/TODO.md"
        cp "$TEMPLATES/05-data-migration/DATA_MIGRATION_PLAN_TEMPLATE.md" "$TARGET_DIR/docs/pm/DATA_MIGRATION_PLAN.md"
        cp "$TEMPLATES/05-data-migration/RECONCILIATION_REPORT_TEMPLATE.md" "$TARGET_DIR/docs/pm/MIGRATION_RECONCILIATION_REPORT.md"
        cp "$TEMPLATES/06-qa-uat/SIT_WORKBOOK_TEMPLATE.md" "$TARGET_DIR/docs/qa/SIT_WORKBOOK.md"
        cp "$TEMPLATES/06-qa-uat/SECURITY_AUDIT_TEMPLATE.md" "$TARGET_DIR/docs/qa/SECURITY_AUDIT.md"
        cp "$TEMPLATES/03-governance/RACI_MATRIX.md" "$TARGET_DIR/docs/governance/RACI_MATRIX.md"
        cp "$TEMPLATES/03-governance/ADR_TEMPLATE.md" "$TARGET_DIR/docs/governance/ADR.md"
        cp "$TEMPLATES/03-governance/CAB_PROCESS.md" "$TARGET_DIR/docs/governance/CAB_APPROVAL.md"
        cp "$TEMPLATES/03-governance/AUDIT_TRAIL_REQUIREMENTS.md" "$TARGET_DIR/docs/governance/AUDIT_TRAIL_REQUIREMENTS.md"
        cp "$TEMPLATES/03-governance/DATA_CLASSIFICATION_POLICY.md" "$TARGET_DIR/docs/governance/DATA_CLASSIFICATION_POLICY.md"
        cp "$TEMPLATES/08-maintenance-ops/DISASTER_RECOVERY_PLAN.md" "$TARGET_DIR/docs/ops/DISASTER_RECOVERY_PLAN.md"
        ;;
    *)
        echo "Invalid scale: $SCALE (options: small | solo-saas | independent | open-source | medium | bespoke | freelance | large | enterprise)"
        exit 1
        ;;
esac

if [ -n "$ARCHETYPE" ] && [ -f "$TARGET_DIR/docs/pm/IDEA_BRIEF.md" ]; then
    echo "Applying Archetype metadata ($ARCHETYPE)..."
    if command -v sed >/dev/null 2>&1; then
        sed -i "s/- \*\*Industry Archetype\*\*:.*/- \*\*Industry Archetype\*\*: $ARCHETYPE (from references\/taxonomy\/SYSTEM_ARCHETYPES_250.md)/g" "$TARGET_DIR/docs/pm/IDEA_BRIEF.md"
    fi
    if [ -f "$TARGET_DIR/PROJECT_LITE.md" ] && command -v sed >/dev/null 2>&1; then
        sed -i "s/- \*\*Industry Archetype\*\*:.*/- \*\*Industry Archetype\*\*: $ARCHETYPE (from references\/taxonomy\/SYSTEM_ARCHETYPES_250.md)/g" "$TARGET_DIR/PROJECT_LITE.md"
    fi
fi

if [ -n "$DELIVERY" ]; then
    echo "Applying Delivery Model ($DELIVERY)..."
    if [ -f "$TARGET_DIR/docs/pm/IDEA_BRIEF.md" ] && command -v sed >/dev/null 2>&1; then
        sed -i "s/- \*\*Delivery Model\*\*:.*/- \*\*Delivery Model\*\*: $DELIVERY/g" "$TARGET_DIR/docs/pm/IDEA_BRIEF.md"
    fi
    if [ -f "$TARGET_DIR/PROJECT_LITE.md" ] && command -v sed >/dev/null 2>&1; then
        sed -i "s/- \*\*Delivery Model\*\*:.*/- \*\*Delivery Model\*\*: $DELIVERY/g" "$TARGET_DIR/PROJECT_LITE.md"
    fi
fi

echo "✅ Project initialized successfully at: $TARGET_DIR"
echo "Next step: Open docs/pm/PROJECT_STATE.md and begin Phase 1."
