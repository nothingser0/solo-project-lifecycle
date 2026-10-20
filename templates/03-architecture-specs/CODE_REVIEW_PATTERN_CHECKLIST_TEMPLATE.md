# Code Review Pattern Checklist

**Project**: [Project Name]  
**Reviewer**: [Name]  
**Date**: [YYYY-MM-DD]  
**Branch/PR**: [Link]  
**AI Tool Used**: [ ] ChatGPT [ ] GitHub Copilot [ ] Claude [ ] Cursor [ ] Other: _______

---

## 1. Clean Code Fundamentals

### Naming Conventions
- [ ] **Variables/functions**: Meaningful, intention-revealing names (not `data`, `tmp`, `x`)
- [ ] **Constants**: Named instead of magic numbers (`MILLISECONDS_PER_DAY` not `86400000`)
- [ ] **Functions**: Verb-noun pattern (`getUserById`, `calculateTotal`)
- [ ] **Boolean variables**: Prefix with `is`, `has`, `should` (`isActive`, `hasPermission`)
- [ ] **Classes**: Noun pattern, singular (`User` not `Users`, `OrderService` not `OrdersManager`)

**Issues Found**:
```
File: _____________
Line: _____________
Issue: _____________
Suggestion: _____________
```

### Function Quality
- [ ] **Length**: Functions < 20 lines (extract longer ones)
- [ ] **Complexity**: Cyclomatic complexity < 10 (simplify nested if/else)
- [ ] **Parameters**: < 4 parameters (use parameter object if more)
- [ ] **Single Responsibility**: Each function does ONE thing
- [ ] **No side effects**: Pure functions when possible

**Issues Found**:
```
Function: _____________
Lines: _____________
Complexity: _____________
Action: _____________
```

### Comments & Documentation
- [ ] **Why, not what**: Comments explain reasoning, not implementation
- [ ] **No redundant comments**: Code is self-documenting
- [ ] **TODO/FIXME addressed**: Or tracked in issue tracker
- [ ] **ponytail comments**: Deliberate simplifications documented with upgrade path

**Example**:
```typescript
// BAD
// Loop through users
for (const user of users) { }

// GOOD
// Retry 3 times due to payment gateway transient failures
// ponytail: upgrade to exponential backoff when error rate > 1%
const MAX_RETRIES = 3;
```

---

## 2. SOLID Principles Compliance

### Single Responsibility Principle (SRP)
- [ ] Each class has one reason to change
- [ ] No "God classes" (< 300 lines per class)
- [ ] No "Manager" or "Utils" dumping grounds

**Violations**:
```
Class: _____________
Responsibilities: _____________, _____________, _____________
Refactor: Split into _____________
```

### Open/Closed Principle (OCP)
- [ ] Can add new behavior without modifying existing code
- [ ] Uses polymorphism/strategy pattern instead of switch/if chains
- [ ] Extension points clearly defined

**Check**:
```typescript
// ❌ Violates OCP - must modify to add discount type
if (type === 'percentage') { ... }
else if (type === 'fixed') { ... }

// ✅ Follows OCP - add new class to extend
interface DiscountStrategy { calculate(): number; }
```

### Liskov Substitution Principle (LSP)
- [ ] Subtypes are substitutable for base types
- [ ] No unexpected behavior in overridden methods
- [ ] Preconditions not strengthened, postconditions not weakened

### Interface Segregation Principle (ISP)
- [ ] Interfaces are small and focused
- [ ] No "fat interfaces" forcing empty implementations
- [ ] Clients depend only on methods they use

### Dependency Inversion Principle (DIP)
- [ ] High-level modules don't depend on low-level modules
- [ ] Both depend on abstractions (interfaces)
- [ ] Dependencies injected via constructor/setter

**DI Check**:
```typescript
// ❌ Tight coupling
class UserService {
  private db = new MySQLDatabase(); // Direct dependency
}

// ✅ Dependency injection
class UserService {
  constructor(private db: Database) {} // Injected interface
}
```

---

## 3. Design Pattern Application

### Pattern Detection
- [ ] **Repository**: Data access abstracted behind interface
- [ ] **Service Layer**: Business logic in service classes
- [ ] **Factory**: Object creation centralized when multiple types
- [ ] **Strategy**: Algorithm selection at runtime
- [ ] **Observer**: Event-driven decoupling
- [ ] **Decorator**: Dynamic behavior addition
- [ ] **DTO**: API boundaries use DTOs, not domain entities

**Appropriate Patterns**:
| Pattern Used | Location | Justified? | Notes |
|--------------|----------|------------|-------|
| Repository | `lib/repositories/` | ✅ YES | Abstracts Prisma |
| Factory | `lib/factories/` | ❌ NO | Only 1 product type - unnecessary |
| | | | |

### Anti-Pattern Detection
- [ ] **God Class**: Class doing everything (> 500 lines)
- [ ] **Primitive Obsession**: Raw strings/numbers instead of value objects
- [ ] **Anemic Domain Model**: Entities with only getters/setters
- [ ] **Feature Envy**: Method uses another class's data more than its own
- [ ] **Shotgun Surgery**: Single change requires editing many files
- [ ] **Singleton Abuse**: Global state instead of DI

**Anti-Patterns Found**:
```
Type: _____________
Location: _____________
Impact: _____________
Refactor: _____________
```

---

## 4. AI-Specific Issues

### Over-Engineering (AI Loves Unnecessary Abstraction)
- [ ] **Factory with one implementation**: Wait for second before abstracting
- [ ] **Interface with single implementer**: Remove until needed
- [ ] **Excessive layering**: Service that only delegates to repository
- [ ] **Premature generalization**: Configuration for values that never change

**Over-Engineering Examples**:
```typescript
// ❌ AI-generated over-engineering
interface UserFactory { create(): User; }
class ConcreteUserFactory implements UserFactory { ... }
class UserCreationService {
  constructor(private factory: UserFactory) {}
}

// ✅ Human simplification
function createUser(email: string): User {
  return new User(email);
}
// ponytail: add factory when premium/enterprise user types added
```

### Under-Engineering (AI Misses Critical Concerns)
- [ ] **No input validation**: Zod/Yup schema missing
- [ ] **No authorization**: Permission checks absent
- [ ] **No error handling**: Try-catch missing or empty
- [ ] **No audit trail**: Who/when/what changes not logged
- [ ] **Silent failures**: Errors swallowed or ignored
- [ ] **Hardcoded values**: Configuration not in environment variables

**Under-Engineering Checklist**:
```
Function: _____________
❌ Missing: [ ] Validation [ ] Auth [ ] Error handling [ ] Audit [ ] Tests
Priority: [ ] P0-Critical [ ] P1-High [ ] P2-Medium [ ] P3-Low
```

### AI-Generated Code Smells
- [ ] **Any/unknown types**: TypeScript `any` instead of proper types
- [ ] **Overly generic names**: `handleData`, `processRequest`, `doStuff`
- [ ] **Copy-paste duplication**: Similar code blocks not extracted
- [ ] **Inconsistent error handling**: Some functions throw, others return null
- [ ] **Missing edge cases**: Only happy path implemented

---

## 5. Security & Data Protection

### Authentication & Authorization
- [ ] **Password hashing**: Argon2id or bcrypt (cost ≥ 12)
- [ ] **JWT expiry**: Short-lived tokens (< 1 hour)
- [ ] **Permission checks**: Authorization enforced server-side
- [ ] **Rate limiting**: Sensitive endpoints protected (login, OTP, checkout)

### Input Validation
- [ ] **Schema validation**: Zod/Yup validates all external input
- [ ] **SQL injection prevention**: Parameterized queries only
- [ ] **XSS prevention**: User input sanitized before rendering
- [ ] **CSRF protection**: Tokens on state-changing operations

### Data Encryption
- [ ] **Sensitive data at rest**: AES-256-GCM encryption
- [ ] **Passwords never logged**: Excluded from error messages/logs
- [ ] **PII handling**: Compliant with GDPR/UU PDP No. 27/2022
- [ ] **TLS 1.3**: HTTPS enforced

**Security Issues**:
```
Severity: [ ] Critical [ ] High [ ] Medium [ ] Low
Location: _____________
Issue: _____________
Fix: _____________
```

---

## 6. Error Handling & Resilience

### Error Handling Patterns
- [ ] **Explicit exceptions**: Meaningful error classes (`UserNotFoundError`)
- [ ] **No empty catch blocks**: All errors logged or re-thrown
- [ ] **Error messages actionable**: Tell user what went wrong and how to fix
- [ ] **Error propagation**: Don't swallow errors deep in stack

**Bad Error Handling**:
```typescript
// ❌ Silent failure
try {
  await sendEmail(user.email);
} catch (e) {
  // Swallowed!
}

// ❌ Vague error
throw new Error("Invalid input");

// ✅ Explicit and actionable
try {
  await sendEmail(user.email);
} catch (e) {
  logger.error(`Failed to send email to ${user.email}:`, e);
  throw new EmailDeliveryError(
    `Unable to send email to ${user.email}. Please verify address.`
  );
}
```

### Resilience Patterns
- [ ] **Retry logic**: Transient failures retried (exponential backoff)
- [ ] **Circuit breaker**: Failing services short-circuited
- [ ] **Timeouts**: All external calls have timeouts
- [ ] **Fallbacks**: Degraded functionality when dependencies fail

---

## 7. Testing & Testability

### Test Coverage
- [ ] **Unit tests**: Core business logic covered
- [ ] **Integration tests**: API endpoints tested
- [ ] **Edge cases**: Error paths tested, not just happy path
- [ ] **Test naming**: Describes behavior (`should_throw_when_email_invalid`)

### Testability Issues
- [ ] **Hard to mock**: Dependencies not injected
- [ ] **Side effects**: Functions not pure (DB calls, file I/O)
- [ ] **Tight coupling**: Can't test in isolation
- [ ] **No test written**: AI generated code but no tests

**Test Debt**:
```
File: _____________
Coverage: _____%
Missing Tests: _____________
Priority: _____________
```

---

## 8. Performance & Scalability

### Database Performance
- [ ] **N+1 queries**: Eager loading used where appropriate
- [ ] **Missing indexes**: Queries on non-indexed columns
- [ ] **Connection pooling**: Connection limits configured
- [ ] **Pagination**: Large result sets paginated

### API Performance
- [ ] **Response time**: p95 < 500ms, p99 < 1s
- [ ] **Caching**: Expensive operations cached
- [ ] **Lazy loading**: Heavy resources loaded on demand
- [ ] **Batch operations**: Multiple operations batched

**Performance Issues**:
```
Location: _____________
Issue: _____________
Impact: _____________
Fix: _____________
```

---

## 9. Architecture & Structure

### Layered Architecture
- [ ] **Clear separation**: Presentation → Application → Domain → Infrastructure
- [ ] **Dependency direction**: Outer layers depend on inner, not vice versa
- [ ] **No leaky abstractions**: DB details don't leak into business logic

### File Organization
- [ ] **Logical grouping**: Files grouped by feature, not type
- [ ] **Consistent naming**: Follows project conventions
- [ ] **No circular dependencies**: Import graph is acyclic

**Structure Issues**:
```
Issue: _____________
Current: _____________
Desired: _____________
```

---

## 10. Documentation & Maintainability

### Code Documentation
- [ ] **Public APIs documented**: JSDoc/PHPDoc for exported functions
- [ ] **Complex logic explained**: Non-obvious code has comments
- [ ] **README updated**: Setup instructions current
- [ ] **Changelog maintained**: Notable changes logged

### Technical Debt
- [ ] **TODO items tracked**: In issue tracker, not just comments
- [ ] **Deprecated code marked**: Clear migration path
- [ ] **Breaking changes noted**: CHANGELOG updated

---

## Summary & Verdict

### Critical Issues (Block Merge)
1. _____________
2. _____________
3. _____________

### High Priority (Must Fix)
1. _____________
2. _____________
3. _____________

### Medium Priority (Should Fix)
1. _____________
2. _____________

### Low Priority / Nice-to-Have
1. _____________
2. _____________

### Positive Highlights
- _____________
- _____________
- _____________

### Overall Assessment
- [ ] **Approve**: Ready to merge
- [ ] **Approve with comments**: Minor issues, can merge
- [ ] **Request changes**: Must address critical/high issues
- [ ] **Reject**: Major architectural problems, needs redesign

**Final Notes**:
_____________________________________________
_____________________________________________
_____________________________________________

---

## Reviewer Signature

**Reviewed by**: _____________  
**Date**: _____________  
**Next review**: _____________
