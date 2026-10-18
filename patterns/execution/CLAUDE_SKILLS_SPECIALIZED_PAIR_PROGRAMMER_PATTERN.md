# Jeffallan Claude Skills & Specialized Pair Programmer Pattern

> **Module**: M06 (Development Execution) & M07 (Quality Assurance)  
> **Source**: Adapted from `Jeffallan/claude-skills` (67 Specialized Skills for Full-Stack Developers & 9 Epic Lifecycle Workflows).  
> **Scope**: Modular skill activation frameworks, multi-skill execution combinations (Feature Development, Bug Investigation, Security Hardening), context engineering via `/common-ground`, and Jira/Confluence Atlassian MCP integration.

---

## 1. Modular Skill Activation & Multi-Skill Workflows

### A. Context-Aware Activation
Skills activate automatically based on user prompts, loading specialized domain references without cluttering the global context window.

### B. Multi-Skill Execution Combinations
* **Feature Development**: `Feature Forge` → `Architecture Designer` → `Fullstack Guardian` → `Test Master` → `DevOps Engineer`
* **Bug Investigation**: `Debugging Wizard` → `Framework Expert` → `Test Master` → `Code Reviewer`
* **Security Hardening**: `Secure Code Guardian` → `Security Reviewer` → `Test Master`

---

## 2. Context Engineering (`/common-ground`)

* **Surface Hidden Assumptions**: Use `/common-ground` to force Claude to state and validate its underlying assumptions about project architecture, state management, and environment before writing code.
* **Reduces Hallucination**: Aligns AI intent directly with the developer's exact mental model and codebase constraints.

---

## 3. Epic Lifecycle Workflow Commands (Atlassian MCP Integration)

Managing large-scale epics from discovery to retrospective through 9 workflow commands integrated with Jira and Confluence:
1. **Discovery & Scoping**
2. **Architecture & Refinement**
3. **Task Breakdown**
4. **Implementation & Testing**
5. **Code Review & Security**
6. **UAT & Deployment**
7. **Retrospective & Documentation**
