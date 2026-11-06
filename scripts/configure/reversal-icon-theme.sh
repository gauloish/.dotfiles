#!/usr/bin/env bash
# @id: configure/reversal-icon-theme
# @name: Reversal Icon Theme Configuration
# @order: 30
# @depends: install/reversal-icon-theme

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly GNOME_INTERFACE_SCHEMA="org.gnome.desktop.interface"
readonly ICON_THEME_KEY="icon-theme"
readonly TARGET_ICON_THEME="Reversal-black"

is_icon_theme_configured() {
    if ! cmd_exists "gsettings"; then
        return 1
    fi

    local current_theme
    current_theme="$(gsettings get "${GNOME_INTERFACE_SCHEMA}" "${ICON_THEME_KEY}" 2>/dev/null | tr -d "'" || true)"
    [[ "${current_theme}" == "${TARGET_ICON_THEME}" ]]
}

apply_icon_theme() {
    log_step "Applying GNOME icon theme '${TARGET_ICON_THEME}'..."
    run_cmd "Set GNOME icon-theme to ${TARGET_ICON_THEME}" \
        gsettings set "${GNOME_INTERFACE_SCHEMA}" "${ICON_THEME_KEY}" "${TARGET_ICON_THEME}"
}

main() {
    log_info "Checking GNOME icon theme configuration"

    if is_icon_theme_configured; then
        log_skip "GNOME icon theme is already set to ${TARGET_ICON_THEME}."
        return 0
    fi

    apply_icon_theme
    log_ok "GNOME icon theme configured to ${TARGET_ICON_THEME}."
}

main "$@"
