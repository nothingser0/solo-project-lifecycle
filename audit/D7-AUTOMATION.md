# Quality Automation Proposals (D7)
**Date**: 2026-10-02  
**Phase**: 2D Structure & Maintenance

---

## Executive Summary

**Goal**: Automate quality checks to catch errors before human review.

**Scope**: 8 automated checks + CI/CD workflow for PR validation.

**Cost**: ~2-5 min CI time per push. Minimal false positives with proper config.

**Maintenance**: Quarterly config updates (staleness rules, dictionary, thresholds).

---

## D7.1 Link Checker

### Tool
**markdown-link-check** (npm package)

**Command**:
```bash
npm install -g markdown-link-check
markdown-link-check --config .markdown-link-check.json *.md **/*.md
```

### Configuration File
**`.markdown-link-check.json`**:
```json
{
  "ignorePatterns": [
    {
      "pattern": "^#"
    }
  ],
  "timeout": "10s",
  "retryOn429": true,
  "retryCount": 3,
  "fallbackRetryDelay": "5s",
  "aliveStatusCodes": [200, 206, 301, 302, 308],
  "httpHeaders": [
    {
      "urls": ["https://"],
      "headers": {
        "User-Agent": "Mozilla/5.0"
      }
    }
  ]
}
```

### What It Catches
- ✅ Broken internal refs: `modules/05-non-existent.md`
- ✅ 404 external links: `https://example.com/broken-page`
- ✅ Typos in paths: `templates/arcive/` (should be `archive/`)

### False Positives
- ⚠️ Anchor links to generated sections (e.g., `#table-of-contents` in README)
- ⚠️ Links to local server: `http://localhost:3000`
- ⚠️ Rate-limited APIs (GitHub, LinkedIn)

### Mitigation
Use `ignorePatterns` config for known false positives:
```json
"ignorePatterns": [
  { "pattern": "^#" },
  { "pattern": "^http://localhost" },
  { "pattern": "^https://github.com/.*/tree/" }
]
```

### When to Run
- Pre-commit hook: Check staged .md files only (fast)
- CI: Check all files on PR (comprehensive)
- Monthly: Full external link check (catch link rot)

---

## D7.2 Fact Consistency Checker

### Tool
**Custom PowerShell script** (no existing tool fits)

### Script
**`scripts/check-fact-consistency.ps1`**:
```powershell
# Read all markdown files
$facts = @{}
Get-ChildItem -Recurse -Include *.md | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    
    # Extract payment terms
    if ($content -match 'Termin 4.*?(\d+)%?\s*-?\s*(\d+)%') {
        $range = "$($Matches[1])-$($Matches[2])"
        if (-not $facts.ContainsKey("Termin4")) {
            $facts["Termin4"] = @{}
        }
        $facts["Termin4"][$_.FullName] = $range
    }
    
    # Extract garansi periods
    if ($content -match 'garansi.*?(\d+)\s*(hari|days)') {
        $days = $Matches[1]
        if (-not $facts.ContainsKey("Garansi")) {
            $facts["Garansi"] = @{}
        }
        $facts["Garansi"][$_.FullName] = "$days hari"
    }
}

# Check for contradictions
foreach ($factType in $facts.Keys) {
    $values = $facts[$factType].Values | Select-Object -Unique
    if ($values.Count -gt 1) {
        Write-Host "⚠️  CONTRADICTION in $factType`:n" -ForegroundColor Yellow
        foreach ($file in $facts[$factType].Keys) {
            Write-Host "  $file : $($facts[$factType][$file])"
        }
    } else {
        Write-Host "✅ $factType consistent: $values" -ForegroundColor Green
    }
}
```

### What It Catches
- ✅ F001: Termin 4 "10-15%" vs "10-20%"
- ✅ Garansi period inconsistencies (30 vs 60 vs 90 days)
- ✅ SLA response time variations
- ✅ Training session count mismatches

### False Positives
- ⚠️ Context-specific variations (e.g., "10%" in different contexts: payment vs discount vs market share)

### Mitigation
Add context awareness:
```powershell
# Only check payment terms
if ($content -match 'Termin 4.*payment.*?(\d+)%') { ... }
```

### When to Run
- CI: On every PR touching modules/03, modules/11, templates/*SOW*
- Manual: Before each release (run on main branch)

---

## D7.3 markdownlint

### Tool
**markdownlint-cli** (npm package)

**Command**:
```bash
npm install -g markdownlint-cli
markdownlint --config .markdownlint.json **/*.md
```

### Configuration File
**`.markdownlint.json`**:
```json
{
  "default": true,
  "MD001": true,
  "MD003": { "style": "atx" },
  "MD004": { "style": "dash" },
  "MD007": { "indent": 2 },
  "MD013": false,
  "MD022": true,
  "MD024": { "siblings_only": true },
  "MD025": true,
  "MD026": false,
  "MD033": false,
  "MD041": false,
  "MD047": true
}
```

### Key Rules
- **MD001**: Heading levels increment by 1 only (no `##` → `####` skip)
- **MD003**: ATX-style headings (`##` not `Heading\n---`)
- **MD004**: Unordered lists use `-` consistently (not `*` or `+`)
- **MD007**: List indentation 2 spaces
- **MD013**: Line length limit (disabled - many lines >80 chars)
- **MD022**: Blank lines around headings
- **MD024**: Duplicate headings (allow if in different sections)
- **MD025**: Single H1 per file
- **MD033**: Allow inline HTML (needed for tables)
- **MD047**: Files end with newline

### What It Catches
- ✅ Heading hierarchy violations
- ✅ Inconsistent list markers
- ✅ Missing blank lines around headings
- ✅ Files without trailing newline

### False Positives
- ⚠️ MD013 (line length): Many tables exceed 80 chars - disabled
- ⚠️ MD026 (no trailing punctuation in headings): Some headings intentionally end with "?"

### When to Run
- Pre-commit hook: Check staged files (fast)
- CI: Check all files on PR

---

## D7.4 cspell (Spelling Checker)

### Tool
**cspell** (npm package)

**Command**:
```bash
npm install -g cspell
cspell --config cspell.json **/*.md
```

### Configuration File
**`cspell.json`**:
```json
{
  "version": "0.2",
  "language": "en,id",
  "dictionaries": [
    "en-US",
    "id-ID",
    "companies",
    "tech-stack",
    "indonesian-legal",
    "project-terms"
  ],
  "dictionaryDefinitions": [
    {
      "name": "tech-stack",
      "path": ".cspell/tech-stack.txt"
    },
    {
      "name": "indonesian-legal",
      "path": ".cspell/indonesian-legal.txt"
    },
    {
      "name": "project-terms",
      "path": ".cspell/project-terms.txt"
    }
  ],
  "words": [],
  "ignoreWords": [],
  "ignorePaths": [
    "node_modules",
    ".git",
    "audit"
  ]
}
```

### Custom Dictionaries

**`.cspell/tech-stack.txt`**:
```
nextjs
vercel
supabase
prisma
drizzle
shadcn
tailwindcss
midtrans
xendit
doku
mixpanel
amplitude
posthog
sentry
postgresql
redis
playwright
vitest
```

**`.cspell/indonesian-legal.txt`**:
```
kemenkop
kuhperdata
meterai
termin
garansi
pelunasan
uang muka
berita acara
serah terima
BAST
SOW
PRD
FSD
RBAC
UAT
SIT
```

**`.cspell/project-terms.txt`**:
```
zeenn
sisyphus
opencode
claude
cursor
jtbd
aarrr
rice
okr
wbs
mvp
poc
```

### What It Catches
- ✅ Typos: "inkan" → should be "ingin" (B017)
- ✅ Misspellings: "arhcitecture" → "architecture"
- ✅ Wrong language: "eksekusi" (ID) in English section

### False Positives
- ⚠️ Technical acronyms not in dictionary (add to custom dict)
- ⚠️ Indonesian words not in id-ID dict (add to indonesian-legal.txt)
- ⚠️ Proper nouns (company names, product names)

### When to Run
- CI: On every PR (fail on typos in prose, warn on code blocks)
- Local: Pre-commit hook (warn only, don't block)

---

## D7.5 Frontmatter Validation

### Tool
**Custom PowerShell script** (no existing tool)

### Script
**`scripts/validate-frontmatter.ps1`**:
```powershell
$requiredFields = @("name", "description")
$errors = @()

Get-ChildItem -Path . -Filter "SKILL.md" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    
    # Extract YAML frontmatter
    if ($content -match '(?s)^---\s*\n(.*?)\n---') {
        $yaml = $Matches[1]
        
        foreach ($field in $requiredFields) {
            if ($yaml -notmatch "$field\s*:") {
                $errors += "$($_.FullName) missing field: $field"
            }
        }
        
        # Validate YAML syntax (basic check)
        $lines = $yaml -split "\n"
        foreach ($line in $lines) {
            if ($line -notmatch '^\s*\w+\s*:' -and $line.Trim() -ne '') {
                $errors += "$($_.FullName) invalid YAML syntax: $line"
            }
        }
    } else {
        $errors += "$($_.FullName) missing frontmatter"
    }
}

if ($errors.Count -gt 0) {
    Write-Host "❌ Frontmatter validation failed:" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host "  $_" }
    exit 1
} else {
    Write-Host "✅ Frontmatter valid" -ForegroundColor Green
}
```

### What It Catches
- ✅ Missing required fields (`name`, `description`)
- ✅ Invalid YAML syntax (e.g., unquoted special chars)
- ✅ Missing frontmatter block in SKILL.md

### False Positives
- ⚠️ Multi-line descriptions (complex YAML) may fail basic parser

### When to Run
- CI: On PRs touching SKILL.md
- Local: Pre-commit hook for SKILL.md changes

---

## D7.6 Size/Token Checker

### Tool
**Custom PowerShell script**

### Script
**`scripts/check-token-budget.ps1`**:
```powershell
$thresholds = @{
    "SKILL.md" = 5000  # <5K tokens = ~20K chars
    "modules/*.md" = 8000  # <8K tokens = ~32K chars
}

$errors = @()

# Check SKILL.md
$skillSize = (Get-Content "SKILL.md" -Raw).Length
$skillTokens = [math]::Ceiling($skillSize / 4)
if ($skillTokens -gt $thresholds["SKILL.md"]) {
    $errors += "SKILL.md: $skillTokens tokens (limit: $($thresholds["SKILL.md"]))"
}

# Check modules
Get-ChildItem -Path modules -Filter *.md | ForEach-Object {
    $size = (Get-Content $_.FullName -Raw).Length
    $tokens = [math]::Ceiling($size / 4)
    if ($tokens -gt $thresholds["modules/*.md"]) {
        $errors += "$($_.Name): $tokens tokens (limit: $($thresholds["modules/*.md"]))"
    }
}

if ($errors.Count -gt 0) {
    Write-Host "⚠️  Token budget warnings:" -ForegroundColor Yellow
    $errors | ForEach-Object { Write-Host "  $_" }
    exit 1
} else {
    Write-Host "✅ Token budget OK" -ForegroundColor Green
}
```

### What It Catches
- ✅ SKILL.md >5K tokens
- ✅ Modules >8K tokens
- ✅ Warns before context window issues

### False Positives
- None (simple size check)

### When to Run
- CI: On every PR touching SKILL.md or modules/
- Local: Pre-commit hook (warn only)

---

## D7.7 Secret Detection

### Tool
**gitleaks** (pre-built binary)

**Command**:
```bash
# Install
curl -sSfL https://github.com/gitleaks/gitleaks/releases/download/v8.18.1/gitleaks_8.18.1_windows_x64.zip -o gitleaks.zip
unzip gitleaks.zip

# Run
./gitleaks detect --source . --verbose
```

### Configuration File
**`.gitleaks.toml`** (default config sufficient):
```toml
[extend]
useDefault = true

[[rules]]
id = "generic-api-key"
description = "Generic API Key"
regex = '''(?i)(api[_-]?key|apikey|secret[_-]?key)\s*[:=]\s*['"]?[a-z0-9]{20,}['"]?'''
```

### What It Catches
- ✅ API keys (Stripe, AWS, etc.)
- ✅ Tokens (GitHub personal access tokens)
- ✅ Passwords in code
- ✅ Private keys (.pem, .key files if committed)

### False Positives
- ⚠️ Example API keys in templates (e.g., `STRIPE_SECRET_KEY=sk_test_xxx`)

### Mitigation
Add to `.gitleaks.toml`:
```toml
[allowlist]
paths = [
    '''templates/.*TEMPLATE\.md''',
    '''.env.example'''
]
```

### When to Run
- Pre-commit hook: Block commits with secrets
- CI: Fail PR if secrets detected
- Monthly: Full history scan (catch past leaks)

---

## D7.8 YAML/JSON Validation in Code Blocks

### Tool
**Custom PowerShell script**

### Script
**`scripts/validate-code-blocks.ps1`**:
```powershell
$errors = @()

Get-ChildItem -Recurse -Include *.md | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    
    # Extract YAML code blocks
    $yamlBlocks = [regex]::Matches($content, '(?s)```yaml\s*\n(.*?)\n```')
    foreach ($match in $yamlBlocks) {
        $yaml = $match.Groups[1].Value
        try {
            # Simple YAML validation (check for basic syntax errors)
            if ($yaml -match '^\s*-\s*$' -or $yaml -match ':\s*$') {
                throw "Incomplete YAML"
            }
        } catch {
            $errors += "$($_.FullName): Invalid YAML block"
        }
    }
    
    # Extract JSON code blocks
    $jsonBlocks = [regex]::Matches($content, '(?s)```json\s*\n(.*?)\n```')
    foreach ($match in $jsonBlocks) {
        $json = $match.Groups[1].Value
        try {
            $null = ConvertFrom-Json $json -ErrorAction Stop
        } catch {
            $errors += "$($_.FullName): Invalid JSON block"
        }
    }
}

if ($errors.Count -gt 0) {
    Write-Host "❌ Code block validation failed:" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host "  $_" }
    exit 1
} else {
    Write-Host "✅ Code blocks valid" -ForegroundColor Green
}
```

### What It Catches
- ✅ Invalid JSON in ```json blocks
- ✅ Malformed YAML in ```yaml blocks
- ✅ Syntax errors in config examples

### False Positives
- ⚠️ Placeholder syntax (e.g., `{project_name}`) may fail JSON parsing

### Mitigation
Skip blocks with placeholders:
```powershell
if ($json -match '\{[a-z_]+\}') {
    # Skip placeholder JSON
    continue
}
```

### When to Run
- CI: On PRs touching templates/ or modules/ with code blocks
- Manual: Before release

---

## D7.9 CI/CD Workflow

### Tool
**GitHub Actions** (if repo is on GitHub)

### Workflow File
**`.github/workflows/quality-checks.yml`**:
```yaml
name: Quality Checks

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  quality:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: |
          npm install -g markdown-link-check markdownlint-cli cspell
      
      - name: Check links
        run: markdown-link-check --config .markdown-link-check.json **/*.md
        continue-on-error: true
      
      - name: Lint Markdown
        run: markdownlint --config .markdownlint.json **/*.md
      
      - name: Check spelling
        run: cspell --config cspell.json **/*.md
      
      - name: Validate frontmatter (PowerShell)
        if: runner.os == 'Linux'
        run: pwsh -File scripts/validate-frontmatter.ps1
      
      - name: Check token budget (PowerShell)
        if: runner.os == 'Linux'
        run: pwsh -File scripts/check-token-budget.ps1
      
      - name: Check fact consistency (PowerShell)
        if: runner.os == 'Linux'
        run: pwsh -File scripts/check-fact-consistency.ps1
      
      - name: Detect secrets
        uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Validate code blocks (PowerShell)
        if: runner.os == 'Linux'
        run: pwsh -File scripts/validate-code-blocks.ps1

  summary:
    needs: quality
    runs-on: ubuntu-latest
    steps:
      - name: Summary
        run: echo "✅ All quality checks passed"
```

### Execution Time
- **Link check**: ~1-2 min (depends on external links)
- **Markdown lint**: ~10-20 sec
- **Spelling**: ~15-30 sec
- **Custom scripts**: ~10-20 sec each
- **Secret detection**: ~20-30 sec
- **Total**: ~2-5 min per PR

### Cost
- GitHub Actions: 2,000 free minutes/month for public repos
- Estimated usage: 5 min × 20 PRs/month = 100 min/month (well within free tier)

### When It Runs
- **Push to main**: Full check suite
- **Pull Request**: Full check suite (blocks merge if fails)
- **Manual trigger**: Can be run via GitHub UI

---

## D7.10 Pre-commit Hook (Optional - Local Development)

### Tool
**Git hooks** (native)

### Hook File
**`.git/hooks/pre-commit`** (install manually):
```bash
#!/bin/bash

echo "Running pre-commit checks..."

# Get staged .md files
staged_md=$(git diff --cached --name-only --diff-filter=ACM | grep '.md$')

if [ -n "$staged_md" ]; then
    # Quick checks only (no network calls)
    echo "Checking markdown lint..."
    markdownlint --config .markdownlint.json $staged_md || exit 1
    
    echo "Checking spelling..."
    cspell --config cspell.json $staged_md || exit 1
    
    echo "Checking token budget..."
    pwsh -File scripts/check-token-budget.ps1 || exit 1
fi

echo "✅ Pre-commit checks passed"
exit 0
```

### Installation
```bash
# Make executable
chmod +x .git/hooks/pre-commit

# Or use husky (npm package)
npm install -g husky
husky install
husky add .git/hooks/pre-commit "pwsh -File scripts/pre-commit-checks.ps1"
```

### Trade-offs
- ✅ Catches errors before commit (early feedback)
- ✅ Faster than waiting for CI
- ⚠️ Slower commits (adds 5-10 seconds)
- ⚠️ Manual installation per developer

---

## D7.11 Maintenance Schedule

### Quarterly (Every 3 Months)
- [ ] Update cspell dictionaries (new tech terms, product names)
- [ ] Update markdownlint config (new rules if available)
- [ ] Review false positives, adjust ignore patterns
- [ ] Check for new linter versions (npm outdated)

### Annual (Yearly)
- [ ] Review all automation scripts (PowerShell version compatibility)
- [ ] Update token budget thresholds (if model context windows increase)
- [ ] Add new checks (e.g., accessibility linter for markdown)

### Ad-hoc (When Adding New Checks)
- [ ] Document in this file (D7)
- [ ] Add to CI workflow
- [ ] Test on sample files
- [ ] Communicate to contributors (if public repo)

---

## D7.12 Automation Summary

| Check | Tool | Runtime | False Positive Rate | Priority |
|-------|------|---------|---------------------|----------|
| Link checker | markdown-link-check | 1-2 min | Low (anchor links) | High |
| Fact consistency | Custom script | 10-20 sec | Medium (context-dependent) | High |
| Markdown lint | markdownlint-cli | 10-20 sec | Very Low | High |
| Spelling | cspell | 15-30 sec | Medium (technical terms) | Medium |
| Frontmatter | Custom script | 5 sec | Very Low | Medium |
| Token budget | Custom script | 5 sec | None | High |
| Secret detection | gitleaks | 20-30 sec | Low (examples) | High |
| Code block validation | Custom script | 10 sec | Low (placeholders) | Low |

**Total CI time**: ~2-5 min per PR

**Maintenance effort**: ~2 hours/quarter (dictionary updates, config tweaks)

**Value**: Catches 80%+ of quality issues before human review.

---

## D7.13 Recommended Implementation Order

### Phase 1 (Week 1): Core Linters
1. Install markdownlint + config
2. Install cspell + custom dictionaries
3. Add both to CI workflow
4. Fix existing violations (batch PR)

### Phase 2 (Week 2): Custom Scripts
1. Write token budget checker
2. Write fact consistency checker
3. Test on local machine
4. Add to CI workflow

### Phase 3 (Week 3): Security & Links
1. Install gitleaks
2. Install markdown-link-check
3. Configure ignore patterns (false positives)
4. Add to CI workflow

### Phase 4 (Week 4): Advanced Checks
1. Write frontmatter validator
2. Write code block validator
3. Add to CI workflow
4. Document in CONTRIBUTING.md

**Total setup time**: ~8-12 hours over 4 weeks

---

**End of D7 Automation Proposals**
