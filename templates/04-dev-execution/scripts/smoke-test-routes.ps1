# smoke-test-routes.ps1 — Automated HTTP Route Smoke Test
# Usage: powershell -File scripts/smoke-test-routes.ps1 [-BaseUrl http://localhost:3000]

param(
    [string]$BaseUrl = "http://localhost:3000"
)

$ErrorActionPreference = "Continue"

$SitemapPath = "docs/specs/SITEMAP.md"
if (-not (Test-Path $SitemapPath)) {
    if (Test-Path "SITEMAP.md") { $SitemapPath = "SITEMAP.md" }
}

Write-Host "=== HTTP Route Smoke Test ($BaseUrl) ===" -ForegroundColor Cyan

$routes = @()
if (Test-Path $SitemapPath) {
    $lines = Get-Content $SitemapPath
    foreach ($line in $lines) {
        if ($line -match "\|\s*(/[a-zA-Z0-9_\-/:*]+)\s*\|") {
            $rawRoute = $matches[1].Trim()
            # Replace dynamic params like :id or :token with test dummies
            $testRoute = $rawRoute -replace ":id", "test-id" -replace ":token", "test-token"
            if ($routes -notcontains $testRoute) {
                $routes += $testRoute
            }
        }
    }
}

if ($routes.Count -eq 0) {
    $routes = @("/", "/login", "/dashboard")
}

$failedCount = 0
$passedCount = 0

foreach ($route in $routes) {
    $targetUrl = "$BaseUrl$route"
    try {
        $response = Invoke-WebRequest -Uri $targetUrl -UseBasicParsing -TimeoutSec 5 -MaximumRedirection 0 -ErrorAction SilentlyContinue
        $statusCode = [int]$response.StatusCode
    } catch {
        if ($_.Exception.Response) {
            $statusCode = [int]$_.Exception.Response.StatusCode
        } else {
            $statusCode = 0
        }
    }

    if ($statusCode -eq 200 -or $statusCode -eq 307 -or $statusCode -eq 302) {
        Write-Host "  [PASS] ($statusCode) $route" -ForegroundColor Green
        $passedCount++
    } elseif ($statusCode -eq 404) {
        Write-Host "  [FAIL 404 NOT FOUND] $route" -ForegroundColor Red
        $failedCount++
    } else {
        Write-Host "  [WARN $statusCode] $route" -ForegroundColor Yellow
        if ($statusCode -ge 500 -or $statusCode -eq 0) {
            $failedCount++
        } else {
            $passedCount++
        }
    }
}

Write-Host ""
Write-Host "Route Smoke Test Summary: $passedCount Passed, $failedCount Failed" -ForegroundColor Cyan

if ($failedCount -gt 0) {
    Write-Host "❌ Smoke test failed: $failedCount route(s) returned 404 or server error!" -ForegroundColor Red
    exit 1
} else {
    Write-Host "✅ All routes resolved successfully without 404 errors!" -ForegroundColor Green
    exit 0
}
