#!/usr/bin/env python3
"""Build an M12 (warranty / SLA) project the gate ACCEPTS, then apply exactly one mutation.

Shape follows templates/08-maintenance-ops/WARRANTY_POLICY_TEMPLATE.md and
templates/essentials/PROJECT_STATE_TEMPLATE.md.

Suspected holes - measured, never assumed:
  coverage-empty       section headings present, every one of them says nothing
  sla-no-numbers       SLA section with no response/resolution figures at all
  warranty-expired     warranty ended last year (still in force?)
  email-placeholder    "[email-support@domain.com]" left unfilled
  solo-runbook-empty   Delivery: solo with a 500-byte RUNBOOK_OPS.md of filler
  incident-partial     Large scale with an incident plan missing escalation names
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))


def find_repo(start):
    cur = start
    for _ in range(12):
        if os.path.isdir(os.path.join(cur, "templates")):
            return cur
        nxt = os.path.dirname(cur)
        if nxt == cur:
            break
        cur = nxt
    raise SystemExit("templates/ not found above %s" % start)


STATE = """# Project State

- **Project**: Kasir POS
- **Scale**: %s
- **Delivery**: %s
- **Current module**: M12
"""

WARRANTY = """# Maintenance Warranty Policy

> Official terms governing coverage, boundaries, service hours, and reporting procedures for bug fixes during the warranty window.

---

## 1. Warranty Parameters
- **System Name**: Kasir POS
- **Client Party**: Toko Nusantara Mandiri
- **Lead Developer**: Damar Wicaksono
- **BAST Reference Number**: BAST/KASIR/XI/2026
- **Warranty Start Date**: 2026-11-06
- **Warranty End Date**: 2027-01-05 (60 calendar days)

---

## 2. Warranty Coverage (What Is Included & Protected)

Warranty applies **EXCLUSIVELY to genuine bug fixes (Bug Fixes)**:
1. Programming logic defects where system behavior deviates from the agreed FSD/PRD specifications.
2. Critical security vulnerabilities in application code written by the Developer.
3. Internal server errors (HTTP 500) triggered during normal workflow paths approved during UAT.

---

## 3. Warranty Exclusions (What Is NOT Included)

The warranty is INAPPLICABLE under the following conditions:
1. New feature requests.
2. Visual design changes (UI layout).
3. User operational errors.
4. External third-party changes.
5. Unauthorized code modification by client teams.

---

## 4. Service Hours & Service Level Agreement (SLA) Matrix

- **Official Service Hours**: **Monday to Friday, 09:00 - 17:00 WIB** (excluding national public holidays)
- **Official Reporting Channel**: Email to support@arunikastudio.example or the designated WhatsApp group

| Issue Classification | Issue Definition | Initial Response Time | Resolution Target |
| :--- | :--- | :---: | :---: |
| **Severity 1 (Critical)** | Entire system down, payment transactions failing completely | **< 2 Business Hours** | **< 8 Business Hours** |
| **Severity 2 (Major)** | Core feature impaired but a workaround exists | **< 8 Business Hours** | **< 48 Business Hours** |
| **Severity 3 (Minor)** | Minor typo, slight cosmetic misalignment | **< 24 Business Hours** | Scheduled in the next release |

---

## 5. Post-Warranty Procedures

Upon expiration of the warranty period, all bug fixes, security updates, and technical support are billed at standard hourly rates under a monthly retainer.
"""

RUNBOOK = """# Operations Runbook

- **Service**: Kasir POS
- **Owner**: Damar Wicaksono
- **Hosting**: Vercel + Neon Postgres

## Health checks
`GET /api/health` returns 200 with the database ping time.

## Restart / redeploy
Run `vercel --prod` from the release branch after confirming the migration report.

## Backup and restore
Neon provides point-in-time restore with a 7 day window; test a restore quarterly.

## Logs
Sentry project `kasir` holds application errors; Vercel runtime logs hold request traces.

## Alerts
Better Stack monitors the health endpoint and notifies the WhatsApp group on two consecutive failures.
"""

INCIDENT = """# Incident Response Plan

## Severity scale
- SEV1: full outage, all tenants affected
- SEV2: core flow broken for some tenants
- SEV3: degraded or cosmetic

## Escalation
On-call rotation: Damar Wicaksono (primary), Ayu Lestari (client contact for business decisions).

## Response targets
- SEV1: acknowledge within 15 minutes, restore within 2 hours
- SEV2: acknowledge within 1 hour, restore within 8 hours

## Communication
Status updates to the client WhatsApp group every 30 minutes during SEV1, and a written post-mortem within 3 working days.

## Owner
Signed by: Damar Wicaksono
"""


def build(dest, kind):
    def w(rel, text):
        p = os.path.join(dest, rel)
        os.makedirs(os.path.dirname(p) or dest, exist_ok=True)
        with open(p, "w", encoding="utf-8") as fh:
            fh.write(text)

    warranty, runbook, incident = WARRANTY, RUNBOOK, INCIDENT
    scale, delivery = "Small", "client"

    if kind == "coverage-empty":
        start = warranty.index("## 2. Warranty Coverage")
        end = warranty.index("## 3. Warranty Exclusions")
        warranty = warranty[:start] + "## 2. Warranty Coverage (What Is Included & Protected)\n\nTo be discussed.\n\n" + warranty[end:]
    elif kind == "sla-no-numbers":
        start = warranty.index("| Issue Classification")
        end = warranty.index("## 5. Post-Warranty")
        warranty = warranty[:start] + "Response times will be agreed per issue.\n\n" + warranty[end:]
    elif kind == "sla-prose-only":
        start = warranty.index("| Issue Classification")
        end = warranty.index("## 5. Post-Warranty")
        warranty = warranty[:start] + "Severity 1 issues are handled first, then Severity 2, then Severity 3.\n\n" + warranty[end:]
    elif kind == "warranty-expired":
        warranty = warranty.replace("**Warranty End Date**: 2027-01-05 (60 calendar days)",
                                    "**Warranty End Date**: 2025-01-05 (60 calendar days)")
    elif kind == "email-placeholder":
        warranty = warranty.replace("support@arunikastudio.example", "[email-support@domain.com]")
    elif kind == "solo-runbook-empty":
        delivery = "solo"
        runbook = "# Operations Runbook\n\n" + ("Operations are handled as needed.\n" * 20)
    elif kind == "incident-partial":
        scale = "Large"
        start = incident.index("## Escalation")
        end = incident.index("## Response targets")
        incident = incident[:start] + "## Escalation\n\nWe will handle it when it happens.\n\n" + incident[end:]
    elif kind != "base":
        raise SystemExit("unknown kind: %s" % kind)

    w("docs/pm/PROJECT_STATE.md", STATE % (scale, delivery))
    if delivery == "solo":
        w("docs/pm/RUNBOOK_OPS.md", runbook)
    else:
        w("docs/pm/WARRANTY_POLICY.md", warranty)
    if scale == "Large":
        w("docs/pm/INCIDENT_RESPONSE.md", incident)


if __name__ == "__main__":
    build(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else "base")
    print("built", sys.argv[2] if len(sys.argv) > 2 else "base")
