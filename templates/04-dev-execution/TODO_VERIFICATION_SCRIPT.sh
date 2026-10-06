#!/usr/bin/env bash
# TODO Verification Script
# Purpose: Verify TODO.md checklist completion before milestone sign-off
# Usage: ./TODO_VERIFICATION_SCRIPT.sh [path/to/TODO.md]

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default TODO path
TODO_FILE="${1:-}"
if [[ -z "$TODO_FILE" ]]; then
    if [[ -f "TODO.md" ]]; then
        TODO_FILE="TODO.md"
    else
        TODO_FILE="docs/harness-root/TODO.md"
    fi
fi

# Counters
TOTAL_ITEMS=0
COMPLETED_ITEMS=0
INCOMPLETE_ITEMS=0
PHASE_STATS=()

echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  TODO Verification Script${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

# Check if TODO file exists
if [[ ! -f "$TODO_FILE" ]]; then
    echo -e "${RED}✗ ERROR: TODO file not found: $TODO_FILE${NC}"
    echo ""
    echo "Usage: $0 [path/to/TODO.md]"
    echo "Example: $0 TODO.md"
    exit 1
fi

echo -e "${GREEN}✓ TODO file found: $TODO_FILE${NC}"
echo ""

# Function to extract phase name
extract_phase() {
    local line="$1"
    # Match patterns like "## Phase 1:" or "### Phase 1:" or "# Phase 1:"
    if echo "$line" | grep -qE '^#{1,3} Phase [0-9]+:'; then
        echo "$line" | sed -E 's/^#{1,3} (Phase [0-9]+:.*)/\1/'
    fi
}

# Parse TODO.md
CURRENT_PHASE=""
PHASE_TOTAL=0
PHASE_COMPLETE=0

while IFS= read -r line; do
    # Check for phase headers
    phase=$(extract_phase "$line")
    if [[ -n "$phase" ]]; then
        # Save previous phase stats
        if [[ -n "$CURRENT_PHASE" ]]; then
            PHASE_STATS+=("$CURRENT_PHASE|$PHASE_COMPLETE|$PHASE_TOTAL")
        fi
        
        # Start new phase
        CURRENT_PHASE="$phase"
        PHASE_TOTAL=0
        PHASE_COMPLETE=0
    fi
    
    # Check for checklist items
    # Match: - [ ] or - [x] or - [X]
    if echo "$line" | grep -qE '^\s*-\s+\[([ xX])\]'; then
        TOTAL_ITEMS=$((TOTAL_ITEMS + 1))
        PHASE_TOTAL=$((PHASE_TOTAL + 1))
        
        # Check if completed [x] or [X]
        if echo "$line" | grep -qE '^\s*-\s+\[[xX]\]'; then
            COMPLETED_ITEMS=$((COMPLETED_ITEMS + 1))
            PHASE_COMPLETE=$((PHASE_COMPLETE + 1))
        else
            INCOMPLETE_ITEMS=$((INCOMPLETE_ITEMS + 1))
        fi
    fi
done < "$TODO_FILE"

# Save last phase stats
if [[ -n "$CURRENT_PHASE" ]]; then
    PHASE_STATS+=("$CURRENT_PHASE|$PHASE_COMPLETE|$PHASE_TOTAL")
fi

# Calculate completion percentage
if [[ $TOTAL_ITEMS -eq 0 ]]; then
    echo -e "${RED}✗ ERROR: No checklist items found in TODO.md${NC}"
    echo ""
    echo "Expected format:"
    echo "  - [ ] Task description"
    echo "  - [x] Completed task"
    exit 1
fi

COMPLETION_PERCENT=$(awk "BEGIN {printf \"%.1f\", ($COMPLETED_ITEMS / $TOTAL_ITEMS) * 100}")

# Display overall stats
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  OVERALL PROGRESS${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "  Total Items:       ${BLUE}$TOTAL_ITEMS${NC}"
echo -e "  Completed:         ${GREEN}$COMPLETED_ITEMS${NC}"
echo -e "  Incomplete:        ${RED}$INCOMPLETE_ITEMS${NC}"
echo -e "  Completion:        ${YELLOW}${COMPLETION_PERCENT}%${NC}"
echo ""

# Display phase-by-phase stats
if [[ ${#PHASE_STATS[@]} -gt 0 ]]; then
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  PHASE BREAKDOWN${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    for stat in "${PHASE_STATS[@]}"; do
        IFS='|' read -r phase_name phase_complete phase_total <<< "$stat"
        phase_percent=$(awk "BEGIN {printf \"%.1f\", ($phase_complete / $phase_total) * 100}")
        
        # Color based on completion
        if awk "BEGIN {exit !($phase_percent == 100)}"; then
            color="$GREEN"
            status="✓"
        elif awk "BEGIN {exit !($phase_percent >= 50)}"; then
            color="$YELLOW"
            status="◐"
        else
            color="$RED"
            status="○"
        fi
        
        printf "  ${color}${status}${NC} %-40s ${color}%3d/%3d${NC} (${color}%5.1f%%${NC})\n" \
            "$phase_name" "$phase_complete" "$phase_total" "$phase_percent"
    done
    echo ""
fi

# Display incomplete items
if [[ $INCOMPLETE_ITEMS -gt 0 ]]; then
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  INCOMPLETE ITEMS${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    CURRENT_PHASE=""
    while IFS= read -r line; do
        # Track current phase
        phase=$(extract_phase "$line")
        if [[ -n "$phase" ]]; then
            CURRENT_PHASE="$phase"
        fi
        
        # Display incomplete items
        if echo "$line" | grep -qE '^\s*-\s+\[ \]'; then
            task=$(echo "$line" | sed -E 's/^\s*-\s+\[ \]\s*//')
            if [[ -n "$CURRENT_PHASE" ]]; then
                echo -e "  ${RED}✗${NC} ${YELLOW}$CURRENT_PHASE${NC}"
                echo -e "    $task"
                CURRENT_PHASE=""  # Only show phase once
            else
                echo -e "    $task"
            fi
        fi
    done < "$TODO_FILE"
    echo ""
fi

# Milestone gates
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  MILESTONE GATES${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

# Gate thresholds
GATE_M04=20  # Design complete
GATE_M05=40  # Architecture complete
GATE_M06=70  # Development complete
GATE_M09=90  # UAT complete
GATE_M10=95  # Production deploy
GATE_M11=100 # Handover complete

check_gate() {
    local gate_name="$1"
    local gate_threshold="$2"
    local current_percent="$3"
    
    if awk "BEGIN {exit !($current_percent >= $gate_threshold)}"; then
        echo -e "  ${GREEN}✓${NC} $gate_name (${gate_threshold}% required, ${current_percent}% achieved)"
    else
        echo -e "  ${RED}✗${NC} $gate_name (${gate_threshold}% required, ${current_percent}% achieved) ${RED}BLOCKED${NC}"
    fi
}

check_gate "M04 Design Gate" "$GATE_M04" "$COMPLETION_PERCENT"
check_gate "M05 Architecture Gate" "$GATE_M05" "$COMPLETION_PERCENT"
check_gate "M06 Development Gate" "$GATE_M06" "$COMPLETION_PERCENT"
check_gate "M09 UAT Gate" "$GATE_M09" "$COMPLETION_PERCENT"
check_gate "M10 Production Gate" "$GATE_M10" "$COMPLETION_PERCENT"
check_gate "M11 Handover Gate" "$GATE_M11" "$COMPLETION_PERCENT"
echo ""

# Final verdict
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  VERDICT${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

if [[ $COMPLETION_PERCENT == "100.0" ]]; then
    echo -e "  ${GREEN}✓ PROJECT COMPLETE!${NC}"
    echo -e "  All TODO items checked. Ready for final handover."
    echo ""
    exit 0
elif awk "BEGIN {exit !($COMPLETION_PERCENT >= 90)}"; then
    echo -e "  ${YELLOW}◐ ALMOST THERE${NC}"
    echo -e "  ${YELLOW}${INCOMPLETE_ITEMS}${NC} items remaining. Review incomplete items above."
    echo ""
    exit 0
elif awk "BEGIN {exit !($COMPLETION_PERCENT >= 50)}"; then
    echo -e "  ${YELLOW}◐ IN PROGRESS${NC}"
    echo -e "  ${YELLOW}${INCOMPLETE_ITEMS}${NC} items remaining. Keep going!"
    echo ""
    exit 0
else
    echo -e "  ${RED}○ EARLY STAGE${NC}"
    echo -e "  ${RED}${INCOMPLETE_ITEMS}${NC} items remaining. Lots of work ahead."
    echo ""
    exit 1
fi
