# Skill Testing Evaluation Set (D8)
**Date**: 2026-10-02  
**Phase**: 2D Structure & Maintenance

---

## Executive Summary

**Goal**: Define 12 test cases to verify agent behavior with solo-project-lifecycle skill.

**Purpose**: Catch regressions in skill logic, gate enforcement, path handling, scale detection, and portability.

**Test Method**: Manual execution (agent loads skill + prompt) or automated (if agent API available).

**Coverage**: Core behavior (gates, scale, paths), edge cases (failure paths, UAT loops), portability (tool compatibility).

---

## Test Case Template

Each test includes:
- **ID**: Unique test identifier
- **Category**: Behavior aspect tested
- **Prompt**: Exact user input to agent
- **Context**: Pre-test setup (files, state)
- **Expected Behavior**: What agent should do/output
- **Pass Criteria**: Observable success condition
- **Fail Indicators**: What indicates test failed
- **Confidence**: How reliably this can be tested (High/Medium/Low)

---

## Test 1: Skill Selection

**ID**: T001  
**Category**: Skill Loading  
**Prompt**: `"Saya mau bikin MVP aplikasi kasir dalam 2 minggu"`  
**Context**: Empty project folder, no prior skill loaded  
**Expected Behavior**: 
- Agent loads `solo-project-lifecycle` skill
- Detects Fast-Track mode (2 weeks = tight deadline)
- Suggests using `PROJECT_LITE.md` template
- Skips Module 00 (product discovery)

**Pass Criteria**:
- ✅ Skill triggered automatically
- ✅ Fast-Track mode mentioned
- ✅ Module 00 not loaded

**Fail Indicators**:
- ❌ Generic project setup (not skill-specific)
- ❌ Module 00 loaded despite tight deadline
- ❌ No mention of Fast-Track protocol

**Confidence**: High (skill trigger is explicit)

---

## Test 2: Fast-Track Detection

**ID**: T002  
**Category**: Scale Detection  
**Prompt**: `"Proyek kecil, deadline 2 minggu, budget terbatas"`  
**Context**: Skill loaded, Module 01 active  
**Expected Behavior**:
- Agent recognizes "Kecil" scale markers (deadline, budget)
- Uses `PROJECT_LITE.md` (consolidated template)
- Module 04 (UI/UX) still REQUIRED for Web/Mobile
- Skips Module 00, 05B (scalability)

**Pass Criteria**:
- ✅ `PROJECT_LITE.md` mentioned
- ✅ Module 04 not skipped (if Web/Mobile)
- ✅ Module 05B skipped

**Fail Indicators**:
- ❌ Full module sequence proposed (00-13)
- ❌ Module 04 skipped for Web app
- ❌ Enterprise-level checks (compliance, pentest)

**Confidence**: High (SKILL.md:68 has explicit scale rules)

---

## Test 3: Gate Stop Enforcement

**ID**: T003  
**Category**: Gate Protocol  
**Prompt**: `"Lanjutkan ke Module 02"` (without Module 01 output)  
**Context**: Module 01 not completed, no `IDEA_BRIEF.md` exists  
**Expected Behavior**:
- Agent stops at Module 01 gate
- Requests `IDEA_BRIEF.md` completion
- Refuses to proceed to Module 02
- Ends turn (does not auto-proceed)

**Pass Criteria**:
- ✅ Agent states "Module 01 not complete"
- ✅ Turn ends without loading Module 02
- ✅ Gate protocol message displayed

**Fail Indicators**:
- ❌ Agent proceeds to Module 02
- ❌ No gate check performed
- ❌ Generic "ready for next step" message

**Confidence**: Medium (requires testing agent's gate enforcement logic)

---

## Test 4: Module Skip Prevention (Commercial Gate)

**ID**: T004  
**Category**: Gate Protocol  
**Prompt**: `"Langsung ke coding"`  
**Context**: Module 02 completed, Module 03 (SOW/DP) skipped  
**Expected Behavior**:
- Agent blocks coding
- Enforces Module 03 gate (contract + DP required)
- Cites SKILL.md rule: "TIDAK ADA SATU BARIS KODE SEBELUM GERBANG INI LOLOS"
- Requests SOW + DP confirmation

**Pass Criteria**:
- ✅ Agent refuses to start Module 06 (Development)
- ✅ Module 03 gate message displayed
- ✅ Turn ends

**Fail Indicators**:
- ❌ Agent proceeds to scaffolding/coding
- ❌ No mention of contract/DP requirement
- ❌ Generic "let's start coding" response

**Confidence**: High (commercial gate is critical, heavily documented)

---

## Test 5: Artifact Path Enforcement

**ID**: T005  
**Category**: File Organization  
**Prompt**: `"Generate SCOPE_STATEMENT.md"`  
**Context**: Module 02 active, project folder exists  
**Expected Behavior**:
- Agent creates file at `docs/pm/SCOPE_STATEMENT.md`
- NOT at root (`./SCOPE_STATEMENT.md`)
- Follows SKILL.md:99-109 distribution rules

**Pass Criteria**:
- ✅ File created at `docs/pm/SCOPE_STATEMENT.md`
- ✅ File contains expected sections (from template)

**Fail Indicators**:
- ❌ File created at root
- ❌ File created at wrong path (e.g., `docs/specs/`)
- ❌ Agent asks where to place file

**Confidence**: High (path rules are explicit)

---

## Test 6: Payment Term Consistency

**ID**: T006  
**Category**: Fact Consistency  
**Prompt**: `"Buat SOW untuk proyek Menengah, termin 4 berapa persen?"`  
**Context**: Module 03 active  
**Expected Behavior**:
- Agent states "10-20%" (post-F001 fix)
- OR flags contradiction if not fixed
- References `modules/11` or `templates/SOW` for consistency

**Pass Criteria**:
- ✅ Consistent value stated (either "10-15%" OR "10-20%", not both)
- ✅ If contradiction exists, agent flags it

**Fail Indicators**:
- ❌ Two different values in same response
- ❌ Agent unaware of values documented in modules/03 vs modules/11

**Confidence**: Medium (requires post-refactor testing)

---

## Test 7: Failure Path (UAT Fails 3x)

**ID**: T007  
**Category**: Error Handling  
**Prompt**: `"UAT failed for 3rd time, apa langkah selanjutnya?"`  
**Context**: Module 09 active, 3rd UAT failure recorded  
**Expected Behavior**:
- Agent suggests:
  - **PIVOT**: Reduce scope, cut features
  - **KILL**: Terminate project, return remaining funds (if applicable)
- Does NOT suggest unlimited UAT retries
- Cites modules/09 failure protocol (if documented)

**Pass Criteria**:
- ✅ PIVOT or KILL option presented
- ✅ Agent does not propose 4th, 5th, 6th UAT
- ✅ References failure escalation

**Fail Indicators**:
- ❌ Agent proposes "let's try again" indefinitely
- ❌ No failure path documented (gap in modules/09)
- ❌ Agent unaware of iteration limits

**Confidence**: Low (F031 indicates this may not be documented - test reveals gap)

---

## Test 8: Tool Portability (skill_view Fallback)

**ID**: T008  
**Category**: Portability  
**Prompt**: `"Load Module 03 improvements"`  
**Context**: Agent is Claude Code (no `skill_view()` tool available)  
**Expected Behavior**:
- Agent attempts `skill_view()`
- If fails, falls back to:
  - `read()` tool
  - OR provides manual file path: `references/improvements/MODUL_03_IMPROVEMENTS.md`
- Does NOT error out with "tool not found"

**Pass Criteria**:
- ✅ File content loaded (via any method)
- ✅ Graceful fallback message if `skill_view()` unavailable
- ✅ No hard error

**Fail Indicators**:
- ❌ Agent stops with "tool not found"
- ❌ No fallback attempted
- ❌ Agent ignores load instruction

**Confidence**: Medium (F004/C1-001 indicates this needs fixing first)

---

## Test 9: Legal Citation Completeness

**ID**: T009  
**Category**: Legal Compliance  
**Prompt**: `"Refer to UU PDP for data handling requirements"`  
**Context**: Module 05 (architecture) active, discussing DB encryption  
**Expected Behavior**:
- Agent cites **full reference**: "UU No. 27/2022 (UU PDP) Pasal 16" (or relevant article)
- NOT just "UU PDP" (vague)
- Provides specific legal requirement (e.g., consent, encryption, data minimization)

**Pass Criteria**:
- ✅ Law number + year cited (UU No. 27/2022)
- ✅ Pasal (article) number cited
- ✅ Specific requirement stated

**Fail Indicators**:
- ❌ Generic "UU PDP" without details
- ❌ No Pasal number
- ❌ Vague "comply with data protection laws"

**Confidence**: Medium (F033/C2-002 indicates 85% lack Pasal numbers currently)

---

## Test 10: Personal Name Scrubbed

**ID**: T010  
**Category**: Content Quality  
**Prompt**: `"Load Module 00 and explain product discovery"`  
**Context**: Clean agent session, Module 00 loaded  
**Expected Behavior**:
- Agent explanation uses generic terms: "solo developer", "developer", "you"
- Does NOT mention "zeenn" (personal name from F006/B001)
- Instructions remain general-purpose

**Pass Criteria**:
- ✅ No "zeenn" in response
- ✅ Generic role terms used

**Fail Indicators**:
- ❌ "Pengguna zeenn" appears
- ❌ `repos/zeenn/project` path example
- ❌ Personal identifiers in output

**Confidence**: High (simple text search)

---

## Test 11: Token Load Warning

**ID**: T011  
**Category**: Performance  
**Prompt**: `"Load all modules 00-13 for planning"`  
**Context**: Agent attempts to load all 17 modules (00, 01, ..., 13 + A/B variants)  
**Expected Behavior**:
- Agent warns: "Loading all modules = ~100K tokens, may exceed context window"
- Suggests progressive loading: "Load specific module when entering that phase"
- Does NOT load all modules simultaneously

**Pass Criteria**:
- ✅ Warning displayed
- ✅ Progressive loading suggested
- ✅ Agent loads only SKILL.md + 1-2 relevant modules

**Fail Indicators**:
- ❌ All modules loaded without warning
- ❌ Agent runs out of context mid-response
- ❌ No mention of token budget

**Confidence**: Low (F044 indicates this is NOT currently enforced - test reveals gap)

---

## Test 12: Scale Adaptation (Enterprise Track)

**ID**: T012  
**Category**: Scale Detection  
**Prompt**: `"Enterprise project, compliance required, bank client, budget unlimited"`  
**Context**: Module 01 feasibility check  
**Expected Behavior**:
- Agent selects **Enterprise** scale
- Engages:
  - Module 00 (Product Discovery) - NO skip
  - Module 05B (Scalability) - REQUIRED
  - Compliance checks (UU PDP audit, pentest, DPA)
- Does NOT use Fast-Track mode

**Pass Criteria**:
- ✅ "Enterprise" scale mentioned
- ✅ Compliance modules engaged
- ✅ Module 00 NOT skipped
- ✅ Full 13-module sequence proposed

**Fail Indicators**:
- ❌ Fast-Track mode suggested
- ❌ Module 00 skipped
- ❌ No compliance checks mentioned
- ❌ "MVP" terminology used

**Confidence**: High (SKILL.md:71 has explicit Enterprise criteria)

---

## Test Execution Matrix

| Test ID | Category | Priority | Confidence | Estimated Time | Pre-requisites |
|---------|----------|---------|------------|----------------|----------------|
| T001 | Skill Loading | High | High | 2 min | None |
| T002 | Scale Detection | High | High | 3 min | None |
| T003 | Gate Protocol | Critical | Medium | 5 min | Module 01 template |
| T004 | Gate Protocol | Critical | High | 5 min | Module 02 complete |
| T005 | File Organization | High | High | 3 min | Project folder |
| T006 | Fact Consistency | High | Medium | 3 min | Post-refactor |
| T007 | Error Handling | Medium | Low | 5 min | UAT scenario |
| T008 | Portability | High | Medium | 5 min | Non-OpenCode agent |
| T009 | Legal Compliance | Medium | Medium | 3 min | Module 05 active |
| T010 | Content Quality | High | High | 2 min | None |
| T011 | Performance | Medium | Low | 3 min | None |
| T012 | Scale Detection | High | High | 3 min | None |

**Total Execution Time**: ~40 minutes (manual) or ~5 minutes (automated API)

---

## Test Automation Approach (Future)

### Manual Testing (Current)
1. Open agent session
2. Load skill: `skill(name='solo-project-lifecycle')`
3. Execute prompt
4. Observe output
5. Check pass/fail criteria
6. Document result

### Automated Testing (Future - Requires Agent API)
```python
# Pseudocode
def test_skill_selection():
    agent = Agent()
    response = agent.run(
        prompt="Saya mau bikin MVP aplikasi kasir dalam 2 minggu",
        skills=["solo-project-lifecycle"]
    )
    assert "Fast-Track" in response.text
    assert "PROJECT_LITE.md" in response.text
    assert "Module 00" not in response.loaded_modules

# Run all tests
pytest test_skill_behavior.py
```

**Blockers for Automation**:
- No standardized agent API
- Agent behavior non-deterministic (LLM-based)
- Context state hard to reset between tests

---

## Test Coverage Analysis

### Covered Aspects
- ✅ Skill trigger (T001)
- ✅ Scale detection (T002, T012)
- ✅ Gate enforcement (T003, T004)
- ✅ Path compliance (T005)
- ✅ Fact consistency (T006)
- ✅ Failure paths (T007)
- ✅ Portability (T008)
- ✅ Legal citations (T009)
- ✅ Content quality (T010)
- ✅ Token budget (T011)

### NOT Covered (Out of Scope)
- ❌ Template content accuracy (requires human review)
- ❌ Legal validity (requires lawyer review)
- ❌ Pricing accuracy (requires market research)
- ❌ Code generation quality (requires separate code tests)
- ❌ Multi-language support (English versions not yet created)

### Known Gaps (Tests Will FAIL Until Fixed)
- **T007** (UAT failure path): F031 indicates no iteration limits documented
- **T008** (tool portability): F004/C1-001 confirms `skill_view()` has no fallback
- **T011** (token warning): F044 confirms no progressive loading enforced

**Action**: Fix these gaps before running full test suite, OR use tests to confirm gaps exist.

---

## Test Results Template

### Test Run: [Date]
**Agent**: [OpenCode / Claude Code / Cursor]  
**Skill Version**: [v1.0.0]  
**Tester**: [Name]

| Test ID | Status | Notes | Duration |
|---------|--------|-------|----------|
| T001 | ✅ PASS | Skill triggered correctly | 2 min |
| T002 | ✅ PASS | Fast-Track detected | 3 min |
| T003 | ⚠️ WARN | Gate bypassed with override flag | 5 min |
| T004 | ✅ PASS | Commercial gate enforced | 5 min |
| T005 | ✅ PASS | Correct path used | 3 min |
| T006 | ❌ FAIL | Contradiction: 10-15% vs 10-20% | 3 min |
| T007 | ❌ FAIL | No failure path documented | 5 min |
| T008 | ❌ FAIL | skill_view() error, no fallback | 5 min |
| T009 | ⚠️ WARN | Pasal number missing | 3 min |
| T010 | ✅ PASS | No personal names | 2 min |
| T011 | ❌ FAIL | All modules loaded, no warning | 3 min |
| T012 | ✅ PASS | Enterprise track engaged | 3 min |

**Summary**: 5/12 PASS, 3/12 WARN, 4/12 FAIL  
**Blockers**: F004 (portability), F031 (failure paths), F044 (token budget), F001 (payment terms)

---

## Regression Testing Strategy

### When to Run Full Test Suite
1. **Before Major Release** (v1.0 → v2.0): Full 12-test run
2. **After Refactor** (PR5 module splits): Run T003, T004, T011 (gate/token tests)
3. **After Content Changes** (modules/03, 11): Run T006 (fact consistency)
4. **After Portability Fixes** (F004): Run T008

### When to Run Subset
- **Quick Smoke Test** (after small PRs): T001, T002, T005 (3 tests, ~8 min)
- **Gate Tests Only**: T003, T004 (critical path validation)
- **Content Quality Only**: T006, T009, T010 (fact/legal/quality checks)

### Test Maintenance
- **Quarterly**: Review test cases, add new tests for new modules
- **After Findings**: Convert high-severity findings to test cases (e.g., F001 → T006)
- **When Tests Fail**: Update test or fix skill (not both)

---

## Success Metrics

**Target**: 10/12 tests passing before v1.0 release

**Acceptable Failures** (document as known limitations):
- T007 (failure paths) - if not critical for MVP
- T011 (token warning) - if agent handles large context well

**Blocking Failures** (must fix before release):
- T003, T004 (gate enforcement) - CRITICAL for commercial protection
- T006 (fact consistency) - CRITICAL for legal disputes
- T008 (portability) - CRITICAL for multi-agent support

---

**End of D8 Skill Testing Evaluation Set**
