# Design Specification & UI Wireflow

> UI design specification, information architecture, visual tokens, and screen inventory document to freeze the visual flow prior to technical architecture and coding phases.

---

## 1. Design Metadata
- **Project Name**: [System / Application Name]
- **Client**: [Client Company / Organization]
- **Solo Lead UI/UX & Engineer**: [Your Name]
- **Design Version**: 1.0.0
- **Design Status**: [Draft / In Review / Frozen (Approved)]
- **Google Stitch Project ID**: `projects/[PROJECT_ID]`
- **Design System Asset ID**: `assets/[ASSET_ID]` (from `DESIGN.md`)
- **Live Interactive Prototype Link**: `[https://staging-preview-url or Stitch Viewer URL]`
- **Approval Date**: [YYYY-MM-DD]

---

## 2. Information Architecture & Sitemap URL Map

| Route URL | Page Name | User Role Access | Core Function & Interactions |
| :--- | :--- | :--- | :--- |
| `/login` | Login Page | Public / All Users | Email input form, password/OTP, reset link |
| `/dashboard` | Main Dashboard | Super Admin, Manager, Staff | Statistical summary, recent documents list, new action CTA |
| `/documents` | Document Management | All Authenticated Users | Documents table, status filters, search feature, export |
| `/documents/new` | Document Creator | Operations Staff, Manager | Dynamic template variable input form, PDF preview |
| `/documents/:id` | Document Details | All Associated Users | Audit trail status display, digital signature button |
| `/sign/:token` | Signing Page | External Guest / Signer | Digital signature canvas without requiring account login |

---

## 3. Design System & Visual Tokens (Design Tokens)

### 3.1 Typography
- **Primary Font (UI & Body Text)**: `Inter` or `Geist Sans` (Fallback: `system-ui, sans-serif`)
- **Monospace Font (Code, Hash, Financial Numbers)**: `JetBrains Mono` or `Geist Mono`
- **Text Size Scale**:
  - Heading 1: `32px` / `line-height: 40px` / `font-weight: 700`
  - Heading 2: `24px` / `line-height: 32px` / `font-weight: 600`
  - Body Text: `14px` / `line-height: 20px` / `font-weight: 400`
  - Caption / Helper: `12px` / `line-height: 16px` / `font-weight: 400`

### 3.2 Color Palette & Contrast Verification (WCAG 2.1 AA)

| Color Token | HEX Value | UI Usage | Contrast Ratio to Background | Pass Status |
| :--- | :---: | :--- | :---: | :---: |
| `background` | `#FFFFFF` | Main page background | - | Base |
| `surface` | `#F4F4F5` | Component cards, form containers | - | Base |
| `text-primary` | `#09090B` | Heading and primary body text | **19.8 : 1** | PASS (AAA) |
| `text-muted` | `#71717A` | Placeholder, secondary labels | **4.6 : 1** | PASS (AA) |
| `primary` | `#[Brand]` | Primary buttons, active links | **$\ge 4.5 : 1$** | PASS (AA) |
| `success` | `#16A34A` | Success status badge, confirmations | **$\ge 4.5 : 1$** | PASS (AA) |
| `destructive` | `#DC2626` | Delete button, error alerts | **$\ge 4.5 : 1$** | PASS (AA) |

---

## 4. Base Component Library Selection
- **UI Library**: `Shadcn UI` (based on Radix UI primitives & Tailwind CSS).
- **Icon Set**: `Lucide Icons` (consistent, 1.5px or 2px stroke).
- **Form Components**: `React Hook Form` + `Zod` validation.
- **Notification Components**: `Sonner` (lightweight toast notifications in bottom-right corner).

---

## 5. Exhaustive Screen Inventory (100% Coverage)

> **ABSOLUTE COVERAGE RULE**: This table MUST cover **100% of all pages/screens** defined in the scope boundaries (`SCOPE_STATEMENT.md` / `PRD.md`) from start to finish without exception. If the scope contains 10, 20, or 100 pages, every single one MUST be listed and generated in Google Stitch with its respective unique Screen ID. Cutting corners or selecting only a sample subset of screens is STRICTLY FORBIDDEN.

| Screen Code | Screen Name | Google Stitch Screen ID | Default State | Loading Skeleton | Empty State | Error State |
| :---: | :--- | :--- | :--- | :--- | :--- | :--- |
| **SCR-01** | Dashboard | `screens/[ID_01]` | Statistical widgets & table | Gray skeleton bars | "No documents yet" banner + create CTA | Server timeout banner |
| **SCR-02** | Document Form | `screens/[ID_02]` | Structured dynamic form inputs | Disabled submit button + loader | - | Red inline error text |
| **SCR-03** | Detail & Sign | `screens/[ID_03]` | PDF preview + signature box | Document render skeleton | - | Hash verification failure alert |
| **SCR-..** | [All Other Screens] | `screens/[ID_..]` | [Must fill 100% without skipping any] | ... | ... | ... |

---

## 6. Screen Breakdown Details (Screen Wireframe & Section Inventory)

> **BREAKDOWN DETAIL RULE**: Every screen listed in Section 5 MUST have a complete breakdown covering: (1) Layout structure (header/sidebar/main/footer), (2) Section-by-section inventory (hero, form, table, CTA, etc.), (3) Components used (button, input, card, modal, dropdown), (4) Text-based wireframe or ASCII art for early visualization, (5) Interaction & state flow (default, loading, empty, error).

### Per-Screen Format:

```
### SCR-XX: [Screen Name] ([Route URL])

**Layout Structure:**
- Header: [logo, nav menu, user avatar, logout]
- Sidebar: [navigation links, active state indicator]
- Main Content: [primary content area breakdown]
- Footer: [copyright, links, social icons]

**Section Breakdown:**
1. Section 1: [Section Name] (e.g., Hero, Form Input, Data Table)
   - Heading: "[Text heading]"
   - Subheading: "[Text subheading]"
   - Components:
     - [Component 1]: [Button "CTA Text" → action]
     - [Component 2]: [Input field "Label" (type, validation)]
     - [Component 3]: [Card grid 3 columns (icon, title, description)]
   - Wireframe:
     ```
     ┌─────────────────────────────────────┐
     │ [ASCII art layout representation]   │
     │ [Shows visual hierarchy & spacing]  │
     └─────────────────────────────────────┘
     ```

2. Section 2: [Next Section Name]
   - [Similar details as Section 1]

**Interaction & State Flow:**
- Default State: [Description of normal display]
- Loading State: [Skeleton/spinner, button disabled]
- Empty State: [Placeholder message + CTA]
- Error State: [Inline error message or toast]

**Responsive Behavior:**
- Mobile (375px): [Stack vertical, hide sidebar, hamburger menu]
- Tablet (768px): [2-column grid, collapsible sidebar]
- Desktop (1280px): [3-column grid, fixed sidebar]
```

### Breakdown Detail Example:

### SCR-01: Landing Page (/)

**Layout Structure:**
- Header: Logo (left), Nav menu (Home, Features, Pricing, Blog), CTA Button "Sign Up Free" (right)
- Main Content: 8 sections (Hero, Problem, Solution, How It Works, Social Proof, Pricing, FAQ, Final CTA)
- Footer: Logo + tagline, Links (About, Contact, Privacy, Terms), Social icons, Copyright

**Section Breakdown:**

1. **Section 1: Hero**
   - Heading: "Calculate 3 Freelancer Tax Schemes. Pick the Most Cost-Effective."
   - Subheading: "Save Millions of Rupiah per Year"
   - Components:
     - Button (primary): "Calculate Tax Free" → /signup
     - Hero Image: Dashboard preview or calculator illustration
   - Wireframe:
     ```
     ┌──────────────────────────────────────────────────┐
     │  [Logo]    Home  Features  Pricing  [Sign Up]   │
     ├──────────────────────────────────────────────────┤
     │                                                  │
     │      Calculate 3 Freelancer Tax Schemes          │
     │      Pick the Most Cost-Effective                │
     │                                                  │
     │      Save Millions of Rupiah per Year            │
     │                                                  │
     │      [Calculate Tax Free →]                      │
     │                                                  │
     │              [Hero Image/Illustration]           │
     │                                                  │
     └──────────────────────────────────────────────────┘
     ```

2. **Section 2: Problem Statement**
   - Heading: "Freelancers Overpay Taxes Because..."
   - Components:
     - Card Grid (3 columns):
       - Card 1: Icon "❓", Heading "Confused Choosing Scheme", Text "Trial-error across 3 calculators, wasted 30-60 mins"
       - Card 2: Icon "📊", Heading "Cumbersome Manual Tracking", Text "5-10 clients mixed domestic/international/crypto, messy data"
       - Card 3: Icon "⏰", Heading "Missed Deadlines", Text "Fined Rp100k + 2% interest/month"
   - Wireframe:
     ```
     ┌──────────────────────────────────────────────────┐
     │  Freelancers Overpay Taxes Because...            │
     │                                                  │
     │  ┌──────┐  ┌──────┐  ┌──────┐                  │
     │  │  ❓  │  │  📊  │  │  ⏰  │                  │
     │  │Confus│  │Manual│  │Missed│                  │
     │  │Scheme│  │Track │  │Deadln│                  │
     │  └──────┘  └──────┘  └──────┘                  │
     └──────────────────────────────────────────────────┘
     ```

3. **Section 3: Solution / Value Prop**
   - Heading: "FreePajak = Tax Planning Assistant"
   - Subheading: "Not a one-shot calculator, but a complete tax planning assistant"
   - Components:
     - Feature Grid (2×3 grid):
       - Feature 1: Icon, "Compare 3 Schemes" (Final 0.5%, NPPN, General Rate)
       - Feature 2: Icon, "Multi-Client Tracking" (Domestic/Foreign/crypto)
       - Feature 3: Icon, "Export Tax Return Excel" (Schedule I Form 1770)
       - Feature 4: Icon, "Tax Treaty 71 Countries" (Withholding tax rate)
       - Feature 5: Icon, "Crypto Tracker" (BTC/ETH/USDT, exchange rates)
       - Feature 6: Icon, "Deadline Reminders" (Monthly installments, Annual return)

4. **Section 4: How It Works**
   - Heading: "3 Simple Steps"
   - Components:
     - Step Grid (3 columns):
       - Step 1: Number "1", Heading "Input Revenue", Text "Enter monthly revenue, tax relief status, domestic/foreign clients", Form illustration
       - Step 2: Number "2", Heading "Compare 3 Schemes", Text "View comparison of Final 0.5%, NPPN, General Rate", Table illustration
       - Step 3: Number "3", Heading "Export Tax Return", Text "Download Excel Schedule I Form 1770, upload to tax portal", Download button illustration

5. **Section 5: Social Proof**
   - Badge: "Compliant with Tax Harmonization Law (UU HPP), PP 20/2026, PMK 168/2023"
   - Testimonial Placeholder: "User testimonials will be added post-MVP launch"

6. **Section 6: Pricing Table**
   - Heading: "Choose the Right Plan"
   - Components:
     - Pricing Card Grid (2 columns):
       - Card 1 (Free):
         - Heading "Free"
         - Price "Rp0/month"
         - Features List: "1 calculator scheme", "Max 3 clients", "1× tax return export/year", "Email reminder"
         - Button "Start Free" → /signup
       - Card 2 (Premium):
         - Heading "Premium"
         - Price "Rp49k/month"
         - Badge "Most Popular"
         - Features List: "3 schemes + comparison", "Unlimited clients", "Tax treaty 71 countries", "Crypto tracker", "Unlimited export", "12-month simulation"
         - Button "Upgrade Premium" → /signup?plan=premium

7. **Section 7: FAQ**
   - Heading: "Frequently Asked Questions"
   - Components:
     - Accordion (5 items):
       - Q1: "Is my tax ID data secure?" → A: "Data is encrypted with AES-256, never shared with third parties"
       - Q2: "Can I file tax returns directly from here?" → A: "Not yet, FreePajak helps calculate & export Excel; filing is still done via the official tax portal"
       - Q3: "What is the difference between Final 0.5% and NPPN?" → A: "Final 0.5% is the simplest (revenue × 0.5%), NPPN deemed profit is 50%"
       - Q4: "What about international clients?" → A: "Tax treaty calculator automatically computes withholding tax rates for 71 countries"
       - Q5: "Can I get a refund on Premium?" → A: "Full refund within the first 7 days, no questions asked"

8. **Section 8: Final CTA**
   - Heading: "Start Saving on Taxes Today"
   - Subheading: "Free forever for 1 scheme + 3 clients. Upgrade anytime."
   - Button (primary): "Sign Up Free" → /signup

**Interaction & State Flow:**
- Default State: All sections display normally
- Loading State: N/A (static landing page)
- Empty State: N/A
- Error State: N/A

**Responsive Behavior:**
- Mobile (375px): Stack vertical, hero image size 80%, card grid 1 column, pricing table 1 column
- Tablet (768px): Card grid 2 columns, pricing table 2 columns
- Desktop (1280px): Card grid 3 columns (Problem section), 2×3 grid (Value Prop section)

---

### SCR-02: Dashboard (/dashboard)

**Layout Structure:**
- Header: Logo (left), Search bar (center), Notification bell + User avatar dropdown (right)
- Sidebar: Nav links (Dashboard, Calculator, Clients, Transactions, Settings), Active state indicator (bg-primary)
- Main Content: Summary cards + chart + recent transactions table
- Footer: N/A (dashboard does not need a footer)

**Section Breakdown:**

1. **Section 1: Summary Cards (4 cards horizontal)**
   - Card 1: "Total Revenue This Year" → Value "Rp240,000,000" (sum all transactions), Icon "💰", Trend "+12% vs last month"
   - Card 2: "Tax Payable" → Value "Rp11,500,000" (calculated based on selected scheme), Icon "📊", Tooltip "Based on NPPN 50% scheme"
   - Card 3: "Tax Credit" → Value "Rp4,500,000" (sum withheld from domestic clients), Icon "✅"
   - Card 4: "Under/Overpaid Tax" → Value "Rp7,000,000 Underpaid" (tax payable - tax credit), Icon "⚠️", Color "text-destructive"

2. **Section 2: Revenue Chart (Bar Chart Jan-Dec)**
   - Heading: "Monthly Revenue"
   - Chart: 12-month bar chart (Jan-Dec), Y-axis Rupiah, X-axis months
   - Interaction: Hover bar → tooltip "February: Rp22,000,000"

3. **Section 3: Next Deadline Card**
   - Heading: "Upcoming Tax Deadline"
   - Card:
     - Date: "October 15, 2026"
     - Type: "Monthly Tax Installment (PPh 25)"
     - Estimate: "Rp966,000"
     - Button: "Pay via e-Billing" → open official e-Billing link
     - Countdown: "14 days remaining"

4. **Section 4: Recent Transactions (Table, last 5 rows)**
   - Heading: "Recent Transactions"
   - Table Columns: Date | Client | Amount | Currency | Amount IDR | Action
   - Table Rows (last 5):
     - 2026-09-25 | PT ABC | Rp10.000.000 | IDR | Rp10.000.000 | [Edit] [Delete]
     - 2026-09-20 | Upwork Client | USD 500 | USD | Rp8.797.000 | [Edit] [Delete]
     - ...
   - Button: "View All Transactions" → /transactions

**Interaction & State Flow:**
- Default State: Cards populated with real data, chart rendered, table 5 rows
- Loading State: Skeleton cards (shimmer gray), skeleton chart, skeleton table rows
- Empty State (if no transactions yet): Empty illustration + text "No transactions yet. Start tracking your income now." + Button "Add Transaction" → /transactions?action=new
- Error State: Toast notification "Failed to load dashboard data. Please try again." + Retry button

**Responsive Behavior:**
- Mobile (375px): Cards stack vertical (4×1), chart full width, table scrolls horizontally
- Tablet (768px): Cards 2×2 grid, chart full width
- Desktop (1280px): Cards 4×1 horizontal, chart 2/3 width (left), deadline card 1/3 width (right)

---

**[TEMPLATE INSTRUCTION]**: Repeat the detailed breakdown format above for **ALL other screens** (SCR-03 Calculator, SCR-04 Clients, SCR-05 Transactions, SCR-06 Settings, SCR-07 Login, SCR-08 Signup, SCR-09 Onboarding, etc.) without exception. Every screen MUST include:
1. Layout Structure (header/sidebar/main/footer)
2. Section Breakdown (min 2-5 sections per screen, with heading/subheading/components/ASCII wireframe)
3. Interaction & State Flow (default/loading/empty/error)
4. Responsive Behavior (mobile/tablet/desktop breakpoint)

---

## 7. Accessibility & Responsive Standards
- [x] All interactive buttons have `focus-visible` ring for keyboard navigation (Tab key).
- [x] Form inputs have explicit text labels (`<label htmlFor="...">`) and `aria-describedby` for error messages.
- [x] Responsive interface supports screen viewports: Mobile (`375px`), Tablet (`768px`), and Desktop (`1280px`).
- [x] Mobile touch targets are at least `44 x 44 px` for easy tapping.

---

## 8. Design Freeze Sign-Off

By signing this sheet, the Client confirms that they have reviewed and approved all visual layouts, navigation architecture, and interactive prototype flows in this document.

**Design Freeze Clauses**:
1. All official visual designs are designated as **FROZEN**.
2. The next implementation phase will proceed directly to technical architecture specifications and coding.
3. Any changes to layout structures, additions of new pages, or revamps of interface flows after this approval date will incur additional cost and time via the *Change Request (CR)* procedure.

| Approved by Client Single PIC | Validated by Solo Engineer |
| :--- | :--- |
| **Name**: _________________________ | **Name**: _________________________ |
| **Title**: ______________________ | **Title**: Independent Lead Engineer |
| **Date**: ______________________ | **Date**: ______________________ |
| **Signature**: | **Signature**: |
