# build-clean-release.ps1 - Build a clean release (Model B: release-branch squash)
# Usage:
#   .\scripts\release\build-clean-release.ps1 -Version v1.0.1 [-Base dev] [-Target main] [-KeepBranch]
#
# Workflow (produces a main branch whose history contains ONLY code changes,
# never any `git rm` of harness/docs):
#   1. Create release/<version> from the dev base branch.
#   2. Strip every path in release-exclude.txt ON THE RELEASE BRANCH (own commit).
#   3. Squash-merge the release branch into the target branch (main) and commit.
#   4. Verify the target tree tracks none of the excluded paths; abort if any leaked.
#   5. Delete the release branch (unless -KeepBranch) and print push/tag steps.
# Never pushes automatically.

param(
    [Parameter(Mandatory = $true)]
    [string]$Version,
    [string]$Base = "dev",
    [string]$Target = "main",
    [switch]$KeepBranch
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

# Read exclusion list into an array up front (paths may be removed mid-run).
$excludes = Get-Content $ExcludeFile |
    Where-Object { $_ -and ($_ -notmatch '^\s*#') } |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -ne "" }

$ReleaseBranch = "release/$Version"
Write-Host "=== Building clean release $Version (release-branch squash) ===" -ForegroundColor Cyan
Write-Host "Base branch   : $Base"
Write-Host "Target branch : $Target"
Write-Host "Exclude list  : $ExcludeFile"
Write-Host "-----------------------------------------------------------"

# 1. Create release branch from base
git checkout $Base
git checkout -B $ReleaseBranch

# 2. Strip excluded paths ON THE RELEASE BRANCH (so the target history stays clean)
$stripped = 0
foreach ($path in $excludes) {
    if (Test-Tracked $path) {
        git rm -r --quiet $path
        Write-Host "  stripped: $path"
        $stripped++
    }
}
Write-Host "  stripped $stripped path(s) on $ReleaseBranch"

if ($stripped -gt 0) {
    git commit -m "chore(release): strip dev-only artifacts for $Version"
}

# 3. Squash-merge into target and commit one release commit
git checkout $Target
# --allow-unrelated-histories: tolerate an orphan target (clean 1-commit main).
git merge --squash --allow-unrelated-histories $ReleaseBranch
git commit -m "release: $Version"

# 4. Verify target tracks none of the excluded paths
$leaked = 0
foreach ($path in $excludes) {
    if (Test-Tracked $path) {
        Write-Host "[ERROR] LEAK: $path is still tracked on $Target" -ForegroundColor Red
        $leaked++
    }
}

if ($leaked -gt 0) {
    Write-Host "[ERROR] Release aborted: $leaked excluded path(s) leaked onto $Target." -ForegroundColor Red
    exit 1
}

# 5. Delete release branch (unless requested to keep it)
if (-not $KeepBranch) {
    git branch -D $ReleaseBranch | Out-Null
    Write-Host "  deleted branch $ReleaseBranch"
}

$short = git rev-parse --short HEAD
Write-Host "-----------------------------------------------------------"
Write-Host "[OK] Clean release commit created on '$Target' ($short)" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps (run manually):"
Write-Host "  git push origin $Target"
Write-Host "  git tag -a $Version -m `"Release $Version`""
Write-Host "  git push origin $Version"
if ($KeepBranch) {
    Write-Host "  git push origin $ReleaseBranch"
    Write-Host "  # Open PR: $ReleaseBranch -> $Target"
}
