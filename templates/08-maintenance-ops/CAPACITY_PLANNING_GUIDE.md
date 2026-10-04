# Capacity Planning Guide

> **Purpose**: Plan infrastructure capacity for Enterprise growth  
> **When**: M05 Architecture + ongoing monitoring  
> **Target**: Enterprise projects expecting significant growth (10x+ users)

---

## What is Capacity Planning?

**Definition**: Forecasting infrastructure needs to handle expected growth without over-provisioning.

**Goals**:
- Avoid outages (insufficient capacity)
- Avoid waste (over-provisioning)
- Maintain performance (response times, throughput)
- Control costs (optimize resource usage)

---

## Key Metrics to Track

### 1. Compute (CPU & Memory)

**Metrics**:
- CPU utilization (%)
- Memory usage (GB)
- Request rate (requests/second)
- Response time (ms)

**Capacity Indicators**:
- ⚠️ Warning: CPU >70% sustained
- 🔴 Critical: CPU >85% sustained
- 🚨 Emergency: CPU >95%

**Action**:
- Warning: Plan to add capacity in 2 weeks
- Critical: Add capacity within 1 week
- Emergency: Add capacity immediately (vertical or horizontal scaling)

---

### 2. Database

**Metrics**:
- Connection pool utilization (%)
- Query latency (ms)
- Disk IOPS (operations/second)
- Storage used (GB)

**Capacity Indicators**:
- ⚠️ Warning: Connections >70%, Storage >80%
- 🔴 Critical: Connections >90%, Storage >90%

**Action**:
- Increase connection pool size
- Add read replicas (distribute load)
- Increase storage (before hitting 100%)
- Optimize slow queries (indexing)

---

### 3. Network

**Metrics**:
- Bandwidth usage (Mbps)
- Requests per second
- CDN hit rate (%)

**Capacity Indicators**:
- ⚠️ Warning: Bandwidth >70% of limit
- 🔴 Critical: Bandwidth >90% of limit

**Action**:
- Increase bandwidth allocation
- Enable CDN (offload static content)
- Optimize asset sizes (compression, minification)

---

### 4. Storage

**Metrics**:
- Disk usage (GB)
- Growth rate (GB/month)
- File upload rate (files/day)

**Capacity Indicators**:
- ⚠️ Warning: Storage >80% full
- 🔴 Critical: Storage >90% full

**Action**:
- Increase disk size
- Implement lifecycle policies (delete old files)
- Archive cold data (S3 Glacier)

---

## Capacity Planning Process

### Step 1: Baseline Current Usage (Week 1)

**Collect Metrics**:
- CPU: Average 45%, peak 70%
- Memory: Average 8GB, peak 12GB
- Database connections: Average 50, peak 80
- Requests: 1,000 req/sec average, 2,000 peak
- Storage: 500GB used, growing 50GB/month

**Tools**: Datadog, CloudWatch, New Relic

---

### Step 2: Forecast Growth (Week 2)

**Business Forecast**:
- Current users: 10,000
- Expected users (6 months): 50,000 (5x growth)
- Expected users (12 months): 100,000 (10x growth)

**Technical Forecast**:
```
Assumption: Linear scaling (5x users = 5x infrastructure)

6 months (5x growth):
- CPU: 45% × 5 = 225% → Need 3x current capacity
- Memory: 8GB × 5 = 40GB
- Database: 50 conn × 5 = 250 connections
- Requests: 1,000 req/sec × 5 = 5,000 req/sec
- Storage: 500GB + (50GB/month × 6) = 800GB

12 months (10x growth):
- CPU: 45% × 10 = 450% → Need 5x current capacity
- Memory: 8GB × 10 = 80GB
- Database: 50 conn × 10 = 500 connections
- Requests: 1,000 req/sec × 10 = 10,000 req/sec
- Storage: 500GB + (50GB/month × 12) = 1,100GB
```

**Note**: Real scaling may not be linear (caching, optimization can reduce needs)

---

### Step 3: Plan Capacity Additions (Week 3)

**Current Infrastructure**:
- 5 EC2 instances (t3.large, 2 vCPU, 8GB RAM each)
- 1 RDS instance (db.t3.large, 2 vCPU, 8GB RAM, 500GB storage)
- 1 ALB (Application Load Balancer)

**6-Month Plan (5x users)**:
- Add 10 EC2 instances (total 15 instances)
- Upgrade RDS to db.r5.xlarge (4 vCPU, 32GB RAM)
- Add 1 read replica (distribute read load)
- Increase RDS storage to 1TB

**12-Month Plan (10x users)**:
- Add 20 EC2 instances (total 25 instances)
- Upgrade RDS to db.r5.2xlarge (8 vCPU, 64GB RAM)
- Add 2 more read replicas (total 3)
- Increase RDS storage to 2TB

**Cost**:
- Current: $5,000/month
- 6 months: $15,000/month (3x)
- 12 months: $30,000/month (6x)

---

### Step 4: Implement in Phases (Ongoing)

**Phase 1 (Month 1-2)**: Add 5 instances (10 total)
- Trigger: When CPU hits 60% sustained

**Phase 2 (Month 3-4)**: Add 5 more instances (15 total)
- Trigger: When CPU hits 60% again

**Phase 3 (Month 5-6)**: Upgrade database
- Trigger: When connections hit 70%

**Auto-Scaling** (Recommended):
```yaml
# AWS Auto Scaling policy
TargetTrackingScaling:
  TargetValue: 60  # Keep CPU at 60%
  ScaleOutCooldown: 300  # Wait 5 min before adding more
  ScaleInCooldown: 600   # Wait 10 min before removing
```

---

## Capacity Planning Worksheet

### Current Capacity (Baseline)

**Date**: 2024-10-04

| Resource | Current Usage | Peak Usage | Limit | Utilization |
|:---------|:-------------|:-----------|:------|:------------|
| **CPU** | 45% (avg) | 70% (peak) | 100% | 70% |
| **Memory** | 8GB (avg) | 12GB (peak) | 16GB | 75% |
| **Database Connections** | 50 (avg) | 80 (peak) | 100 | 80% |
| **Requests/sec** | 1,000 (avg) | 2,000 (peak) | 5,000 | 40% |
| **Storage** | 500GB | N/A | 1TB | 50% |

---

### Growth Forecast

| Timeframe | Users | Multiplier | Action |
|:----------|:------|:-----------|:-------|
| **Current** | 10,000 | 1x | Baseline |
| **3 months** | 25,000 | 2.5x | Add 5 instances |
| **6 months** | 50,000 | 5x | Add 10 instances, upgrade DB |
| **12 months** | 100,000 | 10x | Add 20 instances, 3 read replicas |

---

### Capacity Thresholds

| Metric | Warning (Plan) | Critical (Act Now) | Emergency (Incident) |
|:-------|:--------------|:-------------------|:---------------------|
| **CPU** | 70% | 85% | 95% |
| **Memory** | 75% | 90% | 95% |
| **Database Connections** | 70% | 90% | 100% |
| **Storage** | 80% | 90% | 95% |
| **Network Bandwidth** | 70% | 85% | 95% |

---

## Load Testing

**Purpose**: Validate capacity before hitting limits

**Tools**:
- k6 (open source)
- JMeter
- Gatling
- Locust

**Test Scenarios**:
1. **Current Load (Baseline)**: 1,000 req/sec for 10 minutes
2. **Peak Load**: 2,000 req/sec for 5 minutes
3. **Future Load (6 months)**: 5,000 req/sec for 5 minutes
4. **Spike Test**: 10,000 req/sec for 1 minute

**Example (k6)**:
```javascript
import http from 'k6/http';

export let options = {
  stages: [
    { duration: '2m', target: 1000 },   // Baseline
    { duration: '5m', target: 5000 },   // Future (6 months)
    { duration: '1m', target: 10000 },  // Spike
    { duration: '2m', target: 0 },      // Ramp down
  ],
};

export default function () {
  http.get('https://api.yourapp.com/users');
}
```

**Results**:
- ✅ Pass: Response time <200ms, error rate <1%
- ⚠️ Warning: Response time 200-500ms, error rate 1-5%
- ❌ Fail: Response time >500ms, error rate >5%

**Action**: If fail, add capacity before launching

---

## Cost Optimization

**Right-Sizing**: Use smallest instance that meets performance needs

**Example**:
```
Current: t3.large ($0.0832/hr)
Actual CPU usage: 20% (under-utilized)

Recommendation: Downgrade to t3.medium ($0.0416/hr)
Savings: 50% ($300/month per instance)
```

**Reserved Instances**: Commit to 1-3 years for 30-60% discount

**Spot Instances**: Use for non-critical workloads (70-90% discount, but can be terminated)

**Auto-Scaling**: Scale down during low traffic (nights, weekends)

---

## Monitoring & Alerts

**Dashboard**: Real-time capacity metrics

**Alerts**:
```
Warning: CPU >70% for 15 minutes
  → Slack notification
  → Plan capacity addition

Critical: CPU >85% for 5 minutes
  → PagerDuty alert
  → Add capacity within 1 hour

Emergency: CPU >95% for 1 minute
  → PagerDuty alert (on-call)
  → Add capacity immediately (auto-scale)
```

**Weekly Review**:
- Review capacity trends
- Forecast when to add capacity
- Optimize under-utilized resources

---

## Capacity Planning Checklist

**Initial Planning**:
- [ ] Collect baseline metrics (1-2 weeks)
- [ ] Forecast user growth (business projections)
- [ ] Calculate infrastructure needs (linear or custom model)
- [ ] Estimate costs (current vs future)

**Ongoing Monitoring**:
- [ ] Monitor key metrics (CPU, memory, database, storage)
- [ ] Set up alerts (warning, critical, emergency thresholds)
- [ ] Weekly capacity review
- [ ] Load test before major launches

**Capacity Additions**:
- [ ] Add capacity proactively (before hitting limits)
- [ ] Test new capacity (load test)
- [ ] Monitor for issues (performance regression)
- [ ] Document changes (capacity log)

**Cost Optimization**:
- [ ] Right-size instances (monthly review)
- [ ] Use reserved instances (1-year commit)
- [ ] Implement auto-scaling
- [ ] Archive cold data (S3 Glacier)

---

## Notes

**Plan ahead**: Adding capacity takes time (procurement, testing)

**Over-provision slightly**: Better to have 20% buffer than run out

**Monitor trends**: Sudden spikes may indicate attack or viral growth

**Load test regularly**: Quarterly tests validate capacity plans
