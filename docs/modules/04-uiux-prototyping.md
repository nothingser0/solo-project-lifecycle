# Module 04: UI/UX Design & Prototyping

> **PROTOTYPING OPTIONS (2026)**: Multiple approaches available - Markdown-only, AI tools (v0/Bolt/Lovable), or design tools (Figma).
> **Default workflow**: Choose based on project context (see STEP 2).

> - `references/solo/SOLO_UIUX_GUIDE.md` (Solo dev UI/UX efficiency guide, Component library selection, WCAG contrast, Prototype walkthrough)
> - `references/pm/PM_USER_TESTING_GUIDE.md` (User testing facilitation, Usability test plan)
> - `references/technical/UI_COMPONENT_ANIMATION_LIBRARY.md` (Animation patterns library)
> - `references/technical/ASSET_MANAGEMENT_GUIDE.md` (Images/SVG/WebP/fonts optimization, Favicon package, Accessibility alt text, Performance budgets)
> - `references/technical/AI_DEVELOPMENT_TOOLS_COMPARISON.md` (AI UI prototyping & coding tools benchmark)
> - `references/technical/FIGMA_MCP_SETUP.md` (Figma MCP server installation, live design sync, token setup, usage patterns)
>

This module translates `SCOPE_STATEMENT.md` into three documents that serve as the UI source of truth: `DESIGN.md`, `docs/specs/DESIGN_SPEC.md`, and `docs/design/DESIGN_REFERENCES.md`. Its focus is visual standardization, shared components, all pages/sub-pages that are genuinely in-scope, responsive behavior, accessibility, and acceptance criteria.

> **Default workflow (2026):** Choose prototyping approach based on context. Markdown-first for solo MVP; interactive prototypes (Stitch/AI/Figma) when client needs visual sign-off.

> **Output gate:** Module 04 does not produce UI code, Stitch prompts, Screen IDs, or live prototypes by default. Code is created in Module 06 based on these three documents.

---

## 1. Module 04 Execution Cycle

```text
[ INPUT: SCOPE_STATEMENT.md & Valid Contract + Down Payment from Module 03 ]
                                │
                                ▼
[ STEP 0: Component Discovery & UI Pattern Analysis ]
  • Read SCOPE_STATEMENT.md → Extract features & acceptance criteria
  • Map features → UI patterns (forms, tables, modals, etc.)
  • Identify component inventory (primitives, composite, layout)
  • Define interaction states (5-state matrix, form states)
  • Document responsive breakpoints & accessibility requirements
  • OUTPUT: COMPONENT_REQUIREMENTS.md (prevents AI slop)
                                │
                                ▼
[ STEP 1: Drafting DESIGN.md Guardrails (Anti-Slop Tokens) ]
  • READ: COMPONENT_REQUIREMENTS.md (component inventory as input)
  • Neutral Color Palette (Zinc/Slate) + 1 Accent Brand Color
  • Inter & JetBrains Mono Typography, Flat 1px Border, Zero Gradient
                               │
                                ▼
[ STEP 2: Choose Prototyping Approach (Context-Driven) ]
  • Markdown-only: DESIGN.md + DESIGN_SPEC.md (fast, solo projects)
  • Design options: Visual builder with design system upload
  • AI prototype: v0.dev / Bolt.new (AI-generated components)
  • Design tool: Figma Dev Mode (professional handoff)
                                │
                                ▼
[ STEP 3: Screen Specification (5-State Matrix) ]
  • Document/Generate Each Main Page (Login, Dashboard, Form, Detail)
  • Mandatory Inclusion of 5 States: Default, Loading Skeleton, Empty, Error, Success
                                │
                                ▼
[ STEP 4: Navigation & Prototype (If Interactive Path Chosen) ]
  • Connect screen flows and user journeys
  • Deploy to staging URL (if interactive prototype built)
                                │
                                ▼
[ STEP 5: Walk-Through Session & Design Freeze ]
  • Interactive Demo with Client Single PIC
  • Sign Design Freeze Sign-Off Sheet
                                │
                                ▼
[ OUTPUT: 5 COMPLETE ARTIFACTS ] ──► Ready to Proceed to Module 05: Architecture & FSD
  1. docs/specs/COMPONENT_REQUIREMENTS.md (component inventory)
  2. docs/specs/DESIGN.md (design system tokens - )
  3. docs/specs/DESIGN_SPEC.md (screen specifications)
  4. docs/specs/SITEMAP.md (screen hierarchy)
  5. Prototype URL (if interactive path chosen)
```

---

## 0. Component Discovery & UI Pattern Analysis (STEP 0)

> **CRITICAL: This step prevents AI slop by mapping scope features to concrete UI patterns BEFORE designing.**
> **Duration**: 1-2 hours
> **Input**: `SCOPE_STATEMENT.md` (features, user stories, acceptance criteria)
> **Output**: `COMPONENT_REQUIREMENTS.md` (justified component inventory)

### Why This Step Exists

**Problem without Step 0:**
```
AI generates generic design system:
- Colors: Primary, secondary, tertiary (no context)
- Components: Button, Input, Card (generic descriptions)
- Result: 50+ components, many unused, no justification
```

**Solution with Step 0:**
```
Read SCOPE_STATEMENT → Map features → Identify patterns → List components
- Every component has a reason (traced to scope feature)
- Right-sized inventory (20-30 components, not 50+)
- Interaction states defined upfront (5-state matrix)
- No generic additions without justification
```

---

### Step 0 Process

#### 1. Read SCOPE_STATEMENT.md (15 min)

Extract:
- **Features**: What the app does (authentication, dashboard, CRUD, etc.)
- **User stories**: Who needs what and why
- **Acceptance criteria**: Observable success conditions
- **Critical flows**: Login → Dashboard → Create task → View detail

**Example (TaskFlow app):**
```markdown
Feature 1: Authentication
- User story: As a team member, I want to log in, so I can access my tasks
- Acceptance: Email validation, password min 8 chars, error messages

Feature 2: Dashboard
- User story: As a team lead, I want to see task stats, so I can monitor progress
- Acceptance: Show total/in-progress/completed counts, load in <2s

Feature 3: Task List
- User story: As a team member, I want to view all tasks, so I can pick work
- Acceptance: Sortable table, filter by status, search by title, pagination
```

---

#### 2. Map Features → UI Patterns (45 min)

For each feature, identify:
- **UI pattern needed**: Form, table, dashboard, detail view, modal, etc.
- **User interactions**: What user does → What system shows
- **Edge cases**: Empty state, error state, loading state

**Example:**
```markdown
Feature 1: Authentication

UI Patterns:
- Form layout (email + password fields)
- Input validation (inline errors)
- Submit button (primary variant)
- Loading state (spinner during API call)

User Interactions:
1. User enters email → System validates format
2. User enters password → System checks length
3. User clicks "Login" → System shows loading, then redirects or error

Edge Cases:
- Invalid email: Show "Invalid email format" below field
- Wrong password: Show "Invalid credentials" below form
- Network error: Show "Connection failed. Retry?" with button

Components Required:
- Input (with error state)
- Button (primary variant, loading state)
- FormField (label + input + error wrapper)
- LoadingSpinner
```

Repeat for ALL features in SCOPE_STATEMENT.

---

#### 3. Consolidate Component Inventory (30 min)

Group components into:

**A. Primitives (Atomic)**: Button, Input, Badge, Icon, etc.
**B. Composite (Combinations)**: FormField, Modal, Table, Toast, etc.
**C. Layout (Structure)**: Container, Grid, Stack, ButtonGroup
**D. Patterns (Feature-specific)**: StatWidget, DescriptionList, etc.

**Rules:**
- ✅ Include ONLY if used by ≥1 scope feature
- ❌ Exclude generic "might need later" components
- ✅ Document which features use each component
- ✅ Count variants (Button: primary/secondary/ghost)

**Example Inventory:**
```markdown
Primitives (11):
1. Button (4 variants) - Used by Features 1,2,3,4,5
2. Input (5 states) - Used by Features 1,3,4
3. Textarea - Used by Feature 4
4. Select/Dropdown - Used by Features 3,4
5. Badge - Used by Features 3,5
... (total 11)

Composite (9):
1. FormField - Used by Features 1,4 (all forms)
2. Card - Used by Features 2,5
3. Modal - Used by Feature 5 (delete confirmation)
4. Table - Used by Feature 3 (task list)
... (total 9)

TOTAL: 27 components (justified, no slop)

EXCLUDED (Not in MVP):
❌ Tabs - No complex navigation
❌ Accordion - No collapsible sections
❌ Slider - No range inputs
❌ File Upload - No attachments in MVP
```

---

#### 4. Define Interaction States (15 min)

**Per Component:**
- Input: default, hover, focus, error, disabled
- Button: default, hover, active, disabled, loading
- Modal: closed, opening, open, closing

**Per Screen (5-State Matrix):**
- All data screens MUST have:
  1. **Idle**: Normal render with data
  2. **Loading**: Skeleton loaders (gray pulsing)
  3. **Success**: Data loaded (same as idle)
  4. **Error**: Error message + retry button
  5. **Empty**: Empty state illustration + CTA

**Per Form:**
- Pristine, Validating, Valid, Invalid, Submitting

---

#### 5. Responsive & Accessibility (15 min)

**Responsive Breakpoints:**
```markdown
Mobile (375px): Single column, stacked layout
Tablet (768px): 2 columns for dashboard, table scrolls
Desktop (1440px): 3 columns, full table

Critical decisions:
- Navigation: Hamburger menu on mobile
- Dashboard: 3 cols → 2 cols → 1 col
- Table: Horizontal scroll on mobile (not card view)
- Forms: Always single column
```

**Accessibility:**
```markdown
Per Component:
- Input: aria-label, aria-invalid, aria-describedby
- Button: aria-disabled, aria-busy
- Modal: aria-modal, role="dialog", focus trap, Esc to close
- Table: scope="col" for headers

Global:
- Focus ring: 2px solid #3B82F6, offset 2px
- Color contrast: WCAG AA (4.5:1 body, 3:1 large text)
- Touch targets: 44×44px minimum
```

---

#### 6. Write COMPONENT_REQUIREMENTS.md (15 min)

Use template: `templates/02-design/COMPONENT_REQUIREMENTS_TEMPLATE.md`

**Sections:**
1. Feature summary (from SCOPE_STATEMENT)
2. Feature → UI pattern mapping
3. Component inventory (27 components with justification)
4. Interaction states matrix
5. Responsive breakpoints
6. Accessibility requirements
7. Design decisions rationale (why NO tabs/accordion/slider)

**Output file:**
```
docs/specs/COMPONENT_REQUIREMENTS.md
```

---

### Step 0 Checklist

Before proceeding to Step 1 (DESIGN.md generation):

- [ ] All scope features extracted
- [ ] Each feature mapped to UI patterns
- [ ] Component inventory: 20-40 components (not 50+)
- [ ] Every component has justification (which features use it)
- [ ] Excluded components documented (why NOT in MVP)
- [ ] 5-state matrix defined for data screens
- [ ] Responsive breakpoints decided
- [ ] Accessibility requirements listed
- [ ] COMPONENT_REQUIREMENTS.md committed

**Time budget:** 1-2 hours

**Next step:** Generate DESIGN.md using component inventory as input (prevents generic slop)

---

## 1A. Prototyping Approach Selection (STEP 2)

**Choose approach based on project context**:

### Option A: Markdown-Only (FASTEST - Solo Projects)
**Use when**:
- Solo developer project (no client visual approval needed)
- Budget <$5K USD (time = money)
- Simple UI (forms, tables, dashboards)

**Deliverables**:
- ✅ DESIGN.md (tokens)
- ✅ DESIGN_SPEC.md (5-state matrix per screen)
- ❌ No interactive prototype

**Pros**: Fastest (2-4 hours), no tool dependency, forces clear specification
**Cons**: No visual preview before coding, client may request changes post-M06

---

### Option B: Design prototyping (Visual Builder)
**Use when**:
- Need rapid visual prototyping (drag-and-drop)
- Client requires interactive demo
- Design system can be uploaded programmatically

**Tools**: Design prototyping MCP Server

**Workflow**:
1. Generate DESIGN.md (tokens, guidelines)
5. Connect navigation, deploy to Stitch Viewer
6. Document final specs in DESIGN_SPEC.md

**Deliverables**:
- ✅ DESIGN.md (tokens)
- ✅ DESIGN_SPEC.md (5-state matrix)
- ✅ Stitch prototype URL

**Pros**: Fast iteration, visual drag-and-drop, instant preview
**Cons**: MCP tool dependency, proprietary platform

> ⚠️ **STITCH TOOL TROUBLESHOOTING**:
> If Stitch MCP tools fail (authentication/network):
> - Check API key in `opencode.json` / `STITCH_API_KEY`
> - Report technical issues to user (don't skip Stitch unilaterally)
> - Fallback to Option C (AI prototype) only if Stitch unavailable

---

### Option C: AI-Powered Prototype (Modern Alternative)
**Use when**:
- Stitch unavailable or user prefers code-based output
- Need production-ready component code
- Client needs visual sign-off before M06

**Tools** (choose one):

#### 1. v0.dev (Vercel)
```bash
Pros: Next.js/React output, Tailwind built-in, production-ready code
Cons: Vercel account required, rate limits
Use: Next.js projects (70% of solo projects)
```

#### 2. Bolt.new (StackBlitz)
```bash
Pros: Multiple frameworks (Vue/Svelte/React), instant deploy
Cons: WebContainers dependency, limited backend
Use: Frontend-heavy apps, rapid iteration
```

#### 3. Lovable.dev (formerly GPT Engineer)
```bash
Pros: Database schema + API + UI generation
Cons: Opinionated stack, subscription required
Use: CRUD apps with clear data model
```

**Workflow**:
1. Generate DESIGN.md first (tokens, guidelines)
2. Feed DESIGN.md to AI tool with screen descriptions
3. Iterate 2-3 rounds (colors, layout, components)
4. Export prototype URL for client review
5. Document final design in DESIGN_SPEC.md

**Deliverables**:
- ✅ DESIGN.md (tokens)
- ✅ DESIGN_SPEC.md (5-state matrix)
- ✅ Interactive prototype URL

---

### Option D: Design Tool Workflow (Complex UI)
**Use when**:
- Complex visual design (brand-heavy, marketing site)
- Designer on team (handoff to dev)
- Client requires design files (Figma/Penpot)
- Manual design control needed

**Tools**:

#### 1. Figma Dev Mode (Manual Export)
```bash
Pros: Industry standard, code export, design tokens
Cons: Subscription required ($15/mo), manual design work
Use: Professional client work, complex UI systems
Note: For live sync, use Option E (Figma MCP) instead
```

#### 2. Penpot (Open-Source Figma Alternative)
```bash
Pros: Free, self-hosted, SVG-native
Cons: Smaller ecosystem, fewer plugins
Use: Budget-conscious projects, design freedom
```

**Workflow**:
1. Create design system (colors, typography, components)
2. Design all screens with 5-state variants
3. Export design tokens to DESIGN.md (manual)
4. Document specs in DESIGN_SPEC.md
5. Share Figma/Penpot link for client review

**Deliverables**:
- ✅ DESIGN.md (tokens)
- ✅ DESIGN_SPEC.md (specifications)
- ✅ Figma file / Penpot project

---

### Option E: Figma MCP (Live Design Sync)
**Use when**:
- Active designer making frequent iterations
- Need real-time design system sync
- Want AI to generate code directly from Figma frames
- MCP-compatible AI tool available (Claude Code, Cursor, VS Code, Codex, Xcode)

**Requirements**:
- Figma account with API access
- MCP-compatible AI client ([Figma MCP Catalog](https://www.figma.com/mcp-catalog/))
- OAuth authentication (browser flow)

**Quick Start**:

**If MCP already configured globally** (e.g., in `~/.omp`):
Figma MCP server already available. Skip to Usage below.

**Setup per Client**:

**Claude Code**:
```bash
claude plugin install figma@claude-plugins-official
# Or: claude mcp add --scope user --transport http figma https://mcp.figma.com/mcp
```

**Cursor**: `/add-plugin figma`

**VS Code**: Install Figma MCP extension or add to `mcp.json`

**Codex**: `codex mcp add figma --url https://mcp.figma.com/mcp`

**Xcode**: One-click setup via plugin

See `references/technical/FIGMA_MCP_SETUP.md` for full installation guide.

**Available Tools**:

**Read** (Design → Code):
- `get_design_context` - Extract design + generate code (React+Tailwind default)
- `get_metadata` - XML outline of frame structure
- `get_screenshot` - Screenshot of selection
- `download_assets` - Export assets (PNG/SVG/PDF/JPG)
- `get_variable_defs` - Design tokens (colors, typography, spacing)
- `get_motion_context` - Animation keyframes
- `search_design_system` - Search libraries for components/variables

**Write** (Code → Design):
- `use_figma` - Create/edit Figma content
- `generate_figma_design` - Capture live UI to Figma
- `generate_diagram` - Create FigJam diagrams from Mermaid
- `upload_assets` - Upload images to Figma

Full reference: https://developers.figma.com/docs/figma-mcp-server/tools-and-prompts/

**Usage Examples**:

**Extract Design System (M04)**:
```bash
User: "Extract design system from https://figma.com/file/ABC123/Design-System"

AI calls:
- get_design_context(fileKey="ABC123", nodeId from URL)
- get_variable_defs() for tokens

Generates:
→ DESIGN_SPEC.md with live tokens (colors, typography, spacing)
→ Component inventory from Figma libraries
```

**Generate Code from Frame (M06)**:
```bash
User: "Generate Next.js component from https://figma.com/file/ABC123/.../node-XYZ"

AI calls:
- get_design_context(fileKey="ABC123", nodeId="node-XYZ")

Returns:
→ React + Tailwind component code
→ Matches Figma design exactly
```

**Custom Framework**:
```bash
"Generate in Vue using components from src/ui/"
"Generate iOS SwiftUI view from this Figma frame"
"Generate plain HTML + CSS"
```

**Deliverables**:
- ✅ DESIGN_SPEC.md (auto-generated from Figma variables)
- ✅ DESIGN_SPEC.md (extracted from frames)
- ✅ Live Figma file (source of truth)
- ✅ No manual export needed

**Pros**:
- ✅ No manual token export (reads Figma variables directly)
- ✅ Always synced (queries live file)
- ✅ AI generates code from frames (visual → code)
- ✅ Bidirectional (can capture live UI to Figma)
- ✅ Component reuse via Code Connect

**Cons**:
- ❌ Requires MCP setup (OAuth authentication)
- ❌ Only works with supported clients (Claude Code, Cursor, VS Code, Codex, Xcode)
- ❌ Network dependency (Figma API must be reachable)
- ❌ Figma subscription required

**Best for**:
- Teams with active designer + developer collaboration
- Design systems with frequent token updates
- Projects where Figma is single source of truth

---

### Decision Matrix

| Criteria | Markdown | Stitch | AI Prototype | Design Tool | Figma MCP |
|----------|----------|--------|--------------|-------------|-----------|
| Time | 2-4 hours | 4-8 hours | 1-2 days | 2-3 days | 4-6 hours |
| Cost | Free | Free* | $0-50 | $15-50/mo | $15/mo |
| Client demo | ❌ | ✅ | ✅ | ✅ | ✅ |
| Code output | N/A | HTML | React/Vue | Manual | React/Vue |
| Tool dependency | None | MCP | Web | Desktop app | MCP + Figma |
| Live sync | ❌ | ❌ | ❌ | ❌ | ✅ |
| Best for | Solo MVP | Quick visual | Modern stack | Professional | Design systems |

*Stitch: Free if MCP available; otherwise N/A

---

## 2. Module 04 Deliverables

This module produces concrete deliverables:

| No | Artifact Name | Format / Location | Description & Function |
| :---: | :--- | :--- | :--- |
| **1** | **`docs/specs/SITEMAP.md`** | Folder `docs/specs/` | Information Architecture: navigation structure, page hierarchy, route paths (18-50 screens depending on scale). Prerequisite for DESIGN_SPEC.md. |
| **2** | **`docs/specs/DESIGN_SPEC.md`** | Folder `docs/specs/` | Combined design system tokens and comprehensive UI specification document (color palette, typography, component specs, 5-state screen matrix per screen). |
| **3** | **`docs/harness-root/DESIGN.md`** | Folder `docs/harness-root/` (staged) | Design tokens for AI agent consumption during coding (Module 06): colors, fonts, spacing, anti-slop guardrails. Deployed to root after scaffold. |
| **4** | **Interactive Prototype** (Optional) | Stitch / v0.dev / Bolt / Figma | Clickable interface (only if Option B/C/D selected). For Option A: skip prototype, proceed to M06. |
| **5** | **Design Freeze Sign-Off** | Signed sheet | Written approval minutes from Client Single PIC locking the visual structure before coding begins. |

> 📁 **MANDATORY FILE LOCATION RULES**:
> - `DESIGN.md` is staged in `docs/harness-root/DESIGN.md` during M04, then deployed to root (`./DESIGN.md`) after scaffold in M06.
> - `DESIGN_SPEC.md` MUST be placed in **`docs/specs/DESIGN_SPEC.md`**. Placed in the root directory is STRICTLY FORBIDDEN.
>
> ⚠️ **PROTOTYPING TOOL SELECTION**:
> - Default to Option A (Markdown-only) for solo projects
> - Use Option B (Stitch) if MCP available and user prefers visual builder
> - Use Option C (AI prototype) for modern stack with code output
> - Use Option D (Design tool) for professional design handoff
> - Never skip DESIGN.md + DESIGN_SPEC.md documentation (mandatory regardless of prototype choice)

---

## 2A. SITEMAP.md - Information Architecture

**File**: `docs/specs/SITEMAP.md`

The sitemap defines **page hierarchy, route paths, and navigation structure** prior to creating mockups. Mandatory prerequisite for DESIGN_SPEC.md.

### Template Structure

```markdown
# SITEMAP - Information Architecture
[Project Name]

## Total Screens: [X] screens

---

## PUBLIC PAGES (Unauthenticated)

**Root**: `/`
├── `/login` - User login form
├── `/signup` - Registration form (email + password)
├── `/forgot-password` - Request password reset email
└── `/reset-password?token=xxx` - Reset password with token verification

---

## AUTHENTICATED PAGES

**Dashboard**: `/dashboard` (Landing page after login)

### Documents Module
├── `/documents` - List view (table with filters, search, pagination)
├── `/documents/upload` - Upload new document form
├── `/documents/:id` - Single document detail view
└── `/documents/:id/edit` - Edit document metadata

### Signatures Module (E-signature workflow)
├── `/signatures/pending` - Documents awaiting signature
├── `/signatures/completed` - Signed documents archive
└── `/signatures/:id` - Signature detail & status tracking

### Users Module (Admin only)
├── `/users` - User management list (roles: admin, editor, viewer)
├── `/users/invite` - Invite new user form (email + role selection)
└── `/users/:id` - User profile & permission management

### Settings
├── `/settings/profile` - User profile (name, email, avatar)
├── `/settings/security` - Change password, 2FA setup
└── `/settings/preferences` - UI theme (light/dark), language, notifications

---

## Screen Count by Module

| Module | Screens | Notes |
|--------|---------|-------|
| Public | 4 | Login, signup, forgot/reset password |
| Dashboard | 1 | Main landing after auth |
| Documents | 4 | List, upload, detail, edit |
| Signatures | 3 | Pending, completed, detail |
| Users (Admin) | 3 | List, invite, profile |
| Settings | 3 | Profile, security, preferences |
| **TOTAL** | **18** | MVP scope |

---

## Navigation Structure

**Top Navigation** (Authenticated):
- Logo (left) → `/dashboard`
- Main Nav (center): Documents | Signatures | Users (if admin)
- User Menu (right): Profile | Settings | Logout

**Sidebar Navigation** (Optional - for dashboard-heavy apps):
- Dashboard
- Documents
- Signatures
- Users (admin only)
- Settings
- Help & Support

**Breadcrumbs** (Context awareness):
- Example: Home > Documents > Document #123 > Edit
```

### Example Applications Across Different Scales

**Small (10-15 screens)**: SaaS landing page
```
Public: /, /login, /signup, /pricing
Authenticated: /dashboard, /settings, /billing
Admin: /admin/users, /admin/reports
```

**Medium (20-30 screens)**: E-commerce
```
Public: /, /products, /product/:id, /cart, /checkout, /login
User: /account, /orders, /orders/:id, /wishlist, /settings
Admin: /admin/products, /admin/orders, /admin/customers, /admin/analytics
```

**Large (50-100+ screens)**: Enterprise SaaS
```
- 10+ modules (CRM, Inventory, Finance, HR, Reports)
- Role-based screens (admin, manager, staff)
- Multi-step workflows (onboarding, approval chains)
```

---

## 2B. Workflow Options: Manual vs AI-Assisted Design

After the sitemap is completed, choose a workflow to create mockup screens:

### Option A: Manual Design (Figma/Adobe XD/Sketch)

**Tools**: Figma, Adobe XD, Sketch

**Workflow**:
1. Create a design system in Figma (component library: buttons, inputs, cards, modals)
2. Design 18 screens one by one manually (wireframe → high-fidelity)
3. Export specs (measurements, colors, typography) for developers
4. Generate assets (icons, images, logos)
5. Handoff via Figma Dev Mode / Zeplin

**Pros**:
- ✅ Full pixel-perfect control
- ✅ Industry-standard workflow (easy to hire designers later)
- ✅ Reusable component library for future updates
- ✅ Client familiarity with Figma (easier feedback loop)

**Cons**:
- ❌ Slow (1-2 weeks for 18 screens with polishing)
- ❌ Requires design skills (color theory, typography, spacing)
- ❌ Effort: High (8-10 hours per screen for detailed mockups)

**Best For**:
- Client projects with high design expectations
- Consumer-facing products (B2C) requiring strong branding
- Sufficient budget to hire a freelance UI designer (Rp 5-10 million)

**Time Estimate**: 2-3 weeks (solo developer with basic design skills)

---

### Option B: AI-Assisted Design (Design prototyping / v0.dev / Uizard)

**Tools**: Design prototyping (built-in MCP), v0.dev by Vercel, Uizard, Galileo AI

**Workflow**:
1. Write design system tokens in DESIGN.md (colors, typography, spacing)
2. Prompt AI per screen: "Generate dashboard with sidebar nav, document list table, upload button"
3. AI generates mockup + React/HTML code in seconds
4. Iterate: "Make sidebar wider, change primary color to cyan-600, add dark mode"
5. Export React components / Tailwind HTML

**Pros**:
- ✅ Fast (a few hours for 18 screens with iterations)
- ✅ Generates code directly (skips manual HTML/CSS translation)
- ✅ Easy iteration (re-prompt for different variants)
- ✅ Low cost (Design prototyping free tier, v0.dev $20/month)

**Cons**:
- ❌ Generic look without customization (common AI patterns)
- ❌ Less pixel-perfect (spacing/alignment occasionally off)
- ❌ Requires prompt engineering skills (GIGO: garbage in, garbage out)
- ❌ Code quality varies (occasional inline styles, non-standard conventions)

**Best For**:
- MVP / Internal tools (speed > polish)
- Solo developer without design skills
- Tight budget (cannot hire a designer)
- Fast iteration cycle (prototype → test → iterate within hours)

**Time Estimate**: 1-3 days (including prompt iteration & code cleanup)

**Example Prompt (Design prototyping)**:
```
Generate Dashboard screen (Screen ID: SCR-02) for Legal Document Management:

CONTENT:
- Sidebar navigation (left): Logo, Dashboard, Documents, Signatures, Settings
- Main content area: 
  * Header: "Documents" title, Search bar (placeholder: "Search by title or ID"), "Upload" button (primary)
  * Table: 5 columns (Title, Uploaded By, Date, Status, Actions), 10 rows with pagination
  * Status badges: Draft (gray), Pending (yellow), Signed (green)
  * Actions: View icon, Edit icon, Delete icon

DATA CONTEXT: Indonesian law firm, document titles in Bahasa Indonesia

DESIGN CONSTRAINTS (ANTI-SLOP):
- NO gradients, glassmorphism, colored shadows
- Flat colors: Primary #0891B2 (Cyan-600), Neutrals Zinc-50 to Zinc-950
- Borders: 1px solid #E4E4E7, radius 8px (cards), 6px (buttons)
- Typography: Inter font, weights 400 (body) / 600 (headings), line-height 1.6
- Shadows: 0 1px 3px rgba(0,0,0,0.1) only (no heavy shadows)
- Layout: Sidebar 240px fixed, main content max-w-7xl, padding 24px
- Spacing: Tailwind scale (4/8/16/24/32px)
- Table: Zebra striping (even rows bg-zinc-50), sticky header
```

---

### Option C: Hybrid (Recommended for Solo Developer)

**Best of Both Worlds**

**Workflow**:
1. **AI wireframes** (Design prototyping / v0.dev): Generate 18 screens rapidly (1 day)
   - Focus: Layout structure, component placement, navigation flow
   - Accept: 80% quality (not pixel-perfect yet)

2. **Manual polish** in Figma (if needed) (1-2 days):
   - Export Stitch designs to Figma (via HTML → Figma plugin)
   - Polish: Typography hierarchy, spacing consistency, color refinement
   - Add brand-specific elements (custom icons, illustrations, photography)
   - Create reusable component library from AI output

3. **Code implementation** (Module 06):
   - Use Stitch-generated code as starting point (HTML structure, Tailwind classes)
   - Refactor to match codebase patterns (component composition, naming conventions)
   - Replace placeholder data with real data from database

**Pros**:
- ✅ 70% faster than full manual (AI handles boilerplate structure)
- ✅ Better quality than pure AI (manual polish for brand consistency)
- ✅ Reusable design system (Figma library for future updates)
- ✅ Balanced cost (AI free tier + 1-2 days design time vs 2-3 weeks full manual)

**Cons**:
- ⚠️ Still requires basic Figma skills for polishing
- ⚠️ Two tools overhead (learning both Stitch + Figma)

**Best For**:
- Solo developer with limited design skills but willing to learn
- Client projects with medium design expectations (B2B SaaS)
- Tight budget but 1-2 days available for polish
- Desire for a reusable design system for long-term maintenance

**Time Estimate**: 3-5 days (1 day AI generation + 1-2 days manual polish + 1 day code integration testing)

---

## 2C. Decision Matrix: Select the Right Workflow

| Criteria | Manual Figma | AI-Assisted | Hybrid |
|----------|--------------|-------------|--------|
| **Budget** | Rp 5-10 million (hire designer) or 2-3 weeks solo time | Free - Rp 500k/month tools | Rp 0-2 million (AI tools + freelance polish) |
| **Timeline** | 2-3 weeks | 1-3 days | 3-5 days |
| **Design Skill Required** | High (color theory, typography, composition) | Low (prompt engineering) | Medium (basic Figma + AI prompts) |
| **Output Quality** | Highest (pixel-perfect, brand-aligned) | Medium (generic, needs refinement) | High (80-90% of manual quality) |
| **Client Type** | B2C, consumer apps, high design expectations | Internal tools, MVP, technical users | B2B SaaS, medium expectations |
| **Long-term Maintenance** | Best (component library in Figma) | Hardest (re-prompt on every change) | Good (Figma library + AI iteration) |
| **Code Quality** | N/A (manual translation by dev) | Medium (AI-generated, needs cleanup) | Good (AI base + manual refactoring) |

**Default Recommendations for Solo Developer**:
- **MVP / Internal tools / Tight deadline**: → **Option B (AI-Assisted)**
- **Client project / Medium budget / 1-2 weeks available**: → **Option C (Hybrid)**
- **High-end product / Strong brand / Budget for designer**: → **Option A (Manual Figma)** or hire freelance designer

---

## 3. Step-by-Step Execution

### Step 0A: Generate Logo Design Brief (MANDATORY - Pre-Design Phase)
**MANDATORY BEFORE STEP 1** for all projects (client or solo product):

1. **Create document `LOGO_DESIGN_BRIEF.md`** in `docs/specs/` with structure:
   - Brand Identity (positioning statement, tagline, target user)
   - Brand Personality (tone of voice, mood keywords)
   - Logo Requirements (SVG format, scalability 16px-512px, versatility light/dark)
   - 4 Logo Concept Ideas (Lettermark, Abstract Symbol, Iconographic, Wordmark)
   - Color Palette Recommendation (primary + accent colors with hex codes)
   - **4 Ready-to-Use Prompts** for AI logo generators:
     - Prompt 1: Lettermark Style (for ChatGPT/Claude/Midjourney)
     - Prompt 2: Abstract Symbol Style
     - Prompt 3: Iconographic Style
     - Prompt 4: Wordmark Style
   - Deliverables Checklist (3 variants, color versions, file naming)
   - Style References (SaaS logos: Stripe, Notion, Linear, Vercel)

2. **Inform User Explicitly**:
   > "Logo design brief has been created in `docs/specs/LOGO_DESIGN_BRIEF.md` (Xkb). Please generate a logo using one of the 4 available prompts (copy-paste into ChatGPT/Claude/Midjourney/LogoAI). Once the logo is ready, save the SVG files to `/assets/logo/` and proceed to Step 0B (SITEMAP.md). **Alternatively, if you want to skip with a placeholder logo for now, we can proceed with a placeholder and you can generate the logo later before launch.**"

3. **Wait for User Decision** (Do NOT proceed automatically):
   - User generates logo now → Wait for logo files, then proceed to Step 0B
   - User wants placeholder → Proceed to Step 0B with placeholder logo note

**Why This is Mandatory**:
- Logo colors inform the primary/accent color palette in `DESIGN.md`
- Logo style (geometric/rounded/modern) informs design system tokens
- Generating brief upfront prevents color/style mismatches later
- User can generate logo asynchronously without blocking Module 04 progress

**Template**: Use `templates/02-design/LOGO_DESIGN_BRIEF_TEMPLATE.md` (if not exists, create inline using the structure above).

---

### Step 0B: Generate SITEMAP.md (MANDATORY - Information Architecture)
**PREREQUISITE for all workflows (Manual, AI, or Hybrid)**

1. **Read SCOPE_STATEMENT.md** from Module 02:
   - Extract all user stories (As a [role], I want to [action], so that [benefit])
   - Group by module/feature area (Documents, Users, Settings, etc.)
   - Identify public vs authenticated pages
   - Map role-based access (admin-only screens, user screens)

2. **Create `docs/specs/SITEMAP.md`** with structure:
   - **Public Pages**: Root `/`, login, signup, password reset
   - **Authenticated Pages**: Dashboard, main modules, settings
   - **Screen Count by Module**: Table with screen count breakdown per module
   - **Navigation Structure**: Top nav, sidebar (if applicable), breadcrumbs

3. **Verify Completeness**:
   ```powershell
   # Check file exists
   Test-Path "docs/specs/SITEMAP.md"
   
   # If FALSE: STOP and report error
   # If TRUE: Read file and verify screen count matches scope
   ```

4. **Screen Count Validation**:
   - Count total screens in SITEMAP.md
   - Compare with scope from SCOPE_STATEMENT.md
   - **GATE**: If mismatch >10% (missing screens or out-of-scope screens):
     - Report discrepancy to user
     - Ask: "Scope in SITEMAP has X screens, but SCOPE_STATEMENT only mentions Y user stories. Are there missing or out-of-scope screens?"
     - WAIT for user confirmation before proceeding

5. **Inform User**:
   > "SITEMAP.md has been created at `docs/specs/SITEMAP.md` (Xkb) with a total of [X] screens. Breakdown per module: Public (4), Dashboard (1), Documents (4), Settings (3), Admin (3). Please review the navigation structure before proceeding to workflow selection (Manual Figma / AI-Assisted / Hybrid)."

6. **WAIT for User Approval**:
   > "Is this sitemap structure correct? If yes, choose a workflow:
   > - **A) Manual Figma** (2-3 weeks, pixel-perfect)
   > - **B) AI-Assisted** (1-3 days, direct code)
   > - **C) Hybrid** (3-5 days, AI + manual polish)
   > 
   > Type A/B/C to proceed, or request changes to the sitemap."

**Why This is Mandatory**:
- Sitemap = blueprint for all screens (prevents missing pages in design)
- Screen count validation = early detection of scope creep
- Navigation structure locked early = consistent UX flow
- Prerequisite for effort estimation (18 screens vs 50 screens = different timeline)

**Template**: Use structure from Section 2A (SITEMAP.md - Information Architecture)

**Example Terminal Command** (if SITEMAP.md missing):
```powershell
# GATE CHECK - Step 0B
if (-not (Test-Path "docs/specs/SITEMAP.md")) {
    Write-Error "STEP 0B FAILED: File docs/specs/SITEMAP.md not found."
    Write-Error "Module 04 CANNOT proceed to Step 1 without SITEMAP.md."
    Write-Error "Generate SITEMAP.md first based on SCOPE_STATEMENT.md."
    exit 1
}

# Verify file not empty
$sitemapContent = Get-Content "docs/specs/SITEMAP.md" -Raw
if ($sitemapContent.Length -lt 500) {
    Write-Error "SITEMAP.md is too short (<500 chars). Ensure complete screen inventory."
    exit 1
}

Write-Host "✅ STEP 0B PASS: SITEMAP.md verified ($(($sitemapContent.Length)) bytes)"
```

---

### Step 1: Formulating `DESIGN.md` Guardrails (ANTI-SLOP MANDATORY)
Use template at `templates/02-design/DESIGN_MD_TEMPLATE.md` with **STRICT ANTI-SLOP RULES**:

#### 1.1 Color Palette (FLAT COLORS ONLY)
**Primary/Accent (Pick ONE):**
- From logo color palette if available, OR
- Placeholder: `#0891B2` (Cyan-600) for fintech/SaaS, `#3B82F6` (Blue-500) for enterprise B2B
- **FORBIDDEN:** Purple gradients (`#A855F7` → `#EC4899`), neon colors, rainbow palettes

**Neutrals (Zinc Scale):**
- Background Light: `#FFFFFF`
- Background Dark: `#09090B` (Zinc-950) — NOT pure black `#000000`
- Text Primary: `#3F3F46` (Zinc-700) — readable, high contrast (9.73:1 on white)
- Text Secondary: `#71717A` (Zinc-500)
- Border: `#E4E4E7` (Zinc-200)
- **FORBIDDEN:** Gray scale with blue tint (`#CBD5E1` Slate), custom grays outside Tailwind default

**Semantic Colors:**
- Success: `#10B981` (Emerald-500)
- Warning: `#F59E0B` (Amber-500)
- Error: `#EF4444` (Red-500)
- Info: `#3B82F6` (Blue-500)

#### 1.2 Typography (NO EXOTIC FONTS)
**Font Families:**
- UI/Body: **Inter** (weights: 400, 500, 600, 700 ONLY)
- Monospace/Code: **JetBrains Mono** (weights: 400, 700 ONLY)
- **FORBIDDEN:** Fancy display fonts (Recoleta, Clash Display, Syne), handwriting fonts, font weights outside 400-700

**Type Scale:**
- H1: 48px/700, line-height 1.1, letter-spacing -0.02em
- H2: 36px/600, line-height 1.2
- H3: 24px/600, line-height 1.3
- Body: 16px/400, line-height 1.6
- **FORBIDDEN:** Line-height < 1.4 for body text (readability), all-caps body text

#### 1.3 Borders & Radius (SUBTLE ONLY)
**Borders:**
- Width: **1px solid** (default for all cards, inputs, buttons outline)
- **FORBIDDEN:** 2px+ thick borders, dashed/dotted borders, gradient borders

**Border Radius:**
- Cards: 8px (`rounded-lg`)
- Buttons: 6px (`rounded-md`)
- Inputs: 6px (`rounded-md`)
- **FORBIDDEN:** `rounded-3xl` (24px+), `rounded-full` on non-circular elements, asymmetric radius

#### 1.4 Shadows (FLAT > DEPTH)
**Default Shadow (cards, dropdowns):**
```css
box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1); /* Tailwind shadow-sm */
```

**Hover Shadow (interactive elements):**
```css
box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Tailwind shadow-md */
```

**FORBIDDEN:**
- `shadow-2xl` (0 25px 50px) — too dramatic
- Colored shadows (`shadow-cyan-500/50`)
- Multiple layered shadows
- Inner shadows for "neumorphism" effect

#### 1.5 Effects & Animations (MINIMAL)
**Allowed:**
- Hover state: opacity change (0.9), subtle shadow lift
- Focus state: 2px outline in primary color, 3px offset
- Transitions: 200ms ease-out (NO 500ms+ bouncy animations)

**FORBIDDEN:**
- Gradients (linear-gradient, radial-gradient) — use flat colors
- Glassmorphism (`backdrop-blur-lg`, `bg-white/10`)
- Parallax scrolling
- Floating/levitating cards (`transform: translateY(-10px)`)
- Animated gradients (gradient position shift)
- Skeleton loaders with shimmer animation (use static gray blocks)
- Text fade-in per character (Framer Motion stagger)
- 3D transforms (`rotateX`, `rotateY`, `perspective`)

#### 1.6 Layout (GRID > ARBITRARY FLOATING)
**Structure:**
- Container: `max-w-7xl mx-auto px-4` (1280px max, centered)
- Grid: 12-column system (Tailwind `grid-cols-12`)
- Spacing: 4px/8px/16px/24px/32px increments (Tailwind default scale)

**FORBIDDEN:**
- Absolute positioned elements without layout reason (floating badges everywhere)
- Overlapping cards (z-index stacking for visual "depth")
- Asymmetric layouts (random element placement)

#### 1.7 Component Reusability (DRY PRINCIPLE)
**Mandatory Shared Components:**
- Button (Primary, Secondary, Destructive variants)
- Input (Text, Email, Password, Number with consistent styling)
- Card (Container with standard border, radius, shadow)
- Table (Zebra stripe rows, sticky header)
- Modal/Dialog (Overlay + centered content)
- Toast/Alert (Success, Warning, Error semantic colors)

**Tech Stack Enforcement:**
- **shadcn/ui** as base (Radix UI primitives for accessibility)
- **NO custom CSS files** (Tailwind utility classes only, config in `tailwind.config.ts`)
- **NO Framer Motion** unless interactive prototype needs demo animations (remove before production)

---

#### 1.8 AI Slop Detection Checklist (MANDATORY REVIEW)

Before finalizing `DESIGN.md`, verify ZERO of these slop indicators exist:

**Visual Slop:**
- [ ] ❌ Purple/pink gradients (`bg-gradient-to-r from-purple-600 to-pink-600`)
- [ ] ❌ Glassmorphism blur (`backdrop-blur-lg bg-white/10`)
- [ ] ❌ Drop shadows > `shadow-md`
- [ ] ❌ Border radius > 12px (except circles/pills)
- [ ] ❌ Colored shadows (`shadow-cyan-500/50`)
- [ ] ❌ Floating cards with `hover:scale-105`
- [ ] ❌ Animated gradient backgrounds

**Code Slop:**
- [ ] ❌ Inline Tailwind classes > 15 per element
- [ ] ❌ Custom `@keyframes` animations for static content
- [ ] ❌ Framer Motion `staggerChildren` for text fade-in
- [ ] ❌ Component abstraction layers > 3 deep (Button → BaseButton → Clickable → Pressable)
- [ ] ❌ CSS variables with `-magic-` or `-epic-` prefixes
- [ ] ❌ Hardcoded pixel values outside Tailwind scale (e.g., `w-[347px]`)

**Content Slop:**
- [ ] ❌ Generic hero headlines ("Unlock Your Potential", "Elevate Your Experience")
- [ ] ❌ Overuse of emoji in UI copy (💥🚀✨ everywhere)
- [ ] ❌ Buzzword density > 10% (synergy, leverage, paradigm, holistic)

---

#### 1.9 Design prototyping Prompt Directive (CRITICAL)


```
DESIGN CONSTRAINTS (ANTI-SLOP):
- NO gradients, glassmorphism, or colored shadows
- Flat colors only: Primary [#HEX], Neutrals Zinc-50 to Zinc-950
- Borders: 1px solid #E4E4E7, radius max 8px
- Typography: Inter font, weights 400/600 only, line-height 1.6
- Shadows: subtle 0 1px 3px rgba(0,0,0,0.1) only
- Layout: Grid-based, NO floating/overlapping elements
- Spacing: Tailwind default scale (4/8/16/24/32px)
- Animations: NONE (static screens for prototype)
```

**Example Full Prompt:**
```
Generate Landing Page (Screen ID: SCR-01) for FreePajak tax SaaS:
(Note: Indonesian locale example for demonstration - replace with your language)

CONTENT:
- Hero section: Headline "Hitung 3 Skema Pajak. Pilih yang Paling Hemat.", 
  subheadline, CTA "Coba Gratis"
- Problem section: 3 pain points with icons
- How It Works: 3 steps with numbers
- Pricing: 2 tiers (Free, Pro)
- Footer: links, copyright

DATA CONTEXT: Indonesian freelancer tax app, Rupiah currency format

DESIGN CONSTRAINTS (ANTI-SLOP):
- NO gradients, glassmorphism, or colored shadows
- Flat colors: Primary #0891B2 (Cyan-600), Neutrals Zinc-50 to Zinc-950
- Borders: 1px solid #E4E4E7, radius 8px
- Typography: Inter font, weights 400/600, line-height 1.6
- Shadows: 0 1px 3px rgba(0,0,0,0.1) only
- Layout: Grid-based, max-w-7xl container
- Spacing: Tailwind scale (px-4, py-8, gap-6)
```

---

#### 1.10 Post-Generation Review (MANDATORY BEFORE DESIGN FREEZE)

After Stitch generates screens, **MANUALLY REVIEW** each screen for slop:

**Review Checklist (Per Screen):**
1. [ ] Open screen preview in browser DevTools
2. [ ] Inspect CSS: Search for `gradient`, `blur`, `shadow-` (check if > `shadow-md`)
3. [ ] Check colors: Only Primary + Zinc scale (NO purple, pink, rainbow)
4. [ ] Measure border-radius: Max 8px (use DevTools Inspect)
5. [ ] Count Tailwind classes per element: Max 15 (refactor to component if >15)
6. [ ] Test contrast: All text ≥4.5:1 ratio (use WebAIM Contrast Checker)
7. [ ] Verify typography: Only Inter/JetBrains Mono, weights 400-700

**If Slop Detected:**
- Regenerate screen with stricter prompt directive, OR
- Manually edit exported HTML/CSS to remove slop, OR
- Reject screen and document issue for client review

**Approval Gate:**
- Solo product: Self-review checklist above
- Client project: Walk client through checklist, get written approval per screen batch

### Step 2: Registration to Design prototyping via Tooling
1. Create a new project container:
2. Convert `DESIGN.md` file into base64, then upload:
3. Apply the Design System to the project:
   `stitch_create_design_system_from_design_md(projectId="...", ...)`

### Step 3: Generating All Screens (Phased Coverage for Enterprise)
- **Small/Medium Scale (<50 screens)**: 100% exhaustive coverage in a single phase. Truncation is FORBIDDEN.
- **Large/Enterprise Scale (≥50 screens)**: Phased approach to prevent context exhaustion:
  - **Phase 1 (MVP Screens)**: Core user flows (login, dashboard, primary CRUD, checkout) — max 30-40 screens
  - **Phase 2 (Admin/Secondary)**: Admin panels, reports, settings — remaining screens
  - Document phasing plan in `DESIGN_SPEC.md` before starting.
- Include real Indonesian business data context (rupiah format, legal/business terminology, city names).
- Mandatory defensive states: request *Empty State* and *Loading Skeleton* screens.
- Record the `screen_id` of **every successfully generated screen** into the inventory table in `DESIGN_SPEC.md`.

### Step 4: Assembling the Complete Clickable Demo
1. Retrieve HTML/CSS component code from Stitch for all screens.
2. Add standard routing hyperlink tags to link button flows:
   - "Login" button → navigates to `/dashboard`
   - "Create New Document" button → navigates to `/documents/new`
   - "Save Draft" button → displays success modal/toast and navigates to `/documents/:id`
3. Deploy code to a free staging URL (Vercel / Cloudflare Pages) so it can be opened directly by the client on mobile or laptop to test the complete 100% flow.

### Step 5: Walk-Through & Design Freeze
1. Schedule a demo session with **Client Single PIC** (or self-review for solo product).
2. Let the client test clicking and typing forms in the live demo across all screens.
3. Secure written approval: *Visual layout and navigation flow are officially FROZEN. Subsequent layout changes enter the Change Request (CR) scheme.*

---

## 4. Adaptation Based on Project Scale

| Parameter | Small Scale (MVP / Freelance) | Medium Scale (B2B SaaS / Agency) | Large Scale & Enterprise |
| :--- | :--- | :--- | :--- |
| **Screen Coverage** | **100% of all pages** in Scope (no reductions) | **100% of all pages** in Scope (no reductions) | **Phased if ≥50 screens**: Phase 1 (MVP core), Phase 2 (admin/secondary) |
| **Demo Media** | Stitch Viewer Link / Live Preview | Live Staging Web (Vercel/Cloudflare) | Live Staging Web + Accessibility Audit Document |
| **Design Compliance** | Standard visual contrast ≥4.5:1 | WCAG AA verified on forms | Full WCAG AA audit (Keyboard nav, Screen reader) |
| **Approval** | Written confirmation via email/chat | Signed Design Freeze sheet | Formal Design Sign-Off & UI Review Minutes |

---

## 5. User Testing & Iterative Validation

After the interactive Stitch prototype is complete, user testing is **MANDATORY** before the final design freeze. Skipping this phase merely shifts usability issues to post-launch (5x more expensive to fix).

### 5.1 User Testing Plan (Template: `templates/02-design/USABILITY_TEST_PLAN_TEMPLATE.md`)

**For each iteration:**
- **Test Objectives**: Validate 3-5 critical user journeys (example: "New user can complete onboarding in <5 minutes without assistance")
- **Participant Recruitment**: Minimum **5 users per iteration** (Nielsen Norman standard to uncover 85% of usability issues)
- **Screening Criteria**: Target demographic matching persona (example: "HR admin at a company with 50-500 employees, familiar with Excel")
- **Incentive Structure**: E-commerce voucher Rp 100-200k/session (30-45 minutes), or product credit for B2B SaaS

### 5.2 Usability Testing Protocol

**Task Scenarios** (Representative User Journeys):
- Write 5-7 realistic scenarios without navigation hints (example: "Imagine it is your first day on the job. Create an account and add 3 new employees to the system.")
- Avoid UI keywords ("click the Login button") → use user intent ("log into your account")

**Think-Aloud Protocol**:
- Ask participants to describe their thoughts while working on tasks
- Moderator MUST NOT give hints, only prompt: "What are you thinking right now?"

**Observation Checklist**:
- Task completion rate (success/failure)
- Time on task (compare with baseline target)
- Error rate and recovery path
- Verbatim quotes for pain points

**Post-Test Questionnaire** (SUS - System Usability Scale):
- 10 standard questions, Likert scale 1-5
- Score 0-100 (calculated using SUS formula)
- Template: `templates/02-design/USABILITY_TEST_PLAN_TEMPLATE.md`

### 5.3 Iteration Cycle (Mandatory Loop)

```text
[ Prototype v1 ] → [ Test (5 users) ] → [ Analyze SUS + Pain Points ] → [ Iterate Design ]
       ↑                                                                        │
       └────────────────────────────────────────────────────────────────────────┘
       (Min 2 Iterations)
```

**Success Criteria** (Industry Standard - Sauro & Lewis):
- **SUS Score ≥70**: Acceptable (C grade) — Minimum to proceed to development
- **SUS Score ≥80**: Good (B grade) — Target for competitive products
- **SUS Score ≥90**: Excellent (A grade) — World-class UX

**Minimum 2 Iterations** before design freeze:
- Iteration 1: Uncovering major blockers (navigation confusion, missing features)
- Iteration 2: Refinement (labeling, visual hierarchy, micro-interactions)

> ⚠️ **GATE RULE**: SUS Score <70 on the 2nd iteration → MANDATORY 3rd iteration before proceeding to Module 05.

### 5.4 A/B Testing Hypothesis (Template: `templates/02-design/AB_TEST_HYPOTHESIS_TEMPLATE.md`)

Use to test controversial design alternatives (example: dashboard layout, CTA wording).

**Hypothesis Format** (Measurable & Falsifiable):
```
We believe [CHANGE X]
will result in [OUTCOME Y]
We will measure [METRIC Z]
We will know we're right when [SUCCESS CRITERIA]
```

**Example**:
```
We believe moving "Export Report" button from dropdown menu to primary toolbar
will result in 30% increase in report export usage
We will measure click-through rate on Export button
We will know we're right when CTR ≥15% (baseline: 11.5%) after 2 weeks with 500+ sessions
```

**Sample Size Calculation**:
- Use online calculators (Optimizely, VWO) with inputs: baseline conversion rate, minimum detectable effect (MDE), statistical power (80%), significance (α=0.05)
- Typical B2B SaaS: 200-500 users per variant for MDE 20%

**Test Duration**: Minimum 1 full business cycle (B2B: 1-2 weeks, e-commerce: 3-7 days)

### 5.5 Accessibility Audit (WCAG 2.1 Level AA Compliance)

**Pre-Development Checklist** (Perform on Stitch Prototype):
- [ ] **Contrast Ratio**: Text ≥4.5:1, Large text ≥3:1 (use WebAIM Contrast Checker)
- [ ] **Keyboard Navigation**: All interactions can be performed without a mouse (Tab, Enter, Esc, Arrow keys)
- [ ] **Focus Indicators**: Visible focus state on all interactive elements (outline 2px solid)
- [ ] **Screen Reader Testing**: Test with NVDA (Windows) or VoiceOver (Mac) for 3 critical paths
- [ ] **Form Labels**: All input fields have `<label>` or `aria-label`
- [ ] **Error Messages**: Descriptive and programmatically associated with fields (`aria-describedby`)

**Tools**:
- Chrome Lighthouse Accessibility Audit (target score ≥90)
- axe DevTools browser extension (zero critical/serious issues)

> 📖 **Reference Guide**: `references/pm/PM_USER_TESTING_GUIDE.md` — Best practices, common pitfalls, and iterative testing case studies.

### 5.6 Testing Tools Integration

| Tool | Use Case | Pricing Tier for Solo/Small Team |
| :--- | :--- | :--- |
| **UserTesting.com** | Remote moderated/unmoderated testing | $49/video (pay-as-you-go) |
| **Maze** | Unmoderated prototype testing + heatmaps | Free tier: 1 project, 50 responses/month |
| **Hotjar** | Session recordings, heatmaps, surveys (post-launch) | Free tier: 35 sessions/day |
| **Typeform** | Post-test SUS questionnaires | Free tier: 10 questions, 100 responses/month |
| **Optimal Workshop** | Card sorting, tree testing (IA validation) | Free tier: 1 study, 10 participants |

**Recommended Stack for Limited Budget**:
- **Pre-Launch**: Maze (prototype testing) + Google Forms (SUS questionnaire) + Manual screen reader testing
- **Post-Launch**: Hotjar (behavior analytics) + Typeform (NPS/feedback)

---

## 6. Gate Exit Criteria [GATE]

[GATE] Module 04 is declared **PASSED** if:

### Mandatory Files Verification (BLOCKING):
- [x] **`docs/specs/LOGO_DESIGN_BRIEF.md` exists** (≥500 bytes, contains 4 prompts)
- [x] **`docs/specs/SITEMAP.md` exists** (≥500 bytes, contains screen count table)
- [x] **`docs/harness-root/DESIGN.md` exists** (staged, ≥1000 bytes, contains color palette + typography)
- [x] **`docs/specs/DESIGN_SPEC.md` exists** (≥2000 bytes, contains screen specs)
- [x] **Screen count match**: SITEMAP.md total = DESIGN_SPEC.md screen inventory (±10% tolerance)

### Design Quality (BLOCKING):
- [x] **Anti-slop compliance**: Zero gradients, zero glassmorphism, shadows ≤4px blur
- [x] **Contrast ratio ≥4.5:1** for all text (WCAG AA)
- [x] **Accessibility audit**: Zero critical issues (Lighthouse ≥90 or manual WCAG checklist)

### User Testing (OPTIONAL for MVP, MANDATORY for Client Projects):
- [x] **Minimum 2 iterations of user testing** with 5+ users per iteration (if client project)
- [x] **SUS Score ≥70** (Acceptable) on the final iteration (if user testing conducted)

### Design Freeze Sign-Off (BLOCKING):
- [x] **Design Freeze approval** embedded in DESIGN_SPEC.md with:
  - Approver name (Client PIC or solo developer self-approval)
  - Approval date (YYYY-MM-DD)
  - Signature placeholder (digital signature or statement: "Approved via [email/chat]")

### Optional (Workflow-Dependent):
- [ ] Interactive prototype URL accessible (if AI-Assisted/Hybrid workflow with live demo)
- [ ] Figma project link (if Manual Figma workflow)
- [ ] Exported assets in `/assets/design/` (if manual mockups)

---

## 🛑 PROTOCOL [GATE] EXIT & MANDATORY STOP

**STEP 0: Determine Workflow** (Manual/AI/Hybrid) → User selects A/B/C before file generation

**STEP 1: File Existence Verification (MANDATORY - Run BEFORE declaring complete)**

```powershell
# GATE CHECK - Module 04 File Verification
# Run this PowerShell script to verify all mandatory files exist

$requiredFiles = @(
    @{Path="docs/specs/LOGO_DESIGN_BRIEF.md"; MinSize=500},
    @{Path="docs/specs/SITEMAP.md"; MinSize=500},
    @{Path="DESIGN.md"; MinSize=1000},
    @{Path="docs/specs/DESIGN_SPEC.md"; MinSize=2000}
)

$allPassed = $true

foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file.Path)) {
        Write-Error "❌ GATE FAILED: File $($file.Path) not found."
        $allPassed = $false
    } else {
        $size = (Get-Item $file.Path).Length
        if ($size -lt $file.MinSize) {
            Write-Error "❌ GATE FAILED: File $($file.Path) is too small ($size bytes < $($file.MinSize) bytes minimum)."
            $allPassed = $false
        } else {
            Write-Host "✅ $($file.Path) verified ($size bytes)"
        }
    }
}

if (-not $allPassed) {
    Write-Error "`n🛑 MODULE 04 GATE FAILED: Missing or incomplete files. CANNOT proceed to Module 05."
    exit 1
}

Write-Host "`n✅ MODULE 04 FILE VERIFICATION PASSED - All mandatory files exist."
```

**STEP 2: Content Verification (MANDATORY)**

Agent must execute the following checks BEFORE declaring Module 04 complete:

```python
# Pseudo-code for agent verification
def verify_module_04():
    # 1. Read SITEMAP.md and count screens
    sitemap = read_file("docs/specs/SITEMAP.md")
    sitemap_screen_count = extract_screen_count(sitemap)  # Parse "Total Screens: X"
    
    # 2. Read DESIGN_SPEC.md and count screen specs
    design_spec = read_file("docs/specs/DESIGN_SPEC.md")
    spec_screen_count = count_screen_sections(design_spec)  # Count "## Screen: ..." sections
    
    # 3. Verify match (±10% tolerance)
    if abs(sitemap_screen_count - spec_screen_count) > (sitemap_screen_count * 0.1):
        raise GateError(f"Screen count mismatch: SITEMAP ({sitemap_screen_count}) vs DESIGN_SPEC ({spec_screen_count})")
    
    # 4. Verify DESIGN.md contains required sections
    design_md = read_file("docs/harness-root/DESIGN.md")  # Staged path during M04, deployed to root in M06
    required_sections = ["Color Palette", "Typography", "Spacing", "Components"]
    for section in required_sections:
        if section not in design_md:
            raise GateError(f"DESIGN.md missing section: {section}")
    
    # 5. Verify Design Freeze Sign-Off exists
    if "Approved by:" not in design_spec or "Date:" not in design_spec:
        raise GateError("Design Freeze Sign-Off missing in DESIGN_SPEC.md")
    
    # 6. Anti-slop check (search for violations)
    violations = []
    if "gradient" in design_md.lower() or "linear-gradient" in design_md.lower():
        violations.append("Gradient detected in DESIGN.md")
    if "backdrop-blur" in design_md.lower() or "glassmorphism" in design_md.lower():
        violations.append("Glassmorphism detected")
    if "shadow-2xl" in design_md or "shadow-xl" in design_md:
        violations.append("Excessive shadow detected (>shadow-md)")
    
    if violations:
        raise GateError(f"Anti-slop violations: {', '.join(violations)}")
    
    return True
```

**STEP 3: Report Summary to User**

After all checks pass, display a summary:

```
✅ MODULE 04 COMPLETE - Design Deliverables Ready

Files Generated:
- ✅ LOGO_DESIGN_BRIEF.md (11.2KB) - 4 AI prompts ready
- ✅ SITEMAP.md (6.8KB) - 18 screens mapped
- ✅ DESIGN.md (12.4KB) - Design tokens defined
- ✅ DESIGN_SPEC.md (34.7KB) - Screen specs complete

Quality Checks:
- ✅ Screen count match: SITEMAP (18) = DESIGN_SPEC (18)
- ✅ Anti-slop compliance: 0 violations
- ✅ Accessibility: Contrast ratio ≥4.5:1 verified
- ✅ Design Freeze: Approved by [Name] on [Date]

[Optional - If prototype exists]
- ✅ Interactive Prototype: [URL or Figma link]

---

Next Steps:
1. User review all 4 files (spot-check content accuracy)
2. If corrections needed: Request changes now (before Module 05)
3. If approved: Confirm "Design Freeze approved, proceed to Module 05"

⚠️ WAITING FOR USER CONFIRMATION - Do NOT proceed to Module 05 automatically.
```

**STEP 4: STOP & Wait for User Approval**

**STRICTLY FORBIDDEN** to proceed to Module 05 within the same turn. The agent must:
1. **END TURN** after displaying summary
2. **WAIT** for explicit user approval: "Design approved" or "Proceed to Module 05"
3. Only proceed after user confirmation received

**If user requests changes**:
- Re-generate affected file(s)
- Re-run GATE verification
- Display updated summary
- Wait for approval again

**If user approves**:
- Proceed to Module 05 (Architecture & FSD)
- Carry forward DESIGN.md + DESIGN_SPEC.md as references for technical specs

---

> **AUTHORITATIVE WORKFLOW OVERRIDE**
>

## 7. Workflow Split: Planning (Hermes) vs Development (PC with MCP Stitch)

**Use Case**: User conducts planning/PM/design specification in Hermes (chat AI), then executes UI generation & development on a local PC with MCP Stitch.

### 7.1 Phase A: Planning & Design Specification (Hermes)

**Deliverables created in Hermes**:

1. ✅ **`docs/specs/LOGO_DESIGN_BRIEF.md`** (~11KB)
   - 4 AI prompts to generate logo (ChatGPT/Claude/Midjourney)
   - Color palette recommendation (primary + accent hex codes)
   - Style references (SaaS logos: Stripe, Notion, Linear)

2. ✅ **`docs/harness-root/DESIGN.md`** (staged for deployment after scaffold, ~8-15KB)
   - Color palette (primary, background, text, border with hex codes)
   - Typography (font families, weights, line heights, letter-spacing)
   - Component inventory (buttons, cards, forms, tables, modals)
   - **Anti-slop guardrails** (NO gradients, NO glassmorphism, shadow max 4px, contrast ≥4.5:1)
   - Design tokens (spacing 4px grid, border radius 6-8px, border width 1px)

3. ✅ **`docs/specs/DESIGN_SPEC.md`** (~20-40KB)
   - Sitemap (10-15 pages with routes)
   - Screen ID per page (SCR-001, SCR-002, SCR-003, ...)
   - Section breakdown per screen (header + hero + cards + table + footer)
   - 5-state matrix per screen (Default, Loading, Empty, Error, Success)
   - Wireframe ASCII (optional text-based layout sketch)
   - Component specs (size, spacing, interaction states)

4. ✅ **`data/regulations/*.json`** (if data assets exist, e.g., FreePajak)
   - `pph21-rates.json` (tax brackets with version, source, effective date)
   - `ptkp-values.json` (tax-free allowance categories)
   - `pph23-rates.json`, `pp20-2026.json`, etc.
   - Metadata: version, source URL, last_updated, changelog

5. ✅ **Design prototyping Prompt Files** (optional — pre-write prompts for each screen)
   - `stitch-prompts/01-landing-page.txt` (10-20 lines: layout + strict style + components)
   - `stitch-prompts/02-dashboard.txt`
   - `stitch-prompts/03-calculation-form.txt`
   - Format: Layout sections, Style (STRICT anti-slop), Components list, References

**How to Export from Hermes to PC**:

```bash
# User action (in Hermes chat):
# 1. Request: "Export all Module 04 deliverables to a single archive"
# 2. Hermes creates tar.gz at /opt/data/workspace/ or /opt/data/home/project/[name]/
# 3. User downloads via file browser or scp/rsync

# Example terminal command (Hermes executes):
cd /opt/data/home/project/freepajak
tar -czf ../freepajak-design-export-$(date +%Y%m%d).tar.gz   DESIGN.md   docs/specs/LOGO_DESIGN_BRIEF.md   docs/specs/DESIGN_SPEC.md   data/regulations/*.json   stitch-prompts/*.txt

# Output: /opt/data/home/project/freepajak-design-export-20260929.tar.gz
# User downloads this file to PC
```

**Folder structure in archive**:
```
freepajak-design-export/
├── DESIGN.md                              # Root design system tokens
├── docs/
│   └── specs/
│       ├── LOGO_DESIGN_BRIEF.md           # Logo generation prompts
│       └── DESIGN_SPEC.md                 # Screen breakdown + sitemap
├── data/
│   └── regulations/
│       ├── pph21-rates.json               # Tax data assets
│       └── ptkp-values.json
└── stitch-prompts/                        # Optional pre-written prompts
    ├── 01-landing-page.txt
    ├── 02-dashboard.txt
    ├── 03-calculation-form.txt
    └── ...
```

---

### 7.2 Phase B: UI Generation & Development (PC with MCP Stitch)

**User works on local PC with tools**:
- **MCP Server**: `mcp-server-google-stitch` (built-in in Claude Desktop/Codex/OpenCode/Windsurf)
- **Code editor**: VS Code / Cursor / Windsurf
- **AI coding agent**: Claude Desktop, Codex CLI, OpenCode CLI (with MCP Stitch enabled)
- **Framework**: Next.js 15, Tailwind CSS, shadcn/ui

**Workflow on PC**:

#### Step 1: Extract Deliverables
```bash
# On PC
cd ~/projects/freepajak
tar -xzf ~/Downloads/freepajak-design-export-20260929.tar.gz
ls -lh  # Verify DESIGN.md, docs/, data/, stitch-prompts/ extracted
```

#### Step 2: Setup MCP Stitch (if not yet configured)

**Option A: Claude Desktop** (`~/Library/Application Support/Claude/claude_desktop_config.json` on Mac):
```json
{
  "mcpServers": {
    "google-stitch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-google-stitch"],
      "env": {
        "STITCH_API_KEY": "your-google-stitch-api-key-here"
      }
    }
  }
}
```

**Option B: Environment Variable** (if MCP built-in):
```bash
# Add to ~/.bashrc or ~/.zshrc
export STITCH_API_KEY="your-google-stitch-api-key-here"
```

**Get Stitch API Key**:
- Visit https://stitch.withgoogle.com
- Sign in with Google account
- Go to Settings → API Keys → Generate New Key
- Copy key (starts with `sk-stitch-...`)

#### Step 3: Generate UI Screens via MCP Stitch (Autonomous AI Agent)

**User prompt to Claude Desktop / Codex / OpenCode**:
```
Read DESIGN.md and docs/specs/DESIGN_SPEC.md from this project, then generate all 10 screens using Design prototyping MCP.

Project context:
- App: FreePajak (tax calculator for Indonesian freelancers)
- Framework: Next.js 15 + Tailwind CSS + TypeScript
- Design style: Minimalist, flat colors, NO gradients, NO glassmorphism

For each screen in DESIGN_SPEC.md (SCR-001 to SCR-010):
1. Read the corresponding prompt file from stitch-prompts/[screen].txt
   - prompt: content from .txt file
   - screen_id: from DESIGN_SPEC.md (e.g., "SCR-001")
   - design_system: color palette + typography from DESIGN.md
3. Verify output compliance with DESIGN.md anti-slop rules:
   - NO gradients (background must be solid colors only)
   - Shadow blur max 4px (check box-shadow values)
   - Contrast ratio ≥4.5:1 (text on background)
   - Border radius ≤8px (cards), ≤6px (buttons)
4. Export code to Next.js structure:
   - /app/(routes)/[route-name]/page.tsx
   - Tailwind classes only (no inline styles)
   - shadcn/ui components where applicable
5. Update DESIGN_SPEC.md with Stitch URL per screen

After all screens generated:
- Create interactive prototype links (stitch_link_screens)
- Generate accessibility report (WCAG AA compliance)
- Save summary to design-freeze-report.md

Proceed autonomously and report progress every 3 screens.
```

#### Step 4: AI Agent Execution Flow (Autonomous via MCP)

**What the AI agent does** (no user intervention needed):

1. **Read specifications**:
   - `read_file('DESIGN.md')` → Extract color palette (`#0891B2`, `#FFFFFF`, `#18181B`), typography (`Inter`, `600 semibold`)
   - `read_file('docs/specs/DESIGN_SPEC.md')` → Extract screen list (10 screens: SCR-001 to SCR-010, routes `/`, `/dashboard`, `/calculations`, etc.)
   - `read_file('stitch-prompts/01-landing-page.txt')` → Get prompt text for first screen

2. **Generate screen 1** (Landing Page):
   ```javascript
   // MCP tool call
     prompt: `Landing page for FreePajak tax calculator.
     
     Layout:
     - Header: Logo (left), Nav (center), CTA button (right)
     - Hero: H1 "Hitung Pajak Freelancer 3 Skema", subheading, CTA
     - Features: 3 cards (icons + title + description)
     - Footer: Links + copyright
     
     Style (STRICT):
     - Primary color: #0891B2
     - Background: #FFFFFF
     - Text: #18181B (headings), #52525B (body)
     - NO gradients, flat colors only
     - Shadow: max 0 4px 6px rgba(0,0,0,0.1)
     - Border: 1px solid #E4E4E7
     - Font: Inter (600 semibold headings, 400 body)`,
     
     screen_id: "SCR-001",
     design_system: {
       colors: { primary: "#0891B2", background: "#FFFFFF", text: "#18181B" },
       fonts: { body: "Inter", headings: "Inter" }
     }
   })
   ```

3. **Verify anti-slop compliance**:
   ```javascript
   // Agent checks generated code
   const code = stitch_export_code({ screen_id: "SCR-001", format: "nextjs-tailwind" });
   
   // Check for violations
   const hasGradient = code.includes('bg-gradient') || code.includes('linear-gradient');
   const hasShadowLarge = /shadow-\[(.*?)\]/.test(code) && /* blur > 4px */;
   
   if (hasGradient || hasShadowLarge) {
     // Regenerate with stricter prompt
     stitch_regenerate_screen({
       screen_id: "SCR-001",
       prompt: "... (add more explicit NO GRADIENT rule)"
     });
   }
   ```

4. **Export code to Next.js**:
   ```bash
   # Agent writes file
   # File: /app/(marketing)/page.tsx
   export default function LandingPage() {
     return (
       <div className="min-h-screen bg-white">
         <header className="border-b border-zinc-200">
           <div className="container mx-auto px-4 py-4 flex items-center justify-between">
             <img src="/logo.svg" alt="FreePajak" className="h-8" />
             <nav className="flex gap-6">
               <a href="#features" className="text-zinc-600 hover:text-zinc-900">Features</a>
               <a href="#pricing" className="text-zinc-600 hover:text-zinc-900">Pricing</a>
             </nav>
             <button className="bg-cyan-600 hover:bg-cyan-700 text-white px-4 py-2 rounded-md font-semibold">
               Mulai Gratis
             </button>
           </div>
         </header>
         
         <main>
           <section className="container mx-auto px-4 py-20 text-center">
             <h1 className="text-5xl font-bold text-zinc-900">
               Hitung Pajak Freelancer 3 Skema
             </h1>
             <p className="text-xl text-zinc-600 mt-4">
               PPh 21 Pegawai, Bukan Pegawai, dan PP 23 — bandingkan, hemat jutaan
             </p>
             <button className="mt-8 bg-cyan-600 hover:bg-cyan-700 text-white px-8 py-4 rounded-lg font-semibold text-lg">
               Coba Kalkulator Gratis
             </button>
           </section>
           
           {/* Features section */}
           {/* ... */}
         </main>
       </div>
     );
   }
   ```

5. **Update DESIGN_SPEC.md**:
   ```markdown
   ## Screen: Landing Page (SCR-001)
   
   **Route**: `/`
   **Status**: ✅ Generated
   **Stitch URL**: https://stitch.withgoogle.com/p/abc123/s/001
   **Generated**: 2026-09-29
   **Anti-Slop Compliance**: ✅ Pass (0 gradients, 0 violations)
   ```

6. **Repeat for screens 2-10** (Dashboard, Calculation Form, Result Comparison, History, Settings, etc.)

7. **Generate interactive prototype**:
   ```javascript
   // Link screens together
   stitch_link_screens({
     links: [
       { from: "SCR-001", to: "SCR-002", trigger: "button[Mulai Gratis]" },
       { from: "SCR-002", to: "SCR-003", trigger: "card[PPh 21 Pegawai]" },
       // ...
     ]
   });
   
   // Get preview URL
   const prototypeURL = stitch_get_prototype_url({ project_id: "abc123" });
   // Returns: https://stitch.withgoogle.com/p/abc123/preview
   ```

8. **Generate Design Freeze Report**:
   ```markdown
   # Design Freeze Report — FreePajak
   
   **Date**: 2026-09-29
   **Project**: FreePajak Tax Calculator
   **Screens Generated**: 10/10 (100%)
   
   ## Screen Inventory
   
   | Screen ID | Route | Status | Stitch URL | Compliance |
   |-----------|-------|--------|------------|------------|
   | SCR-001 | / | ✅ Approved | [Link](https://stitch.../001) | ✅ Pass |
   | SCR-002 | /dashboard | ✅ Approved | [Link](https://stitch.../002) | ✅ Pass |
   | SCR-003 | /calculations | ✅ Approved | [Link](https://stitch.../003) | ✅ Pass |
   | ... | ... | ... | ... | ... |
   
   ## Anti-Slop Compliance Summary
   
   - ✅ 0 gradients detected (target: 0)
   - ✅ 0 glassmorphism effects (target: 0)
   - ✅ All shadows ≤4px blur (target: ≤4px)
   - ✅ Contrast ratio ≥4.5:1 on all text (WCAG AA pass)
   - ✅ Border radius ≤8px (cards), ≤6px (buttons)
   
   ## Interactive Prototype
   
   **Preview URL**: https://stitch.withgoogle.com/p/abc123/preview
   **Status**: Ready for user testing
   
   ## Next Steps
   
   1. User review prototype (test all 10 screens, check navigation flow)
   2. Accessibility audit (Lighthouse, WAVE, screen reader test)
   3. Design Freeze Sign-Off
   4. Proceed to Module 05 (System Design & Infrastructure)
   
   ---
   
   **Approved by**: [User Name]
   **Date**: ___________
   **Signature**: ___________
   ```

#### Step 5: User Reviews Output on PC

```bash
# Start Next.js dev server
cd ~/projects/freepajak
npm install
npm run dev

# Open browser
open http://localhost:3000
```

**Review checklist**:
- ✅ Visual matches DESIGN.md (colors, typography, spacing)
- ✅ All 10 screens accessible via navigation
- ✅ Interactive prototype works (buttons clickable, forms submittable)
- ✅ No AI slop (gradients, glassmorphism, excessive shadows)
- ✅ Responsive (mobile 375px, tablet 768px, desktop 1440px)
- ✅ Accessibility (keyboard nav, alt text, ARIA labels)

**Run Lighthouse audit**:
```bash
# Chrome DevTools → Lighthouse → Run audit
# Target scores:
# - Performance: ≥90
# - Accessibility: ≥90
# - Best Practices: ≥90
# - SEO: ≥90
```

#### Step 6: Iterate if Needed

**If violations detected**:
```
User to AI agent:
"Screen SCR-002 (Dashboard) has gradient background in hero section, regenerate with strict flat colors only. Reference DESIGN.md anti-slop rules."

AI agent:
[reads DESIGN.md anti-slop section]
[calls stitch_regenerate_screen with updated prompt]
[verifies new output, exports code]
[reports: "SCR-002 regenerated, gradient removed, compliance verified"]
```

---

### 7.3 Deliverables Handoff Back to Hermes (Optional Documentation)

**If user wants to document final state in Hermes for archival**:

```bash
# On PC, create summary to upload to Hermes
cd ~/projects/freepajak
cat > design-freeze-summary.txt <<EOF
FreePajak Design Freeze Summary

Date: 2026-09-29
Screens: 10/10 generated
Anti-Slop Compliance: 100% (0 violations)
Prototype URL: https://stitch.withgoogle.com/p/abc123/preview
Lighthouse Scores: Performance 92, Accessibility 95, Best Practices 90, SEO 94

Design Freeze Approved: Yes
Approver: [User Name]
Date: 2026-09-29

Ready to proceed to Module 05 (System Design & Infrastructure).
EOF

# User pastes this summary into Hermes chat
```

**Hermes agent actions**:
- Update project tracking (mark Module 04 complete)
- Archive design freeze report to `/opt/data/home/project/freepajak/docs/specs/design-freeze-report.md`
- Suggest next steps: "Module 04 complete. Proceed to Module 05 (System Design & Infrastructure) to define database schema, API endpoints, and detailed tech stack?"

---

### 7.4 Summary: Workflow Split Best Practices

| Phase | Location | Tools | Primary Output | Duration |
|-------|----------|-------|----------------|----------|
| **Planning & Spec** | Hermes (chat AI) | web_search, write_file, patch, skill_view | DESIGN.md, DESIGN_SPEC.md, JSON data, Stitch prompts | 4-6 hours |
| **UI Generation** | PC + MCP Stitch | Claude Desktop/Codex/OpenCode + MCP | 10 screens (Next.js code), interactive prototype | 3-5 hours |
| **Review & Iterate** | PC | Browser, Lighthouse, WAVE | Anti-slop verification, accessibility audit | 2-3 hours |
| **Development** | PC | VS Code, Next.js, Supabase, Vercel | Full-stack app implementation | 40-80 hours |
| **Documentation** | Hermes (optional) | read_file, patch, memory | Design freeze archive, project status update | 30 minutes |

**Key Benefits**:
- ✅ **Hermes**: Thinking & Planning (specifications, research, data modeling, prompt engineering)
- ✅ **PC**: Execution (UI generation via MCP, coding, testing, deployment)
- ✅ **No duplication**: Specs created once in Hermes, consumed autonomously by MCP agent on PC
- ✅ **Async workflow**: User can continue planning in Hermes while PC agent generates screens in background
- ✅ **Verifiable output**: Design freeze report with concrete metrics (0 gradients, 95 Lighthouse score, etc.)

**Common Pitfalls to Avoid**:
- ❌ Skipping DESIGN.md → MCP agent generates inconsistent styling across screens
- ❌ Vague Stitch prompts → AI outputs generic templates with gradients/glassmorphism
- ❌ No anti-slop verification → Accepting first MCP output without compliance check
- ❌ Skipping accessibility audit → Launch with WCAG violations (legal risk)
- ❌ No design freeze sign-off → Scope creep during development ("can we change the layout?")

---

## 8. Design System Foundation & Implementation [M04B - Enterprise Extension]

> 🎯 **WHEN TO USE THIS SECTION?**
> - **MANDATORY for Enterprise** projects (regulatory compliance, multi-product platforms)
> - **Optional for Large** projects with 3+ platforms (Web, iOS, Android, Flutter)
> - **Skip for Small/Medium** projects (use base M04 DESIGN.md only)
> - Products with **3+ engineers** requiring visual consistency without manual review
> - Startups planning to **scale design/engineering teams** within 6-12 months
> - Refactoring legacy codebases with **inconsistent UI components** (design debt)
> - Client requests a **white-label solution** or **multi-tenant branding**
>
> **SKIP THIS SECTION IF:**
> - Solo dev MVP <4 weeks with 1-3 screens (Sections 1-7 Design prototyping are sufficient)
> - Throwaway proof-of-concept prototyping
> - Backend API-only or CLI tool without GUI

Comprehensive guide for solo developers and small teams seeking to build, adopt, or audit a Design System. Unlike **Sections 1-7** which focus on prototyping individual screens with Design prototyping, **Section 8** is the strategic foundation for building a design system that is scalable, maintainable, and adoptable across products or organizations.

---

### 8.1 Critical Terminology (Disambiguation)

These terms are often used interchangeably. The definitions below reflect the 2026 industry standard:

| Term | Definition | Concrete Example | Primary Deliverable |
|------|------------|------------------|---------------------|
| **Design System** | Complete ecosystem: design tokens + component library + documentation + governance | Material Design (Google), Polaris (Shopify), Carbon (IBM) | Figma library + React components + docs site |
| **Design Language** | Philosophical visual principles & tone of voice without code implementation | Fluent Design (Microsoft), Human Interface Guidelines (Apple) | PDF guideline, brand book |
| **Pattern Library** | Catalog of UI solutions for common patterns (navigation, forms, data display) | Navigation patterns (drawer, tabs, breadcrumb) | Storybook / Zeroheight |
| **Component Library** | Collection of coded UI components (buttons, inputs, cards) | Chakra UI, Shadcn, MUI, Ant Design | NPM package / Git submodule |
| **Design Tokens** | Atomic variables for visual properties (color, spacing, typography) | `--color-primary-500: #3B82F6;` | JSON / CSS variables / Swift enums |

**Decision Tree: Build vs Adopt**:
```text
Start → Do you need custom branding? 
        ├─ No → Adopt Shadcn (headless) or Chakra (opinionated)
        └─ Yes → Do you have 3+ designers?
                 ├─ No → Adopt + override tokens (Tailwind custom theme)
                 └─ Yes → Build custom DS (this section)
```

---

### 8.2 Strategic Process (Making a Design System)

**Phase 1: Design Audit** - Expose inconsistency debt (47 shades of gray → consolidate to 10).
**Phase 2: Stakeholder Alignment** - Engineering + Product + Design agreement on MVP component set (20 core, not 50).
**Phase 3: Governance Model** - Centralized (small team <10) vs Federated (scale >20) ownership.
**Phase 4: Adoption Roadmap** - Pilot 1 squad first, avoid "big bang" rollout.

**Audit Checklist** (Template: `templates/02-design/DESIGN_SYSTEM_AUDIT_TEMPLATE.md`):
1. **Color Inventory**: Screenshot all unique colors → cluster similar (Delta E < 3)
2. **Typography Audit**: Count font families (max 2-3), map sizes to scale (H1-H6, Body, Caption)
3. **Spacing**: Measure gaps (should be 8pt grid: 8, 16, 24, 32)
4. **Component Duplication**: Find duplicate implementations (3 different "Card" components)

---

### 8.3 Design Tokens (Single Source of Truth)

**Format**: `[category]-[property]-[variant]-[state]`

```css
/* Primitive tokens (raw values) */
--color-blue-500: #3B82F6;
--space-3: 0.5rem;  /* 8px base unit */

/* Semantic tokens (purpose-driven) */
--color-action-primary: var(--color-blue-500);
--font-size-heading-3: var(--font-size-lg);
```

**8pt Spacing Scale**:
```css
--space-3: 0.5rem;    /* 8px - base */
--space-5: 1rem;      /* 16px - comfortable */
--space-8: 2rem;      /* 32px - section gaps */
```

**Platform-Specific Output** (Style Dictionary):
```bash
pnpm add -D style-dictionary
# Config: style-dictionary.config.js
# Outputs: dist/css/variables.css, dist/ios/Tokens.swift, dist/android/tokens.xml
```

---

### 8.4 Core Components (The 20 Essential)

| Priority | Component | Complexity |
|----------|-----------|------------|
| **P0** (Week 1) | Button, Input, Label, Spinner | Low |
| **P1** (Week 2-3) | Select, Checkbox, Radio, Toggle, Card, Modal, Alert, Toast | Medium |
| **P2** (Week 4-5) | Tooltip, Dropdown, Badge, Avatar, Table, Tabs, Accordion, Breadcrumb | Medium-High |

**Stop at P1 for MVP** (12 components). P2 optional.

**Component API Principles**:
1. **Composition over Configuration**: `<Button><Spinner /></Button>` not `<Button loading />`
2. **Controlled vs Uncontrolled**: Provide both, default controlled for forms
3. **Compound Components**: `<Card><Card.Header /><Card.Body /></Card>`

**Accessibility Checklist** (per component):
- Button: Keyboard (`Enter`/`Space`), visible focus, `aria-label` if icon-only
- Modal: Focus trap, Escape key closes, `role="dialog"`, `aria-modal="true"`
- Table: Semantic HTML (`<thead>`, `<tbody>`), `aria-sort` on sortable columns

---

### 8.5 Tooling & Workflow

**Figma Setup**:
```
📂 Design System (Master Library)
  ├─ 🎨 Foundations (Colors, Typography, Spacing)
  ├─ 🧩 Components (Button, Input, Card...)
  └─ 📐 Templates (Auth Flow, Dashboard Layout)
```

**Essential Plugins**:
- **Tokens Studio**: Sync design tokens JSON ↔ Figma
- **A11y Checker**: Flag text <4.5:1 contrast ratio
- **Figma to Code (Anima)**: Export Figma → React scaffolding (70% production-ready)

**CI/CD Pipeline**:
```yaml
# .github/workflows/design-system.yml
jobs:
  build:
    - run: pnpm run build:tokens  # Style Dictionary
    - run: pnpm test:visual        # Chromatic visual regression
    - run: pnpm run deploy:storybook
```

---

### 8.6 Product Management

**Adoption Metrics**:
- **Coverage**: % screens using DS components (target: 80% in 6 months)
- **Consistency Score**: Visual regression pass rate
- **Velocity**: Design-to-code handoff time (baseline vs DS-enabled)

**ROI Calculation**:
```
Time saved: 24h/sprint/engineer
Team size: 5 engineers
Hourly rate: $50
Annual saving: 24 × 50 × 5 × 26 = $156,000
DS maintenance: $80,000
Net ROI: $76,000/year (95% gain)
```

**RFC Process** (for new components):
1. Draft RFC → Post in #design-system Slack
2. 48h comment period
3. Design System Council vote
4. Approved → Assign to sprint

**Breaking Changes Protocol** (3 releases):
```
v1.9.0: Add new API, deprecate old (console.warn)
v1.10.0: Update docs with migration guide
v2.0.0: Remove deprecated API (breaking)
```

---

### 8.7 Output Artifacts

| Artifact | Location | Purpose |
|----------|----------|---------|
| **Component Requirements** | `docs/specs/COMPONENT_REQUIREMENTS.md` | Feature-to-component mapping, prevents AI slop |
| **Design System Audit** | `docs/design/DESIGN_SYSTEM_AUDIT.md` | Baseline inconsistency assessment |
| **Design Tokens Spec** | `tokens/design-tokens.json` + `dist/css/variables.css` | Single source of truth |
| **Component API Spec** | `docs/design/COMPONENT_API_SPEC.md` | Props, states, accessibility |
| **Storybook Docs** | `https://storybook.myapp.com` | Living documentation |

**Template Sources**:
- `templates/02-design/COMPONENT_REQUIREMENTS_TEMPLATE.md`
- `templates/02-design/DESIGN_SYSTEM_AUDIT_TEMPLATE.md`
- `templates/02-design/DESIGN_TOKENS_SPEC_TEMPLATE.md`
- `templates/02-design/COMPONENT_API_SPEC_TEMPLATE.md`

---

### 8.8 Anti-Patterns

| ❌ Anti-Pattern | ✅ Correct Approach |
|----------------|---------------------|
| Build 50 components on Day 1 | Start with 12 P0/P1, iterate |
| No semantic tokens | Two-layer: primitive → semantic |
| Figma without code | Tight sync: Figma = React component |
| Zero governance | RFC process, DS council approval |
| "Design team project" | Cross-functional: designers + engineers co-own |

---

### 8.9 Gate Exit Criteria

Section 8 is declared **PASSED** if:
- [x] Design audit completed with inconsistency quantified
- [x] Design tokens JSON created (primitive + semantic layers)
- [x] Minimum 12 P0/P1 components implemented in Storybook
- [x] WCAG 2.1 AA compliance for all components
- [x] CI/CD setup: Visual regression + NPM publish
- [x] Adoption plan documented (80% coverage target)

**END RESPONSE** and confirm:
> *"Design System foundation is complete: [X] tokens defined, [Y] components implemented. Please review Storybook at [URL]. Ready to proceed to M05 (Architecture & Specs)?"*

---
