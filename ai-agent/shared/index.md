# Agent Behavior Guidelines

## Overview

Guidelines for AI agents working in this codebase. These rules ensure consistent behavior and quality across all interactions.

## Core Principles

- **Be concise** - Answer directly without unnecessary preamble or explanation
- **Be proactive** - Take appropriate action without asking for permission
- **Follow conventions** - Use existing patterns and respect project structure
- **Verify changes** - Run lint/typecheck before declaring success

## Behavior Rules

### Communication

- Use short responses unless detail is requested
- Avoid introductions, conclusions, and explanations
- Reference specific locations: `file:line`

### Code Quality

- Never add comments unless explicitly requested
- Follow language conventions in existing code
- Use existing libraries and utilities

### Safety

- Never commit secrets or keys
- Avoid destructive git commands without explicit request
- Never modify git config

### Task Completion

- Make all changes explicit before executing
- Run lint/typecheck when available
- Verify solutions with tests

## Commands Reference

| Command        | Description                     |
| -------------- | ------------------------------- |
| `/code-gen`    | Generate code from requirements |
| `/code-review` | Review code quality             |
| `/debug`       | Debug and fix errors            |
| `/docs`        | Documentation management        |
| `/git`         | Git operations                  |
| `/plan`        | Create implementation plan      |
| `/test`        | Generate and run tests          |

## Structure

```
shared/
├── agents/            # Tech stack profiles (coder-*)
├── commands/         # Slash command quick references
├── skills/           # Specialized skills
├── workflows/         # Detailed workflow implementations
├── rules/            # Code conventions and guidelines
│   ├── api-conventions.md
│   ├── clean-code.md
│   ├── code-convention.md
│   ├── database.md
│   ├── error-handling.md
│   ├── naming-convention.md
│   ├── security.md
│   ├── git-workflow.md
│   └── testing.md
└── knowledge/        # Project-specific domain knowledge
```

## Conventions Summary

| Area        | Convention                                  |
| ----------- | ------------------------------------------- |
| Indentation | 2 spaces                                    |
| Line length | 100 characters max                          |
| File naming | PascalCase (components), kebab-case (utils) |
| Functions   | Under 50 lines, single responsibility       |
| Testing     | Test behavior, not implementation           |

## Best Practices

- Read existing files before editing
- Use pattern matching:glob to find similar files
- Prefer edit over write for existing files
- Always read first for file modifications
- Use grep instead of grep command

## Knowledge Base

Project-specific domain knowledge is stored in `knowledge/`. Reference this folder for:

- Architecture decisions
- Business domain concepts
- Project-specific terminology
- Any information unique to this project
