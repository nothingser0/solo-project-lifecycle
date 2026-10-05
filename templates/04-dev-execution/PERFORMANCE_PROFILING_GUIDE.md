# Performance Profiling Guide

> **Purpose**: Identify and fix performance bottlenecks  
> **When**: M07 QA or post-launch optimization  
> **Target**: Large/Enterprise projects with performance requirements

---

## Performance Targets by Scale

| Scale | Page Load | API Response | Database Query | Concurrent Users |
|:------|:----------|:-------------|:---------------|:-----------------|
| Small | <3s | <500ms | <100ms | 10-50 |
| Medium | <2s | <300ms | <50ms | 50-500 |
| **Large** | **<1s** | **<200ms** | **<30ms** | **500-5000** |
| Enterprise | <500ms | <100ms | <10ms | 5000+ |

---

## Performance Profiling Tools

### Frontend Performance

**Chrome DevTools**:
- Lighthouse (overall score)
- Performance tab (flame graph)
- Network tab (waterfall)
- Coverage tab (unused code)

**Web Vitals**:
- LCP (Largest Contentful Paint): <2.5s
- FID (First Input Delay): <100ms
- CLS (Cumulative Layout Shift): <0.1

---

### Backend Performance

**Node.js**:
- `node --inspect` + Chrome DevTools
- `clinic.js` (flame graphs, bubbleprof)
- `0x` (flamegraph profiler)

**Database**:
- PostgreSQL: `EXPLAIN ANALYZE`
- MySQL: `EXPLAIN` + slow query log
- MongoDB: `.explain("executionStats")`

**APM Tools**:
- Datadog APM
- New Relic
- Sentry Performance

---

## Step-by-Step Profiling

### Step 1: Identify Bottleneck

**Symptoms**:
- Page loads >3s
- API calls timeout
- Database queries slow
- High CPU/memory usage

**Measure first**:
```bash
# Frontend: Run Lighthouse
npx lighthouse https://yourapp.com --view

# Backend: Add timing logs
console.time('api-call');
const result = await fetchData();
console.timeEnd('api-call'); // api-call: 1234ms

# Database: Explain query
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'test@example.com';
```

---

### Step 2: Profile Frontend

#### Lighthouse Audit

1. Open Chrome DevTools → Lighthouse tab
2. Select categories: Performance, Accessibility, Best Practices
3. Click "Analyze page load"
4. Review scores (aim for 90+)

**Common Issues**:
- Unoptimized images (use WebP, lazy loading)
- Render-blocking CSS/JS (defer non-critical)
- Unused JavaScript (code splitting)
- No caching headers

**Example Fixes**:
```jsx
// Before: Eager load all images
<img src="/hero.jpg" alt="Hero" />

// After: Lazy load + WebP
<img 
  src="/hero.webp" 
  alt="Hero" 
  loading="lazy"
  width="800"
  height="600"
/>
```

---

#### Performance Timeline

1. DevTools → Performance tab
2. Click record → Reload page → Stop
3. Analyze flame graph

**Look for**:
- Long tasks (>50ms yellow blocks)
- Layout thrashing (multiple reflows)
- Memory leaks (heap growing)

**Example Fix (React)**:
```jsx
// Before: Re-renders on every state change
function ExpensiveList({ items }) {
  return items.map(item => <Item key={item.id} data={item} />);
}

// After: Memoize to prevent unnecessary re-renders
const ExpensiveList = React.memo(({ items }) => {
  return items.map(item => <Item key={item.id} data={item} />);
});
```

---

### Step 3: Profile Backend API

#### Add Timing Middleware

```typescript
// Express middleware
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    console.log(`${req.method} ${req.path} ${duration}ms`);
    if (duration > 200) {
      console.warn(`SLOW: ${req.method} ${req.path} took ${duration}ms`);
    }
  });
  next();
});
```

**Output**:
```
GET /api/users 45ms
POST /api/orders 123ms
GET /api/reports 1234ms  <-- SLOW!
SLOW: GET /api/reports took 1234ms
```

---

#### Profile with clinic.js

```bash
# Install
npm install -g clinic

# Profile CPU
clinic doctor -- node server.js

# Generate flamegraph
clinic flame -- node server.js

# Profile event loop
clinic bubbleprof -- node server.js

# Open browser, use app, Ctrl+C to stop
# Clinic generates HTML report
```

**Example Finding**:
```
Flamegraph shows:
- 60% time in getUserReport()
  - 50% time in database query
  - 10% time in JSON serialization

Fix: Optimize query, add indexes
```

---

### Step 4: Profile Database

#### PostgreSQL: EXPLAIN ANALYZE

```sql
-- Slow query
EXPLAIN ANALYZE 
SELECT orders.*, users.name 
FROM orders 
JOIN users ON orders.user_id = users.id 
WHERE orders.status = 'pending'
ORDER BY orders.created_at DESC;

-- Output shows:
-- Seq Scan on orders (cost=0.00..1234.56 rows=10000) (actual time=0.123..45.678 rows=9876)
--   Filter: (status = 'pending')
-- Hash Join (cost=12.34..567.89 rows=10000) (actual time=1.234..56.789 rows=9876)
```

**Red flags**:
- `Seq Scan` (full table scan) → Add index
- `actual time` >> `cost` → Outdated statistics
- `rows=10000` but `actual rows=9876` → Stats wrong

**Fix**:
```sql
-- Add index
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at DESC);

-- Update statistics
ANALYZE orders;

-- Re-run EXPLAIN ANALYZE
-- Should now show "Index Scan" instead of "Seq Scan"
```

---

#### N+1 Query Problem

**Symptom**: 1 query + N queries for related data

**Example (Bad)**:
```typescript
// Fetches users
const users = await User.findAll(); // 1 query

// Fetches posts for each user (N queries!)
for (const user of users) {
  user.posts = await Post.findAll({ where: { userId: user.id } }); // N queries
}
// Total: 1 + N queries (if 100 users = 101 queries!)
```

**Fix (Eager Loading)**:
```typescript
// Single query with JOIN
const users = await User.findAll({
  include: [{ model: Post }]
});
// Total: 1 query
```

---

### Step 5: Load Testing

#### k6 (Recommended)

**Install**:
```bash
# macOS
brew install k6

# Windows
choco install k6

# Linux
sudo apt install k6
```

**Load test script** (`load-test.js`):
```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '1m', target: 50 },   // Ramp up to 50 users
    { duration: '3m', target: 50 },   // Stay at 50 users
    { duration: '1m', target: 100 },  // Ramp up to 100 users
    { duration: '3m', target: 100 },  // Stay at 100 users
    { duration: '1m', target: 0 },    // Ramp down to 0
  ],
  thresholds: {
    http_req_duration: ['p(95)<200'], // 95% of requests <200ms
    http_req_failed: ['rate<0.01'],   // <1% failure rate
  },
};

export default function () {
  const res = http.get('https://staging.yourapp.com/api/users');
  
  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time <200ms': (r) => r.timings.duration < 200,
  });
  
  sleep(1);
}
```

**Run**:
```bash
k6 run load-test.js
```

**Output**:
```
     ✓ status is 200
     ✓ response time <200ms

     checks.........................: 100.00% ✓ 5000  ✗ 0
     data_received..................: 15 MB   50 kB/s
     data_sent......................: 500 kB  1.7 kB/s
     http_req_duration..............: avg=145ms min=89ms med=142ms max=234ms p(90)=178ms p(95)=198ms
     http_reqs......................: 5000    16.6/s
     vus............................: 100     min=0   max=100
```

**Interpretation**:
- ✅ **Good**: p(95)=198ms (under 200ms threshold)
- ❌ **Bad**: If p(95)>200ms or failure rate >1%

---

#### Autocannon (Alternative)

```bash
# Install
npm install -g autocannon

# Run load test
autocannon -c 100 -d 60 https://staging.yourapp.com/api/users

# -c 100 = 100 concurrent connections
# -d 60 = 60 seconds duration
```

---

### Step 6: Memory Profiling

#### Node.js Heap Snapshot

```bash
# Start node with inspector
node --inspect server.js

# Open chrome://inspect in Chrome
# Click "Open dedicated DevTools for Node"
# Go to Memory tab → Take heap snapshot
# Use app, take another snapshot
# Compare to find memory leaks
```

**Common Leaks**:
- Event listeners not removed
- Closures holding references
- Global variables accumulating data
- Timers not cleared

**Example Fix**:
```typescript
// Before: Memory leak (listener never removed)
app.get('/stream', (req, res) => {
  const listener = (data) => res.write(data);
  eventEmitter.on('data', listener);
  // Never calls eventEmitter.off('data', listener)
});

// After: Cleanup on close
app.get('/stream', (req, res) => {
  const listener = (data) => res.write(data);
  eventEmitter.on('data', listener);
  
  res.on('close', () => {
    eventEmitter.off('data', listener); // Remove listener
  });
});
```

---

## Performance Optimization Checklist

### Frontend Optimization

- [ ] **Images**: WebP format, lazy loading, responsive sizes
- [ ] **JavaScript**: Code splitting, tree shaking, minification
- [ ] **CSS**: Critical CSS inline, defer non-critical
- [ ] **Fonts**: Preload, font-display: swap
- [ ] **Caching**: Service worker, HTTP cache headers
- [ ] **CDN**: Static assets on CDN (Cloudflare, CloudFront)

**Example** (Next.js):
```jsx
import Image from 'next/image';

// Automatic WebP, lazy loading, responsive sizes
<Image 
  src="/hero.jpg" 
  alt="Hero" 
  width={800} 
  height={600} 
  priority // Only for above-fold images
/>
```

---

### Backend Optimization

- [ ] **Database**: Indexes on WHERE/JOIN columns
- [ ] **Queries**: Eager loading (avoid N+1), limit fields
- [ ] **Caching**: Redis for hot data, CDN for static
- [ ] **Compression**: gzip/brotli response compression
- [ ] **Connection pools**: Reuse DB connections
- [ ] **Async**: Use async/await, avoid blocking

**Example** (Node.js + PostgreSQL):
```typescript
// Before: No connection pool, slow
const client = new Client({ connectionString: DATABASE_URL });
await client.connect();
const result = await client.query('SELECT * FROM users');
await client.end(); // Reconnects every time!

// After: Connection pool, fast
const pool = new Pool({ connectionString: DATABASE_URL });
const result = await pool.query('SELECT * FROM users');
// No end() call, pool reuses connections
```

---

### Database Optimization

- [ ] **Indexes**: Add indexes for frequent queries
- [ ] **Query optimization**: Use EXPLAIN ANALYZE
- [ ] **Connection pooling**: Max 10-20 connections
- [ ] **Read replicas**: Offload reads from primary
- [ ] **Partitioning**: Split large tables (>10M rows)
- [ ] **Vacuum**: Periodic VACUUM for PostgreSQL

**Example** (Index strategy):
```sql
-- Orders table (1M rows)
-- Query: Filter by status + sort by date
SELECT * FROM orders WHERE status = 'pending' ORDER BY created_at DESC LIMIT 20;

-- Add composite index (status + created_at)
CREATE INDEX idx_orders_status_created ON orders(status, created_at DESC);

-- Query now uses index (500x faster)
```

---

## Performance Budget

**Set limits, fail build if exceeded**:

```json
// lighthouse-budget.json
[
  {
    "path": "/*",
    "timings": [
      { "metric": "interactive", "budget": 3000 },
      { "metric": "first-contentful-paint", "budget": 1000 }
    ],
    "resourceSizes": [
      { "resourceType": "script", "budget": 200 },
      { "resourceType": "image", "budget": 500 },
      { "resourceType": "total", "budget": 1000 }
    ]
  }
]
```

**CI check**:
```bash
# Run Lighthouse in CI
npx lighthouse https://staging.yourapp.com \
  --budget-path=lighthouse-budget.json \
  --output=json \
  --output-path=lighthouse-report.json

# Fail if budget exceeded
if grep -q "overBudget" lighthouse-report.json; then
  echo "Performance budget exceeded!"
  exit 1
fi
```

---

## Monitoring (Post-Launch)

**Track in production**:
- **APM**: Datadog, New Relic (server-side metrics)
- **RUM**: Google Analytics, Sentry Performance (client-side)
- **Synthetic**: Pingdom, UptimeRobot (health checks)

**Alerts**:
- API response time p(95) > 300ms
- Error rate > 1%
- CPU usage > 80%
- Memory usage > 85%

---

## Example: Full Performance Audit

**Scenario**: Reports page loading in 5 seconds (too slow)

### Step 1: Measure

```bash
# Lighthouse score: 45/100 (bad)
npx lighthouse https://app.com/reports
```

### Step 2: Profile Frontend

- LCP: 4.2s (image loading)
- FID: 150ms (JavaScript blocking)
- CLS: 0.3 (layout shift)

### Step 3: Fix Frontend

1. Convert PNG images to WebP (-60% size)
2. Add lazy loading to below-fold images
3. Code split reports page bundle (-40% JS)
4. Defer non-critical CSS

### Step 4: Profile Backend

```
GET /api/reports took 3200ms
```

### Step 5: Fix Backend

```sql
-- EXPLAIN ANALYZE shows Seq Scan
-- Add index
CREATE INDEX idx_reports_user_date ON reports(user_id, created_at DESC);

-- Query time: 3200ms → 45ms (70x faster!)
```

### Step 6: Re-measure

```bash
# Lighthouse score: 92/100 (excellent)
# Page load: 5s → 1.2s (4x faster!)
```

---

## Checklist

Before profiling:
- [ ] Define performance targets (page load, API response)
- [ ] Set up profiling tools (Lighthouse, k6, clinic.js)
- [ ] Create baseline metrics

During profiling:
- [ ] Identify bottleneck (frontend vs backend vs database)
- [ ] Profile specific bottleneck
- [ ] Fix root cause (not symptoms)
- [ ] Measure improvement

After optimization:
- [ ] Re-run performance tests
- [ ] Set up monitoring alerts
- [ ] Document optimizations
- [ ] Add performance budget to CI

---

## Notes

**Premature optimization is evil**: Profile first, optimize proven bottlenecks

**80/20 rule**: Fix the top 20% slowest code first (biggest impact)

**Measure twice, optimize once**: Always measure before and after

**Performance is a feature**: Budget time for optimization in sprint planning
