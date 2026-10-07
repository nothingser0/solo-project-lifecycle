# calculate-size.ps1 - Accurately calculate repository footprint and token counts
# Usage: .\scripts\calculate-size.ps1

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir = Split-Path -Parent (Split-Path -Parent $scriptDir)

Push-Location $rootDir
try {
    Write-Host "=== Framework Size & Token Metrics ===" -ForegroundColor Cyan
    Write-Host ""

    $allFiles = Get-ChildItem -Recurse -File | Where-Object {
        $_.FullName -notmatch '\\\.' -and
        $_.FullName -notmatch '\\node_modules\\' -and
        $_.FullName -notmatch '\\dist\\'
    }

    $totalBytes = ($allFiles | Measure-Object -Property Length -Sum).Sum
    $sizeMB = [Math]::Round($totalBytes / 1MB, 2)
    $mdFiles = $allFiles | Where-Object { $_.Extension -eq ".md" }
    $scriptFiles = $allFiles | Where-Object { $_.Extension -in @(".sh", ".ps1", ".js", ".ts") }

    $totalWords = 0
    foreach ($f in $mdFiles) {
        $text = Get-Content $f.FullName -Raw
        $words = [regex]::Matches($text, '\S+').Count
        $totalWords += $words
    }
    $estTokens = [Math]::Round($totalWords * 1.33)

    Write-Host "Disk footprint (excl. .git) : $sizeMB MB"
    Write-Host "Total files                 : $($allFiles.Count)"
    Write-Host "Markdown documentation files: $($mdFiles.Count)"
    Write-Host "Tooling & helper scripts    : $($scriptFiles.Count)"
    Write-Host "Total document words        : $totalWords"
    Write-Host "Estimated framework tokens  : ~$estTokens tokens"
    Write-Host ""
    Write-Host "Breakdown by Category:"
    foreach ($d in @("docs", "templates", "patterns", "references", "scripts")) {
        if (Test-Path $d) {
            $catFiles = Get-ChildItem -Path $d -Recurse -File
            $catBytes = ($catFiles | Measure-Object -Property Length -Sum).Sum
            $catMB = [Math]::Round($catBytes / 1MB, 2)
            Write-Host ("  * {0,-12} : {1,6} MB ({2,3} files)" -f $d, $catMB, $catFiles.Count)
        }
    }
    Write-Host "========================================" -ForegroundColor Cyan
} finally {
    Pop-Location
}
