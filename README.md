# .dotfiles

Personal configuration files and installation scripts for Fedora Linux.

## Requirements

- Fedora Linux
- `curl`
- `sudo` privileges

## Installation

Run the bootstrap script to clone the repository into `~/.dotfiles` and execute the setup:

```bash
curl -fsSL https://raw.githubusercontent.com/gauloish/.dotfiles/main/bootstrap.sh | bash
```

To test a specific branch during development:

```bash
curl -fsSL https://raw.githubusercontent.com/gauloish/.dotfiles/dev/bootstrap.sh | bash -s -- --branch dev
```

Alternatively, pass the `DOTFILES_BRANCH` environment variable directly to `bash`:

```bash
curl -fsSL https://raw.githubusercontent.com/gauloish/.dotfiles/dev/bootstrap.sh | DOTFILES_BRANCH=dev bash
```

## Usage

Once cloned to `~/.dotfiles`, you can run the orchestrator directly:

```bash
# Run all installation and configuration scripts
./scripts/run.sh

# Run only installation or configuration phase
./scripts/run.sh --phase install
./scripts/run.sh --phase configure

# Re-run only failed, blocked, or newly added scripts
./scripts/run.sh --resume

# Run specific scripts
./scripts/run.sh --only install/neovim,configure/neovim
```

## Logs

Execution logs are stored in `logs/latest/`. Use the log viewer to inspect them:

```bash
# List logs from the latest run
./scripts/log-viewer.sh --list

# View a specific script log
./scripts/log-viewer.sh install-neovim

# View all failed script logs
./scripts/log-viewer.sh --failed
```

For detailed command options, runtime directories, and instructions on adding new scripts, see [docs/USAGE.md](docs/USAGE.md).

## License

Released under the [MIT License](LICENSE).
