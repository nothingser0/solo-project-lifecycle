# Rencana Pemulihan Darurat (Rollback & Break-Glass Plan)

> Prosedur darurat untuk membatalkan proses rilis dan mengembalikan sistem ke kondisi stabil sebelumnya dalam kurun waktu kurang dari 15 menit jika terjadi kegagalan fatal saat go-live.

---

## 1. Pemicu Keputusan Pembatalan (Rollback Triggers)

Prosedur Rollback **WAJIB DIEKSEKUSI SEGERA** jika setelah rilis ditemukan salah satu kondisi berikut:
1. Skrip migrasi basis data gagal di tengah jalan dan menyebabkan korupsi data.
2. Tingkat kegagalan request (*Error Rate 500*) $> 5\%$ dalam 15 menit pertama.
3. Rata-rata waktu respon sistem (*Latency p95*) melonjak melebihi $2.000\text{ ms}$ (2 detik).
4. Alur transaksi inti (pembayaran atau enkripsi dokumen) mengalami kegagalan total.

---

## 2. Urutan Tindakan Pemulihan Cepat (The 15-Minute Rollback)

### Langkah 1: Pengalihan Kode Aplikasi ke Versi Stabil Sebelumnya
Jika menggunakan Vercel / Railway / Cloud Run:
- Buka dashboard cloud hosting $\to$ Pilih deployment versi stabil sebelumnya $\to$ Klik **"Rollback / Promote to Production"** (Waktu eksekusi: $< 1\text{ menit}$).

Jika menggunakan Git & Docker manual:
```bash
# Checkout ke versi tag sebelumnya (misal v0.9.5)
git checkout v0.9.5
docker build -t app:v0.9.5 .
docker stop app-current && docker rm app-current
docker run -d --name app-current -p 3000:3000 app:v0.9.5
```

### Langkah 2: Pemulihan Basis Data (Database Restore)
Jika skema basis data rusak akibat migrasi gagal:
```bash
# Hentikan akses database sementara
# Restore data dari snapshot backup yang diambil sebelum deploy:
pg_restore -U postgres -d legal_vault_prod -c "backup-pre-deploy-[TANGGAL].dump"
```

### Langkah 3: Verifikasi Sistem Pascamundur
- Buka `https://app.klien.com/api/health` $\to$ Pastikan respon `200 OK`.
- Verifikasi user dapat login kembali menggunakan versi stabil sebelumnya.

---

## 3. Template Komunikasi Darurat ke Single PIC Klien

Jika prosedur rollback terpaksa dieksekusi:

> *"Selamat siang Pak/Bu [Nama PIC], menginformasikan bahwa pada proses peluncuran sistem pukul [Jam], kami mendeteksi anomali pada integrasi [sebutkan kendala, misal: sinkronisasi database] yang menyebabkan latensi melebihi batas toleransi.*
>
> *Demi menjaga keamanan data dan kenyamanan operasional perusahaan Bapak/Ibu, sesuai SOP kami telah mengaktifkan prosedur rollback ke versi stabil sebelumnya. Sistem saat ini telah kembali normal dan aman digunakan. Kami sedang menganalisis akar masalah dan akan menjadwalkan ulang peluncuran setelah perbaikan selesai tuntas."*
