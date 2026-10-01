# Design Specification & UI Wireflow

> Dokumen spesifikasi desain antarmuka, arsitektur informasi, token visual, dan inventaris layar untuk mengunci alur visual sebelum tahap arsitektur teknis dan koding.

---

## 1. Metadata Desain
- **Nama Proyek**: [Nama Sistem / Aplikasi]
- **Klien**: [Perusahaan / Organisasi Klien]
- **Solo Lead UI/UX & Engineer**: [Nama Anda]
- **Versi Desain**: 1.0.0
- **Status Desain**: [Draft / In Review / Frozen (Approved)]
- **Google Stitch Project ID**: `projects/[PROJECT_ID]`
- **Design System Asset ID**: `assets/[ASSET_ID]` (dari `DESIGN.md`)
- **Tautan Live Interactive Prototype**: `[https://staging-preview-url atau Stitch Viewer URL]`
- **Tanggal Persetujuan**: [YYYY-MM-DD]

---

## 2. Arsitektur Informasi & Peta Rute URL (Sitemap)

| Rute URL | Nama Halaman | Peran Pengguna yang Mengakses | Fungsi Utama & Interaksi |
| :--- | :--- | :--- | :--- |
| `/login` | Halaman Masuk | Publik / Seluruh Pengguna | Form input email, password/OTP, link reset |
| `/dashboard` | Dashboard Utama | Super Admin, Manager, Staf | Ringkasan statistik, daftar dokumen terbaru, CTA baru |
| `/documents` | Manajemen Dokumen | Seluruh Pengguna Terotentikasi | Tabel dokumen, filter status, fitur pencarian, ekspor |
| `/documents/new` | Pembuat Dokumen | Staf Operasional, Manager | Form dinamis input variabel template, preview PDF |
| `/documents/:id` | Detail Dokumen | Seluruh Pengguna Terkait | Tampilan status audit trail, tombol tanda tangan digital |
| `/sign/:token` | Halaman Tanda Tangan | Tamu Eksternal / Signer | Canvas tanda tangan digital tanpa perlu login akun |

---

## 3. Sistem Desain & Token Visual (Design Tokens)

### 3.1 Tipografi
- **Primary Font (UI & Body Text)**: `Inter` atau `Geist Sans` (Fallback: `system-ui, sans-serif`)
- **Monospace Font (Kode, Hash, Angka Finansial)**: `JetBrains Mono` atau `Geist Mono`
- **Skala Ukuran Teks**:
  - Heading 1: `32px` / `line-height: 40px` / `font-weight: 700`
  - Heading 2: `24px` / `line-height: 32px` / `font-weight: 600`
  - Body Text: `14px` / `line-height: 20px` / `font-weight: 400`
  - Caption / Helper: `12px` / `line-height: 16px` / `font-weight: 400`

### 3.2 Palet Warna & Verifikasi Kontras (WCAG 2.1 AA)

| Token Warna | Nilai HEX | Penggunaan UI | Rasio Kontras ke Background | Status Kelulusan |
| :--- | :---: | :--- | :---: | :---: |
| `background` | `#FFFFFF` | Latar belakang halaman utama | - | Base |
| `surface` | `#F4F4F5` | Kartu komponen, container form | - | Base |
| `text-primary` | `#09090B` | Teks judul dan body text utama | **19.8 : 1** | PASS (AAA) |
| `text-muted` | `#71717A` | Placeholder, label sekunder | **4.6 : 1** | PASS (AA) |
| `primary` | `#[Brand]` | Tombol utama, link aktif | **$\ge 4.5 : 1$** | PASS (AA) |
| `success` | `#16A34A` | Badge status sukses, konfirmasi | **$\ge 4.5 : 1$** | PASS (AA) |
| `destructive` | `#DC2626` | Tombol hapus, alert error | **$\ge 4.5 : 1$** | PASS (AA) |

---

## 4. Pilihan Library Komponen Dasar
- **Pustaka UI**: `Shadcn UI` (berbasis Radix UI primitives & Tailwind CSS).
- **Icon Set**: `Lucide Icons` (konsisten, stroke 1.5px atau 2px).
- **Komponen Form**: `React Hook Form` + validasi `Zod`.
- **Komponen Notifikasi**: `Sonner` (toast notification ringan di pojok kanan bawah).

---

## 5. Inventaris Lengkap Seluruh Layar (Exhaustive Screen Inventory - 100% Coverage)

> **ATURAN CAKUPAN MUTLAK**: Tabel ini WAJIB mencakup **100% seluruh halaman/layar** yang telah didefinisikan pada batasan lingkup (`SCOPE_STATEMENT.md` / `PRD.md`) dari awal hingga akhir tanpa terkecuali. Jika dalam lingkup terdapat 10, 20, atau 100 halaman, seluruhnya WAJIB didaftarkan dan di-generate di Google Stitch dengan Screen ID unik masing-masing. DILARANG memangkas atau hanya memilih sebagian sampel layar.

| Kode Layar | Nama Layar | Google Stitch Screen ID | Default State | Loading Skeleton | Empty State | Error State |
| :---: | :--- | :--- | :--- | :--- | :--- | :--- |
| **SCR-01** | Dashboard | `screens/[ID_01]` | Widget statistik & tabel | Skeleton bar abu-abu | Banner "Belum ada dokumen" + CTA buat | Banner server timeout |
| **SCR-02** | Form Dokumen | `screens/[ID_02]` | Input form dinamis terstruktur | Tombol submit disable + loader | - | Pesan teks merah inline |
| **SCR-03** | Detail & Sign | `screens/[ID_03]` | Preview PDF + kotak tanda tangan | Skeleton render dokumen | - | Alert gagal verifikasi hash |
| **SCR-..** | [Seluruh Layar Lain] | `screens/[ID_..]` | [Wajib isi 100% tanpa ada yang di-skip] | ... | ... | ... |

---

## 6. Detail Breakdown per Layar (Screen Wireframe & Section Inventory)

> **ATURAN DETAIL BREAKDOWN**: Setiap layar yang terdaftar di Section 5 WAJIB memiliki breakdown lengkap yang mencakup: (1) Layout structure (header/sidebar/main/footer), (2) Section-by-section inventory (hero, form, table, CTA, dll), (3) Komponen yang digunakan (button, input, card, modal, dropdown), (4) Wireframe text-based atau ASCII art untuk visualisasi awal, (5) Interaction & state flow (default, loading, empty, error).

### Format per Layar:

```
### SCR-XX: [Nama Layar] ([Route URL])

**Layout Structure:**
- Header: [logo, nav menu, user avatar, logout]
- Sidebar: [navigation links, active state indicator]
- Main Content: [primary content area breakdown]
- Footer: [copyright, links, social icons]

**Section Breakdown:**
1. Section 1: [Nama Section] (e.g., Hero, Form Input, Data Table)
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

2. Section 2: [Nama Section Berikutnya]
   - [Detail serupa seperti Section 1]

**Interaction & State Flow:**
- Default State: [Deskripsi tampilan normal]
- Loading State: [Skeleton/spinner, button disabled]
- Empty State: [Placeholder message + CTA]
- Error State: [Error message inline atau toast]

**Responsive Behavior:**
- Mobile (375px): [Stack vertical, hide sidebar, hamburger menu]
- Tablet (768px): [2-column grid, collapsible sidebar]
- Desktop (1280px): [3-column grid, fixed sidebar]
```

### Contoh Detail Breakdown:

### SCR-01: Landing Page (/)

**Layout Structure:**
- Header: Logo (kiri), Nav menu (Home, Features, Pricing, Blog), CTA Button "Daftar Gratis" (kanan)
- Main Content: 8 sections (Hero, Problem, Solution, How It Works, Social Proof, Pricing, FAQ, CTA Final)
- Footer: Logo + tagline, Links (Tentang, Kontak, Privacy, Terms), Social icons, Copyright

**Section Breakdown:**

1. **Section 1: Hero**
   - Heading: "Hitung 3 Skema Pajak Freelancer. Pilih yang Paling Hemat."
   - Subheading: "Simpan Jutaan Rupiah per Tahun"
   - Components:
     - Button (primary): "Hitung Pajak Gratis" → /signup
     - Hero Image: Dashboard preview atau ilustrasi kalkulator
   - Wireframe:
     ```
     ┌──────────────────────────────────────────────────┐
     │  [Logo]    Home  Features  Pricing  [Daftar]    │
     ├──────────────────────────────────────────────────┤
     │                                                  │
     │         Hitung 3 Skema Pajak Freelancer         │
     │         Pilih yang Paling Hemat                 │
     │                                                  │
     │         Simpan Jutaan Rupiah per Tahun          │
     │                                                  │
     │         [Hitung Pajak Gratis →]                 │
     │                                                  │
     │              [Hero Image/Illustration]           │
     │                                                  │
     └──────────────────────────────────────────────────┘
     ```

2. **Section 2: Problem Statement**
   - Heading: "Freelancer Bayar Pajak Lebih Mahal Karena..."
   - Components:
     - Card Grid (3 columns):
       - Card 1: Icon "❓", Heading "Bingung Pilih Skema", Text "Trial-error 3 kalkulator, buang waktu 30-60 menit"
       - Card 2: Icon "📊", Heading "Tracking Manual Ribet", Text "5-10 client campuran DN/LN/crypto, data berantakan"
       - Card 3: Icon "⏰", Heading "Lupa Deadline", Text "Kena denda Rp100rb + bunga 2%/bulan"
   - Wireframe:
     ```
     ┌──────────────────────────────────────────────────┐
     │  Freelancer Bayar Pajak Lebih Mahal Karena...   │
     │                                                  │
     │  ┌──────┐  ┌──────┐  ┌──────┐                  │
     │  │  ❓  │  │  📊  │  │  ⏰  │                  │
     │  │Bingung│ │Manual│  │ Lupa │                  │
     │  │Pilih  │ │Ribet │  │Deadln│                  │
     │  │Skema  │ │Track │  │      │                  │
     │  └──────┘  └──────┘  └──────┘                  │
     └──────────────────────────────────────────────────┘
     ```

3. **Section 3: Solution / Value Prop**
   - Heading: "FreePajak = Tax Planning Assistant"
   - Subheading: "Bukan kalkulator one-shot, tapi tax planning assistant lengkap"
   - Components:
     - Feature Grid (2×3 grid):
       - Feature 1: Icon, "Compare 3 Skema" (Final 0.5%, NPPN, Tarif Umum)
       - Feature 2: Icon, "Multi-Client Tracking" (DN/LN/crypto)
       - Feature 3: Icon, "Export SPT Excel" (Lampiran I SPT 1770)
       - Feature 4: Icon, "Tax Treaty 71 Negara" (Withholding tax rate)
       - Feature 5: Icon, "Crypto Tracker" (BTC/ETH/USDT, kurs KMK)
       - Feature 6: Icon, "Reminder Deadline" (PPh 25, SPT Tahunan)

4. **Section 4: How It Works**
   - Heading: "3 Langkah Simpel"
   - Components:
     - Step Grid (3 columns):
       - Step 1: Number "1", Heading "Input Omzet", Text "Isi omzet per bulan, status PTKP, client DN/LN", Ilustrasi form
       - Step 2: Number "2", Heading "Compare 3 Skema", Text "Lihat perbandingan Final 0.5%, NPPN, Tarif Umum", Ilustrasi tabel
       - Step 3: Number "3", Heading "Export SPT", Text "Download Excel Lampiran I SPT 1770, upload ke Coretax", Ilustrasi button download

5. **Section 5: Social Proof**
   - Badge: "Sesuai UU HPP 2021, PP 20/2026, PMK 168/2023"
   - Testimonial Placeholder: "Testimonial user akan ditambahkan setelah MVP launch"

6. **Section 6: Pricing Table**
   - Heading: "Pilih Paket yang Sesuai"
   - Components:
     - Pricing Card Grid (2 columns):
       - Card 1 (Free):
         - Heading "Gratis"
         - Price "Rp0/bulan"
         - Features List: "1 skema kalkulator", "Max 3 client", "1× export SPT/tahun", "Email reminder"
         - Button "Mulai Gratis" → /signup
       - Card 2 (Premium):
         - Heading "Premium"
         - Price "Rp49rb/bulan"
         - Badge "Paling Populer"
         - Features List: "3 skema + perbandingan", "Unlimited client", "Tax treaty 71 negara", "Crypto tracker", "Export unlimited", "Simulasi 12 bulan"
         - Button "Upgrade Premium" → /signup?plan=premium

7. **Section 7: FAQ**
   - Heading: "Pertanyaan Sering Ditanyakan"
   - Components:
     - Accordion (5 items):
       - Q1: "Aman gak data NPWP saya?" → A: "Data terenkripsi AES-256, gak dibagi ke pihak ketiga"
       - Q2: "Bisa lapor SPT langsung dari sini?" → A: "Belum, FreePajak bantu hitung & export Excel, lapor tetap via Coretax DJP"
       - Q3: "Bedanya Final 0.5% vs NPPN?" → A: "Final 0.5% paling simpel (omzet × 0.5%), NPPN deemed profit 50%"
       - Q4: "Kalau client luar negeri gimana?" → A: "Tax treaty calculator otomatis hitung withholding tax rate 71 negara"
       - Q5: "Bisa refund Premium?" → A: "Refund penuh 7 hari pertama, no questions asked"

8. **Section 8: CTA Final**
   - Heading: "Mulai Hemat Pajak Hari Ini"
   - Subheading: "Gratis selamanya untuk 1 skema + 3 client. Upgrade kapan aja."
   - Button (primary): "Daftar Gratis" → /signup

**Interaction & State Flow:**
- Default State: Semua section tampil normal
- Loading State: N/A (static landing page)
- Empty State: N/A
- Error State: N/A

**Responsive Behavior:**
- Mobile (375px): Stack vertical, hero image ukuran 80%, card grid 1 column, pricing table 1 column
- Tablet (768px): Card grid 2 columns, pricing table 2 columns
- Desktop (1280px): Card grid 3 columns (Problem section), 2×3 grid (Value Prop section)

---

### SCR-02: Dashboard (/dashboard)

**Layout Structure:**
- Header: Logo (kiri), Search bar (tengah), Notification bell + User avatar dropdown (kanan)
- Sidebar: Nav links (Dashboard, Calculator, Clients, Transactions, Settings), Active state indicator (bg-primary)
- Main Content: Summary cards + chart + recent transactions table
- Footer: N/A (dashboard gak perlu footer)

**Section Breakdown:**

1. **Section 1: Summary Cards (4 cards horizontal)**
   - Card 1: "Total Omzet Tahun Ini" → Value "Rp240.000.000" (sum all transactions), Icon "💰", Trend "+12% vs bulan lalu"
   - Card 2: "Pajak Terutang" → Value "Rp11.500.000" (calculated based on selected schema), Icon "📊", Tooltip "Berdasarkan skema NPPN 50%"
   - Card 3: "Kredit Pajak" → Value "Rp4.500.000" (sum withheld from DN clients), Icon "✅"
   - Card 4: "Kurang/Lebih Bayar" → Value "Rp7.000.000 Kurang Bayar" (pajak terutang - kredit pajak), Icon "⚠️", Color "text-destructive"

2. **Section 2: Omzet Chart (Bar Chart Jan-Des)**
   - Heading: "Omzet per Bulan"
   - Chart: Bar chart 12 bulan (Jan-Des), Y-axis Rupiah, X-axis bulan
   - Interaction: Hover bar → tooltip "Februari: Rp22.000.000"

3. **Section 3: Next Deadline Card**
   - Heading: "Deadline Pajak Terdekat"
   - Card:
     - Date: "15 Oktober 2026"
     - Type: "PPh 25 Angsuran Bulanan"
     - Estimasi: "Rp966.000"
     - Button: "Bayar via e-Billing" → open link DJP e-Billing
     - Countdown: "14 hari lagi"

4. **Section 4: Recent Transactions (Table 5 baris terakhir)**
   - Heading: "Transaksi Terakhir"
   - Table Columns: Tanggal | Client | Amount | Currency | Amount IDR | Action
   - Table Rows (5 terakhir):
     - 2026-09-25 | PT ABC | Rp10.000.000 | IDR | Rp10.000.000 | [Edit] [Delete]
     - 2026-09-20 | Upwork Client | USD 500 | USD | Rp8.797.000 | [Edit] [Delete]
     - ...
   - Button: "Lihat Semua Transaksi" → /transactions

**Interaction & State Flow:**
- Default State: Cards populated dengan data real, chart tampil, table 5 baris
- Loading State: Skeleton cards (shimmer gray), skeleton chart, skeleton table rows
- Empty State (jika belum ada transaksi): Ilustrasi empty + text "Belum ada transaksi. Mulai tracking penghasilan kamu sekarang." + Button "Tambah Transaksi" → /transactions?action=new
- Error State: Toast notification "Gagal memuat data dashboard. Coba lagi." + Button retry

**Responsive Behavior:**
- Mobile (375px): Cards stack vertical (4×1), chart full width, table scroll horizontal
- Tablet (768px): Cards 2×2 grid, chart full width
- Desktop (1280px): Cards 4×1 horizontal, chart 2/3 width (kiri), deadline card 1/3 width (kanan)

---

**[TEMPLATE INSTRUCTION]**: Ulangi format detail breakdown di atas untuk **SEMUA layar lainnya** (SCR-03 Calculator, SCR-04 Clients, SCR-05 Transactions, SCR-06 Settings, SCR-07 Login, SCR-08 Signup, SCR-09 Onboarding, dst) tanpa terkecuali. Setiap layar WAJIB memiliki:
1. Layout Structure (header/sidebar/main/footer)
2. Section Breakdown (min 2-5 section per layar, dengan heading/subheading/components/wireframe ASCII)
3. Interaction & State Flow (default/loading/empty/error)
4. Responsive Behavior (mobile/tablet/desktop breakpoint)

---

## 7. Standar Aksesibilitas & Responsif
- [x] Seluruh tombol interaktif memiliki `focus-visible` ring untuk navigasi keyboard (Tombol Tab).
- [x] Input form memiliki label teks eksplisit (`<label htmlFor="...">`) dan `aria-describedby` untuk pesan error.
- [x] Antarmuka responsif mendukung viewport layar: Mobile (`375px`), Tablet (`768px`), dan Desktop (`1280px`).
- [x] Ukuran tap target tombol di mobile minimal `44 x 44 px` agar mudah ditekan jari.

---

## 7. Lembar Persetujuan Pembekuan Desain (Design Freeze Sign-Off)

Dengan ditandatanganinya lembar ini, Pihak Klien menyatakan telah meninjau dan menyetujui seluruh tata letak visual, arsitektur navigasi, dan alur prototipe interaktif pada dokumen ini.

**Klausul Pembekuan Desain**:
1. Seluruh rancangan visual resmi berstatus **FROZEN (DIBEKUKAN)**.
2. Tahap pengerjaan berikutnya akan langsung masuk ke spesifikasi arsitektur teknis dan pengkodean.
3. Segala perubahan struktur tata letak, penambahan halaman baru, atau perombakan alur antarmuka setelah tanggal persetujuan ini akan dikenakan biaya dan waktu tambahan melalui prosedur *Change Request (CR)*.

| Disetujui oleh Single PIC Klien | Divalidasi oleh Solo Engineer |
| :--- | :--- |
| **Nama**: _________________________ | **Nama**: _________________________ |
| **Jabatan**: ______________________ | **Jabatan**: Independent Lead Engineer |
| **Tanggal**: ______________________ | **Tanggal**: ______________________ |
| **Tanda Tangan**: | **Tanda Tangan**: |
