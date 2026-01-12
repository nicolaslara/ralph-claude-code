#!/bin/bash
# Ralph Stop Hook
# Checks if a loop is active and should continue

set -euo pipefail

# Find .ralph directory (search up from cwd)
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
LOOP_STATE="$RALPH_DIR/.loop-state.json"

# No loop state file = no active loop
[[ ! -f "$LOOP_STATE" ]] && exit 0

# Check if loop is active
ACTIVE=$(jq -r '.active // false' "$LOOP_STATE" 2>/dev/null) || exit 0
[[ "$ACTIVE" != "true" ]] && exit 0

# Get iteration info
ITERATION=$(jq -r '.iteration // 1' "$LOOP_STATE")
MAX_ITERATIONS=$(jq -r '.maxIterations // 20' "$LOOP_STATE")
COMPLETION_PROMISE=$(jq -r '.completionPromise // "COMPLETE"' "$LOOP_STATE")

# Check if max iterations reached
if [[ $ITERATION -ge $MAX_ITERATIONS ]]; then
  # Deactivate loop
  jq '.active = false | .endReason = "max_iterations"' "$LOOP_STATE" > "$LOOP_STATE.tmp" && mv "$LOOP_STATE.tmp" "$LOOP_STATE"

  # Log to progress
  echo "" >> "$RALPH_DIR/progress.md"
  echo "### $(date '+%Y-%m-%d %H:%M:%S')" >> "$RALPH_DIR/progress.md"
  echo "**Loop ended**: Max iterations ($MAX_ITERATIONS) reached" >> "$RALPH_DIR/progress.md"

  exit 0
fi

# Increment iteration
NEW_ITERATION=$((ITERATION + 1))
jq ".iteration = $NEW_ITERATION" "$LOOP_STATE" > "$LOOP_STATE.tmp" && mv "$LOOP_STATE.tmp" "$LOOP_STATE"

# Log iteration start
echo "" >> "$RALPH_DIR/progress.md"
echo "### $(date '+%Y-%m-%d %H:%M:%S')" >> "$RALPH_DIR/progress.md"
echo "**Iteration $NEW_ITERATION started**" >> "$RALPH_DIR/progress.md"

# Build the continuation prompt
WORKSPACE=$(dirname "$RALPH_DIR")
PROMPT_FILE="$WORKSPACE/RALPH_PROMPT.md"

if [[ -f "$PROMPT_FILE" ]]; then
  # Use custom prompt with iteration placeholder
  PROMPT=$(sed "s/{{ITERATION}}/$NEW_ITERATION/g" "$PROMPT_FILE")
else
  # Default prompt
  PROMPT="Continue Ralph iteration $NEW_ITERATION. Read RALPH_TASK.md and .ralph/guardrails.md, then work on the next unchecked task. Output <ralph>$COMPLETION_PROMISE</ralph> when all tasks are complete."
fi

# Output the prompt for Claude to continue
# The Stop hook can return a message that becomes Claude's next input
echo "$PROMPT"
