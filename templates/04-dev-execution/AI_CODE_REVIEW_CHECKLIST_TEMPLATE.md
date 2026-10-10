# AI Code Review Checklist

> Mandatory review protocol for AI-generated code before merging to staging/production.

**Project**: [Project Name]  
**Reviewer**: [Your Name]  
**Date**: [YYYY-MM-DD]  
**AI Tool Used**: [Cursor / Windsurf / Claude Code / GitHub Copilot]  
**Feature/PR**: [Description]

---

## Pre-Review: Automated Checks

Run these commands before manual review:

```bash
# Type Safety
pnpm tsc --noEmit

# Linting
pnpm eslint . --max-warnings 0

# Security Audit
pnpm audit --audit-level=high

# Tests
pnpm test --run

# Build
pnpm build
```

**All checks passed?** ☐ Yes ☐ No (fix before continuing)

---

## 1. Security Review (MANDATORY)

### 1.1 Authentication & Authorization

- [ ] **No hardcoded secrets**: No API keys, passwords, JWT secrets in code
  - Search: `git diff | grep -E "(password|secret|api.?key|token)" -i`
  
- [ ] **Password handling**: Bcrypt/Argon2 with min 12 rounds, never plaintext
  - Check: Password hashing code uses `bcrypt.hash()` or `argon2.hash()`
  
- [ ] **JWT security**: Secret from env var, HttpOnly cookies, SameSite=Lax
  - Check: `JWT_SECRET` from `process.env`, cookie options correct
  
- [ ] **Session management**: Secure session storage, proper expiration
  - Check: Sessions expire, refresh token rotation implemented
  
- [ ] **Auth guards on protected routes**: All admin/user routes check permissions
  - Check: Middleware or route guard verifies `req.user.role`

### 1.2 Input Validation

- [ ] **All user input validated**: Zod/Joi schema on every API endpoint
  - Check: Every `request.json()` followed by `.parse()` or `.safeParse()`
  
- [ ] **SQL injection prevention**: No string concatenation in queries
  - Check: Prisma parameterized queries only, no template literals in WHERE
  
- [ ] **XSS prevention**: User content sanitized, no `dangerouslySetInnerHTML`
  - Check: Search for `dangerouslySetInnerHTML`, verify sanitization
  
- [ ] **Path traversal prevention**: File paths validated, no `../` in uploads
  - Check: File upload paths use `path.basename()`, reject parent directory access
  
- [ ] **File upload validation**: MIME type checked server-side, size limits enforced
  - Check: File type verified with magic numbers, not just extension

### 1.3 Data Protection

- [ ] **Sensitive data encrypted**: PII encrypted at rest (AES-256-GCM)
  - Check: Database columns with sensitive data encrypted before storage
  
- [ ] **HTTPS only**: No HTTP endpoints, all cookies with Secure flag
  - Check: Production config forces HTTPS redirect
  
- [ ] **CORS configured**: Whitelist specific origins, no `Access-Control-Allow-Origin: *`
  - Check: CORS middleware has explicit origin list
  
- [ ] **Rate limiting**: API endpoints have rate limits (e.g., 100 req/min)
  - Check: Rate limiter middleware applied to public endpoints

### 1.4 Error Handling

- [ ] **No sensitive data in errors**: Stack traces hidden in production
  - Check: Error responses don't leak file paths, SQL queries, internal IPs
  
- [ ] **Proper error codes**: 4xx for client errors, 5xx for server errors
  - Check: Errors use correct HTTP status codes
  
- [ ] **Logging without secrets**: Logs don't contain passwords, tokens
  - Check: Search logs for `password`, `token` keys

**Security Notes**: [Any security concerns or exceptions]

---

## 2. Performance Review

### 2.1 Database Queries

- [ ] **No N+1 queries**: Relations included in single query, not in loop
  - Check: Search for `await` inside `for` loop with Prisma queries
  
- [ ] **Proper indexing**: Foreign keys and frequently queried columns indexed
  - Check: Prisma schema has `@@index` on join columns
  
- [ ] **Query pagination**: Large result sets use `skip`/`take` pagination
  - Check: Queries returning many rows have pagination
  
- [ ] **Select only needed fields**: Use `select` to limit fields, not fetch all
  - Check: Queries select specific fields, not entire models when unnecessary

### 2.2 React Performance

- [ ] **Memoization used correctly**: `useMemo`/`useCallback` for expensive operations
  - Check: Heavy computations wrapped in `useMemo`, callbacks in `useCallback`
  
- [ ] **No unnecessary re-renders**: Components use `React.memo` where appropriate
  - Check: Large lists, expensive components wrapped in `React.memo`
  
- [ ] **Code splitting**: Large components lazy loaded with `dynamic()` or `lazy()`
  - Check: Heavy components use Next.js `dynamic()` import
  
- [ ] **Image optimization**: Using `next/image`, not raw `<img>` tags
  - Check: All images use Next.js Image component with proper sizing

### 2.3 Caching

- [ ] **API response caching**: Expensive queries cached (Redis/in-memory)
  - Check: Frequently accessed data has cache layer
  
- [ ] **HTTP cache headers**: Static assets have long cache duration
  - Check: `Cache-Control` headers set on static responses
  
- [ ] **Stale-while-revalidate**: Used for data that can be slightly stale
  - Check: React Query or SWR configured with appropriate stale times

### 2.4 Resource Management

- [ ] **No memory leaks**: Event listeners cleaned up, intervals cleared
  - Check: `useEffect` returns cleanup function for subscriptions/intervals
  
- [ ] **Stream processing**: Large files processed as streams, not loaded fully
  - Check: File uploads use streams, not `Buffer` for entire file
  
- [ ] **Connection pooling**: Database connections pooled, not created per request
  - Check: Prisma uses connection pool, not new client per request

**Performance Notes**: [Metrics, benchmarks, or concerns]

---

## 3. Code Quality Review

### 3.1 TypeScript

- [ ] **No `any` types**: All variables properly typed
  - Check: Search codebase for `: any` - should be zero occurrences
  
- [ ] **Strict mode enabled**: `tsconfig.json` has `"strict": true`
  - Check: TypeScript strict mode active
  
- [ ] **Proper type inference**: Types inferred where possible, not over-specified
  - Check: Simple cases use inference, complex cases have explicit types
  
- [ ] **Discriminated unions**: For complex state, use discriminated unions
  - Check: State machines use `type` discriminator field

### 3.2 Code Style

- [ ] **Consistent naming**: camelCase for variables/functions, PascalCase for components
  - Check: Naming conventions match project standards (CONVENTIONS.md)
  
- [ ] **Function length**: Functions under 50 lines, single responsibility
  - Check: No mega-functions, logic properly extracted
  
- [ ] **No dead code**: Unused imports, variables, functions removed
  - Check: ESLint `no-unused-vars` rule passes
  
- [ ] **Comments for complex logic**: Non-obvious code has explanatory comments
  - Check: Business logic documented, not obvious code

### 3.3 Error Handling

- [ ] **Try-catch on async operations**: All `await` calls wrapped or handled
  - Check: Async functions have error handling
  
- [ ] **Graceful degradation**: App doesn't crash on API failures
  - Check: Error boundaries in React, fallback UI displayed
  
- [ ] **User-friendly error messages**: Errors explain what happened, not technical jargon
  - Check: Error messages are actionable for users

**Code Quality Notes**: [Refactoring suggestions, code smells]

---

## 4. Accessibility Review (WCAG AA)

### 4.1 Keyboard Navigation

- [ ] **All interactive elements keyboard accessible**: Tab through entire UI
  - Test: Can complete all actions with keyboard only (no mouse)
  
- [ ] **Focus indicators visible**: Focused elements have visible outline/ring
  - Test: Tab through page, see clear focus state on every element
  
- [ ] **Logical tab order**: Tab order follows visual layout
  - Test: Tab order makes sense, doesn't jump around randomly
  
- [ ] **No keyboard traps**: Focus doesn't get stuck in modals/menus
  - Test: Can escape modals with Esc key, close menus with Tab

### 4.2 Screen Reader Support

- [ ] **Semantic HTML**: Using `<button>`, `<nav>`, `<main>`, not div soup
  - Check: Elements use proper HTML tags for their purpose
  
- [ ] **ARIA labels**: Interactive elements have `aria-label` or visible text
  - Check: Icons, image buttons have labels
  
- [ ] **Form labels**: All inputs have associated `<label>` or `aria-label`
  - Check: Every form field labeled
  
- [ ] **Landmarks**: Page has `main`, `nav`, `header`, `footer` landmarks
  - Check: Screen reader can navigate by landmarks

### 4.3 Visual Accessibility

- [ ] **Color contrast**: Text meets 4.5:1 ratio, UI elements 3:1
  - Test: Run axe DevTools or manual contrast checker
  
- [ ] **No color-only information**: Information conveyed beyond just color
  - Check: Error states have icons, not just red color
  
- [ ] **Text resizable**: UI works at 200% browser zoom
  - Test: Zoom to 200%, check for overflow/broken layout
  
- [ ] **Focus visible**: Focus outline not removed without replacement
  - Check: No `outline: none` without custom focus styles

**Accessibility Notes**: [Issues found, WCAG exceptions if any]

---

## 5. Testing Review

### 5.1 Test Coverage

- [ ] **Unit tests exist**: New functions/components have unit tests
  - Check: `__tests__` directory has tests for new code
  
- [ ] **Tests actually test**: Tests fail when code is intentionally broken
  - Test: Comment out key logic, verify tests fail
  
- [ ] **Edge cases covered**: Tests include boundary conditions, empty states
  - Check: Tests cover happy path + error cases + edge cases
  
- [ ] **Integration tests for critical flows**: Auth, payment, data mutation tested
  - Check: Critical user journeys have integration tests

### 5.2 Test Quality

- [ ] **Tests are readable**: Test names describe what they test
  - Check: Test names use `it('should ...')` or `test('...')` format
  
- [ ] **No flaky tests**: Tests pass consistently, no race conditions
  - Run: Tests 3 times, all pass
  
- [ ] **Proper mocking**: External dependencies mocked, not hitting real APIs
  - Check: Tests use MSW or similar for API mocking
  
- [ ] **Fast tests**: Unit tests run in <5s, integration tests <30s
  - Run: `pnpm test` and check duration

**Testing Notes**: [Coverage gaps, flaky tests]

---

## 6. AI-Specific Review

### 6.1 Hallucination Check

- [ ] **Package names real**: All imports exist in `package.json`
  - Check: Run `pnpm why [package]` for any unfamiliar packages
  
- [ ] **API signatures correct**: Function calls match actual library API
  - Check: Cross-reference with official docs, not AI memory
  
- [ ] **File paths exist**: Imports point to real files
  - Check: Run build, verify no import errors
  
- [ ] **Environment variables documented**: New env vars added to `.env.example`
  - Check: `.env.example` has all env vars used in code

### 6.2 AI Anti-Patterns

- [ ] **No over-abstraction**: No premature factories/interfaces/patterns
  - Check: Code is direct, not over-engineered
  
- [ ] **No premature optimization**: No micro-optimizations without profiling
  - Check: Code is readable first, optimized only when needed
  
- [ ] **No copy-paste blocks**: No repeated code that should be extracted
  - Check: DRY principle followed, reusable logic extracted
  
- [ ] **Fits project patterns**: Code matches existing codebase style
  - Check: Compare with similar features, ensure consistency

**AI Review Notes**: [AI mistakes caught, patterns to avoid]

---

## 7. Business Logic Review

- [ ] **Requirements met**: Code implements feature as specified in PRD/ticket
  - Check: Feature works as described in requirements
  
- [ ] **Edge cases handled**: Business rules cover unusual scenarios
  - Check: "What if user does X?" scenarios considered
  
- [ ] **Data integrity**: State transitions maintain consistency
  - Check: Database constraints prevent invalid states
  
- [ ] **Audit trail**: Critical actions logged for compliance
  - Check: Mutations logged with user ID, timestamp

**Business Logic Notes**: [Requirements gaps, clarifications needed]

---

## 8. Documentation Review

- [ ] **Code comments**: Complex logic documented inline
  - Check: Non-obvious code has explanatory comments
  
- [ ] **API documentation**: New endpoints documented (if public API)
  - Check: API docs updated with new routes
  
- [ ] **README updated**: Setup instructions reflect new dependencies
  - Check: README accurate for new environment variables, services
  
- [ ] **Changelog updated**: Notable changes added to CHANGELOG.md
  - Check: User-facing changes documented

**Documentation Notes**: [Missing docs, unclear sections]

---

## Final Checklist

- [ ] All automated checks pass (TypeScript, ESLint, tests, build)
- [ ] Security review complete, no high-risk issues
- [ ] Performance review complete, no obvious bottlenecks
- [ ] Code quality meets project standards
- [ ] Accessibility review passed (keyboard nav, screen reader, contrast)
- [ ] Tests exist and cover new code
- [ ] AI hallucinations checked and corrected
- [ ] Business requirements met
- [ ] Documentation updated

**Overall Assessment**:
- ☐ **APPROVE** - Ready to merge
- ☐ **REQUEST CHANGES** - Issues must be fixed before merge
- ☐ **COMMENT** - Suggestions for improvement, but not blocking

---

## Reviewer Notes

[General comments, suggestions for improvement, praise for good code]

---

## Review Comment Prefix Protocol (Structured Feedback)

> Adopted from the roadmap.sh Code Reviews standard. Every review comment MUST carry a severity prefix so the author (or AI agent) knows exactly what blocks merge vs what is optional:

| Prefix | Meaning | Blocking? | Example |
| :--- | :--- | :---: | :--- |
| `[BLOCKER]` | Correctness, security, data-loss, or spec violation. MUST be fixed before merge. | ✅ Yes | `[BLOCKER] Raw SQL concatenation — SQL injection risk. Use parameterized query.` |
| `[BUG]` | Logic error or edge-case failure confirmed by a test. | ✅ Yes | `[BUG] Off-by-one in pagination; page 2 skips row 21.` |
| `[SECURITY]` | Vulnerability or missing validation. | ✅ Yes | `[SECURITY] Endpoint accepts unvalidated payload; add Zod parse.` |
| `[PERF]` | N+1 query, unbounded memory, or inefficiency. | ⚠️ Usually | `[PERF] N+1 query in loop; eager-load relations.` |
| `[SUGGESTION]` | Better approach, but current code is acceptable. | ❌ No | `[SUGGESTION] Extract this into a shared helper.` |
| `[NIT]` | Cosmetic / style / naming preference. NOT critical. | ❌ No | `[NIT] Rename `d` to `discountAmount`.` |
| `[QUESTION]` | Genuine clarification request, not a demand. | ❌ No | `[QUESTION] Why is this retry capped at 3?` |
| `[PRAISE]` | Reinforce good practice (morale + learning). | ❌ No | `[PRAISE] Excellent idempotency guard here.` |

### Review Philosophy Rules
1. **Seek continuous improvement, not perfection**: Do not block a PR for `[NIT]`/`[SUGGESTION]` items. Only `[BLOCKER]`/`[BUG]`/`[SECURITY]` block merge.
2. **Style guide is the authority**: Verify against the documented style guide, never personal preference.
3. **No hanging PRs**: Resolve conflicting opinions within one business day; do not let a change sit due to disagreement.
4. **Knowledge sharing**: Review code in unfamiliar areas to spread cross-functional understanding.

---

## Author Self-Review Protocol (BEFORE requesting review)

> The author (human or AI agent) MUST complete this self-review and only then hand off to the reviewer. This mirrors roadmap.sh "Post Development (Author)" stage.

- [ ] Re-read the full diff line-by-line before submitting.
- [ ] Confirm the change is complete: tests written, docs updated, no `[BLOCKER]` left unaddressed.
- [ ] Verify it runs in a local/dev environment (not just "compiles").
- [ ] Confirm adherence to `AGENTS.md` and the project style guide.
- [ ] Note any performance, security, or scalability concerns for the reviewer.
- [ ] PR includes: clear title, description, screenshots (UI), config changes, and linked issue.

---

## Actions Required (if REQUEST CHANGES)

1. [Action item 1]
2. [Action item 2]
3. [Action item 3]

---

**Review completed by**: [Your Name]  
**Date**: [YYYY-MM-DD]  
**Time spent**: [minutes]
