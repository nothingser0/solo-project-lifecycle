# Django 5 Quickstart Guide

**Stack**: Django 5 + Python 3.12 + PostgreSQL 16 + Celery + Redis

**Timeline**: 2-4 weeks MVP for backend-heavy applications

**Best for**: REST APIs, admin-heavy apps, data processing, machine learning integration

---

## Quick Setup (20 minutes)

### 1. Initialize Project

```bash
# Create virtual environment
python3.12 -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install Django and dependencies
pip install django psycopg2-binary djangorestframework celery redis python-decouple

# Create project
django-admin startproject myproject .
cd myproject

# Create app
python manage.py startapp core
```

---

### 2. Database Setup (PostgreSQL)

**settings.py**:
```python
import os
from decouple import config

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': config('DB_NAME', default='myproject_db'),
        'USER': config('DB_USER', default='postgres'),
        'PASSWORD': config('DB_PASSWORD'),
        'HOST': config('DB_HOST', default='localhost'),
        'PORT': config('DB_PORT', default='5432'),
    }
}
```

**.env**:
```
DB_NAME=myproject_db
DB_USER=postgres
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432
SECRET_KEY=your-secret-key-here
DEBUG=True
```

**Run migrations**:
```bash
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser
```

---

### 3. Models Example

**core/models.py**:
```python
from django.db import models
from django.contrib.auth.models import User

class Document(models.Model):
    title = models.CharField(max_length=255)
    content = models.TextField(blank=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='documents')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['user', '-created_at']),
        ]
    
    def __str__(self):
        return self.title
```

---

## Project Structure

```
myproject/
├── manage.py
├── myproject/
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   ├── wsgi.py
│   └── asgi.py
├── core/
│   ├── migrations/
│   ├── __init__.py
│   ├── models.py
│   ├── views.py
│   ├── serializers.py
│   ├── urls.py
│   └── admin.py
├── requirements.txt
└── .env
```

---

## REST API with Django REST Framework

### Install DRF

```bash
pip install djangorestframework djangorestframework-simplejwt
```

**settings.py**:
```python
INSTALLED_APPS = [
    # ...
    'rest_framework',
    'rest_framework_simplejwt',
    'core',
]

REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticated',
    ),
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 20,
}
```

### Serializers

**core/serializers.py**:
```python
from rest_framework import serializers
from .models import Document

class DocumentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Document
        fields = ['id', 'title', 'content', 'user', 'created_at', 'updated_at']
        read_only_fields = ['user', 'created_at', 'updated_at']
```

### Views

**core/views.py**:
```python
from rest_framework import viewsets, permissions
from .models import Document
from .serializers import DocumentSerializer

class DocumentViewSet(viewsets.ModelViewSet):
    serializer_class = DocumentSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return Document.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
```

### URLs

**core/urls.py**:
```python
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'documents', views.DocumentViewSet, basename='document')

urlpatterns = [
    path('', include(router.urls)),
]
```

**myproject/urls.py**:
```python
from django.contrib import admin
from django.urls import path, include
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/token/', TokenObtainPairView.as_view()),
    path('api/token/refresh/', TokenRefreshView.as_view()),
    path('api/', include('core.urls')),
]
```

---

## Celery Background Tasks

**myproject/celery.py**:
```python
import os
from celery import Celery

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myproject.settings')

app = Celery('myproject')
app.config_from_object('django.conf:settings', namespace='CELERY')
app.autodiscover_tasks()
```

**myproject/__init__.py**:
```python
from .celery import app as celery_app

__all__ = ('celery_app',)
```

**settings.py**:
```python
CELERY_BROKER_URL = config('REDIS_URL', default='redis://localhost:6379/0')
CELERY_RESULT_BACKEND = config('REDIS_URL', default='redis://localhost:6379/0')
CELERY_ACCEPT_CONTENT = ['json']
CELERY_TASK_SERIALIZER = 'json'
```

**Example task** (core/tasks.py):
```python
from celery import shared_task

@shared_task
def process_document(document_id):
    from .models import Document
    doc = Document.objects.get(id=document_id)
    # Process document
    return f"Processed: {doc.title}"
```

**Run workers**:
```bash
celery -A myproject worker -l info
```

---

## Admin Customization

**core/admin.py**:
```python
from django.contrib import admin
from .models import Document

@admin.register(Document)
class DocumentAdmin(admin.ModelAdmin):
    list_display = ['title', 'user', 'created_at']
    list_filter = ['created_at', 'user']
    search_fields = ['title', 'content']
    date_hierarchy = 'created_at'
```

---

## Testing

**requirements.txt**:
```
pytest
pytest-django
pytest-cov
```

**core/tests.py**:
```python
import pytest
from django.contrib.auth.models import User
from .models import Document

@pytest.mark.django_db
def test_document_creation():
    user = User.objects.create_user('test', 'test@example.com', 'pass')
    doc = Document.objects.create(title='Test Doc', user=user)
    assert doc.title == 'Test Doc'
    assert doc.user == user
```

**Run tests**:
```bash
pytest
```

---

## Deployment (Railway / Heroku)

### Railway

1. Install Railway CLI: `npm i -g @railway/cli`
2. Login: `railway login`
3. Init: `railway init`
4. Add PostgreSQL: `railway add postgresql`
5. Deploy: `railway up`

### Environment Variables

```
DATABASE_URL=postgresql://...
SECRET_KEY=...
DEBUG=False
ALLOWED_HOSTS=.railway.app
```

---

## Performance Optimization

### Database Indexing

```python
class Document(models.Model):
    # ...
    class Meta:
        indexes = [
            models.Index(fields=['user', '-created_at']),
            models.Index(fields=['title']),
        ]
```

### Query Optimization

```python
# Bad: N+1 queries
documents = Document.objects.all()
for doc in documents:
    print(doc.user.username)

# Good: Select related
documents = Document.objects.select_related('user')
for doc in documents:
    print(doc.user.username)
```

### Caching

```python
from django.core.cache import cache

def get_documents(user_id):
    key = f'user_{user_id}_documents'
    documents = cache.get(key)
    
    if documents is None:
        documents = list(Document.objects.filter(user_id=user_id))
        cache.set(key, documents, timeout=300)
    
    return documents
```

---

## Security

**settings.py**:
```python
SECRET_KEY = config('SECRET_KEY')
DEBUG = config('DEBUG', default=False, cast=bool)
ALLOWED_HOSTS = config('ALLOWED_HOSTS', default='').split(',')

# HTTPS
SECURE_SSL_REDIRECT = not DEBUG
SESSION_COOKIE_SECURE = not DEBUG
CSRF_COOKIE_SECURE = not DEBUG
```

**CORS** (for frontend SPAs):
```bash
pip install django-cors-headers
```

```python
INSTALLED_APPS = [
    'corsheaders',
    # ...
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    # ...
]

CORS_ALLOWED_ORIGINS = [
    'http://localhost:3000',
    'https://myapp.com',
]
```

---

## Common Issues

### Migration conflicts
```bash
python manage.py makemigrations --merge
```

### Static files not loading
```bash
python manage.py collectstatic
```

### Database connection errors
Check `.env` file and ensure PostgreSQL is running.

---

## Next Steps

1. **Auth**: Implement JWT auth with DRF SimpleJWT
2. **File uploads**: Add S3/R2 integration with `django-storages`
3. **Email**: Add Resend/SendGrid for transactional emails
4. **Monitoring**: Add Sentry for error tracking
5. **API docs**: Add `drf-spectacular` for OpenAPI docs

---

## See Also

- [Django Docs](https://docs.djangoproject.com/)
- [DRF Docs](https://www.django-rest-framework.org/)
- [Celery Docs](https://docs.celeryq.dev/)
- `patterns/validation/` - Validation patterns
- `patterns/security/` - Security best practices
