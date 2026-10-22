# CONVENTIONS.md

> Code style standards, component architecture, and technical conventions for AI coding agents to prevent low-quality code (*AI slop code*).

---

## 1. File Naming & Structural Rules (File Naming)

1. **File Naming Format**:
   - All filenames must use **`kebab-case`** format:
     - Correct: `document-form.tsx`, `auth-middleware.ts`, `use-vault-storage.ts`
     - Incorrect: `DocumentForm.tsx`, `authMiddleware.ts`, `use_vault.ts`
2. **Prohibited Barrel Files (`index.ts`)**:
   - Creating `index.ts` files that re-export all files in a folder (*re-export barrels*) is PROHIBITED.
   - Always import modules directly from their specific files to maintain optimal *tree-shaking* performance and prevent circular dependencies (*circular dependencies*).

---

## 2. React & Next.js App Router Standards

1. **Server Components as the Primary Default**:
   - All pages and components in `src/app/` are **React Server Components (RSC)** by default.
   - Placing the `'use client'` directive at the top level of a page is PROHIBITED.
2. **Isolating `'use client'` to Leaf Components**:
   - Use `'use client'` only on the smallest components that genuinely require browser interaction (`useState`, `useEffect` hooks, or `onClick` events), such as interactive buttons or signature canvases.
3. **Disciplined State Management**:
   - Use *Discriminated Unions* to manage mutation/data states:
     ```typescript
     type RequestState<T> =
       | { status: "idle" }
       | { status: "loading" }
       | { status: "error"; message: string }
       | { status: "success"; data: T };
     ```
4. **Hydration-Free First (Server-First Rendering)**:
   - If a view is correct without hydration, it MUST NOT be hydrated. `'use client'` is an exception recorded per leaf component in `VERIFY_LOCAL.md` §4C, never the default.
   - No non-deterministic value may be produced during the initial render: `Date.now()`, `new Date()`, `Math.random()`, `crypto.randomUUID()`.
   - `localStorage` / `sessionStorage` / `window` / `matchMedia` are read **after** mount (`useEffect`) or, preferably, never — server-readable cookies/session replace them.
   - Every date/number formatter passes an explicit `locale` **and** `timeZone` (`new Intl.DateTimeFormat('id-ID', { timeZone: 'Asia/Jakarta' })`); bare `toLocaleString()` is PROHIBITED because server and client ICU builds disagree.
   - Prefer server round-trips over client state for sorting, filtering, and pagination (URL search params).
   - `suppressHydrationWarning` is permitted only for a single known-unknowable node — never to silence an undiagnosed mismatch or an entire subtree.
   - Full decision ladder: `references/technical/HYDRATION_FREE_RENDERING.md`.

---

## 3. TypeScript Discipline & Type Handling

1. **Zero `any` Policy**:
   - Using the `any` type is PROHIBITED. Enforce `strict: true` and `noUncheckedIndexedAccess: true` in `tsconfig.json`.
   - Double assertions (`as unknown as TargetType`) and non-null assertions (`!`) without guards are STRICTLY PROHIBITED.
2. **Single Source of Truth Types from Zod**:
   - Writing TypeScript interfaces and Zod schemas separately when they represent the same data is prohibited. Always infer types from Zod schemas:
     ```typescript
     export const UserSchema = z.object({ id: z.string().uuid(), email: z.string().email() });
     export type User = z.infer<typeof UserSchema>;
     ```

---

## 4. Code Structure & Error Handling (Clean Code & Error Handling)

1. **Early Returns Pattern (Guard Clauses)**:
   - Handle error conditions and validation failures at the beginning of functions. Avoid deeply nested `if-else` branching (*arrow anti-pattern*).
2. **No Swallowing Errors (No Empty Catch)**:
   - Writing empty catch blocks: `catch (e) {}` is PROHIBITED. All errors must be logged using structured loggers or rethrown with meaningful messages.
3. **Centralized Constants**:
   - Magic numbers or transaction status strings must be defined as typed constants (*const assertions* or TypeScript enums).
4. **Uniform Action Result Contract**:
   - Server mutations must return a consistent `ActionResult<T>` structure:
     ```typescript
     export type ActionError = { code: string; message: string; fieldErrors?: Record<string, string[]> };
     export type ActionResult<T> = { success: true; data: T } | { success: false; error: ActionError };
     ```
5. **Global Error Boundaries & Process Lifecycle**:
   - **Frontend**: Implement root and route-level Error Boundaries (`error.tsx`) displaying user-friendly error fallbacks with recovery/retry buttons to prevent blank screen crashes.
   - **Backend**: Catch `unhandledRejection` with structured logging. Implement graceful shutdown intercepting `SIGTERM` and `SIGINT` to cleanly close server connections and flush DB connection pools within a 10s grace timeout.
6. **Zero Redundant / Obvious Comments (The Clean Code Rule)**:
   - Comments that merely narrate what the syntax clearly states (`// Fetch rooms`, `// Return data`, `// Submit button`, `// Header layout`) are classified as AI slop and strictly PROHIBITED.
   - Code must be self-explanatory through expressive naming. Comments are reserved exclusively for non-obvious business reasons, regulatory tax rules, or third-party workarounds.

---

## 5. Form Ergonomics & Data Sanitization

1. **Universal 16px Input Font Size (iOS Anti-Zoom Rule)**:
   - Form inputs (`<input>`, `<select>`, `<textarea>`) MUST be at least `16px` (`text-base`) across all viewports.
   - Never override with `md:text-sm`, which triggers auto-zoom on touch tablets and iPads (≥ 768px).
2. **Anti-Disabled Pristine Button Rule**:
   - Form submit buttons remain enabled in pristine/untouched state (validation triggers on click with auto-focus to first invalid field).
3. **Calibrated Notification Toast Behavior**:
   - Success notifications: Auto-dismiss permitted after ≥ 4000ms with pause on hover/focus.
   - Error and offline alert notifications: STRICTLY FORBIDDEN to auto-dismiss (manual dismissal required).
4. **Safe Spreadsheet Export Sanitization**:
   - When exporting tabular data to CSV or Excel, escape formula triggers without breaking pure negative numbers:
     ```typescript
     export function sanitizeExportCell(value: unknown): string | number {
       if (typeof value === 'number') return value;
       if (value === null || value === undefined) return '';
       const str = String(value);
       if (/^-?\d+(\.\d+)?$/.test(str)) return str; // Preserve pure numeric strings
       const triggers = ['=', '+', '-', '@', '\t', '\r'];
       return triggers.some(t => str.startsWith(t)) ? `'${str}` : str;
     }
     ```

---

## 6. Anti-Slop UI & The Craftsmanship Standard

*Adopts core filter rules from the Anti-Slop standard to ensure designs feel human-crafted, intentional, and grounded in domain reality:*

1. **The Purpose Test (No Technique Without Reason)**:
   - Every visual decision (radius, border, badge, animation, shadow) must have an articulated purpose. If the only rationale is "it's the AI default" or "it looks modern", eliminate it.
2. **Zero Default Tailwind Blue & AI Gradients**:
   - Using unstyled Tailwind blue (`#3B82F6` / `blue-500`) or purple-to-blue text gradients (`bg-gradient-to-r from-blue-600 to-purple-600`) as primary brand styles is PROHIBITED. All accent colors must be defined in `DESIGN.md`.
3. **No Cliché Decorative Pills (Eyebrow Badges)**:
   - Do not place decorative badge capsules (`[ ✨ AI Powered ]`, `[ Beta 2.0 ]`, `[ New ]`) directly above page headlines unless conveying a critical system state.
4. **Functional Completeness (No Dead Decoration)**:
   - Every interactive element (button, link, tab, filter) MUST be wired to a real handler or route. Zero `href="#"`, zero dummy buttons, zero "Coming Soon" alerts on primary flows.
5. **Evidence Over Fabricated Claims**:
   - Never generate fake testimonials, fictional user stats ("10k+ active teams", "99.9% uptime"), or placeholder "Trusted By" logos unless provided by the user.
6. **Mirror Component Signatures**:
   - Buttons, cards, and input fields must inherit exact height, padding, and corner radius extracted from the human's visual benchmark in `notes.md` (no unprompted pill buttons or excessive rounded corners).
7. **Zero Internal Spec Leaks in Customer Views**:
   - Screen IDs (`SCR-01`, `SCR-02`), internal document headers, and technical slots (`[WASM Canvas slot]`, `[slot]`) must NEVER appear in rendered customer-facing UI. Use authentic domain-specific nomenclature.
8. **Jangan Pernah Menggunakan Emoticon (Gunakan Icons Selalu)**:
   - Dilarang keras menggunakan emoticon atau karakter emoji OS (e.g. ⚙️, 📁, 🚀, ❌, 😊) sebagai icon tindakan, navigasi, header, feature card, badge, atau status pada antarmuka. Selalu gunakan komponen icon SVG terstandarisasi (misalnya Lucide React, Heroicons, Radix Icons).
9. **Layout Fidelity to Inspiration**:
   - Layout implementations must strictly align with the spatial structure, density, and layout archetypes deposited in `docs/design/inspiration/` and synthesized in `DESIGN.md`.
10. **Zero Tech Stack Leaks in UI Copy**:
    - End users care about solving their domain problem, not your software dependencies. Never include internal tech stack names (`Supabase Auth`, `Next.js 16`, `Prisma`, `PostgreSQL`, `Tailwind CSS`) in customer-facing UI badges, footers, tooltips, or form helper text. Speak strictly in authentic domain language.
11. **Prohibited Raw Native `<select>` for Filter Pills & Rich Dropdowns**:
    - Using native unstyled `<select>` tags for interactive filter pills, floor pickers, or action menus is STRICTLY PROHIBITED. Native options cannot be rounded by CSS and render as crude, sharp-cornered 90-degree OS rectangles with zero shadows.
    - All filter selectors and dropdown menus MUST be authored as custom floating Popover/DropdownMenu components (e.g. Radix UI, Headless UI, or custom floating `<div>`) featuring:
      - `rounded-2xl` matching the system border radius
      - Soft multi-layer elevation shadow (`shadow-xl shadow-slate-200/50`)
      - Clean floating offset (`mt-2`) and subtle border (`border border-slate-100`)
      - Smooth enter/exit transition (`duration-150 ease-out`) and soft hover items (`hover:bg-slate-50 rounded-xl px-3 py-2`).
12. **Mandatory Micro-Interactions & Motion Transitions**:
    - Every interactive element MUST implement tactile micro-interactions (per `references/design/UI_MOTION_GUIDELINES.md` and `templates/ui/motion-tokens.css`):
      - **Hover**: Subtle background tint and elevation change (`transition-all duration-150 ease-out`).
      - **Active**: Physical spring click feel (`active:scale-[0.98] transition-transform`).
      - **Focus**: High-contrast accessible ring (`focus-visible:ring-2 focus-visible:ring-brand-500 focus-visible:ring-offset-2 outline-none`).
      - **Modal Open/Close**: Backdrop blur fade (`fade-in-0 duration-200`) + dialog scale-in (`zoom-in-95 duration-200 slide-in-from-bottom-2`).
      - **Dropdown/Popover Open**: Scale/fade entrance (`scale-95 to scale-100`, `opacity-0 to opacity-100`, `duration-150 ease-out`).
      - **Progress Bars**: Fluid width transitions (`transition-all duration-500 ease-out`). Zero inert static jumps.
13. **Zero Stub Pages (100% Functional Depth)**:
    - Every route declared in `SITEMAP.md` must be implemented with real components, tables, filters, and interactive forms. Creating hollow stub pages that contain merely an `<h1>` title and description paragraph (e.g. `< 15` lines or `< 400` bytes) to pass navigation checks is STRICTLY FORBIDDEN as Stub Slop.
14. **Authentic Authentication vs Fake Link Navigation**:
    - Login, registration, and password recovery forms must execute genuine authentication actions (calling Supabase Auth / NextAuth / API handlers, managing session tokens/cookies, handling invalid credential states, and displaying loading spinners).
    - Wrapping a submit button in a client `<Link href="/dashboard">` without validating credentials is a CRITICAL SECURITY & LOGIC DEFECT that leads to infinite redirect loops in production.
    - Login screens MUST include "Ingat Saya" (Remember Me checkbox) and "Lupa Kata Sandi" (Forgot Password link).
15. **Interactive Control Integrity (Zero Dead Buttons)**:
    - Every button rendered in topbars, headers, cards, and toolbars MUST be wired to an authentic event handler (`onClick`, form submit, or state toggle).
    - Notification bells: MUST toggle an interactive popover/dropdown displaying recent alerts or a clean empty state; rendering an unresponsive icon button is PROHIBITED.
    - Quick action buttons (e.g. "Catat Meter"): MUST open the designated action modal directly instead of redirecting awkwardly.
    - Desktop navigation shell: MUST support responsive expand/collapse toggle for screen efficiency.
16. **Authentic Media & Document Previews (Zero `example.com` Links)**:
    - Receipts, proof of payment, and document attachments must render within an in-app lightbox/modal previewer.
    - Hardcoding or seeding broken mock URLs (`https://example.com/receipts/...` or `placeholder.com`) is PROHIBITED.
    - Creation modals for expenses/invoices must provide authentic file upload handling (or local base64/file object simulation), never bare text inputs for manual URL typing.
17. **Modern SaaS Landing Page Standard (The 6-Section Mandate)**:
    - A public landing page (`SCR-01`) must never be a hollow 100-line hero with 3 static text cards. It must deliver an engaging, modern presentation comprising:
      1. High-impact Hero with value proposition, subheadline, dynamic CTA, and trust signal badge.
      2. Authentic Product Mockup / Interactive Preview Frame showing the real UI in action.
      3. Feature Showcase Cards with workflow illustrations.
      4. Value Calculator or Before/After Comparison Grid.
      5. FAQ Accordion addressing common user questions.
      6. Responsive footer with navigation and legal links.
18. **Strict RBAC Action & UI Masking Protocol (Boleh vs DILARANG)**:
    - Every role (Owner, Manager, Staff, Member/Tenant) defined in `FSD.md` Section 4.0 must have strictly segregated capabilities:
      - **Backend Defense-in-Depth**: Every Server Action, Route Handler, or API mutation must verify the caller's role before execution. Unauthorized attempts must reject immediately with `403 Forbidden` (or throw an unauthorized error). Never rely solely on frontend element hiding.
      - **Sensitive UI Masking**: Lower roles (e.g. Staff/Operator) MUST NOT see executive financial figures (gross revenue, net profit, occupancy financial yield), settings, bank account configurations, or staff management. These components must be conditionally masked or hidden based on session role.
      - **Dedicated Operational Views**: Staff members must be routed to their dedicated operational workspace (e.g. `/staff` or `/ops/workspace`) focused on daily tasks, meter logs, and maintenance tickets, rather than viewing a crippled, disabled-state Owner dashboard.
19. **Visual Asset & Card Imagery Preservation**:
    - When inspiration benchmarks display photographic cards (e.g. room photo thumbnails, property covers, product cards, user profile pictures), the implemented frontend components MUST retain matching image elements (`<img>` or Next.js `<Image>`) with proper aspect ratios (`aspect-video`, `aspect-[4/3]`, `aspect-square`) and `object-cover`.
    - Flattening media-rich cards into text-only boxes or substituting photographic user avatars with raw monochrome initial text circles (`PK`, `BS`) is STRICTLY PROHIBITED as Card Slop. Use curated high-resolution photo URLs or local assets in `public/images/`.
20. **Zero Raw Browser Alerts (`alert()`, `confirm()`, `prompt()`)**:
    - Triggering browser OS modal popups via `window.alert()`, `alert()`, `window.confirm()`, `confirm()`, or `prompt()` is STRICTLY FORBIDDEN as Amateur AI Slop.
    - All user feedback and notifications MUST use high-fidelity, styled UI components tailored to the system design:
      - **Transient Feedback (Success / Error / Info)**: Use custom Toast notifications (e.g. Sonner, react-hot-toast, or custom design-token toast) styled with matching border radius (`rounded-xl`), soft shadows (`shadow-lg`), and contextual SVG icons.
      - **Confirmation & Destructive Actions**: Use custom Dialog / Confirmation Modals (e.g. Radix Dialog or custom backdrop modal) featuring soft backdrop blur (`backdrop-blur-sm`), smooth scale-in animation (`zoom-in-95`), clear warning messaging, and explicit Cancel / Confirm action buttons.
