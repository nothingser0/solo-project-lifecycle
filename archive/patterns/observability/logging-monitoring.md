# Observability, Structured Logging & Error Monitoring Pattern

> **Target**: Production debugging, error tracking, and audit trails for solo developers and small teams without enterprise APM overhead.

---

## 1. Principles of High-Signal Logging

1. **Structured JSON**: Never write raw strings like `console.log("user logged in " + id)`. Output structured JSON objects with timestamp, level, event, and context.
2. **Correlation ID (`x-request-id`)**: Every incoming HTTP request is assigned a unique trace ID forwarded to downstream DB queries, logs, and external calls.
3. **Zero PII Exposure (UU PDP Enforcement)**: Passwords, authorization headers, API secret keys, NIK (National ID), and credit card numbers MUST be redacted before serialization.

---

## 2. Structured Logger Setup (Pino Example)

```typescript
import pino from 'pino';

export const logger = pino({
  level: process.env.LOG_LEVEL || (process.env.NODE_ENV === 'production' ? 'info' : 'debug'),
  redact: {
    paths: [
      'req.headers.authorization',
      'req.headers.cookie',
      'password',
      'token',
      'secret',
      'nik',
      'creditCard',
      'cvv',
    ],
    censor: '[REDACTED]',
  },
  formatters: {
    level(label) {
      return { level: label };
    },
  },
  base: {
    env: process.env.NODE_ENV,
    service: 'app-service',
  },
});
```

---

## 3. Request Tracing Middleware

```typescript
import { NextRequest, NextResponse } from 'next/server';
import { logger } from '@/lib/logger';

export function middleware(req: NextRequest) {
  const requestId = req.headers.get('x-request-id') || crypto.randomUUID();
  const startTime = Date.now();

  const response = NextResponse.next();
  response.headers.set('x-request-id', requestId);

  // Log on completion
  const duration = Date.now() - startTime;
  logger.info({
    requestId,
    method: req.method,
    path: req.nextUrl.pathname,
    status: response.status,
    durationMs: duration,
    userAgent: req.headers.get('user-agent'),
  }, 'HTTP Request processed');

  return response;
}
```

---

## 4. Production Error Alerting (Sentry + Telegram/Slack)

- **Sentry Error Filtering**: Ignore known client-side transient errors (e.g., `ResizeObserver loop limit exceeded`, `AbortError`).
- **Critical Alert Triggers**:
  - Payment gateway signature verification failures.
  - Database connection pool exhaustion (`Max pool size reached`).
  - Webhook processing retries exceeding 5 attempts.
