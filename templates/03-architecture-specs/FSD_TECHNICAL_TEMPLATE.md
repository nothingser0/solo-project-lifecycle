# Functional Specification Document (FSD)

> Technical architecture specification document defining "HOW" the system is built: database schemas, API contracts, security models, and state machine logic.

---

## 1. Document Metadata
- **System Name**: [Application Name]
- **Client**: [Client Company / Organization]
- **Lead Software Architect**: [Your Name]
- **PRD Reference**: PRD-[ID] v1.0 (Approved)
- **Design Reference**: DESIGN_SPEC-[ID] v1.0 (Frozen)
- **Document Version**: 1.0.0
- **Document Status**: [Approved for Build]
- **Approval Date**: [YYYY-MM-DD]

---

## 2. Component Architecture & Tech Stack Decisions

```text
[ Browser / Mobile Client ]
            │
            ▼ (HTTPS / TLS 1.3 - JSON API)
    [ API Gateway / Reverse Proxy (Caddy / Nginx / Cloudflare) ]
            │
            ▼
    [ Application Backend (Node.js / Next.js / Go) ]
            │
            ├──► [ Database: PostgreSQL (Managed / Supabase) ]
            ├──► [ Cache & Rate Limit: Redis (Upstash) ]
            ├──► [ Document Vault: Cloudflare R2 / AWS S3 (AES-256) ]
            └──► [ Third-Party APIs: SMTP (Resend) / Payment (Midtrans) ]
```

### Technology Decisions (Tech Stack Matrix)
- **Frontend / Client UI**: Next.js (App Router, React 19, TypeScript, Tailwind CSS, Shadcn UI).
- **Backend Runtime**: Node.js v20+ LTS / Next.js Server Actions / Route Handlers.
- **Primary Database**: PostgreSQL 16 (with `pgcrypto` and `uuid-ossp` extensions).
- **ORM / Query Builder**: Prisma ORM / Drizzle ORM (with versioned schema migrations).
- **In-Memory Cache & Lock**: Redis v7 (Rate limiting and background job queues).
- **File Storage (Blob Storage)**: Cloudflare R2 (S3-compatible, zero egress fee).

---

## 3. Relational Database Schema (Standard SQL DDL)

```sql
-- Cryptographic and UUID Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Users Table (users)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    role VARCHAR(30) NOT NULL DEFAULT 'staff' CHECK (role IN ('super_admin', 'manager', 'staff')),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);

-- 2. Documents Table (documents)
CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    creator_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    title VARCHAR(255) NOT NULL,
    template_type VARCHAR(50) NOT NULL CHECK (template_type IN ('pkwt', 'nda', 'freelance_contract', 'invoice')),
    form_data JSONB NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'pending_sign', 'signed', 'archived')),
    file_vault_key VARCHAR(500), -- S3 path for encrypted PDF file
    document_hash_sha256 VARCHAR(64), -- Integrity hash of document content
    idempotency_key VARCHAR(100) UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_documents_creator_status ON documents(creator_id, status);
CREATE INDEX idx_documents_created_at ON documents(created_at);

-- 3. Signatures & Audit Trail Table (document_signatures)
CREATE TABLE document_signatures (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    document_id UUID NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
    signer_name VARCHAR(150) NOT NULL,
    signer_email VARCHAR(255) NOT NULL,
    token_hash VARCHAR(64) UNIQUE NOT NULL,
    signature_svg_path VARCHAR(500),
    signer_ip_address VARCHAR(45) NOT NULL,
    signer_user_agent TEXT NOT NULL,
    signed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_signatures_document ON document_signatures(document_id);
```

---

## 4. API Contracts & Endpoint Matrix

### 4.1 Endpoint: `POST /api/v1/documents`
- **Function**: Issue a new document draft from form input.
- **Authentication**: Required (`Bearer <JWT_TOKEN>`).
- **Headers**:
  ```http
  Authorization: Bearer eyJhbGciOi...
  Content-Type: application/json
  X-Idempotency-Key: 9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d
  ```

#### Request Payload JSON
```json
{
  "title": "Freelance Contract - Budi Santoso",
  "template_type": "freelance_contract",
  "form_data": {
    "employer_name": "PT Sinar Maju",
    "contractor_name": "Budi Santoso",
    "compensation_amount": 15000000,
    "scope_of_work": "Website frontend development",
    "start_date": "2026-10-01",
    "end_date": "2026-12-31"
  }
}
```

#### Success Response (`201 Created`)
```json
{
  "status": "success",
  "data": {
    "document_id": "8c4e6123-5e92-4f31-893c-623ab1e4811a",
    "title": "Freelance Contract - Budi Santoso",
    "status": "draft",
    "preview_url": "https://vault.domain.com/preview/8c4e6123?token=exp15m...",
    "created_at": "2026-09-24T10:00:00Z"
  }
}
```

#### Error Response Matrix
| HTTP Code | Error Code | Root Cause / Trigger Condition | JSON Response |
| :---: | :--- | :--- | :--- |
| `400` | `VALIDATION_ERROR` | Invalid JSON form_data format or missing required fields | `{"status": "error", "code": "VALIDATION_ERROR", "details": [...]}` |
| `401` | `UNAUTHORIZED` | Missing or expired JWT token | `{"status": "error", "code": "UNAUTHORIZED", "message": "Your session has expired"}` |
| `409` | `IDEMPOTENCY_CONFLICT`| Request with identical idempotency key is already processing | `{"status": "error", "code": "IDEMPOTENCY_CONFLICT", "message": "Duplicate request"}` |
| `500` | `PDF_RENDER_FAILED` | PDF generator library failed to render document | `{"status": "error", "code": "SERVER_ERROR", "message": "Failed to render PDF file"}` |

---

## 5. Security & Cryptographic Architecture (Security Blueprint)

1. **Document File Encryption (Vault Encryption-at-Rest)**:
   - Document PDF files are encrypted using the **AES-256-GCM** algorithm before being streamed to S3/R2 storage.
   - The encapsulated encryption key (*Data Encryption Key / DEK*) is stored encrypted using a master key (*Master Key*) maintained in an isolated server environment variable.
2. **Download Link Security (Presigned URLs)**:
   - Files in storage are never opened for public access (`public-read`).
   - Download access is issued exclusively through cryptographically signed *Presigned URLs* with a maximum validity of **15 minutes**.
3. **Password Credential Storage**:
   - Passwords must be hashed using **Argon2id** with parameters: `memoryCost: 65536` (64 MB), `timeCost: 3`, `parallelism: 4`.
4. **Cryptographic Signature Verification (Integrity Hash)**:
   - Each completed signed document has its hash calculated using **SHA-256**.
   - The hash value is stored in the `documents.document_hash_sha256` table and included in the PDF footer as proof of document authenticity (*tamper-evident seal*).

---

## 6. Document State Machine

```text
               ┌────────────────────────────────────────────────────────┐
               ▼                                                        │
         [ 1. DRAFT ] ──(Send Signature Link)────────► [ 2. PENDING_SIGN ]
               │                                                │
               │ (Deleted by Creator)                           │ (Expired after 7 Days)
               ▼                                                ▼
         [ ARCHIVED ]                                     [ EXPIRED ]
                                                                │
                                       (All Parties Signed)     │
                                                                ▼
                                                        [ 3. SIGNED (LOCKED) ]
```

### State Invariants:
1. Documents in `SIGNED` status are **STRICTLY FORBIDDEN** from having form data or PDF files modified.
2. Signing is executed within a single database atomic transaction (`BEGIN ... COMMIT`) using row-level locking (`SELECT ... FOR UPDATE`) to prevent race conditions when two signers submit signatures at the exact same second.

---

## 7. Technical Specification Sign-Off

This document represents the final architecture specification. All code implementations in **Module 06: Development** must adhere to the schema definitions, API routes, and security architecture above.

| Approved by Client Single PIC | Validated by Lead Software Architect |
| :--- | :--- |
| **Name**: _________________________ | **Name**: _________________________ |
| **Title / Role**: ______________________ | **Title / Role**: Independent Lead Engineer |
| **Date**: ______________________ | **Date**: ______________________ |
| **Signature**: | **Signature**: |
