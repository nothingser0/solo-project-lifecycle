# CONTEXT.md

> Konteks bisnis, batasan lingkup, dan domain model proyek untuk memandu pemahaman AI coding agents.

---

## 1. Ringkasan Produk & Masalah Bisnis
- **Nama Produk**: [Nama Aplikasi]
- **Masalah Utama**: [Penjelasan singkat masalah yang dihadapi pengguna]
- **Solusi Inti**: [Bagaimana aplikasi ini menyelesaikan masalah tersebut]

---

## 2. Alur Pengguna Inti (Core User Loop)
1. **Langkah 1 (Input)**: [Contoh: Staf login, memilih template, dan mengisi variabel form]
2. **Langkah 2 (Proses)**: [Contoh: Sistem merender PDF, mengenkripsi ke vault, dan menerbitkan link tanda tangan]
3. **Langkah 3 (Output)**: [Contoh: Pihak penandatangan membubuhkan tanda tangan digital, dokumen berstatus LOCKED]

---

## 3. Matriks Peran Pengguna (User Roles & RBAC)

| Peran (Role) | Hak Akses | Batasan Tindakan |
| :--- | :--- | :--- |
| **Super Admin** | Akses penuh seluruh data, audit trail, user management | Dilarang mengubah dokumen yang sudah berstatus `SIGNED` |
| **Manager** | Menyetujui draf dokumen, mengirim permintaan e-sign | Hanya melihat data dalam divisinya |
| **Staf** | Mengisi form input draf dokumen baru | Tidak bisa menyetujui atau menerbitkan dokumen final |
| **Signer (Tamu)** | Akses satu kali via token rahasia untuk tanda tangan | Tidak memiliki akun login sistem |

---

## 4. Batasan Lingkup Mutlak (Scope Boundaries)

### Wajib Dibuat (In-Scope)
- [Daftar fitur sesuai SCOPE_STATEMENT.md]

### DILARANG Dibuat (Out-of-Scope - Jangan Halusinasi)
- AI agen DILARANG menambahkan fitur di luar daftar berikut tanpa perintah eksplisit:
  1. Dilarang membuat sistem e-commerce/keranjang belanja jika tidak diminta.
  2. Dilarang membuat AI chatbot rekomendasi atau fitur analitik kompleks.
  3. Dilarang menambah multi-bahasa selain Bahasa Indonesia.
  4. Dilarang membuat sistem pembayaran manual di luar payment gateway yang disepakati.

---

## 5. Istilah Domain (Glossary)
- **Document Vault**: Penyimpanan cloud terisolasi di mana file PDF dienkripsi menggunakan AES-256-GCM.
- **Audit Trail**: Catatan rekaman permanen berisi timestamp UTC, alamat IP, dan nilai SHA-256 dokumen.
- **Signer Token**: Token hash unik sekali pakai dengan masa kedaluwarsa 7 hari untuk penandatangan.
