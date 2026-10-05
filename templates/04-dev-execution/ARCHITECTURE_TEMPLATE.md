# ARCHITECTURE.md

> Technical architecture blueprint, directory layout, database schema, and API contracts to guide code implementation by AI coding agents.

---

## 1. System Topology & Data Flow

```text
[ Browser Client (HTML/Tailwind from Interactive Prototype) ]
                      │
                      ▼ (HTTPS / JSON API)
        [ Next.js App Router / API Handlers ]
                      │
         ┌────────────┼────────────┐
         ▼            ▼            ▼
   [ PostgreSQL ]  [ Redis ]   [ Cloudflare R2 / S3 ]
  Transaction Data Rate Limiting Encrypted PDF Files
```

---

## 2. Standard Directory Layout

```text
docs/
├── specs/                    # Technical specifications (from M04-M05)
│   ├── PRD.md                # Product requirements
│   ├── FSD.md                # Functional specification
│   ├── SITEMAP.md            # Screen inventory with IDs
│   └── DESIGN_SYSTEM.md      # Design tokens & component specs
├── design/                   # Design artifacts (optional)
│   ├── prototype-output/        # Generated screens from Interactive Prototype (if used)
│   │   ├── SCR-01/           # Landing page components
│   │   ├── SCR-06/           # Login screen components
│   │   └── ...               # One folder per Screen ID
│   └── references/           # Design inspiration (optional)
│       ├── competitors/      # Competitor screenshots
│       └── brand/            # Brand assets, guidelines
└── pm/                       # Project management docs

src/
├── app/                      # Next.js App Router page routes & API Route Handlers
│   ├── (auth)/login/         # Login page
│   ├── (dashboard)/          # Authenticated dashboard pages
│   │   ├── documents/        # Document management
│   │   └── settings/         # Account settings
│   ├── api/v1/               # REST API endpoints
│   │   ├── auth/             # Login/logout handlers
│   │   ├── documents/        # Document CRUD & render handlers
│   │   └── sign/             # Signature verification handler
│   └── sign/[token]/         # Guest signature public page
├── components/               # UI components adapted from Interactive Prototype
│   ├── ui/                   # Primitive components (Button, Dialog, Input, Table)
│   └── docs/modules/         # Business domain components (DocumentForm, PDFPreview, SignCanvas)
├── lib/                      # Shared utilities
│   ├── db.ts                 # Prisma/PostgreSQL connection instance
│   ├── crypto.ts             # AES-256-GCM streaming encryption & hashing
│   ├── storage.ts            # Cloudflare R2 / S3 client & presigned URLs
│   └── env.ts                # Environment variable validation with Zod
└── schemas/                  # Zod schemas for API request & response validation
```

---

## 3. Core Database Models

Referencing SQL DDL schema in `FSD.md`:
- **`users` Table**: Stores user accounts, unique email, Argon2id password hash, and roles (`super_admin`, `manager`, `staff`).
- **`documents` Table**: Stores document drafts, JSONB form data, status (`draft`, `pending_sign`, `signed`, `archived`), encrypted file S3 path, and document SHA-256 hash.
- **`document_signatures` Table**: Stores signature audit records, signer name, IP address, user-agent, and UTC timestamp.

---

## 4. Mandatory API Contract Matrix

| Endpoint Route | Method | Custom Header | Required Payload | Success Response |
| :--- | :---: | :--- | :--- | :---: |
| `/api/v1/auth/login` | `POST` | - | `email`, `password` | `200 OK` + HttpOnly Cookie |
| `/api/v1/documents` | `POST` | `Authorization`, `X-Idempotency-Key` | `title`, `template_type`, `form_data` | `201 Created` (`document_id`) |
| `/api/v1/documents/:id` | `GET` | `Authorization` | - | `200 OK` + `preview_url` (15m) |
| `/api/v1/sign/:token` | `POST` | - | `signature_svg`, `token` | `200 OK` (`SIGNED` Status) |

---

## 5. Mandatory Security & Cryptographic Rules
1. **File Encryption**: PDF documents must be encrypted before uploading to S3/R2 using `crypto.createCipheriv('aes-256-gcm', key, iv)`.
2. **Presigned URL**: File download links must expire within a maximum of 15 minutes (900 seconds).
3. **Pessimistic Locking**: Document signing flows must use atomic transactions with `SELECT ... FOR UPDATE` to prevent race conditions.
