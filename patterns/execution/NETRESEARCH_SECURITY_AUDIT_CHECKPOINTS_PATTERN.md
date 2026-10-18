# Netresearch Security Audit & OWASP/PHP/GitHub Hardening Pattern

> **Module**: M05 (Architecture & Specs) & M07 (Quality Assurance & SIT)  
> **Source**: Adapted from Netresearch Security Audit Skill (`netresearch/security-audit-skill`).  
> **Scope**: 80+ automated security checkpoints, OWASP Top 10 patterns, CWE Top 25 (2025) coverage, CVSS v4.0 scoring, and deep PHP/TYPO3 & GitHub project security scanning.

---

## 1. Automated Security Checkpoints & Patterns
1. **80+ Checkpoints (`checkpoints.yaml`)**: Structured rules covering authentication, input validation, output encoding, data protection, and session handling.
2. **OWASP & CWE Top 25 Coverage**: Standardized mapping for vulnerabilities such as SQL injection, path traversal, XXE, insecure deserialization, and improper file uploads.
3. **CVSS v4.0 Scoring**: Precise severity and risk scoring methodology for reported vulnerabilities.

---

## 2. Platform-Specific & PHP Security Guardrails
- **PHP/TYPO3 Hardening**: Cryptographic best practices (sodium encryption), secure API key management, and modern PHP 8.x security features.
- **PreToolUse Hooks**: Risky command detection scripts preventing unsafe shell execution or secret leakage during agent runs.
