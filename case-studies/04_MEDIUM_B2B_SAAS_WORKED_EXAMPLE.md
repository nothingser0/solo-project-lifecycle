# Worked Example: Medium-Scale B2B SaaS Platform

> **Type**: Hypothetical worked example (not a real project)  
> **Purpose**: Demonstrate framework usage for Medium Scale (12 weeks elapsed)  
> **Scope**: Multi-tenant SaaS with payment integration, team collaboration, admin panel

---

## Project Overview

**Hypothetical Scenario**:
A freelance developer is contracted to build a project management SaaS for small marketing agencies. The platform needs user authentication, team workspaces, task boards, file uploads, and subscription billing.

**Scale Classification**: Medium
- Duration: 12 weeks elapsed (1 developer + 1 designer part-time)
- Features: 15-20 user stories
- Complexity: Multi-tenant architecture, payment integration, real-time updates
- Team: 1 developer + 1 designer (part-time)

---

## Framework Modules Used

### Full Medium-Scale Workflow
- ✅ M01 (Idea & Feasibility) - 1 day
- ✅ M02 (Discovery & Scope) - 2 days
- ✅ M03 (Legal & SOW) - 1 day
- ✅ M04 (UI/UX Prototyping) - 5 days
- ✅ M05 (Architecture & Specs) - 3 days
- ✅ M06 (Development Execution) - 35 days (7 weeks)
- ✅ M07 (Quality Assurance) - 3 days
- ✅ M09 (UAT & Client Sign-Off) - 5 days
- ✅ M10 (Deployment & Go-Live) - 2 days
- ✅ M11 (Handover & BAST) - 1 day

**Total**: 12 weeks elapsed time (developer working full-time, designer part-time)

---

## Phase 1: Planning & Scoping (4 Days)

### Day 1: M01 - Idea & Feasibility

**IDEA_BRIEF.md Created**:
```markdown
# Project Idea: AgencyFlow

## Elevator Pitch
Project management tool specifically for marketing agencies managing client campaigns, 
with built-in time tracking, asset library, and client approval workflows.

## Core User Loop
1. Input: Agency creates project, assigns team, sets milestones
2. Process: Team updates tasks, uploads deliverables, logs time
3. Output: Client reviews deliverables, approves/requests changes

## MVP Feature
Kanban board with file attachments and @mentions for team communication

## Scale Classification: Medium
- Timeline: 12 weeks elapsed
- Features: 18 user stories
- Tech complexity: Real-time updates, file storage, payment gateway
- Team: 1 full-stack dev + 1 designer (20h/week)

## Feasibility Score: 4.2/5
- Technical: 4/5 (standard stack, proven patterns)
- Market: 5/5 (validated demand from 3 existing clients)
- Operational: 4/5 (manageable scope)
- Financial: 4/5 (client pre-paid 50% milestone)
```

**Key Decisions**:
- Tech stack: Next.js 15 + Supabase + Stripe
- Deployment: Vercel (frontend) + Supabase (backend)
- File storage: Supabase Storage (5GB included)

---

### Days 2-3: M02 - Discovery & Scope

**SCOPE_STATEMENT.md Sections**:

**In-Scope Features**:
1. User authentication (email/password, magic link)
2. Workspace management (create, invite members, roles)
3. Project CRUD (name, description, status, due date)
4. Kanban boards (3 default columns: To Do, In Progress, Done)
5. Task cards (title, description, assignee, attachments, comments)
6. File uploads (images, PDFs, max 10MB per file)
7. Team @mentions in comments
8. Time tracking (manual start/stop timer per task)
9. Client portal (view-only access to assigned projects)
10. Subscription billing (Stripe - 3 tiers: Free, Pro, Agency)
11. Admin dashboard (user management, subscription status)

**Out-of-Scope** (Explicitly Excluded):
- ❌ Calendar/Gantt chart view (Phase 2)
- ❌ Integrations (Slack, Google Drive) (Phase 2)
- ❌ Custom fields/workflows (Phase 2)
- ❌ Mobile app (web responsive only)
- ❌ Video/audio files (images/PDFs only)

**Assumptions**:
- Client provides brand assets (logo, color palette) by Day 5
- Designer delivers Figma mockups by Day 10
- Stripe account approved within 3 business days
- No legacy data migration needed

**Success Criteria**:
- Agency can manage 10 concurrent projects with 5 team members
- Client can review/approve deliverables without email
- Payment processing succeeds 99.5% of attempts
- Page load time <2s on 3G connection

---

### Day 4: M03 - Legal & SOW

**SOW_CONTRACT.md Key Terms**:

**Payment Schedule**:
- Milestone 1 (50%): Upon scope sign-off (Day 4) ✅
- Milestone 2 (30%): Beta deployment to staging (Week 8)
- Milestone 3 (20%): Production go-live + 7-day warranty (Week 10)

**Deliverables**:
1. Deployed production application (agencyflow.app)
2. Admin credentials + user documentation
3. Source code repository access (GitHub)
4. Database backup + restore script
5. 30-day warranty (bug fixes, no new features)

**Change Request Process**:
- Up to 3 minor changes included (e.g., button copy, color tweaks)
- Major changes (new features) billed separately at $100/hour

---

## Phase 2: Design & Architecture (8 Days)

### Days 5-9: M04 - UI/UX Prototyping

**DESIGN.md Design System**:

**Colors**:
- Primary: Indigo-600 (brand color)
- Secondary: Slate-700
- Success: Green-500
- Warning: Amber-500
- Error: Red-500

**Typography**:
- Headings: Inter (Google Fonts)
- Body: System font stack

**Components** (Tailwind + shadcn/ui):
- Buttons: 3 variants (primary, secondary, ghost)
- Cards: Elevated shadow for project cards
- Modals: Center overlay with backdrop blur
- Forms: Floating labels, inline validation

**Figma Deliverables** (by designer):
- Landing page (hero, features, pricing)
- Dashboard (project grid, recent activity)
- Kanban board (3-column layout)
- Task modal (form with file upload zone)
- Client portal (simplified view)

---

### Days 10-12: M05 - Architecture & Specs

**FSD.md Database Schema** (Supabase/PostgreSQL):

```sql
-- Users (managed by Supabase Auth)
profiles (
  id UUID PRIMARY KEY REFERENCES auth.users,
  full_name TEXT,
  avatar_url TEXT,
  role TEXT CHECK (role IN ('owner', 'member', 'client'))
)

-- Workspaces (multi-tenancy)
workspaces (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  owner_id UUID REFERENCES profiles,
  subscription_tier TEXT CHECK (tier IN ('free', 'pro', 'agency')),
  stripe_customer_id TEXT
)

workspace_members (
  workspace_id UUID REFERENCES workspaces,
  user_id UUID REFERENCES profiles,
  role TEXT CHECK (role IN ('admin', 'member', 'client')),
  PRIMARY KEY (workspace_id, user_id)
)

-- Projects
projects (
  id UUID PRIMARY KEY,
  workspace_id UUID REFERENCES workspaces,
  name TEXT NOT NULL,
  description TEXT,
  status TEXT CHECK (status IN ('active', 'paused', 'completed')),
  due_date DATE,
  created_at TIMESTAMP DEFAULT NOW()
)

-- Tasks
tasks (
  id UUID PRIMARY KEY,
  project_id UUID REFERENCES projects ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  column TEXT CHECK (column IN ('todo', 'in_progress', 'done')),
  assignee_id UUID REFERENCES profiles,
  position INTEGER,
  created_at TIMESTAMP DEFAULT NOW()
)

-- Comments
comments (
  id UUID PRIMARY KEY,
  task_id UUID REFERENCES tasks ON DELETE CASCADE,
  user_id UUID REFERENCES profiles,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
)

-- File Attachments
attachments (
  id UUID PRIMARY KEY,
  task_id UUID REFERENCES tasks ON DELETE CASCADE,
  file_name TEXT NOT NULL,
  file_url TEXT NOT NULL,
  file_size INTEGER,
  uploaded_by UUID REFERENCES profiles,
  created_at TIMESTAMP DEFAULT NOW()
)

-- Time Tracking
time_entries (
  id UUID PRIMARY KEY,
  task_id UUID REFERENCES tasks,
  user_id UUID REFERENCES profiles,
  started_at TIMESTAMP NOT NULL,
  ended_at TIMESTAMP,
  duration_seconds INTEGER
)
```

**Row-Level Security (RLS) Policies**:
```sql
-- Users can only see workspaces they're members of
CREATE POLICY "workspace_access" ON workspaces
  FOR SELECT USING (
    id IN (
      SELECT workspace_id FROM workspace_members 
      WHERE user_id = auth.uid()
    )
  );

-- Tasks visible to workspace members only
CREATE POLICY "task_access" ON tasks
  FOR SELECT USING (
    project_id IN (
      SELECT id FROM projects WHERE workspace_id IN (
        SELECT workspace_id FROM workspace_members WHERE user_id = auth.uid()
      )
    )
  );
```

**API Routes** (Next.js App Router):
```
/api/workspaces
  GET    - List user's workspaces
  POST   - Create workspace

/api/workspaces/[id]/projects
  GET    - List projects
  POST   - Create project

/api/projects/[id]/tasks
  GET    - List tasks (with filters: column, assignee)
  POST   - Create task
  PATCH  - Update task (move column, reassign)
  DELETE - Delete task

/api/tasks/[id]/comments
  GET    - List comments
  POST   - Add comment (with @mention notifications)

/api/tasks/[id]/attachments
  POST   - Upload file (Supabase Storage)
  DELETE - Remove file

/api/stripe/create-checkout
  POST   - Create Stripe checkout session

/api/stripe/webhook
  POST   - Handle subscription events
```

---

## Phase 3: Development (35 Days)

### Weeks 1-2: Backend Foundation (M06 Section 3)

**Days 13-19**: Database setup, auth, RLS policies
- Supabase project created
- Migrations applied
- RLS policies tested
- Auth flow implemented (magic link + password)

**Days 20-26**: Core API routes
- Workspace CRUD
- Project CRUD
- Task CRUD with position sorting
- Comment system with @mention parsing

---

### Weeks 3-4: Frontend UI (M06 Section 4)

**Days 27-33**: Dashboard + Kanban
- Dashboard layout (sidebar + main content)
- Project grid (card view)
- Kanban board (react-beautiful-dnd for drag-drop)
- Task modal (form with file upload)

**Days 34-40**: Collaboration Features
- Real-time comments (Supabase Realtime subscriptions)
- @mention autocomplete
- File upload (with progress bar)
- Time tracking UI (start/stop timer)

---

### Weeks 5-6: Payment Integration (M06 Section 5)

**Days 41-47**: Stripe Integration
- Pricing page (3 tiers: Free, Pro $29/mo, Agency $99/mo)
- Stripe Checkout session creation
- Webhook handler (subscription.created, subscription.updated)
- Subscription status in dashboard

**Days 48-54**: Client Portal
- Simplified view (no edit permissions)
- Client invite flow (email invitation)
- Read-only task board

---

### Week 7: Polish & Testing (M06 Section 9)

**Days 55-61**: Final touches
- Loading states (skeleton screens)
- Error boundaries
- Toast notifications (sonner)
- Responsive mobile layout
- Accessibility audit (keyboard navigation, ARIA labels)

---

## Phase 4: Quality Assurance (3 Days)

### Days 62-64: M07 - SIT

**Test Suites Executed**:

1. **Unit Tests** (Vitest):
   - API route handlers (200+ tests)
   - Utility functions (date formatting, @mention parsing)
   - Coverage: 87%

2. **Integration Tests**:
   - Database queries (RLS policy enforcement)
   - File upload flow (Supabase Storage)
   - Stripe webhook handling

3. **E2E Tests** (Playwright):
   - User registration → workspace creation → project setup
   - Kanban drag-drop task movement
   - Comment with @mention triggers notification
   - Checkout flow (Stripe test mode)

**Defects Found**: 12 (8 minor, 4 medium, 0 critical)
- Fixed before UAT

---

## Phase 5: Client Acceptance (5 Days)

### Days 65-69: M09 - UAT

**UAT Scenarios**:
1. Agency owner creates workspace, invites 3 team members
2. Create 2 projects with 10 tasks each
3. Assign tasks, add comments, upload deliverables
4. Client logs in, reviews tasks, leaves feedback
5. Upgrade to Pro plan via Stripe

**Client Feedback**:
- ✅ "Drag-drop works smoothly"
- ✅ "File uploads are fast"
- ⚠️ "Would like bulk task import (future phase)"
- ✅ "Client portal is exactly what we needed"

**Sign-Off**: Approved on Day 69

---

## Phase 6: Deployment (2 Days)

### Days 70-71: M10 - Production Go-Live

**Deployment Checklist**:
- ✅ Vercel production deployment
- ✅ Custom domain (agencyflow.app)
- ✅ SSL certificate (auto via Vercel)
- ✅ Environment variables configured
- ✅ Supabase production tier enabled
- ✅ Stripe live mode activated
- ✅ Database backup automated (daily)

**Monitoring**:
- Vercel Analytics enabled
- Sentry error tracking
- Uptime monitoring (UptimeRobot)

---

## Phase 7: Handover (1 Day)

### Day 72: M11 - BAST

**BAST Document Signed**:
- Deliverables confirmed
- Source code repository transferred
- Admin credentials handed over
- 30-day warranty period begins

---

## Lessons from This Worked Example

### What Worked Well
1. **Medium Scale Workflow**: Full framework prevents scope creep
2. **Supabase RLS**: Security handled at database level
3. **Stripe Integration**: Standard patterns work reliably
4. **Designer Collaboration**: Clear handoff at M04/M05 boundary

### Common Pitfalls (Avoided)
1. **Skipping M02**: Out-of-scope list prevented feature creep
2. **Skipping M03**: SOW protected against unpaid change requests
3. **Weak RLS Policies**: Multi-tenancy security critical for SaaS
4. **No UAT**: Client feedback caught 2 usability issues

### Framework Adaptation
- **Skipped M00**: Client provided requirements (no market research needed)
- **Skipped M08**: No legacy data migration
- **Skipped M12**: 30-day warranty only (no long-term maintenance contract)

---

## Hypothetical Timeline

```
Week 1-2:   Planning (M01-M03) + Design (M04)
Week 3:     Architecture (M05)
Week 4-10:  Development (M06) [7 weeks]
Week 11-12: QA (M07) + UAT (M09) + Deploy (M10) + Handover (M11)
```

**Total**: 12 weeks elapsed from idea to production handover

---

**Note**: This is a hypothetical worked example created to demonstrate Medium-Scale framework usage. It does not represent a real project and contains no actual client data, metrics, or outcomes.
