# N+1 Query Prevention Patterns

**Purpose**: Eliminate N+1 query anti-patterns across ORMs (Prisma, Laravel, Django)

**Impact**: **10-100x performance improvement** on list/detail views with relationships

**Referenced in**: M06 line 65, M05B multiple references

---

## What is N+1 Problem?

**N+1 queries occur when**:
1. Fetch N parent records (1 query)
2. Loop through each parent
3. Fetch related child for each parent (N queries)

**Total**: 1 + N queries instead of 2 queries

---

## Example: The Problem

### Bad (N+1 Pattern)

```typescript
// Prisma - BAD (N+1)
const users = await prisma.user.findMany(); // 1 query

for (const user of users) {
  const posts = await prisma.post.findMany({
    where: { userId: user.id } // N queries (one per user)
  });
  console.log(`${user.name} has ${posts.length} posts`);
}
```

**Result**: 
- 100 users = 101 queries (1 + 100)
- 1000 users = 1001 queries (1 + 1000)

**Performance**: **Catastrophic** at scale

---

## Solution 1: Eager Loading

### Prisma

```typescript
// Prisma - GOOD (eager loading)
const users = await prisma.user.findMany({
  include: {
    posts: true, // Fetch posts in same query
  },
});

// Only 2 queries:
// 1. SELECT * FROM users
// 2. SELECT * FROM posts WHERE user_id IN (...)
```

**Performance**: **100x faster** for 100 users

---

### Laravel Eloquent

```php
// Laravel - BAD (N+1)
$users = User::all(); // 1 query

foreach ($users as $user) {
    echo $user->posts->count(); // N queries
}

// Laravel - GOOD (eager loading)
$users = User::with('posts')->get(); // 2 queries

foreach ($users as $user) {
    echo $user->posts->count(); // No additional queries
}
```

**Eloquent Debugbar** shows query count reduction

---

### Django ORM

```python
# Django - BAD (N+1)
users = User.objects.all() # 1 query

for user in users:
    posts = user.post_set.all() # N queries
    print(f"{user.name} has {len(posts)} posts")

# Django - GOOD (select_related for ForeignKey)
users = User.objects.select_related('profile').all() # 1 query (JOIN)

# Django - GOOD (prefetch_related for ManyToMany/Reverse FK)
users = User.objects.prefetch_related('post_set').all() # 2 queries
```

**Django Debug Toolbar** shows query count

---

## Solution 2: DataLoader Pattern

### Node.js (for GraphQL or batched APIs)

```typescript
import DataLoader from 'dataloader';

// Batch function
async function batchLoadPosts(userIds: string[]) {
  const posts = await prisma.post.findMany({
    where: { userId: { in: userIds } },
  });
  
  // Group by userId
  const grouped = userIds.map(id =>
    posts.filter(post => post.userId === id)
  );
  
  return grouped;
}

// Create loader
const postLoader = new DataLoader(batchLoadPosts);

// Usage (automatically batches requests within same tick)
const users = await prisma.user.findMany();

const results = await Promise.all(
  users.map(async user => ({
    ...user,
    posts: await postLoader.load(user.id), // Batched automatically
  }))
);
```

**Use when**: GraphQL resolvers, complex nested queries

---

## Solution 3: Raw SQL with JOINs

### When ORM falls short

```typescript
// Complex case: Multiple relationships + aggregates
const result = await prisma.$queryRaw`
  SELECT 
    u.id,
    u.name,
    COUNT(DISTINCT p.id) as post_count,
    COUNT(DISTINCT c.id) as comment_count
  FROM users u
  LEFT JOIN posts p ON p.user_id = u.id
  LEFT JOIN comments c ON c.user_id = u.id
  GROUP BY u.id, u.name
`;
```

**When to use**: ORM generates inefficient queries (check with EXPLAIN)

---

## Detection Tools

### Prisma

```typescript
// Enable query logging
const prisma = new PrismaClient({
  log: ['query', 'info', 'warn', 'error'],
});

// Count queries
let queryCount = 0;
prisma.$on('query', () => {
  queryCount++;
});
```

---

### Laravel

```php
// Enable query log
DB::enableQueryLog();

// Your code here
$users = User::with('posts')->get();

// Check queries
$queries = DB::getQueryLog();
echo "Total queries: " . count($queries);
```

**Or use Laravel Debugbar** (shows N+1 warnings automatically)

---

### Django

```python
# settings.py - Enable query logging
LOGGING = {
    'loggers': {
        'django.db.backends': {
            'level': 'DEBUG',
        },
    },
}

# Or use django-debug-toolbar
# Shows query count + duplicates in toolbar
```

---

## Common Scenarios

### Scenario 1: List with Counts

```typescript
// BAD - N+1
const users = await prisma.user.findMany();
const usersWithCounts = await Promise.all(
  users.map(async user => ({
    ...user,
    postCount: await prisma.post.count({ where: { userId: user.id } }),
  }))
);

// GOOD - Aggregate query
const users = await prisma.user.findMany({
  include: {
    _count: {
      select: { posts: true },
    },
  },
});
```

---

### Scenario 2: Nested Relationships

```typescript
// BAD - N+1 at multiple levels
const users = await prisma.user.findMany();
for (const user of users) {
  const posts = await prisma.post.findMany({ where: { userId: user.id } });
  for (const post of posts) {
    const comments = await prisma.comment.findMany({ where: { postId: post.id } });
  }
}
// Queries: 1 + N + (N * M)

// GOOD - Nested includes
const users = await prisma.user.findMany({
  include: {
    posts: {
      include: {
        comments: true,
      },
    },
  },
});
// Queries: 3 (users, posts, comments)
```

---

### Scenario 3: Polymorphic Relationships

```typescript
// Activity feed: Mix of posts, comments, likes
// BAD - Query each type separately per item

// GOOD - Union query
const activities = await prisma.$queryRaw`
  (SELECT id, 'post' as type, created_at FROM posts WHERE user_id = ${userId})
  UNION ALL
  (SELECT id, 'comment' as type, created_at FROM comments WHERE user_id = ${userId})
  UNION ALL
  (SELECT id, 'like' as type, created_at FROM likes WHERE user_id = ${userId})
  ORDER BY created_at DESC
  LIMIT 20
`;
```

---

## Testing for N+1

### Automated Test

```typescript
// Vitest example
import { describe, it, expect, beforeEach } from 'vitest';

describe('N+1 Prevention', () => {
  let queryCount = 0;

  beforeEach(() => {
    queryCount = 0;
    prisma.$on('query', () => {
      queryCount++;
    });
  });

  it('should not have N+1 on user list', async () => {
    await getUsersWithPosts(); // Your function
    
    // Should be 2 queries (users + posts), not 1 + N
    expect(queryCount).toBeLessThanOrEqual(2);
  });
});
```

---

### Production Monitoring

```typescript
// APM integration (e.g., Sentry, Datadog)
import * as Sentry from '@sentry/node';

prisma.$on('query', (e) => {
  // Track slow queries
  if (e.duration > 100) {
    Sentry.captureMessage(`Slow query: ${e.query}`, {
      extra: { duration: e.duration },
    });
  }
});
```

---

## Performance Comparison

**Scenario**: 100 users, each with 10 posts

| Pattern | Queries | Time (ms) | Speedup |
|---------|---------|-----------|---------|
| **N+1 (Bad)** | 101 | 2500 | 1x |
| **Eager Loading** | 2 | 25 | **100x** |
| **DataLoader** | 2 | 30 | 83x |
| **Raw SQL JOIN** | 1 | 15 | **166x** |

---

## Best Practices

### 1. Always Eager Load in Lists

```typescript
// API endpoint returning list
export async function GET() {
  const documents = await prisma.document.findMany({
    include: {
      user: true,      // Eager load author
      category: true,  // Eager load category
    },
  });
  
  return Response.json({ documents });
}
```

---

### 2. Use Query Builders for Complex Cases

```typescript
// Laravel example with joins
$users = DB::table('users')
    ->select('users.*', DB::raw('COUNT(posts.id) as post_count'))
    ->leftJoin('posts', 'users.id', '=', 'posts.user_id')
    ->groupBy('users.id')
    ->get();
```

---

### 3. Add Indexes for Foreign Keys

```sql
-- Always index foreign keys
CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_comments_post_id ON comments(post_id);
```

---

### 4. Monitor Query Count in Dev

```typescript
// Middleware to log query count
app.use((req, res, next) => {
  const startQueries = queryCount;
  
  res.on('finish', () => {
    const queries = queryCount - startQueries;
    if (queries > 10) {
      console.warn(`⚠️  ${req.path} made ${queries} queries`);
    }
  });
  
  next();
});
```

---

## When NOT to Optimize

**Skip eager loading if**:
- ✅ Related data rarely accessed (lazy load acceptable)
- ✅ Single-record fetch (detail page with one user)
- ✅ Pagination limits results (N is small, e.g., 10)

**Trade-off**: Eager loading fetches ALL related data (memory overhead)

---

## Migration Checklist

**Finding N+1 in existing code**:

1. Enable query logging in dev
2. Browse list pages
3. Count queries (should be ~2-5 per page)
4. If queries > 10, investigate with ORM debug tools
5. Add eager loading for identified N+1s
6. Re-test query count

---

## See Also

- `patterns/performance/caching-strategies.md` - Cache query results
- `patterns/performance/query-optimization.md` - Index optimization
- M06 Development Execution - Performance pillar
- M05B System Design - Database scaling
