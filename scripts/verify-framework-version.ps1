# Framework Version Gate - M06 Step 0.5
# Enforces FSD locked version matches installed framework version

$ErrorActionPreference = "Stop"

$FSD_FILE = "docs/specs/FSD.md"

Write-Host "`n🔍 Framework Version Gate Check..." -ForegroundColor Cyan
Write-Host ""

# Check FSD exists
if (-not (Test-Path $FSD_FILE)) {
    Write-Host "❌ GATE FAILED: FSD.md not found" -ForegroundColor Red
    Write-Host "FSD.md required from M05. Run Module 05 first."
    exit 1
}

# Extract locked stack
$fsdContent = Get-Content $FSD_FILE -Raw
$stackMatch = [regex]::Match($fsdContent, "Stack Decision LOCKED:\s*(.+?)(\r?\n|$)")

if (-not $stackMatch.Success) {
    Write-Host "❌ GATE FAILED: No locked stack decision in FSD.md" -ForegroundColor Red
    Write-Host "Expected format: 'Stack Decision LOCKED: Next.js 15'"
    exit 1
}

$stack = $stackMatch.Groups[1].Value.Trim()
Write-Host "📋 FSD Locked Stack: $stack"

# Version validation by stack
switch -Wildcard ($stack) {
    "Next.js 15*" {
        $expectedMajor = "15"
        
        if (Test-Path "package.json") {
            $packageJson = Get-Content "package.json" | ConvertFrom-Json
            $installed = $packageJson.dependencies.next
            
            if (-not $installed) {
                Write-Host "⚠️  Next.js not installed yet (scaffold pending)" -ForegroundColor Yellow
                Write-Host "✅ Gate passed - will validate after scaffold"
                exit 0
            }
            
            $installedMajor = ($installed -replace '[\^~]', '') -split '\.' | Select-Object -First 1
            
            if ($installedMajor -ne $expectedMajor) {
                Write-Host ""
                Write-Host "❌ VERSION MISMATCH DETECTED" -ForegroundColor Red
                Write-Host ""
                Write-Host "FSD Locked:  Next.js $expectedMajor.x"
                Write-Host "Installed:   Next.js $installedMajor.x ($installed)"
                Write-Host ""
                
                if ($installedMajor -eq "16") {
                    Write-Host "Next.js 16 Breaking Changes:"
                    Write-Host "  - middleware.ts → proxy.ts"
                    Write-Host "  - Sync request APIs removed (cookies(), headers())"
                    Write-Host "  - Cache behavior changed"
                    Write-Host ""
                    Write-Host "SOLUTIONS:"
                    Write-Host "  1. Downgrade to match FSD:"
                    Write-Host "     npm install next@15.0.3 react@19.0.0"
                    Write-Host ""
                    Write-Host "  2. Update FSD to Next.js 16 (if harness available):"
                    Write-Host "     Check: templates/04-dev-execution/nextjs-16/"
                    Write-Host ""
                    Write-Host "  3. Manual migration:"
                    Write-Host "     Run: npx @next/codemod@16 middleware-to-proxy ."
                }
                
                exit 1
            }
            
            Write-Host "✅ Next.js version: $installed (matches FSD)" -ForegroundColor Green
        }
    }
    
    "Laravel 11*" {
        $expectedMajor = "11"
        
        if (Test-Path "composer.json") {
            $composerJson = Get-Content "composer.json" | ConvertFrom-Json
            $installed = $composerJson.require.'laravel/framework'
            
            if (-not $installed) {
                Write-Host "⚠️  Laravel not installed yet" -ForegroundColor Yellow
                exit 0
            }
            
            $installedMajor = ($installed -replace '[\^~]', '') -split '\.' | Select-Object -First 1
            
            if ($installedMajor -ne $expectedMajor) {
                Write-Host "❌ VERSION MISMATCH" -ForegroundColor Red
                Write-Host "FSD Locked:  Laravel $expectedMajor.x"
                Write-Host "Installed:   Laravel $installedMajor.x ($installed)"
                exit 1
            }
            
            Write-Host "✅ Laravel version: $installed" -ForegroundColor Green
        }
    }
    
    "Django 5*" {
        $expectedMajor = "5"
        
        if (Test-Path "requirements.txt") {
            $djangoLine = Get-Content "requirements.txt" | Where-Object { $_ -match "^Django==" }
            
            if ($djangoLine) {
                $installed = ($djangoLine -split "==")[1]
                $installedMajor = ($installed -split '\.')[0]
                
                if ($installedMajor -ne $expectedMajor) {
                    Write-Host "❌ VERSION MISMATCH" -ForegroundColor Red
                    Write-Host "FSD Locked:  Django $expectedMajor.x"
                    Write-Host "Installed:   Django $installedMajor.x ($installed)"
                    exit 1
                }
                
                Write-Host "✅ Django version: $installed" -ForegroundColor Green
            } else {
                Write-Host "⚠️  Django not installed yet" -ForegroundColor Yellow
                exit 0
            }
        }
    }
    
    "Go 1.23*" {
        $expected = "1.23"
        
        if (Test-Path "go.mod") {
            $goModContent = Get-Content "go.mod"
            $goLine = $goModContent | Where-Object { $_ -match "^go " }
            
            if ($goLine) {
                $installed = ($goLine -split " ")[1]
                
                if (-not $installed.StartsWith($expected)) {
                    Write-Host "❌ VERSION MISMATCH" -ForegroundColor Red
                    Write-Host "FSD Locked:  Go $expected.x"
                    Write-Host "Installed:   Go $installed"
                    exit 1
                }
                
                Write-Host "✅ Go version: $installed" -ForegroundColor Green
            } else {
                Write-Host "⚠️  Go version not specified in go.mod" -ForegroundColor Yellow
                exit 0
            }
        }
    }
    
    default {
        Write-Host "⚠️  Unknown stack: $stack" -ForegroundColor Yellow
        Write-Host "Supported: Next.js 15, Laravel 11, Django 5, Go 1.23"
        Write-Host "Skipping version validation"
        exit 0
    }
}

Write-Host ""
Write-Host "✅ Framework version gate PASSED" -ForegroundColor Green
Write-Host "Proceeding to development..."
