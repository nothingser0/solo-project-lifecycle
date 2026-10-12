# CI/CD Pipeline & Deployment Strategies

Production-ready CI/CD patterns for automated testing, building, and deployment. Covers GitHub Actions, deployment gates, and zero-downtime strategies.

## Pipeline Architecture

```
┌─────────┐   ┌──────┐   ┌────────┐   ┌────────┐   ┌─────────┐
│  Commit │──▶│ Lint │──▶│  Test  │──▶│  Build │──▶│ Deploy  │
└─────────┘   └──────┘   └────────┘   └────────┘   └─────────┘
                  │           │            │             │
                 FAIL        FAIL         FAIL          FAIL
                  │           │            │             │
                  └───────────┴────────────┴─────────────┘
                              STOP PIPELINE
```

---

## GitHub Actions (Recommended)

### Basic CI Pipeline
```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run ESLint
        run: npm run lint
      
      - name: Check TypeScript
        run: npm run type-check

  test:
    runs-on: ubuntu-latest
    needs: lint  # Wait for lint to pass
    
    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: test
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432

    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run migrations
        run: npx prisma migrate deploy
        env:
          DATABASE_URL: postgresql://postgres:postgres@localhost:5432/test
      
      - name: Run unit tests
        run: npm run test:unit
      
      - name: Run integration tests
        run: npm run test:integration
        env:
          DATABASE_URL: postgresql://postgres:postgres@localhost:5432/test
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/coverage-final.json

  build:
    runs-on: ubuntu-latest
    needs: test
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Build
        run: npm run build
      
      - name: Upload build artifacts
        uses: actions/upload-artifact@v3
        with:
          name: build
          path: dist/
```

---

## Deployment Strategies

### 1. **Blue-Green Deployment** (Zero Downtime)

```
┌──────────┐         ┌──────────┐
│  Blue    │ ◀───────│  Router  │
│ (Active) │         └──────────┘
└──────────┘
                          │
┌──────────┐              │
│  Green   │ ◀────────────┘  (Switch traffic after validation)
│  (New)   │
└──────────┘
```

**GitHub Actions Workflow**:
```yaml
# .github/workflows/deploy-blue-green.yml
name: Deploy (Blue-Green)

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy to Green environment
        run: |
          # Deploy to inactive environment
          kubectl apply -f k8s/deployment-green.yml
          kubectl rollout status deployment/app-green
      
      - name: Run smoke tests
        run: |
          curl -f http://green.internal/health || exit 1
          npm run test:smoke -- --base-url=http://green.internal
      
      - name: Switch traffic to Green
        run: |
          kubectl patch service app -p '{"spec":{"selector":{"version":"green"}}}'
      
      - name: Wait for traffic drain
        run: sleep 30
      
      - name: Delete Blue environment
        run: kubectl delete deployment app-blue
```

**Pros**: Instant rollback (switch back to blue)  
**Cons**: 2x infrastructure cost during deployment

---

### 2. **Rolling Deployment** (Gradual Rollout)

```yaml
# k8s/deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
spec:
  replicas: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1        # Max 1 extra pod during update
      maxUnavailable: 1  # Max 1 pod down during update
  template:
    spec:
      containers:
      - name: app
        image: myapp:latest
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 3000
          initialDelaySeconds: 5
```

**How it works**:
1. Deploy 1 new pod (6 total: 5 old + 1 new)
2. Wait for health check ✅
3. Delete 1 old pod (5 total: 4 old + 1 new)
4. Repeat until all pods replaced

**Pros**: No extra infrastructure cost  
**Cons**: Slower rollout, mixed versions during deploy

---

### 3. **Canary Deployment** (Risk Mitigation)

```yaml
# .github/workflows/deploy-canary.yml
name: Deploy (Canary)

on:
  push:
    branches: [main]

jobs:
  canary:
    runs-on: ubuntu-latest
    
    steps:
      - name: Deploy to 5% of traffic
        run: |
          # Deploy canary with 5% traffic split
          kubectl apply -f k8s/deployment-canary.yml
          kubectl apply -f k8s/service-canary.yml  # 5% weight
      
      - name: Monitor error rate for 10 minutes
        run: |
          # Check Datadog/New Relic for error spike
          ./scripts/monitor-canary.sh --duration=10m --threshold=1%
      
      - name: Promote to 100% if healthy
        if: success()
        run: |
          kubectl apply -f k8s/deployment-stable.yml
          kubectl delete deployment app-canary
      
      - name: Rollback if unhealthy
        if: failure()
        run: |
          kubectl delete deployment app-canary
          exit 1
```

**Traffic Split** (Nginx Ingress):
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app
  annotations:
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "5"  # 5% to canary
spec:
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        backend:
          service:
            name: app-canary
            port:
              number: 80
```

**Pros**: Minimize blast radius (only 5% affected by bugs)  
**Cons**: Complex monitoring required

---

## Deployment Gates

### Manual Approval Gate
```yaml
# .github/workflows/deploy-production.yml
name: Deploy to Production

on:
  workflow_dispatch:  # Manual trigger only

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production  # Requires approval in GitHub settings
    
    steps:
      - name: Deploy to production
        run: ./scripts/deploy.sh production
```

**GitHub Settings**:
- Go to Settings → Environments → production
- Add required reviewers (2+ approvals)
- Add branch protection (only main can deploy)

---

### Automated Quality Gates
```yaml
# .github/workflows/quality-gate.yml
name: Quality Gate

on: [pull_request]

jobs:
  quality:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Run tests
        run: npm test
      
      - name: Check coverage
        run: |
          COVERAGE=$(npm run test:coverage -- --reporter=json-summary | jq '.total.lines.pct')
          if (( $(echo "$COVERAGE < 80" | bc -l) )); then
            echo "Coverage $COVERAGE% is below 80%"
            exit 1
          fi
      
      - name: Check bundle size
        run: |
          npm run build
          SIZE=$(du -sb dist/ | cut -f1)
          MAX_SIZE=$((5 * 1024 * 1024))  # 5MB
          if [ $SIZE -gt $MAX_SIZE ]; then
            echo "Bundle size $SIZE exceeds $MAX_SIZE"
            exit 1
          fi
      
      - name: Security audit
        run: npm audit --audit-level=moderate
```

---

## Environment Management

### Multi-Environment Setup
```
Development → Staging → Production
    ↓            ↓           ↓
  Auto        Manual      Manual + Approval
```

**Workflow**:
```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches:
      - develop    # Auto-deploy to dev
      - staging    # Auto-deploy to staging
      - main       # Manual approval for production

jobs:
  deploy-dev:
    if: github.ref == 'refs/heads/develop'
    runs-on: ubuntu-latest
    environment: development
    steps:
      - name: Deploy to dev
        run: ./scripts/deploy.sh dev

  deploy-staging:
    if: github.ref == 'refs/heads/staging'
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - name: Deploy to staging
        run: ./scripts/deploy.sh staging

  deploy-production:
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: production  # Requires approval
    steps:
      - name: Deploy to production
        run: ./scripts/deploy.sh production
```

---

## Database Migrations

### Safe Migration Strategy
```yaml
# .github/workflows/migrate.yml
name: Database Migration

jobs:
  migrate:
    runs-on: ubuntu-latest
    
    steps:
      - name: Backup database
        run: |
          pg_dump $DATABASE_URL > backup-$(date +%s).sql
          aws s3 cp backup-*.sql s3://backups/
      
      - name: Run migrations
        run: npx prisma migrate deploy
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}
      
      - name: Verify migration
        run: |
          # Check critical tables exist
          psql $DATABASE_URL -c "SELECT 1 FROM users LIMIT 1"
          psql $DATABASE_URL -c "SELECT 1 FROM orders LIMIT 1"
      
      - name: Rollback on failure
        if: failure()
        run: |
          # Restore from backup
          LATEST_BACKUP=$(aws s3 ls s3://backups/ | tail -n1 | awk '{print $4}')
          aws s3 cp s3://backups/$LATEST_BACKUP backup.sql
          psql $DATABASE_URL < backup.sql
```

---

## Secrets Management

### GitHub Secrets
```yaml
# Store secrets in GitHub Settings → Secrets
env:
  DATABASE_URL: ${{ secrets.DATABASE_URL }}
  JWT_SECRET: ${{ secrets.JWT_SECRET }}
  STRIPE_KEY: ${{ secrets.STRIPE_KEY }}
```

### Vault (Production)
```yaml
steps:
  - name: Fetch secrets from Vault
    uses: hashicorp/vault-action@v2
    with:
      url: https://vault.example.com
      token: ${{ secrets.VAULT_TOKEN }}
      secrets: |
        secret/data/production DATABASE_URL | DATABASE_URL
        secret/data/production JWT_SECRET | JWT_SECRET
  
  - name: Deploy with secrets
    run: ./deploy.sh
    env:
      DATABASE_URL: ${{ env.DATABASE_URL }}
      JWT_SECRET: ${{ env.JWT_SECRET }}
```

---

## Monitoring & Rollback

### Health Checks
```typescript
// src/routes/health.ts
app.get('/health', async (req, res) => {
  try {
    // Check database
    await db.$queryRaw`SELECT 1`;
    
    // Check Redis
    await redis.ping();
    
    // Check external APIs
    await fetch('https://api.stripe.com/v1/charges', {
      headers: { Authorization: `Bearer ${process.env.STRIPE_KEY}` }
    });
    
    res.json({ status: 'healthy', timestamp: new Date() });
  } catch (err) {
    res.status(503).json({ status: 'unhealthy', error: err.message });
  }
});
```

### Automated Rollback
```yaml
# .github/workflows/rollback.yml
name: Auto Rollback

on:
  workflow_dispatch:
    inputs:
      version:
        description: 'Version to rollback to'
        required: true

jobs:
  rollback:
    runs-on: ubuntu-latest
    
    steps:
      - name: Rollback deployment
        run: |
          kubectl rollout undo deployment/app --to-revision=${{ github.event.inputs.version }}
      
      - name: Verify rollback
        run: |
          kubectl rollout status deployment/app
          curl -f https://app.example.com/health
      
      - name: Notify team
        uses: slackapi/slack-github-action@v1
        with:
          payload: |
            {
              "text": "⚠️ Rolled back to version ${{ github.event.inputs.version }}"
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}
```

---

## Docker Build Optimization

### Multi-Stage Build
```dockerfile
# Dockerfile
# Stage 1: Build
FROM node:22-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

# Stage 2: Production
FROM node:22-alpine

WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY package.json ./

USER node
EXPOSE 3000

CMD ["node", "dist/index.js"]
```

### Layer Caching
```yaml
# .github/workflows/docker.yml
- name: Build and push Docker image
  uses: docker/build-push-action@v5
  with:
    context: .
    push: true
    tags: myapp:${{ github.sha }}
    cache-from: type=registry,ref=myapp:latest
    cache-to: type=inline
```

---

## Performance Monitoring

### Datadog Integration
```yaml
# .github/workflows/deploy.yml
- name: Report deployment to Datadog
  run: |
    curl -X POST "https://api.datadoghq.com/api/v1/events" \
      -H "DD-API-KEY: ${{ secrets.DATADOG_API_KEY }}" \
      -d '{
        "title": "Deployment",
        "text": "Deployed version ${{ github.sha }} to production",
        "tags": ["env:production", "version:${{ github.sha }}"]
      }'
```

### Error Rate Monitoring
```bash
# Example project script: scripts/monitor-canary.sh (create in user project)
#!/bin/bash

DURATION=$1
THRESHOLD=$2

START=$(date +%s)
END=$((START + DURATION))

while [ $(date +%s) -lt $END ]; do
  ERROR_RATE=$(curl -s "https://api.datadog.com/api/v1/query?query=sum:app.errors{env:canary}" | jq '.series[0].pointlist[-1][1]')
  
  if (( $(echo "$ERROR_RATE > $THRESHOLD" | bc -l) )); then
    echo "Error rate $ERROR_RATE exceeds threshold $THRESHOLD"
    exit 1
  fi
  
  sleep 60
done

echo "Canary healthy for $DURATION"
```

---

## Best Practices

### ✅ Do
1. **Run tests before deploy** (unit, integration, E2E)
2. **Use health checks** for readiness/liveness probes
3. **Automate dev/staging** deploys (manual production)
4. **Store secrets securely** (GitHub Secrets, Vault)
5. **Monitor deployments** (error rates, latency)
6. **Plan rollback strategy** (keep 3 previous versions)
7. **Use Docker multi-stage builds** (smaller images)

### ❌ Don't
1. **Deploy on Friday** (no weekend firefighting)
2. **Skip migrations testing** (backup before migrate)
3. **Ignore failed health checks** (auto-rollback)
4. **Commit secrets** (.env files in .gitignore)
5. **Deploy breaking changes** without versioning
6. **Skip staging** (always test before production)
7. **Ignore deployment metrics** (error spike = rollback)

---

## Quick Reference

| Strategy | Downtime | Cost | Rollback Speed | Complexity |
|----------|----------|------|----------------|------------|
| Blue-Green | Zero | 2x | Instant | Medium |
| Rolling | Zero | 1x | Slow | Low |
| Canary | Zero | 1.1x | Fast | High |
| Recreate | ~30s | 1x | Manual | Low |

**Recommendation**:
- **Small Scale**: Rolling (GitHub Actions + Vercel/Render)
- **Medium Scale**: Blue-Green (Kubernetes + LoadBalancer)
- **Large Scale**: Canary (Kubernetes + Service Mesh)
