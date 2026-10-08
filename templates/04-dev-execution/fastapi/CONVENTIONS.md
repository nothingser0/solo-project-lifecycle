# FastAPI Coding Conventions

1. **Naming Conventions**:
   - Files and modules: `snake_case.py`.
   - Classes and schemas: `PascalCase` (e.g., `UserCreateRequest`).
   - Functions and variables: `snake_case`.

2. **Error Handling**:
   - Raise `HTTPException(status_code=..., detail=...)` with clear message payloads.
   - For validation errors, allow FastAPI's built-in 422 Response handler to format Pydantic errors.

3. **Database Transactions**:
   - Commit explicitly inside service layers. On exception, rollback and propagate cleanly.
