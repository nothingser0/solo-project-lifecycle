#!/usr/bin/env bash
# calculate-size.sh - Accurately calculate repository footprint and token counts
# Usage: ./scripts/calculate-size.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$ROOT_DIR"

echo "=== Framework Size & Token Metrics ==="
echo ""

# 1. Total File Counts excluding .git and node_modules
TOTAL_FILES=$(find . -not -path '*/.*' -not -path './node_modules*' -not -path './dist*' -type f | wc -l)
MD_FILES=$(find . -not -path '*/.*' -not -path './node_modules*' -not -path './dist*' -name '*.md' | wc -l)
SCRIPT_FILES=$(find . -not -path '*/.*' -not -path './node_modules*' -not -path './dist*' \( -name '*.sh' -o -name '*.ps1' -o -name '*.js' -o -name '*.ts' \) | wc -l)

# 2. Disk Size in MB
DISK_USAGE=$(du -sh --exclude='.git' --exclude='node_modules' --exclude='dist' . 2>/dev/null | awk '{print $1}' || echo "N/A")

# 3. Word & Estimated Token Counts across Markdown Documentation
TOTAL_WORDS=$(find . -not -path '*/.*' -not -path './node_modules*' -not -path './dist*' -name '*.md' -exec cat {} + | wc -w)
ESTIMATED_TOKENS=$(( TOTAL_WORDS * 4 / 3 ))

echo "Disk footprint (excl. .git) : $DISK_USAGE"
echo "Total files                 : $TOTAL_FILES"
echo "Markdown documentation files: $MD_FILES"
echo "Tooling & helper scripts    : $SCRIPT_FILES"
echo "Total document words        : $TOTAL_WORDS"
echo "Estimated framework tokens  : ~$ESTIMATED_TOKENS tokens"
echo ""
echo "Breakdown by Category:"
for dir in docs templates patterns references scripts; do
    if [ -d "$dir" ]; then
        dir_size=$(du -sh "$dir" 2>/dev/null | awk '{print $1}')
        dir_files=$(find "$dir" -type f | wc -l)
        printf "  • %-12s : %6s (%3d files)\n" "$dir" "$dir_size" "$dir_files"
    fi
done
echo "========================================"
