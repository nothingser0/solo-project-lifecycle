# Capacity Planning: [Project Name]

**Version**: 1.0  
**Date**: [YYYY-MM-DD]  
**Planning Period**: [Q1 2027 / Year 2027]
**Author**: [Your Name]

---

## 1. Current Baseline

**Measurement Period**: [Last 30 days]  
**Last Updated**: [YYYY-MM-DD]

### 1.1 Traffic Metrics

| Metric | Current | Peak | Average |
|--------|---------|------|---------|
| MAU (Monthly Active Users) | [5,000] | [8,000] | [4,500] |
| DAU (Daily Active Users) | [1,200] | [2,000] | [1,000] |
| Peak concurrent users | [150] | [250] | [100] |
| Requests per second (RPS) | [20] | [80] | [15] |
| Bandwidth (GB/day) | [10] | [25] | [8] |

### 1.2 Resource Utilization

**Application Servers**:
- Instance type: [2 vCPU, 4GB RAM]
- Count: [2 instances]
- CPU average: [35%]
- CPU peak: [72%]
- Memory average: [45%]
- Memory peak: [68%]

**Database**:
- Instance type: [db.t3.medium - 2 vCPU, 4GB RAM]
- Storage: [25 GB used / 100 GB allocated]
- Connection pool: [15 avg / 50 max]
- IOPS: [800 avg / 3000 provisioned]
- Read/Write ratio: [70% read / 30% write]

**Cache (Redis)**:
- Memory: [512 MB used / 1 GB allocated]
- Hit rate: [85%]
- Eviction rate: [2%]

**Background Jobs**:
- Queue depth: [20 avg / 150 peak]
- Processing time: [2.5s avg, 8s p95]
- Failure rate: [0.5%]

---

## 2. Growth Projections

### 2.1 User Growth Forecast

**Assumptions**:
- Monthly growth rate: [20%] (based on [recent trends / marketing plan])
- Seasonality: [Holiday spike +50% in Dec, summer dip -20% in Jul-Aug]

| Month | MAU (Projected) | Growth % | Notes |
|-------|-----------------|----------|-------|
| Jan 2027 | 5,000 | — | Current baseline |
| Feb 2027 | 6,000 | +20% | Marketing campaign launch |
| Mar 2027 | 7,200 | +20% | — |
| Apr 2027 | 8,640 | +20% | — |
| May 2027 | 10,368 | +20% | — |
| Jun 2027 | 12,442 | +20% | Product launch v1.0 |
| Jul 2027 | 9,954 | -20% | Summer seasonality |
| Aug 2027 | 11,944 | +20% | — |
| Sep 2027 | 14,333 | +20% | — |
| Oct 2027 | 17,200 | +20% | — |
| Nov 2027 | 20,640 | +20% | Pre-holiday prep |
| Dec 2027 | 30,960 | +50% | Holiday spike |

**Conservative Scenario** (50% of projected): 15,480 MAU by Dec 2027
**Aggressive Scenario** (150% of projected): 46,440 MAU by Dec 2027

### 2.2 Traffic Scaling Formula

**Conversion Factors** (derived from current data):
- MAU to DAU ratio: 0.24 (24% daily active)
- DAU to peak concurrent users ratio: 0.20 (20% concurrent at peak hour)
- Peak RPS per concurrent user: 0.5 RPS/user

**Projected Traffic**:
```
Dec 2027 (Holiday spike):
- MAU: 30,960
- DAU: 30,960 × 0.24 = 7,430
- Peak CCU: 7,430 × 0.20 = 1,486
- Peak RPS: 1,486 × 2 ÷ 4 = 743 RPS

Conservative (Dec 2027):
- MAU: 15,480
- Peak RPS: 371 RPS

Aggressive (Dec 2027):
- MAU: 46,440
- Peak RPS: 1,115 RPS
```

---

## 3. Infrastructure Scaling Plan

### 3.1 Application Layer

**Current Capacity**: 2 instances × 50 RPS/instance = 100 RPS (with 2× safety factor = 50 RPS sustained)

**Scaling Thresholds**:

| Phase | MAU Target | Peak RPS | Required Instances | Action | Cost Impact |
|-------|------------|----------|-------------------|--------|-------------|
| **Phase 0** (Current) | 5,000 | 80 | 2 | Baseline | $40/mo |
| **Phase 1** | 12,000 | 200 | 3-4 | Add 1-2 instances + load balancer | +$20-40/mo |
| **Phase 2** | 25,000 | 450 | 6-8 | Horizontal auto-scaling (2-8 instances) | +$80/mo |
| **Phase 3** | 50,000 | 900 | 12-15 | Auto-scaling (4-15 instances) + CDN caching | +$150/mo |

**Triggers**:
- **Phase 1**: CPU > 70% for 10 min OR RPS > 120 sustained
- **Phase 2**: MAU > 20K OR RPS > 300 sustained
- **Phase 3**: MAU > 40K OR need multi-region

### 3.2 Database Layer

**Current Capacity**: Single instance, 50 connections, ~500 queries/sec

**Scaling Thresholds**:

| Phase | MAU Target | Strategy | Action | Cost Impact |
|-------|------------|----------|--------|-------------|
| **Phase 0** (Current) | 5,000 | Single instance | Baseline | $25/mo |
| **Phase 1** | 12,000 | Add read replica | Offload read queries (70% traffic) to replica | +$25/mo |
| **Phase 2** | 25,000 | Vertical scaling + 2 read replicas | Upgrade primary to 4 vCPU, 8GB RAM | +$75/mo |
| **Phase 3** | 50,000 | Connection pooling + caching | PgBouncer + Redis query cache | +$30/mo |
| **Phase 4** | 100,000+ | Sharding or distributed SQL | Evaluate PlanetScale, CockroachDB | +$200/mo |

**Triggers**:
- **Phase 1**: Connection pool > 80% (40+ connections) OR read latency > 100ms p95
- **Phase 2**: Storage > 70GB OR IOPS > 2500 sustained
- **Phase 3**: Connection pool exhaustion despite read replicas
- **Phase 4**: Single DB cannot handle write load (> 5000 writes/sec)

**Migration Plan**:
```
Phase 1 Implementation (Week 1-2):
1. Provision read replica (same region, async replication)
2. Update application code: write → primary, read → replica
3. Monitor replication lag (target < 1s)
4. Gradually shift read traffic 0% → 50% → 70% → 80%
```

### 3.3 Caching Layer

**Current Capacity**: 1 GB Redis (Upstash Free tier)

**Scaling Thresholds**:

| Phase | MAU Target | Strategy | Memory Needed | Cost |
|-------|------------|----------|---------------|------|
| **Phase 0** (Current) | 5,000 | Session + API cache | 512 MB | Free |
| **Phase 1** | 12,000 | Add query result cache | 2 GB | $10/mo |
| **Phase 2** | 25,000 | Multi-tier caching (in-memory + Redis) | 4 GB | $30/mo |
| **Phase 3** | 50,000 | Redis cluster (3 nodes) | 8 GB distributed | $80/mo |

**Cache Hit Rate Targets**:
- Session cache: > 95% (TTL: 1 hour)
- API response cache: > 80% (TTL: 5-60 min depending on endpoint)
- Query result cache: > 70% (TTL: 5 min)

### 3.4 Background Job Queue

**Current Capacity**: Single Redis queue, 50 jobs/min processing rate

**Scaling Thresholds**:

| Phase | Job Volume (per day) | Strategy | Action |
|-------|----------------------|----------|--------|
| **Phase 0** (Current) | 5,000 jobs/day | Single worker | Baseline |
| **Phase 1** | 20,000 jobs/day | 2-3 workers | Add worker instances |
| **Phase 2** | 100,000 jobs/day | Auto-scaling workers (2-10) | Horizontal worker scaling |
| **Phase 3** | 500,000+ jobs/day | Dedicated queue service | Migrate to AWS SQS or RabbitMQ |

**Monitoring Alerts**:
- Queue depth > 500 jobs → scale workers
- Processing time p95 > 30s → investigate slow jobs
- Failed jobs > 5% → alert + investigate

---

## 4. Cost Projections

### 4.1 Infrastructure Cost Breakdown

**Current Monthly Cost** (5K MAU):
| Service | Provider | Usage | Cost |
|---------|----------|-------|------|
| Application hosting | Vercel Pro | 2 instances | $20 |
| Database | Supabase Pro | Single instance | $25 |
| Cache | Upstash | 1 GB Redis | $0 (free tier) |
| CDN | Cloudflare Pro | 100 GB bandwidth | $20 |
| Monitoring | Sentry | 10K errors/mo | $0 (free tier) |
| **Total** | — | — | **$65/mo** |

**Projected Monthly Cost** (30K MAU - Dec 2027):
| Service | Provider | Usage | Cost |
|---------|----------|-------|------|
| Application hosting | Vercel Pro | Auto-scale 4-12 instances | $80 |
| Database | Supabase Pro | Primary + 2 read replicas | $75 |
| Cache | Upstash Redis | 4 GB | $30 |
| CDN | Cloudflare Pro | 1 TB bandwidth | $20 |
| Background jobs | Upstash Redis (queue) | — | $10 |
| Monitoring | Sentry Team | 50K errors/mo | $26 |
| Logging | Axiom | 10 GB/mo | $25 |
| **Total** | — | — | **$266/mo** |

**Conservative Estimate** (15K MAU): $150/mo  
**Aggressive Estimate** (50K MAU): $400/mo

### 4.2 Cost per User

| MAU | Monthly Cost | Cost per MAU | Revenue per MAU (if applicable) | Margin |
|-----|--------------|--------------|--------------------------------|--------|
| 5,000 | $65 | $0.013 | [e.g., $2.00] | 99.4% |
| 15,000 | $150 | $0.010 | [e.g., $2.00] | 99.5% |
| 30,000 | $266 | $0.009 | [e.g., $2.00] | 99.6% |
| 50,000 | $400 | $0.008 | [e.g., $2.00] | 99.6% |

**Cost Efficiency Improvement**: As scale increases, cost per user decreases due to better resource utilization and economies of scale.

---

## 5. Load Testing Plan

### 5.1 Test Scenarios

**Scenario 1: Normal Load** (Baseline)
- Concurrent users: 150
- Duration: 10 minutes
- Target: p95 latency < 500ms, error rate < 0.1%

**Scenario 2: Peak Load** (Expected holiday traffic)
- Concurrent users: 1,500
- Duration: 30 minutes
- Target: p95 latency < 1s, error rate < 1%

**Scenario 3: Stress Test** (Beyond expected capacity)
- Concurrent users: Ramp 0 → 3,000 over 10 min
- Duration: Until failure
- Goal: Identify breaking point

**Scenario 4: Soak Test** (Sustained load)
- Concurrent users: 500
- Duration: 2 hours
- Goal: Detect memory leaks, connection exhaustion

### 5.2 k6 Test Script

```javascript
// load-test-capacity.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  scenarios: {
    normal_load: {
      executor: 'constant-vus',
      vus: 150,
      duration: '10m',
    },
    peak_load: {
      executor: 'constant-vus',
      vus: 1500,
      duration: '30m',
      startTime: '15m', // After normal load
    },
  },
  thresholds: {
    http_req_duration: ['p(95)<1000'], // p95 < 1s
    http_req_failed: ['rate<0.01'],    // error < 1%
  },
};

export default function () {
  // Simulate user behavior
  const res1 = http.get('https://app.example.com/api/products');
  check(res1, { 'products loaded': (r) => r.status === 200 });
  sleep(2);
  
  const res2 = http.get('https://app.example.com/api/orders');
  check(res2, { 'orders loaded': (r) => r.status === 200 });
  sleep(5);
}
```

**Execution**:
```bash
k6 run --out json=load-test-results.json load-test-capacity.js
```

### 5.3 Load Test Schedule

| Test Type | Frequency | Owner | Next Test Date |
|-----------|-----------|-------|----------------|
| Baseline (Scenario 1) | Monthly | DevOps | [Next month 1st] |
| Peak Load (Scenario 2) | Before major releases | DevOps | [Before Dec launch] |
| Stress Test (Scenario 3) | Quarterly | DevOps | [Q2 2027] |
| Soak Test (Scenario 4) | Before production scale-up | DevOps | [Before Phase 2] |

---

## 6. Bottleneck Analysis

### 6.1 Current Bottlenecks

**Identified via profiling and load testing**:

| Bottleneck | Impact | Root Cause | Solution | Priority |
|------------|--------|------------|----------|----------|
| `/api/orders` endpoint slow (p95: 850ms) | High | Missing DB index on `(user_id, status)` | Add compound index | **P0** (Done) |
| Redis memory eviction during peak | Medium | Insufficient cache size (512MB) | Upgrade to 2GB | **P1** |
| Cold start latency (1.2s) | Low | Serverless cold start | Pre-warm functions OR move to containers | **P2** |

### 6.2 Predicted Bottlenecks (at 30K MAU)

| Component | Predicted Issue | Trigger Point | Mitigation Plan |
|-----------|----------------|---------------|-----------------|
| Database connections | Connection pool exhaustion | > 40 concurrent connections | Add read replica + connection pooling (PgBouncer) |
| Redis memory | Cache eviction rate > 10% | > 1GB cached data | Upgrade to 4GB Redis cluster |
| API rate limits | Third-party API throttling (Stripe 100 req/s) | > 6000 orders/hour | Implement request queuing + retry logic |
| File storage bandwidth | Slow image loading | > 1TB/mo bandwidth | Migrate images to CDN (Cloudflare R2) |

---

## 7. Scaling Automation

### 7.1 Auto-Scaling Rules

**Application Servers** (AWS ECS / Kubernetes):
```yaml
# Auto-scaling policy
min_instances: 2
max_instances: 15
target_cpu_utilization: 70%
scale_out_cooldown: 300s  # 5 min
scale_in_cooldown: 600s   # 10 min

# Scale out if:
- avg_cpu > 70% for 2 minutes
- avg_memory > 80% for 2 minutes
- request_queue_depth > 100

# Scale in if:
- avg_cpu < 30% for 10 minutes
- avg_memory < 50% for 10 minutes
```

**Background Workers**:
```yaml
min_workers: 1
max_workers: 10
queue_depth_threshold: 200  # Scale out if queue > 200 jobs
scale_out_increment: 2       # Add 2 workers at a time
scale_in_decrement: 1        # Remove 1 worker at a time
```

### 7.2 Monitoring Dashboards

**Capacity Dashboard** (Grafana / Datadog):
- Current MAU vs projected MAU
- RPS current vs capacity ceiling
- CPU/Memory utilization (color-coded: green < 60%, yellow 60-80%, red > 80%)
- Database connection pool usage
- Redis memory usage + hit rate
- Queue depth over time

**Alert Thresholds**:
- **Warning** (Slack): Resource > 70% for 10 min → "Approaching capacity, review scaling plan"
- **Critical** (PagerDuty): Resource > 90% for 5 min → "Immediate scaling required"

---

## 8. Contingency Plans

### 8.1 Emergency Scaling Procedure

**Trigger**: Traffic spike > 200% of expected load

**Immediate Actions** (15 min response time):
1. Enable Cloudflare "Under Attack Mode" (DDoS protection)
2. Manually scale application instances to max (15 instances)
3. Enable aggressive caching (increase TTL 5× on all endpoints)
4. Throttle non-critical background jobs
5. Notify team in #incidents Slack channel

**Follow-up Actions** (30 min):
1. Analyze traffic source (legitimate vs bot traffic)
2. Add temporary rate limiting rules (50 req/min per IP)
3. Scale database read replicas if needed
4. Monitor error rate + latency

### 8.2 Degradation Strategy

**If infrastructure cannot scale fast enough**:
1. **Shed non-critical load**: Disable analytics tracking, email notifications (queue for later)
2. **Serve stale cache**: Increase CDN TTL to 1 hour (normally 60s)
3. **Read-only mode**: Allow reads, queue writes to background jobs
4. **Show maintenance banner**: "High traffic, some features temporarily limited"

**Restoration Order** (once capacity available):
1. Core user flows (auth, view content)
2. Transactional features (checkout, payments)
3. Social features (comments, likes)
4. Analytics + reporting

---

## 9. Review & Update Schedule

**Quarterly Review**:
- Compare actual growth vs projected growth
- Update growth assumptions based on new data
- Revise scaling thresholds if needed
- Run stress test to validate capacity

**Next Review Date**: [Q2 2024 - April 1]

**Owner**: [DevOps Lead / CTO]

---

## 10. Appendix

### 10.1 Capacity Calculation Formulas

**RPS to Instance Count**:
```
Required Instances = (Peak RPS × Safety Factor) / RPS per Instance

Example:
- Peak RPS: 500
- Safety Factor: 2× (50% headroom)
- RPS per Instance: 50
- Required Instances = (500 × 2) / 50 = 20 instances
```

**Database Connection Pool Size**:
```
Pool Size = (CPU Cores × 2) + Effective Spindle Count

Example (4 vCPU + SSD):
- Pool = (4 × 2) + 1 = 9 connections per instance
- 3 instances = 27 total connections
```

**Redis Memory Sizing**:
```
Required Memory = (Active Users × Avg Session Size) + Query Cache Buffer

Example:
- 10,000 concurrent users
- 50 KB avg session size
- Query cache: 500 MB
- Required = (10,000 × 50 KB) + 500 MB = 500 MB + 500 MB = 1 GB
```

### 10.2 Historical Growth Data

| Month | Actual MAU | Projected MAU | Variance | Notes |
|-------|-----------|---------------|----------|-------|
| Jan 2024 | 5,000 | 5,000 | 0% | Baseline |
| Feb 2024 | [TBD] | 6,000 | — | — |

---

**Document Status**: [Draft / Under Review / Approved]  
**Approval**: [Name, Title, Date]
