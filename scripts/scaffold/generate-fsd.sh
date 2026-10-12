#!/usr/bin/env bash
# Generate FSD (Functional Specification Document) scaffold with pinned versions
# Usage: ./scripts/generate-fsd.sh [framework] [project_name]

set -e

FRAMEWORK="${1:-nextjs}"
PROJECT_NAME="${2:-MyProject}"
DATE=$(date +%Y-%m-%d 2>/dev/null || date -u +%F)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Run check-package-versions if available to extract recommendations
VERSION_HINTS=""
VERSION_CHECK="$SCRIPT_DIR/../verify/check-package-versions.sh"
if [ -f "$VERSION_CHECK" ]; then
    VERSION_HINTS=$(bash "$VERSION_CHECK" "$FRAMEWORK" 2>/dev/null | grep -A 10 "Recommended Pinned Versions" || true)
fi

cat <<EOF
# Functional Specification Document (FSD) - Technical Specifications

**Project**: $PROJECT_NAME  
**Stack**: $FRAMEWORK  
**Date**: $DATE  
**Status**: DRAFT (Generated from Lifecycle Harness)

---

## 1. System Architecture & Pinned Versions

$VERSION_HINTS

### Core Runtime Dependencies
- Node.js LTS (v20+ / v22+)
- PostgreSQL v16+ (Supabase / RDS)
- TypeScript v5.5+ (Strict mode: enabled)

---

## 2. Database Schema & Data Models

\`\`\`sql
-- Extension initialization
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Core tenants/organizations table (Multi-tenancy isolation)
CREATE TABLE organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Users & Profiles table
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    organization_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
    role VARCHAR(50) NOT NULL CHECK (role IN ('owner', 'admin', 'manager', 'operator', 'member')),
    full_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Row Level Security (RLS)
ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
\`\`\`

---

## 3. API Contracts (REST / Server Actions)

### 3.1 Authentication & Session
- \`POST /api/auth/login\`: Authenticates credentials, sets secure HttpOnly cookie.
- \`POST /api/auth/logout\`: Revokes session token.

### 3.2 Resources
- \`GET /api/v1/resources\`: Paginated list (\`?page=1&limit=20\`), role-filtered.
- \`POST /api/v1/resources\`: Creates resource with Zod schema validation.
- \`GET /api/v1/resources/:id\`: Resource detail.
- \`PUT /api/v1/resources/:id\`: Resource update with audit logging.

---

## 4. Security & Compliance Controls

1. **Authentication**: Supabase SSR / JWT HttpOnly cookies with CSRF validation.
2. **Authorization**: RBAC enforced at database layer (RLS) and middleware.
3. **Data Protection**: UU PDP compliance (consent logging, right-to-erasure endpoint).
4. **Secrets Handling**: Zero raw API secrets in client bundles; strictly server-side \`.env.local\`.
EOF
