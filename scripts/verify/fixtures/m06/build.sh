#!/usr/bin/env bash
# Install the M06 fixture into the repo so the regression suite can copy it.
# build.sh regenerates repo/ from the three generation passes (kept in this directory).
set -eu
HERE=$(cd "$(dirname "$0")" && pwd)
cd "$HERE"

# build from the generation passes, not from a copied tree
rm -rf repo
DBG=$(mktemp -d "${TMPDIR:-/tmp}/hermes-m06build.XXXXXX")
python3 "$HERE/build.py"       "$DBG"
python3 "$HERE/build2.py"      "$DBG"
python3 "$HERE/build3.py"      "$DBG"
# the two ported screens must be named so the gate can match them to SITEMAP
mkdir -p "$DBG/src/app/login" "$DBG/src/app/orders"; printf "export const screens = [\"SCR-001\"];\n" > "$DBG/src/app/login/screens.test.ts"
printf 'export const screens = ["SCR-002"];\n' > "$DBG/src/app/orders/screens.test.ts"
mv "$DBG" repo
echo "M06 fixture built at $HERE/repo"
