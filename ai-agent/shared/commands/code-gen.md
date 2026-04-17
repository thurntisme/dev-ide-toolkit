# /code-gen Command

Trigger: `/code-gen "implement feature..."`

## Usage

```
/code-gen "implement feature"              # Normal
/code-gen "implement feature --strict"      # With test verification
/code-gen "add feature --dry-run"           # Preview only
/code-gen "add feature --interactive"       # Step-by-step confirmation
```

## Flags

| Flag | Description |
|------|-------------|
| `--strict` | Create and verify test cases |
| `--dry-run` | Preview changes without applying |
| `--interactive` | Confirm each step before executing |

## Quick Reference

1. Choose tech stack (coder)
2. Analyze feature
3. Create plan in `dit-tmp/plans/`
4. Execute tasks
5. Run lint/typecheck
6. If --strict: create tests in `dit-tmp/testing/`

## Related

- See: `../workflows/code-gen.md`
- See: `../workflows/plan.md`
- See: `../workflows/implement.md`
