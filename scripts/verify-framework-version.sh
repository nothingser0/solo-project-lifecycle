#!/bin/bash
# Framework Version Gate - M06 Step 0.5
# Enforces FSD locked version matches installed framework version

set -e

FSD_FILE="docs/specs/FSD.md"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🔍 Framework Version Gate Check..."
echo ""

# Check FSD exists
if [[ ! -f "$FSD_FILE" ]]; then
    echo -e "${RED}❌ GATE FAILED: FSD.md not found${NC}"
    echo "FSD.md required from M05. Run Module 05 first."
    exit 1
fi

# Extract locked stack
STACK_LINE=$(grep -i "Stack Decision LOCKED:" "$FSD_FILE" | head -1)
if [[ -z "$STACK_LINE" ]]; then
    echo -e "${RED}❌ GATE FAILED: No locked stack decision in FSD.md${NC}"
    echo "Expected format: 'Stack Decision LOCKED: Next.js 15'"
    exit 1
fi

STACK=$(echo "$STACK_LINE" | sed 's/.*LOCKED:\s*//' | xargs)
echo "📋 FSD Locked Stack: $STACK"

# Version validation by stack
case "$STACK" in
    "Next.js 15"*)
        EXPECTED_MAJOR="15"
        FRAMEWORK="next"
        
        if [[ -f "package.json" ]]; then
            INSTALLED=$(node -p "require('./package.json').dependencies.next || ''" 2>/dev/null | sed 's/[\^~]//g' | cut -d. -f1)
            INSTALLED_FULL=$(node -p "require('./package.json').dependencies.next || ''" 2>/dev/null)
            
            if [[ -z "$INSTALLED" ]]; then
                echo -e "${YELLOW}⚠️  Next.js not installed yet (scaffold pending)${NC}"
                echo "✅ Gate passed - will validate after scaffold"
                exit 0
            fi
            
            if [[ "$INSTALLED" != "$EXPECTED_MAJOR" ]]; then
                echo ""
                echo -e "${RED}❌ VERSION MISMATCH DETECTED${NC}"
                echo ""
                echo "FSD Locked:  Next.js $EXPECTED_MAJOR.x"
                echo "Installed:   Next.js $INSTALLED.x ($INSTALLED_FULL)"
                echo ""
                echo "Breaking changes detected!"
                
                if [[ "$INSTALLED" == "16" ]]; then
                    echo ""
                    echo "Next.js 16 Breaking Changes:"
                    echo "  - middleware.ts → proxy.ts"
                    echo "  - Sync request APIs removed (cookies(), headers())"
                    echo "  - Cache behavior changed"
                    echo ""
                    echo "SOLUTIONS:"
                    echo "  1. Downgrade to match FSD:"
                    echo "     npm install next@15.0.3 react@19.0.0"
                    echo ""
                    echo "  2. Update FSD to Next.js 16 (if harness available):"
                    echo "     Check: templates/04-dev-execution/nextjs-16/"
                    echo ""
                    echo "  3. Manual migration:"
                    echo "     Run: npx @next/codemod@16 middleware-to-proxy ."
                    echo "     Read: NEXTJS_16_MIGRATION.md"
                fi
                
                exit 1
            fi
            
            echo "✅ Next.js version: $INSTALLED_FULL (matches FSD)"
        fi
        ;;
        
    "Laravel 11"*)
        EXPECTED_MAJOR="11"
        
        if [[ -f "composer.json" ]]; then
            INSTALLED=$(php -r "echo json_decode(file_get_contents('composer.json'))->require->{'laravel/framework'} ?? '';" | sed 's/[\^~]//g' | cut -d. -f1)
            INSTALLED_FULL=$(php -r "echo json_decode(file_get_contents('composer.json'))->require->{'laravel/framework'} ?? '';")
            
            if [[ -z "$INSTALLED" ]]; then
                echo -e "${YELLOW}⚠️  Laravel not installed yet${NC}"
                exit 0
            fi
            
            if [[ "$INSTALLED" != "$EXPECTED_MAJOR" ]]; then
                echo -e "${RED}❌ VERSION MISMATCH${NC}"
                echo "FSD Locked:  Laravel $EXPECTED_MAJOR.x"
                echo "Installed:   Laravel $INSTALLED.x ($INSTALLED_FULL)"
                exit 1
            fi
            
            echo "✅ Laravel version: $INSTALLED_FULL"
        fi
        ;;
        
    "Django 5"*)
        EXPECTED_MAJOR="5"
        
        if [[ -f "requirements.txt" ]]; then
            INSTALLED=$(grep -i "^Django==" requirements.txt | cut -d= -f3 | cut -d. -f1)
            INSTALLED_FULL=$(grep -i "^Django==" requirements.txt | cut -d= -f3)
            
            if [[ -z "$INSTALLED" ]]; then
                echo -e "${YELLOW}⚠️  Django not installed yet${NC}"
                exit 0
            fi
            
            if [[ "$INSTALLED" != "$EXPECTED_MAJOR" ]]; then
                echo -e "${RED}❌ VERSION MISMATCH${NC}"
                echo "FSD Locked:  Django $EXPECTED_MAJOR.x"
                echo "Installed:   Django $INSTALLED.x ($INSTALLED_FULL)"
                exit 1
            fi
            
            echo "✅ Django version: $INSTALLED_FULL"
        fi
        ;;
        
    "Go 1.23"*)
        EXPECTED="1.23"
        
        if [[ -f "go.mod" ]]; then
            INSTALLED=$(grep "^go " go.mod | awk '{print $2}')
            
            if [[ -z "$INSTALLED" ]]; then
                echo -e "${YELLOW}⚠️  Go version not specified in go.mod${NC}"
                exit 0
            fi
            
            if [[ "$INSTALLED" != "$EXPECTED"* ]]; then
                echo -e "${RED}❌ VERSION MISMATCH${NC}"
                echo "FSD Locked:  Go $EXPECTED.x"
                echo "Installed:   Go $INSTALLED"
                exit 1
            fi
            
            echo "✅ Go version: $INSTALLED"
        fi
        ;;
        
    *)
        echo -e "${YELLOW}⚠️  Unknown stack: $STACK${NC}"
        echo "Supported: Next.js 15, Laravel 11, Django 5, Go 1.23"
        echo "Skipping version validation"
        exit 0
        ;;
esac

echo ""
echo -e "${GREEN}✅ Framework version gate PASSED${NC}"
echo "Proceeding to development..."
