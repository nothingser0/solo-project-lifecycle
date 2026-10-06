# API Documentation Guide

> **Purpose**: Document APIs for Large/Enterprise projects  
> **When**: M06 Development (alongside coding)  
> **Target**: Public APIs, partner integrations, microservices

---

## API Documentation Standards

### OpenAPI/Swagger (Recommended)

**Generate from code** (automatic, always up-to-date):

```typescript
// Express + Swagger JSDoc
/**
 * @openapi
 * /api/users/{id}:
 *   get:
 *     summary: Get user by ID
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: User ID
 *     responses:
 *       200:
 *         description: User found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/User'
 *       404:
 *         description: User not found
 */
app.get('/api/users/:id', async (req, res) => {
  const user = await User.findById(req.params.id);
  if (!user) return res.status(404).json({ error: 'User not found' });
  res.json(user);
});
```

**Generate docs**:
```bash
npm install swagger-jsdoc swagger-ui-express

# Serve docs at /api-docs
# Auto-generated from JSDoc comments
```

---

## API Documentation Template

### Endpoint: Create User

**Method**: `POST /api/users`

**Description**: Creates a new user account

**Authentication**: Required (Bearer token)

**Request Headers**:
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Request Body**:
```json
{
  "email": "user@example.com",
  "name": "John Doe",
  "password": "SecureP@ssw0rd",
  "role": "user"
}
```

**Request Schema**:
| Field | Type | Required | Constraints |
|:------|:-----|:---------|:------------|
| email | string | Yes | Valid email format |
| name | string | Yes | 2-50 characters |
| password | string | Yes | Min 8 chars, 1 uppercase, 1 number, 1 special |
| role | enum | No | `user` \| `admin` (default: `user`) |

**Response 201 Created**:
```json
{
  "id": "usr_1a2b3c4d",
  "email": "user@example.com",
  "name": "John Doe",
  "role": "user",
  "createdAt": "2024-10-04T12:00:00Z"
}
```

**Response 400 Bad Request**:
```json
{
  "error": "Validation failed",
  "details": [
    {
      "field": "email",
      "message": "Email already exists"
    }
  ]
}
```

**Response 401 Unauthorized**:
```json
{
  "error": "Invalid or missing token"
}
```

**cURL Example**:
```bash
curl -X POST https://api.example.com/api/users \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "name": "John Doe",
    "password": "SecureP@ssw0rd"
  }'
```

**Rate Limit**: 100 requests/hour per API key

---

## Tools for API Docs

### 1. Swagger/OpenAPI

**Best for**: REST APIs, auto-generated from code

**Setup** (Node.js):
```bash
npm install swagger-jsdoc swagger-ui-express
```

```typescript
// server.ts
import swaggerJsdoc from 'swagger-jsdoc';
import swaggerUi from 'swagger-ui-express';

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'My API',
      version: '1.0.0',
      description: 'API documentation',
    },
    servers: [
      { url: 'https://api.example.com', description: 'Production' },
      { url: 'https://staging-api.example.com', description: 'Staging' },
    ],
  },
  apis: ['./src/routes/*.ts'], // Path to API files
};

const specs = swaggerJsdoc(options);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(specs));
```

**Access**: https://api.example.com/api-docs

---

### 2. Postman Collections

**Best for**: Internal APIs, team collaboration

**Export from Postman**:
1. Postman → Collections → ... → Export
2. Choose Collection v2.1 format
3. Save as `postman_collection.json`
4. Commit to repo

**Share with team**:
- Import button in Postman
- Or publish to Postman workspace

---

### 3. Redoc

**Best for**: Beautiful static docs from OpenAPI

```bash
npm install redoc-cli

# Generate static HTML
npx redoc-cli build openapi.yaml -o docs/api.html

# Serve live
npx redoc-cli serve openapi.yaml
```

---

### 4. Stoplight

**Best for**: Enterprise, design-first APIs

- Visual API editor
- Mock servers
- Auto-generated SDKs
- Hosted docs

---

## API Documentation Checklist

### Required Sections

- [ ] **Overview**: What the API does, use cases
- [ ] **Authentication**: How to authenticate (API key, JWT, OAuth)
- [ ] **Base URL**: Production, staging URLs
- [ ] **Rate Limits**: Requests per hour/day
- [ ] **Error Codes**: All possible errors with examples
- [ ] **Endpoints**: Complete list with methods
- [ ] **Schemas**: Request/response models
- [ ] **Examples**: cURL, JavaScript, Python examples
- [ ] **Changelog**: Version history

---

### Per Endpoint

- [ ] **Method + Path**: GET/POST/PUT/DELETE + URL
- [ ] **Description**: What it does (1-2 sentences)
- [ ] **Auth required**: Yes/No
- [ ] **Request headers**: Required headers
- [ ] **Request body**: JSON schema + example
- [ ] **Path/query params**: All parameters documented
- [ ] **Response codes**: 200, 400, 401, 404, 500
- [ ] **Response body**: JSON schema + example
- [ ] **cURL example**: Copy-paste ready
- [ ] **Rate limit**: Specific to endpoint (if different)

---

## Authentication Documentation

### API Key Authentication

```markdown
## Authentication

All API requests require an API key.

### Get API Key
1. Log in to dashboard
2. Go to Settings → API Keys
3. Click "Generate New Key"
4. Copy key (shown once only)

### Using API Key

Include in `Authorization` header:

```bash
curl -H "Authorization: Bearer YOUR_API_KEY" \
  https://api.example.com/api/users
```

**Security**: Never commit API keys to Git. Use environment variables.

### Rate Limits
- Free tier: 100 requests/hour
- Pro tier: 1000 requests/hour
- Enterprise: Unlimited

**Rate limit headers**:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1696435200
```
```

---

## Error Documentation

### Standard Error Response

All errors return this format:

```json
{
  "error": "Error message",
  "code": "ERROR_CODE",
  "details": [
    {
      "field": "email",
      "message": "Invalid email format"
    }
  ],
  "requestId": "req_1a2b3c4d"
}
```

### Error Codes

| Code | HTTP Status | Meaning | Action |
|:-----|:------------|:--------|:-------|
| `INVALID_REQUEST` | 400 | Malformed request | Check request format |
| `AUTHENTICATION_FAILED` | 401 | Invalid credentials | Check API key |
| `FORBIDDEN` | 403 | No permission | Check user permissions |
| `NOT_FOUND` | 404 | Resource not found | Check resource ID |
| `RATE_LIMIT_EXCEEDED` | 429 | Too many requests | Wait before retrying |
| `INTERNAL_ERROR` | 500 | Server error | Contact support |

---

## SDK Documentation

### JavaScript SDK

```bash
npm install @yourcompany/api-client
```

```typescript
import { ApiClient } from '@yourcompany/api-client';

const client = new ApiClient({ apiKey: 'YOUR_API_KEY' });

// Get user
const user = await client.users.get('usr_123');

// Create user
const newUser = await client.users.create({
  email: 'user@example.com',
  name: 'John Doe',
});
```

### Python SDK

```bash
pip install yourcompany-api
```

```python
from yourcompany import ApiClient

client = ApiClient(api_key='YOUR_API_KEY')

# Get user
user = client.users.get('usr_123')

# Create user
new_user = client.users.create(
    email='user@example.com',
    name='John Doe'
)
```

---

## Versioning

### API Versioning Strategy

**URL versioning** (recommended):
```
https://api.example.com/v1/users
https://api.example.com/v2/users
```

**Header versioning**:
```
GET /api/users
Accept: application/vnd.yourcompany.v1+json
```

### Changelog

```markdown
## API Changelog

### v2.0.0 (2024-10-01)
**Breaking Changes**:
- Changed `user_id` to `userId` (camelCase)
- Removed deprecated `/legacy-endpoint`

**New Features**:
- Added pagination to `/users` endpoint
- New `/webhooks` endpoint

**Bug Fixes**:
- Fixed timezone handling in date fields

### v1.2.0 (2024-09-01)
**New Features**:
- Added `/users/bulk` endpoint for batch operations

### v1.1.0 (2024-08-01)
**Improvements**:
- Increased rate limit from 100 to 200 requests/hour
```

---

## Interactive API Explorer

### Swagger UI

**Features**:
- Try API calls directly from docs
- No code needed
- See real responses

**Example**:
```
https://api.example.com/api-docs

1. Click endpoint (e.g., GET /users)
2. Click "Try it out"
3. Enter parameters
4. Click "Execute"
5. See response
```

---

## Webhooks Documentation

### Webhook Events

**Event**: `user.created`

**Triggered**: When a new user is created

**Payload**:
```json
{
  "event": "user.created",
  "timestamp": "2024-10-04T12:00:00Z",
  "data": {
    "id": "usr_123",
    "email": "user@example.com",
    "name": "John Doe"
  }
}
```

**Webhook Headers**:
```
X-Webhook-Signature: sha256=abc123...
X-Webhook-ID: wh_1a2b3c4d
Content-Type: application/json
```

**Verify Signature**:
```typescript
import crypto from 'crypto';

function verifySignature(payload: string, signature: string, secret: string) {
  const expectedSignature = crypto
    .createHmac('sha256', secret)
    .update(payload)
    .digest('hex');
  
  return `sha256=${expectedSignature}` === signature;
}
```

---

## Example: Full API Documentation

**File**: `docs/api/README.md`

```markdown
# API Documentation

Base URL: `https://api.example.com`

## Authentication

Include API key in `Authorization` header:
```bash
Authorization: Bearer YOUR_API_KEY
```

Get API key from [Dashboard → API Keys](https://app.example.com/settings/api).

## Rate Limits

- 100 requests/hour (free tier)
- 1000 requests/hour (pro tier)

## Endpoints

### Users

#### List Users
`GET /api/users`

Query parameters:
- `page` (number): Page number (default: 1)
- `limit` (number): Items per page (default: 20, max: 100)

Response:
```json
{
  "users": [...],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 50
  }
}
```

#### Get User
`GET /api/users/:id`

Response:
```json
{
  "id": "usr_123",
  "email": "user@example.com",
  "name": "John Doe"
}
```

#### Create User
`POST /api/users`

Request:
```json
{
  "email": "user@example.com",
  "name": "John Doe",
  "password": "SecureP@ssw0rd"
}
```

Response: 201 Created

---

## Errors

All errors use this format:
```json
{
  "error": "Error message",
  "code": "ERROR_CODE"
}
```

Common errors:
- `400 INVALID_REQUEST`: Malformed request
- `401 UNAUTHORIZED`: Invalid API key
- `404 NOT_FOUND`: Resource not found
- `429 RATE_LIMIT_EXCEEDED`: Too many requests

---

## SDKs

- [JavaScript](https://www.npmjs.com/package/@yourcompany/api-client)
- [Python](https://pypi.org/project/yourcompany-api/)
- [PHP](https://packagist.org/packages/yourcompany/api)

---

## Support

- [API Status](https://status.example.com)
- [GitHub Issues](https://github.com/yourcompany/api/issues)
- [Email](mailto:api-support@example.com)
```

---

## Checklist

Before publishing API docs:
- [ ] All endpoints documented
- [ ] Authentication explained
- [ ] Error codes listed
- [ ] Rate limits stated
- [ ] Examples provided (cURL, SDK)
- [ ] Changelog maintained
- [ ] Interactive explorer working (Swagger UI)

Ongoing maintenance:
- [ ] Update docs when API changes
- [ ] Version API properly (v1, v2)
- [ ] Deprecate old endpoints gracefully (6+ months notice)
- [ ] Monitor API usage analytics

---

## Notes

**Docs should be**:
- Accurate (always up-to-date)
- Complete (all endpoints)
- Clear (examples for everything)
- Accessible (public URL, searchable)

**Auto-generate when possible**: JSDoc → Swagger (prevents docs drift)

**Treat docs as code**: Review in PRs, test examples
