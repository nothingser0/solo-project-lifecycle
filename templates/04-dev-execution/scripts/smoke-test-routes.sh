#!/usr/bin/env bash
# smoke-test-routes.sh — Automated HTTP Route Smoke Test
# Usage: ./scripts/smoke-test-routes.sh [BASE_URL]

set -uo pipefail

BASE_URL="${1:-http://localhost:3000}"
SITEMAP_PATH="docs/specs/SITEMAP.md"
[ -f "$SITEMAP_PATH" ] || SITEMAP_PATH="SITEMAP.md"

echo "=== HTTP Route Smoke Test ($BASE_URL) ==="

ROUTES=()
if [ -f "$SITEMAP_PATH" ]; then
    while IFS= read -r line; do
        if echo "$line" | grep -qE "\|\s*/[a-zA-Z0-9_\-/:*]+"; then
            RAW_ROUTE=$(echo "$line" | grep -oE "/[a-zA-Z0-9_\-/:*]+" | head -n 1 || true)
            if [ -n "$RAW_ROUTE" ]; then
                TEST_ROUTE=$(echo "$RAW_ROUTE" | sed 's/:id/test-id/g' | sed 's/:token/test-token/g')
                ROUTES+=("$TEST_ROUTE")
            fi
        fi
    done < "$SITEMAP_PATH"
fi

if [ ${#ROUTES[@]} -eq 0 ]; then
    ROUTES=("/" "/login" "/dashboard")
fi

# Remove duplicates
UNIQUE_ROUTES=($(printf "%s\n" "${ROUTES[@]}" | sort -u))

FAILED_COUNT=0
PASSED_COUNT=0

for route in "${UNIQUE_ROUTES[@]}"; do
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" -m 5 "$BASE_URL$route" || echo "000")
    if [ "$STATUS" = "200" ] || [ "$STATUS" = "307" ] || [ "$STATUS" = "302" ]; then
        echo "  [PASS] ($STATUS) $route"
        PASSED_COUNT=$((PASSED_COUNT + 1))
    elif [ "$STATUS" = "404" ]; then
        echo "  [FAIL 404 NOT FOUND] $route"
        FAILED_COUNT=$((FAILED_COUNT + 1))
    else
        echo "  [WARN $STATUS] $route"
        if [ "$STATUS" -ge 500 ] || [ "$STATUS" = "000" ]; then
            FAILED_COUNT=$((FAILED_COUNT + 1))
        else
            PASSED_COUNT=$((PASSED_COUNT + 1))
        fi
    fi
done

echo ""
echo "Route Smoke Test Summary: $PASSED_COUNT Passed, $FAILED_COUNT Failed"

if [ $FAILED_COUNT -gt 0 ]; then
    echo "❌ Smoke test failed: $FAILED_COUNT route(s) returned 404 or server error!"
    exit 1
else
    echo "✅ All routes resolved successfully without 404 errors!"
    exit 0
fi
