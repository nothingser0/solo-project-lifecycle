# Edge Security, DDoS Mitigation, & WAF Protection (Cloudflare Pattern)

> **Scope**: Standard architectural pattern for protecting solo developer production deployments against Layer 3/4/7 DDoS attacks, automated credential stuffing, bot scraping, and third-party API billing shocks.

---

## 1. Threat Model for Solo Developers

As a solo developer, you lack a 24/7 dedicated Security Operations Center (SecOps). Your infrastructure is uniquely vulnerable to three catastrophic edge risks:

1. **Service Disruption (DDoS)**: Volumetric floods (UDP/SYN) or application floods (HTTP GET/POST storms) that exhaust server CPU, memory, or database connection pools (`max_connections`).
2. **Third-Party API Billing Shock**: Automated bots spamming expensive endpoints:
   - LLM / AI inference endpoints (`/api/ai/*`)
   - SMS / WhatsApp OTP endpoints (`/api/auth/otp`)
   - Transactional email endpoints (`/api/auth/reset-password`)
   - Media upload endpoints causing cloud storage bandwidth overages
3. **Origin IP Bypass**: Attackers discovering your direct VPS / host IP and bypassing edge firewalls entirely.

---

## 2. Cloudflare Edge Architecture

```text
[ End-User / Browser ]
          │
          ▼
┌─────────────────────────────────────────────────────────────┐
│ Cloudflare Global Anycast Edge Network                      │
│                                                             │
│ 1. L3/L4 DDoS Mitigation (Automated SYN/UDP Flood Scrub)    │
│ 2. Web Application Firewall (WAF Rules & Managed Ruleset)   │
│ 3. Edge Rate Limiting (Sensitive Endpoints & Token Buckets) │
│ 4. Cloudflare Turnstile (Frictionless Bot Challenge)        │
│ 5. Full (Strict) SSL/TLS Encryption                         │
└──────────────────────────────┬──────────────────────────────┘
                               │ Authenticated Origin Pulls (AOP)
                               │ or Cloudflare Tunnel (cloudflared)
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ Origin Server (VPS / Vercel / Railway / Docker Monolith)    │
│                                                             │
│ • Firewall (UFW / Security Group): Drop all non-CF traffic  │
│ • Reverse Proxy (Nginx / Caddy): Trust CF-Connecting-IP     │
│ • App Application: Real Client IP in structured audit logs  │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Mandatory Edge Security Rules (Baseline Setup)

### 3.1 DNS Proxying & Origin Masking
- Enable **Orange Cloud (Proxied)** on all public-facing records (`@`, `www`, `api`).
- Never expose direct server IP in MX records or public subdomains (use third-party transactional mail like Resend/SendGrid via CNAME).

### 3.2 SSL/TLS Encryption
- **Encryption Mode**: Enforce **Full (Strict)**. Never use *Flexible* (vulnerable to man-in-the-middle attacks between Cloudflare and Origin).
- **HSTS (HTTP Strict Transport Security)**: Enable with `max-age=31536000; includeSubDomains; preload`.
- **Minimum TLS Version**: Enforce **TLS 1.2** or **TLS 1.3**.

### 3.3 Authenticated Origin Protection (Preventing Direct IP Attacks)
Attackers can scan IPv4 ranges looking for your host headers. Prevent direct origin hits using one of two methods:

- **Method A (Recommended: Cloudflare Tunnel)**:
  Run `cloudflared` daemon on your host/container. No inbound public ports (80/443) are open to the internet. Traffic routes purely through outbound tunnels.
- **Method B (Firewall Whitelist + Authenticated Origin Pulls)**:
  If running raw VPS with public IP, configure UFW / Security Group to accept ports 80/443 **strictly** from official Cloudflare IP ranges (`https://www.cloudflare.com/ips/`), dropping all other traffic.

---

## 4. WAF & Rate Limiting Ruleset (Copy-Paste Configurations)

Configure these custom WAF rules in Cloudflare Dashboard:

### Rule 1: High-Risk Endpoint Rate Limiting (Billing Shock Guardrail)
Protects AI, OTP, and Auth routes from automated abuse:
- **Condition**: `(http.request.uri.path contains "/api/auth/otp") or (http.request.uri.path contains "/api/ai/") or (http.request.uri.path contains "/api/v1/checkout")`
- **Action**: Rate Limit
- **Threshold**: 10 requests per 1 minute per IP address.
- **Mitigation Action**: Managed Challenge (Cloudflare Turnstile) or 429 Too Many Requests response.

### Rule 2: Bot Fight Mode & Security Level
- Turn on **Bot Fight Mode** (Free tier) or **Super Bot Fight Mode** (Pro tier).
- Set **Security Level** to **Medium** (automatically raises challenge threshold during recognized distributed attack waves).

### Rule 3: Restrict Sensitive Admin Routes
- **Condition**: `(http.request.uri.path starts_with "/admin") or (http.request.uri.path starts_with "/internal")`
- **Action**: Managed Challenge or Cloudflare Zero Trust Access (require developer email OTP before reaching origin).

---

## 5. Application Code Integration: Restoring Real Client IP

When traffic is proxied through Cloudflare, your backend sees Cloudflare's IP address by default. You **MUST** restore the original client IP for rate limiting and audit logging.

### Nginx Configuration
```nginx
# /etc/nginx/conf.d/cloudflare.conf
# Include official Cloudflare IP ranges:
set_real_ip_from 173.245.48.0/20;
set_real_ip_from 103.21.244.0/22;
set_real_ip_from 103.22.200.0/22;
set_real_ip_from 103.31.4.0/22;
set_real_ip_from 141.101.64.0/18;
set_real_ip_from 108.162.192.0/18;
set_real_ip_from 190.93.240.0/20;
set_real_ip_from 188.114.96.0/20;
set_real_ip_from 197.234.240.0/22;
set_real_ip_from 198.41.128.0/17;
set_real_ip_from 162.158.0.0/15;
set_real_ip_from 104.16.0.0/13;
set_real_ip_from 104.24.0.0/14;
set_real_ip_from 172.64.0.0/13;
set_real_ip_from 131.0.72.0/22;

real_ip_header CF-Connecting-IP;
```

### Node.js / Next.js Middleware / Express Example
```typescript
export function getClientIp(req: Request): string {
  // Cloudflare injects the verified client IP in CF-Connecting-IP header
  const cfIp = req.headers.get("cf-connecting-ip");
  if (cfIp) return cfIp;

  // Fallback to standard forwarded header
  const forwarded = req.headers.get("x-forwarded-for");
  return forwarded ? forwarded.split(",")[0].trim() : "127.0.0.1";
}
```

---

## 6. Pre-Launch Verification Checklist

Before taking production traffic live (M10):
- [ ] Domain nameservers routed through Cloudflare; Orange Cloud proxy enabled.
- [ ] SSL/TLS set to **Full (Strict)**; HTTPS redirect enabled.
- [ ] Rate limiting rule configured for `/api/auth/*` and mutation/inference routes.
- [ ] Backend logging verified to print real client IP from `CF-Connecting-IP`, not Cloudflare proxy IPs.
- [ ] Direct VPS IP blocked from public access (via UFW or Cloudflare Tunnel).
