# Usage and Architecture Guide

This document provides detailed instructions for operating, inspecting, and extending the `.dotfiles` repository.

---

## 1. Repository Layout

```text
~/.dotfiles/
├── bootstrap.sh                 # Remote bootstrap script (clones repo and launches run.sh)
├── README.md                    # High-level overview and quick start
├── LICENSE                      # MIT License
├── config/                      # Application configuration files
├── docs/
│   ├── USAGE.md                 # Detailed operational guide
│   └── specs/
│       └── architecture-and-contracts.md
└── scripts/
    ├── run.sh                   # Main orchestrator
    ├── log-viewer.sh            # Log inspection utility
    ├── validate-contracts.sh    # Static contract validator
    ├── utils/                   # Shared core libraries
    ├── install/                 # Software installation scripts
    └── configure/               # Symlink and post-installation configuration scripts
```

### Runtime Directories (Untracked by Git)

The following directories are created automatically at runtime when scripts are executed and are ignored by Git:

- `logs/<YYYY-MM-DD_HH-MM-SS>/`: Per-script execution logs for a specific session, with `logs/latest` pointing to the most recent session.
- `backups/<YYYY-MM-DD_HH-MM-SS>/`: Automatic backups of pre-existing files or directories that conflicted with symlinks created during the `configure` phase.
- `state/status.tsv`: Tab-separated state table tracking the latest execution status (`SUCCESS`, `FAILED`, `BLOCKED`) of each script.

---

## 2. Bootstrap (`bootstrap.sh`)

`bootstrap.sh` prepares a fresh Fedora installation, clones the repository, and transfers control to `scripts/run.sh`.

### Standard Execution

```bash
curl -fsSL https://raw.githubusercontent.com/gauloish/.dotfiles/main/bootstrap.sh | bash
```

### CLI Options and Argument Forwarding

`bootstrap.sh` accepts options to configure the repository before forwarding any orchestrator flags to `scripts/run.sh`:

- `-b, --branch <branch>`: Target Git branch to clone or checkout (defaults to `main` or `$DOTFILES_BRANCH`).
- `--repo <url>`: Target Git repository URL (defaults to `https://github.com/gauloish/.dotfiles.git` or `$DOTFILES_REPO_URL`).
- `--dir <path>`: Target clone directory (defaults to `${HOME}/.dotfiles` or `$DOTFILES_DIR`).

Any additional arguments passed after `--` are forwarded directly to `scripts/run.sh` (e.g. `--phase`, `--only`, `--resume`, `--no-deps`, `--no-sudo`).

Examples:

```bash
# Run installation phase only
curl -fsSL https://raw.githubusercontent.com/gauloish/.dotfiles/main/bootstrap.sh | bash -s -- --phase install

# Test the dev branch with orchestrator flags
curl -fsSL https://raw.githubusercontent.com/gauloish/.dotfiles/dev/bootstrap.sh | bash -s -- --branch dev --resume
```

### Environment Variables

You can also configure the bootstrap process via environment variables passed directly to `bash`:

- `DOTFILES_BRANCH`: Target branch to clone or update (defaults to `main`).
- `DOTFILES_REPO_URL`: Git repository URL (defaults to `https://github.com/gauloish/.dotfiles.git`).
- `DOTFILES_DIR`: Target installation directory (defaults to `${HOME}/.dotfiles`).

Example for testing the `dev` branch via environment variable:

```bash
curl -fsSL https://raw.githubusercontent.com/gauloish/.dotfiles/dev/bootstrap.sh | DOTFILES_BRANCH=dev bash
```

---

## 3. Orchestrator (`scripts/run.sh`)

`scripts/run.sh` discovers scripts in `scripts/install/` and `scripts/configure/`, resolves their `@order` priority and `@depends` graph, manages `sudo` keep-alive, updates `state/status.tsv`, and redirects all command output to individual log files.

### Execution Modes

1. **Full Run (Default)**
   Executes all `install` scripts followed by all `configure` scripts. Relies on each script's internal idempotency check to skip already applied work:
   ```bash
   ./scripts/run.sh
   ```

2. **Phase Execution (`--phase`)**
   Executes only scripts belonging to `install` or `configure`:
   ```bash
   ./scripts/run.sh --phase install
   ./scripts/run.sh --phase configure
   ```

3. **Resume / Failed & Pending Only (`--resume` or `--failed`)**
   Reads `state/status.tsv` and executes only scripts whose current status is `FAILED`, `BLOCKED`, or `PENDING` (including newly created scripts that have never been executed), skipping all scripts already marked `SUCCESS`:
   ```bash
   ./scripts/run.sh --resume
   ```

4. **Isolated Scripts (`--only`)**
   Executes one or more specific scripts by ID (comma-separated). By default, if any dependency declared in `# @depends:` does not have `SUCCESS` in `state/status.tsv`, the orchestrator automatically schedules the dependency before the requested script:
   ```bash
   ./scripts/run.sh --only configure/neovim
   ./scripts/run.sh --only install/zsh,configure/zsh
   ```
   To run the target script strictly in isolation without checking or scheduling dependencies:
   ```bash
   ./scripts/run.sh --only configure/neovim --no-deps
   ```

5. **Skipping Upfront Sudo Prompt (`--no-sudo`)**
   Skips the initial `sudo -v` check when running scripts that do not require elevated privileges:
   ```bash
   ./scripts/run.sh --phase configure --no-sudo
   ```

6. **Direct Script Execution**
   Any module script can also be executed directly from the terminal. `scripts/utils/core.sh` detects standalone execution, streams output to both the terminal and `logs/latest/`, and updates `state/status.tsv`:
   ```bash
   ./scripts/install/neovim.sh
   ```

---

## 4. Log Viewer (`scripts/log-viewer.sh`)

Log files retain full ANSI color codes and include millisecond-accurate timestamps, log levels (`INFO`, `STEP`, `CMD`, `OK`, `SKIP`, `WARN`, `ERROR`), and indented command output.

### Listing Sessions and Logs

```bash
# List all available execution sessions / timestamps with status summaries
./scripts/log-viewer.sh --sessions

# List all logs from the latest session along with their recorded status
./scripts/log-viewer.sh
./scripts/log-viewer.sh --list

# Filter latest session logs by status (success, skipped, failed, blocked)
./scripts/log-viewer.sh --status failed
./scripts/log-viewer.sh --status skipped
./scripts/log-viewer.sh --status failed,blocked
./scripts/log-viewer.sh --status success

# Inspect or filter logs from a specific past execution session
./scripts/log-viewer.sh --session 2026-11-07_00-12-12
./scripts/log-viewer.sh --session 2026-11-07_00-12-12 --status failed
```

### Viewing Log Contents

```bash
# Print the full log of a specific script (accepts slug, script ID, or partial name)
./scripts/log-viewer.sh install-neovim
./scripts/log-viewer.sh install/neovim
./scripts/log-viewer.sh neovim

# View a log from a specific past session
./scripts/log-viewer.sh configure-gnome-tools --session 2026-11-07_00-12-12

# Open a log inside 'less -R' for scrolling
./scripts/log-viewer.sh install-neovim --pager

# Filter a script log to display only [WARN] and [ERROR] lines
./scripts/log-viewer.sh install-neovim --errors

# Print all failed script logs (from latest session or target session)
./scripts/log-viewer.sh --failed
./scripts/log-viewer.sh --status failed --print --session 2026-11-07_00-12-12
```

---

## 5. Adding New Scripts

New modules are added by creating scripts in `scripts/install/<name>.sh` and/or `scripts/configure/<name>.sh` and placing configuration files under `config/<name>/`.

### Metadata Header

Every module script must begin with `#!/usr/bin/env bash` followed by metadata comments:

```bash
#!/usr/bin/env bash
# @id: install/neovim
# @name: Neovim Editor
# @order: 20
# @depends: install/git, install/ripgrep
```

### Shared Core Utilities (`scripts/utils/`)

When a script sources `scripts/utils/core.sh`, the following functions are available:

- **Logging (`logger.sh`):**
  - `log_info "<message>"`
  - `log_step "<message>"`
  - `log_ok "<message>"`
  - `log_skip "<message>"` (marks the script run as `SKIP` in the orchestrator TUI)
  - `log_warn "<message>"`
  - `log_error "<message>"`
  - `run_cmd "<description>" <command> [args...]`
- **Filesystem & Symlinks (`fs.sh`):**
  - `link_config "<app>"`: Links `~/.config/<app>` to `config/<app>` (backs up existing targets to `backups/<timestamp>/`).
  - `link_path "<config_rel_path>" "<target_abs_path>"`: Links any custom path under `config/` to an arbitrary target path (such as `${HOME}/.zshrc`).
- **Packages & Installers (`pkg.sh`):**
  - `cmd_exists "<binary>"`
  - `rpm_is_installed "<pkg>"`
  - `dnf_install "<pkg1>" ["<pkg2>"...]`
  - `dnf_enable_copr "<owner/project>"`
  - `dnf_group_install "<group>"`
  - `flatpak_is_installed "<app_id>"`
  - `flatpak_install "<app_id>" [...]`
  - `install_from_script "<description>" "<url>" [args...]`

### Contract Validation

Before committing new or modified scripts, make them executable and run the static contract validator:

```bash
chmod +x scripts/install/<name>.sh scripts/configure/<name>.sh
./scripts/validate-contracts.sh
```
