# Review Staged Changes Skill

Handles reviewing git staged files.

## Trigger

- Command: `/code-review`
- Loads: `../skills/code-review/review-staged.md`

## Workflow

### Step 1: Analyze Request
- Parse command with no arguments
- Determine to review staged changes
- Identify this is default review mode

### Step 2: Context Retrieval
- Load project context from `../../docs/`
- Retrieve domain knowledge from `../knowledge/`
- Apply coding conventions from `../rules/`

### Step 3: Gather Files
- Run `git status` to check for staged changes
- Run `git diff --cached` to get staged file list
- Gather all staged files
- If no staged files, inform user and offer alternatives

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
- Recommend committing or addressing issues

## Output

- Console output: Summary and key findings
- Report file: `dit-tmp/review-report/review-{timestamp}.md`

## Constraints

- Verify staged files exist
- Provide actionable feedback
- Focus on changes in diff
- Be constructive, not critical