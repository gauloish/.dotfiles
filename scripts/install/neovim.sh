#!/usr/bin/env bash
# @id: install/neovim
# @name: Neovim Editor
# @order: 20
# @depends: install/cli-utils, install/fonts

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly -a NEOVIM_PACKAGES=(
    "neovim"
    "python3-neovim"
)

is_neovim_installed() {
    local pkg
    for pkg in "${NEOVIM_PACKAGES[@]}"; do
        if ! rpm_is_installed "${pkg}"; then
            return 1
        fi
    done
    return 0
}

install_neovim() {
    log_step "Installing Neovim packages via dnf..."
    dnf_install "${NEOVIM_PACKAGES[@]}"
}

main() {
    log_info "Checking Neovim installation"

    if is_neovim_installed; then
        log_skip "Neovim is already installed."
        return 0
    fi

    install_neovim
    log_ok "Neovim installed successfully."
}

main "$@"
