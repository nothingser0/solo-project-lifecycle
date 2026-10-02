# System User Manual

> Practical operational guide for staff and administrators in utilizing software application features daily.

---

## 1. System Information & Access
- **Application Name**: [Application Name]
- **Official URL**: `https://app.client.com`
- **Supported Browsers**: Google Chrome, Safari, Microsoft Edge, Mozilla Firefox (Latest 2 major versions).

---

## 2. Login & Account Security Guide
1. Open `https://app.client.com/login`.
2. Enter work email address and password registered by the Administrator.
3. Click the **"Sign In"** button.
4. *Security Tip*: Never share your password with anyone. Always click **"Log Out"** after finishing work on a shared computer.

---

## 3. Staff Operational Guide (Core Features)

### 3.1 Creating a New Legal Document
1. Navigate to the **"Document Management"** menu in the left navigation sidebar.
2. Click the **"Create New Document"** button in the top right corner.
3. Select the desired template (e.g., *Freelance Agreement*).
4. Complete the input form:
   - Full names of all parties.
   - Compensation value (enter numbers only without dots/commas, system automatically formats currency).
   - Contract start and end dates.
5. Click **"Preview Document"** to verify that clause contents are accurate.
6. Click **"Save Draft"** or **"Send Signature Request"**.

### 3.2 Sending Digital Signature Links
1. Open the details of a document with status `DRAFT`.
2. Enter the name and email address of the signer.
3. Click **"Send Signing Email"**.
4. The document status will automatically update to `PENDING SIGNATURE`.

---

## 4. Administrator Guide (Management Features)

### 4.1 Adding New User Accounts
1. Navigate to **"Settings"** $\to$ **"User Management"**.
2. Click the **"Add User"** button.
3. Enter name, email, and select role (*Role*):
   - **Staff**: Can only create and view own document drafts.
   - **Manager**: Can approve drafts and send official signature links.
   - **Super Admin**: Full access to all data and system audit logs.
4. Click **"Send Account Invitation"**. A temporary password will be automatically emailed to the new user.

### 4.2 Viewing Audit Trail Logs
1. Navigate to the **"Audit Trail"** menu.
2. All document creation activities, signature timestamps, IP addresses, and SHA-256 hash values are permanently recorded and can be downloaded in Excel format via the **"Export Report"** button.

---

## 5. Frequently Asked Questions & Support (FAQ)
- **What if I forget my password?**
  Click the *"Forgot Password"* link on the login page, enter your email address, and follow the reset instructions sent to your inbox.
- **Why can't the signature link be opened?**
  Digital signature links have a 7-day security expiration window. If expired, staff can issue a fresh link via the *"Resend Link"* button in the document details.
