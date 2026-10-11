#!/usr/bin/env node
/**
 * Index Manifest Generator & Two-Way Completeness Checker
 *
 * Modes:
 *   node scripts/verify/index-manifest.js          -> regenerate INDEX.json from filesystem
 *   node scripts/verify/index-manifest.js --check   -> verify INDEX.json <-> filesystem parity
 *
 * Why: the framework is large; agents route via an index instead of reading everything.
 * Prose indexes drift (files added but unlisted). This makes completeness machine-checkable:
 *   1. every tracked file MUST appear in INDEX.json
 *   2. every INDEX.json entry MUST resolve to a real file
 */

const fs = require('fs');
const path = require('path');

const ROOT = process.cwd();
const MANIFEST = path.join(ROOT, 'INDEX.json');

// Directories whose files must be fully indexed.
const TRACKED_DIRS = ['templates', 'references', 'patterns', 'docs/modules'];

// README catalogs used to derive the owning module per file.
const CATALOGS = [
  'templates/README.md',
  'references/README.md',
  'patterns/README.md',
  'docs/modules/README.md',
];

const SKIP = new Set(['.git', 'node_modules', 'dist', '.gitkeep']);

function walk(dir, acc = []) {
  if (!fs.existsSync(dir)) return acc;
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    if (SKIP.has(entry.name)) continue;
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) walk(full, acc);
    else acc.push(path.relative(ROOT, full).split(path.sep).join('/'));
  }
  return acc;
}

/**
 * Parse catalog READMEs for:
 *   - cataloged: any .md filename mentioned (markdown link OR bare name in a tree block)
 *   - modules:   "Module NN" (templates/references) or "**MNN**" (docs/modules) ownership
 */
function parseCatalogs() {
  const cataloged = new Set();
  const moduleMap = {};
  for (const cat of CATALOGS) {
    const abs = path.join(ROOT, cat);
    if (!fs.existsSync(abs)) continue;
    const catDir = path.dirname(cat);
    const lines = fs.readFileSync(abs, 'utf8').split(/\r?\n/);
    for (const line of lines) {
      // Links resolve relative to the catalog's directory.
      for (const m of line.matchAll(/\]\(\.?\/?([^)#\s]+)\)/g)) {
        const file = path.normalize(path.join(catDir, m[1])).split(path.sep).join('/');
        cataloged.add(file);
        cataloged.add(path.basename(file));
      }
      // Bare `name.md` tokens (tree blocks, prose) — match by basename only.
      for (const m of line.matchAll(/(`[\w./-]+(?:\.md|\.example)`)|\b([\w./-]+\.md)\b/g)) {
        const token = (m[1] || m[2] || '').replace(/[`]/g, '');
        cataloged.add(token.replace(/^\.\//, ''));
        cataloged.add(path.basename(token));
      }
      for (const m of line.matchAll(/([\w./-]+\.md)/g)) {
        cataloged.add(m[1].replace(/^\.\//, ''));
        cataloged.add(path.basename(m[1]));
      }
      const mod = line.match(/Module\s+(\d{2})/i) || line.match(/\*\*M(\d{2})\*\*/);
      if (mod) {
        for (const m of line.matchAll(/\]\(\.?\/?([^)]+\.md)\)/g)) {
          const file = path.normalize(path.join(catDir, m[1])).split(path.sep).join('/');
          if (!moduleMap[file]) moduleMap[file] = new Set();
          moduleMap[file].add(`M${mod[1]}`);
        }
      }
    }
  }
  const modules = {};
  for (const [k, v] of Object.entries(moduleMap)) modules[k] = [...v].sort();
  return { cataloged, modules };
}

function buildManifest() {
  const { cataloged, modules } = parseCatalogs();
  const files = [];
  for (const dir of TRACKED_DIRS) {
    for (const f of walk(path.join(ROOT, dir))) files.push(f);
  }
  files.sort();
  return {
    generated: 'scripts/verify/index-manifest.js',
    note: 'Machine-readable index. `cataloged: false` means no catalog README mentions the file (potential orphan).',
    files: files.map((f) => {
      const entry = { path: f, cataloged: cataloged.has(f) || cataloged.has(path.basename(f)) };
      const mods = modules[f];
      if (mods) entry.modules = mods;
      return entry;
    }),
  };
}

function loadManifest() {
  if (!fs.existsSync(MANIFEST)) return null;
  try {
    return JSON.parse(fs.readFileSync(MANIFEST, 'utf8'));
  } catch (e) {
    console.error(`❌ INDEX.json is not valid JSON: ${e.message}`);
    process.exit(1);
  }
}

const mode = process.argv.includes('--check') ? 'check' : 'generate';

if (mode === 'generate') {
  const manifest = buildManifest();
  fs.writeFileSync(MANIFEST, JSON.stringify(manifest, null, 2) + '\n');
  const orphans = manifest.files.filter((f) => !f.modules).length;
  console.log(`✅ INDEX.json generated: ${manifest.files.length} files (${orphans} without module mapping).`);
  process.exit(0);
}

// --check: two-way parity
const manifest = loadManifest();
if (!manifest) {
  console.error('❌ INDEX.json missing. Run: node scripts/verify/index-manifest.js');
  process.exit(1);
}

const onDisk = new Set();
for (const dir of TRACKED_DIRS) for (const f of walk(path.join(ROOT, dir))) onDisk.add(f);
const inManifest = new Set(manifest.files.map((f) => f.path));

const missingFromManifest = [...onDisk].filter((f) => !inManifest.has(f)).sort();
const staleInManifest = [...inManifest].filter((f) => !onDisk.has(f)).sort();

console.log('=== Index Manifest Parity Check ===');
console.log(`Tracked files on disk : ${onDisk.size}`);
console.log(`Entries in INDEX.json : ${inManifest.size}`);

if (missingFromManifest.length || staleInManifest.length) {
  if (missingFromManifest.length) {
    console.error(`\n❌ ${missingFromManifest.length} file(s) on disk NOT in INDEX.json:`);
    missingFromManifest.forEach((f) => console.error(`  + ${f}`));
  }
  if (staleInManifest.length) {
    console.error(`\n❌ ${staleInManifest.length} INDEX.json entr(ies) with no file on disk:`);
    staleInManifest.forEach((f) => console.error(`  - ${f}`));
  }
  console.error('\nRun: node scripts/verify/index-manifest.js');
  process.exit(1);
}

console.log('✅ INDEX.json is in two-way parity with the filesystem.');
process.exit(0);
