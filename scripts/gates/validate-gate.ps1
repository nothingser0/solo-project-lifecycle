#!/usr/bin/env pwsh
# validate-gate.ps1 - Thin wrapper around validate-gate.sh (single source of gate logic).
# v2.3: full PowerShell duplicate retired. Requires a REAL bash -- resolution and
# rationale live in lib/BashResolver.ps1.
#
# Usage: ./scripts/gates/validate-gate.ps1 <MODULE_ID>
#
# Gates are CWD-relative: they read docs/pm/... from the PROJECT directory. This
# wrapper deliberately does NOT change directory -- v2.2 forced a cd to the framework
# repo root, so validating a scaffolded project silently validated the framework's own
# tree instead (every gate reported MISSING artifacts).
#
# Exit codes: 0 PASS - 1 FAILED - 3 RETEST (non-terminal verdict) - 2 no usable bash.

param(
    [Parameter(Position = 0)]
    [string]$Module
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $scriptDir "lib\BashResolver.ps1")

if ([string]::IsNullOrWhiteSpace($Module)) {
    Write-Host "Usage: validate-gate.ps1 <MODULE_ID>"
    Write-Host "Example: validate-gate.ps1 M03"
    Write-Host "Available gates: M00..M13 | A00..A04"
    exit 1
}

$bashScript = Join-Path $scriptDir "validate-gate.sh"
if (-not (Test-Path $bashScript)) {
    Write-Host "[ERROR] validate-gate.sh not found next to this wrapper: $bashScript"
    exit 1
}

$bashCmd = Resolve-Bash
if (-not $bashCmd) {
    Write-BashMissingHelp -ScriptName "the gate validator" -UsageHint "./scripts/gates/validate-gate.sh $Module"
    exit 2
}

# Run from the CALLER's directory: the gate reads the project being validated.
Invoke-Bash -Bash $bashCmd -Script $bashScript -Arguments @($Module)
exit $script:LastBashExitCode
