# Email Templates Library

Koleksi template email untuk onboarding, transactional, dan re-engagement. Semua template menggunakan format plain text dan HTML responsive (mobile-first).

---

## 1. Onboarding Drip Campaign

### Email 1: Welcome Email (Day 0 — Sent Immediately After Signup)

**Subject:** `Selamat datang di [Product Name]! 🎉`

**Plain Text:**
```
Halo [First Name],

Selamat datang di [Product Name]!

Kami senang Anda bergabung. Berikut langkah pertama untuk memulai:

1. [Primary CTA Action] — [Link]
   Contoh: Lengkapi profil Anda — https://app.example.com/onboarding

2. [Secondary Benefit]
   Contoh: Akses tutorial video 5 menit di dashboard Anda

Butuh bantuan? Balas email ini atau hubungi support@example.com

Salam,
[Founder Name]
Founder, [Product Name]

---
PS: Simpan email ini — link aktivasi Anda ada di sini.
```

**HTML Version:** (Responsive, 600px max width)
```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Welcome Email</title>
</head>
<body style="margin:0; padding:0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; background-color: #f9fafb;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #f9fafb; padding: 40px 20px;">
    <tr>
      <td align="center">
        <table width="600" cellpadding="0" cellspacing="0" style="background-color: #ffffff; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
          <!-- Header -->
          <tr>
            <td style="padding: 40px 40px 20px; text-align: center;">
              <img src="https://yourdomain.com/logo.png" alt="[Product Name]" width="120" style="display: block; margin: 0 auto;">
            </td>
          </tr>
          
          <!-- Body -->
          <tr>
            <td style="padding: 20px 40px 40px; color: #111827; font-size: 16px; line-height: 1.6;">
              <h1 style="margin: 0 0 20px; font-size: 24px; font-weight: 600; color: #111827;">Selamat datang, [First Name]! 🎉</h1>
              
              <p style="margin: 0 0 20px;">Terima kasih sudah mendaftar di [Product Name]. Kami siap membantu Anda [value proposition].</p>
              
              <p style="margin: 0 0 20px; font-weight: 600;">Langkah pertama:</p>
              
              <!-- CTA Button -->
              <table width="100%" cellpadding="0" cellspacing="0" style="margin: 0 0 20px;">
                <tr>
                  <td align="center">
                    <a href="https://app.example.com/onboarding" style="display: inline-block; padding: 14px 28px; background-color: #0891B2; color: #ffffff; text-decoration: none; border-radius: 6px; font-weight: 600; font-size: 16px;">Lengkapi Profil Anda →</a>
                  </td>
                </tr>
              </table>
              
              <p style="margin: 0 0 20px; font-size: 14px; color: #6B7280;">Atau akses tutorial video 5 menit di <a href="https://app.example.com/dashboard" style="color: #0891B2; text-decoration: none;">dashboard Anda</a>.</p>
              
              <hr style="border: 0; border-top: 1px solid #E5E7EB; margin: 30px 0;">
              
              <p style="margin: 0; font-size: 14px; color: #6B7280;">Butuh bantuan? Balas email ini atau hubungi <a href="mailto:support@example.com" style="color: #0891B2; text-decoration: none;">support@example.com</a></p>
            </td>
          </tr>
          
          <!-- Footer -->
          <tr>
            <td style="padding: 20px 40px; background-color: #f9fafb; border-top: 1px solid #E5E7EB; font-size: 12px; color: #6B7280; text-align: center;">
              <p style="margin: 0 0 10px;">[Product Name] — [Tagline]</p>
              <p style="margin: 0;">
                <a href="https://example.com/unsubscribe?email=[Email]" style="color: #6B7280; text-decoration: none;">Unsubscribe</a> | 
                <a href="https://example.com/privacy" style="color: #6B7280; text-decoration: none;">Privacy Policy</a>
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
```

---

### Email 2: Activation Email (Day 2 — If User Hasn't Completed Key Action)

**Subject:** `[First Name], lengkapi langkah ini untuk [benefit] 🚀`

**Plain Text:**
```
Halo [First Name],

Kami perhatikan Anda belum [key action, e.g., "menambahkan data pertama Anda"].

Berikut kenapa ini penting:
✓ [Benefit 1]
✓ [Benefit 2]
✓ [Benefit 3]

Hanya butuh 2 menit:
[CTA Link] → https://app.example.com/[action]

Butuh panduan? Baca artikel ini: [Tutorial Link]

Salam,
[Founder Name]
```

**HTML Version:** (Similar structure to Email 1, highlight benefits with checkmarks)

---

### Email 3: Feature Discovery (Day 5 — Educate Power Features)

**Subject:** `3 fitur yang belum Anda coba di [Product Name] 💡`

**Plain Text:**
```
Halo [First Name],

Sudah nyaman dengan [Product Name]? Yuk coba 3 fitur ini:

1️⃣ [Feature Name]: [1-sentence benefit]
   Tutorial: [Link]

2️⃣ [Feature Name]: [1-sentence benefit]
   Tutorial: [Link]

3️⃣ [Feature Name]: [1-sentence benefit]
   Tutorial: [Link]

Punya pertanyaan? Balas email ini — saya baca setiap balasan.

Salam,
[Founder Name]
```

---

## 2. Transactional Emails

### Password Reset

**Subject:** `Reset password Anda di [Product Name]`

**Plain Text:**
```
Halo [First Name],

Kami menerima permintaan untuk reset password akun Anda.

Klik link ini untuk membuat password baru (berlaku 1 jam):
[Reset Link]

Jika Anda tidak meminta reset password, abaikan email ini.

Salam,
Tim [Product Name]

---
Untuk keamanan, link ini hanya bisa digunakan sekali dan akan kadaluarsa dalam 1 jam.
```

**HTML Version:** (Simple layout, prominent CTA button, security note)

---

### Invoice / Receipt

**Subject:** `Pembayaran diterima — Invoice #[Invoice Number]`

**Plain Text:**
```
Halo [First Name],

Terima kasih atas pembayaran Anda!

RINGKASAN PEMBAYARAN:
- Paket: [Plan Name]
- Jumlah: Rp[Amount]
- Metode: [Payment Method]
- Tanggal: [Date]
- Invoice: #[Invoice Number]

Download invoice lengkap: [Link]

Masa aktif: [Start Date] - [End Date]

Pertanyaan? Hubungi billing@example.com

Salam,
Tim [Product Name]
```

---

### Account Suspended (Payment Failed)

**Subject:** `[URGENT] Akun Anda akan dinonaktifkan dalam 3 hari`

**Plain Text:**
```
Halo [First Name],

Pembayaran terakhir Anda gagal diproses.

Detail:
- Tagihan: Rp[Amount]
- Jatuh tempo: [Due Date]
- Metode pembayaran: [Method] (...[Last 4 Digits])

Untuk menghindari penonaktifan akun, perbarui metode pembayaran Anda:
[Update Payment Method Link]

Butuh bantuan? Balas email ini.

Salam,
Tim [Product Name]
```

---

## 3. Re-Engagement Campaign

### Trial Expiry (3 Days Before End)

**Subject:** `Trial Anda berakhir dalam 3 hari — Upgrade sekarang 🎯`

**Plain Text:**
```
Halo [First Name],

Trial Anda berakhir [Date] (3 hari lagi).

Statistik Anda selama trial:
✓ [Metric 1, e.g., "15 laporan dibuat"]
✓ [Metric 2, e.g., "Rp1.2 juta pajak dihemat"]

Lanjutkan akses unlimited:
[Upgrade Link] → Mulai dari Rp99.000/bulan

Pertanyaan sebelum upgrade? Balas email ini.

Salam,
[Founder Name]
```

---

### Churned User (30 Days After Last Login)

**Subject:** `Kami rindu Anda, [First Name] — Ada yang bisa kami bantu? 💬`

**Plain Text:**
```
Halo [First Name],

Sudah 30 hari Anda tidak login ke [Product Name].

Kami ingin tahu:
- Ada kendala teknis?
- Fitur yang Anda cari tidak ada?
- Harga tidak cocok?

Balas email ini dan ceritakan — feedback Anda sangat berharga.

Sebagai terima kasih, kami berikan diskon 20% jika Anda kembali aktif bulan ini:
Kode: COMEBACK20

Salam,
[Founder Name]

PS: Tidak tertarik lagi? [Unsubscribe link]
```

---

## 4. Announcement / Update Emails

### New Feature Launch

**Subject:** `[NEW] [Feature Name] sekarang tersedia di [Product Name] 🚀`

**Plain Text:**
```
Halo [First Name],

Kami baru meluncurkan fitur yang banyak diminta: [Feature Name]!

Apa yang bisa Anda lakukan:
✓ [Capability 1]
✓ [Capability 2]
✓ [Capability 3]

Coba sekarang: [Link to Feature]
Tutorial lengkap: [Doc Link]

Pertanyaan? Balas email ini.

Salam,
[Founder Name]
```

---

## 5. Best Practices (Email Deliverability & Engagement)

### Technical Setup
- **SPF, DKIM, DMARC:** Wajib dikonfigurasi untuk deliverability (avoid spam folder)
- **Dedicated Sending Domain:** Gunakan subdomain (e.g., `mail.yourdomain.com`) untuk email transactional
- **Warm-up Schedule:** Jangan kirim 10,000 email langsung — mulai 50/day, naikkan bertahap
- **List Hygiene:** Hapus hard bounces & inactive users tiap bulan

### Copywriting Guidelines
- **Subject Line:** Max 50 karakter, avoid spam words ("FREE!!!", "BUY NOW"), test emoji
- **Preheader Text:** 90 karakter yang muncul di preview — gunakan untuk memperkuat subject
- **Personalization:** Minimal `[First Name]`, ideal tambahkan context behavior (`"Anda belum selesaikan X"`)
- **CTA:** Satu CTA utama per email, button warna kontras tinggi
- **Footer:** Wajib ada unsubscribe link (comply CAN-SPAM Act)

### A/B Testing Priority
1. Subject line (impact paling besar pada open rate)
2. CTA button text & color
3. Send time (pagi vs sore, weekday vs weekend)
4. Email length (short vs detailed)

### Metrics Benchmark (SaaS B2B)
- **Open Rate:** 20-30% (good), >35% (excellent)
- **Click Rate:** 3-5% (good), >7% (excellent)
- **Unsubscribe Rate:** <0.5% (acceptable), >2% (red flag)

---

## 6. Email Service Provider (ESP) Integration

### Recommended Tools
| Tool | Use Case | Pricing (Starter Tier) |
|------|----------|------------------------|
| **SendGrid** | Transactional (password reset, invoices) | Free: 100 emails/day |
| **Mailchimp** | Marketing drip campaigns | Free: 500 contacts, 1,000 sends/month |
| **Loops.so** | Modern SaaS email automation | $29/month: 2,000 contacts |
| **Resend** | Developer-first transactional | Free: 3,000 emails/month |

### Code Example (SendGrid + Next.js)
```typescript
// lib/email.ts
import sgMail from '@sendgrid/mail';

sgMail.setApiKey(process.env.SENDGRID_API_KEY!);

export async function sendWelcomeEmail(to: string, firstName: string) {
  const msg = {
    to,
    from: 'hello@yourdomain.com',
    subject: `Selamat datang di [Product Name]! 🎉`,
    text: `Halo ${firstName},\n\nSelamat datang di [Product Name]!...`,
    html: `<html>...</html>`, // Use template from above
  };

  await sgMail.send(msg);
}
```

---

## 7. Internationalization (i18n)

Untuk project multi-bahasa, simpan email templates di JSON dengan struktur:

```json
{
  "welcome_email": {
    "id": {
      "subject": "Selamat datang di {product_name}! 🎉",
      "body": "Halo {first_name},\n\n..."
    },
    "en": {
      "subject": "Welcome to {product_name}! 🎉",
      "body": "Hi {first_name},\n\n..."
    }
  }
}
```

---

## 8. Legal Compliance

### Indonesia (UU PDP / Personal Data Protection Law)
- Wajib ada explicit opt-in checkbox saat sign-up (tidak boleh pre-checked)
- Unsubscribe link harus visible & functional
- Simpan consent records (user, timestamp, IP, context)

### GDPR (EU Users)
- Double opt-in untuk marketing emails
- Right to access: user bisa request semua data email mereka
- Right to erasure: user bisa request hapus dari mailing list

---

**Template ini bisa di-customize sesuai brand voice & industry Anda.**
