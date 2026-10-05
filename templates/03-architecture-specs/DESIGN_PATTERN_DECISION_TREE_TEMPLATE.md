# Design Pattern Decision Tree

**Project**: [Project Name]  
**Date**: [YYYY-MM-DD]  
**Reviewer**: [Name]

---

## Pattern Selection Workflow

### Step 1: Identify the Problem

**What are you trying to solve?**

- [ ] Object creation complexity
- [ ] Structural composition
- [ ] Behavioral flexibility
- [ ] Architectural organization
- [ ] Data access abstraction

---

## Decision Trees by Category

### Creational Patterns (Object Creation)

```
Need multiple ways to create objects?
├─ NO → Use constructor
└─ YES → Continue

Is construction complex (many optional parameters)?
├─ YES → Builder Pattern
└─ NO → Continue

Need to ensure only one instance exists?
├─ YES → Singleton (⚠️ consider DI instead)
└─ NO → Continue

Need to create family of related objects?
├─ YES → Abstract Factory
└─ NO → Factory Method

Need to clone expensive objects?
├─ YES → Prototype
└─ NO → Simple constructor
```

**Decision Record**:
- **Pattern Selected**: _______________
- **Reasoning**: _______________
- **Rejected Alternatives**: _______________

---

### Structural Patterns (Object Composition)

```
Need to adapt incompatible interfaces?
├─ YES → Adapter Pattern
└─ NO → Continue

Need to add behavior without modifying class?
├─ YES → Decorator Pattern
└─ NO → Continue

Need to simplify complex subsystem?
├─ YES → Facade Pattern
└─ NO → Continue

Need to control access to expensive object?
├─ YES → Proxy Pattern (lazy loading, caching, access control)
└─ NO → Continue

Need to treat individual objects and compositions uniformly?
├─ YES → Composite Pattern (tree structures)
└─ NO → Direct composition
```

**Decision Record**:
- **Pattern Selected**: _______________
- **Reasoning**: _______________
- **Trade-offs**: _______________

---

### Behavioral Patterns (Object Interaction)

```
Need to notify multiple objects of state changes?
├─ YES → Observer Pattern (Pub/Sub)
└─ NO → Continue

Need to swap algorithms at runtime?
├─ YES → Strategy Pattern
└─ NO → Continue

Need undo/redo functionality?
├─ YES → Command Pattern
└─ NO → Continue

Need to define skeleton algorithm, vary steps?
├─ YES → Template Method
└─ NO → Continue

Need to change behavior based on internal state?
├─ YES → State Pattern
└─ NO → Continue

Need to pass request along chain until handled?
├─ YES → Chain of Responsibility
└─ NO → Direct method call
```

**Decision Record**:
- **Pattern Selected**: _______________
- **Reasoning**: _______________
- **Alternative Considered**: _______________

---

### Modern Web Patterns

```
Need to abstract data access?
├─ YES → Repository Pattern
└─ NO → Continue

Need to coordinate multiple repositories?
├─ YES → Service Layer Pattern
└─ NO → Continue

Need separate read/write models?
├─ YES → CQRS
└─ NO → Continue

Need to compose business rules?
├─ YES → Specification Pattern
└─ NO → Simple if/else

Need to manage object dependencies?
├─ YES → Dependency Injection Container
└─ NO → Manual DI
```

**Decision Record**:
- **Pattern Selected**: _______________
- **Reasoning**: _______________
- **Implementation Notes**: _______________

---

## Architectural Pattern Selection

### Architecture Decision Tree

```
Team size?
├─ < 5 people → Monolith
├─ 5-15 people → Modular Monolith
└─ > 15 people → Consider Microservices

Deployment independence needed?
├─ NO → Monolith
└─ YES → Continue

Clear bounded contexts?
├─ NO → Modular Monolith
└─ YES → Microservices

Performance requirements?
├─ Simple CRUD → Three-Tier
├─ Complex business rules → Domain-Driven Design
├─ High read load → CQRS
└─ Event processing → Event-Driven Architecture
```

**Architecture Decision**:
- **Style Selected**: _______________
- **Reasoning**: _______________
- **Trade-offs**: _______________
- **Migration Path**: _______________

---

## Anti-Pattern Avoidance Checklist

**Before implementing pattern, verify:**

- [ ] **Not over-engineering**: Pattern adds real value, not just abstraction
- [ ] **Complexity justified**: Problem is complex enough to warrant pattern
- [ ] **Team familiarity**: Team understands pattern (or willing to learn)
- [ ] **Maintenance cost**: Pattern won't make debugging harder
- [ ] **Performance acceptable**: Pattern doesn't add unacceptable overhead

**Red Flags (Don't Implement Pattern If)**:
- [ ] Interface with single implementation (wait for second implementer)
- [ ] Factory for one product type (use constructor)
- [ ] Service class that only delegates (unnecessary indirection)
- [ ] Singleton for configuration (use DI)
- [ ] Observer for single listener (direct call simpler)

---

## Implementation Checklist

### Pre-Implementation
- [ ] Problem clearly defined
- [ ] Pattern benefits documented
- [ ] Alternative approaches considered
- [ ] Team review completed
- [ ] Tests planned

### During Implementation
- [ ] Keep it simple (YAGNI)
- [ ] Write tests first (if complex)
- [ ] Document trade-offs in code comments
- [ ] Follow project conventions

### Post-Implementation
- [ ] Code review completed
- [ ] Documentation updated
- [ ] Tests passing
- [ ] Performance acceptable
- [ ] Team knowledge transfer done

---

## Pattern Refactoring Log

| Date | Original Code | Pattern Applied | Reasoning | Outcome |
|------|---------------|-----------------|-----------|---------|
| YYYY-MM-DD | Direct instantiation | Factory Method | Multiple payment gateways | ✅ Easier to add new gateways |
| | | | | |
| | | | | |

---

## Notes & Lessons Learned

**What worked well:**
- _______________
- _______________

**What to avoid next time:**
- _______________
- _______________

**Pattern combinations that work well together:**
- Repository + Service Layer
- Strategy + Factory
- Command + Memento (undo/redo)
- Observer + Mediator
- _______________

---

## References

- Gang of Four: Design Patterns (1994)
- Martin Fowler: Patterns of Enterprise Application Architecture
- Project-specific patterns: [Link to internal wiki/docs]
