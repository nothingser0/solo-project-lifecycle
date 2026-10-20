#!/usr/bin/env node
/**
 * verify-no-secrets.js - Pre-flight scan for leaked credentials and live API keys
 * Ensures no live keys or private credentials are accidentally committed to the framework.
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const SECRET_PATTERNS = [
  {
    name: 'Private Encryption Key',
    regex: /-----BEGIN (?:RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----/,
  },
  {
    name: 'Live Stripe Secret Key',
    regex: /(?:sk_live|rk_live)_[0-9a-zA-Z]{24,}/,
  },
  {
    name: 'Live Midtrans Server Key',
    // Matches Mid-server- followed by 20+ chars, excluding obvious placeholders
    regex: /\bMid-server-[A-Za-z0-9_-]{20,}\b/,
    exclude: /Mid-server-(?:YOUR|YOUR_KEY|PLACEHOLDER|TEST|xxxx|X{4})/i,
  },
  {
    name: 'AWS Access Key ID',
    regex: /\bAKIA[0-9A-Z]{16}\b/,
    exclude: /AKIAIOSFODNN7EXAMPLE/,
  },
  {
    name: 'GitHub Personal Access Token',
    regex: /\bghp_[0-9a-zA-Z]{36}\b/,
  },
  {
    name: 'Slack Bot Token',
    regex: /\bxoxb-[0-9]{11,13}-[0-9]{11,13}-[a-zA-Z0-9]{24}\b/,
  },
];

const IGNORED_PATHS = [
  '.git',
  'node_modules',
  'dist',
  'scripts/verify/fixtures',
];

function getTrackedFiles() {
  try {
    const stdout = execSync('git ls-files', { encoding: 'utf8' });
    return stdout.split('\n').map(s => s.trim()).filter(Boolean);
  } catch {
    return [];
  }
}

function scanFile(filePath) {
  if (IGNORED_PATHS.some(p => filePath.startsWith(p))) {
    return [];
  }

  // Skip binaries
  const ext = path.extname(filePath).toLowerCase();
  if (['.png', '.jpg', '.jpeg', '.gif', '.ico', '.pdf', '.zip', '.tar', '.gz', '.woff', '.woff2'].includes(ext)) {
    return [];
  }

  if (!fs.existsSync(filePath)) return [];

  let content;
  try {
    content = fs.readFileSync(filePath, 'utf8');
  } catch {
    return [];
  }

  const findings = [];
  const lines = content.split('\n');

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    for (const rule of SECRET_PATTERNS) {
      if (rule.regex.test(line)) {
        if (rule.exclude && rule.exclude.test(line)) {
          continue;
        }
        findings.push({
          rule: rule.name,
          lineNum: i + 1,
          preview: line.trim().substring(0, 80),
        });
      }
    }
  }

  return findings;
}

function main() {
  const files = getTrackedFiles();
  let totalViolations = 0;

  console.log('=== Secret & Credential Pre-flight Guard ===');
  console.log(`Scanning ${files.length} tracked files for leaked keys...`);

  for (const f of files) {
    const violations = scanFile(f);
    if (violations.length > 0) {
      totalViolations += violations.length;
      for (const v of violations) {
        console.error(`  ❌ [${v.rule}] in ${f}:${v.lineNum}`);
        console.error(`     Snippet: ${v.preview}`);
      }
    }
  }

  if (totalViolations === 0) {
    console.log('✅ No leaked secrets or live credentials detected.');
    process.exit(0);
  } else {
    console.error(`\n❌ Failed: ${totalViolations} potential secret(s) found!`);
    process.exit(1);
  }
}

main();
