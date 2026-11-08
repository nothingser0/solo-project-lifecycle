# UI Component Taxonomy & Architecture Pattern

> **Standard Reference**: Mapping clean, accessible component vocabulary (shadcn/ui, Radix, Tailwind) to the 3-Tier lifecycle inventory (`docs/specs/COMPONENT_REQUIREMENTS.md`).
> **Anti-Slop Law**: Solo developers build products, NOT custom component libraries. Only include components directly justified by in-scope P0/P1 features in `SCOPE_STATEMENT.md`. Zero unrequested eye-candy (no 3D globes, no custom fluid cursors, no unrequested AI panels).

---

## 1. Component Taxonomy (Product-Grounded)

### 1.1 Primitives (Atomic Foundation)
- `Button`: Primary, secondary, outline, ghost, destructive with keyboard focus and active spring.
- `Input`: Single-line text, email, password, and `inputmode="numeric"` currency fields.
- `Textarea`: Multi-line text with auto-resize and character limit counter.
- `Select`: Accessible dropdown and combobox selector (Radix Select primitive / custom popover; zero unstyled native `<select>`).
- `Checkbox`: Accessible toggle check with indeterminate state.
- `RadioGroup`: Single-choice list with arrow key navigation.
- `Toggle` (Switch): Binary state switch for settings and feature toggles.
- `Slider`: Range and numeric slider with thumb drag and step increments.
- `Badge` / `Tag`: Status indicators (success, warning, destructive, info, neutral).
- `Avatar`: Circular/rounded user image with initial letter fallback.
- `Icon`: Standardized semantic SVG icon primitives (Lucide React / Heroicons; zero raw emoticons).
- `LoadingSpinner`: SVG spinner with sm, md, lg size variants and aria-live announcements.
- `Link`: Accessible anchor tag with external indicator and underline transition.

### 1.2 Standard Composites (Molecules & Layout Systems)
- `FormField`: Accessible wrapper binding Label, Input, Error Message (>=13px), and Hint.
- `Card`: Container with structured Header, Title, Description, Content, and Footer.
- `Modal` / `Dialog`: Accessible overlay with focus trap, backdrop blur, and Esc listener.
- `Popover`: Floating content box anchored to a trigger element.
- `Tooltip`: Hover/focus explanation bubble with delay and collision detection.
- `DropdownMenu`: Contextual menu for actions and nested submenus.
- `Accordion`: Vertically stacked collapsible panels with smooth height transition.
- `Tabs`: Segmented view switcher with animated active indicator pill.
- `Table`: Tabular data with sortable columns, pagination, and mobile stacked card reflow (<640px).
- `List`: Ordered and unordered data row layout with hover state.
- `Pagination`: Navigational bar with page numbers, ellipsis, and prev/next actions.
- `SearchInput`: Search bar pairing input, search icon, clear button, and debounced query trigger.
- `Toast` / `Notification`: Dismissible feedback message (Sonner stack; error toasts non-auto-dismiss).
- `EmptyState`: Centered visual illustration, clear description, and primary CTA.
- `Progress`: Determinate and indeterminate loading bar.
- `FileUpload`: Drag-and-drop dropzone with file preview, size validation, and upload progress.
- `Sidebar`: Collapsible application navigation drawer with active route highlights.
- `Calendar` / `DatePicker`: Month calendar grid with date/range selection.

### 1.3 Application Organisms (Domain-Driven Only)
*Include ONLY when explicitly specified as an in-scope P0 feature in `SCOPE_STATEMENT.md` / `FSD.md`:*
- `BentoGrid`: High-density dashboard overview or metrics showcase.
- `DataVizChart`: Recharts/Chart.js wrapper for business charts (Bar, Line, Area, Donut).
- `FileTree`: Hierarchical folder and file explorer for document/vault management.
- `AuthForm` (SignIn / SignUp): Authentication card with email validation, session handling, and error boundary.
- `OnboardingWalkthrough`: Step-by-step guided tour spotlight with progress dots.
- `ProfileView`: User summary card with avatar upload and account security controls.
- *Strictly Forbidden Slop*: `InteractiveCursor`, `Globe3D`, canvas physics particles, and decorative AI gimmicks that serve no user goal.

---

## 2. Accessibility (a11y) & Screen-Reader Foundations

For solo developers, accessibility cannot be an afterthought:
1. **Interactive Elements**: All custom clickable items (custom divs/spans) MUST have `role="button"`, `tabIndex={0}`, and handle both `onKeyDown` (Enter/Space) and `onClick`. Prefer native `<button>` whenever possible.
2. **Form Controls**: Every `<input>`, `<select>`, and `<textarea>` must be associated with an explicit `<label htmlFor="...">` or `aria-label`.
3. **Modal Dialogs & Drawers**: Must trap keyboard focus inside the container while open, set `aria-modal="true"`, and close on `Escape`.
4. **Color Contrast (WCAG 2.1 AA)**: Normal text must achieve a minimum contrast ratio of 4.5:1 against its background (3:1 for large text ≥18pt or bold ≥14pt).
