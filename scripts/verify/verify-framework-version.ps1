# Framework Version Gate - M06 Step 1.5
# Enforces exact resolved versions match FSD locked versions

$ErrorActionPreference = "Stop"

$FSD_FILE = "docs/specs/FSD.md"
$LITE_FILE = "PROJECT_LITE.md"

Write-Host "`n[INFO] Framework Version Gate Check..." -ForegroundColor Cyan
Write-Host ""

if (Test-Path $FSD_FILE) {
    $TARGET_FILE = $FSD_FILE
} elseif (Test-Path $LITE_FILE) {
    $TARGET_FILE = $LITE_FILE
    Write-Host "[INFO] Fast-Track mode detected: Using PROJECT_LITE.md instead of FSD.md" -ForegroundColor Yellow
} else {
    Write-Host "[ERROR] Neither docs/specs/FSD.md nor PROJECT_LITE.md found" -ForegroundColor Red
    exit 1
}

function Extract-FsdVersion {
    param($Package)

    # The pinned-version section is written in two accepted shapes and BOTH must
    # parse, because the shipped templates use the first one:
    #   - **Framework**: Next.js ^15.0.3 (App Router)   <- FSD_TECHNICAL_TEMPLATE.md
    #   - Next.js: 15.0.3                               <- bare form
    # The old body anchored on "^- <pkg>:" only, so a template-faithful FSD (stack
    # name in the VALUE) failed its own gate and M06 STEP 3 could never pass.
    # Take the section body, keep lines naming the package, pull the first version.
    $fsdContent = Get-Content $TARGET_FILE -Raw
    $versionsSection = ($fsdContent -split 'Framework Versions \(Pinned\)')[1]
    if ($versionsSection) {
        $body = ($versionsSection -split "(?m)^#{2,6}\s")[0]
        $line = $body -split "`n" | Where-Object { $_ -imatch [regex]::Escape($Package) } | Select-Object -First 1
        if ($line -and ($line -match 'v?[0-9]+(\.[0-9]+)+')) {
            return $Matches[0].TrimStart('v')
        }
    }
    return $null
}

# Scaffold-type guard + Tailwind major detection (parity with the .sh twin).
function Assert-ScaffoldType {
    param($Want, $Manifest, $WrongManifest, $WrongLabel)
    if (-not (Test-Path $Manifest)) {
        Write-Host "[ERROR] FSD declares $Want, but $Manifest is missing - wrong or absent scaffold." -ForegroundColor Red
        exit 1
    }
    if ($WrongManifest -and (Test-Path $WrongManifest)) {
        Write-Host "[ERROR] FSD declares $Want, but the repo looks like $WrongLabel (conflicting manifest present)." -ForegroundColor Red
        exit 1
    }
    Write-Host "[OK] scaffold manifest matches the locked stack ($Want)" -ForegroundColor Green
}

function Test-Tailwind {
    if (-not (Test-Path "package.json")) { return }
    $pkg = Get-Content "package.json" -Raw
    if ($pkg -match '"tailwindcss"\s*:\s*"\D*([0-9]+)') {
        $tw = [int]$Matches[1]
        if ($tw -ge 4) {
            Write-Host "[INFO] Tailwind v4 detected - CSS-first config (no tailwind.config.js). AGENTS.md / CONVENTIONS.md must use v4 syntax." -ForegroundColor Yellow
        } else {
            Write-Host "[OK] Tailwind v$tw detected (JS config expected)" -ForegroundColor Green
        }
    }
}

$fsdContent = Get-Content $TARGET_FILE -Raw
$stackMatch = [regex]::Match($fsdContent, 'Stack Decision LOCKED:\s*(.+?)(\r?\n|$)')
$stack = ($stackMatch.Groups[1].Value.Trim() -split ' ')[0]

Write-Host "[INFO] FSD Stack: $stack"
Write-Host ""

switch ($stack) {
    { $_ -in "Next.js", "Nextjs", "next.js" } {
        Assert-ScaffoldType "Next.js" "package.json" "composer.json" "Laravel/PHP"
        Test-Tailwind
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
        Assert-ScaffoldType "Laravel" "composer.json" "manage.py" "Django/Python"
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
        Assert-ScaffoldType "Django" "manage.py" "composer.json" "Laravel/PHP"
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
        Assert-ScaffoldType "Go" "go.mod" "package.json" "a JS framework"
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
