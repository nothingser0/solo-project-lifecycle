# Gate Validation Script (PowerShell)
# Validates module completion before proceeding to next phase
# Usage: .\scripts\validate-gate.ps1 -Module "M03"

param(
    [Parameter(Mandatory=$true)]
    [string]$Module
)

$ErrorActionPreference = "Stop"

# Gate definitions
$Gates = @{
    "M00" = @{
        Name = "Product Discovery & Strategy"
        Required = @(
            "docs/pm/MARKET_RESEARCH.md",
            "docs/pm/COMPETITIVE_LANDSCAPE.md",
            "docs/pm/USER_RESEARCH_REPORT.md",
            "docs/pm/PRODUCT_STRATEGY.md"
        )
        Optional = @(
            "docs/pm/M00_LITE.md"
        )
    }
    "M01" = @{
        Name = "Idea Feasibility"
        Required = @(
            "docs/pm/IDEA_BRIEF.md"
        )
        Optional = @()
    }
    "M02" = @{
        Name = "Discovery & Scope"
        Required = @(
            "docs/pm/SCOPE_STATEMENT.md"
        )
        Optional = @()
    }
    "M03" = @{
        Name = "Legal SOW & Charter"
        Required = @(
            "contracts/SOW_CONTRACT.md"
        )
        Optional = @(
            "contracts/NDA.md"
        )
    }
    "M04" = @{
        Name = "UI/UX Prototyping"
        Required = @(
            "docs/specs/SITEMAP.md",
            "docs/specs/COMPONENT_REQUIREMENTS.md",
            "DESIGN.md",
            "docs/specs/DESIGN_SPEC.md"
        )
        Optional = @(
            "docs/specs/LOGO_DESIGN_BRIEF.md",
            "docs/design/inspiration/notes.md"
        )
    }
    "M05" = @{
        Name = "Architecture & Specs"
        Required = @(
            "docs/specs/PRD.md",
            "docs/specs/FSD.md"
        )
        Optional = @(
            "PROJECT_LITE.md"
        )
    }
    "M06" = @{
        Name = "Development Execution"
        Required = @(
            "AGENTS.md",
            "CONTEXT.md",
            "TODO.md",
            "docs/RUNBOOK_LOCAL.md"
        )
        Optional = @(
            "ARCHITECTURE.md",
            "CONVENTIONS.md"
        )
    }
    "M07" = @{
        Name = "Quality Assurance"
        Required = @(
            "docs/qa/SIT_WORKBOOK.md"
        )
        Optional = @(
            "docs/qa/SECURITY_AUDIT.md"
        )
    }
    "M08" = @{
        Name = "Data Migration & Seeding"
        Required = @(
            "docs/pm/DATA_MIGRATION_PLAN.md"
        )
        Optional = @(
            "docs/pm/MIGRATION_RECONCILIATION_REPORT.md"
        )
    }
    "M09" = @{
        Name = "UAT & Client Sign-off"
        Required = @(
            "docs/pm/UAT_SIGNOFF_REPORT.md"
        )
        Optional = @(
            "docs/qa/UAT_WORKBOOK.md"
        )
    }
    "M10" = @{
        Name = "Deployment Production"
        Required = @(
            "docs/DEPLOYMENT_PROTOCOL.md"
        )
        Optional = @(
            "docs/ROLLBACK_PLAN.md"
        )
    }
    "M11" = @{
        Name = "Handover & BAST"
        Required = @(
            "docs/pm/BAST.md"
        )
        Optional = @(
            "docs/pm/GO_LIVE_REPORT.md",
            "docs/pm/HANDOVER_PROTOCOL.md",
            "docs/USER_MANUAL.md"
        )
    }
    "M12" = @{
        Name = "Warranty SLA Retainer"
        Required = @(
            "docs/pm/WARRANTY_POLICY.md"
        )
        Optional = @(
            "docs/pm/SLA_RETAINER_CONTRACT.md",
            "docs/pm/INCIDENT_RESPONSE.md"
        )
    }
    "M13" = @{
        Name = "Product Operations & Iteration"
        Required = @(
            "docs/pm/METRICS_BASELINE_REPORT.md"
        )
        Optional = @(
            "docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md"
        )
    }
}

# Check if module exists
if (-not $Gates.ContainsKey($Module)) {
    Write-Host "[ERROR] Unknown module: $Module" -ForegroundColor Red
    Write-Host "Available modules: $($Gates.Keys -join ', ')" -ForegroundColor Yellow
    exit 1
}

$gate = $Gates[$Module]
Write-Host "`n[INFO] Validating gate: $Module - $($gate.Name)" -ForegroundColor Cyan
Write-Host ("=" * 60)

$missingRequired = @()
$missingOptional = @()
$foundFiles = @()

# Check required files
Write-Host "`nRequired files:" -ForegroundColor White
if ($Module -eq "M00" -and (Test-Path "docs/pm/M00_LITE.md")) {
    Write-Host "  [INFO] Detected M00-lite rapid validation path" -ForegroundColor Cyan
    $gate.Required = @("docs/pm/M00_LITE.md")
}
if ($Module -eq "M04" -and (Test-Path "PROJECT_LITE.md")) {
    Write-Host "  [INFO] Detected Small-Scale Fast-Track MVP path (PROJECT_LITE.md)" -ForegroundColor Cyan
    $gate.Required = @("docs/specs/SITEMAP.md", "DESIGN.md")
}
if ($Module -eq "M05" -and (Test-Path "PROJECT_LITE.md")) {
    Write-Host "  [INFO] Detected Small-Scale Fast-Track MVP path (PROJECT_LITE.md)" -ForegroundColor Cyan
    $gate.Required = @("PROJECT_LITE.md")
}
foreach ($file in $gate.Required) {
    $pathExists = Test-Path $file
    if (-not $pathExists -and $file -eq "docs/pm/COMPETITIVE_LANDSCAPE.md" -and (Test-Path "docs/pm/COMPETITOR_ANALYSIS.md")) {
        $pathExists = $true
    }
    if (-not $pathExists -and $file -eq "DESIGN.md" -and (Test-Path "docs/harness-root/DESIGN.md")) {
        $pathExists = $true
    }
    if (-not $pathExists -and $file -eq "contracts/SOW_CONTRACT.md" -and (Test-Path "docs/pm/SOW_CONTRACT.md")) {
        $pathExists = $true
    }
    if (-not $pathExists -and $file -eq "contracts/BAST.md" -and (Test-Path "docs/pm/BAST.md")) {
        $pathExists = $true
    }
    if (-not $pathExists -and $file -eq "docs/DEPLOYMENT_PROTOCOL.md" -and (Test-Path "docs/pm/DEPLOYMENT_PROTOCOL.md")) {
        $pathExists = $true
    }
    if (-not $pathExists -and $file -eq "docs/pm/METRICS_BASELINE_REPORT.md" -and (Test-Path "docs/analytics/METRICS_BASELINE_REPORT.md")) {
        $pathExists = $true
    }
    if (-not $pathExists -and $file -eq "docs/pm/IDEA_BRIEF.md" -and (Test-Path "docs/pm/FEASIBILITY_REPORT.md")) {
        $pathExists = $true
    }
    if ($pathExists) {
        Write-Host "  [OK] $file" -ForegroundColor Green
        $foundFiles += $file
    } else {
        Write-Host "  [ERROR] $file (MISSING)" -ForegroundColor Red
        $missingRequired += $file
    }
}
if ($Module -eq "M00") {
    $userResearchFile = if (Test-Path "docs/pm/M00_LITE.md") { "docs/pm/M00_LITE.md" } elseif (Test-Path "docs/pm/USER_RESEARCH_REPORT.md") { "docs/pm/USER_RESEARCH_REPORT.md" } else { $null }
    if ($userResearchFile) {
        $content = Get-Content $userResearchFile -Raw
        if ($content -match "PENDING_PRIMARY_RESEARCH") {
            Write-Host "  [WARN] Gate status: PENDING_PRIMARY_RESEARCH (Real user validation required)" -ForegroundColor Yellow
        } elseif ($content -match "PASS" -or $content -match "intent.*[3-9][0-9]%" -or $content -match "intent.*100%") {
            Write-Host "  [OK] Market validation gate criteria verified" -ForegroundColor Green
        }
    }
} elseif ($Module -eq "M02") {
    if (Test-Path "docs/pm/SCOPE_STATEMENT.md") {
        $scopeContent = Get-Content "docs/pm/SCOPE_STATEMENT.md" -Raw
        $scopeLines = Get-Content "docs/pm/SCOPE_STATEMENT.md"
        $mustLines = $scopeLines | Where-Object { $_ -match '\|.*(must|p0).*\|' }
        $hasAmbiguity = $mustLines | Where-Object { $_ -match 'TBD|maybe|if time permits|tentative|TBA' }
        if ($hasAmbiguity) {
            Write-Host "  [ERROR] Ambiguous terms (TBD/maybe/if time permits) detected in Must-Have rows!" -ForegroundColor Red
        } else {
            Write-Host "  [OK] Zero ambiguous terms in Must-Have scope rows" -ForegroundColor Green
        }
        if ($scopeContent -match '✅' -or $scopeContent -match 'VERIFIED') {
            Write-Host "  [OK] Data Confidence Legend / status markers present" -ForegroundColor Green
        }
        if ($scopeContent -match 'out-of-scope') {
            Write-Host "  [OK] Explicit Out-of-Scope boundaries defined" -ForegroundColor Green
        }
    }
} elseif ($Module -eq "M03") {
    $sowFile = if (Test-Path "contracts/SOW_CONTRACT.md") { "contracts/SOW_CONTRACT.md" } elseif (Test-Path "docs/pm/SOW_CONTRACT.md") { "docs/pm/SOW_CONTRACT.md" } else { $null }
    if ($sowFile) {
        $sowContent = Get-Content $sowFile -Raw
        if ($sowContent -match '(?i)bypass|waived|solo saas|self-initiated') {
            Write-Host "  [INFO] Solo SaaS / Self-Initiated product: Commercial SOW gate is WAIVED." -ForegroundColor Cyan
        } else {
            if ($sowContent -match '(?i)Termin|Milestone.*Payment|Down Payment|DP') {
                Write-Host "  [OK] Payment terms defined" -ForegroundColor Green
            } else {
                Write-Host "  [ERROR] Payment terms not clearly defined!" -ForegroundColor Red
            }
            if ($sowContent -match '(?i)Single PIC') {
                Write-Host "  [OK] Single PIC clause present" -ForegroundColor Green
            } else {
                Write-Host "  [ERROR] Single PIC clause missing!" -ForegroundColor Red
            }
            if ($sowContent -match '(?i)Limitation of Liability|Liability Cap') {
                Write-Host "  [OK] Limitation of liability clause present" -ForegroundColor Green
            }
        }
    }
}

# Check optional files
if ($gate.Optional.Count -gt 0) {
    Write-Host "`nOptional files:" -ForegroundColor White
    foreach ($file in $gate.Optional) {
        if (-not (Test-Path $file) -and $file -eq "docs/qa/SECURITY_AUDIT.md" -and (Test-Path "docs/qa/SECURITY_AUDIT_REPORT.md")) {
            $file = "docs/qa/SECURITY_AUDIT_REPORT.md"
        }
        if (-not (Test-Path $file) -and $file -eq "docs/ROLLBACK_PLAN.md" -and (Test-Path "docs/pm/ROLLBACK_PLAN.md")) {
            $file = "docs/pm/ROLLBACK_PLAN.md"
        }
        if (-not (Test-Path $file) -and $file -eq "docs/pm/HANDOVER_PROTOCOL.md" -and (Test-Path "docs/HANDOVER_PROTOCOL.md")) {
            $file = "docs/HANDOVER_PROTOCOL.md"
        }
        if (-not (Test-Path $file) -and $file -eq "docs/pm/SLA_RETAINER_CONTRACT.md" -and (Test-Path "contracts/SLA_RETAINER.md")) {
            $file = "contracts/SLA_RETAINER.md"
        }
        if (-not (Test-Path $file) -and $file -eq "docs/pm/INCIDENT_RESPONSE.md" -and (Test-Path "docs/INCIDENT_RESPONSE.md")) {
            $file = "docs/INCIDENT_RESPONSE.md"
        }
        if (Test-Path $file) {
            Write-Host "  [OK] $file" -ForegroundColor Green
            $foundFiles += $file
        } else {
            Write-Host "  [WARN] $file (optional, not found)" -ForegroundColor Yellow
            $missingOptional += $file
        }
    }
}

# Summary
Write-Host ("`n" + ("=" * 60))
if ($missingRequired.Count -eq 0) {
    Write-Host "[OK] Gate $Module PASSED - All required files present" -ForegroundColor Green
    Write-Host "   Found: $($foundFiles.Count) files" -ForegroundColor Gray
    
    if ($missingOptional.Count -gt 0) {
        Write-Host "   Optional files missing: $($missingOptional.Count)" -ForegroundColor Yellow
    }
    
    exit 0
} else {
    Write-Host "[ERROR] Gate $Module FAILED" -ForegroundColor Red
    Write-Host "   Missing required files: $($missingRequired.Count)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Create missing files:" -ForegroundColor Yellow
    foreach ($file in $missingRequired) {
        $dir = Split-Path -Parent $file
        if ($dir) {
            Write-Host "  mkdir -p $dir" -ForegroundColor Gray
        }
        Write-Host "  # Copy template and fill: $file" -ForegroundColor Gray
    }
    
    exit 1
}
