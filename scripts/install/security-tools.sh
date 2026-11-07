#!/usr/bin/env bash
# @id: install/security-tools
# @name: Security and Vulnerability Scanning Tools
# @order: 50
# @depends: install/cli-utils

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly -a SECURITY_PACKAGES=(
    "gitleaks"
    "trivy"
)

are_security_tools_installed() {
    local pkg
    for pkg in "${SECURITY_PACKAGES[@]}"; do
        if ! rpm_is_installed "${pkg}"; then
            return 1
        fi
    done
    return 0
}

install_security_tools() {
    log_step "Installing security tools via dnf..."
    dnf_install "${SECURITY_PACKAGES[@]}"
}

main() {
    log_info "Checking security and vulnerability tools installation"

    if are_security_tools_installed; then
        log_skip "All security tools are already installed."
        return 0
    fi

    install_security_tools
    log_ok "Security tools installed successfully."
}

main "$@"
