#!/usr/bin/env bash
# @id: configure/adw-gtk3
# @name: adw-gtk3 Legacy Theme Configuration
# @order: 32
# @depends: install/adw-gtk3

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly GNOME_INTERFACE_SCHEMA="org.gnome.desktop.interface"
readonly GTK_THEME_KEY="gtk-theme"
readonly TARGET_THEME="adw-gtk3-dark"

is_gtk_theme_configured() {
    if ! cmd_exists "gsettings"; then
        return 1
    fi

    local current_theme
    current_theme="$(gsettings get "${GNOME_INTERFACE_SCHEMA}" "${GTK_THEME_KEY}" 2>/dev/null | tr -d "'" || true)"
    [[ "${current_theme}" == "${TARGET_THEME}" ]]
}

apply_gtk_theme() {
    log_step "Applying GNOME legacy applications theme '${TARGET_THEME}'..."
    run_cmd "Set GNOME gtk-theme to ${TARGET_THEME}" \
        gsettings set "${GNOME_INTERFACE_SCHEMA}" "${GTK_THEME_KEY}" "${TARGET_THEME}"
}

main() {
    log_info "Checking GNOME legacy applications GTK theme"

    if is_gtk_theme_configured; then
        log_skip "GNOME legacy applications theme is already set to ${TARGET_THEME}."
        return 0
    fi

    apply_gtk_theme
    log_ok "GNOME legacy applications theme configured to ${TARGET_THEME}."
}

main "$@"
