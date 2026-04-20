---
name: agents
description: "Universal AI Agent Configuration for all IDEs"
version: "1.0.0"
---

# AGENTS.md - Universal AI Agent Configuration

This file contains shared commands and rules that AI agents can use across any IDE.

## Quick Reference

| Command | Purpose | Command File |
|---------|---------|--------------|
| `/code-gen` | Generate code from requirements | `commands/code-gen.md` |
| `/code-gen --strict` | Generate code with test verification | `skills/code-gen/strict-implement.md` |
| `/code-gen --dry-run` | Preview changes without applying | `skills/code-gen/plan-implement.md` |
| `/code-gen --interactive` | Step-by-step with confirmation | `skills/code-gen/confirm-implement.md` |
| `/code-gen fix [error]` | Debug and fix errors | `skills/code-gen/debug-fix.md` |
| `/code-gen refactor X` | Optimize code without changing behavior | `skills/code-gen/refactor.md` |
| `/code-review` | Review code quality | `commands/code-review.md` |
| `/debug` | Debug and fix errors | `commands/debug.md` |
| `/docs` | Documentation management | `commands/docs.md` |
| `/git` | Git operations | `commands/git.md` |
| `/plan` | Create implementation plan | `commands/plan.md` |
| `/test` | Generate and run tests | `commands/test.md` |

## File Structure

```
shared/
├── commands/           # Slash command quick refs
├── rules/              # Code conventions & guidelines
├── agents/             # Tech stack profiles (coder-*)
├── knowledge/          # Domain-specific knowledge
├── skills/             # Specialized agent skills
│   └── code-gen/       # Code generation sub-skills
└── docs/               # Project documentation
```

## How to Use

1. **When user types `/command`** → Load `commands/<command>.md` for reference
2. **For code-gen with flags** → Load corresponding skill from `skills/code-gen/`
3. **For rules/conventions** → Load `rules/*.md`
4. **For domain knowledge** → Load `knowledge/*.md`

## Code Generation Workflow

The `/code-gen` command uses sub-skills based on flags:

| Flag | Skill | Purpose |
|------|-------|---------|
| (default) | `quick-implement.md` | Autonomous implementation |
| `--strict` | `strict-implement.md` | With test verification |
| `--dry-run` | `plan-implement.md` | Preview without execution |
| `--interactive` | `confirm-implement.md` | Step-by-step confirmation |
| `fix [error]` | `debug-fix.md` | Error analysis and fixing |
| `refactor X` | `refactor.md` | Code optimization |

## IDE-Specific Usage

| IDE | Config Location | File to Use |
|-----|---------------|-------------|
| Antigravity | `.agent/` | Copy `shared/` contents |
| Cursor | `.cursor/rules/` | This file as `AGENTS.md` |
| Claude Code | `.claude/` | This file as `CLAUDE.md` |
| Windsurf | `.windsurfrules` | This file as `AGENTS.md` |
| VS Code | `.vscode/` | This file as `AGENTS.md` |

## Folder Purposes

| Folder | When to Use |
|--------|-------------|
| `commands/` | Quick command reference, flags, examples |
| `rules/` | Code style, git workflow, testing conventions |
| `agents/` | Tech stack specific profiles |
| `skills/` | Specialized execution workflows |
| `knowledge/` | Domain-specific context |
| `docs/` | Project documentation |

## Benefits

- Single source of truth for all IDEs
- IDE agnostic - works anywhere
- Easy to update and maintain
- Version controllable

## Related

- `agents/` - Tech stack specific profiles (coder-*)
- `skills/code-gen/` - Code generation workflows
- `ide-index/` - IDE-specific configurations