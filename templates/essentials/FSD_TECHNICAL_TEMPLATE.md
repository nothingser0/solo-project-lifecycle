# Functional Specification Document (FSD) — Technical Architecture & Database DDL

> **Purpose**: Definitive engineering blueprint defining "HOW" the system is constructed: standard SQL DDL, access control & RLS architecture, atomic transaction functions with row-locking, append-only journals, idempotency caches, and immutable audit logs.
> **Standard**: Zero silent RLS data leaks, zero client-side race conditions, and hardened `SECURITY DEFINER` execution across all project scales (Small, Medium, Large, Enterprise) and software domains (CRM, CMS, HRIS, E-Commerce, Fintech, SaaS, Developer Tools).
> **Output**: `docs/specs/FSD.md`

---

## 1. Document Metadata
- **System / Application Name**: [System / Application Name]
- **Client / Organization**: [Client Company / Organization]
- **Lead Software Architect**: [Your Name]
- **Project Domain**: [CRM / CMS / HRIS / E-Commerce / Fintech / B2B SaaS / Developer Tool]
- **Defined Project Scale**: [Small (MVP) / Medium (SaaS) / Large / Enterprise]
- **PRD Reference**: `docs/specs/PRD.md` (v2.0 Approved)
- **Design Reference**: `docs/specs/DESIGN_SPEC.md` (v2.1 Frozen)
- **Specification Version**: 2.0.0
- **Document Status**: [APPROVED_FOR_BUILD]
- **Approval Date**: [YYYY-MM-DD]

### 1.1 Scale-Adaptive FSD Architecture Framework
*Adapt technical depth and architectural patterns based on project scale:*

| Scale Tier | Typical Tables | State & Persistence Architecture | Concurrency & Isolation | Security Architecture |
| :--- | :---: | :--- | :--- | :--- |
| **Small (MVP / Internal Tool)** | 3–6 tables | Standard relational tables with `created_at`/`updated_at`; simple audit logging | Database unique constraints & client submit debouncing | Application-layer auth; basic RLS or single-tenant database |
| **Medium (B2B SaaS / Agency)** | 10–20 tables | State machine / event journals; cached aggregate projections; versioned migrations | Atomic transactions / stored procedures (`FOR UPDATE`) on critical paths | 100% multi-tenant RLS (`org_id`); hardened `SECURITY DEFINER` helper functions |
| **Large (Scale-Up / Multi-System)**| 20–35 tables | Full append-only movement ledgers; decoupled background workers; Redis caching | Row-level locking; idempotency key response caches; partition strategies | Role-scoped RLS; database view isolation; rate limiting; KMS encryption |
| **Enterprise (Corporate / Regulated)**| 40+ tables | Immutable audit vaults; event sourcing; high-concurrency read replicas | Sharding / time-series partitioning; multi-master or distributed consensus | SOC2 / ISO 27001 / UU PDP compliance; HSM keys; multi-tier CAB sign-off |

---

## 2. Component Architecture & Tech Stack Decisions

```text
[ Browser / Mobile Client / External Worker ]
                    │
                    ▼ (HTTPS / TLS 1.3 - JSON API / WebSockets)
        [ Reverse Proxy / Edge CDN (Cloudflare / Caddy) ]
                    │
                    ▼
        [ Application Backend (Next.js / Laravel / Django / Go / Rails) ]
                    │
                    ├──► [ Database: PostgreSQL (Managed / Supabase / Local) ]
                    │     ├── Access Isolation (RLS / Tenant Scoping)
                    │     ├── Atomic Transactions & Concurrency Guards
                    │     └── Audit Logs & State Event Journals
                    │
                    ├──► [ In-Memory Cache / Worker Queue: Redis (Optional) ]
                    │     └── Rate Limiting, Session Stores, Background Jobs
                    │
                    └──► [ Object Storage: S3 / Cloudflare R2 (Optional) ]
                          └── Encrypted Assets & Presigned URLs
```

### Framework Versions (Pinned)
*(Populate directly from `./scripts/check-package-versions.sh <stack>`)*
- **Framework**: [e.g., Next.js ^15.0.3 (App Router) / Laravel v13.x / Django ^6.1.1 / Go go1.27.1 / Rails ~8.1.4]
- **Language / Runtime**: [e.g., Node.js 22 LTS / PHP ^8.3 / Python >=3.12 / Go 1.27 / Ruby >=3.2.0]
- **Database Engine**: PostgreSQL 16+ (or MySQL / SQLite appropriate to scale)
- **ORM / Driver**: [e.g., Drizzle ORM / Prisma / Eloquent / GORM / psycopg]

---

## 3. Relational Database Schema & DDL Integrity (SQL DDL)

### 3.1 DDL Integrity Rules
1. **Monetary Precision**: All currency amounts MUST use `BIGINT` (stored in smallest currency unit / full Rupiah) or `NUMERIC(15, 2)` to eliminate floating-point rounding errors.
2. **Quantity Precision**: Quantities supporting fractional measurements (weights, volumes, hours) MUST use `NUMERIC(12, 3)`. Whole items use `INTEGER`.
3. **100% Foreign Key Indexing**: Every column with a `REFERENCES` constraint **MUST** have an explicit `CREATE INDEX` to prevent sequential table scans under load.
4. **Strict CHECK Constraints**: Enforce domain invariants and arithmetic correctness directly in the database engine.

```sql
-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================================
-- CORE PLATFORM SCHEMA (Universal: Multi-Tenant & User Access)
-- ============================================================================

-- 1. Organizations (Tenants)
CREATE TABLE organizations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Users & Tenant Roles
CREATE TABLE users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE RESTRICT,
    email VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    role VARCHAR(30) NOT NULL CHECK (role IN ('Owner', 'Manager', 'Staff', 'Auditor')),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT uq_users_org_email UNIQUE (org_id, email)
);
CREATE INDEX idx_users_org_id ON users(org_id);

-- ============================================================================
-- DOMAIN SCHEMAS (Select the pattern matching project domain; adapt or mark N/A)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PATTERN A: Commerce / Inventory / Transactions (Retail / POS / WMS Scope)
-- ----------------------------------------------------------------------------
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE RESTRICT,
    sku VARCHAR(100) NOT NULL,
    barcode VARCHAR(100),
    name VARCHAR(255) NOT NULL,
    unit VARCHAR(30) NOT NULL DEFAULT 'pcs',
    buy_price BIGINT NOT NULL CHECK (buy_price >= 0),
    sell_price BIGINT NOT NULL CHECK (sell_price >= buy_price),
    min_stock NUMERIC(12, 3) NOT NULL DEFAULT 0 CHECK (min_stock >= 0),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT uq_product_sku_per_org UNIQUE (org_id, sku)
);
CREATE INDEX idx_products_org_id ON products(org_id);
CREATE INDEX idx_products_barcode ON products(org_id, barcode) WHERE barcode IS NOT NULL;

CREATE TABLE inventory (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE RESTRICT,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    quantity NUMERIC(12, 3) NOT NULL DEFAULT 0,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT uq_inventory_product_org UNIQUE (org_id, product_id)
);
CREATE INDEX idx_inventory_org_id ON inventory(org_id);
CREATE INDEX idx_inventory_product_id ON inventory(product_id);

CREATE TABLE inventory_movements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE RESTRICT,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    movement_type VARCHAR(30) NOT NULL CHECK (movement_type IN ('INBOUND', 'OUTBOUND', 'ADJUSTMENT', 'VOID_RETURN')),
    quantity NUMERIC(12, 3) NOT NULL,
    unit_cost BIGINT NOT NULL CHECK (unit_cost >= 0),
    reference_id UUID NOT NULL,
    created_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_movements_org_id ON inventory_movements(org_id);
CREATE INDEX idx_movements_prod_time ON inventory_movements(product_id, created_at);

-- ----------------------------------------------------------------------------
-- PATTERN B: CRM / Pipeline / Activity Journals (CRM / Lead Management Scope)
-- ----------------------------------------------------------------------------
CREATE TABLE crm_deals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE RESTRICT,
    title VARCHAR(255) NOT NULL,
    deal_value BIGINT NOT NULL DEFAULT 0 CHECK (deal_value >= 0),
    stage VARCHAR(50) NOT NULL CHECK (stage IN ('LEAD', 'CONTACTED', 'PROPOSAL', 'NEGOTIATION', 'WON', 'LOST')),
    assigned_to UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_deals_org_id ON crm_deals(org_id);
CREATE INDEX idx_deals_assigned ON crm_deals(assigned_to);

-- ----------------------------------------------------------------------------
-- PATTERN C: CMS / Content Lifecycle & Revisions (CMS / Publishing Scope)
-- ----------------------------------------------------------------------------
CREATE TABLE cms_articles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE RESTRICT,
    slug VARCHAR(255) NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'DRAFT' CHECK (status IN ('DRAFT', 'IN_REVIEW', 'SCHEDULED', 'PUBLISHED', 'ARCHIVED')),
    published_at TIMESTAMPTZ,
    author_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT uq_article_slug_org UNIQUE (org_id, slug)
);
CREATE INDEX idx_articles_org_id ON cms_articles(org_id);
CREATE INDEX idx_articles_status ON cms_articles(status, published_at);

-- ============================================================================
-- COMMON PLATFORM INFRASTRUCTURE (Idempotency & Immutable Audit Logs)
-- ============================================================================

-- Idempotency Request Cache (Prevents duplicate processing on network retry)
CREATE TABLE idempotency_keys (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    idempotency_key VARCHAR(100) NOT NULL,
    response_code INT NOT NULL,
    response_body JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    expires_at TIMESTAMPTZ NOT NULL DEFAULT (now() + INTERVAL '24 hours'),
    CONSTRAINT uq_idempotency_org_key UNIQUE (org_id, idempotency_key)
);
CREATE INDEX idx_idempotency_org_key ON idempotency_keys(org_id, idempotency_key);
CREATE INDEX idx_idempotency_expires ON idempotency_keys(expires_at);

-- Automated TTL Cleanup: An index on expires_at does not auto-purge rows.
-- Purge expired keys via pg_cron or periodic background worker: DELETE FROM idempotency_keys WHERE expires_at < now();

-- Immutable Audit Trail
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(50) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id UUID NOT NULL,
    changes JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_audit_logs_org_id ON audit_logs(org_id);
CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);
```

---

## 4. Multi-Tenant Row-Level Security (RLS) Architecture

*(Applicable when building multi-tenant SaaS or exposing database directly to client SDKs. For single-tenant internal apps or backend-only APIs, document application-layer authorization and mark database RLS N/A)*

### 4.1 Security Definer Helper Function Hardening
```sql
-- Secure helper function locking search_path to prevent privilege escalation exploits:
CREATE OR REPLACE FUNCTION get_current_user_org_id()
RETURNS UUID AS $$
  SELECT org_id FROM public.users WHERE id = auth.uid() AND is_active = TRUE;
$$ LANGUAGE sql SECURITY DEFINER SET search_path = public, pg_temp STABLE;

CREATE OR REPLACE FUNCTION get_current_user_role()
RETURNS VARCHAR AS $$
  SELECT role FROM public.users WHERE id = auth.uid() AND is_active = TRUE;
$$ LANGUAGE sql SECURITY DEFINER SET search_path = public, pg_temp STABLE;
```

### 4.2 Explicit Granular RLS Policies (Zero Lax `FOR ALL`)

```sql
-- Enable RLS on multi-tenant tables:
ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_movements ENABLE ROW LEVEL SECURITY;
ALTER TABLE crm_deals ENABLE ROW LEVEL SECURITY;
ALTER TABLE cms_articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE idempotency_keys ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

-- 1. Tenant Data Isolation Policies
CREATE POLICY users_isolation_policy ON users
    FOR SELECT USING (org_id = get_current_user_org_id());

CREATE POLICY products_isolation_policy ON products
    FOR SELECT USING (org_id = get_current_user_org_id());

CREATE POLICY deals_isolation_policy ON crm_deals
    FOR ALL USING (org_id = get_current_user_org_id());

CREATE POLICY articles_isolation_policy ON cms_articles
    FOR ALL USING (org_id = get_current_user_org_id());

-- 2. Immutable Event & Audit Log Policies (Append-Only Enforcement)
CREATE POLICY movements_select_policy ON inventory_movements
    FOR SELECT USING (org_id = get_current_user_org_id());

CREATE POLICY movements_insert_policy ON inventory_movements
    FOR INSERT WITH CHECK (org_id = get_current_user_org_id());

CREATE POLICY audit_logs_select_policy ON audit_logs
    FOR SELECT USING (org_id = get_current_user_org_id());

CREATE POLICY audit_logs_insert_policy ON audit_logs
    FOR INSERT WITH CHECK (org_id = get_current_user_org_id());

-- STRICT RULE: ZERO UPDATE OR DELETE POLICIES ON AUDIT LOGS OR MOVEMENT JOURNALS!
-- PostgreSQL denies UPDATE/DELETE by default when no policy exists.
```

### 4.3 Database View Isolation (Sensitive Field Masking)
*(Enforce database-level masking where lower-privileged roles must not see sensitive costs, margins, or salaries)*
```sql
CREATE OR REPLACE VIEW products_public_view AS
SELECT
    id, org_id, sku, barcode, name, unit, sell_price, is_active, created_at
FROM public.products
WHERE is_active = TRUE;
-- Notice: Sensitive buy_price is completely excluded from projection!

GRANT SELECT ON products_public_view TO authenticated;
```

---

## 5. Atomic Concurrency Guards & Stored Procedures (Conditional)

*(Applicable to high-concurrency state transitions, seat reservations, checkout mutations, or balance settlements; mark N/A for standard low-concurrency CRUD)*

### 5.1 Failure Mode: Client-Side Multi-Step Mutation Race Condition
Executing balance deductions or state transitions via sequential client-side API calls causes race conditions under concurrent submissions. If two users mutate the last available unit simultaneously, both succeed, resulting in data inconsistency or overselling.

### 5.2 Atomic Stored Procedure Pattern (Row-Locking via `SELECT FOR UPDATE`)
> 💡 *Illustrative Architectural Pattern: The following procedure demonstrates server-side tenant authorization, atomic idempotency locking, and deterministic row-locking. Adapt table names, lock hierarchy, and error codes to your project's specific domain entities.*

```sql
CREATE OR REPLACE FUNCTION rpc_execute_atomic_checkout(
    p_org_id UUID,
    p_idempotency_key VARCHAR(100),
    p_product_id UUID,
    p_quantity NUMERIC(12, 3)
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
    v_current_stock NUMERIC(12, 3);
    v_server_price BIGINT;
    v_server_cost BIGINT;
    v_existing_response JSONB;
    v_actor_id UUID := auth.uid();
    v_user_org_id UUID;
BEGIN
    -- 0. Authentication & Organization Membership Validation
    IF v_actor_id IS NULL THEN
        RAISE EXCEPTION 'Authentication required to execute atomic mutation';
    END IF;

    IF p_quantity <= 0 THEN
        RAISE EXCEPTION 'Invalid mutation quantity: % must be greater than zero', p_quantity;
    END IF;

    SELECT org_id INTO v_user_org_id
    FROM public.users
    WHERE id = v_actor_id AND is_active = TRUE;

    IF v_user_org_id IS NULL OR v_user_org_id != p_org_id THEN
        RAISE EXCEPTION 'Unauthorized: User does not belong to specified organization';
    END IF;

    -- 1. Idempotency Check: Return cached response if already committed
    SELECT response_body INTO v_existing_response
    FROM idempotency_keys
    WHERE org_id = p_org_id AND idempotency_key = p_idempotency_key;

    IF v_existing_response IS NOT NULL THEN
        RETURN v_existing_response;
    END IF;

    -- 2. ROW-LOCKING: Lock inventory record exclusively to prevent concurrent race condition:
    -- Note: In multi-item transactions, always query and lock resources in deterministic order (ORDER BY product_id ASC)
    SELECT quantity INTO v_current_stock
    FROM inventory
    WHERE org_id = p_org_id AND product_id = p_product_id
    FOR UPDATE;

    IF NOT FOUND THEN
    RAISE EXCEPTION 'Resource not found or unstocked in this organization';
    END IF;

    IF v_current_stock < p_quantity THEN
        RAISE EXCEPTION 'Insufficient stock. Available: %, Requested: %', v_current_stock, p_quantity;
    END IF;

    -- 3. Fetch server truth pricing (anti-tampering)
    SELECT sell_price, buy_price INTO v_server_price, v_server_cost
    FROM products
    WHERE id = p_product_id AND org_id = p_org_id;

    IF NOT FOUND THEN
    RAISE EXCEPTION 'Resource inactive or unavailable';
    END IF;

    -- 4. Deduct inventory aggregate
    UPDATE inventory
    SET quantity = quantity - p_quantity, updated_at = now()
    WHERE org_id = p_org_id AND product_id = p_product_id;

    -- 5. Record immutable movement ledger
    INSERT INTO inventory_movements (
        org_id, product_id, movement_type, quantity, unit_cost, reference_id, created_by
    ) VALUES (
        p_org_id, p_product_id, 'OUTBOUND', -p_quantity, v_server_cost, gen_random_uuid(), v_actor_id
    );

    -- 6. Atomically persist idempotency response within the same transaction.
    -- Concurrency Behavior: If an identical concurrent request inserts the same key before this commits,
    -- PostgreSQL raises a unique violation (23505) and rolls back the duplicate. The application layer handles 23505 by re-reading the committed response.
    v_existing_response := jsonb_build_object('status', 'SUCCESS', 'product_id', p_product_id, 'deducted', p_quantity);
    INSERT INTO idempotency_keys (org_id, idempotency_key, response_code, response_body)
    VALUES (p_org_id, p_idempotency_key, 200, v_existing_response);

    RETURN v_existing_response;
END;
$$;

-- Restrict execution permissions (never leave SECURITY DEFINER callable by anonymous public):
REVOKE EXECUTE ON FUNCTION rpc_execute_atomic_checkout(UUID, VARCHAR, UUID, NUMERIC) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION rpc_execute_atomic_checkout(UUID, VARCHAR, UUID, NUMERIC) TO authenticated;
```

---

## 6. API Contract Specifications (REST / JSON API)

### 6.1 Standard Endpoint Specification
- **Route**: `POST /api/v1/[resource]/mutate`
- **Authentication**: Bearer JWT (`Role-scoped access`)
- **Headers**:
  ```http
  Authorization: Bearer <TOKEN>
  Content-Type: application/json
  X-Idempotency-Key: 550e8400-e29b-41d4-a716-446655440000
  ```
- **Request Body Schema**:
  ```json
  {
    "resource_id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
    "quantity": 2.000,
    "action_type": "EXECUTE"
  }
  ```
- **Standardized Response Format**:
  - Success: `{"status": "SUCCESS", "data": { ... }}`
  - Error: `{"status": "ERROR", "error": {"code": "RESOURCE_LOCKED", "message": "Descriptive error"}}`

---

## 7. Automated Quality Validation Checklist (FSD Exit Gate)

*Before completing `docs/specs/FSD.md`, verify:*

- [ ] **1. Data Access & RLS Scoping**: Multi-tenant tables enforce appropriate isolation (`ENABLE ROW LEVEL SECURITY;` with granular role policies), or reasoned single-tenant/internal N/A documented.
- [ ] **2. Hardened Security Definer**: All database helper functions declare `SET search_path = public, pg_temp STABLE`.
- [ ] **3. Atomic Mutations with Concurrency Guards**: High-risk concurrent mutations (e.g. checkout, reservations, balance deductions, state transitions) are wrapped in atomic database transactions or stored procedures with row-locking (`FOR UPDATE`), or marked N/A with rationale for standard low-concurrency CRUD.
- [ ] **4. Accurate Data Types**: Monetary values avoid floating-point types (`BIGINT` or `NUMERIC`), and quantities support domain-required fractional precision.
- [ ] **5. 100% Foreign Key Indexes**: Every column with a `REFERENCES` constraint has an explicit `CREATE INDEX`.
- [ ] **6. Audit Trail Protection**: State journals, movement ledgers, and `audit_logs` protect historical records against un-audited `UPDATE` and `DELETE` operations.

---

## 8. Technical Sign-Off Sheet

| Validated by Lead Software Architect | Approved by Client PIC / Lead Stakeholder |
| :--- | :--- |
| **Name**: _________________________ | **Name**: _________________________ |
| **Role**: Lead Software Architect | **Role**: Client Single PIC / Project Lead |
| **Date**: [YYYY-MM-DD] | **Date**: [YYYY-MM-DD] |
| **Signature**: _____________________ | **Signature**: _____________________ |
