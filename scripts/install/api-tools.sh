#!/usr/bin/env bash
# @id: install/api-tools
# @name: API Testing and Load Generation Tools
# @order: 52
# @depends: install/cli-utils

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly XH_COPR_REPO="ducaale/xh"
readonly XH_PACKAGE="xh"
readonly OHA_BINARY_URL="https://github.com/hatoo/oha/releases/latest/download/oha-linux-amd64"
readonly USER_BIN_DIR="${HOME}/.local/bin"
readonly OHA_TARGET_FILE="${USER_BIN_DIR}/oha"

is_xh_installed() {
    rpm_is_installed "${XH_PACKAGE}"
}

is_oha_installed() {
    cmd_exists "oha" || [[ -x "${OHA_TARGET_FILE}" ]]
}

are_all_api_tools_installed() {
    is_xh_installed && is_oha_installed
}

install_xh() {
    if is_xh_installed; then
        log_info "${XH_PACKAGE} is already installed."
        return 0
    fi

    log_step "Enabling COPR repository: ${XH_COPR_REPO}..."
    dnf_enable_copr "${XH_COPR_REPO}"

    log_step "Installing ${XH_PACKAGE} via dnf..."
    dnf_install "${XH_PACKAGE}"
}

install_oha() {
    if is_oha_installed; then
        log_info "oha load generator is already installed."
        return 0
    fi

    log_step "Installing oha binary to ${OHA_TARGET_FILE}..."
    mkdir -p "${USER_BIN_DIR}"

    local tmp_bin
    tmp_bin="$(mktemp)"

    if ! run_cmd "Download oha binary from GitHub releases" \
        curl -fsSL "${OHA_BINARY_URL}" -o "${tmp_bin}"; then
        rm -f "${tmp_bin}"
        return 1
    fi

    chmod +x "${tmp_bin}"
    mv -f "${tmp_bin}" "${OHA_TARGET_FILE}"
    log_ok "oha installed to ${OHA_TARGET_FILE}."
}

main() {
    log_info "Checking API testing and load generation tools installation"

    if are_all_api_tools_installed; then
        log_skip "All API tools are already installed."
        return 0
    fi

    install_xh
    install_oha
    log_ok "API testing and load generation tools installed successfully."
}

main "$@"
