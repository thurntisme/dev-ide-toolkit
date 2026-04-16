# Dev IDE Toolkit - Claude Code Configuration

## Project Overview

IDE/Editor configurations for developers. Includes settings, snippets, and rules for VS Code, Cursor, and Kiro/Zed.

## Directory Structure

```
dev-ide-toolkit/
├── ide-configs/       # Base IDE configurations
│   ├── vscode/       # settings.json, keybindings.json
│   ├── cursor/       # .cursorrules, AI settings
│   └── kiro-zed/     # Zed config, keymap
├── tech-stacks/      # Language/framework configs
├── role-profiles/    # Job-specific configs
└── scripts/          # Automation tools
```

## Available Commands

| Command | Description |
|---------|-------------|
| /plan | Create implementation plan |
| /implement | Generate code from plan |
| /test | Run and generate tests |
| /debug | Debug and fix errors |
| /code-review | Review code quality |
| /git | Git operations |
| /docs | Generate documentation |
| /deploy | Deploy project |

## Tech Stack

- TypeScript preferred
- Node.js for scripts
- JSON/YAML for config files

## Build Commands

```bash
npm install
./scripts/setup.ps1 <target-dir>
```

## Coding Conventions

- Use 2 spaces for indentation
- Use single quotes for strings
- Maximum line length: 100 characters

## Testing

- Test files: `*.test.ts` or `*.spec.ts`
- Run: `npm test`

## Git Workflow

- Branch naming: `feature/description`, `fix/description`
- Commit format: `type(scope): description`

## Tool-Specific Files

- Antigravity: `.agent/workflows/`, `GEMINI.md`
- Cursor: `.cursor/rules/`
- Claude Code: `.claude/`
- Windsurf: `.windsurfrules`
- VS Code: `.vscode/`