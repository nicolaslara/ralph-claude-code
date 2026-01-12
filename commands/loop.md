---
description: Start an autonomous Ralph development loop that continues until completion or max iterations
argument-hint: [--max-iterations N] [--completion-promise TEXT]
---

# /ralph:loop

Start a Ralph Wiggum autonomous development loop.

## Arguments

Parse the following from $ARGUMENTS:
- `--max-iterations N` (default: 20) - Maximum iterations before stopping
- `--completion-promise TEXT` (default: "COMPLETE") - Text that signals completion

## Before Starting

**CRITICAL SAFETY CHECKS** - Do these FIRST:

1. **Check for parallel agents**:
   ```bash
   git log --oneline -3
   ```
   If you see commits you didn't make, STOP and warn the user.

2. **Verify clean git state**:
   ```bash
   git status --short
   ```
   Should be empty or only known untracked files.

3. **Check for orphaned commits**:
   ```bash
   git log --oneline --all | head -10
   ```
   Compare with `git log --oneline HEAD -5`. If there are commits not in HEAD, warn the user.

4. **Initialize Ralph state**:
   - Create `.ralph/` directory if missing
   - Ensure `.ralph/progress.md`, `.ralph/guardrails.md`, `.ralph/errors.log` exist

5. **Set loop state**:
   Write to `.ralph/.loop-state.json`:
   ```json
   {
     "active": true,
     "iteration": 1,
     "maxIterations": <from args>,
     "completionPromise": "<from args>",
     "startedAt": "<timestamp>"
   }
   ```

## During Each Iteration

1. **Read state files** (in this order):
   - `RALPH_TASK.md` - Tasks and completion criteria
   - `.ralph/guardrails.md` - Lessons learned (FOLLOW THESE!)
   - `.ralph/progress.md` - What's been accomplished
   - `.ralph/errors.log` - Recent failures

2. **If RALPH_PROMPT.md exists**, follow its instructions for task selection and execution.

3. **Work on ONE task** from RALPH_TASK.md:
   - Select an unchecked `[ ]` task
   - Implement with tests
   - Mark complete: `[ ]` to `[x]`
   - Commit immediately after EACH change

4. **Update progress**:
   - Add entry to `.ralph/progress.md`
   - Update `.ralph/.loop-state.json` iteration count

5. **Git protocol**:
   - Commit after EVERY file change (never batch)
   - Use message format: `yums: <what you did>`
   - NEVER use `git reset --hard <fixed-commit>` - only `git reset --hard HEAD`
   - NEVER use `git clean -fd` (it deletes .ralph/)

## Completion Signals

When ALL tasks in RALPH_TASK.md show `[x]`, output:
```
<ralph>COMPLETE</ralph>
```

If stuck on the same issue 3+ times, output:
```
<ralph>GUTTER</ralph>
```

## Loop Continuation

After completing work for this iteration:
1. Check if all tasks are complete - if so, output `<ralph>COMPLETE</ralph>`
2. Check iteration count against max - if reached, output `<ralph>MAX_ITERATIONS</ralph>`
3. Otherwise, the Stop hook will automatically continue the loop

## CRITICAL: Never Reset Progress

- Each iteration builds on the PREVIOUS iteration's commits
- Your commits ARE your memory - they persist across rotations
- Never reset to a specific commit hash
- Never delete or ignore the .ralph/ directory
