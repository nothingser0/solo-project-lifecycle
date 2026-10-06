# Framework Version Gate - M06 Step 1.5
# Enforces exact resolved versions match FSD locked versions

$ErrorActionPreference = "Stop"

$FSD_FILE = "docs/specs/FSD.md"

Write-Host "`n[INFO] Framework Version Gate Check..." -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $FSD_FILE)) {
    Write-Host "[ERROR] FSD.md not found" -ForegroundColor Red
    exit 1
}

function Extract-FsdVersion {
    param($Package)
    
    $fsdContent = Get-Content $FSD_FILE -Raw
    $versionsSection = ($fsdContent -split 'Framework Versions \(Pinned\):')[1]
    if ($versionsSection) {
        $versionsSection = ($versionsSection -split "`n`n")[0]
        $line = $versionsSection -split "`n" | Where-Object { $_ -match "^- ${Package}:" } | Select-Object -First 1
        if ($line) {
            return ($line -split ": ")[1].Trim()
        }
    }
    return $null
}

$fsdContent = Get-Content $FSD_FILE -Raw
$stackMatch = [regex]::Match($fsdContent, 'Stack Decision LOCKED:\s*(.+?)(\r?\n|$)')
$stack = ($stackMatch.Groups[1].Value.Trim() -split ' ')[0]

Write-Host "[INFO] FSD Stack: $stack"
Write-Host ""

switch ($stack) {
    { $_ -in "Next.js", "Nextjs", "next.js" } {
        $fsdNext = Extract-FsdVersion "Next.js"
        if (-not $fsdNext) { $fsdNext = Extract-FsdVersion "next" }
        $fsdReact = Extract-FsdVersion "React"
        if (-not $fsdReact) { $fsdReact = Extract-FsdVersion "react" }
        
        if (-not $fsdNext) {
            Write-Host "[ERROR] FSD missing 'Next.js: X.Y.Z'" -ForegroundColor Red
            exit 1
        }
        
        $resolvedNext = $null
        $resolvedReact = $null
        
        if (Test-Path "package-lock.json") {
            $lockData = Get-Content "package-lock.json" | ConvertFrom-Json
            $resolvedNext = $lockData.packages.'node_modules/next'.version
            $resolvedReact = $lockData.packages.'node_modules/react'.version
        } elseif (Test-Path "pnpm-lock.yaml") {
            $nextLine = Get-Content "pnpm-lock.yaml" | Select-String "next@" | Select-Object -First 1
            if ($nextLine) {
                $resolvedNext = ($nextLine -replace '.*next@', '' -split ':')[0]
            }
            $reactLine = Get-Content "pnpm-lock.yaml" | Select-String "^\s+react@" | Select-Object -First 1
            if ($reactLine) {
                $resolvedReact = ($reactLine -replace '.*react@', '' -split ':')[0]
            }
        } else {
            Write-Host "[ERROR] No lockfile found (package-lock.json or pnpm-lock.yaml required)" -ForegroundColor Red
            exit 1
        }
        
        if (-not $resolvedNext) {
            Write-Host "[ERROR] next not resolved in lockfile" -ForegroundColor Red
            exit 1
        }
        
        $fsdMajorMinor = ($fsdNext -split '\.')[0..1] -join '.'
        $resolvedMajorMinor = ($resolvedNext -split '\.')[0..1] -join '.'
        
        if ($resolvedMajorMinor -ne $fsdMajorMinor) {
            Write-Host "[ERROR] VERSION MISMATCH" -ForegroundColor Red
            Write-Host "FSD:      next@$fsdNext"
            Write-Host "Resolved: next@$resolvedNext"
            Write-Host ""
            Write-Host "Fix: npm install next@$fsdNext"
            if ($fsdReact) {
                Write-Host "     npm install react@$fsdReact react-dom@$fsdReact"
            }
            exit 1
        }
        
        if ($fsdReact -and $resolvedReact) {
            $fsdReactMM = ($fsdReact -split '\.')[0..1] -join '.'
            $resolvedReactMM = ($resolvedReact -split '\.')[0..1] -join '.'
            
            if ($resolvedReactMM -ne $fsdReactMM) {
                Write-Host "[ERROR] React version mismatch" -ForegroundColor Red
                Write-Host "FSD:      react@$fsdReact"
                Write-Host "Resolved: react@$resolvedReact"
                Write-Host ""
                Write-Host "Fix: npm install react@$fsdReact react-dom@$fsdReact"
                exit 1
            }
        }

        Write-Host "[OK] next@$resolvedNext matches FSD" -ForegroundColor Green
        if ($resolvedReact) {
            Write-Host "[OK] react@$resolvedReact matches FSD" -ForegroundColor Green
        }
    }
    
    "Laravel" {
        $fsdLaravel = Extract-FsdVersion "Laravel"
        if (-not $fsdLaravel) { $fsdLaravel = Extract-FsdVersion "laravel/framework" }
        
        if (-not $fsdLaravel) {
            Write-Host "[ERROR] FSD missing 'Laravel: X.Y'" -ForegroundColor Red
            exit 1
        }
        
        if (-not (Test-Path "composer.lock")) {
            Write-Host "[ERROR] No composer.lock found" -ForegroundColor Red
            exit 1
        }
        
        $lockData = Get-Content "composer.lock" | ConvertFrom-Json
        $laravelPkg = $lockData.packages | Where-Object { $_.name -eq "laravel/framework" } | Select-Object -First 1
        $resolved = $laravelPkg.version
        
        if (-not $resolved) {
            Write-Host "[ERROR] laravel/framework not in composer.lock" -ForegroundColor Red
            exit 1
        }
        
        $fsdMajor = ($fsdLaravel -replace '^v', '' -split '\.')[0]
        $resolvedMajor = ($resolved -replace '^v', '' -split '\.')[0]
        $fsdMM = ($fsdLaravel -replace '^v', '' -split '\.')[0..1] -join '.'
        $resolvedMM = ($resolved -replace '^v', '' -split '\.')[0..1] -join '.'
        
        if ($resolvedMM -ne $fsdMM) {
            Write-Host "[ERROR] VERSION MISMATCH" -ForegroundColor Red
            Write-Host "FSD:      laravel/framework@$fsdLaravel"
            Write-Host "Resolved: laravel/framework@$resolved"
            Write-Host ""
            Write-Host "Fix: composer require laravel/framework:$fsdLaravel"
            exit 1
        }

        Write-Host "[OK] laravel/framework@$resolved matches FSD" -ForegroundColor Green
    }
    
    "Django" {
        $fsdDjango = Extract-FsdVersion "Django"
        
        if (-not $fsdDjango) {
            Write-Host "[ERROR] FSD missing 'Django: X.Y.Z'" -ForegroundColor Red
            exit 1
        }
        
        if (-not (Test-Path "requirements.txt")) {
            Write-Host "[ERROR] No requirements.txt found" -ForegroundColor Red
            exit 1
        }
        
        $djangoLine = Get-Content "requirements.txt" | Select-String "^Django==" | Select-Object -First 1
        
        if (-not $djangoLine) {
            Write-Host "[ERROR] Django not in requirements.txt" -ForegroundColor Red
            exit 1
        }
        
        $resolved = ($djangoLine -split "==")[1]
        $fsdMajor = ($fsdDjango -split '\.')[0]
        $resolvedMajor = ($resolved -split '\.')[0]
        $fsdMM = ($fsdDjango -split '\.')[0..1] -join '.'
        $resolvedMM = ($resolved -split '\.')[0..1] -join '.'
        
        if ($resolvedMM -ne $fsdMM) {
            Write-Host "[ERROR] VERSION MISMATCH" -ForegroundColor Red
            Write-Host "FSD:      Django==$fsdDjango"
            Write-Host "Resolved: Django==$resolved"
            Write-Host ""
            Write-Host "Fix: pip install django==$fsdDjango"
            exit 1
        }

        Write-Host "[OK] Django==$resolved matches FSD" -ForegroundColor Green
    }
    
    "Go" {
        $fsdGo = Extract-FsdVersion "Go"
        
        if (-not $fsdGo) {
            Write-Host "[ERROR] FSD missing 'Go: X.Y'" -ForegroundColor Red
            exit 1
        }
        
        if (-not (Test-Path "go.mod")) {
            Write-Host "[ERROR] No go.mod found" -ForegroundColor Red
            exit 1
        }
        
        $goLine = Get-Content "go.mod" | Select-String "^go " | Select-Object -First 1
        
        if (-not $goLine) {
            Write-Host "[ERROR] Go version not in go.mod" -ForegroundColor Red
            exit 1
        }
        
        $resolved = ($goLine -split " ")[1]
        
        $fsdGoMM = ($fsdGo -split '\.')[0..1] -join '.'
        $resolvedGoMM = ($resolved -split '\.')[0..1] -join '.'
        if ($resolvedGoMM -ne $fsdGoMM) {
            Write-Host "[ERROR] VERSION MISMATCH" -ForegroundColor Red
            Write-Host "FSD:      go $fsdGo"
            Write-Host "Resolved: go $resolved"
            exit 1
        }

        Write-Host "[OK] go $resolved matches FSD" -ForegroundColor Green
    }
    
    default {
        Write-Host "[ERROR] Unknown stack: $stack" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "[OK] Version gate PASSED" -ForegroundColor Green
