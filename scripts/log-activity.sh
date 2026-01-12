#!/bin/bash
# Ralph Activity Logger (PostToolUse hook)
# Logs tool usage to .ralph/activity.log

set -euo pipefail

ACTION="${1:-unknown}"
DETAILS="${2:-}"

# Find .ralph directory
find_ralph_dir() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/.ralph" ]]; then
      echo "$dir/.ralph"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

RALPH_DIR=$(find_ralph_dir 2>/dev/null) || exit 0
LOG_FILE="$RALPH_DIR/activity.log"

# Ensure log file exists
mkdir -p "$RALPH_DIR"
touch "$LOG_FILE"

TIMESTAMP=$(date '+%H:%M:%S')

case "$ACTION" in
  write)
    # Extract file path from tool input if possible
    FILE_PATH=$(echo "$DETAILS" | grep -oE '"file_path":\s*"[^"]+"' | head -1 | sed 's/.*"file_path":\s*"\([^"]*\)".*/\1/' 2>/dev/null) || FILE_PATH="unknown"
    echo "[$TIMESTAMP] WRITE $FILE_PATH" >> "$LOG_FILE"
    ;;
  bash)
    # Extract command (truncate if too long)
    CMD=$(echo "$DETAILS" | grep -oE '"command":\s*"[^"]+"' | head -1 | sed 's/.*"command":\s*"\([^"]*\)".*/\1/' 2>/dev/null | head -c 100) || CMD="unknown"
    echo "[$TIMESTAMP] BASH $CMD" >> "$LOG_FILE"
    ;;
  *)
    echo "[$TIMESTAMP] $ACTION $DETAILS" >> "$LOG_FILE"
    ;;
esac

exit 0
