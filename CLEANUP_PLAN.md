# Framework Cleanup Plan - 2026-10-02

## Files to Delete (Redundancy & Obsolescence)

### 1. Archive Templates (36KB) - DELETE ✓
**Reason**: Superseded by consolidated templates in main directories

```bash
# Archive templates are OLD versions, modern consolidated versions exist:
templates/archive/commercial/SOW_CONTRACT_TEMPLATE.md          # → SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md
templates/archive/commercial/PROJECT_CHARTER_TEMPLATE.md       # Merged into SOW_CONTRACT_CONSOLIDATED
templates/archive/deploy/DEPLOYMENT_RUNBOOK_TEMPLATE.md        # → DEPLOYMENT_PROTOCOL_TEMPLATE.md
templates/archive/deploy/GO_LIVE_REPORT_TEMPLATE.md           # Outdated format
templates/archive/qa/SIT_REPORT_TEMPLATE.md                   # → SIT_WORKBOOK_TEMPLATE.md
templates/archive/qa/TEST_PLAN_SIT_TEMPLATE.md                # Merged into SIT_WORKBOOK
templates/archive/uat/UAT_SCENARIOS_TEMPLATE.md               # → UAT_WORKBOOK_TEMPLATE.md
templates/archive/uat/UAT_DEFECT_LOG_TEMPLATE.md              # Merged into UAT_WORKBOOK
```

**Impact**: -36KB, cleaner template directory
**Risk**: Low (all functionality in modern templates)

---

### 2. Audit Intermediate Files (200KB+) - DELETE SELECTIVE ✓

**Delete** (no longer needed post-remediation):
```bash
audit/00-inventory.md                  # 12KB - Initial scan, obsolete
audit/01-coverage.md                   # 195B - Superseded by REPORT.md
audit/03-dryrun.md                     # 3.5KB - Test run, obsolete
audit/AUDIT_COMPLETE.md                # 4.2KB - Superseded by REMAINING_FINDINGS_TODO
audit/coverage-matrix.md               # 24KB - Superseded by REPORT.md
audit/findings-initial.md              # 5.9KB - Superseded by findings.md
audit/progress.md                      # 6.2KB - Superseded by REMEDIATION_PROGRESS
audit/PRUNING_REPORT.md                # 17KB - One-time report, obsolete
audit/STYLE_GUIDE_PROPOSAL.md          # 29KB - Not implemented, outdated
```

**Keep** (still valuable):
```bash
audit/REPORT.md                        # 27KB - Primary audit report
audit/findings.md                      # 44KB - Detailed findings reference
audit/REMAINING_FINDINGS_TODO.md       # 4.1KB - Current status (59/59 fixed)
audit/LEGAL_REVIEW_TODO.md             # 3.5KB - F033-F037 pending
audit/REMEDIATION_PROGRESS.md          # 4.4KB - Historical remediation log
audit/REMEDIATION_FINAL_SUMMARY.md     # 5.7KB - Summary of fixes
audit/REFACTOR_PLAN.md                 # 29KB - D1-D9 structural improvements (future)
audit/REFERENCE_MAP.md                 # 30KB - Cross-reference index (valuable)
audit/FRAMEWORK_WEAKNESSES.md          # 15KB - Gap analysis (NEW, keep)
audit/POST_FIX_EVALUATION.md           # 18KB - Post-remediation assessment (NEW, keep)
audit/D6-MAINTENANCE.md                # 16KB - Maintenance patterns
audit/D7-AUTOMATION.md                 # 19KB - CI/CD recommendations
audit/D8-EVAL-TESTS.md                 # 16KB - Testing strategies
audit/D9-PORTABILITY.md                # 16KB - Cross-platform guide
audit/GLOSSARY.md                      # 16KB - Terminology reference
```

**Impact**: -100KB audit cleanup, keep valuable references
**Risk**: Low (deleted files are intermediate artifacts)

---

### 3. Outdated Content to Update (NOT delete)

**Google Stitch deprecation** (19 references):
- M04 still has legacy Stitch guidance (13 mentions)
- Already marked as "legacy optional" but should be cleaner
- Action: Add clear deprecation notice at top of M04

**Year references** (2024/2025):
- M04B: "emerging 2025-2026" → Update to "current 2026"
- M05B: Example timestamps 2024-01 → Update to 2026-10
- M05B: "migrate to v2 by 2024-12-31" → Update to "2027-06-30"
- Multiple references: Keep "deprecated 2024" (historical context OK)

**Impact**: Content accuracy, no file deletion
**Risk**: Low (cosmetic updates)

---

## Deletion Script

```bash
#!/bin/bash
# cleanup-framework.sh - Remove redundant files

echo "🗑️  Framework Cleanup - 2026-10-02"
echo ""

# 1. Delete archive templates (36KB)
echo "Deleting archive templates..."
rm -rf templates/archive/
echo "✅ Deleted: templates/archive/ (-36KB)"

# 2. Delete obsolete audit files (100KB)
echo ""
echo "Deleting obsolete audit files..."
cd audit/
rm -f 00-inventory.md
rm -f 01-coverage.md
rm -f 03-dryrun.md
rm -f AUDIT_COMPLETE.md
rm -f coverage-matrix.md
rm -f findings-initial.md
rm -f progress.md
rm -f PRUNING_REPORT.md
rm -f STYLE_GUIDE_PROPOSAL.md
cd ..
echo "✅ Deleted: 9 audit intermediate files (-100KB)"

# 3. Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Cleanup Summary:"
echo "  - Archive templates: DELETED (-36KB)"
echo "  - Audit intermediate: DELETED (-100KB)"
echo "  - Total saved: ~136KB"
echo ""
echo "Kept valuable files:"
echo "  - audit/REPORT.md (primary audit)"
echo "  - audit/findings.md (detailed reference)"
echo "  - audit/REFACTOR_PLAN.md (future roadmap)"
echo "  - audit/FRAMEWORK_WEAKNESSES.md (gap analysis)"
echo "  - audit/POST_FIX_EVALUATION.md (assessment)"
echo "  - All D6-D9 guides (maintenance/automation/portability)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
```

---

## Content Updates (No Deletion)

### Module 04: Google Stitch Deprecation Notice
```markdown
# At top of modules/04-uiux-prototyping.md:

> ⚠️ **GOOGLE STITCH DEPRECATED (2024)**: All references to Google Stitch below are LEGACY ONLY.
> Default workflow (2026): Create DESIGN.md + DESIGN_SPEC.md only (no Stitch).
> Alternative tools: v0.dev, shadcn/ui, Bolt.new (see TOOL_ALTERNATIVES.md).
```

### Year References Update
```bash
# M04B line: "emerging 2025-2026" → "standard 2026"
# M05B examples: 2024-01 → 2026-10
# M05B API deprecation: "2024-12-31" → "2027-06-30"
```

---

## Validation After Cleanup

```bash
# Before cleanup
du -sh templates/archive audit/
# templates/archive: 36K
# audit/: 725K

# After cleanup
du -sh templates/ audit/
# templates/: ~800K (-36K from archive)
# audit/: ~625K (-100K intermediate files)

# Verify essential files remain
ls -1 audit/REPORT.md audit/findings.md audit/REFACTOR_PLAN.md \
     audit/FRAMEWORK_WEAKNESSES.md audit/POST_FIX_EVALUATION.md
# All should exist

# Verify archive gone
ls templates/archive/
# Should return "No such file or directory"
```

---

## Recommendation

**Execute cleanup**: YES

**Reasoning**:
1. Archive templates are true duplicates (OLD versions)
2. Audit intermediate files served their purpose (remediation done)
3. Saves 136KB disk space
4. Reduces user confusion (fewer outdated files)
5. No functionality loss (all content preserved in modern versions)

**Exceptions** (DO NOT DELETE):
- audit/REPORT.md, findings.md, REFACTOR_PLAN.md (reference value)
- audit/FRAMEWORK_WEAKNESSES.md, POST_FIX_EVALUATION.md (NEW, valuable)
- audit/D6-D9 guides (future maintenance guidance)
- audit/REFERENCE_MAP.md, GLOSSARY.md (navigation aids)

---

## Execution Plan

1. **Commit current state** (safety checkpoint)
2. **Run cleanup script**
3. **Update M04 deprecation notice**
4. **Update year references**
5. **Commit cleanup** ("chore: remove redundant archive & audit intermediates")
6. **Verify framework still functional**

---

**Created**: 2026-10-02  
**Impact**: -136KB, cleaner structure  
**Risk**: Low (all deleted files redundant or obsolete)
