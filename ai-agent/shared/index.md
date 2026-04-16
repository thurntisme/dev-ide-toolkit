# Shared Workflows - Universal Format

Universal workflows/skills/rules that can be mapped to any AI IDE.

## Structure

```
shared/
├── workflows/         # 8 workflow files (.md)
│   ├── plan.md       # /plan
│   ├── implement.md  # /implement
│   ├── test.md      # /test
│   ├── debug.md     # /debug
│   ├── code-review.md
│   ├── git.md
│   ├── docs.md
│   └── deploy.md
├── skills/            # 4 skill folders (each has SKILL.md)
│   ├── code-gen/SKILL.md
│   ├── testing/SKILL.md
│   ├── debug/SKILL.md
│   └── security/SKILL.md
└── rules/            # 3 rule files (.md)
    ├── code-style.md
    ├── git-workflow.md
    └── testing.md
```

## IDE Mapping

| IDE | Command Location | Mapping |
|-----|---------------|---------|
| Antigravity | `.agent/` | Copy to `.agent/` |
| Cursor | `.cursor/rules/` | Use AGENTS.md |
| Claude Code | `.claude/` | Use CLAUDE.md |
| Windsurf | `.windsurfrules` | Use AGENTS.md |
| VS Code | `.vscode/` | Use AGENTS.md |

## How It Works

1. **User types `/plan`** → IDE reads AGENTS.md
2. **AGENTS.md** points to shared workflow
3. **IDE loads workflow** → executes steps

## Copy Scripts

```bash
# For Antigravity
cp -r shared/* .agent/

# For Claude Code
mkdir .claude && cp shared/index.md .claude/
```

## Benefits

- **Single source of truth** - one set of workflows
- **IDE agnostic** - works everywhere
- **Easy to update** - edit once, propagate everywhere
- **Version control** - track changes in one place