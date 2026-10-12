# classify-scale.ps1 - Thin wrapper around classify-scale.sh (single source of truth).
# The bash version uses structured-field parsing (no raw keyword grep); this wrapper
# delegates to it so Windows callers get identical behavior. Bash resolution lives in
# lib/BashResolver.ps1.
# Usage: .\scripts\gates\classify-scale.ps1 [-ProjectState path] [-SoloHoursPerWeek N]
#
# The classifier reads the PROJECT_STATE.md path it is given, relative to the caller's
# directory -- this wrapper does not change directory (v2.2 forced a cd to the framework
# repo root, which validated the framework's own tree instead of the caller's project).
# Exit codes: classifier-specific (see classify-scale.sh) - 2 no usable bash.

param(
    [string]$ProjectState = "docs/pm/PROJECT_STATE.md",
    [int]$SoloHoursPerWeek = 28
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $scriptDir "lib\BashResolver.ps1")

$bashScript = Join-Path $scriptDir "classify-scale.sh"
if (-not (Test-Path $bashScript)) {
    Write-Host "[ERROR] classify-scale.sh not found next to this wrapper: $bashScript" -ForegroundColor Red
    exit 1
}

$bashCmd = Resolve-Bash
if (-not $bashCmd) {
    Write-BashMissingHelp -ScriptName "the scale classifier" -UsageHint "./scripts/gates/classify-scale.sh $ProjectState"
    exit 2
}

$env:SOLO_HOURS_PER_WEEK = "$SoloHoursPerWeek"
Invoke-Bash -Bash $bashCmd -Script $bashScript -Arguments @($ProjectState)
exit $script:LastBashExitCode
