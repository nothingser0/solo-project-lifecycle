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
    "M03" = @{
        Name = "Legal SOW & Charter"
        Required = @(
            "contracts/SOW_CONTRACT.md",
            "docs/pm/SCOPE_STATEMENT.md"
        )
        Optional = @(
            "contracts/NDA.md"
        )
    }
    "M04" = @{
        Name = "UI/UX Prototyping"
        Required = @(
            "DESIGN.md",
            "docs/specs/DESIGN_SPEC.md"
        )
        Optional = @()
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
    "M10" = @{
        Name = "Deployment Production"
        Required = @(
            "docs/DEPLOYMENT_PROTOCOL.md"
        )
        Optional = @(
            "docs/ROLLBACK_PLAN.md"
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
foreach ($file in $gate.Required) {
    $pathExists = Test-Path $file
    if (-not $pathExists -and $file -eq "DESIGN.md" -and (Test-Path "docs/harness-root/DESIGN.md")) {
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

# Check optional files
if ($gate.Optional.Count -gt 0) {
    Write-Host "`nOptional files:" -ForegroundColor White
    foreach ($file in $gate.Optional) {
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
