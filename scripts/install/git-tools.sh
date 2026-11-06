#!/usr/bin/env bash
# @id: install/git-tools
# @name: Git CLI and TUI Tools
# @order: 55
# @depends: install/cli-utils

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly -a GIT_RPM_PACKAGES=(
    "gh"
    "git-delta"
    "meld"
)

readonly LAZYGIT_COPR_REPO="atim/lazygit"
readonly LAZYGIT_PACKAGE="lazygit"

are_git_rpm_packages_installed() {
    local pkg
    for pkg in "${GIT_RPM_PACKAGES[@]}"; do
        if ! rpm_is_installed "${pkg}"; then
            return 1
        fi
    done
    return 0
}

is_lazygit_installed() {
    rpm_is_installed "${LAZYGIT_PACKAGE}"
}

are_all_git_tools_installed() {
    are_git_rpm_packages_installed && is_lazygit_installed
}

install_git_rpm_packages() {
    log_step "Installing Git tools packages via dnf..."
    dnf_install "${GIT_RPM_PACKAGES[@]}"
}

install_lazygit() {
    if is_lazygit_installed; then
        log_info "${LAZYGIT_PACKAGE} is already installed."
        return 0
    fi

    log_step "Enabling COPR repository: ${LAZYGIT_COPR_REPO}..."
    dnf_enable_copr "${LAZYGIT_COPR_REPO}"

    log_step "Installing ${LAZYGIT_PACKAGE} via dnf..."
    dnf_install "${LAZYGIT_PACKAGE}"
}

main() {
    log_info "Checking Git tools installation"

    if are_all_git_tools_installed; then
        log_skip "All Git tools are already installed."
        return 0
    fi

    install_git_rpm_packages
    install_lazygit
    log_ok "Git tools installed successfully."
}

main "$@"
