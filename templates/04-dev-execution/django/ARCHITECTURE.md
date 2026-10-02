# ARCHITECTURE.md - Django Project

> Technical architecture, directory layout, database schema, and API contracts

---

## System Topology

```text
[ Client (Browser/Mobile) ]
        │
        ▼ (HTTPS / JSON API)
  [ Django + DRF ]
        │
   ┌────┴────┬────────┬──────────┐
   ▼         ▼        ▼          ▼
[ PostgreSQL ] [ Redis ] [ S3 ] [ Celery ]
```

---

## Directory Structure

```text
myproject/
├── myproject/              # Project root
│   ├── settings/          # Split settings (base, dev, prod)
│   ├── urls.py           # Root URL config
│   └── wsgi.py           # WSGI entry point
├── apps/
│   ├── users/            # User management app
│   │   ├── models.py
│   │   ├── views.py
│   │   ├── serializers.py
│   │   └── urls.py
│   └── [domain]/         # Business domain apps
├── common/               # Shared utilities
│   ├── permissions.py
│   ├── pagination.py
│   └── exceptions.py
├── tests/               # Test suite
└── manage.py           # Django CLI
```

---

## Database Schema

Refer to `docs/specs/FSD.md` for complete schema.

Key models:
- **User**: Authentication (Django built-in or custom)
- **[DomainModel]**: Core business entities

Migration naming: `NNNN_auto_YYYYMMDD_HHMM.py`

---

## API Routes (DRF)

| Endpoint | Method | ViewSet | Permission | Response |
|----------|--------|---------|------------|----------|
| `/api/auth/login/` | POST | TokenObtainPairView | AllowAny | 200 + tokens |
| `/api/[resource]/` | GET | [Resource]ViewSet | IsAuthenticated | 200 + array |
| `/api/[resource]/` | POST | [Resource]ViewSet | IsAuthenticated | 201 + object |
| `/api/[resource]/{id}/` | GET | [Resource]ViewSet | IsAuthenticated | 200 |
| `/api/[resource]/{id}/` | PUT | [Resource]ViewSet | IsAuthenticated | 200 |
| `/api/[resource]/{id}/` | DELETE | [Resource]ViewSet | IsAuthenticated | 204 |

---

## URL Configuration

```python
# myproject/urls.py
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/auth/', include('rest_framework.urls')),
    path('api/', include('apps.users.urls')),
]

# apps/users/urls.py
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register(r'users', UserViewSet)

urlpatterns = router.urls
```

---

## Middleware Stack

```python
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
]
```

---

## Security Rules

1. **Django ORM**: No raw SQL queries
2. **Permissions**: Define per ViewSet
3. **Authentication**: JWT tokens (djangorestframework-simplejwt)
4. **Validation**: Serializers for all inputs
5. **CSRF**: Enabled for session auth, exempt for token auth
