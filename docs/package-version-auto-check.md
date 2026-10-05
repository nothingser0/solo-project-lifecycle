# Package Version Auto-Check Solution

**Problem**: Framework guides become stale (model cutoff date = April 2024, now October 2026). Recommendations based on outdated package versions cause runtime errors.

**Solution**: Real-time version checking scripts + dynamic FSD.md generation.

---

## Usage

### Before M05 (Tech Stack Decision)

Run auto-check to get current ecosystem state:

```bash
# Bash (Linux/Mac/WSL)
./scripts/check-package-versions.sh nextjs

# PowerShell (Windows)
.\scripts\check-package-versions.ps1 -Framework nextjs
```

**Output**:
- ✓ Current stable versions
- ⚠ Deprecation warnings
- ⚠ Compatibility mismatches
- Recommended scaffold commands
- Safe dependency version pins

**Use output to update FSD.md with current versions.**

---

## What It Checks

### Next.js Ecosystem
- Framework versions (Next.js, React, React DOM)
- Type definitions (@types/react must match React)
- Tooling (eslint-config-next must match Next.js)
- Styling (Tailwind v3 vs v4 breaking changes)
- Validation (Zod v3 vs v4 compatibility)
- Auth (deprecated vs current packages)

### Compatibility Matrix
- Next.js 15 → React 18 (NOT 19)
- Zod v3 → @hookform/resolvers v3
- Zod v4 → incompatible with react-hook-form ecosystem
- Tailwind v4 → breaking config changes (use v3 for stability)

### Deprecation Detection
- @supabase/auth-helpers-nextjs → deprecated, use @supabase/ssr
- Package discontinued warnings
- Security vulnerability alerts

---

## Integration Points

### M05: Tech Stack Decision (FSD.md)

**Before writing FSD.md**:
1. Run auto-check script
2. Copy "Recommended Versions" output
3. Update FSD.md with current stable versions
4. Document any known issues (CVEs, deprecations)

**Example**:
```bash
./scripts/check-package-versions.sh nextjs > /tmp/versions.txt
# Copy recommended versions to FSD.md
```

### M06: Post-Scaffold Verification

**After scaffold, verify versions match FSD.md**:
```bash
# Check what was installed
grep '"next"' package.json
grep '"react"' package.json
grep '"tailwindcss"' package.json

# If mismatch: fix before generating harness files
pnpm add next@15 react@18 -D tailwindcss@3
```

---

## Why This Solution

### ❌ **Static guides** (current approach):
- Outdated after model cutoff (April 2024 → October 2026 = 18 months stale)
- Zod v4 released → breaks ecosystem
- Tailwind v4 released → breaking changes
- Packages deprecated → security risks

### ✅ **Dynamic checks** (this solution):
- Real-time npm registry queries
- Always current versions
- Catches deprecations immediately
- Compatibility analysis before install

---

## Trade-offs

### Approach 1: Scripts Query npm (CHOSEN)
**Pros**:
- Always up-to-date (queries live npm registry)
- Catches deprecations immediately
- Zero maintenance (npm is source of truth)
- Works offline (fails gracefully)

**Cons**:
- Requires npm installed
- Network dependency (but npm needed anyway)
- ~5 seconds runtime

### Approach 2: Web Search During Session
**Pros**:
- Can find blog posts, migration guides
- Human-readable context

**Cons**:
- Slower (10-30 seconds per search)
- Inconsistent results
- Can't batch check 10+ packages

### Approach 3: Hardcoded Version Matrix
**Pros**:
- Fast (no network)
- Predictable

**Cons**:
- Stale immediately after commit
- Maintenance burden (update every release)
- Same problem as static guides

---

## Best Practices

### 1. Run Before Every New Project
```bash
# Add to project initialization workflow
./scripts/check-package-versions.sh nextjs > docs/versions-$(date +%Y%m%d).txt
```

### 2. Update FSD.md With Output
```markdown
## Tech Stack (Verified 2026-10-03)

Framework: Next.js 15.0.3 (App Router)
Runtime: React 18.3.1
Styling: Tailwind CSS 3.4.14
Validation: Zod 3.23.8 + react-hook-form 7.53.0
Auth: Supabase (@supabase/ssr 0.5.2)

Source: ./scripts/check-package-versions.sh
```

### 3. Pin Versions in Scaffold Command
```bash
# ✅ Pinned (matches FSD.md)
npx create-next-app@15 my-app

# ❌ Rolling (could install Next.js 16)
npx create-next-app@latest my-app
```

### 4. Document Known Issues
```markdown
## Known Issues

- Next.js 15.0.3: CVE-2025-66478 (tracked, spec-locked)
- Zod v4: Incompatible with react-hook-form ecosystem (use v3.x)
- Tailwind v4: Breaking config changes (use v3.x for stability)
```

---

## Future Enhancements

### 1. Auto-Update FSD.md Template
```bash
# Generate FSD.md from script output
./scripts/generate-fsd.sh nextjs > docs/specs/FSD.md
```

### 2. CI/CD Integration
```yaml
# .github/workflows/check-versions.yml
name: Check Package Versions
on:
  schedule:
    - cron: '0 0 * * 0' # Weekly
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: ./scripts/check-package-versions.sh nextjs
      - name: Create issue if outdated
        if: failure()
        run: gh issue create --title "Package versions outdated"
```

### 3. Interactive Mode
```bash
./scripts/check-package-versions.sh nextjs --interactive
# Prompts: "Update FSD.md with these versions? [y/n]"
```

---

## Error Prevention Map

| Session 2 Error | Prevention Method |
|-----------------|-------------------|
| #1: Zod v4 incompatibility | Script warns "v4 incompatible with ecosystem" |
| #2: @hookform/resolvers v5 | Script checks Zod→resolver compatibility |
| #3: Deprecated packages | Script checks `npm view <pkg> deprecated` |
| #4: Security CVEs | Script detects + advises documentation |
| #7: Tailwind v4 surprise | Script warns "v4 breaking changes, use v3" |
| #8: Next.js 16 vs 15 spec | Script shows major version mismatch |
| #9: Type mismatches | Script validates @types/* match runtime |
| #12: Font CDN timeout | Script recommends local packages |
| #19: Outdated knowledge | Real-time npm queries bypass model cutoff |
| #20: Deprecation confusion | Script explains deprecation types |
| #21: Peer dep blindness | Script checks peer deps before install |

**Impact**: 11/21 Session 2 errors preventable with pre-flight checks.

---

## Usage in Framework

### Module 05: Tech Stack Decision
Add instruction:
```
STEP 0: Run version check script
./scripts/check-package-versions.sh nextjs

STEP 1: Review output for deprecations/incompatibilities
STEP 2: Update FSD.md with recommended versions
STEP 3: Document any known issues (CVEs, breaking changes)
```

### Module 06: Post-Scaffold Verification
Existing checklist already covers:
- Major version matches FSD.md
- Dependency compatibility checks
- Type version validation

Script provides **pre-scaffold** intelligence; M06 provides **post-scaffold** validation.

---

## Example Session

```bash
$ ./scripts/check-package-versions.sh nextjs

=== Package Version Auto-Check ===

Framework: Next.js

Checking next... v15.0.3
Checking react... v18.3.1
Checking tailwindcss... v3.4.14
Checking zod... v3.23.8
Checking @hookform/resolvers... v3.9.1
Checking @supabase/ssr... v0.5.2
Checking @supabase/auth-helpers-nextjs... DEPRECATED
  Reason: Package discontinued. Use @supabase/ssr

=== Compatibility Analysis ===

✓ Next.js + React compatible
✓ Zod and resolvers compatible
⚠ @supabase/auth-helpers-nextjs is deprecated
  Use: @supabase/ssr (current official solution)

=== Recommended Versions ===

Scaffold command:
  npx create-next-app@15 my-app

Safe dependency versions:
  pnpm add zod@^3.23.8
  pnpm add @hookform/resolvers@^3.9.1
  pnpm add react-hook-form@latest
  pnpm add @supabase/ssr@latest @supabase/supabase-js@latest

Run this script before M05 (Tech Stack Decision) to verify current ecosystem state.
Generated: 2026-10-03 04:13:40 UTC
```

Copy output → Update FSD.md → Proceed with confidence.
