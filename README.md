# Dev IDE Toolkit

IDE/Editor configurations for developers.

## Directory Structure

```
dev-ide-toolkit/
├── 📂 ide-configs/             # Base configurations for each IDE
│   ├── 📂 vscode/              # settings.json (font, theme, UI), keybindings.json
│   ├── 📂 cursor/              # .cursorrules (general AI behavior), AI settings
│   └── 📂 kiro-zed/            # Specific config for Kiro/Zed (performance, keymap)
│
├── 📂 tech-stacks/             # Language/framework-specific configurations
│   ├── 📂 wordpress/           
│   │   └── 📂 .vscode/         # extensions.json (WP hooks), settings.json (PHP)
│   ├── 📂 nextjs/              
│   │   └── 📂 .vscode/         # settings.json (Tailwind, TS), snippets (React)
│   ├── 📂 laravel/             
│   │   └── 📂 .vscode/         # extensions.json (Blade), snippets (Artisan)
│   └── 📂 nodejs/              
│       └── 📂 .cursor/         # .cursorrules (Node/TS expert instructions)
│
├── 📂 role-profiles/           # Job-specific configurations
│   ├── 📂 fe-dev/              # Chrome Debugger, CSS Linters, Accessibility tools
│   ├── 📂 be-dev/              # REST Client configs, SQL/DB connectors, Docker snippets
│   └── 📂 cloud-dev/           # Terraform, K8s manifests, AWS/GCP extensions
│
└── 📂 scripts/                 # Automation tools
    ├── 📄 setup.sh             # Script to copy folders into project
    └── 📄 merge-json.py        # Script to merge multiple settings.json files
```

## Usage

### 1. Copy config to project

Run `setup.sh` to copy desired config to your project folder:

```bash
./scripts/setup.sh <ide> <tech-stack> <role-profile>
```

Example:
```bash
./scripts/setup.sh vscode nextjs fe-dev
```

### 2. Merge multiple settings files

Use `merge-json.py` to merge settings.json files:

```bash
python scripts/merge-json.py output.json file1.json file2.json
```

## Common Keyboard Shortcuts

| Action | VS Code | Cursor | Zed |
|--------|---------|--------|-----|
| Command Palette | `Ctrl+Shift+P` | `Ctrl+Shift+P` | `Ctrl+Shift+P` |
| Quick Open | `Ctrl+P` | `Ctrl+P` | `Ctrl+P` |
| Terminal | ``Ctrl+` `` | ``Ctrl+` `` | ``Ctrl+` `` |
| Go to Definition | `F12` | `F12` | `F12` |
| Find in Files | `Ctrl+Shift+F` | `Ctrl+Shift+F` | `Ctrl+Shift+F` |

## Requirements

- Python 3.x (for merge-json.py)
- Git (to clone/copy config)
