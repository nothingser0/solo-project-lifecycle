# Patterns Devkit Component-Based Data Graphs & SDK Pattern

> **Module**: M05 (Architecture & Specs) & M06 (Development Execution)  
> **Source**: Adapted from Patterns Devkit (`patterns-app/patterns-devkit`).  
> **Scope**: Building modular, versioned data pipelines and graphs from reusable Python and SQL components connected via `graph.yml` and platform SDK primitives (`Table`, `Parameter`, `State`).

---

## 1. Graph Structure & Component Architecture
1. **`graph.yml`**: Central orchestrator defining pipeline nodes, inputs, outputs, and table linkages.
2. **Reusable Python & SQL Nodes**: Stateless or stateful processing units reading and writing through typed table handles (`patterns.Table`).
3. **SDK Primitives**:
   - `Table(name, mode="r"|"w")`: Typed data handle supporting `.init()`, `.read()`, `.append()`, `.upsert()`, and `.replace()`.
   - `Parameter(name, type, default)`: Strongly typed pipeline configuration parameters.
   - `State`: Persistent execution state across graph runs.

---

## 2. CLI Operations & Deployment
- Rapid component creation (`patterns create node`), secret management (`patterns create secret`), and cloud synchronization (`patterns upload`).
