# init-project.ps1 - Deterministic Project Directory Initializer
# Usage: .\scripts\scaffold\init-project.ps1 -TargetDir <PATH> [-Scale <small|solo-saas|independent|open-source|medium|bespoke|freelance|large|enterprise>] [-Archetype <ACRONYM>] [-Delivery <bespoke|saas|on-premise|academic|open-source>]

param (
    [Parameter(Mandatory=$true)]
    [string]$TargetDir,

    [Parameter(Mandatory=$false)]
    [ValidateSet("small", "solo-saas", "independent", "open-source", "medium", "bespoke", "freelance", "large", "enterprise")]
    [string]$Scale = "solo-saas",

    [Parameter(Mandatory=$false)]
    [string]$Archetype = "",

    [Parameter(Mandatory=$false)]
    [string]$Delivery = ""
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir = Split-Path -Parent (Split-Path -Parent $scriptDir)
$templates = Join-Path $rootDir "templates"

Write-Host "=== Initializing New Project ===" -ForegroundColor Cyan
Write-Host "Target Directory : $TargetDir"
Write-Host "Project Scale    : $Scale"
Write-Host "--------------------------------"

# Create standard directory hierarchy
$dirs = @(
    (Join-Path $TargetDir "docs/pm"),
    (Join-Path $TargetDir "docs/pm/use-cases"),
    (Join-Path $TargetDir "docs/pm/meetings"),
    (Join-Path $TargetDir "docs/specs"),
    (Join-Path $TargetDir "docs/security"),
    (Join-Path $TargetDir "docs/design/inspiration"),
    (Join-Path $TargetDir "docs/design/prompts"),
    (Join-Path $TargetDir "docs/design/screens"),
    (Join-Path $TargetDir "docs/design/screens/css"),
    (Join-Path $TargetDir "docs/design/screens/js"),
    (Join-Path $TargetDir "docs/harness-root")
)
foreach ($d in $dirs) {
    if (-not (Test-Path $d)) {
        New-Item -ItemType Directory -Force -Path $d | Out-Null
    }
}

# Universal: Project State tracker
Copy-Item (Join-Path $templates "essentials/PROJECT_STATE_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/PROJECT_STATE.md") -Force
Copy-Item (Join-Path $templates "02-design/SCREEN_PROMPT_TEMPLATE.md") (Join-Path $TargetDir "docs/design/prompts/SCREEN_PROMPT_TEMPLATE.md") -Force
Copy-Item (Join-Path $templates "02-design/references/prototype-output/css/styles.css") (Join-Path $TargetDir "docs/design/screens/css/styles.css") -Force
Copy-Item (Join-Path $templates "02-design/references/prototype-output/js/app.js") (Join-Path $TargetDir "docs/design/screens/js/app.js") -Force

switch ($Scale) {
    { $_ -in "small", "open-source" } {
        Write-Host "Configuring for Small / Open-Source Fast-Track MVP..."
        New-Item -ItemType Directory -Force -Path (Join-Path $TargetDir "assets/logo") | Out-Null
        New-Item -ItemType Directory -Force -Path (Join-Path $TargetDir "docs/qa") | Out-Null
        # Small path: 1-benchmark LITE notes (not the 3-5 screenshot full template)
        Copy-Item (Join-Path $templates "essentials/LITE_NOTES_TEMPLATE.md") (Join-Path $TargetDir "docs/design/inspiration/notes.md") -Force
        # A1: Small scaffold = Intake + state + lite spec + root harness stubs ONLY.
        Copy-Item (Join-Path $templates "03-architecture-specs/PROJECT_LITE_TEMPLATE.md") (Join-Path $TargetDir "PROJECT_LITE.md") -Force
        Copy-Item (Join-Path $templates "essentials/INTAKE_GATE.md") (Join-Path $TargetDir "docs/pm/INTAKE_GATE.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/AGENTS_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/AGENTS.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/TODO_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/TODO.md") -Force
        if ($Delivery -eq "client") {
            $contractsDir = Join-Path $TargetDir "contracts"
            if (-not (Test-Path $contractsDir)) { New-Item -ItemType Directory -Force -Path $contractsDir | Out-Null }
            Copy-Item (Join-Path $templates "02-legal-commercial/SOW_SMB.md") (Join-Path $TargetDir "contracts/SOW_SMB.md") -Force
        }
        Write-Host ""
        Write-Host "Deferred to M04-LITE entry (run when you reach Module 04)."
        Write-Host "Small path uses LITE spec bodies (~8KB total), not the 64KB full set:"
        Write-Host "  copy essentials/LITE_SITEMAP_TEMPLATE.md -> docs/specs/SITEMAP.md"
        Write-Host "  copy essentials/LITE_COMPONENT_REQUIREMENTS_TEMPLATE.md -> docs/specs/COMPONENT_REQUIREMENTS.md"
        Write-Host "  copy essentials/LITE_DESIGN_SPEC_TEMPLATE.md -> docs/specs/DESIGN_SPEC.md"
        Write-Host "  copy 02-design/LOGO_DESIGN_BRIEF_TEMPLATE.md -> docs/specs/LOGO_DESIGN_BRIEF.md"
        Write-Host "  copy 02-design/DESIGN_MD_TEMPLATE.md -> docs/harness-root/DESIGN.md"
        Write-Host "Deferred to M06/M09/M10 (create when reached): SECURITY_CHECKLIST_SMALL.md, UAT_SIGNOFF_SMALL.md, RUNBOOK_OPS.md"
    }
    { $_ -in "solo-saas", "independent" } {
        Write-Host "Configuring for Independent / Self-Initiated Product..."
        Copy-Item (Join-Path $templates "02-design/references/inspiration-template/NOTES_TEMPLATE.md") (Join-Path $TargetDir "docs/design/inspiration/notes.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/M00_LITE_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/M00_LITE.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/INTERVIEW_GUIDE_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/INTERVIEW_GUIDE.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/IDEA_BRIEF.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/SCOPE_STATEMENT.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/REQUIREMENT_MATRIX_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/REQUIREMENT_MATRIX.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/VERIFICATION_PLAN_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/VERIFICATION_PLAN.md") -Force
        Copy-Item (Join-Path $templates "02-design/SITEMAP_TEMPLATE.md") (Join-Path $TargetDir "docs/specs/SITEMAP.md") -Force
        Copy-Item (Join-Path $templates "02-design/COMPONENT_REQUIREMENTS_TEMPLATE.md") (Join-Path $TargetDir "docs/specs/COMPONENT_REQUIREMENTS.md") -Force
        Copy-Item (Join-Path $templates "02-design/DESIGN_SPEC_TEMPLATE.md") (Join-Path $TargetDir "docs/specs/DESIGN_SPEC.md") -Force
        Copy-Item (Join-Path $templates "02-design/DESIGN_MD_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/DESIGN.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/TODO_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/TODO.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/AGENTS_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/AGENTS.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/CONTEXT_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/CONTEXT.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/ARCHITECTURE_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/ARCHITECTURE.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/CONVENTIONS_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/CONVENTIONS.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/ENV_EXAMPLE_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/.env.example") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/RUNBOOK_LOCAL.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/VERIFY_LOCAL_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/VERIFY_LOCAL.md") -Force
    }
    { $_ -in "medium", "bespoke", "freelance" } {
        Write-Host "Configuring for Medium Bespoke / Client Commercial..."
        $contractsDir = Join-Path $TargetDir "contracts"
        if (-not (Test-Path $contractsDir)) { New-Item -ItemType Directory -Force -Path $contractsDir | Out-Null }
        Copy-Item (Join-Path $templates "01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/IDEA_BRIEF.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/SCOPE_STATEMENT.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/STAKEHOLDER_MAP_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/STAKEHOLDER_MAP.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/COMMUNICATION_PLAN_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/COMMUNICATION_PLAN.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md") (Join-Path $TargetDir "contracts/SOW_CONTRACT.md") -Force
        Copy-Item (Join-Path $templates "02-legal-commercial/NDA_TEMPLATE.md") (Join-Path $TargetDir "contracts/NDA.md") -Force
        $govDirM = Join-Path $TargetDir "docs/governance"
        if (-not (Test-Path $govDirM)) { New-Item -ItemType Directory -Force -Path $govDirM | Out-Null }
        Copy-Item (Join-Path $templates "03-governance/ADR_TEMPLATE.md") (Join-Path $TargetDir "docs/governance/ADR.md") -Force
        Copy-Item (Join-Path $templates "02-design/references/inspiration-template/NOTES_TEMPLATE.md") (Join-Path $TargetDir "docs/design/inspiration/notes.md") -Force
        # Design specs deferred to M04 entry (avoids ~65KB of empty template bodies at init)
        Write-Host ""
        Write-Host "Deferred to M04 entry (run when you reach Module 04):"
        Write-Host "  copy 02-design/LOGO_DESIGN_BRIEF_TEMPLATE.md -> docs/specs/LOGO_DESIGN_BRIEF.md"
        Write-Host "  copy 02-design/SITEMAP_TEMPLATE.md -> docs/specs/SITEMAP.md"
        Write-Host "  copy 02-design/COMPONENT_REQUIREMENTS_TEMPLATE.md -> docs/specs/COMPONENT_REQUIREMENTS.md"
        Write-Host "  copy 02-design/DESIGN_SPEC_TEMPLATE.md -> docs/specs/DESIGN_SPEC.md"
        Write-Host "  copy 02-design/DESIGN_MD_TEMPLATE.md -> DESIGN.md"
        Write-Host "Deferred to M05/M06 (create when reached): PRD_FINAL_TEMPLATE.md, FSD_TECHNICAL_TEMPLATE.md, TODO_TEMPLATE.md"
    }
    "enterprise" {
        Write-Host "Configuring for Enterprise Scale (Mission-Critical / Regulated)..."
        $contractsDir = Join-Path $TargetDir "contracts"
        if (-not (Test-Path $contractsDir)) { New-Item -ItemType Directory -Force -Path $contractsDir | Out-Null }
        $qaDir = Join-Path $TargetDir "docs/qa"
        if (-not (Test-Path $qaDir)) { New-Item -ItemType Directory -Force -Path $qaDir | Out-Null }
        $govDir = Join-Path $TargetDir "docs/governance"
        Copy-Item (Join-Path $templates "02-design/references/inspiration-template/NOTES_TEMPLATE.md") (Join-Path $TargetDir "docs/design/inspiration/notes.md") -Force
        if (-not (Test-Path $govDir)) { New-Item -ItemType Directory -Force -Path $govDir | Out-Null }
        $opsDir = Join-Path $TargetDir "docs/ops"
        if (-not (Test-Path $opsDir)) { New-Item -ItemType Directory -Force -Path $opsDir | Out-Null }
        $secDir = Join-Path $TargetDir "docs/security"
        if (-not (Test-Path $secDir)) { New-Item -ItemType Directory -Force -Path $secDir | Out-Null }
        $archDir = Join-Path $TargetDir "docs/architecture"
        if (-not (Test-Path $archDir)) { New-Item -ItemType Directory -Force -Path $archDir | Out-Null }
        
        Copy-Item (Join-Path $templates "00-pre-sales-enterprise/RFP_RESPONSE_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/RFP_RESPONSE.md") -Force
        Copy-Item (Join-Path $templates "00-pre-sales-enterprise/POC_PLAN_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/POC_PLAN.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/MARKET_RESEARCH_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/MARKET_RESEARCH.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/COMPETITIVE_LANDSCAPE_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/COMPETITIVE_LANDSCAPE.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/USER_RESEARCH_REPORT_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/USER_RESEARCH_REPORT.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/PRODUCT_STRATEGY_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/PRODUCT_STRATEGY.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/IDEA_BRIEF.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/SCOPE_STATEMENT.md") -Force
        Copy-Item (Join-Path $templates "00-pre-sales-enterprise/CONSULTING_AGREEMENT_TEMPLATE.md") (Join-Path $TargetDir "contracts/CONSULTING_AGREEMENT.md") -Force
        Copy-Item (Join-Path $templates "00-pre-sales-enterprise/WBS_PHASING_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/WBS_PHASING_PLAN.md") -Force
        Copy-Item (Join-Path $templates "02-legal-commercial/NDA_TEMPLATE.md") (Join-Path $TargetDir "contracts/NDA.md") -Force
        Copy-Item (Join-Path $templates "02-design/SITEMAP_TEMPLATE.md") (Join-Path $TargetDir "docs/specs/SITEMAP.md") -Force
        Copy-Item (Join-Path $templates "02-design/COMPONENT_REQUIREMENTS_TEMPLATE.md") (Join-Path $TargetDir "docs/specs/COMPONENT_REQUIREMENTS.md") -Force
        Copy-Item (Join-Path $templates "02-design/DESIGN_SPEC_TEMPLATE.md") (Join-Path $TargetDir "docs/specs/DESIGN_SPEC.md") -Force
        Copy-Item (Join-Path $templates "02-design/DESIGN_MD_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/DESIGN.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/TODO_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/TODO.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/AGENTS_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/AGENTS.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/CONTEXT_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/CONTEXT.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/ARCHITECTURE_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/ARCHITECTURE.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/CONVENTIONS_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/CONVENTIONS.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/ENV_EXAMPLE_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/.env.example") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/RUNBOOK_LOCAL.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/VERIFY_LOCAL_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/VERIFY_LOCAL.md") -Force
        # M06 requires the 9-file harness; mirror init-project.sh so both scaffolds agree.
        Copy-Item (Join-Path $templates "04-dev-execution/AGENTS_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/AGENTS.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/CONTEXT_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/CONTEXT.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/ARCHITECTURE_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/ARCHITECTURE.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/CONVENTIONS_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/CONVENTIONS.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/ENV_EXAMPLE_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/.env.example") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/RUNBOOK_LOCAL.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/VERIFY_LOCAL_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/VERIFY_LOCAL.md") -Force
        Copy-Item (Join-Path $templates "05-data-migration/DATA_MIGRATION_PLAN_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/DATA_MIGRATION_PLAN.md") -Force
        Copy-Item (Join-Path $templates "05-data-migration/RECONCILIATION_REPORT_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/MIGRATION_RECONCILIATION_REPORT.md") -Force
        Copy-Item (Join-Path $templates "06-qa-uat/SIT_WORKBOOK_TEMPLATE.md") (Join-Path $TargetDir "docs/qa/SIT_WORKBOOK.md") -Force
        Copy-Item (Join-Path $templates "06-qa-uat/SECURITY_AUDIT_TEMPLATE.md") (Join-Path $TargetDir "docs/qa/SECURITY_AUDIT.md") -Force
        Copy-Item (Join-Path $templates "03-architecture-specs/ENTERPRISE_ARCHITECTURE_BLUEPRINT_TEMPLATE.md") (Join-Path $TargetDir "docs/architecture/ENTERPRISE_ARCHITECTURE_BLUEPRINT.md") -Force
        Copy-Item (Join-Path $templates "03-architecture-specs/THREAT_MODEL_STRIDE_TEMPLATE.md") (Join-Path $TargetDir "docs/security/THREAT_MODEL_STRIDE.md") -Force
        $procDir = Join-Path $TargetDir "docs/procurement"
        if (-not (Test-Path $procDir)) { New-Item -ItemType Directory -Force -Path $procDir | Out-Null }
        Copy-Item (Join-Path $templates "03-governance/VENDOR_PROCUREMENT_SCHEDULE_TEMPLATE.md") (Join-Path $TargetDir "docs/procurement/VENDOR_PROCUREMENT_SCHEDULE.md") -Force
        Copy-Item (Join-Path $templates "03-governance/GOVERNANCE_HANDOVER_PACK_TEMPLATE.md") (Join-Path $TargetDir "docs/governance/GOVERNANCE_HANDOVER_PACK.md") -Force
        Copy-Item (Join-Path $templates "03-governance/INCIDENT_RESPONSE_PLAN.md") (Join-Path $TargetDir "docs/pm/INCIDENT_RESPONSE.md") -Force
        Copy-Item (Join-Path $templates "03-governance/RACI_MATRIX.md") (Join-Path $TargetDir "docs/governance/RACI_MATRIX.md") -Force
        Copy-Item (Join-Path $templates "03-governance/ADR_TEMPLATE.md") (Join-Path $TargetDir "docs/governance/ADR.md") -Force
        Copy-Item (Join-Path $templates "03-governance/CAB_PROCESS.md") (Join-Path $TargetDir "docs/governance/CAB_APPROVAL.md") -Force
        Copy-Item (Join-Path $templates "03-governance/AUDIT_TRAIL_REQUIREMENTS.md") (Join-Path $TargetDir "docs/governance/AUDIT_TRAIL_REQUIREMENTS.md") -Force
        Copy-Item (Join-Path $templates "03-governance/DATA_CLASSIFICATION_POLICY.md") (Join-Path $TargetDir "docs/governance/DATA_CLASSIFICATION_POLICY.md") -Force
        Copy-Item (Join-Path $templates "08-maintenance-ops/DISASTER_RECOVERY_PLAN.md") (Join-Path $TargetDir "docs/ops/DISASTER_RECOVERY_PLAN.md") -Force
    }
    "large" {
        Write-Host "Configuring for Large Scale..."
        $contractsDir = Join-Path $TargetDir "contracts"
        if (-not (Test-Path $contractsDir)) { New-Item -ItemType Directory -Force -Path $contractsDir | Out-Null }
        $qaDir = Join-Path $TargetDir "docs/qa"
        if (-not (Test-Path $qaDir)) { New-Item -ItemType Directory -Force -Path $qaDir | Out-Null }
        Copy-Item (Join-Path $templates "02-design/references/inspiration-template/NOTES_TEMPLATE.md") (Join-Path $TargetDir "docs/design/inspiration/notes.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/MARKET_RESEARCH_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/MARKET_RESEARCH.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/COMPETITIVE_LANDSCAPE_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/COMPETITIVE_LANDSCAPE.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/USER_RESEARCH_REPORT_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/USER_RESEARCH_REPORT.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/PRODUCT_STRATEGY_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/PRODUCT_STRATEGY.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/IDEA_BRIEF.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/SCOPE_STATEMENT.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md") (Join-Path $TargetDir "contracts/SOW_CONTRACT.md") -Force
        Copy-Item (Join-Path $templates "02-legal-commercial/NDA_TEMPLATE.md") (Join-Path $TargetDir "contracts/NDA.md") -Force
        $govDirL = Join-Path $TargetDir "docs/governance"
        if (-not (Test-Path $govDirL)) { New-Item -ItemType Directory -Force -Path $govDirL | Out-Null }
        Copy-Item (Join-Path $templates "03-governance/ADR_TEMPLATE.md") (Join-Path $TargetDir "docs/governance/ADR.md") -Force
        Copy-Item (Join-Path $templates "02-design/SITEMAP_TEMPLATE.md") (Join-Path $TargetDir "docs/specs/SITEMAP.md") -Force
        Copy-Item (Join-Path $templates "02-design/COMPONENT_REQUIREMENTS_TEMPLATE.md") (Join-Path $TargetDir "docs/specs/COMPONENT_REQUIREMENTS.md") -Force
        Copy-Item (Join-Path $templates "02-design/DESIGN_SPEC_TEMPLATE.md") (Join-Path $TargetDir "docs/specs/DESIGN_SPEC.md") -Force
        Copy-Item (Join-Path $templates "02-design/DESIGN_MD_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/DESIGN.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/TODO_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/TODO.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/AGENTS_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/AGENTS.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/CONTEXT_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/CONTEXT.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/ARCHITECTURE_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/ARCHITECTURE.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/CONVENTIONS_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/CONVENTIONS.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/ENV_EXAMPLE_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/.env.example") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/RUNBOOK_LOCAL.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/VERIFY_LOCAL_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/VERIFY_LOCAL.md") -Force
        Copy-Item (Join-Path $templates "05-data-migration/DATA_MIGRATION_PLAN_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/DATA_MIGRATION_PLAN.md") -Force
        Copy-Item (Join-Path $templates "05-data-migration/RECONCILIATION_REPORT_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/MIGRATION_RECONCILIATION_REPORT.md") -Force
        Copy-Item (Join-Path $templates "06-qa-uat/SIT_WORKBOOK_TEMPLATE.md") (Join-Path $TargetDir "docs/qa/SIT_WORKBOOK.md") -Force
        Copy-Item (Join-Path $templates "06-qa-uat/SECURITY_AUDIT_TEMPLATE.md") (Join-Path $TargetDir "docs/qa/SECURITY_AUDIT.md") -Force
    }
    Default {
        Write-Host "Invalid scale: $Scale (options: small | solo-saas | independent | open-source | medium | bespoke | freelance | large | enterprise)" -ForegroundColor Red
        exit 1
    }
}

if ($Archetype) {
    Write-Host "Applying Archetype metadata ($Archetype)..."
    $ideaBriefPath = Join-Path $TargetDir "docs/pm/IDEA_BRIEF.md"
    if (Test-Path $ideaBriefPath) {
        $content = Get-Content $ideaBriefPath -Raw
        $content = $content -replace '- \*\*Industry Archetype\*\*:\s*\[.+?\]', "- **Industry Archetype**: $Archetype (from references/taxonomy/SYSTEM_ARCHETYPES_250.md)"
        Set-Content -Path $ideaBriefPath -Value $content -Encoding utf8
    }
    $projectLitePath = Join-Path $TargetDir "PROJECT_LITE.md"
    if (Test-Path $projectLitePath) {
        $content = Get-Content $projectLitePath -Raw
        $content = $content -replace '- \*\*Industry Archetype\*\*:\s*\[.+?\]', "- **Industry Archetype**: $Archetype (from references/taxonomy/SYSTEM_ARCHETYPES_250.md)"
        Set-Content -Path $projectLitePath -Value $content -Encoding utf8
    }
}

if ($Delivery) {
    Write-Host "Applying Delivery Model ($Delivery)..."
    $ideaBriefPath = Join-Path $TargetDir "docs/pm/IDEA_BRIEF.md"
    if (Test-Path $ideaBriefPath) {
        $content = Get-Content $ideaBriefPath -Raw
        $content = $content -replace '- \*\*Delivery Model\*\*:\s*\[.+?\]', "- **Delivery Model**: $Delivery"
        Set-Content -Path $ideaBriefPath -Value $content -Encoding utf8
    }
    $projectLitePath = Join-Path $TargetDir "PROJECT_LITE.md"
    if (Test-Path $projectLitePath) {
        $content = Get-Content $projectLitePath -Raw
        $content = $content -replace '- \*\*Delivery Model\*\*:\s*\[.+?\]', "- **Delivery Model**: $Delivery"
        Set-Content -Path $projectLitePath -Value $content -Encoding utf8
    }
}

Write-Host "[OK] Project initialized successfully at: $TargetDir" -ForegroundColor Green
Write-Host "Next step: Open docs/pm/PROJECT_STATE.md and begin Phase 1."
Write-Host ""
Write-Host "Before Module 04 (any scale): place >=1 design reference in" -ForegroundColor Yellow
Write-Host "  docs/design/inspiration/ (screenshot, brand board, or links.md of URLs)." -ForegroundColor Yellow
Write-Host "  notes.md there is the analysis, not the reference - M04 stops until a" -ForegroundColor Yellow
Write-Host "  human-supplied file exists (validate-gate.sh M04/M06 enforce it)." -ForegroundColor Yellow
