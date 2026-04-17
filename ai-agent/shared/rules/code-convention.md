# Code Conventions (Multi-Language)

## General

- Use 2 spaces for indentation
- Maximum line length: 100 characters
- Use language-appropriate line endings (LF)
- Add final newline to all files
- Keep functions under 50 lines
- Keep components/classes under 200 lines
- Single responsibility principle

## File Naming

| Type | Convention | Example |
|------|------------|---------|
| Components | PascalCase | `UserProfile.tsx`, `UserProfile.vue` |
| Hooks | kebab-case | `use-user-data.ts` |
| Services | kebab-case | `auth-service.ts` |
| Utils | kebab-case | `format-date.ts` |
| Types/Interfaces | PascalCase | `UserType.ts`, `UserInterface.php` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Controllers | PascalCase | `UserController.ts`, `UserController.php` |
| Models | PascalCase | `User.php`, `User.ts` |

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

## Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Files | kebab-case or PascalCase | `user-service.ts`, `UserModel.php` |
| Variables | camelCase / snake_case | `userName`, `user_name` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Functions | camelCase / snake_case | `getUser`, `get_user` |
| Classes | PascalCase | `UserService`, `AuthHandler` |
| Interfaces/Types | PascalCase | `User`, `ApiResponse` |

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
