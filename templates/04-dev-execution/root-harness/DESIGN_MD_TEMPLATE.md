# Design System Specification (Anti-Slop Guardrail for Google Stitch)

> Dokumen acuan sistem desain fondasi untuk diunggah ke Google Stitch (`upload_design_md`). Menjaga konsistensi visual dan mencegah generasi antarmuka generik ("AI Slop").

---

## 1. Filosofi Desain & Arahan Anti-Slop (Core Directives)

1. **Flat & Structured First**:
   - DILARANG menggunakan efek bayangan tebal (*thick/colored drop-shadows*) atau kartu-kartu mengambang (*floating cards*).
   - Gunakan garis pembatas flat 1px netral (`border border-zinc-200 dark:border-zinc-800`) untuk memisahkan kontainer data.
2. **Monokromatik Netral + Satu Warna Aksen**:
   - DILARANG menggunakan gradien warna neon atau ungu acak khas AI.
   - 90% komponen menggunakan palet abu-abu netral (Zinc). Hanya gunakan **1 warna aksen utama brand** untuk tombol Call-to-Action (CTA) dan link aktif.
3. **Data Riil & Kepadatan Informasi (Data-Dense)**:
   - DILARANG menggunakan teks latin palsu (*Lorem Ipsum*).
   - Seluruh teks wajib menggunakan terminologi bisnis/hukum riil sesuai konteks aplikasi (format Rupiah `Rp`, tanggal lokal, nama instansi nyata).
4. **Kepatuhan Aksesibilitas Mutlak (WCAG 2.1 AA)**:
   - Rasio kontras teks terhadap warna latar belakang wajib minimal **4.5 : 1**.

---

## 2. Palet Warna & Token Semantik (Color Tokens)

### 2.1 Mode Terang (Light Mode - Standar)
- **Background Utama**: `#FFFFFF`
- **Surface / Card Background**: `#F4F4F5` (Zinc-100)
- **Border**: `#E4E4E7` (Zinc-200)
- **Text Primary (Judul & Isi)**: `#09090B` (Zinc-950) — *Rasio kontras: 19.8 : 1 (Lolos AAA)*
- **Text Muted (Placeholder & Helper)**: `#71717A` (Zinc-500) — *Rasio kontras: 4.6 : 1 (Lolos AA)*

### 2.2 Mode Gelap (Dark Mode - Opsional)
- **Background Utama**: `#09090B` (Zinc-950)
- **Surface / Card Background**: `#18181B` (Zinc-900)
- **Border**: `#27272A` (Zinc-800)
- **Text Primary**: `#FAFAFA` (Zinc-50)
- **Text Muted**: `#A1A1AA` (Zinc-400)

### 2.3 Warna Aksen & Semantik Fungsional
- **Brand Primary Accent**: `#[HEX_BRAND]` (Contoh Slate Navy: `#0F172A` atau Emerald: `#059669`)
- **Status Success**: `#16A34A` (Green-600)
- **Status Warning**: `#D97706` (Amber-600)
- **Status Destructive / Error**: `#DC2626` (Red-600)

---

## 3. Sistem Tipografi (Typography)

- **Font Utama UI (Sans-Serif)**: `Inter`, `Geist Sans`, atau `system-ui, -apple-system, sans-serif`
- **Font Kode / Angka / Hash (Monospace)**: `JetBrains Mono`, `Geist Mono`, atau `monospace`
- **Hierarki Skala Teks**:
  - `h1`: 30px / font-bold / tracking-tight
  - `h2`: 24px / font-semibold / tracking-tight
  - `h3`: 18px / font-medium
  - `body`: 14px / font-normal / leading-relaxed
  - `small / caption`: 12px / font-normal / text-muted

---

## 4. Bentuk Komponen & Spacing (Geometry & Shapes)

- **Radius Sudut (Corner Roundness)**:
  - Tombol & Input Field: `6px` (`rounded-md`)
  - Kartu & Dialog Modal: `8px` (`rounded-lg`)
  - Badge Status: `9999px` (`rounded-full`)
- **Grid & Spacing**:
  - Berbasis kelipatan **4px / 8-point grid** (`p-2`, `p-4`, `p-6`, `gap-4`, `gap-6`).
  - Target sentuh mobile (*Touch target*): Minimal `44px x 44px`.

---

## 5. Standar Formulir & Tabel

- **Input Form**: Wajib memiliki label teks eksplisit di atas kolom, placeholder abu-abu netral, dan area pesan validasi merah di bawah kolom.
- **Tabel Data**: Garis batas horizontal tipis per baris (`divide-y divide-zinc-200`), padding sel rapat (`py-3 px-4`), dan baris header berwarna abu-abu sangat muda (`bg-zinc-50`).
- **Kondisi Kosong (Empty State)**: Kotak bergaris putus-putus (`border-dashed border-2 border-zinc-300`), teks penjelas alasan kosong, dan tombol CTA utama untuk membuat data baru.
