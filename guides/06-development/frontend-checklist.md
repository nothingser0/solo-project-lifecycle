# Frontend Development Checklist

**Module**: M06 Development Execution  
**Purpose**: Detailed sequential checklist untuk frontend UI, forms, state management

**Use with**: React, Next.js, Vue, Svelte development

---

## 1. Component Library & Design System Setup

### Design Tokens Sync
- [ ] **Sinkronisasi Token Desain**:
  - [ ] Petakan token warna dari `DESIGN_SYSTEM.md` ke Tailwind config / CSS variables (Zinc palette, accent primary).
  - [ ] Konfigurasikan font family Inter, skala tipografi (text-xs hingga text-4xl), dan default border radius (rounded-md).

### Primitive Components (UI Atoms)
- [ ] **Komponen Primitif (UI Atoms)**:
  - [ ] `Button`: Varian primary, secondary, outline, ghost, destructive, with loading spinner state.
  - [ ] `Input` & `Textarea`: Varian normal, focused, error, disabled, helper text.
  - [ ] `Select`, `Checkbox`, `RadioGroup`, `Switch`: Form controls dengan status keyboard navigable.
  - [ ] `Badge`, `Avatar`, `Separator`, `Skeleton`: Elemen dekoratif dan identitas visual.

### Feedback Components (UI Molecules)
- [ ] **Komponen Feedback & Overlay (UI Molecules)**:
  - [ ] `Toast`: Notifikasi pop-up (Sonner / Toast) dengan varian success, error, info, warning.
  - [ ] `Modal / Dialog`: Overlay konfirmasi dengan trap focus dan tombol escape close.
  - [ ] `Drawer / Sheet`: Panel samping geser untuk navigasi mobile atau form sekunder.
  - [ ] `DropdownMenu` & `Popover`: Menu kontekstual dengan positioning dinamis.

### Navigation Components
- [ ] **Komponen Navigasi & Struktur**:
  - [ ] `Navbar`: Bar atas dengan logo proyek, breadcrumb dinamis, dan user profile dropdown.
  - [ ] `Sidebar`: Navigasi samping collapsible dengan indikator rute aktif.
  - [ ] `PageHeader`: Judul halaman, deskripsi, dan tombol aksi utama (*action bar*).

### Accessibility (WCAG AA)
- [ ] **Aksesibilitas (WCAG AA Compliance)**:
  - [ ] Uji rasio kontras teks minimal 4.5:1 terhadap latar belakang.
  - [ ] Pastikan seluruh elemen interaktif memiliki `focus-visible:ring-2` yang tampak jelas saat ditab.
  - [ ] Pasang atribut `aria-label` dan `aria-expanded` pada tombol ikon dan modal trigger.

---

## 2. Pages & Routing Architecture

### Layout Hierarchy
- [ ] **Hierarki Layout Aplikasi**:
  - [ ] `RootLayout`: Pasang penyedia tema, font Inter, dan toaster global.
  - [ ] `(auth)/layout.tsx`: Layout terpusat bersih untuk alur autentikasi tanpa sidebar.
  - [ ] `(dashboard)/layout.tsx`: Layout terproteksi dengan sidebar tetap, navbar, dan auth guard.

### Authentication Pages
- [ ] **Halaman Autentikasi**:
  - [ ] Halaman Login (`/login`), Register (`/register`), Forgot Password (`/forgot-password`), Reset Password (`/reset-password`).
  - [ ] Alur redirect cerdas: Simpan parameter `?callbackUrl=` untuk mengembalikan user ke halaman target setelah login.

### Application Pages
- [ ] **Halaman Aplikasi Utama**:
  - [ ] Halaman Index Dashboard (`/dashboard`): Menampilkan ringkasan metrik statistik dan tabel aktivitas terkini.
  - [ ] Halaman Daftar Entitas (`/documents`): Tabel data dengan pencarian, filter status, dan pagination.
  - [ ] Halaman Detail Entitas (`/documents/[id]`): Tampilan detail lengkap, riwayat audit, dan status approval.
  - [ ] Halaman Buat/Edit Entitas (`/documents/new` & `/documents/[id]/edit`): Formulir terstruktur.
  - [ ] Halaman Pengaturan (`/settings/profile`, `/settings/billing`, `/settings/team`).

### Error Pages
- [ ] **Halaman Error Defensif**:
  - [ ] `not-found.tsx`: Halaman 404 ramah pengguna dengan tombol kembali ke dashboard.
  - [ ] `error.tsx`: Global Error Boundary dengan tombol reset / coba lagi.

---

## 3. State Management

### Server State
- [ ] **Server-State Management**:
  - [ ] Setup TanStack Query / SWR / Server Action cache revalidation.
  - [ ] Tetapkan kebijakan caching: `staleTime: 60_000` (1 menit) untuk data standar, 0 untuk data real-time.
  - [ ] Pasang mutasi dengan otomatis invalidasi query kunci terkait (`queryClient.invalidateQueries`).

### Client UI State
- [ ] **Client UI State Store**:
  - [ ] Setup Zustand / Context ringan untuk state UI ephemera: sidebar open/closed, active modal, tema gelap/terang.
  - [ ] Hindari menyimpan data entitas server di dalam client store untuk mencegah *stale state mismatch*.

### URL Sync
- [ ] **Sinkronisasi URL Search Params**:
  - [ ] Sinkronkan parameter tabel (search query, halaman aktif, filter status) ke URL browser (`?page=2&status=active`).
  - [ ] Pengguna dapat membagikan (*share*) URL atau me-refresh halaman tanpa kehilangan posisi filter.

---

## 4. Form Handling & Validation

### Form Library Integration
- [ ] **Integrasi Form Library**:
  - [ ] Pasang React Hook Form / Formik pada seluruh form input.
  - [ ] Hubungkan validasi resolver Zod (`@hookform/resolvers/zod`) menggunakan skema yang sama dengan backend.

### Inline Validation
- [ ] **Umpan Balik Validasi Inline**:
  - [ ] Tampilkan pesan error spesifik langsung di bawah input field yang bermasalah.
  - [ ] Highlight border merah (`border-destructive`) pada input yang invalid saat disubmit.

### Submit Protection
- [ ] **Perlindungan Double Submit & Navigation Guard**:
  - [ ] Nonaktifkan (`disabled`) tombol submit dan tampilkan spinner saat request sedang diproses.
  - [ ] Beri konfirmasi peringatan (*unsaved changes alert*) jika pengguna mencoba meninggalkan form yang belum disimpan.

---

## 5. API Integration & Client Wiring

### HTTP Client
- [ ] **Abstraksi HTTP Client**:
  - [ ] Buat wrapper API terpusat (`src/lib/api-client.ts`) berbasis `fetch` atau `axios`.
  - [ ] Interceptor otomatis menyuntikkan header Authorization atau mengelola credentials cookie.
  - [ ] Tangani otomatis respons `401 Unauthorized`: redirect ke `/login` atau jalankan silent refresh token.

### File Upload
- [ ] **Upload File Direct-to-Cloud**:
  - [ ] Minta presigned URL dari backend → Upload file langsung ke S3/R2 menggunakan `fetch(putUrl, { body: file })`.
  - [ ] Tampilkan bar progres persentase upload (0% s/d 100%) ke pengguna.

### Optimistic Updates
- [ ] **Optimistic UI Updates**:
  - [ ] Terapkan optimistic update pada aksi instan (misal: toggle bookmark, update status checkbox).
  - [ ] Sediakan mekanisme *rollback* otomatis ke state sebelumnya jika request API backend gagal.

---

## 6. The 5 UI States Implementation (Defensive UI)

### State 1: Idle
- [ ] **Idle State**: Tampilan awal komponen dalam kondisi bersih dan siap menerima aksi.

### State 2: Loading
- [ ] **Loading State**: Gunakan skeleton loader yang memiliki dimensi dan layout persis dengan konten asli (DILARANG spinner layar penuh tanpa konteks).

### State 3: Success
- [ ] **Success State**: Tampilkan toast konfirmasi aksi berhasil, animasikan perubahan visual, dan reset form.

### State 4: Error
- [ ] **Error State**: Tampilkan inline error banner, keterangan kesalahan bahasa manusiawi, dan tombol "Coba Lagi" (Retry).

### State 5: Empty
- [ ] **Empty State**: Tampilkan ikon tematik, judul deskriptif (misal: "Belum Ada Dokumen"), teks motivasi singkat, dan tombol Call-to-Action utama ("Buat Dokumen Sekarang").

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
- `guides/06-development/backend-checklist.md` - Backend API tasks
- `guides/06-development/integration-checklist.md` - Third-party integrations
- `patterns/validation/zod-patterns.md` - Form validation schemas
- `references/stacks/nextjs-15-quickstart.md` - Next.js specific setup
- M06 Development Execution - Core module documentation
