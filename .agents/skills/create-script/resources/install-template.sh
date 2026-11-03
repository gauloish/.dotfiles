#!/usr/bin/env bash
# @id: install/example
# @name: Example Package
# @order: 50
# @depends: install/curl

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

is_installed() {
    cmd_exists "example"
}

install_example() {
    log_step "Installing example package..."
    # Use dnf_install, flatpak_install, install_from_script, or run_cmd
    dnf_install "example"
}

main() {
    log_info "Checking Example Package installation"

    if is_installed; then
        log_skip "Example Package is already installed."
        return 0
    fi

    install_example
    log_ok "Example Package installed successfully."
}

main "$@"
