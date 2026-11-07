#!/usr/bin/env bash
# @id: install/gnome-web
# @name: GNOME Web Browser
# @order: 21

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly GNOME_WEB_PACKAGE="epiphany"

is_gnome_web_installed() {
    rpm_is_installed "${GNOME_WEB_PACKAGE}"
}

install_gnome_web() {
    log_step "Installing GNOME Web (${GNOME_WEB_PACKAGE}) via dnf..."
    dnf_install "${GNOME_WEB_PACKAGE}"
}

main() {
    log_info "Checking GNOME Web (${GNOME_WEB_PACKAGE}) installation"

    if is_gnome_web_installed; then
        log_skip "GNOME Web (${GNOME_WEB_PACKAGE}) is already installed."
        return 0
    fi

    install_gnome_web
    log_ok "GNOME Web installed successfully."
}

main "$@"
