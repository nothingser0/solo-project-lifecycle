# Indonesian Payment Gateway Integration Pattern

> **Standard**: Secure, idempotent payment processing for Indonesian payment rails (QRIS, Virtual Account, E-Wallet, Card) via Midtrans and Xendit.
> **Compliance**: Bank Indonesia PBI QRIS, PCI-DSS SAQ-A (no raw card data on merchant servers).

---

## 1. Architecture Overview

Indonesian payments follow an asynchronous webhook model:

```
[User Browser]
       │ 1. Checkout request
       ▼
[Your Backend] ──(2. Create Tx with Secret Key)──► [Payment Gateway API]
       │                                                      │
       │ 3. Return Snap Token / QR String / VA Number         │
       ▼                                                      │
[User Completes Payment via BCA Mobile / GoPay / QRIS]        │
                                                              │ 4. HTTP POST Webhook
                                                              ▼
                                                        [Your Backend Webhook Handler]
                                                              │ 5. Verify Crypto Signature
                                                              │ 6. Idempotent DB Update
                                                              ▼
                                                        [Database Order Marked PAID]
```

---

## 2. Idempotent Webhook Handler (Midtrans Example)

```typescript
import { NextRequest, NextResponse } from 'next/server';
import crypto from 'node:crypto';
import { db } from '@/lib/db';

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const {
      order_id,
      status_code,
      gross_amount,
      signature_key,
      transaction_id,
      transaction_status,
      fraud_status,
    } = body;

    // 1. Cryptographic Signature Verification
    const serverKey = process.env.MIDTRANS_SERVER_KEY;
    if (!serverKey) {
      return NextResponse.json({ error: 'Server misconfiguration' }, { status: 500 });
    }

    const payloadToHash = `${order_id}${status_code}${gross_amount}${serverKey}`;
    const calculatedSignature = crypto
      .createHash('sha512')
      .update(payloadToHash)
      .digest('hex');

    if (calculatedSignature !== signature_key) {
      console.warn(`[Security Alert] Invalid payment webhook signature for order ${order_id}`);
      return NextResponse.json({ error: 'Invalid signature' }, { status: 403 });
    }

    // 2. Idempotency & Concurrency Lock (Prevent duplicate credit on simultaneous network retries)
    // Use an atomic upsert/insert on a unique gateway transaction record to lock processing.
    const idempotencyKey = `midtrans_${transaction_id || order_id}`;
    
    const existingOrder = await db.order.findUnique({
      where: { id: order_id },
      select: { status: true, paymentStatus: true },
    });

    if (!existingOrder) {
      return NextResponse.json({ error: 'Order not found' }, { status: 404 });
    }

    if (existingOrder.paymentStatus === 'PAID') {
      // Already settled, return 200 immediately to acknowledge gateway retry
      return NextResponse.json({ status: 'already_processed' }, { status: 200 });
    }

    // 3. Status Transition Matrix
    let newPaymentStatus: 'PENDING' | 'PAID' | 'FAILED' | 'EXPIRED' = 'PENDING';

    if (transaction_status === 'capture') {
      newPaymentStatus = fraud_status === 'accept' ? 'PAID' : 'FAILED';
    } else if (transaction_status === 'settlement') {
      newPaymentStatus = 'PAID';
    } else if (['cancel', 'deny', 'expire'].includes(transaction_status)) {
      newPaymentStatus = 'EXPIRED';
    }

    // 4. Atomic Transactional Update with Unique Webhook Log
    await db.$transaction(async (tx) => {
      // Unique constraint on gatewayTransactionId prevents concurrent duplicate webhook execution
      await tx.paymentLog.create({
        data: {
          idempotencyKey,
          orderId: order_id,
          gateway: 'MIDTRANS',
          rawPayload: body,
          status: newPaymentStatus,
        },
      });

      await tx.order.update({
        where: { id: order_id },
        data: {
          paymentStatus: newPaymentStatus,
          status: newPaymentStatus === 'PAID' ? 'PROCESSING' : existingOrder.status,
          paidAt: newPaymentStatus === 'PAID' ? new Date() : null,
        },
      });
    });

    return NextResponse.json({ status: 'ok' }, { status: 200 });
  } catch (error) {
    console.error('Webhook processing error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
```

---

## 3. Idempotent Webhook Handler (Xendit Example)

```typescript
import { NextRequest, NextResponse } from 'next/server';
import { db } from '@/lib/db';

export async function POST(req: NextRequest) {
  try {
    // 1. Verification of Xendit Callback Token
    const callbackToken = req.headers.get('x-callback-token');
    const configuredToken = process.env.XENDIT_CALLBACK_TOKEN;

    if (!configuredToken || callbackToken !== configuredToken) {
      console.warn('[Security Alert] Invalid or missing Xendit callback token');
      return NextResponse.json({ error: 'Unauthorized callback token' }, { status: 403 });
    }

    const body = await req.json();
    // Xendit standard invoice payload uses `external_id` (your order ID) and `id` (Xendit transaction ID)
    const { id: xenditInvoiceId, external_id: order_id, status } = body;

    if (!order_id || !status) {
      return NextResponse.json({ error: 'Invalid payload structure' }, { status: 400 });
    }

    const idempotencyKey = `xendit_${xenditInvoiceId || order_id}`;

    // 2. Fetch Order Status
    const existingOrder = await db.order.findUnique({
      where: { id: order_id },
      select: { status: true, paymentStatus: true },
    });

    if (!existingOrder) {
      return NextResponse.json({ error: 'Order not found' }, { status: 404 });
    }

    if (existingOrder.paymentStatus === 'PAID') {
      return NextResponse.json({ status: 'already_processed' }, { status: 200 });
    }

    // 3. Status Mapping (Xendit Invoice statuses: 'PAID', 'SETTLED', 'EXPIRED', 'PENDING')
    let newPaymentStatus: 'PENDING' | 'PAID' | 'FAILED' | 'EXPIRED' = 'PENDING';
    if (status === 'PAID' || status === 'SETTLED') {
      newPaymentStatus = 'PAID';
    } else if (status === 'EXPIRED') {
      newPaymentStatus = 'EXPIRED';
    }

    // 4. Atomic Transactional Update with Unique Webhook Log
    await db.$transaction(async (tx) => {
      await tx.paymentLog.create({
        data: {
          idempotencyKey,
          orderId: order_id,
          gateway: 'XENDIT',
          rawPayload: body,
          status: newPaymentStatus,
        },
      });

      await tx.order.update({
        where: { id: order_id },
        data: {
          paymentStatus: newPaymentStatus,
          status: newPaymentStatus === 'PAID' ? 'PROCESSING' : existingOrder.status,
          paidAt: newPaymentStatus === 'PAID' ? new Date() : null,
        },
      });
    });

    return NextResponse.json({ status: 'ok' }, { status: 200 });
  } catch (error) {
    console.error('Xendit webhook processing error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
```

---

## 4. QRIS Dynamic Generation & Expiration

1. **Expiration Window**: Dynamic QRIS invoices must expire within 15–30 minutes to prevent stale inventory reservations.
2. **Fee Calculation**:
   - QRIS MDR: **0.7%** for standard merchants, **0.3%** for micro-enterprises (UMKM).
   - In Indonesia, pass-through fee surcharging directly to retail consumers requires regulatory care; usually absorbed into product pricing or charged transparently as administrative fee.
