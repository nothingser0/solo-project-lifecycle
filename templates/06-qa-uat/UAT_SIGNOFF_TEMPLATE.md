# Berita Acara Uji Terima Pengguna (UAT Sign-Off Report)

> Dokumen pengesahan hukum hasil pengujian penerimaan pengguna (*User Acceptance Test*) yang menyatakan bahwa perangkat lunak telah memenuhi seluruh kriteria spesifikasi PRD/FSD dan disetujui untuk rilis ke lingkungan Produksi.

---

## 1. Metadata Pengesahan
- **Nama Sistem**: [Nama Aplikasi]
- **Pihak Klien**: [Nama Perusahaan Klien]
- **Single PIC Klien**: [Nama Lengkap PIC Klien]
- **Lead Developer**: [Nama Anda]
- **Lingkungan Pengujian**: Server Staging (`https://staging.domainklien.com`)
- **Versi Build Teruji**: `v0.9.5-rc` (Commit: `[git-hash]`)
- **Tanggal Penandatanganan**: [YYYY-MM-DD]

---

## 2. Hasil Rekapitulasi Pengujian UAT

Berdasarkan lembar kerja **`UAT_SCENARIOS.md`** dan **`UAT_DEFECT_LOG.md`**, para pihak mencatat hasil pengujian sebagai berikut:

| Kategori Modul | Total Skenario Diuji | Lolos (Pass) | Catatan / Resolusi |
| :--- | :---: | :---: | :--- |
| **Modul Otentikasi & Akun** | [ ] Skenario | [ ] Pass | Seluruh alur login & hak akses RBAC tervalidasi |
| **Modul Pembuatan Dokumen** | [ ] Skenario | [ ] Pass | Seluruh template form & render PDF tervalidasi |
| **Modul Document Vault & S3** | [ ] Skenario | [ ] Pass | Enkripsi file dan presigned URL tervalidasi |
| **Modul Tanda Tangan Digital**| [ ] Skenario | [ ] Pass | Alur penandatanganan dan cap hash tervalidasi |
| **STATUS SEVERITY 1 & 2** | **0 Terbuka** | **LULUS** | Seluruh cacat kritis dan mayor telah diperbaiki |

---

## 3. Pernyataan Persetujuan & Otorisasi Rilis (Acceptance Declaration)

Dengan menandatangani Berita Acara ini, **PIHAK KLIEN** menyatakan dan menyepakati bahwa:

1. **Penerimaan Spesifikasi**: Sistem perangkat lunak yang diuji di server Staging telah berfungsi secara memuaskan dan memenuhi seluruh kriteria kebutuhan yang tercantum dalam dokumen **PRD.md** dan **FSD.md**.
2. **Izin Rilis Produksi**: Pihak Klien secara resmi mengizinkan Developer untuk melakukan penggabungan kode (*merge*) ke branch `main` dan melakukan proses peluncuran ke lingkungan **Produksi (Modul 10: Production Go-Live)**.
3. **Kunci Lingkup**: Seluruh permintaan perubahan alur, tata letak, atau penambahan fitur baru setelah tanggal penandatanganan ini tidak dapat menunda proses peluncuran dan akan diproses melalui skema **Change Request (CR)** berbayar atau perjanjian kerja lanjutan.

---

## 4. Pengesahan Para Pihak

Berita Acara ini dibuat dalam rangkap 2 (dua) yang masing-masing memiliki kekuatan hukum yang sama bagi Klien dan Developer.

| Disetujui oleh Single PIC Klien | Divalidasi oleh Lead Software Engineer |
| :--- | :--- |
| **Nama**: _________________________ | **Nama**: _________________________ |
| **Jabatan**: [Product Owner / Manajer IT] | **Jabatan**: Independent Lead Software Engineer |
| **Perusahaan**: [Nama Perusahaan Klien] | **Tanggal**: ______________________ |
| **Tanggal**: ______________________ | **Tanda Tangan**: |
| **Tanda Tangan**: | |
