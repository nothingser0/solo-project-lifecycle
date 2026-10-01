# Panduan UI/UX Solo Developer: Efisiensi, Aksesibilitas, & Pembekuan Desain

Dokumen ini adalah pedoman praktis bagi solo developer dalam merancang antarmuka pengguna yang profesional, ergonomis, dan aksesibel tanpa terjebak dalam perangkap *pixel-pushing* atau revisi visual tanpa batas dari klien.

---

## 1. Workflow `DESIGN.md`: Efisiensi Maksimal Solo Developer

> **Pemberitahuan deprecasi:** Google Stitch deprecated as of 2024; use pure Markdown DESIGN.md workflow instead.

Solo developer dilarang membuang waktu mendesain dua kali (di kanvas vektor lalu koding ulang). Gunakan `DESIGN.md` sebagai sumber kebenaran tunggal untuk keputusan visual pada seluruh skala proyek, dari Kecil hingga Enterprise.

### 1.1 Prosedur Tiga Langkah Menjalankan Workflow `DESIGN.md` Bebas Slop
1. **Langkah 1: Kunci Design System (`DESIGN.md`)**:
    - Isi template `DESIGN.md` terlebih dahulu dengan token warna, tipografi, radius, spacing, state interaktif, dan batasan aksesibilitas.
    - Jadikan dokumen ini acuan bagi desain, implementasi, dan review agar tidak muncul gradien ungu, kartu mengambang, atau font yang tidak sesuai identitas produk.
2. **Langkah 2: Formula Prompting Layar Presisi**:
    - *Pola Prompt*:
      > *"Bangun antarmuka [Nama Layar] untuk pengguna [Role]. Ikuti `DESIGN.md`. Tampilkan layout berbasis Tailwind yang bersih dan flat. Data yang ditampilkan: [Daftar Kolom/Field Riil]. Komponen: gunakan tabel data rapat, badge status warna semantik, dan tombol aksi bergaris batas 1px. Jangan gunakan drop-shadow tebal atau gradien warna."*
3. **Langkah 3: Menghubungkan Layar Menjadi Prototipe Nyata**:
    - Implementasikan komponen sesuai `DESIGN.md`.
    - Hubungkan tautan routing: `<a href="/target-halaman">`.
    - Deploy instan ke Vercel atau Cloudflare Pages sebagai live demo interaktif untuk klien.

### 1.2 Matriks Penerapan `DESIGN.md` Sesuai Skala:
| Skala | Cakupan Layar dengan `DESIGN.md` | Output Demo |
| :--- | :--- | :--- |
| **Kecil (MVP / Freelance)** | **100% seluruh halaman** dalam Scope (tanpa pengurangan) | Tautan Live Staging Vercel instan |
| **Menengah (B2B SaaS)** | **100% seluruh halaman** lengkap dengan varian 5 state | Live Staging Web interaktif penuh |
| **Besar & Enterprise** | **100% seluruh halaman** mencakup seluruh user role & permission | Live Staging Web + Audit Kepatuhan Aksesibilitas WCAG AA |

---

## 2. Prinsip "Anti-Slop" Visual Solo Engineer

Desain perangkat lunak yang matang dicirikan oleh **keterbacaan dan kejelasan interaksi**, bukan ornamen grafis berlebihan:

1. **Aturan 60-30-10 untuk Warna**:
   - **60%**: Warna dasar netral (Putih `#FFFFFF` / Abu-abu terang `#F4F4F5` untuk background dan kontainer).
   - **30%**: Tipografi gelap berdaya kontras tinggi (Hitam `#09090B` / Slate `#334155`).
   - **10%**: Warna aksen utama brand klien (hanya untuk tombol tindakan utama, tautan aktif, dan penanda fokus).
2. **Kepatuhan Kontras Teks (WCAG 2.1 AA)**:
   - Jangan gunakan teks abu-abu pudar di atas background putih yang membuat mata lelah.
   - Rasio kontras teks biasa ke background wajib minimal **4.5 : 1**.
   - Rasio kontras teks besar (heading $> 18\text{px}$ bold) minimal **3.0 : 1**.
3. **Penyelamat Pengalaman: Empty State & Skeleton Loader**:
   - Jangan biarkan layar kosong melompong saat pengguna baru pertama kali mendaftar.
   - Selalu siapkan ilustrasi ringkas, teks panduan, dan tombol Call-to-Action (*"Belum ada dokumen yang dibuat. Klik tombol di bawah untuk membuat dokumen pertama Anda."*).
   - Gantikan spinner bulat berputar dengan *Skeleton Loader* yang menyerupai bentuk kartu/tabel agar layout halaman tidak bergeser (*zero layout shift*).

---

## 3. Protokol Walk-Through Prototipe Bersama Klien

Saat melakukan sesi demo prototipe dengan **Single PIC Klien**, arahkan percakapan pada alur fungsi, bukan debat selera artistik pribadi:

### Taktik Mengarahkan Feedback:
- **Jangan Tanya**: *"Gimana tampilannya, suka nggak dengan warnanya?"* (Pertanyaan ini memicu opini subjektif liar).
- **Pertanyaan yang Benar**:
  - *"Apakah urutan pengisian formulir ini sudah sesuai dengan SOP operasional staf Bapak/Ibu di kantor?"*
  - *"Apakah informasi status dokumen di halaman ini sudah cukup jelas bagi staf untuk mengambil tindakan berikutnya?"*

### Menghadapi Komentar Subjektif Klien:
- **Kasus**: *"Mas, warnanya kurang jreng ya, coba dibuat merah menyala dan logonya diperbesar."*
- **Respon Solo Dev**:
  > *"Warna saat ini dirancang mengikuti panduan identitas resmi perusahaan Bapak/Ibu dan telah lolos uji rasio kontras aksesibilitas standar WCAG 2.1 AA. Hal ini penting agar mata staf tidak cepat lelah saat bekerja berjam-jam di depan layar. Jika ingin warna lebih menonjol, kita bisa terapkan pada tombol aksi utama tanpa mengubah warna dasar halaman."*

---

## 4. Penegakan Protokol Pembekuan Desain (Design Freeze)

Setelah Single PIC Klien menyetujui alur prototipe pada dokumen `DESIGN_SPEC.md`:

1. **Kunci Seluruh Layout**:
   - Status desain resmi dinyatakan **FROZEN**.
   - Halaman Figma atau kode mockup dilabeli sebagai *Approved Baseline*.
2. **Batas Toleransi Perubahan Pasca-Freeze**:
   - *Boleh direvisi gratis*: Perubahan teks label (copywriting), penggantian warna tombol sedikit, atau penukaran ikon kecil.
   - *Wajib masuk Change Request (CR)*: Pemindahan posisi kolom di database yang mengubah struktur form, penambahan halaman baru, perombakan alur multi-step wizard, atau perubahan arsitektur navigasi.
