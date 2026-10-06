# Cross-Cutting Patterns Index

**Purpose**: Reusable implementation patterns extracted from modules to reduce duplication

**Impact**: Single source of truth for validation, security, git workflows, and performance patterns

---

## Directory Structure

```
patterns/
├── validation/
│   └── zod-patterns.md (13.9KB) - Type-safe validation schemas
├── security/
│   └── authentication.md (15.6KB) - JWT, password hashing, rate limiting
├── git-workflow/
│   └── branching-strategy.md (10.4KB) - Conventional commits, releases
├── performance/
│   ├── caching-strategies.md - Redis, CDN, cache invalidation
│   └── n-plus-one-prevention.md - DataLoader, eager loading, batch queries
├── database/
│   ├── supabase-migrations.md - Migration patterns, RLS policies
│   └── seeding-and-transactions.md - Idempotent seeders, atomic transactions, row locking
├── api/
│   ├── rest-conventions.md - HTTP methods, status codes, API design
│   └── graphql-and-versioning.md - GraphQL schema design, depth limits, URI versioning
├── error-handling/
│   └── error-boundaries.md - Custom error classes, logging, recovery
├── testing/
│   └── test-pyramid.md - Unit/integration/E2E strategy
└── deployment/
    └── ci-cd-pipeline.md - GitHub Actions, blue-green, canary
```

---

## Quick Reference

### Validation Patterns
**File**: `patterns/validation/zod-patterns.md`  
**Covers**: Basic schemas, backend/frontend validation, transforms, refinements  
**Referenced in**: M06 (9 locations), M07, M08

---

### Security Patterns
**File**: `patterns/security/authentication.md`  
**Covers**: Password hashing, JWT, rate limiting, UU PDP No. 27/2022 compliance  
**Referenced in**: M05 (4 locations), M05B (3 locations), M06 (8 locations), M10 (2 locations)

---

### Git Workflow Patterns
**File**: `patterns/git-workflow/branching-strategy.md`  
**Covers**: Branch strategies, conventional commits, SemVer, merge strategies  
**Referenced in**: M03 (git branching), M06 (git workflow), M10 (git tagging)

---

### API Design Patterns
**File**: `patterns/api/rest-conventions.md`  
**Covers**: HTTP methods, status codes, pagination, filtering, error responses, versioning  
**Referenced in**: M05 (API design), M06 (API development), M07 (API testing)

**File**: `patterns/api/graphql-and-versioning.md`
**Covers**: REST vs GraphQL decision matrix, query depth limiting, URI/Header versioning, RFC 7807 errors
**Referenced in**: M05 (API architecture), M06 (API implementation)

---

### Error Handling Patterns
**File**: `patterns/error-handling/error-boundaries.md`  
**Covers**: Custom error classes, global handlers, React error boundaries, graceful shutdown  
**Referenced in**: M06 (error handling), M07 (QA), M10 (production errors)

---

### Testing Patterns
**File**: `patterns/testing/test-pyramid.md`  
**Covers**: Unit/integration/E2E balance, mocking strategies, frameworks (Vitest, Playwright)  
**Referenced in**: M06 (TDD), M07 (SIT), M09 (UAT)

---

### Deployment Patterns
**File**: `patterns/deployment/ci-cd-pipeline.md`  
**Covers**: GitHub Actions, blue-green deployment, canary releases, health checks  
**Referenced in**: M10 (deployment), M11 (handover)

---

### Performance Patterns
**File**: `patterns/performance/caching-strategies.md`  
**Covers**: Redis caching, CDN, stale-while-revalidate, cache invalidation  
**Referenced in**: M05B (system design), M06 (performance pillar)

**File**: `patterns/performance/n-plus-one-prevention.md`  
**Covers**: Eager loading, DataLoader pattern, Prisma optimization  
**Referenced in**: M06 (backend development), M05B (database design)

---

### Database Patterns
**File**: `patterns/database/supabase-migrations.md`  
**Covers**: Migration strategies, RLS policies, type safety  
**Referenced in**: M05 (database design), M06 (migrations)

**File**: `patterns/database/seeding-and-transactions.md`
**Covers**: Atomic transactions ($transaction), row locking (FOR UPDATE), idempotent upsert seeding, batch imports
**Referenced in**: M05 (schema design), M06 (transactions), M08 (seeding)

---

## Migration Benefits

### Before Extraction (Duplication)

**Zod validation** mentioned in:
- M06 lines 229, 342, 1013, 1033, 1193, 1246, 1275, 1394, 1525
- M07 lines 22, 61
- M08 lines 36, 66, 91

**Problem**: 12 scattered references, inconsistent examples, maintenance burden (update 12 locations)

---

### After Extraction (Single Source)

**Zod validation** now:
- `patterns/validation/zod-patterns.md` (single comprehensive guide)
- Modules reference: "See `patterns/validation/zod-patterns.md`"
- Update once, referenced everywhere

**Benefits**:
- ✅ Reduced duplication: -15% module size estimated
- ✅ Consistent examples: Same schemas across modules
- ✅ Easier maintenance: Update 1 file vs 12 locations
- ✅ Better reusability: Copy-paste ready patterns

---

## Usage in Modules

### Module References Format

**Before** (inline duplication):
```markdown
### Validation

Use Zod for type-safe validation:
```typescript
const UserSchema = z.object({
  email: z.string().email(),
  age: z.number().min(18)
});
```
```

**After** (pattern reference):
```markdown
### Validation

Use Zod for type-safe validation. See `patterns/validation/zod-patterns.md` for:
- Reusable auth schemas (RegisterSchema, LoginSchema)
- Backend validation middleware
- Frontend React Hook Form integration
- Advanced patterns (dependent fields, transforms)
```

---

## Pattern Creation Guidelines

### When to Extract

**Extract when**:
- ✅ Duplicated across 3+ modules
- ✅ Cross-cutting concern (not phase-specific)
- ✅ Reusable implementation detail
- ✅ Standard industry practice (not framework opinion)

**Don't extract**:
- ❌ Module-specific workflow (belongs in module)
- ❌ Phase-specific decision (part of SDLC flow)
- ❌ Referenced only once or twice
- ❌ Framework opinion (keep in module with context)

---

### Pattern File Structure

**Template**:
```markdown
# Pattern Name

**Purpose**: One-line description

**Reference locations**: Module references (M06 line 123, M08 line 456)

---

## Core Principles

1-3 key principles

---

## Installation

Package installation commands

---

## Basic Examples

Copy-paste ready code

---

## Advanced Patterns

Edge cases, optimizations

---

## Testing

Test examples

---

## See Also

- Related patterns
- Module references
```

---

## Roadmap

### Production Core Patterns (Complete) ✅
- [x] Validation patterns (Zod)
- [x] Security patterns (Auth, JWT, rate limiting)
- [x] Git workflow patterns (Conventional commits, branching)
- [x] Performance patterns (N+1 prevention, Redis caching)
- [x] Error handling patterns (custom classes, global boundaries)
- [x] Testing patterns (Test pyramid: unit, integration, E2E)
- [x] Database patterns (Supabase migrations, seeding, atomic transactions)
- [x] Deployment patterns (CI/CD pipelines, canary monitoring, rollback)
- [x] API design patterns (REST conventions, GraphQL architecture, versioning)

---

## Maintenance

### Updating Patterns

1. Edit pattern file (`patterns/{category}/{name}.md`)
2. Verify references in modules still accurate
3. Commit: `docs(patterns): update {pattern} with {change}`

### Adding New Patterns

1. Identify duplication (3+ module references)
2. Extract to `patterns/{category}/{name}.md`
3. Update module references to point to pattern
4. Update this index
5. Commit: `feat(patterns): extract {pattern} from modules`

---

## See Also

- `templates/by-use-case/` - Task-oriented template navigation
- `templates/README.md` - Complete template catalog and stage/gate matrix
