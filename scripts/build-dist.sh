#!/usr/bin/env bash
# build-dist.sh - Package framework for distribution and skill upload
# Usage: ./scripts/build-dist.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
DIST_PACKAGE="$DIST_DIR/package"

echo "=== Building Distribution Package ==="
echo "Target directory: $DIST_DIR"

rm -rf "$DIST_DIR"
mkdir -p "$DIST_PACKAGE"

# Copy root metadata and core files
cp "$ROOT_DIR/SKILL.md" "$DIST_PACKAGE/"
cp "$ROOT_DIR/README.md" "$DIST_PACKAGE/"
[ -f "$ROOT_DIR/CHANGELOG.md" ] && cp "$ROOT_DIR/CHANGELOG.md" "$DIST_PACKAGE/"
[ -f "$ROOT_DIR/SECURITY.md" ] && cp "$ROOT_DIR/SECURITY.md" "$DIST_PACKAGE/"

# Copy core skill directories
for dir in docs templates patterns references scripts; do
    if [ -d "$ROOT_DIR/$dir" ]; then
        echo "Copying $dir/..."
        cp -r "$ROOT_DIR/$dir" "$DIST_PACKAGE/"
    fi
done

# Build ZIP archive if zip utility is available
if command -v zip >/dev/null 2>&1; then
    echo "Creating ZIP bundle..."
    (cd "$DIST_PACKAGE" && zip -q -r "$DIST_DIR/solo-project-lifecycle.zip" .)
    echo "✅ ZIP bundle created: dist/solo-project-lifecycle.zip"
fi

TOTAL_DIST_FILES=$(find "$DIST_PACKAGE" -type f | wc -l)
DIST_SIZE=$(du -sh "$DIST_PACKAGE" | awk '{print $1}')

echo ""
echo "Distribution Build Summary:"
echo "  • Package directory: dist/package/ (Root SKILL.md ready for skill install)"
echo "  • Total files      : $TOTAL_DIST_FILES"
echo "  • Uncompressed size: $DIST_SIZE"
echo "✅ Build completed successfully."
