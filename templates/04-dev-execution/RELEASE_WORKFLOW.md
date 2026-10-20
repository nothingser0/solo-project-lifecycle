# Release Workflow (Dev → Clean Main)

> **Purpose**: Step-by-step runbook to ship a clean production release from a `dev` branch that
> contains AI harness files (`AGENTS.md`, `TODO.md`, `docs/pm/`, …) to a `main` branch that
> contains ONLY code + client-facing specs — with **zero AI-harness residue** in the tree or history.
> **Audience**: Solo developer + AI coding agent.
> **Location**: Root `RELEASE_WORKFLOW.md`.
> **Rule**: The exclusion list lives in `scripts/release/release-exclude.txt` and is the SINGLE source
> of truth. NEVER toggle `.gitignore` by hand to "hide" harness files — that does not untrack files already committed.

---

## 0. The Core Concept (read this first)

`.gitignore` only stops files that were **never** tracked. It CANNOT remove a file that was already
committed on `dev`. The ONLY reliable way to strip harness files from a release is:

```bash
git rm -r --cached <path>   # untrack from the index
```

So the workflow is: build a **release branch** from `dev`, `git rm` the harness there, then
squash-merge that clean branch into `main`. Because the strip happens BEFORE the merge, `main`'s
history never records a "delete harness" diff.

| Branch | Contains | Purpose |
| :--- | :--- | :--- |
| `dev` | code + harness + docs | AI agent works here (harness always tracked) |
| `release/vX.Y.Z` | code + client specs (harness stripped) | Temporary bridge branch |
| `main` | code + client specs ONLY | Production / client handover |

---

## 1. One-Time Setup

```bash
git init
git checkout -b dev
git checkout -b main      # keep main present but empty until first release
git checkout dev
```

Create `scripts/release/release-exclude.txt` (already scaffolded; edit to taste):

```
# --- AI Agent Harness (root) ---
AGENTS.md
CLAUDE.md
GEMINI.md
.cursorrules
.windsurfrules
CONTEXT.md
ARCHITECTURE.md
CONVENTIONS.md
TODO.md
VERIFY_LOCAL.md
RUNBOOK_LOCAL.md
LEARNINGS.md

# --- Staging & internal process documents ---
docs/harness-root/
docs/pm/
docs/qa/

# --- Scratch / process artifacts ---
*.scratch.*
rejected-rows.csv

# --- Release tooling (dev-only) ---
scripts/release/
```

> Keep `.gitignore` on `dev` FREE of these paths — you WANT the harness tracked on `dev`.

---

## 2. Daily Development (on `dev`)

```bash
git checkout dev
# ...AI agent implements features, commits...
git add -A
git commit -m "feat: implement X"
git push origin dev
```

Nothing special here. Harness files are tracked normally.

---

## 3. Ship a Release — Option A: Automated (recommended)

The helper script does steps 3.1–3.5 for you and aborts if anything leaks:

```bash
# Git Bash / WSL / macOS / Linux
./scripts/release/build-clean-release.sh v1.0.1

# Windows PowerShell
.\scripts\release\build-clean-release.ps1 -Version v1.0.1
```

Flags:
- `--keep-branch` / `-KeepBranch` — keep `release/v1.0.1` so you can open a PR (see §5).
- `--base dev --target main` — override branch names.

The script prints the manual push/tag commands. It NEVER pushes for you.

---

## 4. Ship a Release — Option B: Manual (copy-paste)

### 4.1 Create the release branch from `dev`
```bash
git checkout dev
git checkout -B release/v1.0.1
```

### 4.2 Strip harness on the release branch
```bash
while IFS= read -r f; do
  f="${f%$'\r'}"                                  # strip Windows CR
  [ -z "$f" ] && continue
  case "$f" in \#*) continue ;; esac              # skip comments
  git rm -r --cached --quiet "$f" 2>/dev/null || true
done < scripts/release/release-exclude.txt

git commit -m "chore(release): strip dev-only artifacts for v1.0.1"
```

### 4.3 Squash-merge into `main`
```bash
git checkout main
git merge --squash --allow-unrelated-histories release/v1.0.1
git commit -m "release: v1.0.1"
```
> `--allow-unrelated-histories` is required when `main` was created as an orphan (no shared parent).
> It is harmless when histories are shared.

### 4.4 VERIFY before pushing (mandatory)
```bash
git ls-files | grep -iE "AGENTS|CONTEXT|TODO|LEARNINGS|docs/pm|docs/qa|scripts/release" \
  && echo "❌ HARNESS STILL PRESENT — DO NOT PUSH" \
  || echo "✅ CLEAN"
```
If you see `❌`, do NOT push. Re-run step 4.2.

### 4.5 Delete the release branch, push, tag
```bash
git branch -D release/v1.0.1
git push origin main
git tag -a v1.0.1 -m "Release v1.0.1"
git push origin v1.0.1
```

---

## 5. If You Want a Pull Request

`git merge --squash` on an **orphan** `main` cannot be a PR (no shared history). Two choices:

| Goal | Setup | PR? | Harness in `main` history? |
| :--- | :--- | :-: | :-: |
| Cleanest possible `main` (handover, private) | orphan `main` + `push -f` | ❌ | ✅ NONE |
| Review/PR workflow | `main` branched from `dev` | ✅ | ⚠️ present in old `dev` commits |

**PR flow**:
```bash
./scripts/release/build-clean-release.sh v1.0.1 --keep-branch
git push origin release/v1.0.1
git push origin main
# Open PR: release/v1.0.1 -> main, then merge on the platform
```
> Note: when `main` shares history with `dev`, `git log main -- AGENTS.md` will still list the old
> `dev` commits. The `main` **tree** is clean, but the **history** is not. Only an orphan `main`
> removes history residue.

---

## 6. Repeating for v1.0.2, v1.0.3, …

Same steps, new version. On `dev` you keep working; each release produces exactly ONE new commit on
`main`. Verified behavior over three consecutive releases:

```
main history:
  release: v1.0.2
  release: v1.0.1
  release: v1.0.0
  init main

git log main -- AGENTS.md   →  (empty)   # harness never appears in main history
```

---

## 7. Anti-Patterns (DO NOT)

| ❌ Don't | Why |
| :--- | :--- |
| Add harness files to `.gitignore` on `dev` and expect them gone | `.gitignore` cannot untrack already-committed files |
| `git rm` harness directly on `main` after merging | Leaves a "delete harness" diff in `main` history |
| Toggle `.gitignore` on/off between dev and release | Fragile, error-prone, easy to forget |
| `git push -f origin main` without verifying (step 4.4) | You may ship harness residue to the client |
| Delete `docs/specs/` | That is the client-facing architecture documentation — KEEP it |

---

## 8. What Stays vs What Goes

| KEEP in release | STRIP from release |
| :--- | :--- |
| `src/`, `app/`, `lib/` (all code) | `AGENTS.md`, `CLAUDE.md`, `.cursorrules` |
| `docs/specs/` (FSD, PRD, SITEMAP, DESIGN_SPEC) | `TODO.md`, `VERIFY_LOCAL.md`, `RUNBOOK_LOCAL.md` |
| `docs/design/` | `CONTEXT.md`, `LEARNINGS.md`, `ARCHITECTURE.md` |
| `README.md`, `LICENSE`, `CHANGELOG.md` | `docs/pm/`, `docs/qa/`, `docs/harness-root/` |
| Migrations, `.env.example`, config | `scripts/release/`, scratch files |
