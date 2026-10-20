#!/usr/bin/env node
/**
 * Repository Markdown Link Integrity Checker
 * Verifies that all local relative links in *.md files resolve to existing files.
 * Ignores code blocks and external/protocol links (http, https, mailto, skill).
 * Also checks module line-references (AUTHORITY.md cites `MM:NN` = docs/modules/MM_*.md
 * line NN) — a bare anchor that points at a blank line, a `---` separator or a code
 * fence means the citation drifted (a section was inserted above it), which is exactly
 * how AUTHORITY.md silently stopped pointing at the rule it claimed to cite.
 */

const fs = require('fs');
const path = require('path');

const linkPattern = /\[([^\]]+)\]\(([^)#\s]+)(?:#[^)]*)?\)/g;
const broken = [];
let totalLinks = 0;
let filesChecked = 0;

function walk(dir) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    if (entry.name === '.git' || entry.name === 'node_modules' || entry.name === 'dist') continue;
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      walk(full);
    } else if (entry.name.endsWith('.md')) {
      filesChecked++;
      let content = fs.readFileSync(full, 'utf8');
      // Strip fenced code blocks
      content = content.replace(/```[\s\S]*?```/g, '');
      let m;
      while ((m = linkPattern.exec(content)) !== null) {
        const target = m[2].trim();
        if (/^(https?:|mailto:|skill:|#)/.test(target)) continue;
        totalLinks++;
        const resolved = path.resolve(path.dirname(full), target);
        if (!fs.existsSync(resolved)) {
          broken.push({ file: full, target, resolved });
        }
      }
    }
  }
}

const MODULE_DIR = path.join('docs', 'modules');
const moduleFiles = fs.existsSync(MODULE_DIR)
  ? fs.readdirSync(MODULE_DIR).filter((f) => f.endsWith('.md'))
  : [];
const moduleByPrefix = {};
for (const f of moduleFiles) {
  const m = /^(\d{2})_/.exec(f);
  if (m) moduleByPrefix[m[1]] = f;
}
const lineRefIssues = [];
const contentByPrefix = {};
for (const [prefix, f] of Object.entries(moduleByPrefix)) {
  contentByPrefix[prefix] = fs.readFileSync(path.join(MODULE_DIR, f), 'utf8').split(/\r?\n/);
}
// Only AUTHORITY.md uses the `MM:NN` citation convention today.
const authFile = path.join('docs', 'AUTHORITY.md');
if (fs.existsSync(authFile)) {
  const lines = fs.readFileSync(authFile, 'utf8').split(/\r?\n/);
  lines.forEach((line, i) => {
    const refs = line.match(/\b(\d{2}):(\d{1,4})\b/g) || [];
    for (const ref of refs) {
      const [mm, nn] = ref.split(':');
      const content = contentByPrefix[mm];
      if (!content) continue; // not a module citation
      const idx = parseInt(nn, 10) - 1;
      const target = idx >= 0 && idx < content.length ? content[idx].trim() : null;
      if (target === null || target === '' || target === '---' || target.startsWith('```')) {
        lineRefIssues.push({ ref, at: `${authFile}:${i + 1}`, points: target === null ? '<out of range>' : JSON.stringify(target) });
      }
    }
  });
}

console.log('=== Markdown Link Integrity Checker ===');
walk('.');
console.log(`Files scanned     : ${filesChecked}`);
console.log(`Local links tested: ${totalLinks}`);

if (lineRefIssues.length > 0) {
  console.error(`\n❌ ${lineRefIssues.length} cross-reference(s) point at no content:`);
  lineRefIssues.forEach((b) => console.error(`  ${b.at} cites ${b.ref} -> ${b.points}`));
}

if (broken.length > 0 || lineRefIssues.length > 0) {
  if (broken.length > 0) {
    console.error(`\n❌ Found ${broken.length} broken local link(s):`);
    broken.forEach((b) => {
      console.error(`  ${b.file} -> ${b.target}`);
    });
  }
  process.exit(1);
} else {
  console.log('✅ All local markdown links + module line-references verified (0 broken).');
  process.exit(0);
}
