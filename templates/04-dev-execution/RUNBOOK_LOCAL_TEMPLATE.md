# Local Development Runbook

> Practical guide for cloning, configuring, and running the application locally on a developer machine or verification runner.

---

## 1. System Prerequisites
Ensure your local environment has the following installed:
- **Node.js**: Version `v20.x` LTS or newer (`node -v`)
- **Package Manager**: `pnpm` or `npm` (`pnpm -v` or `npm -v`)
- **Database**: PostgreSQL v15+ (Local or via Docker)
- **Git**: Version 2.30+ (`git -v`)

---

## 2. Environment Variables (.env Setup)

Copy the configuration template file to `.env`:
```bash
cp .env.example .env
```

### Required Environment Variable Dictionary:
| Variable Name | Example Value | Description |
| :--- | :--- | :--- |
| `DATABASE_URL` | `postgresql://postgres:password@localhost:5432/legal_vault?schema=public` | PostgreSQL database connection |
| `JWT_SECRET` | `generate-random-secret-key-min-32-chars` | Session authentication token signing key |
| `VAULT_MASTER_KEY` | `32-byte-hex-string-for-aes-256-gcm-encryption` | PDF file encryption key in Document Vault |
| `STORAGE_BUCKET_NAME`| `legal-document-vault-dev` | S3 / Cloudflare R2 bucket name |
| `STORAGE_ACCESS_KEY` | `your-r2-or-s3-access-key` | Cloud storage access credentials |
| `STORAGE_SECRET_KEY` | `your-r2-or-s3-secret-key` | Cloud storage secret credentials |
| `STORAGE_ENDPOINT`   | `https://<account-id>.r2.cloudflarestorage.com` | S3-compatible API endpoint |

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
| **Super Admin** | `admin@company.local` | `Admin12345!` | Access to all modules & audit trail |
| **Manager** | `manager@company.local` | `Manager12345!` | Draft approval & send e-sign requests |
| **Staff** | `staff@company.local` | `Staff12345!` | Document template form filling |

---

## 6. Self-Assertion Testing (Local Smoke Test)

Run the quick smoke test script to validate the flow from registration, encrypted PDF generation, through digital signing:

```bash
npm run test:smoke
```

*If all assertions display `PASS` status, the application is ready to be deployed to the Staging environment.*
