# Template Picker (PowerShell)
# Interactive template selection tool
# Usage: .\scripts\template-picker.ps1

param(
    [string]$Phase,
    [string]$Dest = ".",
    [switch]$DryRun,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$TemplatesDir = "templates"

function Show-Header {
    Write-Host ""
    Write-Host "+=======================================================+" -ForegroundColor Cyan
    Write-Host "|      Solo Project Lifecycle - Template Picker         |" -ForegroundColor Cyan
    Write-Host "+=======================================================+" -ForegroundColor Cyan
    Write-Host ""
}

function Show-MainMenu {
    Write-Host "Select project phase:" -ForegroundColor Green
    Write-Host "  1. Discovery & Commercial (Idea, Scope, SOW)"
    Write-Host "  1b. Pre-Sales & Enterprise (RFP, POC Plan)"
    Write-Host "  2. Design (UI/UX, Design System, Components)"
    Write-Host "  3. Architecture & Specs (PRD, FSD, System Design)"
    Write-Host "  3b. Governance & Enterprise Compliance (ADR, RACI, Risk, Policies)"
    Write-Host "  4. Development Harness (AGENTS, TODO, CONTEXT)"
    Write-Host "  5. Data Migration & Seeding (ETL Plan, Reconciliation)"
    Write-Host "  6. QA & UAT (SIT, Security Audit, UAT)"
    Write-Host "  7. Deployment & Handover (BAST, Deployment Protocol)"
    Write-Host "  8. Maintenance & Growth (SLA, Analytics, Experiments)"
    Write-Host "  9. MVP Fast-Track (PROJECT_LITE only)"
    Write-Host "  10. Use-Case Based (by task, not phase)"
    Write-Host "  0. Exit"
    Write-Host ""
}

function Copy-Template {
    param(
        [string]$Source,
        [string]$Destination
    )

    $targetPath = Join-Path $Dest $Destination
    if ($DryRun) {
        Write-Host "[DRY-RUN] Would copy: $Source -> $targetPath" -ForegroundColor Cyan
        return
    }

    if (Test-Path $targetPath) {
        if (-not $Force) {
            Write-Host "[WARN] File exists: $targetPath" -ForegroundColor Yellow
            $confirm = Read-Host "Overwrite? (y/N)"
            if ($confirm -ne "y" -and $confirm -ne "Y") {
                Write-Host "Skipped."
                return
            }
        }
    }

    $destDir = Split-Path -Parent $targetPath
    if ($destDir -and -not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }

    Copy-Item $Source $targetPath -Force
    Write-Host "[OK] Copied to: $targetPath" -ForegroundColor Green
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

function Show-PreSalesMenu {
    Write-Host ""
    Write-Host "=== Pre-Sales & Enterprise Templates ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  1. POC_PLAN (Enterprise proof of concept scope & criteria)"
    Write-Host "  2. RFP_RESPONSE (Formal proposal for enterprise RFP)"
    Write-Host "  3. Back to main menu"
    Write-Host ""

    $choice = Read-Host "Select template (1-3)"

    switch ($choice) {
        "1" { Copy-Template "$TemplatesDir/00-pre-sales-enterprise/POC_PLAN_TEMPLATE.md" "docs/pm/POC_PLAN.md" }
        "2" { Copy-Template "$TemplatesDir/00-pre-sales-enterprise/RFP_RESPONSE_TEMPLATE.md" "docs/pm/RFP_RESPONSE.md" }
        "3" { return }
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

function Show-GovernanceMenu {
    Write-Host ""
    Write-Host "=== Enterprise Governance & Compliance Templates ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  1. ADR (Architecture Decision Record)"
    Write-Host "  2. CAB_PROCESS (Change Advisory Board)"
    Write-Host "  3. RACI_MATRIX (Responsibility assignment)"
    Write-Host "  4. RISK_ASSESSMENT_MATRIX (5x5 matrix)"
    Write-Host "  5. GDPR_COMPLIANCE_CHECKLIST"
    Write-Host "  6. SOC2_ISO27001_COMPLIANCE"
    Write-Host "  7. DATA_CLASSIFICATION_POLICY"
    Write-Host "  8. DATA_RETENTION_POLICY"
    Write-Host "  9. AUDIT_TRAIL_REQUIREMENTS"
    Write-Host "  10. Back to main menu"
    Write-Host ""

    $choice = Read-Host "Select template (1-10)"

    switch ($choice) {
        "1" { Copy-Template "$TemplatesDir/03-governance/ADR_TEMPLATE.md" "docs/adr/ADR_001.md" }
        "2" { Copy-Template "$TemplatesDir/03-governance/CAB_PROCESS.md" "docs/pm/CAB_PROCESS.md" }
        "3" { Copy-Template "$TemplatesDir/03-governance/RACI_MATRIX.md" "docs/pm/RACI_MATRIX.md" }
        "4" { Copy-Template "$TemplatesDir/03-governance/RISK_ASSESSMENT_MATRIX.md" "docs/pm/RISK_ASSESSMENT_MATRIX.md" }
        "5" { Copy-Template "$TemplatesDir/03-governance/GDPR_COMPLIANCE_CHECKLIST.md" "docs/compliance/GDPR_CHECKLIST.md" }
        "6" { Copy-Template "$TemplatesDir/03-governance/SOC2_ISO27001_COMPLIANCE.md" "docs/compliance/SOC2_ISO27001.md" }
        "7" { Copy-Template "$TemplatesDir/03-governance/DATA_CLASSIFICATION_POLICY.md" "docs/compliance/DATA_CLASSIFICATION.md" }
        "8" { Copy-Template "$TemplatesDir/03-governance/DATA_RETENTION_POLICY.md" "docs/compliance/DATA_RETENTION.md" }
        "9" { Copy-Template "$TemplatesDir/03-governance/AUDIT_TRAIL_REQUIREMENTS.md" "docs/compliance/AUDIT_TRAIL.md" }
        "10" { return }
        default { Write-Host "Invalid choice" -ForegroundColor Red }
    }
}

function Show-DataMigrationMenu {
    Write-Host ""
    Write-Host "=== Data Migration & Seeding Templates ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  1. DATA_MIGRATION_PLAN (Source-to-target mapping & validation)"
    Write-Host "  2. RECONCILIATION_REPORT (Import verification & sign-off)"
    Write-Host "  3. DATA_MIGRATION_LITE (Lightweight CSV/Excel import checklist)"
    Write-Host "  4. Back to main menu"
    Write-Host ""

    $choice = Read-Host "Select template (1-4)"

    switch ($choice) {
        "1" { Copy-Template "$TemplatesDir/05-data-migration/DATA_MIGRATION_PLAN_TEMPLATE.md" "docs/migration/DATA_MIGRATION_PLAN.md" }
        "2" { Copy-Template "$TemplatesDir/05-data-migration/RECONCILIATION_REPORT_TEMPLATE.md" "docs/migration/RECONCILIATION_REPORT.md" }
        "3" { Copy-Template "$TemplatesDir/05-data-migration/DATA_MIGRATION_LITE.md" "docs/migration/DATA_MIGRATION_LITE.md" }
        "4" { return }
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
    Write-Host "  6. DESIGN.md (Design tokens)"
    Write-Host "  7. .env.example (Environment variables)"
    Write-Host "  8. RUNBOOK_LOCAL.md (Local setup guide)"
    Write-Host "  9. VERIFY_LOCAL.md (Verification checklist)"
    Write-Host "  10. Copy all 9 harness files at once"
    Write-Host "  11. Back to main menu"
    Write-Host ""

    $choice = Read-Host "Select template (1-11)"
    
    switch ($choice) {
        "1" { Copy-Template "$TemplatesDir/04-dev-execution/AGENTS_TEMPLATE.md" "AGENTS.md" }
        "2" { Copy-Template "$TemplatesDir/04-dev-execution/CONTEXT_TEMPLATE.md" "CONTEXT.md" }
        "3" { Copy-Template "$TemplatesDir/04-dev-execution/TODO_TEMPLATE.md" "TODO.md" }
        "4" { Copy-Template "$TemplatesDir/04-dev-execution/ARCHITECTURE_TEMPLATE.md" "ARCHITECTURE.md" }
        "5" { Copy-Template "$TemplatesDir/04-dev-execution/CONVENTIONS_TEMPLATE.md" "CONVENTIONS.md" }
        "6" { Copy-Template "$TemplatesDir/02-design/DESIGN_MD_TEMPLATE.md" "DESIGN.md" }
        "7" { Copy-Template "$TemplatesDir/04-dev-execution/ENV_EXAMPLE_TEMPLATE.md" ".env.example" }
        "8" { Copy-Template "$TemplatesDir/04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md" "RUNBOOK_LOCAL.md" }
        "9" { Copy-Template "$TemplatesDir/04-dev-execution/VERIFY_LOCAL_TEMPLATE.md" "VERIFY_LOCAL.md" }
        "10" {
            Copy-Template "$TemplatesDir/04-dev-execution/AGENTS_TEMPLATE.md" "AGENTS.md"
            Copy-Template "$TemplatesDir/04-dev-execution/CONTEXT_TEMPLATE.md" "CONTEXT.md"
            Copy-Template "$TemplatesDir/04-dev-execution/TODO_TEMPLATE.md" "TODO.md"
            Copy-Template "$TemplatesDir/04-dev-execution/ARCHITECTURE_TEMPLATE.md" "ARCHITECTURE.md"
            Copy-Template "$TemplatesDir/04-dev-execution/CONVENTIONS_TEMPLATE.md" "CONVENTIONS.md"
            Copy-Template "$TemplatesDir/02-design/DESIGN_MD_TEMPLATE.md" "DESIGN.md"
            Copy-Template "$TemplatesDir/04-dev-execution/ENV_EXAMPLE_TEMPLATE.md" ".env.example"
            Copy-Template "$TemplatesDir/04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md" "RUNBOOK_LOCAL.md"
            Copy-Template "$TemplatesDir/04-dev-execution/VERIFY_LOCAL_TEMPLATE.md" "VERIFY_LOCAL.md"
            Write-Host "[OK] All 9 harness files copied" -ForegroundColor Green
        }
        "11" { return }
        default { Write-Host "Invalid choice" -ForegroundColor Red }
    }
}

function Show-QAMenu {
    Write-Host ""
    Write-Host "=== QA & UAT Templates ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  1. SIT_WORKBOOK (System Integration Testing)"
    Write-Host "  2. SECURITY_AUDIT (OWASP Top 10, UU PDP)"
    Write-Host "  3. UAT_WORKBOOK (User Acceptance Testing)"
    Write-Host "  4. UAT_SIGNOFF (Formal sign-off document)"
    Write-Host "  5. Back to main menu"
    Write-Host ""
    $choice = Read-Host "Select template (1-5)"
    switch ($choice) {
        "1" { Copy-Template "$TemplatesDir/06-qa-uat/SIT_WORKBOOK_TEMPLATE.md" "docs/qa/SIT_WORKBOOK.md" }
        "2" { Copy-Template "$TemplatesDir/06-qa-uat/SECURITY_AUDIT_TEMPLATE.md" "docs/qa/SECURITY_AUDIT.md" }
        "3" { Copy-Template "$TemplatesDir/06-qa-uat/UAT_WORKBOOK_TEMPLATE.md" "docs/qa/UAT_WORKBOOK.md" }
        "4" { Copy-Template "$TemplatesDir/06-qa-uat/UAT_SIGNOFF_TEMPLATE.md" "docs/pm/UAT_SIGNOFF_REPORT.md" }
        "5" { return }
        default { Write-Host "Invalid choice" -ForegroundColor Red }
    }
}

function Show-DeploymentMenu {
    Write-Host ""
    Write-Host "=== Deployment & Handover Templates ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  1. DEPLOYMENT_PROTOCOL (Go-live checklist)"
    Write-Host "  2. ROLLBACK_PLAN (15-min recovery procedure)"
    Write-Host "  3. BAST (Berita Acara Serah Terima)"
    Write-Host "  4. HANDOVER_PROTOCOL (Repo & credentials transfer)"
    Write-Host "  5. USER_MANUAL (End-user documentation)"
    Write-Host "  6. Back to main menu"
    Write-Host ""
    $choice = Read-Host "Select template (1-6)"
    switch ($choice) {
        "1" { Copy-Template "$TemplatesDir/07-release-handover/DEPLOYMENT_PROTOCOL_TEMPLATE.md" "docs/DEPLOYMENT_PROTOCOL.md" }
        "2" { Copy-Template "$TemplatesDir/07-release-handover/ROLLBACK_PLAN_TEMPLATE.md" "docs/ROLLBACK_PLAN.md" }
        "3" { Copy-Template "$TemplatesDir/07-release-handover/BAST_TEMPLATE.md" "contracts/BAST.md" }
        "4" { Copy-Template "$TemplatesDir/07-release-handover/HANDOVER_PROTOCOL_TEMPLATE.md" "docs/HANDOVER_PROTOCOL.md" }
        "5" { Copy-Template "$TemplatesDir/07-release-handover/USER_MANUAL_TEMPLATE.md" "docs/USER_MANUAL.md" }
        "6" { return }
        default { Write-Host "Invalid choice" -ForegroundColor Red }
    }
}

function Show-MaintenanceMenu {
    Write-Host ""
    Write-Host "=== Maintenance & Growth Templates ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  1. WARRANTY_POLICY (Bug fix boundaries)"
    Write-Host "  2. SLA_RETAINER_CONTRACT (Monthly retainer)"
    Write-Host "  3. INCIDENT_RESPONSE (RCA, post-mortem)"
    Write-Host "  4. EVENT_TAXONOMY (Analytics event spec)"
    Write-Host "  5. METRICS_BASELINE_REPORT (30-day baseline)"
    Write-Host "  6. GROWTH_EXPERIMENTS_BACKLOG (RICE-scored experiments)"
    Write-Host "  7. AB_TEST_REPORT (Experiment results)"
    Write-Host "  8. Back to main menu"
    Write-Host ""
    $choice = Read-Host "Select template (1-8)"
    switch ($choice) {
        "1" { Copy-Template "$TemplatesDir/08-maintenance-ops/WARRANTY_POLICY_TEMPLATE.md" "docs/WARRANTY_POLICY.md" }
        "2" { Copy-Template "$TemplatesDir/08-maintenance-ops/SLA_RETAINER_CONTRACT_TEMPLATE.md" "contracts/SLA_RETAINER.md" }
        "3" { Copy-Template "$TemplatesDir/08-maintenance-ops/INCIDENT_RESPONSE_TEMPLATE.md" "docs/INCIDENT_RESPONSE.md" }
        "4" { Copy-Template "$TemplatesDir/09-product-growth/EVENT_TAXONOMY_TEMPLATE.md" "docs/analytics/EVENT_TAXONOMY.md" }
        "5" { Copy-Template "$TemplatesDir/09-product-growth/METRICS_BASELINE_REPORT_TEMPLATE.md" "docs/pm/METRICS_BASELINE_REPORT.md" }
        "6" { Copy-Template "$TemplatesDir/09-product-growth/GROWTH_EXPERIMENTS_BACKLOG_TEMPLATE.md" "docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md" }
        "7" { Copy-Template "$TemplatesDir/09-product-growth/AB_TEST_REPORT_TEMPLATE.md" "docs/analytics/AB_TEST_REPORT.md" }
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
            Write-Host "[OK] MVP Fast-Track complete" -ForegroundColor Green
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
            Write-Host "[OK] Client Commercial complete" -ForegroundColor Green
            Write-Host "See templates/by-use-case/client-commercial/README.md for workflow" -ForegroundColor Gray
        }
        "3" { 
            Write-Host ""
            Write-Host "Technical Specs templates:" -ForegroundColor Yellow
            Copy-Template "$TemplatesDir/03-architecture-specs/PRD_FINAL_TEMPLATE.md" "docs/specs/PRD.md"
            Copy-Template "$TemplatesDir/03-architecture-specs/FSD_TECHNICAL_TEMPLATE.md" "docs/specs/FSD.md"
            Copy-Template "$TemplatesDir/03-architecture-specs/SYSTEM_DESIGN_DOC_TEMPLATE.md" "docs/specs/SYSTEM_DESIGN_DOC.md"
            Write-Host "[OK] Technical Specs complete" -ForegroundColor Green
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
            Write-Host "[OK] Operations complete" -ForegroundColor Green
            Write-Host "See templates/by-use-case/operations/README.md for workflow" -ForegroundColor Gray
        }
        "5" {
            Write-Host ""
            Write-Host "Top 20 Most-Used Templates:" -ForegroundColor Yellow
            Write-Host "See templates/essentials/README.md for complete list" -ForegroundColor Gray
            Write-Host ""
            Write-Host "Quick picks:"
            Write-Host "  - PROJECT_LITE.md - All-in-one MVP spec (1 hour)"
            Write-Host "  - DESIGN.md - Design tokens (30 min)"
            Write-Host "  - AGENTS.md - AI instructions (15 min)"
            Write-Host "  - PRD.md - Product spec (4 hours)"
            Write-Host "  - FSD.md - Technical spec (6 hours)"
            Write-Host "  - SOW_CONTRACT.md - Client contract (2 hours)"
        }
        "6" { return }
        default { Write-Host "Invalid choice" -ForegroundColor Red }
    }
}

# Main loop
if ($Phase) {
    switch ($Phase) {
        "1" { Show-DiscoveryMenu; exit 0 }
        "1b" { Show-PreSalesMenu; exit 0 }
        "2" { Show-DesignMenu; exit 0 }
        "3" { Show-ArchitectureMenu; exit 0 }
        "3b" { Show-GovernanceMenu; exit 0 }
        "4" { Show-DevelopmentMenu; exit 0 }
        "5" { Show-DataMigrationMenu; exit 0 }
        "6" { Show-QAMenu; exit 0 }
        "7" { Show-DeploymentMenu; exit 0 }
        "8" { Show-MaintenanceMenu; exit 0 }
        "9" {
            Copy-Template "$TemplatesDir/03-architecture-specs/PROJECT_LITE_TEMPLATE.md" "PROJECT_LITE.md"
            Write-Host "[OK] PROJECT_LITE.md copied (MVP all-in-one spec)" -ForegroundColor Green
            exit 0
        }
        "PROJECT_LITE" {
            Copy-Template "$TemplatesDir/03-architecture-specs/PROJECT_LITE_TEMPLATE.md" "PROJECT_LITE.md"
            Write-Host "[OK] PROJECT_LITE.md copied (MVP all-in-one spec)" -ForegroundColor Green
            exit 0
        }
        default { Write-Host "[ERROR] Unknown phase: $Phase" -ForegroundColor Red; exit 1 }
    }
}

Show-Header

while ($true) {
    Show-MainMenu
    $choice = Read-Host "Enter your choice (0-9)"
    
    switch ($choice) {
        "1" { Show-DiscoveryMenu }
        "1b" { Show-PreSalesMenu }
        "1B" { Show-PreSalesMenu }
        "2" { Show-DesignMenu }
        "3" { Show-ArchitectureMenu }
        "3b" { Show-GovernanceMenu }
        "3B" { Show-GovernanceMenu }
        "4" { Show-DevelopmentMenu }
        "5" { Show-DataMigrationMenu }
        "6" { Show-QAMenu }
        "7" { Show-DeploymentMenu }
        "8" { Show-MaintenanceMenu }
        "9" { 
            Copy-Template "$TemplatesDir/03-architecture-specs/PROJECT_LITE_TEMPLATE.md" "PROJECT_LITE.md"
            Write-Host "[OK] PROJECT_LITE.md copied (MVP all-in-one spec)" -ForegroundColor Green
        }
        "10" { Show-UseCaseMenu }
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
