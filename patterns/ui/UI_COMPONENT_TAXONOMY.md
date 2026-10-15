# UI Component Taxonomy & Architecture Pattern

> **Standard Reference**: Mapping modern component vocabulary (shadcn/ui, Radix, Tailwind, Aceternity) to the 3-Tier lifecycle inventory (`docs/specs/COMPONENT_REQUIREMENTS.md`).

---

## 1. Complete Component Taxonomy

### 1.1 Primitives (Atomic Foundation)
- `Button`: Primary, secondary, outline, ghost, destructive with keyboard focus and active spring.
- `Input`: Single-line text, email, password, and `inputmode="numeric"` currency fields.
- `Textarea`: Multi-line text with auto-resize and character limit counter.
- `Select`: Accessible dropdown and combobox selector (Radix Select primitive).
- `Checkbox`: Accessible toggle check with indeterminate state.
- `RadioGroup`: Single-choice list with arrow key navigation.
- `Toggle` (Switch): Binary state switch for settings and feature toggles.
- `Slider`: Range and numeric slider with thumb drag and step increments.
- `Badge` / `Tag`: Status indicators (success, warning, destructive, info, neutral).
- `Avatar`: Circular/rounded user image with initial letter fallback.
- `Icon`: Standardized icon primitives (Lucide React / Phosphor).
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
- `Table`: Tabular data with sortable columns, pagination, and mobile stacked card reflow.
- `List`: Ordered and unordered data row layout with hover state.
- `Pagination`: Navigational bar with page numbers, ellipsis, and prev/next actions.
- `SearchInput`: Search bar pairing input, search icon, clear button, and debounced query trigger.
- `Toast` / `Notification`: Dismissible feedback message (Sonner stack; error toasts non-auto-dismiss).
- `EmptyState`: Centered visual illustration, clear description, and primary CTA.
- `Progress`: Determinate and indeterminate loading bar.
- `FileUpload`: Drag-and-drop dropzone with file preview, size validation, and upload progress.
- `Sidebar`: Collapsible application navigation drawer with active route highlights.
- `Calendar` / `DatePicker`: Month calendar grid with date/range selection.

### 1.3 High-Interaction & Rich Composites (Tier 3 Organisms)
- `BentoGrid`: Asymmetrical modern grid layout with responsive span rules.
- `Carousel`: Horizontal content slider with touch swipe, arrow controls, and dot indicators.
- `DataVizChart`: Recharts/Chart.js wrapper for Bar, Line, Area, and Donut visualizations.
- `FileTree`: Hierarchical folder and file explorer with expand/collapse and file type icons.
- `InteractiveCursor`: Trailing fluid mouse cursor, magnetic link snap, or collaborative multiplayer cursor.
- `Globe3D`: WebGL/Three.js interactive globe canvas for geospatial or server metrics.
- `AIChatPanel`: Realtime streaming message bubble list, markdown parser, prompt chips, and stop button.
- `AuthForm` (SignIn / SignUp): Complete authentication card with email validation, OAuth buttons, and error boundary.
- `OnboardingWalkthrough`: Step-by-step guided tour modal/spotlight with progress dots and skip action.
- `ProfileView`: User summary card with avatar upload, personal details, security settings, and audit badge.
