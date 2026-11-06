#!/usr/bin/env bash
# @id: configure/gnome-tools
# @name: GNOME User Theme Extension
# @order: 20
# @depends: install/gnome-tools

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly USER_THEME_UUID="user-theme@gnome-shell-extensions.gcampax.github.com"

is_user_theme_enabled() {
    if ! cmd_exists "gnome-extensions"; then
        return 1
    fi

    gnome-extensions list --enabled 2>/dev/null | grep -qx "${USER_THEME_UUID}"
}

enable_user_theme_extension() {
    log_step "Enabling GNOME Shell extension '${USER_THEME_UUID}'..."
    run_cmd "Enable User Themes extension" \
        gnome-extensions enable "${USER_THEME_UUID}"
}

main() {
    log_info "Checking GNOME User Theme extension status"

    if is_user_theme_enabled; then
        log_skip "GNOME User Theme extension (${USER_THEME_UUID}) is already enabled."
        return 0
    fi

    enable_user_theme_extension
    log_ok "GNOME User Theme extension enabled successfully."
}

main "$@"
