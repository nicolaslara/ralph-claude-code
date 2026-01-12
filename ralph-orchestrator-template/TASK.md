# Task List

## How to Use This File

- `[ ]` = Not started
- `[x]` = Complete (verified: typecheck + tests pass)
- Tasks are NOT ordered - select based on dependencies and current state
- Add new tasks as you discover them

---

## Current Priorities

### P0 - Critical (do first)
- [ ] Configure MCP servers and plugins for project tooling (see Infrastructure & Setup)
- [ ] [Describe critical task]

### P1 - Important
- [ ] [Describe important task]
- [ ] [Another important task]

### P2 - Nice to Have
- [ ] [Lower priority task]

---

## Categories

### Infrastructure & Setup

#### MCP & Plugin Configuration
- [ ] Set up MCP servers in `.mcp.json` for project-specific tools
- [ ] Configure Claude Code plugins if needed
- [ ] Set up Cursor MCP servers in `.cursor/mcp.json` (if different from root)

**Common MCP servers by project type:**

| Project Type | MCP Servers |
|--------------|-------------|
| Convex backend | `convex mcp start` |
| Supabase | `supabase mcp` |
| Database (Postgres) | `postgres-mcp` |
| E2E Testing | `maestro mcp` |
| Browser automation | `puppeteer mcp`, `playwright mcp` |
| Filesystem | `filesystem mcp` (for sandboxed access) |

Example `.mcp.json`:
```json
{
  "mcpServers": {
    "your-service": {
      "command": "npx",
      "args": ["-y", "your-mcp-package"]
    }
  }
}
```

#### Other Setup
- [ ] [Setup task]

### Core Features
- [ ] [Feature task]

### Testing
- [ ] [Testing task]

### Polish & UX
- [ ] [Polish task]

---

## Discovered During Work

<!-- Add tasks here as you find them -->

---

## Completed

<!-- Move completed tasks here for reference -->
