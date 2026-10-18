# Code Patterns — Indonesia-Specific

> The 13 generic engineering patterns (Zod, caching, N+1, auth, testing, CI/CD, git, observability, API conventions, DB seeding, error boundaries) were archived to `archive/patterns/` — agents already know these cold; loading them wasted tokens. Kept here: Indonesia/domain-specific patterns only.

| Pattern | File |
|:---|:---|
| Indonesian payment gateways (Midtrans, Xendit, QRIS, idempotent webhooks) | [`payments/INDONESIA_PAYMENT_GATEWAYS.md`](./payments/INDONESIA_PAYMENT_GATEWAYS.md) |
| UU PDP No. 27/2022 compliance | [`compliance/UU_PDP_COMPLIANCE.md`](./compliance/UU_PDP_COMPLIANCE.md) |
| Rupiah/WIB localization, tax rounding | [`localization/I18N_INDONESIA.md`](./localization/I18N_INDONESIA.md) |
| Offline-first sync & mutation queue | [`offline/OFFLINE_FIRST_SYNC.md`](./offline/OFFLINE_FIRST_SYNC.md) |
| Access Control Patterns (RBAC, ABAC, ReBAC & Postgres RLS) | [`security/ACCESS_CONTROL_PATTERNS.md`](./security/ACCESS_CONTROL_PATTERNS.md) |
| Edge Security, DDoS & WAF Protection (Cloudflare Pattern) | [`security/EDGE_SECURITY_CLOUDFLARE.md`](./security/EDGE_SECURITY_CLOUDFLARE.md) |
| Solo Product Discovery & Strategy Playbook (OST, RAT, 7 Powers) | [`product/SOLO_DISCOVERY_PLAYBOOK.md`](./product/SOLO_DISCOVERY_PLAYBOOK.md) |
| UI Component Taxonomy & Architecture (Modern UI System) | [`ui/UI_COMPONENT_TAXONOMY.md`](./ui/UI_COMPONENT_TAXONOMY.md) |
| Motion Design & Interactive Animation Taxonomy (60+ Effects) | [`ui/MOTION_DESIGN_TAXONOMY.md`](./ui/MOTION_DESIGN_TAXONOMY.md) |
| Scroll-Scrubbed Cinematic World Pattern (Apple-Style Fly-Through) | [`ui/SCROLL_SCRUBBED_WORLD_PATTERN.md`](./ui/SCROLL_SCRUBBED_WORLD_PATTERN.md) |
| Responsive Design Priority Pattern (Mobile-First vs. Desktop-First) | [`ui/RESPONSIVE_DESIGN_PRIORITY_PATTERN.md`](./ui/RESPONSIVE_DESIGN_PRIORITY_PATTERN.md) |
| Indonesian Legal Hierarchy & Grounded AI Citation | [`compliance/INDONESIAN_LEGAL_HIERARCHY_PATTERN.md`](./compliance/INDONESIAN_LEGAL_HIERARCHY_PATTERN.md) |
| Legal Data Modeling & PostgreSQL LTREE Architecture | [`architecture/LEGAL_DATA_MODELING_LTREE_PATTERN.md`](./architecture/LEGAL_DATA_MODELING_LTREE_PATTERN.md) |
| PostgreSQL Native Job Queue (`FOR UPDATE SKIP LOCKED`) | [`architecture/POSTGRES_JOB_QUEUE_SKIP_LOCKED_PATTERN.md`](./architecture/POSTGRES_JOB_QUEUE_SKIP_LOCKED_PATTERN.md) |
| Repository-Backed Architecture Diagram Pattern | [`architecture/REPOSITORY_BACKED_ARCHITECTURE_DIAGRAM_PATTERN.md`](./architecture/REPOSITORY_BACKED_ARCHITECTURE_DIAGRAM_PATTERN.md) |
| Database Schema & Query Optimization Pattern | [`architecture/DATABASE_SCHEMA_AND_QUERY_OPTIMIZATION_PATTERN.md`](./architecture/DATABASE_SCHEMA_AND_QUERY_OPTIMIZATION_PATTERN.md) |
| Realtime Communication & Network Protocols Pattern (SSE vs. WebSocket vs. Polling) | [`architecture/REALTIME_COMMUNICATION_AND_API_PROTOCOLS_PATTERN.md`](./architecture/REALTIME_COMMUNICATION_AND_API_PROTOCOLS_PATTERN.md) |
| S.U.P.E.R Architecture & Closed-Loop Adaptive Control Pattern | [`architecture/SUPER_ARCHITECTURE_AND_ADAPTIVE_CONTROL_PATTERN.md`](./architecture/SUPER_ARCHITECTURE_AND_ADAPTIVE_CONTROL_PATTERN.md) |
| SVG Technical & Architecture Diagram Standard Pattern | [`architecture/SVG_TECHNICAL_DIAGRAM_STANDARD_PATTERN.md`](./architecture/SVG_TECHNICAL_DIAGRAM_STANDARD_PATTERN.md) |
| Caching Strategies & Data Consistency Pattern (Cache-Aside, Stampede Defense & CAP) | [`architecture/CACHING_STRATEGIES_AND_DATA_CONSISTENCY_PATTERN.md`](./architecture/CACHING_STRATEGIES_AND_DATA_CONSISTENCY_PATTERN.md) |
| System Design Methodology & Interview Problem-Solving Pattern | [`architecture/SYSTEM_DESIGN_METHODOLOGY_PATTERN.md`](./architecture/SYSTEM_DESIGN_METHODOLOGY_PATTERN.md) |
| RESTful API Design & Resource Modeling Pattern | [`architecture/RESTFUL_API_DESIGN_PATTERN.md`](./architecture/RESTFUL_API_DESIGN_PATTERN.md) |
| API Design Guidelines & Best Practices Cheat Sheet Pattern | [`architecture/API_DESIGN_CHEAT_SHEET_PATTERN.md`](./architecture/API_DESIGN_CHEAT_SHEET_PATTERN.md) |
| Dwyl Learn API Design & Product-First API Principles Pattern | [`architecture/DWYL_API_DESIGN_PATTERN.md`](./architecture/DWYL_API_DESIGN_PATTERN.md) |
| Full-Stack Execution Roadmap & Milestone Breakdown Pattern | [`execution/FULLSTACK_EXECUTION_ROADMAP_PATTERN.md`](./execution/FULLSTACK_EXECUTION_ROADMAP_PATTERN.md) |
| MERN Stack Full-Stack Curriculum & Project Breakdown Pattern | [`execution/MERN_STACK_ROADMAP_PATTERN.md`](./execution/MERN_STACK_ROADMAP_PATTERN.md) |
| AI Full-Stack Delivery Workflow & Multi-Role Dispatch Pattern | [`execution/AI_FULLSTACK_DELIVERY_WORKFLOW_PATTERN.md`](./execution/AI_FULLSTACK_DELIVERY_WORKFLOW_PATTERN.md) |
| Claude Code Spec-Driven Development & Context Optimization Pattern | [`execution/CLAUDE_CODE_SPEC_WORKFLOW_PATTERN.md`](./execution/CLAUDE_CODE_SPEC_WORKFLOW_PATTERN.md) |
| Jeffallan Claude Skills & Specialized Pair Programmer Pattern | [`execution/CLAUDE_SKILLS_SPECIALIZED_PAIR_PROGRAMMER_PATTERN.md`](./execution/CLAUDE_SKILLS_SPECIALIZED_PAIR_PROGRAMMER_PATTERN.md) |
| PaperOrchestra Multi-Agent Automated AI Research Paper Writing Pattern | [`execution/PAPER_ORCHESTRA_RESEARCH_WRITING_PATTERN.md`](./execution/PAPER_ORCHESTRA_RESEARCH_WRITING_PATTERN.md) |
| Altimate AI Data Engineering & dbt/Snowflake Analytics Engineering Pattern | [`execution/DATA_ENGINEERING_DBT_SNOWFLAKE_PATTERN.md`](./execution/DATA_ENGINEERING_DBT_SNOWFLAKE_PATTERN.md) |
| Vaquar Khan Data Engineering Agent Skills & Production Reliability Pattern | [`execution/DATA_ENGINEERING_AGENT_SKILLS_RELIABILITY_PATTERN.md`](./execution/DATA_ENGINEERING_AGENT_SKILLS_RELIABILITY_PATTERN.md) |
| Riekelt Technical Writer Engineering Writing & Anti-AI-Slop Prose Pattern | [`execution/TECHNICAL_WRITER_ENGINEERING_PROSE_PATTERN.md`](./execution/TECHNICAL_WRITER_ENGINEERING_PROSE_PATTERN.md) |
| Baraa SQL Data Warehouse & Medallion Architecture Pattern | [`execution/SQL_DATA_WAREHOUSE_MEDALLION_PATTERN.md`](./execution/SQL_DATA_WAREHOUSE_MEDALLION_PATTERN.md) |
| Patterns Devkit Component-Based Data Graphs & SDK Pattern | [`execution/PATTERNS_DEVKIT_COMPONENT_DATA_GRAPHS_PATTERN.md`](./execution/PATTERNS_DEVKIT_COMPONENT_DATA_GRAPHS_PATTERN.md) |
| Petr Kindlmann QA Skills & AI-Augmented Quality Assurance Pattern | [`execution/QA_SKILLS_AI_AUGMENTED_QUALITY_ASSURANCE_PATTERN.md`](./execution/QA_SKILLS_AI_AUGMENTED_QUALITY_ASSURANCE_PATTERN.md) |
| AI Agent System Prompt Engineering & Execution Guardrails Pattern | [`architecture/AI_AGENT_SYSTEM_PROMPT_ENGINEERING_PATTERN.md`](./architecture/AI_AGENT_SYSTEM_PROMPT_ENGINEERING_PATTERN.md) |
| Fault Tolerance, Resilience, & Graceful Degradation Pattern | [`resilience/FAULT_TOLERANCE_AND_DEGRADATION_PATTERN.md`](./resilience/FAULT_TOLERANCE_AND_DEGRADATION_PATTERN.md) |
| Solo Architecture Guardrails (The Boring Tech Ladder vs Over-Engineering) | [`architecture/SOLO_ARCHITECTURE_GUARDRAILS.md`](./architecture/SOLO_ARCHITECTURE_GUARDRAILS.md) |
| Exact-Build Verification & Closed-Loop QA (Artifact Pinning & 4-State Lifecycle) | [`qa/EXACT_BUILD_VERIFICATION_PATTERN.md`](./qa/EXACT_BUILD_VERIFICATION_PATTERN.md) |

Archived generic patterns remain available at `archive/patterns/` (git history intact) if a rare case needs them.
