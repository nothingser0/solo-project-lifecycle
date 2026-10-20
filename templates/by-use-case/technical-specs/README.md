# Technical Specs Templates

**Use case**: Writing formal technical documentation for team collaboration

**Critical for**: Multi-developer teams, handover scenarios, external audits

---

## Core Specs (Must Have)

### 1. PRD.md (Product Requirements Document)
**Path**: `../../03-architecture-specs/PRD_FINAL_TEMPLATE.md`  
**Purpose**: Formal product spec (features, user stories, acceptance criteria)  
**Time**: 4 hours  
**When**: Before development starts (team >2 developers)

**Output**: `docs/specs/PRD.md`

```bash
mkdir -p docs/specs
cp templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md docs/specs/PRD.md
# Fill: user personas, functional requirements, non-functional requirements
```

**Key sections**:
- **Objectives**: North Star Metric (e.g., "30% conversion increase")
- **User Stories**: As [role], I want [feature], so that [benefit]
- **Acceptance Criteria**: Given/When/Then format (testable)
- **Non-functional**: Performance (<2s page load), security (HTTPS), accessibility (WCAG 2.1 AA)

**When to skip**: Solo MVP projects (use `PROJECT_LITE.md` instead)

---

### 2. FSD.md (Functional Specification Document)
**Path**: `../../03-architecture-specs/FSD_TECHNICAL_TEMPLATE.md`  
**Purpose**: Technical implementation spec (tech stack, DB schema, API contracts)  
**Time**: 6 hours  
**When**: After PRD approved, before coding

**Output**: `docs/specs/FSD.md`

```bash
cp templates/03-architecture-specs/FSD_TECHNICAL_TEMPLATE.md docs/specs/FSD.md
# Fill: tech stack decisions, database schema, API endpoint contracts
```

**Critical components**:
1. **Tech Stack**: Framework (Next.js 15), DB (PostgreSQL 16), hosting (Vercel)
2. **Database Schema**: Tables, columns, indexes, constraints (SQL DDL)
3. **API Contracts**: Endpoints, request/response schemas, error codes
4. **Third-party Integrations**: Payment (Midtrans), email (Resend), storage (S3)
5. **Security**: Auth flow (JWT), encryption (AES-256-GCM), HTTPS enforcement

**Example API contract**:
```typescript
POST /api/orders
Request: { items: { productId: string, qty: number }[], paymentMethod: 'bank_transfer' | 'e-wallet' }
Response: { orderId: string, totalAmount: number, paymentUrl: string }
Errors: 400 (invalid items), 402 (payment failed), 500 (server error)
```

---

### 3. DB_SCHEMA.sql
**Path**: Write manually in `db/schema.sql`  
**Purpose**: Database schema DDL (tables, indexes, constraints)  
**Time**: 2 hours  
**When**: After FSD database section finalized

**Output**: `db/schema.sql`

> **Note**: Write database schema directly in `db/schema.sql`. No template file exists — use FSD.md database section as reference.

**Best practices**:
- ✅ Use `BIGSERIAL` for IDs (not `SERIAL`)
- ✅ Add `created_at TIMESTAMPTZ DEFAULT NOW()` to all tables
- ✅ Index foreign keys + query filters (`WHERE status = 'active'`)
- ✅ Use `CHECK` constraints for enums (`status CHECK (status IN ('draft', 'published'))`)
- ✅ Add comments: `COMMENT ON COLUMN users.email IS 'Unique lowercase email'`

---

## Advanced Specs (High-Traffic Only)

### 4. SYSTEM_DESIGN_DOC.md
**Path**: `../../03-architecture-specs/SYSTEM_DESIGN_DOC_TEMPLATE.md`  
**Purpose**: Scalability design (load balancing, caching, high availability)  
**Time**: 3 hours  
**When**: >10K MAU or need 99.9% uptime

**Output**: `docs/specs/SYSTEM_DESIGN_DOC.md`

```bash
cp templates/03-architecture-specs/SYSTEM_DESIGN_DOC_TEMPLATE.md docs/specs/SYSTEM_DESIGN_DOC.md
# Design: Redis caching, CDN, horizontal scaling, database replication
```

**Key sections**:
- **Load estimation**: 10K MAU × 20 requests/day = 200K requests/day (2.3 req/sec)
- **Caching strategy**: Redis for sessions (TTL 1 hour), CDN for static assets
- **Database scaling**: Read replicas (3x), connection pooling (max 100)
- **Failover**: Primary-replica auto-failover (RTO 5 min, RPO 1 min)

**Skip if**: <5K MAU (premature optimization)

---

### 5. CAPACITY_PLANNING.md
**Path**: `../../03-architecture-specs/CAPACITY_PLANNING_TEMPLATE.md`  
**Purpose**: Resource sizing (CPU, RAM, storage) based on traffic projection  
**Time**: 2 hours  
**When**: Before infrastructure provisioning (Enterprise projects)

```bash
cp templates/03-architecture-specs/CAPACITY_PLANNING_TEMPLATE.md docs/specs/CAPACITY_PLANNING.md
# Calculate: server specs, database size, bandwidth
```

---

### 6. DISASTER_RECOVERY_PLAN.md
**Path**: `../../03-architecture-specs/DISASTER_RECOVERY_PLAN_TEMPLATE.md`  
**Purpose**: RPO/RTO targets, backup procedures, failover runbook  
**Time**: 2 hours  
**When**: Financial/healthcare/critical systems only

```bash
cp templates/03-architecture-specs/DISASTER_RECOVERY_PLAN_TEMPLATE.md docs/specs/DISASTER_RECOVERY_PLAN.md
# Define: backup frequency (daily), retention (30 days), restore procedure
```

---

## Spec Selection Matrix

| Project Type | Must Have | Recommended | Skip |
|-------------|-----------|-------------|------|
| **Solo MVP** | None (use PROJECT_LITE) | - | PRD, FSD, SYSTEM_DESIGN |
| **Team 2-4 devs** | PRD, FSD, DB_SCHEMA | SYSTEM_DESIGN | CAPACITY, DISASTER_RECOVERY |
| **Team 5+ devs** | PRD, FSD, DB_SCHEMA, SYSTEM_DESIGN | CAPACITY | DISASTER_RECOVERY |
| **Enterprise** | All | - | - |

**Time investment**:
- Solo: 0 hours (use PROJECT_LITE)
- Team 2-4: 12 hours (PRD + FSD + DB_SCHEMA)
- Team 5+: 15 hours (add SYSTEM_DESIGN)
- Enterprise: 22+ hours (all specs)

---

## Workflow: Specs → Code

```mermaid
graph LR
    A[PRD approved] --> B[Write FSD]
    B --> C[Extract DB_SCHEMA.sql]
    C --> D[Run migrations]
    D --> E[Backend coding]
    E --> F[Frontend coding]
```

**Critical path**: PRD (4h) → FSD (6h) → DB_SCHEMA (2h) → Code

**Parallel work**: While FSD in progress, designer works on DESIGN_SPEC.md

---

## Anti-Patterns

❌ **Writing specs during coding** - Specs should be complete before first line of code  
❌ **Copy-paste from ChatGPT** - LLM-generated specs lack business context  
❌ **Skipping DB schema** - "We'll figure out schema as we go" → migration hell  
❌ **Over-speccing MVP** - 25-hour spec for 2-week MVP (spec takes longer than build)

✅ **Do this instead**:
- Write specs collaboratively (PM + tech lead + designer)
- Review specs with team before approval (catch gaps early)
- Use PROJECT_LITE for MVPs, upgrade to PRD+FSD when team grows
- Document API contracts in FSD (no separate API_CONTRACT.md needed)
- Update specs when reality diverges (living documents, not museum artifacts)

---

**See also**:
- `../mvp-fast-track/` - For PROJECT_LITE.md alternative
- `../operations/` - For deployment & maintenance templates
- `../../TEMPLATE_INDEX.md` - Complete template catalog
