# Gate Validation Script (PowerShell)
# Validates module completion before proceeding to next phase
# Usage: .\scripts\gates\validate-gate.ps1 -Module "M03"

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
            "docs/pm/IDEA_BRIEF.md",
            "docs/pm/PROJECT_STATE.md"
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
            "docs/specs/LOGO_DESIGN_BRIEF.md",
            "docs/design/inspiration/notes.md",
            "DESIGN.md",
            "docs/specs/DESIGN_SPEC.md"
        )
        Optional = @(
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
            "RUNBOOK_LOCAL.md",
            "VERIFY_LOCAL.md"
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
            "docs/DEPLOYMENT_PROTOCOL.md",
            "docs/pm/GO_LIVE_REPORT.md"
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

# Detect Solo SaaS / Internal scale from PROJECT_STATE.md or M00_LITE.md
$isSoloSaaS = $false
$isLargeScale = $false
$isEnterprise = $false
if (Test-Path "docs/pm/PROJECT_STATE.md") {
    $stateContent = Get-Content "docs/pm/PROJECT_STATE.md" -Raw
    if ($stateContent -match '(?i)Scale:\s*(large|enterprise)') {
        $isLargeScale = $true
    }
    if ($stateContent -match '(?i)Scale:\s*enterprise') {
        $isEnterprise = $true
    }
}

if (Test-Path "docs/pm/M00_LITE.md") {
    $isSoloSaaS = $true
} elseif (Test-Path "docs/pm/PROJECT_STATE.md") {
    $stateContent = Get-Content "docs/pm/PROJECT_STATE.md" -Raw
    if ($stateContent -match '(?i)Scale:\s*(solo-saas|small|internal)') {
        $isSoloSaaS = $true
    }
}

if ($isSoloSaaS) {
    if ($Module -eq "M03") {
        Write-Host "  [INFO] Solo SaaS / Internal project detected: M03 SOW Contract is WAIVED." -ForegroundColor Cyan
        $gate.Required = @()
    }
    if ($Module -eq "M09") {
        Write-Host "  [INFO] Solo SaaS / Internal project detected: M09 Client UAT is WAIVED (Self-testing)." -ForegroundColor Cyan
        $gate.Required = @()
    }
    if ($Module -eq "M11") {
        Write-Host "  [INFO] Solo SaaS / Internal project detected: M11 Client BAST Handover is WAIVED." -ForegroundColor Cyan
        $gate.Required = @()
    }
}

if ($Module -eq "M06" -and $isSmallScale) {
    Write-Host "  [INFO] Small scale: SECURITY_CHECKLIST_SMALL.md absorbed into M06 (M07 folded)." -ForegroundColor Cyan
    $gate.Required += "docs/qa/SECURITY_CHECKLIST_SMALL.md"
}
if ($isLargeScale -and $Module -eq "M07") {
    Write-Host "  [INFO] Large / Enterprise scale detected: Security Audit is MANDATORY." -ForegroundColor Cyan
    $gate.Required += "docs/qa/SECURITY_AUDIT.md"
}
if ($isEnterprise) {
    if ($Module -eq "M02") {
        Write-Host "  [INFO] Enterprise scale detected: RACI Matrix is MANDATORY." -ForegroundColor Cyan
        $gate.Required += "docs/governance/RACI_MATRIX.md"
    } elseif ($Module -eq "M05") {
        Write-Host "  [INFO] Enterprise scale detected: ADR and Audit Trail Specs are MANDATORY." -ForegroundColor Cyan
        $gate.Required += "docs/governance/ADR.md"
        $gate.Required += "docs/governance/AUDIT_TRAIL_REQUIREMENTS.md"
    } elseif ($Module -eq "M10") {
        Write-Host "  [INFO] Enterprise scale detected: CAB Approval is MANDATORY." -ForegroundColor Cyan
        $gate.Required += "docs/governance/CAB_APPROVAL.md"
    }
}

# Check required files
Write-Host "`nRequired files:" -ForegroundColor White
if ($Module -eq "M00" -and (Test-Path "docs/pm/M00_LITE.md")) {
    Write-Host "  [INFO] Detected M00-lite rapid validation path" -ForegroundColor Cyan
    $gate.Required = @("docs/pm/M00_LITE.md")
}
$isSmallScale = $false
if (Test-Path "docs/pm/PROJECT_STATE.md") {
    $stateContent = Get-Content "docs/pm/PROJECT_STATE.md" -Raw
    if ($stateContent -match '(?i)Scale:\s*small') { $isSmallScale = $true }
} elseif (Test-Path "PROJECT_LITE.md") {
    $isSmallScale = $true
}
if ($Module -eq "M05" -and $isSmallScale) {
    Write-Host "  [INFO] Detected Small-Scale Fast-Track MVP path (PROJECT_LITE.md)" -ForegroundColor Cyan
    $gate.Required = @("PROJECT_LITE.md")
    if (Test-Path "PROJECT_LITE.md") {
        $plContent = Get-Content "PROJECT_LITE.md" -Raw
        if ($plContent -match "(?i)TBD|maybe|tentative|if time permits") {
            Write-Host "  [ERROR] Ambiguous terms (TBD/maybe/tentative) detected in PROJECT_LITE.md Must-Have features!" -ForegroundColor Red
            $missingRequired += "Ambiguous terms in PROJECT_LITE.md"
        } else {
            Write-Host "  [OK] Zero ambiguous terms in PROJECT_LITE.md Must-Have features" -ForegroundColor Green
        }
    }
}
foreach ($file in $gate.Required) {
    $actualFile = $file
    $pathExists = Test-Path $file
    if (-not $pathExists -and $file -eq "docs/pm/COMPETITIVE_LANDSCAPE.md" -and (Test-Path "docs/pm/COMPETITOR_ANALYSIS.md")) {
        $pathExists = $true
        $actualFile = "docs/pm/COMPETITOR_ANALYSIS.md"
    }
    if (-not $pathExists -and $file -eq "DESIGN.md" -and (Test-Path "docs/harness-root/DESIGN.md")) {
        $pathExists = $true
        $actualFile = "docs/harness-root/DESIGN.md"
    }
    if (-not $pathExists -and $file -eq "contracts/SOW_CONTRACT.md" -and (Test-Path "docs/pm/SOW_CONTRACT.md")) {
        $pathExists = $true
        $actualFile = "docs/pm/SOW_CONTRACT.md"
    }
    if (-not $pathExists -and $file -eq "contracts/BAST.md" -and (Test-Path "docs/pm/BAST.md")) {
        $pathExists = $true
        $actualFile = "docs/pm/BAST.md"
    }
    if (-not $pathExists -and $file -eq "docs/DEPLOYMENT_PROTOCOL.md" -and (Test-Path "docs/pm/DEPLOYMENT_PROTOCOL.md")) {
        $pathExists = $true
        $actualFile = "docs/pm/DEPLOYMENT_PROTOCOL.md"
    }
    if (-not $pathExists -and $file -eq "docs/governance/RACI_MATRIX.md" -and (Test-Path "docs/pm/RACI_MATRIX.md")) {
        $pathExists = $true
        $actualFile = "docs/pm/RACI_MATRIX.md"
    }
    if (-not $pathExists -and $file -eq "docs/governance/ADR.md" -and (Test-Path "docs/specs/ADR.md")) {
        $pathExists = $true
        $actualFile = "docs/specs/ADR.md"
    }
    if (-not $pathExists -and $file -eq "docs/governance/CAB_APPROVAL.md" -and (Test-Path "docs/pm/CAB_APPROVAL.md")) {
        $pathExists = $true
        $actualFile = "docs/pm/CAB_APPROVAL.md"
    }
    if (-not $pathExists -and $file -eq "docs/governance/AUDIT_TRAIL_REQUIREMENTS.md" -and (Test-Path "docs/specs/AUDIT_TRAIL_REQUIREMENTS.md")) {
        $pathExists = $true
        $actualFile = "docs/specs/AUDIT_TRAIL_REQUIREMENTS.md"
    }
    if (-not $pathExists -and $file -eq "docs/pm/METRICS_BASELINE_REPORT.md" -and (Test-Path "docs/analytics/METRICS_BASELINE_REPORT.md")) {
        $pathExists = $true
        $actualFile = "docs/analytics/METRICS_BASELINE_REPORT.md"
    }
    if (-not $pathExists -and $file -eq "docs/pm/IDEA_BRIEF.md" -and (Test-Path "docs/pm/FEASIBILITY_REPORT.md")) {
        $pathExists = $true
        $actualFile = "docs/pm/FEASIBILITY_REPORT.md"
    }
    if (-not $pathExists -and $file -eq "VERIFY_LOCAL.md" -and (Test-Path "docs/VERIFY_LOCAL.md")) {
        $pathExists = $true
        $actualFile = "docs/VERIFY_LOCAL.md"
    }
    if (-not $pathExists -and $file -eq "VERIFY_LOCAL.md" -and (Test-Path "docs/specs/VERIFY_LOCAL.md")) {
        $pathExists = $true
        $actualFile = "docs/specs/VERIFY_LOCAL.md"
    }
    if (-not $pathExists -and $file -eq "RUNBOOK_LOCAL.md" -and (Test-Path "docs/RUNBOOK_LOCAL.md")) {
        $pathExists = $true
        $actualFile = "docs/RUNBOOK_LOCAL.md"
    }
    if (-not $pathExists -and $file -eq "RUNBOOK_LOCAL.md" -and (Test-Path "docs/specs/RUNBOOK_LOCAL.md")) {
        $pathExists = $true
        $actualFile = "docs/specs/RUNBOOK_LOCAL.md"
    }
    if (-not $pathExists -and $file -eq "docs/pm/GO_LIVE_REPORT.md" -and (Test-Path "docs/GO_LIVE_REPORT.md")) {
        $pathExists = $true
        $actualFile = "docs/GO_LIVE_REPORT.md"
    }
    if (-not $pathExists -and $file -eq "docs/pm/WARRANTY_POLICY.md" -and (Test-Path "docs/pm/RUNBOOK_OPS.md")) {
        $pathExists = $true
        $actualFile = "docs/pm/RUNBOOK_OPS.md"
    }
    if (-not $pathExists -and $file -eq "docs/qa/SECURITY_CHECKLIST_SMALL.md" -and (Test-Path "SECURITY_CHECKLIST_SMALL.md")) {
        $pathExists = $true
        $actualFile = "SECURITY_CHECKLIST_SMALL.md"
    }
    if ($pathExists) {
        $minBytes = 200
        if ($file -match 'PRD\.md|FSD\.md|SITEMAP\.md|SCOPE_STATEMENT\.md|DESIGN_SPEC\.md') {
            $minBytes = 2000
        } elseif ($file -match 'IDEA_BRIEF\.md|COMPONENT_REQUIREMENTS\.md|DESIGN\.md|DEPLOYMENT_PROTOCOL\.md') {
            $minBytes = 1000
        } elseif ($file -match 'AGENTS\.md|CONTEXT\.md|TODO\.md|RUNBOOK_LOCAL\.md|VERIFY_LOCAL\.md|GO_LIVE_REPORT\.md') {
            $minBytes = 500
        }
        $fileLength = (Get-Item $actualFile).Length
        if ($fileLength -lt $minBytes) {
            Write-Host "  [ERROR] $file (TOO SMALL: ${fileLength}B < ${minBytes}B minimum)" -ForegroundColor Red
            $missingRequired += $file
        } else {
            Write-Host "  [OK] $file (${fileLength}B >= ${minBytes}B)" -ForegroundColor Green
            $foundFiles += $file
        }
    } else {
        Write-Host "  [ERROR] $file (MISSING)" -ForegroundColor Red
        $missingRequired += $file
    }
}
if ($Module -eq "M00") {
    $userResearchFile = if (Test-Path "docs/pm/M00_LITE.md") { "docs/pm/M00_LITE.md" } elseif (Test-Path "docs/pm/USER_RESEARCH_REPORT.md") { "docs/pm/USER_RESEARCH_REPORT.md" } else { $null }
    if ($userResearchFile) {
        $content = Get-Content $userResearchFile -Raw
        # 1. Blocking decision check
        if ($content -match '(?i)Gate-Decision:\s*PENDING|\[x\]\s*⏳\s*PENDING|PENDING_PRIMARY_RESEARCH') {
            Write-Host "  [ERROR] Gate status: PENDING_PRIMARY_RESEARCH (Real human research pending; M00 cannot be closed)" -ForegroundColor Red
            $missingRequired += "Gate-Decision: PASS (currently PENDING)"
        } elseif ($content -match '(?i)Gate-Decision:\s*FAIL|^Gate-Decision:\s*PIVOT|\[x\]\s*❌\s*(PIVOT|STOP)') {
            Write-Host "  [ERROR] Gate status: FAIL / PIVOT (Market validation kill criteria triggered)" -ForegroundColor Red
            $missingRequired += "Gate-Decision: PASS (currently FAIL/PIVOT)"
        } elseif ($content -match '(?i)Gate-Decision:\s*PASS|\[x\]\s*✅\s*PASS') {
            Write-Host "  [OK] Gate decision verified: PASS" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] Explicit Gate-Decision (PASS|PENDING|FAIL) not declared!" -ForegroundColor Red
            $missingRequired += "Gate-Decision: PASS"
        }
        # 2. Check unresolved placeholders
        if ($content -match '\[\.\.\.\]|\[X\]/mo|\[Your Name\]') {
            Write-Host "  [ERROR] Unresolved template placeholders [...] detected in $userResearchFile!" -ForegroundColor Red
            $missingRequired += "Unresolved template placeholders [...]"
        }
        # 3. Check real interviews if M00_LITE
        if ($userResearchFile -like "*M00_LITE*") {
            $realMatches = [regex]::Matches($content, "✅ Real").Count
            if ($realMatches -ge 3) {
                Write-Host "  [OK] Real interviews verified: $realMatches (>= 3 minimum confirmed)" -ForegroundColor Green
            } else {
                Write-Host "  [ERROR] Insufficient real interviews: $realMatches (< 3 confirmed with '✅ Real')" -ForegroundColor Red
                $missingRequired += "Minimum 3 real interviews (✅ Real)"
            }
        }
    }
    if (Test-Path "docs/pm/COMPETITIVE_LANDSCAPE.md") {
        $compContent = Get-Content "docs/pm/COMPETITIVE_LANDSCAPE.md" -Raw
        if ($compContent -match '(?i)Test Date|Tanggal Uji|Onboarding Time|Waktu Onboarding') {
            Write-Host "  [OK] Hands-on competitor testing evidence verified" -ForegroundColor Green
        }
    }
} elseif ($Module -eq "M01") {
    if (Test-Path "docs/pm/PROJECT_STATE.md") {
        $stateRaw = Get-Content "docs/pm/PROJECT_STATE.md" -Raw
        $fields = @("Delivery:", "Intake-Success-Metric:", "Intake-P0-Features:", "Intake-Time-Capacity:", "Intake-Sensitive-Data:")
        foreach ($f in $fields) {
            if ($stateRaw -match "(?im)^\s*-?\s*$([regex]::Escape($f))\s*(UNKNOWN|\[|$)") {
                Write-Host "  [ERROR] Intake field incomplete or UNKNOWN: $f" -ForegroundColor Red
                $missingRequired += $f
            }
        }
        if ($stateRaw -match "(?im)^\s*-?\s*Intake-Status:\s*ANSWERED") {
            Write-Host "  [OK] Intake Gate: all 5 mandatory fields answered" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] Intake Gate: Intake-Status not set to ANSWERED" -ForegroundColor Red
            $missingRequired += "Intake-Status: ANSWERED"
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
            if ($sowContent -match '\[x\]\s*(DP|Down Payment|30%|40%|50%|Cleared|Received)') {
                Write-Host "  [OK] Down payment (DP) confirmation verified ([x] cleared)" -ForegroundColor Green
            } else {
                Write-Host "  [WARNING] Down payment (DP) not marked [x] as received/cleared in SOW!" -ForegroundColor Yellow
            }
            if ($sowContent -match '(?i)Deemed Acceptance|Klien Diam') {
                Write-Host "  [OK] Deemed acceptance clause verified (Anti-ghosting protection)" -ForegroundColor Green
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
} elseif ($Module -eq "M04") {
    $minLogo = if ($isSmallScale) { 50 } else { 200 }
    $logoFile = $null
    foreach ($l in @("assets/logo/logo.svg", "assets/logo/logo.png", "assets/logo/logo.webp")) {
        if (Test-Path $l) { $logoFile = $l; break }
    }
    if ($logoFile) {
        $lsize = (Get-Item $logoFile).Length
        if ($lsize -ge $minLogo) {
            Write-Host "  [OK] $logoFile (${lsize}B >= ${minLogo}B minimum)" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] $logoFile (TOO SMALL: ${lsize}B < ${minLogo}B minimum)" -ForegroundColor Red
            $missingRequired += "assets/logo/ (logo file too small)"
        }
    } else {
        Write-Host "  [ERROR] assets/logo/ (MISSING: logo.svg / logo.png required before DESIGN.md can be generated)" -ForegroundColor Red
        $missingRequired += "assets/logo/logo.svg (or logo.png)"
    }
    if (Test-Path "docs/design/inspiration/notes.md") {
        $notesContent = Get-Content "docs/design/inspiration/notes.md" -Raw
        if ($notesContent -match '(?i)Selected.*Benchmark|Winning Reference|Primary Benchmark|Paling OK') {
            Write-Host "  [OK] docs/design/inspiration/notes.md (Benchmark selection verified)" -ForegroundColor Green
        }
    }
} elseif ($Module -eq "M08") {
    $reconFile = if (Test-Path "docs/pm/MIGRATION_RECONCILIATION_REPORT.md") { "docs/pm/MIGRATION_RECONCILIATION_REPORT.md" } else { $null }
    if ($reconFile) {
        $reconContent = Get-Content $reconFile -Raw
        if ($reconContent -match '(?i)PASSED|RECONCILED|100%|SUCCESS|Zero Discrepancy') {
            Write-Host "  [OK] Data migration reconciliation verified (Audit PASSED)" -ForegroundColor Green
        } else {
            Write-Host "  [WARNING] Migration reconciliation not marked as PASSED/RECONCILED!" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  [INFO] Data migration plan verified. Run reconciliation after seeding." -ForegroundColor Cyan
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
