# Framework Version Policy

**Last Updated**: 2026-10-03  
**Next Review**: 2027-01-03 (quarterly)

---

## Supported Framework Versions

This skill maintains **tested harness templates** for specific framework major versions.

| Framework | Tested Version | Harness Path | Valid Until | Breaking Changes |
|:----------|:---------------|:-------------|:------------|:-----------------|
| **Next.js** | 15.x | `templates/04-dev-execution/nextjs/` | 2027-Q2 | 16.x: middleware→proxy |
| **Laravel** | 11.x | `templates/04-dev-execution/laravel/` | 2027-Q4 | - |
| **Django** | 5.x | `templates/04-dev-execution/django/` | 2027-Q3 | - |
| **Go** | 1.23.x | `templates/04-dev-execution/go/` | 2027-Q2 | - |

---

## Version Pinning Contract

### M05: Lock Exact Versions in FSD.md

**FSD.md MUST include exact framework versions:**

```markdown
## Stack Decision LOCKED: Next.js 15

**Framework Versions (Pinned):**
- Next.js: 15.0.3
- React: 19.0.0
- Node.js: 22.11.0 LTS
- TypeScript: 5.6.3

**Rationale**: Next.js 15 stable, tested harness available.
Next.js 16 (upcoming) has breaking changes (middleware→proxy).

**Upgrade Path**: When Next.js 16 stable + harness updated,
run migration: `npx @next/codemod@16 middleware-to-proxy .`
```

### M06: Enforce Version Gate

**MANDATORY check before coding:**

```bash
# Step 0.5: Version Gate (BEFORE scaffold)
./scripts/verify-framework-version.sh
```

**Gate checks:**
1. Installed version matches FSD locked version (major.minor)
2. If mismatch → FAIL with migration guide
3. If harness unavailable for version → FAIL with supported versions

---

## Version Mismatch Scenarios

### Scenario 1: User Installs Newer Major Version

**Problem:**
- FSD.md: Next.js 15.0.3
- Installed: `next@16.3.8` (via `pnpm create next-app@latest`)
- Harness: Next.js 15 templates (middleware.ts)
- Result: Breaking changes, warnings

**Solution:**
```bash
# Version gate fails at M06 Step 0.5
❌ VERSION MISMATCH DETECTED

FSD Locked: Next.js 15.0.3
Installed:  Next.js 16.3.8

Breaking changes in 16.x:
- middleware.ts → proxy.ts
- Sync request APIs removed
- Cache behavior changed

OPTIONS:
1. Downgrade to match FSD:
   npm install next@15.0.3

2. Update FSD + use Next.js 16 harness (if available):
   Check: templates/04-dev-execution/nextjs-16/
   
3. Migrate breaking changes manually:
   See: NEXTJS_16_MIGRATION.md
```

### Scenario 2: Harness Not Available for Version

**Problem:**
- FSD.md: Next.js 17.0.0
- Skill harness: Only Next.js 15.x, 16.x available

**Solution:**
```bash
❌ HARNESS UNAVAILABLE

Requested: Next.js 17.0.0
Available: 15.x, 16.x

OPTIONS:
1. Use latest supported version:
   Update FSD to Next.js 16.x
   
2. Use generic harness + official docs:
   Copy templates/04-dev-execution/nextjs-16/
   Read Next.js 17 migration guide
   Manually update AGENTS.md for breaking changes
```

---

## Scaffold Command Pinning

**M06 Step 1 MUST use pinned versions from FSD:**

### ❌ WRONG (Latest)
```bash
pnpm create next-app@latest  # Installs Next.js 16.x
```

### ✅ CORRECT (Pinned)
```bash
# Read FSD.md locked version: Next.js 15.0.3
pnpm create next-app@15.0.3

# Or manual scaffold with exact versions
npm install next@15.0.3 react@19.0.0 react-dom@19.0.0
```

---

## Quarterly Update Process

**Every 3 months (Jan/Apr/Jul/Oct):**

1. **Check new major versions:**
   - Next.js: Check latest stable
   - Laravel: Check LTS releases
   - Django: Check stable releases
   - Go: Check minor releases

2. **Evaluate breaking changes:**
   - Read official migration guides
   - Test with sample project
   - Document breaking changes

3. **Update harness templates:**
   - Create `templates/04-dev-execution/{stack}-{version}/`
   - Update AGENTS.md, CONVENTIONS.md for new syntax
   - Update quickstart guides

4. **Update version matrix:**
   - Mark old versions as deprecated
   - Update "Valid Until" dates
   - Add migration guides

---

## Migration Guide Template

When new major version released:

```markdown
# Next.js 15 → 16 Migration Guide

**Breaking Changes:**
1. middleware.ts → proxy.ts
2. Sync request APIs removed (cookies(), headers())
3. Cache behavior changed (default no-store)

**Migration Steps:**
1. Run codemod:
   npx @next/codemod@16 middleware-to-proxy .

2. Update async APIs:
   // Before (Next.js 15)
   const session = cookies().get('session')
   
   // After (Next.js 16)
   const session = (await cookies()).get('session')

3. Update cache directives:
   // Before
   export const revalidate = 60
   
   // After
   export const dynamic = 'force-static'
   export const revalidate = 60

**Harness Updates:**
- Copy templates/04-dev-execution/nextjs-16/
- Update AGENTS.md references
- Update TODO.md file paths
```

---

## Emergency Hotfix Process

If user stuck with version mismatch mid-project:

1. **Assess impact:**
   - Check breaking changes
   - Estimate migration effort (hours/days)

2. **Choose path:**
   - **Path A (Recommended)**: Downgrade to harness version
   - **Path B (Advanced)**: Manual migration + docs reading

3. **Document decision:**
   - Update project README with version lock
   - Add .nvmrc / .tool-versions for Node version
   - Pin all dependencies in package.json

---

## Version Gate Script

**scripts/verify-framework-version.sh:**
```bash
#!/bin/bash
# Version gate for M06 Step 0.5

FSD_FILE="docs/specs/FSD.md"
STACK=$(grep "Stack Decision LOCKED:" "$FSD_FILE" | cut -d: -f2 | xargs)

case "$STACK" in
  "Next.js 15")
    EXPECTED="15"
    INSTALLED=$(node -p "require('./package.json').dependencies.next" 2>/dev/null | cut -d. -f1)
    if [[ "$INSTALLED" != "$EXPECTED" ]]; then
      echo "❌ VERSION MISMATCH"
      echo "Expected: Next.js $EXPECTED.x"
      echo "Installed: Next.js $INSTALLED.x"
      exit 1
    fi
    ;;
  *)
    echo "⚠️  Stack not recognized: $STACK"
    exit 1
    ;;
esac

echo "✅ Framework version matches FSD"
```

---

**Policy Owner**: solo-project-lifecycle skill maintainers  
**Review Cycle**: Quarterly (Jan 1, Apr 1, Jul 1, Oct 1)
