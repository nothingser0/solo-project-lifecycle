# AI Prompt Library

> Reusable prompt templates for AI-assisted development. Copy, customize, and iterate.

**Project**: [Project Name]  
**Created**: [Date]  
**Last Updated**: [Date]

---

## How to Use This Library

1. **Copy the template** that matches your task
2. **Fill in bracketed placeholders** [like this] with your specifics
3. **Paste into AI tool** (Cursor, Claude Code, ChatGPT)
4. **Iterate**: If output is wrong, refine prompt and save improved version
5. **Track success rate**: Mark prompts that consistently work well

**Success Indicators**:
- ⭐⭐⭐ Consistently produces production-ready code
- ⭐⭐ Usually works, requires minor fixes
- ⭐ Needs significant editing

---

## Component Generation

### Template 1: Data Table Component ⭐⭐⭐

```text
Create a data table component for [entity name] with:

Data:
- Columns: [col1, col2, col3...]
- Data source: GET /api/[endpoint]
- Type definition: [paste TypeScript type]

Features:
- Column sorting (asc/desc)
- Search filter by [field]
- Pagination (20 items/page)
- Row actions: Edit, Delete (with confirmation)
- Loading skeleton
- Empty state with CTA button

Tech: Next.js 15 App Router, Tailwind, TanStack Table v8, React Query

File structure:
- components/docs/modules/[Entity]Table.tsx
- types/[entity].ts (if new types needed)

Use design tokens from DESIGN.md (Zinc colors, Inter font, 1px borders)
```

**When to use**: Displaying lists of entities (users, products, orders, documents)  
**Success rate**: 85% - Usually works first try, may need pagination logic tweaking

---

### Template 2: Form with Validation ⭐⭐⭐

```text
Create a form for [action: creating/editing] [entity] with:

Fields:
- [field1]: text input, required, min 3 chars
- [field2]: email input, required, valid email format
- [field3]: select dropdown, options: [Option A, Option B, Option C]
- [field4]: file upload, accept: .pdf/.docx, max size: 10MB
- [field5]: textarea, optional, max 500 chars

Validation:
- Use Zod schema for validation
- Show inline error messages below each field
- Disable submit button until form is valid
- Client-side validation on blur

Submission:
- Method: POST to /api/[endpoint]
- Show loading spinner in submit button during request
- On success: Show toast notification, redirect to [page]
- On error: Display API error message above form
- Reset form after successful submission

Tech: Next.js 15, React Hook Form v7, Zod v3, Sonner toast

File: components/docs/modules/[Entity]Form.tsx
```

**When to use**: Any create/edit form  
**Success rate**: 90% - AI excellent at form boilerplate

---

### Template 3: Modal Dialog ⭐⭐

```text
Create a modal dialog component:

Trigger: [button text/icon]
Title: [modal title]
Content: [description or form]
Actions:
- Cancel button (secondary, closes modal)
- [Primary action] button (primary color, calls [function])

Behavior:
- Close modal on backdrop click
- Close modal on Escape key press
- Focus trap inside modal (tab cycles through elements)
- Animate: fade in backdrop, slide up content
- Disable body scroll when open
- Return focus to trigger after close

Accessibility:
- role="dialog"
- aria-labelledby pointing to title
- aria-describedby pointing to description
- Manage focus correctly

Tech: Radix UI Dialog, Tailwind, Framer Motion

File: components/docs/modules/[Name]Modal.tsx
```

**When to use**: Confirmation dialogs, quick edit forms  
**Success rate**: 70% - AI often misses focus management

---

## API Route Handlers

### Template 4: REST API Endpoint ⭐⭐⭐

```text
Create Next.js API route handler:

Endpoint: [METHOD] /api/[path]
Auth: Requires [user session / API key / public]
Required role: [admin / user / any authenticated]

Request:
- Method: [GET/POST/PATCH/DELETE]
- Body schema (Zod):
  {
    field1: z.string().min(3),
    field2: z.number().positive(),
    field3: z.enum(['A', 'B', 'C']).optional()
  }

Business Logic:
1. [Step 1: e.g., validate user owns resource]
2. [Step 2: e.g., check business rule]
3. [Step 3: e.g., create/update database record]
4. [Step 4: e.g., trigger side effect]

Database:
- Model: [Prisma model name]
- Operation: [create/findUnique/update/delete]
- Relations to include: [related models]

Response:
Success (200/201):
{
  data: [shape],
  message: "Success message"
}

Error responses:
- 400: Validation error (return Zod errors)
- 401: Unauthorized (missing/invalid auth)
- 403: Forbidden (insufficient permissions)
- 404: Resource not found
- 409: Conflict (e.g., duplicate email)
- 500: Internal server error

File: app/api/[path]/route.ts
```

**When to use**: CRUD endpoints, business logic APIs  
**Success rate**: 85% - Strong pattern, AI handles well

---

### Template 5: Database Query ⭐⭐

```text
Write Prisma query to:

Goal: [describe what data to fetch]
Model: [Prisma model name]

Filters:
- [field] equals [value]
- [field] contains [search term] (case-insensitive)
- [field] in [array of values]
- [field] greater than [date/number]
- AND/OR conditions: [complex filters]

Relations:
- Include: [related model 1], [related model 2]
- Select specific fields from relations: [list fields]

Sorting:
- Order by [field] [asc/desc]
- Secondary sort: [field2] [asc/desc]

Pagination:
- Skip: [offset]
- Take: [limit]

Return type: Define TypeScript type for query result

Error handling: Wrap in try/catch, return null on not found, throw on unexpected errors
```

**When to use**: Complex queries, queries with relations  
**Success rate**: 75% - AI sometimes generates inefficient queries (review for N+1)

---

## Refactoring

### Template 6: Extract Custom Hook ⭐⭐⭐

```text
Refactor this component to extract reusable logic into a custom React hook:

Current component code:
[paste component code]

Logic to extract:
- State management: [list state variables]
- Side effects: [describe useEffect logic]
- Event handlers: [list functions]
- API calls: [describe fetch/mutation logic]

Hook signature:
Hook name: use[FeatureName]
Parameters: [input params]
Return value: { 
  data: [type],
  loading: boolean,
  error: Error | null,
  [action1]: () => void,
  [action2]: (param: Type) => Promise<void>
}

Usage example:
Show how component would use the hook after extraction

Files:
- hooks/use-[feature-name].ts (hook implementation)
- components/docs/modules/[Component].tsx (refactored to use hook)
```

**When to use**: Repeated logic across components, testing complex logic  
**Success rate**: 90% - AI excellent at extraction

---

### Template 7: Performance Optimization ⭐⭐

```text
Optimize this code for performance:

Current code:
[paste code]

Performance issue:
- Problem: [describe: slow render, excessive re-renders, memory leak, slow query]
- Current metric: [e.g., 2.5s load time, 500ms render time]
- Target metric: [e.g., <500ms load time, <100ms render time]

Constraints:
- Must maintain exact same output/behavior
- Cannot change external API contracts
- Must remain readable (no micro-optimizations)

Apply these techniques where appropriate:
- React: useMemo, useCallback, React.memo, code splitting, lazy loading
- Database: Add indexes, optimize query (remove N+1), use select to limit fields
- Caching: Add in-memory cache, Redis cache, HTTP cache headers
- Async: Promise.all for parallel operations, avoid blocking loops

Provide:
1. Optimized code with comments explaining changes
2. Before/after performance comparison
3. Trade-offs made (if any)
```

**When to use**: Performance bottlenecks identified via profiling  
**Success rate**: 70% - AI good at obvious optimizations, misses subtle issues

---

## Testing

### Template 8: Unit Tests ⭐⭐⭐

```text
Generate Vitest unit tests for:

File: [file path]
Function/Component: [name]

Test cases:
1. **Happy path**: [describe expected behavior with valid input]
2. **Edge case 1**: [describe boundary condition]
3. **Edge case 2**: [describe unusual but valid input]
4. **Error case 1**: [describe invalid input, expected error]
5. **Error case 2**: [describe failure scenario]

Mocks:
- [dependency1]: Mock return value: [value]
- [dependency2]: Mock to throw error: [error message]
- [API call]: Mock with MSW to return [response]

Assertions:
- Verify return value/rendered output
- Check side effects (function calls, state changes)
- Validate error handling
- Test cleanup (timers, subscriptions)

Coverage target: 100% of function branches

File: [same directory]/__tests__/[name].test.ts
```

**When to use**: After implementing new utility/component  
**Success rate**: 85% - AI good at test structure, sometimes misses edge cases

---

### Template 9: Integration Test ⭐⭐

```text
Create integration test for:

User flow: [describe end-to-end journey]
Steps:
1. [Action 1: e.g., User navigates to /login]
2. [Action 2: e.g., User enters email and password]
3. [Action 3: e.g., User clicks submit]
4. [Action 4: e.g., User redirected to /dashboard]

Test setup:
- Database: Seed with [test data description]
- Auth: [Create test user / Use mock session]
- External APIs: Mock [service] to return [response]

Assertions:
- HTTP response: Status code [code], body contains [data]
- Database: Verify [table] has [expected state]
- UI: Check for [element] with [text/attribute]
- Side effects: Verify [email sent / log created / event tracked]

Cleanup:
- Delete test data from database
- Clear mocks

File: tests/integration/[feature].test.ts
```

**When to use**: Testing critical user flows  
**Success rate**: 75% - AI good at setup, sometimes misses cleanup

---

## Debugging

### Template 10: Error Analysis ⭐⭐⭐

```text
Debug this error:

Error message:
[paste full error message]

Stack trace:
[paste stack trace]

Context:
- When it happens: [user action that triggers error]
- Where: [file and line number]
- Expected behavior: [what should happen]
- Actual behavior: [what's happening instead]
- Frequency: [always / intermittent / specific conditions]

Recent changes:
[What was modified before error started appearing]

Relevant code:
[paste function/component where error occurs, max 50 lines]

Environment:
- Dev/Staging/Production
- Browser: [if frontend]
- Node version: [if backend]

Provide:
1. Root cause explanation (why error is happening)
2. Fix with code diff
3. How to prevent similar errors in future
4. Related areas to check for same bug pattern
```

**When to use**: Any error you can't solve in 10 minutes  
**Success rate**: 80% - AI very good at error analysis with full context

---

## Documentation

### Template 11: Component Documentation ⭐⭐⭐

```text
Generate documentation for this component:

Component file: [path]
Component code:
[paste component code]

Generate:
1. **Purpose**: One-line description of what component does
2. **Props**: Table with columns: Name, Type, Required, Default, Description
3. **Usage example**: Code snippet showing typical usage
4. **Variants**: List different states/modes (loading, error, empty, disabled)
5. **Accessibility**: ARIA attributes, keyboard navigation support
6. **Styling**: How to customize (className props, CSS variables)
7. **Related components**: Links to similar/complementary components

Output format:
- JSDoc comments in code file (/** ... */)
- README.md in same directory (for complex components)
```

**When to use**: Public components, component library  
**Success rate**: 90% - AI excellent at documentation

---

## Custom Prompts (Project-Specific)

### Template 12: [Your Custom Template]

```text
[Add your own prompt templates that work well for this project]
```

**When to use**: [describe use case]  
**Success rate**: [track after 5+ uses]

---

## Prompt Improvement Log

Track prompt iterations to improve success rate:

| Date | Original Prompt | Issue | Improved Prompt | Result |
|------|----------------|-------|-----------------|--------|
| 2026-09-15 | "Create user table" | Missing pagination | "Create user table with sorting, pagination (20/page), search" | ⭐⭐⭐ Works |
| 2026-09-20 | "Add auth" | Too vague | "Add JWT auth with httpOnly cookies, bcrypt hashing, Zod validation" | ⭐⭐⭐ Works |

---

## Notes

- **Update this library** when you discover new patterns that work well
- **Remove prompts** that consistently produce poor results (3+ failures)
- **Share successful prompts** with team members
- **Version control this file** to track what works over time
