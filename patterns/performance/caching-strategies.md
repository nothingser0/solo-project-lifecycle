# Caching Strategies

**Purpose**: Multi-layer caching patterns for 10-100x performance gains

**Impact**: Reduce database load 90%, improve response time 50-200ms → 5-20ms

**Referenced in**: M05B System Design, M06 Performance Pillar

---

## Caching Layers

```
┌─────────────────────────────────────────┐
│ Browser Cache (304 Not Modified)       │ ← 0ms
├─────────────────────────────────────────┤
│ CDN Edge Cache (CloudFlare, Vercel)    │ ← 10-50ms
├─────────────────────────────────────────┤
│ Application Memory Cache (LRU)         │ ← 1-5ms
├─────────────────────────────────────────┤
│ Redis Cache (Centralized)              │ ← 5-20ms
├─────────────────────────────────────────┤
│ Database Query Cache                    │ ← 50-200ms
├─────────────────────────────────────────┤
│ Database (Uncached)                     │ ← 100-500ms
└─────────────────────────────────────────┘
```

---

## Strategy 1: Redis Caching

### Setup

```bash
# Install Redis
pnpm add ioredis

# Docker Compose
version: '3.8'
services:
  redis:
    image: redis:7-alpine
    ports:
      - '6379:6379'
    volumes:
      - redis-data:/data

volumes:
  redis-data:
```

### Basic Usage

```typescript
// lib/redis.ts
import Redis from 'ioredis';

export const redis = new Redis({
  host: process.env.REDIS_HOST || 'localhost',
  port: parseInt(process.env.REDIS_PORT || '6379'),
  password: process.env.REDIS_PASSWORD,
  retryStrategy: (times) => Math.min(times * 50, 2000),
});

// Cache helper
export async function cached<T>(
  key: string,
  ttl: number,
  fetcher: () => Promise<T>
): Promise<T> {
  // Try cache first
  const cached = await redis.get(key);
  if (cached) {
    return JSON.parse(cached);
  }

  // Cache miss - fetch and store
  const data = await fetcher();
  await redis.setex(key, ttl, JSON.stringify(data));
  return data;
}
```

---

### API Route Example

```typescript
// app/api/documents/route.ts
import { redis, cached } from '@/lib/redis';
import { db } from '@/lib/db';

export async function GET(req: Request) {
  const userId = getUserId(req);
  
  const documents = await cached(
    `documents:user:${userId}`,
    300, // 5 minutes TTL
    async () => {
      return db.document.findMany({
        where: { userId },
        include: { category: true },
      });
    }
  );

  return Response.json({ documents });
}
```

---

### Cache Invalidation

```typescript
// app/api/documents/route.ts
export async function POST(req: Request) {
  const userId = getUserId(req);
  const body = await req.json();

  const document = await db.document.create({
    data: { ...body, userId },
  });

  // Invalidate cache after mutation
  await redis.del(`documents:user:${userId}`);

  return Response.json({ document }, { status: 201 });
}
```

---

## Strategy 2: Stale-While-Revalidate

**Pattern**: Serve stale data immediately, refresh in background

```typescript
export async function cachedSWR<T>(
  key: string,
  ttl: number,
  staleTime: number,
  fetcher: () => Promise<T>
): Promise<T> {
  const cached = await redis.get(key);
  const timestamp = await redis.get(`${key}:ts`);

  if (cached) {
    const age = Date.now() - parseInt(timestamp || '0');

    // Fresh data - return immediately
    if (age < ttl * 1000) {
      return JSON.parse(cached);
    }

    // Stale data - return but trigger refresh in background
    if (age < staleTime * 1000) {
      // Non-blocking refresh
      fetcher().then(data => {
        redis.setex(key, staleTime, JSON.stringify(data));
        redis.set(`${key}:ts`, Date.now().toString());
      });

      return JSON.parse(cached);
    }
  }

  // No cache or too stale - fetch synchronously
  const data = await fetcher();
  await redis.setex(key, staleTime, JSON.stringify(data));
  await redis.set(`${key}:ts`, Date.now().toString());
  return data;
}
```

**Use case**: Dashboard metrics, analytics (stale by 5 minutes acceptable)

---

## Strategy 3: Cache Tags (Smart Invalidation)

```typescript
// lib/cache-tags.ts
export async function setCached<T>(
  key: string,
  data: T,
  ttl: number,
  tags: string[]
): Promise<void> {
  await redis.setex(key, ttl, JSON.stringify(data));

  // Track cache key in tag sets
  for (const tag of tags) {
    await redis.sadd(`tag:${tag}`, key);
  }
}

export async function invalidateTag(tag: string): Promise<void> {
  // Get all keys with this tag
  const keys = await redis.smembers(`tag:${tag}`);

  if (keys.length > 0) {
    await redis.del(...keys);
  }

  await redis.del(`tag:${tag}`);
}
```

**Usage**:

```typescript
// Cache with tags
await setCached(
  'document:123',
  document,
  3600,
  ['documents', 'user:456', 'category:789']
);

// Invalidate all documents for user
await invalidateTag('user:456');

// Invalidate all documents in category
await invalidateTag('category:789');
```

---

## Strategy 4: CDN Caching (Static Assets)

### Next.js Static Generation

```typescript
// app/blog/[slug]/page.tsx
export async function generateStaticParams() {
  const posts = await db.post.findMany();
  return posts.map(post => ({ slug: post.slug }));
}

export default async function BlogPost({ params }) {
  const post = await db.post.findUnique({
    where: { slug: params.slug },
  });

  return <article>{post.content}</article>;
}
```

**Result**: Cached at CDN edge, 0 database queries on repeat visits

---

### Incremental Static Regeneration (ISR)

```typescript
// app/blog/[slug]/page.tsx
export const revalidate = 3600; // Revalidate every hour

export default async function BlogPost({ params }) {
  const post = await db.post.findUnique({
    where: { slug: params.slug },
  });

  return <article>{post.content}</article>;
}
```

**Result**: Serve cached version, rebuild in background every hour

---

### HTTP Cache Headers

```typescript
// app/api/public/stats/route.ts
export async function GET() {
  const stats = await getPublicStats();

  return Response.json(stats, {
    headers: {
      'Cache-Control': 'public, max-age=300, s-maxage=600, stale-while-revalidate=86400',
    },
  });
}
```

**Headers explained**:
- `public`: Can be cached by CDN
- `max-age=300`: Browser caches 5 minutes
- `s-maxage=600`: CDN caches 10 minutes
- `stale-while-revalidate=86400`: Serve stale for 24 hours while revalidating

---

## Strategy 5: Application Memory Cache

**Use case**: Hot data accessed multiple times per request (config, user session)

```typescript
// lib/memory-cache.ts
import { LRUCache } from 'lru-cache';

const cache = new LRUCache<string, any>({
  max: 500, // Max 500 entries
  ttl: 1000 * 60 * 5, // 5 minutes
});

export function memoryCached<T>(
  key: string,
  fetcher: () => T
): T {
  const cached = cache.get(key);
  if (cached !== undefined) {
    return cached;
  }

  const data = fetcher();
  cache.set(key, data);
  return data;
}
```

**Example**:

```typescript
// Expensive config parsing (only once per process)
const config = memoryCached('app-config', () => {
  return parseComplexConfig();
});
```

---

## Strategy 6: Database Query Cache

### Prisma Query Cache

```typescript
// lib/query-cache.ts
import { PrismaClient } from '@prisma/client';
import { redis } from './redis';

const prisma = new PrismaClient();

// Wrap Prisma with cache layer
export const db = new Proxy(prisma, {
  get(target, prop) {
    const original = target[prop];

    if (typeof original === 'object' && original !== null) {
      return new Proxy(original, {
        get(innerTarget, innerProp) {
          const method = innerTarget[innerProp];

          if (innerProp === 'findMany' || innerProp === 'findUnique') {
            return async (...args: any[]) => {
              const cacheKey = `prisma:${String(prop)}:${innerProp}:${JSON.stringify(args)}`;
              const cached = await redis.get(cacheKey);

              if (cached) {
                return JSON.parse(cached);
              }

              const result = await method.apply(innerTarget, args);
              await redis.setex(cacheKey, 300, JSON.stringify(result));
              return result;
            };
          }

          return method;
        },
      });
    }

    return original;
  },
});
```

**Warning**: Only cache immutable queries (no user-specific data)

---

## Cache Invalidation Patterns

### Pattern 1: Time-Based (TTL)

```typescript
// Simplest - expire after fixed time
await redis.setex('key', 300, data); // 5 minutes
```

**Pros**: Simple, predictable  
**Cons**: May serve stale data until TTL expires

---

### Pattern 2: Event-Based

```typescript
// Invalidate on mutations
export async function createDocument(data) {
  const document = await db.document.create({ data });

  // Invalidate related caches
  await redis.del(`documents:user:${data.userId}`);
  await redis.del(`documents:category:${data.categoryId}`);
  await redis.del('documents:recent');

  return document;
}
```

**Pros**: Always fresh data  
**Cons**: Must track all dependent cache keys

---

### Pattern 3: Version-Based

```typescript
// Increment version on mutation
await redis.incr('documents:version');

// Check version before using cache
const version = await redis.get('documents:version');
const cacheKey = `documents:list:v${version}`;
const cached = await redis.get(cacheKey);
```

**Pros**: Simpler invalidation logic  
**Cons**: All caches expire together

---

## Cache Warming Strategies

### Pre-populate on Deploy

```typescript
// scripts/warm-cache.ts
async function warmCache() {
  console.log('Warming cache...');

  // Warm common queries
  await cached('documents:recent', 3600, () =>
    db.document.findMany({ take: 20, orderBy: { createdAt: 'desc' } })
  );

  await cached('categories:all', 86400, () =>
    db.category.findMany()
  );

  console.log('Cache warmed');
}

warmCache();
```

**Run on deployment**:

```bash
npm run build && npm run warm-cache && npm start
```

---

### Background Jobs

```typescript
// cron job: every hour
cron.schedule('0 * * * *', async () => {
  // Refresh popular content
  const popularDocuments = await db.document.findMany({
    where: { views: { gt: 1000 } },
  });

  for (const doc of popularDocuments) {
    await redis.setex(
      `document:${doc.id}`,
      3600,
      JSON.stringify(doc)
    );
  }
});
```

---

## Monitoring Cache Effectiveness

### Hit Rate Calculation

```typescript
let hits = 0;
let misses = 0;

export async function cachedWithMetrics<T>(
  key: string,
  ttl: number,
  fetcher: () => Promise<T>
): Promise<T> {
  const cached = await redis.get(key);

  if (cached) {
    hits++;
    console.log(`Cache hit rate: ${(hits / (hits + misses) * 100).toFixed(1)}%`);
    return JSON.parse(cached);
  }

  misses++;
  const data = await fetcher();
  await redis.setex(key, ttl, JSON.stringify(data));
  return data;
}
```

**Target**: >80% hit rate for frequently accessed data

---

### Redis Monitoring

```bash
# Connect to Redis CLI
redis-cli

# Check memory usage
INFO memory

# Check hit rate
INFO stats
# Look for: keyspace_hits, keyspace_misses

# List all keys (dev only, slow in production)
KEYS *

# Check TTL of key
TTL documents:user:123
```

---

## Common Pitfalls

### ❌ Caching User-Specific Data Globally

```typescript
// BAD - Everyone gets same data
await redis.setex('documents', 300, allDocuments);

// GOOD - Cache per user
await redis.setex(`documents:user:${userId}`, 300, userDocuments);
```

---

### ❌ Cache Stampede

```typescript
// BAD - Multiple requests fetch simultaneously on cache miss
const data = await redis.get(key);
if (!data) {
  return await fetchFromDB(); // 100 requests hit DB at same time
}

// GOOD - Use lock to prevent stampede
import Redlock from 'redlock';
const redlock = new Redlock([redis]);

const lock = await redlock.acquire([`lock:${key}`], 5000);
try {
  const cached = await redis.get(key);
  if (cached) return JSON.parse(cached);

  const data = await fetchFromDB();
  await redis.setex(key, 300, JSON.stringify(data));
  return data;
} finally {
  await lock.release();
}
```

---

### ❌ Infinite Cache Growth

```typescript
// BAD - No TTL, cache grows forever
await redis.set('key', data);

// GOOD - Always set TTL
await redis.setex('key', 3600, data);
```

---

## Performance Comparison

**Scenario**: Fetch 100 documents with categories (N+1 prevented)

| Strategy | Latency | Load (DB) | Cost |
|----------|---------|-----------|------|
| **No cache** | 200ms | 2 queries/req | High |
| **Redis cache** | 20ms | 0 queries (hit) | Medium |
| **Memory cache** | 5ms | 0 queries (hit) | Low |
| **CDN cache** | 10-50ms | 0 (origin) | Very Low |

**Hit rate 90%** = 90% requests avoid database entirely

---

## Best Practices Checklist

- [ ] **Cache immutable data aggressively** (categories, settings)
- [ ] **Cache user data with user-specific keys** (`user:${id}:documents`)
- [ ] **Set TTL on all cache entries** (prevent memory leaks)
- [ ] **Invalidate on mutations** (create, update, delete)
- [ ] **Monitor hit rate** (target >80%)
- [ ] **Use tags for complex invalidation** (invalidate by user, category, etc.)
- [ ] **Implement stale-while-revalidate** for tolerance to stale data
- [ ] **Warm cache on deploy** (avoid cold start)
- [ ] **Use CDN for static assets** (images, CSS, JS)
- [ ] **Test cache invalidation** (ensure fresh data after mutations)

---

## See Also

- `patterns/performance/n-plus-one-prevention.md` - Optimize queries first
- `patterns/performance/query-optimization.md` - Index tuning
- M05B System Design Infrastructure - Redis setup
- M06 Development Execution - Performance pillar
