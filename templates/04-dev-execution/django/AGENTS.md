# AI Agent Guidelines - Django Project

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
