# init-project.ps1 - Deterministic Project Directory Initializer
# Usage: .\scripts\init-project.ps1 -TargetDir <PATH> [-Scale <small|solo-saas|medium|large>]

param (
    [Parameter(Mandatory=$true)]
    [string]$TargetDir,

    [Parameter(Mandatory=$false)]
    [ValidateSet("small", "solo-saas", "medium", "large", "enterprise")]
    [string]$Scale = "solo-saas"
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
    (Join-Path $TargetDir "docs/specs"),
    (Join-Path $TargetDir "docs/design/inspiration"),
    (Join-Path $TargetDir "docs/design/prompts"),
    (Join-Path $TargetDir "docs/design/screens"),
    (Join-Path $TargetDir "docs/harness-root")
)
foreach ($d in $dirs) {
    if (-not (Test-Path $d)) {
        New-Item -ItemType Directory -Force -Path $d | Out-Null
    }
}

# Universal: Project State tracker
Copy-Item (Join-Path $templates "essentials/PROJECT_STATE_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/PROJECT_STATE.md") -Force
Copy-Item (Join-Path $templates "02-design/references/inspiration-template/notes-template.md") (Join-Path $TargetDir "docs/design/inspiration/notes.md") -Force
Copy-Item (Join-Path $templates "02-design/SCREEN_PROMPT_TEMPLATE.md") (Join-Path $TargetDir "docs/design/prompts/SCREEN_PROMPT_TEMPLATE.md") -Force

switch ($Scale) {
    "small" {
        Write-Host "Configuring for Small Fast-Track MVP..."
        Copy-Item (Join-Path $templates "03-architecture-specs/PROJECT_LITE_TEMPLATE.md") (Join-Path $TargetDir "PROJECT_LITE.md") -Force
        Copy-Item (Join-Path $templates "02-design/SITEMAP_TEMPLATE.md") (Join-Path $TargetDir "docs/specs/SITEMAP.md") -Force
        Copy-Item (Join-Path $templates "02-design/DESIGN_MD_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/DESIGN.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/TODO_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/TODO.md") -Force
    }
    "solo-saas" {
        Write-Host "Configuring for Solo SaaS (Self-Initiated)..."
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
    }
    "medium" {
        Write-Host "Configuring for Medium Client Commercial..."
        $contractsDir = Join-Path $TargetDir "contracts"
        if (-not (Test-Path $contractsDir)) { New-Item -ItemType Directory -Force -Path $contractsDir | Out-Null }
        Copy-Item (Join-Path $templates "01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/IDEA_BRIEF.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/SCOPE_STATEMENT.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md") (Join-Path $TargetDir "contracts/SOW_CONTRACT.md") -Force
        Copy-Item (Join-Path $templates "02-legal-commercial/NDA_TEMPLATE.md") (Join-Path $TargetDir "contracts/NDA.md") -Force
        Copy-Item (Join-Path $templates "02-design/SITEMAP_TEMPLATE.md") (Join-Path $TargetDir "docs/specs/SITEMAP.md") -Force
        Copy-Item (Join-Path $templates "02-design/COMPONENT_REQUIREMENTS_TEMPLATE.md") (Join-Path $TargetDir "docs/specs/COMPONENT_REQUIREMENTS.md") -Force
        Copy-Item (Join-Path $templates "02-design/DESIGN_SPEC_TEMPLATE.md") (Join-Path $TargetDir "docs/specs/DESIGN_SPEC.md") -Force
        Copy-Item (Join-Path $templates "02-design/DESIGN_MD_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/DESIGN.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/TODO_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/TODO.md") -Force
    }
    Default {
        Write-Host "Configuring for Large / Enterprise Scale..."
        $contractsDir = Join-Path $TargetDir "contracts"
        if (-not (Test-Path $contractsDir)) { New-Item -ItemType Directory -Force -Path $contractsDir | Out-Null }
        Copy-Item (Join-Path $templates "01-discovery-commercial/MARKET_RESEARCH_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/MARKET_RESEARCH.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/COMPETITIVE_LANDSCAPE_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/COMPETITIVE_LANDSCAPE.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/USER_RESEARCH_REPORT_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/USER_RESEARCH_REPORT.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/PRODUCT_STRATEGY_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/PRODUCT_STRATEGY.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/IDEA_BRIEF.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md") (Join-Path $TargetDir "docs/pm/SCOPE_STATEMENT.md") -Force
        Copy-Item (Join-Path $templates "01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md") (Join-Path $TargetDir "contracts/SOW_CONTRACT.md") -Force
        Copy-Item (Join-Path $templates "02-legal-commercial/NDA_TEMPLATE.md") (Join-Path $TargetDir "contracts/NDA.md") -Force
        Copy-Item (Join-Path $templates "02-design/SITEMAP_TEMPLATE.md") (Join-Path $TargetDir "docs/specs/SITEMAP.md") -Force
        Copy-Item (Join-Path $templates "02-design/COMPONENT_REQUIREMENTS_TEMPLATE.md") (Join-Path $TargetDir "docs/specs/COMPONENT_REQUIREMENTS.md") -Force
        Copy-Item (Join-Path $templates "02-design/DESIGN_SPEC_TEMPLATE.md") (Join-Path $TargetDir "docs/specs/DESIGN_SPEC.md") -Force
        Copy-Item (Join-Path $templates "02-design/DESIGN_MD_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/DESIGN.md") -Force
        Copy-Item (Join-Path $templates "04-dev-execution/TODO_TEMPLATE.md") (Join-Path $TargetDir "docs/harness-root/TODO.md") -Force
    }
}

Write-Host "✅ Project initialized successfully at: $TargetDir" -ForegroundColor Green
Write-Host "Next step: Open docs/pm/PROJECT_STATE.md and begin Phase 1."
