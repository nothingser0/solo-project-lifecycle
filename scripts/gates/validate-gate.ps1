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
    # Enterprise Advisory Series (A00 - A04)
    "A00" = @{
        Name = "Advisory Commercial Clearance"
        Required = @(
            "contracts/CONSULTING_AGREEMENT.md"
        )
        Optional = @(
            "docs/pm/RFP_RESPONSE.md"
        )
    }
    "A01" = @{
        Name = "WBS Phasing & Domain Decomposition"
        Required = @(
            "docs/pm/WBS_PHASING_PLAN.md"
        )
        Optional = @()
    }
    "A02" = @{
        Name = "C4 Enterprise Architecture & STRIDE"
        Required = @(
            "docs/architecture/ENTERPRISE_ARCHITECTURE_BLUEPRINT.md",
            "docs/security/THREAT_MODEL_STRIDE.md"
        )
        Optional = @()
    }
    "A03" = @{
        Name = "Vendor Procurement & Build-vs-Buy"
        Required = @(
            "docs/procurement/VENDOR_PROCUREMENT_SCHEDULE.md",
            "docs/governance/VENDOR_COMPARISON_MATRIX.md"
        )
        Optional = @()
    }
    "A04" = @{
        Name = "Governance Handover & Retainer"
        Required = @(
            "docs/governance/GOVERNANCE_HANDOVER_PACK.md"
        )
        Optional = @()
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
$isSmallScale = $false
$isLargeScale = $false
$isEnterprise = $false
if (Test-Path "docs/pm/PROJECT_STATE.md") {
    $stateContent = Get-Content "docs/pm/PROJECT_STATE.md" -Raw
    if ($stateContent -match '(?i)Scale:\s*small') {
        $isSmallScale = $true
    }
    if ($stateContent -match '(?i)Scale:\s*(large|enterprise)') {
        $isLargeScale = $true
    }
    if ($stateContent -match '(?i)Scale:\s*enterprise') {
        $isEnterprise = $true
    }
} elseif (Test-Path "PROJECT_LITE.md") {
    $isSmallScale = $true
}

if (Test-Path "docs/pm/M00_LITE.md") {
    $isSoloSaaS = $true
} elseif (Test-Path "docs/pm/PROJECT_STATE.md") {
    $stateContent = Get-Content "docs/pm/PROJECT_STATE.md" -Raw
    if ($stateContent -match '(?i)Delivery:\s*(solo|portfolio|internal)') {
        $isSoloSaaS = $true
    } elseif ($stateContent -match '(?i)Delivery:\s*client') {
        $isSoloSaaS = $false
    } elseif ($stateContent -match '(?i)Scale:\s*(solo-saas|internal)') {
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
if ($Module -eq "M07" -and $isSmallScale) {
    Write-Host "  [INFO] Small Scale detected: M07 QA & SIT is WAIVED (Security absorbed in M06, UAT in M09-LITE)." -ForegroundColor Cyan
    $gate.Required = @()
}
if ($Module -eq "M08" -and $isSmallScale) {
    Write-Host "  [INFO] Small Scale detected: M08 Data Migration is WAIVED (Legacy data triggers re-classification to Large)." -ForegroundColor Cyan
    $gate.Required = @()
}
if ($isLargeScale -and $Module -eq "M07" -and -not $isSmallScale) {
    Write-Host "  [INFO] Large / Enterprise scale detected: Security Audit is MANDATORY." -ForegroundColor Cyan
    $gate.Required += "docs/qa/SECURITY_AUDIT.md"
}
if ($isLargeScale -and $Module -eq "M08") {
    Write-Host "  [INFO] Large/Enterprise scale detected: Reconciliation Report is MANDATORY." -ForegroundColor Cyan
    $gate.Required += "docs/pm/MIGRATION_RECONCILIATION_REPORT.md"
}
if ($isLargeScale -and $Module -eq "M10") {
    Write-Host "  [INFO] Large / Enterprise scale detected: Emergency Rollback Plan is MANDATORY." -ForegroundColor Cyan
    $gate.Required += "docs/ROLLBACK_PLAN.md"
}
if ($isLargeScale -and $Module -eq "M11") {
    Write-Host "  [INFO] Large / Enterprise scale detected: Technical Handover Protocol is MANDATORY." -ForegroundColor Cyan
    $gate.Required += "docs/pm/HANDOVER_PROTOCOL.md"
}
if ($isLargeScale -and $Module -eq "M12") {
    Write-Host "  [INFO] Large / Enterprise scale detected: Incident Response Plan is MANDATORY." -ForegroundColor Cyan
    $gate.Required += "docs/pm/INCIDENT_RESPONSE.md"
}
if ($Module -eq "M13") {
    # M13 applies only to Self-Initiated Products; Client/Internal/Portfolio & Small terminate at M11/M12
    $isM13Waived = $false
    if (Test-Path "docs/pm/PROJECT_STATE.md") {
        $stRaw = Get-Content "docs/pm/PROJECT_STATE.md" -Raw
        if ($stRaw -match '(?i)Delivery:\s*(client|portfolio|internal)') { $isM13Waived = $true }
    }
    if ($isSmallScale) { $isM13Waived = $true }
    if ($isM13Waived) {
        Write-Host "  [INFO] Client / Internal / Small delivery: M13 Product Iteration is WAIVED (lifecycle ends at M11/M12)." -ForegroundColor Cyan
        $gate.Required = @()
    }
}
if ($isLargeScale -and $Module -eq "M13") {
    Write-Host "  [INFO] Large / Enterprise scale detected: Growth Experiments Backlog is MANDATORY." -ForegroundColor Cyan
    $gate.Required += "docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md"
}
if ($isEnterprise) {
    if ($Module -eq "M03") {
        Write-Host "  [INFO] Enterprise scale detected: Risk Assessment Matrix and RACI Matrix are MANDATORY in M03." -ForegroundColor Cyan
        $gate.Required += "docs/governance/RISK_ASSESSMENT_MATRIX.md"
        $gate.Required += "docs/governance/RACI_MATRIX.md"
    }
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
$isM00Waived = $false
if (Test-Path "docs/pm/PROJECT_STATE.md") {
    $stRaw = Get-Content "docs/pm/PROJECT_STATE.md" -Raw
    if ($stRaw -match "(?i)Scale:\s*small" -or $stRaw -match "(?i)Delivery:\s*(client|internal|portfolio)") {
        $isM00Waived = $true
    }
} elseif (Test-Path "PROJECT_LITE.md") {
    $isM00Waived = $true
}

if ($Module -eq "M00" -and $isM00Waived) {
    Write-Host "  [INFO] Small Scale or Client/Internal delivery: M00 Product Discovery is WAIVED." -ForegroundColor Cyan
    $gate.Required = @()
} elseif ($Module -eq "M00" -and (Test-Path "docs/pm/M00_LITE.md")) {
    Write-Host "  [INFO] Detected M00-lite rapid validation path (Solo SaaS)" -ForegroundColor Cyan
    $gate.Required = @("docs/pm/M00_LITE.md")
}
if ($Module -eq "M01" -and $isSmallScale) {
    Write-Host "  [INFO] Small Scale detected: M01 Idea Feasibility is WAIVED (Handled by Intake Gate & PROJECT_LITE)." -ForegroundColor Cyan
    $gate.Required = @()
}
if ($Module -eq "M02" -and $isSmallScale) {
    Write-Host "  [INFO] Small Scale detected: M02 Discovery & Scope is WAIVED (Handled by Intake Gate & PROJECT_LITE)." -ForegroundColor Cyan
    $gate.Required = @()
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
        if ($plContent -match '(?i)CREATE TABLE|model|table|database|schema' -and $plContent -match '(?i)/api|GET|POST|endpoints|routes') {
            Write-Host "  [OK] Section 5 Architecture in PROJECT_LITE.md contains database schema and API contracts" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] Section 5 Architecture in PROJECT_LITE.md missing database schema or API endpoint definitions!" -ForegroundColor Red
            $missingRequired += "PROJECT_LITE.md (Section 5 database schema and API contracts)"
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
    if (-not $pathExists -and $file -eq "contracts/SOW_CONTRACT.md" -and (Test-Path "contracts/SOW_SMB.md")) {
        $pathExists = $true
        $actualFile = "contracts/SOW_SMB.md"
    }
    if (-not $pathExists -and $file -eq "contracts/SOW_CONTRACT.md" -and (Test-Path "docs/pm/SOW_SMB.md")) {
        $pathExists = $true
        $actualFile = "docs/pm/SOW_SMB.md"
    }
    if (-not $pathExists -and $file -eq "contracts/BAST.md" -and (Test-Path "docs/pm/BAST.md")) {
        $pathExists = $true
        $actualFile = "docs/pm/BAST.md"
    }
    if (-not $pathExists -and $file -eq "docs/pm/BAST.md" -and (Test-Path "contracts/BAST.md")) {
        $pathExists = $true
        $actualFile = "contracts/BAST.md"
    }
    if (-not $pathExists -and ($file -eq "docs/pm/BAST.md" -or $file -eq "contracts/BAST.md") -and (Test-Path "docs/pm/BAST_EMAIL_SMALL.md")) {
        $pathExists = $true
        $actualFile = "docs/pm/BAST_EMAIL_SMALL.md"
    }
    if (-not $pathExists -and ($file -eq "docs/pm/BAST.md" -or $file -eq "contracts/BAST.md") -and (Test-Path "contracts/BAST_EMAIL_SMALL.md")) {
        $pathExists = $true
        $actualFile = "contracts/BAST_EMAIL_SMALL.md"
    }
    if (-not $pathExists -and $file -eq "docs/governance/RACI_MATRIX.md" -and (Test-Path "docs/pm/RACI_MATRIX.md")) {
        $pathExists = $true
        $actualFile = "docs/pm/RACI_MATRIX.md"
    }
    if (-not $pathExists -and $file -eq "docs/DEPLOYMENT_PROTOCOL.md" -and (Test-Path "docs/pm/DEPLOYMENT_PROTOCOL.md")) {
        $pathExists = $true
        $actualFile = "docs/pm/DEPLOYMENT_PROTOCOL.md"
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
    if (-not $pathExists -and $file -eq "docs/pm/UAT_SIGNOFF_REPORT.md" -and (Test-Path "docs/qa/UAT_SIGNOFF.md")) {
        $pathExists = $true
        $actualFile = "docs/qa/UAT_SIGNOFF.md"
    }
    if (-not $pathExists -and $file -eq "docs/pm/UAT_SIGNOFF_REPORT.md" -and (Test-Path "docs/qa/UAT_SIGNOFF_SMALL.md")) {
        $pathExists = $true
        $actualFile = "docs/qa/UAT_SIGNOFF_SMALL.md"
    }
    if (-not $pathExists -and $file -eq "docs/pm/UAT_SIGNOFF_REPORT.md" -and (Test-Path "docs/pm/UAT_SIGNOFF_SMALL.md")) {
        $pathExists = $true
        $actualFile = "docs/pm/UAT_SIGNOFF_SMALL.md"
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
    if (-not $pathExists -and $file -eq "docs/ROLLBACK_PLAN.md" -and (Test-Path "docs/pm/ROLLBACK_PLAN.md")) {
        $pathExists = $true
        $actualFile = "docs/pm/ROLLBACK_PLAN.md"
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
            $minBytes = if ($isSmallScale -and ($file -match 'SITEMAP\.md|DESIGN_SPEC\.md')) { 1000 } else { 2000 }
        } elseif ($file -match 'IDEA_BRIEF\.md|COMPONENT_REQUIREMENTS\.md|DESIGN\.md|DEPLOYMENT_PROTOCOL\.md|PROJECT_LITE\.md') {
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
        if ($content -match '\[\.\.\.\]|\[X\]/mo|\[Your Name\]|\[Business Type\]|\[Current tool\]|\[Competitor A\]|\[Direct Comp|\[Adjacent Comp|\[Segment 1:|Rp \[X\]') {
            Write-Host "  [ERROR] Unresolved template placeholders [...] detected in $userResearchFile!" -ForegroundColor Red
            $missingRequired += "Unresolved template placeholders [...]"
        }
        # 3. Check real interviews if M00_LITE
        if ($userResearchFile -like "*M00_LITE*") {
            $realMatches = [regex]::Matches($content, '(?i)\|\s*\*\*INT-0[1-5]\*\*\s*\|.*✅\s*Real').Count
            if ($realMatches -ge 3) {
                Write-Host "  [OK] Real user interviews verified in INT-0x rows: $realMatches (>= 3 minimum confirmed)" -ForegroundColor Green
            } else {
                Write-Host "  [ERROR] Insufficient real interviews: $realMatches confirmed in INT-0x rows (< 3 confirmed with '✅ Real')" -ForegroundColor Red
                $missingRequired += "Minimum 3 real interviews in INT-0x rows (✅ Real)"
            }
            # 4. Check Waitlist Conversion rate is numeric and >= 5.0%
            if ($content -match '(?i)Waitlist-Conversion-Pct:\s*([0-9.]+)') {
                $wlPct = [double]$matches[1]
                if ($wlPct -lt 5.0) {
                    Write-Host "  [ERROR] Waitlist-Conversion-Pct ($wlPct%) is below minimum gate pass threshold (5.0%)!" -ForegroundColor Red
                    $missingRequired += "Waitlist-Conversion-Pct ($wlPct% < 5.0% threshold)"
                } else {
                    Write-Host "  [OK] Waitlist conversion rate verified: $wlPct% (>= 5.0% threshold)" -ForegroundColor Green
                }
            } else {
                Write-Host "  [ERROR] Waitlist-Conversion-Pct numeric percentage missing in M00_LITE.md!" -ForegroundColor Red
                $missingRequired += "Waitlist-Conversion-Pct numeric percentage"
            }
        }
    }
    if (Test-Path "docs/pm/COMPETITIVE_LANDSCAPE.md") {
        $compContent = Get-Content "docs/pm/COMPETITIVE_LANDSCAPE.md" -Raw
        if ($compContent -match '(?i)Test Date|Tanggal Uji|Onboarding Time|Waktu Onboarding') {
            Write-Host "  [OK] Hands-on competitor testing evidence verified" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] Hands-on competitor testing evidence (Test Date / Onboarding Time) missing in COMPETITIVE_LANDSCAPE.md!" -ForegroundColor Red
            $missingRequired += "Competitor hands-on testing evidence (Test Date / Onboarding Time)"
        }
    }
    if (Test-Path "docs/pm/MARKET_RESEARCH.md") {
        $mktContent = Get-Content "docs/pm/MARKET_RESEARCH.md" -Raw
        if ($mktContent -match "https?://" -and ($mktContent -match "(?i)Verified:|Tahun 20|202[0-9]-[0-9]{2}-[0-9]{2}")) {
            Write-Host "  [OK] Market research sources and verification dates verified" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] MARKET_RESEARCH.md must cite live source URLs (https://) and verification dates!" -ForegroundColor Red
            $missingRequired += "Market research sources (https://) and verification dates"
        }
    }
} elseif ($Module -eq "M01") {
    $isM01Waived = $false
    if (Test-Path "docs/pm/PROJECT_STATE.md") {
        $stRaw = Get-Content "docs/pm/PROJECT_STATE.md" -Raw
        if ($stRaw -match "(?i)Scale:\s*small") { $isM01Waived = $true }
    } elseif (Test-Path "PROJECT_LITE.md") {
        $isM01Waived = $true
    }

    if ($isM01Waived) {
        Write-Host "  [INFO] Small Scale detected: M01 Idea Feasibility is WAIVED (Handled by Intake Gate & PROJECT_LITE)." -ForegroundColor Cyan
        $gate.Required = @()
    } else {
        # Execute classify-scale.ps1
        if (Test-Path "scripts/gates/classify-scale.ps1") {
            Write-Host "  [INFO] Running mechanical scale & solo capacity classifier..." -ForegroundColor Cyan
            & .\scripts\gates\classify-scale.ps1
            if ($LASTEXITCODE -eq 2) {
                Write-Host "  [ERROR] SOLO CAPACITY GATE TRIGGERED: Project exceeds solo developer capacity!" -ForegroundColor Red
                $missingRequired += "Solo capacity exceeded (Must split or route to A-Series Advisory)"
            }
        }
    $briefFile = if (Test-Path "docs/pm/IDEA_BRIEF.md") { "docs/pm/IDEA_BRIEF.md" } elseif (Test-Path "docs/pm/FEASIBILITY_REPORT.md") { "docs/pm/FEASIBILITY_REPORT.md" } else { $null }
    if ($briefFile) {
        $briefContent = Get-Content $briefFile -Raw
        # 1. Reject placeholders [...]
        if ($briefContent -match '\[\.\.\.\]|\[Example:|\[Your Name\]') {
            Write-Host "  [ERROR] Unresolved template placeholders [...] detected in $briefFile!" -ForegroundColor Red
            $missingRequired += "Unresolved template placeholders [...]"
        }
        # 2. Blocking Feasibility Decision check
        if ($briefContent -match '(?i)Feasibility-Decision:\s*KILL|\[x\]\s*\*\*KILL\*\*') {
            Write-Host "  [ERROR] Gate status: KILL (Fatal single-point blocker; project terminated)" -ForegroundColor Red
            $missingRequired += "Feasibility-Decision: GO (currently KILL)"
        } elseif ($briefContent -match '(?i)Feasibility-Decision:\s*PIVOT|\[x\]\s*\*\*PIVOT\*\*') {
            Write-Host "  [ERROR] Gate status: PIVOT (Idea feasibility rejected; return to M00 or restructure scope)" -ForegroundColor Red
            $missingRequired += "Feasibility-Decision: GO (currently PIVOT)"
        } elseif ($briefContent -match '(?i)Feasibility-Decision:\s*(GO|CONDITIONAL_GO)|\[x\]\s*\*\*(GO|CONDITIONAL GO)\*\*') {
            Write-Host "  [OK] Feasibility decision verified: GO / CONDITIONAL_GO" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] Explicit Feasibility-Decision (GO | CONDITIONAL_GO | PIVOT | KILL) not declared!" -ForegroundColor Red
            $missingRequired += "Feasibility-Decision: GO"
        }
        # 3. Dimension Floor & Score Integrity (all 4 dimensions REQUIRED, numeric, range 1.0-5.0, each >= 3.0)
        $dimOk = $true
        $dimSum = 0.0
        foreach ($dim in @("Technical", "Operational", "Regulatory", "Financial")) {
            if ($briefContent -match "(?im)^Feasibility-Score-$dim`:\s*\[") {
                Write-Host "  [ERROR] Feasibility-Score-$dim still holds an unedited placeholder!" -ForegroundColor Red
                $dimOk = $false
                $missingRequired += "Feasibility-Score-$dim (unedited placeholder)"
                continue
            }
            if ($briefContent -match "(?im)^Feasibility-Score-$dim`:\s*([0-9]+(?:\.[0-9]+)?)") {
                $dimVal = [double]$matches[1]
                if ($dimVal -lt 1.0 -or $dimVal -gt 5.0) {
                    Write-Host "  [ERROR] Feasibility-Score-$dim out of range: $dimVal (must be 1.0-5.0)" -ForegroundColor Red
                    $dimOk = $false
                    $missingRequired += "Feasibility-Score-$dim (out of range)"
                    continue
                }
                if ($dimVal -lt 3.0) {
                    Write-Host "  [ERROR] Dimension Floor Failure: $dim = $dimVal (< 3.0)" -ForegroundColor Red
                    $dimOk = $false
                    $missingRequired += "Dimension Floor ($dim < 3.0)"
                    continue
                }
                $dimSum += $dimVal
            } else {
                Write-Host "  [ERROR] Missing numeric Feasibility-Score-$dim (all 4 dimensions required, 1.0-5.0)" -ForegroundColor Red
                $dimOk = $false
                $missingRequired += "Feasibility-Score-$dim (missing)"
            }
        }
        if ($dimOk) {
            $dimAvg = [math]::Round($dimSum / 4, 2)
            Write-Host "  [OK] Dimension Floor verified: all 4 dimensions >= 3.0 (average $dimAvg)" -ForegroundColor Green
            # 4. Decision/average consistency: average < 3.5 MUST be CONDITIONAL_GO, not GO
            if ($briefContent -match '(?im)^Feasibility-Decision:\s*(CONDITIONAL_GO|GO)') {
                $decision = $matches[1].ToUpper()
                if ($decision -eq "GO" -and $dimAvg -lt 3.5) {
                    Write-Host "  [ERROR] Decision mismatch: average $dimAvg < 3.5 requires 'CONDITIONAL_GO', not 'GO'" -ForegroundColor Red
                    $missingRequired += "Decision consistency (average $dimAvg < 3.5 requires CONDITIONAL_GO)"
                }
            }
        }
    }
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
    } # end of isM01Waived else
} elseif ($Module -eq "M02") {
    if ($isSmallScale) {
        Write-Host "  [INFO] Small Scale detected: M02 Discovery & Scope is WAIVED (Handled by Intake Gate & PROJECT_LITE)." -ForegroundColor Cyan
    } elseif (Test-Path "docs/pm/SCOPE_STATEMENT.md") {
        $scopeContent = Get-Content "docs/pm/SCOPE_STATEMENT.md" -Raw
        $scopeLines = Get-Content "docs/pm/SCOPE_STATEMENT.md"

        # 1. Reject placeholders
        if ($scopeContent -match '\[\.\.\.\]|\[Feature [0-9]|\[Application / System Name\]') {
            Write-Host "  [ERROR] Unresolved template placeholders [...] detected in SCOPE_STATEMENT.md!" -ForegroundColor Red
            $missingRequired += "Unresolved template placeholders [...]"
        }

        # 2. Ambiguity on Must-Have rows
        $mustLines = $scopeLines | Where-Object { $_ -match '\|.*(must|p0).*\|' }
        $hasAmbiguity = $mustLines | Where-Object { $_ -match 'TBD|maybe|if time permits|tentative|TBA' }
        if ($hasAmbiguity) {
            Write-Host "  [ERROR] Ambiguous terms detected in Must-Have rows!" -ForegroundColor Red
            $missingRequired += "Ambiguous terms in Must-Have rows"
        } else {
            Write-Host "  [OK] Zero ambiguous terms in Must-Have scope rows" -ForegroundColor Green
        }

        # 3. Scope-Lock-Decision verification (BLOCKER)
        if ($scopeContent -match '(?im)^Scope-Lock-Decision:\s*PENDING') {
            Write-Host "  [ERROR] Scope lock status: PENDING (Scope not frozen; M02 cannot be closed)" -ForegroundColor Red
            $missingRequired += "Scope-Lock-Decision: LOCKED (currently PENDING)"
        } elseif ($scopeContent -match '(?im)^Scope-Lock-Decision:\s*LOCKED') {
            Write-Host "  [OK] Scope lock decision verified: LOCKED" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] Explicit Scope-Lock-Decision (LOCKED | PENDING) not declared in SCOPE_STATEMENT.md!" -ForegroundColor Red
            $missingRequired += "Scope-Lock-Decision: LOCKED"
        }

        # 4. P0 count within scale limits (strictly count F-xx feature rows)
        $fRows = $scopeLines | Where-Object { $_ -match '\|\s*\*\*F-[0-9]+\*\*\s*\|.*(must|p0)' }
        $p0Count = $fRows.Count
        $declaredScale = ""
        if (Test-Path "docs/pm/PROJECT_STATE.md") {
            $stateRaw = Get-Content "docs/pm/PROJECT_STATE.md" -Raw
            if ($stateRaw -match "(?im)^\s*-?\s*Scale:\s*(\S+)") { $declaredScale = $Matches[1].ToLower() }
        }
        $lo = 3; $hi = 25
        switch -Regex ($declaredScale) {
            '^small$' { $lo = 3; $hi = 7 }
            '^(medium|solo-saas)$' { $lo = 8; $hi = 15 }
            '^large$' { $lo = 16; $hi = 25 }
        }
        Write-Host "  [INFO] Declared scale: $declaredScale; P0 feature rows (F-xx) counted: $p0Count (expected $lo-$hi)"
        if ($p0Count -lt $lo -or $p0Count -gt $hi) {
            Write-Host "  [ERROR] P0 Must-Have count ($p0Count) outside scale '$declaredScale' limits ($lo-$hi)." -ForegroundColor Red
            $missingRequired += "P0 count within scale limits"
        } else {
            Write-Host "  [OK] P0 Must-Have count within scale limits" -ForegroundColor Green
        }

        # 5. Confidence Legend (BLOCKER)
        if ($scopeContent -match '✅' -or $scopeContent -match '(?i)VERIFIED') {
            Write-Host "  [OK] Data Confidence Legend / status markers present" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] Data Confidence Legend [OK/ASSUMPTION/UNKNOWN] not declared!" -ForegroundColor Red
            $missingRequired += "Data Confidence Legend"
        }

        # 6. Out-of-Scope exclusions (strictly within Section 5.2)
        if ($scopeContent -match '(?i)out-of-scope') {
            $oosSection = ""
            if ($scopeContent -match '(?s)### 5\.2 Out-of-Scope.*?(### 5\.3|## 6|$)') {
                $oosSection = $Matches[0]
            }
            $oosCount = ([regex]::Matches($oosSection, '(?m)^\s*[0-9]+\.\s')).Count
            if ($oosCount -ge 3) {
                Write-Host "  [OK] Explicit Out-of-Scope boundaries defined in Section 5.2 ($oosCount exclusions)" -ForegroundColor Green
            } else {
                Write-Host "  [ERROR] Section 5.2 Out-of-Scope requires >= 3 explicit exclusions (found: $oosCount)" -ForegroundColor Red
                $missingRequired += "Out-of-Scope >= 3 exclusions in Section 5.2"
            }
        } else {
            Write-Host "  [ERROR] Out-of-Scope boundary section missing!" -ForegroundColor Red
            $missingRequired += "Out-of-Scope section"
        }

        # 7. RBAC Zero Self-Approval guardrail (Hard blocker on non-small projects)
        if ($scopeContent -match '(?i)zero self-approval|no self-approval') {
            Write-Host "  [OK] RBAC Zero Self-Approval guardrail present" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] RBAC Zero Self-Approval guardrail missing in SCOPE_STATEMENT.md!" -ForegroundColor Red
            $missingRequired += "RBAC Zero Self-Approval guardrail"
        }
    }
    if (Test-Path "docs/pm/PROJECT_STATE.md") {
        $stRaw = Get-Content "docs/pm/PROJECT_STATE.md" -Raw
        if ($stRaw -match "(?i)Delivery:\s*(client|internal)") {
            Write-Host "  [INFO] Company/client delivery: Stakeholder & Communication docs MANDATORY." -ForegroundColor Cyan
            foreach ($req in @("docs/pm/STAKEHOLDER_MAP.md", "docs/pm/COMMUNICATION_PLAN.md")) {
                if (Test-Path $req) {
                    Write-Host "  [OK] $req" -ForegroundColor Green
                } else {
                    Write-Host "  [ERROR] $req (MISSING)" -ForegroundColor Red
                    $missingRequired += $req
                }
            }
        }
    }
} elseif ($Module -eq "M03") {
    $sowFile = if (Test-Path "contracts/SOW_CONTRACT.md") { "contracts/SOW_CONTRACT.md" } `
               elseif (Test-Path "docs/pm/SOW_CONTRACT.md") { "docs/pm/SOW_CONTRACT.md" } `
               elseif (Test-Path "contracts/SOW_SMB.md") { "contracts/SOW_SMB.md" } `
               elseif (Test-Path "docs/pm/SOW_SMB.md") { "docs/pm/SOW_SMB.md" } `
               else { $null }
    if ($sowFile) {
        $sowContent = Get-Content $sowFile -Raw
        $isSoloDelivery = $false
        if (Test-Path "docs/pm/PROJECT_STATE.md") {
            $stRaw = Get-Content "docs/pm/PROJECT_STATE.md" -Raw
            if ($stRaw -match "(?i)Delivery:\s*(solo|portfolio|internal)") { $isSoloDelivery = $true }
            if ($stRaw -match "(?i)Delivery:\s*client") { $isSoloDelivery = $false }
        }
        if ($isSoloDelivery) {
            Write-Host "  [INFO] Solo / Portfolio / Internal delivery: Commercial SOW gate is WAIVED." -ForegroundColor Cyan
        } else {
            # NDA check for Medium+ client delivery
            if (-not $isSmallScale) {
                $ndaExists = (Test-Path "contracts/NDA.md") -or (Test-Path "docs/pm/NDA.md")
                if ($ndaExists) {
                    Write-Host "  [OK] NDA verified (contracts/NDA.md)" -ForegroundColor Green
                } else {
                    Write-Host "  [ERROR] Medium+ client delivery: NDA is MANDATORY before client data access!" -ForegroundColor Red
                    $missingRequired += "contracts/NDA.md"
                }
            }
            # 1. Reject placeholders
            if ($sowContent -match '\[\.\.\.\]|\[Numeric Amount\]|\[Account Number\]') {
                Write-Host "  [ERROR] Unresolved template placeholders [...] detected in SOW contract!" -ForegroundColor Red
                $missingRequired += "Unresolved template placeholders in SOW"
            }
            # 2. Payment terms
            if ($sowContent -match '(?i)Termin|Milestone.*Payment|Down Payment|DP|30/40/30|50/50') {
                Write-Host "  [OK] Payment terms & milestone schedule defined" -ForegroundColor Green
            } else {
                Write-Host "  [ERROR] Payment terms not clearly defined!" -ForegroundColor Red
                $missingRequired += "Payment terms not defined"
            }
            # 3. Down payment confirmation BLOCKER
            $dpLine = $sowContent -match '\[x\][^\n]*(DP|Down Payment|30%|40%|50%)'
            $dpCleared = $sowContent -match '\[x\][^\n]*(Cleared|Received|Masuk|Lunas|Transferred|Settled|Bank Confirmed|Transfer Confirmed)'
            if ($dpLine -and $dpCleared) {
                Write-Host "  [OK] Down payment (DP) confirmation verified ([x] cleared & received in bank account)" -ForegroundColor Green
            } else {
                Write-Host "  [ERROR] Down payment (DP) not confirmed! Requires '[x] DP ... Cleared/Received/Transferred' (discussion-only lines do NOT count)." -ForegroundColor Red
                $missingRequired += "Down payment (DP) confirmation [x] with clearing status"
            }
            # 4. Single PIC BLOCKER
            if ($sowContent -match '(?i)Single PIC') {
                Write-Host "  [OK] Single PIC clause present" -ForegroundColor Green
            } else {
                Write-Host "  [ERROR] Single PIC clause missing!" -ForegroundColor Red
                $missingRequired += "Single PIC clause missing"
            }
            # 5. Deemed Acceptance BLOCKER
            if ($sowContent -match '(?i)Deemed Acceptance|Klien Diam') {
                Write-Host "  [OK] Deemed acceptance clause verified (Anti-ghosting protection)" -ForegroundColor Green
            } else {
                Write-Host "  [ERROR] Deemed acceptance clause missing in SOW contract!" -ForegroundColor Red
                $missingRequired += "Deemed acceptance clause"
            }
            # 6. Limitation of Liability BLOCKER
            if ($sowContent -match '(?i)Limitation of Liability|Liability Cap') {
                Write-Host "  [OK] Limitation of liability clause present" -ForegroundColor Green
            } else {
                Write-Host "  [ERROR] Limitation of liability clause missing in SOW contract!" -ForegroundColor Red
                $missingRequired += "Limitation of liability clause"
            }
            # 7. Revision Limits BLOCKER (solo dev anti infinite-revision trap)
            if ($sowContent -match '(?i)Revision Limit|Maximum\s+[0-9]+\s+round|Maximum\s+[0-9]+\s+test cycle|[0-9]+\s+rounds\b|[0-9]+\s+cycles\b') {
                Write-Host "  [OK] Revision limits clause present (design/UAT rounds capped)" -ForegroundColor Green
            } else {
                Write-Host "  [ERROR] Revision limits clause missing! Cap design revisions & UAT cycles." -ForegroundColor Red
                $missingRequired += "Revision limits clause"
            }
            # 8. Third-Party Account Ownership BLOCKER
            if ($sowContent -match '(?i)Third-Party (Subscriptions|Accounts)|Client corporate name|registered under the Client|Client credit card|billed directly to the Client') {
                Write-Host "  [OK] Third-party account ownership clause present (client-owned infrastructure)" -ForegroundColor Green
            } else {
                Write-Host "  [ERROR] Third-party account ownership clause missing! Cloud/hosting/gateway accounts MUST be registered under the Client." -ForegroundColor Red
                $missingRequired += "Third-party account ownership clause"
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
        } else {
            Write-Host "  [ERROR] docs/design/inspiration/notes.md (Prerequisite missing: winning benchmark selection not documented!)" -ForegroundColor Red
            $missingRequired += "docs/design/inspiration/notes.md (winning benchmark selection missing)"
        }
    }

    # Accessibility & Contrast Verification in DESIGN.md (BLOCKER)
    $designFile = if (Test-Path "DESIGN.md") { "DESIGN.md" } elseif (Test-Path "docs/harness-root/DESIGN.md") { "docs/harness-root/DESIGN.md" } else { $null }
    if ($designFile) {
        $designContent = Get-Content $designFile -Raw
        if ($designContent -match '(?i)[0-9]+(\.[0-9]+)?\s*:\s*1|WCAG|Contrast Ratio') {
            Write-Host "  [OK] DESIGN.md accessibility & contrast ratios verified" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] DESIGN.md missing mathematically computed contrast ratios (e.g. >= 4.5:1, >= 7.0:1)!" -ForegroundColor Red
            $missingRequired += "DESIGN.md (accessibility & contrast ratios)"
        }
        if ($designContent -match '(?i)z-index|Z-Index Layering|--z-') {
            Write-Host "  [OK] DESIGN.md z-index layering scale verified" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] DESIGN.md missing z-index layering scale definition!" -ForegroundColor Red
            $missingRequired += "DESIGN.md (z-index layering scale)"
        }
    }

    # 5-State Matrix Verification in DESIGN_SPEC.md (BLOCKER)
    if (Test-Path "docs/specs/DESIGN_SPEC.md") {
        $specContent = Get-Content "docs/specs/DESIGN_SPEC.md" -Raw
        $stateCount = 0
        foreach ($st in @("Idle", "Loading", "Empty", "Error", "Success")) {
            if ($specContent -match "(?i)$st") { $stateCount++ }
        }
        if ($stateCount -ge 3) {
            Write-Host "  [OK] DESIGN_SPEC.md 5-state matrix markers verified ($stateCount/5 states detected)" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] DESIGN_SPEC.md missing 5-state matrix coverage (found only $stateCount/5 states)!" -ForegroundColor Red
            $missingRequired += "docs/specs/DESIGN_SPEC.md (5-state matrix coverage)"
        }

        # Typography & Spacing sections in DESIGN.md (BLOCKER)
        if ($designFile -and (Test-Path $designFile)) {
            $designContent2 = Get-Content $designFile -Raw
            if ($designContent2 -match '(?i)Typography' -and $designContent2 -match '(?i)Spacing') {
                Write-Host "  [OK] DESIGN.md Typography & Spacing sections verified" -ForegroundColor Green
            } else {
                Write-Host "  [ERROR] DESIGN.md missing required 'Typography' and/or 'Spacing' sections!" -ForegroundColor Red
                $missingRequired += "DESIGN.md (Typography/Spacing sections)"
            }
        }

        # Prototyping Workflow enforcement (B/C/D require physical screen/prompt output)
        if ($specContent -match '(?im)^Prototyping-Workflow:\s*([ABCD])') {
            $wf = $matches[1].ToUpper()
            if ($wf -in @("B", "C", "D")) {
                Write-Host "  [INFO] Prototyping-Workflow: $wf (visual/AI/design-tool) - per-screen output is MANDATORY." -ForegroundColor Cyan
                $promptFiles = @(Get-ChildItem -Path "docs/design/prompts" -Filter "PROMPT.md" -Recurse -ErrorAction SilentlyContinue).Count
                $screenFiles = @(Get-ChildItem -Path "docs/design/screens" -File -Recurse -ErrorAction SilentlyContinue).Count
                if ($promptFiles -ge 1 -and $screenFiles -ge 1) {
                    Write-Host "  [OK] Per-screen outputs present (prompts: $promptFiles, screens: $screenFiles)" -ForegroundColor Green
                } else {
                    Write-Host "  [ERROR] Workflow $wf selected but per-screen outputs missing! Create docs/design/prompts/scr-xx/PROMPT.md and docs/design/screens/scr-xx/ for every screen." -ForegroundColor Red
                    $missingRequired += "Per-screen outputs for workflow $wf"
                }
            }
        }

        # Screen count match: SITEMAP routes vs DESIGN_SPEC screen rows (+/-10%)
        if (Test-Path "docs/specs/SITEMAP.md") {
            $sitemapContent = Get-Content "docs/specs/SITEMAP.md" -Raw
            $sitemapScreens = ([regex]::Matches($sitemapContent, "SCR-[0-9]+") | ForEach-Object { $_.Value } | Sort-Object -Unique).Count
            $specScreens = ([regex]::Matches($specContent, "SCR-[0-9]+") | ForEach-Object { $_.Value } | Sort-Object -Unique).Count
            if ($sitemapScreens -ge 1) {
                $diff = [math]::Abs($sitemapScreens - $specScreens)
                $tolerance = [math]::Floor($sitemapScreens / 10)
                if ($diff -le $tolerance) {
                    Write-Host "  [OK] Screen count match verified (SITEMAP $sitemapScreens vs DESIGN_SPEC $specScreens, tolerance +/-$tolerance)" -ForegroundColor Green
                } else {
                    Write-Host "  [ERROR] Screen count mismatch: SITEMAP $sitemapScreens vs DESIGN_SPEC $specScreens (exceeds +/-10% tolerance)!" -ForegroundColor Red
                    $missingRequired += "Screen count match (SITEMAP vs DESIGN_SPEC)"
                }
            }
        }
    }
}
if ($Module -eq "M05" -and -not $isSmallScale) {
    # Content verification for PRD.md
    if (Test-Path "docs/specs/PRD.md") {
        $prdContent = Get-Content "docs/specs/PRD.md" -Raw
        if ($prdContent -match '(?i)REQ-[0-9]+' -and $prdContent -match '(?i)F-[0-9]+') {
            Write-Host "  [OK] PRD.md functional traceability matrix verified (F-xx -> REQ-xx mapped)" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] PRD.md missing functional traceability matrix (must map F-xx features to REQ-xx requirements)!" -ForegroundColor Red
            $missingRequired += "PRD.md (functional traceability matrix F-xx -> REQ-xx)"
        }
        if ($prdContent -match '(?i)Given ' -and $prdContent -match '(?i)When ' -and $prdContent -match '(?i)Then ') {
            Write-Host "  [OK] PRD.md BDD release acceptance scenarios verified (Given-When-Then format)" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] PRD.md missing Given-When-Then BDD acceptance scenarios in Section 8!" -ForegroundColor Red
            $missingRequired += "PRD.md (Given-When-Then BDD acceptance scenarios)"
        }
    }

    if (Test-Path "docs/specs/FSD.md") {
        $fsdContent = Get-Content "docs/specs/FSD.md" -Raw

        # 1. Stack Decision LOCKED
        if ($fsdContent -match '(?i)Stack Decision LOCKED:') {
            Write-Host "  [OK] Locked tech stack decision documented in FSD.md" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] FSD.md missing locked tech stack decision ('Stack Decision LOCKED:')!" -ForegroundColor Red
            $missingRequired += "FSD.md (Stack Decision LOCKED:)"
        }

        # 2. Database Schema DDL
        if ($fsdContent -match '(?i)CREATE TABLE|mongoose\.Schema|models\.Model|Schema::create|model [A-Za-z]+ \{') {
            Write-Host "  [OK] Database schema definition verified in FSD.md (DDL / ORM models present)" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] FSD.md missing explicit database schema definition (CREATE TABLE / ORM models)!" -ForegroundColor Red
            $missingRequired += "FSD.md (database schema DDL)"
        }

        # 3. API Endpoints contract (>= 5 endpoints)
        $epMatches = [regex]::Matches($fsdContent, '(?im)####\s*(GET|POST|PUT|PATCH|DELETE)|Route::(get|post|put|delete)|@(Get|Post|Put|Delete)Mapping|path:\s*/api').Count
        if ($epMatches -ge 5) {
            Write-Host "  [OK] API endpoint contracts verified ($epMatches endpoints documented)" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] FSD.md insufficient API endpoint contracts: found only $epMatches endpoints (minimum 5 required)!" -ForegroundColor Red
            $missingRequired += "FSD.md (>= 5 API endpoint contracts)"
        }

        # 4. Idempotency Key table for financial/mutation systems
        if (Test-Path "docs/pm/PROJECT_STATE.md") {
            $stContent = Get-Content "docs/pm/PROJECT_STATE.md" -Raw
            if ($stContent -match '(?i)financial|pembayaran|payment|saldo|transaksi|checkout|order') {
                if ($fsdContent -match '(?i)idempotency_keys|idempotency') {
                    Write-Host "  [OK] Idempotency protection schema verified in FSD.md (idempotency_keys table present)" -ForegroundColor Green
                } else {
                    Write-Host "  [ERROR] FSD.md missing idempotency_keys table for financial/mutation project!" -ForegroundColor Red
                    $missingRequired += "FSD.md (idempotency_keys schema)"
                }
            }
            if ($stContent -match '(?i)multi-tenant|branch|cabang|tenant|organization' -or $fsdContent -match '(?i)org_id|tenant_id') {
                if ($fsdContent -match '(?i)ROW LEVEL SECURITY|ENABLE ROW LEVEL SECURITY|rls') {
                    Write-Host "  [OK] Multi-tenant isolation verified in FSD.md (Row-Level Security RLS present)" -ForegroundColor Green
                } else {
                    Write-Host "  [ERROR] FSD.md missing Row-Level Security (RLS) policies for multi-tenant data isolation!" -ForegroundColor Red
                    $missingRequired += "FSD.md (Row-Level Security RLS)"
                }
            }
        }
    }

    # Architecture Decision Record is MANDATORY for Medium+ (justify architectural style choices)
    if (Test-Path "docs/pm/PROJECT_STATE.md") {
        $m5State = Get-Content "docs/pm/PROJECT_STATE.md" -Raw
        if ($m5State -match '(?i)Scale:\s*(medium|large|enterprise)') {
            Write-Host "  [INFO] Medium+ scale detected: Architecture Decision Record (ADR) is MANDATORY." -ForegroundColor Cyan
            $adrExists = (Test-Path "docs/governance/ADR.md") -or (Test-Path "docs/specs/ADR.md")
            if ($adrExists) {
                Write-Host "  [OK] docs/governance/ADR.md (architecture decision record present)" -ForegroundColor Green
            } else {
                Write-Host "  [ERROR] Medium+ scale requires Architecture Decision Record (docs/governance/ADR.md)!" -ForegroundColor Red
                $missingRequired += "docs/governance/ADR.md (Medium+ architecture decision record)"
            }
        }
    }
}
if ($Module -eq "M06") {
    # Content verification for TODO.md
    if (Test-Path "TODO.md") {
        $todoContent = Get-Content "TODO.md" -Raw
        $doneMatches = ([regex]::Matches($todoContent, '(?im)^\s*-\s*\[x\]')).Count
        if ($doneMatches -ge 3) {
            Write-Host "  [OK] Completed tasks verified in TODO.md ($doneMatches tasks marked '[x]')" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] TODO.md has insufficient completed tasks: found only $doneMatches marked '[x]' (minimum 3 completed tasks required)!" -ForegroundColor Red
            $missingRequired += "TODO.md (>= 3 completed tasks marked '[x]')"
        }
        # Zero unfinished tasks allowed when declaring M06 complete (no [ ], [~], or [!] permitted)
        $pendingMatches = ([regex]::Matches($todoContent, '(?im)^\s*-\s*\[[ ~!]\]')).Count
        if ($pendingMatches -gt 0) {
            Write-Host "  [ERROR] TODO.md has $pendingMatches unfinished/blocked task(s) marked '[ ]', '[~]', or '[!]'! All sprint tasks must be completed ([x]) before closing Module 06." -ForegroundColor Red
            $missingRequired += "TODO.md ($pendingMatches unfinished/blocked tasks remaining)"
        } else {
            Write-Host "  [OK] 100% Sprint completion verified: zero pending/blocked tasks in TODO.md" -ForegroundColor Green
        }
        # Verify core engineering categories are present in tasks (DB, BE, FE)
        $hasCoreCats = $true
        foreach ($cat in @("DB", "BE", "FE")) {
            if ($todoContent -notmatch "(?i)M06-$cat-[0-9]+") {
                Write-Host "  [ERROR] TODO.md missing core category tasks for 'M06-$cat-xx'!" -ForegroundColor Red
                $missingRequired += "TODO.md (missing M06-$cat-xx tasks)"
                $hasCoreCats = $false
            }
        }
        if ($hasCoreCats) {
            Write-Host "  [OK] Full-stack atomic task categories verified in TODO.md (DB, BE, FE)" -ForegroundColor Green
        }
        # Mandatory specs pre-read task must exist and be completed
        if ($todoContent -match '(?i)M06-SETUP-03|Specs Pre-Read|Pre-Read Sign-Off') {
            if ($todoContent -match '(?im)^\s*-\s*\[[xX]\].*M06-SETUP-03|^\s*-\s*\[[xX]\].*Pre-Read Sign-Off') {
                Write-Host "  [OK] Specs pre-read task verified (M06-SETUP-03 completed)" -ForegroundColor Green
            } else {
                Write-Host "  [ERROR] Specs pre-read task (M06-SETUP-03) present but NOT completed! Read AGENTS/CONTEXT/PROJECT_LITE/FSD/PRD before coding." -ForegroundColor Red
                $missingRequired += "TODO.md (M06-SETUP-03 pre-read not completed)"
            }
        } else {
            Write-Host "  [ERROR] TODO.md missing mandatory specs pre-read task (M06-SETUP-03)!" -ForegroundColor Red
            $missingRequired += "TODO.md (missing M06-SETUP-03 pre-read task)"
        }
    }
    # Content verification for AGENTS.md
    if (Test-Path "AGENTS.md") {
        $agentsContent = Get-Content "AGENTS.md" -Raw
        if ($agentsContent -match '(?i)typescript|strict|anti-slop|guidelines|verification|test|standards') {
            Write-Host "  [OK] AGENTS.md technical quality and engineering guidelines verified" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] AGENTS.md missing technical guidelines / anti-slop engineering standards!" -ForegroundColor Red
            $missingRequired += "AGENTS.md (technical guidelines / anti-slop)"
        }
    }
    # Content verification for VERIFY_LOCAL.md
    $verifyFile = if (Test-Path "VERIFY_LOCAL.md") { "VERIFY_LOCAL.md" } elseif (Test-Path "docs/VERIFY_LOCAL.md") { "docs/VERIFY_LOCAL.md" } elseif (Test-Path "docs/specs/VERIFY_LOCAL.md") { "docs/specs/VERIFY_LOCAL.md" } else { $null }
    if ($verifyFile) {
        $verifyContent = Get-Content $verifyFile -Raw
        if ($verifyContent -match '(?i)LOCAL PASS|\[x\]\s*\*?PASS\*?|Exit code 0|Smoke Test PASS|All assertions passed') {
            Write-Host "  [OK] VERIFY_LOCAL.md test execution proof verified (LOCAL PASS / assertions passed)" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] VERIFY_LOCAL.md missing proof of test execution (requires 'LOCAL PASS', 'Exit code 0', or passing test assertions)!" -ForegroundColor Red
            $missingRequired += "VERIFY_LOCAL.md (test execution proof: LOCAL PASS / assertions passed)"
        }
    }
    # Mechanical anti-slop source scan (BLOCKER): scan real source dirs only
    $scanDirs = @()
    foreach ($d in @("src", "app", "lib", "components", "pages", "server", "api")) {
        if (Test-Path $d) { $scanDirs += $d }
    }
    if ($scanDirs.Count -gt 0) {
        $srcFiles = Get-ChildItem -Path $scanDirs -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -in @(".ts", ".tsx", ".js", ".jsx", ".vue", ".svelte", ".php", ".py", ".go", ".rb", ".java", ".cs") }
        $tsIgnore = 0; $todoStub = 0; $hcSecret = 0
        foreach ($f in $srcFiles) {
            $text = Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue
            if ($text -match '(?m)//\s*@ts-(ignore|nocheck|expect-error)') { $tsIgnore++ }
            if ($text -match '(?im)//\s*TODO:?\s*(Implement|Add (your )?logic|Fill|Complete|Fix later)') { $todoStub++ }
            $lines = $text -split "`n"
            foreach ($ln in $lines) {
                if ($ln -match "(?i)(api[_-]?key|secret|password|passwd|token|private[_-]?key)\s*[:=]\s*[""'][A-Za-z0-9_\-]{16,}[""']" -and $ln -notmatch "(?i)process\.env|import\.meta\.env|example|placeholder|your[_-]|xxx|\*\*\*") { $hcSecret++ }
            }
        }
        if ($tsIgnore -gt 0) {
            Write-Host "  [ERROR] Anti-slop: found $tsIgnore file(s) with type-suppression escape hatches (@ts-ignore / @ts-nocheck / @ts-expect-error)!" -ForegroundColor Red
            $missingRequired += "Anti-slop (type-suppression escape hatches)"
        } else {
            Write-Host "  [OK] Anti-slop: zero type-suppression escape hatches in source" -ForegroundColor Green
        }
        if ($todoStub -gt 0) {
            Write-Host "  [ERROR] Anti-slop: found $todoStub file(s) with unresolved placeholder TODO stubs!" -ForegroundColor Red
            $missingRequired += "Anti-slop (placeholder TODO stubs)"
        } else {
            Write-Host "  [OK] Anti-slop: zero placeholder TODO stubs in source" -ForegroundColor Green
        }
        if ($hcSecret -gt 0) {
            Write-Host "  [ERROR] Anti-slop: found $hcSecret possible hardcoded secret(s)! Use process.env." -ForegroundColor Red
            $missingRequired += "Anti-slop (hardcoded secrets)"
        } else {
            Write-Host "  [OK] Anti-slop: zero obvious hardcoded secrets in source" -ForegroundColor Green
        }
    }
}
if ($Module -eq "M07" -and -not $isSmallScale) {
    # Content verification (BLOCKER): workbook must attest a real PASS, not FAILED / NOT EXECUTED.
    $sitFile = if (Test-Path "docs/qa/SIT_WORKBOOK.md") { "docs/qa/SIT_WORKBOOK.md" } else { $null }
    if ($sitFile) {
        $sitContent = Get-Content $sitFile -Raw
        if ($sitContent -match '\[Your Name\]|\[Application Name\]|\[client-domain\]|\[e\.g\.|\[git-hash\]|\[YYYY-MM-DD\]|\[Total\]|\[ID\]') {
            Write-Host "  [ERROR] SIT_WORKBOOK.md still contains unresolved template placeholders ([...])! Fill in real execution results." -ForegroundColor Red
            $missingRequired += "SIT_WORKBOOK.md (unresolved template placeholders)"
        } elseif ($sitContent -match '(?i)NOT EXECUTED|NOT PASSED|NOT TESTED|Status\s*:\s*FAIL|Testing Status\s*:\s*FAIL') {
            Write-Host "  [ERROR] SIT_WORKBOOK.md reports a FAILED / NOT EXECUTED status! SIT must PASS before Client UAT." -ForegroundColor Red
            $missingRequired += "SIT_WORKBOOK.md (reports FAILED / NOT EXECUTED)"
        } elseif ($sitContent -match '(?i)SIT PASS|READY FOR UAT|Testing Status[^:]*:\s*PASS|PASSED \(SIT PASS\)') {
            Write-Host "  [OK] SIT_WORKBOOK.md attests SIT PASS (ready for UAT)" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] SIT_WORKBOOK.md missing explicit PASS attestation ('SIT PASS' / 'READY FOR UAT')!" -ForegroundColor Red
            $missingRequired += "SIT_WORKBOOK.md (missing PASS attestation)"
        }
        if ($sitContent -match '(?i)https?://\S+') {
            Write-Host "  [OK] SIT_WORKBOOK.md references a staging/environment URL" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] SIT_WORKBOOK.md missing staging environment URL!" -ForegroundColor Red
            $missingRequired += "SIT_WORKBOOK.md (missing staging URL)"
        }
        # Reject any failed scenario: an explicit FAIL cell or a non-zero Failed-column count.
        if (($sitContent -match '\|\s*\**FAIL\**\s*\|') -or ($sitContent -match '\|\s*[0-9]+\s*\|\s*[0-9]+\s*\|\s*[1-9][0-9]*\s*\|')) {
            Write-Host "  [ERROR] SIT_WORKBOOK.md contains FAILED test scenario(s)! 100% of SIT scenarios must PASS before Client UAT." -ForegroundColor Red
            $missingRequired += "SIT_WORKBOOK.md (failed test scenario present)"
        } else {
            Write-Host "  [OK] SIT_WORKBOOK.md shows zero failed SIT scenarios" -ForegroundColor Green
        }
        # Coverage threshold for Large / Enterprise (module 07 §6).
        if ($isLargeScale) {
            $covMin = if ($isEnterprise) { 80 } else { 70 }
            $covMatch = [regex]::Match($sitContent, '(?i)line\s*coverage[^\d]*([0-9]+)')
            if ($covMatch.Success) {
                $covVal = [int]$covMatch.Groups[1].Value
                if ($covVal -ge $covMin) {
                    Write-Host "  [OK] SIT_WORKBOOK.md line coverage ${covVal}% >= ${covMin}% (required)" -ForegroundColor Green
                } else {
                    Write-Host "  [ERROR] SIT_WORKBOOK.md line coverage ${covVal}% < ${covMin}% required for this scale!" -ForegroundColor Red
                    $missingRequired += "SIT_WORKBOOK.md (line coverage ${covVal}% < ${covMin}%)"
                }
            } else {
                Write-Host "  [ERROR] SIT_WORKBOOK.md missing 'Line Coverage: N%' report (>= ${covMin}% required for this scale)!" -ForegroundColor Red
                $missingRequired += "SIT_WORKBOOK.md (missing line coverage report)"
            }
        }
    }
    # Content verification (BLOCKER): zero-Critical attestation required.
    $secFile = if (Test-Path "docs/qa/SECURITY_AUDIT.md") { "docs/qa/SECURITY_AUDIT.md" } elseif (Test-Path "docs/qa/SECURITY_AUDIT_REPORT.md") { "docs/qa/SECURITY_AUDIT_REPORT.md" } else { $null }
    if ($secFile) {
        $secContent = Get-Content $secFile -Raw
        if ($secContent -match '\[Your Name\]|\[Application Name\]|\[client-domain\]|\[YYYY-MM-DD\]|\[Patched / Monitored\]') {
            Write-Host "  [ERROR] $secFile still contains unresolved template placeholders ([...])! Fill in real audit results." -ForegroundColor Red
            $missingRequired += "$secFile (unresolved template placeholders)"
        } elseif (($secContent -match '(?im)\[x\][^A-Za-z]*REJECTED') -or ($secContent -match '\|\s*Critical\s*\|\s*[1-9][0-9]*\s*\|')) {
            Write-Host "  [ERROR] $secFile reports unresolved Critical vulnerabilities! Zero Critical required before go-live." -ForegroundColor Red
            $missingRequired += "$secFile (unresolved Critical vulnerabilities)"
        } elseif ($secContent -match '(?im)\[x\][^A-Za-z]*(SECURITY PASS|MEETS SECURITY STANDARDS)|Free of Critical|Zero Critical|0 Critical') {
            Write-Host "  [OK] $secFile attests SECURITY PASS (zero Critical vulnerabilities)" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] $secFile missing zero-Critical attestation ('SECURITY PASS' / 'Free of Critical')!" -ForegroundColor Red
            $missingRequired += "$secFile (missing zero-Critical attestation)"
        }
    }
}
if ($Module -eq "M08") {
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
