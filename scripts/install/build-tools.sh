#!/usr/bin/env bash
# @id: install/build-tools
# @name: Build Tools and Development Headers
# @order: 06

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly -a BUILD_TOOLS_PACKAGES=(
    "gcc"
    "gcc-c++"
    "make"
    "cmake"
    "pkgconf-pkg-config"
    "python3-devel"
    "libpq-devel"
    "openssl-devel"
    "sqlite"
)

are_build_tools_installed() {
    local pkg
    for pkg in "${BUILD_TOOLS_PACKAGES[@]}"; do
        if ! rpm_is_installed "${pkg}"; then
            return 1
        fi
    done
    return 0
}

install_build_tools() {
    log_step "Installing build tools and development headers via dnf..."
    dnf_install "${BUILD_TOOLS_PACKAGES[@]}"
}

main() {
    log_info "Checking build tools and development headers installation"

    if are_build_tools_installed; then
        log_skip "All build tools and development headers are already installed."
        return 0
    fi

    install_build_tools
    log_ok "Build tools and development headers installed successfully."
}

main "$@"
