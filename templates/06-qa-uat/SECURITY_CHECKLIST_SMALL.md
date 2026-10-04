# Security Baseline Checklist (Small Scale)

> **Target**: Solo MVP / Small projects (<Rp 50M, 1-3 months)  
> **Duration**: 1-2 hours  
> **When**: After M06 (Development), before M09 (UAT)  
> **Purpose**: Prevent common vulnerabilities without full security audit

---

## Checklist (10 Critical Items)

### 1. Password Security
- [ ] **Password hashing**: Bcrypt/Argon2 used (NOT plain text, NOT MD5)
  ```javascript
  // ✅ Correct
  const bcrypt = require('bcrypt');
  const hashedPassword = await bcrypt.hash(password, 10);
  
  // ❌ Wrong
  const hashedPassword = md5(password);
  ```
- [ ] **Min length enforced**: 8+ characters minimum
- [ ] **No password in logs**: Verify logs don't contain passwords

---

### 2. HTTPS Enforcement
- [ ] **Production uses HTTPS**: No HTTP-only deployment
- [ ] **Force HTTPS redirect**: HTTP → HTTPS automatic redirect
- [ ] **Localhost exception**: Development on `http://localhost` OK

**Verification**:
```bash
# Check deployment
curl -I https://yourdomain.com
# Should return: HTTP/2 200 or HTTP/1.1 200
```

---

### 3. SQL Injection Prevention
- [ ] **Parameterized queries**: NO string concatenation in SQL
  ```javascript
  // ✅ Correct (parameterized)
  db.query('SELECT * FROM users WHERE email = ?', [email]);
  
  // ❌ Wrong (vulnerable)
  db.query(`SELECT * FROM users WHERE email = '${email}'`);
  ```
- [ ] **ORM used correctly**: Prisma/Sequelize/TypeORM with prepared statements

---

### 4. XSS (Cross-Site Scripting) Prevention
- [ ] **User input escaped**: HTML special chars escaped before display
- [ ] **React/Vue auto-escape**: Framework default escaping NOT bypassed
- [ ] **No `dangerouslySetInnerHTML`**: Avoid unless absolutely necessary

**Test**:
```javascript
// Try submitting: <script>alert('XSS')</script>
// Should display as text, NOT execute
```

---

### 5. CSRF Protection
- [ ] **CSRF tokens**: Forms have anti-CSRF tokens (Next.js middleware, Laravel Sanctum)
- [ ] **SameSite cookies**: Session cookies use `SameSite=Lax` or `Strict`

**Next.js example**:
```javascript
// middleware.ts
export { default } from "next-auth/middleware";
export const config = { matcher: ["/dashboard/:path*"] };
```

---

### 6. Environment Variables
- [ ] **No secrets in code**: API keys/DB passwords in `.env`, NOT hardcoded
- [ ] **`.env` in `.gitignore`**: Verify `.env` NOT committed to Git
- [ ] **Production env separate**: `.env.production` different from `.env.local`

**Check Git history**:
```bash
git log --all --full-history -- .env
# Should return: nothing (no .env commits)
```

---

### 7. Rate Limiting
- [ ] **Login rate limit**: Max 5 attempts per IP per 15 minutes
- [ ] **API rate limit**: 100 requests per IP per minute (adjust per needs)

**Vercel example**:
```typescript
import { Ratelimit } from "@upstash/ratelimit";
const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(10, "10 s"),
});
```

---

### 8. Authentication Session Security
- [ ] **Session expiry**: Sessions expire after inactivity (30 min default)
- [ ] **Secure cookies**: `httpOnly=true`, `secure=true` in production
- [ ] **Logout clears session**: Logout actually invalidates server session

---

### 9. File Upload Security (if applicable)
- [ ] **File type validation**: Accept only allowed extensions (`.jpg`, `.png`, `.pdf`)
- [ ] **File size limit**: Max 5MB per file (adjust per needs)
- [ ] **Virus scan**: Use ClamAV or cloud service (conditional, if high risk)

**Example**:
```javascript
const allowedTypes = ['image/jpeg', 'image/png', 'application/pdf'];
if (!allowedTypes.includes(file.type)) {
  throw new Error('Invalid file type');
}
```

---

### 10. Dependency Security
- [ ] **No critical vulnerabilities**: Run `npm audit` or `pnpm audit`
- [ ] **Dependencies updated**: Major packages on recent versions
- [ ] **Auto-updates enabled**: Dependabot/Renovate configured (optional)

**Check**:
```bash
npm audit --production
# Fix critical/high: npm audit fix
```

---

## Sign-Off

**Security baseline verified by**: ___________________________  
**Date**: ___________________________  
**Notes**: ___________________________

---

## When to Escalate

Escalate to full M07 Security Audit if:
- Payment processing (credit cards, e-wallets)
- Healthcare/financial data (HIPAA, PDP Law compliance)
- User-generated content (social media, forums)
- Admin panel with sensitive operations

For full audit, see `templates/06-qa-uat/SECURITY_AUDIT_TEMPLATE.md`.
