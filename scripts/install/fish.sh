#!/usr/bin/env bash
# @id: install/fish
# @name: Fish Shell
# @order: 15

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly FISH_PACKAGE="fish"

is_fish_installed() {
    rpm_is_installed "${FISH_PACKAGE}"
}

install_fish() {
    log_step "Installing ${FISH_PACKAGE} package via dnf..."
    dnf_install "${FISH_PACKAGE}"
}

main() {
    log_info "Checking ${FISH_PACKAGE} installation"

    if is_fish_installed; then
        log_skip "${FISH_PACKAGE} is already installed."
        return 0
    fi

    install_fish
    log_ok "${FISH_PACKAGE} installed successfully."
}

main "$@"
