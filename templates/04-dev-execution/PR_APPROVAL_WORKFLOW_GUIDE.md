# Pull Request Approval Workflow Guide

> **Purpose**: Enforce code review process for Large/Enterprise projects  
> **When**: M06 Development (multi-developer teams)  
> **Target**: Large projects (3+ developers) requiring PR approval

---

## PR Approval Rules by Scale

| Scale | PR Required? | Approvers | CI Checks | Merge Strategy |
|:------|:-------------|:----------|:----------|:---------------|
| Small (1-2 dev) | Optional | None (direct commit OK) | Basic linting | Squash merge |
| Medium (3-6 dev) | Recommended | 1 reviewer | Lint + tests | Squash merge |
| **Large (7+ dev)** | **Required** | **2 reviewers** | **Full CI/CD** | **Merge commit** |
| Enterprise | Required | 2+ reviewers + security scan | Full CI/CD + SAST | Merge commit |

---

## GitHub PR Rules Setup

### Step 1: Enable Branch Protection

1. Go to repository → Settings → Branches
2. Add rule for `main` branch
3. Enable protections:

```yaml
Branch name pattern: main

Protect matching branches:
☑ Require a pull request before merging
  ☑ Require approvals: 2
  ☑ Dismiss stale pull request approvals when new commits are pushed
  ☑ Require review from Code Owners (optional)

☑ Require status checks to pass before merging
  ☑ Require branches to be up to date before merging
  Status checks:
    - ci/lint
    - ci/test
    - ci/build

☑ Require conversation resolution before merging
☑ Require signed commits (optional for Large, required for Enterprise)
☑ Require linear history
☑ Include administrators (enforce rules for everyone)

☐ Allow force pushes (disabled)
☐ Allow deletions (disabled)
```

---

## PR Workflow

### Developer: Create PR

1. **Create feature branch**:
```bash
git checkout -b feat/user-authentication
# Work on feature
git commit -m "feat: add JWT authentication"
git push origin feat/user-authentication
```

2. **Open PR via GitHub CLI** (recommended):
```bash
gh pr create \
  --title "feat: Add JWT authentication" \
  --body "$(cat <<EOF
## Changes
- Implement JWT token generation
- Add refresh token logic
- Secure password hashing with bcrypt

## Testing
- Unit tests: 12/12 passing
- Integration tests: 5/5 passing
- Manual test: Login flow verified

## Screenshots
[Attach login flow screenshot]

## Checklist
- [x] Tests added/updated
- [x] Documentation updated
- [x] No breaking changes
- [x] Follows code style guide
EOF
)" \
  --assignee @me \
  --label "enhancement" \
  --reviewer tech-lead,senior-dev
```

3. **Wait for CI checks + reviews**

---

### Reviewer 1: Code Review

**Review Checklist**:

#### Functionality
- [ ] Code does what PR claims
- [ ] Edge cases handled
- [ ] Error handling present
- [ ] No obvious bugs

#### Code Quality
- [ ] Follows project conventions
- [ ] No code duplication
- [ ] Functions <50 lines
- [ ] Clear naming

#### Tests
- [ ] Tests added for new code
- [ ] Tests actually test behavior (not just pass)
- [ ] Coverage maintained or improved

#### Security
- [ ] No hardcoded secrets
- [ ] Input validation present
- [ ] SQL injection prevented (parameterized queries)
- [ ] XSS prevented (sanitized output)

#### Performance
- [ ] No N+1 queries
- [ ] Efficient algorithms
- [ ] No blocking operations on main thread

**Review Comments**:
```
Requesting changes:
- Line 47: This query will cause N+1 problem. Use eager loading.
- Line 82: Password validation too weak. Add min 12 chars + special char requirement.
- Missing unit test for edge case: empty email string.

Otherwise looks good! Fix these 3 items and I'll approve.
```

**GitHub Review Actions**:
- **Approve**: Code ready to merge
- **Request Changes**: Must fix before merge
- **Comment**: Suggestions, not blocking

---

### Developer: Address Feedback

1. **Fix requested changes**:
```bash
git checkout feat/user-authentication
# Fix issues
git commit -m "fix: address code review feedback"
git push origin feat/user-authentication
```

2. **Reply to review comments**:
```
> Line 47: N+1 problem

Fixed in commit abc123. Now using `include` for eager loading.

> Line 82: Password validation weak

Updated to require 12+ chars, 1 uppercase, 1 number, 1 special char.

> Missing unit test

Added test case for empty email (test_empty_email_validation)
```

3. **Re-request review**:
```bash
gh pr review --request-changes
```

---

### Reviewer 2: Second Approval

**Second reviewer focuses on**:
- Different perspective (not same as Reviewer 1)
- Architecture fit (does this integrate well?)
- Long-term maintenance (is this sustainable?)

**Approve if**:
- All Reviewer 1 feedback addressed
- No new issues found
- CI checks passing

---

### Tech Lead: Merge PR

**Pre-merge checklist**:
- [ ] 2 approvals received
- [ ] All CI checks passing (lint, test, build)
- [ ] All conversations resolved
- [ ] Branch up to date with main

**Merge**:
```bash
gh pr merge 123 --merge --delete-branch
```

**Merge commit message**:
```
Merge pull request #123 from user/feat/user-authentication

feat: Add JWT authentication

- Implement JWT token generation
- Add refresh token logic
- Secure password hashing with bcrypt

Reviewed-by: tech-lead, senior-dev
```

---

## PR Size Guidelines

**Keep PRs small** (easier to review):

| Size | Lines Changed | Files | Review Time | Recommendation |
|:-----|:--------------|:------|:------------|:---------------|
| XS | <50 | 1-2 | 5 min | ✅ Ideal |
| S | 50-200 | 2-5 | 15 min | ✅ Good |
| M | 200-500 | 5-10 | 30 min | ⚠️ OK |
| L | 500-1000 | 10-20 | 1 hour | ⚠️ Split if possible |
| XL | >1000 | >20 | 2+ hours | ❌ Too large, split required |

**How to split large PRs**:
1. PR #1: Database schema changes
2. PR #2: Backend API (depends on #1)
3. PR #3: Frontend UI (depends on #2)

---

## Code Owner Rules (Optional)

**CODEOWNERS file** (`.github/CODEOWNERS`):
```
# Global owners
* @tech-lead

# Backend team owns API
/src/api/ @backend-team
/src/database/ @backend-team

# Frontend team owns UI
/src/components/ @frontend-team
/src/pages/ @frontend-team

# Security team must review auth
/src/auth/ @security-team

# DevOps owns CI/CD
/.github/workflows/ @devops-team
/docker/ @devops-team
```

**Effect**: PRs touching these files automatically request review from owners.

---

## PR Templates

**`.github/pull_request_template.md`**:
```markdown
## Description
[What does this PR do?]

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guide
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No new warnings
- [ ] Tests pass locally

## Screenshots (if UI changes)
[Attach before/after screenshots]

## Related Issues
Closes #123
```

---

## CI/CD Integration

**GitHub Actions workflow** (`.github/workflows/pr-checks.yml`):
```yaml
name: PR Checks

on:
  pull_request:
    branches: [main, develop]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 20
      - run: npm ci
      - run: npm run lint

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 20
      - run: npm ci
      - run: npm test
      - name: Upload coverage
        uses: codecov/codecov-action@v3

  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 20
      - run: npm ci
      - run: npm run build

  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Snyk security scan
        uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
```

---

## PR Anti-Patterns (Avoid!)

### Anti-Pattern 1: Rubber Stamp Approval
❌ **Problem**: Approve without reading code  
✅ **Fix**: Actually review, leave comments

### Anti-Pattern 2: Huge PRs
❌ **Problem**: 2000 lines changed, 50 files  
✅ **Fix**: Split into 3-5 smaller PRs

### Anti-Pattern 3: Stale PRs
❌ **Problem**: PR open for 2 weeks, conflicts with main  
✅ **Fix**: Review within 24 hours, merge or close

### Anti-Pattern 4: Endless Bikeshedding
❌ **Problem**: 20 comments about variable naming  
✅ **Fix**: Use linter rules, focus on logic

### Anti-Pattern 5: No Tests
❌ **Problem**: New feature, zero tests  
✅ **Fix**: Require tests, block merge if missing

---

## Emergency Hotfix Process

**When production is broken** (bypass PR rules):

1. **Create hotfix branch**:
```bash
git checkout -b hotfix/critical-login-bug main
# Fix bug
git commit -m "hotfix: fix login crash"
git push origin hotfix/critical-login-bug
```

2. **Fast-track PR**:
```bash
gh pr create --title "HOTFIX: Fix login crash" --label "hotfix" --assignee tech-lead
```

3. **Single approval + merge**:
- Tech lead reviews immediately
- Approve if fix is correct
- Merge without waiting for 2nd reviewer

4. **Post-mortem**:
- Document incident
- Add test to prevent regression
- Review why bug reached production

---

## Metrics to Track

**PR Health Indicators**:
- **Time to first review**: <4 hours (good), >24 hours (bad)
- **Time to merge**: <1 day (good), >3 days (bad)
- **Review cycles**: 1-2 cycles (good), >3 cycles (bad)
- **PR size**: <200 lines (good), >500 lines (bad)

**Team Dashboard** (GitHub Insights):
- Open PRs count (goal: <10)
- Oldest PR age (goal: <3 days)
- Review response time
- Merge frequency

---

## Integration with Workflow

**M06 Development**:
- Week 1-2: Small team → PRs optional
- Week 3+: Team grows → Enable PR rules
- Before M07 QA: All PRs merged, main branch clean

**Daily Routine**:
- 9:00 AM: Review assigned PRs (30 min)
- During day: Address review feedback
- 5:00 PM: Create PR for today's work

---

## Tools

**PR Management**:
- GitHub CLI (`gh pr create`, `gh pr review`)
- GitHub Desktop (visual PR creation)
- GitKraken (visual diff + merge)

**Code Review**:
- GitHub web UI (default)
- VSCode GitHub PR extension
- JetBrains IDE GitHub integration

**Automation**:
- Renovate (dependency update PRs)
- Dependabot (security update PRs)
- GitHub Actions (CI/CD)

---

## Checklist

Before enabling PR rules:
- [ ] Team trained on PR workflow
- [ ] CI/CD pipeline working
- [ ] Branch protection rules configured
- [ ] CODEOWNERS file created (optional)
- [ ] PR template added

Daily PR workflow:
- [ ] Review assigned PRs within 4 hours
- [ ] Keep PRs <200 lines when possible
- [ ] Address feedback within 24 hours
- [ ] Merge PRs within 1 day of approval

---

## Notes

**PR rules are not bureaucracy**: They catch bugs before production

**Trust but verify**: Even senior devs need code review

**Review is teaching**: Junior devs learn from feedback

**Fast reviews matter**: Slow reviews kill momentum
