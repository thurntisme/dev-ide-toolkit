# Dev IDE Toolkit

IDE/Editor configurations for developers.

## Directory Structure

```
dev-ide-toolkit/
├── 📂 ai-agent/              # AI Agent configurations
│   ├── 📂 shared/           # Universal workflows, skills, rules
│   │   ├── 📂 workflows/    # /plan, /implement, /test, /debug...
│   │   ├── 📂 skills/      # code-gen, testing, debug, security
│   │   └── 📂 rules/       # code-style, git-workflow, testing
│   └── 📂 ide-index/         # IDE-specific configs
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

## AI Agent Commands

### Slash Commands

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

### Skills

| Skill | Description |
|-------|-------------|
| code-gen | Code generation |
| testing | Testing patterns |
| debug | Debugging guide |
| security | Security audit |

## Setup for New Project

```bash
# Windows
.\scripts\setup.ps1 C:\Projects\my-project

# Linux/macOS
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