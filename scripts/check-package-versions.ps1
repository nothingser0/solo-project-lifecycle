# Universal Package & Framework Version Auto-Check
# Run before scaffold to verify current ecosystem state
# Queries official package registries directly via HTTP/CLI
# Covers all 14 tracked stacks in STACK_SUPPORT_MATRIX.md without local compiler dependencies

param(
    [string]$Framework = "nextjs"
)

$ErrorActionPreference = "Stop"

Write-Host "=== Universal Package Version Auto-Check ===" -ForegroundColor Cyan
Write-Host ""

function Query-RegistryJson {
    param(
        [string]$Url,
        [scriptblock]$Extractor,
        [switch]$Optional
    )

    try {
        $headers = @{ "User-Agent" = "solo-project-lifecycle/1.0" }
        $data = Invoke-RestMethod -Uri $Url -Headers $headers -TimeoutSec 10 -UseBasicParsing
        $result = & $Extractor $data
        if ([string]::IsNullOrWhiteSpace($result)) {
            if ($Optional) {
                return $null
            }
            throw "Extracted value was null or empty from $Url"
        }
        return $result
    }
    catch {
        if ($Optional) {
            return $null
        }
        Write-Host " [FAILED: $($_.Exception.Message)]" -ForegroundColor Red
        throw $_
    }
}

function Check-NpmPackage {
    param(
        [string]$Name,
        [string]$ExpectedMajor = $null
    )

    Write-Host "Checking $Name..." -NoNewline

    try {
        $latest = (npm view $Name version 2>$null)
        if (-not $latest) {
            Write-Host " NOT FOUND" -ForegroundColor Red
            throw "Package '$Name' not found on npm registry."
        }

        $deprecated = (npm view $Name deprecated 2>$null)
        if ($deprecated) {
            Write-Host " DEPRECATED: $deprecated" -ForegroundColor Yellow
        }

        $major = $latest.Split('.')[0]
        if ($ExpectedMajor -and $major -ne $ExpectedMajor) {
            Write-Host " v$latest (expected v$ExpectedMajor.x)" -ForegroundColor Yellow
        } else {
            Write-Host " v$latest" -ForegroundColor Green
        }

        return @{ latest = $latest.Trim(); major = $major.Trim() }
    }
    catch {
        Write-Host " ERROR" -ForegroundColor Red
        throw $_
    }
}

$frameworkMap = @{
    "nextjs"     = "nextjs"
    "node"       = "nextjs"
    "laravel"    = "laravel"
    "php"        = "laravel"
    "django"     = "django"
    "python"     = "django"
    "go"         = "go"
    "golang"     = "go"
    "rails"      = "rails"
    "ruby"       = "rails"
    "mern"       = "mern"
    "express"    = "mern"
    "aspnet"     = "aspnet"
    "dotnet"     = "aspnet"
    "spring"     = "spring"
    "java"       = "spring"
    "serverless" = "serverless"
    "flutter"    = "flutter"
    "dart"       = "flutter"
    "remix"      = "remix"
    "astro"      = "astro"
    "jamstack"   = "astro"
}

$fw = $Framework.ToLower().Trim()
$target = if ($frameworkMap.ContainsKey($fw)) { $frameworkMap[$fw] } else { "unsupported" }

switch ($target) {
    "nextjs" {
        Write-Host "Framework: Next.js Ecosystem (npm Registry)" -ForegroundColor Cyan
        Write-Host ""

        $next = Check-NpmPackage "next"
        $react = Check-NpmPackage "react"
        $reactDom = Check-NpmPackage "react-dom"
        $typesReact = Check-NpmPackage "@types/react"
        $tailwind = Check-NpmPackage "tailwindcss"
        $zod = Check-NpmPackage "zod"
        $hookForm = Check-NpmPackage "react-hook-form"
        $resolvers = Check-NpmPackage "@hookform/resolvers"
        $eslintNext = Check-NpmPackage "eslint-config-next"
        $supabaseSsr = Check-NpmPackage "@supabase/ssr"
        $supabaseJs = Check-NpmPackage "@supabase/supabase-js"

        Write-Host ""
        Write-Host "=== Compatibility Analysis ===" -ForegroundColor Cyan
        Write-Host ""

        if ($next.major -eq "15") {
            if ($react.major -ne "19" -and $react.major -ne "18") {
                Write-Host "Next.js 15 requires React 19 or 18 (found React $($react.major))" -ForegroundColor Yellow
            } else {
                Write-Host "Next.js 15 + React $($react.major) compatible" -ForegroundColor Green
            }
        } elseif ($next.major -eq "16") {
            Write-Host "Next.js 16 detected - verify React compatibility and App Router breaking changes" -ForegroundColor Yellow
        }

        if ($zod.major -eq "4") {
            Write-Host "Zod v4 detected - verify compatibility with @hookform/resolvers" -ForegroundColor Yellow
            Write-Host "Recommendation: Pin Zod to v3.23.8 for maximum stability" -ForegroundColor Yellow
        } elseif ($zod.major -eq "3") {
            Write-Host "Zod v3 compatible with react-hook-form ecosystem" -ForegroundColor Green
        }

        if ($tailwind.major -eq "4") {
            Write-Host "Tailwind v4 detected (breaking configuration and PostCSS changes)" -ForegroundColor Yellow
            Write-Host "Recommendation: Pin to Tailwind v3.4 for production stability if using shadcn/ui" -ForegroundColor Yellow
        }

        Write-Host ""
        Write-Host "=== Recommended Pinned Versions (for FSD.md) ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Framework: Next.js ^$($next.latest) (App Router)" -ForegroundColor White
        Write-Host "Runtime: React ^$($react.latest)" -ForegroundColor White
        if ($tailwind.major -eq "4") {
            Write-Host "Styling: Tailwind CSS ^3.4.17 (pinned)" -ForegroundColor White
        } else {
            Write-Host "Styling: Tailwind CSS ^$($tailwind.latest)" -ForegroundColor White
        }
        if ($zod.major -eq "4") {
            Write-Host "Validation: Zod ^3.23.8 (pinned) + react-hook-form" -ForegroundColor White
        } else {
            Write-Host "Validation: Zod ^$($zod.latest) + react-hook-form" -ForegroundColor White
        }
        Write-Host "Auth: Supabase (@supabase/ssr)" -ForegroundColor White
        Write-Host "Database: PostgreSQL (Supabase)" -ForegroundColor White
    }

    "sveltekit" {
        Write-Host "Framework: SvelteKit Ecosystem (npm Registry)" -ForegroundColor Cyan
        Write-Host ""
        $kit = Check-NpmPackage "@sveltejs/kit"
        $svelte = Check-NpmPackage "svelte"

        Write-Host ""
        Write-Host "=== Recommended Pinned Versions (for FSD.md) ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Framework: @sveltejs/kit ^$($kit.latest)" -ForegroundColor White
        Write-Host "Runtime: svelte ^$($svelte.latest)" -ForegroundColor White
    }

    "nuxt" {
        Write-Host "Framework: Nuxt Ecosystem (npm Registry)" -ForegroundColor Cyan
        Write-Host ""
        $nuxt = Check-NpmPackage "nuxt"
        $vue = Check-NpmPackage "vue"

        Write-Host ""
        Write-Host "=== Recommended Pinned Versions (for FSD.md) ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Framework: nuxt ^$($nuxt.latest)" -ForegroundColor White
        Write-Host "Runtime: vue ^$($vue.latest)" -ForegroundColor White
    }

    "laravel" {
        Write-Host "Framework: Laravel Ecosystem (Packagist Official API)" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Querying Packagist API for laravel/framework..." -NoNewline

        $laravelVer = Query-RegistryJson "https://repo.packagist.org/p2/laravel/framework.json" { param($d) $d.packages.'laravel/framework'[0].version }
        $phpReq = Query-RegistryJson "https://repo.packagist.org/p2/laravel/framework.json" { param($d) $d.packages.'laravel/framework'[0].require.php }
        $breezeVer = Query-RegistryJson "https://repo.packagist.org/p2/laravel/breeze.json" { param($d) $d.packages.'laravel/breeze'[0].version }
        $sanctumVer = Query-RegistryJson "https://repo.packagist.org/p2/laravel/sanctum.json" { param($d) $d.packages.'laravel/sanctum'[0].version }

        Write-Host " $laravelVer" -ForegroundColor Green
        Write-Host "Laravel Framework: $laravelVer (Requires PHP: $phpReq)" -ForegroundColor White
        Write-Host "Laravel Breeze:    $breezeVer" -ForegroundColor White
        Write-Host "Laravel Sanctum:   $sanctumVer" -ForegroundColor White

        Write-Host ""
        Write-Host "=== Compatibility Analysis ===" -ForegroundColor Cyan
        Write-Host "Query resolved directly from Packagist API (no local composer/php CLI required)" -ForegroundColor Green
        Write-Host "PHP Requirement: $phpReq" -ForegroundColor Green

        Write-Host ""
        Write-Host "=== Recommended Pinned Versions (for FSD.md) ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Framework: Laravel $laravelVer" -ForegroundColor White
        Write-Host "PHP Runtime: $phpReq" -ForegroundColor White
        Write-Host "Authentication: Laravel Breeze ($breezeVer) / Sanctum ($sanctumVer)" -ForegroundColor White
        Write-Host "Database: PostgreSQL / MySQL" -ForegroundColor White
        Write-Host "Architecture: Modular / Action-Domain-Responder (ADR)" -ForegroundColor White
    }

    "django" {
        Write-Host "Framework: Django Ecosystem (PyPI JSON API)" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Querying PyPI API for django..." -NoNewline

        $djangoVer = Query-RegistryJson "https://pypi.org/pypi/django/json" { param($d) $d.info.version }
        $pyReq = Query-RegistryJson "https://pypi.org/pypi/django/json" { param($d) $d.info.requires_python }
        $drfVer = Query-RegistryJson "https://pypi.org/pypi/djangorestframework/json" { param($d) $d.info.version }
        $psycopgVer = Query-RegistryJson "https://pypi.org/pypi/psycopg/json" { param($d) $d.info.version }

        Write-Host " v$djangoVer" -ForegroundColor Green
        Write-Host "Django:                  v$djangoVer (Requires Python: $pyReq)" -ForegroundColor White
        Write-Host "Django REST Framework:   v$drfVer" -ForegroundColor White
        Write-Host "Psycopg (PostgreSQL):    v$psycopgVer" -ForegroundColor White

        Write-Host ""
        Write-Host "=== Compatibility Analysis ===" -ForegroundColor Cyan
        Write-Host "Query resolved directly from PyPI API (no local python/pip CLI required)" -ForegroundColor Green
        Write-Host "Python Requirement: $pyReq" -ForegroundColor Green

        Write-Host ""
        Write-Host "=== Recommended Pinned Versions (for FSD.md) ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Framework: Django ^$djangoVer" -ForegroundColor White
        Write-Host "Python Runtime: $pyReq" -ForegroundColor White
        Write-Host "API Framework: Django REST Framework ^$drfVer" -ForegroundColor White
        Write-Host "Database Driver: psycopg ^$psycopgVer" -ForegroundColor White
        Write-Host "Architecture: App-per-domain / Django Service Layer" -ForegroundColor White
    }

    "go" {
        Write-Host "Framework: Go Ecosystem (Official go.dev & Module Proxy)" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Querying go.dev API for latest Go runtime..." -NoNewline

        $goVer = Query-RegistryJson "https://go.dev/dl/?mode=json" { param($d) $d[0].version }
        $ginVer = Query-RegistryJson "https://proxy.golang.org/github.com/gin-gonic/gin/@latest" { param($d) $d.Version }
        $gormVer = Query-RegistryJson "https://proxy.golang.org/gorm.io/gorm/@latest" { param($d) $d.Version }
        $pgxVer = Query-RegistryJson "https://proxy.golang.org/github.com/jackc/pgx/v5/@latest" { param($d) $d.Version }

        Write-Host " $goVer" -ForegroundColor Green
        Write-Host "Go Runtime:     $goVer" -ForegroundColor White
        Write-Host "Gin Web Engine: $ginVer" -ForegroundColor White
        Write-Host "GORM:           $gormVer" -ForegroundColor White
        Write-Host "pgx Driver:     $pgxVer" -ForegroundColor White

        Write-Host ""
        Write-Host "=== Compatibility Analysis ===" -ForegroundColor Cyan
        Write-Host "Query resolved directly from go.dev and proxy.golang.org" -ForegroundColor Green
        Write-Host "Stable Runtime: $goVer" -ForegroundColor Green

        Write-Host ""
        Write-Host "=== Recommended Pinned Versions (for FSD.md) ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Language Runtime: $goVer" -ForegroundColor White
        Write-Host "Router / Engine: Gin $ginVer" -ForegroundColor White
        Write-Host "Database Driver: pgx $pgxVer / GORM $gormVer" -ForegroundColor White
        Write-Host "Architecture: Standard Go Clean Architecture (cmd, internal, pkg)" -ForegroundColor White
    }

    "rails" {
        Write-Host "Framework: Ruby on Rails Ecosystem (RubyGems Official API)" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Querying RubyGems API for rails..." -NoNewline

        $railsVer = Query-RegistryJson "https://rubygems.org/api/v1/gems/rails.json" { param($d) $d.version }
        $pgGemVer = Query-RegistryJson "https://rubygems.org/api/v1/gems/pg.json" { param($d) $d.version }
        $pumaVer = Query-RegistryJson "https://rubygems.org/api/v1/gems/puma.json" { param($d) $d.version }

        $railsMajor = [int]($railsVer.Split('.')[0])
        $rubyReq = if ($railsMajor -ge 8) { ">= 3.2.0" } elseif ($railsMajor -ge 7) { ">= 2.7.0" } else { ">= 2.5.0" }

        Write-Host " v$railsVer" -ForegroundColor Green
        Write-Host "Rails:       v$railsVer (Required Ruby: $rubyReq)" -ForegroundColor White
        Write-Host "pg gem:      v$pgGemVer" -ForegroundColor White
        Write-Host "Puma Server: v$pumaVer" -ForegroundColor White

        Write-Host ""
        Write-Host "=== Compatibility Analysis ===" -ForegroundColor Cyan
        Write-Host "Query resolved directly from RubyGems API (no local bundler/ruby CLI required)" -ForegroundColor Green

        Write-Host ""
        Write-Host "=== Recommended Pinned Versions (for FSD.md) ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Framework: Rails ~$railsVer" -ForegroundColor White
        Write-Host "Ruby Runtime: $rubyReq" -ForegroundColor White
        Write-Host "Web Server: Puma ~$pumaVer" -ForegroundColor White
        Write-Host "Database: PostgreSQL (gem pg)" -ForegroundColor White
        Write-Host "Architecture: Rails Standard MVC + Service Objects" -ForegroundColor White
    }

    "mern" {
        Write-Host "Framework: MERN Stack (npm Registry)" -ForegroundColor Cyan
        Write-Host ""
        $express = Check-NpmPackage "express"
        $mongoose = Check-NpmPackage "mongoose"
        $cors = Check-NpmPackage "cors"
        $dotenv = Check-NpmPackage "dotenv"

        Write-Host ""
        Write-Host "=== Recommended Pinned Versions (for FSD.md) ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Backend Framework: Express ^$($express.latest)" -ForegroundColor White
        Write-Host "Database ODM: Mongoose ^$($mongoose.latest)" -ForegroundColor White
        Write-Host "Middleware: CORS ^$($cors.latest)" -ForegroundColor White
        Write-Host "Frontend: React ^19.0.0 + Vite" -ForegroundColor White
        Write-Host "Architecture: Modular REST API / Service Layer" -ForegroundColor White
    }

    "aspnet" {
        Write-Host "Framework: ASP.NET Core (.NET / NuGet API)" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Querying NuGet API for Microsoft.AspNetCore.App.Ref..." -NoNewline

        $dotnetVer = Query-RegistryJson "https://api.nuget.org/v3-flatcontainer/microsoft.aspnetcore.app.ref/index.json" {
            param($d) ($d.versions | Where-Object { $_ -notlike "*-*" })[-1]
        }
        $efcoreVer = Query-RegistryJson "https://api.nuget.org/v3-flatcontainer/microsoft.entityframeworkcore/index.json" {
            param($d) ($d.versions | Where-Object { $_ -notlike "*-*" })[-1]
        }
        $npgsqlVer = Query-RegistryJson "https://api.nuget.org/v3-flatcontainer/npgsql.entityframeworkcore.postgresql/index.json" {
            param($d) ($d.versions | Where-Object { $_ -notlike "*-*" })[-1]
        }

        Write-Host " v$dotnetVer" -ForegroundColor Green
        Write-Host ".NET Core Runtime:      v$dotnetVer" -ForegroundColor White
        Write-Host "Entity Framework Core:  v$efcoreVer" -ForegroundColor White
        Write-Host "Npgsql PostgreSQL:      v$npgsqlVer" -ForegroundColor White

        Write-Host ""
        Write-Host "=== Recommended Pinned Versions (for FSD.md) ===" -ForegroundColor Cyan
        Write-Host ""
        $dotMajor = $dotnetVer.Split('.')[0]
        Write-Host "Target Framework: net$dotMajor.0 ($dotnetVer)" -ForegroundColor White
        Write-Host "ORM: Microsoft.EntityFrameworkCore ($efcoreVer)" -ForegroundColor White
        Write-Host "Database Provider: Npgsql.EntityFrameworkCore.PostgreSQL ($npgsqlVer)" -ForegroundColor White
        Write-Host "Architecture: Clean Architecture / Controllers + MediatR" -ForegroundColor White
    }

    "spring" {
        Write-Host "Framework: Spring Boot (Maven Central API)" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Querying Spring Initializr API for Spring Boot..." -NoNewline

        $springVer = Query-RegistryJson "https://start.spring.io/actuator/info" {
            param($d) $d.build.versions.'spring-boot'
        }

        Write-Host " v$springVer" -ForegroundColor Green
        Write-Host "Spring Boot: v$springVer" -ForegroundColor White

        Write-Host ""
        Write-Host "=== Recommended Pinned Versions (for FSD.md) ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Framework: Spring Boot $springVer" -ForegroundColor White
        Write-Host "Java Runtime: Java 21 LTS (or 17 LTS)" -ForegroundColor White
        Write-Host "Build Tool: Maven (pom.xml) / Gradle" -ForegroundColor White
        Write-Host "Database: PostgreSQL / Spring Data JPA" -ForegroundColor White
        Write-Host "Architecture: Layered Controller-Service-Repository" -ForegroundColor White
    }

    "serverless" {
        Write-Host "Framework: Serverless Framework (npm Registry)" -ForegroundColor Cyan
        Write-Host ""
        $sls = Check-NpmPackage "serverless"
        $aws = Check-NpmPackage "@aws-sdk/client-s3"

        Write-Host ""
        Write-Host "=== Recommended Pinned Versions (for FSD.md) ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "CLI Framework: Serverless Framework ^$($sls.latest)" -ForegroundColor White
        Write-Host "Cloud Provider: AWS Lambda (Node.js 20.x runtime)" -ForegroundColor White
        Write-Host "SDK: AWS SDK v3 (^$($aws.latest))" -ForegroundColor White
        Write-Host "Architecture: Event-driven Microservices (API Gateway + Lambda + DynamoDB/Aurora)" -ForegroundColor White
    }

    "flutter" {
        Write-Host "Framework: Flutter / Dart Ecosystem (Pub.dev Official API)" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Querying pub.dev API for flutter packages..." -NoNewline

        $lintsVer = Query-RegistryJson "https://pub.dev/api/packages/flutter_lints" { param($d) $d.latest.version }
        $httpVer = Query-RegistryJson "https://pub.dev/api/packages/http" { param($d) $d.latest.version }
        $providerVer = Query-RegistryJson "https://pub.dev/api/packages/provider" { param($d) $d.latest.version }

        Write-Host " Ready" -ForegroundColor Green
        Write-Host "flutter_lints: $lintsVer" -ForegroundColor White
        Write-Host "http:          $httpVer" -ForegroundColor White
        Write-Host "provider:      $providerVer" -ForegroundColor White

        Write-Host ""
        Write-Host "=== Recommended Pinned Versions (for FSD.md) ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Framework: Flutter (Dart SDK ^3.0.0)" -ForegroundColor White
        Write-Host "State Management: provider ^$providerVer" -ForegroundColor White
        Write-Host "HTTP Client: http ^$httpVer" -ForegroundColor White
        Write-Host "Code Quality: flutter_lints ^$lintsVer" -ForegroundColor White
    }

    "remix" {
        Write-Host "Framework: Remix Ecosystem (npm Registry)" -ForegroundColor Cyan
        Write-Host ""
        $remix = Check-NpmPackage "@remix-run/dev"
        $react = Check-NpmPackage "react"

        Write-Host ""
        Write-Host "=== Recommended Pinned Versions (for FSD.md) ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Framework: Remix ^$($remix.latest)" -ForegroundColor White
        Write-Host "Runtime: React ^$($react.latest)" -ForegroundColor White
        Write-Host "Styling: Tailwind CSS ^3.4.17" -ForegroundColor White
        Write-Host "Architecture: Remix Route Loaders & Actions" -ForegroundColor White
    }

    "astro" {
        Write-Host "Framework: Astro Ecosystem (npm Registry)" -ForegroundColor Cyan
        Write-Host ""
        $astro = Check-NpmPackage "astro"
        $tw = Check-NpmPackage "@astrojs/tailwind"

        Write-Host ""
        Write-Host "=== Recommended Pinned Versions (for FSD.md) ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Framework: Astro ^$($astro.latest)" -ForegroundColor White
        Write-Host "Integrations: @astrojs/tailwind ^$($tw.latest)" -ForegroundColor White
        Write-Host "Architecture: Content-focused Islands Architecture" -ForegroundColor White
    }

    default {
        Write-Host "Error: Unsupported framework '$Framework'." -ForegroundColor Red
        Write-Host "Supported frameworks: nextjs, laravel, django, go, rails, mern, aspnet, spring, serverless, flutter, remix, astro, sveltekit, nuxt" -ForegroundColor White
        exit 1
    }
}

Write-Host ""
Write-Host "Run this script before M05 (Tech Stack Decision) to verify current ecosystem state." -ForegroundColor Gray
Write-Host "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss UTC')" -ForegroundColor Gray
