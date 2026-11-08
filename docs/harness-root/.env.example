# ==============================================================================
# ENVIRONMENT CONFIGURATION BLUEPRINT (.env.example)
# ==============================================================================
#
# PANDUAN PENGISIAN (.env):
# 1. Salin file ini menjadi .env di root proyek:
#      cp .env.example .env
# 2. File .env sudah otomatis masuk .gitignore — JANGAN PERNAH commit file .env!
# 3. Ikuti instruksi "CARA MENDAPATKAN" di setiap seksi di bawah ini untuk
#    mengisi variabel sesuai lingkungan Anda (Local Development vs Production).
# ==============================================================================

# ==============================================================================
# 1. APPLICATION CORE & SERVER
# ==============================================================================
# CARA MENDAPATKAN:
# - NODE_ENV: Gunakan 'development' untuk lokal, 'test' untuk automated testing,
#   atau 'production' pada server live.
# - NEXT_PUBLIC_APP_URL: URL publik aplikasi Anda.
#     * Lokal: http://localhost:3000
#     * Staging: https://staging.domainanda.com
#     * Production: https://domainanda.com (Wajib HTTPS, tanpa trailing slash "/")
# - PORT: Port lokal yang digunakan Next.js / Express (default 3000).
NODE_ENV="development"
NEXT_PUBLIC_APP_URL="http://localhost:3000"
PORT=3000

# ==============================================================================
# 2. DATABASE CONFIGURATION (POSTGRESQL / PRISMA / DRIZZLE)
# ==============================================================================
# CARA MENDAPATKAN:
#
# Opsi A: Lokal (PostgreSQL native / Docker)
#   Format: postgresql://<user>:<password>@<host>:<port>/<dbname>?schema=public
#   Contoh Docker Compose:
#     docker run --name my-postgres -e POSTGRES_PASSWORD=secret -e POSTGRES_DB=myapp_dev -p 5432:5432 -d postgres:16-alpine
#   Maka DATABASE_URL="postgresql://postgres:secret@localhost:5432/myapp_dev?schema=public"
#
# Opsi B: Supabase (Cloud)
#   1. Buka https://supabase.com -> Pilih Project Anda.
#   2. Buka menu: Project Settings (ikon gerigi) -> Database -> Connection String.
#   3. Pilih tab "URI".
#   4. Gunakan "Transaction" pooler (port 6543) untuk serverless/Next.js:
#      DATABASE_URL="postgresql://postgres.[ref]:[password]@aws-0-[region].pooler.supabase.com:6543/postgres?pgbouncer=true"
#   5. Gunakan "Session" pooler / Direct (port 5432) untuk DIRECT_URL (migrasi Prisma):
#      DIRECT_URL="postgresql://postgres.[ref]:[password]@aws-0-[region].pooler.supabase.com:5432/postgres"
#
# Opsi C: Neon.tech (Serverless Postgres)
#   1. Buka https://console.neon.tech -> Pilih Project -> Dashboard.
#   2. Pada kartu "Connection Details", pilih "Prisma" atau "PostgreSQL" lalu copy string URL.
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/myapp_dev?schema=public"
# DIRECT_URL diperlukan khusus Prisma jika menggunakan connection pooler (PgBouncer/Supavisor):
DIRECT_URL="postgresql://postgres:postgres@localhost:5432/myapp_dev?schema=public"

# ==============================================================================
# 3. AUTHENTICATION & SESSION KEYS (NEXTAUTH / BETTER-AUTH / CUSTOM JWT)
# ==============================================================================
# CARA MENDAPATKAN:
# Kunci rahasia berikut WAJIB berupa string acak dengan entropi tinggi (minimal 32 karakter).
# DILARANG mengarang manual seperti "rahasia123" karena mudah di-bruteforce!
#
# Jalankan salah satu perintah ini di terminal untuk menghasilkan string acak:
#   Terminal Linux/Mac/Git Bash:
#     openssl rand -base64 32
#   Terminal Windows (PowerShell / Node.js):
#     node -e "console.log(require('crypto').randomBytes(32).toString('base64'))"
#
# NEXTAUTH_SECRET / AUTH_SECRET: Kunci enkripsi cookie JWT sesi.
# NEXTAUTH_URL: Sama dengan NEXT_PUBLIC_APP_URL (http://localhost:3000 saat lokal).
NEXTAUTH_SECRET="generate-via-openssl-rand-base64-32-min-32-chars"
AUTH_SECRET="generate-via-openssl-rand-base64-32-min-32-chars"
NEXTAUTH_URL="http://localhost:3000"
JWT_SECRET="generate-via-openssl-rand-base64-32-min-32-chars"
JWT_EXPIRES_IN="7d"

# ==============================================================================
# 4. DATA ENCRYPTION AT REST (AES-256-GCM)
# ==============================================================================
# CARA MENDAPATKAN:
# Kunci enkripsi 32-byte (256-bit) dalam format 64 karakter heksadesimal murni.
# Digunakan untuk enkripsi token rahasia, payload webhook, atau dokumen sensitif di database.
#
# Jalankan perintah ini di terminal:
#   Terminal Linux/Mac/Git Bash:
#     openssl rand -hex 32
#   Terminal Node.js:
#     node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
ENCRYPTION_KEY="0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"

# ==============================================================================
# 5. OAUTH SOCIAL PROVIDERS (GOOGLE / GITHUB)
# ==============================================================================
# CARA MENDAPATKAN GOOGLE OAUTH:
# 1. Buka https://console.cloud.google.com/apis/credentials
# 2. Buat Project baru atau pilih yang sudah ada.
# 3. Setup "OAuth consent screen" (User Type: External).
# 4. Klik "Create Credentials" -> "OAuth Client ID" -> Application type: "Web application".
# 5. Tambahkan Authorized JavaScript origins:
#      - http://localhost:3000
# 6. Tambahkan Authorized redirect URIs:
#      - http://localhost:3000/api/auth/callback/google
# 7. Salin Client ID dan Client Secret ke bawah ini:
GOOGLE_CLIENT_ID="your-client-id.apps.googleusercontent.com"
GOOGLE_CLIENT_SECRET="GOCSPX-your-client-secret"

# CARA MENDAPATKAN GITHUB OAUTH:
# 1. Buka https://github.com/settings/developers -> "OAuth Apps" -> "New OAuth App".
# 2. Homepage URL: http://localhost:3000
# 3. Authorization callback URL: http://localhost:3000/api/auth/callback/github
# 4. Salin Client ID dan Generate Client Secret:
GITHUB_CLIENT_ID="your-github-client-id"
GITHUB_CLIENT_SECRET="your-github-client-secret"

# ==============================================================================
# 6. OBJECT STORAGE (CLOUDFLARE R2 / AWS S3)
# ==============================================================================
# CARA MENDAPATKAN CLOUDFLARE R2 (Rekomendasi Solo Dev: Egress Gratis $0):
# 1. Buka https://dash.cloudflare.com -> Menu sidebar "R2 Object Storage".
# 2. Klik "Create bucket" (misal: myapp-assets-dev).
# 3. Klik menu kanan "Manage R2 API Tokens" -> "Create API Token".
# 4. Beri nama token, Permissions: "Admin Read & Write", TTL: Forever (atau sesuai kebutuhan).
# 5. Klik "Create API Token", Anda akan mendapatkan:
#      - Access Key ID -> masukkan ke STORAGE_ACCESS_KEY
#      - Secret Access Key -> masukkan ke STORAGE_SECRET_KEY
#      - Endpoint S3 API -> format: https://<account_id>.r2.cloudflarestorage.com
# 6. STORAGE_PUBLIC_URL: Pada Settings Bucket R2, aktifkan "Custom Domain" atau "R2.dev subdomain"
#    agar file foto/media dapat diakses publik via browser.
STORAGE_BUCKET_NAME="myapp-assets-dev"
STORAGE_ACCESS_KEY="your-r2-access-key-id"
STORAGE_SECRET_KEY="your-r2-secret-access-key"
STORAGE_ENDPOINT="https://<account_id>.r2.cloudflarestorage.com"
STORAGE_REGION="auto"
STORAGE_PUBLIC_URL="https://pub-xxxxxx.r2.dev"

# ==============================================================================
# 7. TRANSACTIONAL EMAIL (RESEND)
# ==============================================================================
# CARA MENDAPATKAN:
# 1. Daftar & login di https://resend.com
# 2. Buka menu "API Keys" -> Klik "Create API Key" (Full access).
# 3. Salin kunci (awalan `re_...`) ke RESEND_API_KEY.
# 4. Untuk mode pengembangan (Development):
#      - EMAIL_FROM wajib menggunakan "onboarding@resend.dev"
#      - Email penerima hanya bisa dikirim ke alamat email akun terdaftar Anda.
# 5. Untuk mode Production:
#      - Buka menu "Domains" -> Tambahkan domain Anda -> Masukkan DNS record (DKIM, SPF, MX)
#      - Setelah status "Verified", ganti EMAIL_FROM menjadi "Nama App <notifikasi@domainanda.com>"
RESEND_API_KEY="re_your_resend_api_key_here"
EMAIL_FROM="MyApp Notification <onboarding@resend.dev>"

# ==============================================================================
# 8. PAYMENT GATEWAY (MIDTRANS / STRIPE / XENDIT)
# ==============================================================================
# CARA MENDAPATKAN MIDTRANS (Indonesia Payment Gateway):
# 1. Daftar akun di https://dashboard.midtrans.com
# 2. Pastikan mode di kanan atas adalah "SANDBOX" untuk development.
# 3. Buka menu: Settings -> Access Keys.
# 4. Salin Client Key dan Server Key:
#      - MIDTRANS_CLIENT_KEY (publik, dipakai di browser Snap popup)
#      - MIDTRANS_SERVER_KEY (rahasia, dipakai di backend API)
# 5. Setting Webhook URL di menu: Settings -> Configuration -> Payment Notification URL:
#      - Lokal testing: gunakan Ngrok (misal: https://xxxx.ngrok-free.app/api/webhooks/midtrans)
#      - Production: https://domainanda.com/api/webhooks/midtrans
MIDTRANS_IS_PRODUCTION="false"
MIDTRANS_CLIENT_KEY="SB-Mid-client-your-client-key"
MIDTRANS_SERVER_KEY="SB-Mid-server-your-server-key"

# CARA MENDAPATKAN STRIPE (Global Credit Card / SaaS Subscription):
# 1. Buka https://dashboard.stripe.com/test/apikeys
# 2. Salin Publishable key (`pk_test_...`) dan Secret key (`sk_test_...`).
# 3. Untuk Webhook: Buka menu Developers -> Webhooks -> Add endpoint -> salin Signing Secret (`whsec_...`).
STRIPE_PUBLISHABLE_KEY="pk_test_your_publishable_key_here"
STRIPE_SECRET_KEY="sk_test_your_secret_key_here"
STRIPE_WEBHOOK_SECRET="whsec_your_webhook_secret_here"

# ==============================================================================
# 9. WHATSAPP GATEWAY / NOTIFIKASI LAPANGAN (FONNTE / TWILIO)
# ==============================================================================
# CARA MENDAPATKAN FONNTE (Populer di Indonesia untuk Notif Kos/Tagihan/Operasional):
# 1. Daftar akun di https://fonnte.com
# 2. Buka menu "Device" -> Tambahkan device -> Scan QR WhatsApp via aplikasi ponsel.
# 3. Salin token API device Anda:
FONNTE_API_TOKEN="your-fonnte-device-token"

# ==============================================================================
# 10. CACHING & RATE LIMITING (UPSTASH REDIS / LOCAL REDIS)
# ==============================================================================
# CARA MENDAPATKAN UPSTASH REDIS (Serverless Redis Gratis untuk Next.js / Edge):
# 1. Buka https://console.upstash.com -> Create Database.
# 2. Pilih region terdekat (misal: Singapore / ap-southeast-1).
# 3. Pada halaman database, scroll ke bawah ke tab "REST API".
# 4. Salin UPSTASH_REDIS_REST_URL dan UPSTASH_REDIS_REST_TOKEN:
UPSTASH_REDIS_REST_URL="https://your-upstash-redis-url.upstash.io"
UPSTASH_REDIS_REST_TOKEN="your-upstash-redis-rest-token"
