# Component Requirements & UI Pattern Analysis

> **Purpose**: Map PRD features to UI patterns and component inventory BEFORE designing.
> **Input**: `PRD.md` features, user flows, acceptance criteria
> **Output**: Justified component list, interaction states, responsive strategy
> **Duration**: 1-2 hours (prevents AI slop, ensures right-sized design system)

---

## Metadata

- **Project**: [Project Name]
- **Date**: [YYYY-MM-DD]
- **Author**: [Your Name]
- **PRD Version**: [Link to PRD.md]
- **Total Features Analyzed**: [N features]

---

## Input: PRD Feature Summary

> Copy critical features from PRD.md for quick reference

### Feature 1: [Feature Name]
**User Story**: As a [role], I want [goal], so that [benefit]

**Acceptance Criteria**:
- [ ] Criterion 1
- [ ] Criterion 2

---

### Feature 2: [Feature Name]
**User Story**: As a [role], I want [goal], so that [benefit]

**Acceptance Criteria**:
- [ ] Criterion 1
- [ ] Criterion 2

---

(Repeat for all features in PRD)

---

## Feature → UI Pattern Mapping

> For each feature, identify UI patterns needed to implement it

### Feature 1: [Feature Name]

**UI Patterns Needed**:
- Pattern 1: [e.g., "Form layout with validation"]
- Pattern 2: [e.g., "Loading spinner during submission"]
- Pattern 3: [e.g., "Inline error messages"]

**User Interactions**:
- User action 1 → System response 1
- User action 2 → System response 2

**Edge Cases**:
- Empty state: [What shows when no data?]
- Error state: [What shows on failure?]
- Loading state: [What shows during async operations?]

**Components Required**:
- Component A: [e.g., "Input (with error state)"]
- Component B: [e.g., "Button (primary variant)"]
- Component C: [e.g., "FormField (label + input + error wrapper)"]

---

### Feature 2: [Feature Name]

**UI Patterns Needed**:
- Pattern 1
- Pattern 2

**User Interactions**:
- User action → System response

**Edge Cases**:
- Empty state
- Error state
- Loading state

**Components Required**:
- Component X
- Component Y

---

(Repeat for all features)

---

## Component Inventory

> Consolidated list of ALL components needed across features (no duplicates, no generic additions)

### Primitives (Atomic Components)

| # | Component | Variants | States | Usage Count | Justification |
|:--|:----------|:---------|:-------|:------------|:--------------|
| 1 | Button | primary, secondary, ghost, icon-only | default, hover, active, disabled, loading | [N features] | [Feature 1, 3, 5 require form submissions] |
| 2 | Input | text, email, password, number | default, focus, error, disabled | [N features] | [Feature 1 (login), 2 (search), 4 (form)] |
| 3 | Textarea | - | default, focus, error, disabled | [N features] | [Feature 4 (description field)] |
| 4 | Select/Dropdown | single, multi (optional) | closed, open, selected, disabled | [N features] | [Feature 4 (assignee picker), 3 (filter)] |
| 5 | Checkbox | - | unchecked, checked, indeterminate, disabled | [N features] | [Feature X (bulk actions)] |
| 6 | Radio | - | unchecked, checked, disabled | [N features] | [Feature Y (options)] |
| 7 | Badge | status, info, warning, error | - | [N features] | [Feature 5 (task status display)] |
| 8 | Icon | various | - | [All features] | [Navigation, actions, status indicators] |
| 9 | LoadingSpinner | - | spinning | [All data features] | [Global loading indicator] |
| 10 | Link | - | default, hover, visited, active | [N features] | [Navigation between screens] |

**Total Primitives**: [N]

---

### Composite Components (Combinations of Primitives)

| # | Component | Composition | Usage Count | Justification |
|:--|:----------|:------------|:------------|:--------------|
| 1 | FormField | Label + Input/Textarea/Select + Error message | [N forms] | [Standard form field wrapper, DRY principle] |
| 2 | Card | Container + Padding + Border + Shadow | [N features] | [Feature 2 (dashboard widgets), 5 (detail view)] |
| 3 | Modal | Overlay + Dialog + Close button + Focus trap | [N features] | [Feature 5 (delete confirmation), future features] |
| 4 | ConfirmDialog | Modal + Message + Yes/No buttons | [N features] | [Feature 5 (delete task confirmation)] |
| 5 | Table | Header + Body + Row + Cell | [N features] | [Feature 3 (task list)] |
| 6 | Pagination | Previous + Next + Page numbers | [N features] | [Feature 3 (task list pagination)] |
| 7 | EmptyState | Icon + Heading + Description + Optional CTA | [N features] | [Feature 3 (no tasks), 2 (no data)] |
| 8 | Toast | Notification + Auto-dismiss timer | [All features] | [Success/error feedback across all actions] |
| 9 | SearchInput | Input + Search icon + Clear button | [N features] | [Feature 3 (task search)] |

**Total Composite**: [N]

---

### Layout Components (Structure & Spacing)

| # | Component | Purpose | Usage |
|:--|:----------|:--------|:------|
| 1 | Container | Max-width wrapper, horizontal centering | All screens |
| 2 | Grid | Responsive column system | Dashboard, layouts |
| 3 | Stack | Vertical spacing utility | Forms, content blocks |
| 4 | ButtonGroup | Horizontal button layout | Form actions (Cancel + Submit) |

**Total Layout**: [N]

---

### Composite Patterns (Feature-Specific Assemblies)

| # | Pattern | Components Used | Where Used |
|:--|:--------|:----------------|:-----------|
| 1 | StatWidget | Card + Large number typography + Label | Dashboard (Feature 2) |
| 2 | DescriptionList | Key-value pairs (dt/dd) | Task detail (Feature 5) |
| 3 | ToastContainer | Toast queue manager | Global (all features) |

**Total Patterns**: [N]

---

## Component Inventory Summary

- **Primitives**: [N] components
- **Composite**: [N] components
- **Layout**: [N] components
- **Patterns**: [N] components
- **TOTAL**: [N] components

**Excluded (Not Needed for MVP)**:
- ❌ Tabs: No complex navigation within screens
- ❌ Accordion: No collapsible sections required
- ❌ Slider: No numeric range inputs
- ❌ Switch: Using dropdown for status instead
- ❌ File Upload: No file attachments in MVP
- ❌ Rich Text Editor: Plain text descriptions sufficient

---

## Interaction States Matrix

### Per Component

| Component | States | Examples |
|:----------|:-------|:---------|
| Input | default, hover, focus, error, disabled | Focus ring #3B82F6, Error border #EF4444 |
| Button | default, hover, active, disabled, loading | Loading shows spinner, Disabled opacity 0.5 |
| Dropdown | closed, open, selected, disabled | Open shows options list, keyboard navigation |
| Modal | closed, opening, open, closing | Fade in overlay + slide up dialog, 200ms |
| Toast | entering, visible, exiting | Slide in from top-right, auto-dismiss 5s |

---

### Per Screen (5-State Matrix)

All data-driven screens MUST implement:

1. **Idle/Default**: Normal render with data
2. **Loading**: Skeleton loaders (shimmer effect)
3. **Success**: Data loaded successfully (same as idle)
4. **Error**: Error message + retry button
5. **Empty**: Empty state illustration + CTA

**Example: Task List Screen**
- Idle: Table with 10 tasks
- Loading: 5 skeleton rows (gray pulsing rectangles)
- Success: Transition from loading to idle
- Error: Red card "Failed to load tasks. Retry?"
- Empty: Illustration "No tasks found. Create your first task!"

---

### Form States

All forms MUST implement:

1. **Pristine**: Initial state, no user input
2. **Validating**: Client-side validation running
3. **Valid**: All fields pass validation, submit enabled
4. **Invalid**: Errors shown, submit disabled
5. **Submitting**: Loading spinner on submit button, form disabled

---

## Responsive Breakpoints

Based on [N] screens analyzed:

| Breakpoint | Width | Layout Changes |
|:-----------|:------|:---------------|
| **Mobile** | 375px - 767px | Single column, stacked forms, hamburger menu |
| **Tablet** | 768px - 1023px | 2 columns for dashboard, table horizontal scroll |
| **Desktop** | 1024px+ | 3 columns for dashboard, full table, sidebar navigation |

**Critical responsive decisions**:
- **Mobile navigation**: Hamburger menu (not bottom nav)
- **Dashboard grid**: 3 cols desktop → 2 cols tablet → 1 col mobile
- **Table overflow**: Horizontal scroll on mobile (not card view)
- **Forms**: Always single column (even desktop)

---

## Accessibility Requirements

### Per Component

| Component | ARIA Attributes | Keyboard Support | Screen Reader |
|:----------|:----------------|:-----------------|:--------------|
| Input | aria-label, aria-invalid, aria-describedby | Tab to focus, Esc to clear | Announces label + error |
| Button | aria-disabled, aria-busy | Enter/Space activates, Tab navigation | Announces state changes |
| Modal | aria-modal, role="dialog" | Esc to close, Tab traps focus | Announces dialog open/close |
| Dropdown | aria-expanded, aria-haspopup | Arrow keys navigate, Enter selects | Announces expanded state |
| Table | scope="col" (headers), scope="row" | Arrow keys navigate cells | Announces row/column |

---

### Global Patterns

| Pattern | Implementation |
|:--------|:---------------|
| **Focus management** | Visible focus ring (2px solid #3B82F6, offset 2px) |
| **Skip links** | "Skip to main content" at top (hidden until focused) |
| **Color contrast** | WCAG AA minimum (4.5:1 for body text, 3:1 for large text) |
| **Touch targets** | Minimum 44×44px (mobile buttons, icon buttons) |
| **Screen reader announcements** | role="status" for success, role="alert" for errors |

---

## Animation Requirements

> Subtle animations for polish, not decoration

| Element | Animation | Duration | Easing | Rationale |
|:--------|:----------|:---------|:-------|:----------|
| Button (click) | scale(0.98) | 100ms | ease-out | Tactile feedback |
| Modal (open) | Overlay fade + Dialog slide-up | 200ms | ease-out | Smooth entrance |
| Toast (enter) | Slide from top-right | 300ms | ease-out | Draw attention |
| Dropdown (open) | Fade + scale(0.95) from top-left | 150ms | ease-out | Natural expansion |
| Page transitions | None | - | - | Instant for MVP speed |

**Animation principle**: Functional only, no decorative motion. All animations <500ms.

---

## Design Decisions Rationale

### Why These Components?

| Decision | Rationale |
|:---------|:----------|
| **No Tabs** | Single-page screens, no complex in-screen navigation needed |
| **No Accordion** | No collapsible sections in current features |
| **No Slider** | No numeric range inputs (priority, progress) in MVP |
| **No Switch** | Status changes via dropdown (todo/in progress/done) more explicit |
| **No File Upload** | MVP scope excludes attachments (PRD Feature X deferred) |
| **Table over Cards** | Task list has 5+ columns, table more scannable than cards |

---

### Future Considerations (NOT MVP)

Components intentionally excluded but may be needed later:

| Component | Future Use Case | When to Add |
|:----------|:----------------|:------------|
| **Tags/Pills** | Task categories/labels | Post-MVP Feature: Categories |
| **Avatar** | User profile photos | Post-MVP Feature: User profiles |
| **Progress Bar** | Task completion percentage | Post-MVP Feature: Subtasks |
| **Rich Text Editor** | Formatted descriptions | Post-MVP Feature: Markdown support |
| **Date Range Picker** | Filter by date range | Post-MVP Feature: Advanced filters |

---

## Trade-offs & Constraints

### Design System Scope

| Aspect | Decision | Trade-off |
|:-------|:---------|:----------|
| **Component count** | 27 components | More than minimal (10), less than generic (50+) |
| **Variant coverage** | 2-4 variants per component | Enough flexibility, avoids over-engineering |
| **Animation complexity** | Functional only (<500ms) | Polish without performance cost |
| **Responsive breakpoints** | 3 breakpoints (mobile/tablet/desktop) | Standard coverage, not pixel-perfect |
| **Accessibility** | WCAG 2.1 AA | Legal minimum, not AAA |

---

### Technical Constraints

| Constraint | Impact on Design | Mitigation |
|:-----------|:-----------------|:-----------|
| **Budget <$5K** | Simple components, no custom illustrations | Use icon libraries (Lucide, Heroicons) |
| **Solo developer** | No designer for polish iterations | Clear specs upfront, follow system |
| **6-week timeline** | No time for advanced interactions | Focus on functional, skip decorative |
| **No backend yet (M05)** | Mock data for prototypes | Use realistic sample data |

---

## Next Steps

### Immediate (M04 Continuation)

1. **Generate DESIGN_SYSTEM.md** (2 hours)
   - Colors: Primary, success, error, neutral scales (from component needs)
   - Typography: Sizes needed (stat numbers, headings, body, captions)
   - Spacing: Consistent padding/margins (4/8/16/24/32/48px)
   - **Component specifications**: Each of 27 components detailed
   - Shadows: 3 levels (sm/md/lg for cards, modals, dropdowns)

2. **Generate SITEMAP.md** (30 min)
   - [N] screens mapped
   - Route hierarchy
   - Navigation flows

3. **Generate DESIGN_SPEC.md** (1.5 hours)
   - Per screen: Components used (from inventory above)
   - 5-state matrix (idle, loading, success, error, empty)
   - Responsive variants (mobile/tablet/desktop)
   - Accessibility notes (ARIA, keyboard)

### Before M06 (Development)

- [ ] Design freeze sign-off (client/stakeholder approval)
- [ ] Component library decision (shadcn/ui, Headless UI, build from scratch)
- [ ] Icon library selection (Lucide, Heroicons, Phosphor)
- [ ] Accessibility audit checklist prepared

---

## Appendix: Component Justification Map

> Quick reference: Which features need which components

| Component | Used By Features | Critical Path? |
|:----------|:-----------------|:---------------|
| Button | 1, 2, 3, 4, 5 | ✅ Yes (all forms) |
| Input | 1, 3, 4 | ✅ Yes (login, search, forms) |
| Table | 3 | ✅ Yes (main task list) |
| Modal | 5 | ⚠️ Medium (delete confirmation) |
| Toast | All | ✅ Yes (feedback for all actions) |
| Badge | 3, 5 | ⚠️ Medium (status display) |
| DatePicker | 4 | ⚠️ Medium (due date) |
| Pagination | 3 | ⚠️ Medium (large task lists) |
| EmptyState | 2, 3 | ⚠️ Medium (empty data) |

**Critical path components** (✅): Must be implemented first, core functionality depends on them
**Medium priority** (⚠️): Important for UX, can use simple fallback initially

---

## Sign-off

- [ ] Component inventory reviewed by: [Name, Date]
- [ ] Interaction states approved by: [Name, Date]
- [ ] Accessibility requirements confirmed by: [Name, Date]
- [ ] Ready to proceed to DESIGN_SYSTEM.md generation

---

**Next Document**: `DESIGN_SYSTEM.md` (generated from this component inventory)
