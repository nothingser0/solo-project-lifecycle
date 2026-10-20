# AI Agent Guidelines - Django Project

## 0. Execution Protocol — One Task Per Turn (NON-NEGOTIABLE)

- **`TODO.md` is the queue.** Work its task list **one task at a time**.
- **Per task**: implement ONLY that task → run that task's `Verify` command → paste the raw output → report task ID + files touched + result → 🛑 **END TURN**.
- **Do NOT** start the next task, open a new sprint, or batch task IDs — unless the human names the specific task IDs to run in one instruction.
- **`[x]` is the human's mark, never yours.** Only after the human confirms may you record `Approved: <date> by <name>` in that task's `Evidence`.
- **If a spec, schema, or requirement is missing, STOP and ask** — never invent it to keep the queue moving.

---

## 1. Absolute Agent Safety Directives (NON-NEGOTIABLE)
1. **NO Destructive Git Operations**: Running `git push --force` or `git push --force-with-lease` is STRICTLY PROHIBITED.
2. **NO Destructive Database Operations in Shared / Deployed Environments**: Running `python manage.py flush` or issuing raw `DROP TABLE` / `DROP DATABASE` queries against shared, staging, or production environments is STRICTLY PROHIBITED. On local disposable test databases, execute resets only when explicitly instructed.
3. **Spec Document Integrity**: Documents marked `[FROZEN]` or `[APPROVED]` (`PRD.md`, `FSD.md`, `DESIGN_SPEC.md`, `DESIGN.md`, `SCOPE_STATEMENT.md`) are immutable. If specifications contradict, STOP AND ASK THE USER. Never alter frozen specifications unilaterally.
4. **Zero Ignored Exceptions**: Empty `except:` blocks or `# type: ignore` without justification is STRICTLY PROHIBITED.
5. **No Unrequested Commits**: Never execute commits or pushes unless explicitly instructed by the user.

---

## CRITICAL: Read Project Design Specifications

**BEFORE implementing any UI component, read project design docs in docs/ folder:**

- **docs/specs/DESIGN_SPEC.md**: Per-screen 5-state specifications (SCR-XX)
- **docs/specs/SITEMAP.md**: Route structure with Screen IDs (SCR-XX)
- **DESIGN.md** (root, staged at `docs/harness-root/DESIGN.md`): design tokens (colors, typography, z-index)

**Why**: Generic styles ≠ project design. Must match brand identity.

**For each screen/component:**
1. Find screen ID in docs/specs/SITEMAP.md (e.g., SCR-09 Dashboard)
2. Read corresponding screen section in docs/specs/DESIGN_SPEC.md
3. Check docs/design/screens/scr-09/ (or docs/design/prompts/scr-09/) if available
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

## Anti-AI-Slop Directives (ENFORCED)
1. **BANNED: Redundant Explanatory Comments** — do not narrate obvious code.
   - ❌ `# Increment counter`  |  `# Import os`
   - ❌ Stub comments: `# TODO: implement this later`  |  `# Add your logic here`
   - ✅ Comment ONLY non-obvious business logic, domain formulas, or deliberate workarounds.
   - ✅ Never leave commented-out dead code — delete it (git remembers).
2. **BANNED: Silent Failures** — no empty catch/except blocks; log, rethrow, or return a typed error.
3. **BANNED: Dead Code & Unused Imports** — remove unused variables, imports, and unreachable branches.
4. **RACE CONDITIONS (MANDATORY for any shared-state mutation)** — protect every read-modify-write on inventory, balances, counters, booking slots, or status transitions:
   - Use a DB transaction + row lock (select_for_update()), or a unique constraint / idempotency key.
   - Never "check then act" across two separate queries without a lock or constraint.
   - Webhooks and payment callbacks MUST be idempotent (dedupe on provider event ID).
   - Frontend: disable the submit button while pending + use an idempotency key to prevent double-submit.
5. **BANNED: Hallucinated APIs/Packages** — verify every import exists before using it.

---

## Anti-Patterns (NEVER)
- ❌ No raw SQL queries (use ORM)
- ❌ No logic in views (use Services/Managers)
- ❌ No print() statements in committed code
- ❌ No hardcoded secrets
- ❌ No N+1 queries (use select_related/prefetch_related)
