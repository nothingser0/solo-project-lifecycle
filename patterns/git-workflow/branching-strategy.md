# Git Workflow & Conventions

**Purpose**: Consistent git practices untuk solo dev & team collaboration

**Reference locations**: M03 (git branching), M06 (git workflow), M10 (git tagging)

---

## Branch Strategy

### Solo Developer (Simplified)

```bash
main          # Production-ready code
├── staging   # Pre-production testing
└── feature/* # Feature branches
```

**Workflow**:
1. Create feature branch from `main`
2. Commit incrementally with clear messages
3. Test locally → merge to `staging`
4. Test staging → merge to `main`
5. Tag release `v1.0.0`

---

### Team (Git Flow Lite)

```bash
main              # Production (protected)
├── staging       # Integration testing (protected)
├── feature/*     # New features
├── bugfix/*      # Bug fixes
└── hotfix/*      # Emergency production fixes
```

**Branch naming**:
```bash
feature/auth-login          # Feature work
feature/INV-123-inventory   # With ticket reference
bugfix/payment-timeout      # Bug fix
hotfix/critical-db-leak     # Production emergency
```

---

## Commit Conventions

### Conventional Commits

Format: `<type>(<scope>): <subject>`

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting, no code change
- `refactor`: Code restructure, no behavior change
- `perf`: Performance improvement
- `test`: Add/update tests
- `chore`: Maintenance (deps, config)
- `revert`: Revert previous commit

**Examples**:
```bash
feat(auth): add JWT refresh token rotation
fix(payment): handle Midtrans timeout retry
docs(readme): update deployment instructions
refactor(api): extract validation middleware
perf(db): add index on users.email
test(auth): add password reset flow tests
chore(deps): upgrade Next.js to 15.0.2
```

---

### Commit Message Template

```bash
# Create .gitmessage template
git config commit.template ~/.gitmessage

# ~/.gitmessage content:
# <type>(<scope>): <subject>
#
# <body>
#
# <footer>

# Example filled:
feat(auth): implement social login

Add Google OAuth 2.0 integration:
- Create /api/auth/google/callback endpoint
- Store OAuth tokens in database
- Map Google profile to user schema

Closes INV-123
```

---

### Atomic Commits

**Bad** (large, mixed changes):
```bash
git add -A
git commit -m "fix stuff"
```

**Good** (small, focused):
```bash
# Commit 1: Schema change
git add db/schema.sql
git commit -m "feat(db): add refresh_tokens table"

# Commit 2: Implementation
git add lib/auth/jwt.ts
git commit -m "feat(auth): implement token refresh"

# Commit 3: Tests
git add __tests__/auth/jwt.test.ts
git commit -m "test(auth): add JWT refresh tests"
```

---

## Daily Workflow

### Solo Developer

```bash
# Morning: Pull latest
git checkout main
git pull origin main

# Create feature branch
git checkout -b feature/user-profile

# Work & commit incrementally
git add src/components/profile.tsx
git commit -m "feat(profile): add profile edit form"

git add src/app/api/profile/route.ts
git commit -m "feat(api): add profile update endpoint"

# Push feature branch
git push -u origin feature/user-profile

# Self-review changes
git diff main..feature/user-profile

# Merge to staging for testing
git checkout staging
git merge feature/user-profile
git push origin staging

# After testing passes, merge to main
git checkout main
git merge feature/user-profile
git push origin main

# Delete feature branch
git branch -d feature/user-profile
git push origin --delete feature/user-profile
```

---

### Team Collaboration

```bash
# Morning: Sync with team
git checkout main
git pull origin main

# Create feature branch from latest main
git checkout -b feature/INV-123-inventory

# Work in small commits
git add src/features/inventory/
git commit -m "feat(inventory): add list view component"

# Push regularly (backup + show progress)
git push -u origin feature/INV-123-inventory

# Pull request review
# (Team reviews on GitHub/GitLab)

# Address review comments
git add src/features/inventory/list.tsx
git commit -m "refactor(inventory): extract table component"
git push

# After approval, squash merge to main
# (via GitHub PR merge button with squash option)

# Delete branch after merge
git branch -d feature/INV-123-inventory
git push origin --delete feature/INV-123-inventory
```

---

## Release Tagging

### SemVer Format

**Version format**: `vMAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes (v1.0.0 → v2.0.0)
- **MINOR**: New features, backward compatible (v1.0.0 → v1.1.0)
- **PATCH**: Bug fixes (v1.0.0 → v1.0.1)

---

### Create Release

```bash
# Tag current commit
git tag -a v1.0.0 -m "Release v1.0.0: Initial stable release

Features:
- User authentication (JWT)
- Document CRUD
- Payment integration (Midtrans)

Breaking changes: None
"

# Push tag to remote
git push origin v1.0.0

# List all tags
git tag -l

# View tag details
git show v1.0.0
```

---

### Hotfix Release

```bash
# Create hotfix from production tag
git checkout v1.0.0
git checkout -b hotfix/critical-auth-bug

# Fix bug
git add src/lib/auth/jwt.ts
git commit -m "fix(auth): prevent token reuse attack"

# Tag hotfix release
git tag -a v1.0.1 -m "Hotfix v1.0.1: Fix token reuse vulnerability"

# Merge back to main
git checkout main
git merge hotfix/critical-auth-bug
git push origin main
git push origin v1.0.1

# Delete hotfix branch
git branch -d hotfix/critical-auth-bug
```

---

## Undoing Changes

### Uncommitted Changes

```bash
# Discard unstaged changes
git restore <file>

# Discard all unstaged changes
git restore .

# Discard staged changes
git restore --staged <file>

# Discard everything (DANGER)
git reset --hard HEAD
```

---

### Committed Changes (Not Pushed)

```bash
# Undo last commit, keep changes
git reset --soft HEAD~1

# Undo last commit, discard changes
git reset --hard HEAD~1

# Amend last commit message
git commit --amend -m "fix(auth): correct typo in error message"

# Add forgotten file to last commit
git add forgotten-file.ts
git commit --amend --no-edit
```

---

### Committed & Pushed

```bash
# Revert commit (creates new commit)
git revert HEAD

# Revert specific commit
git revert abc123

# Revert range of commits
git revert abc123..def456
```

---

## Merge Strategies

### Fast-Forward (Solo Dev)

```bash
# Default for solo work
git checkout main
git merge feature/user-profile
# Result: Linear history
```

---

### Squash Merge (Team)

```bash
# Combine all feature commits into one
git checkout main
git merge --squash feature/user-profile
git commit -m "feat(profile): add user profile page

Squashed commits:
- Add profile form
- Add API endpoint
- Add tests
- Fix validation
"
```

**When to use**: Feature branches with many "WIP" commits

---

### Merge Commit (Preserve History)

```bash
# Keep all individual commits
git checkout main
git merge --no-ff feature/user-profile
# Result: Merge commit with full history
```

**When to use**: Important features where commit history is valuable

---

## Conflict Resolution

```bash
# When merge conflicts occur
git merge feature/payment
# Auto-merging src/api/payment.ts
# CONFLICT (content): Merge conflict in src/api/payment.ts

# Edit conflicted files
# <<<<<<< HEAD
# existing code
# =======
# incoming code
# >>>>>>> feature/payment

# After resolving conflicts
git add src/api/payment.ts
git commit -m "merge: resolve payment endpoint conflicts"
```

---

## Git Hooks (Automation)

### Pre-commit Hook

```bash
# .git/hooks/pre-commit (or use Husky)
#!/bin/bash

echo "Running pre-commit checks..."

# Lint staged files
npm run lint-staged

# Type check
npm run type-check

# Run tests
npm test -- --watchAll=false

# If any command fails, abort commit
if [ $? -ne 0 ]; then
  echo "❌ Pre-commit checks failed"
  exit 1
fi

echo "✅ Pre-commit checks passed"
```

---

### Husky Setup (Recommended)

```bash
# Install Husky
pnpm add -D husky lint-staged

# Initialize Husky
npx husky init

# Add pre-commit hook
echo "npx lint-staged" > .husky/pre-commit

# Configure lint-staged in package.json
{
  "lint-staged": {
    "*.{ts,tsx}": ["eslint --fix", "prettier --write"],
    "*.{json,md}": ["prettier --write"]
  }
}
```

---

## Common Workflows

### Feature Development

```bash
# 1. Create branch
git checkout -b feature/notifications

# 2. Work in small commits
git commit -m "feat(notif): add notification model"
git commit -m "feat(notif): add push notification service"
git commit -m "test(notif): add notification tests"

# 3. Push regularly
git push -u origin feature/notifications

# 4. Merge to main when complete
git checkout main
git merge --squash feature/notifications
git commit -m "feat(notif): add push notification system"
git push origin main

# 5. Tag release
git tag v1.1.0 -m "Add notification system"
git push origin v1.1.0
```

---

### Emergency Hotfix

```bash
# 1. Branch from production
git checkout main
git checkout -b hotfix/db-connection-leak

# 2. Fix & test
git commit -m "fix(db): close connection after query"

# 3. Merge back immediately
git checkout main
git merge hotfix/db-connection-leak
git push origin main

# 4. Tag hotfix release
git tag v1.0.1 -m "Fix database connection leak"
git push origin v1.0.1

# 5. Clean up
git branch -d hotfix/db-connection-leak
```

---

## Best Practices

### Do's ✅

- **Commit often**: Small, logical commits
- **Write clear messages**: Follow conventional commits
- **Pull before push**: Avoid conflicts
- **Branch per feature**: Isolate changes
- **Tag releases**: SemVer versioning
- **Review before merge**: Self-review or peer review

---

### Don'ts ❌

- **Don't commit secrets**: Use `.env` (gitignored)
- **Don't force push to main**: Destructive
- **Don't commit large binaries**: Use Git LFS
- **Don't mix unrelated changes**: One commit = one logical change
- **Don't amend pushed commits**: Only amend local commits
- **Don't commit `node_modules`**: Add to `.gitignore`

---

## Gitignore Template

```bash
# .gitignore
# Dependencies
node_docs/modules/
.pnp.*

# Environment
.env
.env.local
.env.*.local

# Build output
.next/
dist/
build/

# Logs
*.log
npm-debug.log*

# OS files
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo

# Testing
coverage/
.nyc_output/

# Temporary files
*.tmp
.temp/
```

---

## See Also

- `patterns/security/authentication.md` - Secrets management
- M06 Development Execution - Git workflow integration
- M10 Deployment Production - Release tagging
