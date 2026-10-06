#!/bin/bash
# Dependency Compatibility Pre-Install Check
# Run before installing packages to verify compatibility

set -e

echo "=== Dependency Compatibility Check ==="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
ERRORS=0

# Check if package.json exists
if [ ! -f package.json ]; then
  echo -e "${RED}✗ package.json not found${NC}"
  exit 1
fi

echo "1. Checking peer dependencies..."
echo ""

# Check critical packages
PACKAGES=(
  "zod"
  "@hookform/resolvers"
  "@types/react"
  "@types/react-dom"
  "eslint-config-next"
  "tailwindcss"
)

for pkg in "${PACKAGES[@]}"; do
  if grep -q "\"$pkg\"" package.json; then
    INSTALLED_VERSION=$(grep "\"$pkg\"" package.json | sed 's/.*: "\^\?\([0-9]*\).*/\1/')
    echo -e "${GREEN}✓${NC} $pkg detected (v$INSTALLED_VERSION)"
    
    # Check peer dependencies
    PEER_DEPS=$(npm info $pkg peerDependencies 2>/dev/null || echo "")
    if [ -n "$PEER_DEPS" ]; then
      echo "  Peer dependencies:"
      echo "$PEER_DEPS" | sed 's/^/    /'
    fi
  fi
done

echo ""
echo "2. Checking for deprecated packages..."
echo ""

# Extract all dependencies
DEPS=$(grep -A 999 '"dependencies"' package.json | grep '":' | cut -d'"' -f2 | grep -v dependencies)
DEV_DEPS=$(grep -A 999 '"devDependencies"' package.json | grep '":' | cut -d'"' -f2 | grep -v devDependencies)

ALL_DEPS="$DEPS $DEV_DEPS"

for dep in $ALL_DEPS; do
  DEPRECATED=$(npm view $dep deprecated 2>/dev/null || echo "")
  if [ -n "$DEPRECATED" ]; then
    echo -e "${RED}✗ $dep${NC}: DEPRECATED"
    echo "  Reason: $DEPRECATED"
  fi
done

echo ""
echo "3. Checking version compatibility..."
echo ""

# Next.js ecosystem checks
NEXT_VERSION=$(grep '"next"' package.json | sed 's/.*: "\^\?\([0-9]*\).*/\1/' || echo "")
if [ -n "$NEXT_VERSION" ]; then
  echo "Next.js version: $NEXT_VERSION"
  
  # Check React version
  REACT_VERSION=$(grep '"react"' package.json | sed 's/.*: "\^\?\([0-9]*\).*/\1/' || echo "")
  TYPES_REACT_VERSION=$(grep '"@types/react"' package.json | sed 's/.*: "\^\?\([0-9]*\).*/\1/' || echo "")
  ESLINT_CONFIG_VERSION=$(grep '"eslint-config-next"' package.json | sed 's/.*: "\^\?\([0-9]*\).*/\1/' || echo "")
  
  # Validate
  if [ "$NEXT_VERSION" = "15" ] && [ "$REACT_VERSION" != "19" ] && [ "$REACT_VERSION" != "18" ]; then
    echo -e "${RED}✗ Version mismatch: Next.js 15 requires React 19 or 18 (found React $REACT_VERSION)${NC}"
    ERRORS=$((ERRORS + 1))
  else
    echo -e "${GREEN}✓ React version compatible${NC}"
  fi
  
  if [ "$REACT_VERSION" != "$TYPES_REACT_VERSION" ]; then
    echo -e "${YELLOW}⚠ Type mismatch: React $REACT_VERSION but @types/react $TYPES_REACT_VERSION${NC}"
  else
    echo -e "${GREEN}✓ React types match runtime${NC}"
  fi
  
  if [ "$NEXT_VERSION" != "$ESLINT_CONFIG_VERSION" ]; then
    echo -e "${YELLOW}⚠ Config mismatch: Next.js $NEXT_VERSION but eslint-config-next $ESLINT_CONFIG_VERSION${NC}"
  else
    echo -e "${GREEN}✓ ESLint config matches Next.js version${NC}"
  fi
fi

# Form validation stack
ZOD_VERSION=$(grep '"zod"' package.json | sed 's/.*: "\^\?\([0-9]*\).*/\1/' || echo "")
RESOLVERS_VERSION=$(grep '"@hookform/resolvers"' package.json | sed 's/.*: "\^\?\([0-9]*\).*/\1/' || echo "")

if [ -n "$ZOD_VERSION" ] && [ -n "$RESOLVERS_VERSION" ]; then
  echo ""
  echo "Form validation stack:"
  if [ "$ZOD_VERSION" = "3" ] && [ "$RESOLVERS_VERSION" != "3" ]; then
    echo -e "${RED}✗ Mismatch: Zod v3 requires @hookform/resolvers v3 (found v$RESOLVERS_VERSION)${NC}"
    ERRORS=$((ERRORS + 1))
  elif [ "$ZOD_VERSION" = "4" ] && [ "$RESOLVERS_VERSION" != "5" ]; then
    echo -e "${YELLOW}⚠ Warning: Zod v4 is incompatible with most ecosystem packages${NC}"
    echo -e "${YELLOW}  Recommendation: Downgrade to Zod v3.x${NC}"
  else
    echo -e "${GREEN}✓ Zod and resolvers compatible${NC}"
  fi
fi

echo ""
echo "=== Check Complete ==="
echo ""
echo "Next steps:"
echo "  1. Fix any RED errors before proceeding"
echo "  2. Review YELLOW warnings and assess impact"
echo "  3. Run: pnpm install"
echo "  4. Verify: pnpm list | grep -i invalid"

if [ "$ERRORS" -gt 0 ]; then
  exit 1
fi
exit 0
