# .env.example - Go Project

# ==============================================================================
# APPLICATION
# ==============================================================================
APP_ENV=development
APP_PORT=8080
APP_NAME=myapp

# ==============================================================================
# DATABASE
# ==============================================================================
DB_DRIVER=postgres
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=password
DB_NAME=myapp
DB_SSLMODE=disable
DB_MAX_OPEN_CONNS=25
DB_MAX_IDLE_CONNS=5

# ==============================================================================
# REDIS
# ==============================================================================
REDIS_HOST=localhost:6379
REDIS_PASSWORD=
REDIS_DB=0

# ==============================================================================
# JWT AUTHENTICATION
# ==============================================================================
JWT_SECRET=your-secret-key-min-32-characters
JWT_EXPIRY=24h

# ==============================================================================
# AWS S3
# ==============================================================================
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_BUCKET=your-bucket

# ==============================================================================
# EXTERNAL SERVICES
# ==============================================================================
# Email (SMTP)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password
SMTP_FROM=noreply@yourdomain.com

# ==============================================================================
# LOGGING
# ==============================================================================
LOG_LEVEL=info
LOG_FORMAT=json
