#!/usr/bin/env bash
# scripts/verify/check-context-cap.sh — warn (never block) when a session loads more
# than the SKILL.md context budget allows for one phase.
#
# Why this exists: the framework ships ~1.2M tokens. The budget in SKILL.md ("1 module,
# 3 framework files, ~10k tokens per phase; deep-dives only when a step points at one")
# was unenforceable prose, so an agent could read four modules and two deep-dives and
# still believe it was following the rules. This counts what was actually loaded.
#
# How the count happens: the agent harness records every tool call under
#   $HOME/.hermes/tool_usage/<tool>/<YYYY-MM-DD>.jsonl
# where each line is {"args": {...}}. This script reads today's (or --date) records,
# extracts the file paths read by `read_file` and the paths/globs of `search_files`,
# and reports anything outside the budget. Projects and other tools are ignored.
#
# Exit codes: 0 = within budget (or nothing recorded) · 3 = over budget (advisory).
# It is deliberately NOT wired into validate-gate.sh: SKILL.md says the budget is a task
# rule, so this is a report for the human/agent, not a gate that can block work.
#
# Usage:
#   bash scripts/verify/check-context-cap.sh               # today, from $HOME
#   bash scripts/verify/check-context-cap.sh --date 2026-11-04
#   bash scripts/verify/check-context-cap.sh --root /path/to/hermes-home
#   bash scripts/verify/check-context-cap.sh --verbose     # list every loaded file

set -u

ROOT="${HOME}/.hermes"
DATE="$(date +%Y-%m-%d)"
VERBOSE=0
MAX_MODULES=1
MAX_FRAMEWORK=3
MAX_DIVES=1

while [ $# -gt 0 ]; do
    case "$1" in
        --root)  ROOT="$2"; shift 2 ;;
        --date)  DATE="$2"; shift 2 ;;
        --verbose|-v) VERBOSE=1; shift ;;
        -h|--help) sed -n '2,26p' "$0"; exit 0 ;;
        *) echo "unknown argument: $1" >&2; exit 2 ;;
    esac
done

USAGE_DIR="$ROOT/tool_usage"
if [ ! -d "$USAGE_DIR" ]; then
    echo "  ⚠ no tool-usage records at $USAGE_DIR — context cap not measured (advisory)"
    exit 0
fi

# Collect JSONL for this date from every tool that can pull content into context.
FILES_LIST="$(mktemp)"
trap 'rm -f "$FILES_LIST"' EXIT

for tool in read_file search_files skill_view web_extract web_search js terminal patch write_file browser_exec; do
    log="$USAGE_DIR/$tool/$DATE.jsonl"
    [ -f "$log" ] || continue
    # Paths appear as args.path / args.file_path / args.target / args.pattern / args.url.
    awk -v tool="$tool" '
        {
            line = $0
            while (match(line, /"(path|file_path|target|pattern|url)"[[:space:]]*:[[:space:]]*"[^"]*"/)) {
                seg = substr(line, RSTART, RLENGTH)
                sub(/^"[^"]*"[[:space:]]*:[[:space:]]*"/, "", seg)
                sub(/"$/, "", seg)
                print tool "\t" seg
                line = substr(line, RSTART + RLENGTH)
            }
        }
    ' "$log" >> "$FILES_LIST" 2>/dev/null
done

if [ ! -s "$FILES_LIST" ]; then
    echo "  ✓ no file-loading tool calls recorded for $DATE — nothing to cap"
    exit 0
fi

# Classify: framework module / deep-dive / reference / pattern / template / project file.
SUMMARY="$(awk -F'\t' '
    {
        tool = $1; p = $2
        if (p == "") next
        if (p ~ /^tool usage:/) { sub(/^tool usage:[[:space:]]*/, "", p) }
        if (p ~ /\/?docs\/modules\/deep-dives\// || p ~ /^docs\/modules\/deep-dives\//) { dd[p]=1; next }
        # Re-searching a file already counted is not a second load.
        if (p ~ /^(docs\/modules|references|patterns|templates)\//) { seen[p]=1; next }
        if (p ~ /docs\/modules\/[0-9A-Z_]+\.md/ || p ~ /^[0-9A-Z_]+\.md$/) { mod[p]=1; next }
        if (p ~ /(^|\/)(references|patterns)\//) { ref[p]=1; next }
        if (p ~ /(^|\/)templates\//) { tmpl[p]=1; next }
    }
    END {
        for (k in seen) {
            if (k ~ /^docs\/modules\//) mod[k]=1
            else if (k ~ /^(references|patterns)\//) ref[k]=1
            else if (k ~ /^templates\//) tmpl[k]=1
        }
        nm=0; nd=0; nr=0; nt=0
        for (k in mod) { nm++; modlist = modlist "\n    " k }
        for (k in mod) { if (k in dd) delete mod[k] }   # keep MODLIST to runbooks only
        for (k in dd) { nd++; ddlist = ddlist "\n    " k }
        for (k in ref) { nr++ }
        for (k in tmpl) { nt++ }
        printf "modules=%d deep_dives=%d references=%d templates=%d\n", nm, nd, nr, nt
        printf "MODLIST%s\nDDLIST%s\n", modlist, ddlist
    }
' "$FILES_LIST")"

COUNTS="$(printf '%s\n' "$SUMMARY" | head -1)"
MODULES="$(printf '%s' "$COUNTS" | sed -E 's/.*modules=([0-9]+).*/\1/')"
DIVES="$(printf '%s' "$COUNTS" | sed -E 's/.*deep_dives=([0-9]+).*/\1/')"
REFS="$(printf '%s' "$COUNTS" | sed -E 's/.*references=([0-9]+).*/\1/')"
TMPLS="$(printf '%s' "$COUNTS" | sed -E 's/.*templates=([0-9]+).*/\1/')"
FRAMEWORK=$((MODULES + REFS + TMPLS))

echo "=== Context Cap Check ($DATE) ==="
echo "  modules read          : $MODULES (budget $MAX_MODULES)"
echo "  deep-dives read       : $DIVES (budget $MAX_DIVES — only when a step points at one)"
echo "  references/patterns   : $REFS"
echo "  templates             : $TMPLS"
echo "  framework files total : $FRAMEWORK (budget $MAX_FRAMEWORK)"

if [ "$VERBOSE" -eq 1 ]; then
    echo "$SUMMARY" | tail -n +2 | sed '/^$/d'
fi

OVER=0
[ "$MODULES" -gt "$MAX_MODULES" ] && OVER=1
[ "$FRAMEWORK" -gt "$MAX_FRAMEWORK" ] && OVER=1
[ "$DIVES" -gt "$MAX_DIVES" ] && OVER=1
if [ "$OVER" -eq 1 ]; then
    echo ""
    echo "  ⚠ over the SKILL.md context budget for one phase."
    echo "    Stop loading docs: re-read docs/pm/PROJECT_STATE.md and continue from the step you are on."
    echo "    (Advisory only — this never blocks a gate.)"
    exit 3
fi

echo ""
echo "  ✓ within the SKILL.md context budget"
exit 0
