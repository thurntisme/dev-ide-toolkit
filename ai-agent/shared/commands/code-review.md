# /code-review Command

Trigger: `/code-review`

## Usage

```
/code-review                    # Interactive selection
/code-review src/utils/auth.ts  # Review specific file
/code-review "*.php"            # Review file type
```

## Quick Reference

1. Ask user which files to review:
   - Current open files
   - Staged files (git)
   - Specific path
   - Whole folder
   - Specific file type
2. Scan selected files
3. Review: style, error handling, security, performance
4. Provide summary with action items

## Related

- See: `../workflows/code-review.md`
- See: `../rules/code-convention.md`
