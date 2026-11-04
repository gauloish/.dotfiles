#!/usr/bin/env bash
# @id: install/brave-origin
# @name: Brave Origin Browser
# @order: 20

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly BRAVE_REPO_URL="https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo"
readonly BRAVE_REPO_FILE="/etc/yum.repos.d/brave-browser.repo"
readonly BRAVE_PACKAGE="brave-origin"

is_brave_installed() {
    rpm_is_installed "${BRAVE_PACKAGE}"
}

ensure_dnf_plugins() {
    log_step "Ensuring dnf-plugins-core is installed..."
    dnf_install "dnf-plugins-core"
}

ensure_brave_repo() {
    if [[ -f "${BRAVE_REPO_FILE}" ]]; then
        log_info "Brave repository is already configured: ${BRAVE_REPO_FILE}"
        return 0
    fi

    log_step "Adding Brave repository..."
    run_cmd "Add Brave repository via dnf config-manager" \
        sudo dnf config-manager addrepo --from-repofile="${BRAVE_REPO_URL}"
}

install_brave() {
    log_step "Installing ${BRAVE_PACKAGE} package..."
    dnf_install "${BRAVE_PACKAGE}"
}

main() {
    log_info "Checking ${BRAVE_PACKAGE} installation"

    if is_brave_installed; then
        log_skip "${BRAVE_PACKAGE} is already installed."
        return 0
    fi

    ensure_dnf_plugins
    ensure_brave_repo
    install_brave
    log_ok "${BRAVE_PACKAGE} installed successfully."
}

main "$@"
