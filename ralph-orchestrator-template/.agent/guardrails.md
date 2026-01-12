# Guardrails

Rules and lessons learned from past failures. **Read this first. Never violate these.**

---

## Core Rules

### Sign: Check for parallel agents
- **Trigger**: Before starting ANY work
- **Instruction**: Run `git log --oneline -3`. If commits appeared that you didn't make, STOP immediately
- **Why**: Parallel agents cause merge conflicts, lost work, and massive instability

### Sign: Verify clean state before work
- **Trigger**: Start of every session
- **Instruction**: Run typecheck, tests, and git status before making changes
- **Why**: Starting from broken state wastes entire iterations debugging others' mistakes

### Sign: Git is your memory
- **Trigger**: After any meaningful change
- **Instruction**: Commit immediately. Don't batch changes. One logical change = one commit
- **Why**: Your conversation history is lost between iterations. Only commits persist

### Sign: Never reset to a fixed commit
- **Trigger**: When writing any git reset command
- **Instruction**: Use `git reset --hard HEAD` only, NEVER `git reset --hard <specific-hash>`
- **Why**: Caused 36 commits to be orphaned in a loop that kept resetting to the same old commit

### Sign: Never delete .agent directory
- **Trigger**: When running any rm -rf or git clean command
- **Instruction**: Never run `rm -rf .agent`, `git clean -fd`, or similar
- **Why**: Destroys all progress history, guardrails, and institutional memory

### Sign: Never gitignore .agent
- **Trigger**: When modifying .gitignore
- **Instruction**: `.agent/` must be tracked in git. Only `.agent/activity.log` should be gitignored
- **Why**: Entire progress history was permanently lost when .agent/ was gitignored

---

## Testing & Verification

### Sign: Always run tests before marking complete
- **Trigger**: Before marking any task [x] complete
- **Instruction**: `npm run typecheck && npm run test` must both pass
- **Why**: Multiple sessions committed code that broke TypeScript or tests

### Sign: Test on all platforms
- **Trigger**: For any UI or platform-specific changes
- **Instruction**: Verify on web AND mobile (iOS/Android if applicable)
- **Why**: Android crashed silently for days because only web was tested

---

## Lessons Learned

<!-- Add new signs here as you discover them -->
<!-- Format:
### Sign: [Name]
- **Trigger**: When [situation]
- **Instruction**: [What to do]
- **Why**: [What went wrong]
-->
