# Design & Architecture Phase TODO Template (Modul 04 - Modul 05)

> Template daftar tugas atomik untuk fase Desain UI/UX, Design System Foundation, Arsitektur Sistem, dan Spesifikasi Teknis (FSD & SDD).
> Aturan: Kerjakan secara bertahap dari token desain ke prototipe interaktif, kemudian ke arsitektur teknis dan kontrak API. Selesaikan seluruh checklist dan peroleh persetujuan formal klien/lead architect sebelum memulai penulisan kode di Modul 06.

---

## Metadata Proyek
- **Nama Proyek**: [Nama Proyek / Sistem]
- **Lead Product Designer**: [Nama Designer]
- **Lead Software Architect**: [Nama Architect / Solo Dev]
- **Tanggal Mulai**: [YYYY-MM-DD]
- **Target Selesai Fase Desain**: [YYYY-MM-DD]
- **Design Tooling**: Figma / Google Stitch / Penpot / Tailwind CSS
- **Status Gerbang Desain**: [ ] DRAFT | [ ] UNDER REVIEW | [ ] APPROVED / FROZEN

---

## 1. Modul 04B: Fondasi Sistem Desain (Design System Foundation)

### 1.1 Audit Sistem Desain & Token Desain (Design Tokens)
- [ ] `design/tokens/colors.json`: Definisikan palet warna semantik (Primary, Secondary, Accent, Neutral/Gray scale, Destructive, Warning, Success, Info) - expect kontras teks terhadap latar belakang lolos WCAG 2.1 AA (rasio minimal 4.5:1 untuk teks normal, 3:1 untuk teks besar)
- [ ] `design/tokens/typography.json`: Tentukan skala tipografi modular (Font family body & display, font weights, size scale dari `text-xs` hingga `text-4xl`, line-height proporsional) - expect teks nyaman dibaca pada seluruh viewport
- [ ] `design/tokens/spacing-grid.json`: Tetapkan sistem grid 8-pt / 4-pt grid dan skala spacing (padding, margin, gap: 4px, 8px, 12px, 16px, 24px, 32px, 48px, 64px) - expect konsistensi ritme vertikal dan horizontal
- [ ] `design/tokens/elevation-borders.json`: Konfigurasikan token bayangan (*shadows/elevation levels 1-4*) dan kelengkungan sudut (*border-radius tokens: sm, md, lg, full*) - expect hierarki kedalaman visual seragam
- [ ] `design/tokens/theme-modes.json`: Siapkan pemetaan variabel token untuk mode terang (*Light Mode*) dan mode gelap (*Dark Mode*) - expect switching tema mulus tanpa hardcoded color values

### 1.2 Pustaka Komponen Primitif & Spesifikasi API Komponen
- [ ] `design/specs/components/button.md`: Buat spesifikasi visual dan status komponen Button (Variants: Solid, Outline, Ghost, Link; Sizes: sm, md, lg; States: default, hover, focus-visible, active, disabled, loading dengan spinner) - expect interaksi keyboard accessible via Tab & Enter/Space
- [ ] `design/specs/components/form-inputs.md`: Rancang komponen input formulir (Text Input, Textarea, Select/Dropdown, Checkbox, Radio, Switch, File Upload) - expect label eksplisit, placeholder bersih, helper text, dan visual error inline
- [ ] `design/specs/components/feedback-overlays.md`: Definisikan spesifikasi Modal/Dialog, Drawer/Sheet, Tooltip, Alert banner, dan Toast notification - expect fokus otomatis terperangkap (*focus trap*) di dalam dialog aktif
- [ ] `design/specs/components/data-display.md`: Rancang komponen Table (dengan header sorting, pagination, empty state), Card, Badge/Tag, Avatar, dan Skeleton loader - expect data tabular adaptif terhadap konten panjang
- [ ] `design/specs/component-rfc.md`: Susun Component RFC untuk komponen kustom yang kompleks (misal: Dynamic Data Table, Drag-and-Drop Uploader, Signature Canvas) - expect kontrak props TypeScript dan event handler terdokumentasi

### 1.3 Aksesibilitas & Responsivitas (A11y & Mobile Ergonomics)
- [ ] `design/specs/accessibility-audit.md`: Verifikasi fokus keyboard visual (*outline focus-visible ring*) tidak pernah dihilangkan (`outline: none` dilarang tanpa pengganti) - expect indikator fokus terlihat jelas di semua browser
- [ ] `design/specs/mobile-ergonomics.md`: Pastikan seluruh target interaksi sentuh (*touch targets*) berukuran minimal 44x44px pada layar sentuh - expect tidak ada elemen clickable yang terlalu berdempetan di mobile
- [ ] `design/specs/breakpoints.md`: Tetapkan standar breakpoint responsif (`sm: 640px`, `md: 768px`, `lg: 1024px`, `xl: 1280px`, `2xl: 1536px`) dan perilaku reflow layout - expect tidak ada horizontal scrollbar yang tidak diinginkan di resolusi 375px

---

## 2. Modul 04: Pembuatan Prototipe UI/UX (UI/UX Prototyping)

### 2.1 Wireframing & Alur Pengguna (User Flow)
- [ ] `design/flows/information-architecture.md`: Petakan Sitemap dan Information Architecture (IA) navigasi aplikasi - expect struktur pohon menu hierarkis maksimal 3 level kedalaman
- [ ] `design/flows/user-flows.md`: Gambarkan diagram alur pengguna untuk seluruh Core User Journeys (Onboarding, Autentikasi, Transaksi Utama, Pengaturan Akun, Error Recovery) - expect setiap alur memiliki titik mulai, langkah aksi, kondisi percabangan (*decision point*), dan kondisi sukses yang tuntas
- [ ] `design/wireframes/low-fidelity.md`: Buat wireframe low-fidelity hitam-putih untuk seluruh layar utama aplikasi - expect validasi penempatan konten struktural disetujui sebelum eksplorasi visual

### 2.2 Prototipe Interaktif Fidelitas Tinggi (High-Fidelity Prototype)
- [ ] `Figma / Stitch Canvas`: Bangun desain antarmuka resolusi tinggi (Hi-Fi) untuk seluruh modul fungsional:
  - Auth: Halaman Login, Register, Lupa Password, Reset Password, 2FA Verification
  - Dashboard: Layout Navbar, Sidebar lipat, Statistik Cards, Grafik Aktivitas, Tabel Data Cepat
  - Modul Utama: Formulir pembuatan entitas baru, Tampilan detail entitas, Mode edit inline/modal
  - Settings: Manajemen profil, Pengaturan tim/role, Riwayat audit, Integrasi API keys
  - expect seluruh aset tipografi, warna, dan komponen menggunakan token resmi dari Modul 04B
- [ ] `Interactive Clickable Prototype`: Hubungkan frame layar menjadi alur prototipe yang dapat diklik (*clickable prototype*) di Figma atau Google Stitch - expect alur end-to-end dapat disimulasikan dari login hingga konfirmasi transaksi akhir

### 2.3 Desain 5 Kondisi UI Wajib (The 5 Essential UI States)
- [ ] `design/screens/states/ideal-state.md`: Rancang tampilan saat halaman terisi data ideal (*Ideal State*) - expect layout proporsional dan harmonis
- [ ] `design/screens/states/empty-state.md`: Rancang tampilan saat belum ada data sama sekali (*Empty State*) - expect visual ilustrasi ramah, teks panduan, dan tombol CTA primer untuk memulai aksi pertama
- [ ] `design/screens/states/loading-state.md`: Rancang tampilan saat data sedang dimuat (*Loading / Skeleton State*) - expect skeleton loader yang mencerminkan siluet konten riil (bukan hanya satu spinner tengah layar yang membosankan)
- [ ] `design/screens/states/error-state.md`: Rancang tampilan saat terjadi kegagalan sistem atau jaringan (*Error State & 404/500 screens*) - expect pesan error humanis tanpa terminologi teknis membingungkan, dilengkapi tombol retry / kembali ke home
- [ ] `design/screens/states/partial-state.md`: Rancang tampilan saat data hanya terisi sebagian atau teks melebihi kapasitas (*Partial / Extreme Overflow State*) - expect penanganan ellipsis (...), text wrapping rapi, dan toleransi avatar tanpa foto profil

### 2.4 Uji Keterpakaian Prototipe (Usability Testing)
- [ ] `design/usability/test-plan.md`: Susun skenario uji keterpakaian dengan 3-5 tugas skenario spesifik untuk pengguna uji - expect tolak ukur keberhasilan terukur (Task Completion Rate, Time on Task)
- [ ] `design/usability/test-execution.md`: Jalankan sesi usability testing kepada minimal 5 partisipan perwakilan pengguna sasaran - expect rekaman catatan observasi friksi, salah klik, dan kebingungan pengguna
- [ ] `design/usability/sus-score.md`: Hitung skor System Usability Scale (SUS) pasca pengujian - expect target skor SUS >= 75 (kategori Good/Excellent)
- [ ] `design/usability/design-refinements.md`: Iterasi dan perbaiki elemen desain prototipe berdasarkan temuan friksi usability testing - expect perubahan tervalidasi sebelum diserahkan ke tim engineering

---

## 3. Modul 05B: Arsitektur Sistem & Infrastruktur (System Design & Infra)

### 3.1 Diagram Arsitektur C4 & Batasan Sistem
- [ ] `docs/02-architecture/c4-context-diagram.md`: Buat Diagram C4 Level 1 (System Context) yang menggambarkan batas sistem aplikasi, aktor pengguna eksternal, dan integrasi sistem pihak ketiga (Payment Gateway, Email Provider, Storage R2/S3, Auth SSO) - expect hubungan interaksi tingkat tinggi terpapar jelas
- [ ] `docs/02-architecture/c4-container-diagram.md`: Buat Diagram C4 Level 2 (Container) yang merinci Frontend SPA/SSR, Backend REST/GraphQL API Gateway, Database PostgreSQL, Redis In-Memory Cache, dan Background Worker queue - expect protokol komunikasi antar container terdefinisi (HTTPS, gRPC, Redis PubSub)
- [ ] `docs/02-architecture/c4-component-diagram.md`: Buat Diagram C4 Level 3 (Component) untuk modul inti sistem (misal: Auth Module, Billing Engine, Document Processor) - expect batasan modul (*bounded context*) terisolasi rapi

### 3.2 Catatan Keputusan Arsitektur (Architecture Decision Records - ADRs)
- [ ] `docs/02-architecture/adrs/ADR-001-database-selection.md`: Keputusan pemilihan engine basis data (misal: PostgreSQL vs MySQL vs MongoDB) dengan analisis konteks, alternatif dipertimbangkan, pro-kontra, dan konsekuensi - expect justifikasi berbasis pola query data dan integritas relasional
- [ ] `docs/02-architecture/adrs/ADR-002-authentication-strategy.md`: Keputusan strategi otentikasi (JWT vs Session-based Cookie HttpOnly vs OIDC/OAuth2) - expect mitigasi celah XSS dan pencurian token dianalisis tuntas
- [ ] `docs/02-architecture/adrs/ADR-003-state-management-and-rendering.md`: Keputusan arsitektur rendering frontend (SSR vs SSG vs SPA CSR) dan manajemen state (Zustand / TanStack Query) - expect pertimbangan SEO, TTFB, dan kompleksitas caching jelas
- [ ] `docs/02-architecture/adrs/ADR-004-background-job-queue.md`: Keputusan penanganan antrean tugas asinkron (BullMQ + Redis vs PG-Boss vs Inngest vs Cloud Tasks) - expect mekanisme retry, dead-letter queue (DLQ), dan konkurensi terdefinisi
- [ ] `docs/02-architecture/adrs/ADR-005-storage-and-cdn.md`: Keputusan penyimpanan objek dan pengiriman aset (Cloudflare R2 + CDN vs AWS S3 + CloudFront) - expect perhitungan biaya egress bandwidth dan strategi presigned URL aman

### 3.3 Perencanaan Kapasitas & Desain Infrastruktur (Capacity & Scalability)
- [ ] `docs/02-architecture/capacity-planning.md`: Hitung perkiraan beban lalu lintas dan penyimpanan data untuk 12 bulan ke depan (RPS puncak, throughput baca/tulis database, pertumbuhan storage GB/bulan) - expect alokasi ukuran compute instance dan database terukur
- [ ] `docs/02-architecture/infrastructure-topology.md`: Susun topologi jaringan cloud (VPC, Public Subnet untuk Load Balancer, Private Subnet untuk DB dan App Cluster, Security Group ingress/egress rules) - expect database tidak memiliki IP publik
- [ ] `docs/02-architecture/disaster-recovery-plan.md`: Dokumentasikan Rencana Pemulihan Bencana (*Disaster Recovery Plan*) dengan penetapan target RPO (*Recovery Point Objective* <= 1 jam) dan RTO (*Recovery Time Objective* <= 4 jam) - expect prosedur backup otomatis dan simulasi failover tertulis

---

## 4. Modul 05: Spesifikasi Kebutuhan Fungsional & Kontrak API (FSD)

### 4.1 Dokumen Spesifikasi Fungsional (FSD Technical)
- [ ] `docs/02-architecture/fsd-technical.md`: Tuliskan detail fungsional modul Autentikasi & Otorisasi (kebijakan password, brute force protection, lockout, role permissions matrix) - expect aturan bisnis keamanan tercakup lengkap
- [ ] `docs/02-architecture/fsd-technical.md`: Tuliskan spesifikasi fungsional untuk setiap fitur inti bisnis (validasi input, alur state machine entitas, kalkulasi matematis, efek samping/side-effects) - expect tidak ada aturan bisnis yang ambigu bagi developer
- [ ] `docs/02-architecture/fsd-technical.md`: Definisikan matriks penanganan error global sistem (struktur JSON response error: `code`, `message`, `details`, status HTTP standar: 400, 401, 403, 404, 422, 429, 500) - expect format error konsisten di seluruh endpoint

### 4.2 Skema Basis Data & Pemodelan Data Relasional (DDL & ERD)
- [ ] `docs/02-architecture/erd-diagram.md`: Buat Entity Relationship Diagram (ERD) lengkap dengan entitas, atribut, primary key, foreign key, dan kardinalitas relasi (1:1, 1:N, N:M) - expect visualisasi relasi data terstruktur normalisasi 3NF
- [ ] `docs/02-architecture/database-schema.sql` (atau `prisma/schema.prisma`): Tuliskan DDL skema database lengkap:
  - Definisi tipe data presisi (UUIDv7/CUID untuk ID, `TIMESTAMPTZ` untuk waktu, `DECIMAL(12,2)` untuk finansial)
  - Pasang constraint `NOT NULL`, `UNIQUE`, `CHECK`, dan `FOREIGN KEY (ON DELETE RESTRICT/CASCADE)`
  - Rancang indeks efisien (B-Tree indexes untuk filtering/sorting, composite index untuk query majemuk, partial index untuk status aktif)
  - Sertakan kolom audit wajib pada setiap tabel: `id`, `created_at`, `updated_at`, `deleted_at` (soft delete jika diperlukan)
  - expect skema bebas dari potensi query table scan penuh pada tabel berukuran besar
- [ ] `docs/02-architecture/data-dictionary.md`: Susun kamus data (*Data Dictionary*) yang menjelaskan fungsi setiap tabel dan setiap kolom dalam bahasa bisnis - expect referensi glosarium data lengkap

### 4.3 Spesifikasi Kontrak API (OpenAPI 3.1 / Swagger Spec)
- [ ] `docs/02-architecture/openapi.yaml`: Susun spesifikasi OpenAPI 3.1 untuk seluruh endpoint RESTful API:
  - Definisikan URL path terstruktur (misal: `/api/v1/auth/login`, `/api/v1/projects`, `/api/v1/projects/{id}/members`)
  - Rinci skema Request Body menggunakan validasi JSON Schema lengkap (field required, format string, min/max length, regex pattern)
  - Rinci skema Response untuk status sukses 200/201 dan skema Response untuk seluruh potensi status error (400, 401, 403, 404, 422, 500)
  - Definisikan skema otentikasi Bearer JWT / Cookie Session pada komponen Security Schemes
  - expect dokumen OpenAPI valid saat divalidasi dengan linter Swagger/Spectral
- [ ] `docs/02-architecture/webhook-contracts.md`: Definisikan spesifikasi webhook masuk (*incoming webhooks* dari Payment Gateway, Email Provider) dan webhook keluar (*outgoing webhooks*): skema payload, algoritma verifikasi signature HMAC-SHA256, dan aturan retry dengan exponential backoff - expect penanganan webhook idempoten

---

## 5. Gerbang Verifikasi Kelolosan Fase Desain (Gate Pass Design to Dev)

| Parameter Evaluasi | Standar Minimum Kelolosan | Status Verifikasi | Catatan Bukti |
| :--- | :--- | :---: | :--- |
| **Design System & A11y** | Token warna/tipografi lengkap, kontras WCAG 2.1 AA lolos, touch target >= 44px | [ ] PASS | Dilampirkan di `design/tokens/` & Figma |
| **Prototipe & 5 States** | Prototipe interaktif tuntas, 5 kondisi UI terdesain di semua layar utama, SUS >= 75 | [ ] PASS | Dilampirkan di Figma link & `design/usability/` |
| **Arsitektur & ADR** | Diagram C4 Level 1-3 tuntas, ADR inti (DB, Auth, Queue, Storage) disetujui | [ ] PASS | Dilampirkan di `docs/02-architecture/adrs/` |
| **FSD & Kontrak OpenAPI** | Skema DDL/ERD valid ternormalisasi, OpenAPI 3.1 lolos linter Spectral | [ ] PASS | Dilampirkan di `docs/02-architecture/openapi.yaml` |
| **Persetujuan Klien / Lead** | Tanda tangan formal Design & Spec Sign-off dari stakeholder bisnis | [ ] PASS | Dilampirkan dokumen persetujuan tertulis |

### Keputusan Gerbang Desain:
- [ ] **LULUS (GO TO DEVELOPMENT - M06)**: Desain UI dan seluruh spesifikasi teknis terkunci rapat. Bebas melangkah ke inisiasi koding dan implementasi repositori di Modul 06.
- [ ] **REVISI TEKNIS (HOLD / ARCHITECTURE REWORK)**: Terdapat ketidakpastian skema basis data atau celah performa arsitektur. Selesaikan revisi sebelum penulisan kode dimulai.
- [ ] **REVISI DESAIN (HOLD / UX REWORK)**: Alur prototipe membingungkan pengguna atau skor SUS < 75. Perbaiki prototipe UI sebelum mengunci kontrak API.
