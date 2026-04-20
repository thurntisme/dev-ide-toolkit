# Review File Skill

Handles reviewing specific file or directory.

## Trigger

- Command: `/code-review <path>`
- Loads: `../skills/code-review/review-file.md`

## Workflow

### Step 1: Analyze Request
- Parse the provided path argument
- Verify path exists
- Determine if file or directory

### Step 2: Context Retrieval
- Load project context from `../../docs/`
- Retrieve domain knowledge from `../knowledge/`
- Apply coding conventions from `../rules/`

### Step 3: Gather Files
- If file, add to review list
- If directory, gather all source files within
- Exclude binary and generated files (node_modules, vendor, etc.)

### Step 4: Analyze Each File

#### Style Review
- Check naming conventions from `../rules/code-conventions.md`
- Verify formatting consistency
- Review code structure

#### Error Handling Review
- Check exception handling from `../rules/error-handling.md`
- Verify null/undefined checks
- Review edge case handling

#### Security Review
- Check input validation from `../rules/security.md`
- Verify data sanitization
- Look for secret exposure

#### Performance Review
- Identify N+1 queries
- Find unnecessary operations from `../rules/clean-code.md`

### Step 5: Generate Report
- Organize by severity: Critical, Warning, Suggestion
- Include file path and line number
- Provide code snippet and fix suggestion

### Step 6: Save Report File
- Create directory: `dit-tmp/review-report/`
- Generate report file with timestamp: `dit-tmp/review-report/review-{timestamp}.md`
- Include all findings in the file
- Report file content:
  ```
  # Code Review Report - {timestamp}

  ## Summary
  - Files Reviewed: {count}
  - Critical: {count}
  - Warning: {count}
  - Suggestion: {count}

  ## Detailed Findings
  ### {filename}
  - [Line X] {issue} ({severity}): {suggestion}
  ```

### Step 7: Summary
- Total issues by severity
- Priority action items
- Display path to saved report file
- Overall code quality assessment

## Output Format

Console output:
```
## File: <filename>

### Critical
- [Line X] <issue>: <suggestion>

### Warning
- [Line Y] <issue>: <suggestion>

### Suggestion
- [Line Z] <issue>: <suggestion>
```

Report file: `dit-tmp/review-report/review-{timestamp}.md`

## Constraints

- Be specific with line numbers
- Provide actionable fixes
- Reference rules when applicable
- Skip binary files