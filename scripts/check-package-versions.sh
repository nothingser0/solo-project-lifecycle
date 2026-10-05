#!/bin/bash
# Auto-Check Latest Package Versions
# Run before scaffold to verify current ecosystem state

set -e

FRAMEWORK="${1:-nextjs}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m'

echo -e "${CYAN}=== Package Version Auto-Check ===${NC}"
echo ""

check_package() {
    local pkg=$1
    local expected_major=$2
    
    echo -n "Checking $pkg..." >&2
    
    local latest=$(npm view "$pkg" version 2>/dev/null || echo "")
    local deprecated=$(npm view "$pkg" deprecated 2>/dev/null || echo "")
    
    if [ -z "$latest" ]; then
        echo -e " ${RED}FAILED${NC}" >&2
        return 1
    fi
    
    if [ -n "$deprecated" ]; then
        echo -e " ${RED}DEPRECATED${NC}" >&2
        echo -e "  ${YELLOW}Reason: $deprecated${NC}" >&2
        return 1
    fi
    
    local major=$(echo "$latest" | cut -d. -f1)
    
    if [ -n "$expected_major" ] && [ "$major" != "$expected_major" ]; then
        echo -e " ${YELLOW}v$latest (MISMATCH: expected v$expected_major)${NC}" >&2
        return 1
    fi
    
    echo -e " ${GREEN}v$latest${NC}" >&2
    echo "$latest|$major"  # stdout only - for capture
    return 0
}

case $FRAMEWORK in
    nextjs)
        echo -e "${CYAN}Framework: Next.js${NC}"
        echo ""
        
        next_info=$(check_package "next")
        react_info=$(check_package "react")
        react_dom_info=$(check_package "react-dom")
        types_react_info=$(check_package "@types/react")
        tailwind_info=$(check_package "tailwindcss")
        zod_info=$(check_package "zod")
        hook_form_info=$(check_package "react-hook-form")
        resolvers_info=$(check_package "@hookform/resolvers")
        eslint_next_info=$(check_package "eslint-config-next")
        supabase_ssr_info=$(check_package "@supabase/ssr")
        supabase_js_info=$(check_package "@supabase/supabase-js")
        
        # Extract versions
        next_ver=$(echo "$next_info" | cut -d'|' -f1)
        next_major=$(echo "$next_info" | cut -d'|' -f2)
        react_major=$(echo "$react_info" | cut -d'|' -f2)
        types_react_major=$(echo "$types_react_info" | cut -d'|' -f2)
        zod_major=$(echo "$zod_info" | cut -d'|' -f2)
        resolvers_major=$(echo "$resolvers_info" | cut -d'|' -f2)
        tailwind_major=$(echo "$tailwind_info" | cut -d'|' -f2)
        eslint_next_major=$(echo "$eslint_next_info" | cut -d'|' -f2)
        
        echo ""
        echo -e "${CYAN}=== Compatibility Analysis ===${NC}"
        echo ""
        
        # Check Next.js ecosystem
        if [ "$next_major" = "15" ]; then
            if [ "$react_major" != "19" ] && [ "$react_major" != "18" ]; then
                echo -e "${YELLOW}⚠ Next.js 15 requires React 19 or 18 (found React $react_major)${NC}"
            else
                echo -e "${GREEN}✓ Next.js + React compatible${NC}"
            fi
            
            if [ "$types_react_major" != "$react_major" ]; then
                echo -e "${YELLOW}⚠ @types/react should match React major version${NC}"
            fi
            
            if [ "$eslint_next_major" != "$next_major" ]; then
                echo -e "${YELLOW}⚠ eslint-config-next should match Next.js major version${NC}"
            fi
        elif [ "$next_major" = "16" ]; then
            echo -e "${YELLOW}⚠ Next.js 16 detected - verify React compatibility${NC}"
        fi
        
        # Check form validation stack
        if [ "$zod_major" = "4" ]; then
            echo -e "${YELLOW}⚠ Zod v4 incompatible with react-hook-form ecosystem${NC}"
            echo -e "${YELLOW}  Recommendation: Use Zod v3.x${NC}"
        fi
        
        if [ "$zod_major" = "3" ] && [ "$resolvers_major" != "3" ]; then
            echo -e "${YELLOW}⚠ @hookform/resolvers v3 required for Zod v3${NC}"
        fi
        
        if [ "$tailwind_major" = "4" ]; then
            echo -e "${YELLOW}⚠ Tailwind v4 has breaking config changes${NC}"
            echo -e "${YELLOW}  Recommendation: Use v3.x for stability${NC}"
        fi
        
        # Check deprecated packages
        auth_helpers_deprecated=$(npm view @supabase/auth-helpers-nextjs deprecated 2>/dev/null || echo "")
        if [ -n "$auth_helpers_deprecated" ]; then
            echo -e "${RED}✗ @supabase/auth-helpers-nextjs is deprecated${NC}"
            echo -e "${GREEN}  Use: @supabase/ssr (current official solution)${NC}"
        fi
        
        echo ""
        echo -e "${CYAN}=== Recommended Versions ===${NC}"
        echo ""
        echo "Scaffold command:"
        echo -e "  ${NC}npx create-next-app@$next_major my-app${NC}"
        echo ""
        echo "Safe dependency versions:"
        echo -e "  ${NC}pnpm add zod@^3.23.8${NC}"
        echo -e "  ${NC}pnpm add @hookform/resolvers@^3.9.1${NC}"
        echo -e "  ${NC}pnpm add react-hook-form@latest${NC}"
        echo -e "  ${NC}pnpm add @supabase/ssr@latest @supabase/supabase-js@latest${NC}"
        
        if [ "$tailwind_major" = "4" ]; then
            echo -e "  ${NC}pnpm add -D tailwindcss@^3.4.0 # Pin to v3 for stability${NC}"
        fi
        
        echo ""
        echo -e "${CYAN}=== Update FSD.md ===${NC}"
        echo ""
        echo "Update your FSD.md with current versions:"
        echo ""
        cat <<EOF
Framework: Next.js $next_ver (App Router)
Runtime: React $react_major
Styling: Tailwind CSS v3.4
Validation: Zod v3 + react-hook-form
Auth: Supabase (@supabase/ssr)
Database: PostgreSQL (Supabase)
EOF
        ;;
        
    laravel)
        echo -e "${CYAN}Framework: Laravel${NC}"
        echo ""
        
        echo "Checking PHP/Composer packages..."
        composer_ver=$(composer --version 2>/dev/null | grep -oP 'Composer version \K[0-9.]+' || echo "not installed")
        php_ver=$(php -v 2>/dev/null | head -1 | grep -oP 'PHP \K[0-9.]+' || echo "not installed")
        
        echo -e "PHP: ${GREEN}v$php_ver${NC}"
        echo -e "Composer: ${GREEN}v$composer_ver${NC}"
        
        echo ""
        echo "Recommended Laravel setup:"
        echo "  composer create-project laravel/laravel my-app"
        echo "  cd my-app && php artisan --version"
        ;;
        
    *)
        echo -e "${RED}Unknown framework: $FRAMEWORK${NC}"
        echo "Supported: nextjs, laravel"
        exit 1
        ;;
esac

echo ""
echo -e "${GRAY}Run this script before M05 (Tech Stack Decision) to verify current ecosystem state.${NC}"
echo -e "${GRAY}Generated: $(date -u +"%Y-%m-%d %H:%M:%S UTC")${NC}"
