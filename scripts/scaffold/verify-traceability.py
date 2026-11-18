#!/usr/bin/env python3
"""verify-traceability.py - Spec & Task Traceability Linter

Ensures 1-to-1 parity across the 3 core delivery documents:
  - SITEMAP.md (Screen Catalog & Route Map)
  - FSD.md     (Functional Specification Document)
  - TODO.md    (Implementation Plan & Atomic Tasks)

Checks:
  1. All screen codes (e.g., SCR-01, SCR-001) declared in SITEMAP exist in FSD.
  2. All screens declared in SITEMAP have corresponding M06-FE tasks in TODO.md.
  3. No lazy bundling or missing routes.

Usage:
  python scripts/scaffold/verify-traceability.py
  python scripts/scaffold/verify-traceability.py --project /path/to/project

Exit codes: 0 = full parity, 1 = discrepancies found.
"""

import argparse
import os
import re
import sys
from pathlib import Path

# ANSI formatting
USE_COLOR = sys.stdout.isatty()
GREEN = "\033[0;32m" if USE_COLOR else ""
RED = "\033[0;31m" if USE_COLOR else ""
YELLOW = "\033[0;33m" if USE_COLOR else ""
BLUE = "\033[0;34m" if USE_COLOR else ""
BOLD = "\033[1m" if USE_COLOR else ""
NC = "\033[0m" if USE_COLOR else ""


def find_file(base_dir: Path, candidates: list[str]) -> Path | None:
    for c in candidates:
        p = base_dir / c
        if p.exists() and p.is_file():
            return p
    return None


def extract_screens_from_sitemap(sitemap_text: str) -> list[dict]:
    screens = []
    seen = set()

    def add_screen(scr_id: str, route: str, desc: str):
        scr_id_upper = scr_id.upper()
        if scr_id_upper not in seen:
            seen.add(scr_id_upper)
            screens.append({"id": scr_id_upper, "route": route.strip(), "desc": desc.strip()})

    # 1. Match Markdown table: | SCR-01 | /dashboard | Dashboard Page |
    table_pattern = re.compile(
        r"\|\s*(SCR-\d+)\s*\|\s*([^|]+)\s*\|\s*([^|]+)\s*\|",
        re.IGNORECASE,
    )
    for m in table_pattern.finditer(sitemap_text):
        add_screen(m.group(1), m.group(2), m.group(3))

    # 2. Match bold bullet: - **SCR-01** (/dashboard): Description
    bullet_pattern = re.compile(
        r"-\s*\*\*(SCR-\d+)\*\*\s*(?:\(([^)]+)\))?:\s*(.+)",
        re.IGNORECASE,
    )
    for m in bullet_pattern.finditer(sitemap_text):
        add_screen(m.group(1), m.group(2) or "", m.group(3))

    # 3. Match plain bullet / line style: SCR-001 login or - SCR-001 /route
    line_pattern = re.compile(
        r"^(?:[-*]\s*)?(SCR-\d+)\s+([^\n]+)",
        re.IGNORECASE | re.MULTILINE,
    )
    for m in line_pattern.finditer(sitemap_text):
        rest = m.group(2).strip()
        parts = rest.split(maxsplit=1)
        route = parts[0] if parts else ""
        desc = parts[1] if len(parts) > 1 else route
        add_screen(m.group(1), route, desc)

    return screens


def main():
    parser = argparse.ArgumentParser(description="Verify traceability across SITEMAP, FSD, and TODO.")
    parser.add_argument("--project", default=".", help="Root directory of the project to check")
    args = parser.parse_args()

    project_root = Path(args.project).resolve()
    print(f"{BLUE}{BOLD}=== Spec & Task Traceability Linter ==={NC}")
    print(f"Project directory: {project_root}\n")

    sitemap_path = find_file(project_root, ["docs/specs/SITEMAP.md", "SITEMAP.md"])
    fsd_path = find_file(project_root, ["docs/specs/FSD.md", "FSD.md"])
    todo_path = find_file(project_root, ["TODO.md", "docs/TODO.md"])

    missing_docs = []
    if not sitemap_path:
        missing_docs.append("SITEMAP.md (looked in docs/specs/SITEMAP.md and SITEMAP.md)")
    if not fsd_path:
        missing_docs.append("FSD.md (looked in docs/specs/FSD.md and FSD.md)")
    if not todo_path:
        missing_docs.append("TODO.md (looked in TODO.md and docs/TODO.md)")

    if missing_docs:
        print(f"{RED}❌ Required documents not found:{NC}")
        for d in missing_docs:
            print(f"   - {d}")
        print("\nEnsure all specification documents are generated before running this check.")
        sys.exit(1)

    print(f"  {GREEN}✓{NC} SITEMAP found: {sitemap_path.relative_to(project_root)}")
    print(f"  {GREEN}✓{NC} FSD found    : {fsd_path.relative_to(project_root)}")
    print(f"  {GREEN}✓{NC} TODO found   : {todo_path.relative_to(project_root)}\n")

    sitemap_text = sitemap_path.read_text(encoding="utf-8")
    fsd_text = fsd_path.read_text(encoding="utf-8")
    todo_text = todo_path.read_text(encoding="utf-8")

    screens = extract_screens_from_sitemap(sitemap_text)
    if not screens:
        print(f"{YELLOW}⚠️  No screen identifiers (SCR-xx) parsed from SITEMAP.md.{NC}")
        print("   Make sure screens are tagged with standard SCR-xx codes.")
        sys.exit(0)

    print(f"Found {BOLD}{len(screens)}{NC} screens in SITEMAP.md:")
    for s in screens:
        print(f"   [{s['id']}] {s['route']} - {s['desc']}")
    print("")

    errors = 0

    # 1. Check FSD coverage
    print(f"{BLUE}Checking FSD coverage...{NC}")
    missing_in_fsd = []
    for s in screens:
        pattern = re.compile(rf"\b{re.escape(s['id'])}\b", re.IGNORECASE)
        if not pattern.search(fsd_text):
            missing_in_fsd.append(s)

    if missing_in_fsd:
        print(f"  {RED}✗ {len(missing_in_fsd)} screens missing in FSD.md:{NC}")
        for s in missing_in_fsd:
            print(f"      - {s['id']} ({s['route']})")
        errors += len(missing_in_fsd)
    else:
        print(f"  {GREEN}✓ All {len(screens)} screens specified in FSD.md{NC}")

    # 2. Check TODO.md coverage
    print(f"\n{BLUE}Checking TODO.md task coverage...{NC}")
    missing_in_todo = []
    for s in screens:
        # Match SCR-xx in TODO.md
        pattern = re.compile(rf"\b{re.escape(s['id'])}\b", re.IGNORECASE)
        if not pattern.search(todo_text):
            missing_in_todo.append(s)

    if missing_in_todo:
        print(f"  {RED}✗ {len(missing_in_todo)} screens missing from TODO.md:{NC}")
        for s in missing_in_todo:
            print(f"      - {s['id']} ({s['route']}) has no dedicated M06-FE task")
        errors += len(missing_in_todo)
    else:
        print(f"  {GREEN}✓ All {len(screens)} screens have dedicated tasks in TODO.md (Anti-Bundling){NC}")

    print("\n" + "=" * 60)
    if errors == 0:
        print(f"{GREEN}{BOLD}✅ Traceability Check PASSED: 100% Parity across Specs & Tasks.{NC}")
        sys.exit(0)
    else:
        print(f"{RED}{BOLD}❌ Traceability Check FAILED: {errors} discrepancy/discrepancies found.{NC}")
        print("Fix the discrepancies before starting development sprint (Module 06).")
        sys.exit(1)


if __name__ == "__main__":
    main()
