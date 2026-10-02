# Refactor Plan: solo-project-lifecycle
**Date**: 2026-10-02  
**Phase**: 2D Structure & Maintenance  
**Status**: DRAFT - Requires owner approval before execution

---

## Executive Summary

**Current State**: 140 .md files, ~447K tokens total, SKILL.md 7.2K tokens, largest modules 13.2K tokens. Token budget exceeds most model context windows when fully loaded. Duplication in gates, boilerplate, templates. PowerShell-only commands reduce portability. No versioning, changelog, or CI automation.

**Target State**: Modular architecture with shared protocols, reduced token load (SKILL.md <5K, modules <8K), extracted constants, environment adapters, phased refactor over 6 PRs with zero semantic changes to business logic.

**Token Savings**: Estimated 15-20K tokens via deduplication + extraction.

**Risk Level**: Medium (file moves + link updates). Mitigated by redirect stubs, automated link migration, and rollback plan per phase.

---

## D1: Architecture Analysis

### 1.1 Progressive Disclosure

**Current**: SKILL.md lines 77-93 list all 17 modules in detail. Agent forced to load entire instruction set.

**Issue**: No mechanism for "load only needed module". Instructions silent on progressive loading strategy.

**Recommendation**: 
- Create `INDEX.md` with full file inventory
- Trim SKILL.md module list to phase names only
- Add instruction: "Load specific module via skill_view() when entering that phase"

### 1.2 Token Budget

| File | Current Tokens | Target | Method |
|------|---------------|--------|--------|
| SKILL.md | 7,207 | <5,000 | Move detailed module list → INDEX.md |
| modules/05B | 13,251 | <8,000 | Split: 05B-scalability.md + 05B-caching.md |
| modules/06 | 12,500 | <8,000 | Split: 06-backend.md + 06-frontend.md |
| modules/05 | 12,034 | <8,000 | Split: 05-prd.md + 05-fsd.md |

**Estimated Savings**: 
- SKILL.md: 2.2K tokens saved
- Module splits: 0 (same content, better organization)
- Deduplication (gate protocols, boilerplate): ~3-5K tokens
- Total: ~5-7K tokens (1.1-1.6% reduction)

### 1.3 Module Splitting Thresholds

**Rule**: Module >10K tokens = candidate for split. Split at natural phase boundaries.

**05B Split**:
- `05B-scalability.md` (6.5K): Load balancing, HA, capacity planning
- `05B-caching.md` (6.7K): Redis, CDN, query optimization

**06 Split**:
- `06-backend.md` (6K): API, DB, auth, validation
- `06-frontend.md` (6.5K): UI assembly, states, components

**05 Split**:
- `05-prd.md` (5K): PRD, requirements, RBAC
- `05-fsd.md` (7K): FSD, tech stack, DB schema, API contracts

### 1.4 Orphan Files

**Found**: 
- `modules/04-uiux-prototyping.md.backup-20261001` (59KB) - backup file
- `templates/archive/orphans/*` (5 files) - unclear usage

**Action**: 
- Delete `.backup-*` files (use git history)
- Audit `templates/archive/orphans/` - move to `templates/deprecated/` if unused, or restore if referenced

---

## D2: Duplication Analysis

### 2.1 Gate Protocol Duplication

**Pattern**: Every module has identical gate verification structure.

**Example** (found in 16 modules):
```markdown
## [GATE CHECK BEFORE EXIT]

**Verification Protocol**:
- PowerShell: `Test-Path -LiteralPath "docs/pm/FILE.md"` → must return `True`
- File size > X bytes

**CRITICAL ERROR**: File FILE.md not created.

**EXIT PROTOCOL**:
1. **DILARANG KERAS** proceed to next module in same turn!
2. Display summary
3. End turn, wait for user approval
```

**Extraction Target**: `protocols/GATE_PROTOCOL.md`

**Usage**: Modules reference: `"See protocols/GATE_PROTOCOL.md for verification steps"`

**Savings**: ~3K tokens (16 modules × ~180 chars)

### 2.2 Mandatory Load Boilerplate

**Pattern**: Identical 6-line block in 14 modules.

**Example**:
```markdown
> ⚠️ **MANDATORY: Load references BEFORE executing this module**:
> - `references/improvements/MODUL_XX_IMPROVEMENTS.md` (...)
>
> Load via: `skill_view(name='solo-project-lifecycle', file_path='...')`
```

**Extraction Target**: `protocols/MANDATORY_LOAD.md`

**Usage**: Modules reference: `"Load requirements: See protocols/MANDATORY_LOAD.md"`

**Alternative**: Generate dynamic list per module in SKILL.md (less duplication but more complexity)

**Savings**: ~1.5K tokens

### 2.3 Error Message Templates

**Pattern**: 14 occurrences of `CRITICAL ERROR: File X.md tidak tercipta.`

**Extraction**: Not worth extracting (each is contextual). Keep inline.

### 2.4 Exit Checklist Duplication

**Pattern**: `DILARANG KERAS langsung melanjutkan...` appears in 11 modules with identical wording.

**Extraction Target**: `protocols/STOP_AT_GATE.md`

**Usage**: Modules reference: `"Stop protocol: See protocols/STOP_AT_GATE.md"`

**Savings**: ~1K tokens

### 2.5 Template Duplication

**Found**:
- `templates/01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md` (8.8KB)
- `templates/archive/commercial/SOW_CONTRACT_TEMPLATE.md` (6KB)

**Difference**: Consolidated version has milestone table, archive version more concise.

**Action**: 
- Compare content
- If >80% overlap, deprecate one (move to `templates/deprecated/`)
- Document which is canonical in SKILL.md

**Also Found**:
- 8 duplicate files in `templates/04-dev-execution/` vs `templates/04-dev-execution/root-harness/`
- Both have `AGENTS_TEMPLATE.md`, `ARCHITECTURE_TEMPLATE.md`, etc.

**Action**: Keep `root-harness/` subfolder (clearer purpose), remove duplicates from parent

---

## D3: Separation of Concerns

### 3.1 Environment Adapter Needed

**Issue**: PowerShell commands embedded in 14 modules.

**Examples**:
- `Test-Path -LiteralPath "docs/pm/FILE.md"`
- `Get-Content "docs/specs/FSD.md" -Raw`
- `$(date +%Y%m%d)` (bash mixed with PowerShell)

**Solution**: Create `adapters/` folder with equivalent commands per environment.

**Structure**:
```
adapters/
├── opencode/     # PowerShell (Windows)
├── cursor/       # bash/zsh (macOS/Linux)
├── claude-code/  # bash/zsh
└── generic/      # Platform-agnostic descriptions
```

**Example Adapter File** (`adapters/opencode/file-check.md`):
```markdown
# File Existence Check (OpenCode/PowerShell)
Test-Path -LiteralPath "path/to/file.md"
```

**Module Usage**: 
```markdown
Verify file exists:
- OpenCode: See adapters/opencode/file-check.md
- Cursor/Claude: See adapters/cursor/file-check.md
- Generic: Confirm file "path/to/file.md" exists
```

**Trade-off**: More files vs better portability. Choose portability.

### 3.2 Tech Stack Examples

**Issue**: 125 occurrences of stack-specific examples (Next.js, Laravel, Django, Flutter) in Module 06.

**Solution**: Extract to `stack-examples/` folder, parameterize instructions.

**Structure**:
```
stack-examples/
├── nextjs/
│   ├── scaffold.md      # pnpm create next-app
│   ├── migration.md     # Prisma/Drizzle
│   └── test.md          # npm run test
├── laravel/
│   ├── scaffold.md      # composer create-project
│   ├── migration.md     # artisan migrate
│   └── test.md          # php artisan test
└── ...
```

**Module 06 Instruction**:
```markdown
Execute scaffold for chosen stack (see stack-examples/{stack}/scaffold.md):
- Next.js: pnpm create next-app
- Laravel: composer create-project laravel/laravel
- Django: django-admin startproject
- Go: mkdir + go mod init
```

**Trade-off**: More files but cleaner core modules. Worth it for >5 stacks.

### 3.3 Scale-Specific Content

**Issue**: Fast-Track vs Menengah vs Besar vs Enterprise sections embedded in modules.

**Current Approach**: Conditional language like "SKIP jika: Fast-Track MVP"

**Assessment**: Current approach OK. Extraction would create 4× module files (too fragmented).

**Keep As-Is**: Use inline conditionals.

### 3.4 Legal/Jurisdiction Content

**Issue**: Indonesian law (UU PDP, UU ITE, KUHPerdata) embedded in 45 files.

**Solution**: Extract to `legal/indonesia/` for multi-jurisdiction support.

**Structure**:
```
legal/
└── indonesia/
    ├── UU_PDP.md        # UU No. 27/2022 summary
    ├── UU_ITE.md        # UU No. 19/2016 summary
    ├── KUHPerdata.md    # Contract law articles
    └── METERAI.md       # Stamp duty (UU No. 10/2020)
```

**Module Reference**: 
```markdown
Data protection compliance: See legal/indonesia/UU_PDP.md (Pasal 16, 57-59)
```

**Future**: Add `legal/singapore/`, `legal/malaysia/` as needed.

---

## D4: Naming Conventions

### 4.1 File Naming

**Pattern**: `{number}{letter?}-{kebab-case-title}.md`

**Examples**:
- `00-product-discovery-strategy.md` ✅
- `04A-design-system-foundation.md` ✅
- `05B-system-design-infrastructure.md` ✅

**Issue**: Letter suffix (A/B) inconsistent - when to use?

**Rule**: 
- Main module: `{NN}-title.md`
- Optional/specialized sub-module: `{NN}A-title.md`, `{NN}B-title.md`
- Example: 04 (main UI/UX), 04A (design system - optional)

**Sort Order**: Lexicographic works: 04 → 04A → 05 → 05B ✅

### 4.2 Folder Naming

**Current**:
- `templates/01-discovery-commercial/` (prefixed with phase number)
- `templates/archive/` (no prefix)
- `references/improvements/` (no prefix)

**Inconsistency**: Phase-numbered vs semantic names

**Recommendation**: Keep current (semantic is fine for references/, numbered is useful for templates/ to match modules)

### 4.3 Module IDs

**Current**: 00, 01, 02, 03, 04, 04A, 05, 05B, 06, 06B, 07, 08, 09, 10, 11, 12, 13

**Non-sequential**: 04A comes after 04, 05B after 05, 06B after 06

**Agent Parseable**: Yes (string sort works)

**Keep As-Is**: No change needed.

### 4.4 Artifact Naming

**Current**:
- Artifacts: `SCOPE_STATEMENT.md`, `PROJECT_CHARTER.md` (SCREAMING_SNAKE_CASE)
- Folders: `docs/pm/`, `docs/specs/` (lowercase)

**Inconsistency**: SCREAMING vs lowercase

**Rationale**: SCREAMING for important deliverables, lowercase for folders (common practice)

**Keep As-Is**: Convention is intentional.

### 4.5 Output Paths

**Current**:
- PM docs: `docs/pm/`
- Specs: `docs/specs/`
- Design: `docs/design/`
- Analytics: `docs/analytics/`
- Root harness: `./` (AGENTS.md, CONTEXT.md, etc.)

**Consistency**: ✅ Clear rules in SKILL.md:99-109

### 4.6 Text Terminology

**Inconsistencies Found**:
- "Single PIC" vs "PIC Klien" vs "Penanggung Jawab"
- "Termin" vs "Milestone" vs "Payment Stage"
- "BAST" vs "Berita Acara Serah Terima"

**Recommendation**: Add `constants/TERMINOLOGY.md`

**Content**:
```markdown
# Terminology Glossary

**Payment Terms**:
- Termin (ID) = Payment milestone/stage (EN)
- DP = Down Payment = Uang Muka

**Stakeholders**:
- Single PIC = PIC Klien = Client Point of Contact
- Penanggung Jawab = Authorized Representative

**Legal**:
- BAST = Berita Acara Serah Terima = Handover Certificate
- SOW = Statement of Work = Scope dokumen
```

---

## D5: Target Structure

```
solo-project-lifecycle/
├── SKILL.md (trimmed to <5K tokens)
├── README.md
├── LICENSE
├── INDEX.md (NEW - master file inventory)
├── TERMINOLOGY.md (NEW - term consistency)
│
├── modules/
│   ├── 00-product-discovery-strategy.md
│   ├── 01-idea-feasibility.md
│   ├── 02-discovery-scope.md
│   ├── 03-legal-sow-charter.md
│   ├── 04-uiux-prototyping.md
│   ├── 04A-design-system-foundation.md
│   ├── 05-prd.md (NEW - split from 05)
│   ├── 05-fsd.md (NEW - split from 05)
│   ├── 05B-scalability.md (NEW - split from 05B)
│   ├── 05B-caching.md (NEW - split from 05B)
│   ├── 06-backend.md (NEW - split from 06)
│   ├── 06-frontend.md (NEW - split from 06)
│   ├── 06B-product-instrumentation.md
│   ├── 07-quality-assurance-sit.md
│   ├── 08-data-migration-seeding.md
│   ├── 09-uat-client-signoff.md
│   ├── 10-deployment-production.md
│   ├── 11-handover-bast.md
│   ├── 12-warranty-sla-retainer.md
│   └── 13-product-operations-iteration.md
│
├── protocols/ (NEW - shared procedures)
│   ├── GATE_PROTOCOL.md
│   ├── MANDATORY_LOAD.md
│   └── STOP_AT_GATE.md
│
├── constants/ (NEW - SSOT for values)
│   ├── PAYMENT_TERMS.md        # Termin percentages 30-50%, 25%, 25%, 10-20%
│   ├── SLA_STANDARDS.md        # Response times, warranty periods
│   ├── DURATION_CONSTANTS.md   # Phase timelines (Module 00: 3-4wk, etc.)
│   └── TERMINOLOGY.md          # Term definitions
│
├── adapters/ (NEW - env-specific syntax)
│   ├── opencode/
│   │   ├── file-check.md
│   │   └── file-read.md
│   ├── cursor/
│   │   ├── file-check.md
│   │   └── file-read.md
│   └── generic/
│       └── descriptions.md
│
├── stack-examples/ (NEW - tech stack code)
│   ├── nextjs/
│   │   ├── scaffold.md
│   │   ├── migration.md
│   │   └── test.md
│   ├── laravel/
│   ├── django/
│   ├── go/
│   └── flutter/
│
├── legal/ (NEW - jurisdiction-specific)
│   └── indonesia/
│       ├── UU_PDP.md
│       ├── UU_ITE.md
│       ├── KUHPerdata.md
│       └── METERAI.md
│
├── templates/
│   ├── 01-discovery-commercial/
│   ├── 02-design/
│   ├── 03-architecture-specs/
│   ├── 04-dev-execution/
│   │   └── root-harness/ (keep subfolder, remove parent dupes)
│   ├── 05-data-migration/
│   ├── 06-qa-uat/
│   ├── 07-release-handover/
│   ├── 08-maintenance-ops/
│   ├── 09-product-growth/
│   └── deprecated/ (renamed from archive)
│
├── references/
│   ├── checklists/
│   ├── improvements/
│   ├── playbooks/
│   ├── pm/
│   ├── solo/
│   └── technical/
│
└── audit/ (temporary - not part of main skill)
```

---

## D6: File Migration Mapping

**Total**: 140 .md files → 155 .md files (15 new: splits + protocols + constants + adapters)

### New Files (15)

| New File | Source | Reason |
|----------|--------|--------|
| `INDEX.md` | Generated from file list | Master inventory |
| `protocols/GATE_PROTOCOL.md` | Extracted from 16 modules | DRY |
| `protocols/MANDATORY_LOAD.md` | Extracted from 14 modules | DRY |
| `protocols/STOP_AT_GATE.md` | Extracted from 11 modules | DRY |
| `constants/PAYMENT_TERMS.md` | Extracted from modules/03, 11, templates/SOW | SSOT |
| `constants/SLA_STANDARDS.md` | Extracted from modules/12 | SSOT |
| `constants/DURATION_CONSTANTS.md` | Extracted from references/improvements/ | SSOT |
| `constants/TERMINOLOGY.md` | New | Consistency |
| `modules/05-prd.md` | Split from `modules/05-architecture-specs.md` | Token budget |
| `modules/05-fsd.md` | Split from `modules/05-architecture-specs.md` | Token budget |
| `modules/05B-scalability.md` | Split from `modules/05B-system-design-infrastructure.md` | Token budget |
| `modules/05B-caching.md` | Split from `modules/05B-system-design-infrastructure.md` | Token budget |
| `modules/06-backend.md` | Split from `modules/06-development-execution.md` | Token budget |
| `modules/06-frontend.md` | Split from `modules/06-development-execution.md` | Token budget |
| `adapters/*/...` | Extracted from modules | Portability |

### Moved Files (2 folders)

| Old Path | New Path | Reason |
|----------|----------|--------|
| `templates/archive/*` | `templates/deprecated/*` | Clearer naming |

### Deleted Files (9)

| File | Reason |
|------|--------|
| `modules/04-uiux-prototyping.md.backup-20261001` | Use git history |
| `templates/04-dev-execution/AGENTS_TEMPLATE.md` | Duplicate of root-harness/ |
| `templates/04-dev-execution/ARCHITECTURE_TEMPLATE.md` | Duplicate of root-harness/ |
| `templates/04-dev-execution/CONTEXT_TEMPLATE.md` | Duplicate of root-harness/ |
| `templates/04-dev-execution/CONVENTIONS_TEMPLATE.md` | Duplicate of root-harness/ |
| `templates/04-dev-execution/ENV_EXAMPLE_TEMPLATE.md` | Duplicate of root-harness/ |
| `templates/04-dev-execution/TODO_TEMPLATE.md` | Duplicate of root-harness/ |

### Modified Files (Key Changes)

| File | Change | Impact |
|------|--------|--------|
| `SKILL.md` | Trim module list details → INDEX.md | -2.2K tokens |
| All 16 modules | Replace gate blocks with protocol ref | -3K tokens |
| All 14 modules | Replace mandatory load with protocol ref | -1.5K tokens |
| `modules/03-legal-sow-charter.md` | Reference constants/PAYMENT_TERMS.md | Consistency |
| `modules/11-handover-bast.md` | Reference constants/PAYMENT_TERMS.md | Consistency |
| `modules/06-development-execution.md` | Reference stack-examples/* | Cleaner |
| All modules with PowerShell | Add adapter references | Portability |
| All modules with UU PDP/ITE | Reference legal/indonesia/* | Cleaner |

---

## D7: Phased Execution (6 PRs)

### PR1: Foundation (Low Risk)

**Goal**: Create new folder structure, no content moves yet

**Actions**:
1. `mkdir protocols/ constants/ adapters/ stack-examples/ legal/`
2. Create empty placeholder files with headers
3. Add to .gitignore: `audit/`, `.sisyphus/`, `*.backup-*`

**Files Changed**: 
- `.gitignore` (modified)
- 15 new empty files (protocols/, constants/, adapters/, legal/, stack-examples/)

**Risk**: None (additive only)

**Acceptance**:
- [ ] All new folders created
- [ ] .gitignore updated
- [ ] No existing files modified

**Rollback**: `git revert HEAD` (pure additions)

### PR2: Extract Protocols (Medium Risk)

**Goal**: Extract shared gate/load/stop protocols, update module references

**Actions**:
1. Write `protocols/GATE_PROTOCOL.md` (extracted from modules)
2. Write `protocols/MANDATORY_LOAD.md`
3. Write `protocols/STOP_AT_GATE.md`
4. Update 16 modules: replace gate blocks with `"See protocols/GATE_PROTOCOL.md"`
5. Update 14 modules: replace mandatory load with `"See protocols/MANDATORY_LOAD.md"`
6. Update 11 modules: replace stop protocol with `"See protocols/STOP_AT_GATE.md"`

**Files Changed**:
- 3 new files (protocols/)
- 17 modules modified (10-50 lines each)

**Risk**: Broken refs if path wrong

**Acceptance**:
- [ ] All protocol files created with full content
- [ ] All 17 modules reference protocols/ correctly
- [ ] Manual spot-check: modules/03, 06, 11 render correctly
- [ ] No dead links (run link checker)

**Rollback**: `git revert HEAD` (modules restore inline protocols)

### PR3: Extract Constants (Medium Risk)

**Goal**: Create SSOT for payment terms, SLA, durations, terminology

**Actions**:
1. Write `constants/PAYMENT_TERMS.md` (from modules/03, 11, templates/SOW)
2. Write `constants/SLA_STANDARDS.md` (from modules/12)
3. Write `constants/DURATION_CONSTANTS.md` (from references/improvements/)
4. Write `constants/TERMINOLOGY.md` (new)
5. Update modules/03:73 → reference constants/PAYMENT_TERMS.md for termin 4
6. Update modules/11:20 → reference constants/PAYMENT_TERMS.md for termin 4
7. Update templates/SOW → reference constants/PAYMENT_TERMS.md

**Files Changed**:
- 4 new files (constants/)
- 3 files modified (modules/03, 11, templates/SOW)

**Risk**: If constants conflict with module text, confusion

**Acceptance**:
- [ ] All constant files created
- [ ] Payment term contradiction (F001) resolved: termin 4 = 10-20% everywhere
- [ ] Modules reference constants/ correctly
- [ ] No semantic changes (only extraction)

**Rollback**: `git revert HEAD`

### PR4: Reorganize Templates (Low Risk)

**Goal**: Rename archive/ → deprecated/, remove duplicate root-harness/ files

**Actions**:
1. `git mv templates/archive templates/deprecated`
2. Update SKILL.md references: `archive/` → `deprecated/`
3. Delete 7 duplicate files in `templates/04-dev-execution/` (keep root-harness/ only)
4. Delete `modules/04-uiux-prototyping.md.backup-20261001`

**Files Changed**:
- 1 folder renamed (templates/archive → templates/deprecated)
- SKILL.md (references updated)
- 8 files deleted (duplicates + backup)

**Risk**: Broken template refs in SKILL.md

**Acceptance**:
- [ ] templates/deprecated/ exists
- [ ] templates/archive/ does not exist
- [ ] SKILL.md references `deprecated/` correctly
- [ ] No duplicate files in templates/04-dev-execution/ (except root-harness/ subfolder)
- [ ] .backup-* files deleted

**Rollback**: `git mv templates/deprecated templates/archive` + `git revert` for deletions

### PR5: Split Large Modules (High Risk)

**Goal**: Split modules 05, 05B, 06 to meet <8K token budget

**Actions**:
1. Split `modules/05-architecture-specs.md` → `05-prd.md` + `05-fsd.md`
2. Split `modules/05B-system-design-infrastructure.md` → `05B-scalability.md` + `05B-caching.md`
3. Split `modules/06-development-execution.md` → `06-backend.md` + `06-frontend.md`
4. Update SKILL.md module list: add new split modules
5. Archive original combined files → `modules/deprecated/` (keep for 1 release)

**Files Changed**:
- 6 new module files (splits)
- SKILL.md (module list updated)
- 3 files moved to modules/deprecated/

**Risk**: References to old module paths break

**Acceptance**:
- [ ] All 6 new module files <8K tokens each
- [ ] Content preserved 100% (no semantic changes)
- [ ] SKILL.md module list includes splits
- [ ] Old files in modules/deprecated/ with redirect comment
- [ ] Token count verification: all modules <8K

**Rollback**: `git mv modules/deprecated/* modules/` + revert SKILL.md

### PR6: Finalize - INDEX.md & Trim SKILL.md (Medium Risk)

**Goal**: Create master INDEX.md, trim SKILL.md to <5K tokens

**Actions**:
1. Generate `INDEX.md` with full file inventory (140+ files)
2. Trim SKILL.md lines 77-93: replace detailed module list with phase names only
3. Add instruction in SKILL.md: "See INDEX.md for full file inventory"
4. Add instruction: "Load specific module via skill_view() when entering phase"

**Files Changed**:
- 1 new file (INDEX.md)
- SKILL.md (trimmed)

**Risk**: Agent can't find files without detailed module list

**Acceptance**:
- [ ] INDEX.md created with all 140+ files listed
- [ ] SKILL.md <5K tokens (verify with wc -c)
- [ ] SKILL.md references INDEX.md
- [ ] Progressive loading instruction added
- [ ] Token count: SKILL.md ~4.8K tokens (saved 2.4K)

**Rollback**: `git revert HEAD` (restore detailed module list in SKILL.md)

---

## D8: Semantic vs Structural Changes

**Principle**: Refactor = structural only. Business logic untouched.

| Change Type | Examples | Requires Owner Approval? |
|-------------|----------|-------------------------|
| **Structural** | File moves, renames, folder reorg, link updates | No (safe refactor) |
| **Structural** | Extraction to protocols/, constants/ (content preserved) | No (DRY principle) |
| **Structural** | Module splits (content 100% preserved) | No (organization) |
| **Semantic** | Changing termin 4 from "10-15%" to "10-20%" | **YES** (business rule) |
| **Semantic** | Changing garansi period from 30 to 60 days | **YES** (contractual) |
| **Semantic** | Changing gate criteria (file size thresholds) | **YES** (quality bar) |
| **Semantic** | Adding new legal citations (UU PDP Pasal X) | **YES** (legal accuracy) |

**PR3 Semantic Note**: Fixing F001 (termin 4 contradiction) = semantic change. Requires owner decision: use "10-15%" or "10-20%"? Recommend "10-20%" (matches modules/11 and templates/SOW consolidated).

---

## D9: Link Migration Strategy

### 9.1 Approach

**Phase 1-4**: Structural moves (protocols/, constants/, templates/deprecated/)
- Update all internal refs via find-replace
- Leave redirect stubs in old locations for 1 release

**Phase 5**: Module splits (05, 05B, 06)
- Archive original files in modules/deprecated/
- Add redirect stub at top:
  ```markdown
  # [DEPRECATED] Module 05: Architecture & Specs
  **This file has been split. See:**
  - `modules/05-prd.md` (Product Requirements)
  - `modules/05-fsd.md` (Functional Specification)
  ```
- Keep deprecated files for 1 release cycle (v1.1.0), remove in v2.0.0

### 9.2 Automated Link Update Script

**Tool**: PowerShell script `scripts/migrate-links.ps1`

**Logic**:
1. Find all .md files
2. Replace old paths with new paths
3. Generate report of updated refs

**Example Replacements**:
```powershell
# PR2: Protocol extraction
"See gate verification below" → "See protocols/GATE_PROTOCOL.md"

# PR4: Template rename
"templates/archive/" → "templates/deprecated/"

# PR5: Module splits
"modules/05-architecture-specs.md" → "modules/05-prd.md (or 05-fsd.md)"
```

**Validation**: Run `markdown-link-check` after each PR to catch broken links.

### 9.3 Changed Link Inventory

**PR2** (Protocols):
- 16 modules: gate blocks → `protocols/GATE_PROTOCOL.md`
- 14 modules: mandatory load → `protocols/MANDATORY_LOAD.md`
- 11 modules: stop protocol → `protocols/STOP_AT_GATE.md`

**PR3** (Constants):
- modules/03, 11, templates/SOW: payment terms → `constants/PAYMENT_TERMS.md`

**PR4** (Templates):
- SKILL.md: `templates/archive/` → `templates/deprecated/` (8 references)

**PR5** (Splits):
- SKILL.md: Add 6 new module entries (05-prd, 05-fsd, 05B-scalability, 05B-caching, 06-backend, 06-frontend)
- Any external refs to old modules → redirect stub

**Total Ref Updates**: ~60-80 link changes across 6 PRs.

---

## D10: Rollback Plans

### General Rollback Procedure

1. Identify failing PR via CI or manual testing
2. `git revert <commit-hash>` (creates new commit undoing changes)
3. Force push NOT allowed (preserve history)
4. If revert conflicts, manually restore from `git show <commit>^:path/to/file`

### Per-PR Rollback

| PR | Rollback Command | Recovery Time | Data Loss Risk |
|----|------------------|---------------|----------------|
| PR1 | `git revert HEAD` | <1 min | None (pure additions) |
| PR2 | `git revert HEAD` | <5 min | None (content preserved inline) |
| PR3 | `git revert HEAD` | <5 min | None (values preserved in modules) |
| PR4 | `git mv templates/deprecated templates/archive && git revert` | <10 min | None (rename reversible) |
| PR5 | `git mv modules/deprecated/*.md modules/ && git revert` | <15 min | None (old files archived) |
| PR6 | `git revert HEAD` | <5 min | None (detailed list restored) |

### Emergency Rollback (All PRs)

If entire refactor fails after PR6:

```bash
git log --oneline --grep="Refactor Phase" --all  # Find PR1 commit
git revert <PR6-commit>..<PR1-commit>^  # Revert entire series
```

**Recovery**: ~30 min to revert all 6 PRs.

**Test Environment**: Run on `refactor` branch first, merge to `main` only after full validation.

---

## D11: Validation Checklist

### Pre-Refactor

- [ ] Backup: `git tag pre-refactor-backup`
- [ ] Create branch: `git checkout -b refactor-phase-1`
- [ ] Run `markdown-link-check` on `main` (baseline)
- [ ] Token count baseline: SKILL.md = 7,207 tokens

### Post-PR1

- [ ] All new folders exist
- [ ] .gitignore updated
- [ ] No broken links (link-check passes)

### Post-PR2

- [ ] protocols/ files have content
- [ ] All 17 modules reference protocols/
- [ ] No broken links
- [ ] Token savings: ~3K (verify)

### Post-PR3

- [ ] constants/ files have content
- [ ] Payment term F001 resolved (all say "10-20%")
- [ ] No semantic changes beyond F001 fix
- [ ] No broken links

### Post-PR4

- [ ] templates/deprecated/ exists
- [ ] templates/archive/ deleted
- [ ] SKILL.md refs correct
- [ ] Duplicate files removed
- [ ] No broken links

### Post-PR5

- [ ] All 6 new split modules <8K tokens
- [ ] Content 100% preserved (diff check)
- [ ] Old modules in modules/deprecated/ with redirects
- [ ] SKILL.md updated
- [ ] No broken links

### Post-PR6

- [ ] INDEX.md created (140+ files listed)
- [ ] SKILL.md <5K tokens (target: 4.8K)
- [ ] Progressive loading instruction added
- [ ] No broken links
- [ ] Total token savings: 5-7K (verify)

### Final Validation

- [ ] Full skill load test (agent can execute Module 01-13)
- [ ] All templates resolve correctly
- [ ] No duplicate content (grep for repeated blocks)
- [ ] Git history clean (no force pushes)
- [ ] All PRs have rollback tested

---

## D12: Token Savings Summary

| Component | Before | After | Savings |
|-----------|--------|-------|---------|
| SKILL.md | 7,207 | ~4,800 | 2,407 |
| Gate protocols (16 modules) | ~3,000 | 500 | 2,500 |
| Mandatory load (14 modules) | ~1,500 | 300 | 1,200 |
| Stop protocol (11 modules) | ~1,000 | 200 | 800 |
| Module splits | 0 | 0 | 0 (reorg) |
| **TOTAL** | **~12,707** | **~5,800** | **~6,907** |

**Percentage Reduction**: 54% of duplicated/boilerplate content.

**Note**: Module splits don't reduce tokens (same content), but improve organization and stay under 8K budget per file.

---

## Appendix A: Open Questions for Owner

**Before executing refactor, owner must decide**:

1. **F001 Resolution**: Termin 4 = "10-15%" or "10-20%"? (Recommend: 10-20%)
2. **Orphan Files**: Delete or restore `templates/archive/orphans/*` files?
3. **SOW Template**: Keep SOW_CONTRACT_CONSOLIDATED or SOW_CONTRACT as canonical?
4. **Legal Extraction**: Extract UU PDP/ITE now or defer to v2.0? (Recommend: defer)
5. **Stack Examples**: Extract to stack-examples/ now or defer? (Recommend: defer to v2.0)
6. **Adapters**: Build adapters/ for all environments now or generic/ only? (Recommend: generic only, defer full)
7. **Module Deprecation**: Keep deprecated modules for 1 release or remove immediately? (Recommend: keep 1 release)

---

**End of REFACTOR_PLAN.md (D1-D9 Complete)**
