# Error Handling Patterns

Comprehensive error handling strategies for production applications. Covers error boundaries, custom error classes, logging, and user-facing messages.

## Error Classification

### 1. Operational Errors (Expected)
Errors that can be anticipated and handled gracefully:
```typescript
- Network timeout
- Database connection lost
- File not found
- Invalid user input
- Rate limit exceeded
- Payment declined
```

### 2. Programmer Errors (Bugs)
Errors that indicate code defects:
```typescript
- Null pointer exception
- Type mismatch
- Array index out of bounds
- Infinite recursion
- Uncaught promise rejection
```

**Strategy**: Operational errors → handle gracefully. Programmer errors → crash and fix.

---

## Custom Error Classes

### Base Error Hierarchy
```typescript
// base-error.ts
export class AppError extends Error {
  public readonly statusCode: number;
  public readonly code: string;
  public readonly isOperational: boolean;

  constructor(
    message: string,
    statusCode: number,
    code: string,
    isOperational = true
  ) {
    super(message);
    this.statusCode = statusCode;
    this.code = code;
    this.isOperational = isOperational;
    
    Error.captureStackTrace(this, this.constructor);
  }
}

// Specific error types
export class ValidationError extends AppError {
  constructor(message: string, public details?: any) {
    super(message, 422, 'VALIDATION_ERROR');
  }
}

export class NotFoundError extends AppError {
  constructor(resource: string) {
    super(`${resource} not found`, 404, 'NOT_FOUND');
  }
}

export class UnauthorizedError extends AppError {
  constructor(message = 'Unauthorized') {
    super(message, 401, 'UNAUTHORIZED');
  }
}

export class ForbiddenError extends AppError {
  constructor(message = 'Forbidden') {
    super(message, 403, 'FORBIDDEN');
  }
}

export class ConflictError extends AppError {
  constructor(message: string) {
    super(message, 409, 'CONFLICT');
  }
}
```

### Usage
```typescript
// In route handler
if (!user) {
  throw new NotFoundError('User');
}

if (!req.user.canDelete) {
  throw new ForbiddenError('Insufficient permissions');
}

const result = schema.safeParse(req.body);
if (!result.success) {
  throw new ValidationError('Invalid input', result.error.errors);
}
```

---

## Global Error Handler (Express)

```typescript
// middleware/error-handler.ts
import { Request, Response, NextFunction } from 'express';
import { AppError } from '../errors/base-error';

export const errorHandler = (
  err: Error,
  req: Request,
  res: Response,
  next: NextFunction
) => {
  // 1. Log error
  console.error({
    error: err.message,
    stack: err.stack,
    url: req.url,
    method: req.method,
    userId: req.user?.id,
    timestamp: new Date().toISOString()
  });

  // 2. Send error response
  if (err instanceof AppError) {
    // Known operational error
    return res.status(err.statusCode).json({
      error: {
        code: err.code,
        message: err.message,
        ...(err instanceof ValidationError && { details: err.details })
      }
    });
  }

  // 3. Unknown error (programmer error)
  if (process.env.NODE_ENV === 'production') {
    // Don't leak error details to client
    return res.status(500).json({
      error: {
        code: 'INTERNAL_ERROR',
        message: 'Something went wrong'
      }
    });
  } else {
    // Development: show full error
    return res.status(500).json({
      error: {
        code: 'INTERNAL_ERROR',
        message: err.message,
        stack: err.stack
      }
    });
  }
};

// Register after all routes
app.use(errorHandler);
```

---

## Async Error Wrapper

```typescript
// utils/async-handler.ts
export const asyncHandler = (fn: Function) => {
  return (req: Request, res: Response, next: NextFunction) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};

// Usage
app.get('/users/:id', asyncHandler(async (req, res) => {
  const user = await db.users.findUnique({ where: { id: req.params.id } });
  
  if (!user) {
    throw new NotFoundError('User');  // Automatically caught by errorHandler
  }
  
  res.json({ data: user });
}));
```

---

## Error Logging

### Structured Logging
```typescript
// utils/logger.ts
import winston from 'winston';

export const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' })
  ]
});

if (process.env.NODE_ENV !== 'production') {
  logger.add(new winston.transports.Console({
    format: winston.format.simple()
  }));
}

// In error handler
logger.error('Request failed', {
  error: err.message,
  stack: err.stack,
  url: req.url,
  userId: req.user?.id,
  statusCode: err.statusCode
});
```

### Error Monitoring (Sentry)
```typescript
import * as Sentry from '@sentry/node';

Sentry.init({ dsn: process.env.SENTRY_DSN });

// In error handler
if (err instanceof AppError && !err.isOperational) {
  // Only report programmer errors to Sentry
  Sentry.captureException(err);
}
```

---

## Frontend Error Boundaries (React)

### Class Component Boundary
```typescript
// components/ErrorBoundary.tsx
import React, { Component, ReactNode } from 'react';

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
}

interface State {
  hasError: boolean;
  error: Error | null;
}

export class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error('Error boundary caught:', error, errorInfo);
    // Report to error tracking service
  }

  render() {
    if (this.state.hasError) {
      return this.props.fallback || (
        <div className="error-boundary">
          <h2>Something went wrong</h2>
          <pre>{this.state.error?.message}</pre>
          <button onClick={() => this.setState({ hasError: false })}>
            Try again
          </button>
        </div>
      );
    }

    return this.props.children;
  }
}

// Usage
<ErrorBoundary>
  <App />
</ErrorBoundary>
```

### Query Error Handling (React Query)
```typescript
// hooks/useUser.ts
import { useQuery } from '@tanstack/react-query';

export const useUser = (id: string) => {
  return useQuery({
    queryKey: ['user', id],
    queryFn: async () => {
      const res = await fetch(`/api/users/${id}`);
      
      if (!res.ok) {
        const error = await res.json();
        throw new Error(error.error.message);
      }
      
      return res.json();
    },
    retry: (failureCount, error) => {
      // Retry network errors, not 404s
      if (error.message.includes('not found')) return false;
      return failureCount < 3;
    }
  });
};

// Component
function UserProfile({ userId }: { userId: string }) {
  const { data, error, isLoading } = useUser(userId);

  if (isLoading) return <Spinner />;
  if (error) return <ErrorMessage error={error} />;
  
  return <div>{data.name}</div>;
}
```

---

## Database Error Handling

### Prisma Error Mapping
```typescript
import { Prisma } from '@prisma/client';

export const handlePrismaError = (err: unknown) => {
  if (err instanceof Prisma.PrismaClientKnownRequestError) {
    switch (err.code) {
      case 'P2002':
        // Unique constraint violation
        throw new ConflictError('Resource already exists');
      
      case 'P2025':
        // Record not found
        throw new NotFoundError('Resource');
      
      case 'P2003':
        // Foreign key constraint failed
        throw new ValidationError('Invalid reference');
      
      default:
        throw new AppError('Database error', 500, 'DATABASE_ERROR');
    }
  }
  
  throw err;
};

// Usage
try {
  const user = await db.user.create({ data: { email } });
} catch (err) {
  throw handlePrismaError(err);
}
```

---

## Graceful Shutdown

```typescript
// server.ts
const server = app.listen(PORT);

const gracefulShutdown = (signal: string) => {
  console.log(`${signal} received, closing server...`);
  
  server.close(() => {
    console.log('Server closed');
    
    // Close database connections
    db.$disconnect();
    
    process.exit(0);
  });
  
  // Force shutdown after 10 seconds
  setTimeout(() => {
    console.error('Forced shutdown');
    process.exit(1);
  }, 10000);
};

process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));

// Handle uncaught exceptions
process.on('uncaughtException', (err) => {
  console.error('Uncaught exception:', err);
  gracefulShutdown('uncaughtException');
});

process.on('unhandledRejection', (reason) => {
  console.error('Unhandled rejection:', reason);
  gracefulShutdown('unhandledRejection');
});
```

---

## Testing Error Handling

```typescript
// tests/error-handler.test.ts
import request from 'supertest';
import app from '../app';

describe('Error Handler', () => {
  it('returns 404 for unknown routes', async () => {
    const res = await request(app).get('/api/unknown');
    
    expect(res.status).toBe(404);
    expect(res.body.error.code).toBe('NOT_FOUND');
  });

  it('returns 422 for validation errors', async () => {
    const res = await request(app)
      .post('/api/users')
      .send({ email: 'invalid' });
    
    expect(res.status).toBe(422);
    expect(res.body.error.code).toBe('VALIDATION_ERROR');
    expect(res.body.error.details).toBeDefined();
  });

  it('hides error details in production', async () => {
    process.env.NODE_ENV = 'production';
    
    // Force internal error
    const res = await request(app).get('/api/crash');
    
    expect(res.status).toBe(500);
    expect(res.body.error.message).toBe('Something went wrong');
    expect(res.body.error.stack).toBeUndefined();
  });
});
```

---

## Best Practices

### ✅ Do
1. **Use custom error classes** for known error types
2. **Log all errors** with context (user ID, URL, timestamp)
3. **Hide stack traces** in production
4. **Validate input** before processing
5. **Return consistent error format** across all endpoints
6. **Monitor errors** with Sentry/Datadog
7. **Test error paths** in unit/integration tests

### ❌ Don't
1. **Swallow errors** with empty catch blocks
2. **Expose sensitive data** in error messages
3. **Use error codes** as control flow
4. **Throw strings** (`throw "error"`) - always throw Error objects
5. **Ignore unhandled rejections**
6. **Return HTML errors** from JSON APIs
7. **Use status 200** for errors

---

## Example: Complete Error Flow

```typescript
// routes/users.ts
app.post('/api/users', asyncHandler(async (req, res) => {
  // 1. Validation
  const result = createUserSchema.safeParse(req.body);
  if (!result.success) {
    throw new ValidationError('Invalid input', result.error.errors);
  }

  // 2. Authorization
  if (!req.user) {
    throw new UnauthorizedError();
  }

  // 3. Business logic
  try {
    const user = await db.user.create({
      data: result.data
    });
    
    res.status(201).json({ data: user });
  } catch (err) {
    throw handlePrismaError(err);
  }
}));

// Error caught by asyncHandler → passed to errorHandler → logged → response sent
```

This pattern ensures:
- ✅ Consistent error responses
- ✅ Proper HTTP status codes
- ✅ Detailed logging for debugging
- ✅ No sensitive data leaks
- ✅ Graceful degradation
