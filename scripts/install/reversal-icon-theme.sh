#!/usr/bin/env bash
# @id: install/reversal-icon-theme
# @name: Reversal Icon Theme
# @order: 30
# @depends: install/gnome-tools

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly REVERSAL_REPO_URL="https://github.com/gauloish/reversal-icon-theme.git"
readonly ICONS_BASE_DIR="${HOME}/.local/share/icons"
readonly THEME_VARIANT="black"
readonly THEME_NAME="Reversal-${THEME_VARIANT}"

is_theme_installed() {
    [[ -d "${ICONS_BASE_DIR}/${THEME_NAME}" && -d "${ICONS_BASE_DIR}/${THEME_NAME}-dark" ]]
}

ensure_git() {
    if ! cmd_exists "git"; then
        log_step "Ensuring git is installed..."
        dnf_install "git"
    fi
}

install_reversal_icons() {
    local tmp_dir
    tmp_dir="$(mktemp -d)"

    log_step "Cloning Reversal icon theme repository..."
    if ! run_cmd "Clone ${REVERSAL_REPO_URL}" git clone --depth 1 "${REVERSAL_REPO_URL}" "${tmp_dir}/reversal-icon-theme"; then
        rm -rf "${tmp_dir}"
        return 1
    fi

    log_step "Running Reversal icon theme installer (-t ${THEME_VARIANT})..."
    local rc=0
    if run_cmd "Install Reversal (${THEME_VARIANT}) icon theme" \
        bash -c "cd '${tmp_dir}/reversal-icon-theme' && ./install.sh -t '${THEME_VARIANT}'"; then
        rc=0
    else
        rc=$?
    fi

    rm -rf "${tmp_dir}"
    return "${rc}"
}

main() {
    log_info "Checking ${THEME_NAME} icon theme installation"

    if is_theme_installed; then
        log_skip "${THEME_NAME} icon theme is already installed."
        return 0
    fi

    ensure_git
    install_reversal_icons
    log_ok "${THEME_NAME} icon theme installed successfully."
}

main "$@"
