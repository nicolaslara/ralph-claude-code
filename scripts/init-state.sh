#!/bin/bash
# Initialize Ralph state directory and files
# Called by commands that need Ralph state

set -euo pipefail

WORKSPACE="${1:-.}"
RALPH_DIR="$WORKSPACE/.ralph"

mkdir -p "$RALPH_DIR"

# Initialize progress.md
if [[ ! -f "$RALPH_DIR/progress.md" ]]; then
  cat > "$RALPH_DIR/progress.md" << 'EOF'
# Progress Log

> Updated by the agent after significant work.

---

## Session History

EOF
fi

# Initialize guardrails.md
if [[ ! -f "$RALPH_DIR/guardrails.md" ]]; then
  cat > "$RALPH_DIR/guardrails.md" << 'EOF'
# Ralph Guardrails

> Lessons learned from failures. **Read these FIRST before starting work!**

---

## Core Signs (Always Follow)

### Sign: Commit immediately after each change
- **Trigger**: After any file creation/modification
- **Instruction**: Don't batch commits. One change = one commit.

### Sign: NEVER reset to a fixed commit
- **Trigger**: When recovering from errors
- **Instruction**: Use `git reset --hard HEAD` only, never a specific commit hash

### Sign: NEVER use git clean
- **Trigger**: When cleaning up
- **Instruction**: Delete specific files manually instead. git clean deletes .ralph/

---

## Learned Signs

EOF
fi

# Initialize errors.log
if [[ ! -f "$RALPH_DIR/errors.log" ]]; then
  cat > "$RALPH_DIR/errors.log" << 'EOF'
# Error Log

> Failures detected during Ralph iterations.

EOF
fi

# Initialize activity.log
if [[ ! -f "$RALPH_DIR/activity.log" ]]; then
  cat > "$RALPH_DIR/activity.log" << 'EOF'
# Activity Log

> Tool call logging from Ralph hooks.

EOF
fi

echo "Ralph state initialized in $RALPH_DIR"
