---
name: create-script
description: >-
  Use this skill whenever the user asks to add, create, or modify an installation
  script in scripts/install/ or a configuration/symlink script in scripts/configure/.
  Ensures strict compliance with the repository's Spec-Driven Development script contract.
---

# Create or Update Dotfiles Module Scripts

Follow this procedure whenever creating or updating scripts in `scripts/install/` or `scripts/configure/`.

## Step 1: Consult Reference Templates and Spec
1. Review the canonical templates before writing code:
   - Installation script template: [install-template.sh](./resources/install-template.sh)
   - Configuration script template: [configure-template.sh](./resources/configure-template.sh)
2. If needed, check the full specification at [architecture-and-contracts.md](../../docs/specs/architecture-and-contracts.md).

## Step 2: Enforce the Script Contract
Every script in `scripts/install/<name>.sh` and `scripts/configure/<name>.sh` MUST:
1. Start with `#!/usr/bin/env bash`.
2. Include metadata headers immediately after the shebang:
   - `# @id: <install|configure>/<name>`
   - `# @name: <Human Readable Name>`
   - `# @order: <00-99>`
   - `# @depends: <comma-separated script IDs>` (optional; e.g., `configure/<name>` usually depends on `install/<name>`)
3. Enable `set -Eeuo pipefail`.
4. Source `${SCRIPT_DIR}/../utils/core.sh`.
5. Declare all helper functions **before** `main()` and call them **only inside** `main()`.
6. Ensure strict **idempotency** (check if installed/configured first; call `log_skip` and `return 0` if already satisfied).
7. Log every logical block using `log_info`, `log_step`, `log_ok`, `log_skip`, `log_warn`, `log_error`, and `run_cmd`.
8. End with `main "$@"` as the final line and have executable permissions (`chmod +x`).

## Step 3: Validate the Contract
After creating or modifying any script:
1. Make the script executable:
   `chmod +x scripts/<phase>/<name>.sh`
2. Run the contract validator to verify compliance:
   `./scripts/validate-contracts.sh`
