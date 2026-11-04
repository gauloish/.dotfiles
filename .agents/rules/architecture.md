# Architecture and Script Contract Rules — .dotfiles (Spec-Driven Development)

Authoritative specification: `@[Architecture and Contracts Specification](../../docs/specs/architecture-and-contracts.md)`

## 1. Git Workflow, Commits, and Language Standard
- **Branches:** `main` (stable/production), `dev` (integration), `feat/<feature-name>` (branched from `dev`, merged back into `dev` only after implementation and verification, and deleted after merge).
- **Commits:** Follow **Conventional Commits** (`feat`, `fix`, `docs`, `refactor`, `chore`, `test`). Every commit must be strictly atomic (never bundle unrelated changes in a single commit).
- **Repository Language:** All repository files (code, comments, log messages, commit messages, specifications, rules, skills, `README.md`, and `docs/USAGE.md`) must be written in **English**. Technical documentation must be direct, concise, and free of emojis or AI-style filler.

## 2. Architectural Invariants
- **Immutable Core:** When adding new software or application configurations, **do not modify** `scripts/run.sh`, `scripts/log-viewer.sh`, `scripts/validate-contracts.sh`, or `scripts/utils/*.sh`. Only add or update files under `config/`, `scripts/install/`, and/or `scripts/configure/`.
- **Runtime Directories:** `logs/`, `backups/`, and `state/` are created exclusively at runtime and must remain untracked by Git.
- **Target Environment:** Fedora Linux. Supported installation methods include `dnf`, `flatpak`, upstream installer scripts (`curl`/`bash`), precompiled binaries, or source builds using helpers from `scripts/utils/pkg.sh` or `run_cmd`.

## 3. Mandatory Script Contract (`scripts/install/*.sh` and `scripts/configure/*.sh`)
Every script in `scripts/install/` and `scripts/configure/` must:
1. Start with `#!/usr/bin/env bash` on line 1 and have executable permissions (`chmod +x`).
2. Declare metadata headers immediately after the shebang:
   - `# @id: <install|configure>/<name>`
   - `# @name: <Human Readable Name>`
   - `# @order: <00-99>`
   - `# @depends: <id1, id2>` (optional)
3. Enable `set -Eeuo pipefail`.
4. Source `${SCRIPT_DIR}/../utils/core.sh`.
5. Be strictly **idempotent** (check if the package or configuration is already applied before making changes; call `log_skip` and `return 0` when already satisfied).
6. Declare all helper functions **before** `main()` and invoke them **exclusively inside** `main()`.
7. Call `main "$@"` as the final line of the file.
8. Log every logical block using `log_info`, `log_step`, `log_ok`, `log_skip`, `log_warn`, `log_error`, and `run_cmd`.
9. Return `0` on success and `!= 0` on failure, and pass `./scripts/validate-contracts.sh`.
