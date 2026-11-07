#!/usr/bin/env bash
# @id: install/gnome-boxes
# @name: GNOME Boxes
# @order: 48
# @depends: install/cli-utils

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly GNOME_BOXES_PACKAGE="gnome-boxes"

is_gnome_boxes_installed() {
    rpm_is_installed "${GNOME_BOXES_PACKAGE}"
}

install_gnome_boxes() {
    log_step "Installing GNOME Boxes via dnf..."
    dnf_install "${GNOME_BOXES_PACKAGE}"
}

main() {
    log_info "Checking GNOME Boxes installation"

    if is_gnome_boxes_installed; then
        log_skip "GNOME Boxes is already installed."
        return 0
    fi

    install_gnome_boxes
    log_ok "GNOME Boxes installed successfully."
}

main "$@"
