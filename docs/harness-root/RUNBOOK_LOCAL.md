# Local Development Runbook

> Practical guide for cloning, configuring, and running the application locally on a developer machine or verification runner.

---

## 1. System Prerequisites
Ensure your local environment has the following installed:
- **Node.js**: Version `v22.x` LTS or newer (`node -v`)
- **Package Manager**: `pnpm` or `npm` (`pnpm -v` or `npm -v`)
- **Database**: PostgreSQL v16+ (Local or via Docker)
- **Git**: Version 2.30+ (`git -v`)

---

## 2. Environment Variables (.env Setup)

Copy the configuration template file to `.env`:
```bash
cp .env.example .env
```

> 💡 **Detailed Acquisition Guide**: Every variable in `.env.example` includes a dedicated step-by-step header explaining **how and where to acquire or generate** the value (console URLs, terminal one-liners for encryption keys, and callback endpoints).

### Required Environment Variable Dictionary & Acquisition Reference:
| Variable Name | Example / Generation Command | Source & How to Acquire |
| :--- | :--- | :--- |
| `DATABASE_URL` | `postgresql://postgres:postgres@localhost:5432/myapp_dev?schema=public` | Local PostgreSQL Docker, or Supabase/Neon connection string (Port 6543 pooler for serverless) |
| `NEXTAUTH_SECRET` / `AUTH_SECRET` | `node -e "console.log(require('crypto').randomBytes(32).toString('base64'))"` | Generate locally via Node.js or `openssl rand -base64 32` |
| `ENCRYPTION_KEY` | `node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"` | 64-hex string for AES-256-GCM data encryption at rest |
| `STORAGE_ENDPOINT` | `https://<account_id>.r2.cloudflarestorage.com` | Cloudflare Dashboard $\rightarrow$ R2 $\rightarrow$ Bucket Settings |
| `STORAGE_ACCESS_KEY` & `SECRET` | Cloudflare R2 API Token / AWS IAM User | Cloudflare Dashboard $\rightarrow$ R2 $\rightarrow$ Manage API Tokens (Admin Read & Write) |
| `RESEND_API_KEY` | `re_your_api_key_here` | Resend Dashboard $\rightarrow$ API Keys; use `onboarding@resend.dev` in local dev |
| `MIDTRANS_SERVER_KEY` / `STRIPE_SECRET_KEY` | Sandbox API Key | Midtrans Dashboard $\rightarrow$ Settings $\rightarrow$ Access Keys (Sandbox mode) |

---

## 3. Installation & Database Migration Steps

```bash
# 1. Clone repository
git clone <REPO_URL>
cd <PROJECT_FOLDER>

# 2. Install all dependencies
npm install # or pnpm install

# 3. Run database migrations (SQL DDL)
npm run db:migrate # or npx prisma migrate dev / npx drizzle-kit push

# 4. Seed initial testing data (Data Seeding)
npm run db:seed
```

---

## 4. Running the Application

```bash
# Run local development server
npm run dev
```

The web application can be accessed via browser at:
`http://localhost:3000`

---

## 5. Default Test Account Credentials (Seeded Accounts)

| Role | Email Address | Default Password | Special Access |
| :--- | :--- | :--- | :--- |
| **Admin / Owner** | `admin@project.local` | `[SET_IN_LOCAL_ENV_SEED]` | Access to system administration & audit logs |
| **Manager / Supervisor** | `manager@project.local`| `[SET_IN_LOCAL_ENV_SEED]` | Operational reviews & approval workflows |
| **Staff / Operator** | `staff@project.local` | `[SET_IN_LOCAL_ENV_SEED]` | Data entry & task execution |

> ⚠️ **SECURITY WARNING**: Fixed default passwords in repositories lead to accidental credential reuse. Local seed scripts MUST read credentials from local environment variables or generate ephemeral dev-only tokens that cannot be used in deployed environments.

---

## 6. Self-Assertion Testing (Local Smoke Test)

Execute the automated test suites to validate functional flows, RLS multi-tenant security, and database concurrency:

```bash
# 1. End-to-end smoke test of core user loop (configured test script)
npm run test:smoke # (or: pnpm test:smoke / pytest / go test ./... / php artisan test)

# 2. Automated security & data isolation test (conditional on multi-tenant architecture)
npm run test:security # (runs configured security suite, e.g. tests/db/rls.test.ts)

# 3. Database concurrency & anti-deadlock test (conditional on concurrent transaction scope)
npm run test:concurrency # (runs configured load/concurrency suite, e.g. tests/db/concurrency.test.ts)
```

*If all assertions display `PASS` status and zero deadlock errors occur, the application is verified and ready for Staging deployment.*
