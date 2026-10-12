# Testing Pyramid & Strategy

Balanced testing approach for maintainable applications. Covers unit, integration, and E2E tests with practical examples and effort allocation.

## The Testing Pyramid

```
         /\
        /  \  E2E Tests (10%)
       /    \  - Slow, brittle, high confidence
      /------\
     /        \  Integration Tests (30%)
    /          \  - Medium speed, good coverage
   /------------\
  /              \  Unit Tests (60%)
 /________________\  - Fast, focused, easy to maintain

Total: 100% test coverage ≠ 100% code coverage
Goal: Maximum confidence, minimum maintenance
```

## Test Type Definitions

### Unit Tests (60% of suite)
**What**: Single function/method in isolation  
**Mocks**: All external dependencies  
**Speed**: <10ms per test  
**Quantity**: Hundreds to thousands

```typescript
// Example: Pure function
export function calculateDiscount(price: number, percent: number): number {
  if (price < 0 || percent < 0 || percent > 100) {
    throw new Error('Invalid input');
  }
  return price * (percent / 100);
}

// Test
describe('calculateDiscount', () => {
  it('calculates 20% discount correctly', () => {
    expect(calculateDiscount(100, 20)).toBe(20);
  });

  it('throws on negative price', () => {
    expect(() => calculateDiscount(-100, 20)).toThrow('Invalid input');
  });

  it('throws on invalid percent', () => {
    expect(() => calculateDiscount(100, 150)).toThrow('Invalid input');
  });
});
```

### Integration Tests (30% of suite)
**What**: Multiple modules working together  
**Mocks**: External services only (APIs, payment gateways)  
**Speed**: 100ms-1s per test  
**Quantity**: Tens to hundreds

```typescript
// Example: API endpoint + database
describe('POST /api/users', () => {
  beforeEach(async () => {
    await db.user.deleteMany(); // Clean database
  });

  it('creates user with valid input', async () => {
    const res = await request(app)
      .post('/api/users')
      .send({ email: 'test@example.com', name: 'Test' });

    expect(res.status).toBe(201);
    expect(res.body.data.email).toBe('test@example.com');

    // Verify in database
    const user = await db.user.findUnique({ 
      where: { email: 'test@example.com' } 
    });
    expect(user).not.toBeNull();
  });

  it('returns 422 for duplicate email', async () => {
    // Create first user
    await db.user.create({ 
      data: { email: 'test@example.com', name: 'First' } 
    });

    // Try duplicate
    const res = await request(app)
      .post('/api/users')
      .send({ email: 'test@example.com', name: 'Second' });

    expect(res.status).toBe(422);
    expect(res.body.error.code).toBe('VALIDATION_ERROR');
  });
});
```

### E2E Tests (10% of suite)
**What**: Full user flow from UI to database  
**Mocks**: Nothing (real browser, real database)  
**Speed**: 5-30s per test  
**Quantity**: Critical paths only (5-20 tests)

```typescript
// Example: User registration flow (Playwright)
import { test, expect } from '@playwright/test';

test('user can register and login', async ({ page }) => {
  // 1. Visit homepage
  await page.goto('http://localhost:3000');

  // 2. Click sign up
  await page.click('text=Sign Up');

  // 3. Fill form
  await page.fill('input[name="email"]', 'test@example.com');
  await page.fill('input[name="password"]', 'securepass123');
  await page.click('button[type="submit"]');

  // 4. Verify redirect to dashboard
  await expect(page).toHaveURL('/dashboard');
  await expect(page.locator('h1')).toContainText('Welcome');

  // 5. Logout
  await page.click('text=Logout');

  // 6. Login again
  await page.fill('input[name="email"]', 'test@example.com');
  await page.fill('input[name="password"]', 'securepass123');
  await page.click('button[type="submit"]');

  // 7. Verify still works
  await expect(page).toHaveURL('/dashboard');
});
```

---

## Test Coverage Guidelines

### What to Test (Always)

#### 1. Business Logic
```typescript
✅ Tax calculation algorithms
✅ Discount rules
✅ Permission checks
✅ State machines (order status transitions)
✅ Data transformations
```

#### 2. Edge Cases
```typescript
✅ Empty arrays/strings
✅ Null/undefined inputs
✅ Boundary values (0, -1, MAX_INT)
✅ Concurrent operations (race conditions)
✅ Network failures (timeouts, 500 errors)
```

#### 3. Error Paths
```typescript
✅ Validation failures
✅ Unauthorized access
✅ Not found resources
✅ Conflict errors (duplicate email)
✅ Rate limit exceeded
```

### What NOT to Test (Skip)

```typescript
❌ Third-party libraries (trust Zod/Prisma/React)
❌ Framework internals (Next.js routing)
❌ Trivial getters/setters
❌ Constants/configuration files
❌ Type definitions (TypeScript checks this)
❌ Auto-generated code (Prisma client)
```

---

## Test Organization

### Arrange-Act-Assert (AAA)
```typescript
describe('UserService', () => {
  it('sends welcome email after registration', async () => {
    // Arrange: Set up test data + mocks
    const emailService = { send: vi.fn() };
    const userService = new UserService(emailService);
    const userData = { email: 'test@example.com', name: 'Test' };

    // Act: Execute the behavior
    await userService.register(userData);

    // Assert: Verify outcome
    expect(emailService.send).toHaveBeenCalledWith({
      to: 'test@example.com',
      subject: 'Welcome!',
      template: 'welcome'
    });
  });
});
```

### Test Naming Convention
```typescript
describe('[Unit/Component/Feature Name]', () => {
  it('[does X] when [condition Y]', () => {
    // ...
  });
});

// Examples
describe('calculateShipping', () => {
  it('returns free shipping when order exceeds $100', () => {});
  it('adds $10 shipping when order is under $100', () => {});
  it('throws when weight exceeds 50kg', () => {});
});
```

---

## Mocking Strategies

### Database (Use Test DB)
```typescript
// vitest.config.ts
export default defineConfig({
  test: {
    setupFiles: ['./tests/setup.ts']
  }
});

// tests/setup.ts
import { beforeEach } from 'vitest';
import { db } from '../src/db';

beforeEach(async () => {
  // Clean database before each test
  await db.user.deleteMany();
  await db.order.deleteMany();
  await db.product.deleteMany();
});
```

### External APIs (Mock at Boundary)
```typescript
// src/services/payment.ts
export class PaymentService {
  constructor(private client: StripeClient) {}

  async charge(amount: number, token: string) {
    return this.client.charges.create({ amount, source: token });
  }
}

// tests/payment.test.ts
const mockStripe = {
  charges: {
    create: vi.fn().mockResolvedValue({ id: 'ch_123', status: 'succeeded' })
  }
};

const service = new PaymentService(mockStripe as any);
await service.charge(1000, 'tok_123');

expect(mockStripe.charges.create).toHaveBeenCalledWith({
  amount: 1000,
  source: 'tok_123'
});
```

### Time (Use Fake Timers)
```typescript
import { vi } from 'vitest';

it('expires coupon after 24 hours', () => {
  const now = new Date('2026-10-04T00:00:00Z');
  vi.setSystemTime(now);

  const coupon = createCoupon({ expiresIn: '24h' });
  expect(coupon.isExpired()).toBe(false);

  // Fast-forward 25 hours
  vi.setSystemTime(new Date('2026-10-05T01:00:00Z'));
  expect(coupon.isExpired()).toBe(true);

  vi.useRealTimers(); // Cleanup
});
```

---

## Testing Frameworks

### Backend (Node.js)

#### Vitest (Recommended)
```typescript
import { describe, it, expect } from 'vitest';

describe('User', () => {
  it('validates email format', () => {
    expect(() => new User({ email: 'invalid' })).toThrow();
  });
});
```

**Pros**: Fast (ESM native), Vite integration, great DX  
**Cons**: Newer (less ecosystem than Jest)

#### Jest (Mature)
```typescript
describe('User', () => {
  test('validates email format', () => {
    expect(() => new User({ email: 'invalid' })).toThrow();
  });
});
```

**Pros**: Large ecosystem, wide adoption  
**Cons**: Slower, CommonJS default

### Frontend (React)

#### React Testing Library
```typescript
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';

it('submits form on button click', async () => {
  const onSubmit = vi.fn();
  render(<LoginForm onSubmit={onSubmit} />);

  await userEvent.type(screen.getByLabelText('Email'), 'test@example.com');
  await userEvent.type(screen.getByLabelText('Password'), '<REPLACE_ME_TEST_PASSWORD>');
  await userEvent.click(screen.getByRole('button', { name: 'Login' }));

  expect(onSubmit).toHaveBeenCalledWith({
    email: 'test@example.com',
    password: '<REPLACE_ME_TEST_PASSWORD>'
  });
});
```

**Philosophy**: Test behavior, not implementation (no shallow rendering)

### E2E

#### Playwright (Recommended)
```typescript
test('completes checkout flow', async ({ page }) => {
  await page.goto('/products');
  await page.click('text=Add to Cart');
  await page.click('text=Checkout');
  await page.fill('input[name="card"]', '4242 4242 4242 4242');
  await page.click('button:has-text("Pay")');
  await expect(page.locator('.success')).toBeVisible();
});
```

**Pros**: Multi-browser, auto-wait, trace viewer  
**Cons**: Heavier than Cypress

#### Cypress
```typescript
cy.visit('/products');
cy.contains('Add to Cart').click();
cy.contains('Checkout').click();
cy.get('input[name="card"]').type('4242424242424242');
cy.contains('Pay').click();
cy.get('.success').should('be.visible');
```

**Pros**: Great DX, time-travel debugging  
**Cons**: Chrome-only (no Safari/Firefox)

---

## CI/CD Integration

### GitHub Actions
```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_PASSWORD: test
        options: >-
          --health-cmd pg_isready
          --health-interval 10s

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 22

      - name: Install dependencies
        run: npm ci

      - name: Run unit tests
        run: npm run test:unit

      - name: Run integration tests
        run: npm run test:integration
        env:
          DATABASE_URL: postgresql://postgres:test@localhost:5432/test

      - name: Run E2E tests
        run: npx playwright test
```

---

## Test Data Factories

```typescript
// tests/factories/user.factory.ts
import { faker } from '@faker-js/faker';

export const userFactory = {
  build: (overrides?: Partial<User>) => ({
    id: faker.string.uuid(),
    email: faker.internet.email(),
    name: faker.person.fullName(),
    createdAt: faker.date.past(),
    ...overrides
  }),

  create: async (overrides?: Partial<User>) => {
    const data = userFactory.build(overrides);
    return db.user.create({ data });
  }
};

// Usage in tests
const user = await userFactory.create({ email: 'specific@example.com' });
```

---

## Performance Testing

### Load Testing (k6)
```javascript
// load-test.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 50 },  // Ramp up to 50 users
    { duration: '1m', target: 50 },   // Stay at 50 users
    { duration: '30s', target: 0 },   // Ramp down
  ],
};

export default function () {
  const res = http.get('http://localhost:3000/api/users');
  check(res, { 'status is 200': (r) => r.status === 200 });
  sleep(1);
}
```

Run: `k6 run load-test.js`

---

## Test Maintenance

### Red-Green-Refactor (TDD)
```
1. Red:    Write failing test
2. Green:  Make it pass (quick & dirty)
3. Refactor: Clean up code + test
```

### Test Code Quality
```typescript
✅ DRY tests (use factories, shared setup)
✅ Descriptive names (no "test1", "test2")
✅ One assertion per test (or related assertions)
✅ Fast (<1s for unit, <10s for integration)
✅ Deterministic (no flaky tests)

❌ Testing implementation details
❌ Snapshot tests for everything
❌ Excessive mocking (makes tests brittle)
❌ Ignoring flaky tests
```

---

## Testing Anti-Patterns

### ❌ Testing Private Methods
```typescript
// Bad
class UserService {
  private validateEmail(email: string) { ... }
}

// Test calling private method directly → brittle
```

**Fix**: Test through public API. If private method is complex, extract to standalone function.

### ❌ 100% Code Coverage Goal
```typescript
// Chasing 100% → testing getters/setters
expect(user.getName()).toBe(user.name);  // Waste of time
```

**Fix**: Aim for 80-90% meaningful coverage.

### ❌ Mocking Everything
```typescript
// Bad: Mocking database in integration test
const mockDB = { findUser: vi.fn().mockResolvedValue(fakeUser) };
```

**Fix**: Use real test database. Only mock external APIs.

---

## Example: Full Test Suite

```typescript
// src/services/order.service.ts
export class OrderService {
  async createOrder(userId: string, items: CartItem[]) {
    const user = await db.user.findUnique({ where: { id: userId } });
    if (!user) throw new NotFoundError('User');

    const total = items.reduce((sum, item) => sum + item.price, 0);
    
    const order = await db.order.create({
      data: {
        userId,
        total,
        items: { create: items }
      }
    });

    await this.emailService.send({
      to: user.email,
      subject: 'Order confirmation',
      template: 'order-confirmation',
      data: { order }
    });

    return order;
  }
}

// tests/unit/order.service.test.ts (Unit)
describe('OrderService', () => {
  it('calculates total correctly', async () => {
    const mockDB = { 
      user: { findUnique: vi.fn().mockResolvedValue({ id: '1', email: 'test@example.com' }) },
      order: { create: vi.fn().mockResolvedValue({ id: '1', total: 150 }) }
    };
    const mockEmail = { send: vi.fn() };
    
    const service = new OrderService(mockDB, mockEmail);
    const order = await service.createOrder('1', [
      { price: 100 }, 
      { price: 50 }
    ]);

    expect(order.total).toBe(150);
  });
});

// tests/integration/order.api.test.ts (Integration)
describe('POST /api/orders', () => {
  it('creates order and sends email', async () => {
    const user = await db.user.create({ 
      data: { email: 'test@example.com', name: 'Test' } 
    });

    const res = await request(app)
      .post('/api/orders')
      .set('Authorization', `Bearer ${user.token}`)
      .send({ items: [{ productId: '1', quantity: 2 }] });

    expect(res.status).toBe(201);
    expect(res.body.data.total).toBeGreaterThan(0);

    // Verify in database
    const order = await db.order.findFirst({ 
      where: { userId: user.id } 
    });
    expect(order).not.toBeNull();
  });
});

// tests/e2e/checkout.spec.ts (E2E)
test('user can complete checkout', async ({ page }) => {
  await page.goto('/products');
  await page.click('text=Add to Cart');
  await page.click('text=Checkout');
  await page.fill('input[name="card"]', '4242424242424242');
  await page.click('button:has-text("Pay")');
  await expect(page.locator('.success')).toContainText('Order confirmed');
});
```

---

## Quick Reference

| Test Type | Speed | Mocks | Coverage | Quantity |
|-----------|-------|-------|----------|----------|
| Unit | <10ms | All deps | 60% | Hundreds |
| Integration | 100ms-1s | External only | 30% | Tens |
| E2E | 5-30s | Nothing | 10% | 5-20 |

**Golden Rule**: Write tests that give maximum confidence with minimum maintenance.
