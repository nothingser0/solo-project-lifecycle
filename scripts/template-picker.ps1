# Template Picker (PowerShell)
# Interactive template selection tool
# Note: Phases 5-7 (QA/Deployment/Maintenance) not yet implemented
#       Use template-picker.sh (Bash) for these phases
# Usage: .\scripts\template-picker.ps1

$ErrorActionPreference = "Stop"

$TemplatesDir = "templates"

function Show-Header {
    Write-Host ""
    Write-Host "╔═══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║      Solo Project Lifecycle - Template Picker        ║" -ForegroundColor Cyan
    Write-Host "╚═══════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Show-MainMenu {
    Write-Host "Select project phase:" -ForegroundColor Green
    Write-Host "  1. Discovery & Commercial (Idea, Scope, SOW)"
    Write-Host "  2. Design (UI/UX, Design System, Components)"
    Write-Host "  3. Architecture & Specs (PRD, FSD, System Design)"
    Write-Host "  4. Development Harness (AGENTS, TODO, CONTEXT)"
    Write-Host "  5. QA & UAT (SIT, Security Audit, UAT)"
    Write-Host "  6. Deployment & Handover (BAST, Deployment Protocol)"
    Write-Host "  7. Maintenance & Growth (SLA, Analytics, Experiments)"
    Write-Host "  8. MVP Fast-Track (PROJECT_LITE only)"
    Write-Host "  9. Use-Case Based (by task, not phase)"
    Write-Host "  0. Exit"
    Write-Host ""
}

function Copy-Template {
    param(
        [string]$Source,
        [string]$Destination
    )

    if (Test-Path $Destination) {
        Write-Host "⚠️  File exists: $Destination" -ForegroundColor Yellow
        $overwrite = Read-Host "Overwrite? (y/N)"
        if ($overwrite -ne 'y' -and $overwrite -ne 'Y') {
            Write-Host "Skipped." -ForegroundColor Gray
            return
        }
    }

    $destDir = Split-Path -Parent $Destination
    if ($destDir -and -not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }

    Copy-Item $Source $Destination
    Write-Host "✅ Copied to: $Destination" -ForegroundColor Green
}

function Show-DiscoveryMenu {
    Write-Host ""
    Write-Host "=== Discovery & Commercial Templates ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  1. IDEA_BRIEF (Feasibility 4-dimension scoring)"
    Write-Host "  2. SCOPE_STATEMENT (MoSCoW, RBAC, Out-of-Scope)"
    Write-Host "  3. SOW_CONTRACT (Payment terms, Single PIC, IP ownership)"
    Write-Host "  4. MARKET_RESEARCH (TAM/SAM/SOM, competitors)"
    Write-Host "  5. PRODUCT_STRATEGY (Vision, North Star, Value Prop)"
    Write-Host "  6. OKR (Objectives & Key Results)"
    Write-Host "  7. RISK_REGISTER (Risk assessment matrix)"
    Write-Host "  8. BACKLOG (User stories, RICE prioritization)"
    Write-Host "  9. Back to main menu"
    Write-Host ""

    $choice = Read-Host "Select template (1-9)"
    
    switch ($choice) {
        "1" { Copy-Template "$TemplatesDir/01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md" "docs/pm/IDEA_BRIEF.md" }
        "2" { Copy-Template "$TemplatesDir/01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md" "docs/pm/SCOPE_STATEMENT.md" }
        "3" { Copy-Template "$TemplatesDir/01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md" "contracts/SOW_CONTRACT.md" }
        "4" { Copy-Template "$TemplatesDir/01-discovery-commercial/MARKET_RESEARCH_TEMPLATE.md" "docs/pm/MARKET_RESEARCH.md" }
        "5" { Copy-Template "$TemplatesDir/01-discovery-commercial/PRODUCT_STRATEGY_TEMPLATE.md" "docs/pm/PRODUCT_STRATEGY.md" }
        "6" { Copy-Template "$TemplatesDir/01-discovery-commercial/OKR_TEMPLATE.md" "docs/pm/OKR.md" }
        "7" { Copy-Template "$TemplatesDir/01-discovery-commercial/RISK_REGISTER_TEMPLATE.md" "docs/pm/RISK_REGISTER.md" }
        "8" { Copy-Template "$TemplatesDir/01-discovery-commercial/BACKLOG_TEMPLATE.md" "docs/pm/BACKLOG.md" }
        "9" { return }
        default { Write-Host "Invalid choice" -ForegroundColor Red }
    }
}

function Show-DesignMenu {
    Write-Host ""
    Write-Host "=== Design Templates ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  1. DESIGN.md (Design tokens: colors, typography, spacing)"
    Write-Host "  2. DESIGN_SPEC (Page inventory, responsive behavior)"
    Write-Host "  3. DESIGN_SYSTEM_AUDIT (Visual inconsistency audit)"
    Write-Host "  4. DESIGN_TOKENS_SPEC (Primitive + semantic tokens)"
    Write-Host "  5. COMPONENT_API_SPEC (Props, variants, accessibility)"
    Write-Host "  6. Back to main menu"
    Write-Host ""

    $choice = Read-Host "Select template (1-6)"
    
    switch ($choice) {
        "1" { Copy-Template "$TemplatesDir/02-design/DESIGN_MD_TEMPLATE.md" "DESIGN.md" }
        "2" { Copy-Template "$TemplatesDir/02-design/DESIGN_SPEC_TEMPLATE.md" "docs/specs/DESIGN_SPEC.md" }
        "3" { Copy-Template "$TemplatesDir/02-design/DESIGN_SYSTEM_AUDIT_TEMPLATE.md" "docs/design/DESIGN_SYSTEM_AUDIT.md" }
        "4" { Copy-Template "$TemplatesDir/02-design/DESIGN_TOKENS_SPEC_TEMPLATE.md" "tokens/design-tokens.json" }
        "5" { Copy-Template "$TemplatesDir/02-design/COMPONENT_API_SPEC_TEMPLATE.md" "docs/design/COMPONENT_API_SPEC.md" }
        "6" { return }
        default { Write-Host "Invalid choice" -ForegroundColor Red }
    }
}

function Show-ArchitectureMenu {
    Write-Host ""
    Write-Host "=== Architecture & Specs Templates ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  1. PRD (Product Requirements Document)"
    Write-Host "  2. FSD (Functional Specification Document)"
    Write-Host "  3. SYSTEM_DESIGN_DOC (Load balancing, caching, HA)"
    Write-Host "  4. PROJECT_LITE (All-in-one MVP spec)"
    Write-Host "  5. CAPACITY_PLANNING (Traffic projection, resource sizing)"
    Write-Host "  6. DISASTER_RECOVERY_PLAN (RPO/RTO, backup procedures)"
    Write-Host "  7. Back to main menu"
    Write-Host ""

    $choice = Read-Host "Select template (1-7)"
    
    switch ($choice) {
        "1" { Copy-Template "$TemplatesDir/03-architecture-specs/PRD_FINAL_TEMPLATE.md" "docs/specs/PRD.md" }
        "2" { Copy-Template "$TemplatesDir/03-architecture-specs/FSD_TECHNICAL_TEMPLATE.md" "docs/specs/FSD.md" }
        "3" { Copy-Template "$TemplatesDir/03-architecture-specs/SYSTEM_DESIGN_DOC_TEMPLATE.md" "docs/specs/SYSTEM_DESIGN_DOC.md" }
        "4" { Copy-Template "$TemplatesDir/03-architecture-specs/PROJECT_LITE_TEMPLATE.md" "PROJECT_LITE.md" }
        "5" { Copy-Template "$TemplatesDir/03-architecture-specs/CAPACITY_PLANNING_TEMPLATE.md" "docs/specs/CAPACITY_PLANNING.md" }
        "6" { Copy-Template "$TemplatesDir/03-architecture-specs/DISASTER_RECOVERY_PLAN_TEMPLATE.md" "docs/specs/DISASTER_RECOVERY_PLAN.md" }
        "7" { return }
        default { Write-Host "Invalid choice" -ForegroundColor Red }
    }
}

function Show-DevelopmentMenu {
    Write-Host ""
    Write-Host "=== Development Harness Templates ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  1. AGENTS.md (AI agent instructions)"
    Write-Host "  2. CONTEXT.md (Business context, out-of-scope)"
    Write-Host "  3. TODO.md (Atomic task queue)"
    Write-Host "  4. ARCHITECTURE.md (Tech architecture summary)"
    Write-Host "  5. CONVENTIONS.md (Code style guide)"
    Write-Host "  6. RUNBOOK_LOCAL (Local setup guide)"
    Write-Host "  7. Copy all harness files at once"
    Write-Host "  8. Back to main menu"
    Write-Host ""

    $choice = Read-Host "Select template (1-8)"
    
    switch ($choice) {
        "1" { Copy-Template "$TemplatesDir/04-dev-execution/AGENTS_TEMPLATE.md" "AGENTS.md" }
        "2" { Copy-Template "$TemplatesDir/04-dev-execution/CONTEXT_TEMPLATE.md" "CONTEXT.md" }
        "3" { Copy-Template "$TemplatesDir/04-dev-execution/TODO_TEMPLATE.md" "TODO.md" }
        "4" { Copy-Template "$TemplatesDir/04-dev-execution/ARCHITECTURE_TEMPLATE.md" "ARCHITECTURE.md" }
        "5" { Copy-Template "$TemplatesDir/04-dev-execution/CONVENTIONS_TEMPLATE.md" "CONVENTIONS.md" }
        "6" { Copy-Template "$TemplatesDir/04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md" "docs/RUNBOOK_LOCAL.md" }
        "7" { 
            Copy-Template "$TemplatesDir/04-dev-execution/AGENTS_TEMPLATE.md" "AGENTS.md"
            Copy-Template "$TemplatesDir/04-dev-execution/CONTEXT_TEMPLATE.md" "CONTEXT.md"
            Copy-Template "$TemplatesDir/04-dev-execution/TODO_TEMPLATE.md" "TODO.md"
            Copy-Template "$TemplatesDir/04-dev-execution/ARCHITECTURE_TEMPLATE.md" "ARCHITECTURE.md"
            Copy-Template "$TemplatesDir/04-dev-execution/CONVENTIONS_TEMPLATE.md" "CONVENTIONS.md"
            Copy-Template "$TemplatesDir/04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md" "docs/RUNBOOK_LOCAL.md"
            Write-Host "✅ All harness files copied" -ForegroundColor Green
        }
        "8" { return }
        default { Write-Host "Invalid choice" -ForegroundColor Red }
    }
}

function Show-UseCaseMenu {
    Write-Host ""
    Write-Host "=== Use-Case Based Navigation ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  1. MVP Fast-Track (5 templates, 2 hours)"
    Write-Host "  2. Client Commercial (5 templates, legal protection)"
    Write-Host "  3. Technical Specs (6 templates, team docs)"
    Write-Host "  4. Operations (5 templates, production)"
    Write-Host "  5. View Essentials (top 20 most-used)"
    Write-Host "  6. Back to main menu"
    Write-Host ""

    $choice = Read-Host "Select use-case (1-6)"
    
    switch ($choice) {
        "1" { 
            Write-Host ""
            Write-Host "MVP Fast-Track templates:" -ForegroundColor Yellow
            Copy-Template "$TemplatesDir/03-architecture-specs/PROJECT_LITE_TEMPLATE.md" "PROJECT_LITE.md"
            Copy-Template "$TemplatesDir/02-design/DESIGN_MD_TEMPLATE.md" "DESIGN.md"
            Copy-Template "$TemplatesDir/04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md" "docs/RUNBOOK_LOCAL.md"
            Write-Host "✅ MVP Fast-Track complete" -ForegroundColor Green
            Write-Host "See templates/by-use-case/mvp-fast-track/README.md for workflow" -ForegroundColor Gray
        }
        "2" { 
            Write-Host ""
            Write-Host "Client Commercial templates:" -ForegroundColor Yellow
            Copy-Template "$TemplatesDir/01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md" "docs/pm/SCOPE_STATEMENT.md"
            Copy-Template "$TemplatesDir/01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md" "contracts/SOW_CONTRACT.md"
            Copy-Template "$TemplatesDir/07-release-handover/BAST_TEMPLATE.md" "contracts/BAST.md"
            Copy-Template "$TemplatesDir/08-maintenance-ops/WARRANTY_POLICY_TEMPLATE.md" "contracts/WARRANTY_POLICY.md"
            Copy-Template "$TemplatesDir/08-maintenance-ops/SLA_RETAINER_CONTRACT_TEMPLATE.md" "contracts/SLA_RETAINER.md"
            Write-Host "✅ Client Commercial complete" -ForegroundColor Green
            Write-Host "See templates/by-use-case/client-commercial/README.md for workflow" -ForegroundColor Gray
        }
        "3" { 
            Write-Host ""
            Write-Host "Technical Specs templates:" -ForegroundColor Yellow
            Copy-Template "$TemplatesDir/03-architecture-specs/PRD_FINAL_TEMPLATE.md" "docs/specs/PRD.md"
            Copy-Template "$TemplatesDir/03-architecture-specs/FSD_TECHNICAL_TEMPLATE.md" "docs/specs/FSD.md"
            Copy-Template "$TemplatesDir/03-architecture-specs/SYSTEM_DESIGN_DOC_TEMPLATE.md" "docs/specs/SYSTEM_DESIGN_DOC.md"
            Write-Host "✅ Technical Specs complete" -ForegroundColor Green
            Write-Host "See templates/by-use-case/technical-specs/README.md for workflow" -ForegroundColor Gray
        }
        "4" { 
            Write-Host ""
            Write-Host "Operations templates:" -ForegroundColor Yellow
            Copy-Template "$TemplatesDir/04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md" "docs/RUNBOOK_LOCAL.md"
            Copy-Template "$TemplatesDir/07-release-handover/DEPLOYMENT_PROTOCOL_TEMPLATE.md" "docs/DEPLOYMENT_PROTOCOL.md"
            Copy-Template "$TemplatesDir/07-release-handover/ROLLBACK_PLAN_TEMPLATE.md" "docs/ROLLBACK_PLAN.md"
            Copy-Template "$TemplatesDir/08-maintenance-ops/INCIDENT_RESPONSE_TEMPLATE.md" "docs/INCIDENT_RESPONSE.md"
            Copy-Template "$TemplatesDir/08-maintenance-ops/SLA_RETAINER_CONTRACT_TEMPLATE.md" "contracts/SLA_RETAINER.md"
            Write-Host "✅ Operations complete" -ForegroundColor Green
            Write-Host "See templates/by-use-case/operations/README.md for workflow" -ForegroundColor Gray
        }
        "5" {
            Write-Host ""
            Write-Host "Top 20 Most-Used Templates:" -ForegroundColor Yellow
            Write-Host "See templates/essentials/README.md for complete list" -ForegroundColor Gray
            Write-Host ""
            Write-Host "Quick picks:"
            Write-Host "  • PROJECT_LITE.md - All-in-one MVP spec (1 hour)"
            Write-Host "  • DESIGN.md - Design tokens (30 min)"
            Write-Host "  • AGENTS.md - AI instructions (15 min)"
            Write-Host "  • PRD.md - Product spec (4 hours)"
            Write-Host "  • FSD.md - Technical spec (6 hours)"
            Write-Host "  • SOW_CONTRACT.md - Client contract (2 hours)"
        }
        "6" { return }
        default { Write-Host "Invalid choice" -ForegroundColor Red }
    }
}

# Main loop
Show-Header

while ($true) {
    Show-MainMenu
    $choice = Read-Host "Enter your choice (0-9)"
    
    switch ($choice) {
        "1" { Show-DiscoveryMenu }
        "2" { Show-DesignMenu }
        "3" { Show-ArchitectureMenu }
        "4" { Show-DevelopmentMenu }
        "5" { 
            Write-Host ""
            Write-Host "QA & UAT templates - see bash version for full menu" -ForegroundColor Yellow
            Write-Host "Coming in next version" -ForegroundColor Gray
        }
        "6" { 
            Write-Host ""
            Write-Host "Deployment templates - see bash version for full menu" -ForegroundColor Yellow
            Write-Host "Coming in next version" -ForegroundColor Gray
        }
        "7" { 
            Write-Host ""
            Write-Host "Maintenance templates - see bash version for full menu" -ForegroundColor Yellow
            Write-Host "Coming in next version" -ForegroundColor Gray
        }
        "8" { 
            Copy-Template "$TemplatesDir/03-architecture-specs/PROJECT_LITE_TEMPLATE.md" "PROJECT_LITE.md"
            Write-Host "✅ PROJECT_LITE.md copied (MVP all-in-one spec)" -ForegroundColor Green
        }
        "9" { Show-UseCaseMenu }
        "0" { 
            Write-Host ""
            Write-Host "Goodbye!" -ForegroundColor Cyan
            exit 0
        }
        default { Write-Host "Invalid choice. Please enter 0-9." -ForegroundColor Red }
    }
    
    Write-Host ""
    Read-Host "Press Enter to continue"
    Clear-Host
    Show-Header
}
