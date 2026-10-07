# Component Requirements & UI Pattern Analysis (WCAG 2.2 AA)

> **Purpose**: Map `SCOPE_STATEMENT.md` features and `SITEMAP.md` routes to concrete UI interaction patterns, atomic primitives, and composite components BEFORE drafting `DESIGN.md`.
> **Standard**: Strict WCAG 2.2 Level AA compliance, anti-slop nomenclature parity, and domain-grounded interaction states.
> **Output**: `docs/specs/COMPONENT_REQUIREMENTS.md`

---

## 1. Metadata & Scope Alignment

- **Project**: [Project Name]
- **Date**: [YYYY-MM-DD]
- **Author / Designer**: [Your Name]
- **Scope Reference**: `docs/pm/SCOPE_STATEMENT.md` (v1.0)
- **Sitemap Reference**: `docs/specs/SITEMAP.md` (v1.0)
- **Accessibility Target**: **WCAG 2.2 Level AA** (Tested & Mathematically Verified)
- **Scope Alignment Affirmation**:
  - [ ] All features analyzed below are strictly in-scope (P0/P1) in `SCOPE_STATEMENT.md`.
  - [ ] Zero unrequested "nice-to-have" components added without direct feature justification.

---

## 2. Feature → UI Pattern Mapping & Domain Edge Cases

*Map each in-scope feature to interaction patterns. Every named component MUST match 100% with the inventory in Section 3.*

### Feature 1: [Feature Name, e.g., POS Cashier Checkout / Employee Check-In]
- **Scope ID**: [e.g., F-04]
- **User Story**: As a [role], I want to [action], so that [benefit].
- **Role Access & Permissions**:
  - **Allowed Roles**: [e.g., Cashier (Operator), Store Manager, Owner]
  - **UI State per Role**:
    - Operator: Full access to cashier workflow; discount > 15% triggers supervisor approval.
    - Store Manager: Full access; can approve discount overrides and view shift total.
    - Customer: No access (route forbidden).
- **UI Patterns Needed**:
  - [Pattern 1, e.g., Split dual-panel catalog & cart layout]
  - [Pattern 2, e.g., Quick SKU/Barcode search with autofocus]
  - [Pattern 3, e.g., Modal confirmation for payment execution]
- **User Interaction Sequence**:
  1. User triggers action $\rightarrow$ System provides immediate visual/tactile feedback.
  2. User inputs data $\rightarrow$ System performs inline validation on blur.
  3. User submits $\rightarrow$ Primary button enters loading state, action executes, success toast/modal fires.
- **Edge Cases & Domain Scenarios**:
  - **Empty State**: [e.g., Cart is empty $\rightarrow$ show illustration + "Scan barcode or tap product to start"]
  - **Error State (Screen-Level)**: [e.g., Network/API failure $\rightarrow$ show alert card with retry CTA]
  - **Domain Exception Mitigation**: [e.g., If system stock reaches 0 but physical goods exist on shelf $\rightarrow$ provide warning badge with supervisor override rather than rigidly blocking cashier queue]
- **Key Components Used**:
  - `Button`, `Input`, `SearchInput`, `Card`, `Table`, `Modal`, `Toast`, `Badge`, `PermissionGate`, `SupervisorOverrideModal` (Names must match Section 3 exactly)

---

### Feature 2: [Feature Name, e.g., Stock Opname & Adjustment / Leave Request]
- **Scope ID**: [e.g., F-03]
- **User Story**: As a [role], I want to [action], so that [benefit].
- **Role Access & Permissions**:
  - **Allowed Roles**: [e.g., Staff / Operator, Manager, Auditor]
  - **UI State per Role**:
    - Staff: Blind physical count form only (expected inventory count hidden).
    - Manager: Discrepancy report + two-person approval drawer for adjustments > Rp 1.000.000.
    - Read-Only Auditor: View-only history log; submit/approve buttons hidden.
- **UI Patterns Needed**:
  - [Pattern 1, e.g., Form with blind physical count input]
  - [Pattern 2, e.g., Discrepancy indicator badge with arithmetic sign]
  - [Pattern 3, e.g., Two-person review drawer for adjustments > threshold]
- **Domain Edge Cases**:
  - [e.g., Blind count pattern prevents bias by hiding expected quantities until count is submitted]
- **Key Components Used**:
  - `FormField`, `Input`, `Select`, `Badge`, `ConfirmDialog`, `Toast`

---

## 3. Official Component Inventory (Strict Three-Tier Categorization)

*Consolidated, deduplicated inventory. Every component used in Section 2 must be tabulated here.*

### 3.1 Primitives (Atomic Components)

| # | Component Name | Variants | Interactive States | Usage Justification |
|:--:|:---------------|:---------|:-------------------|:--------------------|
| 1 | `Button` | primary, secondary, outline, ghost, destructive | default, hover, active, focus, disabled, loading | Form actions, dialog triggers, checkout submission |
| 2 | `Input` | text, email, password, search | default, hover, focus, error, disabled | Data entry across all forms; uses `inputmode="numeric"` for currency |
| 3 | `Textarea` | standard | default, hover, focus, error, disabled | Notes, adjustment reasons, address fields |
| 4 | `Select` | single, combobox / search-select | closed, open, focused, selected, disabled | Categories, units, branch pickers |
| 5 | `Badge` | neutral, success, warning, destructive, info | default, interactive hover (optional) | Status flags, stock levels, role indicators |
| 6 | `Checkbox` | default | unchecked, checked, indeterminate, disabled | Multi-item selection, agreement terms |
| 7 | `LoadingSpinner`| sm (16px), md (24px), lg (32px) | animated spin | Async indicators, submit buttons |
| 8 | `Icon` | Lucide React (standardized) | default | Visual cues paired with text (never color alone) |

### 3.2 Standard Composites

| # | Component Name | Composition Structure | Usage Justification |
|:--:|:---------------|:----------------------|:--------------------|
| 1 | `FormField` | Label + Input/Select/Textarea + Error Message (≥13px) + Hint | Standardized form wrapper with accessible aria associations |
| 2 | `Card` | CardHeader + CardTitle + CardContent + CardFooter | Content containers, dashboard metric tiles, list cards |
| 3 | `Table` | TableHeader + TableBody + TableRow + TableCell + TablePagination | Tabular data records; reflows to stacked cards on mobile (<640px) |
| 4 | `Modal` | DialogBackdrop (z-40) + DialogContent (z-50) + DialogClose | Focused interactive overlays with focus-trap and Esc handler |
| 5 | `ConfirmDialog`| Modal + Icon + Title + Description + Cancel/Confirm Action | Destruction / void confirmations |
| 6 | `Toast` | ToastContainer (z-60) + ToastItem + CloseAction | Action feedback; error & offline toasts have NO auto-dismiss |
| 7 | `EmptyState` | Icon / Illustration + Heading + Description + ActionButton | Rendered when collections contain 0 records |
| 8 | `SearchInput` | Input + SearchIcon + ClearButton | Filterable headers, product lookup |
| 9 | `PermissionGate` | Role/Permission wrapper | Client-side visual gating aligned with RBAC rules |
| 10| `SupervisorOverrideModal` | Dialog + PIN/Auth + Reason Textarea | Manager overrides for privileged actions exceeding operator limits |
| 11| `AuditActionBadge` | Badge + Tooltip (Author, Timestamp, IP) | Displays identity & role for high-liability modifications |

### 3.3 Domain-Specific Composites (Conditional Extensions)

*Include only components required by the project's specific domain (Retail, HRIS, Fintech, etc.):*

| # | Component Name | Domain / Context | Purpose & Interaction |
|:--:|:---------------|:-----------------|:----------------------|
| 1 | `POSCartDock` | Retail / Point of Sale | Two-panel split on tablet/desktop; sticky bottom bar on mobile (<768px) with total and pay button |
| 2 | `ChangeCalculator`| Cashier / Retail | Large display of tender amount, quick cash chips, and change calculation |
| 3 | `ThermalPrintView`| Hardware / Retail | `@media print` 58mm/80mm receipt format with zero margins and monospaced typography |
| 4 | `OfflineSyncBadge`| Local-First / Field Ops | 4 connection states: Online (green pulse), Offline (amber + pending count), Syncing (spinner), Error (retry) |
| 5 | `CurrencyInput` | Financial / Accounting | Uses `inputmode="numeric"`, live thousand-separator dot formatting, without browser float spinners |

---

## 4. Priority Screen 5-State Matrix

*Document the 5 structural states for all P0 data-driven screens. Crucial: Field validation errors are inline form states, NEVER screen-level error states.*

| Screen ID | Screen Name | 1. Default (Idle) | 2. Loading Skeleton | 3. Success | 4. Screen Error (500/Net) | 5. Empty State |
|:----------|:------------|:------------------|:--------------------|:-----------|:--------------------------|:---------------|
| `SCR-001` | Dashboard | KPI cards with live values | Pulsing gray skeleton cards (3 cards) | Values refreshed smoothly | Error banner + "Muat Ulang" retry button | "Belum ada transaksi hari ini" |
| `SCR-002` | Product Catalog | Search bar + product data table | Table header + 5 skeleton row bars | Row updated / toast notification | Red card with retry button | "Belum ada produk" + "Tambah Produk" CTA |
| `SCR-003` | POS Checkout | Split catalog + active cart | Skeleton grid on product tiles | Green transaction modal + receipt print | Offline warning banner + local cache fallback | Cart empty illustration + instructions |
| `SCR-004` | Stock Opname | Adjustment list & filter bar | Skeleton list items | Opname saved + status badge | Connection failure alert | "Belum ada riwayat adjustment" |

---

## 5. Calibrated Accessibility Protocol (WCAG 2.2 Level AA Enforcement)

### 5.1 Anti-Disabled Pristine Rule
- Form submission buttons **MUST NOT** be `disabled` while the form is untouched/pristine.
- **Rationale**: Disabled buttons prevent users from discovering required fields or understanding form requirements.
- **Behavior**: Clicking the enabled submit button on an incomplete form triggers validation immediately, scrolls smoothly, and **auto-focuses the first invalid field** with descriptive error text.

### 5.2 Timing Adjustable (WCAG 2.2.1)
- **Error Toasts & Offline Alerts**: **STRICTLY FORBIDDEN to auto-dismiss**. They must remain visible until the user explicitly dismisses them or the error condition is resolved.
- **Success & Informational Toasts**: Allowed to auto-dismiss after $\ge 5000\text{ms}$, with timer pause on hover or keyboard focus.

### 5.3 Focus Not Obscured (WCAG 2.4.11)
- Sticky top bars (`z-10`) and fixed bottom checkout bars (`z-20`) must not obscure focused inputs.
- **Enforcement**: Containers must declare CSS `scroll-padding`:
  ```css
  html, body, .scroll-container {
    scroll-padding-top: 80px;    /* Height of sticky navbar + offset */
    scroll-padding-bottom: 96px; /* Height of bottom action bar + offset */
  }
  ```

### 5.4 Form Error Text Readability
- Error message text associated with input fields (`aria-describedby`) **MUST be at least 13px** (`text-xs md:text-sm`).
- Error text color **MUST achieve $\ge 4.5:1$** contrast against background (e.g., `#B91C1C` / `#991B1B` on white = 5.6:1+).
- Every error state pairs color with an alert icon and explicit text explanation.

---

## 6. Multi-User & Role-Aware Component Protocols

### 6.1 Defense-in-Depth Principle
- **Client-side UI gating is strictly ergonomic, NEVER security**: Hiding or disabling buttons using `PermissionGate` improves user experience, but every underlying API route, Server Action, and database mutation MUST enforce independent server-side RBAC authorization.

### 6.2 Three-Tier Permission States
1. **Hidden from DOM**: For routes or major UI sections completely unauthorized for the active role (e.g., billing settings hidden from cashiers). Ensures zero accidental DOM inspection exposure.
2. **Disabled with Explanatory Tooltip**: For actions that the user can see exist within the workflow but lacks privilege to execute (e.g., "Minta persetujuan Supervisor untuk diskon > 15%").
3. **Privileged Escalation Trigger**: Instead of hard-failing, interactive workflows trigger `SupervisorOverrideModal` allowing a manager to authenticate inline without disrupting current user session.

---

## 7. Technical Specifications & Unified Z-Index Scale

### 7.1 Modern Font Loading & Breakpoints
- **Font Module**: Use `next/font/google` (Inter, JetBrains Mono). The deprecated package `@next/font/google` is **strictly prohibited**.
- **Standardized Responsive Breakpoints**:
  - `sm`: 640px (Mobile landscape / compact cards)
  - `md`: 768px (**Definitive switch point** between Mobile Bottom Navigation / Drawer and Desktop Sidebar / Two-Panel layouts)
  - `lg`: 1024px (Standard tablet desktop)
  - `xl`: 1280px (Wide desktop viewports)

### 7.2 Strict Unified Z-Index Hierarchy
*To prevent modal dropdown collisions, combobox clipping, and sticky bar bleed-through:*

```css
:root {
  --z-canvas: 0;             /* Base content layer */
  --z-sticky-nav: 10;        /* Sticky top navigation bar */
  --z-floating-action: 20;   /* Floating action button / POS cart dock */
  --z-page-dropdown: 30;     /* Page-level dropdowns, select menus, popovers */
  --z-modal-backdrop: 40;    /* Backdrop dimming overlay */
  --z-modal-dialog: 50;      /* Dialog window, Sheet drawer */
  --z-modal-dropdown: 55;    /* Dropdowns/comboboxes rendered INSIDE modal portals */
  --z-toast: 60;             /* Global toast notification stack */
  --z-payment-gateway: 999999; /* Third-party payment iframes (Midtrans Snap, Stripe) */
}
```

---

## 8. Regulatory Compliance & Local Domain Policies

*Document sector-specific statutory rules and legal liability disclaimers:*

### 8.1 Statutory Calculation Rules (Domain-Specific)
- **Retail / SME Tax (PP 55/2022 jo. PP 20/2026)**:
  - Model PPh Final 0.5% with the **Rp 500.000.000/year** gross revenue threshold for individual taxpayers (Wajib Pajak Orang Pribadi).
  - Explicitly define Non-PKP status (zero PPN calculation).
- **HRIS / Payroll (PP 58/2023 & PMK 168/2023)**:
  - Model PPh 21 TER (Categories A, B, C) and BPJS deductions.

### 8.2 Mandatory Financial & Operational Disclaimers
Display persistent in-app disclaimers:
1. *"Perhitungan ini bersifat estimasi operasional dan tidak menggantikan pelaporan resmi pada regulator atau nasihat profesional bersertifikasi."*
2. *"Pengguna bertanggung jawab penuh atas kebenaran data fisik dan transaksi yang diinput ke dalam sistem."*

---

## 9. Agent Validation Checklist (Step 0 Exit Gate)

*Before completing Step 0 and proceeding to `DESIGN.md`, the agent MUST verify:*

- [ ] **1. Nomenclature Parity**: 100% of component names referenced in Section 2 exist in Section 3 inventory table.
- [ ] **2. Multi-Role RBAC Alignment**: Every feature in Section 2 defines explicit permissions and UI states across roles from `SCOPE_STATEMENT.md`.
- [ ] **3. Anti-Disabled Pristine**: Form submit buttons are NOT disabled in pristine state (validation triggers on click with auto-focus).
- [ ] **4. Non-Dismissing Errors**: Error toasts and offline reconnection alerts are configured without auto-dismiss (manual close required).
- [ ] **5. Numeric Input Optimization**: All monetary/currency inputs use `inputmode="numeric"` and NEVER `type="number"`.
- [ ] **6. Z-Index Layer Integrity**: Modal dropdowns/comboboxes (`--z-modal-dropdown: 55`) are layered higher than the dialog itself (`--z-modal-dialog: 50`).
- [ ] **7. Accessible Error Typography**: All form error text is minimum 13px with $\ge 4.5:1$ contrast against the card background.
