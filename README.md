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
    ├── 📄 setup                # Bash script to copy configs (Linux/macOS)
    ├── 📄 setup.ps1            # PowerShell script to copy configs (Windows)
    └── 📄 merge-json.py        # Script to merge multiple settings.json files
```

## How to Use

### Option 1: Clone to Local Machine

```bash
git clone https://github.com/thurntisme/dev-ide-toolkit.git ~/dev-ide-toolkit
```

### Option 2: Use Directly in Project

Copy the folder structure manually or via script to your project:

```bash
# Linux/macOS
./scripts/setup ~/Documents/my-project

# Windows
.\setup.ps1 C:\Projects\my-project
```

The script will prompt you to select:
1. IDE config (vscode, cursor, kiro-zed, antigravity)
2. Tech stack (wordpress, nextjs, laravel, nodejs)
3. Role profile (fe-dev, be-dev, cloud-dev)

### Output Structure

After running the script, your project will have:

```
my-project/
└── vscode/              # IDE folder (vscode, cursor, kiro-zed, or antigravity)
    ├── settings.json    # IDE config files
    ├── keybindings.json
    ├── extensions.json
    ├── tech-stack/      # Tech stack config files
    └── role-profile/    # Role profile config files
```

### Available Options

| Category | Choices |
|----------|---------|
| IDE | vscode, cursor, kiro-zed, antigravity |
| Tech Stack | wordpress, nextjs, laravel, nodejs |
| Role Profile | fe-dev, be-dev, cloud-dev |

## Merge JSON (Optional)

Use `merge-json.py` to merge multiple settings.json files:

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
