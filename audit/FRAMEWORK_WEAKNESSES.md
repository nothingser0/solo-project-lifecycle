# Framework Weaknesses Analysis

**Date**: 2026-10-02  
**Scope**: Systematic review of solo-project-lifecycle framework  
**Status**: 14 critical gaps identified

---

## Executive Summary

Framework komprehensif (11K+ lines, 90+ templates, 17 modules) tapi punya **contradiction antara "solo dev efficiency" vs "enterprise documentation overhead"**. Fast-track claim "2-6 minggu" tidak realistis dengan beban baca 3000+ lines modules.

**Priority Fixes**:
1. **Legal liability** (unverified citations)
2. **Scale mismatch** (MVP overhead terlalu tinggi)
3. **No validation tools** (pure markdown, no automation)
4. **Missing examples** (zero real project walkthroughs)

---

## 1. Over-Documentation Bias (CRITICAL)

**Problem**: 
- 11,289 lines across 17 modules
- 90+ templates spanning 9 phases
- SKILL.md 283 lines just untuk overview
- User harus baca M04 (1612 lines) + M05 (1839 lines) + M06 (1612 lines) = **5063 lines** untuk "fast-track MVP"

**Impact**:
- Discovery cost tinggi (1-2 hari just baca dokumentasi)
- Cognitive overload → user skip docs → framework tidak dipakai
- Contradiction: "efficiency framework" butuh 2 hari setup

**Evidence**:
```bash
modules/06-development-execution.md: 1612 lines
modules/05-architecture-specs.md: 1839 lines
modules/04-uiux-prototyping.md: 1608 lines
```

**Fix**:
- [ ] Buat `QUICK_START_MVP.md` single-page (max 500 lines)
- [ ] Extract "Core Path" dari setiap modul (20% content, 80% value)
- [ ] Move deep-dives ke `/references/deep-dive/`

---

## 2. Template Fragmentation (HIGH)

**Problem**:
- 90 templates di 9 folder berbeda
- User harus read SKILL.md → identify phase → find template path → copy
- No central "template picker" tool

**Example Complexity**:
```
User: "Aku mau buat PRD"
Framework: 
  1. Read SKILL.md line 145
  2. Go to templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md
  3. Copy to docs/specs/PRD.md
  4. Read modules/05-architecture-specs.md (1839 lines) untuk filling guide
```

**Impact**: 
- 5-10 menit per template discovery
- 90 templates × 5 menit = **7.5 jam wasted** jika user butuh semua

**Fix**:
- [ ] Buat `scripts/template-picker.sh` interactive CLI
- [ ] Consolidate top 20 most-used templates ke `/templates/essentials/`
- [ ] Add template index: `TEMPLATE_INDEX.md` with use-case mapping

---

## 3. No Validation Tools (CRITICAL)

**Problem**: Framework pure markdown, zero automation untuk:
- ✗ Template completion check (apakah user sudah isi semua `[REQUIRED]` fields?)
- ✗ Gate criteria verification (apakah M03 DP benar-benar diterima?)
- ✗ Consistency check (apakah PRD.md sync dengan FSD.md?)
- ✗ Progress tracker (berapa % proyek selesai?)

**Impact**:
- User bisa skip critical gates tanpa detection
- No quality assurance untuk deliverables
- Framework jadi "checklist suggestion" bukan "enforcement tool"

**Comparison**:
| Feature | This Framework | Industry Standard (e.g., Jira/Linear) |
|---------|---------------|--------------------------------------|
| Gate automation | ❌ Manual | ✅ Workflow rules |
| Template validation | ❌ None | ✅ Required fields |
| Progress tracking | ❌ Manual | ✅ Burndown charts |
| Dependency check | ❌ None | ✅ Blocking issues |

**Fix**:
- [ ] `scripts/validate-gate.sh M03` → check DP received, SOW signed
- [ ] `scripts/lint-template.sh docs/specs/PRD.md` → check required fields
- [ ] `scripts/progress.sh` → parse TODO.md, show % completion

---

## 4. Indonesia Legal Dependencies (CRITICAL - LIABILITY RISK)

**Problem**:
- 109 mentions "UU PDP Pasal X" (unverified)
- KUHPerdata citations without Indonesian lawyer review
- F033-F037 audit findings: "Hire lawyer Rp 5-10M, 1-2 weeks"

**Legal Risk**:
- Providing legal advice without license → violation UU 18/2003 Advokat
- User mengikuti framework → contract invalid → sue framework author
- F034: "IP ownership KUHPerdata Pasal 1601" could be wrong citation

**Status**: `audit/LEGAL_REVIEW_TODO.md` documented but **NOT FIXED**

**Impact**:
- Framework unusable untuk commercial projects (legal uncertainty)
- Liability exposure untuk repository owner

**Fix**:
- [ ] **IMMEDIATE**: Add disclaimer "NOT LEGAL ADVICE, CONSULT LAWYER"
- [ ] Remove specific Pasal citations, replace with "consult UU PDP compliance lawyer"
- [ ] Hire Indonesian lawyer (Rp 5-10M) atau remove legal modules entirely

---

## 5. Missing Stack-Specific Guides (HIGH)

**Problem**:
- README claim "supports Next.js/Laravel/Django/Go/Flutter"
- M06 universal tapi tidak ada deep-dive per stack
- Template `AGENTS.md`, `TODO.md` generic (no Next.js App Router specifics)

**Reality Check**:
```bash
grep -r "Flutter" modules/ --include="*.md" | wc -l
# Output: 3 mentions (just in tables)

grep -r "App Router" modules/ --include="*.md" | wc -l  
# Output: 0 (Next.js 15 not covered)
```

**Impact**:
- User pick Laravel → framework tidak help dengan Eloquent specifics
- User pick Flutter → no BLoC/Riverpod guidance
- Generic advice = low value

**Fix**:
- [ ] Create `/references/stacks/nextjs-15-app-router.md` (500 lines)
- [ ] Create `/references/stacks/laravel-11-octane.md` (500 lines)
- [ ] Create `/templates/stack-specific/` with AGENTS_NEXTJS.md variants

---

## 6. Scale Mismatch: MVP Overhead (CRITICAL)

**Problem**:
- Fast-track claim "2-6 minggu MVP"
- Reality: Must read 3000+ lines modules even for MVP
- PROJECT_LITE_TEMPLATE.md exists tapi workflow still references full modules

**Breakdown**:
| Task | Framework Claim | Actual Time with Docs |
|------|----------------|----------------------|
| Setup | 1 hour | 1 day (read SKILL.md, find templates) |
| PRD/FSD | 4 hours | 2 days (read M05 1839 lines) |
| Design | 1 day | 3 days (read M04 1608 lines) |
| Coding | 2 weeks | 2 weeks + 1 day (read M06 1612 lines) |
| **Total** | **3 weeks** | **4-5 weeks** (overhead +33%) |

**Evidence**:
- SKILL.md line 74: "Kecil (MVP): 1-4 minggu"
- README line 81: "Fast-Track MVP (2-6 minggu)"
- Inconsistency + overhead tidak dihitung

**Fix**:
- [ ] Honest timing: "MVP 3-6 minggu (termasuk 3 hari baca framework)"
- [ ] True fast-track: single `MVP_PLAYBOOK.md` (300 lines max)
- [ ] Skip M00, M01, M02, M03, M04B, M05B, M06B, M07, M08, M09 untuk MVP

---

## 7. No Real Examples / Case Studies (HIGH)

**Problem**:
- Zero end-to-end project walkthroughs
- Modules punya "Contoh:" tapi synthetic (not real project)
- No timing actuals (M06 bilang "29-478 jam" tapi tidak ada proof)

**Missing**:
```
references/
├── case-studies/          # ❌ TIDAK ADA
│   ├── mvp-saas-2weeks/
│   ├── ecommerce-3months/
│   └── enterprise-6months/
└── examples/              # ❌ TIDAK ADA
    ├── PRD-real.md
    ├── FSD-real.md
    └── SOW-real.md
```

**Impact**:
- User tidak tahu "does this actually work?"
- No social proof
- Framework theoretical, not battle-tested

**Fix**:
- [ ] Document 3 real projects (anonymized):
  - Case Study 1: MVP SaaS inventory (solo dev, 4 minggu, Rp 20 juta)
  - Case Study 2: E-commerce (1 dev, 3 bulan, Rp 80 juta)
  - Case Study 3: Enterprise BUMN (konsultan, 6 bulan, Rp 500 juta)
- [ ] Add `references/examples/` dengan real PRD/FSD/SOW samples

---

## 8. Missing Anti-Patterns & Failure Modes (MEDIUM)

**Problem**:
- Tidak ada "When NOT to use this framework"
- Tidak ada "Common failure modes"
- Tidak ada "Break-even point for overhead"

**Questions Not Answered**:
- ❓ What if client refuses to pay DP? (framework bilang "no DP = no code" tapi no enforcement)
- ❓ What if UAT takes 6 months? (deemed acceptance clause tapi no real-world handling)
- ❓ What if solo dev sakit 2 minggu? (no contingency planning)

**Fix**:
- [ ] Add `ANTI_PATTERNS.md`:
  - "Don't use this for <2 week projects (overhead >50%)"
  - "Don't use this if client won't sign SOW (framework useless)"
  - "Don't use this for non-commercial projects (overkill)"
- [ ] Add "Common Pitfalls" section di setiap modul

---

## 9. Maintenance Burden (MEDIUM)

**Problem**:
- 11,289 lines across 17 modules
- 90 templates need updates when tools change
- Already has "[UPDATE 2026: Verify...]" warnings (tech debt starting)

**Decay Examples**:
```markdown
modules/00: "[UPDATE 2026: Verify latest BPS/Kemenkop UKM count]"
modules/04: "Google Stitch deprecated as of 2024" (framework still references)
modules/05: "Stripe pricing 2.9% + $0.30" (could change anytime)
```

**Impact**:
- Framework maintenance = part-time job (4-8 jam/bulan)
- Solo dev using this framework = maintaining TWO codebases (project + framework)

**Fix**:
- [ ] Extract volatile content ke `references/pricing/PRICING_2026.md`
- [ ] Add "Last Updated" timestamp per module
- [ ] Setup GitHub Action: monthly check for broken links / outdated pricing

---

## 10. Solo Dev Scalability Paradox (HIGH)

**Problem**: Framework untuk "solo dev" tapi:
- Butuh maintain 11K lines documentation
- Legal review Rp 5-10M (contradiction dengan solo budget)
- 90 templates × upkeep = overhead tinggi

**Reality Check**:
| Framework Claim | Solo Dev Reality |
|-----------------|------------------|
| "Efficiency framework" | 11K lines to maintain |
| "Fast-track 2-6 minggu" | +33% overhead from docs |
| "Legal compliance" | Rp 5-10M lawyer (unaffordable for many) |
| "Protection mechanisms" | Requires legal enforceability (costly) |

**Fix**:
- [ ] Rename to "Small Team / Technical Consultant Lifecycle" (more honest)
- [ ] Add "Lite Edition" for true solo dev (<Rp 50M budget projects)
- [ ] Separate legal modules to optional "Enterprise Addons"

---

## 11. Dependency on External Services (MEDIUM)

**Problem**: Framework heavily references tools yang bisa deprecated/pricing berubah:
- Google Stitch (already deprecated 2024)
- Mixpanel/Amplitude (pricing volatile)
- Railway/Vercel (pricing spikes common)
- Stripe/Midtrans (API changes)

**No Fallback Strategies**:
- M04: Stitch deprecated → modules still reference "Google Stitch Design System"
- M06B: "Mixpanel $25/mo" → actual pricing bisa 10x untuk volume tinggi
- M10: "Railway $5/mo" → actual Rp 500K/bulan for production

**Fix**:
- [ ] Add "Tool Alternatives Matrix":
  - Design: Stitch ❌ → v0.dev / shadcn/ui / Tailwind UI
  - Analytics: Mixpanel → Plausible / Umami (self-hosted)
  - Hosting: Railway → Coolify / Dokploy (self-hosted)
- [ ] Document migration paths when tools deprecate

---

## 12. No Versioning Strategy (LOW)

**Problem**:
- v1.0.0 git tag exists
- ❌ No CHANGELOG.md
- ❌ No MIGRATION.md
- ❌ Breaking changes policy unclear

**Impact**:
- User clone 6 bulan lalu → updates break their workflow
- No way to know "what changed since last use"

**Fix**:
- [ ] Create `CHANGELOG.md` (conventional commits format)
- [ ] Semantic versioning policy:
  - MAJOR: Module structure changes (M04 → M04A/M04B)
  - MINOR: Template additions
  - PATCH: Content updates, typo fixes
- [ ] Create `MIGRATION.md`: v0.x → v1.0 guide

---

## 13. No Self-Testing / Validation (MEDIUM)

**Problem**: Framework about SDLC best practices tapi:
- ❌ Framework itself not tested
- ❌ No user acceptance validation
- ❌ No benchmark against PMBOK/SWEBOK standards

**Questions**:
- Has anyone completed all 13 modules end-to-end?
- What's actual success rate vs failure rate?
- How does this compare to PMI standards?

**Fix**:
- [ ] Run pilot: 3 solo devs use framework, measure:
  - Time overhead
  - Deliverable quality
  - Client satisfaction
  - Commercial success (payment collected?)
- [ ] Document: `references/validation/PILOT_RESULTS.md`

---

## 14. Audit Findings Incomplete (LOW)

**Problem**:
- audit/REMAINING_FINDINGS_TODO.md: "59/59 fixed (100%)"
- Earlier grep found 163 "TODO" matches tapi mostly false positives
- Legal F033-F037: documented but NOT FIXED

**Discrepancy**:
```bash
grep -r "TODO\|FIXME\|PLACEHOLDER" modules/ templates/ | wc -l
# Output: 163 (mostly TODO.md harness file references + status labels)

grep -r "TODO:|FIXME:|XXX:" modules/ templates/ | wc -l
# Output: 0 (no actual incomplete work markers)
```

**Clarification**: 
- 163 matches = legitimate references to `TODO.md` template + status legends (`TODO`/`WIP`/`DONE`)
- 0 matches for actual work markers (`TODO:`, `FIXME:`, `XXX:`)
- **Audit 59/59 status is accurate**
- Real gap: 4 HIGH legal findings (F033-F037) documented but pending external lawyer

**Fix**:
- [x] Clarified: No actual TODO markers, audit status correct
- [ ] Update audit summary: "59/59 fixed, 4 HIGH pending external lawyer review (Rp 5-10M)"

---

## Priority Matrix

| Priority | Issue | Effort | Impact | Fix By |
|----------|-------|--------|--------|--------|
| **P0** | Legal liability | 2 weeks + Rp 10M | Repository liability | 2026-Q4 |
| **P0** | No validation tools | 40 hours | Framework unusable | 2026-Q4 |
| **P1** | Scale mismatch (MVP overhead) | 16 hours | User churn | 2026-Q4 |
| **P1** | Missing real examples | 24 hours | Trust issue | 2026-Q4 |
| **P1** | Template fragmentation | 12 hours | UX friction | 2026-Q4 |
| **P2** | Stack-specific guides | 60 hours | Low value | 2027-Q1 |
| **P2** | Over-documentation | 40 hours (pruning) | Cognitive load | 2027-Q1 |
| **P3** | Maintenance burden | Ongoing | Tech debt | 2027-Q2 |
| **P3** | Anti-patterns missing | 8 hours | Learning gap | 2027-Q2 |

---

## Recommendations

### Immediate (This Week)
1. **Add legal disclaimer** to README & modules with legal citations
2. **Create `QUICK_START_MVP.md`** (300 lines, skip 80% framework)
3. **Document 1 real case study** (even if anonymized synthetic)

### Short-term (This Month)
4. **Build validation scripts** (`validate-gate.sh`, `lint-template.sh`)
5. **Create template picker CLI** (`scripts/template-picker.sh`)
6. **Add CHANGELOG.md & versioning policy**

### Long-term (Next Quarter)
7. **Hire Indonesian lawyer** (Rp 5-10M) or remove legal modules
8. **Create stack-specific guides** (Next.js, Laravel, Django)
9. **Run pilot validation** (3 real projects, measure success)
10. **Extract "Lite Edition"** (true solo dev, <Rp 50M projects)

---

## Conclusion

Framework punya **foundation solid** (comprehensive, structured, protection-oriented) tapi suffer from **scope creep irony**: tool untuk prevent scope creep sendiri kena scope creep.

**Core tension**: 
- "Solo dev efficiency" ⚔️ "Enterprise documentation completeness"
- "Fast-track MVP" ⚔️ "Read 3000+ lines first"
- "Protection mechanisms" ⚔️ "No enforcement tools"

**Verdict**: Framework **production-ready untuk Menengah-Besar projects** (1-6 bulan, Rp 50M+) TAPI **overkill untuk true MVP** (<4 minggu, <Rp 20M).

**Recommended Split**:
- **Lite Edition**: 5 modules, 20 templates, 2000 lines (MVP focus)
- **Standard Edition**: Current 13 modules (Menengah-Besar)
- **Enterprise Edition**: +legal review, +compliance modules

---

**Next Action**: Review 14 kelemahan ini, prioritize P0-P1 fixes, decide: simplify atau embrace complexity?
