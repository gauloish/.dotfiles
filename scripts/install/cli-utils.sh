#!/usr/bin/env bash
# @id: install/cli-utils
# @name: Essential CLI Utilities
# @order: 05

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly -a CLI_PACKAGES=(
    "git"
    "curl"
    "wget2-wget"
    "dnf-plugins-core"
    "tar"
    "zip"
    "unzip"
    "gzip"
    "bzip2"
    "xz"
    "zstd"
    "p7zip"
    "p7zip-plugins"
    "ripgrep"
    "fd-find"
    "fzf"
    "bat"
    "jq"
    "tree"
    "btop"
    "fastfetch"
    "wl-clipboard"
)

are_all_cli_utils_installed() {
    local pkg
    for pkg in "${CLI_PACKAGES[@]}"; do
        if ! rpm_is_installed "${pkg}"; then
            return 1
        fi
    done
    return 0
}

install_cli_utils() {
    log_step "Installing essential CLI utilities via dnf..."
    dnf_install "${CLI_PACKAGES[@]}"
}

main() {
    log_info "Checking essential CLI utilities installation"

    if are_all_cli_utils_installed; then
        log_skip "All essential CLI utilities are already installed."
        return 0
    fi

    install_cli_utils
    log_ok "Essential CLI utilities installed successfully."
}

main "$@"
