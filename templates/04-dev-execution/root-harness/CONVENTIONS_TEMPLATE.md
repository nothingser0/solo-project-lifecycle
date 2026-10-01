# CONVENTIONS.md

> Standar gaya penulisan kode, arsitektur komponen, dan konvensi teknis untuk AI coding agents guna mencegah kode semrawut (*AI slop code*).

---

## 1. Aturan Penamaan Berkas & Struktur (File Naming)

1. **Format Penamaan Berkas**:
   - Seluruh nama file wajib menggunakan format **`kebab-case`**:
     - Benar: `document-form.tsx`, `auth-middleware.ts`, `use-vault-storage.ts`
     - Salah: `DocumentForm.tsx`, `authMiddleware.ts`, `use_vault.ts`
2. **Haram Barrel Files (`index.ts`)**:
   - DILARANG membuat file `index.ts` yang mengekspor ulang seluruh file di dalam folder (*re-export barrel*).
   - Selalu impor modul langsung dari file spesifiknya untuk menjaga performa *tree-shaking* dan mencegah ketergantungan melingkar (*circular dependencies*).

---

## 2. Standar React & Next.js App Router

1. **Server Components Sebagai Standar Utama**:
   - Semua halaman dan komponen di `src/app/` secara default adalah **React Server Components (RSC)**.
   - DILARANG menaruh direktif `'use client'` di tingkat atas halaman.
2. **Isolasi `'use client'` di Komponen Daun (Leaf Components)**:
   - Gunakan `'use client'` hanya pada komponen terkecil yang benar-benar membutuhkan interaksi browser (hook `useState`, `useEffect`, atau event `onClick`), seperti tombol interaktif atau canvas tanda tangan.
3. **Penyimpanan State yang Disiplin**:
   - Gunakan *Discriminated Union* untuk mengelola status mutasi/data:
     ```typescript
     type RequestState<T> =
       | { status: "idle" }
       | { status: "loading" }
       | { status: "error"; message: string }
       | { status: "success"; data: T };
     ```

---

## 3. Disiplin TypeScript & Penanganan Tipe Data

1. **Zero `any` Policy**:
   - DILARANG menggunakan tipe `any`. Gunakan `unknown` jika tipe data belum dapat dipastikan, lalu persempit menggunakan *Type Guards* atau validasi Zod.
2. **Tipe Data Bersumber Tunggal dari Zod**:
   - Dilarang menuliskan antarmuka TypeScript dan skema Zod secara terpisah jika isinya sama. Selalu turunkan tipe dari skema Zod:
     ```typescript
     export const UserSchema = z.object({ id: z.string().uuid(), email: z.string().email() });
     export type User = z.infer<typeof UserSchema>;
     ```

---

## 4. Struktur Kode & Penanganan Galat (Clean Code & Error Handling)

1. **Pola Early Returns (Guard Clauses)**:
   - Tangani kondisi error dan validasi gagal di baris awal fungsi. Hindari percabangan `if-else` bertingkat yang dalam (*arrow anti-pattern*).
2. **Dilarang Menelan Error (No Empty Catch)**:
   - DILARANG menulis blok catch kosong: `catch (e) {}`. Seluruh galat wajib dicatat menggunakan logger terstruktur atau diteruskan dengan pesan yang bermakna.
3. **Konstanta Terpusat**:
   - Angka ajaib (*magic numbers*) atau string status transaksi wajib disimpan sebagai konstanta bertipe (*const assertions* atau TypeScript enum).
