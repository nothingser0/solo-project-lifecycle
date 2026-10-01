# Local Development Runbook

> Panduan praktis untuk mengkloning, mengonfigurasi, dan menjalankan aplikasi secara lokal di komputer pengembang atau mesin verifikasi.

---

## 1. Prasyarat Sistem
Pastikan lingkungan lokal Anda telah terpasang:
- **Node.js**: Versi `v20.x` LTS atau lebih baru (`node -v`)
- **Package Manager**: `pnpm` atau `npm` (`pnpm -v` atau `npm -v`)
- **Basis Data**: PostgreSQL v15+ (Lokal atau melalui Docker)
- **Git**: Versi 2.30+ (`git -v`)

---

## 2. Variabel Lingkungan (.env Setup)

Salin berkas konfigurasi template ke `.env`:
```bash
cp .env.example .env
```

### Kamus Variabel Lingkungan Wajib:
| Nama Variabel | Contoh Nilai | Keterangan |
| :--- | :--- | :--- |
| `DATABASE_URL` | `postgresql://postgres:password@localhost:5432/legal_vault?schema=public` | Koneksi basis data PostgreSQL |
| `JWT_SECRET` | `generate-random-secret-key-min-32-chars` | Kunci penandatangan token otentikasi sesi |
| `VAULT_MASTER_KEY` | `32-byte-hex-string-for-aes-256-gcm-encryption` | Kunci enkripsi file PDF di Document Vault |
| `STORAGE_BUCKET_NAME`| `legal-document-vault-dev` | Nama bucket S3 / Cloudflare R2 |
| `STORAGE_ACCESS_KEY` | `your-r2-or-s3-access-key` | Kredensial akses cloud storage |
| `STORAGE_SECRET_KEY` | `your-r2-or-s3-secret-key` | Kredensial rahasia cloud storage |
| `STORAGE_ENDPOINT`   | `https://<account-id>.r2.cloudflarestorage.com` | Endpoint API S3-compatible |

---

## 3. Langkah Instalasi & Migrasi Database

```bash
# 1. Kloning repositori
git clone <URL_REPO>
cd <FOLDER_PROYEK>

# 2. Instal seluruh dependensi
npm install # atau pnpm install

# 3. Jalankan migrasi basis data (SQL DDL)
npm run db:migrate # atau npx prisma migrate dev / npx drizzle-kit push

# 4. Masukkan data awal pengujian (Data Seeding)
npm run db:seed
```

---

## 4. Menjalankan Aplikasi

```bash
# Jalankan server pengembangan lokal
npm run dev
```

Aplikasi web dapat dibuka melalui browser pada alamat:
`http://localhost:3000`

---

## 5. Kredensial Akun Default Pengujian (Seeded Accounts)

| Peran | Alamat Email | Kata Sandi Bawaan | Akses Khusus |
| :--- | :--- | :--- | :--- |
| **Super Admin** | `admin@perusahaan.local` | `Admin12345!` | Akses seluruh modul & audit trail |
| **Manager** | `manager@perusahaan.local` | `Manager12345!` | Persetujuan draf & kirim e-sign |
| **Staf** | `staf@perusahaan.local` | `Staf12345!` | Pengisian form template dokumen |

---

## 6. Pengujian Asersi Mandiri (Local Smoke Test)

Jalankan skrip uji cepat untuk memvalidasi alur dari registrasi, generate PDF terenkripsi, hingga tanda tangan:

```bash
npm run test:smoke
```

*Jika seluruh asersi menampilkan status `PASS`, aplikasi siap di-deploy ke lingkungan Staging.*
