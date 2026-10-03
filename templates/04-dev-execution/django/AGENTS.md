# AI Agent Guidelines - Django Project

## CRITICAL: Read Official Documentation First

**BEFORE implementing any feature, check official docs for current syntax:**

- **Framework Docs**: Check version-specific pages for current API
- **ORM Docs**: Database query syntax, migrations, relationships
- **Validation Docs**: Input validation, form handling

**Why**: Framework syntax changes between versions. This project uses specific versions locked in FSD.md.

**When uncertain about syntax:**
1. Read official docs for installed version
2. Check migration guides for breaking changes
3. Verify with tests before committing

## CRITICAL: Read Project Design Specifications

**BEFORE implementing any UI component, read project design docs in docs/ folder:**

- **docs/specs/DESIGN_SYSTEM.md**: Design tokens, screen specifications, component styles
- **docs/specs/SITEMAP.md**: Route structure with Screen IDs (SCR-XX)
- **docs/design/stitch-output/**: Generated screen components (if using Google Stitch)
- **DESIGN.md** (root): Simplified tokens reference (copied from docs/)

**Why**: Generic styles ≠ project design. Must match brand identity.

**For each screen/component:**
1. Find screen ID in docs/specs/SITEMAP.md (e.g., SCR-09 Dashboard)
2. Read corresponding section in docs/specs/DESIGN_SYSTEM.md
3. Check docs/design/stitch-output/SCR-09/ if available
4. Extract design tokens from DESIGN.md (root)
5. Implement exactly as specified

---
## Code Style Rules
1. **PEP 8**: Follow Python style guide (snake_case for functions/variables).
2. **Django ORM Only**: No raw SQL queries. Use QuerySet API.
3. **File Naming**: snake_case for all Python files (`user_profile.py`).
4. **Validation**: Use Django Forms or DRF Serializers.
5. **Settings**: Use environment-specific settings (`settings/production.py`).

## Database
- ORM: Django ORM (built-in)
- Migrations: `python manage.py makemigrations && python manage.py migrate`
- Seeding: Custom management commands or fixtures

## Testing
- Run: `python manage.py test` or `pytest`
- Must pass before commit

## Build Commands
- Dev: `python manage.py runserver`
- Collect Static: `python manage.py collectstatic`
- Celery: `celery -A myproject worker`

## Commit Format
```
feat: add user profile view
fix: resolve authentication issue
refactor: extract payment logic
```

## Anti-Patterns (NEVER)
- ❌ No raw SQL queries (use ORM)
- ❌ No logic in views (use Services/Managers)
- ❌ No print() statements in committed code
- ❌ No hardcoded secrets
- ❌ No N+1 queries (use select_related/prefetch_related)
