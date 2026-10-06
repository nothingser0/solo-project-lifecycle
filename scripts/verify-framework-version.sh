#!/usr/bin/env bash
# Framework Version Gate - M06 Step 1.5
# Enforces exact resolved versions match FSD locked versions

set -e

FSD_FILE="docs/specs/FSD.md"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔍 Framework Version Gate Check..."
echo ""

if [[ ! -f "$FSD_FILE" ]]; then
    echo -e "${RED}❌ FSD.md not found${NC}"
    exit 1
fi

# Extract FSD versions from "Framework Versions (Pinned):" section
extract_fsd_version() {
    local package=$1
    grep -A 20 "Framework Versions (Pinned):" "$FSD_FILE" | grep -i "^- $package:" | sed 's/.*: //' | tr -d ' '
}

# Extract stack
STACK_LINE=$(grep -i "Stack Decision LOCKED:" "$FSD_FILE" | head -1)
STACK=$(echo "$STACK_LINE" | sed 's/.*LOCKED:\s*//' | xargs | cut -d' ' -f1)

echo "📋 FSD Stack: $STACK"
echo ""

case "$STACK" in
    Next.js|Nextjs|next.js)
        FSD_NEXT=$(extract_fsd_version "Next.js" || extract_fsd_version "next")
        FSD_REACT=$(extract_fsd_version "React" || extract_fsd_version "react")
        
        if [[ -z "$FSD_NEXT" ]]; then
            echo -e "${RED}❌ FSD missing 'Next.js: X.Y.Z'${NC}"
            exit 1
        fi
        
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
        FSD_LARAVEL=$(extract_fsd_version "Laravel" || extract_fsd_version "laravel/framework")
        
        if [[ -z "$FSD_LARAVEL" ]]; then
            echo -e "${RED}❌ FSD missing 'Laravel: X.Y'${NC}"
            exit 1
        fi
        
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
        
    *)
        echo -e "${RED}❌ Unknown stack: $STACK${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}✅ Version gate PASSED${NC}"
