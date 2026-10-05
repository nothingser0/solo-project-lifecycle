# PM Tools Setup Guide (Jira, Linear, Notion, Productboard)

**Target Audience**: Solo developers or small teams needing project management structure without enterprise tool overhead.

**Philosophy**: Tools are servants, not masters. Pick the tool that fits your workflow, not the other way around.

**Last Updated**: 2026-09-27

---

## 1. Tool Comparison Matrix

| Feature | Jira | Linear | Notion | Productboard | Trello | Asana |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **Best For** | Complex workflows | Dev-first teams | Docs + PM hybrid | PM/product-led | Simple kanban | Task management |
| **Learning Curve** | Steep (2–3 days) | Easy (30 min) | Medium (1 day) | Medium (1–2 days) | Very easy (10 min) | Easy (30 min) |
| **Cost (Solo)** | Free (up to 10 users) | Free (unlimited) | Free (up to 10 guests) | $20/month | Free | Free (15 users) |
| **Backlog Management** | ✅ Excellent | ✅ Excellent | 🟡 Manual | ✅ Built-in | ❌ Limited | 🟡 Basic |
| **Roadmap View** | ✅ (plugin/advanced) | ✅ Native | 🟡 Manual | ✅ Native | ❌ None | 🟡 Timeline |
| **RICE Scoring** | 🟡 Custom fields | 🟡 Custom fields | ✅ Formulas | ✅ Built-in | ❌ | ❌ |
| **Integration** | ✅ (GitHub, Slack, etc.) | ✅ (GitHub, GitLab) | 🟡 Limited | 🟡 Limited | ✅ (Power-Ups) | ✅ Good |
| **Mobile App** | 🟡 Functional | ✅ Great | ✅ Great | 🟡 Basic | ✅ Great | ✅ Great |
| **Offline Mode** | ❌ No | ❌ No | ✅ Yes | ❌ No | 🟡 Limited | ❌ No |
| **Solo Dev Friendly** | ❌ Overkill | ✅ **Best** | ✅ **Best** | 🟡 For PM-heavy | ✅ Good | ✅ Good |

**Recommendation**:
- **For solo dev (technical)**: **Linear** (dev-first, clean UX, fast)
- **For solo dev (PM-heavy + docs)**: **Notion** (all-in-one, flexible)
- **For small team (2–5)**: **Linear** or **Jira Free**
- **For product manager role**: **Productboard** (if budget allows)

---

## 2. Linear Setup (Recommended for Solo Dev)

### Why Linear?
- Built by developers, for developers (keyboard shortcuts, CLI, fast UX)
- Native GitHub/GitLab integration (auto-link commits to issues)
- Clean prioritization (P0/P1/P2/P3 built-in)
- Roadmap + Cycles (sprint planning) native
- Free for unlimited users (no credit card required)

### 2.1 Initial Setup (15 minutes)

#### Step 1: Create Account
1. Go to [linear.app](https://linear.app)
2. Sign up with Google/GitHub (instant SSO)
3. Create workspace: `[YourProjectName]`

#### Step 2: Create Project
1. Click **"New Project"** in sidebar
2. Name: `[Product Name] Development`
3. Choose icon (optional but makes sidebar cleaner)
4. Set default template: **Scrum** (includes sprint cycles)

#### Step 3: Configure Issue States
Linear uses **workflow states**, not status dropdown.

**Default states** (keep these):
- **Triage**: New issues land here
- **Backlog**: Prioritized, ready for sprint
- **Todo**: Current sprint, not started
- **In Progress**: Actively working
- **Done**: Completed
- **Canceled**: Won't do

**Customization (optional)**:
- Add **"Blocked"** state (for dependency issues)
- Add **"In Review"** (for peer review step)

To customize: **Settings → Projects → [Your Project] → Workflow**

#### Step 4: Set Up Labels
Labels = tags for categorization.

**Suggested labels** (add via **Settings → Labels**):
- `#now` (green) — Now phase roadmap
- `#next` (yellow) — Next phase roadmap
- `#later` (gray) — Later backlog
- `bug` (red) — Bug fix
- `feature` (blue) — New feature
- `tech-debt` (orange) — Refactoring/cleanup
- `p0` / `p1` / `p2` / `p3` (use Priority field instead, but labels are visual)

#### Step 5: Create Cycles (Sprints)
1. Go to **Settings → Projects → [Your Project] → Cycles**
2. Enable cycles: **On**
3. Duration: **2 weeks** (recommended for solo dev — short feedback loop)
4. Start day: **Monday**
5. Auto-create next cycle: **Yes**

**First cycle**: Linear auto-creates `Cycle 1` starting next Monday.

#### Step 6: Set Up Templates (Optional but Recommended)
Templates = pre-filled issue format for consistency.

**Bug Report Template**:
1. Go to **Settings → Templates → New Template**
2. Name: `Bug Report`
3. Content:
```
## Bug Description
[Describe what went wrong]

## Steps to Reproduce
1. Go to...
2. Click on...
3. See error

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
- Browser: [Chrome 120]
- OS: [macOS Sonoma]
- User: [user@example.com or "all users"]

## Screenshots
[Attach if relevant]
```

**User Story Template**:
1. **Settings → Templates → New Template**
2. Name: `User Story`
3. Content:
```
## User Story
As a [persona],
I want to [action],
So that [value].

## Acceptance Criteria
- [ ] Given [context], when [action], then [result]
- [ ] Given [context], when [action], then [result]
- [ ] Edge case: [negative case]

## Technical Notes
[Implementation details, API endpoints, DB changes]

## Dependencies
[Blocked by / Depends on: LIN-XXX]
```

---

### 2.2 Daily Workflow with Linear

#### Creating an Issue
1. Press `C` (keyboard shortcut) or click **"New Issue"**
2. Title: Short, action-oriented (e.g., "Add password reset flow")
3. Description: Use template (select from dropdown)
4. **Priority**: P0 (Must Have), P1 (Should), P2 (Could), P3 (Won't)
5. **Estimate**: Use story points (1, 2, 3, 5, 8, 13) or hours
6. **Labels**: Add `#now`, `feature`, etc.
7. **Assignee**: Yourself (auto-assigned for solo dev)
8. **Cycle**: Assign to current cycle (e.g., `Cycle 1`)
9. Press `Cmd+Enter` to create

#### Moving Issues Through Workflow
- Drag issue to **"In Progress"** when you start coding
- Press `Cmd+Shift+S` to change state (keyboard shortcut)
- Mark **"Done"** when merged to main branch

#### Linking to Code (GitHub Integration)
1. **Settings → Integrations → GitHub** (one-time setup)
2. Connect your repo
3. In commit message, reference issue: `git commit -m "feat(auth): add password reset (LIN-123)"`
4. Linear auto-links commit to issue, shows in issue activity

#### Sprint Planning (Start of Cycle)
1. Go to **Cycles → Current Cycle**
2. Drag issues from **Backlog** to **Current Cycle**
3. Check total story points (aim for 15–30 SP for solo dev per 2-week cycle)
4. Press `Cmd+K` → **"Start Cycle"** (moves all issues to Todo state)

#### Sprint Review (End of Cycle)
1. Go to **Cycles → [Completed Cycle]**
2. Linear auto-calculates:
   - Velocity (story points completed)
   - Completion rate (% of issues done)
3. Review what got Done vs. Canceled/Pushed
4. Adjust estimates for next cycle

---

### 2.3 Roadmap View in Linear

1. Click **"Roadmap"** in left sidebar
2. View shows: **Now / Next / Later / Backlog**
3. Drag issues between columns to reprioritize
4. Add **Projects** for epics:
   - Create **Project**: "User Authentication"
   - Add issues to project (multi-select, press `Cmd+Shift+P`)
   - Projects show progress % in roadmap

**Tips**:
- Use **Projects** for epics (2–4 week efforts)
- Use **Labels** (`#now`, `#next`, `#later`) for phases
- Update roadmap weekly (Friday afternoon review)

---

### 2.4 Custom Fields (for RICE Scoring)

Linear doesn't have RICE built-in, but you can add custom fields:

1. **Settings → Projects → [Your Project] → Custom Fields**
2. Add field: **"RICE Score"** (Number type)
3. Add fields: **"Reach"**, **"Impact"**, **"Confidence"**, **"Effort"** (all Number type)

**Workflow**:
- Fill RICE components manually
- Calculate RICE score in external spreadsheet
- Paste result into **RICE Score** field
- Sort backlog by RICE Score (use filters)

*Limitation*: Linear can't auto-calculate formulas in custom fields (unlike Notion). If you need auto-calc, use Notion or spreadsheet.*

---

### 2.5 Linear CLI (Advanced, Optional)

Install: `npm install -g @linear/cli` or `brew install linear`

**Useful commands**:
```bash
# Create issue from terminal
linear issue create --title "Fix login bug" --priority 0 --team DEV

# List your issues
linear issue list --assignee @me --state "In Progress"

# Update issue state
linear issue update LIN-123 --state "Done"

# Open issue in browser
linear issue open LIN-123
```

**Use case**: Quick issue creation without leaving terminal/IDE.

---

## 3. Notion Setup (Alternative: Docs + PM Hybrid)

### Why Notion?
- All-in-one: Docs + Roadmap + Backlog + Knowledge Base
- Powerful databases with formulas (auto-calculate RICE)
- Great for solo devs who need a centralized workspace
- Free for solo use (up to 10 guest collaborators)

### 3.1 Initial Setup (30 minutes)

#### Step 1: Create Workspace
1. Go to [notion.so](https://notion.so)
2. Sign up (Google/Apple SSO)
3. Create workspace: `[Your Product Name]`

#### Step 2: Create Page Structure
```
📁 [Product Name] Workspace (root)
  ├── 📄 README (project overview)
  ├── 🗺️ Product Roadmap (database)
  ├── 📋 Backlog (database, linked to Roadmap)
  ├── 🎯 OKRs (database)
  ├── ⚠️ Risk Register (database)
  ├── 📚 Documentation
  │   ├── API Docs
  │   ├── Architecture
  │   └── User Guides
  └── 📝 Meeting Notes (database)
```

---

### 3.2 Roadmap Database Setup

#### Step 1: Create Database
1. In workspace root, type `/database` → **"Table - Inline"**
2. Name: **"Product Roadmap"**

#### Step 2: Define Properties (Columns)
| Property Name | Type | Options/Formula |
| :--- | :--- | :--- |
| **Feature** | Title | (default) |
| **Phase** | Select | Now / Next / Later / Done |
| **Priority** | Select | P0 / P1 / P2 / P3 |
| **Owner** | Person | (assign to yourself) |
| **Status** | Select | Not Started / In Progress / Blocked / Done |
| **Reach** | Number | (input manually) |
| **Impact** | Number | (input manually, use 0.25/0.5/1/2/3) |
| **Confidence** | Number | (input manually, use 0.5/0.8/1.0) |
| **Effort** | Number | (input manually, person-months) |
| **RICE Score** | Formula | `prop("Reach") * prop("Impact") * prop("Confidence") / prop("Effort")` |
| **Dependencies** | Relation | (link to other features in same database) |
| **Notes** | Text | (long-form context) |

**To add formula**:
1. Click **"+"** button in table header
2. Select **"Formula"**
3. Name: `RICE Score`
4. Formula: `prop("Reach") * prop("Impact") * prop("Confidence") / prop("Effort")`
5. Done — Notion auto-calculates!

---

#### Step 3: Create Views

**View 1: Now/Next/Later Board**
1. Click **"+ Add a view"** above table
2. Select **"Board"**
3. Name: `Roadmap Board`
4. Group by: **Phase**
5. Sort by: **RICE Score** (descending)

**View 2: Priority List**
1. Add view → **Table**
2. Name: `Backlog (Prioritized)`
3. Filter: **Phase** is **Now** or **Next**
4. Sort: **RICE Score** (descending), then **Priority**

**View 3: By Owner (if team)**
1. Add view → **Board**
2. Name: `By Owner`
3. Group by: **Owner**

---

### 3.3 Backlog Database (Detailed Stories)

Option A: **Separate database** (recommended for large backlogs)
1. Create new database: **"Backlog (Stories)"**
2. Add property: **"Epic"** (Relation to Roadmap database)
3. Each story links to parent Epic

Option B: **Inline in Roadmap** (simple, for solo dev)
1. In Roadmap database, add property: **"Stories"** (Text or toggle sub-items)
2. Use Notion's toggle lists to nest stories under epics

**Recommended**: Option A for backlog > 20 items, Option B for smaller projects.

---

### 3.4 Daily Workflow with Notion

#### Adding a Feature to Roadmap
1. Open **Roadmap Board** view
2. Click **"+ New"** in **"Now"** column
3. Fill: Title, Priority, Reach/Impact/Confidence/Effort
4. RICE Score auto-calculates
5. Drag to reorder within column

#### Sprint Planning
1. Open **Backlog (Prioritized)** view
2. Top 5 items by RICE = your **"Now"**
3. Move to **"In Progress"** when you start coding

#### Linking Docs to Features
1. In Roadmap row, type `@` in **Notes** column
2. Link to relevant doc page (e.g., `@API Docs`)
3. Or embed: `/embed` → paste doc URL

---

### 3.5 Notion Templates for PM

**Template 1: User Story**
Create template button in database:
1. Click **"⋮"** (database menu) → **"New template"**
2. Name: `User Story Template`
3. Pre-fill properties: Priority = P1, Status = Not Started
4. Pre-fill content:
```
## User Story
As a [persona],
I want to [action],
So that [value].

## Acceptance Criteria
- [ ] Given...
- [ ] Given...

## Technical Notes
[Implementation details]
```

**Template 2: Bug Report**
Same steps, pre-fill with bug template (similar to Linear example).

---

### 3.6 Notion API Integration (Advanced)

Notion has REST API → You can sync with external tools (GitHub Issues, Linear, etc.)

**Example**: Auto-create Notion task when GitHub Issue opened
1. Use Zapier/Make.com (no-code automation)
2. Trigger: New GitHub Issue
3. Action: Create row in Notion Backlog database

**Use case**: Centralize PM work in Notion, but let developers use GitHub Issues.

---

## 4. Jira Setup (For Teams / Complex Workflows)

### Why Jira?
- Industry standard (most companies use it)
- Advanced workflows (custom states, automation rules)
- Powerful reporting (burndown charts, velocity tracking)
- Free for up to 10 users

### When NOT to use Jira (for solo dev):
- Overkill for simple projects (too many features)
- Slower UX than Linear (clunky UI)
- Steeper learning curve (2–3 days to get comfortable)

### 4.1 Quick Setup (30 minutes)

#### Step 1: Create Project
1. Go to [atlassian.com](https://atlassian.com/software/jira/free)
2. Sign up → Create **Scrum** project
3. Name: `[Product Name]`

#### Step 2: Configure Issue Types
**Default types** (keep these):
- **Epic**: Large feature (2–4 weeks)
- **Story**: User-facing feature (1–3 days)
- **Task**: Technical work (not user-facing)
- **Bug**: Defect

**Add custom type** (optional):
- **Settings → Issues → Issue types → Add issue type**
- Example: **"Spike"** (research/investigation task)

#### Step 3: Set Up Custom Fields (for RICE)
1. **Settings → Issues → Custom fields → Create custom field**
2. Add:
   - **Reach** (Number)
   - **Impact** (Number)
   - **Confidence** (Number)
   - **Effort** (Number)
   - **RICE Score** (Number, calculated manually or via automation)

*Jira doesn't have formulas like Notion. Use external spreadsheet or Jira automation rule (advanced).*

#### Step 4: Create Sprint
1. Go to **Backlog** view
2. Click **"Create Sprint"** button
3. Name: `Sprint 1`
4. Duration: 2 weeks
5. Start date: Monday

#### Step 5: Workflow Customization (Optional)
**Default workflow**: To Do → In Progress → Done

**Add "In Review" state**:
1. **Settings → Issues → Workflows → Edit [Default workflow]**
2. Add state: **"In Review"**
3. Add transition: **In Progress → In Review**
4. Add transition: **In Review → Done**

---

### 4.2 Daily Workflow with Jira

#### Creating an Issue
1. Click **"Create"** button (top right)
2. Issue type: **Story** / **Bug** / **Task**
3. Summary: Short title
4. Description: Use template (set up via **Settings → Issue templates**)
5. Priority: Highest / High / Medium / Low
6. Story Points: Use Fibonacci (1, 2, 3, 5, 8, 13)
7. Epic Link: Link to parent epic
8. Assignee: Yourself
9. Sprint: Add to current sprint

#### Board View (Kanban)
1. Go to **Board** view (top nav)
2. Drag issues between columns: **To Do → In Progress → Done**
3. Use **Swimlanes** to group by Epic (helpful for large backlogs)

#### Sprint Planning
1. Go to **Backlog** view
2. Drag issues from Backlog to **Sprint X**
3. Check capacity: Story points sum (aim for 15–30 SP for solo dev)
4. Click **"Start Sprint"**

#### Sprint Review (End of Sprint)
1. Click **"Complete Sprint"** button
2. Jira shows:
   - Completed vs. Incomplete issues
   - Velocity chart (story points completed)
3. Move incomplete issues to next sprint or back to backlog

---

### 4.3 Jira Reports

**Burndown Chart** (track sprint progress):
- **Reports → Burndown Chart**
- Shows: Story points remaining per day
- Ideal line vs. actual progress

**Velocity Chart** (track team speed):
- **Reports → Velocity Chart**
- Shows: Story points completed per sprint
- Use to predict future capacity

**Cumulative Flow Diagram** (identify bottlenecks):
- **Reports → Cumulative Flow Diagram**
- Shows: Number of issues in each workflow state over time

---

### 4.4 Jira Automation (Power User Feature)

**Example**: Auto-transition issue to "Done" when PR merged
1. **Settings → Automation → Create rule**
2. Trigger: **"Commit created"** (requires GitHub integration)
3. Condition: **Commit message contains "fixes [ISSUE-KEY]"**
4. Action: **Transition issue to "Done"**

**Example**: Auto-assign to self when you move issue to "In Progress"
1. Trigger: **"Issue transitioned"** to **"In Progress"**
2. Action: **Assign to current user**

---

## 5. Productboard Setup (For Product Managers)

### Why Productboard?
- Built specifically for product management (not dev tool)
- Native RICE scoring, user feedback aggregation
- Roadmap visualization for stakeholders
- Integrations: Jira, Slack, Intercom (sync user feedback)

### When to use:
- You have budget ($20/month minimum)
- PM role-heavy (not coding all day)
- Need to aggregate user feedback from multiple sources

### Quick Setup (20 minutes)

#### Step 1: Create Account
1. Go to [productboard.com](https://productboard.com)
2. Start free trial (14 days)
3. Create workspace

#### Step 2: Add Features
1. Click **"+ Feature"** button
2. Fill: Name, description
3. Add **User feedback** (paste user quotes, emails, support tickets)

#### Step 3: Score with RICE
1. Open feature detail
2. Click **"Score"** tab
3. Fill: Reach, Impact, Confidence, Effort
4. Productboard auto-calculates RICE score

#### Step 4: Roadmap View
1. Go to **"Roadmap"** tab
2. Drag features to **Now / Next / Later** columns
3. Share with stakeholders (public URL)

**Limitation for solo dev**: Overkill if there are no external stakeholders or extensive user feedback channels.

---

## 6. Tool Selection Decision Tree

```
START
  │
  ├─ Solo dev, technical-focused?
  │   ├─ Yes → Use LINEAR (best UX, dev-first)
  │   └─ No → Continue
  │
  ├─ Need docs + PM in one place?
  │   ├─ Yes → Use NOTION (all-in-one)
  │   └─ No → Continue
  │
  ├─ Team of 2+ people?
  │   ├─ Yes → Use JIRA (collaboration, workflows)
  │   └─ No → Continue
  │
  ├─ PM role, need user feedback aggregation?
  │   ├─ Yes → Use PRODUCTBOARD (if budget allows)
  │   └─ No → Continue
  │
  └─ Just need simple task list?
      └─ Use TRELLO or ASANA (quick start)
```

---

## 7. Integration Patterns

### GitHub + Linear
- Install Linear GitHub app
- Commit format: `git commit -m "fix(auth): resolve login issue (LIN-123)"`
- Auto-links commit to issue, updates status

### GitHub + Jira
- Install Jira GitHub app
- Commit format: `git commit -m "fix(auth): PROJ-123 resolve login"`
- Auto-transitions issue based on branch/PR status

### Notion + Zapier + GitHub
- Zapier: GitHub Issue created → Notion database row created
- Keep Notion as source of truth, GitHub for code tracking

### Slack + Any Tool
- All tools have Slack integration (notifications)
- Example: Linear issue created → Slack message in #dev channel

---

## 8. Best Practices (Tool-Agnostic)

### 1. Single Source of Truth
- Pick ONE tool for roadmap/backlog (don't duplicate across Jira + Notion)
- Other tools can sync FROM the primary tool

### 2. Weekly Grooming
- Friday afternoon: Review backlog, update priorities, score new items
- 30 min max for solo dev

### 3. Automate Status Updates
- Link commits to issues (auto-mark done when PR merged)
- Don't manually update status if automation can do it

### 4. Minimize Custom Fields
- Start with defaults, add custom fields only if truly needed
- Too many fields = maintenance burden

### 5. Archive Old Data
- Quarterly: Archive issues from 3+ months ago
- Keeps backlog clean, improves performance

---

## 9. Migration Guide (Switching Tools)

### Notion → Linear
1. Export Notion database as CSV
2. Import to Linear via **Settings → Import → CSV**
3. Map columns: Notion "Feature" → Linear "Title", etc.

### Jira → Linear
1. Use Linear's built-in Jira import: **Settings → Import → Jira**
2. Select project, authenticate, import all issues

### GitHub Issues → Linear/Jira
1. Linear: **Settings → Import → GitHub Issues**
2. Jira: Use Jira GitHub integration (two-way sync)

---

## 10. Cost Breakdown (2026 Pricing)

| Tool | Solo Dev | Small Team (5) | Notes |
| :--- | :--- | :--- | :--- |
| **Linear** | **FREE** | **FREE** | Unlimited users, all features |
| **Notion** | **FREE** | **$8/month** | Free up to 10 guests, paid for unlimited |
| **Jira** | **FREE** | **FREE** | Free up to 10 users, then $7.75/user/month |
| **Productboard** | **$20/month** | **$49/month** | 1 maker + unlimited viewers |
| **Trello** | **FREE** | **$5/user/month** | Free tier sufficient for small teams |
| **Asana** | **FREE** | **$10.99/user/month** | Free up to 15 users, basic features |

**Recommendation**: Start free (Linear or Notion), upgrade only if you hit limits.

---

## 11. Templates to Copy

### Linear Board States (Copy to Settings)
- Triage → Backlog → Todo → In Progress → In Review → Done → Canceled

### Notion Roadmap Properties (Copy to Database)
- Feature (Title), Phase (Select: Now/Next/Later), Priority (Select: P0/P1/P2/P3), Reach (Number), Impact (Number), Confidence (Number), Effort (Number), RICE Score (Formula: `prop("Reach") * prop("Impact") * prop("Confidence") / prop("Effort")`)

### Jira Sprint Naming Convention
- Format: `[Product] Sprint [N] - [Goal]`
- Example: `Acme Sprint 1 - MVP Core Features`

---

## 12. Troubleshooting Common Issues

### Problem: Too many open issues, can't prioritize
**Solution**: Run MoSCoW triage (force-rank into Must/Should/Could/Won't), close "Won't" items.

### Problem: Backlog keeps growing, never shrink
**Solution**: Set WIP limit (max 5 "In Progress" at once), finish before starting new.

### Problem: Estimates always wrong (tasks take 2x longer)
**Solution**: Add 20% buffer to all estimates, track actual vs. estimate to improve over time.

### Problem: Tool feels overwhelming (too many features)
**Solution**: Hide unused features (most tools allow collapsing sections), use only Board + Backlog views.

---

## 13. Quick Start Checklist

- [ ] Pick tool (Linear for dev, Notion for docs+PM)
- [ ] Create project/workspace
- [ ] Set up workflow states (Triage → Backlog → In Progress → Done)
- [ ] Add labels/tags (now/next/later, bug/feature, p0/p1/p2)
- [ ] Create first 5 issues (from your idea brief or PRD)
- [ ] Score with RICE (or MoSCoW for quick triage)
- [ ] Start sprint/cycle (pick top 3–5 items)
- [ ] Integrate with GitHub (auto-link commits)
- [ ] Set weekly review reminder (Friday 4pm)

**Time to productive**: 30 min with Linear, 1 hour with Notion, 2 hours with Jira.

---

**📌 Next Steps**: Choose your tool → Follow setup guide → Create first sprint → Start building!
