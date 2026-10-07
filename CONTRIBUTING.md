# Contributing to Solo Project Lifecycle

Thank you for contributing to the `solo-project-lifecycle` framework.

---

## 1. Core Principles

1. **Pragmatic & Production-Tested**: Every template, script, and pattern must be battle-tested on real production systems. No theoretical boilerplate.
2. **Template-First Design**: Changes to module workflows must be reflected in the corresponding templates in `templates/`.
3. **Cross-Platform Script Parity**: All utility scripts in `scripts/` MUST have identical implementations in both Bash (`.sh`) and PowerShell (`.ps1`).
4. **Anti-Hallucination & Evidence First**: Do not embed synthetic user quotes or fabricate validation numbers in templates.

---

## 2. Development Workflow

### Prerequisites
- Node.js (v20 LTS or v22 LTS)
- Bash (Linux/macOS/WSL/Git Bash)
- PowerShell (Windows or pwsh)

### Running Local Verifications
Before opening a Pull Request, run the local verification suite:

```bash
# 1. Validate SKILL.md frontmatter
node scripts/verify-skill-frontmatter.js

# 2. Check all markdown internal links
node scripts/verify-links.js

# 3. Check Bash script syntax
for f in scripts/*.sh; do bash -n "$f"; done

# 4. Check PowerShell scripts (on Windows / pwsh)
powershell -ExecutionPolicy Bypass -File scripts/verify-all.ps1
```

---

## 3. Commit Message Conventions

This project strictly adheres to [Conventional Commits](https://www.conventionalcommits.org/):

- `feat(modules)`: New module or major workflow addition
- `feat(patterns)`: New cross-cutting pattern
- `fix(scripts)`: Bug fix in CLI or validation script
- `docs(templates)`: Updates to template specifications
- `refactor(stacks)`: Stack quickstart improvements
- `ci`: Changes to GitHub Actions or CI scripts

---

## 4. Submitting a Pull Request

1. Branch from `dev`: `git checkout -b feat/my-improvement`
2. Keep diffs focused and atomic.
3. Verify that `./scripts/verify-links.js` exits with code 0.
4. Submit PR against the `dev` branch.
