# .env.example - Django Project

# ==============================================================================
# DJANGO CORE
# ==============================================================================
SECRET_KEY="django-insecure-replace-this-with-random-50-chars"
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1

# ==============================================================================
# DATABASE
# ==============================================================================
DB_ENGINE=django.db.backends.postgresql
DB_NAME=myproject
DB_USER=postgres
DB_PASSWORD=password
DB_HOST=localhost
DB_PORT=5432

# ==============================================================================
# CACHE & SESSION
# ==============================================================================
REDIS_URL=redis://localhost:6379/0
CACHE_TTL=300

# ==============================================================================
# EMAIL
# ==============================================================================
EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-app-password
DEFAULT_FROM_EMAIL=noreply@yourdomain.com

# ==============================================================================
# CELERY (Background Tasks)
# ==============================================================================
CELERY_BROKER_URL=redis://localhost:6379/0
CELERY_RESULT_BACKEND=redis://localhost:6379/0

# ==============================================================================
# AWS S3 (Media Storage)
# ==============================================================================
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_STORAGE_BUCKET_NAME=your-bucket
AWS_S3_REGION_NAME=us-east-1

# ==============================================================================
# SECURITY
# ==============================================================================
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8000
CSRF_TRUSTED_ORIGINS=http://localhost:3000

# ==============================================================================
# LOGGING
# ==============================================================================
LOG_LEVEL=INFO
