# Architecture and Script Contracts Specification — Dotfiles (Fedora)

This document is the authoritative **Source of Truth** for the repository architecture, Git workflow, script contracts, state management, logging system, and documentation standards of `.dotfiles`.

> [!IMPORTANT]
> All core components (`scripts/utils/`, `scripts/run.sh`, `scripts/log-viewer.sh`, `scripts/validate-contracts.sh`, `bootstrap.sh`) and all module scripts in `scripts/install/` and `scripts/configure/` must strictly comply with the contracts defined in this specification.

---

## 1. Overview and Design Principles

1. **Fedora Linux Target with Multi-Method Installation:** The target operating system is Fedora Linux. The installation architecture supports any installation mechanism required by individual tools (`dnf`, `flatpak`, official upstream `curl`/`bash` installer scripts, precompiled binaries, or source builds).
2. **Strict Idempotency:** Every script and orchestrator run can be executed repeatedly while producing the exact same final state, without duplicating configurations or reinstalling packages unnecessarily.
3. **Immutable Core, Extensible Modules:** Adding new software or configurations requires only adding files under `config/`, `scripts/install/`, and/or `scripts/configure/` in compliance with the script contract, **without modifying the orchestrator or core utilities**.
4. **Two-Way Observability:**
   - **Channel 1 (Terminal / TUI):** Clean terminal interface displaying only execution progress and concise per-script status (`OK`, `SKIP`, `FAIL`, `BLOCKED`), followed by a failure summary at the end of the run.
   - **Channel 2 (Log Files):** Each script writes a dedicated `.log` file preserving ANSI color escape codes, timestamps, log levels, and indented `stdout`/`stderr` output from executed commands.
5. **Dependency-Aware Fault Tolerance:** If a script fails, the orchestrator continues executing independent scripts and automatically marks scripts that depend (directly or transitively) on the failed script as `BLOCKED`.

---

## 2. Repository Layout, Documentation, and Git Workflow

### 2.1 Directory Structure

```text
~/.dotfiles/
├── bootstrap.sh                 # One-liner remote installer (ensures git/curl, clones repo, runs run.sh)
├── README.md                    # Concise, high-level operational instructions in English
├── LICENSE                      # MIT License
├── .gitignore                   # Ignores runtime directories (/logs/, /backups/, /state/)
├── docs/
│   ├── USAGE.md                 # Detailed operational and architectural guide in English
│   └── specs/
│       └── architecture-and-contracts.md  # Authoritative architecture specification
├── .agents/
│   ├── rules/
│   │   └── architecture.md      # Always-on rule enforcing architecture invariants and contracts
│   └── skills/
│       └── create-script/       # Skill and canonical templates for creating new module scripts
├── config/                      # Application configuration files
│   └── <app>/                   # Linked to ~/.config/<app> by default (or custom targets under ~/)
├── scripts/
│   ├── run.sh                   # Main orchestrator (TUI, dependency DAG, state, and execution)
│   ├── log-viewer.sh            # CLI utility to list, filter, and display ANSI log files
│   ├── validate-contracts.sh    # Static validator verifying script contract compliance
│   ├── utils/                   # Shared core libraries
│   │   ├── core.sh              # Unified entrypoint sourced by all scripts
│   │   ├── logger.sh            # ANSI logger and run_cmd wrapper
│   │   ├── errors.sh            # Error handling and ERR trap
│   │   ├── fs.sh                # Idempotent symlink helpers with automatic conflict backup
│   │   ├── pkg.sh               # Multi-method package/tool helpers (cmd_exists, dnf, flatpak, script)
│   │   └── state.sh             # State persistence manager (state/status.tsv)
│   ├── install/                 # Software and utility installation scripts
│   │   └── <module>.sh
│   └── configure/               # Symlink creation and post-installation configuration scripts
│       └── <module>.sh
│
│ # Runtime-only directories (created on demand, untracked by Git):
├── logs/
│   ├── <timestamp>/             # Session log directory (e.g., 2026-11-03_17-30-00/)
│   └── latest -> <timestamp>/   # Symlink pointing to the most recent session
├── backups/
│   └── <timestamp>/             # Automatic backups of conflicting pre-existing target files
└── state/
    └── status.tsv               # Execution state table
```

### 2.2 Public Documentation Standards (`README.md`, `docs/USAGE.md`, and `LICENSE`)

- **`LICENSE`:** Standard **MIT** License.
- **`README.md`:**
  - Written in **English**.
  - High-level and concise: covers only repository purpose, minimum system requirements (`Fedora Linux`, `curl`, `sudo`), quick-start execution commands (`bootstrap.sh`, `scripts/run.sh`, `scripts/log-viewer.sh`), and a link to `docs/USAGE.md`.
- **`docs/USAGE.md`:**
  - Written in **English**.
  - Detailed operational guide covering repository layout, runtime directories (`logs/`, `backups/`, `state/`), environment variables, orchestrator flags, log viewer options, and instructions for adding new scripts.
- **Writing Style:** Technical, sober, and direct. **No emojis**, no marketing language, and no verbose AI-style filler.

### 2.3 Git Workflow and Commit Standards

- **Branches:**
  - `main`: Validated, production-ready code (default branch cloned by `bootstrap.sh`).
  - `dev`: Integration branch where completed features are merged and tested together.
  - `feat/<feature-name>`: Branched from `dev` for each new feature or module. Once implemented and validated, merged back into `dev` and deleted.
- **Conventional & Atomic Commits:**
  - Format: `<type>(<scope>): <concise description>` (e.g., `feat(utils): add ANSI logger and command runner`, `feat(install): add neovim installation script`, `docs(usage): add detailed usage guide`).
  - **Atomicity Rule:** Every commit must represent a single logical change. Unrelated modifications must never be bundled into the same commit.

---

## 3. Formal Script Contract (`scripts/install/` and `scripts/configure/`)

Every script inside `scripts/install/` and `scripts/configure/` is an autonomous unit and must satisfy **all** rules below:

### 3.1 Mandatory Contract Rules

1. **Shebang, Permissions, and Strict Mode:**
   - Line 1 must be `#!/usr/bin/env bash`.
   - File must have executable permissions (`chmod +x`).
   - Must enable `set -Eeuo pipefail` before any execution logic.
2. **Declarative Metadata Header:**
   - Structured comments placed immediately below the shebang and parsed by the orchestrator:
     - `# @id: <install|configure>/<name>` — Unique script identifier matching its directory and filename.
     - `# @name: <Human Readable Name>` — Display name shown in the orchestrator TUI.
     - `# @order: <00-99>` — Numeric execution priority within its phase (lower numbers run first).
     - `# @depends: <id1, id2>` *(Optional)* — Comma-separated list of `@id`s that must succeed before this script runs.
3. **Core Import:**
   - Must source `scripts/utils/core.sh`, which loads all shared utilities and supports both orchestrated and standalone execution.
4. **Functional Structure (`main` and Helpers):**
   - Must define a `main()` function.
   - All helper functions must be declared **before** `main()` and invoked **exclusively inside** `main()` (or inside other helpers called by `main()`).
   - No executable commands are permitted at global scope outside functions (except `set -Eeuo pipefail`, `SCRIPT_DIR=...`, `source ...core.sh`, `readonly` constants, and the final `main "$@"` invocation).
   - The final executable line of the file must be `main "$@"`.
5. **Installation Flexibility and Idempotency:**
   - Scripts in `scripts/install/` may install software using `dnf`, `flatpak`, upstream installer scripts (`curl | sh`), binary downloads, or source compilation via `pkg.sh` helpers or `run_cmd`.
   - Every script must check whether the target state is already satisfied before performing changes. If already satisfied, it must call `log_skip` and `return 0`.
   - Must return `0` on success and non-zero (`!= 0`) on failure.
6. **Logical Block Logging:**
   - Every logical block inside `main()` and helper functions must log its progress using core logging functions (`log_info`, `log_step`, `log_ok`, `log_skip`, `log_warn`, `log_error`) and/or `run_cmd`.

### 3.2 Canonical Script Templates

#### Example 1: Installation via `dnf`
```bash
#!/usr/bin/env bash
# @id: install/neovim
# @name: Neovim Editor
# @order: 20
# @depends: install/git, install/ripgrep

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

is_installed() {
    cmd_exists "nvim" && rpm_is_installed "python3-neovim"
}

install_neovim() {
    log_step "Installing Neovim packages via dnf..."
    dnf_install "neovim" "python3-neovim"
}

main() {
    log_info "Checking Neovim installation"

    if is_installed; then
        log_skip "Neovim is already installed."
        return 0
    fi

    install_neovim
    log_ok "Neovim installation completed."
}

main "$@"
```

#### Example 2: Installation via Upstream Script (`curl | sh`)
```bash
#!/usr/bin/env bash
# @id: install/starship
# @name: Starship Prompt
# @order: 30
# @depends: install/curl

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

is_installed() {
    cmd_exists "starship"
}

install_starship() {
    log_step "Installing Starship via official installer..."
    install_from_script "Run Starship installer" "https://starship.rs/install.sh" -y
}

main() {
    log_info "Checking Starship installation"

    if is_installed; then
        log_skip "Starship is already installed."
        return 0
    fi

    install_starship
    log_ok "Starship installation completed."
}

main "$@"
```

#### Example 3: Configuration and Symlinks (`configure/`)
```bash
#!/usr/bin/env bash
# @id: configure/neovim
# @name: Neovim Configuration
# @order: 20
# @depends: install/neovim

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

configure_neovim() {
    log_step "Linking Neovim configuration files..."
    link_config "nvim"
}

main() {
    log_info "Starting Neovim configuration"
    configure_neovim
    log_ok "Neovim configuration completed."
}

main "$@"
```

---

## 4. Shared Core Utilities (`scripts/utils/`)

| File | Responsibility and Primary Functions |
| :--- | :--- |
| `core.sh` | Unified entrypoint. Resolves repository and runtime directory paths (`config/`, `logs/`, `backups/`, `state/`), loads `logger.sh`, `errors.sh`, `fs.sh`, `pkg.sh`, and `state.sh`, enables `ERR` traps for module scripts, and initializes standalone logging and state tracking when a module script is invoked directly outside `run.sh`. |
| `logger.sh` | Provides `log_info`, `log_step`, `log_ok`, `log_skip`, `log_warn`, `log_error`, and `run_cmd "<description>" <command...>`. Always writes ANSI color sequences, `YYYY-MM-DD HH:MM:SS` timestamps, and level tags. |
| `errors.sh` | Configures `trap 'dotfiles_on_error "$?" "${LINENO}" "${BASH_COMMAND}" "${BASH_SOURCE[0]}"' ERR`. Automatically logs the exact file, line number, failing command, and exit code when any command fails under `set -Eeuo pipefail`. |
| `fs.sh` | Provides `link_config "<app>"` (links `~/.config/<app> -> ~/.dotfiles/config/<app>`) and `link_path "<config_rel_path>" "<target_abs_path>"` (for targets in `~/`, e.g., `~/.zshrc`). Skips if the symlink already points to the source; backs up existing conflicting files/directories to `backups/<timestamp>/` before linking. |
| `pkg.sh` | Multi-method installation and verification helpers for Fedora:<br>• **Generic / Script:** `cmd_exists "<bin>"`, `install_from_script "<description>" "<url>" [args...]`<br>• **DNF / RPM:** `rpm_is_installed "<pkg>"`, `dnf_install "<pkg1>" [...]`, `dnf_enable_copr "<owner/project>"`, `dnf_group_install "<group>"`<br>• **Flatpak:** `flatpak_ensure_flathub`, `flatpak_is_installed "<app_id>"`, `flatpak_install "<app_id>" [...]` |
| `state.sh` | Manages `state/status.tsv` created at runtime. Functions: `state_init`, `state_get_status "<script_id>"`, `state_get_substatus "<script_id>"`, `state_get_log_file "<script_id>"`, `state_set_status "<script_id>" "<STATUS>" "<exit_code>" "<log_file>" ["<substatus>"]`. |

---

## 5. Orchestrator (`scripts/run.sh`) and State Management

### 5.1 Script States (`state/status.tsv`)
- `PENDING`: Newly added script or script that has never been executed.
- `SUCCESS`: Executed and exited with code `0` (substatus `OK` or `SKIP`).
- `FAILED`: Executed and exited with non-zero code (`!= 0`).
- `BLOCKED`: Not executed because one or more dependencies in `@depends` did not reach `SUCCESS`.

### 5.2 Command-Line Granularities (`scripts/run.sh`)
1. **Full Execution (Default):** `./scripts/run.sh`
2. **Phase Execution (`install` or `configure`):** `./scripts/run.sh --phase install` | `./scripts/run.sh --phase configure`
3. **Resume / Failed & Pending (`--resume` / `--failed`):** `./scripts/run.sh --resume`
4. **Isolated Scripts (`--only`):** `./scripts/run.sh --only configure/nvim` (automatically schedules unmet `@depends` unless `--no-deps` is passed).

---

## 6. Two-Way Logging and Log Viewer (`scripts/log-viewer.sh`)

- Each orchestrator session creates `logs/<YYYY-MM-DD_HH-MM-SS>/` at runtime and updates the `logs/latest` symlink.
- Each script writes to `<phase>-<name>.log` with preserved ANSI color escape codes.
- `scripts/log-viewer.sh` options:
  - `--list` (default when called with no arguments): Lists logs in `logs/latest/` alongside their recorded status from `state/status.tsv`.
  - `<script-name>`: Prints the colored log to the terminal (supports `--pager` to open in `less -R`).
  - `--failed`: Prints logs for all scripts currently marked as `FAILED`.
  - `<script-name> --errors`: Filters output to show only `[WARN]` and `[ERROR]` lines.

---

## 7. Bootstrap Script (`bootstrap.sh`)

1. Verifies execution on Fedora Linux (`/etc/os-release`) by a non-root user with `sudo` privileges.
2. Ensures `git` and `curl` are installed via `sudo dnf install -y git curl` if missing.
3. Clones the repository into `~/.dotfiles` on branch `${DOTFILES_BRANCH:-main}` (or updates it if already present).
4. Transfers execution to `~/.dotfiles/scripts/run.sh "$@"`.
