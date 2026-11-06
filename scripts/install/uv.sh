#!/usr/bin/env bash
# @id: install/uv
# @name: Python and uv Package Manager
# @order: 40

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly -a PYTHON_UV_PACKAGES=(
    "python3"
    "uv"
)

are_python_and_uv_installed() {
    local pkg
    for pkg in "${PYTHON_UV_PACKAGES[@]}"; do
        if ! rpm_is_installed "${pkg}"; then
            return 1
        fi
    done
    return 0
}

install_python_and_uv() {
    log_step "Installing Python 3 and uv via dnf..."
    dnf_install "${PYTHON_UV_PACKAGES[@]}"
}

main() {
    log_info "Checking Python 3 and uv installation"

    if are_python_and_uv_installed; then
        log_skip "Python 3 and uv are already installed."
        return 0
    fi

    install_python_and_uv
    log_ok "Python 3 and uv installed successfully."
}

main "$@"
