# Auto-Check Latest Package Versions
# Run before scaffold to verify current ecosystem state

param(
    [string]$Framework = "nextjs"
)

Write-Host "=== Package Version Auto-Check ===" -ForegroundColor Cyan
Write-Host ""

function Check-Package {
    param($Name, $ExpectedMajor = $null)
    
    Write-Host "Checking $Name..." -NoNewline
    
    try {
        $latest = (npm view $Name version 2>$null)
        $deprecated = (npm view $Name deprecated 2>$null)
        
        if ($deprecated) {
            Write-Host " DEPRECATED" -ForegroundColor Red
            Write-Host "  Reason: $deprecated" -ForegroundColor Yellow
            return $false
        }
        
        $latestMajor = $latest.Split('.')[0]
        
        if ($ExpectedMajor -and $latestMajor -ne $ExpectedMajor) {
            Write-Host " v$latest (MISMATCH: expected v$ExpectedMajor)" -ForegroundColor Yellow
            return $false
        }
        
        Write-Host " v$latest" -ForegroundColor Green
        return @{
            version = $latest
            major = $latestMajor
        }
    }
    catch {
        Write-Host " FAILED" -ForegroundColor Red
        return $false
    }
}

# Framework-specific checks
switch ($Framework) {
    "nextjs" {
        Write-Host "Framework: Next.js" -ForegroundColor Cyan
        Write-Host ""
        
        $next = Check-Package "next"
        $react = Check-Package "react"
        $reactDom = Check-Package "react-dom"
        $typesReact = Check-Package "@types/react"
        $tailwind = Check-Package "tailwindcss"
        $zod = Check-Package "zod"
        $hookForm = Check-Package "react-hook-form"
        $resolvers = Check-Package "@hookform/resolvers"
        $eslintNext = Check-Package "eslint-config-next"
        
        Write-Host ""
        Write-Host "=== Compatibility Analysis ===" -ForegroundColor Cyan
        Write-Host ""
        
        # Check Next.js ecosystem
        if ($next.major -eq "15") {
            if ($react.major -ne "19" -and $react.major -ne "18") {
                Write-Host "⚠ Next.js 15 requires React 19 or 18 (found React $($react.major))" -ForegroundColor Yellow
            } else {
                Write-Host "✓ Next.js + React compatible" -ForegroundColor Green
            }
            
            if ($typesReact.major -ne $react.major) {
                Write-Host "⚠ @types/react should match React major version" -ForegroundColor Yellow
            }
            
            if ($eslintNext.major -ne $next.major) {
                Write-Host "⚠ eslint-config-next should match Next.js major version" -ForegroundColor Yellow
            }
        }
        
        # Check form validation stack
        if ($zod.major -eq "4") {
            Write-Host "⚠ Zod v4 incompatible with react-hook-form ecosystem" -ForegroundColor Yellow
            Write-Host "  Recommendation: Use Zod v3.x" -ForegroundColor Yellow
        }
        
        if ($zod.major -eq "3" -and $resolvers.major -ne "3") {
            Write-Host "⚠ @hookform/resolvers v3 required for Zod v3" -ForegroundColor Yellow
        }
        
        if ($tailwind.major -eq "4") {
            Write-Host "⚠ Tailwind v4 has breaking config changes" -ForegroundColor Yellow
            Write-Host "  Recommendation: Use v3.x for stability" -ForegroundColor Yellow
        }
        
        Write-Host ""
        Write-Host "=== Recommended Versions ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Scaffold command:"
        Write-Host "  npx create-next-app@$($next.major) my-app" -ForegroundColor White
        Write-Host ""
        Write-Host "Dependencies:"
        Write-Host "  pnpm add zod@^3.23.8" -ForegroundColor White
        Write-Host "  pnpm add @hookform/resolvers@^3.9.1" -ForegroundColor White
        Write-Host "  pnpm add react-hook-form@latest" -ForegroundColor White
        
        if ($tailwind.major -eq "4") {
            Write-Host "  pnpm add -D tailwindcss@^3.4.0" -ForegroundColor White
        }
    }
    
    "laravel" {
        Write-Host "Framework: Laravel" -ForegroundColor Cyan
        # Add Laravel checks
    }
}

Write-Host ""
Write-Host "Run this script before M05 (Tech Stack Decision) to verify current ecosystem state." -ForegroundColor Gray
