#!/usr/bin/env bash
# template-picker.sh - Interactive template selection tool
# Usage: ./scripts/template-picker.sh

set -e

TEMPLATES_DIR="templates"
PROJECT_ROOT="."
PHASE_ARG=""
DRY_RUN=0
AUTO_CONFIRM=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        -y|--yes)
            AUTO_CONFIRM=1
            shift
            ;;
        --dest)
            PROJECT_ROOT="$2"
            shift 2
            ;;
        --phase)
            PHASE_ARG="$2"
            shift 2
            ;;
        *)
            break
            ;;
    esac
done

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      Solo Project Lifecycle - Template Picker        ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

# Function to show menu
show_menu() {
    echo -e "${GREEN}Select project phase:${NC}"
    echo "1. Discovery & Commercial (Idea, Scope, SOW)"
    echo "2. Design (UI/UX, Design System, Components)"
    echo "3. Architecture & Specs (PRD, FSD, System Design)"
    echo "4. Development Harness (AGENTS, TODO, CONTEXT)"
    echo "5. QA & UAT (SIT, Security Audit, UAT)"
    echo "6. Deployment & Handover (BAST, Deployment Protocol)"
    echo "7. Maintenance & Growth (SLA, Analytics, Experiments)"
    echo "8. MVP Fast-Track (PROJECT_LITE only)"
    echo "9. Show all templates"
    echo "0. Exit"
    echo ""
}

# Function to copy template
copy_template() {
    local src=$1
    local dest="${PROJECT_ROOT}/${2}"
    
    if [ $DRY_RUN -eq 1 ]; then
        echo -e "${BLUE}[DRY-RUN] Would copy: $src -> $dest${NC}"
        return
    fi
    
    if [ -f "$dest" ]; then
        echo -e "${YELLOW}⚠️  File exists: $dest${NC}"
        if [ $AUTO_CONFIRM -ne 1 ]; then
            read -p "Overwrite? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "Skipped."
                return
            fi
        fi
    fi
    
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    echo -e "${GREEN}✅ Copied to: $dest${NC}"
}

# Phase 1: Discovery & Commercial
phase_discovery() {
    echo -e "${BLUE}=== Discovery & Commercial Templates ===${NC}"
    echo ""
    echo "1. IDEA_BRIEF (Feasibility 4-dimension scoring)"
    echo "2. SCOPE_STATEMENT (MoSCoW, RBAC, Out-of-Scope)"
    echo "3. SOW_CONTRACT (Payment terms, Single PIC, IP ownership)"
    echo "4. MARKET_RESEARCH (TAM/SAM/SOM, competitors)"
    echo "5. PRODUCT_STRATEGY (Vision, North Star, Value Prop)"
    echo "6. OKR (Objectives & Key Results)"
    echo "7. RISK_REGISTER (Risk assessment matrix)"
    echo "8. BACKLOG (User stories, RICE prioritization)"
    echo "9. Back to main menu"
    echo ""
    read -p "Select template (1-9): " choice
    
    case $choice in
        1) copy_template "$TEMPLATES_DIR/01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md" "docs/pm/IDEA_BRIEF.md" ;;
        2) copy_template "$TEMPLATES_DIR/01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md" "docs/pm/SCOPE_STATEMENT.md" ;;
        3) copy_template "$TEMPLATES_DIR/01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md" "docs/pm/SOW_CONTRACT.md" ;;
        4) copy_template "$TEMPLATES_DIR/01-discovery-commercial/MARKET_RESEARCH_TEMPLATE.md" "docs/pm/MARKET_RESEARCH.md" ;;
        5) copy_template "$TEMPLATES_DIR/01-discovery-commercial/PRODUCT_STRATEGY_TEMPLATE.md" "docs/pm/PRODUCT_STRATEGY.md" ;;
        6) copy_template "$TEMPLATES_DIR/01-discovery-commercial/OKR_TEMPLATE.md" "docs/pm/OKR.md" ;;
        7) copy_template "$TEMPLATES_DIR/01-discovery-commercial/RISK_REGISTER_TEMPLATE.md" "docs/pm/RISK_REGISTER.md" ;;
        8) copy_template "$TEMPLATES_DIR/01-discovery-commercial/BACKLOG_TEMPLATE.md" "docs/pm/BACKLOG.md" ;;
        9) return ;;
        *) echo "Invalid choice" ;;
    esac
}

# Phase 2: Design
phase_design() {
    echo -e "${BLUE}=== Design Templates ===${NC}"
    echo ""
    echo "1. DESIGN.md (Root harness - design tokens)"
    echo "2. DESIGN_SPEC (Page inventory, states, responsive)"
    echo "3. DESIGN_SYSTEM_AUDIT (Visual inconsistency audit)"
    echo "4. DESIGN_TOKENS_SPEC (Primitive + semantic tokens)"
    echo "5. COMPONENT_API_SPEC (Props, variants, accessibility)"
    echo "6. LOGO_DESIGN_BRIEF (Brand identity)"
    echo "7. AB_TEST_HYPOTHESIS (Experiment design)"
    echo "8. Back to main menu"
    echo ""
    read -p "Select template (1-8): " choice
    
    case $choice in
        1) copy_template "$TEMPLATES_DIR/02-design/DESIGN_MD_TEMPLATE.md" "DESIGN.md" ;;
        2) copy_template "$TEMPLATES_DIR/02-design/DESIGN_SPEC_TEMPLATE.md" "docs/specs/DESIGN_SPEC.md" ;;
        3) copy_template "$TEMPLATES_DIR/02-design/DESIGN_SYSTEM_AUDIT_TEMPLATE.md" "docs/design/DESIGN_SYSTEM_AUDIT.md" ;;
        4) copy_template "$TEMPLATES_DIR/02-design/DESIGN_TOKENS_SPEC_TEMPLATE.md" "tokens/design-tokens.json" ;;
        5) copy_template "$TEMPLATES_DIR/02-design/COMPONENT_API_SPEC_TEMPLATE.md" "docs/design/COMPONENT_API_SPEC.md" ;;
        6) copy_template "$TEMPLATES_DIR/02-design/LOGO_DESIGN_BRIEF_TEMPLATE.md" "docs/design/LOGO_BRIEF.md" ;;
        7) copy_template "$TEMPLATES_DIR/02-design/AB_TEST_HYPOTHESIS_TEMPLATE.md" "docs/analytics/AB_TEST_HYPOTHESIS.md" ;;
        8) return ;;
        *) echo "Invalid choice" ;;
    esac
}

# Phase 3: Architecture
phase_architecture() {
    echo -e "${BLUE}=== Architecture & Specs Templates ===${NC}"
    echo ""
    echo "1. PRD (Product Requirements Document)"
    echo "2. FSD (Functional Specification Document)"
    echo "3. SYSTEM_DESIGN_DOC (Load balancing, caching, HA)"
    echo "4. CAPACITY_PLANNING (Traffic projection, resources)"
    echo "5. DISASTER_RECOVERY_PLAN (RPO/RTO, failover)"
    echo "6. PROJECT_LITE (MVP all-in-one template)"
    echo "7. Back to main menu"
    echo ""
    read -p "Select template (1-7): " choice
    
    case $choice in
        1) copy_template "$TEMPLATES_DIR/03-architecture-specs/PRD_FINAL_TEMPLATE.md" "docs/specs/PRD.md" ;;
        2) copy_template "$TEMPLATES_DIR/03-architecture-specs/FSD_TECHNICAL_TEMPLATE.md" "docs/specs/FSD.md" ;;
        3) copy_template "$TEMPLATES_DIR/03-architecture-specs/SYSTEM_DESIGN_DOC_TEMPLATE.md" "docs/specs/SYSTEM_DESIGN_DOC.md" ;;
        4) copy_template "$TEMPLATES_DIR/03-architecture-specs/CAPACITY_PLANNING_TEMPLATE.md" "docs/specs/CAPACITY_PLANNING.md" ;;
        5) copy_template "$TEMPLATES_DIR/03-architecture-specs/DISASTER_RECOVERY_PLAN_TEMPLATE.md" "docs/specs/DISASTER_RECOVERY_PLAN.md" ;;
        6) copy_template "$TEMPLATES_DIR/03-architecture-specs/PROJECT_LITE_TEMPLATE.md" "PROJECT_LITE.md" ;;
        7) return ;;
        *) echo "Invalid choice" ;;
    esac
}

# Phase 4: Development Harness
phase_dev_harness() {
    echo -e "${BLUE}=== Development Harness (7 Root Files) ===${NC}"
    echo ""
    echo "1. AGENTS.md (AI agent instructions)"
    echo "2. CONTEXT.md (Business context, Out-of-Scope)"
    echo "3. ARCHITECTURE.md (Tech architecture summary)"
    echo "4. DESIGN.md (Design tokens)"
    echo "5. CONVENTIONS.md (Code style guide)"
    echo "6. TODO.md (Atomic task queue)"
    echo "7. .env.example (Environment variables)"
    echo "8. RUNBOOK_LOCAL.md (Local setup guide)"
    echo "9. VERIFY_LOCAL.md (Verification checklist)"
    echo "10. Copy all 9 harness files at once"
    echo "11. Back to main menu"
    echo ""
    read -p "Select template (1-11): " choice
    
    case $choice in
        1) copy_template "$TEMPLATES_DIR/04-dev-execution/AGENTS_TEMPLATE.md" "AGENTS.md" ;;
        2) copy_template "$TEMPLATES_DIR/04-dev-execution/CONTEXT_TEMPLATE.md" "CONTEXT.md" ;;
        3) copy_template "$TEMPLATES_DIR/04-dev-execution/ARCHITECTURE_TEMPLATE.md" "ARCHITECTURE.md" ;;
        4) copy_template "$TEMPLATES_DIR/02-design/DESIGN_MD_TEMPLATE.md" "DESIGN.md" ;;
        5) copy_template "$TEMPLATES_DIR/04-dev-execution/CONVENTIONS_TEMPLATE.md" "CONVENTIONS.md" ;;
        6) copy_template "$TEMPLATES_DIR/04-dev-execution/TODO_TEMPLATE.md" "TODO.md" ;;
        7) copy_template "$TEMPLATES_DIR/04-dev-execution/ENV_EXAMPLE_TEMPLATE.md" ".env.example" ;;
        8) copy_template "$TEMPLATES_DIR/04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md" "RUNBOOK_LOCAL.md" ;;
        9) copy_template "$TEMPLATES_DIR/04-dev-execution/VERIFY_LOCAL_TEMPLATE.md" "VERIFY_LOCAL.md" ;;
        10)
            copy_template "$TEMPLATES_DIR/04-dev-execution/AGENTS_TEMPLATE.md" "AGENTS.md"
            copy_template "$TEMPLATES_DIR/04-dev-execution/CONTEXT_TEMPLATE.md" "CONTEXT.md"
            copy_template "$TEMPLATES_DIR/04-dev-execution/ARCHITECTURE_TEMPLATE.md" "ARCHITECTURE.md"
            copy_template "$TEMPLATES_DIR/02-design/DESIGN_MD_TEMPLATE.md" "DESIGN.md"
            copy_template "$TEMPLATES_DIR/04-dev-execution/CONVENTIONS_TEMPLATE.md" "CONVENTIONS.md"
            copy_template "$TEMPLATES_DIR/04-dev-execution/TODO_TEMPLATE.md" "TODO.md"
            copy_template "$TEMPLATES_DIR/04-dev-execution/ENV_EXAMPLE_TEMPLATE.md" ".env.example"
            copy_template "$TEMPLATES_DIR/04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md" "RUNBOOK_LOCAL.md"
            copy_template "$TEMPLATES_DIR/04-dev-execution/VERIFY_LOCAL_TEMPLATE.md" "VERIFY_LOCAL.md"
            echo -e "${GREEN}✅ All 9 harness files copied${NC}"
            ;;
        11) return ;;
        *) echo "Invalid choice" ;;
    esac
}

# Phase 5: QA & UAT
phase_qa() {
    echo -e "${BLUE}=== QA & UAT Templates ===${NC}"
    echo ""
    echo "1. SIT_WORKBOOK (System Integration Testing)"
    echo "2. SECURITY_AUDIT (OWASP Top 10, UU PDP)"
    echo "3. UAT_WORKBOOK (User Acceptance Testing)"
    echo "4. UAT_SIGNOFF (Formal sign-off document)"
    echo "5. Back to main menu"
    echo ""
    read -p "Select template (1-5): " choice
    
    case $choice in
        1) copy_template "$TEMPLATES_DIR/06-qa-uat/SIT_WORKBOOK_TEMPLATE.md" "docs/qa/SIT_WORKBOOK.md" ;;
        2) copy_template "$TEMPLATES_DIR/06-qa-uat/SECURITY_AUDIT_TEMPLATE.md" "docs/qa/SECURITY_AUDIT.md" ;;
        3) copy_template "$TEMPLATES_DIR/06-qa-uat/UAT_WORKBOOK_TEMPLATE.md" "docs/qa/UAT_WORKBOOK.md" ;;
        4) copy_template "$TEMPLATES_DIR/06-qa-uat/UAT_SIGNOFF_TEMPLATE.md" "docs/pm/UAT_SIGNOFF_REPORT.md" ;;
        5) return ;;
        *) echo "Invalid choice" ;;
    esac
}

# Phase 6: Deployment & Handover
phase_deploy() {
    echo -e "${BLUE}=== Deployment & Handover Templates ===${NC}"
    echo ""
    echo "1. DEPLOYMENT_PROTOCOL (Go-live checklist)"
    echo "2. ROLLBACK_PLAN (15-min recovery procedure)"
    echo "3. BAST (Berita Acara Serah Terima)"
    echo "4. HANDOVER_PROTOCOL (Repo & credentials transfer)"
    echo "5. USER_MANUAL (End-user documentation)"
    echo "6. Back to main menu"
    echo ""
    read -p "Select template (1-6): " choice
    
    case $choice in
        1) copy_template "$TEMPLATES_DIR/07-release-handover/DEPLOYMENT_PROTOCOL_TEMPLATE.md" "docs/DEPLOYMENT_PROTOCOL.md" ;;
        2) copy_template "$TEMPLATES_DIR/07-release-handover/ROLLBACK_PLAN_TEMPLATE.md" "docs/ROLLBACK_PLAN.md" ;;
        3) copy_template "$TEMPLATES_DIR/07-release-handover/BAST_TEMPLATE.md" "contracts/BAST.md" ;;
        4) copy_template "$TEMPLATES_DIR/07-release-handover/HANDOVER_PROTOCOL_TEMPLATE.md" "docs/HANDOVER_PROTOCOL.md" ;;
        5) copy_template "$TEMPLATES_DIR/07-release-handover/USER_MANUAL_TEMPLATE.md" "docs/USER_MANUAL.md" ;;
        6) return ;;
        *) echo "Invalid choice" ;;
    esac
}

# Phase 7: Maintenance & Growth
phase_maintenance() {
    echo -e "${BLUE}=== Maintenance & Growth Templates ===${NC}"
    echo ""
    echo "1. WARRANTY_POLICY (Bug fix boundaries)"
    echo "2. SLA_RETAINER_CONTRACT (Monthly retainer)"
    echo "3. INCIDENT_RESPONSE (RCA, post-mortem)"
    echo "4. EVENT_TAXONOMY (Analytics event spec)"
    echo "5. ANALYTICS_IMPLEMENTATION_PLAN (SDK integration)"
    echo "6. DASHBOARD_SPEC (North Star Metric dashboard)"
    echo "7. METRICS_BASELINE_REPORT (30-day baseline)"
    echo "8. GROWTH_EXPERIMENTS_BACKLOG (RICE-scored experiments)"
    echo "9. AB_TEST_REPORT (Experiment results)"
    echo "10. Back to main menu"
    echo ""
    read -p "Select template (1-10): " choice
    
    case $choice in
        1) copy_template "$TEMPLATES_DIR/08-maintenance-ops/WARRANTY_POLICY_TEMPLATE.md" "docs/WARRANTY_POLICY.md" ;;
        2) copy_template "$TEMPLATES_DIR/08-maintenance-ops/SLA_RETAINER_CONTRACT_TEMPLATE.md" "contracts/SLA_RETAINER.md" ;;
        3) copy_template "$TEMPLATES_DIR/08-maintenance-ops/INCIDENT_RESPONSE_TEMPLATE.md" "docs/INCIDENT_RESPONSE.md" ;;
        4) copy_template "$TEMPLATES_DIR/09-product-growth/EVENT_TAXONOMY_TEMPLATE.md" "docs/analytics/EVENT_TAXONOMY.md" ;;
        5) copy_template "$TEMPLATES_DIR/09-product-growth/ANALYTICS_IMPLEMENTATION_PLAN_TEMPLATE.md" "docs/analytics/ANALYTICS_PLAN.md" ;;
        6) copy_template "$TEMPLATES_DIR/09-product-growth/DASHBOARD_SPEC_TEMPLATE.md" "docs/analytics/DASHBOARD_SPEC.md" ;;
        7) copy_template "$TEMPLATES_DIR/09-product-growth/METRICS_BASELINE_REPORT_TEMPLATE.md" "docs/pm/METRICS_BASELINE_REPORT.md" ;;
        8) copy_template "$TEMPLATES_DIR/09-product-growth/GROWTH_EXPERIMENTS_BACKLOG_TEMPLATE.md" "docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md" ;;
        9) copy_template "$TEMPLATES_DIR/09-product-growth/AB_TEST_REPORT_TEMPLATE.md" "docs/analytics/AB_TEST_REPORT.md" ;;
        10) return ;;
        *) echo "Invalid choice" ;;
    esac
}

# MVP Fast-Track
mvp_fasttrack() {
    echo -e "${BLUE}=== MVP Fast-Track (2-4 weeks) ===${NC}"
    echo ""
    echo "Copying minimal MVP templates:"
    echo ""
    
    copy_template "$TEMPLATES_DIR/03-architecture-specs/PROJECT_LITE_TEMPLATE.md" "PROJECT.md"
    copy_template "$TEMPLATES_DIR/02-design/DESIGN_MD_TEMPLATE.md" "DESIGN.md"
    copy_template "$TEMPLATES_DIR/07-release-handover/DEPLOYMENT_PROTOCOL_TEMPLATE.md" "DEPLOY.md"
    
    echo ""
    echo -e "${GREEN}✅ MVP templates ready${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Fill PROJECT.md (problem, solution, 3 features, DB schema)"
    echo "2. Fill DESIGN.md (color palette, typography, components)"
    echo "3. Build in 2-4 weeks"
    echo "4. Deploy using DEPLOY.md checklist"
    echo ""
    echo "Read: docs/quickstart.md for detailed guide"
    echo ""
    if [ -z "$PHASE_ARG" ]; then
        read -p "Press Enter to continue..."
    fi
}

# Show all templates
show_all_templates() {
    echo -e "${BLUE}=== All Available Templates ===${NC}"
    echo ""
    find "$TEMPLATES_DIR" -name "*TEMPLATE.md" -type f | sort | while read -r file; do
        basename "$file" .md | sed 's/_TEMPLATE//'
    done | nl
    echo ""
    echo "Total: $(find "$TEMPLATES_DIR" -name "*TEMPLATE.md" | wc -l) templates"
    echo ""
    if [ -z "$PHASE_ARG" ]; then
        read -p "Press Enter to continue..."
    fi
}

# Non-interactive phase invocation
if [ -n "$PHASE_ARG" ]; then
    case "$PHASE_ARG" in
        1) phase_discovery; exit 0 ;;
        2) phase_design; exit 0 ;;
        3) phase_architecture; exit 0 ;;
        4) phase_dev_harness; exit 0 ;;
        5) phase_qa; exit 0 ;;
        6) phase_deploy; exit 0 ;;
        7) phase_maintenance; exit 0 ;;
        8|PROJECT_LITE) mvp_fasttrack; exit 0 ;;
        9) show_all_templates; exit 0 ;;
        *) echo "Unknown phase: $PHASE_ARG"; exit 1 ;;
    esac
fi

# Main loop
while true; do
    show_menu
    read -p "Enter choice [0-9]: " choice
    echo ""
    
    case $choice in
        1) phase_discovery ;;
        2) phase_design ;;
        3) phase_architecture ;;
        4) phase_dev_harness ;;
        5) phase_qa ;;
        6) phase_deploy ;;
        7) phase_maintenance ;;
        8) mvp_fasttrack ;;
        9) show_all_templates ;;
        0) echo "Goodbye!"; exit 0 ;;
        *) echo -e "${RED}Invalid choice${NC}" ;;
    esac
    
    echo ""
done
