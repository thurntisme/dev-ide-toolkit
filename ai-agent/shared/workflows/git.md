---
description: Git operations: commit, push, branch, stash, diff, log
---

1. Ask user which git operation:
   - commit: Stage and commit changes
   - push: Push to remote
   - pull: Pull from remote
   - branch: Manage branches
   - stash: Stash changes
   - log: View commit history
   - diff: View changes

2. Check current branch and status.
// turbo
3. Run `git status`

4. Execute the requested operation:

   **For commit:**
   - Ask for commit message (or use conventional format)
   - Stage all changes: `git add -A`
   - Create commit with message
   // turbo
   // run `git commit -m "message"`

   **For push:**
   - Check branch is not main/master
   - Push to remote
   // turbo
   // run `git push`

   **For pull:**
   - Fetch latest
   - Pull from remote
   // turbo
   // run `git pull`

   **For branch:**
   - List branches / Create new branch / Switch branch
   // turbo
   // run `git checkout -b branch-name`

   **For stash:**
   - Stash changes with description
   // turbo
   // run `git stash push -m "description"`

   **For log:**
   - Show recent commits
   // run `git log --oneline -10`

   **For diff:**
   - Show unstaged changes
   // run `git diff`
   - Show staged changes
   // run `git diff --staged`

5. Report result to user.