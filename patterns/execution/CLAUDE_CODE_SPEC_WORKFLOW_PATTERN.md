# Claude Code Spec-Driven Development & Context Optimization Pattern

> **Module**: M05 (Architecture & Specs) & M06 (Development Execution)  
> **Source**: Adapted from a published Claude-Code spec-driven workflow (context optimization system).  
> **Scope**: Structured feature development pipelines (`Requirements → Design → Tasks → Implementation`), streamlined bug-fix workflows (`Report → Analyze → Fix → Verify`), steering context documents (`product.md`, `tech.md`, `structure.md`), and token-efficient hierarchical context sharing (60-80% reduction via bulk loading).

---

## 1. Spec-Driven Development & Bug-Fix Pipelines

### A. Spec Workflow (New Features)
1. **Requirements**: Define user stories and precise acceptance criteria.
2. **Design**: Establish technical architecture, data flow, and Mermaid diagrams.
3. **Tasks**: Break down implementation into atomic, agent-friendly task lists.
4. **Implementation**: Execute tasks incrementally via specialized execution agents (`spec-task-executor`).

### B. Bug Fix Workflow (Quick Resolution)
1. **Report** (`/bug-create`): Document bug symptoms and reproduce steps.
2. **Analyze** (`/bug-analyze`): Investigate root cause and isolate affected symbols.
3. **Fix** (`/bug-fix`): Implement targeted patch.
4. **Verify** (`/bug-verify`): Confirm resolution with regression tests.

---

## 2. Steering Documents & Project Context

Persistent project steering documents govern all development cycles and prevent architectural drift:
* **`product.md`**: Core business goals, target audience, and feature scope.
* **`tech.md`**: Tech stack versions, libraries, and architectural conventions.
* **`structure.md`**: Repository directory layout and file-naming rules.

---

## 3. Token Optimization & Hierarchical Context Management

To prevent context exhaustion and reduce token overhead by 60–80%:
* **Triple Optimization Commands**: Use bulk loaders (`get-steering-context`, `get-spec-context`, `get-template-context`) instead of fetching individual files repeatedly.
* **Hierarchical Distribution**: Main agents load full steering and spec context once, then distribute only selective portions (Requirements + Design) to sub-agents without reloading.
