#!/usr/bin/env python3
"""Verify that the evidence cited in a completion report actually exists on disk.

Framework-agnostic. The problem this solves is universal: an agent writes
"verified, screenshot at artifacts/x.png" and the file is missing, zero bytes,
or from a previous run. This script makes the citation checkable.

    python3 scripts/verify/check_evidence.py <project-dir>
    python3 scripts/verify/check_evidence.py <project-dir> --report artifacts/final-evidence.md
    python3 scripts/verify/check_evidence.py <project-dir> --manifest artifacts/evidence.json

Modes
  manifest  Strict. Verifies a declared capture set from ONE run: run id, distinct
            viewport/state pairs, report freshness, and the artifacts each capture
            points at. This is the only mode that can establish coverage.
  report    Lenient. Extracts cited paths from a markdown report and checks they
            exist and are not stubs. Cannot prove freshness or coverage — say so
            when reporting the result.

Exit 0 when every cited artifact resolves and is not a stub; exit 1 otherwise,
with one line per failure.

Adapted from majidmanzarpour/threejs-game-skills (MIT) — the manifest/capture-set
model and the stub-size floors. Rewritten to be game-agnostic.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import shlex
import sys
from pathlib import Path
from urllib.parse import unquote, urlsplit

# Extensions worth resolving, with the byte floor below which a file is a stub
# rather than evidence. A 0-byte PNG resolves but proves nothing; the floors sit
# just above "empty or truncated write" for each format.
MEDIA_FLOORS = {
    ".png": 1024, ".jpg": 1024, ".jpeg": 1024, ".webp": 512, ".gif": 512,
    ".svg": 128, ".pdf": 1024,
    ".mp4": 1024, ".webm": 1024, ".mov": 1024,
    ".mp3": 512, ".wav": 512, ".ogg": 512, ".m4a": 512,
    ".json": 2, ".log": 16, ".txt": 8, ".md": 8,
    ".har": 1024, ".zip": 256,
    ".glb": 1024, ".gltf": 512, ".fbx": 1024, ".obj": 512,
}

# A path-like token: at least one directory separator, ending in a known
# extension. Requiring the separator keeps prose words with dots out.
PATH_TOKEN = re.compile(
    r"(?<![\w/.:~-])((?:/|~/|\.{1,2}/)?(?:[\w.-]+/)+[\w.-]+\.(?:"
    + "|".join(ext.lstrip(".") for ext in MEDIA_FLOORS)
    + r"))(?![\w/])",
    re.IGNORECASE,
)
MARKDOWN_LINK = re.compile(r"!?\[[^\]\n]*\]\(\s*(?:<([^>\n]+)>|([^\n]+?))\s*\)")
INLINE_CODE = re.compile(r"`([^`\n]+)`")
COMMAND_NAMES = {"python", "python3", "node", "npm", "npx", "pnpm", "yarn", "uv",
                 "bash", "sh", "zsh", "powershell", "pwsh", "php", "composer",
                 "go", "cargo", "dotnet", "pytest", "vitest", "playwright"}

# Paths that name tooling rather than the project's own evidence.
SKIP_PREFIXES = ("node_modules/", "scripts/", "tests/", "vendor/", ".git/")


def find_paths(report_text: str) -> list[str]:
    """Read link/code destinations intact, then unquoted path tokens."""
    candidates: list[tuple[int, str]] = []
    remaining = list(report_text)
    for pattern in (MARKDOWN_LINK, INLINE_CODE):
        for match in pattern.finditer("".join(remaining)):
            raw = next(g for g in match.groups() if g is not None).strip()
            if pattern is INLINE_CODE:
                try:
                    words = shlex.split(raw)
                except ValueError:
                    words = []
                is_command = bool(words) and (
                    words[0] in COMMAND_NAMES or any(w.startswith("--") for w in words[1:])
                )
                if is_command or raw.startswith(("https://", "http://")):
                    remaining[match.start():match.end()] = " " * (match.end() - match.start())
                    continue
            if pattern is MARKDOWN_LINK:
                raw = re.sub(r"\s+[\"'].*[\"']$", "", raw)
                parsed = urlsplit(raw)
                if parsed.scheme or parsed.netloc:
                    raw = ""
                else:
                    raw = unquote(parsed.path)
            if Path(raw).suffix.lower() in MEDIA_FLOORS:
                candidates.append((match.start(), raw))
                remaining[match.start():match.end()] = " " * (match.end() - match.start())
            elif pattern is MARKDOWN_LINK:
                remaining[match.start():match.end()] = " " * (match.end() - match.start())
    candidates.extend((m.start(), m.group(1)) for m in PATH_TOKEN.finditer("".join(remaining)))
    return list(dict.fromkeys(
        c for _, c in sorted(candidates)
        if not c.lower().startswith(SKIP_PREFIXES)
    ))


def resolve(candidate: str, roots: list[Path], *, allow_cwd: bool = True) -> Path | None:
    expanded = Path(candidate).expanduser()
    if expanded.is_absolute():
        return expanded if expanded.exists() else None
    for root in roots:
        resolved = root / expanded
        if resolved.exists():
            return resolved
    direct = Path(candidate)
    return direct if allow_cwd and direct.exists() else None


def check_artifacts(paths: list[str], roots: list[Path], *, allow_cwd: bool = True):
    failures: list[str] = []
    confirmed: list[str] = []
    for candidate in paths:
        resolved = resolve(candidate, roots, allow_cwd=allow_cwd)
        if resolved is None:
            failures.append(f"cited path does not exist: {candidate}")
            continue
        if not resolved.is_file():
            failures.append(f"cited path is not a file: {candidate}")
            continue
        try:
            size = resolved.stat().st_size
        except OSError as exc:
            failures.append(f"cannot inspect {candidate}: {exc}")
            continue
        floor = MEDIA_FLOORS.get(resolved.suffix.lower(), 1)
        if size < floor:
            failures.append(f"cited path is a stub ({size} bytes, expected >= {floor}): {candidate}")
            continue
        confirmed.append(f"{candidate} ({size:,} bytes)")
    return confirmed, failures


def read_json_object(path: Path) -> dict:
    data = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(data, dict):
        raise ValueError("expected a JSON object")
    return data


def check_manifest(project: Path, manifest_path: Path):
    """Strict mode: one declared capture set, one run id, real artifacts."""
    failures: list[str] = []
    confirmed: list[str] = []

    try:
        manifest = read_json_object(manifest_path)
    except (OSError, ValueError, UnicodeDecodeError) as exc:
        return [], [f"cannot read manifest {manifest_path}: {exc}"]

    run_id = manifest.get("runId")
    if not isinstance(run_id, str) or not run_id.strip():
        failures.append("manifest has no 'runId' — evidence must be attributable to one run")
        run_id = "?"

    captures = manifest.get("captures")
    if not isinstance(captures, list) or not captures:
        failures.append("manifest 'captures' must be a non-empty list")
        captures = []

    seen_pairs: set[tuple[str, str]] = set()
    for i, cap in enumerate(captures):
        if not isinstance(cap, dict):
            failures.append(f"captures[{i}] is not an object")
            continue
        mode = cap.get("mode")
        state = cap.get("state")
        report = cap.get("report")
        if mode not in ("desktop", "mobile", "tablet", "print"):
            failures.append(f"captures[{i}].mode must be a known viewport (got {mode!r})")
        if state is not None and (not isinstance(state, str) or not state.strip()):
            failures.append(f"captures[{i}].state must be a name or null")
        pair = (str(mode), str(state))
        if pair in seen_pairs:
            failures.append(f"captures[{i}] duplicates viewport/state {pair}")
        seen_pairs.add(pair)
        if not isinstance(report, str) or not report.strip():
            failures.append(f"captures[{i}] has no report path")
            continue
        ok, bad = check_artifacts([report], [project], allow_cwd=False)
        if bad:
            failures.extend(f"captures[{i}]: {b}" for b in bad)
            continue
        # Freshness: a report written by a different run cannot prove this one.
        try:
            payload = read_json_object(resolve(report, [project]) or Path(report))
        except (OSError, ValueError, UnicodeDecodeError) as exc:
            failures.append(f"captures[{i}] report is unreadable JSON ({exc}): {report}")
            continue
        report_run = payload.get("runId")
        if report_run is not None and report_run != run_id:
            failures.append(
                f"captures[{i}] report is from run {report_run!r}, not {run_id!r} — "
                "relabelled old evidence is not evidence"
            )
            continue
        if payload.get("ok") is False:
            failures.append(f"captures[{i}] report records a failed check: {report}")
            continue
        confirmed.append(f"{report} ({mode}/{state or 'default'})")

    for artifact in manifest.get("artifacts") or []:
        if not isinstance(artifact, str) or not artifact.strip():
            failures.append("manifest 'artifacts' contains a non-string entry")
            continue
        ok, bad = check_artifacts([artifact], [project], allow_cwd=False)
        confirmed.extend(ok)
        failures.extend(bad)

    return confirmed, failures


def check_report(project: Path, report_path: Path):
    """Lenient mode: cited paths must exist and not be stubs."""
    try:
        text = report_path.read_text(encoding="utf-8")
    except (OSError, UnicodeDecodeError) as exc:
        return [], [f"cannot read report {report_path}: {exc}"]
    cited = find_paths(text)
    if not cited:
        return [], [f"no artifact paths cited in {report_path} — a report with no evidence cites nothing"]
    return check_artifacts(cited, [project, report_path.parent])


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("project", nargs="?", default=".", help="project directory (default: .)")
    ap.add_argument("--manifest", help="strict mode: artifacts/evidence.json")
    ap.add_argument("--report", help="lenient mode: a markdown completion report")
    a = ap.parse_args()

    project = Path(a.project).expanduser().resolve()
    if not project.is_dir():
        print(f"❌ project directory not found: {project}")
        return 1

    if a.manifest:
        manifest = Path(a.manifest)
        if not manifest.is_absolute():
            manifest = project / manifest
        confirmed, failures = check_manifest(project, manifest)
        mode = "manifest (strict — coverage + freshness)"
    elif a.report:
        report = Path(a.report)
        if not report.is_absolute():
            report = project / report
        confirmed, failures = check_report(project, report)
        mode = "report (lenient — existence only, cannot prove coverage)"
    else:
        default = project / "artifacts" / "final-evidence.md"
        if default.is_file():
            confirmed, failures = check_report(project, default)
            mode = "report (lenient — found artifacts/final-evidence.md)"
        else:
            print("Usage: check_evidence.py <project> --manifest <evidence.json> | --report <report.md>")
            print(f"No manifest given and {default} not found.")
            return 1

    print(f"=== Evidence check — {mode}")
    print(f"Project: {project}")
    for line in confirmed:
        print(f"  ✅ {line}")
    for line in failures:
        print(f"  ❌ {line}")
    print()
    if failures:
        print(f"❌ Evidence check FAILED — {len(failures)} problem(s). "
              "A completion claim needs evidence that exists, is not a stub, and belongs to this run.")
        return 1
    print(f"✅ Evidence check passed — {len(confirmed)} artifact(s) resolved.")
    if "lenient" in mode:
        print("   Note: this mode proves the files exist. It does NOT prove they are current, "
              "that every required viewport/state was captured, or that the check inside them passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
