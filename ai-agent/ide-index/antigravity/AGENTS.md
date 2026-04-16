# dev-ide-toolkit

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
│   ├── wordpress/
│   ├── nextjs/
│   ├── laravel/
│   └── nodejs/
├── role-profiles/    # Job-specific configs
│   ├── fe-dev/
│   ├── be-dev/
│   └── cloud-dev/
└── scripts/          # Automation tools
```

## Available Commands (Slash Commands)

| Command | Description |
|---------|-------------|
| `/plan` | Create implementation plan |
| `/implement` | Generate code from plan |
| `/test` | Run and generate tests |
| `/debug` | Debug and fix errors |
| `/code-review` | Review code quality |
| `/git` | Git operations |
| `/docs` | Generate documentation |
| `/deploy` | Deploy project |

## Tech Stack

- TypeScript preferred where possible
- Node.js for scripts
- JSON/YAML for config files

## Build Commands

```bash
# Install dependencies
npm install

# Copy configs to project
./scripts/setup.ps1 <target-dir>
```

## Coding Conventions

- Use TypeScript for new code
- Use 2 spaces for indentation
- Use single quotes for strings
- Maximum line length: 100 characters

## Testing

- Test files: `*.test.ts` or `*.spec.ts`
- Run: `npm test`

## Git Workflow

- Branch naming: `feature/description`, `fix/description`
- Commit format: `type(scope): description`

## Security

- No secrets in code
- Use environment variables for sensitive data

---

## Tool-Specific Files

| IDE | Config File |
|-----|-------------|
| Antigravity | `.agent/workflows/`, `GEMINI.md` |
| Cursor | `.cursor/rules/` |
| Claude Code | `.claude/` |
| Windsurf | `.windsurfrules` |
| VS Code | `.vscode/` |