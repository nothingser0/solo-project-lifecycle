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


## CRITICAL: Read Official Documentation First

**BEFORE implementing any feature, check official docs for current syntax:**

- **Django Docs**: https://docs.djangoproject.com/en/stable/ (check version-specific pages)
- **Python Docs**: https://docs.python.org/3/
- **Django ORM**: https://docs.djangoproject.com/en/stable/topics/db/queries/
- **Django REST Framework**: https://www.django-rest-framework.org/ (if using DRF)

**Why**: Django syntax changes between versions. This project uses:
- Django 5.x (check requirements.txt for exact version)
- Breaking changes exist between major versions (4.x vs 5.x)

### Version-Specific Syntax Enforcement

**MANDATORY: Check docs before using these APIs** (syntax changes frequently):

| API Category | Docs URL | Common Version Conflicts |
|:-------------|:---------|:-------------------------|
| **Models & ORM** | https://docs.djangoproject.com/en/stable/topics/db/models/ | Field types evolve per version |
| **Views (CBV)** | https://docs.djangoproject.com/en/stable/topics/class-based-views/ | Mixin syntax changes |
| **URL Patterns** | https://docs.djangoproject.com/en/stable/topics/http/urls/ | path() vs re_path() |
| **Forms** | https://docs.djangoproject.com/en/stable/topics/forms/ | Widget rendering changes |
| **Migrations** | https://docs.djangoproject.com/en/stable/topics/migrations/ | Operation syntax evolves |
| **Admin** | https://docs.djangoproject.com/en/stable/ref/contrib/admin/ | Customization API changes |

**Red Flags (Outdated Patterns):**

❌ **Django 3.x Patterns (DO NOT USE)**:
```python
# ❌ OLD: url() function (pre-4.x)
from django.conf.urls import url
urlpatterns = [url(r'^articles/', views.articles)]

# ✅ NEW: path() function (4.x+)
from django.urls import path
urlpatterns = [path('articles/', views.articles)]
```

❌ **Python 2.x Patterns (DO NOT USE)**:
```python
# ❌ OLD: unicode strings
from __future__ import unicode_literals

# ✅ NEW: Python 3 native strings
# No import needed
```

**Enforcement Rules**:
1. **Before using any API**: Search Django docs for exact function/class name
2. **Check version dropdown**: Verify docs match requirements.txt version
3. **Run `pip show django`**: Confirm installed version
4. **If syntax error**: Update code to match docs, not vice versa

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
