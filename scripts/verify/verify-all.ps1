# ==============================================================================
# verify-all.ps1 - Repository Integrity & Sanity Checker (PowerShell)
# Validates PowerShell scripts syntax, module files, catalogs, case studies,
# and code pattern files.
# ==============================================================================

$ErrorActionPreference = "Continue"

Write-Host "=== Solo Project Lifecycle Integrity Check (PowerShell) ===" -ForegroundColor Blue
Write-Host ""

$errors = 0

# 1. Verify PowerShell Scripts Syntax
Write-Host "1. Checking powershell scripts syntax..."
$psScripts = Get-ChildItem -Path "scripts" -Recurse -Filter *.ps1
foreach ($s in $psScripts) {
    try {
        $null = [System.Management.Automation.PSParser]::Tokenize((Get-Content $s.FullName -Raw), [ref]$null)
        Write-Host "  [OK] $($s.FullName.Replace('\', '/'))" -ForegroundColor Green
    }
    catch {
        Write-Host "  [FAIL] Syntax error in $($s.FullName): $_" -ForegroundColor Red
        $errors++
    }
}

# 2. Verify 14 Modules Presence (M00 - M13)
Write-Host ""
Write-Host "2. Checking 14 Lifecycle Modules (docs/modules/)..."
$modules = @(
    "00_PRODUCT_DISCOVERY_STRATEGY.md",
    "01_IDEA_FEASIBILITY.md",
    "02_DISCOVERY_SCOPE.md",
    "03_LEGAL_SOW_CHARTER.md",
    "04_UIUX_PROTOTYPING.md",
    "05_ARCHITECTURE_SPECS.md",
    "06_DEVELOPMENT_EXECUTION.md",
    "07_QUALITY_ASSURANCE_SIT.md",
    "08_DATA_MIGRATION_SEEDING.md",
    "09_UAT_CLIENT_SIGNOFF.md",
    "10_DEPLOYMENT_PRODUCTION.md",
    "11_HANDOVER_BAST.md",
    "12_WARRANTY_SLA_RETAINER.md",
    "13_PRODUCT_OPERATIONS_ITERATION.md"
)

foreach ($m in $modules) {
    $target = Join-Path "docs/modules" $m
    if (Test-Path $target) {
        Write-Host "  [OK] $target" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Missing $target" -ForegroundColor Red
        $errors++
    }
}

# 3. Verify Key Catalogs
Write-Host ""
Write-Host "3. Checking Root & Directory Catalogs..."
$keyFiles = @(
    "README.md",
    "SKILL.md",
    "docs/README.md",
    "docs/modules/README.md",
    "templates/README.md",
    "patterns/README.md",
    "references/README.md",
    "scripts/README.md",
    "case-studies/README.md",
    "evals/README.md"
)

foreach ($kf in $keyFiles) {
    if (Test-Path $kf) {
        Write-Host "  [OK] $kf" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Missing $kf" -ForegroundColor Red
        $errors++
    }
}

# 4. Verify Case Studies Presence (01 - 05)
Write-Host ""
Write-Host "4. Checking Case Studies..."
$caseStudies = @(
    "01_MVP_SAAS_INVENTORY.md",
    "02_ECOMMERCE_FASHION_MVP.md",
    "03_CRM_REAL_ESTATE_INTERNAL.md",
    "04_MEDIUM_B2B_SAAS_WORKED_EXAMPLE.md",
    "05_LARGE_SYSTEM_INTEGRATION_WORKED_EXAMPLE.md"
)

foreach ($cs in $caseStudies) {
    $target = Join-Path "case-studies" $cs
    if (Test-Path $target) {
        Write-Host "  [OK] $target" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Missing $target" -ForegroundColor Red
        $errors++
    }
}

# 5. Verify Patterns Presence (4 active Indonesia/domain-specific + archived generics)
Write-Host ""
Write-Host "5. Checking Patterns..."
$patterns = @(
    "patterns/payments/INDONESIA_PAYMENT_GATEWAYS.md",
    "patterns/compliance/UU_PDP_COMPLIANCE.md",
    "patterns/offline/OFFLINE_FIRST_SYNC.md",
    "patterns/localization/I18N_INDONESIA.md"
)

foreach ($pat in $patterns) {
    if (Test-Path $pat) {
        Write-Host "  [OK] $pat" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Missing $pat" -ForegroundColor Red
        $errors++
    }
}
# Archived generic patterns (present under archive/patterns/ for recovery; not loaded by agents)
$archivedPatterns = @(
    "archive/patterns/validation/zod-patterns.md",
    "archive/patterns/security/authentication.md",
    "archive/patterns/testing/test-pyramid.md",
    "archive/patterns/deployment/ci-cd-pipeline.md"
)
foreach ($pat in $archivedPatterns) {
    if (-not (Test-Path $pat)) {
        Write-Host "  [FAIL] Archived pattern missing: $pat" -ForegroundColor Red
        $errors++
    }
}
Write-Host "  [OK] archived generic patterns present under archive/patterns/" -ForegroundColor Green

# 6. Verify Markdown Links and Frontmatter
Write-Host ""
Write-Host "6. Checking Markdown Links and SKILL.md Frontmatter..."
if (Get-Command node -ErrorAction SilentlyContinue) {
    $fmRes = node scripts/verify/verify-skill-frontmatter.js 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [OK] SKILL.md frontmatter valid" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] SKILL.md frontmatter invalid" -ForegroundColor Red
        $errors++
    }
    $linkRes = node scripts/verify/verify-links.js 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [OK] Internal Markdown links valid (0 broken)" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Broken markdown links found" -ForegroundColor Red
        $errors++
    }
    $idxRes = node scripts/verify/index-manifest.js --check 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [OK] INDEX.json manifest in two-way parity with filesystem" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] INDEX.json manifest out of sync (run: node scripts/verify/index-manifest.js)" -ForegroundColor Red
        $errors++
    }
}
Write-Host ""
if ($errors -eq 0) {
    Write-Host "All integrity checks passed successfully!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "Integrity check failed with $errors errors." -ForegroundColor Red
    exit 1
}
