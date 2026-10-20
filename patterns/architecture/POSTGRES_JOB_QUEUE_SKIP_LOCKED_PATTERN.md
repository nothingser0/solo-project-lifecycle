# PostgreSQL Native Job Queue Pattern (`FOR UPDATE SKIP LOCKED`)

> **Module**: M05 (Architecture & Technical Specs) & M06 (Development Execution)  
> **Source**: Adapted from high-concurrency database-native scraping queues in published open-law data tooling.  
> **Objective**: Eliminate external queuing infrastructure (Redis, BullMQ, RabbitMQ, Celery) for background jobs in solo projects; enforce transactional, crash-safe, concurrent task processing inside PostgreSQL.

---

## 1. The Anti-Over-Engineering Rationale

Solo developers frequently introduce external Redis clusters or message brokers merely to send transactional emails, process PDF exports, or invoke AI APIs in the background.

**This introduces massive architectural debt:**
1. Dual-write failure modes (database commits, but Redis fails to enqueue).
2. Additional infrastructure billing and memory footprints.
3. Complex distributed debugging and connection management.

Since PostgreSQL 9.5+, the **`FOR UPDATE SKIP LOCKED`** row-level locking primitive allows standard PostgreSQL tables to behave as high-throughput, ACID-compliant FIFO queues capable of processing thousands of jobs per second with **zero external dependencies**.

---

## 2. Queue Schema & Partial Indexing

```sql
CREATE TYPE job_status AS ENUM ('pending', 'processing', 'completed', 'failed');

CREATE TABLE background_jobs (
    id BIGSERIAL PRIMARY KEY,
    job_type VARCHAR(50) NOT NULL,            -- e.g., 'send_invoice_email', 'generate_pdf'
    payload JSONB NOT NULL DEFAULT '{}'::jsonb,
    status job_status NOT NULL DEFAULT 'pending',
    retry_count INT NOT NULL DEFAULT 0,
    max_retries INT NOT NULL DEFAULT 3,
    last_error TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Crucial: Partial composite index ensuring index scans only evaluate active backlog
CREATE INDEX idx_jobs_pending_claim
ON background_jobs (created_at ASC)
WHERE status = 'pending';

-- Index for stuck worker recovery sweep
CREATE INDEX idx_jobs_processing_timeout
ON background_jobs (updated_at ASC)
WHERE status = 'processing';
```

---

## 3. Atomic Job Claiming Function

The claim operation must be atomic. Workers running concurrently must never claim or execute the same job twice:

```sql
CREATE OR REPLACE FUNCTION claim_background_jobs(
    p_batch_size INT DEFAULT 10
) RETURNS SETOF background_jobs
LANGUAGE sql
AS $$
UPDATE background_jobs
SET status = 'processing',
    updated_at = NOW()
WHERE id IN (
    SELECT id 
    FROM background_jobs
    WHERE status = 'pending'
    ORDER BY created_at ASC
    LIMIT p_batch_size
    FOR UPDATE SKIP LOCKED
)
RETURNING *;
$$;
```

---

## 4. Crash Recovery: The Stuck Worker Sweep

If a background worker crashes (e.g., Node.js OOM kill, server restart, network timeout during third-party API call), jobs remain locked in `processing` indefinitely.

Run a lightweight periodic sweep (every 5–15 minutes) to resurrect abandoned tasks or push them to a Dead Letter Queue (DLQ):

```sql
CREATE OR REPLACE FUNCTION recover_stuck_background_jobs(
    p_timeout_minutes INT DEFAULT 15
) RETURNS TABLE (
    recovered_count INT,
    failed_count INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_recovered INT := 0;
    v_failed INT := 0;
BEGIN
    -- 1. Fail permanently if max_retries exceeded (Dead Letter Queue)
    WITH dead_jobs AS (
        UPDATE background_jobs
        SET status = 'failed',
            last_error = 'Worker execution timeout (exceeded max retries)',
            updated_at = NOW()
        WHERE status = 'processing'
          AND updated_at < NOW() - (p_timeout_minutes || ' minutes')::INTERVAL
          AND retry_count >= max_retries
        RETURNING id
    )
    SELECT COUNT(*) INTO v_failed FROM dead_jobs;

    -- 2. Resurrect recoverable jobs back to pending
    WITH recovered_jobs AS (
        UPDATE background_jobs
        SET status = 'pending',
            retry_count = retry_count + 1,
            last_error = 'Worker execution timeout (resurrected)',
            updated_at = NOW()
        WHERE status = 'processing'
          AND updated_at < NOW() - (p_timeout_minutes || ' minutes')::INTERVAL
          AND retry_count < max_retries
        RETURNING id
    )
    SELECT COUNT(*) INTO v_recovered FROM recovered_jobs;

    RETURN QUERY SELECT v_recovered, v_failed;
END;
$$;
```

---

## 5. Lightweight TypeScript Worker Loop

A minimal Node.js / Next.js / Python worker implementation without external client libraries:

```typescript
// worker.ts
import { db } from './db';

async function runWorkerLoop() {
  while (true) {
    // 1. Claim batch of jobs atomically
    const jobs = await db.query('SELECT * FROM claim_background_jobs(5);');

    if (jobs.length === 0) {
      // Back off when queue is idle
      await new Promise((resolve) => setTimeout(resolve, 2000));
      continue;
    }

    // 2. Process concurrently
    await Promise.all(
      jobs.map(async (job) => {
        try {
          await executeJob(job.job_type, job.payload);
          await db.query(
            "UPDATE background_jobs SET status = 'completed', updated_at = NOW() WHERE id = $1;",
            [job.id]
          );
        } catch (err: any) {
          await db.query(
            "UPDATE background_jobs SET status = 'failed', last_error = $2, updated_at = NOW() WHERE id = $1;",
            [job.id, err.message]
          );
        }
      })
    );
  }
}
```
