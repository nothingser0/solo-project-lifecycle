<#
.SYNOPSIS
  Professional UI/UX Consistency Auditor & Auto-Fixer for Prototype Screens
  Verifies token alignment, reusable components, animation discipline, zero emoticons,
  and cross-screen navigation parity across docs/design/screens/

.EXAMPLE
  .\scripts\design\uiux-audit.ps1
  .\scripts\design\uiux-audit.ps1 -Fix
  .\scripts\design\uiux-audit.ps1 -Report "docs\specs\DESIGN_SYSTEM_AUDIT.md"
#>

[CmdletBinding()]
param(
    [string]$TargetDir = "docs/design/screens",
    [switch]$Fix,
    [string]$Report
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $TargetDir)) {
    Write-Warning "Target directory not found: $TargetDir"
    exit 0
}

$htmlFiles = @(Get-ChildItem -Path $TargetDir -Filter "*.html" -Recurse | Sort-Object FullName)
if ($htmlFiles.Count -eq 0) {
    Write-Warning "No HTML prototype screens found in $TargetDir"
    exit 0
}

$divider = "=" * 65

Write-Host ""
Write-Host "[AUDIT] Starting Professional UI/UX Consistency Audit on $($htmlFiles.Count) screen(s)..." -ForegroundColor Cyan
Write-Host "[TARGET] Directory: $((Resolve-Path $TargetDir).Path)"
if ($Fix) {
    Write-Host "[AUTO-FIX] Mode: ENABLED" -ForegroundColor Yellow
}
Write-Host $divider

$emojiRegex = "[\uD83C-\uDBFF\uDC00-\uDFFF\u2600-\u26FF\u2700-\u27BF]"
$specLeakRegex = "\b(SCR-\d+|M06-FE-\d+|REQ-\d+|FSD-\d+)\b"
$rawNeonRegex = "(#FF5722|#FF0000|#00FF00|bg-orange-500|bg-red-500|#3B82F6)"

$totalViolations = 0
$totalWarnings = 0
$totalFixes = 0

$screenAudits = @()
$baselineNav = @()
$baselineBrand = $null
$baselineName = ""

foreach ($file in $htmlFiles) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $violations = @()
    $warnings = @()
    $passed = @()
    $fixes = @()
    $isModified = $false

    # 1. Viewport Meta & Mobile Readiness
    if ($content -notmatch '<meta\s+name=["'']viewport["'']') {
        if ($Fix) {
            if ($content -match '<head>') {
                $content = $content -replace '<head>', "<head>`n  <meta name=`"viewport`" content=`"width=device-width, initial-scale=1.0`">"
                $fixes += "Injected missing mobile viewport meta tag"
                $isModified = $true
            } else {
                $violations += "Missing <meta name=`"viewport`"> (required for mobile ergonomics)"
            }
        } else {
            $violations += "Missing <meta name=`"viewport`"> (required for mobile ergonomics)"
        }
    } else {
        $passed += "Mobile viewport meta tag verified"
    }

    # 2. Shared CSS Linkage
    if ($content -notmatch '<link[^>]+rel=["'']stylesheet["''][^>]+href=["''][^"'']+\.css["'']') {
        if ($Fix) {
            if ($content -match '</head>') {
                $content = $content -replace '</head>', "  <link rel=`"stylesheet`" href=`"css/styles.css`">`n</head>"
                $fixes += "Linked shared stylesheet (css/styles.css)"
                $passed += "Linked shared stylesheet (auto-fixed)"
                $isModified = $true
            } else {
                $violations += "Missing shared stylesheet link (<link rel=`"stylesheet`" href=`"css/styles.css`">)"
            }
        } else {
            $violations += "Missing shared stylesheet link (<link rel=`"stylesheet`" href=`"css/styles.css`">)"
        }
    } else {
        $passed += "Shared stylesheet linked"
    }

    # 3. Shared JS Script Linkage
    if ($content -notmatch '<script[^>]+src=["''][^"'']+\.js["'']') {
        if ($Fix) {
            if ($content -match '</body>') {
                $content = $content -replace '</body>', "  <script src=`"js/app.js`"></script>`n</body>"
                $fixes += "Linked shared script (js/app.js)"
                $passed += "Linked shared script (auto-fixed)"
                $isModified = $true
            } else {
                $warnings += "Missing shared script (<script src=`"js/app.js`"></script>)"
            }
        } else {
            $warnings += "Missing shared script (<script src=`"js/app.js`"></script>)"
        }
    } else {
        $passed += "Shared script linked"
    }

    # 4. Zero Emoticons / Emojis Audit
    if ($content -match $emojiRegex) {
        $violations += "Raw emoticon/emoji detected! All UI components must use vector SVG icons."
    } else {
        $passed += "Zero emoticons/emojis detected (SVG icons compliant)"
    }

    # 5. Component Classes (.btn, .card, .badge)
    $buttonMatches = [regex]::Matches($content, '<button[^>]*>')
    $unclassedButtons = 0
    foreach ($b in $buttonMatches) {
        if ($b.Value -notmatch 'class=' -or $b.Value -notmatch 'btn') {
            $unclassedButtons++
        }
    }
    if ($unclassedButtons -gt 0) {
        $warnings += "Found $unclassedButtons button(s) missing standard .btn class"
    } elseif ($buttonMatches.Count -gt 0) {
        $passed += "All $($buttonMatches.Count) buttons conform to .btn component standard"
    }

    # 6. Form Controls: Anti-Zoom & Unstyled Select
    if ($content -match '<select(?![^>]*class=["''][^"'']*(form-select|custom-select)[^"'']*["''])') {
        $violations += "Unstyled native <select> detected! Must use custom popover or .form-select."
    }
    if ($content -match '<input\s+type=["'']number["'']') {
        $warnings += "Found <input type=`"number`">. Use inputmode=`"numeric`" for currency/amounts."
    }

    # 7. Zero Spec Leaks
    $cleanContent = $content -replace '(?s)<!--.*?-->', ''
    $cleanContent = $cleanContent -replace '(?s)<script.*?</script>', ''
    $specMatches = [regex]::Matches($cleanContent, $specLeakRegex)
    $visibleLeaks = @()
    foreach ($m in $specMatches) {
        if ($content -notmatch "<title>[^<]*$($m.Value)[^<]*</title>") {
            $visibleLeaks += $m.Value
        }
    }
    if ($visibleLeaks.Count -gt 0) {
        $uniqueLeaks = $visibleLeaks | Select-Object -Unique
        $violations += "Internal spec identifier(s) leaked in UI: $($uniqueLeaks -join ', ')"
    } else {
        $passed += "Zero internal spec identifiers leaked in rendered UI"
    }

    # 8. Uncalibrated Neon Palette
    if ($content -match $rawNeonRegex) {
        $warnings += "Uncalibrated raw neon colors detected. Use semantic tokens from DESIGN.md."
    }

    # 9. Multi-Role RBAC Simulation Check
    if ($content -match 'id=["'']role-switcher["'']' -or $content -match 'data-roles=' -or $content -match 'data-role-mask=') {
        $passed += "Interactive multi-role RBAC simulation supported (role switcher / role attributes present)"
    } else {
        $warnings += "Screen missing multi-role testing hooks (#role-switcher or data-roles attributes)"
    }

    # Extract Nav Items & Brand Title
    $navMatches = [regex]::Matches($content, '<(?:a|button)[^>]+class=["''][^"'']*(?:sidebar-link|nav-link)[^"'']*["''][^>]*>(.*?)</(?:a|button)>', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $navItems = @()
    foreach ($nm in $navMatches) {
        $cleanText = ($nm.Groups[1].Value -replace '<[^>]+>', '').Trim()
        if ($cleanText) { $navItems += $cleanText }
    }

    $brandTitle = $null
    if ($content -match 'class=["''][^"'']*(?:sidebar-header|navbar-brand)[^"'']*["''][^>]*>.*?<span[^>]*>(.*?)</span>') {
        $brandTitle = ($matches[1] -replace '<[^>]+>', '').Trim()
    }

    if ($baselineNav.Count -eq 0 -and $navItems.Count -gt 0) {
        $baselineNav = $navItems
        $baselineBrand = $brandTitle
        $baselineName = $file.Name
    } elseif ($baselineNav.Count -gt 0 -and $navItems.Count -gt 0) {
        $diff = Compare-Object $baselineNav $navItems
        if ($diff) {
            $warnings += "Navigation links differ from baseline ($baselineName)"
        } else {
            $passed += "Navigation menu in 100% parity with $baselineName"
        }
        if ($baselineBrand -and $brandTitle -and $baselineBrand -ne $brandTitle) {
            $violations += "Brand title inconsistency: '$brandTitle' vs '$baselineBrand' in $baselineName"
        }
    }

    # Save fixes if modified
    if ($isModified -and $Fix) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
    }

    $totalViolations += $violations.Count
    $totalWarnings += $warnings.Count
    $totalFixes += $fixes.Count

    $screenAudits += [PSCustomObject]@{
        Filename = $file.Name
        Passed = $passed
        Warnings = $warnings
        Violations = $violations
        Fixes = $fixes
    }

    # Display Screen Results
    $statusText = if ($violations.Count -gt 0) { "[FAIL]" } elseif ($warnings.Count -gt 0) { "[WARN]" } else { "[PASS]" }
    $fgColor = if ($violations.Count -gt 0) { "Red" } elseif ($warnings.Count -gt 0) { "Yellow" } else { "Green" }
    Write-Host ""
    Write-Host "$statusText Screen: $($file.Name)" -ForegroundColor $fgColor
    
    foreach ($f in $fixes) {
        Write-Host "  [FIXED] $f" -ForegroundColor Cyan
    }
    foreach ($p in $passed) {
        Write-Host "  [PASS] $p" -ForegroundColor Gray
    }
    foreach ($w in $warnings) {
        Write-Host "  [WARN] $w" -ForegroundColor Yellow
    }
    foreach ($v in $violations) {
        Write-Host "  [FAIL] $v" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host $divider
Write-Host "[SUMMARY] UI/UX AUDIT SUMMARY" -ForegroundColor Cyan
Write-Host "  Screens Audited   : $($screenAudits.Count)"
Write-Host "  Auto-Fixes Done   : $totalFixes"
Write-Host "  Total Warnings    : $totalWarnings"
Write-Host "  Total Violations  : $totalViolations"
Write-Host $divider

if ($Report) {
    $reportDir = Split-Path -Path $Report -Parent
    if ($reportDir -and -not (Test-Path $reportDir)) {
        New-Item -ItemType Directory -Force -Path $reportDir | Out-Null
    }

    $statusHeader = if ($totalViolations -eq 0) { "PASSED" } else { "ACTION REQUIRED" }
    $lines = @(
        "# Design System and UI/UX Consistency Audit Report",
        "",
        "**Audit Status**: $statusHeader  ",
        "**Target Directory**: $TargetDir  ",
        "**Total Screens**: $($screenAudits.Count)  ",
        "**Auto-Fixes Applied**: $totalFixes  ",
        "**Open Violations**: $totalViolations  ",
        "",
        "---",
        "",
        "## Screen Breakdown",
        ""
    )

    foreach ($sa in $screenAudits) {
        $lines += "### Screen: $($sa.Filename)"
        $lines += ""
        if ($sa.Fixes.Count -gt 0) {
            $lines += "**Auto-Fixes Applied:**"
            foreach ($fx in $sa.Fixes) { $lines += "- [FIXED] $fx" }
            $lines += ""
        }
        if ($sa.Violations.Count -gt 0) {
            $lines += "**Violations (Must Fix):**"
            foreach ($vl in $sa.Violations) { $lines += "- [FAIL] $vl" }
            $lines += ""
        }
        if ($sa.Warnings.Count -gt 0) {
            $lines += "**Advisories / Polish Opportunities:**"
            foreach ($wn in $sa.Warnings) { $lines += "- [WARN] $wn" }
            $lines += ""
        }
        if ($sa.Passed.Count -gt 0) {
            $lines += "**Verified Passes:**"
            foreach ($ps in $sa.Passed) { $lines += "- [PASS] $ps" }
            $lines += ""
        }
    }

    Set-Content -Path $Report -Value ($lines -join "`n") -Encoding UTF8
    Write-Host "[REPORT] Full audit report saved to: $((Resolve-Path $Report).Path)" -ForegroundColor Green
}

if ($totalViolations -gt 0) {
    Write-Host "[VERDICT] FAILED. Address violations above before Design Freeze.`n" -ForegroundColor Red
    exit 1
} else {
    Write-Host "[VERDICT] PASSED. Design system consistency and craftsmanship verified.`n" -ForegroundColor Green
    exit 0
}
