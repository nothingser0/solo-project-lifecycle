# Modul 05B: System Design & Infrastructure Scalability

**Trigger**: Gunakan setelah Modul 05 (Arsitektur & Spesifikasi Teknis) selesai untuk proyek Menengah ke atas yang memerlukan performa, skalabilitas, atau ketersediaan tinggi. Skip untuk proyek Kecil (MVP) kecuali ada kebutuhan jelas (misalnya: perkiraan viral growth, integrasi real-time, atau data besar).

**Objektif**: Merancang infrastruktur yang scalable, reliable, dan performant dengan pendekatan pragmatis solo developer — boring tech, decision trees, dan trade-off eksplisit.

---

## 1. Performance & Scalability Fundamentals

### 1.1 Vertical vs Horizontal Scaling

**Decision Tree**:
```
Pertanyaan 1: Apakah bottleneck di CPU/Memory stateless service?
├─ Ya → Horizontal scaling (tambah instance)
└─ Tidak → Lanjut ke Pertanyaan 2

Pertanyaan 2: Apakah bottleneck di database single-node?
├─ Ya → Vertical scaling dulu (upgrade CPU/RAM) hingga cost ceiling
└─ Tidak → Analyze actual bottleneck

Pertanyaan 3: Apakah MAU > 100K atau RPS > 1000?
├─ Ya → Horizontal scaling wajib + load balancer
└─ Tidak → Vertical scaling cukup
```

**Praktik Solo Dev**:
- **< 10K MAU**: Single VPS upgraded (vertical). Contoh: DigitalOcean Droplet $24/mo (2 vCPU, 4GB RAM) → $48/mo (4 vCPU, 8GB RAM).
- **10K-100K MAU**: Horizontal scaling app layer (2-3 instance) + managed DB read replica.
- **> 100K MAU**: Auto-scaling groups + CDN + caching layer wajib.

### 1.2 CAP Theorem Trade-offs

**Consistency-Availability-Partition Tolerance** — pilih 2:
- **CP (Consistency + Partition tolerance)**: Bank, payment, inventory. Tolak request jika cluster split.
- **AP (Availability + Partition tolerance)**: Social media feed, analytics dashboard. Eventual consistency OK.
- **CA (Consistency + Availability)**: Tidak realistis di sistem terdistribusi.

**Solo Dev Decision**:
- **Single-region monolith (default)**: CA praktis karena tidak ada network partition risk.
- **Multi-region perlu**: Gunakan eventual consistency (AP) + conflict resolution strategy.

### 1.3 Performance Budgets

**Core Web Vitals Target** (Google ranking factor):
- **LCP (Largest Contentful Paint)**: < 2.5s
- **FID (First Input Delay)**: < 100ms
- **CLS (Cumulative Layout Shift)**: < 0.1

**Enforcement**:
```bash
# Lighthouse CI di pre-deploy check
npm install -g @lhci/cli
lhci autorun --upload.target=temporary-public-storage --assert.preset=lighthouse:recommended
```

**API Performance Budget**:
- **p50 latency**: < 200ms
- **p95 latency**: < 500ms
- **p99 latency**: < 1s
- **Error rate**: < 0.1%

### 1.4 Capacity Planning

**Formula Solo Dev**:
```
Max RPS = (Worker Count × Worker Throughput) / Safety Factor

Contoh Next.js di Vercel Pro:
- Worker Count: Auto-scale 0-100 instances
- Worker Throughput: ~50 RPS/instance (baseline)
- Safety Factor: 2× (reserve 50% headroom)
- Max RPS sustained: 2500 RPS
```

**Load Testing Checkpoint** (k6 script):
```javascript
// scripts/load-test.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  stages: [
    { duration: '2m', target: 100 }, // Ramp-up
    { duration: '5m', target: 100 }, // Sustained
    { duration: '2m', target: 0 },   // Ramp-down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'], // p95 < 500ms
    http_req_failed: ['rate<0.01'],   // error < 1%
  },
};

export default function () {
  const res = http.get('https://staging.example.com/api/health');
  check(res, { 'status 200': (r) => r.status === 200 });
  sleep(1);
}
```

Run: `k6 run scripts/load-test.js`

---

## 2. Latency & Throughput Optimization

### 2.1 Latency Targets

**Percentile Explanation**:
- **p50 (median)**: 50% request lebih cepat dari nilai ini
- **p95**: 95% request lebih cepat — target SLA umum
- **p99**: 99% request lebih cepat — deteksi outlier/bottleneck

**Network Latency Budget**:
```
User (Jakarta) → Cloudflare Edge (Jakarta): ~5ms
Edge → Origin Server (Singapore): ~20ms
Origin → Database (same AZ): ~1ms
Database Query: 10-50ms (indexed)
---
Total Budget: ~40-80ms (sisakan 120-160ms untuk app logic)
```

### 2.2 Throughput Calculation

**Formula**:
```
Throughput (req/sec) = Concurrency / Latency

Contoh:
- Concurrency: 100 concurrent users
- Average latency: 200ms (0.2s)
- Throughput: 100 / 0.2 = 500 RPS
```

**Database Connection Pooling**:
```javascript
// Next.js + Prisma
// prisma/schema.prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// .env
DATABASE_URL="postgresql://user:pass@host:5432/db?connection_limit=20&pool_timeout=10"
```

**Pool Size Formula**:
```
Pool Size = (Core Count × 2) + Effective Spindle Count

Server 4 vCPU + SSD (spindle=1):
Pool = (4 × 2) + 1 = 9 connections per instance

3 instances: 9 × 3 = 27 total connections
```

### 2.3 Query Optimization

**Index Strategy**:
```sql
-- BEFORE: Full table scan 2.3s
SELECT * FROM orders WHERE user_id = 123 AND status = 'pending';

-- AFTER: Add compound index
CREATE INDEX idx_orders_user_status ON orders(user_id, status);
-- Query time: 15ms (153× faster)
```

**N+1 Query Prevention**:
```javascript
// BAD: N+1 query
const users = await prisma.user.findMany();
for (const user of users) {
  user.posts = await prisma.post.findMany({ where: { userId: user.id } });
}

// GOOD: Eager loading
const users = await prisma.user.findMany({
  include: { posts: true },
});
```

---

## 3. Availability & Consistency

### 3.1 SLA/SLO/SLI Definitions

**Service Level Agreement (SLA)**: Kontrak legal dengan penalti finansial.
**Service Level Objective (SLO)**: Target internal tim.
**Service Level Indicator (SLI)**: Metrik aktual terukur.

**Uptime Budget**:
| Uptime % | Downtime/tahun | Downtime/bulan | Downtime/minggu |
|----------|----------------|----------------|-----------------|
| 90%      | 36.5 hari      | 3 hari         | 16.8 jam        |
| 99%      | 3.65 hari      | 7.2 jam        | 1.68 jam        |
| 99.9%    | 8.76 jam       | 43.2 menit     | 10.1 menit      |
| 99.99%   | 52.6 menit     | 4.32 menit     | 1.01 menit      |

**Solo Dev Realistic Target**:
- **MVP/Kecil**: 99% (7 jam downtime/bulan OK)
- **Menengah**: 99.5% (3.6 jam downtime/bulan)
- **Besar/Enterprise**: 99.9% (gunakan managed services)

### 3.2 Strong vs Eventual Consistency

**Strong Consistency** (ACID transactions):
- **Use case**: Payment, inventory decrement, double-booking prevention
- **Implementation**: PostgreSQL transactions + row-level locking
```sql
BEGIN;
SELECT stock FROM products WHERE id = 1 FOR UPDATE; -- Lock row
UPDATE products SET stock = stock - 1 WHERE id = 1;
COMMIT;
```

**Eventual Consistency**:
- **Use case**: Social feed, view counts, non-critical analytics
- **Implementation**: Write to queue, async worker processes
```javascript
// Increment view count async
await queue.add('increment-views', { postId: 123 });
// Return immediately, tidak tunggu processing
```

### 3.3 Multi-Region Replication

**Decision Tree**:
```
Apakah user base global (latency > 200ms cross-region)?
├─ Tidak → Single region cukup
└─ Ya → Lanjut

Apakah perlu write di semua region?
├─ Ya → Multi-master (conflict resolution complex, hindari jika bisa)
└─ Tidak → Primary-replica (writes ke primary, reads dari replica lokal)
```

**Vercel Edge + PlanetScale** (Lazy Developer Stack):
- Edge Functions: Run di region terdekat user (read path)
- Database: Single primary region (write path)
- Trade-off: Write latency tetap ke primary, tapi read cepat via edge cache

### 3.4 Failover & Disaster Recovery

**RPO (Recovery Point Objective)**: Maksimal data loss yang bisa ditoleransi.
**RTO (Recovery Time Objective)**: Maksimal downtime yang bisa ditoleransi.

**Backup Strategy**:
```bash
# Daily automated DB backup ke S3
#!/bin/bash
# cron: 0 2 * * * /scripts/backup-db.sh

DATE=$(date +%Y%m%d_%H%M%S)
pg_dump $DATABASE_URL | gzip > /tmp/backup_$DATE.sql.gz
aws s3 cp /tmp/backup_$DATE.sql.gz s3://backups/db/
# Retain: 7 daily, 4 weekly, 12 monthly
```

**Failover Checklist**:
- [ ] Database read replica ready (auto-failover: RDS Multi-AZ, PlanetScale)
- [ ] DNS TTL ≤ 60s (cepat switch ke backup IP)
- [ ] Runbook failover manual (documented di `docs/DISASTER_RECOVERY_PLAN.md`)
- [ ] Quarterly disaster recovery drill

---

## 4. Background Jobs & Async Processing

### 4.1 Job Queue Patterns

**Stack Recommendations**:
- **Node.js**: Bull + Redis (`npm install bull`)
- **Ruby**: Sidekiq + Redis (`gem 'sidekiq'`)
- **Python**: Celery + RabbitMQ (`pip install celery`)
- **Serverless**: AWS SQS + Lambda, Vercel Cron + Edge Functions

**Job Definition** (Bull example):
```javascript
// lib/queue.ts
import Queue from 'bull';

export const emailQueue = new Queue('email', process.env.REDIS_URL);

emailQueue.process(async (job) => {
  const { to, subject, body } = job.data;
  await sendEmail(to, subject, body);
});

// Enqueue job
await emailQueue.add({ to: 'user@example.com', subject: 'Welcome', body: '...' });
```

### 4.2 Retry Policies

**Exponential Backoff**:
```javascript
emailQueue.process({
  attempts: 5,
  backoff: {
    type: 'exponential',
    delay: 2000, // 2s, 4s, 8s, 16s, 32s
  },
});
```

**Dead Letter Queue**:
```javascript
emailQueue.on('failed', async (job, err) => {
  if (job.attemptsMade >= 5) {
    await deadLetterQueue.add({
      originalJob: job.data,
      error: err.message,
      failedAt: new Date(),
    });
    // Alert admin via Slack/email
  }
});
```

### 4.3 Cron vs Event-Driven

**Cron** (scheduled, predictable):
```javascript
// vercel.json
{
  "crons": [
    {
      "path": "/api/cron/daily-report",
      "schedule": "0 2 * * *" // 02:00 UTC daily
    }
  ]
}
```

**Event-Driven** (reactive, scalable):
```javascript
// Trigger on user signup
app.post('/api/signup', async (req, res) => {
  const user = await createUser(req.body);
  
  // Fire-and-forget async jobs
  await emailQueue.add({ type: 'welcome', userId: user.id });
  await analyticsQueue.add({ event: 'user_signup', userId: user.id });
  
  res.json({ success: true });
});
```

---

## 5. DNS & Content Delivery

### 5.1 DNS Failover

**Route53 Health Checks** (AWS):
```hcl
# terraform/dns.tf
resource "aws_route53_health_check" "primary" {
  fqdn              = "app.example.com"
  port              = 443
  type              = "HTTPS"
  resource_path     = "/api/health"
  failure_threshold = 3
  request_interval  = 30
}

resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app.example.com"
  type    = "A"
  
  failover_routing_policy {
    type = "PRIMARY"
  }
  
  set_identifier = "primary"
  alias {
    name                   = aws_lb.primary.dns_name
    zone_id                = aws_lb.primary.zone_id
    evaluate_target_health = true
  }
}
```

**Cloudflare Load Balancing** (Lazy stack):
- Dashboard: Traffic → Load Balancing
- Health check: `/api/health` setiap 30s
- Automatic failover jika 3× check gagal

### 5.2 CDN Cache Strategies

**Cache-Control Headers**:
```javascript
// Next.js API route
export async function GET(request) {
  const data = await fetchData();
  
  return new Response(JSON.stringify(data), {
    headers: {
      'Content-Type': 'application/json',
      'Cache-Control': 'public, s-maxage=60, stale-while-revalidate=300',
      // s-maxage=60: CDN cache 60s
      // stale-while-revalidate=300: Serve stale up to 5min while revalidating
    },
  });
}
```

**Cache Purging**:
```javascript
// Purge Cloudflare cache on data update
async function purgeCache(urls) {
  await fetch(`https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/purge_cache`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${CF_API_TOKEN}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ files: urls }),
  });
}

// Call after update
await updateProduct(productId);
await purgeCache([`https://example.com/api/products/${productId}`]);
```

### 5.3 Edge Computing

**Use Cases**:
- **Geolocation routing**: Redirect users based on location
- **A/B testing**: Route % traffic to variant
- **Auth validation**: Verify JWT at edge (skip origin call)
- **Image optimization**: Resize/compress on-the-fly

**Cloudflare Workers**:
```javascript
// workers/ab-test.js
addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request));
});

async function handleRequest(request) {
  const variant = Math.random() < 0.5 ? 'A' : 'B';
  const url = new URL(request.url);
  url.searchParams.set('variant', variant);
  
  return fetch(url, {
    headers: { 'X-Variant': variant },
  });
}
```

### 5.4 DDoS Mitigation

**Rate Limiting** (Cloudflare):
- Dashboard: Security → WAF → Rate limiting rules
- Rule: "Block if > 100 req/min from single IP to /api/*"

**WAF (Web Application Firewall)**:
- Cloudflare: OWASP Core Ruleset auto-enabled
- AWS: AWS WAF dengan managed rule groups
- Vercel: Built-in DDoS protection + rate limiting via `vercel.json`

```json
{
  "functions": {
    "api/**": {
      "memory": 1024,
      "maxDuration": 10
    }
  }
}
```

---

## 6. Load Balancer & Application Layer

### 6.1 Load Balancing Algorithms

**Round-Robin**: Request 1 → Server A, Request 2 → Server B, Request 3 → Server A
- **Pro**: Simple, fair distribution
- **Con**: Ignores server load (server lemot dapat traffic sama)

**Least Connections**: Route ke server dengan active connections paling sedikit
- **Pro**: Better untuk long-lived connections (WebSockets)
- **Con**: Butuh health monitoring overhead

**IP Hash**: Hash client IP → consistent server assignment
- **Pro**: Session affinity tanpa sticky cookies
- **Con**: Uneven distribution jika traffic dari corporate proxy

**Weighted**: Server A weight=3, Server B weight=1 → 75% traffic ke A
- **Pro**: Gradual canary deployment
- **Con**: Butuh manual tuning

### 6.2 Health Checks

**Liveness vs Readiness**:
- **Liveness** (`/health`): Is app process alive? (CPU, memory responsive)
- **Readiness** (`/ready`): Can app serve traffic? (DB connected, migrations done)

```javascript
// app/api/health/route.ts
export async function GET() {
  return Response.json({ status: 'ok' }, { status: 200 });
}

// app/api/ready/route.ts
export async function GET() {
  try {
    await prisma.$queryRaw`SELECT 1`; // DB connectivity check
    return Response.json({ status: 'ready' }, { status: 200 });
  } catch (error) {
    return Response.json({ status: 'not ready', error }, { status: 503 });
  }
}
```

**Graceful Shutdown**:
```javascript
// server.js
const server = app.listen(PORT);

process.on('SIGTERM', () => {
  console.log('SIGTERM received, closing server gracefully');
  server.close(() => {
    console.log('Server closed, exiting');
    process.exit(0);
  });
});
```

### 6.3 Rate Limiting

**Token Bucket Algorithm** (Upstash Redis):
```javascript
// lib/rate-limit.ts
import { Ratelimit } from '@upstash/ratelimit';
import { Redis } from '@upstash/redis';

const redis = new Redis({ url: process.env.UPSTASH_REDIS_URL });

export const limiter = new Ratelimit({
  redis,
  limiter: Ratelimit.slidingWindow(10, '10 s'), // 10 req per 10s
});

// Middleware
export async function rateLimit(request: Request) {
  const ip = request.headers.get('x-forwarded-for') || 'anonymous';
  const { success, limit, remaining } = await limiter.limit(ip);
  
  if (!success) {
    return new Response('Rate limit exceeded', { status: 429 });
  }
  
  return null; // Pass through
}
```

---

## 7. Database Strategies

### 7.1 SQL vs NoSQL Decision Tree

```
Apakah data memiliki relasi kompleks (foreign keys, joins)?
├─ Ya → SQL (PostgreSQL)
└─ Tidak → Lanjut

Apakah perlu transactions ACID?
├─ Ya → SQL
└─ Tidak → Lanjut

Apakah schema flexible (dokumen berbeda struktur)?
├─ Ya → NoSQL (MongoDB, DynamoDB)
└─ Tidak → SQL tetap lebih baik
```

**Solo Dev Default**: PostgreSQL. Alasan:
- JSON column untuk flexible data
- Full-text search built-in
- Mature tooling (Prisma, Drizzle)
- Free tier: Supabase, Neon, PlanetScale

### 7.2 Sharding Strategies

**Range-Based**: User ID 1-10000 → Shard A, 10001-20000 → Shard B
- **Pro**: Simple range queries
- **Con**: Hotspot jika growth tidak merata

**Hash-Based**: `hash(user_id) % shard_count`
- **Pro**: Uniform distribution
- **Con**: Range queries require scatter-gather

**Directory-Based**: Lookup table `user_id → shard_id`
- **Pro**: Flexible reassignment
- **Con**: Extra lookup overhead

**Solo Dev**: Hindari sharding hingga single DB tidak cukup (> 100GB atau > 10K writes/sec). Gunakan managed scaling (PlanetScale, CockroachDB) dulu.

### 7.3 Read Replicas

**Setup** (Supabase):
- Dashboard: Database → Replication → Add read replica (region pilih terdekat users)
- Connection string: `postgres://...?options=--replica`

**Application Code**:
```javascript
// lib/db.ts
import { PrismaClient } from '@prisma/client';

export const dbPrimary = new PrismaClient({
  datasources: { db: { url: process.env.DATABASE_URL_PRIMARY } },
});

export const dbReplica = new PrismaClient({
  datasources: { db: { url: process.env.DATABASE_URL_REPLICA } },
});

// Usage
export async function getUser(id: string) {
  return dbReplica.user.findUnique({ where: { id } }); // Read from replica
}

export async function updateUser(id: string, data: any) {
  return dbPrimary.user.update({ where: { id }, data }); // Write to primary
}
```

**Replication Lag Monitoring**:
```sql
-- PostgreSQL: Check lag
SELECT now() - pg_last_xact_replay_timestamp() AS replication_lag;
-- Target: < 1s
```

---

## 8. Caching Layers

### 8.1 Multi-Tier Caching

**L1 (In-Memory)**: Node.js process cache (fastest, ephemeral)
**L2 (Redis)**: Shared cache across instances (persistent, distributed)
**L3 (CDN)**: Edge cache (global, high hit rate for static/public content)

**Example Flow**:
```javascript
async function getProduct(id: string) {
  // L1: Check in-memory
  if (memoryCache.has(id)) return memoryCache.get(id);
  
  // L2: Check Redis
  const cached = await redis.get(`product:${id}`);
  if (cached) {
    memoryCache.set(id, cached);
    return JSON.parse(cached);
  }
  
  // L3: Database (cache miss)
  const product = await db.product.findUnique({ where: { id } });
  await redis.set(`product:${id}`, JSON.stringify(product), { ex: 3600 }); // 1 hour
  memoryCache.set(id, product);
  
  return product;
}
```

### 8.2 Cache Invalidation

**Time-Based (TTL)**:
```javascript
await redis.set('key', value, { ex: 60 }); // Expire after 60s
```

**Write-Through**: Update cache immediately on write
```javascript
await db.product.update({ where: { id }, data });
await redis.set(`product:${id}`, JSON.stringify(data), { ex: 3600 });
```

**Cache-Aside** (Lazy Loading): Populate on read miss (example above)

**Event-Based**: Invalidate on mutation
```javascript
await db.product.update({ where: { id }, data });
await redis.del(`product:${id}`); // Invalidate, next read will fetch fresh
```

### 8.3 Cache Stampede Prevention

**Problem**: Cache expires → 1000 concurrent requests hit DB simultaneously

**Solution: Probabilistic Early Expiration**:
```javascript
async function getCachedOrFetch(key: string, ttl: number, fetchFn: () => Promise<any>) {
  const cached = await redis.get(key);
  if (cached) {
    const { data, expires } = JSON.parse(cached);
    const timeLeft = expires - Date.now();
    const earlyExpireThreshold = ttl * 0.1; // 10% of TTL
    
    // 10% chance to refresh early if close to expiration
    if (timeLeft < earlyExpireThreshold && Math.random() < 0.1) {
      // Async refresh, return stale data immediately
      fetchAndCache(key, ttl, fetchFn);
    }
    
    return data;
  }
  
  return fetchAndCache(key, ttl, fetchFn);
}
```

---

**[ Bersambung ke bagian 2... ]**
## 9. Asynchronous Patterns

### 9.1 Event Sourcing

**Concept**: Store events, not current state. Replay events to rebuild state.

**Use Case**: Audit trail, undo/redo, debugging historical data.

```javascript
// Event store
const events = [
  { type: 'OrderCreated', orderId: 1, amount: 100, timestamp: '2024-01-01' },
  { type: 'OrderPaid', orderId: 1, timestamp: '2024-01-02' },
  { type: 'OrderShipped', orderId: 1, timestamp: '2024-01-03' },
];

// Rebuild state
function getOrderState(orderId) {
  const orderEvents = events.filter(e => e.orderId === orderId);
  let state = { id: orderId, status: 'pending', amount: 0 };
  
  for (const event of orderEvents) {
    if (event.type === 'OrderCreated') state.amount = event.amount;
    if (event.type === 'OrderPaid') state.status = 'paid';
    if (event.type === 'OrderShipped') state.status = 'shipped';
  }
  
  return state;
}
```

**Solo Dev Warning**: Complex overhead. Gunakan hanya jika audit trail mutlak diperlukan (compliance, financial).

### 9.2 CQRS (Command Query Responsibility Segregation)

**Concept**: Separate write model (commands) from read model (queries).

**Architecture**:
```
Write Path: POST /api/orders → Command Handler → DB Write → Event Bus
Read Path: GET /api/orders → Query Handler → Read-optimized DB/Cache
```

**Implementation** (Prisma + Redis):
```javascript
// Command (write)
async function createOrder(data) {
  const order = await prisma.order.create({ data });
  await redis.publish('order-created', JSON.stringify(order));
  return order;
}

// Query (read from denormalized cache)
async function getOrderSummary(userId) {
  const cached = await redis.get(`user-orders:${userId}`);
  if (cached) return JSON.parse(cached);
  
  // Fallback to DB
  const orders = await prisma.order.findMany({ where: { userId } });
  await redis.set(`user-orders:${userId}`, JSON.stringify(orders), { ex: 300 });
  return orders;
}

// Background worker updates read model
redis.subscribe('order-created', async (message) => {
  const order = JSON.parse(message);
  await redis.del(`user-orders:${order.userId}`); // Invalidate cache
});
```

### 9.3 Saga Pattern (Distributed Transactions)

**Problem**: Payment berhasil di Stripe, tapi inventory update gagal → data inconsistent.

**Choreography Saga** (Event-driven):
```javascript
// Step 1: Create order
await prisma.order.create({ data: { userId, items, status: 'pending' } });
await queue.add('reserve-inventory', { orderId });

// Step 2: Reserve inventory (separate worker)
queue.process('reserve-inventory', async (job) => {
  const { orderId } = job.data;
  try {
    await reserveInventory(orderId);
    await queue.add('charge-payment', { orderId });
  } catch (error) {
    await queue.add('cancel-order', { orderId, reason: 'inventory-unavailable' });
  }
});

// Step 3: Charge payment
queue.process('charge-payment', async (job) => {
  const { orderId } = job.data;
  try {
    await stripe.charges.create({ orderId });
    await prisma.order.update({ where: { id: orderId }, data: { status: 'paid' } });
  } catch (error) {
    await queue.add('release-inventory', { orderId });
    await queue.add('cancel-order', { orderId, reason: 'payment-failed' });
  }
});
```

**Solo Dev**: Gunakan database transactions dulu. Saga hanya jika multi-service unavoidable.

### 9.4 Idempotency Keys

**Problem**: User double-clicks "Pay" → charged twice.

**Solution**: Idempotency key per request.

```javascript
// Stripe-style idempotency
app.post('/api/charge', async (req, res) => {
  const idempotencyKey = req.headers['idempotency-key'];
  if (!idempotencyKey) return res.status(400).json({ error: 'Missing idempotency key' });
  
  // Check if already processed
  const existing = await redis.get(`idempotency:${idempotencyKey}`);
  if (existing) return res.json(JSON.parse(existing)); // Return cached response
  
  // Process charge
  const charge = await stripe.charges.create({ amount: req.body.amount });
  
  // Cache result for 24h
  await redis.set(`idempotency:${idempotencyKey}`, JSON.stringify(charge), { ex: 86400 });
  res.json(charge);
});
```

**Client**:
```javascript
const idempotencyKey = crypto.randomUUID();
await fetch('/api/charge', {
  method: 'POST',
  headers: { 'Idempotency-Key': idempotencyKey },
  body: JSON.stringify({ amount: 1000 }),
});
```

---

## 10. Communication Protocols

### 10.1 REST vs GraphQL vs gRPC

| Protocol | Use When | Pros | Cons |
|----------|----------|------|------|
| **REST** | Public API, CRUD, caching important | Simple, cacheable, wide support | Over/under-fetching, multiple round-trips |
| **GraphQL** | Complex UI, mobile apps (bandwidth sensitive) | Single request, flexible queries, typed | Caching hard, N+1 query risk, learning curve |
| **gRPC** | Internal microservices, streaming, performance-critical | Fast (Protobuf), streaming, type-safe | Not browser-friendly, complex tooling |

**Solo Dev Default**: REST. GraphQL if mobile app with complex data needs.

### 10.2 Webhooks vs Polling

**Webhooks** (push):
```javascript
// Stripe sends payment success webhook
app.post('/api/webhooks/stripe', async (req, res) => {
  const event = req.body;
  if (event.type === 'payment_intent.succeeded') {
    await prisma.order.update({
      where: { paymentIntentId: event.data.object.id },
      data: { status: 'paid' },
    });
  }
  res.json({ received: true });
});
```

**Polling** (pull):
```javascript
// Check payment status every 5s (inefficient)
const interval = setInterval(async () => {
  const payment = await stripe.paymentIntents.retrieve(paymentIntentId);
  if (payment.status === 'succeeded') {
    clearInterval(interval);
    // Update order
  }
}, 5000);
```

**Decision**: Webhooks jika provider support. Polling sebagai fallback (webhook delivery bisa gagal).

### 10.3 WebSockets for Real-Time

**Use Cases**: Chat, live notifications, collaborative editing, live dashboards.

**Implementation** (Next.js + Pusher):
```javascript
// Server
import Pusher from 'pusher';
const pusher = new Pusher({ appId, key, secret, cluster: 'ap1' });

app.post('/api/send-message', async (req, res) => {
  const { roomId, message } = req.body;
  await pusher.trigger(`room-${roomId}`, 'new-message', message);
  res.json({ success: true });
});

// Client
import Pusher from 'pusher-js';
const pusher = new Pusher(key, { cluster: 'ap1' });
const channel = pusher.subscribe('room-123');
channel.bind('new-message', (data) => {
  console.log('New message:', data);
});
```

**Solo Dev Lazy Stack**: Pusher (10K connections free), Ably, or Supabase Realtime.

### 10.4 Message Brokers

**When to Use**:
- Decouple services (producer doesn't wait for consumer)
- Fan-out (1 message → N consumers)
- Replay events (Kafka-style log)

**Stack Comparison**:
| Broker | Use Case | Complexity | Cost (Solo Dev) |
|--------|----------|------------|-----------------|
| **Redis Pub/Sub** | Simple events, ephemeral | Low | Free (Upstash 10K msgs/day) |
| **AWS SQS** | Reliable queues, retries | Medium | $0.40/million requests |
| **RabbitMQ** | Complex routing, priority queues | High | Self-host or CloudAMQP $10/mo |
| **Kafka** | Event streaming, analytics pipelines | Very High | Avoid unless enterprise scale |

**Solo Dev Default**: Redis Pub/Sub or AWS SQS. Hindari Kafka.

---

## 11. Performance Anti-patterns

### 11.1 N+1 Queries

**Problem**:
```javascript
// 1 query for users + N queries for posts
const users = await prisma.user.findMany(); // 1 query
for (const user of users) {
  user.posts = await prisma.post.findMany({ where: { userId: user.id } }); // N queries
}
```

**Solution**: Eager loading
```javascript
const users = await prisma.user.findMany({
  include: { posts: true }, // Single query with JOIN
});
```

### 11.2 Over-fetching / Under-fetching

**Over-fetching**: Fetch entire user object when only need name.
```javascript
// BAD: Fetch 50 fields
const user = await prisma.user.findUnique({ where: { id } });
return { name: user.name }; // Only use 1 field

// GOOD: Select specific fields
const user = await prisma.user.findUnique({
  where: { id },
  select: { name: true },
});
```

**Under-fetching**: Multiple round-trips for related data (use GraphQL or include).

### 11.3 Synchronous External API Calls

**BAD**: Block request waiting for external API
```javascript
app.post('/api/signup', async (req, res) => {
  const user = await createUser(req.body);
  await sendWelcomeEmail(user.email); // Blocks 2-5s
  res.json({ success: true });
});
```

**GOOD**: Async job queue
```javascript
app.post('/api/signup', async (req, res) => {
  const user = await createUser(req.body);
  await emailQueue.add({ type: 'welcome', userId: user.id }); // Non-blocking
  res.json({ success: true });
});
```

### 11.4 Missing Indexes

**Detection**:
```sql
-- PostgreSQL: Find slow queries
SELECT query, mean_exec_time, calls
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 10;

-- Explain query plan
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = 123;
-- Look for "Seq Scan" (full table scan) → add index
```

**Solution**:
```sql
CREATE INDEX idx_orders_user_id ON orders(user_id);
```

### 11.5 Large Payloads

**Problem**: API returns 1000 items in single response (slow, high memory).

**Solution: Cursor-based Pagination**:
```javascript
// API
app.get('/api/posts', async (req, res) => {
  const { cursor, limit = 20 } = req.query;
  
  const posts = await prisma.post.findMany({
    take: limit + 1, // Fetch 1 extra to check if more exist
    cursor: cursor ? { id: cursor } : undefined,
    orderBy: { createdAt: 'desc' },
  });
  
  const hasMore = posts.length > limit;
  const items = hasMore ? posts.slice(0, limit) : posts;
  const nextCursor = hasMore ? items[items.length - 1].id : null;
  
  res.json({ items, nextCursor, hasMore });
});
```

---

## 12. Monitoring & Observability

### 12.1 RED Metrics (Golden Signals)

**Rate**: Requests per second
**Errors**: Error rate (%)
**Duration**: Response time (p50, p95, p99)

**Implementation** (Prometheus + Grafana):
```javascript
import { register, Counter, Histogram } from 'prom-client';

const requestCounter = new Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests',
  labelNames: ['method', 'route', 'status'],
});

const requestDuration = new Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration',
  labelNames: ['method', 'route'],
});

app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    requestCounter.inc({ method: req.method, route: req.route?.path, status: res.statusCode });
    requestDuration.observe({ method: req.method, route: req.route?.path }, duration);
  });
  next();
});

app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});
```

**Solo Dev Lazy Stack**: Vercel Analytics (built-in), Sentry Performance, or Axiom.

### 12.2 Structured Logging

**BAD**: Unstructured logs
```javascript
console.log('User login failed for user@example.com due to wrong password');
```

**GOOD**: JSON structured logs
```javascript
import pino from 'pino';
const logger = pino();

logger.error({
  event: 'login_failed',
  userId: 'user-123',
  email: 'user@example.com',
  reason: 'wrong_password',
  ip: req.ip,
  timestamp: new Date().toISOString(),
});
```

**Benefits**: Easy to query, filter, and alert in log aggregators (Datadog, Grafana Loki).

### 12.3 Distributed Tracing

**Use Case**: Request touches API → Database → External API → Cache. Which part is slow?

**OpenTelemetry** (industry standard):
```javascript
import { NodeTracerProvider } from '@opentelemetry/sdk-trace-node';
import { JaegerExporter } from '@opentelemetry/exporter-jaeger';

const provider = new NodeTracerProvider();
provider.addSpanProcessor(new BatchSpanProcessor(new JaegerExporter()));
provider.register();

// Auto-instrument frameworks
import { registerInstrumentations } from '@opentelemetry/instrumentation';
import { HttpInstrumentation } from '@opentelemetry/instrumentation-http';
registerInstrumentations({
  instrumentations: [new HttpInstrumentation()],
});
```

**Solo Dev Lazy Stack**: Vercel Monitoring (auto-traces serverless), Sentry Tracing, or skip if <1000 RPS.

### 12.4 Alerting Best Practices

**Alert Fatigue Prevention**:
- Alert on symptoms (user impact), not causes (disk 80% full)
- Set SLO-based alerts: "p95 latency > 500ms for 5 min"
- Avoid duplicate alerts (don't alert on same issue via 3 channels)

**On-Call Rotation** (Solo Dev Reality):
- Define critical alerts (payment down, site down)
- Non-critical alerts: batch daily email digest
- Use PagerDuty/Opsgenie free tier or Slack webhooks

---

## 13. Cloud Design Patterns

### 13.1 Strangler Fig Pattern

**Use Case**: Migrate legacy system incrementally without rewrite.

**Strategy**:
```
Phase 1: New feature in new stack, old features stay in legacy
Phase 2: Migrate high-value legacy features one by one
Phase 3: Decommission legacy when 100% migrated
```

**Implementation** (proxy routing):
```nginx
# nginx.conf
location /api/v2/ {
  proxy_pass http://new-app:3000;
}

location /api/ {
  proxy_pass http://legacy-app:8080;
}
```

### 13.2 Circuit Breaker

**Problem**: External API down → all requests timeout → cascade failure.

**Solution**: Detect failure, stop sending requests, retry after cooldown.

```javascript
import CircuitBreaker from 'opossum';

const breaker = new CircuitBreaker(externalApiCall, {
  timeout: 3000, // 3s timeout
  errorThresholdPercentage: 50, // Open circuit if 50% fail
  resetTimeout: 30000, // Try again after 30s
});

breaker.fallback(() => ({ error: 'Service temporarily unavailable' }));

breaker.on('open', () => console.log('Circuit opened'));
breaker.on('halfOpen', () => console.log('Circuit half-open, testing'));
breaker.on('close', () => console.log('Circuit closed, service recovered'));

// Usage
const result = await breaker.fire({ userId: 123 });
```

### 13.3 Bulkhead Pattern

**Concept**: Isolate resources to prevent one failure from affecting others.

**Example**: Separate connection pools per service
```javascript
// Pool 1: Critical database operations (50 connections)
const criticalPool = new Pool({ max: 50, connectionString: DB_URL });

// Pool 2: Analytics queries (10 connections)
const analyticsPool = new Pool({ max: 10, connectionString: DB_URL });

// Heavy analytics query won't starve critical operations
```

### 13.4 Retry with Exponential Backoff

**Implementation**:
```javascript
async function retryWithBackoff(fn, maxRetries = 3, baseDelay = 1000) {
  for (let attempt = 0; attempt < maxRetries; attempt++) {
    try {
      return await fn();
    } catch (error) {
      if (attempt === maxRetries - 1) throw error;
      const delay = baseDelay * Math.pow(2, attempt); // 1s, 2s, 4s
      await new Promise(resolve => setTimeout(resolve, delay));
    }
  }
}

// Usage
const data = await retryWithBackoff(() => fetch('https://api.example.com'));
```

### 13.5 Blue-Green Deployment

**Strategy**: Run 2 identical environments (Blue=current, Green=new). Switch traffic after validation.

**Vercel** (automatic):
```bash
vercel --prod  # Deploys to new environment, tests, then switches traffic
```

**Manual** (Load Balancer):
```
1. Deploy new version to "green" servers
2. Run smoke tests on green
3. Switch LB to route 100% traffic to green
4. Monitor for 30 min
5. If OK: decommission blue. If fail: switch back to blue
```

### 13.6 Canary Releases

**Strategy**: Route small % traffic to new version, gradually increase.

**Cloudflare Workers**:
```javascript
addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request));
});

async function handleRequest(request) {
  const canaryPercent = 10; // 10% traffic to new version
  const isCanary = Math.random() * 100 < canaryPercent;
  
  const targetUrl = isCanary 
    ? 'https://app-v2.example.com'
    : 'https://app-v1.example.com';
  
  return fetch(new Request(targetUrl, request));
}
```

---

## 14. Data Management

### 14.1 ETL vs ELT Pipelines

**ETL (Extract, Transform, Load)**: Transform before loading
- Use when: Source data messy, target DB limited compute
- Tools: Airflow, dbt, custom scripts

**ELT (Extract, Load, Transform)**: Load raw, transform in warehouse
- Use when: Modern warehouse (Snowflake, BigQuery) with compute power
- Tools: Fivetran, Airbyte, dbt

**Solo Dev Default**: ELT dengan dbt (SQL-based transformations).

### 14.2 Schema Evolution

**Backward Compatible** (safe):
- Add optional columns
- Add new tables
- Widen column types (VARCHAR(50) → VARCHAR(100))

**Backward Incompatible** (risky):
- Remove columns (deploy fails if old code still uses it)
- Rename columns
- Change data types (STRING → INT)

**Migration Strategy** (Expand and Contract):
```sql
-- Phase 1: Add new column (backward compatible)
ALTER TABLE users ADD COLUMN email_new VARCHAR(255);

-- Phase 2: Deploy code that writes to both columns
-- Phase 3: Backfill data
UPDATE users SET email_new = email WHERE email_new IS NULL;

-- Phase 4: Deploy code that reads from email_new
-- Phase 5: Drop old column
ALTER TABLE users DROP COLUMN email;
```

### 14.3 Data Retention & Archival

**Strategy**:
```javascript
// Archive orders older than 2 years to S3
const twoYearsAgo = new Date();
twoYearsAgo.setFullYear(twoYearsAgo.getFullYear() - 2);

const oldOrders = await prisma.order.findMany({
  where: { createdAt: { lt: twoYearsAgo } },
});

// Export to S3
const archive = JSON.stringify(oldOrders);
await s3.putObject({
  Bucket: 'archives',
  Key: `orders-${new Date().toISOString()}.json.gz`,
  Body: gzip(archive),
});

// Delete from DB
await prisma.order.deleteMany({
  where: { createdAt: { lt: twoYearsAgo } },
});
```

**Compliance**: Check GDPR/UU PDP retention limits (e.g., delete inactive users after 3 years).

---

## 15. Messaging Patterns

### 15.1 Pub/Sub vs Queue

**Pub/Sub** (Broadcast):
- 1 message → N subscribers
- Example: User signup → send welcome email, create analytics event, notify admin

**Queue** (Point-to-point):
- 1 message → 1 consumer
- Example: Process payment → single worker handles it

### 15.2 Message Ordering Guarantees

**FIFO Queue** (AWS SQS FIFO):
```javascript
await sqs.sendMessage({
  QueueUrl: 'https://sqs.ap-southeast-1.amazonaws.com/123/orders.fifo',
  MessageBody: JSON.stringify({ orderId: 1, action: 'ship' }),
  MessageGroupId: 'order-1', // Messages in same group processed in order
});
```

**Use Case**: Bank transactions (credit must happen after debit).

### 15.3 At-Least-Once vs Exactly-Once Delivery

**At-Least-Once** (default):
- Message may be delivered multiple times (network retry)
- Solution: Idempotent consumers (ignore duplicates)

**Exactly-Once** (expensive):
- Guaranteed single delivery (Kafka, AWS SQS FIFO with deduplication)
- Use when: Financial transactions, inventory decrement

### 15.4 Dead Letter Queue Handling

**Strategy**:
```javascript
dlq.process(async (job) => {
  const { originalJob, error, attemptsMade } = job.data;
  
  // Log to monitoring
  await logger.error({
    event: 'dlq_job_failed',
    job: originalJob,
    error,
    attemptsMade,
  });
  
  // Notify admin via Slack
  await slack.send({
    channel: '#alerts',
    text: `Job failed after ${attemptsMade} attempts: ${error}`,
  });
  
  // Manual intervention required
});
```

---

## 16. Microservices & API Design

### 16.1 Service Boundaries (Domain-Driven Design)

**Bounded Contexts**:
- **Order Service**: Order lifecycle, payment integration
- **Inventory Service**: Stock management, reservations
- **User Service**: Auth, profile, permissions

**Anti-pattern**: Nanoservices (1 function = 1 service → network overhead explosion).

**Solo Dev**: Start monolith, extract microservices only if:
- Team > 5 people OR
- Service needs independent scaling OR
- Different tech stack required

### 16.2 API Versioning

**URL Path** (recommended for REST):
```
GET /api/v1/users
GET /api/v2/users
```

**Header**:
```
GET /api/users
Header: Accept: application/vnd.myapi.v2+json
```

**Query Param** (avoid, breaks caching):
```
GET /api/users?version=2
```

**Deprecation Strategy**:
```javascript
app.get('/api/v1/users', (req, res) => {
  res.set('Warning', '299 - "API v1 deprecated, migrate to v2 by 2024-12-31"');
  // ... handler
});
```

### 16.3 Feature Flags

**Use Cases**:
- Gradual rollout (enable for 10% users)
- A/B testing
- Kill switch (disable buggy feature without deploy)

**Implementation** (LaunchDarkly, Unleash, or simple DB):
```javascript
async function isFeatureEnabled(userId, featureKey) {
  const flag = await prisma.featureFlag.findUnique({ where: { key: featureKey } });
  if (!flag || !flag.enabled) return false;
  
  // Rollout percentage
  if (flag.rolloutPercent < 100) {
    const hash = hashCode(userId) % 100;
    return hash < flag.rolloutPercent;
  }
  
  return true;
}

// Usage
if (await isFeatureEnabled(userId, 'new-checkout')) {
  return newCheckoutFlow();
} else {
  return oldCheckoutFlow();
}
```

### 16.4 ABAC (Attribute-Based Access Control)

**When to Use**:
- **RBAC insufficient**: Role alone can't decide (e.g., "editors can edit own department's docs only")
- **Multi-tenancy**: Tenant isolation + cross-tenant sharing rules
- **Compliance**: GDPR, HIPAA, SOC2 require granular audit ("who accessed what, when, why")
- **Dynamic policies**: Rules change frequently (seasonal access, geo-restrictions)

**ABAC vs RBAC**:
| Aspect | RBAC | ABAC |
|--------|------|------|
| **Decision Based On** | User role (admin, editor, viewer) | Attributes (user.dept, resource.owner, env.time) |
| **Complexity** | Low | High |
| **Flexibility** | Low (roles hardcoded) | High (policies in DB/config) |
| **Use Case** | SaaS tiers, basic admin panel | Enterprise multi-tenant, compliance-heavy |

**ABAC Policy Example**:
```
Policy: "User can edit document IF:
  - user.department == document.department
  - (user.role == 'editor' OR user.id == document.owner_id)
  - environment.time.hour >= 9 AND environment.time.hour <= 17
  - environment.ip NOT IN blacklist
```

**Implementation (Casbin, OPA, or Custom)**:

#### Option 1: Casbin (Lightweight ABAC Library)
```javascript
// Install: npm install casbin
import { newEnforcer } from 'casbin';

// policy.csv (ABAC rules)
// p, subject_rule, object_rule, action, effect
// p, user.department == resource.department, *, edit, allow
// p, user.role == "admin", *, *, allow

const enforcer = await newEnforcer('model.conf', 'policy.csv');

// Check permission
async function canEdit(user, document) {
  const subject = { department: user.department, role: user.role, id: user.id };
  const object = { department: document.department, owner_id: document.owner_id };
  
  return await enforcer.enforce(subject, object, 'edit');
}

// Usage in API
app.put('/api/documents/:id', async (req, res) => {
  const user = req.user; // from JWT
  const document = await prisma.document.findUnique({ where: { id: req.params.id } });
  
  if (!await canEdit(user, document)) {
    return res.status(403).json({ error: 'Access denied' });
  }
  
  // ... update logic
});
```

#### Option 2: Open Policy Agent (OPA) — Production-Grade
```rego
# policy.rego
package authz

default allow = false

# Admin can do everything
allow {
  input.user.role == "admin"
}

# Editor can edit own department's docs
allow {
  input.action == "edit"
  input.user.role == "editor"
  input.user.department == input.resource.department
}

# Owner can edit own docs
allow {
  input.action == "edit"
  input.user.id == input.resource.owner_id
}

# Business hours only
allow {
  input.environment.hour >= 9
  input.environment.hour <= 17
}
```

```javascript
// Node.js + OPA REST API
async function checkPolicy(user, resource, action) {
  const input = {
    user: { id: user.id, role: user.role, department: user.department },
    resource: { id: resource.id, department: resource.department, owner_id: resource.owner_id },
    action,
    environment: { hour: new Date().getHours(), ip: req.ip }
  };
  
  const response = await fetch('http://opa:8181/v1/data/authz/allow', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ input })
  });
  
  const result = await response.json();
  return result.result === true;
}
```

#### Option 3: Custom Lightweight ABAC (Solo Dev)
```javascript
// lib/abac.js
const policies = {
  'document.edit': [
    // Rule 1: Admin bypasses all
    (user, resource, env) => user.role === 'admin',
    
    // Rule 2: Same department editors
    (user, resource, env) => 
      user.role === 'editor' && user.department === resource.department,
    
    // Rule 3: Document owner
    (user, resource, env) => user.id === resource.owner_id,
    
    // Rule 4: Business hours (9-17)
    (user, resource, env) => env.hour >= 9 && env.hour <= 17
  ],
  
  'document.delete': [
    (user, resource, env) => user.role === 'admin',
    (user, resource, env) => user.id === resource.owner_id && user.role === 'editor'
  ]
};

export function checkPermission(action, user, resource) {
  const rules = policies[action];
  if (!rules) return false;
  
  const env = {
    hour: new Date().getHours(),
    ip: null // inject from request context
  };
  
  // ALL rules must pass (AND logic)
  return rules.every(rule => rule(user, resource, env));
}

// Usage
if (!checkPermission('document.edit', req.user, document)) {
  return res.status(403).json({ error: 'Access denied' });
}
```

**ABAC Audit Log** (Required for Compliance):
```javascript
// Log every access decision
async function auditLog(action, user, resource, allowed, reason) {
  await prisma.auditLog.create({
    data: {
      user_id: user.id,
      resource_type: 'document',
      resource_id: resource.id,
      action,
      allowed,
      reason, // "denied: user.department != resource.department"
      ip: req.ip,
      timestamp: new Date()
    }
  });
}

// In checkPermission
if (!allowed) {
  await auditLog('document.edit', user, document, false, 'Department mismatch');
}
```

**Performance Optimization**:
- Cache policy evaluation results (5-60s TTL)
- Precompute user attributes at login (embed in JWT)
- Batch permission checks (avoid N+1 authorization queries)

**Migration Path: RBAC → ABAC**:
1. **Phase 1**: Keep RBAC, add ABAC for new features (hybrid)
2. **Phase 2**: Migrate high-risk actions (delete, export) to ABAC
3. **Phase 3**: Full ABAC rollout, deprecate RBAC

**Tools Comparison**:
| Tool | Complexity | Performance | Use Case |
|------|------------|-------------|----------|
| **Custom** | Low | Fast | Solo dev, simple rules (<10 policies) |
| **Casbin** | Medium | Fast | Mid-size app, dynamic policies |
| **OPA** | High | Fast | Enterprise, compliance, multi-service |
| **AWS Verified Permissions** | Medium | Fast | AWS-native, managed service |

**Decision Tree**:
```
Q: Do you need audit logs for compliance?
├─ No → Use custom lightweight ABAC
└─ Yes → Lanjut Q2

Q: Do you have >20 policies OR multi-service architecture?
├─ No → Use Casbin (Node.js library)
└─ Yes → Use OPA (sidecar service)
```

---

## 17. Reliability & Resiliency

### 17.1 Graceful Degradation

**Example**: Payment gateway down → allow "pay later" option instead of blocking checkout.

```javascript
try {
  await stripePayment.charge({ amount });
} catch (error) {
  // Fallback: Save order as "payment pending"
  await prisma.order.create({
    data: { ...orderData, status: 'payment_pending' },
  });
  return { success: true, message: 'Order created, complete payment via email link' };
}
```

### 17.2 Health Check Endpoints

**Kubernetes-style Probes**:
```javascript
// Liveness: Is process alive?
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// Readiness: Can handle traffic?
app.get('/ready', async (req, res) => {
  try {
    await prisma.$queryRaw`SELECT 1`; // DB check
    await redis.ping(); // Cache check
    res.json({ status: 'ready' });
  } catch (error) {
    res.status(503).json({ status: 'not ready', error: error.message });
  }
});
```

### 17.3 Chaos Engineering

**Concept**: Inject failures in production to test resilience.

**Chaos Monkey** (Netflix):
- Randomly terminate instances
- Simulate network latency
- Throttle API responses

**Solo Dev Lite**:
```javascript
// Inject random failures in staging
app.use((req, res, next) => {
  if (process.env.NODE_ENV === 'staging' && Math.random() < 0.01) {
    return res.status(500).json({ error: 'Chaos injection' });
  }
  next();
});
```

---

## 18. High Availability Architecture

### 18.1 Multi-AZ Deployment

**AWS Example**:
- Deploy app to 3 AZs (ap-southeast-1a, 1b, 1c)
- RDS Multi-AZ (automatic failover)
- ALB routes traffic to healthy instances

**Vercel**: Auto-deploys to multiple regions globally.

### 18.2 Active-Active vs Active-Passive

**Active-Active**: Both regions serve traffic (complex, requires conflict resolution)
**Active-Passive**: Primary serves traffic, standby ready for failover (simpler)

**Solo Dev**: Active-Passive dengan managed failover (RDS Multi-AZ, PlanetScale).

### 18.3 Quorum-Based Consensus

**Raft/Paxos**: Distributed systems elect leader via voting.

**Solo Dev**: Avoid implementing yourself. Use managed services (etcd, Consul, PlanetScale).

---

## 19. Security & Infrastructure

### 19.1 DDoS Protection Layers

**Layer 3/4 (Network)**: AWS Shield, Cloudflare Magic Transit
**Layer 7 (Application)**: WAF rules, rate limiting

**Cloudflare** (Lazy Stack):
- Under Attack Mode (JavaScript challenge)
- Rate limiting rules (100 req/min per IP)
- Bot Fight Mode (block known bots)

### 19.2 Zero-Trust Architecture

**Principles**:
- Never trust, always verify
- Least privilege access
- Assume breach

**Implementation**:
```javascript
// Every API call requires valid JWT
app.use(async (req, res, next) => {
  const token = req.headers.authorization?.replace('Bearer ', '');
  if (!token) return res.status(401).json({ error: 'Unauthorized' });
  
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(401).json({ error: 'Invalid token' });
  }
});
```

### 19.3 Secrets Management

**Never**:
- Commit secrets to Git
- Hardcode API keys

**Do**:
```bash
# .env (gitignored)
DATABASE_URL="postgresql://..."
STRIPE_SECRET_KEY="sk_live_..."

# Production: Use secrets manager
# AWS Secrets Manager, Doppler, HashiCorp Vault
```

**Vercel**:
```bash
vercel env add DATABASE_URL production
vercel env add STRIPE_SECRET_KEY production
```

---

## Summary: Solo Dev Infrastructure Checklist

**< 10K MAU (Boring Stack)**:
- [ ] Single-region VPS/PaaS (Vercel, Fly.io, Railway)
- [ ] Managed PostgreSQL (Supabase, Neon, PlanetScale)
- [ ] CDN (Cloudflare Free)
- [ ] Uptime monitoring (UptimeRobot Free)
- [ ] Error tracking (Sentry Free tier)

**10K-100K MAU (Scaling Up)**:
- [ ] Horizontal auto-scaling (Vercel Pro, AWS ECS)
- [ ] Database read replicas
- [ ] Redis caching layer (Upstash, AWS ElastiCache)
- [ ] Background job queue (Bull + Redis)
- [ ] Structured logging (Axiom, Datadog)
- [ ] Load testing (k6 monthly)

**> 100K MAU (Mature Architecture)**:
- [ ] Multi-region CDN with edge functions
- [ ] Database sharding or distributed SQL (CockroachDB, PlanetScale)
- [ ] Message broker (AWS SQS, RabbitMQ)
- [ ] Distributed tracing (OpenTelemetry)
- [ ] Automated failover (Multi-AZ)
- [ ] Chaos engineering quarterly drills
- [ ] On-call rotation + runbooks

---

## 🛑 PROTOKOL [GATE] KELUAR (OPTIONAL - REFERENCE MODULE)

**⚠️ CATATAN**: Module 05B adalah **reference guide**, bukan mandatory pipeline step. Gate ini hanya berlaku jika user memutuskan untuk mendokumentasikan infrastructure design formal.

**JIKA user membuat infrastructure documentation**:

### **LANGKAH 0: VERIFIKASI EKSISTENSI BERKAS (BLOCKING CHECK)**

**HANYA JIKA user create docs/infrastructure/ files**:

1. **Cek keberadaan file output** (jika dibuat):
   - PowerShell: `Test-Path -LiteralPath "docs/infrastructure/SYSTEM_DESIGN.md"` → harus return `True`
   - PowerShell: `Test-Path -LiteralPath "docs/infrastructure/DISASTER_RECOVERY_PLAN.md"` → harus return `True`

2. **JIKA FILE DIRENCANAKAN TAPI TIDAK ADA**:
   - ❌ **STOP IMMEDIATELY** - jangan declare documentation complete
   - ✅ **REPORT ERROR** ke user:
     ```
     ERROR: Infrastructure documentation files tidak tercipta.
     
     Tolong investigasi issue ini sebelum declare complete.
     ```
   - ✅ **END TURN** dan tunggu user fix issue

3. **JIKA user SKIP documentation** (common for MVP):
   - ✅ OK to proceed - this is optional module
   - No gate enforcement needed

---

**KAPAN MODULE INI WAJIB**:
- Skala Besar/Enterprise projects (>100K MAU)
- Compliance requirements (SOC2, ISO 27001)
- Multi-region deployments
- Financial/Healthcare applications

**KAPAN MODULE INI OPTIONAL/SKIP**:
- MVP/Small projects (<10K MAU)
- Simple single-region deployments
- PaaS-managed infrastructure (Vercel, Railway)
