# build-clean-release.ps1 - Build a clean release branch (Model B: squash merge)
# Usage:
#   .\scripts\release\build-clean-release.ps1 -Version v1.0.1 [-Base dev] [-Target main]
#
# What it does (Model B, squash merge, PR-friendly):
#   1. Creates release/<version> branch from the base branch.
#   2. Squash-merges it into the target branch (default: main) WITHOUT committing.
#   3. Removes every path listed in scripts/release/release-exclude.txt from the index.
#   4. Commits a single clean release commit.
#   5. Verifies no excluded path remains tracked; aborts if any leaked.
#   6. Prints the PR/push commands. Never pushes automatically.

param(
    [Parameter(Mandatory = $true)]
    [string]$Version,
    [string]$Base = "dev",
    [string]$Target = "main"
)

$ErrorActionPreference = "Stop"

# Native git writes to stderr when a pathspec is untracked; with
# $ErrorActionPreference='Stop' that raises NativeCommandError and kills the
# script. This helper isolates the check and returns a clean boolean.
function Test-Tracked([string]$Path) {
    $prev = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    git ls-files --error-unmatch -- $Path 2>$null | Out-Null
    $code = $LASTEXITCODE
    $ErrorActionPreference = $prev
    return ($code -eq 0)
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = (Resolve-Path (Join-Path $ScriptDir "..\..")).Path
$ExcludeFile = Join-Path $ScriptDir "release-exclude.txt"

if (-not (Test-Path $ExcludeFile)) {
    Write-Host "[ERROR] Missing exclusion list: $ExcludeFile" -ForegroundColor Red
    exit 1
}

Set-Location $RootDir

if ((git status --porcelain)) {
    Write-Host "[ERROR] Working tree is dirty. Commit or stash your changes first." -ForegroundColor Red
    exit 1
}

$ReleaseBranch = "release/$Version"
Write-Host "=== Building clean release $Version (squash model) ===" -ForegroundColor Cyan
Write-Host "Base branch   : $Base"
Write-Host "Target branch : $Target"
Write-Host "Exclude list  : $ExcludeFile"
Write-Host "-----------------------------------------------------------"

# 1. Create release branch from base
git checkout $Base
git checkout -B $ReleaseBranch

# 2. Squash-merge into target (no commit yet)
git checkout $Target
# --allow-unrelated-histories: tolerate a target branch that started as an orphan
# (e.g. a clean 1-commit main with no shared ancestry with the dev base).
git merge --squash --allow-unrelated-histories $ReleaseBranch

# Parse exclusion list (skip blanks/comments)
$excludes = Get-Content $ExcludeFile |
    Where-Object { $_ -and ($_ -notmatch '^\s*#') } |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -ne "" }

# 3. Strip excluded paths from the index
$stripped = 0
foreach ($path in $excludes) {
    if (Test-Tracked $path) {
        git rm -r --cached --quiet $path
        Write-Host "  removed: $path"
        $stripped++
    }
}
Write-Host "  stripped $stripped path(s) from index"

# 4. Commit single clean release commit
git commit -m "release: $Version"

# 5. Verify nothing excluded leaked into the commit
$leaked = 0
foreach ($path in $excludes) {
    if (Test-Tracked $path) {
        Write-Host "[ERROR] LEAK: $path is still tracked on $Target" -ForegroundColor Red
        $leaked++
    }
}

if ($leaked -gt 0) {
    Write-Host "[ERROR] Release aborted: $leaked excluded path(s) leaked." -ForegroundColor Red
    exit 1
}

$short = git rev-parse --short HEAD
Write-Host "-----------------------------------------------------------"
Write-Host "[OK] Clean release commit created on '$Target' ($short)" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps (run manually):"
Write-Host "  git push origin $Target"
Write-Host "  git push origin $ReleaseBranch"
Write-Host "  # Optional PR: open PR from $ReleaseBranch into $Target"
