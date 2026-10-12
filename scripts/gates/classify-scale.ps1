# classify-scale.ps1 - Thin wrapper around classify-scale.sh (single source of truth).
# The bash version uses structured-field parsing (no raw keyword grep); this wrapper
# delegates to it so Windows callers get identical behavior.
# Requires bash (Git for Windows, WSL, or Linux/macOS).
# Usage: .\scripts\gates\classify-scale.ps1 [-ProjectState path] [-SoloHoursPerWeek N]

param(
    [string]$ProjectState = "docs/pm/PROJECT_STATE.md",
    [int]$SoloHoursPerWeek = 28
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$bashScript = Join-Path $scriptDir "classify-scale.sh"

if (-not (Test-Path $bashScript)) {
    Write-Host "[ERROR] classify-scale.sh not found next to this wrapper: $bashScript" -ForegroundColor Red
    exit 1
}

$bashCmd = Get-Command bash -ErrorAction SilentlyContinue
if (-not $bashCmd) {
    Write-Host "[ERROR] bash not found on PATH. Classifier logic lives in classify-scale.sh." -ForegroundColor Red
    Write-Host "Run it via Git Bash, WSL, or a Unix shell:"
    Write-Host "  ./scripts/gates/classify-scale.sh $ProjectState"
    exit 2
}

$repoRoot = (Get-Item (Join-Path $scriptDir "..\..\")).FullName
$env:SOLO_HOURS_PER_WEEK = "$SoloHoursPerWeek"
& $bashCmd "-lc" "cd `"$repoRoot`" && ./scripts/gates/classify-scale.sh `"$ProjectState`""
exit $LASTEXITCODE
