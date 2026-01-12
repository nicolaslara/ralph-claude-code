# Project Setup Prompt

You are setting up a new project with the ralph-orchestrator template. Read `SETUP_INPUT.md` for the project description, then create the necessary workpads, tasks, and research items.

## Your Goals

1. **Understand the project** - Read SETUP_INPUT.md thoroughly
2. **Create workpads** - Organize knowledge by domain (delete unused template workpads, create new ones as needed)
3. **Populate initial knowledge** - Document what's known, decisions made, architecture choices
4. **Identify research needed** - What needs to be investigated before building?
5. **Create initial tasks** - Setup tasks, research tasks, and first implementation tasks
6. **Create Cursor rules** - Add project-specific rules for the tech stack

## Step 1: Analyze the Project

Read `SETUP_INPUT.md` and identify:
- What type of project is this? (web app, mobile app, CLI tool, library, smart contracts, etc.)
- What are the main technical domains? (frontend, backend, AI, testing, infra, etc.)
- What decisions have already been made vs. need research?
- What are the key uncertainties or risks?

## Step 2: Create Workpads Structure

Delete the template workpads that don't apply. Create new ones as needed.

**Common workpad types:**

| Domain | When to Create |
|--------|----------------|
| `app/` | Any application with UI/UX decisions |
| `backend/` | APIs, databases, server-side logic |
| `frontend/` | Web/mobile UI frameworks, components |
| `expo/` or `mobile/` | React Native / mobile-specific |
| `ai/` | LLM integration, ML features |
| `testing/` | Test strategy, tools, patterns |
| `infra/` | Deployment, CI/CD, cloud services |
| `contracts/` or `solidity/` | Smart contracts, blockchain |
| `auth/` | Authentication, authorization |
| `data/` | Data modeling, ETL, analytics |

**Each workpad needs:**
- `knowledge.md` - Internal decisions, architecture, patterns
- `references.md` - External docs, links, resources to consult

## Step 3: Populate knowledge.md Files

For each workpad, create a knowledge.md with:

```markdown
# [Domain] Knowledge Base

> Brief description of what this workpad covers

## Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Design Decisions](#design-decisions)
- [Patterns](#patterns)
- [Open Questions](#open-questions)

---

## Overview

[What this domain covers in this project]

---

## Architecture

[High-level architecture, diagrams if helpful]

```
[ASCII diagram or code structure]
```

---

## Design Decisions

| ID | Decision | Rationale | Date |
|----|----------|-----------|------|
| D1 | [What was decided] | [Why] | YYYY-MM-DD |

---

## Patterns

### [Pattern Name]
```[language]
// Example code showing the pattern
```

---

## Open Questions

- [ ] [Question that needs resolution]
- [ ] [Another question]
```

## Step 4: Populate references.md Files

For each workpad, create a references.md with:

```markdown
# [Domain] References

> External resources for [domain]

## Quick Navigation

| Working on... | Consult |
|---------------|---------|
| [Task type] | [Sections] |

---

## [Category 1]

| Resource | URL | Purpose |
|----------|-----|---------|
| [Name] | [URL] | [What it helps with] |

---

## [Category 2]

| Resource | URL | Purpose |
|----------|-----|---------|
| [Name] | [URL] | [What it helps with] |

---

## Research Needed

- [ ] [Topic to research] - [Why it's needed]
- [ ] [Another topic]
```

## Step 5: Create workpads/README.md

Create an index explaining the workpads:

```markdown
# Workpads

Project knowledge organized by domain.

## Structure

```
workpads/
├── [workpad1]/
│   ├── knowledge.md    # Internal decisions, architecture
│   └── references.md   # External docs, links
├── [workpad2]/
│   ├── knowledge.md
│   └── references.md
└── README.md           # This file
```

## Workpads

| Workpad | Purpose | When to Load |
|---------|---------|--------------|
| [name]/ | [description] | [task types] |

## Always Active

These workpads are relevant to most tasks:
- [workpad] - [why]

## How to Use

**Before starting work:**
1. Read guardrails.md
2. Read progress-current.md
3. Load relevant workpads for your task

**During work:**
- Add new decisions to knowledge.md
- Add useful references to references.md
- Document open questions
```

## Step 6: Create TASK.md

Create the initial task list with:

1. **MCP/Plugin setup** (P0) - Configure IDE tooling for the project
2. **Research tasks** (P0) - Things that need investigation before building
3. **Setup tasks** (P0) - Project scaffolding, tooling, CI
4. **Core feature tasks** (P1) - Main functionality
5. **Polish tasks** (P2) - Nice to have, optimization

```markdown
# Tasks

## How to Use
- `[ ]` = Not started
- `[x]` = Complete
- Select tasks based on dependencies and current state

---

## P0 - MCP & Plugin Setup

- [ ] Configure MCP servers in `.mcp.json` for project tooling
- [ ] Set up Cursor MCP in `.cursor/mcp.json` (if needed)

## P0 - Research (do first)

- [ ] Research [topic] - document findings in workpads/[domain]/knowledge.md
- [ ] Evaluate [options] - add comparison to workpads/[domain]/knowledge.md

## P0 - Setup

- [ ] Initialize project structure
- [ ] Set up development environment
- [ ] Configure testing framework
- [ ] Set up CI/CD pipeline

## P1 - Core Features

- [ ] [Feature 1]
- [ ] [Feature 2]

## P2 - Polish

- [ ] [Polish item]

---

## Discovered During Work

<!-- Add tasks here as you find them -->
```

### MCP Server Reference

**Always include relevant MCP servers** based on the tech stack:

| Tech Stack | MCP Server | Config |
|------------|------------|--------|
| Convex | `convex` | `npx -y convex@latest mcp start` |
| Supabase | `supabase` | `npx -y @supabase/mcp-server` |
| PostgreSQL | `postgres` | `npx -y @modelcontextprotocol/server-postgres` |
| Firebase | `firebase` | Check for official MCP |
| Maestro (E2E) | `maestro` | `maestro mcp --working-dir=<path>` |
| Puppeteer | `puppeteer` | `npx -y @anthropic/mcp-puppeteer` |
| Playwright | `playwright` | `npx -y @anthropic/mcp-playwright` |
| GitHub | `github` | `npx -y @anthropic/mcp-github` |
| Filesystem | `filesystem` | `npx -y @anthropic/mcp-filesystem <paths>` |

**Example `.mcp.json` for a Convex + Maestro project:**
```json
{
  "mcpServers": {
    "convex": {
      "command": "npx",
      "args": ["-y", "convex@latest", "mcp", "start"]
    },
    "maestro": {
      "command": "maestro",
      "args": ["mcp", "--working-dir", "./apps/mobile"]
    }
  }
}
```

**Example for a Supabase + Playwright project:**
```json
{
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": ["-y", "@supabase/mcp-server"],
      "env": {
        "SUPABASE_URL": "${SUPABASE_URL}",
        "SUPABASE_SERVICE_KEY": "${SUPABASE_SERVICE_KEY}"
      }
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-playwright"]
    }
  }
}
```

## Step 7: Update .agent/guardrails.md

Add any project-specific guardrails based on the tech stack. For example:

- Smart contracts: "Always run slither before committing"
- React Native: "Test on both iOS and Android"
- APIs: "Never expose secrets in client code"

## Step 8: Create Project-Specific Cursor Rules

The template includes base Cursor rules in `.cursor/rules/`:
- `ralph-workflow.mdc` - Core Ralph workflow (don't modify)
- `workpads-workflow.mdc` - Workpads usage (don't modify)

**Add project-specific rules** for your tech stack. Create new `.mdc` files:

```markdown
---
description: [Brief description of what this rule covers]
globs:
alwaysApply: true
---

# [Rule Name]

[Content specific to your tech stack]
```

**Common project-specific rules:**

| Tech Stack | Rule File | Content |
|------------|-----------|---------|
| React Native/Expo | `expo.mdc` | Expo best practices, component patterns |
| Solidity | `solidity.mdc` | Security patterns, gas optimization, testing |
| Next.js | `nextjs.mdc` | App router patterns, server components |
| Python | `python.mdc` | Type hints, testing, linting standards |
| Convex | `convex.mdc` | Schema patterns, query/mutation conventions |

**Example for a Solidity project:**

```markdown
---
description: Solidity development best practices
globs:
alwaysApply: true
---

# Solidity Rules

## Before Every Commit
1. Run `forge test` - all tests must pass
2. Run `slither .` - no high/medium findings
3. Run `forge snapshot` - check gas changes

## Security Checklist
- [ ] No external calls before state changes (reentrancy)
- [ ] Check for overflow in arithmetic (use SafeMath or 0.8+)
- [ ] Validate all inputs from external sources

## Patterns
- Use OpenZeppelin contracts where possible
- Prefer `error` over `require` strings for gas efficiency
```

**Example for a React Native/Expo project:**

```markdown
---
description: Expo and React Native best practices
globs:
alwaysApply: true
---

# Expo Rules

## Testing Requirements
- Test on both iOS simulator and Android emulator
- Web can be used for rapid iteration but always verify mobile

## Component Patterns
- Use NativeWind for styling (Tailwind CSS)
- Prefer functional components with hooks
- Use `expo-router` for navigation

## Performance
- Avoid inline styles in render
- Use `useMemo` and `useCallback` for expensive operations
- Prefer FlatList over ScrollView for lists
```

## Step 9: Commit Everything

After creating all files:
```bash
git add -A
git commit -m "project: Initial workpads and task setup"
```

## Output

When done, summarize:
1. What workpads were created and why
2. Key research items identified
3. Initial task priorities
4. Any assumptions made that should be validated
