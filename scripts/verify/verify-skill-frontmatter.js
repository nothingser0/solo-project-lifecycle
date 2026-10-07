#!/usr/bin/env node
/**
 * SKILL.md Frontmatter Validator
 * Ensures compliance with agent skill loader specifications.
 */

const fs = require('fs');
const path = require('path');

const skillPath = path.resolve('SKILL.md');
if (!fs.existsSync(skillPath)) {
  console.error('❌ SKILL.md not found in repository root');
  process.exit(1);
}

const content = fs.readFileSync(skillPath, 'utf8');
const match = content.match(/^---\r?\n([\s\S]*?)\r?\n---/);

if (!match) {
  console.error('❌ SKILL.md is missing YAML frontmatter delimiters (--- ... ---)');
  process.exit(1);
}

const frontmatter = match[1];
const fields = {};

frontmatter.split(/\r?\n/).forEach((line) => {
  const colonIdx = line.indexOf(':');
  if (colonIdx !== -1) {
    const key = line.slice(0, colonIdx).trim();
    const val = line.slice(colonIdx + 1).trim();
    fields[key] = val;
  }
});

const requiredKeys = ['name', 'description', 'version', 'updated'];
let hasErrors = false;

console.log('=== SKILL.md Frontmatter Validation ===');
for (const key of requiredKeys) {
  if (!fields[key]) {
    console.error(`❌ Missing or empty required key: "${key}"`);
    hasErrors = true;
  } else {
    console.log(`  ✅ ${key}: ${fields[key].length > 40 ? fields[key].slice(0, 37) + '...' : fields[key]}`);
  }
}

if (fields['name'] !== 'solo-project-lifecycle') {
  console.error(`❌ Unexpected skill name: "${fields['name']}", expected "solo-project-lifecycle"`);
  hasErrors = true;
}

if (hasErrors) {
  process.exit(1);
}

console.log('✅ SKILL.md frontmatter validation PASSED.');
process.exit(0);
