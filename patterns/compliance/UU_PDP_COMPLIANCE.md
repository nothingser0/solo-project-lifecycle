# UU PDP (Undang-Undang Perlindungan Data Pribadi) Compliance Pattern

> **Statutory Basis**: Undang-Undang Republik Indonesia Nomor 27 Tahun 2022 tentang Pelindungan Data Pribadi (UU PDP).
> **Target Audience**: SaaS developers and technical architects operating digital platforms in Indonesia.

---

## 1. Core Principles for Software Engineering

1. **Lawful Basis & Explicit Consent (Pasal 20–22)**:
   - Data collection requires explicit, unbundled user consent.
   - Pre-ticked checkboxes or forced agreements are legally invalid.
2. **Right to Erasure & Anonymization (Pasal 8)**:
   - Users have the right to request deletion or anonymization of their personal data.
   - Exception: Statutory record-keeping laws (e.g. UU Ketentuan Umum Perpajakan mandates keeping financial/transaction records for 5–10 years). In financial systems, personal identifiers are **anonymized/pseudonymized** while ledger transactions are preserved.
3. **Mandatory Breach Notification within 72 Hours (Pasal 46)**:
   - Data controllers must notify Komdigi (Kementerian Komunikasi dan Digital) and affected data subjects within **72 hours** of discovering a data breach.
   - For solo developers, maintain an incident template (`BREACH_NOTIFICATION_TEMPLATE.md`) to avoid panic and ensure mandatory statutory fields (nature of breach, impacted records, remediation contact) are reported immediately.

---

## 2. Statutory Breach Notification Format (Komdigi Pasal 46)

When a security incident involving personal data occurs, copy and fill this statutory notification:

```markdown
# PEMBERITAHUAN KEGAGALAN PERLINDUNGAN DATA PRIBADI (UU PDP NO. 27/2022 PASAL 46)

Kepada Yth:
Direktorat Jenderal Pengendalian Aplikasi Informatika / Lembaga Pelindungan Data Pribadi
Kementerian Komunikasi dan Digital Republik Indonesia (Komdigi)

1. Identitas Pengendali Data:
   - Nama Entitas / Penyelenggara: [Nama PT / Usaha / Aplikasi]
   - Kontak Darurat Penanggung Jawab: [Email & No HP]
2. Waktu & Kronologi Terjadinya Insiden:
   - Tanggal & Waktu Terdeteksi: [YYYY-MM-DD HH:mm WIB]
   - Penyebab Utama: [Credential Leak / SQL Injection / Misconfigured S3 Bucket / etc.]
3. Jenis & Jumlah Data Pribadi yang Terdampak:
   - Estimasi Jumlah Subjek Data: [Jumlah User]
   - Kategori Data: [Nama, Email, Hash Password, No HP] (Tidak termasuk data kartu kredit / plain password)
4. Langkah Penanganan yang Telah Diambil:
   - [x] Isolasi server / rotasi secret keys & API tokens
   - [x] Penutupan celah keamanan pada endpoint terdampak
   - [x] Pemberitahuan tertulis kepada pengguna terdampak dalam waktu 72 jam
5. Kontak Bantuan Subjek Data:
   - Saluran Pengaduan Resmi: support@domain.com / +62...
```

---

## 3. Consent Ledger Schema (Prisma Example)

```prisma
model UserConsent {
  id           String   @id @default(uuid())
  userId       String
  consentType  String   // e.g., "TERMS_OF_SERVICE", "MARKETING_COMMUNICATION", "ANALYTICS_TRACKING"
  policyVersion String   // e.g., "v1.0.0"
  isGranted    Boolean  @default(true)
  ipAddress    String?
  userAgent    String?
  grantedAt    DateTime @default(now())
  revokedAt    DateTime?

  user         User     @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@index([userId, consentType])
}
```

---

## 3. Right to Erasure / Anonymization Workflow

When a user exercises their right to data deletion:

```typescript
import { db } from '@/lib/db';

export async function processDataErasureRequest(userId: string) {
  return await db.$transaction(async (tx) => {
    // 1. Check for active statutory retention requirements (e.g. unpaid orders or active tax audits)
    const activeTransactions = await tx.order.findMany({
      where: { userId, paymentStatus: 'PAID' },
    });

    if (activeTransactions.length > 0) {
      // 2. Anonymize personal identifiers while preserving financial records
      await tx.user.update({
        where: { id: userId },
        data: {
          fullName: 'Anonim (Dihapus atas Permintaan PDP)',
          email: `deleted_${userId.slice(0, 8)}@anonymized.internal`,
          phoneNumber: null,
          nationalIdNumber: null, // NIK
          isDeleted: true,
          deletedAt: new Date(),
        },
      });

      // Clear non-essential profile logs
      await tx.userSession.deleteMany({ where: { userId } });
      await tx.userConsent.updateMany({
        where: { userId },
        data: { isGranted: false, revokedAt: new Date() },
      });

      return { status: 'ANONYMIZED', reason: 'Retained financial ledger under statutory tax rules' };
    }

    // 3. Complete hard delete if zero statutory retention requirements exist
    await tx.user.delete({ where: { id: userId } });
    return { status: 'PURGED' };
  });
}
```

---

## 4. Encryption & Security Controls (Pasal 35)

- **Transit**: TLS 1.3 mandatory; HSTS headers enabled (`max-age=31536000`).
- **At-Rest**: Sensitive PII fields (NIK, financial account numbers, health data) encrypted at application level using AES-256-GCM before database write.
- **Audit Logging**: Zero raw passwords, tokens, or plaintext NIKs logged in stdout or monitoring tools (Sentry/Datadog).
