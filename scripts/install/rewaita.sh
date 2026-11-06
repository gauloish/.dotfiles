#!/usr/bin/env bash
# @id: install/rewaita
# @name: Rewaita
# @order: 35
# @depends: install/gnome-tools

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly REWAITA_FLATPAK_ID="io.github.swordpuffin.rewaita"

is_rewaita_installed() {
    flatpak_is_installed "${REWAITA_FLATPAK_ID}"
}

install_rewaita() {
    log_step "Installing Rewaita (${REWAITA_FLATPAK_ID}) via Flatpak..."
    flatpak_install "${REWAITA_FLATPAK_ID}"
}

main() {
    log_info "Checking Rewaita installation"

    if is_rewaita_installed; then
        log_skip "Rewaita (${REWAITA_FLATPAK_ID}) is already installed."
        return 0
    fi

    install_rewaita
    log_ok "Rewaita installed successfully."
}

main "$@"
