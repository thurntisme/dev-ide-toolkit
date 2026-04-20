# Code Conventions (Multi-Language)

## General

- Use 2 spaces for indentation
- Maximum line length: 100 characters
- Use language-appropriate line endings (LF)
- Add final newline to all files
- Keep functions under 50 lines
- Keep components/classes under 200 lines
- Single responsibility principle

## Project Structure

### JavaScript/TypeScript

```
src/
├── components/     # Reusable UI components
├── pages/          # Route pages
├── hooks/          # Custom React hooks
├── services/       # API services
├── utils/          # Utility functions
├── types/          # TypeScript types
├── constants/     # App constants
└── assets/         # Static assets
```

### Python

```
src/
├── controllers/   # Request handlers
├── models/        # Data models
├── services/      # Business logic
├── utils/         # Helper functions
└── config/        # Configuration
```

### PHP (Laravel)

```
app/
├── Http/
│   └── Controllers/
├── Models/
├── Services/
└── Providers/
```

## Code Organization

### Functions

- Name with verb prefix: `getUser`, `fetchData`, `handleSubmit`
- Use async/await over promises
- Add return types for exported functions

### Classes/Components

- Extract sub-components > 50 lines
- Use composition over inheritance

### Imports

Organize in groups:

1. External packages
2. Internal modules
3. Types/interfaces

### Error Handling

- Always use try/catch for async operations
- Provide meaningful error messages
- Log errors for debugging

## Language-Specific Rules

### TypeScript/JavaScript

- Use single quotes for strings
- Add semicolons at end of statements
- Use explicit return types for exported functions
- Use `interface` for objects, `type` for unions/aliases
- Avoid `any`, use `unknown` if type is uncertain
- Use strict null checks

### Python

- Follow PEP 8
- Use snake_case for functions/variables
- Use PascalCase for classes
- Use type hints for all function signatures
- Use dataclasses for simple data objects

### PHP

- Follow PSR-12
- Use snake_case for functions/variables
- Use PascalCase for classes
- Use type hints and return types
- Use PHP 8+ features where applicable

### Rust

- Use snake_case for functions/variables
- Use PascalCase for structs/enums
- Use explicit lifetimes where needed
- Derive traits for common functionality

### Go

- Use PascalCase for exported functions
- Use camelCase for private functions
- Keep code in src/ or internal/

## Documentation

- Add JSDoc/docstrings for exported functions
- Document complex algorithms
- Keep README updated
- Document public APIs
