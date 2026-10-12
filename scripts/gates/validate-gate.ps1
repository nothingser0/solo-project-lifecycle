#!/usr/bin/env pwsh
# validate-gate.ps1 - Thin wrapper around validate-gate.sh (single source of gate logic).
# v2.2: full PowerShell duplicate retired. Requires bash (Git for Windows, WSL, or Linux/macOS).
# Usage: ./scripts/gates/validate-gate.ps1 <MODULE_ID>

param(
    [Parameter(Position = 0)]
    [string]$Module
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

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

# Locate bash (Git for Windows / WSL / native)
$bashCmd = Get-Command bash -ErrorAction SilentlyContinue
if (-not $bashCmd) {
    Write-Host "[ERROR] bash not found on PATH."
    Write-Host "Gate logic lives only in validate-gate.sh now. Run it via Git Bash, WSL, or a Unix shell:"
    Write-Host "  ./scripts/gates/validate-gate.sh $Module"
    exit 2
}

# Execute the bash gate from the current working directory (gates are CWD-relative)
$repoRoot = (Get-Item (Join-Path $scriptDir "..\..\")).FullName
& $bashCmd "-lc" "cd `"$repoRoot`" && ./scripts/gates/validate-gate.sh `"$Module`""
exit $LASTEXITCODE
