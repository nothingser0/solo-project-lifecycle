# Local Verification & Smoke Test Checklist

> Lembar verifikasi mandiri sebelum solo developer mempublikasikan kode ke repositori staging atau mengajukan milestone rilis.

---

## 1. Metadata Verifikasi
- **Nama Proyek**: [Nama Aplikasi]
- **Commit SHA Terakhir**: `[git rev-parse --short HEAD]`
- **Penguji / Solo Engineer**: [Nama Anda]
- **Tanggal Verifikasi**: [YYYY-MM-DD]
- **Target Status**: [Ready for Staging QA / Incomplete]

---

## 2. Pemeriksaan Kompilasi & Linter (Build Sanity)

| Perintah Uji | Kriteria Sukses | Hasil Uji Mandiri | Catatan |
| :--- | :--- | :---: | :--- |
| `npm run type-check` | TypeScript compile tanpa error (`exit 0`) | [x] PASS | Bebas error tipe data |
| `npm run lint` | Linter bersih tanpa peringatan kritis | [x] PASS | Kode mengikuti aturan style |
| `npm run build` | Bundle frontend & backend berhasil dibuat | [x] PASS | Output siap rilis |

---

## 3. Verifikasi Matriks Endpoint API (Sesuai FSD)

| Endpoint | Metode | Skenario Uji | Status Kode Diharapkan | Hasil Uji |
| :--- | :---: | :--- | :---: | :---: |
| `/api/v1/auth/login` | `POST` | Kredensial benar $\to$ Cookie HttpOnly terpasang | `200 OK` | PASS |
| `/api/v1/auth/login` | `POST` | Password salah $\to$ Pesan error spesifik | `401 Unauthorized` | PASS |
| `/api/v1/documents` | `POST` | Payload valid + Idempotency key baru | `201 Created` | PASS |
| `/api/v1/documents` | `POST` | Idempotency key sama dikirim ulang $\to$ Ditolak | `409 Conflict` | PASS |
| `/api/v1/documents/:id` | `GET` | Ambil data dokumen $\to$ Presigned URL terbit | `200 OK` | PASS |
| `/api/v1/sign/:token` | `POST` | Tanda tangan digital $\to$ Status berubah `SIGNED` | `200 OK` | PASS |

---

## 4. Verifikasi Antarmuka Layar (Sesuai Google Stitch & 5 States)

| Nama Halaman | Default State | Skeleton Loader | Empty State | Inline Error | Success Toast |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Dashboard** | [x] PASS | [x] PASS | [x] PASS | [x] PASS | [x] PASS |
| **Form Dokumen** | [x] PASS | [x] PASS | N/A | [x] PASS | [x] PASS |
| **Layar E-Sign** | [x] PASS | [x] PASS | N/A | [x] PASS | [x] PASS |

---

## 5. Verifikasi Keamanan Kritis (Security Sanity)

- [x] **Enkripsi Vault**: Berkas PDF di bucket Cloudflare R2 / AWS S3 terbukti terenkripsi biner (tidak bisa dibuka langsung tanpa kunci enkripsi).
- [x] **Presigned URL**: Tautan unduhan kedaluwarsa otomatis dan menghasilkan `403 Forbidden` setelah 15 menit.
- [x] **Password Protection**: Kolom `password_hash` di database PostgreSQL terkonfirmasi berawalan `$argon2id$` (bukan teks polos).
- [x] **Rate Limiting**: Endpoint login diblokir sementara setelah 5 kali percobaan salah berturut-turut.

---

## 6. Keputusan Akhir Verifikasi Lokal

- [x] **LOLOS LOKAL (PASS)**: Seluruh checklist di atas terpenuhi. Kode siap di-push ke branch `staging` untuk pengujian integrasi **Modul 07: QA & SIT**.
- [ ] **GAGAL (FAIL)**: Ditemukan bug kritis atau kegagalan kompilasi. Perbaiki sebelum push.
