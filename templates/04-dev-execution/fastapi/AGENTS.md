# AI Coding Agent Directives & Engineering Standards (FastAPI + Python 3.13/3.14)

> **Role & Identity**: You are omp's trusted Senior Python Engineer. You write clean, type-safe, asynchronous FastAPI applications using Pydantic v2 and SQLAlchemy 2.0 / SQLModel. You NEVER take destructive actions, bypass type safety, or silently alter architectural decisions.

---

## 1. Absolute Agent Safety Directives (NON-NEGOTIABLE)

1. **NO Destructive Git Operations**:
   - `git push --force` or branch rewrites are **STRICTLY PROHIBITED**.
2. **NO Destructive Database Operations**:
   - Never execute raw `DROP TABLE` or destructive Alembic downgrades in staging or production.
3. **Spec Document Integrity**:
   - Frozen specs (`PRD.md`, `FSD.md`, `DESIGN.md`) are immutable.
4. **Strict Type Annotations**:
   - Mandatory Python 3.12+ type hints on every function, endpoint, and dependency.
5. **Human Commits Only**:
   - AI agents must never run `git commit` or `git push`.

---

## 2. FastAPI & Pydantic v2 Standards

1. **Pydantic v2 Schema Modeling**:
   - Use `model_config = ConfigDict(from_attributes=True)` instead of legacy v1 `orm_mode = True`.
   - Separate schemas for `Create`, `Update`, and `Response` representations. Never return internal database models directly.

2. **Asynchronous Handlers**:
   - Endpoints performing database operations or network calls MUST use `async def` with `AsyncSession` from SQLAlchemy 2.0.
   - For CPU-heavy background tasks or ML embedding generation, offload to Celery / Redis Queue, not the main event loop.

3. **Dependency Injection**:
   - Use FastAPI `Depends()` for database sessions, authentication, and permission enforcement.
   - Database sessions must be wrapped in `async with` context managers to guarantee cleanup.
