# Design Specification & UI Wireflow (WCAG 2.2 AA)

> **Purpose**: Full screen wireflows, interaction state definitions, responsive layout architectures, visual design tokens, and logic defense to freeze the user interface before entering Module 05 (Architecture & Specs).
> **Input**: `docs/specs/COMPONENT_REQUIREMENTS.md`, `docs/specs/SITEMAP.md`, `docs/harness-root/DESIGN.md`
> **Output**: `docs/specs/DESIGN_SPEC.md`

### Project Metadata
- **Project Name**: [System / Application Name]
- **Client / Organization**: [Client Company / Organization]
- **Solo Lead UI/UX Engineer**: [Your Name]
- **Specification Version**: 1.0.0
- **Design Status**: [DRAFT / IN_REVIEW / FROZEN]
- **Target Scale**: [Small (MVP) / Medium (SaaS) / Large / Enterprise]
- **Prototyping Workflow**: [A (Markdown-only) / B (Visual Builder) / C (AI Prototype) / D (Design Tool)]
- **Approval Date**: [YYYY-MM-DD]

---

## 1. Layout Architecture & Role-Based Navigation (RBAC)

### 1.1 Adaptive Viewport Layouts
- **Desktop Architecture ($\ge 768\text{px}$)**:
  - Sidebar: Fixed 240px–260px width, sticky height `h-screen`, active item highlighted with primary accent border (`border-l-4`). Collapses to 64px icon rail on viewports $<1280\text{px}$ if density requires.
  - Topbar: Height 56px–64px (`h-14` / `h-16`), sticky `z-10`, containing location/tenant switcher dropdown (if multi-tenant), notification bell badge, and user profile avatar.
  - Main Canvas: Dynamic width, `min-h-[calc(100vh-64px)]`, background `--background` (`#FFFFFF` or warm neutral canvas `#F7F6F2`), padding 16px–24px.
- **Mobile Architecture ($< 768\text{px}$)**:
  - Sticky Top Header: Height 56px (`h-14`), brand logo + notifications or quick back button.
  - Sticky Bottom Navigation Bar: Height 64px (`h-16`), sticky `z-20`, max 5 navigation slots.
  - Virtual Keyboard Safety: Bottom nav bar auto-hides when virtual keyboard opens to prevent viewport clipping.

### 1.2 Role Boundaries & Initial Landing Routes
*(Adapt roles and initial routes to project domain: HRIS, CRM, Retail, Fintech, DevTools)*

| Role Code | Role Name | Initial Default Landing Route | Screen View & Action Boundaries |
| :--- | :--- | :--- | :--- |
| **ROL-01** | Super Admin / Owner | `/dashboard` | Unrestricted visibility across all screens, organizational settings, and financial/audit ledgers |
| **ROL-02** | Manager / Reviewer | `/dashboard` | Operational views & approval queues; **NO self-approval** on own submissions |
| **ROL-03** | Operational Staff / Operator | Primary execution route (e.g., `/pos`, `/tasks`, `/workspace`) | Dedicated execution view; sensitive cost/margin fields omitted from query and DOM |
| **ROL-04** | Auditor / Guest | Read-only target route (e.g., `/reports`, `/portal`) | Read-only inspection; zero mutation permissions |

---

## 2. Mathematical Color Contrast & Ergonomics Audit (WCAG 2.2 AA)

*Contrast ratios must be calculated using WCAG relative luminance formulas against actual adjacent backgrounds. The table below illustrates verified benchmark pairs; record your project's actual computed ratios:*

| Design Token | Example Light Hex | Example Dark Hex | Background Surface | Target Standard | Measured Light Ratio | Measured Dark Ratio | Project Audit Status |
| :--- | :---: | :---: | :--- | :---: | :---: | :---: | :---: |
| `--foreground` (Primary Text) | `#18181B` | `#F4F4F5` | `--background` (`#FFF` / `#09090B`) | $\ge 7.0 : 1$ | [e.g., 17.72:1] | [e.g., 18.10:1] | [Verified / Pending] |
| `--muted-foreground` (Secondary)| `#71717A` | `#A1A1AA` | `--background` (`#FFF` / `#09090B`) | $\ge 4.5 : 1$ | [e.g., 4.83:1] | [e.g., 7.76:1] | [Verified / Pending] |
| `--text-placeholder` | `#71717A` | `#A1A1AA` | `--input-bg` (`#FFF` / `#18181B`) | $\ge 4.5 : 1$ | [e.g., 4.83:1] | [e.g., 6.91:1] | [Verified / Pending] |
| `--border-input` (Interactive) | `#71717A` | `#71717A` | `--card` / `--background` | $\ge 3.0 : 1$ | [e.g., 4.83:1] | [e.g., 3.67:1] | [Verified / Pending] |
| `--destructive` (Error Text) | `#991B1B` | `#FCA5A5` | `--destructive` bg (`#FEE2E2` / `#450A0A`) | $\ge 4.5 : 1$ | [e.g., 6.80:1] | [e.g., 8.51:1] | [Verified / Pending] |
| `--success` (Success Text) | `#065F46` | `#86EFAC` | `--success` bg (`#D1FAE5` / `#052E16`) | $\ge 4.5 : 1$ | [e.g., 6.78:1] | [e.g., 10.62:1] | [Verified / Pending] |
| `--warning` (Warning Text) | `#92400E` | `#FDE047` | `--warning` bg (`#FEF3C7` / `#422006`) | $\ge 4.5 : 1$ | [e.g., 6.37:1] | [e.g., 11.06:1] | [Verified / Pending] |

### 2.1 Ergonomics & Touch Target Standards
- **Touch Target Compliance (WCAG 2.5.5 & SC 2.5.8)**: All primary tap targets on mobile/touch interfaces are $\ge 44\text{px} \times 44\text{px}$ (`h-11 min-w-11`). Secondary desktop elements strictly meet minimum 24px target size.
- **Focus Not Obscured (WCAG 2.4.11)**: Containers declare `scroll-padding-top: 80px` and `scroll-padding-bottom: 96px` to prevent sticky topbars or bottom docks from obscuring active keyboard focus rings.
- **Redundant Entry (WCAG 3.3.7)**: Re-entering identical customer, billing, or party data is populated automatically or selectable via dropdown.
- **Accessible Authentication (WCAG 3.3.8)**: Password managers and copy-paste are fully supported on authentication inputs; no cognitive function puzzles required.

---

## 3. Exhaustive Screen Inventory (100% SITEMAP Coverage)

> **ABSOLUTE COVERAGE RULE**: Every single route and modal screen identified in `SITEMAP.md` MUST be registered below with a unique `SCR-xx` ID, feature reference, and access permissions. Truncation or sampling is strictly prohibited.
> 
> 🛡️ **ANTI-STUB SCREEN SPECIFICATION MANDATE**:
> Dilarang mendeskripsikan layar hanya dengan satu kalimat umum (misal: *"Tampilan dashboard menampilkan metrik"*). Setiap entri layar wajib mencantumkan **Anatomi Seksi & Komponen Nyata** (misal: Hero, 3 Kartu KPI, Filter Toolbar, Tabel Data 6 Kolom, Modal Konfirmasi) agar layar tidak ter-generate kosong atau terlalu pendek!

| Screen ID | Route URL | Screen Name | Feature ID | Required Section Anatomy (Anatomi Seksi Wajib) | Primary Role Access |
| :--- : | :--- | :--- | :--- : | :--- | :--- |
| `SCR-001` | `/` | Public Landing Page | F-01 | 1. Hero + CTA, 2. Problem/Pain Cards, 3. Feature Showcase, 4. Pricing Anchor | Public (Unauthenticated) |
| `SCR-002` | `/login` | Authentication Portal | F-01 | 1. Logo Minimal, 2. Centered Card (Email/Pass + Remember), 3. Auth Help Links | Public (Unauthenticated) |
| `SCR-003` | `/dashboard` | Main Operational Dashboard | F-02 | 1. Top KPI Summary (4 Cards), 2. Quick Action Bar, 3. Recent Activity Table, 4. Pending Approvals | All Authenticated Roles |
| `SCR-004` | `/[primary-resource]` | Primary Resource Directory | F-03 | 1. Search & Filter Bar, 2. Data Table (Zebra, Status Badges), 3. Pagination Footer, 4. Bulk Actions | Staff, Manager, Owner |
| `SCR-005` | `/[primary-resource]/new` | Create Resource Form | F-03 | 1. Form Stepper/Card, 2. Field Groups with Inline Validation, 3. Sticky Action Bar (Save/Cancel) | Staff, Manager, Owner |
| `SCR-006` | `/[primary-resource]/:id` | Resource Detail & History | F-03 | 1. Header with Status & Actions, 2. Master Data Card, 3. Related Ledger, 4. Audit History Timeline | Staff, Manager, Owner |
| `SCR-007` | `/[primary-resource]/:id/edit`| Edit Resource Form | F-03 | 1. Pre-populated Fields, 2. Unsaved Changes Warning, 3. Version Conflict Check, 4. Save/Discard | Manager, Owner |
| `SCR-008` | `/[secondary-workflow]` | Operations Workflow View | F-04 | 1. Operational Mode Header, 2. Interactive Workspace Canvas, 3. Live Validation Toast | Operator, Manager, Owner |
| `SCR-009` | `/approvals/pending` | Review & Approval Queue | F-05 | 1. Queue Counter Tabs, 2. Diff/Comparison Viewer, 3. Two-Person Sign-Off Modal (No Self-Approval) | Manager, Owner (No self-approval)|
| `SCR-010` | `/reports/[primary-report]` | Primary Financial/Audit Report | F-06 | 1. Date Range & Parameter Filter, 2. Aggregated KPI Summary, 3. Detail Data Grid, 4. Export (PDF/CSV) | Auditor, Owner |
| `SCR-011` | `/settings/profile` | User Profile & Security Settings| F-07 | 1. Personal Avatar & Info, 2. Credential/Password Change, 3. 2FA Authenticator Setup, 4. Active Sessions | All Authenticated Roles |
| `SCR-012` | `/settings/organization` | Organization Configuration | F-07 | 1. Entity Profile & NPWP, 2. Team & RBAC Invites, 3. Billing & Invoices, 4. Webhook Keys | Owner Only |
| `SCR-...` | `[All Other Sitemap Routes]` | [Exhaustive list of all sitemap pages] | ... | [Minimum 3-4 concrete functional sections per screen] | [Roles] |

---

## 4. Standardized 5-State Matrix per Interface Pattern

*Define concrete system behaviors across the 5 canonical states for each recurring interface pattern:*

### 4.1 Pattern: Data Table & List Views (e.g., Records, Directories, Logs)
1. **Default (Idle)**: Table renders rows with zebra striping, sticky header, status badges, pagination footer.
2. **Loading Skeleton**: Table header renders with 5 gray pulsing skeleton rows (`h-12 animate-pulse`).
3. **Empty State**: Table body replaced by centered card: Empty state illustration, heading *"Belum ada data tercatat"*, description, and primary CTA *"Tambah Data Baru"*.
4. **Screen-Level Error**: Full-width alert banner: *"Gagal memuat data dari server (HTTP 500)"* with prominent *"Coba Lagi"* retry button.
5. **Success State**: Toast notification fires (*"Data berhasil diperbarui"*), table row updates highlight with brief 200ms background transition.

### 4.2 Pattern: Forms & Profile Inputs (e.g., Create, Edit, Settings)
1. **Pristine State (Anti-Disabled)**: Submit button is ENABLED. Inputs render empty or with initial values. User clicks submit to discover form expectations.
2. **Validating State**: Client-side validation evaluates fields on blur. Inputs show spinner icon if checking unique constraints asynchronously.
3. **Submitting State**: Submit button displays spinning loader (*"Menyimpan..."*), all form inputs enter read-only disabled state to prevent race conditions.
4. **Inline Field Errors**: Red error text (`text-destructive text-xs md:text-sm`, $\ge 13$px, $\ge 4.5:1$ contrast) renders directly beneath invalid inputs with `aria-describedby` linkage. Submit button refocuses the first invalid field.
5. **Success State**: Form resets or redirects to entity detail view with confirmation toast.

### 4.3 Pattern: Document Details & Ledgers (e.g., Detail Views, Statements, Invoices)
1. **Default (Idle)**: Document header with metadata chips, line-item table, and action bar (Print, Void, Export).
2. **Loading Skeleton**: Document card renders pulsing header block and 3 skeleton table rows.
3. **Not Found (404 Error)**: Centered error state: *"Dokumen tidak ditemukan atau telah dihapus"* with back navigation CTA.
4. **Action Overlays**: Void/Delete confirmation dialog renders at `z-50` with required audit reason textarea.
5. **Success State**: Document status chip updates dynamically (e.g., from `Draft` to `Disetujui`).

### 4.4 Pattern: Token Validation & Authentication Handshakes (e.g., Email Verification, Password Reset)
1. **Validating State**: Full-screen centered card with animated loading spinner (*"Memverifikasi token..."*).
2. **Expired / Invalid State**: Alert card: *"Tautan kedaluwarsa atau tidak valid"* with CTA button *"Minta Tautan Baru"*.
3. **Success State**: Green checkmark icon with countdown redirect to `/login` or `/dashboard`.

---

## 5. Isolated Wireflows & Logic Defense

*Document interaction wireflows and protective logic rules to prevent domain failures:*

### 5.1 General Interaction & Input Defense
- **Double-Submit Prevention**: All submit buttons automatically debounce and enter a disabled loading state immediately upon initial click until server response completes.
- **Idempotency Keys**: All financial, ledger, or state-changing mutations transmit a client-generated UUID in request headers to guarantee safe retries without duplicated records.
- **CSV Formula Injection Neutralization**: All spreadsheet/CSV export generators prefix cells starting with `=, +, -, @` with a single quote (`'`).

### 5.2 Conditional Domain Extensions
*(Include only subsections relevant to project scope; skip or substitute for unrelated domains)*

#### A. Cashier Hardware & Barcode Scanner Mitigation (Retail / POS Scope)
- *Failure Mode*: Barcode scanners transmit scanned digits followed by automatic `Enter` keystrokes. Binding `Enter` to "Submit Payment" causes premature transaction submission on incomplete carts.
- *Defense Protocol*: Cashier screens MUST NOT bind `Enter` to payment execution. Bind `Enter` strictly to "Add Scanned Item to Cart". Reserve dedicated function keys: `F2` for search/scan, `F4` for payment modal, `F8` for new receipt.

#### B. Blind Count Inventory Opname Defense (Inventory Scope)
- *Failure Mode*: Displaying expected system stock or discrepancy columns to counting staff invites confirmation bias and theft concealment.
- *Defense Protocol*: Staff physical count screens render ONLY item identification and an empty numeric count field. System stock and discrepancy columns are physically excluded from the client DOM and API payload until count submission.

#### C. Dual Printer Protocol (Hardware Scope)
- *Failure Mode*: Desktop web relies on `window.print()`, but mobile/tablet Android POS setups use Bluetooth or RawBT protocols.
- *Defense Protocol*: Receipt dialog provides desktop `@media print` 58mm/80mm fallback AND raw ESC/POS text / Android RawBT intent format.

---

## 6. Design Freeze Sign-Off

By signing this document, the Project Lead / Client PIC formally confirms that all user flows, wireframes, interaction states, and accessibility standards documented herein are approved and **OFFICIALLY FROZEN**.

**Sign-Off Terms**:
1. Visual layouts, screen inventories, and user flows are locked.
2. Development in Module 05 & Module 06 will strictly implement the specifications detailed above.
3. Any revisions to screen flows, addition of unmapped pages, or restructuring of components will be processed under the formal *Change Request (CR)* procedure.

| Approved by Client PIC / Lead Stakeholder | Validated by Solo Engineer |
| :--- | :--- |
| **Name**: _________________________ | **Name**: _________________________ |
| **Role**: _________________________ | **Role**: Solo Software Engineer |
| **Date**: [YYYY-MM-DD] | **Date**: [YYYY-MM-DD] |
| **Signature**: _____________________ | **Signature**: _____________________ |

---

## Appendix: Automated Quality Validation Checklist

*Before completing `DESIGN_SPEC.md`, verify:*

- [ ] **1. Exhaustive Coverage**: 100% of routes from `SITEMAP.md` are documented in Section 3 with unique Screen IDs (`SCR-xx`) and mapped to functional features (`F-xx`).
- [ ] **2. Interaction Shortcut Safety**: Form and execution screens do not bind destructive or checkout actions to common text entry keys (`Enter` reserved for search/add).
- [ ] **3. Data Privacy & Integrity**: Sensitive fields (cost prices, expected opname stock, personal identifiers) are protected by role-based DOM omission.
- [ ] **4. Mathematical Error Contrast**: Form error text achieves verified $\ge 4.5:1$ contrast against light background surfaces.
- [ ] **5. Focus Not Obscured Enforced**: Container styles incorporate `scroll-padding-bottom` (minimum 96px) to guarantee input focus visibility above mobile sticky bars.

---

## Machine Validation Summary (M04 Gate)

```text
Prototyping-Workflow: [A|B|C|D]
```

*(A = Markdown-only: `docs/design/prompts/` & `docs/design/screens/` are OPTIONAL. B/C/D = Visual Builder / AI Prototype / Design Tool: the gate REQUIRES populated `docs/design/prompts/scr-xx/PROMPT.md` and `docs/design/screens/scr-xx/` output folders — the module CANNOT be closed until those files physically exist.)*
