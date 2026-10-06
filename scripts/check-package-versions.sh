#!/bin/bash
# Universal Package & Framework Version Auto-Check
# Queries official package registries directly via HTTP/CLI
# Covers all 12 production stacks in STACK_SUPPORT_MATRIX.md without local compiler dependencies

set -e

FRAMEWORK="${1:-nextjs}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m'

echo -e "${CYAN}=== Universal Package Version Auto-Check ===${NC}"
echo ""

fetch_json() {
    local url=$1
    local query=$2
    local node_query=${3:-$query}
    local result=""

    if command -v python3 >/dev/null 2>&1; then
        result=$(python3 -c "
import urllib.request, json, sys
req = urllib.request.Request('$url', headers={'User-Agent': 'solo-project-lifecycle/1.0'})
try:
    with urllib.request.urlopen(req, timeout=10) as r:
        d = json.loads(r.read().decode('utf-8'))
        val = $query
        if val is None or val == '':
            sys.exit(1)
        print(val)
except Exception as e:
    sys.stderr.write(f'Registry query error ({url}): {e}\n')
    sys.exit(1)
" 2>/dev/null || echo "")
    elif command -v python >/dev/null 2>&1; then
        result=$(python -c "
import urllib.request, json, sys
req = urllib.request.Request('$url', headers={'User-Agent': 'solo-project-lifecycle/1.0'})
try:
    with urllib.request.urlopen(req, timeout=10) as r:
        d = json.loads(r.read().decode('utf-8'))
        val = $query
        if val is None or val == '':
            sys.exit(1)
        print(val)
except Exception as e:
    sys.stderr.write(f'Registry query error ({url}): {e}\n')
    sys.exit(1)
" 2>/dev/null || echo "")
    elif command -v node >/dev/null 2>&1; then
        result=$(node -e "
fetch('$url', { headers: { 'User-Agent': 'solo-project-lifecycle/1.0' } })
  .then(r => {
    if (!r.ok) throw new Error('HTTP ' + r.status);
    return r.json();
  })
  .then(d => {
    const val = $node_query;
    if (val === undefined || val === null || val === '') process.exit(1);
    console.log(val);
  })
  .catch(e => {
    process.stderr.write('Registry query error: ' + e.message + '\n');
    process.exit(1);
  });
" 2>/dev/null || echo "")
    fi

    if [ -z "$result" ]; then
        echo -e "${RED}FAILED to resolve endpoint: $url${NC}" >&2
        return 1
    fi

    echo "$result"
    return 0
}

check_npm_package() {
    local pkg=$1
    local expected_major=$2

    echo -n "Checking $pkg..." >&2

    local latest=$(npm view "$pkg" version 2>/dev/null || echo "")
    local deprecated=$(npm view "$pkg" deprecated 2>/dev/null || echo "")

    if [ -z "$latest" ]; then
        echo -e " ${RED}NOT FOUND${NC}" >&2
        return 1
    fi

    if [ -n "$deprecated" ]; then
        echo -e " ${YELLOW}DEPRECATED: $deprecated${NC}" >&2
    fi

    local major=$(echo "$latest" | cut -d. -f1)

    if [ -n "$expected_major" ] && [ "$major" != "$expected_major" ]; then
        echo -e " ${YELLOW}v$latest (expected v$expected_major.x)${NC}" >&2
    else
        echo -e " ${GREEN}v$latest${NC}" >&2
    fi

    echo "$latest|$major"
    return 0
}

case $FRAMEWORK in
    nextjs|node)
        echo -e "${CYAN}Framework: Next.js Ecosystem (npm Registry)${NC}"
        echo ""

        next_info=$(check_npm_package "next")
        react_info=$(check_npm_package "react")
        react_dom_info=$(check_npm_package "react-dom")
        types_react_info=$(check_npm_package "@types/react")
        tailwind_info=$(check_npm_package "tailwindcss")
        zod_info=$(check_npm_package "zod")
        hook_form_info=$(check_npm_package "react-hook-form")
        resolvers_info=$(check_npm_package "@hookform/resolvers")
        eslint_next_info=$(check_npm_package "eslint-config-next")
        supabase_ssr_info=$(check_npm_package "@supabase/ssr")
        supabase_js_info=$(check_npm_package "@supabase/supabase-js")

        next_ver=$(echo "$next_info" | cut -d'|' -f1)
        next_major=$(echo "$next_info" | cut -d'|' -f2)
        react_ver=$(echo "$react_info" | cut -d'|' -f1)
        react_major=$(echo "$react_info" | cut -d'|' -f2)
        types_react_major=$(echo "$types_react_info" | cut -d'|' -f2)
        zod_ver=$(echo "$zod_info" | cut -d'|' -f1)
        zod_major=$(echo "$zod_info" | cut -d'|' -f2)
        resolvers_major=$(echo "$resolvers_info" | cut -d'|' -f2)
        tailwind_ver=$(echo "$tailwind_info" | cut -d'|' -f1)
        tailwind_major=$(echo "$tailwind_info" | cut -d'|' -f2)
        eslint_next_major=$(echo "$eslint_next_info" | cut -d'|' -f2)

        echo ""
        echo -e "${CYAN}=== Compatibility Analysis ===${NC}"
        echo ""

        if [ "$next_major" = "15" ]; then
            if [ "$react_major" != "19" ] && [ "$react_major" != "18" ]; then
                echo -e "${YELLOW}⚠ Next.js 15 requires React 19 or 18 (found React $react_major)${NC}"
            else
                echo -e "${GREEN}✓ Next.js 15 + React $react_major compatible${NC}"
            fi
        elif [ "$next_major" = "16" ]; then
            echo -e "${YELLOW}⚠ Next.js 16 detected - verify React compatibility and App Router breaking changes${NC}"
        fi

        if [ "$zod_major" = "4" ]; then
            echo -e "${YELLOW}⚠ Zod v4 detected - verify compatibility with @hookform/resolvers${NC}"
            echo -e "${YELLOW}  Recommendation: Pin Zod to v3.23.8 for maximum stability${NC}"
        elif [ "$zod_major" = "3" ]; then
            echo -e "${GREEN}✓ Zod v3 compatible with react-hook-form ecosystem${NC}"
        fi

        if [ "$tailwind_major" = "4" ]; then
            echo -e "${YELLOW}⚠ Tailwind v4 detected (breaking configuration and PostCSS changes)${NC}"
            echo -e "${YELLOW}  Recommendation: Pin to Tailwind v3.4 for production stability if using shadcn/ui${NC}"
        fi

        auth_helpers_deprecated=$(npm view @supabase/auth-helpers-nextjs deprecated 2>/dev/null || echo "")
        if [ -n "$auth_helpers_deprecated" ]; then
            echo -e "${RED}✗ @supabase/auth-helpers-nextjs is deprecated${NC}"
            echo -e "${GREEN}  Use: @supabase/ssr (official SSR solution)${NC}"
        fi

        echo ""
        echo -e "${CYAN}=== Recommended Pinned Versions (for FSD.md) ===${NC}"
        echo ""
        cat <<EOF
Framework: Next.js ^$next_ver (App Router)
Runtime: React ^$react_ver
Styling: Tailwind CSS $( [ "$tailwind_major" = "4" ] && echo "^3.4.17 (pinned)" || echo "^$tailwind_ver" )
Validation: Zod $( [ "$zod_major" = "4" ] && echo "^3.23.8 (pinned)" || echo "^$zod_ver" ) + react-hook-form
Auth: Supabase (@supabase/ssr)
Database: PostgreSQL (Supabase)
EOF
        ;;

    laravel|php)
        echo -e "${CYAN}Framework: Laravel Ecosystem (Packagist Official API)${NC}"
        echo ""
        echo -n "Querying Packagist API for laravel/framework..." >&2

        laravel_ver=$(fetch_json "https://repo.packagist.org/p2/laravel/framework.json" "d['packages']['laravel/framework'][0]['version']")
        laravel_php_req=$(fetch_json "https://repo.packagist.org/p2/laravel/framework.json" "d['packages']['laravel/framework'][0].get('require', {}).get('php', 'N/A')")
        breeze_ver=$(fetch_json "https://repo.packagist.org/p2/laravel/breeze.json" "d['packages']['laravel/breeze'][0]['version']")
        sanctum_ver=$(fetch_json "https://repo.packagist.org/p2/laravel/sanctum.json" "d['packages']['laravel/sanctum'][0]['version']")

        echo -e " ${GREEN}$laravel_ver${NC}" >&2
        echo -e "Laravel Framework: ${GREEN}$laravel_ver${NC} (Requires PHP: ${CYAN}$laravel_php_req${NC})"
        echo -e "Laravel Breeze:    ${GREEN}$breeze_ver${NC}"
        echo -e "Laravel Sanctum:   ${GREEN}$sanctum_ver${NC}"

        echo ""
        echo -e "${CYAN}=== Compatibility Analysis ===${NC}"
        echo -e "${GREEN}✓ Query resolved directly from Packagist API (no local composer/php CLI required)${NC}"
        echo -e "${GREEN}✓ PHP Requirement: $laravel_php_req${NC}"

        echo ""
        echo -e "${CYAN}=== Recommended Pinned Versions (for FSD.md) ===${NC}"
        echo ""
        cat <<EOF
Framework: Laravel $laravel_ver
PHP Runtime: $laravel_php_req
Authentication: Laravel Breeze ($breeze_ver) / Sanctum ($sanctum_ver)
Database: PostgreSQL / MySQL
Architecture: Modular / Action-Domain-Responder (ADR)
EOF
        ;;

    django|python)
        echo -e "${CYAN}Framework: Django Ecosystem (PyPI JSON API)${NC}"
        echo ""
        echo -n "Querying PyPI API for django..." >&2

        django_ver=$(fetch_json "https://pypi.org/pypi/django/json" "d['info']['version']")
        django_python_req=$(fetch_json "https://pypi.org/pypi/django/json" "d['info'].get('requires_python', 'N/A')")
        drf_ver=$(fetch_json "https://pypi.org/pypi/djangorestframework/json" "d['info']['version']")
        psycopg_ver=$(fetch_json "https://pypi.org/pypi/psycopg/json" "d['info']['version']")

        echo -e " ${GREEN}v$django_ver${NC}" >&2
        echo -e "Django:                  ${GREEN}v$django_ver${NC} (Requires Python: ${CYAN}$django_python_req${NC})"
        echo -e "Django REST Framework:   ${GREEN}v$drf_ver${NC}"
        echo -e "Psycopg (PostgreSQL):    ${GREEN}v$psycopg_ver${NC}"

        echo ""
        echo -e "${CYAN}=== Compatibility Analysis ===${NC}"
        echo -e "${GREEN}✓ Query resolved directly from PyPI API (no local python/pip CLI required)${NC}"
        echo -e "${GREEN}✓ Python Requirement: $django_python_req${NC}"

        echo ""
        echo -e "${CYAN}=== Recommended Pinned Versions (for FSD.md) ===${NC}"
        echo ""
        cat <<EOF
Framework: Django ^$django_ver
Python Runtime: $django_python_req
API Framework: Django REST Framework ^$drf_ver
Database Driver: psycopg ^$psycopg_ver
Architecture: App-per-domain / Django Service Layer
EOF
        ;;

    go|golang)
        echo -e "${CYAN}Framework: Go Ecosystem (Official go.dev & Module Proxy)${NC}"
        echo ""
        echo -n "Querying go.dev API for latest Go runtime..." >&2

        go_ver=$(fetch_json "https://go.dev/dl/?mode=json" "d[0]['version']")
        gin_ver=$(fetch_json "https://proxy.golang.org/github.com/gin-gonic/gin/@latest" "d.get('Version', 'N/A')" "d.Version || 'N/A'")
        gorm_ver=$(fetch_json "https://proxy.golang.org/gorm.io/gorm/@latest" "d.get('Version', 'N/A')" "d.Version || 'N/A'")
        pgx_ver=$(fetch_json "https://proxy.golang.org/github.com/jackc/pgx/v5/@latest" "d.get('Version', 'N/A')" "d.Version || 'N/A'")

        echo -e " ${GREEN}$go_ver${NC}" >&2
        echo -e "Go Runtime:     ${GREEN}$go_ver${NC}"
        echo -e "Gin Web Engine: ${GREEN}$gin_ver${NC}"
        echo -e "GORM:           ${GREEN}$gorm_ver${NC}"
        echo -e "pgx Driver:     ${GREEN}$pgx_ver${NC}"

        echo ""
        echo -e "${CYAN}=== Compatibility Analysis ===${NC}"
        echo -e "${GREEN}✓ Query resolved directly from go.dev and proxy.golang.org${NC}"
        echo -e "${GREEN}✓ Stable Runtime: $go_ver${NC}"

        echo ""
        echo -e "${CYAN}=== Recommended Pinned Versions (for FSD.md) ===${NC}"
        echo ""
        cat <<EOF
Language Runtime: $go_ver
Router / Engine: Gin $gin_ver
Database Driver: pgx $pgx_ver / GORM $gorm_ver
Architecture: Standard Go Clean Architecture (cmd, internal, pkg)
EOF
        ;;

    rails|ruby)
        echo -e "${CYAN}Framework: Ruby on Rails Ecosystem (RubyGems Official API)${NC}"
        echo ""
        echo -n "Querying RubyGems API for rails..." >&2

        rails_ver=$(fetch_json "https://rubygems.org/api/v1/gems/rails.json" "d.get('version', '')" "d.version || ''")
        pg_gem_ver=$(fetch_json "https://rubygems.org/api/v1/gems/pg.json" "d.get('version', '')" "d.version || ''")
        puma_ver=$(fetch_json "https://rubygems.org/api/v1/gems/puma.json" "d.get('version', '')" "d.version || ''")

        rails_major=$(echo "$rails_ver" | cut -d. -f1)
        if [ "$rails_major" -ge 8 ] 2>/dev/null; then
            ruby_req=">= 3.2.0"
        elif [ "$rails_major" -ge 7 ] 2>/dev/null; then
            ruby_req=">= 2.7.0"
        else
            ruby_req=">= 2.5.0"
        fi

        echo -e " ${GREEN}v$rails_ver${NC}" >&2
        echo -e "Rails:       ${GREEN}v$rails_ver${NC} (Required Ruby: ${CYAN}$ruby_req${NC})"
        echo -e "pg gem:      ${GREEN}v$pg_gem_ver${NC}"
        echo -e "Puma Server: ${GREEN}v$puma_ver${NC}"

        echo ""
        echo -e "${CYAN}=== Compatibility Analysis ===${NC}"
        echo -e "${GREEN}✓ Query resolved directly from RubyGems API (no local bundler/ruby CLI required)${NC}"

        echo ""
        echo -e "${CYAN}=== Recommended Pinned Versions (for FSD.md) ===${NC}"
        echo ""
        cat <<EOF
Framework: Rails ~$rails_ver
Ruby Runtime: $ruby_req
Web Server: Puma ~$puma_ver
Database: PostgreSQL (gem pg)
Architecture: Rails Standard MVC + Service Objects
EOF
        ;;

    mern|express)
        echo -e "${CYAN}Framework: MERN Stack (npm Registry)${NC}"
        echo ""
        express_info=$(check_npm_package "express")
        mongoose_info=$(check_npm_package "mongoose")
        cors_info=$(check_npm_package "cors")
        dotenv_info=$(check_npm_package "dotenv")

        express_ver=$(echo "$express_info" | cut -d'|' -f1)
        mongoose_ver=$(echo "$mongoose_info" | cut -d'|' -f1)
        cors_ver=$(echo "$cors_info" | cut -d'|' -f1)

        echo ""
        echo -e "${CYAN}=== Recommended Pinned Versions (for FSD.md) ===${NC}"
        echo ""
        cat <<EOF
Backend Framework: Express ^$express_ver
Database ODM: Mongoose ^$mongoose_ver
Middleware: CORS ^$cors_ver
Frontend: React ^19.0.0 + Vite
Architecture: Modular REST API / Service Layer
EOF
        ;;

    aspnet|dotnet)
        echo -e "${CYAN}Framework: ASP.NET Core (.NET / NuGet API)${NC}"
        echo ""
        echo -n "Querying NuGet API for Microsoft.AspNetCore.App.Ref..." >&2

        dotnet_ver=$(fetch_json "https://api.nuget.org/v3-flatcontainer/microsoft.aspnetcore.app.ref/index.json" "[v for v in d['versions'] if '-' not in v][-1]" "d.versions.filter(v => !v.includes('-')).slice(-1)[0]")
        efcore_ver=$(fetch_json "https://api.nuget.org/v3-flatcontainer/microsoft.entityframeworkcore/index.json" "[v for v in d['versions'] if '-' not in v][-1]" "d.versions.filter(v => !v.includes('-')).slice(-1)[0]")
        npgsql_ver=$(fetch_json "https://api.nuget.org/v3-flatcontainer/npgsql.entityframeworkcore.postgresql/index.json" "[v for v in d['versions'] if '-' not in v][-1]" "d.versions.filter(v => !v.includes('-')).slice(-1)[0]")

        echo -e " ${GREEN}v$dotnet_ver${NC}" >&2
        echo -e ".NET Core Runtime:      ${GREEN}v$dotnet_ver${NC}"
        echo -e "Entity Framework Core:  ${GREEN}v$efcore_ver${NC}"
        echo -e "Npgsql PostgreSQL:      ${GREEN}v$npgsql_ver${NC}"

        echo ""
        echo -e "${CYAN}=== Recommended Pinned Versions (for FSD.md) ===${NC}"
        echo ""
        cat <<EOF
Target Framework: net${dotnet_ver%%.*}.0 ($dotnet_ver)
ORM: Microsoft.EntityFrameworkCore ($efcore_ver)
Database Provider: Npgsql.EntityFrameworkCore.PostgreSQL ($npgsql_ver)
Architecture: Clean Architecture / Controllers + MediatR
EOF
        ;;

    spring|java)
        echo -e "${CYAN}Framework: Spring Boot (Maven Central API)${NC}"
        echo ""
        echo -n "Querying Spring Initializr API for Spring Boot..." >&2

        spring_ver=$(fetch_json "https://start.spring.io/actuator/info" "d.get('build', {}).get('versions', {}).get('spring-boot', 'N/A')" "(d.build?.versions?.['spring-boot'] || 'N/A')")

        echo -e " ${GREEN}v$spring_ver${NC}" >&2
        echo -e "Spring Boot: ${GREEN}v$spring_ver${NC}"

        echo ""
        echo -e "${CYAN}=== Recommended Pinned Versions (for FSD.md) ===${NC}"
        echo ""
        cat <<EOF
Framework: Spring Boot $spring_ver
Java Runtime: Java 21 LTS (or 17 LTS)
Build Tool: Maven (pom.xml) / Gradle
Database: PostgreSQL / Spring Data JPA
Architecture: Layered Controller-Service-Repository
EOF
        ;;

    serverless)
        echo -e "${CYAN}Framework: Serverless Framework (npm Registry)${NC}"
        echo ""
        sls_info=$(check_npm_package "serverless")
        aws_s3_info=$(check_npm_package "@aws-sdk/client-s3")

        sls_ver=$(echo "$sls_info" | cut -d'|' -f1)
        aws_ver=$(echo "$aws_s3_info" | cut -d'|' -f1)

        echo ""
        echo -e "${CYAN}=== Recommended Pinned Versions (for FSD.md) ===${NC}"
        echo ""
        cat <<EOF
CLI Framework: Serverless Framework ^$sls_ver
Cloud Provider: AWS Lambda (Node.js 20.x runtime)
SDK: AWS SDK v3 (^$aws_ver)
Architecture: Event-driven Microservices (API Gateway + Lambda + DynamoDB/Aurora)
EOF
        ;;

    flutter|dart)
        echo -e "${CYAN}Framework: Flutter / Dart Ecosystem (Pub.dev Official API)${NC}"
        echo ""
        echo -n "Querying pub.dev API for flutter packages..." >&2

        lints_ver=$(fetch_json "https://pub.dev/api/packages/flutter_lints" "d.get('latest', {}).get('version', 'N/A')" "(d.latest?.version || 'N/A')")
        http_ver=$(fetch_json "https://pub.dev/api/packages/http" "d.get('latest', {}).get('version', 'N/A')" "(d.latest?.version || 'N/A')")
        provider_ver=$(fetch_json "https://pub.dev/api/packages/provider" "d.get('latest', {}).get('version', 'N/A')" "(d.latest?.version || 'N/A')")

        echo -e " ${GREEN}Ready${NC}" >&2
        echo -e "flutter_lints: ${GREEN}$lints_ver${NC}"
        echo -e "http:          ${GREEN}$http_ver${NC}"
        echo -e "provider:      ${GREEN}$provider_ver${NC}"

        echo ""
        echo -e "${CYAN}=== Recommended Pinned Versions (for FSD.md) ===${NC}"
        echo ""
        cat <<EOF
Framework: Flutter (Dart SDK ^3.0.0)
State Management: provider ^$provider_ver
HTTP Client: http ^$http_ver
Code Quality: flutter_lints ^$lints_ver
EOF
        ;;

    remix)
        echo -e "${CYAN}Framework: Remix Ecosystem (npm Registry)${NC}"
        echo ""
        remix_info=$(check_npm_package "@remix-run/dev")
        react_info=$(check_npm_package "react")
        remix_ver=$(echo "$remix_info" | cut -d'|' -f1)
        react_ver=$(echo "$react_info" | cut -d'|' -f1)

        echo ""
        echo -e "${CYAN}=== Recommended Pinned Versions (for FSD.md) ===${NC}"
        echo ""
        cat <<EOF
Framework: Remix ^$remix_ver
Runtime: React ^$react_ver
Styling: Tailwind CSS ^3.4.17
Architecture: Remix Route Loaders & Actions
EOF
        ;;

    astro|jamstack)
        echo -e "${CYAN}Framework: Astro Ecosystem (npm Registry)${NC}"
        echo ""
        astro_info=$(check_npm_package "astro")
        tw_info=$(check_npm_package "@astrojs/tailwind")
        astro_ver=$(echo "$astro_info" | cut -d'|' -f1)
        tw_ver=$(echo "$tw_info" | cut -d'|' -f1)

        echo ""
        echo -e "${CYAN}=== Recommended Pinned Versions (for FSD.md) ===${NC}"
        echo ""
        cat <<EOF
Framework: Astro ^$astro_ver
Integrations: @astrojs/tailwind ^$tw_ver
Architecture: Content-focused Islands Architecture
EOF
        ;;

    *)
        echo -e "${RED}Error: Unsupported framework '$FRAMEWORK'.${NC}"
        echo "Supported frameworks: nextjs, laravel, django, go, rails, mern, aspnet, spring, serverless, flutter, remix, astro"
        exit 1
        ;;
esac

echo ""
echo -e "${GRAY}Run this script before M05 (Tech Stack Decision) to verify current ecosystem state.${NC}"
echo -e "${GRAY}Generated: $(date -u +"%Y-%m-%d %H:%M:%S UTC")${NC}"
