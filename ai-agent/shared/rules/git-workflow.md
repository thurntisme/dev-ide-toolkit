# Git Workflow

## Branch Naming

| Type | Pattern | Example |
|------|---------|---------|
| Feature | `feature/description` | `feature/user-authentication` |
| Bugfix | `fix/description` | `fix/login-error` |
| Refactor | `refactor/description` | `refactor/api-handler` |
| Documentation | `docs/description` | `docs/api-endpoints` |
| Hotfix | `hotfix/description` | `hotfix/security-patch` |
| Release | `release/version` | `release/v1.2.0` |

## Commits

### Commit Message Format

```
type(scope): description

[optional body]
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactor
- `docs`: Documentation
- `style`: Formatting (no code change)
- `test`: Tests
- `chore`: Maintenance
- `perf`: Performance improvement
- `ci`: CI/CD changes

### Rules

- Use imperative mood
- Keep subject under 50 characters
- Reference issues/tickets when applicable
- Body wrap at 72 characters

## Workflow

1. **Start new work**
   ```bash
   git checkout main
   git pull origin main
   git checkout -b feature/description
   ```

2. **Make commits**
   - Make small, focused commits
   - Write descriptive commit messages

3. **Push and create PR**
   ```bash
   git push -u origin feature/description
   ```

4. **Code review**
   - Request review
   - Address feedback
   - Make changes

5. **Merge**
   - Squash merge to main
   - Delete branch

## Best Practices

- Commit early, commit often
- Don't mix unrelated changes
- Write meaningful commit messages
- Review changes before committing
- Use .gitignore for sensitive files
