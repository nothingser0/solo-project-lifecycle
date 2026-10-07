# Template Linter (PowerShell)
# Validates filled templates against framework conventions
# Usage: .\scripts\lint-template.ps1 -File "docs/specs/PRD.md"

param(
    [Parameter(Mandatory=$true)]
    [string]$File
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $File)) {
    Write-Host "[ERROR] File not found: $File" -ForegroundColor Red
    exit 1
}

Write-Host "`n[INFO] Linting: $File" -ForegroundColor Cyan
Write-Host ("=" * 60)

$content = Get-Content $File -Raw
$issues = @()
$warnings = @()

# Check 1: Placeholder detection
$placeholders = @(
    "\[YOUR_.*?\]",
    "\[FILL.*?\]",
    "\[TODO.*?\]",
    "\[REPLACE.*?\]",
    "\[Nama.*?\]",
    "\[isi.*?\]",
    "\[Client.*?\]",
    "xxx",
    "yyy",
    "zzz"
)

foreach ($pattern in $placeholders) {
    if ($content -match $pattern) {
        $matches = [regex]::Matches($content, $pattern)
        foreach ($match in $matches) {
            $issues += "Placeholder not replaced: $($match.Value)"
        }
    }
}

# Check 2: Empty sections
$emptyPatterns = @(
    "(?m)^##\s+[^\r\n]+\r?\n\s*\r?\n\s*^##\s+",   # Empty H2 section
    "(?m)^###\s+[^\r\n]+\r?\n\s*\r?\n\s*^###\s+"  # Empty H3 subsection
)
foreach ($pattern in $emptyPatterns) {
    if ($content -match $pattern) {
        $warnings += "Empty section detected (may be intentional)"
    }
}

# Check 3: Broken internal links
$internalLinks = [regex]::Matches($content, '\[.*?\]\(((?!http)[^)]+)\)')
foreach ($match in $internalLinks) {
    $linkPath = $match.Groups[1].Value
    # Remove anchors
    $linkPath = $linkPath -replace '#.*$', ''
    
    $parentDir = Split-Path -Parent $File
    $targetPath = if ($parentDir) { Join-Path $parentDir $linkPath } else { $linkPath }
    if ($linkPath -and -not (Test-Path $targetPath)) {
        $issues += "Broken link: $linkPath"
    }
}

# Check 4: Template-specific rules
$filename = Split-Path -Leaf $File

if ($filename -match "PRD|FSD|DESIGN_SPEC") {
    # Check for dates
    if ($content -notmatch '\d{4}-\d{2}-\d{2}') {
        $warnings += "No dates found (expected in $filename)"
    }

    if ($filename -match "PRD") {
        if ($content -notmatch "Functional") {
            $issues += "Missing required PRD section: Functional (or Functional Traceability Matrix)"
        }
        if ($content -notmatch "Security") {
            $issues += "Missing required PRD section: Security (Multi-Layer Security Architecture)"
        }
    }

    if ($filename -match "FSD") {
        $fsdSections = @("Tech Stack", "Database Schema", "API Contract", "Security")
        foreach ($sec in $fsdSections) {
            if ($content -notmatch $sec) {
                $issues += "Missing required FSD section: $sec"
            }
        }
        if ($content -notmatch "CREATE TABLE|ALTER TABLE") {
            $warnings += "No SQL DDL found in FSD"
        }
    }
}

if ($filename -match "SOW_CONTRACT") {
    # Check for monetary values
    if ($content -notmatch '(?:Rp|IDR|\$|USD|EUR)\s*[\d,\.]+') {
        $issues += "No monetary values found (required in contract, e.g. Rp, $, USD, EUR)"
    }
    
    # Check for signatures section
    if ($content -notmatch 'Tanda Tangan|Signature') {
        $issues += "No signature section found"
    }
}

if ($filename -match "BAST") {
    # Check for handover checklist
    if ($content -notmatch '\[[ x]\]') {
        $warnings += "No checkboxes found (expected in BAST)"
    }
}

# Check 5: Word count (minimum content check)
$wordCount = ($content -split '\s+' | Where-Object { $_ }).Count
$minWords = 200

if ($wordCount -lt $minWords) {
    $warnings += "Low word count: $wordCount words (minimum $minWords expected)"
}

# Check 6: Frontmatter (YAML)
if ($content -match '\A---\s*\r?\n') {
    if ($content -notmatch '^---\s*\n.*?\n---\s*\n') {
        $issues += "Malformed YAML frontmatter"
    }
}

# Results
Write-Host ""
if ($issues.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Host "[OK] No issues found" -ForegroundColor Green
    Write-Host "   Word count: $wordCount" -ForegroundColor Gray
    exit 0
}

if ($issues.Count -gt 0) {
    Write-Host "[ERROR] Issues found: $($issues.Count)" -ForegroundColor Red
    foreach ($issue in $issues) {
        Write-Host "   - $issue" -ForegroundColor Red
    }
    Write-Host ""
}

if ($warnings.Count -gt 0) {
    Write-Host "[WARN] Warnings: $($warnings.Count)" -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host "   - $warning" -ForegroundColor Yellow
    }
    Write-Host ""
}

Write-Host "Word count: $wordCount" -ForegroundColor Gray

if ($issues.Count -gt 0) {
    exit 1
} else {
    exit 0
}
