> **⚠️ DEPRECATED:** This module has moved to `references/playbooks/ai-assisted-development.md` as of 2026-10.  
> This file remains for reference but is no longer maintained. Update your links to the new location.

# Modul 06C: AI-Assisted Development & Vibe Coding Workflow

Modul ini adalah panduan praktis untuk solo developer yang menggunakan **AI coding agents** (Cursor, Windsurf, Claude Code, GitHub Copilot, v0.dev) sebagai partner coding utama. Tujuannya adalah memaksimalkan kecepatan iterasi tanpa mengorbankan kualitas kode, dengan protokol review yang jelas untuk area kritis (auth, payment, data privacy), strategi prompt engineering, dan anti-pattern AI code generation.

---

## 1. Kapan Modul 06C Digunakan?

```text
[ TIMING & TRIGGER ]

Pre-Coding Phase:     ──► Load M06C sebelum memulai M06 (Development Execution)
Mid-Development:      ──► Saat prompt AI menghasilkan code smell atau bug berulang
Refactoring Phase:    ──► Saat butuh re-architect existing codebase dengan AI
Code Review:          ──► Sebelum merge ke staging, wajib jalankan AI Code Review Protocol
```

**Activation Triggers**:
- User menyebut tool: "Cursor", "Windsurf", "Copilot", "Claude Code", "v0.dev"
- User bertanya: "bagaimana cara prompt AI untuk generate [feature]?"
- User komplain: "AI-generated code punya bug [X]"
- Project setup baru dengan AI workflow
- Team onboarding untuk AI-assisted development

---

## 2. AI Product Creation Cycle (Problem → Solution → Code)

### 2.1 Problem Definition: User Story → AI Prompt Translation

**Teknik Konversi User Story ke AI Prompt**:

| User Story (Ambiguitas Tinggi) | AI Prompt (Spesifik & Actionable) |
|--------------------------------|-------------------------------------|
| "As a user, I want to login" | "Create Next.js 14 App Router login page with email/password validation using Zod, submit to POST /api/auth/login, store JWT in httpOnly cookie, redirect to /dashboard on success, show inline error on 401" |
| "I need a dashboard" | "Create dashboard page with 4 metric cards (Total Users, Active Sessions, Revenue MTD, Conversion Rate), responsive grid layout, skeleton loading state, fetch data from GET /api/dashboard/metrics using React Query" |
| "Add file upload" | "Create file upload component with drag-drop zone, file type validation (PDF/DOCX only, max 10MB), progress bar during upload, generate presigned S3 URL via POST /api/upload/presigned, upload directly to S3, display thumbnail on success" |

**Prompt Engineering Formula (5-Part Structure)**:

```text
[1. CONTEXT]      Tech stack: Next.js 14 App Router, TypeScript, Zod, Prisma
[2. TASK]         Create user registration API endpoint
[3. CONSTRAINTS]  Must validate email uniqueness, hash password with bcrypt (12 rounds), return 409 on duplicate
[4. FORMAT]       Return Zod schema + route handler + error handling
[5. EXAMPLE]      Similar to login handler in /api/auth/login/route.ts
```

**Context Gathering Checklist (AI Window Management)**:

```markdown
## Essential Context (Always Include)
- [ ] Tech stack versions (Next.js 14, React 18, TypeScript 5.x)
- [ ] File structure conventions (from CONVENTIONS.md)
- [ ] API contract (from ARCHITECTURE.md)
- [ ] Design tokens (from DESIGN.md)
- [ ] Existing similar code (paste 1 working example)

## Optional Context (Include When Relevant)
- [ ] Database schema (Prisma models)
- [ ] Authentication flow (JWT vs session)
- [ ] Error handling pattern
- [ ] Performance constraints (must load <200ms)

## Never Include (Wastes Context Window)
- [ ] Full documentation copy-paste
- [ ] Multiple unrelated code files
- [ ] Historical conversation context
```

---

### 2.2 App Anatomy: Component Structure Prompts

**Atomic Design Hierarchy Prompt Template**:

```text
PROMPT: "Create [feature] following this structure:

/src/components/
  ui/                  # Primitives (Button, Input, Card)
  modules/             # Feature-specific (LoginForm, DocumentTable)
  layouts/             # Page shells (DashboardLayout, AuthLayout)

Rules:
- UI components: zero business logic, accept props only
- Module components: contain feature logic, call API via React Query
- Layouts: handle navigation, auth guards, loading states

Generate:
1. UI primitive if needed (e.g., FileUploader in /ui/)
2. Module component in /modules/[feature]/
3. Usage example in page.tsx
"
```

**Data Flow Decision Tree (Props vs Context vs State Management)**:

```text
┌─ Data shared across 2-3 sibling components?
│  └─ YES: Lift state to parent, pass as props
│  └─ NO: ↓
│
└─ Data needed by 5+ nested components?
   └─ YES: Use React Context (AuthContext, ThemeContext)
   └─ NO: ↓
   
   └─ Data persists across page navigations?
      └─ YES: Use Zustand/Jotai (solo dev preferred: Zustand)
      └─ NO: useState() in component
```

**File Organization Convention (Solo Dev Simplified)**:

```text
src/
├── app/                    # Next.js App Router pages
│   ├── (auth)/            # Auth layout group
│   │   └── login/page.tsx
│   └── (dashboard)/       # Dashboard layout group
│       └── page.tsx
├── components/
│   ├── ui/                # Shadcn/ui primitives
│   ├── modules/           # Feature components
│   └── layouts/           # Page layouts
├── lib/
│   ├── api.ts             # API client (fetch wrapper)
│   ├── auth.ts            # Auth utilities
│   └── validators.ts      # Zod schemas
└── types/                 # TypeScript types
```

---

### 2.3 Feature Scoping: AI-Friendly Task Breakdown

**Single-Responsibility Prompt Rule**:

```text
❌ BAD (Multi-Concern Prompt):
"Create a user profile page with edit form, avatar upload, password change, 
account deletion, and email notification settings"

✅ GOOD (Atomic Prompts):
1. "Create user profile read-only view with avatar, name, email, role"
2. "Add edit mode to profile page with Zod validation"
3. "Add avatar upload with image cropping and S3 storage"
4. "Add password change form with current password verification"
5. "Add account deletion with confirmation modal and soft-delete"
```

**Incremental Generation Strategy (Scaffold → Implement → Refine)**:

```text
PHASE 1: SCAFFOLD (AI generates structure only)
├─ File structure
├─ Component skeleton with TODO comments
├─ Type definitions
└─ API route stubs (return mock data)

PHASE 2: IMPLEMENT (AI fills logic per function)
├─ Database queries
├─ Business logic
├─ API integration
└─ Error handling

PHASE 3: REFINE (AI optimizes & polishes)
├─ Performance optimization
├─ Edge case handling
├─ Loading/empty states
└─ Accessibility (ARIA labels, keyboard nav)
```

**Verification Checkpoints (After Each AI Generation)**:

```bash
# Run after every AI code generation
pnpm tsc --noEmit           # TypeScript check
pnpm eslint --fix .         # Linting
pnpm test:affected          # Run tests for changed files
```

---

### 2.4 Tech Stack & Constraints for AI Compatibility

**Framework Selection Matrix (AI Generation Quality)**:

| Framework | AI Generation Quality | Best AI Tool | Notes |
|-----------|----------------------|--------------|-------|
| **Next.js App Router** | ⭐⭐⭐⭐⭐ | Cursor, v0.dev | Most training data, best patterns |
| **Next.js Pages Router** | ⭐⭐⭐⭐ | Cursor, Copilot | Legacy but well-documented |
| **Laravel + Livewire** | ⭐⭐⭐ | Claude Code | Need explicit Livewire examples |
| **Vue 3 + Nuxt** | ⭐⭐⭐ | Copilot | Less training data vs React |
| **SvelteKit** | ⭐⭐ | Claude Code | Rare patterns, need examples |

**AI Code Generation Strengths (Per Framework)**:

```typescript
// Next.js: AI excels at
✅ Server Actions (form submission without API routes)
✅ Route handlers with Zod validation
✅ Metadata generation (SEO)
✅ Image optimization with next/image

// Laravel: AI excels at
✅ Eloquent query builders
✅ Migration files
✅ Resource controllers
⚠️ Livewire: often generates Vue syntax by mistake
```

**Dependency Constraint Strategy**:

```json
// package.json - Pin versions to prevent AI suggesting deprecated packages
{
  "dependencies": {
    "next": "14.2.5",           // AI might suggest 13.x deprecated patterns
    "react": "18.3.1",
    "zod": "^3.23.8",           // ^ allows minor updates
    "prisma": "5.17.0"          // Exact version for schema stability
  },
  "devDependencies": {
    "@types/node": "^20.14.12", // AI-generated types must match Node version
    "typescript": "5.5.4"
  }
}
```

**Anti-Pattern: AI Suggesting Deprecated Packages**:

```bash
# AI might hallucinate these (check before accepting):
❌ moment.js          → Use date-fns or native Intl
❌ request            → Use node-fetch or axios
❌ @prisma/cli        → Use prisma CLI directly
❌ next-auth@3.x      → Use next-auth@4.x or Auth.js
```

---

## 3. Product Development Cycle with AI

### 3.1 Prototyping: Rapid UI Generation

**v0.dev Workflow (Vercel v0)**:

```text
STEP 1: Describe UI in natural language
"Create a dashboard card showing MRR with sparkline chart, 
percentage change badge, and last updated timestamp"

STEP 2: Review generated code (React + Tailwind)
- Check responsive breakpoints
- Verify accessibility (ARIA labels)
- Ensure design token compliance

STEP 3: Iterate with refinement prompt
"Make the sparkline chart use recharts instead of canvas, 
add loading skeleton state"

STEP 4: Copy to codebase
- Paste into src/components/modules/MRRCard.tsx
- Replace hardcoded data with API call
- Add Zod validation for props
```

**Claude Artifacts Workflow (Rapid HTML Prototypes)**:

```text
USE CASE: Landing pages, marketing sites, email templates

PROMPT: "Create a landing page for [product] with:
- Hero section with headline, subheadline, CTA button
- 3-column feature grid
- Testimonial carousel
- Pricing table (3 tiers)
- Footer with social links

Style: Tailwind CSS, dark mode support, mobile-first"

OUTPUT: Single HTML file with embedded CSS/JS
→ Extract components to Next.js or use as-is for static site
```

**Component Iteration Loop (Generate → Test → Refine)**:

```text
ITERATION 1: Generate base component
AI Prompt: "Create FileUploader component with drag-drop"
Result: Basic structure, no validation

ITERATION 2: Add business logic
AI Prompt: "Add file type validation (PDF/DOCX only, max 10MB), 
show error toast on invalid file"
Result: Validation works, but UI feedback unclear

ITERATION 3: Polish UX
AI Prompt: "Add progress bar during upload, thumbnail preview after success,
retry button on failure"
Result: Production-ready component
```

**Design Token Integration Prompts**:

```text
PROMPT: "Use design tokens from DESIGN.md:
- Colors: Zinc scale (50-950), accent brand-500
- Typography: Inter font, text-sm/text-base/text-lg
- Spacing: 4px grid (space-2, space-4, space-6)
- Borders: 1px solid, rounded-md, no shadows

Generate login form following these tokens exactly."
```

**Responsive Breakpoint Specification**:

```text
PROMPT: "Make this component responsive:

Mobile (<640px):     Stack vertically, full-width buttons
Tablet (640-1024px): 2-column grid
Desktop (>1024px):   3-column grid, max-width 1200px

Use Tailwind responsive prefixes: sm:, md:, lg:"
```

---

### 3.2 Generation: AI Code Generation Best Practices

**Multi-Agent Orchestration (Cursor Composer / Windsurf Cascade)**:

```text
CURSOR COMPOSER WORKFLOW:
1. Select multiple files to modify (Cmd+Shift+L)
2. Describe change across files: "Add user role field to User model, 
   update Prisma schema, add role column to users table migration, 
   update user API response type"
3. Review diff for each file before accepting
4. Accept changes file-by-file (not all-at-once)

WINDSURF CASCADE WORKFLOW:
1. Open Cascade panel (Cmd+Shift+K)
2. Describe feature end-to-end: "Add password reset flow"
3. Cascade generates task breakdown
4. Review & approve each subtask
5. Monitor progress, intervene if hallucination detected
```

**Multi-File Generation Orchestration (Avoid Conflicts)**:

```text
ORDER OF OPERATIONS:
1. Database schema changes (Prisma schema.prisma)
2. Type definitions (types/user.ts)
3. API route handlers (app/api/users/route.ts)
4. UI components (components/modules/UserForm.tsx)
5. Page integration (app/dashboard/users/page.tsx)

RULE: Never modify same file in parallel prompts
RULE: Always run `pnpm tsc` after each file generation
```

**Code Style Consistency (ESLint/Prettier for AI Output)**:

```json
// .eslintrc.json - Enforce consistency in AI-generated code
{
  "extends": ["next/core-web-vitals", "prettier"],
  "rules": {
    "@typescript-eslint/no-explicit-any": "error",      // Block AI using 'any'
    "@typescript-eslint/no-unused-vars": "error",       // Catch dead code
    "prefer-const": "error",                            // Modern JS patterns
    "no-console": "warn",                               // Remove debug logs
    "react-hooks/exhaustive-deps": "error"              // Catch effect issues
  }
}
```

**Handling AI Hallucinations (Package Names, API Signatures)**:

```bash
# AI often invents non-existent packages or wrong imports

❌ AI suggests: import { validateEmail } from 'next/validation'
✅ Reality:    No such package, use Zod or validator.js

❌ AI suggests: import { prisma } from '@prisma/client'
✅ Reality:    import { PrismaClient } from '@prisma/client'

# Verification protocol:
pnpm why [package-name]          # Check if package exists
pnpm ls [package-name]           # Verify installed version
```

**Anti-Pattern Detection (Real-Time Feedback)**:

```text
DETECT THESE IN AI OUTPUT (reject immediately):
❌ Hardcoded secrets:       const API_KEY = "sk-proj-..."
❌ SQL concatenation:       `SELECT * FROM users WHERE id = ${userId}`
❌ Missing error handling:  const data = await fetch(url) // no try/catch
❌ Unvalidated user input:  router.push(searchParams.redirect) // XSS risk
❌ Missing loading state:   <div>{data.map(...)}</div> // no skeleton
```

---

### 3.3 Refinement: AI-Generated Code Review Checklist

**Mandatory Human Review Areas (Never Trust AI Blindly)**:

| Area | Why AI Fails | Review Checklist |
|------|--------------|------------------|
| **Authentication** | Invents insecure patterns | ✓ Password hashing (bcrypt ≥12 rounds)<br>✓ JWT secret from env, not hardcoded<br>✓ HttpOnly cookies, SameSite=Lax |
| **Authorization** | Misses RBAC edge cases | ✓ Check user.role before mutation<br>✓ Row-level security (user can only edit own data)<br>✓ Admin endpoints behind auth guard |
| **Payment Flows** | Wrong Stripe API usage | ✓ Idempotency keys on create calls<br>✓ Webhook signature verification<br>✓ Never trust client-side amount |
| **Data Deletion** | Forgets soft-delete | ✓ Set deleted_at timestamp, not DELETE<br>✓ Filter out deleted records in queries<br>✓ Scheduled hard-delete job (30 days retention) |
| **File Uploads** | Misses MIME validation | ✓ Validate file type server-side (not just extension)<br>✓ Virus scan integration (ClamAV)<br>✓ Size limit enforced (max 10MB) |

**Security Vulnerability Scan (Automated)**:

```bash
# Run after every AI code generation session
pnpm audit                           # Dependency vulnerabilities
pnpm dlx @next/lint                  # Next.js security rules
pnpm dlx eslint-plugin-security .    # Common security issues
```

**Performance Review Checklist**:

```typescript
// AI often generates N+1 queries - catch before production

❌ AI-generated code (N+1 problem):
const users = await prisma.user.findMany()
for (const user of users) {
  const posts = await prisma.post.findMany({ where: { userId: user.id } })
  console.log(user.name, posts.length)
}

✅ Human-optimized (single query):
const users = await prisma.user.findMany({
  include: { posts: true }  // Join in single query
})
users.forEach(user => console.log(user.name, user.posts.length))
```

**Accessibility Gaps (AI Often Ignores WCAG)**:

```tsx
// AI generates this (inaccessible):
<button onClick={handleDelete}>🗑️</button>

// Fix manually (accessible):
<button 
  onClick={handleDelete}
  aria-label="Delete item"
  className="focus:ring-2 focus:ring-blue-500"
>
  <TrashIcon aria-hidden="true" />
  <span className="sr-only">Delete</span>
</button>
```

**Git Commit Hygiene (Atomic Commits per AI Generation)**:

```bash
# BAD: Single commit for entire AI session
git add .
git commit -m "Added features"

# GOOD: Atomic commits per feature
git add prisma/schema.prisma prisma/migrations/*
git commit -m "feat(db): add user role enum to schema"

git add src/app/api/auth/route.ts
git commit -m "feat(auth): add role-based access control"

git add src/components/modules/AdminPanel.tsx
git commit -m "feat(ui): add admin user management panel"
```

---

### 3.4 Collaboration Testing: Pair Programming with AI

**Cursor Tab Autocomplete Workflow**:

```text
SCENARIO: Writing API route handler

1. Type function signature:
   export async function POST(request: Request) {

2. Hit Tab, AI suggests:
   const body = await request.json()
   
3. Accept, type next line:
   const validated = 
   
4. Hit Tab, AI suggests:
   const validated = userSchema.parse(body)
   
5. Continue pattern: type intent, tab for implementation
```

**Code Explanation Requests (Understanding Complex Logic)**:

```text
PROMPT: "Explain this Prisma transaction line-by-line:

await prisma.$transaction(async (tx) => {
  const order = await tx.order.create({ data: orderData })
  await tx.inventory.update({
    where: { productId: orderData.productId },
    data: { quantity: { decrement: orderData.quantity } }
  })
  return order
})

Why use transaction? What happens if inventory update fails?"

AI RESPONSE: Should explain atomicity, rollback behavior, isolation level
```

**Alternative Implementation Comparisons**:

```text
PROMPT: "Show me 3 approaches to implement user search:

1. Full-text search with PostgreSQL tsvector
2. Fuzzy search with Fuse.js client-side
3. Algolia integration

Compare: performance, cost, maintenance overhead"

→ Pick best approach based on AI analysis + your constraints
```

**Test Generation (Unit + Integration Tests)**:

```text
PROMPT: "Generate Vitest unit tests for src/lib/crypto.ts encrypt() function:

- Test successful encryption + decryption roundtrip
- Test empty input handling
- Test invalid key format error
- Test output format (IV + encrypted data + auth tag)

Use fixtures from tests/fixtures/crypto-data.json"
```

---

### 3.5 Feedback Loop: Error → Debug → Fix

**Error Message → AI Debugging Prompt Template**:

```text
TEMPLATE:
"I'm getting this error:
[paste full error message + stack trace]

Context:
- File: src/app/api/users/route.ts
- Action: Creating new user
- Expected: 201 Created response
- Actual: 500 Internal Server Error

Code:
[paste relevant function, max 50 lines]

Fix the root cause and explain why it failed."
```

**Performance Profiling → AI Optimization Prompt**:

```text
PROMPT: "This API endpoint is slow (2.5s response time):

GET /api/dashboard/stats

Code:
[paste handler]

Profiling shows:
- Database queries: 1.8s (20 queries)
- JSON serialization: 0.5s
- Network: 0.2s

Optimize to < 500ms response time. Suggest caching strategy."
```

**User Feedback → AI Feature Modification Prompt**:

```text
USER FEEDBACK: "Upload button doesn't show progress, I don't know if it's working"

PROMPT: "Enhance FileUploader component:
- Add progress bar showing upload percentage
- Show spinner during processing
- Display success checkmark when complete
- Add cancel button to abort upload mid-flight

Current code:
[paste component]"
```

**Iteration Velocity Tracking (Measure AI Productivity)**:

```markdown
## Weekly AI-Assisted Development Metrics

| Metric | Target | Actual | Notes |
|--------|--------|--------|-------|
| Features completed | 5 | 7 | AI accelerated UI generation |
| Bugs introduced | <3 | 2 | Auth bug caught in review |
| Code review rejections | <20% | 15% | AI code quality improving |
| Time saved vs manual | 40% | 55% | Boilerplate generation = huge win |
| AI suggestions accepted | >60% | 72% | Cursor autocomplete high quality |
```

---

### 3.6 Deployment: AI-Assisted CI/CD

**GitHub Actions Generation**:

```text
PROMPT: "Generate GitHub Actions workflow for Next.js app:

Trigger: Push to main branch
Steps:
1. Checkout code
2. Setup Node.js 20
3. Install dependencies (pnpm)
4. Run TypeScript check
5. Run ESLint
6. Run Vitest tests
7. Build production
8. Deploy to Vercel

Secrets: VERCEL_TOKEN, VERCEL_ORG_ID, VERCEL_PROJECT_ID

Save to .github/workflows/deploy.yml"
```

**Environment Variable Management**:

```bash
# AI generates .env.example from code analysis

PROMPT: "Scan codebase and generate .env.example with all required env vars:
- Database connections
- API keys (Stripe, S3)
- Auth secrets
- Feature flags

Add comments explaining each variable."

OUTPUT:
# Database
DATABASE_URL="postgresql://user:pass@localhost:5432/myapp"

# Authentication
JWT_SECRET="change-me-in-production"  # openssl rand -base64 32
SESSION_COOKIE_NAME="__session"

# Storage
S3_BUCKET="uploads"
S3_REGION="us-east-1"
S3_ACCESS_KEY_ID="AKIA..."
S3_SECRET_ACCESS_KEY="secret"
```

**Rollback Protocol**:

```bash
# AI generates rollback script

PROMPT: "Create rollback script for Vercel deployment:
1. List last 5 deployments
2. Prompt user to select version
3. Promote selected deployment to production
4. Verify health check endpoint
5. Send Slack notification

Save to scripts/rollback.sh"
```

**Post-Deployment Monitoring Prompt**:

```text
PROMPT: "Analyze last 100 Sentry errors and suggest fixes:

Filter:
- Environment: production
- Time range: last 24 hours
- Min occurrences: 5

For each error group:
1. Root cause analysis
2. Suggested fix (code diff)
3. Priority (P0/P1/P2)
4. Estimated fix time

Output as markdown table."
```

---

## 4. AI Tool Comparison Matrix

| Tool | Pricing | Context Window | Best Use Case | Solo Dev Verdict |
|------|---------|----------------|---------------|------------------|
| **Cursor** | $20/mo (Pro) | 200K tokens | Full-stack refactoring, multi-file edits | ⭐⭐⭐⭐⭐ Best all-rounder |
| **Windsurf** | $10/mo (Pro) | 128K tokens | Sequential task automation (Cascade) | ⭐⭐⭐⭐ Great for structured work |
| **GitHub Copilot** | $10/mo | 8K tokens | Inline autocomplete, single-function logic | ⭐⭐⭐ Good for boilerplate |
| **Codeium** | Free (unlimited) | 50+ languages | Budget-conscious developers, Copilot alternative | ⭐⭐⭐⭐ Best free option |
| **Claude Code (via API)** | $3-15/mtask | 200K tokens | Architecture decisions, code reviews | ⭐⭐⭐⭐ Best for planning |
| **v0.dev** | $20/mo (Pro) | N/A (UI only) | React component prototyping | ⭐⭐⭐⭐⭐ Fastest UI iteration |
| **ChatGPT Code Interpreter** | $20/mo | 128K tokens | Data analysis, script generation | ⭐⭐⭐ Not IDE-integrated |

**Recommended Stack per Budget**:

```text
FREE TIER ($0/mo):
- VS Code + GitHub Copilot Free (limited suggestions)
- ChatGPT Free for debugging help
- v0.dev Free (2 generations/day)

SOLO DEV STARTER ($20/mo):
- Cursor Pro ($20/mo) - covers 90% of needs
- v0.dev Free for UI prototypes

SOLO DEV PRO ($40/mo):
- Cursor Pro ($20/mo) - main coding
- v0.dev Pro ($20/mo) - unlimited UI generation
- Claude API ($5-10/mo) - architecture reviews

AGENCY/TEAM ($60+/mo):
- Cursor Teams ($40/mo per seat)
- v0.dev Pro ($20/mo)
- Windsurf Pro ($10/mo) - for junior devs
```

**When to Use Which Tool**:

| Task | Tool | Reason |
|------|------|--------|
| Scaffold new Next.js project | Cursor Composer | Multi-file generation |
| Generate dashboard UI | v0.dev | Visual iteration speed |
| Debug Prisma query | Cursor Chat | Codebase context awareness |
| Refactor 10+ files | Cursor Composer | Atomic cross-file changes |
| Explain complex algorithm | Claude Code | Best reasoning ability |
| Autocomplete boilerplate | Copilot Tab | Fastest inline suggestions |
| Plan system architecture | Claude Code | Long-form analysis |
| Generate API docs | Cursor Chat | Can read all route files |

---

## 5. AI Code Review Protocol (Mandatory Gates)

**Pre-Merge Checklist (Run Before Every PR)**:

```bash
#!/bin/bash
# scripts/pre-merge-ai-review.sh

echo "🔍 Running AI Code Review Protocol..."

# 1. Type Safety
pnpm tsc --noEmit || { echo "❌ TypeScript errors"; exit 1; }

# 2. Linting
pnpm eslint . --max-warnings 0 || { echo "❌ ESLint warnings"; exit 1; }

# 3. Security Scan
pnpm audit --audit-level=high || { echo "⚠️ Security vulnerabilities"; }

# 4. Tests
pnpm test --run || { echo "❌ Tests failed"; exit 1; }

# 5. Build Check
pnpm build || { echo "❌ Build failed"; exit 1; }

echo "✅ All checks passed"
```

**Security Review Checklist (AI-Generated Code)**:

| Check | Pass Criteria | How to Verify |
|-------|---------------|---------------|
| **No hardcoded secrets** | No API keys, passwords, tokens in code | `git diff \| grep -E "(password\|secret\|api.?key)" -i` |
| **Input validation** | All user input validated with Zod | Search for `request.json()` without `.parse()` |
| **SQL injection safe** | No string concatenation in queries | Search for template literals in Prisma queries |
| **XSS prevention** | User content escaped/sanitized | Check `dangerouslySetInnerHTML` usage |
| **CSRF protection** | POST endpoints validate CSRF token | Check middleware for token validation |
| **Auth checks** | Protected routes check user session | Search for API routes without auth guard |

**Performance Red Flags (Reject AI Code If)**:

```typescript
// ❌ N+1 Query Pattern
for (const user of users) {
  await prisma.post.findMany({ where: { userId: user.id } })
}

// ❌ Blocking Loop
for (const item of items) {
  await processItem(item)  // Serial processing
}

// ❌ No Caching
export async function GET() {
  const data = await expensiveQuery()  // Runs on every request
  return Response.json(data)
}

// ❌ Memory Leak
useEffect(() => {
  const interval = setInterval(() => { ... }, 1000)
  // Missing cleanup
}, [])
```

**Accessibility Audit (AI Often Misses)**:

```bash
# Run automated accessibility scan
pnpm dlx @axe-core/cli http://localhost:3000

# Manual checks:
# 1. Keyboard navigation (Tab through all interactive elements)
# 2. Screen reader test (VoiceOver on Mac, NVDA on Windows)
# 3. Color contrast (4.5:1 for text, 3:1 for UI)
# 4. Focus indicators visible
# 5. Form labels present
```

---

## 6. Prompt Library (20+ Reusable Templates)

### 6.1 Component Generation Prompts

**Template 1: Data Table with Sorting/Filtering**:

```text
Create a data table component for [entity name] with:

Data:
- Columns: [col1, col2, col3...]
- Data source: GET /api/[endpoint]
- Type definition: [paste type]

Features:
- Column sorting (asc/desc)
- Search filter by [field]
- Pagination (20 items/page)
- Row actions: Edit, Delete (with confirmation)
- Loading skeleton
- Empty state with CTA

Tech: Next.js 14, Tailwind, TanStack Table, React Query

File structure:
- components/modules/[Entity]Table.tsx
- types/[entity].ts
```

**Template 2: Form with Validation**:

```text
Create a form for [action] with:

Fields:
- [field1]: text input, required, min 3 chars
- [field2]: email input, required, valid email
- [field3]: select dropdown, options: [A, B, C]
- [field4]: file upload, accept .pdf/.docx, max 10MB

Validation:
- Use Zod schema
- Show inline errors below fields
- Disable submit until valid

Submission:
- POST to /api/[endpoint]
- Show loading spinner in button
- Toast success message
- Redirect to [page] on success
- Display API errors

Tech: Next.js 14, React Hook Form, Zod, Sonner toast
```

**Template 3: Modal Dialog**:

```text
Create a modal dialog component:

Trigger: [button/link text]
Content:
- Title: [modal title]
- Body: [description]
- Actions: [Cancel, Confirm]

Behavior:
- Close on backdrop click
- Close on Escape key
- Focus trap inside modal
- Animate enter/exit
- Confirm calls [action]

Tech: Radix UI Dialog, Tailwind, Framer Motion
```

### 6.2 API Integration Prompts

**Template 4: REST API Route Handler**:

```text
Create Next.js API route handler:

Endpoint: [METHOD] /api/[path]
Auth: Requires user session (role: [role])

Request body (Zod schema):
- field1: string
- field2: number
- field3?: boolean (optional)

Logic:
1. Validate request body
2. [business logic steps]
3. Database operation: [insert/update/delete]
4. Return response

Success response (200/201):
{
  data: [shape],
  message: "Success message"
}

Error responses:
- 400: Invalid input (Zod errors)
- 401: Unauthorized
- 404: Resource not found
- 500: Server error

File: app/api/[path]/route.ts
```

**Template 5: Database Query with Relations**:

```text
Write Prisma query to:

Goal: [description]
Model: [model name]
Relations: Include [related models]
Filters:
- [field] equals [value]
- [field] contains [search term]
- [field] greater than [date]

Sorting: Order by [field] [asc/desc]
Pagination: Skip [offset], take [limit]

Return type: [User & { posts: Post[] }]

Handle errors: Try/catch with custom error message
```

### 6.3 Refactoring Prompts

**Template 6: Extract Reusable Hook**:

```text
Refactor this component logic into a custom React hook:

Code:
[paste component code]

Extract:
- State management for [feature]
- Side effects in useEffect
- Event handlers

Hook name: use[FeatureName]
Return: { data, loading, error, [actions] }
Usage example in component

File: hooks/use-[feature-name].ts
```

**Template 7: Performance Optimization**:

```text
Optimize this code for performance:

Current code:
[paste code]

Issues:
- [describe performance problem]

Constraints:
- Must maintain same output
- Target: [metric] < [threshold]

Apply:
- Memoization (useMemo, useCallback)
- Code splitting (dynamic imports)
- Database query optimization
- Caching strategy

Show before/after comparison
```

**Template 8: Type Safety Improvements**:

```text
Improve TypeScript types for:

Code:
[paste code with 'any' types]

Requirements:
- Replace all 'any' with proper types
- Add discriminated unions where needed
- Make nullable fields explicit (T | null)
- Add JSDoc comments for complex types
- Ensure type inference works

Generate:
1. Updated code
2. New type definitions file if needed
```

### 6.4 Testing Prompts

**Template 9: Unit Test Generation**:

```text
Generate Vitest unit tests for:

File: [file path]
Function: [function name]

Test cases:
1. Happy path: [expected behavior]
2. Edge case: [scenario]
3. Error case: [invalid input]
4. Boundary: [min/max values]

Mock dependencies:
- [dependency1]: return [mock value]
- [dependency2]: throw [error]

Assertions:
- Verify return value
- Check side effects
- Validate error messages

File: [same path]/__tests__/[name].test.ts
```

**Template 10: Integration Test**:

```text
Create integration test for:

Flow: [user journey]
Steps:
1. [action 1]
2. [action 2]
3. [action 3]

Setup:
- Seed database with [test data]
- Mock external APIs: [list]

Test:
- Make request to [endpoint]
- Assert response status [code]
- Assert response body contains [data]
- Verify database state changed

Cleanup:
- Delete test data

File: tests/integration/[feature].test.ts
```

### 6.5 Debugging Prompts

**Template 11: Error Analysis**:

```text
Debug this error:

Error message:
[paste full error + stack trace]

Context:
- When: [trigger action]
- Where: [file:line]
- Expected: [behavior]
- Actual: [what happened]

Recent changes:
[what was modified before error]

Code:
[paste relevant code]

Provide:
1. Root cause explanation
2. Fix with code diff
3. How to prevent in future
```

**Template 12: Performance Bottleneck**:

```text
Investigate slow performance:

Symptom: [page/endpoint] takes [X] seconds
Expected: < [Y] seconds

Profiling data:
[paste Chrome DevTools/Network/Database logs]

Code:
[paste suspected code]

Analyze:
1. Identify bottleneck
2. Explain why it's slow
3. Suggest optimization
4. Estimate improvement

Provide benchmarks before/after
```

### 6.6 Documentation Prompts

**Template 13: API Documentation**:

```text
Generate API documentation for:

Endpoints in: [directory]

Format:
- Endpoint: [METHOD] [path]
- Description: [what it does]
- Auth: [requirements]
- Request body: [schema]
- Response: [schema]
- Error codes: [list]
- Example curl command

Output: Markdown file
File: docs/api/[domain].md
```

**Template 14: Component Documentation**:

```text
Document this component:

Component: [name]
File: [path]

Generate:
- Purpose: [one-line description]
- Props: [name, type, required, description]
- Usage example: [code snippet]
- Variants: [list different states]
- Accessibility: [ARIA attributes used]
- Related components: [list]

Output: JSDoc comments in code + README
```

### 6.7 Migration Prompts

**Template 15: Upgrade Framework Version**:

```text
Migrate from [framework] [old version] to [new version]:

Changes needed:
- API changes: [list breaking changes]
- Deprecations: [what to replace]
- New features: [what to adopt]

Files to update:
- package.json
- [config files]
- [affected components]

Show step-by-step migration plan
Highlight manual verification steps
```

**Template 16: Refactor to New Pattern**:

```text
Refactor [old pattern] to [new pattern]:

Current code: [paste]

New pattern requirements:
- [constraint 1]
- [constraint 2]

Files affected: [list]

Show:
1. Migration strategy
2. Code diff for each file
3. Rollback plan if issues
4. Test cases to verify
```

### 6.8 Architecture Prompts

**Template 17: System Design**:

```text
Design architecture for [feature]:

Requirements:
- Users: [scale]
- Data: [volume]
- Latency: < [threshold]
- Constraints: [budget, tech stack]

Provide:
1. High-level architecture diagram (text/ASCII)
2. Database schema
3. API endpoints
4. Tech stack recommendations
5. Scalability considerations
6. Cost estimate
```

**Template 18: Security Review**:

```text
Security audit for [feature]:

Code: [paste or describe]

Review:
- Authentication: [mechanism]
- Authorization: [RBAC/ABAC]
- Input validation: [where/how]
- Output encoding: [XSS prevention]
- Sensitive data: [encryption at rest/transit]
- OWASP Top 10: [check each]

Output:
- Vulnerabilities found (severity: high/med/low)
- Fix recommendations with code
- Secure coding checklist
```

### 6.9 DevOps Prompts

**Template 19: CI/CD Pipeline**:

```text
Create CI/CD pipeline for [project]:

Stages:
1. Test: [unit, integration, e2e]
2. Build: [steps]
3. Deploy: [environment]

Triggers:
- Push to [branch]
- PR opened
- Manual dispatch

Secrets: [list env vars]

Platform: [GitHub Actions/GitLab CI]

Output: .github/workflows/[name].yml
```

**Template 20: Docker Setup**:

```text
Containerize [app]:

Requirements:
- Base image: [node:20-alpine]
- Dependencies: [list]
- Build steps: [commands]
- Exposed port: [number]
- Health check: [endpoint]
- Multi-stage build for optimization

Files:
- Dockerfile
- .dockerignore
- docker-compose.yml (dev setup)

Include:
- Build command
- Run command
- Environment variables
```

---

## 7. Anti-Patterns & Red Flags

| ❌ Anti-Pattern | Why It's Bad | ✅ Correct Approach |
|----------------|--------------|---------------------|
| Accepting all AI suggestions blindly | Security holes, performance issues | Review every change, run tests |
| Over-prompting (5000-word prompt) | AI loses focus, misses key points | Break into 5 atomic prompts |
| No context window management | AI forgets early instructions | Use AGENTS.md for persistent rules |
| Copy-paste AI code without reading | Hidden bugs, doesn't fit codebase style | Read, understand, adapt to patterns |
| Using AI for critical auth/payment | AI makes subtle security mistakes | Write manually, AI assists only |
| No version control between AI changes | Can't rollback bad generations | Commit after each accepted change |
| Ignoring TypeScript errors from AI | Runtime crashes in production | Fix all `tsc` errors immediately |
| AI generates tests that always pass | False confidence | Verify tests fail when code breaks |
| Treating AI as junior dev without review | Code quality degrades | Same review rigor as human PR |
| Not learning from AI code | Skill atrophy | Study AI solutions, internalize patterns |

**Hallucination Detection Checklist**:

```bash
# Verify AI didn't invent these:

1. Package names
   pnpm ls [package]  # Check it exists

2. API methods
   # Read official docs, don't trust AI memory

3. Environment variables
   # Cross-check with .env.example

4. File paths
   ls [path]  # Verify file exists

5. Function signatures
   # Check actual import source
```

---

## 8. Integration with Other Modules

| Module | Integration Point |
|--------|-------------------|
| **M00 (Discovery)** | AI helps draft PRD from user interviews |
| **M02 (Scope)** | AI generates scope statement from requirements |
| **M04 (UI/UX)** | v0.dev generates components from DESIGN.md tokens |
| **M05 (Architecture)** | AI drafts FSD from business requirements |
| **M06 (Development)** | Main usage: AI writes code from TODO.md tasks |
| **M06B (Analytics)** | AI generates event tracking code |
| **M07 (QA/SIT)** | AI generates test cases from requirements |
| **M09 (UAT)** | AI creates UAT scenarios from user stories |
| **M10 (Deployment)** | AI generates CI/CD pipelines |
| **M13 (Operations)** | AI analyzes logs and suggests fixes |

---

## 9. Output Artifacts (Deliverables)

### Primary Deliverable: Working Codebase
- Functional features matching PRD specs
- Passing all automated tests (unit, integration)
- Zero TypeScript errors
- Passing security audit
- Accessible (WCAG AA compliant)

### Documentation Artifacts:

| Artifact | Location | Purpose |
|----------|----------|---------|
| **AI Prompt Library** | `docs/dev/AI_PROMPT_LIBRARY.md` | Reusable prompts for common tasks |
| **AI Code Review Checklist** | `docs/dev/AI_CODE_REVIEW_CHECKLIST.md` | Pre-merge review gate |
| **AI Tool Comparison** | `docs/dev/AI_TOOLS_COMPARISON.md` | When to use Cursor vs v0 vs Claude |
| **AI Session Log** | `docs/dev/ai-sessions/YYYY-MM-DD.md` | What was generated, what worked/failed |

**Template Sources**:
- `templates/04-dev-execution/AI_PROMPT_LIBRARY_TEMPLATE.md`
- `templates/04-dev-execution/AI_CODE_REVIEW_CHECKLIST_TEMPLATE.md`
- `references/technical/AI_DEVELOPMENT_TOOLS_COMPARISON.md`

---

## 10. Prinsip AI-Assisted Development Solo Developer

1. **AI as Copilot, Not Autopilot**: Review every change, understand every line before accepting.

2. **Context Window as Second Brain**: Maintain AGENTS.md with non-negotiable rules (no `any`, security patterns).

3. **Atomic Prompts Over Monoliths**: One feature per prompt. Multi-concern prompts = confused output.

4. **Security Cannot Be Delegated**: Auth, payments, data deletion = manual review mandatory.

5. **Test the Tests**: AI-generated tests must fail when code is intentionally broken.

6. **Commit Hygiene Prevents Chaos**: One atomic commit per AI generation. Rollback is cheap.

7. **Read AI Code Like Code Review**: Same scrutiny as reviewing a junior dev's PR.

8. **Learn from AI, Don't Depend on It**: Internalize patterns. AI unavailable shouldn't block you.

9. **Performance Budgets Non-Negotiable**: <200ms API response, <2s page load, regardless of AI convenience.

10. **Accessibility is Non-Optional**: AI skips ARIA labels, focus management, keyboard nav = you must add.

---

## 11. When NOT to Use AI

```text
NEVER DELEGATE TO AI (Write Manually):
❌ OAuth integration (too many security pitfalls)
❌ Payment webhooks (Stripe signature verification is critical)
❌ Database migration rollbacks (data loss risk)
❌ Encryption key management (subtle mistakes = breach)
❌ GDPR data deletion logic (legal compliance)
❌ Critical business logic with money/legal impact

AI ASSISTANCE OK (Review Carefully):
✅ CRUD API endpoints with standard patterns
✅ UI components with no business logic
✅ Form validation schemas (Zod)
✅ Database queries (Prisma with review)
✅ Test scaffolding (verify tests actually test)
✅ Documentation generation

SAFE TO AUTOMATE:
✅ TypeScript type generation
✅ Boilerplate code (configs, scaffolding)
✅ Code formatting (Prettier)
✅ Linting fixes (ESLint --fix)
✅ Import sorting
```

---

## 12. Maintenance & Skill Development

**Weekly Review Ritual (30 min)**:

```markdown
## AI-Assisted Dev Weekly Review

### What AI Generated This Week:
- [Feature 1]: [quality score 1-5]
- [Feature 2]: [quality score 1-5]

### Bugs from AI Code:
- [Bug]: [root cause], [prevention]

### Prompts That Worked Well:
- [Prompt]: [why effective]

### Prompts That Failed:
- [Prompt]: [why failed], [how to improve]

### Skills Learned:
- [Pattern AI showed me]

### Action Items:
- [ ] Update AI_PROMPT_LIBRARY.md with new template
- [ ] Add new anti-pattern to AGENTS.md
- [ ] Schedule manual practice of [skill] (avoid atrophy)
```

**Skill Atrophy Prevention**:

```text
SCHEDULE MANUAL CODING (No AI):
- 1 day/month: Build feature without AI
- Kata practice: Implement algorithms manually
- Code review others' work (pattern recognition)
- Read source code of libraries you use

GOAL: Stay sharp if AI unavailable or hallucinates
```

---

**Next Step After M06C**: Return to **Modul 06 (Development Execution)** main workflow, using AI tools to accelerate code generation while following the review protocols defined here.
