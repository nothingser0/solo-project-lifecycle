# build-dist.ps1 - Package framework for distribution and skill upload
# Usage: .\scripts\build-dist.ps1

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir = Split-Path -Parent (Split-Path -Parent $scriptDir)
$distDir = Join-Path $rootDir "dist"
$pkgDir = Join-Path $distDir "package"

Write-Host "=== Building Distribution Package ===" -ForegroundColor Cyan
Write-Host "Target directory: $distDir"

if (Test-Path $distDir) {
    Remove-Item -Recurse -Force $distDir
}
New-Item -ItemType Directory -Force -Path $pkgDir | Out-Null

Copy-Item (Join-Path $rootDir "SKILL.md") $pkgDir
Copy-Item (Join-Path $rootDir "README.md") $pkgDir

foreach ($dir in @("docs", "templates", "patterns", "references", "scripts")) {
    $src = Join-Path $rootDir $dir
    if (Test-Path $src) {
        Write-Host "Copying $dir/..."
        Copy-Item -Recurse $src (Join-Path $pkgDir $dir)
    }
}

$zipPath = Join-Path $distDir "solo-project-lifecycle.zip"
Write-Host "Creating ZIP bundle..."
Compress-Archive -Path "$pkgDir\*" -DestinationPath $zipPath -Force
Write-Host "✅ ZIP bundle created: dist\solo-project-lifecycle.zip" -ForegroundColor Green

$allDist = Get-ChildItem -Path $pkgDir -Recurse -File
$distBytes = ($allDist | Measure-Object -Property Length -Sum).Sum
$distMB = [Math]::Round($distBytes / 1MB, 2)

Write-Host ""
Write-Host "Distribution Build Summary:"
Write-Host "  * Package directory: dist\package\ (Root SKILL.md ready for skill install)"
Write-Host "  * Total files      : $($allDist.Count)"
Write-Host "  * Uncompressed size: $distMB MB"
Write-Host "✅ Build completed successfully." -ForegroundColor Green
