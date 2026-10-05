# Authentication & Password Security

**Purpose**: Production-ready auth patterns compliant with UU PDP No. 27/2022

**Reference locations**: M05 (lines 48, 1277, 1300, 1518), M05B (lines 1682, 1819, 1825), M06 (lines 910-913, 945, 1237-1238, 1524), M10 (lines 97-98, 116)

---

## Core Security Requirements

1. **Password Hashing**: Argon2id (recommended) or bcrypt cost ≥12
2. **Session Storage**: HttpOnly, Secure, SameSite cookies
3. **Token Management**: JWT rotation, 15-min access + 7-day refresh
4. **Rate Limiting**: 5 attempts per IP per 15 minutes
5. **Password Reset**: Cryptographic tokens with 15-minute TTL

---

## Installation

```bash
# Next.js
pnpm add bcrypt jsonwebtoken
pnpm add -D @types/bcrypt @types/jsonwebtoken

# Argon2 (better security, slower)
pnpm add argon2
```

---

## Password Hashing

### Argon2id (Recommended)

```typescript
// lib/auth/password.ts
import argon2 from 'argon2';

export async function hashPassword(password: string): Promise<string> {
  return argon2.hash(password, {
    type: argon2.argon2id,
    memoryCost: 65536, // 64 MB
    timeCost: 3,       // 3 iterations
    parallelism: 4,    // 4 threads
  });
}

export async function verifyPassword(
  password: string,
  hash: string
): Promise<boolean> {
  try {
    return await argon2.verify(hash, password);
  } catch {
    return false;
  }
}
```

**Why Argon2id?**
- ✅ Resistant to GPU/ASIC attacks (memory-hard)
- ✅ Winner of Password Hashing Competition 2015
- ✅ Recommended by OWASP 2024

---

### Bcrypt (Fallback)

```typescript
// lib/auth/password.ts
import bcrypt from 'bcrypt';

const SALT_ROUNDS = 12; // Min 12 for production

export async function hashPassword(password: string): Promise<string> {
  return bcrypt.hash(password, SALT_ROUNDS);
}

export async function verifyPassword(
  password: string,
  hash: string
): Promise<boolean> {
  try {
    return await bcrypt.compare(password, hash);
  } catch {
    return false;
  }
}
```

**Bcrypt cost factor**:
- Cost 10 = ~100ms (too fast for 2026)
- **Cost 12 = ~400ms** (minimum acceptable)
- Cost 14 = ~1.5s (high-security, impacts UX)

---

## JWT Authentication

### Token Generation

```typescript
// lib/auth/jwt.ts
import jwt from 'jsonwebtoken';

const ACCESS_TOKEN_SECRET = process.env.JWT_SECRET!;
const REFRESH_TOKEN_SECRET = process.env.JWT_REFRESH_SECRET!;

interface TokenPayload {
  userId: string;
  email: string;
  role: string;
}

export function generateAccessToken(payload: TokenPayload): string {
  return jwt.sign(payload, ACCESS_TOKEN_SECRET, {
    expiresIn: '15m', // Short-lived
    issuer: 'your-app',
    audience: 'your-app-users',
  });
}

export function generateRefreshToken(payload: TokenPayload): string {
  return jwt.sign(payload, REFRESH_TOKEN_SECRET, {
    expiresIn: '7d', // Long-lived
    issuer: 'your-app',
  });
}

export function verifyAccessToken(token: string): TokenPayload {
  return jwt.verify(token, ACCESS_TOKEN_SECRET) as TokenPayload;
}

export function verifyRefreshToken(token: string): TokenPayload {
  return jwt.verify(token, REFRESH_TOKEN_SECRET) as TokenPayload;
}
```

---

### Login Flow (Next.js)

```typescript
// app/api/auth/login/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { LoginSchema } from '@/lib/schemas/auth';
import { verifyPassword } from '@/lib/auth/password';
import { generateAccessToken, generateRefreshToken } from '@/lib/auth/jwt';
import { db } from '@/lib/db';

export async function POST(req: NextRequest) {
  const body = await req.json();
  const { email, password } = LoginSchema.parse(body);

  // Find user
  const user = await db.user.findUnique({ where: { email } });
  if (!user) {
    return NextResponse.json(
      { error: 'Invalid credentials' },
      { status: 401 }
    );
  }

  // Verify password
  const valid = await verifyPassword(password, user.password);
  if (!valid) {
    return NextResponse.json(
      { error: 'Invalid credentials' },
      { status: 401 }
    );
  }

  // Generate tokens
  const payload = {
    userId: user.id,
    email: user.email,
    role: user.role,
  };
  
  const accessToken = generateAccessToken(payload);
  const refreshToken = generateRefreshToken(payload);

  // Store refresh token in database
  await db.refreshToken.create({
    data: {
      token: refreshToken,
      userId: user.id,
      expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
    },
  });

  // Set HttpOnly cookies
  const response = NextResponse.json({ 
    user: { id: user.id, email: user.email, role: user.role }
  });
  
  response.cookies.set('accessToken', accessToken, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'lax',
    maxAge: 15 * 60, // 15 minutes
    path: '/',
  });
  
  response.cookies.set('refreshToken', refreshToken, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'lax',
    maxAge: 7 * 24 * 60 * 60, // 7 days
    path: '/',
  });

  return response;
}
```

---

### Authentication Middleware

```typescript
// lib/middleware/auth.ts
import { NextRequest, NextResponse } from 'next/server';
import { verifyAccessToken } from '@/lib/auth/jwt';

export async function requireAuth(req: NextRequest) {
  const accessToken = req.cookies.get('accessToken')?.value;

  if (!accessToken) {
    return NextResponse.json(
      { error: 'Unauthorized' },
      { status: 401 }
    );
  }

  try {
    const payload = verifyAccessToken(accessToken);
    
    // Attach user to request
    (req as any).user = payload;
    return null; // No error
    
  } catch (error) {
    return NextResponse.json(
      { error: 'Invalid or expired token' },
      { status: 401 }
    );
  }
}

// Usage in API route
export async function GET(req: NextRequest) {
  const authError = await requireAuth(req);
  if (authError) return authError;

  const user = (req as any).user;
  // ... protected logic
}
```

---

### Token Refresh

```typescript
// app/api/auth/refresh/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { verifyRefreshToken, generateAccessToken } from '@/lib/auth/jwt';
import { db } from '@/lib/db';

export async function POST(req: NextRequest) {
  const refreshToken = req.cookies.get('refreshToken')?.value;

  if (!refreshToken) {
    return NextResponse.json(
      { error: 'No refresh token' },
      { status: 401 }
    );
  }

  try {
    // Verify token signature
    const payload = verifyRefreshToken(refreshToken);

    // Check token exists in database (not revoked)
    const storedToken = await db.refreshToken.findFirst({
      where: {
        token: refreshToken,
        userId: payload.userId,
        expiresAt: { gt: new Date() },
      },
    });

    if (!storedToken) {
      return NextResponse.json(
        { error: 'Invalid refresh token' },
        { status: 401 }
      );
    }

    // Generate new access token
    const newAccessToken = generateAccessToken({
      userId: payload.userId,
      email: payload.email,
      role: payload.role,
    });

    // Set new access token cookie
    const response = NextResponse.json({ success: true });
    response.cookies.set('accessToken', newAccessToken, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax',
      maxAge: 15 * 60,
      path: '/',
    });

    return response;

  } catch (error) {
    return NextResponse.json(
      { error: 'Invalid refresh token' },
      { status: 401 }
    );
  }
}
```

---

## Rate Limiting

### Simple Rate Limiter (Memory)

```typescript
// lib/middleware/rate-limit.ts
import { NextRequest, NextResponse } from 'next/server';

const requests = new Map<string, number[]>();

export function rateLimit(options: {
  maxAttempts: number;
  windowMs: number;
}) {
  return (req: NextRequest) => {
    const ip = req.ip || req.headers.get('x-forwarded-for') || 'unknown';
    const now = Date.now();
    const windowStart = now - options.windowMs;

    // Get recent requests from this IP
    const recentRequests = requests.get(ip) || [];
    const validRequests = recentRequests.filter(time => time > windowStart);

    if (validRequests.length >= options.maxAttempts) {
      return NextResponse.json(
        { error: 'Too many requests, try again later' },
        { status: 429 }
      );
    }

    // Record this request
    validRequests.push(now);
    requests.set(ip, validRequests);

    return null; // No error
  };
}

// Usage
const loginRateLimiter = rateLimit({
  maxAttempts: 5,
  windowMs: 15 * 60 * 1000, // 15 minutes
});

export async function POST(req: NextRequest) {
  const rateLimitError = loginRateLimiter(req);
  if (rateLimitError) return rateLimitError;

  // ... login logic
}
```

---

### Production Rate Limiter (Redis)

```typescript
// lib/middleware/rate-limit-redis.ts
import { NextRequest, NextResponse } from 'next/server';
import { redis } from '@/lib/redis';

export async function rateLimit(
  req: NextRequest,
  options: { maxAttempts: number; windowMs: number }
) {
  const ip = req.ip || 'unknown';
  const key = `rate-limit:${ip}`;

  const requests = await redis.incr(key);
  
  if (requests === 1) {
    await redis.expire(key, Math.ceil(options.windowMs / 1000));
  }

  if (requests > options.maxAttempts) {
    return NextResponse.json(
      { error: 'Too many requests' },
      { status: 429, headers: { 'Retry-After': '900' } } // 15 min
    );
  }

  return null;
}
```

---

## Password Reset

### Request Reset Token

```typescript
// app/api/auth/forgot-password/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { randomBytes } from 'crypto';
import { db } from '@/lib/db';
import { sendEmail } from '@/lib/email';

export async function POST(req: NextRequest) {
  const { email } = await req.json();

  const user = await db.user.findUnique({ where: { email } });
  if (!user) {
    // Don't reveal if email exists (security)
    return NextResponse.json({ success: true });
  }

  // Generate cryptographic token
  const resetToken = randomBytes(32).toString('hex');
  const expiresAt = new Date(Date.now() + 15 * 60 * 1000); // 15 min

  await db.passwordResetToken.create({
    data: {
      token: resetToken,
      userId: user.id,
      expiresAt,
    },
  });

  // Send email with reset link
  await sendEmail({
    to: user.email,
    subject: 'Reset Password',
    html: `
      <p>Click link to reset password (expires in 15 minutes):</p>
      <a href="${process.env.APP_URL}/reset-password?token=${resetToken}">
        Reset Password
      </a>
    `,
  });

  return NextResponse.json({ success: true });
}
```

---

### Reset Password

```typescript
// app/api/auth/reset-password/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { hashPassword } from '@/lib/auth/password';
import { db } from '@/lib/db';

export async function POST(req: NextRequest) {
  const { token, newPassword } = await req.json();

  // Find valid token
  const resetToken = await db.passwordResetToken.findFirst({
    where: {
      token,
      expiresAt: { gt: new Date() },
      usedAt: null,
    },
    include: { user: true },
  });

  if (!resetToken) {
    return NextResponse.json(
      { error: 'Invalid or expired token' },
      { status: 400 }
    );
  }

  // Hash new password
  const hashedPassword = await hashPassword(newPassword);

  // Update password & mark token as used
  await db.$transaction([
    db.user.update({
      where: { id: resetToken.userId },
      data: { password: hashedPassword },
    }),
    db.passwordResetToken.update({
      where: { id: resetToken.id },
      data: { usedAt: new Date() },
    }),
  ]);

  return NextResponse.json({ success: true });
}
```

---

## Session Management

### Database Schema

```sql
-- Refresh tokens table
CREATE TABLE refresh_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  token TEXT NOT NULL UNIQUE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  expires_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  INDEX idx_user_id (user_id),
  INDEX idx_expires_at (expires_at)
);

-- Password reset tokens
CREATE TABLE password_reset_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  token TEXT NOT NULL UNIQUE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  expires_at TIMESTAMPTZ NOT NULL,
  used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  INDEX idx_token (token)
);
```

---

### Logout (Revoke Token)

```typescript
// app/api/auth/logout/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { db } from '@/lib/db';

export async function POST(req: NextRequest) {
  const refreshToken = req.cookies.get('refreshToken')?.value;

  if (refreshToken) {
    // Delete refresh token from database
    await db.refreshToken.deleteMany({
      where: { token: refreshToken },
    });
  }

  // Clear cookies
  const response = NextResponse.json({ success: true });
  response.cookies.delete('accessToken');
  response.cookies.delete('refreshToken');

  return response;
}
```

---

## Security Checklist

### Production Deployment

- [ ] **Environment variables**:
  - [ ] `JWT_SECRET` different from staging (min 64 chars random)
  - [ ] `JWT_REFRESH_SECRET` different from JWT_SECRET
  - [ ] `ENCRYPTION_KEY` for sensitive data (AES-256)
  
- [ ] **Password policy**:
  - [ ] Min 8 characters, 1 uppercase, 1 number
  - [ ] Argon2id or bcrypt cost ≥12
  - [ ] Password strength meter on frontend
  
- [ ] **Token security**:
  - [ ] Access token 15 minutes max
  - [ ] Refresh token 7 days max
  - [ ] HttpOnly, Secure, SameSite cookies
  
- [ ] **Rate limiting**:
  - [ ] Login: 5 attempts per 15 minutes
  - [ ] Password reset: 3 requests per hour
  - [ ] OTP: 10 requests per hour
  
- [ ] **Audit logging**:
  - [ ] Log failed login attempts (IP, timestamp)
  - [ ] Log password changes
  - [ ] Log token refresh events

---

## UU PDP Compliance

**UU PDP No. 27/2022 Requirements**:

1. **Data Minimization** (Article 16): Only store necessary user data
2. **Consent** (Article 20): User must agree to data processing
3. **Security** (Article 28): Implement encryption & access control
4. **Breach Notification** (Article 54): Report breaches within 72 hours

**Implementation**:
```typescript
// Store minimal user data
await db.user.create({
  data: {
    email,
    password: hashedPassword, // Never store plaintext
    consentGiven: true, // UU PDP consent
    consentDate: new Date(),
  },
});
```

---

## Testing

```typescript
// __tests__/auth/password.test.ts
import { describe, it, expect } from 'vitest';
import { hashPassword, verifyPassword } from '@/lib/auth/password';

describe('Password hashing', () => {
  it('hashes password securely', async () => {
    const password = 'SecurePass123';
    const hash = await hashPassword(password);
    
    expect(hash).not.toBe(password);
    expect(hash.length).toBeGreaterThan(50);
  });

  it('verifies correct password', async () => {
    const password = 'SecurePass123';
    const hash = await hashPassword(password);
    
    const valid = await verifyPassword(password, hash);
    expect(valid).toBe(true);
  });

  it('rejects incorrect password', async () => {
    const hash = await hashPassword('SecurePass123');
    const valid = await verifyPassword('WrongPass456', hash);
    
    expect(valid).toBe(false);
  });
});
```

---

## See Also

- `patterns/validation/zod-patterns.md` - Request validation
- `references/solo/SOLO_DEVELOPMENT_PATTERNS.md` - AES-256-GCM file encryption
- M06 Development Execution - Security checklist
