---
description: Cancel an active Ralph loop
argument-hint: (no arguments)
---

# /ralph:cancel

Cancel the currently active Ralph loop.

## Actions

1. **Update loop state**:
   Set `active: false` in `.ralph/.loop-state.json`

2. **Log cancellation**:
   Add entry to `.ralph/progress.md`:
   ```
   ### <timestamp>
   **Loop cancelled by user** at iteration X
   ```

3. **Report final status**:
   - Tasks completed during this loop
   - Current git state
   - How to resume: `/ralph:loop` to start fresh

## Note

This does not undo any work done during the loop.
All commits and file changes are preserved.
