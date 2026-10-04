# Kesalahan di Session Ini (Improvement Notes)

Updated: 2026-10-03 (Extended with 21 new errors from second project)

---

## Session 1 Errors (11 issues - ALL FIXED)

### KATEGORI 1: Process & Workflow

✅ **#1-5**: All fixed (harness staging, version checks, npm fallback, advisory handling, Tailwind detection)

### KATEGORI 2: Technical Errors

✅ **#6-7**: Fixed (FK ordering anti-patterns guide, UUID pattern)
✅ **#8-9**: Fixed (peer deps + deprecated package checks)

### KATEGORI 3: Communication & Handoff

✅ **#10-11**: Fixed (security rule, completion checklist)

**Commits**: `565acda`, `a7bf48b`, `56d1d5e`, `d445f25`, `0efe13f`, `e34da53`, `fc5884b`

---

## Session 2 Errors (21 issues - NEW ANALYSIS)

### KATEGORI A: Dependency Management Errors (CRITICAL) ❌

#### 1. Zod v4 Incompatibility [NEEDS FRAMEWORK FIX]
- **Error**: Installed Zod v4.6.5 (latest) breaks react-hook-form + Supabase
- **Impact**: Runtime error - zodResolver is not a function
- **Root cause**: `pnpm add zod` pulls v4, didn't check peer dependencies
- **Fix needed**: Pre-install compatibility check + version pinning guide
- **Status**: ❌ Not prevented by current framework

#### 2. @hookform/resolvers v5 Incompatibility [NEEDS FRAMEWORK FIX]
- **Error**: v5 requires Zod v4, but ecosystem requires Zod v3
- **Impact**: Runtime error in form validation
- **Root cause**: Didn't check resolver compatibility matrix
- **Fix needed**: Add compatibility matrix to M06
- **Status**: ❌ Not prevented by current framework

#### 3. @supabase/auth-helpers-nextjs Deprecated [PARTIALLY COVERED]
- **Error**: Installed deprecated package
- **Impact**: No security updates
- **Root cause**: Didn't check deprecation before install
- **Fix needed**: Pre-install deprecation check script
- **Status**: ⚠️ Post-scaffold checklist mentions it, but no pre-install prevention

#### 4. Next.js 15.0.3 Security Vulnerability [DOCUMENTATION NEEDED]
- **Error**: CVE-2025-66478 warning ignored
- **Impact**: Security risk (unspecified)
- **Root cause**: Spec locked to 15.0.3, didn't document known risk
- **Fix needed**: Security risk documentation template
- **Status**: ❌ No guidance for spec-locked CVEs

#### 5. ESLint 9.39.5 Deprecated [LOW PRIORITY]
- **Error**: Dev dependency deprecated
- **Impact**: Low (not runtime)
- **Status**: ✅ Low priority, Next.js dependency

#### 6. shadcn-ui Package Deprecated [FALSE ALARM]
- **Context**: Intentional migration from npm package → CLI tool
- **Impact**: None (v2 CLI actively maintained)
- **Status**: ✅ Not an error, architectural change

---

### KATEGORI B: Version Mismatch & Compatibility ⚠️

#### 7. Tailwind v4 Surprise [PARTIALLY FIXED]
- **Error**: Scaffold installed v4, spec requires v3.4
- **Impact**: 60 min config rework
- **Root cause**: Didn't verify scaffold versions before running
- **Framework status**: ✅ M06 has version detection, but no pre-scaffold prevention
- **Enhancement needed**: Pre-scaffold version check guide

#### 8. Next.js 16 vs FSD Spec (Next.js 15) [PARTIALLY FIXED]
- **Error**: Scaffold installed v16, spec locked to v15
- **Impact**: 3x npm timeout (360s wasted)
- **Framework status**: ✅ M06 has version check, but no pinned scaffold command
- **Enhancement needed**: Add pinned version to scaffold command examples

#### 9. Type Mismatches (@types/react v19 vs React v18) [NEEDS FRAMEWORK FIX]
- **Error**: Types don't match runtime version
- **Impact**: Type errors in development
- **Root cause**: Scaffold auto-installed latest types
- **Fix needed**: Post-scaffold type version check
- **Status**: ❌ Not in current checklist

#### 10. eslint-config-next Version Mismatch [COVERED]
- **Error**: v16 with Next.js v15
- **Impact**: Lint rule mismatch
- **Framework status**: ✅ Already in M06 checklist (issue #4 from Session 1)

---

### KATEGORI C: Tool & Workflow Issues 🔧

#### 11. npm Timeout Loop (3x Retries) [FIXED]
- **Framework status**: ✅ M06 has auto-fallback to pnpm after 2x timeout

#### 12. Font Download Timeout (Geist from Google Fonts) [NEEDS PATTERN]
- **Error**: `next/font/google` CDN timeout
- **Impact**: Dev server won't start
- **Root cause**: Network blocking/slow, no fallback
- **Fix needed**: Add local font package pattern
- **Status**: ❌ No guidance in current framework

#### 13. SQL Migration FK Forward Reference [FIXED]
- **Framework status**: ✅ Anti-patterns guide in M06 (commit fc5884b)

#### 14. UUID Function Not Found (uuid_generate_v4) [FIXED]
- **Framework status**: ✅ Supabase migration pattern (commit fc5884b)

---

### KATEGORI D: Process & Verification Errors 📝

#### 15. TODO.md False Positives [NEEDS AGENT TRAINING]
- **Error**: Checked "Test: Create user" without actual testing
- **Impact**: False completion metric
- **Root cause**: Conflated "deployed" with "verified"
- **Fix needed**: Agent training - never check without execution
- **Status**: ❌ Agent behavior issue (not framework fix)

#### 16. Premature "Done" Declarations [PARTIALLY FIXED]
- **Error**: Declared "done" with version mismatches still existing
- **Framework status**: ✅ M06 has 18-point completion checklist (commit fc5884b)
- **Remaining**: Agent must follow checklist religiously

#### 17. Harness Files Premature Deployment [FIXED]
- **Framework status**: ✅ Staging workflow (commits 565acda-d445f25)

#### 18. No Post-Scaffold Verification [FIXED]
- **Framework status**: ✅ M06 verification function (commit e34da53)

---

### KATEGORI E: Knowledge Base & Model Issues 🤖

#### 19. Outdated Knowledge (Google Stitch Example) [UNFIXABLE]
- **Context**: Model cutoff April 2024, now October 2026 (18 month gap)
- **Impact**: False recommendations based on stale info
- **Status**: ❌ Model limitation (no real-time internet during generation)
- **Mitigation**: Always verify external claims via web search

#### 20. Package Deprecation Confusion (shadcn-ui) [DOCUMENTATION NEEDED]
- **Error**: Model sees "deprecated", assumes tool dead
- **Context**: v1 (npm) → v2 (CLI) = architectural migration, not abandonment
- **Fix needed**: Add "deprecation types" guide (critical/migration/abandonment)
- **Status**: ❌ No guidance in framework

#### 21. Peer Dependency Blindness [NEEDS FRAMEWORK FIX]
- **Error**: Installed packages without checking peer deps first
- **Impact**: 2 critical runtime errors (Zod v4, resolvers v5)
- **Root cause**: Didn't run `npm info <pkg> peerDependencies` before install
- **Fix needed**: Pre-install checklist + automation script
- **Status**: ❌ Not prevented by current framework

---

## Framework Fix Priority

### 🔴 HIGH PRIORITY (Blocking runtime errors)
1. **Pre-install peer dependency check** (#1, #2, #21)
   - Add to M06: "MANDATORY: npm info <pkg> peerDependencies before install"
   - Create check script: templates/scripts/check-dependencies.sh
   - Add compatibility matrices (Next.js ecosystem, form validation, Supabase)

2. **Dependency compatibility guide** (#1, #2, #9)
   - Zod v3 vs v4 compatibility matrix
   - @hookform/resolvers version mapping
   - @types/* must match runtime versions

3. **Font loading fallback strategy** (#12)
   - Add pattern: Local font packages vs CDN
   - Example: geist npm package vs next/font/google

4. **Security vulnerability documentation template** (#4)
   - How to document spec-locked CVEs
   - Decision matrix: upgrade vs document risk

### 🟡 MEDIUM PRIORITY (Time wasters, not blocking)
5. **Pre-scaffold version pinning guide** (#7, #8)
   - Add to M06: Pinned version examples (create-next-app@15)
   - Pre-check: npx create-next-app@latest --help

6. **Deprecation types guide** (#20)
   - Critical (security) vs Migration (architectural) vs Abandoned
   - How to interpret npm WARN deprecated messages

### 🟢 LOW PRIORITY (Agent training, not fixable in framework)
7. **Agent checklist discipline** (#15, #16)
   - Training: Never check TODO without execution
   - Training: Follow completion checklist before declaring "done"

8. **Model knowledge limitations** (#19)
   - Document: Cutoff date awareness
   - Mitigation: Use web_search for time-sensitive claims

---

## Commits Needed

### Commit 1: Dependency Pre-Install Checks (HIGH PRIORITY)
- `docs/modules/06-development-execution.md`: Add "Dependency Compatibility & Pre-Install Checks" section
  - Pre-install verification workflow
  - Compatibility matrices (Next.js, forms, Supabase)
  - Common errors with fixes (#1, #2, #9, #12)
- `templates/04-dev-execution/scripts/check-dependencies.sh`: Automated check script
- Update completion checklist: Add dependency compatibility checks

### Commit 2: Patterns & Templates
- `patterns/deployment/security-risk-documentation.md`: CVE handling for spec-locked versions
- `patterns/frontend/font-loading-strategies.md`: Local packages vs CDN
- `patterns/dependencies/deprecation-types.md`: How to interpret deprecation warnings

### Commit 3: Update IMPROVEMENT_NOTES.md
- Document all 21 new errors
- Mark framework-addressable vs unfixable
- Priority matrix

---

## Summary Stats

**Session 1**: 11/11 fixed (100%)
**Session 2**: 
- 21 new errors identified
- Framework-addressable: 13 (62%)
- Model limitations: 2 (10%)
- Agent training: 2 (10%)
- Already fixed/false alarm: 4 (19%)

**Total framework impact**: 24 addressable issues across 2 projects
