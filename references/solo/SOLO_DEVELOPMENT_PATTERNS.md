# Pola Rekayasa Kode Solo Developer (Solo Development Patterns)

Dokumen ini adalah kumpulan pola pengkodean praktis (*production-grade design patterns*) untuk solo developer guna memastikan kode bersih, tahan banting dari bug, dan aman secara kriptografis tanpa dependensi berlebih.

---

## 1. Pola "Parse, Don't Validate" dengan Zod

Sebagai solo developer, jangan pernah memvalidasi data menggunakan pengecekan `if (!req.body.name)` secara manual. Gunakan skema **Zod** di lapisan handler API:

```typescript
import { z } from "zod";

// 1. Definisikan skema kontrak (sesuai FSD)
export const CreateDocumentSchema = z.object({
  title: z.string().min(3).max(255),
  template_type: z.enum(["pkwt", "nda", "freelance_contract", "invoice"]),
  form_data: z.record(z.unknown()),
});

export type CreateDocumentInput = z.infer<typeof CreateDocumentSchema>;

// 2. Gunakan di API Route Handler
export async function handleCreateDocument(req: Request) {
  const json = await req.json().catch(() => null);
  
  // Parse di batas kepercayaan (Trust Boundary)
  const result = CreateDocumentSchema.safeParse(json);
  
  if (!result.success) {
    return Response.json({
      status: "error",
      code: "VALIDATION_ERROR",
      errors: result.error.flatten().fieldErrors,
    }, { status: 400 });
  }

  // Data di bawah ini 100% aman dan ber-type aman (Type-Safe)
  const validData: CreateDocumentInput = result.data;
  // Lanjutkan ke business logic...
}
```

---

## 2. Pola Enkripsi Berkas Aliran (AES-256-GCM Streaming)

Dilarang memuat seluruh file PDF mentah ke memori RAM server sebelum dienkripsi (bisa menyebabkan *Out of Memory* pada file besar). Gunakan metode *stream encryption*:

### TypeScript/Node.js:
```typescript
import { createCipheriv, randomBytes } from "node:crypto";
import { Readable } from "node:stream";

export function encryptBuffer(buffer: Buffer, masterKeyHex: string) {
  const key = Buffer.from(masterKeyHex, "hex"); // 32 bytes (256-bit)
  const iv = randomBytes(12); // 96-bit IV standar untuk GCM
  
  const cipher = createCipheriv("aes-256-gcm", key, iv);
  const encrypted = Buffer.concat([cipher.update(buffer), cipher.final()]);
  const authTag = cipher.getAuthTag(); // 16 bytes auth tag

  // Gabungkan IV + AuthTag + EncryptedData untuk disimpan di S3/R2
  return Buffer.concat([iv, authTag, encrypted]);
}
```

### PHP/Laravel:
```php
use Illuminate\Support\Facades\Crypt;

function encryptFile(string $filePath, string $masterKey): string {
    $iv = random_bytes(12); // 96-bit IV untuk GCM
    $data = file_get_contents($filePath);
    
    $encrypted = openssl_encrypt(
        $data, 
        'aes-256-gcm', 
        hex2bin($masterKey), 
        OPENSSL_RAW_DATA, 
        $iv, 
        $tag
    );
    
    // Gabungkan IV + AuthTag + EncryptedData
    return $iv . $tag . $encrypted;
}
```

### Python/FastAPI:
```python
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
import os

def encrypt_file(data: bytes, master_key_hex: str) -> bytes:
    key = bytes.fromhex(master_key_hex)  # 32 bytes (256-bit)
    iv = os.urandom(12)  # 96-bit IV standar untuk GCM
    
    aesgcm = AESGCM(key)
    encrypted = aesgcm.encrypt(iv, data, None)
    
    # encrypted sudah termasuk auth tag di akhir
    return iv + encrypted
```

---

## 3. Pola Transaksi Atomik & Penguncian Baris (Pessimistic Lock)

Untuk mencegah dua penandatangan mengubah dokumen di saat yang sama (*race condition*):

```typescript
import { db } from "@/lib/db";

export async function signDocumentAtomically(documentId: string, signerData: any) {
  return await db.$transaction(async (tx) => {
    // 1. Kunci baris dokumen secara eksklusif
    const [doc] = await tx.$queryRaw<any[]>`
      SELECT id, status FROM documents WHERE id = ${documentId}::uuid FOR UPDATE
    `;

    if (!doc) throw new Error("DOCUMENT_NOT_FOUND");
    if (doc.status === "signed") throw new Error("ALREADY_SIGNED");

    // 2. Simpan tanda tangan
    await tx.documentSignature.create({
      data: { documentId, ...signerData },
    });

    // 3. Update status dokumen menjadi SIGNED
    const updated = await tx.document.update({
      where: { id: documentId },
      data: { status: "signed" },
    });

    return updated;
  });
}
```

---

## 4. Pola Tautan Akses Sementara (Presigned URL)

Jangan pernah menyimpan URL publik ke file dokumen vault:

```typescript
import { S3Client, GetObjectCommand } from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";

const s3 = new S3Client({ /* konfigurasi R2 / S3 */ });

export async function generateSecureDownloadLink(fileKey: string): Promise<string> {
  const command = new GetObjectCommand({
    Bucket: process.env.STORAGE_BUCKET_NAME,
    Key: fileKey,
  });

  // Kedaluwarsa otomatis dalam 900 detik (15 menit)
  return await getSignedUrl(s3, command, { expiresIn: 900 });
}
```

---

## 5. Pola Skrip Uji Asersi Mandiri (Smoke Test Harness)

Solo dev tidak perlu setup framework test yang berat untuk mengecek apakah aplikasi dasar berjalan. Buat skrip mandiri dengan modul `assert` bawaan Node.js:

```typescript
// scripts/smoke-test.ts
import assert from "node:assert/strict";

async function runSmokeTest() {
  console.log("Menjalankan Local Smoke Test...");

  // 1. Uji Healthcheck API
  const resHealth = await fetch("http://localhost:3000/api/health");
  assert.equal(resHealth.status, 200, "API Healthcheck harus 200 OK");

  // 2. Uji Penolakan Payload Kosong
  const resBad = await fetch("http://localhost:3000/api/v1/documents", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({}),
  });
  assert.equal(resBad.status, 400, "Payload kosong harus ditolak 400 Bad Request");

  console.log("Seluruh asersi mandiri LOLOS (100% PASS)!");
}

runSmokeTest().catch((err) => {
  console.error("Gagal uji mandiri:", err);
  process.exit(1);
});
```

---

## 6. Merging Custom AGENTS.md with Next.js 15 Default

Next.js 15 auto-generate file `AGENTS.md` minimal (9 baris peringatan framework). **WAJIB ditimpa** dengan `AGENTS_TEMPLATE.md` lengkap, tapi boleh menyimpan peringatan Next.js di bawah.

**Struktur Merge yang Benar:**

```markdown
# Agent Instructions

[... Paste seluruh isi AGENTS_TEMPLATE.md di sini ...]
[... (Aturan 6 pilar rekayasa, Zod boundary, larangan tipe `any`, dll.) ...]

---

## Framework-Specific Notices

### Next.js 15 Default Notice

This project was bootstrapped with `create-next-app`.
The Next.js team recommends:
- Use Server Components by default
- Client Components require explicit `"use client"` directive
- Avoid modifying core framework files without understanding implications

Refer to [Next.js Documentation](https://nextjs.org/docs) for details.
```

**DILARANG:**
- ❌ Skip timpa AGENTS.md karena "sudah ada"
- ❌ Cuma append template ke file 9-baris Next.js (kurang lengkap)
- ❌ Buang peringatan Next.js sama sekali (boleh disimpan di bawah)

**WAJIB:**
- ✅ Timpa penuh dengan AGENTS_TEMPLATE.md
- ✅ Optional: tambahkan blok "Framework-Specific Notices" di paling bawah
