# Dev IDE Toolkit

IDE/Editor configurations for developers.

## Directory Structure

```
dev-ide-toolkit/
├── ai-agent/              # AI Agent configurations
│   ├── shared/           # Universal workflows, skills, rules
│   │   ├── 📂 workflows/    # /plan, /implement, /test, /debug...
│   │   ├── 📂 skills/      # code-gen, testing, debug, security
│   │   └── 📂 rules/       # code-style, git-workflow, testing
│   └── 📂 ide-index/       # IDE-specific configs
│       ├── antigravity/     # .agent/ ready
│       ├── cursor/          # .cursor/rules ready
│       ├── windsurf/        # .windsurfrules ready
│       └── claude/           # .claude/ ready
│
├── 📂 ide-configs/           # IDE general settings (VS Code, etc.)
│   └── 📂 vscode/           # settings.json, extensions.json
│
└── 📂 scripts/              # Setup scripts
    ├── setup                # Linux/macOS
    └── setup.ps1            # Windows
```

## How It Works

### 1. ai-agent/ folder
Where to place AI agent configuration (workflows, skills, rules).
- `shared/` - Universal source (edit once, use all IDEs)
- `ide-index/` - Ready-to-copy configs per IDE

### 2. ide-configs/ folder
Where to place IDE general settings.
- VS Code settings, extensions, snippets
- Future: cursor, windsurf, etc.

### 3. scripts/ folder
Run script to setup toolkit for a new project.

---

## How to Implement AI Agent

### File Types

| Type | Location | Trigger |
|------|----------|---------|
| **Workflow** | `ai-agent/shared/workflows/*.md` | Slash command (e.g., `/scaffold`) |
| **Skill** | `ai-agent/shared/skills/*/SKILL.md` | Context-based |
| **Rule** | `ai-agent/shared/rules/*.md` | Always active |

### 1. Create a Workflow

File: `ai-agent/shared/workflows/<name>.md`

```markdown
---
description: Short description of what this workflow does
---

1. Step one
2. Step two
3. Step three
```

**Usage:** Type `/<name>` in chat.

### 2. Create a Skill

Folder: `ai-agent/shared/skills/<name>/SKILL.md`

```markdown
---
name: <name>
description: When to use this skill. Use when user asks to...
---

# Skill Guide

## When to use
- User asks for X
- User asks for Y

## Steps
1. Do this
2. Do that
```

**Usage:** Triggers automatically when relevant.

### 3. Create a Rule

File: `ai-agent/shared/rules/<name>.md`

```markdown
# Rule Name

## Guidelines
- Always do X
- Never do Y
- Use Z format
```

**Usage:** Always loaded in context.

---

## AI Agent Commands

### Slash Commands (Workflows)

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
| `/scaffold` | Scaffold new component/file |

### Skills

| Skill | Description |
|-------|-------------|
| code-gen | Code generation |
| testing | Testing patterns |
| debug | Debugging guide |
| security | Security audit |

---

## Setup for New Project

```bash
# Windows
.\scripts\setup.ps1 C:\Projects\my-project

# Linux/macOS
chmod +x scripts/setup
./scripts/setup ~/Documents/my-project
```

Then select:
1. IDE (vscode, cursor, windsurf, antigravity, claude)
2. Tech stack (optional)
3. Role profile (optional)

## Copy AI Agent Config to Project

```bash
# For Antigravity
cp -r ai-agent/ide-index/antigravity .agent/

# For Cursor
mkdir .cursor
cp ai-agent/ide-index/cursor/rules/* .cursor/rules/

# For Claude Code
mkdir .claude
cp ai-agent/ide-index/claude/CLAUDE.md .claude/

# For Windsurf
cp ai-agent/ide-index/windsurf/.windsurfrules ./
```

Or use the setup script to automate.

## Tech Stack & Role Profiles

```
ai-agent/
├── tech-stacks/            # Language/framework configs
│   ├── wordpress/
│   ├── nextjs/
│   ├── laravel/
│   └── nodejs/
│
└── role-profiles/           # Job-specific configs
    ├── fe-dev/
    ├── be-dev/
    └── cloud-dev/
```

## Configuration Files

| IDE | Config Location |
|-----|-----------------|
| VS Code | ide-configs/vscode/ |
| Antigravity | ai-agent/ide-index/antigravity/ |
| Cursor | ai-agent/ide-index/cursor/ |
| Windsurf | ai-agent/ide-index/windsurf/ |
| Claude Code | ai-agent/ide-index/claude/ |

## Requirements

- Git (to clone/copy config)
- Target IDE installed

## License

MIT
