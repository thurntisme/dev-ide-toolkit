# Coder Type

AI agent uses this file to determine which coder sub-agent to use based on the project technology.

## Tech Stack Mapping

| Tech | Coder Agent |
|------|-------------|
| Laravel | coder-laravel |
| Next.js | coder-nextjs |
| PHP | coder-php |
| Python | coder-python |
| React.js | coder-reactjs |
| Rust / Tauri | coder-rust-tauri |
| WordPress | coder-wordpress |

## Pattern Matching

When selecting a coder:

1. Check package.json, cargo.toml, composer.json, or go.mod for framework/language
2. Match against tech stack mapping above
3. Default to `coder-general` if no match found