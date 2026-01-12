# Ralph Orchestrator Template

Enhanced prompt template for [ralph-orchestrator](https://github.com/mikeyobrien/ralph-orchestrator) with workpads model and battle-tested guardrails.

## Quick Start

```bash
# Install ralph-orchestrator
uv tool install ralph-orchestrator
# or: pip install ralph-orchestrator

# Copy this template to your project
cp -r ralph-orchestrator-template/* your-project/

# Edit TASK.md with your tasks
# Edit workpads/ with your project knowledge

# Run
ralph
```

## Structure

```
your-project/
├── ralph.yml              # Orchestrator configuration
├── PROMPT.md              # Agent instructions (customize as needed)
├── TASK.md                # Your task list (edit this!)
│
├── .agent/                # State directory (tracked in git!)
│   ├── guardrails.md      # Lessons learned from failures
│   ├── progress-current.md # Recent session logs
│   └── progress-archive/  # Older logs (git history)
│
└── workpads/              # Project knowledge bases
    ├── app/
    │   ├── knowledge.md   # Internal decisions, architecture
    │   └── references.md  # External docs, links
    ├── backend/
    │   ├── knowledge.md
    │   └── references.md
    └── testing/
        ├── knowledge.md
        └── references.md
```

## Key Concepts

### Workpads Model

Instead of one giant knowledge file, organize by domain:
- **app/** - Application architecture, UI patterns, decisions
- **backend/** - API design, data model, service decisions
- **testing/** - Test strategies, patterns, commands
- Add more as needed (e.g., `ai/`, `infra/`, `expo/`)

Each workpad has:
- `knowledge.md` - Internal decisions and patterns
- `references.md` - External documentation links

**Selective loading**: Agent only reads workpads relevant to current task, preserving context.

### Progress Rotation

Problem: Progress files grow and consume context.

Solution:
- `progress-current.md` - Last ~10 sessions (agent reads this)
- `progress-archive/YYYY-MM.md` - Older sessions (in git, not loaded)

When current exceeds ~200 lines, rotate older entries to archive.

### Guardrails

Hard-won lessons documented as "Signs":
```markdown
### Sign: [Name]
- **Trigger**: When [situation]
- **Instruction**: [What to do]
- **Why**: [What went wrong]
```

Agent reads these FIRST every iteration to avoid repeating mistakes.

## Configuration

Edit `ralph.yml`:

```yaml
max_iterations: 50      # Stop after N iterations
max_cost: 25.0          # USD spending limit
max_tokens: 1000000     # Token budget
checkpoint_interval: 5  # Git save frequency
```

## Critical Rules

1. **Git is memory** - Commits persist, conversations don't
2. **Never gitignore .agent/** - Only `activity.log` is gitignored
3. **One task at a time** - Complete and commit before moving on
4. **Test before marking complete** - typecheck + tests must pass
5. **Add guardrails from failures** - Every failure = new Sign

## Commands

```bash
ralph                    # Start autonomous loop
ralph -n 10              # Run max 10 iterations
ralph -p "quick task"    # Inline prompt (no PROMPT.md)
ralph --verbose          # Detailed output
```

## Credits

- [ralph-orchestrator](https://github.com/mikeyobrien/ralph-orchestrator) by Mike O'Brien
- [Ralph Wiggum technique](https://ghuntley.com/ralph/) by Geoffrey Huntley
- Guardrails inspired by [ralph-wiggum-cursor](https://github.com/agrimsingh/ralph-wiggum-cursor)
