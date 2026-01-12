---
description: Run a single Ralph iteration for testing before going AFK
argument-hint: (no arguments)
---

# /ralph:once

Run exactly ONE iteration of the Ralph loop, then stop for human review.

Use this to test your RALPH_TASK.md before starting a full autonomous loop.

## Before Starting

**SAFETY CHECKS**:

1. **Check for parallel agents**:
   ```bash
   git log --oneline -3
   ```
   If you see commits you didn't make, STOP and warn the user.

2. **Verify clean git state**:
   ```bash
   git status --short
   ```

3. **Commit any uncommitted changes**:
   ```bash
   git add -A && git commit -m "ralph: checkpoint before single iteration"
   ```

4. **Initialize Ralph state** if needed.

## Single Iteration

1. **Read state files** (in this order):
   - `RALPH_TASK.md` - Tasks and completion criteria
   - `.ralph/guardrails.md` - Lessons learned (FOLLOW THESE!)
   - `.ralph/progress.md` - What's been accomplished

2. **If RALPH_PROMPT.md exists**, follow its instructions.

3. **Work on ONE task** from RALPH_TASK.md:
   - Select an unchecked `[ ]` task
   - Implement with tests
   - Mark complete: `[ ]` to `[x]`
   - Commit immediately

4. **Update `.ralph/progress.md`** with what you accomplished.

5. **Stop and report**:
   - What task was completed
   - What tests were run
   - What's next (for human to review)

## After Completion

Report to the user:
- Summary of changes made
- Git commits created
- Remaining unchecked tasks
- Recommendation: proceed with `/ralph:loop` or fix issues first

## CRITICAL: This is NOT a loop

Do NOT continue to another task. Stop after ONE task is complete (or attempted).
The human will review and decide whether to continue.
