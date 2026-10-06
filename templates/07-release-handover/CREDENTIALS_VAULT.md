# Credentials Vault Setup Guide

> **Purpose**: Secure credential handover to client (M11)  
> **When**: Production deployment, before final handover  
> **Duration**: 30 minutes setup  
> **Tools**: 1Password / Bitwarden (recommended)

---

## Why Use a Password Manager?

**Problems with insecure methods**:
- ❌ Email: Plaintext, searchable, forwarded, hacked
- ❌ WhatsApp: No expiry, screenshot, device compromise
- ❌ Spreadsheet: Shared widely, version chaos
- ❌ Sticky notes: Lost, stolen, photographed

**Password manager benefits**:
- ✅ Encrypted storage
- ✅ Secure sharing (expiring links)
- ✅ Audit trail (who accessed what)
- ✅ Easy rotation (change passwords centrally)
- ✅ No plaintext exposure

---

## Recommended Tools

### Option 1: 1Password (Paid, Enterprise-Grade)

**Pros**:
- Best UX, most polished
- Secure Send (temporary sharing)
- Guest access (free for recipients)
- Travel Mode (hide vaults at border)

**Cons**:
- Paid ($7.99/month per user)

**Best for**: Professional handover, client with budget

**Sign up**: https://1password.com

---

### Option 2: Bitwarden (Free, Open Source)

**Pros**:
- Free tier generous (unlimited passwords, 2 users)
- Open source (audited)
- Send feature (temporary sharing)
- Self-hostable

**Cons**:
- UX less polished than 1Password
- Free tier has 1GB file storage limit

**Best for**: Budget projects, solo devs, open-source preference

**Sign up**: https://bitwarden.com

---

### Option 3: Google Password Manager (Free, Simple)

**Pros**:
- Free
- Built into Chrome
- Zero setup

**Cons**:
- No secure sharing feature (must export CSV = insecure)
- No audit trail
- Less secure than dedicated tools

**Best for**: Personal use only, NOT client handover

---

## Setup: 1Password (Recommended)

### Step 1: Create Account (5 min)

1. Go to https://1password.com/sign-up
2. Choose "Families" plan ($4.99/month, up to 5 users)
3. Create master password (STRONG, you can't recover this)
4. Save Emergency Kit PDF (print or store securely)

---

### Step 2: Create Vault for Client (2 min)

1. Open 1Password app
2. Click "+ New Vault"
3. Name: `[Client Name] - [Project Name]`
4. Icon: Choose client logo or project icon
5. Click "Create"

---

### Step 3: Add Credentials (10 min)

**For each service, add item**:

1. Click "+ New Item" in vault
2. Choose type: Login / Server / Database / API Credential
3. Fill details (see template below)
4. Save

**Credential Types**:

#### Production Website Login
```
Title: Production Admin Login
Type: Login
URL: https://app.client.com/admin
Username: admin@client.com
Password: [generate strong password]
Notes: Admin panel access
```

#### Staging Website Login
```
Title: Staging Admin Login
Type: Login
URL: https://staging.app.client.com/admin
Username: admin@client.com
Password: [same or different]
Notes: For testing before production deploy
```

#### Database Credentials
```
Title: Production Database
Type: Database
Server: db.example.com
Port: 5432
Database: production_db
Username: prod_user
Password: [generate strong password]
Notes: PostgreSQL production database
```

#### API Keys
```
Title: Stripe API Key
Type: API Credential
API Key: sk_live_xxxxx
API Secret: [if applicable]
Webhook Secret: whsec_xxxxx
Notes: Payment processing (live mode)
```

#### Hosting/Cloud Provider
```
Title: Vercel Account
Type: Login
URL: https://vercel.com
Email: client@example.com
Password: [client's password or shared]
Notes: Project: project-name, Team: team-name
```

#### Email Service
```
Title: SendGrid API Key
Type: API Credential
API Key: SG.xxxxx
Notes: Email notifications, 100k emails/month plan
```

#### Domain/DNS
```
Title: Cloudflare Account
Type: Login
URL: https://dash.cloudflare.com
Email: client@example.com
Password: [generate]
Notes: Domain: example.com, Nameservers: ns1.cloudflare.com
```

#### Git Repository
```
Title: GitHub Repository Access
Type: Login
URL: https://github.com/client/repo-name
Username: client-dev
Password: [or Personal Access Token]
Notes: Repository: private, Branch: main
```

---

### Step 4: Share Vault with Client (5 min)

**Option A: Invite Client to 1Password** (Best)

1. Click vault → "Manage Access"
2. Click "Invite People"
3. Enter client email
4. Choose permission: "Can view" or "Can edit"
5. Send invite
6. Client receives email, creates free 1Password account, accesses vault

**Option B: Use 1Password Send** (Temporary)

1. Select item → Click "Share"
2. Click "Get a Shareable Link"
3. Set expiration: 7 days (or 30 days for long handover)
4. Set view limit: 1 view or 10 views
5. Copy link, send to client via email
6. Link expires after time/views

**Recommendation**: Option A (permanent access), Option B (one-time handover)

---

## Setup: Bitwarden (Free Alternative)

### Step 1: Create Account (5 min)

1. Go to https://bitwarden.com/sign-up
2. Create master password
3. Verify email
4. Enable 2FA (recommended)

---

### Step 2: Create Organization (for sharing)

1. Open Bitwarden web vault
2. Click "New Organization"
3. Name: `[Client Name] Project`
4. Choose "Free" plan (2 users, unlimited items)
5. Create organization

---

### Step 3: Add Credentials

1. Click "+ Add Item"
2. Choose type: Login / Card / Identity / Secure Note
3. Fill details (same template as 1Password above)
4. Assign to organization folder
5. Save

---

### Step 4: Share with Client

**Option A: Invite to Organization** (Best)

1. Organization → "Manage" → "People"
2. Click "Invite User"
3. Enter client email
4. Set role: "User" (read-only)
5. Send invite
6. Client creates free Bitwarden account, accepts invite

**Option B: Use Bitwarden Send** (Temporary)

1. Click "Send" → "Create a Send"
2. Choose "Text" or "File"
3. Paste credentials or attach file
4. Set expiration: 7 days
5. Set max access count: 1
6. Create and copy link
7. Send link to client via email

---

## Credential Handover Checklist

### Before Handover

- [ ] All production credentials tested (can login)
- [ ] All staging credentials tested
- [ ] API keys verified (not expired, correct permissions)
- [ ] Database credentials work (can connect)
- [ ] Strong passwords generated (20+ chars, mixed)
- [ ] 2FA enabled where possible (production admin, hosting)

### During Handover

- [ ] Credentials added to vault
- [ ] Vault shared with client (1Password/Bitwarden)
- [ ] Client confirms access (can view credentials)
- [ ] Handover email sent (see template below)

### After Handover

- [ ] Client changes passwords (recommended within 7 days)
- [ ] Remove your access if project complete
- [ ] Archive vault (for reference during warranty)

---

## Handover Email Template

```
Subject: Credentials Handover - [Project Name]

Hi [Client Name],

Your production system is live! Here are the credentials.

SECURE CREDENTIAL VAULT:
I've set up a 1Password vault with all credentials:
- Production admin login
- Staging admin login
- Database access
- API keys (Stripe, SendGrid, etc.)
- Hosting (Vercel)
- Domain/DNS (Cloudflare)
- Git repository

ACCESS:
Check your email for 1Password invite.
1. Click "Accept Invitation"
2. Create free 1Password account (or use existing)
3. Access vault: "[Client Name] - [Project Name]"

CREDENTIALS INCLUDED:
✅ Production: https://app.client.com/admin
✅ Staging: https://staging.app.client.com/admin
✅ Database: PostgreSQL (connection details in vault)
✅ API Keys: Stripe, SendGrid (in vault)
✅ Hosting: Vercel project access
✅ Domain: Cloudflare DNS management
✅ Source Code: GitHub repository

IMPORTANT:
1. Change all passwords within 7 days (recommended)
2. Enable 2FA on critical accounts (production admin, hosting)
3. Do NOT share credentials via email/WhatsApp
4. Keep master password secure (1Password can't recover it)

DURING WARRANTY (30 days):
- I still have view access (for support)
- After warranty: I'll remove my access

Questions? Reply to this email.

Best,
[Your Name]
```

---

## Security Best Practices

### Password Strength

**Weak** (DON'T):
- `password123`
- `admin2024`
- `client@123`

**Strong** (DO):
- `T9$mK2#pL5@nQ8^vR3&hX7!`
- Use password generator (1Password/Bitwarden built-in)
- 20+ characters, mixed case, numbers, symbols

---

### 2FA (Two-Factor Authentication)

**Enable 2FA on**:
- ✅ Production admin login (critical)
- ✅ Hosting/cloud provider (Vercel, AWS, DigitalOcean)
- ✅ Domain registrar (Cloudflare, Namecheap)
- ✅ Payment gateway (Stripe dashboard)
- ✅ Email service (SendGrid, Mailgun)

**2FA Apps**:
- Google Authenticator
- Authy (recommended - cloud backup)
- 1Password (built-in TOTP generator)

---

### Credential Rotation

**Change passwords**:
- ✅ After handover (client takes ownership)
- ✅ After employee leaves (revoke access)
- ✅ After suspected breach (immediate)
- ✅ Every 90 days (best practice, optional)

**How to rotate**:
1. Generate new password in 1Password
2. Update in production system
3. Update in vault
4. Test login
5. Notify team

---

## Common Mistakes

### Mistake 1: Email Passwords in Plaintext
**Problem**: Email hacked = credentials exposed  
**Fix**: Use 1Password Send or share vault

### Mistake 2: Shared Generic Passwords
**Problem**: `admin123` used everywhere  
**Fix**: Unique strong password per service

### Mistake 3: No Backup Master Password
**Problem**: Forgot master password = locked out forever  
**Fix**: Print Emergency Kit, store in safe

### Mistake 4: No 2FA
**Problem**: Password leaked = account compromised  
**Fix**: Enable 2FA on critical accounts

### Mistake 5: Client Loses Access
**Problem**: Client forgot master password  
**Fix**: Can't recover. Re-share credentials via 1Password Send

---

## Credential Types Reference

### Website Logins
- Production admin
- Staging admin
- User test accounts

### Infrastructure
- Hosting (Vercel, AWS, DigitalOcean)
- Database (PostgreSQL, MySQL, MongoDB)
- CDN (Cloudflare, CloudFront)
- Domain registrar (Namecheap, GoDaddy)

### Third-Party Services
- Payment (Stripe, PayPal)
- Email (SendGrid, Mailgun, AWS SES)
- SMS (Twilio, Vonage)
- Storage (AWS S3, Google Cloud Storage)
- Analytics (Google Analytics, Mixpanel)

### Developer Tools
- Git repository (GitHub, GitLab, Bitbucket)
- CI/CD (GitHub Actions, CircleCI)
- Error tracking (Sentry, Rollbar)
- Monitoring (Datadog, New Relic)

### Social/Marketing
- Social media accounts (if managing)
- Google My Business
- Facebook Business Manager

---

## Cost Comparison

| Tool | Free Tier | Paid Tier | Best For |
|:-----|:----------|:----------|:---------|
| 1Password | No | $7.99/month | Professional, best UX |
| Bitwarden | Yes (2 users) | $10/year | Budget, open source |
| LastPass | Yes (1 device) | $3/month | Personal use |
| Dashlane | Yes (50 passwords) | $4.99/month | Personal use |
| Google Password Manager | Yes | N/A | Personal, NOT for sharing |

**Recommendation**: 
- Professional projects: 1Password
- Budget projects: Bitwarden Free
- Personal use only: Google Password Manager

---

## Integration with Workflow

**M10 Production Deploy**:
- Generate all production credentials
- Add to vault (1Password/Bitwarden)
- Test all credentials work

**M11 Handover**:
- Share vault with client
- Send handover email (template above)
- Client confirms access
- Sign BAST

**M12 Warranty**:
- Keep view access during warranty (for support)
- After warranty ends: Remove your access or archive vault

---

## Checklist

Setup:
- [ ] Choose tool (1Password or Bitwarden)
- [ ] Create vault/organization
- [ ] Generate strong passwords (20+ chars)
- [ ] Add all credentials (prod, staging, API keys, etc.)
- [ ] Test each credential works

Share:
- [ ] Invite client to vault (Option A) or use Send (Option B)
- [ ] Client confirms access
- [ ] Handover email sent
- [ ] Client advised to change passwords within 7 days

Security:
- [ ] 2FA enabled on critical accounts
- [ ] Emergency Kit backed up (master password recovery)
- [ ] Credentials not sent via email/WhatsApp
- [ ] Access reviewed quarterly

---

## Support

**If client loses access**:
1. Can't recover master password (1Password/Bitwarden can't help)
2. Re-share credentials via 1Password Send (temporary)
3. Client creates new vault with new master password
4. Advise to print Emergency Kit this time

**If credential compromised**:
1. Immediately change password in production system
2. Update vault
3. Investigate breach source
4. Enable 2FA if not already
5. Notify client

---

## Notes

**Password manager is non-negotiable**: Never send credentials via email/WhatsApp/Slack

**Client unfamiliar with password managers**: Schedule 15-min call to walk through setup

**Enterprise clients**: May have their own password manager (e.g., 1Password Business). Ask first.

**Warranty period**: Keep view access for support, remove after warranty ends.
