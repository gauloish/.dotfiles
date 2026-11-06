#!/usr/bin/env bash
# @id: install/gnome-tools
# @name: GNOME Customization Tools
# @order: 28

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly GNOME_PACKAGES="gnome-tweaks gnome-extensions-app gnome-shell-extension-user-theme"

are_gnome_tools_installed() {
    local pkg
    for pkg in ${GNOME_PACKAGES}; do
        if ! rpm_is_installed "${pkg}"; then
            return 1
        fi
    done
    return 0
}

install_gnome_tools() {
    local pkgs=()
    read -r -a pkgs <<< "${GNOME_PACKAGES}"

    log_step "Installing GNOME customization packages via dnf..."
    dnf_install "${pkgs[@]}"
}

main() {
    log_info "Checking GNOME customization tools installation"

    if are_gnome_tools_installed; then
        log_skip "GNOME customization tools are already installed."
        return 0
    fi

    install_gnome_tools
    log_ok "GNOME customization tools installed successfully."
}

main "$@"
