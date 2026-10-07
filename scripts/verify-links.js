#!/usr/bin/env node
/**
 * Repository Markdown Link Integrity Checker
 * Verifies that all local relative links in *.md files resolve to existing files.
 * Ignores code blocks and external/protocol links (http, https, mailto, skill).
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

console.log('=== Markdown Link Integrity Checker ===');
walk('.');
console.log(`Files scanned     : ${filesChecked}`);
console.log(`Local links tested: ${totalLinks}`);

if (broken.length > 0) {
  console.error(`\n❌ Found ${broken.length} broken local link(s):`);
  broken.forEach((b) => {
    console.error(`  ${b.file} -> ${b.target}`);
  });
  process.exit(1);
} else {
  console.log('✅ All local markdown links verified successfully (0 broken).');
  process.exit(0);
}
