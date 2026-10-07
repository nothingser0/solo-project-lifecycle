# Frontend Development Checklist

**Module**: M06 Development Execution  
**Purpose**: Detailed sequential checklist for frontend UI, forms, state management

**Use with**: React, Next.js, Vue, Svelte development

---

## 1. Component Library & Design System Setup

### Design Tokens Sync
- [ ] **Design Tokens Sync**:
  - [ ] Map color tokens from `DESIGN_SYSTEM.md` to Tailwind config / CSS variables (Zinc palette, accent primary).
  - [ ] Configure Inter font family, typography scale (text-xs to text-4xl), and default border radius (rounded-md).

### Primitive Components (UI Atoms)
- [ ] **Primitive Components (UI Atoms)**:
  - [ ] `Button`: Variants primary, secondary, outline, ghost, destructive, with loading spinner state.
  - [ ] `Input` & `Textarea`: Variants normal, focused, error, disabled, helper text.
  - [ ] `Select`, `Checkbox`, `RadioGroup`, `Switch`: Form controls with keyboard-navigable status.
  - [ ] `Badge`, `Avatar`, `Separator`, `Skeleton`: Decorative elements and visual identity.

### Feedback Components (UI Molecules)
- [ ] **Feedback & Overlay Components (UI Molecules)**:
  - [ ] `Toast`: Pop-up notifications (Sonner / Toast) with success, error, info, warning variants.
  - [ ] `Modal / Dialog`: Confirmation overlay with focus trap and escape key close.
  - [ ] `Drawer / Sheet`: Sliding side panel for mobile navigation or secondary forms.
  - [ ] `DropdownMenu` & `Popover`: Contextual menus with dynamic positioning.

### Navigation Components
- [ ] **Navigation & Structural Components**:
  - [ ] `Navbar`: Top bar with project logo, dynamic breadcrumb, and user profile dropdown.
  - [ ] `Sidebar`: Collapsible side navigation with active route indicator.
  - [ ] `PageHeader`: Page title, description, and primary action bar.

### Accessibility (WCAG AA)
- [ ] **Accessibility (WCAG AA Compliance)**:
  - [ ] Test text contrast ratio minimum 4.5:1 against background.
  - [ ] Ensure all interactive elements have visible `focus-visible:ring-2` when tabbed.
  - [ ] Set `aria-label` and `aria-expanded` attributes on icon buttons and modal triggers.

---

## 2. Pages & Routing Architecture

### Layout Hierarchy
- [ ] **Application Layout Hierarchy**:
  - [ ] `RootLayout`: Set up theme provider, Inter font, and global toaster.
  - [ ] `(auth)/layout.tsx`: Clean centered layout for authentication flow without sidebar.
  - [ ] `(dashboard)/layout.tsx`: Protected layout with persistent sidebar, navbar, and auth guard.

### Authentication Pages
- [ ] **Authentication Pages**:
  - [ ] Login (`/login`), Register (`/register`), Forgot Password (`/forgot-password`), Reset Password (`/reset-password`) pages.
  - [ ] Smart redirect flow: Preserve `?callbackUrl=` parameter to return user to target page after login.

### Application Pages
- [ ] **Core Application Pages**:
  - [ ] Dashboard Index Page (`/dashboard`): Display statistical metric summaries and recent activity table.
  - [ ] Entity List Page (`/documents`): Data table with search, status filters, and pagination.
  - [ ] Entity Detail Page (`/documents/[id]`): Full detail view, audit history, and approval status.
  - [ ] Create/Edit Entity Page (`/documents/new` & `/documents/[id]/edit`): Structured forms.
  - [ ] Settings Pages (`/settings/profile`, `/settings/billing`, `/settings/team`).

### Error Pages
- [ ] **Defensive Error Pages**:
  - [ ] `not-found.tsx`: User-friendly 404 page with return to dashboard button.
  - [ ] `error.tsx`: Global Error Boundary with reset / retry button.

---

## 3. State Management

### Server State
- [ ] **Server-State Management**:
  - [ ] Setup TanStack Query / SWR / Server Action cache revalidation.
  - [ ] Set caching policy: `staleTime: 60_000` (1 minute) for standard data, 0 for real-time data.
  - [ ] Configure mutations with automatic invalidation of related query keys (`queryClient.invalidateQueries`).

### Client UI State
- [ ] **Client UI State Store**:
  - [ ] Setup lightweight Zustand / Context for ephemeral UI state: sidebar open/closed, active modal, dark/light theme.
  - [ ] Avoid storing server entity data in client store to prevent stale state mismatch.

### URL Sync
- [ ] **URL Search Params Synchronization**:
  - [ ] Sync table parameters (search query, active page, status filters) to browser URL (`?page=2&status=active`).
  - [ ] Users can share URLs or refresh the page without losing filter state.

---

## 4. Form Handling & Validation

### Form Library Integration
- [ ] **Form Library Integration**:
  - [ ] Set up React Hook Form / Formik on all input forms.
  - [ ] Connect Zod validation resolver (`@hookform/resolvers/zod`) using the same schema as the backend.

### Inline Validation
- [ ] **Inline Validation Feedback**:
  - [ ] Display specific error messages directly below problematic input fields.
  - [ ] Highlight red border (`border-destructive`) on invalid inputs upon submit.

### Submit Protection
- [ ] **Double Submit Protection & Navigation Guard**:
  - [ ] Disable submit button and display spinner while request is processing.
  - [ ] Provide unsaved changes confirmation alert if user attempts to leave an unsaved form.

---

## 5. API Integration & Client Wiring

### HTTP Client
- [ ] **HTTP Client Abstraction**:
  - [ ] Create centralized API wrapper (`src/lib/api-client.ts`) based on `fetch` or `axios`.
  - [ ] Interceptors automatically inject Authorization header or manage cookie credentials.
  - [ ] Automatically handle `401 Unauthorized` responses: redirect to `/login` or execute silent token refresh.

### File Upload
- [ ] **Direct-to-Cloud File Upload**:
  - [ ] Request presigned URL from backend → Upload file directly to S3/R2 using `fetch(putUrl, { body: file })`.
  - [ ] Display upload percentage progress bar (0% to 100%) to the user.

### Optimistic Updates
- [ ] **Optimistic UI Updates**:
  - [ ] Apply optimistic updates on instant actions (e.g., toggle bookmark, checkbox status update).
  - [ ] Provide automatic rollback mechanism to previous state if backend API request fails.

---

## 6. The 5 UI States Implementation (Defensive UI)

### State 1: Idle
- [ ] **Idle State**: Initial component view in clean condition and ready to accept action.

### State 2: Loading
- [ ] **Loading State**: Use skeleton loader matching the exact dimensions and layout of the real content (PROHIBITED full-screen spinner without context).

### State 3: Success
- [ ] **Success State**: Display action success confirmation toast, animate visual changes, and reset form.

### State 4: Error
- [ ] **Error State**: Display inline error banner, human-readable error explanation, and "Retry" button.

### State 5: Empty
- [ ] **Empty State**: Display thematic icon, descriptive title (e.g., "No Documents Yet"), brief motivational copy, and primary Call-to-Action button ("Create Document Now").

---

## Verification Checklist

Before merging to staging:

- [ ] All components follow design system tokens
- [ ] WCAG AA contrast ratios verified (4.5:1 minimum)
- [ ] Keyboard navigation functional (Tab, Escape, Enter)
- [ ] Forms validate client-side before submission
- [ ] API errors display user-friendly messages
- [ ] Loading states prevent duplicate submissions
- [ ] Empty states guide users to next action
- [ ] Mobile responsive (tested at 375px, 768px, 1024px)
- [ ] Focus indicators visible on all interactive elements
- [ ] No console errors in browser DevTools

---

**See Also**:
- `templates/04-dev-execution/checklists/backend-checklist.md` - Backend API tasks
- `templates/04-dev-execution/checklists/integration-checklist.md` - Third-party integrations
- `patterns/validation/zod-patterns.md` - Form validation schemas
- `references/stacks/nextjs-quickstart.md` - Next.js specific setup
- M06 Development Execution - Core module documentation
