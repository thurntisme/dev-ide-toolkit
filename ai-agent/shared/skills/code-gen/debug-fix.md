# Debug Fix Skill

Handles error analysis and bug fixing.

## Trigger

- Command: `/code-gen "fix [error_log]"`
- Loads: `../skills/code-gen/debug-fix.md`

## Workflow

### Step 1: Error Analysis
- Parse the error log or error description
- Identify the type of error (runtime, compile, logic, etc.)
- Determine the technical stack involved

### Step 2: Context Retrieval
- Load project context from `../../docs/`
- Retrieve domain knowledge from `../knowledge/`
- Apply debugging conventions from `../rules/`

### Step 3: Codebase Analysis
- Locate the files mentioned in the error
- Analyze the code around the error location
- Identify potential causes and contributing factors

### Step 4: Root Cause Identification
- Trace the error to its source
- Identify why the error occurred
- Determine the fix strategy

### Step 5: Implementation
- Apply the fix following project conventions
- Make minimal changes to address the root cause
- Avoid introducing new issues

### Step 6: Verification
- Run the code to verify the fix works
- Run lint/typecheck commands
- Ensure no regressions introduced

## Constraints

- Fix the root cause, not just symptoms
- Do not commit changes unless explicitly requested
- Run tests to verify fix doesn't break other functionality
- Document the fix if appropriate

## Error Types

- **Runtime Errors:** Stack traces, exceptions
- **Compile Errors:** Syntax errors, type errors
- **Logic Errors:** Incorrect behavior, unexpected output
- **Performance Issues:** Slow execution, memory leaks
- **Security Issues:** Vulnerabilities, exposures