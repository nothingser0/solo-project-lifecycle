# FastAPI Architecture Guide

## Directory Structure

```text
app/
├── api/
│   ├── v1/
│   │   ├── endpoints/
│   │   │   ├── auth.py
│   │   │   └── items.py
│   │   └── router.py
├── core/
│   ├── config.py         # Pydantic BaseSettings
│   ├── security.py       # Password hashing & JWT
│   └── database.py       # Async SQLAlchemy engine & session factory
├── models/               # SQLAlchemy ORM models
│   └── item.py
├── schemas/              # Pydantic validation schemas
│   └── item.py
├── services/             # Core business logic
└── main.py               # FastAPI application entrypoint
```

## Architectural Rules

1. **Layer Separation**: Endpoints in `api/` handle HTTP parsing and status codes. Business logic belongs in `services/`. Database queries execute via `AsyncSession`.
2. **Migrations**: Manage all database DDL changes using Alembic (`alembic revision --autogenerate`). Never create tables via `Base.metadata.create_all()` in production.
3. **Configuration**: Environment variables must load through `pydantic-settings` with strict types and defaults.
