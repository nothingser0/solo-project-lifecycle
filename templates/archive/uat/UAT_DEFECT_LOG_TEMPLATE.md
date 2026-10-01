# Log Pelacakan Kendala UAT (UAT Defect Log)

> Lembar kerja resmi untuk mencatat, mengklasifikasikan, dan melacak resolusi seluruh kendala (*bugs/issues*) yang ditemukan selama periode pengujian penerimaan pengguna.

---

## 1. Metadata Pengujian
- **Nama Sistem**: [Nama Aplikasi]
- **Periode Pelaporan**: [Tanggal Mulai] s/d [Tanggal Selesai]
- **Single PIC Penguji**: [Nama PIC Klien]
- **Lead Developer**: [Nama Anda]

---

## 2. Tabel Pelacakan Cacat / Bug (Defect Tracking Table)

| ID Bug | Tanggal Lapor | Modul / Halaman | Deskripsi Masalah & Langkah Reproduksi | Severity (1/2/3/CR) | Status Penanganan | Tanggal Resolusi | Verifikasi Ulang Klien |
| :---: | :---: | :--- | :--- | :---: | :---: | :---: | :---: |
| **BUG-01** | [YYYY-MM-DD] | Form Dokumen | Tanggal lahir tidak bisa dipilih jika sebelum tahun 1980 | **Severity 2** | `CLOSED` | [YYYY-MM-DD] | [x] Terverifikasi Lolos |
| **BUG-02** | [YYYY-MM-DD] | E-Sign Canvas | Tombol clear canvas tidak mereset goresan tanda tangan | **Severity 3** | `CLOSED` | [YYYY-MM-DD] | [x] Terverifikasi Lolos |
| **CR-01**  | [YYYY-MM-DD] | Notifikasi | Klien meminta integrasi notifikasi SMS selain email | **Out-of-Scope** | `DIALIHKAN KE CR` | - | Masuk Lembar CR #02 |

---

## 3. Definisi Status Penanganan
- **`OPEN`**: Masalah baru dilaporkan oleh tester klien dan sedang dalam antrean triase.
- **`IN_PROGRESS`**: Masalah valid sedang diperbaiki oleh developer di branch `fix/*`.
- **`RESOLVED`**: Perbaikan telah di-deploy ke server Staging dan siap diuji ulang oleh klien.
- **`CLOSED`**: PIC Klien telah menguji ulang di Staging dan mengonfirmasi bug telah tuntas.
- **`DIALIHKAN KE CR`**: Permintaan di luar lingkup PRD/FSD yang dialihkan ke penawaran *Change Request* berbayar.

---

## 4. Rekapitulasi Status Akhir Triase

- **Total Temuan Dilaporkan**: [ ] Temuan
- **Severity 1 (Blocker)**: [0] Open  *(Wajib 0 untuk UAT Sign-Off)*
- **Severity 2 (Major)**: [0] Open  *(Wajib 0 untuk UAT Sign-Off)*
- **Severity 3 (Minor)**: [ ] Resolved / Dijadwalkan saat garansi
- **Permintaan Fitur Baru (CR)**: [ ] Dialihkan ke Fase Lanjutan / Dokumen CR
