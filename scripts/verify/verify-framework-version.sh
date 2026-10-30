#!/usr/bin/env bash
# Framework Version Gate - M06 Step 1.5
# Enforces exact resolved versions match FSD locked versions

set -e

FSD_FILE="docs/specs/FSD.md"
LITE_FILE="PROJECT_LITE.md"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔍 Framework Version Gate Check..."
echo ""

if [[ -f "$FSD_FILE" ]]; then
    TARGET_FILE="$FSD_FILE"
elif [[ -f "$LITE_FILE" ]]; then
    TARGET_FILE="$LITE_FILE"
    echo -e "${YELLOW}ℹ️  Fast-Track mode detected: Using PROJECT_LITE.md instead of FSD.md${NC}"
elif [[ -f "docs/specs/PROJECT_LITE.md" ]]; then
    TARGET_FILE="docs/specs/PROJECT_LITE.md"
    echo -e "${YELLOW}ℹ️  Fast-Track mode detected: Using docs/specs/PROJECT_LITE.md instead of FSD.md${NC}"
else
    echo -e "${RED}❌ Neither docs/specs/FSD.md nor PROJECT_LITE.md found${NC}"
    exit 1
fi

# Extract a pinned version from the "Framework Versions (Pinned)" section.
#
# The section is written in TWO accepted shapes and both must parse, because the
# shipped templates use the first one:
#   - **Framework**: Next.js ^15.0.3 (App Router)      <- FSD_TECHNICAL_TEMPLATE.md
#   - **Language / Runtime**: Node.js 22 LTS
#   - Next.js: 15.0.3                                  <- bare form
# The old implementation only matched "^- <pkg>:", so a template-faithful FSD
# (where the stack name lives in the VALUE, not the key) failed its own gate with
# "FSD missing 'Next.js: X.Y.Z'" and M06 STEP 3 could never pass.
# Strategy: take the section body, keep lines mentioning the package name, then
# pull the first version-looking token from them.
extract_fsd_version() {
    local package=$1
    # Body = from the pinned-version heading to the next markdown heading.
    awk '
        /Framework Versions.*\(Pinned\)/ { inb = 1; next }
        inb && /^#{2,6}[[:space:]]/ { exit }
        inb { print }
    ' "$TARGET_FILE" \
    | grep -i -- "$package" \
    | grep -oiE 'v?[0-9]+(\.[0-9]+)+' \
    | head -1 \
    | tr -d ' '
}

# Extract stack (tolerates the bare and the bold/questionnaire forms).
STACK_LINE=$(grep -i "Stack Decision LOCKED:" "$TARGET_FILE" | head -1)
STACK=$(echo "$STACK_LINE" | sed 's/.*LOCKED:[[:space:]]*//' | sed 's/[*`]//g' | xargs | cut -d' ' -f1)
STACK_LC=$(echo "$STACK" | tr '[:upper:]' '[:lower:]')

echo "📋 FSD Stack: $STACK"
echo ""

# A missing tool used to kill the script silently: 'set -e' plus
# `V=$(node -p ...)` when node is not installed exits 127 with NO output, so the
# developer saw an empty run and no diagnosis. Name the missing prerequisite.
require_cmd() {
    local cmd=$1 why=$2
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo -e "${RED}❌ Required tool '$cmd' not found in PATH ($why).${NC}"
        echo "   Install it, or run this gate on a machine that has it."
        exit 1
    fi
}

# Scaffold-type guard: FSD-declared framework vs what is actually in the repo.
# An agent that scaffolded the wrong framework used to be caught only by prose in
# the deep dive; the version comparison then compared against the wrong lockfile.
scaffold_type_check() {
    local want=$1 missing=$2 wrong=$3
    if [ ! -f "$missing" ]; then
        echo -e "${RED}❌ FSD declares $want, but $missing is missing — wrong or absent scaffold.${NC}"
        echo "   Re-scaffold with the FSD-locked command before continuing."
        exit 1
    fi
    if [ -n "$wrong" ]; then
        echo -e "${RED}❌ FSD declares $want, but the repo looks like $wrong (conflicting manifest present).${NC}"
        echo "   Re-scaffold with the FSD-locked command before continuing."
        exit 1
    fi
    echo -e "${GREEN}✓${NC} scaffold manifest matches the locked stack ($want)"
}

# Tailwind major-version detection (v3 vs v4 changes config syntax: v4 is
# CSS-first and has no tailwind.config.js). M06 STEP 3 requires this signal, but
# it was never implemented — harness files could embed v3 syntax on a v4 project.
tailwind_check() {
    [ -f package.json ] || return 0
    local tw
    tw=$(grep -oE '"tailwindcss"[[:space:]]*:[[:space:]]*"[^"]+"' package.json 2>/dev/null \
        | grep -oE '[0-9]+' | head -1) || true
    [ -n "${tw:-}" ] || return 0
    if [ "$tw" -ge 4 ] 2>/dev/null; then
        echo -e "${YELLOW}ℹ️  Tailwind v4 detected — CSS-first config (no tailwind.config.js).${NC}"
        echo "   AGENTS.md / CONVENTIONS.md must reference v4 syntax."
    else
        echo -e "${GREEN}✓${NC} Tailwind v$tw detected (JS config expected)"
    fi
}

case "$STACK" in
    Expo|expo|React\ Native|react-native)
        scaffold_type_check "Expo" "package.json" ""
        FSD_EXPO=$(extract_fsd_version "Expo")
        if [[ -z "$FSD_EXPO" ]]; then
            echo -e "${RED}Expo pin missing in Framework Versions (Pinned); use '- Expo: X.Y.Z'${NC}"
            exit 1
        fi
        if [[ ! -f "package-lock.json" ]]; then
            echo -e "${RED}Expo M06 comparator requires package-lock.json (npm lockfile)${NC}"
            exit 1
        fi
        require_cmd node "needed to read package-lock.json"
        RESOLVED=$(node -p "require('./package-lock.json').packages['node_modules/expo']?.version || ''" 2>/dev/null)
        if [[ -z "$RESOLVED" ]]; then
            echo -e "${RED}expo not resolved in package-lock.json${NC}"
            exit 1
        fi
        FSD_MM=$(echo "$FSD_EXPO" | sed 's/^v//' | cut -d. -f1-2)
        RESOLVED_MM=$(echo "$RESOLVED" | cut -d. -f1-2)
        if [[ "$RESOLVED_MM" != "$FSD_MM" ]]; then
            echo -e "${RED}VERSION MISMATCH: FSD Expo $FSD_EXPO, package-lock Expo $RESOLVED${NC}"
            exit 1
        fi
        echo "Expo package $RESOLVED matches FSD"
        require_cmd npx "needed for Expo compatibility checks"
        npx expo install --check
        npx expo-doctor@latest
        ;;
    Next.js|Nextjs|next.js)
        scaffold_type_check "Next.js" "package.json" "$([ -f composer.json ] && echo 'Laravel/PHP' || ([ -f manage.py ] && echo 'Django/Python' || true))"
        tailwind_check
        FSD_NEXT=$(extract_fsd_version "Next.js" || extract_fsd_version "next")
        FSD_REACT=$(extract_fsd_version "React" || extract_fsd_version "react")
        
        if [[ -z "$FSD_NEXT" ]]; then
            echo -e "${RED}❌ FSD missing 'Next.js: X.Y.Z'${NC}"
            exit 1
        fi
        
        require_cmd node "needed to read package-lock.json"
        # Get resolved from lockfile
        if [[ -f "package-lock.json" ]]; then
            RESOLVED_NEXT=$(node -p "require('./package-lock.json').packages['node_modules/next']?.version || ''" 2>/dev/null)
            RESOLVED_REACT=$(node -p "require('./package-lock.json').packages['node_modules/react']?.version || ''" 2>/dev/null)
        elif [[ -f "pnpm-lock.yaml" ]]; then
            RESOLVED_NEXT=$(grep "next@" pnpm-lock.yaml | head -1 | sed 's/.*next@//' | cut -d: -f1)
            RESOLVED_REACT=$(grep "react@" pnpm-lock.yaml | grep -v "react-dom" | head -1 | sed 's/.*react@//' | cut -d: -f1)
        else
            echo -e "${RED}❌ No lockfile found (package-lock.json or pnpm-lock.yaml required)${NC}"
            exit 1
        fi
        
        if [[ -z "$RESOLVED_NEXT" ]]; then
            echo -e "${RED}❌ next not resolved in lockfile${NC}"
            exit 1
        fi
        
        # Compare exact versions (major.minor match required)
        FSD_MAJOR_MINOR=$(echo "$FSD_NEXT" | cut -d. -f1-2)
        RESOLVED_MAJOR_MINOR=$(echo "$RESOLVED_NEXT" | cut -d. -f1-2)
        
        if [[ "$RESOLVED_MAJOR_MINOR" != "$FSD_MAJOR_MINOR" ]]; then
            echo -e "${RED}❌ VERSION MISMATCH${NC}"
            echo "FSD:      next@$FSD_NEXT"
            echo "Resolved: next@$RESOLVED_NEXT"
            echo ""
            echo "Fix: npm install next@$FSD_NEXT"
            [[ -n "$FSD_REACT" ]] && echo "     npm install react@$FSD_REACT react-dom@$FSD_REACT"
            exit 1
        fi
        
        # Check React if specified
        if [[ -n "$FSD_REACT" && -n "$RESOLVED_REACT" ]]; then
            FSD_REACT_MM=$(echo "$FSD_REACT" | cut -d. -f1-2)
            RESOLVED_REACT_MM=$(echo "$RESOLVED_REACT" | cut -d. -f1-2)
            
            if [[ "$RESOLVED_REACT_MM" != "$FSD_REACT_MM" ]]; then
                echo -e "${RED}❌ React version mismatch${NC}"
                echo "FSD:      react@$FSD_REACT"
                echo "Resolved: react@$RESOLVED_REACT"
                echo ""
                echo "Fix: npm install react@$FSD_REACT react-dom@$FSD_REACT"
                exit 1
            fi
        fi
        
        echo "✅ next@$RESOLVED_NEXT matches FSD"
        [[ -n "$RESOLVED_REACT" ]] && echo "✅ react@$RESOLVED_REACT matches FSD"
        ;;
        
    Laravel)
        scaffold_type_check "Laravel" "composer.json" "$([ -f manage.py ] && echo 'Django/Python' || true)"
        FSD_LARAVEL=$(extract_fsd_version "Laravel" || extract_fsd_version "laravel/framework")
        
        if [[ -z "$FSD_LARAVEL" ]]; then
            echo -e "${RED}❌ FSD missing 'Laravel: X.Y'${NC}"
            exit 1
        fi
        
        require_cmd php "needed to read composer.lock"
        if [[ ! -f "composer.lock" ]]; then
            echo -e "${RED}❌ No composer.lock found${NC}"
            exit 1
        fi
        
        RESOLVED=$(php -r "\$lock = json_decode(file_get_contents('composer.lock')); foreach (\$lock->packages as \$pkg) { if (\$pkg->name == 'laravel/framework') echo \$pkg->version; }")
        
        if [[ -z "$RESOLVED" ]]; then
            echo -e "${RED}❌ laravel/framework not in composer.lock${NC}"
            exit 1
        fi
        
        FSD_MM=$(echo "$FSD_LARAVEL" | sed 's/^v//' | cut -d. -f1-2)
        RESOLVED_MM=$(echo "$RESOLVED" | sed 's/^v//' | cut -d. -f1-2)
        
        if [[ "$RESOLVED_MM" != "$FSD_MM" ]]; then
            echo -e "${RED}❌ VERSION MISMATCH${NC}"
            echo "FSD:      laravel/framework@$FSD_LARAVEL"
            echo "Resolved: laravel/framework@$RESOLVED"
            echo ""
            echo "Fix: composer require laravel/framework:$FSD_LARAVEL"
            exit 1
        fi
        
        echo "✅ laravel/framework@$RESOLVED matches FSD"
        ;;
        
    Django)
        scaffold_type_check "Django" "manage.py" "$([ -f composer.json ] && echo 'Laravel/PHP' || true)"
        FSD_DJANGO=$(extract_fsd_version "Django")
        
        if [[ -z "$FSD_DJANGO" ]]; then
            echo -e "${RED}❌ FSD missing 'Django: X.Y.Z'${NC}"
            exit 1
        fi
        
        if [[ ! -f "requirements.txt" ]]; then
            echo -e "${RED}❌ No requirements.txt found${NC}"
            exit 1
        fi
        
        RESOLVED=$(grep -i "^Django==" requirements.txt | cut -d= -f3)
        
        if [[ -z "$RESOLVED" ]]; then
            echo -e "${RED}❌ Django not in requirements.txt${NC}"
            exit 1
        fi
        
        FSD_MM=$(echo "$FSD_DJANGO" | cut -d. -f1-2)
        RESOLVED_MM=$(echo "$RESOLVED" | cut -d. -f1-2)
        
        if [[ "$RESOLVED_MM" != "$FSD_MM" ]]; then
            echo -e "${RED}❌ VERSION MISMATCH${NC}"
            echo "FSD:      Django==$FSD_DJANGO"
            echo "Resolved: Django==$RESOLVED"
            echo ""
            echo "Fix: pip install django==$FSD_DJANGO"
            exit 1
        fi
        
        echo "✅ Django==$RESOLVED matches FSD"
        ;;
        
    Go)
        scaffold_type_check "Go" "go.mod" "$([ -f package.json ] && echo 'a JS framework' || true)"
        FSD_GO=$(extract_fsd_version "Go")
        
        if [[ -z "$FSD_GO" ]]; then
            echo -e "${RED}❌ FSD missing 'Go: X.Y'${NC}"
            exit 1
        fi
        
        if [[ ! -f "go.mod" ]]; then
            echo -e "${RED}❌ No go.mod found${NC}"
            exit 1
        fi
        
        RESOLVED=$(grep "^go " go.mod | awk '{print $2}')
        
        if [[ -z "$RESOLVED" ]]; then
            echo -e "${RED}❌ Go version not in go.mod${NC}"
            exit 1
        fi
        
        FSD_GO_MM=$(echo "$FSD_GO" | cut -d. -f1-2)
        RESOLVED_GO_MM=$(echo "$RESOLVED" | cut -d. -f1-2)
        if [[ "$RESOLVED_GO_MM" != "$FSD_GO_MM" ]]; then
            echo -e "${RED}❌ VERSION MISMATCH${NC}"
            echo "FSD:      go $FSD_GO"
            echo "Resolved: go $RESOLVED"
            exit 1
        fi
        
        echo "✅ go $RESOLVED matches FSD"
        ;;
        
    FastAPI|fastapi|Python)
        FSD_FASTAPI=$(extract_fsd_version "FastAPI")
        
        if [[ -z "$FSD_FASTAPI" ]]; then
            echo -e "${RED}❌ FSD missing 'FastAPI: X.Y.Z'${NC}"
            exit 1
        fi
        
        if [[ ! -f "requirements.txt" ]]; then
            echo -e "${RED}❌ No requirements.txt found${NC}"
            exit 1
        fi
        
        RESOLVED=$(grep -i "^fastapi==" requirements.txt | cut -d= -f3)
        
        if [[ -z "$RESOLVED" ]]; then
            echo -e "${RED}❌ fastapi not pinned in requirements.txt (expected 'fastapi==X.Y.Z')${NC}"
            exit 1
        fi
        
        FSD_MM=$(echo "$FSD_FASTAPI" | cut -d. -f1-2)
        RESOLVED_MM=$(echo "$RESOLVED" | cut -d. -f1-2)
        
        if [[ "$RESOLVED_MM" != "$FSD_MM" ]]; then
            echo -e "${RED}❌ VERSION MISMATCH${NC}"
            echo "FSD:      fastapi==$FSD_FASTAPI"
            echo "Resolved: fastapi==$RESOLVED"
            echo ""
            echo "Fix: pip install fastapi==$FSD_FASTAPI"
            exit 1
        fi
        
        echo "✅ fastapi==$RESOLVED matches FSD"
        ;;
        
    SvelteKit|Svelte|sveltekit)
        FSD_KIT=$(extract_fsd_version "@sveltejs/kit" || extract_fsd_version "SvelteKit")
        
        if [[ -z "$FSD_KIT" ]]; then
            echo -e "${RED}❌ FSD missing '@sveltejs/kit: X.Y.Z'${NC}"
            exit 1
        fi
        
        if [[ ! -f "package-lock.json" ]]; then
            echo -e "${RED}❌ No package-lock.json found${NC}"
            exit 1
        fi
        
        RESOLVED=$(node -p "require('./package-lock.json').packages['node_modules/@sveltejs/kit']?.version || ''" 2>/dev/null)
        
        if [[ -z "$RESOLVED" ]]; then
            echo -e "${RED}❌ @sveltejs/kit not resolved in package-lock.json${NC}"
            exit 1
        fi
        
        FSD_MM=$(echo "$FSD_KIT" | cut -d. -f1-2)
        RESOLVED_MM=$(echo "$RESOLVED" | cut -d. -f1-2)
        
        if [[ "$RESOLVED_MM" != "$FSD_MM" ]]; then
            echo -e "${RED}❌ VERSION MISMATCH${NC}"
            echo "FSD:      @sveltejs/kit@$FSD_KIT"
            echo "Resolved: @sveltejs/kit@$RESOLVED"
            echo ""
            echo "Fix: npm install @sveltejs/kit@$FSD_KIT"
            exit 1
        fi
        
        echo "✅ @sveltejs/kit@$RESOLVED matches FSD"
        ;;
        
    Nuxt|nuxt)
        FSD_NUXT=$(extract_fsd_version "Nuxt")
        
        if [[ -z "$FSD_NUXT" ]]; then
            echo -e "${RED}❌ FSD missing 'Nuxt: X.Y.Z'${NC}"
            exit 1
        fi
        
        if [[ ! -f "package-lock.json" ]]; then
            echo -e "${RED}❌ No package-lock.json found${NC}"
            exit 1
        fi
        
        RESOLVED=$(node -p "require('./package-lock.json').packages['node_modules/nuxt']?.version || ''" 2>/dev/null)
        
        if [[ -z "$RESOLVED" ]]; then
            echo -e "${RED}❌ nuxt not resolved in package-lock.json${NC}"
            exit 1
        fi
        
        FSD_MM=$(echo "$FSD_NUXT" | cut -d. -f1-2)
        RESOLVED_MM=$(echo "$RESOLVED" | cut -d. -f1-2)
        
        if [[ "$RESOLVED_MM" != "$FSD_MM" ]]; then
            echo -e "${RED}❌ VERSION MISMATCH${NC}"
            echo "FSD:      nuxt@$FSD_NUXT"
            echo "Resolved: nuxt@$RESOLVED"
            echo ""
            echo "Fix: npm install nuxt@$FSD_NUXT"
            exit 1
        fi
        
        echo "✅ nuxt@$RESOLVED matches FSD"
        ;;
        
    Rails|rails|Ruby)
        FSD_RAILS=$(extract_fsd_version "Rails" || extract_fsd_version "rails")
        
        if [[ -z "$FSD_RAILS" ]]; then
            echo -e "${RED}❌ FSD missing 'Rails: X.Y'${NC}"
            exit 1
        fi
        
        if [[ ! -f "Gemfile.lock" ]]; then
            echo -e "${RED}❌ No Gemfile.lock found${NC}"
            exit 1
        fi
        
        RESOLVED=$(awk '/^    rails \(/ { gsub(/[()]/, "", $2); print $2; exit }' Gemfile.lock)
        
        if [[ -z "$RESOLVED" ]]; then
            echo -e "${RED}❌ rails not resolved in Gemfile.lock${NC}"
            exit 1
        fi
        
        FSD_MM=$(echo "$FSD_RAILS" | sed 's/^v//' | cut -d. -f1-2)
        RESOLVED_MM=$(echo "$RESOLVED" | cut -d. -f1-2)
        
        if [[ "$RESOLVED_MM" != "$FSD_MM" ]]; then
            echo -e "${RED}❌ VERSION MISMATCH${NC}"
            echo "FSD:      rails $FSD_RAILS"
            echo "Resolved: rails $RESOLVED"
            echo ""
            echo "Fix: bundle update rails --conservative"
            exit 1
        fi
        
        echo "✅ rails $RESOLVED matches FSD"
        ;;
        
    *)
        echo -e "${RED}❌ No lockfile comparator for stack: $STACK${NC}"
        echo "   Comparators exist for: Next.js, Laravel, Django, FastAPI, Go, SvelteKit, Nuxt, Rails, Expo (npm/package-lock)."
        echo "   Your stack is locked in the FSD, but this gate cannot read its lockfile, so the pin"
        echo "   is UNVERIFIED — do not report M06 STEP 3 as passed."
        echo "   Action: verify the pin by hand against the lockfile, record the result in the FSD"
        echo "   'Framework Versions (Pinned):' block, and add the comparator here (bash + ps1)."
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}✅ Version gate PASSED${NC}"
