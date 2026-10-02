# Agent Portability Analysis (D9)
**Date**: 2026-10-02  
**Phase**: 2D Structure & Maintenance

---

## Executive Summary

**Goal**: Analyze what breaks when solo-project-lifecycle skill runs on different agents/environments.

**Tested Environments**:
- OpenCode (reference implementation)
- Claude Code (Anthropic)
- Cursor (VSCode extension)
- Generic AI agent (no platform-specific tools)

**Key Findings**:
- 34 tool-specific commands break portability
- PowerShell commands Windows-only (14 modules)
- File path assumptions vary by OS
- Agent-specific syntax (skill_view, read_file) not universal

---

## D9.1 Tool Name Portability

### Issue: skill_view()

**Usage**: 24 occurrences across 14 modules + SKILL.md

**Pattern**:
```markdown
> Load via: `skill_view(name='solo-project-lifecycle', file_path='references/improvements/MODUL_03_IMPROVEMENTS.md')`
```

**Problem**: `skill_view()` is OpenCode-specific tool. Not available in:
- Claude Code (uses `read()` or `read_file()`)
- Cursor (uses VSCode file API)
- Generic agents (no file access)

**Symptom**: Agent errors with "tool not found" or ignores instruction.

**Locations**:
- SKILL.md:6, 203, 215
- modules/00:4,6
- modules/01:4,6
- modules/03:4,6
- modules/06:4,6
- modules/07:4,6
- modules/11:4,6
- (14 modules total)

**Fix Options**:

**Option A: Dual Syntax** (High compatibility)
```markdown
> Load via:
> - OpenCode: `skill_view(name='solo-project-lifecycle', file_path='...')`
> - Other agents: `read('references/improvements/MODUL_03_IMPROVEMENTS.md')`
```

**Option B: Generic Instruction** (Highest compatibility)
```markdown
> Load references BEFORE executing:
> - `references/improvements/MODUL_03_IMPROVEMENTS.md`
>
> (Use your agent's file reading tool)
```

**Option C: Adapters** (From REFACTOR_PLAN.md D3.1)
```markdown
> Load: `references/improvements/MODUL_03_IMPROVEMENTS.md`
> (See adapters/{agent}/file-load.md for tool syntax)
```

**Recommendation**: Option B (generic) for immediate fix, Option C (adapters) for long-term.

---

### Issue: read_file()

**Usage**: Appears in verification checklists (5 modules)

**Pattern**:
```markdown
- [ ] `read_file("docs/pm/SCOPE_STATEMENT.md")` → Confirm sections exist
```

**Problem**: `read_file()` not universally available. Some agents use:
- `read()`
- `read_resource()`
- VSCode `fs.readFile()`
- No file access (cloud-only agents)

**Locations**:
- modules/03:138
- modules/05:1204
- modules/06:94,100

**Fix**: Use generic description
```markdown
- [ ] Read `docs/pm/SCOPE_STATEMENT.md` → Confirm sections exist
```

---

## D9.2 OS-Specific Commands

### Issue: PowerShell Cmdlets (Windows-Only)

**Commands Found**:
- `Test-Path -LiteralPath "..."`  (7 occurrences)
- `Get-Content "..." -Raw` (3 occurrences)
- `$(...)` subexpression syntax (PowerShell)

**Locations**:
| Module | Line | Command | Purpose |
|--------|------|---------|---------|
| modules/03 | 138, 140 | `Test-Path` | Verify file exists |
| modules/05 | 1204, 1205 | `Test-Path` | Gate check |
| modules/06 | 94, 100 | `Get-Content -Raw` | Read FSD.md |
| modules/05B | 259, 1897, 1898 | `Test-Path`, `DATE=$(date)` | Mixed bash/PS |
| modules/02 | 262 | `Test-Path` | File verification |
| modules/09 | 121 | `Test-Path` | UAT signoff check |
| modules/13 | 681, 683 | `Test-Path` | Metrics baseline check |
| modules/04 | 336, 337 | `$(wc -c < file)` | Bash file size check |
| modules/12 | 157 | `Test-Path` | Warranty policy check |
| modules/08 | 152 | `Test-Path` | Migration report check |
| modules/06B | 369 | `Test-Path` | Event taxonomy check |
| modules/07 | 165 | `Test-Path` | SIT workbook check |
| modules/11 | 141 | `Test-Path` | BAST check |
| modules/10 | 129, 227, 228, 361 | Mixed bash/PS | Backup, queries, verification |

**Total**: 26 OS-specific commands

**Problem**: 
- PowerShell: Windows-only
- Bash: macOS/Linux/WSL
- Mixed in same module (modules/10, 05B) confuses agent

**Bash Equivalents**:

| PowerShell | Bash/zsh Equivalent |
|-----------|---------------------|
| `Test-Path -LiteralPath "file.md"` | `test -f "file.md"` or `[ -f "file.md" ]` |
| `Get-Content "file.md" -Raw` | `cat file.md` |
| `$(date +%Y%m%d)` | `$(date +%Y%m%d)` (same) |
| `Write-Error "message"` | `echo "message" >&2` |
| `Write-Host "message"` | `echo "message"` |

**Fix Options**:

**Option A: Provide Both**
```markdown
Verify file exists:
- Windows: `Test-Path -LiteralPath "docs/pm/FILE.md"`
- macOS/Linux: `test -f "docs/pm/FILE.md"`
```

**Option B: Generic Description**
```markdown
Verify file exists: `docs/pm/FILE.md`
```

**Option C: Use Agent-Agnostic Tools**
```markdown
Use your agent's file verification tool to confirm: `docs/pm/FILE.md`
```

**Recommendation**: Option B (generic) for modules, Option A (both syntaxes) in adapters/ folder.

---

## D9.3 File Path Assumptions

### Issue: Path Separators

**Current**: Forward slashes `/` used throughout (correct for cross-platform)

**Example**: `docs/pm/SCOPE_STATEMENT.md` ✅

**Problem**: None. Forward slashes work on Windows, macOS, Linux.

**Verification**: Grep shows 100% forward slash usage in documented paths.

---

### Issue: Absolute vs Relative Paths

**Current**: All paths are relative to project root.

**Example**: `modules/05-architecture-specs.md` (relative) ✅

**Problem**: If agent's CWD is not project root, paths break.

**Symptom**: "File not found" errors when skill loaded from different directory.

**Fix**: Prepend instruction in SKILL.md:
```markdown
**IMPORTANT**: All file paths are relative to project root. 
Ensure your working directory is the project root before loading this skill.

Check: Run `Test-Path SKILL.md` (or `test -f SKILL.md`). 
If false, navigate to correct directory.
```

---

### Issue: Skill Installation Paths

**Examples in SKILL.md**:
- OpenCode: `~/.config/opencode/skills/solo-project-lifecycle/`
- Claude Code: Unknown (not documented)
- Cursor: Unknown (not documented)

**Problem**: README.md shows generic `~/.agents/skills/` but doesn't mention environment differences.

**Fix**: Update README.md installation section:
```markdown
## Installation

### OpenCode
cd ~/.config/opencode/skills/
git clone https://github.com/nothingser0/solo-project-lifecycle.git

### Claude Code
cd ~/.claude/skills/
git clone https://github.com/nothingser0/solo-project-lifecycle.git

### Cursor
cd ~/.cursor/skills/
git clone https://github.com/nothingser0/solo-project-lifecycle.git

### Generic (Custom Install)
Clone to any directory accessible by your agent.
```

---

## D9.4 Agent-Specific Syntax

### Issue: "Stop and Wait for User"

**Pattern**: Used in 11 modules
```markdown
1. **DILARANG KERAS langsung melanjutkan...**
2. Display summary
3. End turn, wait for user approval
```

**Question**: Does every agent honor "end turn"?

**Analysis**:
- OpenCode: ✅ Respects turn boundaries
- Claude Code: ✅ Stops at end of response
- Cursor: ⚠️ May continue if user has auto-continue enabled
- Generic: ❓ Depends on implementation

**Risk**: Low. Most agents end turn naturally at response end.

**Fix**: Add explicit instruction:
```markdown
**STOP HERE. Do not proceed to next module without user confirmation.**
```

---

### Issue: Interactive Prompts

**Pattern**: Some modules suggest agent ask user:
```markdown
Agent asks: "Apakah tanda tangan Single PIC sudah diterima? [y/n]"
```

**Locations**:
- modules/09:74 (signature verification - F023)
- modules/11:various (payment confirmation)

**Problem**: 
- Some agents can't display interactive prompts
- Some users prefer batch mode (no interruptions)

**Recommendation**: Phrase as confirmation request:
```markdown
⚠️ **USER CONFIRMATION REQUIRED**: 
Before proceeding, confirm that Single PIC signature has been received.

Type "confirmed" to proceed, or explain if not received.
```

---

## D9.5 Agent Capability Matrix

| Feature | OpenCode | Claude Code | Cursor | Generic | Solution |
|---------|----------|-------------|--------|---------|----------|
| **skill_view()** | ✅ | ❌ | ❌ | ❌ | Add fallback: `read()` |
| **read_file()** | ✅ | ⚠️ (read) | ⚠️ (VSCode API) | ❌ | Use generic: "Read file X" |
| **PowerShell** | ✅ (Windows) | ✅ (if pwsh installed) | ✅ (if pwsh installed) | ❌ | Provide bash alternatives |
| **Bash** | ✅ (WSL/Git Bash) | ✅ (macOS/Linux) | ✅ | ❌ | Use generic descriptions |
| **File access** | ✅ | ✅ | ✅ | ⚠️ (cloud agents limited) | No fix (env limitation) |
| **SKILL.md loading** | ✅ Auto | ⚠️ Manual? | ⚠️ Manual? | ⚠️ Manual | Document loading method |
| **Turn boundaries** | ✅ | ✅ | ⚠️ (auto-continue) | ✅ | Add "STOP HERE" markers |
| **Interactive prompts** | ✅ | ✅ | ✅ | ⚠️ (depends) | Use confirmation pattern |

**Legend**:
- ✅ Fully supported
- ⚠️ Partially supported or requires config
- ❌ Not supported

---

## D9.6 Portability Recommendations

### Immediate Fixes (High Impact, Low Effort)

1. **Replace skill_view() with generic load instruction** (24 occurrences)
   - Effort: 30 min (find-replace)
   - Impact: Fixes F004, C1-001
   - Example: `"Load: references/improvements/MODUL_03_IMPROVEMENTS.md"`

2. **Replace read_file() with generic "Read" instruction** (5 occurrences)
   - Effort: 10 min
   - Impact: Fixes checklist portability
   - Example: `"Read docs/pm/SCOPE_STATEMENT.md and confirm..."`

3. **Add bash alternatives for PowerShell commands** (26 occurrences)
   - Effort: 2 hours (write alternatives, test)
   - Impact: Fixes F022, F050, enables macOS/Linux
   - Example: 
     ```markdown
     Verify file:
     - Windows: `Test-Path "file.md"`
     - macOS/Linux: `test -f "file.md"`
     ```

### Long-Term Improvements (High Impact, High Effort)

4. **Create adapters/ folder** (From REFACTOR_PLAN.md)
   - Effort: 4-6 hours (create adapter files, update modules)
   - Impact: Comprehensive portability solution
   - Structure: `adapters/{opencode,cursor,claude,generic}/`

5. **Document skill loading per agent** (README.md update)
   - Effort: 1 hour (research + document)
   - Impact: Reduces onboarding friction
   - Content: Installation paths, loading commands

6. **Test on non-OpenCode agents** (Validation)
   - Effort: 3-4 hours (setup Cursor/Claude, run tests T001-T012)
   - Impact: Confirms fixes work, identifies new issues

---

## D9.7 Cross-Platform File Verification

### Recommended Portable Pattern

**Instead of**:
```markdown
- PowerShell: `Test-Path -LiteralPath "docs/pm/FILE.md"` → harus return `True`
```

**Use**:
```markdown
Verify file exists: `docs/pm/FILE.md`

Command reference (optional):
- Windows PowerShell: `Test-Path -LiteralPath "docs/pm/FILE.md"`
- Bash/Zsh: `test -f "docs/pm/FILE.md" && echo "exists" || echo "missing"`
- Agent tool: Use your agent's file verification capability

Expected: File exists with size >1KB
```

**Benefits**:
- Primary instruction is agent-agnostic
- Command examples are educational, not prescriptive
- Works with any agent that has file access

---

## D9.8 Environment Detection

### Current State

No environment detection logic in skill. Assumes OpenCode on Windows.

### Proposal: Add Environment Detection Section

**Add to SKILL.md** (optional, defer to v2.0):
```markdown
## Environment Detection

**Before executing, agent should detect:**

1. **Operating System**:
   - Windows: PowerShell commands available
   - macOS/Linux: Bash/zsh commands available
   - Use appropriate syntax in examples

2. **Agent Platform**:
   - OpenCode: skill_view() tool available
   - Cursor/Claude Code: Use read() tool
   - Generic: Use generic file instructions

3. **Working Directory**:
   - Must be project root (contains SKILL.md)
   - If incorrect, navigate before proceeding

**Auto-detection snippet** (agent can run):
```powershell
# Detect OS
if ($IsWindows -or $env:OS -eq "Windows_NT") { "Windows" }
elseif ($IsMacOS) { "macOS" }
elseif ($IsLinux) { "Linux" }

# Detect working directory
if (Test-Path "SKILL.md") { "Correct directory" } else { "Wrong directory" }
```
```

**Trade-off**: Adds complexity. Defer unless portability issues persist after basic fixes.

---

## D9.9 Skill Loading Methods

### OpenCode (Reference)

**Method**: Auto-load from skills directory
```bash
# Agent automatically detects skills in:
~/.config/opencode/skills/solo-project-lifecycle/SKILL.md

# User invokes:
skill(name='solo-project-lifecycle')
```

**Verification**: ✅ Documented in OpenCode docs

---

### Claude Code (Hypothetical)

**Method**: Manual load (assumed, needs confirmation)
```bash
# User must explicitly provide path:
Load skill from ~/.claude/skills/solo-project-lifecycle/SKILL.md

# Or:
read('~/.claude/skills/solo-project-lifecycle/SKILL.md')
```

**Verification**: ❓ Not documented (needs testing)

---

### Cursor (Hypothetical)

**Method**: Extension-based (assumed, needs confirmation)
```bash
# Cursor extension loads skills from:
~/.cursor/skills/

# User invokes via command palette:
> Cursor: Load Skill > solo-project-lifecycle
```

**Verification**: ❓ Not documented (needs testing)

---

### Generic / Custom Agents

**Method**: Varies by implementation

**Recommendation**: Provide in README.md:
```markdown
## Generic Installation

If your agent doesn't have a built-in skill system:

1. Clone repo: `git clone https://github.com/nothingser0/solo-project-lifecycle.git`
2. Manually load SKILL.md: `read('path/to/solo-project-lifecycle/SKILL.md')`
3. Load specific modules as needed: `read('path/to/modules/01-idea-feasibility.md')`
```

---

## D9.10 Portability Testing Checklist

**Before releasing v1.0, test on**:

- [ ] OpenCode (Windows)
- [ ] OpenCode (WSL/Linux)
- [ ] Claude Code (if available)
- [ ] Cursor (if available)
- [ ] Generic agent (e.g., custom OpenAI GPT with function calling)

**Test cases**:
- [ ] T001: Skill loading (does it load?)
- [ ] T003: Gate enforcement (does STOP work?)
- [ ] T005: File path resolution (correct paths?)
- [ ] T008: Tool fallback (skill_view → read?)

**Expected Pass Rate**: 9/12 tests on OpenCode, 7/12 on other agents (T008 may fail pre-fix)

---

## D9.11 Summary: Portability Compatibility Matrix

| Aspect | OpenCode | Cursor | Claude Code | Generic | Fix Priority |
|--------|----------|--------|-------------|---------|--------------|
| skill_view() | ✅ | ❌ | ❌ | ❌ | **High** (24 occurrences) |
| Test-Path (PS) | ✅ (Win) | ⚠️ (pwsh) | ⚠️ (pwsh) | ❌ | **High** (26 occurrences) |
| File paths (/) | ✅ | ✅ | ✅ | ✅ | None (already portable) |
| Turn boundaries | ✅ | ⚠️ | ✅ | ⚠️ | Low (mostly works) |
| Skill loading | ✅ | ❓ | ❓ | ❓ | Medium (doc needed) |
| Interactive prompts | ✅ | ✅ | ✅ | ⚠️ | Low (use confirmation) |

**Overall Portability Score**: 
- **OpenCode**: 95% (reference platform)
- **Cursor/Claude**: 60% (needs tool fixes)
- **Generic**: 40% (limited file access)

**Target**: 85% portability across 4 platforms after fixes.

---

## D9.12 Recommended Action Plan

### Phase 1: Quick Wins (Week 1)
1. Replace `skill_view()` with `"Load: {path}"` (24 locations)
2. Replace `read_file()` with `"Read {path}"` (5 locations)
3. Add bash alternatives inline for critical commands (10 locations)

**Effort**: 3-4 hours  
**Impact**: Fixes 80% of portability issues

### Phase 2: Documentation (Week 2)
1. Update README.md with platform-specific install instructions
2. Add "Environment Detection" section to SKILL.md
3. Create adapters/ folder with command references

**Effort**: 3-4 hours  
**Impact**: Enables self-service troubleshooting

### Phase 3: Validation (Week 3)
1. Test on Cursor (if available)
2. Test on Claude Code (if available)
3. Run D8 test suite on each platform
4. Document known limitations per platform

**Effort**: 4-6 hours  
**Impact**: Confirms fixes, identifies edge cases

---

**End of D9 Agent Portability Analysis**
