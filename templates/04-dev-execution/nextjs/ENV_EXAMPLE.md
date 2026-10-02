# .env.example - Next.js Project

# ==============================================================================
# DATABASE
# ==============================================================================
DATABASE_URL="postgresql://user:password@localhost:5432/dbname"

# ==============================================================================
# AUTHENTICATION
# ==============================================================================
# NextAuth.js secret (generate: openssl rand -base64 32)
NEXTAUTH_SECRET="generate-random-secret-min-32-chars"
NEXTAUTH_URL="http://localhost:3000"

# Session token expiry
JWT_EXPIRES_IN="7d"

# ==============================================================================
# EXTERNAL SERVICES
# ==============================================================================
# Email (Resend / SMTP)
RESEND_API_KEY="re_xxxxxxxxxxxx"
EMAIL_FROM="App <noreply@yourdomain.com>"

# Storage (S3 / R2)
S3_BUCKET_NAME="your-bucket"
S3_ACCESS_KEY="your-access-key"
S3_SECRET_KEY="your-secret-key"
S3_REGION="us-east-1"

# ==============================================================================
# APPLICATION
# ==============================================================================
NODE_ENV="development"
NEXT_PUBLIC_APP_URL="http://localhost:3000"
PORT=3000
