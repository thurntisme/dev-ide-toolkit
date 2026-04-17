---
description: "Slash commands: /docs init and /docs update - Documentation management"
---

# /docs init Workflow

1. Check if docs folder already exists.
2. Ask user for:
   - Documentation type (API docs, README, guide)
   - File names to create
3. Analyze existing codebase to extract:
   - API endpoints
   - Component structure
   - Configuration options
4. Create docs folder structure:
   ```
   docs/
   ├── api/
   ├── guides/
   ├── README.md
   └── index.md
   ```
5. Generate documentation files:
   - API documentation from code comments
   - README with setup instructions
   - Guides for common tasks
6. Verify files created successfully.

---

# /docs update Workflow

1. Check if docs folder exists (if not, prompt user to run /docs init).
2. Compare current code with existing docs:
   - New API endpoints
   - New components
   - Changed configurations
3. Update existing documentation:
   - Update API docs
   - Add new component docs
   - Update configuration guides
4. Track changes in CHANGELOG.md.
5. Verify all updates are complete.
