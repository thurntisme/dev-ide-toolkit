# Naming Conventions

## General Principles

- Use English for all names
- Be descriptive and clear
- Avoid abbreviations unless well-known
- Consider searchability

## Files

### Extensions

| Type | Extension |
|------|-----------|
| TypeScript | `.ts` |
| TypeScript React | `.tsx` |
| JavaScript | `.js` |
| Python | `.py` |
| PHP | `.php` |
| Style | `.css`, `.scss` |
| Config | `.json`, `.yaml` |
| Markdown | `.md` |

### File Names

| Type | Convention | Example |
|------|------------|---------|
| Components | PascalCase | `UserProfile.tsx` |
| Pages | PascalCase | `UserList.tsx` |
| Hooks | kebab-case | `use-user-data.ts` |
| Services | kebab-case | `auth-service.ts` |
| Utils | kebab-case | `format-date.ts` |
| Constants | UPPER_SNAKE | `MAX_RETRY_COUNT` |
| Config | kebab-case | `app-config.ts` |
| Types | PascalCase | `UserType.ts` |
| Controllers | PascalCase | `UserController.ts` |
| Models | PascalCase | `User.ts` |
| Middeware | kebab-case | `auth-middleware.ts` |
| Routes | kebab-case | `user-routes.ts` |

### Directory Names

- Use plural: `components`, `services`
- kebab-case: `user-profile`, `auth-handler`
- Group related: `user-profile/` contains user-profile files

## Code

### Variables

| Type | Convention | Example |
|------|------------|---------|
| Regular | camelCase | `userName` |
| Boolean | is/has/can | `isActive` |
| Array | Plural noun | `users` |
| Object | Singular noun | `userData` |
| DOM Elements | `$` prefix | `$element` |
| jQuery | `$` prefix | `$button` |

### Functions

| Type | Convention | Example |
|------|------------|---------|
| General | camelCase | `getUser` |
| Event Handler | onAction | `onSubmit` |
| Callback | onAction | `handleClick` |
| Async | get/fetch/action | `fetchUser` |
| Private | _prefix | `_internal` |

### Classes

| Type | Convention | Example |
|------|------------|---------|
| Class | PascalCase | `UserService` |
| Enum | PascalCase | `UserRole` |
| Interface | I prefix optional | `User` or `IUser` |
| Abstract | Base prefix | `BaseController` |

### Constants

| Type | Convention | Example |
|------|------------|---------|
| Config | UPPER_SNAKE | `MAX_RETRY_COUNT` |
| Enum Value | PascalCase | `Active` |
| Status | CAPS | `STATUS_PENDING` |

### CSS

| Type | Convention | Example |
|------|------------|---------|
| Class | kebab-case | `.user-profile` |
| BEM Block | `.block` | `.card` |
| BEM Element | `.block__element` | `.card__header` |
| BEM Modifier | `.block--modifier` | `.card--featured` |
| Custom Prop | --prefixed | `--primary-color` |

### Database

| Type | Convention | Example |
|------|------------|---------|
| Table | plural_lowercase | `users` |
| Column | snake_case | `created_at` |
| Primary Key | `id` | `id` |
| Foreign Key | table_singular_id | `user_id` |
| Index | idx_table_cols | `idx_users_email` |

### API

| Type | Convention | Example |
|------|------------|---------|
| Endpoint | kebab-case | `/user-profiles` |
| Query Param | camelCase | `userId` |
| Body Field | camelCase | `userName` |
| Header | Capital-Stored | `X-Request-Id` |

### Git

| Type | Convention | Example |
|------|------------| ---------|
| Branch | type/description | `feature/user-auth` |
| Commit | imperative | `Add user login` |
| Tag | v1.0.0 | `v1.0.0` |

## Abbreviations

### Allowed
- `id` (identifier)
- `num` (number)
- `msg` (message)
- `err` (error)
- `config` (configuration)
- `ctx` (context)
- `req` (request)
- `res` (response)

### Avoid
- `usr` → `user`
- `dt` → `date`
- `val` → `value`
- `str` → `string`

## Prefixes

### Boolean
- `is`: `isValid`
- `has`: `hasPermission`
- `can`: `canEdit`
- `should`: `shouldUpdate`

### Collections
- `get`: `getUsers`
- `fetch`: `fetchOrders`
- `list`: `listProducts`

### Actions
- `create`: `createUser`
- `update`: `updateUser`
- `delete`: `deleteUser`
- `handle`: `handleSubmit`

## Best Practices

### Choose Clarity
- `dueDate` not `d`
- `userList` not `arr`

### Consider Context
- Loop: `i`, `j` OK
- Function parameter: `userId` better

### Searchable
- Avoid `data`, `stuff`, `temp`
- Use exact matches

### Consistent
- Same pattern for similar items
- Follow project conventions