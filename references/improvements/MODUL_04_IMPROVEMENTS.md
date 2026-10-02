# Modul 04 Improvements: Design Specification Without Stitch

## Keputusan Workflow

Untuk solo project, MVP, dan proyek yang belum punya design system matang, Google Stitch **tidak menjadi tool wajib**. Stitch hanya opsi tambahan jika hasilnya konsisten dan lolos review. Design source of truth tetap tiga dokumen berikut:

1. `DESIGN.md` di root: design tokens dan aturan komponen.
2. `docs/specs/DESIGN_SPEC.md`: sitemap, page/sub-page inventory, layout, states, responsive behavior, dan acceptance criteria.
3. `docs/design/DESIGN_REFERENCES.md`: keyword pencarian visual untuk Pinterest, Behance, dan Dribbble. Isinya keyword, bukan screenshot atau copy desain orang lain.

Jangan membuat prototype palsu, Screen ID Stitch, atau prompt Stitch jika user tidak memintanya.

## Deliverables dan Batasan

### DESIGN.md
Wajib memuat:

- Brand direction dan prinsip visual.
- Color tokens: primitive dan semantic.
- Typography scale lengkap, font weight, line-height, dan measure.
- Spacing, radius, border, shadow, breakpoint, dan motion tokens.
- Layout container, grid, dan responsive rules.
- Component contract untuk Button, Link, Input, Select, Textarea, Checkbox, Radio, Card, Badge, Alert, Dialog, Table, Tabs, Breadcrumb, Header, Footer, Sidebar, Empty State, Loading State, dan Error State.
- State setiap komponen: default, hover, focus-visible, active, disabled, loading, error, success bila relevan.
- Accessibility rules: keyboard, contrast, focus ring, label, alt text, reduced motion.
- Content rules: bahasa, format angka/tanggal, panjang heading, empty/error copy.
- Anti-slop rules yang bisa diverifikasi, bukan larangan estetika yang terlalu sempit.

### DESIGN_SPEC.md
Wajib memuat:

- Product navigation map.
- Daftar semua page dan sub-page yang benar-benar diperlukan. Jangan memaksa 25 halaman jika scope tidak membutuhkan.
- Untuk setiap page: route, tujuan, user role, entry points, sections, components, data, actions, responsive behavior, dan states.
- Shared shell: header, footer, navigation, breadcrumbs, auth guard.
- Page state matrix: loading, empty, error, success, permission denied, not found bila relevan.
- Asset inventory dan kebutuhan metadata SEO.
- Acceptance checklist per page.
- Design Freeze status dan daftar keputusan yang belum final.

Page baseline yang perlu ditriase, bukan otomatis dibuat:

- Marketing: home, pricing, features, about, contact, FAQ.
- Legal: privacy, terms, cookies.
- Auth: login, register, forgot/reset password.
- Product: dashboard, profile/settings, billing, notifications.
- Core pages: ditentukan dari `SCOPE_STATEMENT.md`.
- System: not-found, unauthorized, forbidden, server-error, maintenance.

### DESIGN_REFERENCES.md
Per page/component, tulis:

- Search keywords dalam bahasa Inggris dan Indonesia.
- Mood yang dicari: dense, editorial, calm, data-heavy, playful, formal.
- Hal yang boleh diambil: hierarchy, spacing, navigation pattern, information density.
- Hal yang dilarang ditiru: logo, copy, illustration, proprietary layout secara identik.
- URL referensi hanya jika user memang menambahkannya sendiri.

Contoh keyword:

- `minimal SaaS landing page editorial typography Behance`
- `B2B tax dashboard dense data table Dribbble`
- `accessible form error states Figma`
- `responsive SaaS pricing page no gradient Pinterest`
- `enterprise footer navigation sitemap UI`

## Standardisasi yang Wajib

- Satu shared `Header` dan `Footer` dipakai lintas page. Variant hanya boleh jika ada alasan produk yang terdokumentasi.
- Semua page memakai container, grid, spacing, type scale, dan breakpoint dari `DESIGN.md`.
- Jangan membuat button, card, background, atau typography ad-hoc per page.
- Setiap page punya mobile layout, bukan sekadar mengecilkan desktop.
- Background boleh memakai surface hierarchy, pattern, border, atau illustration asset yang didefinisikan token. Background polos tidak otomatis salah, tetapi harus punya fungsi visual.
- Komponen UI harus punya hierarchy, interaction states, affordance, dan content yang nyata. `bg-color + text + padding` saja bukan component spec.
- Asset placeholder harus diberi nama dan ukuran target. Jangan memakai asset final palsu.

## Minimal Page Specification

Gunakan format ini untuk setiap page:

```md
## [PAGE-ID] Nama Page
- Route:
- Purpose:
- Audience/role:
- Entry points:
- Shared shell: Header [variant], Footer [variant]
- Sections:
  1. ...
- Components:
  - ...
- Data and actions:
  - ...
- States: loading, empty, error, success, forbidden
- Responsive behavior:
  - mobile:
  - tablet:
  - desktop:
- Assets:
- SEO metadata:
- Acceptance criteria:
  - ...
```

## Scope Decision

- Solo MVP: DESIGN.md + DESIGN_SPEC.md + DESIGN_REFERENCES.md. Self-review cukup.
- Client project: tambah Design Freeze approval dan review client.
- Multi-platform atau tim besar: evaluasi M04 Section 8 untuk governance design system.
- User testing dan Stitch bukan output default Modul 04. Jalankan hanya jika risiko UX, client contract, atau domain high-stakes memang membutuhkan.

## Items yang Dihapus dari Modul 04

- Kewajiban memakai Google Stitch.
- Kewajiban membuat Screen ID Stitch.
- Kewajiban membuat clickable Stitch prototype.
- Kewajiban membuat 25-40 page tanpa melihat scope.
- Kewajiban dua iterasi dengan lima user untuk semua proyek.
- Prompt Stitch dan folder export Stitch.

## Gate Modul 04

PASS jika:

- Tiga file inti ada dan saling konsisten.
- Semua page/sub-page in-scope punya spesifikasi.
- Shared components dan states terdokumentasi.
- Responsive, accessibility, asset, dan acceptance criteria tertulis.
- Tidak ada page yang dibuat hanya karena template menyuruhnya.
- Design Freeze atau self-review tercatat.
