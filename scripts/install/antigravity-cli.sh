#!/usr/bin/env bash
# @id: install/antigravity-cli
# @name: Google Antigravity CLI
# @order: 60
# @depends: install/cli-utils

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly ANTIGRAVITY_INSTALLER_URL="https://antigravity.google/cli/install.sh"
readonly ANTIGRAVITY_TARGET_BIN="${HOME}/.local/bin/agy"

is_antigravity_installed() {
    cmd_exists "agy" || [[ -x "${ANTIGRAVITY_TARGET_BIN}" ]]
}

install_antigravity() {
    log_step "Installing Antigravity CLI via official installer..."
    install_from_script "Install Antigravity CLI" "${ANTIGRAVITY_INSTALLER_URL}"
}

main() {
    log_info "Checking Antigravity CLI installation"

    if is_antigravity_installed; then
        log_skip "Antigravity CLI (agy) is already installed."
        return 0
    fi

    install_antigravity
    log_ok "Antigravity CLI installed successfully."
}

main "$@"
