#!/usr/bin/env bash
# @id: install/adw-gtk3
# @name: adw-gtk3 Theme for Legacy Applications
# @order: 31
# @depends: install/cli-utils

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly THEME_PACKAGE="adw-gtk3-theme"

is_adw_gtk3_installed() {
    rpm_is_installed "${THEME_PACKAGE}"
}

install_adw_gtk3() {
    log_step "Installing ${THEME_PACKAGE} via dnf..."
    dnf_install "${THEME_PACKAGE}"
}

main() {
    log_info "Checking ${THEME_PACKAGE} installation"

    if is_adw_gtk3_installed; then
        log_skip "${THEME_PACKAGE} is already installed."
        return 0
    fi

    install_adw_gtk3
    log_ok "${THEME_PACKAGE} installed successfully."
}

main "$@"
