#!/usr/bin/env node
/**
 * The two scaffolds (.sh and .ps1) must stage the same artifacts. They drifted once:
 * the shell scaffold copied the nine-file M06 harness and the A02-A04 artifacts while
 * the PowerShell one copied two harness files and no A-series documents, so a Windows
 * user following the same SKILL.md got a project that failed four gates.
 *
 * This compares the set of template filenames each scaffold references. It is a
 * superset check, not an order check: the scaffolds may stage in a different order.
 */
const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..', '..');
const FILES = {
  sh: 'scripts/scaffold/init-project.sh',
  ps1: 'scripts/scaffold/init-project.ps1',
};

// Only REAL copies count. Both scaffolds also `echo "  cp <template> <dest>"` as guidance
// for artifacts deferred to a later module; those are instructions to the user, not
// staging, and counting them makes the two files look more alike than they are.
//   sh:  cp "$TEMPLATES/02-design/X.md" "$TARGET_DIR/..."
//   ps1: Copy-Item (Join-Path $templates "02-design/X.md") (Join-Path ...) -Force
const REF = /^\s*(?:cp\s+"\$TEMPLATES\/|Copy-Item\s+\(Join-Path\s+\$templates\s+")([0-9A-Za-z_-]+\/[A-Za-z0-9_.-]+\.(?:md|yml|json))/gm;

function collect(rel) {
  const text = fs.readFileSync(path.join(ROOT, rel), 'utf8');
  const found = new Set();
  let m;
  while ((m = REF.exec(text)) !== null) found.add(m[1]);
  return found;
}

const sh = collect(FILES.sh);
const ps1 = collect(FILES.ps1);

const onlySh = [...sh].filter((f) => !ps1.has(f)).sort();
const onlyPs1 = [...ps1].filter((f) => !sh.has(f)).sort();

console.log('Scaffold parity check');
console.log(`  ${FILES.sh}:  ${sh.size} template references`);
console.log(`  ${FILES.ps1}: ${ps1.size} template references`);

// Files intentionally staged by one scaffold only. Keep this list empty unless the
// difference is a documented platform constraint; every entry needs a reason.
const ALLOWED = new Set([]);

const badSh = onlySh.filter((f) => !ALLOWED.has(f));
const badPs1 = onlyPs1.filter((f) => !ALLOWED.has(f));

if (badSh.length === 0 && badPs1.length === 0) {
  console.log('✅ Both scaffolds stage the same template set.');
  process.exit(0);
}

if (badSh.length) {
  console.error(`\n❌ Staged by ${FILES.sh} only:`);
  badSh.forEach((f) => console.error(`     ${f}`));
}
if (badPs1.length) {
  console.error(`\n❌ Staged by ${FILES.ps1} only:`);
  badPs1.forEach((f) => console.error(`     ${f}`));
}
console.error('\nA Windows user and a Unix user would get different projects. Mirror the branch.');
process.exit(1);
