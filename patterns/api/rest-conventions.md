# REST API Design Conventions

Proven patterns for building maintainable REST APIs. Based on industry standards (JSON:API, Google API Design Guide, Microsoft REST API Guidelines).

## HTTP Method Semantics

### Safe Methods (Idempotent + No Side Effects)
```
GET /api/users           - List all users
GET /api/users/123       - Get specific user
HEAD /api/users/123      - Check if user exists (headers only)
OPTIONS /api/users       - Get allowed methods
```

### Idempotent Methods (Safe to Retry)
```
PUT /api/users/123       - Replace entire user (creates if not exists)
DELETE /api/users/123    - Delete user (returns 200 if exists, 404 if not)
```

### Non-Idempotent Methods (Side Effects)
```
POST /api/users          - Create new user (returns 201 + Location header)
PATCH /api/users/123     - Partial update (may be idempotent or non-idempotent depending on operation payload)
```

## HTTP Status Codes

### Success (2xx)
```typescript
200 OK                  // GET, PUT, PATCH, DELETE succeeded
201 Created            // POST succeeded (include Location header)
202 Accepted           // Async operation queued
204 No Content         // DELETE succeeded, no response body
```

### Client Errors (4xx)
```typescript
400 Bad Request        // Validation failed
401 Unauthorized       // Missing/invalid auth token
403 Forbidden          // Valid auth but insufficient permissions
404 Not Found          // Resource doesn't exist
409 Conflict           // Concurrent modification (use ETags)
422 Unprocessable      // Semantic validation failed (Zod errors)
429 Too Many Requests  // Rate limit exceeded
```

### Server Errors (5xx)
```typescript
500 Internal Server    // Uncaught exception
502 Bad Gateway        // Upstream service failed
503 Service Unavailable// Maintenance mode
504 Gateway Timeout    // Upstream timeout
```

## Resource Naming

### Use Nouns, Not Verbs
```
❌ /api/getUsers
❌ /api/createUser
❌ /api/deleteUser

✅ GET    /api/users
✅ POST   /api/users
✅ DELETE /api/users/123
```

### Use Plural Nouns
```
❌ /api/user/123
✅ /api/users/123

❌ /api/product/456
✅ /api/products/456
```

### Nested Resources
```
✅ /api/users/123/orders           // User's orders
✅ /api/orders/456/items           // Order's items
✅ /api/projects/789/tasks/12      // Specific task in project

❌ /api/users/123/orders/456/items/78/comments  // Too deep (max 3 levels)
```

## Pagination

### Offset-Based (Simple)
```typescript
GET /api/users?limit=20&offset=40
// Returns: { data: [...], total: 1234, limit: 20, offset: 40 }
```

### Cursor-Based (Large Datasets)
```typescript
GET /api/users?limit=20&cursor=eyJpZCI6MTIzfQ
// Returns: { data: [...], nextCursor: "eyJpZCI6MTQzfQ", hasMore: true }
```

### Page-Based (User-Friendly)
```typescript
GET /api/users?page=3&perPage=20
// Returns: { data: [...], page: 3, perPage: 20, totalPages: 62 }
```

## Filtering & Sorting

```typescript
// Filtering
GET /api/users?status=active&role=admin
GET /api/products?price_min=100&price_max=500

// Sorting
GET /api/users?sort=created_at:desc
GET /api/products?sort=price:asc,name:asc  // Multiple fields

// Searching
GET /api/users?q=john
GET /api/products?search=laptop&fields=name,description
```

## API Versioning

### URL Versioning (Recommended for Public APIs)
```
✅ /api/v1/users
✅ /api/v2/users

Pros: Explicit, easy to test
Cons: URL proliferation
```

### Header Versioning (REST Purist)
```
GET /api/users
Accept: application/vnd.myapi.v1+json

Pros: Clean URLs
Cons: Harder to debug
```

### No Versioning (Internal APIs)
```
// Use feature flags + deprecation warnings instead
```

## Error Response Format

### Standard Error Structure
```typescript
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email is required",
    "details": [
      {
        "field": "email",
        "message": "Email is required",
        "code": "required"
      }
    ],
    "requestId": "req_abc123",
    "timestamp": "2026-10-04T07:51:51Z"
  }
}
```

### Machine-Readable Error Codes
```typescript
// Use SCREAMING_SNAKE_CASE
VALIDATION_ERROR
RESOURCE_NOT_FOUND
UNAUTHORIZED
RATE_LIMIT_EXCEEDED
PAYMENT_FAILED
```

## Authentication

### Bearer Token (JWT)
```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### API Key (Simple)
```http
X-API-Key: sk_live_abc123...
```

### Basic Auth (Avoid for Production)
```http
Authorization: Basic dXNlcjpwYXNz
```

## Rate Limiting Headers

```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 973
X-RateLimit-Reset: 1625097600

// On rate limit exceeded (429)
Retry-After: 60  // Seconds until reset
```

## CORS Headers

```typescript
Access-Control-Allow-Origin: https://app.example.com
Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE
Access-Control-Allow-Headers: Authorization, Content-Type
Access-Control-Max-Age: 86400  // 24 hours
```

## Example: Complete REST Endpoint

```typescript
// Route: POST /api/users
app.post('/api/users', async (req, res) => {
  try {
    // 1. Validate input
    const schema = z.object({
      email: z.string().email(),
      name: z.string().min(2),
      role: z.enum(['user', 'admin'])
    });
    
    const data = schema.parse(req.body);
    
    // 2. Check auth
    if (!req.user) {
      return res.status(401).json({
        error: { code: 'UNAUTHORIZED', message: 'Missing auth token' }
      });
    }
    
    // 3. Check permissions
    if (!req.user.canCreateUsers) {
      return res.status(403).json({
        error: { code: 'FORBIDDEN', message: 'Insufficient permissions' }
      });
    }
    
    // 4. Create resource
    const user = await db.users.create(data);
    
    // 5. Return 201 with Location header
    res.status(201)
      .header('Location', `/api/users/${user.id}`)
      .json({ data: user });
      
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(422).json({
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Invalid input',
          details: error.errors
        }
      });
    }
    
    // Log error for monitoring
    console.error(error);
    
    res.status(500).json({
      error: { code: 'INTERNAL_ERROR', message: 'Something went wrong' }
    });
  }
});
```

## When to Break These Rules

1. **GraphQL instead of REST**: Complex nested queries, real-time subscriptions
2. **RPC-style endpoints**: Operations that don't map to CRUD (`/api/calculate-tax`)
3. **Batch operations**: `/api/users/batch` (POST array of operations)
4. **Legacy constraints**: Existing clients depend on non-standard behavior
