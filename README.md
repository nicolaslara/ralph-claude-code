# Ralph Orchestrator Template

Enhanced prompt template for [ralph-orchestrator](https://github.com/mikeyobrien/ralph-orchestrator) featuring the **workpads model** for organized project knowledge and battle-tested guardrails from real autonomous development sessions.

## Installation

```bash
# Install ralph-orchestrator
uv tool install ralph-orchestrator
# or: pip install ralph-orchestrator

# Clone this repo and install the setup command
git clone https://github.com/nicolaslara/ralph-claude-code.git
cd ralph-claude-code
sudo ./install.sh  # Installs 'ralph-setup' command
```

## Setting Up a New Project

The `ralph-setup` command creates a new project with the template and guides you through initial setup.

### Option 1: With Description (Recommended)

```bash
ralph-setup ~/devel/my-app "A recipe management mobile app using React Native, Expo, and Convex for the backend. Should support offline mode and AI-powered recipe suggestions."
```

### Option 2: Interactive Mode

```bash
ralph-setup ~/devel/my-app
# Prompts for project description
```

### What Happens

1. **Template files are copied** to your project directory
2. **SETUP_INPUT.md** is created with your project description
3. **You run Claude Code** and ask it to set up the project:

```bash
cd ~/devel/my-app
git init
claude  # or cursor, or your preferred AI coding tool
```

Then tell Claude:

> Read SETUP_PROMPT.md and SETUP_INPUT.md, then set up this project.

Claude will:
- **Create appropriate workpads** for your project type (app, backend, ai, etc.)
- **Populate knowledge.md** with architecture decisions and patterns
- **Populate references.md** with relevant documentation links
- **Generate TASK.md** with research tasks, setup tasks, and initial features
- **Add project-specific guardrails** based on your tech stack

### Example

```bash
# Create a new smart contract project
ralph-setup ~/devel/my-token "ERC-20 token with vesting schedules, built with Foundry. Need to support cliff periods, linear vesting, and admin revocation."

cd ~/devel/my-token
git init
claude

# Tell Claude:
# "Read SETUP_PROMPT.md and SETUP_INPUT.md, then set up this project."

# Claude creates:
# - workpads/contracts/ (Solidity patterns, security checklist)
# - workpads/testing/ (Foundry test patterns, fuzzing setup)
# - TASK.md with research tasks (vesting patterns, audit prep) and implementation tasks
```

After Claude finishes, review and commit:

```bash
git add -A && git commit -m "Initial project setup with workpads"
ralph  # Start the autonomous loop
```

## Manual Setup (Without Setup Script)

If you prefer to set things up manually:

```bash
# Copy template to your project
cp -r ralph-orchestrator-template/* ~/your-project/

# Edit TASK.md with your tasks
# Populate workpads/ with your project knowledge

# Run
cd ~/your-project && ralph
```

## Usage

### Running the Loop

```bash
# First run: use fewer iterations to verify setup
ralph -n 5

# If working well, run full loop
ralph

# Run overnight with higher limits
ralph -n 100 --max-cost 50
```

### Monitoring Progress

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
| `ai/` | LLM integration, prompts, model choices |
| `infra/` | Deployment, CI/CD, cloud services |
| `contracts/` | Smart contracts, blockchain specifics |

Add more as needed for your project.

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

## Task Writing Guidelines

- Each task should be completable in one iteration (< 30 min of agent work)
- Be specific: "Add logout button to header" not "Improve auth"
- Include acceptance criteria when helpful
- Break large features into subtasks

Example:
```markdown
## P0 - Research (do first)
- [ ] Research auth options - compare Clerk, Auth0, Supabase Auth
- [ ] Evaluate state management - Zustand vs Jotai vs Redux

## P0 - Setup
- [ ] Initialize Expo project with TypeScript
- [ ] Configure ESLint and Prettier
- [ ] Set up Jest testing

## P1 - Core Features
- [ ] Implement user registration flow
- [ ] Add recipe list screen with search
```

## Critical Rules

These are baked into the template but worth understanding:

1. **Git is memory** - Conversations don't persist between iterations. Commits do.
2. **Never gitignore .agent/** - Only `activity.log` should be gitignored
3. **One task at a time** - Complete fully, test, commit, then move on
4. **Test before marking complete** - Typecheck + tests must pass
5. **Add guardrails from failures** - Every failure should become a new Sign

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
