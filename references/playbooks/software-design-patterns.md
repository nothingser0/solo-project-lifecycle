
# Module 05C: Software Design Patterns & Clean Code Principles

**Trigger**: Use when evaluating the quality of AI-generated code, performing code reviews, refactoring, or designing component architecture. Required for medium-to-large projects requiring long-term maintainability.

**Objective**: Equip solo developers with fundamental knowledge of design patterns, clean code principles, and the ability to detect anti-patterns in AI-generated code (ChatGPT, GitHub Copilot, Claude, etc.).

---

## 1. Clean Code Principles

### 1.1 Naming Conventions

**Meaningful Names**:
```typescript
// BAD: Abbreviations and cryptic names
const d = new Date(); // What does 'd' represent?
const yyyymmdd = getDate(); // Type encoding in name
function get(x: any) { } // Too generic

// GOOD: Intention-revealing names
const orderCreatedAt = new Date();
const formattedDate = getDate();
function getActiveUsersByRole(role: string) { }
```

**Searchable Names**:
```typescript
// BAD: Magic numbers
setTimeout(callback, 86400000); // What is 86400000?

// GOOD: Named constants
const MILLISECONDS_PER_DAY = 86_400_000;
setTimeout(callback, MILLISECONDS_PER_DAY);
```

**Pronounceable Names**:
```php
// BAD: Unpronounceable
$dtaRcrd102 = ['genymdhms' => date('Y-m-d H:i:s')];

// GOOD: Pronounceable
$customer = ['createdAt' => date('Y-m-d H:i:s')];
```

### 1.2 Function Size & Complexity

**Single Responsibility Principle**:
```python
# BAD: Function doing multiple things
def process_order(order):
    validate_items(order.items)
    calculate_total(order)
    charge_payment(order.payment)
    send_confirmation_email(order.email)
    update_inventory(order.items)
    log_analytics(order)

# GOOD: Each function has one reason to change
def process_order(order):
    validate_order(order)
    payment = process_payment(order)
    fulfill_order(order, payment)
    notify_customer(order)
```

**Cyclomatic Complexity Target: < 10**:
```typescript
// BAD: Cyclomatic complexity = 12
function calculateDiscount(user: User, cart: Cart): number {
  if (user.isPremium) {
    if (cart.total > 1000) {
      if (user.loyaltyPoints > 500) {
        return 0.3;
      } else if (user.loyaltyPoints > 200) {
        return 0.2;
      } else {
        return 0.15;
      }
    } else if (cart.total > 500) {
      return 0.1;
    }
  } else {
    if (cart.total > 1000) {
      return 0.05;
    }
  }
  return 0;
}

// GOOD: Strategy pattern, complexity = 4 per function
const DISCOUNT_RULES = {
  premium: [
    { minTotal: 1000, minPoints: 500, discount: 0.3 },
    { minTotal: 1000, minPoints: 200, discount: 0.2 },
    { minTotal: 1000, minPoints: 0, discount: 0.15 },
    { minTotal: 500, minPoints: 0, discount: 0.1 },
  ],
  regular: [
    { minTotal: 1000, minPoints: 0, discount: 0.05 },
  ],
};

function calculateDiscount(user: User, cart: Cart): number {
  const rules = DISCOUNT_RULES[user.tier] || [];
  const applicableRule = rules.find(
    (r) => cart.total >= r.minTotal && user.loyaltyPoints >= r.minPoints
  );
  return applicableRule?.discount ?? 0;
}
```

**Function Length: < 20 Lines**:
```typescript
// BAD: 50-line function
function createInvoice(order) {
  // ... 10 lines validation
  // ... 15 lines calculation
  // ... 10 lines formatting
  // ... 15 lines database insert
}

// GOOD: Extracted functions
function createInvoice(order: Order): Invoice {
  const validatedOrder = validateOrder(order);
  const totals = calculateInvoiceTotals(validatedOrder);
  const formattedInvoice = formatInvoice(validatedOrder, totals);
  return saveInvoice(formattedInvoice);
}
```

### 1.3 Comments: The Why, Not The What

```typescript
// BAD: Redundant comments
// Set the value of i to 0
let i = 0;

// Loop through all users
for (const user of users) {
  // If user is active
  if (user.isActive) {
    // Send email
    sendEmail(user.email);
  }
}

// GOOD: Comments explain WHY
// Retry 3 times because payment gateway has transient network issues
// ponytail: upgrade to exponential backoff when error rate > 1%
const MAX_RETRIES = 3;

// Validate email domain against corporate whitelist per GDPR Art. 32
// (clients require data residency proof)
if (!isWhitelistedDomain(email)) {
  throw new UnauthorizedDomainError(email);
}
```

### 1.4 Error Handling

**Explicit Exceptions**:
```python
# BAD: Silent failures
def get_user(user_id):
    try:
        return db.query("SELECT * FROM users WHERE id = ?", user_id)
    except:
        return None  # Swallowed exception!

# GOOD: Explicit error propagation
def get_user(user_id: int) -> User:
    try:
        result = db.query("SELECT * FROM users WHERE id = ?", user_id)
        if not result:
            raise UserNotFoundError(f"User {user_id} not found")
        return User.from_row(result)
    except DatabaseError as e:
        logger.error(f"DB error fetching user {user_id}: {e}")
        raise UserServiceError("Unable to fetch user") from e
```

**Meaningful Error Messages**:
```typescript
// BAD: Vague errors
throw new Error("Invalid input");

// GOOD: Actionable error messages
throw new ValidationError(
  `Email '${email}' is invalid. Expected format: user@domain.com`
);

throw new BusinessRuleViolation(
  `Cannot delete order ${orderId}: status is 'shipped'. ` +
  `Only 'draft' or 'cancelled' orders can be deleted.`
);
```

### 1.5 DRY vs WET (Write Everything Twice)

**Rule of Three**: Abstract after third duplication, not first.

```typescript
// ITERATION 1: Write inline
function processUserSignup(data) {
  const email = data.email.toLowerCase().trim();
  await createUser(email);
}

// ITERATION 2: Duplicate (WET is OK at this stage)
function processAdminInvite(data) {
  const email = data.email.toLowerCase().trim();
  await createAdmin(email);
}

// ITERATION 3: Third duplication triggers abstraction (DRY)
function processSupportSignup(data) {
  const email = data.email.toLowerCase().trim();
  await createSupportAgent(email);
}

// REFACTOR: Now abstract
function normalizeEmail(email: string): string {
  return email.toLowerCase().trim();
}
```

### 1.6 Code Smells Checklist

**Detection Checklist**:
- [ ] **Long Method**: Function > 20 lines → Extract smaller functions
- [ ] **Large Class**: Class > 300 lines → Split by responsibility
- [ ] **Primitive Obsession**: Passing `string userId` everywhere → Create `UserId` value object
- [ ] **Shotgun Surgery**: One change requires editing 10 files → Poor cohesion
- [ ] **Feature Envy**: Method uses data from another class more than its own → Move method
- [ ] **Data Clumps**: Same 3-4 parameters always passed together → Create parameter object
- [ ] **Divergent Change**: Class changes for multiple unrelated reasons → Violates SRP

---

## 2. Programming Paradigms

### 2.1 Paradigm Comparison

| Paradigm | Best For | Example Languages | Core Concept |
|----------|----------|-------------------|--------------|
| **Procedural** | Scripts, ETL pipelines, CLI tools | Python, PHP, Go | Sequential steps, state in variables |
| **Object-Oriented** | Stateful entities, domain models | Java, C#, TypeScript | Encapsulation, inheritance, polymorphism |
| **Functional** | Data transformation, immutability | Haskell, Elixir, Clojure | Pure functions, no side effects |

### 2.2 When To Use Each

**Procedural** (data transformation scripts):
```python
# Good for: ETL, data migration, one-off admin scripts
def migrate_users():
    rows = fetch_csv('users.csv')
    for row in rows:
        validated = validate_row(row)
        insert_to_db(validated)
```

**Object-Oriented** (stateful domain logic):
```typescript
// Good for: Shopping cart, order management, user accounts
class ShoppingCart {
  private items: CartItem[] = [];

  addItem(product: Product, quantity: number): void {
    const existing = this.items.find(i => i.productId === product.id);
    if (existing) {
      existing.quantity += quantity;
    } else {
      this.items.push({ productId: product.id, quantity });
    }
  }

  getTotal(): number {
    return this.items.reduce((sum, item) => sum + item.price * item.quantity, 0);
  }
}
```

**Functional** (data pipelines):
```typescript
// Good for: API response transformation, filtering, aggregation
const activeUsers = users
  .filter(u => u.status === 'active')
  .map(u => ({ id: u.id, name: u.name }))
  .sort((a, b) => a.name.localeCompare(b.name));
```

### 2.3 Multi-Paradigm Strategy: Functional Core, Imperative Shell

```typescript
// SHELL (imperative, handles I/O)
async function createOrderHandler(req: Request): Promise<Response> {
  const input = await req.json();
  const user = await db.users.findById(input.userId); // Side effect
  
  // CORE (functional, pure logic)
  const orderData = calculateOrder(user, input.items);
  
  // SHELL (imperative, handles I/O)
  const order = await db.orders.insert(orderData); // Side effect
  return Response.json(order);
}

// CORE: Pure function, easy to test
function calculateOrder(user: User, items: CartItem[]): OrderData {
  const subtotal = items.reduce((sum, item) => sum + item.price, 0);
  const discount = calculateDiscount(user, subtotal);
  const tax = (subtotal - discount) * 0.1;
  return { subtotal, discount, tax, total: subtotal - discount + tax };
}
```

---

## 3. Object-Oriented Programming: SOLID Principles

### 3.1 Single Responsibility Principle (SRP)

**Rule**: A class should have one, and only one, reason to change.

```typescript
// BAD: UserService does too much
class UserService {
  createUser(data: UserInput) { }
  sendWelcomeEmail(user: User) { }
  logUserActivity(user: User) { }
  generateUserReport(userId: string) { }
}

// GOOD: Separated by responsibility
class UserRepository {
  create(data: UserInput): User { }
  findById(id: string): User | null { }
}

class EmailService {
  sendWelcome(user: User): void { }
}

class UserActivityLogger {
  log(user: User, action: string): void { }
}

class UserReportGenerator {
  generate(userId: string): Report { }
}
```

### 3.2 Open/Closed Principle (OCP)

**Rule**: Open for extension, closed for modification.

```typescript
// BAD: Must modify class to add new discount type
class DiscountCalculator {
  calculate(type: string, amount: number): number {
    if (type === 'percentage') {
      return amount * 0.1;
    } else if (type === 'fixed') {
      return 10;
    } else if (type === 'tiered') {
      return amount > 100 ? 20 : 10;
    }
    // Adding new type requires modifying this method!
  }
}

// GOOD: Extend via new classes
interface DiscountStrategy {
  calculate(amount: number): number;
}

class PercentageDiscount implements DiscountStrategy {
  constructor(private rate: number) {}
  calculate(amount: number): number {
    return amount * this.rate;
  }
}

class FixedDiscount implements DiscountStrategy {
  constructor(private amount: number) {}
  calculate(amount: number): number {
    return this.amount;
  }
}

class TieredDiscount implements DiscountStrategy {
  calculate(amount: number): number {
    return amount > 100 ? 20 : 10;
  }
}

// Usage
const discount: DiscountStrategy = new PercentageDiscount(0.1);
const discountAmount = discount.calculate(totalAmount);
```

### 3.3 Liskov Substitution Principle (LSP)

**Rule**: Subtypes must be substitutable for their base types.

```python
# BAD: Violates LSP (Rectangle-Square problem)
class Rectangle:
    def __init__(self, width, height):
        self.width = width
        self.height = height
    
    def set_width(self, width):
        self.width = width
    
    def set_height(self, height):
        self.height = height
    
    def area(self):
        return self.width * self.height

class Square(Rectangle):
    def set_width(self, width):
        self.width = width
        self.height = width  # Breaks LSP: unexpected side effect
    
    def set_height(self, height):
        self.width = height
        self.height = height

# This breaks:
def test_rectangle(rect: Rectangle):
    rect.set_width(5)
    rect.set_height(4)
    assert rect.area() == 20  # Fails for Square!

# GOOD: Separate hierarchies
from abc import ABC, abstractmethod

class Shape(ABC):
    @abstractmethod
    def area(self) -> float:
        pass

class Rectangle(Shape):
    def __init__(self, width: float, height: float):
        self._width = width
        self._height = height
    
    def area(self) -> float:
        return self._width * self._height

class Square(Shape):
    def __init__(self, side: float):
        self._side = side
    
    def area(self) -> float:
        return self._side ** 2
```

### 3.4 Interface Segregation Principle (ISP)

**Rule**: Many specific interfaces > one general interface.

```typescript
// BAD: Fat interface
interface Worker {
  code(): void;
  design(): void;
  test(): void;
  deploy(): void;
  managePeople(): void;
}

class Developer implements Worker {
  code() { /* ok */ }
  design() { /* ok */ }
  test() { /* ok */ }
  deploy() { /* ok */ }
  managePeople() { throw new Error("Developer doesn't manage people!"); }
}

// GOOD: Segregated interfaces
interface Coder {
  code(): void;
}

interface Designer {
  design(): void;
}

interface Tester {
  test(): void;
}

interface Manager {
  managePeople(): void;
}

class Developer implements Coder, Designer, Tester {
  code() { }
  design() { }
  test() { }
}

class TechLead implements Coder, Manager {
  code() { }
  managePeople() { }
}
```

### 3.5 Dependency Inversion Principle (DIP)

**Rule**: Depend on abstractions, not concretions.

```php
// BAD: High-level module depends on low-level module
class MySQLDatabase {
    public function query(string $sql): array {
        // MySQL-specific implementation
    }
}

class UserService {
    private MySQLDatabase $db;
    
    public function __construct() {
        $this->db = new MySQLDatabase(); // Tight coupling!
    }
    
    public function getUser(int $id): User {
        return $this->db->query("SELECT * FROM users WHERE id = $id");
    }
}

// GOOD: Depend on abstraction
interface Database {
    public function query(string $sql): array;
}

class MySQLDatabase implements Database {
    public function query(string $sql): array {
        // MySQL implementation
    }
}

class PostgreSQLDatabase implements Database {
    public function query(string $sql): array {
        // PostgreSQL implementation
    }
}

class UserService {
    private Database $db;
    
    public function __construct(Database $db) {
        $this->db = $db; // Injected dependency
    }
    
    public function getUser(int $id): User {
        return $this->db->query("SELECT * FROM users WHERE id = $id");
    }
}

// Usage
$db = new PostgreSQLDatabase();
$userService = new UserService($db); // Easy to swap implementations
```


### 3.6 Composition vs Inheritance

**Rule**: Favor composition over inheritance.

```typescript
// BAD: Inheritance hierarchy
class Animal {
  move() { console.log("Moving..."); }
}

class FlyingAnimal extends Animal {
  fly() { console.log("Flying..."); }
}

class SwimmingAnimal extends Animal {
  swim() { console.log("Swimming..."); }
}

// Problem: What about a duck that flies AND swims?
// Multiple inheritance not allowed in most languages!

// GOOD: Composition
interface Movable {
  move(): void;
}

class Walker implements Movable {
  move() { console.log("Walking..."); }
}

class Flyer implements Movable {
  move() { console.log("Flying..."); }
}

class Swimmer implements Movable {
  move() { console.log("Swimming..."); }
}

class Duck {
  constructor(
    private flyer: Flyer,
    private swimmer: Swimmer
  ) {}
  
  fly() { this.flyer.move(); }
  swim() { this.swimmer.move(); }
}

const duck = new Duck(new Flyer(), new Swimmer());
duck.fly();  // Flying...
duck.swim(); // Swimming...
```

---

## 4. Design Principles

### 4.1 KISS (Keep It Simple, Stupid)

```python
# BAD: Over-engineered
class AbstractFactoryBuilderSingletonProxy:
    _instance = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance
    
    def create_factory(self):
        return ConcreteFactoryBuilder().build()

# GOOD: Simple
def get_user(user_id: int) -> User:
    return db.query("SELECT * FROM users WHERE id = ?", user_id)
```

### 4.2 YAGNI (You Aren't Gonna Need It)

```typescript
// BAD: Adding features "for later"
interface User {
  id: string;
  email: string;
  name: string;
  
  // Future features nobody asked for:
  avatarUrl?: string;
  bio?: string;
  socialLinks?: Record<string, string>;
  preferences?: UserPreferences;
  customFields?: Record<string, any>;
}

// GOOD: Only what's needed now
interface User {
  id: string;
  email: string;
  name: string;
}
// ponytail: add avatar when profile feature ships (M06 sprint 3)
```

### 4.3 Separation of Concerns

```typescript
// BAD: Mixed concerns
async function handleCheckout(req: Request) {
  // Validation
  if (!req.body.email) throw new Error("Email required");
  
  // Business logic
  const cart = await getCart(req.body.cartId);
  const total = cart.items.reduce((sum, i) => sum + i.price, 0);
  
  // External service call
  const payment = await stripe.charges.create({ amount: total });
  
  // Database
  await db.orders.insert({ userId: req.body.userId, total });
  
  // Email
  await sendEmail(req.body.email, "Order confirmed");
  
  // Response
  return { success: true };
}

// GOOD: Separated concerns
async function handleCheckout(req: Request) {
  const input = validateCheckoutInput(req.body);
  const order = await checkoutService.process(input);
  return formatCheckoutResponse(order);
}

class CheckoutService {
  async process(input: CheckoutInput): Promise<Order> {
    const cart = await this.cartRepo.findById(input.cartId);
    const payment = await this.paymentService.charge(cart.total);
    const order = await this.orderRepo.create(cart, payment);
    await this.notificationService.sendOrderConfirmation(order);
    return order;
  }
}
```

### 4.4 Law of Demeter (Don't Talk to Strangers)

```typescript
// BAD: Violates Law of Demeter (too many dots)
class Order {
  getCustomerStreet(): string {
    return this.customer.address.street; // Knows too much about customer internals
  }
}

// GOOD: Tell, don't ask
class Order {
  getDeliveryAddress(): string {
    return this.customer.getShippingAddress(); // Delegate to customer
  }
}

class Customer {
  getShippingAddress(): string {
    return this.address.formatForShipping(); // Encapsulated
  }
}
```

### 4.5 Dependency Injection Patterns

**Constructor Injection** (preferred):
```typescript
class UserService {
  constructor(
    private userRepo: UserRepository,
    private emailService: EmailService
  ) {}
  
  async register(email: string): Promise<User> {
    const user = await this.userRepo.create(email);
    await this.emailService.sendWelcome(user);
    return user;
  }
}

// Usage
const userService = new UserService(
  new UserRepository(),
  new EmailService()
);
```

**Setter Injection** (optional dependencies):
```php
class ReportGenerator {
    private $formatter;
    
    public function setFormatter(FormatterInterface $formatter): void {
        $this->formatter = $formatter;
    }
    
    public function generate(): string {
        $data = $this->fetchData();
        return $this->formatter ? $this->formatter->format($data) : $data;
    }
}
```

**Interface Injection** (frameworks):
```typescript
// Next.js API route with dependency injection
export async function POST(req: Request, context: { db: Database }) {
  const user = await context.db.users.create(await req.json());
  return Response.json(user);
}
```

### 4.6 Inversion of Control (IoC)

```typescript
// BAD: Manual control flow
class Application {
  start() {
    const db = new Database();
    const userRepo = new UserRepository(db);
    const emailService = new EmailService();
    const userService = new UserService(userRepo, emailService);
    
    // ... repeat for 50 services
  }
}

// GOOD: IoC Container
class Container {
  private services = new Map();
  
  register<T>(key: string, factory: () => T): void {
    this.services.set(key, factory);
  }
  
  resolve<T>(key: string): T {
    const factory = this.services.get(key);
    return factory();
  }
}

// Setup
const container = new Container();
container.register('db', () => new Database());
container.register('userRepo', () => new UserRepository(container.resolve('db')));
container.register('userService', () => new UserService(
  container.resolve('userRepo'),
  container.resolve('emailService')
));

// Usage
const userService = container.resolve<UserService>('userService');
```

---

## 5. Design Patterns (Gang of Four + Modern)

### 5.1 Creational Patterns

#### Factory Method

**Intent**: Define interface for creating object, let subclasses decide which class to instantiate.

```typescript
// Use case: Payment processing with multiple gateways
interface PaymentGateway {
  charge(amount: number): Promise<PaymentResult>;
}

class StripeGateway implements PaymentGateway {
  async charge(amount: number): Promise<PaymentResult> {
    // Stripe-specific implementation
    return { success: true, transactionId: 'stripe_123' };
  }
}

class PayPalGateway implements PaymentGateway {
  async charge(amount: number): Promise<PaymentResult> {
    // PayPal-specific implementation
    return { success: true, transactionId: 'paypal_456' };
  }
}

// Factory
class PaymentGatewayFactory {
  static create(type: 'stripe' | 'paypal'): PaymentGateway {
    switch (type) {
      case 'stripe': return new StripeGateway();
      case 'paypal': return new PayPalGateway();
      default: throw new Error(`Unknown gateway: ${type}`);
    }
  }
}

// Usage
const gateway = PaymentGatewayFactory.create('stripe');
await gateway.charge(1000);
```

#### Abstract Factory

**Intent**: Create families of related objects without specifying concrete classes.

```python
# Use case: UI components for different themes
from abc import ABC, abstractmethod

class Button(ABC):
    @abstractmethod
    def render(self) -> str:
        pass

class DarkButton(Button):
    def render(self) -> str:
        return '<button class="dark">Click</button>'

class LightButton(Button):
    def render(self) -> str:
        return '<button class="light">Click</button>'

class Input(ABC):
    @abstractmethod
    def render(self) -> str:
        pass

class DarkInput(Input):
    def render(self) -> str:
        return '<input class="dark" />'

class LightInput(Input):
    def render(self) -> str:
        return '<input class="light" />'

# Abstract Factory
class ThemeFactory(ABC):
    @abstractmethod
    def create_button(self) -> Button:
        pass
    
    @abstractmethod
    def create_input(self) -> Input:
        pass

class DarkThemeFactory(ThemeFactory):
    def create_button(self) -> Button:
        return DarkButton()
    
    def create_input(self) -> Input:
        return DarkInput()

class LightThemeFactory(ThemeFactory):
    def create_button(self) -> Button:
        return LightButton()
    
    def create_input(self) -> Input:
        return LightInput()

# Usage
factory: ThemeFactory = DarkThemeFactory()
button = factory.create_button()
input_field = factory.create_input()
```

#### Builder

**Intent**: Separate construction of complex object from representation.

```typescript
// Use case: Building complex query objects
class QueryBuilder {
  private table: string = '';
  private selectFields: string[] = ['*'];
  private whereConditions: string[] = [];
  private orderByField: string = '';
  private limitValue: number = 0;
  
  from(table: string): this {
    this.table = table;
    return this;
  }
  
  select(...fields: string[]): this {
    this.selectFields = fields;
    return this;
  }
  
  where(condition: string): this {
    this.whereConditions.push(condition);
    return this;
  }
  
  orderBy(field: string): this {
    this.orderByField = field;
    return this;
  }
  
  limit(value: number): this {
    this.limitValue = value;
    return this;
  }
  
  build(): string {
    let sql = `SELECT ${this.selectFields.join(', ')} FROM ${this.table}`;
    
    if (this.whereConditions.length > 0) {
      sql += ` WHERE ${this.whereConditions.join(' AND ')}`;
    }
    
    if (this.orderByField) {
      sql += ` ORDER BY ${this.orderByField}`;
    }
    
    if (this.limitValue > 0) {
      sql += ` LIMIT ${this.limitValue}`;
    }
    
    return sql;
  }
}

// Usage
const query = new QueryBuilder()
  .from('users')
  .select('id', 'email', 'name')
  .where('status = "active"')
  .where('age > 18')
  .orderBy('created_at DESC')
  .limit(10)
  .build();

// Output: SELECT id, email, name FROM users WHERE status = "active" AND age > 18 ORDER BY created_at DESC LIMIT 10
```

#### Singleton

**Intent**: Ensure class has only one instance.

**⚠️ Warning**: Modern anti-pattern unless justified (database connection pool, logger).

```typescript
// Use case: Database connection pool
class DatabasePool {
  private static instance: DatabasePool;
  private connections: Connection[] = [];
  
  private constructor() {
    // Initialize pool
    for (let i = 0; i < 10; i++) {
      this.connections.push(new Connection());
    }
  }
  
  static getInstance(): DatabasePool {
    if (!DatabasePool.instance) {
      DatabasePool.instance = new DatabasePool();
    }
    return DatabasePool.instance;
  }
  
  getConnection(): Connection {
    return this.connections.pop() || new Connection();
  }
  
  releaseConnection(conn: Connection): void {
    this.connections.push(conn);
  }
}

// Usage
const pool = DatabasePool.getInstance();
const conn = pool.getConnection();
// ... use connection
pool.releaseConnection(conn);
```

**Better Alternative**: Dependency injection without singleton.

```typescript
// Inject single instance via DI container
const dbPool = new DatabasePool();

// All services receive same instance
const userService = new UserService(dbPool);
const orderService = new OrderService(dbPool);
```

#### Prototype

**Intent**: Clone objects instead of creating from scratch.

```javascript
// Use case: Cloning complex configuration objects
class ServerConfig {
  constructor(public host, public port, public ssl, public timeout) {}
  
  clone() {
    return new ServerConfig(this.host, this.port, this.ssl, this.timeout);
  }
}

// Base configuration
const prodConfig = new ServerConfig('prod.example.com', 443, true, 30000);

// Clone for staging (modify specific fields)
const stagingConfig = prodConfig.clone();
stagingConfig.host = 'staging.example.com';
stagingConfig.ssl = false;
```

### 5.2 Structural Patterns

#### Adapter

**Intent**: Convert interface of a class into another interface clients expect.

```php
// Use case: Adapting third-party API to internal interface
interface PaymentProcessor {
    public function processPayment(int $amount): bool;
}

// Third-party library with different interface
class StripeAPI {
    public function charge(array $params): object {
        // Stripe-specific implementation
        return (object)['status' => 'success', 'id' => 'ch_123'];
    }
}

// Adapter
class StripeAdapter implements PaymentProcessor {
    private StripeAPI $stripe;
    
    public function __construct(StripeAPI $stripe) {
        $this->stripe = $stripe;
    }
    
    public function processPayment(int $amount): bool {
        $result = $this->stripe->charge([
            'amount' => $amount,
            'currency' => 'usd',
        ]);
        return $result->status === 'success';
    }
}

// Usage
$processor = new StripeAdapter(new StripeAPI());
$success = $processor->processPayment(1000); // Unified interface
```

#### Decorator

**Intent**: Add behavior to objects dynamically without affecting other objects.

```typescript
// Use case: Adding logging, caching, validation layers
interface DataSource {
  read(): string;
  write(data: string): void;
}

class FileDataSource implements DataSource {
  constructor(private filename: string) {}
  
  read(): string {
    return fs.readFileSync(this.filename, 'utf8');
  }
  
  write(data: string): void {
    fs.writeFileSync(this.filename, data);
  }
}

// Decorator: Add encryption
class EncryptionDecorator implements DataSource {
  constructor(private wrapped: DataSource) {}
  
  read(): string {
    const data = this.wrapped.read();
    return this.decrypt(data);
  }
  
  write(data: string): void {
    const encrypted = this.encrypt(data);
    this.wrapped.write(encrypted);
  }
  
  private encrypt(data: string): string {
    return Buffer.from(data).toString('base64');
  }
  
  private decrypt(data: string): string {
    return Buffer.from(data, 'base64').toString('utf8');
  }
}

// Decorator: Add logging
class LoggingDecorator implements DataSource {
  constructor(private wrapped: DataSource) {}
  
  read(): string {
    console.log('[READ] Starting...');
    const data = this.wrapped.read();
    console.log(`[READ] Completed (${data.length} bytes)`);
    return data;
  }
  
  write(data: string): void {
    console.log(`[WRITE] Starting (${data.length} bytes)...`);
    this.wrapped.write(data);
    console.log('[WRITE] Completed');
  }
}

// Usage: Stack decorators
let dataSource: DataSource = new FileDataSource('data.txt');
dataSource = new EncryptionDecorator(dataSource);
dataSource = new LoggingDecorator(dataSource);

dataSource.write('Hello World'); // Logs, encrypts, writes
const data = dataSource.read();   // Reads, decrypts, logs
```


#### Facade

**Intent**: Provide simplified interface to complex subsystem.

```python
# Use case: Simplifying complex video conversion library
class VideoFile:
    def __init__(self, filename: str):
        self.filename = filename

class AudioMixer:
    def fix(self, audio): pass

class BitrateReader:
    def read(self, file, codec): pass
    def convert(self, buffer, codec): pass

class VideoConverter:
    def convert(self, file, format): pass

# Complex subsystem with many classes
class CodecFactory:
    @staticmethod
    def extract(file): pass

# Facade: Simple interface
class VideoConversionFacade:
    def convert_video(self, filename: str, format: str) -> str:
        # Hide complexity from client
        file = VideoFile(filename)
        source_codec = CodecFactory.extract(file)
        
        if format == "mp4":
            destination_codec = "MPEG4Codec"
        else:
            destination_codec = "OggCodec"
        
        buffer = BitrateReader().read(file, source_codec)
        result = BitrateReader().convert(buffer, destination_codec)
        result = AudioMixer().fix(result)
        
        output_file = VideoConverter().convert(result, format)
        return output_file

# Usage: Simple
converter = VideoConversionFacade()
output = converter.convert_video("input.avi", "mp4")
```

#### Proxy

**Intent**: Provide placeholder for another object to control access.

```typescript
// Use case: Lazy loading expensive objects
interface Image {
  display(): void;
}

class RealImage implements Image {
  private filename: string;
  
  constructor(filename: string) {
    this.filename = filename;
    this.loadFromDisk();
  }
  
  private loadFromDisk(): void {
    console.log(`Loading ${this.filename} from disk...`); // Expensive!
  }
  
  display(): void {
    console.log(`Displaying ${this.filename}`);
  }
}

// Proxy: Delays loading until actually needed
class ImageProxy implements Image {
  private realImage: RealImage | null = null;
  private filename: string;
  
  constructor(filename: string) {
    this.filename = filename;
  }
  
  display(): void {
    if (!this.realImage) {
      this.realImage = new RealImage(this.filename); // Load on first access
    }
    this.realImage.display();
  }
}

// Usage
const images = [
  new ImageProxy("photo1.jpg"),
  new ImageProxy("photo2.jpg"),
  new ImageProxy("photo3.jpg"),
];

// Images not loaded yet!
images[0].display(); // Now loads and displays photo1.jpg
images[0].display(); // Reuses cached instance
```

#### Composite

**Intent**: Compose objects into tree structures to represent hierarchies.

```typescript
// Use case: File system structure
interface FileSystemItem {
  getName(): string;
  getSize(): number;
}

class File implements FileSystemItem {
  constructor(private name: string, private size: number) {}
  
  getName(): string {
    return this.name;
  }
  
  getSize(): number {
    return this.size;
  }
}

class Directory implements FileSystemItem {
  private children: FileSystemItem[] = [];
  
  constructor(private name: string) {}
  
  add(item: FileSystemItem): void {
    this.children.push(item);
  }
  
  getName(): string {
    return this.name;
  }
  
  getSize(): number {
    return this.children.reduce((sum, child) => sum + child.getSize(), 0);
  }
}

// Usage
const root = new Directory("root");
const home = new Directory("home");
const user = new Directory("user");

user.add(new File("document.txt", 100));
user.add(new File("photo.jpg", 2000));

home.add(user);
root.add(home);
root.add(new File("system.log", 500));

console.log(root.getSize()); // 2600 (sum of all files recursively)
```

### 5.3 Behavioral Patterns

#### Observer (Pub/Sub)

**Intent**: Define one-to-many dependency so when one object changes state, dependents are notified.

```typescript
// Use case: Event listeners, real-time notifications
interface Observer {
  update(event: string, data: any): void;
}

class Subject {
  private observers: Observer[] = [];
  
  attach(observer: Observer): void {
    this.observers.push(observer);
  }
  
  detach(observer: Observer): void {
    const index = this.observers.indexOf(observer);
    if (index > -1) this.observers.splice(index, 1);
  }
  
  notify(event: string, data: any): void {
    for (const observer of this.observers) {
      observer.update(event, data);
    }
  }
}

class Order extends Subject {
  placeOrder(items: any[]): void {
    // Business logic
    console.log("Order placed");
    
    // Notify all observers
    this.notify("order.placed", { items });
  }
}

class EmailNotifier implements Observer {
  update(event: string, data: any): void {
    if (event === "order.placed") {
      console.log(`Sending email about order: ${JSON.stringify(data)}`);
    }
  }
}

class InventoryUpdater implements Observer {
  update(event: string, data: any): void {
    if (event === "order.placed") {
      console.log(`Updating inventory for: ${data.items.length} items`);
    }
  }
}

// Usage
const order = new Order();
order.attach(new EmailNotifier());
order.attach(new InventoryUpdater());
order.placeOrder([{ id: 1, qty: 2 }]); // Both observers notified
```

#### Strategy

**Intent**: Define family of algorithms, encapsulate each, make them interchangeable.

```python
# Use case: Different sorting algorithms, payment methods, shipping methods
from abc import ABC, abstractmethod

class ShippingStrategy(ABC):
    @abstractmethod
    def calculate_cost(self, weight: float, distance: float) -> float:
        pass

class StandardShipping(ShippingStrategy):
    def calculate_cost(self, weight: float, distance: float) -> float:
        return weight * 0.5 + distance * 0.1

class ExpressShipping(ShippingStrategy):
    def calculate_cost(self, weight: float, distance: float) -> float:
        return weight * 1.0 + distance * 0.3

class OvernightShipping(ShippingStrategy):
    def calculate_cost(self, weight: float, distance: float) -> float:
        return weight * 2.0 + distance * 0.5 + 10.0  # Flat fee

class ShippingCalculator:
    def __init__(self, strategy: ShippingStrategy):
        self.strategy = strategy
    
    def set_strategy(self, strategy: ShippingStrategy):
        self.strategy = strategy
    
    def calculate(self, weight: float, distance: float) -> float:
        return self.strategy.calculate_cost(weight, distance)

# Usage
calculator = ShippingCalculator(StandardShipping())
print(calculator.calculate(10, 100))  # Standard: 15.0

calculator.set_strategy(ExpressShipping())
print(calculator.calculate(10, 100))  # Express: 40.0

calculator.set_strategy(OvernightShipping())
print(calculator.calculate(10, 100))  # Overnight: 80.0
```

#### Command

**Intent**: Encapsulate request as object, allowing parameterization and queuing.

```typescript
// Use case: Undo/redo, transaction queue, job scheduler
interface Command {
  execute(): void;
  undo(): void;
}

class Document {
  private content: string = "";
  
  write(text: string): void {
    this.content += text;
  }
  
  erase(length: number): void {
    this.content = this.content.slice(0, -length);
  }
  
  getContent(): string {
    return this.content;
  }
}

class WriteCommand implements Command {
  private text: string;
  
  constructor(private document: Document, text: string) {
    this.text = text;
  }
  
  execute(): void {
    this.document.write(this.text);
  }
  
  undo(): void {
    this.document.erase(this.text.length);
  }
}

class CommandHistory {
  private history: Command[] = [];
  private current: number = -1;
  
  execute(command: Command): void {
    command.execute();
    
    // Remove commands after current position (clear redo history)
    this.history = this.history.slice(0, this.current + 1);
    this.history.push(command);
    this.current++;
  }
  
  undo(): void {
    if (this.current >= 0) {
      this.history[this.current].undo();
      this.current--;
    }
  }
  
  redo(): void {
    if (this.current < this.history.length - 1) {
      this.current++;
      this.history[this.current].execute();
    }
  }
}

// Usage
const doc = new Document();
const history = new CommandHistory();

history.execute(new WriteCommand(doc, "Hello "));
history.execute(new WriteCommand(doc, "World"));
console.log(doc.getContent()); // "Hello World"

history.undo();
console.log(doc.getContent()); // "Hello "

history.redo();
console.log(doc.getContent()); // "Hello World"
```

#### Template Method

**Intent**: Define skeleton of algorithm, let subclasses override specific steps.

```php
// Use case: Document generation with different formats
abstract class DocumentGenerator {
    // Template method
    final public function generateDocument(array $data): string {
        $output = '';
        $output .= $this->writeHeader($data);
        $output .= $this->writeBody($data);
        $output .= $this->writeFooter($data);
        return $output;
    }
    
    abstract protected function writeHeader(array $data): string;
    abstract protected function writeBody(array $data): string;
    abstract protected function writeFooter(array $data): string;
}

class PDFGenerator extends DocumentGenerator {
    protected function writeHeader(array $data): string {
        return "PDF Header: {$data['title']}\n";
    }
    
    protected function writeBody(array $data): string {
        return "PDF Body: {$data['content']}\n";
    }
    
    protected function writeFooter(array $data): string {
        return "PDF Footer: Page 1\n";
    }
}

class HTMLGenerator extends DocumentGenerator {
    protected function writeHeader(array $data): string {
        return "<html><head><title>{$data['title']}</title></head>\n";
    }
    
    protected function writeBody(array $data): string {
        return "<body>{$data['content']}</body>\n";
    }
    
    protected function writeFooter(array $data): string {
        return "</html>\n";
    }
}

// Usage
$data = ['title' => 'Report', 'content' => 'Lorem ipsum'];

$pdfGen = new PDFGenerator();
echo $pdfGen->generateDocument($data);

$htmlGen = new HTMLGenerator();
echo $htmlGen->generateDocument($data);
```

#### State

**Intent**: Allow object to alter behavior when internal state changes.

```typescript
// Use case: Order status transitions, TCP connection states
interface OrderState {
  processPayment(order: Order): void;
  ship(order: Order): void;
  cancel(order: Order): void;
}

class Order {
  private state: OrderState;
  
  constructor() {
    this.state = new DraftState();
  }
  
  setState(state: OrderState): void {
    this.state = state;
    console.log(`Order state changed to: ${state.constructor.name}`);
  }
  
  processPayment(): void {
    this.state.processPayment(this);
  }
  
  ship(): void {
    this.state.ship(this);
  }
  
  cancel(): void {
    this.state.cancel(this);
  }
}

class DraftState implements OrderState {
  processPayment(order: Order): void {
    console.log("Payment processed");
    order.setState(new PaidState());
  }
  
  ship(order: Order): void {
    console.log("Cannot ship draft order");
  }
  
  cancel(order: Order): void {
    console.log("Order cancelled");
    order.setState(new CancelledState());
  }
}

class PaidState implements OrderState {
  processPayment(order: Order): void {
    console.log("Already paid");
  }
  
  ship(order: Order): void {
    console.log("Order shipped");
    order.setState(new ShippedState());
  }
  
  cancel(order: Order): void {
    console.log("Refund processed, order cancelled");
    order.setState(new CancelledState());
  }
}

class ShippedState implements OrderState {
  processPayment(order: Order): void {
    console.log("Already paid");
  }
  
  ship(order: Order): void {
    console.log("Already shipped");
  }
  
  cancel(order: Order): void {
    console.log("Cannot cancel shipped order");
  }
}

class CancelledState implements OrderState {
  processPayment(order: Order): void {
    console.log("Cannot process payment for cancelled order");
  }
  
  ship(order: Order): void {
    console.log("Cannot ship cancelled order");
  }
  
  cancel(order: Order): void {
    console.log("Already cancelled");
  }
}

// Usage
const order = new Order();
order.processPayment(); // Draft → Paid
order.ship();           // Paid → Shipped
order.cancel();         // Cannot cancel shipped order
```


#### Chain of Responsibility

**Intent**: Pass request along chain of handlers until one handles it.

```typescript
// Use case: Middleware pipeline, approval workflows, validation chains
interface Handler {
  setNext(handler: Handler): Handler;
  handle(request: Request): string | null;
}

abstract class BaseHandler implements Handler {
  private nextHandler: Handler | null = null;
  
  setNext(handler: Handler): Handler {
    this.nextHandler = handler;
    return handler;
  }
  
  handle(request: Request): string | null {
    if (this.nextHandler) {
      return this.nextHandler.handle(request);
    }
    return null;
  }
}

// Concrete handlers
class AuthHandler extends BaseHandler {
  handle(request: Request): string | null {
    if (!request.headers.authorization) {
      return "Unauthorized: Missing auth token";
    }
    console.log("Auth check passed");
    return super.handle(request);
  }
}

class RateLimitHandler extends BaseHandler {
  handle(request: Request): string | null {
    if (this.isRateLimited(request.ip)) {
      return "Too many requests";
    }
    console.log("Rate limit check passed");
    return super.handle(request);
  }
  
  private isRateLimited(ip: string): boolean {
    return false; // Simplified
  }
}

class ValidationHandler extends BaseHandler {
  handle(request: Request): string | null {
    if (!request.body || !request.body.email) {
      return "Validation failed: Email required";
    }
    console.log("Validation passed");
    return super.handle(request);
  }
}

// Usage
const auth = new AuthHandler();
const rateLimit = new RateLimitHandler();
const validation = new ValidationHandler();

auth.setNext(rateLimit).setNext(validation);

const request = {
  headers: { authorization: "Bearer token" },
  ip: "192.168.1.1",
  body: { email: "user@example.com" }
};

const result = auth.handle(request);
console.log(result || "Request processed successfully");
```

### 5.4 Modern Web Patterns

#### Repository Pattern

**Intent**: Abstract data access logic from business logic.

```typescript
// Use case: Separate database queries from business logic
interface UserRepository {
  findById(id: string): Promise<User | null>;
  findByEmail(email: string): Promise<User | null>;
  save(user: User): Promise<User>;
  delete(id: string): Promise<void>;
}

// Implementation with Prisma
class PrismaUserRepository implements UserRepository {
  constructor(private db: PrismaClient) {}
  
  async findById(id: string): Promise<User | null> {
    const row = await this.db.user.findUnique({ where: { id } });
    return row ? this.toDomain(row) : null;
  }
  
  async findByEmail(email: string): Promise<User | null> {
    const row = await this.db.user.findUnique({ where: { email } });
    return row ? this.toDomain(row) : null;
  }
  
  async save(user: User): Promise<User> {
    const row = await this.db.user.upsert({
      where: { id: user.id },
      create: this.toPersistence(user),
      update: this.toPersistence(user),
    });
    return this.toDomain(row);
  }
  
  async delete(id: string): Promise<void> {
    await this.db.user.delete({ where: { id } });
  }
  
  private toDomain(row: any): User {
    return new User(row.id, row.email, row.name);
  }
  
  private toPersistence(user: User): any {
    return { id: user.id, email: user.email, name: user.name };
  }
}

// Business logic uses interface, not implementation
class UserService {
  constructor(private userRepo: UserRepository) {}
  
  async registerUser(email: string, name: string): Promise<User> {
    const existing = await this.userRepo.findByEmail(email);
    if (existing) {
      throw new Error("Email already registered");
    }
    
    const user = new User(generateId(), email, name);
    return this.userRepo.save(user);
  }
}
```

#### Service Layer Pattern

**Intent**: Encapsulate business logic in service classes.

```python
# Use case: Coordinate multiple repositories, enforce business rules
class OrderService:
    def __init__(
        self,
        order_repo: OrderRepository,
        inventory_repo: InventoryRepository,
        payment_service: PaymentService,
        email_service: EmailService
    ):
        self.order_repo = order_repo
        self.inventory_repo = inventory_repo
        self.payment_service = payment_service
        self.email_service = email_service
    
    def checkout(self, user_id: str, cart_items: list[CartItem]) -> Order:
        # Business logic orchestration
        self._validate_cart(cart_items)
        self._check_inventory(cart_items)
        
        order = Order(
            id=generate_id(),
            user_id=user_id,
            items=cart_items,
            total=self._calculate_total(cart_items)
        )
        
        # Transaction: payment + inventory + order creation
        payment = self.payment_service.charge(order.total)
        self.inventory_repo.decrement_stock(cart_items)
        saved_order = self.order_repo.save(order)
        
        # Side effects
        self.email_service.send_order_confirmation(saved_order)
        
        return saved_order
    
    def _validate_cart(self, items: list[CartItem]) -> None:
        if not items:
            raise ValueError("Cart is empty")
    
    def _check_inventory(self, items: list[CartItem]) -> None:
        for item in items:
            available = self.inventory_repo.get_stock(item.product_id)
            if available < item.quantity:
                raise OutOfStockError(f"Product {item.product_id} out of stock")
    
    def _calculate_total(self, items: list[CartItem]) -> float:
        return sum(item.price * item.quantity for item in items)
```

#### DTO (Data Transfer Object)

**Intent**: Transfer data between layers without business logic.

```typescript
// Use case: API request/response payloads
// Domain entity (internal)
class User {
  constructor(
    public id: string,
    public email: string,
    public passwordHash: string,
    public createdAt: Date,
    private isAdmin: boolean
  ) {}
  
  hasPermission(action: string): boolean {
    return this.isAdmin;
  }
}

// DTO (external API)
interface UserResponseDTO {
  id: string;
  email: string;
  createdAt: string; // ISO string, not Date object
  // passwordHash excluded for security
  // isAdmin excluded, use permissions array instead
  permissions: string[];
}

class UserMapper {
  static toDTO(user: User): UserResponseDTO {
    return {
      id: user.id,
      email: user.email,
      createdAt: user.createdAt.toISOString(),
      permissions: user.hasPermission('admin') ? ['admin'] : ['user'],
    };
  }
}

// API route
export async function GET(req: Request) {
  const user = await userRepo.findById(req.params.id);
  return Response.json(UserMapper.toDTO(user)); // DTO, not domain entity
}
```

#### Value Object

**Intent**: Immutable object representing a concept, identified by value not ID.

```typescript
// Use case: Money, Email, Address - concepts without identity
class Money {
  constructor(
    public readonly amount: number,
    public readonly currency: string
  ) {
    if (amount < 0) throw new Error("Amount cannot be negative");
    if (!["USD", "EUR", "IDR"].includes(currency)) {
      throw new Error(`Invalid currency: ${currency}`);
    }
  }
  
  add(other: Money): Money {
    if (this.currency !== other.currency) {
      throw new Error("Cannot add different currencies");
    }
    return new Money(this.amount + other.amount, this.currency);
  }
  
  equals(other: Money): boolean {
    return this.amount === other.amount && this.currency === other.currency;
  }
}

class Email {
  private constructor(public readonly value: string) {}
  
  static create(value: string): Email {
    if (!value.includes("@")) {
      throw new Error("Invalid email format");
    }
    return new Email(value.toLowerCase().trim());
  }
  
  equals(other: Email): boolean {
    return this.value === other.value;
  }
}

// Usage
const price1 = new Money(100, "USD");
const price2 = new Money(50, "USD");
const total = price1.add(price2); // Money(150, "USD")

const email = Email.create("User@Example.Com");
console.log(email.value); // "user@example.com" (normalized)
```

#### Specification Pattern

**Intent**: Compose business rules as reusable specifications.

```python
# Use case: Complex filtering logic, business rule composition
from abc import ABC, abstractmethod

class Specification(ABC):
    @abstractmethod
    def is_satisfied_by(self, candidate) -> bool:
        pass
    
    def and_(self, other):
        return AndSpecification(self, other)
    
    def or_(self, other):
        return OrSpecification(self, other)
    
    def not_(self):
        return NotSpecification(self)

class AndSpecification(Specification):
    def __init__(self, left: Specification, right: Specification):
        self.left = left
        self.right = right
    
    def is_satisfied_by(self, candidate) -> bool:
        return self.left.is_satisfied_by(candidate) and self.right.is_satisfied_by(candidate)

class OrSpecification(Specification):
    def __init__(self, left: Specification, right: Specification):
        self.left = left
        self.right = right
    
    def is_satisfied_by(self, candidate) -> bool:
        return self.left.is_satisfied_by(candidate) or self.right.is_satisfied_by(candidate)

class NotSpecification(Specification):
    def __init__(self, spec: Specification):
        self.spec = spec
    
    def is_satisfied_by(self, candidate) -> bool:
        return not self.spec.is_satisfied_by(candidate)

# Concrete specifications
class PremiumUserSpecification(Specification):
    def is_satisfied_by(self, user) -> bool:
        return user.tier == "premium"

class ActiveUserSpecification(Specification):
    def is_satisfied_by(self, user) -> bool:
        return user.status == "active"

class HighSpenderSpecification(Specification):
    def __init__(self, min_amount: float):
        self.min_amount = min_amount
    
    def is_satisfied_by(self, user) -> bool:
        return user.total_spent >= self.min_amount

# Usage: Compose complex rules
eligible_for_vip = (
    PremiumUserSpecification()
    .and_(ActiveUserSpecification())
    .and_(HighSpenderSpecification(10000))
)

for user in users:
    if eligible_for_vip.is_satisfied_by(user):
        upgrade_to_vip(user)
```

#### Dependency Injection Container

**Intent**: Centralized management of object creation and dependencies.

```typescript
// Use case: Auto-wire dependencies in large applications
type Constructor<T> = new (...args: any[]) => T;

class Container {
  private services = new Map<string, any>();
  private singletons = new Map<string, any>();
  
  register<T>(name: string, factory: () => T, singleton = false): void {
    this.services.set(name, { factory, singleton });
  }
  
  resolve<T>(name: string): T {
    const service = this.services.get(name);
    if (!service) {
      throw new Error(`Service not found: ${name}`);
    }
    
    if (service.singleton) {
      if (!this.singletons.has(name)) {
        this.singletons.set(name, service.factory());
      }
      return this.singletons.get(name);
    }
    
    return service.factory();
  }
}

// Setup
const container = new Container();

container.register('db', () => new Database(), true); // Singleton
container.register('userRepo', () => new UserRepository(container.resolve('db')));
container.register('emailService', () => new EmailService());
container.register('userService', () => new UserService(
  container.resolve('userRepo'),
  container.resolve('emailService')
));

// Usage
const userService = container.resolve<UserService>('userService');
```


---

## 6. Architectural Principles

### 6.1 Layered Architecture

**Structure**: Presentation → Application → Domain → Infrastructure

```
┌─────────────────────────────────────┐
│     Presentation Layer              │  ← UI, API routes, controllers
├─────────────────────────────────────┤
│     Application Layer               │  ← Use cases, orchestration
├─────────────────────────────────────┤
│     Domain Layer                    │  ← Business logic, entities
├─────────────────────────────────────┤
│     Infrastructure Layer            │  ← Database, external services
└─────────────────────────────────────┘
```

**Example (Next.js structure)**:
```
app/
  api/                    ← Presentation (API routes)
    users/
      route.ts            ← HTTP handler
lib/
  application/            ← Application (use cases)
    RegisterUser.ts
  domain/                 ← Domain (business logic)
    User.ts               ← Entity
    UserRepository.ts     ← Interface
  infrastructure/         ← Infrastructure (implementation)
    PrismaUserRepository.ts
    EmailService.ts
```

### 6.2 Hexagonal Architecture (Ports & Adapters)

**Intent**: Isolate core business logic from external concerns.

```typescript
// CORE (Domain + Application)
// Port: Interface defined by core
interface PaymentGateway {
  charge(amount: number): Promise<PaymentResult>;
}

// Use case
class CheckoutUseCase {
  constructor(private paymentGateway: PaymentGateway) {}
  
  async execute(cartId: string): Promise<Order> {
    const cart = await this.getCart(cartId);
    const result = await this.paymentGateway.charge(cart.total);
    return this.createOrder(cart, result);
  }
}

// ADAPTERS (Infrastructure)
// Adapter: Implementation for specific gateway
class StripeAdapter implements PaymentGateway {
  async charge(amount: number): Promise<PaymentResult> {
    const stripe = new Stripe(process.env.STRIPE_KEY);
    const charge = await stripe.charges.create({ amount, currency: 'usd' });
    return { success: charge.status === 'succeeded', id: charge.id };
  }
}

class MockPaymentAdapter implements PaymentGateway {
  async charge(amount: number): Promise<PaymentResult> {
    return { success: true, id: 'mock_payment_123' };
  }
}

// Wiring (Dependency Injection)
const gateway = process.env.NODE_ENV === 'production'
  ? new StripeAdapter()
  : new MockPaymentAdapter();

const checkout = new CheckoutUseCase(gateway);
```

### 6.3 Clean Architecture

**Dependency Rule**: Source code dependencies point inward toward business logic.

```
┌───────────────────────────────────────┐
│  Frameworks & Drivers (UI, DB, Web)  │  ← Outermost
├───────────────────────────────────────┤
│  Interface Adapters (Controllers)    │
├───────────────────────────────────────┤
│  Application (Use Cases)             │
├───────────────────────────────────────┤
│  Entities (Business Rules)           │  ← Innermost (most stable)
└───────────────────────────────────────┘
```

**Key Rules**:
- Inner layers know nothing about outer layers
- Entities have no dependencies
- Use cases depend only on entities
- Controllers/adapters depend on use cases, not frameworks

**Example**:
```typescript
// ENTITIES (innermost - no dependencies)
class Order {
  constructor(
    public id: string,
    public userId: string,
    public total: number,
    public status: OrderStatus
  ) {}
  
  canBeCancelled(): boolean {
    return this.status === 'pending' || this.status === 'paid';
  }
}

// USE CASES (depend only on entities)
interface OrderRepository {
  save(order: Order): Promise<Order>;
  findById(id: string): Promise<Order | null>;
}

class CancelOrderUseCase {
  constructor(private orderRepo: OrderRepository) {}
  
  async execute(orderId: string): Promise<void> {
    const order = await this.orderRepo.findById(orderId);
    if (!order) throw new Error("Order not found");
    
    if (!order.canBeCancelled()) {
      throw new Error("Order cannot be cancelled");
    }
    
    order.status = 'cancelled';
    await this.orderRepo.save(order);
  }
}

// ADAPTERS (depend on use cases)
export async function POST(req: Request) {
  const { orderId } = await req.json();
  
  const orderRepo = new PrismaOrderRepository(db);
  const useCase = new CancelOrderUseCase(orderRepo);
  
  await useCase.execute(orderId);
  return Response.json({ success: true });
}
```

### 6.4 Domain-Driven Design (DDD) Basics

#### Entities
Objects with unique identity that persists over time.

```typescript
class User {
  constructor(
    public readonly id: UserId, // Identity
    public email: Email,
    public name: string
  ) {}
  
  changeEmail(newEmail: Email): void {
    // Business rule: Email validation
    this.email = newEmail;
  }
}
```

#### Value Objects
Objects defined by their attributes, not identity.

```typescript
class UserId {
  constructor(public readonly value: string) {
    if (!value.match(/^[0-9a-f]{8}-[0-9a-f]{4}-4/)) {
      throw new Error("Invalid UUID v4");
    }
  }
  
  equals(other: UserId): boolean {
    return this.value === other.value;
  }
}
```

#### Aggregates
Cluster of entities and value objects with a root entity.

```typescript
// Aggregate Root
class Order {
  private items: OrderItem[] = [];
  
  addItem(product: Product, quantity: number): void {
    // Business rule enforced at aggregate boundary
    if (this.items.length >= 100) {
      throw new Error("Maximum 100 items per order");
    }
    
    const existing = this.items.find(i => i.productId === product.id);
    if (existing) {
      existing.quantity += quantity;
    } else {
      this.items.push(new OrderItem(product.id, quantity, product.price));
    }
  }
  
  // All access to OrderItem goes through Order aggregate root
  getTotal(): number {
    return this.items.reduce((sum, item) => sum + item.subtotal, 0);
  }
}

// Entity inside aggregate (not accessed directly)
class OrderItem {
  constructor(
    public productId: string,
    public quantity: number,
    public price: number
  ) {}
  
  get subtotal(): number {
    return this.quantity * this.price;
  }
}
```

#### Repositories
Persist and retrieve aggregates.

```typescript
interface OrderRepository {
  save(order: Order): Promise<Order>;
  findById(id: string): Promise<Order | null>;
  // Only aggregate roots have repositories
}
```

### 6.5 Onion Architecture

**Structure**: Similar to Clean Architecture, emphasizes dependency inversion.

```
        ┌────────────────┐
        │  Infrastructure │  ← Database, API clients
        └────────────────┘
                ↓
        ┌────────────────┐
        │  Application    │  ← Use cases
        └────────────────┘
                ↓
        ┌────────────────┐
        │  Domain Model   │  ← Entities, value objects
        └────────────────┘
```

**Key Principle**: All dependencies point inward.

---

## 7. Architectural Styles

### 7.1 Monolith vs Microservices

**Decision Tree**:
```
Team size < 5?
├─ YES → Monolith (easier deployment, shared code)
└─ NO → Consider microservices

Independent scaling needed?
├─ YES → Microservices (scale specific services)
└─ NO → Monolith

Organizational boundaries clear?
├─ YES → Microservices (separate teams own services)
└─ NO → Modular monolith
```

**Monolith Advantages**:
- Single deployment
- No network latency between components
- Easier debugging (single codebase)
- Lower infrastructure cost

**Microservices Advantages**:
- Independent deployment per service
- Scale specific services independently
- Technology heterogeneity (different languages per service)
- Fault isolation

**When to Split Monolith**:
- Team size > 10 engineers
- Independent release cycles needed
- Clear bounded contexts identified
- Performance bottleneck in specific component

### 7.2 Event-Driven Architecture

**Intent**: Decouple services via asynchronous events.

```typescript
// Event
interface OrderPlacedEvent {
  type: 'order.placed';
  orderId: string;
  userId: string;
  total: number;
  timestamp: Date;
}

// Producer
class OrderService {
  async placeOrder(cart: Cart): Promise<Order> {
    const order = await this.orderRepo.save(cart);
    
    // Publish event (fire-and-forget)
    await this.eventBus.publish<OrderPlacedEvent>({
      type: 'order.placed',
      orderId: order.id,
      userId: order.userId,
      total: order.total,
      timestamp: new Date(),
    });
    
    return order;
  }
}

// Consumer 1: Send email
eventBus.subscribe('order.placed', async (event: OrderPlacedEvent) => {
  const user = await userRepo.findById(event.userId);
  await emailService.sendOrderConfirmation(user.email, event.orderId);
});

// Consumer 2: Update analytics
eventBus.subscribe('order.placed', async (event: OrderPlacedEvent) => {
  await analyticsService.track('order_placed', {
    orderId: event.orderId,
    revenue: event.total,
  });
});

// Consumer 3: Decrement inventory
eventBus.subscribe('order.placed', async (event: OrderPlacedEvent) => {
  const order = await orderRepo.findById(event.orderId);
  await inventoryService.decrementStock(order.items);
});
```

### 7.3 CQRS (Command Query Responsibility Segregation)

**Intent**: Separate read and write models.

```typescript
// WRITE MODEL (Commands)
class CreateOrderCommand {
  constructor(
    public userId: string,
    public items: CartItem[]
  ) {}
}

class CreateOrderHandler {
  async handle(command: CreateOrderCommand): Promise<string> {
    const order = new Order(generateId(), command.userId, command.items);
    await this.orderRepo.save(order); // Write to normalized tables
    
    // Publish event for read model sync
    await this.eventBus.publish({ type: 'order.created', order });
    
    return order.id;
  }
}

// READ MODEL (Queries)
class GetOrdersByUserQuery {
  constructor(public userId: string) {}
}

class GetOrdersByUserHandler {
  async handle(query: GetOrdersByUserQuery): Promise<OrderDTO[]> {
    // Read from denormalized view optimized for queries
    return this.orderReadModel.findByUserId(query.userId);
  }
}

// Event handler: Sync read model
eventBus.subscribe('order.created', async (event) => {
  await orderReadModel.insert({
    orderId: event.order.id,
    userId: event.order.userId,
    total: event.order.total,
    itemCount: event.order.items.length,
    createdAt: event.order.createdAt,
    // Denormalized fields for fast queries
    userName: await this.getUserName(event.order.userId),
  });
});
```

### 7.4 Serverless Architecture

**Characteristics**:
- Stateless functions
- Event-driven invocation
- Auto-scaling
- Pay-per-execution

```typescript
// Vercel Edge Function
export async function POST(req: Request) {
  const { email, name } = await req.json();
  
  // Cold start: ~50ms
  // Execution: ~200ms
  const user = await db.users.create({ email, name });
  
  // Trigger async job
  await fetch(process.env.QUEUE_URL, {
    method: 'POST',
    body: JSON.stringify({ type: 'send_welcome_email', userId: user.id }),
  });
  
  return Response.json(user);
}
```

**Limitations**:
- Cold start latency (50-200ms)
- Execution time limits (10-900s depending on provider)
- Stateless (no in-memory cache across requests)
- Vendor lock-in

---

## 8. Architectural Patterns

### 8.1 MVC (Model-View-Controller)

**Laravel default pattern**:

```php
// Model (domain data)
class User extends Model {
    protected $fillable = ['email', 'name'];
}

// Controller (handles requests)
class UserController extends Controller {
    public function store(Request $request) {
        $validated = $request->validate([
            'email' => 'required|email',
            'name' => 'required',
        ]);
        
        $user = User::create($validated);
        
        return view('users.show', ['user' => $user]);
    }
}

// View (presentation)
<!-- resources/views/users/show.blade.php -->
<h1>{{ $user->name }}</h1>
<p>{{ $user->email }}</p>
```

### 8.2 MVP (Model-View-Presenter)

**Intent**: Make UI logic testable by extracting it to presenter.

```typescript
// Model
class User {
  constructor(public id: string, public email: string) {}
}

// View (interface, not implementation)
interface UserView {
  showUser(email: string): void;
  showError(message: string): void;
}

// Presenter (testable business logic)
class UserPresenter {
  constructor(
    private view: UserView,
    private userRepo: UserRepository
  ) {}
  
  async loadUser(userId: string): Promise<void> {
    try {
      const user = await this.userRepo.findById(userId);
      if (user) {
        this.view.showUser(user.email);
      } else {
        this.view.showError("User not found");
      }
    } catch (error) {
      this.view.showError("Failed to load user");
    }
  }
}

// View (React implementation)
class UserComponent implements UserView {
  private presenter: UserPresenter;
  
  constructor() {
    this.presenter = new UserPresenter(this, new UserRepository());
  }
  
  componentDidMount() {
    this.presenter.loadUser(this.props.userId);
  }
  
  showUser(email: string): void {
    this.setState({ email, error: null });
  }
  
  showError(message: string): void {
    this.setState({ email: null, error: message });
  }
}
```

### 8.3 MVVM (Model-View-ViewModel)

**Intent**: Two-way data binding between view and view model.

```typescript
// Model
class Task {
  constructor(public id: string, public title: string, public done: boolean) {}
}

// ViewModel (reactive state)
class TaskListViewModel {
  tasks = signal<Task[]>([]);
  filter = signal<'all' | 'active' | 'done'>('all');
  
  get filteredTasks(): Task[] {
    switch (this.filter()) {
      case 'active': return this.tasks().filter(t => !t.done);
      case 'done': return this.tasks().filter(t => t.done);
      default: return this.tasks();
    }
  }
  
  async loadTasks() {
    const tasks = await taskRepo.findAll();
    this.tasks.set(tasks);
  }
  
  toggleTask(id: string) {
    const tasks = this.tasks();
    const task = tasks.find(t => t.id === id);
    if (task) {
      task.done = !task.done;
      this.tasks.set([...tasks]); // Trigger update
    }
  }
}

// View (React with signals or Vue)
function TaskListView() {
  const vm = new TaskListViewModel();
  
  useEffect(() => { vm.loadTasks(); }, []);
  
  return (
    <div>
      {vm.filteredTasks.map(task => (
        <div key={task.id} onClick={() => vm.toggleTask(task.id)}>
          {task.title} {task.done && '✓'}
        </div>
      ))}
    </div>
  );
}
```


### 8.4 Three-Tier Architecture

**Structure**: Presentation → Business Logic → Data Access

```
┌─────────────────┐
│  Presentation   │  ← Web UI, mobile app, API
└─────────────────┘
         ↓
┌─────────────────┐
│ Business Logic  │  ← Services, domain logic
└─────────────────┘
         ↓
┌─────────────────┐
│  Data Access    │  ← Database, file storage
└─────────────────┘
```

**Next.js Example**:
```typescript
// Presentation (app/api/users/route.ts)
export async function GET(req: Request) {
  const users = await userService.getAllUsers();
  return Response.json(users);
}

// Business Logic (lib/services/UserService.ts)
class UserService {
  async getAllUsers(): Promise<User[]> {
    return userRepository.findAll();
  }
}

// Data Access (lib/repositories/UserRepository.ts)
class UserRepository {
  async findAll(): Promise<User[]> {
    return db.user.findMany();
  }
}
```

---

## 9. Enterprise Patterns

### 9.1 Transaction Script vs Domain Model

#### Transaction Script (Procedural)

**Use case**: Simple CRUD operations, small applications.

```php
// Each use case is a single procedural function
function registerUser(string $email, string $password): array {
    // Validate
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        throw new Exception("Invalid email");
    }
    
    // Business logic
    $hashedPassword = password_hash($password, PASSWORD_ARGON2ID);
    
    // Database
    $userId = DB::table('users')->insertGetId([
        'email' => $email,
        'password' => $hashedPassword,
        'created_at' => now(),
    ]);
    
    // Side effect
    Mail::to($email)->send(new WelcomeEmail());
    
    return ['id' => $userId, 'email' => $email];
}
```

**Pros**: Simple, easy to understand, fast for small apps.
**Cons**: Duplication, hard to test, business logic scattered.

#### Domain Model (OOP)

**Use case**: Complex business rules, medium-large applications.

```typescript
// Business logic encapsulated in domain objects
class User {
  constructor(
    public id: string,
    public email: Email,
    private passwordHash: string
  ) {}
  
  static register(email: Email, password: Password): User {
    // Business rules in domain
    if (password.isWeak()) {
      throw new WeakPasswordError();
    }
    
    return new User(
      generateId(),
      email,
      password.hash()
    );
  }
  
  changePassword(oldPassword: Password, newPassword: Password): void {
    if (!this.passwordHash.verify(oldPassword)) {
      throw new InvalidPasswordError();
    }
    this.passwordHash = newPassword.hash();
  }
}

// Use case orchestrates domain objects
class RegisterUserUseCase {
  constructor(
    private userRepo: UserRepository,
    private emailService: EmailService
  ) {}
  
  async execute(email: string, password: string): Promise<User> {
    const user = User.register(
      Email.create(email),
      Password.create(password)
    );
    
    await this.userRepo.save(user);
    await this.emailService.sendWelcome(user.email);
    
    return user;
  }
}
```

**Pros**: Testable, reusable, encapsulated business logic.
**Cons**: More complex, over-engineering for simple apps.

### 9.2 Table Module vs Active Record

#### Active Record (Laravel Eloquent)

**Combines domain logic + data access in single class.**

```php
class Order extends Model {
    // Data access
    protected $fillable = ['user_id', 'total', 'status'];
    
    // Relationships
    public function items() {
        return $this->hasMany(OrderItem::class);
    }
    
    // Business logic
    public function canBeCancelled(): bool {
        return in_array($this->status, ['pending', 'paid']);
    }
    
    public function cancel(): void {
        if (!$this->canBeCancelled()) {
            throw new Exception("Cannot cancel order");
        }
        
        $this->status = 'cancelled';
        $this->save(); // Directly saves to DB
    }
}

// Usage
$order = Order::find($orderId);
$order->cancel(); // Domain logic + persistence coupled
```

**Pros**: Simple, less boilerplate, fast development.
**Cons**: Tight coupling to database, hard to unit test.

#### Table Module

**Separate business logic from data access.**

```typescript
// Domain entity (no persistence logic)
class Order {
  constructor(
    public id: string,
    public userId: string,
    public status: OrderStatus
  ) {}
  
  canBeCancelled(): boolean {
    return this.status === 'pending' || this.status === 'paid';
  }
  
  cancel(): void {
    if (!this.canBeCancelled()) {
      throw new Error("Cannot cancel order");
    }
    this.status = 'cancelled';
  }
}

// Repository (persistence logic)
class OrderRepository {
  async save(order: Order): Promise<void> {
    await db.order.update({
      where: { id: order.id },
      data: { status: order.status },
    });
  }
}

// Usage
const order = await orderRepo.findById(orderId);
order.cancel(); // Domain logic
await orderRepo.save(order); // Explicit save
```

**Pros**: Testable domain logic, separation of concerns.
**Cons**: More boilerplate, requires discipline.

### 9.3 Unit of Work

**Intent**: Batch multiple database operations into single transaction.

```typescript
class UnitOfWork {
  private newEntities: any[] = [];
  private dirtyEntities: any[] = [];
  private deletedEntities: any[] = [];
  
  registerNew(entity: any): void {
    this.newEntities.push(entity);
  }
  
  registerDirty(entity: any): void {
    if (!this.dirtyEntities.includes(entity)) {
      this.dirtyEntities.push(entity);
    }
  }
  
  registerDeleted(entity: any): void {
    this.deletedEntities.push(entity);
  }
  
  async commit(): Promise<void> {
    await db.$transaction(async (tx) => {
      // Insert new
      for (const entity of this.newEntities) {
        await tx.insert(entity);
      }
      
      // Update dirty
      for (const entity of this.dirtyEntities) {
        await tx.update(entity);
      }
      
      // Delete
      for (const entity of this.deletedEntities) {
        await tx.delete(entity);
      }
    });
    
    this.clear();
  }
  
  clear(): void {
    this.newEntities = [];
    this.dirtyEntities = [];
    this.deletedEntities = [];
  }
}

// Usage
const uow = new UnitOfWork();

const order = new Order(generateId(), userId, 'pending');
uow.registerNew(order);

const user = await userRepo.findById(userId);
user.orderCount += 1;
uow.registerDirty(user);

await uow.commit(); // Single transaction
```

**Laravel equivalent**:
```php
DB::transaction(function () use ($order, $user) {
    $order->save();
    $user->increment('order_count');
});
```

### 9.4 Identity Map

**Intent**: Ensure each object loaded only once per session.

```typescript
class IdentityMap {
  private map = new Map<string, any>();
  
  get(type: string, id: string): any | null {
    const key = `${type}:${id}`;
    return this.map.get(key) || null;
  }
  
  set(type: string, id: string, entity: any): void {
    const key = `${type}:${id}`;
    this.map.set(key, entity);
  }
}

class UserRepository {
  constructor(private identityMap: IdentityMap) {}
  
  async findById(id: string): Promise<User | null> {
    // Check cache first
    const cached = this.identityMap.get('User', id);
    if (cached) return cached;
    
    // Load from database
    const row = await db.user.findUnique({ where: { id } });
    if (!row) return null;
    
    const user = new User(row.id, row.email);
    
    // Cache for this session
    this.identityMap.set('User', id, user);
    
    return user;
  }
}

// Benefit: Prevents duplicate queries
const user1 = await userRepo.findById('123'); // DB query
const user2 = await userRepo.findById('123'); // Cache hit (same object reference)
console.log(user1 === user2); // true
```

### 9.5 Lazy Loading vs Eager Loading

#### Lazy Loading (N+1 Problem)

```typescript
// BAD: N+1 queries
const users = await db.user.findMany(); // 1 query

for (const user of users) {
  const posts = await db.post.findMany({ where: { userId: user.id } }); // N queries
  console.log(`${user.name} has ${posts.length} posts`);
}
// Total: 1 + N queries (N = number of users)
```

#### Eager Loading (Solution)

```typescript
// GOOD: 2 queries total
const users = await db.user.findMany({
  include: { posts: true }, // Join in single query
});

for (const user of users) {
  console.log(`${user.name} has ${user.posts.length} posts`);
}
// Total: 1-2 queries (depending on ORM)
```

**Laravel example**:
```php
// N+1 problem
$users = User::all();
foreach ($users as $user) {
    echo $user->posts->count(); // N queries
}

// Eager loading
$users = User::with('posts')->get();
foreach ($users as $user) {
    echo $user->posts->count(); // 2 queries total
}
```

### 9.6 Data Mapper

**Intent**: Separate domain objects from database structure (Doctrine style).

```typescript
// Domain entity (no DB annotations)
class User {
  constructor(
    public id: string,
    public email: string,
    public profile: UserProfile
  ) {}
}

// Data Mapper (handles persistence)
class UserMapper {
  async save(user: User): Promise<void> {
    await db.user.upsert({
      where: { id: user.id },
      create: {
        id: user.id,
        email: user.email,
        profile_bio: user.profile.bio,
        profile_avatar: user.profile.avatarUrl,
      },
      update: {
        email: user.email,
        profile_bio: user.profile.bio,
        profile_avatar: user.profile.avatarUrl,
      },
    });
  }
  
  async findById(id: string): Promise<User | null> {
    const row = await db.user.findUnique({ where: { id } });
    if (!row) return null;
    
    return new User(
      row.id,
      row.email,
      new UserProfile(row.profile_bio, row.profile_avatar)
    );
  }
}

// Domain model stays clean, no DB coupling
```

---

## 10. AI Code Review Application

### 10.1 Pattern Detection Checklist

**When reviewing AI-generated code, check for:**

#### ✅ Good Patterns
- [ ] Single Responsibility: Each function/class has one reason to change
- [ ] Dependency Injection: Dependencies passed via constructor
- [ ] Interface Segregation: Small, focused interfaces
- [ ] Error Handling: Explicit try-catch with meaningful messages
- [ ] Repository Pattern: Data access abstracted behind interface
- [ ] Value Objects: Domain primitives wrapped (Email, Money)

#### ❌ Anti-Patterns
- [ ] God Class: Class > 500 lines doing everything
- [ ] Primitive Obsession: Passing raw strings/numbers everywhere
- [ ] Magic Numbers: Hardcoded values without constants
- [ ] Silent Failures: Empty catch blocks or ignored errors
- [ ] Tight Coupling: Direct database calls in business logic
- [ ] Anemic Domain Model: Entity classes with only getters/setters

### 10.2 AI Over-Engineering Signals

**AI often over-engineers simple requirements:**

```typescript
// AI-generated (over-engineered)
interface UserFactory {
  createUser(data: UserCreationData): User;
}

class ConcreteUserFactory implements UserFactory {
  createUser(data: UserCreationData): User {
    return new User(data.email, data.name);
  }
}

class UserCreationService {
  constructor(private factory: UserFactory) {}
  
  create(data: UserCreationData): User {
    return this.factory.createUser(data);
  }
}

// Human-written (sufficient)
function createUser(email: string, name: string): User {
  return new User(email, name);
}
// ponytail: add factory when multiple user types needed (premium, enterprise)
```

**Over-engineering indicators:**
- Factory with single implementation
- Interface with single implementer
- Service class that only delegates
- Unnecessary abstraction layers

### 10.3 AI Under-Engineering Signals

**AI often misses critical concerns:**

```typescript
// AI-generated (under-engineered)
async function updateUser(userId: string, data: any) {
  await db.user.update({ where: { id: userId }, data });
  return { success: true };
}

// Issues:
// ❌ No input validation
// ❌ No authorization check
// ❌ No error handling
// ❌ Any field can be updated (including sensitive fields)
// ❌ No audit trail

// Human-improved
async function updateUser(
  userId: string,
  data: UpdateUserInput,
  actorId: string
): Promise<User> {
  // Authorization
  if (actorId !== userId && !isAdmin(actorId)) {
    throw new UnauthorizedError();
  }
  
  // Validation
  const validated = UpdateUserSchema.parse(data);
  
  // Business rules
  if (validated.email) {
    const existing = await db.user.findUnique({
      where: { email: validated.email },
    });
    if (existing && existing.id !== userId) {
      throw new EmailAlreadyTakenError();
    }
  }
  
  // Update with audit trail
  const user = await db.user.update({
    where: { id: userId },
    data: {
      ...validated,
      updatedAt: new Date(),
      updatedBy: actorId,
    },
  });
  
  // Side effects
  await auditLog.log('user.updated', { userId, actorId, changes: validated });
  
  return user;
}
```

**Under-engineering indicators:**
- Missing input validation
- No authorization checks
- No audit trail
- Swallowed errors
- Hardcoded configuration values

### 10.4 Refactoring Triggers

**When to refactor AI-generated code:**

| Code Smell | Threshold | Refactoring |
|------------|-----------|-------------|
| Long Method | > 20 lines | Extract Method |
| Long Parameter List | > 3 params | Introduce Parameter Object |
| Duplicated Code | 3+ occurrences | Extract Function |
| Large Class | > 300 lines | Extract Class |
| Cyclomatic Complexity | > 10 | Simplify Conditionals, Strategy Pattern |
| Deep Nesting | > 3 levels | Guard Clauses, Extract Method |
| Primitive Obsession | `string email` everywhere | Introduce Value Object |

**Example: Extract Parameter Object**

```typescript
// Before: Long parameter list
function createOrder(
  userId: string,
  items: CartItem[],
  shippingAddress: string,
  billingAddress: string,
  paymentMethod: string,
  promoCode?: string
) { }

// After: Parameter object
interface CreateOrderParams {
  userId: string;
  items: CartItem[];
  shippingAddress: Address;
  billingAddress: Address;
  paymentMethod: PaymentMethod;
  promoCode?: PromoCode;
}

function createOrder(params: CreateOrderParams) { }
```

### 10.5 Pattern Decision Tree

```
Need multiple implementations?
├─ NO → Direct class (no interface yet)
└─ YES → Extract interface

Need to swap algorithm at runtime?
├─ NO → Simple if/else
└─ YES → Strategy Pattern

Need undo functionality?
├─ NO → Direct method calls
└─ YES → Command Pattern

Object construction complex?
├─ NO → Constructor
└─ YES → Builder Pattern

Need to observe state changes?
├─ NO → Direct method calls
└─ YES → Observer Pattern

Need to separate concerns?
├─ NO → Keep simple
└─ YES → Layered Architecture
```

### 10.6 Quick Reference: When NOT to Use Patterns

- **Singleton**: Use DI instead (easier testing)
- **Factory**: Don't create factory for single class
- **Abstract Factory**: Overkill for < 3 product families
- **Strategy**: Simple if/else sufficient for 2-3 cases
- **Observer**: Direct call simpler for single listener
- **Facade**: Don't wrap simple APIs (adds no value)
- **Decorator**: Composition sufficient for single feature add

**Rule**: Implement simplest solution first. Refactor to pattern when complexity demands it.

---

## Summary

**Clean Code**: Meaningful names, small functions, explicit errors, DRY when appropriate.

**SOLID**: Single responsibility, open/closed, Liskov substitution, interface segregation, dependency inversion.

**Patterns**: Use when complexity demands, not preemptively.

**Architecture**: Match complexity to project size (monolith → modular monolith → microservices).

**AI Code Review**: Check for over-engineering (unnecessary abstraction) and under-engineering (missing validation, auth, error handling).

