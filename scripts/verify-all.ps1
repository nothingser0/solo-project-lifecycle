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
$psScripts = Get-ChildItem -Path "scripts/*.ps1"
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
    "00-product-discovery-strategy.md",
    "01-idea-feasibility.md",
    "02-discovery-scope.md",
    "03-legal-sow-charter.md",
    "04-uiux-prototyping.md",
    "05-architecture-specs.md",
    "06-development-execution.md",
    "07-quality-assurance-sit.md",
    "08-data-migration-seeding.md",
    "09-uat-client-signoff.md",
    "10-deployment-production.md",
    "11-handover-bast.md",
    "12-warranty-sla-retainer.md",
    "13-product-operations-iteration.md"
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
    "case-studies/README.md"
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
    "01-mvp-saas-inventory.md",
    "02-ecommerce-fashion-mvp.md",
    "03-crm-real-estate-internal.md",
    "04-medium-b2b-saas-worked-example.md",
    "05-large-system-integration-worked-example.md"
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

# 5. Verify Patterns Presence (12 Patterns)
Write-Host ""
Write-Host "5. Checking Patterns..."
$patterns = @(
    "patterns/api/graphql-and-versioning.md",
    "patterns/api/rest-conventions.md",
    "patterns/database/seeding-and-transactions.md",
    "patterns/database/supabase-migrations.md",
    "patterns/deployment/ci-cd-pipeline.md",
    "patterns/error-handling/error-boundaries.md",
    "patterns/git-workflow/branching-strategy.md",
    "patterns/performance/caching-strategies.md",
    "patterns/performance/n-plus-one-prevention.md",
    "patterns/security/authentication.md",
    "patterns/testing/test-pyramid.md",
    "patterns/validation/zod-patterns.md"
)

foreach ($pat in $patterns) {
    if (Test-Path $pat) {
        Write-Host "  [OK] $pat" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Missing $pat" -ForegroundColor Red
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
