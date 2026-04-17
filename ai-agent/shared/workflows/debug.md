---
description: "Slash command: /debug - Debug and fix errors"
---

# /debug Workflow

Trigger: User types `/debug` or reports an error

## Usage

```
/debug                    # Debug current error
/debug "fix login error"  # Debug specific issue
```

## Step 1: Identify error

- Get error message or unexpected behavior
- Note stack trace if available
- Ask user for reproduction steps

## Step 2: Locate relevant files

- Analyze error location
- Find related source files
- Check imports and dependencies

## Step 3: Analyze root cause

### Common Issues by Language

**TypeScript/JavaScript**
- Check type mismatches
- Verify imports
- Check null/undefined
- Check async/await errors

**PHP**
- Check fatal errors in logs
- Verify class/method existence
- Check database connections

**Python**
- Check indentation errors
- Verify import statements
- Check virtual environment

### Runtime Issues
- Check environment variables
- Check API responses
- Check network requests

### Build Issues
- Check dependencies
- Check configuration
- Check platform compatibility

## Step 4: Implement fix

- Apply fix to source code
- Add error handling
- Verify fix doesn't break other functionality

## Step 5: Verify fix

- Run tests
- Check error is resolved
- Verify no regressions

## Tools

- Use console.log / print for debugging
- Use debugger statements
- Check error boundaries
- Review recent changes (git diff)

## Related Workflows

- test.md - Run tests to verify fix
- code-review.md - Review changes
