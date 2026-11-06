#!/usr/bin/env bash
# @id: install/claude-code
# @name: Claude Code CLI
# @order: 61
# @depends: install/cli-utils

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly CLAUDE_INSTALLER_URL="https://claude.ai/install.sh"
readonly CLAUDE_TARGET_BIN="${HOME}/.local/bin/claude"

is_claude_installed() {
    cmd_exists "claude" || [[ -x "${CLAUDE_TARGET_BIN}" ]]
}

install_claude() {
    log_step "Installing Claude Code CLI via official installer..."
    install_from_script "Install Claude Code CLI" "${CLAUDE_INSTALLER_URL}"
}

main() {
    log_info "Checking Claude Code CLI installation"

    if is_claude_installed; then
        log_skip "Claude Code CLI is already installed."
        return 0
    fi

    install_claude
    log_ok "Claude Code CLI installed successfully."
}

main "$@"
