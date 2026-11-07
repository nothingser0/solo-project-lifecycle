#!/usr/bin/env python3
"""Build an M10 project the gate ACCEPTS, then apply exactly one mutation.

Templates drive the shape: templates/07-release-handover/DEPLOYMENT_PROTOCOL_TEMPLATE.md and
GO_LIVE_REPORT_TEMPLATE.md. Paths are resolved from this file, never absolute: an absolute path
that only exists on my machine already broke M07 on CI.

Probed holes (measure before fixing):
  go-whitespace      "Human decision:  GO" (two spaces) / trailing blank - is the GO line tolerant?
  go-lowercase       "human decision: GO" - is the label case-insensitive?
  go-commented       "- Human decision: GO" - a bulleted/comment line is not the decision record
  pvt-fail-prose     "| PVT-01 | checkout | 200 | FAIL (retested, now PASS) | PASS |" - is a FAIL
                     inside the Actual cell caught when Status says PASS?
  pvt-no-status-row  a PVT row whose status column is blank
  section-level1     "## 4. Post-Deployment Verification" demoted to "# 4. ..."
  inputs-blank-pic   "Inputs-Received: access handed over from  on 2026-11-06" - no PIC name
  rollback-large     Scale: Large with no ROLLBACK_PLAN.md
  signer-role        "Lead Engineer: Wahyu Nur Sagita (AI-assisted)" - model mention in a name
  status-trailing    "Release status: LIVE " with trailing spaces
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


REPO = find_repo(HERE)
TPL = os.path.join(REPO, "templates", "07-release-handover")

PROTOCOL = """# Production Deployment Protocol

> Project-specific M10 runbook for Kasir POS (Toko Sinar Jaya).

## 1. Release

- **Project / version**: Kasir POS v1.4.0
- **Source branch, commit, artifact**: main @ 9f3c1ab, artifact kasir-1.4.0.tar.gz
- **Target platform / environment**: Vercel (production), Neon Postgres (production)
- **Release owner / human operator**: Wahyu Nur Sagita
- **Approved window and timezone**: 2026-11-06 21:00-22:00 WIB
- **Release freeze rule / approved exception**: none requested
- **M09 UAT decision**: docs/pm/UAT_SIGNOFF_REPORT.md - APPROVED 2026-11-06
- **CI / build / security checks required by project policy**: GitHub Actions run 42351383767 (green)
- **Release notes / changelog**: CHANGELOG.md v1.4.0
- **Human Go/No-Go**: Wahyu Nur Sagita, GO, 2026-11-06

## 2. Production Access Inputs (gate-enforced)

Inputs-Received: production deploy access from Budi Santoso on 2026-11-06
- **Credentials**: held by Wahyu Nur Sagita in the approved secret manager; reference only
- **DNS / domain / platform access owner**: Budi Santoso (Toko Sinar Jaya)
- **Payment / third-party production mode**: Midtrans production keys held by Budi Santoso
- **Production action executed by**: Wahyu Nur Sagita

## 3. Preflight

- [x] Required UAT and release approvals are recorded.
- [x] CI/build and required security checks meet project policy.
- [x] Release commit/artifact is immutable and matches the approved candidate.
- [x] Production secrets are configured through the approved secret manager.
- [x] Backup/snapshot and recovery procedure are ready.
- [x] DNS, TLS, billing prerequisites are checked.
- [x] Freeze exceptions and expected user impact are communicated.

## 4. Deploy (Human Operator)

The human operator ran `vercel --prod` and merged the release tag. No credentials recorded here.

## 5. Post-Deployment Smoke

Login, product listing, and a cash sale were exercised by the human operator on production.
"""

GOLIVE = """# Go-Live Verification Report (PVT & Production Cutover)

> **Purpose**: Record release identity, human decision, deployment evidence, post-deployment checks, telemetry, and recovery readiness.
> **Module**: M10 - Production Deployment

## 1. Release and Environment

| Attribute | Value / evidence |
| :--- | :--- |
| Project / release | Kasir POS v1.4.0 |
| Source commit / artifact ID | 9f3c1ab |
| Deployment target / environment | Vercel production |
| Release owner / human operator | Wahyu Nur Sagita |
| Deployment window / timezone | 2026-11-06 21:00-22:00 WIB |
| CI / build result | GitHub Actions 42351383767 green |
| Production URL | https://kasir.tokosinarjaya.id |
| Domain / TLS result | Let's Encrypt, valid until 2027-02-04 |

## 2. Release Decision and Change Controls

Human decision: GO
Decision maker and date: Wahyu Nur Sagita / 2026-11-06
- **M09 UAT decision**: APPROVED 2026-11-06
- **Release freeze / exception**: none
- **Release notes / changelog**: CHANGELOG.md v1.4.0
- **Outstanding risks / exceptions**: none

## 3. Rollout

- **Strategy**: standard
- **Steps and observation period**: deploy, 30 minute observation
- **Stop / abort triggers**: error rate above 2 percent for 5 minutes
- **Rollout result**: completed
- **Traffic or cohort progression**: all traffic

## 4. Post-Deployment Verification (PVT)

| Test ID | Critical flow / check | Expected result | Actual result | Status (PASS / FAIL / BLOCKED / N/A) | Evidence / build |
| :--- | :--- | :--- | :--- | :--- | :--- |
| PVT-01 | Login as cashier | dashboard renders | dashboard rendered | PASS | artifacts/pvt-01.png |
| PVT-02 | Record a cash sale | receipt printed | receipt printed | PASS | artifacts/pvt-02.png |
| PVT-03 | Product listing paginates | 25 rows per page | 25 rows per page | PASS | artifacts/pvt-03.png |

## 5. Monitoring and Recovery

- **Error tracking / logs / metrics**: Sentry project kasir, checked after cutover
- **Health / uptime checks**: /api/health returns 200, monitored by Better Stack
- **Alert path**: test alert sent to WhatsApp, receipt at artifacts/alert.png
- **Observation period and service targets**: 30 minutes, p95 under 800 ms
- **Rollback / recovery runbook**: docs/pm/ROLLBACK_PLAN.md
- **Recovery triggers and owner**: error rate above 2 percent / Wahyu Nur Sagita
- **Recovery time**: not exercised in production, staging restore took 12 minutes on 2026-11-02
- **Backup / restore and data migration limits**: Neon point-in-time restore, 7 day window

## 6. Verification Attestation

Release status: LIVE
Verification performed by: Wahyu Nur Sagita
- **Date**: 2026-11-06
- **Summary and evidence references**: artifacts/pvt-01.png, artifacts/pvt-02.png

This report records evidence; it does not delegate production deployment or release approval to an agent.
"""

# Matches templates/essentials/PROJECT_STATE_TEMPLATE.md: get_field reads "- **Scale**: ..." lines,
# not table rows, so a table here would silently read as "no scale recorded".
STATE = """# Project State

- **Project**: Kasir POS
- **Scale**: %s
- **Current module**: M10
"""


def build(dest, kind):
    def w(rel, text):
        p = os.path.join(dest, rel)
        os.makedirs(os.path.dirname(p) or dest, exist_ok=True)
        with open(p, "w", encoding="utf-8") as fh:
            fh.write(text)

    proto, report, scale = PROTOCOL, GOLIVE, "Small"

    if kind == "go-whitespace":
        report = report.replace("Human decision: GO\n", "Human decision:  GO\n")
    elif kind == "go-lowercase":
        report = report.replace("Human decision: GO\n", "human decision: GO\n")
    elif kind == "go-commented":
        report = report.replace("Human decision: GO\n", "- Human decision: GO\n")
    elif kind == "pvt-fail-prose":
        report = report.replace(
            "| PVT-01 | Login as cashier | dashboard renders | dashboard rendered | PASS | artifacts/pvt-01.png |",
            "| PVT-01 | Login as cashier | dashboard renders | FAIL (retested, now PASS) | PASS | artifacts/pvt-01.png |",
        )
    elif kind == "pvt-no-status-row":
        report = report.replace(
            "| PVT-03 | Product listing paginates | 25 rows per page | 25 rows per page | PASS | artifacts/pvt-03.png |",
            "| PVT-03 | Product listing paginates | 25 rows per page | 25 rows per page |  | artifacts/pvt-03.png |",
        )
    elif kind == "section-level1":
        report = report.replace("## 4. Post-Deployment Verification (PVT)", "# 4. Post-Deployment Verification (PVT)")
    elif kind == "inputs-blank-pic":
        proto = proto.replace(
            "Inputs-Received: production deploy access from Budi Santoso on 2026-11-06",
            "Inputs-Received: production deploy access from  on 2026-11-06",
        )
    elif kind == "rollback-large":
        scale = "Large"
    elif kind == "signer-role":
        report = report.replace(
            "Verification performed by: Wahyu Nur Sagita",
            "Verification performed by: Wahyu Nur Sagita (Claude Agent)",
        )
    elif kind == "status-trailing":
        report = report.replace("Release status: LIVE\n", "Release status: LIVE \n")
    elif kind != "base":
        raise SystemExit("unknown kind: %s" % kind)

    w("docs/pm/DEPLOYMENT_PROTOCOL.md", proto)
    w("docs/pm/GO_LIVE_REPORT.md", report)
    w("docs/pm/PROJECT_STATE.md", STATE % scale)


if __name__ == "__main__":
    build(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else "base")
    print("built", sys.argv[2] if len(sys.argv) > 2 else "base")
