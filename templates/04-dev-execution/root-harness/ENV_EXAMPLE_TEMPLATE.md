# .env.example

# ==============================================================================
# KONFIGURASI BASIS DATA
# ==============================================================================
# URL koneksi basis data PostgreSQL (Managed / Supabase / Lokal)
DATABASE_URL="postgresql://postgres:password@localhost:5432/legal_vault?schema=public"

# ==============================================================================
# KEAMANAN OTENTIKASI & SESI
# ==============================================================================
# Kunci penandatangan token sesi JWT (Minimal 32 karakter acak)
JWT_SECRET="generate-random-secret-key-min-32-chars-replace-in-production"
# Masa berlaku token sesi (contoh: 7d, 24h)
JWT_EXPIRES_IN="7d"

# ==============================================================================
# ENKRIPSI DOKUMEN VAULT (AES-256-GCM)
# ==============================================================================
# Kunci Master Enkripsi 32-byte dalam format heksadesimal (64 karakter hex)
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
# EMAIL TRANSAKSIONAL (RESEND / SMTP)
# ==============================================================================
EMAIL_FROM="Notifikasi Legal <no-reply@domain.com>"
RESEND_API_KEY="re_123456789_abcdefg"

# ==============================================================================
# APLIKASI & LINGKUNGAN
# ==============================================================================
NODE_ENV="development"
NEXT_PUBLIC_APP_URL="http://localhost:3000"
PORT=3000
