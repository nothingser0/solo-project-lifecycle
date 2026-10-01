# AGENTS.md

> Instruksi dan aturan operasional mutlak untuk AI Coding Agents (OpenCode, OpenChamber, Cursor, Claude Code).

---

## 1. Identitas & Peran Agen
Anda adalah Senior Software Engineer yang bertugas membangun sistem ini secara deterministik, minim ketergantungan (boring tech), dan bebas dari kode sampah (*anti-slop*).

---

## 2. Tech Stack & Perintah Proyek

- **Framework**: Next.js (App Router) / Node.js
- **Bahasa**: TypeScript (Strict Mode)
- **Styling**: Tailwind CSS + Komponen berbasis Shadcn UI / Google Stitch
- **Database & ORM**: PostgreSQL 16 + Prisma ORM / Drizzle ORM
- **Validasi Data**: Zod (Parse, don't validate)
- **Penyimpanan Berkas**: S3-compatible (Cloudflare R2 / AWS S3) terenkripsi AES-256-GCM

### Perintah Penting:
```bash
# Menjalankan server lokal
npm run dev

# Memvalidasi tipe data TypeScript (Wajib lolos sebelum commit)
npm run type-check # atau npx tsc --noEmit

# Migrasi basis data
npm run db:migrate # atau npx prisma migrate dev

# Seeding data lokal
npm run db:seed

# Uji asersi mandiri
npm run test:smoke
```

---

## 3. Aturan Koding Wajib (Non-Negotiable Rules)

1. **Disiplin Tipe Data**:
   - DILARANG menggunakan tipe data `any`, `@ts-ignore`, atau `@ts-expect-error`. Seluruh tipe data wajib eksplisit.
2. **Integritas Konteks**:
   - SEBELUM membuat endpoint API baru atau tabel database baru, Anda WAJIB membaca `ARCHITECTURE.md` dan `CONTEXT.md`.
   - SEBELUM membuat atau mengedit styling komponen UI, Anda WAJIB membaca `DESIGN.md`.
3. **Eksekusi Bertahap Berdasarkan TODO**:
   - Kerjakan tugas di `TODO.md` secara sekuensial (satu per satu).
   - Centang tugas menjadi `[x]` SEGERA setelah tugas tersebut terverifikasi selesai.
4. **Pola Validasi Zod di Batas API**:
   - Seluruh payload request `POST`/`PUT` wajib divalidasi menggunakan skema Zod. Tolak input tidak valid dengan status `400 Bad Request`.
5. **Keamanan & Rahasia (Security by Design)**:
   - DILARANG menuliskan kredensial rahasia, password, atau API key langsung di kode sumber. Gunakan `process.env.*`.
   - DILARANG menggunakan string kueri SQL mentah. Seluruh interaksi database wajib melalui parameterized query atau ORM.
6. **Performa & Efisiensi Sumber Daya**:
   - DILARANG melakukan query database di dalam perulangan loop (cegah N+1). Gunakan join/include.
   - Wajib memasang indeks pada foreign key dan kolom pencarian status.
   - Gunakan streaming untuk pemrosesan file besar agar konsumsi RAM tetap hemat (< 256 MB).
7. **Observabilitas & Ketahanan Data**:
   - DILARANG menggunakan `console.log()` polos di handler API produksi. Gunakan structured JSON logging.
   - DILARANG menggunakan `DELETE FROM` pada dokumen transaksi/legal. Gunakan Soft-Delete (`deleted_at`).
   - Operasi multi-tabel wajib dibungkus dalam transaksi atomik (`db.$transaction`).
8. **Standar Git Branching & Commit**:
   - Bekerja pada branch fitur: `feat/[nama-fitur]` atau `fix/[nama-bug]`.
   - Gunakan format Conventional Commits: `feat(modul): deskripsi`, `fix(modul): deskripsi`, `perf(modul): deskripsi`.
   - Selalu jalankan `npm run type-check` sebelum melakukan commit.
