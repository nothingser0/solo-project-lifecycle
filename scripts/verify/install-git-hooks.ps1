# install-git-hooks.ps1 - Installs pre-commit hook to automate verification
# Usage: .\scripts\verify\install-git-hooks.ps1

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir = Split-Path -Parent (Split-Path -Parent $scriptDir)
$hooksDir = Join-Path $rootDir ".git\hooks"

if (-not (Test-Path $hooksDir)) {
    Write-Host "[ERROR] .git/hooks directory not found. Is this a git repository?" -ForegroundColor Red
    exit 1
}

$preCommitPath = Join-Path $hooksDir "pre-commit"

$hookContent = @'
#!/bin/sh
# pre-commit - Run framework integrity checks before commit
echo "=== Running Pre-Commit Verification ==="

if command -v powershell.exe >/dev/null 2>&1; then
    powershell.exe -ExecutionPolicy Bypass -File scripts/verify/verify-all.ps1
    exit $?
elif command -v pwsh >/dev/null 2>&1; then
    pwsh -File scripts/verify/verify-all.ps1
    exit $?
else
    bash scripts/verify/verify-all.sh
    exit $?
fi
'@

try {
    [System.IO.File]::WriteAllText($preCommitPath, ($hookContent -replace "`r`n", "`n"), [System.Text.Encoding]::UTF8)
    Write-Host "[OK] Pre-commit hook successfully installed at: $preCommitPath" -ForegroundColor Green
    Write-Host "     All future commits will automatically validate integrity, links, and secrets." -ForegroundColor Cyan
} catch {
    Write-Host "[WARN] Could not write to .git/hooks/pre-commit: $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host "       If running inside a sandboxed terminal, run this script with elevated/bypass permissions." -ForegroundColor Yellow
}
