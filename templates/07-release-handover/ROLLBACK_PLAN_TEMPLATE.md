# Emergency Recovery Plan (Rollback & Break-Glass Plan)

> Emergency procedure to abort a release and restore the system to its previous stable state in under 15 minutes in the event of a fatal failure during go-live.

---

## 1. Rollback Triggers

The Rollback procedure **MUST BE EXECUTED IMMEDIATELY** if any of the following conditions occur post-release:
1. Database migration script fails mid-execution causing data corruption.
2. Request error rate (*500 Error Rate*) $> 5\%$ within the first 15 minutes.
3. System response latency (*p95 Latency*) spikes above $2,000\text{ ms}$ (2 seconds).
4. Core transactional flows (e.g., payment or document encryption) suffer total failure.

---

## 2. Rapid Recovery Action Sequence (The 15-Minute Rollback)

### Step 1: Revert Application Code to Previous Stable Version
If using Vercel / Railway / Cloud Run:
- Open cloud hosting dashboard $\to$ Select previous stable deployment $\to$ Click **"Rollback / Promote to Production"** (Execution time: $< 1\text{ minute}$).

If using Git & manual Docker:
```bash
# Checkout to previous release tag (e.g., v0.9.5)
git checkout v0.9.5
docker build -t app:v0.9.5 .
docker stop app-current && docker rm app-current
docker run -d --name app-current -p 3000:3000 app:v0.9.5
```

### Step 2: Database Restore
If database schema is corrupted due to failed migration:
```bash
# Temporarily halt database connections
# Restore data from pre-deployment snapshot backup:
pg_restore -U postgres -d [database_name]_prod -c "backup-pre-deploy-[DATE].dump"
```

### Step 3: Post-Rollback System Verification
- Open `https://app.client.com/api/health` $\to$ Confirm `200 OK` response.
- Verify users can log in again using the previous stable version.

---

## 3. Emergency Communication Template to Client Single PIC

If rollback procedure must be executed:

> *"Good day [Client PIC Name], this is to inform you that during the system release process at [Time], we detected an anomaly in [specify issue, e.g., database synchronization] causing latency to exceed our tolerance threshold.*
>
> *To safeguard data integrity and your company's operational continuity, per our standard operating procedures we have triggered the rollback protocol to the previous stable version. The system is currently restored to normal and safe for use. We are analyzing the root cause and will reschedule the deployment once the fix is verified."*
