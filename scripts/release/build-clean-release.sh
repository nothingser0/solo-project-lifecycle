#!/usr/bin/env bash
# build-clean-release.sh - Build a clean release (Model B: release-branch squash)
# Usage:
#   ./scripts/release/build-clean-release.sh <version> [--base <branch>] [--target <branch>] [--keep-branch]
# Example:
#   ./scripts/release/build-clean-release.sh v1.0.1
#
# Workflow (produces a main branch whose history contains ONLY code changes,
# never any `git rm` of harness/docs):
#   1. Create release/<version> from the dev base branch.
#   2. Strip every path in release-exclude.txt ON THE RELEASE BRANCH (own commit).
#   3. Squash-merge the release branch into the target branch (main) and commit.
#   4. Verify the target tree tracks none of the excluded paths; abort if any leaked.
#   5. Delete the release branch (unless --keep-branch) and print push/tag steps.
# Never pushes automatically.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
EXCLUDE_FILE="$SCRIPT_DIR/release-exclude.txt"

VERSION="${1:-}"
BASE="dev"
TARGET="main"
KEEP_BRANCH=0

shift || true
while [ $# -gt 0 ]; do
  case "$1" in
    --base)        BASE="$2"; shift 2 ;;
    --target)      TARGET="$2"; shift 2 ;;
    --keep-branch) KEEP_BRANCH=1; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version> [--base dev] [--target main] [--keep-branch]"
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

# Read exclusion list into an array up front (paths may be removed mid-run).
EXCLUDES=()
while IFS= read -r line; do
  line="${line%$'\r'}"   # strip trailing CR (file may be saved with CRLF on Windows)
  [ -z "$line" ] && continue
  case "$line" in \#*) continue ;; esac
  EXCLUDES+=("$line")
done < "$EXCLUDE_FILE"

RELEASE_BRANCH="release/$VERSION"
echo "=== Building clean release $VERSION (release-branch squash) ==="
echo "Base branch   : $BASE"
echo "Target branch : $TARGET"
echo "Exclude list  : $EXCLUDE_FILE"
echo "-----------------------------------------------------------"

# 1. Create release branch from base
git checkout "$BASE"
git checkout -B "$RELEASE_BRANCH"

# 2. Strip excluded paths ON THE RELEASE BRANCH (so the target history stays clean)
stripped=0
for path in "${EXCLUDES[@]}"; do
  if git ls-files --error-unmatch "$path" >/dev/null 2>&1; then
    git rm -r --quiet "$path"
    echo "  stripped: $path"
    stripped=$((stripped + 1))
  fi
done
echo "  stripped $stripped path(s) on $RELEASE_BRANCH"

if [ "$stripped" -gt 0 ]; then
  git commit -m "chore(release): strip dev-only artifacts for $VERSION"
fi

# 3. Squash-merge into target and commit one release commit
git checkout "$TARGET"
# --allow-unrelated-histories: tolerate an orphan target (clean 1-commit main).
git merge --squash --allow-unrelated-histories "$RELEASE_BRANCH"
git commit -m "release: $VERSION"

# 4. Verify target tracks none of the excluded paths
leaked=0
for path in "${EXCLUDES[@]}"; do
  if git ls-files --error-unmatch "$path" >/dev/null 2>&1; then
    echo "❌ LEAK: $path is still tracked on $TARGET"
    leaked=$((leaked + 1))
  fi
done

if [ "$leaked" -gt 0 ]; then
  echo "❌ Release aborted: $leaked excluded path(s) leaked onto $TARGET."
  exit 1
fi

# 5. Delete release branch (unless requested to keep it)
if [ "$KEEP_BRANCH" -eq 0 ]; then
  git branch -D "$RELEASE_BRANCH" >/dev/null
  echo "  deleted branch $RELEASE_BRANCH"
fi

echo "-----------------------------------------------------------"
echo "✅ Clean release commit created on '$TARGET' ($(git rev-parse --short HEAD))"
echo ""
echo "Next steps (run manually):"
echo "  git push origin $TARGET"
echo "  git tag -a $VERSION -m \"Release $VERSION\""
echo "  git push origin $VERSION"
if [ "$KEEP_BRANCH" -eq 1 ]; then
  echo "  git push origin $RELEASE_BRANCH"
  echo "  # Open PR: $RELEASE_BRANCH -> $TARGET"
fi
