# CONVENTIONS.md - Django Project

> Code style standards and technical conventions for AI agents

---

## File Naming

1. **Python Files**: snake_case
   - ✅ `user_profile.py`, `auth_middleware.py`
   - ❌ `UserProfile.py`, `authMiddleware.py`

2. **Classes**: PascalCase
   ```python
   class UserProfile(models.Model):
       pass
   ```

3. **Functions/Variables**: snake_case
   ```python
   def get_user_profile(user_id):
       user_count = User.objects.count()
   ```

---

## PEP 8 Standards

1. **Imports Order**
   ```python
   # Standard library
   import os
   from datetime import datetime
   
   # Third-party
   from django.db import models
   from rest_framework import serializers
   
   # Local
   from .models import User
   ```

2. **Line Length**: Max 88 chars (Black formatter)

3. **Docstrings**: Use for all public functions/classes
   ```python
   def create_user(email: str, password: str) -> User:
       """Create a new user account.
       
       Args:
           email: User email address
           password: Plain text password (will be hashed)
       
       Returns:
           User: Created user instance
       """
       pass
   ```

---

## Django ORM Rules

1. **No Raw SQL**
   - ❌ `User.objects.raw('SELECT * FROM users')`
   - ✅ `User.objects.filter(active=True)`

2. **QuerySet Best Practices**
   ```python
   # Prevent N+1
   users = User.objects.select_related('profile').prefetch_related('orders')
   
   # Use Q objects for complex queries
   from django.db.models import Q
   users = User.objects.filter(Q(active=True) | Q(is_staff=True))
   ```

3. **Transactions**
   ```python
   from django.db import transaction
   
   @transaction.atomic
   def create_user_with_profile(data):
       user = User.objects.create(**data['user'])
       Profile.objects.create(user=user, **data['profile'])
       return user
   ```

---

## Views & Serializers

1. **Class-Based Views** (DRF)
   ```python
   from rest_framework import viewsets
   
   class UserViewSet(viewsets.ModelViewSet):
       queryset = User.objects.all()
       serializer_class = UserSerializer
       permission_classes = [IsAuthenticated]
   ```

2. **Serializer Validation**
   ```python
   class UserSerializer(serializers.ModelSerializer):
       class Meta:
           model = User
           fields = ['id', 'email', 'name']
           read_only_fields = ['id']
       
       def validate_email(self, value):
           if User.objects.filter(email=value).exists():
               raise serializers.ValidationError("Email already exists")
           return value
   ```

---

## Error Handling

1. **Never Bare Except**
   ```python
   # ❌ Bad
   try:
       user = User.objects.get(id=user_id)
   except:
       pass
   
   # ✅ Good
   try:
       user = User.objects.get(id=user_id)
   except User.DoesNotExist:
       logger.error(f'User {user_id} not found')
       raise
   ```

2. **API Error Responses**
   ```python
   from rest_framework.response import Response
   from rest_framework import status
   
   return Response(
       {'error': 'Resource not found'},
       status=status.HTTP_404_NOT_FOUND
   )
   ```

---

## Settings Management

1. **Environment-Specific Settings**
   ```python
   # settings/base.py - shared settings
   # settings/development.py - dev overrides
   # settings/production.py - prod overrides
   ```

2. **Secret Management**
   - Use `django-environ` or similar
   - Never hardcode secrets
   ```python
   import environ
   env = environ.Env()
   SECRET_KEY = env('SECRET_KEY')
   ```

---

## Testing

1. **Test File Naming**: `test_*.py`
   ```python
   # tests/test_models.py
   from django.test import TestCase
   
   class UserModelTest(TestCase):
       def test_create_user(self):
           user = User.objects.create(email='test@example.com')
           self.assertEqual(user.email, 'test@example.com')
   ```
