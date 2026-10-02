# Design & Architecture Phase TODO Template (Module 04 - Module 05)

> Atomic task checklist template for UI/UX Design, Design System Foundation, System Architecture, and Technical Specifications (FSD & SDD).
> Rules: Execute progressively from design tokens to interactive prototypes, then to technical architecture and API contracts. Complete the entire checklist and obtain formal approval from the client/lead architect before commencing code implementation in Module 06.

---

## Project Metadata
- **Project Name**: [Project / System Name]
- **Lead Product Designer**: [Designer Name]
- **Lead Software Architect**: [Architect / Solo Dev Name]
- **Start Date**: [YYYY-MM-DD]
- **Target Design Phase Completion**: [YYYY-MM-DD]
- **Design Tooling**: Figma / Google Stitch / Penpot / Tailwind CSS
- **Design Gate Status**: [ ] DRAFT | [ ] UNDER REVIEW | [ ] APPROVED / FROZEN

---

## 1. Module 04B: Design System Foundation (Design System Foundation)

### 1.1 Design System Audit & Design Tokens (Design Tokens)
- [ ] `design/tokens/colors.json`: Define semantic color palette (Primary, Secondary, Accent, Neutral/Gray scale, Destructive, Warning, Success, Info) - expect text-to-background contrast passes WCAG 2.1 AA (minimum ratio 4.5:1 for normal text, 3:1 for large text)
- [ ] `design/tokens/typography.json`: Determine modular typography scale (Font families for body & display, font weights, size scale from `text-xs` to `text-4xl`, proportional line-heights) - expect comfortable text legibility across all viewports
- [ ] `design/tokens/spacing-grid.json`: Establish 8-pt / 4-pt grid system and spacing scale (padding, margin, gap: 4px, 8px, 12px, 16px, 24px, 32px, 48px, 64px) - expect consistent vertical and horizontal rhythm
- [ ] `design/tokens/elevation-borders.json`: Configure elevation shadow tokens (*shadows/elevation levels 1-4*) and corner curvature tokens (*border-radius tokens: sm, md, lg, full*) - expect uniform visual depth hierarchy
- [ ] `design/tokens/theme-modes.json`: Set up token variable mappings for Light Mode and Dark Mode - expect seamless theme switching without hardcoded color values

### 1.2 Primitive Component Library & Component API Specifications
- [ ] `design/specs/components/button.md`: Create visual and state specifications for Button component (Variants: Solid, Outline, Ghost, Link; Sizes: sm, md, lg; States: default, hover, focus-visible, active, disabled, loading with spinner) - expect accessible keyboard interaction via Tab & Enter/Space
- [ ] `design/specs/components/form-inputs.md`: Design form input components (Text Input, Textarea, Select/Dropdown, Checkbox, Radio, Switch, File Upload) - expect explicit labels, clean placeholders, helper text, and inline error visuals
- [ ] `design/specs/components/feedback-overlays.md`: Define specifications for Modal/Dialog, Drawer/Sheet, Tooltip, Alert banner, and Toast notification - expect automatic focus trap (*focus trap*) inside active dialogs
- [ ] `design/specs/components/data-display.md`: Design Table component (with header sorting, pagination, empty state), Card, Badge/Tag, Avatar, and Skeleton loader - expect tabular data adapts gracefully to long content
- [ ] `design/specs/component-rfc.md`: Draft Component RFC for complex custom components (e.g., Dynamic Data Table, Drag-and-Drop Uploader, Signature Canvas) - expect TypeScript props contracts and event handlers documented

### 1.3 Accessibility & Responsiveness (A11y & Mobile Ergonomics)
- [ ] `design/specs/accessibility-audit.md`: Verify visual keyboard focus (*outline focus-visible ring*) is never suppressed (`outline: none` prohibited without replacement) - expect visible focus indicator in all browsers
- [ ] `design/specs/mobile-ergonomics.md`: Ensure all touch interaction targets (*touch targets*) measure at least 44x44px on touchscreens - expect no clickable elements placed too closely on mobile
- [ ] `design/specs/breakpoints.md`: Establish responsive breakpoint standards (`sm: 640px`, `md: 768px`, `lg: 1024px`, `xl: 1280px`, `2xl: 1536px`) and layout reflow behavior - expect no unwanted horizontal scrollbars at 375px viewport

---

## 2. Module 04: UI/UX Prototyping (UI/UX Prototyping)

### 2.1 Wireframing & User Flows
- [ ] `design/flows/information-architecture.md`: Map Sitemap and Information Architecture (IA) for application navigation - expect hierarchical menu tree structure maximum 3 levels deep
- [ ] `design/flows/user-flows.md`: Diagram user flows for all Core User Journeys (Onboarding, Authentication, Core Transactions, Account Settings, Error Recovery) - expect every flow has start point, action steps, decision points, and definitive success state
- [ ] `design/wireframes/low-fidelity.md`: Create grayscale low-fidelity wireframes for all primary application screens - expect structural content placement validated before visual styling

### 2.2 Interactive High-Fidelity Prototype
- [ ] `Figma / Stitch Canvas`: Build high-fidelity (Hi-Fi) interface designs for all functional modules:
  - Auth: Login, Register, Forgot Password, Reset Password, 2FA Verification screens
  - Dashboard: Navbar layout, Collapsible sidebar, Statistic Cards, Activity Charts, Quick Data Tables
  - Core Modules: New entity creation forms, Entity detail views, Inline/modal edit modes
  - Settings: Profile management, Team/role configuration, Audit trail, API keys integration
  - expect all typography, color, and component assets utilize official tokens from Module 04B
- [ ] `Interactive Clickable Prototype`: Connect screen frames into an interactive clickable prototype in Figma or Google Stitch - expect end-to-end simulation from login through final transaction confirmation

### 2.3 The 5 Essential UI States Design
- [ ] `design/screens/states/ideal-state.md`: Design views populated with ideal data (*Ideal State*) - expect balanced, harmonic layout
- [ ] `design/screens/states/empty-state.md`: Design views when no data exists (*Empty State*) - expect welcoming illustration, guidance copy, and primary CTA button to trigger first action
- [ ] `design/screens/states/loading-state.md`: Design views while data is loading (*Loading / Skeleton State*) - expect skeleton loaders mirroring actual content silhouettes (avoid single generic full-screen spinners)
- [ ] `design/screens/states/error-state.md`: Design views for system or network failures (*Error State & 404/500 screens*) - expect human-readable error messages without confusing technical jargon, paired with retry / back-to-home actions
- [ ] `design/screens/states/partial-state.md`: Design views for partial data or overflowing text (*Partial / Extreme Overflow State*) - expect proper ellipsis handling (...), clean text wrapping, and graceful fallbacks for missing avatars

### 2.4 Prototype Usability Testing
- [ ] `design/usability/test-plan.md`: Develop usability testing scenarios with 3-5 specific user tasks - expect measurable success criteria (Task Completion Rate, Time on Task)
- [ ] `design/usability/test-execution.md`: Conduct usability testing sessions with at least 5 target user representatives - expect logged observations of friction, misclicks, and confusion points
- [ ] `design/usability/sus-score.md`: Calculate post-test System Usability Scale (SUS) score - expect target SUS score >= 75 (Good/Excellent tier)
- [ ] `design/usability/design-refinements.md`: Iterate and refine prototype design elements based on usability findings - expect changes validated before engineering handoff

---

## 3. Module 05B: System Architecture & Infrastructure (System Design & Infra)

### 3.1 C4 Architecture Diagrams & System Boundaries
- [ ] `docs/02-architecture/c4-context-diagram.md`: Create C4 Level 1 (System Context) Diagram illustrating application system boundaries, external user actors, and third-party integrations (Payment Gateway, Email Provider, R2/S3 Storage, SSO Auth) - expect high-level interaction relationships clearly exposed
- [ ] `docs/02-architecture/c4-container-diagram.md`: Create C4 Level 2 (Container) Diagram detailing Frontend SPA/SSR, Backend REST/GraphQL API Gateway, PostgreSQL Database, Redis In-Memory Cache, and Background Worker queue - expect inter-container communication protocols defined (HTTPS, gRPC, Redis PubSub)
- [ ] `docs/02-architecture/c4-component-diagram.md`: Create C4 Level 3 (Component) Diagram for core system modules (e.g., Auth Module, Billing Engine, Document Processor) - expect clean bounded context boundaries

### 3.2 Architecture Decision Records (ADRs)
- [ ] `docs/02-architecture/adrs/ADR-001-database-selection.md`: Database engine selection decision (e.g., PostgreSQL vs MySQL vs MongoDB) with context analysis, considered alternatives, pros/cons, and consequences - expect justification based on data query patterns and relational integrity
- [ ] `docs/02-architecture/adrs/ADR-002-authentication-strategy.md`: Authentication strategy decision (JWT vs HttpOnly Cookie Sessions vs OIDC/OAuth2) - expect thorough analysis of XSS mitigation and token theft prevention
- [ ] `docs/02-architecture/adrs/ADR-003-state-management-and-rendering.md`: Frontend rendering architecture decision (SSR vs SSG vs SPA CSR) and state management (Zustand / TanStack Query) - expect clear consideration of SEO, TTFB, and caching complexity
- [ ] `docs/02-architecture/adrs/ADR-004-background-job-queue.md`: Asynchronous background queue decision (BullMQ + Redis vs PG-Boss vs Inngest vs Cloud Tasks) - expect retry mechanisms, dead-letter queues (DLQ), and concurrency defined
- [ ] `docs/02-architecture/adrs/ADR-005-storage-and-cdn.md`: Object storage and asset delivery decision (Cloudflare R2 + CDN vs AWS S3 + CloudFront) - expect egress bandwidth cost analysis and secure presigned URL strategies

### 3.3 Capacity Planning & Infrastructure Design (Capacity & Scalability)
- [ ] `docs/02-architecture/capacity-planning.md`: Calculate traffic and storage projections for next 12 months (peak RPS, database read/write throughput, storage growth GB/month) - expect measurable compute instance and database sizing allocations
- [ ] `docs/02-architecture/infrastructure-topology.md`: Design cloud network topology (VPC, Public Subnets for Load Balancers, Private Subnets for DB and App Clusters, Security Group ingress/egress rules) - expect database without public IP access
- [ ] `docs/02-architecture/disaster-recovery-plan.md`: Document Disaster Recovery Plan with target RPO (*Recovery Point Objective* <= 1 hour) and RTO (*Recovery Time Objective* <= 4 hours) - expect automated backup procedures and failover simulations documented

---

## 4. Module 05: Functional Specification Document & API Contracts (FSD)

### 4.1 Functional Specification Document (FSD Technical)
- [ ] `docs/02-architecture/fsd-technical.md`: Detail Authentication & Authorization functional logic (password policies, brute force protection, lockout, role permissions matrix) - expect security business rules covered comprehensively
- [ ] `docs/02-architecture/fsd-technical.md`: Detail functional specifications for each core business feature (input validation, entity state machine flows, mathematical calculations, side effects) - expect zero ambiguous business rules for developers
- [ ] `docs/02-architecture/fsd-technical.md`: Define global system error handling matrix (JSON error response schema: `code`, `message`, `details`, standard HTTP statuses: 400, 401, 403, 404, 422, 429, 500) - expect consistent error formats across all endpoints

### 4.2 Database Schema & Relational Data Modeling (DDL & ERD)
- [ ] `docs/02-architecture/erd-diagram.md`: Create complete Entity Relationship Diagram (ERD) detailing entities, attributes, primary keys, foreign keys, and relationship cardinalities (1:1, 1:N, N:M) - expect structured 3NF normalized data relationship visualization
- [ ] `docs/02-architecture/database-schema.sql` (or `prisma/schema.prisma`): Write complete database schema DDL:
  - Precise data type definitions (UUIDv7/CUID for IDs, `TIMESTAMPTZ` for timestamps, `DECIMAL(12,2)` for financial values)
  - Apply `NOT NULL`, `UNIQUE`, `CHECK`, and `FOREIGN KEY (ON DELETE RESTRICT/CASCADE)` constraints
  - Design efficient indexes (B-Tree indexes for filtering/sorting, composite indexes for compound queries, partial indexes for active statuses)
  - Include mandatory audit columns on every table: `id`, `created_at`, `updated_at`, `deleted_at` (soft deletes where applicable)
  - expect schema free from potential full table scans on large tables
- [ ] `docs/02-architecture/data-dictionary.md`: Compile Data Dictionary explaining the business purpose of each table and column - expect comprehensive data glossary reference

### 4.3 API Contract Specifications (OpenAPI 3.1 / Swagger Spec)
- [ ] `docs/02-architecture/openapi.yaml`: Build OpenAPI 3.1 specification for all RESTful API endpoints:
  - Define structured URL paths (e.g., `/api/v1/auth/login`, `/api/v1/projects`, `/api/v1/projects/{id}/members`)
  - Detail Request Body schemas using comprehensive JSON Schema validation (required fields, string formats, min/max lengths, regex patterns)
  - Detail Response schemas for 200/201 success statuses and all potential error statuses (400, 401, 403, 404, 422, 500)
  - Define Bearer JWT / Cookie Session authentication schemes under Security Schemes
  - expect OpenAPI document passes validation against Swagger/Spectral linters
- [ ] `docs/02-architecture/webhook-contracts.md`: Define specifications for incoming webhooks (Payment Gateway, Email Provider) and outgoing webhooks: payload schemas, HMAC-SHA256 signature verification algorithms, and exponential backoff retry rules - expect idempotent webhook handling

---

## 5. Design Phase Verification Gate (Gate Pass Design to Dev)

| Evaluation Parameter | Minimum Pass Standard | Verification Status | Evidence Notes |
| :--- | :--- | :---: | :--- |
| **Design System & A11y** | Color/typography tokens complete, WCAG 2.1 AA contrast passes, touch targets >= 44px | [ ] PASS | Attached in `design/tokens/` & Figma |
| **Prototypes & 5 States** | Interactive prototype complete, 5 UI states designed across all main screens, SUS >= 75 | [ ] PASS | Attached via Figma link & `design/usability/` |
| **Architecture & ADRs** | C4 Level 1-3 diagrams complete, core ADRs (DB, Auth, Queue, Storage) approved | [ ] PASS | Attached in `docs/02-architecture/adrs/` |
| **FSD & OpenAPI Contracts** | DDL/ERD schema valid and normalized, OpenAPI 3.1 passes Spectral linter | [ ] PASS | Attached in `docs/02-architecture/openapi.yaml` |
| **Client / Lead Sign-Off** | Formal Design & Spec Sign-off signature from business stakeholders | [ ] PASS | Attached written approval document |

### Design Gate Decision:
- [ ] **PASSED (GO TO DEVELOPMENT - M06)**: UI design and all technical specifications locked down. Approved to proceed with repository setup and coding execution in Module 06.
- [ ] **TECHNICAL REVISION (HOLD / ARCHITECTURE REWORK)**: Database schema ambiguity or architectural performance concerns exist. Complete revisions before coding begins.
- [ ] **DESIGN REVISION (HOLD / UX REWORK)**: Prototype flow confusing to users or SUS score < 75. Refine UI prototype before locking API contracts.
