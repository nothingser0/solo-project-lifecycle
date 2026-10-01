# TODO.md

> Daftar tugas atomik untuk eksekusi koding mandiri oleh AI coding agents (OpenCode / OpenChamber).
> Aturan: Kerjakan satu per satu secara sekuensial. Centang `[x]` setelah tugas selesai dan terverifikasi.

---

## Fase 1: Inisiasi Repositori & Tooling Dasar
- [ ] `package.json`: Inisiasi dependensi inti (Next.js, React, TypeScript, Tailwind, Zod, Prisma) - expect build lokal berhasil
- [ ] `tsconfig.json`: Aktifkan TypeScript strict mode tanpa toleransi tipe any - expect tsc --noEmit lolos
- [ ] `.env.example`: Buat template variabel lingkungan (DATABASE_URL, JWT_SECRET, S3/R2 keys) - expect kamus env lengkap
- [ ] `src/lib/env.ts`: Buat parser variabel lingkungan menggunakan Zod - expect crash instan saat env wajib hilang

## Fase 2: Skema Basis Data & Migrasi
- [ ] `prisma/schema.prisma`: Definisikan model users, documents, dan signatures sesuai DDL FSD - expect skema valid
- [ ] `migrations/`: Jalankan migrasi basis data pertama ke PostgreSQL lokal - expect tabel terbuat di database
- [ ] `prisma/seed.ts`: Buat skrip data seed awal (akun super admin dan template dokumen) - expect seed berhasil di-load

## Fase 3: Pemasangan Komponen Antarmuka dari Google Stitch
- [ ] `src/components/ui/`: Salin komponen primitif (Button, Input, Table, Badge) dari output Stitch - expect komponen bersih
- [ ] `src/app/(auth)/login/page.tsx`: Pasang layout halaman login dari Stitch - expect form login terender rapi
- [ ] `src/app/(dashboard)/page.tsx`: Pasang layout dashboard dari Stitch - expect widget statistik & tabel terender
- [ ] `src/app/(dashboard)/documents/new/page.tsx`: Pasang form dinamis dokumen dari Stitch - expect form input terender

## Fase 4: Endpoint API & Layanan Backend
- [ ] `src/lib/crypto.ts`: Buat fungsi enkripsi streaming AES-256-GCM dan hashing SHA-256 - expect enkripsi & dekripsi lolos
- [ ] `src/lib/storage.ts`: Buat klien storage Cloudflare R2 / S3 dan generator presigned URL - expect upload file sukses
- [ ] `src/app/api/v1/auth/login/route.ts`: Buat handler login ber-Zod dan pasang cookie HttpOnly - expect login 200 OK
- [ ] `src/app/api/v1/documents/route.ts`: Buat handler POST pembuatan draf dokumen baru - expect 201 Created
- [ ] `src/app/api/v1/documents/[id]/route.ts`: Buat handler GET detail dokumen dan presigned URL - expect 200 OK
- [ ] `src/app/api/v1/sign/[token]/route.ts`: Buat handler transaksi tanda tangan dengan pessimistic lock - expect 200 OK

## Fase 5: Integrasi Antarmuka UI ke Backend API (Wiring)
- [ ] `src/components/modules/LoginForm.tsx`: Hubungkan submit form login ke /api/v1/auth/login - expect redirect ke dashboard
- [ ] `src/components/modules/DocumentForm.tsx`: Hubungkan submit form dokumen ke POST /api/v1/documents - expect draf tersimpan
- [ ] `src/components/modules/SignCanvas.tsx`: Hubungkan canvas e-sign ke POST /api/v1/sign/[token] - expect status SIGNED
- [ ] `5-State Review`: Verifikasi tampilan loading skeleton, empty state, dan inline error di semua halaman - expect UI defensif

## Fase 6: Uji Asersi Mandiri (Local Smoke Test)
- [ ] `scripts/smoke-test.ts`: Tulis skrip asersi alur lengkap dari login hingga verifikasi hash dokumen - expect 100% PASS
- [ ] `VERIFY_LOCAL.md`: Isi lembar bukti verifikasi mandiri sebelum rilis ke Staging - expect keputusan PASS
