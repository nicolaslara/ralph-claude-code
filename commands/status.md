---
description: Show current Ralph loop status and progress
argument-hint: (no arguments)
---

# /ralph:status

Show the current state of Ralph execution.

## Check and Report

1. **Loop state** (from `.ralph/.loop-state.json` if exists):
   - Is a loop active?
   - Current iteration / max iterations
   - When it started

2. **Task progress** (from `RALPH_TASK.md`):
   - Count `[x]` completed tasks
   - Count `[ ]` remaining tasks
   - Show next unchecked task

3. **Recent activity** (from `.ralph/progress.md`):
   - Last 3 progress entries

4. **Git status**:
   - Recent commits: `git log --oneline -5`
   - Any uncommitted changes: `git status --short`

5. **Health check**:
   - Are there orphaned commits?
   - Is `.ralph/guardrails.md` up to date?
   - Any errors in `.ralph/errors.log`?

## Output Format

```
Ralph Status
============
Loop: [Active|Inactive] (iteration X of Y)
Tasks: X/Y complete (Z remaining)
Last activity: <timestamp> - <description>

Recent commits:
  <commit list>

Health: [OK|WARNINGS]
  <any warnings>
```
