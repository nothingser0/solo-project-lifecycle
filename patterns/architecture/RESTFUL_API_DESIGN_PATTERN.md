# RESTful API Design & Resource Modeling Pattern

> **Module**: M05 (Architecture & Specs) & M06 (Development Execution)  
> **Source**: Adapted from Roy Fielding's REST Dissertation, Richardson Maturity Model, and industrial REST API design references (`aisuhua/restful-api-design-references`).  
> **Scope**: Authoritative engineering rules for designing clean, predictable, resource-oriented RESTful APIs. Covers noun-based resource paths, HTTP method semantics, pagination/filtering query parameters, and robust error handling contracts.

---

## 1. Core Resource-Oriented Design Rules

### A. Nouns, Not Verbs (Resource Paths)
* URIs must represent **resources (nouns)** in plural form, never RPC-style remote procedure actions.
* *Prohibited*: `POST /getUsers`, `POST /updateUserProfile`, `DELETE /deleteOrder?id=123`.
* *Enforced*: 
  - `GET /api/v1/users` (List users)
  - `POST /api/v1/users` (Create user)
  - `GET /api/v1/users/{id}` (Get specific user)
  - `PATCH /api/v1/users/{id}` (Partial update user)
  - `DELETE /api/v1/users/{id}` (Delete user)

### B. Hierarchical Sub-Resources
* When a resource belongs to another parent resource, reflect the hierarchy in the URI path:
  - `GET /api/v1/users/{user_id}/orders` (List orders belonging to user)
  - `GET /api/v1/users/{user_id}/orders/{order_id}` (Get specific order for user)
* *Nesting limit*: Do not nest more than **2 levels deep** (`/parents/{id}/children/{id}/grandsons` becomes unmaintainable; use flat query filters instead: `/grandsons?child_id={id}`).

---

## 2. HTTP Method & Status Code Semantics

| HTTP Method | Idempotent? | Safe? | Typical Action | Success Status Code |
| :--- | :---: | :---: | :--- | :--- |
| **GET** | Yes | Yes | Retrieve resource(s) | `200 OK` |
| **POST** | No | No | Create new resource | `201 Created` (with `Location` header) |
| **PUT** | Yes | No | Replace resource entirely | `200 OK` or `204 No Content` |
| **PATCH** | No | No | Partial update of resource | `200 OK` or `204 No Content` |
| **DELETE**| Yes | No | Delete resource | `200 OK` or `204 No Content` |

### Mandatory Status Code Standard
* `200 OK`: Request succeeded for GET, PATCH, PUT, DELETE.
* `201 Created`: POST resource creation succeeded. Include `Location: /api/v1/resources/{id}`.
* `204 No Content`: Successful action that returns no body (e.g. DELETE or background trigger).
* `400 Bad Request`: Client validation error (malformed JSON, invalid Zod schema).
* `401 Unauthorized`: Missing or invalid authentication token.
* `403 Forbidden`: Authenticated user lacks RBAC permissions for the action.
* `404 Not Found`: Resource ID does not exist.
* `409 Conflict`: Unique constraint violation (e.g. email already registered).
* `429 Too Many Requests`: Rate limit exceeded (`Retry-After` header required).
* `500 Internal Server Error`: Unhandled server exception.

---

## 3. Query Parameters: Pagination, Filtering & Sorting

Never dump unfiltered tables. All list endpoints MUST implement standard query parameters:

### A. Pagination (Cursor / Keyseting Preferred)
* **Cursor Pagination** (`limit`, `cursor` / `starting_after`): Mandatory for large datasets or infinite scrolls.
  - `GET /api/v1/orders?limit=20&cursor=eyJjcmVhdGVkX2F0Ijoi...`
* **Offset Pagination** (`limit`, `offset`): Acceptable for small admin tables where total count is strictly needed.
  - `GET /api/v1/users?limit=10&offset=20` (Max `limit <= 100`).

### B. Filtering & Sorting
* **Filtering**: Use exact field names or operators as query params:
  - `GET /api/v1/invoices?status=pending&created_gte=2026-01-01`
* **Sorting**: Prefix with `-` for descending order:
  - `GET /api/v1/products?sort=-created_at,price` (Sort by created_at DESC, then price ASC).

---

## 4. Standardized JSON Error Response Envelope

All API error responses must adhere to a predictable JSON structure (RFC 7807 Problem Details compliant):

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request payload.",
    "status": 400,
    "details": [
      {
        "field": "email",
        "issue": "Invalid email address format."
      }
    ],
    "timestamp": "2026-10-18T10:00:00Z",
    "path": "/api/v1/users"
  }
}
```
