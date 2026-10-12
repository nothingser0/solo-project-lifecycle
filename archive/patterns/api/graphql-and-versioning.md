# API Architecture: GraphQL, REST, & Versioning Patterns

Standardized conventions for designing, securing, and versioning APIs across REST and GraphQL architectures for solo developers.

---

## 1. REST vs GraphQL Decision Framework

| Criterion | REST API | GraphQL |
|---|---|---|
| **Best For** | Standard CRUD, file uploads, public third-party integrations, webhook consumers | Rich dashboards, polymorphic relations, multiple mobile/web clients with varied payloads |
| **Caching** | Native HTTP caching (Edge/CDN, `ETag`, `Cache-Control`) | Complex application-level caching (Normalized Apollo/Relay cache) |
| **Over-fetching** | Vulnerable unless sparse fieldsets (`?fields=id,title`) are built | Zero over-fetching (client requests exact query shape) |
| **Complexity** | Low — standard HTTP methods and status codes | Medium/High — requires schema governance, query depth limiting, cost analysis |
| **Solo Dev Velocity** | **Highest** (less moving parts, boring tech) | High for frontend-heavy projects with rapidly changing UI layouts |

---

## 2. API Versioning Patterns

Never break existing mobile clients or integrations when introducing breaking schema modifications.

### 2.1 URI Path Versioning (Recommended Default)

```typescript
// Explicit, clear routing, CDN-cache friendly
GET /api/v1/documents
GET /api/v2/documents
```

**Next.js 15 App Router Implementation**:
```typescript
// src/app/api/v1/documents/route.ts
export async function GET() {
  return Response.json({
    version: '1.0',
    data: await getDocumentsV1(),
  });
}

// src/app/api/v2/documents/route.ts
export async function GET() {
  return Response.json({
    version: '2.0',
    data: await getDocumentsV2(), // includes updated pagination metadata
  });
}
```

### 2.2 Header-Based Versioning

Useful for preserving permalinks:
```http
GET /api/documents HTTP/1.1
Host: api.example.com
Accept: application/vnd.example.v2+json
```

---

## 3. GraphQL Implementation Pattern

When building client-driven dashboards, use modern TypeScript schema-first or code-first approaches (e.g., Pothos, Yoga, or Apollo Server).

### 3.1 Secure GraphQL Yoga Setup with Query Depth Protection


```bash
# Required dependencies
npm install graphql-yoga graphql @envelop/depth-limit
```

```typescript
import { createYoga, createSchema } from 'graphql-yoga';
import { useDepthLimit } from '@envelop/depth-limit'; // Official Envelop plugin for query depth limiting

const schema = createSchema({
  typeDefs: /* GraphQL */ `
    type User {
      id: ID!
      email: String!
      name: String
      documents(limit: Int): [Document!]!
    }

    type Document {
      id: ID!
      title: String!
      status: String!
      author: User!
    }

    type Query {
      me: User
      document(id: ID!): Document
    }

    type Mutation {
      createDocument(title: String!): Document!
    }
  `,
  resolvers: {
    Query: {
      me: async (_, __, context) => {
        if (!context.user) throw new Error('Unauthorized');
        return context.db.user.findUnique({ where: { id: context.user.id } });
      },
      document: async (_, { id }, context) => {
        return context.db.document.findUnique({ where: { id } });
      },
    },
    Document: {
      author: async (parent, _, context) => {
        // Use DataLoader here to avoid N+1 queries!
        return context.loaders.userLoader.load(parent.authorId);
      },
    },
  },
});

export const yoga = createYoga({
  schema,
  graphqlEndpoint: '/api/graphql',
  fetchAPI: { Response },
  plugins: [
    // Security: Limit recursive query nesting to max 5 levels via Envelop plugin
    useDepthLimit({ maxDepth: 5 }),
  ],
});
```

---

## 4. API Error Contract Standardization

Both REST and GraphQL APIs must return structured, RFC-7807 compliant error payloads:

```json
{
  "type": "https://api.example.com/errors/validation-failed",
  "title": "Validation Failed",
  "status": 422,
  "detail": "The request body failed schema validation.",
  "instance": "/api/v1/documents",
  "invalidParams": [
    {
      "name": "title",
      "reason": "Title must be at least 3 characters long"
    }
  ]
}
```

---

## 5. Best Practices Checklist

- [ ] URI versioning (`/api/v1/...`) used as primary versioning mechanism.
- [ ] Breaking changes require a new version path (`/v2/`); deprecated versions supported for at least 90 days.
- [ ] GraphQL query depth is limited (max depth: 5) to prevent nested query denial-of-service.
- [ ] GraphQL relationship resolvers utilize DataLoader to prevent N+1 query bottlenecks.
- [ ] Errors follow structured envelope standards (RFC 7807) with machine-readable error codes.

---

## See Also

- `patterns/api/rest-conventions.md` - Core HTTP status codes, method semantics, & pagination
- `patterns/performance/n-plus-one-prevention.md` - DataLoader patterns for GraphQL & ORMs
- `patterns/validation/zod-patterns.md` - Type-safe schema validation
