# Shared - Universal AI IDE Configuration

Universal workflows, commands, and rules that can be mapped to any AI IDE.

## Structure

```
shared/
├── commands/           # Slash command quick references
│   ├── index.md       # All commands list
│   ├── code-gen.md
│   ├── code-review.md
│   ├── debug.md
│   ├── docs.md
│   ├── git.md
│   ├── plan.md
│   └── test.md
├── workflows/          # Detailed workflow implementations
│   ├── code-gen.md    # /code-gen
│   ├── code-review.md # /code-review
│   ├── debug.md       # /debug
│   ├── docs.md        # /docs
│   ├── git.md         # /git
│   ├── plan.md        # /plan
│   ├── test.md        # /test
│   ├── implement.md
│   ├── scaffold.md
│   └── deploy.md
└── rules/             # Code conventions and guidelines
    ├── code-convention.md
    ├── git-workflow.md
    └── testing.md
```

## Available Commands

| Command | Description |
|---------|-------------|
| `/code-gen` | Generate code from requirements |
| `/code-review` | Review code quality |
| `/debug` | Debug and fix errors |
| `/docs` | Documentation management |
| `/git` | Git operations |
| `/plan` | Create implementation plan |
| `/test` | Generate and run tests |

## IDE Mapping

| IDE | Command Location | Mapping |
|-----|------------------|---------|
| Antigravity | `.agent/` | Copy to `.agent/` |
| Cursor | `.cursor/rules/` | Use AGENTS.md |
| Claude Code | `.claude/` | Use CLAUDE.md |
| Windsurf | `.windsurfrules` | Use AGENTS.md |
| VS Code | `.vscode/` | Use AGENTS.md |

## How It Works

1. **User types `/command`** → IDE reads commands index
2. **Loads quick reference** → from `commands/`
3. **Executes workflow** → from `workflows/`

## Folder Purpose

| Folder | Purpose |
|--------|---------|
| `commands/` | Quick reference for slash commands |
| `workflows/` | Detailed step-by-step execution |
| `rules/` | Conventions, guidelines, standards |

## Benefits

- **Single source of truth** - one set of configurations
- **IDE agnostic** - works everywhere
- **Easy to update** - edit once, propagate everywhere
- **Version control** - track changes in one place

## Related

- See: `agents/` - Tech stack profiles (coder-*)
- See: `ide-index/` - IDE-specific configurations
