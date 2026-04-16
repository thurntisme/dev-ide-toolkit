---
description: Deploy project to target environment
---

1. Ask user for deployment target (dev/staging/production).
2. Run pre-deploy checks (lint, test, build).
// turbo
3. Run npm run build
4. Execute deploy command.
// turbo
5. Run deploy script
6. Verify deployment success.
7. Provide deployment URL.