---
name: coder-rust-tauri
description: Rust and Tauri development. Use when user asks to create, modify, or debug Tauri desktop applications.
---

# Rust and Tauri Development Guide

## When to use
- User asks to create a Tauri desktop application
- User asks to add Rust backend functionality
- User asks about Tauri commands
- User asks to debug Tauri issues

## Conventions

- Use Rust 2021 edition or later
- Follow Rust naming conventions (snake_case functions, PascalCase types)
- Use `cargo` for Rust package management
- Separate frontend and backend clearly

## File Structure

```
tauri-app/
├── src/                  # Rust backend
│   ├── main.rs
│   └── lib.rs
├── src-tauri/            # Tauri configuration
│   ├── Cargo.toml
│   ├── tauri.conf.json
│   └── src/
│       └── main.rs
├── src/                  # Frontend (React/Vue/Svelte)
├── package.json
└── SPEC.md
```

## Cargo.toml

```toml
[package]
name = "tauri-app"
version = "0.1.0"
edition = "2021"

[lib]
name = "tauri_app_lib"
crate-type = ["staticlib", "cdylib", "rlib"]

[build-dependencies]
tauri-build = { version = "1.5", features = [] }

[dependencies]
tauri = { version = "1.6", features = ["shell-open"] }
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
```

## Tauri Commands

```rust
use tauri::command;

#[derive(Serialize)]
pub struct User {
    pub id: u32,
    pub name: String,
}

#[command]
fn get_user(id: u32) -> Result<User, String> {
    // Database call or other logic
    Ok(User { id, name: "John".to_string() })
}

#[command]
async fn async_operation() -> Result<String, String> {
    // Async operations
    Ok("Done".to_string())
}
```

## Tauri Configuration (tauri.conf.json)

```json
{
  "build": {
    "beforeDevCommand": "npm run dev",
    "beforeBuildCommand": "npm run build",
    "devPath": "http://localhost:1420",
    "distDir": "../dist",
    "devtools": true
  },
  "package": {
    "productName": "My App",
    "version": "1.0.0"
  },
  "tauri": {
    "allowlist": {
      "all": false,
      "shell": {
        "open": true
      }
    },
    "windows": [
      {
        "title": "My App",
        "width": 800,
        "height": 600,
        "resizable": true
      }
    ]
  }
}
```

## Frontend Invocation

```typescript
import { invoke } from "@tauri-apps/api/tauri";

const user = await invoke<User>('get_user', { id: 1 });
```

## Logging

```rust
use log::{info, error};

#[command]
fn my_command() {
    info!("Command executed");
    error!("Something went wrong");
}
```

## System Tray

```rust
use tauri::SystemTrayMenu;

let tray_menu = SystemTrayMenu::new()
    .add_item(SystemTrayMenuItem::new("Show", true, Some("show")))
    .add_item(SystemTrayMenuItem::new("Quit", true, Some("quit")));

let system_tray = SystemTray::new().with_menu(tray_menu);
```

## Build Commands

```bash
# Development
npm run tauri dev

# Build
npm run tauri build

# Check Rust
cargo check

# Format Rust
cargo fmt
```

## Security Checklist

- [ ] Validate all input in Rust (don't trust frontend)
- [ ] Use allowlist for Tauri commands
- [ ] Avoid `unsafe` code
- [ ] Use secure defaults in tauri.conf.json
- [ ] Don't expose sensitive data to renderer
