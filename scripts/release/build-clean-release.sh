#!/usr/bin/env bash
# build-clean-release.sh - Build a clean release branch (Model B: squash merge)
# Usage:
#   ./scripts/release/build-clean-release.sh <version> [--base <branch>] [--target <branch>]
# Example:
#   ./scripts/release/build-clean-release.sh v1.0.1
#
# What it does (Model B, squash merge, PR-friendly):
#   1. Creates release/<version> branch from the dev base branch.
#   2. Squash-merges it into the target branch (default: main) WITHOUT committing.
#   3. Removes every path listed in scripts/release/release-exclude.txt from the index.
#   4. Commits a single clean release commit.
#   5. Verifies no excluded path remains tracked; aborts if any leaked.
#   6. Prints the PR/push commands. Never pushes automatically.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
EXCLUDE_FILE="$SCRIPT_DIR/release-exclude.txt"

VERSION="${1:-}"
BASE="dev"
TARGET="main"

shift || true
while [ $# -gt 0 ]; do
  case "$1" in
    --base)   BASE="$2"; shift 2 ;;
    --target) TARGET="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version> [--base dev] [--target main]"
  echo "Example: $0 v1.0.1"
  exit 1
fi

if [ ! -f "$EXCLUDE_FILE" ]; then
  echo "❌ Missing exclusion list: $EXCLUDE_FILE"
  exit 1
fi

cd "$ROOT_DIR"

# Safety: working tree must be clean
if [ -n "$(git status --porcelain)" ]; then
  echo "❌ Working tree is dirty. Commit or stash your changes first."
  exit 1
fi

RELEASE_BRANCH="release/$VERSION"
echo "=== Building clean release $VERSION (squash model) ==="
echo "Base branch   : $BASE"
echo "Target branch : $TARGET"
echo "Exclude list  : $EXCLUDE_FILE"
echo "-----------------------------------------------------------"

# 1. Create release branch from base
git checkout "$BASE"
git checkout -B "$RELEASE_BRANCH"

# 2. Squash-merge into target (no commit yet)
git checkout "$TARGET"
# --allow-unrelated-histories: tolerate a target branch that started as an orphan
# (e.g. a clean 1-commit main with no shared ancestry with the dev base).
git merge --squash --allow-unrelated-histories "$RELEASE_BRANCH"

# 3. Strip excluded paths from the index
stripped=0
while IFS= read -r line; do
  line="${line%$'\r'}"   # strip trailing CR (file may be saved with CRLF on Windows)
  # skip blank/comment lines
  [ -z "$line" ] && continue
  case "$line" in \#*) continue ;; esac
  if git ls-files --error-unmatch "$line" >/dev/null 2>&1; then
    git rm -r --cached --quiet "$line"
    echo "  removed: $line"
    stripped=$((stripped + 1))
  fi
done < "$EXCLUDE_FILE"

echo "  stripped $stripped path(s) from index"

# 4. Commit single clean release commit
git commit -m "release: $VERSION"

# 5. Verify nothing excluded leaked into the commit
leaked=0
while IFS= read -r line; do
  line="${line%$'\r'}"
  [ -z "$line" ] && continue
  case "$line" in \#*) continue ;; esac
  if git ls-files --error-unmatch "$line" >/dev/null 2>&1; then
    echo "❌ LEAK: $line is still tracked on $TARGET"
    leaked=$((leaked + 1))
  fi
done < "$EXCLUDE_FILE"

if [ "$leaked" -gt 0 ]; then
  echo "❌ Release aborted: $leaked excluded path(s) leaked."
  exit 1
fi

echo "-----------------------------------------------------------"
echo "✅ Clean release commit created on '$TARGET' ($(git rev-parse --short HEAD))"
echo ""
echo "Next steps (run manually):"
echo "  git push origin $TARGET"
echo "  git push origin $RELEASE_BRANCH"
echo "  # Optional PR: open PR from $RELEASE_BRANCH into $TARGET"
