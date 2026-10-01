# Root Harness Bundle

Bundle 7 root harness files untuk copy manual setelah framework scaffold.

## Usage

```bash
# After framework scaffold selesai (Next.js/Laravel/Flutter/etc)
cp /path/to/skill/templates/04-dev-execution/root-harness/* .
```

## Files Included

1. `AGENTS_TEMPLATE.md` → `AGENTS.md`
2. `CONTEXT_TEMPLATE.md` → `CONTEXT.md`
3. `ARCHITECTURE_TEMPLATE.md` → `ARCHITECTURE.md`
4. `DESIGN_MD_TEMPLATE.md` → `DESIGN.md`
5. `CONVENTIONS_TEMPLATE.md` → `CONVENTIONS.md`
6. `ENV_EXAMPLE_TEMPLATE.md` → `.env.example`
7. `TODO_TEMPLATE.md` → `TODO.md`

## Critical: Next.js AGENTS.md Conflict

Next.js 15 auto-generates `AGENTS.md` boilerplate (9 lines, no enforcement).

**WAJIB overwrite IMMEDIATELY**:
```bash
cp AGENTS_TEMPLATE.md AGENTS.md
```

## Framework-Agnostic

Bundle ini framework-agnostic. Tidak terkunci Next.js, bisa untuk Laravel, Python FastAPI, Flutter, dll.
