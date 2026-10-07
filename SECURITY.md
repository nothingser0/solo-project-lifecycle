# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.1.x   | :white_check_mark: |
| 1.0.x   | :x:                |

---

## 1. Zero Secrets Policy

This repository is a template and workflow framework. It **MUST NEVER** contain:
- Production private keys or live API credentials.
- Real client databases or unanonymized personal data (UU PDP No. 27/2022 compliance).
- Hardcoded authentication tokens.

All examples must utilize explicit placeholders such as `<REPLACE_ME_PRODUCTION_KEY>` or standard RFC 2606 domain names (`example.com`).

---

## 2. Reporting a Vulnerability

If you discover a security vulnerability in this framework or any of its scripts:

1. **Do NOT** open a public GitHub issue.
2. Email the maintainer at `security@example.com` (or submit via GitHub Private Vulnerability Reporting).
3. Include:
   - Affected file, script, or template
   - Proof of concept (PoC) or attack vector description
   - Proposed mitigation or patch

We appreciate responsible disclosure and aim to acknowledge reports within 48 hours.
