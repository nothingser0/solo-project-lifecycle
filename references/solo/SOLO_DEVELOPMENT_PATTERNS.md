# Solo Development Patterns

This document is a collection of practical, production-grade design patterns for solo developers to ensure code is clean, resilient against bugs, and cryptographically secure without excessive dependencies.

---

## 1. "Parse, Don't Validate" Pattern with Zod

As a solo developer, never validate data using manual `if (!req.body.name)` checks. Use **Zod** schemas at the API handler layer:

```typescript
import { z } from "zod";

// 1. Define contract schema (according to FSD)
export const CreateDocumentSchema = z.object({
  title: z.string().min(3).max(255),
  template_type: z.enum(["pkwt", "nda", "freelance_contract", "invoice"]),
  form_data: z.record(z.unknown()),
});

export type CreateDocumentInput = z.infer<typeof CreateDocumentSchema>;

// 2. Use in API Route Handler
export async function handleCreateDocument(req: Request) {
  const json = await req.json().catch(() => null);
  
  // Parse at the Trust Boundary
  const result = CreateDocumentSchema.safeParse(json);
  
  if (!result.success) {
    return Response.json({
      status: "error",
      code: "VALIDATION_ERROR",
      errors: result.error.flatten().fieldErrors,
    }, { status: 400 });
  }

  // Data below is 100% validated and type-safe
  const validData: CreateDocumentInput = result.data;
  // Proceed to business logic...
}
```

---

## 2. Stream File Encryption Pattern (AES-256-GCM Streaming)

Never load entire raw PDF files into server RAM before encrypting (this can cause Out of Memory errors on large files). Use stream encryption:

### TypeScript/Node.js:
```typescript
import { createCipheriv, randomBytes } from "node:crypto";
import { Readable } from "node:stream";

export function encryptBuffer(buffer: Buffer, masterKeyHex: string) {
  const key = Buffer.from(masterKeyHex, "hex"); // 32 bytes (256-bit)
  const iv = randomBytes(12); // Standard 96-bit IV for GCM
  
  const cipher = createCipheriv("aes-256-gcm", key, iv);
  const encrypted = Buffer.concat([cipher.update(buffer), cipher.final()]);
  const authTag = cipher.getAuthTag(); // 16 bytes auth tag

  // Combine IV + AuthTag + EncryptedData for storage in S3/R2
  return Buffer.concat([iv, authTag, encrypted]);
}
```

### PHP/Laravel:
```php
use Illuminate\Support\Facades\Crypt;

function encryptFile(string $filePath, string $masterKey): string {
    $iv = random_bytes(12); // 96-bit IV for GCM
    $data = file_get_contents($filePath);
    
    $encrypted = openssl_encrypt(
        $data, 
        'aes-256-gcm', 
        hex2bin($masterKey), 
        OPENSSL_RAW_DATA, 
        $iv, 
        $tag
    );
    
    // Combine IV + AuthTag + EncryptedData
    return $iv . $tag . $encrypted;
}
```

### Python/FastAPI:
```python
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
import os

def encrypt_file(data: bytes, master_key_hex: str) -> bytes:
    key = bytes.fromhex(master_key_hex)  # 32 bytes (256-bit)
    iv = os.urandom(12)  # Standard 96-bit IV for GCM
    
    aesgcm = AESGCM(key)
    encrypted = aesgcm.encrypt(iv, data, None)
    
    # Encrypted data includes auth tag at the end
    return iv + encrypted
```

---

## 3. Atomic Transaction & Row Locking Pattern (Pessimistic Lock)

To prevent two signers from modifying a document simultaneously (race conditions):

```typescript
import { db } from "@/lib/db";

export async function signDocumentAtomically(documentId: string, signerData: any) {
  return await db.$transaction(async (tx) => {
    // 1. Exclusively lock the document row
    const [doc] = await tx.$queryRaw<any[]>`
      SELECT id, status FROM documents WHERE id = ${documentId}::uuid FOR UPDATE
    `;

    if (!doc) throw new Error("DOCUMENT_NOT_FOUND");
    if (doc.status === "signed") throw new Error("ALREADY_SIGNED");

    // 2. Save signature
    await tx.documentSignature.create({
      data: { documentId, ...signerData },
    });

    // 3. Update document status to SIGNED
    const updated = await tx.document.update({
      where: { id: documentId },
      data: { status: "signed" },
    });

    return updated;
  });
}
```

---

## 4. Ephemeral Access URL Pattern (Presigned URL)

Never store public URLs to document vault files:

```typescript
import { S3Client, GetObjectCommand } from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";

const s3 = new S3Client({ /* R2 / S3 configuration */ });

export async function generateSecureDownloadLink(fileKey: string): Promise<string> {
  const command = new GetObjectCommand({
    Bucket: process.env.STORAGE_BUCKET_NAME,
    Key: fileKey,
  });

  // Automatically expires in 900 seconds (15 minutes)
  return await getSignedUrl(s3, command, { expiresIn: 900 });
}
```

---

## 5. Self-Asserting Smoke Test Harness Pattern

Solo developers do not need heavy testing frameworks just to verify basic app health. Build a standalone script using Node.js's built-in `assert` module:

```typescript
// scripts/smoke-test.ts
import assert from "node:assert/strict";

async function runSmokeTest() {
  console.log("Running Local Smoke Test...");

  // 1. Test API Healthcheck
  const resHealth = await fetch("http://localhost:3000/api/health");
  assert.equal(resHealth.status, 200, "API Healthcheck must return 200 OK");

  // 2. Test Empty Payload Rejection
  const resBad = await fetch("http://localhost:3000/api/v1/documents", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({}),
  });
  assert.equal(resBad.status, 400, "Empty payload must be rejected with 400 Bad Request");

  console.log("All self-assertions PASSED (100% PASS)!");
}

runSmokeTest().catch((err) => {
  console.error("Self-test failed:", err);
  process.exit(1);
});
```

---

## 6. Merging Custom AGENTS.md with Next.js 15 Default

Next.js 15 auto-generates a minimal `AGENTS.md` file (a 9-line framework notice). **MANDATORY to overwrite** with the complete `AGENTS_TEMPLATE.md`, while optionally keeping the Next.js warning at the bottom.

**Correct Merge Structure:**

```markdown
# Agent Instructions

[... Paste entire AGENTS_TEMPLATE.md content here ...]
[... (Rules for 6 engineering pillars, Zod boundaries, no `any` types, etc.) ...]

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

**PROHIBITED:**
- ❌ Skipping overwriting AGENTS.md because it "already exists"
- ❌ Merely appending the template to the 9-line Next.js file (incomplete)
- ❌ Dropping the Next.js notice entirely (keep it at the bottom instead)

**MANDATORY:**
- ✅ Fully overwrite with AGENTS_TEMPLATE.md
- ✅ Optional: append the "Framework-Specific Notices" block at the very bottom
