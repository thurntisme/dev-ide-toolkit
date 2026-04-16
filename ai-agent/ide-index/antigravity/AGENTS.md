# Antigravity IDE Agent

## Project Context

Work exclusively with Antigravity IDE. All operations should be performed within Antigravity's environment and workflow.

## Working Directory

```
ai-agent/ide-index/antigravity
```

## IDE-Specific Configuration

- Config files: `.agent/workflows/`
- Workflows directory: `.agent/workflows/`

## Available Slash Commands

| Command | Description |
|---------|-------------|
| `/plan` | Create implementation plan |
| `/implement` | Generate code from plan |
| `/test` | Run and generate tests |
| `/debug` | Debug and fix errors |
| `/code-review` | Review code quality |
| `/git` | Git operations |
| `/docs` | Generate documentation |

## Workflow Guidelines

1. Always work within Antigravity IDE's workflow system
2. Use `.agent/workflows/` for automated tasks
3. Focus on code generation and implementation tasks

## Coding Standards

- Use TypeScript where possible
- 2 spaces for indentation
- Single quotes for strings
- Max line length: 100 characters

## Git Workflow

- Branch naming: `feature/description`, `fix/description`
- Commit format: `type(scope): description`