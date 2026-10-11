# UI/UX Design & Prototyping Deep-Dive Guide

> **Companion Reference for Module 04 (`docs/modules/04-uiux-prototyping.md`)**
> Contains comprehensive worked examples, extended sitemaps, manual vs AI prototyping tutorials, local MCP workflows, and enterprise design system specifications.

---

---

## 2A. SITEMAP.md - Information Architecture

**File**: `docs/specs/SITEMAP.md`

The sitemap defines **page hierarchy, route paths, navigation structure, user flows, screen states, real data context, and RBAC boundaries** prior to creating mockups. Mandatory prerequisite for `DESIGN_SPEC.md`. Shallow 1-line route lists are strictly prohibited for production deliverables.

### Production-Grade Template Structure

```markdown
# SITEMAP - Information Architecture
[Project Name]

> *Note: The structure below uses a multi-role retail/accounting application (TataBuku) as an illustrative worked example. Adapt modules, roles, and routes to match your project's specific domain.*

## Executive Summary
- **Total Screens (MVP)**: [X] screens
- **Deferred Screens (Phase 1.5 & Phase 2)**: [Y] screens
- **Target Scale**: [Small 15-20 / Medium 30-50 / Large 60+ screens]
- **Primary Architecture**: [Sidebar Desktop + Bottom Tabs Mobile]
- **Role Matrix**: Owner (ROL-01), Manager (ROL-02), Kasir (ROL-03), Akuntan (ROL-04)

---

## PUBLIC PAGES (Unauthenticated)

**Root**: `/`
├── `/` — Landing page with hero, value proposition, pricing preview, CTA
├── `/login` — User authentication form (email + password, forgot password link)
├── `/signup` — Account registration wizard (business name, owner email, password)
├── `/forgot-password` — Password reset request (email input, captcha)
├── `/reset-password?token=xxx` — Token-authenticated new password setup
├── `/verify-email/:token` — Email verification confirmation landing
├── `/terms` — Terms of service static legal view
└── `/privacy` — Privacy policy static legal view

---

## ONBOARDING FLOW (First-Time Setup)

├── `/onboarding/step-1` — Welcome & business profile setup
├── `/onboarding/step-2` — Organization details & tax identity (NPWP optional)
├── `/onboarding/step-3` — Initial location/branch setup
├── `/onboarding/step-4` — Staff invitations & initial role assignment
└── `/onboarding/complete` — Setup completion summary with CTA to `/dashboard`

---

## AUTHENTICATED PAGES

**Dashboard**: `/dashboard` (Landing page after login, customized by role)

### Products Module (Katalog & Inventori)
├── `/products` — List view with search, category filter, stock level badges, pagination
├── `/products/new` — Add product form (extended specification below)
├── `/products/:id` — Single product detail view, sales history, stock per location
├── `/products/:id/edit` — Edit product form (inline validation, duplicate barcode prevention)
└── `/products/categories` — Product category CRUD table and hierarchy

### POS & Transactions Module
├── `/pos` — Fast cashier interface with barcode scan, numpad, cart, quick checkout
├── `/transactions` — Full transaction history table with date/status/payment filters
├── `/transactions/new-sale` — Form-based sales entry for invoice/custom billing
├── `/transactions/new-purchase` — Purchase order / incoming stock entry form
└── `/transactions/:id` — Transaction detail with line items, receipt print/PDF export

### Stock Management Module
├── `/stock/adjustments` — Stock adjustment log (opname history, discrepancy values)
├── `/stock/adjustments/new` — New stock adjustment request form
└── `/stock/adjustments/pending` — Manager approval queue for adjustments > threshold

### Receivables & Payables Module (Hutang-Piutang)
├── `/receivables` — Customer receivables list with aging buckets (0-30, 31-60, 60+ days)
├── `/receivables/:id` — Customer ledger detail with outstanding balance & payment history
├── `/receivables/new` — Manual invoice/piutang recording form
├── `/payables` — Supplier payables list with due dates and payment terms
├── `/payables/:id` — Supplier ledger detail with bills & payment records
└── `/payables/new` — Manual purchase bill/hutang recording form

### Reports Module (Laporan Finansial)
├── `/reports/profit-loss` — Income statement (Laba-Rugi: Revenue, COGS, Gross Margin)
└── `/reports/inventory` — Stock valuation, turnover rate, and slow-moving SKU report

### User Management Module (Owner/Admin only)
├── `/users` — User directory list with role badges, active status, branch assignment
├── `/users/invite` — Staff invitation form (email, name, role selection, location access)
└── `/users/:id` — User detail and permission inspection modal/page

### Settings Module (Pengaturan Sistem)
├── `/settings/profile` — User profile, contact, avatar upload
├── `/settings/security` — Password change, session management, 2FA setup
├── `/settings/preferences` — Language, date/currency formatting, dark mode toggle
├── `/settings/organization` — Legal business identity, address, tax configuration
├── `/settings/receipt` — Thermal receipt layout, header/footer text, print logo
└── `/settings/notifications` — Notification preferences (low-stock alerts, daily digests)
```

---

### Extended Screen Documentation Format

For all non-trivial screens (forms, details, data tables, POS), agents **MUST** document each screen using the extended format below.

```markdown
### Screen: Add Product (SCR-006)

**Route**: `/products/new`
**Purpose**: Owner/Manager adds new product SKU to inventory master data
**Components**: FormField (8), Input (5), Select (2: category, unit), ImageUpload (1), Button (2: Cancel, Save)
**Layout**: Single column max-w-2xl, card container, padding 24px

**Sections**:
- Header: Title "Tambah Produk", Breadcrumb `Home > Produk > Tambah Produk`
- Form Body: 8 fields (name*, SKU*, barcode, category dropdown*, buy price*, sell price*, stock*, min_stock*, unit dropdown*, image upload)
- Footer: Cancel (secondary button), Save (primary button)

**States**:
- Pristine: Empty form, Save button enabled (clicking triggers inline validation and auto-focuses first invalid field per anti-disabled pristine rule)
- Validating: Inline validation on blur (SKU unique check, sell price >= buy price, prices > 0)
- Invalid: Inline error message in red (min 13px, ≥4.5:1 contrast) below affected input, Save button remains clickable to trigger auto-focus on first invalid field
- Submitting: Save button shows loading spinner "Menyimpan...", all form inputs disabled
- Success: Redirect to `/products/:id` (detail view), show toast "Produk berhasil ditambahkan"
- Error: Show floating error toast "Gagal menyimpan produk: [Alasan]", re-enable inputs

**Breadcrumb**: `Home > Produk > Tambah Produk`

**Data Context**:
- Example Name: "Indomie Goreng Pedas 85g"
- Example SKU: "IDM-001"
- Example Barcode: "8998866200115"
- Example Category: "Makanan & Minuman > Mie Instan"
- Example Pricing: Buy Price Rp 2.500, Sell Price Rp 3.000
- Example Inventory: Stock 120 pcs, Min Stock 50 pcs, Unit "pcs"

**RBAC**: Owner + Manager only (Kasir role blocked, redirects to 403 Forbidden with prompt to contact Owner)
```

#### Enforcement Rules
- **MUST use extended format** for:
  - All form screens (create, add, edit, setup)
  - All detail screens (single record viewer, ledger cards, transaction receipts)
  - All list screens with dynamic data tables (table columns, filter sets, empty/loading states)
  - High-interaction screens (cashier POS, dashboard widgets, approval queues)
- **Lightweight 1-line format allowed** for:
  - Static legal pages (terms, privacy)
  - Simple terminal redirects (`/onboarding/complete` → `/dashboard`)
  - Standard HTTP error boundary pages (`/403`, `/404`, `/500`)

---

### User Flows (Critical Paths — MANDATORY)

Document 3 to 5 critical end-to-end user journeys covering the core value proposition of the system.

#### Format per Flow
1. **Entry point**: Initial screen route
2. **Step-by-step navigation**: Screen → user action → system response → next screen
3. **Decision points**: Conditional branches (`if/else`)
4. **Success exit**: Final terminal destination and confirmation
5. **Error handling**: Failure scenarios, input corrections, and recovery paths

#### Production Examples

```markdown
### Flow 1: Onboarding (First-Time User Setup)
1. Signup `/signup` → enter name, business email, password → submit.
2. Verify email `/verify-email/:token` → user clicks verification link sent via email.
3. Login `/login` → system detects first-time account → redirects to `/onboarding/step-1`.
4. Welcome screen `/onboarding/step-1` → click "Mulai Setup Bisnis".
5. Organization setup `/onboarding/step-2` → input nama usaha ("Toko Berkah Mandiri"), jenis usaha, NPWP (optional) → click "Lanjut".
6. Location setup `/onboarding/step-3` → input cabang utama ("Toko Pusat - Surabaya"), alamat lengkap → click "Lanjut".
7. Staff invite `/onboarding/step-4` → input email kasir/manager (or click "Lewati untuk sekarang").
8. Complete `/onboarding/complete` → click "Buka Dashboard" → redirect to `/dashboard`.

**Alternative Branch**: If user was invited by an Owner (received `/users/invite?token=xxx`) → complete password setup → skip onboarding wizard → redirect directly to `/dashboard`.

---

### Flow 2: Daily Sales Checkout (Kasir Role)
1. Login `/login` → dashboard `/dashboard` → click quick action "Buka Kasir POS".
2. POS screen `/pos` → barcode scanner fires or user types SKU "IDM-001" in search box.
3. Product card displayed → click product or press Enter → item added to cart with default qty 1.
4. Adjust quantity if needed (`+` / `-` / direct input) → unit price & subtotal auto-calculated from master data.
5. Select payment method from dropdown or hotkey: Tunai (Cash), QRIS, Transfer Bank, or Piutang (Kredit).
6. **If Kredit (Piutang)**:
   - Customer name field required (search existing customer or type new name "Warung Bu Siti").
   - Due date picker appears (default: +30 calendar days).
   - On submit, system automatically creates invoice and increments receivables balance.
7. Submit sale (`F9` / click "Bayar") → system validates stock availability.
8. Thermal print dialog opens OR PDF receipt download starts → cart clears automatically → cursor refocuses to barcode search for next customer.
9. **Error Handling**: If stock insufficient (e.g., requested 150 pcs, stock only 120 pcs) → display modal "Stok tidak mencukupi, sisa stok: 120 pcs" → checkout disabled until quantity is adjusted.

---

### Flow 3: Stock Adjustment Approval (Manager Role)
1. Manager logs in → `/dashboard` displays badge notification "3 Penyesuaian Stok Menunggu Persetujuan".
2. Click notification badge → redirects to `/stock/adjustments/pending`.
3. List view renders table: Tanggal, Nama Produk, Lokasi Cabang, Selisih Qty (-5 pcs), Alasan ("Kemasan Rusak"), Pemohon (Kasir Andi), Nilai Kerugian (Rp 12.500).
4. Manager clicks row → opens detail drawer with before/after stock quantities, photo attachment proof, and full audit trail.
5. Manager decision:
   - **Approve**: System updates inventory ledger, creates permanent audit log entry, sends notification to requester, removes row from pending list.
   - **Reject**: System requires rejection notes (min 10 characters), stock remains unchanged, requester receives notification with rejection reason.
6. Redirect / refresh `/stock/adjustments/pending`.
```

---

### Comprehensive Breadcrumbs (25+ Examples)

Breadcrumbs provide critical context awareness across deep hierarchical structures.

**Pattern**: `Home > [Module] > [List/Detail/Action] > [Sub-action]`
**Implementation Rule**: All parent segments are clickable routes. The terminal segment representing the active page is plain text (non-clickable).

```markdown
## Breadcrumbs (Context Awareness)

### Dashboard & Core
1. `Home` → Dashboard overview (`/dashboard`)
2. `Home > Onboarding` → Setup wizard (`/onboarding/step-1`)

### Products Module
3. `Home > Produk` → Product list (`/products`)
4. `Home > Produk > Tambah Produk` → Create product form (`/products/new`)
5. `Home > Produk > Indomie Goreng 85g` → Product detail view (`/products/IDM-001`)
6. `Home > Produk > Indomie Goreng 85g > Edit` → Edit product form (`/products/IDM-001/edit`)
7. `Home > Produk > Kategori` → Product category manager (`/products/categories`)

### POS & Transactions
8. `Home > POS` → Fast cashier screen (`/pos`)
9. `Home > Transaksi` → Transaction list (`/transactions`)
10. `Home > Transaksi > TRX-20261005-001` → Transaction detail view (`/transactions/TRX-001`)
11. `Home > Transaksi > TRX-20261005-001 > Void` → Transaction cancellation modal (`/transactions/TRX-001/void`)
12. `Home > Transaksi > Catat Penjualan` → Manual sales order form (`/transactions/new-sale`)
13. `Home > Transaksi > Catat Pembelian` → Purchase order form (`/transactions/new-purchase`)

### Stock Management
14. `Home > Stok` → Stock overview (`/stock`)
15. `Home > Stok > Riwayat Adjustment` → Adjustment log (`/stock/adjustments`)
16. `Home > Stok > Adjustment Baru` → Create stock opname form (`/stock/adjustments/new`)
17. `Home > Stok > Pending Approval` → Manager approval queue (`/stock/adjustments/pending`)

### Receivables & Payables (Hutang-Piutang)
18. `Home > Piutang` → Customer receivables list (`/receivables`)
19. `Home > Piutang > Warung Bu Siti` → Customer receivable detail (`/receivables/CUST-001`)
20. `Home > Piutang > Warung Bu Siti > Catat Pembayaran` → Record payment modal (`/receivables/CUST-001/pay`)
21. `Home > Hutang` → Supplier payables list (`/payables`)
22. `Home > Hutang > PT Indofood` → Supplier payable ledger (`/payables/SUPP-001`)
23. `Home > Hutang > PT Indofood > Bayar Hutang` → Settle bill modal (`/payables/SUPP-001/pay`)

### Financial Reports
24. `Home > Laporan > Laba-Rugi` → Income statement report (`/reports/profit-loss`)
25. `Home > Laporan > Valuasi Inventori` → Stock valuation report (`/reports/inventory`)

### Users & Settings
26. `Home > User Management` → Staff user directory (`/users`)
27. `Home > User Management > Undang Staf` → Invite staff modal/screen (`/users/invite`)
28. `Home > Pengaturan > Profil` → User profile settings (`/settings/profile`)
29. `Home > Pengaturan > Organisasi` → Organization profile (`/settings/organization`)
30. `Home > Pengaturan > Format Struk` → Receipt layout designer (`/settings/receipt`)
```

---

### Navigation Structure Detail

Production sitemaps must specify both desktop and mobile navigation hierarchies.

```markdown
## Navigation Structure

### Desktop Navigation (Sidebar + Top Bar)

**Sidebar Hierarchy**: Fixed 240px width (collapsible to 64px icon rail on viewports <1280px).

```text
[Logo] TataBuku      [Cabang Surabaya ▼]       🔔 [3]       [Avatar ▼]

🏠 Dashboard            (/dashboard)
🛒 POS (Kasir Cepat)    (/pos)                    ← Highlighted shortcut for Kasir role

📦 Produk               (/products)
   ├─ Daftar Produk     (/products)
   └─ Kategori          (/products/categories)

💰 Transaksi            (/transactions)
   ├─ Riwayat Transaksi (/transactions)
   ├─ Catat Penjualan   (/transactions/new-sale)
   └─ Catat Pembelian   (/transactions/new-purchase)

📊 Stok                 (/stock)
   ├─ Penyesuaian Stok  (/stock/adjustments)
   └─ Butuh Approval    (/stock/adjustments/pending) [Badge 3]

💸 Hutang-Piutang       (/receivables)
   ├─ Piutang Pelanggan (/receivables)
   └─ Hutang Supplier   (/payables)

📈 Laporan              (/reports/profit-loss)
   ├─ Laba-Rugi         (/reports/profit-loss)
   └─ Laporan Stok      (/reports/inventory)

👥 User Management      (/users)                  ← Visible only to Owner (ROL-01)

⚙️  Pengaturan           (/settings/profile)
   ├─ Profil Akun       (/settings/profile)
   ├─ Keamanan & Sandi  (/settings/security)
   ├─ Identitas Usaha   (/settings/organization)
   └─ Pengaturan Struk  (/settings/receipt)
```

**Desktop Sidebar Invariants**:
- Active link state: `bg-cyan-50 text-cyan-900 border-l-4 border-cyan-600 font-semibold`
- Child item indentation: 16px left padding under parent accordion
- Permission pruning: Menu items are completely hidden from DOM if user lacks role access (not just disabled)

**Desktop Top Bar Components**:
- **Brand Mark**: Left-aligned, click redirects to `/dashboard`
- **Location Switcher Dropdown**: Allows filtering dashboard and stock data by branch ("Semua Lokasi", "Cabang Surabaya", "Cabang Jakarta", "+ Tambah Cabang")
- **Alert Center (Bell Icon)**: Shows unread badge count (low-stock alerts, pending stock adjustment approvals)
- **Profile Menu**: User avatar, user name, role badge, quick link to `/settings/profile`, and explicit Logout button (`POST /api/auth/logout`)

---

### Mobile Navigation (Bottom Tabs + More Drawer)

On viewports <768px, navigation shifts to a sticky 64px bottom tab bar with maximum 5 slots:

```text
[ 🏠 Home ]   [ 🛒 POS ]   [ 💰 Transaksi ]   [ 📦 Produk ]   [ ⋯ Lainnya ]
```

**Tab Distribution**:
1. **Home**: `/dashboard` (high-level KPI cards and quick action tiles)
2. **POS**: `/pos` (full-screen mobile cashier interface with barcode button)
3. **Transaksi**: `/transactions` (scrollable daily sales stream)
4. **Produk**: `/products` (searchable product catalog with floating add button)
5. **Lainnya (More Drawer)**: Bottom sheet modal containing remaining modules:
   - 📊 Stok (Penyesuaian & Approval)
   - 💸 Hutang & Piutang
   - 📈 Laporan Laba-Rugi
   - 👥 User Management (Owner only)
   - ⚙️ Pengaturan & Logout

**Mobile Navigation Rules**:
- Auto-hide tab bar when soft keyboard is opened on input focus (prevent viewport distortion)
- Active tab indicator: Icon fill in brand primary (`#0891B2`), label in 11px font weight 600
```

---

### Phase Delineation (MVP vs Deferred)

Every production sitemap must explicitly draw boundary lines to prevent scope creep during sprint execution.

```markdown
## Phase Delineation

### MVP Scope (35-48 screens — Core Launch Criteria)
Must-Have foundational features to achieve initial traction:
- Public & Authentication (8 screens): Landing, login, signup, forgot password, reset password, verify email, legal terms, privacy.
- Onboarding Wizard (5 screens): Business name, tax ID, branch location, staff invite, completion.
- Dashboard (1 screen): Role-specific sales metrics, low stock indicators, quick actions.
- Product Catalog (5 screens): List, add, detail, edit, categories.
- Sales & POS (5 screens): Mobile cashier, transaction history, detail view, manual sale, manual purchase.
- Stock Management (3 screens): Adjustment log, new adjustment, pending approval queue.
- Hutang-Piutang (6 screens): Receivables list/detail/pay, payables list/detail/pay.
- Reports (2 screens): Profit & Loss (Revenue - COGS = Gross Margin), Inventory valuation.
- Users & Admin (3 screens): Staff list, invite modal, detail permissions.
- Settings (6 screens): Profile, security, preferences, organization, receipt layout, notifications.

---

### Phase 1.5 Scope (Deferred — Post-Launch Validation)
Features explicitly deferred until 30 days post-launch:

1. **Beban Operasional / Operational Expenses (3 screens)**:
   - `/expenses` — Expense history table with category filters
   - `/expenses/new` — Record operational expense (rent, electricity, salaries, receipt attachment upload)
   - `/expenses/:id` — Expense detail view and edit
   - *Rationale*: MVP tracks Gross Profit (Penjualan - HPP). Operational expenses can be managed via spreadsheet during initial MVP validation without complicating financial logic.

2. **Mutasi Antar Cabang / Stock Transfers (2 screens)**:
   - `/stock/transfers` — Stock transfer history and transit statuses
   - `/stock/transfers/new` — Transfer initiation form with source/destination selection
   - *Rationale*: Multi-location businesses can coordinate branch restocking via phone/chat in early stages; avoids building transit approval workflows upfront.

3. **Shift Kasir & Tutup Kas / Cash Drawer Reconciliation (1 screen)**:
   - `/shift/close` — End-of-shift cash drawer count, discrepancy calculation, cashier handover
   - *Rationale*: Requires physical cash drawer integration and shift scheduling logic; manual physical counting is sufficient for MVP.

---

### Phase 2 Scope (Future Enhancements — Post-Traction >500 Users)
Features deferred until product-market fit is established:

1. **Audit Trail Viewer (`/admin/audit-log`)**: System-wide event viewer (who changed what, IP address, timestamp).
2. **Pusat Notifikasi Terpadu (`/notifications`)**: Dedicated in-app notification center inbox.
3. **Billing & Langganan SaaS (`/settings/billing`)**: Integrated credit card / payment gateway recurring subscriptions.
4. **Pusat Bantuan & Tutorial (`/help`)**: In-app knowledge base and video walkthrough player.
```

---

### Real Business Data Context Requirements

Generic placeholders like `"Product A"`, `"User 1"`, and `"Category X"` are **strictly forbidden** in sitemaps and wireframes.

#### Rationale
Real business entities expose layout bugs early:
- Indonesian names have variable length and specific formatting (e.g., "PT Sumber Alfaria Trijaya Tbk").
- Pricing in Rupiah uses thousand dots without decimals (`Rp 1.250.000`), whereas US SaaS uses comma separators and 2 decimal points (`$1,250.00`).
- Addresses in Indonesia contain RT/RW, Kelurahan, Kecamatan, and 5-digit postal codes across 3-4 lines.

#### Context Matrix

| Domain Element | Indonesian Business Context | US SaaS Context |
| :--- | :--- | :--- |
| **Currency** | `Rp 1.250.000` (no decimals) | `$1,250.00` (2 decimals) |
| **SKU Example** | `IDM-001`, `BBM-GRG-02` | `LOG-MX3-BLK`, `APL-MBP-14` |
| **Product Name** | "Indomie Goreng Pedas 85g", "Beras Ramos 5kg" | "Logitech MX Master 3S Mouse", "MacBook Pro 14\"" |
| **Category** | "Makanan & Minuman > Mie Instan" | "Electronics > Computer Accessories" |
| **Customer** | "Warung Bu Siti", "Toko Sembako Barokah" | "Acme Corp", "Wayne Enterprises" |
| **Address** | "Jl. Raya Darmo No. 123, Wonokromo, Surabaya 60241" | "500 Howard St, Suite 400, San Francisco, CA 94105" |
| **Date Format** | DD/MM/YYYY (`05/10/2026`) | MM/DD/YYYY (`10/05/2026`) |
| **Tax ID** | NPWP (16 digit: `01.234.567.8-901.000`) | EIN / SSN (`12-3456789`) |

---

### RBAC Documentation Per Screen & Module

Every authenticated screen entry in `SITEMAP.md` must declare its access control rules to prevent post-release authorization holes.

#### Standard Role Matrix (Retail/SaaS Default)
1. **Owner (ROL-01)**: Unrestricted access across all screens, organizational settings, financial ledgers, and user invitations.
2. **Manager (ROL-02)**: Operational authority. Can manage products, create transactions, view inventory, and approve stock adjustments. Cannot alter organization billing, banking details, or delete users.
3. **Kasir / Cashier (ROL-03)**: Restricted terminal access. Allowed exclusively on `/pos`, daily sales stream, and personal profile. Blocked from financial reports, cost prices (HPP), and system settings.
4. **Akuntan / Accountant (ROL-04)**: Read-heavy audit role. Full access to `/reports/*`, transaction ledgers, receivables/payables, and tax exports. Cannot execute POS checkout or alter inventory balances.

#### RBAC Specification Format
Attach RBAC tags directly to modules or extended screen definitions:

```markdown
### Screen: Profit-Loss Report (SCR-025)
**Route**: `/reports/profit-loss`
**RBAC**: Owner (ROL-01) [Full], Akuntan (ROL-04) [Read/Export], Manager (ROL-02) [Read-Only]
**Blocked**: Kasir (ROL-03) → Intercepted by middleware, redirects to `/403` with notice: "Akses laporan keuangan hanya untuk Owner/Akuntan."
```

---

### Screen Count by Module Table

Include an explicit summary table reconciling scope against screen count:

| Module | MVP Screens | Phase 1.5 Deferred | Phase 2 Future | Roles Allowed |
| :--- | :---: | :---: | :---: | :--- |
| Public & Legal | 8 | 0 | 0 | Unauthenticated |
| Onboarding Wizard | 5 | 0 | 0 | Authenticated (New User) |
| Dashboard | 1 | 0 | 0 | All Roles (Personalized) |
| Products & Catalog | 5 | 0 | 0 | Owner, Manager |
| POS & Transactions | 5 | 1 | 0 | Kasir, Manager, Owner |
| Stock & Inventory | 3 | 2 | 0 | Manager, Owner |
| Receivables & Payables | 6 | 0 | 0 | Owner, Manager, Akuntan |
| Financial Reports | 2 | 3 | 0 | Owner, Akuntan |
| User Management | 3 | 0 | 1 | Owner Only |
| System Settings | 6 | 0 | 2 | Owner, All (Profile only) |
| **TOTAL** | **44** | **6** | **3** | **Production Scale** |

---

### Example Applications Across Different Scales

**Small MVP (15-20 screens)**: Solo utility, developer tool, or simple single-role SaaS.
```text
Public: /, /login, /signup, /forgot-password
Core: /dashboard, /projects, /projects/new, /projects/:id, /projects/:id/edit
Settings: /settings/profile, /settings/billing
Total: ~15 screens
```

**Medium Production App (30-50 screens)**: Multi-role B2B SaaS, SME ERP, accounting, inventory (e.g., TataBuku).
```text
Public & Onboarding: 10-12 screens
Operational Modules (Products, Sales, Stock, Ledger): 20-25 screens
Reports, Admin, Settings: 10-15 screens
Total: 35-50 screens
```

**Large Enterprise System (60-100+ screens)**: Multi-tenant ERP, supply chain, multi-branch operations.
```text
Requires phased documentation: MVP core sitemap (40-50 screens) documented in full extended detail, with Phase 1.5/2 modules cataloged in deferred architecture specs.
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

### Option B: AI-Assisted Visual Prototyping (v0.dev / Google Stitch / Uizard)

**Tools**: v0.dev by Vercel, Google Stitch, Uizard, Galileo AI

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
- ✅ Low cost (freemium tiers available)

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

**Example Prompt (v0 / Stitch / AI Prototyping)**:
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
- Typography: Inter font, weights 400/500/600/700, line-height 1.6
- Shadows: 0 1px 3px rgba(0,0,0,0.1) only (no heavy shadows)
- Layout: Sidebar 240px fixed, main content max-w-7xl, padding 24px
- Spacing: Tailwind scale (4/8/16/24/32px)
- Table: Zebra striping (even rows bg-zinc-50), sticky header
```

---

### Option C: Hybrid (Recommended for Solo Developer)

**Best of Both Worlds**

**Workflow**:
1. **AI wireframes** (v0.dev / Google Stitch): Generate initial screen wireflows rapidly (1 day)
   - Focus: Layout structure, component placement, navigation flow
   - Accept: 80% quality (not pixel-perfect yet)

2. **Manual polish** in Figma (if needed) (1-2 days):
   - Export Prototype designs to Figma (via HTML → Figma plugin)
   - Polish: Typography hierarchy, spacing consistency, color refinement
   - Add brand-specific elements (custom icons, illustrations, photography)
   - Create reusable component library from AI output

3. **Code implementation** (Module 06):
   - Use Prototype-generated code as starting point (HTML structure, Tailwind classes)
   - Refactor to match codebase patterns (component composition, naming conventions)
   - Replace placeholder data with real data from database

**Pros**:
- ✅ 70% faster than full manual (AI handles boilerplate structure)
- ✅ Better quality than pure AI (manual polish for brand consistency)
- ✅ Reusable design system (Figma library for future updates)
- ✅ Balanced cost (AI free tier + 1-2 days design time vs 2-3 weeks full manual)

**Cons**:
- ⚠️ Still requires basic Figma skills for polishing
- ⚠️ Two tools overhead (learning both Prototype + Figma)

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
**MANDATORY BEFORE STEP 1** for all projects (client or solo product).

**Directive**: Generate minimal brief (2KB max). Do NOT generate over-prescriptive design documents or pre-baked concepts.

1. **Create document `docs/specs/LOGO_DESIGN_BRIEF.md`** with ONLY these 5 elements:
   - **Product Name + Philosophy**: 2-3 sentences on what the product does and why it exists.
   - **Target User**: 1 sentence defining primary audience.
   - **Brand Vibe**: 4-5 keywords (e.g., trustworthy, practical, modern).
   - **User Responsibility**: Explicit note that user generates the logo, extracts colors from the chosen logo, and saves asset files.
   - **Empty AI Prompt Template**: Minimal prompt skeleton with placeholder:
     ```text
     [UPLOAD YOUR LOGO REFERENCES HERE]

     Create a modern, minimal vector logo inspired by the style and structure of the reference images above.
     Product: [Product Name] - [Philosophy]
     Target User: [Audience]
     Vibe: [Keywords]
     Constraints: Flat vector, high contrast, transparent background, works at 16px favicon and 512px icon. No gradients, no 3D effects.
     ```

2. **ANTI-PATTERNS (What NOT to Include)**:
   - ❌ **NO Logo concept ideas**: Omit Lettermark, Grid, Book+Chart, Wordmark directions (user brainstorms concepts).
   - ❌ **NO Color recommendations**: Do not pre-select cyan `#0891B2`, emerald `#10B981`, etc. (user extracts colors from chosen logo).
   - ❌ **NO Ready-made AI prompts**: Do not provide pre-written multi-variant prompts (user crafts based on references).
   - ❌ **NO Style references list**: Omit pre-selected lists like Linear, Notion, Stripe (user picks own references).
   - ❌ **NO Technical specs detail**: Omit export size matrices, file naming rules, and 20+ item deliverables checklists.

3. **Inform User Explicitly**:
   > "Minimal logo design brief created at `docs/specs/LOGO_DESIGN_BRIEF.md` (<2KB). Add your visual references to the prompt template, generate the logo, extract your primary/accent colors for `DESIGN.md`, and save SVG assets to `/assets/logo/`. Once ready, proceed to Step 0B (SITEMAP.md). **Alternatively, we can proceed with a placeholder logo and finalize branding before launch.**"

4. **Wait for User Decision** (Do NOT proceed automatically):
   - User generates logo now → Extract brand colors from user logo, save to `/assets/logo/`, proceed to Step 0B
   - User wants placeholder → Proceed to Step 0B with placeholder logo note

**Why This is Mandatory**:
- User extracts actual brand colors from logo to inform `DESIGN.md` palette
- Prevents premature design decisions and over-prescriptive AI slop
- User maintains full creative control over branding without blocking workflow progress

---

### Step 0B: Generate SITEMAP.md (MANDATORY - Information Architecture)
**PREREQUISITE for all workflows (Manual, AI, or Hybrid)**. Shallow 1-line route maps are strictly prohibited.

**Duration**: 1.5-3 hours (for 30-50 screens with full extended detail)
- 30-45 min: Read `SCOPE_STATEMENT.md`, extract feature set, group into functional modules
- 45-60 min: Document screens using extended format (10-15 screens/hour at full detail)
- 15-30 min: Document 3-5 critical user flows (onboarding, daily tasks, approvals)
- 10-15 min: Write 20+ comprehensive breadcrumb examples
- 10-15 min: Detail desktop sidebar and mobile navigation structures
- 10 min: Define phase delineation (MVP vs Phase 1.5 and Phase 2 deferred screens)
- 10 min: Execute verification checklist and audit gate

**Time scales with screen inventory**:
- 15-20 screens: ~1.5 hours
- 30-45 screens: ~2.5 hours
- 50-60+ screens: ~3-4 hours (recommend strict phasing: MVP core first, Phase 1.5/2 documented as deferred)

---

### Step 0B Process

1. **Read SCOPE_STATEMENT.md** from Module 02:
   - Extract all user stories (As a [role], I want to [action], so that [benefit])
   - Group into functional domains (Auth, Onboarding, Products, POS, Stock, Ledgers, Reports, Settings)
   - Identify public vs authenticated route boundaries
   - Map role-based permissions (Owner, Manager, Kasir, Akuntan)

2. **Generate `docs/specs/SITEMAP.md`** following Section 2A standard:
   - Executive summary with role matrix
   - Extended screen format for all forms, details, tables, and POS screens
   - 3-5 critical user flows with branching and error handling
   - 20+ breadcrumb navigation examples
   - Desktop sidebar (240px) + mobile bottom tabs (5 slots max)
   - Phase delineation (MVP in-scope vs Phase 1.5 / Phase 2 deferred with rationale)
   - Real business data context (locale-appropriate entities, zero generic placeholders)
   - RBAC rules per module and high-risk screens

3. **SITEMAP.md Verification Checklist**:

   **Completeness Checks**:
   - [ ] Every in-scope feature / user story from `SCOPE_STATEMENT.md` maps to at least one screen
   - [ ] Every screen is justified by an approved requirement (flag uncovered stories or out-of-scope screens)
   - [ ] Complete authentication flow (Login, Signup, Forgot, Reset, Verify Email, Legal Terms)
   - [ ] Onboarding flow documented for first-time account setup

   **Quality Checks**:
   - [ ] 3-5 critical user flows documented for core journeys (entry point, navigation steps, decision branches, success exit, error handling)
   - [ ] Breadcrumbs covering all nested paths (20+ examples for medium/large apps; full coverage of nested routes for small MVPs)
   - [ ] Desktop sidebar (240px hierarchy) and mobile tabs (5 slots max) documented with active states and permission rules
   - [ ] Phase 1.5 and Phase 2 deferred screens documented with concrete technical/commercial rationale

   **Consistency Checks**:
   - [ ] RBAC boundaries clearly stated per module and for sensitive actions
   - [ ] Real business data context used throughout (Indonesian or US SaaS real entities; zero "Product A", "User 1")
   - [ ] No orphaned routes: every authenticated route is reachable via sidebar, mobile tabs, or settings
   - [ ] No duplicate routes (e.g., consolidate `/setup/org` vs `/settings/org`)

   **Technical Checks**:
   - [ ] Route order documented (e.g., static `/users/invite` declared before dynamic `/users/:id` to prevent framework collision)
   - [ ] Consistent dynamic route param naming (e.g., `:id` for records, `:slug` for URL strings)
   - [ ] File size ≥2000 bytes (indicates extended documentation rather than shallow 1-line stubs; >10KB for medium/large 30+ screen apps)

4. **Agent Verification Script (Pseudo-code)**:

   ```python
   def verify_sitemap(sitemap_md: str, scope_statement_md: str):
       # 1. Validate scope coverage (every story maps to screen)
       uncovered_stories = check_story_coverage(sitemap_md, scope_statement_md)
       if uncovered_stories:
           raise VerificationError(f"Uncovered user stories: {', '.join(uncovered_stories)}")

       # 2. Check user flows
       user_flows = extract_sections(sitemap_md, "## User Flows")
       if len(user_flows) < 2:
           raise VerificationError(f"Found {len(user_flows)} user flows; minimum 2 required for small MVPs, 3-5 for medium/large apps.")

       # 3. Check breadcrumbs
       breadcrumbs = extract_list_items(sitemap_md, "## Breadcrumbs")
       if len(breadcrumbs) < 5:
           raise VerificationError("Missing breadcrumbs: must document nested paths and screen contexts.")

       # 4. Check for generic placeholder slop
       banned_placeholders = ["Product A", "User 1", "Category X", "Item 1", "Example Company"]
       for banned in banned_placeholders:
           if banned in sitemap_md:
               raise VerificationError(f"Generic placeholder '{banned}' detected. Use real business context.")

       # 5. Check navigation architectures
       if "Navigation Structure" not in sitemap_md:
           raise VerificationError("Missing navigation architecture specification.")

       # 6. Check minimum size
       if len(sitemap_md.encode('utf-8')) < 2000:
           raise VerificationError("SITEMAP.md is under 2000 bytes. Extended screen format required.")

       return True
   ```

5. **Protocol If Verification Fails**:
   - **STOP immediately**: Do not proceed to `DESIGN.md` or Step 1.
   - Display failure summary:
     ```text
     ❌ SITEMAP.md Verification Failed
     - Coverage: [Uncovered stories or out-of-scope screens]
     - User flows: [Actual count] documented
     - Breadcrumbs: [Actual count] documented
     - Violations: [List specific placeholders or missing sections]
     Decision required: Fix now (regenerate with full detail) or Confirm scope modification?
     ```
   - Wait for explicit user instruction before advancing.

6. **PowerShell Gate Verification**:

   ```powershell
   # GATE CHECK - Step 0B
   if (-not (Test-Path "docs/specs/SITEMAP.md")) {
       Write-Error "STEP 0B FAILED: File docs/specs/SITEMAP.md not found."
       exit 1
   }

   $sitemapContent = Get-Content "docs/specs/SITEMAP.md" -Raw
   if ($sitemapContent.Length -lt 2000) {
       Write-Error "SITEMAP.md is too small ($($sitemapContent.Length) bytes < 2000 bytes). Shallow 1-line format detected. Extended format required."
       exit 1
   }

   Write-Host "✅ STEP 0B PASS: SITEMAP.md verified ($(($sitemapContent.Length)) bytes)"
   ```

7. **Inform User**:
   > "SITEMAP.md has been generated at `docs/specs/SITEMAP.md` ([X] KB) containing [X] MVP screens + [Y] deferred screens across [Z] modules. Includes 5 user flows, 27 breadcrumbs, full desktop/mobile navigation specs, and role-based access rules. Review the sitemap before selecting the design workflow."

8. **WAIT for User Approval**:
   > "Is this sitemap structure correct? If yes, choose a workflow:
   > - **A) Manual Figma** (2-3 weeks, pixel-perfect)
   > - **B) AI-Assisted** (1-3 days, direct code)
   > - **C) Hybrid** (3-5 days, AI + manual polish)
   > 
   > Type A/B/C to proceed, or request changes to the sitemap."

**Why This is Mandatory**:
- Sitemap = blueprint for all screens (prevents missing pages in design)
- Extended format locks UI component inventory and interaction states before writing specs
- 5-state matrix and user flows prevent blank-screen syndrome and unhandled edge cases
- Screen count validation = early detection of scope creep
- Navigation and breadcrumbs locked early = consistent UX hierarchy across desktop and mobile
- Prerequisite for effort estimation (18 screens vs 48 screens = fundamentally different timeline)

---

### Step 0.5: Visual Reference Gathering & Brand Synthesis (MANDATORY)

**PREREQUISITE BEFORE STEP 1**: Agents are strictly forbidden from hallucinating design tokens, inventing generic Zinc palettes, or generating `DESIGN.md` in a vacuum without grounded visual references and brand asset alignment.

#### 1. Automatic Scaffolding & Directory Setup
The agent MUST execute:
```bash
mkdir -p docs/design/inspiration/
```

#### 2. Mandatory Turn Stop (User UI Screenshots)
**STRICT TURN STOP PROTOCOL**: The agent **MUST HALT** and prompt the user to provide 2–5 high-quality UI reference screenshots placed into `docs/design/inspiration/`:
> "Visual inspiration workspace initialized at `docs/design/inspiration/`. Before generating `DESIGN.md`, please drop 2–5 UI reference screenshots (web apps, dashboards, or mobile interfaces whose visual style, density, and typography you admire) into `docs/design/inspiration/`. Alternatively, provide URLs or specific visual direction. **Waiting for your references to extract grounded design tokens.**"

**No-Reference Fast-Track (Bypass Path)**:
If the user states they have no visual references (e.g., small solo MVP, standard internal tool, or prefers default best practices), the agent proceeds directly by deriving tokens from `docs/specs/LOGO_DESIGN_BRIEF.md`, project domain conventions (e.g., HRIS, CRM, DevTools), and mathematically validated accessible defaults. Document the baseline rationale in `docs/design/inspiration/notes.md`.

#### 3. Vision Extraction Protocol
Once reference screenshots are provided, analyze them systematically:
- **Color Palette & Surface Elevation**: Extract dominant background tones, card elevation shifts, text contrasts, and primary/secondary accent candidates.
- **Corner Geometry**: Measure border-radius scale (sharp 4px vs refined 6-8px vs pill/rounded).
- **Elevation & Shadows**: Analyze depth approach (flat 1px borders, subtle 1-3px ambient shadows, or layered elevation).
- **Typography Hierarchy**: Font family style (grotesque sans, geometric sans, monospace accents), weight contrast, and heading scale.
- **Layout Density & Spacing**: Compact high-density data tables vs spacious consumer dashboard grids.

#### 4. Logo Cross-Alignment & Brand Harmonization
- Inspect `/assets/logo/` and `docs/specs/LOGO_DESIGN_BRIEF.md`:
  - Extract the exact primary and accent hex codes from the brand logo (e.g., `#ECECE3` monogram on `#000000` base).
  - **Harmonize Neutrals to Brand Warmth**:
    - If the logo/brand uses warm hues (40°–60°, paper/cream/warm stone), the neutral scale MUST use matching warm undertones (`#F5F5F0`, `#E8E8E0`, `#2B2B28`).
    - If the logo uses cool tech blues (200°–240°), use cool zinc/slate neutrals.
    - **Anti-Slop Rule**: Never default lazily to standard cold Zinc-240° when the brand identity is warm monochrome.

#### 4.5 Benchmark Selection: Pick 1 Primary Winner ("Paling OK")
The agent MUST NOT blend conflicting styles incoherently. The agent reviews the analyzed references alongside `docs/specs/LOGO_DESIGN_BRIEF.md` and makes an explicit choice:
- **Select 1 Primary Design Benchmark**: Choose the single reference that best fits the domain density, user archetype, and logo temperament (e.g., "Reference A (Linear-style dark density) selected as primary benchmark").
- **Logo Cohesion**: If the logo brand has distinctive geometry (e.g., sharp corners, specific saturation), adapt the chosen benchmark's primary accent to align with the logo's core hue.
- **Decision Log**: Record the winning benchmark, why it was chosen over the others, and the exact token derivation in `docs/design/inspiration/notes.md`.

#### 5. Artifact Output: `docs/design/inspiration/notes.md`
Generate `docs/design/inspiration/notes.md` synthesizing:
- **Selected Primary Benchmark ("Paling OK")** and decision rationale.
- Reference images audited with extracted traits.
- Brand logo palette alignment table.
- Selected neutral undertone justification.
- Component density and corner radius decisions.

---

### Step 1: Formulating `DESIGN.md` Guardrails (ANTI-SLOP MANDATORY)
Use template at `templates/02-design/DESIGN_MD_TEMPLATE.md` with **STRICT ANTI-SLOP RULES**.

⛔ **PREREQUISITE RULE**: `DESIGN.md` tokens **MUST** directly inherit from the winning benchmark and logo alignment documented in `docs/design/inspiration/notes.md`. Never invent tokens without referencing `notes.md`.

#### 1.1 Color Palette & Strict WCAG 2.2 Level AA Compliance
**Primary/Accent (Pick ONE):**
- From logo color palette and visual references, OR
- Placeholder: `#0891B2` (Cyan-600) for fintech/SaaS, `#3B82F6` (Blue-500) for enterprise B2B
- **FORBIDDEN:** Purple gradients (`#A855F7` → `#EC4899`), neon colors, rainbow palettes

**Border Contrast Architecture (WCAG 1.4.11 Non-Text Contrast):**
- **Container Divider (`--border-subtle`)**: 1px passive container divider (e.g., `#E4E4E7` on `#FFFFFF` = 1.3:1). Permitted ONLY for non-interactive content grouping.
- **Interactive Input & Button Borders (`--border-input` / `--border`)**: **MUST achieve $\ge 3.0:1$** contrast against adjacent background surfaces (e.g., `#94A3B8` / `#71717A` achieving 3.1:1+ on white). Bypassing this with 1.3:1 borders is a critical accessibility failure.

**Text & Placeholder Contrast (WCAG 1.4.3 Contrast Minimum):**
- **Text Primary**: High contrast $\ge 7:1$ (e.g., `#18181B` / `#3F3F46` on white).
- **Text Secondary**: High contrast $\ge 4.5:1$ (e.g., `#71717A` on white = 4.58:1).
- **Placeholder Text (`--text-placeholder`)**: **MUST achieve $\ge 4.5:1$** contrast against input background. Never use `#A1A1AA` (2.8:1 FAILS); use `#71717A` or darker.

**Separate Semantic Roles (No False Destructive States):**
- **Operating Expenses**: Business transactions (OPEX, rent, utilities) are normal business operations. Style with **neutral warm badge & arithmetic sign** (`-Rp`, e.g., `#71717A` text with subtle border), **NEVER as `--destructive`**.
- **Destructive (`--destructive`, `--destructive-foreground`)**: Strictly reserved for irreversible destructive actions: voiding transactions, product returns, overdue payables, and critical system errors.

**Dark Mode Mirrored Semantics:**
- Semantic status tokens MUST be fully mirrored with elevated dark surfaces and high-contrast text:
  - Destructive Light: `#EF4444` on `#FEF2F2` (text contrast 4.8:1)
  - Destructive Dark: `#FCA5A5` on `#450A0A` / elevated card `#27272A` (text contrast $\ge 5.2:1$, never dark red text on dark surfaces)
  - Success Dark: `#86EFAC` on `#052E16` (contrast $\ge 5.0:1$)
  - Warning Dark: `#FDE047` on `#422006` (contrast $\ge 5.5:1$)

**Data Visualization Tokens (`--chart-1` through `--chart-5`):**
Must be defined in both light and dark mode with distinct hue angles and $\ge 3:1$ contrast against adjacent segments:
```css
:root {
  --chart-1: #0891B2; /* Cyan */
  --chart-2: #10B981; /* Emerald */
  --chart-3: #F59E0B; /* Amber */
  --chart-4: #6366F1; /* Indigo */
  --chart-5: #EC4899; /* Pink */
}
.dark {
  --chart-1: #22D3EE;
  --chart-2: #34D399;
  --chart-3: #FBBF24;
  --chart-4: #818CF8;
  --chart-5: #F472B6;
}
```

#### 1.2 Typography & iOS Anti-Zoom Rule
**Font Families:**
- UI/Body: **Inter** (weights: 400, 500, 600, 700 ONLY)
- Monospace/Code: **JetBrains Mono** (weights: 400, 700 ONLY)
- **FORBIDDEN:** Fancy display fonts (Recoleta, Clash Display, Syne), handwriting fonts, font weights outside 400-700

**Anti-Zoom Rule (iOS Safari):**
- All mobile form inputs (`<input>`, `<select>`, `<textarea>`) **MUST be at least `16px`** font size (`text-base md:text-sm` in Tailwind). Font sizes $<16$px trigger iOS Safari auto-zoom, breaking mobile viewport layout.

**Type Scale:**
- H1: 48px/700, line-height 1.1, letter-spacing -0.02em
- H2: 36px/600, line-height 1.2
- H3: 24px/600, line-height 1.3
- Body: 16px/400, line-height 1.6
- **FORBIDDEN:** Line-height < 1.4 for body text (readability), all-caps body text

#### 1.3 Borders, Radius & Touch Targets
**Touch Target Rule (WCAG 2.5.5 / Mobile Ergonomics):**
- All interactive touch targets (buttons, quantity steppers, table action icons, dropdown triggers) **MUST be $\ge 44\text{px} \times 44\text{px}$** (`h-11 min-w-11` or minimum 44px tap area).

**Borders:**
- Width: **1px solid** (default for all cards, inputs, buttons outline)
- Interactive input borders: $\ge 3.0:1$ contrast against background
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

**POS Dual-Panel & Responsive Table Architecture:**
*(Conditional: Applicable to POS/Retail. For HRIS/CRM/SaaS, replace with domain layouts like split detail views, Kanban columns, or master-detail drawers)*:
- Mobile Viewports (<640px): Standard data tables MUST reflow into stacked cards with key-value pairs (prevent unstyled horizontal overflow).

**Z-Index Layering Scale (Strict Stacking Context):**
```css
:root {
  --z-base: 0;                /* Default flow content */
  --z-sticky-header: 10;      /* Sticky page headers & navigation rails */
  --z-sticky-cart: 20;        /* POS bottom checkout bar & action dock */
  --z-dropdown: 30;           /* Select popovers, tooltips, action menus */
  --z-sync-banner: 40;        /* Fixed offline status / reconnect banner */
  --z-modal: 50;              /* Dialog overlays & bottom sheet drawers */
  --z-toast: 60;              /* Floating toast notifications */
}
```

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

#### 1.7.1 Specialized Retail & Hardware Support (Conditional Domain Extensions)
*(Note: The following sections apply specifically to projects with cashier, retail, or field POS requirements. Skip or substitute with relevant domain patterns for pure SaaS, HRIS, or developer platforms)*:

**1. Offline & Sync Visual Indicator States (F-13):**
Provide explicit CSS/component badge styling for local-first/POS connection states:
- **Online**: Subtle green indicator dot (`#10B981`) with pulse effect.
- **Offline**: Warm amber badge (`#F59E0B`) with pending transaction queue count (e.g., `⚡ Offline (3 pending)`).
- **Syncing**: Active blue spinner badge (`#3B82F6`, `animate-spin`).
- **Sync Error**: Red alert badge (`#EF4444`) with interactive "Retry Sync" button.

**2. Thermal Receipt Stylesheet (58mm & 80mm Hardware):**
Embedded `@media print` rules for direct POS receipt printing:
```css
@media print {
  @page {
    margin: 0;
    size: 58mm auto; /* Use 80mm auto for standard wide POS printers */
  }
  body {
    width: 58mm;
    margin: 0;
    padding: 2mm;
    font-family: 'JetBrains Mono', monospace, courier;
    font-size: 11px;
    line-height: 1.25;
    color: #000000 !important;
    background: #FFFFFF !important;
  }
  .no-print, nav, aside, header, footer {
    display: none !important;
  }
  .receipt-table {
    width: 100%;
    border-collapse: collapse;
  }
  .receipt-divider {
    border-top: 1px dashed #000000;
    margin: 4px 0;
  }
}
```

**3. Dark Mode Logo Outlining:**
When brand marks/monograms feature dark or black base geometries, outline the monogram with a subtle 1px border (`border border-zinc-700 dark:border-zinc-300/40`) to prevent visual disappearance on pure dark backgrounds (`#09090B`).

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

#### 1.9 AI Prototyping Prompt Directive (CRITICAL)

```
DESIGN CONSTRAINTS (ANTI-SLOP):
- NO gradients, glassmorphism, or colored shadows
- Flat colors only: Primary [#HEX], Neutrals Zinc-50 to Zinc-950
- Borders: 1px solid #E4E4E7, radius max 8px
- Typography: Inter font, weights 400/500/600/700 only, line-height 1.6
- Shadows: subtle 0 1px 3px rgba(0,0,0,0.1) only
- Layout: Grid-based, NO floating/overlapping elements
- Spacing: Tailwind default scale (4/8/16/24/32px)
- Animations: NONE (static screens for prototype)
```

**Example Full Prompt:**
```
Generate Landing Page (Screen ID: SCR-01) for FreePajak tax SaaS:
(Note: Sample domain example for demonstration - replace with your project domain)

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
- Typography: Inter font, weights 400/500/600/700, line-height 1.6
- Shadows: 0 1px 3px rgba(0,0,0,0.1) only
- Layout: Grid-based, max-w-7xl container
- Spacing: Tailwind scale (px-4, py-8, gap-6)
```

---

#### 1.10 Post-Generation Review (MANDATORY BEFORE DESIGN FREEZE)

After Prototype generates screens, **MANUALLY REVIEW** each screen for slop:

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

### Step 2: Ingesting Design Tokens into Prototyping Tooling
1. Read `docs/harness-root/DESIGN.md` for color hex codes and spacing scales.
2. Configure Tailwind CSS or CSS variables in your prototyping workspace.
3. Apply the anti-slop prompt directive for every screen generation.

### Step 3: Generating All Screens (Phased Coverage for Enterprise)

Use template: `templates/02-design/DESIGN_SPEC_TEMPLATE.md` to document the exhaustive screen specification in `docs/specs/DESIGN_SPEC.md`.

#### 3.0 Standardized Prototype & Prompt Directory Layout
To establish seamless synchronization between Module 04 (Design) and Module 06 (Development), create and maintain:

```text
docs/design/
├── prompts/                          # Ready-to-use Screen Generation Prompts
│   ├── scr-01/PROMPT.md              # Template: templates/02-design/SCREEN_PROMPT_TEMPLATE.md
│   ├── scr-02/PROMPT.md
│   └── ... (for each SCR-xx)
└── screens/                          # Real User / AI Exported Code Components
    ├── scr-01/                       # HTML, TSX, JSX, or CSS exported from v0/Stitch/Bolt
    ├── scr-02/
    └── ... (for each SCR-xx)
```
- **Prompt Generation**: For each screen in `SITEMAP.md`, generate `docs/design/prompts/scr-xx/PROMPT.md` using `templates/02-design/SCREEN_PROMPT_TEMPLATE.md`.
- **Export Ingestion**: When the user generates screens via v0.dev, Google Stitch, or Claude Artifacts, save exported files in `docs/design/screens/scr-xx/` to enable rapid Level 1 handoff in Module 06.

#### 3.1 Absolute Screen Coverage (100% Mapping)
- **Small/Medium Scale (<50 screens)**: 100% exhaustive coverage in a single phase. Truncation or sampling is STRICTLY FORBIDDEN.
- **Large/Enterprise Scale (≥50 screens)**: Phased approach to prevent context exhaustion:
  - **Phase 1 (MVP Screens)**: Core user flows (login, dashboard, primary CRUD, checkout) — max 30–40 screens.
  - **Phase 2 (Admin/Secondary)**: Admin panels, reports, settings — remaining screens. Document phasing plan in `DESIGN_SPEC.md`.
- Every route in `SITEMAP.md` MUST map to a unique `SCR-xx` ID, functional feature reference `F-xx`, and access role.

#### 3.2 Adaptive Layouts & Role Viewport Boundaries
- **Desktop**: Sidebar 240px (`w-[240px]`, `h-screen`, `border-l-4` active state) + Topbar 64px (`h-16`, `z-10`).
- **Mobile**: Bottom Navigation Bar 64px (`h-16`, `z-20`, max 5 slots) with auto-hide behavior on virtual keyboard focus.
- **Role-Based Routing**: Operators/Cashiers land directly on their execution interface (e.g., `/pos`), with sensitive fields (e.g., `buy_price` / HPP) completely omitted from query layers and DOM.

#### 3.3 Standardized 5-State Matrix per Interface Pattern
Every screen pattern MUST concretely define all 5 states (never write superficial labels):
1. **Data Table Pattern**: Idle/Default, Skeleton Rows (`animate-pulse`), Empty State with CTA, Server Error Banner (`500/Net`) with retry button, Mutation Success Toast.
2. **Form & Profile Pattern**: Pristine (Anti-Disabled submit button enabled), Validating on blur, Submitting (disabled inputs + spinner), Inline Field Errors (≥13px red text with `aria-describedby`), Success Redirect/Toast.
3. **Document Detail Pattern**: Header Skeleton, Not Found (`404` card), Action Dialogs (`z-50`).
4. **Validation Token Pattern**: Validating Spinner, Token Expired Card, Success Banner.

#### 3.4 Wireflow Logic Defense & Hardware Traps
1. **General Interaction & Form Defense (Universal)**:
   - Double-submit prevention: Buttons debounce immediately upon click and display loading indicators.
   - Idempotency: Mutations transmit unique client-generated request tokens.
   - CSV injection neutralization: Spreadsheets prefix formula trigger characters (`=, +, -, @`) with `'`.
2. **Conditional Domain Extensions (Retail / POS / Hardware Scope)**:
   - **Barcode Scanner Shortcut Mitigation**:
   - *Failure Mode*: Physical barcode scanners append an automatic `Enter` keystroke (`\n`). Binding `Enter` to "Submit Payment" causes premature transaction submission on incomplete carts.
   - *Defense Protocol*: Cashier screens MUST NOT bind `Enter` to payment execution. Bind `Enter` to "Add Scanned Item to Cart". Reserve dedicated function keys: `F2` for search/scan, `F4` for payment modal, `F8` for new receipt.
   - **Blind Count Opname Defense**:
   - *Failure Mode*: Displaying expected system stock or discrepancy columns to counting staff invites confirmation bias and theft concealment.
   - *Defense Protocol*: Staff physical count screens (`/stock/adjustments/new`) must physically exclude system stock and discrepancy columns from the client DOM. Variance calculations are strictly backend-side post-submission.
   - **Dual Printer Protocol**:
   - *Failure Mode*: Desktop web relies on `window.print()`, but mobile/tablet Android POS setups use Bluetooth/RawBT.
   - *Defense Protocol*: Receipt dialog provides desktop `@media print` 58mm/80mm fallback AND raw ESC/POS text / Android RawBT intent format.

#### 3.5 Automated Quality Validation Checklist
Before submitting `DESIGN_SPEC.md`, verify:
- [ ] 100% of sitemap screens have unique Screen IDs (`SCR-xx`) mapped to `F-xx` features.
- [ ] Common text entry keys (e.g. `Enter`) are not bound to destructive or premature checkout actions.
- [ ] Sensitive fields (cost prices, expected opname quantities, private tokens) are protected from DOM leakage.
- [ ] Destructive error text contrast against light background surfaces is $\ge 4.5:1$ (measured $\ge 6.8:1$).
- [ ] Focus Not Obscured specifies `scroll-padding-bottom` (min 96px) for mobile sticky action bars.

### Step 4: Assembling the Complete Clickable Demo
1. Retrieve HTML/CSS component code from Prototype for all screens.
2. Add standard routing hyperlink tags to link button flows:
   - "Login" button → navigates to `/dashboard`
   - "Create New Document" button → navigates to `/documents/new`
   - "Save Draft" button → displays success modal/toast and navigates to `/documents/:id`
3. Deploy code to a free staging URL (Vercel / Cloudflare Pages) so it can be opened directly by the client on mobile or laptop to test the complete 100% flow.

### Step 5: Walk-Through & Design Freeze
1. Schedule a structured walk-through session with **Client Single PIC** (or conduct self-audit for solo product).
2. Execute end-to-end interactive testing across all screens, testing edge cases (empty states, field validations, keyboard navigation).
3. Verify the 5-point Quality Validation Checklist in Section 3.5.
4. **Execute Design Freeze Sign-Off**:
   - Client PIC / Solo Dev signs the Design Freeze Sign-Off sheet in Section 6 of `DESIGN_SPEC.md`.
   - **Binding Terms**:
     1. Visual layouts, screen inventories, and interaction wireflows are officially **FROZEN**.
     2. Implementation in Module 05 (Architecture) and Module 06 (Development) strictly reflects this specification.
     3. Any subsequent layout additions or UX restructuring will be processed under billable *Change Request (CR)* agreements.

---

## 4. Adaptation Based on Project Scale

| Parameter | Small Scale (MVP / Freelance) | Medium Scale (B2B SaaS / Agency) | Large Scale & Enterprise |
| :--- | :--- | :--- | :--- |
| **Screen Coverage** | **100% of all pages** in Scope (no reductions) | **100% of all pages** in Scope (no reductions) | **Phased if ≥50 screens**: Phase 1 (MVP core), Phase 2 (admin/secondary) |
| **Demo Media** | Prototype Viewer Link / Live Preview | Live Staging Web (Vercel/Cloudflare) | Live Staging Web + Accessibility Audit Document |
| **Design Compliance** | Standard visual contrast ≥4.5:1 | WCAG AA verified on forms | Full WCAG AA audit (Keyboard nav, Screen reader) |
| **Approval** | Written confirmation via email/chat | Signed Design Freeze sheet | Formal Design Sign-Off & UI Review Minutes |

---

## 5. User Testing & Iterative Validation

After the interactive UI prototype is complete, user testing is **MANDATORY for Client Projects** (and recommended/self-testing for Solo MVPs) before the final design freeze. Skipping this phase merely shifts usability issues to post-launch (5x more expensive to fix).

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

**Pre-Development Checklist** (Perform on Interactive Prototype):
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


## 7. Workflow Split: Planning (Cloud AI) vs Development (Local PC with MCP)

**Use Case**: User conducts planning/PM/design specification in Cloud AI (chat interface), then executes UI generation & development on a local PC with MCP.

### 7.1 Phase A: Planning & Design Specification

**Deliverables created in Cloud AI**:

1. ✅ **`docs/specs/LOGO_DESIGN_BRIEF.md`** (≤2KB minimal brief)
   - Product name + philosophy (2-3 sentences)
   - Target user (1 sentence) + brand vibe (4-5 keywords)
   - User responsibility + empty prompt template with reference placeholder

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
   - Domain configuration or rule tables with version, source, effective date
   - `ptkp-values.json` (tax-free allowance categories)
   - `pph23-rates.json`, `pp20-2026.json`, etc.
   - Metadata: version, source URL, last_updated, changelog

5. ✅ **UI Screen Prompt Files** (optional — pre-write prompts for each screen)
   - `ui-prompts/01-landing-page.txt` (10-20 lines: layout + strict style + components)
   - `ui-prompts/02-dashboard.txt`
   - `ui-prompts/03-calculation-form.txt`
   - Format: Layout sections, Style (STRICT anti-slop), Components list, References

**How to Export Deliverables to PC**:

```bash
# User action:
# 1. Request: "Export all Module 04 deliverables to a single archive"
# 2. Creates tar.gz in project directory
# 3. User downloads via file browser or scp/rsync

# Example terminal command:
cd ./my-project
tar -czf ../design-export-$(date +%Y%m%d).tar.gz DESIGN.md docs/specs/LOGO_DESIGN_BRIEF.md docs/specs/DESIGN_SPEC.md

# Output: ../design-export-20260929.tar.gz
# User downloads this file to PC
```

**Folder structure in archive**:
```
project-design-export/
├── DESIGN.md                              # Root design system tokens
├── docs/
│   └── specs/
│       ├── LOGO_DESIGN_BRIEF.md           # Minimal logo brief
│       └── DESIGN_SPEC.md                 # Screen breakdown + sitemap
├── data/
│   └── regulations/
│       ├── pph21-rates.json               # Tax data assets
│       └── ptkp-values.json
└── ui-prompts/                        # Optional pre-written prompts
    ├── 01-landing-page.txt
    ├── 02-dashboard.txt
    ├── 03-calculation-form.txt
    └── ...
```

---

### 7.2 Phase B: UI Generation & Development (PC with MCP Prototype)

**User works on local PC with tools**:
- **MCP Server**: `mcp-server-figma` (built-in in Claude Desktop/Codex/Cursor/Windsurf)
- **Code editor**: VS Code / Cursor / Windsurf
- **AI coding agent**: Claude Desktop, Codex CLI, Cursor, Windsurf (with MCP Prototype enabled)
- **Framework**: Next.js 15, Tailwind CSS, shadcn/ui

**Workflow on PC**:

#### Step 1: Extract Deliverables
```bash
# On PC
cd ~/projects/freepajak
tar -xzf ~/Downloads/design-export-20260929.tar.gz
ls -lh  # Verify DESIGN.md, docs/, data/, ui-prompts/ extracted
```

#### Step 2: Setup MCP Prototype (if not yet configured)

**Option A: Claude Desktop** (`~/Library/Application Support/Claude/claude_desktop_config.json` on Mac):
```json
{
  "mcpServers": {
    "figma": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-figma"],
      "env": {
        "FIGMA_ACCESS_TOKEN": "your-figma-access-token-here"
      }
    }
  }
}
```

**Option B: Environment Variable** (if MCP built-in):
```bash
# Add to ~/.bashrc or ~/.zshrc
export FIGMA_ACCESS_TOKEN="your-figma-access-token-here"
```

**Get Prototype API Key**:
- Visit https://figma.com
- Sign in with Google account
- Go to Settings → API Keys → Generate New Key
- Copy key (starts with `figd_...`)

#### Step 3: Generate UI Screens via MCP Prototype (Autonomous AI Agent)

**User prompt to Claude Desktop / Codex / Cursor / Windsurf**:
```
Read DESIGN.md and docs/specs/DESIGN_SPEC.md from this project, then generate all 10 screens using AI UI prototyping tools (v0 / Stitch / Next.js).

Project context:
- App: FreePajak (tax calculator for Indonesian freelancers)
- Framework: Next.js + Tailwind CSS + TypeScript
- Design style: Minimalist, flat colors, NO gradients, NO glassmorphism

For each screen in DESIGN_SPEC.md (SCR-001 to SCR-010):
1. Read the corresponding prompt file from ui-prompts/[screen].txt
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
5. Update DESIGN_SPEC.md with Prototype URL per screen

After all screens generated:
- Connect screen links in Next.js router
- Generate accessibility report (WCAG AA compliance)
- Save summary to design-freeze-report.md

Proceed autonomously and report progress every 3 screens.
```

#### Step 4: AI Agent Execution Flow (Autonomous via MCP)

**What the AI agent does** (no user intervention needed):

1. **Read specifications**:
   - `read_file('DESIGN.md')` → Extract color palette (`#0891B2`, `#FFFFFF`, `#18181B`), typography (`Inter`, `600 semibold`)
   - `read_file('docs/specs/DESIGN_SPEC.md')` → Extract screen list (10 screens: SCR-001 to SCR-010, routes `/`, `/dashboard`, `/calculations`, etc.)
   - `read_file('ui-prompts/01-landing-page.txt')` → Get prompt text for first screen

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
   // Agent checks generated component code against anti-slop rules
   
   // Check for violations
   const hasGradient = code.includes('bg-gradient') || code.includes('linear-gradient');
   const hasShadowLarge = /shadow-\[(.*?)\]/.test(code) && /* blur > 4px */;
   
   if (hasGradient || hasShadowLarge) {
     // Regenerate with stricter prompt
     // Regenerate component with solid background only
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
   **Prototype URL**: https://staging-preview.app/screens
   **Generated**: 2026-09-29
   **Anti-Slop Compliance**: ✅ Pass (0 gradients, 0 violations)
   ```

6. **Repeat for screens 2-10** (Dashboard, Calculation Form, Result Comparison, History, Settings, etc.)

7. **Generate interactive prototype**:
   ```javascript
   // Link screens together via Next.js router or static prototype
   
   // Get preview URL
   ```

8. **Generate Design Freeze Report**:
   ```markdown
   # Design Freeze Report — FreePajak

   **Date**: 2026-10-06
   **Project**: FreePajak Tax Calculator
   **Screens Generated**: 10/10 (100%)
   
   ## Screen Inventory
   
   | Screen ID | Route | Status | Prototype URL | Compliance |
   |-----------|-------|--------|------------|------------|
   | SCR-001 | / | ✅ Approved | [Link](https://staging-preview.app/screen) | ✅ Pass |
   | SCR-002 | /dashboard | ✅ Approved | [Link](https://staging-preview.app/screen) | ✅ Pass |
   | SCR-003 | /calculations | ✅ Approved | [Link](https://staging-preview.app/screen) | ✅ Pass |
   | ... | ... | ... | ... | ... |
   
   ## Anti-Slop Compliance Summary
   
   - ✅ 0 gradients detected (target: 0)
   - ✅ 0 glassmorphism effects (target: 0)
   - ✅ All shadows ≤4px blur (target: ≤4px)
   - ✅ Contrast ratio ≥4.5:1 on all text (WCAG AA pass)
   - ✅ Border radius ≤8px (cards), ≤6px (buttons)
   
   ## Interactive Prototype
   
   **Preview URL**: https://staging-preview.app/preview
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
[regenerates component with updated anti-slop prompt]
[verifies new output, exports code]
[reports: "SCR-002 regenerated, gradient removed, compliance verified"]
```

---

### 7.3 Deliverables Handoff Back to Planning Environment (Optional Documentation)

**If user wants to document final state in planning repository for archival**:

```bash
# On PC, create summary to sync back to Planning repository
cd ~/projects/freepajak
cat > design-freeze-summary.txt <<'EOF'
FreePajak Design Freeze Summary

Date: 2026-09-29
Screens: 10/10 generated
Anti-Slop Compliance: 100% (0 violations)
Prototype URL: https://staging-preview.app/preview
Lighthouse Scores: Performance 92, Accessibility 95, Best Practices 90, SEO 94

Design Freeze Approved: Yes
Approver: [User Name]
Date: 2026-09-29

Ready to proceed to Module 05 (System Design & Infrastructure).
EOF

# User archives this summary in project documentation
```

**Planning agent actions**:
- Update project tracking (mark Module 04 complete)
- Archive design freeze report to `docs/specs/design-freeze-report.md`
- Suggest next steps: "Module 04 complete. Proceed to Module 05 (System Design & Infrastructure) to define database schema, API endpoints, and detailed tech stack?"

---

### 7.4 Summary: Workflow Split Best Practices

| Phase | Location | Tools | Primary Output | Duration |
|-------|----------|-------|----------------|----------|
| **Planning & Spec** | Cloud AI (chat interface) | web_search, write_file, patch, skill_view | DESIGN.md, DESIGN_SPEC.md, JSON data, Prototype prompts | 4-6 hours |
| **UI Generation** | PC + MCP Prototype | Claude Desktop/Codex/Cursor/Windsurf + MCP | 10 screens (Next.js code), interactive prototype | 3-5 hours |
| **Review & Iterate** | PC | Browser, Lighthouse, WAVE | Anti-slop verification, accessibility audit | 2-3 hours |
| **Development** | PC | VS Code, Next.js, Supabase, Vercel | Full-stack app implementation | 40-80 hours |
| **Documentation** | Cloud AI (optional) | read_file, patch, memory | Design freeze archive, project status update | 30 minutes |

**Key Benefits**:
- ✅ **Cloud AI**: Thinking & Planning (specifications, research, data modeling, prompt engineering)
- ✅ **PC**: Execution (UI generation via MCP, coding, testing, deployment)
- ✅ **No duplication**: Specs created once in planning, consumed autonomously by MCP agent on PC
- ✅ **Async workflow**: User can continue planning while PC agent generates screens in background
- ✅ **Verifiable output**: Design freeze report with concrete metrics (0 gradients, 95 Lighthouse score, etc.)

**Common Pitfalls to Avoid**:
- ❌ Skipping DESIGN.md → MCP agent generates inconsistent styling across screens
- ❌ Vague Prototype prompts → AI outputs generic templates with gradients/glassmorphism
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
> - Solo dev MVP <4 weeks with 1-3 screens (Sections 1-7 specifications are sufficient)
> - Throwaway proof-of-concept prototyping
> - Backend API-only or CLI tool without GUI

Comprehensive guide for enterprise engineering teams seeking to build, adopt, or audit a Design System. Unlike **Sections 1-7** which focus on prototyping individual screens, **Section 8** is an Enterprise-only extension [M04B] for building a formal token repository across multiple teams.

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
Engineering time saved: ~20–30 hours per engineer per sprint
Team scale: 5–10 engineers across multiple product pods
Direct impact: Reusable token primitives eliminate manual CSS redlines and UI rework
Adoption target: ≥80% screen coverage across all production routes within 6 months
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
- [ ] Design audit completed with inconsistency quantified
- [ ] Design tokens JSON created (primitive + semantic layers)
- [ ] Minimum 12 P0/P1 components implemented in Storybook
- [ ] WCAG 2.1 AA compliance for all components
- [ ] CI/CD setup: Visual regression + NPM publish
- [ ] Adoption plan documented (80% coverage target)

**END RESPONSE** and confirm:
> *"Design System foundation is complete: [X] tokens defined, [Y] components implemented. Please review Storybook at [URL]. Ready to proceed to M05 (Architecture & Specs)?"*

---
