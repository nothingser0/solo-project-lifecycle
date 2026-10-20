#!/usr/bin/env bash
# install-git-hooks.sh - Installs pre-commit hook to automate verification
# Usage: ./scripts/verify/install-git-hooks.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
HOOKS_DIR="$ROOT_DIR/.git/hooks"

if [ ! -d "$HOOKS_DIR" ]; then
    echo "[ERROR] .git/hooks directory not found. Is this a git repository?"
    exit 1
fi

PRE_COMMIT="$HOOKS_DIR/pre-commit"

cat > "$PRE_COMMIT" << 'EOF'
#!/bin/sh
# pre-commit - Run framework integrity checks before commit
echo "=== Running Pre-Commit Verification ==="

if command -v powershell.exe >/dev/null 2>&1; then
    powershell.exe -ExecutionPolicy Bypass -File scripts/verify/verify-all.ps1
    exit $?
elif command -v pwsh >/dev/null 2>&1; then
    pwsh -File scripts/verify/verify-all.ps1
    exit $?
else
    bash scripts/verify/verify-all.sh
    exit $?
fi
EOF

chmod +x "$PRE_COMMIT"

echo "[OK] Pre-commit hook successfully installed at: $PRE_COMMIT"
echo "     All future commits will automatically validate integrity, links, and secrets."
