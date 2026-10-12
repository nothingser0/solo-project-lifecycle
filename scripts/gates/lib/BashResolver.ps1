# BashResolver.ps1 -- shared, dot-sourced helper for PowerShell wrappers that
# delegate to a .sh implementation (single source of gate/classifier logic).
#
# Why this exists: `Get-Command bash` on Windows usually resolves to
# C:\Windows\System32\bash.exe, which is the WSL LAUNCHER, not a shell. With no
# distribution installed it prints "Windows Subsystem for Linux has no installed
# distributions" and exits 1 -- indistinguishable from a genuine checker failure.
# Git for Windows ships a real bash at a predictable path; prefer it.
#
# Dot-source from a wrapper:
#   . (Join-Path $PSScriptRoot "lib\BashResolver.ps1")
#   $bash = Resolve-Bash
#   if (-not $bash) { ... exit 2 }

function Resolve-Bash {
    [CmdletBinding()]
    param()

    # Join-Path throws on a $null root, and ProgramFiles(x86) is absent on 64-bit-only
    # or ARM hosts -- build the list defensively.
    $roots = @($env:ProgramFiles, ${env:ProgramFiles(x86)}, $env:LOCALAPPDATA) |
        Where-Object { $_ -and $_.Trim() -ne "" }
    $candidates = @()
    foreach ($r in $roots) {
        $candidates += (Join-Path $r "Git\bin\bash.exe")
    }
    if ($env:LOCALAPPDATA) { $candidates += (Join-Path $env:LOCALAPPDATA "Programs\Git\bin\bash.exe") }
    foreach ($c in $candidates) {
        if ($c -and (Test-Path $c)) { return $c }
    }

    $onPath = Get-Command bash -ErrorAction SilentlyContinue
    if ($onPath) {
        $p = $onPath.Source
        if ($p -match '\\System32\\bash\.exe$') {
            # WSL launcher stub: usable only if a distribution is actually installed.
            $probe = & $p "-lc" "uname -s" 2>&1
            if ($LASTEXITCODE -eq 0 -and "$probe" -match 'Linux|Darwin') { return $p }
            return $null
        }
        return $p
    }
    return $null
}

function Write-BashMissingHelp {
    param([string]$ScriptName, [string]$UsageHint)

    Write-Host "[ERROR] No usable bash found." -ForegroundColor Red
    Write-Host ""
    Write-Host "Logic for $ScriptName lives only in its .sh implementation. Install one of:"
    Write-Host "  - Git for Windows (recommended on Windows): includes bash at"
    Write-Host "    'C:\Program Files\Git\bin\bash.exe'"
    Write-Host "  - A WSL distribution (wsl --install -d Ubuntu)"
    Write-Host "  - Git Bash / any Unix shell on Linux or macOS"
    Write-Host ""
    if ($UsageHint) { Write-Host "Usage: $UsageHint" }
    Write-Host ""
    Write-Host "Note: C:\Windows\System32\bash.exe is a WSL launcher, not a shell -- it"
    Write-Host "only works once a distribution is installed."
}

# Convert a Windows path to the forward-slash form the bash side expects.
function ConvertTo-BashPath {
    param([Parameter(Mandatory)][string]$Path)
    return ($Path -replace '\\', '/')
}

# Run a .sh script with bash, from a chosen working directory.
#   Invoke-Bash -Bash <path> -Script <path> -Arguments @(...) [-WorkingDirectory <dir>]
# The child's output streams through untouched (dialogs/evidence are the point).
# Its exit code lands in $script:LastBashExitCode -- deliberately NOT on the output
# stream, because a caller doing `exit (Invoke-Bash ...)` would otherwise collect the
# gate's whole stdout into the exit expression and print nothing.
#
# The script is invoked DIRECTLY (not through a nested `sh -c "cd ... && ..."`):
# building a shell command line containing Windows paths with spaces ("C:\Program
# Files\...") requires quote escaping that Windows PowerShell 5.1 mangles, and the
# failure surfaces as the shell trying to execute "C:/Program". Running the script
# with bash's inherited cwd has no quoting surface at all.
function Invoke-Bash {
    param(
        [Parameter(Mandatory)][string]$Bash,
        [Parameter(Mandatory)][string]$Script,
        [string[]]$Arguments = @(),
        [string]$WorkingDirectory = (Get-Location).Path
    )

    Push-Location $WorkingDirectory
    try {
        & $Bash $Script @Arguments
        $script:LastBashExitCode = $LASTEXITCODE
    } finally {
        Pop-Location
    }
}
