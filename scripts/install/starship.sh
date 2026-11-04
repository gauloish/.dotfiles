#!/usr/bin/env bash
# @id: install/starship
# @name: Starship Prompt
# @order: 25

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly STARSHIP_COPR_REPO="atim/starship"
readonly STARSHIP_PACKAGE="starship"

is_starship_installed() {
    rpm_is_installed "${STARSHIP_PACKAGE}"
}

enable_starship_copr() {
    log_step "Enabling COPR repository: ${STARSHIP_COPR_REPO}..."
    dnf_enable_copr "${STARSHIP_COPR_REPO}"
}

install_starship() {
    log_step "Installing ${STARSHIP_PACKAGE} package via dnf..."
    dnf_install "${STARSHIP_PACKAGE}"
}

main() {
    log_info "Checking ${STARSHIP_PACKAGE} installation"

    if is_starship_installed; then
        log_skip "${STARSHIP_PACKAGE} is already installed."
        return 0
    fi

    enable_starship_copr
    install_starship
    log_ok "${STARSHIP_PACKAGE} installed successfully."
}

main "$@"
