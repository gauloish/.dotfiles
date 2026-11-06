#!/usr/bin/env bash
# @id: install/vscode
# @name: Visual Studio Code
# @order: 22
# @depends: install/cli-utils, install/fonts

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly VSCODE_PACKAGE="code"
readonly VSCODE_REPO_FILE="/etc/yum.repos.d/vscode.repo"
readonly VSCODE_GPG_KEY="https://packages.microsoft.com/keys/microsoft.asc"
readonly VSCODE_BASEURL="https://packages.microsoft.com/yumrepos/vscode"

is_vscode_installed() {
    rpm_is_installed "${VSCODE_PACKAGE}"
}

ensure_vscode_repo() {
    if [[ -f "${VSCODE_REPO_FILE}" ]]; then
        log_info "Visual Studio Code repository is already configured: ${VSCODE_REPO_FILE}"
        return 0
    fi

    log_step "Importing Microsoft GPG key..."
    run_cmd "Import Microsoft GPG key" \
        sudo rpm --import "${VSCODE_GPG_KEY}"

    log_step "Configuring Visual Studio Code repository (${VSCODE_REPO_FILE})..."
    run_cmd "Write ${VSCODE_REPO_FILE}" \
        sudo bash -c "printf '[code]\nname=Visual Studio Code\nbaseurl=${VSCODE_BASEURL}\nenabled=1\ngpgcheck=1\ngpgkey=${VSCODE_GPG_KEY}\n' > '${VSCODE_REPO_FILE}'"
}

install_vscode() {
    log_step "Installing ${VSCODE_PACKAGE} package via dnf..."
    dnf_install "${VSCODE_PACKAGE}"
}

main() {
    log_info "Checking Visual Studio Code installation"

    if is_vscode_installed; then
        log_skip "Visual Studio Code (${VSCODE_PACKAGE}) is already installed."
        return 0
    fi

    ensure_vscode_repo
    install_vscode
    log_ok "Visual Studio Code installed successfully."
}

main "$@"
