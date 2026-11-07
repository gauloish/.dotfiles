#!/usr/bin/env bash
# @id: install/dnf-automatic
# @name: DNF Automatic Updates
# @order: 08

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly DNF_AUTOMATIC_PACKAGE="dnf5-plugin-automatic"

is_dnf_automatic_installed() {
    rpm_is_installed "${DNF_AUTOMATIC_PACKAGE}"
}

install_dnf_automatic() {
    log_step "Installing ${DNF_AUTOMATIC_PACKAGE} package via dnf..."
    dnf_install "${DNF_AUTOMATIC_PACKAGE}"
}

main() {
    log_info "Checking ${DNF_AUTOMATIC_PACKAGE} installation"

    if is_dnf_automatic_installed; then
        log_skip "${DNF_AUTOMATIC_PACKAGE} is already installed."
        return 0
    fi

    install_dnf_automatic
    log_ok "${DNF_AUTOMATIC_PACKAGE} installed successfully."
}

main "$@"
