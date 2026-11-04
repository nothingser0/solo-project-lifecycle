# Interactive Prototype Output

> **Purpose**: Store generated screen outputs for review and handoff to development using a **Modular & Reusable Architecture**.

## Folder Structure

```
docs/design/screens/
├── css/
│   └── styles.css             # Centralized design system: tokens, typography, .btn, .card, .badge, .navbar, form controls
├── js/
│   └── app.js                # Centralized scripts: navigation highlight, modals, toasts, 5-state preview switcher
├── index.html                 # SCR-01 Landing / Dashboard (links to css/styles.css & js/app.js)
├── rooms.html                 # SCR-02 Unit / Room Management (links to css/styles.css & js/app.js)
├── billing.html               # SCR-03 Invoicing / Finance (links to css/styles.css & js/app.js)
├── tenants.html               # SCR-04 Tenant Records (links to css/styles.css & js/app.js)
└── settings.html              # SCR-05 Configuration & Rules (links to css/styles.css & js/app.js)
```

*(Nested subfolder structure like `scr-01/screen.html` is also supported, provided all screens link to the shared `css/styles.css` and `js/app.js` via relative path).*

---

## Reusable Component Architecture Standards

To prevent visual inconsistencies (different button sizes, mismatched card paddings, rogue fonts, divergent navbar heights, and contrasting colors across screens):

1. **Strictly No Monolithic / Hardcoded Inline Slop**:
   - Dilarang keras menulis tag `<style>` inline atau meng-hardcode styling unik pada setiap halaman HTML.
   - Semua halaman prototype wajib mengimpor stylesheet yang sama:
     ```html
     <link rel="stylesheet" href="css/styles.css">
     ```
   - Semua interaksi umum (dropdown popover, modal dialog, toast feedback, tab navigasi) wajib mengimpor script yang sama:
     ```html
     <script src="js/app.js" defer></script>
     ```

2. **Standardized Reusable Classes in `css/styles.css`**:
   - **CSS Variables (`:root`)**: Synchronized 1-to-1 with `DESIGN.md` (colors, typography, radii, shadows, z-indexes).
   - **Buttons (`.btn`)**: `.btn-primary`, `.btn-secondary`, `.btn-ghost`, `.btn-destructive` (uniform height, padding, radius, focus rings).
   - **Cards (`.card`)**: `.card-header`, `.card-body`, `.card-footer` (uniform border radius, 1px border, subtle shadow).
   - **Badges (`.badge`)**: `.badge-success`, `.badge-warning`, `.badge-destructive`, `.badge-neutral`.
   - **Form Controls (`.form-input`, `.form-select`)**: Mandatory 16px font size on mobile (anti-zoom), uniform height & focus ring.
   - **Navigation (`.navbar`, `.sidebar`)**: Consistent layout, active nav-link highlighting, logo sizing.

3. **Shared Interactivity in `js/app.js`**:
   - Active route highlighting based on current file/page name.
   - Shared Toast notification dispatcher (`showToast(message, type)`).
   - Shared Modal / Drawer open & close handlers with accessible keyboard `Escape` trap.
   - 5-State Matrix preview simulator (Default, Loading Skeleton, Empty, Error, Success).

4. **100% SITEMAP Coverage Mandate (Zero Missing Screens)**:
   - Setiap rute dan ID layar (`SCR-01..SCR-NN`) yang dideklarasikan di `docs/specs/SITEMAP.md` **wajib** memiliki file HTML prototipe nyata yang fungsional di `docs/design/screens/`.
   - Dilarang hanya membuat 1 halaman dashboard lalu membiarkan layar-layar operasional lainnya kosong. Seluruh alur aplikasi harus bisa diklik dan dijelajahi.

5. **Interactive Multi-Role Simulation (RBAC Testing Standard)**:
   - Setiap layar wajib menyertakan `#role-switcher` di navbar agar peninjau (klien/developer) dapat berpindah peran secara langsung (Guest, Tenant, Staff, Manager, Owner).
   - Tautan sidebar dan menu yang terbatas untuk role tertentu wajib diberi atribut `data-roles="owner,manager"`.
   - Data angka sensitif (seperti omzet, laba bersih, nomor rekening) wajib diberi atribut `data-role-mask="staff,user,guest"` untuk memverifikasi proteksi informasi sejak fase prototipe.

---

## Workflow

1. **Setup Shared Assets**: Ensure `css/styles.css` and `js/app.js` are populated with tokens from `DESIGN.md`.
2. **Build Screen HTML**: Implement each screen using the reusable classes (`<button class="btn btn-primary">`, `<div class="card">`).
3. **Automated UI/UX Consistency Audit & Auto-Fix**: Run the mechanical audit tool:
   - Linux/Mac: `python3 scripts/design/uiux_audit.py docs/design/screens/ --fix --report docs/specs/DESIGN_SYSTEM_AUDIT.md`
   - Windows: `powershell -ExecutionPolicy Bypass -File scripts/design/uiux-audit.ps1 -Fix -Report docs/specs/DESIGN_SYSTEM_AUDIT.md`
   The auditor verifies cross-screen navigation parity, component class uniformity, animation timings, zero emoticons, and automatically resolves missing link tags and viewport definitions.
4. **Verify Sitemaps**: Verify that clicking navigation links transitions smoothly across prototype HTML files while keeping the navbar, typography, and button styles 100% consistent.
5. **Review**: Check against DESIGN_SPEC.md requirements (5 states, responsive, accessibility, zero emoticons).

## Quality Gates

Before moving to Module 06 (Development), verify each screen:

| Check | Status |
|:------|:------:|
| Linked to shared `css/styles.css` & `js/app.js` (no inline styles) | ❌ / ✅ |
| Matches DESIGN.md color tokens & typography | ❌ / ✅ |
| Reusable component classes used consistently (.btn, .card, .badge) | ❌ / ✅ |
| Responsive (mobile/tablet/desktop) & 44px touch targets | ❌ / ✅ |
| 5 states present (ideal/loading/empty/error/success) | ❌ / ✅ |
| Zero emoticons/emojis (cohesive SVG icons used everywhere) | ❌ / ✅ |
| No AI slop (generic shadows, uncalibrated styling, mismatched colors) | ❌ / ✅ |

## Handoff to Development

After all screens approved:

1. **Component extraction**: Move components to `src/components/ui/`
2. **Page assembly**: Wire pages in `src/app/` (Next.js) or `src/pages/` (other frameworks)
3. **State management**: Connect loading/empty/error states to API
4. **API integration**: Replace mock data with real endpoints

## Example MCP Commands

```typescript
// Get generated screen
const screen = await tool.prototype_get_screen({
  projectId: 'projects/[PROJECT_ID]',
  screenId: 'SCR-01'
});

// Save HTML
fs.writeFileSync('docs/design/screens/SCR-01-landing/screen.html', screen.html);

// Take screenshot (use Playwright/Puppeteer)
await page.screenshot({
  path: 'docs/design/screens/SCR-01-landing/screenshot.png',
  fullPage: true
});
```

---

**Note**: If not using Interactive Prototype, skip this folder and implement screens directly in code based on DESIGN_SPEC.md wireframes and component descriptions.
