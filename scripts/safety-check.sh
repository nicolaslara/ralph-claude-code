#!/bin/bash
# Ralph Safety Check (PreToolUse hook for Bash)
# Blocks dangerous commands that violate guardrails

set -euo pipefail

TOOL_INPUT="${1:-}"

# Patterns to BLOCK (exit non-zero to block the tool)
BLOCKED_PATTERNS=(
  "git clean -fd"
  "git clean -f"
  "git reset --hard [a-f0-9]"  # Specific commit hash (not HEAD)
  "rm -rf .ralph"
  "rm -r .ralph"
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$TOOL_INPUT" | grep -qE "$pattern"; then
    echo "BLOCKED by Ralph guardrail: '$pattern' is dangerous"
    echo ""
    echo "Reason:"
    case "$pattern" in
      *"git clean"*)
        echo "  git clean deletes untracked files including .ralph/ state"
        echo "  Use 'rm <specific-file>' instead if you need to delete something"
        ;;
      *"git reset --hard"*)
        echo "  Resetting to a specific commit orphans all work since that commit"
        echo "  Use 'git reset --hard HEAD' to reset uncommitted changes only"
        ;;
      *"rm"*".ralph"*)
        echo "  The .ralph/ directory contains critical state (guardrails, progress)"
        echo "  Never delete it"
        ;;
    esac
    exit 1
  fi
done

# Allow the command
exit 0
