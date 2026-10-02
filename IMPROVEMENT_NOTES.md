# Kesalahan di Session Ini (Improvement Notes)

Updated: 2026-10-02

---

## KATEGORI 1: Process & Workflow

### ✅ 1. Harness Files Premature Deployment [FIXED]
- **Salah**: Generate langsung ke root sebelum scaffold selesai
- **Impact**: Harus manual move ke staging area
- **Root cause**: Ga baca M06 workflow (STEP 0 → STEP 1 sequence)
- **Fix Applied**: 
  - Commits: `565acda`, `a7bf48b`, `56d1d5e`, `d445f25`
  - Staging workflow: M01-M05 → `docs/harness-root/`, M06 → deploy to root
  - Updated: M04, M06, quickstart, templates/essentials

### ✅ 2. No Version Check Before Scaffold [FIXED]
- **Salah**: Assume create-next-app@latest = Next.js 15
- **Impact**: 60 min wasted (3x npm timeout + downgrade cycles)
- **Root cause**: Didn't check latest version first
- **Fix Applied**:
  - Commit: `e34da53`
  - Extended `verify_scaffold_matches_fsd()` with major version check
  - BLOCKING error if FSD version ≠ scaffold version

### ✅ 3. Stuck in npm Timeout Loop (3x) [FIXED]
- **Salah**: Retry npm 3 kali dengan same strategy
- **Impact**: 360 seconds wasted
- **Root cause**: Didn't pivot after 2nd failure
- **Fix Applied**:
  - Commit: `e34da53`
  - Added `install_dependencies_with_fallback()` function
  - 2x timeout → auto-switch to pnpm

### ✅ 4. Ignored Advisory Until Escalation [FIXED]
- **Salah**: Advisory 1-2 ignored, fixed only after blocker advisory 3
- **Impact**: User hampir mulai coding dengan broken dependencies
- **Root cause**: "Done bias" - rush to completion
- **Fix Applied**:
  - Commit: `e34da53`
  - Post-scaffold checklist: "Fix IMMEDIATELY before generating harness files"
  - Concern = pre-handoff blocker

---

## KATEGORI 2: Technical Errors

### ✅ 5. Tailwind v4 → v3 Migration Missed [FIXED]
- **Salah**: Generated harness files dengan v3 syntax while v4 installed
- **Impact**: Would break on first pnpm dev
- **Root cause**: No verification step after scaffold
- **Fix Applied**:
  - Commit: `e34da53`
  - Tailwind version detection in verification function
  - Returns `tailwind_version` flag for harness generation

### ❌ 6. SQL Migration FK Forward Reference [NOT FIXED IN FRAMEWORK]
- **Salah**: time_entries.invoice_id REFERENCES invoices(id) tapi invoices defined later
- **Impact**: Migration failed, had to regenerate
- **Root cause**: Copy-paste dari FSD.md tanpa check dependency order
- **Fix**: Topological sort tables (parents before children)
- **Status**: User-level error, not framework issue (FSD.md validation could help)

### ❌ 7. UUID Extension vs Built-in Function [NOT FIXED IN FRAMEWORK]
- **Salah**: Used uuid_generate_v4() (requires extension) instead of gen_random_uuid()
- **Impact**: Migration failed 2x
- **Root cause**: Copied old Postgres pattern (pre-13)
- **Fix**: For Supabase/modern Postgres: always use gen_random_uuid()
- **Status**: Could add to templates/patterns (Supabase migration pattern)

### ❌ 8. Missing Peer Dependency (@supabase/supabase-js) [NOT FIXED IN FRAMEWORK]
- **Salah**: Installed @supabase/ssr without peer dependency
- **Impact**: Would error on first import
- **Root cause**: Didn't read pnpm warnings
- **Fix**: After pnpm add, check [WARN] unmet peer dependency messages
- **Status**: Runtime detection, not framework issue

### ❌ 9. Deprecated Package Not Removed [NOT FIXED IN FRAMEWORK]
- **Salah**: @supabase/auth-helpers-nextjs installed despite deprecated
- **Impact**: Confusion (two auth patterns in codebase)
- **Root cause**: Ignored deprecation warning until blocker advisory
- **Fix**: Deprecation warning = immediate action
- **Status**: Could add to verification checklist (check for deprecated packages)

---

## KATEGORI 3: Communication & Handoff

### ✅ 10. Asked User to Paste Secret Keys in Chat [PREVENTED]
- **Salah**: "Reply dengan format: SERVICE: eyJhbGc..."
- **Impact**: Security risk (service_role key in chat history)
- **Root cause**: Didn't think about secret exposure
- **Advisory saved**: "Don't ask user to paste service_role key"
- **Fix**: NEVER ask for secrets. Guide user to paste directly into .env.local
- **Status**: Prevented by advisory system

### ⚠️ 11. Premature "Done" Declaration [PARTIALLY FIXED]
- **Salah**: Declared "M06 setup complete" while still had version mismatches
- **Impact**: User would hit errors immediately on first code
- **Root cause**: "Done bias" - want to finish, skip final verification
- **Fix Applied**:
  - Commit: `e34da53`
  - Post-scaffold checklist with explicit verification steps
- **Remaining**: Need agent training to follow checklist religiously

---

## Summary: Framework Fixes Applied

**Commits**: 8 total
- `565acda` - Harness staging workflow
- `a7bf48b` - M06 per-stack protocols
- `56d1d5e` - M04/quickstart DESIGN.md staging
- `d445f25` - templates/essentials staging
- `0efe13f` - Classification restructure
- `e34da53` - Comprehensive scaffold verification
- `95a0d28` - Framework repo safeguards
- `4d7231c` - Go WriteHeader bug

**Fixed Issues**: 5/11 (45%)
- ✅ Process workflow issues (#1-5)
- ❌ Technical errors (#6-9) - mostly runtime/user-level
- ⚠️ Communication (#10-11) - partially addressed

**Remaining Work**:
- Add Supabase migration patterns to templates/patterns/
- Add deprecated package detection to verification
- Agent training: follow checklists before declaring "done"
