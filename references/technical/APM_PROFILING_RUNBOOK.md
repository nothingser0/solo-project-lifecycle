# Post-Launch Performance Profiling & APM Runbook

> **Purpose**: Systematic performance monitoring and optimization runbook for post-launch operations (M13). Detect bottlenecks, optimize queries, and prevent performance degradation.

---

## 1. APM Tool Selection (Boring Tech Ladder)

| Tool | Best For | Free Tier | Key Features |
|------|----------|-----------|--------------|
| **Sentry Performance** | Full-stack JS/Python/Go | 5K transactions/mo | Error tracking + APM, source maps, releases |
| **New Relic** | Enterprise polyglot | 100GB/mo free | Deep traces, SQL analysis, infra monitoring |
| **Datadog** | Multi-cloud infrastructure | Trial only | Logs + metrics + traces unified |
| **Application Insights** | Azure-hosted apps | 5GB/mo free | .NET native, Azure integration |
| **Prometheus + Grafana** | Self-hosted, open-source | Free (DIY) | Time-series metrics, custom dashboards |

**Recommended Stack**: Sentry (errors) + Prometheus + Grafana (metrics) for solo dev
- Sentry: Free 5K errors/mo sufficient for <10K MAU
- Prometheus: Self-hosted metrics collection
- Grafana: Free dashboards, alert rules

---

## 2. Core Metrics to Monitor (RED Method)

### Request Rate
- **Metric**: Requests per second (RPS)
- **Target**: Track baseline, alert on 3× spike
- **Why**: Detect traffic surges, DDoS, bot attacks

### Error Rate
- **Metric**: Errors / Total requests (%)
- **Target**: <1% (99%+ success rate)
- **Alert**: >5% sustained for 5 minutes

### Duration (Latency)
- **Metric**: P50, P95, P99 response time
- **Target**: 
  - P50 <200ms (median user experience)
  - P95 <500ms (95% users satisfied)
  - P99 <1000ms (catch outliers)
- **Alert**: P95 >1000ms

---

## 3. Database Performance Profiling

### PostgreSQL Slow Query Log

**Enable slow query logging**:
```sql
-- postgresql.conf or runtime
ALTER DATABASE yourdb SET log_min_duration_statement = 100; -- Log queries >100ms
```

**Analyze slow queries**:
```sql
-- Install pg_stat_statements extension
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- Top 10 slowest queries (by total time)
SELECT 
  calls,
  total_exec_time / 1000 AS total_seconds,
  mean_exec_time / 1000 AS mean_ms,
  query
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 10;
```

**Common bottlenecks**:
1. **Missing indexes**: Sequential scans on large tables
2. **N+1 queries**: ORM lazy loading (fetch related data in loop)
3. **Inefficient JOINs**: Cartesian products, missing foreign key indexes
4. **Large OFFSET**: Pagination with high offset (use cursor-based instead)

---

### Query Optimization Workflow

**Step 1: Identify slow query from logs**
```sql
-- Example slow query
SELECT * FROM orders 
WHERE user_id = 123 AND status = 'pending' 
ORDER BY created_at DESC;
```

**Step 2: Run EXPLAIN ANALYZE**
```sql
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM orders 
WHERE user_id = 123 AND status = 'pending' 
ORDER BY created_at DESC;
```

**Output analysis**:
- **Seq Scan** (bad) → Add index
- **Index Scan** (good) but high cost → Index selectivity issue
- **Nested Loop** with large row count → JOIN order problem

**Step 3: Add covering index**
```sql
-- Before: Sequential scan on 1M rows
CREATE INDEX idx_orders_user_status_created 
ON orders(user_id, status, created_at DESC);

-- After: Index scan on 50 rows (20,000× faster)
```

**Step 4: Verify improvement**
```sql
-- Re-run EXPLAIN ANALYZE
-- Compare "Execution Time" before/after
```

---

### Index Maintenance Audit (Monthly)

```sql
-- Find unused indexes (candidates for removal)
SELECT 
  schemaname,
  tablename,
  indexname,
  idx_scan,
  pg_size_pretty(pg_relation_size(indexrelid)) AS size
FROM pg_stat_user_indexes
WHERE idx_scan = 0 
  AND indexrelname NOT LIKE '%_pkey'
ORDER BY pg_relation_size(indexrelid) DESC;

-- Find missing indexes (high seq scans)
SELECT 
  schemaname,
  tablename,
  seq_scan,
  seq_tup_read,
  idx_scan,
  seq_tup_read / seq_scan AS avg_rows_per_scan
FROM pg_stat_user_tables
WHERE seq_scan > 100
ORDER BY seq_tup_read DESC
LIMIT 10;
```

---

## 4. Application Code Profiling

### Node.js/Next.js

**Option A: Sentry Performance Monitoring**

```typescript
// sentry.server.config.ts
Sentry.init({
  dsn: process.env.SENTRY_DSN,
  tracesSampleRate: 0.1, // Sample 10% of requests
  profilesSampleRate: 0.1, // Profile 10% of traces
  integrations: [
    new Sentry.Integrations.Http({ tracing: true }),
    new Sentry.Integrations.Prisma({ client: prisma }),
  ],
});
```

```typescript
// app/api/orders/route.ts
import * as Sentry from '@sentry/nextjs';

export async function GET() {
  const transaction = Sentry.startTransaction({
    op: 'http.server',
    name: 'GET /api/orders',
  });
  
  // Measure database query
  const span = transaction.startChild({
    op: 'db.query',
    description: 'SELECT orders',
  });
  
  const orders = await prisma.order.findMany();
  span.finish();
  
  transaction.finish();
  return Response.json(orders);
}
```

**Option B: Built-in Node.js Profiler**

```bash
# Generate CPU profile
node --prof server.js
# Generate flame graph
node --prof-process isolate-*.log > profile.txt
```

**Option C: Clinic.js (Development)**

```bash
npm install -g clinic
clinic doctor -- node server.js
# Open browser to view diagnostics
```

---

### Python/FastAPI

**cProfile + SnakeViz**:
```python
import cProfile
import pstats

profiler = cProfile.Profile()
profiler.enable()

# Your code
result = expensive_function()

profiler.disable()
stats = pstats.Stats(profiler)
stats.sort_stats('cumulative')
stats.print_stats(20)  # Top 20 functions by cumulative time
```

**Py-Spy (Production-safe)**:
```bash
pip install py-spy
# Sample running process without stopping it
py-spy record -o profile.svg --pid 12345
# Open profile.svg in browser
```

---

## 5. Frontend Performance Profiling

### Lighthouse CI (Automated)

```yaml
# .github/workflows/lighthouse.yml
name: Lighthouse CI
on: [pull_request]
jobs:
  lighthouse:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm install && npm run build
      - run: npx @lhci/cli@0.12.x autorun
        env:
          LHCI_GITHUB_APP_TOKEN: ${{ secrets.LHCI_GITHUB_APP_TOKEN }}
```

**Performance Budget**:
```json
// lighthouserc.json
{
  "ci": {
    "assert": {
      "preset": "lighthouse:recommended",
      "assertions": {
        "first-contentful-paint": ["error", {"maxNumericValue": 2000}],
        "largest-contentful-paint": ["error", {"maxNumericValue": 2500}],
        "cumulative-layout-shift": ["error", {"maxNumericValue": 0.1}],
        "total-blocking-time": ["error", {"maxNumericValue": 300}]
      }
    }
  }
}
```

---

### Real User Monitoring (RUM)

**Web Vitals Tracking**:
```typescript
// app/layout.tsx
import { onCLS, onFID, onLCP, onFCP, onTTFB } from 'web-vitals';

function sendToAnalytics(metric) {
  fetch('/api/analytics/web-vitals', {
    method: 'POST',
    body: JSON.stringify(metric),
    keepalive: true,
  });
}

onCLS(sendToAnalytics);
onFID(sendToAnalytics);
onLCP(sendToAnalytics);
onFCP(sendToAnalytics);
onTTFB(sendToAnalytics);
```

**Backend aggregation**:
```sql
-- Store in timescale/clickhouse for time-series analysis
CREATE TABLE web_vitals (
  timestamp TIMESTAMPTZ NOT NULL,
  metric VARCHAR(10) NOT NULL,
  value FLOAT NOT NULL,
  page_url TEXT,
  user_agent TEXT
);

-- Analyze P75 LCP by page
SELECT 
  page_url,
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY value) AS p75_lcp
FROM web_vitals
WHERE metric = 'LCP' AND timestamp > NOW() - INTERVAL '7 days'
GROUP BY page_url
ORDER BY p75_lcp DESC;
```

---

## 6. Infrastructure Monitoring

### Prometheus + Grafana Setup

**docker-compose.yml**:
```yaml
version: '3'
services:
  prometheus:
    image: prom/prometheus
    ports:
      - 9090:9090
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      
  grafana:
    image: grafana/grafana
    ports:
      - 3000:3000
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=secret
```

**prometheus.yml**:
```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'app'
    static_configs:
      - targets: ['app:3000']
        
  - job_name: 'postgres'
    static_configs:
      - targets: ['postgres-exporter:9187']
```

**Expose metrics in app**:
```typescript
// app/api/metrics/route.ts
import { register, Counter, Histogram } from 'prom-client';

const httpRequestDuration = new Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code'],
});

const httpRequestTotal = new Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code'],
});

export async function GET() {
  const metrics = await register.metrics();
  return new Response(metrics, {
    headers: { 'Content-Type': register.contentType },
  });
}
```

---

### Key Dashboards to Create

**1. Application Performance**:
- Request rate (RPM)
- Error rate (%)
- P50/P95/P99 latency
- Active users (gauge)

**2. Database Health**:
- Connections active/idle
- Query duration P95
- Cache hit ratio (>90% good)
- Disk usage (alert >80%)

**3. Infrastructure**:
- CPU usage (%)
- Memory usage (%)
- Disk I/O
- Network traffic

---

## 7. Performance Optimization Checklist (Monthly)

### Database Layer
- [ ] Run slow query report
- [ ] Identify queries >100ms
- [ ] Add missing indexes (max 5 per table)
- [ ] Remove unused indexes
- [ ] Vacuum + analyze tables
- [ ] Check for table bloat

### Application Layer
- [ ] Profile slowest API endpoints (P95 >500ms)
- [ ] Fix N+1 queries (use eager loading)
- [ ] Add caching for repeated queries (Redis)
- [ ] Optimize large JSON payloads (pagination)
- [ ] Check for memory leaks (heap snapshots)

### Frontend Layer
- [ ] Run Lighthouse audit
- [ ] Optimize images (WebP, lazy loading)
- [ ] Code split large bundles (>200KB)
- [ ] Remove unused dependencies
- [ ] Enable compression (Brotli/gzip)
- [ ] Check LCP <2.5s, CLS <0.1

### Infrastructure Layer
- [ ] Review resource utilization (CPU/RAM)
- [ ] Scale up if >80% sustained
- [ ] Enable CDN for static assets
- [ ] Configure HTTP/2 or HTTP/3
- [ ] Enable connection pooling (Prisma, PgBouncer)

---

## 8. Performance Incident Response

### Severity Levels

| Severity | Definition | Response Time | Example |
|----------|------------|---------------|---------|
| **P0 (Critical)** | Site down, 50%+ error rate | <15 min | Database connection pool exhausted |
| **P1 (High)** | Major feature broken, 10%+ errors | <1 hour | Payment gateway timeout |
| **P2 (Medium)** | Slow performance, user complaints | <4 hours | Query taking 5s instead of 200ms |
| **P3 (Low)** | Minor degradation, no user impact | <24 hours | Dashboard load time increased 20% |

---

### Incident Runbook Template

**1. Detect** (Automated alert):
```
Alert: P95 latency > 1000ms for 5 minutes
Endpoint: POST /api/orders
Time: 2026-10-02 10:23 UTC
```

**2. Triage**:
- Check error rate: Normal or spiking?
- Check traffic: Sudden spike?
- Check database: Connection pool full?
- Check external APIs: Third-party outage?

**3. Mitigate**:
- Quick fix: Restart service, clear cache, scale up
- Temporary: Disable non-critical features
- Rollback: Deploy previous version if recent change

**4. Resolve**:
- Root cause analysis (RCA)
- Permanent fix deployed
- Monitoring confirms resolution

**5. Post-Mortem** (Within 48 hours):
```markdown
## Incident: Slow Order Creation (2026-10-02)

**Impact**: 200 users affected, 5-minute degradation  
**Root Cause**: Missing index on orders(user_id, status)  
**Detection**: Sentry alert P95 >1000ms  
**Resolution**: Added composite index, latency back to <200ms  

**Action Items**:
- [ ] Add index creation to migration checklist
- [ ] Improve test data volume (catch missing indexes pre-prod)
- [ ] Set alert threshold to P95 >500ms (earlier detection)
```

---

## 9. M13 Integration: Continuous Performance Monitoring

**Add to M13 (Product Operations) Checklist**:

### Week 1 Post-Launch
- [ ] Establish baseline metrics (P50/P95/P99 latency)
- [ ] Set alert thresholds (error rate >1%, P95 >500ms)
- [ ] Create Grafana dashboards (RED metrics)
- [ ] Run initial Lighthouse audit (save score)

### Week 4 (30-day Review)
- [ ] Run full performance audit (this runbook)
- [ ] Identify top 5 slowest queries → optimize
- [ ] Check for N+1 queries in logs
- [ ] Review frontend bundle size
- [ ] Compare Web Vitals vs baseline

### Monthly Ongoing
- [ ] Review slow query report
- [ ] Check index usage (add/remove)
- [ ] Profile top 3 slowest endpoints
- [ ] Run Lighthouse CI (track score trend)
- [ ] Review infrastructure utilization

### Quarterly
- [ ] Deep performance audit (full checklist)
- [ ] Load testing (k6) at 2× current traffic
- [ ] Review and update performance budgets
- [ ] Upgrade dependencies (patch performance fixes)

---

## 10. Performance Budget Template

```json
{
  "budgets": [
    {
      "resourceSizes": [
        {"resourceType": "script", "budget": 200},
        {"resourceType": "image", "budget": 500},
        {"resourceType": "total", "budget": 1000}
      ]
    },
    {
      "timings": [
        {"metric": "first-contentful-paint", "budget": 2000},
        {"metric": "largest-contentful-paint", "budget": 2500},
        {"metric": "time-to-interactive", "budget": 3500}
      ]
    }
  ],
  "api": {
    "p50_latency_ms": 150,
    "p95_latency_ms": 400,
    "p99_latency_ms": 800,
    "error_rate_percent": 0.5
  },
  "database": {
    "p95_query_ms": 50,
    "connection_pool_utilization": 70,
    "cache_hit_rate_percent": 90
  }
}
```

**Enforcement**: Fail CI/CD pipeline if budgets exceeded

---

**Created**: 2026-10-02  
**Version**: 1.0  
**Integration**: Add to M13 ongoing operations checklist
