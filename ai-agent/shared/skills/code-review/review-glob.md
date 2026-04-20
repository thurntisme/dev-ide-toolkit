# Review Glob Skill

Handles reviewing files matching a pattern.

## Trigger

- Command: `/code-review <glob>`
- Loads: `../skills/code-review/review-glob.md`

## Workflow

### Step 1: Analyze Request
- Parse the glob pattern (e.g., "*.php", "src/**/*.ts")
- Validate pattern format
- Determine file types to match

### Step 2: Context Retrieval
- Load project context from `../../docs/`
- Retrieve domain knowledge from `../knowledge/`
- Apply coding conventions from `../rules/`

### Step 3: Gather Files by Pattern
- Match files in the project against pattern
- Exclude directories: node_modules, vendor, dist, .git
- Filter out binary files and generated code
- Limit batch size if too many files (suggest review in batches)

### Step 4: Batch Analysis

For each matched file:

#### Style Review
- Check naming conventions from `../rules/code-conventions.md`
- Verify formatting consistency

#### Error Handling Review
- Check exception handling from `../rules/error-handling.md`
- Verify null checks

#### Security Review
- Check input validation from `../rules/security.md`
- Look for secrets

#### Performance Review
- Identify inefficient patterns from `../rules/clean-code.md`

### Step 5: Generate Report
- Group by file
- Organize by severity
- Provide summary statistics

### Step 6: Save Report File
- Create directory: `dit-tmp/review-report/`
- Generate report file with timestamp: `dit-tmp/review-report/review-{timestamp}.md`
- Include all findings in the file
- Report file content:
  ```
  # Code Review Report - {timestamp}

  ## Summary
  - Files Reviewed: {count}
  - Pattern: {glob}
  - Critical: {count}
  - Warning: {count}
  - Suggestion: {count}

  ## Detailed Findings
  ### {filename}
  - [Line X] {issue} ({severity}): {suggestion}
  ```

### Step 7: Summary
- Total files reviewed
- Issues by severity count
- Top priority issues to address
- Display path to saved report file

## Common Patterns

| Pattern | Matches |
|---------|---------|
| `*.php` | All PHP files in current directory |
| `src/**/*.js` | JS files in src and subdirectories |
| `**/*.ts` | All TypeScript files recursively |
| `*.{js,ts}` | Both JS and TS files |
| `tests/**/*` | All test files |

## Output

- Console output: Summary and key findings
- Report file: `dit-tmp/review-report/review-{timestamp}.md`

## Constraints

- Limit batch size if too many files
- Skip binary/generated files
- Provide aggregate statistics
- Suggest batching if >50 files