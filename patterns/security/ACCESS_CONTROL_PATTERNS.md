# Access Control Architecture Patterns (RBAC, ABAC, ReBAC)

> **Standard Reference**: Technical architecture, schema designs, and decision rubrics for access control models in the `solo-project-lifecycle` (`docs/pm/SCOPE_STATEMENT.md` Section 3, `docs/specs/FSD.md` Section 2, and `docs/specs/DESIGN_SPEC.md`).

---

## 1. Access Control Comparison & Solo Decision Rubric

| Model | Core Concept | Flexibility | Solo Dev Complexity | Best Used In |
|:---|:---|:---:|:---:|:---|
| **RBAC** (Role-Based Access Control) | Permissions tied to named Roles (e.g., Admin, Manager, Cashier) | Medium | **Low - Medium (Default)** | Standard SaaS, POS, CRM, Internal Tools, SMB Apps |
| **ReBAC** (Relationship-Based Access Control) | Permissions derived from Object Graphs (Google Zanzibar: *User X is Editor of Doc Y via Team Z*) | High | **Medium - High** | Realtime Collab (Figma/Miro), Whiteboards, Drive/Folders |
| **ABAC** (Attribute-Based Access Control) | Permissions evaluated dynamically via User/Resource/Environment attributes (IP, time, department) | Very High | **High** (Hard to audit) | FinTech compliance, government, conditional branch geo-fencing |
| **MAC / DAC** | Mandatory (OS/military clear levels) vs Discretionary (Object owner grants access) | Rigid / Unpredictable | **Not recommended** | Low-level OS / specialized military systems |

> 💡 **Solo Engineer Golden Rule**: Always default to **RBAC** for 90% of SaaS applications. Upgrade to **ReBAC** only if the core domain is a multi-user workspace/collaboration tool (like Google Docs or Whiteboard). Avoid full ABAC unless legally mandated.

---

## 2. Multi-Tenant RBAC Implementation (Postgres + Supabase RLS)

### Schema Design (Zero Overhead & Fast Indexing)
```sql
-- 1. Tenants / Organizations
CREATE TABLE organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. User Roles Junction (One user can have different roles in different orgs)
CREATE TABLE user_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL CHECK (role IN ('owner', 'manager', 'cashier', 'accountant')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(org_id, user_id)
);

CREATE INDEX idx_user_roles_lookup ON user_roles(user_id, org_id, role);
```

### Row Level Security (RLS) Policy Example
```sql
-- Ensure cashiers can only read transactions, managers can approve, and zero cross-tenant leak
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "tenant_isolation_select" ON transactions
FOR SELECT USING (
    org_id IN (
        SELECT org_id FROM user_roles WHERE user_id = auth.uid()
    )
);

CREATE POLICY "manager_only_void_approval" ON transactions
FOR UPDATE USING (
    org_id IN (
        SELECT org_id FROM user_roles 
        WHERE user_id = auth.uid() 
        AND role IN ('owner', 'manager')
    )
);
```

---

## 3. Mandatory Domain Guardrails in M02 & M06

1. **Zero Self-Approval Guardrail**:
   - Managers or employees cannot approve their own expenses, voids, or purchase requests. The backend MUST assert: `creator_id != approver_id`.
2. **Field-Level / Column-Level Hiding**:
   - RLS filters rows, not columns. Use Postgres Views or GraphQL/TRPC select masks to hide sensitive fields (`buy_price`, `margin`, `staff_salary`) from lower roles (like Cashier).
3. **Session Auto-Lock & Inactivity Timeouts**:
   - Shared terminals (e.g. POS counter): PIN-pad quick switch or 15–30 minute auto-lock.
   - Admin/Personal dashboards: 7-day refresh token rotation with immediate revocation on password change.
