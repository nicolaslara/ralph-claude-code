# Ralph Plugin for Claude Code

A custom implementation of the [Ralph Wiggum method](https://ghuntley.com/ralph/) for Claude Code with built-in guardrails, safety checks, and activity logging.

## Why This Plugin?

The official `ralph-wiggum` plugin is minimal. This plugin adds:

| Feature | Official | This Plugin |
|---------|----------|-------------|
| Custom prompt file (RALPH_PROMPT.md) | No | Yes |
| Guardrail enforcement | No | Yes |
| Blocks dangerous git commands | No | Yes |
| Activity logging | No | Yes |
| Single iteration mode | No | Yes |
| Status command | No | Yes |

### Safety Features

Automatically blocks commands that have caused issues:
- `git clean -fd` - Deletes untracked files including `.ralph/` state
- `git reset --hard <commit>` - Orphans all work since that commit
- `rm -rf .ralph` - Deletes critical state

## Installation

### From GitHub (Recommended)

```bash
# Add the marketplace
/plugin marketplace add nicolaslara/ralph-claude-code

# Install the plugin
/plugin install ralph@ralph-marketplace
```

### For Development

```bash
# Clone the repo
git clone https://github.com/nicolaslara/ralph-claude-code.git

# Run Claude Code with the plugin
claude --plugin-dir ./ralph-claude-code
```

## Commands

| Command | Description |
|---------|-------------|
| `/ralph:loop` | Start autonomous loop until completion |
| `/ralph:once` | Run single iteration for testing |
| `/ralph:status` | Show current progress and health |
| `/ralph:cancel` | Cancel active loop |

## Usage

### 1. Set Up Your Project

Create these files in your project:

```
your-project/
├── RALPH_TASK.md           # Tasks with [ ] checkboxes
├── RALPH_PROMPT.md         # Custom agent instructions (optional)
└── .ralph/
    ├── guardrails.md       # Lessons learned
    └── progress.md         # Progress log
```

### 2. Define Tasks

In `RALPH_TASK.md`:
```markdown
# My Project Tasks

## Phase 1: Setup
- [ ] Initialize project structure
- [ ] Set up testing framework
- [ ] Configure CI/CD

## Phase 2: Features
- [ ] Implement user authentication
- [ ] Add API endpoints
- [ ] Create frontend components
```

### 3. Test with Single Iteration

```
/ralph:once
```

Review the changes, then proceed to full loop if satisfied.

### 4. Run the Loop

```
/ralph:loop --max-iterations 20
```

Claude will work through tasks until all `[ ]` become `[x]` or max iterations reached.

## Custom Prompt (RALPH_PROMPT.md)

Create `RALPH_PROMPT.md` in your project root to customize agent behavior. Use `{{ITERATION}}` placeholder for current iteration number.

## Hooks

The plugin uses these Claude Code hooks:

| Hook | Purpose |
|------|---------|
| `Stop` | Continues the loop by re-prompting |
| `PreToolUse` (Bash) | Blocks dangerous commands |
| `PostToolUse` (Write/Bash) | Logs activity |

## State Files

| File | Purpose |
|------|---------|
| `.ralph/progress.md` | What's been accomplished |
| `.ralph/guardrails.md` | Lessons learned from failures |
| `.ralph/errors.log` | Failure tracking |
| `.ralph/activity.log` | Tool call log |
| `.ralph/.loop-state.json` | Active loop state |

## Contributing

Issues and PRs welcome! This plugin was born from real-world pain points using the Ralph method.

## Credits

- [Geoffrey Huntley](https://ghuntley.com/ralph/) - Original Ralph Wiggum technique
- [Anthropic](https://github.com/anthropics/claude-code) - Claude Code and official plugins

## License

MIT
