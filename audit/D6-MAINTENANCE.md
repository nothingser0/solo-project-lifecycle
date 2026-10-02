# Maintenance & Governance Proposals (D6)
**Date**: 2026-10-02  
**Phase**: 2D Structure & Maintenance

---

## D6.1 Versioning Strategy

### Current State
- No version tracking
- No semver in SKILL.md or README.md
- Git tags used sporadically (only `pre-refactor-backup` visible)

### Recommendation: Adopt Semantic Versioning

**Format**: `vMAJOR.MINOR.PATCH`

**Rules**:
- **MAJOR** (v2.0.0): Breaking changes (module renaming, removed features, new dependencies)
- **MINOR** (v1.1.0): New modules, optional features, backward-compatible additions
- **PATCH** (v1.0.1): Bug fixes, typo corrections, clarifications

**Examples**:
- Current state: `v1.0.0` (initial release)
- Add Module 14: `v1.1.0`
- Fix F001 payment term: `v1.0.1`
- Refactor (file moves, no semantic changes): `v1.1.0` (structure is new feature)
- Remove deprecated modules: `v2.0.0` (breaking)

**Implementation**:
1. Add to SKILL.md frontmatter:
   ```yaml
   ---
   name: solo-project-lifecycle
   version: 1.0.0
   description: ...
   ---
   ```
2. Git tag each release: `git tag v1.0.0 -m "Initial release"`
3. Document version in README.md

---

## D6.2 CHANGELOG.md

### Current State
- No CHANGELOG.md file exists
- Changes documented in git commit messages only (not user-facing)

### Recommendation: Create CHANGELOG.md

**Format**: [Keep a Changelog](https://keepachangelog.com/) standard

**Structure**:
```markdown
# Changelog
All notable changes to solo-project-lifecycle will be documented here.

Format based on [Keep a Changelog](https://keepachangelog.com/),
versioning follows [Semantic Versioning](https://semver.org/).

## [Unreleased]
### Added
- (changes staged for next release)

## [1.0.0] - 2026-10-02
### Added
- Initial 13-module SDLC framework
- Fast-Track mode for MVP projects
- Module 04A: Design System Foundation
- Module 05B: System Design & Infrastructure
- Module 06B: Product Instrumentation & Analytics
- Module 13: Product Operations & Iteration
- 89 templates across 9 phase folders
- 67 reference guides (improvements, checklists, playbooks, PM, solo, technical)

### Fixed
- (none - initial release)

### Changed
- (none - initial release)

### Deprecated
- (none - initial release)

### Removed
- (none - initial release)

### Security
- (none - initial release)
```

**Maintenance**: Update CHANGELOG.md in every PR before merge.

**Categories**:
- **Added**: New modules, templates, features
- **Changed**: Modifications to existing content (non-breaking)
- **Deprecated**: Features marked for future removal (still work)
- **Removed**: Deleted features (breaking)
- **Fixed**: Bug fixes, typos, clarifications
- **Security**: Security-related changes (e.g., audit findings)

---

## D6.3 Commit Message Convention

### Current State
- Inconsistent commit messages:
  - "feat(modules): add universal tech stack support across Module 04-06" ✅ (good)
  - "Initial commit: solo-project-lifecycle framework" ⚠️ (no type prefix)

### Recommendation: Adopt Conventional Commits

**Format**: `<type>(<scope>): <subject>`

**Types**:
- `feat`: New feature/module
- `fix`: Bug fix
- `docs`: Documentation only
- `refactor`: Code restructure (no behavior change)
- `test`: Test additions/changes
- `chore`: Maintenance (deps, config)
- `style`: Formatting (no logic change)

**Scopes**:
- `modules`: Changes to modules/
- `templates`: Changes to templates/
- `references`: Changes to references/
- `skill`: Changes to SKILL.md
- `readme`: Changes to README.md
- `deps`: Dependency updates (if any)

**Examples**:
- `feat(modules): add Module 14 Post-Launch Growth`
- `fix(modules): correct termin 4 percentage (F001)`
- `refactor(templates): rename archive/ to deprecated/`
- `docs(readme): add installation instructions`
- `chore(gitignore): add audit/ and .sisyphus/`

**Body & Footer** (optional):
```
feat(modules): add Module 14 Post-Launch Growth

Covers growth loops, viral mechanics, referral programs, and PLG strategies.
Target audience: Menengah and Besar projects post-v1.0 launch.

Closes #42
```

**Enforcement**: Manual review until CI automation added (Phase D7).

---

## D6.4 Git Hygiene

### Current State
**Issues Found**:
1. `.gitignore` missing:
   - `audit/` (temporary analysis folder)
   - `.sisyphus/` (AI session data)
   - `*.backup-*` (backup files)
2. Backup file in repo: `modules/04-uiux-prototyping.md.backup-20261001`
3. No `.gitattributes` (line ending consistency)

### Recommendations

#### 4a. Update .gitignore

**Add to .gitignore**:
```gitignore
# Audit & Analysis (temporary)
audit/
.sisyphus/

# Backup files (use git history instead)
*.backup-*
*.bak
*.old

# Session files
.session-*
```

**Rationale**: Audit folder is for analysis only, not part of skill distribution. Backup files should use git history.

#### 4b. Create .gitattributes

**Content**:
```gitattributes
# Force LF line endings (avoid CRLF/LF mix)
* text=auto
*.md text eol=lf
*.json text eol=lf
*.yaml text eol=lf
*.yml text eol=lf

# Binary files
*.png binary
*.jpg binary
*.pdf binary
```

**Rationale**: Prevents CRLF/LF inconsistencies across Windows/Mac/Linux contributors.

#### 4c. Remove Backup Files

**Action**: Delete `modules/04-uiux-prototyping.md.backup-20261001`

**Command**: `Remove-Item modules\04-uiux-prototyping.md.backup-20261001`

**Rationale**: Git history preserves old versions. Backup files clutter repo.

#### 4d. Backup Policy

**Rule**: No `.backup-*`, `.bak`, `.old` files in repo. Use git history or branches.

**Exception**: None. If file needs preservation during refactor, use:
- Git branch: `git checkout -b preserve-old-version`
- Git stash: `git stash save "preserve before refactor"`
- Deprecation folder: `modules/deprecated/` (temporary, 1 release cycle)

---

## D6.5 Branch Strategy

### Current State
- Branches:
  - `main` (current)
  - `backup-before-rewrite`
  - `remotes/origin/main`

### Recommendation: Feature Branch Workflow

**Main Branch**: `main` (protected)
- Only accepts PRs
- No direct commits
- Always deployable/usable

**Feature Branches**: `{type}/{scope}-{description}`
- Examples:
  - `feat/module-14-growth`
  - `fix/f001-payment-terms`
  - `refactor/extract-protocols`
  - `docs/readme-installation`

**Lifetime**: Delete after merge (keep history in main)

**Protection Rules** (if GitHub/GitLab):
- Require PR approval
- Block force-push to main
- Require status checks to pass (once CI added)

---

## D6.6 Public vs Private Considerations

### Current State
- Repo: `https://github.com/nothingser0/solo-project-lifecycle.git`
- Public/Private: Unknown (needs owner confirmation)

### Recommendations

#### If Public Repo:

**Actions**:
1. Audit for sensitive data:
   - Personal names (already found: "zeenn" in Module 00 - F006)
   - Client project examples with real company names
   - Email addresses, phone numbers
   - Internal process details specific to solo dev
2. Add CONTRIBUTING.md (see D6.7)
3. Add CODE_OF_CONDUCT.md (if accepting contributions)
4. Verify LICENSE appropriate (MIT allows commercial use)

**Scan Commands**:
```powershell
# Find personal names
Get-ChildItem -Recurse -Include *.md | Select-String -Pattern "@\w+\.com|zeenn|[0-9]{3}-[0-9]{4}"

# Find potential client data
Get-ChildItem -Recurse -Include *.md | Select-String -Pattern "PT\. |CV\. |Rp\s+\d{1,3}(\.\d{3})+[,\.]"
```

#### If Private Repo:

**Actions**:
1. Document what can be shared externally (e.g., templates OK, modules confidential)
2. Add to README.md: "Private skill for solo developer use only"
3. No CONTRIBUTING.md needed (closed project)

---

## D6.7 CONTRIBUTING.md (Optional - Public Repos Only)

### Current State
- No CONTRIBUTING.md exists

### Recommendation: Create if Public

**Content Outline**:
```markdown
# Contributing to solo-project-lifecycle

Thank you for considering contributions!

## How to Contribute

1. Fork the repo
2. Create a feature branch: `git checkout -b feat/your-feature`
3. Follow commit conventions (see CHANGELOG.md)
4. Test changes: Ensure agent can load skill and execute modules
5. Update CHANGELOG.md under [Unreleased]
6. Submit PR with description

## What to Contribute

**Welcome**:
- Bug fixes (typos, broken links, logical errors)
- New templates
- Additional reference guides
- Translations (e.g., English version of modules)

**Requires Discussion First**:
- New modules (open issue first)
- Major refactors
- Changing versioning/naming conventions

**Not Accepted**:
- Personal workflow preferences (fork instead)
- Breaking changes without migration path

## Code Review

PRs reviewed within 7 days. May request changes for:
- Consistency with existing style
- Token budget concerns (new content >5K tokens)
- Duplication (check if already exists)

## License

By contributing, you agree to MIT license.
```

**Rationale**: Sets expectations for contributors, reduces maintenance burden.

---

## D6.8 Attribution & Credit

### Current State
- LICENSE exists (MIT from 00-inventory.md)
- No CONTRIBUTORS.md or attribution in README.md

### Recommendation: Add Attribution Section to README.md

**Content**:
```markdown
## Credits

**Framework by**: [nothingser0](https://github.com/nothingser0)

**Inspiration & References**:
- Module 04A Design System: Inspired by Shopify Polaris, Airbnb DLS
- Module 00 Product Discovery: Adapted from Lean Startup, JTBD framework
- Module 13 Product Ops: Influenced by RICE (Intercom), AARRR (Dave McClure)

**External Templates**:
- (List any adapted templates with attribution)

**Special Thanks**:
- Solo dev community for testing and feedback
- (Add collaborators if any)
```

**Rationale**: Gives credit, shows influences, avoids plagiarism concerns.

---

## D6.9 Dependency Management

### Current State
- No external dependencies (pure markdown skill)
- No package.json, requirements.txt, Gemfile, etc.

### Recommendation: Keep Dependency-Free

**Rationale**: 
- Markdown skills don't need package managers
- Reduces installation friction
- No security vulnerabilities from outdated deps

**Exception**: If automation scripts added (D7), document minimal deps:
```markdown
## Development Dependencies (Optional)

For automation scripts only:
- markdown-link-check: `npm install -g markdown-link-check`
- cspell: `npm install -g cspell`
```

**Rule**: No deps required to USE skill, only to DEVELOP/TEST it.

---

## D6.10 Release Process

### Recommendation: Formal Release Checklist

**Before Each Release**:

1. **Version Bump**:
   - [ ] Update SKILL.md `version:` field
   - [ ] Update README.md version badge (if any)
   - [ ] Move [Unreleased] changes to [vX.Y.Z] in CHANGELOG.md

2. **Pre-Release Validation**:
   - [ ] Run link checker (no broken links)
   - [ ] Token count check (SKILL.md <5K, modules <8K)
   - [ ] Grep for TODO/FIXME comments
   - [ ] Verify no backup files (*.backup-*)
   - [ ] Test: Agent can load skill and execute Module 01-13

3. **Git Operations**:
   - [ ] Commit: `chore(release): bump version to vX.Y.Z`
   - [ ] Tag: `git tag vX.Y.Z -m "Release vX.Y.Z"`
   - [ ] Push: `git push origin main --tags`

4. **Post-Release**:
   - [ ] Create GitHub release (if public repo)
   - [ ] Announce in README.md or discussions
   - [ ] Archive deprecated files after 1 cycle (e.g., v1.0 → v1.1 keeps deprecations, v1.1 → v2.0 removes them)

**Release Frequency**:
- Patch (v1.0.x): As needed for bugs
- Minor (v1.x.0): Monthly or when 3+ new features
- Major (vx.0.0): Yearly or when breaking changes accumulate

---

## D6.11 Documentation Maintenance

### Current State
- README.md exists (basic)
- No documentation versioning (e.g., docs/ folder per version)

### Recommendations

#### 11a. README.md Enhancement

**Add Sections**:
```markdown
## Installation
## Quick Start
## Project Structure
## Versioning
## Contributing (if public)
## License
## Changelog
```

**Example "Project Structure"**:
```markdown
## Project Structure

- `modules/`: 13 SDLC phase modules (00-13)
- `templates/`: 89 document templates
- `references/`: Checklists, guides, playbooks
- `protocols/`: Shared gate/load procedures
- `constants/`: SSOT for terms, durations, SLA
- `SKILL.md`: Agent skill definition
- `CHANGELOG.md`: Version history
```

#### 11b. Documentation Versioning

**Rule**: Keep docs in sync with code version.

**Approach**: Single-version documentation (main branch = latest release).

**Historical Docs**: Tag git releases, users can checkout old versions:
```bash
git checkout v1.0.0
cat SKILL.md  # Read v1.0.0 docs
```

**Rationale**: Simpler than maintaining separate docs/ folders per version.

---

## D6.12 Maintenance Schedule

### Recommendation: Quarterly Review Cycle

**Every 3 Months**:
1. **Content Audit**:
   - [ ] Check for outdated year-stamped data (e.g., "2022 data" - F007, F011)
   - [ ] Verify external links still work (APIs, tools, pricing)
   - [ ] Update tool recommendations (new alternatives available?)

2. **Dependency Check** (if any added):
   - [ ] Update markdown-link-check, cspell versions
   - [ ] Test scripts still work

3. **Issue Triage**:
   - [ ] Review open issues (if public repo)
   - [ ] Close stale issues (>90 days no activity)

4. **Community Feedback**:
   - [ ] Collect user feedback (if public)
   - [ ] Prioritize most-requested features

**Annual Review**:
- [ ] Major version planning (breaking changes)
- [ ] Deprecation cleanup (remove files marked deprecated 1 year ago)
- [ ] Legal review (UU updates, new regulations)

---

## D6.13 Governance Model

### Current State
- Single maintainer: nothingser0

### Recommendation: Document Decision-Making

**Add to CONTRIBUTING.md or README.md**:

```markdown
## Governance

**Maintainer**: @nothingser0 (final decision authority)

**Decision Process**:
- Typos, bug fixes: Merge immediately
- New templates: Maintainer approval
- New modules: Community discussion (issue) → maintainer decision
- Breaking changes: RFC (Request for Comments) → 7-day feedback period

**RFC Process** (for major changes):
1. Open issue with "[RFC]" prefix
2. Describe problem, proposed solution, alternatives
3. Collect feedback for 7 days
4. Maintainer makes final decision
5. If approved, implement via PR
```

**Rationale**: Transparency for contributors, clear escalation path.

---

## D6.14 Archival & Deprecation Policy

### Recommendation: Formalize Lifecycle

**States**:
1. **Active**: Current modules/templates (in main/)
2. **Deprecated**: Marked for removal (in deprecated/ folders, 1 release cycle)
3. **Archived**: Removed from main, available in git history only

**Process**:
```
Active → Deprecated (vX.Y.0) → Archived (vX+1.0.0)
       ↑ 1 release cycle ↑
```

**Example**:
- v1.0.0: Module 05 active
- v1.1.0: Module 05 deprecated (split to 05-prd + 05-fsd), moved to modules/deprecated/
- v2.0.0: Module 05 removed from repo (available in git tag v1.1.0)

**Deprecation Notice** (in deprecated files):
```markdown
# [DEPRECATED as of v1.1.0] Module 05: Architecture & Specs

**This file has been split. Use instead:**
- `modules/05-prd.md` (Product Requirements)
- `modules/05-fsd.md` (Functional Specification)

**Removal**: This file will be deleted in v2.0.0.
**Migration Guide**: See CHANGELOG.md v1.1.0 notes.
```

---

## Summary: D6 Maintenance Proposals

| Proposal | Priority | Effort | Impact |
|----------|---------|--------|--------|
| Adopt Semantic Versioning | High | 1 hour | Version clarity |
| Create CHANGELOG.md | High | 2 hours | Change tracking |
| Conventional Commits | Medium | Ongoing | Consistency |
| Update .gitignore | High | 10 min | Clean repo |
| Create .gitattributes | Medium | 10 min | Line ending fix |
| Remove backup files | High | 5 min | Clean repo |
| Branch strategy | Low | 0 (process only) | Collaboration |
| Public/Private audit | High (if public) | 2-4 hours | Security |
| CONTRIBUTING.md | Medium (if public) | 1 hour | Contributor guide |
| Attribution | Low | 30 min | Credit |
| Release checklist | High | 30 min | Quality gate |
| README enhancement | Medium | 1 hour | Discoverability |
| Quarterly review | Low | Ongoing | Freshness |
| Governance docs | Low | 30 min | Transparency |
| Deprecation policy | Medium | 30 min | Clear lifecycle |

**Total Initial Effort**: 6-10 hours (one-time setup) + ongoing maintenance.

---

**End of D6 Maintenance Proposals**
