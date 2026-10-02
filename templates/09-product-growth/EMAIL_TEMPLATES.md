# Email Templates Library

Collection of email templates for onboarding, transactional, and re-engagement. All templates use plain text and responsive HTML (mobile-first) formats.

---

## 1. Onboarding Drip Campaign

### Email 1: Welcome Email (Day 0 — Sent Immediately After Signup)

**Subject:** `Welcome to [Product Name]! 🎉`

**Plain Text:**
```
Hi [First Name],

Welcome to [Product Name]!

We're thrilled to have you join us. Here is your first step to get started:

1. [Primary CTA Action] — [Link]
   Example: Complete your profile — https://app.example.com/onboarding

2. [Secondary Benefit]
   Example: Access the 5-minute video tutorial on your dashboard

Need help? Reply to this email or contact support@example.com

Best regards,
[Founder Name]
Founder, [Product Name]

---
PS: Save this email — your activation link is here.
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
              <h1 style="margin: 0 0 20px; font-size: 24px; font-weight: 600; color: #111827;">Welcome, [First Name]! 🎉</h1>
              
              <p style="margin: 0 0 20px;">Thank you for signing up for [Product Name]. We're excited to help you [value proposition].</p>
              
              <p style="margin: 0 0 20px; font-weight: 600;">First step:</p>
              
              <!-- CTA Button -->
              <table width="100%" cellpadding="0" cellspacing="0" style="margin: 0 0 20px;">
                <tr>
                  <td align="center">
                    <a href="https://app.example.com/onboarding" style="display: inline-block; padding: 14px 28px; background-color: #0891B2; color: #ffffff; text-decoration: none; border-radius: 6px; font-weight: 600; font-size: 16px;">Complete Your Profile →</a>
                  </td>
                </tr>
              </table>
              
              <p style="margin: 0 0 20px; font-size: 14px; color: #6B7280;">Or access the 5-minute video tutorial on <a href="https://app.example.com/dashboard" style="color: #0891B2; text-decoration: none;">your dashboard</a>.</p>
              
              <hr style="border: 0; border-top: 1px solid #E5E7EB; margin: 30px 0;">
              
              <p style="margin: 0; font-size: 14px; color: #6B7280;">Need help? Reply to this email or contact <a href="mailto:support@example.com" style="color: #0891B2; text-decoration: none;">support@example.com</a></p>
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

**Subject:** `[First Name], complete this step to [benefit] 🚀`

**Plain Text:**
```
Hi [First Name],

We noticed you haven't [key action, e.g., "added your first data entry"].

Here's why this matters:
✓ [Benefit 1]
✓ [Benefit 2]
✓ [Benefit 3]

It only takes 2 minutes:
[CTA Link] → https://app.example.com/[action]

Need guidance? Read this article: [Tutorial Link]

Best regards,
[Founder Name]
```

**HTML Version:** (Similar structure to Email 1, highlight benefits with checkmarks)

---

### Email 3: Feature Discovery (Day 5 — Educate Power Features)

**Subject:** `3 features you haven't tried in [Product Name] 💡`

**Plain Text:**
```
Hi [First Name],

Getting comfortable with [Product Name]? Check out these 3 features:

1️⃣ [Feature Name]: [1-sentence benefit]
   Tutorial: [Link]

2️⃣ [Feature Name]: [1-sentence benefit]
   Tutorial: [Link]

3️⃣ [Feature Name]: [1-sentence benefit]
   Tutorial: [Link]

Have questions? Reply to this email — I read every response.

Best regards,
[Founder Name]
```

---

## 2. Transactional Emails

### Password Reset

**Subject:** `Reset your password for [Product Name]`

**Plain Text:**
```
Hi [First Name],

We received a request to reset your account password.

Click this link to create a new password (valid for 1 hour):
[Reset Link]

If you didn't request a password reset, you can safely ignore this email.

Best regards,
The [Product Name] Team

---
For security, this link can only be used once and expires in 1 hour.
```

**HTML Version:** (Simple layout, prominent CTA button, security note)

---

### Invoice / Receipt

**Subject:** `Payment received — Invoice #[Invoice Number]`

**Plain Text:**
```
Hi [First Name],

Thank you for your payment!

PAYMENT SUMMARY:
- Plan: [Plan Name]
- Amount: Rp[Amount]
- Method: [Payment Method]
- Date: [Date]
- Invoice: #[Invoice Number]

Download full invoice: [Link]

Active period: [Start Date] - [End Date]

Questions? Contact billing@example.com

Best regards,
The [Product Name] Team
```

---

### Account Suspended (Payment Failed)

**Subject:** `[URGENT] Your account will be deactivated in 3 days`

**Plain Text:**
```
Hi [First Name],

Your latest payment could not be processed.

Details:
- Amount Due: Rp[Amount]
- Due Date: [Due Date]
- Payment Method: [Method] (...[Last 4 Digits])

To avoid account deactivation, please update your payment method:
[Update Payment Method Link]

Need help? Reply to this email.

Best regards,
The [Product Name] Team
```

---

## 3. Re-Engagement Campaign

### Trial Expiry (3 Days Before End)

**Subject:** `Your trial ends in 3 days — Upgrade now 🎯`

**Plain Text:**
```
Hi [First Name],

Your trial ends on [Date] (3 days left).

Your stats during the trial:
✓ [Metric 1, e.g., "15 reports generated"]
✓ [Metric 2, e.g., "Rp1.2 million tax saved"]

Continue unlimited access:
[Upgrade Link] → Starting from Rp99,000/month

Questions before upgrading? Reply to this email.

Best regards,
[Founder Name]
```

---

### Churned User (30 Days After Last Login)

**Subject:** `We miss you, [First Name] — How can we help? 💬`

**Plain Text:**
```
Hi [First Name],

It's been 30 days since you last logged in to [Product Name].

We'd love to know:
- Ran into technical issues?
- Missing a feature you need?
- Pricing wasn't right?

Reply to this email and let us know — your feedback is invaluable.

As a thank you, here is 20% off if you reactivate this month:
Code: COMEBACK20

Best regards,
[Founder Name]

PS: Not interested anymore? [Unsubscribe link]
```

---

## 4. Announcement / Update Emails

### New Feature Launch

**Subject:** `[NEW] [Feature Name] is now live on [Product Name] 🚀`

**Plain Text:**
```
Hi [First Name],

We just launched a highly requested feature: [Feature Name]!

What you can do:
✓ [Capability 1]
✓ [Capability 2]
✓ [Capability 3]

Try it now: [Link to Feature]
Full tutorial: [Doc Link]

Questions? Reply to this email.

Best regards,
[Founder Name]
```

---

## 5. Best Practices (Email Deliverability & Engagement)

### Technical Setup
- **SPF, DKIM, DMARC:** Required configuration for deliverability (avoid spam folder)
- **Dedicated Sending Domain:** Use a subdomain (e.g., `mail.yourdomain.com`) for transactional emails
- **Warm-up Schedule:** Don't send 10,000 emails right away — start at 50/day and ramp up gradually
- **List Hygiene:** Prune hard bounces and inactive users monthly

### Copywriting Guidelines
- **Subject Line:** Max 50 characters, avoid spam trigger words ("FREE!!!", "BUY NOW"), test emojis
- **Preheader Text:** 90 characters visible in inbox preview — use to reinforce subject line
- **Personalization:** At least `[First Name]`, ideally include behavioral context (`"You haven't completed X"`)
- **CTA:** One primary CTA per email, high-contrast button color
- **Footer:** Unsubscribe link required (comply with CAN-SPAM Act)

### A/B Testing Priority
1. Subject line (largest impact on open rate)
2. CTA button text & color
3. Send time (morning vs afternoon, weekday vs weekend)
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
    subject: `Welcome to [Product Name]! 🎉`,
    text: `Hi ${firstName},\n\nWelcome to [Product Name]!...`,
    html: `<html>...</html>`, // Use template from above
  };

  await sgMail.send(msg);
}
```

---

## 7. Internationalization (i18n)

For multi-language projects, store email templates in JSON using this structure:

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
- Explicit opt-in checkbox required at signup (never pre-checked)
- Unsubscribe link must be visible & functional
- Store consent records (user, timestamp, IP, context)

### GDPR (EU Users)
- Double opt-in for marketing emails
- Right to access: users can request all their email data
- Right to erasure: users can request deletion from mailing lists

---

**These templates can be customized to match your brand voice and industry.**
