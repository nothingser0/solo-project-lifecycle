# .env.example

# ==============================================================================
# DATABASE CONFIGURATION
# ==============================================================================
# PostgreSQL database connection URL (Managed / Supabase / Local)
DATABASE_URL="postgresql://postgres:password@localhost:5432/legal_vault?schema=public"

# ==============================================================================
# AUTHENTICATION & SESSION SECURITY
# ==============================================================================
# JWT session token signing key (Minimum 32 random characters)
JWT_SECRET="generate-random-secret-key-min-32-chars-replace-in-production"
# Session token expiration (e.g., 7d, 24h)
JWT_EXPIRES_IN="7d"

# ==============================================================================
# DOCUMENT VAULT ENCRYPTION (AES-256-GCM)
# ==============================================================================
# 32-byte Master Encryption Key in hexadecimal format (64 hex characters)
# Generate via terminal: node -e "console.log(crypto.randomBytes(32).toString('hex'))"
VAULT_MASTER_KEY="0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"

# ==============================================================================
# CLOUD STORAGE (CLOUDFLARE R2 / AWS S3)
# ==============================================================================
STORAGE_BUCKET_NAME="legal-document-vault-prod"
STORAGE_ACCESS_KEY="your-s3-or-r2-access-key-id"
STORAGE_SECRET_KEY="your-s3-or-r2-secret-access-key"
STORAGE_ENDPOINT="https://<account_id>.r2.cloudflarestorage.com"
STORAGE_REGION="auto"

# ==============================================================================
# TRANSACTIONAL EMAIL (RESEND / SMTP)
# ==============================================================================
EMAIL_FROM="Legal Notification <no-reply@domain.com>"
RESEND_API_KEY="re_123456789_abcdefg"

# ==============================================================================
# APPLICATION & ENVIRONMENT
# ==============================================================================
NODE_ENV="development"
NEXT_PUBLIC_APP_URL="http://localhost:3000"
PORT=3000
