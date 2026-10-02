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
└── performance/
    └── (planned for v1.2)
```

---

## Quick Reference

### Validation Patterns
**File**: `patterns/validation/zod-patterns.md`

**Covers**:
- Basic schemas (auth, CRUD, file upload)
- Backend validation (Next.js API routes, middleware)
- Frontend validation (React Hook Form integration)
- Advanced patterns (dependent fields, transforms, refinements)
- Error handling best practices

**Referenced in**: M06 (9 locations), M07, M08

**Usage**:
```typescript
import { RegisterSchema } from '@/lib/schemas/auth';
const validatedData = RegisterSchema.parse(body);
```

---

### Security Patterns
**File**: `patterns/security/authentication.md`

**Covers**:
- Password hashing (Argon2id, bcrypt)
- JWT authentication (access + refresh tokens)
- HttpOnly cookies configuration
- Rate limiting (memory + Redis)
- Password reset flow
- UU PDP No. 27/2022 compliance

**Referenced in**: M05 (4 locations), M05B (3 locations), M06 (8 locations), M10 (2 locations)

**Usage**:
```typescript
import { hashPassword, verifyPassword } from '@/lib/auth/password';
import { generateAccessToken } from '@/lib/auth/jwt';
```

---

### Git Workflow Patterns
**File**: `patterns/git-workflow/branching-strategy.md`

**Covers**:
- Branch strategies (solo vs team)
- Conventional commits format
- Atomic commits best practices
- Release tagging (SemVer)
- Merge strategies (fast-forward, squash, merge commit)
- Conflict resolution
- Git hooks (Husky setup)

**Referenced in**: M03 (git branching), M06 (git workflow), M10 (git tagging)

**Usage**:
```bash
git checkout -b feature/auth-login
git commit -m "feat(auth): add JWT refresh token rotation"
git tag -a v1.0.0 -m "Release v1.0.0"
```

---

## Performance Patterns (Planned v1.2)

### N+1 Query Prevention
**Planned**: `patterns/performance/n-plus-one-prevention.md`

**Will cover**:
- Eager loading vs lazy loading
- DataLoader pattern
- Batch SQL queries
- ORM optimization (Prisma `include`, Laravel `with()`)

**Currently in**: M06 line 65, M05B (multiple references)

---

### Caching Strategies
**Planned**: `patterns/performance/caching-strategies.md`

**Will cover**:
- Redis caching layers
- CDN configuration
- Stale-while-revalidate
- Cache invalidation patterns

**Currently in**: M05B System Design, M06 Performance Pillar

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

### v1.1 (Current) ✅
- [x] Validation patterns (Zod)
- [x] Security patterns (Auth, JWT, rate limiting)
- [x] Git workflow patterns (Conventional commits, branching)

### v1.2 (Q1 2027)
- [ ] Performance patterns (N+1, caching)
- [ ] Error handling patterns (try-catch, boundary)
- [ ] Testing patterns (unit, integration, E2E)

### v2.0 (Q2 2027)
- [ ] Database patterns (migrations, seeding, transactions)
- [ ] Deployment patterns (CI/CD, rollback, monitoring)
- [ ] API design patterns (REST, GraphQL, versioning)

---

## Maintenance

### Updating Patterns

1. Edit pattern file (`patterns/<category>/<name>.md`)
2. Verify references in modules still accurate
3. Update pattern version in CHANGELOG.md
4. Commit: `docs(patterns): update <pattern> with <change>`

### Adding New Patterns

1. Identify duplication (3+ module references)
2. Extract to `patterns/<category>/<name>.md`
3. Update module references to point to pattern
4. Update this index
5. Commit: `feat(patterns): extract <pattern> from modules`

---

## See Also

- `templates/by-use-case/` - Task-oriented template navigation
- `IMPROVEMENT_ROADMAP.md` - v1.1-v2.0 improvement plan
- `TEMPLATE_INDEX.md` - Complete template catalog
