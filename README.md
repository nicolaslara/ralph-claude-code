# Ralph Orchestrator Template

Enhanced prompt template for [ralph-orchestrator](https://github.com/mikeyobrien/ralph-orchestrator) featuring the **workpads model** for organized project knowledge and battle-tested guardrails from real autonomous development sessions.

## Quick Start

```bash
# Install ralph-orchestrator
uv tool install ralph-orchestrator
# or: pip install ralph-orchestrator

# Copy the template to your project
cp -r ralph-orchestrator-template/* your-project/

# Edit TASK.md with your tasks
# Populate workpads/ with your project knowledge

# Run
cd your-project && ralph
```

## Usage

### Step 1: Set Up Your Project

Copy the template into an existing project:

```bash
# Clone this repo
git clone https://github.com/nicolaslara/ralph-claude-code.git

# Copy template to your project
cp -r ralph-claude-code/ralph-orchestrator-template/* ~/your-project/

# Commit the template files
cd ~/your-project
git add -A && git commit -m "Add ralph orchestrator template"
```

### Step 2: Define Your Tasks

Edit `TASK.md` with checkbox-style tasks:

```markdown
## P0 - Critical
- [ ] Fix authentication bug causing logout on refresh
- [ ] Add input validation to payment form

## P1 - Important
- [ ] Implement user profile page
- [ ] Add search functionality to product list

## P2 - Nice to Have
- [ ] Dark mode support
- [ ] Performance optimization for large lists
```

**Task guidelines:**
- Each task should be completable in one iteration (< 30 min of agent work)
- Be specific: "Add logout button to header" not "Improve auth"
- Include acceptance criteria when helpful
- Break large features into subtasks

### Step 3: Populate Workpads

Add project-specific knowledge to help the agent understand your codebase:

**`workpads/app/knowledge.md`** - Document your architecture:
```markdown
## Architecture
- React + TypeScript frontend
- Express API in /server
- PostgreSQL database

## Design Decisions
| ID | Decision | Rationale |
|----|----------|-----------|
| D1 | Zustand for state | Minimal boilerplate, good TS support |
| D2 | TanStack Query for API | Caching, deduplication, retries |

## Patterns
- All API calls go through /src/api/client.ts
- Components use compound pattern for complex UI
```

**`workpads/backend/knowledge.md`** - Document your API:
```markdown
## Endpoints
| Route | Method | Purpose |
|-------|--------|---------|
| /api/users | GET | List users |
| /api/users/:id | GET | Get user by ID |

## Database Schema
- users: id, email, name, created_at
- products: id, name, price, user_id
```

### Step 4: Configure Limits

Edit `ralph.yml` based on your needs:

```yaml
# Conservative (testing)
max_iterations: 10
max_cost: 5.0

# Normal usage
max_iterations: 50
max_cost: 25.0

# Long-running (overnight)
max_iterations: 100
max_cost: 50.0
```

### Step 5: Run the Loop

```bash
# First run: use fewer iterations to verify setup
ralph -n 5

# If working well, run full loop
ralph

# Run overnight with higher limits
ralph -n 100 --max-cost 50
```

### Step 6: Monitor Progress

While running:
- Watch terminal output for progress
- Check `git log` for commits being made
- Read `.agent/progress-current.md` for session summaries

After running:
- Review `TASK.md` - completed tasks marked `[x]`
- Check `.agent/guardrails.md` for new lessons learned
- Run your test suite to verify quality

### Intervening

**To stop gracefully:** `Ctrl+C` - current iteration completes, then stops

**To add a guardrail mid-run:** Edit `.agent/guardrails.md` directly. The agent reads it at the start of each iteration.

**To reprioritize:** Edit `TASK.md` to reorder or add tasks. Changes take effect next iteration.

**When the agent gets stuck:**
1. Check `.agent/progress-current.md` for what it tried
2. Add a guardrail explaining what to do differently
3. Restart: `ralph`

## Template Structure

```
your-project/
├── ralph.yml                    # Orchestrator configuration
├── PROMPT.md                    # Agent instructions
├── TASK.md                      # Your task list
│
├── .agent/                      # State directory (tracked in git)
│   ├── guardrails.md            # Lessons learned from failures
│   ├── progress-current.md      # Recent session logs (~10 sessions)
│   └── progress-archive/        # Rotated older logs
│
└── workpads/                    # Project knowledge bases
    ├── app/
    │   ├── knowledge.md         # Architecture, decisions, patterns
    │   └── references.md        # External docs, links
    ├── backend/
    │   ├── knowledge.md
    │   └── references.md
    └── testing/
        ├── knowledge.md
        └── references.md
```

## Key Concepts

### Workpads Model

Organize project knowledge by domain instead of one giant file:

| Workpad | Contains |
|---------|----------|
| `app/` | Application architecture, UI patterns, design decisions |
| `backend/` | API design, data model, service configuration |
| `testing/` | Test strategies, commands, patterns |

Add more as needed (`ai/`, `infra/`, `expo/`, etc.).

Each workpad has:
- `knowledge.md` - Internal decisions and patterns (committed)
- `references.md` - External documentation links (committed)

**Selective loading**: The agent only loads workpads relevant to the current task, preserving context for actual work.

### Progress Rotation

Progress files grow and consume context. This template solves that:

- `progress-current.md` - Last ~10 sessions (agent reads this)
- `progress-archive/YYYY-MM.md` - Older sessions rotated here
- Full history lives in git - use `git log` if you need it

### Guardrails

Hard-won lessons documented as "Signs":

```markdown
### Sign: Never reset to a fixed commit
- **Trigger**: When writing any git reset command
- **Instruction**: Use `git reset --hard HEAD` only, never specific hashes
- **Why**: Caused 36 commits to be orphaned in a loop
```

The agent reads guardrails FIRST every iteration to avoid repeating mistakes.

## Configuration

Edit `ralph.yml`:

```yaml
agent: claude                # Or: kiro, q, gemini, acp, auto
max_iterations: 50           # Stop after N iterations
max_cost: 25.0               # USD spending limit
max_tokens: 1000000          # Token budget
checkpoint_interval: 5       # Git checkpoint every N iterations
completion_promise: LOOP_COMPLETE
```

## Critical Rules

These are baked into the template but worth understanding:

1. **Git is memory** - Conversations don't persist between iterations. Commits do.
2. **Never gitignore .agent/** - Only `activity.log` should be gitignored
3. **One task at a time** - Complete fully, test, commit, then move on
4. **Test before marking complete** - Typecheck + tests must pass
5. **Add guardrails from failures** - Every failure should become a new Sign

## Commands

```bash
ralph                    # Start autonomous loop
ralph -n 10              # Run max 10 iterations
ralph -p "quick task"    # Inline prompt without PROMPT.md
ralph --verbose          # Detailed output
```

## Troubleshooting

**Agent keeps failing on the same task:**
- Task may be too large - break it into smaller subtasks
- Add a guardrail with specific instructions
- Check if dependencies are missing

**Progress file getting too large:**
- Move older entries to `progress-archive/YYYY-MM.md`
- Keep only last ~10 sessions in `progress-current.md`

**Agent not following project patterns:**
- Add patterns to the relevant workpad `knowledge.md`
- Be explicit: show code examples, not just descriptions

**Costs running higher than expected:**
- Reduce `max_iterations` in `ralph.yml`
- Set a lower `max_cost` limit
- Break tasks into smaller chunks (fewer iterations per task)

## Credits

- [ralph-orchestrator](https://github.com/mikeyobrien/ralph-orchestrator) - The orchestration engine
- [Ralph Wiggum technique](https://ghuntley.com/ralph/) - Original concept by Geoffrey Huntley
- [ralph-wiggum-cursor](https://github.com/agrimsingh/ralph-wiggum-cursor) - Guardrails inspiration

## License

MIT
